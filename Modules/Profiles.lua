local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Profiles'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {profile = {scale = 1, general = {toCopy = 'Default', toDelete = 'Default'}}}
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
    local key = info[1]

    if key == 'currentProfile' then
        --  
        return Module:GetCurrentProfile()
    end

    return Module:GetOption(info)
end

local function setOption(info, value)
    local key = info[1]

    if key == 'currentProfile' then
        --  
        Module:SetCurrentProfile(value)
    else
        Module:SetOption(info, value)
    end

    Module:RefreshOptionScreens()
end

local function GetProfileOptions()
    local generalOptions = {
        type = 'group',
        name = 'Profiles',
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

    return generalOptions
end

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    -- DF:RegisterModuleOptions(mName, generalOptions)
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

function Module:RegisterOptionScreens()
    StaticPopupDialogs['DragonflightUINewProfile'] = {
        text = 'Add New Profile',
        button1 = ACCEPT,
        button2 = CANCEL,
        OnShow = function(self, data)
            --
        end,
        OnAccept = function(self, data, data2)
            --
            local text = self.editBox:GetText()
            print(L["ProfilesChatNewProfile"] .. text)
            if text == '' or text == ' ' then
                Module:Print(L["ProfilesErrorNewProfile"])
            else
                Module:SetCurrentProfile(text)
            end
        end,
        hasEditBox = true
    }

    StaticPopupDialogs['DragonflightUIDeleteProfile'] = {
        text = 'Delete profile ..',
        button1 = ACCEPT,
        button2 = CANCEL,
        OnShow = function(self, data)
            local toDelete = getOption({'toDelete'})

            self.text:SetText(string.format(L["ProfilesDialogueDeleteProfile"], toDelete))
        end,
        OnAccept = function(self, data, data2)
            --         
            local toDelete = getOption({'toDelete'})

            Module:DeleteProfile(toDelete)
        end
    }

    StaticPopupDialogs['DragonflightUICopyProfile'] = {
        text = 'Copy profile ..',
        button1 = ACCEPT,
        button2 = CANCEL,
        OnShow = function(self, data)
            local toCopy = getOption({'toCopy'})

            self.text:SetText(string.format(L["ProfilesDialogueCopyProfile"], toCopy))
        end,
        OnAccept = function(self, data, data2)
            --         
            local toCopy = getOption({'toCopy'})

            Module:CopyProfile(toCopy)
        end
    }

    local options = {
        name = 'Profiles',
        get = getOption,
        set = setOption,
        args = {
            headerCurrentProfile = {type = 'header', name = 'Current Profile', order = 1},
            currentProfile = {
                type = 'select',
                name = 'Current Profile',
                desc = L["ProfilesSetActiveProfile"],
                -- values = profilesWithDefaults,
                valuesFunction = Module.GetProfilesWithDefaults,
                order = 10
            },
            -- headerNewProfile = {type = 'header', name = 'New Profile', order = 20},
            createNewProfile = {
                type = 'execute',
                name = 'New Profile',
                btnName = 'Create',
                desc = L["ProfilesNewProfile"],
                func = function()
                    -- print('func! *NewProfile*')
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
                    StaticPopup_Show('DragonflightUINewProfile')
                end,
                order = 21
            },
            headerCopy = {type = 'header', name = 'Copy From Profile', order = 30},
            toCopy = {
                type = 'select',
                name = 'Copy From',
                desc = L["ProfilesCopyFrom"],
                -- values = profilesWithDefaults,
                valuesFunction = Module.GetProfiles,
                order = 31
            },
            copyFromProfile = {
                type = 'execute',
                name = 'Copy To Current Profile',
                btnName = 'Copy',
                desc = L["ProfilesOpenCopyDialogue"],
                func = function()
                    -- print('func! *CopyFromProfile*')
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
                    StaticPopup_Show('DragonflightUICopyProfile')
                end,
                order = 32
            },
            headerDelete = {type = 'header', name = 'Delete Profile', order = 40},
            toDelete = {
                type = 'select',
                name = 'Profile To Delete',
                desc = L["ProfilesDeleteProfile"],
                -- values = profilesWithDefaults,
                valuesFunction = Module.GetProfiles,
                order = 41
            },
            deleteProfile = {
                type = 'execute',
                name = 'Delete Profile',
                btnName = 'Delete',
                desc = L["ProfilesOpenDeleteDialogue"],
                func = function()
                    -- print('func! *DeleteProfile*')
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
                    StaticPopup_Show('DragonflightUIDeleteProfile')
                end,
                order = 42
            }
        }
    }

    local config = {name = 'Profiles', options = options}
    DF.ConfigModule:RegisterOptionScreen('General', 'Profiles', config)
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame
    local cat = 'General'
    configFrame:RefreshCatSub(cat, 'Profiles')
end

function Module:ApplySettings()
    local db = Module.db.profile
end

function Module:GetCurrentProfile()
    return DF.db:GetCurrentProfile()
end

function Module:SetCurrentProfile(name)
    local current = Module:GetCurrentProfile()
    Module:Print('Set current profile from ' .. current .. ' to ' .. name)
    DF.db:SetProfile(name)
    Module:RefreshOptionScreens()
end

function Module:CopyProfile(name)
    DF.db:CopyProfile(name, false)
    Module:RefreshOptionScreens()
end

function Module:DeleteProfile(name)
    Module:Print('Delete profile ' .. name)

    DF.db:DeleteProfile(name, false)
    Module:RefreshOptionScreens()
end

function Module:GetProfiles()
    local profilesT = DF.db:GetProfiles()
    local profiles = {}

    for k, v in ipairs(profilesT) do profiles[v] = v end

    return profiles
end

function Module:GetProfilesWithDefaults()
    local profiles = Module:GetProfiles()

    local char = DF.db.keys.char
    local class = DF.db.keys.class
    local faction = DF.db.keys.faction
    local realm = DF.db.keys.realm

    profiles["Default"] = "Default"
    profiles[char] = char
    profiles[class] = class
    profiles[faction] = faction
    profiles[realm] = realm

    -- DevTools_Dump(DF.db.keys)
    -- DevTools_Dump(profiles)

    return profiles
end

function Module:GetProfilesWithEmpty()
    local profiles = Module:GetProfiles()

    profiles[' '] = ' '

    return profiles
end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1, arg2, arg3)
    -- print('event', event)    
end
frame:SetScript('OnEvent', frame.OnEvent)

-- Cata
function Module.Cata()
end

-- Wrath
function Module.Wrath()
end

-- Era
function Module.Era()
end
