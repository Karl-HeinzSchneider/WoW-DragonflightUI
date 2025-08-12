local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local RangeCheck = LibStub("LibRangeCheck-3.0")

local subModuleName = 'Focus';
local SubModuleMixin = {};
addonTable.SubModuleMixins[subModuleName] = SubModuleMixin;

function SubModuleMixin:Init()
    self.ModuleRef = DF:GetModule('Unitframe')
    self:SetDefaults()
    self:SetupOptions()

    self:SetScript('OnEvent', self.OnEvent);
end

function SubModuleMixin:SetDefaults()
    local defaults = {
        classcolor = false,
        reactioncolor = false,
        classicon = false,
        breakUpLargeNumbers = true,
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
        y = -170,
        customHealthBarTexture = 'Default',
        customPowerBarTexture = 'Default',
        -- Visibility
        alphaNormal = 1.0,
        alphaCombat = 1.0,
        showMouseover = false,
        hideAlways = false,
        hideCombat = false,
        hideOutOfCombat = false,
        hideVehicle = false,
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

    local optionsFocus = {
        desc = L["FocusFrameDesc"],
        name = L["FocusFrameName"],
        advancedName = 'FocusFrame',
        sub = 'focus',
        get = getOption,
        set = setOption,
        type = 'group',
        args = {
            headerStyling = {
                type = 'header',
                name = L["FocusFrameStyle"],
                desc = '',
                order = 20,
                isExpanded = true,
                editmode = true
            },
            classcolor = {
                type = 'toggle',
                name = L["FocusFrameClassColor"],
                desc = L["FocusFrameClassColorDesc"] .. getDefaultStr('classcolor', 'focus'),
                group = 'headerStyling',
                order = 2,
                editmode = true
            },
            reactioncolor = {
                type = 'toggle',
                name = L["TargetFrameReactionColor"],
                desc = L["TargetFrameReactionColorDesc"] .. getDefaultStr('reactioncolor', 'focus'),
                group = 'headerStyling',
                order = 3,
                new = true,
                editmode = true
            },
            customHealthBarTexture = {
                type = 'select',
                name = L["PlayerFrameCustomHealthbarTexture"],
                desc = L["PlayerFrameCustomHealthbarTextureDesc"] .. getDefaultStr('customHealthBarTexture', 'focus'),
                dropdownValuesFunc = Helper:CreateSharedMediaStatusBarGenerator(function(name)
                    return getOption({'focus', 'customHealthBarTexture'}) == name;
                end, function(name)
                    setOption({'focus', 'customHealthBarTexture'}, name)
                end),
                group = 'headerStyling',
                order = 4,
                new = true
            },
            customPowerBarTexture = {
                type = 'select',
                name = L["PlayerFrameCustomPowerbarTexture"],
                desc = L["PlayerFrameCustomPowerbarTextureDesc"] .. getDefaultStr('customPowerBarTexture', 'focus'),
                dropdownValuesFunc = Helper:CreateSharedMediaStatusBarGenerator(function(name)
                    return getOption({'focus', 'customPowerBarTexture'}) == name;
                end, function(name)
                    setOption({'focus', 'customPowerBarTexture'}, name)
                end),
                group = 'headerStyling',
                order = 5,
                new = true
            },
            classicon = {
                type = 'toggle',
                name = L["FocusFrameClassIcon"],
                desc = L["FocusFrameClassIconDesc"] .. getDefaultStr('classicon', 'focus'),
                group = 'headerStyling',
                order = 1,
                disabled = true,
                new = false,
                editmode = true
            },
            fadeOut = {
                type = 'toggle',
                name = L["TargetFrameFadeOut"],
                desc = L["TargetFrameFadeOutDesc"] .. getDefaultStr('fadeOut', 'focus'),
                group = 'headerStyling',
                order = 9.5,
                new = false,
                editmode = true
            },
            fadeOutDistance = {
                type = 'range',
                name = L["TargetFrameFadeOutDistance"],
                desc = L["TargetFrameFadeOutDistanceDesc"] .. getDefaultStr('fadeOutDistance', 'focus'),
                min = 0,
                max = 50,
                bigStep = 1,
                order = 9.6,
                group = 'headerStyling',
                new = false,
                editmode = true
            },
            breakUpLargeNumbers = {
                type = 'toggle',
                name = L["FocusFrameBreakUpLargeNumbers"],
                desc = L["FocusFrameBreakUpLargeNumbersDesc"] .. getDefaultStr('breakUpLargeNumbers', 'focus'),
                group = 'headerStyling',
                order = 3.5,
                editmode = true
            },
            hideNameBackground = {
                type = 'toggle',
                name = L["FocusFrameHideNameBackground"],
                desc = L["FocusFrameHideNameBackgroundDesc"] .. getDefaultStr('hideNameBackground', 'focus'),
                group = 'headerStyling',
                order = 11,
                new = false,
                editmode = true
            }
        }
    }

    DF.Settings:AddPositionTable(Module, optionsFocus, 'focus', 'Focus', getDefaultStr, frameTableWithout('FocusFrame'))

    DragonflightUIStateHandlerMixin:AddStateTable(Module, optionsFocus, 'focus', 'Focus', getDefaultStr)
    local optionsFocusEditmode = {
        name = 'Focus',
        desc = 'Focus',
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
                    local dbTable = Module.db.profile.focus
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

    self.Options = optionsFocus;
    self.OptionsEditmode = optionsFocusEditmode;
end

function SubModuleMixin:Setup()
    local function setDefaultSubValues(sub)
        self.ModuleRef:SetDefaultSubValues(sub)
    end

    DF.ConfigModule:RegisterSettingsData('focus', 'unitframes', {
        options = self.Options,
        default = function()
            setDefaultSubValues('focus')
        end
    })

    --
    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('PLAYER_FOCUS_CHANGED')

    self:RegisterEvent('UNIT_HEALTH')
    self:RegisterEvent('UNIT_POWER_UPDATE')
    self:RegisterEvent('PLAYER_FOCUS_CHANGED')
    --
    self:ChangeFocusFrame()

    local up = function()
        self:ReApplyFocusFrame()
    end
    FocusFrameHealthBar:HookScript('OnValueChanged', up)
    FocusFrameHealthBar:HookScript('OnEvent', function(_, event, arg1)
        if event == 'UNIT_MAXHEALTH' and arg1 == 'focus' then up() end
    end)

    _G['FocusFrameManaBar'].DFUpdateFunc = function()
        self:ReApplyFocusFrame()
    end

    -- state handler
    Mixin(FocusFrame, DragonflightUIStateHandlerMixin)
    FocusFrame:InitStateHandler()
    FocusFrame:SetUnit('focus')

    -- Edit mode
    local EditModeModule = DF:GetModule('Editmode');
    local fakeFocus = CreateFrame('Frame', 'DragonflightUIEditModeFocusFramePreview', UIParent,
                                  'DFEditModePreviewTargetTemplate')
    fakeFocus:OnLoad()
    self.PreviewFocus = fakeFocus;

    EditModeModule:AddEditModeToFrame(fakeFocus)

    fakeFocus.DFEditModeSelection:SetGetLabelTextFunction(function()
        return self.Options.name
    end)

    fakeFocus.DFEditModeSelection:RegisterOptions({
        options = self.Options,
        extra = self.OptionsEditmode,
        parentExtra = FocusFrame,
        default = function()
            setDefaultSubValues('focus')
        end,
        moduleRef = self.ModuleRef,
        showFunction = function()
            --
            -- FocusFrame.unit = 'player';
            -- TargetFrame_Update(FocusFrame);
            -- FocusFrame:Show()
            FocusFrame:SetAlpha(0)
        end,
        hideFunction = function()
            --
            -- FocusFrame.unit = 'focus';
            -- TargetFrame_Update(FocusFrame);
            FocusFrame:SetAlpha(1)
        end
    });
end

function SubModuleMixin:OnEvent(event, ...)
    local arg1 = ...;
    if event == 'PLAYER_ENTERING_WORLD' then
        -- self:ReApplyFocusFrame()
    elseif event == 'PLAYER_FOCUS_CHANGED' then
        self:ReApplyFocusFrame()
        self:UpdateFocusText()
    elseif event == 'PLAYER_FOCUS_CHANGED' and arg1 == 'focus' then
        self:UpdateFocusText()
    elseif event == 'UNIT_HEALTH' and arg1 == 'focus' then
        self:UpdateFocusText()
    end
end

function SubModuleMixin:UpdateState(state)
    self.state = state;
    self:Update();
end

function SubModuleMixin:Update()
    local state = self.state;
    if not state then return end

    local f = FocusFrame

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    f:SetScale(state.scale)
    f:ClearAllPoints()
    f:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    f:SetUserPlaced(true)

    self:ReApplyFocusFrame()
    -- self:ReApplyFocusToT()
    FocusFrameHealthBar.breakUpLargeNumbers = state.breakUpLargeNumbers
    TextStatusBar_UpdateTextString(FocusFrameHealthBar)
    FocusFrameNameBackground:SetShown(not state.hideNameBackground)
    UnitFramePortrait_Update(FocusFrame)
    FocusFrame:UpdateStateHandler(state)
    self.PreviewFocus:UpdateState(state);
end

function SubModuleMixin:ChangeFocusFrame()
    local frame = self;
    local Module = self.ModuleRef;
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    FocusFrameTextureFrameTexture:Hide()
    FocusFrameBackground:Hide()

    FocusFrame.Portrait = FocusFramePortrait;
    FocusFrame.Name = FocusFrameTextureFrameName;
    FocusFrame.NameBackground = FocusFrameNameBackground;
    FocusFrame.Flash = FocusFrameFlash;
    FocusFrame.LevelText = FocusFrameTextureFrameLevelText;
    FocusFrame.DeadText = FocusFrameTextureFrameDeadText;
    FocusFrame.UnconsciousText = FocusFrameTextureFrameUnconsciousText;

    self.ModuleRef.SubTarget:ChangeTargetFrameGeneral(self, FocusFrame)

    FocusFrameTextureFrameRaidTargetIcon:SetPoint('CENTER', FocusFramePortrait, 'TOP', 0, 2)

    if not FocusFrameNameBackground.DFHooked then
        FocusFrameNameBackground.DFHooked = true

        FocusFrameNameBackground:HookScript('OnShow', function()
            --          
            local db = Module.db.profile.focus
            if db.hideNameBackground then
                -- 
                FocusFrameNameBackground:Hide()
            end
        end)
    end

    local dx = 5
    -- health vs mana bar
    local deltaSize = 134 - 125

    FocusFrameTextureFrame.HealthBarText:ClearAllPoints()
    FocusFrameTextureFrame.HealthBarText:SetPoint('CENTER', FocusFrameHealthBar, 0, 0)
    FocusFrameTextureFrame.HealthBarTextLeft:SetPoint('LEFT', FocusFrameHealthBar, 'LEFT', dx, 0)
    FocusFrameTextureFrame.HealthBarTextRight:SetPoint('RIGHT', FocusFrameHealthBar, 'RIGHT', -dx, 0)

    FocusFrameTextureFrame.ManaBarText:ClearAllPoints()
    FocusFrameTextureFrame.ManaBarText:SetPoint('CENTER', FocusFrameManaBar, -deltaSize / 2, 0)
    FocusFrameTextureFrame.ManaBarTextLeft:SetPoint('LEFT', FocusFrameManaBar, 'LEFT', dx, 0)
    FocusFrameTextureFrame.ManaBarTextRight:SetPoint('RIGHT', FocusFrameManaBar, 'RIGHT', -deltaSize - dx, 0)

    -- CUSTOM HealthText
    if not frame.FocusFrameHealthBarText then
        local FocusFrameHealthBarDummy = CreateFrame('FRAME', 'FocusFrameHealthBarDummy')
        FocusFrameHealthBarDummy:SetPoint('LEFT', FocusFrameHealthBar, 'LEFT', 0, 0)
        FocusFrameHealthBarDummy:SetPoint('TOP', FocusFrameHealthBar, 'TOP', 0, 0)
        FocusFrameHealthBarDummy:SetPoint('RIGHT', FocusFrameHealthBar, 'RIGHT', 0, 0)
        FocusFrameHealthBarDummy:SetPoint('BOTTOM', FocusFrameHealthBar, 'BOTTOM', 0, 0)
        FocusFrameHealthBarDummy:SetParent(FocusFrame)
        FocusFrameHealthBarDummy:SetFrameStrata('LOW')
        FocusFrameHealthBarDummy:SetFrameLevel(3)
        FocusFrameHealthBarDummy:EnableMouse(true)

        frame.FocusFrameHealthBarDummy = FocusFrameHealthBarDummy

        local t = FocusFrameHealthBarDummy:CreateFontString('FocusFrameHealthBarText', 'OVERLAY', 'TextStatusBarText')

        t:SetPoint('CENTER', FocusFrameHealthBarDummy, 0, 0)
        t:SetText('HP')
        t:Hide()
        frame.FocusFrameHealthBarText = t

        FocusFrameHealthBarDummy:HookScript('OnEnter', function(self)
            if FocusFrameTextureFrame.HealthBarTextRight:IsVisible() or FocusFrameTextureFrame.HealthBarText:IsVisible() then
            else
                frame:UpdateFocusText()
                frame.FocusFrameHealthBarText:Show()
            end
        end)
        FocusFrameHealthBarDummy:HookScript('OnLeave', function(self)
            frame.FocusFrameHealthBarText:Hide()
        end)
    end

    -- CUSTOM ManaText
    if not frame.FocusFrameManaBarText then
        local FocusFrameManaBarDummy = CreateFrame('FRAME', 'FocusFrameManaBarDummy')
        FocusFrameManaBarDummy:SetPoint('LEFT', FocusFrameManaBar, 'LEFT', 0, 0)
        FocusFrameManaBarDummy:SetPoint('TOP', FocusFrameManaBar, 'TOP', 0, 0)
        FocusFrameManaBarDummy:SetPoint('RIGHT', FocusFrameManaBar, 'RIGHT', 0, 0)
        FocusFrameManaBarDummy:SetPoint('BOTTOM', FocusFrameManaBar, 'BOTTOM', 0, 0)
        FocusFrameManaBarDummy:SetParent(FocusFrame)
        FocusFrameManaBarDummy:SetFrameStrata('LOW')
        FocusFrameManaBarDummy:SetFrameLevel(3)
        FocusFrameManaBarDummy:EnableMouse(true)

        frame.FocusFrameManaBarDummy = FocusFrameManaBarDummy

        local t = FocusFrameManaBarDummy:CreateFontString('FocusFrameManaBarText', 'OVERLAY', 'TextStatusBarText')

        t:SetPoint('CENTER', FocusFrameManaBarDummy, -dx, 0)
        t:SetText('MANA')
        t:Hide()
        frame.FocusFrameManaBarText = t

        FocusFrameManaBarDummy:HookScript('OnEnter', function(self)
            if FocusFrameTextureFrame.ManaBarTextRight:IsVisible() or FocusFrameTextureFrame.ManaBarText:IsVisible() then
            else
                frame:UpdateFocusText()
                frame.FocusFrameManaBarText:Show()
            end
        end)
        FocusFrameManaBarDummy:HookScript('OnLeave', function(self)
            frame.FocusFrameManaBarText:Hide()
        end)
    end

    -- FocusFrameToTDebuff1:SetPoint('TOPLEFT', FocusFrameToT, 'TOPRIGHT', 25, -20) -- ?? TODO

    if not FocusFrame.DFRangeHooked then
        FocusFrame.DFRangeHooked = true;

        local state = self.ModuleRef.db.profile.focus

        if not RangeCheck then return end
        local function updateRange()
            local minRange, maxRange = RangeCheck:GetRange('focus')
            -- print(minRange, maxRange)

            if not state.fadeOut then
                FocusFrame:SetAlpha(1);
                return;
            end

            if minRange and minRange >= state.fadeOutDistance then
                FocusFrame:SetAlpha(0.55);
                -- elseif maxRange and maxRange >= 40 then
                --     TargetFrame:SetAlpha(0.55);
            else
                FocusFrame:SetAlpha(1);
            end
        end

        FocusFrame:HookScript('OnUpdate', updateRange)
        FocusFrame:HookScript('OnEvent', updateRange)
    end
end

function SubModuleMixin:ReApplyFocusFrame()
    self.ModuleRef.SubTarget:UpdateTargetHealthBarTexture(FocusFrameHealthBar, self.ModuleRef.db.profile.focus, 'focus')
    self.ModuleRef.SubTarget:UpdateTargetPowerBarTexture(FocusFrameManaBar, self.ModuleRef.db.profile.focus, 'focus')

    FocusFrameFlash:SetTexture('')
    if self.PortraitExtra then self.PortraitExtra:UpdateStyle() end
end

function SubModuleMixin:UpdateFocusText()
    -- print('UpdateFocusText')
    if UnitExists('focus') then
        local max_health = UnitHealthMax('focus')
        local health = UnitHealth('focus')

        self.FocusFrameHealthBarText:SetText(health .. ' / ' .. max_health)

        local max_mana = UnitPowerMax('focus')
        local mana = UnitPower('focus')

        if max_mana == 0 then
            self.FocusFrameManaBarText:SetText('')
        else
            self.FocusFrameManaBarText:SetText(mana .. ' / ' .. max_mana)
        end
    end
end
