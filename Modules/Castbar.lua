local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Castbar'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        player = {
            activate = true,
            scale = 1,
            anchorFrame = 'UIParent',
            customAnchorFrame = '',
            anchor = 'CENTER',
            anchorParent = 'BOTTOM',
            x = 0,
            y = 245,
            sizeX = 256,
            sizeY = 16,
            preci = 1,
            preciMax = 2,
            castTimeEnabled = true,
            castTimeMaxEnabled = true,
            compactLayout = true,
            holdTime = 1.0,
            holdTimeInterrupt = 1.0,
            showIcon = false,
            sizeIcon = 30,
            showTicks = false,
            showRank = true,
            showChannelName = true,
            autoAdjust = false
        },
        target = {
            activate = true,
            scale = 1,
            anchorFrame = 'TargetFrame',
            customAnchorFrame = '',
            anchor = 'TOP',
            anchorParent = 'BOTTOM',
            x = -20,
            y = -20,
            sizeX = 150,
            sizeY = 10,
            preci = 1,
            preciMax = 2,
            castTimeEnabled = true,
            castTimeMaxEnabled = false,
            compactLayout = true,
            holdTime = 1.0,
            holdTimeInterrupt = 1.0,
            showIcon = true,
            sizeIcon = 20,
            showTicks = false,
            showRank = false,
            autoAdjust = true
        },
        focus = {
            activate = true,
            scale = 1,
            anchorFrame = 'FocusFrame',
            customAnchorFrame = '',
            anchor = 'TOP',
            anchorParent = 'BOTTOM',
            x = -20,
            y = -20,
            sizeX = 150,
            sizeY = 10,
            preci = 1,
            preciMax = 2,
            castTimeEnabled = true,
            castTimeMaxEnabled = false,
            compactLayout = true,
            holdTime = 1.0,
            holdTimeInterrupt = 1.0,
            showIcon = true,
            sizeIcon = 20,
            showTicks = false,
            showRank = false,
            autoAdjust = true
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
    Module:SetOption(info, value)
end

local function setPreset(T, preset, sub)
    for k, v in pairs(preset) do
        --
        T[k] = v;
    end
    Module:ApplySettings(sub)
    Module:RefreshOptionScreens()
end

local frameTable = {
    {value = 'UIParent', text = 'UIParent', tooltip = 'descr', label = 'label'},
    {value = 'PlayerFrame', text = 'PlayerFrame', tooltip = 'descr', label = 'label'},
    {value = 'TargetFrame', text = 'TargetFrame', tooltip = 'descr', label = 'label'}
}
if DF.Wrath then
    table.insert(frameTable, {value = 'FocusFrame', text = 'FocusFrame', tooltip = 'descr', label = 'label'})
end

function AddCastbarTable(optionTable, sub)
    local CastbarTable = {
        activate = {
            type = 'toggle',
            name = L["CastbarTableActive"],
            desc = L["CastbarTableActivateDesc"] .. getDefaultStr('activate', sub),
            order = -1,
            new = false,
            editmode = true
        },
        headerStyling = {
            type = 'header',
            name = L["CastbarTableStyle"],
            desc = L["CastbarTableStyleDesc"],
            order = 20,
            isExpanded = true,
            editmode = true
        },
        sizeX = {
            type = 'range',
            name = L["CastbarTableWidth"],
            desc = L["CastbarTableWidthDesc"] .. getDefaultStr('sizeX', sub),
            min = 80,
            max = 512,
            bigStep = 1,
            group = 'headerStyling',
            order = 10,
            editmode = true
        },
        sizeY = {
            type = 'range',
            name = L["CastbarTableHeight"],
            desc = L["CastbarTableHeightDesc"] .. getDefaultStr('sizeY', sub),
            min = 10,
            max = 64,
            bigStep = 1,
            group = 'headerStyling',
            order = 11,
            editmode = true
        },
        preci = {
            type = 'range',
            name = L["CastbarTablePrecisionTimeLeft"],
            desc = L["CastbarTablePrecisionTimeLeftDesc"] .. getDefaultStr('preci', sub),
            min = 0,
            max = 3,
            bigStep = 1,
            group = 'headerStyling',
            order = 12,
            editmode = true
        },
        preciMax = {
            type = 'range',
            name = L["CastbarTablePrecisionTimeMax"],
            desc = L["CastbarTablePrecisionTimeMaxDesc"] .. getDefaultStr('preciMax', sub),
            min = 0,
            max = 3,
            bigStep = 1,
            group = 'headerStyling',
            order = 13,
            editmode = true
        },
        castTimeEnabled = {
            type = 'toggle',
            name = L["CastbarTableShowCastTimeText"],
            desc = L["CastbarTableShowCastTimeTextDesc"] .. getDefaultStr('castTimeEnabled', sub),
            group = 'headerStyling',
            order = 14,
            editmode = true
        },
        castTimeMaxEnabled = {
            type = 'toggle',
            name = L["CastbarTableShowCastTimeMaxText"],
            desc = L["CastbarTableShowCastTimeMaxTextDesc"] .. getDefaultStr('castTimeMaxEnabled', sub),
            group = 'headerStyling',
            order = 15,
            editmode = true
        },
        compactLayout = {
            type = 'toggle',
            name = L["CastbarTableCompactLayout"],
            desc = L["CastbarTableCompactLayoutDesc"] .. getDefaultStr('compactLayout', sub),
            group = 'headerStyling',
            order = 16,
            editmode = true
        },
        holdTime = {
            type = 'range',
            name = L["CastbarTableHoldTimeSuccess"],
            desc = L["CastbarTableHoldTimeSuccessDesc"] .. getDefaultStr('holdTime', sub),
            min = 0,
            max = 2,
            bigStep = 0.05,
            group = 'headerStyling',
            order = 13.1,
            new = false,
            editmode = true
        },
        holdTimeInterrupt = {
            type = 'range',
            name = L["CastbarTableHoldTimeInterrupt"],
            desc = L["CastbarTableHoldTimeInterruptDesc"] .. getDefaultStr('holdTimeInterrupt', sub),
            min = 0,
            max = 2,
            bigStep = 0.05,
            group = 'headerStyling',
            order = 13.2,
            new = false,
            editmode = true
        },
        showIcon = {
            type = 'toggle',
            name = L["CastbarTableShowIcon"],
            desc = L["CastbarTableShowIconDesc"] .. getDefaultStr('showIcon', sub),
            group = 'headerStyling',
            order = 17,
            editmode = true
        },
        sizeIcon = {
            type = 'range',
            name = L["CastbarTableIconSize"],
            desc = L["CastbarTableIconSizeDesc"] .. getDefaultStr('sizeIcon', sub),
            min = 1,
            max = 64,
            bigStep = 1,
            group = 'headerStyling',
            order = 17.1,
            new = false,
            editmode = true
        },
        showTicks = {
            type = 'toggle',
            name = L["CastbarTableShowTicks"],
            desc = L["CastbarTableShowTicksDesc"] .. getDefaultStr('showTicks', sub),
            group = 'headerStyling',
            order = 18,
            editmode = true
        },
        autoAdjust = {
            type = 'toggle',
            name = L["CastbarTableAutoAdjust"],
            desc = L["CastbarTableAutoAdjustDesc"] .. getDefaultStr('autoAdjust', sub),
            group = 'headerStyling',
            order = 22,
            editmode = true
        }
    }

    for k, v in pairs(CastbarTable) do
        --
        optionTable.args[k] = v
    end
end

local optionsPlayer = {type = 'group', name = 'DragonflightUI - ' .. mName, get = getOption, set = setOption, args = {}}
if DF.Era then
    local moreOptions = {
        showRank = {
            type = 'toggle',
            name = L["CastbarTableShowRank"],
            desc = L["CastbarTableShowRankDesc"] .. getDefaultStr('showRank', 'player'),
            group = 'headerStyling',
            order = 20,
            new = false,
            editmode = true
        }
    }

    for k, v in pairs(moreOptions) do optionsPlayer.args[k] = v end
end

do
    optionsPlayer.args['showChannelName'] = {
        type = 'toggle',
        name = L["CastbarTableShowChannelName"],
        desc = L["CastbarTableShowChannelNameDesc"] .. getDefaultStr('showChannelName', 'player'),
        group = 'headerStyling',
        order = 19,
        new = false,
        editmode = true
    }
end

AddCastbarTable(optionsPlayer, 'player')
optionsPlayer.args.autoAdjust = nil;
DF.Settings:AddPositionTable(Module, optionsPlayer, 'player', 'Player', getDefaultStr, frameTable)

local optionsPlayerEditmode = {
    name = 'player',
    desc = 'player',
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
                local dbTable = Module.db.profile.player
                local defaultsTable = defaults.profile.player
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'player')
            end,
            order = 16,
            editmode = true,
            new = false
        },
        resetStyle = {
            type = 'execute',
            name = L["ExtraOptionsPreset"],
            btnName = L["ExtraOptionsResetToDefaultStyle"],
            desc = L["ExtraOptionsPresetStyleDesc"],
            func = function()
                local dbTable = Module.db.profile.player
                local defaultsTable = defaults.profile.player
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    sizeX = defaultsTable.sizeX,
                    sizeY = defaultsTable.sizeY,
                    preci = defaultsTable.preci,
                    preciMax = defaultsTable.preciMax,
                    castTimeEnabled = defaultsTable.castTimeEnabled,
                    castTimeMaxEnabled = defaultsTable.castTimeMaxEnabled,
                    compactLayout = defaultsTable.compactLayout,
                    -- holdTime = defaultsTable.holdTime,
                    -- holdTimeInterrupt = defaultsTable.holdTimeInterrupt,
                    showIcon = defaultsTable.showIcon,
                    sizeIcon = defaultsTable.sizeIcon,
                    showTicks = defaultsTable.showTicks,
                    showRank = defaultsTable.showRank,
                    autoAdjust = defaultsTable.autoAdjust
                }, 'player')
            end,
            order = 17,
            editmode = true,
            new = false
        }
    }
}

local optionsTarget = {type = 'group', name = 'DragonflightUI - ' .. mName, get = getOption, set = setOption, args = {}}
AddCastbarTable(optionsTarget, 'target')
DF.Settings:AddPositionTable(Module, optionsTarget, 'target', 'Target', getDefaultStr, frameTable)

if DF.Era then
    local moreOptions = {
        showRank = {
            type = 'toggle',
            name = 'Show Rank',
            desc = '' .. getDefaultStr('showRank', 'target'),
            order = 20,
            new = false,
            editmode = true
        }
    }

    for k, v in pairs(moreOptions) do optionsTarget.args[k] = v end
end

local optionsTargetEditmode = {
    name = 'target',
    desc = 'target',
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
                local dbTable = Module.db.profile.target
                local defaultsTable = defaults.profile.target
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'target')
                Module.TargetCastbar:SetParent(UIParent)
            end,
            order = 16,
            editmode = true,
            new = false
        },
        resetStyle = {
            type = 'execute',
            name = L["ExtraOptionsPreset"],
            btnName = L["ExtraOptionsResetToDefaultStyle"],
            desc = L["ExtraOptionsPresetStyleDesc"],
            func = function()
                local dbTable = Module.db.profile.target
                local defaultsTable = defaults.profile.target
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    sizeX = defaultsTable.sizeX,
                    sizeY = defaultsTable.sizeY,
                    preci = defaultsTable.preci,
                    preciMax = defaultsTable.preciMax,
                    castTimeEnabled = defaultsTable.castTimeEnabled,
                    castTimeMaxEnabled = defaultsTable.castTimeMaxEnabled,
                    compactLayout = defaultsTable.compactLayout,
                    -- holdTime = defaultsTable.holdTime,
                    -- holdTimeInterrupt = defaultsTable.holdTimeInterrupt,
                    showIcon = defaultsTable.showIcon,
                    sizeIcon = defaultsTable.sizeIcon,
                    showTicks = defaultsTable.showTicks,
                    showRank = defaultsTable.showRank,
                    autoAdjust = defaultsTable.autoAdjust
                }, 'target')
                Module.TargetCastbar:SetParent(UIParent)
            end,
            order = 17,
            editmode = true,
            new = false
        }
    }
}

local optionsFocus = {type = 'group', name = 'DragonflightUI - ' .. mName, get = getOption, set = setOption, args = {}}
AddCastbarTable(optionsFocus, 'focus')
DF.Settings:AddPositionTable(Module, optionsFocus, 'focus', 'Focus', getDefaultStr, frameTable)

local optionsFocusEditmode = {
    name = 'focus',
    desc = 'focus',
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
                local dbTable = Module.db.profile.focus
                local defaultsTable = defaults.profile.focus
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'focus')
                Module.FocusCastbar:SetParent(UIParent)
            end,
            order = 16,
            editmode = true,
            new = false
        },
        resetStyle = {
            type = 'execute',
            name = L["ExtraOptionsPreset"],
            btnName = L["ExtraOptionsResetToDefaultStyle"],
            desc = L["ExtraOptionsPresetStyleDesc"],
            func = function()
                local dbTable = Module.db.profile.focus
                local defaultsTable = defaults.profile.focus
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    sizeX = defaultsTable.sizeX,
                    sizeY = defaultsTable.sizeY,
                    preci = defaultsTable.preci,
                    preciMax = defaultsTable.preciMax,
                    castTimeEnabled = defaultsTable.castTimeEnabled,
                    castTimeMaxEnabled = defaultsTable.castTimeMaxEnabled,
                    compactLayout = defaultsTable.compactLayout,
                    -- holdTime = defaultsTable.holdTime,
                    -- holdTimeInterrupt = defaultsTable.holdTimeInterrupt,
                    showIcon = defaultsTable.showIcon,
                    sizeIcon = defaultsTable.sizeIcon,
                    showTicks = defaultsTable.showTicks,
                    showRank = defaultsTable.showRank,
                    autoAdjust = defaultsTable.autoAdjust
                }, 'focus')
                Module.FocusCastbar:SetParent(UIParent)
            end,
            order = 17,
            editmode = true,
            new = false
        }
    }
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

    Module:AddEditMode()

    Module:RegisterOptionScreens()
    Module:ApplySettings()

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)
        Module:ApplySettings()
        Module:RefreshOptionScreens()
    end)
end

function Module:OnDisable()
end

function Module:RegisterSettings()
    local moduleName = 'Castbar'
    local cat = 'castbar'
    local function register(name, data)
        data.module = moduleName;
        DF.ConfigModule:RegisterSettingsElement(name, cat, data, true)
    end

    register('player', {
        order = 1,
        name = 'Player',
        descr = 'Player Cast Bar',
        isNew = false
        --
        -- sub = 'player',
        -- options = optionsPlayer,
        -- default = function()
        --     setDefaultSubValues('player')
        -- end
    })

    register('target', {order = 2, name = 'Target', descr = 'Target Cast Bar', isNew = false})

    if DF.Wrath then register('focus', {order = 3, name = 'Focus', descr = 'Focus Cast Bar', isNew = false}) end
end

function Module:RegisterOptionScreens()
    DF.ConfigModule:RegisterSettingsData('player', 'castbar', {
        name = 'Player',
        sub = 'player',
        options = optionsPlayer,
        default = function()
            setDefaultSubValues('player')
        end
    })

    DF.ConfigModule:RegisterSettingsData('target', 'castbar', {
        name = 'Target',
        sub = 'target',
        options = optionsTarget,
        default = function()
            setDefaultSubValues('target')
        end
    })

    if DF.Wrath then
        DF.ConfigModule:RegisterSettingsData('focus', 'castbar', {
            name = 'Focus',
            sub = 'focus',
            options = optionsFocus,
            default = function()
                setDefaultSubValues('focus')
            end
        })
    end
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame

    local refreshCat = function(name)
        configFrame:RefreshCatSub('Castbar', name)
    end

    refreshCat('Player')
    refreshCat('Target')

    Module.PlayerCastbar.DFEditModeSelection:RefreshOptionScreen();
    Module.TargetCastbar.DFEditModeSelection:RefreshOptionScreen();

    if DF.Wrath then
        refreshCat('Focus')
        Module.FocusCastbar.DFEditModeSelection:RefreshOptionScreen();
    end
end

function Module:AddEditMode()
    local EditModeModule = DF:GetModule('Editmode');
    EditModeModule:AddEditModeToFrame(Module.PlayerCastbar)
    Module.PlayerCastbar.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'PlayerCastbar'
    end)
    Module.PlayerCastbar.DFEditModeSelection:RegisterOptions({
        name = 'PlayerCastbar',
        sub = 'player',
        advancedName = 'Castbars',
        options = optionsPlayer,
        extra = optionsPlayerEditmode,
        default = function()
            setDefaultSubValues('player')
        end,
        moduleRef = self
    });

    Module.PlayerCastbar.DFEditModeSelection:ClearAllPoints()
    Module.PlayerCastbar.DFEditModeSelection:SetPoint('TOPLEFT', Module.PlayerCastbar, 'TOPLEFT', -4, 4)
    Module.PlayerCastbar.DFEditModeSelection:SetPoint('BOTTOMRIGHT', Module.PlayerCastbar, 'BOTTOMRIGHT', 4, -16)

    EditModeModule:AddEditModeToFrame(Module.TargetCastbar)
    Module.TargetCastbar.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'TargetCastbar'
    end)
    Module.TargetCastbar.DFEditModeSelection:RegisterOptions({
        name = 'TargetCastbar',
        sub = 'target',
        advancedName = 'Castbars',
        options = optionsTarget,
        extra = optionsTargetEditmode,
        default = function()
            setDefaultSubValues('target')
        end,
        moduleRef = self,
        showFunction = function()
            Module.TargetCastbar:SetParent(UIParent)
        end
    });

    Module.TargetCastbar.DFEditModeSelection:ClearAllPoints()
    Module.TargetCastbar.DFEditModeSelection:SetPoint('TOPLEFT', Module.TargetCastbar, 'TOPLEFT', -4, 4)
    Module.TargetCastbar.DFEditModeSelection:SetPoint('BOTTOMRIGHT', Module.TargetCastbar, 'BOTTOMRIGHT', 4, -16)

    if DF.Wrath then
        EditModeModule:AddEditModeToFrame(Module.FocusCastbar)
        Module.FocusCastbar.DFEditModeSelection:SetGetLabelTextFunction(function()
            return 'FocusCastbar'
        end)
        Module.FocusCastbar.DFEditModeSelection:RegisterOptions({
            name = 'FocusCastbar',
            sub = 'focus',
            advancedName = 'Castbars',
            options = optionsFocus,
            extra = optionsFocusEditmode,
            default = function()
                setDefaultSubValues('focus')
            end,
            moduleRef = self,
            showFunction = function()
                Module.FocusCastbar:SetParent(UIParent)
            end
        });

        Module.FocusCastbar.DFEditModeSelection:ClearAllPoints()
        Module.FocusCastbar.DFEditModeSelection:SetPoint('TOPLEFT', Module.FocusCastbar, 'TOPLEFT', -4, 4)
        Module.FocusCastbar.DFEditModeSelection:SetPoint('BOTTOMRIGHT', Module.FocusCastbar, 'BOTTOMRIGHT', 4, -16)
    end
end

function Module:ApplySettings(sub)
    local db = Module.db.profile

    if not sub or sub == 'ALL' then
        Module.PlayerCastbar:UpdateState(db.player)
        Module.TargetCastbar:UpdateState(db.target)

        if DF.Wrath then Module.FocusCastbar:UpdateState(db.focus) end
    elseif sub == 'player' then
        Module.PlayerCastbar:UpdateState(db.player)
    elseif sub == 'target' then
        Module.TargetCastbar:UpdateState(db.target)
    elseif sub == 'focus' then
        Module.FocusCastbar:UpdateState(db.focus)
    end
end

local frame = CreateFrame('FRAME', 'DragonflightUICastbarFrame', UIParent)
Module.frame = frame

function Module.ChangeDefaultCastbar()
    CastingBarFrame:UnregisterAllEvents()
    CastingBarFrame:Hide()

    TargetFrameSpellBar:UnregisterAllEvents()
    TargetFrameSpellBar:Hide()

    if DF.Wrath then
        FocusFrameSpellBar:UnregisterAllEvents()
        FocusFrameSpellBar:Hide()
    end
end

Module.ChannelTicks = DF.Cata and {
    -- wl
    [GetSpellInfo(5740)] = 4, -- rain of fire
    -- [GetSpellInfo(5138)] = 5, -- drain mana
    [GetSpellInfo(689)] = 5, -- drain life
    [GetSpellInfo(1120)] = 5, -- drain soul
    [GetSpellInfo(755)] = 10, -- health funnel
    [GetSpellInfo(1949)] = 15, -- hellfire
    -- priest
    [GetSpellInfo(47540)] = 2, -- penance
    [GetSpellInfo(15407)] = 3, -- mind flay
    [GetSpellInfo(64843)] = 4, -- divine hymn
    [GetSpellInfo(64901)] = 4, -- hymn of hope
    [GetSpellInfo(48045)] = 5, -- mind sear
    -- hunter
    -- [GetSpellInfo(1510)] = 6, -- volley
    -- druid
    [GetSpellInfo(740)] = 4, -- tranquility
    [GetSpellInfo(16914)] = 10, -- hurricane
    -- mage
    [5143] = 3, -- arcane missiles rank 1
    [5144] = 4, -- arcane missiles rank 2
    -- [GetSpellInfo(5145)] = 5, -- arcane missiles
    [GetSpellInfo(10)] = 8 -- blizzard
} or DF.Wrath and {
    -- wl
    [GetSpellInfo(5740)] = 4, -- rain of fire
    [GetSpellInfo(5138)] = 5, -- drain mana
    [GetSpellInfo(689)] = 5, -- drain life
    [GetSpellInfo(1120)] = 5, -- drain soul
    [GetSpellInfo(755)] = 10, -- health funnel
    [GetSpellInfo(1949)] = 15, -- hellfire
    -- priest
    [GetSpellInfo(47540)] = 2, -- penance
    [GetSpellInfo(15407)] = 3, -- mind flay
    [GetSpellInfo(64843)] = 4, -- divine hymn
    [GetSpellInfo(64901)] = 4, -- hymn of hope
    [GetSpellInfo(48045)] = 5, -- mind sear
    -- hunter
    [GetSpellInfo(1510)] = 6, -- volley
    -- druid
    [GetSpellInfo(740)] = 4, -- tranquility
    [GetSpellInfo(16914)] = 10, -- hurricane
    -- mage
    [5143] = 3, -- arcane missiles rank 1
    [5144] = 4, -- arcane missiles rank 2
    [GetSpellInfo(5145)] = 5, -- arcane missiles
    [GetSpellInfo(10)] = 8 -- blizzard
} or DF.Era and {
    -- wl
    [GetSpellInfo(5740)] = 4, -- rain of fire
    [GetSpellInfo(5138)] = 5, -- drain mana
    [GetSpellInfo(689)] = 5, -- drain life
    [GetSpellInfo(1120)] = 5, -- drain soul
    [GetSpellInfo(755)] = 10, -- health funnel
    [GetSpellInfo(1949)] = 15, -- hellfire
    -- priest
    [GetSpellInfo(15407)] = 3, -- mind flay
    [GetSpellInfo(402174)] = 2, -- penance
    [GetSpellInfo(413259)] = 2, -- mind sear
    -- hunter
    [GetSpellInfo(1510)] = 6, -- volley
    -- druid
    [GetSpellInfo(740)] = 4, -- tranquility
    [GetSpellInfo(16914)] = 10, -- hurricane
    -- mage
    [5143] = 3, -- arcane missiles rank 1
    [5144] = 4, -- arcane missiles rank 2
    [GetSpellInfo(5145)] = 5, -- arcane missiles
    [GetSpellInfo(10)] = 8, -- blizzard,
    [GetSpellInfo(401417)] = 3, -- regeneration
    [GetSpellInfo(412510)] = 3 -- mass regeneration
}

function Module.AddNewCastbar()
    local castbar = CreateFrame('StatusBar', 'DragonflightUIPlayerCastbar', UIParent,
                                'DragonflightUIPlayerCastbarTemplate')
    castbar:AddTickTable(Module.ChannelTicks)
    Module.PlayerCastbar = castbar

    local target = CreateFrame('StatusBar', 'DragonflightUITargetCastbar', UIParent,
                               'DragonflightUITargetCastbarTemplate')
    TargetFrameSpellBar.DFCastbar = target
    Module.TargetCastbar = target

    if DF.Wrath then
        local focus = CreateFrame('StatusBar', 'DragonflightUIFocusCastbar', UIParent,
                                  'DragonflightUIFocusCastbarTemplate')
        FocusFrameSpellBar.DFCastbar = focus
        Module.FocusCastbar = focus
    end

    hooksecurefunc('Target_Spellbar_AdjustPosition', function(self)
        -- print('Target_Spellbar_AdjustPosition', self:GetName())
        if self.DFCastbar then self.DFCastbar:AdjustPosition() end
    end)
end

function Module:FixScale()
    -- print('Module:FixScale()')
    local t = {'PlayerCastbar', 'TargetCastbar', 'FocusCastbar'}
    for k, v in ipairs(t) do if Module[v] then Module[v]:FixScale() end end
end

function frame:OnEvent(event, arg1)
    -- print('event', event, arg1)
    if event == 'UI_SCALE_CHANGED' then Module:FixScale() end
end
frame:SetScript('OnEvent', frame.OnEvent)
frame:RegisterEvent('UI_SCALE_CHANGED')

function Module:Era()
    Module:Wrath()
end

function Module:TBC()
end

function Module:Wrath()
    Module.ChangeDefaultCastbar()
    Module.AddNewCastbar()
end

function Module:Cata()
    Module:Wrath()
end

function Module:Mists()
    Module:Wrath()
end
