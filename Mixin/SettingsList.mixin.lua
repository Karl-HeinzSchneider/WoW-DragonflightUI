ScrollableListItemMixinDF = {}

function ScrollableListItemMixinDF:Init(elementData)
    -- self.Background:SetColorTexture(elementData.color:GetRGBA())
    -- self.Text:SetText(elementData.text)

    local key = elementData.key
    local data = elementData.args

    local normal = function()
        self.Item = CreateFrame('Frame', nil, self, 'SettingsListElementTemplateDF')
        self.Item:SetAllPoints()
        self.Item.Text:SetText(data.name)
        -- self.Text:SetPoint("LEFT", (self:GetIndent() + 37), 0);
        self.Item.Text:SetPoint("LEFT", 37, 0);
        self.Item.Text:SetPoint("RIGHT", self, "CENTER", -85, 0);

        -- self.Item.Tooltip.tooltipText = 'tooltipsss'
        -- self.Item.Tooltip:SetTooltipFunc(GenerateClosure(Settings.InitTooltip, data.name, data.desc or ''))
    end

    -- self.Text:SetText(data.type)
    if data.type == 'header' then
        self.Header = CreateFrame('Frame', nil, self, 'SettingsListSectionHeaderTemplateDF')
        self.Header:SetAllPoints()
        self.Header.Title:SetText(data.name)
    elseif data.type == 'range' then
        -- normal()

    elseif data.type == 'execute' then
        normal()
    elseif data.type == 'description' then
        normal()
    elseif data.type == 'toggle' then
        normal()
    elseif data.type == 'toggle' then
        --
    elseif data.type == 'toggle' then
    end
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

