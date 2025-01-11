---@diagnostic disable: undefined-global
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Actionbar'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

local noop = function()
end

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        scale = 1,
        x = 0,
        y = 0,
        showGryphon = true,
        changeSides = true,
        sideRows = 3,
        sideButtons = 12,
        bagsExpanded = true,
        alwaysShowXP = false,
        alwaysShowRep = false,
        bar1 = {
            scale = 1,
            anchorFrame = 'DragonflightUIRepBar',
            anchor = 'BOTTOM',
            anchorParent = 'TOP',
            x = 0,
            y = 10,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 12,
            padding = 2,
            -- Style
            alwaysShow = true,
            hideArt = false,
            hideScrolling = false,
            gryphons = 'DEFAULT',
            range = true,
            hideMacro = false,
            macroFontSize = 14,
            hideKeybind = false,
            keybindFontSize = 16,
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
            hideCustom = false,
            hideCustomCond = ''
        },
        bar2 = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame1',
            anchor = 'BOTTOM',
            anchorParent = 'TOP',
            x = 0,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 12,
            padding = 2,
            -- Style
            alwaysShow = true,
            activate = true,
            hideMacro = false,
            macroFontSize = 14,
            hideKeybind = false,
            keybindFontSize = 16,
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
            hideCustom = false,
            hideCustomCond = ''
        },
        bar3 = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame2',
            anchor = 'BOTTOM',
            anchorParent = 'TOP',
            x = 0,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 12,
            padding = 2,
            -- Style
            alwaysShow = true,
            activate = true,
            hideMacro = false,
            macroFontSize = 14,
            hideKeybind = false,
            keybindFontSize = 16,
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
            hideCustom = false,
            hideCustomCond = ''
        },
        bar4 = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame2',
            anchor = 'RIGHT',
            anchorParent = 'LEFT',
            x = -64,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 3,
            buttons = 12,
            padding = 2,
            -- Style
            alwaysShow = true,
            activate = true,
            hideMacro = false,
            macroFontSize = 14,
            hideKeybind = false,
            keybindFontSize = 16,
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
            hideCustom = false,
            hideCustomCond = ''
        },
        bar5 = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame2',
            anchor = 'LEFT',
            anchorParent = 'RIGHT',
            x = 64,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 3,
            buttons = 12,
            padding = 2,
            -- Style
            alwaysShow = true,
            activate = true,
            hideMacro = false,
            macroFontSize = 14,
            hideKeybind = false,
            keybindFontSize = 16,
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
            hideCustom = false,
            hideCustomCond = ''
        },
        bar6 = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame3',
            anchor = 'BOTTOM',
            anchorParent = 'TOP',
            x = 0,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 12,
            padding = 2,
            -- Style
            alwaysShow = true,
            activate = false,
            hideMacro = false,
            macroFontSize = 14,
            hideKeybind = false,
            keybindFontSize = 16,
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
            hideCustom = false,
            hideCustomCond = ''
        },
        bar7 = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame6',
            anchor = 'BOTTOM',
            anchorParent = 'TOP',
            x = 0,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 12,
            padding = 2,
            -- Style
            alwaysShow = true,
            activate = false,
            hideMacro = false,
            macroFontSize = 14,
            hideKeybind = false,
            keybindFontSize = 16,
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
            hideCustom = false,
            hideCustomCond = ''
        },
        bar8 = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame7',
            anchor = 'BOTTOM',
            anchorParent = 'TOP',
            x = 0,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 12,
            padding = 2,
            -- Style
            alwaysShow = true,
            activate = false,
            hideMacro = false,
            macroFontSize = 14,
            hideKeybind = false,
            keybindFontSize = 16,
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
            hideCustom = false,
            hideCustomCond = ''
        },
        pet = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame3',
            anchor = 'BOTTOMLEFT',
            anchorParent = 'TOPLEFT',
            x = 0,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 10,
            padding = 2,
            -- Style
            alwaysShow = true,
            hideMacro = false,
            macroFontSize = 14,
            hideKeybind = false,
            keybindFontSize = 16,
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
            hideCustom = false,
            hideCustomCond = ''
        },
        xp = {
            scale = 1,
            anchorFrame = 'UIParent',
            anchor = 'BOTTOM',
            anchorParent = 'BOTTOM',
            x = 0,
            y = 5,
            width = 466,
            height = 20,
            alwaysShowXP = false,
            showXPPercent = true,
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
            hideCustom = false,
            hideCustomCond = ''
        },
        rep = {
            scale = 1,
            anchorFrame = 'DragonflightUIXPBar',
            anchor = 'BOTTOM',
            anchorParent = 'TOP',
            x = 0,
            y = 0,
            width = 466,
            height = 20,
            alwaysShowRep = false,
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
            hideCustom = false,
            hideCustomCond = ''
        },
        stance = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame3',
            anchor = 'BOTTOMLEFT',
            anchorParent = 'TOPLEFT',
            x = 0,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 10,
            padding = 2,
            -- Style
            alwaysShow = false,
            activate = true,
            hideMacro = false,
            macroFontSize = 14,
            hideKeybind = false,
            keybindFontSize = 16,
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
            hideCustom = false,
            hideCustomCond = ''
        },
        totem = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame3',
            anchor = 'BOTTOM',
            anchorParent = 'TOP',
            x = 0,
            y = 2,
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
            hideCustom = false,
            hideCustomCond = ''
        },
        possess = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame3',
            anchor = 'BOTTOMLEFT',
            anchorParent = 'TOPLEFT',
            x = -4,
            y = 2,
            offset = false,
            -- Visibility
            hideAlways = false,
            hideCombat = false,
            hideOutOfCombat = false,
            hidePet = false,
            hideNoPet = false,
            hideStance = false,
            hideStealth = false,
            hideNoStealth = false,
            hideCustom = false,
            hideCustomCond = ''
        },
        bags = {
            scale = 1,
            anchorFrame = 'UIParent',
            anchor = 'BOTTOMRIGHT',
            anchorParent = 'BOTTOMRIGHT',
            x = 0,
            y = 26,
            expanded = true,
            hideArrow = false,
            hidden = false,
            overrideBagAnchor = false,
            offsetX = 5,
            offsetY = 95,
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
            hideCustom = false,
            hideCustomCond = ''
        },
        micro = {
            scale = 1,
            anchorFrame = 'UIParent',
            anchor = 'BOTTOMRIGHT',
            anchorParent = 'BOTTOMRIGHT',
            x = 0,
            y = 0,
            hidden = false,
            hideDefaultFPS = true,
            showFPS = true,
            alwaysShowFPS = false,
            showPing = true,
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
            hideCustom = false,
            hideCustomCond = ''
        }
    }
}
-- if DF.Cata then
--     defaults.profile.micro.x = -320
-- elseif DF.Wrath then
--     defaults.profile.micro.x = -294
-- elseif DF.Era then
--     defaults.profile.micro.x = -205
-- end

Module:SetDefaults(defaults)

local defaultsActionbarPROTO = {
    scale = 1,
    anchorFrame = 'UIParent',
    anchor = 'CENTER',
    anchorParent = 'CENTER',
    x = 0,
    y = 0,
    orientation = 'horizontal',
    buttonScale = 1,
    rows = 1,
    buttons = 12,
    padding = 3,
    alwaysShow = true
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

local presetDesc =
    'Sets Scale, Anchor, AnchorParent, AnchorFrame, X and Y to that of the chosen preset, but does not change any other setting.';

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
    ['UIParent'] = 'UIParent',
    ['DragonflightUIActionbarFrame1'] = 'Actionbar1',
    ['DragonflightUIActionbarFrame2'] = 'Actionbar2',
    ['DragonflightUIActionbarFrame3'] = 'Actionbar3',
    ['DragonflightUIActionbarFrame4'] = 'Actionbar4',
    ['DragonflightUIActionbarFrame5'] = 'Actionbar5',
    ['DragonflightUIActionbarFrame6'] = 'Actionbar6',
    ['DragonflightUIActionbarFrame7'] = 'Actionbar7',
    ['DragonflightUIActionbarFrame8'] = 'Actionbar8',

    ['DragonflightUIXPBar'] = 'XPbar',
    ['DragonflightUIRepBar'] = 'RepBar',
    ['DragonflightUIPetBar'] = 'PetBar',
    ['DragonflightUIStancebar'] = 'Stancebar'
}

local function frameTableWithout(own)
    local newFrameTable = {}
    for k, v in pairs(frameTable) do
        --
        if k == own then
        else
            newFrameTable[k] = v
        end
    end

    return newFrameTable
end

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
        config = {type = 'header', name = 'Config - Actionbar', order = 100},
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale'),
            min = 0.2,
            max = 1.5,
            bigStep = 0.025,
            order = 101,
            disabled = true
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to BOTTOM CENTER' .. getDefaultStr('x'),
            min = -2500,
            max = 2500,
            bigStep = 0.50,
            order = 102,
            disabled = true
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to BOTTOM CENTER' .. getDefaultStr('y'),
            min = -2500,
            max = 2500,
            bigStep = 0.50,
            order = 102,
            disabled = true
        },
        showGryphon = {
            type = 'toggle',
            name = 'Show Gryphon Art',
            desc = 'Shows/Hides Gryphon Art on the side' .. getDefaultStr('showGryphon'),
            order = 105.1
        },
        changeSides = {
            type = 'toggle',
            name = 'Change Right Bar 1+2',
            desc = 'Moves the Right Bar 1 + 2 to the side of the mainbar ' .. getDefaultStr('changeSides'),
            order = 105.2
        },
        -- config = {type = 'header', name = 'Config - XP/Reputation Bar', order = 200},
        alwaysShowXP = {
            type = 'toggle',
            name = 'Always show XP Text',
            desc = 'Set to always show text on XP bar' .. getDefaultStr('alwaysShowXP'),
            order = 201,
            width = '2'
        },
        alwaysShowRep = {
            type = 'toggle',
            name = 'Always show Reputation Text',
            desc = 'Set to always show text on Reputation bar' .. getDefaultStr('alwaysShowRep'),
            order = 201,
            width = '4'
        },
        -- config = {type = 'header', name = 'EXPERIMENTAL - Actionbar 4/5', order = 300},
        sideRows = {
            type = 'range',
            name = '# of Rows',
            desc = '' .. getDefaultStr('sideRows'),
            min = 1,
            max = 12,
            bigStep = 1,
            order = 301.1,
            disabled = false
        },
        sideButtons = {
            type = 'range',
            name = '# of Buttons',
            desc = '' .. getDefaultStr('sideButtons'),
            min = 1,
            max = 12,
            bigStep = 1,
            order = 301.2,
            disabled = false
        }
    }
}

-- .....\BlizzardInterfaceCode\Interface\FrameXML\SettingDefinitions\ActionBarsOverrides.lua
local actionBars = {
    {
        variable = "PROXY_SHOW_ACTIONBAR_2",
        label = OPTION_SHOW_ACTION_BAR:format(2),
        tooltip = OPTION_TOOLTIP_SHOW_MULTIBAR1,
        uvar = "SHOW_MULTI_ACTIONBAR_1"
    }, {
        variable = "PROXY_SHOW_ACTIONBAR_3",
        label = OPTION_SHOW_ACTION_BAR:format(3),
        tooltip = OPTION_TOOLTIP_SHOW_MULTIBAR2,
        uvar = "SHOW_MULTI_ACTIONBAR_2"
    }, {
        variable = "PROXY_SHOW_ACTIONBAR_4",
        label = OPTION_SHOW_ACTION_BAR:format(4),
        tooltip = OPTION_TOOLTIP_SHOW_MULTIBAR3,
        uvar = "SHOW_MULTI_ACTIONBAR_3"
    }, {
        variable = "PROXY_SHOW_ACTIONBAR_5",
        label = OPTION_SHOW_ACTION_BAR:format(5),
        tooltip = OPTION_TOOLTIP_SHOW_MULTIBAR4,
        uvar = "SHOW_MULTI_ACTIONBAR_4"
    }
};

local function GetBarOption(n)
    local barname = 'bar' .. n
    local opt = {
        name = 'Actionbar' .. n,
        desc = 'Actionbar' .. n,
        get = getOption,
        set = setOption,
        type = 'group',
        args = {
            --[[    scale = {
                type = 'range',
                name = 'Scale',
                desc = '' .. getDefaultStr('scale', barname),
                min = 0.1,
                max = 5,
                bigStep = 0.1,
                order = 1
            }, ]]
            anchorFrame = {
                type = 'select',
                name = 'Anchorframe',
                desc = 'Anchor' .. getDefaultStr('anchorFrame', barname),
                values = frameTableWithout('DragonflightUIActionbarFrame' .. n),
                order = 4,
                editmode = true
            },
            anchor = {
                type = 'select',
                name = 'Anchor',
                desc = 'Anchor' .. getDefaultStr('anchor', barname),
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
                desc = 'AnchorParent' .. getDefaultStr('anchorParent', barname),
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
                desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', barname),
                min = -2500,
                max = 2500,
                bigStep = 1,
                order = 5,
                editmode = true
            },
            y = {
                type = 'range',
                name = 'Y',
                desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', barname),
                min = -2500,
                max = 2500,
                bigStep = 1,
                order = 6,
                editmode = true
            },
            orientation = {
                type = 'select',
                name = 'Orientation',
                desc = 'Orientation' .. getDefaultStr('orientation', barname),
                values = {['horizontal'] = 'Horizontal', ['vertical'] = 'Vertical'},
                order = 7,
                editmode = true
            },
            reverse = {
                type = 'toggle',
                name = 'Reverse Button order',
                desc = '' .. getDefaultStr('reverse', barname),
                order = 7.5,
                editmode = true
            },
            buttonScale = {
                type = 'range',
                name = 'ButtonScale',
                desc = '' .. getDefaultStr('buttonScale', barname),
                min = 0.1,
                max = 3,
                bigStep = 0.05,
                order = 1,
                editmode = true
            },
            rows = {
                type = 'range',
                name = '# of Rows',
                desc = '' .. getDefaultStr('rows', barname),
                min = 1,
                max = 12,
                bigStep = 1,
                order = 9,
                editmode = true
            },
            buttons = {
                type = 'range',
                name = '# of Buttons',
                desc = '' .. getDefaultStr('buttons', barname),
                min = 1,
                max = 12,
                bigStep = 1,
                order = 10,
                editmode = true
            },
            padding = {
                type = 'range',
                name = 'Padding',
                desc = '' .. getDefaultStr('padding', barname),
                min = 0,
                max = 10,
                bigStep = 1,
                order = 11,
                editmode = true
            },
            headerStyling = {type = 'header', name = 'Style', desc = '', order = 50},
            alwaysShow = {
                type = 'toggle',
                name = 'Always show Actionbar',
                desc = '' .. getDefaultStr('alwaysShow', barname),
                order = 50.1
            },
            hideMacro = {
                type = 'toggle',
                name = 'Hide Macro Text',
                desc = '' .. getDefaultStr('hideMacro', barname),
                order = 55
            },
            macroFontSize = {
                type = 'range',
                name = 'MacroName Font Size',
                desc = '' .. getDefaultStr('macroFontSize', barname),
                min = 6,
                max = 24,
                bigStep = 1,
                order = 55.1,
                new = true
            },
            hideKeybind = {
                type = 'toggle',
                name = 'Hide Keybind Text',
                desc = '' .. getDefaultStr('hideKeybind', barname),
                order = 56
            },
            keybindFontSize = {
                type = 'range',
                name = 'Keybind Font Size',
                desc = '' .. getDefaultStr('keybindFontSize', barname),
                min = 6,
                max = 24,
                bigStep = 1,
                order = 56.1,
                new = true
            }

        }
    }

    if n == 1 then
        -- print('111111')
        local moreOptions = {
            hideArt = {
                type = 'toggle',
                name = 'Hide bar art',
                desc = '' .. getDefaultStr('hideArt', barname),
                order = 51.2,
                editmode = true
            },
            hideScrolling = {
                type = 'toggle',
                name = 'Hide bar scrolling',
                desc = '' .. getDefaultStr('hideScrolling', barname),
                order = 51.3,
                editmode = true
            },
            gryphons = {
                type = 'select',
                name = 'Gryphons',
                desc = 'Gryphons' .. getDefaultStr('gryphons', barname),
                values = {['DEFAULT'] = 'DEFAULT', ['ALLY'] = 'ALLIANCE', ['HORDE'] = 'HORDE', ['NONE'] = 'NONE'},
                order = 51.4,
                editmode = true
            },
            range = {
                type = 'toggle',
                name = 'Icon Range Color',
                desc = 'Changes the Icon color when Out Of Range, similar to RedRange/tullaRange' ..
                    getDefaultStr('range', barname),
                order = 51.1,
                editmode = true
            }
        }

        for k, v in pairs(moreOptions) do opt.args[k] = v end
        -- elseif n <= 5 then
        --     local moreOptions = {
        --         activate = {
        --             type = 'toggle',
        --             name = actionBars[n - 1].label,
        --             desc = actionBars[n - 1].tooltip,
        --             order = 13,
        --             blizzard = true,
        --             editmode = true
        --         }
        --     }
        --     for k, v in pairs(moreOptions) do opt.args[k] = v end
        -- elseif n > 5 then
    else
        local moreOptions = {
            activate = {
                type = 'toggle',
                name = 'Active',
                desc = '' .. getDefaultStr('activate', barname),
                order = 13,
                new = true,
                editmode = true
            }
        }
        for k, v in pairs(moreOptions) do opt.args[k] = v end
    end

    -- AddStateTable(opt, barname, 'Actionbar' .. n)
    DragonflightUIStateHandlerMixin:AddStateTable(Module, opt, barname, 'Actionbar' .. n, getDefaultStr)

    -- if n > 5 then opt.args.hideAlways.editmode = true; end

    return opt
end
local function GetBarExtraOptions(n)
    local bar = 'bar' .. n;
    local extra = {
        name = bar,
        desc = bar,
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
                    local dbTable = Module.db.profile[bar]
                    local defaultsTable = defaults.profile[bar]
                    -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                    setPreset(dbTable, {
                        scale = defaultsTable.scale,
                        anchor = defaultsTable.anchor,
                        anchorParent = defaultsTable.anchorParent,
                        anchorFrame = defaultsTable.anchorFrame,
                        x = defaultsTable.x,
                        y = defaultsTable.y
                    }, bar)
                end,
                order = 16,
                editmode = true,
                new = true
            }
        }
    }
    return extra;
end

local petOptions = {
    name = 'PetBar',
    desc = 'PetBar',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'pet'),
            values = frameTableWithout('DragonflightUIPetBar'),
            order = 4,
            editmode = true
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'pet'),
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
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'pet'),
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
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'pet'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5,
            editmode = true
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'pet'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6,
            editmode = true
        },
        orientation = {
            type = 'select',
            name = 'Orientation',
            desc = 'Orientation' .. getDefaultStr('orientation', 'pet'),
            values = {['horizontal'] = 'Horizontal', ['vertical'] = 'Vertical'},
            order = 7,
            editmode = true
        },
        buttonScale = {
            type = 'range',
            name = 'ButtonScale',
            desc = '' .. getDefaultStr('buttonScale', 'pet'),
            min = 0.1,
            max = 3,
            bigStep = 0.05,
            order = 1,
            editmode = true
        },
        rows = {
            type = 'range',
            name = '# of Rows',
            desc = '' .. getDefaultStr('rows', 'pet'),
            min = 1,
            max = 12,
            bigStep = 1,
            order = 9,
            editmode = true
        },
        buttons = {
            type = 'range',
            name = '# of Buttons',
            desc = '' .. getDefaultStr('buttons', 'pet'),
            min = 1,
            max = 10,
            bigStep = 1,
            order = 10,
            editmode = true
        },
        padding = {
            type = 'range',
            name = 'Padding',
            desc = '' .. getDefaultStr('padding', 'pet'),
            min = 0,
            max = 10,
            bigStep = 1,
            order = 11,
            editmode = true
        },
        alwaysShow = {
            type = 'toggle',
            name = 'Always show Actionbar',
            desc = '' .. getDefaultStr('alwaysShow', 'pet'),
            order = 12,
            editmode = true
        },
        hideMacro = {
            type = 'toggle',
            name = 'Hide Macro Text',
            desc = '' .. getDefaultStr('hideMacro', 'pet'),
            order = 16,
            editmode = true
        },
        hideKeybind = {
            type = 'toggle',
            name = 'Hide Keybind Text',
            desc = '' .. getDefaultStr('hideKeybind', 'pet'),
            order = 17,
            editmode = true
        }
    }
}
DragonflightUIStateHandlerMixin:AddStateTable(Module, petOptions, 'pet', 'PetBar', getDefaultStr)
local optionsPetEdtimode = {
    name = 'pet',
    desc = 'pet',
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
                local dbTable = Module.db.profile.pet
                local defaultsTable = defaults.profile.pet
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'pet')
            end,
            order = 16,
            editmode = true,
            new = true
        }
    }
}

local xpOptions = {
    name = 'XP',
    desc = 'XP',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'xp'),
            min = 0.1,
            max = 5,
            bigStep = 0.1,
            order = 1,
            editmode = true
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'xp'),
            values = frameTableWithout('DragonflightUIXPBar'),
            order = 4,
            editmode = true
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'xp'),
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
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'xp'),
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
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'xp'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5,
            editmode = true
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'xp'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6,
            editmode = true
        },
        width = {
            type = 'range',
            name = 'Width',
            desc = '' .. getDefaultStr('width', 'xp'),
            min = 1,
            max = 2500,
            bigStep = 1,
            order = 7,
            editmode = true
        },
        height = {
            type = 'range',
            name = 'Height',
            desc = '' .. getDefaultStr('height', 'xp'),
            min = 1,
            max = 69,
            bigStep = 1,
            order = 8,
            editmode = true
        },
        alwaysShowXP = {
            type = 'toggle',
            name = 'Always show XP text',
            desc = '' .. getDefaultStr('alwaysShowXP', 'xp'),
            order = 12,
            editmode = true
        },
        showXPPercent = {
            type = 'toggle',
            name = 'Show XP Percent',
            desc = '' .. getDefaultStr('showXPPercent', 'xp'),
            order = 13,
            editmode = true
        }
    }
}
DragonflightUIStateHandlerMixin:AddStateTable(Module, xpOptions, 'xp', 'XPBar', getDefaultStr)
local optionsXpEdtimode = {
    name = 'xp',
    desc = 'xp',
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
                local dbTable = Module.db.profile.xp
                local defaultsTable = defaults.profile.xp
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'xp')
            end,
            order = 16,
            editmode = true,
            new = true
        }
    }
}

local repOptions = {
    name = 'Rep',
    desc = 'Rep',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'rep'),
            min = 0.1,
            max = 5,
            bigStep = 0.1,
            order = 1,
            editmode = true
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'rep'),
            values = frameTableWithout('DragonflightUIRepBar'),
            order = 4,
            editmode = true
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'rep'),
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
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'rep'),
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
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'rep'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5,
            editmode = true
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'rep'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6,
            editmode = true
        },
        width = {
            type = 'range',
            name = 'Width',
            desc = '' .. getDefaultStr('width', 'rep'),
            min = 1,
            max = 2500,
            bigStep = 1,
            order = 7,
            editmode = true
        },
        height = {
            type = 'range',
            name = 'Height',
            desc = '' .. getDefaultStr('height', 'rep'),
            min = 1,
            max = 69,
            bigStep = 1,
            order = 8,
            editmode = true
        },
        alwaysShowRep = {
            type = 'toggle',
            name = 'Always show Rep text',
            desc = '' .. getDefaultStr('alwaysShowRep', 'rep'),
            order = 12,
            editmode = true
        }
    }
}
DragonflightUIStateHandlerMixin:AddStateTable(Module, repOptions, 'rep', 'RepBar', getDefaultStr)
local optionsRepEdtimode = {
    name = 'rep',
    desc = 'rep',
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
                local dbTable = Module.db.profile.rep
                local defaultsTable = defaults.profile.rep
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'rep')
            end,
            order = 16,
            editmode = true,
            new = true
        }
    }
}

local stanceOptions = {
    name = 'StanceBar',
    desc = 'StanceBar',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'stance'),
            values = frameTableWithout('DragonflightUIStancebar'),
            order = 4,
            editmode = true
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'stance'),
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
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'stance'),
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
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'stance'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5,
            editmode = true
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'stance'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6,
            editmode = true
        },
        orientation = {
            type = 'select',
            name = 'Orientation',
            desc = 'Orientation' .. getDefaultStr('orientation', 'stance'),
            values = {['horizontal'] = 'Horizontal', ['vertical'] = 'Vertical'},
            order = 7,
            editmode = true
        },
        buttonScale = {
            type = 'range',
            name = 'ButtonScale',
            desc = '' .. getDefaultStr('buttonScale', 'stance'),
            min = 0.1,
            max = 3,
            bigStep = 0.05,
            order = 1,
            editmode = true
        },
        rows = {
            type = 'range',
            name = '# of Rows',
            desc = '' .. getDefaultStr('rows', 'stance'),
            min = 1,
            max = 12,
            bigStep = 1,
            order = 9,
            editmode = true
        },
        buttons = {
            type = 'range',
            name = '# of Buttons',
            desc = '' .. getDefaultStr('buttons', 'stance'),
            min = 1,
            max = 10,
            bigStep = 1,
            order = 10,
            editmode = true
        },
        padding = {
            type = 'range',
            name = 'Padding',
            desc = '' .. getDefaultStr('padding', 'stance'),
            min = 0,
            max = 10,
            bigStep = 1,
            order = 11,
            editmode = true
        },
        headerStyling = {type = 'header', name = 'Style', desc = '', order = 50},
        alwaysShow = {
            type = 'toggle',
            name = 'Always show Actionbar',
            desc = '' .. getDefaultStr('alwaysShow', 'stance'),
            order = 50.1
        },
        hideMacro = {
            type = 'toggle',
            name = 'Hide Macro Text',
            desc = '' .. getDefaultStr('hideMacro', 'stance'),
            order = 55
        },
        macroFontSize = {
            type = 'range',
            name = 'MacroName Font Size',
            desc = '' .. getDefaultStr('macroFontSize', 'stance'),
            min = 6,
            max = 24,
            bigStep = 1,
            order = 55.1,
            new = true
        },
        hideKeybind = {
            type = 'toggle',
            name = 'Hide Keybind Text',
            desc = '' .. getDefaultStr('hideKeybind', 'stance'),
            order = 56
        },
        keybindFontSize = {
            type = 'range',
            name = 'Keybind Font Size',
            desc = '' .. getDefaultStr('keybindFontSize', 'stance'),
            min = 6,
            max = 24,
            bigStep = 1,
            order = 56.1,
            new = true
        },
        activate = {type = 'toggle', name = 'Active', desc = '' .. getDefaultStr('activate', 'stance'), order = 13}
    }
}
DragonflightUIStateHandlerMixin:AddStateTable(Module, stanceOptions, 'stance', 'StanceBar', getDefaultStr)
local optionsStanceEdtimode = {
    name = 'stance',
    desc = 'stance',
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
                local dbTable = Module.db.profile.stance
                local defaultsTable = defaults.profile.stance
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'stance')
            end,
            order = 16,
            editmode = true,
            new = true
        }
    }
}

local totemOptions = {
    name = 'Totembar',
    desc = 'Totembar',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'totem'),
            min = 0.1,
            max = 5,
            bigStep = 0.1,
            order = 1,
            editmode = true
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'totem'),
            values = frameTable,
            order = 4,
            editmode = true
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'totem'),
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
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'totem'),
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
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'totem'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5,
            editmode = true
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'totem'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6,
            editmode = true
        }
    }
}
DragonflightUIStateHandlerMixin:AddStateTable(Module, totemOptions, 'totem', 'TotemBar', getDefaultStr)
local optionsTotemEdtimode = {
    name = 'totem',
    desc = 'totem',
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
                local dbTable = Module.db.profile.totem
                local defaultsTable = defaults.profile.totem
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'totem')
            end,
            order = 16,
            editmode = true,
            new = true
        }
    }
}

local possessOptions = {
    name = 'Possessbar',
    desc = 'Possessbar',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'possess'),
            min = 0.1,
            max = 5,
            bigStep = 0.1,
            order = 1,
            editmode = true
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'possess'),
            values = frameTable,
            order = 4,
            editmode = true
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'possess'),
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
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'possess'),
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
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'possess'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5,
            editmode = true
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'possess'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6,
            editmode = true
        },
        offset = {
            type = 'toggle',
            name = 'Auto adjust offset',
            desc = 'Auto add some Y offset depending on the class, e.g. on Paladin to make room for the stance bar' ..
                getDefaultStr('offset', 'possess'),
            order = 11,
            new = true,
            editmode = true
        }
    }
}
DragonflightUIStateHandlerMixin:AddStateTable(Module, possessOptions, 'possess', 'PossessBar', getDefaultStr)
local optionsPossessEdtimode = {
    name = 'possess',
    desc = 'possess',
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
                local dbTable = Module.db.profile.possess
                local defaultsTable = defaults.profile.possess
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'possess')
            end,
            order = 16,
            editmode = true,
            new = true
        }
    }
}

local bagsOptions = {
    name = 'Bags',
    desc = 'Bags',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'bags'),
            min = 0.1,
            max = 5,
            bigStep = 0.1,
            order = 1,
            editmode = true
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'bags'),
            values = frameTable,
            order = 4,
            editmode = true
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'bags'),
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
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'bags'),
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
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'bags'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5,
            editmode = true
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'bags'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6,
            editmode = true
        },
        expanded = {type = 'toggle', name = 'Expanded', desc = '' .. getDefaultStr('expanded', 'bags'), order = 7},
        hideArrow = {
            type = 'toggle',
            name = 'HideArrow',
            desc = '' .. getDefaultStr('hideArrow', 'bags'),
            order = 8,
            editmode = true
        },
        hidden = {
            type = 'toggle',
            name = 'Hidden',
            desc = 'Backpack hidden' .. getDefaultStr('hidden', 'bags'),
            order = 9,
            editmode = true
        },
        overrideBagAnchor = {
            type = 'toggle',
            name = 'Override BagAnchor',
            desc = '' .. getDefaultStr('overrideBagAnchor', 'bags'),
            order = 15,
            new = true
        },
        offsetX = {
            type = 'range',
            name = 'BagAnchor OffsetX',
            desc = '' .. getDefaultStr('offsetX', 'bags'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 16,
            new = true
        },
        offsetY = {
            type = 'range',
            name = 'BagAnchor OffsetY',
            desc = '' .. getDefaultStr('offsetY', 'bags'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 17,
            new = true
        }
    }
}
-- bag blizzard options
do
    local moreOptions = {
        activate = {
            type = 'toggle',
            name = DISPLAY_FREE_BAG_SLOTS,
            desc = OPTION_TOOLTIP_DISPLAY_FREE_BAG_SLOTS,
            order = 13,
            blizzard = true
        }
    }

    for k, v in pairs(moreOptions) do bagsOptions.args[k] = v end

    bagsOptions.get = function(info)
        local key = info[1]
        local sub = info[2]

        if sub == 'activate' then
            C_CVar.GetCVarBool("displayFreeBagSlots")
        else
            return getOption(info)
        end
    end

    local function CVarChangedCB()
        local displayFreeBagSlots = C_CVar.GetCVarBool("displayFreeBagSlots");
        if (displayFreeBagSlots) then
            MainMenuBarBackpackButtonCount:Show();
        else
            MainMenuBarBackpackButtonCount:Hide();
        end
        MainMenuBarBackpackButton_UpdateFreeSlots();
    end

    bagsOptions.set = function(info, value)
        local key = info[1]
        local sub = info[2]

        if sub == 'activate' then
            if value then
                C_CVar.SetCVar("displayFreeBagSlots", 1)
            else
                C_CVar.SetCVar("displayFreeBagSlots", 0)
            end
            CVarChangedCB()
        else
            setOption(info, value)
        end
    end
end
DragonflightUIStateHandlerMixin:AddStateTable(Module, bagsOptions, 'bags', 'Bags', getDefaultStr)
local optionsBagsEdtimode = {
    name = 'bags',
    desc = 'bags',
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
                local dbTable = Module.db.profile.bags
                local defaultsTable = defaults.profile.bags
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'bags')
            end,
            order = 16,
            editmode = true,
            new = true
        }
    }
}

local microOptions = {
    name = 'Micromenu',
    desc = 'Micromenu',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'micro'),
            min = 0.1,
            max = 5,
            bigStep = 0.05,
            order = 1,
            editmode = true
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'micro'),
            values = frameTable,
            order = 4,
            editmode = true
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'micro'),
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
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'micro'),
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
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'micro'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5,
            editmode = true
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'micro'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6,
            editmode = true
        },
        -- hidden = {
        --     type = 'toggle',
        --     name = 'Hidden',
        --     desc = 'Hide Micromenu' .. getDefaultStr('hidden', 'micro'),
        --     order = 7
        -- },
        hideDefaultFPS = {
            type = 'toggle',
            name = 'HideDefaultFPS',
            desc = 'Hide Default FPS Text' .. getDefaultStr('hideDefaultFPS', 'micro'),
            order = 8
        },
        showFPS = {
            type = 'toggle',
            name = 'ShowFPS',
            desc = 'Show Custom FPS Text' .. getDefaultStr('showFPS', 'micro'),
            order = 9
        },
        alwaysShowFPS = {
            type = 'toggle',
            name = 'AlwaysShowFPS',
            desc = 'Always Show Custom FPS Text' .. getDefaultStr('alwaysShowFPS', 'micro'),
            order = 10
        },
        showPing = {
            type = 'toggle',
            name = 'ShowPing',
            desc = 'Show Ping In MS' .. getDefaultStr('showPing', 'micro'),
            order = 11
        }
    }
}
DragonflightUIStateHandlerMixin:AddStateTable(Module, microOptions, 'micro', 'Micromenu', getDefaultStr)
local optionsMicroEditmode = {
    name = 'micro',
    desc = 'micro',
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
                local dbTable = Module.db.profile.micro
                local defaultsTable = defaults.profile.micro
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'micro')
            end,
            order = 16,
            editmode = true,
            new = true
        }
    }
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    DF:RegisterModuleOptions(mName, options)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    -- not the best solution, override global CVAR and let DF UI handle everything
    C_CVar.SetCVar("alwaysShowActionBars", 1)

    Module.Temp = {}
    Module.UpdateRangeHooked = false
    if DF.Wrath then
        Module.Wrath()
    else
        Module.Era()
    end
    Module:SetupActionbarFrames()
    Module.AddStateUpdater()
    Module:AddEditMode()

    Module:RegisterOptionScreens()
    Module:ApplySettings('ALL')

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)
        Module:ApplySettings('ALL')
        Module:RefreshOptionScreens()
    end)
end

function Module:OnDisable()
end

function Module:SetupActionbarFrames()
    local createStuff = function(n, base)
        local bar = CreateFrame('FRAME', 'DragonflightUIActionbarFrame' .. n, UIParent,
                                'DragonflightUIActionbarFrameTemplate')
        local buttons = {}
        for i = 1, 12 do
            local name = base .. i
            local btn = _G[name]
            buttons[i] = btn
        end
        bar:Init()
        bar:SetButtons(buttons)
        Module['bar' .. n] = bar
    end

    DragonflightUIActionbarMixin:HookGrid()
    if DF.Cata then
        DragonflightUIActionbarMixin:HookFlyout()
        DragonflightUIActionbarMixin:StyleFlyout()
    end

    createStuff(1, 'ActionButton')
    Module.bar1:SetupMainBar()
    createStuff(2, 'MultiBarBottomLeftButton')
    createStuff(3, 'MultiBarBottomRightButton')
    createStuff(4, 'MultiBarLeftButton')
    createStuff(5, 'MultiBarRightButton')

    Module.bar1:StyleButtons()
    Module.bar1:HookQuickbindMode()
    -- Module.bar1:HookGrid()
    Module.bar2:StyleButtons()
    Module.bar2:HookQuickbindMode()
    Module.bar3:StyleButtons()
    Module.bar3:HookQuickbindMode()
    Module.bar4:StyleButtons()
    Module.bar4:HookQuickbindMode()
    Module.bar5:StyleButtons()
    Module.bar5:HookQuickbindMode()

    -- bar 6

    local createExtra = function(n)
        local btns = {}

        local extraParent = CreateFrame('FRAME', 'DragonflightUIMultiactionBar' .. n .. 'VisParent', UIParent)
        extraParent:SetFrameLevel(0)

        for i = 1, 12 do
            --
            local btn = CreateFrame("CheckButton", "DragonflightUIMultiactionBar" .. n .. "Button" .. i, extraParent,
                                    "ActionBarButtonTemplate")
            btn:SetSize(64, 64)
            btn:SetPoint("CENTER", UIParent, "CENTER", 64 * i, 0)
            btn:SetAttribute("type", "action")
            btn:SetAttribute("action", 144 + (n - 6) * 12 + i) -- Action slot 1
            btn:SetFrameLevel(3)

            -- global binding
            -- _G["BINDING_NAME_CLICK DragonflightUIMultiactionBar" .. n .. "Button" .. i .. ":LeftButton"] =
            --     "Action Bar " .. n .. ' Button ' .. i;

            btn.command = "CLICK DragonflightUIMultiactionBar" .. n .. "Button" .. i .. ":LeftButton"
            btn.commandHuman = "Action Bar " .. n .. ' Button ' .. i

            btns[i] = btn
            btn:Hide()

            -- btn:UpdateAction()          
        end

        local bar = CreateFrame('FRAME', 'DragonflightUIActionbarFrame' .. n, UIParent,
                                'DragonflightUIActionbarFrameTemplate')

        bar:Init()
        bar:SetButtons(btns)
        Module['bar' .. n] = bar

        bar:StyleButtons()
        bar:HookQuickbindMode()
    end

    createExtra(6)
    createExtra(7)
    createExtra(8)

    DragonFlightUIQuickKeybindMixin:HookExtraButtons()

    hooksecurefunc('ActionButton_UpdateHotkeys', function(self, actionButtonType)
        -- print('ActionButton_UpdateHotkeys')        
        if self.DragonflightFixHotkeyPosition then self.DragonflightFixHotkeyPosition() end
    end)

    do
        local bar = CreateFrame('FRAME', 'DragonflightUIPetbar', UIParent, 'DragonflightUIPetbarFrameTemplate')
        local buttons = {}

        for i = 1, 10 do
            local btn = _G['PetActionButton' .. i]
            buttons[i] = btn
        end

        bar:Init()
        bar:SetButtons(buttons)
        bar:StyleButtons()
        bar:StylePetButton()
        bar:SetIgnoreRange(true)
        Module['petbar'] = bar
    end

    do
        local bar = CreateFrame('FRAME', 'DragonflightUIStancebar', UIParent, 'DragonflightUIStancebarFrameTemplate')
        local buttons = {}

        for i = 1, 10 do
            local btn = _G['StanceButton' .. i]
            buttons[i] = btn
        end

        bar:Init()
        bar:SetButtons(buttons)
        bar:StyleButtons()
        bar:ReplaceNormalTexture2()
        bar.stanceBar = true
        Module['stancebar'] = bar
    end

    -- @TODO
    do
        -- MultiBarBottomLeft.ignoreFramePositionManager = true
        -- MultiBarBottomLeft:ClearAllPoints()
        -- MultiBarBottomLeft:SetPoint('BOTTOM', _G['DragonflightUIActionbarFrame2'], 'BOTTOM')

        -- MultiBarBottomRight.ignoreFramePositionManager = true
        -- MultiBarBottomRight:ClearAllPoints()
        -- MultiBarBottomRight:SetPoint('BOTTOM', _G['DragonflightUIActionbarFrame3'], 'BOTTOM')
    end
end

function Module.AddStateUpdater()
    Mixin(MainMenuBarBackpackButton, DragonflightUIStateHandlerMixin)
    MainMenuBarBackpackButton:InitStateHandler()
    -- MainMenuBarBackpackButton:SetHideFrame(CharacterBag0Slot, 2)
    -- MainMenuBarBackpackButton:SetHideFrame(CharacterBag1Slot, 3)
    -- MainMenuBarBackpackButton:SetHideFrame(CharacterBag2Slot, 4)
    -- MainMenuBarBackpackButton:SetHideFrame(CharacterBag3Slot, 5)

    MainMenuBarBackpackButton.DFShower:ClearAllPoints()
    MainMenuBarBackpackButton.DFShower:SetPoint('TOPLEFT', MainMenuBarBackpackButton, 'TOPLEFT', -95, 6)
    MainMenuBarBackpackButton.DFShower:SetPoint('BOTTOMRIGHT', MainMenuBarBackpackButton, 'BOTTOMRIGHT', 6, -6)

    MainMenuBarBackpackButton.DFMouseHandler:ClearAllPoints()
    MainMenuBarBackpackButton.DFMouseHandler:SetPoint('TOPLEFT', MainMenuBarBackpackButton, 'TOPLEFT', -95, 6)
    MainMenuBarBackpackButton.DFMouseHandler:SetPoint('BOTTOMRIGHT', MainMenuBarBackpackButton, 'BOTTOMRIGHT', 6, -6)

    ---
    local microFrame = Module.MicroFrame
    Mixin(microFrame, DragonflightUIStateHandlerMixin)
    microFrame:InitStateHandler()
end

function Module:AddEditMode()
    local EditModeModule = DF:GetModule('Editmode');

    -- bars
    for i = 1, 8 do
        local bar = Module['bar' .. i]

        EditModeModule:AddEditModeToFrame(bar)

        bar.DFEditModeSelection:SetGetLabelTextFunction(function()
            return 'Actionbar' .. i
        end)

        local optionsBar = GetBarOption(i)
        local optionsBarExtra = GetBarExtraOptions(i)
        bar.DFEditModeSelection:RegisterOptions({
            name = 'Actionbar' .. i,
            sub = 'bar' .. i,
            options = optionsBar,
            extra = optionsBarExtra,
            default = function()
                setDefaultSubValues('bar' .. i)
            end,
            moduleRef = self
        });
    end

    -- Pet 
    EditModeModule:AddEditModeToFrame(Module.petbar)

    Module.petbar.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'Petbar'
    end)

    Module.petbar.DFEditModeSelection:RegisterOptions({
        name = 'Petbar',
        sub = 'pet',
        options = petOptions,
        extra = optionsPetEdtimode,
        default = function()
            setDefaultSubValues('pet')
        end,
        moduleRef = self
    });

    -- XP 
    EditModeModule:AddEditModeToFrame(Module.xpbar)

    Module.xpbar.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'XPbar'
    end)

    Module.xpbar.DFEditModeSelection:RegisterOptions({
        name = 'XPbar',
        sub = 'xp',
        options = xpOptions,
        extra = optionsXpEdtimode,
        default = function()
            setDefaultSubValues('xp')
        end,
        moduleRef = self
    });

    -- Rep 
    EditModeModule:AddEditModeToFrame(Module.repbar)

    Module.repbar.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'Repbar'
    end)

    Module.repbar.DFEditModeSelection:RegisterOptions({
        name = 'Repbar',
        sub = 'rep',
        options = repOptions,
        extra = optionsRepEdtimode,
        default = function()
            setDefaultSubValues('rep')
        end,
        moduleRef = self
    });

    -- Possess 
    EditModeModule:AddEditModeToFrame(PossessBarFrame)

    PossessBarFrame.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'Possessbar'
    end)

    PossessBarFrame.DFEditModeSelection:RegisterOptions({
        name = 'Possessbar',
        sub = 'possess',
        options = possessOptions,
        extra = optionsPossessEdtimode,
        default = function()
            setDefaultSubValues('possess')
        end,
        moduleRef = self
    });

    PossessBarFrame.DFEditModeSelection:ClearAllPoints()
    local possessDelta = 4
    PossessBarFrame.DFEditModeSelection:SetPoint('TOPLEFT', _G['PossessButton1'], 'TOPLEFT', -possessDelta, possessDelta)
    PossessBarFrame.DFEditModeSelection:SetPoint('BOTTOMRIGHT', _G['PossessButton2'], 'BOTTOMRIGHT', possessDelta,
                                                 -possessDelta)

    -- Stance 
    EditModeModule:AddEditModeToFrame(Module.stancebar)

    Module.stancebar.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'Stancebar'
    end)

    Module.stancebar.DFEditModeSelection:RegisterOptions({
        name = 'Stancebar',
        sub = 'stance',
        options = stanceOptions,
        extra = optionsStanceEdtimode,
        default = function()
            setDefaultSubValues('stance')
        end,
        moduleRef = self
    });

    -- totem
    if DF.Cata then
        EditModeModule:AddEditModeToFrame(MultiCastActionBarFrame)

        MultiCastActionBarFrame.DFEditModeSelection:SetGetLabelTextFunction(function()
            return 'Totembar'
        end)

        MultiCastActionBarFrame.DFEditModeSelection:RegisterOptions({
            name = 'Totembar',
            sub = 'totem',
            options = totemOptions,
            extra = optionsTotemEdtimode,
            default = function()
                setDefaultSubValues('totem')
            end,
            moduleRef = self
        });
    end

    -- Bags
    EditModeModule:AddEditModeToFrame(MainMenuBarBackpackButton)

    MainMenuBarBackpackButton.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'Bags'
    end)

    MainMenuBarBackpackButton.DFEditModeSelection:RegisterOptions({
        name = 'Bags',
        sub = 'bags',
        options = bagsOptions,
        extra = optionsBagsEdtimode,
        default = function()
            setDefaultSubValues('bags')
            UpdateContainerFrameAnchors()
        end,
        moduleRef = self
    });

    -- Micro 
    EditModeModule:AddEditModeToFrame(Module.MicroFrame)

    Module.MicroFrame.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'Micromenu'
    end)

    Module.MicroFrame.DFEditModeSelection:RegisterOptions({
        name = 'Micromenu',
        sub = 'micro',
        options = microOptions,
        extra = optionsMicroEditmode,
        default = function()
            setDefaultSubValues('micro')
        end,
        moduleRef = self
    });
end

function Module:RegisterOptionScreens()
    for i = 1, 8 do
        local optionsBar = GetBarOption(i)
        DF.ConfigModule:RegisterOptionScreen('Actionbar', 'Actionbar' .. i, {
            name = 'Actionbar' .. i,
            sub = 'bar' .. i,
            options = optionsBar,
            default = function()
                setDefaultSubValues('bar' .. i)
            end
        })
    end

    DF.ConfigModule:RegisterOptionScreen('Actionbar', 'Petbar', {
        name = 'Petbar',
        sub = 'pet',
        options = petOptions,
        default = function()
            setDefaultSubValues('pet')
        end
    })

    DF.ConfigModule:RegisterOptionScreen('Actionbar', 'XPbar', {
        name = 'XPbar',
        sub = 'xp',
        options = xpOptions,
        default = function()
            setDefaultSubValues('xp')
        end
    })

    DF.ConfigModule:RegisterOptionScreen('Actionbar', 'Repbar', {
        name = 'Repbar',
        sub = 'rep',
        options = repOptions,
        default = function()
            setDefaultSubValues('rep')
        end
    })

    DF.ConfigModule:RegisterOptionScreen('Actionbar', 'Possessbar', {
        name = 'Possessbar',
        sub = 'possess',
        options = possessOptions,
        default = function()
            setDefaultSubValues('possess')
        end
    })

    DF.ConfigModule:RegisterOptionScreen('Actionbar', 'Stancebar', {
        name = 'Stancebar',
        sub = 'stance',
        options = stanceOptions,
        default = function()
            setDefaultSubValues('stance')
        end
    })
    if DF.Cata then
        DF.ConfigModule:RegisterOptionScreen('Actionbar', 'Totembar', {
            name = 'Totembar',
            sub = 'totem',
            options = totemOptions,
            default = function()
                setDefaultSubValues('totem')
            end
        })
    end
    DF.ConfigModule:RegisterOptionScreen('Actionbar', 'Bags', {
        name = 'Bags',
        sub = 'bags',
        options = bagsOptions,
        default = function()
            setDefaultSubValues('bags')
            UpdateContainerFrameAnchors()
        end
    })

    DF.ConfigModule:RegisterOptionScreen('Actionbar', 'Micromenu', {
        name = 'Micromenu',
        sub = 'micro',
        options = microOptions,
        default = function()
            setDefaultSubValues('micro')
        end
    })
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame

    local refreshCat = function(name)
        configFrame:RefreshCatSub('Actionbar', name)
    end

    for i = 1, 8 do refreshCat('Actionbar' .. i) end
    refreshCat('Petbar')
    refreshCat('XPbar')
    refreshCat('Repbar')
    refreshCat('Stancebar')
    if DF.Cata then refreshCat('Totembar') end
    refreshCat('Bags')
    refreshCat('Micromenu')

    for i = 1, 8 do
        local bar = Module['bar' .. i]
        bar.DFEditModeSelection:RefreshOptionScreen();
    end

    Module.petbar.DFEditModeSelection:RefreshOptionScreen();
    Module.xpbar.DFEditModeSelection:RefreshOptionScreen();
    Module.repbar.DFEditModeSelection:RefreshOptionScreen();
    PossessBarFrame.DFEditModeSelection:RefreshOptionScreen();
    Module.stancebar.DFEditModeSelection:RefreshOptionScreen();
    if DF.Cata then MultiCastActionBarFrame.DFEditModeSelection:RefreshOptionScreen(); end

    MainMenuBarBackpackButton.DFEditModeSelection:RefreshOptionScreen();
    Module.MicroFrame.DFEditModeSelection:RefreshOptionScreen();
end

function Module:ApplySettings(sub)
    -- print('function Module:ApplySettings(sub)', sub)
    local db = Module.db.profile

    if not sub or sub == 'ALL' then
        Module.bar1:SetState(db.bar1)
        Module.bar2:SetState(db.bar2)
        Module.bar3:SetState(db.bar3)
        Module.bar4:SetState(db.bar4)
        Module.bar5:SetState(db.bar5)

        Module.bar6:SetState(db.bar6)
        Module.bar7:SetState(db.bar7)
        Module.bar8:SetState(db.bar8)

        Module.petbar:SetState(db.pet)
        Module.xpbar:SetState(db.xp)
        Module.repbar:SetState(db.rep)
        Module.stancebar:SetState(db.stance)

        if db.bar1.range then
            if Module.UpdateRangeHooked then
                -- already hooked
            else
                self:SecureHook('ActionButton_UpdateRangeIndicator', function(self, checksRange, inRange)
                    DragonflightUIActionbarMixin:UpdateRange(self, checksRange, inRange)
                end)
                Module.UpdateRangeHooked = true
            end
        else
            if Module.UpdateRangeHooked then
                -- remove hook      
                Module.UpdateRangeHooked = false
                self:Unhook('ActionButton_UpdateRangeIndicator')
            end
        end

        if DF.Cata then Module.UpdateTotemState(db.totem) end

        Module.UpdateBagState(db.bags)
        Module.MicroFrame:UpdateState(db.micro)

        Module.UpdatePossesbarState(db.possess)

    elseif sub == 'bar1' then
        Module.bar1:SetState(db.bar1)

        if db.bar1.range then
            if Module.UpdateRangeHooked then
                -- already hooked
            else
                self:SecureHook('ActionButton_UpdateRangeIndicator', function(self, checksRange, inRange)
                    DragonflightUIActionbarMixin:UpdateRange(self, checksRange, inRange)
                end)
                Module.UpdateRangeHooked = true
            end
        else
            if Module.UpdateRangeHooked then
                -- remove hook      
                Module.UpdateRangeHooked = false
                self:Unhook('ActionButton_UpdateRangeIndicator')
            end
        end
    elseif sub == 'bar2' then
        Module.bar2:SetState(db.bar2)
    elseif sub == 'bar3' then
        Module.bar3:SetState(db.bar3)
    elseif sub == 'bar4' then
        Module.bar4:SetState(db.bar4)
    elseif sub == 'bar5' then
        Module.bar5:SetState(db.bar5)
    elseif sub == 'bar6' then
        Module.bar6:SetState(db.bar6)
    elseif sub == 'bar7' then
        Module.bar7:SetState(db.bar7)
    elseif sub == 'bar8' then
        Module.bar8:SetState(db.bar8)
    elseif sub == 'pet' then
        Module.petbar:SetState(db.pet)
    elseif sub == 'xp' then
        Module.xpbar:SetState(db.xp)
    elseif sub == 'rep' then
        Module.repbar:SetState(db.rep)
    elseif sub == 'stance' then
        Module.stancebar:SetState(db.stance)
    elseif sub == 'possess' then
        Module.UpdatePossesbarState(db.possess)
    elseif sub == 'totem' then
        if DF.Cata then Module.UpdateTotemState(db.totem) end
    elseif sub == 'bags' then
        Module.UpdateBagState(db.bags)
    elseif sub == 'micro' then
        Module.MicroFrame:UpdateState(db.micro)
    end
end

-- Actionbar
local frame = CreateFrame('FRAME', 'DragonflightUIActionbarFrame', UIParent)
frame:SetFrameStrata('HIGH')
Module.Frame = frame

function Module.ChangeActionbar()
    -- ActionButton1:ClearAllPoints()
    -- ActionButton1:SetPoint('CENTER', MainMenuBar, 'CENTER', -230 + 3 * 5.5, 30 + 18)
    ActionButton1.ignoreFramePositionManager = true

    -- MultiBarBottomLeft:ClearAllPoints()
    -- MultiBarBottomLeft:SetPoint('LEFT', ActionButton1, 'LEFT', 0, 40)
    MultiBarBottomLeft.ignoreFramePositionManager = true
    -- MultiBarBottomLeft:ClearAllPoints()
    -- MultiBarBottomLeft:SetPoint('BOTTOM', _G['DragonflightUIActionbarFrame2'], 'BOTTOM')

    -- MultiBarBottomRight:ClearAllPoints()
    -- MultiBarBottomRight:SetPoint('LEFT', MultiBarBottomLeft, 'LEFT', 0, 40)
    MultiBarBottomRight.ignoreFramePositionManager = true
    -- MultiBarBottomRight:ClearAllPoints()
    -- MultiBarBottomRight:SetPoint('BOTTOM', _G['DragonflightUIActionbarFrame3'], 'BOTTOM')

    MultiBarLeft.ignoreFramePositionManager = true
    MultiBarRight.ignoreFramePositionManager = true

    StanceButton1:ClearAllPoints()
    StanceButton1:SetPoint('LEFT', MultiBarBottomLeft, 'LEFT', 1, 77)
    StanceButton1.ignoreFramePositionManager = true

    StanceBarLeft:Hide()
    StanceBarMiddle:Hide()
    StanceBarRight:Hide()

    hooksecurefunc(StanceBarRight, 'Show', function()
        StanceBarLeft:Hide()
        StanceBarMiddle:Hide()
        StanceBarRight:Hide()
    end)

    --[[    ActionBarUpButton:ClearAllPoints()
    ActionBarUpButton:SetPoint('LEFT', ActionButton1, 'TOPLEFT', -40, -6)
    ActionBarDownButton:ClearAllPoints()
    ActionBarDownButton:SetPoint('LEFT', ActionButton1, 'BOTTOMLEFT', -40, 7) ]]

    MainMenuBar:SetSize(1, 1)

    MainMenuExpBar:Hide()
    hooksecurefunc(MainMenuExpBar, 'Show', function()
        MainMenuExpBar:Hide()
    end)
    ReputationWatchBar:Hide()
    hooksecurefunc(ReputationWatchBar, 'Show', function()
        ReputationWatchBar:Hide()
    end)
    MainMenuBarMaxLevelBar:Hide()
    hooksecurefunc(MainMenuBarMaxLevelBar, 'Show', function()
        MainMenuBarMaxLevelBar:Hide()
    end)
end

function Module.CreateNewXPBar()
    local newF = CreateFrame('Frame', 'DragonflightUIXPBar', UIParent, 'DragonflightUIXPBarTemplate')
    Module.xpbar = newF
end

function Module.CreateNewRepBar()
    local newRep = CreateFrame('Frame', 'DragonflightUIRepBar', UIParent, 'DragonflightUIRepBarTemplate')
    Module.repbar = newRep
end

function Module.HookAlwaysShowActionbar()
    local updateGrids = function()
        print('updateGrids')
        print(Module.db.profile.bar2.alwaysShow, Module.db.profile.bar3.alwaysShow)
        Module.bar2:UpdateGrid(Module.db.profile.bar2.alwaysShow)
        Module.bar3:UpdateGrid(Module.db.profile.bar3.alwaysShow)
    end
    hooksecurefunc('MultiActionBar_UpdateGridVisibility', function()
        -- print('MultiActionBar_UpdateGridVisibility')
        -- updateGrids()
    end)
    hooksecurefunc('MultiActionBar_ShowAllGrids', function()
        print('MultiActionBar_ShowAllGrids')
        updateGrids()
        C_Timer.After(2, updateGrids)
    end)
    hooksecurefunc('MultiActionBar_HideAllGrids', function()
        print('MultiActionBar_HideAllGrids')
        updateGrids()
        C_Timer.After(2, updateGrids)

    end)

    hooksecurefunc('ActionButton_ShowGrid', function(btn)
        print('ShowGrid', btn:GetName())
    end)

end

function Module.ChangeButtonSpacing()
    local spacing = 3 -- default: 6
    local buttonTable = {'MultiBarBottomRightButton', 'MultiBarBottomLeftButton', 'ActionButton'}
    for k, v in pairs(buttonTable) do
        for i = 2, 12 do _G[v .. i]:SetPoint('LEFT', _G[v .. (i - 1)], 'RIGHT', spacing, 0) end
    end
end

function Module.GetPetbarOffset()
    local localizedClass, englishClass, classIndex = UnitClass('player')

    -- 1=warrior, 2=paladin, 5=priest, 6=DK, 7=Shaman, 11=druid
    if (classIndex == 1 or classIndex == 2 or classIndex == 5 or classIndex == 6 or classIndex == 7 or classIndex == 11) then
        return 34
    else
        return 0
    end
end

function Module.HookPetBar()
    PetActionBarFrame:ClearAllPoints()
    PetActionBarFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    PetActionBarFrame.ignoreFramePositionManager = true

    SlidingActionBarTexture0:SetTexture('')
    SlidingActionBarTexture1:SetTexture('')

    -- frame:RegisterEvent('PET_BAR_UPDATE')

    for i = 1, 10 do
        _G['PetActionButton' .. i]:SetSize(30, 30)
        _G['PetActionButton' .. i .. 'NormalTexture2']:SetSize(50, 50)
    end

    local spacing = 7 -- default: 8
    for i = 2, 10 do
        _G['PetActionButton' .. i]:SetPoint('LEFT', _G['PetActionButton' .. (i - 1)], 'RIGHT', spacing, 0)
    end

    -- different offset for each class (stance vs no stance)
    -- local offset = 0 + 34
    -- local offset = Module.GetPetbarOffset()
    -- PetActionButton1:SetPoint('BOTTOMLEFT', MultiBarBottomRight, 'TOPLEFT', 0.5, 4 + offset)
end

function Module.MoveSideBarsDynamic(shouldMove)
    local gap = 3
    local delta = 70

    if shouldMove then
        local db = Module.db.profile
        local rows = db.sideRows
        local buttons = db.sideButtons
        -- print('dynamic', rows, buttons)

        -- right
        do
            for i = 1, 12 do
                local btn = _G['MultiBarRightButton' .. i]
                -- btn:Show()
                btn:ClearAllPoints()
            end

            local modulo = buttons % rows
            -- print('modulo', modulo)

            local index = 12
            local firstButtons = {}

            for i = 1, rows do
                local rowButtons = buttons / rows

                if i <= modulo then
                    rowButtons = math.ceil(rowButtons)
                else
                    rowButtons = math.floor(rowButtons)
                end
                -- print('row', i, rowButtons)

                for j = rowButtons, 1, -1 do
                    -- print('loop j=', j, index)
                    local btn = _G['MultiBarRightButton' .. (index)]
                    local btnNext = _G['MultiBarRightButton' .. (index - 1)]
                    btn:Show()
                    if j == 1 then
                        if i == 1 then
                            btn:SetPoint('LEFT', _G['ActionButton12'], 'RIGHT', delta, 0)
                            firstButtons[1] = btn
                        else
                            local anchor = firstButtons[i - 1]
                            btn:SetPoint('BOTTOM', anchor, 'TOP', 0, gap)
                            firstButtons[i] = btn

                        end
                    else
                        btn:SetPoint('LEFT', btnNext, 'RIGHT', gap, 0)
                    end

                    index = index - 1
                end
            end

            for i = index, 1, -1 do
                -- print('hide', i)
                local btn = _G['MultiBarRightButton' .. (index)]
                btn:Hide()
            end
        end

        -- left
        do
            for i = 1, 12 do
                local btn = _G['MultiBarLeftButton' .. i]
                -- btn:Show()
                btn:ClearAllPoints()
            end

            local modulo = buttons % rows
            -- print('modulo', modulo)

            local index = 12
            local firstButtons = {}

            for i = 1, rows do
                local rowButtons = buttons / rows

                if i <= modulo then
                    rowButtons = math.ceil(rowButtons)
                else
                    rowButtons = math.floor(rowButtons)
                end
                -- print('row', i, rowButtons)

                for j = rowButtons, 1, -1 do
                    -- print('loop j=', j, index)
                    local btn = _G['MultiBarLeftButton' .. (index)]
                    local btnNext = _G['MultiBarLeftButton' .. (index + 1)]
                    btn:Show()
                    if j == rowButtons then
                        if i == 1 then
                            btn:SetPoint('RIGHT', _G['ActionButton1'], 'LEFT', -delta, 0)
                            firstButtons[1] = btn
                        else
                            local anchor = firstButtons[i - 1]
                            btn:SetPoint('BOTTOM', anchor, 'TOP', 0, gap)
                            firstButtons[i] = btn

                        end
                    else
                        btn:SetPoint('RIGHT', btnNext, 'LEFT', -gap, 0)
                    end

                    index = index - 1
                end
            end

            for i = index, 1, -1 do
                -- print('hide', i)
                local btn = _G['MultiBarLeftButton' .. (index)]
                btn:Hide()
            end
        end
    else
        -- Default
        -- right
        _G['MultiBarRightButton1']:ClearAllPoints()
        _G['MultiBarRightButton1']:SetPoint('TOPRIGHT', MultiBarRight, 'TOPRIGHT', -2, -gap)

        for i = 2, 12 do
            _G['MultiBarRightButton' .. i]:ClearAllPoints()
            _G['MultiBarRightButton' .. i]:SetPoint('TOP', _G['MultiBarRightButton' .. (i - 1)], 'BOTTOM', 0, -gap)
        end

        -- left
        _G['MultiBarLeftButton1']:ClearAllPoints()
        _G['MultiBarLeftButton1']:SetPoint('TOPRIGHT', MultiBarLeft, 'TOPRIGHT', -2, -gap)

        for i = 2, 12 do
            _G['MultiBarLeftButton' .. i]:ClearAllPoints()
            _G['MultiBarLeftButton' .. i]:SetPoint('TOP', _G['MultiBarLeftButton' .. (i - 1)], 'BOTTOM', 0, -gap)
        end
    end
end

function Module.MoveSideBars(shouldMove)
    local gap = 3
    local delta = 70

    if shouldMove then
        -- right
        for i = 1, 12 do _G['MultiBarRightButton' .. i]:ClearAllPoints() end

        -- first row 1 2 3 4
        _G['MultiBarRightButton1']:SetPoint('LEFT', MultiBarBottomRightButton12, 'RIGHT', delta, 0)
        for i = 2, 4 do
            _G['MultiBarRightButton' .. i]:SetPoint('LEFT', _G['MultiBarRightButton' .. (i - 1)], 'RIGHT', gap, 0)
        end

        -- second row 5 6 7 8
        _G['MultiBarRightButton5']:SetPoint('TOP', _G['MultiBarRightButton1'], 'BOTTOM', 0, -gap)
        for i = 6, 8 do
            _G['MultiBarRightButton' .. i]:SetPoint('LEFT', _G['MultiBarRightButton' .. (i - 1)], 'RIGHT', gap, 0)
        end

        -- third row 9 10 11 12
        _G['MultiBarRightButton9']:SetPoint('TOP', _G['MultiBarRightButton5'], 'BOTTOM', 0, -gap)
        for i = 10, 12 do
            _G['MultiBarRightButton' .. i]:SetPoint('LEFT', _G['MultiBarRightButton' .. (i - 1)], 'RIGHT', gap, 0)
        end

        -- left
        for i = 1, 12 do _G['MultiBarLeftButton' .. i]:ClearAllPoints() end

        -- first row 1 2 3 4
        _G['MultiBarLeftButton4']:SetPoint('RIGHT', MultiBarBottomRightButton1, 'LEFT', -delta, 0)
        for i = 1, 3 do
            _G['MultiBarLeftButton' .. i]:SetPoint('RIGHT', _G['MultiBarLeftButton' .. (i + 1)], 'LEFT', -gap, 0)
        end

        -- second row 5 6 7 8
        _G['MultiBarLeftButton5']:SetPoint('TOP', _G['MultiBarLeftButton1'], 'BOTTOM', 0, -gap)
        for i = 6, 8 do
            _G['MultiBarLeftButton' .. i]:SetPoint('LEFT', _G['MultiBarLeftButton' .. (i - 1)], 'RIGHT', gap, 0)
        end

        -- third row 9 10 11 12
        _G['MultiBarLeftButton9']:SetPoint('TOP', _G['MultiBarLeftButton5'], 'BOTTOM', 0, -gap)
        for i = 10, 12 do
            _G['MultiBarLeftButton' .. i]:SetPoint('LEFT', _G['MultiBarLeftButton' .. (i - 1)], 'RIGHT', gap, 0)
        end
    else
        -- Default
        -- right
        _G['MultiBarRightButton1']:ClearAllPoints()
        _G['MultiBarRightButton1']:SetPoint('TOPRIGHT', MultiBarRight, 'TOPRIGHT', -2, -gap)

        for i = 2, 12 do
            _G['MultiBarRightButton' .. i]:ClearAllPoints()
            _G['MultiBarRightButton' .. i]:SetPoint('TOP', _G['MultiBarRightButton' .. (i - 1)], 'BOTTOM', 0, -gap)
        end

        -- left
        _G['MultiBarLeftButton1']:ClearAllPoints()
        _G['MultiBarLeftButton1']:SetPoint('TOPRIGHT', MultiBarLeft, 'TOPRIGHT', -2, -gap)

        for i = 2, 12 do
            _G['MultiBarLeftButton' .. i]:ClearAllPoints()
            _G['MultiBarLeftButton' .. i]:SetPoint('TOP', _G['MultiBarLeftButton' .. (i - 1)], 'BOTTOM', 0, -gap)
        end
    end
end

function Module.MoveSideBarsOLD()
    -- left
    local gap = 3
    local dx = 220
    _G['MultiBarLeftButton1']:ClearAllPoints()
    _G['MultiBarLeftButton1']:SetPoint('LEFT', ActionButton1, 'LEFT', -dx, 80)

    for i = 2, 4 do
        _G['MultiBarLeftButton' .. i]:ClearAllPoints()
        _G['MultiBarLeftButton' .. i]:SetPoint('LEFT', _G['MultiBarLeftButton' .. (i - 1)], 'RIGHT', gap, 0)
    end

    _G['MultiBarLeftButton5']:ClearAllPoints()
    _G['MultiBarLeftButton5']:SetPoint('LEFT', ActionButton1, 'LEFT', -dx, 40)
    for i = 6, 8 do
        _G['MultiBarLeftButton' .. i]:ClearAllPoints()
        _G['MultiBarLeftButton' .. i]:SetPoint('LEFT', _G['MultiBarLeftButton' .. (i - 1)], 'RIGHT', gap, 0)
    end

    _G['MultiBarLeftButton9']:ClearAllPoints()
    _G['MultiBarLeftButton9']:SetPoint('LEFT', ActionButton1, 'LEFT', -dx, 0)
    for i = 10, 12 do
        _G['MultiBarLeftButton' .. i]:ClearAllPoints()
        _G['MultiBarLeftButton' .. i]:SetPoint('LEFT', _G['MultiBarLeftButton' .. (i - 1)], 'RIGHT', gap, 0)
    end

    -- right
    local dxRight = dx - 4 * 36 - 3 * gap
    _G['MultiBarRightButton1']:ClearAllPoints()
    _G['MultiBarRightButton1']:SetPoint('LEFT', ActionButton12, 'RIGHT', dxRight, 80)

    for i = 2, 4 do
        _G['MultiBarRightButton' .. i]:ClearAllPoints()
        _G['MultiBarRightButton' .. i]:SetPoint('LEFT', _G['MultiBarRightButton' .. (i - 1)], 'RIGHT', gap, 0)
    end

    _G['MultiBarRightButton5']:ClearAllPoints()
    _G['MultiBarRightButton5']:SetPoint('LEFT', ActionButton12, 'RIGHT', dxRight, 40)
    for i = 6, 8 do
        _G['MultiBarRightButton' .. i]:ClearAllPoints()
        _G['MultiBarRightButton' .. i]:SetPoint('LEFT', _G['MultiBarRightButton' .. (i - 1)], 'RIGHT', gap, 0)
    end

    _G['MultiBarRightButton9']:ClearAllPoints()
    _G['MultiBarRightButton9']:SetPoint('LEFT', ActionButton12, 'RIGHT', dxRight, 0)
    for i = 10, 12 do
        _G['MultiBarRightButton' .. i]:ClearAllPoints()
        _G['MultiBarRightButton' .. i]:SetPoint('LEFT', _G['MultiBarRightButton' .. (i - 1)], 'RIGHT', gap, 0)
    end
end

-- TODO
function Module.MoveTotem()
    MultiCastActionBarFrame.ignoreFramePositionManager = true
    Module.Temp.TotemFixing = nil
    hooksecurefunc(MultiCastActionBarFrame, 'SetPoint', function()
        if Module.Temp.TotemFixing or InCombatLockdown() then return end
        Module.Temp.TotemFixing = true

        local db = Module.db.profile
        Module.UpdateTotemState(db.totem)

        Module.Temp.TotemFixing = nil
    end)
end

function Module.UpdatePossesbarState(state)
    PossessBarFrame.ignoreFramePositionManager = true

    local offset = (GetNumShapeshiftForms() > 0) and _G['DragonflightUIStancebar']:GetHeight() or 0
    local offset = state.offset and offset or 0

    PossessBarFrame:ClearAllPoints()
    local parent = _G[state.anchorFrame]
    PossessBarFrame:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y + offset)

    PossessBarFrame:SetScale(state.scale)
end

function Module:ActivateAllActionbars()
    Module:Print('ActivateAllActionbars', true);
    Settings.SetValue("PROXY_SHOW_ACTIONBAR_2", true)
    Settings.SetValue("PROXY_SHOW_ACTIONBAR_3", true)
    Settings.SetValue("PROXY_SHOW_ACTIONBAR_4", true)
    Settings.SetValue("PROXY_SHOW_ACTIONBAR_5", true)
    ReloadUI()
end

function Module:CheckActionbarSettingsCVars()
    -- print('Module:CheckActionbarSettingsCVars()')

    local allSet = true;

    for i = 2, 5 do
        local settingProxyName = 'PROXY_SHOW_ACTIONBAR_' .. i
        local value = Settings.GetValue(settingProxyName);
        -- print(settingProxyName, value)
        if not value then allSet = false end
    end

    if allSet then
        DF:Debug(self, '~~>> All Actionbars Set <3')
    else
        Module:RegisterChatCommand('ActivateActionbars', 'ActivateAllActionbars')

        C_Timer.After(2, function()
            --
            Module:Print([[At least one of the default 5 Actionbars is not activated.]])
            Module:Print([[Please activate them through the Blizzard options and let DragonflightUI handle it.]])
            Module:Print([[You can also type '/ActivateActionbars' to activate all at once (this also reloads the UI)]])
            Module:Print(
                [[Tip: If you dont need all 5 Actionbars, you can deactivate them through the Dragonflight Options like you would with Actionbar 6/7/8.]])
        end)
    end
end

function frame:OnEvent(event, arg1)
    -- print('event', event)
    if event == 'PLAYER_ENTERING_WORLD' then
        -- ActivateAllActionbars() 
    elseif event == 'SETTINGS_LOADED' then
        -- print('SETTINGS_LOADED')
        Module:CheckActionbarSettingsCVars()
    elseif event == 'PLAYER_REGEN_ENABLED' then
        --
        -- print('PLAYER_REGEN_ENABLED', self.ShouldUpdate)
        if frame.ShouldUpdate then
            local db = Module.db.profile
            local state = db.micro
            Module.MicroFrame:UpdateStateHandler(state)

            frame.ShouldUpdate = false
        end
    end
end
frame:SetScript('OnEvent', frame.OnEvent)
frame:RegisterEvent('PLAYER_REGEN_ENABLED')
frame:RegisterEvent('SETTINGS_LOADED')

local atlasActionbar = {
    ['UI-HUD-ActionBar-Gryphon-Left'] = {200, 188, 0.001953125, 0.697265625, 0.10205078125, 0.26513671875, false, false},
    ['UI-HUD-ActionBar-Gryphon-Right'] = {
        200, 188, 0.001953125, 0.697265625, 0.26611328125, 0.42919921875, false, false
    },
    ['UI-HUD-ActionBar-IconFrame-Slot'] = {
        128, 124, 0.701171875, 0.951171875, 0.10205078125, 0.16259765625, false, false
    },
    ['UI-HUD-ActionBar-Wyvern-Left'] = {200, 188, 0.001953125, 0.697265625, 0.43017578125, 0.59326171875, false, false},
    ['UI-HUD-ActionBar-Wyvern-Right'] = {200, 188, 0.001953125, 0.697265625, 0.59423828125, 0.75732421875, false, false}
}

function Module.CreateFrameFromAtlas(atlas, name, textureRef, frameName)
    local data = atlas[name]

    local f = CreateFrame('Frame', frameName, UIParent)
    f:SetSize(data[1], data[2])
    f:SetPoint('CENTER', UIParent, 'CENTER')

    f.texture = f:CreateTexture()
    f.texture:SetTexture(textureRef)
    f.texture:SetSize(data[1], data[2])
    f.texture:SetTexCoord(data[3], data[4], data[5], data[6])
    f.texture:SetPoint('CENTER')
    return f
end

function Module.ChangeGryphon()
    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()
    MainMenuBarTexture0:Hide()
    MainMenuBarTexture1:Hide()
    MainMenuBarTexture2:Hide()
    MainMenuBarTexture3:Hide()
end

function Module.DrawActionbarDeco()
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'
    for i = 1, 12 do
        local deco = Module.CreateFrameFromAtlas(atlasActionbar, 'UI-HUD-ActionBar-IconFrame-Slot', textureRef,
                                                 'ActionbarDeco' .. i)
        deco:SetScale(0.3)
        deco:SetPoint('CENTER', _G['ActionButton' .. i], 'CENTER', 0, 0)
        -- deco:SetParent(_G['ActionButton' .. i])
        deco:SetFrameStrata('LOW')
        _G['ActionButton' .. i].decoDF = deco
    end
end

-- Micromenu
function Module.SetButtonFromAtlas(frame, atlas, textureRef, pre, name)
    local key = pre .. name

    local up = atlas[key .. '-Up']
    frame:SetSize(up[1], up[2])
    frame:SetScale(0.7)
    frame:SetHitRectInsets(0, 0, 0, 0)

    frame:SetNormalTexture(textureRef)
    frame:GetNormalTexture():SetTexCoord(up[3], up[4], up[5], up[6])

    local disabled = atlas[key .. '-Disabled']
    frame:SetDisabledTexture(textureRef)
    frame:GetDisabledTexture():SetTexCoord(disabled[3], disabled[4], disabled[5], disabled[6])

    local down = atlas[key .. '-Down']
    frame:SetPushedTexture(textureRef)
    frame:GetPushedTexture():SetTexCoord(down[3], down[4], down[5], down[6])

    local mouseover = atlas[key .. '-Mouseover']
    frame:SetHighlightTexture(textureRef)
    frame:GetHighlightTexture():SetTexCoord(mouseover[3], mouseover[4], mouseover[5], mouseover[6])

    return frame
end

function Module.ChangeMicroMenu()
    local microFrame = CreateFrame('Frame', 'DragonflightUIMicroMenuBar', UIParent,
                                   'DragonflightUIMicroMenuFrameTemplate')
    -- microFrame:SetPoint('TOPLEFT', CharacterMicroButton, 'TOPLEFT', 0, 0)
    -- microFrame:SetPoint('BOTTOMRIGHT', HelpMicroButton, 'BOTTOMRIGHT', 0, 0)
    Module.MicroFrame = microFrame
end

function Module.UpdateTotemState(state)
    -- print('UpdateTotemState')
    Module.Temp.TotemFixing = true
    -- MultiCastActionBarFrame:SetPoint('BOTTOM', MultiBarBottomRight, 'TOP', 0, 5)

    local parent = _G[state.anchorFrame]
    MultiCastActionBarFrame:ClearAllPoints()
    MultiCastActionBarFrame:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

    MultiCastActionBarFrame:SetScale(state.scale)

    Module.Temp.TotemFixing = nil
end

function Module.UpdateFPSState(state)
    FramerateLabel:ClearAllPoints()
    if state.hideDefaultFPS then
        FramerateLabel:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 117 - 500)
    else
        FramerateLabel:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 117)
    end

    local fps = Module.FPSFrame

    if state.alwaysShowFPS then fps:Show() end

    if state.showPing then
        fps.PingLabel:Show()
        fps.PingText:Show()
    else
        fps.PingLabel:Hide()
        fps.PingText:Hide()
    end

    if not state.showFPS then fps:Hide() end
end

function Module.GetBagSlots(id)
    local build, _, _, _ = GetBuildInfo()
    if not GetContainerNumSlots then
        local slots = C_Container.GetContainerNumSlots(id)
        return slots
    else
        local slots = GetContainerNumSlots(id)
        return slots
    end
end

function Module.ChangeBackpack()
    local bagAtlas = 'Interface\\Addons\\DragonflightUI\\Textures\\bagslots2x'
    -- MainMenuBarBackpackButton
    do
        local texture = 'Interface\\Addons\\DragonflightUI\\Textures\\bigbag'
        local highlight = 'Interface\\Addons\\DragonflightUI\\Textures\\bigbagHighlight'

        MainMenuBarBackpackButton:SetScale(1.5)

        SetItemButtonTexture(MainMenuBarBackpackButton, texture)
        MainMenuBarBackpackButton:SetHighlightTexture(highlight)
        MainMenuBarBackpackButton:SetPushedTexture(highlight)
        MainMenuBarBackpackButton:SetCheckedTexture(highlight)

        MainMenuBarBackpackButtonNormalTexture:Hide()
        MainMenuBarBackpackButtonNormalTexture:SetTexture()

        if not MainMenuBarBackpackButton.Border then
            local cutout = 'Interface\\Addons\\DragonflightUI\\Textures\\bagslotCutout'

            local border = MainMenuBarBackpackButton:CreateTexture('DragonflightUIBigBagBorder')
            border:SetTexture(cutout)
            -- border:SetTexCoord(0, 96 / 128, 0, 96 / 128)
            -- border:SetSize(30, 30)
            -- border:SetPoint('CENTER', 2, -1 + 50)
            border:SetPoint('TOPLEFT', MainMenuBarBackpackButton, 'TOPLEFT', 0, 0)
            border:SetPoint('BOTTOMRIGHT', MainMenuBarBackpackButton, 'BOTTOMRIGHT', 0, 0)

            MainMenuBarBackpackButton.Border = border
        end
    end

    -- bags
    do
        CharacterBag0Slot:SetPoint('RIGHT', MainMenuBarBackpackButton, 'LEFT', -12, 0)

        for i = 1, 3 do
            local gap = 0
            _G['CharacterBag' .. i .. 'Slot']:SetPoint('RIGHT', _G['CharacterBag' .. (i - 1) .. 'Slot'], 'LEFT', -gap, 0)
        end

        for i = 0, 3 do
            local slot = _G['CharacterBag' .. i .. 'Slot']
            -- slot:SetParent(MainMenuBarBackpackButton)
            -- print(i, slot:GetSize())
            slot:SetScale(1)
            slot:SetSize(30, 30)

            local size = 30.5

            local normal = slot:GetNormalTexture()
            normal:SetTexture(bagAtlas)
            normal:SetTexCoord(0.576172, 0.695312, 0.5, 0.976562)
            normal:SetSize(size, size)
            normal:SetPoint('CENTER', 2, -1)
            normal:SetDrawLayer('BORDER', 0)
            -- normal:SetPoint('CENTER', 0, 0)

            -- normal:SetTexture()

            local highlight = slot:GetHighlightTexture()
            highlight:SetTexture(bagAtlas)
            highlight:SetTexCoord(0.699219, 0.818359, 0.0078125, 0.484375)
            highlight:SetSize(size, size)
            highlight:ClearAllPoints()
            highlight:SetPoint('CENTER', 2, -1)
            -- highlight:SetPoint('CENTER', 0, 0)

            -- DF:Dump(highlight:GetPoint(1))

            -- highlight:SetTexture()

            local checked = slot:GetCheckedTexture()
            checked:SetTexture(bagAtlas)
            checked:SetTexCoord(0.699219, 0.818359, 0.0078125, 0.484375)
            checked:SetSize(size, size)
            checked:ClearAllPoints()
            checked:SetPoint('CENTER', 2, -1)
            -- checked:SetPoint('CENTER', 0, 0)

            -- checked:SetTexture()

            local pushed = slot:GetPushedTexture()
            pushed:SetTexture(bagAtlas)
            pushed:SetTexCoord(0.576172, 0.695312, 0.5, 0.976562)
            pushed:SetSize(size, size)
            pushed:ClearAllPoints()
            pushed:SetPoint('CENTER', 2, -1)
            pushed:SetDrawLayer('BORDER', 0)

            -- TODO
            --[[ local circleMask = slot:CreateMaskTexture()
            circleMask:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\tempportraitalphamask')
            circleMask:SetPoint('TOPLEFT', 2, -2)
            circleMask:SetPoint('BOTTOMRIGHT', -4, 4)
            circleMask:SetSize(30, 30)
                                        ]]
            local iconTexture = _G['CharacterBag' .. i .. 'SlotIconTexture']
            -- _G['CharacterBag1SlotIconTexture']:GetSize()
            -- iconTexture:AddMaskTexture(circleMask)
            -- DF:Dump(iconTexture:GetPoint(1))
            iconTexture:ClearAllPoints()
            iconTexture:SetPoint('CENTER', 0, 0)

            local bagmask = 'Interface\\Addons\\DragonflightUI\\Textures\\bagmask'
            iconTexture:SetMask(bagmask)
            iconTexture:SetSize(30, 30)
            iconTexture:SetDrawLayer('BORDER', 2)

            if not slot.Border then
                local border = slot:CreateTexture('DragonflightUIBagBorder')
                border:SetTexture(bagAtlas)
                border:SetTexCoord(0.576172, 0.695312, 0.0078125, 0.484375)
                border:SetSize(size, size)
                border:SetPoint('CENTER', 2, -1)

                slot.Border = border
            end
        end
    end

    -- keyring
    if not DF.Cata then
        KeyRingButton:SetSize(30, 30)
        KeyRingButton:ClearAllPoints()
        KeyRingButton:SetPoint('RIGHT', _G['CharacterBag3Slot'], 'LEFT', 0, 0)
        KeyRingButton:SetScale(1)

        local size = 30.5

        local normal = KeyRingButton:GetNormalTexture()
        normal:SetTexture(bagAtlas)
        normal:SetTexCoord(0.822266, 0.941406, 0.0078125, 0.484375)
        normal:SetSize(size, size)
        normal:ClearAllPoints()
        normal:SetPoint('CENTER', 2, -1)
        normal:SetDrawLayer('BORDER', 0)

        local highlight = KeyRingButton:GetHighlightTexture()
        highlight:SetTexture(bagAtlas)
        highlight:SetTexCoord(0.699219, 0.818359, 0.0078125, 0.484375)
        highlight:SetSize(size, size)
        highlight:ClearAllPoints()
        highlight:SetPoint('CENTER', 2, -1)

        -- local checked = KeyRingButton:GetCheckedTexture()
        -- checked:Hide()

        local pushed = KeyRingButton:GetPushedTexture()
        pushed:SetTexture(bagAtlas)
        pushed:SetTexCoord(0.699219, 0.818359, 0.0078125, 0.484375)
        pushed:SetSize(size, size)
        pushed:ClearAllPoints()
        pushed:SetPoint('CENTER', 2, -1)
        -- pushed:SetDrawLayer('BORDER', 0)

        if not KeyRingButton.Icon then
            -- 237379   key icon
            local icon = KeyRingButton:CreateTexture('DragonflightUIKeyRingIconTexture')
            -- icon:SetTexture(135828)
            -- icon:SetTexture('Interface\\ContainerFrame\\KeyRing-Bag-Icon')
            icon:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\KeyRing-Bag-Icon')
            KeyRingButton.Icon = icon

            local delta = 6
            icon:SetSize(size - delta, size - delta)
            icon:SetPoint('CENTER', 0, 0)
            icon:SetDrawLayer('BORDER', 2)

            local bagmask = KeyRingButton:CreateMaskTexture('DragonflightUIKeyRingButtonMask')
            KeyRingButton.Mask = bagmask
            bagmask:SetAllPoints(icon)
            bagmask:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\bagmask')
            bagmask:SetSize(size - delta, size - delta)

            icon:AddMaskTexture(bagmask)
        end

        if not KeyRingButton.Border then
            local border = KeyRingButton:CreateTexture('DragonflightUIKeyRingBorder')
            border:SetTexture(bagAtlas)
            border:SetTexCoord(0.699219, 0.818359, 0.5, 0.976562)
            border:SetSize(size, size)
            border:SetPoint('CENTER', 2, -1)

            KeyRingButton.Border = border
        end

    end
end

function Module.UpdateBagSlotIcons()
    for i = 0, 3 do
        local slot = _G['CharacterBag' .. i .. 'Slot']
        local iconTexture = _G['CharacterBag' .. i .. 'SlotIconTexture']

        local slots = Module.GetBagSlots(i + 1)
        -- print('bag', i, slots)
        if slots == 0 then
            iconTexture:SetDrawLayer('BORDER', -1)
        else
            iconTexture:SetDrawLayer('BORDER', 2)
        end
    end
end

function Module.HookBags()
    -- from '\BlizzardInterfaceCode\Interface\FrameXML\ContainerFrame_Shared.lua'
    local UpdateContainerFrameAnchorsModified = function()
        -- CHANGE
        local CONTAINER_OFFSET_X_DF = ContainerFrame1.CONTAINER_OFFSET_X_DF or 0
        local CONTAINER_OFFSET_Y_DF = ContainerFrame1.CONTAINER_OFFSET_Y_DF or 92

        local db = Module.db.profile
        if db.bags.overrideBagAnchor then
            CONTAINER_OFFSET_X_DF = db.bags.offsetX
            CONTAINER_OFFSET_Y_DF = db.bags.offsetY
        end

        local VISIBLE_CONTAINER_SPACING_DF = ContainerFrame1.VISIBLE_CONTAINER_SPACING_DF or 3
        local CONTAINER_SPACING_DF = ContainerFrame1.CONTAINER_SPACING_DF or 0

        if Module.db.profile.changeSides then
        else
            CONTAINER_OFFSET_X_DF = CONTAINER_OFFSET_X
            -- CONTAINER_OFFSET_Y_DF = CONTAINER_OFFSET_Y
        end

        local frame, xOffset, yOffset, screenHeight, freeScreenHeight, leftMostPoint, column
        local screenWidth = GetScreenWidth()
        local containerScale = 1
        local leftLimit = 0
        if (BankFrame:IsShown()) then leftLimit = BankFrame:GetRight() - 25 end

        while (containerScale > CONTAINER_SCALE) do
            screenHeight = GetScreenHeight() / containerScale
            -- Adjust the start anchor for bags depending on the multibars          
            xOffset = CONTAINER_OFFSET_X_DF / containerScale
            yOffset = CONTAINER_OFFSET_Y_DF / containerScale
            -- freeScreenHeight determines when to start a new column of bags
            freeScreenHeight = screenHeight - yOffset
            leftMostPoint = screenWidth - xOffset
            column = 1
            local frameHeight
            for index, frameName in ipairs(ContainerFrame1.bags) do
                frameHeight = _G[frameName]:GetHeight()
                if (freeScreenHeight < frameHeight) then
                    -- Start a new column
                    column = column + 1
                    leftMostPoint = screenWidth - (column * CONTAINER_WIDTH * containerScale) - xOffset
                    freeScreenHeight = screenHeight - yOffset
                end
                freeScreenHeight = freeScreenHeight - frameHeight - VISIBLE_CONTAINER_SPACING_DF
            end
            if (leftMostPoint < leftLimit) then
                containerScale = containerScale - 0.01
            else
                break
            end
        end

        if (containerScale < CONTAINER_SCALE) then containerScale = CONTAINER_SCALE end

        screenHeight = GetScreenHeight() / containerScale
        -- Adjust the start anchor for bags depending on the multibars
        xOffset = CONTAINER_OFFSET_X_DF / containerScale
        yOffset = CONTAINER_OFFSET_Y_DF / containerScale
        -- freeScreenHeight determines when to start a new column of bags
        freeScreenHeight = screenHeight - yOffset
        column = 0
        for index, frameName in ipairs(ContainerFrame1.bags) do
            frame = _G[frameName]
            frame:SetScale(containerScale)
            if (index == 1) then
                -- First bag
                frame:SetPoint('BOTTOMRIGHT', frame:GetParent(), 'BOTTOMRIGHT', -xOffset, yOffset)
            elseif (freeScreenHeight < frame:GetHeight()) then
                -- Start a new column
                column = column + 1
                freeScreenHeight = screenHeight - yOffset
                frame:SetPoint('BOTTOMRIGHT', frame:GetParent(), 'BOTTOMRIGHT', -(column * CONTAINER_WIDTH) - xOffset,
                               yOffset)
            else
                -- Anchor to the previous bag
                frame:SetPoint('BOTTOMRIGHT', ContainerFrame1.bags[index - 1], 'TOPRIGHT', 0, CONTAINER_SPACING_DF)
            end
            freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING_DF
        end
    end

    hooksecurefunc('UpdateContainerFrameAnchors', UpdateContainerFrameAnchorsModified)
end

function Module.UpdateBagState(state)
    MainMenuBarBackpackButton:ClearAllPoints()
    MainMenuBarBackpackButton:SetPoint(state.anchor, state.anchorFrame, state.anchorParent, state.x, state.y)
    MainMenuBarBackpackButton:SetScale(1.5 * state.scale)

    for i = 0, 3 do
        local slot = _G['CharacterBag' .. i .. 'Slot']
        slot:SetScale(state.scale)
    end

    if state.hidden then
        MainMenuBarBackpackButton:Hide()
        Module.BagBarExpandToggled(state.expanded, true)
    else
        MainMenuBarBackpackButton:Show()
        Module.BagBarExpandToggled(state.expanded, false)
    end

    local toggle = Module.FrameBagToggle
    if state.hideArrow then
        toggle:Hide()
        CharacterBag0Slot:SetPoint('RIGHT', MainMenuBarBackpackButton, 'LEFT', 0, 0)
    else
        toggle:Show()
        CharacterBag0Slot:SetPoint('RIGHT', MainMenuBarBackpackButton, 'LEFT', -12, 0)
    end

    if state.overrideBagAnchor and ContainerFrame1:IsVisible() then UpdateContainerFrameAnchors() end

    MainMenuBarBackpackButton:UpdateStateHandler(state)
end

function Module.MoveBars()
    MainMenuBarBackpackButton:ClearAllPoints()
    MainMenuBarBackpackButton:SetPoint('BOTTOMRIGHT', UIParent, 0, 26)

    if DF.Wrath then
        CharacterMicroButton:ClearAllPoints()
        CharacterMicroButton:SetPoint('BOTTOMRIGHT', UIParent, -300 + 5, 0)
    elseif DF.Era then
        CharacterMicroButton:ClearAllPoints()
        CharacterMicroButton:SetPoint('BOTTOMRIGHT', UIParent, -300 + 95, 0)
    else
        CharacterMicroButton:ClearAllPoints()
        CharacterMicroButton:SetPoint('BOTTOMRIGHT', UIParent, -300 + 5, 0)
    end

    -- CharacterMicroButton.SetPoint = noop
    -- CharacterMicroButton.ClearAllPoints = noop

    if DF.Wrath then
        PVPMicroButton.SetPoint = noop
        PVPMicroButton.ClearAllPoints = noop
    end
end

local frameBagToggle = CreateFrame('Button', 'DragonflightUIBagToggleFrame', MainMenuBarBackpackButton)
Module.FrameBagToggle = frameBagToggle

function Module.CreateBagExpandButton()
    local point, relativePoint = 'RIGHT', 'LEFT'
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\bagslots2x'

    local f = Module.FrameBagToggle
    f:SetSize(16, 30)
    f:SetScale(0.5 / 1.5)
    f:ClearAllPoints()
    f:SetPoint(point, MainMenuBarBackpackButton, relativePoint)

    f:SetNormalTexture(base)
    f:SetPushedTexture(base)
    f:SetHighlightTexture(base)
    f:GetNormalTexture():SetTexCoord(0.951171875, 0.982421875, 0.015625, 0.25)
    f:GetHighlightTexture():SetTexCoord(0.951171875, 0.982421875, 0.015625, 0.25)
    f:GetPushedTexture():SetTexCoord(0.951171875, 0.982421875, 0.015625, 0.25)

    f:SetScript('OnClick', function()
        setOption({'bags', 'expanded'}, not Module.db.profile.bags.expanded)
        -- Module.BagBarExpandToggled(Module.db.profile.bagsExpanded)
    end)
    f:RegisterEvent('BAG_UPDATE_DELAYED')
    f:RegisterEvent('PLAYER_ENTERING_WORLD')
    f:RegisterUnitEvent('UNIT_ENTERED_VEHICLE', 'player')
    f:RegisterUnitEvent('UNIT_EXITED_VEHICLE', 'player')
end

function frameBagToggle:OnEvent(event, arg1)
    if event == 'BAG_UPDATE_DELAYED' then
        Module.RefreshBagBarToggle()
        Module.UpdateBagSlotIcons()
        -- print('BAG_UPDATE_DELAYED')
    elseif event == 'PLAYER_ENTERING_WORLD' then
        Module.UpdateBagSlotIcons()
    elseif event == 'UNIT_ENTERED_VEHICLE' then
        frameBagToggle:Hide()
    elseif event == 'UNIT_EXITED_VEHICLE' then
        frameBagToggle:Show()
    end
end
frameBagToggle:SetScript('OnEvent', frameBagToggle.OnEvent)

function Module.BagBarExpandToggled(expanded, hidden)
    local rotation

    if (expanded) then
        rotation = math.pi
    else
        rotation = 0
    end

    local f = Module.FrameBagToggle

    f:GetNormalTexture():SetRotation(rotation)
    f:GetPushedTexture():SetRotation(rotation)
    f:GetHighlightTexture():SetRotation(rotation)

    for i = 0, 3 do
        if (expanded and not hidden) then
            _G['CharacterBag' .. i .. 'Slot']:Show()
            if not DF.Cata then KeyRingButton:Show() end
        else
            _G['CharacterBag' .. i .. 'Slot']:Hide()
            if not DF.Cata then KeyRingButton:Hide() end
        end
    end
end

function Module.RefreshBagBarToggle()
    Module.BagBarExpandToggled(Module.db.profile.bags.expanded, Module.db.profile.bags.hidden)
end

function Module.ChangeFramerate()
    UIPARENT_MANAGED_FRAME_POSITIONS.FramerateLabel = nil

    -- fps
    local Path, Size, Flags = FramerateText:GetFont()

    local fps = CreateFrame('Frame', 'DragonflightUIFPSTextFrame', Module.MicroFrame)
    fps:SetSize(65, 26)
    fps:SetPoint('RIGHT', CharacterMicroButton, 'LEFT', -10, 0)

    Module.FPSFrame = fps

    do
        local t = fps:CreateFontString('FPSLabel', 'OVERLAY', 'SystemFont_Shadow_Med1')
        t:SetPoint('TOPLEFT', 0, 0)
        t:SetText('FPS:')
        t:SetFont(Path, Size, Flags)

        fps.FPSLabel = t
    end

    do
        local t = fps:CreateFontString('PingLabel', 'OVERLAY', 'SystemFont_Shadow_Med1')
        t:SetPoint('TOPLEFT', fps.FPSLabel, 'BOTTOMLEFT', 0, 0)
        t:SetText('MS:')
        t:SetFont(Path, Size, Flags)

        fps.PingLabel = t
    end

    do
        local t = fps:CreateFontString('FPSText', 'OVERLAY', 'SystemFont_Shadow_Med1')
        t:SetPoint('TOPRIGHT', fps, 'TOPRIGHT', 0, 0)
        t:SetText('')
        t:SetFont(Path, Size, Flags)

        fps.FPSText = t
    end

    do
        local t = fps:CreateFontString('PingText', 'OVERLAY', 'SystemFont_Shadow_Med1')
        t:SetPoint('TOPRIGHT', fps.FPSText, 'BOTTOMRIGHT', 0, 0)
        t:SetText('')
        t:SetFont(Path, Size, Flags)

        fps.PingText = t
    end

    fps:SetScript('OnUpdate', function(self, elapsed)
        if (fps:IsShown()) then
            local timeLeft = fps.fpsTime - elapsed
            if (timeLeft <= 0) then
                fps.fpsTime = FRAMERATE_FREQUENCY;

                local framerate = GetFramerate();
                fps.FPSText:SetFormattedText("%.1f", framerate);

                local down, up, lagHome, lagWorld = GetNetStats()
                -- local str = 'MS: ' .. lagHome .. '|' .. lagWorld
                local str = tostring(math.max(lagHome, lagWorld))
                fps.PingText:SetText(str)
            else
                fps.fpsTime = timeLeft;
            end
        end
    end)
    fps.fpsTime = 0;
    fps:Hide()

    hooksecurefunc('ToggleFramerate', function()
        local fps = Module.FPSFrame
        local state = Module.db.profile.micro

        if (fps:IsShown()) then
            fps:Hide()
        else
            fps:Show()
        end

        Module.UpdateFPSState(state)
    end)
end

-- WRATH
function Module.Wrath()
    Module.ChangeActionbar()
    Module.CreateNewXPBar()
    Module.CreateNewRepBar()

    Module.HookPetBar()
    Module.MoveTotem()
    -- Module.ChangePossessBar()

    frame:RegisterEvent('PLAYER_REGEN_ENABLED')
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")

    Module.ChangeGryphon()
    -- Module.DrawActionbarDeco()

    Module.ChangeMicroMenu()
    Module.ChangeBackpack()
    Module.MoveBars()
    Module.ChangeFramerate()
    Module.CreateBagExpandButton()
    Module.RefreshBagBarToggle()
    Module.HookBags()
end

-- ERA
function Module.Era()
    Module.ChangeActionbar()
    Module.CreateNewXPBar()
    Module.CreateNewRepBar()

    Module.HookPetBar()
    -- Module.MoveTotem()
    -- Module.ChangePossessBar()

    frame:RegisterEvent('PLAYER_REGEN_ENABLED')
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")

    Module.ChangeGryphon()
    -- Module.DrawActionbarDeco()

    -- Module.ChangeMicroMenu()
    Module.ChangeBackpack()
    Module.MoveBars()
    Module.ChangeFramerate()
    Module.CreateBagExpandButton()
    Module.RefreshBagBarToggle()
    Module.HookBags()
end
