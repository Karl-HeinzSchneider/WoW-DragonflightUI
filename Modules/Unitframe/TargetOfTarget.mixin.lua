local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;
local LSM = LibStub('LibSharedMedia-3.0')
local RangeCheck = LibStub("LibRangeCheck-3.0")

local subModuleName = 'TargetOfTarget';
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
        classcolor = false,
        reactioncolor = false,
        classicon = false,
        fadeOut = false,
        fadeOutDistance = 40,
        -- breakUpLargeNumbers = true,   
        -- hideNameBackground = false,
        scale = 1.0,
        override = false,
        anchorFrame = 'TargetFrame',
        customAnchorFrame = '',
        anchor = 'BOTTOMRIGHT',
        anchorParent = 'BOTTOMRIGHT',
        x = -35 + 27,
        y = -15,
        customHealthBarTexture = 'Default',
        customPowerBarTexture = 'Default'
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

    local partyBuffTooltipTable = {
        {value = 'NEVER', text = 'Never', tooltip = 'descr', label = 'label'},
        {value = 'ALWAYS', text = 'Always', tooltip = 'descr', label = 'label'},
        {value = 'INCOMBAT', text = 'In Combat', tooltip = 'descr', label = 'label'}
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
    local optionsTargetOfTarget = {
        name = L["TargetOfTargetFrameName"],
        desc = L["TargetOfTargetFrameDesc"],
        advancedName = 'TargetOfTargetFrame',
        sub = 'tot',
        get = getOption,
        set = setOption,
        type = 'group',
        args = {
            headerStyling = {
                type = 'header',
                name = L["TargetFrameStyle"],
                desc = '',
                order = 20,
                isExpanded = true,
                editmode = true
            },
            classcolor = {
                type = 'toggle',
                name = L["TargetFrameClassColor"],
                desc = L["TargetFrameClassColorDesc"] .. getDefaultStr('classcolor', 'tot'),
                group = 'headerStyling',
                order = 2,
                editmode = true,
                new = true
            },
            reactioncolor = {
                type = 'toggle',
                name = L["TargetFrameReactionColor"],
                desc = L["TargetFrameReactionColorDesc"] .. getDefaultStr('reactioncolor', 'tot'),
                group = 'headerStyling',
                order = 3,
                new = true,
                editmode = true
            },
            classicon = {
                type = 'toggle',
                name = L["TargetFrameClassIcon"],
                desc = L["TargetFrameClassIconDesc"] .. getDefaultStr('classicon', 'tot'),
                group = 'headerStyling',
                order = 1,
                disabled = true,
                new = true,
                editmode = true
            },
            fadeOut = {
                type = 'toggle',
                name = L["TargetFrameFadeOut"],
                desc = L["TargetFrameFadeOutDesc"] .. getDefaultStr('fadeOut', 'tot'),
                group = 'headerStyling',
                order = 9.5,
                new = true,
                editmode = true
            },
            fadeOutDistance = {
                type = 'range',
                name = L["TargetFrameFadeOutDistance"],
                desc = L["TargetFrameFadeOutDistanceDesc"] .. getDefaultStr('fadeOutDistance', 'tot'),
                min = 0,
                max = 50,
                bigStep = 1,
                order = 9.6,
                group = 'headerStyling',
                new = true,
                editmode = true
            },
            customHealthBarTexture = {
                type = 'select',
                name = L["PlayerFrameCustomHealthbarTexture"],
                desc = L["PlayerFrameCustomHealthbarTextureDesc"] .. getDefaultStr('customHealthBarTexture', 'tot'),
                dropdownValuesFunc = Helper:CreateSharedMediaStatusBarGenerator(function(name)
                    return getOption({'tot', 'customHealthBarTexture'}) == name;
                end, function(name)
                    setOption({'tot', 'customHealthBarTexture'}, name)
                end),
                group = 'headerStyling',
                order = 4,
                new = true
            },
            customPowerBarTexture = {
                type = 'select',
                name = L["PlayerFrameCustomPowerbarTexture"],
                desc = L["PlayerFrameCustomPowerbarTextureDesc"] .. getDefaultStr('customPowerBarTexture', 'tot'),
                dropdownValuesFunc = Helper:CreateSharedMediaStatusBarGenerator(function(name)
                    return getOption({'tot', 'customPowerBarTexture'}) == name;
                end, function(name)
                    setOption({'tot', 'customPowerBarTexture'}, name)
                end),
                group = 'headerStyling',
                order = 5,
                new = true
            }
        }
    }
    DF.Settings:AddPositionTable(Module, optionsTargetOfTarget, 'tot', 'TargetOfTarget', getDefaultStr, frameTable)
    local optionsTargetOfTargetEditmode = {
        name = 'TargetOfTarget',
        desc = 'Targetframedesc',
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
                    local dbTable = Module.db.profile.tot
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

    self.Options = optionsTargetOfTarget;
    self.OptionsEditmode = optionsTargetOfTargetEditmode;
end

function SubModuleMixin:Setup()
    local function setDefaultSubValues(sub)
        self.ModuleRef:SetDefaultSubValues(sub)
    end

    DF.ConfigModule:RegisterSettingsData('targetoftarget', 'unitframes', {
        options = self.Options,
        default = function()
            setDefaultSubValues('tot')
        end
    })

    --
    self:ChangeToT()
    self:ReApplyToT()

    _G['TargetFrameToTManaBar'].DFUpdateFunc = function()
        self:ReApplyToT()
    end

    -- edit mode
    local EditModeModule = DF:GetModule('Editmode');
    local fakeTarget = _G['DragonflightUIEditModeTargetFramePreview']
    local fakeTargetOfTarget = CreateFrame('Frame', 'DragonflightUIEditModeTargetOfTargetFramePreview', UIParent,
                                           'DFEditModePreviewTargetOfTargetTemplate')
    fakeTargetOfTarget.IsToT = true;
    fakeTargetOfTarget:OnLoad()
    fakeTargetOfTarget:SetParent(fakeTarget)
    -- fakeTargetOfTarget:SetIgnoreParentScale(true)
    self.PreviewTargetOfTarget = fakeTargetOfTarget;

    EditModeModule:AddEditModeToFrame(fakeTargetOfTarget)

    fakeTargetOfTarget.DFEditModeSelection:SetGetLabelTextFunction(function()
        return self.Options.name
    end)

    fakeTargetOfTarget.DFEditModeSelection:RegisterOptions({
        options = self.Options,
        extra = self.OptionsEditmode,
        default = function()
            setDefaultSubValues('tot')
        end,
        moduleRef = self.ModuleRef,
        showFunction = function()
            --         
        end,
        hideFunction = function()
            --
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

    local f = TargetFrameToT

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    f:ClearAllPoints()
    f:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    f:SetScale(state.scale)

    f:SetIgnoreParentAlpha(state.fadeOut and true or false)

    self:ReApplyToT()
    UnitFramePortrait_Update(TargetFrameToT)

    self.PreviewTargetOfTarget:UpdateState(state);
end

function SubModuleMixin:ChangeToTFrame(self, frame)
    local tex2xBase = 'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe2x\\'

    local port = frame.Portrait or _G[frame:GetName() .. 'Portrait']
    local healthBar = self.HealthBar or _G[frame:GetName() .. 'HealthBar']
    local manaBar = self.ManaBar or _G[frame:GetName() .. 'ManaBar']
    local name = frame.Name;

    frame:SetSize(120, 49)

    local portDelta = 0.5; -- not 100% centered without it
    port:SetSize(37, 37)
    port:ClearAllPoints()
    port:SetPoint('TOPLEFT', frame, 'TOPLEFT', 5 + portDelta, -5 + portDelta)
    port:SetDrawLayer('BACKGROUND', 0)

    if not self[frame:GetName() .. 'Background'] then
        local background = frame:CreateTexture('DragonflightUI' .. frame:GetName() .. 'Background')
        background:SetDrawLayer('BACKGROUND', 1)
        background:SetTexture(tex2xBase .. 'ui-hud-unitframe-targetoftarget-portraiton-2x')
        background:SetTexCoord(0, 240 / 256, 0, 98 / 128)
        background:SetSize(120, 49)
        background:SetPoint('CENTER', frame, 'CENTER', 0, 0)

        self[frame:GetName() .. 'Background'] = background
        self.TargetFrameBackground = background;
    end

    healthBar:ClearAllPoints()
    healthBar:SetPoint('BOTTOMLEFT', port, 'RIGHT', 2 - portDelta, -2.75 - portDelta - 0.5)
    healthBar:SetSize(70, 10 + 0.5)
    healthBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health')

    if not healthBar.DFMask then
        local hpMask = healthBar:CreateMaskTexture()
        healthBar:GetStatusBarTexture():AddMaskTexture(hpMask)
        healthBar.DFMask = hpMask
        hpMask:ClearAllPoints()
        hpMask:SetPoint('TOPLEFT', healthBar, 'TOPLEFT', -29, 3)
        hpMask:SetTexture(tex2xBase .. 'uipartyframeportraitonhealthmask', 'CLAMPTOBLACKADDITIVE',
                          'CLAMPTOBLACKADDITIVE')
        hpMask:SetTexCoord(0, 1, 0, 1)
        hpMask:SetSize(128, 16 + 0.5)
    end

    manaBar:ClearAllPoints()
    manaBar:SetPoint('TOPLEFT', healthBar, 'BOTTOMLEFT', -4, -1 + 0.5)
    manaBar:SetSize(74, 7 + 0.5)
    manaBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana')
    manaBar:GetStatusBarTexture():SetVertexColor(1, 1, 1, 1)

    if not manaBar.DFMask then
        local manaMask = manaBar:CreateMaskTexture()
        manaMask:ClearAllPoints()
        manaMask:SetPoint('TOPLEFT', manaBar, 'TOPLEFT', -27, 4)
        manaMask:SetTexture(tex2xBase .. 'uipartyframeportraitonmanamask', 'CLAMPTOBLACKADDITIVE',
                            'CLAMPTOBLACKADDITIVE')
        -- hpMask:SetTexCoord(0, 1, 0, 1)
        manaMask:SetSize(128, 16 + 0.5)
        manaBar:GetStatusBarTexture():AddMaskTexture(manaMask)
        manaBar.DFMask = manaMask
    end

    name:ClearAllPoints()
    -- name:SetPoint('LEFT', port, 'RIGHT', 1 + 1, 2 + 12 - 1)
    name:SetPoint('BOTTOMLEFT', healthBar, 'TOPLEFT', 0, 1)
    name:SetJustifyH('LEFT')
    name:SetJustifyV('BOTTOM')
    name:SetFontObject(GameFontNormalSmall)
    name:SetSize(68, 10)

    local debuff1 = _G[frame:GetName() .. 'Debuff1']
    if debuff1 then debuff1:SetPoint('TOPLEFT', frame, 'TOPRIGHT', 5, -20) end
end

function SubModuleMixin:ChangeToT()
    local tex2xBase = 'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe2x\\'

    -- TargetFrameToTTextureFrame:Hide()
    TargetFrameToT:ClearAllPoints()
    TargetFrameToT:SetPoint('BOTTOMRIGHT', TargetFrame, 'BOTTOMRIGHT', -35 + 27, -10 - 5)

    TargetFrameToT.Name = TargetFrameToTTextureFrameName
    self:ChangeToTFrame(self, TargetFrameToT)

    TargetFrameToTTextureFrameTexture:SetTexture('')

    -- TargetFrameToTTextureFrameTexture:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-TargetofTarget-PortraitOn'))
    local totDelta = 1

    TargetFrameToTBackground:Hide()

    TargetFrameToTTextureFrameDeadText:ClearAllPoints()
    TargetFrameToTTextureFrameDeadText:SetPoint('CENTER', TargetFrameToTHealthBar, 'CENTER', 0, 0)

    TargetFrameToTTextureFrameUnconsciousText:ClearAllPoints()
    TargetFrameToTTextureFrameUnconsciousText:SetPoint('CENTER', TargetFrameToTHealthBar, 'CENTER', 0, 0)

    if not TargetFrameToT.DFRangeHooked then
        TargetFrameToT.DFRangeHooked = true;

        local state = self.ModuleRef.db.profile.tot

        if not RangeCheck then return end
        local function updateRange()
            local minRange, maxRange = RangeCheck:GetRange('targettarget')
            -- print(minRange, maxRange)

            if not state.fadeOut then
                TargetFrameToT:SetAlpha(1);
                return;
            end

            if minRange and minRange >= state.fadeOutDistance then
                TargetFrameToT:SetAlpha(0.55);
                -- elseif maxRange and maxRange >= 40 then
                --     TargetFrame:SetAlpha(0.55);
            else
                TargetFrameToT:SetAlpha(1);
            end
        end

        TargetFrameToT:HookScript('OnUpdate', updateRange)
        TargetFrameToT:HookScript('OnEvent', updateRange)
    end
end

function SubModuleMixin:ReApplyToT()
    self:UpdateToTHealthBarTexture(TargetFrameToTHealthBar, self.ModuleRef.db.profile.tot, 'targettarget')
    self:UpdateToTPowerBarTexture(TargetFrameToTManaBar, self.ModuleRef.db.profile.tot, 'targettarget')
end

local texBase = 'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\'
local texBaseToT = texBase .. 'UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-'

local powerTable = {
    MANA = 'Mana',
    FOCUS = 'Focus',
    RAGE = 'Rage',
    ENERGY = 'Energy',
    RUNIC_POWER = 'RunicPower',
    POWER_TYPE_FEL_ENERGY = 'Energy' -- TODO
}

function SubModuleMixin:UpdateToTHealthBarTexture(bar, state, unit)
    if state.customHealthBarTexture == 'Default' or not LSM then
        if (not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)) then
            bar:GetStatusBarTexture():SetTexture(texBaseToT .. 'Health')
            bar:SetStatusBarColor(0.5, 0.5, 0.5, 1)
        elseif state.classcolor and UnitIsPlayer(unit) then
            bar:GetStatusBarTexture():SetTexture(texBaseToT .. 'Health-Status')
            local _, englishClass, _ = UnitClass(unit)
            bar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
        elseif state.reactioncolor then
            bar:GetStatusBarTexture():SetTexture(texBaseToT .. 'Health-Status')
            bar:SetStatusBarColor(DF:GetUnitSelectionColor(unit))
        else
            bar:GetStatusBarTexture():SetTexture(texBaseToT .. 'Health')
            bar:SetStatusBarColor(1, 1, 1, 1)
        end
    else
        local customTex = LSM:Fetch("statusbar", state.customHealthBarTexture)
        bar:GetStatusBarTexture():SetTexture(customTex)

        if (not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)) then
            bar:SetStatusBarColor(0.5, 0.5, 0.5, 1)
        elseif state.classcolor and UnitIsPlayer(unit) then
            local _, englishClass, _ = UnitClass(unit)
            bar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
        elseif state.reactioncolor then
            bar:SetStatusBarColor(DF:GetUnitSelectionColor(unit))
        else
            bar:SetStatusBarColor(0.0, 1.0, 0.0, 1)
        end
    end
end

function SubModuleMixin:UpdateToTPowerBarTexture(bar, state, unit)
    if state.customPowerBarTexture == 'Default' or not LSM then
        local _, powerTypeString = UnitPowerType(unit)

        local powerTexStr = powerTable[powerTypeString] or powerTable['MANA']
        bar:GetStatusBarTexture():SetTexture(texBaseToT .. powerTexStr)

        bar:GetStatusBarTexture():SetVertexColor(1, 1, 1, 1)
    else
        UnitFrameManaBar_UpdateType(bar, true)
        local customTex = LSM:Fetch("statusbar", state.customPowerBarTexture)
        bar:GetStatusBarTexture():SetTexture(customTex)
    end
end
