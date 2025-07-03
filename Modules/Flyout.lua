local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Flyout'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        scale = 1,
        warlock = {
            scale = 0.8,
            anchorFrame = 'UIParent',
            customAnchorFrame = '',
            anchor = 'CENTER',
            anchorParent = 'CENTER',
            x = 0,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 7,
            padding = 2,
            -- flyout
            icon = 136082,
            displayName = L["FlyoutWarlock"],
            tooltip = L["FlyoutWarlockDesc"],
            flyoutDirection = 'TOP',
            spells = '688, 697,712,713,691,1122,18540',
            spellsAlliance = '',
            spellsHorde = '',
            items = '',
            closeAfterClick = true,
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
        magePort = {
            scale = 0.8,
            anchorFrame = "DragonflightUISpellFlyout" .. "Warlock" .. "Button",
            customAnchorFrame = '',
            anchor = 'LEFT',
            anchorParent = 'RIGHT',
            x = 4,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 10,
            padding = 2,
            -- flyout
            icon = 237509,
            displayName = L["FlyoutMagePort"],
            tooltip = L["FlyoutMagePortDesc"],
            flyoutDirection = 'TOP',
            spells = '',
            spellsAlliance = '3561,3562,3565,32271,49359,33690,53140,120145,88342,132621',
            spellsHorde = '3567,3563,3566,32272,49358,35715,53140,120145,88344,132627',
            -- spellsHorde = '3567,3563,3566,49358,35715,53140',
            items = '',
            closeAfterClick = true,
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
        magePortals = {
            scale = 0.8,
            anchorFrame = "DragonflightUISpellFlyout" .. "MagePort" .. "Button",
            customAnchorFrame = '',
            anchor = 'LEFT',
            anchorParent = 'RIGHT',
            x = 4,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 10,
            padding = 2,
            -- flyout
            icon = 135748,
            displayName = L["FlyoutMagePortals"],
            tooltip = L["FlyoutMagePortalsDesc"],
            flyoutDirection = 'TOP',
            spells = '',
            spellsAlliance = '10059,11416,11419,32266,49360,33691,53142,120146,88345,132620',
            spellsHorde = '11417,11418,11420,32267,49361,35717,53142,120146,88346,132626',
            items = '',
            closeAfterClick = true,
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
        mageWater = {
            scale = 0.8,
            anchorFrame = "DragonflightUISpellFlyout" .. "MagePortals" .. "Button",
            customAnchorFrame = '',
            anchor = 'LEFT',
            anchorParent = 'RIGHT',
            x = 4,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 10,
            padding = 2,
            -- flyout
            icon = 132793,
            displayName = L["FlyoutMageWater"],
            tooltip = L["FlyoutMageWaterDesc"],
            flyoutDirection = 'TOP',
            spells = '5504,5505,5506,6127,10138,10139,10140,468766',
            spellsAlliance = '',
            spellsHorde = '',
            items = '',
            closeAfterClick = true,
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
        mageFood = {
            scale = 0.8,
            anchorFrame = "DragonflightUISpellFlyout" .. "MageWater" .. "Button",
            customAnchorFrame = '',
            anchor = 'LEFT',
            anchorParent = 'RIGHT',
            x = 4,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 10,
            padding = 2,
            -- flyout
            icon = 134029,
            displayName = L["FlyoutMageFood"],
            tooltip = L["FlyoutMageFoodDesc"],
            flyoutDirection = 'TOP',
            spells = '587,597,990,6129,10144,10145,28612',
            spellsAlliance = '',
            spellsHorde = '',
            items = '',
            closeAfterClick = true,
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
        custom1 = {
            scale = 0.8,
            anchorFrame = "UIParent",
            customAnchorFrame = '',
            anchor = 'CENTER',
            anchorParent = 'CENTER',
            x = 300,
            y = -100,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 12,
            padding = 2,
            -- flyout
            icon = 134400,
            displayName = string.format(L["FlyoutCustomNameFormat"], 1),
            tooltip = string.format(L["FlyoutCustomNameDescFormat"], 1),
            flyoutDirection = 'TOP',
            spells = '',
            spellsAlliance = '',
            spellsHorde = '',
            items = '',
            closeAfterClick = true,
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
        custom2 = {
            scale = 0.8,
            anchorFrame = "DragonflightUISpellFlyout" .. "Custom" .. tostring(1) .. "Button",
            customAnchorFrame = '',
            anchor = 'LEFT',
            anchorParent = 'RIGHT',
            x = 4,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 12,
            padding = 2,
            -- flyout
            icon = 134400,
            displayName = string.format(L["FlyoutCustomNameFormat"], 2),
            tooltip = string.format(L["FlyoutCustomNameDescFormat"], 2),
            flyoutDirection = 'TOP',
            spells = '',
            spellsAlliance = '',
            spellsHorde = '',
            items = '',
            closeAfterClick = true,
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
        custom3 = {
            scale = 0.8,
            anchorFrame = "DragonflightUISpellFlyout" .. "Custom" .. tostring(2) .. "Button",
            customAnchorFrame = '',
            anchor = 'LEFT',
            anchorParent = 'RIGHT',
            x = 4,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 12,
            padding = 2,
            -- flyout
            icon = 134400,
            displayName = string.format(L["FlyoutCustomNameFormat"], 3),
            tooltip = string.format(L["FlyoutCustomNameDescFormat"], 3),
            flyoutDirection = 'TOP',
            spells = '',
            spellsAlliance = '',
            spellsHorde = '',
            items = '',
            closeAfterClick = true,
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
        custom4 = {
            scale = 0.8,
            anchorFrame = "DragonflightUISpellFlyout" .. "Custom" .. tostring(3) .. "Button",
            customAnchorFrame = '',
            anchor = 'LEFT',
            anchorParent = 'RIGHT',
            x = 4,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 12,
            padding = 2,
            -- flyout
            icon = 134400,
            displayName = string.format(L["FlyoutCustomNameFormat"], 4),
            tooltip = string.format(L["FlyoutCustomNameDescFormat"], 4),
            flyoutDirection = 'TOP',
            spells = '',
            spellsAlliance = '',
            spellsHorde = '',
            items = '',
            closeAfterClick = true,
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
        custom5 = {
            scale = 0.8,
            anchorFrame = "DragonflightUISpellFlyout" .. "Custom" .. tostring(4) .. "Button",
            customAnchorFrame = '',
            anchor = 'LEFT',
            anchorParent = 'RIGHT',
            x = 4,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 12,
            padding = 2,
            -- flyout
            icon = 134400,
            displayName = string.format(L["FlyoutCustomNameFormat"], 5),
            tooltip = string.format(L["FlyoutCustomNameDescFormat"], 5),
            flyoutDirection = 'TOP',
            spells = '',
            spellsAlliance = '',
            spellsHorde = '',
            items = '',
            closeAfterClick = true,
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
        custom6 = {
            scale = 0.8,
            anchorFrame = "DragonflightUISpellFlyout" .. "Custom" .. tostring(5) .. "Button",
            customAnchorFrame = '',
            anchor = 'LEFT',
            anchorParent = 'RIGHT',
            x = 4,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 12,
            padding = 2,
            -- flyout
            icon = 134400,
            displayName = string.format(L["FlyoutCustomNameFormat"], 6),
            tooltip = string.format(L["FlyoutCustomNameDescFormat"], 6),
            flyoutDirection = 'TOP',
            spells = '',
            spellsAlliance = '',
            spellsHorde = '',
            items = '',
            closeAfterClick = true,
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
        custom7 = {
            scale = 0.8,
            anchorFrame = "DragonflightUISpellFlyout" .. "Custom" .. tostring(6) .. "Button",
            customAnchorFrame = '',
            anchor = 'LEFT',
            anchorParent = 'RIGHT',
            x = 4,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 12,
            padding = 2,
            -- flyout
            icon = 134400,
            displayName = string.format(L["FlyoutCustomNameFormat"], 7),
            tooltip = string.format(L["FlyoutCustomNameDescFormat"], 7),
            flyoutDirection = 'TOP',
            spells = '',
            spellsAlliance = '',
            spellsHorde = '',
            items = '',
            closeAfterClick = true,
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
        custom8 = {
            scale = 0.8,
            anchorFrame = "DragonflightUISpellFlyout" .. "Custom" .. tostring(7) .. "Button",
            customAnchorFrame = '',
            anchor = 'LEFT',
            anchorParent = 'RIGHT',
            x = 4,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 12,
            padding = 2,
            -- flyout
            icon = 134400,
            displayName = string.format(L["FlyoutCustomNameFormat"], 8),
            tooltip = string.format(L["FlyoutCustomNameDescFormat"], 8),
            flyoutDirection = 'TOP',
            spells = '',
            spellsAlliance = '',
            spellsHorde = '',
            items = '',
            closeAfterClick = true,
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
        custom9 = {
            scale = 0.8,
            anchorFrame = "DragonflightUISpellFlyout" .. "Custom" .. tostring(8) .. "Button",
            customAnchorFrame = '',
            anchor = 'LEFT',
            anchorParent = 'RIGHT',
            x = 4,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 12,
            padding = 2,
            -- flyout
            icon = 134400,
            displayName = string.format(L["FlyoutCustomNameFormat"], 9),
            tooltip = string.format(L["FlyoutCustomNameDescFormat"], 9),
            flyoutDirection = 'TOP',
            spells = '',
            spellsAlliance = '',
            spellsHorde = '',
            items = '',
            closeAfterClick = true,
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
        custom10 = {
            scale = 0.8,
            anchorFrame = "DragonflightUISpellFlyout" .. "Custom" .. tostring(9) .. "Button",
            customAnchorFrame = '',
            anchor = 'LEFT',
            anchorParent = 'RIGHT',
            x = 4,
            y = 0,
            orientation = 'horizontal',
            reverse = false,
            buttonScale = 0.8,
            rows = 1,
            buttons = 12,
            padding = 2,
            -- flyout
            icon = 134400,
            displayName = string.format(L["FlyoutCustomNameFormat"], 10),
            tooltip = string.format(L["FlyoutCustomNameDescFormat"], 10),
            flyoutDirection = 'TOP',
            spells = '',
            spellsAlliance = '',
            spellsHorde = '',
            items = '',
            closeAfterClick = true,
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
        actions = {actionTable = {}}
    },
    class = {WARLOCK = {test = 1337}},
    char = {actions = {actionTable = {}}}
}
-- 
local numCustomButtons = 10;
Module.NumCustomButtons = numCustomButtons;

for i = 1, numCustomButtons do
    defaults.char['custom' .. i] = {
        icon = 134400,
        displayName = string.format(L["FlyoutCustomNameFormat"], i),
        tooltip = string.format(L["FlyoutCustomNameDescFormat"], i),
        flyoutDirection = 'TOP',
        closeAfterClick = true,
        buttons = 12,
        activate = i <= 5
        -- alwaysShow = true
    }
end
Module:SetDefaults(defaults)

local classDefaults = {
    WARLOCK = {
        [1] = {
            icon = 136082,
            displayName = L["FlyoutWarlock"],
            tooltip = L["FlyoutWarlockDesc"],
            flyoutDirection = 'TOP',
            spells = {688, 697, 712, 713, 691, 1122, 18540}
        }
    },
    MAGE_ALLIANCE = {
        [1] = {
            icon = 237509,
            displayName = L["FlyoutMagePort"],
            tooltip = L["FlyoutMagePortDesc"],
            flyoutDirection = 'TOP',
            spells = {3561, 3562, 3565, 32271, 49359, 33690, 53140, 120145, 88342, 132621}
        },
        [2] = {
            icon = 135748,
            displayName = L["FlyoutMagePortals"],
            tooltip = L["FlyoutMagePortalsDesc"],
            flyoutDirection = 'TOP',
            spells = {10059, 11416, 11419, 32266, 49360, 33691, 53142, 120146, 88345, 132620}
        }
    },
    MAGE_HORDE = {
        [1] = {
            icon = 237509,
            displayName = L["FlyoutMagePort"],
            tooltip = L["FlyoutMagePortDesc"],
            flyoutDirection = 'TOP',
            spells = {3567, 3563, 3566, 32272, 49358, 35715, 53140, 120145, 88344, 132627}
        },
        [2] = {
            icon = 135744,
            displayName = L["FlyoutMagePortals"],
            tooltip = L["FlyoutMagePortalsDesc"],
            flyoutDirection = 'TOP',
            spells = {11417, 11418, 11420, 32267, 49361, 35717, 53142, 120146, 88346, 132626}
        }
    }
}
if DF.API.Version.IsClassic then
    local t = {
        [3] = {
            icon = 132793,
            displayName = L["FlyoutMageWater"],
            tooltip = L["FlyoutMageWaterDesc"],
            flyoutDirection = 'TOP',
            spells = {5504, 5505, 5506, 6127, 10138, 10139, 10140, 468766}
        },
        [4] = {
            icon = 134029,
            displayName = L["FlyoutMageFood"],
            tooltip = L["FlyoutMageFoodDesc"],
            flyoutDirection = 'TOP',
            spells = {587, 597, 990, 6129, 10144, 10145, 28612}
        }
    }
    for k, v in pairs(t) do
        classDefaults.MAGE_ALLIANCE[k] = v;
        classDefaults.MAGE_HORDE[k] = v;
    end
end
-- DevTools_Dump(classDefaults)

local function getDefaultStr(key, sub, extra)
    return Module:GetDefaultStr(key, sub, extra)
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
    {value = 'UIParent', text = 'UIParent', tooltip = 'descr', label = 'label'}
    -- {
    --     value = "DragonflightUISpellFlyout" .. "Warlock" .. "Button",
    --     text = L["FlyoutButtonWarlock"],
    --     tooltip = 'descr',
    --     label = 'label'
    -- }
    -- {
    --     value = "DragonflightUISpellFlyout" .. "MagePort" .. "Button",
    --     text = L["FlyoutButtonMagePort"],
    --     tooltip = 'descr',
    --     label = 'label'
    -- }, {
    --     value = "DragonflightUISpellFlyout" .. "MagePortals" .. "Button",
    --     text = L["FlyoutButtonMagePortals"],
    --     tooltip = 'descr',
    --     label = 'label'
    -- }
}

-- if DF.API.Version.IsClassic then
--     table.insert(frameTable, {
--         value = "DragonflightUISpellFlyout" .. "MageFood" .. "Button",
--         text = L["FlyoutButtonMageFood"],
--         tooltip = 'descr',
--         label = 'label'
--     })
--     table.insert(frameTable, {
--         value = "DragonflightUISpellFlyout" .. "MageWater" .. "Button",
--         text = L["FlyoutButtonMageWater"],
--         tooltip = 'descr',
--         label = 'label'
--     })
-- end

for i = 1, numCustomButtons do
    --
    table.insert(frameTable, {
        value = "DragonflightUISpellFlyout" .. "Custom" .. i .. "Button",
        text = string.format(L["FlyoutCustomNameFormat"], i),
        tooltip = 'descr',
        label = 'label'
    })
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

function AddFlyoutTable(optionTable, sub)
    local extraOptions = {
        headerFlyout = {
            type = 'header',
            name = L["FlyoutHeader"],
            desc = L["FlyoutHeaderDesc"],
            order = 10,
            isExpanded = true,
            editmode = true
        },
        flyoutDirection = {
            type = 'select',
            name = L["FlyoutDirection"],
            desc = L["FlyoutDirectionDesc"] .. getDefaultStr('flyoutDirection', sub),
            dropdownValues = DF.Settings.DropdownCrossAnchorTable,
            order = 2,
            group = 'headerFlyout',
            editmode = true
        },
        buttons = {
            type = 'range',
            name = L["ButtonTableNumButtons"],
            desc = L["ButtonTableNumButtonsDesc"] .. getDefaultStr('buttons', sub),
            min = 1,
            max = 12,
            bigStep = 1,
            order = 3,
            group = 'headerFlyout',
            editmode = true
        },
        -- spells = {
        --     type = 'editbox',
        --     name = L["FlyoutSpells"],
        --     desc = L["FlyoutSpellsDesc"] .. getDefaultStr('spells', sub),
        --     Validate = function()
        --         return true
        --     end,
        --     order = 4.5,
        --     group = 'headerFlyout',
        --     editmode = true
        -- },
        -- spellsAlliance = {
        --     type = 'editbox',
        --     name = L["FlyoutSpellsAlliance"],
        --     desc = L["FlyoutSpellsAllianceDesc"] .. getDefaultStr('spellsAlliance', sub),
        --     Validate = function()
        --         return true
        --     end,
        --     order = 4.6,
        --     group = 'headerFlyout',
        --     editmode = true
        -- },
        -- spellsHorde = {
        --     type = 'editbox',
        --     name = L["FlyoutSpellsHorde"],
        --     desc = L["FlyoutSpellsHordeDesc"] .. getDefaultStr('spellsHorde', sub),
        --     Validate = function()
        --         return true
        --     end,
        --     order = 4.7,
        --     group = 'headerFlyout',
        --     editmode = true
        -- },
        -- items = {
        --     type = 'editbox',
        --     name = L["FlyoutItems"],
        --     desc = L["FlyoutItemsDesc"] .. getDefaultStr('items', sub),
        --     Validate = function()
        --         return true
        --     end,
        --     order = 4.8,
        --     group = 'headerFlyout',
        --     editmode = true
        -- },
        closeAfterClick = {
            type = 'toggle',
            name = L["FlyoutCloseAfterClick"],
            desc = L["FlyoutCloseAfterClickDesc"] .. getDefaultStr('closeAfterClick', sub),
            order = 5,
            group = 'headerFlyout',
            editmode = true
        },
        -- alwaysShow = {
        --     type = 'toggle',
        --     name = L["FlyoutAlwaysShow"],
        --     desc = L["FlyoutAlwaysShowDesc"] .. getDefaultStr('alwaysShow', sub),
        --     group = 'headerFlyout',
        --     order = 5.1,
        --     editmode = true
        -- },
        icon = {
            type = 'editbox',
            name = L["FlyoutIcon"],
            desc = L["FlyoutIconDesc"] .. getDefaultStr('icon', sub),
            Validate = function()
                return true
            end,
            order = 10.1,
            group = 'headerFlyout',
            editmode = true
        },
        displayName = {
            type = 'editbox',
            name = L["FlyoutDisplayname"],
            desc = L["FlyoutDisplaynameDesc"] .. getDefaultStr('displayName', sub),
            Validate = function()
                return true
            end,
            order = 10.2,
            group = 'headerFlyout',
            editmode = true
        },
        tooltip = {
            type = 'editbox',
            name = L["FlyoutTooltip"],
            desc = L["FlyoutTooltipDesc"] .. getDefaultStr('tooltip', sub),
            Validate = function()
                return true
            end,
            order = 10.3,
            group = 'headerFlyout',
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

    optionTable.get = function(info)
        local key = info[1]
        local s = info[2]
        if defaults.char.custom1[s] ~= nil then
            local t = Module.db.char[key]
            return t[s]
        else
            return getOption(info)
        end
    end

    optionTable.set = function(info, value)
        local key = info[1]
        local s = info[2]

        if defaults.char.custom1[s] ~= nil then
            local t = Module.db.char[key]
            t[s] = value
            Module:ApplySettings(key)
        else
            setOption(info, value)
        end
    end
end

-- warlock pets
local warlockOptions = {
    name = L["FlyoutButtonWarlock"],
    desc = '...',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        activate = {
            type = 'toggle',
            name = L["ButtonTableActive"],
            desc = L["ButtonTableActiveDesc"] .. getDefaultStr('activate', 'warlock'),
            order = -1,
            new = false,
            editmode = true
        }
    }
}
AddFlyoutTable(warlockOptions, 'warlock')
DF.Settings:AddPositionTable(Module, warlockOptions, 'warlock', 'Warlock', getDefaultStr,
                             frameTableWithout("DragonflightUISpellFlyout" .. "Warlock" .. "Button"))

DragonflightUIStateHandlerMixin:AddStateTable(Module, warlockOptions, 'warlock', 'Warlock', getDefaultStr)
local warlockOptionsEditmode = {
    name = 'flyout',
    desc = 'flyout',
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
                local dbTable = Module.db.profile.warlock
                local defaultsTable = defaults.profile.warlock
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'warlock')
            end,
            order = 16,
            editmode = true,
            new = false
        }
    }
}

-- mage port
local magePortOptions = {
    name = 'Mage Port',
    desc = '...',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        activate = {
            type = 'toggle',
            name = L["ButtonTableActive"],
            desc = L["ButtonTableActiveDesc"] .. getDefaultStr('activate', 'magePort'),
            order = -1,
            new = false,
            editmode = true
        }
    }
}
AddFlyoutTable(magePortOptions, 'magePort')
DF.Settings:AddPositionTable(Module, magePortOptions, 'magePort', 'Mage Port', getDefaultStr,
                             frameTableWithout("DragonflightUISpellFlyout" .. "MagePort" .. "Button"))

DragonflightUIStateHandlerMixin:AddStateTable(Module, magePortOptions, 'magePort', 'Mage Port', getDefaultStr)
local magePortOptionsEditmode = {
    name = 'flyout',
    desc = 'flyout',
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
                local dbTable = Module.db.profile.magePort
                local defaultsTable = defaults.profile.magePort
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'magePort')
            end,
            order = 16,
            editmode = true,
            new = false
        }
    }
}

-- portals
local magePortalOptions = {
    name = 'Mage Portals',
    desc = '...',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        activate = {
            type = 'toggle',
            name = L["ButtonTableActive"],
            desc = L["ButtonTableActiveDesc"] .. getDefaultStr('activate', 'magePortals'),
            order = -1,
            new = false,
            editmode = true
        }
    }
}
AddFlyoutTable(magePortalOptions, 'magePortals')
DF.Settings:AddPositionTable(Module, magePortalOptions, 'magePortals', 'Mage Portals', getDefaultStr,
                             frameTableWithout("DragonflightUISpellFlyout" .. "MagePortals" .. "Button"))

DragonflightUIStateHandlerMixin:AddStateTable(Module, magePortalOptions, 'magePortals', 'Mage Portals', getDefaultStr)
local magePortalOptionsEditmode = {
    name = 'flyout',
    desc = 'flyout',
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
                local dbTable = Module.db.profile.magePortals
                local defaultsTable = defaults.profile.magePortals
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'magePortals')
            end,
            order = 16,
            editmode = true,
            new = false
        }
    }
}

-- mage food
local mageFoodOptions = {
    name = 'Mage Food',
    desc = '...',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        activate = {
            type = 'toggle',
            name = L["ButtonTableActive"],
            desc = L["ButtonTableActiveDesc"] .. getDefaultStr('activate', 'mageFood'),
            order = -1,
            new = false,
            editmode = true
        }
    }
}
AddFlyoutTable(mageFoodOptions, 'mageFood')
DF.Settings:AddPositionTable(Module, mageFoodOptions, 'mageFood', 'Mage Food', getDefaultStr,
                             frameTableWithout("DragonflightUISpellFlyout" .. "MageFood" .. "Button"))

DragonflightUIStateHandlerMixin:AddStateTable(Module, mageFoodOptions, 'mageFood', 'Mage Food', getDefaultStr)
local mageFoodOptionsEditmode = {
    name = 'flyout',
    desc = 'flyout',
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
                local dbTable = Module.db.profile.mageFood
                local defaultsTable = defaults.profile.mageFood
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'mageFood')
            end,
            order = 16,
            editmode = true,
            new = false
        }
    }
}

-- mage water
local mageWaterOptions = {
    name = 'Mage Water',
    desc = '...',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        activate = {
            type = 'toggle',
            name = L["ButtonTableActive"],
            desc = L["ButtonTableActiveDesc"] .. getDefaultStr('activate', 'mageWater'),
            order = -1,
            new = false,
            editmode = true
        }
    }
}
AddFlyoutTable(mageWaterOptions, 'mageWater')
DF.Settings:AddPositionTable(Module, mageWaterOptions, 'mageWater', 'Mage Water', getDefaultStr,
                             frameTableWithout("DragonflightUISpellFlyout" .. "MageWater" .. "Button"))

DragonflightUIStateHandlerMixin:AddStateTable(Module, mageWaterOptions, 'mageWater', 'Mage Water', getDefaultStr)
local mageWaterOptionsEditmode = {
    name = 'flyout',
    desc = 'flyout',
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
                local dbTable = Module.db.profile.mageWater
                local defaultsTable = defaults.profile.mageWater
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'mageWater')
            end,
            order = 16,
            editmode = true,
            new = false
        }
    }
}

-- custom
local customOptionsTable = {}
local customOptionsTableEditmode = {}

for i = 1, numCustomButtons do
    --
    local sub = 'custom' .. i;
    local options = {
        name = string.format(L["FlyoutCustomNameFormat"], i),
        desc = '...',
        get = getOption,
        set = setOption,
        type = 'group',
        args = {
            activate = {
                type = 'toggle',
                name = L["ButtonTableActive"],
                desc = L["ButtonTableActiveDesc"] .. getDefaultStr('activate', sub),
                order = -1,
                new = false,
                editmode = true
            }
        }
    }
    AddFlyoutTable(options, sub)
    DF.Settings:AddPositionTable(Module, options, sub, string.format(L["FlyoutCustomNameFormat"], i), getDefaultStr,
                                 frameTableWithout("DragonflightUISpellFlyout" .. "Custom" .. i .. "Button"))

    DragonflightUIStateHandlerMixin:AddStateTable(Module, options, sub, string.format(L["FlyoutCustomNameFormat"], i),
                                                  getDefaultStr)
    local optionsEditmode = {
        name = 'flyout',
        desc = 'flyout',
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
                    local dbTable = Module.db.profile[sub]
                    local defaultsTable = defaults.profile[sub]
                    -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                    setPreset(dbTable, {
                        scale = defaultsTable.scale,
                        anchor = defaultsTable.anchor,
                        anchorParent = defaultsTable.anchorParent,
                        anchorFrame = defaultsTable.anchorFrame,
                        x = defaultsTable.x,
                        y = defaultsTable.y
                    }, sub)
                end,
                order = 16,
                editmode = true,
                new = false
            }
        }
    }

    for k, v in pairs(options.args) do
        if defaults.char.custom1[k] ~= nil then
            v.desc = v.desc .. L["SettingsCharacterSpecific"];
            v.char = true;
        end
    end

    do
        local localizedClass, englishClass, classIndex = UnitClass('player')

        if englishClass == 'MAGE' then
            local englishFaction, localizedFaction = UnitFactionGroup('player')

            if englishFaction then englishClass = englishClass .. '_' .. englishFaction:upper() end
            -- englishClass = 'MAGE_HORDE'
        end

        if classDefaults[englishClass] then
            local template = classDefaults[englishClass]
            -- local db = Module.db.char;

            options.args['headerClassPresets'] = {
                type = 'header',
                name = L["FlyoutHeaderClassPresets"],
                desc = L["FlyoutHeaderClassPresetsDesc"],
                order = 12,
                isExpanded = true,
                editmode = true
            }

            for flyout, flyoutOptions in pairs(template) do
                options.args['custom' .. flyout .. 'preset'] = {
                    type = 'execute',
                    name = L["ExtraOptionsPreset"],
                    btnName = flyoutOptions.displayName,
                    desc = L["FlyoutHeaderClassPresetsDesc"],
                    func = function()
                        local db = Module.db.char;
                        local flyoutTable = db['custom' .. i]
                        local baseID = 5 + i - 1

                        for k, v in pairs(flyoutOptions) do
                            if k ~= 'spells' then
                                flyoutTable[k] = v;
                            else
                                local index = 0;
                                for j, spell in ipairs(v) do
                                    local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon =
                                        GetSpellInfo(spell)
                                    if name then
                                        -- print(name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon)
                                        local actionID = baseID * 12 + j;
                                        -- print('actionID', actionID, Module:GetAction(actionID))
                                        Module:SetAction(actionID, 'spell', spell)
                                        index = index + 1;
                                    end
                                end
                                -- print('~~~>>', index)
                                flyoutTable['buttons'] = index
                            end
                        end

                        Module:ApplySettings('custom' .. i)
                    end,
                    group = 'headerClassPresets',
                    order = flyout,
                    editmode = true,
                    new = true
                }
            end

        end
    end

    customOptionsTable[i] = options
    customOptionsTableEditmode[i] = optionsEditmode
end

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)
    Module:AddClassDefaults()

    hooksecurefunc(DF:GetModule('Config'), 'AddConfigFrame', function()
        Module:RegisterSettings()
    end)
    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    -- DF:RegisterModuleOptions(mName, generalOptions)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    self:EnableAddonSpecific()

    Module:AddEditMode()

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

function Module:RegisterSettings()
    local moduleName = 'Flyout'
    local cat = 'flyout'
    local function register(name, data)
        data.module = moduleName;
        DF.ConfigModule:RegisterSettingsElement(name, cat, data, true)
    end

    -- register('warlock', {order = 0, name = L["FlyoutButtonWarlock"], descr = '...', isNew = true})
    -- register('magePort', {order = 0, name = L["FlyoutButtonMagePort"], descr = '...', isNew = true})
    -- register('magePortals', {order = 0, name = L["FlyoutButtonMagePortals"], descr = '...', isNew = true})
    -- if DF.API.Version.IsClassic then
    --     register('mageFood', {order = 0, name = L["FlyoutButtonMageFood"], descr = '...', isNew = true})
    --     register('mageWater', {order = 0, name = L["FlyoutButtonMageWater"], descr = '...', isNew = true})
    -- end

    for i = 1, numCustomButtons do
        --
        register('custom' .. i,
                 {order = i, name = string.format(L["FlyoutCustomNameFormat"], i), descr = '...', isNew = true})
    end
end

function Module:RegisterOptionScreens()
    -- DF.ConfigModule:RegisterSettingsData('warlock', 'flyout', {
    --     name = L["FlyoutButtonWarlock"],
    --     sub = 'warlock',
    --     options = warlockOptions,
    --     sortComparator = warlockOptions.sortComparator,
    --     default = function()
    --         setDefaultSubValues('warlock')
    --     end
    -- })

    -- DF.ConfigModule:RegisterSettingsData('magePort', 'flyout', {
    --     name = L["FlyoutButtonMagePort"],
    --     sub = 'magePort',
    --     options = magePortOptions,
    --     sortComparator = magePortOptions.sortComparator,
    --     default = function()
    --         setDefaultSubValues('magePort')
    --     end
    -- })

    -- DF.ConfigModule:RegisterSettingsData('magePortals', 'flyout', {
    --     name = L["FlyoutButtonMagePortals"],
    --     sub = 'magePortals',
    --     options = magePortalOptions,
    --     sortComparator = magePortalOptions.sortComparator,
    --     default = function()
    --         setDefaultSubValues('magePortals')
    --     end
    -- })

    -- if DF.API.Version.IsClassic then
    --     DF.ConfigModule:RegisterSettingsData('mageFood', 'flyout', {
    --         name = L["FlyoutButtonMageFood"],
    --         sub = 'mageFood',
    --         options = mageFoodOptions,
    --         sortComparator = mageFoodOptions.sortComparator,
    --         default = function()
    --             setDefaultSubValues('mageFood')
    --         end
    --     })

    --     DF.ConfigModule:RegisterSettingsData('mageWater', 'flyout', {
    --         name = L["FlyoutButtonMageWater"],
    --         sub = 'mageWater',
    --         options = mageWaterOptions,
    --         sortComparator = mageWaterOptions.sortComparator,
    --         default = function()
    --             setDefaultSubValues('mageWater')
    --         end
    --     })
    -- end

    for i = 1, numCustomButtons do
        --   
        local n = string.format(L["FlyoutCustomNameFormat"], i);
        local sub = 'custom' .. i;

        DF.ConfigModule:RegisterSettingsData(sub, 'flyout', {
            name = n,
            sub = sub,
            options = customOptionsTable[i],
            sortComparator = customOptionsTable[i].sortComparator,
            default = function()
                setDefaultSubValues(sub)
            end
        })
    end
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame

    local refreshCat = function(name)
        configFrame:RefreshCatSub('Flyout', name)
    end

    -- refreshCat('warlock')
    -- refreshCat('magePort')
    -- refreshCat('magePortals')

    -- Module.WarlockButton.DFEditModeSelection:RefreshOptionScreen();
    -- Module.MagePortButton.DFEditModeSelection:RefreshOptionScreen();
    -- Module.MagePortalsButton.DFEditModeSelection:RefreshOptionScreen();

    -- if DF.API.Version.IsClassic then
    --     refreshCat('mageFood')
    --     refreshCat('mageWater')
    --     Module.MageFoodButton.DFEditModeSelection:RefreshOptionScreen();
    --     Module.MageWaterButton.DFEditModeSelection:RefreshOptionScreen();
    -- end

    for i = 1, numCustomButtons do
        --   
        local n = string.format(L["FlyoutCustomNameFormat"], i);
        local sub = 'custom' .. i;

        refreshCat(sub)

        local btn = Module['Custom' .. i .. 'Button'];
        btn.DFEditModeSelection:RefreshOptionScreen();
    end
end

function Module:ApplySettings(sub)
    -- print('Module:ApplySettings(sub)', sub)
    local db = Module.db.profile
    local char = Module.db.char

    if not sub or sub == 'ALL' then
        -- Module.WarlockButton:SetState(db.warlock)
        -- Module.MagePortButton:SetState(db.magePort)
        -- Module.MagePortalsButton:SetState(db.magePortals)
        -- if DF.API.Version.IsClassic then
        --     Module.MageFoodButton:SetState(db.mageFood)
        --     Module.MageWaterButton:SetState(db.mageWater)
        -- end

        for i = 1, numCustomButtons do
            --
            local btn = Module['Custom' .. i .. 'Button'];
            if btn then btn:SetState(db['custom' .. i], char['custom' .. i]) end
        end
        -- elseif sub == 'warlock' then
        --     Module.WarlockButton:SetState(db.warlock)
        -- elseif sub == 'magePort' then
        --     Module.MagePortButton:SetState(db.magePort)
        -- elseif sub == 'magePortals' then
        --     Module.MagePortalsButton:SetState(db.magePortals)
        -- elseif sub == 'mageFood' then
        --     Module.MageFoodButton:SetState(db.mageFood)
        -- elseif sub == 'mageWater' then
        --     Module.MageWaterButton:SetState(db.mageWater)
    elseif strmatch(sub, 'custom') then
        local big = sub:gsub("c", "C")
        local btn = Module[big .. 'Button'];
        if btn then btn:SetState(db[sub], char[sub]) end
    end
end

function Module:AddEditMode()
    local EditModeModule = DF:GetModule('Editmode');

    -- -- warlock
    -- do
    --     EditModeModule:AddEditModeToFrame(Module.WarlockButton)

    --     Module.WarlockButton.DFEditModeSelection:SetGetLabelTextFunction(function()
    --         return L["FlyoutButtonWarlock"]
    --     end)

    --     Module.WarlockButton.DFEditModeSelection:RegisterOptions({
    --         name = L["FlyoutButtonWarlock"],
    --         sub = 'warlock',
    --         advancedName = 'FlyoutBar',
    --         options = warlockOptions,
    --         extra = warlockOptionsEditmode,
    --         -- parentExtra = TargetFrame,
    --         default = function()
    --             setDefaultSubValues('warlock')
    --         end,
    --         moduleRef = self
    --     });
    -- end

    -- -- mage port
    -- do
    --     EditModeModule:AddEditModeToFrame(Module.MagePortButton)

    --     Module.MagePortButton.DFEditModeSelection:SetGetLabelTextFunction(function()
    --         return L["FlyoutButtonMagePort"]
    --     end)

    --     Module.MagePortButton.DFEditModeSelection:RegisterOptions({
    --         name = L["FlyoutButtonMagePort"],
    --         sub = 'magePort',
    --         advancedName = 'FlyoutBar',
    --         options = magePortOptions,
    --         extra = magePortOptionsEditmode,
    --         -- parentExtra = TargetFrame,
    --         default = function()
    --             setDefaultSubValues('Mage')
    --         end,
    --         moduleRef = self
    --     });
    -- end

    -- -- mage portals
    -- do
    --     EditModeModule:AddEditModeToFrame(Module.MagePortalsButton)

    --     Module.MagePortalsButton.DFEditModeSelection:SetGetLabelTextFunction(function()
    --         return L["FlyoutButtonMagePortals"]
    --     end)

    --     Module.MagePortalsButton.DFEditModeSelection:RegisterOptions({
    --         name = L["FlyoutButtonMagePortals"],
    --         sub = 'magePortals',
    --         advancedName = 'FlyoutBar',
    --         options = magePortalOptions,
    --         extra = magePortalOptionsEditmode,
    --         -- parentExtra = TargetFrame,
    --         default = function()
    --             setDefaultSubValues('magePortals')
    --         end,
    --         moduleRef = self
    --     });
    -- end

    -- if DF.API.Version.IsClassic then
    --     -- mage food
    --     do
    --         EditModeModule:AddEditModeToFrame(Module.MageFoodButton)

    --         Module.MageFoodButton.DFEditModeSelection:SetGetLabelTextFunction(function()
    --             return L["FlyoutButtonMageFood"]
    --         end)

    --         Module.MageFoodButton.DFEditModeSelection:RegisterOptions({
    --             name = L["FlyoutButtonMageFood"],
    --             sub = 'mageFood',
    --             advancedName = 'FlyoutBar',
    --             options = mageFoodOptions,
    --             extra = mageFoodOptionsEditmode,
    --             -- parentExtra = TargetFrame,
    --             default = function()
    --                 setDefaultSubValues('mageFood')
    --             end,
    --             moduleRef = self
    --         });
    --     end

    --     -- mage water
    --     do
    --         EditModeModule:AddEditModeToFrame(Module.MageWaterButton)

    --         Module.MageWaterButton.DFEditModeSelection:SetGetLabelTextFunction(function()
    --             return L["FlyoutButtonMageWater"]
    --         end)

    --         Module.MageWaterButton.DFEditModeSelection:RegisterOptions({
    --             name = L["FlyoutButtonMageWater"],
    --             sub = 'mageWater',
    --             advancedName = 'FlyoutBar',
    --             options = mageWaterOptions,
    --             extra = mageWaterOptionsEditmode,
    --             -- parentExtra = TargetFrame,
    --             default = function()
    --                 setDefaultSubValues('mageWater')
    --             end,
    --             moduleRef = self
    --         });
    --     end
    -- end

    for i = 1, numCustomButtons do
        --   
        local n = string.format(L["FlyoutCustomNameFormat"], i);
        local sub = 'custom' .. i;

        local btn = Module['Custom' .. i .. 'Button']
        EditModeModule:AddEditModeToFrame(btn)

        btn.DFEditModeSelection:SetGetLabelTextFunction(function()
            return n
        end)

        btn.DFEditModeSelection:RegisterOptions({
            name = n,
            sub = sub,
            advancedName = 'FlyoutBar',
            options = customOptionsTable[i],
            extra = customOptionsTableEditmode[i],
            -- parentExtra = TargetFrame,
            default = function()
                setDefaultSubValues(sub)
            end,
            moduleRef = self
        });
    end
end

function Module:GetActionTable()
    -- return Module.db.profile.actions.actionTable;
    return Module.db.char.actions.actionTable;
end

function Module:GetAction(index)
    local t = self:GetActionTable()

    return t[index] or nil;
end

function Module:SetAction(index, type, value)
    -- print('SetAction', index, type, value)
    local t = self:GetActionTable()
    if type and value then
        t[index] = {type = type, value = value};
    else
        t[index] = nil;
    end
end

function Module:HookCollections()
    hooksecurefunc(C_MountJournal, 'Pickup', function(index)
        local name, spellID, icon, isActive, isUsable, sourceType, isFavorite, isFactionSpecific, faction,
              shouldHideOnChar, isCollected, mountID, isSteadyFlight = C_MountJournal.GetDisplayedMountInfo(index)
        DF:Debug(self, 'C_MountJournal Pickup():', name, spellID, mountID)
        -- self:Print('C_MountJournal Pickup():', name, spellID, mountID)

        Module.CursorMountID = mountID;
        Module.CursorMountSpellID = spellID;
    end)

    hooksecurefunc(GameTooltip, 'SetAction', function(tt, slot)
        -- print('SetAction', slot)
        if not slot or slot < 1 or slot > 1000 then return end

        local actionType, id, subType = GetActionInfo(slot)
        if actionType == 'companion' and subType == 'MOUNT' then
            Module.PreCursorMountID = C_MountJournal.GetMountFromSpell(id);
            Module.PreCursorMountSpellID = id;
        end
    end)

    hooksecurefunc(_G, 'PickupAction', function(slot)
        DF:Debug(self, 'PickupAction(slot):', slot)
        -- self:Print('PickupAction(slot):', slot)

        --
        Module.CursorMountID = Module.PreCursorMountID;
        Module.CursorMountSpellID = Module.PreCursorMountSpellID;
        DF:Debug(self, '~picked up:', Module.PreCursorMountID, Module.PreCursorMountSpellID)
        -- self:Print('~picked up:', Module.PreCursorMountID, Module.PreCursorMountSpellID)
    end)
end

function Module:AddClassDefaults()
    DF:Debug(self, 'AddClassDefaults()')

    local localizedClass, englishClass, classIndex = UnitClass('player')

    if englishClass == 'MAGE' then
        local englishFaction, localizedFaction = UnitFactionGroup('player')

        if englishFaction then englishClass = englishClass .. '_' .. englishFaction:upper() end
        -- englishClass = 'MAGE_HORDE'
    end

    if not classDefaults[englishClass] then
        DF:Debug(self, '~no defaults for class')
        return
    end

    -- self.db.char.initialized = false;

    if self.db.char.initialized then
        DF:Debug(self, '~already initialized')
        return
    else
        DF:Debug(self, '~>initialize defaults')
        local template = classDefaults[englishClass]
        local db = self.db.char;

        for flyout, options in pairs(template) do
            -- print(flyout)
            -- DevTools_Dump({options})
            local flyoutTable = db['custom' .. flyout]

            local baseID = 5 + flyout - 1

            for k, v in pairs(options) do
                if k ~= 'spells' then
                    flyoutTable[k] = v;
                else
                    local index = 0;
                    for i, spell in ipairs(v) do
                        local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon =
                            GetSpellInfo(spell)
                        if name then
                            -- print(name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon)
                            local actionID = baseID * 12 + i;
                            -- print('actionID', actionID, Module:GetAction(actionID))
                            Module:SetAction(actionID, 'spell', spell)
                            index = index + 1;
                        end
                    end
                    -- print('~~~>>', index)
                    flyoutTable['buttons'] = index
                end
            end
        end

        self.db.char.initialized = true;
    end
end

function Module:AddWarlockButton()
    local btn = CreateFrame("Button", "DragonflightUISpellFlyout" .. "Warlock" .. "Button", UIParent,
                            "DFSpellFlyoutButtonTemplate", 1000 + 1)
    Module.WarlockButton = btn;
end

function Module:AddMageButtons()
    local port = CreateFrame("Button", "DragonflightUISpellFlyout" .. "MagePort" .. "Button", UIParent,
                             "DFSpellFlyoutButtonTemplate", 1000 + 2)
    Module.MagePortButton = port;

    local portals = CreateFrame("Button", "DragonflightUISpellFlyout" .. "MagePortals" .. "Button", UIParent,
                                "DFSpellFlyoutButtonTemplate", 1000 + 3)
    Module.MagePortalsButton = portals;

    if DF.API.Version.IsClassic then
        local food = CreateFrame("Button", "DragonflightUISpellFlyout" .. "MageFood" .. "Button", UIParent,
                                 "DFSpellFlyoutButtonTemplate", 1000 + 4)
        Module.MageFoodButton = food;

        local water = CreateFrame("Button", "DragonflightUISpellFlyout" .. "MageWater" .. "Button", UIParent,
                                  "DFSpellFlyoutButtonTemplate", 1000 + 5)
        Module.MageWaterButton = water;
    end
end

function Module:AddCustomButtons()
    for i = 1, numCustomButtons do
        --
        local btn = CreateFrame("Button", "DragonflightUISpellFlyout" .. "Custom" .. i .. "Button", UIParent,
                                "DFSpellFlyoutButtonTemplate", 1000 + 5 + i)
        Module['Custom' .. i .. 'Button'] = btn;
    end

    _G['DragonflightUIQuickKeybindFrame']:HookCustomFlyoutButtons()
end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1, arg2, arg3)
    -- print('event', event) 
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module:Era()
    Module:HookCollections()

    -- Module:AddWarlockButton()
    -- Module:AddMageButtons()
    Module:AddCustomButtons()
end

function Module:TBC()
end

function Module:Wrath()
    Module:Era()
end

function Module:Cata()
    Module:Era()
end

function Module:Mists()
    Module:Era()
end
