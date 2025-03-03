local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Buffs'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        scale = 1,
        buffs = {
            scale = 1,
            anchorFrame = 'MinimapCluster',
            anchor = 'TOPRIGHT',
            anchorParent = 'TOPLEFT',
            x = -55,
            y = -13,
            expanded = true,
            -- Visibility
            showMouseover = false,
            hideAlways = false,
            hideCombat = false,
            hideOutOfCombat = false,
            hidePet = false,
            hideNoPet = false,
            hideStance = false,
            hideStealth = false,
            hideNoStealth = false,
            hideCustom = false,
            hideCustomCond = '',
            useStateHandler = true
        },
        debuffs = {
            scale = 1,
            anchorFrame = 'MinimapCluster',
            anchor = 'TOPRIGHT',
            anchorParent = 'TOPLEFT',
            x = -55,
            y = -13 - 110,
            -- Visibility
            showMouseover = false,
            hideAlways = false,
            hideCombat = false,
            hideOutOfCombat = false,
            hidePet = false,
            hideNoPet = false,
            hideStance = false,
            hideStealth = false,
            hideNoStealth = false,
            hideCustom = false,
            hideCustomCond = ''
        }
    }
}
Module:SetDefaults(defaults)

local function getDefaultStr(key, sub)
    return Module:GetDefaultStr(key, sub)
end

local function setDefaultValues()
    Module:SetDefaultValues()
end

local function setDefaultSubValues(sub)
    Module:SetDefaultSubValues(sub)
end

local function getOption(info)
    return Module:GetOption(info)
end

local function setOption(info, value)
    Module:SetOption(info, value)
end

local presetDesc =
    'Sets Scale, Anchor, AnchorParent, AnchorFrame, X and Y to that of the chosen preset, but does not change any other setting.';

local function setPreset(T, preset, sub)
    -- print('setPreset')
    -- DevTools_Dump(T)
    -- print('---')
    -- DevTools_Dump(preset)

    for k, v in pairs(preset) do
        --
        T[k] = v;
    end
    Module:ApplySettings(sub)
    Module:RefreshOptionScreens()
end

local generalOptions = {
    type = 'group',
    name = 'Buffs',
    get = getOption,
    set = setOption,
    args = {
        -- scale = {
        --     type = 'range',
        --     name = 'Scale',
        --     desc = '' .. getDefaultStr('scale', 'minimap'),
        --     min = 0.1,
        --     max = 5,
        --     bigStep = 0.1,
        --     order = 1
        -- }    
    }
}

local frameTable = {
    {value = 'UIParent', text = 'UIParent', tooltip = 'descr', label = 'label'},
    {value = 'MinimapCluster', text = 'MinimapCluster', tooltip = 'descr', label = 'label'}
}

local buffsOptions = {
    type = 'group',
    name = L["BuffsOptionsName"],
    get = getOption,
    set = setOption,
    args = {
        headerStyling = {
            type = 'header',
            name = L["BuffsOptionsStyle"],
            desc = L["BuffsOptionsStyleDesc"],
            order = 20,
            isExpanded = true,
            editmode = true
        },
        expanded = {
            type = 'toggle',
            name = L["BuffsOptionsExpanded"],
            desc = L["BuffsOptionsExpandedDesc"] .. getDefaultStr('expanded', 'buffs'),
            group = 'headerStyling',
            order = 10,
            new = false,
            editmode = true
        },
        useStateHandler = {
            type = 'toggle',
            name = L["BuffsOptionsUseStateHandler"],
            desc = L["BuffsOptionsUseStateHandlerDesc"] .. getDefaultStr('useStateHandler', 'buffs'),
            group = 'headerStyling',
            order = 115
        }
    }
}

-- blizz options buffs
if DF.Cata then
    local moreOptions = {
        consolidate = {
            type = 'toggle',
            name = CONSOLIDATE_BUFFS_TEXT,
            desc = OPTION_TOOLTIP_CONSOLIDATE_BUFFS,
            group = 'headerStyling',
            order = 13,
            blizzard = true,
            editmode = true
        }
    }

    for k, v in pairs(moreOptions) do buffsOptions.args[k] = v end

    buffsOptions.get = function(info)
        local key = info[1]
        local sub = info[2]

        if sub == 'consolidate' then
            return C_CVar.GetCVarBool("consolidateBuffs")
        else
            return getOption(info)
        end
    end

    local function CVarChangedCB()
        BuffFrame_Update();
    end

    buffsOptions.set = function(info, value)
        local key = info[1]
        local sub = info[2]

        if sub == 'consolidate' then
            if value then
                C_CVar.SetCVar("consolidateBuffs", 1)
            else
                C_CVar.SetCVar("consolidateBuffs", 0)
            end
            CVarChangedCB()
        else
            setOption(info, value)
        end
    end
end
DF.Settings:AddPositionTable(Module, buffsOptions, 'buffs', 'Buffs', getDefaultStr, frameTable)
DragonflightUIStateHandlerMixin:AddStateTable(Module, buffsOptions, 'buffs', 'Buffs', getDefaultStr)
local optionsBuffEditmode = {
    name = 'Buff',
    desc = 'Buff',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        resetPosition = {
            type = 'execute',
            name = L["ExtraOptionsPreset"],
            btnName = L["ExtraOptionsResetToDefaultPosition"],
            desc = L["ExtraOptionsPresetDesc"],
            func = function()
                local dbTable = Module.db.profile.buffs
                local defaultsTable = defaults.profile.buffs
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'buffs')
            end,
            order = 16,
            editmode = true,
            new = true
        }
    }
}

local debuffsOptions = {type = 'group', name = 'Debuffs', get = getOption, set = setOption, args = {}}
DF.Settings:AddPositionTable(Module, debuffsOptions, 'debuffs', 'Debuffs', getDefaultStr, frameTable)
DragonflightUIStateHandlerMixin:AddStateTable(Module, debuffsOptions, 'debuffs', 'Debuffs', getDefaultStr)
local optionsDebuffEditmode = {
    name = 'Debuff',
    desc = 'Debuff',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        resetPosition = {
            type = 'execute',
            name = L["ExtraOptionsPreset"],
            btnName = L["ExtraOptionsResetToDefaultPosition"],
            desc = L["ExtraOptionsPresetDesc"],
            func = function()
                local dbTable = Module.db.profile.debuffs
                local defaultsTable = defaults.profile.debuffs
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'debuffs')
            end,
            order = 16,
            editmode = true,
            new = true
        }
    }
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)
    hooksecurefunc(DF:GetModule('Config'), 'AddConfigFrame', function()
        Module:RegisterSettings()
    end)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    DF:RegisterModuleOptions(mName, generalOptions)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    if DF.Cata then
        Module.Cata()
    elseif DF.Wrath then
        Module.Wrath()
    else
        Module.Era()
    end

    -- Module.AddStateUpdater()
    Module:AddEditMode()

    Module:ApplySettings()
    Module:RegisterOptionScreens()

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)
        Module:ApplySettings()
        Module:RefreshOptionScreens()
    end)
end

function Module:OnDisable()
end

function Module:RegisterSettings()
    local moduleName = 'Buffs'
    local cat = 'misc'
    local function register(name, data)
        data.module = moduleName;
        DF.ConfigModule:RegisterSettingsElement(name, cat, data, true)
    end

    register('buffs', {order = 1, name = 'Buffs', descr = 'Buffsss', isNew = false})
    register('debuffs', {order = 1, name = 'Debuffs', descr = 'Debuffsss', isNew = false})
end

function Module:RegisterOptionScreens()
    DF.ConfigModule:RegisterSettingsData('buffs', 'misc', {
        name = 'Buffs',
        sub = 'buffs',
        options = buffsOptions,
        default = function()
            setDefaultSubValues('buffs')
        end
    })

    DF.ConfigModule:RegisterSettingsData('debuffs', 'misc', {
        name = 'Debuffs',
        sub = 'debuffs',
        options = debuffsOptions,
        default = function()
            setDefaultSubValues('debuffs')
        end
    })
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame
    local cat = 'Misc'
    configFrame:RefreshCatSub(cat, 'Buffs')
    configFrame:RefreshCatSub(cat, 'Debuffs')

    Module.DFBuffFrame.DFEditModeSelection:RefreshOptionScreen();
    Module.DFDebuffFrame.DFEditModeSelection:RefreshOptionScreen();
end

function Module:ApplySettings(sub)
    local db = Module.db.profile

    if db.buffs.useStateHandler and not Module.StateHandlerAdded then
        Module.StateHandlerAdded = true;
        Module.AddStateUpdater()
    end

    Module.UpdateBuffState(db.buffs)
    Module.UpdateDebuffState(db.debuffs)
end

function Module.AddStateUpdater()
    ---

    Mixin(Module.DFBuffFrame, DragonflightUIStateHandlerMixin)
    Module.DFBuffFrame:InitStateHandler()

    Module.DFBuffFrame.DFShower:ClearAllPoints()
    Module.DFBuffFrame.DFShower:SetPoint('TOPLEFT', Module.DFBuffFrame, 'TOPLEFT', -4, 4)
    Module.DFBuffFrame.DFShower:SetPoint('BOTTOMRIGHT', Module.DFBuffFrame, 'BOTTOMRIGHT', 14, -4)

    Module.DFBuffFrame.DFMouseHandler:ClearAllPoints()
    Module.DFBuffFrame.DFMouseHandler:SetPoint('TOPLEFT', Module.DFBuffFrame, 'TOPLEFT', -4, 4)
    Module.DFBuffFrame.DFMouseHandler:SetPoint('BOTTOMRIGHT', Module.DFBuffFrame, 'BOTTOMRIGHT', 14, -4)

    ---

    Mixin(Module.DFDebuffFrame, DragonflightUIStateHandlerMixin)
    Module.DFDebuffFrame:InitStateHandler(4, 4)
end

function Module:AddEditMode()
    local EditModeModule = DF:GetModule('Editmode');
    EditModeModule:AddEditModeToFrame(Module.DFBuffFrame)

    Module.DFBuffFrame.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'Buffs'
    end)

    Module.DFBuffFrame.DFEditModeSelection:RegisterOptions({
        name = 'Buffs',
        sub = 'buffs',
        advancedName = 'Buffs',
        options = buffsOptions,
        extra = optionsBuffEditmode,
        default = function()
            setDefaultSubValues('buffs')
        end,
        moduleRef = self
    });

    -- Module.DFBuffFrame.DFEditModeSelection:ClearAllPoints()
    -- Module.DFBuffFrame.DFEditModeSelection:SetPoint('TOPLEFT', Module.DFBuffFrame, 'TOPLEFT', -16, 32)
    -- Module.DFBuffFrame.DFEditModeSelection:SetPoint('BOTTOMRIGHT', Module.DFBuffFrame, 'BOTTOMRIGHT', 16, -16)

    EditModeModule:AddEditModeToFrame(Module.DFDebuffFrame)

    Module.DFDebuffFrame.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'Debuffs'
    end)

    Module.DFDebuffFrame.DFEditModeSelection:RegisterOptions({
        name = 'Debuffs',
        sub = 'debuffs',
        advancedName = 'Debuffs',
        options = debuffsOptions,
        extra = optionsDebuffEditmode,
        default = function()
            setDefaultSubValues('debuffs')
        end,
        moduleRef = self
    });
end

function Module.CreateBuffFrame()
    local f = CreateFrame('FRAME', 'DragonflightUIBuffFrame', UIParent)
    f:SetSize(30 + (10 - 1) * 35, 30 + (3 - 1) * 35)
    f:SetPoint('TOPRIGHT', MinimapCluster, 'TOPLEFT', -55, -13)
    Module.DFBuffFrame = f
    f:SetClampedToScreen(true)

    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\bagslots2x'

    local toggleFrame = CreateFrame('FRAME', 'DragonflightUIBuffFrameToggleFrame', f)
    toggleFrame:SetSize(16, 30)
    toggleFrame:SetPoint('TOPLEFT', f, 'TOPRIGHT', 0, 0)
    Module.DFToggleFrame = toggleFrame

    local toggle = CreateFrame('CHECKBUTTON', 'DragonflightUI', toggleFrame)
    toggle:SetSize(16, 30)
    toggle:SetPoint('CENTER', toggleFrame, 'CENTER', 0, 0)
    toggle:SetScale(0.48)
    toggle:SetHitRectInsets(-10, -10, -15, -15)

    Module.DFToggleFrame.Toggle = toggle

    toggle:SetNormalTexture(base)
    toggle:SetPushedTexture(base)
    toggle:SetHighlightTexture(base)
    toggle:GetNormalTexture():SetTexCoord(0.951171875, 0.982421875, 0.015625, 0.25)
    toggle:GetHighlightTexture():SetTexCoord(0.951171875, 0.982421875, 0.015625, 0.25)
    toggle:GetPushedTexture():SetTexCoord(0.951171875, 0.982421875, 0.015625, 0.25)

    toggle:SetScript('OnClick', function()
        setOption({'buffs', 'expanded'}, not Module.db.profile.buffs.expanded)
    end)
end

function Module.UpdateBuffState(state)
    local f = Module.DFBuffFrame
    f:SetScale(state.scale)
    f:ClearAllPoints()
    f:SetPoint(state.anchor, state.anchorFrame, state.anchorParent, state.x, state.y)

    -- local toggelFrame = Module.DFToggleFrame
    -- toggleFrame:SetScale(state.scale)
    do
        local rotation

        if (state.expanded) then
            rotation = math.pi
        else
            rotation = 0
        end

        local toggle = Module.DFToggleFrame.Toggle

        toggle:GetNormalTexture():SetRotation(rotation)
        toggle:GetPushedTexture():SetRotation(rotation)
        toggle:GetHighlightTexture():SetRotation(rotation)
    end

    -- BuffFrame:SetScale(state.scale)
    -- BuffFrame:ClearAllPoints()
    -- -- BuffFrame:SetPoint(state.anchor, state.anchorFrame, state.anchorParent, state.x, state.y)
    -- BuffFrame:SetPoint('TOPRIGHT', f, 'TOPRIGHT', 0, 0)

    -- BuffFrame:SetShown(state.expanded)
    -- BuffFrame:SetParent(f)

    -- TemporaryEnchantFrame:SetScale(state.scale)
    -- TemporaryEnchantFrame:SetParent(f)

    -- if Module.StateHandlerAdded then f:UpdateStateHandler(state) end
end

function Module.MoveBuffs()
    hooksecurefunc('UIParent_UpdateTopFramePositions', function()
        -- print('UIParent_UpdateTopFramePositions')
        local state = Module.db.profile.buffs
        Module.UpdateBuffState(state)
    end)
end

function Module:CreateNewBuffs()
    local header = CreateFrame("Frame", "DragonflightUIBuffFrameHeader", nil, "SecureAuraHeaderTemplate");
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

    header:Show();

    header:SetPoint('TOPRIGHT', Module.DFBuffFrame, 'TOPRIGHT', 0, 0)
    header:Show();

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

    local TOOLTIP_UPDATE_TIME = TOOLTIP_UPDATE_TIME or 0.2;
    local BUFF_FLASH_TIME_ON = BUFF_FLASH_TIME_ON or 0.75;
    local BUFF_FLASH_TIME_OFF = BUFF_FLASH_TIME_OFF or 0.75;
    local BUFF_MIN_ALPHA = BUFF_MIN_ALPHA or 0.3;

    header:SetScript('OnUpdate', function(self, elapsed)
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

    local BUFF_DURATION_WARNING_TIME = BUFF_DURATION_WARNING_TIME or 60;
    local BUFF_WARNING_TIME = BUFF_WARNING_TIME or 31;

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

-- set default, may be overriden by darkmode module
Module.BuffVertexColorR = 1.0;
Module.BuffVertexColorG = 1.0;
Module.BuffVertexColorB = 1.0;
Module.BuffDesaturate = false;
function Module.AddBuffBorders()
    -- buffs
    hooksecurefunc('AuraButton_Update', function(buttonName, index, filter) --

        local buffName = buttonName .. index;
        local buff = _G[buffName];

        if not buff then return end
        if not buff:IsShown() then return end

        -- print(buttonName, index, filter)
        local helpful = (filter == "HELPFUL" or filter == "HELPFUL");

        if not buff.DFIconBorder then
            --
            DragonflightUIMixin:AddIconBorder(buff, helpful)
            buff.DFIconBorder:SetDesaturated(Module.BuffDesaturate)
            buff.DFIconBorder:SetVertexColor(Module.BuffVertexColorR, Module.BuffVertexColorG, Module.BuffVertexColorB)
        end

        if (not helpful) then
            local debuffSlot = _G[buffName .. "Border"];
            if not debuffSlot then return end

            debuffSlot:Hide()

            local r, g, b = debuffSlot:GetVertexColor()
            -- print(r, g, b)
            buff.DFIconBorder:SetVertexColor(r, g, b)
        end
    end)

    hooksecurefunc('TargetFrame_UpdateAuras', function(self)
        -- also styles focusFrame
        -- print('TargetFrame_UpdateAuras', self:GetName())
        local frame, frameName, frameStealable;
        local selfName = self:GetName();
        for i = 1, MAX_TARGET_BUFFS do
            frameName = selfName .. "Buff" .. (i);
            frame = _G[frameName];

            if frame and frame:IsShown() then
                -- 
                if not frame.DFIconBorder then
                    --
                    DragonflightUIMixin:AddIconBorder(frame, true)
                    frame.DFIconBorder:SetDesaturated(Module.BuffDesaturate)
                    frame.DFIconBorder:SetVertexColor(Module.BuffVertexColorR, Module.BuffVertexColorG,
                                                      Module.BuffVertexColorB)
                end

                -- TODO: style etc
                -- frameStealable = _G[frameName .. "Stealable"];
                -- frameStealable:Show()
            end
        end

        local maxDebuffs = self.maxDebuffs or MAX_TARGET_DEBUFFS; -- max = 16

        for i = 1, maxDebuffs do
            frameName = selfName .. "Debuff" .. (i);
            frame = _G[frameName];

            if frame and frame:IsShown() then
                -- 
                if not frame.DFIconBorder then
                    --
                    DragonflightUIMixin:AddIconBorder(frame, false)
                end

                local debuffSlot = _G[frameName .. "Border"];
                if debuffSlot then
                    --
                    debuffSlot:Hide()
                    local r, g, b = debuffSlot:GetVertexColor()
                    -- print(r, g, b)
                    frame.DFIconBorder:SetVertexColor(r, g, b)
                end
            end
        end
    end)
end

function Module.CreateDebuffFrame()
    local f = CreateFrame('FRAME', 'DragonflightUIDebuffFrame', UIParent)
    f:SetSize(30 + (10 - 1) * 35, 30 + (2 - 1) * 35)
    f:SetPoint('TOPRIGHT', MinimapCluster, 'TOPLEFT', -55, -13 - 110)
    f:SetClampedToScreen(true)
    Module.DFDebuffFrame = f
end

function Module.MoveDebuffs()
    local f = Module.DFDebuffFrame
    hooksecurefunc('DebuffButton_UpdateAnchors', function(buttonName, index)
        -- print('update', buttonName, index)

        local state = Module.db.profile.debuffs
        local buff = _G[buttonName .. index];
        buff:SetScale(state.scale)
        buff:SetParent(f)
        -- buff:Show()

        if index ~= 1 then return end

        -- buff:SetPoint("TOPRIGHT", BuffFrame, "BOTTOMRIGHT", 0, -DebuffButton1.offsetY);
        buff:ClearAllPoints()
        buff:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0);
    end)
end

function Module.UpdateDebuffState(state)
    local f = Module.DFDebuffFrame
    f:SetScale(state.scale)
    f:ClearAllPoints()
    f:SetPoint(state.anchor, state.anchorFrame, state.anchorParent, state.x, state.y)

    for i = 1, 12 do
        local buff = _G['DebuffButton' .. i];
        if buff then
            buff:SetScale(state.scale)
            buff:SetParent(f)
            -- buff:Show()
        end
    end

    if Module.StateHandlerAdded then f:UpdateStateHandler(state) end
end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1, arg2, arg3)
    -- print('event', event)    
end
frame:SetScript('OnEvent', frame.OnEvent)

-- Cata
function Module.Cata()
    Module.CreateBuffFrame()
    -- Module.AddBuffBorders()
    -- Module.MoveBuffs()
    Module:CreateNewBuffs()
    Module.CreateDebuffFrame()
    Module.MoveDebuffs()
end

-- Wrath
function Module.Wrath()
    Module.CreateBuffFrame()
    Module.AddBuffBorders()
    Module.MoveBuffs()
    Module.CreateDebuffFrame()
    Module.MoveDebuffs()
end

-- Era
function Module.Era()
    Module.CreateBuffFrame()
    -- Module.AddBuffBorders()
    -- Module.MoveBuffs()
    Module:CreateNewBuffs()
    Module.CreateDebuffFrame()
    Module.MoveDebuffs()
end
