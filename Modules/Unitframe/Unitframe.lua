local addonName, addonTable = ...;
---@diagnostic disable: undefined-global
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local rc = LibStub("LibRangeCheck-3.0")
local auraDurations = LibStub:GetLibrary('AuraDurations-1.0')
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

    Module.AddStateUpdater()
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

    DF.ConfigModule:RegisterSettingsData('target', 'unitframes', {
        options = optionsTarget,
        default = function()
            setDefaultSubValues('target')
        end
    })

    DF.ConfigModule:RegisterSettingsData('targetoftarget', 'unitframes', {
        options = optionsTargetOfTarget,
        default = function()
            setDefaultSubValues('tot')
        end
    })
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame

    local refreshCat = function(name)
        configFrame:RefreshCatSub('Unitframes', name)
    end

    if DF.Wrath then refreshCat('Focus') end
    refreshCat('Party')
    refreshCat('Pet')
    refreshCat('Player')
    refreshCat('Raid')
    refreshCat('Target')
    refreshCat('TargetOfTarget')

    if DF.Wrath then
        self.SubFocus.PreviewFocus.DFEditModeSelection:RefreshOptionScreen();
        self.SubFocusTarget.PreviewFocusTarget.DFEditModeSelection:RefreshOptionScreen();
    end
    if DF.Cata then self.SubAltPower.PowerBarAltPreview.DFEditModeSelection:RefreshOptionScreen(); end
    self.SubParty.PreviewParty.DFEditModeSelection:RefreshOptionScreen();
    PlayerFrame.DFEditModeSelection:RefreshOptionScreen();
    PetFrame.DFEditModeSelection:RefreshOptionScreen();

    if true then return end

    -- TargetFrame.DFEditModeSelection:RefreshOptionScreen();
    Module.PreviewTarget.DFEditModeSelection:RefreshOptionScreen();
    Module.PreviewTargetOfTarget.DFEditModeSelection:RefreshOptionScreen();
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

    if true then return end

    -- if sub then
    --     if sub == "target" then
    --         print('sub target')
    --         -- return;
    --     elseif sub == 'focus' then
    --         print('sub focus')
    --         -- return;
    --     end
    -- end

    -- target
    do
        local obj = db.target
        local objLocal = localSettings.target

        Module.MoveTargetFrame(obj.anchor, obj.anchorParent, obj.anchorFrame, obj.x, obj.y)
        TargetFrame:SetUserPlaced(true)

        TargetFrame:SetScale(obj.scale)
        Module.ReApplyTargetFrame()
        Module.ReApplyToT()
        TargetFrameHealthBar.breakUpLargeNumbers = obj.breakUpLargeNumbers
        TextStatusBar_UpdateTextString(TargetFrameHealthBar)
        Module.UpdateComboFrameState(obj)
        TargetFrameNameBackground:SetShown(not obj.hideNameBackground)
        auraDurations.frame:SetState(obj)
        UnitFramePortrait_Update(TargetFrame)
        TargetFrame:UpdateStateHandler(obj)
        Module.PreviewTarget:UpdateState(obj);
    end

    -- target of target
    do
        local obj = db.tot

        local anchorframe = _G[obj.anchorFrame]
        TargetFrameToT:ClearAllPoints()
        TargetFrameToT:SetPoint(obj.anchor, anchorframe, obj.anchorParent, obj.x, obj.y)
        TargetFrameToT:SetScale(obj.scale)

        Module.PreviewTargetOfTarget:UpdateState(obj);
    end
end

local frame = CreateFrame('FRAME', 'DragonflightUIUnitframeFrame', UIParent)
Module.Frame = frame

function Module.FixBlizzardBug()
    SetTextStatusBarText(PlayerFrameManaBar, PlayerFrameManaBarText)
    SetTextStatusBarText(PlayerFrameHealthBar, PlayerFrameHealthBarText)
    TextStatusBar_UpdateTextString(PlayerFrameHealthBar)
    TextStatusBar_UpdateTextString(PlayerFrameManaBar)
end

function Module.AddStateUpdater()
    Mixin(TargetFrame, DragonflightUIStateHandlerMixin)
    TargetFrame:InitStateHandler()
    TargetFrame:SetUnit('target')
end

function Module:AddEditMode()
    local EditModeModule = DF:GetModule('Editmode');

    -- Target
    local fakeTarget = CreateFrame('Frame', 'DragonflightUIEditModeTargetFramePreview', UIParent,
                                   'DFEditModePreviewTargetTemplate')
    fakeTarget:OnLoad()
    Module.PreviewTarget = fakeTarget;

    EditModeModule:AddEditModeToFrame(fakeTarget)

    fakeTarget.DFEditModeSelection:SetGetLabelTextFunction(function()
        return optionsTarget.name
    end)

    fakeTarget.DFEditModeSelection:RegisterOptions({
        options = optionsTarget,
        extra = optionsTargetEditmode,
        parentExtra = TargetFrame,
        default = function()
            setDefaultSubValues('target')
        end,
        moduleRef = self,
        showFunction = function()
            --
            -- TargetFrame.unit = 'player';
            -- TargetFrame_Update(TargetFrame);
            -- TargetFrame:Show()
            TargetFrame:SetAlpha(0)
        end,
        hideFunction = function()
            --        
            -- TargetFrame.unit = 'target';
            -- TargetFrame_Update(TargetFrame);
            TargetFrame:SetAlpha(1)
        end
    });

    -- Target of target
    local fakeTargetOfTarget = CreateFrame('Frame', 'DragonflightUIEditModeTargetFramePreview', UIParent,
                                           'DFEditModePreviewTargetOfTargetTemplate')
    fakeTargetOfTarget:OnLoad()
    fakeTargetOfTarget:SetParent(fakeTarget)
    Module.PreviewTargetOfTarget = fakeTargetOfTarget;

    EditModeModule:AddEditModeToFrame(fakeTargetOfTarget)

    fakeTargetOfTarget.DFEditModeSelection:SetGetLabelTextFunction(function()
        return optionsTargetOfTarget.name
    end)

    fakeTargetOfTarget.DFEditModeSelection:RegisterOptions({
        options = optionsTargetOfTarget,
        extra = optionsTargetOfTargetEditmode,
        default = function()
            setDefaultSubValues('tot')
        end,
        moduleRef = self,
        showFunction = function()
            --         
        end,
        hideFunction = function()
            --
        end
    });

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

    local updateTargetFrameHealthBar = function()
        if Module.db.profile.target.classcolor and UnitIsPlayer('target') then
            TargetFrameHealthBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health-Status')
            local localizedClass, englishClass, classIndex = UnitClass('target')
            TargetFrameHealthBar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
        else
            TargetFrameHealthBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health')
            TargetFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)
        end
    end
    TargetFrameHealthBar:HookScript('OnValueChanged', updateTargetFrameHealthBar)
    TargetFrameHealthBar:HookScript('OnEvent', function(self, event, arg1)
        if event == 'UNIT_MAXHEALTH' and arg1 == 'target' then updateTargetFrameHealthBar() end
    end)

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
            print('~UnitFrameManaBar_UpdateType:', manaBar:GetName())
            manaBar.DFUpdateFunc()
        end
    end)

    if true then return end
    hooksecurefunc("UnitFrameManaBar_UpdateType", function(manaBar)
        -- print('UnitFrameManaBar_UpdateType', manaBar:GetName())
        local name = manaBar:GetName()

        if name == 'PlayerFrameManaBar' then

        elseif name == 'TargetFrameManaBar' then
            local powerType, powerTypeString = UnitPowerType('target')

            if powerTypeString == 'MANA' then
                TargetFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana')
            elseif powerTypeString == 'FOCUS' then
                TargetFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus')
            elseif powerTypeString == 'RAGE' then
                TargetFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage')
            elseif powerTypeString == 'ENERGY' then
                TargetFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy')
            elseif powerTypeString == 'RUNIC_POWER' then
                TargetFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower')
            end

            TargetFrameManaBar:SetStatusBarColor(1, 1, 1, 1)
        elseif name == 'TargetFrameToTManaBar' then
            Module.ReApplyToT()
        elseif name == 'FocusFrameManaBar' then
            local powerType, powerTypeString = UnitPowerType('focus')

            if powerTypeString == 'MANA' then
                FocusFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana')
            elseif powerTypeString == 'FOCUS' then
                FocusFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus')
            elseif powerTypeString == 'RAGE' then
                FocusFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage')
            elseif powerTypeString == 'ENERGY' then
                FocusFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy')
            elseif powerTypeString == 'RUNIC_POWER' then
                FocusFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower')
            end

            FocusFrameManaBar:SetStatusBarColor(1, 1, 1, 1)

            FocusFrameFlash:SetTexture('')
        elseif name == 'PetFrameManaBar' then
            -- frame.UpdatePetManaBarTexture()
        else
            -- print('HookEnergyBar', manaBar:GetName())
        end
    end)
end

-- ChangePlayerframe()
-- frame:RegisterEvent('PLAYER_ENTERING_WORLD')

function Module.MovePlayerFrame(anchor, anchorOther, anchorFrame, dx, dy)
    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint(anchor, anchorFrame, anchorOther, dx, dy)
end

function Module.ChangeTargetFrame()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    TargetFrameTextureFrameTexture:Hide()
    TargetFrameBackground:Hide()

    if not frame.TargetFrameBackground then
        local background = TargetFrame:CreateTexture('DragonflightUITargetFrameBackground')
        background:SetDrawLayer('BACKGROUND', 2)
        background:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BACKGROUND')
        background:SetPoint('LEFT', TargetFrame, 'LEFT', 0, -32.5 + 10)
        frame.TargetFrameBackground = background
    end

    if not frame.TargetFrameBorder then
        local border = TargetFrame:CreateTexture('DragonflightUITargetFrameBorder')
        border:SetDrawLayer('ARTWORK', 2)
        border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BORDER')
        border:SetPoint('LEFT', TargetFrame, 'LEFT', 0, -32.5 + 10)
        frame.TargetFrameBorder = border
    end

    TargetFramePortrait:SetDrawLayer('BACKGROUND', -1)
    TargetFramePortrait:SetSize(56, 56)
    local CorrectionY = -3
    local CorrectionX = -5
    TargetFramePortrait:SetPoint('TOPRIGHT', TargetFrame, 'TOPRIGHT', -42 + CorrectionX, -12 + CorrectionY)

    -- TargetFrameTextureFrameRaidTargetIcon:SetPoint('CENTER',TargetFrameTextureFrame,'TOPRIGHT',-73,-14)
    -- TargetFrameTextureFrameRaidTargetIcon:GetHeight()
    TargetFrameTextureFrameRaidTargetIcon:SetPoint('CENTER', TargetFramePortrait, 'TOP', 0, 2)

    -- TargetFrameBuff1:SetPoint('TOPLEFT', TargetFrame, 'BOTTOMLEFT', 5, 0)

    -- @TODO: change text spacing
    TargetFrameTextureFrameName:ClearAllPoints()
    TargetFrameTextureFrameName:SetPoint('BOTTOM', TargetFrameHealthBar, 'TOP', 10, 3 - 2)
    TargetFrameTextureFrameName:SetSize(100, 12)

    TargetFrameTextureFrameLevelText:ClearAllPoints()
    TargetFrameTextureFrameLevelText:SetPoint('BOTTOMRIGHT', TargetFrameHealthBar, 'TOPLEFT', 16, 3 - 2)
    TargetFrameTextureFrameLevelText:SetHeight(12)

    TargetFrameTextureFrameDeadText:ClearAllPoints()
    TargetFrameTextureFrameDeadText:SetPoint('CENTER', TargetFrameHealthBar, 'CENTER', 0, 0)

    TargetFrameTextureFrameUnconsciousText:ClearAllPoints()
    TargetFrameTextureFrameUnconsciousText:SetPoint('CENTER', TargetFrameHealthBar, 'CENTER', 0, 0)

    -- Health 119,12
    TargetFrameHealthBar:ClearAllPoints()
    TargetFrameHealthBar:SetSize(125, 20)
    TargetFrameHealthBar:SetPoint('RIGHT', TargetFramePortrait, 'LEFT', -1, 0)
    --[[     TargetFrameHealthBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health'
    )
    TargetFrameHealthBar:SetStatusBarColor(1, 1, 1, 1) ]]
    -- Mana 119,12
    TargetFrameManaBar:ClearAllPoints()
    -- TargetFrameManaBar:SetPoint('RIGHT', TargetFramePortrait, 'LEFT', -1 + 8 - 0.5 + 1, -18 + 1 + 0.5)
    TargetFrameManaBar:SetPoint('TOPLEFT', TargetFrameHealthBar, 'BOTTOMLEFT', 0, -1)
    TargetFrameManaBar:SetSize(134, 10)
    TargetFrameManaBar:SetStatusBarColor(1, 1, 1, 1)

    if not TargetFrameManaBar.DFMask then
        local manaMask = TargetFrameManaBar:CreateMaskTexture()
        manaMask:SetPoint('TOPLEFT', TargetFrameManaBar, 'TOPLEFT', -61, 3)
        manaMask:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\ui-hud-unitframe-target-portraiton-bar-mana-mask-2x',
            'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
        manaMask:SetTexCoord(0, 1, 0, 1)
        manaMask:SetSize(256, 16)
        TargetFrameManaBar:GetStatusBarTexture():AddMaskTexture(manaMask)
        TargetFrameManaBar.DFMask = manaMask
    end

    TargetFrameNameBackground:SetTexture(base)
    TargetFrameNameBackground:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Target-PortraitOn-Type'))
    TargetFrameNameBackground:SetSize(135, 18)
    TargetFrameNameBackground:ClearAllPoints()
    TargetFrameNameBackground:SetPoint('BOTTOMLEFT', TargetFrameHealthBar, 'TOPLEFT', -2, -4 - 1)

    if not TargetFrameNameBackground.DFHooked then
        TargetFrameNameBackground.DFHooked = true

        TargetFrameNameBackground:HookScript('OnShow', function()
            --          
            local db = Module.db.profile.target
            if db.hideNameBackground then
                -- 
                TargetFrameNameBackground:Hide()
            end
        end)
    end

    if DF.Era then
        local parent = TargetFrameTextureFrame
        -- health
        if not parent.HealthBarText then
            parent.HealthBarText = parent:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
            TargetFrameHealthBar.TextString = parent.HealthBarText
        end

        if not parent.HealthBarTextLeft then
            parent.HealthBarTextLeft = parent:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
            TargetFrameHealthBar.LeftText = parent.HealthBarTextLeft
        end

        if not parent.HealthBarTextRight then
            parent.HealthBarTextRight = parent:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
            TargetFrameHealthBar.RightText = parent.HealthBarTextRight
        end
        -- mana
        if not parent.ManaBarText then
            parent.ManaBarText = parent:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
            TargetFrameManaBar.TextString = parent.ManaBarText
        end
        if not parent.ManaBarTextLeft then
            parent.ManaBarTextLeft = parent:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
            TargetFrameManaBar.LeftText = parent.ManaBarTextLeft
        end
        if not parent.ManaBarTextRight then
            parent.ManaBarTextRight = parent:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
            TargetFrameManaBar.RightText = parent.ManaBarTextRight
        end
    end

    if DF.Wrath or DF.Era then
        local dx = 5
        -- health vs mana bar
        local deltaSize = 132 - 125

        TargetFrameTextureFrame.HealthBarText:SetPoint('CENTER', TargetFrameHealthBar, 'CENTER', 0, 0)
        TargetFrameTextureFrame.HealthBarTextLeft:SetPoint('LEFT', TargetFrameHealthBar, 'LEFT', dx, 0)
        TargetFrameTextureFrame.HealthBarTextRight:SetPoint('RIGHT', TargetFrameHealthBar, 'RIGHT', -dx, 0)

        TargetFrameTextureFrame.ManaBarText:SetPoint('CENTER', TargetFrameManaBar, 'CENTER', -deltaSize / 2, 0)
        TargetFrameTextureFrame.ManaBarTextLeft:SetPoint('LEFT', TargetFrameManaBar, 'LEFT', dx, 0)
        TargetFrameTextureFrame.ManaBarTextRight:SetPoint('RIGHT', TargetFrameManaBar, 'RIGHT', -deltaSize - dx, 0)
    end

    if DF.Wrath then
        TargetFrameFlash:SetTexture('')

        if not frame.TargetFrameFlash then
            local flash = TargetFrame:CreateTexture('DragonflightUITargetFrameFlash')
            flash:SetDrawLayer('BACKGROUND', 2)
            flash:SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-InCombat')
            flash:SetPoint('CENTER', TargetFrame, 'CENTER', 20 + CorrectionX, -20 + CorrectionY)
            flash:SetSize(256, 128)
            flash:SetScale(1)
            flash:SetVertexColor(1.0, 0.0, 0.0, 1.0)
            flash:SetBlendMode('ADD')
            frame.TargetFrameFlash = flash
        end

        hooksecurefunc(TargetFrameFlash, 'Show', function()
            -- print('show')
            TargetFrameFlash:SetTexture('')
            frame.TargetFrameFlash:Show()
            if (UIFrameIsFlashing(frame.TargetFrameFlash)) then
            else
                -- print('go flash')
                local dt = 0.5
                UIFrameFlash(frame.TargetFrameFlash, dt, dt, -1)
            end
        end)

        hooksecurefunc(TargetFrameFlash, 'Hide', function()
            -- print('hide')
            TargetFrameFlash:SetTexture('')
            if (UIFrameIsFlashing(frame.TargetFrameFlash)) then UIFrameFlashStop(frame.TargetFrameFlash) end
            frame.TargetFrameFlash:Hide()
        end)
    end

    if not frame.PortraitExtra then
        local extra = TargetFrame:CreateTexture('DragonflightUITargetFramePortraitExtra')
        extra:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiunitframeboss2x')
        extra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
        extra:SetSize(80, 79)
        extra:SetDrawLayer('ARTWORK', 3)
        extra:SetPoint('CENTER', TargetFramePortrait, 'CENTER', 4, 1)

        extra.UpdateStyle = function()
            local class = UnitClassification('target')
            --[[ "worldboss", "rareelite", "elite", "rare", "normal", "trivial" or "minus" ]]
            if class == 'worldboss' then
                frame.PortraitExtra:Show()
                frame.PortraitExtra:SetSize(99, 81)
                frame.PortraitExtra:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.31835937)
                frame.PortraitExtra:SetPoint('CENTER', TargetFramePortrait, 'CENTER', 13, 1)
            elseif class == 'rareelite' or class == 'rare' then
                frame.PortraitExtra:Show()
                frame.PortraitExtra:SetSize(80, 79)
                frame.PortraitExtra:SetTexCoord(0.00390625, 0.31640625, 0.64453125, 0.953125)
                frame.PortraitExtra:SetPoint('CENTER', TargetFramePortrait, 'CENTER', 4, 1)
            elseif class == 'elite' then
                frame.PortraitExtra:Show()
                frame.PortraitExtra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
                frame.PortraitExtra:SetSize(80, 79)
                frame.PortraitExtra:SetPoint('CENTER', TargetFramePortrait, 'CENTER', 4, 1)
            else
                local name, realm = UnitName('target')
                if Module.famous[name] then
                    frame.PortraitExtra:Show()
                    frame.PortraitExtra:SetSize(99, 81)
                    frame.PortraitExtra:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.31835937)
                    frame.PortraitExtra:SetPoint('CENTER', TargetFramePortrait, 'CENTER', 13, 1)
                else
                    frame.PortraitExtra:Hide()
                end
            end
        end

        frame.PortraitExtra = extra
    end

    if not TargetFrame.DFRangeHooked then
        TargetFrame.DFRangeHooked = true;

        local state = Module.db.profile.target

        if not rc then return end
        local function updateRange()
            local minRange, maxRange = rc:GetRange('target')
            -- print(minRange, maxRange)

            if not state.fadeOut then
                TargetFrame:SetAlpha(1);
                return;
            end

            if minRange and minRange >= state.fadeOutDistance then
                TargetFrame:SetAlpha(0.55);
                -- elseif maxRange and maxRange >= 40 then
                --     TargetFrame:SetAlpha(0.55);
            else
                TargetFrame:SetAlpha(1);
            end
        end

        TargetFrame:HookScript('OnUpdate', updateRange)
        TargetFrame:HookScript('OnEvent', updateRange)
    end
end

function Module.ChangeTargetComboFrame()
    local c = ComboFrame
    c:SetParent(TargetFrame)
    c:SetFrameLevel(10)

    local tex = 'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\classoverlaycombopoints'

    for i = 1, 5 do
        --
        local point = _G['ComboPoint' .. i]

        local regions = {point:GetRegions()}

        for k, v in ipairs(regions) do
            --
            local layer = v:GetDrawLayer()
            -- print(k, layer)
            v:ClearAllPoints()
            v:SetSize(12, 12)
            v:SetPoint('CENTER', point, 'CENTER', 0, 0)
            v:SetTexture(tex)

            if layer == 'BACKGROUND' then
                v:SetTexCoord(0.226562, 0.382812, 0.515625, 0.671875)
            elseif layer == 'ARTWORK' then
                v:SetTexCoord(0.226562, 0.382812, 0.34375, 0.5)
            elseif layer == 'OVERLAY' then
                v:SetTexCoord(0.0078125, 0.210938, 0.164062, 0.375)
            end
        end
    end
end

function Module.UpdateComboFrameState(state)
    local c = ComboFrame

    if state.comboPointsOnPlayerFrame then
        c:SetParent(PlayerFrame)
        c:SetSize(116, 20)
        c:ClearAllPoints()
        -- c:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50 - 8, 34 + 4)
        -- ShardBarFrame:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50, 34 - 1)   

        local localizedClass, englishClass, classIndex = UnitClass('player');
        if englishClass == 'DRUID' then
            local deltaY = 16;
            c:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50 - 8, 34 + 4 - deltaY)
        else
            c:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50 - 8, 34 + 4)
        end

        for i = 1, 5 do
            --
            local size = 20
            local scaling = 20 / 12

            local point = _G['ComboPoint' .. i]
            point:SetSize(20, 20)
            point:ClearAllPoints()
            local dx = (i - 1) * 24 / scaling
            point:SetPoint('TOPLEFT', c, 'TOPLEFT', dx, 0)

            point:SetScale(scaling)
        end
    else
        -- default
        c:SetParent(TargetFrame)
        c:SetSize(256, 32)
        c:ClearAllPoints()
        c:SetPoint('TOPRIGHT', TargetFrame, 'TOPRIGHT', -44, -9)

        local comboDefaults = {{0, 0}, {7, -8}, {12, -19}, {14, -30}, {12, -41}}

        for i = 1, 5 do
            --
            local scaling = 1

            local point = _G['ComboPoint' .. i]
            point:SetSize(12, 12)
            point:ClearAllPoints()
            point:SetPoint('TOPRIGHT', c, 'TOPRIGHT', comboDefaults[i][1], comboDefaults[i][2])

            point:SetScale(scaling)
        end
    end

    if state.hideComboPoints then
        c:ClearAllPoints()
        c:SetPoint('TOP', UIParent, 'TOP', 0, 50)
    end
end

function Module.ReApplyTargetFrame()
    if Module.db.profile.target.classcolor and UnitIsPlayer('target') then
        TargetFrameHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health-Status')
        local localizedClass, englishClass, classIndex = UnitClass('target')
        TargetFrameHealthBar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
    else
        TargetFrameHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health')
        TargetFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)
    end

    local powerType, powerTypeString = UnitPowerType('target')

    if powerTypeString == 'MANA' then
        TargetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana')
    elseif powerTypeString == 'FOCUS' then
        TargetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus')
    elseif powerTypeString == 'RAGE' then
        TargetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage')
    elseif powerTypeString == 'ENERGY' then
        TargetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy')
    elseif powerTypeString == 'RUNIC_POWER' then
        TargetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower')
    end

    TargetFrameManaBar:SetStatusBarColor(1, 1, 1, 1)
    if DF.Wrath then TargetFrameFlash:SetTexture('') end

    if frame.PortraitExtra then frame.PortraitExtra:UpdateStyle() end
end
-- frame:RegisterEvent('PLAYER_TARGET_CHANGED')

function Module.ReApplyToT()
    if Module.db.profile.target.classcolor and UnitIsPlayer('targettarget') then
        TargetFrameToTHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health-Status')
        local localizedClass, englishClass, classIndex = UnitClass('targettarget')
        TargetFrameToTHealthBar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
    else
        TargetFrameToTHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health')
        TargetFrameToTHealthBar:SetStatusBarColor(1, 1, 1, 1)
    end

    local powerType, powerTypeString = UnitPowerType('targettarget')

    if powerTypeString == 'MANA' then
        TargetFrameToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana')
    elseif powerTypeString == 'FOCUS' then
        TargetFrameToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Focus')
    elseif powerTypeString == 'RAGE' then
        TargetFrameToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Rage')
    elseif powerTypeString == 'ENERGY' then
        TargetFrameToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Energy')
    elseif powerTypeString == 'RUNIC_POWER' then
        TargetFrameToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-RunicPower')
    end

    TargetFrameToTManaBar:SetStatusBarColor(1, 1, 1, 1)
end

function Module.MoveTargetFrame(anchor, anchorOther, anchorFrame, dx, dy)
    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint(anchor, anchorFrame, anchorOther, dx, dy)
end

function Module.ShouldKnowHealth(unit)
    local guid = UnitGUID(unit)
    local matched = guid and guid:match("^(.-)%-")

    return UnitIsUnit(unit, 'Player') or UnitIsUnit(unit, 'Pet') or UnitPlayerOrPetInRaid(unit) or
               UnitPlayerOrPetInParty(unit) or (matched == 'Creature')
end

function Module.AddMobhealth()
    hooksecurefunc('UnitFrameHealthBar_Update', function(statusbar, unit)
        -- print(statusbar:GetName(), 'should know?', Module.ShouldKnowHealth(unit))
        local shouldKnow = Module.ShouldKnowHealth(unit)

        if shouldKnow then
            -- print('should know: ', statusbar:GetName(), unit)
            statusbar.showPercentage = false;
            TextStatusBar_UpdateTextString(statusbar)
        end
    end)

    --[[    hooksecurefunc("TextStatusBar_UpdateTextStringWithValues",
                   function(statusFrame, textString, value, valueMin, valueMax)
        -- print(statusFrame, textString, value, valueMin, valueMax)
    end); ]]

    hooksecurefunc("TextStatusBar_UpdateTextString", function(textStatusBar)
        local textString = textStatusBar.TextString;
        if textString then
            local value = textStatusBar:GetValue();
            local valueMin, valueMax = textStatusBar:GetMinMaxValues();

            -- print('TextStatusBar_UpdateTextString', textStatusBar:GetName(), value, valueMin, valueMax)
        end
    end)

end

function Module.ChangeToT()
    -- TargetFrameToTTextureFrame:Hide()
    TargetFrameToT:ClearAllPoints()
    TargetFrameToT:SetPoint('BOTTOMRIGHT', TargetFrame, 'BOTTOMRIGHT', -35 + 27, -10 - 5)
    TargetFrameToT:SetSize(93 + 27, 45)

    TargetFrameToTTextureFrameTexture:SetTexture('')
    -- TargetFrameToTTextureFrameTexture:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-TargetofTarget-PortraitOn'))
    local totDelta = 1

    if not frame.TargetFrameToTBackground then
        local background = TargetFrameToTTextureFrame:CreateTexture('DragonflightUITargetFrameToTBackground')
        background:SetDrawLayer('BACKGROUND', 1)
        background:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BACKGROUND')
        background:SetPoint('LEFT', TargetFrameToTPortrait, 'CENTER', -25 + 1, -10 + totDelta)
        frame.TargetFrameToTBackground = background
    end
    TargetFrameToTBackground:Hide()

    if not frame.TargetFrameToTBorder then
        local border = TargetFrameToTHealthBar:CreateTexture('DragonflightUITargetFrameToTBorder')
        border:SetDrawLayer('ARTWORK', 2)
        border:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BORDER')
        border:SetPoint('LEFT', TargetFrameToTPortrait, 'CENTER', -25 + 1, -10 + totDelta)
        frame.TargetFrameToTBorder = border
    end

    TargetFrameToTHealthBar:ClearAllPoints()
    TargetFrameToTHealthBar:SetPoint('LEFT', TargetFrameToTPortrait, 'RIGHT', 1 + 1, 0 + totDelta)
    TargetFrameToTHealthBar:SetFrameLevel(10)
    TargetFrameToTHealthBar:SetSize(70.5, 10)

    TargetFrameToTManaBar:ClearAllPoints()
    TargetFrameToTManaBar:SetPoint('LEFT', TargetFrameToTPortrait, 'RIGHT', 1 - 2 - 1.5 + 1, 2 - 10 - 1 + totDelta)
    TargetFrameToTManaBar:SetFrameLevel(10)
    TargetFrameToTManaBar:SetSize(74, 7.5)

    TargetFrameToTTextureFrameName:ClearAllPoints()
    TargetFrameToTTextureFrameName:SetPoint('LEFT', TargetFrameToTPortrait, 'RIGHT', 1 + 1, 2 + 12 - 1 + totDelta)

    TargetFrameToTTextureFrameDeadText:ClearAllPoints()
    TargetFrameToTTextureFrameDeadText:SetPoint('CENTER', TargetFrameToTHealthBar, 'CENTER', 0, 0)

    TargetFrameToTTextureFrameUnconsciousText:ClearAllPoints()
    TargetFrameToTTextureFrameUnconsciousText:SetPoint('CENTER', TargetFrameToTHealthBar, 'CENTER', 0, 0)

    TargetFrameToTDebuff1:SetPoint('TOPLEFT', TargetFrameToT, 'TOPRIGHT', 5, -20)
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
        Module.ChangeTargetFrame()
        Module.ChangeTargetComboFrame()
        Module.ChangeToT()
        Module.ReApplyTargetFrame()
        if DF.Wrath then Module.ChangeFocusToT() end
        Module:ChangeFonts()
        Module:ApplySettings()
    elseif event == 'PLAYER_TARGET_CHANGED' then
        -- Module.ApplySettings()
        Module.ReApplyTargetFrame()

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

function Module.CreatThreatIndicator()
    local sizeX, sizeY = 42, 16

    local indi = CreateFrame('Frame', 'DragonflightUIThreatIndicator', TargetFrame)
    indi:SetSize(sizeX, sizeY)
    indi:SetPoint('BOTTOM', TargetFrameTextureFrameName, 'TOP', 0, 2)

    local bg = indi:CreateTexture(nil, 'BACKGROUND')
    bg:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
    bg:SetTexture(
        "Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health");
    bg:SetPoint('CENTER', 0, 0)
    bg:SetSize(sizeX, sizeY)

    -- TargetFrameHealthBar:GetStatusBarTexture():SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health')
    -- TargetFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)

    local text = indi:CreateFontString(nil, 'BACKGROUND', 'GameFontHighlight')
    text:SetPoint('CENTER', 0, 0)
    text:SetText('999%')

    indi.Background = bg
    indi.Text = text
    Module.ThreatIndicator = indi

    local function UpdateIndicator()
        local db = Module.db.profile
        local enableNumeric = db.target.enableNumericThreat
        local threatAnchor = db.target.numericThreatAnchor
        local enableGlow = db.target.enableThreatGlow

        if UnitExists('TARGET') and (enableNumeric or enableGlow) then
            local isTanking, status, percentage, rawPercentage = UnitDetailedThreatSituation('PLAYER', 'TARGET')
            local display = rawPercentage;

            if enableNumeric then
                if isTanking then
                    ---@diagnostic disable-next-line: cast-local-type
                    display = UnitThreatPercentageOfLead('PLAYER', 'TARGET')
                    -- print('IsTanking')
                end

                if display and display ~= 0 then
                    -- print('t:', display)
                    display = min(display, MAX_DISPLAYED_THREAT_PERCENT);
                    text:SetText(format("%1.0f", display) .. "%")
                    bg:SetVertexColor(GetThreatStatusColor(status))
                    indi:Show()
                else
                    indi:Hide()
                end
            else
                indi:Hide()
            end

            if enableGlow then
                -- show
            else
                -- hide
            end

            indi:ClearAllPoints()
            if threatAnchor == 'TOP' then
                indi:SetPoint('BOTTOM', TargetFrameTextureFrameName, 'TOP', 0, 2)
            elseif threatAnchor == 'RIGHT' then
                indi:SetPoint('LEFT', TargetFramePortrait, 'RIGHT', 5, 0)
            elseif threatAnchor == 'BOTTOM' then
                indi:SetPoint('TOP', TargetFrameManaBar, 'BOTTOM', 0, -2)
            elseif threatAnchor == 'LEFT' then
                indi:SetPoint('RIGHT', TargetFrameHealthBar, 'LEFT', -2, 0)
            else
                -- should not happen
                indi:SetPoint('BOTTOM', TargetFrameTextureFrameName, 'TOP', 0, 2)
            end
        else
            indi:Hide()
            -- disable glow
        end
    end

    indi:RegisterEvent('PLAYER_TARGET_CHANGED')
    indi:RegisterUnitEvent('UNIT_THREAT_LIST_UPDATE', 'TARGET')

    indi:SetScript('OnEvent', UpdateIndicator)
    UpdateIndicator()
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

    Module:HookEnergyBar()

    if true then return end
end
