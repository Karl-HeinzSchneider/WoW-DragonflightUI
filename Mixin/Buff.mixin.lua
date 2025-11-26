local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

DragonflightUIBuffContainerMixin = {}

local seperateOwnTable = {
    {value = '-1', text = 'after', tooltip = 'descr', label = 'label'},
    {value = '0', text = 'before', tooltip = 'descr', label = 'label'},
    {value = '1', text = 'no seperation', tooltip = 'descr', label = 'label'}
}

local sortMethodTable = {
    {value = 'INDEX', text = 'Index', tooltip = 'descr', label = 'label'},
    {value = 'NAME', text = 'Name', tooltip = 'descr', label = 'label'},
    {value = 'TIME', text = 'Time', tooltip = 'descr', label = 'label'}
}

local sortDirectionTable = {
    {value = '+', text = '+', tooltip = 'descr', label = 'label'},
    {value = '-', text = '-', tooltip = 'descr', label = 'label'}
}

local orientationTable = {
    {value = 'leftToRight', text = 'Left To Right', tooltip = 'descr', label = 'label'},
    {value = 'rightToLeft', text = 'Right To Left', tooltip = 'descr', label = 'label'}
}

local pointTable = {
    {value = 'TOP', text = 'TOP', tooltip = 'descr', label = 'label'},
    {value = 'RIGHT', text = 'RIGHT', tooltip = 'descr', label = 'label'},
    {value = 'BOTTOM', text = 'BOTTOM', tooltip = 'descr', label = 'label'},
    {value = 'LEFT', text = 'LEFT', tooltip = 'descr', label = 'label'},
    {value = 'TOPRIGHT', text = 'TOPRIGHT', tooltip = 'descr', label = 'label'},
    {value = 'TOPLEFT', text = 'TOPLEFT', tooltip = 'descr', label = 'label'},
    {value = 'BOTTOMLEFT', text = 'BOTTOMLEFT', tooltip = 'descr', label = 'label'},
    {value = 'BOTTOMRIGHT', text = 'BOTTOMRIGHT', tooltip = 'descr', label = 'label'}
}

function DragonflightUIBuffContainerMixin:AddAuraTable(Module, optionTable, sub, getDefaultStr)
    local AuraHeaderTable = {
        headerStyling = {
            type = 'header',
            name = L["BuffsAura"],
            desc = L["BuffsAuraDesc"],
            order = 20,
            isExpanded = true,
            editmode = true
        },
        -- castTimeEnabled = {
        --     type = 'toggle',
        --     name = L["CastbarTableShowCastTimeText"],
        --     desc = L["CastbarTableShowCastTimeTextDesc"] .. getDefaultStr('castTimeEnabled', sub),
        --     group = 'headerStyling',
        --     order = 14,
        --     editmode = true
        -- },
        ----
        seperateOwn = {
            type = 'select',
            name = L["BuffsSeperateOwn"],
            desc = L["BuffsSeperateOwnDesc"] .. getDefaultStr('seperateOwn', sub),
            dropdownValues = seperateOwnTable,
            order = 1,
            group = 'headerStyling',
            editmode = true
        },
        sortMethod = {
            type = 'select',
            name = L["BuffsSortMethod"],
            desc = L["BuffsSortMethodDesc"] .. getDefaultStr('sortMethod', sub),
            dropdownValues = sortMethodTable,
            order = 2,
            group = 'headerStyling',
            editmode = true
        },
        sortDirection = {
            type = 'select',
            name = L["BuffsSortDirection"],
            desc = L["BuffsSortDirectionDesc"] .. getDefaultStr('sortDirection', sub),
            dropdownValues = sortDirectionTable,
            order = 3,
            group = 'headerStyling',
            editmode = true
        },
        paddingX = {
            type = 'range',
            name = L["BuffsPaddingX"],
            desc = L["BuffsPaddingXDesc"] .. getDefaultStr('paddingX', sub),
            min = 0,
            max = 30,
            bigStep = 0.1,
            group = 'headerStyling',
            order = 5,
            editmode = true
        },
        paddingY = {
            type = 'range',
            name = L["BuffsPaddingY"],
            desc = L["BuffsPaddingYDesc"] .. getDefaultStr('paddingY', sub),
            min = 0,
            max = 30,
            bigStep = 0.1,
            group = 'headerStyling',
            order = 6,
            editmode = true
        },
        wrapAfter = {
            type = 'range',
            name = L["BuffsWrapAfter"],
            desc = L["BuffsWrapAfterDesc"] .. getDefaultStr('wrapAfter', sub),
            min = 0,
            max = 32,
            bigStep = 1,
            group = 'headerStyling',
            order = 11,
            editmode = true
        },
        wrapXOffset = {
            type = 'range',
            name = L["BuffsWrapXOffset"],
            desc = L["BuffsWrapXOffsetDesc"] .. getDefaultStr('wrapXOffset', sub),
            min = 0,
            max = 30,
            bigStep = 1,
            group = 'headerStyling',
            order = 12,
            editmode = true
        },
        wrapYOffset = {
            type = 'range',
            name = L["BuffsWrapYOffset"],
            desc = L["BuffsWrapYOffsetDesc"] .. getDefaultStr('wrapYOffset', sub),
            min = 0,
            max = 30,
            bigStep = 1,
            group = 'headerStyling',
            order = 13,
            editmode = true
        },
        maxWraps = {
            type = 'range',
            name = L["BuffsMaxWraps"],
            desc = L["BuffsMaxWrapsDesc"] .. getDefaultStr('maxWraps', sub),
            min = 0,
            max = 32,
            bigStep = 1,
            group = 'headerStyling',
            order = 14,
            editmode = true
        }
    }

    for k, v in pairs(AuraHeaderTable) do
        --
        optionTable.args[k] = v
    end
end

function DragonflightUIBuffContainerMixin:AddAuraHeaderTable(Module, optionTable, sub, getDefaultStr)
    local AuraHeaderTable = {
        headerStyling = {
            type = 'header',
            name = L["BuffsHeaderAura"],
            desc = L["BuffsHeaderAuraDesc"],
            order = 20.1,
            isExpanded = true,
            editmode = true
        },
        headerStylingAura = {
            type = 'header',
            name = L["BuffsHeaderStylingAura"],
            desc = L["BuffsHeaderStylingAuraDesc"],
            order = 20.2,
            isExpanded = true,
            editmode = true
        },
        -- castTimeEnabled = {
        --     type = 'toggle',
        --     name = L["CastbarTableShowCastTimeText"],
        --     desc = L["CastbarTableShowCastTimeTextDesc"] .. getDefaultStr('castTimeEnabled', sub),
        --     group = 'headerStyling',
        --     order = 14,
        --     editmode = true
        -- },
        ----
        seperateOwn = {
            type = 'select',
            name = L["BuffsSeperateOwn"],
            desc = L["BuffsSeperateOwnDesc"] .. getDefaultStr('seperateOwn', sub),
            dropdownValues = seperateOwnTable,
            order = 11,
            group = 'headerStyling',
            editmode = true
        },
        sortMethod = {
            type = 'select',
            name = L["BuffsSortMethod"],
            desc = L["BuffsSortMethodDesc"] .. getDefaultStr('sortMethod', sub),
            dropdownValues = sortMethodTable,
            order = 12,
            group = 'headerStyling',
            editmode = true
        },
        sortDirection = {
            type = 'select',
            name = L["BuffsSortDirection"],
            desc = L["BuffsSortDirectionDesc"] .. getDefaultStr('sortDirection', sub),
            dropdownValues = sortDirectionTable,
            order = 13,
            group = 'headerStyling',
            editmode = true
        },
        -- point = {
        --     type = 'select',
        --     name = L["BuffsPoint"],
        --     desc = L["BuffsPointDesc"] .. getDefaultStr('point', sub),
        --     dropdownValues = pointTable,
        --     order = 4,
        --     group = 'headerStyling',
        --     editmode = true
        -- },
        orientation = {
            type = 'select',
            name = L["BuffsOrientation"],
            desc = L["BuffsOrientationDesc"] .. getDefaultStr('orientation', sub),
            dropdownValues = orientationTable,
            order = 1,
            group = 'headerStyling',
            editmode = true
        },
        growthDirection = {
            type = 'select',
            name = L["BuffsGrowthDirection"],
            desc = L["BuffsGrowthDirectionDesc"] .. getDefaultStr('growthDirection', sub),
            dropdownValues = DF.Settings.GrowthDirectionTable,
            order = 2,
            group = 'headerStyling',
            editmode = true
        },
        paddingX = {
            type = 'range',
            name = L["BuffsPaddingX"],
            desc = L["BuffsPaddingXDesc"] .. getDefaultStr('paddingX', sub),
            min = 0,
            max = 30,
            bigStep = 0.1,
            group = 'headerStyling',
            order = 5,
            editmode = true
        },
        paddingY = {
            type = 'range',
            name = L["BuffsPaddingY"],
            desc = L["BuffsPaddingYDesc"] .. getDefaultStr('paddingY', sub),
            min = 0,
            max = 30,
            bigStep = 0.1,
            group = 'headerStyling',
            order = 6,
            editmode = true
        },
        wrapAfter = {
            type = 'range',
            name = L["BuffsWrapAfter"],
            desc = L["BuffsWrapAfterDesc"] .. getDefaultStr('wrapAfter', sub),
            min = 0,
            max = 32,
            bigStep = 1,
            group = 'headerStyling',
            order = 21,
            editmode = true
        },
        -- wrapXOffset = {
        --     type = 'range',
        --     name = L["BuffsWrapXOffset"],
        --     desc = L["BuffsWrapXOffsetDesc"] .. getDefaultStr('wrapXOffset', sub),
        --     min = 0,
        --     max = 30,
        --     bigStep = 1,
        --     group = 'headerStyling',
        --     order = 12,
        --     editmode = true
        -- },
        -- wrapYOffset = {
        --     type = 'range',
        --     name = L["BuffsWrapYOffset"],
        --     desc = L["BuffsWrapYOffsetDesc"] .. getDefaultStr('wrapYOffset', sub),
        --     min = 0,
        --     max = 30,
        --     bigStep = 1,
        --     group = 'headerStyling',
        --     order = 13,
        --     editmode = true
        -- },
        maxWraps = {
            type = 'range',
            name = L["BuffsMaxWraps"],
            desc = L["BuffsMaxWrapsDesc"] .. getDefaultStr('maxWraps', sub),
            min = 0,
            max = 32,
            bigStep = 1,
            group = 'headerStyling',
            order = 22,
            editmode = true
        },
        hideDurationText = {
            type = 'toggle',
            name = L["BuffsHideDurationText"],
            desc = L["BuffsHideDurationTextDesc"] .. getDefaultStr('hideDurationText', sub),
            group = 'headerStylingAura',
            order = 0.1,
            editmode = true
        },
        hideCooldownSwipe = {
            type = 'toggle',
            name = L["BuffsHideCooldownSwipe"],
            desc = L["BuffsHideCooldownSwipeDesc"] .. getDefaultStr('hideCooldownSwipe', sub),
            group = 'headerStylingAura',
            order = 0.2,
            editmode = true
        },
        hideCooldownDurationText = {
            type = 'toggle',
            name = L["BuffsHideCooldownDurationText"],
            desc = L["BuffsHideCooldownDurationTextDesc"] .. getDefaultStr('hideCooldownDurationText', sub),
            group = 'headerStylingAura',
            order = 0.3,
            editmode = true
        }
    }

    for k, v in pairs(AuraHeaderTable) do
        --
        optionTable.args[k] = v
    end
end

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
        name = 'DFPlayerBuffHeader'
    elseif filter == 'HARMFUL' then
        name = 'DFPlayerDebuffHeader'
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

    function header:UpdateStyleAll()
        for _, frame in header:ActiveChildren() do
            --
            frame:UpdateStyle()
        end
    end

    header:HookScript('OnEvent', function(event, ...)
        --
        -- print('OnEvent:', event, ...)
        header:UpdateStyleAll()
    end)
    header:UpdateStyleAll()
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

    local size = 30;

    header:SetAttribute("yOffset", 0);
    header:SetAttribute("wrapXOffset", 0);

    if state.orientation == 'leftToRight' then
        if state.growthDirection == 'down' then
            header:ClearAllPoints()
            header:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0);

            header:SetAttribute("point", 'TOPLEFT');
            header:SetAttribute("xOffset", size + state.paddingX);
            header:SetAttribute("wrapYOffset", -size - state.paddingY);
        else
            header:ClearAllPoints()
            header:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 0, 0 + 14);

            header:SetAttribute("point", 'BOTTOMLEFT');
            header:SetAttribute("xOffset", size + state.paddingX);
            header:SetAttribute("wrapYOffset", size + state.paddingY);
        end
    else
        -- state.orientation == 'rightToLeft' 
        if state.growthDirection == 'down' then
            header:ClearAllPoints()
            header:SetPoint('TOPRIGHT', self, 'TOPRIGHT', 0, 0);

            header:SetAttribute("point", 'TOPRIGHT');
            header:SetAttribute("xOffset", -size - state.paddingX);
            header:SetAttribute("wrapYOffset", -size - state.paddingY);
        else
            header:ClearAllPoints()
            header:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0 + 14);

            header:SetAttribute("point", 'BOTTOMRIGHT');
            header:SetAttribute("xOffset", -size - state.paddingX);
            header:SetAttribute("wrapYOffset", size + state.paddingY);
        end
    end

    header:SetAttribute("wrapAfter", state.wrapAfter);
    header:SetAttribute("maxWraps", state.maxWraps);

    -- sorting
    -- header:SetAttribute("filter", filter);
    header:SetAttribute("separateOwn", state.seperateOwn);
    header:SetAttribute("sortMethod", state.sortMethod); -- INDEX or NAME or TIME
    header:SetAttribute("sortDirection", state.sortDirection); -- - to reverse

    header.state = state;
    header.hideDurationText = state.hideDurationText;
    header.hideCooldownSwipe = state.hideCooldownSwipe;
    header.hideCooldownDurationText = state.hideCooldownDurationText;
    header:UpdateStyleAll();
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
    self.DFUnit = 'player';

    local filter = self:GetAttribute('DFFilter');
    self.DFFilter = filter;

    DragonflightUIMixin:AddIconBorder(self, true)
    self.DFIconBorder:SetDesaturated(false)
    self.DFIconBorder:SetVertexColor(1.0, 1.0, 1.0)
end

function DragonflightUIAuraButtonTemplateMixin:UpdateStyle()
    local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId,
          canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod, shouldConsolidate = UnitAura(self.DFUnit,
                                                                                                            self:GetID(),
                                                                                                            self.DFFilter);
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
        -- self.Cooldown:SetCooldown(0, -1);
        self.Cooldown:SetAlpha(0);
        self:SetScript('OnUpdate', nil)
    end

    local header = self:GetParent();
    if header.hideCooldownSwipe then
        --
        self.Cooldown:Hide()
    end

    self.Cooldown:SetHideCountdownNumbers(header.hideCooldownDurationText)
end

function DragonflightUIAuraButtonTemplateMixin:UpdateAuraDuration(elapsed)
    -- print('updateAuraDuration', self:GetName(), elapsed, self.Duration:GetText())
    local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId,
          canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod =
        UnitAura(self.DFUnit, self:GetID(), self.DFFilter);
    -- print(timeMod) 

    local shouldHide = self:GetParent().hideDurationText

    if name and duration > 0 and not shouldHide then

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
        if (GameTooltip:IsOwned(self)) then GameTooltip:SetUnitAura(self.DFUnit, self:GetID(), self.DFFilter); end
    else
        self.Duration:Hide()
        self:SetAlpha(1.0);
    end
end

-- DragonflightUIConsolidatedBuffsTemplateMixin = {}

-- function DragonflightUIConsolidatedBuffsTemplateMixin:OnLoad()
--     -- print('ON LOADS')
--     local icon = _G[self:GetName() .. 'Icon']
--     icon:SetTexture("Interface\\Buttons\\BuffConsolidation");
--     icon:SetTexCoord(0, 0.5, 0, 1);
--     icon:ClearAllPoints();
--     icon:SetPoint("CENTER");
--     icon:SetWidth(64);
--     icon:SetHeight(64);

--     if not self.Tooltip then
--         --
--         self.Tooltip = CreateFrame('Frame', 'DragonflightUIConsolidatedBuffsTooltip', self,
--                                    'DragonflightUIConsolidatedBuffsTooltip')
--     end
-- end

-- function DragonflightUIConsolidatedBuffsTemplateMixin:OnUpdate()
--     if (self.mousedOver and not self:IsMouseOver(1, -1, -1, 1)) then
--         self.mousedOver = nil;
--         if (not self.Tooltip:IsMouseOver()) then self.Tooltip:Hide(); end
--     end

--     -- 	-- check exit times
--     -- if ( not ConsolidatedBuffs.pauseUpdate ) then
--     -- 	local needUpdate = false;
--     -- 	local timeNow = GetTime();
--     -- 	for buffIndex, buff in pairs(consolidatedBuffs) do
--     -- 		if ( buff.exitTime and buff.exitTime < timeNow ) then
--     -- 			buff.consolidated = false;
--     -- 			buff.timeLeft = buff.expirationTime - timeNow;
--     -- 			tremove(consolidatedBuffs, buffIndex);
--     -- 			needUpdate = true;
--     -- 		end
--     -- 	end
--     -- 	if ( needUpdate ) then			
--     -- 		if ( #consolidatedBuffs == 0 ) then
--     -- 			BuffFrame.numConsolidated = 0;
--     -- 			ConsolidatedBuffs:Hide();
--     -- 		else
--     -- 			BuffFrame_UpdateAllBuffAnchors();
--     -- 			ConsolidatedBuffsCount:SetText(#consolidatedBuffs);
--     -- 		end			
--     -- 	end
--     -- end
-- end

-- function DragonflightUIConsolidatedBuffsTemplateMixin:OnEnter()
--     self.Tooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, 0);
--     -- check expiration times
--     local timeNow = GetTime();
--     -- for buffIndex, buff in pairs(consolidatedBuffs) do
--     -- 	if ( buff.timeLeft ) then
--     -- 		buff.timeLeft = buff.expirationTime - timeNow;
--     -- 	end
--     -- end
--     -- ConsolidatedBuffs_UpdateAllAnchors();

--     local header = self:GetAttribute('header')
--     local handle = self:GetAttribute('frameref-header')

--     -- local ref = _G[handle:GetName()]
--     -- DevTools_Dump(handle:GetName())

--     -- print(ref:GetAttribute('template'))
--     -- ref:SetPoint('TOPLEFT', self.Tooltip.Container, 'TOPLEFT', 0, 0)
--     -- ref:Show()
--     -- ref:UpdateStyle()
--     -- DevTools_Dump(f)
--     -- print('~~f:', f:GetName())
--     -- f:ClearAllPoints()
--     -- self.Tooltip:Show();
--     -- ref:SetPoint('TOPLEFT', self.Tooltip.Container, 'TOPLEFT', 0, 0)
--     -- ref:SetPoint('BOTTOMRIGHT', self.Tooltip.Container, 'BOTTOMRIGHT', 0, 0)
--     -- ref:SetPoint('TOPLEFT', UIParent, 'CENTER', -50, 50)
--     -- ref:SetPoint('BOTTOMRIGHT', UIParent, 'CENTER', 50, -50)
--     self.mousedOver = true;
-- end

-- function DragonflightUIConsolidatedBuffsTemplateMixin:OnShow()
--     -- ConsolidatedBuffsCount:SetText(BuffFrame.numConsolidated);
--     -- TemporaryEnchantFrame:SetPoint("TOPRIGHT", ConsolidatedBuffs, "TOPLEFT", -6, 0);
--     -- BuffFrame_UpdateAllBuffAnchors();
-- end

-- function DragonflightUIConsolidatedBuffsTemplateMixin:OnHide()
--     self.mousedOver = nil;
--     self.Tooltip:Hide();
--     -- TemporaryEnchantFrame:SetPoint("TOPRIGHT", ConsolidatedBuffs, "TOPRIGHT", 0, 0);
--     -- BuffFrame_UpdateAllBuffAnchors();
-- end

-- -- 
-- DragonflightUIConsolidateBuffsProxyHeaderTemplateMixin = {}

-- function DragonflightUIConsolidateBuffsProxyHeaderTemplateMixin:OnLoad()
--     print('PROXY LOAAAAAD')
--     print(self:GetSize())
--     print(self:GetPoint(1))

--     self:SetAttribute("template", "DragonflightUIAuraButtonBuffTemplate");

--     self:SetAttribute("minWidth", 30);
--     self:SetAttribute("minHeight", 30);

--     self:SetAttribute("point", "TOPLEFT");
--     self:SetAttribute("xOffset", 30 + 5);
--     self:SetAttribute("yOffset", 0);
--     self:SetAttribute("wrapAfter", 10);
--     self:SetAttribute("wrapXOffset", 0);
--     self:SetAttribute("wrapYOffset", -30 - 5);
--     self:SetAttribute("maxWraps", 2);

--     -- sorting
--     -- self:SetAttribute("filter", 'HELPFUL');
--     -- self:SetAttribute("separateOwn", "0");

--     -- self:SetAttribute("sortMethod", "INDEX"); -- INDEX or NAME or TIME
--     -- self:SetAttribute("sortDirection", "-"); -- - to reverse

--     -- self:SetAttribute("consolidateTo", 0);
--     self:SetAttribute("groupBy", 'HELPFUL');

--     -- self:SetAttribute("consolidateDuration", 30);
--     -- self:SetAttribute("consolidateThreshold", 10);
--     -- self:SetAttribute("consolidateFraction", 0.1);

--     self.BuffFrameUpdateTime = 0;
--     self.BuffFrameFlashTime = 0;
--     self.BuffFrameFlashState = 1;
--     self.BuffAlphaValue = 1;

--     -- provide a simple iterator to the header
--     local function siter_active_children(h, i)
--         i = i + 1;
--         local child = h:GetAttribute("child" .. i);
--         if child and child:IsShown() then return i, child, child:GetAttribute("index"); end
--     end

--     function self:ActiveChildren()
--         return siter_active_children, self, 0;
--     end

--     function self:UpdateStyle()
--         print('proxy UpdateStyle()')
--         local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint(1)
--         -- print('....', point, relativeTo:GetName(), relativePoint, xOfs, yOfs)

--         for _, frame in self:ActiveChildren() do
--             --
--             print('~', frame:GetName())
--             local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint(1)
--             print('~~', point, relativeTo:GetName(), relativePoint, xOfs, yOfs)
--             frame:UpdateStyle()
--         end
--     end

--     self:HookScript('OnEvent', function(event, ...)
--         --
--         -- print('OnEvent:', event, ...)
--         self:UpdateStyle()
--     end)
--     self:UpdateStyle()
-- end
