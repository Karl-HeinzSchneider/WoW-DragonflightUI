local ESCAPE_TO_UNBIND = ESCAPE_TO_UNBIND or "Press the escape key to unbind this action."

local NOT_BOUND = NOT_BOUND or "Not Bound"

local PRESS_KEY_TO_BIND = PRESS_KEY_TO_BIND or "Press a key to set the binding for this action."

local QUICK_KEYBIND_DESCRIPTION = QUICK_KEYBIND_DESCRIPTION or
                                      "You are in Quick Keybind Mode. Mouse over a button and press the desired key to set the binding for that button.";
local QUICK_KEYBIND_CANCEL_DESCRIPTION = QUICK_KEYBIND_CANCEL_DESCRIPTION or
                                             'Canceling will remove you from Quick Keybind Mode.'

local QUICK_KEYBIND_MODE = QUICK_KEYBIND_MODE or 'Quick Keybind Mode'

-------------------

local DragonflightUIQuickKeybindButtonOverlay

DragonFlightUIQuickKeybindButtonOverlayMixin = {}

function DragonFlightUIQuickKeybindButtonOverlayMixin:OnLoad()
    DragonflightUIQuickKeybindButtonOverlay = self
end

function DragonFlightUIQuickKeybindButtonOverlayMixin:OnEnter()
    self:UpdateTooltip()
end

function DragonFlightUIQuickKeybindButtonOverlayMixin:OnLeave()
    self:ClearButton()
end

function DragonFlightUIQuickKeybindButtonOverlayMixin:OnKeyDown(input)
    -- print('ButtonOverlayMixin:OnKeyDown', input)
    DragonflightUIQuickKeybindFrame:OnKeyDown(input)
end

function DragonFlightUIQuickKeybindButtonOverlayMixin:OnMouseUp(input)
    -- print('DragonFlightUIQuickKeybindButtonOverlayMixin:OnMouseUp()', input)
    DragonflightUIQuickKeybindFrame:OnKeyDown(input)
end

function DragonFlightUIQuickKeybindButtonOverlayMixin:OnMouseWheel(delta)
    -- print('DragonFlightUIQuickKeybindButtonOverlayMixin:OnMouseWheel()', delta)
    if delta > 0 then
        DragonflightUIQuickKeybindFrame:OnKeyDown('MOUSEWHEELUP')
    else
        DragonflightUIQuickKeybindFrame:OnKeyDown('MOUSEWHEELDOWN')
    end
end

function DragonFlightUIQuickKeybindButtonOverlayMixin:SetButton(btn)
    self.buttonRef = btn
    self.command = btn.command
    self.commandHuman = btn.commandHuman

    self:ClearAllPoints()
    self:SetAllPoints(btn)
    self:Show()

    DragonflightUIQuickKeybindFrame:SetSelected(btn.command, btn)
end

function DragonFlightUIQuickKeybindButtonOverlayMixin:ClearButton()
    self.command = nil
    self.commandHuman = nil

    self:Hide()
    GameTooltip:Hide()

    DragonflightUIQuickKeybindFrame:SetSelected(nil, nil)
end

function DragonFlightUIQuickKeybindButtonOverlayMixin:UpdateTooltip()
    GameTooltip:ClearLines();
    GameTooltip:SetOwner(self, "ANCHOR_TOP");
    -- GameTooltip:AddDoubleLine("Left", "Right", 1, 0, 0, 0, 0, 1);

    -- GameTooltip_AddHighlightLine(GameTooltip, 'GameTooltip_AddHighlightLine')
    -- GameTooltip_AddInstructionLine(GameTooltip, 'GameTooltip_AddInstructionLine')
    -- GameTooltip_AddNormalLine(GameTooltip, 'GameTooltip_AddNormalLine')
    -- GameTooltip_AddErrorLine(GameTooltip, 'GameTooltip_AddErrorLine')
    -- print('commands', self.command)
    local command = self.command
    local commandHuman = self.commandHuman

    GameTooltip_AddHighlightLine(GameTooltip, commandHuman)
    GameTooltip_AddHighlightLine(GameTooltip, '(' .. command .. ')')

    local keys = {GetBindingKey(self.command)}

    local hasKeybindings = #keys > 0

    if hasKeybindings then
        GameTooltip_AddInstructionLine(GameTooltip, table.concat(keys, ", "))
        GameTooltip_AddNormalLine(GameTooltip, ESCAPE_TO_UNBIND)
    else
        GameTooltip_AddErrorLine(GameTooltip, NOT_BOUND)
        GameTooltip_AddNormalLine(GameTooltip, PRESS_KEY_TO_BIND)
    end

    GameTooltip:Show();
end

DragonFlightUIQuickKeybindMixin = {}

local DragonflightUIQuickKeybindFrame

function DragonFlightUIQuickKeybindMixin:OnLoad()
    DragonflightUIQuickKeybindFrame = self

    self.InstructionText:SetText(QUICK_KEYBIND_DESCRIPTION)
    self.CancelDescriptionText:SetText(QUICK_KEYBIND_CANCEL_DESCRIPTION)
    self.Header.Text:SetText(QUICK_KEYBIND_MODE)

    self.CancelButton:SetText(CANCEL);
    self.CancelButton:SetScript("OnClick", function(button, buttonName, down)
        self:CancelBinding();
    end);

    self.OkayButton:SetText(OKAY);
    self.OkayButton:SetScript("OnClick", function(button, buttonName, down)
        KeybindListener:Commit();

        HideUIPanel(self);
    end);

    self.DefaultsButton:SetText(RESET_TO_DEFAULT);
    self.DefaultsButton:SetScript("OnClick", function(button, buttonName, down)
        StaticPopup_Show("CONFIRM_RESET_TO_DEFAULT_KEYBINDINGS");
    end);

    self.UseCharacterBindingsButton.Text:SetText(HIGHLIGHT_FONT_COLOR_CODE .. CHARACTER_SPECIFIC_KEYBINDINGS ..
                                                     FONT_COLOR_CODE_CLOSE);
    self.UseCharacterBindingsButton:SetScript("OnClick", function(button, buttonName, down)
        -- Button may be re-checked if the binding has been intercepted by a dialog. See OnCharacterBindingsChanged
        -- where the check box will be updated once the backing value is actually updated.
        Settings.TryChangeBindingSet(button);
    end);

    Settings.SetOnValueChangedCallback("PROXY_CHARACTER_SPECIFIC_BINDINGS", self.OnCharacterBindingsChanged, self);

    EventRegistry:RegisterCallback("KeybindListener.UnbindFailed", self.OnKeybindUnbindFailed, self);
    EventRegistry:RegisterCallback("KeybindListener.RebindFailed", self.OnKeybindRebindFailed, self);
    EventRegistry:RegisterCallback("KeybindListener.RebindSuccess", self.OnKeybindRebindSuccess, self);

    -- debug
    if false then
        EventRegistry:RegisterCallback("KeybindListener.StartedListening", function(self, action, slotIndex)
            print('StartedListening', action, slotIndex)
        end, self);
        EventRegistry:RegisterCallback("KeybindListener.StoppedListening", function(self, oldAction, slotIndex)
            print('StoppedListening', oldAction, slotIndex)
        end, self);
    end

    self:HookButtons()
end

function DragonFlightUIQuickKeybindMixin:OnShow()
    local isCharacterSet = GetCurrentBindingSet() == Enum.BindingSet.Character;
    self.UseCharacterBindingsButton:SetChecked(isCharacterSet);

    self:ClearOutputText();

    self.mouseOverButton = nil;

    -- ActionButtonUtil.ShowAllActionButtonGrids();
    -- ActionButtonUtil.ShowAllQuickKeybindButtonHighlights();
    local showQuickKeybindEffects = true;
    -- ACTION BARS TODO: Re-enable these effects with proper art
    -- MainMenuBar:SetQuickKeybindModeEffectsShown(showQuickKeybindEffects);
    -- MultiActionBar_SetAllQuickKeybindModeEffectsShown(showQuickKeybindEffects);
    -- ExtraActionBar_ForceShowIfNeeded();

    self.InQuickKeybindMode = true
    EventRegistry:TriggerEvent("DragonflightUI.ToggleQuickKeybindMode", true);
end

function DragonFlightUIQuickKeybindMixin:OnHide()
    self.InQuickKeybindMode = false
    EventRegistry:TriggerEvent("DragonflightUI.ToggleQuickKeybindMode", false);
end

function DragonFlightUIQuickKeybindMixin:IsInQuickKeybindMode()
    return self.InQuickKeybindMode
end

function DragonFlightUIQuickKeybindMixin:CancelBinding()
    LoadBindings(GetCurrentBindingSet());
    KeybindListener:StopListening();
    HideUIPanel(self);
end

function DragonFlightUIQuickKeybindMixin:HookButtons()

    local ActionBarButtonNames = {
        "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarRightButton",
        "MultiBarLeftButton"
    }

    for b, actionBar in ipairs(ActionBarButtonNames) do
        for i = 1, 12 do
            local btn = _G[actionBar .. i]

            if b == 1 then
                btn.command = 'ACTIONBUTTON' .. i
            else
                btn.command = 'MULTIACTIONBAR' .. (b - 1) .. 'BUTTON' .. i
            end
            btn.commandHuman = 'Action Bar ' .. b .. ' Button ' .. i

            btn:HookScript('OnEnter', function(selfButton)
                if DragonflightUIQuickKeybindFrame:IsInQuickKeybindMode() then
                    DragonflightUIQuickKeybindButtonOverlay:SetButton(selfButton)
                end
            end)
        end
    end

    for i = 1, 10 do
        --
        local btn = _G['StanceButton' .. i]

        btn.command = 'SHAPESHIFTBUTTON' .. i
        btn.commandHuman = 'Special Action Button ' .. i

        btn:HookScript('OnEnter', function(selfButton)
            if DragonflightUIQuickKeybindFrame:IsInQuickKeybindMode() then
                DragonflightUIQuickKeybindButtonOverlay:SetButton(selfButton)
            end
        end)
    end

    for i = 1, 10 do
        --
        local btn = _G['PetActionButton' .. i]

        btn.command = 'BONUSACTIONBUTTON' .. i
        btn.commandHuman = 'Pet Action Button ' .. i

        btn:HookScript('OnEnter', function(selfButton)
            if DragonflightUIQuickKeybindFrame:IsInQuickKeybindMode() then
                DragonflightUIQuickKeybindButtonOverlay:SetButton(selfButton)
            end
        end)
    end
end

function DragonFlightUIQuickKeybindMixin:HookExtraButtons()
    -- print('DragonFlightUIQuickKeybindMixin:HookExtraButtons()')
    -- "DragonflightUIMultiactionBar" .. n .. "Button" .. i

    local ActionBarButtonNames = {
        "DragonflightUIMultiactionBar6Button", "DragonflightUIMultiactionBar7Button",
        "DragonflightUIMultiactionBar8Button"
    }

    for b, actionBar in ipairs(ActionBarButtonNames) do
        for i = 1, 12 do
            local btn = _G[actionBar .. i]

            btn:HookScript('OnEnter', function(selfButton)
                if DragonflightUIQuickKeybindFrame:IsInQuickKeybindMode() then
                    DragonflightUIQuickKeybindButtonOverlay:SetButton(selfButton)
                end
            end)
        end
    end
end

function DragonFlightUIQuickKeybindMixin:HookCustomFlyoutButtons()
    for f = 1, 10 do
        local expander = _G['DragonflightUISpellFlyoutCustom' .. f .. 'Button']

        expander.command = "CLICK DragonflightUISpellFlyoutCustom" .. f .. "Button:Keybind"
        expander.commandHuman = "Custom Flyout " .. f .. " Expand"

        expander:HookScript('OnEnter', function(selfButton)
            if DragonflightUIQuickKeybindFrame:IsInQuickKeybindMode() then
                DragonflightUIQuickKeybindButtonOverlay:SetButton(selfButton)
            end
        end)

        for i = 1, 12 do
            local btn = _G['DragonflightUISpellFlyoutCustom' .. f .. 'ButtonSub' .. i]

            btn.command = "CLICK DragonflightUISpellFlyoutCustom" .. f .. "ButtonSub" .. i .. ":Keybind"
            btn.commandHuman = "Custom Flyout " .. f .. " Button " .. i

            btn:HookScript('OnEnter', function(selfButton)
                if DragonflightUIQuickKeybindFrame:IsInQuickKeybindMode() then
                    DragonflightUIQuickKeybindButtonOverlay:SetButton(selfButton)
                end
            end)
        end
    end
end

function DragonFlightUIQuickKeybindMixin:OnMouseWheel()
end

function DragonFlightUIQuickKeybindMixin:OnDragStart()
    self:StartMoving();
end

function DragonFlightUIQuickKeybindMixin:OnDragStop()
    self:StopMovingOrSizing();
end

function DragonFlightUIQuickKeybindMixin:SetOutputText(text)
    self.OutputText:SetText(text);
end

function DragonFlightUIQuickKeybindMixin:ClearOutputText()
    self.OutputText:SetText(nil);
end

function DragonFlightUIQuickKeybindMixin:SetSelected(command, actionButton)
    -- print('SetSelected', command, actionButton)
    self.mouseOverButton = actionButton;

    if command == nil then
        KeybindListener:StopListening();
    else
        local slotIndex = 1;
        KeybindListener:StartListening(command, slotIndex);
    end
end

function DragonFlightUIQuickKeybindMixin:OnKeyDown(input)
    -- print('QuickKeybindMixin:OnKeyDown')
    local listening = KeybindListener:IsListening();

    local gmkey1, gmkey2 = GetBindingKey("TOGGLEGAMEMENU");
    if (input == gmkey1) and not listening then
        -- print('(input == gmkey1 or input == gmkey1) and not listening')
        self:CancelBinding();
    elseif input == "ESCAPE" and listening then
        -- print('input == "ESCAPE" and listening ')
        KeybindListener:ClearActionPrimaryBinding();
    else
        -- print('else')
        KeybindListener:OnKeyDown(input);
    end

    if self.mouseOverButton then
        -- self.mouseOverButton:QuickKeybindButtonSetTooltip();
        DragonflightUIQuickKeybindButtonOverlay:UpdateTooltip()

        local slotIndex = 1;
        KeybindListener:StartListening(self.mouseOverButton.command, slotIndex);
    end
end

function DragonFlightUIQuickKeybindMixin:OnCharacterBindingsChanged(setting, value)
    self.UseCharacterBindingsButton:SetChecked(value);
end

function DragonFlightUIQuickKeybindMixin:OnKeybindUnbindFailed(action, unbindAction, unbindSlotIndex)
    local errorFormat = unbindSlotIndex == 1 and PRIMARY_KEY_UNBOUND_ERROR or KEY_UNBOUND_ERROR;
    self:SetOutputText(errorFormat:format(GetBindingName(unbindAction)));
    -- print('OnKeybindUnbindFailed:', action, unbindAction, unbindSlotIndex)
end

function DragonFlightUIQuickKeybindMixin:OnKeybindRebindFailed(action)
    self:SetOutputText(KEYBINDINGFRAME_MOUSEWHEEL_ERROR);
    -- print('OnKeybindRebindFailed:', action)
end

function DragonFlightUIQuickKeybindMixin:OnKeybindRebindSuccess(action)
    self:SetOutputText(KEY_BOUND);
    -- print('OnKeybindRebindSuccess', action)
end
