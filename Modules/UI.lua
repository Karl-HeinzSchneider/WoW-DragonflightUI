local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'UI'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')
Module.Tmp = {}

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {profile = {scale = 1, first = {}}}
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

local UIOptions = {
    type = 'group',
    name = 'Utility',
    get = getOption,
    set = setOption,
    args = {friendsHeader = {type = 'header', name = 'Friendsframe', order = 10}}
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    DF:RegisterModuleOptions(mName, UIOptions)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    if DF.Cata then
        Module.Cata()
    else
        Module.Era()
    end

    Module.ApplySettings()
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
    DF.ConfigModule:RegisterOptionScreen('Misc', 'UI', {
        name = 'UI',
        sub = 'first',
        options = UIOptions,
        default = function()
            setDefaultSubValues('first')
        end
    })
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame

    local refreshCat = function(name)
        configFrame:RefreshCatSub('Misc', name)
    end

    refreshCat('UI')
end

function Module:ApplySettings()
    local db = Module.db.profile
end

function Module:ChangeButtons()
    -- DragonflightUIMixin:UIPanelCloseButton(_G['DragonflightUIConfigFrame'].ClosePanelButton)

    -- Dragonflight Config
    do
        local config = _G['DragonflightUIConfigFrame']
        DragonflightUIMixin:ButtonFrameTemplateNoPortrait(config)
        DragonflightUIMixin:MaximizeMinimizeButtonFrameTemplate(config.MinimizeButton)
        config.MinimizeButton:ClearAllPoints()
        config.MinimizeButton:SetPoint('RIGHT', config.ClosePanelButton, 'LEFT', 0, 0)

        config.KeybindButton:SetPoint('RIGHT', config.MinimizeButton, 'LEFT', 0, 0)
    end

    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(_G['SettingsPanel'])

    SpellBookPage2:Hide()
    SpellBookFrameInset:Hide()
    SpellBookSpellIconsFrame:Hide()
    SpellBookFramePortrait:Hide()
    SpellBookFrameBg:Hide()

    DragonflightUIMixin:PortraitFrameTemplate(_G['SpellBookFrame'])

end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1)
    -- print('event', event) 
end
frame:SetScript('OnEvent', frame.OnEvent)

-- Cata
function Module.Cata()
    Module:ChangeButtons()
end

-- Wrath
function Module.Wrath()
end

-- Era
function Module.Era()
end
