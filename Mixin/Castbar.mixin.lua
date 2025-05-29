local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
-- print('MIXIN!')
local standardRef = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarStandard2'
local interruptedRef = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarInterrupted2'
local channelRef = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarChannel'

DragonFlightUICastbarMixin = {}

function DragonFlightUICastbarMixin:OnLoad(unit)
    -- print('OnLoad', unit)
    self.tickTable = {}
    self.maxHoldTime = 1.0;
    self:SetUnit(unit)
    self:AddTicks(15)
    self:SetPrecision(1, 2)
    self:SetCompactLayout(true)

    self.showCastbar = true;
    self:SetCastTimeTextShown(true)
    self.showTradeSkills = true
    self.showTicks = false
    self.showRank = false

    self.BorderShield:ClearAllPoints();
    self.BorderShield:SetPoint('CENTER', self.Icon, 'CENTER', 0, -2.25);

    -- icon mask
    local mask = self:CreateMaskTexture('DragonflightUIIconMask')
    local delta = 0
    mask:SetPoint('TOPLEFT', self.Icon, 'TOPLEFT', -delta, delta)
    mask:SetPoint('BOTTOMRIGHT', self.Icon, 'BOTTOMRIGHT', delta, -delta)
    mask:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\maskNew')
    self.Icon:AddMaskTexture(mask)

    -- icon border
    local border = self:CreateTexture('DragonflightUIIconBorder')
    border:ClearAllPoints()
    -- border:SetSize(46, 45)
    -- border:SetPoint('TOPLEFT')
    border:SetPoint('TOPLEFT', self.Icon, 'TOPLEFT', 0, 0)
    border:SetPoint('BOTTOMRIGHT', self.Icon, 'BOTTOMRIGHT', 0, 0)
    border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x')
    border:SetTexCoord(0.701171875, 0.880859375, 0.31689453125, 0.36083984375)
    border:SetDrawLayer('OVERLAY')
    self.Icon.Border = border;
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
    if self.DFEditMode then
        return
    elseif self.state and not self.state.activate then
        return
    end

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
    elseif (event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_FOCUS_CHANGED") then
        if not UnitExists(unit) then
            self:FinishSpell();
            self.unitGuid = nil
            return;
        end
        local guid = UnitGUID(unit)

        local differentTarget = self.unitGuid ~= guid
        self.unitGuid = guid

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
            if differentTarget then
                self.flash = false;
                self.fadeOut = false;
                self.holdTime = GetTime();
                self:SetAlpha(0);
            end
        end
    end

    if (arg1 ~= unit) then return; end

    if (event == "UNIT_SPELLCAST_START") then
        local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellId =
            UnitCastingInfo(unit);
        -- print(name, notInterruptible)
        local subText = GetSpellSubtext(spellId) or ''
        if not self.showRank then subText = '' end
        if subText ~= '' then subText = ' (' .. subText .. ')' end

        if (not name or (not self.showTradeSkills and isTradeSkill)) then
            -- local desiredShowFalse = false;
            -- self:UpdateShownState(desiredShowFalse);
            return;
        end

        -- self.barType = self:GetEffectiveType(false, notInterruptible, isTradeSkill, false);
        -- self:SetStatusBarTexture(self:GetTypeInfo(self.barType).filling);
        self:SetStatusBarTexture(standardRef)

        if notInterruptible then
            self:SetStatusBarDesaturated(true)
        else
            self:SetStatusBarDesaturated(false)
        end

        self:ShowSpark();
        self:HideAllTicks()

        self.value = (GetTime() - (startTime / 1000));
        self.maxValue = (endTime - startTime) / 1000;
        self:SetMinMaxValues(0, self.maxValue);
        self:SetValue(self.value);
        -- self:UpdateCastTimeText();
        if (self.Text) then
            self.Text:SetText(text .. subText);
            self.TextCompact:SetText(text .. subText)
        end
        if (self.Icon) then
            -- @TODO
            self.Icon:SetTexture(texture);
            -- if (self.iconWhenNoninterruptible) then self.Icon:SetShown(not notInterruptible); end
        end
        self.casting = true;
        self.castID = castID;
        self.channeling = nil;
        self.reverseChanneling = nil;

        self.holdTime = 0;
        self:SetAlpha(1.0);
        self.fadeOut = nil;

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

        self:UpdateShownState(self.showCastbar);
    elseif (event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP") then
        self:HandleCastStop(event, ...);
    elseif (event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED") then
        self:HandleInterruptOrSpellFailed(false, event, ...);
    elseif (event == "UNIT_SPELLCAST_DELAYED") then
        if (self:IsShown()) then
            local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible =
                UnitCastingInfo(unit);
            -- print(name, notInterruptible)
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

                self.flash = nil;
                self.fadeOut = nil;
                -- self:StopAnims();
            end
        end
    elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
        local name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellId = UnitChannelInfo(unit);
        local subText = GetSpellSubtext(spellId) or ''
        if not self.showRank then subText = '' end
        if subText ~= '' then
            text = name
            subText = ' (' .. subText .. ')'
        elseif self.showChannelName then
            text = name or text;
        end

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

        if notInterruptible then
            self:SetStatusBarDesaturated(true)
        else
            self:SetStatusBarDesaturated(false)
        end

        self.value = (endTime / 1000) - GetTime();

        self:ShowSpark();

        self:SetMinMaxValues(0, self.maxValue);
        self:SetValue(self.value);
        self:UpdateCastTimeText();
        if (self.Text) then
            self.Text:SetText(text .. subText);
            self.TextCompact:SetText(text .. subText)
        end
        if (self.Icon) then self.Icon:SetTexture(texture); end

        self.reverseChanneling = nil;
        self.casting = nil;
        self.channeling = true;

        self:SetAlpha(1.0)
        self.holdTime = 0;
        self.fadeOut = nil;

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

        -- local tickCount = self.tickTable[name]
        local tickCount = self:GetTickCount(name, spellId)
        if tickCount and tickCount > 0 then
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
        self:UpdateInterruptibleState(event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE");
    end
end

function DragonFlightUICastbarMixin:UpdateInterruptibleState(notInterruptible)
    if (self.casting or self.channeling) then
        local _, _, _, _, _, isTradeSkill = UnitCastingInfo(self.unit);
        -- self.barType = self:GetEffectiveType(false, notInterruptible, isTradeSkill, false);
        -- self:SetStatusBarTexture(self:GetTypeInfo(self.barType).filling);

        if notInterruptible then
            self:SetStatusBarDesaturated(true)
        else
            self:SetStatusBarDesaturated(false)
        end

        if (self.BorderShield) then
            if (self.showShield and notInterruptible) then
                self.BorderShield:Show();
                if (self.BarBorder) then self.BarBorder:Hide(); end
            else
                self.BorderShield:Hide();
                if (self.BarBorder) then self.BarBorder:Show(); end
            end
        end

        -- if (self.Icon and self.iconWhenNoninterruptible) then self.Icon:SetShown(not notInterruptible); end
    end
end

function DragonFlightUICastbarMixin:SetUnit(unit)
    if self.unit ~= unit then
        self.unit = unit;
        self.showShield = true;

        self.casting = nil;
        self.channeling = nil;
        self.reverseChanneling = nil;
        self.holdTime = 0;
        self.fadeOut = nil;

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

            if unit == 'target' then self:RegisterEvent("PLAYER_TARGET_CHANGED"); end
            if unit == 'focus' then self:RegisterEvent("PLAYER_FOCUS_CHANGED"); end

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

            self:UnregisterEvent("PLAYER_TARGET_CHANGED");
            self:UnregisterEvent("PLAYER_FOCUS_CHANGED");

            local desiredShowFalse = false;
            self:UpdateShownState(desiredShowFalse);
        end
    end
end

function DragonFlightUICastbarMixin:OnUpdate(elapsed)
    if self.DFEditMode then
        --
    elseif (self.casting or self.reverseChanneling) then
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
    elseif (GetTime() < self.holdTime) then
        return;
    elseif (self.fadeOut) then
        local alpha = self:GetAlpha() - CASTING_BAR_ALPHA_STEP;
        if (alpha > 0) then
            -- CastingBarFrame_ApplyAlpha(self, alpha);
            self:SetAlpha(alpha)
        else
            self.fadeOut = nil;
            self:Hide();
        end
    end

    if (self.casting or self.reverseChanneling or self.channeling) then
        if (self.Spark) then
            local sparkPosition = (self.value / self.maxValue) * self:GetWidth();
            self.Spark:SetPoint("CENTER", self, "LEFT", sparkPosition, 0);
        end
    end
end

function DragonFlightUICastbarMixin:HandleCastStop(event, ...)
    -- print('HandleCastStop', event, ...)
    if (not self:IsVisible() or self.DFEditMode) then
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

        self.flash = true;
        self.fadeOut = true;
        self.holdTime = GetTime() + self.maxHoldTime; -- 0 on classic?
    else
        -- TODO should not go here but does on cast finished
        --[[       if (event == "UNIT_SPELLCAST_STOP") then
            self.casting = nil;
        else
            self.channeling = nil;
            if (self.reverseChanneling) then self.casting = nil; end
            self.reverseChanneling = nil;
        end

        self.flash = true;
        self.fadeOut = true;
        self.holdTime = GetTime() + CASTING_BAR_HOLD_TIME; ]]
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
                self.TextCompact:SetText(FAILED)
            else
                self.Text:SetText(INTERRUPTED);
                self.TextCompact:SetText(INTERRUPTED)
            end
        end

        self.casting = nil;
        self.channeling = nil;
        self.reverseChanneling = nil;

        self.fadeOut = true;
        -- self.holdTime = GetTime() + self.maxHoldTime;
        self.holdTime = GetTime() + self.maxHoldTimeInterrupt;
        -- self:PlayInterruptAnims();
    end
end

function DragonFlightUICastbarMixin:SetEditMode(editmode)
    -- print('DragonFlightUICastbarMixin:SetEditMode(editmode)', editmode)
    if editmode then
        self.DFEditMode = true;
        self.fadeOut = nil;
        self:SetAlpha(1)
        self:Show();
        self:UpdateEditModeStyle(true)
    else
        self.DFEditMode = false;
        self:Hide();
    end
end

function DragonFlightUICastbarMixin:UpdateEditModeStyle(editmode)
    self:UpdateCastTimeText()
    self:SetMinMaxValues(0, 10);
    self:SetValue(6.9)
    self.value = self:GetValue()
    _, self.maxValue = self:GetMinMaxValues()

    self:SetStatusBarDesaturated(false)
    self:SetStatusBarTexture(standardRef)

    local sparkPosition = (self.value / self.maxValue) * self:GetWidth();
    self.Spark:SetPoint("CENTER", self, "LEFT", sparkPosition, 0);
    self.Spark:Show()

    local castName = 'Shadow Bolt'
    self.Text:SetText(castName);
    self.TextCompact:SetText(castName)

    self.Icon:SetTexture(136197)
end

function DragonFlightUICastbarMixin:StopAnims()
    -- self:StopInterruptAnims();
    -- self:StopFinishAnims();
end

function DragonFlightUICastbarMixin:ShowSpark()
    if (self.Spark) then
        self.Spark:Show()
        self.Spark:SetSize(6, self:GetHeight() + 8)
    end
end

function DragonFlightUICastbarMixin:HideSpark()
    if (self.Spark) then self.Spark:Hide(); end
end

function DragonFlightUICastbarMixin:UpdateCastTimeText()
    if not self.CastTimeText then return; end

    local seconds = 0;
    local secondsMax = 0
    if self.casting or self.channeling then
        local min, max = self:GetMinMaxValues();
        secondsMax = max
        if self.casting then
            seconds = math.max(min, max - self:GetValue());
        else
            seconds = math.max(min, self:GetValue());
        end
    elseif self.DFEditMode then
        seconds = 6.9;
        secondsMax = 10
    end

    -- local text = string.format(CAST_BAR_CAST_TIME, seconds);
    -- @TODO
    local text = string.format('%.' .. self.preci .. 'f', seconds)

    if self.showCastTimeMaxSetting then
        local textMax = string.format('%.' .. self.preciMax .. 'f', secondsMax)
        self.CastTimeText:SetText(text .. ' / ' .. textMax)
        self.CastTimeTextCompact:SetText(text .. ' / ' .. textMax)
    else
        self.CastTimeText:SetText(text .. 's')
        self.CastTimeTextCompact:SetText(text .. 's')
    end
end

function DragonFlightUICastbarMixin:SetPrecision(preci, preciMax)
    self.preci = preci
    self.preciMax = preciMax
    self:UpdateCastTimeTextShown()
end

function DragonFlightUICastbarMixin:SetCompactLayout(bCompact)
    self.compactLayout = bCompact
    if self.compactLayout then
        self.Text:SetShown(false)
        self.TextCompact:SetShown(true)
    else
        self.Text:SetShown(true)
        self.TextCompact:SetShown(false)
    end
    self:UpdateCastTimeTextShown()
end

function DragonFlightUICastbarMixin:UpdateShownState(desiredShow)
    self:UpdateCastTimeTextShown();

    if self.DFEditMode then
        -- If we are in edit mode then override and just show
        -- self:StopFinishAnims();
        -- self:ApplyAlpha(1.0);
        self:Show();
        self:UpdateEditModeStyle(true)
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

function DragonFlightUICastbarMixin:SetCastTimeTextMaxShown(showCastTimeMax)
    self.showCastTimeMaxSetting = showCastTimeMax;
    self:UpdateCastTimeTextShown();
end

function DragonFlightUICastbarMixin:SetIconShown(bShown)
    self.showIcon = bShown
    self.Icon:SetShown(self.showIcon)
    self.Icon.Border:SetShown(self.showIcon)
end

function DragonFlightUICastbarMixin:UpdateCastTimeTextShown()
    if not self.CastTimeText then return; end

    local showCastTime = self.showCastTimeSetting and (self.casting or self.channeling or self.DFEditMode)
    if self.compactLayout then
        self.CastTimeText:SetShown(false)
        self.CastTimeTextCompact:SetShown(showCastTime)
    else
        self.CastTimeText:SetShown(showCastTime)
        self.CastTimeTextCompact:SetShown(false)
    end

    if showCastTime and self.DFEditMode and not self.CastTimeText.text then self:UpdateCastTimeText(); end
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

    self.flash = true;
    self.fadeOut = true;
    self.holdTime = GetTime() + self.maxHoldTime;
end

function DragonFlightUICastbarMixin:AddTicks(count)
    if not self.ticks then
        local ticks = {}
        for i = 1, count do
            local tick = self:CreateTexture('Tick' .. i, 'OVERLAY', 'DragonflightUICastbarTickTemplate')
            tick:SetDrawLayer('OVERLAY')
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

function DragonFlightUICastbarMixin:GetTickCount(spell, spellID)
    -- local tickCount = self.tickTable[name]

    if not self.showTicks then return 0 end

    return self.tickTable[spellID] or self.tickTable[spell] or 0
end

function DragonFlightUICastbarMixin:SetShowTicks(showTicks)
    self.showTicks = showTicks
end

function DragonFlightUICastbarMixin:SetShowRank(showRank)
    self.showRank = showRank
end

function DragonFlightUICastbarMixin:SetShowChannelName(showName)
    self.showChannelName = showName
end

function DragonFlightUICastbarMixin:UpdateState(state)
    self.state = state
    self:Update()
end

function DragonFlightUICastbarMixin:FixScale()
    local state = self.state
    if not state then return end

    self:SetIgnoreParentScale(true) -- TODO
    self:SetScale(UIParent:GetScale() * state.scale) -- TODO
    self:SetSize(state.sizeX, state.sizeY)
end

function DragonFlightUICastbarMixin:Update()
    local state = self.state

    -- self:SetScale(state.scale)
    self:SetIgnoreParentScale(true) -- TODO
    self:SetScale(UIParent:GetScale() * state.scale) -- TODO
    self:SetSize(state.sizeX, state.sizeY)

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    if self.DFEditMode then
        self:Show()
        self:UpdateEditModeStyle(true)
        self:SetParent(UIParent)
    elseif not state.activate then
        -- self:Hide()
        self:UpdateShownState(false)
    else
        self:UpdateShownState()
        self:SetParent(parent) -- TODO
    end
    -- self:ClearAllPoints()
    -- self:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y) 
    self:AdjustPosition()

    self:SetPrecision(state.preci, state.preciMax)
    self:SetCastTimeTextShown(state.castTimeEnabled)
    self:SetCastTimeTextMaxShown(state.castTimeMaxEnabled)
    self.maxHoldTime = state.holdTime
    self.maxHoldTimeInterrupt = state.holdTimeInterrupt
    self:SetCompactLayout(state.compactLayout)
    self:SetShowTicks(state.showTicks)
    self:SetShowRank(state.showRank)
    self:SetIconShown(state.showIcon)
    self:SetShowChannelName(state.showChannelName or false)

    -- self.Icon:SetSize(state.sizeY, state.sizeY)
    local iconScale = state.sizeIcon / 16
    self.Icon:SetSize(state.sizeIcon, state.sizeIcon)
    self.Icon:SetPoint('RIGHT', self, 'LEFT', -7 * iconScale, -4)
    self.BorderShield:SetScale(iconScale * 0.9)
end

function DragonFlightUICastbarMixin:AdjustPosition()
    local state = self.state

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    self:ClearAllPoints()

    if state.autoAdjust then
        --   
        local rows = self:GetParent().auraRows or 0
        local auraSize = 22

        local delta = (rows - 2) * (auraSize + 2)

        if ((not parent.buffsOnTop) and rows > 2) then
            --
            self:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y - delta)
        else
            --
            self:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
        end
    else
        --
        self:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    end
end
