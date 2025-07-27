local addonName, addonTable = ...;
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

local Helper = {};
addonTable.Helper = Helper;

function Helper:Benchmark(label, func, level)
    level = level or 1;
    if level < 1 then DF:Debug(DF, string.format('|cffffd100-----Start Bench: |r|cff8080ff%s|r-----', label)) end
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
    DF:Debug(DF, str)
end
