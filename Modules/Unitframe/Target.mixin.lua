local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local RangeCheck = LibStub("LibRangeCheck-3.0")
local AuraDurations = LibStub:GetLibrary('AuraDurations-1.0')

local subModuleName = 'Target';
local SubModuleMixin = {};
addonTable.SubModuleMixins[subModuleName] = SubModuleMixin;

function SubModuleMixin:Init()
    self.ModuleRef = DF:GetModule('Unitframe')
    self:SetDefaults()
    self:SetupOptions()

    self.famous = {['Norbert'] = true}

    self:SetScript('OnEvent', self.OnEvent);
end

function SubModuleMixin:SetDefaults()
    local defaults = {
        classcolor = false,
        classicon = false,
        breakUpLargeNumbers = true,
        enableNumericThreat = true,
        numericThreatAnchor = 'TOP',
        enableThreatGlow = true,
        comboPointsOnPlayerFrame = false,
        hideComboPoints = false,
        hideNameBackground = false,
        fadeOut = false,
        fadeOutDistance = 40,
        scale = 1.0,
        override = false,
        anchorFrame = 'UIParent',
        customAnchorFrame = '',
        anchor = 'TOPLEFT',
        anchorParent = 'TOPLEFT',
        x = 250,
        y = -4,
        -- buff - from AuraDurations
        auraSizeSmall = 17, -- SMALL_AURA_SIZE,
        auraSizeLarge = 21, -- LARGE_AURA_SIZE,
        auraOffsetY = 1, -- AURA_OFFSET_Y,
        noDebuffFilter = true, -- noBuffDebuffFilterOnTarget
        dynamicBuffSize = true, -- showDynamicBuffSize
        auraRowWidth = 122, -- AURA_ROW_WIDTH
        totAuraRowWidth = 101, -- TOT_AURA_ROW_WIDTH
        numTotAuraRows = 2, -- NUM_TOT_AURA_ROWS
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
        hideBattlePet = false,
        hideCustom = false,
        hideCustomCond = ''
    };
    self.Defaults = defaults;
end

function SubModuleMixin:SetupOptions()
    local Module = self.ModuleRef;
    local function getDefaultStr(key, sub, extra)
        -- return Module:GetDefaultStr(key, sub)
        local value = self.Defaults[key]
        local defaultFormat = L["SettingsDefaultStringFormat"]
        return string.format(defaultFormat, (extra or '') .. tostring(value))
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

    local function setPreset(T, preset, sub)
        for k, v in pairs(preset) do
            --
            T[k] = v;
        end
        Module:ApplySettings(sub)
        Module:RefreshOptionScreens()
    end

    local frameTable = {
        {value = 'UIParent', text = 'UIParent', tooltip = 'descr', label = 'label'},
        {value = 'PlayerFrame', text = 'PlayerFrame', tooltip = 'descr', label = 'label'},
        {value = 'TargetFrame', text = 'TargetFrame', tooltip = 'descr', label = 'label'},
        {value = 'CompactRaidFrameManager', text = 'CompactRaidFrameManager', tooltip = 'descr', label = 'label'}
    }

    local partyBuffTooltipTable = {
        {value = 'NEVER', text = 'Never', tooltip = 'descr', label = 'label'},
        {value = 'ALWAYS', text = 'Always', tooltip = 'descr', label = 'label'},
        {value = 'INCOMBAT', text = 'In Combat', tooltip = 'descr', label = 'label'}
    }

    if DF.Wrath then
        table.insert(frameTable, {value = 'FocusFrame', text = 'FocusFrame', tooltip = 'descr', label = 'label'})
    end

    local function frameTableWithout(without)
        local newTable = {}

        for k, v in ipairs(frameTable) do
            --
            if v.value ~= without then
                --      
                table.insert(newTable, v);
            end
        end

        return newTable
    end

    local optionsTarget = {
        name = L["TargetFrameName"],
        desc = L["TargetFrameDesc"],
        advancedName = 'TargetFrame',
        sub = "target",
        get = getOption,
        set = setOption,
        type = 'group',
        args = {
            headerStyling = {
                type = 'header',
                name = L["TargetFrameStyle"],
                desc = '',
                order = 20,
                isExpanded = true,
                editmode = true
            },
            classcolor = {
                type = 'toggle',
                name = L["TargetFrameClassColor"],
                desc = L["TargetFrameClassColorDesc"] .. getDefaultStr('classcolor', 'target'),
                group = 'headerStyling',
                order = 7,
                editmode = true
            },
            classicon = {
                type = 'toggle',
                name = L["TargetFrameClassIcon"],
                desc = L["TargetFrameClassIconDesc"] .. getDefaultStr('classicon', 'target'),
                group = 'headerStyling',
                order = 7.1,
                disabled = true,
                new = false,
                editmode = true
            },
            breakUpLargeNumbers = {
                type = 'toggle',
                name = L["TargetFrameBreakUpLargeNumbers"],
                desc = L["TargetFrameBreakUpLargeNumbersDesc"] .. getDefaultStr('breakUpLargeNumbers', 'target'),
                group = 'headerStyling',
                order = 8,
                editmode = true
            },
            enableThreatGlow = {
                type = 'toggle',
                name = L["TargetFrameThreatGlow"],
                desc = L["TargetFrameThreatGlowDesc"] .. getDefaultStr('enableThreatGlow', 'target'),
                group = 'headerStyling',
                order = 10,
                disabled = true,
                editmode = true
            },
            hideNameBackground = {
                type = 'toggle',
                name = L["TargetFrameHideNameBackground"],
                desc = L["TargetFrameHideNameBackgroundDesc"] .. getDefaultStr('hideNameBackground', 'target'),
                group = 'headerStyling',
                order = 11,
                new = false,
                editmode = true
            },
            comboPointsOnPlayerFrame = {
                type = 'toggle',
                name = L["TargetFrameComboPointsOnPlayerFrame"],
                desc = L["TargetFrameComboPointsOnPlayerFrameDesc"] ..
                    getDefaultStr('comboPointsOnPlayerFrame', 'target'),
                group = 'headerStyling',
                order = 12,
                new = false,
                editmode = true
            },
            hideComboPoints = {
                type = 'toggle',
                name = L["TargetFrameHideComboPoints"],
                desc = L["TargetFrameHideComboPointsDesc"] .. getDefaultStr('hideComboPoints', 'target'),
                group = 'headerStyling',
                order = 12.5,
                new = false,
                editmode = true
            },
            fadeOut = {
                type = 'toggle',
                name = L["TargetFrameFadeOut"],
                desc = L["TargetFrameFadeOutDesc"] .. getDefaultStr('fadeOut', 'target'),
                group = 'headerStyling',
                order = 9.5,
                new = false,
                editmode = true
            },
            fadeOutDistance = {
                type = 'range',
                name = L["TargetFrameFadeOutDistance"],
                desc = L["TargetFrameFadeOutDistanceDesc"] .. getDefaultStr('fadeOutDistance', 'target'),
                min = 0,
                max = 50,
                bigStep = 1,
                order = 9.6,
                group = 'headerStyling',
                new = false,
                editmode = true
            }
        }
    }

    if DF.Era then
        -- numericThreatAnchor
        optionsTarget.args['enableNumericThreat'] = {
            type = 'toggle',
            name = L["TargetFrameNumericThreat"],
            desc = L["TargetFrameNumericThreatDesc"] .. getDefaultStr('enableNumericThreat', 'target'),
            group = 'headerStyling',
            order = 9,
            disabled = not DF.Era,
            editmode = true
        }
        optionsTarget.args['numericThreatAnchor'] = {
            type = 'select',
            name = L["TargetFrameNumericThreatAnchor"],
            desc = L["TargetFrameNumericThreatAnchorDesc"] .. getDefaultStr('numericThreatAnchor', 'target'),
            dropdownValues = DF.Settings.DropdownCrossAnchorTable,
            order = 9.5,
            group = 'headerStyling',
            editmode = true
        }
    end

    if true then
        local moreOptions = {
            targetOfTarget = {
                type = 'toggle',
                name = SHOW_TARGET_OF_TARGET_TEXT,
                desc = OPTION_TOOLTIP_SHOW_TARGET_OF_TARGET,
                group = 'headerStyling',
                order = 15,
                blizzard = true,
                editmode = true
            },
            buffsOnTop = {
                type = 'toggle',
                name = BUFFS_ON_TOP,
                desc = '',
                group = 'headerStyling',
                order = 16,
                blizzard = true,
                editmode = true
            }
        }

        if true then
            moreOptions['headerBuffs'] = {
                type = 'header',
                name = L["TargetFrameHeaderBuffs"],
                desc = '',
                order = 19,
                isExpanded = true,
                editmode = true
            }
            moreOptions['buffsOnTop'].group = 'headerBuffs'

            moreOptions['auraSizeSmall'] = {
                type = 'range',
                name = L["TargetFrameAuraSizeSmall"],
                desc = L["TargetFrameAuraSizeSmallDesc"] .. getDefaultStr('auraSizeSmall', 'target'),
                min = 8,
                max = 64,
                bigStep = 1,
                group = 'headerBuffs',
                order = 4,
                new = true,
                editmode = true
            }
            moreOptions['auraSizeLarge'] = {
                type = 'range',
                name = L["TargetFrameAuraSizeLarge"],
                desc = L["TargetFrameAuraSizeLargeDesc"] .. getDefaultStr('auraSizeLarge', 'target'),
                min = 8,
                max = 64,
                bigStep = 1,
                group = 'headerBuffs',
                order = 2,
                new = true,
                editmode = true
            }
            moreOptions['noDebuffFilter'] = {
                type = 'toggle',
                name = L["TargetFrameNoDebuffFilter"],
                desc = L["TargetFrameNoDebuffFilterDesc"] .. getDefaultStr('noDebuffFilter', 'target'),
                group = 'headerBuffs',
                order = 1,
                new = true,
                editmode = true
            }
            moreOptions['dynamicBuffSize'] = {
                type = 'toggle',
                name = L["TargetFrameDynamicBuffSize"],
                desc = L["TargetFrameDynamicBuffSizeDesc"] .. getDefaultStr('dynamicBuffSize', 'target'),
                group = 'headerBuffs',
                order = 3,
                new = true,
                editmode = true
            }
        end

        for k, v in pairs(moreOptions) do optionsTarget.args[k] = v end

        optionsTarget.get = function(info)
            local key = info[1]
            local sub = info[2]

            if sub == 'targetOfTarget' then
                local tot = C_CVar.GetCVar("showTargetOfTarget");
                if tot == '1' then
                    return true
                else
                    return false
                end
            elseif sub == 'buffsOnTop' then
                if TARGET_FRAME_BUFFS_ON_TOP then
                    return true
                else
                    return false
                end
            else
                return getOption(info)
            end
        end

        optionsTarget.set = function(info, value)
            local key = info[1]
            local sub = info[2]

            if sub == 'targetOfTarget' then
                if value then
                    SetCVar("showTargetOfTarget", "1");
                else
                    SetCVar("showTargetOfTarget", "0");
                end
            elseif sub == 'buffsOnTop' then
                if value then
                    TARGET_FRAME_BUFFS_ON_TOP = true
                    TargetFrame.buffsOnTop = true
                else
                    TARGET_FRAME_BUFFS_ON_TOP = false
                    TargetFrame.buffsOnTop = false
                end
                TargetFrame_UpdateAuras(TargetFrame)
            else
                setOption(info, value)
            end
        end
    end
    DF.Settings:AddPositionTable(Module, optionsTarget, 'target', 'Target', getDefaultStr,
                                 frameTableWithout('TargetFrame'))

    DragonflightUIStateHandlerMixin:AddStateTable(Module, optionsTarget, 'target', 'Target', getDefaultStr)
    local optionsTargetEditmode = {
        name = 'Target',
        desc = 'Targetframedesc',
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
                    local dbTable = Module.db.profile.target
                    local defaultsTable = self.Defaults
                    -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                    setPreset(dbTable, {
                        scale = defaultsTable.scale,
                        anchor = defaultsTable.anchor,
                        anchorParent = defaultsTable.anchorParent,
                        anchorFrame = defaultsTable.anchorFrame,
                        x = defaultsTable.x,
                        y = defaultsTable.y
                    })
                end,
                order = 16,
                editmode = true,
                new = false
            }
        }
    }
    self.Options = optionsTarget;
    self.OptionsEditmode = optionsTargetEditmode;
end

function SubModuleMixin:Setup()
    local function setDefaultSubValues(sub)
        self.ModuleRef:SetDefaultSubValues(sub)
    end

    DF.ConfigModule:RegisterSettingsData('target', 'unitframes', {
        options = self.Options,
        default = function()
            setDefaultSubValues('target')
        end
    })
    --
    self:RegisterEvent('PLAYER_TARGET_CHANGED')
    --
    self:ChangeTargetFrame()
    self:ReApplyTargetFrame()
    self:ChangeTargetComboFrame()

    if DF.Era then
        self:AddMobhealth();
        self:CreatThreatIndicator();
    end

    local UpdateTargetStatusBars = function()
        self:ReApplyTargetFrame()
    end
    TargetFrameHealthBar:HookScript('OnValueChanged', UpdateTargetStatusBars)
    TargetFrameHealthBar:HookScript('OnEvent', function(_, event, arg1)
        if event == 'UNIT_MAXHEALTH' and arg1 == 'target' then UpdateTargetStatusBars() end
    end)

    _G['TargetFrameManaBar'].DFUpdateFunc = function()
        self:ReApplyTargetFrame()
    end

    -- state
    Mixin(TargetFrame, DragonflightUIStateHandlerMixin)
    TargetFrame:InitStateHandler()
    TargetFrame:SetUnit('target')

    -- editmode
    local EditModeModule = DF:GetModule('Editmode');
    local fakeTarget = CreateFrame('Frame', 'DragonflightUIEditModeTargetFramePreview', UIParent,
                                   'DFEditModePreviewTargetTemplate')
    fakeTarget:OnLoad()
    self.PreviewTarget = fakeTarget;

    EditModeModule:AddEditModeToFrame(fakeTarget)

    fakeTarget.DFEditModeSelection:SetGetLabelTextFunction(function()
        return self.Options.name
    end)

    fakeTarget.DFEditModeSelection:RegisterOptions({
        options = self.Options,
        extra = self.OptionsEditmode,
        parentExtra = TargetFrame,
        default = function()
            setDefaultSubValues('target')
        end,
        moduleRef = self.ModuleRef,
        showFunction = function()
            --
            -- TargetFrame.unit = 'player';
            -- TargetFrame_Update(TargetFrame);
            -- TargetFrame:Show()
            TargetFrame:SetAlpha(0)
        end,
        hideFunction = function()
            --        
            -- TargetFrame.unit = 'target';
            -- TargetFrame_Update(TargetFrame);
            TargetFrame:SetAlpha(1)
        end
    });
end

function SubModuleMixin:OnEvent(event, ...)
    if event == 'PLAYER_TARGET_CHANGED' then self:ReApplyTargetFrame() end
end

function SubModuleMixin:UpdateState(state)
    self.state = state;
    self:Update();
end

function SubModuleMixin:Update()
    local state = self.state;
    if not state then return end

    local f = TargetFrame

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    f:ClearAllPoints()
    f:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    f:SetUserPlaced(true)
    f:SetScale(state.scale)

    self:ReApplyTargetFrame()
    -- Module.ReApplyToT()
    TargetFrameHealthBar.breakUpLargeNumbers = state.breakUpLargeNumbers
    TextStatusBar_UpdateTextString(TargetFrameHealthBar)
    self:UpdateComboFrameState(state)
    TargetFrameNameBackground:SetShown(not state.hideNameBackground)
    AuraDurations.frame:SetState(state)
    UnitFramePortrait_Update(TargetFrame)
    TargetFrame:UpdateStateHandler(state)

    self.PreviewTarget:UpdateState(state);
end

function SubModuleMixin:ChangeTargetFrame()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    TargetFrameTextureFrameTexture:Hide()
    TargetFrameBackground:Hide()

    if not self.TargetFrameBackground then
        local background = TargetFrame:CreateTexture('DragonflightUITargetFrameBackground')
        background:SetDrawLayer('BACKGROUND', 2)
        background:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BACKGROUND')
        background:SetPoint('LEFT', TargetFrame, 'LEFT', 0, -32.5 + 10)
        self.TargetFrameBackground = background
    end

    if not self.TargetFrameBorder then
        local border = TargetFrame:CreateTexture('DragonflightUITargetFrameBorder')
        border:SetDrawLayer('ARTWORK', 2)
        border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BORDER')
        border:SetPoint('LEFT', TargetFrame, 'LEFT', 0, -32.5 + 10)
        self.TargetFrameBorder = border
    end

    TargetFramePortrait:SetDrawLayer('BACKGROUND', -1)
    TargetFramePortrait:SetSize(56, 56)
    local CorrectionY = -3
    local CorrectionX = -5
    TargetFramePortrait:SetPoint('TOPRIGHT', TargetFrame, 'TOPRIGHT', -42 + CorrectionX, -12 + CorrectionY)

    -- TargetFrameTextureFrameRaidTargetIcon:SetPoint('CENTER',TargetFrameTextureFrame,'TOPRIGHT',-73,-14)
    -- TargetFrameTextureFrameRaidTargetIcon:GetHeight()
    TargetFrameTextureFrameRaidTargetIcon:SetPoint('CENTER', TargetFramePortrait, 'TOP', 0, 2)

    -- TargetFrameBuff1:SetPoint('TOPLEFT', TargetFrame, 'BOTTOMLEFT', 5, 0)

    -- @TODO: change text spacing
    TargetFrameTextureFrameName:ClearAllPoints()
    TargetFrameTextureFrameName:SetPoint('BOTTOM', TargetFrameHealthBar, 'TOP', 10, 3 - 2)
    TargetFrameTextureFrameName:SetSize(100, 12)

    TargetFrameTextureFrameLevelText:ClearAllPoints()
    TargetFrameTextureFrameLevelText:SetPoint('BOTTOMRIGHT', TargetFrameHealthBar, 'TOPLEFT', 16, 3 - 2)
    TargetFrameTextureFrameLevelText:SetHeight(12)

    TargetFrameTextureFrameDeadText:ClearAllPoints()
    TargetFrameTextureFrameDeadText:SetPoint('CENTER', TargetFrameHealthBar, 'CENTER', 0, 0)

    TargetFrameTextureFrameUnconsciousText:ClearAllPoints()
    TargetFrameTextureFrameUnconsciousText:SetPoint('CENTER', TargetFrameHealthBar, 'CENTER', 0, 0)

    -- Health 119,12
    TargetFrameHealthBar:ClearAllPoints()
    TargetFrameHealthBar:SetSize(125, 20)
    TargetFrameHealthBar:SetPoint('RIGHT', TargetFramePortrait, 'LEFT', -1, 0)
    --[[     TargetFrameHealthBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health'
    )
    TargetFrameHealthBar:SetStatusBarColor(1, 1, 1, 1) ]]
    -- Mana 119,12
    TargetFrameManaBar:ClearAllPoints()
    -- TargetFrameManaBar:SetPoint('RIGHT', TargetFramePortrait, 'LEFT', -1 + 8 - 0.5 + 1, -18 + 1 + 0.5)
    TargetFrameManaBar:SetPoint('TOPLEFT', TargetFrameHealthBar, 'BOTTOMLEFT', 0, -1)
    TargetFrameManaBar:SetSize(134, 10)
    TargetFrameManaBar:SetStatusBarColor(1, 1, 1, 1)

    if not TargetFrameManaBar.DFMask then
        local manaMask = TargetFrameManaBar:CreateMaskTexture()
        manaMask:SetPoint('TOPLEFT', TargetFrameManaBar, 'TOPLEFT', -61, 3)
        manaMask:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\ui-hud-unitframe-target-portraiton-bar-mana-mask-2x',
            'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
        manaMask:SetTexCoord(0, 1, 0, 1)
        manaMask:SetSize(256, 16)
        TargetFrameManaBar:GetStatusBarTexture():AddMaskTexture(manaMask)
        TargetFrameManaBar.DFMask = manaMask
    end

    TargetFrameNameBackground:SetTexture(base)
    TargetFrameNameBackground:SetTexCoord(0.7939453125, 0.92578125, 0.3125, 0.34765625)
    TargetFrameNameBackground:SetSize(135, 18)
    TargetFrameNameBackground:ClearAllPoints()
    TargetFrameNameBackground:SetPoint('BOTTOMLEFT', TargetFrameHealthBar, 'TOPLEFT', -2, -4 - 1)

    if not TargetFrameNameBackground.DFHooked then
        TargetFrameNameBackground.DFHooked = true

        TargetFrameNameBackground:HookScript('OnShow', function()
            --          
            local db = self.ModuleRef.db.profile.target
            if db.hideNameBackground then
                -- 
                TargetFrameNameBackground:Hide()
            end
        end)
    end

    if DF.Era then
        local parent = TargetFrameTextureFrame
        -- health
        if not parent.HealthBarText then
            parent.HealthBarText = parent:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
            TargetFrameHealthBar.TextString = parent.HealthBarText
        end

        if not parent.HealthBarTextLeft then
            parent.HealthBarTextLeft = parent:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
            TargetFrameHealthBar.LeftText = parent.HealthBarTextLeft
        end

        if not parent.HealthBarTextRight then
            parent.HealthBarTextRight = parent:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
            TargetFrameHealthBar.RightText = parent.HealthBarTextRight
        end
        -- mana
        if not parent.ManaBarText then
            parent.ManaBarText = parent:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
            TargetFrameManaBar.TextString = parent.ManaBarText
        end
        if not parent.ManaBarTextLeft then
            parent.ManaBarTextLeft = parent:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
            TargetFrameManaBar.LeftText = parent.ManaBarTextLeft
        end
        if not parent.ManaBarTextRight then
            parent.ManaBarTextRight = parent:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
            TargetFrameManaBar.RightText = parent.ManaBarTextRight
        end
    end

    if DF.Wrath or DF.Era then
        local dx = 5
        -- health vs mana bar
        local deltaSize = 134 - 125

        TargetFrameTextureFrame.HealthBarText:SetPoint('CENTER', TargetFrameHealthBar, 'CENTER', 0, 0)
        TargetFrameTextureFrame.HealthBarTextLeft:SetPoint('LEFT', TargetFrameHealthBar, 'LEFT', dx, 0)
        TargetFrameTextureFrame.HealthBarTextRight:SetPoint('RIGHT', TargetFrameHealthBar, 'RIGHT', -dx, 0)

        TargetFrameTextureFrame.ManaBarText:SetPoint('CENTER', TargetFrameManaBar, 'CENTER', -deltaSize / 2, 0)
        TargetFrameTextureFrame.ManaBarTextLeft:SetPoint('LEFT', TargetFrameManaBar, 'LEFT', dx, 0)
        TargetFrameTextureFrame.ManaBarTextRight:SetPoint('RIGHT', TargetFrameManaBar, 'RIGHT', -deltaSize - dx, 0)
    end

    if DF.Wrath then
        TargetFrameFlash:SetTexture('')

        if not self.TargetFrameFlash then
            local flash = TargetFrame:CreateTexture('DragonflightUITargetFrameFlash')
            flash:SetDrawLayer('BACKGROUND', 2)
            flash:SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-InCombat')
            flash:SetPoint('CENTER', TargetFrame, 'CENTER', 20 + CorrectionX, -20 + CorrectionY)
            flash:SetSize(256, 128)
            flash:SetScale(1)
            flash:SetVertexColor(1.0, 0.0, 0.0, 1.0)
            flash:SetBlendMode('ADD')
            self.TargetFrameFlash = flash
        end

        hooksecurefunc(TargetFrameFlash, 'Show', function()
            -- print('show')
            TargetFrameFlash:SetTexture('')
            self.TargetFrameFlash:Show()
            if (UIFrameIsFlashing(frame.TargetFrameFlash)) then
            else
                -- print('go flash')
                local dt = 0.5
                UIFrameFlash(frame.TargetFrameFlash, dt, dt, -1)
            end
        end)

        hooksecurefunc(TargetFrameFlash, 'Hide', function()
            -- print('hide')
            TargetFrameFlash:SetTexture('')
            if (UIFrameIsFlashing(self.TargetFrameFlash)) then UIFrameFlashStop(self.TargetFrameFlash) end
            self.TargetFrameFlash:Hide()
        end)
    end

    if not self.PortraitExtra then
        local extra = TargetFrame:CreateTexture('DragonflightUITargetFramePortraitExtra')
        extra:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiunitframeboss2x')
        extra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
        extra:SetSize(80, 79)
        extra:SetDrawLayer('ARTWORK', 3)
        extra:SetPoint('CENTER', TargetFramePortrait, 'CENTER', 4, 1)

        extra.UpdateStyle = function()
            local class = UnitClassification('target')
            --[[ "worldboss", "rareelite", "elite", "rare", "normal", "trivial" or "minus" ]]
            if class == 'worldboss' then
                self.PortraitExtra:Show()
                self.PortraitExtra:SetSize(99, 81)
                self.PortraitExtra:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.31835937)
                self.PortraitExtra:SetPoint('CENTER', TargetFramePortrait, 'CENTER', 13, 1)
            elseif class == 'rareelite' or class == 'rare' then
                self.PortraitExtra:Show()
                self.PortraitExtra:SetSize(80, 79)
                self.PortraitExtra:SetTexCoord(0.00390625, 0.31640625, 0.64453125, 0.953125)
                self.PortraitExtra:SetPoint('CENTER', TargetFramePortrait, 'CENTER', 4, 1)
            elseif class == 'elite' then
                self.PortraitExtra:Show()
                self.PortraitExtra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
                self.PortraitExtra:SetSize(80, 79)
                self.PortraitExtra:SetPoint('CENTER', TargetFramePortrait, 'CENTER', 4, 1)
            else
                local name, realm = UnitName('target')
                if self.ModuleRef.famous[name] then
                    self.PortraitExtra:Show()
                    self.PortraitExtra:SetSize(99, 81)
                    self.PortraitExtra:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.31835937)
                    self.PortraitExtra:SetPoint('CENTER', TargetFramePortrait, 'CENTER', 13, 1)
                else
                    self.PortraitExtra:Hide()
                end
            end
        end

        self.PortraitExtra = extra
    end

    if not TargetFrame.DFRangeHooked then
        TargetFrame.DFRangeHooked = true;

        local state = self.ModuleRef.db.profile.target

        if not RangeCheck then return end
        local function updateRange()
            local minRange, maxRange = RangeCheck:GetRange('target')
            -- print(minRange, maxRange)

            if not state.fadeOut then
                TargetFrame:SetAlpha(1);
                return;
            end

            if minRange and minRange >= state.fadeOutDistance then
                TargetFrame:SetAlpha(0.55);
                -- elseif maxRange and maxRange >= 40 then
                --     TargetFrame:SetAlpha(0.55);
            else
                TargetFrame:SetAlpha(1);
            end
        end

        TargetFrame:HookScript('OnUpdate', updateRange)
        TargetFrame:HookScript('OnEvent', updateRange)
    end
end

function SubModuleMixin:ReApplyTargetFrame()
    if self.ModuleRef.db.profile.target.classcolor and UnitIsPlayer('target') then
        TargetFrameHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health-Status')
        local localizedClass, englishClass, classIndex = UnitClass('target')
        TargetFrameHealthBar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
    else
        TargetFrameHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health')
        TargetFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)
    end

    local powerType, powerTypeString = UnitPowerType('target')
    -- print('~target', powerType, powerTypeString)

    if powerTypeString == 'MANA' then
        TargetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana')
    elseif powerTypeString == 'FOCUS' then
        TargetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus')
    elseif powerTypeString == 'RAGE' then
        TargetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage')
    elseif powerTypeString == 'ENERGY' or powerTypeString == 'POWER_TYPE_FEL_ENERGY' then
        TargetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy')
    elseif powerTypeString == 'RUNIC_POWER' then
        TargetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower')
    end

    TargetFrameManaBar:SetStatusBarColor(1, 1, 1, 1)
    if DF.Wrath then TargetFrameFlash:SetTexture('') end

    if self.PortraitExtra then self.PortraitExtra:UpdateStyle() end
end

function SubModuleMixin:ChangeTargetComboFrame()
    local c = ComboFrame
    c:SetParent(TargetFrame)
    c:SetFrameLevel(10)

    local tex = 'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\classoverlaycombopoints'

    for i = 1, 5 do
        --
        local point = _G['ComboPoint' .. i]

        local regions = {point:GetRegions()}

        for k, v in ipairs(regions) do
            --
            local layer = v:GetDrawLayer()
            -- print(k, layer)
            v:ClearAllPoints()
            v:SetSize(12, 12)
            v:SetPoint('CENTER', point, 'CENTER', 0, 0)
            v:SetTexture(tex)

            if layer == 'BACKGROUND' then
                v:SetTexCoord(0.226562, 0.382812, 0.515625, 0.671875)
            elseif layer == 'ARTWORK' then
                v:SetTexCoord(0.226562, 0.382812, 0.34375, 0.5)
            elseif layer == 'OVERLAY' then
                v:SetTexCoord(0.0078125, 0.210938, 0.164062, 0.375)
            end
        end
    end
end

function SubModuleMixin:UpdateComboFrameState(state)
    local c = ComboFrame

    if state.comboPointsOnPlayerFrame then
        c:SetParent(PlayerFrame)
        c:SetSize(116, 20)
        c:ClearAllPoints()
        -- c:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50 - 8, 34 + 4)
        -- ShardBarFrame:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50, 34 - 1)   

        local localizedClass, englishClass, classIndex = UnitClass('player');
        if englishClass == 'DRUID' then
            local deltaY = 16;
            c:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50 - 8, 34 + 4 - deltaY)
        else
            c:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50 - 8, 34 + 4)
        end

        for i = 1, 5 do
            --
            local size = 20
            local scaling = 20 / 12

            local point = _G['ComboPoint' .. i]
            point:SetSize(20, 20)
            point:ClearAllPoints()
            local dx = (i - 1) * 24 / scaling
            point:SetPoint('TOPLEFT', c, 'TOPLEFT', dx, 0)

            point:SetScale(scaling)
        end
    else
        -- default
        c:SetParent(TargetFrame)
        c:SetSize(256, 32)
        c:ClearAllPoints()
        c:SetPoint('TOPRIGHT', TargetFrame, 'TOPRIGHT', -44, -9)

        local comboDefaults = {{0, 0}, {7, -8}, {12, -19}, {14, -30}, {12, -41}}

        for i = 1, 5 do
            --
            local scaling = 1

            local point = _G['ComboPoint' .. i]
            point:SetSize(12, 12)
            point:ClearAllPoints()
            point:SetPoint('TOPRIGHT', c, 'TOPRIGHT', comboDefaults[i][1], comboDefaults[i][2])

            point:SetScale(scaling)
        end
    end

    if state.hideComboPoints then
        c:ClearAllPoints()
        c:SetPoint('TOP', UIParent, 'TOP', 0, 50)
    end
end

function SubModuleMixin:ShouldKnowHealth(unit)
    local guid = UnitGUID(unit)
    local matched = guid and guid:match("^(.-)%-")

    return UnitIsUnit(unit, 'Player') or UnitIsUnit(unit, 'Pet') or UnitPlayerOrPetInRaid(unit) or
               UnitPlayerOrPetInParty(unit) or (matched == 'Creature')
end

function SubModuleMixin:AddMobhealth()
    hooksecurefunc('UnitFrameHealthBar_Update', function(statusbar, unit)
        -- print(statusbar:GetName(), 'should know?', Module.ShouldKnowHealth(unit))
        local shouldKnow = self:ShouldKnowHealth(unit)

        if shouldKnow then
            -- print('should know: ', statusbar:GetName(), unit)
            statusbar.showPercentage = false;
            TextStatusBar_UpdateTextString(statusbar)
        end
    end)

    --[[    hooksecurefunc("TextStatusBar_UpdateTextStringWithValues",
                   function(statusFrame, textString, value, valueMin, valueMax)
        -- print(statusFrame, textString, value, valueMin, valueMax)
    end); ]]

    -- hooksecurefunc("TextStatusBar_UpdateTextString", function(textStatusBar)
    --     local textString = textStatusBar.TextString;
    --     if textString then
    --         local value = textStatusBar:GetValue();
    --         local valueMin, valueMax = textStatusBar:GetMinMaxValues();

    --         -- print('TextStatusBar_UpdateTextString', textStatusBar:GetName(), value, valueMin, valueMax)
    --     end
    -- end)
end

function SubModuleMixin:CreatThreatIndicator()
    local sizeX, sizeY = 42, 16

    local indi = CreateFrame('Frame', 'DragonflightUIThreatIndicator', TargetFrame)
    indi:SetSize(sizeX, sizeY)
    indi:SetPoint('BOTTOM', TargetFrameTextureFrameName, 'TOP', 0, 2)

    local bg = indi:CreateTexture(nil, 'BACKGROUND')
    bg:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
    bg:SetTexture(
        "Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health");
    bg:SetPoint('CENTER', 0, 0)
    bg:SetSize(sizeX, sizeY)

    -- TargetFrameHealthBar:GetStatusBarTexture():SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health')
    -- TargetFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)

    local text = indi:CreateFontString(nil, 'BACKGROUND', 'GameFontHighlight')
    text:SetPoint('CENTER', 0, 0)
    text:SetText('999%')

    indi.Background = bg
    indi.Text = text
    self.ThreatIndicator = indi

    local function UpdateIndicator()
        local db = self.ModuleRef.db.profile
        local enableNumeric = db.target.enableNumericThreat
        local threatAnchor = db.target.numericThreatAnchor
        local enableGlow = db.target.enableThreatGlow

        if UnitExists('TARGET') and (enableNumeric or enableGlow) then
            local isTanking, status, percentage, rawPercentage = UnitDetailedThreatSituation('PLAYER', 'TARGET')
            local display = rawPercentage;

            if enableNumeric then
                if isTanking then
                    ---@diagnostic disable-next-line: cast-local-type
                    display = UnitThreatPercentageOfLead('PLAYER', 'TARGET')
                    -- print('IsTanking')
                end

                if display and display ~= 0 then
                    -- print('t:', display)
                    display = min(display, MAX_DISPLAYED_THREAT_PERCENT);
                    text:SetText(format("%1.0f", display) .. "%")
                    bg:SetVertexColor(GetThreatStatusColor(status))
                    indi:Show()
                else
                    indi:Hide()
                end
            else
                indi:Hide()
            end

            if enableGlow then
                -- show
            else
                -- hide
            end

            indi:ClearAllPoints()
            if threatAnchor == 'TOP' then
                indi:SetPoint('BOTTOM', TargetFrameTextureFrameName, 'TOP', 0, 2)
            elseif threatAnchor == 'RIGHT' then
                indi:SetPoint('LEFT', TargetFramePortrait, 'RIGHT', 5, 0)
            elseif threatAnchor == 'BOTTOM' then
                indi:SetPoint('TOP', TargetFrameManaBar, 'BOTTOM', 0, -2)
            elseif threatAnchor == 'LEFT' then
                indi:SetPoint('RIGHT', TargetFrameHealthBar, 'LEFT', -2, 0)
            else
                -- should not happen
                indi:SetPoint('BOTTOM', TargetFrameTextureFrameName, 'TOP', 0, 2)
            end
        else
            indi:Hide()
            -- disable glow
        end
    end

    indi:RegisterEvent('PLAYER_TARGET_CHANGED')
    indi:RegisterUnitEvent('UNIT_THREAT_LIST_UPDATE', 'TARGET')

    indi:SetScript('OnEvent', UpdateIndicator)
    UpdateIndicator()
end

