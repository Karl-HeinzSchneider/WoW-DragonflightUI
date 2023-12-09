ScrollableListItemMixinDF = {}

function ScrollableListItemMixinDF:Init(elementData)
    -- self.Background:SetColorTexture(elementData.color:GetRGBA())
    -- self.Text:SetText(elementData.text)

    local key = elementData.key
    local data = elementData.args

    self:Reset()

    if data.type == 'header' then
        self:SetHeader(data.name)
    elseif data.type == 'range' then
        self:SetText(data.name)
        self:SetTooltip(data.name, data.desc)
        self:SetSlider(1, data.min, data.max, data.bigStep)
        -- DevTools_Dump(data)

        -- self.Item.Slider:SetMinMaxValues(0, 25);
        -- self.Item.Slider:SetValueStep(1);
        -- self.Item.Slider:SetValue(11);

    elseif data.type == 'execute' then
        self:SetText(data.name)
        self:SetTooltip(data.name, data.desc)

    elseif data.type == 'description' then
        self:SetText(data.name)
        self:SetTooltip(data.name, data.desc)

    elseif data.type == 'toggle' then
        self:SetText(data.name)
        self:SetTooltip(data.name, data.desc)
        self:SetCheckbox(true)

    elseif data.type == 'toggle' then
        --
    elseif data.type == 'toggle' then
    end
end

function ScrollableListItemMixinDF:Reset()
    self.Header:Hide()

    -- self.Item:ClearAllPoints()
    self.Item.Text:SetPoint("LEFT", 37, 0);
    self.Item.Text:SetPoint("RIGHT", self:GetParent(), "CENTER", -85, 0);
    self.Item:Hide()

    self.Item.Checkbox:SetParent(self)
    self.Item.Checkbox:SetPoint("LEFT", self, "CENTER", -80, 0)
    self.Item.Checkbox:Hide()

    self.Item.Slider:SetParent(self)
    self.Item.Slider:SetWidth(250)
    self.Item.Slider:SetPoint("LEFT", self, "CENTER", -80, 3)
    self.Item.Slider:Hide()
end

function ScrollableListItemMixinDF:SetHeader(header)
    self.Header:Show()
    self.Header.Title:SetText(header)
end

function ScrollableListItemMixinDF:SetText(text)
    self.Item:Show()
    self.Item.Text:SetText(text)
end

function ScrollableListItemMixinDF:SetTooltip(name, desc)
    local tooltipFunc = GenerateClosure(Settings.InitTooltip, name, desc or '')
    self.Item.Tooltip:SetTooltipFunc(tooltipFunc)
    self.Item.Checkbox.tooltipFunc = tooltipFunc
end

function ScrollableListItemMixinDF:SetCheckbox(checked)
    self.Item.Checkbox:SetValue(checked)
    self.Item.Checkbox:Show()
end

function ScrollableListItemMixinDF:SetSlider(value, minValue, maxValue, step)
    self.Item.Slider:Show()
    local options = Settings.CreateSliderOptions(0, 500, 1);
    self.Item.Slider.Slider:SetMinMaxValues(minValue, maxValue)
    self.Item.Slider.Slider:SetValueStep(step)
    self.Item.Slider.Slider:SetValue(42)
end

--- Checkbox
-- SettingsCheckBoxMixinDF = {};
SettingsCheckBoxMixinDF = CreateFromMixins(CallbackRegistryMixin);
SettingsCheckBoxMixinDF:GenerateCallbackEvents({"OnValueChanged"});

function SettingsCheckBoxMixinDF:OnLoad()
    CallbackRegistryMixin.OnLoad(self);

    self:SetScript('OnClick', function(button, buttonName, down)
        -- print(button, buttonName, down)
        self:TriggerEvent(SettingsCheckBoxMixinDF.Event.OnValueChanged, button:GetChecked())
    end)
end

function SettingsCheckBoxMixinDF:OnEnter()
    -- print('SettingsCheckBoxMixinDF OnEnter')
    local parent = self:GetParent()

    parent.Item.Tooltip.HoverBackground:Show()

    SettingsTooltip:SetOwner(self, 'ANCHOR_RIGHT', 0, 0);
    parent.Item.Checkbox.tooltipFunc()
    SettingsTooltip:Show()
end
function SettingsCheckBoxMixinDF:OnLeave()
    -- print('SettingsCheckBoxMixinDF OnLeave')
    local parent = self:GetParent()
    parent.Item.Tooltip.HoverBackground:Hide()
    SettingsTooltip:Hide();
end

function SettingsCheckBoxMixinDF:SetValue(value)
    self:SetChecked(value)
    if value then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
    end
end

--- Slider
SettingsSliderMixinDF = CreateFromMixins(CallbackRegistryMixin);
SettingsSliderMixinDF:GenerateCallbackEvents({"OnValueChanged", "OnInteractStart", "OnInteractEnd"});

local sliderFormat = {}
-- sliderFormat[2] = CreateMinimalSliderFormatter()
sliderFormat[2] = function(value)
    if math.floor(value) == value then
        return value
    else
        return string.format('%.2f', value)
    end
end

-- DevTools_Dump(sliderFormat[2])

function SettingsSliderMixinDF:OnLoad()
    CallbackRegistryMixin.OnLoad(self);

    -- self:Init(setting:GetValue(), options.minValue, options.maxValue, options.steps, options.formatters);   
    local options = Settings.CreateSliderOptions(0, 100, 1);
    self:Init(41, options.minValue, options.maxValue, options.steps, sliderFormat)

    self:SetEnabled_(true)

    self.Back:SetScript('OnClick', GenerateClosure(self.OnStepperClicked, self, false))
    self.Forward:SetScript('OnClick', GenerateClosure(self.OnStepperClicked, self, true))

    self.Slider:HookScript('OnEnter', function()
        self:OnEnter()
    end)
    self.Slider:HookScript('OnLeave', function()
        self:OnLeave()
    end)
end

function SettingsSliderMixinDF:OnEnter()
    local parent = self:GetParent()

    parent.Item.Tooltip.HoverBackground:Show()

    SettingsTooltip:SetOwner(self, 'ANCHOR_RIGHT', 0, 0);
    parent.Item.Checkbox.tooltipFunc()
    SettingsTooltip:Show()
end

function SettingsSliderMixinDF:OnLeave()
    local parent = self:GetParent()
    parent.Item.Tooltip.HoverBackground:Hide()
    SettingsTooltip:Hide();
end

local elementSize = {header = 45, range = 26, execute = 26, description = 26, toggle = 26}

--- Settingslist
SettingsListMixinDF = {}

function SettingsListMixinDF:OnLoad()
    print('SettingsListMixinDF', 'OnLoad')
    self.DataProvider = CreateDataProvider()

    local verticalPad = 10;
    local padLeft, padRight = 25, 0;
    local spacing = 9;

    self.ScrollView = CreateScrollBoxListLinearView(verticalPad, verticalPad, padLeft, padRight, spacing);
    self.ScrollView:SetDataProvider(self.DataProvider)

    local function ExtentCalculator(dataIndex, elementData)
        return elementSize[elementData.args.type] or 1
    end
    self.ScrollView:SetElementExtentCalculator(ExtentCalculator)

    self.ScrollView:SetElementInitializer("ScrollableListItemTemplateDF", function(frame, elementData)
        -- This is called each time the scrollview acquires a frame this
        -- should generally call a method on the acquired frame and update
        -- its visual state accordingly.

        frame:Init(elementData)
    end)

    -- The below call is required to hook everything up automatically.

    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView)

    local scrollBoxAnchors = {
        CreateAnchor("TOPLEFT", self.Header, "BOTTOMLEFT", -15, -2), CreateAnchor("BOTTOMRIGHT", -20, -2)
    };
    ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, scrollBoxAnchors, scrollBoxAnchors);

    -- ScrollUtil.AddResizableChildrenBehavior(self.ScrollBox);
end

function SettingsListMixinDF:AppendListItem() -- this creates the line items 
    local color = CreateColor(fastrandom(), fastrandom(), fastrandom())
    local text = string.format("Time: %.5f", GetTime())

    local elementData = -- Used by the list to display each list row text and color as they're scrolled
    {color = color, text = text, viewH = 21}

    self.DataProvider:Insert(elementData)
    self.ScrollBox:ScrollToEnd(ScrollBoxConstants.NoScrollInterpolation)
end

function SettingsListMixinDF:SetRandomProvider()
    -- self.DataProvider = CreateDataProvider()
    -- self.ScrollView:SetDataProvider(self.DataProvider)
    self.DataProvider:Flush()

    local rnd = fastrandom(0, 42)
    print('random', i)

    for i = 1, rnd do
        print('rnd', i)
        self:AppendListItem()
    end

end

function SettingsListMixinDF:Display(data)
    -- self.DataProvider:Flush()
    self.DataProvider = CreateDataProvider()
    self.ScrollView:SetDataProvider(self.DataProvider)

    if not data then
        print('SettingsListMixinDF:Display', 'no data')
        return
    end

    self.Header.Title:SetText(data.name)

    -- https://stackoverflow.com/a/15706820
    function spairs(t, order)
        -- collect the keys
        local keys = {}
        for k in pairs(t) do keys[#keys + 1] = k end

        -- if order function given, sort by it by passing the table and keys a, b,
        -- otherwise just sort the keys 
        if order then
            table.sort(keys, function(a, b)
                return order(t, a, b)
            end)
        else
            table.sort(keys)
        end

        -- return the iterator function
        local i = 0
        return function()
            i = i + 1
            if keys[i] then return keys[i], t[keys[i]] end
        end
    end

    for k, v in spairs(data.options.args, function(t, a, b)
        return t[b].order > t[a].order
    end) do
        local elementData = {key = k, args = v, viewH = 45}
        self.DataProvider:Insert(elementData)
        -- print(k, v.order)
    end
end

function SettingsListMixinDF:RemoveListItem()
    local lastIndex = self.DataProvider:GetSize()
    self.DataProvider:RemoveIndex(lastIndex)
end

