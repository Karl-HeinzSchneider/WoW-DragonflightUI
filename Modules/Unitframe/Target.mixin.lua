local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local subModuleName = 'Target';
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
