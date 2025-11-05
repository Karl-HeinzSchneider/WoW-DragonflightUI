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

function Helper:ColorGradiant(percent)
    local red, green, blue

    if percent <= 0.5 then
        -- From red (1,0,0) to bright amber (1,0.6,0)
        local t = percent / 0.5
        red = 1
        green = 0.6 * t      -- green goes 0 → 0.6
        blue = 0
    else
        -- From bright amber (1,0.6,0) to bright green (0,1,0)
        local t = (percent - 0.5) / 0.5
        red = 1 - t          -- red fades to 0
        green = 0.6 + 0.4 * t  -- green goes 0.6 → 1
        blue = 0
    end

    return red, green, blue
end

