local isClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC;
local addonName, addonTable = ...
local standalone = (addonName == 'AuraDurations');

if standalone and not isClassic then return; end

local lib = LibStub:NewLibrary("AuraDurations-1.0", 1);

if not lib then
    return -- already loaded and no upgrade necessary
end

--
local MAX_TARGET_BUFFS = MAX_TARGET_BUFFS or 32;
local MAX_TARGET_DEBUFFS = MAX_TARGET_DEBUFFS or 16;
local PLAYER_UNITS = {player = true, vehicle = true, pet = true};

local UnitAura = UnitAura
local LibClassicDurations;

local SetCVarFunc = SetCVar;
-- if C_CVar and C_CVar.SetCVar then
--     SetCVarFunc = C_CVar.SetCVar;
-- else
--     SetCVarFunc = SetCVar;
-- end

local GetCVarFunc = GetCVarBool;
-- if C_CVar and C_CVar.GetCVar then
--     GetCVarFunc = C_CVar.GetCVarBool;
-- else
--     GetCVarFunc = GetCVarBool;
-- end

local defaults = {
    auraSizeSmall = 17, -- SMALL_AURA_SIZE,
    auraSizeLarge = 21, -- LARGE_AURA_SIZE,
    auraOffsetY = 1, -- AURA_OFFSET_Y,
    noDebuffFilter = true, -- noBuffDebuffFilterOnTarget
    dynamicBuffSize = true, -- showDynamicBuffSize
    auraRowWidth = 122, -- AURA_ROW_WIDTH
    totAuraRowWidth = 101, -- TOT_AURA_ROW_WIDTH
    numTotAuraRows = 2 -- NUM_TOT_AURA_ROWS
}

---@class frame
local frame = CreateFrame("Frame");
lib.frame = frame;
lib.Defaults = defaults
lib.IsStandalone = standalone

function frame:SetDefaults()
    for k, v in pairs(defaults) do AuraDurationsDB[k] = v; end
end

function frame:AddMissingKeys()
    for k, v in pairs(defaults) do if AuraDurationsDB[k] == nil then AuraDurationsDB[k] = v; end end
end

function frame:SetState(state)
    if not standalone then frame:Embed() end
    for k, v in pairs(state) do AuraDurationsDB[k] = v; end

    self:Update()
end

function frame:Update()
    -- print('update')
    SetCVarFunc('noBuffDebuffFilterOnTarget', AuraDurationsDB.noDebuffFilter)
    SetCVarFunc('showDynamicBuffSize', AuraDurationsDB.dynamicBuffSize)

    TargetFrame_UpdateAuras(TargetFrame)
end

frame:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, event, ...);
end)

-- standalone uses PLAYER_LOGIN
-- embeded adds the functionality when you call SetState() 
if standalone then frame:RegisterEvent("PLAYER_LOGIN") end

function frame:PLAYER_LOGIN(event, ...)
    -- print(event, ...)

    if type(AuraDurationsDB) ~= 'table' then
        -- print('AuraDurations: new DB!')
        AuraDurationsDB = {}
        frame:SetDefaults()
    end
    lib.AuraDurationsDB = AuraDurationsDB;
    self.AuraDurationsDB = AuraDurationsDB;
    self:AddMissingKeys()
    self:Update()

    LibClassicDurations = LibStub("LibClassicDurations", true)
    if LibClassicDurations then
        LibClassicDurations:Register("AuraDurations")
        UnitAura = LibClassicDurations.UnitAuraWrapper
    end

    hooksecurefunc("TargetFrame_UpdateAuras", frame.TargetBuffHook)
    hooksecurefunc("CompactUnitFrame_UtilSetBuff", frame.CompactUnitFrameBuffHook)
    hooksecurefunc("CompactUnitFrame_UtilSetDebuff", frame.CompactUnitFrameDeBuffHook)
end

function frame:Embed()
    if frame.IsEmbeded then return false; end

    frame:PLAYER_LOGIN('EMBED')

    frame.IsEmbeded = true;
    return true;
end

local largeBuffList = {};
local largeDebuffList = {};
local function ShouldAuraBeLarge(caster)
    if (not GetCVarBool("showDynamicBuffSize")) then return true; end
    if not caster then return false; end

    for token, value in pairs(PLAYER_UNITS) do
        if UnitIsUnit(caster, token) or UnitIsOwnerOrControllerOfUnit(token, caster) then return value; end
    end
end

frame.UpdateAuraPositions = function(self, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth,
                                     offsetX, mirrorAurasVertically)
    -- custom
    local AURA_OFFSET_Y = AuraDurationsDB.auraOffsetY;
    local LARGE_AURA_SIZE = AuraDurationsDB.auraSizeLarge;
    local SMALL_AURA_SIZE = AuraDurationsDB.auraSizeSmall;
    local AURA_ROW_WIDTH = AuraDurationsDB.auraRowWidth;
    local NUM_TOT_AURA_ROWS = AuraDurationsDB.numTotAuraRows;
    --

    -- Position auras
    local size;
    local offsetY = AURA_OFFSET_Y;
    -- current width of a row, increases as auras are added and resets when a new aura's width exceeds the max row width
    local rowWidth = 0;
    local firstBuffOnRow = 1;
    for i = 1, numAuras do
        -- update size and offset info based on large aura status
        if (largeAuraList[i]) then
            size = LARGE_AURA_SIZE;
            offsetY = AURA_OFFSET_Y + AURA_OFFSET_Y;
        else
            size = SMALL_AURA_SIZE;
        end

        -- anchor the current aura
        if (i == 1) then
            rowWidth = size;
            self.auraRows = self.auraRows + 1;
        else
            rowWidth = rowWidth + size + offsetX;
        end
        if (rowWidth > maxRowWidth) then
            -- this aura would cause the current row to exceed the max row width, so make this aura
            -- the start of a new row instead
            updateFunc(self, auraName, i, numOppositeAuras, firstBuffOnRow, size, offsetX, offsetY,
                       mirrorAurasVertically);

            rowWidth = size;
            self.auraRows = self.auraRows + 1;
            firstBuffOnRow = i;
            offsetY = AURA_OFFSET_Y;

            if (self.auraRows > NUM_TOT_AURA_ROWS) then
                -- if we exceed the number of tot rows, then reset the max row width
                -- note: don't have to check if we have tot because AURA_ROW_WIDTH is the default anyway
                maxRowWidth = AURA_ROW_WIDTH;
            end
        else
            updateFunc(self, auraName, i, numOppositeAuras, i - 1, size, offsetX, offsetY, mirrorAurasVertically);
        end
    end
end

frame.TargetBuffHook = function(self)
    -- print('TargetBuffHook')
    local frameName, frameCooldown;
    local numBuffs = 0;
    local numDebuffs = 0;
    local selfName = self:GetName();
    ---@diagnostic disable-next-line: undefined-field
    local unit = self.unit;

    for i = 1, MAX_TARGET_BUFFS do
        local buffName, icon, count, debuffType, duration, expirationTime, caster, canStealOrPurge, _, spellId, _, _,
              casterIsPlayer, nameplateShowAll = UnitBuff(unit, i, nil);

        if (buffName) then
            frameName = selfName .. "Buff" .. (i);
            numBuffs = numBuffs + 1;
            largeBuffList[numBuffs] = ShouldAuraBeLarge(caster);
            -- blizzard default
            -- -- Handle cooldowns
            -- frameCooldown = _G[frameName .. "Cooldown"];
            -- CooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);

            -- using Lib
            -- Handle cooldowns
            frameCooldown = _G[frameName .. "Cooldown"];
            if LibClassicDurations then
                local durationLib, expirationTimeLib = LibClassicDurations:GetAuraDurationByUnit(unit, spellId, caster);
                if duration == 0 and durationLib then
                    duration = durationLib;
                    expirationTime = expirationTimeLib;
                end
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
                -- frame = _G[frameName];
                if (icon) then
                    numDebuffs = numDebuffs + 1;
                    largeDebuffList[numDebuffs] = ShouldAuraBeLarge(caster);

                    -- -- blizzard default
                    -- -- Handle cooldowns
                    -- frameCooldown = _G[frameName .. "Cooldown"];
                    -- CooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);

                    -- using Lib
                    -- Handle cooldowns
                    frameCooldown = _G[frameName .. "Cooldown"];
                    if LibClassicDurations then
                        local durationLib, expirationTimeLib =
                            LibClassicDurations:GetAuraDurationByUnit(unit, spellId, caster);
                        if duration == 0 and durationLib then
                            duration = durationLib;
                            expirationTime = expirationTimeLib;
                        end
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

    -- custom
    local AURA_ROW_WIDTH = AuraDurationsDB.auraRowWidth;
    local NUM_TOT_AURA_ROWS = AuraDurationsDB.numTotAuraRows;
    local TOT_AURA_ROW_WIDTH = AuraDurationsDB.totAuraRowWidth
    --

    self.auraRows = 0;

    local mirrorAurasVertically = false;
    if (self.buffsOnTop) then mirrorAurasVertically = true; end
    local haveTargetofTarget;
    if (self.totFrame) then haveTargetofTarget = self.totFrame:IsShown(); end
    self.spellbarAnchor = nil;
    local maxRowWidth;
    -- update buff positions
    maxRowWidth = (haveTargetofTarget and TOT_AURA_ROW_WIDTH) or AURA_ROW_WIDTH;
    frame.UpdateAuraPositions(self, selfName .. "Buff", numBuffs, numDebuffs, largeBuffList,
                              TargetFrame_UpdateBuffAnchor, maxRowWidth, 3, mirrorAurasVertically);
    -- update debuff positions
    maxRowWidth = (haveTargetofTarget and self.auraRows < NUM_TOT_AURA_ROWS and TOT_AURA_ROW_WIDTH) or AURA_ROW_WIDTH;
    frame.UpdateAuraPositions(self, selfName .. "Debuff", numDebuffs, numBuffs, largeDebuffList,
                              TargetFrame_UpdateDebuffAnchor, maxRowWidth, 3, mirrorAurasVertically);
    -- update the spell bar position
    if (self.spellbar) then Target_Spellbar_AdjustPosition(self.spellbar); end
end

-- based on blizz: function CompactUnitFrame_UtilSetBuff(buffFrame, unit, index, filter)
frame.CompactUnitFrameBuffHook = function(buffFrame, unit, index, filter)
    local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura =
        UnitBuff(unit, index, filter);

    if LibClassicDurations then
        local durationLib, expirationTimeLib = LibClassicDurations:GetAuraDurationByUnit(unit, spellId, unitCaster);
        if duration == 0 and durationLib then
            duration = durationLib;
            expirationTime = expirationTimeLib;
        end
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

    if LibClassicDurations then
        local durationLib, expirationTimeLib = LibClassicDurations:GetAuraDurationByUnit(unit, spellId, unitCaster);
        if duration == 0 and durationLib then
            duration = durationLib;
            expirationTime = expirationTimeLib;
        end
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

