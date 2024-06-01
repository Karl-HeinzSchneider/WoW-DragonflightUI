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
    self:SetScale(2)

    self:SetupTextures()
    self:CreateHP(unit)
    self:CreateMana(unit)
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
end

function DragonflightUIBossframeMixin:CreateHP(unit)
    local f = self

    local hp = CreateFrame('StatusBar', nil, f)
    f.hp = hp
    hp:SetWidth(85)
    hp:SetHeight(10)
    hp:SetPoint("LEFT", f, "LEFT", 3, -1);
    hp:SetScale(2)

    hp:SetStatusBarTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health')
    hp:SetStatusBarColor(1, 1, 1, 1)
end

function DragonflightUIBossframeMixin:CreateMana(unit)
    local f = self

    local mana = CreateFrame('StatusBar', nil, f)
    f.mana = mana
    mana:SetWidth(85)
    mana:SetHeight(8)
    mana:SetPoint("TOPRIGHT", f.hp, "BOTTOMRIGHT", 0, -1);
    mana:SetScale(2)

    mana:SetStatusBarTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana')
    mana:SetStatusBarColor(1, 1, 1, 1)
end
