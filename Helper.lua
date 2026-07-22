local addonName, addonTable = ...;
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

local Helper = {};
addonTable.Helper = Helper;

-- era-1159 diagnostics: persist phase timings so slow spots can be read from
-- disk after logout ("script ran too long" hides the real sink - the error
-- surfaces wherever the shared load-time budget happens to expire, not where
-- the time went). Wiped at the start of every session: the file always holds
-- the LAST session.
local perfLog = { boot = true }
DragonflightUIPerfLog = perfLog
-- SavedVariables load AFTER this file runs and would re-point the global at
-- last session's table; re-assert ours so the file on disk is always the
-- most recent session.
local perfFrame = CreateFrame('Frame')
perfFrame:RegisterEvent('ADDON_LOADED')
perfFrame:SetScript('OnEvent', function(self, _, name)
    if name == addonName then
        DragonflightUIPerfLog = perfLog
        self:UnregisterAllEvents()
    end
end)

-- make globally available
_G['DragonflightUI_Helper'] = Helper;

function Helper:Benchmark(label, func, level, moduleRef)
    if level == nil or type(level) ~= 'number' then level = 1; end
    -- level = level or 1;
    if level < 1 then
        local firstStr = string.format('|cffffd100-----Start Bench: |r|cff8080ff%s|r-----', label)
        -- print(firstStr)
        DF:Debug(moduleRef or DF, firstStr)
    end
    local startTime = GetTimePreciseSec()
    local results = {func()}
    local endTime = GetTimePreciseSec()
    local duration = endTime - startTime

    local levelStr = '';
    if level > 0 then levelStr = string.rep("~", level) .. '>'; end

    -- local str = string.format("|cffffd100%sBench: |r|cff8080ff%s|r took %.4f ms (%.6f seconds)", levelStr, label,
    --                           duration * 1000, duration)
    local str = string.format("|cffffd100%sBench: |r|cff8080ff%s|r took |cffffd100%.4f|r ms", levelStr, label,
                              duration * 1000)
    -- print(str)
    DF:Debug(moduleRef or DF, str)
    if #perfLog < 400 then
        perfLog[#perfLog + 1] = string.format('%.1fms %s', duration * 1000, label)
    end
    return results, duration, startTime, endTime;
end

-- era-1159: run {label, fn} steps one per frame. Each step gets a fresh
-- watchdog slice; a failing step is reported (so DFUIErrorGrab records it)
-- but never breaks the chain.
function Helper:RunSteps(steps, moduleRef, chainLabel)
    local index = 0
    local function runNext()
        index = index + 1
        local step = steps[index]
        if not step then return end
        local name = (chainLabel or 'Chain') .. ':' .. (step[1] or index)
        local startTime = GetTimePreciseSec()
        local ok, err = pcall(step[2])
        local ms = (GetTimePreciseSec() - startTime) * 1000
        if #perfLog < 400 then
            perfLog[#perfLog + 1] = string.format('%.1fms %s%s', ms, name, ok and '' or ' [ERROR]')
        end
        if not ok then geterrorhandler()(name .. ': ' .. tostring(err)) end
        C_Timer.After(0, runNext)
    end
    -- Fully async: even the first step runs outside the caller's slice.
    C_Timer.After(0, runNext)
end

-- local playerMaskTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframeplayerportraitmask'
local circularMaskTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\tempportraitalphamask'

function Helper:AddCircleMask(f, port, maskTexture)
    if not f or not port then return end
    if not maskTexture then maskTexture = circularMaskTexture end
    local mask = f:CreateMaskTexture()
    mask:SetAllPoints(port)
    mask:SetTexture(maskTexture, 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
    port:AddMaskTexture(mask)
end

function Helper:GetUnitHealthPercent(unit)
    if not unit then return 0 end

    local max_health = UnitHealthMax(unit)
    local health = UnitHealth(unit)

    return health / max_health
end

-- override with _G['DragonflightUI_Helper'].UnitFrameColorGradiantTable = [...]
-- maybe I'll add some color picker on advanced options, but for now a simple macro/addon/weakaura should be enough, if not
-- contact me on discord!
local UnitFrameColorGradiantTable = {
    DFCreateColor(1.0, 0, 0), -- red
    DFCreateColor(1.0, 0.6, 0), -- amber
    DFCreateColor(0.3, 1.0, 0.2) -- green
}
Helper.UnitFrameColorGradiantTable = UnitFrameColorGradiantTable;
Helper.UnitFrameColorGradiantCutoff = 0.60; -- 0.5

function Helper:LerpColor(percent, colorOne, colorTwo)
    if percent < 0 then
        percent = 0
    elseif percent > 1.0 then
        percent = 1.0;
    end

    local red = colorOne.r + (colorTwo.r - colorOne.r) * percent;
    local green = colorOne.g + (colorTwo.g - colorOne.g) * percent;
    local blue = colorOne.b + (colorTwo.b - colorOne.b) * percent;

    return red, green, blue
end

function Helper:ColorGradiant(percent)
    local red, green, blue;

    if percent < 0 then
        percent = 0
    elseif percent > 1.0 then
        percent = 1.0;
    end

    local cutoff = Helper.UnitFrameColorGradiantCutoff;
    if cutoff <= 0 then
        cutoff = 0.5
    elseif cutoff > 1.0 then
        cutoff = 0.5;
    end
    local cutoffMult = 1 / cutoff;

    if percent <= cutoff then
        red, green, blue = Helper:LerpColor(percent * cutoffMult, UnitFrameColorGradiantTable[1],
                                            UnitFrameColorGradiantTable[2])
    else
        red, green, blue = Helper:LerpColor((percent - (1 - cutoff)) * cutoffMult, UnitFrameColorGradiantTable[2],
                                            UnitFrameColorGradiantTable[3])
    end

    return red, green, blue
end

function Helper:CreateFrameEventCallback(event, fn)
    return EventRegistry:RegisterFrameEventAndCallback(event, function(_, ...)
        fn(...)
    end)
end

function Helper:CreateCVARCallback(cvar, fn, notInCombat)
    -- print('CreateCVARCallback', cvar)

    local ownerID = nil;
    local ownerIDLoaded = nil;
    local ownerIDCombat = nil;

    if notInCombat then
        ownerIDLoaded = Helper:CreateFrameEventCallback('VARIABLES_LOADED', function(...)
            -- print('~VARIABLES_LOADED', ...)
            if InCombatLockdown() then return end
            fn();
        end)

        ownerID = Helper:CreateFrameEventCallback('CVAR_UPDATE', function(...)
            -- print('~CVAR_UPDATE', ...)
            if InCombatLockdown() then return end
            local c, value = ...;

            if c == cvar then fn(); end
        end)

        ownerIDCombat = Helper:CreateFrameEventCallback('PLAYER_REGEN_ENABLED', function(...)
            -- print('~PLAYER_REGEN_ENABLED', ...)
            if InCombatLockdown() then return end
            fn();
        end)
    else
        ownerIDLoaded = Helper:CreateFrameEventCallback('VARIABLES_LOADED', function(...)
            -- print('~VARIABLES_LOADED', ...)
            fn();
        end)

        ownerID = Helper:CreateFrameEventCallback('CVAR_UPDATE', function(...)
            -- print('~CVAR_UPDATE', ...)
            local c, value = ...;

            if c == cvar then fn(); end
        end)
    end

    return ownerID, ownerIDLoaded, ownerIDCombat
end

-- function Helper:CreateFrameEventCallback(event, cvar, fn)
--     print('CreateFrameEventCallback', event, cvar)
--     return EventRegistry:RegisterFrameEventAndCallback(event, function(self, c, value)
--         -- print("showed the mount journal")
--         print(event, c, value)
--     end)
-- end

