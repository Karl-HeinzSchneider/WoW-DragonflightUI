-- print('MIXIN!')
local standardRef = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarStandard2'
local interruptedRef = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarInterrupted2'
local channelRef = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarChannel'

InterfaceVersion = select(4, GetBuildInfo())
Wrath = InterfaceVersion >= 30400
Era = InterfaceVersion <= 20000

DragonFlightUICastbarMixin = {}

function DragonFlightUICastbarMixin:OnLoad(unit)
    -- print('OnLoad')
    self:SetUnit(unit)
    self:AddTicks(15)

    self.showCastbar = true;
    self:SetCastTimeTextShown(true)
end

function DragonFlightUICastbarMixin:OnShow()
    if (self.unit) then
        if (self.casting) then
            local _, _, _, startTime = UnitCastingInfo(self.unit);
            if (startTime) then self.value = (GetTime() - (startTime / 1000)); end
        else
            local _, _, _, _, endTime = UnitChannelInfo(self.unit);
            if (endTime) then self.value = ((endTime / 1000) - GetTime()); end
        end
    end
end

function DragonFlightUICastbarMixin:OnEvent(event, ...)
    -- print('event:', event)
    -- if true then return end
    local arg1 = ...;

    local unit = self.unit;
    if (event == "PLAYER_ENTERING_WORLD") then
        local nameChannel = UnitChannelInfo(unit);
        local nameSpell = UnitCastingInfo(unit);
        if (nameChannel) then
            event = "UNIT_SPELLCAST_CHANNEL_START";
            arg1 = unit;
        elseif (nameSpell) then
            event = "UNIT_SPELLCAST_START";
            arg1 = unit;
        else
            self:FinishSpell();
        end
    end

    if (arg1 ~= unit) then return; end

    if (event == "UNIT_SPELLCAST_START") then
        local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unit);
        if (not name or (not self.showTradeSkills and isTradeSkill)) then
            -- local desiredShowFalse = false;
            -- self:UpdateShownState(desiredShowFalse);
            return;
        end

        -- self.barType = self:GetEffectiveType(false, notInterruptible, isTradeSkill, false);
        -- self:SetStatusBarTexture(self:GetTypeInfo(self.barType).filling);
        self:SetStatusBarTexture(standardRef)

        self:ShowSpark();
        self:HideAllTicks()

        self.value = (GetTime() - (startTime / 1000));
        self.maxValue = (endTime - startTime) / 1000;
        self:SetMinMaxValues(0, self.maxValue);
        self:SetValue(self.value);
        -- self:UpdateCastTimeText();
        if (self.Text) then self.Text:SetText(text); end
        if (self.Icon) then
            -- @TODO
            -- self.Icon:SetTexture(texture);
            if (self.iconWhenNoninterruptible) then self.Icon:SetShown(not notInterruptible); end
        end
        self.casting = true;
        self.castID = castID;
        self.channeling = nil;
        self.reverseChanneling = nil;

        -- self:StopAnims();
        -- self:ApplyAlpha(1.0);

        self:UpdateShownState(self.showCastbar);
    elseif (event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP") then
        self:HandleCastStop(event, ...);
    elseif (event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED") then
        self:HandleInterruptOrSpellFailed(false, event, ...);
    elseif (event == "UNIT_SPELLCAST_DELAYED") then
        if (self:IsShown()) then
            local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible =
                UnitCastingInfo(unit);
            if (not name or (not self.showTradeSkills and isTradeSkill)) then
                -- if there is no name, there is no bar
                local desiredShowFalse = false;
                self:UpdateShownState(desiredShowFalse);
                return;
            end
            self.value = (GetTime() - (startTime / 1000));
            self.maxValue = (endTime - startTime) / 1000;
            self:SetMinMaxValues(0, self.maxValue);
            if (not self.casting) then
                -- self.barType = self:GetEffectiveType(false, notInterruptible, isTradeSkill, false);
                -- self:SetStatusBarTexture(self:GetTypeInfo(self.barType).filling);
                -- self:ClearStages();
                self:ShowSpark();
                if (self.Flash) then
                    -- self.Flash:SetAlpha(0.0);
                    -- self.Flash:Hide();
                end
                self.casting = true;
                self.channeling = nil;
                self.reverseChanneling = nil;

                -- self:StopAnims();
            end
        end
    elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
        local name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellID = UnitChannelInfo(unit);
        if (not name or (not self.showTradeSkills and isTradeSkill)) then
            -- if there is no name, there is no bar
            local desiredShowFalse = false;
            self:UpdateShownState(desiredShowFalse);
            return;
        end

        self.maxValue = (endTime - startTime) / 1000;

        -- self.barType = self:GetEffectiveType(not isChargeSpell, notInterruptible, isTradeSkill, isChargeSpell);

        -- self:SetStatusBarTexture(self:GetTypeInfo(self.barType).filling);
        self:SetStatusBarTexture(channelRef)

        self.value = (endTime / 1000) - GetTime();

        self:ShowSpark();

        self:SetMinMaxValues(0, self.maxValue);
        self:SetValue(self.value);
        self:UpdateCastTimeText();
        if (self.Text) then self.Text:SetText(text); end
        if (self.Icon) then self.Icon:SetTexture(texture); end

        self.reverseChanneling = nil;
        self.casting = nil;
        self.channeling = true;

        -- self:StopAnims();
        -- self:ApplyAlpha(1.0);

        if (self.BorderShield) then
            if (self.showShield and notInterruptible) then
                self.BorderShield:Show();
                if (self.BarBorder) then self.BarBorder:Hide(); end
            else
                self.BorderShield:Hide();
                if (self.BarBorder) then self.BarBorder:Show(); end
            end
        end

        local tickCount = self.tickTable[name]
        if tickCount then
            local tickDelta = self:GetWidth() / tickCount

            for i = 1, tickCount - 1 do
                self.ticks[i]:Show()
                self.ticks[i]:SetPoint('CENTER', self, 'LEFT', i * tickDelta, 0)
                self.ticks[i]:SetHeight(self:GetHeight() + 8)
            end

            for i = tickCount, 15 do self.ticks[i]:Hide() end
        else
            self:HideAllTicks()
        end

        self:UpdateShownState(self.showCastbar);
    elseif (event == "UNIT_SPELLCAST_CHANNEL_UPDATE" or event == "UNIT_SPELLCAST_EMPOWER_UPDATE") then
        if (self:IsShown()) then
            local name, text, texture, startTime, endTime, isTradeSkill = UnitChannelInfo(unit);
            if (not name or (not self.showTradeSkills and isTradeSkill)) then
                -- if there is no name, there is no bar
                local desiredShowFalse = false;
                self:UpdateShownState(desiredShowFalse);
                return;
            end
            self.value = ((endTime / 1000) - GetTime());
            self.maxValue = (endTime - startTime) / 1000;
            self:SetMinMaxValues(0, self.maxValue);
            self:SetValue(self.value);
            self:UpdateCastTimeText();
        end
    elseif (event == "UNIT_SPELLCAST_INTERRUPTIBLE" or event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE") then
        -- self:UpdateInterruptibleState(event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE");
    end
end

function DragonFlightUICastbarMixin:SetUnit(unit)
    if self.unit ~= unit then
        self.unit = unit;

        self.casting = nil;
        self.channeling = nil;
        self.reverseChanneling = nil;

        -- self:StopAnims();

        if unit then
            self:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", unit);
            self:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", unit);
            self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", unit);
            self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", unit);
            self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", unit);
            -- self:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_START", unit);
            -- self:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_UPDATE", unit);
            -- self:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_STOP", unit);
            self:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTIBLE", unit);
            self:RegisterUnitEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE", unit);
            self:RegisterUnitEvent("UNIT_SPELLCAST_START", unit);
            self:RegisterUnitEvent("UNIT_SPELLCAST_STOP", unit);
            self:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", unit);
            self:RegisterEvent("PLAYER_ENTERING_WORLD");

            self:OnEvent("PLAYER_ENTERING_WORLD")
        else
            self:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
            self:UnregisterEvent("UNIT_SPELLCAST_DELAYED");
            self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START");
            self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
            self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
            -- self:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_START");
            -- self:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_UPDATE");
            -- self:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_STOP");
            self:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE");
            self:UnregisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE");
            self:UnregisterEvent("UNIT_SPELLCAST_START");
            self:UnregisterEvent("UNIT_SPELLCAST_STOP");
            self:UnregisterEvent("UNIT_SPELLCAST_FAILED");
            self:UnregisterEvent("PLAYER_ENTERING_WORLD");

            local desiredShowFalse = false;
            self:UpdateShownState(desiredShowFalse);
        end
    end
end

function DragonFlightUICastbarMixin:OnUpdate(elapsed)
    if (self.casting or self.reverseChanneling) then
        self.value = self.value + elapsed;

        if (self.value >= self.maxValue) then
            self:SetValue(self.maxValue);
            self:UpdateCastTimeText();
            if (not self.reverseChanneling) then
                self:FinishSpell();
            else
                if self.FlashLoopingAnim and not self.FlashLoopingAnim:IsPlaying() then
                    -- self.FlashLoopingAnim:Play();
                    -- self.Flash:Show();
                end
            end
            self:HideSpark();
            return;
        end
        self:SetValue(self.value);
        self:UpdateCastTimeText();
        if (self.Flash) then self.Flash:Hide(); end
    elseif (self.channeling) then
        self.value = self.value - elapsed;
        if (self.value <= 0) then
            self:FinishSpell();
            return;
        end
        self:SetValue(self.value);
        self:UpdateCastTimeText();
        -- if (self.Flash) then self.Flash:Hide(); end
    end

    if (self.casting or self.reverseChanneling or self.channeling) then
        if (self.Spark) then
            local sparkPosition = (self.value / self.maxValue) * self:GetWidth();
            self.Spark:SetPoint("CENTER", self, "LEFT", sparkPosition, 0);
        end
    end
end

function DragonFlightUICastbarMixin:HandleCastStop(event, ...)
    if (not self:IsVisible()) then
        local desiredShowFalse = false;
        self:UpdateShownState(desiredShowFalse);
    end
    if ((self.casting and event == "UNIT_SPELLCAST_STOP" and select(2, ...) == self.castID) or
        ((self.channeling or self.reverseChanneling) and
            (event == "UNIT_SPELLCAST_CHANNEL_STOP" or event == "UNIT_SPELLCAST_EMPOWER_STOP"))) then

        local castComplete = select(4, ...);
        if (event == "UNIT_SPELLCAST_EMPOWER_STOP" and not castComplete) then
            self:HandleInterruptOrSpellFailed(true, event, ...);
            return;
        end

        -- Cast info not available once stopped, so update bar based on cached barType
        -- local barTypeInfo = self:GetTypeInfo(self.barType);
        -- self:SetStatusBarTexture(barTypeInfo.full);

        if not self.reverseChanneling then self:HideSpark(); end

        --[[  if (self.Flash) then
            self.Flash:SetAtlas(barTypeInfo.glow);
            self.Flash:SetAlpha(0.0);
            self.Flash:Show();
        end ]]
        if not self.reverseChanneling and not self.channeling then
            self:SetValue(self.maxValue);
            self:UpdateCastTimeText();
        end

        -- self:PlayFadeAnim();
        -- self:PlayFinishAnim();

        if (event == "UNIT_SPELLCAST_STOP") then
            self.casting = nil;
        else
            self.channeling = nil;
            if (self.reverseChanneling) then self.casting = nil; end
            self.reverseChanneling = nil;
        end
    end
end

function DragonFlightUICastbarMixin:HandleInterruptOrSpellFailed(empoweredInterrupt, event, ...)
    if (empoweredInterrupt or (self:IsShown() and (self.casting and select(2, ...) == self.castID) and
        (not self.FadeOutAnim or not self.FadeOutAnim:IsPlaying()))) then
        self.barType = "interrupted"; -- failed and interrupted use same bar art

        -- We don't want to show the full state for the empowered texture since it produces a gradient.
        -- self:SetStatusBarTexture(empoweredInterrupt and nil or self:GetTypeInfo(self.barType).full);
        self:SetStatusBarTexture(interruptedRef)

        self:ShowSpark();

        if (self.Text) then
            if (event == "UNIT_SPELLCAST_FAILED") then
                self.Text:SetText(FAILED);
            else
                self.Text:SetText(INTERRUPTED);
            end
        end

        self.casting = nil;
        self.channeling = nil;
        self.reverseChanneling = nil;

        -- self:PlayInterruptAnims();
    end
end

function DragonFlightUICastbarMixin:StopAnims()
    -- self:StopInterruptAnims();
    -- self:StopFinishAnims();
end

function DragonFlightUICastbarMixin:ShowSpark()
    if (self.Spark) then self.Spark:Show(); end
end

function DragonFlightUICastbarMixin:HideSpark()
    if (self.Spark) then self.Spark:Hide(); end
end

function DragonFlightUICastbarMixin:UpdateCastTimeText()
    if not self.CastTimeText then return; end

    local seconds = 0;
    if self.casting or self.channeling then
        local min, max = self:GetMinMaxValues();
        if self.casting then
            seconds = math.max(min, max - self:GetValue());
        else
            seconds = math.max(min, self:GetValue());
        end
    elseif self.isInEditMode then
        seconds = 10;
    end

    -- local text = string.format(CAST_BAR_CAST_TIME, seconds);
    -- @TODO
    local text = string.format('%.' .. 1 .. 'f', seconds) .. 's'
    self.CastTimeText:SetText(text);
end

function DragonFlightUICastbarMixin:UpdateShownState(desiredShow)
    self:UpdateCastTimeTextShown();

    if self.isInEditMode then
        -- If we are in edit mode then override and just show
        self:StopFinishAnims();
        self:ApplyAlpha(1.0);
        self:Show();
        return;
    end

    if desiredShow ~= nil then
        self:SetShown(desiredShow);
        return;
    end

    self:SetShown(self.casting and self.showCastbar);
end

function DragonFlightUICastbarMixin:UpdateIsShown()
    if (self.casting and self.showCastbar) then
        self:OnEvent("PLAYER_ENTERING_WORLD")
    else
        local desiredShowFalse = false;
        self:UpdateShownState(desiredShowFalse);
    end
end

function DragonFlightUICastbarMixin:SetCastTimeTextShown(showCastTime)
    self.showCastTimeSetting = showCastTime;
    self:UpdateCastTimeTextShown();
end

function DragonFlightUICastbarMixin:UpdateCastTimeTextShown()
    if not self.CastTimeText then return; end

    local showCastTime = self.showCastTimeSetting and (self.casting or self.channeling or self.isInEditMode);
    self.CastTimeText:SetShown(showCastTime);
    if showCastTime and self.isInEditMode and not self.CastTimeText.text then self:UpdateCastTimeText(); end
end

function DragonFlightUICastbarMixin:FinishSpell()
    if self.maxValue and not self.reverseChanneling and not self.channeling then
        self:SetValue(self.maxValue);
        self:UpdateCastTimeText();
    end
    -- local barTypeInfo = self:GetTypeInfo(self.barType);
    -- self:SetStatusBarTexture(barTypeInfo.full);

    self:HideSpark();

    if (self.Flash) then
        -- self.Flash:SetAtlas(barTypeInfo.glow);
        -- self.Flash:SetAlpha(0.0);
        -- self.Flash:Show();
    end

    -- self:PlayFadeAnim();
    -- self:PlayFinishAnim();

    self.casting = nil;
    self.channeling = nil;
    self.reverseChanneling = nil;
end

function DragonFlightUICastbarMixin:AddTicks(count)
    if not self.ticks then
        local ticks = {}
        for i = 1, count do
            local tick = self:CreateTexture('Tick' .. i, 'OVERLAY', 'DragonflightUICastbarTickTemplate')
            -- tick:SetVertexColor(0, 0, 0, 0.69)
            tick:ClearAllPoints()
            tick:SetSize(6, 20 + 8)
            tick:SetPoint('CENTER', self, 'LEFT', 320 / 2, 0)
            ticks[i] = tick
        end

        self.ticks = ticks
    end
end

function DragonFlightUICastbarMixin:HideAllTicks()
    if self.ticks then for k, v in pairs(self.ticks) do v:Hide() end end
end

function DragonFlightUICastbarMixin:AddTickTable(data)
    if data then
        self.tickTable = data
    else
        self.tickTable = {}
    end
end
