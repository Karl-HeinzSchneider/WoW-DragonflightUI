local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local subModuleName = 'RaidFrame';
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
        -- breakUpLargeNumbers = true,
        -- enableThreatGlow = true,
        -- scale = 1.0,
        -- override = false,
        -- anchorFrame = 'PlayerFrame',
        -- customAnchorFrame = '',
        -- anchor = 'TOPRIGHT',
        -- anchorParent = 'BOTTOMRIGHT',
        -- x = 4,
        -- y = 28,
        -- hideStatusbarText = false,
        -- offset = false,
        -- hideIndicator = false,
        -- -- Visibility
        -- showMouseover = false,
        -- hideAlways = false,
        -- hideCombat = false,
        -- hideOutOfCombat = false,
        -- hidePet = false,
        -- hideNoPet = false,
        -- hideStance = false,
        -- hideStealth = false,
        -- hideNoStealth = false,
        -- hideCustom = false,
        -- hideCustomCond = ''
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

    local optionsRaid = {
        name = L["RaidFrameName"],
        advancedName = 'RaidFrame',
        sub = 'raid',
        get = getOption,
        set = setOption,
        type = 'group',
        args = {
            -- scale = {
            --     type = 'range',
            --     name = 'Scale',
            --     desc = '' .. getDefaultStr('scale', 'party'),
            --     min = 0.1,
            --     max = 5,
            --     bigStep = 0.1,
            --     order = 1,
            --     editmode = true
            -- },
            -- anchorFrame = {
            --     type = 'select',
            --     name = 'Anchorframe',
            --     desc = 'Anchor' .. getDefaultStr('anchorFrame', 'party'),
            --     values = frameTable,
            --     order = 4,
            --     editmode = true
            -- },
            -- anchor = {
            --     type = 'select',
            --     name = 'Anchor',
            --     desc = 'Anchor' .. getDefaultStr('anchor', 'party'),
            --     values = {
            --         ['TOP'] = 'TOP',
            --         ['RIGHT'] = 'RIGHT',
            --         ['BOTTOM'] = 'BOTTOM',
            --         ['LEFT'] = 'LEFT',
            --         ['TOPRIGHT'] = 'TOPRIGHT',
            --         ['TOPLEFT'] = 'TOPLEFT',
            --         ['BOTTOMLEFT'] = 'BOTTOMLEFT',
            --         ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
            --         ['CENTER'] = 'CENTER'
            --     },
            --     order = 2,
            --     editmode = true
            -- },
            -- anchorParent = {
            --     type = 'select',
            --     name = 'AnchorParent',
            --     desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'party'),
            --     values = {
            --         ['TOP'] = 'TOP',
            --         ['RIGHT'] = 'RIGHT',
            --         ['BOTTOM'] = 'BOTTOM',
            --         ['LEFT'] = 'LEFT',
            --         ['TOPRIGHT'] = 'TOPRIGHT',
            --         ['TOPLEFT'] = 'TOPLEFT',
            --         ['BOTTOMLEFT'] = 'BOTTOMLEFT',
            --         ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
            --         ['CENTER'] = 'CENTER'
            --     },
            --     order = 3,
            --     editmode = true
            -- },
            -- x = {
            --     type = 'range',
            --     name = 'X',
            --     desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'party'),
            --     min = -2500,
            --     max = 2500,
            --     bigStep = 1,
            --     order = 5,
            --     editmode = true
            -- },
            -- y = {
            --     type = 'range',
            --     name = 'Y',
            --     desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'party'),
            --     min = -2500,
            --     max = 2500,
            --     bigStep = 1,
            --     order = 6,
            --     editmode = true
            -- }     
        }
    }
    if true then
        local moreOptions = {
            -- useCompactPartyFrames = {
            --     type = 'toggle',
            --     name = USE_RAID_STYLE_PARTY_FRAMES,
            --     desc = OPTION_TOOLTIP_USE_RAID_STYLE_PARTY_FRAMES,
            --     order = 15,
            --     blizzard = true,
            --     editmode = false
            -- },
            raidFrameBtn = {
                type = 'execute',
                name = 'Raid Frame Settings',
                btnName = 'Open',
                func = function()
                    Settings.OpenToCategory(Settings.INTERFACE_CATEGORY_ID, RAID_FRAMES_LABEL);
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
                end,
                order = 5,
                blizzard = true,
                editmode = false
            },
            headerTaint = {
                type = 'header',
                name = 'Use the blizzard settings, as setting them through addons taints the UI.',
                desc = '',
                order = 1,
                editmode = false
            }
            -- headerTaint = {type = 'header', name = 'May Cause Taint Issues - /reload after setup', desc = '', order = 10},
            -- keepGroupsTogether = {
            --     type = 'toggle',
            --     name = COMPACT_UNIT_FRAME_PROFILE_KEEPGROUPSTOGETHER,
            --     desc = OPTION_TOOLTIP_KEEP_GROUPS_TOGETHER,
            --     proxy = 'PROXY_RAID_FRAME_KEEP_GROUPS_TOGETHER',
            --     order = 20.1,
            --     blizzard = true,
            --     editmode = true
            -- },
            -- horizontalGroups = {
            --     type = 'toggle',
            --     name = COMPACT_UNIT_FRAME_PROFILE_HORIZONTALGROUPS,
            --     desc = '',
            --     proxy = 'PROXY_RAID_FRAME_KEEP_HORIZONTAL_GROUPS',
            --     order = 20.2,
            --     blizzard = true,
            --     editmode = true
            -- },
            -- sortBy = {
            --     type = 'select',
            --     name = COMPACT_UNIT_FRAME_PROFILE_SORTBY,
            --     desc = '',
            --     values = {['role'] = 'role', ['group'] = 'group', ['alphabetical'] = 'alphabetical'},
            --     proxy = 'PROXY_RAID_FRAME_SORT_BY',
            --     order = 20.21,
            --     blizzard = true,
            --     editmode = true
            -- },
            -- displayPowerBar = {
            --     type = 'toggle',
            --     name = COMPACT_UNIT_FRAME_PROFILE_DISPLAYPOWERBAR,
            --     desc = OPTION_TOOLTIP_COMPACT_UNIT_FRAME_PROFILE_DISPLAYPOWERBAR,
            --     proxy = 'PROXY_RAID_FRAME_POWER_BAR',
            --     order = 20.3,
            --     blizzard = true,
            --     editmode = true
            -- },
            -- useClassColors = {
            --     type = 'toggle',
            --     name = COMPACT_UNIT_FRAME_PROFILE_USECLASSCOLORS,
            --     desc = OPTION_TOOLTIP_COMPACT_UNIT_FRAME_PROFILE_USECLASSCOLORS,
            --     proxy = 'PROXY_RAID_FRAME_CLASS_COLORS',
            --     order = 20.4,
            --     blizzard = true,
            --     editmode = true
            -- },
            -- displayPets = {
            --     type = 'toggle',
            --     name = COMPACT_UNIT_FRAME_PROFILE_DISPLAYPETS,
            --     desc = OPTION_TOOLTIP_COMPACT_UNIT_FRAME_PROFILE_DISPLAYPETS,
            --     proxy = 'PROXY_RAID_FRAME_PETS',
            --     order = 20.5,
            --     blizzard = true,
            --     editmode = true
            -- },
            -- displayMainTankAndAssist = {
            --     type = 'toggle',
            --     name = COMPACT_UNIT_FRAME_PROFILE_DISPLAYMAINTANKANDASSIST,
            --     desc = OPTION_TOOLTIP_COMPACT_UNIT_FRAME_PROFILE_DISPLAYMAINTANKANDASSIST,
            --     proxy = 'PROXY_RAID_FRAME_TANK_ASSIST',
            --     order = 20.6,
            --     blizzard = true,
            --     editmode = true
            -- },
            -- displayBorder = {
            --     type = 'toggle',
            --     name = COMPACT_UNIT_FRAME_PROFILE_DISPLAYBORDER,
            --     desc = '',
            --     proxy = 'PROXY_RAID_FRAME_BORDER',
            --     order = 20.7,
            --     blizzard = true,
            --     editmode = true
            -- },
            -- displayNonBossDebuffs = {
            --     type = 'toggle',
            --     name = COMPACT_UNIT_FRAME_PROFILE_DISPLAYNONBOSSDEBUFFS,
            --     desc = OPTION_TOOLTIP_COMPACT_UNIT_FRAME_PROFILE_DISPLAYNONBOSSDEBUFFS,
            --     proxy = 'PROXY_RAID_FRAME_SHOW_DEBUFFS',
            --     order = 20.8,
            --     blizzard = true,
            --     editmode = true
            -- },
            -- displayOnlyDispellableDebuffs = {
            --     type = 'toggle',
            --     name = DISPLAY_ONLY_DISPELLABLE_DEBUFFS,
            --     desc = OPTION_TOOLTIP_COMPACT_UNIT_FRAME_PROFILE_DISPLAYONLYDISPELLABLEDEBUFFS,
            --     proxy = 'PROXY_RAID_FRAME_DISPELLABLE_DEBUFFS',
            --     order = 21.1,
            --     blizzard = true,
            --     editmode = true
            -- },
            -- healthText = {
            --     type = 'select',
            --     name = COMPACT_UNIT_FRAME_PROFILE_HEALTHTEXT,
            --     desc = OPTION_TOOLTIP_COMPACT_UNIT_FRAME_PROFILE_HEALTHTEXT,
            --     values = {['none'] = 'none', ['health'] = 'health', ['losthealth'] = 'losthealth', ['perc'] = 'perc'},
            --     proxy = 'PROXY_RAID_HEALTH_TEXT',
            --     order = 21.2,
            --     blizzard = true,
            --     editmode = true
            -- },
            -- frameHeight = {
            --     type = 'range',
            --     name = COMPACT_UNIT_FRAME_PROFILE_FRAMEHEIGHT,
            --     desc = '',
            --     proxy = 'PROXY_RAID_FRAME_HEIGHT',
            --     min = 20,
            --     max = 128,
            --     bigStep = 1,
            --     order = 22.1,
            --     editmode = true,
            --     blizzard = true
            -- },
            -- frameWidth = {
            --     type = 'range',
            --     name = COMPACT_UNIT_FRAME_PROFILE_FRAMEWIDTH,
            --     desc = '',
            --     proxy = 'PROXY_RAID_FRAME_WIDTH',
            --     min = 20,
            --     max = 256,
            --     bigStep = 1,
            --     order = 22.2,
            --     editmode = true,
            --     blizzard = true
            -- }
        }

        for k, v in pairs(moreOptions) do optionsRaid.args[k] = v end

        local defaultFuncs = {}

        -- Proxy
        -- RevertSetting("PROXY_RAID_FRAME_CLASS_COLORS");
        -- RevertSetting("PROXY_RAID_FRAME_PETS");
        -- RevertSetting("PROXY_RAID_FRAME_TANK_ASSIST");
        -- RevertSetting("PROXY_RAID_FRAME_BORDER");
        -- RevertSetting("PROXY_RAID_FRAME_SHOW_DEBUFFS");
        -- RevertSetting("PROXY_RAID_FRAME_KEEP_GROUPS_TOGETHER");
        -- RevertSetting("PROXY_RAID_FRAME_KEEP_HORIZONTAL_GROUPS");
        -- RevertSetting("PROXY_RAID_FRAME_SORT_BY");
        -- RevertSetting("PROXY_RAID_FRAME_POWER_BAR");
        -- RevertSetting("PROXY_RAID_FRAME_DISPELLABLE_DEBUFFS");
        -- RevertSetting("PROXY_RAID_HEALTH_TEXT");
        -- RevertSetting("PROXY_RAID_FRAME_HEIGHT");
        -- RevertSetting("PROXY_RAID_FRAME_WIDTH");
        -- RevertSetting("PROXY_RAID_AUTO_ACTIVATE");
        -- RevertSetting("PROXY_RAID_AUTO_ACTIVATE_2");
        -- RevertSetting("PROXY_RAID_AUTO_ACTIVATE_3");
        -- RevertSetting("PROXY_RAID_AUTO_ACTIVATE_5");
        -- RevertSetting("PROXY_RAID_AUTO_ACTIVATE_10");
        -- RevertSetting("PROXY_RAID_AUTO_ACTIVATE_15");
        -- RevertSetting("PROXY_RAID_AUTO_ACTIVATE_20");
        -- RevertSetting("PROXY_RAID_AUTO_ACTIVATE_40");

        optionsRaid.get = function(info)
            local key = info[1]
            local sub = info[2]

            if sub == 'useCompactPartyFrames' then
                local value = C_CVar.GetCVar("useCompactPartyFrames");
                if value == '1' then
                    return true
                else
                    return false
                end
            end

            if moreOptions[sub].proxy then
                -- proxy
                local value = Settings.GetValue(moreOptions[sub].proxy);
                return value;
            end
        end

        optionsRaid.set = function(info, value)
            local key = info[1]
            local sub = info[2]

            if sub == 'useCompactPartyFrames' then
                if value then
                    SetCVar("useCompactPartyFrames", "1");
                else
                    SetCVar("useCompactPartyFrames", "0");
                end
            end

            if moreOptions[sub].proxy then
                -- proxy
                Settings.SetValue(moreOptions[sub].proxy, value);
                -- InterfaceOverrides.SetRaidProfileOption(sub, value);
                -- local isSecure, taint = issecurevariable('CompactRaidGroup1Member1')
                -- print('SECURE? ', isSecure, ', TAINT? ', taint)       
            end
        end
    end
    local optionsRaidEditmode = {
        name = 'Raid',
        desc = 'Raid',
        get = getOption,
        set = setOption,
        type = 'group',
        args = {
            raidFrameBtn = {
                type = 'execute',
                name = 'Raid Frame Settings',
                btnName = 'Open',
                func = function()
                    Settings.OpenToCategory(Settings.INTERFACE_CATEGORY_ID, RAID_FRAMES_LABEL);
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
                end,
                order = 5,
                blizzard = true,
                editmode = true
            }
        }
    }

    self.Options = optionsRaid;
    self.OptionsEditmode = optionsRaidEditmode;
end

function SubModuleMixin:Setup()
    local function setDefaultSubValues(sub)
        self.ModuleRef:SetDefaultSubValues(sub)
    end

    DF.ConfigModule:RegisterSettingsData('raid', 'unitframes', {
        options = self.Options
        -- default = function()
        --     setDefaultSubValues('raid')
        -- end
    })
    --
    self:AddRaidframeRoleIcons()

    -- edit mode
    local EditModeModule = DF:GetModule('Editmode');
    local initRaid = function()
        --         
        local f = _G['CompactRaidFrameManagerContainerResizeFrame']
        _G['CompactRaidFrameManagerContainerResizeFrameResizer']:SetFrameLevel(15)

        local fakeRaid = CreateFrame('Frame', 'DragonflightUIEditModeRaidFramePreview', f,
                                     'DFEditModePreviewRaidFrameTemplate')
        fakeRaid:OnLoad()
        fakeRaid:SetPoint('TOPLEFT', f, 'TOPLEFT', 4, -7)
        fakeRaid:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 0, 0)

        -- fakeRaid:ClearAllPoints()
        -- fakeRaid:SetPoint('TOPLEFT', UIParent, 'CENTER', -50, 50)
        -- fakeRaid:SetParent(UIParent)

        fakeRaid:Show()

        self.PreviewRaid = fakeRaid;

        EditModeModule:AddEditModeToFrame(f)

        f.DFEditModeSelection:SetGetLabelTextFunction(function()
            return self.Options.name
        end)

        f.DFEditModeSelection:ClearAllPoints()
        f.DFEditModeSelection:SetPoint('TOPLEFT', f, 'TOPLEFT', 0, -7)
        f.DFEditModeSelection:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 0, 11)

        f.DFEditModeSelection:RegisterOptions({
            options = self.Options,
            extra = self.OptionsEditmode,
            -- parentExtra = FocusFrame,
            default = function()
                -- setDefaultSubValues('focus')
            end,
            moduleRef = self.ModuleRef,
            showFunction = function()
                --  
                f:Show()
                CompactRaidFrameManager_SetSetting('Locked', false)
                f:Show()
            end,
            hideFunction = function()
                --      
                CompactRaidFrameManager_SetSetting('Locked', true)
                CompactRaidFrameManager_ResizeFrame_SavePosition(CompactRaidFrameManager)
            end
        });

        fakeRaid:UpdateState(nil)

        hooksecurefunc('CompactRaidFrameManager_UpdateContainerVisibility', function()
            -- print('CompactRaidFrameManager_UpdateContainerVisibility')
            if EditModeModule.IsEditMode then
                --             
                -- CompactRaidFrameManager_SetSetting('Locked', false)
                C_Timer.After(0, function()
                    --
                    CompactRaidFrameManager_SetSetting('Locked', false)
                end)
            end
        end)

        f.DFEditModeSelection:HookScript('OnDragStop', function()
            --
            CompactRaidFrameManager_ResizeFrame_SavePosition(CompactRaidFrameManager)
        end)
    end

    if HasLoadedCUFProfiles() and CompactUnitFrameProfiles and CompactUnitFrameProfiles.variablesLoaded then
        initRaid()
    else
        local waitFrame = CreateFrame('Frame')
        waitFrame:RegisterEvent("COMPACT_UNIT_FRAME_PROFILES_LOADED")
        waitFrame:RegisterEvent("VARIABLES_LOADED")
        waitFrame:SetScript("OnEvent", function(waitFrame, event, arg1)
            --
            -- print(event)
            waitFrame:UnregisterEvent(event);
            if (HasLoadedCUFProfiles() and CompactUnitFrameProfiles and CompactUnitFrameProfiles.variablesLoaded) then
                --
                initRaid()
            end
        end)
    end
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

function SubModuleMixin:AddRaidframeRoleIcons()
    local function updateRoleIcons(f)
        if not f.roleIcon then
            return
        else
            f.roleIcon:SetDrawLayer('OVERLAY')
            local size = f.roleIcon:GetHeight();
            local role = UnitGroupRolesAssigned(f.unit);
            if (role == "TANK" or role == "HEALER" or role == "DAMAGER") then
                f.roleIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES");
                f.roleIcon:SetTexCoord(GetTexCoordsForRoleSmallCircle(role));
                f.roleIcon:Show();
                f.roleIcon:SetSize(size, size);
                if strmatch(tostring(f.unit), 'target') then f.roleIcon:Hide() end
            else
                f.roleIcon:Hide();
                f.roleIcon:SetSize(1, size);
            end
        end
    end
    hooksecurefunc("CompactUnitFrame_UpdateRoleIcon", function(f)
        --
        -- print('CompactUnitFrame_UpdateRoleIcon')
        updateRoleIcons(f)
    end)
end
