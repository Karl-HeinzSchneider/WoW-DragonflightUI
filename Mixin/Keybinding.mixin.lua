DragonFlightUIKeybindingMixin = {}

local popup = 'DragonflightUIKeybindingPopup'

function DragonFlightUIKeybindingMixin:CreatePopup()
    StaticPopupDialogs[popup] = {
        text = "Do you want to greet the world today?",
        button1 = "Yes",
        button2 = "No",
        OnAccept = function()
            self:ApplyBindings()
        end,
        OnCancel = function()
            self:Discard()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true
    }
    StaticPopup_Show(popup)
end

function DragonFlightUIKeybindingMixin:ApplyBindings()

end

function DragonFlightUIKeybindingMixin:Discard()

end

