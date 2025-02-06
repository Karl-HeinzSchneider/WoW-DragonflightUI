---@class DragonflightUI
---@diagnostic disable-next-line: assign-type-mismatch
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

local moduleOptions = {}
local options = {
    type = 'group',
    args = {
        info = {
            type = 'description',
            name = "Type '/df' or '/dragonflight' to open the (new) config window - or use the game menu button",
            fontSize = 'large',
            order = 420
        },
        unlock = {
            type = 'execute',
            name = 'Open config window',
            desc = 'Opens the Dragonflight UI config window',
            func = function()
                -- DF:Print('Dont press me, i do nothing!')
                ---@diagnostic disable-next-line: undefined-field
                local ConfigModule = DF:GetModule('Config')
                if ConfigModule then ConfigModule:ToggleConfigFrame() end
            end,
            order = 69
        }
    }
}

function DF:SetupOptions()
    self.optFrames = {}
    LibStub('AceConfigRegistry-3.0'):RegisterOptionsTable('DragonflightUI', options)
    self.optFrames['DragonflightUI'] = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('DragonflightUI',
                                                                                       'DragonflightUI')

    local profiles = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)
    profiles.order = 666

    DF.OptionTableProfiles = profiles
    LibStub('AceConfig-3.0'):RegisterOptionsTable('DragonflightUI_Profiles', profiles)
    local frame, name = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('DragonflightUI_Profiles', 'Profiles',
                                                                        'DragonflightUI')

    self:EnableProfileCallbacks(true)
    DF.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
    DF.db.RegisterCallback(self, "OnProfileCopied", "OnProfileCopied")
    DF.db.RegisterCallback(self, "OnProfileReset", "OnProfileReset")
end

function DF:EnableProfileCallbacks(enabled)
    self.ProfileCallbacksEnabled = true;
end

function DF:OnProfileChanged(name)
    -- print("OnProfileChanged!", name)
    if not self.ProfileCallbacksEnabled then return end
    DF:RefreshConfig()
end

function DF:OnProfileCopied(name)
    -- print("OnProfileCopied!", name)
    if not self.ProfileCallbacksEnabled then return end
    DF:RefreshConfig()
end

function DF:OnProfileReset()
    -- print("OnProfileReset!")
    if not self.ProfileCallbacksEnabled then return end
    DF:RefreshConfig()
end

function DF:RefreshConfig()
    -- would do some stuff here
    -- print("RefreshConfig!")

    ---@diagnostic disable-next-line: undefined-field
    local configFrame = DF.ConfigModule.ConfigFrame
    local refreshCat = function(name)
        -- local subCat = configFrame:GetSubCategory('General', name)
        -- subCat.displayFrame:CallRefresh()
        configFrame:RefreshCatSub('General', name)
    end
    refreshCat('Profiles')
end

function DF:RegisterModuleOptions(name, options)
    -- self:Print('RegisterModuleOptions()', name, options)
    moduleOptions[name] = options
    -- function AceConfigDialog:AddToBlizOptions(appName, name, parent, ...)
    LibStub('AceConfigRegistry-3.0'):RegisterOptionsTable('DragonflightUI_' .. name, options)

    -- self.optFrames[name] = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('DragonflightUI_' .. name, name,
    --                                                                        'DragonflightUI')
end

function DF:RegisterSlashCommands()
    -- self:RegisterChatCommand('df', 'SlashCommand')
    -- self:RegisterChatCommand('dragonflight', 'SlashCommand')

    -- "default" quick reload command
    self:RegisterChatCommand('rl', 'ReloadCommand')
end

function DF:SlashCommand(msg)
    -- self:Print('Slash: ' .. msg)
    InterfaceOptionsFrame_OpenToCategory('DragonflightUI')
    InterfaceOptionsFrame_OpenToCategory('DragonflightUI')
end

function DF:ReloadCommand()
    ReloadUI()
end
