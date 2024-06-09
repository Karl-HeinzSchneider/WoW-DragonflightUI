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
            alwaysShow = true,
            hideArt = false,
            hideScrolling = false,
            gryphons = 'DEFAULT'
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
            alwaysShow = true
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
            alwaysShow = true
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
            alwaysShow = true
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
            alwaysShow = true
        },
        pet = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame3',
            anchor = 'BOTTOM',
            anchorParent = 'TOP',
            x = 0,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 1,
            rows = 1,
            buttons = 10,
            padding = 2,
            alwaysShow = true
        },
        xp = {
            scale = 1,
            anchorFrame = 'UIParent',
            anchor = 'BOTTOM',
            anchorParent = 'BOTTOM',
            x = 0,
            y = 5,
            alwaysShowXP = false
        },
        rep = {
            scale = 1,
            anchorFrame = 'DragonflightUIXPBar',
            anchor = 'BOTTOM',
            anchorParent = 'TOP',
            x = 0,
            y = 0,
            alwaysShowRep = false
        },
        stance = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame3',
            anchor = 'BOTTOM',
            anchorParent = 'TOP',
            x = 0,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 1,
            rows = 1,
            buttons = 10,
            padding = 2,
            alwaysShow = true
        },
        totem = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame3',
            anchor = 'BOTTOM',
            anchorParent = 'TOP',
            x = 0,
            y = 2
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
            hidden = false
        },
        micro = {
            scale = 1,
            anchorFrame = 'UIParent',
            anchor = 'BOTTOMRIGHT',
            anchorParent = 'BOTTOMRIGHT',
            x = -295,
            y = 0,
            hidden = false,
            hideDefaultFPS = true,
            showFPS = true,
            alwaysShowFPS = false,
            showPing = true
        }
    }
}
if DF.Era then defaults.profile.micro.x = -205 end
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
    ['DragonflightUIXPBar'] = 'XPbar',
    ['DragonflightUIRepBar'] = 'RepBar',
    ['DragonflightUIPetBar'] = 'PetBar',
    ['DragonflightUIStancebar'] = 'Stancebar'
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
        config = {type = 'header', name = 'Config - XP/Reputation Bar', order = 200},
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
        config = {type = 'header', name = 'EXPERIMENTAL - Actionbar 4/5', order = 300},
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
                values = frameTable,
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
                max = 5,
                bigStep = 0.1,
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
            alwaysShow = {
                type = 'toggle',
                name = 'Always show Actionbar',
                desc = '' .. getDefaultStr('alwaysShow', barname),
                order = 12
            }
        }
    }
    -- if n == 1 then opt.args.anchorFrame['DragonflightUIActionbarFrame1'] = nil end

    if n == 1 then
        -- print('111111')
        local moreOptions = {
            hideArt = {
                type = 'toggle',
                name = 'Hide bar art',
                desc = '' .. getDefaultStr('hideArt', barname),
                order = 14
            },
            hideScrolling = {
                type = 'toggle',
                name = 'Hide bar scrolling',
                desc = '' .. getDefaultStr('hideScrolling', barname),
                order = 15
            },
            gryphons = {
                type = 'select',
                name = 'Gryphons',
                desc = 'Gryphons' .. getDefaultStr('gryphons', barname),
                values = {['DEFAULT'] = 'DEFAULT', ['ALLY'] = 'ALLIANCE', ['HORDE'] = 'HORDE', ['NONE'] = 'NONE'},
                order = 13
            }
        }

        for k, v in pairs(moreOptions) do opt.args[k] = v end
    end

    return opt
end

local petOptions = {
    name = 'PetBar',
    desc = 'PetBar',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'pet'),
            min = 0.1,
            max = 5,
            bigStep = 0.1,
            order = 1
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'pet'),
            values = frameTable,
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
            max = 5,
            bigStep = 0.1,
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
            order = 1
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'xp'),
            values = frameTable,
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
        alwaysShowXP = {
            type = 'toggle',
            name = 'Always show XP text',
            desc = '' .. getDefaultStr('alwaysShowXP', 'xp'),
            order = 12
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
            order = 1
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'rep'),
            values = frameTable,
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
        alwaysShowRep = {
            type = 'toggle',
            name = 'Always show Rep text',
            desc = '' .. getDefaultStr('alwaysShowRep', 'rep'),
            order = 12
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
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'stance'),
            min = 0.1,
            max = 5,
            bigStep = 0.1,
            order = 1
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'stance'),
            values = frameTable,
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
            max = 5,
            bigStep = 0.1,
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
        alwaysShow = {
            type = 'toggle',
            name = 'Always show Actionbar',
            desc = '' .. getDefaultStr('alwaysShow', 'stance'),
            order = 12
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
            bigStep = 0.1,
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
        hidden = {
            type = 'toggle',
            name = 'Hidden',
            desc = 'Hide Micromenu' .. getDefaultStr('hidden', 'micro'),
            order = 7
        },
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
    if DF.Wrath then
        Module.Wrath()
    else
        Module.Era()
    end
    Module:SetupActionbarFrames()
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

    createStuff(1, 'ActionButton')
    Module.bar1:SetupMainBar()
    createStuff(2, 'MultiBarBottomLeftButton')
    createStuff(3, 'MultiBarBottomRightButton')
    createStuff(4, 'MultiBarLeftButton')
    createStuff(5, 'MultiBarRightButton')

    Module.bar1:StyleButtons()
    Module.bar2:StyleButtons()
    Module.bar3:StyleButtons()
    Module.bar4:StyleButtons()
    Module.bar5:StyleButtons()

    do
        local bar = CreateFrame('FRAME', 'DragonflightUIPetbarFrame', UIParent, 'DragonflightUIPetbarFrameTemplate')
        local buttons = {}

        for i = 1, 10 do
            local btn = _G['PetActionButton' .. i]
            buttons[i] = btn
        end

        bar:Init()
        bar:SetButtons(buttons)
        Module['petbar'] = bar
    end

    do
        local bar = CreateFrame('FRAME', 'DragonflightUIStancebarFrame', UIParent,
                                'DragonflightUIActionbarFrameTemplate')
        local buttons = {}

        for i = 1, 10 do
            local btn = _G['StanceButton' .. i]
            buttons[i] = btn
        end

        bar:Init()
        bar:SetButtons(buttons)
        Module['stancebar'] = bar
    end

    -- @TODO
    do
        MultiBarBottomLeft.ignoreFramePositionManager = true
        MultiBarBottomLeft:ClearAllPoints()
        MultiBarBottomLeft:SetPoint('BOTTOM', _G['DragonflightUIActionbarFrame2'], 'BOTTOM')

        MultiBarBottomRight.ignoreFramePositionManager = true
        MultiBarBottomRight:ClearAllPoints()
        MultiBarBottomRight:SetPoint('BOTTOM', _G['DragonflightUIActionbarFrame3'], 'BOTTOM')
    end
end

function Module:RegisterOptionScreens()

    for i = 1, 5 do
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

    DF.ConfigModule:RegisterOptionScreen('Actionbar', 'Stancebar', {
        name = 'Stancebar',
        sub = 'stance',
        options = stanceOptions,
        default = function()
            setDefaultSubValues('stance')
        end
    })

    DF.ConfigModule:RegisterOptionScreen('Actionbar', 'Totembar', {
        name = 'Totembar',
        sub = 'totem',
        options = totemOptions,
        default = function()
            setDefaultSubValues('totem')
        end
    })

    DF.ConfigModule:RegisterOptionScreen('Actionbar', 'Bags', {
        name = 'Bags',
        sub = 'bags',
        options = bagsOptions,
        default = function()
            setDefaultSubValues('bags')
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

    for i = 1, 5 do refreshCat('Actionbar' .. i) end
    refreshCat('Petbar')
    refreshCat('XPbar')
    refreshCat('Repbar')
    refreshCat('Stancebar')
    refreshCat('Totembar')
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
    Module.petbar:SetState(db.pet)
    Module.xpbar:SetState(db.xp)
    Module.repbar:SetState(db.rep)
    Module.stancebar:SetState(db.stance)

    Module.UpdateTotemState(db.totem)

    Module.UpdateBagState(db.bags)
    Module.UpdateMicromenuState(db.micro)

    Module.ChangePossessBar()
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

function Module.StyleButtons()
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'

    local buttonTable = {
        'MultiBarBottomRightButton', 'MultiBarBottomLeftButton', 'ActionButton', 'MultiBarLeftButton',
        'MultiBarRightButton'
    }
    for k, v in pairs(buttonTable) do
        for i = 1, 12 do
            -- MultiBarBottomRightButton1NormalTexture
            local name = v .. i

            _G[name .. 'NormalTexture']:SetTexture(textureRef)
            _G[name .. 'NormalTexture']:SetTexCoord(0.701171875, 0.880859375, 0.31689453125, 0.36083984375)
            _G[name .. 'NormalTexture']:SetSize(38, 38)
            _G[name .. 'NormalTexture']:SetPoint('CENTER', 0.5, -0.5)
            _G[name .. 'NormalTexture']:SetAlpha(1)

            -- Border
            -- _G[name .. 'Border']:SetTexture()
            -- _G[name .. 'Border']:SetTexCoord(0.701171875, 0.880859375, 0.36181640625, 0.40576171875)
            -- _G[name .. 'Border']:SetSize(45, 45)

            -- Highlight
            _G[name]:SetHighlightTexture(textureRef)
            _G[name]:GetHighlightTexture():SetTexCoord(0.701171875, 0.880859375, 0.52001953125, 0.56396484375)
            -- _G[name]:GetHighlightTexture():SetSize(55, 25)

            -- Pressed
            _G[name]:SetPushedTexture(textureRef)
            _G[name]:GetPushedTexture():SetTexCoord(0.701171875, 0.880859375, 0.43017578125, 0.47412109375)

            -- Background
            if _G[name .. 'FloatingBG'] then
                _G[name .. 'FloatingBG']:SetTexture()
                _G[name .. 'FloatingBG']:SetTexCoord(0, 0, 0, 0)
                _G[name .. 'FloatingBG']:SetSize(45, 45)
            end
        end
    end

    for i = 1, 10 do
        local btn = _G['StanceButton' .. i]
        local tex = _G['StanceButton' .. i .. 'NormalTexture2']
        tex:SetSize(52, 52)

        -- TODO can maybe break
        hooksecurefunc(tex, 'SetWidth', function()
            -- print(tex:GetName(), 'SetSize')
            tex:SetSize(52, 52)
        end)
        hooksecurefunc(tex, 'SetHeight', function()
            -- print(tex:GetName(), 'SetSize')
            tex:SetSize(52, 52)
        end)
    end
end

function Module.ApplyMask()
    local buttonTable = {
        'MultiBarBottomRightButton', 'MultiBarBottomLeftButton', 'ActionButton', 'MultiBarLeftButton',
        'MultiBarRightButton'
    }
    frame.ButtonMask = frame:CreateMaskTexture()
    frame.ButtonMask:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\ui-chaticon-hots')
    frame.ButtonMask:SetTexture('Interface/ChatFrame/UI-ChatIcon-HotS')

    local f = CreateFrame('Frame', nil, UIParent)
    f:SetPoint('CENTER')
    f:SetSize(64, 64)

    for i = 1, 0 do
        local tex = f:CreateTexture()
        tex:SetAllPoints(f)
        tex:SetTexture('Interface/Icons/spell_shadow_antishadow')
        tex:SetMask('Interface\\Addons\\DragonflightUI\\Textures\\mask3')
        tex:SetPoint('CENTER', f, 'CENTER', i, i)

        f['tex' .. i] = tex
    end

    for k, v in pairs(buttonTable) do
        for i = 1, 12 do
            -- MultiBarBottomRightButton1NormalTexture
            local name = v .. i

            -- Mask
            local btn = _G[name]
            local icon = _G[name .. 'Icon']
            if icon then
                icon:SetAlpha(0.1)
                local tex = btn:CreateTexture()
                tex:SetPoint('CENTER', btn)
                local size = 36
                tex:SetSize(size, size)
                tex:SetMask('Interface\\Addons\\DragonflightUI\\Textures\\mask3')
                tex:SetDrawLayer('BACKGROUND')
                btn.DragonflightUIMaskTexture = tex

                hooksecurefunc(icon, 'Show', function(self)
                    local tex = self:GetTexture()
                    if tex then
                        btn.DragonflightUIMaskTexture:Show()
                        btn.DragonflightUIMaskTexture:SetTexture(tex)
                    end
                end)
                hooksecurefunc(icon, 'Hide', function(self)
                    btn.DragonflightUIMaskTexture:Hide()
                end)

                hooksecurefunc(icon, 'SetVertexColor', function(self)
                    -- print('vertex')
                    local r, g, b = self:GetVertexColor()
                    btn.DragonflightUIMaskTexture:SetVertexColor(r, g, b)
                end)
            end
        end
    end
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

-- @TODO: better system
function Module.SetNumBars()
    local inLockdown = InCombatLockdown()
    if true then return end
    if inLockdown then
        -- return
        -- print('[DragonflightUI] changing Frames after combat ends..')
    else
        local dy = 20
        local dRep, dButtons = 0, 0

        if frame.XPBar.valid then
            frame.XPBar:Show()
        else
            frame.XPBar:Hide()
            dRep = dRep + dy
            dButtons = dButtons + dy
        end
        if frame.RepBar.valid then
            frame.RepBar:Show()
        else
            frame.RepBar:Hide()
            dButtons = dButtons + dy
        end

        ActionButton1:SetPoint('CENTER', MainMenuBar, 'CENTER', -230 + 3 * 5.5, 30 + 18 - dButtons)
        frame.XPBar:SetPoint('BOTTOM', 0, 5)
        frame.RepBar:SetPoint('BOTTOM', 0, 5 + 20 - dRep)
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

function Module.ChangePossessBar()
    PossessBarFrame.ignoreFramePositionManager = true

    PossessBarFrame:ClearAllPoints()
    -- PossessBarFrame:SetPoint('BOTTOMLEFT', MultiBarBottomRight, 'TOPLEFT', 0.5, 4)
    local ab = _G['DragonflightUIActionbarFrame1']
    local dy = 2 * ab:GetHeight() + 2
    local dx = -2
    PossessBarFrame:SetPoint('BOTTOMLEFT', ab, 'TOPLEFT', dx, dy)
end

function frame:OnEvent(event, arg1)
    -- print('event', event)  
end
frame:SetScript('OnEvent', frame.OnEvent)

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

function Module.ChangeMicroMenuButton(frame, name)
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

function Module.ChangeMicroMenuNew()
    if DF.Cata then
        Module.ChangeCharacterMicroButton()
        Module.ChangeMicroMenuButton(SpellbookMicroButton, 'SpellbookAbilities')
        Module.ChangeMicroMenuButton(TalentMicroButton, 'SpecTalents')
        Module.ChangeMicroMenuButton(AchievementMicroButton, 'Achievements')
        Module.ChangeMicroMenuButton(QuestLogMicroButton, 'Questlog')
        Module.ChangeMicroMenuButton(GuildMicroButton, 'GuildCommunities')
        Module.ChangeMicroMenuButton(CollectionsMicroButton, 'Collections')
        Module.ChangeMicroMenuButton(PVPMicroButton, 'AdventureGuide')
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
        PVPMicroButtonTexture:Hide()
        Module.ChangeMicroMenuButton(LFGMicroButton, 'Groupfinder')
        Module.ChangeMicroMenuButton(MainMenuMicroButton, 'Shop')
        Module.ChangeMicroMenuButton(HelpMicroButton, 'GameMenu')

        MainMenuBarTextureExtender:Hide()

        -- MainMenuBarPerformanceBar:ClearAllPoints()
        MainMenuBarPerformanceBar:SetPoint('BOTTOM', MainMenuMicroButton, 'BOTTOM', 0, 0)
        MainMenuBarPerformanceBar:SetSize(19, 39)

    elseif DF.Era then
        Module.ChangeCharacterMicroButton()
        Module.ChangeMicroMenuButton(SpellbookMicroButton, 'SpellbookAbilities')
        Module.ChangeMicroMenuButton(TalentMicroButton, 'SpecTalents')
        Module.ChangeMicroMenuButton(QuestLogMicroButton, 'Questlog')
        Module.ChangeMicroMenuButton(SocialsMicroButton, 'GuildCommunities')
        -- WorldMapMicroButton    
        Module.ChangeMicroMenuButton(WorldMapMicroButton, 'Collections')
        Module.ChangeMicroMenuButton(LFGMicroButton, 'Groupfinder')
        Module.ChangeMicroMenuButton(MainMenuMicroButton, 'Shop')
        Module.ChangeMicroMenuButton(HelpMicroButton, 'GameMenu')

        MainMenuBarPerformanceBarFrame:Hide()
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

function Module.ChangeMicroMenu()
    -- from https://www.townlong-yak.com/framexml/live/Helix/AtlasInfo.lua
    local Atlas = {
        ['UI-HUD-MicroMenu-Achievements-Disabled'] = {
            38, 52, 0.78515625, 0.93359375, 0.212890625, 0.314453125, false, false
        },
        ['UI-HUD-MicroMenu-Achievements-Down'] = {
            38, 52, 0.62890625, 0.77734375, 0.107421875, 0.208984375, false, false
        },
        ['UI-HUD-MicroMenu-Achievements-Mouseover'] = {
            38, 52, 0.78515625, 0.93359375, 0.107421875, 0.208984375, false, false
        },
        ['UI-HUD-MicroMenu-Achievements-Up'] = {38, 52, 0.62890625, 0.77734375, 0.212890625, 0.314453125, false, false},
        ['UI-HUD-MicroMenu-AdventureGuide-Disabled'] = {
            38, 52, 0.31640625, 0.46484375, 0.318359375, 0.419921875, false, false
        },
        ['UI-HUD-MicroMenu-AdventureGuide-Down'] = {
            38, 52, 0.78515625, 0.93359375, 0.318359375, 0.419921875, false, false
        },
        ['UI-HUD-MicroMenu-AdventureGuide-Mouseover'] = {
            38, 52, 0.62890625, 0.77734375, 0.318359375, 0.419921875, false, false
        },
        ['UI-HUD-MicroMenu-AdventureGuide-Up'] = {
            38, 52, 0.00390625, 0.15234375, 0.529296875, 0.630859375, false, false
        },
        ['UI-HUD-MicroMenu-CharacterInfo-Disabled'] = {
            38, 52, 0.00390625, 0.15234375, 0.423828125, 0.525390625, false, false
        },
        ['UI-HUD-MicroMenu-CharacterInfo-Down'] = {
            38, 52, 0.47265625, 0.62109375, 0.318359375, 0.419921875, false, false
        },
        ['UI-HUD-MicroMenu-CharacterInfo-Mouseover'] = {
            38, 52, 0.31640625, 0.46484375, 0.423828125, 0.525390625, false, false
        },
        ['UI-HUD-MicroMenu-CharacterInfo-Up'] = {38, 52, 0.00390625, 0.15234375, 0.634765625, 0.736328125, false, false},
        ['UI-HUD-MicroMenu-Collections-Disabled'] = {
            38, 52, 0.47265625, 0.62109375, 0.001953125, 0.103515625, false, false
        },
        ['UI-HUD-MicroMenu-Collections-Down'] = {38, 52, 0.00390625, 0.15234375, 0.740234375, 0.841796875, false, false},
        ['UI-HUD-MicroMenu-Collections-Mouseover'] = {
            38, 52, 0.00390625, 0.15234375, 0.845703125, 0.947265625, false, false
        },
        ['UI-HUD-MicroMenu-Collections-Up'] = {38, 52, 0.16015625, 0.30859375, 0.318359375, 0.419921875, false, false},
        ['UI-HUD-MicroMenu-Communities-Icon-Notification'] = {
            20, 22, 0.00390625, 0.08203125, 0.951171875, 0.994140625, false, false
        },
        ['UI-HUD-MicroMenu-GameMenu-Disabled'] = {
            38, 52, 0.16015625, 0.30859375, 0.423828125, 0.525390625, false, false
        },
        ['UI-HUD-MicroMenu-GameMenu-Down'] = {38, 52, 0.47265625, 0.62109375, 0.423828125, 0.525390625, false, false},
        ['UI-HUD-MicroMenu-GameMenu-Mouseover'] = {
            38, 52, 0.62890625, 0.77734375, 0.423828125, 0.525390625, false, false
        },
        ['UI-HUD-MicroMenu-GameMenu-Up'] = {38, 52, 0.78515625, 0.93359375, 0.423828125, 0.525390625, false, false},
        ['UI-HUD-MicroMenu-Groupfinder-Disabled'] = {
            38, 52, 0.16015625, 0.30859375, 0.529296875, 0.630859375, false, false
        },
        ['UI-HUD-MicroMenu-Groupfinder-Down'] = {38, 52, 0.31640625, 0.46484375, 0.212890625, 0.314453125, false, false},
        ['UI-HUD-MicroMenu-Groupfinder-Mouseover'] = {
            38, 52, 0.16015625, 0.30859375, 0.212890625, 0.314453125, false, false
        },
        ['UI-HUD-MicroMenu-Groupfinder-Up'] = {38, 52, 0.00390625, 0.15234375, 0.318359375, 0.419921875, false, false},
        ['UI-HUD-MicroMenu-GuildCommunities-Disabled'] = {
            38, 52, 0.78515625, 0.93359375, 0.001953125, 0.103515625, false, false
        },
        ['UI-HUD-MicroMenu-GuildCommunities-Down'] = {
            38, 52, 0.00390625, 0.15234375, 0.001953125, 0.103515625, false, false
        },
        ['UI-HUD-MicroMenu-GuildCommunities-Mouseover'] = {
            38, 52, 0.16015625, 0.30859375, 0.001953125, 0.103515625, false, false
        },
        ['UI-HUD-MicroMenu-GuildCommunities-Up'] = {
            38, 52, 0.16015625, 0.30859375, 0.107421875, 0.208984375, false, false
        },
        ['UI-HUD-MicroMenu-Highlightalert'] = {66, 80, 0.47265625, 0.73046875, 0.740234375, 0.896484375, false, false},
        ['UI-HUD-MicroMenu-Questlog-Disabled'] = {
            38, 52, 0.16015625, 0.30859375, 0.740234375, 0.841796875, false, false
        },
        ['UI-HUD-MicroMenu-Questlog-Down'] = {38, 52, 0.47265625, 0.62109375, 0.529296875, 0.630859375, false, false},
        ['UI-HUD-MicroMenu-Questlog-Mouseover'] = {
            38, 52, 0.16015625, 0.30859375, 0.845703125, 0.947265625, false, false
        },
        ['UI-HUD-MicroMenu-Questlog-Up'] = {38, 52, 0.78515625, 0.93359375, 0.529296875, 0.630859375, false, false},
        ['UI-HUD-MicroMenu-Shop-Disabled'] = {38, 52, 0.16015625, 0.30859375, 0.634765625, 0.736328125, false, false},
        ['UI-HUD-MicroMenu-Shop-Down'] = {38, 52, 0.62890625, 0.77734375, 0.529296875, 0.630859375, false, false},
        ['UI-HUD-MicroMenu-Shop-Mouseover'] = {38, 52, 0.47265625, 0.62109375, 0.634765625, 0.736328125, false, false},
        ['UI-HUD-MicroMenu-Shop-Up'] = {38, 52, 0.00390625, 0.15234375, 0.212890625, 0.314453125, false, false},
        ['UI-HUD-MicroMenu-SpecTalents-Disabled'] = {
            38, 52, 0.31640625, 0.46484375, 0.107421875, 0.208984375, false, false
        },
        ['UI-HUD-MicroMenu-SpecTalents-Down'] = {38, 52, 0.31640625, 0.46484375, 0.529296875, 0.630859375, false, false},
        ['UI-HUD-MicroMenu-SpecTalents-Mouseover'] = {
            38, 52, 0.31640625, 0.46484375, 0.001953125, 0.103515625, false, false
        },
        ['UI-HUD-MicroMenu-SpecTalents-Up'] = {38, 52, 0.62890625, 0.77734375, 0.001953125, 0.103515625, false, false},
        ['UI-HUD-MicroMenu-SpellbookAbilities-Disabled'] = {
            38, 52, 0.00390625, 0.15234375, 0.107421875, 0.208984375, false, false
        },
        ['UI-HUD-MicroMenu-SpellbookAbilities-Down'] = {
            38, 52, 0.31640625, 0.46484375, 0.845703125, 0.947265625, false, false
        },
        ['UI-HUD-MicroMenu-SpellbookAbilities-Mouseover'] = {
            38, 52, 0.73828125, 0.88671875, 0.845703125, 0.947265625, false, false
        },
        ['UI-HUD-MicroMenu-SpellbookAbilities-Up'] = {
            38, 52, 0.47265625, 0.62109375, 0.107421875, 0.208984375, false, false
        },
        ['UI-HUD-MicroMenu-StreamDLGreen-Down'] = {
            38, 52, 0.31640625, 0.46484375, 0.634765625, 0.736328125, false, false
        },
        ['UI-HUD-MicroMenu-StreamDLGreen-Up'] = {38, 52, 0.47265625, 0.62109375, 0.212890625, 0.314453125, false, false},
        ['UI-HUD-MicroMenu-StreamDLRed-Down'] = {38, 52, 0.31640625, 0.46484375, 0.740234375, 0.841796875, false, false},
        ['UI-HUD-MicroMenu-StreamDLRed-Up'] = {38, 52, 0.62890625, 0.77734375, 0.634765625, 0.736328125, false, false},
        ['UI-HUD-MicroMenu-StreamDLYellow-Down'] = {
            38, 52, 0.73828125, 0.88671875, 0.740234375, 0.841796875, false, false
        },
        ['UI-HUD-MicroMenu-StreamDLYellow-Up'] = {
            38, 52, 0.78515625, 0.93359375, 0.634765625, 0.736328125, false, false
        }
    }
    local microTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\uimicromenu2x'
    Module.SetButtonFromAtlas(CharacterMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'CharacterInfo')
    MicroButtonPortrait:Hide()
    Module.SetButtonFromAtlas(SpellbookMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'SpellbookAbilities')
    Module.SetButtonFromAtlas(TalentMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'SpecTalents')
    Module.SetButtonFromAtlas(QuestLogMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'Questlog')
    Module.SetButtonFromAtlas(SocialsMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'GuildCommunities')

    Module.SetButtonFromAtlas(HelpMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'GameMenu')

    if DF.Wrath then
        Module.SetButtonFromAtlas(AchievementMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'Achievements')
        Module.SetButtonFromAtlas(PVPMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'AdventureGuide')
        PVPMicroButtonTexture:Hide()
        Module.SetButtonFromAtlas(LFGMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'Groupfinder')
        Module.SetButtonFromAtlas(MainMenuMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'Shop')

        Module.SetButtonFromAtlas(CollectionsMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'Collections')
        MainMenuBarTextureExtender:Hide()

        local deltaX, deltaY = 6, 18
        MainMenuBarPerformanceBar:ClearAllPoints()
        MainMenuBarPerformanceBar:SetPoint('LEFT', MainMenuMicroButton, 'LEFT', deltaX, -deltaY)
        MainMenuBarPerformanceBar:SetPoint('RIGHT', MainMenuMicroButton, 'RIGHT', -deltaX, -deltaY)
        MainMenuBarPerformanceBar:SetPoint('RIGHT', MainMenuMicroButton, 'RIGHT',
                                           MainMenuBarPerformanceBar:GetWidth() / 2 - deltaX, -15)
    else
        MainMenuBarPerformanceBarFrame:Hide()
    end
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
            CharacterMicroButton, SpellbookMicroButton, TalentMicroButton, QuestLogMicroButton, SocialsMicroButton,
            WorldMapMicroButton, LFGMicroButton, MainMenuMicroButton, HelpMicroButton
        }
    end

    for k, v in ipairs(buttons) do
        --
        v:SetScale(state.scale)
        v:SetShown(not state.hidden)
    end

    local playerLevel = UnitLevel("player");
    if (playerLevel < SHOW_SPEC_LEVEL) then TalentMicroButton:Hide(); end

    -- FPS
    Module.UpdateFPSState(state)
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

function Module.ChangeBackpackNew()
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

            local delta = 6
            icon:SetSize(size - delta, size - delta)
            icon:SetPoint('CENTER', 0, 0)
            icon:SetDrawLayer('BORDER', 2)

            local bagmask = 'Interface\\Addons\\DragonflightUI\\Textures\\bagmask'
            icon:SetMask(bagmask)
            KeyRingButton.Icon = icon

            -- icon:Hide()
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

function Module.ChangeBackpack()
    -- MainMenuBarBackpackButton MainMenuBarBackpackButtonIconTexture
    local texture = 'Interface\\Addons\\DragonflightUI\\Textures\\bigbag'
    local highlight = 'Interface\\Addons\\DragonflightUI\\Textures\\bigbagHighlight'

    MainMenuBarBackpackButton:SetScale(1.5)

    SetItemButtonTexture(MainMenuBarBackpackButton, texture)
    MainMenuBarBackpackButton:SetHighlightTexture(highlight)
    MainMenuBarBackpackButton:SetPushedTexture(highlight)
    MainMenuBarBackpackButton:SetCheckedTexture(highlight)

    MainMenuBarBackpackButtonNormalTexture:Hide()
    MainMenuBarBackpackButtonNormalTexture:SetTexture()
    -- MainMenuBarBackpackButton.IconBorder:Hide()

    local slot = 'Interface\\Addons\\DragonflightUI\\Textures\\bagborder2'
    local slothighlight = 'Interface\\Addons\\DragonflightUI\\Textures\\baghighlight2'

    local bagtexture = 'Interface\\Addons\\DragonflightUI\\Textures\\bagslots2x'
    local bagmask = 'Interface\\Addons\\DragonflightUI\\Textures\\bagmask'
    -- dx/dy => better center
    local dy = 0.015
    local dx = -0.001

    for i = 0, 3 do
        _G['CharacterBag' .. i .. 'Slot']:GetNormalTexture():SetTexture(bagtexture)
        --  _G['CharacterBag' .. i .. 'Slot']:GetNormalTexture():SetTexCoord(0.576171875, 0.6953125, 0.5, 0.9765625) -- empty

        _G['CharacterBag' .. i .. 'Slot']:GetNormalTexture():SetTexCoord(0.576171875 + dx, 0.6953125 + dx,
                                                                         0.0078125 + dy, 0.484375 + dy)
        _G['CharacterBag' .. i .. 'Slot']:GetNormalTexture():SetSize(35, 35)

        _G['CharacterBag' .. i .. 'Slot']:GetHighlightTexture():SetTexture(bagtexture)
        _G['CharacterBag' .. i .. 'Slot']:GetHighlightTexture()
            :SetTexCoord(0.69921875, 0.818359375, 0.0078125, 0.484375)
        _G['CharacterBag' .. i .. 'Slot']:GetHighlightTexture():SetSize(35, 35)

        _G['CharacterBag' .. i .. 'Slot']:GetCheckedTexture():SetTexture()
        _G['CharacterBag' .. i .. 'Slot']:GetPushedTexture():SetTexture()

        _G['CharacterBag' .. i .. 'SlotIconTexture']:SetMask(bagmask)

        -- Note:
        -- bagID = 4 3 2 1 0  , 0 = backpack
        -- texture bag id = 3 2 1 0  , backpack seperate
        local slothook = function(self, id)
            local slots = Module.GetBagSlots(id)
            local name = 'CharacterBag' .. (id - 1) .. 'Slot'
            if slots == 0 then
                _G[name]:GetNormalTexture():SetTexCoord(0.576171875, 0.6953125, 0.5, 0.9765625)
            else
                _G[name]:GetNormalTexture():SetTexCoord(0.576171875 + dx, 0.6953125 + dx, 0.0078125 + dy, 0.484375 + dy)
            end
        end

        hooksecurefunc(_G['CharacterBag' .. i .. 'SlotIconTexture'], 'SetTexture', function(args)
            slothook(args, i + 1)
        end)
    end

    CharacterBag0Slot:SetPoint('RIGHT', MainMenuBarBackpackButton, 'LEFT', -12, 0)

    -- keyring
    KeyRingButton:SetSize(34.5, 34.5)
    KeyRingButton:SetPoint('RIGHT', CharacterBag3Slot, 'LEFT', -6 + 3, 0 - 2 + 2)

    KeyRingButton:GetNormalTexture():SetTexture(bagtexture)
    KeyRingButton:GetNormalTexture():SetSize(35, 35)
    KeyRingButton:GetNormalTexture():SetTexCoord(0.576171875 + dx, 0.6953125 + dx, 0.0078125 + dy, 0.484375 + dy)
    KeyRingButton:GetNormalTexture():SetTexCoord(0.822265625, 0.94140625, 0.0078125, 0.484375)

    KeyRingButton:GetHighlightTexture():SetTexture(bagtexture)
    KeyRingButton:GetHighlightTexture():SetSize(35, 35)
    KeyRingButton:GetHighlightTexture():SetTexCoord(0.69921875, 0.818359375, 0.0078125, 0.484375)

    -- KeyRingButton:GetPushedTexture():SetTexture(bagtexture)
    KeyRingButton:GetPushedTexture():SetSize(35, 35)
    -- KeyRingButton:GetPushedTexture():SetTexture(0.69921875, 0.818359375, 0.0078125, 0.484375)
    -- KeyRingButton:GetCheckedTexture():SetTexture()
end

function Module.HookBags()
    -- from '\BlizzardInterfaceCode\Interface\FrameXML\ContainerFrame_Shared.lua'
    local UpdateContainerFrameAnchorsModified = function()
        -- CHANGE
        local CONTAINER_OFFSET_X_DF = 0
        local CONTAINER_OFFSET_Y_DF = 92

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
                freeScreenHeight = freeScreenHeight - frameHeight - VISIBLE_CONTAINER_SPACING
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
                frame:SetPoint('BOTTOMRIGHT', ContainerFrame1.bags[index - 1], 'TOPRIGHT', 0, CONTAINER_SPACING)
            end
            freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING
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

    local fps = CreateFrame('Frame', 'DragonflightUIFPSTextFrame', UIParent)
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
    -- Module.StyleButtons()
    -- Module.ApplyMask()

    Module.SetNumBars()
    Module.HookPetBar()
    Module.MoveTotem()
    -- Module.ChangePossessBar()

    frame:RegisterEvent('PLAYER_REGEN_ENABLED')

    Module.ChangeGryphon()
    -- Module.DrawActionbarDeco()

    Module.ChangeMicroMenuNew()
    Module.ChangeBackpackNew()
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
    -- Module.StyleButtons()
    -- Module.ApplyMask()

    Module.SetNumBars()
    Module.HookPetBar()
    -- Module.MoveTotem()
    -- Module.ChangePossessBar()

    frame:RegisterEvent('PLAYER_REGEN_ENABLED')

    Module.ChangeGryphon()
    -- Module.DrawActionbarDeco()

    Module.ChangeMicroMenuNew()
    Module.ChangeBackpackNew()
    Module.MoveBars()
    Module.ChangeFramerate()
    Module.CreateBagExpandButton()
    Module.RefreshBagBarToggle()
    Module.HookBags()
end
