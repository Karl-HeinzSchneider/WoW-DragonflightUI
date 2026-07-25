---@class DragonflightUI
---@diagnostic disable-next-line: assign-type-mismatch
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

-- Hover-lag diagnostic (/df hoverlag). v6 goal: ONE run answers everything.
--
-- Per second it records fps, avg/worst frame time, call counts + measured ms
-- for every DragonflightUI tooltip surface, and Lua-heap allocation split
-- three ways: by whether DFUI tooltip code ran that frame, by what was under
-- the mouse (player / npc / nothing), and per unique unit crossed. The
-- single worst-allocating frame of each second is tagged with the unit that
-- was hovered. Every 5s an addon-memory probe (UpdateAddOnMemoryUsage)
-- snapshots per-addon deltas - that names the allocating addon directly,
-- no addon-disable testing needed; the probe's own cost is excluded from
-- the frame statistics. The stop summary aggregates all of it, including
-- the unattributed remainder (allocations belonging to the Blizzard UI /
-- client rather than any addon).
--
-- v7 adds the action-bar storm instrumentation: per-second counts of the
-- events that #showtooltip [@mouseover] macros make the client fire on
-- every mouseover change (SLOT_CHANGED / SPELL_UPDATE_ICON /
-- UPDATE_COOLDOWN / RANGE_CHECK / USABLE_CHANGED), and a census of how
-- many action buttons sit in Blizzard's central dispatchers (every one of
-- them runs a full Update/UpdateCooldown - several table allocations per
-- button - per global event). Together these prove or disprove the
-- "duplicated button population x mouseover macro re-resolution" theory.
--
-- Everything is hooksecurefunc/method-wrap/OnUpdate based - no secure paths
-- are touched, and the wraps are inert while the diagnostic is off.
local Diag = {}
DF.HoverDiag = Diag

local AUTO_STOP_SECONDS = 900
local MAX_LINES = 700
local SPIKE_SECONDS = 0.09
local SLOW_FRAME = 1 / 30
local ADDON_PROBE_INTERVAL = 5

local active = false
local hooksInstalled = false
local startedAt = 0
local lines = {}

-- session totals
local spikes, worstMs = 0, 0
local hoverMs, hoverFrames, baseMs, baseFrames = 0, 0, 0, 0
local sessAllocPlayer, sessAllocNpc, sessAllocNone = 0, 0, 0
local sessUnitsPlayer, sessUnitsNpc = 0, 0
local sessWorstAllocKb, sessWorstAllocUnit = 0, '-'
local sessAddonDelta = {} -- addon name -> accumulated positive kb growth
local sessAllocDfui, sessAllocOther = 0, 0

local sec = {}
local cur = {}
local prev = {}

-- action-bar event storm counters (v7) -----------------------------------
local EV_WATCH = {
    'UPDATE_MOUSEOVER_UNIT', 'ACTIONBAR_SLOT_CHANGED', 'SPELL_UPDATE_ICON', 'ACTIONBAR_UPDATE_COOLDOWN',
    'ACTION_RANGE_CHECK_UPDATE', 'ACTION_USABLE_CHANGED', 'ACTIONBAR_UPDATE_STATE'
}
local secEv, sessEv = {}, {}
local evFrame = CreateFrame('Frame')
evFrame:SetScript('OnEvent', function(_, event)
    secEv[event] = (secEv[event] or 0) + 1
    sessEv[event] = (sessEv[event] or 0) + 1
end)

local function evLine(t)
    return string.format('mo=%d slot=%d icon=%d cd=%d rng=%d usab=%d state=%d', t.UPDATE_MOUSEOVER_UNIT or 0,
                         t.ACTIONBAR_SLOT_CHANGED or 0, t.SPELL_UPDATE_ICON or 0, t.ACTIONBAR_UPDATE_COOLDOWN or 0,
                         t.ACTION_RANGE_CHECK_UPDATE or 0, t.ACTION_USABLE_CHANGED or 0, t.ACTIONBAR_UPDATE_STATE or 0)
end

local function countKeys(t)
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    return n
end

-- Census of Blizzard's central action-button dispatchers: every frame
-- listed there receives every dispatched event; buttons with actions run
-- the full Update/UpdateCooldown pipeline per event. Read-only.
local function actionbarCensus()
    local parts = {}
    local bef = _G['ActionBarButtonEventsFrame']
    if bef and bef.frames then
        local total, visible, dfui = 0, 0, 0
        for _, f in pairs(bef.frames) do
            total = total + 1
            if f.IsVisible and f:IsVisible() then visible = visible + 1 end
            local name = f.GetName and f:GetName()
            if name and name:find('DragonflightUI', 1, true) then dfui = dfui + 1 end
        end
        parts[#parts + 1] = string.format('buttonEvents=%d(%d visible,%d dfui)', total, visible, dfui)
    end
    local aef = _G['ActionBarActionEventsFrame']
    if aef and aef.frames then parts[#parts + 1] = 'actionEvents=' .. countKeys(aef.frames) end
    local rcf = _G['ActionBarButtonRangeCheckFrame']
    if rcf and rcf.actions then
        local acts, frames = 0, 0
        for _, t in pairs(rcf.actions) do
            acts = acts + 1
            frames = frames + countKeys(t)
        end
        parts[#parts + 1] = string.format('rangeTracked=%da/%df', acts, frames)
    end
    local uwf = _G['ActionBarButtonUsableWatcherFrame']
    if uwf and uwf.actions then
        local acts, frames = 0, 0
        for _, t in pairs(uwf.actions) do
            acts = acts + 1
            frames = frames + countKeys(t)
        end
        parts[#parts + 1] = string.format('usableWatched=%da/%df', acts, frames)
    end
    if GetNumMacros and GetMacroBody then
        local nGlobal, nChar = GetNumMacros()
        local mo, total = 0, 0
        local function scan(i)
            local b = GetMacroBody(i)
            if b then
                total = total + 1
                if b:lower():find('mouseover', 1, true) then mo = mo + 1 end
            end
        end
        for i = 1, (nGlobal or 0) do scan(i) end
        for i = 121, 120 + (nChar or 0) do scan(i) end
        parts[#parts + 1] = string.format('macros=%d(%d w/mouseover)', total, mo)
    end
    local mb5 = _G['MultiBar5Button1']
    if mb5 then
        parts[#parts + 1] = string.format('parkedMB5b1:id=%d,action=%s,vis=%s', mb5:GetID() or -1,
                                          tostring(mb5.action), tostring(mb5:IsVisible() and 1 or 0))
    end
    local abModule = DF.GetModule and DF:GetModule('Actionbar', true)
    local filterStats = abModule and abModule.SlotFilterStats
    if filterStats then
        parts[#parts + 1] = string.format('slotFilter:light=%d,full=%d', filterStats.spurious, filterStats.full)
    else
        parts[#parts + 1] = 'slotFilter:off'
    end
    return table.concat(parts, ' | ')
end

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
    sec.allocDfui, sec.allocDfuiN = 0, 0
    sec.allocOther, sec.allocOtherN = 0, 0
    sec.allocPlayer, sec.allocNpc, sec.allocNone = 0, 0, 0
    sec.unitsPlayer, sec.unitsNpc = 0, 0
    sec.worstAllocKb, sec.worstAllocUnit = 0, '-'
    sec.maxLines = 0
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

local GetNumAddOnsFn = (C_AddOns and C_AddOns.GetNumAddOns) or GetNumAddOns
local GetAddOnInfoFn = (C_AddOns and C_AddOns.GetAddOnInfo) or GetAddOnInfo

local function header()
    local version = (C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata)('DragonflightUI', 'Version')
    local _, build = GetBuildInfo()
    local _, class = UnitClass('player')
    local profile = (DF.db and DF.db.GetCurrentProfile and DF.db:GetCurrentProfile()) or '?'
    local enabled, disabled = moduleStates()
    local loadedAddons = {}
    for i = 1, GetNumAddOnsFn() do
        local name, _, _, loadable = GetAddOnInfoFn(i)
        if name and (C_AddOns and C_AddOns.IsAddOnLoaded or IsAddOnLoaded)(name) then
            loadedAddons[#loadedAddons + 1] = name
        end
    end
    table.sort(loadedAddons)
    return string.format(
               'DragonflightUI hover-lag log v7 | v%s | client build %s | %s | class %s | lvl %d | profile %s | started %s\nmodules ON: %s\nmodules OFF: %s\naddons loaded (%d): %s\nactionbars: %s',
               tostring(version), tostring(build), IsInRaid() and 'raid' or (IsInGroup() and 'party' or 'solo'),
               tostring(class), UnitLevel('player') or 0, tostring(profile), date('%Y-%m-%d %H:%M:%S'), enabled,
               disabled == '' and '-' or disabled, #loadedAddons, table.concat(loadedAddons, ','), actionbarCensus())
end

-- 5s addon-memory probe -------------------------------------------------
local lastAddonMem = nil
local lastProbeAt = 0
local skipStatsOnce = false

local function addonProbe()
    UpdateAddOnMemoryUsage()
    local now = {}
    local deltas = {}
    for i = 1, GetNumAddOnsFn() do
        local name = GetAddOnInfoFn(i)
        if name then
            local kb = GetAddOnMemoryUsage(name) or 0
            now[name] = kb
            if lastAddonMem and lastAddonMem[name] then
                local d = kb - lastAddonMem[name]
                if d > 50 then
                    deltas[#deltas + 1] = {name = name, d = d}
                    sessAddonDelta[name] = (sessAddonDelta[name] or 0) + d
                end
            end
        end
    end
    lastAddonMem = now
    if #deltas > 0 then
        table.sort(deltas, function(a, b) return a.d > b.d end)
        local parts = {}
        for i = 1, math.min(6, #deltas) do
            parts[#parts + 1] = string.format('%s %+dkb', deltas[i].name, deltas[i].d)
        end
        addLine(string.format('%s ADDONMEM(5s): %s', date('%H:%M:%S'), table.concat(parts, ', ')))
    end
    -- the probe itself is expensive; keep its frame out of the statistics
    skipStatsOnce = true
end

local lastFrameHeap = nil
local lastMoGuid = nil

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

    local line = string.format(
                     '%s fps=%.0f avg=%.0fms worst=%.0fms over33ms=%d hover=%s units=P%d/N%d builds=%d lines=%d dfuiTT=%.1fms(%d) anchorHook=%.1fms(%d/%d) backdrop=%.1fms(%d) statusbar=%.1fms(%d) resize=%.1fms(%d) allocDfuiFrames=%dkb(%d) allocOtherFrames=%dkb(%d) allocByHover=P%d/N%d/-%dkb worstAlloc=%dkb@%s ev[%s]',
                     date('%H:%M:%S'), fps, avg, sec.worst * 1000, sec.over33, sec.hover and 'YES' or 'no',
                     sec.unitsPlayer, sec.unitsNpc, sec.builds, sec.maxLines, sec.ttMs, sec.ttN, sec.anMs, sec.anN,
                     sec.anchorN, sec.bdMs, sec.bdN, sec.sbMs, sec.sbN, sec.fsMs, sec.fsN, sec.allocDfui,
                     sec.allocDfuiN, sec.allocOther, sec.allocOtherN, sec.allocPlayer, sec.allocNpc, sec.allocNone,
                     sec.worstAllocKb, sec.worstAllocUnit, evLine(secEv))
    addLine(line)
    if avg > SLOW_FRAME * 1000 then chat(line) end
    wipe(secEv)
    resetSecond()
end

local lastSecond = 0

watch:SetScript('OnUpdate', function(_, elapsed)
    if not active then return end
    if GetTime() - startedAt > AUTO_STOP_SECONDS then
        Diag:Stop(true)
        return
    end

    local statsFrame = not skipStatsOnce
    skipStatsOnce = false

    if elapsed < 5 and statsFrame then
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

        local moPlayer, moName
        if UnitExists('mouseover') then
            sec.hover = true
            moPlayer = UnitIsPlayer('mouseover')
            moName = UnitName('mouseover')
            local g = UnitGUID('mouseover')
            if g and g ~= lastMoGuid then
                lastMoGuid = g
                if moPlayer then
                    sec.unitsPlayer = sec.unitsPlayer + 1
                    sessUnitsPlayer = sessUnitsPlayer + 1
                else
                    sec.unitsNpc = sec.unitsNpc + 1
                    sessUnitsNpc = sessUnitsNpc + 1
                end
            end
        end

        if prev.anchorN > 0 and GameTooltip:IsShown() then
            local n = GameTooltip:NumLines()
            if n > sec.maxLines then sec.maxLines = n end
        end

        -- allocation attribution
        local heapNow = collectgarbage('count')
        if lastFrameHeap then
            local d = heapNow - lastFrameHeap
            if d > 0 then
                local dfuiRan = prev.anN > 0 or prev.ttN > 0 or prev.bdN > 0
                if dfuiRan then
                    sec.allocDfui, sec.allocDfuiN = sec.allocDfui + d, sec.allocDfuiN + 1
                    sessAllocDfui = sessAllocDfui + d
                else
                    sec.allocOther, sec.allocOtherN = sec.allocOther + d, sec.allocOtherN + 1
                    sessAllocOther = sessAllocOther + d
                end
                if UnitExists('mouseover') then
                    if moPlayer then
                        sec.allocPlayer = sec.allocPlayer + d
                        sessAllocPlayer = sessAllocPlayer + d
                    else
                        sec.allocNpc = sec.allocNpc + d
                        sessAllocNpc = sessAllocNpc + d
                    end
                else
                    sec.allocNone = sec.allocNone + d
                    sessAllocNone = sessAllocNone + d
                end
                if d > sec.worstAllocKb then
                    sec.worstAllocKb = d
                    sec.worstAllocUnit = moName and (moName .. (moPlayer and '(player)' or '(npc)')) or '-'
                end
                if d > sessWorstAllocKb then
                    sessWorstAllocKb = d
                    sessWorstAllocUnit = sec.worstAllocUnit
                end
            end
        end
        lastFrameHeap = heapNow

        if elapsed > SPIKE_SECONDS then
            spikes = spikes + 1
            if elapsed * 1000 > worstMs then worstMs = elapsed * 1000 end
            addLine(string.format('%s SPIKE %dms build=%s dfuiTT=%.1fms mouseover=%s', date('%H:%M:%S'),
                                  elapsed * 1000, tostring(prev.setUnit), prev.ttMs, moName or '-'))
        end
    else
        -- probe frame: keep heap baseline current so the probe's own
        -- allocations don't leak into the next frame's attribution
        lastFrameHeap = collectgarbage('count')
    end

    local now = math.floor(GetTime())
    if now ~= lastSecond then
        lastSecond = now
        flushSecond()
        if GetTime() - lastProbeAt >= ADDON_PROBE_INTERVAL then
            lastProbeAt = GetTime()
            addonProbe()
        end
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
    sessAllocPlayer, sessAllocNpc, sessAllocNone = 0, 0, 0
    sessUnitsPlayer, sessUnitsNpc = 0, 0
    sessWorstAllocKb, sessWorstAllocUnit = 0, '-'
    sessAddonDelta = {}
    sessAllocDfui, sessAllocOther = 0, 0
    lastFrameHeap = nil
    lastMoGuid = nil
    lastAddonMem = nil
    lastProbeAt = GetTime()
    skipStatsOnce = false
    wipe(secEv)
    wipe(sessEv)
    for _, ev in ipairs(EV_WATCH) do pcall(evFrame.RegisterEvent, evFrame, ev) end
    resetSecond()
    resetCounters(cur)
    resetCounters(prev)
    addonProbe() -- baseline snapshot
    chat('recording - sweep across PLAYERS ~30s, then across NPCS ~30s, then stand still ~20s.')
    chat('|cffffffff/df hoverlag|r stops, |cffffffff/df hoverlag report|r opens a copyable log.')
end

function Diag:Stop(auto)
    if not active then return end
    active = false
    flushSecond()
    evFrame:UnregisterAllEvents()
    addonProbe() -- final delta snapshot

    local hoverAvg = hoverFrames > 0 and (hoverMs / hoverFrames) or 0
    local baseAvg = baseFrames > 0 and (baseMs / baseFrames) or 0
    addLine(string.format(
                'SUMMARY: hovering avg %.0fms/frame (%d frames) vs baseline %.0fms/frame (%d frames); %d spikes >90ms, worst %dms',
                hoverAvg, hoverFrames, baseAvg, baseFrames, spikes, worstMs))
    addLine(string.format(
                'SUMMARY alloc: onDfuiFrames=%dkb onOtherFrames=%dkb | byHover: players=%dkb npcs=%dkb none=%dkb | units crossed: %d players, %d npcs | per-unit: %dkb/player, %dkb/npc',
                sessAllocDfui, sessAllocOther, sessAllocPlayer, sessAllocNpc, sessAllocNone, sessUnitsPlayer,
                sessUnitsNpc, sessUnitsPlayer > 0 and (sessAllocPlayer / sessUnitsPlayer) or 0,
                sessUnitsNpc > 0 and (sessAllocNpc / sessUnitsNpc) or 0))
    addLine(string.format('SUMMARY worst single frame allocation: %dkb while over %s', sessWorstAllocKb,
                          sessWorstAllocUnit))
    local unitsCrossed = sessUnitsPlayer + sessUnitsNpc
    addLine(string.format('SUMMARY actionbar events: total [%s]%s', evLine(sessEv), unitsCrossed > 0 and
                              string.format(' | per unit crossed: slot=%.1f icon=%.1f cd=%.1f rng=%.1f usab=%.1f',
                                            (sessEv.ACTIONBAR_SLOT_CHANGED or 0) / unitsCrossed,
                                            (sessEv.SPELL_UPDATE_ICON or 0) / unitsCrossed,
                                            (sessEv.ACTIONBAR_UPDATE_COOLDOWN or 0) / unitsCrossed,
                                            (sessEv.ACTION_RANGE_CHECK_UPDATE or 0) / unitsCrossed,
                                            (sessEv.ACTION_USABLE_CHANGED or 0) / unitsCrossed) or ''))
    addLine('SUMMARY actionbar census: ' .. actionbarCensus())

    local ranked = {}
    local addonSum = 0
    for name, d in pairs(sessAddonDelta) do
        ranked[#ranked + 1] = {name = name, d = d}
        addonSum = addonSum + d
    end
    table.sort(ranked, function(a, b) return a.d > b.d end)
    local parts = {}
    for i = 1, math.min(8, #ranked) do
        parts[#parts + 1] = string.format('%s %+dkb', ranked[i].name, ranked[i].d)
    end
    local totalAlloc = sessAllocDfui + sessAllocOther
    addLine(string.format('SUMMARY addon net growth (5s probes): %s | addons total %+dkb vs frame-observed %+dkb'
                              .. ' (rest = Blizzard UI / client-side Lua)',
                          #parts > 0 and table.concat(parts, ', ') or 'none >50kb', addonSum, totalAlloc))

    chat(string.format('stopped%s: hovering %.0fms/frame vs baseline %.0fms/frame. Top allocator: %s',
                       auto and ' (auto)' or '', hoverAvg, baseAvg, ranked[1] and
                           string.format('%s %+dkb', ranked[1].name, ranked[1].d) or 'none detected'))
    chat('|cffffffff/df hoverlag report|r opens the full log to copy into the issue.')

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
