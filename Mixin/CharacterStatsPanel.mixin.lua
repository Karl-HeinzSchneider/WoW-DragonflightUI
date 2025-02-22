DragonflightUICharacterStatsPanelMixin = CreateFromMixins(CallbackRegistryMixin);
DragonflightUICharacterStatsPanelMixin:GenerateCallbackEvents({"OnDefaults", "OnRefresh"});

function DragonflightUICharacterStatsPanelMixin:OnLoad()
    print('DragonflightUICharacterStatsPanelMixin:OnLoad()')
    CallbackRegistryMixin.OnLoad(self);

    self:SetupScrollBox()
    self:AddDefaultCategorys()
end

function DragonflightUICharacterStatsPanelMixin:SetupScrollBox()
    self.DataProvider = CreateTreeDataProvider();

    local indent = 0;
    local verticalPad = 4;
    local padLeft, padRight = 1, 0;
    local spacing = 4;

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
                button:Init(n);
            end, button)
            self:RegisterCallback('OnRefresh', function(btn, message)
                --
                -- print(btn, message)
                button:Init(n);
            end, button)

            button:Init(n);

            if elementData.categoryInfo then
                button.Toolbar:SetScript("OnMouseDown", function(_, _)
                    node:ToggleCollapsed();
                    button:SetCollapseState(node:IsCollapsed());
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
                end);
            end
        end

        if elementData.categoryInfo then
            factory("DFCharacterStatsPanelHeader", Initializer);
        elseif elementData.elementInfo then
            -- factory("DFCharacterStatsPanelHeader", Initializer);
        else
            print('~no factory: ', elementType, ' ~')
            factory("Frame");
        end
    end);

    self.ScrollView:SetDataProvider(self.DataProvider)

    local elementSize = DFSettingsListMixin.ElementSize;

    self.ScrollView:SetElementExtentCalculator(function(dataIndex, node)
        print('extend', dataIndex, node:GetData())
        local elementData = node:GetData();
        local baseElementHeight = 20;
        local baseHeaderHeight = 18;

        if elementData.elementInfo then return baseElementHeight; end

        if elementData.categoryInfo then
            if node:IsCollapsed() then
                return baseHeaderHeight;
            else
                return 50
            end
        end

        if elementData.dividerHeight then return elementData.dividerHeight; end

        if elementData.topPadding then return 1; end

        if elementData.bottomPadding then return 10; end
    end);

    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView);

    local scrollBoxAnchorsWithBar = {CreateAnchor("TOPLEFT", 4, -4), CreateAnchor("BOTTOMRIGHT", -16, 0)};
    local scrollBoxAnchorsWithoutBar = {scrollBoxAnchorsWithBar[1], CreateAnchor("BOTTOMRIGHT", 0, 0)};
    ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, scrollBoxAnchorsWithBar,
                                                     scrollBoxAnchorsWithoutBar);
end

function DragonflightUICharacterStatsPanelMixin:FlushDisplay()
    self.DataProvider = CreateTreeDataProvider();
    self.ScrollView:SetDataProvider(self.DataProvider)
end

function DragonflightUICharacterStatsPanelMixin:CallRefresh()
    -- print('refresh!');
    -- self:Display(self.Args_Data, self.Args_Data);
    self:TriggerEvent(DragonflightUICharacterStatsPanelMixin.Event.OnRefresh, true)
end

-- function DragonflightUICharacterStatsPanelMixin:Display(data, small)
--     -- self.DataProvider:Flush()
--     -- self.DataProvider = CreateTreeDataProvider()
--     -- self.ScrollView:SetDataProvider(self.DataProvider)

--     self.Args_Data = data;
--     self.Args_Small = small;

--     self.DataProvider = CreateTreeDataProvider();
--     local affectChildren = true;
--     local skipSort = true;

--     if data.sortComparator then
--         self.DataProvider:SetSortComparator(data.sortComparator, false, false)
--     else
--         self.DataProvider:SetSortComparator(DFSettingsListMixin.OrderSortComparator, false, false)
--     end

--     if not data then
--         print('DragonflightUICharacterStatsPanelMixin:Display', 'no data')
--         return
--     end

--     local getFunc;
--     local setFunc;

--     local sub = data.sub;

--     if sub then
--         getFunc = function(info)
--             -- print('subGet', info[1])
--             local newInfo = {}
--             newInfo[1] = sub
--             newInfo[2] = info[1]
--             return data.options.get(newInfo)
--         end
--         setFunc = function(info, value)
--             local newInfo = {}
--             newInfo[1] = sub
--             newInfo[2] = info[1]
--             return data.options.set(newInfo, value)
--         end
--     else
--         getFunc = data.options.get;
--         setFunc = data.options.set;
--     end

--     -- first pass ~> categorys
--     for k, v in pairs(data.options.args) do
--         --

--         if v.type == 'header' then
--             -- print('header', k)
--             local elementData = {key = k, order = (v.order or 9999), name = (v.name or ''), args = v, small = small}
--             local node = self.DataProvider:Insert(elementData);

--             -- local affectChildren = true;
--             -- local skipSort = false;
--             if v.sortComparator then
--                 node:SetSortComparator(v.sortComparator, true, false)
--             else
--                 node:SetSortComparator(DFSettingsListMixin.OrderSortComparator, true, false)
--             end
--             -- node:SetSortComparator(self.sortComparator, true, false)
--         end
--     end

--     -- second pass ~> elements
--     for k, v in pairs(data.options.args) do
--         --

--         if v.type == 'header' then
--             -- already done
--         else
--             local elementData = {
--                 key = k,
--                 order = (v.order or 9999),
--                 name = (v.name or ''),
--                 args = v,
--                 get = getFunc,
--                 set = setFunc,
--                 small = small
--             }
--             local group = v.group or '*NOGROUP*'

--             if group == '*NOGROUP*' then
--                 -- just append  @TODO
--                 -- print('~~ NOGROUP', k)
--                 self.DataProvider:Insert(elementData);
--             else

--                 self.DataProvider:InsertInParentByPredicate(elementData, function(node)
--                     local nodeData = node:GetData()
--                     return nodeData.key == group;
--                 end)

--                 -- local oldNode = self.DataProvider:FindElementDataByPredicate(function(node)
--                 --     local nodeData = node:GetData();
--                 --     return nodeData.key == group;
--                 -- end, false)

--                 -- elementData.args.desc = 'order:' .. elementData.order .. ', group: ' .. group

--                 -- if oldNode then
--                 --     print('~~ oldNode', k)
--                 --     oldNode:Insert(elementData)
--                 --     oldNode:Sort()
--                 -- else
--                 --     -- @TODO but shouldnt happen
--                 --     print('else?!?!!?')
--                 -- end
--             end
--         end

--     end

--     self.ScrollView:SetDataProvider(self.DataProvider)
-- end

function DragonflightUICharacterStatsPanelMixin:AddDefaultCategorys()
    -- list:RegisterCategory('general', {name = 'General', descr = 'descr..', order = 1, isExpanded = true},
    --                       alphaSortComparator, true)

    self:RegisterCategory('general', {name = 'General', descr = 'descr..', order = 1, isExpanded = true})
    self:RegisterCategory('attributes', {name = 'Attributes', descr = 'descr..', order = 2, isExpanded = true})
    self:RegisterCategory('melee', {name = 'Melee', descr = 'descr..', order = 3, isExpanded = true})
    self:RegisterCategory('ranged', {name = 'Ranged', descr = 'descr..', order = 4, isExpanded = true})
    self:RegisterCategory('spell', {name = 'Spell', descr = 'descr..', order = 4, isExpanded = true})
    self:RegisterCategory('defense', {name = 'Defense', descr = 'descr..', order = 4, isExpanded = true})
    self:RegisterCategory('resistance', {name = 'Resistance', descr = 'descr..', order = 4, isExpanded = true})
end

function DragonflightUICharacterStatsPanelMixin:RegisterCategory(id, info, sortComparator)
    local dataProvider = self.DataProvider;

    local data = {
        id = id,
        order = info.order or 666,
        isExpanded = info.isExpanded or true,
        categoryInfo = {name = info.name, isExpanded = true, descr = info.descr or ''}
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

-- expand button
DragonflightUICharacterFrameExpandButtonMixin = {}

function DragonflightUICharacterFrameExpandButtonMixin:OnLoad()
    self:SetFrameLevel(self:GetParent():GetFrameLevel() + 2);

    self.collapseTooltip = STATS_COLLAPSE_TOOLTIP;
    self.expandTooltip = STATS_EXPAND_TOOLTIP;

    self:AddCharacterFrameFunctions()
end

function DragonflightUICharacterFrameExpandButtonMixin:OnClick()
    if (CharacterFrame.Expanded) then
        -- SetCVar("characterFrameCollapsed", "1");
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE);
        CharacterFrame:Collapse();
    else
        -- SetCVar("characterFrameCollapsed", "0");
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN);
        CharacterFrame:Expand();
    end
    if (GameTooltip:GetOwner() == self) then self:GetScript("OnEnter")(self); end
end

function DragonflightUICharacterFrameExpandButtonMixin:OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    if (CharacterFrame.Expanded) then
        GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE .. self.collapseTooltip .. FONT_COLOR_CODE_CLOSE);
    else
        GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE .. self.expandTooltip .. FONT_COLOR_CODE_CLOSE);
    end
end

function DragonflightUICharacterFrameExpandButtonMixin:OnLeave()
    GameTooltip:Hide();
end

function DragonflightUICharacterFrameExpandButtonMixin:AddCharacterFrameFunctions()
    function CharacterFrame:Collapse()
        self.Expanded = false;
        CharacterFrame:DFUpdateFrameWidth(false);
        -- characterFrameDisplayInfo["Default"].width = PANEL_DEFAULT_WIDTH;
        -- characterFrameDisplayInfo["PetPaperDollFrame"].width = PANEL_DEFAULT_WIDTH;
        self.DFExpandButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up");
        self.DFExpandButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down");
        self.DFExpandButton:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled");
        -- for i = 1, #PAPERDOLL_SIDEBARS do GetPaperDollSideBarFrame(i):Hide(); end
        self.DFInsetRight:Hide();
        -- PaperDollFrame_SetLevel();
        -- self:RefreshDisplay();
    end

    function CharacterFrame:Expand()
        self.Expanded = true;
        CharacterFrame:DFUpdateFrameWidth(true);
        -- characterFrameDisplayInfo["Default"].width = CHARACTERFRAME_EXPANDED_WIDTH;
        -- characterFrameDisplayInfo["PetPaperDollFrame"].width = CHARACTERFRAME_EXPANDED_WIDTH;
        self.DFExpandButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up");
        self.DFExpandButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down");
        self.DFExpandButton:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled");
        -- if (PaperDollFrame:IsShown() and PaperDollFrame.currentSideBar) then
        --     PaperDollFrame.currentSideBar:Show();
        -- else
        --     CharacterStatsPane:Show();
        -- end
        -- PaperDollFrame_UpdateSidebarTabs();
        self.DFInsetRight:Show();
        -- PaperDollFrame_SetLevel();
        -- self:RefreshDisplay();
    end
end

DFCharacterStatsPanelHeaderMixin = {}

function DFCharacterStatsPanelHeaderMixin:OnLoad()
    print('DFCharacterStatsPanelHeaderMixin:OnLoad()')
end

function DFCharacterStatsPanelHeaderMixin:Init(node)
    -- print('DFCharacterStatsPanelHeaderMixin:Init()')
    local elementData = node:GetData();
    self.ElementData = elementData;
    -- print('DFSettingsCategoryHeaderMixin:Init()', elementData.categoryInfo.name)

    self.NameText:SetText(elementData.categoryInfo.name)
    self.Description = elementData.categoryInfo.descr

    if elementData.isExpanded then
        node:SetCollapsed(false, true, false)
    else
        node:SetCollapsed(true, true, false)
    end

    self:SetCollapseState(node:IsCollapsed());
end

function DFCharacterStatsPanelHeaderMixin:SetCollapseState(collapsed)
    -- print('DFCharacterStatsPanelHeaderMixin:SetCollapseState(collapsed)', collapsed)
    if collapsed then
        -- self.CollapseIcon:SetTexCoord(0.302246, 0.312988, 0.0537109, 0.0693359)
        -- self.CollapseIconAlphaAdd:SetTexCoord(0.302246, 0.312988, 0.0537109, 0.0693359)
        -- self.Background:Show()
        self.CollapsedIcon:Show();
        self.ExpandedIcon:Hide();
        -- self:SetHeight(18);
        -- PaperDollFrame_UpdateStatScrollChildHeight();
        self.BgMinimized:Show();
        self.BgTop:Hide();
        self.BgMiddle:Hide();
        self.BgBottom:Hide();
    else
        -- self.CollapseIcon:SetTexCoord(0.270508, 0.28125, 0.0537109, 0.0693359)
        -- self.CollapseIconAlphaAdd:SetTexCoord(0.270508, 0.28125, 0.0537109, 0.0693359)
        -- self.Background:Hide() -- TODO
        self.collapsed = false;
        self.CollapsedIcon:Hide();
        self.ExpandedIcon:Show();
        -- PaperDollFrame_UpdateStatCategory(categoryFrame);
        -- PaperDollFrame_UpdateStatScrollChildHeight();
        self.BgMinimized:Hide();
        self.BgTop:Show();
        self.BgMiddle:Show();
        self.BgBottom:Show();
    end
end
