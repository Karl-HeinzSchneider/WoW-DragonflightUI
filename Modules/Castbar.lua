local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Castbar'
local Module = DF:NewModule(mName, 'AceConsole-3.0')

local db, getOptions

local defaults = {
    profile = {
        scale = 1,
        x = 0,
        y = 245,
        sizeX = 460,
        sizeY = 207,
        preci = 1,
        preciMax = 2
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
local function getOption(info) return db[info[#info]] end

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
            get = function() return DF:GetModuleEnabled(mName) end,
            set = function(info, v) DF:SetModuleEnabled(mName, v) end,
            order = 1
        },
        reload = {
            type = 'execute',
            name = '/reload',
            desc = 'reloads UI',
            func = function() ReloadUI() end,
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
            max = 1.5,
            bigStep = 0.025,
            order = 101,
            disabled = true
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
        preci = {
            type = 'range',
            name = 'Precision (time left)',
            desc = '...' .. getDefaultStr('preci'),
            min = 0,
            max = 3,
            bigStep = 1,
            order = 103
        },
        preciMax = {
            type = 'range',
            name = 'Precision (time max)',
            desc = '...' .. getDefaultStr('preciMax'),
            min = 0,
            max = 3,
            bigStep = 1,
            order = 103
        }
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
end

function Module:OnDisable() end

function Module:ApplySettings()
    db = Module.db.profile
    Module.frame.Castbar:SetPoint('CENTER', UIParent, 'BOTTOM', db.x, db.y)
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

function Module.CreateNewCastbar()
    local standardRef =
        'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarStandard2'
    local borderRef =
        'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarFrame2'
    local backgroundRef =
        'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarBackground2'
    local sparkRef =
        'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarSpark'

    local sizeX = 250
    local sizeY = 20
    local f = CreateFrame('Frame', 'DragonflightUICastBar', CastingBarFrame)
    f:SetSize(sizeX, sizeY)
    f:SetPoint('CENTER', UIParent, 'BOTTOM', 0, 230)

    local tex = f:CreateTexture('Background', 'ARTWORK')
    tex:SetAllPoints()
    tex:SetTexture(backgroundRef)
    f.Background = tex

    -- actual status bar, child of parent above
    f.Bar = CreateFrame('StatusBar', nil, f)
    f.Bar:SetStatusBarTexture(standardRef)
    f.Bar:SetPoint('TOPLEFT', 0, 0)
    f.Bar:SetPoint('BOTTOMRIGHT', 0, 0)

    f.Bar:SetMinMaxValues(0, 100)
    f.Bar:SetValue(50)

    frame.Castbar = f

    local UpdateCastBarValues = function(other)
        local value = other:GetValue()
        local statusMin, statusMax = other:GetMinMaxValues()

        frame.Castbar.Bar:SetValue(value)
        frame.Castbar.Bar:SetMinMaxValues(statusMin, statusMax)
    end

    local border = f.Bar:CreateTexture('Border', 'OVERLAY')
    border:SetTexture(borderRef)
    local dx, dy = 2, 4
    border:SetSize(sizeX + dx, sizeY + dy)
    border:SetPoint('CENTER', f.Bar, 'CENTER', 0, 0)
    f.Border = border

    local spark = f.Bar:CreateTexture('Spark', 'OVERLAY')
    spark:SetTexture(sparkRef)
    spark:SetSize(20, 32)
    spark:SetPoint('CENTER', f.Bar, 'CENTER', 0, 0)
    spark:SetBlendMode('ADD')
    f.Spark = spark

    local UpdateSpark = function(other)
        local value = other:GetValue()
        local statusMin, statusMax = other:GetMinMaxValues()
        if statusMax == 0 then return end

        local percent = value / statusMax
        if percent == 1 then
            f.Spark:Hide()
        else
            -- f.Spark:SetPoint('CENTER', f.Bar, 'LEFT', sizeX / 2, 0 + 15)
            f.Spark:Show()
            local dx = 2
            f.Spark:SetPoint('CENTER', f.Bar, 'LEFT',
                             (value * sizeX) / statusMax, 0)
        end
    end

    local bg = CreateFrame('Frame', 'DragonflightUICastbarNameBackgroundFrame',
                           CastingBarFrame)
    bg:SetSize(sizeX, sizeY)
    bg:SetPoint('TOP', f, 'BOTTOM', 0, 0)

    local bgTex = bg:CreateTexture('DragonflightUICastbarNameBackground',
                                   'ARTWORK')
    bgTex:ClearAllPoints()
    bgTex:SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\MinimapBorder')
    bgTex:SetSize(sizeX, 30)
    bgTex:SetPoint('TOP', f, 'BOTTOM', 2, 2)

    bg.tex = bgTex
    f.Background = bg

    local text = bg:CreateFontString('DragonflightUICastbarText', 'OVERLAY',
                                     'GameFontHighlight')
    text:SetText('12')
    text:SetPoint('TOP', f, 'BOTTOM', 0, -1)
    text:SetText('SHADOW BOLT DEBUG')
    f.Text = text

    local textValueMax = bg:CreateFontString('DragonflightUICastbarText',
                                             'OVERLAY', 'GameFontHighlight')
    textValueMax:SetPoint('TOP', f, 'BOTTOM', 0, -1)
    textValueMax:SetPoint('RIGHT', f.Background, 'RIGHT', -10, 0)
    textValueMax:SetText('/ 4.2')
    f.TextValueMax = textValueMax

    local textValue = bg:CreateFontString('DragonflightUICastbarText',
                                          'OVERLAY', 'GameFontHighlight')
    textValue:SetPoint('RIGHT', f.TextValueMax, 'LEFT', 0, 0)
    textValue:SetText('0.69')
    f.TextValue = textValue

    local UpdateExtratext = function(other)
        local value = other:GetValue()
        local statusMin, statusMax = other:GetMinMaxValues()

        local preci = Module.db.profile.preci
        local preciMax = Module.db.profile.preciMax

        if value == statusMax then
            frame.Castbar.TextValue:SetText('')
            frame.Castbar.TextValueMax:SetText('')
        elseif frame.Castbar.bChanneling then
            f.TextValue:SetText(string.format('%.' .. preci .. 'f', value))
            f.TextValueMax:SetText(' / ' ..
                                       string.format('%.' .. preciMax .. 'f',
                                                     statusMax))
        else
            f.TextValue:SetText(string.format('%.' .. preci .. 'f',
                                              statusMax - value))
            f.TextValueMax:SetText(' / ' ..
                                       string.format('%.' .. preciMax .. 'f',
                                                     statusMax))
        end
    end

    local ticks = {}
    for i = 1, 15 do
        local tick = f.Bar:CreateTexture('Tick' .. i, 'OVERLAY')
        tick:SetTexture('Interface\\ChatFrame\\ChatFrameBackground')
        tick:SetVertexColor(0, 0, 0)
        tick:SetAlpha(0.75)
        tick:SetSize(2.5, sizeY - 2)
        tick:SetPoint('CENTER', f.Bar, 'LEFT', sizeX / 2, 0)
        ticks[i] = tick
    end
    f.Ticks = ticks

    CastingBarFrame:HookScript('OnUpdate', function(self)
        UpdateCastBarValues(self)
        UpdateSpark(self)
        UpdateExtratext(self)
    end)
end

function Module.SetBarNormal()
    local standardRef =
        'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarStandard2'
    frame.Castbar.Bar:SetStatusBarTexture(standardRef)

    frame.Castbar.bChanneling = false
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID,
          notInterruptible, spellId = UnitCastingInfo('player')

    frame.Castbar.Text:SetText(text:sub(1, 23))
    frame.Castbar.Text:ClearAllPoints()
    frame.Castbar.Text:SetPoint('TOP', frame.Castbar, 'BOTTOM', 0, -1)
    frame.Castbar.Text:SetPoint('LEFT', frame.Castbar.Background, 'LEFT', 10, 0)
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
    [GetSpellInfo(5145)] = 5, -- arcane missiles
    [GetSpellInfo(10)] = 8 -- blizzard
} or DF.Era and {}

function Module.HideAllTicks()
    if frame.Castbar.Ticks then
        for i = 1, 15 do frame.Castbar.Ticks[i]:Hide() end
    end
end

function Module.SetBarChannel()
    local channelRef =
        'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarChannel'
    frame.Castbar.Bar:SetStatusBarTexture(channelRef)

    frame.Castbar.bChanneling = true
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill,
          notInterruptible, spellId = UnitChannelInfo('player')
    frame.Castbar.Text:SetText(name:sub(1, 23))
    frame.Castbar.Text:ClearAllPoints()
    frame.Castbar.Text:SetPoint('TOP', frame.Castbar, 'BOTTOM', 0, -1)
    frame.Castbar.Text:SetPoint('LEFT', frame.Castbar.Background, 'LEFT', 10, 0)

    local tickCount = Module.ChannelTicks[name]
    if tickCount then
        local tickDelta = frame.Castbar:GetWidth() / tickCount
        for i = 1, tickCount - 1 do
            frame.Castbar.Ticks[i]:Show()
            frame.Castbar.Ticks[i]:SetPoint('CENTER', frame.Castbar, 'LEFT',
                                            i * tickDelta, 0)
        end

        for i = tickCount, 15 do frame.Castbar.Ticks[i]:Hide() end
    else
        Module.HideAllTicks()
    end
end

function Module.SetBarInterrupted()
    local interruptedRef =
        'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarInterrupted2'
    frame.Castbar.Bar:SetStatusBarTexture(interruptedRef)

    frame.Castbar.Text:SetText('Interrupted')
    frame.Castbar.Text:ClearAllPoints()
    frame.Castbar.Text:SetPoint('TOP', frame.Castbar, 'BOTTOM', 0, -1)
end

function frame:OnEvent(event, arg1)
    -- print('event', event, arg1)
    Module.ChangeDefaultCastbar()
    if event == 'PLAYER_ENTERING_WORLD' then
    elseif (event == 'UNIT_SPELLCAST_START' and arg1 == 'player') then
        Module.SetBarNormal()
        Module.HideAllTicks()
    elseif (event == 'UNIT_SPELLCAST_INTERRUPTED' and arg1 == 'player') then
        Module.SetBarInterrupted()
    elseif (event == 'UNIT_SPELLCAST_CHANNEL_START' and arg1 == 'player') then
        Module.SetBarChannel()
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
    Module.CreateNewCastbar()
end

-- Era
function Module.Era() Module.Wrath() end
