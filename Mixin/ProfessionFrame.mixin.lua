local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

DFProfessionMixin = {}

function DFProfessionMixin:OnLoad()
    self:SetupFavoriteDatabase()

    self.minimized = false
    self.anchored = false
    self.currentTradeSkillName = ''
    self.currentSkillID = nil

    self:SetupFrameStyle()
    self:SetupSchematics()
    self:Minimize(self.minimized)

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

    -- self.ClosePanelButton:SetScript("OnClick", function(btn)
    --     --     
    --     HideUIPanel(TradeSkillFrame)
    -- end);

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

function DFProfessionMixin:OnEvent()
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

function DFProfessionMixin:SetupFavoriteDatabase()
    self.db = DF.db:RegisterNamespace('RecipeFavorite', {profile = {favorite = {}}})
end

-- function DFProfessionMixin:OnEvent()
-- end

