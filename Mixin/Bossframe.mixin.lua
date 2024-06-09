DragonflightUIBossframeMixin = {}

function DragonflightUIBossframeMixin:OnLoad()
    print('DragonflightUIBossframeMixin:OnLoad()')

end

function DragonflightUIBossframeMixin:Setup(unit)
    print('DragonflightUIBossframeMixin:Setup()', unit)

    self.unit = unit
    self:SetAttribute('unit', unit)
    self:RegisterForClicks("AnyUp")

    RegisterUnitWatch(self)

    self:SetAttribute("type1", "macro")
    self:SetAttribute('macrotext', '/targetexact ' .. unit)

    self:SetSize(232, 100)
    self:SetPoint('CENTER', UIParent, 'CENTER', 0, 80)
    self:SetScale(1)

    self:SetupTargetFrameStyle()
end

function DragonflightUIBossframeMixin:UpdateState(state)
    self:UpdatePortrait(self.unit)
end

function DragonflightUIBossframeMixin:UpdatePortrait(unit)
    SetPortraitTexture(self.Portrait, unit)
end

function DragonflightUIBossframeMixin:SetupTargetFrameStyle()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    do
        local textureFrame = CreateFrame('Frame', 'DragonflightUIBossFrameTextureFrame', self)
        textureFrame:SetPoint('CENTER')
        textureFrame:SetFrameLevel(3)
        self.TextureFrame = textureFrame
    end

    do
        local background = self:CreateTexture('DragonflightUIBossFrameBackground')
        background:SetDrawLayer('BACKGROUND', 2)
        background:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BACKGROUND')
        background:SetPoint('LEFT', self, 'LEFT', 0, -32.5 + 10)
        self.FrameBackground = background
    end

    do
        local border = self.TextureFrame:CreateTexture('DragonflightUIBossFrameBorder')
        border:SetDrawLayer('ARTWORK', 2)
        border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BORDER')
        border:SetPoint('LEFT', self, 'LEFT', 0, -32.5 + 10)
        self.FrameBorder = border
    end

    do
        local portrait = self.TextureFrame:CreateTexture('DragonflightUIBossFramePortrait')
        portrait:SetDrawLayer('ARTWORK', 1)
        portrait:SetSize(56, 56)
        local CorrectionY = -3
        local CorrectionX = -5
        portrait:SetPoint('TOPRIGHT', self, 'TOPRIGHT', -42 + CorrectionX, -12 + CorrectionY)
        self.Portrait = portrait
    end

    do
        local extra = self:CreateTexture('DragonflightUIBossFramePortraitExtra')
        extra:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiunitframeboss2x')
        extra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
        extra:SetSize(80, 79)
        extra:SetDrawLayer('ARTWORK', 3)
        extra:SetPoint('CENTER', self.Portrait, 'CENTER', 4, 1)

        self.PortraitExtra = extra

        self:UpdatePortraitExtra('worldboss')
    end

    do
        local hp = CreateFrame('StatusBar', nil, self)
        hp:SetSize(125, 20)
        hp:SetPoint('RIGHT', self.Portrait, 'LEFT', -1, 0)
        hp:SetStatusBarTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health')
        hp:SetStatusBarColor(1, 1, 1, 1)

        self.HealthBar = hp
    end

    do
        local mana = CreateFrame('StatusBar', nil, self)
        mana:SetSize(132, 9)
        mana:SetPoint('RIGHT', self.Portrait, 'LEFT', -1 + 8 - 0.5, -18 + 1 + 0.5)

        mana:SetStatusBarTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health')
        mana:SetStatusBarColor(1, 1, 1, 1)

        self.ManaBar = mana

        -- local powerType, powerTypeString = UnitPowerType('target')   
        self:UpdatePowerType('MANA')
    end

    do
        local nameBG = self:CreateTexture('DragonflightUIBossFrameNameBackground')

        nameBG:SetTexture(base)
        nameBG:SetTexCoord(0.7939453125, 0.92578125, 0.3125, 0.34765625)
        nameBG:SetSize(135, 18)
        nameBG:ClearAllPoints()
        nameBG:SetPoint('BOTTOMLEFT', self.HealthBar, 'TOPLEFT', -2, -4 - 1)

        -- TODO
        nameBG:Hide()

        self.NameBackground = nameBG
    end

    do
        local name = self:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
        name:SetSize(100, 10)
        name:SetPoint('BOTTOM', self.HealthBar, 'TOP', 10, 3 - 2)

        self.Name = name

        self:UpdateName('Zimtdev')
    end

    do
        local dx = 5
        -- health vs mana bar
        local deltaSize = 132 - 125

        -- HP
        self.HealthBar.HealthBarText = self.HealthBar:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
        self.HealthBar.HealthBarText:SetText('100/100')
        self.HealthBar.HealthBarText:SetPoint('CENTER', self.HealthBar, 'CENTER', 0, 0)
        self.HealthBar.HealthBarText:Hide()

        self.HealthBar.HealthBarTextLeft = self.HealthBar:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
        self.HealthBar.HealthBarTextLeft:SetText('100%')
        self.HealthBar.HealthBarTextLeft:SetPoint('LEFT', self.HealthBar, 'LEFT', dx, 0)

        self.HealthBar.HealthBarTextRight = self.HealthBar:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
        self.HealthBar.HealthBarTextRight:SetText('6942')
        self.HealthBar.HealthBarTextRight:SetPoint('RIGHT', self.HealthBar, 'RIGHT', -dx, 0)

        -- Mana
        self.ManaBar.ManaBarText = self.ManaBar:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
        self.ManaBar.ManaBarText:SetText('100/100')
        self.ManaBar.ManaBarText:SetPoint('CENTER', self.ManaBar, 'CENTER', -deltaSize / 2, 0)
        self.ManaBar.ManaBarText:Hide()

        self.ManaBar.ManaBarTextLeft = self.ManaBar:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
        self.ManaBar.ManaBarTextLeft:SetText('100%')
        self.ManaBar.ManaBarTextLeft:SetPoint('LEFT', self.ManaBar, 'LEFT', dx, 0)

        self.ManaBar.ManaBarTextRight = self.ManaBar:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
        self.ManaBar.ManaBarTextRight:SetText('6942')
        self.ManaBar.ManaBarTextRight:SetPoint('RIGHT', self.ManaBar, 'RIGHT', -deltaSize - dx, 0)
    end
end

function DragonflightUIBossframeMixin:UpdatePortraitExtra(class)
    --    local class = UnitClassification('target')
    if class == 'worldboss' then
        self.PortraitExtra:Show()
        self.PortraitExtra:SetSize(99, 81)
        self.PortraitExtra:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.31835937)
        self.PortraitExtra:SetPoint('CENTER', self.Portrait, 'CENTER', 13, 1)
    elseif class == 'rareelite' or class == 'rare' then
        self.PortraitExtra:Show()
        self.PortraitExtra:SetSize(80, 79)
        self.PortraitExtra:SetTexCoord(0.00390625, 0.31640625, 0.64453125, 0.953125)
        self.PortraitExtra:SetPoint('CENTER', self.Portrait, 'CENTER', 4, 1)
    elseif class == 'elite' then
        self.PortraitExtra:Show()
        self.PortraitExtra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
        self.PortraitExtra:SetSize(80, 79)
        self.PortraitExtra:SetPoint('CENTER', self.Portrait, 'CENTER', 4, 1)
    else
        self.PortraitExtra:Hide()
    end
end

function DragonflightUIBossframeMixin:UpdatePowerType(powerTypeString)
    local mana = self.ManaBar

    if powerTypeString == 'MANA' then
        mana:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana')
    elseif powerTypeString == 'FOCUS' then
        mana:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus')
    elseif powerTypeString == 'RAGE' then
        mana:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage')
    elseif powerTypeString == 'ENERGY' then
        mana:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy')
    elseif powerTypeString == 'RUNIC_POWER' then
        mana:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower')
    end
end

function DragonflightUIBossframeMixin:UpdateName(name)
    self.Name:SetText(name)
end

function DragonflightUIBossframeMixin:SetupTextures()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframeboss2x'
    local f = self

    local border = f:CreateTexture('DragonflightUIBossframeBorder')
    f.border = border
    border:SetDrawLayer('ARTWORK', 2)
    border:SetTexture(base)
    border:SetTexCoord(0.392578, 0.841797, 0.00195312, 0.220703)
    border:SetSize(230, 112)
    border:SetPoint('CENTER')

    local bosstype = f:CreateTexture('DragonflightUIBossframeType')
    f.type = bosstype
    bosstype:SetDrawLayer('BACKGROUND', 2)
    bosstype:SetTexture(base)
    bosstype:SetTexCoord(0.392578, 0.724609, 0.224609, 0.294922)
    bosstype:SetSize(173, 36)
    bosstype:SetPoint('TOPLEFT', 4, -14)
    bosstype:SetVertexColor(1.0, 0, 0, 1.0)
end

function DragonflightUIBossframeMixin:SetupName(unit)
    local f = self
    local name = f:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
    f.name = name
    name:SetSize(90, 12)
    name:SetPoint('BOTTOM', f.hp, 'TOP', 0, 4)
    name:SetText('Zimtdev')
end

function DragonflightUIBossframeMixin:CreateHP(unit)
    local f = self

    local hp = CreateFrame('StatusBar', nil, f)
    f.hp = hp
    hp:SetWidth(170)
    hp:SetHeight(20)
    hp:SetPoint("LEFT", f, "LEFT", 5, -2);

    hp:SetStatusBarTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Bossframe\\UI-HUD-UnitFrame-Target-Boss-Small-PortraitOff-Bar-Health')
    hp:SetStatusBarColor(1, 1, 1, 1)
end

function DragonflightUIBossframeMixin:CreateMana(unit)
    local f = self

    local mana = CreateFrame('StatusBar', nil, f)
    f.mana = mana
    mana:SetWidth(170)
    mana:SetHeight(16)
    mana:SetPoint("TOPRIGHT", f.hp, "BOTTOMRIGHT", 0, -1);

    mana:SetStatusBarTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Bossframe\\UI-HUD-UnitFrame-Target-Boss-Small-PortraitOff-Bar-Rage')
    mana:SetStatusBarColor(1, 1, 1, 1)
end
