--
DFSettingsCategoryListMixin = CreateFromMixins(CallbackRegistryMixin);
DFSettingsCategoryListMixin:GenerateCallbackEvents({"OnSelectionChanged"});

function DFSettingsCategoryListMixin:OnLoad()
    -- print('DFSettingsCategoryListMixin:OnLoad()')
    CallbackRegistryMixin.OnLoad(self)

    self.DataProvider = CreateTreeDataProvider();
    local sortComparator = function(a, b)
        return b.data.order > a.data.order
    end
    local affectChildren = false;
    local skipSort = true;
    self.DataProvider:SetSortComparator(sortComparator, affectChildren, skipSort)

    self.selectedElement = '_'

    -- The scroll box is anchored -50 so that the "new" label can appear without
    -- being clipped. This offset moves the contents back into the desired position.
    local padLeft = 50;

    local indent = 0; -- maybe 10?
    local pad = 0;
    local spacing = 2;
    local view = CreateScrollBoxListTreeListView(indent, pad, pad, padLeft, pad, spacing);
    self.View = view;

    view:SetElementFactory(function(factory, node)
        local elementData = node:GetData();
        if elementData.categoryInfo then
            local function Initializer(button, node)
                button:Init(node);

                button:SetScript("OnClick", function(button, buttonName)
                    node:ToggleCollapsed();
                    button:SetCollapseState(node:IsCollapsed());
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
                end);
            end
            factory("DFSettingsCategoryHeader", Initializer);
        elseif elementData.elementInfo then
            local function Initializer(button, node)
                button:Init(node, false);

                if elementData.key == self.selectedElement then self.selectionBehavior:Select(button) end
                local selected = self.selectionBehavior:IsElementDataSelected(node);
                button:SetSelected(selected);

                button:SetScript("OnClick", function(button, buttonName, down)
                    -- print('onclick', elementData.elementInfo.name)
                    if not elementData.isEnabled then return end
                    self.selectionBehavior:Select(button);
                    -- PlaySound(SOUNDKIT.UI_90_BLACKSMITHING_TREEITEMCLICK);
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
                end);

            end
            factory("DFSettingsCategoryElement", Initializer);

            -- elseif elementData.isDivider then
            --     factory("ProfessionsRecipeListDividerTemplate");
        else
            factory("Frame");
        end
    end);

    view:SetDataProvider(self.DataProvider)

    view:SetElementExtentCalculator(function(dataIndex, node)
        local elementData = node:GetData();
        local baseElementHeight = 20;
        local baseHeaderHeight = 30;

        if elementData.elementInfo then return baseElementHeight; end

        if elementData.categoryInfo then return baseHeaderHeight; end

        if elementData.dividerHeight then return elementData.dividerHeight; end

        if elementData.topPadding then return 1; end

        if elementData.bottomPadding then return 10; end
    end);

    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, view);

    local scrollBoxAnchorsWithBar = {CreateAnchor("TOPLEFT", -padLeft, 0), CreateAnchor("BOTTOMRIGHT", -16, 0)};
    local scrollBoxAnchorsWithoutBar = {scrollBoxAnchorsWithBar[1], CreateAnchor("BOTTOMRIGHT", 0, 0)};
    ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, scrollBoxAnchorsWithBar,
                                                     scrollBoxAnchorsWithoutBar);

    local function OnSelectionChanged(o, elementData, selected)
        -- print('OnSelectionChanged', o, elementData, selected)
        local button = self.ScrollBox:FindFrame(elementData);
        if button then button:SetSelected(selected); end

        if selected then
            local data = elementData:GetData();

            local newElementID = data.key
            local changed = newElementID ~= self.selectedElement
            if changed then
                -- print('OnSelectionChanged-changed', newElementID)
                self.selectedElement = newElementID
                EventRegistry:TriggerEvent("DFSettingsCategoryListMixin.Event.OnSelectionChanged", newElementID, self);

                self:SelectElement(newElementID, false)
                -- if newRecipeID then self.previousRecipeID = newRecipeID; end
            end
        end
    end

    self.selectionBehavior = ScrollUtil.AddSelectionBehavior(self.ScrollBox);
    self.selectionBehavior:RegisterCallback(SelectionBehaviorMixin.Event.OnSelectionChanged, OnSelectionChanged, self);
end

function DFSettingsCategoryListMixin:SelectElement(id, scrollToElement)
    local elementData = self.selectionBehavior:SelectElementDataByPredicate(function(node)
        local data = node:GetData();
        return data.elementInfo and data.id == id
    end);

    if scrollToElement then
        self.ScrollBox:ScrollToElementData(elementData);
        -- ScrollBoxConstants.AlignCenter,  ScrollBoxConstants.RetainScrollPosition
    end

    return elementData;
end

function DFSettingsCategoryListMixin:RegisterCategory(id, info, sortComparator, isDragonflight)
    local dataProvider = self.DataProvider;

    local data = {
        id = id,
        order = info.order or 666,
        isExpanded = info.isExpanded or true,
        categoryInfo = {
            name = info.name,
            isExpanded = true,
            descr = info.descr or '',
            isNew = info.isNew or false,
            isDragonflight = isDragonflight or false
        }
    }

    local node = dataProvider:Insert(data)

    local affectChildren = false;
    local skipSort = true;

    if sortComparator then
        node:SetSortComparator(sortComparator, affectChildren, skipSort)
    else
        local orderSortComparator = function(a, b)
            return b.data.order > a.data.order
        end
        node:SetSortComparator(orderSortComparator, affectChildren, skipSort)
    end
end

function DFSettingsCategoryListMixin:RegisterElement(id, categoryID, info)
    local dataProvider = self.DataProvider;

    local data = {
        id = id,
        categoryID = categoryID,
        key = categoryID .. '_' .. id,
        isEnabled = info.isEnabled,
        order = info.order or 99999,
        elementInfo = {
            name = info.name,
            descr = info.descr or '',
            module = info.module or '*moduleXY*',
            isNew = info.isNew or false
        }
    }

    -- dataProvider:Insert(data)
    dataProvider:InsertInParentByPredicate(data, function(node)
        local nodeData = node:GetData()

        return nodeData.id == data.categoryID
    end)
end

function DFSettingsCategoryListMixin:UpdateElementData(id, categoryID, info)
    -- TreeDataProviderMixin:FindElementDataByPredicate(predicate, excludeCollapsed)
    local key = categoryID .. '_' .. id;
    local oldNode = self.DataProvider:FindElementDataByPredicate(function(node)
        local data = node:GetData();
        return data.key == key;
    end, false)

    local skipInvalidation = true;
    self.DataProvider:Remove(oldNode, skipInvalidation)

    self:RegisterElement(id, categoryID, info)
end

function DFSettingsCategoryListMixin:EnableElement(id, categoryID)
    local key = categoryID .. '_' .. id;
    local oldNode = self.DataProvider:FindElementDataByPredicate(function(node)
        local data = node:GetData();
        return data.key == key;
    end, false)

    local skipInvalidation = true;
    self.DataProvider:Remove(oldNode, skipInvalidation);

    local oldNodeData = oldNode:GetData();
    oldNodeData.isEnabled = true;

    self.DataProvider:InsertInParentByPredicate(oldNodeData, function(node)
        local nodeData = node:GetData()

        return nodeData.id == categoryID
    end)
end

function DFSettingsCategoryListMixin:FindElementDataByPredicate(predicate)
    return self.DataProvider:FindElementDataByPredicate(predicate, false)
end

function DFSettingsCategoryListMixin:FindElementDataByKey(key)
    return self:FindElementDataByPredicate(function(node)
        local nodeData = node:GetData();
        return nodeData.key == key;
    end)
end

-- Header
DFSettingsCategoryHeaderMixin = {}

function DFSettingsCategoryHeaderMixin:OnLoad()
    -- print('DFSettingsCategoryHeaderMixin:OnLoad()')
    self.Background:SetAtlas('Options_CategoryHeader_1', true)

    self.Background:SetDrawLayer('BACKGROUND', -1)
    self.CollapseIcon:SetDrawLayer('ARTWORK', 2)
end

function DFSettingsCategoryHeaderMixin:Init(node)
    local elementData = node:GetData();
    self.ElementData = elementData;
    -- print('DFSettingsCategoryHeaderMixin:Init()', elementData.categoryInfo.name)

    self.Label:SetText(elementData.categoryInfo.name)
    self.Description = elementData.categoryInfo.descr

    if elementData.isExpanded then
        node:SetCollapsed(false, true, false)
    else
        node:SetCollapsed(true, true, false)
    end

    self:SetCollapseState(node:IsCollapsed());
end

function DFSettingsCategoryHeaderMixin:SetCollapseState(collapsed)
    if collapsed then
        self.CollapseIcon:SetTexCoord(0.302246, 0.312988, 0.0537109, 0.0693359)
        self.CollapseIconAlphaAdd:SetTexCoord(0.302246, 0.312988, 0.0537109, 0.0693359)
        -- self.Background:Show()
    else
        self.CollapseIcon:SetTexCoord(0.270508, 0.28125, 0.0537109, 0.0693359)
        self.CollapseIconAlphaAdd:SetTexCoord(0.270508, 0.28125, 0.0537109, 0.0693359)
        -- self.Background:Hide() -- TODO
    end
end

-- Element
DFSettingsCategoryElementMixin = CreateFromMixins(ButtonStateBehaviorMixin)

function DFSettingsCategoryElementMixin:OnLoad()
    -- print('DFSettingsCategoryElementMixin:OnLoad()')

    self.over = nil
    self.down = nil
    self.isEnabled = false
    self.isSelected = false

    self:UpdateState()
end

function DFSettingsCategoryElementMixin:Init(node)
    local elementData = node:GetData();
    self.ElementData = elementData;
    -- print('DFSettingsCategoryElementMixin:Init()', elementData.elementInfo.name)

    self.Label:SetText(elementData.elementInfo.name)
    self.NewFeature:SetShown(elementData.elementInfo.isNew)
    self.Description = elementData.elementInfo.descr
    self:SetEnabled(elementData.isEnabled)

    self:UpdateState()
end

function DFSettingsCategoryElementMixin:UpdateState()
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

function DFSettingsCategoryElementMixin:OnEnter()
    -- print(self:GetName(), 'OnEnter')
    if ButtonStateBehaviorMixin.OnEnter(self) then self:UpdateState(); end

    -- @TODO
    if not self:IsEnabled() then
        -- GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        -- GameTooltip_AddNormalLine(GameTooltip, self.ElementData.elementInfo.module);
        -- GameTooltip:Show();
    end
end

function DFSettingsCategoryElementMixin:OnLeave()
    -- print(self:GetName(), 'OnLeave')
    if ButtonStateBehaviorMixin.OnLeave(self) then self:UpdateState(); end
    -- GameTooltip_Hide();
end

function DFSettingsCategoryElementMixin:IsEnabled()
    return self.isEnabled
end

function DFSettingsCategoryElementMixin:SetEnabled(enabled)
    self.isEnabled = enabled
    self:UpdateState()
end

function DFSettingsCategoryElementMixin:SetSelected(selected)
    self.isSelected = selected
    self:UpdateState()
end

-- new feature label
DFSettingsNewFeatureLabelMixin = {};

function DFSettingsNewFeatureLabelMixin:OnLoad()
    self.BGLabel:SetText(self.label);
    self.Label:SetText(self.label);
    self.Label:SetJustifyH(self.justifyH);
    self.BGLabel:SetJustifyH(self.justifyH);
end

function DFSettingsNewFeatureLabelMixin:ClearAlert()
    -- derive
    self:SetShown(false);
end

function DFSettingsNewFeatureLabelMixin:OnShow()
    if self.animateGlow then self.Fade:Play(); end
end

function DFSettingsNewFeatureLabelMixin:OnHide()
    if self.animateGlow then self.Fade:Stop(); end
end
