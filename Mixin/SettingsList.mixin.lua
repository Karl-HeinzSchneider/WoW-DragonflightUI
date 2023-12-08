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

    self.Item.Checkbox:SetPoint("LEFT", self, "CENTER", -80, 0)
    self.Item.Checkbox:Hide()
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
    self.Item.Tooltip:SetTooltipFunc(GenerateClosure(Settings.InitTooltip, name, desc or ''))
end

function ScrollableListItemMixinDF:SetCheckbox(checked)
    -- self.Item.Checkbox:SetValue(checked)
    self.Item.Checkbox:Show()
end

--------------------------
SettingsCheckBoxMixinDF = {};
function SettingsCheckBoxMixinDF:OnLoad()
end
function SettingsCheckBoxMixinDF:OnEnter()
    print('SettingsCheckBoxMixinDF OnEnter')
end
function SettingsCheckBoxMixinDF:OnLeave()
    print('SettingsCheckBoxMixinDF OnLeave')
end

function SettingsCheckBoxMixinDF:SetValue(value)
    self:SetChecked(value)
end

local elementSize = {header = 45, range = 26, execute = 26, description = 26, toggle = 26}

--------------------------
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

    print('----')
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

