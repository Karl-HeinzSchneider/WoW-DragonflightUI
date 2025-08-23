DragonFlightUICastbarMirrorMixin = {}

function DragonFlightUICastbarMirrorMixin:OnLoad()
    print('DragonFlightUICastbarMirrorMixin:OnLoad()')
end

function DragonFlightUICastbarMirrorMixin:OnEvent(event, ...)
end

function DragonFlightUICastbarMirrorMixin:OnShow()
end

function DragonFlightUICastbarMirrorMixin:OnUpdate(elapsed)
end
-- function DragonFlightUICastbarMirrorMixin:OnLoad() end
-- function DragonFlightUICastbarMirrorMixin:OnLoad() end

function DragonFlightUICastbarMirrorMixin:SetEditMode(editmode)
    -- print('DragonFlightUICastbarMixin:SetEditMode(editmode)', editmode)
    if editmode then
        self.DFEditMode = true;
        -- self.fadeOut = nil;
        -- self:SetAlpha(1)
        -- self:Show();
        -- self:UpdateEditModeStyle(true)
    else
        self.DFEditMode = false;
        -- self:Hide();
    end
end
