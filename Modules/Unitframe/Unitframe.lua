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

local function getDefaultStr(key, sub)
    return Module:GetDefaultStr(key, sub)
end

local function setDefaultValues()
    Module:SetDefaultValues()
end

local function setDefaultSubValues(sub)
    Module:SetDefaultSubValues(sub)
end

local function getOption(info)
    return Module:GetOption(info)
end

local function setOption(info, value)
    Module:SetOption(info, value)
end

local frameTable = {
    {value = 'UIParent', text = 'UIParent', tooltip = 'descr', label = 'label'},
    {value = 'PlayerFrame', text = 'PlayerFrame', tooltip = 'descr', label = 'label'},
    {value = 'TargetFrame', text = 'TargetFrame', tooltip = 'descr', label = 'label'},
    {value = 'CompactRaidFrameManager', text = 'CompactRaidFrameManager', tooltip = 'descr', label = 'label'}
}

if DF.Wrath then
    table.insert(frameTable, {value = 'FocusFrame', text = 'FocusFrame', tooltip = 'descr', label = 'label'})
end

local function frameTableWithout(without)
    local newTable = {}

    for k, v in ipairs(frameTable) do
        --
        if v.value ~= without then
            --      
            table.insert(newTable, v);
        end
    end

    return newTable
end

local presetDesc =
    'Sets Scale, Anchor, AnchorParent, AnchorFrame, X and Y to that of the chosen preset, but does not change any other setting.';

local function setPreset(T, preset, sub)
    for k, v in pairs(preset) do
        --
        T[k] = v;
    end
    Module:ApplySettings(sub)
    Module:RefreshOptionScreens()
end

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

    if true then return end

    Module:AddEditMode()

    Module:SaveLocalSettings()

    hooksecurefunc('UIParent_UpdateTopFramePositions', function()
        Module:SaveLocalSettings()
    end)
    Module:RegisterOptionScreens()

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)      
        Module:ApplySettings()
        Module:RefreshOptionScreens()
    end)

    Module.FixBlizzardBug()
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

function Module:RegisterOptionScreens()

    DF.ConfigModule:RegisterSettingsData('raid', 'unitframes', {
        options = optionsRaid
        -- default = function()
        --     setDefaultSubValues('party')
        -- end
    })
end

function Module:RefreshOptionScreens()
    print('Module:RefreshOptionScreens()')

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
    local orig = defaults.profile

    self.SubFocus:UpdateState(db.focus)
    self.SubFocusTarget:UpdateState(db.focusTarget)

    self.SubAltPower:UpdateState(db.altpower)
    self.SubParty:UpdateState(db.party)
    self.SubPlayer:UpdateState(db.player)
    self.SubPet:UpdateState(db.pet)
    self.SubTarget:UpdateState(db.target)
    self.SubTargetOfTarget:UpdateState(db.tot)
end

local frame = CreateFrame('FRAME', 'DragonflightUIUnitframeFrame', UIParent)
Module.Frame = frame

function Module.FixBlizzardBug()
    SetTextStatusBarText(PlayerFrameManaBar, PlayerFrameManaBarText)
    SetTextStatusBarText(PlayerFrameHealthBar, PlayerFrameHealthBarText)
    TextStatusBar_UpdateTextString(PlayerFrameHealthBar)
    TextStatusBar_UpdateTextString(PlayerFrameManaBar)
end

function Module:AddEditMode()

    -- raid frame 
    if true then
        local initRaid = function()
            --         
            local f = _G['CompactRaidFrameManagerContainerResizeFrame']
            _G['CompactRaidFrameManagerContainerResizeFrameResizer']:SetFrameLevel(15)

            local fakeRaid = CreateFrame('Frame', 'DragonflightUIEditModeRaidFramePreview', f,
                                         'DFEditModePreviewRaidFrameTemplate')
            fakeRaid:OnLoad()
            fakeRaid:SetPoint('TOPLEFT', f, 'TOPLEFT', 4, -7)
            fakeRaid:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 0, 0)

            -- fakeRaid:ClearAllPoints()
            -- fakeRaid:SetPoint('TOPLEFT', UIParent, 'CENTER', -50, 50)
            -- fakeRaid:SetParent(UIParent)

            fakeRaid:Show()

            Module.PreviewRaid = fakeRaid;

            EditModeModule:AddEditModeToFrame(f)

            f.DFEditModeSelection:SetGetLabelTextFunction(function()
                return optionsRaid.name
            end)

            f.DFEditModeSelection:ClearAllPoints()
            f.DFEditModeSelection:SetPoint('TOPLEFT', f, 'TOPLEFT', 0, -7)
            f.DFEditModeSelection:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 0, 11)

            f.DFEditModeSelection:RegisterOptions({
                options = optionsRaid,
                extra = optionsRaidEditmode,
                -- parentExtra = FocusFrame,
                default = function()
                    -- setDefaultSubValues('focus')
                end,
                moduleRef = self,
                showFunction = function()
                    --  
                    f:Show()
                    CompactRaidFrameManager_SetSetting('Locked', false)
                    f:Show()
                end,
                hideFunction = function()
                    --      
                    CompactRaidFrameManager_SetSetting('Locked', true)
                    CompactRaidFrameManager_ResizeFrame_SavePosition(CompactRaidFrameManager)
                end
            });

            fakeRaid:UpdateState(nil)

            local editModule = DF:GetModule('Editmode')

            hooksecurefunc('CompactRaidFrameManager_UpdateContainerVisibility', function()
                -- print('CompactRaidFrameManager_UpdateContainerVisibility')
                if editModule.IsEditMode then
                    --             
                    -- CompactRaidFrameManager_SetSetting('Locked', false)
                    C_Timer.After(0, function()
                        --
                        CompactRaidFrameManager_SetSetting('Locked', false)
                    end)
                end
            end)

            f.DFEditModeSelection:HookScript('OnDragStop', function()
                --
                CompactRaidFrameManager_ResizeFrame_SavePosition(CompactRaidFrameManager)
            end)
        end

        if HasLoadedCUFProfiles() and CompactUnitFrameProfiles and CompactUnitFrameProfiles.variablesLoaded then
            initRaid()
        else
            local waitFrame = CreateFrame('Frame')
            waitFrame:RegisterEvent("COMPACT_UNIT_FRAME_PROFILES_LOADED")
            waitFrame:RegisterEvent("VARIABLES_LOADED")
            waitFrame:SetScript("OnEvent", function(waitFrame, event, arg1)
                --
                -- print(event)
                waitFrame:UnregisterEvent(event);
                if (HasLoadedCUFProfiles() and CompactUnitFrameProfiles and CompactUnitFrameProfiles.variablesLoaded) then
                    --
                    initRaid()
                end
            end)
        end
    end

end

function Module.GetCoords(key)
    local uiunitframe = {
        ['UI-HUD-UnitFrame-Player-Absorb-Edge'] = {8, 32, 0.984375, 0.9921875, 0.001953125, 0.064453125, false, false},
        ['UI-HUD-UnitFrame-Player-CombatIcon'] = {
            16, 16, 0.9775390625, 0.9931640625, 0.259765625, 0.291015625, false, false
        },
        ['UI-HUD-UnitFrame-Player-CombatIcon-Glow'] = {
            32, 32, 0.1494140625, 0.1806640625, 0.8203125, 0.8828125, false, false
        },
        ['UI-HUD-UnitFrame-Player-Group-FriendOnlineIcon'] = {
            16, 16, 0.162109375, 0.177734375, 0.716796875, 0.748046875, false, false
        },
        ['UI-HUD-UnitFrame-Player-Group-GuideIcon'] = {
            16, 16, 0.162109375, 0.177734375, 0.751953125, 0.783203125, false, false
        },
        ['UI-HUD-UnitFrame-Player-Group-LeaderIcon'] = {
            16, 16, 0.1259765625, 0.1416015625, 0.919921875, 0.951171875, false, false
        },
        ['UI-HUD-UnitFrame-Player-GroupIndicator'] = {
            71, 13, 0.927734375, 0.9970703125, 0.3125, 0.337890625, false, false
        },
        ['UI-HUD-UnitFrame-Player-PlayTimeTired'] = {29, 29, 0.1904296875, 0.21875, 0.505859375, 0.5625, false, false},
        ['UI-HUD-UnitFrame-Player-PlayTimeUnhealthy'] = {
            29, 29, 0.1904296875, 0.21875, 0.56640625, 0.623046875, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff'] = {
            133, 51, 0.0009765625, 0.130859375, 0.716796875, 0.81640625, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-Energy'] = {
            124, 10, 0.6708984375, 0.7919921875, 0.35546875, 0.375, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-Focus'] = {
            124, 10, 0.6708984375, 0.7919921875, 0.37890625, 0.3984375, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-Health'] = {
            126, 23, 0.0009765625, 0.1240234375, 0.919921875, 0.96484375, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-Health-Status'] = {
            124, 20, 0.5478515625, 0.6689453125, 0.3125, 0.3515625, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-Mana'] = {
            126, 12, 0.0009765625, 0.1240234375, 0.96875, 0.9921875, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-Rage'] = {
            124, 10, 0.8203125, 0.94140625, 0.435546875, 0.455078125, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-RunicPower'] = {
            124, 10, 0.1904296875, 0.3115234375, 0.458984375, 0.478515625, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn'] = {198, 71, 0.7890625, 0.982421875, 0.001953125, 0.140625, false, false},
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Energy'] = {
            124, 10, 0.3134765625, 0.4345703125, 0.458984375, 0.478515625, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Focus'] = {
            124, 10, 0.4365234375, 0.5576171875, 0.458984375, 0.478515625, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health'] = {
            124, 20, 0.5478515625, 0.6689453125, 0.35546875, 0.39453125, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health-Status'] = {
            124, 20, 0.6708984375, 0.7919921875, 0.3125, 0.3515625, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana'] = {
            124, 10, 0.5595703125, 0.6806640625, 0.458984375, 0.478515625, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana-Status'] = {
            124, 10, 0.6826171875, 0.8037109375, 0.458984375, 0.478515625, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Rage'] = {
            124, 10, 0.8056640625, 0.9267578125, 0.458984375, 0.478515625, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-RunicPower'] = {
            124, 10, 0.1904296875, 0.3115234375, 0.482421875, 0.501953125, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-CornerEmbellishment'] = {
            23, 23, 0.953125, 0.9755859375, 0.259765625, 0.3046875, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-InCombat'] = {
            192, 71, 0.1943359375, 0.3818359375, 0.169921875, 0.30859375, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Status'] = {
            196, 71, 0.0009765625, 0.1923828125, 0.169921875, 0.30859375, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Vehicle'] = {
            202, 84, 0.0009765625, 0.1982421875, 0.001953125, 0.166015625, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Vehicle-InCombat'] = {
            198, 84, 0.3984375, 0.591796875, 0.001953125, 0.166015625, false, false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Vehicle-Status'] = {
            201, 84, 0.2001953125, 0.396484375, 0.001953125, 0.166015625, false, false
        },
        ['UI-HUD-UnitFrame-Player-PVP-AllianceIcon'] = {
            28, 41, 0.1201171875, 0.1474609375, 0.8203125, 0.900390625, false, false
        },
        ['UI-HUD-UnitFrame-Player-PVP-FFAIcon'] = {
            28, 44, 0.1328125, 0.16015625, 0.716796875, 0.802734375, false, false
        },
        ['UI-HUD-UnitFrame-Player-PVP-HordeIcon'] = {
            44, 44, 0.953125, 0.99609375, 0.169921875, 0.255859375, false, false
        },
        ['UI-HUD-UnitFrame-Target-HighLevelTarget_Icon'] = {
            11, 14, 0.984375, 0.9951171875, 0.068359375, 0.095703125, false, false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn'] = {
            192, 67, 0.57421875, 0.76171875, 0.169921875, 0.30078125, false, false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Energy'] = {
            127, 10, 0.8544921875, 0.978515625, 0.412109375, 0.431640625, false, false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Focus'] = {
            127, 10, 0.1904296875, 0.314453125, 0.435546875, 0.455078125, false, false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Health'] = {
            125, 12, 0.7939453125, 0.916015625, 0.3515625, 0.375, false, false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Health-Status'] = {
            125, 12, 0.7939453125, 0.916015625, 0.37890625, 0.40234375, false, false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Mana'] = {
            127, 10, 0.31640625, 0.4404296875, 0.435546875, 0.455078125, false, false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Mana-Status'] = {
            127, 10, 0.4423828125, 0.56640625, 0.435546875, 0.455078125, false, false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Rage'] = {
            127, 10, 0.568359375, 0.6923828125, 0.435546875, 0.455078125, false, false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-RunicPower'] = {
            127, 10, 0.6943359375, 0.818359375, 0.435546875, 0.455078125, false, false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-InCombat'] = {
            188, 67, 0.0009765625, 0.1845703125, 0.447265625, 0.578125, false, false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Status'] = {
            193, 69, 0.3837890625, 0.572265625, 0.169921875, 0.3046875, false, false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn'] = {
            192, 67, 0.763671875, 0.951171875, 0.169921875, 0.30078125, false, false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy'] = {
            134, 10, 0.7890625, 0.919921875, 0.14453125, 0.1640625, false, false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus'] = {
            134, 10, 0.1904296875, 0.3212890625, 0.412109375, 0.431640625, false, false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health'] = {
            126, 20, 0.4228515625, 0.5458984375, 0.3125, 0.3515625, false, false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health-Status'] = {
            126, 20, 0.4228515625, 0.5458984375, 0.35546875, 0.39453125, false, false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana'] = {
            134, 10, 0.3232421875, 0.4541015625, 0.412109375, 0.431640625, false, false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana-Status'] = {
            134, 10, 0.4560546875, 0.5869140625, 0.412109375, 0.431640625, false, false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage'] = {
            134, 10, 0.5888671875, 0.7197265625, 0.412109375, 0.431640625, false, false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower'] = {
            134, 10, 0.7216796875, 0.8525390625, 0.412109375, 0.431640625, false, false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-InCombat'] = {
            188, 67, 0.0009765625, 0.1845703125, 0.58203125, 0.712890625, false, false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Type'] = {
            135, 18, 0.7939453125, 0.92578125, 0.3125, 0.34765625, false, false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Vehicle'] = {
            198, 81, 0.59375, 0.787109375, 0.001953125, 0.16015625, false, false
        },
        ['UI-HUD-UnitFrame-Target-Rare-PortraitOn'] = {
            192, 67, 0.0009765625, 0.1884765625, 0.3125, 0.443359375, false, false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn'] = {
            120, 49, 0.0009765625, 0.1181640625, 0.8203125, 0.916015625, false, false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Energy'] = {
            74, 7, 0.91796875, 0.990234375, 0.37890625, 0.392578125, false, false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Focus'] = {
            74, 7, 0.3134765625, 0.3857421875, 0.482421875, 0.49609375, false, false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health'] = {
            70, 10, 0.921875, 0.990234375, 0.14453125, 0.1640625, false, false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health-Status'] = {
            70, 10, 0.91796875, 0.986328125, 0.3515625, 0.37109375, false, false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana'] = {
            74, 7, 0.3876953125, 0.4599609375, 0.482421875, 0.49609375, false, false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana-Status'] = {
            74, 7, 0.4619140625, 0.5341796875, 0.482421875, 0.49609375, false, false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Rage'] = {
            74, 7, 0.5361328125, 0.6083984375, 0.482421875, 0.49609375, false, false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-RunicPower'] = {
            74, 7, 0.6103515625, 0.6826171875, 0.482421875, 0.49609375, false, false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-InCombat'] = {
            114, 47, 0.3095703125, 0.4208984375, 0.3125, 0.404296875, false, false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Status'] = {
            120, 49, 0.1904296875, 0.3076171875, 0.3125, 0.408203125, false, false
        }
    }

    local data = uiunitframe[key]
    return data[3], data[4], data[5], data[6]
end

function Module.HookDrag()
    local DragStopPlayerFrame = function(self)
        Module:SaveLocalSettings()

        for k, v in pairs(localSettings.player) do Module.db.profile.player[k] = v end
        Module.db.profile.player.anchorFrame = 'UIParent'
        Module:RefreshOptionScreens()
    end
    PlayerFrame:HookScript('OnDragStop', DragStopPlayerFrame)
    hooksecurefunc('PlayerFrame_ResetUserPlacedPosition', DragStopPlayerFrame)

    local DragStopTargetFrame = function(self)
        Module:SaveLocalSettings()

        for k, v in pairs(localSettings.target) do Module.db.profile.target[k] = v end
        Module.db.profile.target.anchorFrame = 'UIParent'
        Module:RefreshOptionScreens()
    end
    TargetFrame:HookScript('OnDragStop', DragStopTargetFrame)
    hooksecurefunc('TargetFrame_ResetUserPlacedPosition', DragStopTargetFrame)

    if DF.Wrath then
        local DragStopFocusFrame = function(self)
            Module:SaveLocalSettings()

            for k, v in pairs(localSettings.focus) do Module.db.profile.focus[k] = v end
            Module.db.profile.focus.anchorFrame = 'UIParent'
            Module:RefreshOptionScreens()
        end
        FocusFrame:HookScript('OnDragStop', DragStopFocusFrame)
        -- hooksecurefunc('FocusFrame_ResetUserPlacedPosition', DragStopFocusFrame)
    end
end

function Module.HookClassIcon()
    Module:Unhook('UnitFramePortrait_Update')
    Module:SecureHook('UnitFramePortrait_Update', function(self)
        -- print('UnitFramePortrait_Update', self:GetName(), self.unit)
        if not self.portrait then return end

        local icon
        local unit = self.unit

        if unit == "player" then
            icon = Module.db.profile.player.classicon
        elseif unit == "target" then
            icon = Module.db.profile.target.classicon
        elseif unit == "focus" then
            icon = Module.db.profile.focus.classicon
        end

        if (not icon) or unit == "pet" or (not UnitIsPlayer(unit)) then
            self.portrait:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
            SetPortraitTexture(self.portrait, unit)
            if self.portrait.fixClassSize then self.portrait:fixClassSize(false) end
            return
        end

        local texCoords = CLASS_ICON_TCOORDS[select(2, UnitClass(unit))]
        if texCoords then
            self.portrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
            self.portrait:SetTexCoord(unpack(texCoords))
            if self.portrait.fixClassSize then self.portrait:fixClassSize(true) end
        end
    end)
end

function Module.HookVertexColor()

    for i = 1, 4 do
        local healthbar = _G['PartyMemberFrame' .. i .. 'HealthBar']
        healthbar:HookScript('OnValueChanged', function(self)
            -- print('OnValueChanged', i)
            Module.UpdatePartyHPBar(i)
        end)
        healthbar:HookScript('OnEvent', function(self, event, arg1)
            -- print('OnValueChanged', i)
            if event == 'UNIT_MAXHEALTH' then Module.UpdatePartyHPBar(i) end
        end)
    end

    if DF.Wrath then
        local updateFocusFrameHealthBar = function()
            if Module.db.profile.focus.classcolor and UnitIsPlayer('focus') then
                FocusFrameHealthBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health-Status')
                local localizedClass, englishClass, classIndex = UnitClass('focus')
                FocusFrameHealthBar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
            else
                FocusFrameHealthBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health')
                FocusFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)
            end
        end

        FocusFrameHealthBar:HookScript('OnValueChanged', updateFocusFrameHealthBar)
        FocusFrameHealthBar:HookScript('OnEvent', function(self, event, arg1)
            if event == 'UNIT_MAXHEALTH' and arg1 == 'focus' then updateFocusFrameHealthBar() end
        end)
    end
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

function Module:AddRaidframeRoleIcons()
    local function updateRoleIcons(f)
        if not f.roleIcon then
            return
        else
            f.roleIcon:SetDrawLayer('OVERLAY')
            local size = f.roleIcon:GetHeight();
            local role = UnitGroupRolesAssigned(f.unit);
            if (role == "TANK" or role == "HEALER" or role == "DAMAGER") then
                f.roleIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES");
                f.roleIcon:SetTexCoord(GetTexCoordsForRoleSmallCircle(role));
                f.roleIcon:Show();
                f.roleIcon:SetSize(size, size);
                if strmatch(tostring(f.unit), 'target') then f.roleIcon:Hide() end
            else
                f.roleIcon:Hide();
                f.roleIcon:SetSize(1, size);
            end
        end
    end
    hooksecurefunc("CompactUnitFrame_UpdateRoleIcon", function(f)
        --
        -- print('CompactUnitFrame_UpdateRoleIcon')
        updateRoleIcons(f)
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

function frame:OnEvent(event, arg1)
    if true then return end
    -- print(event, arg1)
    if event == 'UNIT_POWER_UPDATE' and arg1 == 'focus' then
    elseif event == 'UNIT_POWER_UPDATE' and arg1 == 'pet' then
    elseif event == 'PET_BAR_UPDATE' then
        -- print('PET_BAR_UPDATE')      
    elseif event == 'UNIT_POWER_UPDATE' then
        -- print(event, arg1)
    elseif event == 'PLAYER_ENTERING_WORLD' then
        -- print('PLAYER_ENTERING_WORLD')
        Module.ChangeToT()
        if DF.Wrath then Module.ChangeFocusToT() end
        Module:ChangeFonts()
        Module:ApplySettings()
    elseif event == 'PLAYER_TARGET_CHANGED' then
        -- Module.ApplySettings()

    elseif event == 'UNIT_PORTRAIT_UPDATE' then
        Module.RefreshPortrait()
    elseif event == 'PORTRAITS_UPDATED' then
        Module.RefreshPortrait()
    elseif event == 'SETTINGS_LOADED' then
        Module:RefreshOptionScreens()
    end
end

function Module.RefreshPortrait()
    if UnitHasVehiclePlayerFrameUI('player') then
        -- SetPortraitTexture(PlayerPortrait, 'vehicle', true)
    else
        -- SetPortraitTexture(PlayerPortrait, 'player', true)
    end
end

function Module.ApplyPortraitMask()
    local playerMaskTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframeplayerportraitmask'
    local circularMaskTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\tempportraitalphamask'

    local mask = PlayerFrame:CreateMaskTexture()
    mask:SetPoint('CENTER', PlayerPortrait, 'CENTER', 1, 0)
    mask:SetTexture(playerMaskTexture, 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
    PlayerPortrait:AddMaskTexture(mask)

    -- mask:SetScale(2)

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

frame:SetScript('OnEvent', frame.OnEvent)

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
    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
    frame:RegisterEvent('PLAYER_TARGET_CHANGED')
    frame:RegisterEvent('PLAYER_FOCUS_CHANGED')
    frame:RegisterEvent('UNIT_PORTRAIT_UPDATE')
    frame:RegisterEvent('PET_BAR_UPDATE')

    frame:RegisterUnitEvent('UNIT_ENTERED_VEHICLE', 'player')
    frame:RegisterUnitEvent('UNIT_EXITED_VEHICLE', 'player')

    frame:RegisterEvent('UNIT_POWER_UPDATE')
    -- frame:RegisterUnitEvent('UNIT_POWER_UPDATE', 'pet') -- overriden by other RegisterUnitEvent

    frame:RegisterEvent('ZONE_CHANGED')
    frame:RegisterEvent('ZONE_CHANGED_INDOORS')
    frame:RegisterEvent('ZONE_CHANGED_NEW_AREA')

    frame:RegisterEvent('PORTRAITS_UPDATED')

    frame:RegisterEvent('CVAR_UPDATE')
    frame:RegisterEvent('SETTINGS_LOADED')

    Module.HookVertexColor()

    Module.HookPlayerArt()
    Module.HookDrag()

    -- Module.ApplyPortraitMask()
    Module.HookClassIcon()
    Module.ChangePartyFrame()
    Module.AddMobhealth()
    Module.CreatThreatIndicator()
    Module.ChangePetFrame()
    Module:AddAlternatePowerBar()
    Module:AddRaidframeRoleIcons()

    Module:CreatePlayerFrameExtra()
end

function Module:TBC()
end

function Module:Wrath()
    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
    frame:RegisterEvent('PLAYER_TARGET_CHANGED')
    frame:RegisterEvent('PLAYER_FOCUS_CHANGED')
    frame:RegisterEvent('UNIT_PORTRAIT_UPDATE')
    frame:RegisterEvent('PET_BAR_UPDATE')

    frame:RegisterUnitEvent('UNIT_ENTERED_VEHICLE', 'player')
    frame:RegisterUnitEvent('UNIT_EXITED_VEHICLE', 'player')

    frame:RegisterEvent('UNIT_POWER_UPDATE')
    -- frame:RegisterUnitEvent('UNIT_POWER_UPDATE', 'pet') -- overriden by other RegisterUnitEvent

    ---@diagnostic disable-next-line: redundant-parameter
    frame:RegisterUnitEvent('UNIT_POWER_UPDATE', 'focus', 'pet')
    frame:RegisterUnitEvent('UNIT_HEALTH', 'focus')

    frame:RegisterEvent('ZONE_CHANGED')
    frame:RegisterEvent('ZONE_CHANGED_INDOORS')
    frame:RegisterEvent('ZONE_CHANGED_NEW_AREA')

    frame:RegisterEvent('PORTRAITS_UPDATED')

    frame:RegisterEvent('CVAR_UPDATE')
    frame:RegisterEvent('SETTINGS_LOADED')

    Module.HookVertexColor()

    Module.HookDrag()

    -- Module.ApplyPortraitMask()
    Module.HookClassIcon()
    Module.ChangePetFrame()
end

function Module:Cata()
    Module:Wrath()
end

function Module:Mists()
    -- Module:Wrath()

    self.SubFocus:Setup()
    self.SubFocusTarget:Setup()

    self.SubAltPower:Setup()
    self.SubParty:Setup()
    self.SubPlayer:Setup()

    self.SubPet:Setup()
    self.SubTarget:Setup()
    self.SubTargetOfTarget:Setup()

    Module:HookEnergyBar()

    if true then return end
end
