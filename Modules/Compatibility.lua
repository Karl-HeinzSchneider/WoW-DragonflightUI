local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Compatibility'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {profile = {scale = 1, general = {auctionator = true, baganator = true}}}
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

local compatOptions = {
    type = 'group',
    name = L["CompatName"],
    get = getOption,
    set = setOption,
    sortComparator = DFSettingsListMixin.AlphaSortComparator,
    args = {
        auctionator = {
            type = 'toggle',
            name = L["CompatAuctionator"],
            desc = L["CompatAuctionatorDesc"] .. getDefaultStr('auctionator', 'general'),
            order = 21
        },
        baganator = {
            type = 'toggle',
            name = L["CompatBaganator"],
            desc = L["CompatBaganatorDesc"] .. getDefaultStr('baganator', 'general'),
            order = 21
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

    DF:RegisterModuleOptions(mName, compatOptions)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    -- if DF.Cata then
    --     Module.Cata()
    -- elseif DF.Wrath then
    --     Module.Wrath()
    -- else
    --     Module.Era()
    -- end

    -- Module:AddEditMode()

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
    local moduleName = 'Compatibility'
    local cat = 'general'
    local function register(name, data)
        data.module = moduleName;
        DF.ConfigModule:RegisterSettingsElement(name, cat, data, true)
    end

    register('compatibility', {order = 0, name = 'Compatibility', descr = '...', isNew = true})
end

function Module:RegisterOptionScreens()
    DF.ConfigModule:RegisterSettingsData('compatibility', 'general', {
        name = L['CompatName'],
        sub = 'general',
        options = compatOptions,
        sortComparator = compatOptions.sortComparator,
        default = function()
            setDefaultSubValues('general')
        end
    })
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

    self:ConditionalOption('auctionator', 'general', L['CompatAuctionator'], function()
        if _G['DragonflightUIProfessionFrame'] then
            DF.Compatibility:FuncOrWaitframe('Auctionator', DF.Compatibility.AuctionatorCraftingInfoFrame)
        else
            DF.API.Modules:HookModuleFunction('UI', 'UpdateTradeskills', function(m, state)
                DF.Compatibility:FuncOrWaitframe('Auctionator', DF.Compatibility.AuctionatorCraftingInfoFrame)
            end)
        end
    end)

    self:ConditionalOption('baganator', 'general', L['CompatBaganator'], function()
        DF.Compatibility:FuncOrWaitframe('Baganator', DF.Compatibility.Baganator)
    end)

end

