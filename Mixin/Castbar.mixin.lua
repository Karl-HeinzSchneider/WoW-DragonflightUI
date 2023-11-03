print('MIXIN!')

DragonFlightUICastbarMixin = {}

function DragonFlightUICastbarMixin:OnLoad(unit)
    print('OnLoad')
    self:SetUnit(unit)
end

function DragonFlightUICastbarMixin:OnUpdate(self, elapsed)
    print('MIXIN! update')

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
    if true then return end
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
            local desiredShowFalse = false;
            self:UpdateShownState(desiredShowFalse);
            return;
        end

        self.barType = self:GetEffectiveType(false, notInterruptible, isTradeSkill, false);
        self:SetStatusBarTexture(self:GetTypeInfo(self.barType).filling);

        self:ClearStages();

        self:ShowSpark();

        self.value = (GetTime() - (startTime / 1000));
        self.maxValue = (endTime - startTime) / 1000;
        self:SetMinMaxValues(0, self.maxValue);
        self:SetValue(self.value);
        self:UpdateCastTimeText();
        if (self.Text) then self.Text:SetText(text); end
        if (self.Icon) then
            self.Icon:SetTexture(texture);
            if (self.iconWhenNoninterruptible) then self.Icon:SetShown(not notInterruptible); end
        end
        self.casting = true;
        self.castID = castID;
        self.channeling = nil;
        self.reverseChanneling = nil;

        self:StopAnims();
        self:ApplyAlpha(1.0);

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
    elseif (event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP" or event ==
        "UNIT_SPELLCAST_EMPOWER_STOP") then
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
                self.barType = self:GetEffectiveType(false, notInterruptible, isTradeSkill, false);
                self:SetStatusBarTexture(self:GetTypeInfo(self.barType).filling);
                self:ClearStages();
                self:ShowSpark();
                if (self.Flash) then
                    self.Flash:SetAlpha(0.0);
                    self.Flash:Hide();
                end
                self.casting = true;
                self.channeling = nil;
                self.reverseChanneling = nil;

                self:StopAnims();
            end
        end
    elseif (event == "UNIT_SPELLCAST_CHANNEL_START" or event == "UNIT_SPELLCAST_EMPOWER_START") then
        local name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellID, _, numStages =
            UnitChannelInfo(unit);
        if (not name or (not self.showTradeSkills and isTradeSkill)) then
            -- if there is no name, there is no bar
            local desiredShowFalse = false;
            self:UpdateShownState(desiredShowFalse);
            return;
        end

        local isChargeSpell = numStages > 0;

        if isChargeSpell then endTime = endTime + GetUnitEmpowerHoldAtMaxTime(self.unit); end

        self.maxValue = (endTime - startTime) / 1000;

        self.barType = self:GetEffectiveType(not isChargeSpell, notInterruptible, isTradeSkill, isChargeSpell);

        if isChargeSpell then
            self:SetColorFill(0, 0, 0, 0);
        else
            self:SetStatusBarTexture(self:GetTypeInfo(self.barType).filling);
        end

        self:ClearStages();

        if (isChargeSpell) then
            self.value = GetTime() - (startTime / 1000);
        else
            self.value = (endTime / 1000) - GetTime();
        end

        self:ShowSpark();

        self:SetMinMaxValues(0, self.maxValue);
        self:SetValue(self.value);
        self:UpdateCastTimeText();
        if (self.Text) then self.Text:SetText(text); end
        if (self.Icon) then self.Icon:SetTexture(texture); end
        if (isChargeSpell) then
            self.reverseChanneling = true;
            self.casting = true;
            self.channeling = false;
        else
            self.reverseChanneling = nil;
            self.casting = nil;
            self.channeling = true;
        end

        self:StopAnims();
        self:ApplyAlpha(1.0);

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

        -- AddStages after Show so that the layout is valid
        if (isChargeSpell) then self:AddStages(numStages); end
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

function DragonFlightUICastbarMixin:SetUnit(unit)
    if self.unit ~= unit then
        self.unit = unit;

        self.casting = nil;
        self.channeling = nil;
        self.reverseChanneling = nil;

        self:StopAnims();

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

            -- local desiredShowFalse = false;
            -- self:UpdateShownState(desiredShowFalse);
        end
    end
end

function DragonFlightUICastbarMixin:StopAnims()
    -- self:StopInterruptAnims();
    -- self:StopFinishAnims();
end

