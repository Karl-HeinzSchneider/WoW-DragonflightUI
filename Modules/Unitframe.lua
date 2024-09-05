---@diagnostic disable: undefined-global
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Unitframe'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

-- local db, getOptions

Module.famous = {['Norbert'] = true}

local defaults = {
    profile = {
        scale = 1,
        focus = {
            classcolor = false,
            breakUpLargeNumbers = true,
            scale = 1.0,
            override = false,
            anchorFrame = 'UIParent',
            anchor = 'TOPLEFT',
            anchorParent = 'TOPLEFT',
            x = 250,
            y = -170,
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
        player = {
            classcolor = false,
            breakUpLargeNumbers = true,
            scale = 1.0,
            override = false,
            anchorFrame = 'UIParent',
            anchor = 'TOPLEFT',
            anchorParent = 'TOPLEFT',
            x = -19,
            y = -4,
            biggerHealthbar = false,
            hideRedStatus = false,
            hideIndicator = false,
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
        target = {
            classcolor = false,
            classicon = false,
            breakUpLargeNumbers = true,
            enableNumericThreat = true,
            enableThreatGlow = true,
            comboPointsOnPlayerFrame = false,
            scale = 1.0,
            override = false,
            anchorFrame = 'UIParent',
            anchor = 'TOPLEFT',
            anchorParent = 'TOPLEFT',
            x = 250,
            y = -4,
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
            breakUpLargeNumbers = true,
            enableThreatGlow = true,
            scale = 1.0,
            override = false,
            anchorFrame = 'PlayerFrame',
            anchor = 'TOPRIGHT',
            anchorParent = 'BOTTOMRIGHT',
            x = 4,
            y = 28,
            hideStatusbarText = false,
            offset = true,
            hideIndicator = false,
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
        party = {
            classcolor = false,
            breakUpLargeNumbers = true,
            scale = 1.0,
            override = false,
            anchorFrame = 'CompactRaidFrameManager',
            anchor = 'TOPLEFT',
            anchorParent = 'TOPRIGHT',
            x = 0,
            y = 0,
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
        boss = {
            breakUpLargeNumbers = true,
            scale = 1.0,
            override = false,
            anchorFrame = 'UIParent',
            anchor = 'TOPRIGHT',
            anchorParent = 'TOPRIGHT',
            x = 55,
            y = -236
        }
    }
}
Module:SetDefaults(defaults)

local defaultsPROTO = {
    classcolor = false,
    scale = 1.0,
    override = false,
    anchor = 'TOPLEFT',
    anchorParent = 'TOPLEFT',
    x = -19,
    y = -4
}

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
    ['UIParent'] = 'UIParent',
    ['PlayerFrame'] = 'PlayerFrame',
    ['TargetFrame'] = 'TargetFrame',
    ['CompactRaidFrameManager'] = 'CompactRaidFrameManager'
}
if DF.Wrath then frameTable['FocusFrame'] = 'FocusFrame' end

local function frameTableWithout(without)
    local newTable = {}

    for k, v in pairs(frameTable) do if k ~= without then newTable[k] = v end end

    return newTable
end

local optionsPlayer = {
    name = 'Player',
    desc = 'PlayerframeDesc',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'player'),
            min = 0.1,
            max = 5,
            bigStep = 0.1,
            order = 1
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'player'),
            values = frameTableWithout('PlayerFrame'),
            order = 4
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
            order = 2
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
            order = 3
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'player'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'player'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6
        },
        classcolor = {type = 'toggle', name = 'Class Color', desc = 'Enable classcolors for the healthbar', order = 7},
        breakUpLargeNumbers = {
            type = 'toggle',
            name = 'Break Up Large Numbers',
            desc = 'Enable breaking up large numbers of the StatusText, e.g. 7588 K instead of 7588000',
            order = 8
        },
        biggerHealthbar = {
            type = 'toggle',
            name = 'Bigger Healthbar',
            desc = '' .. getDefaultStr('biggerHealthbar', 'player'),
            order = 9,
            new = true
        },
        hideRedStatus = {
            type = 'toggle',
            name = 'Hide In Combat Red Statusglow',
            desc = '' .. getDefaultStr('hideRedStatus', 'player'),
            order = 10,
            new = true
        },
        hideIndicator = {
            type = 'toggle',
            name = 'Hide Hit Indicator',
            desc = '' .. getDefaultStr('hideIndicator', 'player'),
            order = 11,
            new = true
        }
    }
}
if true then
    local moreOptions = {
        statusText = {
            type = 'select',
            name = STATUSTEXT_LABEL,
            desc = OPTION_TOOLTIP_STATUS_TEXT_DISPLAY,
            values = {
                ['None'] = 'None',
                ['Percent'] = 'Percent',
                ['Both'] = 'Both',
                ['Numeric Value'] = 'Numeric Value'
            },
            order = 10,
            blizzard = true
        }
    }

    for k, v in pairs(moreOptions) do optionsPlayer.args[k] = v end

    local CVAR_VALUE_NUMERIC = "NUMERIC";
    local CVAR_VALUE_PERCENT = "PERCENT";
    local CVAR_VALUE_BOTH = "BOTH";
    local CVAR_VALUE_NONE = "NONE";

    optionsPlayer.get = function(info)
        local key = info[1]
        local sub = info[2]

        if sub == 'statusText' then
            local statusTextDisplay = C_CVar.GetCVar("statusTextDisplay");
            if statusTextDisplay == CVAR_VALUE_NUMERIC then
                return 'Numeric Value';
            elseif statusTextDisplay == CVAR_VALUE_PERCENT then
                return 'Percent';
            elseif statusTextDisplay == CVAR_VALUE_BOTH then
                return 'Both';
            elseif statusTextDisplay == CVAR_VALUE_NONE then
                return 'None';
            end
        else
            return getOption(info)
        end
    end

    local textStatusBars = {
        PlayerFrameHealthBar, PlayerFrameManaBar, PetFrameHealthBar, PetFrameManaBar, TargetFrameHealthBar,
        TargetFrameManaBar, FocusFrameHealthBar, FocusFrameManaBar
    }

    local function CVarChangedCB()
        for k, v in ipairs(textStatusBars) do if v then TextStatusBar_UpdateTextString(v) end end
    end

    optionsPlayer.set = function(info, value)
        local key = info[1]
        local sub = info[2]

        if sub == 'statusText' then
            if value == 'Numeric Value' then
                SetCVar("statusTextDisplay", CVAR_VALUE_NUMERIC);
                SetCVar("statusText", "1");
            elseif value == 'Percent' then
                SetCVar("statusTextDisplay", CVAR_VALUE_PERCENT);
                SetCVar("statusText", "1");
            elseif value == 'Both' then
                SetCVar("statusTextDisplay", CVAR_VALUE_BOTH);
                SetCVar("statusText", "1");
            elseif value == 'None' then
                SetCVar("statusTextDisplay", CVAR_VALUE_NONE);
                SetCVar("statusText", "0");
            end
            CVarChangedCB()
        else
            setOption(info, value)
        end
    end
end
DragonflightUIStateHandlerMixin:AddStateTable(Module, optionsPlayer, 'player', 'Player', getDefaultStr)

local optionsTarget = {
    name = 'Target',
    desc = 'TargetFrameDesc',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'target'),
            min = 0.1,
            max = 5,
            bigStep = 0.1,
            order = 1
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'target'),
            values = frameTableWithout('TargetFrame'),
            order = 4
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
            order = 2
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
            order = 3
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'target'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'target'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6
        },
        classcolor = {type = 'toggle', name = 'Class Color', desc = 'Enable classcolors for the healthbar', order = 7},
        classicon = {type = 'toggle', name = 'Class Icon Portrait', desc = '', order = 7, disabled = true, new = false},
        breakUpLargeNumbers = {
            type = 'toggle',
            name = 'Break Up Large Numbers',
            desc = 'Enable breaking up large numbers of the StatusText, e.g. 7588 K instead of 7588000',
            order = 8
        },
        enableNumericThreat = {
            type = 'toggle',
            name = 'Numeric Threat',
            desc = 'Enable numeric threat',
            order = 9,
            disabled = not DF.Era
        },
        enableThreatGlow = {
            type = 'toggle',
            name = 'Threat Glow',
            desc = 'Enable threat glow',
            order = 10,
            disabled = true
        },
        comboPointsOnPlayerFrame = {
            type = 'toggle',
            name = 'ComboPoints on PlayerFrame',
            desc = '' .. getDefaultStr('comboPointsOnPlayerFrame', 'target'),
            order = 10,
            new = true
        }
    }
}
if true then
    local moreOptions = {
        targetOfTarget = {
            type = 'toggle',
            name = SHOW_TARGET_OF_TARGET_TEXT,
            desc = OPTION_TOOLTIP_SHOW_TARGET_OF_TARGET,
            order = 15,
            blizzard = true
        },
        buffsOnTop = {type = 'toggle', name = 'Buffs On Top', desc = '', order = 16, blizzard = true}
    }

    for k, v in pairs(moreOptions) do optionsTarget.args[k] = v end

    optionsTarget.get = function(info)
        local key = info[1]
        local sub = info[2]

        if sub == 'targetOfTarget' then
            local tot = C_CVar.GetCVar("showTargetOfTarget");
            if tot == '1' then
                return true
            else
                return false
            end
        elseif sub == 'buffsOnTop' then
            if TARGET_FRAME_BUFFS_ON_TOP then
                return true
            else
                return false
            end
        else
            return getOption(info)
        end
    end

    optionsTarget.set = function(info, value)
        local key = info[1]
        local sub = info[2]

        if sub == 'targetOfTarget' then
            if value then
                SetCVar("showTargetOfTarget", "1");
            else
                SetCVar("showTargetOfTarget", "0");
            end
        elseif sub == 'buffsOnTop' then
            if value then
                TARGET_FRAME_BUFFS_ON_TOP = true
                TargetFrame.buffsOnTop = true
            else
                TARGET_FRAME_BUFFS_ON_TOP = false
                TargetFrame.buffsOnTop = false
            end
            TargetFrame_UpdateAuras(TargetFrame)
        else
            setOption(info, value)
        end
    end
end
DragonflightUIStateHandlerMixin:AddStateTable(Module, optionsTarget, 'target', 'Target', getDefaultStr)

local optionsPet = {
    name = 'Pet',
    desc = 'PetFrameDesc',
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
            values = frameTableWithout('PetFrame'),
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
        breakUpLargeNumbers = {
            type = 'toggle',
            name = 'Break Up Large Numbers',
            desc = 'Enable breaking up large numbers of the StatusText, e.g. 7588 K instead of 7588000',
            order = 9
        },
        enableThreatGlow = {
            type = 'toggle',
            name = 'Threat Glow',
            desc = 'Enable threat glow',
            order = 8,
            disabled = true
        },
        hideStatusbarText = {type = 'toggle', name = 'Hide Statusbar Text', desc = '', order = 10},
        hideIndicator = {
            type = 'toggle',
            name = 'Hide Hit Indicator',
            desc = '' .. getDefaultStr('hideIndicator', 'pet'),
            order = 11,
            new = true
        }
    }
}

if DF.Cata then
    local moreOptions = {
        offset = {
            type = 'toggle',
            name = 'Auto adjust offset',
            desc = 'Auto add some Y offset depending on the class, e.g. on Deathknight to make room for the rune display' ..
                getDefaultStr('offset', 'pet'),
            order = 11,
            new = true
        }
    }

    for k, v in pairs(moreOptions) do optionsPet.args[k] = v end
end
DragonflightUIStateHandlerMixin:AddStateTable(Module, optionsPet, 'pet', 'Pet', getDefaultStr)

local optionsFocus = {
    name = 'Focus',
    desc = 'FocusFrameDesc',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'focus'),
            min = 0.1,
            max = 5,
            bigStep = 0.1,
            order = 1
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'focus'),
            values = frameTableWithout('FocusFrame'),
            order = 4
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
            order = 2
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
            order = 3
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'focus'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'focus'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6
        },
        classcolor = {type = 'toggle', name = 'Class Color', desc = 'Enable classcolors for the healthbar', order = 7},
        breakUpLargeNumbers = {
            type = 'toggle',
            name = 'Break Up Large Numbers',
            desc = 'Enable breaking up large numbers of the StatusText, e.g. 7588 K instead of 7588000',
            order = 8
        }
    }
}
DragonflightUIStateHandlerMixin:AddStateTable(Module, optionsFocus, 'focus', 'Focus', getDefaultStr)

local optionsParty = {
    name = 'Party',
    desc = 'PartyframeDesc',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'party'),
            min = 0.1,
            max = 5,
            bigStep = 0.1,
            order = 1
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'party'),
            values = frameTable,
            order = 4
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'party'),
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
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'party'),
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
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'party'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'party'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6
        },
        classcolor = {type = 'toggle', name = 'Class Color', desc = 'Enable classcolors for the healthbar', order = 7},
        breakUpLargeNumbers = {
            type = 'toggle',
            name = 'Break Up Large Numbers',
            desc = 'Enable breaking up large numbers of the StatusText, e.g. 7588 K instead of 7588000',
            order = 8
        }
    }
}
if true then
    local moreOptions = {
        useCompactPartyFrames = {
            type = 'toggle',
            name = USE_RAID_STYLE_PARTY_FRAMES,
            desc = OPTION_TOOLTIP_USE_RAID_STYLE_PARTY_FRAMES,
            order = 15,
            blizzard = true
        },
        raidFrameBtn = {
            type = 'execute',
            name = 'Raid Frame Settings',
            btnName = 'Open',
            func = function()
                Settings.OpenToCategory(Settings.INTERFACE_CATEGORY_ID, RAID_FRAMES_LABEL);
                PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
            end,
            order = 16,
            blizzard = true
        }
    }

    for k, v in pairs(moreOptions) do optionsParty.args[k] = v end

    optionsParty.get = function(info)
        local key = info[1]
        local sub = info[2]

        if sub == 'useCompactPartyFrames' then
            local value = C_CVar.GetCVar("useCompactPartyFrames");
            if value == '1' then
                return true
            else
                return false
            end
        else
            return getOption(info)
        end
    end

    optionsParty.set = function(info, value)
        local key = info[1]
        local sub = info[2]

        if sub == 'useCompactPartyFrames' then
            if value then
                SetCVar("useCompactPartyFrames", "1");
            else
                SetCVar("useCompactPartyFrames", "0");
            end
        else
            setOption(info, value)
        end
    end
end
DragonflightUIStateHandlerMixin:AddStateTable(Module, optionsParty, 'party', 'Party', getDefaultStr)

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
        target = optionsTarget,
        pet = optionsPet,
        party = optionsParty
    }
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)
    -- db = self.db.profile

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
    Module.AddStateUpdater()

    Module:SaveLocalSettings()
    Module:ApplySettings()

    hooksecurefunc('UIParent_UpdateTopFramePositions', function()
        Module:SaveLocalSettings()
    end)
    Module:RegisterOptionScreens()

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)      
        Module:ApplySettings()
        Module:RefreshOptionScreens()
    end)

    -- Module.FixBlizzardBug()
end

function Module:OnDisable()
end

function Module:RegisterOptionScreens()
    local function filterTableByFunction(opts, fnc)
        local newOpts = {}
        for k, v in pairs(opts) do if k ~= 'args' then newOpts[k] = v end end
        newOpts.args = {}
        for k, v in pairs(opts.args) do if fnc(v.type) then newOpts.args[k] = v end end
        return newOpts
    end

    if DF.Wrath then
        DF.ConfigModule:RegisterOptionScreen('Unitframes', 'Focus', {
            name = 'Focus',
            sub = 'focus',
            options = optionsFocus,
            default = function()
                setDefaultSubValues('focus')
            end
        })
    end

    DF.ConfigModule:RegisterOptionScreen('Unitframes', 'Party', {
        name = 'Party',
        sub = 'party',
        options = optionsParty,
        default = function()
            setDefaultSubValues('party')
        end
    })
    DF.ConfigModule:RegisterOptionScreen('Unitframes', 'Pet', {
        name = 'Pet',
        sub = 'pet',
        options = optionsPet,
        default = function()
            setDefaultSubValues('pet')
        end
    })
    DF.ConfigModule:RegisterOptionScreen('Unitframes', 'Player', {
        name = 'Player',
        sub = 'player',
        options = optionsPlayer,
        default = function()
            setDefaultSubValues('player')
        end
    })
    DF.ConfigModule:RegisterOptionScreen('Unitframes', 'Target', {
        name = 'Target',
        sub = 'target',
        options = optionsTarget,
        default = function()
            setDefaultSubValues('target')
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
    refreshCat('Target')
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

function Module:ApplySettings()
    local db = Module.db.profile
    local orig = defaults.profile

    -- playerframe
    do
        local obj = db.player
        local objLocal = localSettings.player

        Module.MovePlayerFrame(obj.anchor, obj.anchorParent, obj.anchorFrame, obj.x, obj.y)
        PlayerFrame:SetUserPlaced(true)

        PlayerFrame:SetScale(obj.scale)
        Module.ChangePlayerframe()
        Module.SetPlayerBiggerHealthbar(obj.biggerHealthbar)
        PlayerFrameHealthBar.breakUpLargeNumbers = obj.breakUpLargeNumbers
        TextStatusBar_UpdateTextString(PlayerFrameHealthBar)

        if obj.hideIndicator then
            PlayerHitIndicator:SetScale(0.01)
        else
            PlayerHitIndicator:SetScale(1)
        end

        PlayerFrame:UpdateStateHandler(obj)
    end

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
        Module.UpdateComboFrameState(obj.comboPointsOnPlayerFrame)

        TargetFrame:UpdateStateHandler(obj)
    end

    -- pet
    do
        local obj = db.pet
        local objLocal = localSettings.pet

        PetFrame:ClearAllPoints()
        local offsetY = DF.Cata and Module.GetPetOffset(obj.offset) or 0
        PetFrame:SetPoint(obj.anchor, obj.anchorFrame, obj.anchorParent, obj.x, obj.y + offsetY)

        PetFrame:SetScale(obj.scale)
        Module.ReApplyTargetFrame()
        PetFrame.breakUpLargeNumbers = obj.breakUpLargeNumbers
        TextStatusBar_UpdateTextString(PetFrameHealthBar)

        local alpha = 1
        if obj.hideStatusbarText then alpha = 0 end
        PetFrameHealthBarText:SetAlpha(alpha)
        PetFrameHealthBarTextLeft:SetAlpha(alpha)
        PetFrameHealthBarTextRight:SetAlpha(alpha)

        PetFrameManaBarText:SetAlpha(alpha)
        PetFrameManaBarTextLeft:SetAlpha(alpha)
        PetFrameManaBarTextRight:SetAlpha(alpha)

        if obj.hideIndicator then
            PetHitIndicator:SetScale(0.01)
        else
            PetHitIndicator:SetScale(1)
        end

        PetFrame:UpdateStateHandler(obj)
    end

    -- party
    do
        local obj = db.party
        local objLocal = localSettings.party

        local party1 = _G['PartyMemberFrame' .. 1]
        party1:ClearAllPoints()
        party1:SetPoint(obj.anchor, obj.anchorFrame, obj.anchorParent, obj.x, obj.y)

        for i = 1, 4 do
            local pf = _G['PartyMemberFrame' .. i]
            -- local dfScale = 1.25
            local dfScale = 1
            pf:SetScale(obj.scale * dfScale)
            Module.UpdatePartyHPBar(i)
            TextStatusBar_UpdateTextString(_G['PartyMemberFrame' .. i .. 'HealthBar'])
            TextStatusBar_UpdateTextString(_G['PartyMemberFrame' .. i .. 'ManaBar'])

            pf:UpdateStateHandler(obj)
        end
    end

    if DF.Wrath then
        -- focus
        do
            local obj = db.focus
            local objLocal = localSettings.focus

            Module.MoveFocusFrame(obj.anchor, obj.anchorParent, obj.anchorFrame, obj.x, obj.y)
            FocusFrame:SetUserPlaced(true)

            FocusFrame:SetScale(obj.scale)
            Module.ReApplyFocusFrame()
            Module.ReApplyFocusToT()
            FocusFrameHealthBar.breakUpLargeNumbers = obj.breakUpLargeNumbers
            TextStatusBar_UpdateTextString(FocusFrameHealthBar)

            FocusFrame:UpdateStateHandler(obj)
        end
    end
end

function Module.MovePlayerTargetPreset(name)
    local db = Module.db.profile

    if name == 'DEFAULT' then
        local orig = defaults.profile

        db.playerOverride = false
        db.playerAnchor = orig.playerAnchor
        db.playerAnchorParent = orig.playerAnchorParent
        db.playerX = orig.playerX
        db.playerY = orig.playerY

        db.targetOverride = false
        db.targetAnchor = orig.targetAnchor
        db.targetAnchorParent = orig.targetAnchorParent
        db.targetX = orig.targetX
        db.targetY = orig.targetY

        Module:ApplySettings()
    elseif name == 'CENTER' then
        local deltaX = 50
        local deltaY = 180

        db.playerOverride = true
        db.playerAnchor = 'CENTER'
        db.playerAnchorParent = 'CENTER'
        -- player and target frame center is not perfect/identical
        db.playerX = -107.5 - deltaX
        db.playerY = -deltaY

        db.targetOverride = true
        db.targetAnchor = 'CENTER'
        db.targetAnchorParent = 'CENTER'
        -- see above
        db.targetX = 112 + deltaX
        db.targetY = -deltaY

        Module:ApplySettings()
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
    Mixin(PlayerFrame, DragonflightUIStateHandlerMixin)
    PlayerFrame:InitStateHandler()

    PetFrame:SetParent(UIParent)
    Mixin(PetFrame, DragonflightUIStateHandlerMixin)
    PetFrame:InitStateHandler()
    PetFrame:SetUnit('pet')

    Mixin(TargetFrame, DragonflightUIStateHandlerMixin)
    TargetFrame:InitStateHandler()
    TargetFrame:SetUnit('target')

    if DF.Wrath then
        Mixin(FocusFrame, DragonflightUIStateHandlerMixin)
        FocusFrame:InitStateHandler()
        FocusFrame:SetUnit('focus')
    end

    for i = 1, 4 do
        local pf = _G['PartyMemberFrame' .. i]
        Mixin(pf, DragonflightUIStateHandlerMixin)
        pf:InitStateHandler()
        pf:SetUnit('party' .. i)
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

function Module.CreatePlayerFrameTextures()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    if not frame.PlayerFrameBackground then
        local background = PlayerFrame:CreateTexture('DragonflightUIPlayerFrameBackground')
        background:SetDrawLayer('BACKGROUND', 2)
        background:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Player-PortraitOn-BACKGROUND')
        background:SetPoint('LEFT', PlayerFrameHealthBar, 'LEFT', -67, -28.5)

        background:SetTexture(base)
        background:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-PortraitOn'))
        background:SetSize(198, 71)
        background:SetPoint('LEFT', PlayerFrameHealthBar, 'LEFT', -67, 0)
        frame.PlayerFrameBackground = background
    end

    if not frame.PlayerFrameBorder then
        local border = PlayerFrameHealthBar:CreateTexture('DragonflightUIPlayerFrameBorder')
        border:SetDrawLayer('ARTWORK', 2)
        border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Player-PortraitOn-BORDER')
        border:SetPoint('LEFT', PlayerFrameHealthBar, 'LEFT', -67, -28.5)
        frame.PlayerFrameBorder = border
    end

    if not frame.PlayerFrameDeco then
        local textureSmall = PlayerFrame:CreateTexture('DragonflightUIPlayerFrameDeco')
        textureSmall:SetDrawLayer('OVERLAY', 5)
        textureSmall:SetTexture(base)
        textureSmall:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-PortraitOn-CornerEmbellishment'))
        local delta = 15
        textureSmall:SetPoint('CENTER', PlayerPortrait, 'CENTER', delta, -delta - 2)
        textureSmall:SetSize(23, 23)
        textureSmall:SetScale(1)
        frame.PlayerFrameDeco = textureSmall
    end
end

function Module.ChangeStatusIcons()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    PlayerAttackIcon:SetTexture(base)
    PlayerAttackIcon:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-CombatIcon'))
    PlayerAttackIcon:ClearAllPoints()
    PlayerAttackIcon:SetPoint('BOTTOMRIGHT', PlayerPortrait, 'BOTTOMRIGHT', -3, 0)
    PlayerAttackIcon:SetSize(16, 16)

    PlayerAttackBackground:SetTexture(base)
    PlayerAttackBackground:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-CombatIcon-Glow'))
    PlayerAttackBackground:ClearAllPoints()
    PlayerAttackBackground:SetPoint('CENTER', PlayerAttackIcon, 'CENTER')
    PlayerAttackBackground:SetSize(32, 32)

    PlayerFrameGroupIndicator:ClearAllPoints()
    -- PlayerFrameGroupIndicator:SetPoint('BOTTOMRIGHT', PlayerFrameHealthBar, 'TOPRIGHT', 4, 13)
    PlayerFrameGroupIndicator:SetPoint('BOTTOM', PlayerName, 'TOP', 0, 0)

    PlayerLeaderIcon:SetTexture(base)
    PlayerLeaderIcon:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-Group-LeaderIcon'))
    -- PlayerLeaderIcon:ClearAllPoints()
    -- PlayerLeaderIcon:SetPoint('BOTTOM', PlayerName, 'TOP', 0, 0)
    PlayerLeaderIcon:ClearAllPoints()
    PlayerLeaderIcon:SetPoint('BOTTOMRIGHT', PlayerPortrait, 'TOPLEFT', 10, -10)

    TargetFrameTextureFrameLeaderIcon:SetTexture(base)
    TargetFrameTextureFrameLeaderIcon:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-Group-LeaderIcon'))
    TargetFrameTextureFrameLeaderIcon:ClearAllPoints()
    TargetFrameTextureFrameLeaderIcon:SetPoint('BOTTOMLEFT', TargetFramePortrait, 'TOPRIGHT', -10 - 3, -10)
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

function Module.UpdatePlayerFrameHealthBar()
    if Module.db.profile.player.classcolor then
        PlayerFrameHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health-Status')

        local localizedClass, englishClass, classIndex = UnitClass('player')
        PlayerFrameHealthBar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
    else
        PlayerFrameHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health')
        PlayerFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)
    end
end

function Module.HookClassIcon()
    Module:Unhook('UnitFramePortrait_Update')
    Module:SecureHook('UnitFramePortrait_Update', function(self)
        -- print('UnitFramePortrait_Update', self:GetName())
        if not self.portrait then return end

        local icon = Module.db.profile.target.classicon
        local unit = self.unit

        if (not icon) or unit == "player" or unit == "pet" or (not UnitIsPlayer(unit)) then
            self.portrait:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
            SetPortraitTexture(self.portrait, unit);
            return
        end

        local texCoords = CLASS_ICON_TCOORDS[select(2, UnitClass(unit))]
        if texCoords then
            self.portrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
            self.portrait:SetTexCoord(unpack(texCoords))
        end
    end)
end

function Module.HookVertexColor()
    PlayerFrameHealthBar:HookScript('OnValueChanged', Module.UpdatePlayerFrameHealthBar)
    PlayerFrameHealthBar:HookScript('OnEvent', function(self, event, arg1)
        if event == 'UNIT_MAXHEALTH' and arg1 == 'player' then Module.UpdatePlayerFrameHealthBar() end
    end)

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

function Module.HookEnergyBar()
    hooksecurefunc("UnitFrameManaBar_UpdateType", function(manaBar)
        -- print('UnitFrameManaBar_UpdateType', manaBar:GetName())
        local name = manaBar:GetName()

        if name == 'PlayerFrameManaBar' then
            local powerType, powerTypeString = UnitPowerType('player')

            if powerTypeString == 'MANA' then
                PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana')
            elseif powerTypeString == 'RAGE' then
                PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Rage')
            elseif powerTypeString == 'FOCUS' then
                PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Focus')
            elseif powerTypeString == 'ENERGY' then
                PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Energy')
            elseif powerTypeString == 'RUNIC_POWER' then
                PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-RunicPower')
            end

            PlayerFrameManaBar:SetStatusBarColor(1, 1, 1, 1)

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
        elseif name == 'FocusFrameToTManaBar' then
            Module.ReApplyFocusToT()
        elseif name == 'PartyMemberFrame1ManaBar' then
            Module.UpdatePartyManaBar(1)
        elseif name == 'PartyMemberFrame2ManaBar' then
            Module.UpdatePartyManaBar(2)
        elseif name == 'PartyMemberFrame3ManaBar' then
            Module.UpdatePartyManaBar(3)
        elseif name == 'PartyMemberFrame4ManaBar' then
            Module.UpdatePartyManaBar(4)
        elseif name == 'PetFrameManaBar' then
            -- frame.UpdatePetManaBarTexture()
        else
            -- print('HookEnergyBar', manaBar:GetName())
        end
    end)
end

function Module.ChangePlayerframe()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    -- Module.RefreshPortrait()

    PlayerFrameTexture:Hide()
    PlayerFrameBackground:Hide()
    PlayerFrameVehicleTexture:Hide()

    PlayerPortrait:ClearAllPoints()
    PlayerPortrait:SetPoint('TOPLEFT', PlayerFrame, 'TOPLEFT', 42, -15)
    PlayerPortrait:SetDrawLayer('ARTWORK', 5)
    PlayerPortrait:SetSize(56, 56)

    -- @TODO: change text spacing
    PlayerName:ClearAllPoints()
    PlayerName:SetPoint('BOTTOMLEFT', PlayerFrameHealthBar, 'TOPLEFT', 0, 1)

    PlayerLevelText:ClearAllPoints()
    PlayerLevelText:SetPoint('BOTTOMRIGHT', PlayerFrameHealthBar, 'TOPRIGHT', -5, 1)

    -- Health 119,12
    PlayerFrameHealthBar:SetSize(125, 20)
    PlayerFrameHealthBar:ClearAllPoints()
    PlayerFrameHealthBar:SetPoint('LEFT', PlayerPortrait, 'RIGHT', 1, 0)

    Module.UpdatePlayerFrameHealthBar()

    PlayerFrameHealthBarText:SetPoint('CENTER', PlayerFrameHealthBar, 'CENTER', 0, 0)

    local dx = 5
    PlayerFrameHealthBarTextLeft:SetPoint('LEFT', PlayerFrameHealthBar, 'LEFT', dx, 0)
    PlayerFrameHealthBarTextRight:SetPoint('RIGHT', PlayerFrameHealthBar, 'RIGHT', -dx, 0)

    -- Mana 119,12
    PlayerFrameManaBar:ClearAllPoints()
    PlayerFrameManaBar:SetPoint('LEFT', PlayerPortrait, 'RIGHT', 1, -17 + 0.5)
    PlayerFrameManaBar:SetSize(125, 8)

    PlayerFrameManaBarText:SetPoint('CENTER', PlayerFrameManaBar, 'CENTER', 0, 0)
    PlayerFrameManaBarTextLeft:SetPoint('LEFT', PlayerFrameManaBar, 'LEFT', dx, 0)
    PlayerFrameManaBarTextRight:SetPoint('RIGHT', PlayerFrameManaBar, 'RIGHT', -dx, 0)

    local powerType, powerTypeString = UnitPowerType('player')

    if powerTypeString == 'MANA' then
        PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana')
    elseif powerTypeString == 'RAGE' then
        PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Rage')
    elseif powerTypeString == 'FOCUS' then
        PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Focus')
    elseif powerTypeString == 'ENERGY' then
        PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Energy')
    elseif powerTypeString == 'RUNIC_POWER' then
        PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-RunicPower')
    end

    PlayerFrameManaBar:SetStatusBarColor(1, 1, 1, 1)

    -- UI-HUD-UnitFrame-Player-PortraitOn-Status
    PlayerStatusTexture:SetTexture(base)
    PlayerStatusTexture:SetSize(192, 71)
    PlayerStatusTexture:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-PortraitOn-InCombat'))

    PlayerStatusTexture:ClearAllPoints()
    PlayerStatusTexture:SetPoint('TOPLEFT', frame.PlayerFrameBorder, 'TOPLEFT', 1, 1)

    if DF.Wrath then RuneFrame:SetPoint('TOP', PlayerFrame, 'BOTTOM', 54 - 3, 34 - 3) end

    if DF.Cata then
        PaladinPowerBar:SetPoint('TOP', PlayerFrame, 'BOTTOM', 43, 39 - 2)
        ShardBarFrame:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50, 34 - 1)
    end
end
-- ChangePlayerframe()
-- frame:RegisterEvent('PLAYER_ENTERING_WORLD')

function Module.SetPlayerBiggerHealthbar(bigger)
    local border = frame.PlayerFrameBorder
    local background = frame.PlayerFrameBackground

    if not border or not background then return end

    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    if bigger then
        background:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\plunderstorm-UI-HUD-UnitFrame-Player-PortraitOn')
        background:SetTexCoord(0, 198 / 256, 0, 71 / 128)
        background:SetSize(198, 71)
        background:SetPoint('LEFT', PlayerFrameHealthBar, 'LEFT', -67, 0 + 6)

        border:SetDrawLayer('ARTWORK', 2)
        border:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Player-PortraitOn-BORDER-Plunder')
        border:SetPoint('LEFT', PlayerFrameHealthBar, 'LEFT', -67, -28.5 + 6)

        PlayerStatusTexture:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\plunderstorm-UI-HUD-UnitFrame-Player-PortraitOn-InCombat')
        PlayerStatusTexture:SetSize(192, 71)
        PlayerStatusTexture:SetTexCoord(0, 192 / 256, 0, 71 / 128)

        PlayerFrameHealthBar:SetSize(125, 32)
        PlayerFrameHealthBar:ClearAllPoints()
        PlayerFrameHealthBar:SetPoint('LEFT', PlayerPortrait, 'RIGHT', 1, 0 - 6)

        PlayerFrameManaBar:SetAlpha(0)
        PlayerFrameManaBarText:SetAlpha(0)
        PlayerFrameManaBarTextLeft:SetAlpha(0)
        PlayerFrameManaBarTextRight:SetAlpha(0)
    else
        background:SetTexture(base)
        background:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-PortraitOn'))
        background:SetSize(198, 71)
        background:SetPoint('LEFT', PlayerFrameHealthBar, 'LEFT', -67, 0)

        border:SetDrawLayer('ARTWORK', 2)
        border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Player-PortraitOn-BORDER')
        border:SetPoint('LEFT', PlayerFrameHealthBar, 'LEFT', -67, -28.5)

        PlayerStatusTexture:SetTexture(base)
        PlayerStatusTexture:SetSize(192, 71)
        PlayerStatusTexture:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-PortraitOn-InCombat'))

        PlayerFrameHealthBar:SetSize(125, 20)
        PlayerFrameHealthBar:ClearAllPoints()
        PlayerFrameHealthBar:SetPoint('LEFT', PlayerPortrait, 'RIGHT', 1, 0)

        PlayerFrameManaBar:SetAlpha(1)
        PlayerFrameManaBarText:SetAlpha(1)
        PlayerFrameManaBarTextLeft:SetAlpha(1)
        PlayerFrameManaBarTextRight:SetAlpha(1)
    end
end

function Module.UpdatePlayerStatus()
    if not frame.PlayerFrameDeco then return end

    -- TODO: fix statusglow
    PlayerStatusGlow:Hide()

    if UnitHasVehiclePlayerFrameUI and UnitHasVehiclePlayerFrameUI('player') then
        -- TODO: vehicle stuff
        -- frame.PlayerFrameDeco:Show()
        frame.RestIcon:Hide()
        frame.RestIconAnimation:Stop()
        -- frame.PlayerFrameDeco:Show()
    elseif IsResting() then
        frame.PlayerFrameDeco:Show()
        frame.PlayerFrameBorder:SetVertexColor(1.0, 1.0, 1.0, 1.0)

        frame.RestIcon:Show()
        frame.RestIconAnimation:Play()

        -- PlayerStatusTexture:Show()
        -- PlayerStatusTexture:SetVertexColor(1.0, 0.88, 0.25, 1.0)
        PlayerStatusTexture:SetAlpha(1.0)
    elseif PlayerFrame.onHateList then
        -- PlayerStatusTexture:Show()
        -- PlayerStatusTexture:SetVertexColor(1.0, 0, 0, 1.0)
        frame.PlayerFrameDeco:Hide()

        frame.RestIcon:Hide()
        frame.RestIconAnimation:Stop()

        frame.PlayerFrameBorder:SetVertexColor(1.0, 0, 0, 1.0)
        frame.PlayerFrameBackground:SetVertexColor(1.0, 0, 0, 1.0)
    elseif PlayerFrame.inCombat then
        frame.PlayerFrameDeco:Hide()

        frame.RestIcon:Hide()
        frame.RestIconAnimation:Stop()

        frame.PlayerFrameBackground:SetVertexColor(1.0, 0, 0, 1.0)

        -- PlayerStatusTexture:Show()
        -- PlayerStatusTexture:SetVertexColor(1.0, 0, 0, 1.0)
        PlayerStatusTexture:SetAlpha(1.0)
    else
        frame.PlayerFrameDeco:Show()

        frame.RestIcon:Hide()
        frame.RestIconAnimation:Stop()

        frame.PlayerFrameBorder:SetVertexColor(1.0, 1.0, 1.0, 1.0)
        frame.PlayerFrameBackground:SetVertexColor(1.0, 1.0, 1.0, 1.0)
    end

    local db = Module.db.profile.player
    if db.hideRedStatus and (PlayerFrame.onHateList or PlayerFrame.inCombat) then
        --
        frame.PlayerFrameBorder:SetVertexColor(1.0, 1.0, 1.0, 1.0)
        frame.PlayerFrameBackground:SetVertexColor(1.0, 1.0, 1.0, 1.0)
        PlayerStatusTexture:SetAlpha(0)
        PlayerStatusTexture:Hide()
    end
end

function Module.HookPlayerStatus()
    hooksecurefunc('PlayerFrame_UpdateStatus', function()
        --
        Module.UpdatePlayerStatus()
    end)
end

function Module.HookPlayerArt()
    hooksecurefunc('PlayerFrame_ToPlayerArt', function()
        -- print('PlayerFrame_ToPlayerArt')
        Module.ChangePlayerframe()
        Module.SetPlayerBiggerHealthbar(Module.db.profile.player.biggerHealthbar)
    end)
end

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

    TargetFramePortrait:SetDrawLayer('ARTWORK', 1)
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

    TargetFrameTextureFrameLevelText:ClearAllPoints()
    TargetFrameTextureFrameLevelText:SetPoint('BOTTOMRIGHT', TargetFrameHealthBar, 'TOPLEFT', 16, 3 - 2)

    TargetFrameTextureFrameDeadText:ClearAllPoints()
    TargetFrameTextureFrameDeadText:SetPoint('CENTER', TargetFrameHealthBar, 'CENTER', 0, 0)

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
    TargetFrameManaBar:SetPoint('RIGHT', TargetFramePortrait, 'LEFT', -1 + 8 - 0.5, -18 + 1 + 0.5)
    TargetFrameManaBar:SetSize(132, 9)
    TargetFrameManaBar:SetStatusBarColor(1, 1, 1, 1)

    TargetFrameNameBackground:SetTexture(base)
    TargetFrameNameBackground:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Target-PortraitOn-Type'))
    TargetFrameNameBackground:SetSize(135, 18)
    TargetFrameNameBackground:ClearAllPoints()
    TargetFrameNameBackground:SetPoint('BOTTOMLEFT', TargetFrameHealthBar, 'TOPLEFT', -2, -4 - 1)

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

function Module.UpdateComboFrameState(onPlayer)
    local c = ComboFrame

    if onPlayer then
        c:SetParent(PlayerFrame)
        c:SetSize(116, 20)
        c:ClearAllPoints()
        c:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50 - 8, 34 + 4)
        -- ShardBarFrame:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50, 34 - 1)   

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

function Module.ReApplyFocusToT()
    if Module.db.profile.focus.classcolor and UnitIsPlayer('focusTarget') then
        FocusFrameToTHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health-Status')
        local localizedClass, englishClass, classIndex = UnitClass('focusTarget')
        FocusFrameToTHealthBar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
    else
        FocusFrameToTHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health')
        FocusFrameToTHealthBar:SetStatusBarColor(1, 1, 1, 1)
    end

    local powerType, powerTypeString = UnitPowerType('focusTarget')

    if powerTypeString == 'MANA' then
        FocusFrameToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana')
    elseif powerTypeString == 'FOCUS' then
        FocusFrameToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Focus')
    elseif powerTypeString == 'RAGE' then
        FocusFrameToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Rage')
    elseif powerTypeString == 'ENERGY' then
        FocusFrameToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Energy')
    elseif powerTypeString == 'RUNIC_POWER' then
        FocusFrameToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-RunicPower')
    end

    FocusFrameToTManaBar:SetStatusBarColor(1, 1, 1, 1)
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
    TargetFrameToT:SetPoint('BOTTOMRIGHT', TargetFrame, 'BOTTOMRIGHT', -35, -10 - 5)

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

    TargetFrameToTDebuff1:SetPoint('TOPLEFT', TargetFrameToT, 'TOPRIGHT', 25, -20)
end

function Module.ChangeFocusFrame()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    FocusFrameTextureFrameTexture:Hide()
    FocusFrameBackground:Hide()

    if not frame.FocusFrameBackground then
        local background = FocusFrame:CreateTexture('DragonflightUIFocusFrameBackground')
        background:SetDrawLayer('BACKGROUND', 2)
        background:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BACKGROUND')
        background:SetPoint('LEFT', FocusFrame, 'LEFT', 0, -32.5 + 10)
        frame.FocusFrameBackground = background
    end

    if not frame.FocusFrameBorder then
        local border = FocusFrame:CreateTexture('DragonflightUIFocusFrameBorder')
        border:SetDrawLayer('ARTWORK', 2)
        border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BORDER')
        border:SetPoint('LEFT', FocusFrame, 'LEFT', 0, -32.5 + 10)
        frame.FocusFrameBorder = border
    end

    FocusFramePortrait:SetDrawLayer('ARTWORK', 1)
    FocusFramePortrait:SetSize(56, 56)
    local CorrectionY = -3
    local CorrectionX = -5
    FocusFramePortrait:SetPoint('TOPRIGHT', FocusFrame, 'TOPRIGHT', -42 + CorrectionX, -12 + CorrectionY)

    FocusFrameTextureFrameRaidTargetIcon:SetPoint('CENTER', FocusFramePortrait, 'TOP', 0, 2)

    FocusFrameNameBackground:ClearAllPoints()
    FocusFrameNameBackground:SetTexture(base)
    FocusFrameNameBackground:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Target-PortraitOn-Type'))
    FocusFrameNameBackground:SetSize(135, 18)
    FocusFrameNameBackground:ClearAllPoints()
    FocusFrameNameBackground:SetPoint('BOTTOMLEFT', FocusFrameHealthBar, 'TOPLEFT', -2, -4 - 1)

    -- @TODO: change text spacing
    FocusFrameTextureFrameName:ClearAllPoints()
    FocusFrameTextureFrameName:SetPoint('BOTTOM', FocusFrameHealthBar, 'TOP', 10, 3 - 2)

    FocusFrameTextureFrameLevelText:ClearAllPoints()
    FocusFrameTextureFrameLevelText:SetPoint('BOTTOMRIGHT', FocusFrameHealthBar, 'TOPLEFT', 16, 3 - 2)

    FocusFrameTextureFrameDeadText:ClearAllPoints()
    FocusFrameTextureFrameDeadText:SetPoint('CENTER', FocusFrameHealthBar, 'CENTER', 0, 0)

    local dx = 5
    -- health vs mana bar
    local deltaSize = 132 - 125

    FocusFrameTextureFrame.HealthBarText:ClearAllPoints()
    FocusFrameTextureFrame.HealthBarText:SetPoint('CENTER', FocusFrameHealthBar, 0, 0)
    FocusFrameTextureFrame.HealthBarTextLeft:SetPoint('LEFT', FocusFrameHealthBar, 'LEFT', dx, 0)
    FocusFrameTextureFrame.HealthBarTextRight:SetPoint('RIGHT', FocusFrameHealthBar, 'RIGHT', -dx, 0)

    FocusFrameTextureFrame.ManaBarText:ClearAllPoints()
    FocusFrameTextureFrame.ManaBarText:SetPoint('CENTER', FocusFrameManaBar, -deltaSize / 2, 0)
    FocusFrameTextureFrame.ManaBarTextLeft:SetPoint('LEFT', FocusFrameManaBar, 'LEFT', dx, 0)
    FocusFrameTextureFrame.ManaBarTextRight:SetPoint('RIGHT', FocusFrameManaBar, 'RIGHT', -deltaSize - dx, 0)

    -- Health 119,12
    FocusFrameHealthBar:ClearAllPoints()
    FocusFrameHealthBar:SetSize(125, 20)
    FocusFrameHealthBar:SetPoint('RIGHT', FocusFramePortrait, 'LEFT', -1, 0)
    --[[    FocusFrameHealthBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOff-Bar-Health'
    )
    FocusFrameHealthBar:SetStatusBarColor(1, 1, 1, 1) ]]
    -- Mana 119,12
    FocusFrameManaBar:ClearAllPoints()
    FocusFrameManaBar:SetPoint('RIGHT', FocusFramePortrait, 'LEFT', -1 + 8 - 0.5, -18 + 1 + 0.5)
    FocusFrameManaBar:SetSize(132, 9)
    FocusFrameManaBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana')
    FocusFrameManaBar:SetStatusBarColor(1, 1, 1, 1)

    -- CUSTOM HealthText
    if not frame.FocusFrameHealthBarText then
        local FocusFrameHealthBarDummy = CreateFrame('FRAME', 'FocusFrameHealthBarDummy')
        FocusFrameHealthBarDummy:SetPoint('LEFT', FocusFrameHealthBar, 'LEFT', 0, 0)
        FocusFrameHealthBarDummy:SetPoint('TOP', FocusFrameHealthBar, 'TOP', 0, 0)
        FocusFrameHealthBarDummy:SetPoint('RIGHT', FocusFrameHealthBar, 'RIGHT', 0, 0)
        FocusFrameHealthBarDummy:SetPoint('BOTTOM', FocusFrameHealthBar, 'BOTTOM', 0, 0)
        FocusFrameHealthBarDummy:SetParent(FocusFrame)
        FocusFrameHealthBarDummy:SetFrameStrata('LOW')
        FocusFrameHealthBarDummy:SetFrameLevel(3)
        FocusFrameHealthBarDummy:EnableMouse(true)

        frame.FocusFrameHealthBarDummy = FocusFrameHealthBarDummy

        local t = FocusFrameHealthBarDummy:CreateFontString('FocusFrameHealthBarText', 'OVERLAY', 'TextStatusBarText')

        t:SetPoint('CENTER', FocusFrameHealthBarDummy, 0, 0)
        t:SetText('HP')
        t:Hide()
        frame.FocusFrameHealthBarText = t

        FocusFrameHealthBarDummy:HookScript('OnEnter', function(self)
            if FocusFrameTextureFrame.HealthBarTextRight:IsVisible() or FocusFrameTextureFrame.HealthBarText:IsVisible() then
            else
                Module.UpdateFocusText()
                frame.FocusFrameHealthBarText:Show()
            end
        end)
        FocusFrameHealthBarDummy:HookScript('OnLeave', function(self)
            frame.FocusFrameHealthBarText:Hide()
        end)
    end

    -- CUSTOM ManaText
    if not frame.FocusFrameManaBarText then
        local FocusFrameManaBarDummy = CreateFrame('FRAME', 'FocusFrameManaBarDummy')
        FocusFrameManaBarDummy:SetPoint('LEFT', FocusFrameManaBar, 'LEFT', 0, 0)
        FocusFrameManaBarDummy:SetPoint('TOP', FocusFrameManaBar, 'TOP', 0, 0)
        FocusFrameManaBarDummy:SetPoint('RIGHT', FocusFrameManaBar, 'RIGHT', 0, 0)
        FocusFrameManaBarDummy:SetPoint('BOTTOM', FocusFrameManaBar, 'BOTTOM', 0, 0)
        FocusFrameManaBarDummy:SetParent(FocusFrame)
        FocusFrameManaBarDummy:SetFrameStrata('LOW')
        FocusFrameManaBarDummy:SetFrameLevel(3)
        FocusFrameManaBarDummy:EnableMouse(true)

        frame.FocusFrameManaBarDummy = FocusFrameManaBarDummy

        local t = FocusFrameManaBarDummy:CreateFontString('FocusFrameManaBarText', 'OVERLAY', 'TextStatusBarText')

        t:SetPoint('CENTER', FocusFrameManaBarDummy, -dx, 0)
        t:SetText('MANA')
        t:Hide()
        frame.FocusFrameManaBarText = t

        FocusFrameManaBarDummy:HookScript('OnEnter', function(self)
            if FocusFrameTextureFrame.ManaBarTextRight:IsVisible() or FocusFrameTextureFrame.ManaBarText:IsVisible() then
            else
                Module.UpdateFocusText()
                frame.FocusFrameManaBarText:Show()
            end
        end)
        FocusFrameManaBarDummy:HookScript('OnLeave', function(self)
            frame.FocusFrameManaBarText:Hide()
        end)
    end

    FocusFrameFlash:SetTexture('')

    FocusFrameToTDebuff1:SetPoint('TOPLEFT', FocusFrameToT, 'TOPRIGHT', 25, -20)

    if not frame.FocusFrameFlash then
        local flash = FocusFrame:CreateTexture('DragonflightUIFocusFrameFlash')
        flash:SetDrawLayer('BACKGROUND', 2)
        flash:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-InCombat')
        flash:SetPoint('CENTER', FocusFrame, 'CENTER', 20 + CorrectionX, -20 + CorrectionY)
        flash:SetSize(256, 128)
        flash:SetScale(1)
        flash:SetVertexColor(1.0, 0.0, 0.0, 1.0)
        flash:SetBlendMode('ADD')
        frame.FocusFrameFlash = flash
    end

    hooksecurefunc(FocusFrameFlash, 'Show', function()
        -- print('show')
        FocusFrameFlash:SetTexture('')
        frame.FocusFrameFlash:Show()
        if (UIFrameIsFlashing(frame.FocusFrameFlash)) then
        else
            -- print('go flash')
            local dt = 0.5
            UIFrameFlash(frame.FocusFrameFlash, dt, dt, -1)
        end
    end)

    hooksecurefunc(FocusFrameFlash, 'Hide', function()
        -- print('hide')
        FocusFrameFlash:SetTexture('')
        if (UIFrameIsFlashing(frame.FocusFrameFlash)) then UIFrameFlashStop(frame.FocusFrameFlash) end
        frame.FocusFrameFlash:Hide()
    end)

    if not frame.FocusExtra then
        local extra = FocusFrame:CreateTexture('DragonflightUIFocusFramePortraitExtra')
        extra:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiunitframeboss2x')
        extra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
        extra:SetSize(80, 79)
        extra:SetDrawLayer('ARTWORK', 3)
        extra:SetPoint('CENTER', FocusFramePortrait, 'CENTER', 4, 1)

        extra.UpdateStyle = function()
            local class = UnitClassification('focus')
            --[[ "worldboss", "rareelite", "elite", "rare", "normal", "trivial" or "minus" ]]
            if class == 'worldboss' then
                frame.FocusExtra:Show()
                frame.FocusExtra:SetSize(99, 81)
                frame.FocusExtra:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.31835937)
                frame.FocusExtra:SetPoint('CENTER', FocusFramePortrait, 'CENTER', 13, 1)
            elseif class == 'rareelite' or class == 'rare' then
                frame.FocusExtra:Show()
                frame.FocusExtra:SetSize(80, 79)
                frame.FocusExtra:SetTexCoord(0.00390625, 0.31640625, 0.64453125, 0.953125)
                frame.FocusExtra:SetPoint('CENTER', FocusFramePortrait, 'CENTER', 4, 1)
            elseif class == 'elite' then
                frame.FocusExtra:Show()
                frame.FocusExtra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
                frame.FocusExtra:SetSize(80, 79)
                frame.FocusExtra:SetPoint('CENTER', FocusFramePortrait, 'CENTER', 4, 1)
            else
                local name, realm = UnitName('target')
                if Module.famous[name] then
                    frame.FocusExtra:Show()
                    frame.FocusExtra:SetSize(99, 81)
                    frame.FocusExtra:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.31835937)
                    frame.FocusExtra:SetPoint('CENTER', FocusFramePortrait, 'CENTER', 13, 1)
                else
                    frame.FocusExtra:Hide()
                end
            end
        end

        frame.FocusExtra = extra
    end
end
-- ChangeFocusFrame()
-- frame:RegisterUnitEvent('UNIT_POWER_UPDATE', 'focus')
-- frame:RegisterUnitEvent('UNIT_HEALTH', 'focus')
-- frame:RegisterEvent('PLAYER_FOCUS_CHANGED')

function Module.MoveFocusFrame(anchor, anchorOther, anchorFrame, dx, dy)
    FocusFrame:ClearAllPoints()
    FocusFrame:SetPoint(anchor, anchorFrame, anchorOther, dx, dy)
end

function Module.ReApplyFocusFrame()
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

    if frame.FocusExtra then frame.FocusExtra:UpdateStyle() end
end

function Module.ChangeFocusToT()
    FocusFrameToT:ClearAllPoints()
    FocusFrameToT:SetPoint('BOTTOMRIGHT', FocusFrame, 'BOTTOMRIGHT', -35, -10 - 5)

    FocusFrameToTTextureFrameTexture:SetTexture('')

    if not frame.FocusFrameToTBackground then
        local background = FocusFrameToTTextureFrame:CreateTexture('DragonflightUIFocusFrameToTBackground')
        background:SetDrawLayer('BACKGROUND', 1)
        background:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BACKGROUND')
        background:SetPoint('LEFT', FocusFrameToTPortrait, 'CENTER', -25 + 1, -10 + 1)
        frame.FocusFrameToTBackground = background
    end

    if not frame.FocusFrameToTBorder then
        local border = FocusFrameToTHealthBar:CreateTexture('DragonflightUIFocusFrameToTBorder')
        border:SetDrawLayer('ARTWORK', 2)
        border:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BORDER')
        border:SetPoint('LEFT', FocusFrameToTPortrait, 'CENTER', -25 + 1, -10 + 1)
        frame.FocusFrameToTBorder = border
    end

    FocusFrameToTHealthBar:ClearAllPoints()
    FocusFrameToTHealthBar:SetPoint('LEFT', FocusFrameToTPortrait, 'RIGHT', 1 + 1, 0 + 1)
    FocusFrameToTHealthBar:SetFrameLevel(10)
    FocusFrameToTHealthBar:SetSize(70.5, 10)

    FocusFrameToTHealthBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health')
    FocusFrameToTManaBar:SetStatusBarColor(1, 1, 1, 1)

    FocusFrameToTManaBar:ClearAllPoints()
    FocusFrameToTManaBar:SetPoint('LEFT', FocusFrameToTPortrait, 'RIGHT', 1 - 2 - 1.5 + 1, 2 - 10 - 1)
    FocusFrameToTManaBar:SetFrameLevel(10)
    FocusFrameToTManaBar:SetSize(74, 7.5)

    FocusFrameToTTextureFrameName:ClearAllPoints()
    FocusFrameToTTextureFrameName:SetPoint('LEFT', FocusFrameToTPortrait, 'RIGHT', 1 + 1, 2 + 12 - 1)

    FocusFrameToTTextureFrameDeadText:ClearAllPoints()
    FocusFrameToTTextureFrameDeadText:SetPoint('CENTER', FocusFrameToTHealthBar, 'CENTER', 0, 0)
end

function Module.UpdateFocusText()
    -- print('UpdateFocusText')
    if UnitExists('focus') then
        local max_health = UnitHealthMax('focus')
        local health = UnitHealth('focus')

        frame.FocusFrameHealthBarText:SetText(health .. ' / ' .. max_health)

        local max_mana = UnitPowerMax('focus')
        local mana = UnitPower('focus')

        if max_mana == 0 then
            frame.FocusFrameManaBarText:SetText('')
        else
            frame.FocusFrameManaBarText:SetText(mana .. ' / ' .. max_mana)
        end
    end
end

function Module.HookFunctions()
    hooksecurefunc(PlayerFrameTexture, 'Show', function()
        -- print('PlayerFrameTexture - Show()')
        -- Module.ChangePlayerframe()
    end)
end

function Module.ChangePetFrame()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    PetFrame:SetPoint('TOPLEFT', PlayerFrame, 'TOPLEFT', 100, -70)
    PetFrameTexture:SetTexture('')
    PetFrameTexture:Hide()

    if not frame.PetAttackModeTexture then
        -- local attack = PetFrame:CreateTexture('DragonflightUIPetAttackModeTexture')
        local attack = PetFrameHealthBar:CreateTexture('DragonflightUIPetAttackModeTexture')
        attack:SetDrawLayer('ARTWORK', 3)
        attack:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Status')
        attack:SetSize(120, 49)
        attack:SetTexCoord(0, 120 / 128, 0, 49 / 64)
        attack:SetPoint('CENTER', PetFrame, 'CENTER', -2, 0)
        attack:SetBlendMode('ADD')
        attack:SetVertexColor(239 / 256, 0, 0)

        attack.attackModeCounter = 0
        attack.attackModeSign = -1

        PetFrame:HookScript('OnUpdate', function(self, elapsed)
            -- print('OnUpdate', elapsed)
            PetAttackModeTexture:Hide()

            if attack:IsShown() then
                local alpha = 255;
                local counter = attack.attackModeCounter + elapsed;
                local sign = attack.attackModeSign;

                if (counter > 0.5) then
                    sign = -sign;
                    attack.attackModeSign = sign;
                end
                counter = mod(counter, 0.5);
                attack.attackModeCounter = counter;

                if (sign == 1) then
                    alpha = (55 + (counter * 400)) / 255;
                else
                    alpha = (255 - (counter * 400)) / 255;
                end
                -- attack:SetVertexColor(239 / 256, 0, 0, alpha);
                attack:SetVertexColor(1, 0, 0, alpha);

            else
            end
        end)

        attack:Hide()
        PetFrame:HookScript('OnEvent', function(self, event, ...)
            if event == 'PET_ATTACK_START' then
                attack:Show()
            elseif event == 'PET_ATTACK_STOP' then
                attack:Hide()
            end
        end)

        frame.PetAttackModeTexture = attack
    end

    -- PetAttackModeTexture:ClearAllPoints()
    -- PetAttackModeTexture:SetSize(120, 49)
    -- local attSize = 40
    -- PetAttackModeTexture:SetSize(attSize * 2, attSize * 2)

    -- PetAttackModeTexture:SetTexCoord(0.703125, 1.0, 0, 1.0)
    -- PetAttackModeTexture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Status')
    -- PetAttackModeTexture:SetTexCoord(0.441406, 0.558594, 0.3125, 0.408203)
    -- PetAttackModeTexture:SetTexCoord(0, 120 / 128, 0, 49 / 64)
    -- PetAttackModeTexture:SetPoint('CENTER', PetFrame, 'CENTER', -2, 0)
    -- PetAttackModeTexture:SetVertexColor(239 / 256, 0, 0)

    if not frame.PetFrameBackground then
        local background = PetFrame:CreateTexture('DragonflightUIPetFrameBackground')
        background:SetDrawLayer('BACKGROUND', 1)
        background:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BACKGROUND')
        background:SetPoint('LEFT', PetPortrait, 'CENTER', -25 + 1, -10)
        frame.PetFrameBackground = background
    end

    if not frame.PetFrameBorder then
        local border = PetFrameHealthBar:CreateTexture('DragonflightUIPetFrameBorder')
        border:SetDrawLayer('ARTWORK', 2)
        border:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BORDER')
        border:SetPoint('LEFT', PetPortrait, 'CENTER', -25 + 1, -10)
        frame.PetFrameBorder = border
    end
    if PetFrameHappiness then PetFrameHappiness:SetPoint('LEFT', PetFrame, 'RIGHT', -7, -2) end

    PetFrameHealthBar:ClearAllPoints()
    PetFrameHealthBar:SetPoint('LEFT', PetPortrait, 'RIGHT', 1 + 1 - 2 + 0.5, 0)
    PetFrameHealthBar:SetSize(70.5, 10)
    PetFrameHealthBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health')
    PetFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)
    PetFrameHealthBar.SetStatusBarColor = noop

    PetFrameHealthBarText:SetPoint('CENTER', PetFrameHealthBar, 'CENTER', 0, 0)

    PetFrameManaBar:ClearAllPoints()
    PetFrameManaBar:SetPoint('LEFT', PetPortrait, 'RIGHT', 1 - 2 - 1.5 + 1 - 2 + 0.5, 2 - 10 - 1)
    PetFrameManaBar:SetSize(74, 7.5)
    PetFrameManaBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana')
    PetFrameManaBar:GetStatusBarTexture():SetVertexColor(1, 1, 1, 1)

    frame.UpdatePetManaBarTexture = function()
        local powerType, powerTypeString = UnitPowerType('pet')

        if powerTypeString == 'MANA' then
            PetFrameManaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana')
        elseif powerTypeString == 'FOCUS' then
            PetFrameManaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Focus')
        elseif powerTypeString == 'RAGE' then
            PetFrameManaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Rage')
        elseif powerTypeString == 'ENERGY' then
            PetFrameManaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Energy')
        elseif powerTypeString == 'RUNIC_POWER' then
            PetFrameManaBar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-RunicPower')
        end

        PetFrameManaBar:GetStatusBarTexture():SetVertexColor(1, 1, 1, 1)
    end

    hooksecurefunc('PetFrame_Update', function(self)
        frame.UpdatePetManaBarTexture()
    end)

    local dx = 2
    -- health vs mana bar
    local deltaSize = 74 - 70.5

    local newPetTextScale = 0.8

    PetName:ClearAllPoints()
    PetName:SetPoint('LEFT', PetPortrait, 'RIGHT', 1 + 1, 2 + 12 - 1)

    PetFrameHealthBarText:SetPoint('CENTER', PetFrameHealthBar, 'CENTER', 0, 0)
    PetFrameHealthBarTextLeft:SetPoint('LEFT', PetFrameHealthBar, 'LEFT', dx, 0)
    PetFrameHealthBarTextRight:SetPoint('RIGHT', PetFrameHealthBar, 'RIGHT', -dx, 0)

    PetFrameHealthBarText:SetScale(newPetTextScale)
    PetFrameHealthBarTextLeft:SetScale(newPetTextScale)
    PetFrameHealthBarTextRight:SetScale(newPetTextScale)

    PetFrameManaBarText:SetPoint('CENTER', PetFrameManaBar, 'CENTER', deltaSize / 2, 0)
    PetFrameManaBarTextLeft:ClearAllPoints()
    PetFrameManaBarTextLeft:SetPoint('LEFT', PetFrameManaBar, 'LEFT', deltaSize + dx + 1.5, 0)
    PetFrameManaBarTextRight:SetPoint('RIGHT', PetFrameManaBar, 'RIGHT', -dx, 0)

    PetFrameManaBarText:SetScale(newPetTextScale)
    PetFrameManaBarTextLeft:SetScale(newPetTextScale)
    PetFrameManaBarTextRight:SetScale(newPetTextScale)
end

function Module.GetPetOffset(offset)
    if not offset then return 0 end

    local _, class = UnitClass("player");

    -- default -60
    if (class == "DEATHKNIGHT") then
        return -15
        -- self:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 60, -75);
    elseif (class == "SHAMAN" or class == "DRUID") then
        return -40
        -- self:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 60, -100);
    elseif (class == "WARLOCK") then
        return -20
        -- self:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 60, -80);
    elseif (class == "PALADIN") then
        return -30
        -- self:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 60, -90);
    end

    return 0
end

function Module.ChangePartyFrame()
    local first = _G['PartyMemberFrame' .. 1]
    first:SetPoint('TOPLEFT', CompactRaidFrameManager, 'TOPRIGHT', 0, 0)

    for i = 1, 4 do
        local pf = _G['PartyMemberFrame' .. i]
        pf:SetSize(120, 53)
        -- pf:ClearAllPoints()
        -- pf:SetPoint('TOPLEFT', CompactRaidFrameManager, 'TOPRIGHT', 0, 0)

        pf:SetHitRectInsets(0, 0, 0, 12)

        -- layer = 'BACKGROUND => Flash,Portrait,Background
        local bg = _G['PartyMemberFrame' .. i .. 'Background']
        bg:Hide()

        local flash = _G['PartyMemberFrame' .. i .. 'Flash']
        flash:SetSize(114, 47)
        flash:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\uipartyframe')
        flash:SetTexCoord(0.480469, 0.925781, 0.453125, 0.636719)
        flash:SetPoint('TOPLEFT', 1 + 1, -2)
        flash:SetVertexColor(1, 0, 0, 1)
        flash:SetDrawLayer('ARTWORK', 5)

        local portrait = _G['PartyMemberFrame' .. i .. 'Portrait']
        -- portrait:SetSize(37,37)
        -- portrait:SetPoint('TOPLEFT',7,-6)

        -- layer = 'BORDER' => Texture, VehicleTexture,Name
        local texture = _G['PartyMemberFrame' .. i .. 'Texture']
        texture:SetTexture()
        texture:Hide()

        local name = _G['PartyMemberFrame' .. i .. 'Name']
        name:ClearAllPoints()
        name:SetSize(57, 12)
        name:SetPoint('TOPLEFT', 46, -6)

        if DF.Era then name:SetWidth(100) end

        -- layer = 'ARTWORK' => Status

        if not pf.PartyFrameBorder then
            local border = pf:CreateTexture('DragonflightUIPartyFrameBorder')
            -- border = _G['PartyMemberFrame' .. i .. 'HealthBar']:CreateTexture('DragonflightUIPartyFrameBorder')
            border:SetDrawLayer('ARTWORK', 3)
            border:SetSize(120, 49)
            border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\uipartyframe')
            border:SetTexCoord(0.480469, 0.949219, 0.222656, 0.414062)
            border:SetPoint('TOPLEFT', 1, -2)
            -- border:SetPoint('TOPLEFT', pf, 'TOPLEFT', 1, -2)
            -- border:Hide()

            pf.PartyFrameBorder = border
        end

        local status = _G['PartyMemberFrame' .. i .. 'Status']
        status:SetSize(114, 47)
        status:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\uipartyframe')
        status:SetTexCoord(0.00390625, 0.472656, 0.453125, 0.644531)
        status:SetPoint('TOPLEFT', 1, -2)
        status:SetDrawLayer('ARTWORK', 5)

        -- layer = 'OVERLAY' => LeaderIcon etc

        local updateSmallIcons = function()
            local leaderIcon = _G['PartyMemberFrame' .. i .. 'LeaderIcon']
            leaderIcon:ClearAllPoints()
            leaderIcon:SetPoint('BOTTOM', pf, 'TOP', -10, -6)

            local masterIcon = _G['PartyMemberFrame' .. i .. 'MasterIcon']
            masterIcon:ClearAllPoints()
            masterIcon:SetPoint('BOTTOM', pf, 'TOP', -10 + 16, -6)

            local guideIcon = _G['PartyMemberFrame' .. i .. 'GuideIcon']
            guideIcon:ClearAllPoints()
            guideIcon:SetPoint('BOTTOM', pf, 'TOP', -10, -6)

            local pvpIcon = _G['PartyMemberFrame' .. i .. 'PVPIcon']
            pvpIcon:ClearAllPoints()
            pvpIcon:SetPoint('CENTER', pf, 'TOPLEFT', 7, -24)

            local readyCheck = _G['PartyMemberFrame' .. i .. 'ReadyCheck']
            readyCheck:ClearAllPoints()
            readyCheck:SetPoint('CENTER', portrait, 'CENTER', 0, -2)

            local notPresentIcon = _G['PartyMemberFrame' .. i .. 'NotPresentIcon']
            notPresentIcon:ClearAllPoints()
            notPresentIcon:SetPoint('LEFT', pf, 'RIGHT', 2, -2)
        end
        updateSmallIcons()

        if DF.Wrath then
            local roleIcon = pf:CreateTexture('DragonflightUIPartyFrameRoleIcon')
            roleIcon:SetSize(12, 12)
            roleIcon:SetPoint('TOPRIGHT', -5, -5)
            roleIcon:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\roleicons')
            roleIcon:SetTexCoord(0.015625, 0.265625, 0.03125, 0.53125)

            pf.RoleIcon = roleIcon

            local updateRoleIcon = function()
                local role = UnitGroupRolesAssigned(pf.unit)
                if role == 'TANK' then
                    roleIcon:SetTexCoord(0.578125, 0.828125, 0.03125, 0.53125)
                elseif role == 'HEALER' then
                    roleIcon:SetTexCoord(0.296875, 0.546875, 0.03125, 0.53125)
                elseif role == 'DAMAGER' then
                    roleIcon:SetTexCoord(0.015625, 0.265625, 0.03125, 0.53125)
                end
            end

            updateRoleIcon()

            pf:HookScript('OnEvent', function(self, event, ...)
                -- print('events', event)
                if event == 'GROUP_ROSTER_UPDATE' then updateRoleIcon() end
            end)
        end

        local healthbar = _G['PartyMemberFrame' .. i .. 'HealthBar']
        healthbar:SetSize(70 + 1, 10)
        healthbar:ClearAllPoints()
        healthbar:SetPoint('TOPLEFT', 45 - 1, -19)
        healthbar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Health')
        healthbar:SetStatusBarColor(1, 1, 1, 1)

        local hpMask = healthbar:CreateMaskTexture()
        -- hpMask:SetPoint('TOPLEFT', pf, 'TOPLEFT', -29, 3)
        hpMask:SetPoint('CENTER', healthbar, 'CENTER', 0, 0)
        hpMask:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Health-Mask',
            'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
        hpMask:SetSize(70 + 1, 10)
        healthbar:GetStatusBarTexture():AddMaskTexture(hpMask)

        healthbar.DFHealthBarText = healthbar:CreateFontString('DragonflightUIHealthBarText', 'OVERLAY',
                                                               'TextStatusBarText')
        healthbar.DFHealthBarText:SetPoint('CENTER', healthbar, 'CENTER', 0, 0)
        healthbar.DFTextString = healthbar.DFHealthBarText

        healthbar.DFHealthBarTextLeft = healthbar:CreateFontString('DragonflightUIHealthBarTextLeft', 'OVERLAY',
                                                                   'TextStatusBarText')
        healthbar.DFHealthBarTextLeft:SetPoint('LEFT', healthbar, 'LEFT', 0, 0)
        healthbar.DFLeftText = healthbar.DFHealthBarTextLeft

        healthbar.DFHealthBarTextRight = healthbar:CreateFontString('DragonflightUIHealthBarTextRight', 'OVERLAY',
                                                                    'TextStatusBarText')
        healthbar.DFHealthBarTextRight:SetPoint('RIGHT', healthbar, 'RIGHT', 0, 0)
        healthbar.DFRightText = healthbar.DFHealthBarTextRight

        healthbar:HookScript('OnEnter', function(self)
            if healthbar.DFHealthBarTextRight:IsVisible() or healthbar.DFTextString:IsVisible() then
            else
                local max_health = UnitHealthMax('party' .. i)
                local health = UnitHealth('party' .. i)
                healthbar.DFTextString:SetText(health .. ' / ' .. max_health)
                healthbar.DFTextString:Show()
            end
        end)
        healthbar:HookScript('OnLeave', function(self)
            healthbar.DFTextString:Hide()
            Module.UpdatePartyHPBar(i)
        end)

        Module.UpdatePartyHPBar(i)

        local manabar = _G['PartyMemberFrame' .. i .. 'ManaBar']
        manabar:SetSize(74, 7)
        manabar:ClearAllPoints()
        manabar:SetPoint('TOPLEFT', 41, -30)
        manabar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Mana')
        manabar:SetStatusBarColor(1, 1, 1, 1)

        local manaMask = manabar:CreateMaskTexture()
        -- hpMask:SetPoint('TOPLEFT', pf, 'TOPLEFT', -29, 3)
        manaMask:SetPoint('CENTER', manabar, 'CENTER', 0, 0)
        manaMask:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Mana-Mask',
            'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
        manaMask:SetSize(74, 7)
        manabar:GetStatusBarTexture():AddMaskTexture(manaMask)

        manabar.DFManaBarText = manabar:CreateFontString('DragonflightUIManaBarText', 'OVERLAY', 'TextStatusBarText')
        manabar.DFManaBarText:SetPoint('CENTER', manabar, 'CENTER', 1.5, 0)
        manabar.DFTextString = manabar.DFManaBarText

        manabar.DFManaBarTextLeft = manabar:CreateFontString('DragonflightUIManaBarTextLeft', 'OVERLAY',
                                                             'TextStatusBarText')
        manabar.DFManaBarTextLeft:SetPoint('LEFT', manabar, 'LEFT', 3, 0)
        manabar.DFLeftText = manabar.DFManaBarTextLeft

        manabar.DFManaBarTextRight = manabar:CreateFontString('DragonflightUIManaBarTextRight', 'OVERLAY',
                                                              'TextStatusBarText')
        manabar.DFManaBarTextRight:SetPoint('RIGHT', manabar, 'RIGHT', 0, 0)
        manabar.DFRightText = manabar.DFManaBarTextRight

        manabar:HookScript('OnEnter', function(self)
            if manabar.DFManaBarTextRight:IsVisible() or manabar.DFTextString:IsVisible() then
            else
                local max_mana = UnitPowerMax('party' .. i)
                local mana = UnitPower('party' .. i)

                if max_mana == 0 then
                    manabar.DFTextString:SetText('')
                else
                    manabar.DFTextString:SetText(mana .. ' / ' .. max_mana)
                end
                manabar.DFTextString:Show()
            end
        end)
        manabar:HookScript('OnLeave', function(self)
            manabar.DFTextString:Hide()
            Module.UpdatePartyManaBar(i)
        end)

        Module.UpdatePartyManaBar(i)

        -- debuff
        local debuffOne = _G['PartyMemberFrame' .. i .. 'Debuff1']
        debuffOne:SetPoint('TOPLEFT', 120, -20)

        hooksecurefunc('PartyMemberBuffTooltip_Update', function(self)
            -- print('PartyMemberBuffTooltip_Update', self:GetName())

            local point, relativeTo, relativePoint, xOfs, yOfs = PartyMemberBuffTooltip:GetPoint(1)

            if relativeTo == pf then
                -- print('sAME')
                -- print(point, relativeTo:GetName(), relativePoint, xOfs, yOfs)
                -- PartyMemberBuffTooltip:SetPoint('TOPLEFT', portrait, 'TOPLEFT', 32, -2.5)
                -- print('scale', PartyMemberBuffTooltip:GetScale())
                -- print(portrait:GetHeight(), PartyMemberBuffTooltip:GetHeight())
                -- PartyMemberBuffTooltip:SetScale(pf:GetScale())
                PartyMemberBuffTooltip:ClearAllPoints()
                PartyMemberBuffTooltip:SetPoint('LEFT', pf, 'RIGHT', 0, 0)

                local scale = pf:GetScale()
                if scale > 2 then
                    scale = 2
                else
                end
                PartyMemberBuffTooltip:SetScale(0.8 * scale)

            end

            -- [07:05:37] TOPLEFT PartyMemberFrame1 TOPLEFT 47 -30
        end)

        pf:HookScript('OnEvent', function(self, event, ...)
            local texture = _G['PartyMemberFrame' .. i .. 'Texture']
            texture:SetTexture()
            texture:Hide()
            healthbar:SetStatusBarColor(1, 1, 1, 1)

            updateSmallIcons()

            Module.UpdatePartyHPBar(i)
        end)
    end
end

local function DFTextStatusBar_UpdateTextStringWithValues(statusFrame, textString, value, valueMin, valueMax)
    if (statusFrame.DFLeftText and statusFrame.DFRightText) then
        statusFrame.DFLeftText:SetText("");
        statusFrame.DFRightText:SetText("");
        statusFrame.DFLeftText:Hide();
        statusFrame.DFRightText:Hide();
    end

    if ((tonumber(valueMax) ~= valueMax or valueMax > 0) and not (statusFrame.pauseUpdates)) then
        statusFrame:Show();

        if ((statusFrame.cvar and GetCVar(statusFrame.cvar) == "1" and statusFrame.textLockable) or
            statusFrame.forceShow) then
            textString:Show();
        elseif (statusFrame.lockShow > 0 and (not statusFrame.forceHideText)) then
            textString:Show();
        else
            textString:SetText("");
            textString:Hide();
            return;
        end

        local valueDisplay = value;
        local valueMaxDisplay = valueMax;
        -- Modern WoW always breaks up large numbers, whereas Classic never did.
        -- We'll remove breaking-up by default for Classic, but add a flag to reenable it.
        if (statusFrame.breakUpLargeNumbers) then
            if (statusFrame.capNumericDisplay) then
                valueDisplay = AbbreviateLargeNumbers(value);
                valueMaxDisplay = AbbreviateLargeNumbers(valueMax);
            else
                valueDisplay = BreakUpLargeNumbers(value);
                valueMaxDisplay = BreakUpLargeNumbers(valueMax);
            end
        end

        local textDisplay = GetCVar("statusTextDisplay");
        if (value and valueMax > 0 and
            ((textDisplay ~= "NUMERIC" and textDisplay ~= "NONE") or statusFrame.showPercentage) and
            not statusFrame.showNumeric) then
            if (value == 0 and statusFrame.zeroText) then
                textString:SetText(statusFrame.zeroText);
                statusFrame.isZero = 1;
                textString:Show();
            elseif (textDisplay == "BOTH" and not statusFrame.showPercentage) then
                if (statusFrame.DFLeftText and statusFrame.DFRightText) then
                    if (not statusFrame.powerToken or statusFrame.powerToken == "MANA") then
                        statusFrame.DFLeftText:SetText(math.ceil((value / valueMax) * 100) .. "%");
                        statusFrame.DFLeftText:Show();
                    end
                    statusFrame.DFRightText:SetText(valueDisplay);
                    statusFrame.DFRightText:Show();
                    textString:Hide();
                else
                    valueDisplay = "(" .. math.ceil((value / valueMax) * 100) .. "%) " .. valueDisplay .. " / " ..
                                       valueMaxDisplay;
                end
                textString:SetText(valueDisplay);
            else
                valueDisplay = math.ceil((value / valueMax) * 100) .. "%";
                if (statusFrame.prefix and
                    (statusFrame.alwaysPrefix or
                        not (statusFrame.cvar and GetCVar(statusFrame.cvar) == "1" and statusFrame.textLockable))) then
                    textString:SetText(statusFrame.prefix .. " " .. valueDisplay);
                else
                    textString:SetText(valueDisplay);
                end
            end
        elseif (value == 0 and statusFrame.zeroText) then
            textString:SetText(statusFrame.zeroText);
            statusFrame.isZero = 1;
            textString:Show();
            return;
        else
            statusFrame.isZero = nil;
            if (statusFrame.prefix and
                (statusFrame.alwaysPrefix or
                    not (statusFrame.cvar and GetCVar(statusFrame.cvar) == "1" and statusFrame.textLockable))) then
                textString:SetText(statusFrame.prefix .. " " .. valueDisplay .. " / " .. valueMaxDisplay);
            else
                textString:SetText(valueDisplay .. " / " .. valueMaxDisplay);
            end
        end
    else
        textString:Hide();
        textString:SetText("");
        if (not statusFrame.alwaysShow) then
            statusFrame:Hide();
        else
            statusFrame:SetValue(0);
        end
    end
end

local function DFTextStatusBar_UpdateTextString(textStatusBar)
    local textString = textStatusBar.DFTextString;
    if (textString) then
        local value = textStatusBar:GetValue();
        local valueMin, valueMax = textStatusBar:GetMinMaxValues();
        DFTextStatusBar_UpdateTextStringWithValues(textStatusBar, textString, value, valueMin, valueMax);
    end
end

function Module.UpdatePartyManaBar(i)
    local pf = _G['PartyMemberFrame' .. i]
    local manabar = _G['PartyMemberFrame' .. i .. 'ManaBar']
    if UnitExists(pf.unit) then
        local powerType, powerTypeString = UnitPowerType(pf.unit)
        -- powerTypeString = 'RUNIC_POWER'

        if powerTypeString == 'MANA' then
            manabar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Mana')
        elseif powerTypeString == 'FOCUS' then
            manabar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Focus')
        elseif powerTypeString == 'RAGE' then
            manabar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Rage')
        elseif powerTypeString == 'ENERGY' then
            manabar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Energy')
        elseif powerTypeString == 'RUNIC_POWER' then
            manabar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-RunicPower')
        end
        manabar:SetStatusBarColor(1, 1, 1, 1)
        DFTextStatusBar_UpdateTextString(manabar)
    else
    end
    -- print('UpdatePartyManaBar', i, powerType, powerTypeString)
end

function Module.UpdatePartyHPBar(i)
    local pf = _G['PartyMemberFrame' .. i]
    local healthbar = _G['PartyMemberFrame' .. i .. 'HealthBar']
    if UnitExists(pf.unit) then
        if Module.db.profile.party.classcolor then
            healthbar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Health-Status')
            local localizedClass, englishClass, classIndex = UnitClass(pf.unit)
            healthbar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
        else
            healthbar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Health')
            healthbar:SetStatusBarColor(1, 1, 1, 1)
        end
        DFTextStatusBar_UpdateTextString(healthbar)
    else
    end
end

function Module.CreateRestFlipbook()
    if not frame.RestIcon then
        local rest = CreateFrame('Frame', 'DragonflightUIRestFlipbook', PlayerFrame)
        rest:SetSize(20, 20)
        rest:SetPoint('CENTER', PlayerPortrait, 'TOPRIGHT', -4, 4)
        ---@diagnostic disable-next-line: redundant-parameter
        rest:SetFrameStrata('MEDIUM', 5)
        rest:SetScale(1.2)

        local restTexture = rest:CreateTexture('DragonflightUIRestFlipbookTexture')
        restTexture:SetAllPoints()
        restTexture:SetColorTexture(1, 1, 1, 1)
        restTexture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiunitframerestingflipbook')
        restTexture:SetTexCoord(0, 7 / 8, 0, 7 / 8)

        local animationGroup = restTexture:CreateAnimationGroup()
        local animation = animationGroup:CreateAnimation('Flipbook', 'RestFlipbookAnimation')

        animationGroup:SetLooping('REPEAT')
        local size = 60
        animation:SetFlipBookFrameWidth(size)
        animation:SetFlipBookFrameHeight(size)
        animation:SetFlipBookRows(7)
        animation:SetFlipBookColumns(6)
        animation:SetFlipBookFrames(42)
        animation:SetDuration(1.5)

        frame.RestIcon = rest
        frame.RestIconAnimation = animationGroup

        PlayerFrame_UpdateStatus()
    end
end

function Module.HookRestFunctions()
    hooksecurefunc(PlayerStatusGlow, 'Show', function()
        PlayerStatusGlow:Hide()
    end)

    hooksecurefunc(PlayerRestIcon, 'Show', function()
        PlayerRestIcon:Hide()
    end)

    hooksecurefunc(PlayerRestGlow, 'Show', function()
        PlayerRestGlow:Hide()
    end)

    hooksecurefunc('SetUIVisibility', function(visible)
        if visible then
            PlayerFrame_UpdateStatus()
        else
            frame.RestIcon:Hide()
            frame.RestIconAnimation:Stop()
        end
    end)
end

function Module.ChangeFonts()
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
    -- print(event, arg1)
    if event == 'UNIT_POWER_UPDATE' and arg1 == 'focus' then
        Module.UpdateFocusText()
    elseif event == 'UNIT_POWER_UPDATE' and arg1 == 'pet' then
    elseif event == 'PET_BAR_UPDATE' then
        -- print('PET_BAR_UPDATE')      
    elseif event == 'UNIT_POWER_UPDATE' then
        -- print(event, arg1)
    elseif event == 'UNIT_HEALTH' and arg1 == 'focus' then
        Module.UpdateFocusText()
    elseif event == 'PLAYER_FOCUS_CHANGED' then
        Module.ReApplyFocusFrame()
        Module.UpdateFocusText()
    elseif event == 'PLAYER_ENTERING_WORLD' then
        -- print('PLAYER_ENTERING_WORLD')
        Module.CreatePlayerFrameTextures()
        Module.ChangePlayerframe()
        Module.SetPlayerBiggerHealthbar(Module.db.profile.player.biggerHealthbar)
        Module.ChangeTargetFrame()
        Module.ChangeTargetComboFrame()
        Module.ChangeToT()
        Module.ReApplyTargetFrame()
        Module.ChangeStatusIcons()
        Module.CreateRestFlipbook()
        if DF.Wrath then
            Module.ChangeFocusFrame()
            Module.ChangeFocusToT()
        end
        Module.ChangeFonts()
        Module:ApplySettings()
    elseif event == 'PLAYER_TARGET_CHANGED' then
        -- Module.ApplySettings()
        Module.ReApplyTargetFrame()
        -- Module.ChangePlayerframe()
    elseif event == 'UNIT_ENTERED_VEHICLE' then
        Module.ChangePlayerframe()
        Module.SetPlayerBiggerHealthbar(Module.db.profile.player.biggerHealthbar)
    elseif event == 'UNIT_EXITED_VEHICLE' then
        Module.ChangePlayerframe()
        Module.SetPlayerBiggerHealthbar(Module.db.profile.player.biggerHealthbar)
    elseif event == 'ZONE_CHANGED' or event == 'ZONE_CHANGED_INDOORS' or event == 'ZONE_CHANGED_NEW_AREA' then
        Module.ChangePlayerframe()
        Module.SetPlayerBiggerHealthbar(Module.db.profile.player.biggerHealthbar)
    elseif event == 'UNIT_PORTRAIT_UPDATE' then
        Module.RefreshPortrait()
    elseif event == 'PORTRAITS_UPDATED' then
        Module.RefreshPortrait()
    elseif event == 'CVAR_UPDATE' then
        if arg1 == 'statusText' or arg1 == 'statusTextDisplay' then
            for i = 1, 4 do
                Module.UpdatePartyHPBar(i)
                Module.UpdatePartyManaBar(i)
            end
        end
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

function Module.Wrath()
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

    Module.HookRestFunctions()
    Module.HookVertexColor()
    Module.HookEnergyBar()
    Module.HookPlayerStatus()
    Module.HookPlayerArt()
    Module.HookDrag()

    Module.ApplyPortraitMask()
    Module.HookClassIcon()
    Module.ChangePartyFrame()
    Module.ChangePetFrame()
end

function Module.Era()
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

    Module.HookRestFunctions()
    Module.HookVertexColor()
    Module.HookEnergyBar()
    Module.HookPlayerStatus()
    Module.HookPlayerArt()
    Module.HookDrag()

    Module.ApplyPortraitMask()
    Module.HookClassIcon()
    Module.ChangePartyFrame()
    Module.AddMobhealth()
    Module.CreatThreatIndicator()
    Module.ChangePetFrame()
end
