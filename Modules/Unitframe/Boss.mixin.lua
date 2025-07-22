local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local subModuleName = 'BossFrame';
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
