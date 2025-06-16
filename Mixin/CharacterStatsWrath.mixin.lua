---@diagnostic disable: redundant-parameter
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

-- local ATTACK_SPEED_SECONDS = ATTACK_SPEED_SECONDS or 'Attack Speed (seconds)' -- Era

DragonflightUICharacterStatsWrathMixin = CreateFromMixins(DragonflightUICharacterStatsPanelMixin);

function DragonflightUICharacterStatsWrathMixin:SetupStats()
    -- print('DragonflightUICharacterStatsEraMixin SetupStats()')
    self:AddDummy()
    self:AddDefaultCategorys()

    self:AddStatsGeneral()
    self:AddStatsAttributes()
    self:AddStatsMelee()
    -- self:AddStatsRanged()
    self:AddStatsSpell()
    self:AddStatsDefense()
    self:AddStatsResistance()
end

function DragonflightUICharacterStatsWrathMixin:AddDummy()
    self.Dummy = CreateFrame("Frame", 'DragonflightUICharacterStatsDummy', self, 'DFCharacterStatsDummy')
end

function DragonflightUICharacterStatsWrathMixin:AddDefaultCategorys()
    -- print('DragonflightUICharacterStatsEraMixin AddDefaultCategorys()')

    self:RegisterCategory('general', {name = STAT_CATEGORY_GENERAL, descr = 'descr..', order = 1, isExpanded = false})
    self:RegisterCategory('attributes',
                          {name = STAT_CATEGORY_ATTRIBUTES, descr = 'descr..', order = 2, isExpanded = true})
    self:RegisterCategory('melee', {name = STAT_CATEGORY_MELEE, descr = 'descr..', order = 3, isExpanded = true})
    -- self:RegisterCategory('ranged', {name = STAT_CATEGORY_RANGED, descr = 'descr..', order = 4, isExpanded = true})
    self:RegisterCategory('spell', {name = STAT_CATEGORY_SPELL, descr = 'descr..', order = 4, isExpanded = true})
    self:RegisterCategory('defense', {name = STAT_CATEGORY_DEFENSE, descr = 'descr..', order = 4, isExpanded = true})
    self:RegisterCategory('resistance',
                          {name = STAT_CATEGORY_RESISTANCE, descr = 'descr..', order = 4, isExpanded = true})
end

function DragonflightUICharacterStatsWrathMixin:AddStatsGeneral()
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

function DragonflightUICharacterStatsWrathMixin:AddStatsAttributes()
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

        if ((posBuff == 0) and (negBuff == 0)) then
            frameText = effectiveStat;
            tooltip = tooltipText .. effectiveStat .. FONT_COLOR_CODE_CLOSE;
            -- tooltip2 = classStatText;
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
            -- tooltip2 = classStatText;

            -- If there are any negative buffs then show the main number in red even if there are
            -- positive buffs. Otherwise show in green.
            if (negBuff < 0) then
                frameText = RED_FONT_COLOR_CODE .. effectiveStat .. FONT_COLOR_CODE_CLOSE;
            else
                frameText = GREEN_FONT_COLOR_CODE .. effectiveStat .. FONT_COLOR_CODE_CLOSE;
            end
        end

        tooltip2 = getglobal("DEFAULT_STAT" .. i .. "_TOOLTIP");
        local _, unitClass = UnitClass("player");
        unitClass = strupper(unitClass);

        if (i == 1) then
            local attackPower = GetAttackPowerForStat(i, effectiveStat);
            tooltip2 = format(tooltip2, attackPower);
            if (unitClass == "WARRIOR" or unitClass == "SHAMAN" or unitClass == "PALADIN") then
                tooltip2 = tooltip2 .. "\n" .. format(STAT_BLOCK_TOOLTIP, effectiveStat * BLOCK_PER_STRENGTH - 10);
            end
        elseif (i == 3) then
            local baseStam = min(20, effectiveStat);
            local moreStam = effectiveStat - baseStam;
            tooltip2 = format(tooltip2,
                              (baseStam + (moreStam * HEALTH_PER_STAMINA)) * GetUnitMaxHealthModifier("player"));
            local petStam = ComputePetBonus("PET_BONUS_STAM", effectiveStat);
            if (petStam > 0) then tooltip2 = tooltip2 .. "\n" .. format(PET_BONUS_TOOLTIP_STAMINA, petStam); end
        elseif (i == 2) then
            local attackPower = GetAttackPowerForStat(i, effectiveStat);
            if (attackPower > 0) then
                tooltip2 = format(STAT_ATTACK_POWER, attackPower) ..
                               format(tooltip2, GetCritChanceFromAgility("player"), effectiveStat * ARMOR_PER_AGILITY);
            else
                tooltip2 = format(tooltip2, GetCritChanceFromAgility("player"), effectiveStat * ARMOR_PER_AGILITY);
            end
        elseif (i == 4) then
            local baseInt = min(20, effectiveStat);
            local moreInt = effectiveStat - baseInt
            if (UnitHasMana("player")) then
                tooltip2 = format(tooltip2, baseInt + moreInt * MANA_PER_INTELLECT,
                                  GetSpellCritChanceFromIntellect("player"));
            else
                tooltip2 = nil;
            end
            local petInt = ComputePetBonus("PET_BONUS_INT", effectiveStat);
            if (petInt > 0) then
                if (not tooltip2) then tooltip2 = ""; end
                tooltip2 = tooltip2 .. "\n" .. format(PET_BONUS_TOOLTIP_INTELLECT, petInt);
            end
        elseif (i == 5) then
            -- All mana regen stats are displayed as mana/5 sec.
            tooltip2 = format(tooltip2, GetUnitHealthRegenRateFromSpirit("player"));
            if (UnitHasMana("player")) then
                local regen = GetUnitManaRegenRateFromSpirit("player");
                regen = floor(regen * 5.0);
                tooltip2 = tooltip2 .. "\n" .. format(MANA_REGEN_FROM_SPIRIT, regen);
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

function DragonflightUICharacterStatsWrathMixin:AddStatsMelee()
    self:RegisterElement('damage', 'melee', {
        order = 1,
        name = DAMAGE,
        descr = '..',
        func = function()
            local frameText; -- df  

            local Dummy = self.Dummy;
            Dummy:ResetText()
            PaperDollFrame_SetDamage(Dummy, 'player');
            local label, stattext, tt, tt2 = self.Dummy:GetText();
            frameText = stattext;

            local newTable = {} -- df

            newTable[1] = {left = INVTYPE_WEAPONMAINHAND}
            newTable[2] = {left = ATTACK_SPEED_SECONDS, right = string.format('%.2f', Dummy.attackSpeed)}
            newTable[3] = {left = DAMAGE, right = Dummy.damage}
            newTable[4] = {left = DAMAGE_PER_SECOND, right = string.format('%.1f', Dummy.dps)}

            if Dummy.offhandAttackSpeed then
                newTable[5] = {left = ' '}
                newTable[6] = {left = INVTYPE_WEAPONOFFHAND, white = true}
                newTable[7] = {left = ATTACK_SPEED_SECONDS, right = string.format('%.2f', Dummy.offhandAttackSpeed)}
                newTable[8] = {left = DAMAGE, right = Dummy.offhandDamage}
                newTable[9] = {left = DAMAGE_PER_SECOND, right = string.format('%.1f', Dummy.offhandDps)}
            end

            -- print(frameText, tooltip, tooltip2)
            return frameText, nil, nil, newTable
        end
    })

    self:RegisterElement('dps', 'melee', {
        order = 2,
        name = STAT_DPS_SHORT,
        descr = '..',
        func = function()
            local frameText; -- df  

            local Dummy = self.Dummy;
            Dummy:ResetText()
            PaperDollFrame_SetDamage(Dummy, 'player');
            local label, stattext, tt, tt2 = self.Dummy:GetText();
            -- frameText = stattext;

            local newTable = {} -- df

            frameText = string.format('%.1f', Dummy.dps);

            newTable[1] = {left = DAMAGE_PER_SECOND}
            newTable[2] = {left = INVTYPE_WEAPONMAINHAND, right = frameText}

            if Dummy.offhandAttackSpeed then
                newTable[3] = {left = INVTYPE_WEAPONOFFHAND, right = string.format('%.1f', Dummy.offhandDps)}
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

            if (offhandSpeed) then frameText = frameText .. " / " .. string.format('%.2f', offhandSpeed); end

            newTable[1] = {left = ATTACK_SPEED_SECONDS} -- era
            newTable[2] = {left = INVTYPE_WEAPONMAINHAND, right = frameText}

            if offhandSpeed then
                newTable[3] = {left = INVTYPE_WEAPONOFFHAND, right = string.format('%.2f', offhandSpeed)}
            end
            table.insert(newTable, {
                left = format(CR_HASTE_RATING_TOOLTIP, GetCombatRating(CR_HASTE_MELEE),
                              GetCombatRatingBonus(CR_HASTE_MELEE))
            })

            return frameText, nil, nil, newTable
        end
    })

    self:RegisterElement('hit', 'melee', {
        order = 6,
        name = COMBAT_RATING_NAME6,
        descr = '..',
        func = function()
            -- local Dummy = self.Dummy;
            -- Dummy:ResetText()
            -- PaperDollFrame_SetRating(Dummy, CR_HIT_MELEE);
            -- local label, stattext, tt, tt2 = Dummy:GetText();
            -- print(label, stattext, tt, tt2)

            local rating = GetCombatRating(CR_HIT_MELEE);
            local ratingBonus = GetCombatRatingBonus(CR_HIT_MELEE);

            local newTable = {} -- df
            newTable[1] = {left = COMBAT_RATING_NAME6 .. ' ' .. rating}
            newTable[2] = {left = L['CharacterStatsHitMeleeTooltipFormat']:format(UnitLevel('player'), ratingBonus)}

            return rating, nil, nil, newTable
        end
    })

    self:RegisterElement('crit', 'melee', {
        order = 7,
        name = MELEE_CRIT_CHANCE,
        descr = '..',
        func = function()
            local crit = GetCritChance() -- + GetCritChanceFromAgility('player');
            local str = string.format(' %.2F', crit) .. '%';

            local newTable = {} -- df
            newTable[1] = {left = MELEE_CRIT_CHANCE .. str}
            newTable[2] = {left = 'Chance of attacks doing extra damage.'}
            newTable[3] = {left = ' '}
            newTable[4] = {
                left = format(CR_CRIT_MELEE_TOOLTIP, GetCombatRating(CR_CRIT_MELEE), GetCombatRatingBonus(CR_CRIT_MELEE))
            }

            -- newTable[4] = {left = 'Crit Rating', right = GetCombatRating(CR_CRIT_MELEE)}
            -- newTable[4] = {
            --     left = 'Crit Rating',
            --     right = string.format('%d (+%.2f%%)', GetCombatRating(CR_CRIT_MELEE),
            --                           GetCombatRatingBonus(CR_CRIT_MELEE))
            -- }
            -- newTable[5] = {left = ' ', right = string.format('+%.2f%%', GetCombatRatingBonus(CR_CRIT_MELEE))}
            -- newTable[5] = {left = 'From Agility', right = string.format('+%.2f%%', GetCritChanceFromAgility('player'))}

            return str, nil, nil, newTable
        end
    })

    self:RegisterElement('arp', 'melee', {
        order = 8,
        name = L['CharacterStatsArp'],
        descr = '..',
        func = function()
            local rating = GetCombatRating(CR_ARMOR_PENETRATION);
            local ratingBonus = GetArmorPenetration();

            local newTable = {} -- df
            newTable[1] = {left = L['CharacterStatsArp'] .. ' ' .. rating}
            newTable[2] = {left = L['CharacterStatsArpTooltipFormat']:format(rating, ratingBonus)}

            return rating, nil, nil, newTable
        end
    })

    self:RegisterElement('expertise', 'melee', {
        order = 9,
        name = STAT_EXPERTISE,
        descr = '..',
        func = function()
            local expertise, offhandExpertise = GetExpertise();
            local speed, offhandSpeed = UnitAttackSpeed('player');
            local rating;
            if (offhandSpeed) then
                rating = expertise .. " / " .. offhandExpertise;
            else
                rating = expertise;
            end

            local expertisePercent, offhandExpertisePercent = GetExpertisePercent();
            expertisePercent = format("%.2f", expertisePercent);
            local text;
            if (offhandSpeed) then
                offhandExpertisePercent = format("%.2f", offhandExpertisePercent);
                text = expertisePercent .. "% / " .. offhandExpertisePercent .. "%";
            else
                text = expertisePercent .. "%";
            end

            local newTable = {} -- df
            newTable[1] = {left = _G["COMBAT_RATING_NAME" .. CR_EXPERTISE] .. ' ' .. rating}
            newTable[2] = {
                left = CR_EXPERTISE_TOOLTIP:format(text, GetCombatRating(CR_EXPERTISE),
                                                   GetCombatRatingBonus(CR_EXPERTISE))
            }

            return rating, nil, nil, newTable
        end
    })

end

function DragonflightUICharacterStatsWrathMixin:AddStatsRanged()
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

function DragonflightUICharacterStatsWrathMixin:AddStatsSpell()
    local cap = {
        SPELL_SCHOOL1_CAP, SPELL_SCHOOL2_CAP, SPELL_SCHOOL3_CAP, SPELL_SCHOOL4_CAP, SPELL_SCHOOL5_CAP,
        SPELL_SCHOOL6_CAP, SPELL_SCHOOL7_CAP
    }

    self:RegisterElement('damage', 'spell', {
        order = 1,
        name = BONUS_DAMAGE,
        descr = '..',
        func = function()
            local newTable = {} -- df
            newTable[1] = {left = BONUS_DAMAGE}

            local holySchool = 2;
            -- Start at 2 to skip physical damage
            local minModifier = GetSpellBonusDamage(holySchool);
            local bonusDamageTable = {};
            bonusDamageTable[holySchool] = minModifier;
            table.insert(newTable, {left = cap[2 - 1] .. ' ' .. DAMAGE, right = string.format('%d', minModifier)})

            local bonusDamage;
            for i = (holySchool + 1), MAX_SPELL_SCHOOLS do
                bonusDamage = GetSpellBonusDamage(i);
                minModifier = min(minModifier, bonusDamage);
                bonusDamageTable[i] = bonusDamage;

                table.insert(newTable, {left = cap[i - 1] .. ' ' .. DAMAGE, right = string.format('%d', bonusDamage)})
            end
            if #newTable == 3 then newTable[3] = nil; end

            local str = minModifier;

            newTable[1] = {left = BONUS_DAMAGE .. ' ' .. str}

            -- local str = string.format(' %d', dmg);
            return str, nil, nil, newTable;
        end
    })

    self:RegisterElement('healing', 'spell', {
        order = 2,
        name = BONUS_HEALING,
        descr = '..',
        func = function()
            local healing = GetSpellBonusHealing();

            local str = string.format(' %d', healing);
            return str, BONUS_HEALING .. str, format(BONUS_HEALING_TOOLTIP, healing);
        end
    })

    self:RegisterElement('hit', 'spell', {
        order = 3,
        name = COMBAT_RATING_NAME8,
        descr = '..',
        func = function()
            local rating = GetCombatRating(CR_HIT_SPELL);
            local ratingBonus = GetCombatRatingBonus(CR_HIT_SPELL);

            local newTable = {} -- df
            newTable[1] = {left = COMBAT_RATING_NAME8 .. ' ' .. rating}
            newTable[2] = {left = L['CharacterStatsHitSpellTooltipFormat']:format(UnitLevel('player'), ratingBonus)}

            return rating, nil, nil, newTable
        end
    })

    self:RegisterElement('crit', 'spell', {
        order = 4,
        name = SPELL_CRIT_CHANCE,
        descr = '..',
        func = function()
            local newTable = {} -- df
            newTable[1] = {left = SPELL_CRIT_CHANCE}

            local holySchool = 2;
            -- Start at 2 to skip physical damage
            local minCrit = GetSpellCritChance(holySchool);

            table.insert(newTable, {left = cap[2 - 1] .. ' ' .. '', right = string.format('%.2f%%', minCrit)})

            local spellCrit;
            for i = (holySchool + 1), MAX_SPELL_SCHOOLS do
                spellCrit = GetSpellCritChance(i);
                minCrit = min(minCrit, spellCrit);

                table.insert(newTable, {left = cap[i - 1] .. ' ' .. '', right = string.format('%.2f%%', spellCrit)})
            end
            if #newTable == 3 then newTable[3] = nil; end

            local str = minCrit;
            newTable[1] = {left = SPELL_CRIT_CHANCE .. ' ' .. string.format('%.2f%%', str)}

            -- local str = string.format(' %d', dmg);
            return string.format('%.2f%%', str), nil, nil, newTable;
        end
    })

    self:RegisterElement('haste', 'spell', {
        order = 5,
        name = SPELL_HASTE,
        descr = '..',
        func = function()
            local rating = GetCombatRating(CR_HASTE_SPELL)

            return rating, SPELL_HASTE .. ' ' .. rating, format(SPELL_HASTE_TOOLTIP, rating);
        end
    })

    self:RegisterElement('pen', 'spell', {
        order = 6,
        name = L['CharacterStatsSpellPen'],
        descr = '..',
        func = function()
            local rating = GetSpellPenetration();

            local newTable = {} -- df
            newTable[1] = {left = L['CharacterStatsSpellPen'] .. ' ' .. rating}
            newTable[2] = {left = L['CharacterStatsSpellPenTooltipFormat']:format(rating, rating)}

            return rating, nil, nil, newTable
        end
    })

    self:RegisterElement('mana', 'spell', {
        order = 7,
        name = MANA_REGEN,
        descr = '..',
        func = function()
            if (not UnitHasMana("player")) then return NOT_APPLICABLE, nil, nil; end

            local base, casting = GetManaRegen();
            -- All mana regen stats are displayed as mana/5 sec.
            base = floor(base * 5.0);
            casting = floor(casting * 5.0);

            return base, MANA_REGEN .. ' ' .. base, format(MANA_REGEN_TOOLTIP, base, casting)
        end
    })
end

function DragonflightUICharacterStatsWrathMixin:AddStatsDefense()
    local armor = function()
        local frameText; -- df
        local tooltip; -- df
        local tooltip2; -- df           

        local base, effectiveArmor, armor, posBuff, negBuff = UnitArmor('player');

        local totalBufs = posBuff + negBuff;

        -- local frame = _G[prefix .. "ArmorFrame"];
        -- local text = _G[prefix .. "ArmorFrameStatText"];

        frameText, tooltip, tooltip2 = self:PaperDollFormatStat(ARMOR, base, posBuff, negBuff);
        local playerLevel = UnitLevel('player');
        local armorReduction = PaperDollFrame_GetArmorReduction(effectiveArmor, UnitLevel('player'))
        tooltip2 = format(DEFAULT_STATARMOR_TOOLTIP, armorReduction)
        -- armorReduction = 100 * (armorReduction / (armorReduction + 1));

        -- tooltip2 = format(ARMOR_TOOLTIP, playerLevel, armorReduction);        	

        local petBonus = ComputePetBonus("PET_BONUS_ARMOR", effectiveArmor);
        if (petBonus > 0) then tooltip2 = tooltip2 .. "\n" .. format(PET_BONUS_TOOLTIP_ARMOR, petBonus); end

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
            local base, modifier = UnitDefense('player');
            local posBuff = 0;
            local negBuff = 0;
            if (modifier > 0) then
                posBuff = modifier;
            elseif (modifier < 0) then
                negBuff = modifier;
            end
            local frameText, tooltip, tooltip2 = self:PaperDollFormatStat(DEFENSE, base, posBuff, negBuff);

            -- tooltip2 = 'Increases chance to Dodge, Block and Parry.\nDecreases chance to be hit and critically hit.';
            local defensePercent = GetDodgeBlockParryChanceFromDefense();
            tooltip2 = format(DEFAULT_STATDEFENSE_TOOLTIP, GetCombatRating(CR_DEFENSE_SKILL),
                              GetCombatRatingBonus(CR_DEFENSE_SKILL), defensePercent, defensePercent);

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

            local tooltip = DODGE_CHANCE .. str
            local tooltip2 = format(CR_DODGE_TOOLTIP, GetCombatRating(CR_DODGE), GetCombatRatingBonus(CR_DODGE));

            return str, tooltip, tooltip2
        end
    })

    self:RegisterElement('parry', 'defense', {
        order = 4,
        name = PARRY,
        descr = '..',
        func = function()
            -- local parry = GetParryChance()
            -- local str = string.format(' %.2F', parry) .. '%';
            -- return str, PARRY_CHANCE .. str, nil

            local parry = GetParryChance()
            local str = string.format(' %.2F', parry) .. '%';

            local tooltip = PARRY_CHANCE .. str
            local tooltip2 = format(CR_PARRY_TOOLTIP, GetCombatRating(CR_PARRY), GetCombatRatingBonus(CR_PARRY));

            return str, tooltip, tooltip2
        end
    })

    self:RegisterElement('block', 'defense', {
        order = 5,
        name = BLOCK,
        descr = '..',
        func = function()
            local block = GetBlockChance()
            local str = string.format(' %.2F', block) .. '%';

            local tooltip = BLOCK_CHANCE .. str
            local tooltip2 = format(CR_BLOCK_TOOLTIP, GetCombatRating(CR_BLOCK), GetCombatRatingBonus(CR_BLOCK),
                                    GetShieldBlock());

            return str, tooltip, tooltip2
        end
    })

    self:RegisterElement('res', 'defense', {
        order = 6,
        name = STAT_RESILIENCE,
        descr = '..',
        func = function()
            local resilience = GetCombatRating(CR_RESILIENCE_CRIT_TAKEN);
            local bonus = GetCombatRatingBonus(CR_RESILIENCE_CRIT_TAKEN);
            local maxBonus = GetMaxCombatRatingBonus(CR_RESILIENCE_CRIT_TAKEN);

            -- local frameText, tooltip, tooltip2 = self:PaperDollFormatStat(DEFENSE, base, posBuff, negBuff);
            local tooltip = STAT_RESILIENCE .. ' ' .. resilience;
            local tooltip2 = format(RESILIENCE_TOOLTIP, bonus,
                                    min(bonus * RESILIENCE_CRIT_CHANCE_TO_DAMAGE_REDUCTION_MULTIPLIER, maxBonus),
                                    bonus * RESILIENCE_CRIT_CHANCE_TO_CONSTANT_DAMAGE_REDUCTION_MULTIPLIER);

            return resilience, tooltip, tooltip2
        end
    })
end

function DragonflightUICharacterStatsWrathMixin:AddStatsResistance()
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
        local petBonus = ComputePetBonus("PET_BONUS_RES", resistance);

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

        if (petBonus > 0) then tooltip2 = tooltip2 .. "\n" .. format(PET_BONUS_TOOLTIP_RESISTANCE, petBonus); end

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

DragonflightUICharacterStatsDummyMixin = {}

function DragonflightUICharacterStatsDummyMixin:OnLoad()
    -- print('DragonflightUICharacterStatsDummyMixin:OnLoad()')
    -- print('~~>> DUMMY')

    self.tt = self:CreateFontString('DragonflightUICharacterStatsDummyTooltip1', 'ARTWORK', 'GameFontNormal')
    self.tt2 = self:CreateFontString('DragonflightUICharacterStatsDummyTooltip2', 'ARTWORK', 'GameFontNormal')
    self.label = self:CreateFontString(self:GetName() .. 'Label', 'ARTWORK', 'GameFontNormal')
    self.stattext = self:CreateFontString(self:GetName() .. 'StatText', 'ARTWORK', 'GameFontNormal')

    -- self:ResetText()
end

function DragonflightUICharacterStatsDummyMixin:ResetText()
    self.tt:SetText('');
    self.tt2:SetText('');
    self.label:SetText('');
    self.stattext:SetText('');

    self.tooltip = nil;
    self.tooltip2 = nil;
end

function DragonflightUICharacterStatsDummyMixin:GetText()
    local label = self.label:GetText()
    local stat = self.stattext:GetText()
    local tt = self.tt:GetText()
    local tt2 = self.tt2:GetText()
    return label, stat, tt, tt2
    -- return self.label:GetText() or nil, self.stattext:GetText() or nil, self.tooltip:GetText() or nil,
    --        self.tooltip2:GetText() or nil
end
