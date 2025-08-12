local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local subModuleName = 'GroupLootContainer';
local SubModuleMixin = {};
addonTable.SubModuleMixins[subModuleName] = SubModuleMixin;

function SubModuleMixin:Init()
    self.ModuleRef = DF:GetModule('UI')

    self:SetDefaults()
    self:SetupOptions()
end

function SubModuleMixin:SetDefaults()
    local defaults = {
        scale = 1,
        anchorFrame = 'UIParent',
        customAnchorFrame = '',
        anchor = 'BOTTOM',
        anchorParent = 'BOTTOM',
        x = 425, -- 0
        y = 200 -- 152 = default blizz
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
        {value = 'Minimap', text = 'Minimap', tooltip = 'descr', label = 'label'}
    }

    local rollOptions = {
        name = L["GroupLootContainerName"],
        desc = L["GroupLootContainerDesc"],
        advancedName = 'GroupLootContainer',
        sub = 'roll',
        get = getOption,
        set = setOption,
        type = 'group',
        args = {}
    }
    DF.Settings:AddPositionTable(Module, rollOptions, 'roll', 'GroupLootContainer', getDefaultStr, frameTable)
    -- DragonflightUIStateHandlerMixin:AddStateTable(Module, rollOptions, 'possess', 'PossessBar', getDefaultStr)
    rollOptions.args.scale = nil;
    local rollOptionsEditmode = {
        name = 'possess',
        desc = 'possess',
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
                    local dbTable = Module.db.profile.roll
                    local defaultsTable = self.Defaults
                    -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                    setPreset(dbTable, {
                        scale = defaultsTable.scale,
                        anchor = defaultsTable.anchor,
                        anchorParent = defaultsTable.anchorParent,
                        anchorFrame = defaultsTable.anchorFrame,
                        x = defaultsTable.x,
                        y = defaultsTable.y
                    }, 'roll')
                end,
                order = 16,
                editmode = true,
                new = false
            }
        }
    }

    self.Options = rollOptions;
    self.OptionsEditmode = rollOptionsEditmode;
end

function SubModuleMixin:Setup()
    local function setDefaultSubValues(sub)
        self.ModuleRef:SetDefaultSubValues(sub)
    end

    DF.ConfigModule:RegisterSettingsData('roll', 'misc', {
        options = self.Options,
        default = function()
            setDefaultSubValues('roll')
        end
    })

    self:ChangeGroupLootContainer()
    self:SetScript('OnEvent', self.OnEvent);

    -- editmode 
    local EditModeModule = DF:GetModule('Editmode');

    local fakeRoll = self.PreviewRoll

    EditModeModule:AddEditModeToFrame(fakeRoll)

    fakeRoll.DFEditModeSelection:SetGetLabelTextFunction(function()
        return self.Options.name
    end)

    fakeRoll.DFEditModeSelection:RegisterOptions({
        options = self.Options,
        extra = self.OptionsEditmode,
        default = function()
            setDefaultSubValues('roll')
        end,
        moduleRef = self.ModuleRef,
        showFunction = function()
            --         
            fakeRoll.FakePreview:Show()
        end,
        hideFunction = function()
            --
            fakeRoll.FakePreview:Hide()
        end
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

    local preview = self.PreviewRoll;
    preview:ClearAllPoints()
    preview:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    -- preview:SetScale(state.scale)
    preview:SetScale(1)

    local f = _G['GroupLootContainer']
    f.ignoreFramePositionManager = true;
    f:ClearAllPoints()
    f:SetPoint('BOTTOM', preview, 'BOTTOM', 0, 0)
end

function SubModuleMixin:ChangeGroupLootContainer()
    local fakeRoll = CreateFrame('Frame', 'DragonflightUIEditModeGroupLootContainerPreview', UIParent)
    fakeRoll:SetSize(256, 100)
    self.PreviewRoll = fakeRoll

    local fakePreview = CreateFrame('Frame', 'DragonflightUIEditModeGroupLootContainerFakeLootPreview', fakeRoll,
                                    'DFEditModePreviewGroupLootTemplate')
    fakePreview:SetPoint('CENTER')

    fakeRoll.FakePreview = fakePreview

    for i = 1, 1 do self:HookGroupLootFrame(_G['GroupLootFrame' .. i]); end
end

function SubModuleMixin:HookGroupLootFrame(f)
    print('HookGroupLootFrame', f:GetName())
end

