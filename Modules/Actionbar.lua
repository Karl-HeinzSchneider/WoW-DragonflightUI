---@diagnostic disable: undefined-global
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
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
            customAnchorFrame = '',
            anchor = 'BOTTOM',
            anchorParent = 'TOP',
            x = 0,
            y = 10,
            orientation = 'horizontal',
            growthDirection = 'up',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 12,
            padding = 2,
            -- Style
            alwaysShow = true,
            activate = true,
            hideArt = false,
            hideScrolling = false,
            gryphons = 'DEFAULT',
            range = true,
            hideMacro = false,
            macroFontSize = 14,
            hideKeybind = false,
            shortenKeybind = false,
            useKeyDown = false,
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
            hideBattlePet = true,
            hideCustom = false,
            hideCustomCond = ''
        },
        bar2 = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame1',
            customAnchorFrame = '',
            anchor = 'BOTTOM',
            anchorParent = 'TOP',
            x = 0,
            y = 0,
            orientation = 'horizontal',
            growthDirection = 'up',
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
            shortenKeybind = false,
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
            hideBattlePet = true,
            hideCustom = false,
            hideCustomCond = ''
        },
        bar3 = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame2',
            customAnchorFrame = '',
            anchor = 'BOTTOM',
            anchorParent = 'TOP',
            x = 0,
            y = 0,
            orientation = 'horizontal',
            growthDirection = 'up',
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
            shortenKeybind = false,
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
            hideBattlePet = true,
            hideCustom = false,
            hideCustomCond = ''
        },
        bar4 = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame2',
            customAnchorFrame = '',
            anchor = 'RIGHT',
            anchorParent = 'LEFT',
            x = -64,
            y = 0,
            orientation = 'horizontal',
            growthDirection = 'up',
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
            shortenKeybind = false,
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
            hideBattlePet = true,
            hideCustom = false,
            hideCustomCond = ''
        },
        bar5 = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame2',
            customAnchorFrame = '',
            anchor = 'LEFT',
            anchorParent = 'RIGHT',
            x = 64,
            y = 0,
            orientation = 'horizontal',
            growthDirection = 'up',
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
            shortenKeybind = false,
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
            hideBattlePet = true,
            hideCustom = false,
            hideCustomCond = ''
        },
        bar6 = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame3',
            customAnchorFrame = '',
            anchor = 'BOTTOM',
            anchorParent = 'TOP',
            x = 0,
            y = 0,
            orientation = 'horizontal',
            growthDirection = 'up',
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
            shortenKeybind = false,
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
            hideBattlePet = true,
            hideCustom = false,
            hideCustomCond = ''
        },
        bar7 = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame6',
            customAnchorFrame = '',
            anchor = 'BOTTOM',
            anchorParent = 'TOP',
            x = 0,
            y = 0,
            orientation = 'horizontal',
            growthDirection = 'up',
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
            shortenKeybind = false,
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
            hideBattlePet = true,
            hideCustom = false,
            hideCustomCond = ''
        },
        bar8 = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame7',
            customAnchorFrame = '',
            anchor = 'BOTTOM',
            anchorParent = 'TOP',
            x = 0,
            y = 0,
            orientation = 'horizontal',
            growthDirection = 'up',
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
            shortenKeybind = false,
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
            hideBattlePet = true,
            hideCustom = false,
            hideCustomCond = ''
        },
        pet = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame3',
            customAnchorFrame = '',
            anchor = 'BOTTOMLEFT',
            anchorParent = 'TOPLEFT',
            x = 0,
            y = 0,
            orientation = 'horizontal',
            growthDirection = 'up',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 10,
            padding = 2,
            -- Style
            alwaysShow = true,
            activate = true,
            hideMacro = false,
            macroFontSize = 14,
            hideKeybind = false,
            shortenKeybind = false,
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
            hideBattlePet = true,
            hideCustom = false,
            hideCustomCond = ''
        },
        xp = {
            scale = 1,
            anchorFrame = 'UIParent',
            customAnchorFrame = '',
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
            hideBattlePet = true,
            hideCustom = false,
            hideCustomCond = ''
        },
        rep = {
            scale = 1,
            anchorFrame = 'DragonflightUIXPBar',
            customAnchorFrame = '',
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
            hideBattlePet = true,
            hideCustom = false,
            hideCustomCond = ''
        },
        stance = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame3',
            customAnchorFrame = '',
            anchor = 'BOTTOMLEFT',
            anchorParent = 'TOPLEFT',
            x = 0,
            y = 0,
            orientation = 'horizontal',
            growthDirection = 'up',
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
            shortenKeybind = false,
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
            hideBattlePet = true,
            hideCustom = false,
            hideCustomCond = ''
        },
        totem = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame3',
            customAnchorFrame = '',
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
            hideBattlePet = false,
            hideCustom = false,
            hideCustomCond = ''
        },
        possess = {
            scale = 1,
            anchorFrame = 'DragonflightUIActionbarFrame3',
            customAnchorFrame = '',
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
            hideBattlePet = true,
            hideCustom = false,
            hideCustomCond = ''
        },
        bags = {
            scale = 1,
            anchorFrame = 'UIParent',
            customAnchorFrame = '',
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
            hideBattlePet = false,
            hideCustom = false,
            hideCustomCond = ''
        },
        micro = {
            scale = 1,
            anchorFrame = 'UIParent',
            customAnchorFrame = '',
            anchor = 'BOTTOMRIGHT',
            anchorParent = 'BOTTOMRIGHT',
            x = 0,
            y = 0,
            hidden = false,
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
            hideCustomCond = ''
        },
        fps = {
            scale = 1,
            anchorFrame = 'DragonflightUIMicroMenuBar',
            customAnchorFrame = '',
            anchor = 'RIGHT',
            anchorParent = 'LEFT',
            x = -5,
            y = 0,
            hidden = false,
            hideDefaultFPS = true,
            alwaysShowFPS = false,
            showFPS = true,
            showPing = true
            -- Visibility
            -- showMouseover = false,
            -- hideAlways = false,
            -- hideCombat = false,
            -- hideOutOfCombat = false,
            -- hidePet = false,
            -- hideNoPet = false,
            -- hideStance = false,
            -- hideStealth = false,
            -- hideNoStealth = false,
            -- hideCustom = false,
            -- hideCustomCond = ''
        },
        extraActionButton = {
            scale = 1,
            anchorFrame = 'UIParent',
            customAnchorFrame = '',
            anchor = 'BOTTOM',
            anchorParent = 'BOTTOM',
            x = 0,
            y = 320, -- 160 = default blizz
            hideBackgroundTexture = false
            -- Visibility
            -- showMouseover = false,
            -- hideAlways = false,
            -- hideCombat = false,
            -- hideOutOfCombat = false,
            -- hidePet = false,
            -- hideNoPet = false,
            -- hideStance = false,
            -- hideStealth = false,
            -- hideNoStealth = false,
            -- hideCustom = false,
            -- hideCustomCond = ''
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
    {value = 'DragonflightUIXPBar', text = L["XPBar"], tooltip = 'descr', label = 'label'},
    {value = 'DragonflightUIRepBar', text = L["ReputationBar"], tooltip = 'descr', label = 'label'},
    {value = 'DragonflightUIPetBar', text = L["PetBar"], tooltip = 'descr', label = 'label'},
    {value = 'DragonflightUIStancebar', text = L["StanceBar"], tooltip = 'descr', label = 'label'},
    {value = 'PossessBarFrame', text = L["PossessBar"], tooltip = 'descr', label = 'label'},
    {value = 'DragonflightUIMicroMenuBar', text = L["MicroMenu"], tooltip = 'descr', label = 'label'}
}

for i = 1, 8 do
    table.insert(frameTable, i + 1, {
        value = 'DragonflightUIActionbarFrame' .. i,
        text = L["ActionbarNameFormat"]:format(i),
        tooltip = 'descr',
        label = 'label'
    })
end

local gryphonsTable = {
    {value = 'DEFAULT', text = L["Default"], tooltip = 'descr', label = 'label'},
    {value = 'ALLY', text = L["Alliance"], tooltip = 'descr', label = 'label'},
    {value = 'HORDE', text = L["Horde"], tooltip = 'descr', label = 'label'},
    {value = 'NONE', text = L["None"], tooltip = 'descr', label = 'label'}
}

if DF.Cata then
    --
    table.insert(frameTable,
                 {value = 'MultiCastActionBarFrame', text = L["TotemBar"], tooltip = 'descr', label = 'label'})
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

function AddButtonTable(optionTable, sub)
    local extraOptions = {
        activate = {
            type = 'toggle',
            name = L["ButtonTableActive"],
            desc = L["ButtonTableActiveDesc"] .. getDefaultStr('activate', sub),
            order = -1,
            new = false,
            editmode = true
        },
        headerButtons = {
            type = 'header',
            name = L["ButtonTableButtons"],
            desc = L["ButtonTableButtonsDesc"],
            order = 10,
            isExpanded = true,
            editmode = true
        },
        buttonScale = {
            type = 'range',
            name = L["ButtonTableButtonScale"],
            desc = L["ButtonTableButtonScaleDesc"] .. getDefaultStr('buttonScale', sub),
            min = 0.1,
            max = 3,
            bigStep = 0.05,
            order = 1,
            group = 'headerButtons',
            editmode = true
        },
        orientation = {
            type = 'select',
            name = L["ButtonTableOrientation"],
            desc = L["ButtonTableOrientationDesc"] .. getDefaultStr('orientation', sub),
            dropdownValues = DF.Settings.OrientationTable,
            order = 7,
            group = 'headerButtons',
            editmode = true
        },
        growthDirection = {
            type = 'select',
            name = L["ButtonTableGrowthDirection"],
            desc = L["ButtonTableGrowthDirectionDesc"] .. getDefaultStr('growthDirection', sub),
            dropdownValues = DF.Settings.GrowthDirectionTable,
            order = 7.1,
            group = 'headerButtons',
            new = true,
            editmode = true
        },
        reverse = {
            type = 'toggle',
            name = L["ButtonTableReverseButtonOrder"],
            desc = L["ButtonTableReverseButtonOrderDesc"] .. getDefaultStr('reverse', sub),
            order = 7.5,
            group = 'headerButtons',
            editmode = true
        },
        rows = {
            type = 'range',
            name = L["ButtonTableNumRows"],
            desc = L["ButtonTableNumRowsDesc"] .. getDefaultStr('rows', sub),
            min = 1,
            max = 12,
            bigStep = 1,
            order = 9,
            group = 'headerButtons',
            editmode = true
        },
        buttons = {
            type = 'range',
            name = L["ButtonTableNumButtons"],
            desc = L["ButtonTableNumButtonsDesc"] .. getDefaultStr('buttons', sub),
            min = 1,
            max = 12,
            bigStep = 1,
            order = 10,
            group = 'headerButtons',
            editmode = true
        },
        padding = {
            type = 'range',
            name = L["ButtonTablePadding"],
            desc = L["ButtonTablePaddingDesc"] .. getDefaultStr('padding', sub),
            min = 0,
            max = 10,
            bigStep = 1,
            order = 11,
            group = 'headerButtons',
            editmode = true
        },
        headerStyling = {
            type = 'header',
            name = L["ButtonTableStyle"],
            desc = L["ButtonTableStyleDesc"],
            order = 20,
            isExpanded = true,
            editmode = true
        },
        alwaysShow = {
            type = 'toggle',
            name = L["ButtonTableAlwaysShowActionbar"],
            desc = L["ButtonTableAlwaysShowActionbarDesc"] .. getDefaultStr('alwaysShow', sub),
            group = 'headerStyling',
            order = 50.1,
            editmode = true
        },
        hideMacro = {
            type = 'toggle',
            name = L["ButtonTableHideMacroText"],
            desc = L["ButtonTableHideMacroTextDesc"] .. getDefaultStr('hideMacro', sub),
            group = 'headerStyling',
            order = 55,
            editmode = true
        },
        macroFontSize = {
            type = 'range',
            name = L["ButtonTableMacroNameFontSize"],
            desc = L["ButtonTableMacroNameFontSizeDesc"] .. getDefaultStr('macroFontSize', sub),
            min = 6,
            max = 24,
            bigStep = 1,
            group = 'headerStyling',
            order = 55.1,
            new = false,
            editmode = true
        },
        hideKeybind = {
            type = 'toggle',
            name = L["ButtonTableHideKeybindText"],
            desc = L["ButtonTableHideKeybindTextDesc"] .. getDefaultStr('hideKeybind', sub),
            group = 'headerStyling',
            order = 56,
            editmode = true
        },
        shortenKeybind = {
            type = 'toggle',
            name = L["ButtonTableShortenKeybindText"],
            desc = L["ButtonTableShortenKeybindTextDesc"] .. getDefaultStr('shortenKeybind', sub),
            group = 'headerStyling',
            order = 56.05,
            editmode = true,
            new = true
        },
        keybindFontSize = {
            type = 'range',
            name = L["ButtonTableKeybindFontSize"],
            desc = L["ButtonTableKeybindFontSizeDesc"] .. getDefaultStr('keybindFontSize', sub),
            min = 6,
            max = 24,
            bigStep = 1,
            group = 'headerStyling',
            order = 56.1,
            new = false,
            editmode = true
        }
    }

    for k, v in pairs(extraOptions) do
        --
        optionTable.args[k] = v
    end
end

local function GetBarOption(n)
    local barname = 'bar' .. n
    local opt = {
        name = 'Actionbar' .. n,
        desc = 'Actionbar' .. n,
        get = getOption,
        set = setOption,
        type = 'group',
        args = {}
    }
    AddButtonTable(opt, barname)
    DF.Settings:AddPositionTable(Module, opt, barname, 'Action Bar' .. n, getDefaultStr,
                                 frameTableWithout('DragonflightUIActionbarFrame' .. n))
    opt.args.scale = nil;
    if n == 1 then
        -- print('111111')
        local moreOptions = {
            hideArt = {
                type = 'toggle',
                name = L["MoreOptionsHideBarArt"],
                desc = L["MoreOptionsHideBarArtDesc"] .. getDefaultStr('hideArt', barname),
                group = 'headerButtons',
                order = 51.2,
                editmode = true
            },
            hideScrolling = {
                type = 'toggle',
                name = L["MoreOptionsHideBarScrolling"],
                desc = L["MoreOptionsHideBarScrollingDesc"] .. getDefaultStr('hideScrolling', barname),
                group = 'headerButtons',
                order = 51.3,
                editmode = true
            },
            gryphons = {
                type = 'select',
                name = L["MoreOptionsGryphons"],
                desc = L["MoreOptionsGryphonsDesc"] .. getDefaultStr('gryphons', barname),
                values = {['DEFAULT'] = 'DEFAULT', ['ALLY'] = 'ALLIANCE', ['HORDE'] = 'HORDE', ['NONE'] = 'NONE'},
                dropdownValues = gryphonsTable,
                group = 'headerButtons',
                order = 51.4,
                editmode = true
            },
            range = {
                type = 'toggle',
                name = L["MoreOptionsIconRangeColor"],
                desc = L["MoreOptionsIconRangeColorDesc"] .. getDefaultStr('range', barname),
                group = 'headerButtons',
                order = 51.1,
                editmode = true
            },
            useKeyDown = {
                type = 'toggle',
                name = L["MoreOptionsUseKeyDown"],
                desc = L["MoreOptionsUseKeyDownDesc"] .. getDefaultStr('useKeyDown', barname),
                group = 'headerButtons',
                order = 51.0,
                editmode = true,
                blizzard = true
            }
        }

        for k, v in pairs(moreOptions) do opt.args[k] = v end

        opt.get = function(info)
            local key = info[1]
            local sub = info[2]
            if sub == 'useKeyDown' then
                if GetCVarBool('ActionButtonUseKeyDown') then
                    return true
                else
                    return false
                end
            else
                return getOption(info)
            end
        end

        opt.set = function(info, value)
            local key = info[1]
            local sub = info[2]

            if sub == 'useKeyDown' then
                if value then
                    C_CVar.SetCVar('ActionButtonUseKeyDown', 1)
                else
                    C_CVar.SetCVar('ActionButtonUseKeyDown', 0)
                end
            else
                setOption(info, value)
            end
        end

        -- GetCVarBool('ActionButtonUseKeyDown')

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
            -- activate = {
            --     type = 'toggle',
            --     name = 'Active',
            --     desc = '' .. getDefaultStr('activate', barname),
            --     order = 13,
            --     new = false,
            --     editmode = true
            -- }
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
                name = L["ExtraOptionsPreset"],
                btnName = L["ExtraOptionsResetToDefaultPosition"],
                desc = L["ExtraOptionsPresetDesc"],
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
                new = false
            }
        }
    }

    if n == 4 then
        -- left
        local morePresets = {
            sidebarModern = {
                type = 'execute',
                name = L["ExtraOptionsPreset"],
                btnName = L["ExtraOptionsModernLayout"],
                desc = L["ExtraOptionsModernLayoutDesc"],
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
                        y = defaultsTable.y,

                        orientation = defaultsTable.orientation,
                        reverse = defaultsTable.reverse,
                        buttonScale = defaultsTable.buttonScale,
                        rows = defaultsTable.rows,
                        buttons = defaultsTable.buttons,
                        padding = defaultsTable.padding
                    }, bar)
                end,
                order = 20,
                editmode = true,
                new = false
            },
            sidebarClassic = {
                type = 'execute',
                name = L["ExtraOptionsPreset"],
                btnName = L["ExtraOptionsClassicLayout"],
                desc = L["ExtraOptionsClassicLayoutDesc"],
                func = function()
                    local dbTable = Module.db.profile[bar]
                    local defaultsTable = defaults.profile[bar]
                    -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                    setPreset(dbTable, {
                        scale = defaultsTable.scale,
                        anchor = 'RIGHT',
                        anchorParent = 'RIGHT',
                        anchorFrame = 'UIParent',
                        x = -38,
                        y = -100,

                        orientation = 'vertical',
                        reverse = false,
                        buttonScale = defaultsTable.buttonScale,
                        rows = 1,
                        buttons = 12,
                        padding = defaultsTable.padding
                    }, bar)
                end,
                order = 21,
                editmode = true,
                new = false
            }
        }
        for k, v in pairs(morePresets) do extra.args[k] = v end

    elseif n == 5 then
        -- right
        local morePresets = {
            sidebarModern = {
                type = 'execute',
                name = L["ExtraOptionsPreset"],
                btnName = L["ExtraOptionsModernLayout"],
                desc = L["ExtraOptionsModernLayoutDesc"],
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
                        y = defaultsTable.y,

                        orientation = defaultsTable.orientation,
                        reverse = defaultsTable.reverse,
                        buttonScale = defaultsTable.buttonScale,
                        rows = defaultsTable.rows,
                        buttons = defaultsTable.buttons,
                        padding = defaultsTable.padding
                    }, bar)
                end,
                order = 20,
                editmode = true,
                new = false
            },
            sidebarClassic = {
                type = 'execute',
                name = L["ExtraOptionsPreset"],
                btnName = L["ExtraOptionsClassicLayout"],
                desc = L["ExtraOptionsClassicLayoutDesc"],
                func = function()
                    local dbTable = Module.db.profile[bar]
                    local defaultsTable = defaults.profile[bar]
                    -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                    setPreset(dbTable, {
                        scale = defaultsTable.scale,
                        anchor = 'RIGHT',
                        anchorParent = 'RIGHT',
                        anchorFrame = 'UIParent',
                        x = 0,
                        y = -100,

                        orientation = 'vertical',
                        reverse = false,
                        buttonScale = defaultsTable.buttonScale,
                        rows = 1,
                        buttons = 12,
                        padding = defaultsTable.padding
                    }, bar)
                end,
                order = 21,
                editmode = true,
                new = false
            }

        }
        for k, v in pairs(morePresets) do extra.args[k] = v end
    end

    return extra;
end

local petOptions = {name = 'PetBar', desc = 'PetBar', get = getOption, set = setOption, type = 'group', args = {}}
AddButtonTable(petOptions, 'pet')
DF.Settings:AddPositionTable(Module, petOptions, 'pet', 'Pet Bar', getDefaultStr,
                             frameTableWithout('DragonflightUIPetBar'))
petOptions.args.scale = nil;
petOptions.args.hideMacro = nil;
petOptions.args.macroFontSize = nil;
petOptions.args.buttons.max = 10;

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
            name = L["ExtraOptionsPreset"],
            btnName = L["ExtraOptionsResetToDefaultPosition"],
            desc = L["ExtraOptionsPresetDesc"],
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
            new = false
        }
    }
}

local xpOptions = {
    name = L["XPOptionsName"],
    desc = L["XPOptionsDesc"],
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        headerStyling = {
            type = 'header',
            name = L["XPOptionsStyle"],
            desc = L["XPOptionsStyleDesc"],
            order = 20,
            editmode = true,
            isExpanded = true
        },
        width = {
            type = 'range',
            name = L["XPOptionsWidth"],
            desc = L["XPOptionsWidthDesc"] .. getDefaultStr('width', 'xp'),
            min = 1,
            max = 2500,
            bigStep = 1,
            group = 'headerStyling',
            order = 7,
            editmode = true
        },
        height = {
            type = 'range',
            name = L["XPOptionsHeight"],
            desc = L["XPOptionsHeightDesc"] .. getDefaultStr('height', 'xp'),
            min = 1,
            max = 69,
            bigStep = 1,
            group = 'headerStyling',
            order = 8,
            editmode = true
        },
        alwaysShowXP = {
            type = 'toggle',
            name = L["XPOptionsAlwaysShowXPText"],
            desc = L["XPOptionsAlwaysShowXPTextDesc"] .. getDefaultStr('alwaysShowXP', 'xp'),
            group = 'headerStyling',
            order = 12,
            editmode = true
        },
        showXPPercent = {
            type = 'toggle',
            name = L["XPOptionsShowXPPercent"],
            desc = L["XPOptionsShowXPPercentDesc"] .. getDefaultStr('showXPPercent', 'xp'),
            group = 'headerStyling',
            order = 13,
            editmode = true
        }
    }
}

DF.Settings:AddPositionTable(Module, xpOptions, 'xp', 'XP Bar', getDefaultStr, frameTableWithout('DragonflightUIPetBar'))
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
            name = L["ExtraOptionsPreset"],
            btnName = L["ExtraOptionsResetToDefaultPosition"],
            desc = L["ExtraOptionsPresetDesc"],
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
            new = false
        }
    }
}

local repOptions = {
    name = L["RepOptionsName"],
    desc = L["RepOptionsDesc"],
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        headerStyling = {
            type = 'header',
            name = L["RepOptionsStyle"],
            desc = L["RepOptionsStyleDesc"],
            order = 20,
            editmode = true,
            isExpanded = true
        },
        width = {
            type = 'range',
            name = L["RepOptionsWidth"],
            desc = L["RepOptionsWidthDesc"] .. getDefaultStr('width', 'rep'),
            min = 1,
            max = 2500,
            bigStep = 1,
            group = 'headerStyling',
            order = 7,
            editmode = true
        },
        height = {
            type = 'range',
            name = L["RepOptionsHeight"],
            desc = L["RepOptionsHeightDesc"] .. getDefaultStr('height', 'rep'),
            min = 1,
            max = 69,
            bigStep = 1,
            group = 'headerStyling',
            order = 8,
            editmode = true
        },
        alwaysShowRep = {
            type = 'toggle',
            name = L["RepOptionsAlwaysShowRepText"],
            desc = L["RepOptionsAlwaysShowRepTextDesc"] .. getDefaultStr('alwaysShowRep', 'rep'),
            group = 'headerStyling',
            order = 12,
            editmode = true
        }
    }
}

DF.Settings:AddPositionTable(Module, repOptions, 'rep', 'Reputation Bar', getDefaultStr,
                             frameTableWithout('DragonflightUIRepBar'))
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
            name = L["ExtraOptionsPreset"],
            btnName = L["ExtraOptionsResetToDefaultPosition"],
            desc = L["ExtraOptionsPresetDesc"],
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
            new = false
        }
    }
}

local stanceOptions = {
    name = 'StanceBar',
    desc = 'StanceBar',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {activate = {type = 'toggle', name = 'Active', desc = '' .. getDefaultStr('activate', 'stance'), order = 13}}
}
AddButtonTable(stanceOptions, 'stance')
DF.Settings:AddPositionTable(Module, stanceOptions, 'stance', 'Stance Bar', getDefaultStr,
                             frameTableWithout('DragonflightUIStanceBar'))
stanceOptions.args.scale = nil;
stanceOptions.args.buttons.max = 10;

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
            name = L["ExtraOptionsPreset"],
            btnName = L["ExtraOptionsResetToDefaultPosition"],
            desc = L["ExtraOptionsPresetDesc"],
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
            new = false
        }
    }
}

local totemOptions = {name = 'Totembar', desc = 'Totembar', get = getOption, set = setOption, type = 'group', args = {}}
DF.Settings:AddPositionTable(Module, totemOptions, 'totem', 'Totem Bar', getDefaultStr,
                             frameTableWithout('MultiCastActionBarFrame'))
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
            name = L["ExtraOptionsPreset"],
            btnName = L["ExtraOptionsResetToDefaultPosition"],
            desc = L["ExtraOptionsPresetDesc"],
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
            new = false
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
        headerStyling = {type = 'header', name = 'Style', desc = '', order = 20, isExpanded = true},
        offset = {
            type = 'toggle',
            name = 'Auto adjust offset',
            desc = 'Auto add some Y offset depending on the class, e.g. on Paladin to make room for the stance bar' ..
                getDefaultStr('offset', 'possess'),
            group = 'headerStyling',
            order = 11,
            new = false,
            editmode = true
        }
    }
}
DF.Settings:AddPositionTable(Module, possessOptions, 'possess', 'Possess Bar', getDefaultStr,
                             frameTableWithout('PossessBarFrame'))
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
            name = L["ExtraOptionsPreset"],
            btnName = L["ExtraOptionsResetToDefaultPosition"],
            desc = L["ExtraOptionsPresetDesc"],
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
            new = false
        }
    }
}

local bagsOptions = {
    name = L["BagsOptionsName"],
    desc = L["BagsOptionsDesc"],
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        headerStyling = {
            type = 'header',
            name = L["BagsOptionsStyle"],
            desc = L["BagsOptionsStyleDesc"],
            order = 20,
            isExpanded = true,
            editmode = true
        },
        expanded = {
            type = 'toggle',
            name = L["BagsOptionsExpanded"],
            desc = L["BagsOptionsExpandedDesc"] .. getDefaultStr('expanded', 'bags'),
            group = 'headerStyling',
            order = 7,
            editmode = true
        },
        hideArrow = {
            type = 'toggle',
            name = L["BagsOptionsHideArrow"],
            desc = L["BagsOptionsHideArrowDesc"] .. getDefaultStr('hideArrow', 'bags'),
            group = 'headerStyling',
            order = 8,
            editmode = true
        },
        hidden = {
            type = 'toggle',
            name = L["BagsOptionsHidden"],
            desc = L["BagsOptionsHiddenDesc"] .. getDefaultStr('hidden', 'bags'),
            group = 'headerStyling',
            order = 9,
            editmode = true
        },
        overrideBagAnchor = {
            type = 'toggle',
            name = L["BagsOptionsOverrideBagAnchor"],
            desc = L["BagsOptionsOverrideBagAnchorDesc"] .. getDefaultStr('overrideBagAnchor', 'bags'),
            group = 'headerStyling',
            order = 15,
            new = false
        },
        offsetX = {
            type = 'range',
            name = L["BagsOptionsOffsetX"],
            desc = L["BagsOptionsOffsetXDesc"] .. getDefaultStr('offsetX', 'bags'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            group = 'headerStyling',
            order = 16,
            new = false
        },
        offsetY = {
            type = 'range',
            name = L["BagsOptionsOffsetY"],
            desc = L["BagsOptionsOffsetYDesc"] .. getDefaultStr('offsetY', 'bags'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            group = 'headerStyling',
            order = 17,
            new = false
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
            group = 'headerStyling',
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
DF.Settings:AddPositionTable(Module, bagsOptions, 'bags', 'Bags', getDefaultStr, frameTable)
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
            name = L["ExtraOptionsPreset"],
            btnName = L["ExtraOptionsResetToDefaultPosition"],
            desc = L["ExtraOptionsPresetDesc"],
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
            new = false
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

        -- hidden = {
        --     type = 'toggle',
        --     name = 'Hidden',
        --     desc = 'Hide Micromenu' .. getDefaultStr('hidden', 'micro'),
        --     order = 7
        -- },   
    }
}
DF.Settings:AddPositionTable(Module, microOptions, 'micro', 'Micromenu', getDefaultStr, frameTable)
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
            name = L["ExtraOptionsPreset"],
            btnName = L["ExtraOptionsResetToDefaultPosition"],
            desc = L["ExtraOptionsPresetDesc"],
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
            new = false
        }
    }
}

local fpsOptions = {
    name = L["FPSOptionsName"],
    desc = L["FPSOptionsDesc"],
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        headerStyling = {
            type = 'header',
            name = L["FPSOptionsStyle"],
            desc = L["FPSOptionsStyleDesc"],
            order = 20,
            isExpanded = true
        },
        hideDefaultFPS = {
            type = 'toggle',
            name = L["FPSOptionsHideDefaultFPS"],
            desc = L["FPSOptionsHideDefaultFPSDesc"] .. getDefaultStr('hideDefaultFPS', 'fps'),
            group = 'headerStyling',
            order = 8,
            editmode = true
        },
        showFPS = {
            type = 'toggle',
            name = L["FPSOptionsShowFPS"],
            desc = L["FPSOptionsShowFPSDesc"] .. getDefaultStr('showFPS', 'fps'),
            group = 'headerStyling',
            order = 10,
            editmode = true
        },
        alwaysShowFPS = {
            type = 'toggle',
            name = L["FPSOptionsAlwaysShowFPS"],
            desc = L["FPSOptionsAlwaysShowFPSDesc"] .. getDefaultStr('alwaysShowFPS', 'fps'),
            group = 'headerStyling',
            order = 9,
            editmode = true
        },
        showPing = {
            type = 'toggle',
            name = L["FPSOptionsShowPing"],
            desc = L["FPSOptionsShowPingDesc"] .. getDefaultStr('showPing', 'fps'),
            group = 'headerStyling',
            order = 11,
            editmode = true
        }
    }
}

DF.Settings:AddPositionTable(Module, fpsOptions, 'fps', 'FPS', getDefaultStr, frameTable)

local optionsFPSEditmode = {
    name = 'fps',
    desc = 'fps',
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
                local dbTable = Module.db.profile.fps
                local defaultsTable = defaults.profile.fps
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'fps')
            end,
            order = 16,
            editmode = true,
            new = false
        }
    }
}

local extraActionButtonOptions = {
    name = L["ExtraActionButtonOptionsName"],
    desc = L["ExtraActionButtonOptionsNameDesc"],
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        headerStyling = {
            type = 'header',
            name = L["ExtraActionButtonStyle"],
            desc = L["ExtraActionButtonStyleDesc"],
            order = 20,
            isExpanded = true,
            editmode = true
        },
        hideBackgroundTexture = {
            type = 'toggle',
            name = L["ExtraActionButtonHideBackgroundTexture"],
            desc = L["ExtraActionButtonHideBackgroundTextureDesc"] ..
                getDefaultStr('hideBackgroundTexture', 'extraActionButton'),
            group = 'headerStyling',
            order = 8,
            editmode = true
        }
    }
}

DF.Settings:AddPositionTable(Module, extraActionButtonOptions, 'extraActionButton', 'Extra Action Button',
                             getDefaultStr, frameTable)

local extraActionButtonOptionsEditmode = {
    name = 'extraActionButton',
    desc = 'extraActionButton',
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
                local dbTable = Module.db.profile.extraActionButton
                local defaultsTable = defaults.profile.extraActionButton
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'extraActionButton')
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

    -- not the best solution, override global CVAR and let DF UI handle everything
    C_CVar.SetCVar("alwaysShowActionBars", 1)

    Module.Temp = {}
    Module.UpdateRangeHooked = false

    self:EnableAddonSpecific()

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

function Module:RegisterSettings()
    local moduleName = 'Actionbar'
    local cat = 'actionbar'
    local function register(name, data)
        data.module = moduleName;
        DF.ConfigModule:RegisterSettingsElement(name, cat, data, true)
    end

    for i = 1, 8 do register('actionbar' .. i, {order = i, name = 'Action Bar ' .. i, descr = 'desc', isNew = false}) end

    register('petbar', {order = 9, name = 'Pet Bar', descr = 'desc', isNew = false})
    register('xpbar', {order = 10, name = 'XP Bar', descr = 'desc', isNew = false})
    register('repbar', {order = 11, name = 'Rep Bar', descr = 'desc', isNew = false})
    register('possessbar', {order = 12, name = 'Possess Bar', descr = 'desc', isNew = false})
    register('stancebar', {order = 13, name = 'Stance Bar', descr = 'desc', isNew = false})

    register('bags', {order = 15, name = 'Bags', descr = 'desc', isNew = false})
    register('micromenu', {order = 16, name = 'Micromenu', descr = 'desc', isNew = false})
    register('fps', {order = 17, name = 'FPS', descr = 'desc', isNew = false})

    if DF.Cata then
        register('totembar', {order = 14, name = 'Totem Bar', descr = 'desc', isNew = false})
        register('extraactionbutton', {order = 8.5, name = 'Extra Action Button', descr = 'desc', isNew = false})
    end
end

function Module:SetupActionbarFrames()
    local createStuff = function(n, base)
        local bar = CreateFrame('FRAME', 'DragonflightUIActionbarFrame' .. n, UIParent,
                                'DragonflightUIActionbarFrameTemplate')
        if base == 'MultiBarLeftButton' or base == 'MultiBarRightButton' then
            bar:RegisterEvent('UI_SCALE_CHANGED');
            bar:RegisterEvent('PLAYER_REGEN_ENABLED');
        end
        local buttons = {}
        for i = 1, 12 do
            local name = base .. i
            local btn = _G[name]
            buttons[i] = btn
            if base == 'MultiBarLeftButton' or base == 'MultiBarRightButton' then
                btn.DFIgnoreParentScale = true;
            end
        end
        bar:Init()
        bar:SetButtons(buttons)
        Module['bar' .. n] = bar
    end

    DragonflightUIActionbarMixin:HookGrid()
    if DF.Cata then
        -- DragonflightUIActionbarMixin:HookFlyout()
        -- DragonflightUIActionbarMixin:StyleFlyout()
    end

    createStuff(1, 'ActionButton')
    Module.bar1:SetupMainBar()
    createStuff(2, 'MultiBarBottomLeftButton')
    createStuff(3, 'MultiBarBottomRightButton')
    createStuff(4, 'MultiBarLeftButton')
    createStuff(5, 'MultiBarRightButton')

    for i = 1, 5 do
        local bar = Module['bar' .. i]
        bar:StyleButtons()
        bar:HookQuickbindMode()
    end

    -- secure handler
    local handler = CreateFrame('Frame', 'DragonflightUIActionBarHandler', nil, 'SecureHandlerBaseTemplate');
    handler:SetAttribute("ActionButtonUseKeyDown", GetCVarBool('ActionButtonUseKeyDown'));

    handler:SetScript("OnEvent", function(f, event, ...)
        f[event](f, ...)
    end)
    handler:RegisterEvent('VARIABLES_LOADED');
    handler:RegisterEvent('CVAR_UPDATE');
    handler:RegisterEvent('PLAYER_REGEN_ENABLED');

    handler.dirtyTable = {};
    function handler:TrySetAttribute(key, value)
        if InCombatLockdown() then
            self.dirtyTable[key] = value;
            return;
        end

        self:SetAttribute(key, value);
    end

    function handler:PLAYER_REGEN_ENABLED()
        for k, v in pairs(self.dirtyTable) do
            self:SetAttribute(k, v);
            self.dirtyTable[k] = nil;
        end
    end

    function handler:VARIABLES_LOADED()
        self:TrySetAttribute('ActionButtonUseKeyDown', GetCVarBool('ActionButtonUseKeyDown'))
    end

    function handler:CVAR_UPDATE(cvar)
        if cvar == 'ActionButtonUseKeyDown' then
            --
            self:TrySetAttribute(cvar, GetCVarBool(cvar))
        end
    end

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

            btn:EnableMouseWheel()
            btn:RegisterForClicks('AnyDown', 'AnyUp')

            handler:WrapScript(btn, "OnClick", [[
                -- print('OnClick',self:GetName(),button)
                if self:GetAttribute("type") == "action" then
                    local type, action = GetActionInfo(self:GetAttribute("action"))

                    local flyoutHandler = owner:GetFrameRef("flyoutHandler")
                    if flyoutHandler then
                        flyoutHandler:Hide()
                    end

                    if IsModifiedClick("PICKUPACTION") then
                        -- print('PICKUPACTION')
                        return false;
                    end                    

                    if button == 'Keybind' then    
                        local useKeyDown = control:GetAttribute("ActionButtonUseKeyDown")                         

                        if down == useKeyDown then
                            return "LeftButton"
                        end
                        return false
                    end

                  
                    if down then 
                        return false
                    else
                        return "LeftButton"    
                    end                                     
                end

                local flyoutHandler = owner:GetFrameRef("flyoutHandler")
                if flyoutHandler and (not down or self:GetParent() ~= flyoutHandler) then
                    flyoutHandler:Hide()
                end

                return "LeftButton"               
            ]])

            btn.command = "CLICK DragonflightUIMultiactionBar" .. n .. "Button" .. i .. ":Keybind"
            btn.commandHuman = "Action Bar " .. n .. ' Button ' .. i

            btn:SetAttributeNoHandler("commandName", btn.command)

            btns[i] = btn
            btn:Hide()
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

    DragonflightUIActionbarMixin:MigrateOldKeybinds()

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
            advancedName = 'ActionBars',
            options = optionsBar,
            extra = optionsBarExtra,
            default = function()
                setDefaultSubValues('bar' .. i)
            end,
            moduleRef = self
        });
    end

    -- extra action button
    if DF.Cata then
        local f = CreateFrame('FRAME', 'DragonflightUIExtraActionButtonPreview', UIParent)
        f:SetPoint('CENTER', UIParent, 'CENTER', 0, -180)
        f:SetSize(64, 64)
        f:SetClampedToScreen(true)

        Module.ExtraActionButtonPreview = f;

        EditModeModule:AddEditModeToFrame(f)

        f.DFEditModeSelection:SetGetLabelTextFunction(function()
            return 'Extra Action Button'
        end)

        f.DFEditModeSelection:RegisterOptions({
            name = 'Extra Action Button',
            sub = 'extraActionButton',
            advancedName = 'ExtraActionButton',
            options = extraActionButtonOptions,
            extra = extraActionButtonOptionsEditmode,
            default = function()
                setDefaultSubValues('extraActionButton')
            end,
            moduleRef = self,
            hideFunction = function()
                --
                f:Show()
            end
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
        advancedName = 'PetBar',
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
        advancedName = 'XPBar',
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
        advancedName = 'RepBar',
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
        advancedName = 'PossessBar',
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
        advancedName = 'StanceBar',
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
            advancedName = 'TotemBar',
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
        advancedName = 'Bags',
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
        advancedName = 'MicroMenu',
        options = microOptions,
        extra = optionsMicroEditmode,
        default = function()
            setDefaultSubValues('micro')
        end,
        moduleRef = self
    });

    -- fps 
    EditModeModule:AddEditModeToFrame(Module.FPSFrame)

    Module.FPSFrame.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'FPS'
    end)

    Module.FPSFrame.DFEditModeSelection:RegisterOptions({
        name = 'FPS',
        sub = 'fps',
        advancedName = 'FPS',
        options = fpsOptions,
        extra = optionsFPSEditmode,
        default = function()
            setDefaultSubValues('fps')
        end,
        moduleRef = self
    });
end

function Module:RegisterOptionScreens()
    for i = 1, 8 do
        local optionsBar = GetBarOption(i)
        DF.ConfigModule:RegisterSettingsData('actionbar' .. i, 'actionbar', {
            name = 'Actionbar' .. i,
            sub = 'bar' .. i,
            options = optionsBar,
            default = function()
                setDefaultSubValues('bar' .. i)
            end
        })
    end

    if DF.Cata then
        DF.ConfigModule:RegisterSettingsData('extraactionbutton', 'actionbar', {
            name = 'Extra Action Button',
            sub = 'extraActionButton',
            options = extraActionButtonOptions,
            default = function()
                setDefaultSubValues('extraActionButton')
            end
        })
    end

    DF.ConfigModule:RegisterSettingsData('petbar', 'actionbar', {
        name = 'Petbar',
        sub = 'pet',
        options = petOptions,
        default = function()
            setDefaultSubValues('pet')
        end
    })

    DF.ConfigModule:RegisterSettingsData('xpbar', 'actionbar', {
        name = 'XPbar',
        sub = 'xp',
        options = xpOptions,
        default = function()
            setDefaultSubValues('xp')
        end
    })

    DF.ConfigModule:RegisterSettingsData('repbar', 'actionbar', {
        name = 'Repbar',
        sub = 'rep',
        options = repOptions,
        default = function()
            setDefaultSubValues('rep')
        end
    })

    DF.ConfigModule:RegisterSettingsData('possessbar', 'actionbar', {
        name = 'Possessbar',
        sub = 'possess',
        options = possessOptions,
        default = function()
            setDefaultSubValues('possess')
        end
    })

    DF.ConfigModule:RegisterSettingsData('stancebar', 'actionbar', {
        name = 'Stancebar',
        sub = 'stance',
        options = stanceOptions,
        default = function()
            setDefaultSubValues('stance')
        end
    })
    if DF.Cata then
        DF.ConfigModule:RegisterSettingsData('totembar', 'actionbar', {
            name = 'Totembar',
            sub = 'totem',
            options = totemOptions,
            default = function()
                setDefaultSubValues('totem')
            end
        })
    end
    DF.ConfigModule:RegisterSettingsData('bags', 'actionbar', {
        name = 'Bags',
        sub = 'bags',
        options = bagsOptions,
        default = function()
            setDefaultSubValues('bags')
            UpdateContainerFrameAnchors()
        end
    })

    DF.ConfigModule:RegisterSettingsData('micromenu', 'actionbar', {
        name = 'Micromenu',
        sub = 'micro',
        options = microOptions,
        default = function()
            setDefaultSubValues('micro')
        end
    })

    DF.ConfigModule:RegisterSettingsData('fps', 'actionbar', {
        name = 'FPS',
        sub = 'fps',
        options = fpsOptions,
        default = function()
            setDefaultSubValues('fps')
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
    refreshCat('FPS')

    for i = 1, 8 do
        local bar = Module['bar' .. i]
        bar.DFEditModeSelection:RefreshOptionScreen();
    end

    Module.petbar.DFEditModeSelection:RefreshOptionScreen();
    Module.xpbar.DFEditModeSelection:RefreshOptionScreen();
    Module.repbar.DFEditModeSelection:RefreshOptionScreen();
    PossessBarFrame.DFEditModeSelection:RefreshOptionScreen();
    Module.stancebar.DFEditModeSelection:RefreshOptionScreen();
    if DF.Cata then
        MultiCastActionBarFrame.DFEditModeSelection:RefreshOptionScreen();
        Module.ExtraActionButtonPreview.DFEditModeSelection:RefreshOptionScreen();
    end

    MainMenuBarBackpackButton.DFEditModeSelection:RefreshOptionScreen();
    Module.MicroFrame.DFEditModeSelection:RefreshOptionScreen();
    Module.FPSFrame.DFEditModeSelection:RefreshOptionScreen();
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

        if DF.Cata then
            Module.UpdateTotemState(db.totem)
            Module:UpdateExtraButtonState(db.extraActionButton)
        end

        Module.UpdateBagState(db.bags)
        Module.MicroFrame:UpdateState(db.micro)
        Module.FPSFrame:SetState(db.fps)

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
    elseif sub == 'extraActionButton' then
        if DF.Cata then Module:UpdateExtraButtonState(db.extraActionButton) end
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
    elseif sub == 'fps' then
        Module.FPSFrame:SetState(db.fps)
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
    if not self:IsEnabled() then return end

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

function Module:UpdateExtraButtonState(state)
    -- print('UpdateExtraButtonState')
    -- Module.ExtraActionButtonPreview

    local parent = _G[state.anchorFrame]

    Module.ExtraActionButtonPreview:ClearAllPoints()
    Module.ExtraActionButtonPreview:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    Module.ExtraActionButtonPreview:SetScale(state.scale)

    local btn = _G['ExtraActionButton1']
    btn:ClearAllPoints()
    btn:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    btn:SetScale(state.scale)

    if state.hideBackgroundTexture then
        btn.style:SetAlpha(0);
    else
        btn.style:SetAlpha(1.0);
    end
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
    local fps = CreateFrame('Frame', 'DragonflightUIFPSTextFrame', UIParent, 'DragonflightUIFPSTemplate')
    fps:SetSize(65, 26)
    fps:SetPoint('RIGHT', CharacterMicroButton, 'LEFT', -10, 0)

    Module.FPSFrame = fps
end

function Module:Era()
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

function Module:TBC()
end

function Module:Wrath()
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

function Module:Cata()
    Module:Wrath()
end

function Module:Mists()
    Module:Wrath()
end
