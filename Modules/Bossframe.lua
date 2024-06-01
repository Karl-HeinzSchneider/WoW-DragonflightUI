local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Bossframe'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')
Module.Tmp = {}

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        scale = 1,
        boss = {
            scale = 1,
            anchorFrame = 'MinimapCluster',
            anchor = 'TOPRIGHT',
            anchorParent = 'BOTTOMRIGHT',
            x = -49.2,
            y = 0,
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
                return DF:GetModuleEnabled(mName)
            end,
            set = function(info, v)
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
            desc = 'Lock the Minimap. Unlocked Minimap can be moved with shift-click and drag ' ..
                getDefaultStr('locked'),
            order = 103
        },
        durability = {
            type = 'select',
            name = 'Durability',
            desc = 'Durability' .. getDefaultStr('durability', barname),
            values = {
                ['HIDDEN'] = 'HIDDEN',
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT'
            },
            order = 110
        },
        trackerHeader = {type = 'header', name = 'Questtracker', desc = '', order = 120}
    }
}

local frameTable = {['UIParent'] = 'UIParent', ['MinimapCluster'] = 'MinimapCluster'}

local bossOptions = {
    type = 'group',
    name = 'Minimap',
    get = getOption,
    set = setOption,
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'boss'),
            min = 0.1,
            max = 5,
            bigStep = 0.1,
            order = 1
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'boss'),
            values = frameTable,
            order = 4
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'boss'),
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
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'boss'),
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
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', 'boss'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', 'boss'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6
        },
        locked = {
            type = 'toggle',
            name = 'Locked',
            desc = 'Lock the Minimap. Unlocked Minimap can be moved with shift-click and drag ' ..
                getDefaultStr('locked', 'boss'),
            order = 10
        },
        durability = {
            type = 'select',
            name = 'Durability',
            desc = 'Durability' .. getDefaultStr('durability', 'boss'),
            values = {
                ['HIDDEN'] = 'HIDDEN',
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT'
            },
            order = 20
        }
    }
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    DF:RegisterModuleOptions(mName, options)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    if DF.Cata then
        Module.Cata()
    else
        Module.Era()
    end

    Module.ApplySettings()
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
    DF.ConfigModule:RegisterOptionScreen('Unitframes', 'Boss', {
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
        local subCat = configFrame:GetSubCategory('Unitframes', name)
        subCat.displayFrame:CallRefresh()
    end

    refreshCat('Boss')
end

function Module:ApplySettings()
    local db = Module.db.profile
end

function Module:CreateBossFrames()

    for id = 1, 1 do
        print('createBossFrames', id)
        local f = Module:CreateBossFrame(id)
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

function Module:CreateBossFrame(id)
    local name = 'DragonflightUIBoss' .. id .. 'Frame'
    local f = CreateFrame('Button', name, UIParent, 'DragonflightUIBossframeTemplate')
    local unit = 'player'
    f:Setup(unit)

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

-- Cata
function Module.Cata()
    Module:CreateBossFrames()
end

-- Wrath
function Module.Wrath()
end

-- Era
function Module.Era()
end
