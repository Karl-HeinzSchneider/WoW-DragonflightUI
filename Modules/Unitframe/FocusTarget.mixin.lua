local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local RangeCheck = LibStub("LibRangeCheck-3.0")

local subModuleName = 'FocusTarget';
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
        anchorFrame = 'FocusFrame',
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

    local optionsFocusTarget = {
        name = L["FocusFrameToTName"],
        advancedName = 'FocusTargetFrame',
        sub = 'focusTarget',
        get = getOption,
        set = setOption,
        type = 'group',
        args = {
            headerStyling = {
                type = 'header',
                name = L["FocusFrameStyle"],
                desc = '',
                order = 20,
                isExpanded = true,
                editmode = true
            },
            classcolor = {
                type = 'toggle',
                name = L["FocusFrameClassColor"],
                desc = L["FocusFrameClassColorDesc"] .. getDefaultStr('classcolor', 'focusTarget'),
                group = 'headerStyling',
                order = 7,
                editmode = true
            },
            reactioncolor = {
                type = 'toggle',
                name = L["TargetFrameReactionColor"],
                desc = L["TargetFrameReactionColorDesc"] .. getDefaultStr('reactioncolor', 'focusTarget'),
                group = 'headerStyling',
                order = 7.05,
                new = true,
                editmode = true
            },
            classicon = {
                type = 'toggle',
                name = L["TargetFrameClassIcon"],
                desc = L["TargetFrameClassIconDesc"] .. getDefaultStr('classicon', 'focusTarget'),
                group = 'headerStyling',
                order = 7.1,
                disabled = true,
                new = false,
                editmode = true
            },
            fadeOut = {
                type = 'toggle',
                name = L["TargetFrameFadeOut"],
                desc = L["TargetFrameFadeOutDesc"] .. getDefaultStr('fadeOut', 'focusTarget'),
                group = 'headerStyling',
                order = 9.5,
                new = false,
                editmode = true
            },
            fadeOutDistance = {
                type = 'range',
                name = L["TargetFrameFadeOutDistance"],
                desc = L["TargetFrameFadeOutDistanceDesc"] .. getDefaultStr('fadeOutDistance', 'focusTarget'),
                min = 0,
                max = 50,
                bigStep = 1,
                order = 9.6,
                group = 'headerStyling',
                new = false,
                editmode = true
            },
            customHealthBarTexture = {
                type = 'select',
                name = L["PlayerFrameCustomHealthbarTexture"],
                desc = L["PlayerFrameCustomHealthbarTextureDesc"] ..
                    getDefaultStr('customHealthBarTexture', 'focusTarget'),
                dropdownValuesFunc = Helper:CreateSharedMediaStatusBarGenerator(function(name)
                    return getOption({'focusTarget', 'customHealthBarTexture'}) == name;
                end, function(name)
                    setOption({'focusTarget', 'customHealthBarTexture'}, name)
                end),
                group = 'headerStyling',
                order = 41,
                new = true
            },
            customPowerBarTexture = {
                type = 'select',
                name = L["PlayerFrameCustomPowerbarTexture"],
                desc = L["PlayerFrameCustomPowerbarTextureDesc"] ..
                    getDefaultStr('customPowerBarTexture', 'focusTarget'),
                dropdownValuesFunc = Helper:CreateSharedMediaStatusBarGenerator(function(name)
                    return getOption({'focusTarget', 'customPowerBarTexture'}) == name;
                end, function(name)
                    setOption({'focusTarget', 'customPowerBarTexture'}, name)
                end),
                group = 'headerStyling',
                order = 41,
                new = true
            }
        }
    }
    DF.Settings:AddPositionTable(Module, optionsFocusTarget, 'focusTarget', 'FocusTarget', getDefaultStr, frameTable)
    local optionsFocusTargetEditmode = {
        name = 'FocusTarget',
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
                    local dbTable = Module.db.profile.focusTarget
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

    self.Options = optionsFocusTarget;
    self.OptionsEditmode = optionsFocusTargetEditmode;
end

function SubModuleMixin:Setup()
    local function setDefaultSubValues(sub)
        self.ModuleRef:SetDefaultSubValues(sub)
    end

    DF.ConfigModule:RegisterSettingsData('focusTarget', 'unitframes', {
        options = self.Options,
        default = function()
            setDefaultSubValues('focusTarget')
        end
    })

    --
    self:ChangeFocusToT()
    self:ReApplyFocusToT()

    _G['FocusFrameToTManaBar'].DFUpdateFunc = function()
        self:ReApplyFocusToT()
    end

    -- editmode
    local EditModeModule = DF:GetModule('Editmode');
    local fakeFocus = _G['DragonflightUIEditModeFocusFramePreview']
    local fakeFocusTarget = CreateFrame('Frame', 'DragonflightUIEditModeFocusTargetOfTargetFramePreview', UIParent,
                                        'DFEditModePreviewTargetOfTargetTemplate')
    fakeFocusTarget:OnLoad()
    fakeFocusTarget:SetParent(fakeFocus)
    self.PreviewFocusTarget = fakeFocusTarget;

    EditModeModule:AddEditModeToFrame(fakeFocusTarget)

    fakeFocusTarget.DFEditModeSelection:SetGetLabelTextFunction(function()
        return self.Options.name
    end)

    fakeFocusTarget.DFEditModeSelection:RegisterOptions({
        options = self.Options,
        extra = self.OptionsEditmode,
        default = function()
            setDefaultSubValues('focusTarget')
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

    local f = FocusFrameToT

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    f:SetScale(state.scale)
    f:ClearAllPoints()
    f:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    f:SetUserPlaced(true)

    self:ReApplyFocusToT()
    UnitFramePortrait_Update(FocusFrameToT)

    self.PreviewFocusTarget:UpdateState(state);
end

function SubModuleMixin:ChangeFocusToT()
    FocusFrameToT:ClearAllPoints()
    FocusFrameToT:SetPoint('BOTTOMRIGHT', FocusFrame, 'BOTTOMRIGHT', -35 + 27, -10 - 5)
    FocusFrameToT:SetSize(93 + 27, 45)

    FocusFrameToT.Portrait = FocusFrameToTPortrait;
    FocusFrameToT.Name = FocusFrameToTTextureFrameName;

    self.ModuleRef.SubTargetOfTarget:ChangeToTFrame(self, FocusFrameToT)

    FocusFrameToTTextureFrameTexture:SetTexture('')

    FocusFrameToTBackground:Hide()

    FocusFrameToTTextureFrameDeadText:ClearAllPoints()
    FocusFrameToTTextureFrameDeadText:SetPoint('CENTER', FocusFrameToTHealthBar, 'CENTER', 0, 0)

    FocusFrameToTTextureFrameUnconsciousText:ClearAllPoints()
    FocusFrameToTTextureFrameUnconsciousText:SetPoint('CENTER', FocusFrameToTHealthBar, 'CENTER', 0, 0)

    if not FocusFrameToT.DFRangeHooked then
        FocusFrameToT.DFRangeHooked = true;

        local state = self.ModuleRef.db.profile.focusTarget

        if not RangeCheck then return end
        local function updateRange()
            local minRange, maxRange = RangeCheck:GetRange('focusTarget')
            -- print(minRange, maxRange)

            if not state.fadeOut then
                FocusFrameToT:SetAlpha(1);
                return;
            end

            if minRange and minRange >= state.fadeOutDistance then
                FocusFrameToT:SetAlpha(0.55);
                -- elseif maxRange and maxRange >= 40 then
                --     TargetFrame:SetAlpha(0.55);
            else
                FocusFrameToT:SetAlpha(1);
            end
        end

        FocusFrameToT:HookScript('OnUpdate', updateRange)
        FocusFrameToT:HookScript('OnEvent', updateRange)
    end
end

function SubModuleMixin:ReApplyFocusToT()
    self.ModuleRef.SubTargetOfTarget:UpdateToTHealthBarTexture(FocusFrameToTHealthBar,
                                                               self.ModuleRef.db.profile.focusTarget, 'focusTarget')
    self.ModuleRef.SubTargetOfTarget:UpdateToTPowerBarTexture(FocusFrameToTManaBar,
                                                              self.ModuleRef.db.profile.focusTarget, 'focusTarget')
end
