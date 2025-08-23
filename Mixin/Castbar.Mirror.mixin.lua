DragonFlightUICastbarMirrorMixin = {}

function DragonFlightUICastbarMirrorMixin:OnLoad()
    -- print('DragonFlightUICastbarMirrorMixin:OnLoad()')

    self.preci = 1;
    self.preciMax = 1;
    self.showCastTimeMaxSetting = true;
    self.casting = false;
    self.channeling = true;

    self.CastTimeTextCompact:SetWidth(70 + 30)
end

function DragonFlightUICastbarMirrorMixin:OnEvent(event, ...)
end

function DragonFlightUICastbarMirrorMixin:OnShow()
end

function DragonFlightUICastbarMirrorMixin:OnUpdate(elapsed)
    if not self.timer then return; end

    self:UpdateStatusBarValue();
end
-- function DragonFlightUICastbarMirrorMixin:OnLoad() end
-- function DragonFlightUICastbarMirrorMixin:OnLoad() end

function DragonFlightUICastbarMirrorMixin:SetEditMode(editmode)
    -- print('DragonFlightUICastbarMixin:SetEditMode(editmode)', editmode)
    if editmode then
        self.DFEditMode = true;
        self:SetEditModeStyle()
        -- self.fadeOut = nil;
        -- self:SetAlpha(1)
        -- self:Show();
        -- self:UpdateEditModeStyle(true)
    else
        self.DFEditMode = false;
        -- self:Hide();
        self:Clear()
    end
end

function DragonFlightUICastbarMirrorMixin:Setup(timer, value, maxvalue, paused, label)
    self.timer = timer;
    self.DFEditMode = false;

    if paused > 0 then
        paused = true
    else
        paused = false
    end

    -- self:SetStatusBarTexture(MirrorTimerAtlas[timer]); -- set outside and fixed
    self:SetMinMaxValues(0, (maxvalue / 1000));
    self:UpdateStatusBarValue(value);

    self:SetPaused(paused);

    self.TextCompact:SetText(label);

    self:UpdateShownState();
end

function DragonFlightUICastbarMirrorMixin:Clear()
    self:SetScript("OnUpdate", nil);
    self.timer = nil;
    self:UpdateShownState();
end

local maxRandomValue = 180;
local maxRandomDelta = 20;

function DragonFlightUICastbarMirrorMixin:SetEditModeStyle()
    local value = 42;
    local maxValue = 69;

    value = fastrandom(1, maxRandomValue - maxRandomDelta);
    maxValue = fastrandom(value, maxRandomValue);

    self:SetMinMaxValues(0, (maxValue / 1000));
    self:UpdateStatusBarValue(value);
    self:UpdateText(value, 0, maxValue)

    self.TextCompact:SetText('***');

    self:UpdateShownState();
end

function DragonFlightUICastbarMirrorMixin:SetPaused(paused)
    if paused then
        self:SetScript("OnUpdate", nil);
    else
        self:SetScript("OnUpdate", self.OnUpdate);
    end
end

function DragonFlightUICastbarMirrorMixin:UpdateStatusBarValue(value)
    self:SetValue((value or GetMirrorTimerProgress(self.timer)) / 1000);

    local minValue, maxValue = self:GetMinMaxValues();
    local val = self:GetValue();
    self:UpdateSpark(val, minValue, maxValue)
    self:UpdateText(val, minValue, maxValue)
end

function DragonFlightUICastbarMirrorMixin:UpdateText(value, minValue, maxValue)
    if not self.CastTimeText then return; end

    local seconds = 0;
    local secondsMax = 0
    if self.casting or self.channeling then
        -- local min, max = self:GetMinMaxValues();
        local min, max = minValue, maxValue;
        secondsMax = max
        if self.casting then
            -- seconds = math.max(min, max - self:GetValue());
            seconds = math.max(min, max - value);
        else
            -- seconds = math.max(min, self:GetValue());
            seconds = math.max(min, value);
        end
    elseif self.DFEditMode then
        seconds = value or 6.9;
        secondsMax = maxValue or 10
    end

    local text = string.format('%.' .. self.preci .. 'f', seconds)

    if self.showCastTimeMaxSetting then
        local textMax = string.format('%.' .. self.preciMax .. 'f', secondsMax)
        -- self.CastTimeText:SetText(text .. ' / ' .. textMax)
        self.CastTimeTextCompact:SetText(text .. ' / ' .. textMax)
    else
        -- self.CastTimeText:SetText(text .. 's')
        self.CastTimeTextCompact:SetText(text .. 's')
    end
end

function DragonFlightUICastbarMirrorMixin:UpdateSpark(value, minValue, maxValue)
    if (self.Spark) then
        local sparkPosition = (value / maxValue) * self:GetWidth();
        self.Spark:SetPoint("CENTER", self, "LEFT", sparkPosition, 0);
    end
end

function DragonFlightUICastbarMirrorMixin:HasTimer()
    return self.timer;
end

-- function DragonFlightUICastbarMirrorMixin:SetIsInEditModeInternal(isInEditMode)
--     self.DFEditMode = isInEditMode;
-- end

-- function DragonFlightUICastbarMirrorMixin:SetIsInEditMode(isInEditMode)
--     self:SetIsInEditModeInternal(isInEditMode);
--     self:UpdateShownState();
-- end

function DragonFlightUICastbarMirrorMixin:ShouldShow()
    return self.DFEditMode or self.timer;
end

function DragonFlightUICastbarMirrorMixin:UpdateShownState()
    self:SetShown(self:ShouldShow());
end
