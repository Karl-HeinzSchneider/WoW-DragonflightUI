local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Buffs'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        scale = 1,
        buffs = {
            scale = 1,
            anchorFrame = 'MinimapCluster',
            customAnchorFrame = '',
            anchor = 'TOPRIGHT',
            anchorParent = 'TOPLEFT',
            x = -55,
            y = -13,
            expanded = true,
            -- Visibility
            showMouseover = false,
            hideAlways = false,
            hideCombat = false,
            hideOutOfCombat = false,
            hidePet = false,
            hideNoPet = false,
            hideStance = false,
            hideStealth = false,
            hideNoStealth = false,
            hideBattlePet = false,
            hideCustom = false,
            hideCustomCond = '',
            useStateHandler = true
        },
        debuffs = {
            scale = 1,
            anchorFrame = 'MinimapCluster',
            customAnchorFrame = '',
            anchor = 'TOPRIGHT',
            anchorParent = 'TOPLEFT',
            x = -55,
            y = -13 - 110,
            -- Visibility
            showMouseover = false,
            hideAlways = false,
            hideCombat = false,
            hideOutOfCombat = false,
            hidePet = false,
            hideNoPet = false,
            hideStance = false,
            hideStealth = false,
            hideNoStealth = false,
            hideBattlePet = false,
            hideCustom = false,
            hideCustomCond = ''
        }
    }
}
Module:SetDefaults(defaults)

local function getDefaultStr(key, sub)
    return Module:GetDefaultStr(key, sub)
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

local presetDesc =
    'Sets Scale, Anchor, AnchorParent, AnchorFrame, X and Y to that of the chosen preset, but does not change any other setting.';

local function setPreset(T, preset, sub)
    -- print('setPreset')
    -- DevTools_Dump(T)
    -- print('---')
    -- DevTools_Dump(preset)

    for k, v in pairs(preset) do
        --
        T[k] = v;
    end
    Module:ApplySettings(sub)
    Module:RefreshOptionScreens()
end

local generalOptions = {
    type = 'group',
    name = 'Buffs',
    get = getOption,
    set = setOption,
    args = {
        -- scale = {
        --     type = 'range',
        --     name = 'Scale',
        --     desc = '' .. getDefaultStr('scale', 'minimap'),
        --     min = 0.1,
        --     max = 5,
        --     bigStep = 0.1,
        --     order = 1
        -- }    
    }
}

local frameTable = {
    {value = 'UIParent', text = 'UIParent', tooltip = 'descr', label = 'label'},
    {value = 'MinimapCluster', text = 'MinimapCluster', tooltip = 'descr', label = 'label'}
}

local buffsOptions = {
    type = 'group',
    name = L["BuffsOptionsName"],
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
        expanded = {
            type = 'toggle',
            name = L["BuffsOptionsExpanded"],
            desc = L["BuffsOptionsExpandedDesc"] .. getDefaultStr('expanded', 'buffs'),
            group = 'headerStyling',
            order = 10,
            new = false,
            editmode = true
        },
        useStateHandler = {
            type = 'toggle',
            name = L["BuffsOptionsUseStateHandler"],
            desc = L["BuffsOptionsUseStateHandlerDesc"] .. getDefaultStr('useStateHandler', 'buffs'),
            group = 'headerStyling',
            order = 115
        }
    }
}

-- blizz options buffs
if DF.Cata then
    local moreOptions = {
        consolidate = {
            type = 'toggle',
            name = CONSOLIDATE_BUFFS_TEXT,
            desc = OPTION_TOOLTIP_CONSOLIDATE_BUFFS,
            group = 'headerStyling',
            order = 13,
            blizzard = true,
            editmode = true
        }
    }

    for k, v in pairs(moreOptions) do buffsOptions.args[k] = v end

    buffsOptions.get = function(info)
        local key = info[1]
        local sub = info[2]

        if sub == 'consolidate' then
            return C_CVar.GetCVarBool("consolidateBuffs")
        else
            return getOption(info)
        end
    end

    local function CVarChangedCB()
        BuffFrame_Update();
    end

    buffsOptions.set = function(info, value)
        local key = info[1]
        local sub = info[2]

        if sub == 'consolidate' then
            if value then
                C_CVar.SetCVar("consolidateBuffs", 1)
            else
                C_CVar.SetCVar("consolidateBuffs", 0)
            end
            CVarChangedCB()
        else
            setOption(info, value)
        end
    end
end
DF.Settings:AddPositionTable(Module, buffsOptions, 'buffs', 'Buffs', getDefaultStr, frameTable)
DragonflightUIStateHandlerMixin:AddStateTable(Module, buffsOptions, 'buffs', 'Buffs', getDefaultStr)
local optionsBuffEditmode = {
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
                local dbTable = Module.db.profile.buffs
                local defaultsTable = defaults.profile.buffs
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
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

local debuffsOptions = {type = 'group', name = 'Debuffs', get = getOption, set = setOption, args = {}}
DF.Settings:AddPositionTable(Module, debuffsOptions, 'debuffs', 'Debuffs', getDefaultStr, frameTable)
DragonflightUIStateHandlerMixin:AddStateTable(Module, debuffsOptions, 'debuffs', 'Debuffs', getDefaultStr)
local optionsDebuffEditmode = {
    name = 'Debuff',
    desc = 'Debuff',
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
                local dbTable = Module.db.profile.debuffs
                local defaultsTable = defaults.profile.debuffs
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'debuffs')
            end,
            order = 16,
            editmode = true,
            new = false
        }
    }
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)
    hooksecurefunc(DF:GetModule('Config'), 'AddConfigFrame', function()
        Module:RegisterSettings()
    end)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    DF:RegisterModuleOptions(mName, generalOptions)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    self:EnableAddonSpecific()

    -- Module.AddStateUpdater()
    Module:AddEditMode()

    Module:ApplySettings()
    Module:RegisterOptionScreens()

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)
        Module:ApplySettings()
        Module:RefreshOptionScreens()
    end)
end

function Module:OnDisable()
end

function Module:RegisterSettings()
    local moduleName = 'Buffs'
    local cat = 'misc'
    local function register(name, data)
        data.module = moduleName;
        DF.ConfigModule:RegisterSettingsElement(name, cat, data, true)
    end

    register('buffs', {order = 1, name = 'Buffs', descr = 'Buffsss', isNew = false})
    register('debuffs', {order = 1, name = 'Debuffs', descr = 'Debuffsss', isNew = false})
end

function Module:RegisterOptionScreens()
    DF.ConfigModule:RegisterSettingsData('buffs', 'misc', {
        name = 'Buffs',
        sub = 'buffs',
        options = buffsOptions,
        default = function()
            setDefaultSubValues('buffs')
        end
    })

    DF.ConfigModule:RegisterSettingsData('debuffs', 'misc', {
        name = 'Debuffs',
        sub = 'debuffs',
        options = debuffsOptions,
        default = function()
            setDefaultSubValues('debuffs')
        end
    })
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame
    local cat = 'Misc'
    configFrame:RefreshCatSub(cat, 'Buffs')
    configFrame:RefreshCatSub(cat, 'Debuffs')

    Module.DFBuffFrame.DFEditModeSelection:RefreshOptionScreen();
    Module.DFDebuffFrame.DFEditModeSelection:RefreshOptionScreen();
end

function Module:ApplySettings(sub)
    local db = Module.db.profile

    if db.buffs.useStateHandler and not Module.StateHandlerAdded then
        Module.StateHandlerAdded = true;
        Module.AddStateUpdater()
    end

    Module.UpdateBuffState(db.buffs)
    Module.UpdateDebuffState(db.debuffs)
end

function Module.AddStateUpdater()
    ---

    Mixin(Module.DFBuffFrame, DragonflightUIStateHandlerMixin)
    Module.DFBuffFrame:InitStateHandler()

    Module.DFBuffFrame.DFShower:ClearAllPoints()
    Module.DFBuffFrame.DFShower:SetPoint('TOPLEFT', Module.DFBuffFrame, 'TOPLEFT', -4, 4)
    Module.DFBuffFrame.DFShower:SetPoint('BOTTOMRIGHT', Module.DFBuffFrame, 'BOTTOMRIGHT', 14, -4)

    Module.DFBuffFrame.DFMouseHandler:ClearAllPoints()
    Module.DFBuffFrame.DFMouseHandler:SetPoint('TOPLEFT', Module.DFBuffFrame, 'TOPLEFT', -4, 4)
    Module.DFBuffFrame.DFMouseHandler:SetPoint('BOTTOMRIGHT', Module.DFBuffFrame, 'BOTTOMRIGHT', 14, -4)

    ---

    Mixin(Module.DFDebuffFrame, DragonflightUIStateHandlerMixin)
    Module.DFDebuffFrame:InitStateHandler(4, 4)
end

function Module:AddEditMode()
    local EditModeModule = DF:GetModule('Editmode');
    EditModeModule:AddEditModeToFrame(Module.DFBuffFrame)

    Module.DFBuffFrame.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'Buffs'
    end)

    Module.DFBuffFrame.DFEditModeSelection:RegisterOptions({
        name = 'Buffs',
        sub = 'buffs',
        advancedName = 'Buffs',
        options = buffsOptions,
        extra = optionsBuffEditmode,
        default = function()
            setDefaultSubValues('buffs')
        end,
        moduleRef = self
    });

    -- Module.DFBuffFrame.DFEditModeSelection:ClearAllPoints()
    -- Module.DFBuffFrame.DFEditModeSelection:SetPoint('TOPLEFT', Module.DFBuffFrame, 'TOPLEFT', -16, 32)
    -- Module.DFBuffFrame.DFEditModeSelection:SetPoint('BOTTOMRIGHT', Module.DFBuffFrame, 'BOTTOMRIGHT', 16, -16)

    EditModeModule:AddEditModeToFrame(Module.DFDebuffFrame)

    Module.DFDebuffFrame.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'Debuffs'
    end)

    Module.DFDebuffFrame.DFEditModeSelection:RegisterOptions({
        name = 'Debuffs',
        sub = 'debuffs',
        advancedName = 'Debuffs',
        options = debuffsOptions,
        extra = optionsDebuffEditmode,
        default = function()
            setDefaultSubValues('debuffs')
        end,
        moduleRef = self
    });
end

function Module.CreateBuffFrame()
    local f = CreateFrame('FRAME', 'DragonflightUIBuffFrame', UIParent)
    f:SetSize(30 + (10 - 1) * 35, 30 + (3 - 1) * 35)
    f:SetPoint('TOPRIGHT', MinimapCluster, 'TOPLEFT', -55, -13)
    Module.DFBuffFrame = f
    f:SetClampedToScreen(true)

    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\bagslots2x'

    local toggleFrame = CreateFrame('FRAME', 'DragonflightUIBuffFrameToggleFrame', f)
    toggleFrame:SetSize(16, 30)
    toggleFrame:SetPoint('TOPLEFT', f, 'TOPRIGHT', 0, 0)
    Module.DFToggleFrame = toggleFrame

    local toggle = CreateFrame('CHECKBUTTON', 'DragonflightUI', toggleFrame)
    toggle:SetSize(16, 30)
    toggle:SetPoint('CENTER', toggleFrame, 'CENTER', 0, 0)
    toggle:SetScale(0.48)
    toggle:SetHitRectInsets(-10, -10, -15, -15)

    Module.DFToggleFrame.Toggle = toggle

    toggle:SetNormalTexture(base)
    toggle:SetPushedTexture(base)
    toggle:SetHighlightTexture(base)
    toggle:GetNormalTexture():SetTexCoord(0.951171875, 0.982421875, 0.015625, 0.25)
    toggle:GetHighlightTexture():SetTexCoord(0.951171875, 0.982421875, 0.015625, 0.25)
    toggle:GetPushedTexture():SetTexCoord(0.951171875, 0.982421875, 0.015625, 0.25)

    toggle:SetScript('OnClick', function()
        setOption({'buffs', 'expanded'}, not Module.db.profile.buffs.expanded)
    end)
end

function Module.UpdateBuffState(state)
    local f = Module.DFBuffFrame

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

        local toggle = Module.DFToggleFrame.Toggle

        toggle:GetNormalTexture():SetRotation(rotation)
        toggle:GetPushedTexture():SetRotation(rotation)
        toggle:GetHighlightTexture():SetRotation(rotation)
    end

    BuffFrame:SetScale(state.scale)
    BuffFrame:ClearAllPoints()
    -- BuffFrame:SetPoint(state.anchor, state.anchorFrame, state.anchorParent, state.x, state.y)
    BuffFrame:SetPoint('TOPRIGHT', f, 'TOPRIGHT', 0, 0)

    BuffFrame:SetShown(state.expanded)
    BuffFrame:SetParent(f)

    TemporaryEnchantFrame:SetScale(state.scale)
    TemporaryEnchantFrame:SetParent(f)

    if Module.StateHandlerAdded then f:UpdateStateHandler(state) end
end

function Module.MoveBuffs()
    hooksecurefunc('UIParent_UpdateTopFramePositions', function()
        -- print('UIParent_UpdateTopFramePositions')
        local state = Module.db.profile.buffs
        Module.UpdateBuffState(state)
    end)
end

-- set default, may be overriden by darkmode module
Module.BuffVertexColorR = 1.0;
Module.BuffVertexColorG = 1.0;
Module.BuffVertexColorB = 1.0;
Module.BuffDesaturate = false;
function Module.AddBuffBorders()
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
            buff.DFIconBorder:SetDesaturated(Module.BuffDesaturate)
            buff.DFIconBorder:SetVertexColor(Module.BuffVertexColorR, Module.BuffVertexColorG, Module.BuffVertexColorB)
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

    hooksecurefunc('TargetFrame_UpdateAuras', function(self)
        -- also styles focusFrame
        -- print('TargetFrame_UpdateAuras', self:GetName())
        local frame, frameName, frameStealable;
        local selfName = self:GetName();
        for i = 1, MAX_TARGET_BUFFS do
            frameName = selfName .. "Buff" .. (i);
            frame = _G[frameName];

            if frame and frame:IsShown() then
                -- 
                if not frame.DFIconBorder then
                    --
                    DragonflightUIMixin:AddIconBorder(frame, true)
                    frame.DFIconBorder:SetDesaturated(Module.BuffDesaturate)
                    frame.DFIconBorder:SetVertexColor(Module.BuffVertexColorR, Module.BuffVertexColorG,
                                                      Module.BuffVertexColorB)
                end

                -- TODO: style etc
                -- frameStealable = _G[frameName .. "Stealable"];
                -- frameStealable:Show()
            end
        end

        local maxDebuffs = self.maxDebuffs or MAX_TARGET_DEBUFFS; -- max = 16

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

function Module.CreateDebuffFrame()
    local f = CreateFrame('FRAME', 'DragonflightUIDebuffFrame', UIParent)
    f:SetSize(30 + (10 - 1) * 35, 30 + (2 - 1) * 35)
    f:SetPoint('TOPRIGHT', MinimapCluster, 'TOPLEFT', -55, -13 - 110)
    f:SetClampedToScreen(true)
    Module.DFDebuffFrame = f
end

function Module.MoveDebuffs()
    local f = Module.DFDebuffFrame
    hooksecurefunc('DebuffButton_UpdateAnchors', function(buttonName, index)
        -- print('update', buttonName, index)

        local state = Module.db.profile.debuffs
        local buff = _G[buttonName .. index];
        buff:SetScale(state.scale)
        buff:SetParent(f)
        -- buff:Show()

        if index ~= 1 then return end

        -- buff:SetPoint("TOPRIGHT", BuffFrame, "BOTTOMRIGHT", 0, -DebuffButton1.offsetY);
        buff:ClearAllPoints()
        buff:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0);
    end)
end

function Module.UpdateDebuffState(state)
    local f = Module.DFDebuffFrame

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    f:SetScale(state.scale)
    f:ClearAllPoints()
    f:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

    for i = 1, 12 do
        local buff = _G['DebuffButton' .. i];
        if buff then
            buff:SetScale(state.scale)
            buff:SetParent(f)
            -- buff:Show()
        end
    end

    if Module.StateHandlerAdded then f:UpdateStateHandler(state) end
end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1, arg2, arg3)
    -- print('event', event)    
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module:Era()
    Module.CreateBuffFrame()
    Module.AddBuffBorders()
    Module.MoveBuffs()
    Module.CreateDebuffFrame()
    Module.MoveDebuffs()
end

function Module:TBC()
end

function Module:Wrath()
    Module.CreateBuffFrame()
    Module.AddBuffBorders()
    Module.MoveBuffs()
    Module.CreateDebuffFrame()
    Module.MoveDebuffs()
end

function Module:Cata()
    Module.CreateBuffFrame()
    Module.AddBuffBorders()
    Module.MoveBuffs()
    Module.CreateDebuffFrame()
    Module.MoveDebuffs()
end

function Module:Mists()
    Module.CreateBuffFrame()
    Module.AddBuffBorders()
    Module.MoveBuffs()
    Module.CreateDebuffFrame()
    Module.MoveDebuffs()
end
