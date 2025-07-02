local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

local CreateColor = DFCreateColor;

-- filter
local DFFilter = {}

DFProfessionMixin = {}

function DFProfessionMixin:OnLoad()
    self:SetupFavoriteDatabase()

    self.minimized = false
    self.ProfessionTable = {}
    self.SelectedProfession = ''
    self.SelectedSkillID = ''

    self:SetupFrameStyle()
    self:SetupSchematics()
    self:SetupDropdown()
    self:SetupTabs()
    self:SetupFavorite()
    self:Minimize(self.minimized)

    self:Refresh(true)
    self:Show()

    if SpellBookFrame_Update then
        hooksecurefunc('SpellBookFrame_Update', function()
            --
            -- print('SpellBookFrame_Update')
            self:Refresh(true)
        end)
    end

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
        CloseTradeSkill()
        CloseCraft()
    end);

    self.RecipeList.ResetButton:SetScript('OnClick', function(btn)
        --
        self:ResetFilter()
    end)

    -- blizzmove
    self:AddBlizzMoveSupport();
end

function DFProfessionMixin:OnShow()
end

function DFProfessionMixin:OnHide()
end

function DFProfessionMixin:ShouldShow(should)
    -- print('~~~~~ should show', should)
    if should then
        self:Show()

        if self.TradeSkillOpen then
            self:ClearAllPoints()
            self:SetPoint('TOPLEFT', TradeSkillFrame, 'TOPLEFT', 12, -12)

            TradeSkillFrame:SetFrameStrata('BACKGROUND')
            self:SetFrameStrata('MEDIUM')

            self:UpdateUIPanelWindows(not self.minimized)
        elseif self.CraftOpen then
            self:ClearAllPoints()
            self:SetPoint('TOPLEFT', CraftFrame, 'TOPLEFT', 12, -12)

            CraftFrame:SetFrameStrata('BACKGROUND')
            self:SetFrameStrata('MEDIUM')

            self:UpdateUIPanelWindows(not self.minimized)
        end
    else
        self:Hide()
    end
end

function DFProfessionMixin:OnEvent(event, arg1, ...)
    -- print('~~', event, arg1 and arg1 or '')
    if event == 'TRADE_SKILL_SHOW' then
        self.TradeSkillOpen = true;
        self.CraftOpen = false;
        CloseCraft()
        self:ShouldShow(true)
        self:Refresh(true)
    elseif event == 'CRAFT_SHOW' then
        self.TradeSkillOpen = false;
        self.CraftOpen = true;
        CloseTradeSkill()
        self:ShouldShow(true)
        self:Refresh(true)
    elseif event == 'TRADE_SKILL_CLOSE' then
        self.TradeSkillOpen = false;
        if not self.CraftOpen then self:ShouldShow(false) end
    elseif event == 'CRAFT_CLOSE' then
        self.CraftOpen = false;
        if not self.TradeSkillOpen then self:ShouldShow(false) end
    elseif event == 'TRADE_SKILL_UPDATE' or event == 'TRADE_SKILL_FILTER_UPDATE' or event == 'CRAFT_UPDATE' then
        if self:IsShown() then self:Refresh(false) end
    elseif event == 'PLAYER_REGEN_ENABLED' then
        if self.ShouldUpdate then self:UpdateTabs() end
    elseif event == 'UNIT_PET_TRAINING_POINTS' then
        self:UpdateTrainingPoints()
    elseif event == 'SPELLS_CHANGED' then
        self:Refresh(true)
    end
end

local frameWidth = 942 - 164
local frameWidthSmall = 404 - 50

function DFProfessionMixin:Minimize(mini)
    self.minimized = mini

    if mini then
        -- 
        self:SetWidth(frameWidthSmall)
        self:UpdateUIPanelWindows(false)

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

        self:UpdateUIPanelWindows(true)

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

function DFProfessionMixin:UpdateUIPanelWindows(big)
    if TradeSkillFrame then
        -- print('UIPanel', 'TradeSkillFrame', big)
        if big then
            TradeSkillFrame:SetAttribute("UIPanelLayout-width", frameWidth);
        else
            TradeSkillFrame:SetAttribute("UIPanelLayout-width", frameWidthSmall);
        end
        UpdateUIPanelPositions(TradeSkillFrame)
    end

    if CraftFrame then
        -- print('UIPanel', 'CraftFrame', big)
        if big then
            CraftFrame:SetAttribute("UIPanelLayout-width", frameWidth);
        else
            CraftFrame:SetAttribute("UIPanelLayout-width", frameWidthSmall);
        end
        UpdateUIPanelPositions(CraftFrame)
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
        create:SetFrameLevel(10)
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

    -- pet training points @ERA
    if DF.Era then
        local trainingFrame = CreateFrame('Frame', 'DragonflightUIProfessionTrainingPointFrame', self)
        trainingFrame:SetSize(120, 18)
        -- trainigFrame:SetPoint('TOPLEFT', self, 'TOPLEFT', 280, -40) 
        trainingFrame:SetPoint('RIGHT', CraftCreateButton, 'LEFT', -12, 0)
        self.TrainingFrame = trainingFrame

        local trainingLabel = trainingFrame:CreateFontString('', 'ARTWORK', 'GameFontNormalSmall')
        trainingLabel:SetPoint('LEFT', trainingFrame, 'LEFT', 10, 0)
        trainingLabel:SetText(TRAINING_POINTS)
        self.TrainingFrameLabel = trainingLabel

        local trainingText = trainingFrame:CreateFontString('', 'ARTWORK', 'GameFontHighlightSmall')
        trainingText:SetPoint('LEFT', trainingLabel, 'RIGHT', 6, 0)
        trainingText:SetText('69 TP')
        self.TrainingFrameText = trainingText

        local newW = trainingLabel:GetUnboundedStringWidth() + trainingText:GetUnboundedStringWidth() + 10 + 6
        trainingFrame:SetWidth(newW)

        trainingFrame:Hide()
    end

end

function DFProfessionMixin:UpdateTrainingPoints()
    -- print('..UpdateTrainingPoints()')
    if not self.TrainingFrame then return end

    if self.TradeSkillOpen then
        self.TrainingFrame:Hide()
    elseif self.CraftOpen then
        if self.SelectedProfession == 'beast' then
            self.TrainingFrame:Show()

            local totalPoints, spent = GetPetTrainingPoints();
            if (totalPoints > 0) then
                self.TrainingFrameLabel:Show();
                self.TrainingFrameText:Show();
                self.TrainingFrameText:SetText(totalPoints - spent);
            else
                self.TrainingFrameLabel:Hide();
                self.TrainingFrameText:Hide();
            end
        else
            self.TrainingFrame:Hide()
        end
    else
        self.TrainingFrame:Hide()
    end
end

function DFProfessionMixin:AddBlizzMoveSupport()
    DF.Compatibility:FuncOrWaitframe('BlizzMove', function()
        --
        -- print('blizzmovess')
        if not BlizzMoveAPI or not BlizzMoveAPI.RegisterAddOnFrames then return end

        local data = {['DragonflightUI'] = {['DragonflightUIProfessionFrame'] = {}}}

        if TradeSkillFrame then TradeSkillFrame:SetAlpha(0); end
        if CraftFrame then CraftFrame:SetAlpha(0); end

        BlizzMoveAPI:RegisterAddOnFrames(data)
    end)
end

local MAX_TRADE_SKILL_REAGENTS = 8 -- 8

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

    local iconOverlay = DragonflightUIItemColorMixin:AddOverlayToFrame(icon)
    iconOverlay:SetPoint('TOPLEFT', icon, 'TOPLEFT', 0, 0)
    iconOverlay:SetPoint('BOTTOMRIGHT', icon, 'BOTTOMRIGHT', 0, 0)

    local iconCount = icon:CreateFontString('DragonflightUIProfession' .. 'IconCount', 'OVERLAY', 'NumberFontNormal')
    -- iconCount:SetSize(244, 10)
    iconCount:SetText('*1*')
    iconCount:SetJustifyH('RIGHT')
    iconCount:SetPoint('BOTTOMRIGHT', icon, 'BOTTOMRIGHT', -5, 2)
    frame.SkillIconCount = iconCount

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
    -- reqText:SetSize(250, 9.9)
    reqText:SetJustifyH("LEFT");
    reqText:SetPoint('TOPLEFT', req, 'TOPRIGHT', 4, 0)
    reqText:SetPoint('RIGHT', frame, 'RIGHT', -28, 0)
    frame.RequirementText = reqText

    local cost = frame:CreateFontString('DragonflightUIProfession' .. 'CostLabel', 'BACKGROUND',
                                        'GameFontHighlightSmall')
    cost:SetPoint('TOPLEFT', req, 'BOTTOMLEFT', 0, -4)
    cost:SetText(COSTS_LABEL)
    frame.CostLabel = cost

    local costText = frame:CreateFontString('DragonflightUIProfession' .. 'CostText', 'BACKGROUND',
                                            'GameFontHighlightSmall')
    costText:SetSize(250, 9.9)
    costText:SetJustifyH("LEFT");
    costText:SetPoint('LEFT', cost, 'RIGHT', 4, 0)
    frame.CostText = costText

    local cooldown = frame:CreateFontString('DragonflightUIProfession' .. 'SkillCooldown', 'BACKGROUND',
                                            'GameFontRedSmall')
    cooldown:SetPoint('TOPLEFT', req, 'BOTTOMLEFT', 0, 0)
    frame.SkillCooldown = cooldown

    local descr = frame:CreateFontString('DragonflightUIProfession' .. 'SkillDescription', 'BACKGROUND',
                                         'GameFontHighlightSmall')
    descr:SetPoint('TOPLEFT', icon, 'BOTTOMLEFT', -1, -12)
    descr:SetPoint('RIGHT', frame, 'RIGHT', -28, 0)
    descr:SetText('*descr*')
    descr:SetJustifyH('LEFT')
    frame.SkillDescription = descr

    local extra = CreateFrame("Frame", 'DragonflightUIProfessionFrameExtraDataFrame', self)
    extra:SetPoint('TOPLEFT', icon, 'BOTTOMLEFT', -1, -12)
    extra:SetPoint('RIGHT', frame, 'RIGHT', -28, 0)
    extra:SetHeight(1)
    frame.ExtraDataFrame = extra

    -- reagents
    local reagentLabel = frame:CreateFontString('DragonflightUIProfession' .. 'ReagentLabel', 'BACKGROUND',
                                                'GameFontNormalSmall')
    -- reagentLabel:SetPoint('TOPLEFT', icon, 'BOTTOMLEFT', -1, -12)
    reagentLabel:SetPoint('TOPLEFT', extra, 'BOTTOMLEFT', -1, 0)
    reagentLabel:SetText(SPELL_REAGENTS)
    frame.RegentLabel = reagentLabel

    frame.ReagentTable = {}
    for i = 1, MAX_TRADE_SKILL_REAGENTS do
        --
        local reagent = CreateFrame('BUTTON', 'DragonflightUIProfession' .. 'Reagent' .. i, frame, 'QuestItemTemplate',
                                    i)
        if i <= 6 then
            reagent:SetPoint('TOPLEFT', reagentLabel, 'TOPLEFT', 1, -23 - (i - 1) * 45)
        else
            reagent:SetPoint('TOPLEFT', frame.ReagentTable[i - 2], 'TOPRIGHT', 6, 0)
        end
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

function DFProfessionMixin:SetupDropdown()
    local drop = self.RecipeList.FilterButton
    drop.Text:SetPoint('TOP', drop, 'TOP', 0, 0)

    local generator = function(dropdown, rootDescription)
        rootDescription:SetTag("MENU_PROFESSIONS_FILTER");
        -- rootDescription:CreateTitle('TITLETEST')

        -- DFFilter_HasSkillUp
        do
            local function IsSelected()
                return DFFilter['DFFilter_HasSkillUp'].enabled;
            end

            local function SetChecked(checked)
                if checked then
                    DFFilter['DFFilter_HasSkillUp'].enabled = true
                    DFFilter['DFFilter_HasSkillUp'].filter = {easy = true, medium = true, optimal = true}
                else
                    DFFilter['DFFilter_HasSkillUp'].enabled = false
                    DFFilter['DFFilter_HasSkillUp'].filter = DFFilter['DFFilter_HasSkillUp'].filterDefault
                end
            end

            rootDescription:CreateCheckbox(L["ProfessionFrameHasSkillUp"], IsSelected, function()
                SetChecked(not DFFilter['DFFilter_HasSkillUp'].enabled)
                self:UpdateRecipeList()
                self:CheckFilter()
            end);
        end

        -- DFFilter_HaveMaterials
        do
            local function IsSelected()
                return DFFilter['DFFilter_HaveMaterials'].enabled;
            end

            local function SetChecked(checked)
                if checked then
                    DFFilter['DFFilter_HaveMaterials'].enabled = true
                else
                    DFFilter['DFFilter_HaveMaterials'].enabled = false
                end
            end

            rootDescription:CreateCheckbox(L["ProfessionFrameHasMaterials"], IsSelected, function()
                SetChecked(not DFFilter['DFFilter_HaveMaterials'].enabled)
                self:UpdateRecipeList()
                self:CheckFilter()
            end);
        end

        rootDescription:CreateDivider();

        -- subclass
        do
            -- subclassMenu:CreateButton(L["ProfessionCheckAll"], function()
            --     --
            -- end);
            -- subclassMenu:CreateButton(L["ProfessionUnCheckAll"], function()
            --     --
            -- end);
            local subClasses;
            local IsSelected;
            local SetSelected;

            if self.TradeSkillOpen then
                subClasses = {GetTradeSkillSubClasses()}

                local dropDown = TradeSkillSubClassDropDown or TradeSkillSubClassDropdown -- TODO: blizzard changed this in SoD for some reason..

                function IsSelected(k)
                    local allCheckedSub = GetTradeSkillSubClassFilter(0);

                    if k == 0 then
                        local selectedIDSub = UIDropDownMenu_GetSelectedID(dropDown) or 1;
                        return allCheckedSub and (selectedIDSub == nil or selectedIDSub == 1)
                    else
                        local checked

                        if allCheckedSub then
                            checked = false
                        else
                            checked = GetTradeSkillSubClassFilter(k)
                        end
                        return checked;
                    end
                end

                function SetSelected(k)
                    if GetTradeSkillSubClassFilter(k) then
                        SetTradeSkillSubClassFilter(k, 0, 1)
                    else
                        SetTradeSkillSubClassFilter(k, 1, 1)
                    end
                    self:UpdateRecipeList()
                    self:CheckFilter()
                end
            elseif self.CraftOpen then
            end

            if subClasses then
                if #subClasses > 0 then
                    local subclassMenu = rootDescription:CreateButton(L["ProfessionFrameSubclass"]);

                    local radioAll = subclassMenu:CreateRadio(ALL_SUBCLASSES, IsSelected, SetSelected, 0);

                    for k, v in ipairs(subClasses) do
                        -- 
                        local radio = subclassMenu:CreateRadio(v, IsSelected, SetSelected, k);
                    end
                end
            end
        end

        -- slot
        do
            -- subclassMenu:CreateButton(L["ProfessionCheckAll"], function()
            --     --
            -- end);
            -- subclassMenu:CreateButton(L["ProfessionUnCheckAll"], function()
            --     --
            -- end);
            local subInv;
            local IsSelected;
            local SetSelected;

            if self.TradeSkillOpen then
                subInv = {GetTradeSkillInvSlots()}

                function IsSelected(k)
                    local allCheckedInv = GetTradeSkillInvSlotFilter(0);

                    if k == 0 then
                        return allCheckedInv
                    else
                        local checked

                        if allCheckedInv then
                            checked = nil
                        else
                            checked = GetTradeSkillInvSlotFilter(k)
                        end
                        return checked;
                    end
                end

                function SetSelected(k)
                    if GetTradeSkillInvSlotFilter(k) then
                        SetTradeSkillInvSlotFilter(k, 0, 1)
                    else
                        SetTradeSkillInvSlotFilter(k, 1, 1)
                    end
                    self:UpdateRecipeList()
                    self:CheckFilter()
                end
            elseif self.CraftOpen then
            end

            if subInv then
                if #subInv > 0 then
                    local slotMenu = rootDescription:CreateButton(L["ProfessionFrameSlot"]);

                    local radioAll = slotMenu:CreateRadio(ALL_INVENTORY_SLOTS, IsSelected, SetSelected, 0);
                    for k, v in ipairs(subInv) do
                        -- 
                        local radio = slotMenu:CreateRadio(v, IsSelected, SetSelected, k);
                    end
                end
            end

        end
    end
    drop:SetupMenu(generator)
end

function DFProfessionMixin:SetupTabs()
    local tabFrame = CreateFrame('FRAME', 'DragonflightUIProfessionFrameTabFrame', self)

    self.DFTabFrame = tabFrame
    local numTabs = 8
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
            -- DragonflightUICharacterTabMixin:Tab_OnClick(self, tabFrame)
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
                profIndex = 'beast'
            elseif i == 7 then
                profIndex = 'runeforging'
            end

            -- if self.SelectedProfession == profIndex then return end

            local prof = self.ProfessionTable[profIndex]
            if not prof then return end

            if tabFrame.selectedTab == i then return end
            -- print('nameLoc:', prof.nameLoc)

            local spellToCast = prof.nameLoc
            -- print('cast:', spellToCast)

            if spellToCast == 'Costura' then
                spellToCast = 'Sastrería'
            elseif spellToCast == 'Marroquinería' then
                spellToCast = 'Peletería'
            elseif spellToCast == 'Minería' then
                spellToCast = 'Fundiendo'
            elseif spellToCast == 'Secourisme' then
                spellToCast = 'Premiers soins'
            end

            if spellToCast == DragonflightUILocalizationData.DF_CHARACTER_PROFESSIONMINING then
                spellToCast = DragonflightUILocalizationData.DF_PROFESSIONS_SMELTING
            end

            -- print('~~cast:', spellToCast)
            if prof.skillID == 182 or prof.skillID == 393 then return end
            CastSpellByName(spellToCast)
        end

        tab:SetScript('OnClick', onClick)
        tab.DFOnClick = onClick

        DragonflightUIMixin:TabResize(tab)
    end
end

function DFProfessionMixin:UpdateTabs()
    -- print('DFProfessionMixin:UpdateTabs()')
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
        tab:Show()
        tab:SetText(prof1.nameLoc)
        setupTooltip(tab, prof1)
        tab.isDisabled = (prof1.skillID == 182 or prof1.skillID == 393)
        if self.SelectedProfession == 'primary1' then DragonflightUICharacterTabMixin:Tab_OnClick(tab, tabFrame) end
    else
        tab:Hide()
        tab:SetText('***')
    end

    local prof2 = self.ProfessionTable['primary2'];
    tab = tabs[2]
    if prof2 then
        tab:Enable()
        tab:Show()
        tab:SetText(prof2.nameLoc)
        setupTooltip(tab, prof2)
        tab.isDisabled = (prof2.skillID == 182 or prof2.skillID == 393)
        if self.SelectedProfession == 'primary2' then DragonflightUICharacterTabMixin:Tab_OnClick(tab, tabFrame) end
    else
        tab:Hide()
        tab:SetText('***')
    end

    local prof3 = self.ProfessionTable['cooking'];
    tab = tabs[3]
    if prof3 then
        tab:Enable()
        tab:Show()
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
        tab:Show()
        tab:SetText(prof4.nameLoc)
        setupTooltip(tab, prof4)
        if self.SelectedProfession == 'firstaid' then DragonflightUICharacterTabMixin:Tab_OnClick(tab, tabFrame) end
    else
        tab:Hide()
        tab:SetText('***')
    end

    -- 
    local prof5 = self.ProfessionTable['poison'];
    tab = tabs[5]
    if prof5 then
        tab:Enable()
        tab:Show()
        tab:SetText(prof5.nameLoc)
        setupTooltip(tab, prof5)
        if self.SelectedProfession == 'poison' then DragonflightUICharacterTabMixin:Tab_OnClick(tab, tabFrame) end
    else
        tab:Hide()
        tab:SetText('***')
    end

    -- 
    local prof6 = self.ProfessionTable['beast'];
    tab = tabs[6]
    if prof6 then
        tab:Enable()
        tab:Show()
        tab:SetText(prof6.nameLoc)
        setupTooltip(tab, prof6)
        if self.SelectedProfession == 'beast' then DragonflightUICharacterTabMixin:Tab_OnClick(tab, tabFrame) end
    else
        tab:Hide()
        tab:SetText('***')
    end

    -- 
    local prof7 = self.ProfessionTable['runeforging'];
    tab = tabs[7]
    if prof7 then
        tab:Enable()
        tab:Show()
        tab:SetText(prof7.nameLoc)
        setupTooltip(tab, prof7)
        if self.SelectedProfession == 'runeforging' then
            DragonflightUICharacterTabMixin:Tab_OnClick(tab, tabFrame)
        end
    else
        tab:Hide()
        tab:SetText('***')
    end

    -- 
    local prof8 = nil;
    tab = tabs[8]
    if prof8 then
        tab:Enable()
        tab:Show()
        tab:SetText(prof8.nameLoc)
        setupTooltip(tab, prof8)
        if self.SelectedProfession == 'beast' then DragonflightUICharacterTabMixin:Tab_OnClick(tab, tabFrame) end
    else
        tab:Hide()
        tab:SetText('***')
    end

    local tmp;

    for k, v in ipairs(tabs) do
        --
        local w = v.Text:GetWrappedWidth()
        local newW = math.max(w + 16, 78)
        if v:IsShown() then
            v:SetWidth(newW)
            v:ClearAllPoints()
            if tmp then
                v:SetPoint('LEFT', tmp, 'RIGHT', 4, 0)
            else
                v:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 12, 2)
            end
            tmp = v
        else
            v:SetWidth(0.01)
        end
    end
end

function DFProfessionMixin:SetupFavorite()
    local fav = self.FavoriteButton
    fav:SetPoint('LEFT', self.SchematicForm.SkillName, 'RIGHT', 4, 1)
    -- fav:SetPoint('LEFT', self, 'RIGHT', 20, 0)

    fav:GetNormalTexture():SetTexture(base .. 'auctionhouse')
    -- fav:GetNormalTexture():SetTexCoord(0.94043, 0.979492, 0.0957031, 0.166016)
    fav:GetNormalTexture():SetTexCoord(0.94043, 0.979492, 0.169922, 0.240234)

    fav:GetHighlightTexture():SetTexture(base .. 'auctionhouse')
    fav:GetHighlightTexture():SetTexCoord(0.94043, 0.979492, 0.169922, 0.240234)

    function fav:SetIsFavorite(isFavorite)
        if isFavorite then
            fav:GetNormalTexture():SetTexCoord(0.94043, 0.979492, 0.0957031, 0.166016)
            fav:GetHighlightTexture():SetTexCoord(0.94043, 0.979492, 0.0957031, 0.166016)
            fav:GetHighlightTexture():SetAlpha(0.2)
        else
            fav:GetNormalTexture():SetTexCoord(0.94043, 0.979492, 0.169922, 0.240234)
            fav:GetHighlightTexture():SetTexCoord(0.94043, 0.979492, 0.169922, 0.240234)
            fav:GetHighlightTexture():SetAlpha(0.4)
        end
        fav.IsFavorite = isFavorite
        fav:SetChecked(isFavorite)
    end
    -- fav:SetIsFavorite(false)  

    local frame = self;

    function fav:UpdateFavoriteState()
        -- print('fav:UpdateFavoriteState()')
        -- local tradeSkillIndex = GetTradeSkillSelectionIndex();
        -- local skillName, skillType, numAvailable, isExpanded, altVerb, numSkillUps = GetTradeSkillInfo(tradeSkillIndex)
        -- fav:SetIsFavorite(self:IsRecipeFavorite(skillName))
        if frame.TradeSkillOpen then
            local index = frame.RecipeList.selectedSkill
            local skillName, skillType, numAvailable, isExpanded, altVerb, numSkillUps = GetTradeSkillInfo(index)
            fav:SetIsFavorite(frame:IsRecipeFavorite(skillName))
        elseif frame.CraftOpen then
            local craftIndex = GetCraftSelectionIndex();
            local skillName, craftSubSpellName, skillType, numAvailable, isExpanded, trainingPointCost, requiredLevel =
                GetCraftInfo(craftIndex)
            fav:SetIsFavorite(frame:IsRecipeFavorite(skillName))
        else
            fav:SetIsFavorite(false)
        end
    end
    fav:UpdateFavoriteState()

    local function SetFavoriteTooltip(button)
        GameTooltip:SetOwner(button, "ANCHOR_RIGHT");
        GameTooltip_AddHighlightLine(GameTooltip, button:GetChecked() and BATTLE_PET_UNFAVORITE or BATTLE_PET_FAVORITE);
        GameTooltip:Show();
    end

    fav:SetScript('OnClick', function(button, buttonName, down)
        local checked = button:GetChecked();
        -- C_TradeSkillUI.SetRecipeFavorite(currentRecipeInfo.recipeID, checked);
        do
            local info;
            if self.TradeSkillOpen then
                local index = self.RecipeList.selectedSkill
                local skillName, skillType, numAvailable, isExpanded, altVerb, numSkillUps = GetTradeSkillInfo(index)
                info = skillName
            elseif self.CraftOpen then
                local craftIndex = GetCraftSelectionIndex();
                local skillName, craftSubSpellName, skillType, numAvailable, isExpanded, trainingPointCost,
                      requiredLevel = GetCraftInfo(craftIndex)
                info = skillName
            else
                return;
            end

            frame:SetRecipeFavorite(info, checked)
            frame:Refresh(false)
        end
        button:SetIsFavorite(checked)
        SetFavoriteTooltip(button)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
    end)

    fav:SetScript("OnEnter", function(button)
        SetFavoriteTooltip(button);
    end);

    fav:SetScript("OnLeave", GameTooltip_Hide);
end

function DFProfessionMixin:SetupFavoriteDatabase()
    self.db = DF.db:RegisterNamespace('RecipeFavorite', {profile = {favorite = {}}})
end

function DFProfessionMixin:SetRecipeFavorite(info, checked)
    -- print('SetRecipeFavorite', info, checked)
    local db = self.db.profile

    if checked then
        db.favorite[info] = true
    else
        db.favorite[info] = nil
    end
end

function DFProfessionMixin:IsRecipeFavorite(info)
    -- print('IsRecipeFav', info)
    local db = self.db.profile

    if db.favorite[info] then
        -- print('~true')
        return true
    else
        return false
    end
end

function DFProfessionMixin:Refresh(force)
    -- print('DFProfessionMixin:Refresh(force)', force)
    self:UpdateProfessionData()

    self:SetCurrentProfession()
    -- print('==', self.SelectedProfession)

    if InCombatLockdown() then
        -- prevent unsecure update in combat TODO: message?
        self.ShouldUpdate = true
    else
        self.ShouldUpdate = false
        self:UpdateTabs()
    end

    if not self.SelectedProfession then
        -- print('-- no self.SelectedProfession')
        return
    end

    self:UpdateHeader()
    self:UpdateRecipeList()
    -- self:UpdateRecipe()
    self:CheckFilter()
end

function DFProfessionMixin:SetCurrentProfession()
    -- print('DFProfessionMixin:SetCurrentProfession()')
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

    -- linked profession
    local isLink, playerName = IsTradeSkillLinked()
    if (DF.Cata or DF.API.Version.IsWotlk) and isLink and playerName and playerName ~= '' then
        --
        -- print('SetCurrentProfession LINKED')
        local tradeskillName, currentLevel, maxLevel, skillLineModifier = GetTradeSkillLine()

        local skillID = DragonflightUILocalizationData:GetSkillIDFromProfessionName(tradeskillName)

        if skillID then
            local profDataTable = self.ProfessionDataTable[skillID]

            self.ProfessionTable['linked'] = {
                nameLoc = tradeskillName,
                icon = profDataTable.icon,
                skillID = skillID,
                skill = currentLevel,
                maxSkill = maxLevel,
                profData = profDataTable
            }

            self.SelectedProfession = 'linked'
            return 'linked'
        end

    end

    self.ProfessionTable['linked'] = nil;

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
    professionDataTable[667] = {tex = 'professionbackgroundart', bar = 'professionsfxskinning', icon = 132162} -- beast training
    professionDataTable[668] = {tex = 'professionbackgroundart', bar = 'professionsfxskinning', icon = 237523} -- cata: runeforging
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
local ignoredPrimary = {182, 393}
local profs = {
    primary = {},
    ignoredPrimary = {},
    poison = 666,
    fishing = 356,
    cooking = 185,
    firstaid = 129,
    beast = 667,
    runeforging = 668
}
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
        -- runeforging
        local localizedClass, englishClass, classIndex = UnitClass('player')
        if englishClass == 'DEATHKNIGHT' then
            local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(53428)
            local skillLine = 668
            skillTable['runeforging'] = {
                nameLoc = name,
                icon = icon,
                skillID = skillLine,
                skill = 1,
                maxSkill = 1,
                profData = professionDataTable[skillLine]
            }
        end
    elseif DF.Wrath then
        for i = 1, GetNumSkillLines() do
            local nameLoc, _, _, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost,
                  rankCost, minLevel, skillCostType, skillDescription = GetSkillLineInfo(i)

            local skillID = DragonflightUILocalizationData:GetSkillIDFromProfessionName(nameLoc)

            if skillID then
                --
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
                    -- local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(2580)
                    -- nameLoc = name
                    -- spellIcon = icon
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

        -- beast training rip
        if IsSpellKnown(5149) or IsSpellKnown(5300) then
            -- beast training

            local nameLoc = DragonflightUILocalizationData.DF_PROFESSIONS_BEAST
            local skillID = DragonflightUILocalizationData:GetSkillIDFromProfessionName(nameLoc)
            local profData = professionDataTable[skillID]

            local data = {
                nameLoc = nameLoc,
                icon = profData.icon,
                skillID = skillID, -- only era @TODO
                -- lineID = i,
                skill = 1,
                maxSkill = 1,
                -- skillModifier = skillModifier, -- only era= @TODO
                profData = profData
            }

            skillTable['beast'] = data
        end
    elseif DF.Era then
        for i = 1, GetNumSkillLines() do
            local nameLoc, _, _, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost,
                  rankCost, minLevel, skillCostType, skillDescription = GetSkillLineInfo(i)

            local skillID = DragonflightUILocalizationData:GetSkillIDFromProfessionName(nameLoc)

            if skillID then
                --
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
                    -- local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(2580)
                    -- nameLoc = name
                    -- spellIcon = icon
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

        -- beast training rip
        if IsSpellKnown(5149) or IsSpellKnown(5300) then
            -- beast training

            local nameLoc = DragonflightUILocalizationData.DF_PROFESSIONS_BEAST
            local skillID = DragonflightUILocalizationData:GetSkillIDFromProfessionName(nameLoc)
            local profData = professionDataTable[skillID]

            local data = {
                nameLoc = nameLoc,
                icon = profData.icon,
                skillID = skillID, -- only era @TODO
                -- lineID = i,
                skill = 1,
                maxSkill = 1,
                -- skillModifier = skillModifier, -- only era= @TODO
                profData = profData
            }

            skillTable['beast'] = data
        end
    end

    self.ProfessionTable = skillTable

    return skillTable;
end

function DFProfessionMixin:UpdateHeader()
    -- print('DFProfessionMixin:UpdateHeader()', self.SelectedProfession)

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
    -- self.LinkButton:Hide() -- @TODO

    self.SchematicForm.Background:SetTexture(base .. prof.profData.tex)

    local newStatusTexture = base .. prof.profData.bar
    if newStatusTexture ~= self.RankFrame.DFStatusTexture then
        self.RankFrameBar:SetStatusBarTexture(base .. prof.profData.bar)
        self.RankFrame.DFStatusTexture = base .. prof.profData.bar
    end

    self.RankFrame:UpdateRankFrame(prof.skill, 0, prof.maxSkill)
end

function DFProfessionMixin:GetRecipeQuality(index)
    if not self.ScanningTooltip then
        local tt = CreateFrame("GameTooltip", "DragonflightUIScanningTooltip", nil, "GameTooltipTemplate")
        tt:SetOwner(WorldFrame, "ANCHOR_NONE");
        self.ScanningTooltip = tt
    end

    if not index or index == 0 then return 1 end

    local tooltip = self.ScanningTooltip

    if self.TradeSkillOpen then
        tooltip:SetTradeSkillItem(index)
    elseif self.CraftOpen then
        tooltip:SetCraftSpell(index)
    else
        return 1
    end

    local name, link = tooltip:GetItem()

    if not link then return 1 end

    local itemString = string.match(link, "item[%-?%d:]+")
    if not itemString then return 1; end

    local _, itemIdStr = strsplit(":", itemString)
    local itemId = tonumber(itemIdStr)
    if not itemId or itemId == "" then return 1; end

    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc,
          itemTexture, itemSellPrice, classID = C_Item.GetItemInfo(link)
    if not itemLevel or not itemId then return 1 end

    return itemRarity
end

function DFProfessionMixin:UpdateRecipe(id)
    -- print('DFProfessionMixin:UpdateRecipe()', id)
    local frame = self.SchematicForm

    if self.TradeSkillOpen then
        local skillName, skillType, numAvailable, isExpanded, altVerb, numSkillUps, indentLevel, showProgressBar,
              currentRank, maxRank, startingRank = GetTradeSkillInfo(id)

        frame.SkillName:SetText(skillName)
        frame.SkillName:SetWidth(frame.SkillName:GetUnboundedStringWidth())

        local quality = DFProfessionMixin:GetRecipeQuality(id)
        local r, g, b, hex = C_Item.GetItemQualityColor(quality)
        frame.SkillName:SetTextColor(r, g, b)

        DragonflightUIItemColorMixin:UpdateOverlayQuality(frame.SkillIcon, quality)

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
                frame.SkillIconCount:SetText(minMade);
            else
                frame.SkillIconCount:SetText(minMade .. "-" .. maxMade);
            end
            if (frame.SkillIconCount:GetWidth() > 39) then
                frame.SkillIconCount:SetText("~" .. floor((minMade + maxMade) / 2));
            end
        else
            frame.SkillIconCount:SetText("");
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
        frame.CostLabel:Hide()
        frame.CostText:SetText('')

        self.CreateButton:SetText(altVerb or CREATE_PROFESSION);

        if (creatable) then
            self.CreateButton:Enable();
            self.CreateAllButton:Enable();
        else
            self.CreateButton:Disable();
            self.CreateAllButton:Disable();
        end
        self.CreateButton:Show();

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
            frame.ExtraDataFrame:SetPoint("TOPLEFT", frame.SkillDescription, "BOTTOMLEFT", 0, -10);
        else
            frame.SkillDescription:SetText(" ");
            frame.ExtraDataFrame:SetPoint("TOPLEFT", frame.SkillDescription, "TOPLEFT", 0, 0);
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
        local craftName, craftSubSpellName, craftType, numAvailable, isExpanded, trainingPointCost, requiredLevel =
            GetCraftInfo(id);

        if craftSubSpellName then
            frame.SkillName:SetText(craftName .. ' (' .. craftSubSpellName .. ')')
        else
            frame.SkillName:SetText(craftName)
        end
        frame.SkillName:SetWidth(frame.SkillName:GetUnboundedStringWidth())

        local quality = DFProfessionMixin:GetRecipeQuality(id)
        local r, g, b, hex = C_Item.GetItemQualityColor(quality)
        frame.SkillName:SetTextColor(r, g, b)

        DragonflightUIItemColorMixin:UpdateOverlayQuality(frame.SkillIcon, quality)

        if (GetCraftCooldown(id)) then
            frame.SkillCooldown:SetText(COOLDOWN_REMAINING .. " " .. SecondsToTime(GetCraftCooldown(id)));
        else
            frame.SkillCooldown:SetText("");
        end

        local icon = GetCraftIcon(id);
        if (icon) then
            frame.SkillIcon:SetNormalTexture(icon);
        else
            frame.SkillIcon:ClearNormalTexture();
        end

        local minMade, maxMade = GetCraftNumMade(id);
        if (maxMade > 1) then
            if (minMade == maxMade) then
                frame.SkillIconCount:SetText(minMade);
            else
                frame.SkillIconCount:SetText(minMade .. "-" .. maxMade);
            end
            if (frame.SkillIconCount:GetWidth() > 39) then
                frame.SkillIconCount:SetText("~" .. floor((minMade + maxMade) / 2));
            end
        else
            frame.SkillIconCount:SetText("");
        end

        local creatable = true;
        local numReagents = GetCraftNumReagents(id);

        if (numReagents > 0) then
            frame.RegentLabel:Show();
        else
            frame.RegentLabel:Hide();
        end

        for i = 1, numReagents do
            local reagentName, reagentTexture, reagentCount, playerReagentCount = GetCraftReagentInfo(id, i);

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

                local link = GetCraftReagentItemLink(id, i)

                if link then
                    local quality, _, _, _, _, _, _, _, _, classId = select(3, C_Item.GetItemInfo(link));
                    if (classId == 12) then quality = 0; end
                    DragonflightUIItemColorMixin:UpdateOverlayQuality(reagent, quality)
                end

                local function UpdateTooltip(self)
                    GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT");
                    GameTooltip:SetCraftItem(id, self:GetID());
                    CursorUpdate(self);
                end
                reagent:SetScript('OnEnter', UpdateTooltip)

                local function OnClick(self)
                    HandleModifiedItemClick(GetCraftReagentItemLink(id, self:GetID()));
                end
                reagent:SetScript('OnClick', OnClick)
            end
        end

        for i = numReagents + 1, MAX_TRADE_SKILL_REAGENTS do
            local reagent = frame.ReagentTable[i]
            reagent:Hide()
        end

        local spellFocus = BuildColoredListString(GetCraftSpellFocus(id));
        if (spellFocus) then
            frame.RequirementLabel:Show();
            frame.RequirementText:SetText(spellFocus);
        elseif requiredLevel and requiredLevel > 0 then
            frame.RequirementLabel:Show();
            if (UnitLevel("pet") >= requiredLevel) then
                frame.RequirementText:SetText(format(TRAINER_REQ_LEVEL --[[TRAINER_PET_LEVEL]] , requiredLevel));
            else
                frame.RequirementText:SetText(format(TRAINER_REQ_LEVEL --[[TRAINER_PET_LEVEL_RED]] , requiredLevel));
            end
        else
            frame.RequirementLabel:Hide();
            frame.RequirementText:SetText("");
        end

        if (trainingPointCost > 0) then
            local totalPoints, spent = GetPetTrainingPoints();
            local usablePoints = totalPoints - spent;
            if (usablePoints >= trainingPointCost) then
                frame.CostText:SetText(trainingPointCost .. " " .. TRAINING_POINTS_LABEL);
            else
                frame.CostText:SetText(RED_FONT_COLOR_CODE .. trainingPointCost .. FONT_COLOR_CODE_CLOSE .. " " ..
                                           TRAINING_POINTS_LABEL);
            end

            frame.CostLabel:Show()
            frame.CostText:Show();
        else
            frame.CostText:Hide();
        end

        -- CraftCreateButton:SetText(getglobal(GetCraftButtonToken()));
        self.CreateButton:SetText(getglobal(GetCraftButtonToken()));
        -- self.CreateButton:SetText(CraftCreateButton:GetText()); -- @TODO

        if (craftType == "used") then creatable = false; end

        if (creatable) then
            self.CreateButton:Enable();
            -- self.CreateAllButton:Enable();
        else
            self.CreateButton:Disable();
            -- self.CreateAllButton:Disable();
        end

        -- -- self.InputBox:SetNumber(GetTradeskillRepeatCount());
        -- self.InputBox:SetNumber(1);

        if (true) then
            self.CreateAllButton:Hide();
            self.DecrementButton:Hide();
            self.InputBox:Hide();
            self.Incrementbutton:Hide();
            -- else
            --     -- DF
            --     self.CreateAllButton:Show();
            --     self.DecrementButton:Show();
            --     self.InputBox:Show();
            --     self.Incrementbutton:Show();
        end

        -- @TODO
        self.CreateButton:Hide();
        CraftCreateButton:SetParent(self)
        CraftCreateButton:ClearAllPoints()
        CraftCreateButton:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -9, 7)
        CraftCreateButton:SetFrameLevel(8)

        if (GetCraftDescription(id)) then
            frame.SkillDescription:SetText(GetCraftDescription(id))
            frame.ExtraDataFrame:SetPoint("TOPLEFT", frame.SkillDescription, "BOTTOMLEFT", 0, -10);
        else
            frame.SkillDescription:SetText(" ");
            frame.ExtraDataFrame:SetPoint("TOPLEFT", frame.SkillDescription, "TOPLEFT", 0, 0);
        end

        frame.SkillDescription:Show();

        -- DF
        local function UpdateTooltip(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT");
            GameTooltip:SetCraftSpell(id);
            CursorUpdate(self);
        end
        frame.SkillIcon:SetScript('OnEnter', UpdateTooltip)

        frame.SkillIcon:SetScript('OnClick', function(self)
            HandleModifiedItemClick(GetCraftItemLink(id));
        end)

        self.CreateButton:SetScript('OnClick', function()
            DoCraft(id);
            -- self.InputBox:ClearFocus();
        end)

        -- self.CreateAllButton:SetScript('OnClick', function()
        --     local _, _, numAvailable, _, _, _ = GetTradeSkillInfo(id);
        --     self.InputBox:SetNumber(numAvailable);
        --     DoCraft(id);
        --     self.InputBox:ClearFocus();
        -- end)
    end
    self:UpdateTrainingPoints()
    self.FavoriteButton:UpdateFavoriteState()
end

function DFProfessionMixin:ResetFilter()
    DFFilter['DFFilter_HasSkillUp'].enabled = false
    DFFilter['DFFilter_HaveMaterials'].enabled = false
    SetTradeSkillSubClassFilter(0, true, 1)
    SetTradeSkillInvSlotFilter(0, true, 1)

    self:UpdateRecipeList()
    self:CheckFilter()
end

function DFProfessionMixin:AreFilterDefault()
    local allCheckedSub = GetTradeSkillSubClassFilter(0);
    if not allCheckedSub then return false end
    local allCheckedInv = GetTradeSkillInvSlotFilter(0);
    if not allCheckedInv then return false end

    if DFFilter['DFFilter_HasSkillUp'].enabled then return false end
    if DFFilter['DFFilter_HaveMaterials'].enabled then return false end

    return true
end

function DFProfessionMixin:CheckFilter()
    -- print('DFProfessionMixin:CheckFilter()')
    local def = self:AreFilterDefault()

    self.RecipeList.ResetButton:SetShown(not def)
end

function DFProfessionMixin:UpdateRecipeList()
    -- print('DFProfessionMixin:UpdateRecipeList()')
    local selectedKey = self.ProfessionTable[self.SelectedProfession]
    local recipeList = self.RecipeList

    if self.TradeSkillOpen then
        local numSkills = GetNumTradeSkills()
        local index = recipeList.selectedSkill
        index = GetTradeSkillSelectionIndex()
        do
            local skillName, skillType, numAvailable, isExpanded, altVerb, numSkillUps = GetTradeSkillInfo(index);
            if skillType == 'header' then index = GetFirstTradeSkill() end
        end
        if index > numSkills then
            index = GetFirstTradeSkill()
            TradeSkillFrame_SetSelection(index)
        end
        local changed = recipeList.selectedSkill ~= index
        recipeList.selectedSkill = index

        local oldScroll = recipeList.ScrollBox:GetScrollPercentage()

        recipeList:UpdateRecipeListTradeskill()

        recipeList:SelectRecipe(index, true)
        self.FavoriteButton:UpdateFavoriteState()

        if (not changed) and (not force) then
            -- print('set old scroll')
            recipeList.ScrollBox:SetScrollPercentage(oldScroll, ScrollBoxConstants.NoScrollInterpolation)
        end

    elseif self.CraftOpen then
        -- self.RecipeList:ClearList()
        local numSkills = GetNumCrafts()
        local index = recipeList.selectedSkill
        index = GetCraftSelectionIndex()
        if index > numSkills then index = 2 end
        local changed = recipeList.selectedSkill ~= index
        recipeList.selectedSkill = index

        local oldScroll = recipeList.ScrollBox:GetScrollPercentage()

        recipeList:UpdateRecipeListCraft()

        recipeList:SelectRecipe(index, true)
        self.FavoriteButton:UpdateFavoriteState()

        if (not changed) and (not force) then
            -- print('set old scroll')
            recipeList.ScrollBox:SetScrollPercentage(oldScroll, ScrollBoxConstants.NoScrollInterpolation)
        end
    else
        recipeList:ClearList()
    end
end

-- FILTER
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
                if self:GetParent().CraftOpen then CraftFrame_SetSelection(newRecipeID) end
                if self:GetParent().TradeSkillOpen then TradeSkillFrame_SetSelection(newRecipeID) end
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
        local data = {id = 0, categoryInfo = {name = L["ProfessionFavorites"], isExpanded = true}}
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

function DFProfessionFrameRecipeListMixin:UpdateRecipeListCraft()
    local dataProvider = CreateTreeDataProvider();

    local filterTable = DFFilter
    local numSkills = GetNumCrafts()
    local headerID = 0

    do
        local data = {id = 0, categoryInfo = {name = 'Favorites', isExpanded = true}}
        dataProvider:Insert(data)
    end

    for i = 1, numSkills do
        local skillName, craftSubSpellName, skillType, numAvailable, isExpanded, trainingPointCost, requiredLevel =
            GetCraftInfo(i)

        if skillType == "none" then
            skillType = "easy"
        elseif skillType == "used" then
            skillType = "trivial"
        end

        if false then
            -- local data = {id = i, categoryInfo = {name = skillName, isExpanded = isExpanded == 1}}
            -- dataProvider:Insert(data)
            -- headerID = i
        else
            -- print('--', skillName)
            local isFavorite = self:GetParent():IsRecipeFavorite(skillName)

            local data = {
                id = i,
                isFavorite = isFavorite,
                isCraft = true,
                recipeInfo = {
                    name = skillName,
                    craftSubSpellName = craftSubSpellName,
                    skillType = skillType,
                    numAvailable = numAvailable,
                    isExpanded = isExpanded,
                    trainingPointCost = trainingPointCost,
                    requiredLevel = requiredLevel
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

    if recipeInfo.craftSubSpellName then
        self.Label:SetText(recipeInfo.name .. ' (' .. recipeInfo.craftSubSpellName .. ')');
    else
        self.Label:SetText(recipeInfo.name);
    end
    -- self.learned = recipeInfo.learned;
    self:SetLabelFontColors(self:GetLabelColor());

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

    if recipeInfo.trainingPointCost and recipeInfo.trainingPointCost > 0 then
        width = width - 10;
        self.Count:SetFormattedText(" - %d TP", recipeInfo.trainingPointCost)
        self.Count:Show()
    end
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

------------------------------
DFProfessionFrameRecipeSchematicFormMixin = {}

function DFProfessionFrameRecipeSchematicFormMixin:OnLoad()
    -- print('DFProfessionFrameRecipeSchematicFormMixin:OnLoad()')
end

function DFProfessionFrameRecipeSchematicFormMixin:OnShow()
    -- print('DFProfessionFrameRecipeSchematicFormMixin:OnShow()')
end

function DFProfessionFrameRecipeSchematicFormMixin:OnHide()
    -- print('DFProfessionFrameRecipeSchematicFormMixin:OnHide()')
end

function DFProfessionFrameRecipeSchematicFormMixin:OnEvent()
    -- print('DFProfessionFrameRecipeSchematicFormMixin:OnEvent()')
end

