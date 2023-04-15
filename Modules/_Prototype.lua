local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = '*Prototype*'
local Module = DF:NewModule(mName, 'AceConsole-3.0')

local db, getOptions

local defaults = {
    profile = {
        scale = 1,
        dX = 42,
        dY = 35,
        sizeX = 460,
        sizeY = 207
    }
}

local options = {
    type = 'group',
    name = 'DragonflightUI - ' .. mName,
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
            order = 69
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
end

function Module:OnDisable()
end

function Module:ApplySettings()
    db = self.db.profile
end

local frame = CreateFrame('FRAME', 'DragonflightUIPrototypeFrame', UIParent)

function frame:OnEvent(event, arg1)
    --print('event', event)
    if event == 'PLAYER_ENTERING_WORLD' then
    end
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module.Wrath()
    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
end

function Module.Era()
    Module.Wrath()
end
