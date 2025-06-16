---@diagnostic disable: redundant-parameter
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

DragonflightUICharacterStatsPanelMixin = CreateFromMixins(CallbackRegistryMixin);
DragonflightUICharacterStatsPanelMixin:GenerateCallbackEvents({"OnDefaults", "OnRefresh"});

function DragonflightUICharacterStatsPanelMixin:OnLoad()
    -- print('DragonflightUICharacterStatsPanelMixin:OnLoad()')
    CallbackRegistryMixin.OnLoad(self);

    self:SetupCollapsedDatabase()
    self:SetupScrollBox()

    self:RegisterEvent("PLAYER_ENTERING_WORLD");
    self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
    self:RegisterEvent("UNIT_AURA");
    self:RegisterEvent("PLAYER_DAMAGE_DONE_MODS");
    self:RegisterEvent("SKILL_LINES_CHANGED");
    self:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
    self:RegisterEvent("UNIT_DAMAGE");
    self:RegisterEvent("UNIT_ATTACK_SPEED");
    self:RegisterEvent("UNIT_RANGEDDAMAGE");
    self:RegisterEvent("UNIT_ATTACK");
    self:RegisterEvent("UNIT_RESISTANCES");
    self:RegisterEvent("UNIT_STATS");
    self:RegisterEvent("UNIT_MAXHEALTH");
    self:RegisterEvent("UNIT_ATTACK_POWER");
    self:RegisterEvent("UNIT_RANGED_ATTACK_POWER");
    self:RegisterEvent("COMBAT_RATING_UPDATE");
    self:RegisterEvent("VARIABLES_LOADED");

    -- @TODO HACK, maybe fix for ghost tooltips
    C_Timer.After(1, function()
        self:SetupStats() -- version specific mixin

        self:SetScript("OnUpdate", function(_, elapsed)
            self:OnUpdate(elapsed)
        end)

        self.LastUpdate = GetTime()
        self.ForceUpdate = true;
    end)
end

function DragonflightUICharacterStatsPanelMixin:OnEvent(event, arg1, arg2, arg3)
    -- print('~', event, arg1)
    self.ForceUpdate = true;
end

local updateInterval = 5;

function DragonflightUICharacterStatsPanelMixin:OnUpdate(elapsed)
    if self.ForceUpdate then
        -- print('~ForceUpdate!')
        self.LastUpdate = GetTime()
        self:CallRefresh()
        self.ForceUpdate = false;
        return
    end

    if GetTime() - self.LastUpdate >= updateInterval then
        self.LastUpdate = GetTime()
        -- print('self:OnUpdate')
        self:CallRefresh()
    end
end

function DragonflightUICharacterStatsPanelMixin:SetupCollapsedDatabase()
    self.db = DF.db:RegisterNamespace('CharacterStatsPanel', {profile = {collapsed = {}}})
end

function DragonflightUICharacterStatsPanelMixin:SetCategoryCollapsed(info, collapsed)
    -- print('SetRecipeFavorite', info, checked)
    local db = self.db.profile

    if collapsed then
        db.collapsed[info] = true
    else
        db.collapsed[info] = nil
    end
end

function DragonflightUICharacterStatsPanelMixin:IsCategoryCollapsed(info)
    -- print('IsRecipeFav', info)
    local db = self.db.profile

    if db.collapsed[info] then
        -- print('~true')
        return true
    else
        return false
    end
end

function DragonflightUICharacterStatsPanelMixin:SetupScrollBox()
    self.DataProvider = CreateTreeDataProvider();

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
                button.Toolbar:SetScript("OnMouseDown", function(_, _)
                    node:ToggleCollapsed();
                    button:SetCollapseState(node:IsCollapsed());
                    self:SetCategoryCollapsed(elementData.id, node:IsCollapsed())
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
                end);
            end
        end

        if elementData.categoryInfo then
            factory("DFCharacterStatsPanelHeader", Initializer);
        elseif elementData.elementInfo then
            factory("DFCharacterStatsStatTemplate", Initializer);
        elseif elementData.spacer then
            factory("DFCharacterStatsSpacer", Initializer);
        else
            print('~no factory: ', elementType, ' ~')
            factory("Frame");
        end
    end);

    self.ScrollView:SetDataProvider(self.DataProvider)

    local elementSize = DFSettingsListMixin.ElementSize;

    self.ScrollView:SetElementExtentCalculator(function(dataIndex, node)
        -- print('extend', dataIndex, node:GetData())
        local elementData = node:GetData();
        local baseElementHeight = 13;
        local baseHeaderHeight = 18;

        if elementData.elementInfo then return baseElementHeight; end

        if elementData.categoryInfo then
            return baseHeaderHeight;

            -- if node:IsCollapsed() then
            --     return baseHeaderHeight;
            -- else
            --     return 50
            -- end
        end

        return 4; -- spacer

        -- if elementData.dividerHeight then return elementData.dividerHeight; end

        -- if elementData.topPadding then return 1; end

        -- if elementData.bottomPadding then return 10; end
    end);

    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView);

    local scrollBoxAnchorsWithBar = {CreateAnchor("TOPLEFT", 4, -4), CreateAnchor("BOTTOMRIGHT", -16, 0)};
    -- local scrollBoxAnchorsWithoutBar = {scrollBoxAnchorsWithBar[1], CreateAnchor("BOTTOMRIGHT", 0, 0)};
    ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, scrollBoxAnchorsWithBar,
                                                     scrollBoxAnchorsWithBar);

    -- always show scroll 
    self.DataProvider:RegisterCallback("OnSizeChanged", function()
        --     
        self.ScrollBar:Show()
    end)
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

-- function DragonflightUICharacterStatsPanelMixin:AddDefaultCategorys()
--     self:RegisterCategory('general', {name = STAT_CATEGORY_GENERAL, descr = 'descr..', order = 1, isExpanded = false})
--     self:RegisterCategory('attributes',
--                           {name = STAT_CATEGORY_ATTRIBUTES, descr = 'descr..', order = 2, isExpanded = true})
--     self:RegisterCategory('melee', {name = STAT_CATEGORY_MELEE, descr = 'descr..', order = 3, isExpanded = true})
--     self:RegisterCategory('ranged', {name = STAT_CATEGORY_RANGED, descr = 'descr..', order = 4, isExpanded = true})
--     self:RegisterCategory('spell', {name = STAT_CATEGORY_SPELL, descr = 'descr..', order = 4, isExpanded = true})
--     self:RegisterCategory('defense', {name = STAT_CATEGORY_DEFENSE, descr = 'descr..', order = 4, isExpanded = true})
--     self:RegisterCategory('resistance',
--                           {name = STAT_CATEGORY_RESISTANCE, descr = 'descr..', order = 4, isExpanded = true})
-- end

function DragonflightUICharacterStatsPanelMixin:PaperDollFormatStat(name, base, posBuff, negBuff)
    -- print('PaperDollFormatStat', name, base, posBuff, negBuff)
    local frameText; -- df
    local tooltip; -- df
    local tooltip2; -- df

    local effective = max(0, base + posBuff + negBuff);
    local text = HIGHLIGHT_FONT_COLOR_CODE .. name .. " " .. effective;

    if ((posBuff == 0) and (negBuff == 0)) then
        text = text .. FONT_COLOR_CODE_CLOSE;
        frameText = effective;
    else
        if (posBuff > 0 or negBuff < 0) then text = text .. " (" .. base .. FONT_COLOR_CODE_CLOSE; end
        if (posBuff > 0) then
            text = text .. FONT_COLOR_CODE_CLOSE .. GREEN_FONT_COLOR_CODE .. "+" .. posBuff .. FONT_COLOR_CODE_CLOSE;
        end
        if (negBuff < 0) then text = text .. RED_FONT_COLOR_CODE .. " " .. negBuff .. FONT_COLOR_CODE_CLOSE; end
        if (posBuff > 0 or negBuff < 0) then
            text = text .. HIGHLIGHT_FONT_COLOR_CODE .. ")" .. FONT_COLOR_CODE_CLOSE;
        end

        -- if there is a negative buff then show the main number in red, even if there are
        -- positive buffs. Otherwise show the number in green
        if (negBuff < 0) then
            frameText = RED_FONT_COLOR_CODE .. effective .. FONT_COLOR_CODE_CLOSE;
        else
            frameText = GREEN_FONT_COLOR_CODE .. effective .. FONT_COLOR_CODE_CLOSE;
        end
    end
    tooltip = text;

    return frameText, tooltip, tooltip2
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

    local affectChildren = true;
    local skipSort = false;

    if sortComparator then
        node:SetSortComparator(sortComparator, affectChildren, skipSort)
    else
        local orderSortComparator = function(a, b)
            return b.data.order > a.data.order
        end
        node:SetSortComparator(orderSortComparator, affectChildren, skipSort)
    end
    node:Sort()

    local spacerData = {id = 'spacer', key = id .. '_' .. 'spacer', order = info.order + 0.1, spacer = true}
    dataProvider:Insert(spacerData)
end

function DragonflightUICharacterStatsPanelMixin:RegisterElement(id, categoryID, info)
    local dataProvider = self.DataProvider;

    local data = {
        id = id,
        categoryID = categoryID,
        key = categoryID .. '_' .. id,
        order = info.order or 99999,
        elementInfo = {name = info.name, descr = info.descr or '', func = info.func, hookOnUpdate = info.hookOnUpdate}
    }

    -- dataProvider:Insert(data)
    -- dataProvider:InsertInParentByPredicate(data, function(node)
    --     local nodeData = node:GetData()

    --     return nodeData.id == data.categoryID
    -- end)

    local parentNode = self.DataProvider:FindElementDataByPredicate(function(node)
        local d = node:GetData();
        return d.id == categoryID;
    end, false)
    if parentNode then
        parentNode:Insert(data)
        parentNode:Sort()
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
    -- print('DFCharacterStatsPanelHeaderMixin:OnLoad()')
end

function DFCharacterStatsPanelHeaderMixin:Init(node, ref)
    -- print('DFCharacterStatsPanelHeaderMixin:Init()')
    self.Node = node;
    local elementData = node:GetData();
    self.ElementData = elementData;
    -- print('DFSettingsCategoryHeaderMixin:Init()', elementData.categoryInfo.name)

    self.NameText:SetText(elementData.categoryInfo.name)
    self.Description = elementData.categoryInfo.descr

    -- local collapsed = not elementData.isExpanded;
    local collapsed = ref:IsCategoryCollapsed(elementData.id)
    if not collapsed then
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
        self.collapsed = true;
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

        local childNodes = self.Node:GetNodes();
        local numChilds = #childNodes - 1 + 1;
        local dy = 18 + (13 + 2) * numChilds + 4;

        if dy - 18 < 46 then
            self.BgBottom:SetHeight(dy - 18)
        else
            self.BgBottom:SetHeight(46)
        end

        -- self.BgBottom:ClearAllPoints()
        self.BgBottom:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, -dy)

        -- print('~children', #childNodes)
    end
end

-- stat
DFCharacterStatsStatTemplateMixin = {}

function DFCharacterStatsStatTemplateMixin:OnLoad()
    self.updateInterval = 0.2;
    self.LastUpdate = GetTime()
end

function DFCharacterStatsStatTemplateMixin:Init(node, _, skipHook)
    -- print('DFCharacterStatsStatTemplateMixin:Init()')
    local elementData = node:GetData();
    self.ElementData = elementData;

    self.Label:SetText(elementData.elementInfo.name .. ':')
    self.Description = elementData.elementInfo.descr

    self.Value:SetText('*VALUE*')

    if elementData.elementInfo.func then
        --
        local val, tt, tt2, tooltipTable = elementData.elementInfo.func()
        self.Value:SetText(val or '')
        self.tooltip = tt;
        self.tooltip2 = tt2;
        self.tooltipTable = tooltipTable;
        if (GameTooltip:GetOwner() == self) then self:OnEnter(); end
    end

    if skipHook then
        -- print('skiphook')
        return
    end

    if elementData.elementInfo.hookOnUpdate then
        -- print('hook!')
        self:SetScript("OnUpdate", function(_, elapsed)
            -- print('OnUpdate')
            if GetTime() - self.LastUpdate >= self.updateInterval then
                self.LastUpdate = GetTime()
                -- print('~~OnUpdate')
                self:Init(node, _, true)

                if (GameTooltip:GetOwner() == self) then self:OnEnter(); end
            end
        end)
    else
        self:SetScript('OnUpdate', nil);
    end
end

-- function DFCharacterStatsStatTemplateMixin:OnClick()
-- end

function DFCharacterStatsStatTemplateMixin:OnEnter()
    -- if (not self.tooltip) then return; end

    if self.tooltip then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetText(self.tooltip, 1.0, 1.0, 1.0);
        if (self.tooltip2) then
            GameTooltip:AddLine(self.tooltip2, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true);
        end
        GameTooltip:Show();

    else
        if self.tooltipTable then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT");

            for k, v in ipairs(self.tooltipTable) do
                --
                if k == 1 then
                    GameTooltip:SetText(v.left, 1.0, 1.0, 1.0);
                else
                    if v.right then
                        GameTooltip:AddDoubleLine(v.left, v.right, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g,
                                                  NORMAL_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g,
                                                  HIGHLIGHT_FONT_COLOR.b)
                    else
                        if v.white then
                            GameTooltip:AddLine(v.left, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g,
                                                HIGHLIGHT_FONT_COLOR.b)
                        else
                            GameTooltip:AddLine(v.left, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b,
                                                true)
                        end
                    end

                    -- print(k, v.left, v.right)
                end
            end
            GameTooltip:Show();
        end
    end

end

function DFCharacterStatsStatTemplateMixin:OnLeave()
    GameTooltip:Hide()
end

-- spacer

DFCharacterStatsSpacerMixin = {}

function DFCharacterStatsSpacerMixin:Init(node)
    -- print('DFCharacterStatsStatTemplateMixin:Init()')
    -- local elementData = node:GetData();
    -- self.ElementData = elementData;

    -- self.Label:SetText(elementData.elementInfo.name)
    -- self.Description = elementData.elementInfo.descr

    -- self.Value:SetText('*VALUE*')
end
