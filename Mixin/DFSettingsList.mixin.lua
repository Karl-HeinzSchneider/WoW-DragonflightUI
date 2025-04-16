local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local CreateColor = DFCreateColor;

DFSettingsListMixin = CreateFromMixins(CallbackRegistryMixin);
DFSettingsListMixin:GenerateCallbackEvents({"OnDefaults", "OnRefresh"});

DFSettingsListMixin.ElementSize = {
    header = 45,
    range = 26,
    execute = 26,
    editbox = 26,
    description = 26,
    toggle = 26,
    select = 26,
    color = 26,
    divider = 16 + 10
}

DFSettingsListMixin.OrderSortComparator = function(a, b)
    return b.data.order > a.data.order
end

DFSettingsListMixin.AlphaSortComparator = function(a, b)
    return b.data.name > a.data.name
end

function DFSettingsListMixin:OnLoad()
    CallbackRegistryMixin.OnLoad(self);
    -- print('DFSettingsListMixin', 'OnLoad')

    -- TODO
    SettingsTooltip:SetScale(UIParent:GetEffectiveScale())

    local parent = self:GetParent()
    self:SetPoint('TOPLEFT', parent, 'TOPLEFT', 0, 0);
    self:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', 0, 0);
    self:Show()

    self.DataProvider = CreateTreeDataProvider();
    self.sortComparator = DFSettingsListMixin.OrderSortComparator
    local affectChildren = true;
    local skipSort = true;
    self.DataProvider:SetSortComparator(self.sortComparator, affectChildren, skipSort)

    local indent = 0;
    local verticalPad = 10;
    local padLeft, padRight = 25, 0;
    local spacing = 9;

    self.ScrollView = CreateScrollBoxListTreeListView(indent, verticalPad, verticalPad, padLeft, padRight, spacing);

    self.ScrollView:SetElementFactory(function(factory, node)
        -- DevTools_Dump(node)
        local elementData = node:GetData();
        local elementType = elementData.args.type;

        local function Initializer(button, n)
            self:UnregisterCallback('OnDefaults', button);
            self:UnregisterCallback('OnRefresh', button);

            self:RegisterCallback('OnDefaults', function(btn, message)
                --
                -- print(btn, message)
                button:Init(n);
            end, button)
            self:RegisterCallback('OnRefresh', function(btn, message)
                --
                -- print(btn, message)
                button:Init(n);
            end, button)

            button:Init(n);

            if elementType == 'header' then
                button.Tooltip:SetScript("OnMouseDown", function(_, _)
                    node:ToggleCollapsed();
                    button:SetCollapseState(node:IsCollapsed());
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
                end);
            end
        end

        if elementType == 'header' then
            factory("DFSettingsListHeader", Initializer);
        elseif elementType == 'divider' then
            factory("DFSettingsListDivider", Initializer);
        elseif elementType == 'toggle' then
            factory("DFSettingsListCheckboxContainer", Initializer);
        elseif elementType == 'range' then
            factory("DFSettingsListSliderContainer", Initializer);
        elseif elementType == 'execute' then
            factory("DFSettingsListButton", Initializer);
        elseif elementType == 'select' then
            if DF.Wrath and not DF.Cata then
                factory("DFSettingsListDropdownContainer_Compat", Initializer);
            else
                factory("DFSettingsListDropdownContainer", Initializer);
            end
        elseif elementType == 'editbox' then
            factory("DFSettingsListEditbox", Initializer);
        elseif elementType == 'color' then
            factory("DFSettingsListColorPicker", Initializer);
        else
            print('~no factory: ', elementType, ' ~')
            factory("Frame");
        end
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

function DFSettingsListMixin:FlushDisplay()
    self.DataProvider = CreateTreeDataProvider();
    self.ScrollView:SetDataProvider(self.DataProvider)
end

function DFSettingsListMixin:CallRefresh()
    -- print('refresh!');
    -- self:Display(self.Args_Data, self.Args_Data);
    self:TriggerEvent(DFSettingsListMixin.Event.OnRefresh, true)
end

function DFSettingsListMixin:Display(data, small)
    -- self.DataProvider:Flush()
    -- self.DataProvider = CreateTreeDataProvider()
    -- self.ScrollView:SetDataProvider(self.DataProvider)

    self.Args_Data = data;
    self.Args_Small = small;

    self.DataProvider = CreateTreeDataProvider();
    local affectChildren = true;
    local skipSort = true;

    if data.sortComparator then
        self.DataProvider:SetSortComparator(data.sortComparator, false, false)
    else
        self.DataProvider:SetSortComparator(DFSettingsListMixin.OrderSortComparator, false, false)
    end

    if not data then
        print('DFSettingsListMixin:Display', 'no data')
        return
    end

    -- DevTools_Dump(data.name)

    self.Header.Title:SetText(data.name)

    if data.default then
        self.Header.DefaultsButton:Show()
        self.Header.DefaultsButton:SetText('Defaults')

        self.Header.DefaultsButton:SetScript('OnClick', function()
            data.default()
            self:TriggerEvent('OnDefaults', 'set Defaults')
        end)
    else
        self.Header.DefaultsButton:Hide()
        self.Header.DefaultsButton:SetText('')
        self.Header.DefaultsButton:SetScript('OnClick', function()
        end)
    end

    local getFunc;
    local setFunc;

    local sub = data.sub;

    if sub then
        getFunc = function(info)
            -- print('subGet', info[1])
            local newInfo = {}
            newInfo[1] = sub
            newInfo[2] = info[1]
            return data.options.get(newInfo)
        end
        setFunc = function(info, value)
            local newInfo = {}
            newInfo[1] = sub
            newInfo[2] = info[1]
            return data.options.set(newInfo, value)
        end
    else
        getFunc = data.options.get;
        setFunc = data.options.set;
    end

    -- first pass ~> categorys
    for k, v in pairs(data.options.args) do
        --

        if v.type == 'header' then
            -- print('header', k)
            local elementData = {key = k, order = (v.order or 9999), name = (v.name or ''), args = v, small = small}
            local node = self.DataProvider:Insert(elementData);

            -- local affectChildren = true;
            -- local skipSort = false;
            if v.sortComparator then
                node:SetSortComparator(v.sortComparator, true, false)
            else
                node:SetSortComparator(DFSettingsListMixin.OrderSortComparator, true, false)
            end
            -- node:SetSortComparator(self.sortComparator, true, false)
        end
    end

    -- second pass ~> elements
    for k, v in pairs(data.options.args) do
        --

        if v.type == 'header' then
            -- already done
        else
            local elementData = {
                key = k,
                order = (v.order or 9999),
                name = (v.name or ''),
                args = v,
                get = getFunc,
                set = setFunc,
                small = small
            }
            local group = v.group or '*NOGROUP*'

            if group == '*NOGROUP*' then
                -- just append  @TODO
                -- print('~~ NOGROUP', k)
                self.DataProvider:Insert(elementData);
            else

                self.DataProvider:InsertInParentByPredicate(elementData, function(node)
                    local nodeData = node:GetData()
                    return nodeData.key == group;
                end)

                -- local oldNode = self.DataProvider:FindElementDataByPredicate(function(node)
                --     local nodeData = node:GetData();
                --     return nodeData.key == group;
                -- end, false)

                -- elementData.args.desc = 'order:' .. elementData.order .. ', group: ' .. group

                -- if oldNode then
                --     print('~~ oldNode', k)
                --     oldNode:Insert(elementData)
                --     oldNode:Sort()
                -- else
                --     -- @TODO but shouldnt happen
                --     print('else?!?!!?')
                -- end
            end
        end

    end

    self.ScrollView:SetDataProvider(self.DataProvider)
end

-- Base
DFSettingsListElementBaseMixin = CreateFromMixins(CallbackRegistryMixin);
DFSettingsListElementBaseMixin:GenerateCallbackEvents({"OnValueChanged", "OnClick"});

function DFSettingsListElementBaseMixin:OnLoad()
    -- print('DFSettingsListElementBaseMixin:OnLoad()')
    CallbackRegistryMixin.OnLoad(self);

    self.Text:SetText('');
    self:SetBaseSmall(false);

    if self.Init then
        hooksecurefunc(self, 'Init', function()
            --
            -- print('init')
            if not self.ElementData then return; end
            self.NewFeature:SetShown(self.ElementData.args.new)
            self.Blizzard:SetShown(self.ElementData.args.blizzard)
        end)
    end
end

function DFSettingsListElementBaseMixin:SetBaseSmall(small)
    if small then
        self.Text:ClearAllPoints()
        self.Text:SetPoint('LEFT', 10, 0)
        self.Text:SetWidth(130);
        self.Tooltip:SetPoint('BOTTOMRIGHT', self, 'BOTTOMLEFT', 150, 0)
        self.NewFeature:SetPoint('RIGHT', self.Text, 'LEFT', -20, 3)
        self.Blizzard:SetPoint('RIGHT', self.Text, 'LEFT', -20, 3)
    else
        self.Text:ClearAllPoints()
        self.Text:SetPoint('LEFT', 37, 0)
        self.Text:SetWidth(180);
        self.Tooltip:SetPoint('BOTTOMRIGHT', self, 'BOTTOMLEFT', 226, 0)
        self.NewFeature:SetPoint('RIGHT', self.Text, 'LEFT', -37, 3)
        self.Blizzard:SetPoint('RIGHT', self.Text, 'LEFT', -37, 3)
    end
end

function DFSettingsListElementBaseMixin:SetTooltip(name, desc)
    local tooltipFunc = GenerateClosure(Settings.InitTooltip, name, desc or '');
    self.Tooltip:SetTooltipFunc(tooltipFunc);
    self.TooltipFunc = tooltipFunc;
end

-- Header
DFSettingsListHeaderMixin = {}

function DFSettingsListHeaderMixin:Init(node)
    -- print('DFSettingsListHeaderMixin:OnLoad()')

    local elementData = node:GetData();
    self.Title:SetText(elementData.args.name)

    if elementData.args.isExpanded then
        node:SetCollapsed(false, true, false)
    else
        node:SetCollapsed(true, true, false)
    end

    self:SetCollapseState(node:IsCollapsed());

    self.Tooltip:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0)
end

function DFSettingsListHeaderMixin:SetCollapseState(collapsed)
    if collapsed then
        self.CollapseIcon:SetTexCoord(0.302246, 0.312988, 0.0537109, 0.0693359)
        self.CollapseIconAlphaAdd:SetTexCoord(0.302246, 0.312988, 0.0537109, 0.0693359)
    else
        self.CollapseIcon:SetTexCoord(0.270508, 0.28125, 0.0537109, 0.0693359)
        self.CollapseIconAlphaAdd:SetTexCoord(0.270508, 0.28125, 0.0537109, 0.0693359)
    end
end

-- Divider
DFSettingsListDividerMixin = {}

function DFSettingsListDividerMixin:Init(node)
    -- print('DFSettingsListDividerMixin:OnLoad()')
end

-- CheckboxContainer
DFSettingsListCheckboxContainerMixin = {}

function DFSettingsListCheckboxContainerMixin:Init(node)
    -- print('DFSettingsListCheckboxContainerMixin:OnLoad()')
    local elementData = node:GetData();
    self.ElementData = elementData;
    local args = elementData.args;

    self.Text:SetText(args.name);
    self.Text:Show();

    self:SetTooltip(args.name, args.desc);

    self:SetBaseSmall(elementData.small);

    -- self.checkbox:UnregisterCallback('OnValueChanged', self);
    self.Checkbox:UnregisterCallback('OnValueChanged', self)
    self.Checkbox:SetValue(elementData.get({elementData.key}), true);
    self.Checkbox:RegisterCallback('OnValueChanged', function(cb, checked)
        -- print('OnValueChanged', checked) 
        elementData.set({elementData.key}, checked)
    end, self)

    self.Tooltip:SetScript('OnMouseDown', function()
        self.Checkbox:SetValue(not self.Checkbox:GetChecked())
        self.Checkbox:TriggerEvent(DFSettingsListCheckboxMixin.Event.OnValueChanged, self.Checkbox:GetChecked())
    end)

    self.Tooltip:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0)
    self.Tooltip:HookScript('OnEnter', function()
        SettingsTooltip:SetOwner(self.Checkbox, 'ANCHOR_RIGHT', 0, 0);
        self.TooltipFunc()
        SettingsTooltip:Show();
    end)
end

-- Checkbox
DFSettingsListCheckboxMixin = CreateFromMixins(CallbackRegistryMixin);
DFSettingsListCheckboxMixin:GenerateCallbackEvents({"OnValueChanged"});

function DFSettingsListCheckboxMixin:OnLoad()
    CallbackRegistryMixin.OnLoad(self);
end

function DFSettingsListCheckboxMixin:OnEnter()
    -- print('DFSettingsListCheckboxMixin:OnEnter()')
    local parent = self:GetParent();

    parent.Tooltip.HoverBackground:Show();
    SettingsTooltip:SetOwner(self, 'ANCHOR_RIGHT', 0, 0);
    parent.TooltipFunc();
    SettingsTooltip:Show();
end

function DFSettingsListCheckboxMixin:OnClick(button, buttonName, down)
    -- print('DFSettingsListCheckboxMixin:OnClick()', button, buttonName, down);
    self:TriggerEvent(DFSettingsListElementBaseMixin.Event.OnValueChanged, self:GetChecked())
end

function DFSettingsListCheckboxMixin:OnLeave()
    -- print('DFSettingsListCheckboxMixin:OnLeave()')
    local parent = self:GetParent()
    parent.Tooltip.HoverBackground:Hide()
    SettingsTooltip:Hide();
end

function DFSettingsListCheckboxMixin:SetValue(value, muted)
    -- print('DFSettingsListCheckboxMixin:SetValue()', value, muted)
    self:SetChecked(value)
    if muted then return end
    if value then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
    end
end

-- SliderContainer
DFSettingsListSliderContainerMixin = {}

function DFSettingsListSliderContainerMixin:Init(node)
    -- print('DFSettingsListCheckboxContainerMixin:OnLoad()')
    local elementData = node:GetData();
    self.ElementData = elementData;
    local args = elementData.args;
    -- print('~~~~~~:OnLoad()', args.name)

    self.Text:SetText(args.name);
    self.Text:Show();

    self:SetTooltip(args.name, args.desc);

    self.Slider:UnregisterCallback('OnValueChanged', self)
    -- print(args.min, args.max, args.bigStep)
    -- get({key}), data.min, data.max, data.bigStep
    self.Slider.Slider:SetMinMaxValues(args.min, args.max)
    self.Slider.Slider:SetValueStep(args.bigStep)
    self.Slider.Slider:SetValue(elementData.get({elementData.key}))
    self.Slider.RightText:Hide()
    self.Editbox:SetText(self.Slider.RightText:GetText())
    self.Editbox:SetFrameLevel(self.Tooltip:GetFrameLevel() + 1)

    self.Slider:RegisterCallback('OnValueChanged', function(self, ...)
        local newValue = ...
        if ... ~= elementData.get({elementData.key}) then elementData.set({elementData.key}, newValue) end
        self.Slider.RightText:Hide();
        self.Editbox:SetText(self.Slider.RightText:GetText())
    end, self)

    self:SetBaseSmall(elementData.small);

    if elementData.small then
        self.Slider:SetWidth(204);
        self.Slider:SetPoint('LEFT', self.Text, 'RIGHT', 8, 3);

        self.Editbox:SetPoint('LEFT', self.Slider.RightText, 'LEFT', -5, 0)
        self.Editbox:SetWidth(40);
    else
        self.Slider:SetWidth(250);
        self.Slider:SetPoint('LEFT', self.Text, 'RIGHT', 8, 3);

        self.Editbox:SetPoint('LEFT', self.Slider.RightText, 'LEFT', 0, 0)
        self.Editbox:SetWidth(60);
    end

    -- editbox
    self.Editbox:SetScript('OnEscapePressed', function()
        self.Editbox:ClearFocus()
    end)

    self.Editbox:SetScript('OnTabPressed', function()
        self.Editbox:ClearFocus()
    end)

    self.Editbox:SetScript('OnEditFocusGained', function()
        self.Editbox:HighlightText()
    end)

    self.Editbox:SetScript('OnEnterPressed', function()
        self.Editbox:ClearFocus()
        local newValue = tonumber(self.Editbox:GetText()) or self.Slider:GetValue();
        self.Slider:SetValue(newValue)
        self.Editbox:SetText(self.Slider.RightText:GetText())
        self.Slider.RightText:Hide()
    end)

    self.Editbox:SetJustifyH('CENTER')
end

-- -- SliderContainer
-- DFSettingsListSliderWithCheckboxContainerMixin = {}

-- function DFSettingsListSliderWithCheckboxContainerMixin:Init(node)
--     -- print('DFSettingsListCheckboxContainerMixin:OnLoad()')
--     local elementData = node:GetData();
--     self.ElementData = elementData;
--     local args = elementData.args;
--     -- print('~~~~~~:OnLoad()', args.name)

--     self.Text:SetText(args.name);
--     self.Text:Show();

--     self:SetTooltip(args.name, args.desc);

--     self.Slider:UnregisterCallback('OnValueChanged', self)
--     -- print(args.min, args.max, args.bigStep)
--     -- get({key}), data.min, data.max, data.bigStep
--     self.Slider.Slider:SetMinMaxValues(args.min, args.max)
--     self.Slider.Slider:SetValueStep(args.bigStep)
--     self.Slider.Slider:SetValue(elementData.get({elementData.key}))
--     self.Slider.RightText:Hide()
--     self.Editbox:SetText(self.Slider.RightText:GetText())
--     self.Editbox:SetFrameLevel(self.Tooltip:GetFrameLevel() + 1)

--     self.Slider:RegisterCallback('OnValueChanged', function(self, ...)
--         local newValue = ...
--         if ... ~= elementData.get({elementData.key}) then elementData.set({elementData.key}, newValue) end
--         self.Slider.RightText:Hide();
--         self.Editbox:SetText(self.Slider.RightText:GetText())
--     end, self)

--     self:SetBaseSmall(elementData.small);

--     if elementData.small then
--         self.Slider:SetWidth(204);
--         self.Slider:SetPoint('LEFT', self.Text, 'RIGHT', 8, 3);

--         self.Editbox:SetPoint('LEFT', self.Slider.RightText, 'LEFT', -5, 0)
--         self.Editbox:SetWidth(40);
--     else
--         self.Slider:SetWidth(250);
--         self.Slider:SetPoint('LEFT', self.Text, 'RIGHT', 8, 3);

--         self.Editbox:SetPoint('LEFT', self.Slider.RightText, 'LEFT', 0, 0)
--         self.Editbox:SetWidth(60);
--     end

--     -- editbox
--     self.Editbox:SetScript('OnEscapePressed', function()
--         self.Editbox:ClearFocus()
--     end)

--     self.Editbox:SetScript('OnTabPressed', function()
--         self.Editbox:ClearFocus()
--     end)

--     self.Editbox:SetScript('OnEditFocusGained', function()
--         self.Editbox:HighlightText()
--     end)

--     self.Editbox:SetScript('OnEnterPressed', function()
--         self.Editbox:ClearFocus()
--         local newValue = tonumber(self.Editbox:GetText()) or self.Slider:GetValue();
--         self.Slider:SetValue(newValue)
--         self.Editbox:SetText(self.Slider.RightText:GetText())
--         self.Slider.RightText:Hide()
--     end)

--     self.Editbox:SetJustifyH('CENTER')
-- end

-- Slider
DFSettingsListSliderMixin = CreateFromMixins(CallbackRegistryMixin);
DFSettingsListSliderMixin:GenerateCallbackEvents({
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

function DFSettingsListSliderMixin:OnLoad()
    CallbackRegistryMixin.OnLoad(self);

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
end

function DFSettingsListSliderMixin:OnEnter()
    -- print('DFSettingsListSliderMixin:OnEnter()')
    local parent = self:GetParent();

    parent.Tooltip.HoverBackground:Show();
    SettingsTooltip:SetOwner(self, 'ANCHOR_RIGHT', 0, 0);
    parent.TooltipFunc();
    SettingsTooltip:Show();
end

function DFSettingsListSliderMixin:OnLeave()
    -- print('DFSettingsListSliderMixin:OnLeave()')
    local parent = self:GetParent()
    parent.Tooltip.HoverBackground:Hide()
    SettingsTooltip:Hide();
end

-- Button
-- DFSettingsListButtonMixin = CreateFromMixins(CallbackRegistryMixin);
-- DFSettingsListButtonMixin:GenerateCallbackEvents({"OnButtonClicked"});
DFSettingsListButtonMixin = {}

function DFSettingsListButtonMixin:Init(node)
    -- print('DFSettingsListButtonMixin:Init()')
    local elementData = node:GetData();
    self.ElementData = elementData;
    local args = elementData.args;

    self.Text:SetText(args.name);
    self.Text:Show();

    self:SetTooltip(args.name, args.desc);

    self:SetBaseSmall(elementData.small);
    self.Button:SetFrameLevel(self.Tooltip:GetFrameLevel() + 1)

    if elementData.small then
        self.Button:SetWidth(200);
        self.Button:SetPoint('LEFT', self.Text, 'RIGHT', 8, 0);
    else
        self.Button:SetWidth(183);
        self.Button:SetPoint('LEFT', self.Text, 'RIGHT', 40, 0);
    end

    self.Button:SetText(args.btnName);
    self.Button:SetScript('OnClick', function(button, buttonName)
        -- print('OnClick')
        self:TriggerEvent(DFSettingsListElementBaseMixin.Event.OnClick, true)
    end)

    self:UnregisterCallback('OnClick', self)
    self:RegisterCallback('OnClick', function(self, ...)
        args.func()
    end, self)
end

-- ColorPicker
-- DFSettingsListButtonMixin = CreateFromMixins(CallbackRegistryMixin);
-- DFSettingsListButtonMixin:GenerateCallbackEvents({"OnButtonClicked"});
DFSettingsListColorPickerMixin = {}

function DFSettingsListColorPickerMixin:Init(node)
    -- print('DFSettingsListButtonMixin:Init()')
    local elementData = node:GetData();
    self.ElementData = elementData;
    local args = elementData.args;

    self.Text:SetText(args.name);
    self.Text:Show();

    self:SetTooltip(args.name, args.desc);

    self:SetBaseSmall(elementData.small);

    self.Color:SetColorHex(elementData.get({elementData.key}))

    self.Color:SetScript('OnEnter', function()
        --
        -- print('OnEnter!')
    end)
    self.Color:SetScript('OnLeave', function()
        --
        -- print('OnLeave!')
    end)
    self.Color:SetScript('OnClick', function()
        --
        -- print('clicks!')
        local currentColor = CreateColorFromRGBHexString(elementData.get({elementData.key}))

        local info = {
            r = currentColor.r,
            g = currentColor.g,
            b = currentColor.b,
            swatchFunc = function()
                --
                -- print('swatchFunc')
                local newR, newG, newB = _G['DragonflightUIColorPicker']:GetColorRGB()
                local newA = _G['DragonflightUIColorPicker']:GetColorAlpha()
                local newC = CreateColor(newR, newG, newB, newA)
                -- print('~', newC:GenerateHexColorNoAlpha())
                elementData.set({elementData.key}, newC:GenerateHexColorNoAlpha())

                self.Color:SetColorHex(elementData.get({elementData.key}))
            end,
            hasOpacity = false,
            opacityFunc = nil,
            opacity = 1.0,
            cancelFunc = function(previousValues)
                --          
                local prevC = CreateColor(previousValues.r, previousValues.g, previousValues.b, previousValues.a)
                elementData.set({elementData.key}, prevC:GenerateHexColorNoAlpha())

                self.Color:SetColorHex(elementData.get({elementData.key}))
            end,
            extraInfo = {}
        }

        _G['DragonflightUIColorPicker']:SetupColorPickerAndShow(info)
    end)

    -- DragonflightUIColorPicker

    -- self.Button:SetFrameLevel(self.Tooltip:GetFrameLevel() + 1)

    -- if elementData.small then
    --     self.Button:SetWidth(200);
    --     self.Button:SetPoint('LEFT', self.Text, 'RIGHT', 8, 0);
    -- else
    --     self.Button:SetWidth(183);
    --     self.Button:SetPoint('LEFT', self.Text, 'RIGHT', 40, 0);
    -- end

    -- self.Button:SetText(args.btnName);
    -- self.Button:SetScript('OnClick', function(button, buttonName)
    --     -- print('OnClick')
    --     self:TriggerEvent(DFSettingsListElementBaseMixin.Event.OnClick, true)
    -- end)

    -- self:UnregisterCallback('OnClick', self)
    -- self:RegisterCallback('OnClick', function(self, ...)
    --     args.func()
    -- end, self)
end

DFSettingsListColorMixin = {}

function DFSettingsListColorMixin:OnLoad()
    -- print('~~DFSettingsListColorMixin:OnLoad()')

    local colorSwatch = self:CreateTexture(nil, "OVERLAY")
    colorSwatch:SetWidth(26)
    colorSwatch:SetHeight(26)
    colorSwatch:SetTexture(130939) -- Interface\\ChatFrame\\ChatFrameColorSwatch
    colorSwatch:SetPoint("LEFT")
    -- colorSwatch:Hide()
    self.ColorSwatch = colorSwatch

    local texture = self:CreateTexture(nil, "BACKGROUND")
    colorSwatch.background = texture
    texture:SetWidth(23)
    texture:SetHeight(23)
    texture:SetColorTexture(1, 1, 1)
    texture:SetPoint("CENTER", colorSwatch)
    -- texture:Hide()
    self.Texture = texture

    local checkers = self:CreateTexture(nil, "BACKGROUND")
    colorSwatch.checkers = checkers
    checkers:SetWidth(21)
    checkers:SetHeight(21)
    checkers:SetTexture(188523) -- Tileset\\Generic\\Checkers
    checkers:SetTexCoord(.25, 0, 0.5, .25)
    checkers:SetDesaturated(true)
    checkers:SetVertexColor(1, 1, 1, 0.75)
    checkers:SetPoint("CENTER", colorSwatch)
    -- checkers:Hide()
    self.Checkers = checkers

    local text = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetHeight(24)
    text:SetJustifyH("LEFT")
    text:SetTextColor(1, 1, 1)
    text:SetPoint("LEFT", colorSwatch, "RIGHT", 2, 0)
    text:SetPoint("RIGHT")
    self.Text = text
end

function DFSettingsListColorMixin:SetColorHex(hex)
    -- print('DFSettingsListColorMixin:SetColorHex(hex)')
    local c = CreateColorFromRGBHexString(hex)
    self.ColorSwatch:SetVertexColor(c.r, c.g, c.b, 1.0)
end

-- Editbox
DFSettingsListEditboxMixin = {}

function DFSettingsListEditboxMixin:Init(node)
    -- print('DFSettingsListButtonMixin:Init()')
    local elementData = node:GetData();
    self.ElementData = elementData;
    local args = elementData.args;

    self.Text:SetText(args.name);
    self.Text:Show();

    self:SetTooltip(args.name, args.desc);

    self:SetBaseSmall(elementData.small);

    if elementData.small then
        self.Editbox:SetWidth(180);
        self.Editbox:SetPoint('LEFT', self.Text, 'RIGHT', 8 + 2, 0);
    else
        self.Editbox:SetWidth(200);
        self.Editbox:SetPoint('LEFT', self.Text, 'RIGHT', 8, 0);
    end

    -- editbox
    self.Editbox:SetFrameLevel(self.Tooltip:GetFrameLevel() + 1)

    self.Editbox:SetText(elementData.get({elementData.key}) or '')

    self.Editbox:SetScript('OnEscapePressed', function()
        self.Editbox:ClearFocus()
    end)

    self.Editbox:SetScript('OnTabPressed', function()
        self.Editbox:ClearFocus()
    end)

    self.Editbox:SetScript('OnEditFocusGained', function()
        self.Editbox:HighlightText()
    end)

    self.Editbox:SetScript('OnEnterPressed', function()
        self.Editbox:ClearFocus()

        if args.Validate then
            local text = self.Editbox:GetText();
            local valid, reset = args.Validate(text)
            if text == '' then
                elementData.set({elementData.key}, text)
            elseif valid then
                elementData.set({elementData.key}, text)
            else
                if reset then
                    self.Editbox:SetText(elementData.get({elementData.key}))
                    elementData.set({elementData.key}, elementData.get({elementData.key}))
                end
            end
        end
    end)

    self.Editbox:SetJustifyH('CENTER')
end

-- Dropdown
DFSettingsListDropdownContainerMixin = {}

function DFSettingsListDropdownContainerMixin:OnLoad()
    -- print('~~DFSettingsListDropdownMixin:OnLoad()');
    DFSettingsListElementBaseMixin.OnLoad(self);

    self.Button:ClearAllPoints()
    -- self.Button:SetPoint('LEFT', self.Text, 'RIGHT', 4 + 32 + 5, 0);
    self.Button:SetPoint('LEFT', self.Text, 'RIGHT', 20, 0);
    -- self.Button:SetEnabled(false)

    local sizeX = 185
    self.Button.Dropdown:SetWidth(sizeX)
    -- self.Button:SetWidth(sizeX - 2 * (32 + 5))
    self.Button.Dropdown.Text:SetText('TEST')

    -- DevTools_Dump(self.Button.Dropdown)

    self.Button.IncrementButton:HookScript('OnClick', function()
        self.Button:UpdateSteppers()
    end)
    self.Button.DecrementButton:HookScript('OnClick', function()
        self.Button:UpdateSteppers()
    end)
end

-- hooksecurefunc(Settings, 'CreateDropdownOptionInserter', function(options)
-- DevTools_Dump(options())
-- end)

-- hooksecurefunc(Settings, 'CreateOptionsInitTooltip', function(setting, name, tooltip, options)
--     if name == 'Auto Loot Key' then
--         -- DevTools_Dump(setting)
--         print('name:', name)
--         -- DevTools_Dump(tooltip)
--         -- DevTools_Dump(options())
--     end
-- end)

-- hooksecurefunc(Settings, 'InitDropdown', function(dropdown, setting, elementInserter, initTooltip)
--     -- DevTools_Dump(options())

--     local settingValue = setting:GetValue();
--     if settingValue == 'SHIFT' then
--         print('settingValue:', settingValue)

--         -- DevTools_Dump(setting)
--         -- DevTools_Dump(name)
--         -- DevTools_Dump(tooltip)
--         -- DevTools_Dump(options())
--         local test = initTooltip()
--         DevTools_Dump(test)
--     end

-- end)

function DFSettingsListDropdownContainerMixin:Init(node)
    -- print('~~~~DFSettingsListDropdownMixin:Init()');
    local elementData = node:GetData();
    self.ElementData = elementData;
    local args = elementData.args;

    self.Text:SetText(args.name);
    self.Text:Show();

    self:SetTooltip(args.name, args.desc);

    self:SetBaseSmall(elementData.small);

    if elementData.small then
        self.Button.Dropdown:SetWidth(140)
        self.Button:SetPoint('LEFT', self.Text, 'RIGHT', 0, 0);
    else
        self.Button.Dropdown:SetWidth(180)
        self.Button:SetPoint('LEFT', self.Text, 'RIGHT', 20, 0);
    end

    self.Button:UpdateSteppers()

    if args.dropdownValuesFunc then
        self.Button.Dropdown:SetupMenu(args.dropdownValuesFunc)
    elseif args.dropdownValues then
        -- self.Button.Dropdown:OverrideText(elementData.get({elementData.key}));
        -- self.Button.Dropdown:SetDefaultText(elementData.get({elementData.key}));

        local generator = function(dropdown, rootDescription)
            rootDescription:SetTag('TAG?')
            -- rootDescription:CreateTitle('TITLETEST')

            local function IsSelected(name)
                -- print('IsSelected', name)
                return elementData.get({elementData.key}) == name;
            end

            local function SetSelected(name)
                -- print('SetSelected', name)
                elementData.set({elementData.key}, name)
            end

            for k, v in ipairs(args.dropdownValues) do
                --
                local name = v.value;
                local desc = v.text;

                -- local btnFunc = function()
                --     print('btnFunc', name)
                --     -- elementData.set({args.name}, name)
                --     elementData.set({elementData.key}, name)

                --     self.Text:SetText(args.name);
                --     self.Text:Show();
                -- end

                local radio = rootDescription:CreateRadio(desc, IsSelected, SetSelected, name);
                -- radio:SetTooltip(function(tooltip, elementDescription)
                --     GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription));
                --     GameTooltip_AddInstructionLine(tooltip, "Test Tooltip Instruction");
                --     GameTooltip_AddNormalLine(tooltip, "Test Tooltip Normal Line");
                --     GameTooltip_AddErrorLine(tooltip, "Test Tooltip Colored Line");
                -- end);

                -- local button = rootDescription:CreateButton(desc, btnFunc, name);
            end
        end
        self.Button.Dropdown:SetupMenu(generator)

        -- rootDescription:CreateTitle(EQUIPMENT_SET_ASSIGN_TO_SPEC);

        -- __Checkbox__
        -- rootDescription:SetTag("MENU_CALENDAR_FILTER");
        -- for index, data in ipairs(CALENDAR_FILTER_CVARS) do
        -- 	rootDescription:CreateCheckbox(data.text, IsSelected, SetSelected, data);
        -- end

        -- __Radio__
        -- rootDescription:SetTag("MENU_COMPACT_RAID_FRAME_DISPLAY_PROFILES");
        -- for i = 1, GetNumRaidProfiles() do
        --     local name = GetRaidProfileName(i);
        --     rootDescription:CreateRadio(name, IsSelected, SetSelected, name);
        -- end

        -- __ Divider__
        -- rootDescription:CreateDivider();

        -- __Button__
        -- local button = rootDescription:CreateButton(tbl.text, tbl.func);     
        -- button:SetEnabled(not tbl.disabled);
        do
            -- print('~~~~~dropdownValues~~~~~')
            -- DevTools_Dump(args.dropdownValues)
            -- -- local function Inserter(rootDescription, isSelected, setSelected)
            -- -- 	for index, optionData in ipairs(options()) do
            -- -- 		local optionDescription = rootDescription:CreateTemplate("SettingsDropdownButtonTemplate");
            -- -- 		Settings.CreateDropdownButton(optionDescription, optionData, isSelected, setSelected);
            -- -- 	end
            -- -- end
            -- -- return Inserter;
            -- local inserter = Settings.CreateDropdownOptionInserter(args.dropdownValues);

            -- -- local initDropdownTooltip = Settings.CreateOptionsInitTooltip(dropdownSetting, args.name, args.desc,
            -- --                                                               dropdownOptions);
            -- local initDropdownTooltip = function()
            --     print('initDropdownTooltip!')
            -- end

            -- local dropdownSetting = {}
            -- function dropdownSetting:GetValue()
            --     print('dropdownSetting:GetValue()')
            --     return elementData.get({elementData.key});
            -- end

            -- function dropdownSetting:SetValue(value)
            --     print('dropdownSetting:SetValue()', value)
            --     return elementData.set({elementData.key}, value);
            -- end

            -- Settings.InitDropdown(self.Dropdown, dropdownSetting, inserter, initDropdownTooltip);

            -- self.Dropdown:SetEnabled(true)

        end
    else
        self.Button.Dropdown:SetupMenu(function(_, _)
        end)
    end
end
