DragonflightUIBuffFrameContainerTemplateMixin = {}

local TOOLTIP_UPDATE_TIME = TOOLTIP_UPDATE_TIME or 0.2;
local BUFF_FLASH_TIME_ON = BUFF_FLASH_TIME_ON or 0.75;
local BUFF_FLASH_TIME_OFF = BUFF_FLASH_TIME_OFF or 0.75;
local BUFF_MIN_ALPHA = BUFF_MIN_ALPHA or 0.3;

local BUFF_DURATION_WARNING_TIME = BUFF_DURATION_WARNING_TIME or 60;
local BUFF_WARNING_TIME = BUFF_WARNING_TIME or 31;

function DragonflightUIBuffFrameContainerTemplateMixin:OnLoad()
    print('DragonflightUIBuffFrameContainerTemplateMixin:OnLoad()')

    local header = CreateFrame("Frame", self:GetName() .. "Header", nil, "SecureAuraHeaderTemplate");
    header:SetPoint('TOPRIGHT', self, 'TOPRIGHT', 0, 0);
    self.Header = header;
    print('~', header:GetName())

    header:SetAttribute("unit", "player");
    header:SetAttribute("template", "DragonflightUIAuraButtonTemplate");
    header:SetAttribute("minWidth", 100);
    header:SetAttribute("minHeight", 100);

    header:SetAttribute("point", "TOPRIGHT");
    header:SetAttribute("xOffset", -30 - 5);
    header:SetAttribute("yOffset", 0);
    header:SetAttribute("wrapAfter", 10);
    header:SetAttribute("wrapXOffset", 0);
    header:SetAttribute("wrapYOffset", -30 - 5);
    header:SetAttribute("maxWraps", 2);

    -- sorting
    header:SetAttribute("filter", "HELPFUL");
    header:SetAttribute("separateOwn", "0");

    header:SetAttribute("sortMethod", "INDEX"); -- INDEX or NAME or TIME
    header:SetAttribute("sortDir", "-"); -- - to reverse

    header:Show()

    -- provide a simple iterator to the header
    local function siter_active_children(h, i)
        i = i + 1;
        local child = h:GetAttribute("child" .. i);
        if child and child:IsShown() then return i, child, child:GetAttribute("index"); end
    end

    function header:ActiveChildren()
        return siter_active_children, self, 0;
    end

    -- The update style function
    header.BuffFrameUpdateTime = 0;
    header.BuffFrameFlashTime = 0;
    header.BuffFrameFlashState = 1;
    header.BuffAlphaValue = 1;

    header:HookScript('OnUpdate', function(self, elapsed)
        --
        if (self.BuffFrameUpdateTime > 0) then
            self.BuffFrameUpdateTime = self.BuffFrameUpdateTime - elapsed;
        else
            self.BuffFrameUpdateTime = self.BuffFrameUpdateTime + TOOLTIP_UPDATE_TIME;
        end

        self.BuffFrameFlashTime = self.BuffFrameFlashTime - elapsed;
        if (self.BuffFrameFlashTime < 0) then
            local overtime = -self.BuffFrameFlashTime;
            if (self.BuffFrameFlashState == 0) then
                self.BuffFrameFlashState = 1;
                self.BuffFrameFlashTime = BUFF_FLASH_TIME_ON;
            else
                self.BuffFrameFlashState = 0;
                self.BuffFrameFlashTime = BUFF_FLASH_TIME_OFF;
            end
            if (overtime < self.BuffFrameFlashTime) then
                self.BuffFrameFlashTime = self.BuffFrameFlashTime - overtime;
            end
        end

        if (self.BuffFrameFlashState == 1) then
            self.BuffAlphaValue = (BUFF_FLASH_TIME_ON - self.BuffFrameFlashTime) / BUFF_FLASH_TIME_ON;
        else
            self.BuffAlphaValue = self.BuffFrameFlashTime / BUFF_FLASH_TIME_ON;
        end
        self.BuffAlphaValue = (self.BuffAlphaValue * (1 - BUFF_MIN_ALPHA)) + BUFF_MIN_ALPHA;
    end)

    local function updateAuraDuration(btn, elapsed)
        --
        -- print('updateAuraDuration', btn:GetName(), elapsed)
        local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
              spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitAura("player",
                                                                                                      btn:GetID(),
                                                                                                      "HELPFUL");
        -- print(timeMod)
        if name and duration > 0 then
            btn.Duration:Show()

            local timeLeft = (expirationTime - GetTime());
            if (timeMod > 0) then
                --
                timeLeft = timeLeft / timeMod;
            end

            timeLeft = max(timeLeft, 0);

            btn.Duration:SetFormattedText(SecondsToTimeAbbrev(timeLeft));
            if (timeLeft < BUFF_DURATION_WARNING_TIME) then
                btn.Duration:SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
            else
                btn.Duration:SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
            end

            if (timeLeft < BUFF_WARNING_TIME) then
                btn:SetAlpha(header.BuffAlphaValue);
            else
                btn:SetAlpha(1.0);
            end

            if (header.BuffFrameUpdateTime > 0) then return; end
            if (GameTooltip:IsOwned(btn)) then
                GameTooltip:SetUnitAura(PlayerFrame.unit, btn:GetID(), 'HELPFUL');
            end
        else
            btn.Duration:Hide()
            btn:SetAlpha(1.0);
        end
    end

    local function updateStyle()
        for _, frame in header:ActiveChildren() do

            if not frame.Cooldown then
                local cd = CreateFrame("Cooldown", nil, frame, 'CooldownFrameTemplate')
                cd:SetAllPoints(frame.Icon)
                cd:SetSwipeTexture('Interface\\Addons\\DragonflightUI\\Textures\\maskNewAlpha', 1.0, 1.0, 1.0, 0.8)
                cd:SetReverse(true)
                cd.noCooldownCount = true -- no OmniCC timers
                cd:SetFrameLevel(3)
                frame.Cooldown = cd
            end

            local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
                  spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitAura("player",
                                                                                                          frame:GetID(),
                                                                                                          "HELPFUL");
            -- print('~', name, icon, count, expirationTime - duration)
            if name then
                frame.Icon:SetTexture(icon);
                frame.Icon:Show();

                if count > 1 then
                    frame.Count:SetText(count);
                    frame.count:Show();
                else
                    frame.Count:SetText("");
                end

                if duration > 0 then
                    frame.Cooldown:SetCooldown(expirationTime - duration, duration);
                    frame.Cooldown:SetAlpha(1.0);
                    frame.Cooldown:Show();
                    -- print('dur', expirationTime - duration, duration)
                    frame.Duration:Show()
                    frame.Duration:SetText(duration)

                    frame:SetScript('OnUpdate', updateAuraDuration)
                    updateAuraDuration(frame, 0);
                else
                    frame.Cooldown:Hide();
                    frame.Cooldown:SetCooldown(0, -1);
                    frame.Cooldown:SetAlpha(0);
                    frame.Duration:Hide()
                    frame:SetScript('OnUpdate', nil)
                    frame:SetAlpha(1.0)
                end
            else
                frame.Icon:Hide();
                frame.Count:Hide();
                frame.Cooldown:Hide();
                frame.Cooldown:SetCooldown(0, -1);
                frame.Cooldown:SetAlpha(0);
                frame:SetScript('OnUpdate', nil)
            end
        end
    end

    header:HookScript('OnEvent', function(event, ...)
        --
        -- print('OnEvent:', event, ...)
        updateStyle()
    end)
    updateStyle()
end

-- function DragonflightUIBuffFrameContainerTemplate:OnEvent(event, ...)
--     print('OnEvent:', event, ...)
--     self:UpdateStyle()
-- end

-- function DragonflightUIBuffFrameContainerTemplate:OnUpdate(elapsed)
--     if (self.BuffFrameUpdateTime > 0) then
--         self.BuffFrameUpdateTime = self.BuffFrameUpdateTime - elapsed;
--     else
--         self.BuffFrameUpdateTime = self.BuffFrameUpdateTime + TOOLTIP_UPDATE_TIME;
--     end

--     self.BuffFrameFlashTime = self.BuffFrameFlashTime - elapsed;
--     if (self.BuffFrameFlashTime < 0) then
--         local overtime = -self.BuffFrameFlashTime;
--         if (self.BuffFrameFlashState == 0) then
--             self.BuffFrameFlashState = 1;
--             self.BuffFrameFlashTime = BUFF_FLASH_TIME_ON;
--         else
--             self.BuffFrameFlashState = 0;
--             self.BuffFrameFlashTime = BUFF_FLASH_TIME_OFF;
--         end
--         if (overtime < self.BuffFrameFlashTime) then
--             self.BuffFrameFlashTime = self.BuffFrameFlashTime - overtime;
--         end
--     end

--     if (self.BuffFrameFlashState == 1) then
--         self.BuffAlphaValue = (BUFF_FLASH_TIME_ON - self.BuffFrameFlashTime) / BUFF_FLASH_TIME_ON;
--     else
--         self.BuffAlphaValue = self.BuffFrameFlashTime / BUFF_FLASH_TIME_ON;
--     end
--     self.BuffAlphaValue = (self.BuffAlphaValue * (1 - BUFF_MIN_ALPHA)) + BUFF_MIN_ALPHA;
-- end

-- -- provide a simple iterator to the header
-- local function siter_active_children(h, i)
--     i = i + 1;
--     local child = h:GetAttribute("child" .. i);
--     if child and child:IsShown() then return i, child, child:GetAttribute("index"); end
-- end

-- function DragonflightUIBuffFrameHeaderTemplateMixin:ActiveChildren()
--     return siter_active_children, self, 0;
-- end

-- function DragonflightUIBuffFrameContainerTemplate:UpdateStyle()
--     print('~~UpdateStyle()')
--     for _, frame in self:ActiveChildren() do
--         print(_, frame, frame:GetName())

--         local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
--               spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitAura("player",
--                                                                                                       frame:GetID(),
--                                                                                                       "HELPFUL");
--         -- print('~', name, icon, count, expirationTime - duration)
--         if name then
--             frame.Icon:SetTexture(icon);
--             frame.Icon:Show();

--             if count > 1 then
--                 frame.Count:SetText(count);
--                 frame.count:Show();
--             else
--                 frame.Count:SetText("");
--             end

--             if duration > 0 then
--                 frame.Cooldown:SetCooldown(expirationTime - duration, duration);
--                 frame.Cooldown:SetAlpha(1.0);
--                 frame.Cooldown:Show();
--                 -- print('dur', expirationTime - duration, duration)
--                 -- frame.Duration:Show()
--                 -- frame.Duration:SetText(duration)

--                 -- frame:SetScript('OnUpdate', frame.updateAuraDuration)
--                 -- frame.updateAuraDuration(0);
--             else
--                 frame.Cooldown:Hide();
--                 frame.Cooldown:SetCooldown(0, -1);
--                 frame.Cooldown:SetAlpha(0);
--                 -- frame.Duration:Hide()
--                 -- frame:SetScript('OnUpdate', nil)
--                 -- frame:SetAlpha(1.0)
--             end
--         else
--             frame.Icon:Hide();
--             frame.Count:Hide();
--             frame.Cooldown:Hide();
--             frame.Cooldown:SetCooldown(0, -1);
--             frame.Cooldown:SetAlpha(0);
--             -- frame:SetScript('OnUpdate', nil)
--         end
--     end
-- end

-- button template
DragonflightUIAuraButtonTemplateMixin = {}

function DragonflightUIAuraButtonTemplateMixin:OnLoad()
    self:RegisterForClicks("RightButtonUp")

    local cd = CreateFrame("Cooldown", nil, self, 'CooldownFrameTemplate')
    cd:SetAllPoints(self.Icon)
    cd:SetSwipeTexture('Interface\\Addons\\DragonflightUI\\Textures\\maskNewAlpha', 1.0, 1.0, 1.0, 0.8)
    cd:SetReverse(true)
    cd.noCooldownCount = true -- no OmniCC timers
    cd:SetFrameLevel(3)
    self.Cooldown = cd
end

function DragonflightUIAuraButtonTemplateMixin:UpdateStyle()
end

function DragonflightUIAuraButtonTemplateMixin:UpdateAuraDuration(elapsed)
    -- print('updateAuraDuration', btn:GetName(), elapsed)
    local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId,
          canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod =
        UnitAura("player", self:GetID(), "HELPFUL");
    -- print(timeMod)
    if name and duration > 0 then
        self.Duration:Show()

        local timeLeft = (expirationTime - GetTime());
        if (timeMod > 0) then
            --
            timeLeft = timeLeft / timeMod;
        end

        timeLeft = max(timeLeft, 0);

        self.Duration:SetFormattedText(SecondsToTimeAbbrev(timeLeft));
        if (timeLeft < BUFF_DURATION_WARNING_TIME) then
            self.Duration:SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
        else
            self.Duration:SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        end

        if (timeLeft < BUFF_WARNING_TIME) then
            self:SetAlpha(self:GetParent().BuffAlphaValue);
        else
            self:SetAlpha(1.0);
        end

        if (header.BuffFrameUpdateTime > 0) then return; end
        if (GameTooltip:IsOwned(self)) then GameTooltip:SetUnitAura(PlayerFrame.unit, self:GetID(), 'HELPFUL'); end
    else
        self.Duration:Hide()
        self:SetAlpha(1.0);
    end
end

