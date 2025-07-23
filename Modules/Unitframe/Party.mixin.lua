local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local subModuleName = 'Party';
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
        breakUpLargeNumbers = true,
        scale = 1.0,
        override = false,
        anchorFrame = 'CompactRaidFrameManager',
        customAnchorFrame = '',
        anchor = 'TOPLEFT',
        anchorParent = 'TOPRIGHT',
        x = 0,
        y = 0,
        padding = 10,
        orientation = 'vertical',
        disableBuffTooltip = 'INCOMBAT',
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

    local optionsParty = {
        name = L["PartyFrameName"],
        desc = L["PartyFrameDesc"],
        advancedName = 'PartyFrame',
        sub = 'party',
        get = getOption,
        set = setOption,
        type = 'group',
        args = {
            headerStyling = {
                type = 'header',
                name = L["PartyFrameStyle"],
                desc = '',
                order = 20,
                isExpanded = true,
                editmode = true
            },
            classcolor = {
                type = 'toggle',
                name = L["PartyFrameClassColor"],
                desc = L["PartyFrameClassColorDesc"] .. getDefaultStr('classcolor', 'party'),
                group = 'headerStyling',
                order = 7,
                editmode = true
            },
            breakUpLargeNumbers = {
                type = 'toggle',
                name = L["PartyFrameBreakUpLargeNumbers"],
                desc = L["PartyFrameBreakUpLargeNumbersDesc"] .. getDefaultStr('breakUpLargeNumbers', 'party'),
                group = 'headerStyling',
                order = 8,
                editmode = true
            }
        }
    }

    if true then
        local moreOptions = {
            useCompactPartyFrames = {
                type = 'toggle',
                name = USE_RAID_STYLE_PARTY_FRAMES,
                desc = OPTION_TOOLTIP_USE_RAID_STYLE_PARTY_FRAMES,
                group = 'headerStyling',
                order = 15,
                blizzard = true,
                editmode = true
            },
            raidFrameBtn = {
                type = 'execute',
                name = 'Raid Frame Settings',
                btnName = 'Open',
                func = function()
                    Settings.OpenToCategory(Settings.INTERFACE_CATEGORY_ID, RAID_FRAMES_LABEL);
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
                end,
                group = 'headerStyling',
                order = 16,
                blizzard = true,
                editmode = true
            },
            orientation = {
                type = 'select',
                name = L["ButtonTableOrientation"],
                desc = L["ButtonTableOrientationDesc"] .. getDefaultStr('orientation', 'party'),
                dropdownValues = DF.Settings.OrientationTable,
                order = 2,
                group = 'headerStyling',
                editmode = true
            },
            disableBuffTooltip = {
                type = 'select',
                name = L["PartyFrameDisableBuffTooltip"],
                desc = L["PartyFrameDisableBuffTooltipDesc"] .. getDefaultStr('disableBuffTooltip', 'party'),
                dropdownValues = partyBuffTooltipTable,
                order = 3,
                group = 'headerStyling',
                editmode = true,
                new = true
            },
            padding = {
                type = 'range',
                name = L["ButtonTablePadding"],
                desc = L["ButtonTablePaddingDesc"] .. getDefaultStr('padding', 'party'),
                min = -50,
                max = 50,
                bigStep = 1,
                order = 3,
                group = 'headerStyling',
                editmode = true
            }
        }

        for k, v in pairs(moreOptions) do optionsParty.args[k] = v end

        optionsParty.get = function(info)
            local key = info[1]
            local sub = info[2]

            if sub == 'useCompactPartyFrames' then
                local value = C_CVar.GetCVar("useCompactPartyFrames");
                if value == '1' then
                    return true
                else
                    return false
                end
            else
                return getOption(info)
            end
        end

        optionsParty.set = function(info, value)
            local key = info[1]
            local sub = info[2]

            if sub == 'useCompactPartyFrames' then
                if value then
                    SetCVar("useCompactPartyFrames", "1");
                else
                    SetCVar("useCompactPartyFrames", "0");
                end
            else
                setOption(info, value)
            end
        end
    end
    DF.Settings:AddPositionTable(Module, optionsParty, 'party', 'Party', getDefaultStr, frameTable)

    DragonflightUIStateHandlerMixin:AddStateTable(Module, optionsParty, 'party', 'Party', getDefaultStr)
    local optionsPartyEditmode = {
        name = 'party',
        desc = 'party',
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
                    local dbTable = Module.db.profile.party
                    local defaultsTable = self.Defaults
                    -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                    setPreset(dbTable, {
                        scale = defaultsTable.scale,
                        anchor = defaultsTable.anchor,
                        anchorParent = defaultsTable.anchorParent,
                        anchorFrame = defaultsTable.anchorFrame,
                        x = defaultsTable.x,
                        y = defaultsTable.y,
                        orientation = defaultsTable.orientation,
                        padding = defaultsTable.padding
                    })
                end,
                order = 16,
                editmode = true,
                new = false
            }
        }
    }

    self.Options = optionsParty;
    self.OptionsEditmode = optionsPartyEditmode;
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
