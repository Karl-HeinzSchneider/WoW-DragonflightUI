local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local subModuleName = 'Durability';
local SubModuleMixin = {};
addonTable.SubModuleMixins[subModuleName] = SubModuleMixin;

function SubModuleMixin:Init()
    self.ModuleRef = DF:GetModule('Minimap')
    self:SetDefaults()
    self:SetupOptions()
    -- self:SetScript('OnEvent', self.OnEvent);
end

function SubModuleMixin:SetDefaults()
    local defaults = {
        scale = 1,
        anchorFrame = 'DragonflightUIMinimapBase',
        customAnchorFrame = '',
        anchor = 'TOP',
        anchorParent = 'BOTTOM',
        x = 0,
        y = 0
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
        {value = 'MinimapCluster', text = 'MinimapCluster', tooltip = 'descr', label = 'label'}
    }

    local frameTableTracker = {
        {value = 'UIParent', text = 'UIParent', tooltip = 'descr', label = 'label'},
        {value = 'MinimapCluster', text = 'MinimapCluster', tooltip = 'descr', label = 'label'},
        {value = 'Minimap', text = 'Minimap', tooltip = 'descr', label = 'label'},
        {value = 'DragonflightUIMinimapBase', text = 'DF_MinimapFrame', tooltip = 'descr', label = 'label'}
    }

    local options = {
        type = 'group',
        name = L["MinimapDurabilityName"],
        advancedName = 'Durability',
        sub = 'durability',
        get = getOption,
        set = setOption,
        args = {}
    }
    DF.Settings:AddPositionTable(Module, options, 'durability', 'Durability', getDefaultStr, frameTableTracker)

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
                    local dbTable = Module.db.profile.durability
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

    DF.ConfigModule:RegisterSettingsData('durability', 'misc', {
        options = self.Options,
        default = function()
            setDefaultSubValues(self.Options.sub)
        end
    })
    --
    self:CreateBase()
    --
    local f = self.BaseFrame

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
        moduleRef = self.ModuleRef,
        showFunction = function()
            --         
            -- fakeWidget.FakePreview:Show()
        end,
        hideFunction = function()
            --
            -- f:Show()
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

    local f = self.BaseFrame

    f:SetScale(state.scale)
    f:ClearAllPoints()
    f:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
end

function SubModuleMixin:CreateBase()
    local baseFrame = CreateFrame('Frame', 'DragonflightUIDurabilityFrame', UIParent);
    baseFrame:SetSize(92, 75);
    -- baseFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0);
    baseFrame:SetClampedToScreen(true)
    -- baseFrame:Hide()
    self.BaseFrame = baseFrame;

    local fake = CreateFrame('Frame', 'sss', baseFrame, 'DFEditModePreviewDurability')
    -- fake:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    fake:SetWidth(58 + 20 + 14)
    fake.DurabilityHead:SetPoint('TOPRIGHT', -40, 0)
    fake:SetPoint('TOPRIGHT', baseFrame, 'TOPRIGHT', 0, 0)

    fake:Hide()

    self.FakeFrame = fake;

    -- 
    function self.BaseFrame:SetEditMode(editmode)
        -- print('SetEditMode', editmode)
        if editmode and not DurabilityFrame:IsVisible() then
            fake:Show()
        else
            fake:Hide()
        end
    end

    local moveDur = function()
        local widthMax = 92
        local width = DurabilityFrame:GetWidth()
        local delta = (widthMax - width) / 2

        DurabilityFrame:ClearAllPoints()
        DurabilityFrame:SetPoint('TOPRIGHT', baseFrame, 'TOPRIGHT', -delta, 0)
        DurabilityFrame:SetParent(baseFrame)
    end
    DurabilityFrame:ClearAllPoints()
    moveDur()

    hooksecurefunc(DurabilityFrame, 'SetPoint', function(self, void, rel)
        -- print('DurabilityFrame', 'SetPoint')
        if rel and (rel ~= baseFrame) then
            -- print('DurabilityFrame', 'inside')
            moveDur()
        end
    end)
end
