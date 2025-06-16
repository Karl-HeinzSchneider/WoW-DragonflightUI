---@diagnostic disable: redundant-parameter
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

local ATTACK_SPEED_SECONDS = ATTACK_SPEED_SECONDS or 'Attack Speed (seconds)' -- Era

DragonflightUICharacterStatsEraMixin = CreateFromMixins(DragonflightUICharacterStatsPanelMixin);

function DragonflightUICharacterStatsEraMixin:SetupStats()
    -- print('DragonflightUICharacterStatsEraMixin SetupStats()')
    self:AddDefaultCategorys()

    self:AddStatsGeneral()
    self:AddStatsAttributes()
    self:AddStatsMelee()
    self:AddStatsRanged()
    self:AddStatsSpell()
    self:AddStatsDefense()
    self:AddStatsResistance()
    -- self:AddStatsSpell()
    -- self:AddStatsSpell()
end

function DragonflightUICharacterStatsEraMixin:AddDefaultCategorys()
    -- print('DragonflightUICharacterStatsEraMixin AddDefaultCategorys()')

    self:RegisterCategory('general', {name = STAT_CATEGORY_GENERAL, descr = 'descr..', order = 1, isExpanded = false})
    self:RegisterCategory('attributes',
                          {name = STAT_CATEGORY_ATTRIBUTES, descr = 'descr..', order = 2, isExpanded = true})
    self:RegisterCategory('melee', {name = STAT_CATEGORY_MELEE, descr = 'descr..', order = 3, isExpanded = true})
    self:RegisterCategory('ranged', {name = STAT_CATEGORY_RANGED, descr = 'descr..', order = 4, isExpanded = true})
    self:RegisterCategory('spell', {name = STAT_CATEGORY_SPELL, descr = 'descr..', order = 4, isExpanded = true})
    self:RegisterCategory('defense', {name = STAT_CATEGORY_DEFENSE, descr = 'descr..', order = 4, isExpanded = true})
    self:RegisterCategory('resistance',
                          {name = STAT_CATEGORY_RESISTANCE, descr = 'descr..', order = 4, isExpanded = true})
end

function DragonflightUICharacterStatsEraMixin:AddStatsGeneral()
    self:RegisterElement('health', 'general', {
        order = 1,
        name = HEALTH,
        descr = '..',
        func = function()
            local hp = UnitHealthMax('player');
            return BreakUpLargeNumbers(hp), 'Health ' .. BreakUpLargeNumbers(hp),
                   'Maximum Health. If your health reaches Zero, you will die.'
        end
    })
    -- self:RegisterElement('itemlvl', 'general', {
    --     order = 2,
    --     name = STAT_AVERAGE_ITEM_LEVEL,
    --     descr = '..',
    --     func = function()

    --     end
    -- })

    local function normalize(d, pad)
        -- return d          
        return string.format("%s %.2f", pad or '', (d / BASE_MOVEMENT_SPEED * 100)) .. '%'
    end

    local function GetMovementTable()
        local newTable = {}
        local currentSpeed, runSpeed, flightSpeed, swimSpeed = GetUnitSpeed('player');

        local pad = '';
        local currentNormal = (currentSpeed / BASE_MOVEMENT_SPEED * 100);

        if currentNormal < 10 then
            pad = '     '
        elseif currentNormal < 100 then
            pad = '   '
        end
        -- print('pad', strlen(pad))

        newTable[1] = {left = 'Movement Speed' .. normalize(currentSpeed, pad)}
        newTable[2] = {left = 'Run Speed', right = normalize(runSpeed)}
        newTable[3] = {left = 'Flight Speed', right = normalize(flightSpeed)}
        newTable[4] = {left = 'Swim Speed', right = normalize(swimSpeed)}

        return newTable, currentSpeed;
    end

    self:RegisterElement('movement', 'general', {
        order = 3,
        name = STAT_MOVEMENT_SPEED,
        descr = '..',
        func = function()
            local moveTable, currentSpeed = GetMovementTable()

            local str = normalize(currentSpeed);
            return str, nil, nil, moveTable;
        end,
        hookOnUpdate = true
    })
end

function DragonflightUICharacterStatsEraMixin:AddStatsAttributes()
    local statTable = {'STRENGTH', 'AGILITY', 'STAMINA', 'INTELLECT', 'SPIRIT'}

    -- function PaperDollFrame_SetPrimaryStats()
    local stats = function(i)
        local frameText; -- df
        local tooltip; -- df
        local tooltip2; -- df

        local stat;
        local effectiveStat;
        local posBuff;
        local negBuff;
        stat, effectiveStat, posBuff, negBuff = UnitStat("player", i);

        -- Set the tooltip text
        local tooltipText = HIGHLIGHT_FONT_COLOR_CODE .. _G["SPELL_STAT" .. i .. "_NAME"] .. " ";

        -- Get class specific tooltip for that stat
        local temp, classFileName = UnitClass("player");
        local classStatText = _G[strupper(classFileName) .. "_" .. statTable[i] .. "_" .. "TOOLTIP"];
        -- If can't find one use the default
        if (not classStatText) then classStatText = _G["DEFAULT" .. "_" .. statTable[i] .. "_" .. "TOOLTIP"]; end

        if ((posBuff == 0) and (negBuff == 0)) then
            frameText = effectiveStat;
            tooltip = tooltipText .. effectiveStat .. FONT_COLOR_CODE_CLOSE;
            tooltip2 = classStatText;
        else
            tooltipText = tooltipText .. effectiveStat;
            if (posBuff > 0 or negBuff < 0) then
                tooltipText = tooltipText .. " (" .. (stat - posBuff - negBuff) .. FONT_COLOR_CODE_CLOSE;
            end
            if (posBuff > 0) then
                tooltipText = tooltipText .. FONT_COLOR_CODE_CLOSE .. GREEN_FONT_COLOR_CODE .. "+" .. posBuff ..
                                  FONT_COLOR_CODE_CLOSE;
            end
            if (negBuff < 0) then
                tooltipText = tooltipText .. RED_FONT_COLOR_CODE .. " " .. negBuff .. FONT_COLOR_CODE_CLOSE;
            end
            if (posBuff > 0 or negBuff < 0) then
                tooltipText = tooltipText .. HIGHLIGHT_FONT_COLOR_CODE .. ")" .. FONT_COLOR_CODE_CLOSE;
            end
            tooltip = tooltipText;
            tooltip2 = classStatText;

            -- If there are any negative buffs then show the main number in red even if there are
            -- positive buffs. Otherwise show in green.
            if (negBuff < 0) then
                frameText = RED_FONT_COLOR_CODE .. effectiveStat .. FONT_COLOR_CODE_CLOSE;
            else
                frameText = GREEN_FONT_COLOR_CODE .. effectiveStat .. FONT_COLOR_CODE_CLOSE;
            end
        end

        return frameText, tooltip, tooltip2;
    end

    self:RegisterElement('str', 'attributes', {
        order = 1,
        name = SPELL_STAT1_NAME,
        descr = '..',
        func = function()
            return stats(1)
        end
    })

    self:RegisterElement('agi', 'attributes', {
        order = 3,
        name = SPELL_STAT2_NAME,
        descr = '..',
        func = function()
            return stats(2)
        end
    })

    self:RegisterElement('stam', 'attributes', {
        order = 3,
        name = SPELL_STAT3_NAME,
        descr = '..',
        func = function()
            return stats(3)
        end
    })

    self:RegisterElement('int', 'attributes', {
        order = 3,
        name = SPELL_STAT4_NAME,
        descr = '..',
        func = function()
            return stats(4)
        end
    })

    self:RegisterElement('spirit', 'attributes', {
        order = 3,
        name = SPELL_STAT5_NAME,
        descr = '..',
        func = function()
            return stats(5)
        end
    })
end

function DragonflightUICharacterStatsEraMixin:AddStatsMelee()

    local function melee()
        local frameText; -- df
        local tooltip; -- df
        local tooltip2; -- df
        local tooltipTable = {}

        local speed, offhandSpeed = UnitAttackSpeed('player');

        local minDamage;
        local maxDamage;
        local minOffHandDamage;
        local maxOffHandDamage;
        local physicalBonusPos;
        local physicalBonusNeg;
        local percent;
        minDamage, maxDamage, minOffHandDamage, maxOffHandDamage, physicalBonusPos, physicalBonusNeg, percent =
            UnitDamage('player');
        local displayMin = max(floor(minDamage), 1);
        local displayMax = max(ceil(maxDamage), 1);

        minDamage = (minDamage / percent) - physicalBonusPos - physicalBonusNeg;
        maxDamage = (maxDamage / percent) - physicalBonusPos - physicalBonusNeg;

        local baseDamage = (minDamage + maxDamage) * 0.5;
        local fullDamage = (baseDamage + physicalBonusPos + physicalBonusNeg) * percent;
        local totalBonus = (fullDamage - baseDamage);
        local damagePerSecond = (max(fullDamage, 1) / speed);
        local damageTooltip = max(floor(minDamage), 1) .. " - " .. max(ceil(maxDamage), 1);

        local colorPos = "|cff20ff20";
        local colorNeg = "|cffff2020";
        if (totalBonus == 0) then
            if ((displayMin < 100) and (displayMax < 100)) then
                frameText = displayMin .. " - " .. displayMax;
            else
                frameText = displayMin .. "-" .. displayMax;
            end
        else

            local color;
            if (totalBonus > 0) then
                color = colorPos;
            else
                color = colorNeg;
            end
            if ((displayMin < 100) and (displayMax < 100)) then
                frameText = color .. displayMin .. " - " .. displayMax .. "|r";
            else
                frameText = color .. displayMin .. "-" .. displayMax .. "|r";
            end
            if (physicalBonusPos > 0) then
                damageTooltip = damageTooltip .. colorPos .. " +" .. physicalBonusPos .. "|r";
            end
            if (physicalBonusNeg < 0) then
                damageTooltip = damageTooltip .. colorNeg .. " " .. physicalBonusNeg .. "|r";
            end
            if (percent > 1) then
                damageTooltip = damageTooltip .. colorPos .. " x" .. floor(percent * 100 + 0.5) .. "%|r";
            elseif (percent < 1) then
                damageTooltip = damageTooltip .. colorNeg .. " x" .. floor(percent * 100 + 0.5) .. "%|r";
            end

        end
        tooltipTable.damage = damageTooltip;
        tooltipTable.attackSpeed = speed;
        tooltipTable.dps = damagePerSecond;

        -- If there's an offhand speed then add the offhand info to the tooltip
        if (offhandSpeed) then
            minOffHandDamage = (minOffHandDamage / percent) - physicalBonusPos - physicalBonusNeg;
            maxOffHandDamage = (maxOffHandDamage / percent) - physicalBonusPos - physicalBonusNeg;

            local offhandBaseDamage = (minOffHandDamage + maxOffHandDamage) * 0.5;
            local offhandFullDamage = (offhandBaseDamage + physicalBonusPos + physicalBonusNeg) * percent;
            local offhandDamagePerSecond = (max(offhandFullDamage, 1) / offhandSpeed);
            local offhandDamageTooltip = max(floor(minOffHandDamage), 1) .. " - " .. max(ceil(maxOffHandDamage), 1);
            if (physicalBonusPos > 0) then
                offhandDamageTooltip = offhandDamageTooltip .. colorPos .. " +" .. physicalBonusPos .. "|r";
            end
            if (physicalBonusNeg < 0) then
                offhandDamageTooltip = offhandDamageTooltip .. colorNeg .. " " .. physicalBonusNeg .. "|r";
            end
            if (percent > 1) then
                offhandDamageTooltip = offhandDamageTooltip .. colorPos .. " x" .. floor(percent * 100 + 0.5) .. "%|r";
            elseif (percent < 1) then
                offhandDamageTooltip = offhandDamageTooltip .. colorNeg .. " x" .. floor(percent * 100 + 0.5) .. "%|r";
            end
            tooltipTable.offhandDamage = offhandDamageTooltip;
            tooltipTable.offhandAttackSpeed = offhandSpeed;
            tooltipTable.offhandDps = offhandDamagePerSecond;
        else
            tooltipTable.offhandAttackSpeed = nil;
        end
        return frameText, tooltip, tooltip2, tooltipTable

    end

    self:RegisterElement('damage', 'melee', {
        order = 1,
        name = DAMAGE,
        descr = '..',
        func = function()
            local frameText; -- df
            local tooltip; -- df
            local tooltip2; -- df
            local tooltipTable = {}

            frameText, tooltip, tooltip2, tooltipTable = melee()

            local newTable = {} -- df

            newTable[1] = {left = INVTYPE_WEAPONMAINHAND}
            newTable[2] = {left = ATTACK_SPEED_SECONDS, right = string.format('%.2f', tooltipTable.attackSpeed)}
            newTable[3] = {left = DAMAGE, right = tooltipTable.damage}
            newTable[4] = {left = DAMAGE_PER_SECOND, right = string.format('%.1f', tooltipTable.dps)}

            if tooltipTable.offhandAttackSpeed then
                newTable[5] = {left = ' '}
                newTable[6] = {left = INVTYPE_WEAPONOFFHAND, white = true}
                newTable[7] = {
                    left = ATTACK_SPEED_SECONDS,
                    right = string.format('%.2f', tooltipTable.offhandAttackSpeed)
                }
                newTable[8] = {left = DAMAGE, right = tooltipTable.offhandDamage}
                newTable[9] = {left = DAMAGE_PER_SECOND, right = string.format('%.1f', tooltipTable.offhandDps)}
            end

            -- print(frameText, tooltip, tooltip2)
            return frameText, tooltip, tooltip2, newTable
        end
    })

    self:RegisterElement('dps', 'melee', {
        order = 2,
        name = STAT_DPS_SHORT,
        descr = '..',
        func = function()
            local frameText; -- df
            local tooltip; -- df
            local tooltip2; -- df
            local tooltipTable = {}

            local newTable = {} -- df

            frameText, tooltip, tooltip2, tooltipTable = melee()
            frameText = string.format('%.1f', tooltipTable.dps);

            newTable[1] = {left = DAMAGE_PER_SECOND}
            newTable[2] = {left = INVTYPE_WEAPONMAINHAND, right = frameText}

            if tooltipTable.offhandAttackSpeed then
                newTable[3] = {left = INVTYPE_WEAPONOFFHAND, right = string.format('%.1f', tooltipTable.offhandDps)}
            end

            return frameText, nil, nil, newTable
        end
    })

    self:RegisterElement('ap', 'melee', {
        order = 3,
        name = ATTACK_POWER_TOOLTIP,
        descr = '..',
        func = function()
            local base, posBuff, negBuff = UnitAttackPower('player');
            local frameText, tooltip, tooltip2 = self:PaperDollFormatStat(MELEE_ATTACK_POWER, base, posBuff, negBuff);
            tooltip2 =
                format(MELEE_ATTACK_POWER_TOOLTIP, max((base + posBuff + negBuff), 0) / ATTACK_POWER_MAGIC_NUMBER);

            return frameText, tooltip, tooltip2;
        end
    })

    self:RegisterElement('attackspeed', 'melee', {
        order = 4,
        name = ATTACK_SPEED,
        descr = '..',
        func = function()
            local frameText; -- df                   

            local newTable = {} -- df
            local speed, offhandSpeed = UnitAttackSpeed('player');

            frameText = string.format('%.2f', speed);

            newTable[1] = {left = ATTACK_SPEED_SECONDS} -- era
            newTable[2] = {left = INVTYPE_WEAPONMAINHAND, right = frameText}

            if offhandSpeed then
                newTable[3] = {left = INVTYPE_WEAPONOFFHAND, right = string.format('%.2f', offhandSpeed)}
            end

            return frameText, nil, nil, newTable
        end
    })

    self:RegisterElement('hit', 'melee', {
        order = 6,
        name = STAT_HIT_CHANCE,
        descr = '..',
        func = function()
            local hit = GetHitModifier()
            if not hit then hit = 0; end

            local str = string.format(' %.2F', hit) .. '%';
            return str, STAT_HIT_CHANCE .. str, 'Reduces your chance to miss.'
        end
    })

    self:RegisterElement('crit', 'melee', {
        order = 7,
        name = STAT_CRITICAL_STRIKE,
        descr = '..',
        func = function()
            local crit = GetCritChance()
            local str = string.format(' %.2F', crit) .. '%';
            return str, CRIT_CHANCE .. str, 'Chance of attacks doing extra damage.'
        end
    })
end

function DragonflightUICharacterStatsEraMixin:AddStatsRanged()
    local function checkNoRange()
        return IsRangedWeapon();
    end

    local function range()
        local frameText; -- df
        local tooltip; -- df
        local tooltip2; -- df
        local tooltipTable = {}

        local rangedAttackSpeed, minDamage, maxDamage, physicalBonusPos, physicalBonusNeg, percent = UnitRangedDamage(
                                                                                                         'player');
        local displayMin = max(floor(minDamage), 1);
        local displayMax = max(ceil(maxDamage), 1);

        minDamage = (minDamage / percent) - physicalBonusPos - physicalBonusNeg;
        maxDamage = (maxDamage / percent) - physicalBonusPos - physicalBonusNeg;

        local baseDamage = (minDamage + maxDamage) * 0.5;
        local fullDamage = (baseDamage + physicalBonusPos + physicalBonusNeg) * percent;
        local totalBonus = (fullDamage - baseDamage);
        local damagePerSecond;
        if (rangedAttackSpeed == 0) then
            -- Egan's Blaster!!!
            damagePerSecond = math.huge;
        else
            damagePerSecond = (max(fullDamage, 1) / rangedAttackSpeed);
        end

        tooltip = max(floor(minDamage), 1) .. " - " .. max(ceil(maxDamage), 1);

        if (totalBonus == 0) then
            if ((displayMin < 100) and (displayMax < 100)) then
                frameText = displayMin .. " - " .. displayMax;
            else
                frameText = displayMin .. "-" .. displayMax;
            end
        else
            local colorPos = "|cff20ff20";
            local colorNeg = "|cffff2020";
            local color;
            if (totalBonus > 0) then
                color = colorPos;
            else
                color = colorNeg;
            end
            if ((displayMin < 100) and (displayMax < 100)) then
                frameText = color .. displayMin .. " - " .. displayMax .. "|r";
            else
                frameText = color .. displayMin .. "-" .. displayMax .. "|r";
            end
            if (physicalBonusPos > 0) then tooltip = tooltip .. colorPos .. " +" .. physicalBonusPos .. "|r"; end
            if (physicalBonusNeg < 0) then tooltip = tooltip .. colorNeg .. " " .. physicalBonusNeg .. "|r"; end
            if (percent > 1) then
                tooltip = tooltip .. colorPos .. " x" .. floor(percent * 100 + 0.5) .. "%|r";
            elseif (percent < 1) then
                tooltip = tooltip .. colorNeg .. " x" .. floor(percent * 100 + 0.5) .. "%|r";
            end
            tooltipTable.tooltip = tooltip .. " " .. format(DPS_TEMPLATE, damagePerSecond);
        end
        tooltipTable.attackSpeed = rangedAttackSpeed;
        tooltipTable.damage = tooltip;
        tooltipTable.dps = damagePerSecond;

        return frameText, tooltip, tooltip2, tooltipTable
    end

    self:RegisterElement('damage', 'ranged', {
        order = 1,
        name = DAMAGE,
        descr = '..',
        func = function()
            local frameText; -- df
            local tooltip; -- df
            local tooltip2; -- df
            local tooltipTable = {}

            if not checkNoRange() then return NOT_APPLICABLE, nil, nil end

            frameText, tooltip, tooltip2, tooltipTable = range()
            -- DevTools_Dump(tooltipTable)

            local newTable = {} -- df

            newTable[1] = {left = RANGED}
            newTable[2] = {left = ATTACK_SPEED_SECONDS, right = string.format('%.2f', tooltipTable.attackSpeed)}
            newTable[3] = {left = DAMAGE, right = tooltipTable.damage}
            newTable[4] = {left = DAMAGE_PER_SECOND, right = string.format('%.1f', tooltipTable.dps)}

            -- print(frameText, tooltip, tooltip2)
            return frameText, nil, nil, newTable
        end
    })

    self:RegisterElement('dps', 'ranged', {
        order = 2,
        name = STAT_DPS_SHORT,
        descr = '..',
        func = function()
            if not checkNoRange() then return NOT_APPLICABLE, nil, nil end

            local frameText; -- df
            local tooltip; -- df
            local tooltip2; -- df
            local tooltipTable = {}

            local newTable = {} -- df

            frameText, tooltip, tooltip2, tooltipTable = range()
            frameText = string.format('%.1f', tooltipTable.dps);

            newTable[1] = {left = DAMAGE_PER_SECOND}
            newTable[2] = {left = RANGED, right = frameText}

            return frameText, nil, nil, newTable
        end
    })

    self:RegisterElement('ap', 'ranged', {
        order = 3,
        name = ATTACK_POWER_TOOLTIP,
        descr = '..',
        func = function()
            if not checkNoRange() then return NOT_APPLICABLE, nil, nil end

            -- if (HasWandEquipped()) then return '--', nil, nil end
            if (HasWandEquipped()) then return NOT_APPLICABLE, nil, nil end

            local base, posBuff, negBuff = UnitRangedAttackPower('player');
            local frameText, tooltip, tooltip2 = self:PaperDollFormatStat(RANGED_ATTACK_POWER, base, posBuff, negBuff);
            tooltip2 = format(RANGED_ATTACK_POWER_TOOLTIP,
                              max((base + posBuff + negBuff), 0) / ATTACK_POWER_MAGIC_NUMBER);

            return frameText, tooltip, tooltip2;
        end
    })

    self:RegisterElement('attackspeed', 'ranged', {
        order = 4,
        name = ATTACK_SPEED,
        descr = '..',
        func = function()
            if not checkNoRange() then return NOT_APPLICABLE, nil, nil end

            local frameText; -- df
            local tooltip; -- df
            local tooltip2; -- df
            local tooltipTable = {}

            local speed, lowDmg, hiDmg, posBuff, negBuff, percent = UnitRangedDamage('player');
            frameText = string.format('%.2f', speed);

            local newTable = {} -- df         

            newTable[1] = {left = RANGED}
            newTable[2] = {left = ATTACK_SPEED_SECONDS, right = frameText}

            -- print(frameText, tooltip, tooltip2)
            return frameText, nil, nil, newTable
        end
    })

    local extraHit = function()
        local link = GetInventoryItemLink('player', 18);

        if link then
            local itemID, enchantID = link:match("item:(%d+):(%d*)");
            if enchantID and tonumber(enchantID) == 2523 then return 3; end
        end

        return 0;
    end

    self:RegisterElement('hit', 'ranged', {
        order = 6,
        name = STAT_HIT_CHANCE,
        descr = '..',
        func = function()
            if not checkNoRange() then return NOT_APPLICABLE, nil, nil end

            local hit = GetHitModifier()
            if not hit then hit = 0; end

            hit = hit + extraHit()

            local str = string.format(' %.2F', hit) .. '%';
            return str, STAT_HIT_CHANCE .. str, 'Reduces your chance to miss.'
        end
    })

    self:RegisterElement('crit', 'ranged', {
        order = 7,
        name = STAT_CRITICAL_STRIKE,
        descr = '..',
        func = function()
            if not checkNoRange() then return NOT_APPLICABLE, nil, nil end

            local crit = GetRangedCritChance()
            local str = string.format(' %.2F', crit) .. '%';
            return str, CRIT_CHANCE .. str, 'Chance of attacks doing extra damage.'
        end
    })
end

function DragonflightUICharacterStatsEraMixin:AddStatsSpell()
    local cap = {
        SPELL_SCHOOL1_CAP, SPELL_SCHOOL2_CAP, SPELL_SCHOOL3_CAP, SPELL_SCHOOL4_CAP, SPELL_SCHOOL5_CAP,
        SPELL_SCHOOL6_CAP, SPELL_SCHOOL7_CAP
    }

    local function GetSpellDamageTable()
        local newTable = {}
        newTable[1] = {left = STAT_SPELLPOWER}
        newTable[2] = {left = STAT_SPELLPOWER_TOOLTIP}
        newTable[3] = {left = ' '}

        local maxDamage = GetSpellBonusDamage(2);
        local spellDamage;

        for i = 2, 7 do
            spellDamage = GetSpellBonusDamage(i);
            -- minCrit = min(minCrit, spellCrit);
            maxDamage = max(maxDamage, spellDamage);
            -- spellDamage = 5;
            if spellDamage > 0 then
                table.insert(newTable, {left = cap[i - 1] .. ' ' .. DAMAGE, right = string.format('%d', spellDamage)})
            end
        end

        if #newTable == 3 then newTable[3] = nil; end

        return newTable, maxDamage;
    end

    self:RegisterElement('damage', 'spell', {
        order = 5,
        name = STAT_SPELLPOWER,
        descr = '..',
        func = function()
            local spellTable, dmg = GetSpellDamageTable()

            local str = string.format(' %d', dmg);
            return str, nil, nil, spellTable;
        end
    })

    self:RegisterElement('healing', 'spell', {
        order = 5.5,
        name = STAT_SPELLHEALING,
        descr = '..',
        func = function()
            local healing = GetSpellBonusHealing();

            local str = string.format(' %d', healing);
            return str, STAT_SPELLHEALING .. str, STAT_SPELLHEALING_TOOLTIP;
        end
    })

    self:RegisterElement('hit', 'spell', {
        order = 6,
        name = STAT_HIT_CHANCE,
        descr = '..',
        func = function()
            local hit = GetSpellHitModifier()
            if not hit then hit = 0; end

            local str = string.format(' %.2F', hit) .. '%';
            return str, STAT_HIT_CHANCE .. str, 'Reduces your chance to miss.'
        end
    })

    local function GetRealSpellCrit()
        local minCrit = GetSpellCritChance(2);
        local spellCrit;

        for i = 2, 7 do
            spellCrit = GetSpellCritChance(i);
            -- minCrit = min(minCrit, spellCrit);
            minCrit = max(minCrit, spellCrit);
        end

        return minCrit;
    end

    self:RegisterElement('crit', 'spell', {
        order = 7,
        name = STAT_CRITICAL_STRIKE,
        descr = '..',
        func = function()
            local crit = GetRealSpellCrit()
            local str = string.format(' %.2f', crit) .. '%';
            return str, CRIT_CHANCE .. str, 'Chance of spells doing extra damage.'
        end
    })

    self:RegisterElement('mana', 'spell', {
        order = 8,
        name = MANA_REGEN,
        descr = '..',
        func = function()
            local base, casting = GetManaRegen()

            local newTable = {}
            newTable[1] = {left = MANA_REGEN}
            -- newTable[2] = {left = 'Mana every 5s', right = string.format(' %.2f', base * 5)}
            -- newTable[3] = {left = 'Mana every 5s while casting', right = string.format(' %.2f', casting * 5)}
            newTable[2] = {left = 'Mana every 5s while casting', right = BreakUpLargeNumbers(casting * 5)}
            newTable[3] = {left = 'Mana every 5s while not casting', right = BreakUpLargeNumbers(base * 5)}

            return newTable[3].right, nil, nil, newTable;
        end
    })
end

function DragonflightUICharacterStatsEraMixin:AddStatsDefense()
    local armor = function()
        local frameText; -- df
        local tooltip; -- df
        local tooltip2; -- df           

        local base, effectiveArmor, _armor, posBuff, negBuff = UnitArmor('player');

        local totalBufs = posBuff + negBuff;

        -- local frame = _G[prefix .. "ArmorFrame"];
        -- local text = _G[prefix .. "ArmorFrameStatText"];

        frameText, tooltip, tooltip2 = self:PaperDollFormatStat(ARMOR, base, posBuff, negBuff);
        local playerLevel = UnitLevel('player');
        local armorReduction = effectiveArmor / ((85 * playerLevel) + 400);
        armorReduction = 100 * (armorReduction / (armorReduction + 1));

        tooltip2 = format(ARMOR_TOOLTIP, playerLevel, armorReduction);

        return frameText, tooltip, tooltip2
    end

    self:RegisterElement('armor', 'defense', {
        order = 1,
        name = ARMOR,
        descr = '..',
        func = function()
            return armor()
        end
    })

    local function GetDefense()
        for i = 1, GetNumSkillLines() do
            local skillName, isHeader, isExpanded, skillRank, numTempPoints, skillModifier = GetSkillLineInfo(i)
            if skillName == DEFENSE then
                -- print(name, rank, tempRank, mod)
                -- print('skillName, skillRank, numTempPoints, skillModifier')
                return skillName, skillRank, numTempPoints, skillModifier
            end
        end
    end

    self:RegisterElement('defense', 'defense', {
        order = 2,
        name = DEFENSE,
        descr = '..',
        func = function()
            local skillName, skillRank, numTempPoints, skillModifier = GetDefense();

            local posBuff = 0;
            local negBuff = 0;
            if (skillModifier > 0) then
                posBuff = skillModifier;
            elseif (skillModifier < 0) then
                negBuff = skillModifier;
            end

            local frameText, tooltip, tooltip2 = self:PaperDollFormatStat(DEFENSE, skillRank, posBuff, negBuff);

            tooltip2 = 'Increases chance to Dodge, Block and Parry.\nDecreases chance to be hit and critically hit.';

            return frameText, tooltip, tooltip2
        end
    })

    self:RegisterElement('dodge', 'defense', {
        order = 3,
        name = DODGE,
        descr = '..',
        func = function()
            local dodge = GetDodgeChance()
            local str = string.format(' %.2F', dodge) .. '%';
            return str, DODGE_CHANCE .. str, nil
        end
    })

    self:RegisterElement('parry', 'defense', {
        order = 4,
        name = PARRY,
        descr = '..',
        func = function()
            local parry = GetParryChance()
            local str = string.format(' %.2F', parry) .. '%';
            return str, PARRY_CHANCE .. str, nil
        end
    })

    self:RegisterElement('block', 'defense', {
        order = 5,
        name = BLOCK,
        descr = '..',
        func = function()
            local block = GetBlockChance()
            local str = string.format(' %.2F', block) .. '%';
            return str, BLOCK_CHANCE .. str, nil
        end
    })
end

function DragonflightUICharacterStatsEraMixin:AddStatsResistance()
    local tex = 'Interface\\PaperDollInfoFrame\\UI-Character-ResistanceIcons';
    local resIcons = {}
    local resCoords = {
        {0, 1.0, 0, 0.11328125}, -- fire
        {0, 1.0, 0.11328125, 0.2265625}, -- nature
        {0, 1.0, 0.33984375, 0.453125}, -- frost
        {0, 1.0, 0.453125, 0.56640625}, -- shadow  
        {0, 1.0, 0.2265625, 0.33984375} -- arcane
    }
    for k, v in ipairs(resCoords) do
        resIcons[k] = string.format('%s:%s:%s:%s', v[1] * 32, v[2] * 32, v[3] * 256, v[4] * 256)
    end
    -- local resIcons = {'0:1.0:0.2265625:0.33984375'}

    local res = function(i)
        local frameText; -- df
        local tooltip; -- df
        local tooltip2; -- df

        local resistance;
        local positive;
        local negative;
        local base;
        -- local text = _G["MagicResText"..i];
        -- local frame = _G["MagicResFrame"..i];

        base, resistance, positive, negative = UnitResistance("player", i);

        -- resistances can now be negative. Show Red if negative, Green if positive, white otherwise
        if (abs(negative) > positive) then
            frameText = RED_FONT_COLOR_CODE .. resistance .. FONT_COLOR_CODE_CLOSE;
        elseif (abs(negative) == positive) then
            frameText = resistance;
        else
            frameText = GREEN_FONT_COLOR_CODE .. resistance .. FONT_COLOR_CODE_CLOSE;
        end

        local resistanceName = _G["RESISTANCE" .. i .. "_NAME"];
        tooltip = resistanceName .. " " .. resistance;
        if (positive ~= 0 or negative ~= 0) then
            -- Otherwise build up the formula
            tooltip = tooltip .. " ( " .. HIGHLIGHT_FONT_COLOR_CODE .. base;
            if (positive > 0) then tooltip = tooltip .. GREEN_FONT_COLOR_CODE .. " +" .. positive; end
            if (negative < 0) then tooltip = tooltip .. " " .. RED_FONT_COLOR_CODE .. negative; end
            tooltip = tooltip .. FONT_COLOR_CODE_CLOSE .. " )";
        end

        local unitLevel = UnitLevel("player");
        unitLevel = max(unitLevel, 20);
        local magicResistanceNumber = resistance / unitLevel;
        local resistanceLevel;
        if (magicResistanceNumber > 5) then
            resistanceLevel = RESISTANCE_EXCELLENT;
        elseif (magicResistanceNumber > 3.75) then
            resistanceLevel = RESISTANCE_VERYGOOD;
        elseif (magicResistanceNumber > 2.5) then
            resistanceLevel = RESISTANCE_GOOD;
        elseif (magicResistanceNumber > 1.25) then
            resistanceLevel = RESISTANCE_FAIR;
        elseif (magicResistanceNumber > 0) then
            resistanceLevel = RESISTANCE_POOR;
        else
            resistanceLevel = RESISTANCE_NONE;
        end
        tooltip2 = format(RESISTANCE_TOOLTIP_SUBTEXT, _G["RESISTANCE_TYPE" .. i], unitLevel, resistanceLevel);

        tooltip = string.format('|T%s:16:16:0:0:32:256:%s|t %s', tex, resIcons[i - 1], tooltip)

        return frameText, tooltip, tooltip2;
    end

    -- local resTable = {'Holy', 'Fire', 'Nature', 'Frost', 'Shadow', 'Arcane'}

    local function resName(i)
        return string.format('|T%s:16:16:0:0:32:256:%s|t %s', tex, resIcons[i - 2], SCHOOL_STRINGS[i])
    end

    self:RegisterElement(SCHOOL_STRINGS[7], 'resistance', {
        order = 1,
        name = resName(7),
        descr = '..',
        func = function()
            return res(6)
        end
    })
    -- 1 = holy
    for k = 2, NUM_RESISTANCE_TYPES do
        self:RegisterElement(SCHOOL_STRINGS[k + 1], 'resistance', {
            order = k,
            name = resName(k + 1),
            descr = '..',
            func = function()
                return res(k)
            end
        })
    end
end

-- function DragonflightUICharacterStatsEraMixin:AddStatsGeneral()
-- end

-- function DragonflightUICharacterStatsEraMixin:Test()
--     print('TEST DragonflightUICharacterStatsEraMixin')
-- end
