local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'ObjectiveTracker'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        scale = 1,
        general = {
            -- scale = 1.0,
            -- anchorFrame = 'UIParent',
            -- anchor = 'BOTTOMRIGHT',
            -- anchorParent = 'BOTTOMRIGHT',
            -- x = -30,
            -- y = 120,
            -- -- mouseanchor
            -- anchorToMouse = false,
            -- mouseAnchor = 'ANCHOR_CURSOR_RIGHT',
            -- mouseX = 16,
            -- mouseY = 8,
            -- -- backdrop
            -- backdropAlpha = 0.2,
            -- -- gametooltip

            -- -- statusbar
            -- statusbarHeight = 9,
            -- -- spell
            -- anchorSpells = true,
            -- showSpellID = true,
            -- showSpellSource = true,
            -- showSpellIconID = false,
            -- showSpellIcon = true,
            -- showStealable = false,
            -- -- item
            -- showItemQuality = true,
            -- showItemQualityBackdrop = false,
            -- showItemStackCount = false,
            -- showItemID = false,
            -- showItemIconID = false,
            -- -- unit
            -- unitClassBorder = true,
            -- unitClassBackdrop = false,
            -- unitHealthbar = true,
            -- unitHealthbarText = true,
            -- unitReactionBorder = true,
            -- unitReactionBackdrop = false,
            -- unitClassName = true,
            -- unitTitle = true,
            -- unitRealm = true,
            -- unitGuild = true,
            -- unitGuildRank = true,
            -- unitGuildRankIndex = false,
            -- unitGrayoutOnDeath = true,
            -- unitZone = 'onlydifferent'
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
local mouseAnchorTable = {
    {value = 'ANCHOR_CURSOR_RIGHT', text = 'Cursor Right', tooltip = 'descr', label = 'label'},
    {value = 'ANCHOR_CURSOR_LEFT', text = 'Cursor Left', tooltip = 'descr', label = 'label'}
}
local zoneTable = {
    {value = 'always', text = 'Always', tooltip = 'descr', label = 'label'},
    {value = 'never', text = 'Never', tooltip = 'descr', label = 'label'},
    {value = 'onlydifferent', text = 'Only Different Zone', tooltip = 'descr', label = 'label'}
}

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

local generalOptions = {
    type = 'group',
    name = 'GameTooltip',
    get = getOption,
    set = setOption,
    args = {
        -- headerGameTooltip = {
        --     type = 'header',
        --     name = L["TooltipHeaderGameToltip"],
        --     desc = L["TooltipHeaderGameToltip"],
        --     order = 1,
        --     isExpanded = true,
        --     editmode = true,
        --     sortComparator = DFSettingsListMixin.AlphaSortComparator
        -- },
        headerMouseAnchor = {
            type = 'header',
            name = L["TooltipCursorAnchorHeader"],
            desc = L["TooltipCursorAnchorHeaderDesc"],
            order = 1,
            isExpanded = true,
            editmode = true,
            sortComparator = DFSettingsListMixin.OrderSortComparator
        },
        anchorToMouse = {
            type = 'toggle',
            name = L["TooltipAnchorToMouse"],
            desc = L["TooltipAnchorToMouseDesc"] .. getDefaultStr('anchorToMouse', 'general'),
            order = 1,
            editmode = true,
            group = 'headerMouseAnchor'
        },
        mouseAnchor = {
            type = 'select',
            name = L["PositionTableAnchor"],
            desc = L["PositionTableAnchorDesc"] .. getDefaultStr('mouseAnchor', 'general'),
            dropdownValues = mouseAnchorTable,
            order = 2,
            group = 'headerMouseAnchor',
            editmode = true
        },
        mouseX = {
            type = 'range',
            name = L["TooltipMouseX"],
            desc = L["TooltipMouseXDesc"] .. getDefaultStr('mouseX', 'general'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5,
            group = 'headerMouseAnchor',
            editmode = true
        },
        mouseY = {
            type = 'range',
            name = L["TooltipMouseY"],
            desc = L["TooltipMouseYDesc"] .. getDefaultStr('mouseY', 'general'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6,
            group = 'headerMouseAnchor',
            editmode = true
        },
        -- Spelltooltip
        headerSpellTooltip = {
            type = 'header',
            name = L["TooltipHeaderSpellTooltip"],
            desc = L["TooltipHeaderSpellTooltip"],
            order = 2,
            isExpanded = true,
            editmode = true,
            sortComparator = DFSettingsListMixin.AlphaSortComparator
        },
        anchorSpells = {
            type = 'toggle',
            name = L["TooltipAnchorSpells"],
            desc = L["TooltipAnchorSpellsDesc"] .. getDefaultStr('anchorSpells', 'general'),
            order = 1,
            editmode = true,
            group = 'headerSpellTooltip'
        },
        showSpellID = {
            type = 'toggle',
            name = L["TooltipShowSpellID"],
            desc = L["TooltipShowSpellIDDesc"] .. getDefaultStr('showSpellID', 'general'),
            order = 1,
            editmode = true,
            group = 'headerSpellTooltip'
        },
        showSpellSource = {
            type = 'toggle',
            name = L["TooltipShowSpellSource"],
            desc = L["TooltipShowSpellSourceDesc"] .. getDefaultStr('showSpellSource', 'general'),
            order = 1,
            editmode = true,
            group = 'headerSpellTooltip'
        },
        showSpellIconID = {
            type = 'toggle',
            name = L["TooltipShowIconID"],
            desc = L["TooltipShowIconIDDesc"] .. getDefaultStr('showSpellIconID', 'general'),
            order = 1,
            editmode = true,
            group = 'headerSpellTooltip'
        },
        showSpellIcon = {
            type = 'toggle',
            name = L["TooltipShowSpellIcon"],
            desc = L["TooltipShowSpellIconDesc"] .. getDefaultStr('showSpellIcon', 'general'),
            order = 1,
            editmode = true,
            group = 'headerSpellTooltip'
        },
        -- Itemtooltip
        headerItemTooltip = {
            type = 'header',
            name = L["TooltipHeaderItemTooltip"],
            desc = L["TooltipHeaderItemTooltipDesc"],
            order = 3,
            isExpanded = true,
            editmode = true,
            sortComparator = DFSettingsListMixin.AlphaSortComparator
        },
        showItemQuality = {
            type = 'toggle',
            name = L["TooltipShowItemQuality"],
            desc = L["TooltipShowItemQualityDesc"] .. getDefaultStr('showItemQuality', 'general'),
            order = 1,
            editmode = true,
            group = 'headerItemTooltip'
        },
        showItemQualityBackdrop = {
            type = 'toggle',
            name = L["TooltipShowItemQualityBackdrop"],
            desc = L["TooltipShowItemQualityBackdropDesc"] .. getDefaultStr('showItemQualityBackdrop', 'general'),
            order = 1,
            editmode = true,
            group = 'headerItemTooltip'
        },
        showItemStackCount = {
            type = 'toggle',
            name = L["TooltipShowItemStackCount"],
            desc = L["TooltipShowItemStackCountDesc"] .. getDefaultStr('showItemStackCount', 'general'),
            order = 1,
            editmode = true,
            group = 'headerItemTooltip'
        },
        showItemID = {
            type = 'toggle',
            name = L["TooltipShowItemID"],
            desc = L["TooltipShowItemIDDesc"] .. getDefaultStr('showItemID', 'general'),
            order = 1,
            editmode = true,
            group = 'headerItemTooltip'
        },
        showItemIconID = {
            type = 'toggle',
            name = L["TooltipShowIconID"],
            desc = L["TooltipShowIconIDDesc"] .. getDefaultStr('showItemIconID', 'general'),
            order = 1,
            editmode = true,
            group = 'headerItemTooltip'
        },
        -- UnitTooltip
        headerUnitTooltip = {
            type = 'header',
            name = L["TooltipUnitTooltip"],
            desc = L["TooltipUnitTooltipDesc"],
            order = 4,
            isExpanded = true,
            editmode = true,
            sortComparator = DFSettingsListMixin.AlphaSortComparator
        },
        unitClassBorder = {
            type = 'toggle',
            name = L["TooltipUnitClassBorder"],
            desc = L["TooltipUnitClassBorderDesc"] .. getDefaultStr('unitClassBorder', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitClassBackdrop = {
            type = 'toggle',
            name = L["TooltipUnitClassBackdrop"],
            desc = L["TooltipUnitClassBackdropDesc"] .. getDefaultStr('unitClassBackdrop', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitReactionBorder = {
            type = 'toggle',
            name = L["TooltipUnitReactionBorder"],
            desc = L["TooltipUnitReactionBorderDesc"] .. getDefaultStr('unitReactionBorder', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitReactionBackdrop = {
            type = 'toggle',
            name = L["TooltipUnitReactionBackdrop"],
            desc = L["TooltipUnitReactionBackdropDesc"] .. getDefaultStr('unitReactionBackdrop', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitClassName = {
            type = 'toggle',
            name = L["TooltipUnitClassName"],
            desc = L["TooltipUnitClassNameDesc"] .. getDefaultStr('unitClassName', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitTitle = {
            type = 'toggle',
            name = L["TooltipUnitTitle"],
            desc = L["TooltipUnitTitleDesc"] .. getDefaultStr('unitTitle', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitRealm = {
            type = 'toggle',
            name = L["TooltipUnitRealm"],
            desc = L["TooltipUnitRealmDesc"] .. getDefaultStr('unitRealm', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitGuild = {
            type = 'toggle',
            name = L["TooltipUnitGuild"],
            desc = L["TooltipUnitGuildDesc"] .. getDefaultStr('unitGuild', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitGuildRank = {
            type = 'toggle',
            name = L["TooltipUnitGuildRank"],
            desc = L["TooltipUnitGuildRankDesc"] .. getDefaultStr('unitGuildRank', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitGuildRankIndex = {
            type = 'toggle',
            name = L["TooltipUnitGuildRankIndex"],
            desc = L["TooltipUnitGuildRankIndexDesc"] .. getDefaultStr('unitGuildRankIndex', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitGrayoutOnDeath = {
            type = 'toggle',
            name = L["TooltipUnitGrayOutOnDeath"],
            desc = L["TooltipUnitGrayOutOnDeathDesc"] .. getDefaultStr('unitGrayoutOnDeath', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitZone = {
            type = 'select',
            name = L["TooltipUnitZone"],
            desc = L["TooltipUnitZoneDesc"] .. getDefaultStr('unitZone', 'general'),
            dropdownValues = zoneTable,
            order = 2,
            group = 'headerUnitTooltip',
            editmode = true
        },
        unitHealthbar = {
            type = 'toggle',
            name = L["TooltipUnitHealthbar"],
            desc = L["TooltipUnitHealthbarDesc"] .. getDefaultStr('unitHealthbar', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitHealthbarText = {
            type = 'toggle',
            name = L["TooltipUnitHealthbarText"],
            desc = L["TooltipUnitHealthbarTextDesc"] .. getDefaultStr('unitHealthbarText', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        }
    }
}
DF.Settings:AddPositionTable(Module, generalOptions, 'general', 'GameTooltip', getDefaultStr, frameTable)

local optionsGeneralEditmode = {
    name = 'party',
    desc = 'party',
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
                local dbTable = Module.db.profile.general
                local defaultsTable = defaults.profile.general
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y,
                    orientation = defaultsTable.orientation,
                    padding = defaultsTable.padding
                })
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
    hooksecurefunc(DF:GetModule('Config'), 'AddConfigFrame', function()
        Module:RegisterSettings()
    end)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    DF:RegisterModuleOptions(mName, generalOptions)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    if DF.Cata then
        Module.Cata()
    elseif DF.Wrath then
        Module.Wrath()
    else
        Module.Era()
    end

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
    -- local moduleName = 'Tooltip'
    -- local cat = 'misc'
    -- local function register(name, data)
    --     data.module = moduleName;
    --     DF.ConfigModule:RegisterSettingsElement(name, cat, data, true)
    -- end

    -- register('tooltip', {order = 0, name = 'Tooltip', descr = '...', isNew = true})
end

function Module:RegisterOptionScreens()
    -- DF.ConfigModule:RegisterSettingsData('tooltip', 'misc', {
    --     name = 'Tooltip',
    --     sub = 'general',
    --     options = generalOptions,
    --     sortComparator = generalOptions.sortComparator,
    --     default = function()
    --         setDefaultSubValues('general')
    --     end
    -- })
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    -- local configFrame = DF.ConfigModule.ConfigFrame
    -- local cat = 'Misc'
    -- configFrame:RefreshCatSub(cat, 'Tooltip')

    -- Module.GametooltipPreview.DFEditModeSelection:RefreshOptionScreen();
end

function Module:ApplySettings(sub)
    local db = Module.db.profile
    local state = db.general

    -- local parent = _G[state.anchorFrame]

    -- Module.GametooltipPreview:ClearAllPoints()
    -- Module.GametooltipPreview:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    -- Module.GametooltipPreview:SetScale(state.scale)
end

function Module:AddEditMode()
    -- local EditModeModule = DF:GetModule('Editmode');

    -- local f = CreateFrame('FRAME', 'DragonflightUIGameTooltipPreviewFrame', UIParent)
    -- f:SetSize(250, 90)

    -- Module.GametooltipPreview = f;

    -- EditModeModule:AddEditModeToFrame(f)

    -- f.DFEditModeSelection:SetGetLabelTextFunction(function()
    --     return 'Tooltip Anchor'
    -- end)

    -- f.DFEditModeSelection:RegisterOptions({
    --     name = 'GameTooltip',
    --     sub = 'general',
    --     advancedName = 'GameTooltip',
    --     options = generalOptions,
    --     extra = optionsGeneralEditmode,
    --     -- parentExtra = TargetFrame,
    --     default = function()
    --         setDefaultSubValues('general')
    --     end,
    --     moduleRef = self
    --     -- showFunction = function()
    --     --     --
    --     --     -- TargetFrame.unit = 'player';
    --     --     -- TargetFrame_Update(TargetFrame);
    --     --     -- TargetFrame:Show()
    --     --     TargetFrame:SetAlpha(0)
    --     -- end,
    --     -- hideFunction = function()
    --     --     --        
    --     --     -- TargetFrame.unit = 'target';
    --     --     -- TargetFrame_Update(TargetFrame);
    --     --     TargetFrame:SetAlpha(1)
    --     -- end
    -- });
end

function Module:CreateTracker()
    local t = CreateFrame('Frame', 'DragonflightUIObjectiveTracker', UIParent, 'DragonflightUIObjectiveTracker')
    t:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1, arg2, arg3)
    -- print('event', event) 
    if event == 'MINIMAP_PING' then
    elseif event == 'MINIMAP_UPDATE_TRACKING' then
    end
end
frame:SetScript('OnEvent', frame.OnEvent)

-- Cata
function Module.Cata()
    Module.Era()
end

-- Wrath
function Module.Wrath()
    Module.Era()
end

-- Era
function Module.Era()
    Module:CreateTracker()
end
