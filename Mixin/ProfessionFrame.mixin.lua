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

    self:RegisterEvent("CRAFT_SHOW");
    self:RegisterEvent("CRAFT_CLOSE");
    self:RegisterEvent("CRAFT_UPDATE");
    self:RegisterEvent("SPELLS_CHANGED");
    self:RegisterEvent("UNIT_PET_TRAINING_POINTS");

    -- UIParent:UnregisterEvent("TRADE_SKILL_SHOW")
    -- UIParent:UnregisterEvent("CRAFT_SHOW")

    self.RecipeList:RegisterCallback('OnRecipeSelected', function(recipeList, id)
        --
        -- print('~~~OnRecipeSelected', id)
        self:UpdateRecipe(id)
    end, self)

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
        self.TradeSkillOpen = true;
        self.CraftOpen = false;
        CloseCraft()
        self:Show()
        self:Refresh(true)
    elseif event == 'CRAFT_SHOW' then
        self.TradeSkillOpen = false;
        self.CraftOpen = true;
        CloseTradeSkill()
        self:Show()
        self:Refresh(true)
    elseif event == 'TRADE_SKILL_CLOSE' then
        self.TradeSkillOpen = false;
        if not self.CraftOpen then self:Hide() end
    elseif event == 'CRAFT_CLOSE' then
        self.CraftOpen = false;
        if not self.TradeSkillOpen then self:Hide() end
    elseif event == 'TRADE_SKILL_UPDATE' or event == 'TRADE_SKILL_FILTER_UPDATE' or event == 'CRAFT_UPDATE' then
        if self:IsShown() then self:Refresh(false) end
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

    icon.hasItem = 1;
    icon:SetScript('OnLeave', function()
        GameTooltip:Hide();
        ResetCursor();
    end)

    local iconCount = icon:CreateFontString('DragonflightUIProfession' .. 'IconCount', 'BACKGROUND', 'NumberFontNormal')
    -- iconCount:SetSize(244, 10)
    iconCount:SetText('*1*')
    iconCount:SetJustifyH('RIGHT')
    iconCount:SetPoint('BOTTOMRIGHT', icon, 'BOTTOMRIGHT', -5, 2)
    frame.SKillIconCount = iconCount

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
        local reagent = CreateFrame('BUTTON', 'DragonflightUIProfession' .. 'Reagent' .. i, frame, 'QuestItemTemplate',
                                    i)
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

        local reagentNameFrame = _G[reagent:GetName() .. 'NameFrame']
        reagentNameFrame:Hide()

        reagent.hasItem = 1;
        reagent:SetScript('OnLeave', function()
            GameTooltip:Hide();
            ResetCursor();
        end)
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
            tab:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 12, 2)
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

        local function onClick()
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

            -- if self.SelectedProfession == profIndex then return end

            local prof = self.ProfessionTable[profIndex]
            if not prof then return end

            if tabFrame.selectedTab == i then return end
            -- print('cast:', prof.nameLoc)

            CastSpellByName(prof.nameLoc)
        end

        tab:SetScript('OnClick', onClick)
        tab.DFOnClick = onClick

        DragonflightUIMixin:TabResize(tab)
    end
end

function DFProfessionMixin:UpdateTabs()
    local tabFrame = self.DFTabFrame;

    if InCombatLockdown() then return end

    local function setupTooltip(tab, prof)
        tab:SetScript('OnEnter', function(self)
            --
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
            GameTooltip:SetText(prof.nameLoc, 1.0, 1.0, 1.0);
            GameTooltip:AddDoubleLine(' ')
            GameTooltip:AddDoubleLine('Skill: ', '|cFFFFFFFF' .. prof.skill .. '/' .. prof.maxSkill .. '|r')

            GameTooltip:Show()
        end)
    end

    local tabs = tabFrame.Tabs;
    local tab;

    local prof1 = self.ProfessionTable['primary1'];
    tab = tabs[1]
    if prof1 then
        tab:Enable()
        tab:SetText(prof1.nameLoc)
        setupTooltip(tab, prof1)
        if self.SelectedProfession == 'primary1' then DragonflightUICharacterTabMixin:Tab_OnClick(tab, tabFrame) end
    else
        tab:Hide()
        tab:SetText('***')
    end

    local prof2 = self.ProfessionTable['primary2'];
    tab = tabs[2]
    if prof2 then
        tab:Enable()
        tab:SetText(prof2.nameLoc)
        setupTooltip(tab, prof2)
        if self.SelectedProfession == 'primary2' then DragonflightUICharacterTabMixin:Tab_OnClick(tab, tabFrame) end
    else
        tab:Hide()
        tab:SetText('***')
    end

    local prof3 = self.ProfessionTable['cooking'];
    tab = tabs[3]
    if prof3 then
        tab:Enable()
        tab:SetText(prof3.nameLoc)
        setupTooltip(tab, prof3)
        if self.SelectedProfession == 'cooking' then DragonflightUICharacterTabMixin:Tab_OnClick(tab, tabFrame) end
    else
        tab:Hide()
        tab:SetText('***')
    end

    local prof4 = self.ProfessionTable['firstaid'];
    tab = tabs[4]
    if prof4 then
        tab:Enable()
        tab:SetText(prof4.nameLoc)
        setupTooltip(tab, prof4)
        if self.SelectedProfession == 'firstaid' then DragonflightUICharacterTabMixin:Tab_OnClick(tab, tabFrame) end
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
        setupTooltip(tab, prof5)
        if self.SelectedProfession == 'poison' then DragonflightUICharacterTabMixin:Tab_OnClick(tab, tabFrame) end
    else
        tab:Hide()
        tab:SetText('***')
    end

    -- 
    local prof6 = self.ProfessionTable[''];
    tab = tabs[6]
    tab:Hide()

    for k, v in ipairs(tabs) do
        --
        local w = v.Text:GetWrappedWidth()
        local newW = math.max(w + 16, 78)
        if v:IsShown() then
            v:SetWidth(newW)
        else
            v:SetWidth(0.01)
        end
    end
end

function DFProfessionMixin:SetupFavoriteDatabase()
    self.db = DF.db:RegisterNamespace('RecipeFavorite', {profile = {favorite = {}}})
end

function DFProfessionMixin:SetRecipeFavorite(info, checked)
    local db = self.db.profile

    if checked then
        db.favorite[info] = true
    else
        db.favorite[info] = nil
    end
end

function DFProfessionMixin:IsRecipeFavorite(info)
    local db = self.db.profile

    if db.favorite[info] then
        return true
    else
        return false
    end
end

function DFProfessionMixin:Refresh(force)
    print('DFProfessionMixin:Refresh(force)', force)
    self:UpdateProfessionData()

    self:SetCurrentProfession()

    if InCombatLockdown() then
        -- prevent unsecure update in combat TODO: message?
        self.ShouldUpdate = true
    else
        self.ShouldUpdate = false
        self:UpdateTabs()
    end

    if not self.SelectedProfession then
        print('-- no self.SelectedProfession')
        return
    end

    self:UpdateHeader()
    self:UpdateRecipeList()
    -- self:UpdateRecipe()
    -- self:CheckFilter()
end

function DFProfessionMixin:SetCurrentProfession()
    print('DFProfessionMixin:SetCurrentProfession()')
    local nameLoc;

    if self.TradeSkillOpen then
        nameLoc, _, _ = GetTradeSkillLine();
    elseif self.CraftOpen then
        nameLoc, _, _ = GetCraftDisplaySkillLine();

        if nameLoc then
            -- normal 
        else
            -- beast training
            -- nameLoc = GetCraftSkillLine(1)
            nameLoc = DragonflightUILocalizationData.DF_PROFESSIONS_BEAST
        end
    end

    for k, v in pairs(self.ProfessionTable) do
        if v.nameLoc == nameLoc then
            self.SelectedProfession = k;
            return k
        end
    end

    self.SelectedProfession = nil;
    return nil;
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
local ignoredPrimary = {182, 186}
local profs = {primary = {}, ignoredPrimary = {}, poison = 666, fishing = 356, cooking = 185, firstaid = 129}
for k, v in ipairs(primary) do profs.primary[v] = true end
for k, v in ipairs(ignoredPrimary) do profs.ignoredPrimary[v] = true end

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
                maxSkill = maxSkillLevel,
                profData = professionDataTable[skillLine]
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
                maxSkill = maxSkillLevel,
                profData = professionDataTable[skillLine]
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
                maxSkill = maxSkillLevel,
                profData = professionDataTable[skillLine]
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
                maxSkill = maxSkillLevel,
                profData = professionDataTable[skillLine]
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
                    skillModifier = skillModifier, -- only era= @TODO
                    profData = professionDataTable[skillID]
                }

                if profs.primary[skillID] and not profs.ignoredPrimary[skillID] then
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

function DFProfessionMixin:UpdateHeader()
    print('DFProfessionMixin:UpdateHeader()', self.SelectedProfession)

    local prof = self.ProfessionTable[self.SelectedProfession]

    self.Icon:SetTexture(prof.profData.icon)
    SetPortraitToTexture(self.Icon, self.Icon:GetTexture())

    local isLink, playerName = IsTradeSkillLinked()
    if isLink then
        --
        self.NineSlice.Text:SetText(prof.nameLoc .. ' (' .. playerName .. ')')
        self.LinkButton:Hide()
    else
        self.NineSlice.Text:SetText(prof.nameLoc)

        if DF.Era then
            self.LinkButton:Hide()
        else
            self.LinkButton:Show()
        end
    end
    self.LinkButton:Hide() -- @TODO

    self.SchematicForm.Background:SetTexture(base .. prof.profData.tex)

    local newStatusTexture = base .. prof.profData.bar
    if newStatusTexture ~= self.RankFrame.DFStatusTexture then
        self.RankFrameBar:SetStatusBarTexture(base .. prof.profData.bar)
        self.RankFrame.DFStatusTexture = base .. prof.profData.bar
    end

    self.RankFrame:UpdateRankFrame(prof.skill, 0, prof.maxSkill)
end

function DFProfessionMixin:UpdateRecipe(id)
    print('DFProfessionMixin:UpdateRecipe()', id)
    local frame = self.SchematicForm

    if self.TradeSkillOpen then
        local skillName, skillType, numAvailable, isExpanded, altVerb, numSkillUps, indentLevel, showProgressBar,
              currentRank, maxRank, startingRank = GetTradeSkillInfo(id)

        frame.SkillName:SetText(skillName)

        if (GetTradeSkillCooldown(id)) then
            frame.SkillCooldown:SetText(COOLDOWN_REMAINING .. " " .. SecondsToTime(GetTradeSkillCooldown(id)));
        else
            frame.SkillCooldown:SetText("");
        end

        local icon = GetTradeSkillIcon(id);
        if (icon) then
            frame.SkillIcon:SetNormalTexture(icon);
        else
            frame.SkillIcon:ClearNormalTexture();
        end

        local minMade, maxMade = GetTradeSkillNumMade(id);
        if (maxMade > 1) then
            if (minMade == maxMade) then
                frame.SKillIconCount:SetText(minMade);
            else
                frame.SKillIconCount:SetText(minMade .. "-" .. maxMade);
            end
            if (frame.SKillIconCount:GetWidth() > 39) then
                frame.SKillIconCount:SetText("~" .. floor((minMade + maxMade) / 2));
            end
        else
            frame.SKillIconCount:SetText("");
        end

        local creatable = true;
        local numReagents = GetTradeSkillNumReagents(id);

        if (numReagents > 0) then
            frame.RegentLabel:Show();
        else
            frame.RegentLabel:Hide();
        end

        for i = 1, numReagents do
            local reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(id, i);

            local reagent = frame.ReagentTable[i]
            local name = _G[reagent:GetName() .. 'Name']
            local count = _G[reagent:GetName() .. "Count"];

            if (not reagentName or not reagentTexture) then
                reagent:Hide();
            else
                reagent:Show();
                SetItemButtonTexture(reagent, reagentTexture);
                name:SetText(reagentName);
                -- Grayout items
                if (playerReagentCount < reagentCount) then
                    SetItemButtonTextureVertexColor(reagent, 0.5, 0.5, 0.5);
                    name:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
                    creatable = false;
                else
                    SetItemButtonTextureVertexColor(reagent, 1.0, 1.0, 1.0);
                    name:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
                end
                if (playerReagentCount >= 100) then playerReagentCount = "*"; end
                count:SetText(playerReagentCount .. " /" .. reagentCount);

                -- DF
                local newText = playerReagentCount .. "/" .. reagentCount .. ' ' .. reagentName
                name:SetText(newText)

                local link = GetTradeSkillReagentItemLink(id, i)

                if link then
                    local quality, _, _, _, _, _, _, _, _, classId = select(3, C_Item.GetItemInfo(link));
                    if (classId == 12) then quality = 0; end
                    DragonflightUIItemColorMixin:UpdateOverlayQuality(reagent, quality)
                end

                local function UpdateTooltip(self)
                    GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT");
                    GameTooltip:SetTradeSkillItem(id, self:GetID());
                    CursorUpdate(self);
                end
                reagent:SetScript('OnEnter', UpdateTooltip)

                local function OnClick(self)
                    HandleModifiedItemClick(GetTradeSkillReagentItemLink(id, self:GetID()));
                end
                reagent:SetScript('OnClick', OnClick)

            end
        end

        for i = numReagents + 1, MAX_TRADE_SKILL_REAGENTS do
            local reagent = frame.ReagentTable[i]
            reagent:Hide()
        end

        local spellFocus = BuildColoredListString(GetTradeSkillTools(id));
        if (spellFocus) then
            frame.RequirementLabel:Show();
            frame.RequirementText:SetText(spellFocus);
        else
            frame.RequirementLabel:Hide();
            frame.RequirementText:SetText("");
        end

        self.CreateButton:SetText(altVerb or CREATE);

        if (creatable) then
            self.CreateButton:Enable();
            self.CreateAllButton:Enable();
        else
            self.CreateButton:Disable();
            self.CreateAllButton:Disable();
        end

        -- self.InputBox:SetNumber(GetTradeskillRepeatCount());
        self.InputBox:SetNumber(1);

        if (altVerb) then
            self.CreateAllButton:Hide();
            self.DecrementButton:Hide();
            self.InputBox:Hide();
            self.Incrementbutton:Hide();
        else
            -- DF
            self.CreateAllButton:Show();
            self.DecrementButton:Show();
            self.InputBox:Show();
            self.Incrementbutton:Show();
        end

        if (GetTradeSkillDescription(id)) then
            frame.SkillDescription:SetText(GetTradeSkillDescription(id))
            frame.RegentLabel:SetPoint("TOPLEFT", frame.SkillDescription, "BOTTOMLEFT", 0, -10);
        else
            frame.SkillDescription:SetText(" ");
            frame.RegentLabel:SetPoint("TOPLEFT", frame.SkillDescription, "TOPLEFT", 0, 0);
        end

        frame.SkillDescription:Show();

        -- DF
        local function UpdateTooltip(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT");
            GameTooltip:SetTradeSkillItem(id);
            CursorUpdate(self);
        end
        frame.SkillIcon:SetScript('OnEnter', UpdateTooltip)

        frame.SkillIcon:SetScript('OnClick', function(self)
            HandleModifiedItemClick(GetTradeSkillItemLink(id));
        end)

        self.CreateButton:SetScript('OnClick', function()
            DoTradeSkill(id, self.InputBox:GetNumber());
            self.InputBox:ClearFocus();
        end)

        self.CreateAllButton:SetScript('OnClick', function()
            local _, _, numAvailable, _, _, _ = GetTradeSkillInfo(id);
            self.InputBox:SetNumber(numAvailable);
            DoTradeSkill(id, numAvailable);
            self.InputBox:ClearFocus();
        end)
    elseif self.CraftOpen then
    end
end

function DFProfessionMixin:CheckFilter()
    print('DFProfessionMixin:CheckFilter()')
end

function DFProfessionMixin:UpdateRecipeList()
    print('DFProfessionMixin:UpdateRecipeList()')
    local selectedKey = self.ProfessionTable[self.SelectedProfession]
    local recipeList = self.RecipeList

    if self.TradeSkillOpen then
        local numSkills = GetNumTradeSkills()
        local index = recipeList.selectedSkill
        if index > numSkills then index = GetFirstTradeSkill() end
        local changed = recipeList.selectedSkill ~= index
        recipeList.selectedSkill = index

        local oldScroll = recipeList.ScrollBox:GetScrollPercentage()

        recipeList:UpdateRecipeListTradeskill()

        recipeList:SelectRecipe(index, true)
        -- frameRef.FavoriteButton:UpdateFavoriteState()

        if (not changed) and (not force) then
            -- print('set old scroll')
            recipeList.ScrollBox:SetScrollPercentage(oldScroll, ScrollBoxConstants.NoScrollInterpolation)
        end

    elseif self.CraftOpen then
        -- self.RecipeList:ClearList()
    else
        recipeList:ClearList()
    end
end

-- FILTER
local DFFilter = {}

do
    local DFFilter_HasSkillUp = function(elementData)
        local skillType = elementData.recipeInfo.skillType
        local filter = DFFilter['DFFilter_HasSkillUp'].filter

        -- print('DFFilter_HasSkillUp', elementData.recipeInfo.skillType, filter[skillType])

        if filter[skillType] then
            return true
        else
            return false
        end
    end

    DFFilter['DFFilter_HasSkillUp'] = {
        name = 'DFFilter_HasSkillUp',
        filterDefault = {trivial = true, easy = true, medium = true, optimal = true, difficult = true},
        filter = {},
        func = DFFilter_HasSkillUp,
        enabled = false
    }
    DFFilter['DFFilter_HasSkillUp'].filter = DFFilter['DFFilter_HasSkillUp'].filterDefault
end

-- have materials
do
    local DFFilter_HaveMaterials = function(elementData)
        return elementData.recipeInfo.numAvailable > 0
    end

    DFFilter['DFFilter_HaveMaterials'] = {
        name = 'DFFilter_HaveMaterials',
        func = DFFilter_HaveMaterials,
        enabled = false
    }
end

-- searchbox
do
    local match = function(str, text)
        return strfind(strupper(str), strupper(text))
    end

    local DFFilter_Searchbox = function(elementData, searchBoxRef)
        --[[     local data = {
            id = i,
            isFavorite = isFavorite,
            recipeInfo = {
                name = skillName,
                skillType = skillType,
                numAvailable = numAvailable,
                isExpanded = isExpanded,
                altVerb = altVerb,
                numSkills = numSkills
            }
        } ]]
        local searchText = strupper(searchBoxRef:GetText())

        if searchText == '' then return true end

        local id = elementData.id
        local info = elementData.recipeInfo

        if match(info.name, searchText) then return true end

        local numReagents = GetTradeSkillNumReagents(id);

        for i = 1, numReagents do
            local reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(id, i);
            if reagentName and match(reagentName, searchText) then return true end
        end

        return false
    end

    DFFilter['DFFilter_Searchbox'] = {name = 'DFFilter_Searchbox', func = DFFilter_Searchbox, enabled = true}
end

------------------------------

DFProfessionFrameRecipeListMixin = CreateFromMixins(CallbackRegistryMixin);
DFProfessionFrameRecipeListMixin:GenerateCallbackEvents({"OnRecipeSelected"});

function DFProfessionFrameRecipeListMixin:OnLoad()
    -- print('DFProfessionFrameRecipeListTemplateMixin:OnLoad()')
    CallbackRegistryMixin.OnLoad(self);

    self.selectedSkill = 2
    self.selectedSkillTable = {}
    -- print('self.selectedSkill', self.selectedSkill)
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
                -- print('initCats', elementData.id, self.selectedSkill)

                button:SetScript("OnClick", function(button, buttonName)
                    node:ToggleCollapsed();
                    button:SetCollapseState(node:IsCollapsed());
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)

                    if elementData.categoryInfo.isExpanded then
                        -- CollapseTradeSkillSubClass(elementData.id)
                    else
                        -- ExpandTradeSkillSubClass(elementData.id)
                    end
                end);
            end
            factory("DFProfessionFrameRecipeCategoryTemplate", Initializer);
        elseif elementData.recipeInfo then
            local function Initializer(button, node)
                button:Init(node, false);

                -- print('init', elementData.id, self.selectedSkill)
                if elementData.id == self.selectedSkill then self.selectionBehavior:Select(button) end
                local selected = self.selectionBehavior:IsElementDataSelected(node);
                button:SetSelected(selected);

                button:SetScript("OnClick", function(button, buttonName, down)

                    if buttonName == "LeftButton" then
                        if IsModifiedClick() then
                            if elementData.isTradeskill then
                                HandleModifiedItemClick(GetTradeSkillRecipeLink(elementData.id));
                            elseif elementData.isCraft then
                            end
                        else
                            self.selectionBehavior:Select(button);
                        end
                    elseif buttonName == "RightButton" then
                    end

                    -- PlaySound(SOUNDKIT.UI_90_BLACKSMITHING_TREEITEMCLICK);
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
                end);

            end
            factory("DFProfessionFrameRecipeTemplate", Initializer);
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
        -- print('OnSelectionChanged', o, elementData, selected)
        local button = self.ScrollBox:FindFrame(elementData);
        if button then button:SetSelected(selected); end

        if selected then
            local data = elementData:GetData();

            local newRecipeID = data.id
            local changed = data.id ~= self.selectedSkill
            if changed then
                -- print('OnSelectionChanged-changed', data.id)
                self.selectedSkill = newRecipeID
                -- EventRegistry:TriggerEvent("DFProfessionsRecipeListMixin.Event.OnRecipeSelected", newRecipeID, self);

                -- TradeSkillFrame_SetSelection(newRecipeID)
                self:SelectRecipe(newRecipeID, false)
            end
        end
    end

    self.selectionBehavior = ScrollUtil.AddSelectionBehavior(self.ScrollBox);
    self.selectionBehavior:RegisterCallback(SelectionBehaviorMixin.Event.OnSelectionChanged, OnSelectionChanged, self);
end

function DFProfessionFrameRecipeListMixin:OnEvent(event, ...)
    -- print('DFProfessionsRecipeListMixin:OnEvent(event, ...)', event, ...)
end

function DFProfessionFrameRecipeListMixin:OnShow()
    -- print('DFProfessionsRecipeListMixin:OnShow()')    
    -- self:Refresh()
    -- EventRegistry:TriggerEvent("DFProfessionsRecipeListMixin.Event.OnRecipeSelected", self.selectedSkill, self);
end

function DFProfessionFrameRecipeListMixin:SelectRecipe(id, scrollToRecipe)
    local elementData = self.selectionBehavior:SelectElementDataByPredicate(function(node)
        local data = node:GetData();
        return data.recipeInfo and data.id == id
    end);

    if scrollToRecipe then
        self.ScrollBox:ScrollToElementData(elementData);
        -- ScrollBoxConstants.AlignCenter,  ScrollBoxConstants.RetainScrollPosition
    end

    self:TriggerEvent('OnRecipeSelected', id)

    return elementData;
end

function DFProfessionFrameRecipeListMixin:ClearList()
    local dataProvider = CreateTreeDataProvider();
    self.ScrollBox:SetDataProvider(dataProvider);
end

function DFProfessionFrameRecipeListMixin:UpdateRecipeListTradeskill()
    local dataProvider = CreateTreeDataProvider();

    local filterTable = DFFilter
    local numSkills = GetNumTradeSkills()
    local headerID = 0

    do
        local data = {id = 0, categoryInfo = {name = 'Favorites', isExpanded = true}}
        dataProvider:Insert(data)
    end

    for i = 1, numSkills do
        local skillName, skillType, numAvailable, isExpanded, altVerb, numSkillUps = GetTradeSkillInfo(i);

        if skillType == 'header' then
            local data = {id = i, categoryInfo = {name = skillName, isExpanded = isExpanded == 1}}
            dataProvider:Insert(data)
            headerID = i
        else
            -- print('--', skillName)
            local isFavorite = self:GetParent():IsRecipeFavorite(skillName)

            local data = {
                id = i,
                isFavorite = isFavorite,
                isTradeskill = true,
                recipeInfo = {
                    name = skillName,
                    skillType = skillType,
                    numAvailable = numAvailable,
                    isExpanded = isExpanded,
                    altVerb = altVerb,
                    numSkills = numSkills
                }
            }

            local filtered = true

            for k, filter in pairs(filterTable) do
                --
                if filter.enabled then
                    --
                    if not filter.func(data, self.SearchBox) then
                        --
                        filtered = false
                    end
                end
            end

            if filtered then
                --
                dataProvider:InsertInParentByPredicate(data, function(node)
                    local nodeData = node:GetData()

                    if data.isFavorite then
                        return nodeData.id == 0
                    else
                        return nodeData.id == headerID
                    end
                end)
            end
        end
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
        dataProvider:Remove(node)
    end

    -- print('UpdateRecipeList()', numSkills, dataProvider:GetSize(false))
    self.ScrollBox:SetDataProvider(dataProvider);
end

------------------------------

DFProfessionFrameRecipeCategoryMixin = {}

function DFProfessionFrameRecipeCategoryMixin:OnEnter()
    self.Label:SetFontObject(GameFontHighlight_NoShadow);
end

function DFProfessionFrameRecipeCategoryMixin:OnLeave()
    self.Label:SetFontObject(GameFontNormal_NoShadow);
end

function DFProfessionFrameRecipeCategoryMixin:Init(node)
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

function DFProfessionFrameRecipeCategoryMixin:SetCollapseState(collapsed)
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

DFProfessionFrameRecipeMixin = {}

function DFProfessionFrameRecipeMixin:OnLoad()
    local function OnLeave()
        self:OnLeave();
        GameTooltip_Hide();
    end

    self.LockedIcon:SetScript("OnLeave", OnLeave);
    self.SkillUps:SetScript("OnLeave", OnLeave);
end

local PROFESSION_RECIPE_COLOR = CreateColor(0.88627457618713, 0.86274516582489, 0.83921575546265, 1)

function DFProfessionFrameRecipeMixin:GetLabelColor()
    return PROFESSION_RECIPE_COLOR
    -- return self.learned and PROFESSION_RECIPE_COLOR or DISABLED_FONT_COLOR;
end

local PROFESSIONS_SKILL_UP_EASY = "Low chance of gaining skill"
local PROFESSIONS_SKILL_UP_MEDIUM = "High chance of gaining skill"
local PROFESSIONS_SKILL_UP_OPTIMAL = "Guaranteed chance of gaining %d skill ups"

function DFProfessionFrameRecipeMixin:Init(node, hideCraftableCount)
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

    local count = recipeInfo.numAvailable -- + 69
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

function DFProfessionFrameRecipeMixin:SetLabelFontColors(color)
    self.Label:SetVertexColor(color:GetRGB());
    self.Count:SetVertexColor(color:GetRGB());
end

function DFProfessionFrameRecipeMixin:OnEnter()
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

function DFProfessionFrameRecipeMixin:OnLeave()
    self:SetLabelFontColors(self:GetLabelColor());
    GameTooltip:Hide();
end

function DFProfessionFrameRecipeMixin:SetSelected(selected)
    self.SelectedOverlay:SetShown(selected);
    self.HighlightOverlay:SetShown(not selected);
end

------------------------------
DFProfessionFrameSearchBoxMixin = {}

function DFProfessionFrameSearchBoxMixin:OnLoad()
    -- print('DFProfessionSearchBoxTemplateMixin:OnLoad()')
end

function DFProfessionFrameSearchBoxMixin:OnHide()
    -- print('DFProfessionSearchBoxTemplateMixin:OnHide()')
    self.clearButton:Click();
    SearchBoxTemplate_OnTextChanged(self);
end

function DFProfessionFrameSearchBoxMixin:OnTextChanged()
    -- print('DFProfessionSearchBoxTemplateMixin:OnTextChanged()')
    SearchBoxTemplate_OnTextChanged(self);
    -- frameRef:OnEvent('TRADE_SKILL_FILTER_UPDATE')
    self:GetParent():GetParent():OnEvent('TRADE_SKILL_FILTER_UPDATE')
end

function DFProfessionFrameSearchBoxMixin:OnChar()
    -- print('DFProfessionSearchBoxTemplateMixin:OnChar()')
    -- clear focus if the player is repeating keys (ie - trying to move)
    -- TODO: move into base editbox code?
    local MIN_REPEAT_CHARACTERS = 4;
    local searchString = self:GetText();
    if (string.len(searchString) >= MIN_REPEAT_CHARACTERS) then
        local repeatChar = true;
        for i = 1, MIN_REPEAT_CHARACTERS - 1, 1 do
            if (string.sub(searchString, (0 - i), (0 - i)) ~= string.sub(searchString, (-1 - i), (-1 - i))) then
                repeatChar = false;
                break
            end
        end
        if (repeatChar) then self:ClearFocus(); end
    end
end

