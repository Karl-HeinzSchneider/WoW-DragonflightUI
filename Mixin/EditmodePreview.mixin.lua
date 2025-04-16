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
    -- print('--------------DragonflightUIEditModePreviewTargetMixin:OnLoad()')

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
    if self.TargetFramePortrait then
        if unit.displayTexture then
            self.TargetFramePortrait:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\VIP\\' ..
                                                    unit.displayTexture)

            if not self.TargetFramePortrait.CircleMask then
                local circleMask = self:CreateMaskTexture()
                circleMask:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\tempportraitalphamask')
                circleMask:SetPoint('TOPLEFT', self.TargetFramePortrait, 'TOPLEFT', 0, 0)
                circleMask:SetPoint('BOTTOMRIGHT', self.TargetFramePortrait, 'BOTTOMRIGHT', 0, 0)
                self.TargetFramePortrait:AddMaskTexture(circleMask)
                self.TargetFramePortrait.CircleMask = circleMask;
            end
            local mask = self.TargetFramePortrait.CircleMask
        else
            self.TargetFramePortrait:UpdatePortrait(unit.displayID)
        end
    end
    if self.PortraitExtra then self.PortraitExtra:UpdateStyle(unit.extra) end
    if self.RoleIcon then self.RoleIcon:UpdateRoleIcon(unit.role) end

    self.HealthBar:SetMinMaxValues(0, 100)
    self.HealthBar:SetValue(unit.hpAmount)

    self.ManaBar:SetMinMaxValues(0, 100)
    self.ManaBar:SetValue(unit.energyAmount)
    self.ManaBar:SetPowerType(unit.powerType)

    if self.RaidTargetIcon then self.RaidTargetIcon:UpdateTargetIcon(unit.targetIcon) end

    self.FontName:SetName(unit.name)
    if self.FontLevel then self.FontLevel:SetLevel(unit.level) end
end

function DragonflightUIEditModePreviewTargetMixin:UpdateState(state)
    self:ClearAllPoints()
    local parent = _G[state.anchorFrame]
    self:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    self:SetScale(state.scale)

    if self.NameBackground then self.NameBackground:SetShown(not state.hideNameBackground) end

    if state.classcolor then
        self.HealthBar:SetClass(self.Unit.class)
    else
        self.HealthBar:SetClass('')
    end

    if state.classicon then
        local texCoords = CLASS_ICON_TCOORDS[self.Unit.class]
        if texCoords then
            self.TargetFramePortrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
            self.TargetFramePortrait:SetTexCoord(unpack(texCoords))
        else
            self:SetUnit(self.Unit)
            self.TargetFramePortrait:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
        end
    else
        self:SetUnit(self.Unit)
        self.TargetFramePortrait:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
    end
end

function DragonflightUIEditModePreviewTargetMixin:SetupFrame()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    local textureFrame = CreateFrame('Frame', 'DragonflightUITargetFrameTextureFrame', self)
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

    local portrait = self.TextureFrame:CreateTexture('DragonflightUIPreviewTargetFramePortrait')
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

    local extra = self.TextureFrame:CreateTexture('DragonflightUIPreviewTargetFramePortraitExtra')
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
    -- manaBar:SetSize(132, 9)
    -- manaBar:SetPoint('RIGHT', portrait, 'LEFT', -1 + 8 - 0.5, -18 + 1 + 0.5)
    manaBar:SetPoint('TOPLEFT', healthBar, 'BOTTOMLEFT', 0, -1)
    manaBar:SetSize(134, 10)
    manaBar:SetStatusBarTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health')
    manaBar:SetStatusBarColor(1, 1, 1, 1)
    manaBar:SetMinMaxValues(0, 100)
    manaBar:SetValue(100)

    local manaMask = manaBar:CreateMaskTexture()
    manaMask:SetPoint('TOPLEFT', manaBar, 'TOPLEFT', -61, 3)
    manaMask:SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\ui-hud-unitframe-target-portraiton-bar-mana-mask-2x',
        'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
    manaMask:SetTexCoord(0, 1, 0, 1)
    manaMask:SetSize(256, 16)
    manaBar:GetStatusBarTexture():AddMaskTexture(manaMask)

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

------ target of target
DragonflightUIEditModePreviewTargetOfTargetMixin = {}
Mixin(DragonflightUIEditModePreviewTargetOfTargetMixin, DragonflightUIEditModePreviewTargetMixin)

function DragonflightUIEditModePreviewTargetOfTargetMixin:OnLoad()
    -- print('~~~~~~~~~~~~DragonflightUIEditModePreviewRaidMixin:OnLoad()')

    -- local sizeX, sizeY = _G['TargetFrameToT']:GetSize()
    local sizeX, sizeY = 120, 45;
    self:SetSize(sizeX, sizeY)
    self:SetupFrame()
    self:SetRandomUnit()
end

function DragonflightUIEditModePreviewTargetOfTargetMixin:SetupFrame()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    local textureFrame = CreateFrame('Frame', 'DragonflightUITargetOfTargetTextureFrame', self)
    textureFrame:SetPoint('CENTER')
    textureFrame:SetFrameLevel(3)
    self.TextureFrame = textureFrame
    local totDelta = 1

    local portrait = self.TextureFrame:CreateTexture('DragonflightUIPreviewTargetOfTargetFramePortrait')
    portrait:SetDrawLayer('ARTWORK', 1)
    portrait:SetSize(35, 35)

    portrait:SetPoint('TOPLEFT', self, 'TOPLEFT', 6, -6)
    self.TargetFramePortrait = portrait
    function portrait:UpdatePortrait(id)
        if not id then return end
        -- SetPortraitTexture(self.TargetFramePortrait, unit)   
        SetPortraitTextureFromCreatureDisplayID(portrait, tonumber(id) or 0);
    end
    portrait:UpdatePortrait('player')

    local background = self:CreateTexture('DragonflightUITargetOfTargetFrameBackground')
    background:SetDrawLayer('BACKGROUND', 2)
    background:SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BORDER')
    background:SetPoint('LEFT', portrait, 'CENTER', -25 + 1, -10 + totDelta)
    self.TargetFrameBackground = background

    local border = self.TextureFrame:CreateTexture('DragonflightUITargetOfTargetFrameBorder')
    border:SetDrawLayer('ARTWORK', 2)
    border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BORDER')
    border:SetPoint('LEFT', portrait, 'CENTER', -25 + 1, -10 + totDelta)
    self.TargetFrameBorder = border

    local healthBar = CreateFrame("StatusBar", nil, self)
    healthBar:SetSize(70.5, 10)
    healthBar:SetPoint('LEFT', portrait, 'RIGHT', 1 + 1, 0 + totDelta)

    healthBar:SetStatusBarTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health')
    healthBar:SetStatusBarColor(1, 1, 1, 1)
    healthBar:SetMinMaxValues(0, 100)
    healthBar:SetValue(69)
    self.HealthBar = healthBar
    function healthBar:SetClass(class)
        if class == '' then
            healthBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health')
            healthBar:SetStatusBarColor(1, 1, 1, 1)
        else
            healthBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health-Status')
            -- local localizedClass, englishClass, classIndex = UnitClass('focus')
            healthBar:SetStatusBarColor(DF:GetClassColor(class, 1))
        end
    end
    self.HealthBar:SetClass('PRIEST')

    local manaBar = CreateFrame("StatusBar", nil, self)
    manaBar:SetPoint('LEFT', portrait, 'RIGHT', 1 - 2 - 1.5 + 1, 2 - 10 - 1 + totDelta)
    manaBar:SetSize(74, 7.5)
    manaBar:SetStatusBarTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health')
    manaBar:SetStatusBarColor(1, 1, 1, 1)
    manaBar:SetMinMaxValues(0, 100)
    manaBar:SetValue(100)

    -- local manaMask = manaBar:CreateMaskTexture()
    -- manaMask:SetPoint('TOPLEFT', manaBar, 'TOPLEFT', -61, 3)
    -- manaMask:SetTexture(
    --     'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\ui-hud-unitframe-target-portraiton-bar-mana-mask-2x',
    --     'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
    -- manaMask:SetTexCoord(0, 1, 0, 1)
    -- manaMask:SetSize(256, 16)
    -- manaBar:GetStatusBarTexture():AddMaskTexture(manaMask)

    self.ManaBar = manaBar
    function manaBar:SetPowerType(powerTypeString)
        if powerTypeString == 'MANA' then
            manaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana')
        elseif powerTypeString == 'FOCUS' then
            manaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Focus')
        elseif powerTypeString == 'RAGE' then
            manaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Rage')
        elseif powerTypeString == 'ENERGY' then
            manaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Energy')
        elseif powerTypeString == 'RUNIC_POWER' then
            manaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-RunicPower')
        end
    end
    self.ManaBar:SetPowerType('MANA')

    -- -- TargetFrameTextureFrameRaidTargetIcon:SetPoint('CENTER', TargetFramePortrait, 'TOP', 0, 2)
    -- local targetIcon = self.TextureFrame:CreateTexture('DragonflightUIRaidTarget')
    -- targetIcon:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcons')
    -- targetIcon:SetDrawLayer('ARTWORK', 5)
    -- targetIcon:SetSize(26, 26)
    -- targetIcon:ClearAllPoints()
    -- targetIcon:SetPoint('CENTER', portrait, 'TOP', 0, 2)
    -- targetIcon:Hide()
    -- self.RaidTargetIcon = targetIcon
    -- function targetIcon:UpdateTargetIcon(index)
    --     -- local index = GetRaidTargetIndex(unit);
    --     if (index > 0) then
    --         SetRaidTargetIconTexture(targetIcon, index);
    --         targetIcon:Show();
    --     else
    --         targetIcon:Hide();
    --     end
    -- end
    -- targetIcon:UpdateTargetIcon(0)

    local fontName = self:CreateFontString('**', 'OVERLAY', 'GameFontNormalSmall')
    fontName:SetPoint('LEFT', portrait, 'RIGHT', 1 + 1, 2 + 12 - 1 + totDelta)
    fontName:SetSize(100, 10)
    fontName:SetJustifyH('LEFT')
    self.FontName = fontName
    function fontName:SetName(name)
        fontName:SetText(name)
    end
    fontName:SetName('Zimtschnecke')

    -- local fontLevel = self:CreateFontString('**', 'OVERLAY', 'GameFontNormalSmall')
    -- fontLevel:SetPoint('BOTTOMRIGHT', healthBar, 'TOPLEFT', 16, 3 - 2)
    -- fontLevel:SetHeight(12);
    -- self.FontLevel = fontLevel
    -- function fontLevel:SetLevel(lvl)
    --     fontLevel:SetText(lvl)
    -- end
    -- fontLevel:SetLevel('69')

    -- local nameBackground = self:CreateTexture('')
    -- nameBackground:SetTexture(base)
    -- nameBackground:SetTexCoord(0.7939453125, 0.92578125, 0.3125, 0.34765625)
    -- nameBackground:SetSize(135, 18)
    -- nameBackground:SetPoint('BOTTOMLEFT', healthBar, 'TOPLEFT', -2, -4 - 1)
    -- function nameBackground:SetColor(type)
    --     if type == 'white' then
    --         nameBackground:SetVertexColor(1, 1, 1, 1);
    --     elseif type == 'blue' then
    --         nameBackground:SetVertexColor(0, 0, 1, 1);
    --     elseif type == 'green' then
    --         nameBackground:SetVertexColor(0, 1, 0, 1);
    --     elseif type == 'red' then
    --         nameBackground:SetVertexColor(1, 0, 0, 1);
    --     elseif type == 'yellow' then
    --         nameBackground:SetVertexColor(1, 1, 0, 1);
    --     end
    -- end
    -- nameBackground:SetColor('blue')
    -- self.NameBackground = nameBackground
end

------- party frame
DragonflightUIEditModePreviewPartyFrameMixin = {}
function DragonflightUIEditModePreviewPartyFrameMixin:OnLoad()
    -- print('~~ DragonflightUIEditModePreviewPartyFrameMixin:OnLoad()')

    local sizeX, sizeY = _G['PartyMemberFrame' .. 1]:GetSize()
    local gap = 10;
    self:SetSize(sizeX, sizeY * 4 + 3 * gap)

    self.LastUpdate = GetTime()
    self.PartyFrames = {}

    for k = 1, 4 do
        -- 
        local fakeParty = CreateFrame('Frame', 'DragonflightUIEditModeParty' .. k .. 'Preview', self,
                                      'DFEditModePreviewPartyTemplate')
        fakeParty:OnLoad()
        if k == 1 then
            fakeParty:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)
        else
            fakeParty:SetPoint('TOPLEFT', self.PartyFrames[k - 1], 'BOTTOMLEFT', 0, -gap)
        end

        self.PartyFrames[k] = fakeParty;
    end

    self:SetScript('OnEvent', self.OnEvent)
    self:RegisterEvent('GROUP_ROSTER_UPDATE')
    self:RegisterEvent("CVAR_UPDATE")

    self:UpdateVisibility()
end

function DragonflightUIEditModePreviewPartyFrameMixin:OnUpdate(elapsed)
    local updateInterval = 0.15;

    if not self.DFEditMode then return; end

    if GetTime() - self.LastUpdate >= updateInterval then
        self.LastUpdate = GetTime()
        -- print('self:OnUpdate')
        -- if self.UpdateBlizzard then self:UpdateBlizzard() end
    end
end

function DragonflightUIEditModePreviewPartyFrameMixin:UpdateBlizzard()
    -- local PartyMoveFrame = self.DFEditModeSelection.ModuleRef.PartyMoveFrame;

    -- local state = self.state;
    -- local parent = _G[state.anchorFrame]

    -- local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint(1)
    -- PartyMoveFrame:ClearAllPoints();
    -- -- self.PartyMoveFrame:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    -- PartyMoveFrame:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
    -- PartyMoveFrame:SetScale(state.scale)
end

function DragonflightUIEditModePreviewPartyFrameMixin:UpdateState(state)
    self.state = state;
    self:Update()
end

function DragonflightUIEditModePreviewPartyFrameMixin:Update()
    local state = self.state;
    self:ClearAllPoints()

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    self:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    self:SetScale(state.scale)

    local sizeX, sizeY = _G['PartyMemberFrame' .. 1]:GetSize()

    if state.orientation == 'vertical' then
        self:SetSize(sizeX, sizeY * 4 + 3 * state.padding)
    else
        self:SetSize(sizeX * 4 + 3 * state.padding, sizeY)
    end

    for i = 2, 4 do
        local pf = self.PartyFrames[i]

        if state.orientation == 'vertical' then
            pf:ClearAllPoints()
            pf:SetPoint('TOPLEFT', self.PartyFrames[i - 1], 'BOTTOMLEFT', 0, -state.padding)
        else
            pf:ClearAllPoints()
            pf:SetPoint('TOPLEFT', self.PartyFrames[i - 1], 'TOPRIGHT', state.padding, 0)
        end
    end

    for k, v in ipairs(self.PartyFrames) do
        --
        v:UpdateState(state)
    end

    self:UpdateVisibility()
end

function DragonflightUIEditModePreviewPartyFrameMixin:UpdateVisibility()
    if (GetDisplayedAllyFrames() ~= "party") then
        for k, v in ipairs(self.PartyFrames) do
            --           
            v:Show()
        end
        return;
    end
    for k, v in ipairs(self.PartyFrames) do
        --
        if UnitExists('party' .. k) then
            v:Hide()
        else
            v:Show()
        end
    end
end

function DragonflightUIEditModePreviewPartyFrameMixin:OnEvent(event, arg1, ...)
    -- print(event, arg1, ...)

    if event == 'GROUP_ROSTER_UPDATE' then
        --
        -- print('GROUP_ROSTER_UPDATE')
        self:UpdateVisibility()
    elseif event == 'CVAR_UPDATE' and arg1 == 'useCompactPartyFrames' then
        self:UpdateVisibility()
    end
end

------ individual party member
DragonflightUIEditModePreviewPartyMixin = {}
Mixin(DragonflightUIEditModePreviewPartyMixin, DragonflightUIEditModePreviewTargetMixin)

function DragonflightUIEditModePreviewPartyMixin:OnLoad()
    -- print('~~~~~~~~~~~~DragonflightUIEditModePreviewPartyMixin:OnLoad()')

    local sizeX, sizeY = _G['PartyMemberFrame' .. 1]:GetSize()
    self:SetSize(sizeX, sizeY)
    self:SetupFrame()
    self:SetRandomUnit()
end

function DragonflightUIEditModePreviewPartyMixin:SetupFrame()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    local textureFrame = CreateFrame('Frame', 'DragonflightUIPartyFrameTextureFrame', self)
    textureFrame:SetPoint('CENTER')
    textureFrame:SetFrameLevel(3)
    self.TextureFrame = textureFrame

    -- local background = self:CreateTexture('DragonflightUITargetFrameBackground')
    -- background:SetDrawLayer('BACKGROUND', 2)
    -- background:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BACKGROUND')
    -- background:SetPoint('LEFT', self, 'LEFT', 0, -32.5 + 10)
    -- self.TargetFrameBackground = background

    local border = self:CreateTexture('DragonflightUIPartyFrameBorder')
    border:SetDrawLayer('ARTWORK', 3)
    border:SetSize(120, 49)
    border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\uipartyframe')
    border:SetTexCoord(0.480469, 0.949219, 0.222656, 0.414062)
    border:SetPoint('TOPLEFT', self, 'TOPLEFT', 1, -2)
    self.TargetFrameBorder = border

    local portrait = self:CreateTexture('DragonflightUIPartyFramePortrait')
    portrait:SetDrawLayer('ARTWORK', 1)
    portrait:SetSize(37, 37)
    portrait:SetPoint('TOPLEFT', self, 'TOPLEFT', 7, -6)
    self.TargetFramePortrait = portrait
    function portrait:UpdatePortrait(id)
        if not id then return end
        -- SetPortraitTexture(self.TargetFramePortrait, unit)   
        SetPortraitTextureFromCreatureDisplayID(portrait, tonumber(id) or 0);
    end

    -- local extra = self.TextureFrame:CreateTexture('DragonflightUIPartyFramePortraitExtra')
    -- extra:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiunitframeboss2x')
    -- extra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
    -- extra:SetSize(80, 79)
    -- extra:SetDrawLayer('ARTWORK', 3)
    -- extra:SetPoint('CENTER', portrait, 'CENTER', 4, 1)
    -- self.PortraitExtra = extra

    -- function extra:UpdateStyle(class)
    --     -- local class = UnitClassification('target')
    --     --[[ "worldboss", "rareelite", "elite", "rare", "normal", "trivial" or "minus" ]]
    --     if class == 'worldboss' then
    --         extra:Show()
    --         extra:SetSize(99, 81)
    --         extra:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.31835937)
    --         extra:SetPoint('CENTER', portrait, 'CENTER', 13, 1)
    --     elseif class == 'rareelite' or class == 'rare' then
    --         extra:Show()
    --         extra:SetSize(80, 79)
    --         extra:SetTexCoord(0.00390625, 0.31640625, 0.64453125, 0.953125)
    --         extra:SetPoint('CENTER', portrait, 'CENTER', 4, 1)
    --     elseif class == 'elite' then
    --         extra:Show()
    --         extra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
    --         extra:SetSize(80, 79)
    --         extra:SetPoint('CENTER', portrait, 'CENTER', 4, 1)
    --     else
    --         local name, realm = UnitName('target')
    --         if false then
    --             extra:Show()
    --             extra:SetSize(99, 81)
    --             extra:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.31835937)
    --             extra:SetPoint('CENTER', portrait, 'CENTER', 13, 1)
    --         else
    --             extra:Hide()
    --         end
    --     end
    -- end
    -- -- self.PortraitExtra:UpdateStyle('worldboss')

    if DF.Wrath then
        local roleIcon = self.TextureFrame:CreateTexture('DragonflightUIPartyFrameRoleIcon')
        roleIcon:SetSize(12, 12)
        roleIcon:SetPoint('TOPRIGHT', self, 'TOPRIGHT', -5, -5)
        roleIcon:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\roleicons')
        roleIcon:SetTexCoord(0.015625, 0.265625, 0.03125, 0.53125)

        function roleIcon:UpdateRoleIcon(role)
            roleIcon:Show()
            if role == 'TANK' then
                roleIcon:SetTexCoord(0.578125, 0.828125, 0.03125, 0.53125)
            elseif role == 'HEALER' then
                roleIcon:SetTexCoord(0.296875, 0.546875, 0.03125, 0.53125)
            elseif role == 'DAMAGER' then
                roleIcon:SetTexCoord(0.015625, 0.265625, 0.03125, 0.53125)
            else
                roleIcon:Hide()
            end
        end
        roleIcon:UpdateRoleIcon('TANK')
        self.RoleIcon = roleIcon
    end

    local healthBar = CreateFrame("StatusBar", nil, self)
    healthBar:SetMinMaxValues(0, 100)
    healthBar:SetValue(69)
    healthBar:SetSize(70 + 1, 10)
    healthBar:ClearAllPoints()
    healthBar:SetPoint('TOPLEFT', 45 - 1, -19)
    healthBar:SetStatusBarTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Health')
    healthBar:SetStatusBarColor(1, 1, 1, 1)

    local hpMask = healthBar:CreateMaskTexture()
    -- hpMask:SetPoint('TOPLEFT', pf, 'TOPLEFT', -29, 3)
    hpMask:SetPoint('CENTER', healthBar, 'CENTER', 0, 0)
    hpMask:SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Health-Mask',
        'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
    hpMask:SetSize(70 + 1, 10)
    healthBar:GetStatusBarTexture():AddMaskTexture(hpMask)

    self.HealthBar = healthBar
    function healthBar:SetClass(class)
        if class == '' then
            healthBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Health')
            healthBar:SetStatusBarColor(1, 1, 1, 1)
        else
            healthBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Health-Status')
            -- local localizedClass, englishClass, classIndex = UnitClass('focus')
            healthBar:SetStatusBarColor(DF:GetClassColor(class, 1))
        end
    end
    self.HealthBar:SetClass('PRIEST')

    local manaBar = CreateFrame("StatusBar", nil, self)
    manaBar:SetMinMaxValues(0, 100)
    manaBar:SetValue(100)
    manaBar:SetSize(74, 7)
    manaBar:ClearAllPoints()
    manaBar:SetPoint('TOPLEFT', 41, -30)
    manaBar:SetStatusBarTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Mana')
    manaBar:SetStatusBarColor(1, 1, 1, 1)

    local manaMask = manaBar:CreateMaskTexture()
    -- hpMask:SetPoint('TOPLEFT', pf, 'TOPLEFT', -29, 3)
    manaMask:SetPoint('CENTER', manaBar, 'CENTER', 0, 0)
    manaMask:SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Mana-Mask',
        'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
    manaMask:SetSize(74, 7)
    manaBar:GetStatusBarTexture():AddMaskTexture(manaMask)

    self.ManaBar = manaBar
    function manaBar:SetPowerType(powerTypeString)
        if powerTypeString == 'MANA' then
            manaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Mana')
        elseif powerTypeString == 'FOCUS' then
            manaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Focus')
        elseif powerTypeString == 'RAGE' then
            manaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Rage')
        elseif powerTypeString == 'ENERGY' then
            manaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Energy')
        elseif powerTypeString == 'RUNIC_POWER' then
            manaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-RunicPower')
        end
    end
    self.ManaBar:SetPowerType('MANA')

    -- TargetFrameTextureFrameRaidTargetIcon:SetPoint('CENTER', TargetFramePortrait, 'TOP', 0, 2)
    -- local targetIcon = self.TextureFrame:CreateTexture('DragonflightUIRaidTarget')
    -- targetIcon:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcons')
    -- targetIcon:SetDrawLayer('ARTWORK', 5)
    -- targetIcon:SetSize(26, 26)
    -- targetIcon:ClearAllPoints()
    -- targetIcon:SetPoint('CENTER', portrait, 'TOP', 0, 2)
    -- targetIcon:Hide()
    -- self.RaidTargetIcon = targetIcon
    -- function targetIcon:UpdateTargetIcon(index)
    --     -- local index = GetRaidTargetIndex(unit);
    --     if (index > 0) then
    --         SetRaidTargetIconTexture(targetIcon, index);
    --         targetIcon:Show();
    --     else
    --         targetIcon:Hide();
    --     end
    -- end
    -- targetIcon:UpdateTargetIcon(0)

    local fontName = self:CreateFontString('**', 'OVERLAY', 'GameFontNormalSmall')
    fontName:SetPoint('TOPLEFT', self, 'TOPLEFT', 46, -6)
    fontName:SetSize(57, 12)
    if DF.Era then fontName:SetWidth(100) end
    fontName:SetJustifyH('LEFT')
    self.FontName = fontName
    function fontName:SetName(name)
        fontName:SetText(name)
    end
    fontName:SetName('Zimtschnecke')

    -- local fontLevel = self:CreateFontString('**', 'OVERLAY', 'GameFontNormalSmall')
    -- fontLevel:SetPoint('BOTTOMRIGHT', healthBar, 'TOPLEFT', 16, 3 - 2)
    -- fontLevel:SetHeight(12);
    -- self.FontLevel = fontLevel
    -- function fontLevel:SetLevel(lvl)
    --     fontLevel:SetText(lvl)
    -- end
    -- fontLevel:SetLevel('69')

    -- local nameBackground = self:CreateTexture('')
    -- nameBackground:SetTexture(base)
    -- nameBackground:SetTexCoord(0.7939453125, 0.92578125, 0.3125, 0.34765625)
    -- nameBackground:SetSize(135, 18)
    -- nameBackground:SetPoint('BOTTOMLEFT', healthBar, 'TOPLEFT', -2, -4 - 1)
    -- function nameBackground:SetColor(type)
    --     if type == 'white' then
    --         nameBackground:SetVertexColor(1, 1, 1, 1);
    --     elseif type == 'blue' then
    --         nameBackground:SetVertexColor(0, 0, 1, 1);
    --     elseif type == 'green' then
    --         nameBackground:SetVertexColor(0, 1, 0, 1);
    --     elseif type == 'red' then
    --         nameBackground:SetVertexColor(1, 0, 0, 1);
    --     elseif type == 'yellow' then
    --         nameBackground:SetVertexColor(1, 1, 0, 1);
    --     end
    -- end
    -- nameBackground:SetColor('blue')
    -- self.NameBackground = nameBackground
end

function DragonflightUIEditModePreviewPartyMixin:UpdateState(state)
    -- self:ClearAllPoints()
    -- local parent = _G[state.anchorFrame]
    -- self:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    -- self:SetScale(state.scale)

    -- self.NameBackground:SetShown(not state.hideNameBackground)

    if state.classcolor then
        self.HealthBar:SetClass(self.Unit.class)
    else
        self.HealthBar:SetClass('')
    end
end

------- raid frame
DragonflightUIEditModePreviewRaidFrameMixin = {}
function DragonflightUIEditModePreviewRaidFrameMixin:OnLoad()
    -- print('~~ DragonflightUIEditModePreviewRaidFrameMixin:OnLoad()')

    self:SetSize(100, 100)

    self.PartyFrames = {}
    local gap = 0;

    for k = 1, 40 do
        -- 
        local member = CreateFrame('Frame', 'DragonflightUIEditModeRaid' .. k .. 'Preview', self,
                                   'DFEditModePreviewRaidTemplate')
        member:OnLoad()
        if k == 1 then
            member:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)
        else
            member:SetPoint('TOPLEFT', self.PartyFrames[k - 1], 'BOTTOMLEFT', 0, -gap)
        end

        if k % 5 == 1 then
            member.GroupHeader = member:CreateFontString('DragonflightUIRaidPreviewGroupHeader', 'ARTWORK',
                                                         'GameFontNormalSmall')
            member.GroupHeader:SetSize(50, 14)
            member.GroupHeader:SetPoint('BOTTOM', member, 'TOP', 0, 0)
            member.GroupHeader:SetFormattedText(GROUP_NUMBER, ((k - 1) / 5) + 1);
        end

        self.PartyFrames[k] = member;
    end

    self.AssistFrames = {};
    for k = 1, 2 do
        -- 
        local member = CreateFrame('Frame', 'DragonflightUIEditModeRaid' .. k .. 'Preview', self,
                                   'DFEditModePreviewRaidTemplate')
        member:OnLoad()
        if k == 1 then
            member:SetPoint('TOPRIGHT', self, 'TOPLEFT', 0, 0)
        else
            member:SetPoint('TOPLEFT', self.AssistFrames[k - 1], 'BOTTOMLEFT', 0, -gap)
        end
        self.AssistFrames[k] = member;

        if k % 2 == 1 then
            member.roleIcon:UpdateRoleIcon('MAINTANK')
        else
            member.roleIcon:UpdateRoleIcon('MAINASSIST')
        end

    end

    -- self:SetScript('OnEvent', self.OnEvent)
    -- self:RegisterEvent('GROUP_ROSTER_UPDATE')
    -- self:RegisterEvent("CVAR_UPDATE")

    -- self:UpdateVisibility()
    self.MaxToShow = 15;
    self:UpdateState(nil)

    hooksecurefunc(InterfaceOverrides, 'SetRaidProfileOption', function(option, value)
        --
        -- print('SetRaidProfileOption', option, value);
        self:UpdateState(nil);
    end)

    local updateInterval = 0.15;
    self.LastUpdate = GetTime()
    hooksecurefunc('CompactRaidFrameManager_ResizeFrame_UpdateContainerSize', function(manager)
        --
        if GetTime() - self.LastUpdate >= updateInterval then
            self.LastUpdate = GetTime()
            -- print('CompactRaidFrameManager_ResizeFrame_UpdateContainerSize', manager.container:GetHeight())
            self:UpdateState(nil)
        else
        end
    end)
end

function DragonflightUIEditModePreviewRaidFrameMixin:UpdateState(state)
    -- self:ClearAllPoints()
    -- local parent = _G[state.anchorFrame]
    -- self:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    -- self:SetScale(state.scale)

    local settings = GetRaidProfileFlattenedOptions(GetActiveRaidProfile());
    local maxToShow = self.MaxToShow;
    local gap = 0;

    local manager = CompactRaidFrameManager;
    local managerSize = manager.container:GetHeight();

    if settings.displayMainTankAndAssist then
        for k, v in ipairs(self.AssistFrames) do
            --
            v:Show()
            v:UpdateState(settings)
        end

        local f = _G['CompactRaidFrameManagerContainerResizeFrame']
        self:ClearAllPoints()
        self:SetPoint('TOPLEFT', f, 'TOPLEFT', 4 + settings.frameWidth, -7)
        self:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 0, 0)
    else
        for k, v in ipairs(self.AssistFrames) do
            --
            v:Hide()
        end

        local f = _G['CompactRaidFrameManagerContainerResizeFrame']
        self:ClearAllPoints()
        self:SetPoint('TOPLEFT', f, 'TOPLEFT', 4, -7)
        self:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 0, 0)
    end

    -- local f = _G['CompactRaidFrameManagerContainerResizeFrame']

    --     local fakeRaid = CreateFrame('Frame', 'DragonflightUIEditModeRaidFramePreview', f,
    --                                  'DFEditModePreviewRaidFrameTemplate')
    --     fakeRaid:OnLoad()
    --     fakeRaid:SetPoint('TOPLEFT', f, 'TOPLEFT', 4, -7)

    if settings.keepGroupsTogether then
        local borderSize = (settings.displayBorder and 8) or 0;
        if settings.horizontalGroups then
            local maxRows = math.floor(managerSize / (settings.frameHeight + 14)) -- 14 = title
            maxRows = math.min(maxRows, 8)
            maxRows = math.max(maxRows, 1)
            -- print('maxRows:', maxRows)
            for k, v in ipairs(self.PartyFrames) do
                --
                if k > maxToShow then
                    v:Hide()
                else
                    v:Show()
                    v:UpdateState(settings)

                    local mod = k % 5;
                    -- print(k, mod)
                    if k == 1 then
                        -- first stays
                        v:ClearAllPoints();
                        v:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0 - 14);
                    elseif mod == 1 then
                        -- header
                        local groupIndex = 1 + (k - mod) / 5; -- 1,2,3             

                        local column = math.floor((groupIndex - 1) / maxRows) + 1;
                        local row = groupIndex - maxRows * (column - 1);

                        v:ClearAllPoints();
                        v:SetPoint('TOPLEFT', self, 'TOPLEFT', (column - 1) * 5 * settings.frameWidth,
                                   -(row - 1) * (settings.frameHeight + 14) - 14);
                    else
                        v:ClearAllPoints();
                        v:SetPoint('TOPLEFT', self.PartyFrames[k - 1], 'TOPRIGHT', 0, 0);
                    end
                end
            end
        else
            local maxRows = math.floor(managerSize / (5 * settings.frameHeight + 14)) -- 14 = title
            if maxRows < 1 then
                maxRows = 1
            elseif maxRows > 1 then
                maxRows = 2;
            end
            -- print('maxRows:', maxRows)
            for k, v in ipairs(self.PartyFrames) do
                --
                if k > maxToShow then
                    v:Hide()
                else
                    v:Show()
                    v:UpdateState(settings)

                    local mod = k % 5;
                    -- print(k, mod)
                    if k == 1 then
                        -- first stays
                        v:ClearAllPoints();
                        v:SetPoint('TOPLEFT', self, 'TOPLEFT', 0 + borderSize, 0 - 14);
                        -- print(k, 1)
                    elseif mod == 1 then
                        -- header
                        local groupIndex = 1 + (k - mod) / 5; -- 1,2,3
                        local groupIndexZero = groupIndex - 1;
                        -- print(k, groupIndex)

                        if maxRows == 1 then
                            v:ClearAllPoints();
                            v:SetPoint('TOPLEFT', self, 'TOPLEFT',
                                       (((k - mod) / 5)) * (settings.frameWidth + 2 * borderSize), 0 - 14);
                        else
                            if groupIndex % 2 == 0 then
                                -- 2,4
                                v:ClearAllPoints();
                                v:SetPoint('TOPLEFT', self.PartyFrames[k - 1], 'BOTTOMLEFT', 0, -gap - 14 - borderSize);
                            else
                                -- 3,5
                                v:ClearAllPoints();
                                v:SetPoint('TOPLEFT', self, 'TOPLEFT', (((k - 5 * (math.floor(groupIndex / 2)) - mod) /
                                               5)) * (settings.frameWidth + 2 * borderSize), 0 - 14);
                            end
                        end
                    else
                        v:ClearAllPoints();
                        v:SetPoint('TOPLEFT', self.PartyFrames[k - 1], 'BOTTOMLEFT', 0, -gap);
                    end
                end
            end
        end
    else
        local maxRows = math.floor(managerSize / settings.frameHeight)
        -- print('maxRows:', maxRows)
        for k, v in ipairs(self.PartyFrames) do
            --
            if k > maxToShow then
                v:Hide()
            else
                v:Show()
                v:UpdateState(settings)
                if k == 1 then
                    -- first stays
                    v:ClearAllPoints();
                    v:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0);
                    -- print(k, 1, 1)
                else
                    local zeroIndex = k - 1;
                    local column = 1 + math.floor(zeroIndex / maxRows);
                    local row = 1 + (zeroIndex % maxRows);

                    -- print(k, column, row)
                    v:ClearAllPoints()
                    v:SetPoint('TOPLEFT', self, 'TOPLEFT', (column - 1) * settings.frameWidth,
                               -(row - 1) * settings.frameHeight)
                end
            end
        end
    end

    self:UpdateVisibility()
end

function DragonflightUIEditModePreviewRaidFrameMixin:UpdateVisibility()
    -- if (GetDisplayedAllyFrames() ~= "party") then
    --     for k, v in ipairs(self.PartyFrames) do
    --         --           
    --         v:Show()
    --     end
    --     return;
    -- end
    -- for k, v in ipairs(self.PartyFrames) do
    --     --
    --     if UnitExists('party' .. k) then
    --         v:Hide()
    --     else
    --         v:Show()
    --     end
    -- end
end

function DragonflightUIEditModePreviewRaidFrameMixin:OnEvent(event, arg1, ...)
    -- print(event, arg1, ...)

    -- if event == 'GROUP_ROSTER_UPDATE' then
    --     --
    --     -- print('GROUP_ROSTER_UPDATE')
    --     self:UpdateVisibility()
    -- elseif event == 'CVAR_UPDATE' and arg1 == 'useCompactPartyFrames' then
    --     self:UpdateVisibility()
    -- end
end

------ individual raid member
DragonflightUIEditModePreviewRaidMixin = {}
Mixin(DragonflightUIEditModePreviewRaidMixin, DragonflightUIEditModePreviewTargetMixin)

function DragonflightUIEditModePreviewRaidMixin:OnLoad()
    -- print('~~~~~~~~~~~~DragonflightUIEditModePreviewRaidMixin:OnLoad()')

    local sizeX, sizeY = _G['PartyMemberFrame' .. 1]:GetSize()
    self:SetSize(sizeX, sizeY)
    self:SetupFrame()
    self:SetRandomUnit()
end

local NATIVE_UNIT_FRAME_HEIGHT = 36;
local NATIVE_UNIT_FRAME_WIDTH = 72;
-- DefaultCompactUnitFrameSetupOptions = {
-- 	displayPowerBar = true,
-- 	height = NATIVE_UNIT_FRAME_HEIGHT,
-- 	width = NATIVE_UNIT_FRAME_WIDTH,
-- 	displayBorder = true,
-- }

function DragonflightUIEditModePreviewRaidMixin:SetupFrame()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'
    local frame = self;

    local options = DefaultCompactUnitFrameSetupOptions;
    local componentScale = min(options.height / NATIVE_UNIT_FRAME_HEIGHT, options.width / NATIVE_UNIT_FRAME_WIDTH);

    frame:SetAlpha(1);

    frame:SetSize(options.width, options.height);
    local powerBarHeight = 8;
    local powerBarUsedHeight = options.displayPowerBar and powerBarHeight or 0;

    frame.background = frame:CreateTexture('DragonflightUIBackgroundTexture')
    frame.background:SetAllPoints()
    frame.background:SetTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Bg");
    frame.background:SetTexCoord(0, 1, 0, 0.53125);

    frame.healthBar = CreateFrame('StatusBar', nil, self)
    frame.healthBar:SetMinMaxValues(0, 100)
    frame.healthBar:SetValue(69)
    -- frame.healthBar:SetFrameStrata('LOW')

    function frame.healthBar:SetClass(class)
        if class == '' then
            frame.healthBar:SetStatusBarColor(1, 1, 1, 1)
        else
            frame.healthBar:SetStatusBarColor(DF:GetClassColor(class, 1))
        end
    end
    frame.healthBar:SetClass('PRIEST')

    frame.healthBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1);
    frame.healthBar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1);
    frame.healthBar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1 + powerBarUsedHeight);

    frame.healthBar:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill");
    frame.healthBar:SetStatusBarColor(0.0, 1.0, 0.0) -- 
    frame.healthBar:SetFrameLevel(7)

    frame.powerBar = CreateFrame('StatusBar', nil, self)
    frame.powerBar:SetMinMaxValues(0, 100)
    frame.powerBar:SetValue(100)

    frame.powerBar.background = frame.powerBar:CreateTexture(nil, 'BACKGROUND')
    frame.powerBar.background:SetAllPoints()

    if (frame.powerBar) then
        if (options.displayPowerBar) then
            if (options.displayBorder) then
                frame.powerBar:SetPoint("TOPLEFT", frame.healthBar, "BOTTOMLEFT", 0, -2);
            else
                frame.powerBar:SetPoint("TOPLEFT", frame.healthBar, "BOTTOMLEFT", 0, 0);
            end
            frame.powerBar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1);
            frame.powerBar:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Resource-Fill");
            frame.powerBar.background:SetTexture("Interface\\RaidFrame\\Raid-Bar-Resource-Background");
            frame.powerBar:Show();
        else
            frame.powerBar:Hide();
        end
    end

    function frame.powerBar:SetPowerType(powerType)
        local r, g, b;
        local info = PowerBarColor[powerType];
        if (info) then
            r, g, b = info.r, info.g, info.b;
        else
            if (not altR) then
                -- couldn't find a power token entry...default to indexing by power type or just mana if we don't have that either
                info = PowerBarColor[powerType] or PowerBarColor["MANA"];
                r, g, b = info.r, info.g, info.b;
            else
                r, g, b = altR, altG, altB;
            end
        end
        frame.powerBar:SetStatusBarColor(r, g, b);
    end

    frame.iconFrame = CreateFrame('FRAME', 'DragonflightUIIconFrame', frame)
    -- frame.iconFrame:SetAllPoints()
    frame.iconFrame:SetPoint('TOPLEFT', frame, 'TOPLEFT', 0, 0)
    frame.iconFrame:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', 0, 0)
    frame.iconFrame:SetHeight(12)

    -- frame.iconFrame:SetSize(55, 55)
    frame.iconFrame:SetFrameLevel(10)

    frame.roleIcon = frame.iconFrame:CreateTexture('DragonflightUIRoleIcon', 'ARTWORK')
    frame.roleIcon:ClearAllPoints();
    frame.roleIcon:SetPoint("TOPLEFT", frame, 'TOPLEFT', 3, -2);
    frame.roleIcon:SetSize(12, 12);
    -- frame.roleIcon:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\roleicons')

    -- function frame.roleIcon:UpdateRoleIcon(role)
    --     frame.roleIcon:Show()
    --     if role == 'TANK' then
    --         frame.roleIcon:SetTexCoord(0.578125, 0.828125, 0.03125, 0.53125)
    --     elseif role == 'HEALER' then
    --         frame.roleIcon:SetTexCoord(0.296875, 0.546875, 0.03125, 0.53125)
    --     elseif role == 'DAMAGER' then
    --         frame.roleIcon:SetTexCoord(0.015625, 0.265625, 0.03125, 0.53125)
    --     else
    --         frame.roleIcon:Hide()
    --     end
    -- end
    function frame.roleIcon:UpdateRoleIcon(role)
        frame.roleIcon:Show()
        if (role == "TANK" or role == "HEALER" or role == "DAMAGER") then
            frame.roleIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES");
            frame.roleIcon:SetTexCoord(GetTexCoordsForRoleSmallCircle(role));
        elseif (role == 'MAINTANK' or role == 'MAINASSIST') then
            frame.roleIcon:SetTexture("Interface\\GroupFrame\\UI-Group-" .. role .. "Icon");
            frame.roleIcon:SetTexCoord(0, 1, 0, 1);
        else
            frame.roleIcon:Hide()
        end
    end
    frame.roleIcon:UpdateRoleIcon('TANK')

    frame.name = frame.iconFrame:CreateFontString('DragonflightUIName', 'ARTWORK', 'GameFontHighlightSmall')
    frame.name:SetPoint("TOPLEFT", frame.roleIcon, "TOPRIGHT", 0, -1);
    frame.name:SetPoint("TOPRIGHT", frame, 'TOPRIGHT', -3, -3);
    frame.name:SetJustifyH("LEFT");
    frame.name:SetWordWrap(false);
    frame.name:SetText('Zimt <3')

    function frame.name:SetName(name)
        frame.name:SetText(name)
    end
    frame.name:SetName('Zimtschnecke')

    frame.statusText = frame.powerBar:CreateFontString('DragonflightUIStatusText', 'ARTWORK', 'GameFontDisable')

    local NATIVE_FONT_SIZE = 12;
    local fontName, fontSize, fontFlags = frame.statusText:GetFont();
    frame.statusText:SetFont('GameFontDisable', NATIVE_FONT_SIZE * componentScale, fontFlags);
    frame.statusText:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 3, options.height / 3 - 2);
    frame.statusText:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, options.height / 3 - 2);
    frame.statusText:SetHeight(12 * componentScale);
    frame.statusText:SetText('100%')

    frame.horizTopBorder = frame.healthBar:CreateTexture(nil, 'BORDER')
    frame.horizBottomBorder = frame.healthBar:CreateTexture(nil, 'BORDER')
    frame.vertLeftBorder = frame.healthBar:CreateTexture(nil, 'BORDER')
    frame.vertRightBorder = frame.healthBar:CreateTexture(nil, 'BORDER')
    frame.horizDivider = frame.healthBar:CreateTexture(nil, 'BORDER')

    self.HealthBar = frame.healthBar
    self.ManaBar = frame.powerBar
    self.FontName = frame.name
    self.RoleIcon = frame.roleIcon
end

function DragonflightUIEditModePreviewRaidMixin:UpdateState(state)
    --     [05:21:29] Dump: value=GetRaidProfileFlattenedOptions(GetActiveRaidProfile())
    -- [05:21:29] [1]={
    -- [05:21:29]   autoActivate2Players=false,
    -- [05:21:29]   horizontalGroups=false,
    -- [05:21:29]   shown=true,
    -- [05:21:29]   healthText="health",
    -- [05:21:29]   displayNonBossDebuffs=true,
    -- [05:21:29]   autoActivatePvE=false,
    -- [05:21:29]   autoActivate3Players=false,
    -- [05:21:29]   locked=true,
    -- [05:21:29]   keepGroupsTogether=false,
    -- [05:21:29]   displayBorder=false,
    -- [05:21:29]   frameHeight=50,
    -- [05:21:29]   autoActivatePvP=false,
    -- [05:21:29]   autoActivate40Players=false,
    -- [05:21:29]   displayPowerBar=true,
    -- [05:21:29]   displayOnlyDispellableDebuffs=false,
    -- [05:21:29]   autoActivate20Players=false,
    -- [05:21:29]   autoActivate15Players=false,
    -- [05:21:29]   autoActivate5Players=false,
    -- [05:21:29]   autoActivate10Players=false,
    -- [05:21:29]   displayMainTankAndAssist=false,
    -- [05:21:29]   useClassColors=true,
    -- [05:21:29]   sortBy="group",
    -- [05:21:29]   displayPets=true,
    -- [05:21:29]   frameWidth=120
    -- [05:21:29] }
    local frame = self;
    local componentScale = min(state.frameHeight / NATIVE_UNIT_FRAME_HEIGHT, state.frameWidth / NATIVE_UNIT_FRAME_WIDTH);

    if self.GroupHeader then
        if state.keepGroupsTogether then
            self.GroupHeader:Show()

            if state.horizontalGroups then
                self.GroupHeader:ClearAllPoints()
                self.GroupHeader:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT', 0, 0)
            else
                self.GroupHeader:ClearAllPoints()
                self.GroupHeader:SetPoint('BOTTOM', frame, 'TOP', 0, 0)
            end
        else
            self.GroupHeader:Hide()
        end
    end

    self:SetSize(state.frameWidth, state.frameHeight)

    if state.useClassColors then
        self.HealthBar:SetClass(self.Unit.class)
    else
        self.HealthBar:SetClass('')
    end

    local powerBarHeight = 8;
    local powerBarUsedHeight = state.displayPowerBar and powerBarHeight or 0;
    frame.healthBar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1 + powerBarUsedHeight);

    if (frame.powerBar) then
        if (state.displayPowerBar) then
            if (state.displayBorder) then
                frame.powerBar:SetPoint("TOPLEFT", frame.healthBar, "BOTTOMLEFT", 0, -2);
            else
                frame.powerBar:SetPoint("TOPLEFT", frame.healthBar, "BOTTOMLEFT", 0, 0);
            end
            frame.powerBar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1);
            -- frame.powerBar:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Resource-Fill", "BORDER");
            -- frame.powerBar.background:SetTexture("Interface\\RaidFrame\\Raid-Bar-Resource-Background");
            frame.powerBar:Show();
        else
            frame.powerBar:Hide();
        end
    end

    local NATIVE_FONT_SIZE = 12;
    local fontName, fontSize, fontFlags = frame.statusText:GetFont();
    frame.statusText:SetFont(fontName, NATIVE_FONT_SIZE * componentScale, fontFlags);
    frame.statusText:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 3, state.frameHeight / 3 - 2);
    frame.statusText:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, state.frameHeight / 3 - 2);
    frame.statusText:SetHeight(12 * componentScale);

    if (state.displayBorder) then
        frame.horizTopBorder:ClearAllPoints();
        frame.horizTopBorder:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, -7);
        frame.horizTopBorder:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, -7);
        frame.horizTopBorder:SetTexture("Interface\\RaidFrame\\Raid-HSeparator");
        frame.horizTopBorder:SetHeight(8);
        frame.horizTopBorder:Show();

        frame.horizBottomBorder:ClearAllPoints();
        frame.horizBottomBorder:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, 1);
        frame.horizBottomBorder:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 0, 1);
        frame.horizBottomBorder:SetTexture("Interface\\RaidFrame\\Raid-HSeparator");
        frame.horizBottomBorder:SetHeight(8);
        frame.horizBottomBorder:Show();

        frame.vertLeftBorder:ClearAllPoints();
        frame.vertLeftBorder:SetPoint("TOPRIGHT", frame, "TOPLEFT", 7, 0);
        frame.vertLeftBorder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", 7, 0);
        frame.vertLeftBorder:SetTexture("Interface\\RaidFrame\\Raid-VSeparator");
        frame.vertLeftBorder:SetWidth(8);
        frame.vertLeftBorder:Show();

        frame.vertRightBorder:ClearAllPoints();
        frame.vertRightBorder:SetPoint("TOPLEFT", frame, "TOPRIGHT", -1, 0);
        frame.vertRightBorder:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", -1, 0);
        frame.vertRightBorder:SetTexture("Interface\\RaidFrame\\Raid-VSeparator");
        frame.vertRightBorder:SetWidth(8);
        frame.vertRightBorder:Show();

        if (state.displayPowerBar) then
            frame.horizDivider:ClearAllPoints();
            frame.horizDivider:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, 1 + powerBarUsedHeight);
            frame.horizDivider:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 0, 1 + powerBarUsedHeight);
            frame.horizDivider:SetTexture("Interface\\RaidFrame\\Raid-HSeparator");
            frame.horizDivider:SetHeight(8);
            frame.horizDivider:Show();
        else
            frame.horizDivider:Hide();
        end
    else
        frame.horizTopBorder:Hide();
        frame.horizBottomBorder:Hide();
        frame.vertLeftBorder:Hide();
        frame.vertRightBorder:Hide();

        frame.horizDivider:Hide();
    end
end

DragonflightUIEditModePreviewAltPowerBarMixin = {}

function DragonflightUIEditModePreviewAltPowerBarMixin:OnLoad()
    -- print('~~~~~~~~~~~~DragonflightUIEditModePreviewRaidMixin:OnLoad()')

    -- local sizeX, sizeY = _G['PartyMemberFrame' .. 1]:GetSize()
    -- self:SetSize(sizeX, sizeY)
    -- self:SetupFrame()
    -- self:SetRandomUnit()
end
