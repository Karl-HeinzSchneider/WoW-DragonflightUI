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
        local background = self:CreateTexture('DragonflightUIBossFrameBackground')
        background:SetDrawLayer('BACKGROUND', 2)
        background:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BACKGROUND')
        background:SetPoint('LEFT', self, 'LEFT', 0, -32.5 + 10)
        self.FrameBackground = background
    end

    do
        local border = self:CreateTexture('DragonflightUIBossFrameBorder')
        border:SetDrawLayer('ARTWORK', 2)
        border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BORDER')
        border:SetPoint('LEFT', self, 'LEFT', 0, -32.5 + 10)
        self.FrameBorder = border
    end

    do
        local portrait = self:CreateTexture('DragonflightUIBossFramePortrait')
        portrait:SetDrawLayer('ARTWORK', 1)
        portrait:SetSize(56, 56)
        local CorrectionY = -3
        local CorrectionX = -5
        portrait:SetPoint('TOPRIGHT', self, 'TOPRIGHT', -42 + CorrectionX, -12 + CorrectionY)
        self.Portrait = portrait
    end
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
