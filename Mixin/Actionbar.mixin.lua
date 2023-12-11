DragonflightUIActionbarMixin = {}

function DragonflightUIActionbarMixin:SetButtons(buttons)
    self.buttons = buttons
end

function DragonflightUIActionbarMixin:SetState(state)
    self.state = state
    self:Update()
end

function DragonflightUIActionbarMixin:Update()
    local state = self.state
end
