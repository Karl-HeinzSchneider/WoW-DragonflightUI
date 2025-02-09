local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

DFProfessionMixin = {}

function DFProfessionMixin:OnLoad()
    self:SetupFavoriteDatabase()

    self.minimized = false
    self.ProfessionTable = {}
    self.SelectedProfession = ''
    self.SelectedSkillID = ''

    self:SetupFrameStyle()
    self:SetupSchematics()
    self:SetupTabs()
    self:Minimize(self.minimized)

    self:Refresh(true)
    self:Show()

    hooksecurefunc('SpellBookFrame_Update', function()
        --
        -- print('SpellBookFrame_Update')
        self:Refresh(true)
    end)

    self:RegisterEvent('PLAYER_REGEN_ENABLED')

    self:RegisterEvent("TRADE_SKILL_SHOW");
    self:RegisterEvent("TRADE_SKILL_CLOSE");
    self:RegisterEvent("TRADE_SKILL_UPDATE");
    self:RegisterEvent("TRADE_SKILL_FILTER_UPDATE");

    self.MinimizeButton:SetOnMaximizedCallback(function(btn)
        -- print('SetOnMaximizedCallback')
        self:Minimize(false)
    end)
    self.MinimizeButton:SetOnMinimizedCallback(function(btn)
        -- print('SetOnMinimizedCallback')
        self:Minimize(true)
    end)

    self.ClosePanelButton:HookScript("OnClick", function(btn)
        --     
        -- HideUIPanel(TradeSkillFrame)
        CloseTradeSkill()
        CloseCraft()
    end);

    -- self.RecipeList.ResetButton:SetScript('OnClick', function(btn)
    --     --
    --     self:ResetFilter()
    --     self:FilterDropdownRefresh()
    -- end)
end

function DFProfessionMixin:OnShow()
end

function DFProfessionMixin:OnHide()
end

function DFProfessionMixin:OnEvent(event, arg1, ...)
    print('~~', event, arg1 and arg1 or '')
    if event == 'TRADE_SKILL_SHOW' then
        -- self:Show()
        self:Refresh(true, true)
    elseif event == 'TRADE_SKILL_CLOSE' then
        -- self:Hide()
    elseif event == 'TRADE_SKILL_UPDATE' or event == 'TRADE_SKILL_FILTER_UPDATE' then
        if self:IsShown() then self:Refresh(false, true) end
    elseif event == 'PLAYER_REGEN_ENABLED' then
        if self.ShouldUpdate then self:UpdateTabs() end
    end
end

local frameWidth = 942 - 164
local frameWidthSmall = 404 - 50

function DFProfessionMixin:Minimize(mini)
    self.minimized = mini

    if mini then
        -- 
        self:SetWidth(frameWidthSmall)
        -- self:UpdateUIPanelWindows(false)

        self.RecipeList:Hide()
        self.RecipeList:SetWidth(0.1)

        self.RankFrame:Hide()

        self.SchematicForm.NineSlice:Hide()
        self.SchematicForm.BackgroundNineSlice:Hide()
        self.SchematicForm.Background:Hide()
        self.SchematicForm.MinimalBackground:Show()

        -- TradeSkillCreateButton:ClearAllPoints()
        -- TradeSkillCreateButton:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -9, 13)
        self.CreateButton:ClearAllPoints()
        self.CreateButton:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -9, 13 - 6)
    else
        --
        self:SetWidth(frameWidth)
        self:SetHeight(525)

        -- self:UpdateUIPanelWindows(true)

        self.RecipeList:Show()
        self.RecipeList:SetWidth(274)

        self.RankFrame:Show()

        self.SchematicForm.NineSlice:Show()
        self.SchematicForm.BackgroundNineSlice:Show()
        self.SchematicForm.Background:Show()
        self.SchematicForm.MinimalBackground:Hide()

        -- TradeSkillCreateButton:ClearAllPoints()
        -- TradeSkillCreateButton:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -9, 7)
        self.CreateButton:ClearAllPoints()
        self.CreateButton:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -9, 7)

        -- self:Refresh(true)
    end
end

function DFProfessionMixin:SetupFrameStyle()
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(self)
    DragonflightUIMixin:MaximizeMinimizeButtonFrameTemplate(self.MinimizeButton)
    self.MinimizeButton:ClearAllPoints()
    self.MinimizeButton:SetPoint('RIGHT', self.ClosePanelButton, 'LEFT', 0, 0)

    self:SetFrameStrata('MEDIUM')

    -- portrait/professionicon
    do
        local icon = self:CreateTexture('DragonflightUIProfessionIcon')
        icon:SetSize(62, 62)
        icon:SetPoint('TOPLEFT', self, 'TOPLEFT', -5, 7)
        icon:SetDrawLayer('OVERLAY', 6)
        self.Icon = icon

        local pp = self:CreateTexture('DragonflightUIProfessionIconFrame')
        pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
        pp:SetTexCoord(0.0078125, 0.0078125, 0.0078125, 0.6171875, 0.6171875, 0.0078125, 0.6171875, 0.6171875)
        pp:SetSize(84, 84)
        pp:SetPoint('CENTER', icon, 'CENTER', 0, 0)
        pp:SetDrawLayer('OVERLAY', 7)
        self.PortraitFrame = pp
    end

    -- header
    do
        local top = self.Bg.TopSection
        top:SetTexture(base .. 'ui-background-rock')
        top:ClearAllPoints()
        top:SetPoint('TOPLEFT', self.Bg, 'TOPLEFT', 0, 0)
        top:SetPoint('BOTTOMRIGHT', self.Bg.BottomRight, 'BOTTOMRIGHT', 0, 0)
        top:SetDrawLayer('BACKGROUND', 2)

        local bg = _G[self:GetName() .. 'Bg']
        bg:Hide()

        self.Bg:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 3)

        local newBG = self:CreateTexture('DragonflightUIRecipeListBG')
        newBG:SetTexture(base .. 'professions')
        newBG:SetTexCoord(0.000488281, 0.131348, 0.0771484, 0.635742)
        newBG:SetSize(268, 572)
        newBG:ClearAllPoints()
        newBG:SetPoint('TOPLEFT', self.RecipeList, 'TOPLEFT', 0, 0)
        newBG:SetPoint('BOTTOMRIGHT', self.RecipeList, 'BOTTOMRIGHT', 0, 0)

        self.NineSlice.Text:SetText('tmp')

        local titleFrame = CreateFrame('Frame', 'DragonflightUITitleFrame')
        titleFrame:SetPoint('TOP', self.NineSlice, 'TOP', 0, -2)
        titleFrame:SetPoint('LEFT', self.NineSlice, 'LEFT', 60, 0)
        titleFrame:SetPoint('RIGHT', self.NineSlice, 'RIGHT', -60, 0)
        titleFrame:SetHeight(self.NineSlice.Text:GetHeight())

        self.NineSlice.Text:ClearAllPoints()
        self.NineSlice.Text:SetPoint('CENTER', titleFrame, 'CENTER', 0, 0)

        local linkButton = self.LinkButton
        linkButton:ClearAllPoints()
        linkButton:SetPoint('LEFT', self.NineSlice.Text, 'RIGHT', 5, 0)
    end

    -- rankframe
    do
        local rankFrame = CreateFrame('Frame', 'DragonflightUIProfessionRankFrame', self)
        rankFrame:SetSize(453, 18)
        rankFrame:SetPoint('TOPLEFT', self, 'TOPLEFT', 280, -40)

        local rankFrameBG = rankFrame:CreateTexture('DragonflightUIProfessionRankFrameBackground')
        rankFrameBG:SetDrawLayer('BACKGROUND', 1)
        rankFrameBG:SetTexture(base .. 'professions')
        rankFrameBG:SetTexCoord(0.29834, 0.518555, 0.750977, 0.779297)
        rankFrameBG:SetSize(451, 29)
        rankFrameBG:SetPoint('TOPLEFT', rankFrame, 'TOPLEFT', 0, 0)

        local rankFrameBar = CreateFrame('Statusbar', 'DragonflightUIProfessionRankFrameBar', self)
        rankFrameBar:SetSize(441, 18)
        rankFrameBar:SetPoint('TOPLEFT', rankFrame, 'TOPLEFT', 5, -3)
        rankFrameBar:SetMinMaxValues(0, 100);
        rankFrameBar:SetValue(69);
        rankFrameBar:SetStatusBarTexture(base .. 'professionsfxalchemy')

        local rankFrameMask = rankFrame:CreateMaskTexture('DragonflightUIProfessionRankFrameMask')
        rankFrameMask:SetPoint('TOPLEFT', rankFrameBar, 'TOPLEFT', 0, 0)
        rankFrameMask:SetPoint('BOTTOMRIGHT', rankFrameBar, 'BOTTOMRIGHT', 0, 0)
        rankFrameMask:SetTexture(base .. 'profbarmask', "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        rankFrameBar:GetStatusBarTexture():AddMaskTexture(rankFrameMask)

        local rankFrameBorder = rankFrame:CreateTexture('DragonflightUIProfessionRankFrameBorder')
        rankFrameBorder:SetDrawLayer('OVERLAY', 1)
        rankFrameBorder:SetTexture(base .. 'professions')
        rankFrameBorder:SetTexCoord(0.663574, 0.883789, 0.129883, 0.158203)
        rankFrameBorder:SetSize(451, 29)
        rankFrameBorder:SetPoint('TOPLEFT', rankFrame, 'TOPLEFT', 0, 0)

        local rankFrameText = rankFrame:CreateFontString('', 'ARTWORK', 'GameFontHighlightSmall')
        rankFrameText:SetPoint('CENTER', rankFrameBar, 'CENTER', 0, 0)
        rankFrameText:SetText('69/100')

        function rankFrame:UpdateRankFrame(value, minValue, maxValue)
            rankFrameBar:SetMinMaxValues(minValue, maxValue)
            rankFrameBar:SetValue(value)

            rankFrameText:SetText(value .. '/' .. maxValue)
        end

        self.RankFrame = rankFrame
        self.RankFrameBar = rankFrameBar
        self.RankFrameText = rankFrameText
    end

    -- buttons
    do
        local create = CreateFrame('Button', 'DragonflightUIProfessionCreateButton', self, 'UIPanelButtonTemplate')
        create:SetSize(80, 22)
        create:SetText(CREATE)
        self.CreateButton = create

        local createAll =
            CreateFrame('Button', 'DragonflightUIProfessionCreateAllButton', self, 'UIPanelButtonTemplate')
        createAll:SetSize(80, 22)
        createAll:SetText(CREATE_ALL)
        createAll:SetPoint('RIGHT', create, 'LEFT', -86, 0)
        self.CreateAllButton = createAll

        local cancel = CreateFrame('Button', 'DragonflightUIProfessionCancelButton', self, 'UIPanelButtonTemplate')
        cancel:SetSize(80, 22)
        cancel:SetText(EXIT)
        self.CancelButton = cancel

        local decrement = CreateFrame('Button', 'DragonflightUIProfessionDecrementButton', self)
        decrement:SetSize(23, 22)
        decrement:SetNormalTexture('Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up')
        decrement:SetPushedTexture('Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down')
        decrement:SetDisabledTexture('Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled')
        decrement:SetHighlightTexture('Interface\\Buttons\\UI-Common-MouseHilight', 'ADD')
        decrement:SetPoint('LEFT', createAll, 'RIGHT', 3, 0)
        self.DecrementButton = decrement;

        local increment = CreateFrame('Button', 'DragonflightUIProfessionIncrementButton', self)
        increment:SetSize(23, 22)
        increment:SetNormalTexture('Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up')
        increment:SetPushedTexture('Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down')
        increment:SetDisabledTexture('Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled')
        increment:SetHighlightTexture('Interface\\Buttons\\UI-Common-MouseHilight', 'ADD')
        increment:SetPoint('RIGHT', create, 'LEFT', -3, 0)
        self.Incrementbutton = increment;

        -- local editbox = CreateFrame('EditBox','DragonflightUIProfessionInputBox', self)
        -- editbox:SetSize(30,20)
        -- editbox:SetPoint('LEFT',decrement,'RIGHT',4,0)
        local editbox = self.InputBox
        editbox:SetPoint('LEFT', decrement, 'RIGHT', 4, 0)

        local function incrementClicked()
            if editbox:GetNumber() < 100 then editbox:SetNumber(editbox:GetNumber() + 1) end
        end

        increment:SetScript('OnClick', function()
            --
            incrementClicked()
            editbox:ClearFocus()
        end)

        local function decrementClicked()
            if editbox:GetNumber() > 0 then editbox:SetNumber(editbox:GetNumber() - 1) end
        end

        decrement:SetScript('OnClick', function()
            --
            decrementClicked()
            editbox:ClearFocus()
        end)

    end

end

local MAX_TRADE_SKILL_REAGENTS = 6 -- 8

function DFProfessionMixin:SetupSchematics()
    local frame = self.SchematicForm

    local icon = CreateFrame('Button', 'DragonflightUIProfessionSkillIcon', frame)
    icon:SetSize(37, 37)
    icon:SetPoint('TOPLEFT', frame, 'TOPLEFT', 28 - 400 + 400, -28)
    frame.SkillIcon = icon

    -- TODO iconcount

    local name = frame:CreateFontString('DragonflightUIProfession' .. 'SkillName', 'BACKGROUND', 'GameFontNormal')
    name:SetSize(244, 10)
    name:SetText('Skill Name')
    name:SetJustifyH('LEFT')
    -- name:SetPoint('LEFT', icon, 'RIGHT', 14, 17)
    name:SetPoint('TOPLEFT', icon, 'TOPRIGHT', 14, 0)
    frame.SkillName = name

    local req = frame:CreateFontString('DragonflightUIProfession' .. 'RequirementLabel', 'BACKGROUND',
                                       'GameFontHighlightSmall')
    req:SetPoint('TOPLEFT', name, 'BOTTOMLEFT', 0, -4)
    req:SetText(REQUIRES_LABEL)
    frame.RequirementLabel = req

    local reqText = frame:CreateFontString('DragonflightUIProfession' .. 'RequirementText', 'BACKGROUND',
                                           'GameFontHighlightSmall')
    reqText:SetSize(250, 9.9)
    reqText:SetJustifyH("LEFT");
    reqText:SetPoint('LEFT', req, 'RIGHT', 4, 0)
    frame.RequirementText = reqText

    local cooldown = frame:CreateFontString('DragonflightUIProfession' .. 'SkillCooldown', 'BACKGROUND',
                                            'GameFontRedSmall')
    cooldown:SetPoint('TOPLEFT', req, 'BOTTOMLEFT', 0, 0)
    frame.SkillCooldown = cooldown

    local descr = frame:CreateFontString('DragonflightUIProfession' .. 'SkillDescription', 'BACKGROUND',
                                         'GameFontHighlightSmall')
    descr:SetPoint('TOPLEFT', icon, 'BOTTOMLEFT', -1, -12)
    descr:SetText('*descr*')
    frame.SkillDescription = descr

    -- reagents
    local reagentLabel = frame:CreateFontString('DragonflightUIProfession' .. 'ReagentLabel', 'BACKGROUND',
                                                'GameFontNormalSmall')
    reagentLabel:SetPoint('TOPLEFT', icon, 'BOTTOMLEFT', -1, -12)
    reagentLabel:SetText(SPELL_REAGENTS)
    frame.RegentLabel = reagentLabel

    frame.ReagentTable = {}
    for i = 1, MAX_TRADE_SKILL_REAGENTS do
        --
        local reagent = CreateFrame('BUTTON', 'DragonflightUIProfession' .. 'Reagent' .. i, frame, 'QuestItemTemplate')
        reagent:SetPoint('TOPLEFT', reagentLabel, 'TOPLEFT', 1, -23 - (i - 1) * 45)
        reagent:SetSize(180, 50)
        frame.ReagentTable[i] = reagent

        local reagentIcon = _G[reagent:GetName() .. 'IconTexture']
        -- reagentIcon:SetSize() 
        reagentIcon:ClearAllPoints()
        reagentIcon:SetPoint('LEFT', reagent, 'LEFT', 0, 0)

        local overlay = DragonflightUIItemColorMixin:AddOverlayToFrame(reagent)
        overlay:SetPoint('TOPLEFT', reagentIcon, 'TOPLEFT', 0, 0)
        overlay:SetPoint('BOTTOMRIGHT', reagentIcon, 'BOTTOMRIGHT', 0, 0)

        local reagentCountText = _G[reagent:GetName() .. "Count"];
        reagentCountText:Hide()

        local reagentNameText = _G[reagent:GetName() .. 'Name']
        reagentNameText:ClearAllPoints()
        reagentNameText:SetPoint('LEFT', reagent, 'LEFT', 46, 0)
        reagentNameText:SetSize(142, 36)
        reagentNameText:SetJustifyH("LEFT");
        reagentNameText:SetText('*Reagent' .. i .. '*')

        -- local updateText = function()
        --     local index = GetTradeSkillSelectionIndex()
        --     local reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(index, i);

        --     if (not reagentName or not reagentTexture) then return end

        --     local newText = playerReagentCount .. "/" .. reagentCount .. ' ' .. reagentName

        --     reagentNameText:SetText(newText)

        --     local link = GetTradeSkillReagentItemLink(index, i)

        --     if link then
        --         local quality, _, _, _, _, _, _, _, _, classId = select(3, C_Item.GetItemInfo(link));
        --         if (classId == 12) then quality = 0; end
        --         DragonflightUIItemColorMixin:UpdateOverlayQuality(reagent, quality)
        --     end
        -- end

        -- hooksecurefunc(reagentCountText, 'SetText', function()
        --     updateText()
        -- end)
        -- updateText()

        local reagentNameFrame = _G[reagent:GetName() .. 'NameFrame']
        reagentNameFrame:Hide()
    end

end

function DFProfessionMixin:SetupTabs()
    local tabFrame = CreateFrame('FRAME', 'DragonflightUIProfessionFrameTabFrame', self)

    self.DFTabFrame = tabFrame
    local numTabs = 6
    tabFrame.numTabs = numTabs
    tabFrame.Tabs = {}

    for i = 1, numTabs do
        --
        local tab = CreateFrame('BUTTON', 'DragonflightUIProfessionFrameTabButton' .. i, tabFrame,
                                'DFProfessionTabTemplate', i)
        tab:SetParent(tabFrame)
        local text = _G[tab:GetName() .. 'Text']
        tab.Text = text;
        function tab:SetText(str)
            text:SetText(str)
        end
        tinsert(tabFrame.Tabs, i, tab)

        DragonflightUIMixin:CharacterFrameTabButtonTemplate(tab, true, true)

        tab:SetAttribute('type', 'macro')
        tab:SetScript('PostClick', function(self, button, down)
            --        
            DragonflightUICharacterTabMixin:Tab_OnClick(self, tabFrame)
        end)

        if i == 1 then
            tab:ClearAllPoints()
            tab:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 12, 1)
            text:SetText('*Prof1*')
            tab:SetScript('OnEnter', function(self)
                --
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
                -- GameTooltip:SetText(MicroButtonTooltipText(tab:GetText(), 'TOGGLESPELLBOOK'), 1.0, 1.0, 1.0);
                GameTooltip:SetText('1', 1.0, 1.0, 1.0);
            end)
        else
            tab.DFChangePoint = true
            tab:ClearAllPoints()
            tab:SetPoint('LEFT', tabFrame.Tabs[i - 1], 'RIGHT', 0, 0)
            text:SetText('*Prof' .. i .. '*')
            tab:SetScript('OnEnter', function(self)
                --
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
                -- GameTooltip:SetText(MicroButtonTooltipText(tab:GetText(), ''), 1.0, 1.0, 1.0);
                GameTooltip:SetText(i, 1.0, 1.0, 1.0);
            end)
        end

        tab:SetScript('OnClick', function()
            --
            -- print('onclick', i)
            local profIndex = ''
            if i == 1 then
                profIndex = 'primary1'
            elseif i == 2 then
                profIndex = 'primary2'
            elseif i == 3 then
                profIndex = 'cooking'
            elseif i == 4 then
                profIndex = 'firstaid'
            elseif i == 5 then
                profIndex = 'poison'
            elseif i == 6 then
                -- profIndex= 'primary1'
            end

            local prof = self.ProfessionTable[profIndex]
            if not prof then return end

            if tabFrame.selectedTab == i then return end
            -- print('cast:', prof.nameLoc)
            CastSpellByName(prof.nameLoc)
        end)

        DragonflightUIMixin:TabResize(tab)
    end
end

function DFProfessionMixin:UpdateTabs()
    local tabFrame = self.DFTabFrame;

    if InCombatLockdown() then return end

    local tabs = tabFrame.Tabs;
    local tab;

    local prof1 = self.ProfessionTable['primary1'];
    tab = tabs[1]
    if prof1 then
        tab:Enable()
        tab:SetText(prof1.nameLoc)
    else
        tab:Hide()
        tab:SetText('***')
    end

    local prof2 = self.ProfessionTable['primary2'];
    tab = tabs[2]
    if prof2 then
        tab:Enable()
        tab:SetText(prof2.nameLoc)
    else
        tab:Hide()
        tab:SetText('***')
    end

    local prof3 = self.ProfessionTable['cooking'];
    tab = tabs[3]
    if prof3 then
        tab:Enable()
        tab:SetText(prof3.nameLoc)
    else
        tab:Hide()
        tab:SetText('***')
    end

    local prof4 = self.ProfessionTable['firstaid'];
    tab = tabs[4]
    if prof4 then
        tab:Enable()
        tab:SetText(prof4.nameLoc)
    else
        tab:Hide()
        tab:SetText('***')
    end

    -- TODO or hunter pet
    local prof5 = self.ProfessionTable['poison'];
    tab = tabs[5]
    if prof5 then
        tab:Enable()
        tab:SetText(prof5.nameLoc)
    else
        tab:Hide()
        tab:SetText('***')
    end

    -- 
    local prof6 = self.ProfessionTable[''];
    tab = tabs[6]
    tab:Hide()
end

function DFProfessionMixin:SetupFavoriteDatabase()
    self.db = DF.db:RegisterNamespace('RecipeFavorite', {profile = {favorite = {}}})
end

function DFProfessionMixin:Refresh(force, isTradeskill)
    print('DFProfessionMixin:Refresh(force)', force, isTradeskill and 'Tradeskill' or 'Craft')
    self:UpdateProfessionData()

    if InCombatLockdown() then
        -- prevent unsecure update in combat TODO: message?
        self.ShouldUpdate = true
    else
        self.ShouldUpdate = false
        self:UpdateTabs()
    end
    -- self:SetProfessionData(isTradeskill)
    -- self:UpdateHeader()
    -- self:UpdateRecipe()
    -- self:CheckFilter()
end

function DFProfessionMixin:SetProfessionData(isTradeskill)
    print('DFProfessionMixin:SetProfessionData()', isTradeskill and 'Tradeskill' or 'Craft')

end

--[[ First Aid 	129										
Blacksmithing	164	
Leatherworking	165	
Alchemy	171	
Herbalism	182
Cooking	185	
Mining	186
Tailoring	197	
Engineering	202	
Enchanting	333	
Fishing	356
Skinning	393	
Jewelcrafting 	755
Inscription 	773	
Archeology 	794
 ]]

local professionDataTable = {}
do
    professionDataTable[129] = {tex = 'professionbackgroundart', bar = 'professionsfxalchemy', icon = 135966} -- first aid
    professionDataTable[164] = {
        tex = 'ProfessionBackgroundArtBlacksmithing',
        bar = 'professionsfxblacksmithing',
        icon = 136241
    }
    professionDataTable[165] = {
        tex = 'ProfessionBackgroundArtLeatherworking',
        bar = 'professionsfxleatherworking',
        icon = 133611
    }
    professionDataTable[171] = {tex = 'ProfessionBackgroundArtAlchemy', bar = 'professionsfxalchemy', icon = 136240}
    professionDataTable[182] = {tex = 'ProfessionBackgroundArtHerbalism', bar = '', icon = 136246} -- herb
    professionDataTable[185] = {tex = 'ProfessionBackgroundArtCooking', bar = 'professionsfxcooking', icon = 133971}
    professionDataTable[186] = {tex = 'ProfessionBackgroundArtMining', bar = 'professionsfxmining', icon = 136248}
    professionDataTable[197] = {tex = 'ProfessionBackgroundArtTailoring', bar = 'professionsfxtailoring', icon = 136249}
    professionDataTable[202] = {
        tex = 'ProfessionBackgroundArtEngineering',
        bar = 'professionsfxengineering',
        icon = 136243
    }
    professionDataTable[333] = {
        tex = 'ProfessionBackgroundArtEnchanting',
        bar = 'professionsfxenchanting',
        icon = 136244
    }
    professionDataTable[356] = {tex = 'ProfessionBackgroundArtFishing', bar = '', icon = 136245} -- fisch
    professionDataTable[393] = {tex = 'ProfessionBackgroundArtSkinning', bar = 'professionsfxskinning', icon = 134366} -- skinning
    professionDataTable[755] = {
        tex = 'ProfessionBackgroundArtJewelcrafting',
        bar = 'professionsfxjewelcrafting',
        icon = 134071
    }
    professionDataTable[773] = {
        tex = 'ProfessionBackgroundArtInscription',
        bar = 'professionsfxinscription',
        icon = 237171
    }
    professionDataTable[794] = {
        tex = 'ProfessionBackgroundArtLeatherworking',
        bar = 'professionsfxleatherworking',
        icon = 441139
    } -- archeology
    professionDataTable[666] = {tex = 'ProfessionBackgroundArtAlchemy', bar = 'professionsfxalchemy', icon = 136242} -- poison
    DFProfessionMixin.ProfessionDataTable = professionDataTable
end

if not PROFESSION_RANKS then
    PROFESSION_RANKS = {};
    PROFESSION_RANKS[1] = {75, APPRENTICE};
    PROFESSION_RANKS[2] = {150, JOURNEYMAN};
    PROFESSION_RANKS[3] = {225, EXPERT};
    PROFESSION_RANKS[4] = {300, ARTISAN};
    PROFESSION_RANKS[5] = {375, MASTER};
    PROFESSION_RANKS[6] = {450, GRAND_MASTER};
    PROFESSION_RANKS[7] = {525, ILLUSTRIOUS};
end

local primary = {164, 165, 171, 182, 186, 197, 202, 333, 393, 755, 773}
local profs = {primary = {}, poison = 666, fishing = 356, cooking = 185, firstaid = 129}
for k, v in ipairs(primary) do profs.primary[v] = true end

function DFProfessionMixin:UpdateProfessionData()
    local skillTable = {}
    if DF.Cata then
        local prof1, prof2, archaeology, fishing, cooking, firstaid = GetProfessions()

        if prof1 then
            local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier,
                  specializationIndex, specializationOffset = GetProfessionInfo(prof1)
            skillTable['primary1'] = {
                nameLoc = name,
                icon = icon,
                skillID = skillLine,
                skill = skillLevel,
                maxSkill = maxSkillLevel
            }
        end

        if prof2 then
            local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier,
                  specializationIndex, specializationOffset = GetProfessionInfo(prof2)
            skillTable['primary2'] = {
                nameLoc = name,
                icon = icon,
                skillID = skillLine,
                skill = skillLevel,
                maxSkill = maxSkillLevel
            }
        end

        -- TODO: archeo, fishing

        if cooking then
            local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier,
                  specializationIndex, specializationOffset = GetProfessionInfo(cooking)
            skillTable['cooking'] = {
                nameLoc = name,
                icon = icon,
                skillID = skillLine,
                skill = skillLevel,
                maxSkill = maxSkillLevel
            }
        end

        -- first aid
        if firstaid then
            local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier,
                  specializationIndex, specializationOffset = GetProfessionInfo(firstaid)
            skillTable['firstaid'] = {
                nameLoc = name,
                icon = icon,
                skillID = skillLine,
                skill = skillLevel,
                maxSkill = maxSkillLevel
            }
        end
    elseif DF.Wrath then
    elseif DF.Era then
        for i = 1, GetNumSkillLines() do
            local nameLoc, _, _, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost,
                  rankCost, minLevel, skillCostType, skillDescription = GetSkillLineInfo(i)

            local skillID = DragonflightUILocalizationData:GetSkillIDFromProfessionName(nameLoc)

            if skillID then
                --
                -- print(nameLoc, skillRank, skillID)

                local profDataTable = self.ProfessionDataTable[skillID]
                local texture = profDataTable.icon
                local spellIcon = texture

                if skillID == 182 then
                    -- herbalism
                    local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(2383)
                    nameLoc = name
                    spellIcon = icon
                elseif skillID == 186 then
                    -- mining
                    local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(2580)
                    nameLoc = name
                    spellIcon = icon
                end

                local data = {
                    nameLoc = nameLoc,
                    icon = texture,
                    skillID = skillID, -- only era @TODO
                    lineID = i,
                    skill = skillRank,
                    maxSkill = skillMaxRank,
                    skillModifier = skillModifier -- only era= @TODO
                }

                if profs.primary[skillID] then
                    --
                    if skillTable['primary1'] then
                        skillTable['primary2'] = data
                    else
                        skillTable['primary1'] = data
                    end
                else
                    --
                    if skillID == profs.poison then
                        skillTable['poison'] = data
                    elseif skillID == profs.fishing then
                        skillTable['fishing'] = data
                    elseif skillID == profs.cooking then
                        skillTable['cooking'] = data
                    elseif skillID == profs.firstaid then
                        skillTable['firstaid'] = data
                    end
                end
            end
        end
    end

    self.ProfessionTable = skillTable

    return skillTable;
end

function DFProfessionMixin:GetProfessionIDAndIcon(isTradeskill)
    if DF.Cata then
        local prof1, prof2, archaeology, fishing, cooking, firstaid = GetProfessions()

        if prof1 then
            local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier,
                  specializationIndex, specializationOffset = GetProfessionInfo(prof1)
            if name == nameLoc then return skillLine, icon end
        end

        if prof2 then
            local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier,
                  specializationIndex, specializationOffset = GetProfessionInfo(prof2)
            if name == nameLoc then return skillLine, icon end
        end

        -- TODO: archeo, fishing

        if cooking then
            local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier,
                  specializationIndex, specializationOffset = GetProfessionInfo(cooking)
            if name == nameLoc then return skillLine, icon end
        end

        -- first aid
        if firstaid then
            local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier,
                  specializationIndex, specializationOffset = GetProfessionInfo(firstaid)
            if name == nameLoc then return skillLine, icon end
        end

        return nil, nil
    elseif DF.Wrath then
        -- TODO
    elseif DF.Era then

        if isTradeskill then
            local nameLoc, rank, maxRank = GetTradeSkillLine();
            local skillID = DragonflightUILocalizationData:GetSkillIDFromProfessionName(nameLoc)
            local profData = professionDataTable[skillID]

            return skillID, profData.icon
        else
            -- localized...
            local nameLoc, rank, maxRank = GetCraftDisplaySkillLine();

            if nameLoc then
                -- normal 
            else
                -- beast training
                -- nameLoc = GetCraftSkillLine(1)
                nameLoc = DragonflightUILocalizationData.DF_PROFESSIONS_BEAST
            end

            local skillID = DragonflightUILocalizationData:GetSkillIDFromProfessionName(nameLoc)
            local profData = professionDataTable[skillID]

            return skillID, profData.icon
        end
    end
end

function DFProfessionMixin:UpdateHeader()
    print('DFProfessionMixin:UpdateHeader()')
end

function DFProfessionMixin:UpdateRecipe()
    print('DFProfessionMixin:UpdateRecipeName()')
end

function DFProfessionMixin:CheckFilter()
    print('DFProfessionMixin:CheckFilter()')
end

-- function DFProfessionMixin:IsCrafting()
--     print('DFProfessionMixin:CheckFilter()')
-- end

-- GetTradeSkillLine()
