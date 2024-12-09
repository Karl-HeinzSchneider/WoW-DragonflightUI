local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Buffs'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        scale = 1,
        buffs = {
            scale = 1,
            anchorFrame = 'MinimapCluster',
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
            hideCustom = false,
            hideCustomCond = ''
        },
        debuffs = {
            scale = 1,
            anchorFrame = 'MinimapCluster',
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

local frameTable = {['UIParent'] = 'UIParent', ['MinimapCluster'] = 'MinimapCluster'}

local buffsOptions = {
    type = 'group',
    name = 'Buffs',
    get = getOption,
    set = setOption,
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'buffs'),
            min = 0.1,
            max = 5,
            bigStep = 0.1,
            order = 1
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'buffs'),
            values = frameTable,
            order = 4
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'buffs'),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            order = 2
        },
        anchorParent = {
            type = 'select',
            name = 'AnchorParent',
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'buffs'),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            order = 3
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'buffs'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'buffs'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6
        },
        expanded = {
            type = 'toggle',
            name = 'Expanded',
            desc = '' .. getDefaultStr('expanded', 'buffs'),
            order = 10,
            new = true
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
            order = 13,
            blizzard = true
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
DragonflightUIStateHandlerMixin:AddStateTable(Module, buffsOptions, 'buffs', 'Buffs', getDefaultStr)

local debuffsOptions = {
    type = 'group',
    name = 'Debuffs',
    get = getOption,
    set = setOption,
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'debuffs'),
            min = 0.1,
            max = 5,
            bigStep = 0.1,
            order = 1
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'debuffs'),
            values = frameTable,
            order = 4
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'debuffs'),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            order = 2
        },
        anchorParent = {
            type = 'select',
            name = 'AnchorParent',
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'debuffs'),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            order = 3
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'debuffs'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'debuffs'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6
        }
    }
}
DragonflightUIStateHandlerMixin:AddStateTable(Module, debuffsOptions, 'debuffs', 'Debuffs', getDefaultStr)

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    DF:RegisterModuleOptions(mName, generalOptions)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    if DF.Cata then
        Module.Cata()
    elseif DF.Wrath then
        Module.Wrath()
    else
        Module.Era()
    end

    Module.AddStateUpdater()

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

function Module:RegisterOptionScreens()
    DF.ConfigModule:RegisterOptionScreen('Misc', 'Buffs', {
        name = 'Buffs',
        sub = 'buffs',
        options = buffsOptions,
        default = function()
            setDefaultSubValues('buffs')
        end
    })

    DF.ConfigModule:RegisterOptionScreen('Misc', 'Debuffs', {
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
end

function Module:ApplySettings()
    local db = Module.db.profile

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

function Module.CreateBuffFrame()
    local f = CreateFrame('FRAME', 'DragonflightUIBuffFrame', UIParent)
    f:SetSize(30 + (10 - 1) * 35, 30 + (3 - 1) * 35)
    f:SetPoint('TOPRIGHT', MinimapCluster, 'TOPLEFT', -55, -13)
    Module.DFBuffFrame = f

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
    f:SetScale(state.scale)
    f:ClearAllPoints()
    f:SetPoint(state.anchor, state.anchorFrame, state.anchorParent, state.x, state.y)

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

    f:UpdateStateHandler(state)
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
    f:SetScale(state.scale)
    f:ClearAllPoints()
    f:SetPoint(state.anchor, state.anchorFrame, state.anchorParent, state.x, state.y)

    for i = 1, 12 do
        local buff = _G['DebuffButton' .. i];
        if buff then
            buff:SetScale(state.scale)
            buff:SetParent(f)
            -- buff:Show()
        end
    end

    f:UpdateStateHandler(state)
end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1, arg2, arg3)
    -- print('event', event)    
end
frame:SetScript('OnEvent', frame.OnEvent)

-- Cata
function Module.Cata()
    Module.CreateBuffFrame()
    Module.AddBuffBorders()
    Module.MoveBuffs()
    Module.CreateDebuffFrame()
    Module.MoveDebuffs()
end

-- Wrath
function Module.Wrath()
    Module.CreateBuffFrame()
    Module.AddBuffBorders()
    Module.MoveBuffs()
    Module.CreateDebuffFrame()
    Module.MoveDebuffs()
end

-- Era
function Module.Era()
    Module.CreateBuffFrame()
    Module.AddBuffBorders()
    Module.MoveBuffs()
    Module.CreateDebuffFrame()
    Module.MoveDebuffs()
end
