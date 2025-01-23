--
DFSettingsCategoryListMixin = CreateFromMixins(CallbackRegistryMixin);
DFSettingsCategoryListMixin:GenerateCallbackEvents({"OnSelectionChanged"});

function DFSettingsCategoryListMixin:OnLoad()
    print('DFSettingsCategoryListMixin:OnLoad()')
    CallbackRegistryMixin.OnLoad(self)

    self.DataProvider = CreateTreeDataProvider();

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
                    -- node:ToggleCollapsed();
                    -- button:SetCollapseState(node:IsCollapsed());
                    -- PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
                end);
            end
            factory("DFSettingsCategoryHeader", Initializer);
        elseif elementData.elementInfo then
            local function Initializer(button, node)
                button:Init(node, false);

                -- if elementData.id == self.selectedSkill then self.selectionBehavior:Select(button) end
                -- local selected = self.selectionBehavior:IsElementDataSelected(node);
                -- button:SetSelected(selected);

                -- button:SetScript("OnClick", function(button, buttonName, down)
                --     -- self.selectionBehavior:Select(button);
                --     -- PlaySound(SOUNDKIT.UI_90_BLACKSMITHING_TREEITEMCLICK);
                --     -- PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
                -- end);

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

    local function OnSelectionChanged(o, elementData, selected)
        -- print('OnSelectionChanged', o, elementData, selected)
        local button = self.ScrollBox:FindFrame(elementData);
        if button then button:SetSelected(selected); end

        -- if selected then
        --     local data = elementData:GetData();

        --     -- TradeSkillSkillButton_OnClick(test, 'LeftButton')

        --     local newRecipeID = data.id
        --     local changed = data.id ~= self.selectedSkill
        --     if changed then
        --         -- print('OnSelectionChanged-changed', data.id)
        --         self.selectedSkill = newRecipeID
        --         EventRegistry:TriggerEvent("DFProfessionsRecipeListMixin.Event.OnRecipeSelected", newRecipeID, self);

        --         TradeSkillFrame_SetSelection(newRecipeID)
        --         self:SelectRecipe(newRecipeID, false)
        --         -- if newRecipeID then self.previousRecipeID = newRecipeID; end
        --     end
        -- end
    end

    self.selectionBehavior = ScrollUtil.AddSelectionBehavior(self.ScrollBox);
    self.selectionBehavior:RegisterCallback(SelectionBehaviorMixin.Event.OnSelectionChanged, OnSelectionChanged, self);

    self:RegisterDefaultCategorys()
    self:RegisterDefaultElements()
end

function DFSettingsCategoryListMixin:RegisterCategory(id, info, isDragonflight)
    local dataProvider = self.DataProvider;

    local data = {
        id = id,
        categoryInfo = {
            name = info.name,
            isExpanded = true,
            descr = info.descr or '',
            isNew = info.isNew or false,
            isDragonflight = isDragonflight or false
        }
    }

    dataProvider:Insert(data)
end

function DFSettingsCategoryListMixin:RegisterDefaultCategorys()
    self:RegisterCategory('general', {name = 'General', descr = 'descr..'}, true)
    self:RegisterCategory('actionbar', {name = 'Action Bar', descr = 'descr..'}, true)
    self:RegisterCategory('castbar', {name = 'Cast Bar', descr = 'descr..'}, true)
    self:RegisterCategory('misc', {name = 'Misc', descr = 'descr..'}, true)
    self:RegisterCategory('unitframes', {name = 'Unitframes', descr = 'descr..'}, true)
end

function DFSettingsCategoryListMixin:RegisterElement(id, info)
    local dataProvider = self.DataProvider;

    local data = {
        id = id,
        categoryID = info.categoryID,
        isEnabled = info.isEnabled or false,
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

function DFSettingsCategoryListMixin:RegisterDefaultElements()
    -- general
    self:RegisterElement('info', {categoryID = 'general', name = 'Info', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('modules', {categoryID = 'general', name = 'Modules', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('profiles', {categoryID = 'general', name = 'Profiles', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('whatsnew', {categoryID = 'general', name = 'Whatsnew', descr = 'Infostuff', module = 'global'})

    -- actionbar
    self:RegisterElement('actionbar1',
                         {categoryID = 'actionbar', name = 'Actionbar1', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('actionbar2',
                         {categoryID = 'actionbar', name = 'Actionbar2', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('actionbar3',
                         {categoryID = 'actionbar', name = 'Actionbar3', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('actionbar4',
                         {categoryID = 'actionbar', name = 'Actionbar4', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('actionbar5',
                         {categoryID = 'actionbar', name = 'Actionbar5', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('actionbar6',
                         {categoryID = 'actionbar', name = 'Actionbar6', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('actionbar7',
                         {categoryID = 'actionbar', name = 'Actionbar7', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('actionbar8',
                         {categoryID = 'actionbar', name = 'Actionbar8', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('petbar', {categoryID = 'actionbar', name = 'Petbar', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('xpbar', {categoryID = 'actionbar', name = 'XPbar', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('repbar', {categoryID = 'actionbar', name = 'Repbar', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('possessbar',
                         {categoryID = 'actionbar', name = 'Possessbar', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('stancebar',
                         {categoryID = 'actionbar', name = 'Stancebar', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('totembar',
                         {categoryID = 'actionbar', name = 'Totembar', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('bags', {categoryID = 'actionbar', name = 'Bags', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('micromenu',
                         {categoryID = 'actionbar', name = 'Micromenu', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('fps',
                         {categoryID = 'actionbar', name = 'FPS', descr = 'Infostuff', module = 'global', isNew = true})

    -- castbar
    self:RegisterElement('focus', {categoryID = 'castbar', name = 'Focus', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('player', {categoryID = 'castbar', name = 'Player', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('target', {categoryID = 'castbar', name = 'Target', descr = 'Infostuff', module = 'global'})

    -- misc
    self:RegisterElement('buffs', {categoryID = 'misc', name = 'Buffs', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('chat', {categoryID = 'misc', name = 'Chat', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('darkmode',
                         {categoryID = 'misc', name = 'Darkmode', descr = 'Infostuff', module = 'global', isNew = true})
    self:RegisterElement('debuffs', {categoryID = 'misc', name = 'Debuffs', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('durability', {
        categoryID = 'misc',
        name = 'Durability',
        descr = 'Infostuff',
        module = 'global',
        isNew = true
    })
    self:RegisterElement('minimap', {categoryID = 'misc', name = 'Minimap', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('questtracker',
                         {categoryID = 'misc', name = 'Questtracker', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('ui', {categoryID = 'misc', name = 'UI', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('utility', {categoryID = 'misc', name = 'Utility', descr = 'Infostuff', module = 'global'})

    -- unitframes
    self:RegisterElement('boss', {categoryID = 'unitframes', name = 'Boss', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('focus', {categoryID = 'unitframes', name = 'Focus', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('party', {categoryID = 'unitframes', name = 'Party', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('pet', {categoryID = 'unitframes', name = 'Pet', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('player', {categoryID = 'unitframes', name = 'Player', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('raid', {categoryID = 'unitframes', name = 'Raid', descr = 'Infostuff', module = 'global'})
    self:RegisterElement('target', {categoryID = 'unitframes', name = 'Target', descr = 'Infostuff', module = 'global'})
end

-- Header
DFSettingsCategoryHeaderMixin = {}

function DFSettingsCategoryHeaderMixin:OnLoad()
    -- print('DFSettingsCategoryHeaderMixin:OnLoad()')
    self.Background:SetAtlas('Options_CategoryHeader_1', true)
end

function DFSettingsCategoryHeaderMixin:Init(node)
    local elementData = node:GetData();
    self.ElementData = elementData;
    -- print('DFSettingsCategoryHeaderMixin:Init()', elementData.categoryInfo.name)

    self.Label:SetText(elementData.categoryInfo.name)
    self.Description = elementData.categoryInfo.descr
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
end

function DFSettingsCategoryElementMixin:OnLeave()
    -- print(self:GetName(), 'OnLeave')
    if ButtonStateBehaviorMixin.OnLeave(self) then self:UpdateState(); end
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
