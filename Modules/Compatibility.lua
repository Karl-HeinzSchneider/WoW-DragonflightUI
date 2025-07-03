local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Compatibility'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        scale = 1,
        general = {
            auctionator = true,
            baganator = true,
            baganatorEquipment = true,
            characterstatsclassic = true,
            classicalendar = true,
            clique = true,
            lfgbulletinboard = true,
            merinspect = true,
            ranker = true,
            tacotip = true,
            tdinspect = true,
            whatstraining = true
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
        },
        characterstatsclassic = {
            type = 'toggle',
            name = L["CompatCharacterStatsClassic"],
            desc = L["CompatCharacterStatsClassicDesc"] .. getDefaultStr('characterstatsclassic', 'general'),
            order = 21
        },
        classicalendar = {
            type = 'toggle',
            name = L["CompatClassicCalendar"],
            desc = L["CompatClassicCalendarDesc"] .. getDefaultStr('classicalendar', 'general'),
            order = 21
        },
        clique = {
            type = 'toggle',
            name = L["CompatClique"],
            desc = L["CompatCliqueDesc"] .. getDefaultStr('clique', 'general'),
            order = 21
        },
        lfgbulletinboard = {
            type = 'toggle',
            name = L["CompatLFGBulletinBoard"],
            desc = L["CompatLFGBulletinBoardDesc"] .. getDefaultStr('lfgbulletinboard', 'general'),
            order = 21
        },
        merinspect = {
            type = 'toggle',
            name = L["CompatMerInspect"],
            desc = L["CompatMerInspectDesc"] .. getDefaultStr('merinspect', 'general'),
            order = 21
        },
        ranker = {
            type = 'toggle',
            name = L["CompatRanker"],
            desc = L["CompatRankerDesc"] .. getDefaultStr('ranker', 'general'),
            order = 21
        },
        tacotip = {
            type = 'toggle',
            name = L["CompatTacoTip"],
            desc = L["CompatTacoTipDesc"] .. getDefaultStr('tacotip', 'general'),
            order = 21
        },
        tdinspect = {
            type = 'toggle',
            name = L["CompatTDInspect"],
            desc = L["CompatTDInspectDesc"] .. getDefaultStr('tdinspect', 'general'),
            order = 21
        },
        whatstraining = {
            type = 'toggle',
            name = L["CompatWhatsTraining"],
            desc = L["CompatWhatsTrainingDesc"] .. getDefaultStr('whatstraining', 'general'),
            order = 21
        }
    }
}

if DF.API.Version.IsClassic then
    compatOptions.args.baganatorEquipment = {
        type = 'toggle',
        name = L["CompatBaganatorEquipment"],
        desc = L["CompatBaganatorEquipmentDesc"] .. getDefaultStr('baganatorEquipment', 'general'),
        order = 21
    }
end

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

    -- self:EnableAddonSpecific()

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

    local MinimapModule = DF.API.Modules:GetModule('Minimap')
    local UIModule = DF.API.Modules:GetModule('UI')

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

    self:ConditionalOption('baganatorEquipment', 'general', L['CompatBaganatorEquipment'], function()
        DF.Compatibility:FuncOrWaitframe('Baganator', DF.Compatibility.BaganatorEquipment)
    end)

    -- self:ConditionalOption('characterstatsclassic', 'general', L['CompatCharacterStatsClassic'], function()
    --     DF.API.Modules:HookEnableModule('UI', function(m)
    --         if m['changeCharacterframe' .. 'Hooked'] then
    --             Module:FuncOrWaitframe('CharacterStatsClassic', function()
    --                 DF.Compatibility:CharacterStatsClassic()
    --             end)
    --         else
    --             DF.API.Modules:HookModuleFunction('UI', 'ApplySettings', function()
    --                 if m['changeCharacterframe' .. 'Hooked'] and not Module['characterstatsclassic' .. 'Func'] then
    --                     Module['characterstatsclassic' .. 'Func'] = true
    --                     Module:FuncOrWaitframe('CharacterStatsClassic', function()
    --                         DF.Compatibility:CharacterStatsClassic()
    --                     end)
    --                 end
    --             end)
    --         end
    --     end)
    -- end)_G['DragonflightUIProfessionFrame'] 

    self:ConditionalOption('characterstatsclassic', 'general', L['CompatCharacterStatsClassic'], function()
        if UIModule['changeCharacterframe' .. 'Hooked'] then
            Module:FuncOrWaitframe('CharacterStatsClassic', DF.Compatibility.CharacterStatsClassic)
        else
            hooksecurefunc(DragonflightUIMixin, 'ChangeCharacterFrameEra', function()
                Module:FuncOrWaitframe('CharacterStatsClassic', DF.Compatibility.CharacterStatsClassic)
            end)
        end
    end)

    self:ConditionalOption('classicalendar', 'general', L['CompatClassicCalendar'], function()
        DF.API.Modules:HookEnableModule('Minimap', function(m)
            Module:FuncOrWaitframe('ClassicCalendar', DF.Compatibility.ClassicCalendarEra)
        end)
    end)

    self:ConditionalOption('clique', 'general', L['CompatClique'], function()
        DF.API.Modules:HookEnableModule('Unitframe', function(m)
            Module:FuncOrWaitframe('Clique', DF.Compatibility.Clique)
        end)
    end)

    self:ConditionalOption('lfgbulletinboard', 'general', L['CompatLFGBulletinBoard'], function()
        if MinimapModule['skinButtons' .. 'Hooked'] then
            Module:FuncOrWaitframe('LFGBulletinBoard', function()
                --
                DF.Compatibility:LFGBulletinBoard(MinimapModule.UpdateButton)
            end)
        else
            DF.API.Modules:HookModuleFunction('Minimap', 'ChangeMinimapButtons', function()
                if MinimapModule['skinButtons' .. 'Hooked'] and not Module['lfgbulletinboard' .. 'Func'] then
                    Module['lfgbulletinboard' .. 'Func'] = true
                    Module:FuncOrWaitframe('LFGBulletinBoard', function()
                        --
                        DF.Compatibility:LFGBulletinBoard(MinimapModule.UpdateButton)
                    end)
                end
            end)
        end
    end)

    self:ConditionalOption('merinspect', 'general', L['CompatMerInspect'], function()
        if UIModule['changeCharacterframe' .. 'Hooked'] then
            -- on some sites it has a shorter name, but seems to be the same addon
            Module:FuncOrWaitframe('MerInspect', DF.Compatibility.MerInspect)
            Module:FuncOrWaitframe('MerInspect-classic-era', DF.Compatibility.MerInspectClassicEra)
        else
            DF.API.Modules:HookModuleFunction('UI', 'ApplySettings', function()
                if UIModule['changeCharacterframe' .. 'Hooked'] and not Module['merinspect' .. 'Func'] then
                    Module['merinspect' .. 'Func'] = true
                    Module:FuncOrWaitframe('MerInspect', DF.Compatibility.MerInspect)
                    Module:FuncOrWaitframe('MerInspect-classic-era', DF.Compatibility.MerInspectClassicEra)
                end
            end)
        end
    end)

    self:ConditionalOption('ranker', 'general', L['CompatRanker'], function()
        -- if UIModule['changeCharacterframe' .. 'Hooked'] then
        --     Module:FuncOrWaitframe('tdInspect', DF.Compatibility.TDInspect)
        -- else
        --     DF.API.Modules:HookModuleFunction('UI', 'ApplySettings', function()
        --         if UIModule['changeCharacterframe' .. 'Hooked'] and not Module['tdinspect' .. 'Func'] then
        --             Module['tdinspect' .. 'Func'] = true
        --             Module:FuncOrWaitframe('tdInspect', DF.Compatibility.TDInspect)
        --         end
        --     end)
        -- end
    end)

    self:ConditionalOption('tacotip', 'general', L['CompatTacoTip'], function()
        if UIModule['changeCharacterframe' .. 'Hooked'] then
            Module:FuncOrWaitframe('TacoTip', DF.Compatibility.TacoTipCharacter)
        else
            DF.API.Modules:HookModuleFunction('UI', 'ApplySettings', function()
                if UIModule['changeCharacterframe' .. 'Hooked'] and not Module['tacotip' .. 'Func'] then
                    Module['tacotip' .. 'Func'] = true
                    Module:FuncOrWaitframe('TacoTip', DF.Compatibility.TacoTipCharacter)
                end
            end)
        end
    end)

    self:ConditionalOption('tdinspect', 'general', L['CompatTDInspect'], function()
        if UIModule['changeCharacterframe' .. 'Hooked'] then
            Module:FuncOrWaitframe('tdInspect', DF.Compatibility.TDInspect)
        else
            DF.API.Modules:HookModuleFunction('UI', 'ApplySettings', function()
                if UIModule['changeCharacterframe' .. 'Hooked'] and not Module['tdinspect' .. 'Func'] then
                    Module['tdinspect' .. 'Func'] = true
                    Module:FuncOrWaitframe('tdInspect', DF.Compatibility.TDInspect)
                end
            end)
        end
    end)

    self:ConditionalOption('whatstraining', 'general', L['CompatWhatsTraining'], function()
        if UIModule['changeSpellBook' .. 'Hooked'] then
            Module:FuncOrWaitframe('WhatsTraining', DF.Compatibility.WhatsTraining)
        else
            hooksecurefunc(DragonflightUIMixin, 'ChangeSpellbookEra', function()
                Module:FuncOrWaitframe('WhatsTraining', DF.Compatibility.WhatsTraining)
            end)
        end
    end)

end

