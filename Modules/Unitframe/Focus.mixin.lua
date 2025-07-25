local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local subModuleName = 'Focus';
local SubModuleMixin = {};
addonTable.SubModuleMixins[subModuleName] = SubModuleMixin;

function SubModuleMixin:Init()
    self.ModuleRef = DF:GetModule('Unitframe')
    self:SetDefaults()
    self:SetupOptions()

    self:SetScript('OnEvent', self.OnEvent);
    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('PLAYER_FOCUS_CHANGED')

    self:RegisterEvent('UNIT_HEALTH')
    self:RegisterEvent('UNIT_POWER_UPDATE')
    self:RegisterEvent('PLAYER_FOCUS_CHANGED')
end

function SubModuleMixin:SetDefaults()
    local defaults = {
        classcolor = false,
        classicon = false,
        breakUpLargeNumbers = true,
        hideNameBackground = false,
        scale = 1.0,
        override = false,
        anchorFrame = 'UIParent',
        customAnchorFrame = '',
        anchor = 'TOPLEFT',
        anchorParent = 'TOPLEFT',
        x = 250,
        y = -170,
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
                order = 7,
                editmode = true
            },
            classicon = {
                type = 'toggle',
                name = L["FocusFrameClassIcon"],
                desc = L["FocusFrameClassIconDesc"] .. getDefaultStr('classicon', 'focus'),
                group = 'headerStyling',
                order = 7.1,
                disabled = true,
                new = false,
                editmode = true
            },
            breakUpLargeNumbers = {
                type = 'toggle',
                name = L["FocusFrameBreakUpLargeNumbers"],
                desc = L["FocusFrameBreakUpLargeNumbersDesc"] .. getDefaultStr('breakUpLargeNumbers', 'focus'),
                group = 'headerStyling',
                order = 8,
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
    self:ChangeFocusFrame()

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

    FocusFrame:UpdateStateHandler(state)
    self.PreviewFocus:UpdateState(state);
end

function SubModuleMixin:ChangeFocusFrame()
    local frame = self;
    local Module = self.ModuleRef;
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    FocusFrameTextureFrameTexture:Hide()
    FocusFrameBackground:Hide()

    if not frame.FocusFrameBackground then
        local background = FocusFrame:CreateTexture('DragonflightUIFocusFrameBackground')
        background:SetDrawLayer('BACKGROUND', 2)
        background:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BACKGROUND')
        background:SetPoint('LEFT', FocusFrame, 'LEFT', 0, -32.5 + 10)
        frame.FocusFrameBackground = background
    end

    if not frame.FocusFrameBorder then
        local border = FocusFrame:CreateTexture('DragonflightUIFocusFrameBorder')
        border:SetDrawLayer('ARTWORK', 2)
        border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BORDER')
        border:SetPoint('LEFT', FocusFrame, 'LEFT', 0, -32.5 + 10)
        frame.FocusFrameBorder = border
    end

    FocusFramePortrait:SetDrawLayer('BACKGROUND', -1)
    FocusFramePortrait:SetSize(56, 56)
    local CorrectionY = -3
    local CorrectionX = -5
    FocusFramePortrait:SetPoint('TOPRIGHT', FocusFrame, 'TOPRIGHT', -42 + CorrectionX, -12 + CorrectionY)

    FocusFrameTextureFrameRaidTargetIcon:SetPoint('CENTER', FocusFramePortrait, 'TOP', 0, 2)

    FocusFrameNameBackground:ClearAllPoints()
    FocusFrameNameBackground:SetTexture(base)
    FocusFrameNameBackground:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Target-PortraitOn-Type'))
    FocusFrameNameBackground:SetSize(135, 18)
    FocusFrameNameBackground:ClearAllPoints()
    FocusFrameNameBackground:SetPoint('BOTTOMLEFT', FocusFrameHealthBar, 'TOPLEFT', -2, -4 - 1)

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

    -- @TODO: change text spacing
    FocusFrameTextureFrameName:ClearAllPoints()
    FocusFrameTextureFrameName:SetPoint('BOTTOM', FocusFrameHealthBar, 'TOP', 10, 3 - 2)
    FocusFrameTextureFrameName:SetSize(100, 12)

    FocusFrameTextureFrameLevelText:ClearAllPoints()
    FocusFrameTextureFrameLevelText:SetPoint('BOTTOMRIGHT', FocusFrameHealthBar, 'TOPLEFT', 16, 3 - 2)
    FocusFrameTextureFrameLevelText:SetHeight(12)

    FocusFrameTextureFrameDeadText:ClearAllPoints()
    FocusFrameTextureFrameDeadText:SetPoint('CENTER', FocusFrameHealthBar, 'CENTER', 0, 0)

    FocusFrameTextureFrameUnconsciousText:ClearAllPoints()
    FocusFrameTextureFrameUnconsciousText:SetPoint('CENTER', FocusFrameHealthBar, 'CENTER', 0, 0)

    local dx = 5
    -- health vs mana bar
    local deltaSize = 132 - 125

    FocusFrameTextureFrame.HealthBarText:ClearAllPoints()
    FocusFrameTextureFrame.HealthBarText:SetPoint('CENTER', FocusFrameHealthBar, 0, 0)
    FocusFrameTextureFrame.HealthBarTextLeft:SetPoint('LEFT', FocusFrameHealthBar, 'LEFT', dx, 0)
    FocusFrameTextureFrame.HealthBarTextRight:SetPoint('RIGHT', FocusFrameHealthBar, 'RIGHT', -dx, 0)

    FocusFrameTextureFrame.ManaBarText:ClearAllPoints()
    FocusFrameTextureFrame.ManaBarText:SetPoint('CENTER', FocusFrameManaBar, -deltaSize / 2, 0)
    FocusFrameTextureFrame.ManaBarTextLeft:SetPoint('LEFT', FocusFrameManaBar, 'LEFT', dx, 0)
    FocusFrameTextureFrame.ManaBarTextRight:SetPoint('RIGHT', FocusFrameManaBar, 'RIGHT', -deltaSize - dx, 0)

    -- Health 119,12
    FocusFrameHealthBar:ClearAllPoints()
    FocusFrameHealthBar:SetSize(125, 20)
    FocusFrameHealthBar:SetPoint('RIGHT', FocusFramePortrait, 'LEFT', -1, 0)
    --[[    FocusFrameHealthBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOff-Bar-Health'
    )
    FocusFrameHealthBar:SetStatusBarColor(1, 1, 1, 1) ]]
    -- Mana 119,12
    FocusFrameManaBar:ClearAllPoints()
    -- FocusFrameManaBar:SetPoint('RIGHT', FocusFramePortrait, 'LEFT', -1 + 8 - 0.5, -18 + 1 + 0.5)
    FocusFrameManaBar:SetPoint('TOPLEFT', FocusFrameHealthBar, 'BOTTOMLEFT', 0, -1)
    FocusFrameManaBar:SetSize(134, 10)
    FocusFrameManaBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana')
    FocusFrameManaBar:SetStatusBarColor(1, 1, 1, 1)

    if not FocusFrameManaBar.DFMask then
        local manaMask = FocusFrameManaBar:CreateMaskTexture()
        manaMask:SetPoint('TOPLEFT', FocusFrameManaBar, 'TOPLEFT', -61, 3)
        manaMask:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\ui-hud-unitframe-target-portraiton-bar-mana-mask-2x',
            'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
        manaMask:SetTexCoord(0, 1, 0, 1)
        manaMask:SetSize(256, 16)
        FocusFrameManaBar:GetStatusBarTexture():AddMaskTexture(manaMask)
        FocusFrameManaBar.DFMask = manaMask;
    end

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
                Module.UpdateFocusText()
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
                Module.UpdateFocusText()
                frame.FocusFrameManaBarText:Show()
            end
        end)
        FocusFrameManaBarDummy:HookScript('OnLeave', function(self)
            frame.FocusFrameManaBarText:Hide()
        end)
    end

    FocusFrameFlash:SetTexture('')

    FocusFrameToTDebuff1:SetPoint('TOPLEFT', FocusFrameToT, 'TOPRIGHT', 25, -20)

    if not frame.FocusFrameFlash then
        local flash = FocusFrame:CreateTexture('DragonflightUIFocusFrameFlash')
        flash:SetDrawLayer('BACKGROUND', 2)
        flash:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-InCombat')
        flash:SetPoint('CENTER', FocusFrame, 'CENTER', 20 + CorrectionX, -20 + CorrectionY)
        flash:SetSize(256, 128)
        flash:SetScale(1)
        flash:SetVertexColor(1.0, 0.0, 0.0, 1.0)
        flash:SetBlendMode('ADD')
        frame.FocusFrameFlash = flash
    end

    hooksecurefunc(FocusFrameFlash, 'Show', function()
        -- print('show')
        FocusFrameFlash:SetTexture('')
        frame.FocusFrameFlash:Show()
        if (UIFrameIsFlashing(frame.FocusFrameFlash)) then
        else
            -- print('go flash')
            local dt = 0.5
            UIFrameFlash(frame.FocusFrameFlash, dt, dt, -1)
        end
    end)

    hooksecurefunc(FocusFrameFlash, 'Hide', function()
        -- print('hide')
        FocusFrameFlash:SetTexture('')
        if (UIFrameIsFlashing(frame.FocusFrameFlash)) then UIFrameFlashStop(frame.FocusFrameFlash) end
        frame.FocusFrameFlash:Hide()
    end)

    if not frame.FocusExtra then
        local extra = FocusFrame:CreateTexture('DragonflightUIFocusFramePortraitExtra')
        extra:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiunitframeboss2x')
        extra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
        extra:SetSize(80, 79)
        extra:SetDrawLayer('ARTWORK', 3)
        extra:SetPoint('CENTER', FocusFramePortrait, 'CENTER', 4, 1)

        extra.UpdateStyle = function()
            local class = UnitClassification('focus')
            --[[ "worldboss", "rareelite", "elite", "rare", "normal", "trivial" or "minus" ]]
            if class == 'worldboss' then
                frame.FocusExtra:Show()
                frame.FocusExtra:SetSize(99, 81)
                frame.FocusExtra:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.31835937)
                frame.FocusExtra:SetPoint('CENTER', FocusFramePortrait, 'CENTER', 13, 1)
            elseif class == 'rareelite' or class == 'rare' then
                frame.FocusExtra:Show()
                frame.FocusExtra:SetSize(80, 79)
                frame.FocusExtra:SetTexCoord(0.00390625, 0.31640625, 0.64453125, 0.953125)
                frame.FocusExtra:SetPoint('CENTER', FocusFramePortrait, 'CENTER', 4, 1)
            elseif class == 'elite' then
                frame.FocusExtra:Show()
                frame.FocusExtra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
                frame.FocusExtra:SetSize(80, 79)
                frame.FocusExtra:SetPoint('CENTER', FocusFramePortrait, 'CENTER', 4, 1)
            else
                local name, realm = UnitName('target')
                if Module.famous[name] then
                    frame.FocusExtra:Show()
                    frame.FocusExtra:SetSize(99, 81)
                    frame.FocusExtra:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.31835937)
                    frame.FocusExtra:SetPoint('CENTER', FocusFramePortrait, 'CENTER', 13, 1)
                else
                    frame.FocusExtra:Hide()
                end
            end
        end

        frame.FocusExtra = extra
    end
end

function SubModuleMixin:ReApplyFocusFrame()
    if self.ModuleRef.db.profile.focus.classcolor and UnitIsPlayer('focus') then
        FocusFrameHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health-Status')
        local localizedClass, englishClass, classIndex = UnitClass('focus')
        FocusFrameHealthBar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
    else
        FocusFrameHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health')
        FocusFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)
    end

    local powerType, powerTypeString = UnitPowerType('focus')

    if powerTypeString == 'MANA' then
        FocusFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana')
    elseif powerTypeString == 'FOCUS' then
        FocusFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus')
    elseif powerTypeString == 'RAGE' then
        FocusFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage')
    elseif powerTypeString == 'ENERGY' then
        FocusFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy')
    elseif powerTypeString == 'RUNIC_POWER' then
        FocusFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower')
    end

    FocusFrameManaBar:SetStatusBarColor(1, 1, 1, 1)

    FocusFrameFlash:SetTexture('')

    if self.FocusExtra then self.FocusExtra:UpdateStyle() end
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
