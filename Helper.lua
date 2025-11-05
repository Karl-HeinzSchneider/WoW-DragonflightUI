local addonName, addonTable = ...;
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

local Helper = {};
addonTable.Helper = Helper;

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
    return results, duration, startTime, endTime;
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

    if percent <= 0.5 then
        red, green, blue = Helper:LerpColor(percent * 2, UnitFrameColorGradiantTable[1], UnitFrameColorGradiantTable[2])
    else
        red, green, blue = Helper:LerpColor((percent - 0.5) * 2, UnitFrameColorGradiantTable[2],
                                            UnitFrameColorGradiantTable[3])
    end

    return red, green, blue
end

