DFSettingsListMixin = CreateFromMixins(CallbackRegistryMixin);
DFSettingsListMixin:GenerateCallbackEvents({"OnDefaults", "OnRefresh"});

function DFSettingsListMixin:OnLoad()
    CallbackRegistryMixin.OnLoad(self);
    print('DFSettingsListMixin', 'OnLoad')

    local parent = self:GetParent()
    self:SetPoint('TOPLEFT', parent, 'TOPLEFT', 0, 0);
    self:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', 0, 0);
    self:Show()

    self.DataProvider = CreateTreeDataProvider();
    self.sortComparator = function(a, b)
        return b.data.order > a.data.order
    end
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
            factory("DFSettingsListDropdownContainer", Initializer);
        else
            print('~no factory: ', elementType, ' ~')
            factory("Frame");
        end
    end);

    self.ScrollView:SetDataProvider(self.DataProvider)

    local elementSize = {
        header = 45,
        range = 26,
        execute = 26,
        description = 26,
        toggle = 26,
        select = 26,
        divider = 16
    }

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

function DFSettingsListMixin:Display(data, small)
    -- self.DataProvider:Flush()
    -- self.DataProvider = CreateTreeDataProvider()
    -- self.ScrollView:SetDataProvider(self.DataProvider)

    self.DataProvider = CreateTreeDataProvider();
    local affectChildren = true;
    local skipSort = true;
    self.DataProvider:SetSortComparator(self.sortComparator, affectChildren, skipSort)

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
            local elementData = {key = k, order = (v.order or 9999), args = v, small = small}
            local node = self.DataProvider:Insert(elementData);

            -- local affectChildren = true;
            -- local skipSort = false;
            node:SetSortComparator(self.sortComparator, true, false)
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

    self.Text:ClearAllPoints()
    self.Text:SetPoint('LEFT', 37, 0)
    self.Text:SetWidth(180);
    self.Text:SetText('');
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

    -- self.checkbox:UnregisterCallback('OnValueChanged', self);
    self.Checkbox:UnregisterCallback('OnValueChanged', self)
    self.Checkbox:SetValue(elementData.get({elementData.key}));
    self.Checkbox:RegisterCallback('OnValueChanged', function(cb, checked)
        -- print('OnValueChanged', checked) 
        elementData.set({elementData.key}, checked)
    end, self)

    self.Tooltip:SetScript('OnMouseDown', function()
        self.Checkbox:SetValue(not self.Checkbox:GetChecked())
        self.Checkbox:TriggerEvent(DFSettingsListCheckboxMixin.Event.OnValueChanged, self.Checkbox:GetChecked())
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

    self.Slider:RegisterCallback('OnValueChanged', function(self, ...)
        local newValue = ...
        if ... ~= elementData.get({elementData.key}) then elementData.set({elementData.key}, newValue) end
        self.Slider.RightText:Hide();
        self.Editbox:SetText(self.Slider.RightText:GetText())
    end, self)

    if args.small then
        -- self.Slider:SetWidth(250);
        -- self.Slider:SetPoint('LEFT', self.Text, 'RIGHT', 8, 3);
    else
        self.Slider:SetWidth(250);
        self.Slider:SetPoint('LEFT', self.Text, 'RIGHT', 8, 3);
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

    if args.small then
        -- self.Slider:SetWidth(250);
        -- self.Slider:SetPoint('LEFT', self.Text, 'RIGHT', 8, 3);
    else
        self.Button:SetWidth(200);
        self.Button:SetPoint('LEFT', self.Text, 'RIGHT', 8, 0);
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

    if args.small then
        -- self.Slider:SetWidth(250);
        -- self.Slider:SetPoint('LEFT', self.Text, 'RIGHT', 8, 3);
    else
        -- self.Button:SetWidth(200);
        -- self.Button:SetPoint('LEFT', self.Text, 'RIGHT', 8, 0);
    end

    if args.dropdownValues then

        local generator = function(dropdown, rootDescription)
            rootDescription:SetTag('')
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
                local radio = rootDescription:CreateRadio(desc, IsSelected, SetSelected, name);
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
    end
end
