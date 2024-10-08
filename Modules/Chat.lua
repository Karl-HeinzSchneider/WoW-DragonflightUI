local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Chat'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        scale = 1,
        x = 42,
        y = 35,
        sizeX = 460,
        sizeY = 207,
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

local options = {
    type = 'group',
    name = 'DragonflightUI - ' .. mName,
    get = getOption,
    set = setOption,
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale'),
            min = 0.2,
            max = 5,
            bigStep = 0.1,
            order = 1,
            disabled = true
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to BOTTOM LEFT' .. getDefaultStr('x'),
            min = 0,
            max = 3500,
            bigStep = 1,
            order = 2
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to BOTTOM LEFT' .. getDefaultStr('y'),
            min = 0,
            max = 3500,
            bigStep = 1,
            order = 3
        },
        sizeX = {
            type = 'range',
            name = 'Size X',
            desc = 'Size X' .. getDefaultStr('sizeX'),
            min = 0,
            max = 1000,
            bigStep = 1,
            order = 4
        },
        sizeY = {
            type = 'range',
            name = 'Size Y',
            desc = 'Size Y' .. getDefaultStr('sizeY'),
            min = 0,
            max = 1000,
            bigStep = 1,
            order = 5
        }
    }
}
-- DragonflightUIStateHandlerMixin:AddStateTable(Module, options, nil, 'Chat', getDefaultStr, setOption)

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    DF:RegisterModuleOptions(mName, options)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    if DF.Wrath then
        Module.Wrath()
    else
        Module.Era()
    end
    -- Module.AddStateUpdater()

    Module:ApplySettings()
    DF.ConfigModule:RegisterOptionScreen('Misc', 'Chat', {name = 'Chat', options = options, default = setDefaultValues})

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)
        Module:ApplySettings()
        Module:RefreshOptionScreens()
    end)
end

function Module:OnDisable()
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame

    local refreshCat = function(name)
        configFrame:RefreshCatSub('Misc', name)
    end

    refreshCat('Chat')
end

function Module:ApplySettings()
    local db = Module.db.profile

    ChatFrame1:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', db.x, db.y)
    ChatFrame1:SetSize(db.sizeX, db.sizeY)
    ChatFrame1:SetUserPlaced(true)

    -- ChatFrame1:UpdateStateHandler(db)
end

local frame = CreateFrame('FRAME', 'DragonflightUIChatFrame', UIParent)

function Module.AddStateUpdater()
    Mixin(ChatFrame1, DragonflightUIStateHandlerMixin)
    ChatFrame1:InitStateHandler()
    -- Minimap:SetHideFrame(frame.CalendarButton, 2)
end

function Module.ChangeSizeAndPosition()
    ChatFrame1:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 42, 35)
    ChatFrame1:SetSize(420 + 40, 200 + 7)
end

function frame:OnEvent(event, arg1)
    -- print('event', event)
    if event == 'PLAYER_ENTERING_WORLD' then
        -- Module.ChangeSizeAndPosition()
        Module:ApplySettings()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module.Wrath()
    -- Module.ChangeSizeAndPosition()

    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
end

function Module.Era()
    Module.Wrath()
end
