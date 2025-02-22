DragonflightUICharacterStatsPanelMixin = CreateFromMixins(CallbackRegistryMixin);
DragonflightUICharacterStatsPanelMixin:GenerateCallbackEvents({"OnDefaults", "OnRefresh"});

function DragonflightUICharacterStatsPanelMixin:OnLoad()
    print('DragonflightUICharacterStatsPanelMixin:OnLoad()')
    CallbackRegistryMixin.OnLoad(self);

    -- self:SetupScrollBox()
end

function DragonflightUICharacterStatsPanelMixin:SetupScrollBox()
    self.DataProvider = CreateTreeDataProvider();

    local indent = 0;
    local verticalPad = 10;
    local padLeft, padRight = 25, 0;
    local spacing = 9;

    self.ScrollView = CreateScrollBoxListTreeListView(indent, verticalPad, verticalPad, padLeft, padRight, spacing);

    self.ScrollView:SetElementFactory(function(factory, node)
        -- DevTools_Dump(node)
        local elementData = node:GetData();
        local elementType = elementData.args.type;

        -- local function Initializer(button, n)
        --     self:UnregisterCallback('OnDefaults', button);
        --     self:UnregisterCallback('OnRefresh', button);

        --     self:RegisterCallback('OnDefaults', function(btn, message)
        --         --
        --         -- print(btn, message)
        --         button:Init(n);
        --     end, button)
        --     self:RegisterCallback('OnRefresh', function(btn, message)
        --         --
        --         -- print(btn, message)
        --         button:Init(n);
        --     end, button)

        --     button:Init(n);

        --     if elementType == 'header' then
        --         button.Tooltip:SetScript("OnMouseDown", function(_, _)
        --             node:ToggleCollapsed();
        --             button:SetCollapseState(node:IsCollapsed());
        --             PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
        --         end);
        --     end
        -- end

        -- if elementType == 'header' then
        --     factory("DFSettingsListHeader", Initializer);
        -- elseif elementType == 'divider' then
        --     factory("DFSettingsListDivider", Initializer);
        -- elseif elementType == 'toggle' then
        --     factory("DFSettingsListCheckboxContainer", Initializer);
        -- elseif elementType == 'range' then
        --     factory("DFSettingsListSliderContainer", Initializer);
        -- elseif elementType == 'execute' then
        --     factory("DFSettingsListButton", Initializer);
        -- elseif elementType == 'select' then
        --     if DF.Wrath and not DF.Cata then
        --         factory("DFSettingsListDropdownContainer_Compat", Initializer);
        --     else
        --         factory("DFSettingsListDropdownContainer", Initializer);
        --     end
        -- elseif elementType == 'editbox' then
        --     factory("DFSettingsListEditbox", Initializer);
        -- elseif elementType == 'color' then
        --     factory("DFSettingsListColorPicker", Initializer);
        -- else
        --     print('~no factory: ', elementType, ' ~')
        --     factory("Frame");
        -- end
    end);

    self.ScrollView:SetDataProvider(self.DataProvider)

    local elementSize = DFSettingsListMixin.ElementSize;

    self.ScrollView:SetElementExtentCalculator(function(dataIndex, node)
        local elementData = node:GetData();

        return elementSize[elementData.args.type] or 1;
    end);

    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView);

    local scrollBoxAnchors = {
        CreateAnchor("TOPLEFT", self.Header, "BOTTOMLEFT", -15, -2), CreateAnchor("BOTTOMRIGHT", -20, -2)
    };
    ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, scrollBoxAnchors, scrollBoxAnchors);
end
-- function DragonflightUICharacterStatsPanelMixin:OnLoad()
-- end

-- expand button
DragonflightUICharacterFrameExpandButtonMixin = {}

function DragonflightUICharacterFrameExpandButtonMixin:OnLoad()
    self:SetFrameLevel(self:GetParent():GetFrameLevel() + 2);

    self.collapseTooltip = STATS_COLLAPSE_TOOLTIP;
    self.expandTooltip = STATS_EXPAND_TOOLTIP;

    self:AddCharacterFrameFunctions()
end

function DragonflightUICharacterFrameExpandButtonMixin:OnClick()
    if (CharacterFrame.Expanded) then
        -- SetCVar("characterFrameCollapsed", "1");
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE);
        CharacterFrame:Collapse();
    else
        -- SetCVar("characterFrameCollapsed", "0");
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN);
        CharacterFrame:Expand();
    end
    if (GameTooltip:GetOwner() == self) then self:GetScript("OnEnter")(self); end
end

function DragonflightUICharacterFrameExpandButtonMixin:OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    if (CharacterFrame.Expanded) then
        GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE .. self.collapseTooltip .. FONT_COLOR_CODE_CLOSE);
    else
        GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE .. self.expandTooltip .. FONT_COLOR_CODE_CLOSE);
    end
end

function DragonflightUICharacterFrameExpandButtonMixin:OnLeave()
    GameTooltip:Hide();
end

function DragonflightUICharacterFrameExpandButtonMixin:AddCharacterFrameFunctions()
    function CharacterFrame:Collapse()
        self.Expanded = false;
        CharacterFrame:DFUpdateFrameWidth(false);
        -- characterFrameDisplayInfo["Default"].width = PANEL_DEFAULT_WIDTH;
        -- characterFrameDisplayInfo["PetPaperDollFrame"].width = PANEL_DEFAULT_WIDTH;
        self.DFExpandButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up");
        self.DFExpandButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down");
        self.DFExpandButton:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled");
        -- for i = 1, #PAPERDOLL_SIDEBARS do GetPaperDollSideBarFrame(i):Hide(); end
        self.DFInsetRight:Hide();
        -- PaperDollFrame_SetLevel();
        -- self:RefreshDisplay();
    end

    function CharacterFrame:Expand()
        self.Expanded = true;
        CharacterFrame:DFUpdateFrameWidth(true);
        -- characterFrameDisplayInfo["Default"].width = CHARACTERFRAME_EXPANDED_WIDTH;
        -- characterFrameDisplayInfo["PetPaperDollFrame"].width = CHARACTERFRAME_EXPANDED_WIDTH;
        self.DFExpandButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up");
        self.DFExpandButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down");
        self.DFExpandButton:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled");
        -- if (PaperDollFrame:IsShown() and PaperDollFrame.currentSideBar) then
        --     PaperDollFrame.currentSideBar:Show();
        -- else
        --     CharacterStatsPane:Show();
        -- end
        -- PaperDollFrame_UpdateSidebarTabs();
        self.DFInsetRight:Show();
        -- PaperDollFrame_SetLevel();
        -- self:RefreshDisplay();
    end
end

