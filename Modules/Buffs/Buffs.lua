local addonName, addonTable = ...;
local Helper = addonTable.Helper;
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Buffs'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

Module.SubBuff = DF:CreateFrameFromMixinAndInit(addonTable.SubModuleMixins['Buff'])
Module.SubDebuff = DF:CreateFrameFromMixinAndInit(addonTable.SubModuleMixins['Debuff'])

local defaults = {profile = {scale = 1, buffs = Module.SubBuff.Defaults, debuffs = Module.SubDebuff.Defaults}}
Module:SetDefaults(defaults)

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

    self:EnableAddonSpecific()
    Module:ApplySettings()

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
    register('debuffs',
             {order = 1, name = Module.SubDebuff.Options.name, descr = Module.SubDebuff.Options.desc, isNew = false})
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame
    local cat = 'Misc'
    configFrame:RefreshCatSub(cat, 'Buffs')
    configFrame:RefreshCatSub(cat, 'Debuffs')

    Module.SubBuff.DFBuffFrame.DFEditModeSelection:RefreshOptionScreen();
    Module.SubDebuff.DFDebuffFrame.DFEditModeSelection:RefreshOptionScreen();
end

function Module:ApplySettings(sub, key)
    Helper:Benchmark(string.format('ApplySettings(%s,%s)', tostring(sub), tostring(key)), function()
        Module:ApplySettingsInternal(sub, key)
    end, 0, self)
end

function Module:ApplySettingsInternal(sub, key)
    local db = Module.db.profile

    Module.SubBuff:UpdateState(db.buffs)
    Module.SubDebuff:UpdateState(db.debuffs)
end

function Module:Era()
    Module.SubBuff:Setup()
    Module.SubDebuff:Setup()
end

function Module:TBC()
    Module.SubBuff:Setup()
    Module.SubDebuff:Setup()
end

function Module:Wrath()
    Module.SubBuff:Setup()
    Module.SubDebuff:Setup()
end

function Module:Cata()
    Module.SubBuff:Setup()
    Module.SubDebuff:Setup()
end

function Module:Mists()
    Module.SubBuff:Setup()
    Module.SubDebuff:Setup()
end
