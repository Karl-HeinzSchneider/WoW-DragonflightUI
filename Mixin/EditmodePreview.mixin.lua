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

    self.NameBackground:SetShown(not state.hideNameBackground)

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

------- party frame
DragonflightUIEditModePreviewPartyFrameMixin = {}
function DragonflightUIEditModePreviewPartyFrameMixin:OnLoad()
    -- print('~~ DragonflightUIEditModePreviewPartyFrameMixin:OnLoad()')

    local sizeX, sizeY = _G['PartyMemberFrame' .. 1]:GetSize()
    local gap = 10;
    self:SetSize(sizeX, sizeY * 4 + 3 * gap)

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

    -- local m = CreateFrame("PlayerModel", nil, UIParent)
    -- m:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    -- m:SetSize(256, 256)
    -- -- m:SetDisplayInfo(21723) -- creature/murloccostume/murloccostume.m2

    -- C_Timer.After(1.5, function()

    --     print('.........')
    --     m:SetUnit('player')
    --     -- MODELFRAME_DEFAULT_ROTATION 0.61
    --     -- m:SetRotation(0.61)
    --     m:SetRotation(0)
    --     m:SetPortraitZoom(1)
    --     m:SetAnimation(804)
    --     -- myModel:FreezeAnimation(60, 0, 55) -- Freeze the talking animation at the frame 55
    --     m:FreezeAnimation(804, 0, 0) -- Freeze the talking animation at the frame 55
    --     -- m:StopAnimKit()  
    -- end)
end

function DragonflightUIEditModePreviewPartyFrameMixin:UpdateState(state)
    self:ClearAllPoints()
    local parent = _G[state.anchorFrame]
    self:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    self:SetScale(state.scale)

    for k, v in ipairs(self.PartyFrames) do
        --
        v:UpdateState(state)
    end

    self:SetScript('OnEvent', self.OnEvent)
    self:RegisterEvent('GROUP_ROSTER_UPDATE')
end

function DragonflightUIEditModePreviewPartyFrameMixin:UpdateVisibility()
    for k, v in ipairs(self.PartyFrames) do
        --
        if UnitExists('party' .. k) then
            v:Hide()
        else
            v:Show()
        end
    end
end

function DragonflightUIEditModePreviewPartyFrameMixin:OnEvent(event, arg1)

    if event == 'GROUP_ROSTER_UPDATE' then
        --
        -- print('GROUP_ROSTER_UPDATE')
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

    local textureFrame = CreateFrame('Frame', 'DragonflightUIBossFrameTextureFrame', self)
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

    local portrait = self:CreateTexture('DragonflightUITargetFramePortrait')
    portrait:SetDrawLayer('ARTWORK', 1)
    portrait:SetSize(37, 37)
    portrait:SetPoint('TOPLEFT', self, 'TOPLEFT', 7, -6)
    self.TargetFramePortrait = portrait
    function portrait:UpdatePortrait(id)
        if not id then return end
        -- SetPortraitTexture(self.TargetFramePortrait, unit)   
        SetPortraitTextureFromCreatureDisplayID(portrait, tonumber(id) or 0);
    end

    -- local extra = self.TextureFrame:CreateTexture('DragonflightUITargetFramePortraitExtra')
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
