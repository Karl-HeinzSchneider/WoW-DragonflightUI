local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

local noop = function()
    return false;
end

local CompanionID = nil;

local GetItemCooldown = GetItemCooldown or C_Container.GetItemCooldown;
local GetItemInfo = GetItemInfo or C_Item.GetItemInfo;
local GetItemCount = GetItemCount or C_Item.GetItemCount;
local GetSpellPowerCost = GetSpellPowerCost or C_Spell.GetSpellPowerCost;
local PickupSpell = PickupSpell or C_Spell.PickupSpell
local PickupItem = PickupItem or C_Item.PickupItem;

local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar'
local textureRefTwo = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'

DragonflightUISpellFlyoutButtonMixin = {}

function DragonflightUISpellFlyoutButtonMixin:OnLoad()
    -- print('DragonflightUISpellFlyoutButtonMixin:OnLoad()')

    Mixin(self, DragonflightUIStateHandlerMixin)
    self:InitStateHandler()

    local flyoutModule = DF:GetModule('Flyout')
    self.ModuleRef = flyoutModule;

    self.MaxButtons = 12;
    self:InitButtons()

    self:AddArrow()
    self:UpdateArrow()

    self:RegisterEvent('UPDATE_BINDINGS')
end

function DragonflightUISpellFlyoutButtonMixin:OnEvent(event, ...)
    if event == 'UPDATE_BINDINGS' then
        self:UpdateHotkeyDisplayText()
        return;
    end
end

function DragonflightUISpellFlyoutButtonMixin:OnEnter()
    local char = self.stateChar
    if not char then return end

    if char.displayName == '' and char.tooltip == '' then return end

    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    if char.displayName ~= '' then GameTooltip:SetText(char.displayName, 1.0, 1.0, 1.0); end
    if char.tooltip ~= '' then
        GameTooltip:AddLine(char.tooltip, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true);
    end
    GameTooltip:Show()
end

function DragonflightUISpellFlyoutButtonMixin:OnLeave()
    GameTooltip:Hide()
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
        
        local attributeFrame = self:GetFrameRef("attributeFrame")
        attributeFrame:SetAttribute('update', not attributeFrame:GetAttribute('update'))
    ]=]);
    frame:RegisterForClicks("AnyUp");
    frame:SetFrameRef("frame1", f);
    self.Frame = frame;

    frame:HookScript('OnClick', function()
        --
        -- print('onclick')
        local state = self.state;
        local char = self.stateChar
        self:UpdateArrow(char.flyoutDirection or '')
    end)

    -- frame:SetSize(69, 69)
    frame:SetPoint('TOP', UIParent, 'BOTTOM', -666, -666)

    -- handler
    local handler = CreateFrame('Frame', 'DragonflightUISpellFlyoutHandler', nil, 'SecureHandlerBaseTemplate');
    local id = self:GetID() - 1000;
    -- print(n, id, '=', (id - 1) * 12 + 1, '-', (id - 1) * 12 + 12)

    handler:SetFrameRef('flyout', f)

    self.Handler = handler;

    RegisterStateDriver(handler, "cursor", "[cursor] true; false")
    RegisterStateDriver(handler, "combat", "[combat] true; false")

    -- attribute
    local attributeFrame = CreateFrame("FRAME", "DragonflightUISpellFlyoutAttributeHandler", nil,
                                       "SecureHandlerAttributeTemplate");
    attributeFrame:SetFrameRef('shower', self.DFShower)
    attributeFrame:SetFrameRef('mouse', self.DFMouseHandler)
    attributeFrame:SetFrameRef('flyout', f)
    attributeFrame:SetFrameRef('parent', self)

    attributeFrame:SetAttribute("_onattributechanged", [=[
        -- print('_onattributechanged',name)

        local parent = control:GetFrameRef("parent")

        local dir = control:GetAttribute('dir')
        local w = control:GetAttribute('w')
        local h = control:GetAttribute('h')
        -- print('state:',dir,w,h)    

        local shower = control:GetFrameRef("shower")
        local mouse = control:GetFrameRef("mouse")
        shower:ClearAllPoints()
        mouse:ClearAllPoints() 

        local flyout = control:GetFrameRef("flyout")
        if flyout and flyout:IsShown() then
            if dir == 'LEFT' then
                mouse:SetPoint('TOPRIGHT', parent, 'TOPRIGHT', 2, 2)
                mouse:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', 2, -2)
                mouse:SetPoint('LEFT', flyout, 'LEFT', -2, 0)

                shower:SetPoint('TOPRIGHT', parent, 'TOPRIGHT', 2, 2)
                shower:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', 2, -2)
                shower:SetPoint('LEFT', flyout, 'LEFT', -2, 0)
            elseif dir == 'RIGHT' then
                mouse:SetPoint('TOPLEFT', parent, 'TOPLEFT', -2, 2)
                mouse:SetPoint('BOTTOMLEFT', parent, 'BOTTOMLEFT', -2, -2)
                mouse:SetPoint('RIGHT', flyout, 'RIGHT', 2, 0)

                shower:SetPoint('TOPLEFT', parent, 'TOPLEFT', -2, 2)
                shower:SetPoint('BOTTOMLEFT', parent, 'BOTTOMLEFT', -2, -2)
                shower:SetPoint('RIGHT', flyout, 'RIGHT', 2, 0)
            elseif dir == 'BOTTOM' then
                mouse:SetPoint('TOPRIGHT', parent, 'TOPRIGHT', 2, 2)
                mouse:SetPoint('TOPLEFT', parent, 'TOPLEFT', -2, 2)
                mouse:SetPoint('BOTTOM', flyout, 'BOTTOM', 0, -2)

                shower:SetPoint('TOPRIGHT', parent, 'TOPRIGHT', 2, 2)
                shower:SetPoint('TOPLEFT', parent, 'TOPLEFT', -2, 2)
                shower:SetPoint('BOTTOM', flyout, 'BOTTOM', 0, -2)
            else
                mouse:SetPoint('BOTTOMLEFT', parent, 'BOTTOMLEFT', -2, -2)
                mouse:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', 2, -2)
                mouse:SetPoint('TOP', flyout, 'TOP', 0, 2)

                shower:SetPoint('BOTTOMLEFT', parent, 'BOTTOMLEFT', -2, -2)
                shower:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', 2, -2)
                shower:SetPoint('TOP', flyout, 'TOP', 0, 2)
            end
        else 
            shower:SetPoint('TOPLEFT',parent,'TOPLEFT',-2,2)
            shower:SetPoint('BOTTOMRIGHT',parent,'BOTTOMRIGHT',2,-2)

            mouse:SetPoint('TOPLEFT',parent,'TOPLEFT',-2,2)
            mouse:SetPoint('BOTTOMRIGHT',parent,'BOTTOMRIGHT',2,-2)
        end   
    ]=]);
    self.AttributeFrame = attributeFrame
    frame:SetFrameRef("attributeFrame", attributeFrame);
    handler:SetFrameRef("attributeFrame", attributeFrame);

    --
    local t = {}
    for i = 1, self.MaxButtons do
        --    
        local btn = CreateFrame("Button", n .. 'Sub' .. i, self.BG, "DFSpellFlyoutSubButtonTemplate");
        btn:SetAttribute('DFAction', (id - 1) * 12 + i)
        -- print(i, n, btn:GetName(), btn:GetAttribute('DFAction'))

        DragonflightUIActionbarMixin:StyleButton(btn);
        btn:SetScale(0.8);
        btn:SetSize(45, 45)
        -- btn:Show()

        t[i] = btn;
        self:SetHideFrame(btn, i + 1)

        btn:SetFrameLevel(3)
        btn.Icon:SetTexture(136082)

        btn.Count = _G[btn:GetName() .. 'Count']
        btn.Count:SetText('69')

        btn.Name = _G[btn:GetName() .. 'Name']

        handler:WrapScript(btn, 'OnClick', [[
            -- print('wraped OnClick')

            local inCombatState = control:GetAttribute('state-combat')
            local inCombat = inCombat == 'true'

            local cursorState = control:GetAttribute('state-cursor')
            local hasCursor = cursorState == 'true'

            if hasCursor and not inCombat then             
                self:CallMethod('OnReceiveDrag')
                return false;    
            end         

            local flyout = control:GetFrameRef("flyout")
            local closeAfterClick = control:GetAttribute('closeAfterClick')
            if flyout and flyout:IsShown() and closeAfterClick then
                flyout:Hide()
            end      
            
            local attributeFrame = control:GetFrameRef("attributeFrame")
            attributeFrame:SetAttribute('update', not attributeFrame:GetAttribute('update'))
        ]])

        btn:HookScript('OnClick', function()
            --
            -- print('onclick')
            local state = self.state;
            local char = self.stateChar
            self:UpdateArrow(char.flyoutDirection or '')
        end)
    end

    self.buttonTable = t;

    self:SetScript('OnLeave', function()
        GameTooltip:Hide()
    end)
end
-- function DragonflightUISpellFlyoutButtonMixin:OnLoad()
-- end

function DragonflightUISpellFlyoutButtonMixin:SetState(state, char)
    self.state = state
    self.stateChar = char
    self.savedAlwaysShow = state.alwaysShow
    self:Update()
end

function DragonflightUISpellFlyoutButtonMixin:Update()
    -- print('DragonflightUISpellFlyoutButtonMixin:Update()')
    local state = self.state
    local char = self.stateChar

    self.Icon:SetTexture(char.icon or 136082)

    self:UpdateArrow(char.flyoutDirection)

    do
        local name = self:GetName()
        local macroText = _G[name .. 'Name']
        local keybindText = _G[name .. 'HotKey']

        if macroText then
            if state.hideMacro then
                macroText:SetAlpha(0)
            else
                macroText:SetAlpha(1)
            end

            self:SetMacroFontSize(state.macroFontSize)
        end

        if keybindText then
            if state.hideKeybind then
                keybindText:SetAlpha(0)
            else
                keybindText:SetAlpha(1)
            end

            self:SetKeybindFontSize(state.keybindFontSize)

            self:UpdateHotkeyDisplayText(state.shortenKeybind)
        end
    end
    local buttonTable = self.buttonTable
    local btnCount = #buttonTable
    local buttons = math.min(char.buttons, btnCount)

    for i = buttons + 1, btnCount do
        local btn = buttonTable[i]
        btn:ClearAllPoints()
        btn:SetPoint('CENTER', UIParent, 'BOTTOM', 0, -666)
        btn:Hide()
        -- print('hide', i)
    end

    self.BG:SetState(char, buttons)

    self.Handler:SetAttribute('closeAfterClick', char.closeAfterClick)

    for i = 1, buttons do
        local btn = buttonTable[i]
        self.BG:SetButton(btn, i, buttonTable)

        btn.ModuleRef = self.ModuleRef;
        btn:UpdateAction()

        if state.alwaysShow then
            btn:SetAttribute("showgrid", 1)
        else
            btn:SetAttribute("showgrid", 0)
        end

        local name = btn:GetName()
        local macroText = _G[name .. 'Name']
        local keybindText = _G[name .. 'HotKey']

        if macroText then
            if state.hideMacro then
                macroText:SetAlpha(0)
            else
                macroText:SetAlpha(1)
            end

            btn:SetMacroFontSize(state.macroFontSize)
        end

        if keybindText then
            if state.hideKeybind then
                keybindText:SetAlpha(0)
            else
                keybindText:SetAlpha(1)
            end

            btn:SetKeybindFontSize(state.keybindFontSize)

            btn:UpdateHotkeyDisplayText(state.shortenKeybind)
        end
    end

    for i = buttons + 1, btnCount do
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

    self:UpdateStateHandler(state, char.activate)
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

    local attributeFrame = parent.AttributeFrame
    attributeFrame:SetAttributeNoHandler('dir', dir)
    attributeFrame:SetAttributeNoHandler('w', w)
    attributeFrame:SetAttributeNoHandler('h', h)
    attributeFrame:SetAttribute('update', not attributeFrame:GetAttribute('update'))
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

    self:RegisterEvent('UPDATE_BINDINGS')

    -- self:RegisterEvent("SPELL_UPDATE_COOLDOWN");

    self:RegisterForDrag("LeftButton")
    -- btn:HookScript('OnDragStart', function()
    --     print('OnDragStart')
    -- end)

    -- btn:HookScript('OnReceiveDrag', function()
    --     print('OnReceiveDrag')
    -- end)

    self.DFNormalTexture = _G[self:GetName() .. 'NormalTexture']
end

function DragonflightUISpellSubButtonMixin:OnEvent(event, ...)
    -- if self:GetAttribute('DFAction') == 1 then print(event, ...) end
    -- print(event, ...)
    if event == 'UPDATE_BINDINGS' then
        self:UpdateHotkeyDisplayText()
        return;
    end
    self:UpdateState()
end

function DragonflightUISpellSubButtonMixin:UpdateAction()
    local DFAction = self:GetAttribute('DFAction');
    local actionTable = self.ModuleRef:GetAction(DFAction)

    self:SetAttribute("IsEquipmentset", false);
    self:SetAttribute("IsMount", false);

    if actionTable then
        local type = actionTable.type;
        local value = actionTable.value;
        -- print('~UpdateAction()', DFAction, type, value)

        if type == 'spell' then
            self:SetAttribute("type", "spell");
            self:SetAttribute("spell", value);
        elseif type == 'item' then
            self:SetAttribute("type", "item");
            self:SetAttribute("item", "item:" .. value);
            self:SetAttribute("itemID", value); -- custom

            -- self:SetAttribute("unit", "player");
        elseif type == 'macro' then
            self:SetAttribute("type", "macro");
            self:SetAttribute("macro", value);
        elseif type == 'equipmentset' then
            -- print('~~equipmentSet')
            local t = "/equipset " .. value
            -- print(t)
            self:SetAttribute("type", "macro");
            self:SetAttribute("macrotext", t);
            self:SetAttribute("IsEquipmentset", true); -- custom
            self:SetAttribute('equipmentsetName', value); -- custom
        elseif type == 'toy' then
            self:SetAttribute("type", "toy")
            self:SetAttribute("toy", value)
        elseif type == 'mount' then
            local name, spellID, icon, isActive, isUsable, sourceType, isFavorite, isFactionSpecific, faction,
                  shouldHideOnChar, isCollected, mountID = C_MountJournal.GetMountInfoByID(value)
            -- local t = "/cast " .. name .. ""
            local t = "/run C_MountJournal.SummonByID(" .. value .. ')'
            -- print(t)
            self:SetAttribute("type", "macro");
            self:SetAttribute("macrotext", t);
            self:SetAttribute("IsMount", true); -- custom
            self:SetAttribute('mountID', value); -- custom
        else
            self:SetAttribute("type", nil);
        end
    else
        -- print(DFAction, 'NIL', 'NIL')
        self:SetAttribute("type", nil);
    end

    self:UpdateState()
end

function DragonflightUISpellSubButtonMixin:UpdateState()
    local type = self:GetAttribute('type');
    -- print('UpdateState', type, self:GetAttribute('IsEquipmentset'))

    if type == 'spell' then
        self:UpdateStateSpell()
    elseif type == 'item' then
        self:UpdateStateItem()
    elseif type == 'macro' and (self:GetAttribute('IsEquipmentset') == true) then
        self:UpdateStateEquipmentset()
    elseif type == 'macro' and (self:GetAttribute('IsMount') == true) then
        self:UpdateStateMount()
    elseif type == 'macro' then
        self:UpdateStateMacro()
    elseif type == 'toy' then
        self:UpdateStateToy()
    else
        self:UpdateStateEmpty()
    end
    self:UpdateHotkeyDisplayText()
end

function DragonflightUISpellSubButtonMixin:UpdateStateSpell()
    local Spell = self:GetAttribute('spell');

    self.PickupFunc = function()
        PickupSpell(Spell);
        return true;
    end

    local name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(Spell)
    self.Icon:SetTexture(icon)

    -- local name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spell)
    local learned = IsPlayerSpell(Spell)

    if learned then
        self.Icon:SetDesaturated(false);
        local powerCosts = GetSpellPowerCost(Spell)
        local hasRequiredAura = true;
        local hasCost = true;
        if powerCosts and powerCosts[1] then
            powerCosts = powerCosts[1]
            if powerCosts.requiredAuraID and powerCosts.requiredAuraID ~= 0 then
                hasRequiredAura = powerCosts.hasRequiredAura;
            end

            local power = UnitPower("player", Enum.PowerType[powerCosts.type]);
            hasCost = power >= powerCosts.minCost;
        else
        end
        self.Icon:SetVertexColor(0.4, 0.4, 0.4)
        self.Icon:SetVertexColor(0.5, 0.5, 1.0)

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

    local numCasts = GetSpellCount(Spell)

    if numCasts and numCasts > 0 then
        self.Count:SetText(numCasts);
    else
        self.Count:SetText("");
    end

    self.Name:SetText('')

    self:UpdateCooldown()
end

function DragonflightUISpellSubButtonMixin:UpdateStateItem()
    local Item = self:GetAttribute('itemID');

    self.PickupFunc = function()
        PickupItem(Item)
        return true;
    end

    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc,
          itemTexture, itemSellPrice = GetItemInfo(Item)
    self.Icon:SetTexture(itemTexture)

    local count = GetItemCount(Item, false, true)
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

    self.Name:SetText('')

    self:UpdateCooldown()
end

function DragonflightUISpellSubButtonMixin:UpdateStateMacro()
    local macroName = self:GetAttribute('macro');

    self.PickupFunc = function()
        PickupMacro(macroName)
        return true;
    end;

    local name, icon, body = GetMacroInfo(macroName)

    self.Count:SetText('')
    self.Icon:SetVertexColor(1.0, 1.0, 1.0)
    self.Icon:SetTexture(icon)

    self.Name:SetText(macroName)

    self:UpdateCooldown()
end

function DragonflightUISpellSubButtonMixin:UpdateStateToy()
    local toyID = self:GetAttribute('toy');

    self.PickupFunc = function()
        C_ToyBox.PickupToyBoxItem(toyID);
        return true;
    end;

    local itemID, toyName, icon, isFavorite, hasFanfare = C_ToyBox.GetToyInfo(toyID);

    self.Count:SetText('')
    self.Icon:SetVertexColor(1.0, 1.0, 1.0)
    self.Icon:SetTexture(icon)

    self.Name:SetText('')

    self:UpdateCooldown()
end

function DragonflightUISpellSubButtonMixin:UpdateStateMount()
    local mountID = self:GetAttribute('mountID');
    local name, spellID, icon, isActive, isUsable, sourceType, isFavorite, isFactionSpecific, faction, shouldHideOnChar,
          isCollected, id = C_MountJournal.GetMountInfoByID(mountID)

    -- print('UpdateStateMount', mountID, spellID)

    self.PickupFunc = function()
        -- C_MountJournal.Pickup(mountID)
        C_Spell.PickupSpell(spellID);
        self.ModuleRef.CursorMountID = mountID
        self.ModuleRef.PreCursorMountSpellID = spellID
        return true;
    end;

    -- 
    self.Count:SetText('')
    -- self.Icon:SetVertexColor(1.0, 1.0, 1.0)

    if isUsable then
        self.Icon:SetVertexColor(1.0, 1.0, 1.0)
    else
        self.Icon:SetVertexColor(0.4, 0.4, 0.4)
    end

    if isActive then
        self.Icon:SetTexture(136116)
    else
        self.Icon:SetTexture(icon)
    end

    -- self.Name:SetText(name)
    self.Name:SetText('')

    -- self:UpdateCooldown()
end

function DragonflightUISpellSubButtonMixin:UpdateStateEquipmentset()
    local equipName = self:GetAttribute('equipmentsetName');
    local id = C_EquipmentSet.GetEquipmentSetID(equipName)

    self.PickupFunc = function()
        C_EquipmentSet.PickupEquipmentSet(id)
        return true;
    end;

    local name, texture, setID, isEquipped, numItems, equippedItems, availableItems, missingItems, ignoredSlots =
        C_EquipmentSet.GetEquipmentSetInfo(id)

    self.Count:SetText('')
    self.Icon:SetVertexColor(1.0, 1.0, 1.0)
    self.Icon:SetTexture(texture)

    self.Name:SetText(name)

    self:UpdateCooldown()
end

function DragonflightUISpellSubButtonMixin:UpdateStateEmpty()
    self.Count:SetText("");
    self.Icon:SetVertexColor(1.0, 1.0, 1.0)
    self.Icon:SetTexture()
    self.Name:SetText('')

    self.PickupFunc = noop;
    self:UpdateCooldown()
end

local bandageIDs = {
    2581, 3530, 6450, 6451, 8545, 1251, 8544, 44646, 3531, 20244, 20235, 20067, 19068, 20065, 20237, 19067, 20232,
    14529, 20066, 19066, 20234, 20243, 14530, 19307, 21990, 21991, 34721, 38643, 34722, 53049, 53050, 63391, 38640,
    64995, 53051, 72985, 82829, 72986, 72987, 82830
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
    local type = self:GetAttribute('type');

    if type == 'spell' then
        local Spell = self:GetAttribute('spell');
        start, duration, enable, modRate = GetSpellCooldown(Spell);
    elseif type == 'item' then
        local Item = self:GetAttribute('itemID');
        -- start, duration, enable, modRate = GetActionCooldown(self.action);
        -- charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetActionCharges(self.action);
        if isBandageID[Item] then
            -- print('bandage')
            local auraData = self:GetBandage()

            if auraData then
                start = auraData.expirationTime - auraData.duration;
                duration = auraData.duration;
                enable = true;
            end
        else
            start, duration, enable = GetItemCooldown(Item)
        end
    elseif type == 'toy' then
        local toyID = self:GetAttribute('toy');
        start, duration, enable = GetItemCooldown(toyID)
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
    local type = self:GetAttribute('type');

    if type == 'spell' then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetSpellByID(self:GetAttribute('spell'))
        GameTooltip:Show()
    elseif type == 'item' then
        local Item = self:GetAttribute('itemID');
        local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
              itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(Item)
        if not itemName or not itemLink then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetHyperlink(itemLink)
        GameTooltip:Show()
    elseif type == 'macro' and (self:GetAttribute('IsEquipmentset') == true) then
        -- print('equip onenter')
        local equipName = self:GetAttribute('equipmentsetName');

        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetEquipmentSet(equipName)
        GameTooltip:Show()
    elseif type == 'macro' and (self:GetAttribute('IsMount') == true) then
        local mountID = self:GetAttribute('mountID');
        local name, spellID, icon, isActive, isUsable, sourceType, isFavorite, isFactionSpecific, faction,
              shouldHideOnChar, isCollected, id = C_MountJournal.GetMountInfoByID(mountID)

        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetSpellByID(spellID)
        GameTooltip:Show()
    elseif type == 'macro' then
        local macroName = self:GetAttribute('macro');
        local tt = DF:GetModule('Tooltip')

        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        tt:SetMacroTooltip(GameTooltip, macroName)
        GameTooltip:Show()
    elseif type == 'toy' then
        local toyID = self:GetAttribute('toy');
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetToyByItemID(toyID)
        GameTooltip:Show()
    elseif type == 'companion' then
        -- local petID = self:GetAttribute('petID');

        -- GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        -- ---@diagnostic disable-next-line: redundant-parameter
        -- GameTooltip:SetCompanionPet(petID);
        -- GameTooltip:Show();
    end
end

function DragonflightUISpellSubButtonMixin:OnLeave()
    GameTooltip:Hide()
end

function DragonflightUISpellSubButtonMixin:OnDragStart()
    if InCombatLockdown() then return end

    local doDrag = (not Settings.GetValue("lockActionBars") or IsModifiedClick("PICKUPACTION"));
    if not doDrag then return end

    -- print('DragonflightUISpellSubButtonMixin:OnDragStart()')

    -- if self.Spell then
    --     PickupSpell(self.Spell)
    -- elseif self.Item then
    --     PickupItem(self.Item)
    -- end

    local pickupCurrent = self.PickupFunc
    local didPickup = pickupCurrent()

    if didPickup then
        local DFAction = self:GetAttribute('DFAction');
        self.ModuleRef:SetAction(DFAction, nil, nil)
        self:UpdateAction()
    end
end

function DragonflightUISpellSubButtonMixin:OnReceiveDrag()
    if InCombatLockdown() then return end
    local infoType = GetCursorInfo()
    -- print('DragonflightUISpellSubButtonMixin:OnReceiveDrag()', infoType)
    -- DevTools_Dump({GetCursorInfo()})

    local DFAction = self:GetAttribute('DFAction');
    local pickupCurrent = self.PickupFunc

    if infoType == 'spell' then
        local _, spellIndex, bookType, spellID = GetCursorInfo()
        -- print(spellIndex, bookType, spellID)
        self.ModuleRef:SetAction(DFAction, 'spell', spellID)
        self:UpdateAction()

        ClearCursor()
        pickupCurrent()
    elseif infoType == 'item' then
        local _, itemID, itemLink = GetCursorInfo()
        -- print(itemID, itemLink)       

        if PlayerHasToy and PlayerHasToy(itemID) then
            -- print('TOY', itemID)
            self.ModuleRef:SetAction(DFAction, 'toy', itemID)
            self:UpdateAction()
        else
            self.ModuleRef:SetAction(DFAction, 'item', itemID)
            self:UpdateAction()
        end

        ClearCursor()
        pickupCurrent()
    elseif infoType == 'macro' then
        local _, index = GetCursorInfo()
        -- print(infoType, index)
        local name, icon, body = GetMacroInfo(index)
        self.ModuleRef:SetAction(DFAction, 'macro', name)
        self:UpdateAction()

        ClearCursor()
        pickupCurrent()
    elseif infoType == 'equipmentset' then
        local _, name, itemLink = GetCursorInfo()
        local id = C_EquipmentSet.GetEquipmentSetID(name)
        -- print(infoType, name, id)

        -- self.ModuleRef:SetAction(DFAction, 'equipmentset', id)
        self.ModuleRef:SetAction(DFAction, 'equipmentset', name)
        self:UpdateAction()

        ClearCursor()
        pickupCurrent()
    elseif infoType == 'companion' then
        local _, mountID, mountIndex = GetCursorInfo()

        if mountIndex == 'MOUNT' then
            -- print(infoType, mountID, mountIndex)

            self.ModuleRef:SetAction(DFAction, 'mount', self.ModuleRef.CursorMountID)
            -- self.ModuleRef:SetAction(DFAction, 'spell', self.ModuleRef.CursorMountSpellID)

            self:UpdateAction()

            ClearCursor()
            pickupCurrent()
        end
    end
end
