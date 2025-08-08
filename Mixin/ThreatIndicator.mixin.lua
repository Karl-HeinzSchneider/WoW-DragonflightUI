DragonflightUIThreatIndicatorMixin = {}

function DragonflightUIThreatIndicatorMixin:OnLoad()
    -- print('DragonflightUIThreatIndicatorMixin:OnLoad()')

    local bg = self:CreateTexture(nil, 'BACKGROUND')
    -- bg:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
    bg:SetTexture(
        "Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health");
    bg:SetPoint('CENTER', 0, 0)
    bg:SetSize(self:GetSize())
    self.Background = bg;

    local text = self:CreateFontString(nil, 'BACKGROUND', 'GameFontHighlight')
    text:SetPoint('CENTER', 0, 0)
    text:SetText('999%')
    self.Text = text;
end

function DragonflightUIThreatIndicatorMixin:OnEvent(event, ...)
    self:UpdateThreat();
end

function DragonflightUIThreatIndicatorMixin:SetUnit(unit, shouldShow)
    self.unit = unit;
    self.ShouldShow = shouldShow;
    self:SetShown(self.ShouldShow)

    self:RegisterEvent('PLAYER_TARGET_CHANGED')
    self:RegisterUnitEvent('UNIT_THREAT_LIST_UPDATE', self.unit)
end

local MAX_DISPLAYED_THREAT_PERCENT = MAX_DISPLAYED_THREAT_PERCENT or 999;

function DragonflightUIThreatIndicatorMixin:UpdateThreat()
    local unit = self.unit;
    if not self.ShouldShow or not UnitExists(unit) then
        self:Hide();
        return;
    end

    local isTanking, status, percentage, rawPercentage = UnitDetailedThreatSituation('PLAYER', unit)
    local display = rawPercentage;

    if isTanking then
        --
        display = UnitThreatPercentageOfLead('PLAYER', 'TARGET') or 100;
    end

    if display and display ~= 0 then
        -- print('t:', display)
        display = min(display, MAX_DISPLAYED_THREAT_PERCENT);
        self.Text:SetText(format("%1.0f", display) .. "%")
        self.Background:SetVertexColor(GetThreatStatusColor(status))
        self:Show()
    else
        self:Hide()
    end
end
