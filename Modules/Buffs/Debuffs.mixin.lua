local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local subModuleName = 'Debuff';
local SubModuleMixin = {};
addonTable.SubModuleMixins[subModuleName] = SubModuleMixin;

function SubModuleMixin:Init()
    self.ModuleRef = DF:GetModule('Buffs')
    self:SetDefaults()
    self:SetupOptions();
    -- self:SetScript('OnEvent', self.OnEvent);
end

function SubModuleMixin:SetDefaults()
    local defaults = {
        scale = 1,
        anchorFrame = 'UIParent',
        customAnchorFrame = '',
        anchor = 'TOPRIGHT',
        anchorParent = 'TOPRIGHT',
        x = -250,
        y = -146, -- -13 - 110
        -- auraheader
        seperateOwn = '0',
        sortMethod = 'INDEX',
        sortDirection = '+',
        groupBy = '',
        point = 'TOPRIGHT',
        orientation = 'rightToLeft',
        growthDirection = 'down',
        paddingX = 5,
        paddingY = 14,
        wrapAfter = 8,
        -- wrapXOffset = 0,
        -- wrapYOffset = 14,
        maxWraps = 2,
        --
        hideDurationText = false,
        hideCooldownSwipe = false,
        hideCooldownDurationText = true,
        -- Visibility
        alphaNormal = 1.0,
        alphaCombat = 1.0,
        showMouseover = false,
        hideAlways = false,
        hideCombat = false,
        hideOutOfCombat = false,
        hideVehicle = false,
        hidePet = false,
        hideNoPet = false,
        hideStance = false,
        hideStealth = false,
        hideNoStealth = false,
        hideBattlePet = false,
        hideCustom = false,
        hideCustomCond = '',
        useStateHandler = true
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

    local options = {
        type = 'group',
        name = L["DebuffsOptionsName"],
        advancedName = 'Debuffs',
        sub = 'debuffs',
        get = getOption,
        set = setOption,
        args = {}
    }

    DF.Settings:AddPositionTable(Module, options, 'debuffs', 'Debuffs', getDefaultStr, frameTable)
    DragonflightUIStateHandlerMixin:AddStateTable(Module, options, 'debuffs', 'Debuffs', getDefaultStr)
    DragonflightUIBuffContainerMixin:AddAuraHeaderTable(Module, options, sub, getDefaultStr)
    local optionsEditmode = {
        name = 'Debuff',
        desc = 'Debuff',
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
                    local dbTable = self.ModuleRef.db.profile.debuffs
                    local defaultsTable = self.Defaults
                    -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                    setPreset(dbTable, {
                        scale = defaultsTable.scale,
                        anchor = defaultsTable.anchor,
                        anchorParent = defaultsTable.anchorParent,
                        anchorFrame = defaultsTable.anchorFrame,
                        x = defaultsTable.x,
                        y = defaultsTable.y
                    }, 'debuffs')
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
    -- 
    local function setDefaultSubValues(sub)
        self.ModuleRef:SetDefaultSubValues(sub)
    end

    DF.ConfigModule:RegisterSettingsData('debuffs', 'misc', {
        options = self.Options,
        default = function()
            setDefaultSubValues(self.Options.sub)
        end
    })

    --
    self:CreateDebuffFrame()
    self:CreateNewDebuffs()
    self:RemoveDefaultDebuffs()
    --
    local EditModeModule = DF:GetModule('Editmode');
    EditModeModule:AddEditModeToFrame(self.DFDebuffFrame)

    self.DFDebuffFrame.DFEditModeSelection:SetGetLabelTextFunction(function()
        return self.Options.name
    end)

    self.DFDebuffFrame.DFEditModeSelection:RegisterOptions({
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

    local f = self.DFDebuffFrame

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    f:SetScale(state.scale)
    f:ClearAllPoints()
    f:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

    if state.useStateHandler and not self.StateHandlerAdded then
        self.StateHandlerAdded = true;
        self:AddStateUpdater()
    end

    self.NewDebuffs:SetState(state)

    if self.StateHandlerAdded then f:UpdateStateHandler(state) end
end

function SubModuleMixin:CreateDebuffFrame()
    local f = CreateFrame('FRAME', 'DragonflightUIPlayerDebuffFrame', UIParent)
    f:SetSize(30 + (10 - 1) * 35, 30 + (2 - 1) * 35)
    f:SetPoint('TOPRIGHT', MinimapCluster, 'TOPLEFT', -55, -13 - 110)
    f:SetClampedToScreen(true)
    self.DFDebuffFrame = f
end

function SubModuleMixin:AddStateUpdater()
    Mixin(self.DFDebuffFrame, DragonflightUIStateHandlerMixin)
    self.DFDebuffFrame:InitStateHandler(4, 4)
end

function SubModuleMixin:CreateNewDebuffs()
    local container = CreateFrame("Frame", "DragonflightUIPlayerDebuffFrameContainer", self.DFDebuffFrame,
                                  "DragonflightUIDebuffFrameContainerTemplate");
    container:SetPoint('TOPRIGHT', self.DFDebuffFrame, 'TOPRIGHT', 0, 0)
    container:SetPoint('BOTTOMLEFT', self.DFDebuffFrame, 'BOTTOMLEFT', 0, 0)
    container.Header:SetParent(self.DFDebuffFrame)
    -- container:SetSize(30, 30)
    container:Show();

    self.NewDebuffs = container
end

function SubModuleMixin:RemoveDefaultDebuffs()
    -- if TemporaryEnchantFrame then
    --     TemporaryEnchantFrame:UnregisterAllEvents()
    --     TemporaryEnchantFrame:Hide()
    -- end
    -- if BuffFrame then
    --     BuffFrame:UnregisterAllEvents()
    --     BuffFrame:Hide()
    -- end
end

