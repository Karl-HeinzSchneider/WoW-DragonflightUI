---@class DragonflightUI : AceAddon-3.0, AceConsole-3.0, AceComm-3.0, AceHook-3.0
---@diagnostic disable-next-line: assign-type-mismatch
local DF = LibStub('AceAddon-3.0'):NewAddon('DragonflightUI', 'AceConsole-3.0', 'AceComm-3.0', 'AceHook-3.0',
                                            'AceSerializer-3.0')
local db

DF.InterfaceVersion = select(4, GetBuildInfo())
DF.Cata = (DF.InterfaceVersion >= 40000)
DF.Wrath = (DF.InterfaceVersion >= 30400)
DF.Era = DF.InterfaceVersion <= 20000
DF.EraLater = DF.Era and DF.InterfaceVersion >= 11503

local defaults = {profile = {bestnumber = 42}}

function DF:OnInitialize()
    -- Called when the addon is loaded
    self.db = LibStub('AceDB-3.0'):New('DragonflightUIDB', defaults, true)
    db = self.db.profile
    self:SetupOptions()
    self:RegisterSlashCommands()
    self:InitVersionCheck()
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
DF.ShowDebug = showDebug;
function DF:Debug(m, ...)
    if showDebug then m:Print(...) end
end

function DF:Dump(value)
    if showDebug then DevTools_Dump(value) end
end

function DF:ShowStartMessage()
    local version = C_AddOns.GetAddOnMetadata('DragonflightUI', 'Version')

    self:Print(version .. " loaded! Type '/dragonflight' or '/df' to open the options menu.")
end

-- BLIZZ:
local function GetClassColor(classFilename)
    local classColors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS -- change for 'WeWantBlueShamans'

    local color = classColors[classFilename];
    if color then return color.r, color.g, color.b, color.colorStr; end

    return 1, 1, 1, "ffffffff";
end

function DF:GetClassColor(class, alpha)
    local r, g, b, hex = GetClassColor(class)
    if alpha then
        return r, g, b, alpha
    else
        return r, g, b, 1
    end
end

do
    local classColor = {
        SHAMAN = "2459FF",
        MAGE = "69CCF0",
        WARLOCK = "9482C9",
        HUNTER = "ABD473",
        ROGUE = "FFF569",
        PRIEST = "FFFFFF",
        DRUID = "FF7D0A",
        DEATHKNIGHT = "C41F3B",
        WARRIOR = "C79C6E",
        PALADIN = "F58CBA"
    }

    function DF:GetClassColorText(class)
        return classColor[class] or classColor['PRIEST']
    end

    function DF:GetClassColoredText(str, class)
        return "|cff" .. DF:GetClassColorText(class) .. str .. "|r"
    end
end

