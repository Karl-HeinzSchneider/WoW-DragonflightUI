local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local subModuleName = 'Party';
local SubModuleMixin = {};
addonTable.SubModuleMixins[subModuleName] = SubModuleMixin;

function SubModuleMixin:Init()
    self.ModuleRef = DF:GetModule('Unitframe')
    self:SetDefaults()
    self:SetupOptions()
    self:SetScript('OnEvent', self.OnEvent);
end

function SubModuleMixin:SetDefaults()
    local defaults = {
        classcolor = false,
        breakUpLargeNumbers = true,
        scale = 1.0,
        override = false,
        anchorFrame = 'CompactRaidFrameManager',
        customAnchorFrame = '',
        anchor = 'TOPLEFT',
        anchorParent = 'TOPRIGHT',
        x = 0,
        y = 0,
        customHealthBarTexture = 'Default',
        customPowerBarTexture = 'Default',
        padding = 10,
        orientation = 'vertical',
        disableBuffTooltip = 'INCOMBAT',
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

    local optionsParty = {
        name = L["PartyFrameName"],
        desc = L["PartyFrameDesc"],
        advancedName = 'PartyFrame',
        sub = 'party',
        get = getOption,
        set = setOption,
        type = 'group',
        args = {
            headerStyling = {
                type = 'header',
                name = L["PartyFrameStyle"],
                desc = '',
                order = 20,
                isExpanded = true,
                editmode = true
            },
            classcolor = {
                type = 'toggle',
                name = L["PartyFrameClassColor"],
                desc = L["PartyFrameClassColorDesc"] .. getDefaultStr('classcolor', 'party'),
                group = 'headerStyling',
                order = 7,
                editmode = true
            },
            breakUpLargeNumbers = {
                type = 'toggle',
                name = L["PartyFrameBreakUpLargeNumbers"],
                desc = L["PartyFrameBreakUpLargeNumbersDesc"] .. getDefaultStr('breakUpLargeNumbers', 'party'),
                group = 'headerStyling',
                order = 8,
                editmode = true
            }
        }
    }

    if true then
        local moreOptions = {
            useCompactPartyFrames = {
                type = 'toggle',
                name = USE_RAID_STYLE_PARTY_FRAMES,
                desc = OPTION_TOOLTIP_USE_RAID_STYLE_PARTY_FRAMES,
                group = 'headerStyling',
                order = 15,
                blizzard = true,
                editmode = true
            },
            raidFrameBtn = {
                type = 'execute',
                name = 'Raid Frame Settings',
                btnName = 'Open',
                func = function()
                    Settings.OpenToCategory(Settings.INTERFACE_CATEGORY_ID, RAID_FRAMES_LABEL);
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
                end,
                group = 'headerStyling',
                order = 16,
                blizzard = true,
                editmode = true
            },
            orientation = {
                type = 'select',
                name = L["ButtonTableOrientation"],
                desc = L["ButtonTableOrientationDesc"] .. getDefaultStr('orientation', 'party'),
                dropdownValues = DF.Settings.OrientationTable,
                order = 2,
                group = 'headerStyling',
                editmode = true
            },
            disableBuffTooltip = {
                type = 'select',
                name = L["PartyFrameDisableBuffTooltip"],
                desc = L["PartyFrameDisableBuffTooltipDesc"] .. getDefaultStr('disableBuffTooltip', 'party'),
                dropdownValues = partyBuffTooltipTable,
                order = 3,
                group = 'headerStyling',
                editmode = true,
                new = false
            },
            padding = {
                type = 'range',
                name = L["ButtonTablePadding"],
                desc = L["ButtonTablePaddingDesc"] .. getDefaultStr('padding', 'party'),
                min = -50,
                max = 50,
                bigStep = 1,
                order = 3,
                group = 'headerStyling',
                editmode = true
            }
        }

        for k, v in pairs(moreOptions) do optionsParty.args[k] = v end

        optionsParty.get = function(info)
            local key = info[1]
            local sub = info[2]

            if sub == 'useCompactPartyFrames' then
                local value = C_CVar.GetCVar("useCompactPartyFrames");
                if value == '1' then
                    return true
                else
                    return false
                end
            else
                return getOption(info)
            end
        end

        optionsParty.set = function(info, value)
            local key = info[1]
            local sub = info[2]

            if sub == 'useCompactPartyFrames' then
                if value then
                    SetCVar("useCompactPartyFrames", "1");
                else
                    SetCVar("useCompactPartyFrames", "0");
                end
            else
                setOption(info, value)
            end
        end
    end
    DF.Settings:AddPositionTable(Module, optionsParty, 'party', 'Party', getDefaultStr, frameTable)

    DragonflightUIStateHandlerMixin:AddStateTable(Module, optionsParty, 'party', 'Party', getDefaultStr)
    local optionsPartyEditmode = {
        name = 'party',
        desc = 'party',
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
                    local dbTable = Module.db.profile.party
                    local defaultsTable = self.Defaults
                    -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                    setPreset(dbTable, {
                        scale = defaultsTable.scale,
                        anchor = defaultsTable.anchor,
                        anchorParent = defaultsTable.anchorParent,
                        anchorFrame = defaultsTable.anchorFrame,
                        x = defaultsTable.x,
                        y = defaultsTable.y,
                        orientation = defaultsTable.orientation,
                        padding = defaultsTable.padding
                    })
                end,
                order = 16,
                editmode = true,
                new = false
            }
        }
    }

    self.Options = optionsParty;
    self.OptionsEditmode = optionsPartyEditmode;
end

function SubModuleMixin:Setup()
    local function setDefaultSubValues(sub)
        self.ModuleRef:SetDefaultSubValues(sub)
    end

    DF.ConfigModule:RegisterSettingsData('party', 'unitframes', {
        options = self.Options,
        default = function()
            setDefaultSubValues('party')
        end
    })
    --
    self:RegisterEvent('CVAR_UPDATE')
    --
    self:ChangePartyFrame()
    self:AddStateUpdater()

    -- editmode
    local EditModeModule = DF:GetModule('Editmode');
    local fakeParty = CreateFrame('Frame', 'DragonflightUIEditModePartyFramePreview', UIParent,
                                  'DFEditModePreviewPartyFrameTemplate')
    fakeParty:OnLoad()
    self.PreviewParty = fakeParty;

    EditModeModule:AddEditModeToFrame(fakeParty)

    fakeParty.DFEditModeSelection:SetGetLabelTextFunction(function()
        return self.Options.name
    end)

    fakeParty.DFEditModeSelection:RegisterOptions({
        options = self.Options,
        extra = self.OptionsEditmode,
        -- parentExtra = Module.PartyMoveFrame,
        default = function()
            setDefaultSubValues('party')
        end,
        moduleRef = self.ModuleRef
        -- showFunction = function()
        --     --           
        --     for k = 1, 4 do
        --         local p = _G['PartyMemberFrame' .. k]
        --         -- p:SetAlpha(0)
        --         -- print('p', k)
        --     end
        --     -- Module.PartyMoveFrame:Hide()
        -- end,
        -- hideFunction = function()
        --     --            
        --     for k = 1, 4 do
        --         local p = _G['PartyMemberFrame' .. k]
        --         -- p:SetAlpha(0)
        --         -- print('p', k)
        --     end
        --     -- Module.PartyMoveFrame:Show()
        -- end
    });
end

function SubModuleMixin:OnEvent(event, ...)
    if event == 'CVAR_UPDATE' then
        local arg1 = ...;
        if arg1 == 'statusText' or arg1 == 'statusTextDisplay' then
            for i = 1, 4 do
                self:UpdatePartyHPBar(i)
                self:UpdatePartyManaBar(i)
            end
        end
    end
end

function SubModuleMixin:UpdateState(state)
    self.state = state;
    self:Update();
end

function SubModuleMixin:Update()
    local state = self.state;
    if not state then return end

    local parent = _G[state.anchorFrame]
    self.PartyMoveFrame:ClearAllPoints();
    self.PartyMoveFrame:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    self.PartyMoveFrame:SetScale(state.scale)

    -- local party1 = _G['PartyMemberFrame' .. 1]
    -- party1:ClearAllPoints()
    -- party1:SetPoint('TOPLEFT', PartyMoveFrame, 'TOPLEFT', 0, 0)

    local sizeX, sizeY = _G['PartyMemberFrame' .. 1]:GetSize()

    if state.orientation == 'vertical' then
        self.PartyMoveFrame:SetSize(sizeX, sizeY * 4 + 3 * state.padding)
    else
        self.PartyMoveFrame:SetSize(sizeX * 4 + 3 * state.padding, sizeY)
    end

    for i = 2, 4 do
        local pf = _G['PartyMemberFrame' .. i]
        pf:ClearAllPoints()

        if state.orientation == 'vertical' then
            pf:SetPoint('TOPLEFT', _G['PartyMemberFrame' .. (i - 1)], 'BOTTOMLEFT', 0, -state.padding)
        else
            pf:SetPoint('TOPLEFT', _G['PartyMemberFrame' .. (i - 1)], 'TOPRIGHT', state.padding, 0)
        end
    end

    for i = 1, 4 do
        local pf = _G['PartyMemberFrame' .. i]

        local debuffOne = _G['PartyMemberFrame' .. i .. 'Debuff1']
        if state.orientation == 'vertical' then
            debuffOne:SetPoint('TOPLEFT', 120, -20)
        else
            debuffOne:SetPoint('TOPLEFT', 40 + 2, -40)
        end

        self:UpdatePartyHPBar(i)
        TextStatusBar_UpdateTextString(_G['PartyMemberFrame' .. i .. 'HealthBar'])
        TextStatusBar_UpdateTextString(_G['PartyMemberFrame' .. i .. 'ManaBar'])

        pf:UpdateStateHandler(state)
        PartyMemberFrame_UpdateMember(pf)
    end

    self.PreviewParty:UpdateState(state)
end

function SubModuleMixin:ChangePartyFrame()
    local PartyMoveFrame = CreateFrame('Frame', 'DraggonflightUIPartyMoveFrame', UIParent)
    PartyMoveFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    PartyMoveFrame:SetFrameStrata('LOW')
    PartyMoveFrame:SetFrameLevel(2)
    self.PartyMoveFrame = PartyMoveFrame

    local sizeX, sizeY = _G['PartyMemberFrame' .. 1]:GetSize()
    local gap = 10;
    PartyMoveFrame:SetSize(sizeX, sizeY * 4 + 3 * gap)

    local first = _G['PartyMemberFrame' .. 1]
    -- first:SetPoint('TOPLEFT', CompactRaidFrameManager, 'TOPRIGHT', 0, 0)
    first:ClearAllPoints()
    first:SetPoint('TOPLEFT', PartyMoveFrame, 'TOPLEFT', 0, 0)

    for i = 1, 4 do
        local pf = _G['PartyMemberFrame' .. i]
        pf:SetParent(PartyMoveFrame)
        pf:SetSize(120, 53)
        -- pf:ClearAllPoints()
        -- pf:SetPoint('TOPLEFT', CompactRaidFrameManager, 'TOPRIGHT', 0, 0)

        pf:SetHitRectInsets(0, 0, 0, 12)

        -- layer = 'BACKGROUND => Flash,Portrait,Background
        local bg = _G['PartyMemberFrame' .. i .. 'Background']
        bg:Hide()

        local flash = _G['PartyMemberFrame' .. i .. 'Flash']
        flash:SetSize(114, 47)
        flash:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\uipartyframe')
        flash:SetTexCoord(0.480469, 0.925781, 0.453125, 0.636719)
        flash:SetPoint('TOPLEFT', 1 + 1, -2)
        flash:SetVertexColor(1, 0, 0, 1)
        flash:SetDrawLayer('ARTWORK', 5)

        local portrait = _G['PartyMemberFrame' .. i .. 'Portrait']
        -- portrait:SetSize(37,37)
        -- portrait:SetPoint('TOPLEFT',7,-6)

        -- layer = 'BORDER' => Texture, VehicleTexture,Name
        local texture = _G['PartyMemberFrame' .. i .. 'Texture']
        texture:SetTexture()
        texture:Hide()

        local name = _G['PartyMemberFrame' .. i .. 'Name']
        name:ClearAllPoints()
        name:SetSize(57, 12)
        name:SetPoint('TOPLEFT', 46, -6)

        if not UnitGroupRolesAssigned then name:SetWidth(100) end

        -- layer = 'ARTWORK' => Status

        if not pf.PartyFrameBorder then
            local border = pf:CreateTexture('DragonflightUIPartyFrameBorder')
            -- border = _G['PartyMemberFrame' .. i .. 'HealthBar']:CreateTexture('DragonflightUIPartyFrameBorder')
            border:SetDrawLayer('ARTWORK', 3)
            border:SetSize(120, 49)
            border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\uipartyframe')
            border:SetTexCoord(0.480469, 0.949219, 0.222656, 0.414062)
            border:SetPoint('TOPLEFT', 1, -2)
            -- border:SetPoint('TOPLEFT', pf, 'TOPLEFT', 1, -2)
            -- border:Hide()

            pf.PartyFrameBorder = border
        end

        local status = _G['PartyMemberFrame' .. i .. 'Status']
        status:SetSize(114, 47)
        status:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\uipartyframe')
        status:SetTexCoord(0.00390625, 0.472656, 0.453125, 0.644531)
        status:SetPoint('TOPLEFT', 1, -2)
        status:SetDrawLayer('ARTWORK', 5)

        -- layer = 'OVERLAY' => LeaderIcon etc

        local updateSmallIcons = function()
            local leaderIcon = _G['PartyMemberFrame' .. i .. 'LeaderIcon']
            leaderIcon:ClearAllPoints()
            leaderIcon:SetPoint('BOTTOM', pf, 'TOP', -10, -6)

            local masterIcon = _G['PartyMemberFrame' .. i .. 'MasterIcon']
            masterIcon:ClearAllPoints()
            masterIcon:SetPoint('BOTTOM', pf, 'TOP', -10 + 16, -6)

            local guideIcon = _G['PartyMemberFrame' .. i .. 'GuideIcon']
            guideIcon:ClearAllPoints()
            guideIcon:SetPoint('BOTTOM', pf, 'TOP', -10, -6)

            local pvpIcon = _G['PartyMemberFrame' .. i .. 'PVPIcon']
            pvpIcon:ClearAllPoints()
            pvpIcon:SetPoint('CENTER', pf, 'TOPLEFT', 7, -24)

            local readyCheck = _G['PartyMemberFrame' .. i .. 'ReadyCheck']
            readyCheck:ClearAllPoints()
            readyCheck:SetPoint('CENTER', portrait, 'CENTER', 0, -2)

            local notPresentIcon = _G['PartyMemberFrame' .. i .. 'NotPresentIcon']
            notPresentIcon:ClearAllPoints()
            notPresentIcon:SetPoint('LEFT', pf, 'RIGHT', 2, -2)
        end
        updateSmallIcons()

        if UnitGroupRolesAssigned then
            local roleIcon = pf:CreateTexture('DragonflightUIPartyFrameRoleIcon')
            roleIcon:SetSize(12, 12)
            roleIcon:SetPoint('TOPRIGHT', -5, -5)
            roleIcon:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\roleicons')
            roleIcon:SetTexCoord(0.015625, 0.265625, 0.03125, 0.53125)

            pf.RoleIcon = roleIcon

            local updateRoleIcon = function()
                local role = UnitGroupRolesAssigned(pf.unit)
                roleIcon:Show()
                if role == 'TANK' then
                    roleIcon:SetTexCoord(0.578125, 0.828125, 0.03125, 0.53125)
                elseif role == 'HEALER' then
                    roleIcon:SetTexCoord(0.296875, 0.546875, 0.03125, 0.53125)
                elseif role == 'DAMAGER' then
                    roleIcon:SetTexCoord(0.015625, 0.265625, 0.03125, 0.53125)
                else
                    roleIcon:Hide()
                end
            end

            updateRoleIcon()

            pf:HookScript('OnEvent', function(self, event, ...)
                -- print('events', event)
                if event == 'GROUP_ROSTER_UPDATE' then updateRoleIcon() end
            end)
        end

        local healthbar = _G['PartyMemberFrame' .. i .. 'HealthBar']
        healthbar:SetSize(70 + 1, 10)
        healthbar:ClearAllPoints()
        healthbar:SetPoint('TOPLEFT', 45 - 1, -19)
        healthbar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Health')
        healthbar:SetStatusBarColor(1, 1, 1, 1)

        local hpMask = healthbar:CreateMaskTexture()
        -- hpMask:SetPoint('TOPLEFT', pf, 'TOPLEFT', -29, 3)
        hpMask:SetPoint('CENTER', healthbar, 'CENTER', 0, 0)
        hpMask:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Health-Mask',
            'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
        hpMask:SetSize(70 + 1, 10)
        healthbar:GetStatusBarTexture():AddMaskTexture(hpMask)

        healthbar.DFHealthBarText = healthbar:CreateFontString('DragonflightUIHealthBarText', 'OVERLAY',
                                                               'TextStatusBarText')
        healthbar.DFHealthBarText:SetPoint('CENTER', healthbar, 'CENTER', 0, 0)
        healthbar.DFTextString = healthbar.DFHealthBarText

        healthbar.DFHealthBarTextLeft = healthbar:CreateFontString('DragonflightUIHealthBarTextLeft', 'OVERLAY',
                                                                   'TextStatusBarText')
        healthbar.DFHealthBarTextLeft:SetPoint('LEFT', healthbar, 'LEFT', 0, 0)
        healthbar.DFLeftText = healthbar.DFHealthBarTextLeft

        healthbar.DFHealthBarTextRight = healthbar:CreateFontString('DragonflightUIHealthBarTextRight', 'OVERLAY',
                                                                    'TextStatusBarText')
        healthbar.DFHealthBarTextRight:SetPoint('RIGHT', healthbar, 'RIGHT', 0, 0)
        healthbar.DFRightText = healthbar.DFHealthBarTextRight

        healthbar:HookScript('OnEnter', function(self)
            if healthbar.DFHealthBarTextRight:IsVisible() or healthbar.DFTextString:IsVisible() then
            else
                local max_health = UnitHealthMax('party' .. i)
                local health = UnitHealth('party' .. i)
                healthbar.DFTextString:SetText(health .. ' / ' .. max_health)
                healthbar.DFTextString:Show()
            end
            PartyMemberBuffTooltip_Update(pf);
        end)
        healthbar:HookScript('OnLeave', function(hb)
            healthbar.DFTextString:Hide()
            self:UpdatePartyHPBar(i)
        end)
        healthbar:HookScript('OnValueChanged', function(_)
            -- print('OnValueChanged', i)
            self:UpdatePartyHPBar(i)
        end)
        healthbar:HookScript('OnEvent', function(_, event, arg1)
            -- print('OnValueChanged', i)
            if event == 'UNIT_MAXHEALTH' then self:UpdatePartyHPBar(i) end
        end)

        self:UpdatePartyHPBar(i)

        local manabar = _G['PartyMemberFrame' .. i .. 'ManaBar']
        manabar:SetSize(74, 7)
        manabar:ClearAllPoints()
        manabar:SetPoint('TOPLEFT', 41, -30)
        manabar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Mana')
        manabar:SetStatusBarColor(1, 1, 1, 1)

        local manaMask = manabar:CreateMaskTexture()
        -- hpMask:SetPoint('TOPLEFT', pf, 'TOPLEFT', -29, 3)
        manaMask:SetPoint('CENTER', manabar, 'CENTER', 0, 0)
        manaMask:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Mana-Mask',
            'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
        manaMask:SetSize(74, 7)
        manabar:GetStatusBarTexture():AddMaskTexture(manaMask)

        manabar.DFManaBarText = manabar:CreateFontString('DragonflightUIManaBarText', 'OVERLAY', 'TextStatusBarText')
        manabar.DFManaBarText:SetPoint('CENTER', manabar, 'CENTER', 1.5, 0)
        manabar.DFTextString = manabar.DFManaBarText

        manabar.DFManaBarTextLeft = manabar:CreateFontString('DragonflightUIManaBarTextLeft', 'OVERLAY',
                                                             'TextStatusBarText')
        manabar.DFManaBarTextLeft:SetPoint('LEFT', manabar, 'LEFT', 3, 0)
        manabar.DFLeftText = manabar.DFManaBarTextLeft

        manabar.DFManaBarTextRight = manabar:CreateFontString('DragonflightUIManaBarTextRight', 'OVERLAY',
                                                              'TextStatusBarText')
        manabar.DFManaBarTextRight:SetPoint('RIGHT', manabar, 'RIGHT', 0, 0)
        manabar.DFRightText = manabar.DFManaBarTextRight

        manabar:HookScript('OnEnter', function(self)
            if manabar.DFManaBarTextRight:IsVisible() or manabar.DFTextString:IsVisible() then
            else
                local max_mana = UnitPowerMax('party' .. i)
                local mana = UnitPower('party' .. i)

                if max_mana == 0 then
                    manabar.DFTextString:SetText('')
                else
                    manabar.DFTextString:SetText(mana .. ' / ' .. max_mana)
                end
                manabar.DFTextString:Show()
            end
            PartyMemberBuffTooltip_Update(pf);
        end)
        manabar:HookScript('OnLeave', function(mb)
            manabar.DFTextString:Hide()
            self:UpdatePartyManaBar(i)
        end)

        self:UpdatePartyManaBar(i)

        manabar.DFUpdateFunc = function()
            self:UpdatePartyManaBar(i)
        end

        -- debuff
        local debuffOne = _G['PartyMemberFrame' .. i .. 'Debuff1']
        debuffOne:SetPoint('TOPLEFT', 120, -20)

        -- CompactUnitFrame_UpdateInRange
        local function updateRange()
            local inRange, checkedRange = UnitInRange('party' .. i);
            if (checkedRange and not inRange) then
                pf:SetAlpha(0.55);
            else
                pf:SetAlpha(1);
            end
        end

        pf:HookScript('OnUpdate', updateRange)

        pf:HookScript('OnEvent', function(p, event, ...)
            local texture = _G['PartyMemberFrame' .. i .. 'Texture']
            texture:SetTexture()
            texture:Hide()
            healthbar:SetStatusBarColor(1, 1, 1, 1)

            updateSmallIcons()
            updateRange()

            self:UpdatePartyHPBar(i)
        end)
    end

    local moduleRef = self.ModuleRef
    hooksecurefunc('PartyMemberBuffTooltip_Update', function(self)
        -- print('PartyMemberBuffTooltip_Update', self:GetName())
        local tooltip = PartyMemberBuffTooltip;

        local state = moduleRef.db.profile.party;
        local disableBuffTooltip = state.disableBuffTooltip

        if disableBuffTooltip == 'NEVER' then
            -- do nothing
        elseif disableBuffTooltip == 'ALWAYS' then
            tooltip:Hide()
            return;
        elseif disableBuffTooltip == 'INCOMBAT' then
            if InCombatLockdown() then
                tooltip:Hide()
                return;
            end
        end

        if state.orientation == 'vertical' then
            tooltip:ClearAllPoints()
            tooltip:SetPoint('LEFT', self, 'RIGHT', 0, 0)
        else
            tooltip:ClearAllPoints()
            tooltip:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 0)
        end

        local scale = state.scale;
        if scale > 2 then
            scale = 2
        else
        end
        tooltip:SetScale(0.8 * scale)
    end)
end

local function DFTextStatusBar_UpdateTextStringWithValues(statusFrame, textString, value, valueMin, valueMax)
    if (statusFrame.DFLeftText and statusFrame.DFRightText) then
        statusFrame.DFLeftText:SetText("");
        statusFrame.DFRightText:SetText("");
        statusFrame.DFLeftText:Hide();
        statusFrame.DFRightText:Hide();
    end

    if ((tonumber(valueMax) ~= valueMax or valueMax > 0) and not (statusFrame.pauseUpdates)) then
        statusFrame:Show();

        if ((statusFrame.cvar and GetCVar(statusFrame.cvar) == "1" and statusFrame.textLockable) or
            statusFrame.forceShow) then
            textString:Show();
        elseif (statusFrame.lockShow > 0 and (not statusFrame.forceHideText)) then
            textString:Show();
        else
            textString:SetText("");
            textString:Hide();
            return;
        end

        local valueDisplay = value;
        local valueMaxDisplay = valueMax;
        -- Modern WoW always breaks up large numbers, whereas Classic never did.
        -- We'll remove breaking-up by default for Classic, but add a flag to reenable it.
        if (statusFrame.breakUpLargeNumbers) then
            if (statusFrame.capNumericDisplay) then
                valueDisplay = AbbreviateLargeNumbers(value);
                valueMaxDisplay = AbbreviateLargeNumbers(valueMax);
            else
                valueDisplay = BreakUpLargeNumbers(value);
                valueMaxDisplay = BreakUpLargeNumbers(valueMax);
            end
        end

        local textDisplay = GetCVar("statusTextDisplay");
        if (value and valueMax > 0 and
            ((textDisplay ~= "NUMERIC" and textDisplay ~= "NONE") or statusFrame.showPercentage) and
            not statusFrame.showNumeric) then
            if (value == 0 and statusFrame.zeroText) then
                textString:SetText(statusFrame.zeroText);
                statusFrame.isZero = 1;
                textString:Show();
            elseif (textDisplay == "BOTH" and not statusFrame.showPercentage) then
                if (statusFrame.DFLeftText and statusFrame.DFRightText) then
                    if (not statusFrame.powerToken or statusFrame.powerToken == "MANA") then
                        statusFrame.DFLeftText:SetText(math.ceil((value / valueMax) * 100) .. "%");
                        statusFrame.DFLeftText:Show();
                    end
                    statusFrame.DFRightText:SetText(valueDisplay);
                    statusFrame.DFRightText:Show();
                    textString:Hide();
                else
                    valueDisplay = "(" .. math.ceil((value / valueMax) * 100) .. "%) " .. valueDisplay .. " / " ..
                                       valueMaxDisplay;
                end
                textString:SetText(valueDisplay);
            else
                valueDisplay = math.ceil((value / valueMax) * 100) .. "%";
                if (statusFrame.prefix and
                    (statusFrame.alwaysPrefix or
                        not (statusFrame.cvar and GetCVar(statusFrame.cvar) == "1" and statusFrame.textLockable))) then
                    textString:SetText(statusFrame.prefix .. " " .. valueDisplay);
                else
                    textString:SetText(valueDisplay);
                end
            end
        elseif (value == 0 and statusFrame.zeroText) then
            textString:SetText(statusFrame.zeroText);
            statusFrame.isZero = 1;
            textString:Show();
            return;
        else
            statusFrame.isZero = nil;
            if (statusFrame.prefix and
                (statusFrame.alwaysPrefix or
                    not (statusFrame.cvar and GetCVar(statusFrame.cvar) == "1" and statusFrame.textLockable))) then
                textString:SetText(statusFrame.prefix .. " " .. valueDisplay .. " / " .. valueMaxDisplay);
            else
                textString:SetText(valueDisplay .. " / " .. valueMaxDisplay);
            end
        end
    else
        textString:Hide();
        textString:SetText("");
        if (not statusFrame.alwaysShow) then
            statusFrame:Hide();
        else
            statusFrame:SetValue(0);
        end
    end
end

local function DFTextStatusBar_UpdateTextString(textStatusBar)
    local textString = textStatusBar.DFTextString;
    if (textString) then
        local value = textStatusBar:GetValue();
        local valueMin, valueMax = textStatusBar:GetMinMaxValues();
        DFTextStatusBar_UpdateTextStringWithValues(textStatusBar, textString, value, valueMin, valueMax);
    end
end

function SubModuleMixin:UpdatePartyManaBar(i)
    local pf = _G['PartyMemberFrame' .. i]
    local manabar = _G['PartyMemberFrame' .. i .. 'ManaBar']
    if UnitExists(pf.unit) then
        local powerType, powerTypeString = UnitPowerType(pf.unit)
        -- powerTypeString = 'RUNIC_POWER'

        if powerTypeString == 'MANA' then
            manabar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Mana')
        elseif powerTypeString == 'FOCUS' then
            manabar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Focus')
        elseif powerTypeString == 'RAGE' then
            manabar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Rage')
        elseif powerTypeString == 'ENERGY' then
            manabar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Energy')
        elseif powerTypeString == 'RUNIC_POWER' then
            manabar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-RunicPower')
        end
        manabar:SetStatusBarColor(1, 1, 1, 1)
        DFTextStatusBar_UpdateTextString(manabar)
    else
    end
    -- print('UpdatePartyManaBar', i, powerType, powerTypeString)
end

function SubModuleMixin:UpdatePartyHPBar(i)
    local pf = _G['PartyMemberFrame' .. i]
    local healthbar = _G['PartyMemberFrame' .. i .. 'HealthBar']
    if UnitExists(pf.unit) then
        if self.ModuleRef.db.profile.party.classcolor then
            healthbar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Health-Status')
            local localizedClass, englishClass, classIndex = UnitClass(pf.unit)
            healthbar:SetStatusBarColor(DF:GetClassColor(englishClass, 1))
        else
            healthbar:GetStatusBarTexture():SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Partyframe\\UI-HUD-UnitFrame-Party-PortraitOn-Bar-Health')
            healthbar:SetStatusBarColor(1, 1, 1, 1)
        end
        DFTextStatusBar_UpdateTextString(healthbar)
    else
    end
end

function SubModuleMixin:AddStateUpdater()
    for i = 1, 4 do
        local pf = _G['PartyMemberFrame' .. i]
        Mixin(pf, DragonflightUIStateHandlerMixin)
        pf:InitStateHandler()
        pf:SetUnit('party' .. i)
    end
end

