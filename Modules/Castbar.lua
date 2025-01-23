local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Castbar'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        player = {
            scale = 1,
            anchorFrame = 'UIParent',
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
            autoAdjust = false
        },
        target = {
            scale = 1,
            anchorFrame = 'TargetFrame',
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
            scale = 1,
            anchorFrame = 'FocusFrame',
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

local presetDesc =
    'Sets Scale, Anchor, AnchorParent, AnchorFrame, X and Y to that of the chosen preset, but does not change any other setting.';
local presetStyleDesc = 'Sets all settings that change the style of the castbar, but does not change any other setting.';

local function setPreset(T, preset, sub)
    for k, v in pairs(preset) do
        --
        T[k] = v;
    end
    Module:ApplySettings(sub)
    Module:RefreshOptionScreens()
end

local frameTable = {['UIParent'] = 'UIParent', ['PlayerFrame'] = 'PlayerFrame', ['TargetFrame'] = 'TargetFrame'}
if DF.Wrath then frameTable['FocusFrame'] = 'FocusFrame' end

local optionsPlayer = {
    type = 'group',
    name = 'DragonflightUI - ' .. mName,
    get = getOption,
    set = setOption,
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'player'),
            min = 0.2,
            max = 5,
            bigStep = 0.1,
            order = 1,
            disabled = false,
            editmode = true
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'player'),
            values = frameTable,
            order = 4,
            editmode = true
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'player'),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            order = 2,
            editmode = true
        },
        anchorParent = {
            type = 'select',
            name = 'AnchorParent',
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'player'),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            order = 3,
            editmode = true
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to BOTTOM CENTER' .. getDefaultStr('x', 'player'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5,
            editmode = true
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to BOTTOM CENTER' .. getDefaultStr('y', 'player'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6,
            editmode = true
        },
        sizeX = {
            type = 'range',
            name = 'Width',
            desc = getDefaultStr('sizeX', 'player'),
            min = 80,
            max = 512,
            bigStep = 1,
            order = 10,
            editmode = true
        },
        sizeY = {
            type = 'range',
            name = 'Height',
            desc = getDefaultStr('sizeY', 'player'),
            min = 10,
            max = 64,
            bigStep = 1,
            order = 11,
            editmode = true
        },
        preci = {
            type = 'range',
            name = 'Precision (time left)',
            desc = '...' .. getDefaultStr('preci', 'player'),
            min = 0,
            max = 3,
            bigStep = 1,
            order = 12,
            editmode = true
        },
        preciMax = {
            type = 'range',
            name = 'Precision (time max)',
            desc = '...' .. getDefaultStr('preciMax', 'player'),
            min = 0,
            max = 3,
            bigStep = 1,
            order = 13,
            editmode = true
        },
        castTimeEnabled = {
            type = 'toggle',
            name = 'Show cast time text',
            desc = '' .. getDefaultStr('castTimeEnabled', 'player'),
            order = 14,
            editmode = true
        },
        castTimeMaxEnabled = {
            type = 'toggle',
            name = 'Show cast time max text',
            desc = '' .. getDefaultStr('castTimeMaxEnabled', 'player'),
            order = 15,
            editmode = true
        },
        compactLayout = {
            type = 'toggle',
            name = 'Compact Layout',
            desc = '' .. getDefaultStr('compactLayout', 'player'),
            order = 16,
            editmode = true
        },
        holdTime = {
            type = 'range',
            name = 'Hold Time (Success)',
            desc = 'Time before the Castbar starts fading after the Cast was successful.' ..
                getDefaultStr('holdTime', 'player'),
            min = 0,
            max = 2,
            bigStep = 0.05,
            order = 13.1,
            new = true,
            editmode = true
        },
        holdTimeInterrupt = {
            type = 'range',
            name = 'Hold Time (Interrupt)',
            desc = 'Time before the Castbar starts fading after the Cast was interrupted.' ..
                getDefaultStr('holdTimeInterrupt', 'player'),
            min = 0,
            max = 2,
            bigStep = 0.05,
            order = 13.2,
            new = true,
            editmode = true
        },
        showIcon = {
            type = 'toggle',
            name = 'Show Icon',
            desc = '' .. getDefaultStr('showIcon', 'player'),
            order = 17,
            editmode = true
        },
        sizeIcon = {
            type = 'range',
            name = 'Icon Size',
            desc = getDefaultStr('sizeIcon', 'player'),
            min = 1,
            max = 64,
            bigStep = 1,
            order = 17.1,
            new = true,
            editmode = true
        },
        showTicks = {
            type = 'toggle',
            name = 'Show Ticks',
            desc = '' .. getDefaultStr('showTicks', 'player'),
            order = 18
        }
        -- autoAdjust = {
        --     type = 'toggle',
        --     name = 'Auto Adjust',
        --     desc = 'This applies an Y-offset depending on the amount of buffs/debuffs - useful when anchoring the castbar beneath the PlayerFrame' ..
        --         getDefaultStr('autoAdjust', 'player'),
        --     order = 22
        -- }
    }
}

if DF.Era then
    local moreOptions = {
        showRank = {
            type = 'toggle',
            name = 'Show Rank',
            desc = '' .. getDefaultStr('showRank', 'player'),
            order = 20,
            new = true,
            editmode = true
        }
    }

    for k, v in pairs(moreOptions) do optionsPlayer.args[k] = v end
end

local optionsPlayerEditmode = {
    name = 'player',
    desc = 'player',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        resetPosition = {
            type = 'execute',
            name = 'Preset',
            btnName = 'Reset to Default Position',
            desc = presetDesc,
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
            new = true
        },
        resetStyle = {
            type = 'execute',
            name = 'Preset',
            btnName = 'Reset to Default Style',
            desc = presetStyleDesc,
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
            new = true
        }
    }
}

local optionsTarget = {
    type = 'group',
    name = 'DragonflightUI - ' .. mName,
    get = getOption,
    set = setOption,
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'target'),
            min = 0.2,
            max = 5,
            bigStep = 0.1,
            order = 1,
            disabled = false,
            editmode = true
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'target'),
            values = frameTable,
            order = 4,
            editmode = true
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'target'),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            order = 2,
            editmode = true
        },
        anchorParent = {
            type = 'select',
            name = 'AnchorParent',
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'target'),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            order = 3,
            editmode = true
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to BOTTOM CENTER' .. getDefaultStr('x', 'target'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5,
            editmode = true
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to BOTTOM CENTER' .. getDefaultStr('y', 'target'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6,
            editmode = true
        },
        sizeX = {
            type = 'range',
            name = 'Width',
            desc = getDefaultStr('sizeX', 'target'),
            min = 80,
            max = 512,
            bigStep = 1,
            order = 10,
            editmode = true
        },
        sizeY = {
            type = 'range',
            name = 'Height',
            desc = getDefaultStr('sizeY', 'target'),
            min = 10,
            max = 64,
            bigStep = 1,
            order = 11,
            editmode = true
        },
        preci = {
            type = 'range',
            name = 'Precision (time left)',
            desc = '...' .. getDefaultStr('preci', 'target'),
            min = 0,
            max = 3,
            bigStep = 1,
            order = 12,
            editmode = true
        },
        preciMax = {
            type = 'range',
            name = 'Precision (time max)',
            desc = '...' .. getDefaultStr('preciMax', 'target'),
            min = 0,
            max = 3,
            bigStep = 1,
            order = 13,
            editmode = true
        },
        castTimeEnabled = {
            type = 'toggle',
            name = 'Show cast time text',
            desc = '' .. getDefaultStr('castTimeEnabled', 'target'),
            order = 14,
            editmode = true
        },
        castTimeMaxEnabled = {
            type = 'toggle',
            name = 'Show cast time max text',
            desc = '' .. getDefaultStr('castTimeMaxEnabled', 'target'),
            order = 15,
            editmode = true
        },
        compactLayout = {
            type = 'toggle',
            name = 'Compact Layout',
            desc = '' .. getDefaultStr('compactLayout', 'target'),
            order = 16,
            editmode = true
        },
        holdTime = {
            type = 'range',
            name = 'Hold Time (Success)',
            desc = 'Time before the Castbar starts fading after the Cast was successful.' ..
                getDefaultStr('holdTime', 'target'),
            min = 0,
            max = 2,
            bigStep = 0.05,
            order = 13.1,
            new = true,
            editmode = true
        },
        holdTimeInterrupt = {
            type = 'range',
            name = 'Hold Time (Interrupt)',
            desc = 'Time before the Castbar starts fading after the Cast was interrupted.' ..
                getDefaultStr('holdTimeInterrupt', 'target'),
            min = 0,
            max = 2,
            bigStep = 0.05,
            order = 13.2,
            new = true,
            editmode = true
        },
        showIcon = {
            type = 'toggle',
            name = 'Show Icon',
            desc = '' .. getDefaultStr('showIcon', 'target'),
            order = 17,
            editmode = true
        },
        sizeIcon = {
            type = 'range',
            name = 'Icon Size',
            desc = getDefaultStr('sizeIcon', 'target'),
            min = 1,
            max = 64,
            bigStep = 1,
            order = 17.1,
            new = true,
            editmode = true
        },
        showTicks = {
            type = 'toggle',
            name = 'Show Ticks',
            desc = '' .. getDefaultStr('showTicks', 'target'),
            order = 18,
            editmode = true
        },
        autoAdjust = {
            type = 'toggle',
            name = 'Auto Adjust',
            desc = 'This applies an Y-offset depending on the amount of buffs/debuffs - useful when anchoring the castbar beneath the TargetFrame' ..
                getDefaultStr('autoAdjust', 'target'),
            order = 22,
            editmode = true
        }
    }
}

if DF.Era then
    local moreOptions = {
        showRank = {
            type = 'toggle',
            name = 'Show Rank',
            desc = '' .. getDefaultStr('showRank', 'target'),
            order = 20,
            new = true,
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
            name = 'Preset',
            btnName = 'Reset to Default Position',
            desc = presetDesc,
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
            new = true
        },
        resetStyle = {
            type = 'execute',
            name = 'Preset',
            btnName = 'Reset to Default Style',
            desc = presetStyleDesc,
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
            new = true
        }
    }
}

local optionsFocus = {
    type = 'group',
    name = 'DragonflightUI - ' .. mName,
    get = getOption,
    set = setOption,
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'focus'),
            min = 0.2,
            max = 5,
            bigStep = 0.1,
            order = 1,
            disabled = false,
            editmode = true
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'focus'),
            values = frameTable,
            order = 4,
            editmode = true
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'focus'),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            order = 2,
            editmode = true
        },
        anchorParent = {
            type = 'select',
            name = 'AnchorParent',
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'focus'),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            order = 3,
            editmode = true
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to BOTTOM CENTER' .. getDefaultStr('x', 'focus'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5,
            editmode = true
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to BOTTOM CENTER' .. getDefaultStr('y', 'focus'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6,
            editmode = true
        },
        sizeX = {
            type = 'range',
            name = 'Width',
            desc = getDefaultStr('sizeX', 'focus'),
            min = 80,
            max = 512,
            bigStep = 1,
            order = 10,
            editmode = true
        },
        sizeY = {
            type = 'range',
            name = 'Height',
            desc = getDefaultStr('sizeY', 'focus'),
            min = 10,
            max = 64,
            bigStep = 1,
            order = 11,
            editmode = true
        },
        preci = {
            type = 'range',
            name = 'Precision (time left)',
            desc = '...' .. getDefaultStr('preci', 'focus'),
            min = 0,
            max = 3,
            bigStep = 1,
            order = 12,
            editmode = true
        },
        preciMax = {
            type = 'range',
            name = 'Precision (time max)',
            desc = '...' .. getDefaultStr('preciMax', 'focus'),
            min = 0,
            max = 3,
            bigStep = 1,
            order = 13,
            editmode = true
        },
        castTimeEnabled = {
            type = 'toggle',
            name = 'Show cast time text',
            desc = '' .. getDefaultStr('castTimeEnabled', 'focus'),
            order = 14,
            editmode = true
        },
        castTimeMaxEnabled = {
            type = 'toggle',
            name = 'Show cast time max text',
            desc = '' .. getDefaultStr('castTimeMaxEnabled', 'focus'),
            order = 15,
            editmode = true
        },
        compactLayout = {
            type = 'toggle',
            name = 'Compact Layout',
            desc = '' .. getDefaultStr('compactLayout', 'focus'),
            order = 16,
            editmode = true
        },
        holdTime = {
            type = 'range',
            name = 'Hold Time (Success)',
            desc = 'Time before the Castbar starts fading after the Cast was successful.' ..
                getDefaultStr('holdTime', 'focus'),
            min = 0,
            max = 2,
            bigStep = 0.05,
            order = 13.1,
            new = true,
            editmode = true
        },
        holdTimeInterrupt = {
            type = 'range',
            name = 'Hold Time (Interrupt)',
            desc = 'Time before the Castbar starts fading after the Cast was interrupted.' ..
                getDefaultStr('holdTimeInterrupt', 'focus'),
            min = 0,
            max = 2,
            bigStep = 0.05,
            order = 13.2,
            new = true,
            editmode = true
        },
        showIcon = {
            type = 'toggle',
            name = 'Show Icon',
            desc = '' .. getDefaultStr('showIcon', 'focus'),
            order = 17,
            editmode = true
        },
        sizeIcon = {
            type = 'range',
            name = 'Icon Size',
            desc = getDefaultStr('sizeIcon', 'focus'),
            min = 1,
            max = 64,
            bigStep = 1,
            order = 17.1,
            new = true,
            editmode = true
        },
        showTicks = {
            type = 'toggle',
            name = 'Show Ticks',
            desc = '' .. getDefaultStr('showTicks', 'focus'),
            order = 18,
            editmode = true
        },
        autoAdjust = {
            type = 'toggle',
            name = 'Auto Adjust',
            desc = 'This applies an Y-offset depending on the amount of buffs/debuffs - useful when anchoring the castbar beneath the FocusFrame' ..
                getDefaultStr('autoAdjust', 'focus'),
            order = 22,
            editmode = true
        }
    }
}

local optionsFocusEditmode = {
    name = 'focus',
    desc = 'focus',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        resetPosition = {
            type = 'execute',
            name = 'Preset',
            btnName = 'Reset to Default Position',
            desc = presetDesc,
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
            new = true
        },
        resetStyle = {
            type = 'execute',
            name = 'Preset',
            btnName = 'Reset to Default Style',
            desc = presetStyleDesc,
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
            new = true
        }
    }
}

local options = {
    type = 'group',
    name = 'DragonflightUI - ' .. mName,
    get = getOption,
    set = setOption,
    args = {
        toggle = {
            type = 'toggle',
            name = 'Enable',
            get = function()
                return DF:GetModuleEnabled(mName)
            end,
            set = function(info, v)
                DF:SetModuleEnabled(mName, v)
            end,
            order = 1
        },
        reload = {
            type = 'execute',
            name = '/reload',
            desc = 'reloads UI',
            func = function()
                ReloadUI()
            end,
            order = 1.1
        },
        defaults = {
            type = 'execute',
            name = 'Defaults',
            desc = 'Sets Config to default values',
            func = setDefaultValues,
            order = 1.1
        },
        focus = optionsFocus,
        player = optionsPlayer,
        target = optionsTarget
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

    DF:RegisterModuleOptions(mName, options)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    if DF.Wrath then
        Module.Wrath()
    else
        Module.Era()
    end
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
    DF.ConfigModule:RegisterOptionScreen('Castbar', 'Player', {
        name = 'Player',
        sub = 'player',
        options = optionsPlayer,
        default = function()
            setDefaultSubValues('player')
        end
    })

    DF.ConfigModule:RegisterOptionScreen('Castbar', 'Target', {
        name = 'Target',
        sub = 'target',
        options = optionsTarget,
        default = function()
            setDefaultSubValues('target')
        end
    })

    if DF.Wrath then
        DF.ConfigModule:RegisterOptionScreen('Castbar', 'Focus', {
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

function frame:OnEvent(event, arg1)
    -- print('event', event, arg1) 
end
frame:SetScript('OnEvent', frame.OnEvent)

-- Wrath
function Module.Wrath()
    Module.ChangeDefaultCastbar()
    Module.AddNewCastbar()
end

-- Era
function Module.Era()
    Module.Wrath()
end
