DragonFlightUIProfessionMixin = {}
local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

--
local frameRef = nil

function DragonFlightUIProfessionMixin:OnLoad()
    self:SetupFrameStyle()

    self:RegisterEvent("TRADE_SKILL_SHOW");
    self:RegisterEvent("TRADE_SKILL_CLOSE");
    self:RegisterEvent("TRADE_SKILL_UPDATE");
    self:RegisterEvent("TRADE_SKILL_FILTER_UPDATE");

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
        HideUIPanel(TradeSkillFrame)
    end);

    frameRef = self
end

function DragonFlightUIProfessionMixin:OnShow()
    if not self.anchored then
        self.anchored = true

        self:AnchorButtons()
        self:AnchorSchematics()
        self:HideDefault()

        -- self:SetParent(TradeSkillFrame)
        -- self:SetPoint('TOPLEFT', TradeSkillFrame, 'TOPRIGHT', 0, 0)
        self:SetPoint('TOPLEFT', TradeSkillFrame, 'TOPLEFT', 12, -12)

        TradeSkillFrame:SetFrameStrata('BACKGROUND')
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

function DragonFlightUIProfessionMixin:OnHide()

end

function DragonFlightUIProfessionMixin:Refresh(force)
    self:UpdateHeader()
    self:UpdateRecipeName()

    do
        local name, rank, maxRank = GetTradeSkillLine();
        if (rank < 75) and (not IsTradeSkillLinked()) then
            self.RecipeList.SearchBox:Disable()
        else
            self.RecipeList.SearchBox:Enable()
        end

        if self.currentTradeSkillName ~= name then
            --[[   UIDropDownMenu_Initialize(frameRef.RecipeList.FilterDropDown,
                                      DragonFlightUIProfessionMixin.FilterDropdownInitialize, 'MENU'); ]]
            DragonFlightUIProfessionMixin:FilterDropdownUpdate()

            self.currentTradeSkillName = name
        end
    end

    self.RecipeList:Refresh(force)
end

function DragonFlightUIProfessionMixin:Minimize(minimize)
    -- print('DragonFlightUIProfessionMixin:Minimize(minimize)', minimize)
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

        TradeSkillCreateButton:ClearAllPoints()
        TradeSkillCreateButton:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -9, 13)
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

        TradeSkillCreateButton:ClearAllPoints()
        TradeSkillCreateButton:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -9, 7)

        self:Refresh(true)
    end
end

function DragonFlightUIProfessionMixin:UpdateUIPanelWindows(big)
    if big then
        TradeSkillFrame:SetAttribute("UIPanelLayout-width", 942);
    else
        TradeSkillFrame:SetAttribute("UIPanelLayout-width", 404);
    end
    UpdateUIPanelPositions(TradeSkillFrame)
end

function DragonFlightUIProfessionMixin:OnEvent(event, arg1, ...)
    -- print('ProfessionMixin', event)
    if event == 'TRADE_SKILL_SHOW' then
        self:Show()
    elseif event == 'TRADE_SKILL_CLOSE' then
        self:Hide()
    elseif event == 'TRADE_SKILL_UPDATE' or event == 'TRADE_SKILL_FILTER_UPDATE' then
        if self:IsShown() then self:Refresh(false) end
    end
end

function DragonFlightUIProfessionMixin:HideDefault()
    TradeSkillFrame:SetFrameStrata('BACKGROUND')
end

function DragonFlightUIProfessionMixin:SetupFrameStyle()
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

function DragonFlightUIProfessionMixin:AnchorButtons()
    local create = TradeSkillCreateButton
    create:ClearAllPoints()
    create:SetParent(self)
    create:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -9, 7)

    local createAll = TradeSkillCreateAllButton
    createAll:SetParent(self)

    local input = TradeSkillInputBox
    input:SetParent(self)

    if TradeSkillFrameEditBox then TradeSkillFrameEditBox:SetParent(self) end

    local increm = TradeSkillDecrementButton
    increm:SetParent(self)

    local decrem = TradeSkillIncrementButton
    decrem:SetParent(self)

    if TradeSkillFrameEditBox then
        TradeSkillFrameEditBox:ClearAllPoints()
        TradeSkillFrameEditBox:SetPoint('RIGHT', UIParent, 'LEFT', -500, 0)
        --[[    -- TradeSkillFrameEditBox:Hide()
    hooksecurefunc(TradeSkillFrameEditBox, 'Show', function()
        -- print('TradeSkillFrameEditBox', 'OnShow')
        -- TradeSkillFrameEditBox:Hide()
    end) ]]
    end
end

function DragonFlightUIProfessionMixin:GetIconOverlayTexCoord(quality)
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

function DragonFlightUIProfessionMixin:AnchorSchematics()
    local frame = self.SchematicForm
    -- frame.NineSlice:SetFrameLevel(2)
    -- frame.NineSlice:SetAlpha(0.25)

    local icon = TradeSkillSkillIcon
    icon:ClearAllPoints()
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

    local name = TradeSkillSkillName
    name:ClearAllPoints()
    name:SetParent(frame)
    -- name:SetPoint('LEFT', icon, 'RIGHT', 14, 17)
    name:SetPoint('TOPLEFT', icon, 'TOPRIGHT', 14, 0)

    local req = TradeSkillRequirementLabel
    req:ClearAllPoints()
    req:SetParent(frame)
    req:SetPoint('TOPLEFT', name, 'BOTTOMLEFT', 0, -4)

    local reqText = TradeSkillRequirementText
    reqText:ClearAllPoints()
    reqText:SetParent(frame)
    -- reqText:SetSize(180,9.9)
    reqText:SetSize(250, 9.9)
    -- reqText:SetJustifyH("LEFT");
    reqText:SetPoint('LEFT', req, 'RIGHT', 4, 0)

    if TradeSkillDescription then
        local descr = TradeSkillDescription
        descr:ClearAllPoints()
        descr:SetParent(frame)
        descr:SetPoint('TOPLEFT', icon, 'BOTTOMLEFT', -1, -12)
    end

    local reagentLabel = TradeSkillReagentLabel
    reagentLabel:ClearAllPoints()
    reagentLabel:SetParent(frame)
    reagentLabel:SetPoint('TOPLEFT', descr, 'BOTTOMLEFT', 0, -20)

    for i = 1, MAX_TRADE_SKILL_REAGENTS do
        --
        local reagent = _G['TradeSkillReagent' .. i]
        reagent:ClearAllPoints()
        reagent:SetParent(frame)
        reagent:SetPoint('TOPLEFT', reagentLabel, 'TOPLEFT', 1, -23 - (i - 1) * 45)
        -- <Size x="147" y="41" />
        -- DF: <Size x="180" y="50"/>
        reagent:SetSize(180, 50)

        local reagentIcon = _G['TradeSkillReagent' .. i .. 'IconTexture']
        -- reagentIcon:SetSize() 
        reagentIcon:ClearAllPoints()
        reagentIcon:SetPoint('LEFT', reagent, 'LEFT', 0, 0)

        local overlay = DragonflightUIItemColorMixin:AddOverlayToFrame(reagent)
        overlay:SetPoint('TOPLEFT', reagentIcon, 'TOPLEFT', 0, 0)
        overlay:SetPoint('BOTTOMRIGHT', reagentIcon, 'BOTTOMRIGHT', 0, 0)

        local reagentCountText = _G["TradeSkillReagent" .. i .. "Count"];
        reagentCountText:Hide()
        local reagentNameText = _G['TradeSkillReagent' .. i .. 'Name']
        reagentNameText:ClearAllPoints()
        reagentNameText:SetPoint('LEFT', reagent, 'LEFT', 46, 0)
        -- <Size x="90" y="36" />
        -- DF: <Size x="108" y="36" />
        -- reagentNameText:SetSize(108, 36)
        reagentNameText:SetSize(142, 36)
        reagentNameText:SetJustifyH("LEFT");

        local updateText = function()
            local index = GetTradeSkillSelectionIndex()
            local reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(index, i);

            if (not reagentName or not reagentTexture) then return end

            local newText = playerReagentCount .. "/" .. reagentCount .. ' ' .. reagentName

            reagentNameText:SetText(newText)

            local link = GetTradeSkillReagentItemLink(index, i)

            if link then
                local quality, _, _, _, _, _, _, _, _, classId = select(3, GetItemInfo(link));
                if (classId == 12) then quality = LE_ITEM_QUALITY_QUEST; end
                DragonflightUIItemColorMixin:UpdateOverlayQuality(reagent, quality)
            end
        end

        hooksecurefunc(reagentCountText, 'SetText', function()
            updateText(i)
        end)
        updateText(i)

        local reagentNameFrame = _G['TradeSkillReagent' .. i .. 'NameFrame']
        reagentNameFrame:Hide()
    end

    hooksecurefunc('TradeSkillFrame_SetSelection', function(id)
        DragonFlightUIProfessionMixin:UpdateRecipeName()
    end)
end

function DragonFlightUIProfessionMixin:UpdateRecipeName()
    local index = GetTradeSkillSelectionIndex()

    local quality = DragonFlightUIProfessionMixin:GetRecipeQuality(index)
    local r, g, b, hex = GetItemQualityColor(quality)

    local name = TradeSkillSkillName
    name:SetTextColor(r, g, b)
end

function DragonFlightUIProfessionMixin:GetRecipeQuality(index)
    local tooltip = CreateFrame("GameTooltip", "DragonflightUIScanningTooltip", nil, "GameTooltipTemplate")
    tooltip:SetOwner(WorldFrame, "ANCHOR_NONE");

    -- local _, skillType, _, _, _ = GetTradeSkillInfo(index);
    -- if (skillType == "header") then return 1 end

    if not index or index == 0 then return 1 end

    tooltip:SetTradeSkillItem(index)

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

function DragonFlightUIProfessionMixin:ToggleFilterDropdown()
    -- print('DragonFlightUIProfessionMixin:ToggleFilterDropdown()')
    -- hide all other

    local dropdown = frameRef.RecipeList.FilterDropDown
    -- dropdown.point = 'TOPLEFT'
    -- dropdown.relativePoint = 'TOPRIGHT'

    -- if not dropdown:IsShown() then HideDropDownMenu(1); end   

    local menuTable = DragonFlightUIProfessionMixin:FilterDropdownGetEasyMenuTable()
    ToggleDropDownMenu(1, nil, dropdown, frameRef.RecipeList.FilterButton, 0, 0, menuTable, nil);
end

function DragonFlightUIProfessionMixin:FilterDropdownOnLoad(self)
    -- print('DragonFlightUIProfessionMixin:FilterDropdownOnLoad(self)')

    -- UIDropDownMenu_Initialize(self, DragonFlightUIProfessionMixin.FilterDropdownInitialize, 'MENU');
    -- UIDropDownMenu_SetWidth(self, 120);
    -- UIDropDownMenu_SetSelectedID(self, 1);
end

function DragonFlightUIProfessionMixin:FilterDropdownUpdate()
    -- print('DragonFlightUIProfessionMixin:FilterDropdownUpdate()')
    local dropdown = frameRef.RecipeList.FilterDropDown
    dropdown.point = 'TOPLEFT'
    dropdown.relativePoint = 'TOPRIGHT'
    dropdown.displayMode = 'MENU'

    local menuTable = DragonFlightUIProfessionMixin:FilterDropdownGetEasyMenuTable()

    --    EasyMenu(menuTable, dropdown, frameRef.RecipeList.FilterButton, 0, 0, "MENU");
    UIDropDownMenu_Initialize(dropdown, EasyMenu_Initialize, 'MENU', nil, menuTable);

    -- ToggleDropDownMenu(1, nil, dropdown, frameRef.RecipeList.FilterButton, 0, 0, menuTable, nil);
end

function DragonFlightUIProfessionMixin:FilterDropdownRefresh()
    -- TODO: find better way
    DragonFlightUIProfessionMixin:ToggleFilterDropdown()
    DragonFlightUIProfessionMixin:ToggleFilterDropdown()
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
---------

function DragonFlightUIProfessionMixin:FilterDropdownGetEasyMenuTable()
    local subClasses = {GetTradeSkillSubClasses()}
    local numSubClasses = #subClasses
    local allCheckedSub = GetTradeSkillSubClassFilter(0);
    local selectedIDSub = UIDropDownMenu_GetSelectedID(TradeSkillSubClassDropDown) or 1;

    local subInv = {GetTradeSkillInvSlots()}
    local numSubClassesInv = #subInv
    local allCheckedInv = GetTradeSkillInvSlotFilter(0);

    local menu = {
        {
            text = CRAFT_IS_MAKEABLE,
            checked = false,
            isNotRadio = true,
            keepShownOnClick = true,
            func = function(self, arg1, arg2, checked)
                -- print(self, arg1, arg2, checked)
                TradeSkillOnlyShowMakeable(checked);
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
            end
        }, {text = " ", isTitle = true}, {
            text = "Subclass",
            hasArrow = true,
            menuList = {
                {
                    text = ALL_SUBCLASSES,
                    checked = allCheckedSub and (selectedIDSub == nil or selectedIDSub == 1),
                    isNotRadio = true,
                    keepShownOnClick = true,
                    func = function(self, arg1, arg2, checked)
                        -- SetTradeSkillSubClassFilter(slotIndex, onOff{, exclusive});
                        -- print('func', self:GetID())
                        SetTradeSkillSubClassFilter(0, checked, 1)
                        DragonFlightUIProfessionMixin:FilterDropdownRefresh()
                    end
                }
            }
        }, {
            text = "Slot",
            hasArrow = true,
            menuList = {
                {
                    text = ALL_INVENTORY_SLOTS,
                    checked = allCheckedInv,
                    isNotRadio = true,
                    keepShownOnClick = true,
                    func = function(self, arg1, arg2, checked)
                        -- SetTradeSkillSubClassFilter(slotIndex, onOff{, exclusive});
                        -- print('func', self:GetID())
                        SetTradeSkillInvSlotFilter(0, checked, 1)
                        DragonFlightUIProfessionMixin:FilterDropdownRefresh()
                    end
                }
            }
        }
    }

    for k, v in ipairs(subClasses) do
        --
        local checked

        if allCheckedSub then
            checked = nil
        else
            checked = GetTradeSkillSubClassFilter(k)
        end

        local option = {
            text = v,
            checked = checked,
            isNotRadio = true,
            keepShownOnClick = true,
            func = function(self, arg1, arg2, checked)
                -- SetTradeSkillSubClassFilter(slotIndex, onOff{, exclusive});
                -- print('func', k, v, checked)
                -- print('->', k, checked, true)
                if checked then
                    SetTradeSkillSubClassFilter(k, 1, 1)
                else
                    SetTradeSkillSubClassFilter(k, 0, 1)
                end
                -- print('func', self:GetID())
                -- UIDropDownMenu_SetSelectedValue     
                DragonFlightUIProfessionMixin:FilterDropdownRefresh()
            end
        }

        table.insert(menu[4].menuList, option)
    end

    for k, v in ipairs(subInv) do
        --
        local checked

        if allCheckedInv then
            checked = nil
        else
            checked = GetTradeSkillInvSlotFilter(k)
        end

        local option = {
            text = v,
            checked = checked,
            isNotRadio = true,
            keepShownOnClick = true,
            func = function(self, arg1, arg2, checked)
                -- SetTradeSkillSubClassFilter(slotIndex, onOff{, exclusive});
                -- print('func', k, v, checked)
                -- print('->', k, v, checked)
                if checked then
                    SetTradeSkillInvSlotFilter(k, 1, 1)
                else
                    SetTradeSkillInvSlotFilter(k, 0, 1)
                end
                DragonFlightUIProfessionMixin:FilterDropdownRefresh()
            end
        }

        table.insert(menu[5].menuList, option)
    end

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
professionDataTable[129] = {tex = 'professionbackgroundart', bar = 'professionsfxalchemy'} -- first aid
professionDataTable[164] = {tex = 'ProfessionBackgroundArtBlacksmithing', bar = 'professionsfxblacksmithing'}
professionDataTable[165] = {tex = 'ProfessionBackgroundArtLeatherworking', bar = 'professionsfxleatherworking'}
professionDataTable[171] = {tex = 'ProfessionBackgroundArtAlchemy', bar = 'professionsfxalchemy'}
professionDataTable[182] = {tex = 'ProfessionBackgroundArtHerbalism', bar = ''} -- herb
professionDataTable[185] = {tex = 'ProfessionBackgroundArtCooking', bar = 'professionsfxcooking'}
professionDataTable[186] = {tex = 'ProfessionBackgroundArtMining', bar = 'professionsfxmining'}
professionDataTable[197] = {tex = 'ProfessionBackgroundArtTailoring', bar = 'professionsfxtailoring'}
professionDataTable[202] = {tex = 'ProfessionBackgroundArtEngineering', bar = 'professionsfxengineering'}
professionDataTable[333] = {tex = 'ProfessionBackgroundArtEnchanting', bar = 'professionsfxenchanting'}
professionDataTable[356] = {tex = 'ProfessionBackgroundArtFishing', bar = ''} -- fisch
professionDataTable[393] = {tex = 'ProfessionBackgroundArtSkinning', bar = 'professionsfxskinning'} -- skinning
professionDataTable[755] = {tex = 'ProfessionBackgroundArtJewelcrafting', bar = 'professionsfxjewelcrafting'}
professionDataTable[773] = {tex = 'ProfessionBackgroundArtInscription', bar = 'professionsfxinscription'}
professionDataTable[794] = {tex = 'ProfessionBackgroundArtLeatherworking', bar = 'professionsfxleatherworking'} -- archeology

function DragonFlightUIProfessionMixin:UpdateHeader()
    self.NineSlice.Text:SetText('**')
    self.Icon:SetTexture('')
    SetPortraitToTexture(self.Icon, self.Icon:GetTexture())

    local skillID, icon = DragonFlightUIProfessionMixin:GetProfessionID()

    if not skillID then return end

    -- print('skillID', skillID)

    local nameLoc, rank, maxRank = GetTradeSkillLine();

    -- self.NineSlice.Text:SetText(nameLoc)
    self.Icon:SetTexture(icon)
    SetPortraitToTexture(self.Icon, self.Icon:GetTexture())

    local isLink, playerName = IsTradeSkillLinked()

    if isLink then
        --
        self.NineSlice.Text:SetText(nameLoc .. ' (' .. playerName .. ')')
        self.LinkButton:Hide()
    else
        self.NineSlice.Text:SetText(nameLoc)
        self.LinkButton:Show()
    end

    local profData = professionDataTable[skillID]

    -- DevTools_Dump(profData)

    self.SchematicForm.Background:SetTexture(base .. profData.tex)

    -- RankFrame
    if skillID ~= self.currentSkillID then self.RankFrameBar:SetStatusBarTexture(base .. profData.bar) end
    self.RankFrame:UpdateRankFrame(rank, 0, maxRank)

    self.currentSkillID = skillID
end

function DragonFlightUIProfessionMixin:GetProfessionID()
    local skillID;

    -- localized...
    local nameLoc, rank, maxRank = GetTradeSkillLine();

    local prof1, prof2, archaeology, fishing, cooking, firstaid = GetProfessions()

    if prof1 then
        local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier,
              specializationIndex, specializationOffset = GetProfessionInfo(prof1)

        if name == nameLoc then return skillLine, icon end
    end

    if prof2 then
        local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier,
              specializationIndex, specializationOffset = GetProfessionInfo(prof2)
        if name == nameLoc then return skillLine, icon end
    end

    -- TODO: archeo, cooking

    if cooking then
        local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier,
              specializationIndex, specializationOffset = GetProfessionInfo(cooking)
        if name == nameLoc then return skillLine, icon end
    end

    -- first aid
    if firstaid then
        local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier,
              specializationIndex, specializationOffset = GetProfessionInfo(firstaid)
        if name == nameLoc then return skillLine, icon end
    end
end

------------------------------

DFProfessionsRecipeListMixin = CreateFromMixins(CallbackRegistryMixin);
DFProfessionsRecipeListMixin:GenerateCallbackEvents({"OnRecipeSelected"});

function DFProfessionsRecipeListMixin:OnLoad()
    -- print('DFProfessionsRecipeListMixin:OnLoad()')
    CallbackRegistryMixin.OnLoad(self);

    self.selectedSkill = GetTradeSkillSelectionIndex() or 2
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
                            HandleModifiedItemClick(GetTradeSkillRecipeLink(elementData.id));
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
                EventRegistry:TriggerEvent("DFProfessionsRecipeListMixin.Event.OnRecipeSelected", newRecipeID, self);

                TradeSkillFrame_SetSelection(newRecipeID)
                self:SelectRecipe(newRecipeID, false)
                -- if newRecipeID then self.previousRecipeID = newRecipeID; end
            end
        end
    end

    self.selectionBehavior = ScrollUtil.AddSelectionBehavior(self.ScrollBox);
    self.selectionBehavior:RegisterCallback(SelectionBehaviorMixin.Event.OnSelectionChanged, OnSelectionChanged, self);
end

function DFProfessionsRecipeListMixin:OnEvent(event, ...)
    -- print('DFProfessionsRecipeListMixin:OnEvent(event, ...)', event, ...)
end

function DFProfessionsRecipeListMixin:OnShow()
    -- print('DFProfessionsRecipeListMixin:OnShow()')    
    -- self:Refresh()
    -- EventRegistry:TriggerEvent("DFProfessionsRecipeListMixin.Event.OnRecipeSelected", self.selectedSkill, self);
end

function DFProfessionsRecipeListMixin:Refresh(force)
    -- print('->DFProfessionsRecipeListMixin:Refresh()', force == true)

    local numSkills = GetNumTradeSkills()
    local index = GetTradeSkillSelectionIndex()
    if index > numSkills then
        index = GetFirstTradeSkill()
        TradeSkillFrame_SetSelection(index)
    end
    local changed = self.selectedSkill ~= index
    self.selectedSkill = index

    local oldScroll = self.ScrollBox:GetScrollPercentage()

    self:UpdateRecipeList()

    self:SelectRecipe(index, true)

    if (not changed) and (not force) then
        -- print('set old scroll')
        self.ScrollBox:SetScrollPercentage(oldScroll, ScrollBoxConstants.NoScrollInterpolation)
    end
end

function DFProfessionsRecipeListMixin:SelectRecipe(id, scrollToRecipe)
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

function DFProfessionsRecipeListMixin:UpdateRecipeList()
    local dataProvider = CreateTreeDataProvider();

    local filterTable = DFFilter

    local numSkills = GetNumTradeSkills()

    local headerID = 0

    for i = 1, numSkills do
        local skillName, skillType, numAvailable, isExpanded, altVerb, numSkillUps = GetTradeSkillInfo(i);

        if skillType == 'header' then
            local data = {id = i, categoryInfo = {name = skillName, isExpanded = isExpanded == 1}}
            dataProvider:Insert(data)
            headerID = i
        else
            -- print('--', skillName)
            local data = {
                id = i,
                recipeInfo = {
                    name = skillName,
                    skillType = skillType,
                    numAvailable = numAvailable,
                    isExpanded = isExpanded,
                    altVerb = altVerb,
                    numSkills = numSkills
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

                    return nodeData.id == headerID
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

------------------------------

DFProfessionsRecipeListCategoryMixin = {}

function DFProfessionsRecipeListCategoryMixin:OnEnter()
    self.Label:SetFontObject(GameFontHighlight_NoShadow);
end

function DFProfessionsRecipeListCategoryMixin:OnLeave()
    self.Label:SetFontObject(GameFontNormal_NoShadow);
end

function DFProfessionsRecipeListCategoryMixin:Init(node)
    local elementData = node:GetData();

    local categoryInfo = elementData.categoryInfo;
    self.Label:SetText(categoryInfo.name);

    -- local color = categoryInfo.unlearned and DISABLED_FONT_COLOR or NORMAL_FONT_COLOR;
    -- self.Label:SetVertexColor(color:GetRGB());

    if categoryInfo.isExpanded then
        node:SetCollapsed(false, true, false)
    else
        node:SetCollapsed(true, true, false)
    end

    self:SetCollapseState(node:IsCollapsed());
end

function DFProfessionsRecipeListCategoryMixin:SetCollapseState(collapsed)
    if collapsed then
        self.CollapseIcon:SetTexCoord(0.302246, 0.312988, 0.0537109, 0.0693359)
        self.CollapseIconAlphaAdd:SetTexCoord(0.302246, 0.312988, 0.0537109, 0.0693359)
    else
        self.CollapseIcon:SetTexCoord(0.270508, 0.28125, 0.0537109, 0.0693359)
        self.CollapseIconAlphaAdd:SetTexCoord(0.270508, 0.28125, 0.0537109, 0.0693359)
    end

    if true then return end

    local atlas = collapsed and "Professions-recipe-header-expand" or "Professions-recipe-header-collapse";
    self.CollapseIcon:SetAtlas(atlas, TextureKitConstants.UseAtlasSize);
    self.CollapseIconAlphaAdd:SetAtlas(atlas, TextureKitConstants.UseAtlasSize);
end

------------------------------

DFProfessionsRecipeListRecipeMixin = {}

function DFProfessionsRecipeListRecipeMixin:OnLoad()
    local function OnLeave()
        self:OnLeave();
        GameTooltip_Hide();
    end

    self.LockedIcon:SetScript("OnLeave", OnLeave);
    self.SkillUps:SetScript("OnLeave", OnLeave);
end

local PROFESSION_RECIPE_COLOR = CreateColor(0.88627457618713, 0.86274516582489, 0.83921575546265, 1)

function DFProfessionsRecipeListRecipeMixin:GetLabelColor()
    return PROFESSION_RECIPE_COLOR
    -- return self.learned and PROFESSION_RECIPE_COLOR or DISABLED_FONT_COLOR;
end

local PROFESSIONS_SKILL_UP_EASY = "Low chance of gaining skill"
local PROFESSIONS_SKILL_UP_MEDIUM = "High chance of gaining skill"
local PROFESSIONS_SKILL_UP_OPTIMAL = "Guaranteed chance of gaining %d skill ups"

function DFProfessionsRecipeListRecipeMixin:Init(node, hideCraftableCount)
    local elementData = node:GetData();
    local recipeInfo = elementData.recipeInfo
    -- local recipeInfo = Professions.GetHighestLearnedRecipe(elementData.recipeInfo) or elementData.recipeInfo;

    self.Label:SetText(recipeInfo.name);
    -- self.learned = recipeInfo.learned;
    self:SetLabelFontColors(self:GetLabelColor());

    -- if true then return end
    --[[ 
    local rightFrames = {};

    self.LockedIcon:Hide();

    local function OnClick(button, buttonName, down)
        self:Click(buttonName, down);
    end
  ]]

    --[[ 
  ["Professions-Icon-Skill-High"]={13, 15, 0.263184, 0.269531, 0.0537109, 0.0683594, false, false, "1x"},
  ["Professions-Icon-Skill-Low"]={13, 15, 0.255859, 0.262207, 0.0537109, 0.0683594, false, false, "1x"},
  ["Professions-Icon-Skill-Medium"]={13, 15, 0.294922, 0.30127, 0.0537109, 0.0683594, false, false, "1x"}, ]]

    -- self.SkillUps:Hide();
    local tooltipSkillUpString = nil;

    local tex = base .. 'professions'
    local xOfs = -9;
    local yOfs = 0;

    local icon = self.SkillUps.Icon
    -- icon:ClearAllPoints()
    -- icon:SetPoint('LEFT', self, 'LEFT', -9, 1)
    icon:Show()

    local skillType = recipeInfo.skillType

    if skillType == 'trivial' then
        --       
        icon:Hide()
    elseif skillType == 'easy' then
        --
        icon:SetTexCoord(0.255859, 0.262207, 0.0537109, 0.0683594)
        tooltipSkillUpString = PROFESSIONS_SKILL_UP_EASY
    elseif skillType == 'medium' then
        icon:SetTexCoord(0.294922, 0.30127, 0.0537109, 0.0683594)
        tooltipSkillUpString = PROFESSIONS_SKILL_UP_MEDIUM
    elseif skillType == 'optimal' then
        icon:SetTexCoord(0.263184, 0.269531, 0.0537109, 0.0683594)
        tooltipSkillUpString = PROFESSIONS_SKILL_UP_OPTIMAL
    elseif skillType == 'difficult' then
        --
        icon:Hide()
    end

    if tooltipSkillUpString then
        local isDifficultyOptimal = skillType == 'optimal'
        local numSkillUps = recipeInfo.numSkillUps and recipeInfo.numSkillUps or 1;
        local hasMultipleSkillUps = numSkillUps > 1;
        local hasSkillUps = numSkillUps > 0;
        local showText = hasMultipleSkillUps and isDifficultyOptimal;
        self.SkillUps.Text:SetShown(showText);
        -- print('->', isDifficultyOptimal, numSkillUps, hasMultipleSkillUps, hasSkillUps, showText)
        if hasSkillUps then
            if showText then
                self.SkillUps.Text:SetText(numSkillUps);
                -- self.SkillUps.Text:SetVertexColor(DifficultyColors[recipeInfo.relativeDifficulty]:GetRGB());
            end

            self.SkillUps:SetScript("OnEnter", function()
                self:OnEnter();
                GameTooltip:SetOwner(self.SkillUps, "ANCHOR_RIGHT");
                GameTooltip_AddNormalLine(GameTooltip, tooltipSkillUpString:format(numSkillUps));
                GameTooltip:Show();
            end);
        else
            self.SkillUps:SetScript("OnEnter", nil);
        end

    end

    local count = recipeInfo.numAvailable -- + 69
    local hasCount = count > 0;
    if hasCount then
        self.Count:SetFormattedText(" [%d] ", count);
        self.Count:Show();
    else
        self.Count:Hide();
    end

    local padding = 10;
    local countWidth = hasCount and self.Count:GetStringWidth() or 0;
    local width = self:GetWidth() - (countWidth + padding + self.SkillUps:GetWidth());
    self.Label:SetWidth(self:GetWidth());
    self.Label:SetWidth(math.min(width, self.Label:GetStringWidth()));
end

function DFProfessionsRecipeListRecipeMixin:SetLabelFontColors(color)
    self.Label:SetVertexColor(color:GetRGB());
    self.Count:SetVertexColor(color:GetRGB());
end

function DFProfessionsRecipeListRecipeMixin:OnEnter()
    self:SetLabelFontColors(HIGHLIGHT_FONT_COLOR);
    local elementData = self:GetElementData();
    local recipeID = elementData.data.recipeInfo.recipeID;
    local name = elementData.data.recipeInfo.name;
    local iconID = elementData.data.recipeInfo.icon;

    if self.Label:IsTruncated() then
        GameTooltip:SetOwner(self.Label, "ANCHOR_RIGHT");
        local wrap = false;
        GameTooltip_AddHighlightLine(GameTooltip, name, wrap);
        GameTooltip:Show();
    end

    -- EventRegistry:TriggerEvent("Professions.RecipeListOnEnter", self, elementData.data);
end

function DFProfessionsRecipeListRecipeMixin:OnLeave()
    self:SetLabelFontColors(self:GetLabelColor());
    GameTooltip:Hide();
end

function DFProfessionsRecipeListRecipeMixin:SetSelected(selected)
    self.SelectedOverlay:SetShown(selected);
    self.HighlightOverlay:SetShown(not selected);
end

------------------------------
DFProfessionsRecipeSchematicFormMixin = {}

function DFProfessionsRecipeSchematicFormMixin:OnLoad()
    -- print('DFProfessionsRecipeSchematicFormMixin:OnLoad()')
end

function DFProfessionsRecipeSchematicFormMixin:OnShow()
    -- print('DFProfessionsRecipeSchematicFormMixin:OnShow()')
end

function DFProfessionsRecipeSchematicFormMixin:OnHide()
    -- print('DFProfessionsRecipeSchematicFormMixin:OnHide()')
end

function DFProfessionsRecipeSchematicFormMixin:OnEvent()
    -- print('DFProfessionsRecipeSchematicFormMixin:OnEvent()')
end

------------------------------
DFProfessionSearchBoxTemplateMixin = {}

function DFProfessionSearchBoxTemplateMixin:OnLoad()
    -- print('DFProfessionSearchBoxTemplateMixin:OnLoad()')
end

function DFProfessionSearchBoxTemplateMixin:OnHide()
    -- print('DFProfessionSearchBoxTemplateMixin:OnHide()')
    self.clearButton:Click();
    SearchBoxTemplate_OnTextChanged(self);
end

function DFProfessionSearchBoxTemplateMixin:OnTextChanged()
    -- print('DFProfessionSearchBoxTemplateMixin:OnTextChanged()')
    SearchBoxTemplate_OnTextChanged(self);
    TradeSkillFrameEditBox:SetText(self:GetText())
end

function DFProfessionSearchBoxTemplateMixin:OnChar()
    -- print('DFProfessionSearchBoxTemplateMixin:OnChar()')
    -- clear focus if the player is repeating keys (ie - trying to move)
    -- TODO: move into base editbox code?
    local MIN_REPEAT_CHARACTERS = 4;
    local searchString = self:GetText();
    if (string.len(searchString) >= MIN_REPEAT_CHARACTERS) then
        local repeatChar = true;
        for i = 1, MIN_REPEAT_CHARACTERS - 1, 1 do
            if (string.sub(searchString, (0 - i), (0 - i)) ~= string.sub(searchString, (-1 - i), (-1 - i))) then
                repeatChar = false;
                break
            end
        end
        if (repeatChar) then self:ClearFocus(); end
    end
end
