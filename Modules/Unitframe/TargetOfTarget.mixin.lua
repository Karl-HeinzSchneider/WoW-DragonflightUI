local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

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
        y = -15
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
                order = 7,
                editmode = true,
                new = true
            },
            classicon = {
                type = 'toggle',
                name = L["TargetFrameClassIcon"],
                desc = L["TargetFrameClassIconDesc"] .. getDefaultStr('classicon', 'tot'),
                group = 'headerStyling',
                order = 7.1,
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

    self:ReApplyToT()
    UnitFramePortrait_Update(TargetFrameToT)

    self.PreviewTargetOfTarget:UpdateState(state);
end

function SubModuleMixin:ChangeToT()
    -- TargetFrameToTTextureFrame:Hide()
    TargetFrameToT:ClearAllPoints()
    TargetFrameToT:SetPoint('BOTTOMRIGHT', TargetFrame, 'BOTTOMRIGHT', -35 + 27, -10 - 5)
    TargetFrameToT:SetSize(93 + 27, 45)

    TargetFrameToTTextureFrameTexture:SetTexture('')
    -- TargetFrameToTTextureFrameTexture:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-TargetofTarget-PortraitOn'))
    local totDelta = 1

    if not self.TargetFrameToTBackground then
        local background = TargetFrameToTTextureFrame:CreateTexture('DragonflightUITargetFrameToTBackground')
        background:SetDrawLayer('BACKGROUND', 1)
        background:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BACKGROUND')
        background:SetPoint('LEFT', TargetFrameToTPortrait, 'CENTER', -25 + 1, -10 + totDelta)
        self.TargetFrameToTBackground = background
    end
    TargetFrameToTBackground:Hide()

    if not self.TargetFrameToTBorder then
        local border = TargetFrameToTHealthBar:CreateTexture('DragonflightUITargetFrameToTBorder')
        border:SetDrawLayer('ARTWORK', 2)
        border:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BORDER')
        border:SetPoint('LEFT', TargetFrameToTPortrait, 'CENTER', -25 + 1, -10 + totDelta)
        self.TargetFrameToTBorder = border
    end

    TargetFrameToTHealthBar:ClearAllPoints()
    TargetFrameToTHealthBar:SetPoint('LEFT', TargetFrameToTPortrait, 'RIGHT', 1 + 1, 0 + totDelta)
    TargetFrameToTHealthBar:SetFrameLevel(10)
    TargetFrameToTHealthBar:SetSize(70.5, 10)

    TargetFrameToTManaBar:ClearAllPoints()
    TargetFrameToTManaBar:SetPoint('LEFT', TargetFrameToTPortrait, 'RIGHT', 1 - 2 - 1.5 + 1, 2 - 10 - 1 + totDelta)
    TargetFrameToTManaBar:SetFrameLevel(10)
    TargetFrameToTManaBar:SetSize(74, 7.5)

    if not TargetFrameToTManaBar.DFMask then
        local manaMask = TargetFrameToTManaBar:CreateMaskTexture()
        -- hpMask:SetPoint('TOPLEFT', pf, 'TOPLEFT', -29, 3)
        manaMask:SetPoint('CENTER', TargetFrameToTManaBar, 'CENTER', 0, 0)
        manaMask:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Mana-Mask',
            'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
        manaMask:SetSize(74, 7)
        TargetFrameToTManaBar:GetStatusBarTexture():AddMaskTexture(manaMask)
        TargetFrameToTManaBar.DFMask = manaMask;
    end

    TargetFrameToTTextureFrameName:ClearAllPoints()
    TargetFrameToTTextureFrameName:SetPoint('LEFT', TargetFrameToTPortrait, 'RIGHT', 1 + 1, 2 + 12 - 1 + totDelta)

    TargetFrameToTTextureFrameDeadText:ClearAllPoints()
    TargetFrameToTTextureFrameDeadText:SetPoint('CENTER', TargetFrameToTHealthBar, 'CENTER', 0, 0)

    TargetFrameToTTextureFrameUnconsciousText:ClearAllPoints()
    TargetFrameToTTextureFrameUnconsciousText:SetPoint('CENTER', TargetFrameToTHealthBar, 'CENTER', 0, 0)

    TargetFrameToTDebuff1:SetPoint('TOPLEFT', TargetFrameToT, 'TOPRIGHT', 5, -20)

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
    if self.ModuleRef.db.profile.tot.classcolor and UnitIsPlayer('targettarget') then
        TargetFrameToTHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health-Status')
        local localizedClass, englishClass, classIndex = UnitClass('targettarget')
        TargetFrameToTHealthBar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
    else
        TargetFrameToTHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health')
        TargetFrameToTHealthBar:SetStatusBarColor(1, 1, 1, 1)
    end

    local powerType, powerTypeString = UnitPowerType('targettarget')

    if powerTypeString == 'MANA' then
        TargetFrameToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana')
    elseif powerTypeString == 'FOCUS' then
        TargetFrameToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Focus')
    elseif powerTypeString == 'RAGE' then
        TargetFrameToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Rage')
    elseif powerTypeString == 'ENERGY' or powerTypeString == 'POWER_TYPE_FEL_ENERGY' then
        TargetFrameToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Energy')
    elseif powerTypeString == 'RUNIC_POWER' then
        TargetFrameToTManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-RunicPower')
    end

    TargetFrameToTManaBar:SetStatusBarColor(1, 1, 1, 1)
end
