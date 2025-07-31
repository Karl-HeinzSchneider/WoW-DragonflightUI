local addonName, addonTable = ...;
---@diagnostic disable: undefined-global
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

local mName = 'Unitframe'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

Module.SubAltPower = DF:CreateFrameFromMixinAndInit(addonTable.SubModuleMixins['AltPower'])
Module.SubFocus = DF:CreateFrameFromMixinAndInit(addonTable.SubModuleMixins['Focus'])
Module.SubFocusTarget = DF:CreateFrameFromMixinAndInit(addonTable.SubModuleMixins['FocusTarget'])
Module.SubParty = DF:CreateFrameFromMixinAndInit(addonTable.SubModuleMixins['Party'])
Module.SubPet = DF:CreateFrameFromMixinAndInit(addonTable.SubModuleMixins['PetFrame'])
Module.SubPlayer = DF:CreateFrameFromMixinAndInit(addonTable.SubModuleMixins['PlayerFrame'])
Module.SubRaid = DF:CreateFrameFromMixinAndInit(addonTable.SubModuleMixins['RaidFrame'])
Module.SubTarget = DF:CreateFrameFromMixinAndInit(addonTable.SubModuleMixins['Target'])
Module.SubTargetOfTarget = DF:CreateFrameFromMixinAndInit(addonTable.SubModuleMixins['TargetOfTarget'])

-- local db, getOptions

Module.famous = {['Norbert'] = true}

local defaults = {
    profile = {
        altpower = Module.SubAltPower.Defaults,
        focus = Module.SubFocus.Defaults,
        focusTarget = Module.SubFocusTarget.Defaults,
        party = Module.SubParty.Defaults,
        pet = Module.SubPet.Defaults,
        player = Module.SubPlayer.Defaults,
        raid = Module.SubRaid.Defaults,
        target = Module.SubTarget.Defaults,
        tot = Module.SubTargetOfTarget.Defaults
    }
}
Module:SetDefaults(defaults)

local localSettings = {
    scale = 1,
    focus = {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = 250, y = -170},
    player = {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4},
    target = {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = 250, y = -4},
    pet = {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = 100, y = -70}
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)
    -- db = self.db.profile
    hooksecurefunc(DF:GetModule('Config'), 'AddConfigFrame', function()
        Module:RegisterSettings()
    end)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    self:EnableAddonSpecific()

    Module:ApplySettings()
    Module:SaveLocalSettings()

    hooksecurefunc('UIParent_UpdateTopFramePositions', function()
        Module:SaveLocalSettings()
    end)

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)      
        Module:ApplySettings()
        Module:RefreshOptionScreens()
    end)

    Module:FixBlizzardBug()
end

function Module:OnDisable()
end

function Module:RegisterSettings()
    local moduleName = 'Unitframe'
    local cat = 'unitframes'
    local function register(name, data)
        data.module = moduleName;
        DF.ConfigModule:RegisterSettingsElement(name, cat, data, true)
    end

    register('party', {order = 0, name = self.SubParty.Options.name, descr = 'Partyss', isNew = false})
    register('pet', {order = 0, name = self.SubPet.Options.name, descr = 'Petss', isNew = false})
    register('player', {order = 0, name = self.SubPlayer.Options.name, descr = 'players', isNew = false})
    register('raid', {order = 0, name = self.SubRaid.Options.name, descr = 'Raidss', isNew = false})
    register('target', {order = 0, name = self.SubTarget.Options.name, descr = 'Targetss', isNew = true})
    register('targetoftarget',
             {order = 0, name = self.SubTargetOfTarget.Options.name, descr = 'Targetss', isNew = false})

    if DF.Wrath then
        register('focus', {order = 0, name = self.SubFocus.Options.name, descr = 'Focusss', isNew = false})
        register('focusTarget', {order = 0, name = self.SubFocusTarget.Options.name, descr = 'Focusss', isNew = false})
    end
    if DF.Cata then
        register('altpower', {order = 0, name = self.SubAltPower.Options.name, descr = 'Focusss', isNew = false})
    end
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame

    local refreshCat = function(name)
        configFrame:RefreshCatSub('Unitframes', name)
    end

    refreshCat('Party')
    refreshCat('Pet')
    refreshCat('Player')
    refreshCat('Raid')
    refreshCat('Target')
    refreshCat('TargetOfTarget')

    if DF.Wrath then
        refreshCat('Focus')
        refreshCat('focusTarget')

        self.SubFocus.PreviewFocus.DFEditModeSelection:RefreshOptionScreen();
        self.SubFocusTarget.PreviewFocusTarget.DFEditModeSelection:RefreshOptionScreen();
    end
    self.SubParty.PreviewParty.DFEditModeSelection:RefreshOptionScreen();
    PlayerFrame.DFEditModeSelection:RefreshOptionScreen();
    PetFrame.DFEditModeSelection:RefreshOptionScreen();
    -- self.SubRaid.PreviewRaid.DFEditModeSelection:RefreshOptionScreen();
    self.SubTarget.PreviewTarget.DFEditModeSelection:RefreshOptionScreen();
    self.SubTargetOfTarget.PreviewTargetOfTarget.DFEditModeSelection:RefreshOptionScreen();
    if DF.Cata then self.SubAltPower.PowerBarAltPreview.DFEditModeSelection:RefreshOptionScreen(); end
end

function Module:SaveLocalSettings()
    -- playerframe
    do
        local scale = PlayerFrame:GetScale()
        local point, relativeTo, relativePoint, xOfs, yOfs = PlayerFrame:GetPoint(1)
        -- print('PlayerFrame', point, relativePoint, xOfs, yOfs)

        local obj = localSettings.player
        obj.scale = scale
        obj.anchor = point
        obj.anchorParent = relativePoint
        obj.x = xOfs
        obj.y = yOfs
    end
    -- targetframe
    do
        local scale = TargetFrame:GetScale()
        local point, relativeTo, relativePoint, xOfs, yOfs = TargetFrame:GetPoint(1)
        -- print('TargetFrame', point, relativePoint, xOfs, yOfs)

        local obj = localSettings.target
        obj.scale = scale
        obj.anchor = point
        obj.anchorParent = relativePoint
        obj.x = xOfs
        obj.y = yOfs
    end
    --[[    -- petframe
    do
        local scale = PetFrame:GetScale()
        local point, relativeTo, relativePoint, xOfs, yOfs = PetFrame:GetPoint(1)
        -- print('TargetFrame', point, relativePoint, xOfs, yOfs)

        local obj = localSettings.pet
        obj.scale = scale
        obj.anchor = point
        obj.anchorParent = relativePoint
        obj.x = xOfs
        obj.y = yOfs
    end ]]
    -- focusframe
    if DF.Wrath then
        do
            local scale = FocusFrame:GetScale()
            local point, relativeTo, relativePoint, xOfs, yOfs = FocusFrame:GetPoint(1)
            -- print('FocusFrame', point, relativePoint, xOfs, yOfs)

            local obj = localSettings.focus
            obj.scale = scale
            obj.anchor = point
            obj.anchorParent = relativePoint
            obj.x = xOfs
            obj.y = yOfs
        end
    end

    -- DevTools_Dump({localSettings})
end

function Module:ApplySettings(sub)
    local db = Module.db.profile

    self.SubParty:UpdateState(db.party)
    self.SubPlayer:UpdateState(db.player)
    self.SubPet:UpdateState(db.pet)
    self.SubTarget:UpdateState(db.target)
    self.SubTargetOfTarget:UpdateState(db.tot)
    self.SubRaid:UpdateState(db.raid)

    if DF.Wrath then
        self.SubFocus:UpdateState(db.focus)
        self.SubFocusTarget:UpdateState(db.focusTarget)
    end
    if DF.Cata then self.SubAltPower:UpdateState(db.altpower) end
end

function Module:FixBlizzardBug()
    SetTextStatusBarText(PlayerFrameManaBar, PlayerFrameManaBarText)
    SetTextStatusBarText(PlayerFrameHealthBar, PlayerFrameHealthBarText)
    TextStatusBar_UpdateTextString(PlayerFrameHealthBar)
    TextStatusBar_UpdateTextString(PlayerFrameManaBar)
end

function Module:HookDrag()
    local DragStopPlayerFrame = function(_)
        self:SaveLocalSettings()

        for k, v in pairs(localSettings.player) do self.db.profile.player[k] = v end
        self.db.profile.player.anchorFrame = 'UIParent'
        self:RefreshOptionScreens()
    end
    PlayerFrame:HookScript('OnDragStop', DragStopPlayerFrame)
    hooksecurefunc('PlayerFrame_ResetUserPlacedPosition', DragStopPlayerFrame)

    local DragStopTargetFrame = function(_)
        self:SaveLocalSettings()

        for k, v in pairs(localSettings.target) do self.db.profile.target[k] = v end
        self.db.profile.target.anchorFrame = 'UIParent'
        self:RefreshOptionScreens()
    end
    TargetFrame:HookScript('OnDragStop', DragStopTargetFrame)
    hooksecurefunc('TargetFrame_ResetUserPlacedPosition', DragStopTargetFrame)

    if DF.Wrath then
        local DragStopFocusFrame = function(_)
            self:SaveLocalSettings()

            for k, v in pairs(localSettings.focus) do self.db.profile.focus[k] = v end
            self.db.profile.focus.anchorFrame = 'UIParent'
            self:RefreshOptionScreens()
        end
        FocusFrame:HookScript('OnDragStop', DragStopFocusFrame)
        -- hooksecurefunc('FocusFrame_ResetUserPlacedPosition', DragStopFocusFrame)
    end
end

function Module:HookClassIcon()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

    self:Unhook('UnitFramePortrait_Update')
    self:SecureHook('UnitFramePortrait_Update', function(portraitFrame)
        -- print('UnitFramePortrait_Update', portraitFrame:GetName(), portraitFrame.unit)
        if not portraitFrame.portrait then return end

        local icon = nil;
        local unit = portraitFrame.unit;
        local disableMasking = false;

        if unit == "player" then
            icon = self.db.profile.player.classicon
            disableMasking = true
        elseif unit == "target" then
            icon = self.db.profile.target.classicon
            disableMasking = true
        elseif unit == "focus" then
            icon = self.db.profile.focus.classicon
            disableMasking = true
        elseif unit == "targettarget" then
            icon = self.db.profile.tot.classicon
            disableMasking = true
        elseif unit == "focustarget" then
            icon = self.db.profile.focusTarget.classicon
            disableMasking = true
        end

        if (not icon) or unit == "pet" or (not UnitIsPlayer(unit)) then
            portraitFrame.portrait:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
            SetPortraitTexture(portraitFrame.portrait, unit, disableMasking)
            -- if portraitFrame.portrait.fixClassSize then portraitFrame.portrait:fixClassSize(false) end
            return
        end

        -- improved icons
        local class = select(2, UnitClass(unit));
        if class then
            if class == 'MONK' then
                local tex = base .. 'classicon-monk';
                portraitFrame.portrait:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1);
                portraitFrame.portrait:SetTexture(tex);
                return;
            else
                local classIconAtlas = GetClassAtlas(class);
                if (classIconAtlas) then
                    portraitFrame.portrait:SetAtlas(classIconAtlas);
                    return;
                end
            end
        end

        -- local texCoords = CLASS_ICON_TCOORDS[select(2, UnitClass(unit))]
        -- texCoords = CLASS_ICON_TCOORDS['WARRIOR']

        -- if texCoords then
        --     portraitFrame.portrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
        --     portraitFrame.portrait:SetTexCoord(unpack(texCoords))
        --     if portraitFrame.portrait.fixClassSize then portraitFrame.portrait:fixClassSize(true) end
        -- end
    end)
end

function Module:AddPortraitMasks()
    local playerMaskTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframeplayerportraitmask'
    local circularMaskTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\tempportraitalphamask'

    local mask = PlayerFrame:CreateMaskTexture()
    mask:SetPoint('CENTER', PlayerPortrait, 'CENTER', 1, 0)
    mask:SetTexture(playerMaskTexture, 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
    PlayerPortrait:AddMaskTexture(mask)

    local maskTarget = TargetFrame:CreateMaskTexture()
    maskTarget:SetAllPoints(TargetFramePortrait)
    maskTarget:SetTexture(circularMaskTexture, 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
    TargetFramePortrait:AddMaskTexture(maskTarget)

    local maskToT = TargetFrameToT:CreateMaskTexture()
    maskToT:SetAllPoints(TargetFrameToTPortrait)
    maskToT:SetTexture(circularMaskTexture, 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
    TargetFrameToTPortrait:AddMaskTexture(maskToT)

    local maskPet = PetFrame:CreateMaskTexture()
    maskPet:SetAllPoints(PetPortrait)
    maskPet:SetTexture(circularMaskTexture, 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
    PetPortrait:AddMaskTexture(maskPet)

    if DF.Wrath then
        local maskFocus = FocusFrame:CreateMaskTexture()
        maskFocus:SetAllPoints(FocusFramePortrait)
        maskFocus:SetTexture(circularMaskTexture, 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
        FocusFramePortrait:AddMaskTexture(maskFocus)

        local maskFocusToT = FocusFrameToT:CreateMaskTexture()
        maskFocusToT:SetAllPoints(FocusFrameToTPortrait)
        maskFocusToT:SetTexture(circularMaskTexture, 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
        FocusFrameToTPortrait:AddMaskTexture(maskFocusToT)
    end

    for i = 1, 4 do
        local pf = _G['PartyMemberFrame' .. i]
        local port = _G['PartyMemberFrame' .. i .. 'Portrait']

        local m = pf:CreateMaskTexture()
        m:SetAllPoints(port)
        m:SetTexture(circularMaskTexture, 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
        port:AddMaskTexture(m)
    end

    -- fix portraits
    local maskCharacterFrame = CharacterFrame:CreateMaskTexture()
    maskCharacterFrame:SetAllPoints(CharacterFramePortrait)
    maskCharacterFrame:SetTexture(circularMaskTexture, 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
    CharacterFramePortrait:AddMaskTexture(maskCharacterFrame)

    local maskTalentFrame = PlayerTalentFrame:CreateMaskTexture()
    maskTalentFrame:SetAllPoints(PlayerTalentFramePortrait)
    maskTalentFrame:SetTexture(circularMaskTexture, 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
    PlayerTalentFramePortrait:AddMaskTexture(maskTalentFrame)
end

function Module:HookEnergyBar()
    hooksecurefunc("UnitFrameManaBar_UpdateType", function(manaBar)
        if manaBar.DFUpdateFunc and type(manaBar.DFUpdateFunc) == 'function' then
            --
            -- print('~UnitFrameManaBar_UpdateType:', manaBar:GetName())
            manaBar.DFUpdateFunc()
        end
    end)
end

function Module:ChangeFonts()
    local newFont = 'Fonts\\FRIZQT__.ttf'

    local locale = GetLocale()
    if locale == "ruRU" then
        newFont = "Fonts\\FRIZQT___CYR.TTF"
    elseif locale == "koKR" then
        newFont = "Fonts\\2002.TTF"
    elseif locale == "zhCN" then
        newFont = "Fonts\\ARKai_T.TTF"
    elseif locale == "zhTW" then
        newFont = "Fonts\\blei00d.TTF"
    end

    local changeFont = function(f, newsize)
        if not f then return end
        local path, size, flags = f:GetFont()
        f:SetFont(newFont, newsize, flags)
    end

    local std = 11

    changeFont(PlayerFrameHealthBarText, std)
    changeFont(PlayerFrameHealthBarTextLeft, std)
    changeFont(PlayerFrameHealthBarTextRight, std)

    changeFont(PlayerFrameManaBarText, std)
    changeFont(PlayerFrameManaBarTextLeft, std)
    changeFont(PlayerFrameManaBarTextRight, std)

    changeFont(PetFrameHealthBarText, std)
    changeFont(PetFrameHealthBarTextLeft, std)
    changeFont(PetFrameHealthBarTextRight, std)

    changeFont(PetFrameManaBarText, std)
    changeFont(PetFrameManaBarTextLeft, std)
    changeFont(PetFrameManaBarTextRight, std)

    changeFont(TargetFrameTextureFrame.HealthBarText, std)
    changeFont(TargetFrameTextureFrame.HealthBarTextLeft, std)
    changeFont(TargetFrameTextureFrame.HealthBarTextRight, std)

    changeFont(TargetFrameTextureFrame.ManaBarText, std)
    changeFont(TargetFrameTextureFrame.ManaBarTextLeft, std)
    changeFont(TargetFrameTextureFrame.ManaBarTextRight, std)

    for i = 1, 4 do
        local healthbar = _G['PartyMemberFrame' .. i .. 'HealthBar']
        changeFont(healthbar.DFHealthBarText, std)
        changeFont(healthbar.DFHealthBarTextLeft, std)
        changeFont(healthbar.DFHealthBarTextRight, std)

        local manabar = _G['PartyMemberFrame' .. i .. 'ManaBar']
        changeFont(manabar.DFManaBarText, std)
        changeFont(manabar.DFManaBarTextLeft, std)
        changeFont(manabar.DFManaBarTextRight, std)
    end

    if DF.Wrath then
        changeFont(FocusFrameTextureFrame.HealthBarText, std)
        changeFont(FocusFrameTextureFrame.HealthBarTextLeft, std)
        changeFont(FocusFrameTextureFrame.HealthBarTextRight, std)

        changeFont(FocusFrameTextureFrame.ManaBarText, std)
        changeFont(FocusFrameTextureFrame.ManaBarTextLeft, std)
        changeFont(FocusFrameTextureFrame.ManaBarTextRight, std)
    end
end

function Module:TakePicture()
    if not Module.PictureTakerFrame then
        local pt = CreateFrame('FRAME', 'DragonflightUIPictureTakerFrame', UIParent);
        local size = 256
        local border = 0;
        pt:SetSize(size + 2 * border, size + 2 * border);
        pt:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)

        local tex = pt:CreateTexture(nil, 'BACKGROUND');
        tex:SetColorTexture(0, 0, 0, 1)
        tex:SetPoint('TOPLEFT')
        tex:SetPoint('BOTTOMRIGHT')

        local port = pt:CreateTexture(nil, 'OVERLAY')
        port:SetPoint('TOPLEFT', tex, 'TOPLEFT', border, -border)
        port:SetPoint('BOTTOMRIGHT', tex, 'BOTTOMRIGHT', -border, border)
        pt.Portrait = port;

        pt:Hide()
        Module.PictureTakerFrame = pt;

        function Module.PictureTakerFrame:Update()
            -- print('update....')
            SetPortraitTexture(pt.Portrait, 'target')
        end
    end

    if Module.PictureTakerFrame:IsVisible() then
        Module.PictureTakerFrame:Hide()
    else
        print('cheeese ', GetUnitName('target'))
        Module.PictureTakerFrame:Show()
        Module.PictureTakerFrame:Update()
    end
end
Module:RegisterChatCommand('cheeese', 'TakePicture')

function Module:Era()
    -- self.SubFocus:Setup()
    -- self.SubFocusTarget:Setup()
    -- self.SubAltPower:Setup()

    self.SubParty:Setup()
    self.SubPlayer:Setup()

    self.SubPet:Setup()
    self.SubTarget:Setup()
    self.SubTargetOfTarget:Setup()
    self.SubRaid:Setup()

    self:HookEnergyBar()
    self:ChangeFonts()
    self:HookDrag()
    self:AddPortraitMasks()
    self:HookClassIcon()
end

function Module:TBC()
end

function Module:Wrath()
    self.SubFocus:Setup()
    self.SubFocusTarget:Setup()

    -- self.SubAltPower:Setup()
    self.SubParty:Setup()
    self.SubPlayer:Setup()

    self.SubPet:Setup()
    self.SubTarget:Setup()
    self.SubTargetOfTarget:Setup()
    self.SubRaid:Setup()

    self:HookEnergyBar()
    self:ChangeFonts()
    self:HookDrag()
    self:AddPortraitMasks()
    self:HookClassIcon()
end

function Module:Cata()
    self.SubFocus:Setup()
    self.SubFocusTarget:Setup()

    self.SubAltPower:Setup()
    self.SubParty:Setup()
    self.SubPlayer:Setup()

    self.SubPet:Setup()
    self.SubTarget:Setup()
    self.SubTargetOfTarget:Setup()
    self.SubRaid:Setup()

    self:HookEnergyBar()
    self:ChangeFonts()
    self:HookDrag()
    self:AddPortraitMasks()
    self:HookClassIcon()
end

function Module:Mists()
    self.SubFocus:Setup()
    self.SubFocusTarget:Setup()

    self.SubAltPower:Setup()
    self.SubParty:Setup()
    self.SubPlayer:Setup()

    self.SubPet:Setup()
    self.SubTarget:Setup()
    self.SubTargetOfTarget:Setup()
    self.SubRaid:Setup()

    self:HookEnergyBar()
    self:ChangeFonts()
    self:HookDrag()
    self:AddPortraitMasks()
    self:HookClassIcon()
end
