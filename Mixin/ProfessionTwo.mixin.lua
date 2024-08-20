DragonFlightUIProfessionCraftMixin = {}
local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

--
local frameRef = nil
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

function DragonFlightUIProfessionCraftMixin:OnLoad()
    self:SetupFrameStyle()

    self:RegisterEvent("CRAFT_SHOW");
    self:RegisterEvent("CRAFT_CLOSE");
    self:RegisterEvent("CRAFT_UPDATE");
    self:RegisterEvent("SPELLS_CHANGED");
    self:RegisterEvent("UNIT_PET_TRAINING_POINTS");

    self.anchored = false
    self.currentTradeSkillName = ''
    self.currentSkillID = nil

    self.MinimizeButton:SetOnMaximizedCallback(function(btn)
        -- print('SetOnMaximizedCallback')
        self:Minimize(false)
    end)
    self.MinimizeButton:SetOnMinimizedCallback(function(btn)
        -- print('SetOnMinimizedCallback')
        self:Minimize(true)
    end)

    self.minimized = false

    self.ClosePanelButton:SetScript("OnClick", function(btn)
        --     
        HideUIPanel(CraftFrame)
    end);

    self.RecipeList.ResetButton:SetScript('OnClick', function(btn)
        --
        self:ResetFilter()
        self:FilterDropdownRefresh()
        self:Refresh(false)
    end)

    frameRef = self
    self:SetupFavoriteDatabase()

    CraftFrame:HookScript('OnShow', function()
        self:Show()
    end)
end

function DragonFlightUIProfessionCraftMixin:OnShow()
    -- print('DragonFlightUIProfessionCraftMixin:OnShow()')
    self:AnchorButtons()
    if not self.anchored then
        self.anchored = true

        -- self:AnchorButtons()
        self:AnchorSchematics()
        self:HideDefault()
        self:SetupFavorite()

        -- self:SetParent(TradeSkillFrame)
        -- self:SetPoint('TOPLEFT', TradeSkillFrame, 'TOPRIGHT', 0, 0)
        self:SetPoint('TOPLEFT', CraftFrame, 'TOPLEFT', 12, -12)

        CraftFrame:SetFrameStrata('BACKGROUND')
        self:SetFrameStrata('MEDIUM')

        self.Bg:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 3)

        local top = self.Bg.TopSection
        top:SetTexture(base .. 'ui-background-rock')
        top:ClearAllPoints()
        top:SetPoint('TOPLEFT', self.Bg, 'TOPLEFT', 0, 0)
        top:SetPoint('BOTTOMRIGHT', self.Bg.BottomRight, 'BOTTOMRIGHT', 0, 0)
        top:SetDrawLayer('BACKGROUND', 2)

        local bg = _G['DragonflightUIProfessionFrameBg']
        bg:Hide()

        local newBG = self:CreateTexture('DragonflightUIRecipeListBG')
        newBG:SetTexture(base .. 'professions')
        newBG:SetTexCoord(0.000488281, 0.131348, 0.0771484, 0.635742)
        newBG:SetSize(268, 572)
        newBG:ClearAllPoints()
        newBG:SetPoint('TOPLEFT', self.RecipeList, 'TOPLEFT', 0, 0)
        newBG:SetPoint('BOTTOMRIGHT', self.RecipeList, 'BOTTOMRIGHT', 0, 0)

        self.NineSlice.Text:SetText('tmp')

        local titleFrame = CreateFrame('Frame', 'DragonflightUITitleFrame')
        titleFrame:SetPoint('TOP', self.NineSlice, 'TOP', 0, -2)
        titleFrame:SetPoint('LEFT', self.NineSlice, 'LEFT', 60, 0)
        titleFrame:SetPoint('RIGHT', self.NineSlice, 'RIGHT', -60, 0)
        titleFrame:SetHeight(self.NineSlice.Text:GetHeight())

        self.NineSlice.Text:ClearAllPoints()
        self.NineSlice.Text:SetPoint('CENTER', titleFrame, 'CENTER', 0, 0)

        local linkButton = self.LinkButton
        linkButton:ClearAllPoints()
        linkButton:SetPoint('LEFT', self.NineSlice.Text, 'RIGHT', 5, 0)
    end

    self:Refresh(true)
end

function DragonFlightUIProfessionCraftMixin:OnHide()

end

function DragonFlightUIProfessionCraftMixin:Refresh(force)
    self:AnchorButtons()
    self:UpdateHeader()
    -- self:UpdateRecipeName()
    self:CheckFilter()

    do
        local name, rank, maxRank = GetCraftDisplaySkillLine();
        --[[  if (rank < 75) and (not IsTradeSkillLinked()) then
            self.RecipeList.SearchBox:Disable()
        else
            self.RecipeList.SearchBox:Enable()
        end
        ]]
        if self.currentTradeSkillName ~= name then
            --[[   UIDropDownMenu_Initialize(frameRef.RecipeList.FilterDropDown,
                                      DragonFlightUIProfessionCraftMixin.FilterDropdownInitialize, 'MENU'); ]]
            DragonFlightUIProfessionCraftMixin:FilterDropdownUpdate()

            self.currentTradeSkillName = name
        end
    end

    self.RecipeList:Refresh(force)
end

function DragonFlightUIProfessionCraftMixin:Minimize(minimize)
    -- print('DragonFlightUIProfessionCraftMixin:Minimize(minimize)', minimize)
    self.minimized = minimize

    if minimize then
        -- 
        self:SetWidth(404)
        self:UpdateUIPanelWindows(false)

        self.RecipeList:Hide()
        self.RecipeList:SetWidth(0.1)

        self.RankFrame:Hide()

        self.SchematicForm.NineSlice:Hide()
        self.SchematicForm.BackgroundNineSlice:Hide()
        self.SchematicForm.Background:Hide()
        self.SchematicForm.MinimalBackground:Show()

        CraftCreateButton:ClearAllPoints()
        CraftCreateButton:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -9, 13)
    else
        --
        self:SetWidth(942)
        self:UpdateUIPanelWindows(true)

        self.RecipeList:Show()
        self.RecipeList:SetWidth(274)

        self.RankFrame:Show()

        self.SchematicForm.NineSlice:Show()
        self.SchematicForm.BackgroundNineSlice:Show()
        self.SchematicForm.Background:Show()
        self.SchematicForm.MinimalBackground:Hide()

        CraftCreateButton:ClearAllPoints()
        CraftCreateButton:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -9, 7)

        self:Refresh(true)
    end
end

function DragonFlightUIProfessionCraftMixin:UpdateUIPanelWindows(big)
    if big then
        CraftFrame:SetAttribute("UIPanelLayout-width", 942);
    else
        CraftFrame:SetAttribute("UIPanelLayout-width", 404);
    end
    UpdateUIPanelPositions(CraftFrame)
end

function DragonFlightUIProfessionCraftMixin:OnEvent(event, arg1, ...)
    -- print('ProfessionMixin', event)

    if event == 'CRAFT_SHOW' then
        self:Show()
        self:Refresh(false)
    elseif event == 'CRAFT_CLOSE' then
        self:Hide()
    else
        if self:IsShown() then self:Refresh(false) end
    end
    --[[ 
    if event == 'CRAFT_UPDATE' or event == 'TRADE_SKILL_FILTER_UPDATE' then
        if self:IsShown() then self:Refresh(false) end
    end ]]
    -- SPELLS_CHANGED
    -- UNIT_PET_TRAINING_POINTS 
end

function DragonFlightUIProfessionCraftMixin:HideDefault()
    CraftFrame:SetFrameStrata('BACKGROUND')
end

function DragonFlightUIProfessionCraftMixin:SetupFrameStyle()
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(self)
    DragonflightUIMixin:MaximizeMinimizeButtonFrameTemplate(self.MinimizeButton)
    self.MinimizeButton:ClearAllPoints()
    self.MinimizeButton:SetPoint('RIGHT', self.ClosePanelButton, 'LEFT', 0, 0)

    local icon = self:CreateTexture('DragonflightUIProfessionIcon')
    icon:SetSize(62, 62)
    icon:SetPoint('TOPLEFT', self, 'TOPLEFT', -5, 7)
    icon:SetDrawLayer('OVERLAY', 6)
    self.Icon = icon

    local pp = self:CreateTexture('DragonflightUIProfessionoIconFrame')
    pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
    pp:SetTexCoord(0.0078125, 0.0078125, 0.0078125, 0.6171875, 0.6171875, 0.0078125, 0.6171875, 0.6171875)
    pp:SetSize(84, 84)
    pp:SetPoint('CENTER', icon, 'CENTER', 0, 0)
    pp:SetDrawLayer('OVERLAY', 7)
    self.PortraitFrame = pp

    local rankFrame = CreateFrame('Frame', 'DragonflightUIRankFrame', self)
    rankFrame:SetSize(453, 18)
    rankFrame:SetPoint('TOPLEFT', self, 'TOPLEFT', 280, -40)

    local rankFrameBG = rankFrame:CreateTexture('DragonflightUIRankFrameBackground')
    rankFrameBG:SetDrawLayer('BACKGROUND', 1)
    rankFrameBG:SetTexture(base .. 'professions')
    rankFrameBG:SetTexCoord(0.29834, 0.518555, 0.750977, 0.779297)
    rankFrameBG:SetSize(451, 29)
    rankFrameBG:SetPoint('TOPLEFT', rankFrame, 'TOPLEFT', 0, 0)

    local rankFrameBar = CreateFrame('Statusbar', 'DragonflightUIRankFrameBar', self)
    rankFrameBar:SetSize(441, 18)
    rankFrameBar:SetPoint('TOPLEFT', rankFrame, 'TOPLEFT', 5, -3)
    rankFrameBar:SetMinMaxValues(0, 100);
    rankFrameBar:SetValue(69);
    rankFrameBar:SetStatusBarTexture(base .. 'professionsfxalchemy')

    local rankFrameMask = rankFrame:CreateMaskTexture('DragonflightUIRankFrameMask')
    rankFrameMask:SetPoint('TOPLEFT', rankFrameBar, 'TOPLEFT', 0, 0)
    rankFrameMask:SetPoint('BOTTOMRIGHT', rankFrameBar, 'BOTTOMRIGHT', 0, 0)
    rankFrameMask:SetTexture(base .. 'profbarmask', "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    rankFrameBar:GetStatusBarTexture():AddMaskTexture(rankFrameMask)

    -- profbarmask

    local rankFrameBorder = rankFrame:CreateTexture('DragonflightUIRankFrameBorder')
    rankFrameBorder:SetDrawLayer('OVERLAY', 1)
    rankFrameBorder:SetTexture(base .. 'professions')
    rankFrameBorder:SetTexCoord(0.663574, 0.883789, 0.129883, 0.158203)
    rankFrameBorder:SetSize(451, 29)
    rankFrameBorder:SetPoint('TOPLEFT', rankFrame, 'TOPLEFT', 0, 0)

    --  ["Professions-skillbar-bg"]={451, 29, 0.29834, 0.518555, 0.750977, 0.779297, false, false, "1x"},
    -- ["Professions-skillbar-frame"]={451, 29, 0.663574, 0.883789, 0.129883, 0.158203, false, false, "1x"},

    local rankFrameText = rankFrame:CreateFontString('', 'ARTWORK', 'GameFontHighlightSmall')
    rankFrameText:SetPoint('CENTER', rankFrameBar, 'CENTER', 0, 0)
    rankFrameText:SetText('69/100')

    function rankFrame:UpdateRankFrame(value, minValue, maxValue)
        rankFrameBar:SetMinMaxValues(minValue, maxValue)
        rankFrameBar:SetValue(value)

        rankFrameText:SetText(value .. '/' .. maxValue)
    end

    self.RankFrame = rankFrame
    self.RankFrameBar = rankFrameBar
    self.RankFrameText = rankFrameText
end

function DragonFlightUIProfessionCraftMixin:AnchorButtons()
    local create = CraftCreateButton
    create:ClearAllPoints()
    create:SetParent(self)
    create:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -9, 7)

    local points = CraftFramePointsText
    points:ClearAllPoints()
    points:SetParent(self)
    points:SetPoint('RIGHT', create, 'LEFT', -20, 0)

    local label = CraftFramePointsLabel
    label:ClearAllPoints()
    label:SetParent(self)
    label:SetPoint('RIGHT', points, 'LEFT', -5, 0)
end

function DragonFlightUIProfessionCraftMixin:SetupFavorite()
    local fav = self.FavoriteButton
    fav:SetPoint('LEFT', CraftName, 'RIGHT', 4, 1)
    -- fav:SetPoint('LEFT', self, 'RIGHT', 20, 0)

    fav:GetNormalTexture():SetTexture(base .. 'auctionhouse')
    -- fav:GetNormalTexture():SetTexCoord(0.94043, 0.979492, 0.0957031, 0.166016)
    fav:GetNormalTexture():SetTexCoord(0.94043, 0.979492, 0.169922, 0.240234)

    fav:GetHighlightTexture():SetTexture(base .. 'auctionhouse')
    fav:GetHighlightTexture():SetTexCoord(0.94043, 0.979492, 0.169922, 0.240234)

    function fav:SetIsFavorite(isFavorite)
        if isFavorite then
            fav:GetNormalTexture():SetTexCoord(0.94043, 0.979492, 0.0957031, 0.166016)
            fav:GetHighlightTexture():SetTexCoord(0.94043, 0.979492, 0.0957031, 0.166016)
            fav:GetHighlightTexture():SetAlpha(0.2)
        else
            fav:GetNormalTexture():SetTexCoord(0.94043, 0.979492, 0.169922, 0.240234)
            fav:GetHighlightTexture():SetTexCoord(0.94043, 0.979492, 0.169922, 0.240234)
            fav:GetHighlightTexture():SetAlpha(0.4)
        end
        fav.IsFavorite = isFavorite
        fav:SetChecked(isFavorite)
    end
    -- fav:SetIsFavorite(false)  

    function fav:UpdateFavoriteState()
        local craftIndex = GetCraftSelectionIndex();
        -- local skillName, skillType, numAvailable, isExpanded, altVerb, numSkillUps = GetTradeSkillInfo(tradeSkillIndex)
        local skillName, craftSubSpellName, skillType, numAvailable, isExpanded, trainingPointCost, requiredLevel =
            GetCraftInfo(craftIndex)
        fav:SetIsFavorite(frameRef:IsRecipeFavorite(skillName))

        fav:ClearAllPoints()
        local width = CraftName:GetWrappedWidth()
        fav:SetPoint('LEFT', CraftName, 'LEFT', width + 4, 1)
    end
    fav:UpdateFavoriteState()

    local function SetFavoriteTooltip(button)
        GameTooltip:SetOwner(button, "ANCHOR_RIGHT");
        GameTooltip_AddHighlightLine(GameTooltip, button:GetChecked() and BATTLE_PET_UNFAVORITE or BATTLE_PET_FAVORITE);
        GameTooltip:Show();
    end

    fav:SetScript('OnClick', function(button, buttonName, down)
        local checked = button:GetChecked();
        -- C_TradeSkillUI.SetRecipeFavorite(currentRecipeInfo.recipeID, checked);
        do
            local craftIndex = GetCraftSelectionIndex();
            local skillName, craftSubSpellName, skillType, numAvailable, isExpanded, trainingPointCost, requiredLevel =
                GetCraftInfo(craftIndex)
            local info = skillName

            frameRef:SetRecipeFavorite(info, checked)
            frameRef:Refresh(false)
        end
        button:SetIsFavorite(checked)
        SetFavoriteTooltip(button)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
    end)

    fav:SetScript("OnEnter", function(button)
        SetFavoriteTooltip(button);
    end);

    fav:SetScript("OnLeave", GameTooltip_Hide);
end

function DragonFlightUIProfessionCraftMixin:SetupFavoriteDatabase()
    -- print('DragonFlightUIProfessionCraftMixin:SetupFavoriteDatabase()')
    self.db = DF.db:RegisterNamespace('RecipeCraftFavorite', {profile = {favorite = {}}})

    -- DevTools_Dump(self.db.profile)
end

function DragonFlightUIProfessionCraftMixin:SetRecipeFavorite(info, checked)
    -- print('DragonFlightUIProfessionCraftMixin:SetRecipeFavorite(info,checked)', info, checked)
    local db = frameRef.db.profile

    if checked then
        db.favorite[info] = true
    else
        db.favorite[info] = nil
    end
end

function DragonFlightUIProfessionCraftMixin:IsRecipeFavorite(info)
    local db = frameRef.db.profile

    if db.favorite[info] then
        return true
    else
        return false
    end
end

function DragonFlightUIProfessionCraftMixin:GetIconOverlayTexCoord(quality)
    if quality == 0 then
        -- poor
        return 0.32959, 0.349121, 0.000976562, 0.0400391
    elseif quality == 1 then
        -- common
        return 0.32959, 0.349121, 0.000976562, 0.0400391
    elseif quality == 2 then
        -- uncommon
        return 0.411621, 0.431152, 0.0273438, 0.0664062
    elseif quality == 3 then
        -- rare
        return 0.377441, 0.396973, 0.0273438, 0.0664062
    elseif quality == 4 then
        -- epic
        return 0.579102, 0.598633, 0.0351562, 0.0742188
    elseif quality == 5 then
        -- legendary
        return 0.558594, 0.578125, 0.0351562, 0.0742188
    else
        -- fallback
        return 0.32959, 0.349121, 0.000976562, 0.0400391
    end
end

function DragonFlightUIProfessionCraftMixin:AnchorSchematics()
    local frame = self.SchematicForm
    -- frame.NineSlice:SetFrameLevel(2)
    -- frame.NineSlice:SetAlpha(0.25)

    local icon = CraftIcon
    -- icon:ClearAllPoints()
    icon:SetParent(frame)
    icon:SetPoint('TOPLEFT', frame, 'TOPLEFT', 28 - 400 + 400, -28)
    -- icon:SetPoint('TOPLEFT', TradeSkillDetailScrollChildFrame, 'TOPLEFT', 28, -28)

    --[[     if not icon.DFOverlay then
        local overlay = frame:CreateTexture('DragonflightUIOverlay')
        overlay:SetTexture(base .. 'professions')
        overlay:SetSize(40, 40)
        overlay:SetTexCoord(0.32959, 0.349121, 0.000976562, 0.0400391)
        overlay:SetPoint('TOPLEFT', icon, 'TOPLEFT')
        overlay:SetPoint('BOTTOMRIGHT', icon, 'BOTTOMRIGHT')
        icon.DFOverlay = overlay
    end ]]

    local name = CraftName
    name:ClearAllPoints()
    name:SetParent(frame)
    -- name:SetPoint('LEFT', icon, 'RIGHT', 14, 17)
    name:SetPoint('TOPLEFT', icon, 'TOPRIGHT', 14, 0)

    local req = CraftRequirements
    req:ClearAllPoints()
    req:SetParent(frame)
    req:SetPoint('TOPLEFT', name, 'BOTTOMLEFT', 0, -4)

    --[[     local reqText = TradeSkillRequirementText
    reqText:ClearAllPoints()
    reqText:SetParent(frame)
    -- reqText:SetSize(180,9.9)
    reqText:SetSize(250, 9.9)
    -- reqText:SetJustifyH("LEFT");
    reqText:SetPoint('LEFT', req, 'RIGHT', 4, 0) ]]

    if CraftDescription then
        local descr = CraftDescription
        descr:ClearAllPoints()
        descr:SetParent(frame)
        descr:SetPoint('TOPLEFT', icon, 'BOTTOMLEFT', -1, -12)
    else
        local reagentLabel = CraftReagentLabel
        reagentLabel:ClearAllPoints()
        reagentLabel:SetParent(frame)
        reagentLabel:SetPoint('TOPLEFT', icon, 'BOTTOMLEFT', -1, -12)
    end

    local reagentLabel = CraftReagentLabel
    --   reagentLabel:ClearAllPoints()
    reagentLabel:SetParent(frame)
    -- reagentLabel:SetPoint('TOPLEFT', TradeSkillDescription, 'BOTTOMLEFT', 0, -20)

    --[[ local cooldown = CraftCooldown
    cooldown:SetParent(frame) ]]

    for i = 1, MAX_CRAFT_REAGENTS do
        --
        local reagent = _G['CraftReagent' .. i]
        reagent:ClearAllPoints()
        reagent:SetParent(frame)
        reagent:SetPoint('TOPLEFT', reagentLabel, 'TOPLEFT', 1, -23 - (i - 1) * 45)
        -- <Size x="147" y="41" />
        -- DF: <Size x="180" y="50"/>
        reagent:SetSize(180, 50)

        local reagentIcon = _G['CraftReagent' .. i .. 'IconTexture']
        -- reagentIcon:SetSize() 
        reagentIcon:ClearAllPoints()
        reagentIcon:SetPoint('LEFT', reagent, 'LEFT', 0, 0)

        local overlay = DragonflightUIItemColorMixin:AddOverlayToFrame(reagent)
        overlay:SetPoint('TOPLEFT', reagentIcon, 'TOPLEFT', 0, 0)
        overlay:SetPoint('BOTTOMRIGHT', reagentIcon, 'BOTTOMRIGHT', 0, 0)

        local reagentCountText = _G["CraftReagent" .. i .. "Count"];
        reagentCountText:Hide()
        local reagentNameText = _G['CraftReagent' .. i .. 'Name']
        reagentNameText:ClearAllPoints()
        reagentNameText:SetPoint('LEFT', reagent, 'LEFT', 46, 0)
        -- <Size x="90" y="36" />
        -- DF: <Size x="108" y="36" />
        -- reagentNameText:SetSize(108, 36)
        reagentNameText:SetSize(142, 36)
        reagentNameText:SetJustifyH("LEFT");

        local updateText = function()
            local index = GetCraftSelectionIndex()
            local reagentName, reagentTexture, reagentCount, playerReagentCount = GetCraftReagentInfo(index, i);

            if (not reagentName or not reagentTexture) then return end

            local newText = playerReagentCount .. "/" .. reagentCount .. ' ' .. reagentName

            reagentNameText:SetText(newText)

            local link = GetCraftReagentItemLink(index, i)

            if link then
                local quality, _, _, _, _, _, _, _, _, classId = select(3, GetItemInfo(link));
                if (classId == 12) then quality = 0; end
                DragonflightUIItemColorMixin:UpdateOverlayQuality(reagent, quality)
            end
        end

        hooksecurefunc(reagentCountText, 'SetText', function()
            updateText(i)
        end)
        updateText(i)

        local reagentNameFrame = _G['CraftReagent' .. i .. 'NameFrame']
        reagentNameFrame:Hide()
    end

    hooksecurefunc('CraftFrame_SetSelection', function(id)
        -- DragonFlightUIProfessionCraftMixin:UpdateRecipeName()
    end)
end

function DragonFlightUIProfessionCraftMixin:UpdateRecipeName()
    local index = GetCraftSelectionIndex()

    local quality = DragonFlightUIProfessionCraftMixin:GetRecipeQuality(index)
    local r, g, b, hex = GetItemQualityColor(quality)

    local name = CraftName
    name:SetTextColor(r, g, b)

    local stringWidth = name:GetStringWidth()
    name:SetWidth(stringWidth)

    local fav = frameRef.FavoriteButton
    fav:UpdateFavoriteState()
end

function DragonFlightUIProfessionCraftMixin:GetRecipeQuality(index)
    local tooltip = CreateFrame("GameTooltip", "DragonflightUIScanningTooltip", nil, "GameTooltipTemplate")
    tooltip:SetOwner(WorldFrame, "ANCHOR_NONE");

    -- local _, skillType, _, _, _ = GetTradeSkillInfo(index);
    -- if (skillType == "header") then return 1 end

    if not index or index == 0 then return 1 end

    tooltip:SetCraftSpell(index)

    local name, link = tooltip:GetItem()

    if not link then return 1 end

    local itemString = string.match(link, "item[%-?%d:]+")
    if not itemString then return 1; end

    local _, itemId = strsplit(":", itemString)
    itemId = tonumber(itemId)
    if not itemId or itemId == "" then return 1; end

    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc,
          itemTexture, itemSellPrice, classID = GetItemInfo(link)
    if not itemLevel or not itemId then return 1 end

    return itemRarity
end

function DragonFlightUIProfessionCraftMixin:ToggleFilterDropdown()
    -- print('DragonFlightUIProfessionCraftMixin:ToggleFilterDropdown()')
    -- hide all other

    local dropdown = frameRef.RecipeList.FilterDropDown
    -- dropdown.point = 'TOPLEFT'
    -- dropdown.relativePoint = 'TOPRIGHT'

    -- if not dropdown:IsShown() then HideDropDownMenu(1); end   

    local menuTable = DragonFlightUIProfessionCraftMixin:FilterDropdownGetEasyMenuTable()
    ToggleDropDownMenu(1, nil, dropdown, frameRef.RecipeList.FilterButton, 0, 0, menuTable, nil);
end

function DragonFlightUIProfessionCraftMixin:FilterDropdownOnLoad(self)
    -- print('DragonFlightUIProfessionCraftMixin:FilterDropdownOnLoad(self)')

    -- UIDropDownMenu_Initialize(self, DragonFlightUIProfessionCraftMixin.FilterDropdownInitialize, 'MENU');
    -- UIDropDownMenu_SetWidth(self, 120);
    -- UIDropDownMenu_SetSelectedID(self, 1);
end

function DragonFlightUIProfessionCraftMixin:FilterDropdownUpdate()
    -- print('DragonFlightUIProfessionCraftMixin:FilterDropdownUpdate()')
    local dropdown = frameRef.RecipeList.FilterDropDown
    dropdown.point = 'TOPLEFT'
    dropdown.relativePoint = 'TOPRIGHT'
    dropdown.displayMode = 'MENU'

    local menuTable = DragonFlightUIProfessionCraftMixin:FilterDropdownGetEasyMenuTable()

    --    EasyMenu(menuTable, dropdown, frameRef.RecipeList.FilterButton, 0, 0, "MENU");
    UIDropDownMenu_Initialize(dropdown, EasyMenu_Initialize, 'MENU', nil, menuTable);

    -- ToggleDropDownMenu(1, nil, dropdown, frameRef.RecipeList.FilterButton, 0, 0, menuTable, nil);
end

function DragonFlightUIProfessionCraftMixin:FilterDropdownRefresh()
    -- TODO: find better way
    DragonFlightUIProfessionCraftMixin:ToggleFilterDropdown()
    DragonFlightUIProfessionCraftMixin:ToggleFilterDropdown()
    frameRef:CheckFilter()
end

-- FILTER
local DFFilter = {}

do
    local DFFilter_HasSkillUp = function(elementData)
        local skillType = elementData.recipeInfo.skillType
        local filter = DFFilter['DFFilter_HasSkillUp'].filter

        -- print('DFFilter_HasSkillUp', elementData.recipeInfo.skillType, filter[skillType])

        if filter[skillType] then
            return true
        else
            return false
        end
    end

    DFFilter['DFFilter_HasSkillUp'] = {
        name = 'DFFilter_HasSkillUp',
        filterDefault = {trivial = true, easy = true, medium = true, optimal = true, difficult = true},
        filter = {},
        func = DFFilter_HasSkillUp,
        enabled = false
    }
    DFFilter['DFFilter_HasSkillUp'].filter = DFFilter['DFFilter_HasSkillUp'].filterDefault
end

-- have materials
do
    local DFFilter_HaveMaterials = function(elementData)
        return elementData.recipeInfo.numAvailable > 0
    end

    DFFilter['DFFilter_HaveMaterials'] = {
        name = 'DFFilter_HaveMaterials',
        func = DFFilter_HaveMaterials,
        enabled = false
    }
end

-- searchbox
do
    local match = function(str, text)
        return strfind(strupper(str), strupper(text))
    end

    local DFFilter_Searchbox = function(elementData)
        --[[     local data = {
            id = i,
            isFavorite = isFavorite,
            recipeInfo = {
                name = skillName,
                skillType = skillType,
                numAvailable = numAvailable,
                isExpanded = isExpanded,
                altVerb = altVerb,
                numSkills = numSkills
            }
        } ]]
        local searchText = strupper(frameRef.RecipeList.SearchBox:GetText())

        if searchText == '' then return true end

        local id = elementData.id
        local info = elementData.recipeInfo

        if match(info.name, searchText) then return true end

        local numReagents = GetCraftNumReagents(id);

        for i = 1, numReagents do
            local reagentName, reagentTexture, reagentCount, playerReagentCount = GetCraftReagentInfo(id, i);
            if reagentName and match(reagentName, searchText) then return true end
        end

        return false
    end

    DFFilter['DFFilter_Searchbox'] = {name = 'DFFilter_Searchbox', func = DFFilter_Searchbox, enabled = true}
end
---------

function DragonFlightUIProfessionCraftMixin:ResetFilter()
    DFFilter['DFFilter_HasSkillUp'].enabled = false
    DFFilter['DFFilter_HaveMaterials'].enabled = false
    -- SetTradeSkillSubClassFilter(0, true, 1)
    -- SetTradeSkillInvSlotFilter(0, true, 1)
end

function DragonFlightUIProfessionCraftMixin:AreFilterDefault()
    -- local allCheckedSub = GetTradeSkillSubClassFilter(0);
    -- if not allCheckedSub then return false end
    -- local allCheckedInv = GetTradeSkillInvSlotFilter(0);
    -- if not allCheckedInv then return false end

    if DFFilter['DFFilter_HasSkillUp'].enabled then return false end
    if DFFilter['DFFilter_HaveMaterials'].enabled then return false end

    return true
end

function DragonFlightUIProfessionCraftMixin:CheckFilter()
    local def = self:AreFilterDefault()

    self.RecipeList.ResetButton:SetShown(not def)
end

function DragonFlightUIProfessionCraftMixin:FilterDropdownGetEasyMenuTable()
    local menu = {
        {
            text = CRAFT_IS_MAKEABLE,
            checked = DFFilter['DFFilter_HaveMaterials'].enabled,
            isNotRadio = true,
            keepShownOnClick = true,
            func = function(self, arg1, arg2, checked)
                -- print(self, arg1, arg2, checked)
                DFFilter['DFFilter_HaveMaterials'].enabled = checked
                frameRef.RecipeList:Refresh(true)
                frameRef:CheckFilter()
            end
        }, {
            text = 'Has skill up',
            checked = DFFilter['DFFilter_HasSkillUp'].enabled,
            isNotRadio = true,
            keepShownOnClick = true,
            func = function(self, arg1, arg2, checked)
                -- print(self, arg1, arg2, checked)
                -- print('Filter: Has skill up', checked)
                if checked then
                    DFFilter['DFFilter_HasSkillUp'].enabled = true
                    DFFilter['DFFilter_HasSkillUp'].filter = {easy = true, medium = true, optimal = true}
                else
                    DFFilter['DFFilter_HasSkillUp'].enabled = false
                    DFFilter['DFFilter_HasSkillUp'].filter = DFFilter['DFFilter_HasSkillUp'].filterDefault
                end
                frameRef.RecipeList:Refresh(true)
                frameRef:CheckFilter()
            end
        }
    }

    return menu
end

--[[ First Aid 	129										
Blacksmithing	164	
Leatherworking	165	
Alchemy	171	
Herbalism	182
Cooking	185	
Mining	186
Tailoring	197	
Engineering	202	
Enchanting	333	
Fishing	356
Skinning	393	
Jewelcrafting 	755
Inscription 	773	
Archeology 	794
 ]]

local professionDataTable = {}
professionDataTable[129] = {tex = 'professionbackgroundart', bar = 'professionsfxalchemy', icon = 135966} -- first aid
professionDataTable[164] = {
    tex = 'ProfessionBackgroundArtBlacksmithing',
    bar = 'professionsfxblacksmithing',
    icon = 136241
}
professionDataTable[165] = {
    tex = 'ProfessionBackgroundArtLeatherworking',
    bar = 'professionsfxleatherworking',
    icon = 133611
}
professionDataTable[171] = {tex = 'ProfessionBackgroundArtAlchemy', bar = 'professionsfxalchemy', icon = 136240}
professionDataTable[182] = {tex = 'ProfessionBackgroundArtHerbalism', bar = '', icon = 136246} -- herb
professionDataTable[185] = {tex = 'ProfessionBackgroundArtCooking', bar = 'professionsfxcooking', icon = 133971}
professionDataTable[186] = {tex = 'ProfessionBackgroundArtMining', bar = 'professionsfxmining', icon = 136248}
professionDataTable[197] = {tex = 'ProfessionBackgroundArtTailoring', bar = 'professionsfxtailoring', icon = 136249}
professionDataTable[202] = {tex = 'ProfessionBackgroundArtEngineering', bar = 'professionsfxengineering', icon = 136243}
professionDataTable[333] = {tex = 'ProfessionBackgroundArtEnchanting', bar = 'professionsfxenchanting', icon = 136244}
professionDataTable[356] = {tex = 'ProfessionBackgroundArtFishing', bar = '', icon = 136245} -- fisch
professionDataTable[393] = {tex = 'ProfessionBackgroundArtSkinning', bar = 'professionsfxskinning', icon = 134366} -- skinning
professionDataTable[755] = {
    tex = 'ProfessionBackgroundArtJewelcrafting',
    bar = 'professionsfxjewelcrafting',
    icon = 134071
}
professionDataTable[773] = {tex = 'ProfessionBackgroundArtInscription', bar = 'professionsfxinscription', icon = 237171}
professionDataTable[794] = {
    tex = 'ProfessionBackgroundArtLeatherworking',
    bar = 'professionsfxleatherworking',
    icon = 441139
} -- archeology
professionDataTable[666] = {tex = 'ProfessionBackgroundArtAlchemy', bar = 'professionsfxalchemy', icon = 136242} -- poison
professionDataTable[667] = {tex = 'professionbackgroundart', bar = 'professionsfxskinning', icon = 132162} -- beast training

function DragonFlightUIProfessionCraftMixin:UpdateHeader()
    self.NineSlice.Text:SetText('**')
    self.Icon:SetTexture('')
    SetPortraitToTexture(self.Icon, self.Icon:GetTexture())

    local skillID, icon = DragonFlightUIProfessionCraftMixin:GetProfessionID()

    if not skillID then return end

    -- print('skillID', skillID)
    local profData = professionDataTable[skillID]

    local nameLoc, rank, maxRank = GetCraftDisplaySkillLine();
    if not nameLoc then nameLoc = GetCraftSkillLine(1) end -- beast training

    -- print(nameLoc, skillID, icon)
    -- self.NineSlice.Text:SetText(nameLoc) 
    self.Icon:SetTexture(profData.icon)
    SetPortraitToTexture(self.Icon, self.Icon:GetTexture())

    local isLink, playerName = IsTradeSkillLinked()

    if isLink then
        --
        self.NineSlice.Text:SetText(nameLoc .. ' (' .. playerName .. ')')
        self.LinkButton:Hide()
    else
        self.NineSlice.Text:SetText(nameLoc)

        if DF.Era then
            self.LinkButton:Hide()
        else
            self.LinkButton:Show()
        end
    end

    -- DevTools_Dump(profData)

    self.SchematicForm.Background:SetTexture(base .. profData.tex)

    -- RankFrame
    if skillID ~= self.currentSkillID then self.RankFrameBar:SetStatusBarTexture(base .. profData.bar) end
    self.RankFrame:UpdateRankFrame(rank, 0, maxRank)

    self.currentSkillID = skillID
end

function DragonFlightUIProfessionCraftMixin:GetProfessionID()
    -- localized...
    local nameLoc, rank, maxRank = GetCraftDisplaySkillLine();

    if not nameLoc then nameLoc = GetCraftSkillLine(1) end -- beast training

    local skillID = DragonflightUILocalizationData:GetSkillIDFromProfessionName(nameLoc)
    local profData = professionDataTable[skillID]

    return skillID, profData.icon
end

------------------------------

DFProfessionsCraftRecipeListMixin = CreateFromMixins(CallbackRegistryMixin);
DFProfessionsCraftRecipeListMixin:GenerateCallbackEvents({"OnRecipeSelected"});

function DFProfessionsCraftRecipeListMixin:OnLoad()
    -- print('DFProfessionsCraftRecipeListMixin:OnLoad()')
    CallbackRegistryMixin.OnLoad(self);

    self.selectedSkill = GetCraftSelectionIndex() or 2
    -- print('self.selectedSkill', self.selectedSkill)
    self.DataProvider = CreateTreeDataProvider()

    local indent = 10;
    local padLeft = 0;
    local pad = 5;
    local spacing = 1;
    local view = CreateScrollBoxListTreeListView(indent, pad, pad, padLeft, pad, spacing);
    self.View = view

    view:SetElementFactory(function(factory, node)
        local elementData = node:GetData();
        if elementData.categoryInfo then
            local function Initializer(button, node)
                button:Init(node);
                -- print('initCats', elementData.id, self.selectedSkill)

                button:SetScript("OnClick", function(button, buttonName)
                    node:ToggleCollapsed();
                    button:SetCollapseState(node:IsCollapsed());
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)

                    if elementData.categoryInfo.isExpanded then
                        -- CollapseTradeSkillSubClass(elementData.id)
                    else
                        -- ExpandTradeSkillSubClass(elementData.id)
                    end
                end);
                --[[ 
                button:SetScript("OnEnter", function()
                    EventRegistry:TriggerEvent("ProfessionsDebug.CraftingRecipeListCategoryEntered", button,
                                               elementData.categoryInfo);
                    ProfessionsRecipeListCategoryMixin.OnEnter(button);
                end); ]]
            end
            factory("ProfessionsRecipeListCategoryTemplate", Initializer);
        elseif elementData.recipeInfo then
            local function Initializer(button, node)

                button:Init(node, false);

                if elementData.recipeInfo.craftSubSpellName then
                    button.Count:SetText(" (" .. elementData.recipeInfo.craftSubSpellName .. ")")
                    button.Count:Show()

                    local padding = 10;
                    local countWidth = button.Count:GetStringWidth() or 0;
                    local width = button:GetWidth() - (countWidth + padding + button.SkillUps:GetWidth());
                    button.Label:SetWidth(button:GetWidth());
                    button.Label:SetWidth(math.min(width, button.Label:GetStringWidth()));
                end
                -- print('init', elementData.id, self.selectedSkill)
                if elementData.id == self.selectedSkill then self.selectionBehavior:Select(button) end
                local selected = self.selectionBehavior:IsElementDataSelected(node);
                button:SetSelected(selected);

                button:SetScript("OnClick", function(button, buttonName, down)
                    --[[   EventRegistry:TriggerEvent("ProfessionsDebug.CraftingRecipeListRecipeClicked", button, buttonName,
                                               down, elementData.recipeInfo);]]
                    -- print('OnClick', buttonName, elementData.id)

                    if buttonName == "LeftButton" then
                        if IsModifiedClick() then
                            --[[      local link = C_TradeSkillUI.GetRecipeLink(elementData.recipeInfo.recipeID);
                            if not HandleModifiedItemClick(link) and IsModifiedClick("RECIPEWATCHTOGGLE") and
                                Professions.CanTrackRecipe(elementData.recipeInfo) then
                                local recrafting = false;
                                local tracked = C_TradeSkillUI.IsRecipeTracked(elementData.recipeInfo.recipeID,
                                                                               recrafting);
                                C_TradeSkillUI.SetRecipeTracked(elementData.recipeInfo.recipeID, not tracked, recrafting);
                            end ]]
                            HandleModifiedItemClick(GetCraftItemLink(elementData.id));
                        else
                            self.selectionBehavior:Select(button);
                        end
                    elseif buttonName == "RightButton" then
                        -- If additional context menu options are added, move this
                        -- public view check to the dropdown initializer.
                        --[[      if elementData.recipeInfo.learned and Professions.InLocalCraftingMode() then
                            ToggleDropDownMenu(1, elementData.recipeInfo, self.ContextMenu, "cursor");
                        end ]]
                    end

                    -- PlaySound(SOUNDKIT.UI_90_BLACKSMITHING_TREEITEMCLICK);
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
                end);

                --[[       button:SetScript("OnEnter", function()
                    ProfessionsRecipeListRecipeMixin.OnEnter(button);
                    EventRegistry:TriggerEvent("ProfessionsDebug.CraftingRecipeListRecipeEntered", button,
                                               elementData.recipeInfo);
                end); ]]
            end
            factory("ProfessionsRecipeListRecipeTemplate", Initializer);
        elseif elementData.isDivider then
            factory("ProfessionsRecipeListDividerTemplate");
        else
            factory("Frame");
        end
    end);

    view:SetDataProvider(self.DataProvider)

    view:SetElementExtentCalculator(function(dataIndex, node)
        local elementData = node:GetData();
        local baseElementHeight = 20;
        local categoryPadding = 5;

        if elementData.recipeInfo then return baseElementHeight; end

        if elementData.categoryInfo then return baseElementHeight + categoryPadding; end

        if elementData.dividerHeight then return elementData.dividerHeight; end

        if elementData.topPadding then return 1; end

        if elementData.bottomPadding then return 10; end
    end);

    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, view);

    local function OnSelectionChanged(o, elementData, selected)
        -- print('OnSelectionChanged', o, elementData, selected)
        local button = self.ScrollBox:FindFrame(elementData);
        if button then button:SetSelected(selected); end

        if selected then
            local data = elementData:GetData();

            -- TradeSkillSkillButton_OnClick(test, 'LeftButton')

            local newRecipeID = data.id
            local changed = data.id ~= self.selectedSkill
            if changed then
                -- print('OnSelectionChanged-changed', data.id)
                self.selectedSkill = newRecipeID
                EventRegistry:TriggerEvent("DFProfessionsCraftRecipeListMixin.Event.OnRecipeSelected", newRecipeID, self);

                CraftFrame_SetSelection(newRecipeID)
                self:SelectRecipe(newRecipeID, false)
                frameRef.FavoriteButton:UpdateFavoriteState()
                -- if newRecipeID then self.previousRecipeID = newRecipeID; end
            end
        end
    end

    self.selectionBehavior = ScrollUtil.AddSelectionBehavior(self.ScrollBox);
    self.selectionBehavior:RegisterCallback(SelectionBehaviorMixin.Event.OnSelectionChanged, OnSelectionChanged, self);
end

function DFProfessionsCraftRecipeListMixin:OnEvent(event, ...)
    -- print('DFProfessionsCraftRecipeListMixin:OnEvent(event, ...)', event, ...)
end

function DFProfessionsCraftRecipeListMixin:OnShow()
    -- print('DFProfessionsCraftRecipeListMixin:OnShow()')    
    -- self:Refresh()
    -- EventRegistry:TriggerEvent("DFProfessionsCraftRecipeListMixin.Event.OnRecipeSelected", self.selectedSkill, self);
end

function DFProfessionsCraftRecipeListMixin:Refresh(force)
    -- print('->DFProfessionsCraftRecipeListMixin:Refresh()', force == true)

    local numSkills = GetNumCrafts()
    local index = GetCraftSelectionIndex()
    --[[   if index > numSkills then
        index = GetFirstTradeSkill()
        TradeSkillFrame_SetSelection(index)
    end ]]
    local changed = self.selectedSkill ~= index
    self.selectedSkill = index

    local oldScroll = self.ScrollBox:GetScrollPercentage()

    self:UpdateRecipeList()

    self:SelectRecipe(index, true)
    frameRef.FavoriteButton:UpdateFavoriteState()

    if (not changed) and (not force) then
        -- print('set old scroll')
        self.ScrollBox:SetScrollPercentage(oldScroll, ScrollBoxConstants.NoScrollInterpolation)
    end
end

function DFProfessionsCraftRecipeListMixin:SelectRecipe(id, scrollToRecipe)
    local elementData = self.selectionBehavior:SelectElementDataByPredicate(function(node)
        local data = node:GetData();
        return data.recipeInfo and data.id == id
    end);

    if scrollToRecipe then
        self.ScrollBox:ScrollToElementData(elementData);
        -- ScrollBoxConstants.AlignCenter,  ScrollBoxConstants.RetainScrollPosition

    end

    return elementData;
end

function DFProfessionsCraftRecipeListMixin:UpdateRecipeList()
    local dataProvider = CreateTreeDataProvider();

    local filterTable = DFFilter

    local numSkills = GetNumCrafts()

    local headerID = -1

    do
        local data = {id = 0, categoryInfo = {name = 'Favorites', isExpanded = true}}
        dataProvider:Insert(data)

        local dataTwo = {id = -1, categoryInfo = {name = 'No Category', isExpanded = true}}
        dataProvider:Insert(dataTwo)
    end

    for i = 1, numSkills do
        -- local skillName, skillType, numAvailable, isExpanded, altVerb, numSkillUps = GetTradeSkillInfo(i);
        -- local craftName, craftSubSpellName, craftType, numAvailable, isExpanded, trainingPointCost, requiredLevel = GetCraftInfo(i)
        local skillName, craftSubSpellName, skillType, numAvailable, isExpanded, trainingPointCost, requiredLevel =
            GetCraftInfo(i)

        if skillType == "none" then
            skillType = "easy"
        elseif skillType == "used" then
            skillType = "trivial"
        end

        if craftType == 'header' then
            -- local data = {id = i, categoryInfo = {name = skillName, isExpanded = isExpanded == 1}}
            -- dataProvider:Insert(data)
            -- headerID = i
        else
            -- print('--', skillName)
            local isFavorite = DragonFlightUIProfessionCraftMixin:IsRecipeFavorite(skillName)

            local data = {
                id = i,
                isFavorite = isFavorite,
                recipeInfo = {
                    name = skillName,
                    craftSubSpellName = craftSubSpellName,
                    skillType = skillType,
                    numAvailable = numAvailable,
                    isExpanded = isExpanded
                }
            }

            local filtered = true

            for k, filter in pairs(filterTable) do
                --
                if filter.enabled then
                    --
                    if not filter.func(data) then
                        --
                        filtered = false
                    end
                end
            end

            if filtered then
                --
                dataProvider:InsertInParentByPredicate(data, function(node)
                    local nodeData = node:GetData()

                    if data.isFavorite then
                        return nodeData.id == 0
                    else
                        return nodeData.id == headerID
                    end
                end)
            end
        end
    end

    -- DevTools_Dump(dataProvider)

    local nodes = dataProvider:GetChildrenNodes()
    local nodesToRemove = {}
    -- print('NODES', #nodes)

    for k, child in ipairs(nodes) do
        --
        local numChildNodes = #child:GetNodes()
        -- print('numChildNodes', numChildNodes)
        if numChildNodes < 1 then
            --
            -- print('remove node')
            -- dataProvider:Remove(child)
            table.insert(nodesToRemove, child)
        end
    end

    for k, node in ipairs(nodesToRemove) do
        --
        -- print('to remove', k, node)
        dataProvider:Remove(node)
    end

    -- print('UpdateRecipeList()', numSkills, dataProvider:GetSize(false))
    self.ScrollBox:SetDataProvider(dataProvider);
end

