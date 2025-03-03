DragonflightUIBuffFrameContainerTemplateMixin = {}

local TOOLTIP_UPDATE_TIME = TOOLTIP_UPDATE_TIME or 0.2;
local BUFF_FLASH_TIME_ON = BUFF_FLASH_TIME_ON or 0.75;
local BUFF_FLASH_TIME_OFF = BUFF_FLASH_TIME_OFF or 0.75;
local BUFF_MIN_ALPHA = BUFF_MIN_ALPHA or 0.3;

local BUFF_DURATION_WARNING_TIME = BUFF_DURATION_WARNING_TIME or 60;
local BUFF_WARNING_TIME = BUFF_WARNING_TIME or 31;

function DragonflightUIBuffFrameContainerTemplateMixin:OnLoad()
    -- print('DragonflightUIBuffFrameContainerTemplateMixin:OnLoad()')
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

    header:SetAttribute("includeWeapons", 2);
    header:SetAttribute("weaponTemplate", 'DragonflightUIAuraButtonBuffTemplate');

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
    header:SetAttribute("sortDirection", "-"); -- - to reverse

    -- consolidate
    -- header:SetAttribute("consolidateTo", 1);
    -- header:SetAttribute("consolidateDuration", 30);
    -- header:SetAttribute("consolidateThreshold", 10);
    -- header:SetAttribute("consolidateFraction", 0.1);
    -- header:SetAttribute("consolidateProxy", "DragonflightUIConsolidatedBuffsTemplate");
    -- header:SetAttribute("consolidateHeader", "DragonflightUIConsolidateBuffsProxyHeaderTemplate"); -- ??

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

    function header:UpdateStyle()
        for _, frame in header:ActiveChildren() do
            --
            frame:UpdateStyle()
        end
    end

    header:HookScript('OnEvent', function(event, ...)
        --
        -- print('OnEvent:', event, ...)
        header:UpdateStyle()
    end)
    header:UpdateStyle()
end

function DragonflightUIBuffFrameContainerTemplateMixin:SetState(state)
    self.state = state
    self:Update()
    -- DevTools_Dump(state)
end

function DragonflightUIBuffFrameContainerTemplateMixin:Update()
    -- print('DragonflightUIBuffFrameContainerTemplateMixin:Update()')
    local state = self.state
    local header = self.Header

    -- header:SetAttribute("unit", "player");
    -- header:SetAttribute("minWidth", 30);
    -- header:SetAttribute("minHeight", 30);

    -- header:SetAttribute("point", "TOPRIGHT");
    header:SetAttribute("xOffset", -30 - state.paddingX);
    header:SetAttribute("yOffset", state.paddingY);
    header:SetAttribute("wrapAfter", state.wrapAfter);
    header:SetAttribute("wrapXOffset", state.wrapXOffset);
    header:SetAttribute("wrapYOffset", -30 - state.wrapYOffset);
    header:SetAttribute("maxWraps", state.maxWraps);

    -- sorting
    -- header:SetAttribute("filter", filter);
    header:SetAttribute("separateOwn", state.seperateOwn);
    header:SetAttribute("sortMethod", state.sortMethod); -- INDEX or NAME or TIME
    header:SetAttribute("sortDirection", state.sortDirection); -- - to reverse

    header:UpdateStyle()
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

    -- print('~~p', self:GetParent():GetName(), self:GetScale())
    -- self:SetScale(1.5)

    --
    local filter = self:GetAttribute('DFFilter');

    DragonflightUIMixin:AddIconBorder(self, true)
    self.DFIconBorder:SetDesaturated(false)
    self.DFIconBorder:SetVertexColor(1.0, 1.0, 1.0)
end

function DragonflightUIAuraButtonTemplateMixin:UpdateStyle()
    local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId,
          canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod, shouldConsolidate = UnitAura("player",
                                                                                                            self:GetID(),
                                                                                                            "HELPFUL");
    -- print('~', name, icon, count, expirationTime - duration)
    -- local auraData = C_UnitAuras.GetAuraDataByIndex('player', self:GetID(), 'HELPFUL');
    -- print('~', name, shouldConsolidate, #auraData.points > 0)

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

DragonflightUIConsolidatedBuffsTemplateMixin = {}

function DragonflightUIConsolidatedBuffsTemplateMixin:OnLoad()
    -- print('ON LOADS')
    local icon = _G[self:GetName() .. 'Icon']
    icon:SetTexture("Interface\\Buttons\\BuffConsolidation");
    icon:SetTexCoord(0, 0.5, 0, 1);
    icon:ClearAllPoints();
    icon:SetPoint("CENTER");
    icon:SetWidth(64);
    icon:SetHeight(64);

    if not self.Tooltip then
        --
        self.Tooltip = CreateFrame('Frame', 'DragonflightUIConsolidatedBuffsTooltip', self,
                                   'DragonflightUIConsolidatedBuffsTooltip')
    end
end

function DragonflightUIConsolidatedBuffsTemplateMixin:OnUpdate()
    if (self.mousedOver and not self:IsMouseOver(1, -1, -1, 1)) then
        self.mousedOver = nil;
        if (not self.Tooltip:IsMouseOver()) then self.Tooltip:Hide(); end
    end

    -- 	-- check exit times
    -- if ( not ConsolidatedBuffs.pauseUpdate ) then
    -- 	local needUpdate = false;
    -- 	local timeNow = GetTime();
    -- 	for buffIndex, buff in pairs(consolidatedBuffs) do
    -- 		if ( buff.exitTime and buff.exitTime < timeNow ) then
    -- 			buff.consolidated = false;
    -- 			buff.timeLeft = buff.expirationTime - timeNow;
    -- 			tremove(consolidatedBuffs, buffIndex);
    -- 			needUpdate = true;
    -- 		end
    -- 	end
    -- 	if ( needUpdate ) then			
    -- 		if ( #consolidatedBuffs == 0 ) then
    -- 			BuffFrame.numConsolidated = 0;
    -- 			ConsolidatedBuffs:Hide();
    -- 		else
    -- 			BuffFrame_UpdateAllBuffAnchors();
    -- 			ConsolidatedBuffsCount:SetText(#consolidatedBuffs);
    -- 		end			
    -- 	end
    -- end
end

function DragonflightUIConsolidatedBuffsTemplateMixin:OnEnter()
    self.Tooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, 0);
    -- check expiration times
    local timeNow = GetTime();
    -- for buffIndex, buff in pairs(consolidatedBuffs) do
    -- 	if ( buff.timeLeft ) then
    -- 		buff.timeLeft = buff.expirationTime - timeNow;
    -- 	end
    -- end
    -- ConsolidatedBuffs_UpdateAllAnchors();

    local header = self:GetAttribute('header')
    local handle = self:GetAttribute('frameref-header')

    -- local ref = _G[handle:GetName()]
    -- DevTools_Dump(handle:GetName())

    -- print(ref:GetAttribute('template'))
    -- ref:SetPoint('TOPLEFT', self.Tooltip.Container, 'TOPLEFT', 0, 0)
    -- ref:Show()
    -- ref:UpdateStyle()
    -- DevTools_Dump(f)
    -- print('~~f:', f:GetName())
    -- f:ClearAllPoints()
    -- self.Tooltip:Show();
    -- ref:SetPoint('TOPLEFT', self.Tooltip.Container, 'TOPLEFT', 0, 0)
    -- ref:SetPoint('BOTTOMRIGHT', self.Tooltip.Container, 'BOTTOMRIGHT', 0, 0)
    -- ref:SetPoint('TOPLEFT', UIParent, 'CENTER', -50, 50)
    -- ref:SetPoint('BOTTOMRIGHT', UIParent, 'CENTER', 50, -50)
    self.mousedOver = true;
end

function DragonflightUIConsolidatedBuffsTemplateMixin:OnShow()
    -- ConsolidatedBuffsCount:SetText(BuffFrame.numConsolidated);
    -- TemporaryEnchantFrame:SetPoint("TOPRIGHT", ConsolidatedBuffs, "TOPLEFT", -6, 0);
    -- BuffFrame_UpdateAllBuffAnchors();
end

function DragonflightUIConsolidatedBuffsTemplateMixin:OnHide()
    self.mousedOver = nil;
    self.Tooltip:Hide();
    -- TemporaryEnchantFrame:SetPoint("TOPRIGHT", ConsolidatedBuffs, "TOPRIGHT", 0, 0);
    -- BuffFrame_UpdateAllBuffAnchors();
end

-- 
DragonflightUIConsolidateBuffsProxyHeaderTemplateMixin = {}

function DragonflightUIConsolidateBuffsProxyHeaderTemplateMixin:OnLoad()
    print('PROXY LOAAAAAD')
    print(self:GetSize())
    print(self:GetPoint(1))

    self:SetAttribute("template", "DragonflightUIAuraButtonBuffTemplate");

    self:SetAttribute("minWidth", 30);
    self:SetAttribute("minHeight", 30);

    self:SetAttribute("point", "TOPLEFT");
    self:SetAttribute("xOffset", 30 + 5);
    self:SetAttribute("yOffset", 0);
    self:SetAttribute("wrapAfter", 10);
    self:SetAttribute("wrapXOffset", 0);
    self:SetAttribute("wrapYOffset", -30 - 5);
    self:SetAttribute("maxWraps", 2);

    -- sorting
    -- self:SetAttribute("filter", 'HELPFUL');
    -- self:SetAttribute("separateOwn", "0");

    -- self:SetAttribute("sortMethod", "INDEX"); -- INDEX or NAME or TIME
    -- self:SetAttribute("sortDirection", "-"); -- - to reverse

    -- self:SetAttribute("consolidateTo", 0);
    self:SetAttribute("groupBy", 'HELPFUL');

    -- self:SetAttribute("consolidateDuration", 30);
    -- self:SetAttribute("consolidateThreshold", 10);
    -- self:SetAttribute("consolidateFraction", 0.1);

    self.BuffFrameUpdateTime = 0;
    self.BuffFrameFlashTime = 0;
    self.BuffFrameFlashState = 1;
    self.BuffAlphaValue = 1;

    -- provide a simple iterator to the header
    local function siter_active_children(h, i)
        i = i + 1;
        local child = h:GetAttribute("child" .. i);
        if child and child:IsShown() then return i, child, child:GetAttribute("index"); end
    end

    function self:ActiveChildren()
        return siter_active_children, self, 0;
    end

    function self:UpdateStyle()
        print('proxy UpdateStyle()')
        local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint(1)
        -- print('....', point, relativeTo:GetName(), relativePoint, xOfs, yOfs)

        for _, frame in self:ActiveChildren() do
            --
            print('~', frame:GetName())
            local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint(1)
            print('~~', point, relativeTo:GetName(), relativePoint, xOfs, yOfs)
            frame:UpdateStyle()
        end
    end

    self:HookScript('OnEvent', function(event, ...)
        --
        -- print('OnEvent:', event, ...)
        self:UpdateStyle()
    end)
    self:UpdateStyle()
end
