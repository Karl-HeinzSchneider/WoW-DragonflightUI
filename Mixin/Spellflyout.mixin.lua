DragonflightUISpellFlyoutMixin = CreateFromMixins(DragonflightUIActionbarMixin)

function DragonflightUISpellFlyoutMixin:OnLoad()
    print('DragonflightUISpellFlyoutMixin:OnLoad()')
end

function DragonflightUISpellFlyoutMixin:InitFlyoutButtons()
    print('DragonflightUISpellFlyoutMixin:InitFlyoutButtons()')

    local t = {}

    local function addButtons(n)
        for i = 1, n do
            local btn = CreateFrame("CheckButton", 'DragonflightUISpellFlyoutButton' .. i, self,
                                    'DFSpellFlyoutButtonTemplate')
            btn:SetSize(45, 45)
            t[i] = btn;
            _G[btn:GetName() .. "Icon"]:SetTexCoord(4 / 64, 60 / 64, 4 / 64, 60 / 64);
        end
    end
    addButtons(4)
    self:SetButtons(t);
    self:StyleButtons()

    local _, _, classIndex = UnitClass('player')
    -- None = 0
    -- Warrior = 1
    -- Paladin = 2
    -- Hunter = 3
    -- Rogue = 4
    -- Priest = 5
    -- DeathKnight = 6
    -- Shaman = 7
    -- Mage = 8
    -- Warlock = 9
    -- Monk = 10
    -- Druid = 11
    -- Demon Hunter = 12
    if classIndex == 1 then
    elseif classIndex == 2 then
    elseif classIndex == 3 then
    elseif classIndex == 4 then
    elseif classIndex == 5 then
    elseif classIndex == 6 then
    elseif classIndex == 7 then
    elseif classIndex == 8 then
    elseif classIndex == 9 then
        self:AddWarlockButtons(t)
    elseif classIndex == 10 then
    elseif classIndex == 11 then
    elseif classIndex == 12 then
    else
    end
end

function DragonflightUISpellFlyoutMixin:AddWarlockButtons(t)
    print('DragonflightUISpellFlyoutMixin:AddWarlockButtons()', #t)

    local sum = t[1]
    sum.Icon:SetTexture(136082)
end
-- function DragonflightUISpellFlyoutMixin:OnLoad()
--     print('DragonflightUISpellFlyoutMixin:OnLoad()')
-- end
-- function DragonflightUISpellFlyoutMixin:OnLoad()
--     print('DragonflightUISpellFlyoutMixin:OnLoad()')
-- end
-- function DragonflightUISpellFlyoutMixin:OnLoad()
--     print('DragonflightUISpellFlyoutMixin:OnLoad()')
-- end

