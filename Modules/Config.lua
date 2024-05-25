local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Config'
local Module = DF:NewModule(mName, 'AceConsole-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        modules = {['Actionbar'] = true, ['Castbar'] = true, ['Chat'] = false, ['Minimap'] = true, ['Unitframe'] = true},
        bestnumber = 42
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

local modulesOptions = {
    type = 'group',
    name = 'DragonflightUI - ' .. mName,
    get = getOption,
    set = setOption,
    args = {
        Actionbar = {type = 'toggle', name = 'Actionbar', desc = '' .. getDefaultStr('Actionbar', 'modules'), order = 1},
        Castbar = {type = 'toggle', name = 'Castbar', desc = '' .. getDefaultStr('Castbar', 'modules'), order = 2},
        Chat = {type = 'toggle', name = 'Chat', desc = '' .. getDefaultStr('Chat', 'modules'), order = 3},
        Minimap = {type = 'toggle', name = 'Minimap', desc = '' .. getDefaultStr('Minimap', 'modules'), order = 4},
        Unitframe = {type = 'toggle', name = 'Unitframe', desc = '' .. getDefaultStr('Unitframe', 'modules'), order = 5}
    }
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)

    -- self:SetEnabledState(DF:GetModuleEnabled(mName))
    self:SetEnabledState(true)
    self:SetWasEnabled(true)

    DF.ConfigModule = self
    DF:RegisterModuleOptions(mName, modulesOptions)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    if DF.Wrath then
        Module:Wrath()
    else
        Module:Era()
    end

    Module:ApplySettings()

    DF.ConfigModule:RegisterOptionScreen('General', 'Modules', {
        name = 'Modules',
        sub = 'modules',
        options = modulesOptions,
        default = function()
            setDefaultSubValues('modules')
        end
    })
end

function Module:OnDisable()
end

function Module:ApplySettings()
    local db = Module.db.profile

    local modules = db.modules

    for k, v in pairs(modules) do
        -- print(k, v)

        local dfmod = DF:GetModule(k)
        if dfmod then
            if v and not dfmod:GetWasEnabled() then
                DF:EnableModule(k)
            elseif not v and dfmod:GetWasEnabled() then
                DF:Print("Already loaded module was deactivated, please '/reload' !")
            end
        end
    end
end

function Module:GetModuleEnabled(module)
    return self.db.profile.modules[module]
end

--[[ function Module:SetModuleEnabled(module, value)
    print('SetModuleEnabled', module, value)
    local old = self.db.profile.modules[module]
    self.db.profile.modules[module] = value
    if old ~= value then
        if value then
            DF:EnableModule(module)
            print('true')
        else
            DF:DisableModule(module)
            print('false')
        end
        self:Print('/reload')
    end
end ]]

function Module:AddMainMenuButton()
    hooksecurefunc('GameMenuFrame_UpdateVisibleButtons', function(self)
        -- print('GameMenuFrame_UpdateVisibleButtons')
        local blizzHeight = self:GetHeight()

        self:SetHeight(blizzHeight + 22)

        Module.UpdateMainMenuButtons()
    end)

    local btn = CreateFrame('Button', 'DragonflightUIMainMenuButton', GameMenuFrame, 'UIPanelButtonTemplate')
    btn:SetSize(145, 21)
    btn:SetText('DragonflightUI')
    Module.MainMenuButton = btn

    Module.UpdateMainMenuButtons = function()
        local btn = Module.MainMenuButton

        -- TODO:
        -- 'Interface action failed because of an AddOn' when infight and clicking DF Menu button    
        local storeIsRestricted = IsTrialAccount();
        if (C_StorePublic.IsEnabled() and C_StorePublic.HasPurchaseableProducts() and not storeIsRestricted) then
            btn:SetPoint('TOP', GameMenuButtonStore, 'BOTTOM', 0, -16)
        else
            btn:SetPoint('TOP', GameMenuButtonHelp, 'BOTTOM', 0, -16)
        end

        GameMenuButtonOptions:SetPoint('TOP', btn, 'BOTTOM', 0, -1)
    end
    Module.UpdateMainMenuButtons()

    btn:SetScript('OnClick', function()
        Module.ToggleConfigFrame()
        HideUIPanel(GameMenuFrame)
    end)
end

function Module:AddConfigFrame()
    local config = CreateFrame('Frame', 'DragonflightUIConfigFrame', UIParent, 'DragonflightUIConfigFrameTemplate')
    Module.ConfigFrame = config
    -- config:Show()

    _G['DragonflightUIConfigFrame'] = config
    tinsert(UISpecialFrames, 'DragonflightUIConfigFrame')

    Module:RegisterChatCommand('dragonflight', 'SlashCommand')
    Module:RegisterChatCommand('df', 'SlashCommand')

    -- Module:AddTestConfig()
    Module:AddProfileConfig()
end

function Module:AddTestConfig()
    local options = {
        name = 'WhatsNew',
        get = function(info)
            return false
        end,
        args = {
            configSize = {type = 'header', name = 'Size', order = 1},
            tog = {type = 'toggle', name = 'toggle me', order = 42},
            selectTest = {
                type = 'select',
                name = 'selectTest',
                desc = 'testing',
                values = {
                    ['TOP'] = 'TOP',
                    ['RIGHT'] = 'RIGHT',
                    ['BOTTOM'] = 'BOTTOM',
                    ['LEFT'] = 'LEFT',
                    ['TOPRIGHT'] = 'TOPRIGHT',
                    ['TOPLEFT'] = 'TOPLEFT',
                    ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                    ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                    ['CENTER'] = 'CENTER'
                },
                order = 69
            },
            steptog = {type = 'toggle', name = 'toggle me steptoggler', order = 666}
        }
    }
    local config = {name = 'WhatsNew', options = options}
    Module:RegisterOptionScreen('General', 'WhatsNew', config)
end

function Module:AddProfileConfig()
    local getCurrentProfile = function()
        return DF.db:GetCurrentProfile()
    end

    local setCurrentProfile = function(name)
        DF.db:SetProfile(name)
    end

    local copyProfile = function(name)
        DF.db:CopyProfile(name, false)
    end

    local deleteProfile = function(name)
        DF.db:DeleteProfile(name, false)
    end

    local getProfiles = function()
        local profilesT = DF.db:GetProfiles()
        local profiles = {}
        local current = getCurrentProfile()

        for k, v in ipairs(profilesT) do profiles[v] = v end

        return profiles
    end
    local profiles = getProfiles()

    local getProfilesWithDefaults = function()
        local prof = getProfiles()

        local char = DF.db.keys.char
        local realm = DF.db.keys.realm

        prof["Default"] = "Default"
        prof[char] = char
        prof[realm] = realm

        return prof
    end
    local profilesWithDefaults = getProfilesWithDefaults()

    local getProfilesWithoutCurrent = function()
        local prof = getProfiles()
        local current = getCurrentProfile()

        if prof[current] then prof[current] = nil end

        return prof
    end
    local profilesWithoutCurrent = getProfilesWithoutCurrent()

    local profilesForCopy = {}

    for k, v in pairs(profilesWithoutCurrent) do
        --
        profilesForCopy[k] = v
    end
    profilesForCopy[" "] = " "

    local get = function(info)
        print('get', info, info[1])
        local key = info[1]
        -- local sub = info[2]
        if key == "currentProfile" then return getCurrentProfile() end
        if key == "copyProfile" then return " " end
        if key == "deleteProfile" then return " " end

        return true
    end

    local set = function(info, value)
        local key = info[1]
        -- local sub = info[2]

        print('set', info, info[1], value)

        if key == "currentProfile" then
            --
            setCurrentProfile(value)
        end

        if key == "copyProfile" then
            --
            if value ~= " " then
                --
                copyProfile(value)
            end
        end

        if key == "deleteProfile" then
            --
            if value ~= " " then
                --
                deleteProfile(value)
            end
        end
    end

    local options = {
        name = 'Profiles',
        get = get,
        set = set,
        args = {
            currentProfile = {
                type = 'select',
                name = 'Current Profile',
                desc = 'testing',
                values = profilesWithDefaults,
                valuesFunction = getProfilesWithDefaults,
                order = 42
            },
            copyProfile = {
                type = 'select',
                name = 'copy from',
                desc = 'testing',
                values = profilesForCopy,
                valuesFunction = getProfilesWithoutCurrent,
                order = 69
            },
            deleteProfile = {
                type = 'select',
                name = 'delete',
                desc = 'testing',
                values = profilesForCopy,
                valuesFunction = getProfilesWithoutCurrent,
                order = 69
            }
        }
    }
    local config = {name = 'Profiles', options = options}
    Module:RegisterOptionScreen('General', 'Profiles', config)
end

function Module:ToggleConfigFrame()
    local configFrame = Module.ConfigFrame

    if configFrame:IsShown() then
        configFrame:Hide()
    else
        configFrame:Show()

        HideUIPanel(GameMenuFrame)
        HideUIPanel(SettingsPanel)
    end
end

function Module:SlashCommand()
    Module:ToggleConfigFrame()
end

function Module:RegisterOptionScreen(cat, sub, data)
    -- print('RegisterOptionScreen', cat, sub)
    local config = Module.ConfigFrame
    local subCategory = config:GetSubCategory(cat, sub)

    if subCategory then
        subCategory:SetDisplayData(data)
        subCategory:SetEnabled(true)
    end
end

local frame = CreateFrame('FRAME', 'DragonflightUIConfigFrame', UIParent)

function frame:OnEvent(event, arg1)
    -- print('event', event)
    if event == 'PLAYER_ENTERING_WORLD' then end
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module:Wrath()
    Module:AddConfigFrame()
    Module:AddMainMenuButton()

    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
end

function Module:Era()
    Module:Wrath()
end
