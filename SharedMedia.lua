local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local LSM = LibStub('LibSharedMedia-3.0')

local pre = 'DFUI '
local texDF = [[Interface\AddOns\DragonflightUI\Textures\]]

-- statusbars
local function RegisterStatusbar(n, tex)
    LSM:Register('statusbar', pre .. n, texDF .. tex)
end

-- player
RegisterStatusbar('Player Health', [[Unitframe\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health]])
RegisterStatusbar('Player Health Status', [[Unitframe\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health-Status]])
RegisterStatusbar('Player Health Mask', [[Unitframe2x\uiunitframeplayerhealthmask2x]])
RegisterStatusbar('Player Health Mask2', [[Unitframe2x\plunderstormplayerhealthbarmask2x]])
RegisterStatusbar('Player Mana Mask', [[Unitframe2x\uiunitframeplayermanamask2x]])

local energyTypes = {'Mana', 'Rage', 'Focus', 'Energy', 'RunicPower'}
for i, n in ipairs(energyTypes) do
    --
    RegisterStatusbar('Player Bar ' .. n, [[Unitframe\UI-HUD-UnitFrame-Player-PortraitOn-Bar-]] .. n)
end

-- target
RegisterStatusbar('Target Health', [[Unitframe\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health]])
RegisterStatusbar('Target Health Status', [[Unitframe\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health-Status]])
RegisterStatusbar('Target Health Mask', [[Unitframe2x\uiunitframetargethealthmask2x]])
-- RegisterStatusbar('Player Health Mask2', [[Unitframe2x\plunderstormplayerhealthbarmask2x]])
RegisterStatusbar('Target Mana Mask', [[Unitframe2x\uiunitframetargetmanamask2x]])

for i, n in ipairs(energyTypes) do
    --
    RegisterStatusbar('Target Bar ' .. n, [[Unitframe\UI-HUD-UnitFrame-Target-PortraitOn-Bar-]] .. n)
end
