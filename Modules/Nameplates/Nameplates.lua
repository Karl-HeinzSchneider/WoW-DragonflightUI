-- era-1159: Dragonflight-styled nameplates for the modern (1.15.9+)
-- nameplate system. New module - upstream DFUI has none.
local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local mName = 'Nameplates'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {profile = {classColors = true}}
Module:SetDefaults(defaults)

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)
    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))
end

local BAR_TEXTURE =
    'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Player-PortraitOff-Bar-Health-Status32'

local function StylePlate(unit)
    if not (C_NamePlate and C_NamePlate.GetNamePlateForUnit) then return end
    local plate = C_NamePlate.GetNamePlateForUnit(unit)
    if not plate then return end
    if plate.IsForbidden and plate:IsForbidden() then return end

    local uf = plate.UnitFrame
    if not uf or (uf.IsForbidden and uf:IsForbidden()) then return end

    local container = uf.HealthBarsContainer
    local healthBar = container and container.healthBar
    if healthBar and not healthBar.DFStyled then
        healthBar.DFStyled = true
        healthBar:SetStatusBarTexture(BAR_TEXTURE)
        local bg = (container and container.background) or healthBar.background
        if bg and bg.SetColorTexture then bg:SetColorTexture(0, 0, 0, 0.55) end
    end

    if uf.name and not uf.DFNameStyled then
        uf.DFNameStyled = true
        local path = uf.name:GetFont()
        if path then uf.name:SetFont(path, 10, 'OUTLINE') end
        uf.name:SetShadowOffset(0, 0)
    end
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    -- Midnight-backport CVars, new to Era in 1.15.9: class-colored enemy
    -- health bars. Re-asserted at enable while the option is on.
    if self.db.profile.classColors and C_CVar and C_CVar.SetCVar then
        C_CVar.SetCVar('nameplateShowClassColor', 1)
    end

    local frame = CreateFrame('Frame')
    self.Frame = frame
    frame:RegisterEvent('NAME_PLATE_UNIT_ADDED')
    frame:SetScript('OnEvent', function(_, _, unit)
        StylePlate(unit)
    end)

    -- Style anything already on screen (enable happens post-login).
    if C_NamePlate and C_NamePlate.GetNamePlates then
        for _, plate in ipairs(C_NamePlate.GetNamePlates()) do
            if plate.namePlateUnitToken then StylePlate(plate.namePlateUnitToken) end
        end
    end
end

function Module:OnDisable()
end
