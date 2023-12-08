local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Castbar'
local Module = DF:NewModule(mName, 'AceConsole-3.0')

local db, getOptions

local defaults = {
    profile = {
        scale = 1,
        x = 0,
        y = 245,
        sizeX = 256,
        sizeY = 16,
        preci = 1,
        preciMax = 2,
        castTimeEnabled = true,
        castTimeMaxEnabled = true,
        compactLayout = true,
        showIcon = false,
        showTicks = false
    }
}

local function getDefaultStr(key)
    return ' (Default: ' .. tostring(defaults.profile[key]) .. ')'
end

local function setDefaultValues()
    for k, v in pairs(defaults.profile) do Module.db.profile[k] = v end
    Module.ApplySettings()
end

-- db[info[#info] = VALUE
local function getOption(info)
    return db[info[#info]]
end

local function setOption(info, value)
    local key = info[1]
    Module.db.profile[key] = value
    Module.ApplySettings()
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
        config = {type = 'header', name = 'Config - Player', order = 100},
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale'),
            min = 0.2,
            max = 3,
            bigStep = 0.1,
            order = 101,
            disabled = false
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to BOTTOM CENTER' .. getDefaultStr('x'),
            min = -2500,
            max = 2500,
            bigStep = 0.50,
            order = 102
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to BOTTOM CENTER' .. getDefaultStr('y'),
            min = -2500,
            max = 2500,
            bigStep = 0.50,
            order = 102
        },
        sizeX = {
            type = 'range',
            name = 'Width',
            desc = getDefaultStr('sizeX'),
            min = 80,
            max = 512,
            bigStep = 1,
            order = 103.1
        },
        sizeY = {
            type = 'range',
            name = 'Height',
            desc = getDefaultStr('sizeY'),
            min = 10,
            max = 64,
            bigStep = 1,
            order = 103.2
        },
        sizeSpacer = {type = 'description', name = '', order = 103.3},
        preci = {
            type = 'range',
            name = 'Precision (time left)',
            desc = '...' .. getDefaultStr('preci'),
            min = 0,
            max = 3,
            bigStep = 1,
            order = 104.1
        },
        preciMax = {
            type = 'range',
            name = 'Precision (time max)',
            desc = '...' .. getDefaultStr('preciMax'),
            min = 0,
            max = 3,
            bigStep = 1,
            order = 104.2
        },
        preciSpacer = {type = 'description', name = '', order = 104.3},
        castTimeEnabled = {type = 'toggle', name = 'Show cast time text', order = 105.1},
        castTimeMaxEnabled = {type = 'toggle', name = 'Show cast time max text', order = 105.2},
        castTimeSpacer = {type = 'description', name = '', order = 105.3},
        compactLayout = {type = 'toggle', name = 'Compact Layout', order = 106.1},
        showIcon = {type = 'toggle', name = 'Show Icon', order = 106.2},
        showTicks = {type = 'toggle', name = 'Show Ticks', order = 107.1}

    }
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)
    db = self.db.profile

    self:SetEnabledState(DF:GetModuleEnabled(mName))
    DF:RegisterModuleOptions(mName, options)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    if DF.Wrath then
        Module.Wrath()
    else
        Module.Era()
    end
    Module:ApplySettings()
    DF.ConfigModule:RegisterOptionScreen('Misc', 'Castbar', {name = 'Castbar', options = options})
end

function Module:OnDisable()
end

function Module:ApplySettings()
    db = Module.db.profile
    Module.Castbar:SetScale(db.scale)
    Module.Castbar:SetPoint('CENTER', UIParent, 'BOTTOM', db.x, db.y)
    Module.Castbar:SetSize(db.sizeX, db.sizeY)
    Module.Castbar:SetPrecision(db.preci, db.preciMax)
    Module.Castbar:SetCastTimeTextShown(db.castTimeEnabled)
    Module.Castbar:SetCastTimeTextMaxShown(db.castTimeMaxEnabled)
    Module.Castbar:SetCompactLayout(db.compactLayout)
    Module.Castbar:SetShowTicks(db.showTicks)
    Module.Castbar:SetIconShown(db.showIcon)
    Module.Castbar.Icon:SetSize(db.sizeY, db.sizeY)
end

local frame = CreateFrame('FRAME', 'DragonflightUICastbarFrame', UIParent)
Module.frame = frame

function Module.ChangeDefaultCastbar()
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, -100)

    CastingBarFrame:GetStatusBarTexture():SetVertexColor(0, 0, 0, 0)
    CastingBarFrame:GetStatusBarTexture():SetAlpha(0)

    -- CastingBarFrame.Border:Hide()
    -- CastingBarFrame.BorderShield:Hide()
    -- CastingBarFrame.Text:Hide()
    -- CastingBarFrame.Icon:Hide()
    -- CastingBarFrame.Spark:Hide()
    -- CastingBarFrame.Flash:Hide()

    local children = {CastingBarFrame:GetRegions()}
    for i, child in pairs(children) do
        -- print('child', child:GetName())
        child:Hide()
    end
end

Module.ChannelTicks = DF.Wrath and {
    -- wl
    [GetSpellInfo(5740)] = 4, -- rain of fire
    [GetSpellInfo(5138)] = 5, -- drain mana
    [GetSpellInfo(689)] = 5, -- drain life
    [GetSpellInfo(1120)] = 5, -- drain soul
    [GetSpellInfo(755)] = 10, -- health funnel
    [GetSpellInfo(1949)] = 15, -- hellfire
    -- priest
    [GetSpellInfo(47540)] = 2, -- penance
    [GetSpellInfo(15407)] = 3, -- mind flay
    [GetSpellInfo(64843)] = 4, -- divine hymn
    [GetSpellInfo(64901)] = 4, -- hymn of hope
    [GetSpellInfo(48045)] = 5, -- mind sear
    -- hunter
    [GetSpellInfo(1510)] = 6, -- volley
    -- druid
    [GetSpellInfo(740)] = 4, -- tranquility
    [GetSpellInfo(16914)] = 10, -- hurricane
    -- mage
    [5143] = 3, -- arcane missiles rank 1
    [5144] = 4, -- arcane missiles rank 2
    [GetSpellInfo(5145)] = 5, -- arcane missiles
    [GetSpellInfo(10)] = 8 -- blizzard
} or DF.Era and {
    -- wl
    [GetSpellInfo(5740)] = 4, -- rain of fire
    [GetSpellInfo(5138)] = 5, -- drain mana
    [GetSpellInfo(689)] = 5, -- drain life
    [GetSpellInfo(1120)] = 5, -- drain soul
    [GetSpellInfo(755)] = 10, -- health funnel
    [GetSpellInfo(1949)] = 15, -- hellfire
    -- priest
    [GetSpellInfo(15407)] = 3, -- mind flay
    [GetSpellInfo(402174)] = 2, -- penance
    [GetSpellInfo(413259)] = 2, -- mind sear
    -- hunter
    [GetSpellInfo(1510)] = 6, -- volley
    -- druid
    [GetSpellInfo(740)] = 4, -- tranquility
    [GetSpellInfo(16914)] = 10, -- hurricane
    -- mage
    [5143] = 3, -- arcane missiles rank 1
    [5144] = 4, -- arcane missiles rank 2
    [GetSpellInfo(5145)] = 5, -- arcane missiles
    [GetSpellInfo(10)] = 8, -- blizzard,
    [GetSpellInfo(401417)] = 3, -- regeneration
    [GetSpellInfo(412510)] = 3 -- mass regeneration
}

function Module.AddNewCastbar()
    local castbar = CreateFrame('StatusBar', 'DragonflightUIPlayerCastbar', CastingBarFrame,
                                'DragonflightUIPlayerCastbarTemplate')
    castbar:AddTickTable(Module.ChannelTicks)

    Module.Castbar = castbar
end

function frame:OnEvent(event, arg1)
    -- print('event', event, arg1)
    Module.ChangeDefaultCastbar()
    if event == 'PLAYER_ENTERING_WORLD' then
    elseif (event == 'UNIT_SPELLCAST_START' and arg1 == 'player') then
        -- Module.SetBarNormal()
        -- Module.HideAllTicks()
        -- Module.SetCastbarNormal()
    elseif (event == 'UNIT_SPELLCAST_INTERRUPTED' and arg1 == 'player') then
        -- Module.SetBarInterrupted()
        -- Module.SetCastbarInterrupted()
    elseif (event == 'UNIT_SPELLCAST_CHANNEL_START' and arg1 == 'player') then
        -- Module.SetBarChannel()
    else
    end
end
frame:SetScript('OnEvent', frame.OnEvent)

-- Wrath
function Module.Wrath()
    frame:RegisterUnitEvent('UNIT_SPELLCAST_INTERRUPTED', 'player')
    frame:RegisterUnitEvent('UNIT_SPELLCAST_DELAYED', 'player')
    frame:RegisterUnitEvent('UNIT_SPELLCAST_CHANNEL_START', 'player')
    frame:RegisterUnitEvent('UNIT_SPELLCAST_CHANNEL_UPDATE', 'player')
    frame:RegisterUnitEvent('UNIT_SPELLCAST_CHANNEL_STOP', 'player')
    frame:RegisterUnitEvent('UNIT_SPELLCAST_START', 'player')
    frame:RegisterUnitEvent('UNIT_SPELLCAST_STOP', 'player')
    frame:RegisterUnitEvent('UNIT_SPELLCAST_FAILED', 'player')

    Module.ChangeDefaultCastbar()
    Module.AddNewCastbar()
end

-- Era
function Module.Era()
    Module.Wrath()
end
