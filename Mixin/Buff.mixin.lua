DragonflightUIBuffFrameContainerTemplateMixin = {}

local TOOLTIP_UPDATE_TIME = TOOLTIP_UPDATE_TIME or 0.2;
local BUFF_FLASH_TIME_ON = BUFF_FLASH_TIME_ON or 0.75;
local BUFF_FLASH_TIME_OFF = BUFF_FLASH_TIME_OFF or 0.75;
local BUFF_MIN_ALPHA = BUFF_MIN_ALPHA or 0.3;

local BUFF_DURATION_WARNING_TIME = BUFF_DURATION_WARNING_TIME or 60;
local BUFF_WARNING_TIME = BUFF_WARNING_TIME or 31;

function DragonflightUIBuffFrameContainerTemplateMixin:OnLoad()
    print('DragonflightUIBuffFrameContainerTemplateMixin:OnLoad()')
    local filter = self:GetAttribute('DFFilter');
    local name;
    if filter == 'HELPFUL' then
        name = 'DFPlayerBuff'
    elseif filter == 'HARMFUL' then
        name = 'DFPlayerDebuff'
    else
        print('shouldnt happen :§')
    end

    local header = CreateFrame("Frame", name, nil, "SecureAuraHeaderTemplate");
    header:SetPoint('TOPRIGHT', self, 'TOPRIGHT', 0, 0);
    self.Header = header;
    -- print('~', header:GetName())

    if filter == 'HELPFUL' then
        header:SetAttribute("template", "DragonflightUIAuraButtonBuffTemplate");
    elseif filter == 'HARMFUL' then
        header:SetAttribute("template", "DragonflightUIAuraButtonDebuffTemplate");
    else
        print('shouldnt happen :§')
    end

    header:SetAttribute("unit", "player");
    header:SetAttribute("minWidth", 30);
    header:SetAttribute("minHeight", 30);

    header:SetAttribute("point", "TOPRIGHT");
    header:SetAttribute("xOffset", -30 - 5);
    header:SetAttribute("yOffset", 0);
    header:SetAttribute("wrapAfter", 10);
    header:SetAttribute("wrapXOffset", 0);
    header:SetAttribute("wrapYOffset", -30 - 5);
    header:SetAttribute("maxWraps", 2);

    -- sorting
    header:SetAttribute("filter", filter);
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

    local function updateStyle()
        for _, frame in header:ActiveChildren() do
            --
            frame:UpdateStyle()
        end
    end

    header:HookScript('OnEvent', function(event, ...)
        --
        -- print('OnEvent:', event, ...)
        updateStyle()
    end)
    updateStyle()
end

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

    --
    local filter = self:GetAttribute('DFFilter');

    DragonflightUIMixin:AddIconBorder(self, true)
    self.DFIconBorder:SetDesaturated(false)
    self.DFIconBorder:SetVertexColor(1.0, 1.0, 1.0)
end

function DragonflightUIAuraButtonTemplateMixin:UpdateStyle()
    local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId,
          canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod =
        UnitAura("player", self:GetID(), "HELPFUL");
    -- print('~', name, icon, count, expirationTime - duration)
    if name then
        self.Icon:SetTexture(icon);
        self.Icon:Show();

        if count > 1 then
            self.Count:SetText(count);
            self.count:Show();
        else
            self.Count:SetText("");
        end

        if duration > 0 then
            self.Cooldown:SetCooldown(expirationTime - duration, duration);
            self.Cooldown:SetAlpha(1.0);
            self.Cooldown:Show();
            -- print('dur', expirationTime - duration, duration)
            self.Duration:Show()
            self.Duration:SetText(duration)

            self:SetScript('OnUpdate', self.UpdateAuraDuration)
            self:UpdateAuraDuration(0);
        else
            self.Cooldown:Hide();
            self.Cooldown:SetCooldown(0, -1);
            self.Cooldown:SetAlpha(0);
            self.Duration:Hide()
            self:SetScript('OnUpdate', nil)
            self:SetAlpha(1.0)
        end
    else
        self.Icon:Hide();
        self.Count:Hide();
        self.Cooldown:Hide();
        self.Cooldown:SetCooldown(0, -1);
        self.Cooldown:SetAlpha(0);
        self:SetScript('OnUpdate', nil)
    end
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

        if (self:GetParent().BuffFrameUpdateTime > 0) then return; end
        if (GameTooltip:IsOwned(self)) then GameTooltip:SetUnitAura(PlayerFrame.unit, self:GetID(), 'HELPFUL'); end
    else
        self.Duration:Hide()
        self:SetAlpha(1.0);
    end
end

