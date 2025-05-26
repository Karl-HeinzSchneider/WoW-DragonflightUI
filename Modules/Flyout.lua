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
            buttons = 5,
            padding = 2,
            -- flyout
            icon = 136082,
            displayName = L["FlyoutWarlock"],
            tooltip = L["FlyoutWarlockDesc"],
            flyoutDirection = 'TOP',
            spells = '688, 697, 712, 691, 1122',
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
            hideCustom = false,
            hideCustomCond = ''
        }
    }
}
Module:SetDefaults(defaults)

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

local frameTable = {{value = 'UIParent', text = 'UIParent', tooltip = 'descr', label = 'label'}}

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
        spells = {
            type = 'editbox',
            name = L["FlyoutSpells"],
            desc = L["FlyoutSpellsDesc"] .. getDefaultStr('spells', sub),
            Validate = function()
                return true
            end,
            order = 4.5,
            group = 'headerFlyout',
            editmode = true
        },
        spellsAlliance = {
            type = 'editbox',
            name = L["FlyoutSpellsAlliance"],
            desc = L["FlyoutSpellsAllianceDesc"] .. getDefaultStr('spellsAlliance', sub),
            Validate = function()
                return true
            end,
            order = 4.6,
            group = 'headerFlyout',
            editmode = true
        },
        spellsHorde = {
            type = 'editbox',
            name = L["FlyoutSpellsHorde"],
            desc = L["FlyoutSpellsHordeDesc"] .. getDefaultStr('spellsHorde', sub),
            Validate = function()
                return true
            end,
            order = 4.7,
            group = 'headerFlyout',
            editmode = true
        },
        items = {
            type = 'editbox',
            name = L["FlyoutItems"],
            desc = L["FlyoutItemsDesc"] .. getDefaultStr('items', sub),
            Validate = function()
                return true
            end,
            order = 4.8,
            group = 'headerFlyout',
            editmode = true
        },
        closeAfterClick = {
            type = 'toggle',
            name = L["FlyoutCloseAfterClick"],
            desc = L["FlyoutCloseAfterClickDesc"] .. getDefaultStr('closeAfterClick', sub),
            order = 5,
            group = 'headerFlyout',
            editmode = true
        },
        icon = {
            type = 'editbox',
            name = L["FlyoutIcon"],
            desc = L["FlyoutIconDesc"] .. getDefaultStr('icon', sub),
            Validate = function()
                return true
            end,
            order = 5.1,
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
            order = 5.2,
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
            order = 5.3,
            group = 'headerFlyout',
            editmode = true
        }
    }

    for k, v in pairs(extraOptions) do
        --
        optionTable.args[k] = v
    end
end

local warlockOptions = {
    name = 'Warlock',
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
DF.Settings:AddPositionTable(Module, warlockOptions, 'warlock', 'Warlock', getDefaultStr, frameTable)

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

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)
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

    register('warlock', {order = 0, name = 'Warlock', descr = '...', isNew = true})
    register('magePort', {order = 0, name = 'Mage Port', descr = '...', isNew = true})
    register('magePortals', {order = 0, name = 'Mage Portals', descr = '...', isNew = true})
end

function Module:RegisterOptionScreens()
    DF.ConfigModule:RegisterSettingsData('warlock', 'flyout', {
        name = 'Warlock',
        sub = 'warlock',
        options = warlockOptions,
        sortComparator = warlockOptions.sortComparator,
        default = function()
            setDefaultSubValues('warlock')
        end
    })
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame

    local refreshCat = function(name)
        configFrame:RefreshCatSub('Flyout', name)
    end

    refreshCat('warlock')

    Module.WarlockButton.DFEditModeSelection:RefreshOptionScreen();
end

function Module:ApplySettings(sub)
    local db = Module.db.profile

    Module.WarlockButton:SetState(db.warlock)

    -- local state = db.general

    -- local parent;
    -- if DF.Settings.ValidateFrame(state.customAnchorFrame) then
    --     parent = _G[state.customAnchorFrame]
    -- else
    --     parent = _G[state.anchorFrame]
    -- end

    -- Module.GametooltipPreview:ClearAllPoints()
    -- Module.GametooltipPreview:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    -- Module.GametooltipPreview:SetScale(state.scale)
end

function Module:AddEditMode()
    local EditModeModule = DF:GetModule('Editmode');

    -- local f = CreateFrame('FRAME', 'DragonflightUIGameTooltipPreviewFrame', UIParent)
    -- f:SetSize(250, 90)

    -- Module.GametooltipPreview = f;

    EditModeModule:AddEditModeToFrame(Module.WarlockButton)

    Module.WarlockButton.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'Warlock'
    end)

    Module.WarlockButton.DFEditModeSelection:RegisterOptions({
        name = 'Warlock',
        sub = 'warlock',
        advancedName = 'FlyoutBar',
        options = warlockOptions,
        extra = warlockOptionsEditmode,
        -- parentExtra = TargetFrame,
        default = function()
            setDefaultSubValues('warlock')
        end,
        moduleRef = self
        -- showFunction = function()
        --     --
        --     -- TargetFrame.unit = 'player';
        --     -- TargetFrame_Update(TargetFrame);
        --     -- TargetFrame:Show()
        --     TargetFrame:SetAlpha(0)
        -- end,
        -- hideFunction = function()
        --     --        
        --     -- TargetFrame.unit = 'target';
        --     -- TargetFrame_Update(TargetFrame);
        --     TargetFrame:SetAlpha(1)
        -- end
    });
end

function Module:AddWarlockButton()
    local btn = CreateFrame("Button", "DragonflightUISpellFlyout" .. "Warlock" .. "Button", UIParent,
                            "DFSpellFlyoutButtonTemplate")
    Module.WarlockButton = btn;
end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1, arg2, arg3)
    -- print('event', event) 
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module:Era()
    Module:AddWarlockButton()
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
