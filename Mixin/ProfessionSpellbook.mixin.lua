DragonFlightUIProfessionSpellbookMixin = {}
local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

PROFESSION_RANKS = {};
PROFESSION_RANKS[1] = {75, APPRENTICE};
PROFESSION_RANKS[2] = {150, JOURNEYMAN};
PROFESSION_RANKS[3] = {225, EXPERT};
PROFESSION_RANKS[4] = {300, ARTISAN};
PROFESSION_RANKS[5] = {375, MASTER};
PROFESSION_RANKS[6] = {450, GRAND_MASTER};
PROFESSION_RANKS[7] = {525, ILLUSTRIOUS};

local primary = {164, 165, 171, 182, 186, 197, 202, 333, 393, 755, 773}
local profs = {primary = {}, poison = 666, fishing = 356, cooking = 185, firstaid = 129}
for k, v in ipairs(primary) do profs.primary[v] = true end
-- DevTools_Dump(profs)

function DragonFlightUIProfessionSpellbookMixin:Update()
    print('DragonFlightUIProfessionSpellbookMixin:Update()')

    local skillTable = {}

    for i = 1, GetNumSkillLines() do
        local nameLoc, _, _, skillRank = GetSkillLineInfo(i)

        local skillID = DragonflightUILocalizationData:GetSkillIDFromProfessionName(nameLoc)

        if skillID then
            --
            print(nameLoc, skillRank, skillID)

            local data = {nameLoc = nameLoc, skillID = skillID, lineID = i}

            if profs.primary[skillID] then
                --
                if skillTable['primary1'] then
                    skillTable['primary2'] = data
                else
                    skillTable['primary1'] = data
                end
            else
                --
                if skillID == profs.poison then
                    skillTable['poison'] = data
                elseif skillID == profs.fishing then
                    skillTable['fishing'] = data
                elseif skillID == profs.cooking then
                    skillTable['cooking'] = data
                elseif skillID == profs.firstaid then
                    skillTable['firstaid'] = data
                end
            end
        end
    end

    DevTools_Dump(skillTable)

    self:FormatProfession(self.PrimaryProfession1, skillTable['primary1'])
    self:FormatProfession(self.PrimaryProfession2, skillTable['primary2'])
end

function DragonFlightUIProfessionSpellbookMixin:FormatProfession(frame, data)
    print('DragonFlightUIProfessionSpellbookMixin:FormatProfession(frame,data)')
    if data then
        --
        print('FormatProfession DATA', frame:GetName())
        local index = data.lineID
        frame.missingHeader:Hide();
        frame.missingText:Hide();

        local skillName, isHeader, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable,
              stepCost, rankCost, minLevel, skillCostType, skillDescription = GetSkillLineInfo(index)

        print(skillName, skillRank, skillMaxRank)
        frame.statusBar:SetMinMaxValues(1, skillMaxRank);
        frame.statusBar:SetValue(skillRank);

        if frame.UnlearnButton ~= nil then
            frame.UnlearnButton:Show();
            -- frame.UnlearnButton:SetScript("OnClick", function() 
            -- 	StaticPopup_Show("UNLEARN_SKILL", name, nil, skillLine);
            -- end);
        end

        local prof_title = "";
        for i = 1, #PROFESSION_RANKS do
            local value, title = PROFESSION_RANKS[i][1], PROFESSION_RANKS[i][2];
            if skillMaxRank < value then break end
            prof_title = title;
        end
        frame.rank:SetText(prof_title);

        frame.statusBar:Show();
        if rank == skillMaxRank then
            frame.statusBar.capRight:Show();
        else
            frame.statusBar.capRight:Hide();
        end

        -- frame.statusBar.capped:Hide();
        frame.statusBar.rankText:SetTextColor(HIGHLIGHT_FONT_COLOR:GetRGB());
        frame.statusBar.tooltip = nil;

        local profDataTable = DragonFlightUIProfessionMixin.ProfessionDataTable[data.skillID]
        local texture = profDataTable.icon

        if frame.icon and texture then SetPortraitToTexture(frame.icon, texture); end

        frame.professionName:SetText(skillName);

        if (skillModifier > 0) then
            frame.statusBar.rankText:SetFormattedText(TRADESKILL_RANK_WITH_MODIFIER, skillRank, rankModifier,
                                                      skillMaxRank);
        else
            frame.statusBar.rankText:SetFormattedText(TRADESKILL_RANK, skillRank, skillMaxRank);
        end

        local numSpells = 1 -- TODO

        local hasSpell = false;
        if numSpells <= 0 then
            frame.SpellButton1:Hide();
            frame.SpellButton2:Hide();
        elseif numSpells == 1 then
            hasSpell = true;
            frame.SpellButton2:Hide();
            frame.SpellButton1:Show();
            -- UpdateProfessionButton(frame.SpellButton1);
        else -- if numSpells >= 2 then
            hasSpell = true;
            frame.SpellButton1:Show();
            frame.SpellButton2:Show();
            -- UpdateProfessionButton(frame.SpellButton1);
            -- UpdateProfessionButton(frame.SpellButton2);
        end

        -- if hasSpell and SpellBookFrame.showProfessionSpellHighlights and C_ProfSpecs.ShouldShowPointsReminderForSkillLine(skillLine) then
        -- 	UIFrameFlash(frame.SpellButton1.Flash, 0.5, 0.5, -1);
        -- else
        -- 	UIFrameFlashStop(frame.SpellButton1.Flash);
        -- end
    else
        -- 
        print('FormatProfession ELSE', frame:GetName())
        frame.missingHeader:Show();
        frame.missingText:Show();

        if frame.icon then
            SetPortraitToTexture(frame.icon, "Interface\\Icons\\INV_Scroll_04");
            frame.specialization:SetText("");
        end
        frame.SpellButton1:Hide();
        frame.SpellButton2:Hide();
        frame.statusBar:Hide();
        frame.rank:SetText("");
        frame.professionName:SetText("");

        if frame.UnlearnButton ~= nil then frame.UnlearnButton:Hide(); end
    end
end

--

DragonflightUIProfessionsUnlearnButtonMixin = {}

function DragonflightUIProfessionsUnlearnButtonMixin:OnEnter()
    self.Icon:SetAlpha(1.0);
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    GameTooltip:SetText(UNLEARN_SKILL_TOOLTIP);
end

function DragonflightUIProfessionsUnlearnButtonMixin:OnLeave()
    self.Icon:SetAlpha(0.75);
    GameTooltip_Hide();
end

function DragonflightUIProfessionsUnlearnButtonMixin:OnMouseDown()
    self.Icon:SetPoint("TOPLEFT", 1, -1);
end

function DragonflightUIProfessionsUnlearnButtonMixin:OnMouseUp()
    self.Icon:SetPoint("TOPLEFT", 0, 0);
end

--
DragonflightUISpellButtonMixin = {}
