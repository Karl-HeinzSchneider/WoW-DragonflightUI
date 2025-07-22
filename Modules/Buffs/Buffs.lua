local addonName, addonTable = ...;
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Buffs'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

Module.SubBuff = DF:CreateFrameFromMixinAndInit(addonTable.SubModuleMixins['Buff'])

local defaults = {
    profile = {
        scale = 1,
        buffs = Module.SubBuff.Defaults,
        debuffs = {
            scale = 1,
            anchorFrame = 'MinimapCluster',
            customAnchorFrame = '',
            anchor = 'TOPRIGHT',
            anchorParent = 'TOPLEFT',
            x = -55,
            y = -13 - 110,
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
    name = 'Buffs',
    get = getOption,
    set = setOption,
    args = {
        -- scale = {
        --     type = 'range',
        --     name = 'Scale',
        --     desc = '' .. getDefaultStr('scale', 'minimap'),
        --     min = 0.1,
        --     max = 5,
        --     bigStep = 0.1,
        --     order = 1
        -- }    
    }
}

local frameTable = {
    {value = 'UIParent', text = 'UIParent', tooltip = 'descr', label = 'label'},
    {value = 'MinimapCluster', text = 'MinimapCluster', tooltip = 'descr', label = 'label'}
}

local debuffsOptions = {
    type = 'group',
    name = L["DebuffsOptionsName"],
    advancedName = 'Debuffs',
    sub = 'debuffs',
    get = getOption,
    set = setOption,
    args = {}
}
DF.Settings:AddPositionTable(Module, debuffsOptions, 'debuffs', 'Debuffs', getDefaultStr, frameTable)
DragonflightUIStateHandlerMixin:AddStateTable(Module, debuffsOptions, 'debuffs', 'Debuffs', getDefaultStr)
local optionsDebuffEditmode = {
    name = 'Debuff',
    desc = 'Debuff',
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
                local dbTable = Module.db.profile.debuffs
                local defaultsTable = defaults.profile.debuffs
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'debuffs')
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

    DF:RegisterModuleOptions(mName, generalOptions)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    self:EnableAddonSpecific()

    -- Module.AddStateUpdater()
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
    local moduleName = 'Buffs'
    local cat = 'misc'
    local function register(name, data)
        data.module = moduleName;
        DF.ConfigModule:RegisterSettingsElement(name, cat, data, true)
    end

    register('buffs',
             {order = 1, name = Module.SubBuff.Options.name, descr = Module.SubBuff.Options.desc, isNew = false})
    register('debuffs', {order = 1, name = debuffsOptions.name, descr = 'Debuffsss', isNew = false})
end

function Module:RegisterOptionScreens()
    DF.ConfigModule:RegisterSettingsData('debuffs', 'misc', {
        options = debuffsOptions,
        default = function()
            setDefaultSubValues(debuffsOptions.sub)
        end
    })
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame
    local cat = 'Misc'
    configFrame:RefreshCatSub(cat, 'Buffs')
    configFrame:RefreshCatSub(cat, 'Debuffs')

    -- Module.DFBuffFrame.DFEditModeSelection:RefreshOptionScreen();
    Module.DFDebuffFrame.DFEditModeSelection:RefreshOptionScreen();
end

function Module:ApplySettings(sub)
    local db = Module.db.profile

    Module.SubBuff:UpdateState(db.buffs)

    Module.UpdateDebuffState(db.debuffs)
end

function Module.AddStateUpdater()
    ---

    Mixin(Module.DFDebuffFrame, DragonflightUIStateHandlerMixin)
    Module.DFDebuffFrame:InitStateHandler(4, 4)
end

function Module:AddEditMode()
    local EditModeModule = DF:GetModule('Editmode');

    EditModeModule:AddEditModeToFrame(Module.DFDebuffFrame)

    Module.DFDebuffFrame.DFEditModeSelection:SetGetLabelTextFunction(function()
        return debuffsOptions.name
    end)

    Module.DFDebuffFrame.DFEditModeSelection:RegisterOptions({
        options = debuffsOptions,
        extra = optionsDebuffEditmode,
        default = function()
            setDefaultSubValues(buffsOptions.sub)
        end,
        moduleRef = self
    });
end

function Module.CreateDebuffFrame()
    local f = CreateFrame('FRAME', 'DragonflightUIDebuffFrame', UIParent)
    f:SetSize(30 + (10 - 1) * 35, 30 + (2 - 1) * 35)
    f:SetPoint('TOPRIGHT', MinimapCluster, 'TOPLEFT', -55, -13 - 110)
    f:SetClampedToScreen(true)
    Module.DFDebuffFrame = f
end

function Module.MoveDebuffs()
    local f = Module.DFDebuffFrame
    hooksecurefunc('DebuffButton_UpdateAnchors', function(buttonName, index)
        -- print('update', buttonName, index)

        local state = Module.db.profile.debuffs
        local buff = _G[buttonName .. index];
        buff:SetScale(state.scale or 1.0)
        buff:SetParent(f)
        -- buff:Show()

        if index ~= 1 then return end

        -- buff:SetPoint("TOPRIGHT", BuffFrame, "BOTTOMRIGHT", 0, -DebuffButton1.offsetY);
        buff:ClearAllPoints()
        buff:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0);
    end)
end

function Module.UpdateDebuffState(state)
    local f = Module.DFDebuffFrame

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    f:SetScale(state.scale)
    f:ClearAllPoints()
    f:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

    for i = 1, 12 do
        local buff = _G['DebuffButton' .. i];
        if buff then
            buff:SetScale(state.scale)
            buff:SetParent(f)
            -- buff:Show()
        end
    end

    if Module.StateHandlerAdded then f:UpdateStateHandler(state) end
end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1, arg2, arg3)
    -- print('event', event)    
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module:Era()
    Module.SubBuff:Setup()

    Module.CreateDebuffFrame()
    Module.MoveDebuffs()
end

function Module:TBC()
end

function Module:Wrath()
    Module.SubBuff:Setup()

    Module.CreateDebuffFrame()
    Module.MoveDebuffs()
end

function Module:Cata()
    Module.SubBuff:Setup()

    Module.CreateDebuffFrame()
    Module.MoveDebuffs()
end

function Module:Mists()
    Module.SubBuff:Setup()

    Module.CreateDebuffFrame()
    Module.MoveDebuffs()
end
