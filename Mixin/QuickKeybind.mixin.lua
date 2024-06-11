DragonFlightUIQuickKeybindMixin = {}

local QUICK_KEYBIND_DESCRIPTION = QUICK_KEYBIND_DESCRIPTION or
                                      "You are in Quick Keybind Mode. Mouse over a button and press the desired key to set the binding for that button.";
local QUICK_KEYBIND_CANCEL_DESCRIPTION = QUICK_KEYBIND_CANCEL_DESCRIPTION or
                                             'Canceling will remove you from Quick Keybind Mode.'

local QUICK_KEYBIND_MODE = QUICK_KEYBIND_MODE or 'Quick Keybind Mode'

function DragonFlightUIQuickKeybindMixin:OnLoad()
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
end

function DragonFlightUIQuickKeybindMixin:OnHide()
end

function DragonFlightUIQuickKeybindMixin:CancelBinding()
    LoadBindings(GetCurrentBindingSet());
    KeybindListener:StopListening();
    HideUIPanel(self);
end

function DragonFlightUIQuickKeybindMixin:OnKeyDown()
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

function DragonFlightUIQuickKeybindMixin:OnCharacterBindingsChanged(setting, value)
    self.UseCharacterBindingsButton:SetChecked(value);
end

function DragonFlightUIQuickKeybindMixin:OnKeybindUnbindFailed(action, unbindAction, unbindSlotIndex)
    local errorFormat = unbindSlotIndex == 1 and PRIMARY_KEY_UNBOUND_ERROR or KEY_UNBOUND_ERROR;
    self:SetOutputText(errorFormat:format(GetBindingName(unbindAction)));
end

function DragonFlightUIQuickKeybindMixin:OnKeybindRebindFailed(action)
    self:SetOutputText(KEYBINDINGFRAME_MOUSEWHEEL_ERROR);
end

function DragonFlightUIQuickKeybindMixin:OnKeybindRebindSuccess(action)
    self:SetOutputText(KEY_BOUND);
end
