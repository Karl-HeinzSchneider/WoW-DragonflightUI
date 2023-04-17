local DF = LibStub('AceAddon-3.0'):NewAddon('DragonflightUI', 'AceConsole-3.0')
local db

DF.InterfaceVersion = select(4, GetBuildInfo())
DF.Wrath = DF.InterfaceVersion >= 30400
DF.Era = DF.InterfaceVersion <= 20000

local defaults = {
    profile = {
        modules = {['Actionbar'] = true, ['Castbar'] = true, ['Chat'] = true, ['Minimap'] = true, ['Unitframe'] = true},
        bestnumber = 42
    }
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

function DF:GetModuleEnabled(module)
    return db.modules[module]
end

function DF:SetModuleEnabled(module, value)
    local old = db.modules[module]
    db.modules[module] = value
    if old ~= value then
        if value then
            self:EnableModule(module)
        else
            self:DisableModule(module)
        end
        self:Print('/reload')
    end
end

local name, realm = UnitName('player')
local showDebug = name == 'Zimtdev'
function DF:Debug(m, value)
    if showDebug then
        m:Print(value)
    end
end
