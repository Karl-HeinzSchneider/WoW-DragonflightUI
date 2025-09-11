local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local subModuleName = 'MirrorTimer';
local SubModuleMixin = {};
addonTable.SubModuleMixins[subModuleName] = SubModuleMixin;

local numMirrorTimerTypes = 3;

local timerSettingsTable = {
    [1] = {timer = 'EXHAUSTION', tex = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarStandard2'},
    [2] = {timer = 'BREATH', tex = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarCrafting2'},
    [3] = {timer = 'DEATH', tex = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarStandard2'},
    [4] = {timer = 'FEIGNDEATH', tex = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarChannel'}
}

function SubModuleMixin:Init()
    self.ModuleRef = DF:GetModule('Castbar')
    self:SetDefaults()
    self:SetupOptions()
    -- self:SetScript('OnEvent', self.OnEvent);
end

function SubModuleMixin:SetDefaults()
    local defaults = {
        activate = true,
        -- anchor
        scale = 1.0,
        anchorFrame = 'UIParent',
        customAnchorFrame = '',
        anchor = 'TOP',
        anchorParent = 'TOP',
        x = 0,
        y = -100,
        --
        hideBlizzard = true
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
        args = {
            headerStyling = {
                type = 'header',
                name = L["PetFrameStyle"],
                desc = '',
                order = 20,
                isExpanded = true,
                editmode = true
            },
            hideBlizzard = {
                type = 'toggle',
                name = L["CastbarMirrorHideBlizzard"],
                desc = L["CastbarMirrorHideBlizzardDesc"] .. getDefaultStr('hideBlizzard', 'mirrorTimer'),
                group = 'headerStyling',
                order = 9,
                editmode = true
            },
            activate = {
                type = 'toggle',
                name = L["ButtonTableActive"],
                desc = L["ButtonTableActiveDesc"] .. getDefaultStr('activate', 'mirrorTimer'),
                order = -1,
                new = false,
                editmode = true
            }
        }
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
    self.Timers = {}
    self.TimersByType = {}
    self.activeTimers = {}

    self.DFEditMode = false;

    self:CreateBase()
    self:CreateMirrorTimers(numMirrorTimerTypes + 1)

    self:SetScript('OnEvent', self.OnEvent);
    self:RegisterEvent('MIRROR_TIMER_START')
    self:RegisterEvent('MIRROR_TIMER_PAUSE')
    self:RegisterEvent('MIRROR_TIMER_STOP')
    self:RegisterEvent('PLAYER_ENTERING_WORLD')

    -- 
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
    -- print(event, ...)
    -- print('edit?', self.DFEditMode)

    if self.DFEditMode then
        --
        return;
    end

    if event == 'PLAYER_ENTERING_WORLD' then
        --
        for i = 1, numMirrorTimerTypes do
            local timer, value, maxvalue, _, paused, label = GetMirrorTimerInfo(i);
            if timer ~= "UNKNOWN" then
                --
                self:SetupTimer(timer, value, maxvalue, paused, label);
            end
        end

    elseif event == "MIRROR_TIMER_START" then
        local timer, value, maxvalue, _, paused, label = ...;
        self:SetupTimer(timer, value, maxvalue, paused, label);
    elseif event == "MIRROR_TIMER_STOP" then
        local timer = ...;
        self:ClearTimer(timer);
    elseif event == "MIRROR_TIMER_PAUSE" then
        local timer, paused = ...;
        local activeTimer = self:GetActiveTimer(timer);
        if activeTimer then activeTimer:SetPaused(paused); end
    end

    self:UpdateLayout()
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

    if state.activate or self.DFEditMode then
        self.VisFrame:Show()
    else
        self.VisFrame:Hide()
    end
    self.VisFrame:SetScale(state.scale)

    if state.hideBlizzard then
        for i = 1, 3 do
            _G['MirrorTimer' .. i]:UnregisterEvent('MIRROR_TIMER_PAUSE')
            _G['MirrorTimer' .. i]:UnregisterEvent('MIRROR_TIMER_STOP')
            _G['MirrorTimer' .. i]:UnregisterEvent('PLAYER_ENTERING_WORLD')
            _G['MirrorTimer' .. i]:Hide()
        end
        UIParent:UnregisterEvent('MIRROR_TIMER_START')
    else
        for i = 1, 3 do
            _G['MirrorTimer' .. i]:RegisterEvent('MIRROR_TIMER_PAUSE')
            _G['MirrorTimer' .. i]:RegisterEvent('MIRROR_TIMER_STOP')
            _G['MirrorTimer' .. i]:RegisterEvent('PLAYER_ENTERING_WORLD')
        end
        UIParent:RegisterEvent('MIRROR_TIMER_START')
    end
end

function SubModuleMixin:CreateBase()
    local baseFrame = CreateFrame('Frame', 'DragonflightUIMirrorTimerBase', UIParent);
    baseFrame:SetSize(190, 120);
    baseFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0);
    baseFrame:SetClampedToScreen(true)
    baseFrame:Hide()
    self.BaseFrame = baseFrame;

    local visFrame = CreateFrame('Frame', nil, UIParent)
    self.VisFrame = visFrame;

    local function SetEditMode(editmode)
        -- print('~> SetEditMode', editmode)
        self.DFEditMode = editmode

        self:ClearAllTimer()
        for i = 1, 4 do
            local bar = self.Timers[i];
            if bar then
                --
                bar:SetEditMode(editmode)
            end
        end

        if editmode then
            self.VisFrame:Show()
        else
            self:OnEvent('PLAYER_ENTERING_WORLD')

            local state = self.ModuleRef.db.profile.mirrorTimer
            if state.activate then
                self.VisFrame:Show()
            else
                self.VisFrame:Hide()
            end
        end
        self:UpdateLayout()
        baseFrame:SetShown(editmode)
    end

    function baseFrame:SetEditMode(editmode)
        SetEditMode(editmode)
    end
end

function SubModuleMixin:CreateMirrorTimers(howMany)
    for i = 1, howMany do
        --
        local bar = CreateFrame('StatusBar', 'DragonflightUIMirrorTimer' .. i, self.VisFrame,
                                'DragonflightUIMirrorCastbarTemplate')
        self.Timers[i] = bar;
        -- if i == 1 then
        --     bar:SetPoint('TOP', self.BaseFrame, 'TOP', 0, 0);
        -- else
        --     bar:SetPoint('TOP', self.Timers[i - 1], 'BOTTOM', 0, -20);
        -- end
        bar:ClearAllPoints()
        bar:SetPoint('TOP', self.BaseFrame, 'TOP', 0, -(i - 1) * 30);

        local data = timerSettingsTable[i];
        bar:SetStatusBarTexture(data.tex)
        self.TimersByType[data.timer] = bar;

        bar:SetSize(190, 10)
    end
end

function SubModuleMixin:UpdateLayout()
    local deltaMult = 1;
    for i = 1, 4 do
        local bar = self.Timers[i];
        if bar then
            bar:ClearAllPoints()
            if bar:IsShown() then
                -- print('IsShown', i)
                bar:SetPoint('TOP', self.BaseFrame, 'TOP', 0, -4 - (deltaMult - 1) * 30);
                deltaMult = deltaMult + 1;
            end
        end
    end

end

function SubModuleMixin:ClearAllTimer()
    for k, v in pairs(self.activeTimers) do
        --
        v:Clear()
        self.activeTimers[k] = nil;
    end
end

function SubModuleMixin:SetupTimer(timer, value, maxvalue, paused, label)
    local availableTimerFrame = self.TimersByType[timer];
    if not availableTimerFrame then return; end

    availableTimerFrame:Setup(timer, value, maxvalue, paused, label);
    self.activeTimers[timer] = availableTimerFrame;
end

function SubModuleMixin:ClearTimer(timer)
    local activeTimer = self.activeTimers[timer];
    if activeTimer then
        activeTimer:Clear();
        self.activeTimers[timer] = nil;
    end
end

function SubModuleMixin:GetActiveTimer(timer)
    return self.activeTimers[timer];
end
