local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;
local LSM = LibStub('LibSharedMedia-3.0')

local subModuleName = 'PlayerFrame';
local SubModuleMixin = {};
addonTable.SubModuleMixins[subModuleName] = SubModuleMixin;

function SubModuleMixin:Init()
    self.ModuleRef = DF:GetModule('Unitframe')
    self:SetDefaults()
    self:SetupOptions()
    -- self:SetScript('OnEvent', self.OnEvent);  
end

function SubModuleMixin:SetDefaults()
    local defaults = {
        classcolor = false,
        classicon = false,
        breakUpLargeNumbers = true,
        scale = 1.0,
        override = false,
        anchorFrame = 'UIParent',
        customAnchorFrame = '',
        anchor = 'TOPLEFT',
        anchorParent = 'TOPLEFT',
        x = -19,
        y = -4,
        customHealthBarTexture = 'Default',
        customPowerBarTexture = 'Default',
        biggerHealthbar = false,
        portraitExtra = 'none',
        hideRedStatus = false,
        hideIndicator = false,
        hideAlternatePowerBar = false,
        hideRestingGlow = false,
        hideRestingIcon = false,
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

    local statusTextTable = {
        {value = 'None', text = 'None', tooltip = 'descr', label = 'label'},
        {value = 'Percent', text = 'Percent', tooltip = 'descr', label = 'label'},
        {value = 'Both', text = 'Both', tooltip = 'descr', label = 'label'},
        {value = 'Numeric Value', text = 'Numeric Value', tooltip = 'descr', label = 'label'}
    }

    local portraitExtraTable = {
        {value = 'none', text = 'None', tooltip = 'descr', label = 'label'},
        {value = 'elite', text = 'Elite', tooltip = 'descr', label = 'label'},
        {value = 'rare', text = 'Rare', tooltip = 'descr', label = 'label'},
        {value = 'worldboss', text = 'World Boss', tooltip = 'descr', label = 'label'}
    }

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

    local optionsPlayer = {
        name = L["PlayerFrameName"],
        desc = L["PlayerFrameDesc"],
        advancedName = 'PlayerFrame',
        sub = "player",
        get = getOption,
        set = setOption,
        type = 'group',
        args = {
            headerStyling = {
                type = 'header',
                name = L["PlayerFrameStyle"],
                desc = '',
                order = 20,
                isExpanded = true,
                editmode = true
            },
            classcolor = {
                type = 'toggle',
                name = L["PlayerFrameClassColor"],
                desc = L["PlayerFrameClassColorDesc"] .. getDefaultStr('classcolor', 'player'),
                group = 'headerStyling',
                order = 7,
                editmode = true
            },
            classicon = {
                type = 'toggle',
                name = L["PlayerFrameClassIcon"],
                desc = L["PlayerFrameClassIconDesc"] .. getDefaultStr('classicon', 'player'),
                group = 'headerStyling',
                order = 7.1,
                disabled = true,
                new = false,
                editmode = true
            },
            breakUpLargeNumbers = {
                type = 'toggle',
                name = L["PlayerFrameBreakUpLargeNumbers"],
                desc = L["PlayerFrameBreakUpLargeNumbersDesc"],
                group = 'headerStyling',
                order = 8,
                editmode = true
            },
            biggerHealthbar = {
                type = 'toggle',
                name = L["PlayerFrameBiggerHealthbar"],
                desc = L["PlayerFrameBiggerHealthbarDesc"] .. getDefaultStr('biggerHealthbar', 'player'),
                group = 'headerStyling',
                order = 9,
                new = false,
                editmode = true
            },
            portraitExtra = {
                type = 'select',
                name = L["PlayerFramePortraitExtra"],
                desc = L["PlayerFramePortraitExtraDesc"] .. getDefaultStr('portraitExtra', 'player'),
                dropdownValues = portraitExtraTable,
                order = 9.5,
                group = 'headerStyling',
                new = true,
                editmode = true
            },
            hideRedStatus = {
                type = 'toggle',
                name = L["PlayerFrameHideRedStatus"],
                desc = L["PlayerFrameHideRedStatusDesc"] .. getDefaultStr('hideRedStatus', 'player'),
                group = 'headerStyling',
                order = 10,
                new = false,
                editmode = true
            },
            hideIndicator = {
                type = 'toggle',
                name = L["PlayerFrameHideHitIndicator"],
                desc = L["PlayerFrameHideHitIndicatorDesc"] .. getDefaultStr('hideIndicator', 'player'),
                group = 'headerStyling',
                order = 11,
                new = false,
                editmode = true
            },
            hideRestingGlow = {
                type = 'toggle',
                name = L["PlayerFrameHideRestingGlow"],
                desc = L["PlayerFrameHideRestingGlowDesc"] .. getDefaultStr('hideRestingGlow', 'player'),
                group = 'headerStyling',
                order = 12,
                new = true,
                editmode = true
            },
            hideRestingIcon = {
                type = 'toggle',
                name = L["PlayerFrameHideRestingIcon"],
                desc = L["PlayerFrameHideRestingIconDesc"] .. getDefaultStr('hideRestingIcon', 'player'),
                group = 'headerStyling',
                order = 13,
                new = true,
                editmode = true
            }
        }
    }

    if DF.Era then
        local localizedClass, englishClass, classIndex = UnitClass('player');
        if englishClass == 'DRUID' then
            optionsPlayer.args['hideAlternatePowerBar'] = {
                type = 'toggle',
                name = L["PlayerFrameHideAlternatePowerBar"],
                desc = L["PlayerFrameHideAlternatePowerBarDesc"] .. getDefaultStr('hideAlternatePowerBar', 'player'),
                group = 'headerStyling',
                order = 13,
                new = false,
                editmode = true
            }
        end
    end

    if true then
        local moreOptions = {
            statusText = {
                type = 'select',
                name = STATUSTEXT_LABEL,
                desc = OPTION_TOOLTIP_STATUS_TEXT_DISPLAY,
                values = {
                    ['None'] = 'None',
                    ['Percent'] = 'Percent',
                    ['Both'] = 'Both',
                    ['Numeric Value'] = 'Numeric Value'
                },
                dropdownValues = statusTextTable,
                group = 'headerStyling',
                order = 10,
                blizzard = true,
                editmode = true
            }
        }

        for k, v in pairs(moreOptions) do optionsPlayer.args[k] = v end

        local CVAR_VALUE_NUMERIC = "NUMERIC";
        local CVAR_VALUE_PERCENT = "PERCENT";
        local CVAR_VALUE_BOTH = "BOTH";
        local CVAR_VALUE_NONE = "NONE";

        optionsPlayer.get = function(info)
            local key = info[1]
            local sub = info[2]

            if sub == 'statusText' then
                local statusTextDisplay = C_CVar.GetCVar("statusTextDisplay");
                if statusTextDisplay == CVAR_VALUE_NUMERIC then
                    return 'Numeric Value';
                elseif statusTextDisplay == CVAR_VALUE_PERCENT then
                    return 'Percent';
                elseif statusTextDisplay == CVAR_VALUE_BOTH then
                    return 'Both';
                elseif statusTextDisplay == CVAR_VALUE_NONE then
                    return 'None';
                end
            else
                return getOption(info)
            end
        end

        local textStatusBars = {
            PlayerFrameHealthBar, PlayerFrameManaBar, PetFrameHealthBar, PetFrameManaBar, TargetFrameHealthBar,
            TargetFrameManaBar, FocusFrameHealthBar, FocusFrameManaBar
        }

        local function CVarChangedCB()
            for k, v in ipairs(textStatusBars) do if v then TextStatusBar_UpdateTextString(v) end end
        end

        optionsPlayer.set = function(info, value)
            local key = info[1]
            local sub = info[2]

            if sub == 'statusText' then
                if value == 'Numeric Value' then
                    SetCVar("statusTextDisplay", CVAR_VALUE_NUMERIC);
                    SetCVar("statusText", "1");
                elseif value == 'Percent' then
                    SetCVar("statusTextDisplay", CVAR_VALUE_PERCENT);
                    SetCVar("statusText", "1");
                elseif value == 'Both' then
                    SetCVar("statusTextDisplay", CVAR_VALUE_BOTH);
                    SetCVar("statusText", "1");
                elseif value == 'None' then
                    SetCVar("statusTextDisplay", CVAR_VALUE_NONE);
                    SetCVar("statusText", "0");
                end
                CVarChangedCB()
            else
                setOption(info, value)
            end
        end
    end
    if true then
        optionsPlayer.args['customHealthBarTexture'] = {
            type = 'select',
            name = L["PlayerFrameCustomHealthbarTexture"],
            desc = L["PlayerFrameCustomHealthbarTextureDesc"] .. getDefaultStr('customHealthBarTexture', 'player'),
            dropdownValuesFunc = Helper:CreateSharedMediaStatusBarGenerator(function(name)
                return getOption({optionsPlayer.sub, 'customHealthBarTexture'}) == name;
            end, function(name)
                setOption({optionsPlayer.sub, 'customHealthBarTexture'}, name)
            end),
            group = 'headerStyling',
            order = 41,
            new = true
        }
        optionsPlayer.args['customPowerBarTexture'] = {
            type = 'select',
            name = L["PlayerFrameCustomPowerbarTexture"],
            desc = L["PlayerFrameCustomPowerbarTextureDesc"] .. getDefaultStr('customPowerBarTexture', 'player'),
            dropdownValuesFunc = Helper:CreateSharedMediaStatusBarGenerator(function(name)
                return getOption({optionsPlayer.sub, 'customPowerBarTexture'}) == name;
            end, function(name)
                setOption({optionsPlayer.sub, 'customPowerBarTexture'}, name)
            end),
            group = 'headerStyling',
            order = 42,
            new = true
        }
    end

    DF.Settings:AddPositionTable(Module, optionsPlayer, 'player', 'Player', getDefaultStr,
                                 frameTableWithout('PlayerFrame'))

    DragonflightUIStateHandlerMixin:AddStateTable(Module, optionsPlayer, 'player', 'Player', getDefaultStr)
    local optionsPlayerEditmode = {
        name = 'Player',
        desc = 'PlayerframeDesc',
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
                    local dbTable = Module.db.profile.player
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

    self.Options = optionsPlayer;
    self.OptionsEditmode = optionsPlayerEditmode;
end

function SubModuleMixin:Setup()
    local function setDefaultSubValues(sub)
        self.ModuleRef:SetDefaultSubValues(sub)
    end

    DF.ConfigModule:RegisterSettingsData('player', 'unitframes', {
        options = self.Options,
        default = function()
            setDefaultSubValues('player')
        end
    })
    --
    self:SetScript('OnEvent', self.OnEvent);

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('PLAYER_TARGET_CHANGED')
    -- self:RegisterEvent('UNIT_ENTERED_VEHICLE')
    -- self:RegisterEvent('UNIT_EXITED_VEHICLE')

    self:RegisterUnitEvent('UNIT_ENTERED_VEHICLE', 'player')
    self:RegisterUnitEvent('UNIT_EXITED_VEHICLE', 'player')

    self:RegisterEvent('ZONE_CHANGED')
    self:RegisterEvent('ZONE_CHANGED_INDOORS')
    self:RegisterEvent('ZONE_CHANGED_NEW_AREA')
    --
    self:CreatePlayerFrameTextures()
    self:ChangePlayerframe()
    self:CreatePlayerFrameExtra()
    self:CreateCustomPortrait()
    -- self:ChangeStatusIcons() -- PLAYER_ENTERING_WORLD
    self:CreateRestFlipbook()
    self:HookRestFunctions()

    if DF.Era then self:AddAlternatePowerBar() end

    PlayerFrameHealthBar:HookScript('OnValueChanged', function()
        self:UpdatePlayerFrameHealthBar()
    end)
    PlayerFrameHealthBar:HookScript('OnEvent', function(_, event, arg1)
        -- if event == 'UNIT_MAXHEALTH' and arg1 == 'player' then Module.UpdatePlayerFrameHealthBar() end
        self:UpdatePlayerFrameHealthBar()
    end)
    PlayerFrame:HookScript('OnEvent', function(_, event, arg1)
        -- print('onevent playerframe')
        self:UpdatePlayerFrameHealthBar()
    end)

    _G['PlayerFrameManaBar'].DFUpdateFunc = function()
        self:UpdatePlayerFrameManaBar()
    end

    hooksecurefunc('PlayerFrame_UpdateStatus', function()
        --
        self:UpdatePlayerStatus()
    end)

    hooksecurefunc('PlayerFrame_ToPlayerArt', function()
        -- print('PlayerFrame_ToPlayerArt')
        self:ChangePlayerframe()
        -- Module.SetPlayerBiggerHealthbar(Module.db.profile.player.biggerHealthbar)
    end)

    -- state handler
    Mixin(PlayerFrame, DragonflightUIStateHandlerMixin)
    PlayerFrame:InitStateHandler()

    -- editmode
    local EditModeModule = DF:GetModule('Editmode');
    EditModeModule:AddEditModeToFrame(PlayerFrame)

    PlayerFrame.DFEditModeSelection:SetGetLabelTextFunction(function()
        return self.Options.name
    end)

    PlayerFrame.DFEditModeSelection:RegisterOptions({
        options = self.Options,
        extra = self.OptionsEditmode,
        default = function()
            setDefaultSubValues('player')
        end,
        moduleRef = self.ModuleRef
    });

end

function SubModuleMixin:OnEvent(event, ...)
    -- print(event, ...)
    if event == 'PLAYER_ENTERING_WORLD' then
        self:ChangePlayerframe()
        self:SetPlayerBiggerHealthbar(self.ModuleRef.db.profile.player.biggerHealthbar)
        self:ChangeStatusIcons()
    elseif event == 'UNIT_ENTERED_VEHICLE' then
        self:ChangePlayerframe()
        self:SetPlayerBiggerHealthbar(self.ModuleRef.db.profile.player.biggerHealthbar)
    elseif event == 'UNIT_EXITED_VEHICLE' then
        self:ChangePlayerframe()
        self:SetPlayerBiggerHealthbar(self.ModuleRef.db.profile.player.biggerHealthbar)
    elseif event == 'ZONE_CHANGED' or event == 'ZONE_CHANGED_INDOORS' or event == 'ZONE_CHANGED_NEW_AREA' then
        self:ChangePlayerframe()
        self:SetPlayerBiggerHealthbar(self.ModuleRef.db.profile.player.biggerHealthbar)
    elseif event == 'PLAYER_TARGET_CHANGED' then
        -- fallback
        -- self:ChangePlayerframe()
        -- self:SetPlayerBiggerHealthbar(self.ModuleRef.db.profile.player.biggerHealthbar)
    end
end

function SubModuleMixin:UpdateState(state)
    self.state = state;
    self:Update();
end

function SubModuleMixin:Update()
    local state = self.state;
    if not state then return end

    local f = PlayerFrame

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

    self:ChangePlayerframe()
    self:SetPlayerBiggerHealthbar(state.biggerHealthbar)
    self.PlayerPortraitExtra:UpdateStyle(state.portraitExtra)
    self:UpdatePlayerStatus()
    self:UpdatePlayerFrameHealthBar()
    self:UpdatePlayerFrameManaBar()
    PlayerFrameHealthBar.breakUpLargeNumbers = state.breakUpLargeNumbers
    TextStatusBar_UpdateTextString(PlayerFrameHealthBar)
    UnitFramePortrait_Update(PlayerFrame)

    if state.hideIndicator then
        PlayerHitIndicator:SetScale(0.01)
    else
        PlayerHitIndicator:SetScale(1)
    end
    self:HideAlternatePowerBar(state.hideAlternatePowerBar)

    f:UpdateStateHandler(state)
end

function SubModuleMixin:CreatePlayerFrameTextures()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'
    local tex2xBase = 'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe2x\\'

    if not self.PlayerFrameBackground then
        local background = PlayerFrame:CreateTexture('DragonflightUIPlayerFrameBackground')
        background:SetTexelSnappingBias(0.0)
        background:SetSnapToPixelGrid(false)
        self.PlayerFrameBackground = background
    end

    if not self.PlayerFrameDeco then
        local textureSmall = PlayerFrame:CreateTexture('DragonflightUIPlayerFrameDeco')
        textureSmall:SetDrawLayer('OVERLAY', 5)
        textureSmall:SetTexture(tex2xBase .. 'ui-hud-unitframe-player-portraiton-cornerembellishment-2x')
        textureSmall:SetTexCoord(0, 44 / 64, 0, 44 / 64)
        textureSmall:SetSize(22, 22)
        textureSmall:SetPoint('CENTER', PlayerFrame, 'CENTER', -32 + 1.5, -9.5)

        self.PlayerFrameDeco = textureSmall
    end
end

function SubModuleMixin:ChangePlayerframe()
    PlayerFrameTexture:Hide()
    PlayerFrameBackground:Hide()
    PlayerFrameVehicleTexture:Hide()

    -- @TODO: change text spacing
    PlayerName:ClearAllPoints()
    PlayerName:SetPoint('BOTTOMLEFT', PlayerFrameHealthBar, 'TOPLEFT', 0, 1)

    PlayerLevelText:ClearAllPoints()
    PlayerLevelText:SetPoint('BOTTOMRIGHT', PlayerFrameHealthBar, 'TOPRIGHT', -5, 1)
    PlayerLevelText:SetHeight(12)

    self:UpdatePlayerFrameHealthBar()

    PlayerFrameHealthBarText:SetPoint('CENTER', PlayerFrameHealthBar, 'CENTER', 0, 0)

    local dx = 5
    PlayerFrameHealthBarTextLeft:SetPoint('LEFT', PlayerFrameHealthBar, 'LEFT', dx, 0)
    PlayerFrameHealthBarTextRight:SetPoint('RIGHT', PlayerFrameHealthBar, 'RIGHT', -dx, 0)

    local dy = -0.75;
    PlayerFrameManaBarText:SetPoint('CENTER', PlayerFrameManaBar, 'CENTER', 0, dy)
    PlayerFrameManaBarTextLeft:SetPoint('LEFT', PlayerFrameManaBar, 'LEFT', dx, dy)
    PlayerFrameManaBarTextRight:SetPoint('RIGHT', PlayerFrameManaBar, 'RIGHT', -dx, dy)

    self:UpdatePlayerFrameManaBar()

    if _G['TotemFrame'] then
        _G['TotemFrame']:ClearAllPoints()
        _G['TotemFrame']:SetPoint('TOPLEFT', PlayerFrame, 'BOTTOMLEFT', 99 + 3, 38 - 3)
    end
end

function SubModuleMixin:CreateCustomPortrait()
    PlayerPortrait:ClearAllPoints()
    PlayerPortrait:SetPoint('TOPLEFT', PlayerFrame, 'TOPLEFT', 42, -15)
    PlayerPortrait:SetDrawLayer('BACKGROUND', -1)
    PlayerPortrait:SetSize(57, 57)

    -- function PlayerPortrait:fixClassSize(class)
    --     --
    --     -- print('fixClassSize', class)
    --     if class then
    --         local delta = 4.5;
    --         PlayerPortrait:SetVertexOffset(1, -delta, delta)
    --         PlayerPortrait:SetVertexOffset(2, -delta, -delta)
    --         PlayerPortrait:SetVertexOffset(3, delta, delta)
    --         PlayerPortrait:SetVertexOffset(4, delta, -delta)
    --     else
    --         PlayerPortrait:SetVertexOffset(1, 0, 0)
    --         PlayerPortrait:SetVertexOffset(2, 0, 0)
    --         PlayerPortrait:SetVertexOffset(3, 0, 0)
    --         PlayerPortrait:SetVertexOffset(4, 0, 0)
    --     end

    -- end
    -- PlayerPortrait:fixClassSize(false)
end

function SubModuleMixin:CreateRestFlipbook()
    if not self.RestIcon then
        local rest = CreateFrame('Frame', 'DragonflightUIRestFlipbook', PlayerFrame)
        rest:SetSize(20, 20)
        rest:SetPoint('CENTER', PlayerPortrait, 'TOPRIGHT', -4, 4)
        ---@diagnostic disable-next-line: redundant-parameter
        rest:SetFrameStrata('MEDIUM', 5)
        rest:SetScale(1.2)

        local restTexture = rest:CreateTexture('DragonflightUIRestFlipbookTexture')
        restTexture:SetAllPoints()
        restTexture:SetColorTexture(1, 1, 1, 1)
        restTexture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiunitframerestingflipbook')
        restTexture:SetTexCoord(0, 7 / 8, 0, 7 / 8)

        local animationGroup = restTexture:CreateAnimationGroup()
        local animation = animationGroup:CreateAnimation('Flipbook', 'RestFlipbookAnimation')

        animationGroup:SetLooping('REPEAT')
        local size = 60
        animation:SetFlipBookFrameWidth(size)
        animation:SetFlipBookFrameHeight(size)
        animation:SetFlipBookRows(7)
        animation:SetFlipBookColumns(6)
        animation:SetFlipBookFrames(42)
        animation:SetDuration(1.5)

        self.RestIcon = rest
        self.RestIconAnimation = animationGroup

        PlayerFrame_UpdateStatus()
    end
end

function SubModuleMixin:HookRestFunctions()
    hooksecurefunc(PlayerStatusGlow, 'Show', function()
        PlayerStatusGlow:Hide()
    end)

    hooksecurefunc(PlayerRestIcon, 'Show', function()
        PlayerRestIcon:Hide()
    end)

    hooksecurefunc(PlayerRestGlow, 'Show', function()
        PlayerRestGlow:Hide()
    end)

    hooksecurefunc('SetUIVisibility', function(visible)
        if visible then
            PlayerFrame_UpdateStatus()
        else
            self.RestIcon:Hide()
            self.RestIconAnimation:Stop()
        end
    end)
end

function SubModuleMixin:UpdatePlayerStatus()
    if not self.PlayerFrameDeco then return end

    -- TODO: fix statusglow
    PlayerStatusGlow:Hide()

    if UnitHasVehiclePlayerFrameUI and UnitHasVehiclePlayerFrameUI('player') then
        -- TODO: vehicle stuff
        -- frame.PlayerFrameDeco:Show()
        self.RestIcon:Hide()
        self.RestIconAnimation:Stop()
        -- frame.PlayerFrameDeco:Show()
    elseif IsResting() then
        self.PlayerFrameDeco:Show()

        self.RestIcon:Show()
        self.RestIconAnimation:Play()

        PlayerStatusTexture:Show()
        -- PlayerStatusTexture:SetVertexColor(1.0, 0.88, 0.25, 1.0)
        PlayerStatusTexture:SetAlpha(1.0)
    elseif PlayerFrame.onHateList then
        -- PlayerStatusTexture:Show()
        -- PlayerStatusTexture:SetVertexColor(1.0, 0, 0, 1.0)
        self.PlayerFrameDeco:Hide()

        self.RestIcon:Hide()
        self.RestIconAnimation:Stop()

        self.PlayerFrameBackground:SetVertexColor(1.0, 0, 0, 1.0)
    elseif PlayerFrame.inCombat then
        self.PlayerFrameDeco:Hide()

        self.RestIcon:Hide()
        self.RestIconAnimation:Stop()

        self.PlayerFrameBackground:SetVertexColor(1.0, 0, 0, 1.0)

        PlayerStatusTexture:Show()
        -- PlayerStatusTexture:SetVertexColor(1.0, 0, 0, 1.0)
        PlayerStatusTexture:SetAlpha(1.0)
    else
        self.PlayerFrameDeco:Show()

        self.RestIcon:Hide()
        self.RestIconAnimation:Stop()

        self.PlayerFrameBackground:SetVertexColor(1.0, 1.0, 1.0, 1.0)
    end

    local db = self.ModuleRef.db.profile.player
    if db.hideRedStatus and (PlayerFrame.onHateList or PlayerFrame.inCombat) then
        --
        self.PlayerFrameBackground:SetVertexColor(1.0, 1.0, 1.0, 1.0)
        PlayerStatusTexture:SetAlpha(0)
        PlayerStatusTexture:Hide()
    end

    if db.hideRestingGlow and IsResting() then
        PlayerStatusTexture:SetAlpha(0)
        PlayerStatusTexture:Hide()
    end

    if db.hideRestingIcon and IsResting() then
        self.RestIcon:Hide()
        self.RestIconAnimation:Stop()
    end
end

function SubModuleMixin:CreatePlayerFrameExtra()
    local textureFrame = CreateFrame('Frame', 'DragonflightUIPlayerFrameTextureFrame', PlayerFrame)
    textureFrame:SetPoint('TOPLEFT')
    textureFrame:SetPoint('BOTTOMRIGHT')
    textureFrame:SetFrameLevel(3)
    PlayerFrame.DFTextureFrame = textureFrame

    local extra = textureFrame:CreateTexture('DragonflightUIPlayerFramePortraitExtra')
    extra:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiunitframeboss2x')
    -- extra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
    extra:SetTexCoord(0.314453125, 0.001953125, 0.322265625, 0.630859375)
    extra:SetSize(80, 79)
    extra:SetDrawLayer('ARTWORK', 7)
    extra:SetPoint('CENTER', PlayerPortrait, 'CENTER', -4, 1)
    self.PlayerPortraitExtra = extra

    function extra:UpdateStyle(class)
        -- local class = UnitClassification('target')
        --[[ "worldboss", "rareelite", "elite", "rare", "normal", "trivial" or "minus" ]]
        extra:ClearAllPoints()
        if class == 'worldboss' then
            extra:Show()
            extra:SetSize(99 - 2, 81 - 2)
            extra:SetTexCoord(0.388671875, 0.001953125, 0.001953125, 0.31835937)
            extra:SetPoint('CENTER', PlayerPortrait, 'CENTER', -13, 1 + 2)
        elseif class == 'rareelite' or class == 'rare' then
            extra:Show()
            extra:SetSize(80 - 2, 79 - 2)
            extra:SetTexCoord(0.31640625, 0.00390625, 0.634765625, 0.943359375)
            extra:SetPoint('CENTER', PlayerPortrait, 'CENTER', -4, 1 + 2)
        elseif class == 'elite' then
            extra:Show()
            extra:SetTexCoord(0.314453125, 0.001953125, 0.322265625, 0.630859375)
            extra:SetSize(80 - 2, 79 - 2)
            extra:SetPoint('CENTER', PlayerPortrait, 'CENTER', -4, 1 + 2)
        else
            extra:Hide()
        end
    end

    extra:UpdateStyle('none')
end

function SubModuleMixin:ChangeStatusIcons()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    PlayerAttackIcon:SetTexture(base)
    PlayerAttackIcon:SetTexCoord(0.9775390625, 0.9931640625, 0.259765625, 0.291015625)
    PlayerAttackIcon:ClearAllPoints()
    PlayerAttackIcon:SetPoint('BOTTOMRIGHT', PlayerPortrait, 'BOTTOMRIGHT', -3, 0)
    PlayerAttackIcon:SetSize(16, 16)

    PlayerAttackBackground:SetTexture(base)
    PlayerAttackBackground:SetTexCoord(0.1494140625, 0.1806640625, 0.8203125, 0.8828125)
    PlayerAttackBackground:ClearAllPoints()
    PlayerAttackBackground:SetPoint('CENTER', PlayerAttackIcon, 'CENTER')
    PlayerAttackBackground:SetSize(32, 32)

    PlayerFrameGroupIndicator:ClearAllPoints()
    -- PlayerFrameGroupIndicator:SetPoint('BOTTOMRIGHT', PlayerFrameHealthBar, 'TOPRIGHT', 4, 13)
    PlayerFrameGroupIndicator:SetPoint('BOTTOM', PlayerName, 'TOP', 0, 0)

    PlayerLeaderIcon:SetTexture(base)
    PlayerLeaderIcon:SetTexCoord(0.1259765625, 0.1416015625, 0.919921875, 0.951171875)
    -- PlayerLeaderIcon:ClearAllPoints()
    -- PlayerLeaderIcon:SetPoint('BOTTOM', PlayerName, 'TOP', 0, 0)
    PlayerLeaderIcon:ClearAllPoints()
    PlayerLeaderIcon:SetPoint('BOTTOMRIGHT', PlayerPortrait, 'TOPLEFT', 10, -10)

    -- TargetFrameTextureFrameLeaderIcon:SetTexture(base)
    -- TargetFrameTextureFrameLeaderIcon:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-Group-LeaderIcon'))
    -- TargetFrameTextureFrameLeaderIcon:ClearAllPoints()
    -- TargetFrameTextureFrameLeaderIcon:SetPoint('BOTTOMLEFT', TargetFramePortrait, 'TOPRIGHT', -10 - 3, -10)
end

local texBase = 'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\'
function SubModuleMixin:UpdatePlayerFrameHealthBar()
    local state = self.ModuleRef.db.profile.player;

    if state.customHealthBarTexture == 'Default' or not LSM then
        if state.classcolor then
            PlayerFrameHealthBar:GetStatusBarTexture():SetTexture(texBase ..
                                                                      'UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health-Status')
            local _, englishClass, _ = UnitClass('player')
            PlayerFrameHealthBar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
        else
            PlayerFrameHealthBar:GetStatusBarTexture():SetTexture(texBase ..
                                                                      'UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health')
            PlayerFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)
        end
    else
        local customTex = LSM:Fetch("statusbar", state.customHealthBarTexture)
        PlayerFrameHealthBar:GetStatusBarTexture():SetTexture(customTex)

        if state.classcolor then
            local _, englishClass, _ = UnitClass('player')
            PlayerFrameHealthBar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
        else
            PlayerFrameHealthBar:SetStatusBarColor(0.0, 1.0, 0.0, 1)
        end
    end
end

function SubModuleMixin:UpdatePlayerFrameManaBar()
    local state = self.ModuleRef.db.profile.player;

    if state.customPowerBarTexture == 'Default' or not LSM then
        local _, powerTypeString = UnitPowerType('player')

        if powerTypeString == 'MANA' then
            PlayerFrameManaBar:GetStatusBarTexture()
                :SetTexture(texBase .. 'UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana')
        elseif powerTypeString == 'RAGE' then
            PlayerFrameManaBar:GetStatusBarTexture()
                :SetTexture(texBase .. 'UI-HUD-UnitFrame-Player-PortraitOn-Bar-Rage')
        elseif powerTypeString == 'FOCUS' then
            PlayerFrameManaBar:GetStatusBarTexture():SetTexture(texBase ..
                                                                    'UI-HUD-UnitFrame-Player-PortraitOn-Bar-Focus')
        elseif powerTypeString == 'ENERGY' then
            PlayerFrameManaBar:GetStatusBarTexture():SetTexture(texBase ..
                                                                    'Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Energy')
        elseif powerTypeString == 'RUNIC_POWER' then
            PlayerFrameManaBar:GetStatusBarTexture():SetTexture(texBase ..
                                                                    'Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-RunicPower')
        else
            -- fallback - should not happen
            PlayerFrameManaBar:GetStatusBarTexture()
                :SetTexture(texBase .. 'UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana')
        end

        PlayerFrameManaBar:SetStatusBarColor(1, 1, 1, 1)
    else
        UnitFrameManaBar_UpdateType(PlayerFrameManaBar, true)
        local customTex = LSM:Fetch("statusbar", state.customPowerBarTexture)
        PlayerFrameManaBar:GetStatusBarTexture():SetTexture(customTex)
        -- PlayerFrameManaBar:SetStatusBarColor(0.0, 1.0, 0.0, 1)
    end
end

function SubModuleMixin:SetPlayerBiggerHealthbar(bigger)
    local background = self.PlayerFrameBackground

    if not background then return end

    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'
    local base2 = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe2x'
    local tex2xBase = 'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe2x\\'

    if not PlayerFrameHealthBar.DFMask then
        local hpMask = PlayerFrameHealthBar:CreateMaskTexture()

        PlayerFrameHealthBar:GetStatusBarTexture():AddMaskTexture(hpMask)
        PlayerFrameHealthBar.DFMask = hpMask

        function PlayerFrameHealthBar.DFMask:SetBigger(big)
            if big then
                hpMask:ClearAllPoints()
                hpMask:SetPoint('TOPLEFT', PlayerFrameHealthBar, 'TOPLEFT', -2, -0.5)
                hpMask:SetTexture(tex2xBase .. 'plunderstormplayerhealthbarmask2x', 'CLAMPTOBLACKADDITIVE',
                                  'CLAMPTOBLACKADDITIVE')
                hpMask:SetSize(128, 32)
            else
                hpMask:ClearAllPoints()
                hpMask:SetPoint('TOPLEFT', PlayerFrameHealthBar, 'TOPLEFT', -2, 6)
                hpMask:SetTexture(tex2xBase .. 'uiunitframeplayerhealthmask2x', 'CLAMPTOBLACKADDITIVE',
                                  'CLAMPTOBLACKADDITIVE')
                hpMask:SetSize(128, 32)
            end
        end
    end

    if not PlayerFrameManaBar.DFMask then
        local manaMask = PlayerFrameManaBar:CreateMaskTexture()
        manaMask:ClearAllPoints()
        manaMask:SetPoint('TOPLEFT', PlayerFrameManaBar, 'TOPLEFT', -2, 2)
        manaMask:SetTexture(tex2xBase .. 'uiunitframeplayermanamask2x', 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
        -- hpMask:SetTexCoord(0, 1, 0, 1)
        manaMask:SetSize(128, 16)
        PlayerFrameManaBar:GetStatusBarTexture():AddMaskTexture(manaMask)
        PlayerFrameManaBar.DFMask = manaMask
    end

    if bigger then
        background:SetTexture(tex2xBase .. 'plunderstorm-ui-hud-unitframe-player-portraiton-2x')
        background:SetTexCoord(0, 396 / 512, 0, 142 / 256)
        background:SetSize(198, 71)
        background:SetPoint('CENTER', PlayerFrame, 'CENTER', 16, 6.05)

        PlayerStatusTexture:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\plunderstorm-UI-HUD-UnitFrame-Player-PortraitOn-InCombat')
        PlayerStatusTexture:SetSize(192, 71)
        PlayerStatusTexture:SetTexCoord(0, 192 / 256, 0, 71 / 128)

        PlayerFrameHealthBar:SetSize(124, 32)
        PlayerFrameHealthBar:ClearAllPoints()
        PlayerFrameHealthBar:SetPoint('CENTER', PlayerFrame, 'CENTER', 46.95, 0)
        PlayerFrameHealthBar.DFMask:SetBigger(true)

        PlayerFrameManaBar:SetAlpha(0)
        PlayerFrameManaBarText:SetAlpha(0)
        PlayerFrameManaBarTextLeft:SetAlpha(0)
        PlayerFrameManaBarTextRight:SetAlpha(0)
    else
        background:SetTexture(tex2xBase .. 'ui-hud-unitframe-player-portraiton-2x')
        background:SetTexCoord(0, 396 / 512, 0, 142 / 256)

        background:SetSize(198, 71)
        background:ClearAllPoints()
        background:SetPoint('CENTER', PlayerFrame, 'CENTER', 16, 6.05)

        -- ["UI-HUD-UnitFrame-Player-PortraitOn-Status"]={196, 71, 0.194824, 0.38623, 0.166992, 0.305664, false, false, "2x"},
        PlayerStatusTexture:SetTexture(tex2xBase .. 'UI-HUD-UnitFrame-Player-PortraitOn-Status')
        PlayerStatusTexture:SetSize(196, 71)
        PlayerStatusTexture:SetTexCoord(0, 392 / 512, 0, 142 / 256)
        PlayerStatusTexture:ClearAllPoints()
        PlayerStatusTexture:SetPoint('CENTER', PlayerFrame, 'CENTER', 16 - 1, 6.05 + 1)

        PlayerFrameHealthBar:SetSize(124, 20)
        PlayerFrameHealthBar:ClearAllPoints()
        PlayerFrameHealthBar:SetPoint('CENTER', PlayerFrame, 'CENTER', 46.95, 5.5)
        PlayerFrameHealthBar.DFMask:SetBigger(false)

        PlayerFrameManaBar:SetSize(124, 10.5)
        PlayerFrameManaBar:ClearAllPoints()
        PlayerFrameManaBar:SetPoint('CENTER', PlayerFrame, 'CENTER', 46.95, -10)

        PlayerFrameManaBar:SetAlpha(1)
        PlayerFrameManaBarText:SetAlpha(1)
        PlayerFrameManaBarTextLeft:SetAlpha(1)
        PlayerFrameManaBarTextRight:SetAlpha(1)
    end
end

function SubModuleMixin:AddAlternatePowerBar()
    local localizedClass, englishClass, classIndex = UnitClass('player');
    if not englishClass == 'DRUID' then return; end

    local bar = CreateFrame('StatusBar', 'DragonflightUIAlternatePowerBar', PlayerFrame, 'TextStatusBar');
    bar:SetSize(78, 12);
    bar:SetPoint('BOTTOMLEFT', 114 + 6, 23 - 1);
    bar:SetStatusBarTexture('Interface\\TargetingFrame\\UI-StatusBar');
    bar:SetStatusBarColor(0, 0, 1.0);
    self.AlternatePowerBar = bar;

    local bg = bar:CreateTexture('DragonflightUIAlternatePowerBarBackground', 'BACKGROUND');
    bg:SetSize(78, 12);
    bg:SetPoint('TOPLEFT', 0, 0);
    bg:SetColorTexture(0, 0, 0, 0.5);

    local border = bar:CreateTexture('DragonflightUIAlternatePowerBarBorder', 'OVERLAY');
    border:SetSize(97, 16);
    border:SetPoint('TOPLEFT', -10, 0);
    border:SetTexture('Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator');
    border:SetTexCoord(0.0234375, 0.6875, 1.0, 0);

    local text = bar:CreateFontString('DragonflightUIAlternatePowerBarText', 'OVERLAY', 'TextStatusBarText');
    text:SetPoint('CENTER', 0, 0);
    bar.TextString = text

    local textLeft = bar:CreateFontString('DragonflightUIAlternatePowerBarTextLeft', 'OVERLAY', 'TextStatusBarText');
    textLeft:SetPoint('LEFT', 0, 0);
    bar.LeftText = textLeft

    local textRight = bar:CreateFontString('DragonflightUIAlternatePowerBarText', 'OVERLAY', 'TextStatusBarText');
    textRight:SetPoint('RIGHT', 0, 0);
    bar.RightText = textRight

    --
    local ADDITIONAL_POWER_BAR_NAME = "MANA";
    local ADDITIONAL_POWER_BAR_INDEX = 0;

    local function AlternatePowerBar_Initialize(self)
        if (not self.powerName) then
            self.powerName = ADDITIONAL_POWER_BAR_NAME;
            self.powerIndex = ADDITIONAL_POWER_BAR_INDEX;
        end

        self:RegisterEvent("UNIT_POWER_UPDATE"); -- "UNIT_"..self.powerName
        self:RegisterEvent("UNIT_MAXPOWER"); -- "UNIT_MAX"..self.powerName
        self:RegisterEvent("PLAYER_ENTERING_WORLD");
        self:RegisterEvent("UNIT_DISPLAYPOWER");

        SetTextStatusBarText(self, _G[self:GetName() .. "Text"])

        local info = PowerBarColor[self.powerName];
        self:SetStatusBarColor(info.r, info.g, info.b);
    end

    local function AlternatePowerBar_OnLoad(self)
        self.textLockable = 1;
        self.cvar = "StatusText"; -- DF
        self.cvarLabel = "STATUS_TEXT_PLAYER";
        self.capNumericDisplay = true -- DF
        AlternatePowerBar_Initialize(self);
        TextStatusBar_Initialize(self);
    end

    local function AlternatePowerBar_UpdateValue(self)
        local currmana = UnitPower(self:GetParent().unit, self.powerIndex);
        self:SetValue(currmana);
        self.value = currmana
    end

    local function AlternatePowerBar_UpdateMaxValues(self)
        local maxmana = UnitPowerMax(self:GetParent().unit, self.powerIndex);
        self:SetMinMaxValues(0, maxmana);
    end

    local function AlternatePowerBar_UpdatePowerType(self)
        if ((UnitPowerType(self:GetParent().unit) ~= self.powerIndex) and
            (UnitPowerMax(self:GetParent().unit, self.powerIndex) ~= 0)) then
            self.pauseUpdates = false;
            self:Show();
        else
            self.pauseUpdates = true;
            self:Hide();
        end
    end

    local function AlternatePowerBar_OnEvent(self, event, arg1)
        local parent = self:GetParent();
        if (event == "UNIT_DISPLAYPOWER") then
            AlternatePowerBar_UpdatePowerType(self);
        elseif (event == "PLAYER_ENTERING_WORLD") then
            AlternatePowerBar_UpdateMaxValues(self);
            AlternatePowerBar_UpdateValue(self);
            AlternatePowerBar_UpdatePowerType(self);
        elseif ((event == "UNIT_MAXPOWER")) then
            if arg1 == parent.unit then AlternatePowerBar_UpdateMaxValues(self); end
        elseif (self:IsShown()) then
            if ((event == "UNIT_MANA") and (arg1 == parent.unit)) then AlternatePowerBar_UpdateValue(self); end
        end
    end

    local function AlternatePowerBar_OnUpdate(self, elapsed)
        AlternatePowerBar_UpdateValue(self);
    end

    -- 
    AlternatePowerBar_OnLoad(bar)
    TextStatusBar_Initialize(bar)

    bar:SetScript('OnEvent', function(self, event, ...)
        -- 
        AlternatePowerBar_OnEvent(self, event, ...);
        TextStatusBar_OnEvent(self, event, ...);
    end)
    bar:SetScript('OnUpdate', function(self, elapsed)
        -- 
        AlternatePowerBar_OnUpdate(self, elapsed);
    end)
    -- bar:SetScript('OnMouseUp', function() end)
end

function SubModuleMixin:HideAlternatePowerBar(hide)
    if not self.AlternatePowerBar then return end

    if hide then
        self.AlternatePowerBar:ClearAllPoints()
        self.AlternatePowerBar:SetPoint('BOTTOM', UIParent, 'TOP', 0, 500);
    else
        self.AlternatePowerBar:ClearAllPoints()
        self.AlternatePowerBar:SetPoint('BOTTOMLEFT', PlayerFrame, 'BOTTOMLEFT', 114 + 6, 23 - 1);
    end
end

