ScrollableListItemMixinDF = {}

function ScrollableListItemMixinDF:Init(elementData)
    -- self.Background:SetColorTexture(elementData.color:GetRGBA())
    -- self.Text:SetText(elementData.text)

    local key = elementData.key
    local data = elementData.args
    local get = elementData.get
    local set = elementData.set
    local list = elementData.settingsList
    list:UnregisterCallback('OnDefaults', self)
    list:UnregisterCallback('OnRefresh', self)

    -- print('init', key, data)
    self:Reset()

    if data.new then
        self.Item.NewFeature:Show()
    elseif data.blizzard then
        self.Item.Blizzard:Show()
    end

    if elementData.small then self:SetSmall(true) end
    -- if data.editmode then self:SetSmall(true) end

    if data.type == 'header' then
        self:SetHeader(data.name)
    elseif data.type == 'range' then
        self:SetText(data.name)
        self:SetTooltip(data.name, data.desc)
        self:SetSlider(get({key}), data.min, data.max, data.bigStep)
        -- self.Item.Slider.lastValue = get({key})
        self.Item.Slider:RegisterCallback('OnValueChanged', function(self, ...)
            local newValue = ...
            set({key}, newValue)
            self.Item.Slider.RightText:Hide();
            self.Item.Slider.Editbox:SetText(self.Item.Slider.RightText:GetText())
        end, self)
        list:RegisterCallback('OnDefaults', function(self, ...)
            self:SetSlider(get({key}), data.min, data.max, data.bigStep)
        end, self)
        list:RegisterCallback('OnRefresh', function(self, ...)
            self:SetSlider(get({key}), data.min, data.max, data.bigStep)
        end, self)
    elseif data.type == 'execute' then
        self:SetText(data.name)
        self:SetTooltip(data.name, data.desc)

        self.Item.Button:Show()
        self.Item.Button.Button:SetText(data.btnName)
        self.Item.Button:RegisterCallback('OnClick', function(self, ...)
            data.func()
        end)
    elseif data.type == 'description' then
        self:SetText(data.name)
        self:SetTooltip(data.name, data.desc)

    elseif data.type == 'toggle' then
        self:SetText(data.name)
        self:SetTooltip(data.name, data.desc)
        self:SetCheckbox(get({key}))
        self.Item.Tooltip:SetScript('OnMouseDown', function()
            self.Item.Checkbox:SetValue(not self.Item.Checkbox:GetChecked())
            self.Item.Checkbox:TriggerEvent(SettingsCheckBoxMixinDF.Event.OnValueChanged,
                                            self.Item.Checkbox:GetChecked())
        end)
        self.Item.Checkbox:RegisterCallback('OnValueChanged', function(self, ...)
            set({key}, self.Item.Checkbox:GetChecked())
        end, self)
        list:RegisterCallback('OnDefaults', function(self, ...)
            self.Item.Checkbox:SetValue(get({key}))
        end, self)
        list:RegisterCallback('OnRefresh', function(self, ...)
            self.Item.Checkbox:SetValue(get({key}))
        end, self)
    elseif data.type == 'select' then
        -- print('select')
        self:SetText(data.name)
        self:SetTooltip(data.name, data.desc)
        if data.valuesFunction then
            local funcValues = data.valuesFunction()
            self:SetDropdown(funcValues)
        else
            self:SetDropdown(data.values)
        end
        -- self.Item.Dropdown:SetDropdownSelection('TOP')
        self.Item.Dropdown:SetDropdownSelection(get({key}))
        self.Item.Dropdown:RegisterCallback('OnValueChanged', function(self, ...)
            -- print('OnValueChanged', key, ...)
            local newValue = ...
            set({key}, newValue)
        end)
        list:RegisterCallback('OnDefaults', function(self, ...)
            -- print('OnDefaults')
            self.Item.Dropdown:SetDropdownSelection(get({key}))
        end, self)
        list:RegisterCallback('OnRefresh', function(self, ...)
            -- print('OnDefaults')
            if data.valuesFunction then
                local funcValues = data.valuesFunction()
                self:SetDropdown(funcValues)
            end
            self.Item.Dropdown:SetDropdownSelection(get({key}))
        end, self)
    elseif data.type == 'divider' then
        self.Divider:Show()
    end
end

function ScrollableListItemMixinDF:Reset()
    self.Header:Hide()
    self.Divider:Hide()

    self.Item.Tooltip:SetScript('OnMouseDown', nil)

    -- self.Item:ClearAllPoints()
    self.Item.Text:SetPoint("LEFT", 37, 0);
    self.Item.Text:SetPoint("RIGHT", self:GetParent(), "CENTER", -85, 0);
    self.Item:Hide()

    self.Item.Button:SetParent(self)
    self.Item.Button.Button:SetPoint("LEFT", self, "CENTER", -40, 0)
    self.Item.Button.Button:SetWidth(200)
    self.Item.Button:Hide()
    self.Item.Button:UnregisterCallback('OnClick', self)

    self.Item.Checkbox:SetParent(self)
    self.Item.Checkbox:SetPoint("LEFT", self, "CENTER", -80, 0)
    self.Item.Checkbox:Hide()
    self.Item.Checkbox:UnregisterCallback('OnValueChanged', self)

    self.Item.Slider:SetParent(self)
    self.Item.Slider:SetWidth(250)
    self.Item.Slider:SetPoint("LEFT", self, "CENTER", -80, 3)
    self.Item.Slider:Hide()
    self.Item.Slider:UnregisterCallback('OnValueChanged', self)
    -- self.Item.Slider.Editbox:SetJustifyH('CENTER')
    self.Item.Slider.Editbox:SetWidth(60)
    self.Item.Slider.Editbox:SetPoint('LEFT', self.Item.Slider.RightText, 'LEFT', 0, 0)

    self.Item.Dropdown:SetParent(self)
    self.Item.Dropdown:SetPoint("LEFT", self, "CENTER", -40, 3)
    self.Item.Dropdown:Hide()
    self.Item.Dropdown:UnregisterCallback('OnValueChanged', self)

    self.Item.NewFeature:Hide()
    self.Item.NewFeature:SetPoint('RIGHT', self.Item.Text, 'LEFT', -37, 3)

    self.Item.Blizzard:Hide()
    self.Item.Blizzard:SetPoint('RIGHT', self.Item.Text, 'LEFT', -37, 3)
end

function ScrollableListItemMixinDF:SetSmall(small)
    self.Item.Text:SetPoint("LEFT", 10, 0); -- 37
    self.Item.Text:SetPoint("RIGHT", self:GetParent(), "CENTER", -65, 0); -- 85,0
    -- self.Item:Hide()

    self.Item.Button.Button:SetPoint("LEFT", self, "CENTER", -45 - 34, 0) -- -40
    self.Item.Button.Button:SetWidth(220 + 34) -- 200
    -- self.Item.Button:Hide()

    self.Item.Checkbox:SetPoint("LEFT", self, "CENTER", -60, 0) -- 80,0

    self.Item.Slider:SetWidth(228) -- 250
    -- self.Item.Slider.Editbox:SetJustifyH('LEFT')
    self.Item.Slider.Editbox:SetWidth(48) -- 60
    self.Item.Slider.Editbox:SetPoint('LEFT', self.Item.Slider.RightText, 'LEFT', -5, 0)

    self.Item.Dropdown.Button:SetWidth(204) -- 250
    self.Item.Dropdown:SetPoint("LEFT", self, "CENTER", -64, 3) -- -40

    -- <Size x="250" y="38" />

    self.Item.NewFeature:SetPoint('RIGHT', self.Item.Text, 'LEFT', -20, 3) -- -37,3
    self.Item.Blizzard:SetPoint('RIGHT', self.Item.Text, 'LEFT', -20, 3) -- -37,3
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
    self.Item.Checkbox:SetValue(checked, true)
    self.Item.Checkbox:Show()
end

function ScrollableListItemMixinDF:SetSlider(value, minValue, maxValue, step)
    self.Item.Slider:Show()
    local options = Settings.CreateSliderOptions(0, 500, 1);
    self.Item.Slider.Slider:SetMinMaxValues(minValue, maxValue)
    self.Item.Slider.Slider:SetValueStep(step)
    self.Item.Slider.Slider:SetValue(value)

    self.Item.Slider.RightText:Hide();
    self.Item.Slider.Editbox:SetText(self.Item.Slider.RightText:GetText())
end

function ScrollableListItemMixinDF:SetDropdown(options)
    self.Item.Dropdown:Show()
    self.Item.Dropdown:SetDropdownSelectionOptions(options)
end

--- Button
SettingsButtonControlMixinDF = CreateFromMixins(CallbackRegistryMixin);
SettingsButtonControlMixinDF:GenerateCallbackEvents({"OnClick"});

function SettingsButtonControlMixinDF:OnLoad()
    CallbackRegistryMixin.OnLoad(self);

    self.Button:SetScript("OnClick", function(button, buttonName)
        self:TriggerEvent(SettingsButtonControlMixinDF.Event.OnClick, true)
    end)
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

function SettingsCheckBoxMixinDF:SetValue(value, muted)
    self:SetChecked(value)
    if muted then return end
    if value then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
    end
end

--- Slider
SettingsSliderMixinDF = CreateFromMixins(CallbackRegistryMixin);
SettingsSliderMixinDF:GenerateCallbackEvents({
    "OnValueChanged", "OnValueChangedFilter", "OnInteractStart", "OnInteractEnd"
});

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

    if self.SetEnabled_ then
        self:SetEnabled_(true)
    else
        self:SetEnabled(true)
    end

    self.Back:SetScript('OnClick', GenerateClosure(self.OnStepperClicked, self, false))
    self.Forward:SetScript('OnClick', GenerateClosure(self.OnStepperClicked, self, true))

    self.Slider:HookScript('OnEnter', function()
        self:OnEnter()
    end)
    self.Slider:HookScript('OnLeave', function()
        self:OnLeave()
    end)

    local editbox = CreateFrame('EditBox', 'EditBox', self, 'SettingsSliderEditboxTemplateDF')
    editbox:SetPoint('LEFT', self.RightText, 'LEFT', 0, 0)
    self.Editbox = editbox

    editbox:SetScript('OnEscapePressed', function()
        editbox:ClearFocus()
    end)

    editbox:SetScript('OnTabPressed', function()
        editbox:ClearFocus()
    end)

    editbox:SetScript('OnEditFocusGained', function()
        editbox:HighlightText()
    end)

    editbox:SetScript('OnEnterPressed', function()
        editbox:ClearFocus()
        local newValue = tonumber(editbox:GetText()) or self.Slider:GetValue();
        self.Slider:SetValue(newValue)
        editbox:SetText(self.RightText:GetText())
        self.RightText:Hide()
    end)

    self.RightText:Hide()
    editbox:SetJustifyH('CENTER')

    -- self:HookScript('SetValue', function(test, value)
    --     print('SetValue', test, value)
    -- end)

    -- editbox:SetScript('OnClick', function()
    --     editbox.Text:HighlightText() -- parameters (start, end) or default all
    --     editbox.Text:SetFocus()
    -- end)

    --[[ self.lastValue = nil

    self:RegisterCallback('OnValueChanged', function(self, ...)
        -- print('valuechangeslider')
        local newValue = ...

        if newValue ~= self.lastValue then
            self.lastValue = newValue
            self:TriggerEvent(SettingsSliderMixinDF.Event.OnValueChangedFilter, newValue);
        else
            -- same -> do nothing
        end
    end, self) ]]
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

--- dropdown button
SelectionPopoutButtonMixinDF = CreateFromMixins(CallbackRegistryMixin)
SelectionPopoutButtonMixinDF:GenerateCallbackEvents({"OnValueChanged"})

function SelectionPopoutButtonMixinDF:OnLoad()
    -- print('SelectionPopoutButtonMixinDF', 'OnLoad')
    CallbackRegistryMixin.OnLoad(self);

    self.parent = self:GetParent();
end

function SelectionPopoutButtonMixinDF:OnHide()
end

function SelectionPopoutButtonMixinDF:OnMouseDown()
    self:TogglePopout()
end

function SelectionPopoutButtonMixinDF:OnMouseWheel()
end

function SelectionPopoutButtonMixinDF:OnEnter()
    if self.parent.OnEnter then self.parent:OnEnter(); end
    if not self.Popout:IsShown() then self.NormalTexture:SetAtlas("charactercreate-customize-dropdownbox-hover"); end
end

function SelectionPopoutButtonMixinDF:OnLeave()
    if self.parent.OnLeave then self.parent:OnLeave(); end
    if not self.Popout:IsShown() then self.NormalTexture:SetAtlas("charactercreate-customize-dropdownbox"); end
end

function SelectionPopoutButtonMixinDF:TogglePopout()
    local showPopup = not self.Popout:IsShown();
    if showPopup then
        self:ShowPopout();
    else
        self:HidePopout();
    end
end

function SelectionPopoutButtonMixinDF:ShowPopout()
    self.Popout:Show();
    self.NormalTexture:SetAtlas("charactercreate-customize-dropdownbox-open");
    self.HighlightTexture:SetAlpha(0.2);
end

function SelectionPopoutButtonMixinDF:HidePopout()
    self.Popout:Hide();

    -- local isMouseOverButton
    -- if GetMouseFocus then
    --     isMouseOverButton = GetMouseFocus() == self;
    -- else
    --     local foci = GetMouseFoci()
    --     isMouseOverButton = foci[1] == self;
    -- end
    -- print('s', self:IsMouseMotionFocus())

    if self:IsMouseMotionFocus() then
        self.NormalTexture:SetAtlas("charactercreate-customize-dropdownbox-hover");
    else
        self.NormalTexture:SetAtlas("charactercreate-customize-dropdownbox");
    end

    self.HighlightTexture:SetAlpha(0);
end

--- dropdown
SettingsDropdownMixinDF = CreateFromMixins(CallbackRegistryMixin)
SettingsDropdownMixinDF:GenerateCallbackEvents({"OnValueChanged"})

function SettingsDropdownMixinDF:OnLoad()
    -- print('SettingsDropdownMixinDF', 'OnLoad')
    CallbackRegistryMixin.OnLoad(self);

    local xOffset = self.incrementOffsetX or 4
    self.IncrementButton:SetPoint("LEFT", self.Button, "RIGHT", xOffset, 0)
    self.IncrementButton:SetScript("OnClick", GenerateClosure(self.OnIncrementClicked, self));

    xOffset = self.decrementOffsetX or -5
    self.DecrementButton:SetPoint("RIGHT", self.Button, "LEFT", xOffset, 0)
    self.DecrementButton:SetScript("OnClick", GenerateClosure(self.OnDecrementClicked, self));

    self.options = {}
    self.selectedIndex = 0

    self.isEnabledDF = true

    self.Button.Popout:UnregisterCallback('OnEntryClicked', self)

    self.Button.Popout:RegisterCallback('OnEntryClicked', function(self, ...)
        local index = ...
        -- print('clicked', index, 'SettingsDropdownMixinDF')
        self:SetSelectedIndex(index)
    end, self)
    self.Button.Popout:SetFrameStrata('FULLSCREEN_DIALOG')

end

function SettingsDropdownMixinDF:OnEnter()
end

function SettingsDropdownMixinDF:OnLeave()
end

function SettingsDropdownMixinDF:IsEnabledDF()
    return self.isEnabledDF
end

function SettingsDropdownMixinDF:SetDropdownSelection(selection)
    self.Button.SelectionDetails.SelectionName:Show()
    local index = self:GetIndex(selection)
    -- print('index', selection, index)
    if index > 0 then
        self.selectedIndex = index
        local option = self.options[index]
        self.Button.SelectionDetails.SelectionName:SetText(option.value)
        self.Button.Popout:UpdateSelected(index)
    else
        self.Button.SelectionDetails.SelectionName:SetText('ERROR')
    end
    self:Update()
end

function SettingsDropdownMixinDF:SetDropdownSelectionOptions(options)
    local newTable = {}

    for k, v in pairs(options) do table.insert(newTable, {key = k, value = v}) end

    self.options = newTable
    -- DevTools_Dump(newTable)
    self.Button.Popout:SetEntrys(newTable)
end

function SettingsDropdownMixinDF:GetIndex(value)
    for k, v in pairs(self.options) do if v.key == value then return k end end
    return 0
end

function SettingsDropdownMixinDF:GetAdjustedIndex(forward, selections)
    if not self.selectedIndex then return nil; end
    local offset = forward and 1 or -1;
    local nextIndex = self.selectedIndex + offset;
    local data = selections[nextIndex];
    while data do
        if data.disabled == nil and not data.isLocked then
            return nextIndex;
        else
            nextIndex = nextIndex + offset;
            data = selections[nextIndex];
        end
    end

    return nil;
end

function SettingsDropdownMixinDF:OnIncrementClicked(button, buttonName, down)
    self:Increment();
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
end

function SettingsDropdownMixinDF:Increment()
    local forward = true;
    local index = self:GetAdjustedIndex(forward, self.options);
    self:SetSelectedIndex(index);
end

function SettingsDropdownMixinDF:OnDecrementClicked(button, buttonName, down)
    self:Decrement();
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
end

function SettingsDropdownMixinDF:Decrement()
    local forward = false;
    local index = self:GetAdjustedIndex(forward, self.options);
    self:SetSelectedIndex(index);
end

function SettingsDropdownMixinDF:SetSelectedIndex(newIndex)
    local oldIndex = self.selectedIndex;
    local isNewIndex = newIndex and newIndex ~= oldIndex;
    if isNewIndex then
        self.selectedIndex = newIndex;
        self:Update();
        -- print('setindex', oldIndex, newIndex)

        local option = self.options[newIndex]
        self.Button.SelectionDetails.SelectionName:SetText(option.value)
        self.Button.Popout:UpdateSelected(newIndex)

        self:TriggerEvent(SettingsDropdownMixinDF.Event.OnValueChanged, self.options[newIndex].key);
    end
end

function SettingsDropdownMixinDF:Update()
    -- print('Update!')
    self:UpdateButtons()
    self:UpdatePopout()
end

function SettingsDropdownMixinDF:UpdateButtons()
    local enabled = self:IsEnabledDF()
    if enabled then
        local incr = self.selectedIndex == #self.options
        self.IncrementButton:SetEnabled(not incr)

        local decr = self.selectedIndex == 1
        self.DecrementButton:SetEnabled(not decr)
        -- print(incr, decr)
    else
        self.IncrementButton:SetEnabled(false)
        self.DecrementButton:SetEnabled(false)
    end
    -- print('UpdateButtons')
end

function SettingsDropdownMixinDF:UpdatePopout()
    -- print('UpdatePopout!')
end

----- popup

SelectionPopoutMixinDF = CreateFromMixins(CallbackRegistryMixin);
SelectionPopoutMixinDF:GenerateCallbackEvents({"OnEntryClicked"});

function SelectionPopoutMixinDF:OnLoad()
    -- print('SelectionPopoutMixinDF:OnLoad()')
    CallbackRegistryMixin.OnLoad(self);

    self.MAX_POOL = 16
    self.entryPool = {}
    self.data = {}

    self:CreateEntrys(self.MAX_POOL)
    self:SetHeightForN(self.MAX_POOL)
end

function SelectionPopoutMixinDF:OnShow()
end

function SelectionPopoutMixinDF:OnHide()
end

function SelectionPopoutMixinDF:OnEntryClicked(index)
    self:TriggerEvent(SettingsSelectionPopoutEntryMixinDF.Event.OnEntryClicked, index)
    self:Hide()
end

function SelectionPopoutMixinDF:CreateEntrys(MAX_POOL)
    local last = nil
    local heightPadding = 12
    for i = 1, MAX_POOL do
        local tmp = CreateFrame('Button', nil, self, 'SettingsSelectionPopoutEntryTemplateDF')
        table.insert(self.entryPool, tmp)

        tmp.index = i
        tmp.SelectionName:SetText('TMP' .. i)

        tmp:RegisterCallback('OnEntryClicked', function(self, ...)
            self:OnEntryClicked(...)
        end, self)

        if last then
            tmp:SetPoint('TOP', last, 'BOTTOM', 0, 0)
        else
            tmp:SetPoint('TOP', self, 'TOP', 0, -heightPadding)
        end
        last = tmp
    end
end

function SelectionPopoutMixinDF:SetHeightForN(n)
    local heightPadding = 12
    local h = 20
    local newHeight = 2 * heightPadding + (n + 1) * h
    -- print('newHeight', newHeight)
    self:SetHeight(newHeight)
end

function SelectionPopoutMixinDF:SetEntrys(data)
    local count = #data
    if count > self.MAX_POOL then
        print('DATA TO BIG')
        return
    end

    self.data = data

    for i = 1, count do
        local tmpSelection = data[i]
        local tmp = self.entryPool[i]
        tmp.SelectionName:SetText(tmpSelection.value)
        tmp.SelectionName.key = tmpSelection.key
        tmp.SelectionName.value = tmpSelection.value
    end

    for i = count + 1, self.MAX_POOL do self.entryPool[i]:Hide() end

    self:SetHeightForN(count)
end

function SelectionPopoutMixinDF:UpdateSelected(index)
    local count = #self.data
    for i = 1, count do
        local tmp = self.entryPool[i]
        if i == index then
            tmp:Update(true)
        else
            tmp:Update(false)
        end
    end
end

--- popup entry

SettingsSelectionPopoutEntryMixinDF = CreateFromMixins(CallbackRegistryMixin)
SettingsSelectionPopoutEntryMixinDF:GenerateCallbackEvents({"OnEntryClicked"})

function SettingsSelectionPopoutEntryMixinDF:OnLoad()
    CallbackRegistryMixin.OnLoad(self);
    self.isSelected = false
    self.index = 0
end

function SettingsSelectionPopoutEntryMixinDF:OnClick()
    self:TriggerEvent(SettingsSelectionPopoutEntryMixinDF.Event.OnEntryClicked, self.index)
    -- print('clicked', self.index)
end

function SettingsSelectionPopoutEntryMixinDF:OnEnter()
    self.HighlightBGTex:SetAlpha(0.15);

    if not self.isSelected then self.SelectionName:SetTextColor(HIGHLIGHT_FONT_COLOR:GetRGB()); end
end

function SettingsSelectionPopoutEntryMixinDF:OnLeave()
    self.HighlightBGTex:SetAlpha(0);

    if not self.isSelected then
        --[[ local fontColor = nil;
		if self.selectionData.disabled == nil then
			fontColor = VERY_LIGHT_GRAY_COLOR;
		else
			fontColor = DISABLED_FONT_COLOR;
		end ]]

        local fontColor = VERY_LIGHT_GRAY_COLOR
        self.SelectionName:SetTextColor(fontColor:GetRGB())
    end
end

function SettingsSelectionPopoutEntryMixinDF:Update(selected)
    self.isSelected = selected
    local fontColor = nil;
    if selected then
        fontColor = NORMAL_FONT_COLOR;
    else
        fontColor = VERY_LIGHT_GRAY_COLOR;
    end
    self.SelectionName:SetTextColor(fontColor:GetRGB());

    local maxNameWidth = 200;
    if self.SelectionName:GetWidth() > maxNameWidth then self.SelectionName:SetWidth(maxNameWidth); end
end

------------------------------------

local elementSize = {header = 45, range = 26, execute = 26, description = 26, toggle = 26, select = 26, divider = 16}

--- Settingslist
SettingsListMixinDF = CreateFromMixins(CallbackRegistryMixin);
SettingsListMixinDF:GenerateCallbackEvents({"OnDefaults", "OnRefresh"});

function SettingsListMixinDF:OnLoad()
    CallbackRegistryMixin.OnLoad(self);

    -- print('SettingsListMixinDF', 'OnLoad')
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

function SettingsListMixinDF:CallRefresh()
    self:TriggerEvent(SettingsListMixinDF.Event.OnRefresh, true)
end

function SettingsListMixinDF:Display(data, small)
    -- self.DataProvider:Flush()
    self.DataProvider = CreateDataProvider()
    self.ScrollView:SetDataProvider(self.DataProvider)

    self.Header.DefaultsButton:Hide()

    if not data then
        print('SettingsListMixinDF:Display', 'no data')
        return
    end

    self.Header.Title:SetText(data.name)

    if data.default then
        self.Header.DefaultsButton:Show()
        self.Header.DefaultsButton:SetText('Defaults')

        self.Header.DefaultsButton:SetScript('OnClick', function()
            data.default()
            self:TriggerEvent('OnDefaults', 'set Defaults')
        end)
    end

    -- self.Header.DefaultsButton:Show()
    -- self.Header.DefaultsButton:SetText('TEST')

    -- https://stackoverflow.com/a/15706820
    local function sortedPairs(t, order)
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

    for k, v in sortedPairs(data.options.args, function(t, a, b)
        return t[b].order > t[a].order
    end) do
        local elementData
        if data.sub then
            local subGet = function(info)
                -- print('subGet', info[1])
                local newInfo = {}
                newInfo[1] = data.sub
                newInfo[2] = info[1]
                return data.options.get(newInfo)
            end
            local subSet = function(info, value)
                local newInfo = {}
                newInfo[1] = data.sub
                newInfo[2] = info[1]
                return data.options.set(newInfo, value)
            end
            elementData = {key = k, args = v, get = subGet, set = subSet, settingsList = self, small = small}
        else
            elementData = {
                key = k,
                args = v,
                get = data.options.get,
                set = data.options.set,
                settingsList = self,
                small = small
            }
        end

        if v.name ~= '' and v.name ~= 'Enable' then self.DataProvider:Insert(elementData) end
        -- print(k, v.order)
    end
end

function SettingsListMixinDF:RemoveListItem()
    local lastIndex = self.DataProvider:GetSize()
    self.DataProvider:RemoveIndex(lastIndex)
end

--------

DragonflightUINewFeatureLabelMixin = {};

function DragonflightUINewFeatureLabelMixin:OnLoad()
    self.BGLabel:SetText(self.label);
    self.Label:SetText(self.label);
    self.Label:SetJustifyH(self.justifyH);
    self.BGLabel:SetJustifyH(self.justifyH);
end

function DragonflightUINewFeatureLabelMixin:ClearAlert()
    -- derive
    self:SetShown(false);
end

function DragonflightUINewFeatureLabelMixin:OnShow()
    if self.animateGlow then self.Fade:Play(); end
end

function DragonflightUINewFeatureLabelMixin:OnHide()
    if self.animateGlow then self.Fade:Stop(); end
end

--------

-- orig: SettingsSelectionPopoutDetailsMixin  removed on SoD PTR  @TODO
SettingsSelectionPopoutDetailsMixinDF = {}

--[[ function SettingsSelectionPopoutDetailsMixin:GetTooltipText()
    if self.SelectionName:IsShown() and self.SelectionName:IsTruncated() then return self.label; end

    return nil;
end

function SettingsSelectionPopoutDetailsMixin:AdjustWidth(multipleColumns, defaultWidth)
    if multipleColumns then
        self:SetWidth(Round(defaultWidth / 2));
    else
        local nameWidth = self.SelectionName:GetUnboundedStringWidth() + self.selectionNamePadding;
        self:SetWidth(Round(math.max(nameWidth, defaultWidth)));
        self.SelectionName:SetWidth(nameWidth);
    end
end

function SettingsSelectionPopoutDetailsMixin:SetupDetails(selectionData, index, isSelected, hasAFailedReq,
                                                          hasALockedChoice)
    self.label = selectionData.label;

    self.SelectionName:Show();
    self.SelectionName:SetText(selectionData.label);

    if isSelected ~= nil then
        local fontColor = nil;
        if isSelected then
            fontColor = NORMAL_FONT_COLOR;
        elseif selectionData.disabled then
            fontColor = DISABLED_FONT_COLOR;
        else
            fontColor = VERY_LIGHT_GRAY_COLOR;
        end
        self.SelectionName:SetTextColor(fontColor:GetRGB());
    end

    local maxNameWidth = 200;
    if self.SelectionName:GetWidth() > maxNameWidth then self.SelectionName:SetWidth(maxNameWidth); end
end

function SettingsSelectionPopoutDetailsMixin:SetupCustomDetails()
    self.label = CUSTOM;

    self.SelectionName:Show();
    self.SelectionName:SetText(self.label);
    self.SelectionName:SetTextColor(VERY_LIGHT_GRAY_COLOR:GetRGB());

    local maxNameWidth = 200;
    if self.SelectionName:GetWidth() > maxNameWidth then self.SelectionName:SetWidth(maxNameWidth); end
end ]]
