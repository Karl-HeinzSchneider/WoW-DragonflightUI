local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

--- DragonflightUI (public)  API
--- @class API
--- @field Modules? ModulesAPI
--- @field Version? VersionAPI
local API = {};
DF.API = API;

-- make globally available
_G['DragonflightUI_API'] = API;

