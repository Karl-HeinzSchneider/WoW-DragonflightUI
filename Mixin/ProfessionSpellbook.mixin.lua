DragonFlightUIProfessionSpellbookMixin = {}
local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

function DragonFlightUIProfessionSpellbookMixin:Update()
    print('DragonFlightUIProfessionSpellbookMixin:Update()')
end

--

DragonflightUIProfessionsUnlearnButtonMixin = {}

function DragonflightUIProfessionsUnlearnButtonMixin:OnEnter()
    self.Icon:SetAlpha(1.0);
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    GameTooltip:SetText(UNLEARN_SKILL_TOOLTIP);
end

function DragonflightUIProfessionsUnlearnButtonMixin:OnLeave()
    self.Icon:SetAlpha(0.75);
    GameTooltip_Hide();
end

function DragonflightUIProfessionsUnlearnButtonMixin:OnMouseDown()
    self.Icon:SetPoint("TOPLEFT", 1, -1);
end

function DragonflightUIProfessionsUnlearnButtonMixin:OnMouseUp()
    self.Icon:SetPoint("TOPLEFT", 0, 0);
end

--
DragonflightUISpellButtonMixin = {}
