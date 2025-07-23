local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

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
        biggerHealthbar = false,
        portraitExtra = 'none',
        hideRedStatus = false,
        hideIndicator = false,
        hideSecondaryRes = false,
        hideAlternatePowerBar = false,
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
            }
        }
    }

    if DF.Cata then
        optionsPlayer.args['hideSecondaryRes'] = {
            type = 'toggle',
            name = L["PlayerFrameHideSecondaryRes"],
            desc = L["PlayerFrameHideSecondaryResDesc"] .. getDefaultStr('hideSecondaryRes', 'player'),
            group = 'headerStyling',
            order = 12,
            new = false,
            editmode = true
        }
    end
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
        Module:SetDefaultSubValues(sub)
    end

    DF.ConfigModule:RegisterSettingsData('player', 'unitframes', {
        options = self.Options,
        default = function()
            setDefaultSubValues('player')
        end
    })
end

function SubModuleMixin:OnEvent(event, ...)
end

function SubModuleMixin:UpdateState(state)
    self.state = state;
    self:Update();
end

function SubModuleMixin:Update()
    local state = self.state;
    if not state then return end
end

-- function Module.CreateRestFlipbook()
--     if not frame.RestIcon then
--         local rest = CreateFrame('Frame', 'DragonflightUIRestFlipbook', PlayerFrame)
--         rest:SetSize(20, 20)
--         rest:SetPoint('CENTER', PlayerPortrait, 'TOPRIGHT', -4, 4)
--         ---@diagnostic disable-next-line: redundant-parameter
--         rest:SetFrameStrata('MEDIUM', 5)
--         rest:SetScale(1.2)

--         local restTexture = rest:CreateTexture('DragonflightUIRestFlipbookTexture')
--         restTexture:SetAllPoints()
--         restTexture:SetColorTexture(1, 1, 1, 1)
--         restTexture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiunitframerestingflipbook')
--         restTexture:SetTexCoord(0, 7 / 8, 0, 7 / 8)

--         local animationGroup = restTexture:CreateAnimationGroup()
--         local animation = animationGroup:CreateAnimation('Flipbook', 'RestFlipbookAnimation')

--         animationGroup:SetLooping('REPEAT')
--         local size = 60
--         animation:SetFlipBookFrameWidth(size)
--         animation:SetFlipBookFrameHeight(size)
--         animation:SetFlipBookRows(7)
--         animation:SetFlipBookColumns(6)
--         animation:SetFlipBookFrames(42)
--         animation:SetDuration(1.5)

--         frame.RestIcon = rest
--         frame.RestIconAnimation = animationGroup

--         PlayerFrame_UpdateStatus()
--     end
-- end

-- function Module.HookRestFunctions()
--     hooksecurefunc(PlayerStatusGlow, 'Show', function()
--         PlayerStatusGlow:Hide()
--     end)

--     hooksecurefunc(PlayerRestIcon, 'Show', function()
--         PlayerRestIcon:Hide()
--     end)

--     hooksecurefunc(PlayerRestGlow, 'Show', function()
--         PlayerRestGlow:Hide()
--     end)

--     hooksecurefunc('SetUIVisibility', function(visible)
--         if visible then
--             PlayerFrame_UpdateStatus()
--         else
--             frame.RestIcon:Hide()
--             frame.RestIconAnimation:Stop()
--         end
--     end)
-- end

-- function Module.CreatePlayerFrameTextures()
--     local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

--     if not frame.PlayerFrameBackground then
--         local background = PlayerFrame:CreateTexture('DragonflightUIPlayerFrameBackground')
--         background:SetDrawLayer('BACKGROUND', 2)
--         background:SetTexture(
--             'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Player-PortraitOn-BACKGROUND')
--         background:SetPoint('LEFT', PlayerFrameHealthBar, 'LEFT', -67, -28.5)

--         background:SetTexture(base)
--         background:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-PortraitOn'))
--         background:SetSize(198, 71)
--         background:SetPoint('LEFT', PlayerFrameHealthBar, 'LEFT', -67, 0)
--         frame.PlayerFrameBackground = background
--     end

--     if not frame.PlayerFrameBorder then
--         local border = PlayerFrameHealthBar:CreateTexture('DragonflightUIPlayerFrameBorder')
--         border:SetDrawLayer('ARTWORK', 2)
--         border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Player-PortraitOn-BORDER')
--         border:SetPoint('LEFT', PlayerFrameHealthBar, 'LEFT', -67, -28.5)
--         frame.PlayerFrameBorder = border
--     end

--     if not frame.PlayerFrameDeco then
--         local textureSmall = PlayerFrame:CreateTexture('DragonflightUIPlayerFrameDeco')
--         textureSmall:SetDrawLayer('OVERLAY', 5)
--         textureSmall:SetTexture(base)
--         textureSmall:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-PortraitOn-CornerEmbellishment'))
--         local delta = 15
--         textureSmall:SetPoint('CENTER', PlayerPortrait, 'CENTER', delta, -delta - 2)
--         textureSmall:SetSize(23, 23)
--         textureSmall:SetScale(1)
--         frame.PlayerFrameDeco = textureSmall
--     end
-- end

-- function Module:CreatePlayerFrameExtra()

--     local textureFrame = CreateFrame('Frame', 'DragonflightUIPlayerFrameTextureFrame', PlayerFrame)
--     textureFrame:SetPoint('TOPLEFT')
--     textureFrame:SetPoint('BOTTOMRIGHT')
--     textureFrame:SetFrameLevel(3)
--     PlayerFrame.DFTextureFrame = textureFrame

--     local extra = textureFrame:CreateTexture('DragonflightUIPlayerFramePortraitExtra')
--     extra:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiunitframeboss2x')
--     -- extra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
--     extra:SetTexCoord(0.314453125, 0.001953125, 0.322265625, 0.630859375)
--     extra:SetSize(80, 79)
--     extra:SetDrawLayer('ARTWORK', 7)
--     extra:SetPoint('CENTER', PlayerPortrait, 'CENTER', -4, 1)
--     frame.PlayerPortraitExtra = extra

--     function extra:UpdateStyle(class)
--         -- local class = UnitClassification('target')
--         --[[ "worldboss", "rareelite", "elite", "rare", "normal", "trivial" or "minus" ]]
--         extra:ClearAllPoints()
--         if class == 'worldboss' then
--             extra:Show()
--             extra:SetSize(99 - 2, 81 - 2)
--             extra:SetTexCoord(0.388671875, 0.001953125, 0.001953125, 0.31835937)
--             extra:SetPoint('CENTER', PlayerPortrait, 'CENTER', -13, 1 + 2)
--         elseif class == 'rareelite' or class == 'rare' then
--             extra:Show()
--             extra:SetSize(80 - 2, 79 - 2)
--             extra:SetTexCoord(0.31640625, 0.00390625, 0.634765625, 0.943359375)
--             extra:SetPoint('CENTER', PlayerPortrait, 'CENTER', -4, 1 + 2)
--         elseif class == 'elite' then
--             extra:Show()
--             extra:SetTexCoord(0.314453125, 0.001953125, 0.322265625, 0.630859375)
--             extra:SetSize(80 - 2, 79 - 2)
--             extra:SetPoint('CENTER', PlayerPortrait, 'CENTER', -4, 1 + 2)
--         else
--             extra:Hide()
--         end
--     end

--     extra:UpdateStyle('none')
-- end

-- function Module:HideSecondaryRes(hide)
--     if not Module.SecondaryResToHide then return end

--     local _, class = UnitClass('player');

--     if class == 'WARLOCK' then
--         if DF.API.Version.IsCata then
--             _G['ShardBarFrame']:SetShown(not hide);
--         else
--             -- MoP onwards; 
--             local spec = C_SpecializationInfo.GetSpecialization()

--             if spec == SPEC_WARLOCK_AFFLICTION then
--                 _G['ShardBarFrame']:SetShown(not hide);
--                 _G['BurningEmbersBarFrame']:SetShown(false);
--                 _G['DemonicFuryBarFrame']:SetShown(false);
--             elseif spec == SPEC_WARLOCK_DESTRUCTION then
--                 _G['ShardBarFrame']:SetShown(false);
--                 _G['BurningEmbersBarFrame']:SetShown(not hide);
--                 _G['DemonicFuryBarFrame']:SetShown(false);
--             else
--                 _G['ShardBarFrame']:SetShown(false);
--                 _G['BurningEmbersBarFrame']:SetShown(false);
--                 _G['DemonicFuryBarFrame']:SetShown(not hide);
--             end
--         end
--     elseif class == 'DRUID' then
--         if hide then
--             _G['EclipseBarFrame']:Hide()
--         else
--             if DF.API.Version.IsMoP then
--                 _G['EclipseBarFrame']:UpdateShown()
--             else
--                 EclipseBar_UpdateShown(_G['EclipseBarFrame'])
--             end
--         end
--     elseif class == 'PALADIN' then
--         _G['PaladinPowerBar']:SetShown(not hide);
--     elseif class == 'DEATHKNIGHT' then
--         _G['RuneFrame']:SetShown(not hide);
--     elseif class == 'MONK' then
--         _G['MonkHarmonyBar']:SetShown(not hide)
--         _G['MonkStaggerBar']:SetShown(not hide)
--     end
-- end

-- function Module:HookSecondaryRes()
--     local _, class = UnitClass('player');

--     if class == 'WARLOCK' then
--         Module.SecondaryResToHide = _G['ShardBarFrame'];
--     elseif class == 'DRUID' then
--         Module.SecondaryResToHide = _G['EclipseBarFrame'];
--     elseif class == 'PALADIN' then
--         Module.SecondaryResToHide = _G['PaladinPowerBar'];
--     elseif class == 'DEATHKNIGHT' then
--         Module.SecondaryResToHide = _G['RuneFrame'];
--     elseif class == 'MONK' then
--         Module.SecondaryResToHide = _G['MonkHarmonyBar'];
--     end

--     if not Module.SecondaryResToHide then return end

--     if Module.SecondaryResToHide == _G['ShardBarFrame'] and not DF.API.Version.IsCata then
--         -- warlock MoP onwards
--         frame:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')

--         local t = {_G['ShardBarFrame'], _G['BurningEmbersBarFrame'], _G['DemonicFuryBarFrame']}

--         for k, v in ipairs(t) do
--             v:HookScript('OnShow', function()
--                 --
--                 -- print('onshow')
--                 if Module.db.profile.player.hideSecondaryRes then v:Hide() end
--             end)
--         end
--     else
--         Module.SecondaryResToHide:HookScript('OnShow', function()
--             --
--             -- print('onshow')
--             if Module.db.profile.player.hideSecondaryRes then Module.SecondaryResToHide:Hide() end
--         end)
--     end
-- end

-- function Module.ChangeStatusIcons()
--     local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

--     PlayerAttackIcon:SetTexture(base)
--     PlayerAttackIcon:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-CombatIcon'))
--     PlayerAttackIcon:ClearAllPoints()
--     PlayerAttackIcon:SetPoint('BOTTOMRIGHT', PlayerPortrait, 'BOTTOMRIGHT', -3, 0)
--     PlayerAttackIcon:SetSize(16, 16)

--     PlayerAttackBackground:SetTexture(base)
--     PlayerAttackBackground:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-CombatIcon-Glow'))
--     PlayerAttackBackground:ClearAllPoints()
--     PlayerAttackBackground:SetPoint('CENTER', PlayerAttackIcon, 'CENTER')
--     PlayerAttackBackground:SetSize(32, 32)

--     PlayerFrameGroupIndicator:ClearAllPoints()
--     -- PlayerFrameGroupIndicator:SetPoint('BOTTOMRIGHT', PlayerFrameHealthBar, 'TOPRIGHT', 4, 13)
--     PlayerFrameGroupIndicator:SetPoint('BOTTOM', PlayerName, 'TOP', 0, 0)

--     PlayerLeaderIcon:SetTexture(base)
--     PlayerLeaderIcon:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-Group-LeaderIcon'))
--     -- PlayerLeaderIcon:ClearAllPoints()
--     -- PlayerLeaderIcon:SetPoint('BOTTOM', PlayerName, 'TOP', 0, 0)
--     PlayerLeaderIcon:ClearAllPoints()
--     PlayerLeaderIcon:SetPoint('BOTTOMRIGHT', PlayerPortrait, 'TOPLEFT', 10, -10)

--     TargetFrameTextureFrameLeaderIcon:SetTexture(base)
--     TargetFrameTextureFrameLeaderIcon:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-Group-LeaderIcon'))
--     TargetFrameTextureFrameLeaderIcon:ClearAllPoints()
--     TargetFrameTextureFrameLeaderIcon:SetPoint('BOTTOMLEFT', TargetFramePortrait, 'TOPRIGHT', -10 - 3, -10)
-- end

-- function Module.UpdatePlayerFrameHealthBar()
--     if Module.db.profile.player.classcolor then
--         PlayerFrameHealthBar:GetStatusBarTexture():SetTexture(
--             'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health-Status')

--         local localizedClass, englishClass, classIndex = UnitClass('player')
--         PlayerFrameHealthBar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
--     else
--         PlayerFrameHealthBar:GetStatusBarTexture():SetTexture(
--             'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health')
--         PlayerFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)
--     end
-- end
