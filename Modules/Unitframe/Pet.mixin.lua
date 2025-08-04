local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local subModuleName = 'PetFrame';
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
        breakUpLargeNumbers = true,
        enableThreatGlow = true,
        scale = 1.0,
        override = false,
        anchorFrame = 'PlayerFrame',
        customAnchorFrame = '',
        anchor = 'TOPRIGHT',
        anchorParent = 'BOTTOMRIGHT',
        x = 4,
        y = 28,
        hideStatusbarText = false,
        offset = false,
        hideIndicator = false,
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

    local optionsPet = {
        name = L["PetFrameName"],
        desc = L["PetFrameDesc"],
        advancedName = 'PetFrame',
        sub = 'pet',
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
            breakUpLargeNumbers = {
                type = 'toggle',
                name = L["PetFrameBreakUpLargeNumbers"],
                desc = L["PetFrameBreakUpLargeNumbersDesc"] .. getDefaultStr('breakUpLargeNumbers', 'pet'),
                group = 'headerStyling',
                order = 9,
                editmode = true
            },
            enableThreatGlow = {
                type = 'toggle',
                name = L["PetFrameThreatGlow"],
                desc = L["PetFrameThreatGlowDesc"] .. getDefaultStr('enableThreatGlow', 'pet'),
                group = 'headerStyling',
                order = 8,
                disabled = true,
                editmode = true
            },
            hideStatusbarText = {
                type = 'toggle',
                name = L["PetFrameHideStatusbarText"],
                desc = L["PetFrameHideStatusbarTextDesc"] .. getDefaultStr('hideStatusbarText', 'pet'),
                group = 'headerStyling',
                order = 10,
                editmode = true
            },
            hideIndicator = {
                type = 'toggle',
                name = L["PetFrameHideIndicator"],
                desc = L["PetFrameHideIndicatorDesc"] .. getDefaultStr('hideIndicator', 'pet'),
                group = 'headerStyling',
                order = 11,
                new = false,
                editmode = true
            }
        }
    }

    if DF.Cata then
        local moreOptions = {
            offset = {
                type = 'toggle',
                name = 'Auto adjust offset',
                desc = 'Auto add some Y offset depending on the class, e.g. on Deathknight to make room for the rune display' ..
                    getDefaultStr('offset', 'pet'),
                group = 'headerStyling',
                order = 11,
                new = false
            }
        }

        for k, v in pairs(moreOptions) do optionsPet.args[k] = v end
    end
    DF.Settings:AddPositionTable(Module, optionsPet, 'pet', 'Pet', getDefaultStr, frameTableWithout('PetFrame'))

    DragonflightUIStateHandlerMixin:AddStateTable(Module, optionsPet, 'pet', 'Pet', getDefaultStr)
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
                    local dbTable = Module.db.profile.pet
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

    DF.ConfigModule:RegisterSettingsData('pet', 'unitframes', {
        options = self.Options,
        default = function()
            setDefaultSubValues('pet')
        end
    })

    --
    self:ChangePetFrame()

    _G['PetFrameManaBar'].DFUpdateFunc = function()
        self:UpdatePetManaBarTexture();
    end

    -- state
    PetFrame:SetParent(UIParent)
    Mixin(PetFrame, DragonflightUIStateHandlerMixin)
    PetFrame:InitStateHandler()
    PetFrame:SetUnit('pet')

    -- editmode
    local EditModeModule = DF:GetModule('Editmode');
    EditModeModule:AddEditModeToFrame(PetFrame)

    PetFrame.DFEditModeSelection:SetGetLabelTextFunction(function()
        return self.Options.name
    end)

    PetFrame.DFEditModeSelection:RegisterOptions({
        options = self.Options,
        extra = self.OptionsEditmode,
        default = function()
            setDefaultSubValues('pet')
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

    -- pet

    local f = PetFrame

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    f:SetScale(state.scale)
    f:ClearAllPoints()
    f:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

    PetFrame.breakUpLargeNumbers = state.breakUpLargeNumbers
    TextStatusBar_UpdateTextString(PetFrameHealthBar)

    local alpha = 1
    if state.hideStatusbarText then alpha = 0 end
    PetFrameHealthBarText:SetAlpha(alpha)
    PetFrameHealthBarTextLeft:SetAlpha(alpha)
    PetFrameHealthBarTextRight:SetAlpha(alpha)

    PetFrameManaBarText:SetAlpha(alpha)
    PetFrameManaBarTextLeft:SetAlpha(alpha)
    PetFrameManaBarTextRight:SetAlpha(alpha)

    if state.hideIndicator then
        PetHitIndicator:SetScale(0.01)
    else
        PetHitIndicator:SetScale(1)
    end

    PetFrame:UpdateStateHandler(state)
end

function SubModuleMixin:ChangePetFrame()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'
    local tex2xBase = 'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe2x\\'

    PetFrame:SetPoint('TOPLEFT', PlayerFrame, 'TOPLEFT', 100, -70)
    PetFrameTexture:SetTexture('')
    PetFrameTexture:Hide()

    PetFrame:SetSize(120, 49)

    PetPortrait:SetSize(37, 37)
    PetPortrait:ClearAllPoints()
    PetPortrait:SetPoint('TOPLEFT', PetFrame, 'TOPLEFT', 5, -5)

    if not self.PetAttackModeTexture then
        -- local attack = PetFrame:CreateTexture('DragonflightUIPetAttackModeTexture')
        local attack = PetFrameHealthBar:CreateTexture('DragonflightUIPetAttackModeTexture')
        attack:SetDrawLayer('ARTWORK', 3)
        attack:SetTexture(tex2xBase .. 'ui-hud-unitframe-targetoftarget-portraiton-status-2x')
        attack:SetTexCoord(0, 240 / 256, 0, 98 / 128)
        attack:SetSize(120, 49)
        attack:SetPoint('CENTER', PetFrame, 'CENTER', 0, 0)

        attack:SetBlendMode('ADD')
        attack:SetVertexColor(239 / 256, 0, 0)

        attack.attackModeCounter = 0
        attack.attackModeSign = -1

        PetFrame:HookScript('OnUpdate', function(self, elapsed)
            -- print('OnUpdate', elapsed)
            PetAttackModeTexture:Hide()

            if attack:IsShown() then
                local alpha = 255;
                local counter = attack.attackModeCounter + elapsed;
                local sign = attack.attackModeSign;

                if (counter > 0.5) then
                    sign = -sign;
                    attack.attackModeSign = sign;
                end
                counter = mod(counter, 0.5);
                attack.attackModeCounter = counter;

                if (sign == 1) then
                    alpha = (55 + (counter * 400)) / 255;
                else
                    alpha = (255 - (counter * 400)) / 255;
                end
                -- attack:SetVertexColor(239 / 256, 0, 0, alpha);
                attack:SetVertexColor(1, 0, 0, alpha);

            else
            end
        end)

        attack:Hide()
        PetFrame:HookScript('OnEvent', function(self, event, ...)
            if event == 'PET_ATTACK_START' then
                attack:Show()
            elseif event == 'PET_ATTACK_STOP' then
                attack:Hide()
            end
        end)

        self.PetAttackModeTexture = attack
    end

    if not self.PetFrameBackground then
        local background = PetFrame:CreateTexture('DragonflightUIPetFrameBackground')
        background:SetDrawLayer('BACKGROUND', 1)
        background:SetTexture(tex2xBase .. 'ui-hud-unitframe-targetoftarget-portraiton-2x')
        background:SetTexCoord(0, 240 / 256, 0, 98 / 128)
        background:SetSize(120, 49)
        background:SetPoint('CENTER', PetFrame, 'CENTER', 0, 0)

        self.PetFrameBackground = background
    end

    if PetFrameHappiness then PetFrameHappiness:SetPoint('LEFT', PetFrame, 'RIGHT', -7, -2) end

    PetFrameHealthBar:ClearAllPoints()
    PetFrameHealthBar:SetPoint('BOTTOMLEFT', PetPortrait, 'RIGHT', 2, -2.75)
    PetFrameHealthBar:SetSize(70, 10)
    PetFrameHealthBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health')
    PetFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)
    PetFrameHealthBar.SetStatusBarColor = noop

    if not PetFrameHealthBar.DFMask then
        local hpMask = PetFrameHealthBar:CreateMaskTexture()

        PetFrameHealthBar:GetStatusBarTexture():AddMaskTexture(hpMask)
        PetFrameHealthBar.DFMask = hpMask
        hpMask:ClearAllPoints()
        hpMask:SetPoint('TOPLEFT', PetFrameHealthBar, 'TOPLEFT', -29, 3)
        hpMask:SetTexture(tex2xBase .. 'uipartyframeportraitonhealthmask', 'CLAMPTOBLACKADDITIVE',
                          'CLAMPTOBLACKADDITIVE')
        hpMask:SetTexCoord(0, 1, 0, 1)
        hpMask:SetSize(128, 16)
    end

    PetFrameHealthBarText:SetPoint('CENTER', PetFrameHealthBar, 'CENTER', 0, 0)

    PetFrameManaBar:ClearAllPoints()
    PetFrameManaBar:SetPoint('TOPLEFT', PetFrameHealthBar, 'BOTTOMLEFT', -4, -1)
    PetFrameManaBar:SetSize(74, 7)
    PetFrameManaBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana')
    PetFrameManaBar:GetStatusBarTexture():SetVertexColor(1, 1, 1, 1)

    if not PetFrameManaBar.DFMask then
        local manaMask = PetFrameManaBar:CreateMaskTexture()
        manaMask:ClearAllPoints()
        manaMask:SetPoint('TOPLEFT', PetFrameManaBar, 'TOPLEFT', -27, 4)
        manaMask:SetTexture(tex2xBase .. 'uipartyframeportraitonmanamask', 'CLAMPTOBLACKADDITIVE',
                            'CLAMPTOBLACKADDITIVE')
        -- hpMask:SetTexCoord(0, 1, 0, 1)
        manaMask:SetSize(128, 16)
        PetFrameManaBar:GetStatusBarTexture():AddMaskTexture(manaMask)
        PetFrameManaBar.DFMask = manaMask
    end

    hooksecurefunc('PetFrame_Update', function(_)
        self:UpdatePetManaBarTexture()
    end)
    self:UpdatePetManaBarTexture()

    local dx = 2
    -- health vs mana bar
    local deltaSize = 74 - 70.5

    local newPetTextScale = 0.8

    PetName:ClearAllPoints()
    PetName:SetPoint('LEFT', PetPortrait, 'RIGHT', 1 + 1, 2 + 12 - 1)

    PetFrameHealthBarText:SetPoint('CENTER', PetFrameHealthBar, 'CENTER', 0, 0)
    PetFrameHealthBarTextLeft:SetPoint('LEFT', PetFrameHealthBar, 'LEFT', dx, 0)
    PetFrameHealthBarTextRight:SetPoint('RIGHT', PetFrameHealthBar, 'RIGHT', -dx, 0)

    PetFrameHealthBarText:SetScale(newPetTextScale)
    PetFrameHealthBarTextLeft:SetScale(newPetTextScale)
    PetFrameHealthBarTextRight:SetScale(newPetTextScale)

    PetFrameManaBarText:SetPoint('CENTER', PetFrameManaBar, 'CENTER', deltaSize / 2, 0)
    PetFrameManaBarTextLeft:ClearAllPoints()
    PetFrameManaBarTextLeft:SetPoint('LEFT', PetFrameManaBar, 'LEFT', deltaSize + dx + 1.5, 0)
    PetFrameManaBarTextRight:SetPoint('RIGHT', PetFrameManaBar, 'RIGHT', -dx, 0)

    PetFrameManaBarText:SetScale(newPetTextScale)
    PetFrameManaBarTextLeft:SetScale(newPetTextScale)
    PetFrameManaBarTextRight:SetScale(newPetTextScale)
end

function SubModuleMixin:GetPetOffset(offset)
    if not offset then return 0 end

    local _, class = UnitClass("player");

    -- default -60
    if (class == "DEATHKNIGHT") then
        return -15
        -- self:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 60, -75);
    elseif (class == "SHAMAN" or class == "DRUID") then
        return -40
        -- self:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 60, -100);
    elseif (class == "WARLOCK") then
        return -20
        -- self:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 60, -80);
    elseif (class == "PALADIN") then
        return -30
        -- self:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 60, -90);
    end

    return 0
end

function SubModuleMixin:UpdatePetManaBarTexture()
    local powerType, powerTypeString = UnitPowerType('pet')

    if powerTypeString == 'MANA' then
        PetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana')
    elseif powerTypeString == 'FOCUS' then
        PetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Focus')
    elseif powerTypeString == 'RAGE' then
        PetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Rage')
    elseif powerTypeString == 'ENERGY' or powerTypeString == 'POWER_TYPE_FEL_ENERGY' then
        PetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Energy')
    elseif powerTypeString == 'RUNIC_POWER' then
        PetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-RunicPower')
    end

    PetFrameManaBar:GetStatusBarTexture():SetVertexColor(1, 1, 1, 1)
end
