---@class DragonflightUI
---@diagnostic disable-next-line: assign-type-mismatch
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

-- Hover-lag diagnostic (/df hoverlag) for the "frame drops when hovering
-- raid members" reports. While active, every frame that takes >90ms is
-- logged with (a) whether a GameTooltip:SetUnit build ran during that
-- frame, (b) how many ms of it were DragonflightUI's own tooltip handler,
-- and (c) how many UPDATE_MOUSEOVER_UNIT events fired (sweeping across
-- raid frames fires one per frame crossed). If skips coincide with
-- tooltip builds while the DFUI share stays near zero, another addon's
-- tooltip/mouseover hook is the offender. /df hoverlag report opens a
-- copyable log to paste into an issue.
--
-- Everything here is hooksecurefunc/OnUpdate based - no secure paths are
-- touched, and the hooks are inert (single boolean check) while the
-- diagnostic is off.
local Diag = {}
DF.HoverDiag = Diag

local AUTO_STOP_SECONDS = 900 -- don't let users leave it running forever
local MAX_LINES = 400
local SPIKE_SECONDS = 0.09

local active = false
local hooksInstalled = false
local startedAt = 0
local lastChatAt = 0
local lines = {}
local spikes, worstMs, spikesWithTooltip, worstDfuiMs = 0, 0, 0, 0

-- flags describe the CURRENT frame's activity; the elapsed that reflects
-- that frame's cost arrives in the NEXT frame's OnUpdate, so keep a
-- one-frame history.
local curSetUnit, prevSetUnit = false, false
local curDfuiMs, prevDfuiMs = 0, 0
local curMo, prevMo = 0, 0

local watch = CreateFrame('Frame')
local moFrame = CreateFrame('Frame')

local function chat(msg)
    print('|cffff8800DFUI hoverlag:|r ' .. msg)
end

local function installHooks()
    if hooksInstalled then return end
    hooksInstalled = true

    hooksecurefunc(GameTooltip, 'SetUnit', function(_, unit)
        if active then curSetUnit = unit or '?' end
    end)

    moFrame:SetScript('OnEvent', function()
        curMo = curMo + 1
    end)

    -- time DFUI's own unit-tooltip handler so its share is measured, not guessed
    local tooltipModule = DF:GetModule('Tooltip', true)
    if tooltipModule and tooltipModule.OnTooltipSetUnit then
        local orig = tooltipModule.OnTooltipSetUnit
        tooltipModule.OnTooltipSetUnit = function(...)
            if not active then return orig(...) end
            local t0 = debugprofilestop()
            local r1, r2 = orig(...)
            curDfuiMs = curDfuiMs + (debugprofilestop() - t0)
            return r1, r2
        end
    end
end

local function header()
    local version = (C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata)('DragonflightUI', 'Version')
    local _, build = GetBuildInfo()
    return string.format('DragonflightUI hover-lag log | v%s | client build %s | %s | started %s',
                         tostring(version), tostring(build),
                         IsInRaid() and 'raid' or (IsInGroup() and 'party' or 'solo'), date('%Y-%m-%d %H:%M:%S'))
end

watch:SetScript('OnUpdate', function(_, elapsed)
    if not active then return end
    if GetTime() - startedAt > AUTO_STOP_SECONDS then
        Diag:Stop(true)
        return
    end

    if elapsed > SPIKE_SECONDS and elapsed < 5 then -- ignore loading screens
        local mo, moGroup = '-', '-'
        if UnitExists('mouseover') then
            mo = UnitName('mouseover') or '?'
            moGroup = (UnitInRaid('mouseover') and 'raid') or (UnitInParty('mouseover') and 'party') or
                          (UnitIsPlayer('mouseover') and 'player' or 'npc')
        end
        local ttUnit = '-'
        if GameTooltip:IsShown() then
            local _, u = GameTooltip:GetUnit()
            ttUnit = u or '-'
        end

        local ms = elapsed * 1000
        spikes = spikes + 1
        if ms > worstMs then worstMs = ms end
        if prevSetUnit then spikesWithTooltip = spikesWithTooltip + 1 end
        if prevDfuiMs > worstDfuiMs then worstDfuiMs = prevDfuiMs end

        local line = string.format(
                         '%s skip=%dms tooltipBuild=%s dfuiShare=%.1fms moEvents=%d mouseover=%s(%s) tooltip=%s grp=%s',
                         date('%H:%M:%S'), ms, tostring(prevSetUnit), prevDfuiMs, prevMo, mo, moGroup, ttUnit,
                         IsInRaid() and 'raid' or (IsInGroup() and 'party' or 'solo'))
        if #lines >= MAX_LINES then table.remove(lines, 1) end
        lines[#lines + 1] = line

        -- live feedback, at most one line per second
        if GetTime() - lastChatAt > 1 then
            lastChatAt = GetTime()
            chat(line)
        end
    end

    prevSetUnit, prevDfuiMs, prevMo = curSetUnit, curDfuiMs, curMo
    curSetUnit, curDfuiMs, curMo = false, 0, 0
end)

function Diag:Start()
    if active then return end
    installHooks()
    active = true
    startedAt = GetTime()
    lines = {header()}
    spikes, worstMs, spikesWithTooltip, worstDfuiMs = 0, 0, 0, 0
    moFrame:RegisterEvent('UPDATE_MOUSEOVER_UNIT')
    chat('recording frame skips - reproduce the lag now (hover raid members/frames).')
    chat('|cffffffff/df hoverlag|r stops, |cffffffff/df hoverlag report|r opens a copyable log.')
end

function Diag:Stop(auto)
    if not active then return end
    active = false
    moFrame:UnregisterAllEvents()

    local summary = string.format('stopped%s: %d skips, worst %dms, %d during a tooltip build, DFUI max share %.1fms',
                                  auto and ' (auto, 15min)' or '', spikes, worstMs, spikesWithTooltip, worstDfuiMs)
    lines[#lines + 1] = summary
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
    elseif arg == '' or arg == 'toggle' then
        if active then
            Diag:Stop()
        else
            Diag:Start()
        end
    else
        chat('usage: |cffffffff/df hoverlag|r (start/stop), |cffffffff/df hoverlag report|r (copyable log)')
    end
end
