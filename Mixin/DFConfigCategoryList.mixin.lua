-- List
local DF_selectionBehavior;
DragonFlightUIConfigCategoryListMixin = CreateFromMixins(CallbackRegistryMixin);

DragonFlightUIConfigCategoryListMixin:GenerateCallbackEvents({"OnCategorySelected"});

function DragonFlightUIConfigCategoryListMixin:OnLoad()
    print('DragonFlightUIConfigCategoryListMixin:OnLoad()')

    self.Cats = {}
    self.CatsFrameData = {}

    self.DataProvider = CreateDataProvider()

    -- The scroll box is anchored -50 so that the "new" label can appear without
    -- being clipped. This offset moves the contents back into the desired position.
    local leftPad = 50;

    local pad = 0;
    local spacing = 2;

    self.ScrollView = CreateScrollBoxListLinearView(verticalPad, verticalPad, padLeft, padRight, spacing);
    self.ScrollView:SetDataProvider(self.DataProvider)

    local function ExtentCalculator(dataIndex, elementData)
        if elementData.header then return 30 end
        return 20
    end
    self.ScrollView:SetElementExtentCalculator(ExtentCalculator)

    local function IndentCalculator(elementData)
        return 50
    end
    self.ScrollView:SetElementIndentCalculator(IndentCalculator);

    local selfRef = self
    self.ScrollView:SetElementInitializer("DragonflightUIConfigCategoryListElementTemplate",
                                          function(frame, elementData)
        -- This is called each time the scrollview acquires a frame this
        -- should generally call a method on the acquired frame and update
        -- its visual state accordingly.
        frame:Init(elementData, selfRef)
    end)

    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView)

    local scrollBoxAnchorsWithBar = {CreateAnchor("TOPLEFT", -leftPad, 0), CreateAnchor("BOTTOMRIGHT", -16, 0)};
    local scrollBoxAnchorsWithoutBar = {scrollBoxAnchorsWithBar[1], CreateAnchor("BOTTOMRIGHT", 0, 0)};
    ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, scrollBoxAnchorsWithBar,
                                                     scrollBoxAnchorsWithoutBar);

    local function OnSelectionChanged(o, elementData, selected)
        local button = self.ScrollBox:FindFrame(elementData);
        if button then button:SetSelected(selected); end

        if selected then self.ScrollBox:ScrollToElementData(elementData, ScrollBoxConstants.AlignNearest); end
    end
end

function DragonFlightUIConfigCategoryListMixin:AddElement(elementData)
    self.DataProvider:Insert(elementData)

    if elementData.header then self.Cats[elementData.name] = {} end
end

function DragonFlightUIConfigCategoryListMixin:SetDisplayData(cat, sub, data)
    print('SetDisplayData', cat, sub, data)
    local displayFrame = CreateFrame('Frame', nil, nil, 'SettingsListTemplateDF')
    displayFrame:Display(data)

    local _cat = self.Cats[cat]
    _cat[sub] = {}
    _cat[sub].displayFrame = displayframe
end

function DragonFlightUIConfigCategoryListMixin:CatButtonClicked(elementData)
    print('CatButtonClicked', elementData.name)
end

-- Element
DragonFlightUIConfigCategoryListElementMixin = {}

function DragonFlightUIConfigCategoryListElementMixin:OnLoad()
    -- print('DragonFlightUIConfigCategoryListElementMixin:OnLoad()')
end

function DragonFlightUIConfigCategoryListElementMixin:Init(elementData, listRef)
    print('DragonFlightUIConfigCategoryListElementMixin:Init', elementData.name)
    self.listRef = listRef
    self.elementData = elementData
    self.Button.listRef = listRef
    self.Button.elementData = elementData
    self:Reset()

    -- self:RefreshCatState()

    if elementData.header then
        self.Header:Show()
        self.Header.Label:SetText(elementData.name)
    else
        self.Button:Show()
        self.Button.Label:SetText(elementData.name)
    end
end

function DragonFlightUIConfigCategoryListElementMixin:Reset()
    self.Header:Hide()
    self.Button:Hide()
end

function DragonFlightUIConfigCategoryListElementMixin:RefreshCatState()
    if self.elementData.header then return end

    local cat = self.elementData.cat
    local sub = self.elementData.name

    if self.listRef.Cats[cat][sub] then
        self.Button:SetEnabled(true)
    else
        self.Button:SetEnabled(false)
    end

    DevTools_Dump(self.listRef.Cats)
end

-- Header
DragonFlightUIConfigCategoryListHeaderMixin = {}

function DragonFlightUIConfigCategoryListHeaderMixin:OnLoad()
    -- print('DragonFlightUIConfigCategoryListHeaderMixin:OnLoad()')
    self.Background:SetAtlas('Options_CategoryHeader_1', true)
end

-- Button
DragonFlightUIConfigCategoryListButtonMixin = CreateFromMixins(ButtonStateBehaviorMixin)

function DragonFlightUIConfigCategoryListButtonMixin:OnLoad()
    -- print('DragonFlightUIConfigCategoryListButtonMixin:OnLoad()')

    self.over = nil
    self.down = nil
    self.isEnabled = false
    self.isSelected = false

    self.category = nil
    self.categoryRef = nil
    self.subCategory = nil

    self.displayData = nil
    self.displayFrame = nil

    self:UpdateState()
end

function DragonFlightUIConfigCategoryListButtonMixin:OnEnter()
    -- print(self:GetName(), 'OnEnter')
    if ButtonStateBehaviorMixin.OnEnter(self) then self:UpdateState(); end
end

function DragonFlightUIConfigCategoryListButtonMixin:OnLeave()
    -- print(self:GetName(), 'OnLeave')
    if ButtonStateBehaviorMixin.OnLeave(self) then self:UpdateState(); end
end

function DragonFlightUIConfigCategoryListButtonMixin:OnMouseDown()
    -- print(self:GetName(), 'OnMouseDown')
end

function DragonFlightUIConfigCategoryListButtonMixin:OnMouseUp()
    -- print(self:GetName(), 'OnMouseUp')  
    self:BtnClicked()
end

function DragonFlightUIConfigCategoryListButtonMixin:IsEnabled()
    return self.isEnabled
end

function DragonFlightUIConfigCategoryListButtonMixin:SetEnabled(enabled)
    self.isEnabled = enabled
    self:UpdateState()
end

function DragonFlightUIConfigCategoryListButtonMixin:BtnClicked()
    -- print('DragonFlightUIConfigCategoryListButtonMixin:BtnClicked()')
    -- if self:IsEnabled() then self.categoryRef.configRef:SubCategoryBtnClicked(self) end

    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
    self.listRef:CatButtonClicked(self.elementData)

    self:UpdateState()
end

function DragonFlightUIConfigCategoryListButtonMixin:UpdateState()
    -- self:UpdateStateInternal(g_selectionBehavior:IsSelected(self));
    if not self:IsEnabled() then
        self.Label:SetFontObject("GameFontHighlight");
        self.Label:SetAlpha(0.5)

        self.Texture:Hide()
    elseif self.isSelected then
        self.Label:SetFontObject("GameFontHighlight");
        self.Label:SetAlpha(1)

        self.Texture:SetAtlas("Options_List_Active", TextureKitConstants.UseAtlasSize);
        self.Texture:Show();
    else
        self.Label:SetFontObject("GameFontNormal");
        self.Label:SetAlpha(1)

        if self.over then
            self.Texture:SetAtlas("Options_List_Hover", TextureKitConstants.UseAtlasSize);
            self.Texture:Show();
        else
            self.Texture:Hide();
        end
    end
end

function DragonFlightUIConfigCategoryListButtonMixin:SetDisplayData(data)
    self.displayData = data
    -- if self.displayFrame then self.displayFrame:Hide() end
    self.displayFrame = CreateFrame('Frame', nil, nil, 'SettingsListTemplateDF')
    self.displayFrame:Display(data)
end

