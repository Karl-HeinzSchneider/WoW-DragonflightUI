local isClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC;
if not isClassic then return; end

local lib = LibStub:NewLibrary("AuraDurations-1.0", 1);

if not lib then
    return -- already loaded and no upgrade necessary
end

--
local MAX_TARGET_BUFFS = MAX_TARGET_BUFFS or 32;
local MAX_TARGET_DEBUFFS = MAX_TARGET_DEBUFFS or 16;

local UnitAura = UnitAura
local LibClassicDurations;

---@class frame
local frame = CreateFrame("Frame");
lib.frame = frame;

frame:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, event, ...);
end)

frame:RegisterEvent("PLAYER_LOGIN")
function frame:PLAYER_LOGIN(event, ...)
    -- print(event, ...)

    LibClassicDurations = LibStub("LibClassicDurations", true)
    if LibClassicDurations then
        LibClassicDurations:Register("AuraDurations")
        UnitAura = LibClassicDurations.UnitAuraWrapper

        hooksecurefunc("TargetFrame_UpdateAuras", frame.TargetBuffHook)
        hooksecurefunc("CompactUnitFrame_UtilSetBuff", frame.CompactUnitFrameBuffHook)
        hooksecurefunc("CompactUnitFrame_UtilSetDebuff", frame.CompactUnitFrameDeBuffHook)
    end
end

frame.TargetBuffHook = function(self)
    -- print('TargetBuffHook')
    local frameName, frameCooldown;
    local selfName = self:GetName();
    ---@diagnostic disable-next-line: undefined-field
    local unit = self.unit;

    for i = 1, MAX_TARGET_BUFFS do
        local buffName, icon, count, debuffType, duration, expirationTime, caster, canStealOrPurge, _, spellId, _, _,
              casterIsPlayer, nameplateShowAll = UnitBuff(unit, i, nil);

        if (buffName) then
            frameName = selfName .. "Buff" .. (i);

            -- blizzard default
            -- -- Handle cooldowns
            -- frameCooldown = _G[frameName .. "Cooldown"];
            -- CooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);

            -- using Lib
            -- Handle cooldowns
            frameCooldown = _G[frameName .. "Cooldown"];
            local durationLib, expirationTimeLib = LibClassicDurations:GetAuraDurationByUnit(unit, spellId, caster);
            if duration == 0 and durationLib then
                duration = durationLib;
                expirationTime = expirationTimeLib;
            end
            CooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);
        else
            break
        end
    end

    local frameNum = 1;
    local index = 1;

    ---@diagnostic disable-next-line: undefined-field
    local maxDebuffs = self.maxDebuffs or MAX_TARGET_DEBUFFS;
    while (frameNum <= maxDebuffs and index <= maxDebuffs) do
        local debuffName, icon, count, debuffType, duration, expirationTime, caster, _, _, spellId, _, _,
              casterIsPlayer, nameplateShowAll = UnitDebuff(unit, index, "INCLUDE_NAME_PLATE_ONLY");
        if (debuffName) then
            if (TargetFrame_ShouldShowDebuffs(unit, caster, nameplateShowAll, casterIsPlayer)) then
                frameName = selfName .. "Debuff" .. frameNum;
                frame = _G[frameName];
                if (icon) then
                    -- -- blizzard default
                    -- -- Handle cooldowns
                    -- frameCooldown = _G[frameName .. "Cooldown"];
                    -- CooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);

                    -- using Lib
                    -- Handle cooldowns
                    frameCooldown = _G[frameName .. "Cooldown"];
                    local durationLib, expirationTimeLib = LibClassicDurations:GetAuraDurationByUnit(unit, spellId,
                                                                                                     caster);
                    if duration == 0 and durationLib then
                        duration = durationLib;
                        expirationTime = expirationTimeLib;
                    end
                    CooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);

                    frameNum = frameNum + 1;
                end
            end
        else
            break
        end
        index = index + 1;
    end
end

-- based on blizz: function CompactUnitFrame_UtilSetBuff(buffFrame, unit, index, filter)
frame.CompactUnitFrameBuffHook = function(buffFrame, unit, index, filter)
    local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura =
        UnitBuff(unit, index, filter);

    local durationLib, expirationTimeLib = LibClassicDurations:GetAuraDurationByUnit(unit, spellId, unitCaster);
    if duration == 0 and durationLib then
        duration = durationLib;
        expirationTime = expirationTimeLib;
    end

    -- CompactUnitFrame_UpdateCooldownFrame(buffFrame, expirationTime - duration, duration, true); -- blizz default

    -- from function CompactUnitFrame_UpdateCooldownFrame(frame, expirationTime, duration, buff)
    local enabled = expirationTime and expirationTime ~= 0;
    if enabled then
        local startTime = expirationTime - duration;
        CooldownFrame_Set(buffFrame.cooldown, startTime, duration, true);
    else
        CooldownFrame_Clear(buffFrame.cooldown);
    end
end

-- based on blizz: function CompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, isBossAura, isBossBuff)
frame.CompactUnitFrameDeBuffHook = function(debuffFrame, unit, index, filter, isBossAura, isBossBuff)
    local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId;
    if (isBossBuff) then
        name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId = UnitBuff(
                                                                                                               unit,
                                                                                                               index,
                                                                                                               filter);
    else
        name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId = UnitDebuff(
                                                                                                               unit,
                                                                                                               index,
                                                                                                               filter);
    end

    local durationLib, expirationTimeLib = LibClassicDurations:GetAuraDurationByUnit(unit, spellId, unitCaster);
    if duration == 0 and durationLib then
        duration = durationLib;
        expirationTime = expirationTimeLib;
    end

    -- CompactUnitFrame_UpdateCooldownFrame(debuffFrame, expirationTime, duration, false);

    -- from function CompactUnitFrame_UpdateCooldownFrame(frame, expirationTime, duration, buff)
    local enabled = expirationTime and expirationTime ~= 0;
    if enabled then
        local startTime = expirationTime - duration;
        CooldownFrame_Set(debuffFrame.cooldown, startTime, duration, true);
    else
        CooldownFrame_Clear(debuffFrame.cooldown);
    end
end

