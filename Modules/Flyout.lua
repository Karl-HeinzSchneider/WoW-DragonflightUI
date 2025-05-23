local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Flyout'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        scale = 1,
        warlock = {
            scale = 1,
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

local warlockOptions = {name = 'Warlock', desc = '...', get = getOption, set = setOption, type = 'group', args = {}}
-- AddButtonTable(warlockOptions, 'warlock')
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
    -- local moduleName = 'Tooltip'
    -- local cat = 'misc'
    -- local function register(name, data)
    --     data.module = moduleName;
    --     DF.ConfigModule:RegisterSettingsElement(name, cat, data, true)
    -- end

    -- register('tooltip', {order = 0, name = 'Tooltip', descr = '...', isNew = false})
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
    -- local db = Module.db.profile
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

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1, arg2, arg3)
    -- print('event', event) 
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module:Era()
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
