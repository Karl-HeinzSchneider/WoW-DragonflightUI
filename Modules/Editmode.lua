local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Editmode'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {profile = {scale = 1, general = {showGrid = true, gridSize = 20}}}
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

local generalOptions = {
    type = 'group',
    name = 'Darkmode',
    get = getOption,
    set = setOption,
    args = {
        showGrid = {
            type = 'toggle',
            name = 'Show Grid',
            desc = '' .. getDefaultStr('showGrid', 'general'),
            order = 100.5
        },
        gridSize = {
            type = 'range',
            name = 'r',
            desc = '' .. getDefaultStr('gridSize', 'general'),
            min = 1,
            max = 32,
            bigStep = 1,
            order = 101
        }
    }
}

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
    -- Module:RegisterOptionScreens()

    -- self:SecureHook(DF, 'RefreshConfig', function()
    --     -- print('RefreshConfig', mName)
    --     Module:ApplySettings()
    --     Module:RefreshOptionScreens()
    -- end)
end

function Module:OnDisable()
end

-- function Module:RegisterOptionScreens()
--     DF.ConfigModule:RegisterOptionScreen('Misc', 'Darkmode', {
--         name = 'Darkmode',
--         sub = 'general',
--         options = generalOptions,
--         default = function()
--             setDefaultSubValues('general')
--         end
--     })
-- end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame
    local cat = 'Misc'
    configFrame:RefreshCatSub(cat, 'Darkmode')
end

function Module:ApplySettings()
    local db = Module.db.profile
    local state = db.general
end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1, arg2, arg3)
    -- print('event', event)   
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module:CreateGrid()
    print('CreateGrid()')
    local editModeFrame = CreateFrame('Frame', 'DragonflightUIEditModeFrame', UIParent,
                                      'DragonflightUIEditModeFrameTemplate');

end

-- Cata
function Module.Cata()
    Module:CreateGrid()
end

-- Wrath
function Module.Wrath()
end

-- Era
function Module.Era()
end
