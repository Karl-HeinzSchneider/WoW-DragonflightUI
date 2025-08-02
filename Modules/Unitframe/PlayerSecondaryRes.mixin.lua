local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local subModuleName = 'PlayerFrameSecondaryRes';
local SubModuleMixin = {};
addonTable.SubModuleMixins[subModuleName] = SubModuleMixin;

function SubModuleMixin:Init()
    self.ModuleRef = DF:GetModule('Unitframe')
    self:SetDefaults()
    self:SetupOptions()
end

function SubModuleMixin:SetDefaults()
    local defaults = {
        activate = true,
        scale = 1.0,
        anchorFrame = 'PlayerFrame',
        customAnchorFrame = '',
        anchor = 'TOPRIGHT',
        anchorParent = 'BOTTOMRIGHT',
        x = -7, -- -9
        y = 35
        -- Visibility
        -- alphaNormal = 1.0,
        -- alphaCombat = 1.0,
        -- showMouseover = false,
        -- hideAlways = false,
        -- hideCombat = false,
        -- hideOutOfCombat = false,
        -- hideVehicle = false,
        -- hidePet = false,
        -- hideNoPet = false,
        -- hideStance = false,
        -- hideStealth = false,
        -- hideNoStealth = false,
        -- hideBattlePet = false,
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

    local optionsPlayer = {
        name = L["PlayerSecondaryResName"],
        desc = L["PlayerSecondaryResNameDesc"],
        advancedName = 'PlayerSecondaryRes',
        sub = "playerSecondaryRes",
        get = getOption,
        set = setOption,
        type = 'group',
        args = {
            activate = {
                type = 'toggle',
                name = L["ButtonTableActive"],
                desc = L["ButtonTableActiveDesc"] .. getDefaultStr('activate', 'playerSecondaryRes'),
                order = -1,
                new = false,
                editmode = true
            }
        }
    }

    DF.Settings:AddPositionTable(Module, optionsPlayer, 'playerSecondaryRes', 'playerSecondaryRes', getDefaultStr,
                                 frameTable)

    -- DragonflightUIStateHandlerMixin:AddStateTable(Module, optionsPlayer, 'playerSecondaryRes', 'playerSecondaryRes',
    --                                               getDefaultStr)
    local optionsPlayerEditmode = {
        name = 'Player',
        desc = 'PlayerframeDesc',
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
                    local dbTable = Module.db.profile.playerSecondaryRes
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

    self.Options = optionsPlayer;
    self.OptionsEditmode = optionsPlayerEditmode;
end

function SubModuleMixin:Setup()
    local function setDefaultSubValues(sub)
        self.ModuleRef:SetDefaultSubValues(sub)
    end

    DF.ConfigModule:RegisterSettingsData('playerSecondaryRes', 'unitframes', {
        options = self.Options,
        default = function()
            setDefaultSubValues('playerSecondaryRes')
        end
    })
    --
    self:CreateSecondaryResFrame()
    self:HookSecondaryRes()

    self:SetScript('OnEvent', self.OnEvent);
    self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')

    -- if DF.API.Version.IsCata then self:RegisterEvent('PLAYER_LEVEL_UP'); end

    -- state handler
    -- Mixin(PlayerFrame, DragonflightUIStateHandlerMixin)
    -- PlayerFrame:InitStateHandler()

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
            setDefaultSubValues('playerSecondaryRes')
        end,
        moduleRef = self.ModuleRef,
        showFunction = function()
            --         
            -- fakeWidget.FakePreview:Show()
        end,
        hideFunction = function()
            --
            fakeWidget:Show()
        end
    });

end

function SubModuleMixin:OnEvent(event, ...)
    if event == 'PLAYER_SPECIALIZATION_CHANGED' then
        self:Update();
    elseif event == 'PLAYER_LEVEL_UP' then
        -- local level = ...;
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

    if parent == PlayerFrame then
        f:SetParent(parent)
        f:SetScale(state.scale)

        -- taint from parent
        if DF.API.Version.IsMoP then
            _G['PriestBarFrame']:SetIgnoreParentScale(false)
            _G['PriestBarFrame']:SetScale(1.0)
        end
    else
        f:SetParent(UIParent)
        -- f:SetScale(PlayerFrame:GetScale() * state.scale)
        f:SetScale(state.scale)

        -- taint from parent
        if DF.API.Version.IsMoP then
            _G['PriestBarFrame']:SetIgnoreParentScale(true)
            _G['PriestBarFrame']:SetScale(UIParent:GetEffectiveScale() * state.scale)
        end
    end

    f:ClearAllPoints()
    f:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    -- f:SetUserPlaced(true)

    self:HideSecondaryRes(not state.activate)

    -- f:UpdateStateHandler(state)
end

function SubModuleMixin:CreateSecondaryResFrame()
    local fakeWidget = CreateFrame('Frame', 'DragonflightUIPlayerSecondaryRessourceFrame', UIParent)
    fakeWidget:SetSize(125, 40)
    fakeWidget.unit = 'player'
    self.PreviewFrame = fakeWidget

    -- if DF.Wrath then RuneFrame:SetPoint('TOP', PlayerFrame, 'BOTTOM', 54 - 3, 34 - 3) end

    -- if DF.Cata then PaladinPowerBar:SetPoint('TOP', PlayerFrame, 'BOTTOM', 43, 39 - 2) end

    -- if DF.API.Version.IsCata then ShardBarFrame:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50, 34 - 1) end
    -- if DF.API.Version.IsMoP then
    -- _G['MonkHarmonyBar']:SetPoint('TOP', 49 - 5, -46);
    -- _G['WarlockPowerFrame']:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50, 34 - 3);
    -- _G['ShardBarFrame']:SetPoint('TOPLEFT', _G['WarlockPowerFrame'], 'TOPLEFT', 0, 0 + 2)
    -- _G['BurningEmbersBarFrame']:SetPoint('TOPLEFT', _G['WarlockPowerFrame'], 'TOPLEFT', -21, 1 + 2)
    -- _G['PriestBarFrame']:SetPoint('TOP', PlayerFrame, 'BOTTOM', 53 - 3, 37 - 1)
    -- end

    if DF.Wrath then
        _G['RuneFrame']:SetWidth(123)
        _G['RuneFrame']:ClearAllPoints()
        _G['RuneFrame']:SetParent(self.PreviewFrame)
        _G['RuneFrame']:SetPoint('TOP', self.PreviewFrame, 'TOP', 0, -6)

    end

    if DF.Cata then
        _G['PaladinPowerBar']:SetParent(self.PreviewFrame)
        _G['PaladinPowerBar']:ClearAllPoints()
        _G['PaladinPowerBar']:SetPoint('TOP', self.PreviewFrame, 'TOP', 0, 5)

        _G['EclipseBarFrame']:SetParent(self.PreviewFrame)
        _G['EclipseBarFrame']:ClearAllPoints()
        _G['EclipseBarFrame']:SetPoint('TOP', self.PreviewFrame, 'TOP', 0, -1)
    end

    if DF.API.Version.IsCata then
        _G['ShardBarFrame']:SetParent(self.PreviewFrame)
        _G['ShardBarFrame']:ClearAllPoints()
        _G['ShardBarFrame']:SetPoint('TOP', self.PreviewFrame, 'TOP', 0, -9)
    elseif DF.API.Version.IsMoP then
        _G['MonkHarmonyBar']:SetParent(self.PreviewFrame)
        _G['MonkHarmonyBar']:ClearAllPoints()
        _G['MonkHarmonyBar']:SetPoint('TOP', self.PreviewFrame, 'TOP', 0, 18)

        -- WarlockPowerFrame
        _G['WarlockPowerFrame']:SetParent(self.PreviewFrame)
        _G['WarlockPowerFrame']:ClearAllPoints()
        _G['WarlockPowerFrame']:SetPoint('TOP', self.PreviewFrame, 'TOP', 0, -7)

        _G['ShardBarFrame']:SetParent(self.PreviewFrame)
        _G['ShardBarFrame']:ClearAllPoints()
        _G['ShardBarFrame']:SetPoint('TOP', self.PreviewFrame, 'TOP', 0, -2)

        _G['BurningEmbersBarFrame']:SetParent(self.PreviewFrame)
        _G['BurningEmbersBarFrame']:ClearAllPoints()
        _G['BurningEmbersBarFrame']:SetPoint('TOP', self.PreviewFrame, 'TOP', 0, -0.5)

        -- PriestBarFrame
        -- _G['PriestBarFrame']:SetParent(self.PreviewFrame)
        _G['PriestBarFrame']:ClearAllPoints()
        _G['PriestBarFrame']:SetPoint('TOP', self.PreviewFrame, 'TOP', 0, 0.5)
    end
end

function SubModuleMixin:HideSecondaryRes(hide)
    if not self.SecondaryResToHide then return end

    local _, class = UnitClass('player');

    if class == 'WARLOCK' then
        if DF.API.Version.IsCata then
            if UnitLevel("player") >= (SHARDBAR_SHOW_LEVEL or 10) then
                _G['ShardBarFrame']:SetShown(not hide);
            end
        else
            -- MoP onwards; 
            local spec = C_SpecializationInfo.GetSpecialization()

            if spec == SPEC_WARLOCK_AFFLICTION then
                if IsPlayerSpell(WARLOCK_SOULBURN) then
                    _G['ShardBarFrame']:SetShown(not hide);
                else
                    _G['ShardBarFrame']:SetShown(false);
                end
                _G['BurningEmbersBarFrame']:SetShown(false);
                _G['DemonicFuryBarFrame']:SetShown(false);
            elseif spec == SPEC_WARLOCK_DESTRUCTION then
                if IsPlayerSpell(WARLOCK_BURNING_EMBERS) then
                    _G['BurningEmbersBarFrame']:SetShown(not hide);
                else
                    _G['BurningEmbersBarFrame']:SetShown(false);
                end
                _G['ShardBarFrame']:SetShown(false);
                _G['DemonicFuryBarFrame']:SetShown(false);
            elseif spec == SPEC_WARLOCK_DEMONOLOGY then
                _G['ShardBarFrame']:SetShown(false);
                _G['BurningEmbersBarFrame']:SetShown(false);
                _G['DemonicFuryBarFrame']:SetShown(not hide);
            else
                _G['ShardBarFrame']:SetShown(false);
                _G['BurningEmbersBarFrame']:SetShown(false);
                _G['DemonicFuryBarFrame']:SetShown(false);
            end
        end
    elseif class == 'DRUID' then
        if hide then
            _G['EclipseBarFrame']:Hide()
        else
            if DF.API.Version.IsMoP then
                _G['EclipseBarFrame']:UpdateShown()
            else
                EclipseBar_UpdateShown(_G['EclipseBarFrame'])
            end
        end
    elseif class == 'PALADIN' then
        if DF.API.Version.IsCata then
            if UnitLevel("player") >= (PALADINPOWERBAR_SHOW_LEVEL or 9) then
                _G['PaladinPowerBar']:SetShown(not hide);
            else
                _G['PaladinPowerBar']:SetShown(false);
            end
        else
            -- MoP onwards
            if UnitLevel("player") >= (PALADINPOWERBAR_SHOW_LEVEL or 9) then
                _G['PaladinPowerBar']:SetShown(not hide);
            else
                _G['PaladinPowerBar']:SetShown(false);
            end
        end
    elseif class == 'DEATHKNIGHT' then
        _G['RuneFrame']:SetShown(not hide);
    elseif class == 'MONK' then
        _G['MonkHarmonyBar']:SetShown(not hide)

        local spec = C_SpecializationInfo.GetSpecialization()

        if spec == SPEC_MONK_BREWMASTER then
            _G['MonkStaggerBar']:SetShown(not hide)
        else
            _G['MonkStaggerBar']:SetShown(false)
        end
    elseif class == 'PRIEST' then
        -- _G['PriestBarFrame']:SetShown(not hide)
        -- _G['PriestBarFrame']:CheckAndShow();
        local spec = C_SpecializationInfo.GetSpecialization();
        if (spec == SPEC_PRIEST_SHADOW) then
            if (_G['PriestBarFrame'].hasReqLevel) then
                --
                _G['PriestBarFrame']:SetShown(not hide)
            else
                _G['PriestBarFrame']:SetShown(false)
            end
        else
            _G['PriestBarFrame']:SetShown(false)
        end
    end
end

function SubModuleMixin:HookSecondaryRes()
    local _, class = UnitClass('player');

    if class == 'WARLOCK' then
        self.SecondaryResToHide = _G['ShardBarFrame'];
    elseif class == 'DRUID' then
        self.SecondaryResToHide = _G['EclipseBarFrame'];
    elseif class == 'PALADIN' then
        self.SecondaryResToHide = _G['PaladinPowerBar'];
    elseif class == 'DEATHKNIGHT' then
        self.SecondaryResToHide = _G['RuneFrame'];
    elseif class == 'MONK' then
        self.SecondaryResToHide = _G['MonkHarmonyBar'];
    elseif class == 'PRIEST' then
        self.SecondaryResToHide = _G['PriestBarFrame'];
    end

    if not self.SecondaryResToHide then return end

    if self.SecondaryResToHide == _G['ShardBarFrame'] and not DF.API.Version.IsCata then
        -- warlock MoP onwards
        self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')

        local t = {_G['ShardBarFrame'], _G['BurningEmbersBarFrame'], _G['DemonicFuryBarFrame']}

        for k, v in ipairs(t) do
            v:HookScript('OnShow', function()
                --
                -- print('onshow')
                if not self.ModuleRef.db.profile.playerSecondaryRes.activate then v:Hide() end
            end)
        end
    elseif self.SecondaryResToHide == _G['PriestBarFrame'] then
        self.SecondaryResToHide:HookScript('OnShow', function()
            --
            -- print('onshow')
            if not self.ModuleRef.db.profile.playerSecondaryRes.activate then self.SecondaryResToHide:Hide() end
        end)
        hooksecurefunc(_G['PriestBarFrame'], 'CheckAndShow', function()
            local spec = C_SpecializationInfo.GetSpecialization();
            if (spec == SPEC_PRIEST_SHADOW) then
                if (_G['PriestBarFrame'].hasReqLevel) then
                    --
                    if not self.ModuleRef.db.profile.playerSecondaryRes.activate then
                        _G['PriestBarFrame']:Hide()
                    end
                end
            end
        end)
    else
        self.SecondaryResToHide:HookScript('OnShow', function()
            --
            -- print('onshow')
            if not self.ModuleRef.db.profile.playerSecondaryRes.activate then self.SecondaryResToHide:Hide() end
        end)
    end
end
