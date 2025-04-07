---@diagnostic disable: undefined-global, undefined-field, need-check-nil, inject-field, param-type-mismatch
DragonFlightUIProfessionSpellbookMixin = {}
local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

if not PROFESSION_RANKS then
    PROFESSION_RANKS = {};
    PROFESSION_RANKS[1] = {75, APPRENTICE};
    PROFESSION_RANKS[2] = {150, JOURNEYMAN};
    PROFESSION_RANKS[3] = {225, EXPERT};
    PROFESSION_RANKS[4] = {300, ARTISAN};
    PROFESSION_RANKS[5] = {375, MASTER};
    PROFESSION_RANKS[6] = {450, GRAND_MASTER};
    PROFESSION_RANKS[7] = {525, ILLUSTRIOUS};
end

local primary = {164, 165, 171, 182, 186, 197, 202, 333, 393, 755, 773}
local profs = {primary = {}, poison = 666, fishing = 356, cooking = 185, firstaid = 129}
for k, v in ipairs(primary) do profs.primary[v] = true end
-- DevTools_Dump(profs)

function DragonFlightUIProfessionSpellbookMixin:InitHook()
    self:SetScript('OnEvent', self.OnEvent)
    self:RegisterEvent('PLAYER_REGEN_ENABLED')
end

function DragonFlightUIProfessionSpellbookMixin:OnEvent(event, arg1, ...)
    if event == 'PLAYER_REGEN_ENABLED' then
        --
        -- print('PLAYER_REGEN_ENABLED', self.ShouldUpdate)
        if self.ShouldUpdate then self:Update() end
    end
end

function DragonFlightUIProfessionSpellbookMixin:Update()
    -- print('DragonFlightUIProfessionSpellbookMixin:Update()')

    if InCombatLockdown() then
        -- prevent unsecure update in combat TODO: message?
        self.ShouldUpdate = true
        return
    end
    self.ShouldUpdate = false

    local skillTable = {}

    for i = 1, GetNumSkillLines() do
        local nameLoc, _, _, skillRank = GetSkillLineInfo(i)

        local skillID = DragonflightUILocalizationData:GetSkillIDFromProfessionName(nameLoc)
        -- print('L:', nameLoc, skillRank, ' - ', skillID)

        -- @TODO - fix for spanish inconsistent names on Era
        if nameLoc == 'Desollar' then
            nameLoc = 'Desollando' -- skinning
            -- print('Desollar')
        elseif nameLoc == 'Costura' then
            nameLoc = 'Sastrería' -- tailoring
        elseif nameLoc == 'Marroquinería' then
            nameLoc = 'Peletería' -- tailoring
        end

        -- @TODO - same with french
        if nameLoc == 'Secourisme' then
            nameLoc = 'Premiers soins' -- first aid            
        end

        if skillID then
            --
            -- print(nameLoc, skillRank, skillID)

            local profDataTable = DFProfessionMixin.ProfessionDataTable[skillID]
            local texture = profDataTable.icon
            local spellIcon = texture

            if skillID == 182 then
                -- herbalism
                local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(2383)
                nameLoc = name
                spellIcon = icon
            elseif skillID == 186 then
                -- mining
                local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(2580)
                nameLoc = name
                spellIcon = icon
            end

            local bookID = DragonFlightUIProfessionSpellbookMixin:GetSpellBookID(nameLoc)

            local data = {
                nameLoc = nameLoc,
                skillID = skillID,
                lineID = i,
                icon = texture,
                spellIcon = spellIcon,
                bookID = bookID
            }

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
                    local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(818)
                    local fireBookID = DragonFlightUIProfessionSpellbookMixin:GetSpellBookID(name)

                    data['cookingFire'] = {
                        nameLoc = name,
                        skillID = skillID,
                        lineID = i,
                        icon = icon,
                        spellIcon = icon,
                        bookID = fireBookID
                    }
                    skillTable['cooking'] = data
                elseif skillID == profs.firstaid then
                    skillTable['firstaid'] = data
                end
            end
        end
    end

    -- DevTools_Dump(skillTable)

    self:FormatProfession(self.PrimaryProfession1, skillTable['primary1'])
    self:FormatProfession(self.PrimaryProfession2, skillTable['primary2'])

    self:FormatProfession(self.SecondaryProfession1, skillTable['poison'])
    self:FormatProfession(self.SecondaryProfession2, skillTable['fishing'])
    self:FormatProfession(self.SecondaryProfession3, skillTable['cooking'])
    self:FormatProfession(self.SecondaryProfession4, skillTable['firstaid'])
end

function DragonFlightUIProfessionSpellbookMixin:GetSpellBookID(name)
    -- print('---GetSpellBookID', name)
    local maxFinder = 69

    for i = 1, maxFinder do
        -- local spell, rank = GetSpellInfo(i, BOOKTYPE_SPELL)
        local spellName, spellSubName, spellID = GetSpellBookItemName(i, BOOKTYPE_SPELL)
        -- print(name .. ':', i, spell, rank)
        if (not spellName) then break end

        if spellName == name then
            --
            -- print('Found!', name, i)
            return i
        end
    end

    -- print('Not Found!', name)
end

local function UpdateProfessionButton(self)
    local parent = self:GetParent();
    if not parent.professionInitialized then return; end

    local data = self.Data

    if self.spellString:GetText() == data.nameLoc then
        --
        -- print('UpdateProfessionButton', 'no update needed')
        return
    end

    if InCombatLockdown() then return end -- prevent unsecure update in combat TODO: message?

    local skillType, spellID = GetSpellBookItemInfo(data.nameLoc)
    self.DFNameLoc = data.nameLoc
    self.DFSpellID = spellID

    self:SetAttribute('type1', 'spell')
    self:SetAttribute('spell', spellID)

    -- print('---', skillType, spellID, data.nameLoc)

    -- self:SetAttribute("_onclick", [[      
    --     print('_onclick') 

    --     if (IsModifiedClick('CHATLINK')) then
    --         ChatEdit_InsertLink(self.DFNameLoc)
    --     end
    -- ]]);

    -- self:SetScript('PreClick', function(self, button)
    --     --
    --     self:SetChecked(false);

    --     if IsShiftKeyDown() then
    --         -- Call a custom function on Shift+Click
    --         self:OnClick(button)
    --     elseif IsControlKeyDown() then
    --         -- Call a different custom function on Ctrl+Click
    --         self:OnClick(button)
    --     else
    --         -- Default action: cast the spell
    --         self:SetAttribute('type1', 'spell')
    --         self:SetAttribute('spell', spellID)
    --     end
    -- end)

    self.IconTexture:SetTexture(data.spellIcon)

    self.spellString:SetText(data.nameLoc);
    self.subSpellString:SetText("");

    -- if spellID then
    --     local spell = Spell:CreateFromSpellID(spellID);
    --     spell:ContinueOnSpellLoad(function()
    --         self.subSpellString:SetText(spell:GetSpellSubtext());
    --     end);
    -- end

    -- self:UpdateSelection();
end

function DragonFlightUIProfessionSpellbookMixin:FormatProfession(frame, data)
    -- print('DragonFlightUIProfessionSpellbookMixin:FormatProfession(frame,data)')
    if data then
        --
        -- print('FormatProfession DATA', frame:GetName())
        local index = data.lineID
        frame.missingHeader:Hide();
        frame.missingText:Hide();

        local skillName, isHeader, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable,
              stepCost, rankCost, minLevel, skillCostType, skillDescription = GetSkillLineInfo(index)

        frame.professionInitialized = true;
        frame.data = data

        -- print(skillName, skillRank, skillMaxRank)
        frame.statusBar:SetMinMaxValues(1, skillMaxRank);
        frame.statusBar:SetValue(skillRank);

        if frame.UnlearnButton ~= nil then
            frame.UnlearnButton:Show();
            frame.UnlearnButton:SetScript("OnClick", function()
                -- StaticPopup_Show("UNLEARN_SKILL", name, nil, skillLine);
                local dialog = StaticPopup_Show("UNLEARN_SKILL", skillName);
                if (dialog) then dialog.data = index; end
            end);
        end

        local prof_title = "";
        for i = 1, #PROFESSION_RANKS do
            local value, title = PROFESSION_RANKS[i][1], PROFESSION_RANKS[i][2];
            if skillMaxRank < value then break end
            prof_title = title;
        end
        frame.rank:SetText(prof_title);

        frame.statusBar:Show();
        if skillRank == skillMaxRank then
            frame.statusBar.capRight:Show();
        else
            frame.statusBar.capRight:Hide();
        end

        frame.statusBar.capped:Hide();
        frame.statusBar.rankText:SetTextColor(HIGHLIGHT_FONT_COLOR:GetRGB());
        frame.statusBar.tooltip = nil;

        local texture = data.icon
        if frame.icon and texture then SetPortraitToTexture(frame.icon, texture); end

        frame.professionName:SetText(skillName);

        if (skillModifier > 0) then
            frame.statusBar.rankText:SetFormattedText(TRADESKILL_RANK_WITH_MODIFIER, skillRank, skillModifier,
                                                      skillMaxRank);
        else
            frame.statusBar.rankText:SetFormattedText(TRADESKILL_RANK, skillRank, skillMaxRank);
        end

        local numSpells = data.skillID == 185 and 2 or 1 -- TODO

        local hasSpell = false;
        if numSpells <= 0 then
            frame.SpellButton1:Hide();
            frame.SpellButton2:Hide();
        elseif numSpells == 1 then
            hasSpell = true;
            frame.SpellButton1:Show();
            frame.SpellButton1.Data = data
            UpdateProfessionButton(frame.SpellButton1);

            frame.SpellButton2:Hide();
        else -- if numSpells >= 2 then
            hasSpell = true;
            frame.SpellButton1:Show();
            frame.SpellButton1.Data = data
            UpdateProfessionButton(frame.SpellButton1);

            frame.SpellButton2:Show();
            frame.SpellButton2.Data = data['cookingFire']
            UpdateProfessionButton(frame.SpellButton2);
        end

        -- if hasSpell and SpellBookFrame.showProfessionSpellHighlights and C_ProfSpecs.ShouldShowPointsReminderForSkillLine(skillLine) then
        -- 	UIFrameFlash(frame.SpellButton1.Flash, 0.5, 0.5, -1);
        -- else
        -- 	UIFrameFlashStop(frame.SpellButton1.Flash);
        -- end
    else
        -- 
        -- print('FormatProfession ELSE', frame:GetName())
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

function DragonflightUISpellButtonMixin:OnLoad()
    self:RegisterForDrag("LeftButton");
    self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function DragonflightUISpellButtonMixin:OnEvent(event, ...)
    if (event == "SPELLS_CHANGED" or event == "UPDATE_SHAPESHIFT_FORM") then
        -- need to listen for UPDATE_SHAPESHIFT_FORM because attack icons change when the shapeshift form changes
        -- self:UpdateButton();
    elseif (event == "SPELL_UPDATE_COOLDOWN") then
        -- self:UpdateCooldown();
        -- Update tooltip
        if (GameTooltip:GetOwner() == self) then self:OnEnter(); end
    elseif (event == "CURRENT_SPELL_CAST_CHANGED") then
        self:UpdateSelection();
    elseif (event == "CRAFT_SHOW" or event == "CRAFT_CLOSE" or event == "TRADE_SKILL_SHOW" or event ==
        "TRADE_SKILL_CLOSE") then
        self:UpdateSelection();
    elseif (event == "PET_BAR_UPDATE") then
        -- if (SpellBookFrame.bookType == BOOKTYPE_PET) then self:UpdateButton(); end
    elseif (event == "CURSOR_CHANGED") then
        if (self.spellGrabbed) then
            -- self:UpdateButton();
            self.spellGrabbed = false;
        end
    end
end

function DragonflightUISpellButtonMixin:OnShow()
    self:RegisterEvent("SPELLS_CHANGED");
    self:RegisterEvent("SPELL_UPDATE_COOLDOWN");
    self:RegisterEvent("CRAFT_SHOW");
    self:RegisterEvent("CRAFT_CLOSE");
    self:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
    self:RegisterEvent("CURRENT_SPELL_CAST_CHANGED");
    self:RegisterEvent("TRADE_SKILL_SHOW");
    self:RegisterEvent("TRADE_SKILL_CLOSE");
    self:RegisterEvent("PET_BAR_UPDATE");
    self:RegisterEvent("CURSOR_CHANGED");
end

function DragonflightUISpellButtonMixin:OnHide()
    self:UnregisterEvent("SPELLS_CHANGED");
    self:UnregisterEvent("SPELL_UPDATE_COOLDOWN");
    self:UnregisterEvent("CRAFT_SHOW");
    self:UnregisterEvent("CRAFT_CLOSE");
    self:UnregisterEvent("UPDATE_SHAPESHIFT_FORM");
    self:UnregisterEvent("CURRENT_SPELL_CAST_CHANGED");
    self:UnregisterEvent("TRADE_SKILL_SHOW");
    self:UnregisterEvent("TRADE_SKILL_CLOSE");
    self:UnregisterEvent("PET_BAR_UPDATE");
    self:UnregisterEvent("CURSOR_CHANGED");
end

function DragonflightUISpellButtonMixin:OnEnter()
    local slot = self.Data.bookID
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    if (GameTooltip:SetSpellBookItem(slot, BOOKTYPE_SPELL)) then
        self.UpdateTooltip = self.OnEnter;
    else
        self.UpdateTooltip = nil;
    end

    GameTooltip:Show();
end

function DragonflightUISpellButtonMixin:OnLeave()
    GameTooltip:Hide();
end

function DragonflightUISpellButtonMixin:OnClick(button)
    local slot = self.Data.bookID
    local slotType, slotID = GetSpellBookItemInfo(slot, BOOKTYPE_SPELL);

    if (IsModifiedClick("CHATLINK")) then
        if (MacroFrameText and MacroFrameText:HasFocus()) then
            local spellName, subSpellName = GetSpellBookItemName(slot, BOOKTYPE_SPELL);
            if (spellName and not IsPassiveSpell(slot, BOOKTYPE_SPELL)) then
                if (subSpellName and (strlen(subSpellName) > 0)) then
                    ChatEdit_InsertLink(spellName .. "(" .. subSpellName .. ")");
                else
                    ChatEdit_InsertLink(spellName);
                end
            end
            return;
        else
            local tradeSkillLink, tradeSkillSpellID = GetSpellTradeSkillLink(slot, BOOKTYPE_SPELL);
            if (tradeSkillSpellID) then
                ChatEdit_InsertLink(tradeSkillLink);
            else
                ChatEdit_InsertLink(GetSpellLink(slot, BOOKTYPE_SPELL));
            end
            return;
        end
    end
    if (IsModifiedClick("PICKUPACTION")) then
        PickupSpellBookItem(slot, BOOKTYPE_SPELL);
        return;
    end

    if (IsModifiedClick("SELFCAST")) then
        if self.Data.skillID == 393 then return end -- TODO
        ---@diagnostic disable-next-line: redundant-parameter
        CastSpell(slot, BOOKTYPE_SPELL, true);
        -- self:UpdateSelection();
        -- print('SELFCAST')
        return;
    end

    if (slotType == "FLYOUT") then
        -- TODO
        -- SpellFlyout:Toggle(id, self, "RIGHT", 1, false, self.offSpecID, true);
        -- SpellFlyout:SetBorderColor(181/256, 162/256, 90/256);
    else
        if self.Data.skillID == 393 then return end -- TODO
        -- CastSpell(slot, BOOKTYPE_SPELL); -- should never reach here, TODO
    end
    -- self:UpdateSelection();
end

function DragonflightUISpellButtonMixin:UpdateDragSpell()
    local slot = self.Data.bookID
    local slotType, slotID = GetSpellBookItemInfo(slot, BOOKTYPE_SPELL);

    if (not slot or slot > MAX_SPELLS or not _G[self:GetName() .. "IconTexture"]:IsShown() or
        (slotType == "FUTURESPELL")) then return; end
    self:SetChecked(false);
    PickupSpellBookItem(slot, BOOKTYPE_SPELL);
end

function DragonflightUISpellButtonMixin:OnDragStart()
    if InCombatLockdown() then return end -- Prevent dragging in combat
    self.spellGrabbed = true;
    self:UpdateDragSpell();
    if self.SpellHighlightTexture then self.SpellHighlightTexture:Hide(); end
end

function DragonflightUISpellButtonMixin:OnDragStop()
    self.dragStopped = true;
end

function DragonflightUISpellButtonMixin:OnReceiveDrag()
    -- self:UpdateDragSpell();
end

function DragonflightUISpellButtonMixin:UpdateSelection()
    local slot = self.Data.bookID
    ---@diagnostic disable-next-line: redundant-parameter
    if (slot and IsSelectedSpellBookItem(slot, BOOKTYPE_SPELL)) then
        self:SetChecked(true);
    else
        self:SetChecked(false);
    end
end
