DragonflightUITalentsPanelMixin = {}

local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

function DragonflightUITalentsPanelMixin:OnLoad()
end

function DragonflightUITalentsPanelMixin:OnShow()
end

function DragonflightUITalentsPanelMixin:OnHide()
end

function DragonflightUITalentsPanelMixin:OnEvent()
end

function DragonflightUITalentsPanelMixin:Init(id)
    self.ID = id
    local panel = self:GetName()

    for i = 1, 28 do
        local buttonName = panel .. 'Talent' .. i
        local button = _G[buttonName]

        button.panelID = id
        button:SetID(i)
        button.talentID = i

        local anchorFrame = CreateFrame('FRAME', nil, self)
        anchorFrame:SetSize(30, 30)
        anchorFrame:SetPoint('CENTER', self, 'CENTER', 0, 0)

        button:ClearAllPoints()
        button:SetPoint('CENTER', anchorFrame, 'CENTER', 0, 0)

        button.anchorFrame = anchorFrame

        -- events

        button:SetScript('OnEnter', function(self)
            --                    
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
            GameTooltip:SetTalent(id, i)
        end)

        button:SetScript('OnEvent', function(self, event, ...)
            --
            if (GameTooltip:IsOwned(self)) then GameTooltip:SetTalent(id, i) end
        end)

        button:SetScript('OnClick', function(self, button)
            --                    
            DragonflightUITalentsPanelMixin:ButtonOnClick(self, button)
        end)

        button:RegisterEvent("PREVIEW_TALENT_POINTS_CHANGED");
        button:RegisterEvent("PLAYER_TALENT_UPDATE");
        button:RegisterEvent("PET_TALENT_UPDATE");
    end

    self.RoleIcon = _G[panel .. 'RoleIcon']
    self.RoleIcon2 = _G[panel .. 'RoleIcon2']
    DragonflightUITalentsPanelMixin:UpdateRoleIcon(self, id)
end

function DragonflightUITalentsPanelMixin:ButtonOnClick(self, button)
    -- print('DragonflightUITalentsPanelMixin:ButtonOnClick(self, button)', self:GetName(), button)
    local panelID = self.panelID
    local talentID = self.talentID

    if (IsModifiedClick("CHATLINK")) then
        --
        local link = GetTalentLink(panelID, talentID)
        if link then ChatEdit_InsertLink(link) end
    else
        --
        if button == 'LeftButton' then
            --
            LearnTalent(panelID, talentID)
        end
    end
end

function DragonflightUITalentsPanelMixin:Refresh()
    print('DragonflightUITalentsPanelMixin:Refresh()', self.ID)

    local panelID = self.ID
    local panel = self:GetName()

    local id, name, description, iconTexture, pointsSpent, background, previewPointsSpent, isUnlocked =
        GetTalentTabInfo(panelID)
    print(id, name, description, iconTexture, pointsSpent, background, previewPointsSpent, isUnlocked)

    -- header
    do
        local headerName = _G[panel .. 'Name']
        headerName:SetText(name)

        local headerIcon = _G[panel .. 'HeaderIconIcon']
        headerIcon:SetTexture(iconTexture)

        local headerPointsSpent = _G[panel .. 'HeaderIconPointsSpent']
        headerPointsSpent:SetText(pointsSpent)
    end

    -- background
    do
        local bg = _G[panel .. 'BackgroundTopLeft']
        -- bg:SetTexture()
    end

    -- talents

    do
        --
        local numTalents = GetNumTalents(panelID);

        local unspentTalentPoints, learnedProfessions = UnitCharacterPoints("player")

        for i = 1, 28 do
            local buttonName = panel .. 'Talent' .. i
            local button = _G[buttonName]
            local forceDesaturated, tierUnlocked;
            if i <= numTalents then
                local name, iconPath, tier, column, currentRank, maxRank, isExceptional, meetsPrereq = GetTalentInfo(
                                                                                                           panelID, i);

                if name then
                    _G[buttonName .. 'Rank']:SetText(currentRank)

                    -- position
                    do
                        local offsetX = 20
                        local offsetY = -52
                        local size = 46

                        local x = ((column - 1) * size) + offsetX
                        local y = -((tier - 1) * size) + offsetY

                        -- button:SetSize(25, 25)
                        local anchor = button.anchorFrame
                        anchor:ClearAllPoints()
                        anchor:SetPoint('TOPLEFT', self, 'TOPLEFT', x, y)

                        button:SetScale(30 / 37)
                    end

                    if unspentTalentPoints <= 0 and rank == 0 then
                        forceDesaturated = 1;
                    else
                        forceDesaturated = nil;
                    end

                    local tierUnlocked;
                    -- is this talent's tier unlocked?
                    if (((tier - 1) * (PLAYER_TALENTS_PER_TIER) <= pointsSpent)) then
                        tierUnlocked = 1;
                    else
                        tierUnlocked = nil;
                    end

                    SetItemButtonTexture(button, iconPath);

                    -- Talent must meet prereqs or the player must have no points to spend
                    --[[    local prereqsSet = TalentFrame_SetPrereqs(TalentFrame, tier, column, forceDesaturated, tierUnlocked,
                                                              preview, GetTalentPrereqs(selectedTab, i,
                                                                                        TalentFrame.inspect,
                                                                                        TalentFrame.pet,
                                                                                        TalentFrame.talentGroup)); ]]
                    local prereqsSet = DragonflightUITalentsPanelMixin:SetPrereqs(tier, column, forceDesaturated,
                                                                                  tierUnlocked, false,
                                                                                  GetTalentPrereqs(panelID, i))
                    if prereqsSet then
                        SetItemButtonDesaturated(button, nil);

                        if (currentRank < maxRank) then
                            -- Rank is green if not maxed out
                            _G[buttonName .. "Slot"]:SetVertexColor(0.1, 1.0, 0.1);
                            _G[buttonName .. "Rank"]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g,
                                                                  GREEN_FONT_COLOR.b);
                        else
                            _G[buttonName .. "Slot"]:SetVertexColor(1.0, 0.82, 0);
                            _G[buttonName .. "Rank"]:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g,
                                                                  NORMAL_FONT_COLOR.b);
                        end
                        _G[buttonName .. "RankBorder"]:Show();
                        _G[buttonName .. "Rank"]:Show();
                    else
                        SetItemButtonDesaturated(button, 1, 0.65, 0.65, 0.65);
                        _G[buttonName .. "Slot"]:SetVertexColor(0.5, 0.5, 0.5);
                        if (rank == 0) then
                            _G[buttonName .. "RankBorder"]:Hide();
                            _G[buttonName .. "Rank"]:Hide();
                        else
                            _G[buttonName .. "RankBorder"]:SetVertexColor(0.5, 0.5, 0.5);
                            _G[buttonName .. "Rank"]:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g,
                                                                  GRAY_FONT_COLOR.b);
                        end
                    end

                    button:Show()
                else
                    button:Hide()
                end
            else
                button:Hide()
            end
        end
    end
end

function DragonflightUITalentsPanelMixin:SetPrereqs(buttonTier, buttonColumn, forceDesaturated, tierUnlocked, preview, ...)
    local requirementsMet = tierUnlocked and not forceDesaturated;
    for i = 1, select("#", ...), 4 do
        local tier, column, isLearnable, isPreviewLearnable = select(i, ...);
        if (forceDesaturated or (preview and not isPreviewLearnable) or (not preview and not isLearnable)) then
            requirementsMet = nil;
        end
        -- TODO
        -- TalentFrame_DrawLines(buttonTier, buttonColumn, tier, column, requirementsMet, TalentFrame);
    end
    return requirementsMet;
end

-- 'DAMAGER', 'TANK', 'HEALER'
local PlayerClassRoleTable = {
    {{'DAMAGER'}, {'DAMAGER'}, {'TANK'}}, -- Warrior
    {{'HEALER'}, {'TANK'}, {'DAMAGER'}}, -- Paladin 
    {{'DAMAGER'}, {'DAMAGER'}, {'DAMAGER'}}, -- Hunter 
    {{'DAMAGER'}, {'DAMAGER'}, {'DAMAGER'}}, -- Rogue 
    {{'HEALER'}, {'HEALER'}, {'DAMAGER'}}, -- Priest  
    {{'TANK'}, {'DAMAGER'}, {'DAMAGER'}}, -- DeathKnight 
    {{'DAMAGER'}, {'DAMAGER', 'TANK'}, {'HEALER'}}, -- Shaman 
    {{'DAMAGER', 'HEALER'}, {'DAMAGER'}, {'DAMAGER'}}, -- Mage 
    {{'DAMAGER'}, {'DAMAGER'}, {'DAMAGER'}}, -- Warlock 
    {{'DAMAGER'}, {'DAMAGER'}, {'DAMAGER'}}, -- Monk 
    {{'DAMAGER'}, {'DAMAGER', 'TANK'}, {'HEALER'}}, -- Druid 
    {{'DAMAGER'}, {'DAMAGER'}, {'DAMAGER'}} -- Demon Hunter 
}

function DragonflightUITalentsPanelMixin:GetPlayerRole(panelID)
    local localizedClass, englishClass, classIndex = UnitClass('player');

    local roleData = PlayerClassRoleTable[classIndex][panelID]

    return roleData[1], roleData[2]
end

function DragonflightUITalentsPanelMixin:UpdateRoleIcon(self, panelID)
    -- local role1, role2 = GetTalentTreeRoles(self.talentTree, self.inspect, self.pet); 
    -- local role1, role2 = 'TANK', 'TANK'
    local role1, role2 = DragonflightUITalentsPanelMixin:GetPlayerRole(panelID)

    -- swap roles to match order on the summary screen
    if (role2) then role1, role2 = role2, role1; end

    -- Update roles
    if (role1 == "TANK" or role1 == "HEALER" or role1 == "DAMAGER") then
        self.RoleIcon.Icon:SetTexCoord(GetTexCoordsForRoleSmall(role1));
        self.RoleIcon:Show();
        self.RoleIcon.role = role1;
    else
        self.RoleIcon:Hide();
    end

    if (role2 == "TANK" or role2 == "HEALER" or role2 == "DAMAGER") then
        self.RoleIcon2.Icon:SetTexCoord(GetTexCoordsForRoleSmall(role2));
        self.RoleIcon2:Show();
        self.RoleIcon2.role = role2;
    else
        self.RoleIcon2:Hide();
    end
end
