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
            hideAlways = true,
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
            hideAlways = true,
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
            hideAlways = true,
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
            offset = true,
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
            x = -320,
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
if DF.Cata then
    defaults.profile.micro.x = -320
elseif DF.Wrath then
    defaults.profile.micro.x = -294
elseif DF.Era then
    defaults.profile.micro.x = -205
end

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
local ActionBarSettingsTogglesCache = nil;
local ActionBarSettingsLastCacheTime = 0;
local ActionBarSettingsCacheTimeout = 10;

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

local function SetActionBarToggle(index, value)
    -- Use local cache instead of GetActionBarToggles since it could lead to inconsistencies between UI and server state.
    -- If SetActionBarToggle is called multiple times before the server has mirrored the data back to the client, the client will send an outdated mask to the server and clear out values that were just set.
    -- Timeout the cache so we use latest mirror data after a period of time. This is incase actionbar toggles are set through macros or other addons, we need to make sure the settings still syncs with mirror data.
    if ((ActionBarSettingsTogglesCache == nil) or
        (GetTime() - ActionBarSettingsLastCacheTime > ActionBarSettingsCacheTimeout)) then
        ActionBarSettingsTogglesCache = {GetActionBarToggles()};
    end

    -- reset cache timeout each time set actionbar is called so that it doesnt timeout while toggling quickly
    ActionBarSettingsLastCacheTime = GetTime();

    ActionBarSettingsTogglesCache[index] = value;

    _G[actionBars[index].uvar] = value;

    SetActionBarToggles(unpack(ActionBarSettingsTogglesCache));
    MultiActionBar_Update();
end

local function ActivateAllActionbars()
    -- TODO: better system, without taint
    if true then return end
    -- SHOW_MULTI_ACTIONBAR_1 = true
    -- SHOW_MULTI_ACTIONBAR_2 = true
    -- SHOW_MULTI_ACTIONBAR_3 = true
    -- SHOW_MULTI_ACTIONBAR_4 = true
    ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
    SetActionBarToggles(1, 1, 1, 1, 1)
    ---@diagnostic disable-next-line: missing-parameter
    SetActionBarToggles(true, true, true, true, true)
    MultiActionBar_Update()
end

local function GetActionBarToggle(index)
    return select(index, GetActionBarToggles());
end

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
                order = 4
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
                order = 2
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
                order = 3
            },
            x = {
                type = 'range',
                name = 'X',
                desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', barname),
                min = -2500,
                max = 2500,
                bigStep = 1,
                order = 5
            },
            y = {
                type = 'range',
                name = 'Y',
                desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', barname),
                min = -2500,
                max = 2500,
                bigStep = 1,
                order = 6
            },
            orientation = {
                type = 'select',
                name = 'Orientation',
                desc = 'Orientation' .. getDefaultStr('orientation', barname),
                values = {['horizontal'] = 'Horizontal', ['vertical'] = 'Vertical'},
                order = 7
            },
            reverse = {
                type = 'toggle',
                name = 'Reverse Button order',
                desc = '' .. getDefaultStr('reverse', barname),
                order = 7.5
            },
            buttonScale = {
                type = 'range',
                name = 'ButtonScale',
                desc = '' .. getDefaultStr('buttonScale', barname),
                min = 0.1,
                max = 3,
                bigStep = 0.05,
                order = 1
            },
            rows = {
                type = 'range',
                name = '# of Rows',
                desc = '' .. getDefaultStr('rows', barname),
                min = 1,
                max = 12,
                bigStep = 1,
                order = 9
            },
            buttons = {
                type = 'range',
                name = '# of Buttons',
                desc = '' .. getDefaultStr('buttons', barname),
                min = 1,
                max = 12,
                bigStep = 1,
                order = 10
            },
            padding = {
                type = 'range',
                name = 'Padding',
                desc = '' .. getDefaultStr('padding', barname),
                min = 0,
                max = 10,
                bigStep = 1,
                order = 11
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
                order = 51.2
            },
            hideScrolling = {
                type = 'toggle',
                name = 'Hide bar scrolling',
                desc = '' .. getDefaultStr('hideScrolling', barname),
                order = 51.3
            },
            gryphons = {
                type = 'select',
                name = 'Gryphons',
                desc = 'Gryphons' .. getDefaultStr('gryphons', barname),
                values = {['DEFAULT'] = 'DEFAULT', ['ALLY'] = 'ALLIANCE', ['HORDE'] = 'HORDE', ['NONE'] = 'NONE'},
                order = 51.4
            },
            range = {
                type = 'toggle',
                name = 'Icon Range Color',
                desc = 'Changes the Icon color when Out Of Range, similar to RedRange/tullaRange' ..
                    getDefaultStr('range', barname),
                order = 51.1
            }
        }

        for k, v in pairs(moreOptions) do opt.args[k] = v end
    elseif n <= 5 and false then
        local moreOptions = {
            activate = {
                type = 'toggle',
                name = actionBars[n - 1].label,
                desc = actionBars[n - 1].tooltip,
                order = 13,
                blizzard = true
            }
        }

        for k, v in pairs(moreOptions) do opt.args[k] = v end

        opt.get = function(info)
            local key = info[1]
            local sub = info[2]

            if sub == 'activate' then
                return GetActionBarToggle(n - 1)
            else
                return getOption(info)
            end
        end

        opt.set = function(info, value)
            local key = info[1]
            local sub = info[2]

            if sub == 'activate' then
                SetActionBarToggle(n - 1, value)
            else
                setOption(info, value)
            end
        end
    else
        local moreOptions = {activate = {type = 'toggle', name = 'Action Bar ' .. n, desc = '', order = 13, new = true}}

        -- for k, v in pairs(moreOptions) do opt.args[k] = v end
    end

    -- AddStateTable(opt, barname, 'Actionbar' .. n)
    DragonflightUIStateHandlerMixin:AddStateTable(Module, opt, barname, 'Actionbar' .. n, getDefaultStr)

    return opt
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
            order = 4
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
            order = 2
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
            order = 3
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'pet'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'pet'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6
        },
        orientation = {
            type = 'select',
            name = 'Orientation',
            desc = 'Orientation' .. getDefaultStr('orientation', 'pet'),
            values = {['horizontal'] = 'Horizontal', ['vertical'] = 'Vertical'},
            order = 7
        },
        buttonScale = {
            type = 'range',
            name = 'ButtonScale',
            desc = '' .. getDefaultStr('buttonScale', 'pet'),
            min = 0.1,
            max = 3,
            bigStep = 0.05,
            order = 1
        },
        rows = {
            type = 'range',
            name = '# of Rows',
            desc = '' .. getDefaultStr('rows', 'pet'),
            min = 1,
            max = 12,
            bigStep = 1,
            order = 9
        },
        buttons = {
            type = 'range',
            name = '# of Buttons',
            desc = '' .. getDefaultStr('buttons', 'pet'),
            min = 1,
            max = 10,
            bigStep = 1,
            order = 10
        },
        padding = {
            type = 'range',
            name = 'Padding',
            desc = '' .. getDefaultStr('padding', 'pet'),
            min = 0,
            max = 10,
            bigStep = 1,
            order = 11
        },
        alwaysShow = {
            type = 'toggle',
            name = 'Always show Actionbar',
            desc = '' .. getDefaultStr('alwaysShow', 'pet'),
            order = 12
        },
        hideMacro = {
            type = 'toggle',
            name = 'Hide Macro Text',
            desc = '' .. getDefaultStr('hideMacro', 'pet'),
            order = 16
        },
        hideKeybind = {
            type = 'toggle',
            name = 'Hide Keybind Text',
            desc = '' .. getDefaultStr('hideKeybind', 'pet'),
            order = 17
        }
    }
}
DragonflightUIStateHandlerMixin:AddStateTable(Module, petOptions, 'pet', 'PetBar', getDefaultStr)

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
            order = 1
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'xp'),
            values = frameTableWithout('DragonflightUIXPBar'),
            order = 4
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
            order = 2
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
            order = 3
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'xp'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'xp'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6
        },
        width = {
            type = 'range',
            name = 'Width',
            desc = '' .. getDefaultStr('width', 'xp'),
            min = 1,
            max = 2500,
            bigStep = 1,
            order = 7
        },
        height = {
            type = 'range',
            name = 'Height',
            desc = '' .. getDefaultStr('height', 'xp'),
            min = 1,
            max = 69,
            bigStep = 1,
            order = 8
        },
        alwaysShowXP = {
            type = 'toggle',
            name = 'Always show XP text',
            desc = '' .. getDefaultStr('alwaysShowXP', 'xp'),
            order = 12
        },
        showXPPercent = {
            type = 'toggle',
            name = 'Show XP Percent',
            desc = '' .. getDefaultStr('showXPPercent', 'xp'),
            order = 13
        }
    }
}
DragonflightUIStateHandlerMixin:AddStateTable(Module, xpOptions, 'xp', 'XPBar', getDefaultStr)

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
            order = 1
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'rep'),
            values = frameTableWithout('DragonflightUIRepBar'),
            order = 4
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
            order = 2
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
            order = 3
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'rep'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'rep'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6
        },
        width = {
            type = 'range',
            name = 'Width',
            desc = '' .. getDefaultStr('width', 'rep'),
            min = 1,
            max = 2500,
            bigStep = 1,
            order = 7
        },
        height = {
            type = 'range',
            name = 'Height',
            desc = '' .. getDefaultStr('height', 'rep'),
            min = 1,
            max = 69,
            bigStep = 1,
            order = 8
        },
        alwaysShowRep = {
            type = 'toggle',
            name = 'Always show Rep text',
            desc = '' .. getDefaultStr('alwaysShowRep', 'rep'),
            order = 12
        }
    }
}
DragonflightUIStateHandlerMixin:AddStateTable(Module, repOptions, 'rep', 'RepBar', getDefaultStr)

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
            order = 4
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
            order = 2
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
            order = 3
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'stance'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'stance'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6
        },
        orientation = {
            type = 'select',
            name = 'Orientation',
            desc = 'Orientation' .. getDefaultStr('orientation', 'stance'),
            values = {['horizontal'] = 'Horizontal', ['vertical'] = 'Vertical'},
            order = 7
        },
        buttonScale = {
            type = 'range',
            name = 'ButtonScale',
            desc = '' .. getDefaultStr('buttonScale', 'stance'),
            min = 0.1,
            max = 3,
            bigStep = 0.05,
            order = 1
        },
        rows = {
            type = 'range',
            name = '# of Rows',
            desc = '' .. getDefaultStr('rows', 'stance'),
            min = 1,
            max = 12,
            bigStep = 1,
            order = 9
        },
        buttons = {
            type = 'range',
            name = '# of Buttons',
            desc = '' .. getDefaultStr('buttons', 'stance'),
            min = 1,
            max = 10,
            bigStep = 1,
            order = 10
        },
        padding = {
            type = 'range',
            name = 'Padding',
            desc = '' .. getDefaultStr('padding', 'stance'),
            min = 0,
            max = 10,
            bigStep = 1,
            order = 11
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
            order = 1
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'totem'),
            values = frameTable,
            order = 4
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
            order = 2
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
            order = 3
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'totem'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'totem'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6
        }
    }
}
DragonflightUIStateHandlerMixin:AddStateTable(Module, totemOptions, 'totem', 'TotemBar', getDefaultStr)

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
            order = 1
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'possess'),
            values = frameTable,
            order = 4
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
            order = 2
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
            order = 3
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'possess'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'possess'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6
        },
        offset = {
            type = 'toggle',
            name = 'Auto adjust offset',
            desc = 'Auto add some Y offset depending on the class, e.g. on Paladin to make room for the stance bar' ..
                getDefaultStr('offset', 'possess'),
            order = 11,
            new = true
        }
    }
}
DragonflightUIStateHandlerMixin:AddStateTable(Module, possessOptions, 'possess', 'PossessBar', getDefaultStr)

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
            order = 1
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'bags'),
            values = frameTable,
            order = 4
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
            order = 2
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
            order = 3
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'bags'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'bags'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6
        },
        expanded = {type = 'toggle', name = 'Expanded', desc = '' .. getDefaultStr('expanded', 'bags'), order = 7},
        hideArrow = {type = 'toggle', name = 'HideArrow', desc = '' .. getDefaultStr('hideArrow', 'bags'), order = 8},
        hidden = {
            type = 'toggle',
            name = 'Hidden',
            desc = 'Backpack hidden' .. getDefaultStr('hidden', 'bags'),
            order = 9
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
            order = 1
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'micro'),
            values = frameTable,
            order = 4
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
            order = 2
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
            order = 3
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'micro'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'micro'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6
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
    ActivateAllActionbars()

    Module.Temp = {}
    Module.UpdateRangeHooked = false
    if DF.Wrath then
        Module.Wrath()
    else
        Module.Era()
    end
    Module:SetupActionbarFrames()
    Module.AddStateUpdater()
    Module:ApplySettings()
    Module:RegisterOptionScreens()

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)
        Module:ApplySettings()
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
        local bar = CreateFrame('FRAME', 'DragonflightUIStancebar', UIParent, 'DragonflightUIActionbarFrameTemplate')
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
    microFrame:InitStateHandler(4, 4)

    table.insert(Module.MicroButtons, CharacterMicroButton)
    table.insert(Module.MicroButtons, PVPMicroButton)

    for k, v in ipairs(Module.MicroButtons) do
        --
        -- print(k, v:GetName())
        -- v:SetParent(microFrame)
        microFrame:SetHideFrame(v, k)
    end

    C_Timer.After(0, function()
        local db = Module.db.profile
        local state = db.micro
        Module.MicroFrame:UpdateStateHandler(state)
    end)
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
end

function Module:ApplySettings()
    local db = Module.db.profile
    -- Module.ChangeGryphonVisibility(db.showGryphon)

    local MinimapModule = DF:GetModule('Minimap')
    -- if MinimapModule and MinimapModule:IsEnabled() then MinimapModule.MoveTrackerFunc() end

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
    Module.UpdateMicromenuState(db.micro)

    Module.UpdatePossesbarState(db.possess)
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

function frame:OnEvent(event, arg1)
    -- print('event', event)
    if event == 'PLAYER_ENTERING_WORLD' then
        -- ActivateAllActionbars()
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

Module.MicromenuAtlas = {
    ["UI-HUD-MicroMenu-Achievements-Disabled"] = {
        16, 20, 0.000976562, 0.0634766, 0.00195312, 0.162109, false, false, "2x"
    },
    ["UI-HUD-MicroMenu-Achievements-Down"] = {16, 20, 0.000976562, 0.0634766, 0.166016, 0.326172, false, false, "2x"},
    ["UI-HUD-MicroMenu-Achievements-Mouseover"] = {
        16, 20, 0.000976562, 0.0634766, 0.330078, 0.490234, false, false, "2x"
    },
    ["UI-HUD-MicroMenu-Achievements-Up"] = {16, 20, 0.000976562, 0.0634766, 0.494141, 0.654297, false, false, "2x"},
    ["UI-HUD-MicroMenu-AdventureGuide-Disabled"] = {
        16, 20, 0.000976562, 0.0634766, 0.658203, 0.818359, false, false, "2x"
    },
    ["UI-HUD-MicroMenu-AdventureGuide-Down"] = {16, 20, 0.000976562, 0.0634766, 0.822266, 0.982422, false, false, "2x"},
    ["UI-HUD-MicroMenu-AdventureGuide-Mouseover"] = {
        16, 20, 0.0654297, 0.12793, 0.00195312, 0.162109, false, false, "2x"
    },
    ["UI-HUD-MicroMenu-AdventureGuide-Up"] = {16, 20, 0.0654297, 0.12793, 0.166016, 0.326172, false, false, "2x"},
    ["UI-HUD-MicroMenu-Collections-Disabled"] = {16, 20, 0.0654297, 0.12793, 0.658203, 0.818359, false, false, "2x"},
    ["UI-HUD-MicroMenu-Collections-Down"] = {16, 20, 0.0654297, 0.12793, 0.822266, 0.982422, false, false, "2x"},
    ["UI-HUD-MicroMenu-Collections-Mouseover"] = {16, 20, 0.129883, 0.192383, 0.00195312, 0.162109, false, false, "2x"},
    ["UI-HUD-MicroMenu-Collections-Up"] = {16, 20, 0.129883, 0.192383, 0.166016, 0.326172, false, false, "2x"},
    ["UI-HUD-MicroMenu-Communities-Icon-Notification"] = {
        7, 7, 0.581055, 0.608398, 0.166016, 0.220703, false, false, "2x"
    },
    ["UI-HUD-MicroMenu-GameMenu-Disabled"] = {16, 20, 0.129883, 0.192383, 0.330078, 0.490234, false, false, "2x"},
    ["UI-HUD-MicroMenu-GameMenu-Down"] = {16, 20, 0.129883, 0.192383, 0.494141, 0.654297, false, false, "2x"},
    ["UI-HUD-MicroMenu-GameMenu-Mouseover"] = {16, 20, 0.129883, 0.192383, 0.658203, 0.818359, false, false, "2x"},
    ["UI-HUD-MicroMenu-GameMenu-Up"] = {16, 20, 0.129883, 0.192383, 0.822266, 0.982422, false, false, "2x"},
    ["UI-HUD-MicroMenu-Groupfinder-Disabled"] = {16, 20, 0.194336, 0.256836, 0.00195312, 0.162109, false, false, "2x"},
    ["UI-HUD-MicroMenu-Groupfinder-Down"] = {16, 20, 0.194336, 0.256836, 0.166016, 0.326172, false, false, "2x"},
    ["UI-HUD-MicroMenu-Groupfinder-Mouseover"] = {16, 20, 0.194336, 0.256836, 0.330078, 0.490234, false, false, "2x"},
    ["UI-HUD-MicroMenu-Groupfinder-Up"] = {16, 20, 0.194336, 0.256836, 0.494141, 0.654297, false, false, "2x"},
    ["UI-HUD-MicroMenu-GuildCommunities-Disabled"] = {
        16, 20, 0.194336, 0.256836, 0.658203, 0.818359, false, false, "2x"
    },
    ["UI-HUD-MicroMenu-GuildCommunities-Down"] = {16, 20, 0.194336, 0.256836, 0.822266, 0.982422, false, false, "2x"},
    ["UI-HUD-MicroMenu-GuildCommunities-Mouseover"] = {
        16, 20, 0.258789, 0.321289, 0.658203, 0.818359, false, false, "2x"
    },
    ["UI-HUD-MicroMenu-GuildCommunities-Up"] = {16, 20, 0.258789, 0.321289, 0.822266, 0.982422, false, false, "2x"},
    ["UI-HUD-MicroMenu-Highlightalert"] = {16, 20, 0.323242, 0.385742, 0.00195312, 0.162109, false, false, "2x"},
    ["UI-HUD-MicroMenu-Questlog-Disabled"] = {16, 20, 0.323242, 0.385742, 0.494141, 0.654297, false, false, "2x"},
    ["UI-HUD-MicroMenu-Questlog-Down"] = {16, 20, 0.323242, 0.385742, 0.658203, 0.818359, false, false, "2x"},
    ["UI-HUD-MicroMenu-Questlog-Mouseover"] = {16, 20, 0.323242, 0.385742, 0.822266, 0.982422, false, false, "2x"},
    ["UI-HUD-MicroMenu-Questlog-Up"] = {16, 20, 0.387695, 0.450195, 0.00195312, 0.162109, false, false, "2x"},
    ["UI-HUD-MicroMenu-Shop-Disabled"] = {16, 20, 0.387695, 0.450195, 0.166016, 0.326172, false, false, "2x"},
    ["UI-HUD-MicroMenu-Shop-Mouseover"] = {16, 20, 0.387695, 0.450195, 0.330078, 0.490234, false, false, "2x"},
    ["UI-HUD-MicroMenu-Shop-Down"] = {16, 20, 0.387695, 0.450195, 0.494141, 0.654297, false, false, "2x"},
    ["UI-HUD-MicroMenu-Shop-Up"] = {16, 20, 0.387695, 0.450195, 0.658203, 0.818359, false, false, "2x"},
    ["UI-HUD-MicroMenu-SpecTalents-Disabled"] = {16, 20, 0.387695, 0.450195, 0.822266, 0.982422, false, false, "2x"},
    ["UI-HUD-MicroMenu-SpecTalents-Down"] = {16, 20, 0.452148, 0.514648, 0.00195312, 0.162109, false, false, "2x"},
    ["UI-HUD-MicroMenu-SpecTalents-Mouseover"] = {16, 20, 0.452148, 0.514648, 0.166016, 0.326172, false, false, "2x"},
    ["UI-HUD-MicroMenu-SpecTalents-Up"] = {16, 20, 0.452148, 0.514648, 0.330078, 0.490234, false, false, "2x"},
    ["UI-HUD-MicroMenu-SpellbookAbilities-Disabled"] = {
        16, 20, 0.452148, 0.514648, 0.494141, 0.654297, false, false, "2x"
    },
    ["UI-HUD-MicroMenu-SpellbookAbilities-Down"] = {16, 20, 0.452148, 0.514648, 0.658203, 0.818359, false, false, "2x"},
    ["UI-HUD-MicroMenu-SpellbookAbilities-Mouseover"] = {
        16, 20, 0.452148, 0.514648, 0.822266, 0.982422, false, false, "2x"
    },
    ["UI-HUD-MicroMenu-SpellbookAbilities-Up"] = {16, 20, 0.516602, 0.579102, 0.00195312, 0.162109, false, false, "2x"},
    ["UI-HUD-MicroMenu-StreamDLGreen-Down"] = {16, 20, 0.516602, 0.579102, 0.166016, 0.326172, false, false, "2x"},
    ["UI-HUD-MicroMenu-StreamDLGreen-Up"] = {16, 20, 0.516602, 0.579102, 0.330078, 0.490234, false, false, "2x"},
    ["UI-HUD-MicroMenu-StreamDLRed-Down"] = {16, 20, 0.516602, 0.579102, 0.494141, 0.654297, false, false, "2x"},
    ["UI-HUD-MicroMenu-StreamDLRed-Up"] = {16, 20, 0.516602, 0.579102, 0.658203, 0.818359, false, false, "2x"},
    ["UI-HUD-MicroMenu-StreamDLYellow-Down"] = {16, 20, 0.516602, 0.579102, 0.822266, 0.982422, false, false, "2x"},
    ["UI-HUD-MicroMenu-StreamDLYellow-Up"] = {16, 20, 0.581055, 0.643555, 0.00195312, 0.162109, false, false, "2x"},
    ["UI-HUD-MicroMenu-ButtonBG-Down"] = {32, 41, 0.0654297, 0.12793, 0.330078, 0.490234, false, false, "1x"},
    ["UI-HUD-MicroMenu-ButtonBG-Up"] = {32, 41, 0.0654297, 0.12793, 0.494141, 0.654297, false, false, "1x"},
    ["UI-HUD-MicroMenu-Portrait-Shadow-2x"] = {32, 41, 0.323242, 0.385742, 0.330078, 0.490234, false, false, "1x"},
    ["UI-HUD-MicroMenu-Portrait-Down-2x"] = {32, 41, 0.323242, 0.385742, 0.166016, 0.326172, false, false, "1x"},
    ["UI-HUD-MicroMenu-GuildCommunities-GuildColor-Disabled"] = {
        32, 41, 0.258789, 0.321289, 0.00195312, 0.162109, false, false, "1x"
    },
    ["UI-HUD-MicroMenu-GuildCommunities-GuildColor-Down"] = {
        32, 41, 0.258789, 0.321289, 0.166016, 0.326172, false, false, "1x"
    },
    ["UI-HUD-MicroMenu-GuildCommunities-GuildColor-Mouseover"] = {
        32, 41, 0.258789, 0.321289, 0.330078, 0.490234, false, false, "1x"
    },
    ["UI-HUD-MicroMenu-GuildCommunities-GuildColor-Up"] = {
        32, 41, 0.258789, 0.321289, 0.494141, 0.654297, false, false, "1x"
    }
}

Module.MicroButtons = {}

function Module.ChangeMicroMenuButton(frame, name)
    table.insert(Module.MicroButtons, frame)
    local microTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\Micromenu\\uimicromenu2x'

    if DF.Era then microTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\Micromenu\\uimicromenu2xERA' end

    local pre = 'UI-HUD-MicroMenu-'
    local key = pre .. name
    local up = Module.MicromenuAtlas[key .. '-Up']

    local sizeX, sizeY = 32, 40
    frame:SetSize(sizeX, sizeY)
    frame:SetHitRectInsets(0, 0, 0, 0)

    frame:SetNormalTexture(microTexture)
    frame:GetNormalTexture():SetTexCoord(up[3], up[4], up[5], up[6])

    local disabled = Module.MicromenuAtlas[key .. '-Disabled']
    frame:SetDisabledTexture(microTexture)
    frame:GetDisabledTexture():SetTexCoord(disabled[3], disabled[4], disabled[5], disabled[6])

    local down = Module.MicromenuAtlas[key .. '-Down']
    frame:SetPushedTexture(microTexture)
    frame:GetPushedTexture():SetTexCoord(down[3], down[4], down[5], down[6])

    local mouseover = Module.MicromenuAtlas[key .. '-Mouseover']
    frame:SetHighlightTexture(microTexture)
    frame:GetHighlightTexture():SetTexCoord(mouseover[3], mouseover[4], mouseover[5], mouseover[6])
    frame:GetHighlightTexture():SetSize(sizeX, sizeY)

    -- Fix: on Era textures get overwritten inside OnUpdate :x
    if DF.Era and frame == MainMenuMicroButton then
        MainMenuMicroButton:HookScript('OnUpdate', function(self)
            frame:SetNormalTexture(microTexture)
            frame:SetDisabledTexture(microTexture)
            frame:SetPushedTexture(microTexture)
            frame:SetHighlightTexture(microTexture)
        end)
    end

    -- add missing background
    local dx, dy = -1, 1
    local offX, offY = frame:GetPushedTextOffset()

    -- ["UI-HUD-MicroMenu-ButtonBG-Down"]={32, 41, 0.0654297, 0.12793, 0.330078, 0.490234, false, false, "1x"},
    local bg = frame:CreateTexture('Background', 'BACKGROUND')
    bg:SetTexture(microTexture)
    bg:SetSize(sizeX, sizeY + 1)
    bg:SetTexCoord(0.0654297, 0.12793, 0.330078, 0.490234)
    bg:SetPoint('CENTER', dx, dy)
    frame.Background = bg

    --	["UI-HUD-MicroMenu-ButtonBG-Up"]={32, 41, 0.0654297, 0.12793, 0.494141, 0.654297, false, false, "1x"},
    local bgPushed = frame:CreateTexture('Background', 'BACKGROUND')
    bgPushed:SetTexture(microTexture)
    bgPushed:SetSize(sizeX, sizeY + 1)
    bgPushed:SetTexCoord(0.0654297, 0.12793, 0.494141, 0.654297)
    bgPushed:SetPoint('CENTER', dx + offX, dy + offY)
    bgPushed:Hide()
    frame.BackgroundPushed = bgPushed

    -- frame:GetHighlightTexture():SetPoint('CENTER', 0, 0)
    -- frame:GetHighlightTexture():SetPoint('CENTER', 2, -2)

    frame.dfState = {}
    frame.dfState.pushed = false
    frame.dfState.highlight = false

    frame.HandleState = function()
        -- DF:Dump(frame.dfState)
        local state = frame.dfState

        if state.pushed then
            frame.Background:Hide()
            frame.BackgroundPushed:Show()
            frame:GetHighlightTexture():ClearAllPoints()
            frame:GetHighlightTexture():SetPoint('CENTER', offX, offY)
        else
            frame.Background:Show()
            frame.BackgroundPushed:Hide()
            frame:GetHighlightTexture():ClearAllPoints()

            frame:GetHighlightTexture():SetPoint('CENTER', 0, 0)
        end
    end
    frame.HandleState()

    frame:GetNormalTexture():HookScript('OnShow', function(self)
        -- frame.Background:Show()
        frame.dfState.pushed = false
        frame.HandleState()
    end)

    --[[   frame:GetNormalTexture():HookScript('OnHide', function(self)
        frame.Background:Hide()
        frame.dfState.pushed = true
        frame.HandleState()
    end)    ]]

    frame:GetPushedTexture():HookScript('OnShow', function(self)
        -- frame.BackgroundPushed:Show()
        frame.dfState.pushed = true
        frame.HandleState()
    end)

    --[[   frame:GetPushedTexture():HookScript('OnHide', function(self)
        frame.BackgroundPushed:Hide()
        frame.dfState.pushed = false
        frame.HandleState()
    end)  ]]

    frame:HookScript('OnEnter', function(self)
        -- frame.Background:Show()
        frame.dfState.highlight = true
        frame.HandleState()
    end)

    frame:HookScript('OnLeave', function(self)
        -- frame.Background:Show()
        frame.dfState.highlight = false
        frame.HandleState()
    end)

    -- flash
    local flash = _G[frame:GetName() .. 'Flash']
    if flash then
        -- print(flash:GetName())
        flash:SetSize(sizeX, sizeY)
        flash:SetTexture(microTexture)
        flash:SetTexCoord(0.323242, 0.385742, 0.00195312, 0.162109)
        flash:ClearAllPoints()
        flash:SetPoint('CENTER', 0, 0)
    end

    -- gap
    --[[     local gap = 0
    local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint(1)
    print(point, relativeTo, relativePoint, xOfs, yOfs)
    frame:SetPoint(point, relativeTo, relativePoint, gap, yOfs)
    ]]
end

function Module.ChangeCharacterMicroButton()
    local microTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\Micromenu\\uimicromenu2x'

    --[[   local name = 'CharacterInfo'
    local pre = 'UI-HUD-MicroMenu-'
    local key = pre .. name
    local up = Module.MicromenuAtlas[key .. '-Up']
    ]]

    local frame = CharacterMicroButton
    local sizeX, sizeY = 32, 40
    local offX, offY = frame:GetPushedTextOffset()

    frame:SetSize(sizeX, sizeY)
    frame:SetHitRectInsets(0, 0, 0, 0)

    frame:GetNormalTexture():SetAlpha(0)
    frame:GetPushedTexture():SetAlpha(0)
    frame:GetHighlightTexture():SetAlpha(0)

    MicroButtonPortrait:ClearAllPoints()
    MicroButtonPortrait:Hide()

    -- new portrait
    local dfPortrait = frame:CreateTexture('NewPortrait', 'ARTWORK')
    dfPortrait:SetAllPoints()
    -- newPortrait:SetSize(sizeX - 2 * inside, sizeY - 2 * inside)
    -- newPortrait:SetPoint('CENTER', 0.5, 0)
    dfPortrait:SetPoint('TOPLEFT', 8, -7)
    dfPortrait:SetPoint('BOTTOMRIGHT', -6, 7)
    dfPortrait:SetTexCoord(0.2, 0.8, 0.0666, 0.9)
    frame.dfPortrait = dfPortrait

    local microPortraitMaskTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\Micromenu\\uimicromenuportraitmask2x'

    -- portraitMask
    local dfPortraitMask = frame:CreateMaskTexture()
    dfPortraitMask:SetTexture(microPortraitMaskTexture, 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
    dfPortraitMask:SetPoint('CENTER')
    dfPortraitMask:SetSize(35, 65)
    dfPortrait:AddMaskTexture(dfPortraitMask)
    frame.dfPortraitMask = dfPortraitMask

    -- portraitShadow (pushed)
    local dfPortraitShadow = frame:CreateTexture('NewPortraitShadow', 'OVERLAY')
    dfPortraitShadow:SetTexture(microTexture)
    dfPortraitShadow:SetTexCoord(0.323242, 0.385742, 0.166016, 0.326172)
    dfPortraitShadow:SetSize(32, 41)
    dfPortraitShadow:SetPoint('CENTER', 1, -4)
    dfPortraitShadow:Hide()
    frame.dfPortraitShadow = dfPortraitShadow

    SetPortraitTexture(frame.dfPortrait, 'player')

    -- CharacterMicroButton_OnEvent
    CharacterMicroButton:HookScript('OnEvent', function(self)
        -- print('on event')
        SetPortraitTexture(frame.dfPortrait, 'player')
    end)

    frame.dfSetState = function(pushed)
        if pushed then
            local delta = offX / 2
            frame.dfPortraitMask:ClearAllPoints()
            frame.dfPortraitMask:SetPoint('CENTER', delta, -delta)

            frame.dfPortrait:ClearAllPoints()
            frame.dfPortrait:SetPoint('TOPLEFT', 8 + delta, -7 - delta)
            frame.dfPortrait:SetPoint('BOTTOMRIGHT', -6 + delta, 7 - delta)

            dfPortraitShadow:Show()
        else
            frame.dfPortraitMask:ClearAllPoints()
            frame.dfPortraitMask:SetPoint('CENTER', 0, 0)

            frame.dfPortrait:ClearAllPoints()
            frame.dfPortrait:SetPoint('TOPLEFT', 8, -7)
            frame.dfPortrait:SetPoint('BOTTOMRIGHT', -6, 7)

            dfPortraitShadow:Hide()
        end
    end

    do
        -- add missing background
        local dx, dy = -1, 1

        -- ["UI-HUD-MicroMenu-ButtonBG-Down"]={32, 41, 0.0654297, 0.12793, 0.330078, 0.490234, false, false, "1x"},
        local bg = frame:CreateTexture('Background', 'BACKGROUND')
        bg:SetTexture(microTexture)
        bg:SetSize(sizeX, sizeY + 1)
        bg:SetTexCoord(0.0654297, 0.12793, 0.330078, 0.490234)
        bg:SetPoint('CENTER', dx, dy)
        frame.Background = bg

        --	["UI-HUD-MicroMenu-ButtonBG-Up"]={32, 41, 0.0654297, 0.12793, 0.494141, 0.654297, false, false, "1x"},
        local bgPushed = frame:CreateTexture('Background', 'BACKGROUND')
        bgPushed:SetTexture(microTexture)
        bgPushed:SetSize(sizeX, sizeY + 1)
        bgPushed:SetTexCoord(0.0654297, 0.12793, 0.494141, 0.654297)
        bgPushed:SetPoint('CENTER', dx + offX, dy + offY)
        bgPushed:Hide()
        frame.BackgroundPushed = bgPushed

        -- frame:GetHighlightTexture():SetPoint('CENTER', 0, 0)
        -- frame:GetHighlightTexture():SetPoint('CENTER', 2, -2)

        frame.dfState = {}
        frame.dfState.pushed = false
        frame.dfState.highlight = false

        frame.HandleState = function()
            -- DF:Dump(frame.dfState)
            local state = frame.dfState

            if state.pushed then
                frame.Background:Hide()
                frame.BackgroundPushed:Show()
                frame:GetHighlightTexture():ClearAllPoints()
                frame:GetHighlightTexture():SetPoint('CENTER', offX, offY)
            else
                frame.Background:Show()
                frame.BackgroundPushed:Hide()
                frame:GetHighlightTexture():ClearAllPoints()

                frame:GetHighlightTexture():SetPoint('CENTER', 0, 0)
            end
            frame.dfSetState(state.pushed)
        end
        frame.HandleState()

        frame:GetNormalTexture():HookScript('OnShow', function(self)
            -- frame.Background:Show()
            frame.dfState.pushed = false
            frame.HandleState()
        end)

        --[[   frame:GetNormalTexture():HookScript('OnHide', function(self)
        frame.Background:Hide()
        frame.dfState.pushed = true
        frame.HandleState()
        end)    ]]

        frame:GetPushedTexture():HookScript('OnShow', function(self)
            -- frame.BackgroundPushed:Show()
            frame.dfState.pushed = true
            frame.HandleState()
        end)

        --[[   frame:GetPushedTexture():HookScript('OnHide', function(self)
        frame.BackgroundPushed:Hide()
        frame.dfState.pushed = false
        frame.HandleState()
         end)  ]]

        frame:HookScript('OnEnter', function(self)
            -- frame.Background:Show()
            frame.dfState.highlight = true
            frame.HandleState()
        end)

        frame:HookScript('OnLeave', function(self)
            -- frame.Background:Show()
            frame.dfState.highlight = false
            frame.HandleState()
        end)

        -- flash
        local flash = _G[frame:GetName() .. 'Flash']
        if flash then
            -- print(flash:GetName())
            flash:SetSize(sizeX, sizeY)
            flash:SetTexture(microTexture)
            flash:SetTexCoord(0.323242, 0.385742, 0.00195312, 0.162109)
            flash:ClearAllPoints()
            flash:SetPoint('CENTER', 0, 0)
        end
    end
end

function Module.ChangeMicroMenu()
    local microFrame = CreateFrame('Frame', 'DragonflightUIMicroMenuBar', UIParent, 'SecureFrameTemplate')
    microFrame:SetPoint('TOPLEFT', CharacterMicroButton, 'TOPLEFT', 0, 0)
    microFrame:SetPoint('BOTTOMRIGHT', HelpMicroButton, 'BOTTOMRIGHT', 0, 0)
    Module.MicroFrame = microFrame

    if DF.Cata then
        Module.ChangeCharacterMicroButton()
        Module.ChangeMicroMenuButton(SpellbookMicroButton, 'SpellbookAbilities')
        Module.ChangeMicroMenuButton(TalentMicroButton, 'SpecTalents')
        Module.ChangeMicroMenuButton(AchievementMicroButton, 'Achievements')
        Module.ChangeMicroMenuButton(QuestLogMicroButton, 'Questlog')
        Module.ChangeMicroMenuButton(GuildMicroButton, 'GuildCommunities')
        Module.ChangeMicroMenuButton(CollectionsMicroButton, 'Collections')
        Module.ChangeMicroMenuButton(PVPMicroButton, 'AdventureGuide')
        Module.BetterPVPMicroButton(PVPMicroButton)
        PVPMicroButtonTexture:Hide()
        Module.ChangeMicroMenuButton(LFGMicroButton, 'Groupfinder')
        Module.ChangeMicroMenuButton(EJMicroButton, 'AdventureGuide')
        Module.ChangeMicroMenuButton(MainMenuMicroButton, 'Shop')
        Module.ChangeMicroMenuButton(HelpMicroButton, 'GameMenu')

        MainMenuBarTextureExtender:Hide()

        -- MainMenuBarPerformanceBar:ClearAllPoints()
        MainMenuBarPerformanceBar:SetPoint('BOTTOM', MainMenuMicroButton, 'BOTTOM', 0, 0)
        MainMenuBarPerformanceBar:SetSize(19, 39)

        Module.HookMicromenuOverride()
    elseif DF.Wrath then
        Module.ChangeCharacterMicroButton()
        Module.ChangeMicroMenuButton(SpellbookMicroButton, 'SpellbookAbilities')
        Module.ChangeMicroMenuButton(TalentMicroButton, 'SpecTalents')
        Module.ChangeMicroMenuButton(AchievementMicroButton, 'Achievements')
        Module.ChangeMicroMenuButton(QuestLogMicroButton, 'Questlog')
        Module.ChangeMicroMenuButton(SocialsMicroButton, 'GuildCommunities')
        Module.ChangeMicroMenuButton(CollectionsMicroButton, 'Collections')
        Module.ChangeMicroMenuButton(PVPMicroButton, 'AdventureGuide')
        Module.BetterPVPMicroButton(PVPMicroButton)
        PVPMicroButtonTexture:Hide()
        Module.ChangeMicroMenuButton(LFGMicroButton, 'Groupfinder')
        Module.ChangeMicroMenuButton(MainMenuMicroButton, 'Shop')
        Module.ChangeMicroMenuButton(HelpMicroButton, 'GameMenu')

        MainMenuBarTextureExtender:Hide()

        -- MainMenuBarPerformanceBar:ClearAllPoints()
        MainMenuBarPerformanceBar:SetPoint('BOTTOM', MainMenuMicroButton, 'BOTTOM', 0, 0)
        MainMenuBarPerformanceBar:SetSize(19, 39)

        Module.HookMicromenuOverride()
    elseif DF.Era then
        Module.ChangeCharacterMicroButton()
        Module.ChangeMicroMenuButton(SpellbookMicroButton, 'SpellbookAbilities')
        Module.ChangeMicroMenuButton(TalentMicroButton, 'SpecTalents')
        Module.ChangeMicroMenuButton(QuestLogMicroButton, 'Questlog')
        -- WorldMapMicroButton    
        Module.ChangeMicroMenuButton(WorldMapMicroButton, 'Collections')

        if LFGMicroButton then Module.ChangeMicroMenuButton(LFGMicroButton, 'Groupfinder') end
        if SocialsMicroButton then Module.ChangeMicroMenuButton(SocialsMicroButton, 'GuildCommunities') end
        if GuildMicroButton then Module.ChangeMicroMenuButton(GuildMicroButton, 'GuildCommunities') end

        -- TODO
        if SocialsMicroButton and GuildMicroButton then
            SocialsMicroButton:Hide();
            GuildMicroButton:Hide();
        end

        Module.ChangeMicroMenuButton(MainMenuMicroButton, 'Shop')
        Module.ChangeMicroMenuButton(HelpMicroButton, 'GameMenu')

        MainMenuBarPerformanceBarFrame:Hide()

        Module.HookMicromenuOverride()
    end

    -- TalentMicroButton getting updated from UpdateMicroButtons() when open/closeing talentframe
    hooksecurefunc('UpdateMicroButtons', function()
        --
        -- print('UpdateMicroButtons')

        if InCombatLockdown() then
            -- prevent unsecure update in combat TODO: message?
            frame.ShouldUpdate = true
            return
        end
        frame.ShouldUpdate = false

        local db = Module.db.profile
        local state = db.micro
        Module.MicroFrame:UpdateStateHandler(state)
    end)
end

function Module.BetterPVPMicroButton(btn)
    local tex = 'Interface\\Addons\\DragonflightUI\\Textures\\Micromenu\\micropvp'

    local englishFaction, localizedFaction = UnitFactionGroup('player')

    if englishFaction == 'Alliance' then
        btn:SetNormalTexture(tex)
        btn:GetNormalTexture():SetTexCoord(0, 118 / 256, 0, 151 / 256)

        btn:SetDisabledTexture(tex)
        btn:GetDisabledTexture():SetTexCoord(0, 118 / 256, 0, 151 / 256)

        btn:SetPushedTexture(tex)
        btn:GetPushedTexture():SetTexCoord(0, 118 / 256, 0, 151 / 256)

        btn:SetHighlightTexture(tex)
        btn:GetHighlightTexture():SetTexCoord(0, 118 / 256, 0, 151 / 256)
    else
        btn:SetNormalTexture(tex)
        btn:GetNormalTexture():SetTexCoord(118 / 256, 236 / 256, 0, 151 / 256)

        btn:SetDisabledTexture(tex)
        btn:GetDisabledTexture():SetTexCoord(118 / 256, 236 / 256, 0, 151 / 256)

        btn:SetPushedTexture(tex)
        btn:GetPushedTexture():SetTexCoord(118 / 256, 236 / 256, 0, 151 / 256)

        btn:SetHighlightTexture(tex)
        btn:GetHighlightTexture():SetTexCoord(118 / 256, 236 / 256, 0, 151 / 256)
    end
end

function Module.HookMicromenuOverride()
    hooksecurefunc('MoveMicroButtons', function(self, anchor, anchorTo, relAnchor, x, y, isStacked)
        -- print('MoveMicroButtons', anchor:GetName(), anchorTo, relAnchor, x, y, isStacked)
        if isStacked then
            -- CharacterMicroButton:SetPoint('BOTTOMLEFT', OverrideActionBar, 'BOTTOMLEFT', 532, 41)
            GuildMicroButton:ClearAllPoints()
            GuildMicroButton:SetPoint('BOTTOMLEFT', QuestLogMicroButton, 'BOTTOMRIGHT', -3, 0)
            CollectionsMicroButton:ClearAllPoints()
            CollectionsMicroButton:SetPoint('TOPLEFT', CharacterMicroButton, 'BOTTOMLEFT', 0, 5)
        else
            local db = Module.db.profile
            Module.UpdateMicromenuState(db.micro)
        end
    end)
end

function Module.UpdateMicromenuState(state)
    -- print('UpdateMicromenuState')

    CharacterMicroButton:ClearAllPoints()
    CharacterMicroButton:SetPoint(state.anchor, state.anchorFrame, state.anchorParent, state.x, state.y)

    local buttons = {}

    if DF.Cata then
        buttons = {
            CharacterMicroButton, SpellbookMicroButton, TalentMicroButton, AchievementMicroButton, QuestLogMicroButton,
            GuildMicroButton, CollectionsMicroButton, PVPMicroButton, LFGMicroButton, EJMicroButton,
            MainMenuMicroButton, HelpMicroButton
        }
    elseif DF.Wrath then
        buttons = {
            CharacterMicroButton, SpellbookMicroButton, TalentMicroButton, AchievementMicroButton, QuestLogMicroButton,
            SocialsMicroButton, CollectionsMicroButton, PVPMicroButton, LFGMicroButton, MainMenuMicroButton,
            HelpMicroButton
        }
    elseif DF.Era then
        buttons = {
            CharacterMicroButton, SpellbookMicroButton, TalentMicroButton, QuestLogMicroButton, GuildMicroButton,
            WorldMapMicroButton, LFGMicroButton, MainMenuMicroButton, HelpMicroButton
        }
    end

    -- for k, v in ipairs(buttons) do
    --     --
    --     v:SetScale(state.scale)
    --     -- v:SetShown(not state.hidden)
    --     if state.hidden then
    --         --
    --         v:SetAlpha(0)
    --         v:EnableMouse(false)
    --     else
    --         --
    --         v:SetAlpha(1)
    --         v:EnableMouse(true)
    --     end
    -- end

    -- for k, v in ipairs(buttons) do v:SetScale(state.scale) end

    for k, v in ipairs(Module.MicroButtons) do
        --
        v:SetScale(state.scale)
    end

    -- local playerLevel = UnitLevel("player");
    -- if (playerLevel < SHOW_SPEC_LEVEL) then TalentMicroButton:Hide(); end

    -- FPS
    Module.UpdateFPSState(state)

    Module.MicroFrame:SetScale(state.scale) -- compat
    Module.MicroFrame:UpdateStateHandler(state)
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

    Module.ChangeMicroMenu()
    Module.ChangeBackpack()
    Module.MoveBars()
    Module.ChangeFramerate()
    Module.CreateBagExpandButton()
    Module.RefreshBagBarToggle()
    Module.HookBags()
end
