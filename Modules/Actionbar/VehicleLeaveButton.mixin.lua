local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local subModuleName = 'VehicleLeaveButton';
local SubModuleMixin = {};
addonTable.SubModuleMixins[subModuleName] = SubModuleMixin;

function SubModuleMixin:Init()
    self.ModuleRef = DF:GetModule('Actionbar')
    self:SetDefaults()
    self:SetupOptions()
end

function SubModuleMixin:SetDefaults()
    local defaults = {
        scale = 1.25,
        override = false,
        anchorFrame = 'UIParent',
        customAnchorFrame = '',
        anchor = 'CENTER',
        anchorParent = 'CENTER',
        x = -215,
        y = -285,
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

    local optionsPet = {
        name = L["VehicleLeaveButton"],
        desc = L["VehicleLeaveButtonDesc"],
        advancedName = 'VehicleLeave',
        sub = 'vehicleLeave',
        get = getOption,
        set = setOption,
        type = 'group',
        args = {}
    }

    DF.Settings:AddPositionTable(Module, optionsPet, 'vehicleLeave', 'Vehicle Leave Button', getDefaultStr, frameTable)

    -- DragonflightUIStateHandlerMixin:AddStateTable(Module, optionsPet, 'vehicleLeave', 'Vehicle Leave Button',
    --                                               getDefaultStr)
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
                    local dbTable = Module.db.profile.vehicleLeave
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
        self.ModuleRef:SetDefaultSubValues(sub)
    end

    DF.ConfigModule:RegisterSettingsData('vehicleLeave', 'actionbar', {
        options = self.Options,
        default = function()
            setDefaultSubValues('vehicleLeave')
        end
    })

    --

    self:CreateVehicleLeaveButton()

    self:SetScript('OnEvent', self.OnEvent);
    self:RegisterEvent("PLAYER_ENTERING_WORLD");
    self:RegisterEvent("UPDATE_BONUS_ACTIONBAR");
    self:RegisterEvent("UPDATE_MULTI_CAST_ACTIONBAR");
    self:RegisterEvent("UNIT_ENTERED_VEHICLE");
    self:RegisterEvent("UNIT_EXITED_VEHICLE");
    self:RegisterEvent("VEHICLE_UPDATE");

    -- editmode
    local EditModeModule = DF:GetModule('Editmode');
    local fakeWidget = self.PreviewFrame

    EditModeModule:AddEditModeToFrame(fakeWidget)

    fakeWidget.DFEditModeSelection:SetGetLabelTextFunction(function()
        return self.Options.name
    end)

    fakeWidget.DFEditModeSelection:RegisterOptions({
        options = self.Options,
        extra = self.OptionsEditmode,
        default = function()
            setDefaultSubValues(self.Options.sub)
        end,
        moduleRef = self.ModuleRef,
        showFunction = function()
            --         
            fakeWidget.FakePreview:Show()
        end,
        hideFunction = function()
            --
            fakeWidget:Show()
            fakeWidget.FakePreview:Hide()
        end
    });
end

function SubModuleMixin:OnEvent(event, ...)
    -- print('event', event, ...)
    if ((CanExitVehicle() or UnitOnTaxi("player")) and ActionBarController_GetCurrentActionBarState() ==
        LE_ACTIONBAR_STATE_MAIN) then
        --
        MainMenuBarVehicleLeaveButton:Show();
        MainMenuBarVehicleLeaveButton:Enable();
    else
        MainMenuBarVehicleLeaveButton:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]], "ADD");
        MainMenuBarVehicleLeaveButton:UnlockHighlight();
        MainMenuBarVehicleLeaveButton:Hide();
    end
end

function SubModuleMixin:UpdateState(state)
    self.state = state;
    self:Update();
end

function SubModuleMixin:Update()
    local state = self.state;
    if not state then return end

    local f = self.PreviewFrame

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    -- f:SetParent(parent)
    f:SetScale(state.scale)

    f:ClearAllPoints()
    f:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    -- f:SetUserPlaced(true)

    -- f:UpdateStateHandler(state)
end

function SubModuleMixin:CreateVehicleLeaveButton()
    local fakeWidget = CreateFrame('Frame', 'DragonflightUIVehicleLeaveButton', UIParent)
    fakeWidget:SetSize(32, 32)
    self.PreviewFrame = fakeWidget

    local tex = 'Interface\\Addons\\DragonflightUI\\Textures\\UI-Vehicles-Button-Exit-Up'
    local fakeArrow = fakeWidget:CreateTexture('DragonflightUIFakeVehicleLeaveButton', "ARTWORK")
    -- fakeArrow:SetTexture('Interface\\Vehicles\\UI-Vehicles-Button-Exit-U')
    fakeArrow:SetTexture(tex)
    fakeArrow:SetTexCoord(0.140625, 0.859375, 0.140625, 0.859375)
    fakeArrow:SetSize(32, 32)
    fakeArrow:SetPoint('CENTER', fakeWidget, 'CENTER', 0, 0)
    fakeArrow:Hide()
    fakeWidget.FakePreview = fakeArrow;

    local btn = _G['MainMenuBarVehicleLeaveButton'];
    btn:UnregisterAllEvents()

    btn:SetParent(fakeWidget)
    btn:ClearAllPoints()
    btn:SetPoint('CENTER', fakeWidget, 'CENTER', 0, 0)
    -- btn:Show()

end
