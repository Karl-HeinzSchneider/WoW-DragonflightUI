local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local subModuleName = 'PetFrame';
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
        breakUpLargeNumbers = true,
        enableThreatGlow = true,
        scale = 1.0,
        override = false,
        anchorFrame = 'PlayerFrame',
        customAnchorFrame = '',
        anchor = 'TOPRIGHT',
        anchorParent = 'BOTTOMRIGHT',
        x = 4,
        y = 28,
        hideStatusbarText = false,
        offset = false,
        hideIndicator = false,
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

    local optionsPet = {
        name = L["PetFrameName"],
        desc = L["PetFrameDesc"],
        advancedName = 'PetFrame',
        sub = 'pet',
        get = getOption,
        set = setOption,
        type = 'group',
        args = {
            headerStyling = {
                type = 'header',
                name = L["PetFrameStyle"],
                desc = '',
                order = 20,
                isExpanded = true,
                editmode = true
            },
            breakUpLargeNumbers = {
                type = 'toggle',
                name = L["PetFrameBreakUpLargeNumbers"],
                desc = L["PetFrameBreakUpLargeNumbersDesc"] .. getDefaultStr('breakUpLargeNumbers', 'pet'),
                group = 'headerStyling',
                order = 9,
                editmode = true
            },
            enableThreatGlow = {
                type = 'toggle',
                name = L["PetFrameThreatGlow"],
                desc = L["PetFrameThreatGlowDesc"] .. getDefaultStr('enableThreatGlow', 'pet'),
                group = 'headerStyling',
                order = 8,
                disabled = true,
                editmode = true
            },
            hideStatusbarText = {
                type = 'toggle',
                name = L["PetFrameHideStatusbarText"],
                desc = L["PetFrameHideStatusbarTextDesc"] .. getDefaultStr('hideStatusbarText', 'pet'),
                group = 'headerStyling',
                order = 10,
                editmode = true
            },
            hideIndicator = {
                type = 'toggle',
                name = L["PetFrameHideIndicator"],
                desc = L["PetFrameHideIndicatorDesc"] .. getDefaultStr('hideIndicator', 'pet'),
                group = 'headerStyling',
                order = 11,
                new = false,
                editmode = true
            }
        }
    }

    if DF.Cata then
        local moreOptions = {
            offset = {
                type = 'toggle',
                name = 'Auto adjust offset',
                desc = 'Auto add some Y offset depending on the class, e.g. on Deathknight to make room for the rune display' ..
                    getDefaultStr('offset', 'pet'),
                group = 'headerStyling',
                order = 11,
                new = false
            }
        }

        for k, v in pairs(moreOptions) do optionsPet.args[k] = v end
    end
    DF.Settings:AddPositionTable(Module, optionsPet, 'pet', 'Pet', getDefaultStr, frameTableWithout('PetFrame'))

    DragonflightUIStateHandlerMixin:AddStateTable(Module, optionsPet, 'pet', 'Pet', getDefaultStr)
    local optionsPetEditmode = {
        name = 'Pet',
        desc = 'Pet',
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
                    local dbTable = Module.db.profile.pet
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

    self.Options = optionsPet;
    self.OptionsEditmode = optionsPetEditmode;
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
