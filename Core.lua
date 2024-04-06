local DF = LibStub('AceAddon-3.0'):NewAddon('DragonflightUI', 'AceConsole-3.0')
local db

DF.InterfaceVersion = select(4, GetBuildInfo())
DF.Cata = (DF.InterfaceVersion >= 40000)
DF.Wrath = (DF.InterfaceVersion >= 30400)
DF.Era = DF.InterfaceVersion <= 20000

local defaults = {profile = {bestnumber = 42}}

function DF:OnInitialize()
    -- Called when the addon is loaded
    self.db = LibStub('AceDB-3.0'):New('DragonflightUIDB', defaults, true)
    db = self.db.profile
    self:SetupOptions()
    self:RegisterSlashCommands()
end

function DF:OnEnable()
    -- Called when the addon is enabled
    -- self:Print('DragonflightUI enabled!')
    self:ShowStartMessage()
end

function DF:OnDisable()
    -- Called when the addon is disabled
end

local name, realm = UnitName('player')
local showDebug = name == 'Zimtdev'
function DF:Debug(m, value)
    if showDebug then m:Print(value) end
end

function DF:Dump(value)
    if showDebug then DevTools_Dump(value) end
end

function DF:ShowStartMessage()
    local version = ''

    if not GetAddOnMetadata then
        version = C_AddOns.GetAddOnMetadata('DragonflightUI', 'Version')
    else
        version = GetAddOnMetadata('DragonflightUI', 'Version')
    end

    self:Print(version .. " loaded! Type '/dragonflight' or '/df' to open the options menu.")
end

function DF:GetClassColor(class, alpha)
    local r, g, b, hex = GetClassColor(class)
    if alpha then
        return r, g, b, alpha
    else
        return r, g, b, 1
    end
end
