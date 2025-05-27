local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

local GetItemCooldown = GetItemCooldown or C_Container.GetItemCooldown;

local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar'
local textureRefTwo = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'

DragonflightUISpellFlyoutButtonMixin = {}

function DragonflightUISpellFlyoutButtonMixin:OnLoad()
    print('DragonflightUISpellFlyoutButtonMixin:OnLoad()')

    Mixin(self, DragonflightUIStateHandlerMixin)
    self:InitStateHandler()

    self.MaxButtons = 8;
    self:InitButtons()

    self:AddArrow()
    self:UpdateArrow()
end

function DragonflightUISpellFlyoutButtonMixin:AddArrow()
    local arr = self:CreateTexture('DragonflightUISpellFlyoutArrow')

    arr:ClearAllPoints()
    arr:SetSize(18, 6)
    arr:SetTexture(textureRefTwo)
    arr:SetTexCoord(0.884766, 0.955078, 0.438965, 0.445801)
    arr:SetPoint('TOP', self, 'TOP', 0, 6)

    self.Arrow = arr;
end

function DragonflightUISpellFlyoutButtonMixin:UpdateArrow(dir)
    local arr = self.Arrow

    local o = (self.BG:IsShown() and 1) or 0;

    if dir == 'LEFT' then
        arr:ClearAllPoints()
        arr:SetSize(18, 6)
        arr:SetPoint('RIGHT', self, 'LEFT', 6, 0)
        arr:SetRotation(math.pi / 2 + o * math.pi)
    elseif dir == 'RIGHT' then
        arr:ClearAllPoints()
        arr:SetSize(18, 6)
        arr:SetPoint('LEFT', self, 'RIGHT', -6, 0)
        arr:SetRotation(-math.pi / 2 + o * math.pi)
    elseif dir == 'BOTTOM' then
        arr:ClearAllPoints()
        arr:SetSize(18, 6)
        arr:SetPoint('BOTTOM', self, 'BOTTOM', 0, -6)
        arr:SetRotation(math.pi + o * math.pi)
    else
        arr:ClearAllPoints()
        arr:SetSize(18, 6)
        arr:SetPoint('TOP', self, 'TOP', 0, 6)
        arr:SetRotation(0 + o * math.pi)
    end
end

function DragonflightUISpellFlyoutButtonMixin:InitButtons()
    DragonflightUIActionbarMixin:StyleButton(self);

    local n = self:GetName()

    local f = CreateFrame('Frame', n .. 'BG', self, 'DFSpellFlyoutBGTemplate')
    f:Hide()
    self.BG = f;

    self:SetAttribute("type", "macro");
    self:SetAttribute("macrotext", "/click " .. n .. "ClickButton");

    -- self:SetSize(45, 45)
    -- self:SetAttribute("_onclick", [[      
    --     -- local frame = self:GetFrameRef("flyoutFrame");
    --     -- frame:Show();    
    --     print('test')
    --     -- local tabs = self:GetFrameRef("TabsFrame");
    --     -- tabs:Hide();   
    -- -- ]]);
    -- self:SetFrameRef('flyoutFrame', f)
    -- self:SetFrameRef("frame1", PlayerFrame);

    -- somehow I could not get SetFrameRef to work here °_°; workaround:
    local frame = CreateFrame("BUTTON", n .. "ClickButton", UIParent, "SecureHandlerClickTemplate")
    frame:SetAttribute("_onclick", [=[
        local ref = self:GetFrameRef("frame1")
        if ref:IsShown() then
            ref:Hide()
        else
            ref:Show()
        end
    ]=]);
    frame:RegisterForClicks("AnyUp");
    frame:SetFrameRef("frame1", f);

    frame:HookScript('OnClick', function()
        --
        -- print('onclick')
        local state = self.state;
        self:UpdateArrow(state.flyoutDirection or '')
    end)

    -- frame:SetSize(69, 69)
    frame:SetPoint('TOP', UIParent, 'BOTTOM', -666, -666)

    local t = {}
    for i = 1, self.MaxButtons do
        --
        -- print(i, n)
        local btn = CreateFrame("Button", n .. 'Spell' .. i, self.BG, "DFSpellFlyoutSubButtonTemplate");
        -- print(i, n, btn:GetName())

        DragonflightUIActionbarMixin:StyleButton(btn);
        btn:SetScale(0.8);
        btn:SetSize(45, 45)
        -- btn:Show()

        t[i] = btn;
        self:SetHideFrame(btn, i + 1)

        -- btn:SetAttribute("type", "spell");
        -- btn:SetAttribute("spell", "Summon Imp");
        btn:SetFrameLevel(3)
        btn.Icon:SetTexture(136082)

        btn.Count = _G[btn:GetName() .. 'Count']
        btn.Count:SetText('69')
        -- if i == 1 then
        --     btn:SetPoint("BOTTOM", self, "TOP", 0, 4)
        -- else
        --     btn:SetPoint("BOTTOM", t[i - 1], "TOP", 0, 4)
        -- end
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

    self:UpdateArrow(state.flyoutDirection)

    self:SetScript('OnEnter', function()
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetText(state.displayName, 1.0, 1.0, 1.0);
        GameTooltip:AddLine(state.tooltip, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true);
        GameTooltip:Show()
    end)

    self:SetScript('OnLeave', function()
        GameTooltip:Hide()
    end)

    local buttonTable = self.buttonTable
    local btnCount = #buttonTable
    local buttons = math.min(state.buttons, btnCount)

    for i = buttons + 1, btnCount do
        local btn = buttonTable[i]
        btn:ClearAllPoints()
        btn:SetPoint('CENTER', UIParent, 'BOTTOM', 0, -666)
        btn:Hide()
        -- print('hide', i)
    end

    local macroTable = {}

    -- all spells
    if state.spells ~= '' then
        local spellTable = self:SplitString(state.spells)

        for k, spell in ipairs(spellTable) do
            --        
            local name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spell)
            if name then table.insert(macroTable, spell) end
        end
    end

    local englishFaction, localizedFaction = UnitFactionGroup('player')

    if state.spellsAlliance ~= '' and englishFaction == 'Alliance' then
        local spellTable = self:SplitString(state.spellsAlliance)

        for k, spell in ipairs(spellTable) do
            --        
            local name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spell)
            if name then table.insert(macroTable, spell) end
        end
    end

    if state.spellsHorde ~= '' and englishFaction == 'Horde' then
        local spellTable = self:SplitString(state.spellsHorde)

        for k, spell in ipairs(spellTable) do
            --        
            local name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spell)
            if name then table.insert(macroTable, spell) end
        end
    end

    local numSpells = #macroTable;

    if state.items ~= '' then
        local spellTable = self:SplitString(state.items)

        for k, spell in ipairs(spellTable) do
            --        
            local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
                  itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(spell)
            if itemName then table.insert(macroTable, spell) end
        end
    end

    -- DevTools_Dump(macroTable)
    -- print('numspells', numSpells)
    -- print('all', #macroTable)

    local closeStr = ''
    if state.closeAfterClick then closeStr = "\n/click " .. self:GetName() .. "ClickButton"; end

    local numUsed = math.min(state.buttons, #macroTable);
    self.BG:SetState(state, numUsed)

    for i = 1, numUsed do
        --
        local btn = buttonTable[i]
        self.BG:SetButton(btn, i, buttonTable)

        if i <= numSpells then
            local spell = macroTable[i];
            local name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spell)
            -- local learned = IsPlayerSpell(spell)

            btn:SetAttribute("type", "macro");
            btn:SetAttribute("macrotext", "#showtooltip\n/cast " .. name .. closeStr);

            btn:SetSpell(spell)
        else
            local item = macroTable[i]
            local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
                  itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item)

            btn:SetAttribute("type", "macro");
            btn:SetAttribute("macrotext", "/use " .. itemName .. closeStr);

            btn:SetItem(item)
        end
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
    -- print('DragonflightUISpellFlyoutBGMixin:OnLoad()')
    self:SetSize(45, 45)
    self:AddTextures()
end

function DragonflightUISpellFlyoutBGMixin:AddTextures()
    -- print('DragonflightUISpellFlyoutBGMixin:AddTextures()')

    self.box = CreateFrame('FRAME')
    self.box:SetParent(self)
    self.box:SetAllPoints()
    self.box:SetFrameLevel(42)
    self.box:SetFrameStrata('LOW')

    self.box.texture = self.box:CreateTexture(nil, 'BACKGROUND')
    self.box.texture:SetAllPoints()
    self.box.texture:SetColorTexture(0, 0.8, 0, 0.42)

    self.box.texture:Hide()

    -- -- end
    -- local e = self:CreateTexture(nil, 'BACKGROUND')
    -- e:SetSize(47, 29)
    -- e:SetTexture(textureRefTwo)
    -- e:SetTexCoord(0.701171875, 0.884765625, 0.56494140625, 0.59326171875)
    -- e:SetPoint('TOP', 0, 3)

    -- -- start
    -- local start = self:CreateTexture(nil, 'BACKGROUND')
    -- start:SetSize(47, 5)
    -- start:SetTexture(textureRefTwo)
    -- start:SetTexCoord(0.701171875, 0.884765625, 0.59423828125, 0.59912109375)
    -- start:SetPoint('BOTTOM', 0, -5)

    -- ["_ui-hud-actionbar-iconframe-flyoutmidleft"]={48, 19771, 0.125, 0.183594, 0, 0.03125, false, false, "1x"},
    -- local midHoriz = self:CreateTexture(nil, 'BACKGROUND')
    -- midHoriz:SetSize(47, 5)
    -- midHoriz:SetTexture(textureRef)
    -- midHoriz:SetTexCoord(0.701171875, 0.884765625, 0.59423828125, 0.59912109375)
    -- midHoriz:SetPoint('BOTTOM')

    -- local texVert = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbarvertical2x'

    --   local midVert = self:CreateTexture(nil, 'BACKGROUND')
    -- midVert:SetSize(32, 9885)
    -- midVert:SetTexture(texVert)
    -- midVert:SetTexCoord(0.701171875, 0.884765625, 0.59423828125, 0.59912109375)
    -- midVert:SetPoint('BOTTOM')
    -- ["!ui-hud-actionbar-iconframe-flyoutmid"]={32, 19770, 0.183594, 0.125, 0.03125, 1.5, false, false, "1x"},
    -- ["!ui-hud-actionbar-iconframe-flyoutmid-2x"]={32, 9885, 0.367188, 0.25, 0.015625, 1.48438, false, false, "2x"},
end

-- ["UI-HUD-ActionBar-Flyout"]={18, 3, 0.884766, 0.955078, 0.438965, 0.445801, false, false, "2x"},
-- ["UI-HUD-ActionBar-Flyout-Down"]={19, 4, 0.884766, 0.958984, 0.430176, 0.437988, false, false, "2x"},
-- ["UI-HUD-ActionBar-Flyout-Mouseover"]={18, 3, 0.884766, 0.955078, 0.446777, 0.453613, false, false, "2x"},

-- function DragonflightUISpellFlyoutBGMixin:OnLoad()
--     print('DragonflightUISpellFlyoutBGMixin:OnLoad()')
-- end

function DragonflightUISpellFlyoutBGMixin:SetState(state, numUsed)
    self.state = state
    self.state.numUsed = numUsed
    self:Update()
end

function DragonflightUISpellFlyoutBGMixin:Update()
    -- print('DragonflightUISpellFlyoutBGMixin:Update()')
    local state = self.state

    local parent = self:GetParent()

    local buttons = state.numUsed;
    local buttonSize = 45;
    local buttonScaling = 0.8

    local padding = 4;

    local w = buttonScaling * (buttonSize + padding)
    local h = buttonScaling * (buttons * (buttonSize + padding) + 2 * padding)

    local dir = state.flyoutDirection
    self:ClearAllPoints()
    if dir == 'LEFT' then
        self:SetSize(h, w)
        self:SetPoint('RIGHT', parent, 'LEFT', 0, 0)
    elseif dir == 'RIGHT' then
        self:SetSize(h, w)
        self:SetPoint('LEFT', parent, 'RIGHT', 0, 0)
    elseif dir == 'BOTTOM' then
        self:SetSize(w, h)
        self:SetPoint('TOP', parent, 'BOTTOM', 0, 0)
    else
        self:SetSize(w, h)
        self:SetPoint('BOTTOM', parent, 'TOP', 0, 0)
    end
end

function DragonflightUISpellFlyoutBGMixin:SetButton(btn, i, buttonTable)
    -- print('~SetButton', btn:GetName(), i)
    local state = self.state
    local dir = state.flyoutDirection
    local padding = 4;

    btn:ClearAllPoints()
    btn:Show()

    if dir == 'LEFT' then
        if i == 1 then
            btn:SetPoint("RIGHT", self, "RIGHT", -2 * padding, 0)
        else
            btn:SetPoint("RIGHT", buttonTable[i - 1], "LEFT", -padding, 0)
        end
    elseif dir == 'RIGHT' then
        if i == 1 then
            btn:SetPoint("LEFT", self, "LEFT", 2 * padding, 0)
        else
            btn:SetPoint("LEFT", buttonTable[i - 1], "RIGHT", padding, 0)
        end
    elseif dir == 'BOTTOM' then
        if i == 1 then
            btn:SetPoint("TOP", self, "TOP", 0, -2 * padding)
        else
            btn:SetPoint("TOP", buttonTable[i - 1], "BOTTOM", 0, -padding)
        end
    else
        if i == 1 then
            btn:SetPoint("BOTTOM", self, "BOTTOM", 0, 2 * padding)
        else
            btn:SetPoint("BOTTOM", buttonTable[i - 1], "TOP", 0, padding)
        end
    end
end

DragonflightUISpellSubButtonMixin = {}
function DragonflightUISpellSubButtonMixin:OnLoad()
    -- print('DragonflightUISpellSubButtonMixin:OnLoad()')

    -- self:RegisterEvent("ACTIONBAR_UPDATE_STATE"); -- not updating state from lua anymore, see SetActionUIButton
    self:RegisterEvent("ACTIONBAR_UPDATE_USABLE");
    self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN"); -- not updating cooldown from lua anymore, see SetActionUIButton
    self:RegisterEvent("SPELL_UPDATE_CHARGES");
    self:RegisterEvent("UPDATE_INVENTORY_ALERTS");
    self:RegisterEvent("PLAYER_TARGET_CHANGED");
    self:RegisterEvent("TRADE_SKILL_SHOW");
    self:RegisterEvent("TRADE_SKILL_CLOSE");
    self:RegisterEvent("PLAYER_ENTER_COMBAT");
    self:RegisterEvent("PLAYER_LEAVE_COMBAT");
    self:RegisterEvent("START_AUTOREPEAT_SPELL");
    self:RegisterEvent("STOP_AUTOREPEAT_SPELL");
    self:RegisterEvent("UNIT_INVENTORY_CHANGED");
    self:RegisterEvent("LEARNED_SPELL_IN_TAB");
    self:RegisterEvent("PET_STABLE_UPDATE");
    self:RegisterEvent("PET_STABLE_SHOW");
    self:RegisterUnitEvent("LOSS_OF_CONTROL_ADDED", "player");
    self:RegisterUnitEvent("LOSS_OF_CONTROL_UPDATE", "player");
    self:RegisterEvent("SPELL_UPDATE_ICON");
    self:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW");
    self:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE");

    -- self:RegisterEvent("SPELL_UPDATE_COOLDOWN");
end

function DragonflightUISpellSubButtonMixin:OnEvent(event, ...)
    -- if self:GetID() == 1 then print(event, ...) end
    -- print(event, ...)
    self:UpdateState()
end

function DragonflightUISpellSubButtonMixin:SetSpell(spell)
    self.Spell = spell;
    self.Item = nil;
    self.ItemLink = nil;

    local name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spell)
    local learned = IsPlayerSpell(spell)

    self.Icon:SetTexture(icon)

    self:UpdateState()
end

function DragonflightUISpellSubButtonMixin:SetItem(item)
    self.Spell = nil;
    self.Item = item;

    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc,
          itemTexture, itemSellPrice = GetItemInfo(item)
    self.ItemLink = itemLink;

    self.Icon:SetTexture(itemTexture)

    self:UpdateState()
end

function DragonflightUISpellSubButtonMixin:UpdateState()
    if self.Spell then
        self:UpdateStateSpell()
    elseif self.Item then
        self:UpdateStateItem()
    end
end

function DragonflightUISpellSubButtonMixin:UpdateStateSpell()
    self.Count:SetText("");

    -- local name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spell)
    local learned = IsPlayerSpell(self.Spell)

    if learned then
        self.Icon:SetDesaturated(false);
        local powerCosts = C_Spell.GetSpellPowerCost(self.Spell)
        powerCosts = powerCosts[1]
        self.Icon:SetVertexColor(0.4, 0.4, 0.4)
        self.Icon:SetVertexColor(0.5, 0.5, 1.0)

        local hasRequiredAura = true;
        if powerCosts.requiredAuraID and powerCosts.requiredAuraID ~= 0 then
            hasRequiredAura = powerCosts.hasRequiredAura;
        end

        local power = UnitPower("player", Enum.PowerType[powerCosts.type]);
        local hasCost = power >= powerCosts.minCost;

        -- print(self.Spell, hasRequiredAura, hasCost)

        if hasRequiredAura then
            if hasCost then
                -- "usable"
                self.Icon:SetVertexColor(1.0, 1.0, 1.0)
            else
                -- "notEnoughMana"
                self.Icon:SetVertexColor(0.5, 0.5, 1.0)
            end
        else
            self.Icon:SetVertexColor(0.4, 0.4, 0.4)
        end
    else
        self.Icon:SetDesaturated(true);
        self.Icon:SetVertexColor(1.0, 1.0, 1.0)
    end

    self:UpdateCooldown()
end

function DragonflightUISpellSubButtonMixin:UpdateStateItem()
    local count = GetItemCount(self.Item, false, true)
    if (count > (self.maxDisplayCount or 9999)) then
        self.Count:SetText("*");
    else
        self.Count:SetText(count)
    end

    if count > 0 then
        self.Icon:SetVertexColor(1.0, 1.0, 1.0)
    else
        self.Icon:SetVertexColor(0.4, 0.4, 0.4)
    end

    self:UpdateCooldown()
end

local bandageIDs = {
    8545, 6450, 6451, 3531, 8544, 2581, 3530, 1251, 20244, 20235, 19068, 20067, 20232, 20065, 19067, 20237, 14529,
    19066, 20234, 20243, 20066, 14530, 19307, 23684
}
local isBandageID = {}
for k, v in ipairs(bandageIDs) do
    --
    isBandageID[v] = true;
end

function DragonflightUISpellSubButtonMixin:UpdateCooldown()
    local start, duration, enable -- , charges, maxCharges, chargeStart, chargeDuration;
    local modRate = 1.0;
    -- local chargeModRate = 1.0;

    if self.Spell then
        start, duration, enable, modRate = GetSpellCooldown(self.Spell);
    elseif self.Item then
        -- start, duration, enable, modRate = GetActionCooldown(self.action);
        -- charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetActionCharges(self.action);
        if isBandageID[self.Item] then
            -- print('bandage')
            local auraData = self:GetBandage()

            if auraData then
                start = auraData.expirationTime - auraData.duration;
                duration = auraData.duration;
                enable = true;
            end
        else
            start, duration, enable = GetItemCooldown(self.Item)
        end
    end

    if (self.cooldown.currentCooldownType ~= COOLDOWN_TYPE_NORMAL) then
        self.cooldown:SetEdgeTexture("Interface\\Cooldown\\edge");
        self.cooldown:SetSwipeColor(0, 0, 0);
        self.cooldown:SetHideCountdownNumbers(false);
        self.cooldown.currentCooldownType = COOLDOWN_TYPE_NORMAL;
    end

    -- if (charges and maxCharges and maxCharges > 1 and charges < maxCharges) then
    --     StartChargeCooldown(self, chargeStart, chargeDuration, chargeModRate);
    -- else
    --     ClearChargeCooldown(self);
    -- end

    -- if enable then
    --     self.Icon:SetVertexColor(0.4, 0.4, 0.4)
    -- else
    --     self.Icon:SetVertexColor(1.0, 1.0, 1.0)
    -- end

    CooldownFrame_Set(self.cooldown, start, duration, enable, false, modRate);
end

function DragonflightUISpellSubButtonMixin:GetBandage()
    local bandageDebuffName = GetSpellInfo(11196);

    local i = 1;
    repeat
        --
        local aura = {}

        local auraData = C_UnitAuras.GetAuraDataByIndex('player', i, 'HARMFUL');
        if (auraData == nil) then
            aura.name = nil;
        else
            aura.name = auraData.name;
            aura.duration = auraData.duration;
            aura.expires = auraData.expirationTime;
            aura.caster = auraData.sourceUnit;
            aura.shouldConsolidate = #auraData.points > 0;
        end

        if aura.name == bandageDebuffName then return auraData; end

        -- print(i, aura.name, aura.duration, aura.expires)

        i = i + 1;
    until (not aura.name)

    return nil;
end

function DragonflightUISpellSubButtonMixin:OnEnter()
    if self.Spell then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetSpellByID(self.Spell)
        GameTooltip:Show()
    elseif self.Item and self.ItemLink then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetHyperlink(self.ItemLink)
        GameTooltip:Show()
    end
end

function DragonflightUISpellSubButtonMixin:OnLeave()
    GameTooltip:Hide()
end
