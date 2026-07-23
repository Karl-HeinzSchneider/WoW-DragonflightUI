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
        -- era-1159: dock at the right end of the main action bar like
        -- retail, instead of floating at an arbitrary mid-screen offset.
        anchorFrame = 'DragonflightUIActionbarFrame1',
        customAnchorFrame = '',
        anchor = 'LEFT',
        anchorParent = 'RIGHT',
        x = 12,
        y = 0,
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

    local f = _G['DragonflightUIVehicleLeaveButton']
    f:SetParent(UIParent)
    f:SetScale(1.0)
    f:SetClampedToScreen(true)
    f:SetMovable(true)

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
        moduleRef = self.ModuleRef,
        showFunction = function()
            --         
            f.FakePreview:Show()
        end,
        hideFunction = function()
            --
            -- fakeWidget:Show()
            f.FakePreview:Hide()
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

    local f = _G['DragonflightUIVehicleLeaveButton']

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

    local btn = _G['MainMenuBarVehicleLeaveButton'];
    btn:SetScale(state.scale)

    -- f:UpdateStateHandler(state)
end

function SubModuleMixin:CreateVehicleLeaveButton()
    local f = _G['DragonflightUIVehicleLeaveButton']
    -- local fakeWidget = CreateFrame('Frame', 'DragonflightUIVehicleLeaveButtonPreview', f)
    -- fakeWidget:SetParent(UIParent)
    -- fakeWidget:SetSize(32, 32)
    local fakeWidget = f;

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
    if DF.API.Version.IsTBC then
        addonTable:OverrideBlizzEditmode(btn, 'CENTER', f, 'CENTER', 0, 0)
    else
        btn:UnregisterAllEvents()
        -- btn:SetParent(f)
        btn:ClearAllPoints()
        btn:SetPoint('CENTER', f, 'CENTER', 0, 0)
        -- btn:Show()

        -- era-1159: the plain SetPoint above is not enough. The Classic
        -- panel manager (UIParentManageFramePositions) re-anchors this
        -- button to UIParent/BOTTOM whenever the bars update - which is
        -- exactly when a taxi shows it - because IsInDefaultPosition()
        -- still reports true. Move its EditMode layout anchor as well
        -- (the same trick ForceMoveBlizzEditModeGhosts uses for the
        -- parked bars, and the TBC branch below already does): the
        -- manager then skips the button and the dock anchor sticks.
        local lib = addonTable.LibEditModeOverride
        if lib then
            lib:ReanchorFrame(btn, 'CENTER', f, 'CENTER', 0, 0)
            if InCombatLockdown() then
                lib:SaveOnly()
            else
                lib:ApplyChanges()
            end
        elseif addonTable.OverrideBlizzEditmode then
            addonTable:OverrideBlizzEditmode(btn, 'CENTER', f, 'CENTER', 0, 0)
        end

        -- era-1159: dress the real button in the retail round exit-arrow
        -- art (shipped by DFUI but previously used only for the edit-mode
        -- preview); the classic wooden square reads nothing like retail.
        btn:SetSize(32, 32)
        for _, region in ipairs({btn:GetRegions()}) do
            if region:GetObjectType() == 'Texture' then region:SetTexture(nil) end
        end
        local coord = {0.140625, 0.859375, 0.140625, 0.859375}
        btn:SetNormalTexture(tex)
        btn:GetNormalTexture():SetTexCoord(unpack(coord))
        btn:SetPushedTexture(tex)
        local pushed = btn:GetPushedTexture()
        pushed:SetTexCoord(unpack(coord))
        pushed:SetVertexColor(0.6, 0.6, 0.6)
        btn:SetHighlightTexture(tex, 'ADD')
        btn:GetHighlightTexture():SetTexCoord(unpack(coord))
        btn:GetHighlightTexture():SetAlpha(0.35)
    end
end
