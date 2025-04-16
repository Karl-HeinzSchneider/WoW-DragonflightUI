---@diagnostic disable: redundant-parameter
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

DFEquipmentManagerMixin = {}

-- Sidebar
local PAPERDOLL_SIDEBARS = {
    {
        name = PAPERDOLL_SIDEBAR_STATS,
        icon = nil, -- Uses the character portrait
        texCoords = {0.109375, 0.890625, 0.09375, 0.90625},
        disabledTooltip = nil,
        IsActive = function()
            return true;
        end
    }, {
        name = PAPERDOLL_SIDEBAR_TITLES,
        icon = "Interface\\PaperDollInfoFrame\\PaperDollSidebarTabs",
        texCoords = {0.01562500, 0.53125000, 0.32421875, 0.46093750},
        disabledTooltip = NO_TITLES_TOOLTIP,
        IsActive = function()
            -- You always have the "No Title" title so you need to have more than one to have an option.
            -- return #GetKnownTitles() > 1;
            return false;
        end
    }, {
        name = PAPERDOLL_EQUIPMENTMANAGER,
        icon = "Interface\\PaperDollInfoFrame\\PaperDollSidebarTabs",
        texCoords = {0.01562500, 0.53125000, 0.46875000, 0.60546875},
        disabledTooltip = function()
            local _, failureReason = C_LFGInfo.CanPlayerUseLFD();
            return failureReason;
        end,
        IsActive = function()
            return C_EquipmentSet.GetNumEquipmentSets() > 0 or C_LFGInfo.CanPlayerUseLFD();
        end
    }
};

DragonflightUISidebarMixin = {}

function DragonflightUISidebarMixin:OnLoad()
    print('OnLoads DragonflightUISidebarMixin')

    _G['DFPaperDollSidebarTab2']:Disable()
end

function DragonflightUISidebarMixin:GetPaperDollSideBarFrame(index)
    if index == 1 then
        return _G['DragonflightUICharacterStatsPanel'];
    elseif index == 2 then
        return _G['DragonflightUICharacterTitlePanel'];
    elseif index == 3 then
        return _G['DragonflightUICharacterEquipmentManagerPanel'];
    end
end

function DragonflightUISidebarMixin:SetSidebar(index)
    local frame = self:GetPaperDollSideBarFrame(index);
    if (not frame:IsShown()) then
        for i = 1, #PAPERDOLL_SIDEBARS do
            local barFrame = self:GetPaperDollSideBarFrame(i);
            barFrame:Hide();
        end
        frame:Show();
        self.currentSideBar = frame;
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
        self:UpdateSidebarTabs();
    end
end

function DragonflightUISidebarMixin:UpdateSidebarTabs()
    for i = 1, #PAPERDOLL_SIDEBARS do
        local tab = _G["PaperDollSidebarTab" .. i];
        if (tab) then
            local frame = self:GetPaperDollSideBarFrame(i);
            if (frame:IsShown()) then
                tab.Hider:Hide();
                tab.Highlight:Hide();
                tab.TabBg:SetTexCoord(0.01562500, 0.79687500, 0.78906250, 0.95703125);
            else
                tab.Hider:Show();
                tab.Highlight:Show();
                tab.TabBg:SetTexCoord(0.01562500, 0.79687500, 0.61328125, 0.78125000);
                if (PAPERDOLL_SIDEBARS[i].IsActive()) then
                    tab:Enable();
                else
                    tab:Disable();
                end
            end
        end
    end
end

-- Tabs

DragonflightUISidebarTabMixin = {}

function DragonflightUISidebarTabMixin:OnLoad()
    -- print('OnLoads DragonflightUISidebarTabMixin')

    if self:GetID() == 1 then
        self:RegisterEvent("UNIT_PORTRAIT_UPDATE");
        self:RegisterEvent("PORTRAITS_UPDATED");
        self:RegisterEvent("PLAYER_ENTERING_WORLD");

        local tcoords = PAPERDOLL_SIDEBARS[self:GetID()].texCoords;
        self.Icon:SetTexCoord(tcoords[1], tcoords[2], tcoords[3], tcoords[4]);
        self.Icon:SetSize(29, 31);
        self.Icon:SetPoint("BOTTOM", 1, 0);
    else
        self.Icon:SetTexture(PAPERDOLL_SIDEBARS[self:GetID()].icon);
        local tcoords = PAPERDOLL_SIDEBARS[self:GetID()].texCoords;
        self.disabledTooltip = PAPERDOLL_SIDEBARS[self:GetID()].disabledTooltip;
        self.Icon:SetTexCoord(tcoords[1], tcoords[2], tcoords[3], tcoords[4]);
    end

end

function DragonflightUISidebarTabMixin:OnClick()
    -- print('OnClick DragonflightUISidebarTabMixin')
    -- PaperDollFrame_SetSidebar(self, self:GetID());
    self:GetParent():SetSidebar(self:GetID())
end

function DragonflightUISidebarTabMixin:OnEnable()
    -- print('OnEnable DragonflightUISidebarTabMixin')
    self:SetAlpha(1);
    self.Icon:SetDesaturation(0);
end

function DragonflightUISidebarTabMixin:OnDisable()
    -- print('OnDisable DragonflightUISidebarTabMixin')
    self:SetAlpha(0.5);
    self.Icon:SetDesaturation(1);
end

function DragonflightUISidebarTabMixin:OnEnter()
    -- print('OnEnter DragonflightUISidebarTabMixin')
    -- PaperDollFrame_SidebarTab_OnEnter

    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    GameTooltip_SetTitle(GameTooltip, PAPERDOLL_SIDEBARS[self:GetID()].name);
    if not self:IsEnabled() and self.disabledTooltip then
        local disabledTooltipText = GetValueOrCallFunction(self, "disabledTooltip");
        GameTooltip_AddErrorLine(GameTooltip, disabledTooltipText, true);
    end
    GameTooltip:Show();
end

function DragonflightUISidebarTabMixin:OnLeave()
    -- print('OnLeave DragonflightUISidebarTabMixin')
    GameTooltip:Hide();
end

-- manager
DragonflightUIEquipmentManagerPanelMixin = CreateFromMixins(CallbackRegistryMixin);
DragonflightUIEquipmentManagerPanelMixin:GenerateCallbackEvents({"OnDefaults", "OnRefresh"});

function DragonflightUIEquipmentManagerPanelMixin:OnLoad()
    print('OnLoad DragonflightUIEquipmentManagerPanelMixin')
    CallbackRegistryMixin.OnLoad(self);

    self:RegisterEvent("EQUIPMENT_SWAP_FINISHED");
    self:RegisterEvent("EQUIPMENT_SETS_CHANGED");
    self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
    self:RegisterEvent("BAG_UPDATE");

    local view = CreateScrollBoxListLinearView();
    view:SetElementInitializer("DFGearSetButtonTemplate", function(button, elementData)
        print('SetElementInitializer')
        self:InitButton(button, elementData);
        button.PanelRef = self;
    end);
    view:SetPadding(0, 0, 3, 0, 2);

    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, view);
end

function DragonflightUIEquipmentManagerPanelMixin:OnShow()
    print('OnShow DragonflightUIEquipmentManagerPanelMixin')
    self:Update(true)
    -- EquipmentFlyoutPopoutButton_ShowAll();
end

function DragonflightUIEquipmentManagerPanelMixin:OnHide()
    print('OnHide DragonflightUIEquipmentManagerPanelMixin')
    -- EquipmentFlyoutPopoutButton_HideAll();
    -- PaperDollFrame_ClearIgnoredSlots();
    -- GearManagerPopupFrame:Hide();
    -- StaticPopup_Hide("CONFIRM_SAVE_EQUIPMENT_SET");
    -- StaticPopup_Hide("CONFIRM_OVERWRITE_EQUIPMENT_SET");
end

function DragonflightUIEquipmentManagerPanelMixin:OnUpdate()
    -- print('OnUpdate DragonflightUIEquipmentManagerPanelMixin')
    self.ScrollBox:ForEachFrame(function(button)
        if (button:IsMouseOver()) then
            if (button.setID) then
                button.DeleteButton:Show();
                button.EditButton:Show();
            else
                button.DeleteButton:Hide();
                button.EditButton:Hide();
            end
            button.HighlightBar:Show();
        else
            button.DeleteButton:Hide();
            button.EditButton:Hide();
            button.HighlightBar:Hide();
        end
    end);

    if (self.queuedUpdate) then
        self:Update()
        self.queuedUpdate = false;
    end
end

function DragonflightUIEquipmentManagerPanelMixin:OnEvent(event, ...)
    -- print('OnEvent DragonflightUIEquipmentManagerPanelMixin')
    print('~', event, ...)

    if (event == "EQUIPMENT_SWAP_FINISHED") then
        local completed, setID = ...;
        if (completed) then
            PlaySound(SOUNDKIT.PUT_DOWN_SMALL_CHAIN); -- plays the equip sound for plate mail
            if (self:IsShown()) then
                self.selectedSetID = setID;
                self:Update()
            end
        end
    end

    if (self:IsShown()) then
        if (event == "EQUIPMENT_SETS_CHANGED") then
            self:Update(true)
        elseif (event == "PLAYER_EQUIPMENT_CHANGED" or event == "BAG_UPDATE") then
            -- This queues the update to only happen once at the end of the frame
            self.queuedUpdate = true;
        end
    end
end

function DragonflightUIEquipmentManagerPanelMixin:Update(equipmentSetsDirty)
    print('--update', equipmentSetsDirty)
    local _, setID, isEquipped;
    if (self.selectedSetID) then _, _, setID, isEquipped = C_EquipmentSet.GetEquipmentSetInfo(self.selectedSetID); end

    if (setID) then
        if (isEquipped) then
            self.SaveSet:Disable();
            self.EquipSet:Disable();
        else
            self.SaveSet:Enable();
            self.EquipSet:Enable();
        end
        -- PaperDollFrame_IgnoreSlotsForSet(setID);
    else
        self.SaveSet:Disable();
        self.EquipSet:Disable();

        -- Clear selected equipment set if it doesn't exist
        if (self.selectedSetID) then
            self.selectedSetID = nil;
            -- PaperDollFrame_ClearIgnoredSlots();
        end
    end

    if (equipmentSetsDirty) then
        self.equipmentSetIDs = self:SortEquipmentSetIDs(C_EquipmentSet.GetEquipmentSetIDs());
    end

    DevTools_Dump(self.equipmentSetIDs)

    local dataProvider = CreateDataProvider();

    local numSets = #self.equipmentSetIDs;
    for index = 1, numSets do
        --
        print('~set:', index, ' of ', numSets)
        dataProvider:Insert({index = index});
    end

    if (numSets < MAX_EQUIPMENT_SETS_PER_PLAYER) then
        -- print('numSets < MAX_EQUIPMENT_SETS_PER_PLAYER')
        dataProvider:Insert({addSetButton = true}); -- "Add New Set" button  
    end

    DevTools_Dump(dataProvider:GetSize())

    self.ScrollBox:SetDataProvider(dataProvider, ScrollBoxConstants.RetainScrollPosition);
end

function DragonflightUIEquipmentManagerPanelMixin:SortEquipmentSetIDs(equipmentSetIDs)
    local sortedIDs = {};

    -- Add all the spec-assigned sets first because they should appear first.
    for i, equipmentSetID in ipairs(equipmentSetIDs) do
        if C_EquipmentSet.GetEquipmentSetAssignedSpec(equipmentSetID) then
            sortedIDs[#sortedIDs + 1] = equipmentSetID;
        end
    end

    for i, equipmentSetID in ipairs(equipmentSetIDs) do
        if not C_EquipmentSet.GetEquipmentSetAssignedSpec(equipmentSetID) then
            sortedIDs[#sortedIDs + 1] = equipmentSetID;
        end
    end

    return sortedIDs;
end

function DragonflightUIEquipmentManagerPanelMixin:SetButtonSelected(button, selected)
    if selected then
        button.SelectedBar:Show();
    else
        button.SelectedBar:Hide();
    end
end

function DragonflightUIEquipmentManagerPanelMixin:InitButton(button, elementData)
    print('InitButton')
    if elementData.addSetButton then
        button.setID = nil;
        button.text:SetText(PAPERDOLL_NEWEQUIPMENTSET);
        button.text:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
        button.icon:SetTexture("Interface\\PaperDollInfoFrame\\Character-Plus");
        button.icon:SetSize(30, 30);
        button.icon:SetPoint("LEFT", 7, 0);
        button.Check:Hide();
        button.SelectedBar:Hide();
        SetClampedTextureRotation(button.BgBottom, 180);

    else
        local index = elementData.index;

        local equipmentSetIDs = self.equipmentSetIDs;
        local equipmentSetIndex = equipmentSetIDs[index];
        local numRows = #equipmentSetIDs;
        local name, texture, setID, isEquipped, _, _, _, numLost = C_EquipmentSet.GetEquipmentSetInfo(equipmentSetIndex);
        button.setID = setID;
        button.text:SetText(name);
        if (numLost > 0) then
            button.text:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
        else
            button.text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        end
        if (texture) then
            button.icon:SetTexture(texture);
        else
            button.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
        end

        local currentSelectionID = self.selectedSetID;
        local selected = currentSelectionID and button.setID == currentSelectionID;
        self:SetButtonSelected(button, selected);

        if (isEquipped) then
            button.Check:Show();
        else
            button.Check:Hide();
        end
        button.icon:SetSize(36, 36);
        button.icon:SetPoint("LEFT", 4, 0);

        if (index == 1) then
            button.BgTop:Show();
            button.BgMiddle:SetPoint("TOP", button.BgTop, "BOTTOM");
        else
            button.BgTop:Hide();
            button.BgMiddle:SetPoint("TOP");
        end

        if (equipmentSetIndex == numRows) then
            button.BgBottom:Show();
            button.BgMiddle:SetPoint("BOTTOM", button.BgBottom, "TOP");
        else
            button.BgBottom:Hide();
            button.BgMiddle:SetPoint("BOTTOM");
        end

        if (index % 2 == 0) then
            button.Stripe:SetColorTexture(STRIPE_COLOR.r, STRIPE_COLOR.g, STRIPE_COLOR.b);
            button.Stripe:SetAlpha(0.1);
            button.Stripe:Show();
        else
            button.Stripe:Hide();
        end
    end

    button:UpdateSpecInfo()
end

-- gearset button
DragonflightUIGearSetButtonMixin = {}

function DragonflightUIGearSetButtonMixin:OnLoad()
    print('DragonflightUIGearSetButtonMixin:OnLoad()')
    self:RegisterForDrag("LeftButton");
    SetClampedTextureRotation(self.BgBottom, 180);
end

function DragonflightUIGearSetButtonMixin:OnClick(button, down)
    print('DragonflightUIGearSetButtonMixin:OnClick(button, down)', button, down)
    -- GearSetButton_OnClick(self, button, down);
    if (self.setID) then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON); -- inappropriately named, but a good sound.
        self.PanelRef.selectedSetID = self.setID;
        -- mark the ignored slots
        -- PaperDollFrame_ClearIgnoredSlots();
        -- PaperDollFrame_IgnoreSlotsForSet(self.setID);
        -- GearManagerPopupFrame:Hide();
    else
        -- This is the "New Set" button
        -- GearManagerPopupFrame.mode = IconSelectorPopupFrameModes.New;
        -- GearManagerPopupFrame:Show();
        self.PanelRef.selectedSetID = nil;
        -- PaperDollFrame_ClearIgnoredSlots();
        -- Ignore shirt and tabard by default
        -- PaperDollFrame_IgnoreSlot(4);
        -- PaperDollFrame_IgnoreSlot(19);
    end
    self.PanelRef:Update();

    StaticPopup_Hide("CONFIRM_SAVE_EQUIPMENT_SET");
    StaticPopup_Hide("CONFIRM_OVERWRITE_EQUIPMENT_SET");
end

function DragonflightUIGearSetButtonMixin:OnDoubleClick()
    if (self.setID) then
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB); -- inappropriately named, but a good sound.
        -- EquipmentManager_EquipSet(self.setID);
    end
end

function DragonflightUIGearSetButtonMixin:OnEnter()
    -- GearSetButton_OnEnter(self);
    if (self.setID) then
        GameTooltip_SetDefaultAnchor(GameTooltip, self);
        GameTooltip:SetEquipmentSet(self.setID);
    end
end

function DragonflightUIGearSetButtonMixin:OnLeave()
    GameTooltip:Hide();
end

function DragonflightUIGearSetButtonMixin:OnDragStart()
    if (self.setID) then C_EquipmentSet.PickupEquipmentSet(self.setID); end
end

function DragonflightUIGearSetButtonMixin:SetSpecInfo(specID)
    if (specID and specID > 0) then
        self.specID = specID;
        local id, name, description, texture, role, class = GetSpecializationInfoByID(specID);
        SetPortraitToTexture(self.SpecIcon, texture);
        self.SpecIcon:Show();
        self.SpecRing:Show();
    else
        self.specID = nil;
        self.SpecIcon:Hide();
        self.SpecRing:Hide();
    end
end

function DragonflightUIGearSetButtonMixin:UpdateSpecInfo()
    if (not self.setID) then
        self:SetSpecInfo(nil);
        return;
    end

    local specIndex = C_EquipmentSet.GetEquipmentSetAssignedSpec(self.setID);
    if (not specIndex) then
        self:SetSpecInfo(nil);
        return;
    end

    local specID = GetSpecializationInfo(specIndex);
    self:SetSpecInfo(specID);
end

