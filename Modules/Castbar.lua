local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Castbar'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        player = {
            scale = 1,
            anchorFrame = 'UIParent',
            anchor = 'CENTER',
            anchorParent = 'BOTTOM',
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
            sizeIcon = 24,
            showTicks = false,
            showRank = true,
            autoAdjust = false
        },
        target = {
            scale = 1,
            anchorFrame = 'TargetFrame',
            anchor = 'TOP',
            anchorParent = 'BOTTOM',
            x = -20,
            y = -20,
            sizeX = 150,
            sizeY = 10,
            preci = 1,
            preciMax = 2,
            castTimeEnabled = true,
            castTimeMaxEnabled = false,
            compactLayout = true,
            showIcon = true,
            sizeIcon = 20,
            showTicks = false,
            showRank = false,
            autoAdjust = true
        },
        focus = {
            scale = 1,
            anchorFrame = 'FocusFrame',
            anchor = 'TOP',
            anchorParent = 'BOTTOM',
            x = -20,
            y = -20,
            sizeX = 150,
            sizeY = 10,
            preci = 1,
            preciMax = 2,
            castTimeEnabled = true,
            castTimeMaxEnabled = false,
            compactLayout = true,
            showIcon = true,
            sizeIcon = 20,
            showTicks = false,
            showRank = false,
            autoAdjust = true
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

local frameTable = {['UIParent'] = 'UIParent', ['PlayerFrame'] = 'PlayerFrame', ['TargetFrame'] = 'TargetFrame'}
if DF.Wrath then frameTable['FocusFrame'] = 'FocusFrame' end

local optionsPlayer = {
    type = 'group',
    name = 'DragonflightUI - ' .. mName,
    get = getOption,
    set = setOption,
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'player'),
            min = 0.2,
            max = 5,
            bigStep = 0.1,
            order = 1,
            disabled = false
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'player'),
            values = frameTable,
            order = 4
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'player'),
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
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'player'),
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
            desc = 'X relative to BOTTOM CENTER' .. getDefaultStr('x', 'player'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to BOTTOM CENTER' .. getDefaultStr('y', 'player'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6
        },
        sizeX = {
            type = 'range',
            name = 'Width',
            desc = getDefaultStr('sizeX', 'player'),
            min = 80,
            max = 512,
            bigStep = 1,
            order = 10
        },
        sizeY = {
            type = 'range',
            name = 'Height',
            desc = getDefaultStr('sizeY', 'player'),
            min = 10,
            max = 64,
            bigStep = 1,
            order = 11
        },
        preci = {
            type = 'range',
            name = 'Precision (time left)',
            desc = '...' .. getDefaultStr('preci', 'player'),
            min = 0,
            max = 3,
            bigStep = 1,
            order = 12
        },
        preciMax = {
            type = 'range',
            name = 'Precision (time max)',
            desc = '...' .. getDefaultStr('preciMax', 'player'),
            min = 0,
            max = 3,
            bigStep = 1,
            order = 13
        },
        castTimeEnabled = {
            type = 'toggle',
            name = 'Show cast time text',
            desc = '' .. getDefaultStr('castTimeEnabled', 'player'),
            order = 14
        },
        castTimeMaxEnabled = {
            type = 'toggle',
            name = 'Show cast time max text',
            desc = '' .. getDefaultStr('castTimeMaxEnabled', 'player'),
            order = 15
        },
        compactLayout = {
            type = 'toggle',
            name = 'Compact Layout',
            desc = '' .. getDefaultStr('compactLayout', 'player'),
            order = 16
        },
        showIcon = {type = 'toggle', name = 'Show Icon', desc = '' .. getDefaultStr('showIcon', 'player'), order = 17},
        sizeIcon = {
            type = 'range',
            name = 'Icon Size',
            desc = getDefaultStr('sizeIcon', 'player'),
            min = 1,
            max = 64,
            bigStep = 1,
            order = 17.1,
            new = true
        },
        showTicks = {
            type = 'toggle',
            name = 'Show Ticks',
            desc = '' .. getDefaultStr('showTicks', 'player'),
            order = 18
        }
        -- autoAdjust = {
        --     type = 'toggle',
        --     name = 'Auto Adjust',
        --     desc = 'This applies an Y-offset depending on the amount of buffs/debuffs - useful when anchoring the castbar beneath the PlayerFrame' ..
        --         getDefaultStr('autoAdjust', 'player'),
        --     order = 22
        -- }
    }
}

if DF.Era then
    local moreOptions = {
        showRank = {
            type = 'toggle',
            name = 'Show Rank',
            desc = '' .. getDefaultStr('showRank', 'player'),
            order = 20,
            new = true
        }
    }

    for k, v in pairs(moreOptions) do optionsPlayer.args[k] = v end
end

local optionsTarget = {
    type = 'group',
    name = 'DragonflightUI - ' .. mName,
    get = getOption,
    set = setOption,
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'target'),
            min = 0.2,
            max = 5,
            bigStep = 0.1,
            order = 1,
            disabled = false
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'target'),
            values = frameTable,
            order = 4
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'target'),
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
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'target'),
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
            desc = 'X relative to BOTTOM CENTER' .. getDefaultStr('x', 'target'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to BOTTOM CENTER' .. getDefaultStr('y', 'target'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6
        },
        sizeX = {
            type = 'range',
            name = 'Width',
            desc = getDefaultStr('sizeX', 'target'),
            min = 80,
            max = 512,
            bigStep = 1,
            order = 10
        },
        sizeY = {
            type = 'range',
            name = 'Height',
            desc = getDefaultStr('sizeY', 'target'),
            min = 10,
            max = 64,
            bigStep = 1,
            order = 11
        },
        preci = {
            type = 'range',
            name = 'Precision (time left)',
            desc = '...' .. getDefaultStr('preci', 'target'),
            min = 0,
            max = 3,
            bigStep = 1,
            order = 12
        },
        preciMax = {
            type = 'range',
            name = 'Precision (time max)',
            desc = '...' .. getDefaultStr('preciMax', 'target'),
            min = 0,
            max = 3,
            bigStep = 1,
            order = 13
        },
        castTimeEnabled = {
            type = 'toggle',
            name = 'Show cast time text',
            desc = '' .. getDefaultStr('castTimeEnabled', 'target'),
            order = 14
        },
        castTimeMaxEnabled = {
            type = 'toggle',
            name = 'Show cast time max text',
            desc = '' .. getDefaultStr('castTimeMaxEnabled', 'target'),
            order = 15
        },
        compactLayout = {
            type = 'toggle',
            name = 'Compact Layout',
            desc = '' .. getDefaultStr('compactLayout', 'target'),
            order = 16
        },
        showIcon = {type = 'toggle', name = 'Show Icon', desc = '' .. getDefaultStr('showIcon', 'target'), order = 17},
        sizeIcon = {
            type = 'range',
            name = 'Icon Size',
            desc = getDefaultStr('sizeIcon', 'target'),
            min = 1,
            max = 64,
            bigStep = 1,
            order = 17.1,
            new = true
        },
        showTicks = {
            type = 'toggle',
            name = 'Show Ticks',
            desc = '' .. getDefaultStr('showTicks', 'target'),
            order = 18
        },
        autoAdjust = {
            type = 'toggle',
            name = 'Auto Adjust',
            desc = 'This applies an Y-offset depending on the amount of buffs/debuffs - useful when anchoring the castbar beneath the TargetFrame' ..
                getDefaultStr('autoAdjust', 'target'),
            order = 22
        }
    }
}

if DF.Era then
    local moreOptions = {
        showRank = {
            type = 'toggle',
            name = 'Show Rank',
            desc = '' .. getDefaultStr('showRank', 'target'),
            order = 20,
            new = true
        }
    }

    for k, v in pairs(moreOptions) do optionsTarget.args[k] = v end
end

local optionsFocus = {
    type = 'group',
    name = 'DragonflightUI - ' .. mName,
    get = getOption,
    set = setOption,
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', 'focus'),
            min = 0.2,
            max = 5,
            bigStep = 0.1,
            order = 1,
            disabled = false
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', 'focus'),
            values = frameTable,
            order = 4
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', 'focus'),
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
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', 'focus'),
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
            desc = 'X relative to BOTTOM CENTER' .. getDefaultStr('x', 'focus'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to BOTTOM CENTER' .. getDefaultStr('y', 'focus'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6
        },
        sizeX = {
            type = 'range',
            name = 'Width',
            desc = getDefaultStr('sizeX', 'focus'),
            min = 80,
            max = 512,
            bigStep = 1,
            order = 10
        },
        sizeY = {
            type = 'range',
            name = 'Height',
            desc = getDefaultStr('sizeY', 'focus'),
            min = 10,
            max = 64,
            bigStep = 1,
            order = 11
        },
        preci = {
            type = 'range',
            name = 'Precision (time left)',
            desc = '...' .. getDefaultStr('preci', 'focus'),
            min = 0,
            max = 3,
            bigStep = 1,
            order = 12
        },
        preciMax = {
            type = 'range',
            name = 'Precision (time max)',
            desc = '...' .. getDefaultStr('preciMax', 'focus'),
            min = 0,
            max = 3,
            bigStep = 1,
            order = 13
        },
        castTimeEnabled = {
            type = 'toggle',
            name = 'Show cast time text',
            desc = '' .. getDefaultStr('castTimeEnabled', 'focus'),
            order = 14
        },
        castTimeMaxEnabled = {
            type = 'toggle',
            name = 'Show cast time max text',
            desc = '' .. getDefaultStr('castTimeMaxEnabled', 'focus'),
            order = 15
        },
        compactLayout = {
            type = 'toggle',
            name = 'Compact Layout',
            desc = '' .. getDefaultStr('compactLayout', 'focus'),
            order = 16
        },
        showIcon = {type = 'toggle', name = 'Show Icon', desc = '' .. getDefaultStr('showIcon', 'focus'), order = 17},
        sizeIcon = {
            type = 'range',
            name = 'Icon Size',
            desc = getDefaultStr('sizeIcon', 'focus'),
            min = 1,
            max = 64,
            bigStep = 1,
            order = 17.1,
            new = true
        },
        showTicks = {type = 'toggle', name = 'Show Ticks', desc = '' .. getDefaultStr('showTicks', 'focus'), order = 18},
        autoAdjust = {
            type = 'toggle',
            name = 'Auto Adjust',
            desc = 'This applies an Y-offset depending on the amount of buffs/debuffs - useful when anchoring the castbar beneath the FocusFrame' ..
                getDefaultStr('autoAdjust', 'focus'),
            order = 22
        }
    }
}

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
        focus = optionsFocus,
        player = optionsPlayer,
        target = optionsTarget
    }
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)
    -- db = self.db.profile

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    DF:RegisterModuleOptions(mName, options)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    if DF.Wrath then
        Module.Wrath()
    else
        Module.Era()
    end
    Module:ApplySettings()

    DF.ConfigModule:RegisterOptionScreen('Castbar', 'Player', {
        name = 'Player',
        sub = 'player',
        options = optionsPlayer,
        default = function()
            setDefaultSubValues('player')
        end
    })

    DF.ConfigModule:RegisterOptionScreen('Castbar', 'Target', {
        name = 'Target',
        sub = 'target',
        options = optionsTarget,
        default = function()
            setDefaultSubValues('target')
        end
    })

    if DF.Wrath then
        DF.ConfigModule:RegisterOptionScreen('Castbar', 'Focus', {
            name = 'Focus',
            sub = 'focus',
            options = optionsFocus,
            default = function()
                setDefaultSubValues('focus')
            end
        })
    end

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)
        Module:ApplySettings()
        Module:RefreshOptionScreens()
    end)
end

function Module:OnDisable()
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame

    local refreshCat = function(name)
        configFrame:RefreshCatSub('Castbar', name)
    end

    refreshCat('Player')
    refreshCat('Target')
end

function Module:ApplySettings()
    local db = Module.db.profile

    Module.PlayerCastbar:UpdateState(db.player)
    Module.TargetCastbar:UpdateState(db.target)

    if DF.Wrath then Module.FocusCastbar:UpdateState(db.focus) end
end

local frame = CreateFrame('FRAME', 'DragonflightUICastbarFrame', UIParent)
Module.frame = frame

function Module.ChangeDefaultCastbar()
    CastingBarFrame:UnregisterAllEvents()
    CastingBarFrame:Hide()

    TargetFrameSpellBar:UnregisterAllEvents()
    TargetFrameSpellBar:Hide()

    if DF.Wrath then
        FocusFrameSpellBar:UnregisterAllEvents()
        FocusFrameSpellBar:Hide()
    end
end

Module.ChannelTicks = DF.Cata and {
    -- wl
    [GetSpellInfo(5740)] = 4, -- rain of fire
    -- [GetSpellInfo(5138)] = 5, -- drain mana
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
    -- [GetSpellInfo(1510)] = 6, -- volley
    -- druid
    [GetSpellInfo(740)] = 4, -- tranquility
    [GetSpellInfo(16914)] = 10, -- hurricane
    -- mage
    [5143] = 3, -- arcane missiles rank 1
    [5144] = 4, -- arcane missiles rank 2
    -- [GetSpellInfo(5145)] = 5, -- arcane missiles
    [GetSpellInfo(10)] = 8 -- blizzard
} or DF.Wrath and {
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
    local castbar = CreateFrame('StatusBar', 'DragonflightUIPlayerCastbar', UIParent,
                                'DragonflightUIPlayerCastbarTemplate')
    castbar:AddTickTable(Module.ChannelTicks)
    Module.PlayerCastbar = castbar

    local target = CreateFrame('StatusBar', 'DragonflightUITargetCastbar', UIParent,
                               'DragonflightUITargetCastbarTemplate')
    TargetFrameSpellBar.DFCastbar = target
    Module.TargetCastbar = target

    if DF.Wrath then
        local focus = CreateFrame('StatusBar', 'DragonflightUIFocusCastbar', UIParent,
                                  'DragonflightUIFocusCastbarTemplate')
        FocusFrameSpellBar.DFCastbar = focus
        Module.FocusCastbar = focus
    end

    hooksecurefunc('Target_Spellbar_AdjustPosition', function(self)
        -- print('Target_Spellbar_AdjustPosition', self:GetName())
        if self.DFCastbar then self.DFCastbar:AdjustPosition() end
    end)
end

function frame:OnEvent(event, arg1)
    -- print('event', event, arg1) 
end
frame:SetScript('OnEvent', frame.OnEvent)

-- Wrath
function Module.Wrath()
    Module.ChangeDefaultCastbar()
    Module.AddNewCastbar()
end

-- Era
function Module.Era()
    Module.Wrath()
end
