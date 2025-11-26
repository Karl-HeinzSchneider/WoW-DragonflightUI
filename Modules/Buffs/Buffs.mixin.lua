local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local subModuleName = 'Buff';
local SubModuleMixin = {};
addonTable.SubModuleMixins[subModuleName] = SubModuleMixin;

function SubModuleMixin:Init()
    self.ModuleRef = DF:GetModule('Buffs')
    self:SetDefaults()
    self:SetupOptions();
    -- self:SetScript('OnEvent', self.OnEvent);
end

function SubModuleMixin:SetDefaults()
    local defaults = {
        scale = 1,
        anchorFrame = 'MinimapCluster',
        customAnchorFrame = '',
        anchor = 'TOPRIGHT',
        anchorParent = 'TOPLEFT',
        x = -55,
        y = -13,
        expanded = true,
        -- auraheader
        seperateOwn = '0',
        sortMethod = 'INDEX',
        sortDirection = '+',
        groupBy = '',
        point = 'TOPRIGHT',
        orientation = 'rightToLeft',
        growthDirection = 'down',
        paddingX = 5,
        paddingY = 14,
        wrapAfter = 10,
        -- wrapXOffset = 0,
        -- wrapYOffset = 14,
        maxWraps = 4,
        --
        hideDurationText = false,
        hideCooldownSwipe = false,
        hideCooldownDurationText = true,
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
        hideCustomCond = '',
        useStateHandler = true
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

    local options = {
        type = 'group',
        name = L["BuffsOptionsName"],
        advancedName = 'Buffs',
        sub = 'buffs',
        get = getOption,
        set = setOption,
        args = {
            headerStyling = {
                type = 'header',
                name = L["BuffsOptionsStyle"],
                desc = L["BuffsOptionsStyleDesc"],
                order = 20,
                isExpanded = true,
                editmode = true
            },
            -- expanded = {
            --     type = 'toggle',
            --     name = L["BuffsOptionsExpanded"],
            --     desc = L["BuffsOptionsExpandedDesc"] .. getDefaultStr('expanded', 'buffs'),
            --     group = 'headerStyling',
            --     order = 10,
            --     new = false,
            --     editmode = true
            -- },
            useStateHandler = {
                type = 'toggle',
                name = L["BuffsOptionsUseStateHandler"],
                desc = L["BuffsOptionsUseStateHandlerDesc"] .. getDefaultStr('useStateHandler', 'buffs'),
                group = 'headerStyling',
                order = 115
            }
        }
    }
    -- -- blizz options buffs
    -- if DF.Cata then
    --     local moreOptions = {
    --         consolidate = {
    --             type = 'toggle',
    --             name = CONSOLIDATE_BUFFS_TEXT,
    --             desc = OPTION_TOOLTIP_CONSOLIDATE_BUFFS,
    --             group = 'headerStyling',
    --             order = 13,
    --             blizzard = true,
    --             editmode = true
    --         }
    --     }

    --     for k, v in pairs(moreOptions) do options.args[k] = v end

    --     options.get = function(info)
    --         local key = info[1]
    --         local sub = info[2]

    --         if sub == 'consolidate' then
    --             return C_CVar.GetCVarBool("consolidateBuffs")
    --         else
    --             return getOption(info)
    --         end
    --     end

    --     local function CVarChangedCB()
    --         BuffFrame_Update();
    --     end

    --     options.set = function(info, value)
    --         local key = info[1]
    --         local sub = info[2]

    --         if sub == 'consolidate' then
    --             if value then
    --                 C_CVar.SetCVar("consolidateBuffs", 1)
    --             else
    --                 C_CVar.SetCVar("consolidateBuffs", 0)
    --             end
    --             CVarChangedCB()
    --         else
    --             setOption(info, value)
    --         end
    --     end
    -- end

    DF.Settings:AddPositionTable(Module, options, 'buffs', 'Buffs', getDefaultStr, frameTable)
    DragonflightUIStateHandlerMixin:AddStateTable(Module, options, 'buffs', 'Buffs', getDefaultStr)
    DragonflightUIBuffContainerMixin:AddAuraHeaderTable(Module, options, sub, getDefaultStr)

    local optionsEditmode = {
        name = 'Buff',
        desc = 'Buff',
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
                    local dbTable = self.ModuleRef.db.profile.buffs
                    local defaultsTable = self.Defaults
                    setPreset(dbTable, {
                        scale = defaultsTable.scale,
                        anchor = defaultsTable.anchor,
                        anchorParent = defaultsTable.anchorParent,
                        anchorFrame = defaultsTable.anchorFrame,
                        x = defaultsTable.x,
                        y = defaultsTable.y
                    }, 'buffs')
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
    -- 
    local function setDefaultSubValues(sub)
        self.ModuleRef:SetDefaultSubValues(sub)
    end

    DF.ConfigModule:RegisterSettingsData('buffs', 'misc', {
        options = self.Options,
        default = function()
            setDefaultSubValues(self.Options.sub)
        end
    })

    --
    self:CreateBuffFrame()
    -- self:AddBuffBorders()
    -- self:MoveBuffs()

    self:CreateNewBuffs()

    --
    local EditModeModule = DF:GetModule('Editmode');
    EditModeModule:AddEditModeToFrame(self.DFBuffFrame)

    self.DFBuffFrame.DFEditModeSelection:SetGetLabelTextFunction(function()
        return self.Options.name
    end)

    self.DFBuffFrame.DFEditModeSelection:RegisterOptions({
        options = self.Options,
        extra = self.OptionsEditmode,
        default = function()
            setDefaultSubValues(self.Options.sub)
        end,
        moduleRef = self.ModuleRef
    });

    -- Module.DFBuffFrame.DFEditModeSelection:ClearAllPoints()
    -- Module.DFBuffFrame.DFEditModeSelection:SetPoint('TOPLEFT', Module.DFBuffFrame, 'TOPLEFT', -16, 32)
    -- Module.DFBuffFrame.DFEditModeSelection:SetPoint('BOTTOMRIGHT', Module.DFBuffFrame, 'BOTTOMRIGHT', 16, -16)
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

    local f = self.DFBuffFrame

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    f:SetScale(state.scale)
    f:ClearAllPoints()
    f:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

    -- local toggelFrame = Module.DFToggleFrame
    -- toggleFrame:SetScale(state.scale)
    do
        local rotation

        if (state.expanded) then
            rotation = math.pi
        else
            rotation = 0
        end

        local toggle = self.DFToggleFrame.Toggle

        toggle:GetNormalTexture():SetRotation(rotation)
        toggle:GetPushedTexture():SetRotation(rotation)
        toggle:GetHighlightTexture():SetRotation(rotation)
    end

    -- BuffFrame:SetScale(state.scale)
    -- BuffFrame:ClearAllPoints()
    -- -- BuffFrame:SetPoint(state.anchor, state.anchorFrame, state.anchorParent, state.x, state.y)
    -- BuffFrame:SetPoint('TOPRIGHT', f, 'TOPRIGHT', 0, 0)

    -- BuffFrame:SetShown(state.expanded)
    -- BuffFrame:SetParent(f)

    -- TemporaryEnchantFrame:SetScale(state.scale)
    -- TemporaryEnchantFrame:SetParent(f)

    -- if state.useStateHandler and not self.StateHandlerAdded then
    --     self.StateHandlerAdded = true;
    --     self:AddStateUpdater()
    -- end

    self.NewBuffs:SetState(state)

    if self.StateHandlerAdded then f:UpdateStateHandler(state) end
end

function SubModuleMixin:CreateBuffFrame()
    local f = CreateFrame('FRAME', 'DragonflightUIPlayerBuffFrame', UIParent)
    f:SetSize(30 + (10 - 1) * 35, 30 + (3 - 1) * 35)
    f:SetPoint('TOPRIGHT', MinimapCluster, 'TOPLEFT', -55, -13)
    self.DFBuffFrame = f
    f:SetClampedToScreen(true)

    local function SetEditMode(editmode)
        -- print('~> SetEditMode', editmode)
        self.DFEditMode = editmode
    end

    function f:SetEditMode(editmode)
        SetEditMode(editmode)
    end

    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\bagslots2x'

    local toggleFrame = CreateFrame('FRAME', 'DragonflightUIBuffFrameToggleFrame', f)
    toggleFrame:SetSize(16, 30)
    toggleFrame:SetPoint('TOPLEFT', f, 'TOPRIGHT', 0, 0)
    self.DFToggleFrame = toggleFrame
    toggleFrame:Hide() -- TODO

    local toggle = CreateFrame('CHECKBUTTON', 'DragonflightUI', toggleFrame)
    toggle:SetSize(16, 30)
    toggle:SetPoint('CENTER', toggleFrame, 'CENTER', 0, 0)
    toggle:SetScale(0.48)
    toggle:SetHitRectInsets(-10, -10, -15, -15)

    self.DFToggleFrame.Toggle = toggle

    toggle:SetNormalTexture(base)
    toggle:SetPushedTexture(base)
    toggle:SetHighlightTexture(base)
    toggle:GetNormalTexture():SetTexCoord(0.951171875, 0.982421875, 0.015625, 0.25)
    toggle:GetHighlightTexture():SetTexCoord(0.951171875, 0.982421875, 0.015625, 0.25)
    toggle:GetPushedTexture():SetTexCoord(0.951171875, 0.982421875, 0.015625, 0.25)

    local function setOption(info, value)
        self.ModuleRef:SetOption(info, value)
    end

    toggle:SetScript('OnClick', function()
        setOption({'buffs', 'expanded'}, not self.ModuleRef.db.profile.buffs.expanded)
    end)
end

function SubModuleMixin:MoveBuffs()
    hooksecurefunc('UIParent_UpdateTopFramePositions', function()
        -- print('UIParent_UpdateTopFramePositions')
        -- local state = self.ModuleRef.db.profile.buffs
        -- self:UpdateBuffState(state)
        self:Update()
    end)
end

function SubModuleMixin:AddBuffBorders()
    -- set default, may be overriden by darkmode module
    self.BuffVertexColorR = 1.0;
    self.BuffVertexColorG = 1.0;
    self.BuffVertexColorB = 1.0;
    self.BuffDesaturate = false;

    -- buffs
    hooksecurefunc('AuraButton_Update', function(buttonName, index, filter) --

        local buffName = buttonName .. index;
        local buff = _G[buffName];

        if not buff then return end
        if not buff:IsShown() then return end

        -- print(buttonName, index, filter)
        local helpful = (filter == "HELPFUL" or filter == "HELPFUL");

        if not buff.DFIconBorder then
            --
            DragonflightUIMixin:AddIconBorder(buff, helpful)
            buff.DFIconBorder:SetDesaturated(self.BuffDesaturate)
            buff.DFIconBorder:SetVertexColor(self.BuffVertexColorR, self.BuffVertexColorG, self.BuffVertexColorB)
        end

        if (not helpful) then
            local debuffSlot = _G[buffName .. "Border"];
            if not debuffSlot then return end

            debuffSlot:Hide()

            local r, g, b = debuffSlot:GetVertexColor()
            -- print(r, g, b)
            buff.DFIconBorder:SetVertexColor(r, g, b)
        end
    end)

    hooksecurefunc('TargetFrame_UpdateAuras', function(frameRef)
        -- also styles focusFrame
        -- print('TargetFrame_UpdateAuras', self:GetName())
        local frame, frameName, frameStealable;
        local selfName = frameRef:GetName();
        for i = 1, MAX_TARGET_BUFFS do
            frameName = selfName .. "Buff" .. (i);
            frame = _G[frameName];

            if frame and frame:IsShown() then
                -- 
                if not frame.DFIconBorder then
                    --
                    DragonflightUIMixin:AddIconBorder(frame, true)
                    frame.DFIconBorder:SetDesaturated(self.BuffDesaturate)
                    frame.DFIconBorder:SetVertexColor(self.BuffVertexColorR, self.BuffVertexColorG,
                                                      self.BuffVertexColorB)
                end

                -- TODO: style etc
                -- frameStealable = _G[frameName .. "Stealable"];
                -- frameStealable:Show()
            end
        end

        local maxDebuffs = frameRef.maxDebuffs or MAX_TARGET_DEBUFFS; -- max = 16

        for i = 1, maxDebuffs do
            frameName = selfName .. "Debuff" .. (i);
            frame = _G[frameName];

            if frame and frame:IsShown() then
                -- 
                if not frame.DFIconBorder then
                    --
                    DragonflightUIMixin:AddIconBorder(frame, false)
                end

                local debuffSlot = _G[frameName .. "Border"];
                if debuffSlot then
                    --
                    debuffSlot:Hide()
                    local r, g, b = debuffSlot:GetVertexColor()
                    -- print(r, g, b)
                    frame.DFIconBorder:SetVertexColor(r, g, b)
                end
            end
        end
    end)
end

function SubModuleMixin:AddStateUpdater()
    Mixin(self.DFBuffFrame, DragonflightUIStateHandlerMixin)
    self.DFBuffFrame:InitStateHandler()

    self.DFBuffFrame.DFShower:ClearAllPoints()
    self.DFBuffFrame.DFShower:SetPoint('TOPLEFT', self.DFBuffFrame, 'TOPLEFT', -4, 4)
    self.DFBuffFrame.DFShower:SetPoint('BOTTOMRIGHT', self.DFBuffFrame, 'BOTTOMRIGHT', 14, -4)

    self.DFBuffFrame.DFMouseHandler:ClearAllPoints()
    self.DFBuffFrame.DFMouseHandler:SetPoint('TOPLEFT', self.DFBuffFrame, 'TOPLEFT', -4, 4)
    self.DFBuffFrame.DFMouseHandler:SetPoint('BOTTOMRIGHT', self.DFBuffFrame, 'BOTTOMRIGHT', 14, -4)
end

function SubModuleMixin:CreateNewBuffs()
    local container = CreateFrame("Frame", "DragonflightUIPlayerBuffFrameContainer", self.DFBuffFrame,
                                  "DragonflightUIBuffFrameContainerTemplate");
    container:SetPoint('TOPRIGHT', self.DFBuffFrame, 'TOPRIGHT', 0, 0)
    container:SetPoint('BOTTOMLEFT', self.DFBuffFrame, 'BOTTOMLEFT', 0, 0)
    container.Header:SetParent(self.DFBuffFrame)
    -- container:SetSize(30, 30)
    container:Show();

    self.NewBuffs = container
end

