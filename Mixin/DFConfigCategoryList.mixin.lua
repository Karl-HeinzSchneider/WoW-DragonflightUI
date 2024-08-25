---@diagnostic disable: inject-field, undefined-field
-- List
local DF_selectionBehavior;
DragonFlightUIConfigCategoryListMixin = CreateFromMixins(CallbackRegistryMixin);

DragonFlightUIConfigCategoryListMixin:GenerateCallbackEvents({"OnSelectionChanged"});

function DragonFlightUIConfigCategoryListMixin:OnLoad()
    -- print('DragonFlightUIConfigCategoryListMixin:OnLoad()')
    CallbackRegistryMixin.OnLoad(self)

    self.Cats = {}

    self.DataProvider = CreateDataProvider()

    -- The scroll box is anchored -50 so that the "new" label can appear without
    -- being clipped. This offset moves the contents back into the desired position.
    local leftPad = 50;

    local pad = 0;
    local spacing = 2;

    ---@diagnostic disable-next-line: undefined-global
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

    self.ScrollView:SetElementInitializer("DragonflightUIConfigCategoryListElementTemplate",
                                          GenerateClosure(self.OnElementInitialize, self));
    self.ScrollView:SetElementResetter(GenerateClosure(self.OnElementReset, self));

    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView)

    local scrollBoxAnchorsWithBar = {CreateAnchor("TOPLEFT", -leftPad, 0), CreateAnchor("BOTTOMRIGHT", -16, 0)};
    local scrollBoxAnchorsWithoutBar = {scrollBoxAnchorsWithBar[1], CreateAnchor("BOTTOMRIGHT", 0, 0)};
    ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, scrollBoxAnchorsWithBar,
                                                     scrollBoxAnchorsWithoutBar);

    self.selectionBehavior = ScrollUtil.AddSelectionBehavior(self.ScrollBox);
    self.selectionBehavior:RegisterCallback("OnSelectionChanged", self.OnElementSelectionChanged, self)
end

function DragonFlightUIConfigCategoryListMixin:OnElementInitialize(element, elementData)
    element:Init(elementData, nil)
    element.Button:SetSelected(self.selectionBehavior:IsSelected(element))

    if not elementData.header and not elementData.spacer then
        local _cat = self.Cats[elementData.cat]
        if _cat[elementData.name] then
            element.Button:SetEnabled(true)
        else
            element.Button:SetEnabled(false)
        end
        element:RegisterCallback('OnClick', self.OnElementClicked, self)
    end
end

function DragonFlightUIConfigCategoryListMixin:OnElementReset(element)
    element:UnregisterCallback("OnClick", self);
end

function DragonFlightUIConfigCategoryListMixin:OnElementClicked(element)
    -- print('OnElementClicked', element.elementData.name)
    self.selectionBehavior:Select(element);
end

function DragonFlightUIConfigCategoryListMixin:OnElementSelectionChanged(elementData, selected)
    -- Trigger a visual update on the item that was just [de]selected prior
    -- to notifying listeners of the change in selection.
    -- print('OnElementSelectionChanged', elementData.name, selected)
    local element = self.ScrollView:FindFrame(elementData);

    if element then element.Button:SetSelected(selected); end

    -- The below is set up such that we'll only notify listeners of our
    -- *new* selection, and not that we've deselected something in order
    -- to select something new first.

    if selected then
        self:TriggerEvent("OnSelectionChanged", elementData, selected);
        self.ScrollBox:ScrollToElementData(elementData, ScrollBoxConstants.AlignNearest);
    end
end

function DragonFlightUIConfigCategoryListMixin:AddElement(elementData)
    self.DataProvider:Insert(elementData)

    if elementData.header then self.Cats[elementData.name] = {} end
end

function DragonFlightUIConfigCategoryListMixin:FindElement(cat, sub)
    local view = self.ScrollView:GetView()
end

function DragonFlightUIConfigCategoryListMixin:SetDisplayData(cat, sub, data)
    -- print('SetDisplayData', cat, sub, data)
    local displayFrame = CreateFrame('Frame', nil, nil, 'SettingsListTemplateDF')
    displayFrame:Display(data)

    local _cat = self.Cats[cat]
    _cat[sub] = {displayFrame = displayFrame}

    local elementData = {name = sub, cat = cat}
    local element = self:GetCatSubScrollElement(cat, sub)

    if element then element.Button:SetEnabled(true); end
end

function DragonFlightUIConfigCategoryListMixin:GetCatSubScrollElement(cat, sub)
    local element = self.ScrollView:FindFrameByPredicate(function(frame, data)
        if (data.name == sub) and (data.cat == cat) then
            return true
        else
            return false
        end
    end);

    return element
end

-- Element
DragonFlightUIConfigCategoryListElementMixin = CreateFromMixins(CallbackRegistryMixin);
DragonFlightUIConfigCategoryListElementMixin:GenerateCallbackEvents({"OnClick"});

function DragonFlightUIConfigCategoryListElementMixin:OnLoad()
    -- print('DragonFlightUIConfigCategoryListElementMixin:OnLoad()')
    CallbackRegistryMixin.OnLoad(self);

    self.Button:SetScript('OnMouseUp', function(button, buttonName, down)
        self:OnMouseUp()
    end)
end

function DragonFlightUIConfigCategoryListElementMixin:OnMouseUp()
    -- DevTools_Dump(self.elementData)

    if self.elementData.header then
    elseif self.Button:IsEnabled() then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
        self:TriggerEvent("OnClick", self);
    else
        -- print('else')
    end
end

function DragonFlightUIConfigCategoryListElementMixin:Init(elementData, listRef)
    -- print('DragonFlightUIConfigCategoryListElementMixin:Init', elementData.name)
    self.listRef = listRef
    self.elementData = elementData
    self.Button.listRef = listRef
    self.Button.elementData = elementData
    self:Reset()

    -- self:RefreshCatState()

    if elementData.header then
        self.Header:Show()
        self.Header.Label:SetText(elementData.name)
    elseif elementData.spacer then
        -- do nothing
    else
        self.Button:Show()
        self.Button.Label:SetText(elementData.name)
        self.Button.NewFeature:SetShown(elementData.new)
    end
end

function DragonFlightUIConfigCategoryListElementMixin:Reset()
    self.Header:Hide()
    self.Button:Hide()
    self.Button.NewFeature:Hide()
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

function DragonFlightUIConfigCategoryListButtonMixin:IsEnabled()
    return self.isEnabled
end

function DragonFlightUIConfigCategoryListButtonMixin:SetEnabled(enabled)
    self.isEnabled = enabled
    self:UpdateState()
end

function DragonFlightUIConfigCategoryListButtonMixin:SetSelected(selected)
    self.isSelected = selected
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

