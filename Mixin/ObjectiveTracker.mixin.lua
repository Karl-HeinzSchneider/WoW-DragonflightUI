local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

DragonflightUIObjectiveTrackerMixin = CreateFromMixins(CallbackRegistryMixin);
DragonflightUIObjectiveTrackerMixin:GenerateCallbackEvents({"OnDefaults", "OnRefresh"});

function DragonflightUIObjectiveTrackerMixin:OnLoad()
    CallbackRegistryMixin.OnLoad(self);

    self:SetupCollapsedDatabase()

    self.DataProvider = CreateTreeDataProvider();
    self.sortComparator = DFSettingsListMixin.OrderSortComparator
    local affectChildren = true;
    local skipSort = true;
    self.DataProvider:SetSortComparator(self.sortComparator, affectChildren, skipSort)

    local indent = 0;
    local verticalPad = 4;
    local padLeft, padRight = 1, 0;
    local spacing = 2;

    self.ScrollView = CreateScrollBoxListTreeListView(indent, verticalPad, verticalPad, padLeft, padRight, spacing);
    self.ScrollView:SetElementFactory(function(factory, node)
        -- DevTools_Dump(node)
        local elementData = node:GetData();

        local function Initializer(button, n)
            self:UnregisterCallback('OnDefaults', button);
            self:UnregisterCallback('OnRefresh', button);

            self:RegisterCallback('OnDefaults', function(btn, message)
                --
                -- print(btn, message)
                button:Init(n, self);
            end, button)
            self:RegisterCallback('OnRefresh', function(btn, message)
                --
                -- print(btn, message)
                button:Init(n, self);
            end, button)

            button:Init(n, self);

            if elementData.categoryInfo then
                button.MinimizeButton:SetScript("OnClick", function(_, _)
                    -- print('onclick')
                    node:ToggleCollapsed();
                    button:SetCollapseState(node:IsCollapsed());
                    self:SetCategoryCollapsed(elementData.id, node:IsCollapsed())
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
                end);
            end
        end

        if elementData.categoryInfo then
            factory("DFObjectiveTrackerElementHeader", Initializer);
        elseif elementData.elementInfo then
            factory("DFObjectiveTrackerElementHeaderDefaulkt", Initializer);
        else
            print('~no factory: ', elementType, ' ~')
            factory("Frame");
        end
    end);

    self.ScrollView:SetDataProvider(self.DataProvider)

    self.ScrollView:SetElementExtentCalculator(function(dataIndex, node)
        local elementData = node:GetData();

        local baseElementHeight = 20;
        local baseHeaderHeight = 26;

        if elementData.elementInfo then return baseElementHeight; end

        if elementData.categoryInfo then return baseHeaderHeight; end
    end);

    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView);

    local scrollBoxAnchors = {
        -- CreateAnchor("TOPLEFT", self.Header, "BOTTOMLEFT", -15, -2), CreateAnchor("BOTTOMRIGHT", -20, -2)
        CreateAnchor("TOPLEFT", self.Header, "BOTTOMLEFT", 0, -2), CreateAnchor("BOTTOMRIGHT", 0, -2)
    };
    ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, scrollBoxAnchors, scrollBoxAnchors);
end

function DragonflightUIObjectiveTrackerMixin:OnShow()
    self:UpdateList()
end

function DragonflightUIObjectiveTrackerMixin:OnEvent()
    self:UpdateList()
end

function DragonflightUIObjectiveTrackerMixin:FlushDisplay()
    self.DataProvider = CreateTreeDataProvider();
    self.ScrollView:SetDataProvider(self.DataProvider)
end

function DragonflightUIObjectiveTrackerMixin:CallRefresh()
    -- print('refresh!');
    -- self:Display(self.Args_Data, self.Args_Data);
    self:TriggerEvent(DragonflightUIObjectiveTrackerMixin.Event.OnRefresh, true)
end

function DragonflightUIObjectiveTrackerMixin:SetupCollapsedDatabase()
    self.db = DF.db:RegisterNamespace('DFObjectiveTracker', {profile = {collapsed = {}}})
end

function DragonflightUIObjectiveTrackerMixin:SetCategoryCollapsed(info, collapsed)
    -- print('SetRecipeFavorite', info, checked)
    local db = self.db.profile

    if collapsed then
        db.collapsed[info] = true
    else
        db.collapsed[info] = nil
    end
end

function DragonflightUIObjectiveTrackerMixin:IsCategoryCollapsed(info)
    -- print('IsRecipeFav', info)
    local db = self.db.profile

    if db.collapsed[info] then
        -- print('~true')
        return true
    else
        return false
    end
end

function DragonflightUIObjectiveTrackerMixin:UpdateList()
    print('DragonflightUIObjectiveTrackerMixin:UpdateList()')
    local dataProvider = CreateTreeDataProvider();

    do
        local data = {id = 0, categoryInfo = {name = 'Favorites', isExpanded = true}}
        dataProvider:Insert(data)
    end

    do
        local data = {id = 1, categoryInfo = {name = 'Quests', isExpanded = true}}
        dataProvider:Insert(data)
    end

    -- DevTools_Dump(dataProvider)

    local nodes = dataProvider:GetChildrenNodes()
    local nodesToRemove = {}
    -- print('NODES', #nodes)

    for k, child in ipairs(nodes) do
        --
        local numChildNodes = #child:GetNodes()
        -- print('numChildNodes', numChildNodes)
        if numChildNodes < 1 then
            --
            -- print('remove node')
            -- dataProvider:Remove(child)
            table.insert(nodesToRemove, child)
        end
    end

    for k, node in ipairs(nodesToRemove) do
        --
        -- print('to remove', k, node)
        -- dataProvider:Remove(node)
    end

    -- print('UpdateRecipeList()', numSkills, dataProvider:GetSize(false))
    self.ScrollBox:SetDataProvider(dataProvider);
end

-- function DragonflightUIObjectiveTrackerMixin:RegisterCategory(id, info, sortComparator, isDragonflight)
--     local dataProvider = self.DataProvider;

--     local data = {
--         id = id,
--         order = info.order or 666,
--         isExpanded = info.isExpanded or true,
--         categoryInfo = {
--             name = info.name,
--             isExpanded = true,
--             descr = info.descr or '',
--             isNew = info.isNew or false,
--             isDragonflight = isDragonflight or false
--         }
--     }

--     local node = dataProvider:Insert(data)

--     local affectChildren = false;
--     local skipSort = true;

--     if sortComparator then
--         node:SetSortComparator(sortComparator, affectChildren, skipSort)
--     else
--         local orderSortComparator = function(a, b)
--             return b.data.order > a.data.order
--         end
--         node:SetSortComparator(orderSortComparator, affectChildren, skipSort)
--     end
--     node:Sort()
-- end

-- function DragonflightUIObjectiveTrackerMixin:RegisterElement(id, categoryID, info)
--     local dataProvider = self.DataProvider;

--     local data = {
--         id = id,
--         categoryID = categoryID,
--         key = categoryID .. '_' .. id,
--         isEnabled = info.isEnabled,
--         order = info.order or 99999,
--         elementInfo = {
--             name = info.name,
--             descr = info.descr or '',
--             module = info.module or '*moduleXY*',
--             isNew = info.isNew or false
--         }
--     }

--     local parentNode = self.DataProvider:FindElementDataByPredicate(function(node)
--         local d = node:GetData();
--         return d.id == categoryID;
--     end, false)
--     if parentNode then
--         parentNode:Insert(data)
--         parentNode:Sort()
--     end
-- end

--
DFObjectiveTrackerContainerHeaderMixin = {}

function DFObjectiveTrackerContainerHeaderMixin:OnLoad()
    local tex = base .. 'questtracker2x'
    self.Text:SetText('All Objectives')

    self.Background:SetTexture(tex)
    self.Background:SetTexCoord(0.000976562, 0.586914, 0.470703, 0.626953)
    self.Background:SetSize(300, 40)

    self.MinimizeButton:SetNormalTexture(tex)
    self.MinimizeButton:GetNormalTexture():SetTexCoord(0.928711, 0.963867, 0.115234, 0.189453)
    self.MinimizeButton:SetPushedTexture(tex)
    self.MinimizeButton:GetPushedTexture():SetTexCoord(0.883789, 0.918945, 0.236328, 0.310547)
    self.MinimizeButton:SetHighlightTexture(tex, 'ADD')
    self.MinimizeButton:GetHighlightTexture():SetTexCoord(0.920898, 0.956055, 0.314453, 0.388672)
end

-- element-header
DFObjectiveTrackerElementHeaderMixin = {}

function DFObjectiveTrackerElementHeaderMixin:OnLoad()
    local tex = base .. 'questtracker2x'
    -- self.Text:SetText('All Objectives')

    self.Background:SetTexture(tex)
    self.Background:SetTexCoord(0.000976562, 0.586914, 0.630859, 0.748047)
    self.Background:SetSize(300, 30)

    self.MinimizeButton:SetNormalTexture(tex)
    self.MinimizeButton:GetNormalTexture():SetTexCoord(0.96582, 0.99707, 0.115234, 0.177734)
    self.MinimizeButton:SetPushedTexture(tex)
    self.MinimizeButton:GetPushedTexture():SetTexCoord(0.920898, 0.952148, 0.392578, 0.455078)
    self.MinimizeButton:SetHighlightTexture(tex, 'ADD')
    self.MinimizeButton:GetHighlightTexture():SetTexCoord(0.588867, 0.620117, 0.470703, 0.533203)
end

function DFObjectiveTrackerElementHeaderMixin:Init(node, ref)
    -- print('DFCharacterStatsPanelHeaderMixin:Init()')
    self.Node = node;
    local elementData = node:GetData();
    self.ElementData = elementData;
    -- print('DFSettingsCategoryHeaderMixin:Init()', elementData.categoryInfo.name)

    self.Text:SetText(elementData.categoryInfo.name)
    -- self.Description = elementData.categoryInfo.descr

    -- local collapsed = not elementData.isExpanded;
    local collapsed = ref:IsCategoryCollapsed(elementData.id)
    if not collapsed then
        node:SetCollapsed(false, true, false)
    else
        node:SetCollapsed(true, true, false)
    end

    self:SetCollapseState(node:IsCollapsed());
end

function DFObjectiveTrackerElementHeaderMixin:SetCollapseState(collapsed)
    local tex = base .. 'questtracker2x'

    if collapsed then
        self.MinimizeButton:SetNormalTexture(tex)
        self.MinimizeButton:GetNormalTexture():SetTexCoord(0.958008, 0.989258, 0.314453, 0.376953)
        self.MinimizeButton:SetPushedTexture(tex)
        self.MinimizeButton:GetPushedTexture():SetTexCoord(0.958008, 0.989258, 0.380859, 0.443359)
    else
        self.MinimizeButton:SetNormalTexture(tex)
        self.MinimizeButton:GetNormalTexture():SetTexCoord(0.96582, 0.99707, 0.115234, 0.177734)
        self.MinimizeButton:SetPushedTexture(tex)
        self.MinimizeButton:GetPushedTexture():SetTexCoord(0.920898, 0.952148, 0.392578, 0.455078)
    end

    -- if true then return end

    -- local atlas = collapsed and "Professions-recipe-header-expand" or "Professions-recipe-header-collapse";
    -- self.CollapseIcon:SetAtlas(atlas, TextureKitConstants.UseAtlasSize);
    -- self.CollapseIconAlphaAdd:SetAtlas(atlas, TextureKitConstants.UseAtlasSize);
end
