local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Chat'
local Module = DF:NewModule(mName, 'AceConsole-3.0')

local db, getOptions

local defaults = {
    profile = {
        scale = 1,
        x = 42,
        y = 35,
        sizeX = 460,
        sizeY = 207
    }
}
local function getDefaultStr(key)
    return ' (Default: ' .. tostring(defaults.profile[key]) .. ')'
end

local function setDefaultValues()
    for k, v in pairs(defaults.profile) do
        Module.db.profile[k] = v
    end
    Module.ApplySettings()
end

-- db[info[#info] = VALUE
local function getOption(info)
    return db[info[#info]]
end

local function setOption(info, value)
    local key = info[1]
    Module.db.profile[key] = value
    Module.ApplySettings()
end

local options = {
    type = 'group',
    name = 'DragonflightUI - ' .. mName,
    get = getOption,
    set = setOption,
    args = {
        toggle = {
            type = 'toggle',
            name = 'Enable',
            get = function()
                return DF:GetModuleEnabled(mName)
            end,
            set = function(info, v)
                DF:SetModuleEnabled(mName, v)
            end,
            order = 1
        },
        reload = {
            type = 'execute',
            name = '/reload',
            desc = 'reloads UI',
            func = function()
                ReloadUI()
            end,
            order = 1.1
        },
        defaults = {
            type = 'execute',
            name = 'Defaults',
            desc = 'Sets Config to default values',
            func = setDefaultValues,
            order = 1.1
        },
        config = {
            type = 'header',
            name = 'Config - Chat',
            order = 100
        },
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale'),
            min = 0.2,
            max = 1.5,
            bigStep = 0.025,
            order = 101,
            disabled = true
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to BOTTOM LEFT' .. getDefaultStr('x'),
            min = 0,
            max = 3500,
            bigStep = 0.50,
            order = 102
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to BOTTOM LEFT' .. getDefaultStr('y'),
            min = 0,
            max = 3500,
            bigStep = 0.50,
            order = 102
        },
        sizeX = {
            type = 'range',
            name = 'Size X',
            desc = 'Size X' .. getDefaultStr('sizeX'),
            min = 0,
            max = 1000,
            bigStep = 0.50,
            order = 103
        },
        sizeY = {
            type = 'range',
            name = 'Size Y',
            desc = 'Size Y' .. getDefaultStr('sizeY'),
            min = 0,
            max = 1000,
            bigStep = 0.50,
            order = 103
        }
    }
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)
    db = self.db.profile

    self:SetEnabledState(DF:GetModuleEnabled(mName))
    DF:RegisterModuleOptions(mName, options)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    if DF.Wrath then
        Module.Wrath()
    else
        Module.Era()
    end
    Module:ApplySettings()
end

function Module:OnDisable()
end

function Module:ApplySettings()
    db = Module.db.profile

    ChatFrame1:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', db.x, db.y)
    ChatFrame1:SetSize(db.sizeX, db.sizeY)
end

local frame = CreateFrame('FRAME', 'DragonflightUIChatFrame', UIParent)

function Module.ChangeSizeAndPosition()
    ChatFrame1:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 42, 35)
    ChatFrame1:SetSize(420 + 40, 200 + 7)
end

function frame:OnEvent(event, arg1)
    --print('event', event)
    if event == 'PLAYER_ENTERING_WORLD' then
        --Module.ChangeSizeAndPosition()
        Module:ApplySettings()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module.Wrath()
    Module.ChangeSizeAndPosition()

    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
end

function Module.Era()
    Module.Wrath()
end
