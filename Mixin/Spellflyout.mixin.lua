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
    local sumButtons = {}
    sum.Icon:SetTexture(136082)

    local spells = {688, 697, 712, 691, 1122}

    for k, v in ipairs(spells) do
        local btn = self:CreateSpellButton(v, sum:GetName() .. 'Spell' .. k, sum)

        sumButtons[k] = btn;

        if k == 1 then
            btn:SetPoint("BOTTOM", sum, "TOP", 0, 4)
        else
            btn:SetPoint("BOTTOM", sumButtons[k - 1], "TOP", 0, 4)
        end
    end
end

function DragonflightUISpellFlyoutMixin:CreateSpellButton(spell, id, parent)
    print('DragonflightUISpellFlyoutMixin:CreateSpellButton()', id)
    local btn = CreateFrame("CheckButton", id, parent, "DFSpellFlyoutSubButtonTemplate")
    self:StyleButton(btn)
    btn:SetScale(0.9)

    local name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spell)
    local learned = IsPlayerSpell(spell)
    print(name, learned)
    -- btn:SetAttribute("type", "action")
    -- btn:SetAttribute("action", 144 + (n - 6) * 12 + i) -- Action slot 1
    btn:SetAttribute("type", "spell");
    btn:SetAttribute("spell", name);
    _G[btn:GetName() .. 'Icon']:SetTexture(icon)
    btn:SetFrameLevel(3)

    btn:SetScript('OnEnter', function()
        GameTooltip:SetOwner(btn, "ANCHOR_RIGHT");
        GameTooltip:SetSpellByID(spell)

        if IsPlayerSpell(spell) then
            print('true')
        else
            print('false')
        end
    end)
    btn:SetScript('OnLeave', function()
        GameTooltip:Hide()
    end)

    return btn;
end
-- function DragonflightUISpellFlyoutMixin:OnLoad()
--     print('DragonflightUISpellFlyoutMixin:OnLoad()')
-- end
-- function DragonflightUISpellFlyoutMixin:OnLoad()
--     print('DragonflightUISpellFlyoutMixin:OnLoad()')
-- end

