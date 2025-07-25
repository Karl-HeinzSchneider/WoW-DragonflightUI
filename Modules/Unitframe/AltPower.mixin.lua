local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local subModuleName = 'AltPower';
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
        scale = 1.0,
        anchorFrame = 'UIParent',
        customAnchorFrame = '',
        anchor = 'CENTER',
        anchorParent = 'CENTER',
        x = 0,
        y = -220
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
        {value = 'TargetFrame', text = 'TargetFrame', tooltip = 'descr', label = 'label'}
    }

    local optionsAltPower = {
        name = L["PowerBarAltName"],
        desc = L["PowerBarAltNameDesc"],
        advancedName = 'Player_PowerBarAlt',
        sub = "altpower",
        get = getOption,
        set = setOption,
        type = 'group',
        args = {}
    }
    DF.Settings:AddPositionTable(Module, optionsAltPower, 'altpower', 'AltPower', getDefaultStr, frameTable)
    local optionsAltPowerEditmode = {
        name = 'AltPower',
        desc = '.',
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
                    local dbTable = Module.db.profile.altpower
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

    self.Options = optionsAltPower;
    self.OptionsEditmode = optionsAltPowerEditmode;
end

function SubModuleMixin:Setup()
    local function setDefaultSubValues(sub)
        self.ModuleRef:SetDefaultSubValues(sub)
    end

    DF.ConfigModule:RegisterSettingsData('altpower', 'unitframes', {
        options = self.Options,
        default = function()
            setDefaultSubValues('altpower')
        end
    })

    --
    self:AddPowerBarAlt()

    -- edit mode
    local EditModeModule = DF:GetModule('Editmode');
    local f = self.PowerBarAltPreview
    EditModeModule:AddEditModeToFrame(f)

    f.DFEditModeSelection:SetGetLabelTextFunction(function()
        return self.Options.name
    end)

    f.DFEditModeSelection:RegisterOptions({
        options = self.Options,
        extra = self.OptionsEditmode,
        default = function()
            setDefaultSubValues('altpower')
        end,
        moduleRef = self.ModuleRef,
        showFunction = function()
            self:UpdatePowerBarAltPosition()
        end,
        hideFunction = function()
            --
            f:Show()
        end
    });
end

function SubModuleMixin:OnEvent(event, ...)
end

function SubModuleMixin:UpdateState(state)
    self.state = state;
    self:Update();

    local f = self.PowerBarAltPreview

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    f:SetScale(state.scale)
    f:ClearAllPoints()
    f:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

    self:UpdatePowerBarAltPosition();
end

function SubModuleMixin:Update()
    local state = self.state;
    if not state then return end
end

function SubModuleMixin:AddPowerBarAlt()
    local f = CreateFrame('FRAME', 'DragonflightUIPlayerPowerBarAlt', UIParent)
    f:SetPoint('CENTER', UIParent, 'CENTER', 0, -180)
    f:SetSize(130, 75)
    f:SetClampedToScreen(true)

    self.PowerBarAltPreview = f

    local alt = _G['PlayerPowerBarAlt']
    alt:SetMovable(true)
    alt:SetUserPlaced(true)

    function self:UpdatePowerBarAltPosition()
        -- local state = Module.db.profile.altpower
        -- alt:ClearAllPoints()
        -- alt:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
        -- alt:SetScale(state.scale)
        alt:ClearAllPoints()
        alt:SetParent(f)
        alt:SetPoint('CENTER', f, 'CENTER', 0, 0)
    end

    hooksecurefunc('UnitPowerBarAlt_SetUp', function(bar, barID)
        --
        -- print('UnitPowerBarAlt_SetUp')
        if bar.unit and UnitIsUnit(bar.unit, 'player') then
            -- print('~~player')
            self:UpdatePowerBarAltPosition();
        end
    end)

    hooksecurefunc('PlayerBuffTimerManager_UpdateTimers', function(bar)
        -- print('PlayerBuffTimerManager_UpdateTimers')
        self:UpdatePowerBarAltPosition();
    end)
end

