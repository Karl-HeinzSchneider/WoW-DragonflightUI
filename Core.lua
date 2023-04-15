local Addon, Core = ...

local DF = LibStub('AceAddon-3.0'):NewAddon('DragonflightUI', 'AceConsole-3.0')
local db

local defaults = {
    profile = {}
}

function DF:OnInitialize()
    -- Called when the addon is loaded
    self:Print('Hello World!')
    self.db = LibStub('AceDB-3.0'):New('DragonflightUIDB', defaults, true)
    db = self.db.profile
    self:SetupOptions()
end

function DF:OnEnable()
    -- Called when the addon is enabled
    self:Print('DragonflightUI enabled!')
end

function DF:OnDisable()
    -- Called when the addon is disabled
end

-- Vars

local colorTable = {
    ['yellow'] = '|c00ffff00',
    ['green'] = '|c0000ff00',
    ['orange'] = '|c00ffc400',
    ['red'] = '|c00ff0000'
}

local InterfaceVersion = select(4, GetBuildInfo())
Core.Wrath = InterfaceVersion >= 30400
Core.Era = InterfaceVersion <= 20000

Core.Modules = {}
Core.Sub = {}
Core.RegisterModule = function(name, meta, options, default, func)
    table.insert(
        Core.Modules,
        {
            ['name'] = name,
            ['meta'] = meta,
            ['options'] = options,
            ['default'] = default,
            ['func'] = func
        }
    )
end
