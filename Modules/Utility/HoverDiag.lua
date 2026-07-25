---@class DragonflightUI
---@diagnostic disable-next-line: assign-type-mismatch
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

-- Hover-lag diagnostic (/df hoverlag) for the "frame drops when hovering
-- raid members" reports. v2: the first field run showed the lag can be
-- sustained 30-80ms frames rather than single >90ms spikes, so besides
-- spike lines this now records a per-second aggregate (fps, avg/worst
-- frame time) split into hovering vs not-hovering seconds, plus call
-- counts and measured milliseconds for every DragonflightUI hover-path
-- entry point (tooltip anchor hook, unit-tooltip styling, statusbar
-- updates, frame resize). The stop summary directly compares hover
-- seconds against baseline seconds - if hovering is no slower than
-- baseline, the lag is not hover-tied; if it is slower and the DFUI
-- columns stay near zero, another addon (or the client) owns the cost.
-- /df hoverlag report opens a copyable log to paste into an issue.
--
-- Everything here is hooksecurefunc/method-wrap/OnUpdate based - no
-- secure paths are touched, and the wraps are inert (single boolean
-- check) while the diagnostic is off.
local Diag = {}
DF.HoverDiag = Diag

local AUTO_STOP_SECONDS = 900 -- don't let users leave it running forever
local MAX_LINES = 600
local SPIKE_SECONDS = 0.09
local SLOW_FRAME = 1 / 30 -- frames longer than this count as degraded

local active = false
local hooksInstalled = false
local startedAt = 0
local lines = {}

-- session totals
local spikes, worstMs = 0, 0
local hoverMs, hoverFrames, baseMs, baseFrames = 0, 0, 0, 0

-- current second aggregate
local sec = {}
-- current/previous frame flags (the elapsed reflecting a frame's cost
-- arrives in the NEXT frame's OnUpdate)
local cur = {}
local prev = {}

local function resetCounters(t)
    t.setUnit = false
    t.ttMs, t.ttN = 0, 0
    t.anchorN = 0
    t.sbMs, t.sbN = 0, 0
    t.fsMs, t.fsN = 0, 0
    t.bdMs, t.bdN = 0, 0
    t.anMs, t.anN = 0, 0
end
resetCounters(cur)
resetCounters(prev)

local function resetSecond()
    sec.frames = 0
    sec.sum = 0
    sec.worst = 0
    sec.over33 = 0
    sec.hover = false
    sec.ttMs, sec.ttN = 0, 0
    sec.anchorN = 0
    sec.sbMs, sec.sbN = 0, 0
    sec.fsMs, sec.fsN = 0, 0
    sec.bdMs, sec.bdN = 0, 0
    sec.anMs, sec.anN = 0, 0
    sec.builds = 0
    -- allocation split: churn on frames where DFUI tooltip code ran vs
    -- frames where it did not. A per-frame tooltip scanner (OnUpdate hooks
    -- in other addons) allocates on EVERY frame while a tooltip shows;
    -- DFUI only runs on build/anchor events.
    sec.heapBuildKb, sec.heapBuildN = 0, 0
    sec.heapIdleKb, sec.heapIdleN = 0, 0
end
resetSecond()

local watch = CreateFrame('Frame')

local function chat(msg)
    print('|cffff8800DFUI hoverlag:|r ' .. msg)
end

local function addLine(line)
    if #lines >= MAX_LINES then table.remove(lines, 1) end
    lines[#lines + 1] = line
end

-- wrap a module method with a timer that feeds (msKey, nKey) on `cur`
local function wrapTimed(owner, methodName, msKey, nKey)
    local orig = owner[methodName]
    if type(orig) ~= 'function' then return end
    owner[methodName] = function(...)
        if not active then return orig(...) end
        local t0 = debugprofilestop()
        local r1, r2 = orig(...)
        cur[msKey] = cur[msKey] + (debugprofilestop() - t0)
        cur[nKey] = cur[nKey] + 1
        return r1, r2
    end
end

local function installHooks()
    if hooksInstalled then return end
    hooksInstalled = true

    hooksecurefunc(GameTooltip, 'SetUnit', function(_, unit)
        if active then cur.setUnit = unit or '?' end
    end)

    hooksecurefunc('GameTooltip_SetDefaultAnchor', function()
        if active then cur.anchorN = cur.anchorN + 1 end
    end)

    local tooltipModule = DF:GetModule('Tooltip', true)
    if tooltipModule then
        wrapTimed(tooltipModule, 'OnTooltipSetUnit', 'ttMs', 'ttN')
        wrapTimed(tooltipModule, 'UpdateStatusbar', 'sbMs', 'sbN')
        wrapTimed(tooltipModule, 'UpdateFrameSize', 'fsMs', 'fsN')
        -- v4: also time the backdrop reapply (runs from the OnTooltipCleared
        -- hook, previously invisible) and the anchor hook body itself
        wrapTimed(tooltipModule, 'SetDefaultBackdrop', 'bdMs', 'bdN')
        wrapTimed(tooltipModule, 'GameTooltipSetDefaultAnchor', 'anMs', 'anN')
    end
end

local function moduleStates()
    local enabled, disabled = {}, {}
    for name, module in DF:IterateModules() do
        if module.IsEnabled and module:IsEnabled() then
            enabled[#enabled + 1] = name
        else
            disabled[#disabled + 1] = name
        end
    end
    table.sort(enabled)
    table.sort(disabled)
    return table.concat(enabled, ','), table.concat(disabled, ',')
end

local function header()
    local version = (C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata)('DragonflightUI', 'Version')
    local _, build = GetBuildInfo()
    local _, class = UnitClass('player')
    local profile = (DF.db and DF.db.GetCurrentProfile and DF.db:GetCurrentProfile()) or '?'
    local enabled, disabled = moduleStates()
    return string.format(
               'DragonflightUI hover-lag log v5 | v%s | client build %s | %s | class %s | lvl %d | profile %s | started %s\nmodules ON: %s\nmodules OFF: %s',
               tostring(version), tostring(build), IsInRaid() and 'raid' or (IsInGroup() and 'party' or 'solo'),
               tostring(class), UnitLevel('player') or 0, tostring(profile), date('%Y-%m-%d %H:%M:%S'), enabled,
               disabled == '' and '-' or disabled)
end

local lastMemKb = nil
local lastFrameHeap = nil

local function flushSecond()
    if sec.frames == 0 then
        resetSecond()
        return
    end
    local avg = sec.sum / sec.frames * 1000
    local fps = sec.frames / sec.sum

    if sec.hover then
        hoverMs = hoverMs + sec.sum * 1000
        hoverFrames = hoverFrames + sec.frames
    else
        baseMs = baseMs + sec.sum * 1000
        baseFrames = baseFrames + sec.frames
    end

    -- heap delta reveals per-hover allocation churn. v3 used
    -- UpdateAddOnMemoryUsage here, which itself costs tens of ms with a
    -- full addon list and poisoned worst/over33 with a once-per-second
    -- hitch of our own making; collectgarbage('count') is near-free.
    local memKb = collectgarbage('count')
    local memDelta = lastMemKb and (memKb - lastMemKb) or 0
    lastMemKb = memKb

    -- log every second; only degraded seconds go to chat
    local line = string.format(
                     '%s fps=%.0f avg=%.0fms worst=%.0fms over33ms=%d hover=%s builds=%d dfuiTT=%.1fms(%d) anchorHook=%.1fms(%d/%d) backdrop=%.1fms(%d) statusbar=%.1fms(%d) resize=%.1fms(%d) heap=%+dkb allocOnDfuiFrames=%dkb(%d) allocOnOtherFrames=%dkb(%d)',
                     date('%H:%M:%S'), fps, avg, sec.worst * 1000, sec.over33, sec.hover and 'YES' or 'no', sec.builds,
                     sec.ttMs, sec.ttN, sec.anMs, sec.anN, sec.anchorN, sec.bdMs, sec.bdN, sec.sbMs, sec.sbN, sec.fsMs,
                     sec.fsN, memDelta, sec.heapBuildKb, sec.heapBuildN, sec.heapIdleKb, sec.heapIdleN)
    addLine(line)
    if avg > SLOW_FRAME * 1000 then chat(line) end
    resetSecond()
end

local lastSecond = 0

watch:SetScript('OnUpdate', function(_, elapsed)
    if not active then return end
    if GetTime() - startedAt > AUTO_STOP_SECONDS then
        Diag:Stop(true)
        return
    end

    -- fold the finished frame (prev flags belong to it) into the second
    if elapsed < 5 then -- ignore loading screens
        sec.frames = sec.frames + 1
        sec.sum = sec.sum + elapsed
        if elapsed > sec.worst then sec.worst = elapsed end
        if elapsed > SLOW_FRAME then sec.over33 = sec.over33 + 1 end
        if prev.setUnit then sec.builds = sec.builds + 1 end
        sec.ttMs, sec.ttN = sec.ttMs + prev.ttMs, sec.ttN + prev.ttN
        sec.anchorN = sec.anchorN + prev.anchorN
        sec.sbMs, sec.sbN = sec.sbMs + prev.sbMs, sec.sbN + prev.sbN
        sec.fsMs, sec.fsN = sec.fsMs + prev.fsMs, sec.fsN + prev.fsN
        sec.bdMs, sec.bdN = sec.bdMs + prev.bdMs, sec.bdN + prev.bdN
        sec.anMs, sec.anN = sec.anMs + prev.anMs, sec.anN + prev.anN
        if UnitExists('mouseover') then sec.hover = true end

        -- attribute allocation churn: positive heap deltas on frames where
        -- DFUI tooltip code ran vs frames where it did not (GC reclaims
        -- show as negative deltas and are skipped)
        local heapNow = collectgarbage('count')
        if lastFrameHeap then
            local d = heapNow - lastFrameHeap
            if d > 0 then
                local dfuiRan = prev.anN > 0 or prev.ttN > 0 or prev.bdN > 0
                if dfuiRan then
                    sec.heapBuildKb = sec.heapBuildKb + d
                    sec.heapBuildN = sec.heapBuildN + 1
                else
                    sec.heapIdleKb = sec.heapIdleKb + d
                    sec.heapIdleN = sec.heapIdleN + 1
                end
            end
        end
        lastFrameHeap = heapNow

        if elapsed > SPIKE_SECONDS then
            spikes = spikes + 1
            if elapsed * 1000 > worstMs then worstMs = elapsed * 1000 end
            local mo = UnitExists('mouseover') and (UnitName('mouseover') or '?') or '-'
            addLine(string.format('%s SPIKE %dms build=%s dfuiTT=%.1fms mouseover=%s', date('%H:%M:%S'),
                                  elapsed * 1000, tostring(prev.setUnit), prev.ttMs, mo))
        end
    end

    local now = math.floor(GetTime())
    if now ~= lastSecond then
        lastSecond = now
        flushSecond()
    end

    prev, cur = cur, prev
    resetCounters(cur)
end)

function Diag:Start()
    if active then return end
    installHooks()
    active = true
    startedAt = GetTime()
    lastSecond = math.floor(GetTime())
    lines = {header()}
    spikes, worstMs = 0, 0
    hoverMs, hoverFrames, baseMs, baseFrames = 0, 0, 0, 0
    lastMemKb = nil
    lastFrameHeap = nil
    resetSecond()
    resetCounters(cur)
    resetCounters(prev)
    chat('recording - reproduce the lag now (hover raid members/frames for a while, then look away for a while too).')
    chat('|cffffffff/df hoverlag|r stops, |cffffffff/df hoverlag report|r opens a copyable log.')
end

function Diag:Stop(auto)
    if not active then return end
    active = false
    flushSecond()

    local hoverAvg = hoverFrames > 0 and (hoverMs / hoverFrames) or 0
    local baseAvg = baseFrames > 0 and (baseMs / baseFrames) or 0
    local summary = string.format(
                        'stopped%s: hovering avg %.0fms/frame (%d frames) vs baseline %.0fms/frame (%d frames); %d spikes >90ms, worst %dms',
                        auto and ' (auto, 15min)' or '', hoverAvg, hoverFrames, baseAvg, baseFrames, spikes, worstMs)
    addLine(summary)
    chat(summary)
    chat('|cffffffff/df hoverlag report|r opens the full log to copy into the issue.')

    -- keep the last session across /reload so the report survives
    if DF.db and DF.db.global then DF.db.global.hoverDiagLog = lines end
end

local function getWindow()
    if Diag.window then return Diag.window end

    local f = CreateFrame('Frame', 'DragonflightUIHoverDiagWindow', UIParent, 'BackdropTemplate')
    f:SetSize(620, 360)
    f:SetPoint('CENTER')
    f:SetFrameStrata('DIALOG')
    f:SetBackdrop({
        bgFile = 'Interface\\DialogFrame\\UI-DialogBox-Background',
        edgeFile = 'Interface\\Tooltips\\UI-Tooltip-Border',
        edgeSize = 12,
        insets = {left = 3, right = 3, top = 3, bottom = 3}
    })
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag('LeftButton')
    f:SetScript('OnDragStart', f.StartMoving)
    f:SetScript('OnDragStop', f.StopMovingOrSizing)

    local close = CreateFrame('Button', nil, f, 'UIPanelCloseButton')
    close:SetPoint('TOPRIGHT', 0, 0)

    local title = f:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    title:SetPoint('TOP', 0, -8)
    title:SetText('DragonflightUI hover-lag report - Ctrl+A, Ctrl+C to copy')

    local scroll = CreateFrame('ScrollFrame', nil, f, 'UIPanelScrollFrameTemplate')
    scroll:SetPoint('TOPLEFT', 12, -28)
    scroll:SetPoint('BOTTOMRIGHT', -32, 12)

    local edit = CreateFrame('EditBox', nil, scroll)
    edit:SetMultiLine(true)
    edit:SetFontObject(ChatFontNormal)
    edit:SetWidth(560)
    edit:SetAutoFocus(false)
    edit:SetScript('OnEscapePressed', function(self)
        self:ClearFocus()
        f:Hide()
    end)
    scroll:SetScrollChild(edit)
    f.edit = edit

    Diag.window = f
    return f
end

function Diag:Report()
    local log = (#lines > 1 and lines) or (DF.db and DF.db.global and DF.db.global.hoverDiagLog)
    if not log or #log == 0 then
        chat('no recorded session - run |cffffffff/df hoverlag|r first, reproduce the lag, then report.')
        return
    end
    local f = getWindow()
    f.edit:SetText(table.concat(log, '\n'))
    f:Show()
    f.edit:HighlightText()
    f.edit:SetFocus()
end

function Diag:Command(arg)
    arg = arg and arg:gsub('^%s+', ''):gsub('%s+$', ''):lower() or ''
    if arg == 'report' then
        Diag:Report()
    elseif arg == 'modules' then
        -- quick character-to-character comparison without a full session
        local profile = (DF.db and DF.db.GetCurrentProfile and DF.db:GetCurrentProfile()) or '?'
        local enabled, disabled = moduleStates()
        chat('profile: ' .. tostring(profile))
        chat('modules ON: ' .. enabled)
        chat('modules OFF: ' .. (disabled == '' and '-' or disabled))
    elseif arg == '' or arg == 'toggle' then
        if active then
            Diag:Stop()
        else
            Diag:Start()
        end
    else
        chat('usage: |cffffffff/df hoverlag|r (start/stop), |cffffffff/df hoverlag report|r (copyable log), |cffffffff/df hoverlag modules|r (module states)')
    end
end
