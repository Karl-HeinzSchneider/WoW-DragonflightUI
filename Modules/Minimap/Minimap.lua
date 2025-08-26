local addonName, addonTable = ...;
local Helper = addonTable.Helper;
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Minimap'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')
Module.Tmp = {}

Mixin(Module, DragonflightUIModulesMixin)

Module.SubDurability = DF:CreateFrameFromMixinAndInit(addonTable.SubModuleMixins['Durability'])
Module.SubMinimap = DF:CreateFrameFromMixinAndInit(addonTable.SubModuleMixins['Minimap'])

local defaults = {
    profile = {
        scale = 1,
        minimap = Module.SubMinimap.Defaults,
        tracker = {
            scale = 1,
            anchorFrame = 'UIParent',
            customAnchorFrame = '',
            anchor = 'TOPRIGHT',
            anchorParent = 'TOPRIGHT',
            x = 0,
            y = -310
        },
        durability = Module.SubDurability.Defaults,
        lfg = {
            scale = 1,
            anchorFrame = 'Minimap',
            customAnchorFrame = '',
            anchor = 'CENTER',
            anchorParent = 'CENTER',
            x = -62.38,
            y = -41.63
        }
    }
}
Module:SetDefaults(defaults)

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
    -- print('setOption', info[1], info[2], value)
    Module:SetOption(info, value)
end

local function setPreset(T, preset, sub)
    -- print('setPreset')
    -- DevTools_Dump(T)
    -- print('---')
    -- DevTools_Dump(preset)

    for k, v in pairs(preset) do
        --
        T[k] = v;
    end
    Module:ApplySettings(sub)
    Module:RefreshOptionScreens()
end

local frameTable = {
    {value = 'UIParent', text = 'UIParent', tooltip = 'descr', label = 'label'},
    {value = 'MinimapCluster', text = 'MinimapCluster', tooltip = 'descr', label = 'label'}
}

local frameTableTracker = {
    {value = 'UIParent', text = 'UIParent', tooltip = 'descr', label = 'label'},
    {value = 'MinimapCluster', text = 'MinimapCluster', tooltip = 'descr', label = 'label'},
    {value = 'Minimap', text = 'Minimap', tooltip = 'descr', label = 'label'},
    {value = 'DragonflightUIMinimapBase', text = 'DF_MinimapFrame', tooltip = 'descr', label = 'label'}
}

local trackerOptions = {
    type = 'group',
    name = L["MinimapTrackerName"],
    advancedName = 'Tracker',
    sub = 'tracker',
    get = getOption,
    set = setOption,
    args = {}
}
DF.Settings:AddPositionTable(Module, trackerOptions, 'tracker', 'Tracker', getDefaultStr, frameTableTracker)

local optionsTrackerEditmode = {
    name = 'Tracker',
    desc = 'Tracker',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        resetPosition = {
            type = 'execute',
            name = L["ExtraOptionsPreset"],
            btnName = L["ExtraOptionsResetToDefaultPosition"],
            desc = L["ExtraOptionsPresetDesc"],
            func = function()
                local dbTable = Module.db.profile.tracker
                local defaultsTable = defaults.profile.tracker
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'tracker')
            end,
            order = 16,
            editmode = true,
            new = false
        }
    }
}

local optionsLFG = {
    type = 'group',
    name = L["MinimapLFGName"],
    advancedName = 'LFG',
    sub = 'lfg',
    get = getOption,
    set = setOption,
    args = {}
}
DF.Settings:AddPositionTable(Module, optionsLFG, 'lfg', 'LFG', getDefaultStr, frameTableTracker)

local optionsLFGEditmode = {
    name = 'LFG',
    desc = 'LFG',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        resetPosition = {
            type = 'execute',
            name = L["ExtraOptionsPreset"],
            btnName = L["ExtraOptionsResetToDefaultPosition"],
            desc = L["ExtraOptionsPresetDesc"],
            func = function()
                local dbTable = Module.db.profile.lfg
                local defaultsTable = defaults.profile.lfg
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'lfg')
            end,
            order = 16,
            editmode = true,
            new = false
        }
    }
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)
    hooksecurefunc(DF:GetModule('Config'), 'AddConfigFrame', function()
        Module:RegisterSettings()
    end)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    self:EnableAddonSpecific()

    Module.Tmp.MinimapX = 0
    Module.Tmp.MinimapY = 0
    -- Module.AddStateUpdater()

    Module:ApplySettings()
    Module:RegisterOptionScreens()
    Module:AddEditMode()

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)
        Module:ApplySettings()
        Module:RefreshOptionScreens()
    end)
end

function Module:OnDisable()
end

function Module:RegisterSettings()
    local moduleName = 'Minimap'
    local cat = 'misc'
    local function register(name, data)
        data.module = moduleName;
        DF.ConfigModule:RegisterSettingsElement(name, cat, data, true)
    end

    register('minimap', {order = 1, name = self.SubMinimap.Options.name, descr = 'Minimapss', isNew = true})
    register('questtracker', {order = 1, name = trackerOptions.name, descr = 'Trackers', isNew = false})
    register('durability', {order = 1, name = self.SubDurability.Options.name, descr = 'Durablityss', isNew = false})
    register('lfg', {order = 1, name = optionsLFG.name, descr = 'LFGss', isNew = false})
end

function Module:RegisterOptionScreens()
    DF.ConfigModule:RegisterSettingsData('questtracker', 'misc', {
        options = trackerOptions,
        default = function()
            setDefaultSubValues(trackerOptions.sub)
        end
    })

    DF.ConfigModule:RegisterSettingsData('lfg', 'misc', {
        options = optionsLFG,
        default = function()
            setDefaultSubValues(optionsLFG.sub)
        end
    })
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame
    local cat = 'Misc'
    configFrame:RefreshCatSub(cat, 'Minimap')
    configFrame:RefreshCatSub(cat, 'Questtracker')
    configFrame:RefreshCatSub(cat, 'Durability')
    configFrame:RefreshCatSub(cat, 'LFG')

    Module.TrackerFrameRef.DFEditModeSelection:RefreshOptionScreen()
    if Module.LFG then Module.LFG.DFEditModeSelection:RefreshOptionScreen() end

    self.SubDurability.BaseFrame.DFEditModeSelection:RefreshOptionScreen()
    self.SubMinimap.BaseFrame.DFEditModeSelection:RefreshOptionScreen()
end

function Module:ApplySettings(sub, key)
    Helper:Benchmark(string.format('ApplySettings(%s,%s)', tostring(sub), tostring(key)), function()
        Module:ApplySettingsInternal(sub, key)
    end, 0, self)
end

function Module:ApplySettingsInternal(sub, key)
    local db = Module.db.profile

    Module.UpdateTrackerState(db.tracker)
    Module:UpdateLFGState(db.lfg)

    self.SubDurability:UpdateState(db.durability)
    self.SubMinimap:UpdateState(db.minimap)
end

local frame = CreateFrame('FRAME')
Module.Frame = frame

function Module.GetCoords(key)
    local uiunitframe = {
        ['UI-HUD-Calendar-1-Down'] = {21, 19, 0.00390625, 0.0859375, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-1-Mouseover'] = {21, 19, 0.09375, 0.17578125, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-1-Up'] = {21, 19, 0.18359375, 0.265625, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-10-Down'] = {21, 19, 0.2734375, 0.35546875, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-10-Mouseover'] = {21, 19, 0.36328125, 0.4453125, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-10-Up'] = {21, 19, 0.453125, 0.53515625, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-11-Down'] = {21, 19, 0.54296875, 0.625, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-11-Mouseover'] = {21, 19, 0.6328125, 0.71484375, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-11-Up'] = {21, 19, 0.72265625, 0.8046875, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-12-Down'] = {21, 19, 0.8125, 0.89453125, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-12-Mouseover'] = {21, 19, 0.90234375, 0.984375, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-12-Up'] = {21, 19, 0.00390625, 0.0859375, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-13-Down'] = {21, 19, 0.09375, 0.17578125, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-13-Mouseover'] = {21, 19, 0.18359375, 0.265625, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-13-Up'] = {21, 19, 0.2734375, 0.35546875, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-14-Down'] = {21, 19, 0.36328125, 0.4453125, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-14-Mouseover'] = {21, 19, 0.453125, 0.53515625, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-14-Up'] = {21, 19, 0.54296875, 0.625, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-15-Down'] = {21, 19, 0.6328125, 0.71484375, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-15-Mouseover'] = {21, 19, 0.72265625, 0.8046875, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-15-Up'] = {21, 19, 0.8125, 0.89453125, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-16-Down'] = {21, 19, 0.90234375, 0.984375, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-16-Mouseover'] = {21, 19, 0.00390625, 0.0859375, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-16-Up'] = {21, 19, 0.00390625, 0.0859375, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-17-Down'] = {21, 19, 0.00390625, 0.0859375, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-17-Mouseover'] = {21, 19, 0.00390625, 0.0859375, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-17-Up'] = {21, 19, 0.00390625, 0.0859375, 0.49609375, 0.5703125, false, false},
        ['UI-HUD-Calendar-18-Down'] = {21, 19, 0.00390625, 0.0859375, 0.578125, 0.65234375, false, false},
        ['UI-HUD-Calendar-18-Mouseover'] = {21, 19, 0.00390625, 0.0859375, 0.66015625, 0.734375, false, false},
        ['UI-HUD-Calendar-18-Up'] = {21, 19, 0.00390625, 0.0859375, 0.7421875, 0.81640625, false, false},
        ['UI-HUD-Calendar-19-Down'] = {21, 19, 0.00390625, 0.0859375, 0.82421875, 0.8984375, false, false},
        ['UI-HUD-Calendar-19-Mouseover'] = {21, 19, 0.00390625, 0.0859375, 0.90625, 0.98046875, false, false},
        ['UI-HUD-Calendar-19-Up'] = {21, 19, 0.09375, 0.17578125, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-2-Down'] = {21, 19, 0.18359375, 0.265625, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-2-Mouseover'] = {21, 19, 0.2734375, 0.35546875, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-2-Up'] = {21, 19, 0.36328125, 0.4453125, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-20-Down'] = {21, 19, 0.453125, 0.53515625, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-20-Mouseover'] = {21, 19, 0.54296875, 0.625, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-20-Up'] = {21, 19, 0.6328125, 0.71484375, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-21-Down'] = {21, 19, 0.72265625, 0.8046875, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-21-Mouseover'] = {21, 19, 0.8125, 0.89453125, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-21-Up'] = {21, 19, 0.90234375, 0.984375, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-22-Down'] = {21, 19, 0.09375, 0.17578125, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-22-Mouseover'] = {21, 19, 0.09375, 0.17578125, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-22-Up'] = {21, 19, 0.09375, 0.17578125, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-23-Down'] = {21, 19, 0.09375, 0.17578125, 0.49609375, 0.5703125, false, false},
        ['UI-HUD-Calendar-23-Mouseover'] = {21, 19, 0.09375, 0.17578125, 0.578125, 0.65234375, false, false},
        ['UI-HUD-Calendar-23-Up'] = {21, 19, 0.09375, 0.17578125, 0.66015625, 0.734375, false, false},
        ['UI-HUD-Calendar-24-Down'] = {21, 19, 0.09375, 0.17578125, 0.7421875, 0.81640625, false, false},
        ['UI-HUD-Calendar-24-Mouseover'] = {21, 19, 0.09375, 0.17578125, 0.82421875, 0.8984375, false, false},
        ['UI-HUD-Calendar-24-Up'] = {21, 19, 0.09375, 0.17578125, 0.90625, 0.98046875, false, false},
        ['UI-HUD-Calendar-25-Down'] = {21, 19, 0.18359375, 0.265625, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-25-Mouseover'] = {21, 19, 0.2734375, 0.35546875, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-25-Up'] = {21, 19, 0.36328125, 0.4453125, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-26-Down'] = {21, 19, 0.453125, 0.53515625, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-26-Mouseover'] = {21, 19, 0.54296875, 0.625, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-26-Up'] = {21, 19, 0.6328125, 0.71484375, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-27-Down'] = {21, 19, 0.72265625, 0.8046875, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-27-Mouseover'] = {21, 19, 0.8125, 0.89453125, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-27-Up'] = {21, 19, 0.90234375, 0.984375, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-28-Down'] = {21, 19, 0.18359375, 0.265625, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-28-Mouseover'] = {21, 19, 0.18359375, 0.265625, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-28-Up'] = {21, 19, 0.18359375, 0.265625, 0.49609375, 0.5703125, false, false},
        ['UI-HUD-Calendar-29-Down'] = {21, 19, 0.18359375, 0.265625, 0.578125, 0.65234375, false, false},
        ['UI-HUD-Calendar-29-Mouseover'] = {21, 19, 0.18359375, 0.265625, 0.66015625, 0.734375, false, false},
        ['UI-HUD-Calendar-29-Up'] = {21, 19, 0.18359375, 0.265625, 0.7421875, 0.81640625, false, false},
        ['UI-HUD-Calendar-3-Down'] = {21, 19, 0.18359375, 0.265625, 0.82421875, 0.8984375, false, false},
        ['UI-HUD-Calendar-3-Mouseover'] = {21, 19, 0.18359375, 0.265625, 0.90625, 0.98046875, false, false},
        ['UI-HUD-Calendar-3-Up'] = {21, 19, 0.2734375, 0.35546875, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-30-Down'] = {21, 19, 0.36328125, 0.4453125, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-30-Mouseover'] = {21, 19, 0.453125, 0.53515625, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-30-Up'] = {21, 19, 0.54296875, 0.625, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-31-Down'] = {21, 19, 0.6328125, 0.71484375, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-31-Mouseover'] = {21, 19, 0.72265625, 0.8046875, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-31-Up'] = {21, 19, 0.8125, 0.89453125, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-4-Down'] = {21, 19, 0.90234375, 0.984375, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-4-Mouseover'] = {21, 19, 0.2734375, 0.35546875, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-4-Up'] = {21, 19, 0.2734375, 0.35546875, 0.49609375, 0.5703125, false, false},
        ['UI-HUD-Calendar-5-Down'] = {21, 19, 0.2734375, 0.35546875, 0.578125, 0.65234375, false, false},
        ['UI-HUD-Calendar-5-Mouseover'] = {21, 19, 0.2734375, 0.35546875, 0.66015625, 0.734375, false, false},
        ['UI-HUD-Calendar-5-Up'] = {21, 19, 0.2734375, 0.35546875, 0.7421875, 0.81640625, false, false},
        ['UI-HUD-Calendar-6-Down'] = {21, 19, 0.2734375, 0.35546875, 0.82421875, 0.8984375, false, false},
        ['UI-HUD-Calendar-6-Mouseover'] = {21, 19, 0.2734375, 0.35546875, 0.90625, 0.98046875, false, false},
        ['UI-HUD-Calendar-6-Up'] = {21, 19, 0.36328125, 0.4453125, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-7-Down'] = {21, 19, 0.453125, 0.53515625, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-7-Mouseover'] = {21, 19, 0.54296875, 0.625, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-7-Up'] = {21, 19, 0.6328125, 0.71484375, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-8-Down'] = {21, 19, 0.72265625, 0.8046875, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-8-Mouseover'] = {21, 19, 0.8125, 0.89453125, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-8-Up'] = {21, 19, 0.90234375, 0.984375, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-9-Down'] = {21, 19, 0.36328125, 0.4453125, 0.49609375, 0.5703125, false, false},
        ['UI-HUD-Calendar-9-Mouseover'] = {21, 19, 0.36328125, 0.4453125, 0.578125, 0.65234375, false, false},
        ['UI-HUD-Calendar-9-Up'] = {21, 19, 0.36328125, 0.4453125, 0.66015625, 0.734375, false, false}
    }

    local data = uiunitframe[key]
    return data[3], data[4], data[5], data[6]
end

function Module:AddEditMode()
    local EditModeModule = DF:GetModule('Editmode');

    -- QuestTracker
    local trackerFrame = (DF.Era and QuestWatchFrame) or (DF.Wrath and WatchFrame) or (DF.Cata and WatchFrame);
    if trackerFrame then
        Module.TrackerFrameRef = trackerFrame;
        EditModeModule:AddEditModeToFrame(trackerFrame)

        trackerFrame.DFEditModeSelection:SetGetLabelTextFunction(function()
            return trackerOptions.name
        end)

        trackerFrame.DFEditModeSelection:RegisterOptions({
            options = trackerOptions,
            extra = optionsTrackerEditmode,
            default = function()
                setDefaultSubValues(trackerOptions.sub)
            end,
            moduleRef = self,
            prio = -5
        });

        if trackerFrame:GetHeight() > 500 then
            trackerFrame.DFEditModeSelection:ClearAllPoints()
            trackerFrame.DFEditModeSelection:SetPoint('TOPLEFT', trackerFrame, 'TOPLEFT', 0, 0)
            trackerFrame.DFEditModeSelection:SetPoint('BOTTOMRIGHT', trackerFrame, 'TOPRIGHT', 0, -500)
        end

        -- TODO: add fake preview
        function Module.TrackerFrameRef:SetEditMode()
        end
    end
end

function Module:UpdateMinimapZonePanelPosition(pos)
    if pos ~= 'TOP' and pos ~= 'BOTTOM' then pos = 'TOP' end

    local f = frame.MinimapInfo;
    f:ClearAllPoints()
    MiniMapMailFrame:ClearAllPoints()

    if pos == 'TOP' then
        -- default
        f:SetPoint('CENTER', Minimap, 'TOP', 0, 20)

        if DF.Wrath or DF.Cata then
            MiniMapMailFrame:SetPoint('TOPRIGHT', MiniMapTracking, 'BOTTOMRIGHT', 2, -1)
        else
            MiniMapMailFrame:SetPoint('RIGHT', _G['DragonflightUIMinimapTop'], 'LEFT', 0, 0)
        end

        if Minimap.DFShower then
            Minimap.DFShower:ClearAllPoints()
            Minimap.DFShower:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', -16, 32 + 32)
            Minimap.DFShower:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', 16, -16)
        end
        if Minimap.DFMouseHandler then
            Minimap.DFMouseHandler:ClearAllPoints()
            Minimap.DFMouseHandler:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', -16, 32)
            Minimap.DFMouseHandler:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', 16, -16)
        end
    else
        f:SetPoint('CENTER', Minimap, 'BOTTOM', 0, -20)

        if DF.Wrath or DF.Cata then
            MiniMapMailFrame:SetPoint('BOTTOMRIGHT', MiniMapTracking, 'TOPRIGHT', 2, 1)
        else
            MiniMapMailFrame:SetPoint('RIGHT', _G['DragonflightUIMinimapTop'], 'LEFT', 0, 0)
        end

        if Minimap.DFShower then
            Minimap.DFShower:ClearAllPoints()
            Minimap.DFShower:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', -16, 32)
            Minimap.DFShower:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', 16, -16 - 32)
        end
        if Minimap.DFMouseHandler then
            Minimap.DFMouseHandler:ClearAllPoints()
            Minimap.DFMouseHandler:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', -16, 32)
            Minimap.DFMouseHandler:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', 16, -16)
        end
    end
end

function Module.UpdateTrackerState(state)
    if not state then return end
    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    if DF.Era then
        QuestWatchFrame:SetClampedToScreen(false)

        QuestWatchFrame:SetScale(state.scale)
        QuestWatchFrame:ClearAllPoints()
        QuestWatchFrame:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

        -- QuestWatchFrame:SetHeight(800)
        -- QuestWatchFrame:SetWidth(204)    

        QuestTimerFrame:ClearAllPoints()
        -- QuestTimerFrame:SetPoint('TOP', Minimap, 'BOTTOMLEFT', 0, 0)
        QuestTimerFrame:SetPoint('BOTTOMRIGHT', QuestWatchFrame, 'TOPRIGHT', -25, 0)
    elseif DF.Cata then
        if not WatchFrame then return end
        WatchFrame:SetClampedToScreen(false)

        WatchFrame:SetScale(state.scale)
        WatchFrame:ClearAllPoints()
        WatchFrame:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

        WatchFrame:SetHeight(800)
        WatchFrame:SetWidth(204)
    elseif DF.Wrath then
        if not WatchFrame then return end
        WatchFrame:SetClampedToScreen(false)
        WatchFrame:SetScale(state.scale)
        WatchFrame:ClearAllPoints()
        WatchFrame:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
        WatchFrame:SetHeight(800)
        WatchFrame:SetWidth(204)
    end
end

function Module:UpdateLFGState(state)
    local container = Module.LFG
    if not container then return end

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    container:SetIgnoreParentScale(parent == UIParent)
    container:SetParent(parent)

    container:SetScale(state.scale)
    container:ClearAllPoints()
    container:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
end

function Module.LockMinimap(locked)
    if locked then
        -- print('locked')
        Minimap:SetMovable(false)
        Minimap:SetScript('OnDragStart', nil)
        Minimap:SetScript('OnDragStop', nil)

        -- Minimap:EnableMouse(false)
    else
        -- print('not locked')

        Minimap:SetMovable(true)
        -- Minimap:EnableMouse(true)      
        Minimap:RegisterForDrag("LeftButton")
        Minimap:SetScript("OnDragStart", function(self)
            local x, y = Minimap:GetCenter()
            -- print('before', x, y)
            Module.Tmp.MinimapX = x
            Module.Tmp.MinimapY = y

            if IsShiftKeyDown() then self:StartMoving() end
        end)
        Minimap:SetScript("OnDragStop", function(self)
            -- print('OnDragStop')
            self:StopMovingOrSizing()
            -- local point, relativeTo, relativePoint, xOfs, yOfs = Minimap:GetPoint(1)
            -- print(xOfs, yOfs)
            local x, y = Minimap:GetCenter()
            -- print('after', x, y)

            local dx = Module.Tmp.MinimapX - x
            local dy = Module.Tmp.MinimapY - y
            -- print('delta', dx, dy)

            local db = Module.db.profile.minimap

            db.x = db.x - dx
            db.y = db.y - dy
            Module:ApplySettings()
        end)
        Minimap:SetUserPlaced(true)
    end
end

function Module.MoveTracker()
    local setting

    if DF.Era then
        hooksecurefunc(QuestWatchFrame, 'SetPoint', function(self)
            if not setting then
                setting = true
                -- print('WatchFrame SetPoint')
                local state = Module.db.profile.tracker
                Module.UpdateTrackerState(state)
                setting = nil
            end
        end)
    elseif DF.Cata then
        hooksecurefunc(WatchFrame, 'SetPoint', function(self)
            if not setting then
                setting = true
                -- print('WatchFrame SetPoint')
                local state = Module.db.profile.tracker
                Module.UpdateTrackerState(state)
                setting = nil
            end
        end)
    elseif DF.Wrath then
        hooksecurefunc(WatchFrame, 'SetPoint', function(self)
            if not setting then
                setting = true
                -- print('WatchFrame SetPoint')
                local state = Module.db.profile.tracker
                Module.UpdateTrackerState(state)
                setting = nil
            end
        end)
    end
end

function Module.MoveTrackerFunc()
    if WatchFrame then
        WatchFrame:ClearAllPoints()
        local ActionbarModule = DF:GetModule('Actionbar')

        local y = -115

        if ActionbarModule and ActionbarModule:IsEnabled() and ActionbarModule.db.profile.changeSides then
            WatchFrame:SetPoint('TOPRIGHT', MinimapCluster, 'BOTTOMRIGHT', 0, y)
        elseif MultiBarRight:IsShown() and MultiBarLeft:IsShown() then
            WatchFrame:SetPoint('TOPRIGHT', MinimapCluster, 'BOTTOMRIGHT', -100, y)
        elseif MultiBarRight:IsShown() then
            WatchFrame:SetPoint('TOPRIGHT', MinimapCluster, 'BOTTOMRIGHT', -25, y)
        else
            WatchFrame:SetPoint('TOPRIGHT', MinimapCluster, 'BOTTOMRIGHT', 0, y)
        end
        WatchFrame:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', 0, 100)
    end
end

function Module:ChangeLFG()
    local addEditmode = function()
        local EditModeModule = DF:GetModule('Editmode');

        local lfg = Module.LFG
        EditModeModule:AddEditModeToFrame(lfg)

        lfg.DFEditModeSelection:SetGetLabelTextFunction(function()
            return optionsLFG.name
        end)

        lfg.DFEditModeSelection:RegisterOptions({
            options = optionsLFG,
            prio = 5,
            extra = optionsLFGEditmode,
            showFunction = function()
                --
            end,
            hideFunction = function()
                --
                if DF.Wrath then
                    MiniMapLFGFrame_OnEvent(Module.LFG, 'LFG_UPDATE')
                elseif DF.Era then
                    Module.LFG:Show()
                end
            end,
            default = function()
                setDefaultSubValues(optionsLFG.sub)
            end,
            moduleRef = self
        });
    end

    if DF.Wrath then
        Module.LFG = _G['MiniMapLFGFrame']

        -- Module.LFG:SetFrameLevel(10)
        Module.LFG:Raise()

        local LFGEye = CreateFrame('Frame', 'DragonflightUILFGButtonFrame', Module.LFG)
        Mixin(LFGEye, DragonflightUILFGButtonImprovedMixin)
        LFGEye:SetPoint('CENTER', Module.LFG, 'CENTER', 0, 0)
        LFGEye:Init()
        LFGEye:EnableMouse(false)

        Module.LFGEye = LFGEye

        addEditmode()
    elseif DF.Era then
        local loaded, value = C_AddOns.LoadAddOn('Blizzard_GroupFinder_VanillaStyle')
        DF.Compatibility:FuncOrWaitframe('Blizzard_GroupFinder_VanillaStyle', function()
            --
            -- print('~~~~Blizzard_GroupFinder_VanillaStyle')
            Module.LFG = _G['LFGMinimapFrame']
            Module.LFG:Raise()

            local LFGEye = CreateFrame('Frame', 'DragonflightUILFGButtonFrame', Module.LFG)
            Mixin(LFGEye, DragonflightUILFGButtonImprovedMixin)
            LFGEye:SetPoint('CENTER', Module.LFG, 'CENTER', 0, 0)
            LFGEye:Init()
            LFGEye:EnableMouse(false)

            Module.LFGEye = LFGEye

            addEditmode()
        end)
    end
end

function Module:QueueStatusReposition(_, anchorFrame)
    if anchorFrame ~= Module.QueueStatus then
        --
        self:ClearAllPoints()
        self:SetPoint('CENTER', Module.QueueStatus, 'CENTER', 0, 0)
    end
end

function frame:OnEvent(event, arg1, arg2, arg3)
    -- print('event', event)  
end
frame:SetScript('OnEvent', frame.OnEvent)
Module.Frame = frame

function Module:Era()
    Module.MoveTracker()
    Module:ChangeLFG()

    self.SubDurability:Setup()
    self.SubMinimap:Setup()
end

function Module:TBC()
end

function Module:Wrath()
    Module.MoveTracker()
    Module:ChangeLFG()

    self.SubDurability:Setup()
    self.SubMinimap:Setup()
end

function Module:Cata()
    Module:Wrath()
end

function Module:Mists()
    Module:Wrath()
end

