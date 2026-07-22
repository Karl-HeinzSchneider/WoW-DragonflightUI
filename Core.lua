local addonName, addonTable = ...;
---@class DragonflightUI : AceAddon-3.0, AceConsole-3.0, AceComm-3.0, AceHook-3.0
---@diagnostic disable-next-line: assign-type-mismatch
local DF = LibStub('AceAddon-3.0'):NewAddon('DragonflightUI', 'AceConsole-3.0', 'AceComm-3.0', 'AceHook-3.0',
                                            'AceSerializer-3.0')
local L = LibStub("AceLocale-3.0"):NewLocale("DragonflightUI", "enUS", true)

addonTable.DF = DF;
addonTable.L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI");
addonTable.SubModuleMixins = {}

local defaults = {profile = {bestnumber = 42}}

---@type API
local t = DF.API;

function DF:OnInitialize()
    -- Called when the addon is loaded
    self.db = LibStub('AceDB-3.0'):New('DragonflightUIDB', defaults, true)
    local db = self.db.profile
    self:SetupOptions()
    self:RegisterSlashCommands()
    self:InitVersionCheck()
end

function DF:OnEnable()
    -- Called when the addon is enabled
    -- self:Print('DragonflightUI enabled!')
    self:ShowStartMessage()

    -- era-1159: the 1.15.9 login runs every addon's file load and setup
    -- inside ONE script-watchdog slice; heavy setups trip 'script ran too
    -- long' at whatever line happens to be executing when the shared budget
    -- expires. Park all modules now (AceAddon is about to auto-enable them
    -- in this same slice) and enable them one per frame instead - each timer
    -- callback gets a fresh watchdog budget. Runtime enabling is already a
    -- supported path (the config module toggles do it), so modules cannot
    -- tell the difference.
    self.deferredModules = {}
    for _, module in ipairs(self.orderedModules) do
        if module.enabledState then
            module:SetEnabledState(false)
            table.insert(self.deferredModules, module)
        end
    end
    local Helper = addonTable.Helper
    local index = 0
    local function enableNext()
        index = index + 1
        local module = self.deferredModules[index]
        if not module then return end
        module:SetEnabledState(true)
        Helper:Benchmark('DeferredEnable(' .. (module.moduleName or index) .. ')', function()
            module:Enable()
        end, 0, self)
        C_Timer.After(0, enableNext)
    end
    -- Start strictly AFTER the loading screen (PLAYER_ENTERING_WORLD), not
    -- from a login-time timer: keeps module setup fully clear of the
    -- loading pipeline and its shared watchdog slice.
    local starter = CreateFrame('Frame')
    starter:RegisterEvent('PLAYER_ENTERING_WORLD')
    starter:SetScript('OnEvent', function(frame)
        frame:UnregisterAllEvents()
        C_Timer.After(0, enableNext)
    end)
end

function DF:OnDisable()
    -- Called when the addon is disabled
end

function DF:EnableModule(name, force)
    force = force and true or false;
    -- DF:GetModule(k, true)
    -- EnableModuleIfNotAlreadyEnabled
    local module = self:GetModule(name)
    local wasAlready = module:GetWasEnabled()
    DF:Debug(module, string.format('DF:EnableModule(%s,%s,%s)', name, tostring(force), tostring(wasAlready)))

    if wasAlready then
        if force then return module:Enable() end
    else
        return module:Enable()
    end
end

local name, realm = UnitName('player')
local showDebug = (name == 'Zimtdev') or (name == 'Zimtdevtwo')
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
        return r, g, b, alpha, hex
    else
        return r, g, b, 1, hex
    end
end

-- TODO
function DF:GetUnitSelectionColor(unit)
    local red, green, blue, alpha = UnitSelectionColor(unit)
    return red, green, blue, alpha;
end

function DF:GetClassColoredText(str, class)
    if not str then return '' end
    local r, g, b, a, hex = DF:GetClassColor(class)
    return "|r|c" .. hex .. str .. "|r"
end

function DF:CreateFrameFromMixinAndInit(mixinTable)
    local f = CreateFrame('Frame');
    Mixin(f, mixinTable);
    f:Init();
    return f;
end
