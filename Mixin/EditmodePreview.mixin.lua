local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
-- local EditModeModule = DF:GetModule('Editmode');
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

DragonflightUIEditModePreviewMixin = {}

function DragonflightUIEditModePreviewMixin:OnLoad()
end

function DragonflightUIEditModePreviewMixin:CreateFakeTargetFrame()
    local f = CreateFrame('Frame', 'DragonflightUIEditModePreviewFrame', UIParent);

    local sizeX, sizeY = TargetFrame:GetSize()
    f:SetSize(sizeX, sizeY)

    return f;
end

DragonflightUIEditModePreviewTargetMixin = {}

function DragonflightUIEditModePreviewTargetMixin:OnLoad()
    print('--------------DragonflightUIEditModePreviewTargetMixin:OnLoad()')

    local sizeX, sizeY = TargetFrame:GetSize()
    self:SetSize(sizeX, sizeY)
    self:SetupFrame()
    self:SetRandomUnit()
end

function DragonflightUIEditModePreviewTargetMixin:SetRandomUnit()
    local vip = DF:GetRandomVIP()
    self:SetUnit(vip)
end

function DragonflightUIEditModePreviewTargetMixin:SetUnit(unit)
    self.Unit = unit;
    -- DF.VIPTable['Zimtschnecke'] = {
    --     name = 'Zimtschnecke',
    --     level = '69',
    --     class = 'PALADIN',
    --     powerType = 'MANA',
    --     hpAmount = 69,
    --     energyAmount = 100,
    --     targetIcon = 0,
    --     extra = ''
    -- }
    self.TargetFramePortrait:UpdatePortrait(unit.displayID)
    self.PortraitExtra:UpdateStyle(unit.extra)

    self.HealthBar:SetMinMaxValues(0, 100)
    self.HealthBar:SetValue(unit.hpAmount)

    self.ManaBar:SetMinMaxValues(0, 100)
    self.ManaBar:SetValue(unit.energyAmount)
    self.ManaBar:SetPowerType(unit.powerType)

    self.RaidTargetIcon:UpdateTargetIcon(unit.targetIcon)

    self.FontName:SetName(unit.name)
    self.FontLevel:SetLevel(unit.level)
end

function DragonflightUIEditModePreviewTargetMixin:UpdateState(state)
    self:ClearAllPoints()
    local parent = _G[state.anchorFrame]
    self:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    self:SetScale(state.scale)

    self.NameBackground:SetShown(not state.hideNameBackground)

    if state.classcolor then
        self.HealthBar:SetClass(self.Unit.class)
    else
        self.HealthBar:SetClass('')
    end
end

function DragonflightUIEditModePreviewTargetMixin:SetupFrame()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    local textureFrame = CreateFrame('Frame', 'DragonflightUIBossFrameTextureFrame', self)
    textureFrame:SetPoint('CENTER')
    textureFrame:SetFrameLevel(3)
    self.TextureFrame = textureFrame

    local background = self:CreateTexture('DragonflightUITargetFrameBackground')
    background:SetDrawLayer('BACKGROUND', 2)
    background:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BACKGROUND')
    background:SetPoint('LEFT', self, 'LEFT', 0, -32.5 + 10)
    self.TargetFrameBackground = background

    local border = self.TextureFrame:CreateTexture('DragonflightUITargetFrameBorder')
    border:SetDrawLayer('ARTWORK', 2)
    border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BORDER')
    border:SetPoint('LEFT', self, 'LEFT', 0, -32.5 + 10)
    self.TargetFrameBorder = border

    local portrait = self.TextureFrame:CreateTexture('DragonflightUITargetFramePortrait')
    portrait:SetDrawLayer('ARTWORK', 1)
    portrait:SetSize(56, 56)
    local CorrectionY = -3
    local CorrectionX = -5
    portrait:SetPoint('TOPRIGHT', self, 'TOPRIGHT', -42 + CorrectionX, -12 + CorrectionY)
    self.TargetFramePortrait = portrait
    function portrait:UpdatePortrait(id)
        if not id then return end
        -- SetPortraitTexture(self.TargetFramePortrait, unit)   
        SetPortraitTextureFromCreatureDisplayID(portrait, tonumber(id) or 0);
    end
    portrait:UpdatePortrait('player')

    -- local portraitBackground = self.TextureFrame:CreateTexture(nil, "BACKGROUND", nil, -8)
    -- portraitBackground:SetSize(56, 56)
    -- portraitBackground:SetPoint('TOPRIGHT', self, 'TOPRIGHT', -42 + CorrectionX, -12 + CorrectionY)
    -- portraitBackground:SetTexture("Interface\\AddOns\\rTextures\\portrait_back")

    local extra = self.TextureFrame:CreateTexture('DragonflightUITargetFramePortraitExtra')
    extra:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiunitframeboss2x')
    extra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
    extra:SetSize(80, 79)
    extra:SetDrawLayer('ARTWORK', 3)
    extra:SetPoint('CENTER', portrait, 'CENTER', 4, 1)
    self.PortraitExtra = extra

    function extra:UpdateStyle(class)
        -- local class = UnitClassification('target')
        --[[ "worldboss", "rareelite", "elite", "rare", "normal", "trivial" or "minus" ]]
        if class == 'worldboss' then
            extra:Show()
            extra:SetSize(99, 81)
            extra:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.31835937)
            extra:SetPoint('CENTER', portrait, 'CENTER', 13, 1)
        elseif class == 'rareelite' or class == 'rare' then
            extra:Show()
            extra:SetSize(80, 79)
            extra:SetTexCoord(0.00390625, 0.31640625, 0.64453125, 0.953125)
            extra:SetPoint('CENTER', portrait, 'CENTER', 4, 1)
        elseif class == 'elite' then
            extra:Show()
            extra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
            extra:SetSize(80, 79)
            extra:SetPoint('CENTER', portrait, 'CENTER', 4, 1)
        else
            local name, realm = UnitName('target')
            if false then
                extra:Show()
                extra:SetSize(99, 81)
                extra:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.31835937)
                extra:SetPoint('CENTER', portrait, 'CENTER', 13, 1)
            else
                extra:Hide()
            end
        end
    end
    -- self.PortraitExtra:UpdateStyle('worldboss')

    local healthBar = CreateFrame("StatusBar", nil, self)
    healthBar:SetSize(125, 20)
    healthBar:SetPoint('RIGHT', portrait, 'LEFT', -1, 0)

    healthBar:SetStatusBarTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health')
    healthBar:SetStatusBarColor(1, 1, 1, 1)
    healthBar:SetMinMaxValues(0, 100)
    healthBar:SetValue(69)
    self.HealthBar = healthBar
    function healthBar:SetClass(class)
        if class == '' then
            healthBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health')
            healthBar:SetStatusBarColor(1, 1, 1, 1)
        else
            healthBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health-Status')
            -- local localizedClass, englishClass, classIndex = UnitClass('focus')
            healthBar:SetStatusBarColor(DF:GetClassColor(class, 1))
        end
    end
    self.HealthBar:SetClass('PRIEST')

    local manaBar = CreateFrame("StatusBar", nil, self)
    manaBar:SetSize(132, 9)
    manaBar:SetPoint('RIGHT', portrait, 'LEFT', -1 + 8 - 0.5, -18 + 1 + 0.5)
    manaBar:SetStatusBarTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health')
    manaBar:SetStatusBarColor(1, 1, 1, 1)
    manaBar:SetMinMaxValues(0, 100)
    manaBar:SetValue(100)
    self.ManaBar = manaBar
    function manaBar:SetPowerType(powerTypeString)
        if powerTypeString == 'MANA' then
            manaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana')
        elseif powerTypeString == 'FOCUS' then
            manaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus')
        elseif powerTypeString == 'RAGE' then
            manaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage')
        elseif powerTypeString == 'ENERGY' then
            manaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy')
        elseif powerTypeString == 'RUNIC_POWER' then
            manaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower')
        end
    end
    self.ManaBar:SetPowerType('MANA')

    -- TargetFrameTextureFrameRaidTargetIcon:SetPoint('CENTER', TargetFramePortrait, 'TOP', 0, 2)
    local targetIcon = self.TextureFrame:CreateTexture('DragonflightUIRaidTarget')
    targetIcon:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcons')
    targetIcon:SetDrawLayer('ARTWORK', 5)
    targetIcon:SetSize(26, 26)
    targetIcon:ClearAllPoints()
    targetIcon:SetPoint('CENTER', portrait, 'TOP', 0, 2)
    targetIcon:Hide()
    self.RaidTargetIcon = targetIcon
    function targetIcon:UpdateTargetIcon(index)
        -- local index = GetRaidTargetIndex(unit);
        if (index > 0) then
            SetRaidTargetIconTexture(targetIcon, index);
            targetIcon:Show();
        else
            targetIcon:Hide();
        end
    end
    targetIcon:UpdateTargetIcon(0)

    local fontName = self:CreateFontString('**', 'OVERLAY', 'GameFontNormalSmall')
    fontName:SetPoint('BOTTOM', healthBar, 'TOP', 10, 3 - 2)
    fontName:SetSize(100, 12)
    self.FontName = fontName
    function fontName:SetName(name)
        fontName:SetText(name)
    end
    fontName:SetName('Zimtschnecke')

    local fontLevel = self:CreateFontString('**', 'OVERLAY', 'GameFontNormalSmall')
    fontLevel:SetPoint('BOTTOMRIGHT', healthBar, 'TOPLEFT', 16, 3 - 2)
    fontLevel:SetHeight(12);
    self.FontLevel = fontLevel
    function fontLevel:SetLevel(lvl)
        fontLevel:SetText(lvl)
    end
    fontLevel:SetLevel('69')

    local nameBackground = self:CreateTexture('')
    nameBackground:SetTexture(base)
    nameBackground:SetTexCoord(0.7939453125, 0.92578125, 0.3125, 0.34765625)
    nameBackground:SetSize(135, 18)
    nameBackground:SetPoint('BOTTOMLEFT', healthBar, 'TOPLEFT', -2, -4 - 1)
    function nameBackground:SetColor(type)
        if type == 'white' then
            nameBackground:SetVertexColor(1, 1, 1, 1);
        elseif type == 'blue' then
            nameBackground:SetVertexColor(0, 0, 1, 1);
        elseif type == 'green' then
            nameBackground:SetVertexColor(0, 1, 0, 1);
        elseif type == 'red' then
            nameBackground:SetVertexColor(1, 0, 0, 1);
        elseif type == 'yellow' then
            nameBackground:SetVertexColor(1, 1, 0, 1);
        end
    end
    nameBackground:SetColor('blue')
    self.NameBackground = nameBackground
end
