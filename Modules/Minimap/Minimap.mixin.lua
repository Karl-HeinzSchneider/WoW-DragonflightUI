local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local libIcon = LibStub("LibDBIcon-1.0")

local subModuleName = 'Minimap';
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
        anchorFrame = 'UIParent',
        customAnchorFrame = '',
        anchor = 'TOPRIGHT',
        anchorParent = 'TOPRIGHT',
        x = -4,
        y = -4,
        shape = 'ROUND',
        locked = true,
        showPing = false,
        showPingChat = false,
        hideZoneText = false,
        hideClock = false,
        hideCalendar = false,
        hideZoom = false,
        hideHeader = false,
        skinButtons = true,
        hideButtons = false,
        zonePanelPosition = 'TOP',
        -- Visibility
        alphaNormal = 1.0,
        alphaCombat = 1.0,
        showMouseover = false,
        hideAlways = false,
        hideCombat = false,
        hideOutOfCombat = false,
        hidePet = false,
        hideVehicle = false,
        hideNoPet = false,
        hideStance = false,
        hideStealth = false,
        hideNoStealth = false,
        hideBattlePet = false,
        hideCustom = false,
        hideCustomCond = ''
        -- useStateHandler = true
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

    local shapeTable = {
        {value = 'ROUND', text = 'Round', tooltip = 'descr', label = 'label'},
        {value = 'SQUARE', text = 'Square', tooltip = 'descr', label = 'label'}
    }

    local minimapOptions = {
        type = 'group',
        name = L["MinimapName"],
        advancedName = 'Minimap',
        sub = 'minimap',
        get = getOption,
        set = setOption,
        args = {
            headerStyling = {
                type = 'header',
                name = L["MinimapStyle"],
                desc = '',
                order = 20,
                isExpanded = true,
                editmode = true
            },
            shape = {
                type = 'select',
                name = L["MinimapShape"],
                desc = L["MinimapShapeDesc"] .. getDefaultStr('shape', 'minimap'),
                dropdownValues = shapeTable,
                order = 1,
                group = 'headerStyling',
                new = true,
                editmode = true
            },
            zonePanelPosition = {
                type = 'select',
                name = L["MinimapZonePanelPosition"],
                desc = L["MinimapZonePanelPositionDesc"] .. getDefaultStr('zonePanelPosition', 'minimap'),
                dropdownValues = DF.Settings.DropdownTopBottomAnchorTable,
                order = 10,
                group = 'headerStyling',
                new = true,
                editmode = true
            },
            hideHeader = {
                type = 'toggle',
                name = L["MinimapHideHeader"],
                desc = L["MinimapHideHeaderDesc"] .. getDefaultStr('hideHeader', 'minimap'),
                group = 'headerStyling',
                order = 10.1,
                new = true,
                editmode = true
            },
            hideZoneText = {
                type = 'toggle',
                name = L["MinimapHideZoneText"],
                desc = L["MinimapHideZoneTextDesc"] .. getDefaultStr('hideZoneText', 'minimap'),
                group = 'headerStyling',
                order = 10.2,
                new = true,
                editmode = true
            },
            hideClock = {
                type = 'toggle',
                name = L["MinimapHideClock"],
                desc = L["MinimapHideClockDesc"] .. getDefaultStr('hideClock', 'minimap'),
                group = 'headerStyling',
                order = 10.3,
                new = true,
                editmode = true
            },
            hideCalendar = {
                type = 'toggle',
                name = L["MinimapHideCalendar"],
                desc = L["MinimapHideCalendarDesc"] .. getDefaultStr('hideCalendar', 'minimap'),
                group = 'headerStyling',
                order = 10.4,
                new = false,
                editmode = true
            },
            showPing = {
                type = 'toggle',
                name = L["MinimapShowPing"],
                desc = L["MinimapNotYetImplemented"] .. getDefaultStr('showPing', 'minimap'),
                group = 'headerStyling',
                order = 11,
                editmode = true
            },
            showPingChat = {
                type = 'toggle',
                name = L["MinimapShowPingInChat"],
                desc = getDefaultStr('showPingChat', 'minimap'),
                group = 'headerStyling',
                order = 12,
                editmode = true
            },
            hideZoom = {
                type = 'toggle',
                name = L["MinimapHideZoomButtons"],
                desc = L["MinimapHideZoomDesc"] .. getDefaultStr('hideZoom', 'minimap'),
                group = 'headerStyling',
                order = 14,
                new = false,
                editmode = true
            },
            hideButtons = {
                type = 'toggle',
                name = L["MinimapSkinMinimapHideButtons"],
                desc = L["MinimapSkinMinimapHideButtonsDesc"] .. getDefaultStr('hideButtons', 'minimap'),
                group = 'headerStyling',
                order = 15.1,
                new = true,
                editmode = true
            }
            -- skinButtons = {
            --     type = 'toggle',
            --     name = L["MinimapSkinMinimapButtons"],
            --     desc = L["MinimapSkinMinimapButtonsDesc"] .. getDefaultStr('skinButtons', 'minimap'),
            --     group = 'headerStyling',
            --     order = 15,
            --     new = false,
            --     editmode = true
            -- }
        }
    }
    do
        local moreOptions = {
            rotate = {
                type = 'toggle',
                name = ROTATE_MINIMAP,
                desc = OPTION_TOOLTIP_ROTATE_MINIMAP .. L["MinimapRotateDescAdditional"],
                group = 'headerStyling',
                order = 13.1,
                blizzard = true,
                editmode = true
            }
        }

        for k, v in pairs(moreOptions) do minimapOptions.args[k] = v end

        minimapOptions.get = function(info)
            local key = info[1]
            local sub = info[2]

            if sub == 'rotate' then
                return C_CVar.GetCVarBool("rotateMinimap")
            else
                return getOption(info)
            end
        end

        minimapOptions.set = function(info, value)
            local key = info[1]
            local sub = info[2]

            if sub == 'rotate' then
                if value then
                    C_CVar.SetCVar("rotateMinimap", 1)
                else
                    C_CVar.SetCVar("rotateMinimap", 0)
                end
                self:UpdateMinimapShape()
            else
                setOption(info, value)
            end
        end
    end

    DF.Settings:AddPositionTable(Module, minimapOptions, 'minimap', 'Minimap', getDefaultStr, frameTable)
    -- DragonflightUIStateHandlerMixin:AddStateTable(Module, optionTable, sub, displayName, getDefaultStr)
    DragonflightUIStateHandlerMixin:AddStateTable(Module, minimapOptions, 'minimap', 'Minimap', getDefaultStr)
    local optionsMinimapEditmode = {
        name = 'Minimap',
        desc = 'Minimapdesc',
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
                    local dbTable = Module.db.profile.minimap
                    local defaultsTable = self.Defaults
                    -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                    setPreset(dbTable, {
                        scale = defaultsTable.scale,
                        anchor = defaultsTable.anchor,
                        anchorParent = defaultsTable.anchorParent,
                        anchorFrame = defaultsTable.anchorFrame,
                        x = defaultsTable.x,
                        y = defaultsTable.y
                    }, 'minimap')
                end,
                order = 16,
                editmode = true,
                new = false
            }
        }
    }

    self.Options = minimapOptions;
    self.OptionsEditmode = optionsMinimapEditmode;
end

function SubModuleMixin:Setup()
    local function setDefaultSubValues(sub)
        self.ModuleRef:SetDefaultSubValues(sub)
    end

    DF.ConfigModule:RegisterSettingsData('minimap', 'misc', {
        options = self.Options,
        default = function()
            setDefaultSubValues(self.Options.sub)
        end
    })

    self:CreateBaseFrame()
    self:CreateInfoPanel()
    self:ChangeZoneText()
    self:ChangeClock()
    self:ChangeTracking()
    self:ChangeCalendar()
    self:ChangeDifficulty()
    self:ChangeMail()

    self:HideDefaultStuff()
    self:HookMouseWheel()
    self:ChangeZoom()
    self:SetupMinimap()

    self:ChangeMinimapButtons()

    self:SetScript('OnEvent', self.OnEvent);
    self:RegisterEvent('MINIMAP_UPDATE_TRACKING')
    self:RegisterEvent('MINIMAP_PING')

    local f = self.BaseFrame
    -- state
    Mixin(f, DragonflightUIStateHandlerMixin)
    f:InitStateHandler()
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
    -- print('event', event)
    if event == 'MINIMAP_PING' then
        --
        local arg1, arg2, arg3 = ...;
        self:HandlePing(arg1, arg2, arg3)
    elseif event == 'MINIMAP_UPDATE_TRACKING' then
        -- print('MINIMAP_UPDATE_TRACKING', GetTrackingTexture())
        self:UpdateTrackingEra()
    end
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

    local dfScale = 1.25
    f:SetScale(state.scale * dfScale)

    f:ClearAllPoints()
    f:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

    -- Module:UpdateMinimapZonePanelPosition(state.zonePanelPosition)

    self:UpdateMinimapShape()

    if state.hideCalendar then
        self.CalendarButtonFrame:Hide()
    else
        self.CalendarButtonFrame:Show()
    end

    if state.hideZoom then
        MinimapZoomIn:Hide()
        MinimapZoomOut:Hide()
    else
        MinimapZoomIn:Show()
        MinimapZoomOut:Show()
    end

    -- buttons
    if libIcon then
        local buttons = libIcon:GetButtonList()
        -- DevTools_Dump(buttons)

        for k, v in ipairs(buttons) do libIcon:ShowOnEnter(v, self.ModuleRef.db.profile.minimap.hideButtons) end
    end

    -- header
    do
        if state.hideHeader then
            self.InfoPanel:Hide()
            self.TopFrame:SetHeight(0.0000001)
            self.BottomFrame:SetHeight(0.0000001)
            self.BaseFrame:SetHeight(self.MinimalHeight)
        else
            self.InfoPanel:Show()
            self.BaseFrame:SetHeight(self.DefaultHeight)

            local pos = state.zonePanelPosition;
            if pos ~= 'TOP' and pos ~= 'BOTTOM' then pos = 'TOP' end

            if pos == 'TOP' then
                self.InfoPanel:SetPoint('CENTER', self.TopFrame, 'CENTER', 0, 0);
                self.TopFrame:SetHeight(18)
                self.BottomFrame:SetHeight(0.0000001)

                MiniMapMailFrame:ClearAllPoints()
                if DF.Wrath or DF.Cata or DF.API.Version.IsTBC then
                    MiniMapMailFrame:SetPoint('TOPRIGHT', MiniMapTracking, 'BOTTOMRIGHT', 2, -1)
                else
                    MiniMapMailFrame:SetPoint('RIGHT', self.InfoPanel, 'LEFT', 0, 0)
                end
            else
                self.InfoPanel:SetPoint('CENTER', self.BottomFrame, 'CENTER', 0, 0);
                self.BottomFrame:SetHeight(18)
                self.TopFrame:SetHeight(0.0000001)

                MiniMapMailFrame:ClearAllPoints()
                if DF.Wrath or DF.Cata or DF.API.Version.IsTBC then
                    MiniMapMailFrame:SetPoint('BOTTOMRIGHT', MiniMapTracking, 'TOPRIGHT', 2, 1)
                else
                    MiniMapMailFrame:SetPoint('RIGHT', self.InfoPanel, 'LEFT', 0, 0)
                end
            end

            -- 140
            local clockSpace;
            if state.hideClock then
                -- _G['TimeManagerClockButton']:Hide();
                C_CVar.SetCVar('showMinimapClock', 0)
                clockSpace = 0;
            else
                -- _G['TimeManagerClockButton']:Show();
                C_CVar.SetCVar('showMinimapClock', 1)
                clockSpace = 40;
            end
            -- _G['MinimapZoneTextButton']:SetWidth(140 - 4 - clockSpace - 4)

            local zoneTextSpace;
            if state.hideZoneText then
                _G['MinimapZoneTextButton']:Hide();
                zoneTextSpace = 0;
            else
                _G['MinimapZoneTextButton']:Show();
                zoneTextSpace = 100;
            end

            local w = clockSpace + zoneTextSpace;
            if w > 0 then
                self.InfoPanelBackground:Show()
                self.InfoPanel:SetWidth(w)
            else
                self.InfoPanelBackground:Hide()
                self.InfoPanel:SetWidth(0.0000001)
            end

            if w < 140 - 4 - 20 then
                --
                MiniMapMailFrame:ClearAllPoints()
                MiniMapMailFrame:SetPoint('RIGHT', MiniMapTracking, 'LEFT', 0, 0)
            end

        end
    end

    f:UpdateStateHandler(state)

    -- Module:ConditionalOption('skinButtons', 'minimap', 'Skin Minimap Buttons', function()
    --     Module.ChangeMinimapButtons()
    -- end)
end

local function refreshAllMinimapButtons()
    if not libIcon then return end
    libIcon:SetButtonRadius(5)
    -- local buttons = libIcon:GetButtonList()
    -- -- DevTools_Dump(buttons)

    -- for k, v in ipairs(buttons) do
    --     local btn = libIcon:GetMinimapButton(v)

    --     libIcon:Refresh(btn, nil);
    -- end
end

function SubModuleMixin:UpdateMinimapShape()
    local state = self.state;

    if state and state.shape == 'SQUARE' and not C_CVar.GetCVarBool("rotateMinimap") then
        Minimap:SetMaskTexture("Interface\\BUTTONS\\WHITE8X8")
        -- Minimap:SetSize(130, 130)
        self.MinimapBorder:Hide()
        self.MinimapBorderSquare:Show()
        function GetMinimapShape()
            return 'SQUARE';
        end
        refreshAllMinimapButtons()
    else
        Minimap:SetMaskTexture('Interface\\Addons\\DragonflightUI\\Textures\\tempportraitalphamask')
        -- Minimap:SetSize(140, 140)
        if not C_CVar.GetCVarBool("rotateMinimap") then
            self.MinimapBorder:Show()
        else
            self.MinimapBorder:Hide()
        end
        self.MinimapBorderSquare:Hide()
        function GetMinimapShape()
            return 'ROUND';
        end
        refreshAllMinimapButtons()
    end
end

function SubModuleMixin:CreateBaseFrame()
    local baseFrame = CreateFrame('Frame', 'DragonflightUIMinimapBase', UIParent);
    baseFrame:SetSize(178, 200);
    baseFrame:SetPoint('CENTER', UIParent, 'CENTER', 0 + 200, 0);
    baseFrame:SetClampedToScreen(true)
    self.BaseFrame = baseFrame;

    local topFrame = CreateFrame('Frame', 'DragonflightUIMinimapTop', baseFrame);
    topFrame:SetPoint('TOPLEFT', baseFrame, 'TOPLEFT', 0, 0);
    topFrame:SetPoint('TOPRIGHT', baseFrame, 'TOPRIGHT', 0, 0);
    topFrame:SetHeight(18);
    self.TopFrame = topFrame;

    local bottomFrame = CreateFrame('Frame', 'DragonflightUIMinimapBottom', baseFrame);
    bottomFrame:SetPoint('BOTTOMLEFT', baseFrame, 'BOTTOMLEFT', 0, 0);
    bottomFrame:SetPoint('BOTTOMRIGHT', baseFrame, 'BOTTOMRIGHT', 0, 0);
    -- bottomFrame:SetHeight(18);
    bottomFrame:SetHeight(0.0000001);
    self.BottomFrame = bottomFrame;

    local padding = 4;
    local midFrame = CreateFrame('Frame', 'DragonflightUIMinimapMid', baseFrame);
    midFrame:SetPoint('TOP', topFrame, 'BOTTOM', 0, -padding);
    -- midFrame:SetPoint('BOTTOM', bottomFrame, 'TOP', 0, padding);
    -- midFrame:SetWidth(140);
    midFrame:SetSize(140, 160)
    self.MidFrame = midFrame;

    self.DefaultHeight = 18 + padding + 160 + padding;
    self.MinimalHeight = padding + 160 + padding;

    baseFrame:SetHeight(self.DefaultHeight)
end

function SubModuleMixin:CreateInfoPanel()
    local f = CreateFrame('Frame', 'DragonflightUIMinimapInfoPanel', self.BaseFrame)
    f:SetSize(140, 18)
    f:SetPoint('CENTER', self.TopFrame, 'CENTER', 0, 0)
    self.InfoPanel = f;

    local background = f:CreateTexture('DragonflightUIMinimapInfoPanelBackground', 'ARTWORK')

    -- ["UI-HUD-Minimap-Button"]={19.5, 19, 0.861328, 0.9375, 0.392578, 0.429688, false, false, "2x"},
    local texture = 'Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x'
    background:SetTexture(texture)
    background:SetSize(39, 38)
    background:SetTexCoord(0.861328, 0.9375, 0.392578, 0.429688)

    background:SetPoint('TOPLEFT', f, 'TOPLEFT', 0, 0)
    background:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 0, 0)
    background:SetTextureSliceMode(1)
    background:SetTextureSliceMargins(20, 20, 25, 25)

    self.InfoPanelBackground = background;
end

function SubModuleMixin:ChangeZoneText()
    local btn = _G['MinimapZoneTextButton'];
    btn:ClearAllPoints()
    btn:SetHeight(16)
    btn:SetParent(self.InfoPanel)
    btn:SetPoint('LEFT', self.InfoPanel, 'LEFT', 4, 0)
    -- btn:SetPoint('RIGHT', self.InfoPanel, 'RIGHT', -4 - 40, 0)
    -- btn:SetWidth(self.InfoPanel:GetWidth() - 4 - 40)
    btn:SetWidth(140 - 4 - 40 - 4) -- 92

    local text = _G['MinimapZoneText']
    text:ClearAllPoints()
    text:SetSize(130, 10)
    text:SetPoint('LEFT', btn, 'LEFT', 1, 0)
    text:SetPoint('RIGHT', btn, 'RIGHT', -1, 0)
    -- MinimapZoneText:SetFontObject(GameFontSmall)
    -- MinimapZoneText:SetJustifyH('CENTER')
    -- MinimapZoneText:SetJustifyV('MIDDLE')
    local path, size, flags = text:GetFont()
    text:SetFont(path, 12 - 2, flags)
end

function SubModuleMixin:ChangeClock()
    local loaded, reason = DF:LoadAddOn('Blizzard_TimeManager')

    local btn = _G['TimeManagerClockButton']
    local regions = {btn:GetRegions()}
    regions[1]:Hide()
    btn:ClearAllPoints()
    btn:SetSize(40, 16)
    btn:SetPoint('RIGHT', self.InfoPanel, 'RIGHT', 0, 0)
    btn:SetParent(self.InfoPanel)

    btn:HookScript('OnEnter', function()
        TimeManagerClockButton_UpdateTooltip()
    end)

    local ticker = _G['TimeManagerClockTicker']
    local path, size, flags = ticker:GetFont()
    ticker:SetFont(path, 10 - 1, flags)

    TimeManagerAlarmFiredTexture:SetPoint("TOPLEFT", btn, "TOPLEFT", 0, 5)
    TimeManagerAlarmFiredTexture:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -2, -11)

    TimeManagerFrame:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', -10, -190 - 30)
end

function SubModuleMixin:ChangeTracking()
    if DF.Era then
        self:ChangeTrackingEra()
        self:UpdateTrackingEra()
        return;
    end

    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x'

    local tracking = _G['MiniMapTracking']
    local trackingIcon = _G['MiniMapTrackingIcon']
    local trackingBG = _G['MiniMapTrackingBackground']
    local btn = _G['MiniMapTrackingButton']
    local btnBorder = _G['MiniMapTrackingButtonBorder']

    tracking:ClearAllPoints()
    tracking:SetPoint('RIGHT', self.InfoPanel, 'LEFT', -1, 0)
    tracking:SetSize(18, 18)
    tracking:SetFrameStrata('MEDIUM')
    tracking:SetParent(self.InfoPanel)
    trackingIcon:Hide()

    trackingBG:ClearAllPoints()
    trackingBG:SetPoint('CENTER', tracking, 'CENTER')
    trackingBG:SetSize(18, 18)
    trackingBG:SetTexture(base)
    trackingBG:SetTexCoord(0.861328125, 0.9375, 0.392578125, 0.4296875)

    btnBorder:Hide()

    btn:SetSize(14, 15)
    btn:ClearAllPoints()
    btn:SetPoint('CENTER', tracking, 'CENTER')
    btn:SetParent(self.InfoPanel)

    -- ["UI-HUD-Minimap-Tracking-Down"]={16, 15, 0.162109, 0.224609, 0.507812, 0.537109, false, false, "2x"},
    -- ["UI-HUD-Minimap-Tracking-Mouseover"]={15, 14, 0.228516, 0.287109, 0.507812, 0.535156, false, false, "2x"},
    -- ["UI-HUD-Minimap-Tracking-Up"]={15, 14, 0.291016, 0.349609, 0.507812, 0.535156, false, false, "2x"},

    btn:SetNormalTexture(base)
    btn:GetNormalTexture():SetTexCoord(0.291016, 0.349609, 0.507812, 0.535156)
    btn:SetHighlightTexture(base)
    btn:GetHighlightTexture():SetTexCoord(0.228516, 0.287109, 0.507812, 0.535156)
    btn:SetPushedTexture(base)
    -- MiniMapTrackingButton:GetPushedTexture():SetTexCoord(0.162109, 0.224609, 0.507812, 0.537109)
    btn:GetPushedTexture():SetTexCoord(0.228516, 0.287109, 0.507812, 0.535156)
end

local MiniMapTrackingFrame = MiniMapTrackingFrame or MiniMapTracking
function SubModuleMixin:ChangeTrackingEra()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\'

    local updatePos = function()
        -- print('updatePos')
        MiniMapTrackingFrame:ClearAllPoints()
        MiniMapTrackingFrame:SetPoint('CENTER', Minimap, 'CENTER', -52.56, 53.51)
        MiniMapTrackingFrame:SetParent(Minimap)
    end

    updatePos()
    MiniMapTrackingFrame:SetSize(31, 31)
    MiniMapTrackingFrame:SetFrameStrata('MEDIUM')
    -- MiniMapTrackingFrame:SetScale(0.75)
    -- MiniMapTrackingFrame:SetScale(1.15)

    local bg = MiniMapTrackingFrame:CreateTexture('DragonflightUITrackingFrameBackground', 'BACKGROUND')
    bg:SetSize(24, 24)
    bg:SetTexture(base .. 'ui-minimap-background')
    bg:ClearAllPoints()
    bg:SetPoint("CENTER", MiniMapTrackingFrame, "CENTER")

    MiniMapTrackingBorder:SetSize(50, 50)
    MiniMapTrackingBorder:SetTexture(base .. 'minimap-trackingborder')
    MiniMapTrackingBorder:ClearAllPoints()
    MiniMapTrackingBorder:SetPoint("TOPLEFT", MiniMapTrackingFrame, "TOPLEFT")

    MiniMapTrackingIcon:SetSize(20, 20)
    MiniMapTrackingIcon:ClearAllPoints()
    MiniMapTrackingIcon:SetPoint("CENTER", MiniMapTrackingFrame, "CENTER", 0, 0)

    hooksecurefunc('SetLookingForGroupUIAvailable', function()
        --
        -- print('SetLookingForGroupUIAvailable')
        updatePos()
    end)
end

function SubModuleMixin:UpdateTrackingEra()
    local icon = GetTrackingTexture();
    if (icon) then
        -- MiniMapTrackingIcon:SetTexture(icon);
        SetPortraitToTexture(MiniMapTrackingIcon, icon)
        MiniMapTrackingFrame:Show();
    else
        MiniMapTrackingFrame:Hide();
    end
end

function SubModuleMixin:ChangeZoom()
    local dx, dy = 5, 90
    MinimapZoomIn:SetScale(0.55)
    MinimapZoomIn:SetPoint('CENTER', Minimap, 'RIGHT', -dx, -dy)
    MinimapZoomIn:SetNormalTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomIn:GetNormalTexture():SetTexCoord(0.001953125, 0.068359375, 0.5390625, 0.572265625)
    -- MinimapZoomIn:SetPushedTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap')
    -- MinimapZoomIn:GetPushedTexture():SetTexCoord(0.001953125, 0.068359375, 0.57421875, 0.607421875)
    MinimapZoomIn:SetPushedTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomIn:GetPushedTexture():SetTexCoord(0.001953125, 0.068359375, 0.5390625, 0.572265625)
    MinimapZoomIn:SetDisabledTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomIn:GetDisabledTexture():SetTexCoord(0.001953125, 0.068359375, 0.5390625, 0.572265625)
    MinimapZoomIn:GetDisabledTexture():SetDesaturated(1)
    MinimapZoomIn:SetHighlightTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomIn:GetHighlightTexture():SetTexCoord(0.001953125, 0.068359375, 0.5390625, 0.572265625)

    MinimapZoomOut:SetScale(0.55)
    MinimapZoomOut:SetPoint('CENTER', Minimap, 'BOTTOM', dy, dx)
    MinimapZoomOut:SetNormalTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomOut:GetNormalTexture():SetTexCoord(0.353515625, 0.419921875, 0.5, 0.533203125)
    MinimapZoomOut:SetPushedTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomOut:GetPushedTexture():SetTexCoord(0.353515625, 0.419921875, 0.5, 0.533203125)
    MinimapZoomOut:SetDisabledTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomOut:GetDisabledTexture():SetTexCoord(0.353515625, 0.419921875, 0.5, 0.533203125)
    MinimapZoomOut:GetDisabledTexture():SetDesaturated(1)
    MinimapZoomOut:SetHighlightTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomOut:GetHighlightTexture():SetTexCoord(0.353515625, 0.419921875, 0.5, 0.533203125)
end

function SubModuleMixin:HookMouseWheel()
    Minimap:SetScript('OnMouseWheel', function(self, delta)
        if (delta == -1) then
            MinimapZoomIn:Enable()
            -- PlaySound(SOUNDKIT.IG_MINIMAP_ZOOM_OUT);
            Minimap:SetZoom(math.max(Minimap:GetZoom() - 1, 0))
            if (Minimap:GetZoom() == 0) then MinimapZoomOut:Disable() end
        elseif (delta == 1) then
            MinimapZoomOut:Enable()
            -- PlaySound(SOUNDKIT.IG_MINIMAP_ZOOM_IN);
            Minimap:SetZoom(math.min(Minimap:GetZoom() + 1, Minimap:GetZoomLevels() - 1))
            if (Minimap:GetZoom() == (Minimap:GetZoomLevels() - 1)) then MinimapZoomIn:Disable() end
        end
    end)
end

function SubModuleMixin:HideDefaultStuff()
    _G['MinimapBorder']:Hide()
    if _G['MinimapBorderTop'] then _G['MinimapBorderTop']:Hide() end

    if _G['MinimapCluster'].BorderTop then _G['MinimapCluster'].BorderTop:Hide() end -- tbc

    if MinimapToggleButton then MinimapToggleButton:Hide() end

    -- Hide WorldMapButton
    if MiniMapWorldMapButton then
        MiniMapWorldMapButton:Hide()
        hooksecurefunc(MiniMapWorldMapButton, 'Show', function()
            MiniMapWorldMapButton:Hide()
        end)
    end
    -- Hide North Tag
    MinimapNorthTag:Hide()
    hooksecurefunc(MinimapNorthTag, 'Show', function()
        MinimapNorthTag:Hide()
    end)
end

function SubModuleMixin:ChangeCalendar()
    GameTimeFrame:ClearAllPoints()
    -- GameTimeFrame:SetPoint('CENTER', MinimapCluster, 'TOPRIGHT', -16, -20)
    GameTimeFrame:SetPoint('LEFT', self.InfoPanel, 'RIGHT', 0, -2)
    GameTimeFrame:Hide()

    local f = CreateFrame('Frame', 'DragonflightUICalendarButtonFrame', self.InfoPanel)
    f:SetSize(18, 18)
    f:SetPoint('LEFT', self.InfoPanel, 'RIGHT', 1, 0)

    local bg = f:CreateTexture('DragonflightUICalendarButtonFrameBackground', "BACKGROUND")
    bg:SetPoint('TOPLEFT')
    bg:SetPoint('BOTTOMRIGHT')
    bg:SetSize(18, 18)
    bg:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    bg:SetTexCoord(0.861328125, 0.9375, 0.392578125, 0.4296875)

    local button = CreateFrame('Button', 'DragonflightUICalendarButton', f, 'SecureActionButtonTemplate')
    button:SetSize(18, 18)
    button:SetPoint('CENTER')

    if DF.Wrath then
        button:SetAttribute('type', 'macro')
        button:SetAttribute('macrotext', '/click GameTimeFrame')
    elseif DF.Era then
        button:SetScript('OnClick', function()
            self.ModuleRef:Print(
                "Era doesn't have an ingame Calendar, sorry. Consider using 'Classic Calendar' by 'Toxiix', and this button will magically work...")
        end)
    end

    local microTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\Micromenu\\uimicromenu2x'
    button:SetNormalTexture(microTexture)
    button:SetPushedTexture(microTexture)
    button:SetHighlightTexture(microTexture)
    -- button:GetNormalTexture():SetTexCoord(0.258789, 0.321289, 0.822266, 0.982422)
    -- button:GetHighlightTexture():SetTexCoord(0.258789, 0.321289, 0.658203, 0.818359)
    -- -- button:GetPushedTexture():SetTexCoord(0.194336, 0.256836, 0.822266, 0.982422)
    -- button:GetPushedTexture():SetTexCoord(0.258789, 0.321289, 0.822266, 0.982422)

    button:GetNormalTexture():SetTexCoord(0.258789, 0.321289, 0.494141, 0.654297)
    button:GetHighlightTexture():SetTexCoord(0.258789, 0.321289, 0.330078, 0.490234)
    button:GetHighlightTexture():SetVertexColor(1, 1, 0, 0.5)
    button:GetPushedTexture():SetTexCoord(0.258789, 0.321289, 0.494141, 0.654297)

    local text = button:CreateFontString('DragonflightUICalendarButtonText', 'ARTWORK', 'GameFontBlackSmall')
    text:SetText('12')
    text:SetPoint('CENTER', 0, 0.5)
    text:SetJustifyH("CENTER")
    text:SetJustifyV("MIDDLE")

    local path, size, flags = text:GetFont()
    text:SetFont(path, 10 - 4, flags)

    self.CalendarButtonFrame = f
    self.CalendarButtonText = text

    local function UpdateCalendar()
        local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime()
        local day = currentCalendarTime.monthDay
        self.CalendarButtonText:SetText(tostring(day))
    end
    UpdateCalendar()

    hooksecurefunc(TimeManagerClockTicker, 'SetText', function()
        UpdateCalendar()
    end)

    if DF.Cata then
        -- GameTimeCalendarInvitesTexture + Glow
        GameTimeCalendarInvitesTexture:ClearAllPoints()
        GameTimeCalendarInvitesTexture:SetParent(button)
        GameTimeCalendarInvitesTexture:SetPoint('CENTER', text, 'CENTER', 0, 0)
        GameTimeCalendarInvitesTexture:SetSize(18, 18)
        GameTimeCalendarInvitesTexture:SetScale(1)
        GameTimeCalendarInvitesTexture:SetDrawLayer('OVERLAY', 2)

        local glowSize = 18 + 10
        GameTimeCalendarInvitesGlow:ClearAllPoints()
        GameTimeCalendarInvitesGlow:SetParent(button)
        GameTimeCalendarInvitesGlow:SetPoint('CENTER', text, 'CENTER', 0, 0)
        GameTimeCalendarInvitesGlow:SetSize(glowSize, glowSize)
        GameTimeCalendarInvitesGlow:SetScale(1)
        GameTimeCalendarInvitesGlow:SetDrawLayer('OVERLAY', 1)

        local PI = PI;
        local TWOPI = PI * 2.0;
        local cos = math.cos;
        local INVITE_PULSE_SEC = 1.0 / (2.0 * 1.0); -- mul by 2 so the pulse constant counts for half a flash

        local ref = self;
        ref.minimapFlashTimer = 0.0

        Minimap:HookScript('OnUpdate', function(self, elapsed)
            -- Flashing stuff, from GameTime.lua line 112++
            if (elapsed and GameTimeFrame.flashInvite) then
                local flashIndex = TWOPI * ref.minimapFlashTimer * INVITE_PULSE_SEC;
                local flashValue = max(0.0, 0.5 + 0.5 * cos(flashIndex));
                if (flashIndex >= TWOPI) then
                    ref.minimapFlashTimer = 0.0;
                else
                    ref.minimapFlashTimer = ref.minimapFlashTimer + elapsed;
                end

                GameTimeCalendarInvitesTexture:SetAlpha(flashValue);
                GameTimeCalendarInvitesGlow:SetAlpha(flashValue);
            end
        end)
    end
end

function SubModuleMixin:SetupMinimap()
    Minimap:ClearAllPoints()
    Minimap:SetPoint('CENTER', self.MidFrame, 'CENTER', 0, 0)
    Minimap:SetParent(self.BaseFrame)

    local texture = Minimap:CreateTexture('DragonflightUIMinimapBorder', 'ARTWORK')
    texture:SetDrawLayer('ARTWORK', 7)
    texture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    texture:SetTexCoord(0.001953125, 0.857421875, 0.056640625, 0.505859375)
    texture:SetPoint('CENTER', Minimap, 'CENTER', 1, 0)
    self.MinimapBorder = texture

    local delta = 22
    local dx = 6
    texture:SetSize(140 + delta - dx, 140 + delta)
    -- texture:SetScale(0.88)

    local textureSquare = Minimap:CreateTexture('DragonflightUIMinimapBorderSquare', 'ARTWORK')
    textureSquare:SetDrawLayer('ARTWORK', 7)
    textureSquare:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\MinimapSquareJag')
    -- textureSquare:SetTexCoord(0.001953125, 0.857421875, 0.056640625, 0.505859375)
    local dSquare = 13;
    textureSquare:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', -dSquare, dSquare + 1)
    textureSquare:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', dSquare, -dSquare + 1)

    self.MinimapBorderSquare = textureSquare

    -- MinimapCompassTexture:SetDrawLayer('ARTWORK', 7)
    MinimapCompassTexture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapCompassTexture:SetTexCoord(0.001953125, 0.857421875, 0.056640625, 0.505859375)
    MinimapCompassTexture:SetSize(140 + delta - dx, 140 + delta)
    MinimapCompassTexture:SetScale(1)
    MinimapCompassTexture:ClearAllPoints()
    MinimapCompassTexture:SetPoint('CENTER', Minimap, 'CENTER', 1, 0)

    hooksecurefunc(MinimapCompassTexture, 'Show', function()
        self.MinimapBorder:Hide()
        self.MinimapBorderSquare:Hide()
    end)

    hooksecurefunc(MinimapCompassTexture, 'Hide', function()
        if self.state and self.state.shape == 'SQUARE' then
            self.MinimapBorder:Hide()
            self.MinimapBorderSquare:Show()
        else
            self.MinimapBorder:Show()
            self.MinimapBorderSquare:Hide()
        end
    end)
end

function SubModuleMixin:ChangeMail()
    MiniMapMailBorder:Hide()
    MiniMapMailIcon:Hide()
    -- MiniMapMailFrame:SetPoint('TOPRIGHT', Minimap, 'TOPRIGHT', 24 - 5, -52 + 25)
    MiniMapMailFrame:SetSize(19.5, 15)

    if DF.Wrath or DF.Cata then
        MiniMapMailFrame:SetPoint('TOPRIGHT', MiniMapTracking, 'BOTTOMRIGHT', 2, -1)
    else
        -- MiniMapMailFrame:SetPoint('TOPRIGHT', _G['DragonflightUIMinimapTop'], 'BOTTOMLEFT', 2, -1)
        MiniMapMailFrame:ClearAllPoints()
        MiniMapMailFrame:SetPoint('RIGHT', self.InfoPanel, 'LEFT', 0, 0)
    end

    MiniMapMailFrame:SetParent(self.InfoPanel)

    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x'

    local mail = MiniMapMailFrame:CreateTexture('DragonflightUIMinimapMailFrame', 'ARTWORK')
    mail:ClearAllPoints()
    mail:SetTexture(base)
    mail:SetTexCoord(0.08203125, 0.158203125, 0.5078125, 0.537109375)
    mail:SetSize(19.5, 15)
    mail:SetPoint('CENTER', MiniMapMailFrame, 'CENTER', -3, 0)
    mail:SetScale(1)
end

function SubModuleMixin:ChangeDifficulty()
    if not MiniMapInstanceDifficulty then return end
    MiniMapInstanceDifficulty:ClearAllPoints()
    MiniMapInstanceDifficulty:SetPoint('TOPRIGHT', self.InfoPanel, 'BOTTOMRIGHT', 0, 0)
    MiniMapInstanceDifficulty:SetParent(self.InfoPanel)
end

function SubModuleMixin:UpdateButton(btn)
    if not btn then return end
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\'
    local children = {btn:GetRegions()}

    for i, child in ipairs(children) do
        --            
        if child:GetObjectType() == 'Texture' then
            --
            local tex = child:GetTexture()
            -- print('child=texture', tex)

            if tex == 136477 then
                -- highlight
                child:SetTexture(base .. 'ui-minimap-zoombutton-highlight')
            elseif tex == 136430 then
                -- overlay
                ----"Interface\\Minimap\\MiniMap-TrackingBorder"                  
                child:SetSize(50, 50)
                child:SetTexture(base .. 'minimap-trackingborder')
                child:ClearAllPoints()
                child:SetPoint("TOPLEFT", btn, "TOPLEFT")

                btn.DFTrackingBorder = child
            elseif tex == 136467 then
                -- background
                ----"Interface\\Minimap\\UI-Minimap-Background"
                child:SetSize(24, 24)
                child:SetTexture(base .. 'ui-minimap-background')
                child:ClearAllPoints()
                child:SetPoint("CENTER", btn, "CENTER")
            else
                --
            end
        end
    end
    -- icon
    if btn.icon then
        btn.icon:SetSize(20, 20)
        btn.icon:ClearAllPoints()
        btn.icon:SetPoint("CENTER", btn, "CENTER", 0, 0)

        if not btn.DFMask then
            btn.DFMask = btn:CreateMaskTexture()
            btn.DFMask:SetTexture(base .. 'tempportraitalphamask')
            local delta = 0;
            btn.DFMask:SetPoint('TOPLEFT', btn.icon, 'TOPLEFT', delta, -delta)
            btn.DFMask:SetPoint('BOTTOMRIGHT', btn.icon, 'BOTTOMRIGHT', -delta, delta)
            btn.icon:AddMaskTexture(btn.DFMask)
        end
        -- btn.icon:Hide()
    end
end

function SubModuleMixin:ChangeMinimapButtons()
    -- print('Module.ChangeMinimapButtons()')
    if not libIcon then return end

    hooksecurefunc(libIcon, 'Register', function(_, name, object, db, customCompartmentIcon)
        --
        -- print('register', name, object, db, customCompartmentIcon)
        local btn = libIcon:GetMinimapButton(name)
        if btn then
            --
            self:UpdateButton(btn)
            libIcon:ShowOnEnter(v, self.ModuleRef.db.profile.minimap.hideButtons)
        end
    end)

    local buttons = libIcon:GetButtonList()
    -- DevTools_Dump(buttons)

    for k, v in ipairs(buttons) do
        local btn = libIcon:GetMinimapButton(v)

        if btn then
            --
            self:UpdateButton(btn)
            libIcon:ShowOnEnter(v, self.ModuleRef.db.profile.minimap.hideButtons)
        end
    end

    if MiniMapBattlefieldFrame then self:UpdateButton(MiniMapBattlefieldFrame) end
end

function SubModuleMixin:HandlePing(unit, y, x)
    -- print('HandlePing', unit, y, x, UnitIsVisible(unit))

    if not UnitIsVisible(unit) then return end

    local unitName = UnitName(unit);

    local state = self.ModuleRef.db.profile.minimap;

    if state.showPing then
        --
    end

    if state.showPingChat then
        --
        DF:Print('<Ping>', unitName or '<unknown>');
    end
end

