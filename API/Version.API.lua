local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

-- compat @TODO
DF.InterfaceVersion = select(4, GetBuildInfo())
DF.Cata = (DF.InterfaceVersion >= 40000)
DF.Wrath = (DF.InterfaceVersion >= 30400)
DF.Era = DF.InterfaceVersion <= 20000
DF.EraLater = DF.Era and DF.InterfaceVersion >= 11503

---@type API
local API = DF.API;

--- Game version table
--- @class VersionAPI
local Version = {}
API.Version = Version

--- WoW Interface Version, e.g. 11507
---@type number
Version.InterfaceVersion = select(4, GetBuildInfo())

--- Addon is running on Classic "Vanilla" client, e.g. Era and SoD etc
---@type boolean
Version.IsClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC

--- Addon is running on Classic Season of Discovery client
---@type boolean
Version.IsSoD = Version.IsClassic and C_Seasons.HasActiveSeason() and
                    (C_Seasons.GetActiveSeason() == Enum.SeasonID.SeasonOfDiscovery)

--- current Season ID, or 0 if no Season
--- 
--- https://warcraft.wiki.gg/wiki/API_C_Seasons.GetActiveSeason
---@type Enum.SeasonID
Version.SeasonID = 0;
if C_Seasons.HasActiveSeason() then Version.SeasonID = C_Seasons.GetActiveSeason() end

--- Addon is running on Classic TBC client
---@type boolean
Version.IsTBC = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC

--- Addon is running on Classic Wotlk client
---@type boolean
Version.IsWotlk = WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC

--- Addon is running on Classic Cataclysm client
---@type boolean
Version.IsCata = WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC

--- Addon is running on Classic MoP client
---@type boolean
Version.IsMoP = WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC

-- DevTools_Dump(API.Version)
