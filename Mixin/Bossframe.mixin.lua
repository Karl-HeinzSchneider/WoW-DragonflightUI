DragonflightUIBossframeMixin = {}

function DragonflightUIBossframeMixin:OnLoad()
    -- print('DragonflightUIBossframeMixin:OnLoad()')
end

function DragonflightUIBossframeMixin:Setup(unit, id)
    -- print('DragonflightUIBossframeMixin:Setup()', unit)

    self.unit = unit
    self.id = id
    self:SetAttribute('unit', unit)
    self:RegisterForClicks("AnyUp")

    self:SetAttribute("type1", "macro")
    self:SetAttribute('macrotext', '/targetexact ' .. unit)

    self:SetSize(232, 100)
    self:SetPoint('CENTER', UIParent, 'CENTER', 0, 80)
    self:SetScale(1)

    self:SetupTargetFrameStyle()

    self:UpdateHealth(unit)
    self:UpdatePower(unit)
    self:UpdatePortrait(unit)
    self:UpdatePortraitExtra(unit)

    self:RegisterEvent("UNIT_NAME_UPDATE")
    self:RegisterEvent("CVAR_UPDATE")
    self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
    self:RegisterEvent("RAID_TARGET_UPDATE")

    self:RegisterUnitEvent("UNIT_HEALTH", unit)
    -- self:RegisterUnitEvent("UNIT_MAXHEALTH", unit)
    self:RegisterUnitEvent("UNIT_POWER_UPDATE", unit)
    -- self:RegisterUnitEvent("UNIT_MAXPOWER", unit)

    self:SetScript("OnEvent", self.OnEvent)

    RegisterUnitWatch(self)
end

function DragonflightUIBossframeMixin:OnShow()
    -- print('OnShow')
    local unit = self.unit
    if not unit then return end

    self:UpdateName(unit)
    self:UpdateLevel(unit)
    self:UpdateTargetIcon(unit)
    self:OnEvent("UNIT_HEALTH", unit)
    self:OnEvent("UNIT_POWER_UPDATE", unit)
    self:OnEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
end

function DragonflightUIBossframeMixin:OnHide()
    -- print('OnHide')
end

function DragonflightUIBossframeMixin:OnEvent(event, eventUnit, arg1, arg2)
    -- print('OnEvent', event, eventUnit)
    local unit = self.unit

    if (event == "UNIT_NAME_UPDATE") then

    elseif (event == "UNIT_HEALTH") then
        self:UpdateHealth(unit)
    elseif (event == "UNIT_MAXHEALTH") then
        self:UpdateHealth(unit)
    elseif (event == "UNIT_POWER_UPDATE") then
        self:UpdatePower(unit)
    elseif (event == "UNIT_MAXPOWER") then
        self:UpdatePower(unit)

    elseif (event == 'CVAR_UPDATE') and (eventUnit == 'statusTextDisplay') then
        -- self:UpdateStatusStyle()
        self:UpdateHealth(unit)
        self:UpdatePower(unit)
    elseif (event == 'INSTANCE_ENCOUNTER_ENGAGE_UNIT') then
        self:UpdatePortrait(unit)
        self:UpdatePortraitExtra(unit)
        self.NameBackground:SetVertexColor(UnitSelectionColor(self.unit))
    elseif (event == 'RAID_TARGET_UPDATE') then
        self:UpdateTargetIcon(unit)
    end
end

function DragonflightUIBossframeMixin:UpdateState(state)
    self:UpdatePortrait(self.unit)

    local deltaY = (1 - self.id) * 85

    local parent = _G[state.anchorFrame]
    self:ClearAllPoints()
    self:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y + deltaY)

    self:SetScale(state.scale)
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

        -- self:UpdatePortraitExtra('worldboss')
    end

    do
        local hp = CreateFrame('StatusBar', nil, self)
        hp:SetSize(125, 20)
        hp:SetPoint('RIGHT', self.Portrait, 'LEFT', -1, 0)
        hp:SetStatusBarTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health')
        hp:SetStatusBarColor(1, 1, 1, 1)
        hp.breakUpLargeNumbers = true

        self.HealthBar = hp
    end

    do
        local mana = CreateFrame('StatusBar', nil, self)
        mana:SetSize(132, 9)
        mana:SetPoint('RIGHT', self.Portrait, 'LEFT', -1 + 8 - 0.5, -18 + 1 + 0.5)

        mana:SetStatusBarTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health')
        mana:SetStatusBarColor(1, 1, 1, 1)
        mana.breakUpLargeNumbers = true

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
        -- nameBG:Hide()

        self.NameBackground = nameBG
    end

    do
        local name = self:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
        name:SetSize(100, 10)
        name:SetPoint('BOTTOM', self.HealthBar, 'TOP', 10, 3 - 2)

        self.Name = name

        -- self:UpdateName('Zimtdev')
    end

    do
        local level = self:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
        -- level:SetSize(100, 10)    
        level:SetPoint('BOTTOMRIGHT', self.HealthBar, 'TOPLEFT', 16, 3 - 2)

        -- level:SetText('69')
        self.Level = level
    end

    do
        local targetIcon = self.TextureFrame:CreateTexture('DragonflightUIBossFrameRaidTargetIcon')

        targetIcon:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcons')
        targetIcon:SetDrawLayer('ARTWORK', 5)
        targetIcon:SetSize(26, 26)
        targetIcon:ClearAllPoints()
        targetIcon:SetPoint('CENTER', self.Portrait, 'TOP', 0, 2)

        targetIcon:Hide()

        self.RaidTargetIcon = targetIcon
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

        self.HealthBar.LeftText = self.HealthBar:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
        self.HealthBar.LeftText:SetText('100%')
        self.HealthBar.LeftText:SetPoint('LEFT', self.HealthBar, 'LEFT', dx, 0)

        self.HealthBar.RightText = self.HealthBar:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
        self.HealthBar.RightText:SetText('6942')
        self.HealthBar.RightText:SetPoint('RIGHT', self.HealthBar, 'RIGHT', -dx, 0)

        -- Mana
        self.ManaBar.ManaBarText = self.ManaBar:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
        self.ManaBar.ManaBarText:SetText('100/100')
        self.ManaBar.ManaBarText:SetPoint('CENTER', self.ManaBar, 'CENTER', -deltaSize / 2, 0)
        self.ManaBar.ManaBarText:Hide()

        self.ManaBar.LeftText = self.ManaBar:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
        self.ManaBar.LeftText:SetText('100%')
        self.ManaBar.LeftText:SetPoint('LEFT', self.ManaBar, 'LEFT', dx, 0)

        self.ManaBar.RightText = self.ManaBar:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
        self.ManaBar.RightText:SetText('6942')
        self.ManaBar.RightText:SetPoint('RIGHT', self.ManaBar, 'RIGHT', -deltaSize - dx, 0)
    end
end

function DragonflightUIBossframeMixin:UpdatePortraitExtra(unit)
    local class = UnitClassification(unit)
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

function DragonflightUIBossframeMixin:UpdateName(unit)
    local name = GetUnitName(unit)
    self.Name:SetText(name)
end

function DragonflightUIBossframeMixin:UpdateLevel(unit)
    local targetEffectiveLevel = UnitLevel(self.unit);

    if targetEffectiveLevel > 0 then
        -- self.Level:Show()
        self.Level:SetText(targetEffectiveLevel)
    else
        self.Level:SetText('??')
    end
end

function DragonflightUIBossframeMixin:UpdateTargetIcon(unit)
    local index = GetRaidTargetIndex(unit);
    if (index) then
        SetRaidTargetIconTexture(self.RaidTargetIcon, index);
        self.RaidTargetIcon:Show();
    else
        self.RaidTargetIcon:Hide();
    end
end

function DragonflightUIBossframeMixin:UpdateHealth(unit)
    self.HealthBar:SetMinMaxValues(0, UnitHealthMax(unit))
    self.HealthBar:SetValue(UnitHealth(unit))

    local value = self.HealthBar:GetValue();
    local valueMin, valueMax = self.HealthBar:GetMinMaxValues();

    local statusStyle = GetCVar("statusTextDisplay")
    if statusStyle == 'NONE' then
        self.HealthBar.lockShow = 0
    else
        self.HealthBar.lockShow = 1
    end

    TextStatusBar_UpdateTextStringWithValues(self.HealthBar, self.HealthBar.HealthBarText, value, valueMin, valueMax)
end

function DragonflightUIBossframeMixin:UpdatePower(unit)
    local powerType, powerTypeString = UnitPowerType(unit)

    if self.PowerTypeString ~= powerTypeString then
        self:UpdatePowerType(powerTypeString)
        self.PowerTypeString = powerTypeString
    end

    self.ManaBar:SetMinMaxValues(0, UnitPowerMax(unit))
    self.ManaBar:SetValue(UnitPower(unit))

    local value = self.ManaBar:GetValue();
    local valueMin, valueMax = self.ManaBar:GetMinMaxValues();

    local statusStyle = GetCVar("statusTextDisplay")
    if statusStyle == 'NONE' then
        self.ManaBar.lockShow = 0
    else
        self.ManaBar.lockShow = 1
    end

    TextStatusBar_UpdateTextStringWithValues(self.ManaBar, self.ManaBar.ManaBarText, value, valueMin, valueMax)
end

