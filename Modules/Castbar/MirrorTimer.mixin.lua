local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local subModuleName = 'MirrorTimer';
local SubModuleMixin = {};
addonTable.SubModuleMixins[subModuleName] = SubModuleMixin;

function SubModuleMixin:Init()
    self.ModuleRef = DF:GetModule('Castbar')
    self:SetDefaults()
    self:SetupOptions()
    -- self:SetScript('OnEvent', self.OnEvent);
end

function SubModuleMixin:SetDefaults()
    local defaults = {
        scale = 1.0,
        anchorFrame = 'UIParent',
        customAnchorFrame = '',
        anchor = 'TOP',
        anchorParent = 'TOP',
        x = 0,
        y = -300
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

    local options = {
        name = L["CastbarMirrorTimerName"],
        desc = L["CastbarMirrorTimerNameDesc"],
        advancedName = 'MirrorTimer',
        sub = 'mirrorTimer',
        get = getOption,
        set = setOption,
        type = 'group',
        args = {}
    }
    DF.Settings:AddPositionTable(Module, options, 'mirrorTimer', 'mirrorTimer', getDefaultStr, frameTable)

    local optionsEditmode = {
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
                    local dbTable = Module.db.profile.mirrorTimer
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

    self.Options = options;
    self.OptionsEditmode = optionsEditmode;
end

function SubModuleMixin:Setup()
    local function setDefaultSubValues(sub)
        self.ModuleRef:SetDefaultSubValues(sub)
    end

    DF.ConfigModule:RegisterSettingsData('mirrorTimer', 'castbar', {
        options = self.Options,
        default = function()
            setDefaultSubValues('mirrorTimer')
        end
    })
    --

    self:CreateBase()

    local f = self.BaseFrame
    -- state
    -- Mixin(f, DragonflightUIStateHandlerMixin)
    -- f:InitStateHandler()
    -- editmode

    local EditModeModule = DF:GetModule('Editmode');
    EditModeModule:AddEditModeToFrame(f)

    f.DFEditModeSelection:SetGetLabelTextFunction(function()
        return self.Options.name
    end)

    f.DFEditModeSelection:RegisterOptions({
        options = self.Options,
        extra = self.OptionsEditmode,
        default = function()
            setDefaultSubValues(self.Options.sub)
        end,
        moduleRef = self.ModuleRef
    });
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

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    local f = self.BaseFrame

    f:SetScale(state.scale)
    f:ClearAllPoints()
    f:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

end

function SubModuleMixin:CreateBase()
    local baseFrame = CreateFrame('Frame', 'DragonflightUIMirrorTimerBase', UIParent);
    baseFrame:SetSize(200, 200);
    baseFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0);
    baseFrame:SetClampedToScreen(true)
    self.BaseFrame = baseFrame;

    function baseFrame:SetEditMode(editmode)
        print('~> SetEditMode', editmode)
    end
end
