DragonFlightUIProfessionMixin = {}
local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

function DragonFlightUIProfessionMixin:OnLoad()
    self:SetupFrameStyle()
end

function DragonFlightUIProfessionMixin:OnShow()
    self:UpdateHeader()
end

function DragonFlightUIProfessionMixin:OnHide()

end

function DragonFlightUIProfessionMixin:OnEvent()

end

function DragonFlightUIProfessionMixin:SetupFrameStyle()
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(self)
    DragonflightUIMixin:MaximizeMinimizeButtonFrameTemplate(self.MinimizeButton)
    self.MinimizeButton:ClearAllPoints()
    self.MinimizeButton:SetPoint('RIGHT', self.ClosePanelButton, 'LEFT', 0, 0)

    local icon = self:CreateTexture('DragonflightUIProfessionIcon')
    icon:SetSize(62, 62)
    icon:SetPoint('TOPLEFT', self, 'TOPLEFT', -5, 7)
    icon:SetDrawLayer('OVERLAY', 6)
    self.Icon = icon

    local pp = self:CreateTexture('DragonflightUIProfessionoIconFrame')
    pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
    pp:SetTexCoord(0.0078125, 0.0078125, 0.0078125, 0.6171875, 0.6171875, 0.0078125, 0.6171875, 0.6171875)
    pp:SetSize(84, 84)
    pp:SetPoint('CENTER', icon, 'CENTER', 0, 0)
    pp:SetDrawLayer('OVERLAY', 7)
    self.PortraitFrame = pp
end

function DragonFlightUIProfessionMixin:AnchorButtons()
    local create = TradeSkillCreateButton
    create:ClearAllPoints()
    create:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -9, 7)

    local createAll = TradeSkillCreateAllButton
    local input = TradeSkillInputBox

    local rankFrame = TradeSkillRankFrame
    rankFrame:ClearAllPoints()
    rankFrame:SetPoint('TOPLEFT', self, 'TOPLEFT', 280, -40)
    -- ProfessionsRankBarTemplate
    -- <Size x="453" y="18"/>
    rankFrame:SetSize(453, 18)

    local rankFrameBorder = TradeSkillRankFrameBorder
    -- rankFrameText:SetPoint('CENTER', rankFrame, 'CENTER', 0, 0)
    rankFrameBorder:SetSize(453 + 10, 18)
    rankFrameBorder:Hide()

    local rankFrameText = TradeSkillRankFrameSkillRank
    rankFrameText:ClearAllPoints()
    rankFrameText:SetPoint('CENTER', rankFrame, 'CENTER', 0, 0)
end

function DragonFlightUIProfessionMixin:UpdateHeader()
    self.NineSlice.Text:SetText('Enchanting')
    self.Icon:SetTexture(136244)
    SetPortraitToTexture(self.Icon, self.Icon:GetTexture())

end

------------------------------

DFProfessionsRecipeListMixin = CreateFromMixins(CallbackRegistryMixin);
DFProfessionsRecipeListMixin:GenerateCallbackEvents({"OnRecipeSelected"});

function DFProfessionsRecipeListMixin:OnLoad()
    print('DFProfessionsRecipeListMixin:OnLoad()')
    CallbackRegistryMixin.OnLoad(self);

    self.DataProvider = CreateTreeDataProvider()

    local indent = 10;
    local padLeft = 0;
    local pad = 5;
    local spacing = 1;
    local view = CreateScrollBoxListTreeListView(indent, pad, pad, padLeft, pad, spacing);
    self.View = view

    view:SetElementFactory(function(factory, node)
        local elementData = node:GetData();
        if elementData.categoryInfo then
            local function Initializer(button, node)
                button:Init(node);

                button:SetScript("OnClick", function(button, buttonName)
                    node:ToggleCollapsed();
                    button:SetCollapseState(node:IsCollapsed());
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)

                    if elementData.categoryInfo.isExpanded then
                        CollapseTradeSkillSubClass(elementData.categoryInfo.id)
                    else
                        ExpandTradeSkillSubClass(elementData.categoryInfo.id)
                    end
                end);
                --[[ 
                button:SetScript("OnEnter", function()
                    EventRegistry:TriggerEvent("ProfessionsDebug.CraftingRecipeListCategoryEntered", button,
                                               elementData.categoryInfo);
                    ProfessionsRecipeListCategoryMixin.OnEnter(button);
                end); ]]
            end
            factory("ProfessionsRecipeListCategoryTemplate", Initializer);
        elseif elementData.recipeInfo then
            local function Initializer(button, node)
                button:Init(node, false);

                local selected = self.selectionBehavior:IsElementDataSelected(node);
                button:SetSelected(selected);

                button:SetScript("OnClick", function(button, buttonName, down)
                    --[[   EventRegistry:TriggerEvent("ProfessionsDebug.CraftingRecipeListRecipeClicked", button, buttonName,
                                               down, elementData.recipeInfo);]]

                    if buttonName == "LeftButton" then
                        if IsModifiedClick() then
                            --[[      local link = C_TradeSkillUI.GetRecipeLink(elementData.recipeInfo.recipeID);
                            if not HandleModifiedItemClick(link) and IsModifiedClick("RECIPEWATCHTOGGLE") and
                                Professions.CanTrackRecipe(elementData.recipeInfo) then
                                local recrafting = false;
                                local tracked = C_TradeSkillUI.IsRecipeTracked(elementData.recipeInfo.recipeID,
                                                                               recrafting);
                                C_TradeSkillUI.SetRecipeTracked(elementData.recipeInfo.recipeID, not tracked, recrafting);
                            end ]]
                        else
                            self.selectionBehavior:Select(button);
                        end
                    elseif buttonName == "RightButton" then
                        -- If additional context menu options are added, move this
                        -- public view check to the dropdown initializer.
                        --[[      if elementData.recipeInfo.learned and Professions.InLocalCraftingMode() then
                            ToggleDropDownMenu(1, elementData.recipeInfo, self.ContextMenu, "cursor");
                        end ]]
                    end

                    -- PlaySound(SOUNDKIT.UI_90_BLACKSMITHING_TREEITEMCLICK);
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
                end);

                --[[       button:SetScript("OnEnter", function()
                    ProfessionsRecipeListRecipeMixin.OnEnter(button);
                    EventRegistry:TriggerEvent("ProfessionsDebug.CraftingRecipeListRecipeEntered", button,
                                               elementData.recipeInfo);
                end); ]]
            end
            factory("ProfessionsRecipeListRecipeTemplate", Initializer);
        elseif elementData.isDivider then
            factory("ProfessionsRecipeListDividerTemplate");
        else
            factory("Frame");
        end
    end);

    view:SetDataProvider(self.DataProvider)

    view:SetElementExtentCalculator(function(dataIndex, node)
        local elementData = node:GetData();
        local baseElementHeight = 20;
        local categoryPadding = 5;

        if elementData.recipeInfo then return baseElementHeight; end

        if elementData.categoryInfo then return baseElementHeight + categoryPadding; end

        if elementData.dividerHeight then return elementData.dividerHeight; end

        if elementData.topPadding then return 1; end

        if elementData.bottomPadding then return 10; end
    end);

    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, view);

    local function OnSelectionChanged(o, elementData, selected)
        local button = self.ScrollBox:FindFrame(elementData);
        if button then button:SetSelected(selected); end

        if selected then
            local data = elementData:GetData();
            assert(data.recipeInfo);

            local newRecipeID = data.recipeInfo.recipeID;
            local changed = self.previousRecipeID ~= newRecipeID;
            if changed then
                EventRegistry:TriggerEvent("ProfessionsRecipeListMixin.Event.OnRecipeSelected", data.recipeInfo, self);

                if newRecipeID then self.previousRecipeID = newRecipeID; end
            end
        end
    end

    self.selectionBehavior = ScrollUtil.AddSelectionBehavior(self.ScrollBox);
    self.selectionBehavior:RegisterCallback(SelectionBehaviorMixin.Event.OnSelectionChanged, OnSelectionChanged, self);

    self:RegisterEvent("TRADE_SKILL_UPDATE");
    self:RegisterEvent("TRADE_SKILL_FILTER_UPDATE");
    self:RegisterEvent("UPDATE_TRADESKILL_RECAST");
end

function DFProfessionsRecipeListMixin:OnEvent(event, ...)
    print('DFProfessionsRecipeListMixin:OnEvent(event, ...)', event, ...)
    if event == 'TRADE_SKILL_UPDATE' then
        self:Refresh()
    elseif event == 'TRADE_SKILL_FILTER_UPDATE' then
    elseif event == 'UPDATE_TRADESKILL_RECAST' then
    end
end

function DFProfessionsRecipeListMixin:OnShow()
    -- print('DFProfessionsRecipeListMixin:OnShow()')
    -- self:CreateRecipeList()
end

function DFProfessionsRecipeListMixin:Refresh()
    print('->DFProfessionsRecipeListMixin:Refresh()')
    self:CreateRecipeList()
end

function DFProfessionsRecipeListMixin:CreateRecipeList()
    -- print('-->DFProfessionsRecipeListMixin:CreateRecipeList()')

    if not self.DataProvider then
        -- 
        print('no self.DataProvider')
        return
    end

    -- self.DataProvider = CreateTreeDataProvider()
    self.DataProvider:Flush()
    -- view:SetDataProvider(self.DataProvider)

    local numSkills = GetNumTradeSkills()
    if numSkills == 0 then return end

    local skillName, skillType, numAvailable, isExpanded, altVerb, numSkillUps;
    local headerNode = nil;
    for i = 1, numSkills do
        skillName, skillType, numAvailable, isExpanded, altVerb, numSkillUps = GetTradeSkillInfo(i);

        if skillType == 'header' then
            -- print('Header:', skillName)
            -- print('Header:', GetTradeSkillInfo(i))
            headerNode = self.DataProvider:Insert({
                categoryInfo = {name = skillName, isExpanded = isExpanded == 1, id = i}
            })
            -- print('-headerNode:', headerNode)
        else
            -- print('--', skillName)
            headerNode:Insert({
                recipeInfo = {
                    name = skillName,
                    skillType = skillType,
                    numAvailable = numAvailable,
                    isExpanded = isExpanded,
                    altVerb = altVerb,
                    numSkills = numSkills,
                    id = i
                }
            })
        end

    end
end
------------------------------

DFProfessionsRecipeListCategoryMixin = {}

function DFProfessionsRecipeListCategoryMixin:OnEnter()
    self.Label:SetFontObject(GameFontHighlight_NoShadow);
end

function DFProfessionsRecipeListCategoryMixin:OnLeave()
    self.Label:SetFontObject(GameFontNormal_NoShadow);
end

function DFProfessionsRecipeListCategoryMixin:Init(node)
    local elementData = node:GetData();

    local categoryInfo = elementData.categoryInfo;
    self.Label:SetText(categoryInfo.name);

    -- local color = categoryInfo.unlearned and DISABLED_FONT_COLOR or NORMAL_FONT_COLOR;
    -- self.Label:SetVertexColor(color:GetRGB());

    if categoryInfo.isExpanded then
        node:SetCollapsed(false, true, false)
    else
        node:SetCollapsed(true, true, false)
    end

    self:SetCollapseState(node:IsCollapsed());
end

function DFProfessionsRecipeListCategoryMixin:SetCollapseState(collapsed)
    if collapsed then
        self.CollapseIcon:SetTexCoord(0.302246, 0.312988, 0.0537109, 0.0693359)
        self.CollapseIconAlphaAdd:SetTexCoord(0.302246, 0.312988, 0.0537109, 0.0693359)
    else
        self.CollapseIcon:SetTexCoord(0.270508, 0.28125, 0.0537109, 0.0693359)
        self.CollapseIconAlphaAdd:SetTexCoord(0.270508, 0.28125, 0.0537109, 0.0693359)
    end

    if true then return end

    local atlas = collapsed and "Professions-recipe-header-expand" or "Professions-recipe-header-collapse";
    self.CollapseIcon:SetAtlas(atlas, TextureKitConstants.UseAtlasSize);
    self.CollapseIconAlphaAdd:SetAtlas(atlas, TextureKitConstants.UseAtlasSize);
end

------------------------------

DFProfessionsRecipeListRecipeMixin = {}

function DFProfessionsRecipeListRecipeMixin:OnLoad()
    local function OnLeave()
        self:OnLeave();
        GameTooltip_Hide();
    end

    self.LockedIcon:SetScript("OnLeave", OnLeave);
    self.SkillUps:SetScript("OnLeave", OnLeave);
end

local PROFESSION_RECIPE_COLOR = CreateColor(0.88627457618713, 0.86274516582489, 0.83921575546265, 1)

function DFProfessionsRecipeListRecipeMixin:GetLabelColor()
    return PROFESSION_RECIPE_COLOR
    -- return self.learned and PROFESSION_RECIPE_COLOR or DISABLED_FONT_COLOR;
end

local PROFESSIONS_SKILL_UP_EASY = "Low chance of gaining skill"
local PROFESSIONS_SKILL_UP_MEDIUM = "High chance of gaining skill"
local PROFESSIONS_SKILL_UP_OPTIMAL = "Guaranteed chance of gaining %d skill ups"

function DFProfessionsRecipeListRecipeMixin:Init(node, hideCraftableCount)
    local elementData = node:GetData();
    local recipeInfo = elementData.recipeInfo
    -- local recipeInfo = Professions.GetHighestLearnedRecipe(elementData.recipeInfo) or elementData.recipeInfo;

    self.Label:SetText(recipeInfo.name);
    -- self.learned = recipeInfo.learned;
    self:SetLabelFontColors(self:GetLabelColor());

    -- if true then return end
    --[[ 
    local rightFrames = {};

    self.LockedIcon:Hide();

    local function OnClick(button, buttonName, down)
        self:Click(buttonName, down);
    end
  ]]

    --[[ 
  ["Professions-Icon-Skill-High"]={13, 15, 0.263184, 0.269531, 0.0537109, 0.0683594, false, false, "1x"},
  ["Professions-Icon-Skill-Low"]={13, 15, 0.255859, 0.262207, 0.0537109, 0.0683594, false, false, "1x"},
  ["Professions-Icon-Skill-Medium"]={13, 15, 0.294922, 0.30127, 0.0537109, 0.0683594, false, false, "1x"}, ]]

    -- self.SkillUps:Hide();
    local tooltipSkillUpString = nil;

    local tex = base .. 'professions'
    local xOfs = -9;
    local yOfs = 0;

    local icon = self.SkillUps.Icon
    -- icon:ClearAllPoints()
    -- icon:SetPoint('LEFT', self, 'LEFT', -9, 1)
    icon:Show()

    local skillType = recipeInfo.skillType

    if skillType == 'trivial' then
        --       
        icon:Hide()
    elseif skillType == 'easy' then
        --
        icon:SetTexCoord(0.255859, 0.262207, 0.0537109, 0.0683594)
        tooltipSkillUpString = PROFESSIONS_SKILL_UP_EASY
    elseif skillType == 'medium' then
        icon:SetTexCoord(0.294922, 0.30127, 0.0537109, 0.0683594)
        tooltipSkillUpString = PROFESSIONS_SKILL_UP_MEDIUM
    elseif skillType == 'optimal' then
        icon:SetTexCoord(0.263184, 0.269531, 0.0537109, 0.0683594)
        tooltipSkillUpString = PROFESSIONS_SKILL_UP_OPTIMAL
    elseif skillType == 'difficult' then
        --
        icon:Hide()
    end

    if tooltipSkillUpString then
        local isDifficultyOptimal = skillType == 'optimal'
        local numSkillUps = recipeInfo.numSkillUps and recipeInfo.numSkillUps or 1;
        local hasMultipleSkillUps = numSkillUps > 1;
        local hasSkillUps = numSkillUps > 0;
        local showText = hasMultipleSkillUps and isDifficultyOptimal;
        self.SkillUps.Text:SetShown(showText);
        -- print('->', isDifficultyOptimal, numSkillUps, hasMultipleSkillUps, hasSkillUps, showText)
        if hasSkillUps then
            if showText then
                self.SkillUps.Text:SetText(numSkillUps);
                -- self.SkillUps.Text:SetVertexColor(DifficultyColors[recipeInfo.relativeDifficulty]:GetRGB());
            end

            self.SkillUps:SetScript("OnEnter", function()
                self:OnEnter();
                GameTooltip:SetOwner(self.SkillUps, "ANCHOR_RIGHT");
                GameTooltip_AddNormalLine(GameTooltip, tooltipSkillUpString:format(numSkillUps));
                GameTooltip:Show();
            end);
        else
            self.SkillUps:SetScript("OnEnter", nil);
        end

    end

    local count = recipeInfo.numAvailable + 69
    local hasCount = count > 0;
    if hasCount then
        self.Count:SetFormattedText(" [%d] ", count);
        self.Count:Show();
    else
        self.Count:Hide();
    end

    local padding = 10;
    local countWidth = hasCount and self.Count:GetStringWidth() or 0;
    local width = self:GetWidth() - (countWidth + padding + self.SkillUps:GetWidth());
    self.Label:SetWidth(self:GetWidth());
    self.Label:SetWidth(math.min(width, self.Label:GetStringWidth()));
end

function DFProfessionsRecipeListRecipeMixin:SetLabelFontColors(color)
    self.Label:SetVertexColor(color:GetRGB());
    self.Count:SetVertexColor(color:GetRGB());
end

function DFProfessionsRecipeListRecipeMixin:OnEnter()
    self:SetLabelFontColors(HIGHLIGHT_FONT_COLOR);
    local elementData = self:GetElementData();
    local recipeID = elementData.data.recipeInfo.recipeID;
    local name = elementData.data.recipeInfo.name;
    local iconID = elementData.data.recipeInfo.icon;

    if self.Label:IsTruncated() then
        GameTooltip:SetOwner(self.Label, "ANCHOR_RIGHT");
        local wrap = false;
        GameTooltip_AddHighlightLine(GameTooltip, name, wrap);
        GameTooltip:Show();
    end

    -- EventRegistry:TriggerEvent("Professions.RecipeListOnEnter", self, elementData.data);
end

function DFProfessionsRecipeListRecipeMixin:OnLeave()
    self:SetLabelFontColors(self:GetLabelColor());
    GameTooltip:Hide();
end

function DFProfessionsRecipeListRecipeMixin:SetSelected(selected)
    self.SelectedOverlay:SetShown(selected);
    self.HighlightOverlay:SetShown(not selected);
end

------------------------------
DFProfessionsRecipeSchematicFormMixin = {}

function DFProfessionsRecipeSchematicFormMixin:OnLoad()
    print('DFProfessionsRecipeSchematicFormMixin:OnLoad()')
end

function DFProfessionsRecipeSchematicFormMixin:OnShow()
    print('DFProfessionsRecipeSchematicFormMixin:OnShow()')
end

function DFProfessionsRecipeSchematicFormMixin:OnHide()
    print('DFProfessionsRecipeSchematicFormMixin:OnHide()')
end

function DFProfessionsRecipeSchematicFormMixin:OnEvent()
    print('DFProfessionsRecipeSchematicFormMixin:OnEvent()')
end

