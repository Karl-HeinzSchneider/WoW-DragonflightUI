---@class DragonflightUI
---@diagnostic disable-next-line: assign-type-mismatch
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Bossframe'
---@diagnostic disable-next-line: undefined-field
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')
Module.Tmp = {}

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        scale = 1,
        boss = {
            scale = 1,
            anchorFrame = 'MinimapCluster',
            customAnchorFrame = '',
            anchor = 'TOPRIGHT',
            anchorParent = 'BOTTOMRIGHT',
            x = -200,
            y = -140,
            locked = true,
            durability = 'BOTTOM'
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

local options = {
    type = 'group',
    name = 'DragonflightUI - ' .. mName,
    get = getOption,
    set = setOption,
    args = {
        toggle = {
            type = 'toggle',
            name = 'Enable',
            get = function()
                ---@diagnostic disable-next-line: undefined-field
                return DF:GetModuleEnabled(mName)
            end,
            set = function(info, v)
                ---@diagnostic disable-next-line: undefined-field
                DF:SetModuleEnabled(mName, v)
            end,
            order = 1
        },
        reload = {
            type = 'execute',
            name = '/reload',
            desc = 'reloads UI',
            func = function()
                ReloadUI()
            end,
            order = 1.1
        },
        defaults = {
            type = 'execute',
            name = 'Defaults',
            desc = 'Sets Config to default values',
            func = setDefaultValues,
            order = 1.1
        },
        --[[ config = {type = 'header', name = 'Config - Player', order = 100}, ]]
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale'),
            min = 0.2,
            max = 3,
            bigStep = 0.025,
            order = 101,
            disabled = false
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to TOPRIGHT' .. getDefaultStr('x'),
            min = -2500,
            max = 2500,
            bigStep = 0.50,
            order = 102
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to TOPRIGHT' .. getDefaultStr('y'),
            min = -2500,
            max = 2500,
            bigStep = 0.50,
            order = 102
        },
        locked = {
            type = 'toggle',
            name = 'Locked',
            desc = 'Lock the Preview Frame.' .. getDefaultStr('locked'),
            order = 103
        },
        trackerHeader = {type = 'header', name = 'Questtracker', desc = '', order = 120}
    }
}

local frameTable = {
    {value = 'UIParent', text = 'UIParent', tooltip = 'descr', label = 'label'},
    {value = 'MinimapCluster', text = 'MinimapCluster', tooltip = 'descr', label = 'label'}
}

local bossOptions = {
    type = 'group',
    name = 'Minimap',
    get = getOption,
    set = setOption,
    args = {
        locked = {
            type = 'toggle',
            name = 'Locked',
            desc = 'Lock the Preview Frame. Use this to position the frames.' .. getDefaultStr('locked', 'boss'),
            order = 10
        }
    }
}
DF.Settings:AddPositionTable(Module, bossOptions, 'boss', 'Boss', getDefaultStr, frameTable)

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)
    hooksecurefunc(DF:GetModule('Config'), 'AddConfigFrame', function()
        Module:RegisterSettings()
    end)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    DF:RegisterModuleOptions(mName, options)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    if not DF.Cata then return end -- guard TODO

    self:EnableAddonSpecific()

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
    local moduleName = 'Boss'
    local cat = 'unitframes'
    local function register(name, data)
        data.module = moduleName;
        DF.ConfigModule:RegisterSettingsElement(name, cat, data, true)
    end

    if not DF.Cata then return end
    register('boss', {order = 0, name = 'Boss', descr = 'Bossss', isNew = false})
end

function Module:RegisterOptionScreens()
    if not DF.Cata then return end
    DF.ConfigModule:RegisterSettingsData('boss', 'unitframes', {
        name = 'Boss',
        sub = 'boss',
        options = bossOptions,
        default = function()
            setDefaultSubValues('boss')
        end
    })
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame

    local refreshCat = function(name)
        configFrame:RefreshCatSub('Unitframes', name)
    end

    refreshCat('Boss')
end

function Module:ApplySettings()
    local state = Module.db.profile.boss
    if not DF.Cata then return end
    do
        local tex = Module.TmpTex

        if state.locked then
            tex:Hide()
        else
            tex:Show()
            tex:SetScale(state.scale)

            local parent = _G[state.anchorFrame]
            tex:ClearAllPoints()
            tex:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
        end
    end

    for id = 1, 4 do
        local f = Module['BossFrame' .. id]

        f:UpdateState(state)
    end
end

function Module:CreateBossFrames()
    do
        local tex = UIParent:CreateTexture()
        tex:SetPoint('CENTER')
        tex:SetSize(232, 100 + 3 * 70)
        tex:SetColorTexture(1, 1, 0, 0.5)

        Module.TmpTex = tex
    end

    for id = 1, 4 do
        -- print('createBossFrames', id)
        local f = Module:CreateBossFrame(id)

        Module['BossFrame' .. id] = f
    end

    -- frame = CreateFrame(frameType [, name, parent, template, id])

    -- for id = 1, 5 do
    --     local name = 'DragonflightUIBoss' .. id .. 'Frame'
    --     print('create', name)
    --     local f = CreateFrame('Button', name, UIParent, 'BossTargetFrameTemplate', id)
    --     f:SetPoint('CENTER', UIParent, 'CENTER', 0, 80 * id)

    --     if (id == 1) then
    --         BossTargetFrame_OnLoad(f, "boss1", "INSTANCE_ENCOUNTER_ENGAGE_UNIT");
    --     else
    --         BossTargetFrame_OnLoad(f, "boss" .. id);
    --     end
    --     TargetFrame_CreateSpellbar(f, "INSTANCE_ENCOUNTER_ENGAGE_UNIT", true);
    -- end

end

function Module:HideDefault()
    for id = 1, 4 do
        local f = _G['Boss' .. id .. 'TargetFrame']
        f:SetAlpha(0)
    end
end

function Module:CreateBossFrame(id)
    local name = 'DragonflightUIBoss' .. id .. 'Frame'
    local f = CreateFrame('Button', name, UIParent, 'DragonflightUIBossframeTemplate')
    local unit = 'boss' .. id
    -- unit = 'player'
    f:Setup(unit, id)

    return f
end

function Module:HookBossframe()
    local b = _G.Boss1TargetFrame
    b:SetMovable(true)
    b:SetUserPlaced(true)
    b:ClearAllPoints()
    b:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -350, -470)
    b:SetMovable(false)

    local moving
    hooksecurefunc(Boss1TargetFrame, "SetPoint", function(self)
        if moving then return end
        moving = true
        self:SetMovable(true)
        self:SetUserPlaced(true)
        self:ClearAllPoints()
        self:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -350, -470)
        self:SetMovable(false)
        moving = nil
    end)
end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1)
    -- print('event', event) 
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module:Era()
end

function Module:TBC()
end

function Module:Wrath()
end

function Module:Cata()
    Module:CreateBossFrames()
    Module:HideDefault()
end

function Module:Mists()
end
