-- List
DragonFlightUIConfigCategoryListMixin = {}

function DragonFlightUIConfigCategoryListMixin:OnLoad()
    print('DragonFlightUIConfigCategoryListMixin:OnLoad()')

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

    self.ScrollView:SetElementInitializer("DragonflightUIConfigCategoryListElementTemplate",
                                          function(frame, elementData)
        -- This is called each time the scrollview acquires a frame this
        -- should generally call a method on the acquired frame and update
        -- its visual state accordingly.
        frame:Init(elementData)
    end)

    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView)

    local scrollBoxAnchorsWithBar = {CreateAnchor("TOPLEFT", -leftPad, 0), CreateAnchor("BOTTOMRIGHT", -16, 0)};
    local scrollBoxAnchorsWithoutBar = {scrollBoxAnchorsWithBar[1], CreateAnchor("BOTTOMRIGHT", 0, 0)};
    ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, scrollBoxAnchorsWithBar,
                                                     scrollBoxAnchorsWithoutBar);
end

function DragonFlightUIConfigCategoryListMixin:AddElement(elementData)
    self.DataProvider:Insert(elementData)
end

-- Element
DragonFlightUIConfigCategoryListElementMixin = {}

function DragonFlightUIConfigCategoryListElementMixin:OnLoad()
    print('DragonFlightUIConfigCategoryListElementMixin:OnLoad()')
end

function DragonFlightUIConfigCategoryListElementMixin:Init(elementData)
    self:Reset()

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

-- Header
DragonFlightUIConfigCategoryListHeaderMixin = {}

function DragonFlightUIConfigCategoryListHeaderMixin:OnLoad()
    -- print('DragonFlightUIConfigCategoryListHeaderMixin:OnLoad()')
    self.Background:SetAtlas('Options_CategoryHeader_1', true)
end

-- Button
DragonFlightUIConfigCategoryListButtonMixin = {}

function DragonFlightUIConfigCategoryListButtonMixin:OnLoad()
    -- print('DragonFlightUIConfigCategoryListButtonMixin:OnLoad()')
end

function DragonFlightUIConfigCategoryListButtonMixin:OnEnter()
    -- print(self:GetName(), 'OnEnter')
end

function DragonFlightUIConfigCategoryListButtonMixin:OnLeave()
    -- print(self:GetName(), 'OnLeave')
end

function DragonFlightUIConfigCategoryListButtonMixin:OnMouseDown()
    -- print(self:GetName(), 'OnMouseDown')
end

function DragonFlightUIConfigCategoryListButtonMixin:OnMouseUp()
    -- print(self:GetName(), 'OnMouseUp')  
end

