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
    -- self:AddStatsSpell()
    -- self:AddStatsDefense()
    -- self:AddStatsResistance()
    -- self:AddStatsSpell()
    -- self:AddStatsSpell()
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
    self:RegisterCategory('ranged', {name = STAT_CATEGORY_RANGED, descr = 'descr..', order = 4, isExpanded = true})
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
            local Dummy = self.Dummy;
            Dummy:ResetText()
            PaperDollFrame_SetRating(Dummy, CR_HIT_MELEE);
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

DragonflightUICharacterStatsDummyMixin = {}

function DragonflightUICharacterStatsDummyMixin:OnLoad()
    print('DragonflightUICharacterStatsDummyMixin:OnLoad()')
    print('~~>> DUMMY')

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
