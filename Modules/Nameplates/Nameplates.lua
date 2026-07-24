-- era-1159: Dragonflight-styled nameplates for the modern (1.15.9+)
-- nameplate system. New module - upstream DFUI has none.
local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local mName = 'Nameplates'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {profile = {classColors = true, modernStyle = true}}
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

    -- Enemy level, top-right in line with the name. Plates are pooled, so
    -- the FontString is created once but refreshed for every new unit.
    if uf.name then
        local levelText = uf.DFLevelText
        if not levelText then
            levelText = uf:CreateFontString(nil, 'OVERLAY')
            local path = uf.name:GetFont()
            if path then levelText:SetFont(path, 10, 'OUTLINE') end
            levelText:SetShadowOffset(0, 0)
            levelText:SetPoint('LEFT', uf.name, 'RIGHT', 4, 0)
            uf.DFLevelText = levelText
        end
        if UnitCanAttack('player', unit) then
            local level = UnitLevel(unit)
            if level and level > 0 then
                local color = GetQuestDifficultyColor and GetQuestDifficultyColor(level)
                    or { r = 1, g = 0.82, b = 0 }
                levelText:SetText(level)
                levelText:SetTextColor(color.r, color.g, color.b)
            else
                levelText:SetText('??')
                levelText:SetTextColor(1, 0.1, 0.1)
            end
            levelText:Show()
        else
            levelText:Hide()
        end
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

    -- THE switch: Era 1.15.9 defaults nameplateStyle to the classic look
    -- (border ring + level box). Careful with the enum: 'Modern' is
    -- MIDNIGHT's chunky plate (20px bar, name inside) - the style everyone
    -- calls the Dragonflight plate (thin bar, name above) is 'Thin'.
    -- Blizzard-native; the driver re-reads options via the CVar callback
    -- registry on change.
    if self.db.profile.modernStyle and C_CVar and C_CVar.SetCVar and Enum.NamePlateStyle then
        C_CVar.SetCVar('nameplateStyle', Enum.NamePlateStyle.Thin)
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
