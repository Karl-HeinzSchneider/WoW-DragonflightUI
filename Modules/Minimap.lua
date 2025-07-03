local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Minimap'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')
Module.Tmp = {}

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        scale = 1,
        minimap = {
            scale = 1,
            anchorFrame = 'MinimapCluster',
            customAnchorFrame = '',
            anchor = 'CENTER',
            anchorParent = 'TOP',
            x = -10,
            y = -105,
            locked = true,
            showPing = false,
            showPingChat = false,
            hideCalendar = false,
            hideZoom = false,
            skinButtons = true,
            zonePanelPosition = 'TOP',
            -- Visibility
            showMouseover = false,
            hideAlways = false,
            hideCombat = false,
            hideOutOfCombat = false,
            hidePet = false,
            hideNoPet = false,
            hideStance = false,
            hideStealth = false,
            hideNoStealth = false,
            hideBattlePet = false,
            hideCustom = false,
            hideCustomCond = '',
            useStateHandler = true
        },
        tracker = {
            scale = 1,
            anchorFrame = 'UIParent',
            customAnchorFrame = '',
            anchor = 'TOPRIGHT',
            anchorParent = 'TOPRIGHT',
            x = 0,
            y = -310
        },
        durability = {
            scale = 1,
            anchorFrame = 'Minimap',
            customAnchorFrame = '',
            anchor = 'TOP',
            anchorParent = 'BOTTOM',
            x = 0,
            y = -15
        },
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
    {value = 'Minimap', text = 'Minimap', tooltip = 'descr', label = 'label'}
}

local minimapOptions = {
    type = 'group',
    name = L["MinimapName"],
    get = getOption,
    set = setOption,
    args = {
        headerStyling = {
            type = 'header',
            name = L["MinimapStyle"],
            desc = '',
            order = 20,
            isExpanded = true,
            editmode = true
        },
        zonePanelPosition = {
            type = 'select',
            name = L["MinimapZonePanelPosition"],
            desc = L["MinimapZonePanelPositionDesc"] .. getDefaultStr('zonePanelPosition', 'minimap'),
            dropdownValues = DF.Settings.DropdownTopBottomAnchorTable,
            order = 10,
            group = 'headerStyling',
            new = true,
            editmode = true
        },
        showPing = {
            type = 'toggle',
            name = L["MinimapShowPing"],
            desc = L["MinimapNotYetImplemented"] .. getDefaultStr('showPing', 'minimap'),
            group = 'headerStyling',
            order = 11,
            editmode = true
        },
        showPingChat = {
            type = 'toggle',
            name = L["MinimapShowPingInChat"],
            desc = getDefaultStr('showPingChat', 'minimap'),
            group = 'headerStyling',
            order = 12,
            editmode = true
        },
        hideCalendar = {
            type = 'toggle',
            name = L["MinimapHideCalendar"],
            desc = L["MinimapHideCalendarDesc"] .. getDefaultStr('hideCalendar', 'minimap'),
            group = 'headerStyling',
            order = 13,
            new = false,
            editmode = true
        },
        hideZoom = {
            type = 'toggle',
            name = L["MinimapHideZoomButtons"],
            desc = L["MinimapHideZoomDesc"] .. getDefaultStr('hideZoom', 'minimap'),
            group = 'headerStyling',
            order = 14,
            new = false,
            editmode = true
        },
        skinButtons = {
            type = 'toggle',
            name = L["MinimapSkinMinimapButtons"],
            desc = L["MinimapSkinMinimapButtonsDesc"] .. getDefaultStr('skinButtons', 'minimap'),
            group = 'headerStyling',
            order = 15,
            new = false,
            editmode = true
        },
        useStateHandler = {
            type = 'toggle',
            name = L["MinimapUseStateHandler"],
            desc = L["MinimapUseStateHandlerDesc"] .. getDefaultStr('useStateHandler', 'minimap'),
            group = 'headerVis',
            order = 115,
            editmode = true
        }
    }
}

do
    local moreOptions = {
        rotate = {
            type = 'toggle',
            name = ROTATE_MINIMAP,
            desc = OPTION_TOOLTIP_ROTATE_MINIMAP,
            group = 'headerStyling',
            order = 13.1,
            blizzard = true,
            editmode = true
        }
    }

    for k, v in pairs(moreOptions) do minimapOptions.args[k] = v end

    minimapOptions.get = function(info)
        local key = info[1]
        local sub = info[2]

        if sub == 'rotate' then
            return C_CVar.GetCVarBool("rotateMinimap")
        else
            return getOption(info)
        end
    end

    minimapOptions.set = function(info, value)
        local key = info[1]
        local sub = info[2]

        if sub == 'rotate' then
            if value then
                C_CVar.SetCVar("rotateMinimap", 1)
            else
                C_CVar.SetCVar("rotateMinimap", 0)
            end
        else
            setOption(info, value)
        end
    end
end
DF.Settings:AddPositionTable(Module, minimapOptions, 'minimap', 'Minimap', getDefaultStr, frameTable)
-- DragonflightUIStateHandlerMixin:AddStateTable(Module, optionTable, sub, displayName, getDefaultStr)
DragonflightUIStateHandlerMixin:AddStateTable(Module, minimapOptions, 'minimap', 'Minimap', getDefaultStr)
local optionsMinimapEditmode = {
    name = 'Minimap',
    desc = 'Minimapdesc',
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
                local dbTable = Module.db.profile.minimap
                local defaultsTable = defaults.profile.minimap
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'minimap')
            end,
            order = 16,
            editmode = true,
            new = false
        }
    }
}

local trackerOptions = {type = 'group', name = 'Tracker', get = getOption, set = setOption, args = {}}
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

local optionsDurability = {type = 'group', name = 'Durability', get = getOption, set = setOption, args = {}}
DF.Settings:AddPositionTable(Module, optionsDurability, 'durability', 'Durability', getDefaultStr, frameTableTracker)

local optionsDurabilityEditmode = {
    name = 'Durability',
    desc = 'Durability',
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
                local dbTable = Module.db.profile.durability
                local defaultsTable = defaults.profile.durability
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'durability')
            end,
            order = 16,
            editmode = true,
            new = false
        }
    }
}

local optionsLFG = {type = 'group', name = 'LFG', get = getOption, set = setOption, args = {}}
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

    register('minimap', {order = 1, name = 'Minimap', descr = 'Minimapss', isNew = false})
    register('questtracker', {order = 1, name = 'Quest Tracker', descr = 'Trackers', isNew = false})
    register('durability', {order = 1, name = 'Durability', descr = 'Durablityss', isNew = false})
    register('lfg', {order = 1, name = 'LFG', descr = 'LFGss', isNew = false})
end

function Module:RegisterOptionScreens()
    DF.ConfigModule:RegisterSettingsData('minimap', 'misc', {
        name = 'Minimap',
        sub = 'minimap',
        options = minimapOptions,
        default = function()
            setDefaultSubValues('minimap')
        end
    })

    DF.ConfigModule:RegisterSettingsData('questtracker', 'misc', {
        name = 'Questtracker',
        sub = 'tracker',
        options = trackerOptions,
        default = function()
            setDefaultSubValues('tracker')
        end
    })

    DF.ConfigModule:RegisterSettingsData('durability', 'misc', {
        name = 'Durability',
        sub = 'durability',
        options = optionsDurability,
        default = function()
            setDefaultSubValues('durability')
        end
    })

    DF.ConfigModule:RegisterSettingsData('lfg', 'misc', {
        name = 'LFG',
        sub = 'lfg',
        options = optionsLFG,
        default = function()
            setDefaultSubValues('lfg')
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

    -- Minimap.DFEditModeSelection.SelectionOptions:CallRefresh()
    Minimap.DFEditModeSelection:RefreshOptionScreen();
    Module.TrackerFrameRef.DFEditModeSelection:RefreshOptionScreen()
    Module.DurabilityContainer.DFEditModeSelection:RefreshOptionScreen()
    Module.LFG.DFEditModeSelection:RefreshOptionScreen()
end

function Module:ApplySettings(sub)
    local db = Module.db.profile

    if db.minimap.useStateHandler and not Module.StateHandlerAdded then
        Module.StateHandlerAdded = true;
        Module.AddStateUpdater()
    end

    Module.UpdateMinimapState(db.minimap)
    Module.UpdateTrackerState(db.tracker)
    Module.UpdateDurabilityState(db.durability)
    if Module.LFG then Module.LFG:UpdateState(db.lfg) end
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

function Module.AddStateUpdater()
    Mixin(Minimap, DragonflightUIStateHandlerMixin)
    Minimap:InitStateHandler()
    -- Minimap:SetHideFrame(frame.CalendarButton, 2)

    Minimap.DFShower:ClearAllPoints()
    Minimap.DFShower:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', -16, 32 + 32)
    Minimap.DFShower:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', 16, -16)

    Minimap.DFMouseHandler:ClearAllPoints()
    Minimap.DFMouseHandler:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', -16, 32)
    Minimap.DFMouseHandler:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', 16, -16)
end

function Module:AddEditMode()
    local EditModeModule = DF:GetModule('Editmode');
    EditModeModule:AddEditModeToFrame(Minimap)

    Minimap.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'Minimap'
    end)

    Minimap.DFEditModeSelection:RegisterOptions({
        name = 'Minimap',
        sub = 'minimap',
        advancedName = 'Minimap',
        options = minimapOptions,
        extra = optionsMinimapEditmode,
        default = function()
            setDefaultSubValues('minimap')
        end,
        moduleRef = self
    });

    Minimap.DFEditModeSelection:ClearAllPoints()
    Minimap.DFEditModeSelection:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', -16, 32)
    Minimap.DFEditModeSelection:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', 16, -16)

    -- QuestTracker
    local trackerFrame = (DF.Era and QuestWatchFrame) or (DF.Wrath and WatchFrame) or (DF.Cata and WatchFrame);
    if trackerFrame then
        Module.TrackerFrameRef = trackerFrame;
        EditModeModule:AddEditModeToFrame(trackerFrame)

        trackerFrame.DFEditModeSelection:SetGetLabelTextFunction(function()
            return 'Questtracker'
        end)

        trackerFrame.DFEditModeSelection:RegisterOptions({
            name = 'Questtracker',
            sub = 'tracker',
            advancedName = 'Tracker',
            options = trackerOptions,
            extra = optionsTrackerEditmode,
            default = function()
                setDefaultSubValues('tracker')
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

    -- durablity
    EditModeModule:AddEditModeToFrame(Module.DurabilityContainer)

    Module.DurabilityContainer.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'Durability'
    end)

    Module.DurabilityContainer.DFEditModeSelection:RegisterOptions({
        name = 'Durability',
        sub = 'durability',
        advancedName = 'Durability',
        options = optionsDurability,
        extra = optionsDurabilityEditmode,
        showFunction = function()
            -- 
        end,
        hideFunction = function()
            -- DurabilityFrame_SetAlerts()
        end,
        default = function()
            setDefaultSubValues('durability')
        end,
        moduleRef = self
    });

    -- TODO: add fake preview
    function Module.DurabilityContainer:SetEditMode()
    end

    -- LFG
    EditModeModule:AddEditModeToFrame(Module.LFG)

    Module.LFG.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'LFG'
    end)

    Module.LFG.DFEditModeSelection:RegisterOptions({
        name = 'LFG',
        sub = 'lfg',
        advancedName = 'LFG',
        options = optionsLFG,
        prio = 5,
        extra = optionsLFGEditmode,
        showFunction = function()
            --
        end,
        hideFunction = function()
            --
        end,
        default = function()
            setDefaultSubValues('lfg')
        end,
        moduleRef = self
    });

end

function Module.UpdateMinimapState(state)
    -- print('state', state.anchor, state.anchorFrame, state.anchorParent, state.x, state.y)
    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    Minimap:ClearAllPoints()
    Minimap:SetClampedToScreen(true)
    Minimap:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

    -- Module.LFG:SetScale(state.scale)
    local dfScale = 1.25
    Minimap:SetScale(state.scale * dfScale)
    -- Module.LockMinimap(state.locked)

    Module:UpdateMinimapZonePanelPosition(state.zonePanelPosition)

    if state.hideCalendar then
        frame.CalendarButton:Hide()
    else
        frame.CalendarButton:Show()
    end

    if state.hideZoom then
        MinimapZoomIn:Hide()
        MinimapZoomOut:Hide()
    else
        MinimapZoomIn:Show()
        MinimapZoomOut:Show()
    end

    if Module.StateHandlerAdded then Minimap:UpdateStateHandler(state) end

    Module:ConditionalOption('skinButtons', 'minimap', 'Skin Minimap Buttons', function()
        Module.ChangeMinimapButtons()
    end)
end

function Module:UpdateMinimapZonePanelPosition(pos)
    if pos ~= 'TOP' and pos ~= 'BOTTOM' then pos = 'TOP' end

    local f = frame.MinimapInfo;
    f:ClearAllPoints()
    MiniMapMailFrame:ClearAllPoints()

    if pos == 'TOP' then
        -- default
        f:SetPoint('CENTER', Minimap, 'TOP', 0, 25)

        if DF.Wrath or DF.Cata then
            MiniMapMailFrame:SetPoint('TOPRIGHT', MiniMapTracking, 'BOTTOMRIGHT', 2, -1)
        else
            MiniMapMailFrame:SetPoint('RIGHT', _G['DragonflightUIMinimapTop'], 'LEFT', 0, 0)
        end

        Minimap.DFShower:ClearAllPoints()
        Minimap.DFShower:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', -16, 32 + 32)
        Minimap.DFShower:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', 16, -16)

        Minimap.DFMouseHandler:ClearAllPoints()
        Minimap.DFMouseHandler:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', -16, 32)
        Minimap.DFMouseHandler:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', 16, -16)
    else
        f:SetPoint('CENTER', Minimap, 'BOTTOM', 0, -25)

        if DF.Wrath or DF.Cata then
            MiniMapMailFrame:SetPoint('BOTTOMRIGHT', MiniMapTracking, 'TOPRIGHT', 2, 1)
        else
            MiniMapMailFrame:SetPoint('RIGHT', _G['DragonflightUIMinimapTop'], 'LEFT', 0, 0)
        end

        Minimap.DFShower:ClearAllPoints()
        Minimap.DFShower:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', -16, 32)
        Minimap.DFShower:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', 16, -16 - 32)

        Minimap.DFMouseHandler:ClearAllPoints()
        Minimap.DFMouseHandler:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', -16, 32)
        Minimap.DFMouseHandler:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', 16, -16)
    end
end

function Module.UpdateTrackerState(state)
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

function Module.HideDefaultStuff()
    _G['MinimapBorder']:Hide()
    _G['MinimapBorderTop']:Hide()

    -- Hide WorldMapButton
    if MiniMapWorldMapButton then
        MiniMapWorldMapButton:Hide()
        hooksecurefunc(MiniMapWorldMapButton, 'Show', function()
            MiniMapWorldMapButton:Hide()
        end)
    end
    -- Hide North Tag
    hooksecurefunc(MinimapNorthTag, 'Show', function()
        MinimapNorthTag:Hide()
    end)
end

function Module.MoveDefaultStuff()
    -- CENTER table: 000001F816E0E7B0 TOP 9 -92
    Minimap:SetPoint('CENTER', MinimapCluster, 'TOP', -10, -105)
    -- Minimap:SetScale(1.25)

    local container = CreateFrame('Frame', 'DragonflightUIDurabilityContainer', UIParent)
    container:SetPoint('CENTER', Minimap, 'CENTER', 0, -142)
    container:SetSize(92, 75)
    Module.DurabilityContainer = container

    local moveDur = function()
        local widthMax = 92
        local width = DurabilityFrame:GetWidth()
        local delta = (widthMax - width) / 2

        DurabilityFrame:SetPoint('TOPRIGHT', container, 'TOPRIGHT', -delta, 0)
        DurabilityFrame:SetParent(container)
    end
    DurabilityFrame:ClearAllPoints()
    moveDur()

    hooksecurefunc(DurabilityFrame, 'SetPoint', function(self, void, rel)
        -- print('DurabilityFrame', 'SetPoint')
        if rel and (rel ~= container) then
            -- print('DurabilityFrame', 'inside')
            moveDur()
        end
    end)
end

function Module.UpdateDurabilityState(state)
    local container = Module.DurabilityContainer

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    container:SetScale(state.scale)
    container:ClearAllPoints()
    container:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
end

function Module.MoveMinimap(x, y)
    Minimap:ClearAllPoints()
    Minimap:SetClampedToScreen(true)
    Minimap:SetPoint('CENTER', MinimapCluster, 'TOP', x, y)
    -- MinimapCluster:ClearAllPoints()
    -- MinimapCluster:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', 0, 0)
    -- MinimapCluster:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', x, y)
end

function Module.ChangeZoom()
    local dx, dy = 5, 90
    MinimapZoomIn:SetScale(0.55)
    MinimapZoomIn:SetPoint('CENTER', Minimap, 'RIGHT', -dx, -dy)
    MinimapZoomIn:SetNormalTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomIn:GetNormalTexture():SetTexCoord(0.001953125, 0.068359375, 0.5390625, 0.572265625)
    -- MinimapZoomIn:SetPushedTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap')
    -- MinimapZoomIn:GetPushedTexture():SetTexCoord(0.001953125, 0.068359375, 0.57421875, 0.607421875)
    MinimapZoomIn:SetPushedTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomIn:GetPushedTexture():SetTexCoord(0.001953125, 0.068359375, 0.5390625, 0.572265625)
    MinimapZoomIn:SetDisabledTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomIn:GetDisabledTexture():SetTexCoord(0.001953125, 0.068359375, 0.5390625, 0.572265625)
    MinimapZoomIn:GetDisabledTexture():SetDesaturated(1)
    MinimapZoomIn:SetHighlightTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomIn:GetHighlightTexture():SetTexCoord(0.001953125, 0.068359375, 0.5390625, 0.572265625)

    MinimapZoomOut:SetScale(0.55)
    MinimapZoomOut:SetPoint('CENTER', Minimap, 'BOTTOM', dy, dx)
    MinimapZoomOut:SetNormalTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomOut:GetNormalTexture():SetTexCoord(0.353515625, 0.419921875, 0.5, 0.533203125)
    MinimapZoomOut:SetPushedTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomOut:GetPushedTexture():SetTexCoord(0.353515625, 0.419921875, 0.5, 0.533203125)
    MinimapZoomOut:SetDisabledTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomOut:GetDisabledTexture():SetTexCoord(0.353515625, 0.419921875, 0.5, 0.533203125)
    MinimapZoomOut:GetDisabledTexture():SetDesaturated(1)
    MinimapZoomOut:SetHighlightTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomOut:GetHighlightTexture():SetTexCoord(0.353515625, 0.419921875, 0.5, 0.533203125)
end

function Module.HookMouseWheel()
    Minimap:SetScript('OnMouseWheel', function(self, delta)
        if (delta == -1) then
            MinimapZoomIn:Enable()
            -- PlaySound(SOUNDKIT.IG_MINIMAP_ZOOM_OUT);
            Minimap:SetZoom(math.max(Minimap:GetZoom() - 1, 0))
            if (Minimap:GetZoom() == 0) then MinimapZoomOut:Disable() end
        elseif (delta == 1) then
            MinimapZoomOut:Enable()
            -- PlaySound(SOUNDKIT.IG_MINIMAP_ZOOM_IN);
            Minimap:SetZoom(math.min(Minimap:GetZoom() + 1, Minimap:GetZoomLevels() - 1))
            if (Minimap:GetZoom() == (Minimap:GetZoomLevels() - 1)) then MinimapZoomIn:Disable() end
        end
    end)
end

function Module.CreateMinimapInfoFrame()
    local f = CreateFrame('Frame', 'DragonflightUIMinimapTop', UIParent)
    f:SetSize(170, 22)
    f:SetScale(0.8)
    f:SetParent(Minimap)
    f:SetPoint('CENTER', Minimap, 'TOP', 0, 25)

    local background = f:CreateTexture('DragonflightUIMinimapTopBackground', 'ARTWORK')
    background:ClearAllPoints()
    background:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\MinimapBorder')
    background:SetSize(170, 38)
    background:SetPoint('LEFT', f, 'LEFT', 0, -8)

    f.Background = background

    frame.MinimapInfo = f
end

function Module.ChangeCalendar()
    GameTimeFrame:ClearAllPoints()
    -- GameTimeFrame:SetPoint('CENTER', MinimapCluster, 'TOPRIGHT', -16, -20)
    GameTimeFrame:SetPoint('LEFT', frame.MinimapInfo, 'RIGHT', 0, -2)

    -- GameTimeFrame:SetParent(MinimapBackdrop)
    GameTimeFrame:SetScale(0.75)

    local texture = 'Interface\\Addons\\DragonflightUI\\Textures\\uicalendar32'
    GameTimeFrame:SetSize(35, 35)
    GameTimeFrame:GetNormalTexture():SetTexture(texture)
    GameTimeFrame:GetNormalTexture():SetTexCoord(0.18359375, 0.265625, 0.00390625, 0.078125)
    GameTimeFrame:GetPushedTexture():SetTexture(texture)
    GameTimeFrame:GetPushedTexture():SetTexCoord(0.00390625, 0.0859375, 0.00390625, 0.078125)
    GameTimeFrame:GetHighlightTexture():SetTexture(texture)
    GameTimeFrame:GetHighlightTexture():SetTexCoord(0.09375, 0.17578125, 0.00390625, 0.078125)

    GameTimeFrame:Hide()
    -- @TODO: change Font/size/center etc
    -- local fontstring = GameTimeFrame:GetFontString()
    -- print(fontstring[1])
    -- GameTimeFrame:SetNormalFontObject(GameFontHighlightLarge)

    -- local obj = GameTimeFrame:GetNormalFontObject()
    -- obj:SetJustifyH('LEFT')
end

function Module.UpdateCalendar()
    local button = frame.CalendarButton

    if button then
        local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uicalendar'

        local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime()
        local day = currentCalendarTime.monthDay
        -- print('UpdateCalendar', day, GetCoords('UI-HUD-Calendar-' .. day .. '-Up'))
        ---@diagnostic disable-next-line: param-type-mismatch
        frame.CalendarButtonText:SetText(day)

        -- @TODO
        -- button:GetNormalTexture():SetTexCoord(GetCoords('UI-HUD-Calendar-' .. day .. '-Up'))
        -- button:GetHighlightTexture():SetTexCoord(GetCoords('UI-HUD-Calendar-' .. day .. '-Mouseover'))
        -- button:GetPushedTexture():SetTexCoord(GetCoords('UI-HUD-Calendar-' .. day .. '-Down'))

        local fix
    else
        -- print('no Calendarbutton => RIP')
    end
end

function Module.HookCalendar()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uicalendar32'

    local button = CreateFrame('Button', 'DragonflightUICalendarButton', Minimap)
    -- button:SetPoint('CENTER', 0, 75)
    local size = 24
    button:SetSize(size * 1.105, size)
    button:SetScale(0.8)

    -- button:SetParent(Minimap)
    -- local relativeScale = 0.8
    -- workaround, because sometimes the button dissappears when parent = Minimap
    -- hooksecurefunc(Minimap, 'SetScale', function()
    --     -- button:SetScale(Minimap:GetScale() * relativeScale)
    -- end)

    button:SetPoint('LEFT', frame.MinimapInfo, 'RIGHT', -2, -2)

    -- button:ClearAllPoints()
    -- button:SetPoint('LEFT', frame.MinimapInfo, 'RIGHT', -2, -2)

    local text = button:CreateFontString('DragonflightUICalendarButtonText', 'ARTWORK', 'GameFontBlack')
    text:SetText('12')
    text:SetPoint('CENTER', -2, 1)

    button:SetScript('OnClick', function()
        if DF.Wrath then
            ToggleCalendar()
        elseif DF.Era then
            Module:Print(
                "Era doesn't have an ingame Calendar, sorry. Consider using 'Classic Calendar' by 'Toxiix', and this button will magically work...")
        end
    end)

    button:SetNormalTexture(base)
    button:SetPushedTexture(base)
    button:SetHighlightTexture(base)
    button:GetNormalTexture():SetTexCoord(Module.GetCoords('UI-HUD-Calendar-1-Up'))
    button:GetHighlightTexture():SetTexCoord(Module.GetCoords('UI-HUD-Calendar-1-Mouseover'))
    button:GetPushedTexture():SetTexCoord(Module.GetCoords('UI-HUD-Calendar-1-Down'))

    frame.CalendarButton = button
    frame.CalendarButtonText = text

    hooksecurefunc(TimeManagerClockTicker, 'SetText', function()
        Module.UpdateCalendar()
    end)

    if DF.Cata then
        -- GameTimeCalendarInvitesTexture + Glow
        GameTimeCalendarInvitesTexture:ClearAllPoints()
        GameTimeCalendarInvitesTexture:SetParent(button)
        GameTimeCalendarInvitesTexture:SetPoint('CENTER', text, 'CENTER', 0, 0)
        GameTimeCalendarInvitesTexture:SetSize(size, size)
        GameTimeCalendarInvitesTexture:SetScale(1)
        GameTimeCalendarInvitesTexture:SetDrawLayer('OVERLAY', 2)

        local glowSize = size + 10
        GameTimeCalendarInvitesGlow:ClearAllPoints()
        GameTimeCalendarInvitesGlow:SetParent(button)
        GameTimeCalendarInvitesGlow:SetPoint('CENTER', text, 'CENTER', 0, 0)
        GameTimeCalendarInvitesGlow:SetSize(glowSize, glowSize)
        GameTimeCalendarInvitesGlow:SetScale(1)
        GameTimeCalendarInvitesGlow:SetDrawLayer('OVERLAY', 1)

        local PI = PI;
        local TWOPI = PI * 2.0;
        local cos = math.cos;
        local INVITE_PULSE_SEC = 1.0 / (2.0 * 1.0); -- mul by 2 so the pulse constant counts for half a flash

        Module.minimapFlashTimer = 0.0

        Minimap:HookScript('OnUpdate', function(self, elapsed)
            -- Flashing stuff, from GameTime.lua line 112++
            if (elapsed and GameTimeFrame.flashInvite) then
                local flashIndex = TWOPI * Module.minimapFlashTimer * INVITE_PULSE_SEC;
                local flashValue = max(0.0, 0.5 + 0.5 * cos(flashIndex));
                if (flashIndex >= TWOPI) then
                    Module.minimapFlashTimer = 0.0;
                else
                    Module.minimapFlashTimer = Module.minimapFlashTimer + elapsed;
                end

                GameTimeCalendarInvitesTexture:SetAlpha(flashValue);
                GameTimeCalendarInvitesGlow:SetAlpha(flashValue);
            end
        end)
    end
end

function Module.ChangeClock()
    if DF:IsAddOnLoaded('Blizzard_TimeManager') then
        local regions = {TimeManagerClockButton:GetRegions()}
        regions[1]:Hide()
        TimeManagerClockButton:ClearAllPoints()
        TimeManagerClockButton:SetPoint('RIGHT', frame.MinimapInfo, 'RIGHT', 5, 0)
        TimeManagerClockButton:SetParent(frame.MinimapInfo)

        TimeManagerAlarmFiredTexture:SetPoint("TOPLEFT", TimeManagerClockButton, "TOPLEFT", 0, 5)
        TimeManagerAlarmFiredTexture:SetPoint("BOTTOMRIGHT", TimeManagerClockButton, "BOTTOMRIGHT", -2, -11)

        TimeManagerFrame:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', -10, -190 - 30)
    end
end

function Module.ChangeZoneText()
    MinimapZoneTextButton:ClearAllPoints()
    MinimapZoneTextButton:SetPoint('LEFT', frame.MinimapInfo, 'LEFT', 1, 0)
    MinimapZoneTextButton:SetParent(frame.MinimapInfo)
    MinimapZoneTextButton:SetSize(130, 12)

    MinimapZoneText:ClearAllPoints()
    MinimapZoneText:SetSize(130, 12)
    MinimapZoneText:SetPoint('LEFT', frame.MinimapInfo, 'LEFT', 1, 0)
end

function Module.ChangeTracking()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x'

    MiniMapTracking:ClearAllPoints()
    -- MiniMapTracking:SetPoint('TOPRIGHT', MinimapCluster, 'TOPRIGHT', -200 - 5, 0)
    MiniMapTracking:SetPoint('RIGHT', frame.MinimapInfo, 'LEFT', 0, 0)
    MiniMapTracking:SetScale(0.75)
    MiniMapTracking:SetFrameStrata('MEDIUM')
    MiniMapTrackingIcon:Hide()

    -- MiniMapTrackingBackground:Hide()
    MiniMapTrackingBackground:ClearAllPoints()
    MiniMapTrackingBackground:SetPoint('CENTER', MiniMapTracking, 'CENTER')
    MiniMapTrackingBackground:SetTexture(base)
    MiniMapTrackingBackground:SetTexCoord(0.861328125, 0.9375, 0.392578125, 0.4296875)

    MiniMapTrackingButtonBorder:Hide()

    MiniMapTrackingButton:SetSize(19.5, 19)
    MiniMapTrackingButton:ClearAllPoints()
    MiniMapTrackingButton:SetPoint('CENTER', MiniMapTracking, 'CENTER')

    MiniMapTrackingButton:SetNormalTexture(base)
    MiniMapTrackingButton:GetNormalTexture():SetTexCoord(0.291015625, 0.349609375, 0.5078125, 0.53515625)
    MiniMapTrackingButton:SetHighlightTexture(base)
    MiniMapTrackingButton:GetHighlightTexture():SetTexCoord(0.228515625, 0.287109375, 0.5078125, 0.53515625)
    MiniMapTrackingButton:SetPushedTexture(base)
    MiniMapTrackingButton:GetPushedTexture():SetTexCoord(0.162109375, 0.224609375, 0.5078125, 0.537109375)
end

local MiniMapTrackingFrame = MiniMapTrackingFrame or MiniMapTracking

function Module.ChangeTrackingEra()
    --  MiniMapTrackingFrame:ClearAllPoints()
    -- MiniMapTracking:SetPoint('TOPRIGHT', MinimapCluster, 'TOPRIGHT', -200 - 5, 0)
    -- MiniMapTrackingFrame:SetPoint('RIGHT', frame.MinimapInfo, 'LEFT', 0, 0)
    -- MiniMapTrackingFrame:SetScale(0.75)
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\'

    local updatePos = function()
        MiniMapTrackingFrame:ClearAllPoints()
        -- MiniMapTrackingFrame:SetPoint('RIGHT', frame.MinimapInfo, 'LEFT', 0, -2)
        -- MiniMapTrackingFrame:SetPoint('CENTER', Minimap, 'LEFT', 15, 56)
        MiniMapTrackingFrame:SetPoint('CENTER', Minimap, 'CENTER', -52.56, 53.51)

        MiniMapTrackingFrame:SetParent(Minimap)
    end

    updatePos()
    MiniMapTrackingFrame:SetSize(31, 31)
    MiniMapTrackingFrame:SetFrameStrata('MEDIUM')
    -- MiniMapTrackingFrame:SetScale(0.75)
    -- MiniMapTrackingFrame:SetScale(1.15)

    local bg = MiniMapTrackingFrame:CreateTexture('DragonflightUITrackingFrameBackground', 'BACKGROUND')
    bg:SetSize(24, 24)
    bg:SetTexture(base .. 'ui-minimap-background')
    bg:ClearAllPoints()
    bg:SetPoint("CENTER", MiniMapTrackingFrame, "CENTER")

    MiniMapTrackingBorder:SetSize(50, 50)
    MiniMapTrackingBorder:SetTexture(base .. 'minimap-trackingborder')
    MiniMapTrackingBorder:ClearAllPoints()
    MiniMapTrackingBorder:SetPoint("TOPLEFT", MiniMapTrackingFrame, "TOPLEFT")

    MiniMapTrackingIcon:SetSize(20, 20)
    MiniMapTrackingIcon:ClearAllPoints()
    MiniMapTrackingIcon:SetPoint("CENTER", MiniMapTrackingFrame, "CENTER", 0, 0)

    hooksecurefunc('SetLookingForGroupUIAvailable', function()
        --
        -- print('SetLookingForGroupUIAvailable')
        updatePos()
    end)
end

function Module.UpdateTrackingEra()
    local icon = GetTrackingTexture();
    if (icon) then
        -- MiniMapTrackingIcon:SetTexture(icon);
        SetPortraitToTexture(MiniMapTrackingIcon, icon)
        MiniMapTrackingFrame:Show();
    else
        MiniMapTrackingFrame:Hide();
    end
end

function Module.DrawMinimapBorder()
    local texture = Minimap:CreateTexture('DragonflightUIMinimapBorder', 'ARTWORK')
    texture:SetDrawLayer('ARTWORK', 7)
    texture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    texture:SetTexCoord(0.001953125, 0.857421875, 0.056640625, 0.505859375)
    texture:SetPoint('CENTER', Minimap, 'CENTER', 1, 0)
    local delta = 22
    local dx = 6
    texture:SetSize(140 + delta - dx, 140 + delta)
    -- texture:SetScale(0.88)

    -- MinimapCompassTexture:SetDrawLayer('ARTWORK', 7)
    MinimapCompassTexture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapCompassTexture:SetTexCoord(0.001953125, 0.857421875, 0.056640625, 0.505859375)
    MinimapCompassTexture:SetSize(140 + delta - dx, 140 + delta)
    MinimapCompassTexture:SetScale(1)
    MinimapCompassTexture:ClearAllPoints()
    MinimapCompassTexture:SetPoint('CENTER', Minimap, 'CENTER', 1, 0)

    hooksecurefunc(MinimapCompassTexture, 'Show', function()
        texture:Hide()
    end)

    hooksecurefunc(MinimapCompassTexture, 'Hide', function()
        texture:Show()
    end)

    frame.minimap = texture
end

function Module.ReplaceTextures()
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
    local lfg = CreateFrame('Button', 'DragonflightUILFGButtonFrame', Minimap)
    Mixin(lfg, DragonflightUILFGButtonMixin)
    lfg:Init()
    -- lfg:SetPoint('CENTER', MiniMapLFGFrame, 'CENTER', 0, 0)
    lfg:SetPoint('CENTER', Minimap, 'CENTER', -62.38, -41.63)
    Module.LFG = lfg

    if DF.Cata or DF.Wrath then
        MiniMapLFGFrame:ClearAllPoints()
        -- MiniMapLFGFrame:SetPoint('CENTER', Minimap, 'BOTTOMLEFT', 10, 30)
        MiniMapLFGFrame:SetPoint('CENTER', Minimap, 'CENTER', -62.38, -41.63)
        MiniMapLFGFrameBorder:Hide()
        MiniMapLFGFrameIcon:Hide()

        lfg:HookCata()
    elseif DF.Era then
        DF.Compatibility:FuncOrWaitframe('Blizzard_GroupFinder_VanillaStyle', function()
            --
            Module:ChangeLFGEra();
        end)

    end
end

function Module:ChangeLFGEra()
    local lfg = Module.LFG;

    local btn = _G.LFGMinimapFrame
    btn:SetParent(Minimap)
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\'

    local LFGMinimapFrameBorder = _G['LFGMinimapFrameBorder']
    LFGMinimapFrameBorder:SetTexture(base .. 'minimap-trackingborder')
    LFGMinimapFrameBorder:SetSize(50, 50)

    lfg:HookEra()

    local db = Module.db.profile
    local state = db.lfg
    lfg:UpdateState(state);
end

function Module.ChangeDifficulty()
    MiniMapInstanceDifficulty:ClearAllPoints()
    MiniMapInstanceDifficulty:SetPoint('TOPRIGHT', _G['DragonflightUIMinimapTop'], 'BOTTOMRIGHT', 0, 0)
end

function Module.ChangeMail()
    MiniMapMailBorder:Hide()
    MiniMapMailIcon:Hide()
    -- MiniMapMailFrame:SetPoint('TOPRIGHT', Minimap, 'TOPRIGHT', 24 - 5, -52 + 25)
    MiniMapMailFrame:SetSize(19.5, 15)

    if DF.Wrath or DF.Cata then
        MiniMapMailFrame:SetPoint('TOPRIGHT', MiniMapTracking, 'BOTTOMRIGHT', 2, -1)
    else
        -- MiniMapMailFrame:SetPoint('TOPRIGHT', _G['DragonflightUIMinimapTop'], 'BOTTOMLEFT', 2, -1)
        MiniMapMailFrame:ClearAllPoints()
        MiniMapMailFrame:SetPoint('RIGHT', _G['DragonflightUIMinimapTop'], 'LEFT', 0, 0)
    end

    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x'

    local mail = MiniMapMailFrame:CreateTexture('DragonflightUIMinimapMailFrame', 'ARTWORK')
    mail:ClearAllPoints()
    mail:SetTexture(base)
    mail:SetTexCoord(0.08203125, 0.158203125, 0.5078125, 0.537109375)
    mail:SetSize(19.5, 15)
    mail:SetPoint('CENTER', MiniMapMailFrame, 'CENTER', -3, 0)
    mail:SetScale(1)
end

function Module:QueueStatusReposition(_, anchorFrame)
    if anchorFrame ~= Module.QueueStatus then
        --
        self:ClearAllPoints()
        self:SetPoint('CENTER', Module.QueueStatus, 'CENTER', 0, 0)
    end
end

function Module.ChangeEra()
    GameTimeFrame:Hide()
    MinimapToggleButton:Hide()
end

function Module:UpdateButton(btn)
    if not btn then return end
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\'
    local children = {btn:GetRegions()}

    for i, child in ipairs(children) do
        --            
        if child:GetObjectType() == 'Texture' then
            --
            local tex = child:GetTexture()
            -- print('child=texture', tex)

            if tex == 136477 then
                -- highlight
                child:SetTexture(base .. 'ui-minimap-zoombutton-highlight')
            elseif tex == 136430 then
                -- overlay
                ----"Interface\\Minimap\\MiniMap-TrackingBorder"                  
                child:SetSize(50, 50)
                child:SetTexture(base .. 'minimap-trackingborder')
                child:ClearAllPoints()
                child:SetPoint("TOPLEFT", btn, "TOPLEFT")

                btn.DFTrackingBorder = child
            elseif tex == 136467 then
                -- background
                ----"Interface\\Minimap\\UI-Minimap-Background"
                child:SetSize(24, 24)
                child:SetTexture(base .. 'ui-minimap-background')
                child:ClearAllPoints()
                child:SetPoint("CENTER", btn, "CENTER")
            else
                --
            end
        end
    end
    -- icon
    if btn.icon then
        btn.icon:SetSize(20, 20)
        btn.icon:ClearAllPoints()
        btn.icon:SetPoint("CENTER", btn, "CENTER", 0, 0)

        local tex = btn.icon:GetTexture()

        local updateTex = function()
            SetPortraitToTexture(btn.icon, btn.icon:GetTexture())
        end

        local err = function(s)
            -- print('error!', s)
            btn.icon:SetTexture(tex)
        end

        local status = xpcall(updateTex, err)
        -- SetPortraitToTexture(btn.icon, btn.icon:GetTexture())
    end
end

function Module.ChangeMinimapButtons()
    -- print('Module.ChangeMinimapButtons()')
    local libIcon = LibStub("LibDBIcon-1.0")

    if not libIcon then return end

    hooksecurefunc(libIcon, 'Register', function(self, name, object, db, customCompartmentIcon)
        --
        -- print('register', name, object, db, customCompartmentIcon)
        local btn = libIcon:GetMinimapButton(name)
        if btn then
            --
            Module:UpdateButton(btn)
        end
    end)

    local buttons = libIcon:GetButtonList()
    -- DevTools_Dump(buttons)

    for k, v in ipairs(buttons) do
        -- DevTools_Dump(v) 
        ---@diagnostic disable-next-line: param-type-mismatch
        local btn = libIcon:GetMinimapButton(v)
        -- DevTools_Dump(btn)

        if btn then
            --
            Module:UpdateButton(btn)
        end
    end

    Module:UpdateButton(MiniMapBattlefieldFrame)
end

function Module.HandlePing(unit, y, x)
    -- print('HandlePing', unit, y, x, UnitIsVisible(unit))

    if not UnitIsVisible(unit) then return end

    local unitName = UnitName(unit)

    local state = Module.db.profile.minimap

    if state.showPing then
        --
    end

    if state.showPingChat then
        --
        DF:Print('<Ping>', unitName)
    end
end

function frame:OnEvent(event, arg1, arg2, arg3)
    -- print('event', event) 
    if event == 'MINIMAP_PING' then
        --
        Module.HandlePing(arg1, arg2, arg3)
    elseif event == 'MINIMAP_UPDATE_TRACKING' then
        -- print('MINIMAP_UPDATE_TRACKING', GetTrackingTexture())
        Module.UpdateTrackingEra()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)
Module.Frame = frame

function Module:Era()
    Module.HideDefaultStuff()
    Module.MoveDefaultStuff()
    Module.ChangeZoom()
    Module.CreateMinimapInfoFrame()
    Module.ChangeClock()
    Module.ChangeZoneText()
    Module.ChangeTrackingEra()
    Module.UpdateTrackingEra()
    Module.DrawMinimapBorder()
    Module.MoveTracker()
    Module:ChangeLFG()
    Module.HookMouseWheel()
    Module.ChangeMail()
    -- Module.ChangeMinimapButtons()
    Module.ChangeEra()

    Module.HookCalendar()
    Module.UpdateCalendar()

    -- frame:RegisterEvent('ADDON_LOADED')
    frame:RegisterEvent('MINIMAP_PING')
    frame:RegisterEvent('MINIMAP_UPDATE_TRACKING')
end

function Module:TBC()
end

function Module:Wrath()
    Module.HideDefaultStuff()
    Module.MoveDefaultStuff()
    Module.ChangeZoom()
    Module.CreateMinimapInfoFrame()
    Module.ChangeCalendar()
    Module.ChangeClock()
    Module.ChangeZoneText()
    Module.ChangeTracking()
    Module.DrawMinimapBorder()
    Module.MoveTracker()
    Module:ChangeLFG()
    Module.ChangeDifficulty()
    Module.HookMouseWheel()
    Module.ChangeMail()
    -- Module.ChangeMinimapButtons()

    Module.HookCalendar()
    Module.UpdateCalendar()

    -- frame:RegisterEvent('ADDON_LOADED')
    frame:RegisterEvent('MINIMAP_PING')
end

function Module:Cata()
    Module:Wrath()
end

function Module:Mists()
    Module:Wrath()
end

