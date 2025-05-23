local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

DragonflightUISpellFlyoutButtonMixin = {}

function DragonflightUISpellFlyoutButtonMixin:OnLoad()
    print('DragonflightUISpellFlyoutButtonMixin:OnLoad()')

    Mixin(self, DragonflightUIStateHandlerMixin)
    self:InitStateHandler()

    self.MaxButtons = 8;
    self:InitButtons()
end

function DragonflightUISpellFlyoutButtonMixin:InitButtons()
    DragonflightUIActionbarMixin:StyleButton(self);

    local n = self:GetName()

    local t = {}
    for i = 1, self.MaxButtons do
        --
        -- print(i, n)
        local btn = CreateFrame("CheckButton", n .. 'Spell' .. i, self, "DFSpellFlyoutSubButtonTemplate");
        -- print(i, n, btn:GetName())

        DragonflightUIActionbarMixin:StyleButton(btn);
        btn:SetScale(0.8);
        btn:SetSize(45, 45)
        btn:Show()

        t[i] = btn;
        self:SetHideFrame(btn, i + 1)

        -- btn:SetAttribute("type", "spell");
        -- btn:SetAttribute("spell", "Summon Imp");
        btn:SetFrameLevel(3)
        btn.Icon:SetTexture(136082)

        if i == 1 then
            btn:SetPoint("BOTTOM", self, "TOP", 0, 4)
        else
            btn:SetPoint("BOTTOM", t[i - 1], "TOP", 0, 4)
        end
    end

    self.buttonTable = t;
end
-- function DragonflightUISpellFlyoutButtonMixin:OnLoad()
-- end

function DragonflightUISpellFlyoutButtonMixin:SetState(state)
    self.state = state
    self.savedAlwaysShow = state.alwaysShow
    self:Update()
end

function DragonflightUISpellFlyoutButtonMixin:Update()
    -- print('DragonflightUISpellFlyoutButtonMixin:Update()')
    local state = self.state

    self.Icon:SetTexture(state.icon or 136082)

    local buttonTable = self.buttonTable
    local btnCount = #buttonTable
    local buttons = math.min(state.buttons, btnCount)

    for i = buttons + 1, btnCount do
        local btn = buttonTable[i]
        btn:ClearAllPoints()
        btn:SetPoint('CENTER', UIParent, 'BOTTOM', 0, -666)
        btn:Hide()
    end

    local numUsed = 0;
    if state.spells ~= '' then
        local spellTable = self:SplitString(state.spells)
        -- print('spells: ', state.spells)
        -- DevTools_Dump(spellTable)
        numUsed = #spellTable;

        for i = 1, numUsed do
            --
            local btn = buttonTable[i]
            btn:ClearAllPoints()
            btn:Show()

            if i == 1 then
                btn:SetPoint("BOTTOM", self, "TOP", 0, 4)
            else
                btn:SetPoint("BOTTOM", buttonTable[i - 1], "TOP", 0, 4)
            end

            local spell = spellTable[i];

            local name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spell)
            local learned = IsPlayerSpell(spell)
            -- print(spell, name, learned)

            btn:SetAttribute("type", "spell");
            btn:SetAttribute("spell", name);
            btn.Icon:SetTexture(icon)

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
        end
    else
    end

    for i = numUsed + 1, btnCount do
        --
        local btn = buttonTable[i]
        btn:ClearAllPoints()
        btn:SetPoint('CENTER', UIParent, 'BOTTOM', 0, -666)
        btn:Hide()
        -- print('hide', i)
    end

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    self:ClearAllPoints()
    self:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    self:SetScale(state.scale)

    self:UpdateStateHandler(state)
end

function DragonflightUISpellFlyoutButtonMixin:SplitString(str)
    local spellTable = {}

    --- @type {[string]: string | number} 
    spellTable = {strsplit(',', str)}

    for k, v in ipairs(spellTable) do spellTable[k] = tonumber(strtrim(v)) end

    return spellTable
end

DragonflightUISpellFlyoutBGMixin = {}
function DragonflightUISpellFlyoutBGMixin:OnLoad()
    print('DragonflightUISpellFlyoutBGMixin:OnLoad()')
end

function DragonflightUISpellFlyoutBGMixin:SetState(state)
    self.state = state
    self:Update()
end

function DragonflightUISpellFlyoutBGMixin:Update()
    -- print('DragonflightUISpellFlyoutButtonMixin:Update()')
end
