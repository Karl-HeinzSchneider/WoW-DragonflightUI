ScrollableListItemMixinDF = {}

function ScrollableListItemMixinDF:Init(elementData)
    self.Background:SetColorTexture(elementData.color:GetRGBA())
    self.Text:SetText(elementData.text)
end

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
        local extent = elementData.viewH
        return extent or 1
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
    self.DataProvider:Flush()
    if not data then
        print('SettingsListMixinDF:Display', 'no data')
        return
    end

    self.Header.Title:SetText(data.name)
end

function SettingsListMixinDF:RemoveListItem()
    local lastIndex = self.DataProvider:GetSize()
    self.DataProvider:RemoveIndex(lastIndex)
end

function SettingsListMixinDF:RegisterSettings(cat, sub, data)
    print('RegisterSettigs', cat, sub)
end

