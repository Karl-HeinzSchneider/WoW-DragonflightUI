local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Unitframe'
local Module = DF:NewModule(mName, 'AceConsole-3.0')

local db, getOptions

Module.famous = {['Norbert'] = true}

local defaults = {
    profile = {
        scale = 1,
        dX = 42,
        dY = 35,
        sizeX = 460,
        sizeY = 207
    }
}

local options = {
    type = 'group',
    name = 'DragonflightUI - ' .. mName,
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
            order = 69
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
end

function Module:OnDisable()
end

function Module:ApplySettings()
    db = self.db.profile
end

local frame = CreateFrame('FRAME', 'DragonflightUIUnitframeFrame', UIParent)

function Module.GetCoords(key)
    local uiunitframe = {
        ['UI-HUD-UnitFrame-Player-Absorb-Edge'] = {8, 32, 0.984375, 0.9921875, 0.001953125, 0.064453125, false, false},
        ['UI-HUD-UnitFrame-Player-CombatIcon'] = {
            16,
            16,
            0.9775390625,
            0.9931640625,
            0.259765625,
            0.291015625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-CombatIcon-Glow'] = {
            32,
            32,
            0.1494140625,
            0.1806640625,
            0.8203125,
            0.8828125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-Group-FriendOnlineIcon'] = {
            16,
            16,
            0.162109375,
            0.177734375,
            0.716796875,
            0.748046875,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-Group-GuideIcon'] = {
            16,
            16,
            0.162109375,
            0.177734375,
            0.751953125,
            0.783203125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-Group-LeaderIcon'] = {
            16,
            16,
            0.1259765625,
            0.1416015625,
            0.919921875,
            0.951171875,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-GroupIndicator'] = {
            71,
            13,
            0.927734375,
            0.9970703125,
            0.3125,
            0.337890625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PlayTimeTired'] = {29, 29, 0.1904296875, 0.21875, 0.505859375, 0.5625, false, false},
        ['UI-HUD-UnitFrame-Player-PlayTimeUnhealthy'] = {
            29,
            29,
            0.1904296875,
            0.21875,
            0.56640625,
            0.623046875,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff'] = {
            133,
            51,
            0.0009765625,
            0.130859375,
            0.716796875,
            0.81640625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-Energy'] = {
            124,
            10,
            0.6708984375,
            0.7919921875,
            0.35546875,
            0.375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-Focus'] = {
            124,
            10,
            0.6708984375,
            0.7919921875,
            0.37890625,
            0.3984375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-Health'] = {
            126,
            23,
            0.0009765625,
            0.1240234375,
            0.919921875,
            0.96484375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-Health-Status'] = {
            124,
            20,
            0.5478515625,
            0.6689453125,
            0.3125,
            0.3515625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-Mana'] = {
            126,
            12,
            0.0009765625,
            0.1240234375,
            0.96875,
            0.9921875,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-Rage'] = {
            124,
            10,
            0.8203125,
            0.94140625,
            0.435546875,
            0.455078125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOff-Bar-RunicPower'] = {
            124,
            10,
            0.1904296875,
            0.3115234375,
            0.458984375,
            0.478515625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn'] = {198, 71, 0.7890625, 0.982421875, 0.001953125, 0.140625, false, false},
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Energy'] = {
            124,
            10,
            0.3134765625,
            0.4345703125,
            0.458984375,
            0.478515625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Focus'] = {
            124,
            10,
            0.4365234375,
            0.5576171875,
            0.458984375,
            0.478515625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health'] = {
            124,
            20,
            0.5478515625,
            0.6689453125,
            0.35546875,
            0.39453125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health-Status'] = {
            124,
            20,
            0.6708984375,
            0.7919921875,
            0.3125,
            0.3515625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana'] = {
            124,
            10,
            0.5595703125,
            0.6806640625,
            0.458984375,
            0.478515625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana-Status'] = {
            124,
            10,
            0.6826171875,
            0.8037109375,
            0.458984375,
            0.478515625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-Rage'] = {
            124,
            10,
            0.8056640625,
            0.9267578125,
            0.458984375,
            0.478515625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Bar-RunicPower'] = {
            124,
            10,
            0.1904296875,
            0.3115234375,
            0.482421875,
            0.501953125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-CornerEmbellishment'] = {
            23,
            23,
            0.953125,
            0.9755859375,
            0.259765625,
            0.3046875,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-InCombat'] = {
            192,
            71,
            0.1943359375,
            0.3818359375,
            0.169921875,
            0.30859375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Status'] = {
            196,
            71,
            0.0009765625,
            0.1923828125,
            0.169921875,
            0.30859375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Vehicle'] = {
            202,
            84,
            0.0009765625,
            0.1982421875,
            0.001953125,
            0.166015625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Vehicle-InCombat'] = {
            198,
            84,
            0.3984375,
            0.591796875,
            0.001953125,
            0.166015625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PortraitOn-Vehicle-Status'] = {
            201,
            84,
            0.2001953125,
            0.396484375,
            0.001953125,
            0.166015625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PVP-AllianceIcon'] = {
            28,
            41,
            0.1201171875,
            0.1474609375,
            0.8203125,
            0.900390625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PVP-FFAIcon'] = {
            28,
            44,
            0.1328125,
            0.16015625,
            0.716796875,
            0.802734375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Player-PVP-HordeIcon'] = {
            44,
            44,
            0.953125,
            0.99609375,
            0.169921875,
            0.255859375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-HighLevelTarget_Icon'] = {
            11,
            14,
            0.984375,
            0.9951171875,
            0.068359375,
            0.095703125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn'] = {
            192,
            67,
            0.57421875,
            0.76171875,
            0.169921875,
            0.30078125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Energy'] = {
            127,
            10,
            0.8544921875,
            0.978515625,
            0.412109375,
            0.431640625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Focus'] = {
            127,
            10,
            0.1904296875,
            0.314453125,
            0.435546875,
            0.455078125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Health'] = {
            125,
            12,
            0.7939453125,
            0.916015625,
            0.3515625,
            0.375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Health-Status'] = {
            125,
            12,
            0.7939453125,
            0.916015625,
            0.37890625,
            0.40234375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Mana'] = {
            127,
            10,
            0.31640625,
            0.4404296875,
            0.435546875,
            0.455078125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Mana-Status'] = {
            127,
            10,
            0.4423828125,
            0.56640625,
            0.435546875,
            0.455078125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Rage'] = {
            127,
            10,
            0.568359375,
            0.6923828125,
            0.435546875,
            0.455078125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-RunicPower'] = {
            127,
            10,
            0.6943359375,
            0.818359375,
            0.435546875,
            0.455078125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-InCombat'] = {
            188,
            67,
            0.0009765625,
            0.1845703125,
            0.447265625,
            0.578125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Status'] = {
            193,
            69,
            0.3837890625,
            0.572265625,
            0.169921875,
            0.3046875,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn'] = {
            192,
            67,
            0.763671875,
            0.951171875,
            0.169921875,
            0.30078125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy'] = {
            134,
            10,
            0.7890625,
            0.919921875,
            0.14453125,
            0.1640625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus'] = {
            134,
            10,
            0.1904296875,
            0.3212890625,
            0.412109375,
            0.431640625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health'] = {
            126,
            20,
            0.4228515625,
            0.5458984375,
            0.3125,
            0.3515625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health-Status'] = {
            126,
            20,
            0.4228515625,
            0.5458984375,
            0.35546875,
            0.39453125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana'] = {
            134,
            10,
            0.3232421875,
            0.4541015625,
            0.412109375,
            0.431640625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana-Status'] = {
            134,
            10,
            0.4560546875,
            0.5869140625,
            0.412109375,
            0.431640625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage'] = {
            134,
            10,
            0.5888671875,
            0.7197265625,
            0.412109375,
            0.431640625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower'] = {
            134,
            10,
            0.7216796875,
            0.8525390625,
            0.412109375,
            0.431640625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-InCombat'] = {
            188,
            67,
            0.0009765625,
            0.1845703125,
            0.58203125,
            0.712890625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Type'] = {
            135,
            18,
            0.7939453125,
            0.92578125,
            0.3125,
            0.34765625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-PortraitOn-Vehicle'] = {
            198,
            81,
            0.59375,
            0.787109375,
            0.001953125,
            0.16015625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-Target-Rare-PortraitOn'] = {
            192,
            67,
            0.0009765625,
            0.1884765625,
            0.3125,
            0.443359375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn'] = {
            120,
            49,
            0.0009765625,
            0.1181640625,
            0.8203125,
            0.916015625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Energy'] = {
            74,
            7,
            0.91796875,
            0.990234375,
            0.37890625,
            0.392578125,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Focus'] = {
            74,
            7,
            0.3134765625,
            0.3857421875,
            0.482421875,
            0.49609375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health'] = {
            70,
            10,
            0.921875,
            0.990234375,
            0.14453125,
            0.1640625,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health-Status'] = {
            70,
            10,
            0.91796875,
            0.986328125,
            0.3515625,
            0.37109375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana'] = {
            74,
            7,
            0.3876953125,
            0.4599609375,
            0.482421875,
            0.49609375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana-Status'] = {
            74,
            7,
            0.4619140625,
            0.5341796875,
            0.482421875,
            0.49609375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Rage'] = {
            74,
            7,
            0.5361328125,
            0.6083984375,
            0.482421875,
            0.49609375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-RunicPower'] = {
            74,
            7,
            0.6103515625,
            0.6826171875,
            0.482421875,
            0.49609375,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-InCombat'] = {
            114,
            47,
            0.3095703125,
            0.4208984375,
            0.3125,
            0.404296875,
            false,
            false
        },
        ['UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Status'] = {
            120,
            49,
            0.1904296875,
            0.3076171875,
            0.3125,
            0.408203125,
            false,
            false
        }
    }

    local data = uiunitframe[key]
    return data[3], data[4], data[5], data[6]
end

function Module.CreatePlayerFrameTextures()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    if not frame.PlayerFrameBackground then
        local background = PlayerFrame:CreateTexture('DragonflightUIPlayerFrameBackground')
        background:SetDrawLayer('BACKGROUND', 2)
        background:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Player-PortraitOn-BACKGROUND'
        )
        background:SetPoint('LEFT', PlayerFrameHealthBar, 'LEFT', -67, -28.5)

        background:SetTexture(base)
        background:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-PortraitOn'))
        background:SetSize(198, 71)
        background:SetPoint('LEFT', PlayerFrameHealthBar, 'LEFT', -67, 0)
        frame.PlayerFrameBackground = background
    end

    if not frame.PlayerFrameBorder then
        local border = PlayerFrameHealthBar:CreateTexture('DragonflightUIPlayerFrameBorder')
        border:SetDrawLayer('ARTWORK', 2)
        border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Player-PortraitOn-BORDER')
        border:SetPoint('LEFT', PlayerFrameHealthBar, 'LEFT', -67, -28.5)
        frame.PlayerFrameBorder = border
    end

    if not frame.PlayerFrameDeco then
        local textureSmall = PlayerFrame:CreateTexture('DragonflightUIPlayerFrameDeco')
        textureSmall:SetDrawLayer('ARTWORK', 5)
        textureSmall:SetTexture(base)
        textureSmall:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Player-PortraitOn-CornerEmbellishment'))
        local delta = 15
        textureSmall:SetPoint('CENTER', PlayerPortrait, 'CENTER', delta, -delta - 2)
        textureSmall:SetSize(23, 23)
        textureSmall:SetScale(1)
        frame.PlayerFrameDeco = textureSmall
    end
end

function Module.ChangePlayerframe()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    PlayerFrameTexture:Hide()
    PlayerFrameBackground:Hide()
    PlayerFrameVehicleTexture:Hide()

    PlayerPortrait:ClearAllPoints()
    PlayerPortrait:SetPoint('TOPLEFT', PlayerFrame, 'TOPLEFT', 42, -15)
    PlayerPortrait:SetDrawLayer('ARTWORK', 5)
    PlayerPortrait:SetSize(56, 56)

    -- @TODO: change text spacing
    PlayerName:ClearAllPoints()
    PlayerName:SetPoint('BOTTOMLEFT', PlayerFrameHealthBar, 'TOPLEFT', 0, 1)

    PlayerLevelText:ClearAllPoints()
    PlayerLevelText:SetPoint('BOTTOMRIGHT', PlayerFrameHealthBar, 'TOPRIGHT', -5, 1)

    -- Health 119,12
    PlayerFrameHealthBar:SetSize(125, 20)
    PlayerFrameHealthBar:ClearAllPoints()
    PlayerFrameHealthBar:SetPoint('LEFT', PlayerPortrait, 'RIGHT', 1, 0)
    PlayerFrameHealthBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health'
    )
    PlayerFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)

    PlayerFrameHealthBarText:SetPoint('CENTER', PlayerFrameHealthBar, 'CENTER', 0, 0)

    -- Mana 119,12
    PlayerFrameManaBar:ClearAllPoints()
    PlayerFrameManaBar:SetPoint('LEFT', PlayerPortrait, 'RIGHT', 1, -17)
    PlayerFrameManaBar:SetSize(125, 8)

    local powerType, powerTypeString = UnitPowerType('player')

    if powerTypeString == 'MANA' then
        PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana'
        )
    elseif powerTypeString == 'RAGE' then
        PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Rage'
        )
    elseif powerTypeString == 'ENERGY' then
        PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Energy'
        )
    elseif powerTypeString == 'RUNIC_POWER' then
        PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-RunicPower'
        )
    end

    PlayerFrameManaBar:SetStatusBarColor(1, 1, 1, 1)

    --UI-HUD-UnitFrame-Player-PortraitOn-Status
    PlayerStatusTexture:SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-InCombat'
    )
end
--ChangePlayerframe()
--frame:RegisterEvent('PLAYER_ENTERING_WORLD')

function Module.ChangeTargetFrame()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    TargetFrameTextureFrameTexture:Hide()
    TargetFrameBackground:Hide()

    if not frame.TargetFrameBackground then
        local background = TargetFrame:CreateTexture('DragonflightUITargetFrameBackground')
        background:SetDrawLayer('BACKGROUND', 2)
        background:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BACKGROUND'
        )
        background:SetPoint('LEFT', TargetFrame, 'LEFT', 0, -32.5 + 10)
        frame.TargetFrameBackground = background
    end

    if not frame.TargetFrameBorder then
        local border = TargetFrame:CreateTexture('DragonflightUITargetFrameBorder')
        border:SetDrawLayer('ARTWORK', 2)
        border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BORDER')
        border:SetPoint('LEFT', TargetFrame, 'LEFT', 0, -32.5 + 10)
        frame.TargetFrameBorder = border
    end

    TargetFramePortrait:SetDrawLayer('ARTWORK', 1)
    TargetFramePortrait:SetSize(56, 56)
    local CorrectionY = -3
    local CorrectionX = -5
    TargetFramePortrait:SetPoint('TOPRIGHT', TargetFrame, 'TOPRIGHT', -42 + CorrectionX, -12 + CorrectionY)

    --TargetFrameBuff1:SetPoint('TOPLEFT', TargetFrame, 'BOTTOMLEFT', 5, 0)

    -- @TODO: change text spacing
    TargetFrameTextureFrameName:ClearAllPoints()
    TargetFrameTextureFrameName:SetPoint('BOTTOM', TargetFrameHealthBar, 'TOP', 10, 3 - 2)

    TargetFrameTextureFrameLevelText:ClearAllPoints()
    TargetFrameTextureFrameLevelText:SetPoint('BOTTOMRIGHT', TargetFrameHealthBar, 'TOPLEFT', 16, 3 - 2)

    if DF.Wrath then
        TargetFrameTextureFrame.HealthBarText:ClearAllPoints()
        TargetFrameTextureFrame.HealthBarText:SetPoint('CENTER', TargetFrameHealthBar, 'CENTER', 0, 0)

        TargetFrameTextureFrame.ManaBarText:ClearAllPoints()
        TargetFrameTextureFrame.ManaBarText:SetPoint('CENTER', TargetFrameManaBar, 'CENTER', 0, 0)
    end
    -- Health 119,12
    TargetFrameHealthBar:ClearAllPoints()
    TargetFrameHealthBar:SetSize(125, 20)
    TargetFrameHealthBar:SetPoint('RIGHT', TargetFramePortrait, 'LEFT', -1, 0)
    TargetFrameHealthBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health'
    )
    TargetFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)

    --PlayerFrameHealthBarText:SetPoint('CENTER', PlayerFrameHealthBar, 'CENTER', 0, 0)

    -- Mana 119,12
    TargetFrameManaBar:ClearAllPoints()
    TargetFrameManaBar:SetPoint('RIGHT', TargetFramePortrait, 'LEFT', -1 + 8 - 0.5, -18 + 1 + 0.5)
    TargetFrameManaBar:SetSize(132, 9)
    TargetFrameManaBar:SetStatusBarColor(1, 1, 1, 1)

    TargetFrameNameBackground:SetTexture(base)
    TargetFrameNameBackground:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Target-PortraitOn-Type'))
    TargetFrameNameBackground:SetSize(135, 18)
    TargetFrameNameBackground:ClearAllPoints()
    TargetFrameNameBackground:SetPoint('BOTTOMLEFT', TargetFrameHealthBar, 'TOPLEFT', -2, -4 - 1)

    if DF.Wrath then
        TargetFrameFlash:SetTexture('')

        if not frame.TargetFrameFlash then
            local flash = TargetFrame:CreateTexture('DragonflightUITargetFrameFlash')
            flash:SetDrawLayer('BACKGROUND', 2)
            flash:SetTexture(
                'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-InCombat'
            )
            flash:SetPoint('CENTER', TargetFrame, 'CENTER', 20 + CorrectionX, -20 + CorrectionY)
            flash:SetSize(256, 128)
            flash:SetScale(1)
            flash:SetVertexColor(1.0, 0.0, 0.0, 1.0)
            flash:SetBlendMode('ADD')
            frame.TargetFrameFlash = flash
        end

        hooksecurefunc(
            TargetFrameFlash,
            'Show',
            function()
                --print('show')
                TargetFrameFlash:SetTexture('')
                frame.TargetFrameFlash:Show()
                if (UIFrameIsFlashing(frame.TargetFrameFlash)) then
                else
                    --print('go flash')
                    local dt = 0.5
                    UIFrameFlash(frame.TargetFrameFlash, dt, dt, -1)
                end
            end
        )

        hooksecurefunc(
            TargetFrameFlash,
            'Hide',
            function()
                --print('hide')
                TargetFrameFlash:SetTexture('')
                if (UIFrameIsFlashing(frame.TargetFrameFlash)) then
                    UIFrameFlashStop(frame.TargetFrameFlash)
                end
                frame.TargetFrameFlash:Hide()
            end
        )
    end

    if not frame.PortraitExtra then
        local extra = TargetFrame:CreateTexture('DragonflightUITargetFramePortraitExtra')
        extra:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiunitframeboss2x')
        extra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
        extra:SetSize(80, 79)
        extra:SetDrawLayer('ARTWORK', 3)
        extra:SetPoint('CENTER', TargetFramePortrait, 'CENTER', 4, 1)

        extra.UpdateStyle = function()
            local class = UnitClassification('target')
            --[[ "worldboss", "rareelite", "elite", "rare", "normal", "trivial" or "minus" ]]
            if class == 'worldboss' then
                frame.PortraitExtra:Show()
                frame.PortraitExtra:SetSize(99, 81)
                frame.PortraitExtra:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.31835937)
                frame.PortraitExtra:SetPoint('CENTER', TargetFramePortrait, 'CENTER', 13, 1)
            elseif class == 'rareelite' or class == 'rare' then
                frame.PortraitExtra:Show()
                frame.PortraitExtra:SetSize(80, 79)
                frame.PortraitExtra:SetTexCoord(0.00390625, 0.31640625, 0.64453125, 0.953125)
                frame.PortraitExtra:SetPoint('CENTER', TargetFramePortrait, 'CENTER', 4, 1)
            elseif class == 'elite' then
                frame.PortraitExtra:Show()
                frame.PortraitExtra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
                frame.PortraitExtra:SetSize(80, 79)
                frame.PortraitExtra:SetPoint('CENTER', TargetFramePortrait, 'CENTER', 4, 1)
            else
                local name, realm = UnitName('target')
                if Module.famous[name] then
                    frame.PortraitExtra:Show()
                    frame.PortraitExtra:SetSize(99, 81)
                    frame.PortraitExtra:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.31835937)
                    frame.PortraitExtra:SetPoint('CENTER', TargetFramePortrait, 'CENTER', 13, 1)
                else
                    frame.PortraitExtra:Hide()
                end
            end
        end

        frame.PortraitExtra = extra
    end
end
function Module.ReApplyTargetFrame()
    TargetFrameHealthBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health'
    )
    TargetFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)

    local powerType, powerTypeString = UnitPowerType('target')

    if powerTypeString == 'MANA' then
        TargetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana'
        )
    elseif powerTypeString == 'RAGE' then
        TargetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage'
        )
    elseif powerTypeString == 'ENERGY' then
        TargetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy'
        )
    elseif powerTypeString == 'RUNIC_POWER' then
        TargetFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower'
        )
    end

    TargetFrameManaBar:SetStatusBarColor(1, 1, 1, 1)
    if DF.Wrath then
        TargetFrameFlash:SetTexture('')
    end

    frame.PortraitExtra:UpdateStyle()
end
--frame:RegisterEvent('PLAYER_TARGET_CHANGED')

function Module.ChangeToT()
    --TargetFrameToTTextureFrame:Hide()
    TargetFrameToT:ClearAllPoints()
    TargetFrameToT:SetPoint('BOTTOMRIGHT', TargetFrame, 'BOTTOMRIGHT', -35, -10 - 5)

    TargetFrameToTTextureFrameTexture:SetTexture('')
    --TargetFrameToTTextureFrameTexture:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-TargetofTarget-PortraitOn'))

    if not frame.TargetFrameToTBackground then
        local background = TargetFrameToTTextureFrame:CreateTexture('DragonflightUITargetFrameToTBackground')
        background:SetDrawLayer('BACKGROUND', 1)
        background:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BACKGROUND'
        )
        background:SetPoint('LEFT', TargetFrameToTPortrait, 'CENTER', -25 + 1, -10)
        frame.TargetFrameToTBackground = background
    end

    if not frame.TargetFrameToTBorder then
        local border = TargetFrameToTHealthBar:CreateTexture('DragonflightUITargetFrameToTBorder')
        border:SetDrawLayer('ARTWORK', 2)
        border:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BORDER'
        )
        border:SetPoint('LEFT', TargetFrameToTPortrait, 'CENTER', -25 + 1, -10)
        frame.TargetFrameToTBorder = border
    end

    TargetFrameToTHealthBar:ClearAllPoints()
    TargetFrameToTHealthBar:SetPoint('LEFT', TargetFrameToTPortrait, 'RIGHT', 1 + 1, 0)
    TargetFrameToTHealthBar:SetFrameLevel(10)
    TargetFrameToTHealthBar:SetSize(70.5, 10)

    TargetFrameToTManaBar:ClearAllPoints()
    TargetFrameToTManaBar:SetPoint('LEFT', TargetFrameToTPortrait, 'RIGHT', 1 - 2 - 1.5 + 1, 2 - 10 - 1)
    TargetFrameToTManaBar:SetFrameLevel(10)
    TargetFrameToTManaBar:SetSize(74, 7.5)
    TargetFrameToTManaBar:Hide()

    if not frame.ToTManaBar then
        local f = CreateFrame('StatusBar', 'DragonflightUIToTManaBar', TargetFrameToT)
        f:SetSize(74, 7.5)
        f:SetPoint('LEFT', TargetFrameToTPortrait, 'RIGHT', 1 - 2 - 1.5 + 1, 2 - 10 - 1)
        f:SetFrameLevel(10)
        f:SetStatusBarTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana'
        )
        f:SetStatusBarColor(1, 1, 1, 1)

        frame.ToTManaBar = f

        local UpdateManaBarValues = function(other)
            local value = other:GetValue()
            local statusMin, statusMax = other:GetMinMaxValues()

            frame.ToTManaBar:SetValue(value)
            frame.ToTManaBar:SetMinMaxValues(statusMin, statusMax)
        end

        local UpdateManaBarTextures = function()
            local powerType, powerTypeString = UnitPowerType('playertargettarget')

            if powerTypeString == 'MANA' then
                frame.ToTManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana'
                )
            elseif powerTypeString == 'RAGE' then
                frame.ToTManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Rage'
                )
            elseif powerTypeString == 'ENERGY' then
                frame.ToTManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Energy'
                )
            elseif powerTypeString == 'RUNIC_POWER' then
                frame.ToTManaBar:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-RunicPower'
                )
            end

            frame.ToTManaBar:SetStatusBarColor(1, 1, 1, 1)
        end

        --[[   hooksecurefunc(
            'TargetofTarget_Update',
            function()
                --print('TargetofTarget_Update')
            end
        ) ]]
        TargetFrame:HookScript(
            'OnShow',
            function(self)
                UpdateManaBarTextures()
            end
        )

        TargetFrameToTManaBar:HookScript(
            'OnValueChanged',
            function(self)
                TargetFrameToTManaBar:Hide()
                UpdateManaBarValues(self)
            end
        )
        TargetFrameToTManaBar:HookScript(
            'OnMinMaxChanged',
            function(self)
                TargetFrameToTManaBar:Hide()
                UpdateManaBarValues(self)
                UpdateManaBarTextures()
            end
        )
    end

    TargetFrameToTTextureFrameName:ClearAllPoints()
    TargetFrameToTTextureFrameName:SetPoint('LEFT', TargetFrameToTPortrait, 'RIGHT', 1 + 1, 2 + 12 - 1)
end

function Module.ReApplyToT()
    if UnitExists('playertargettarget') then
        --frame.ToTManaBar:Show()

        TargetFrameToTHealthBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health'
        )

        TargetFrameToTHealthBar:SetStatusBarColor(1, 1, 1, 1)

        if UnitIsUnit('player', 'playertarget') then
        --frame.ToTManaBar:Hide()
        end
    else
        --print('ToT doesnt exist')
        --frame.ToTManaBar:Hide()
    end
end

function Module.ChangeFocusFrame()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    FocusFrameTextureFrameTexture:Hide()
    FocusFrameBackground:Hide()

    if not frame.FocusFrameBackground then
        local background = FocusFrame:CreateTexture('DragonflightUITargetFrameBackground')
        background:SetDrawLayer('BACKGROUND', 2)
        background:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BACKGROUND'
        )
        background:SetPoint('LEFT', FocusFrame, 'LEFT', 0, -32.5 + 10)
        frame.FocusFrameBackground = background
    end

    if not frame.FocusFrameBorder then
        local border = FocusFrame:CreateTexture('DragonflightUITargetFrameBorder')
        border:SetDrawLayer('ARTWORK', 2)
        border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Target-PortraitOn-BORDER')
        border:SetPoint('LEFT', FocusFrame, 'LEFT', 0, -32.5 + 10)
        frame.FocusFrameBorder = border
    end

    FocusFramePortrait:SetDrawLayer('ARTWORK', 1)
    FocusFramePortrait:SetSize(56, 56)
    local CorrectionY = -3
    local CorrectionX = -5
    FocusFramePortrait:SetPoint('TOPRIGHT', FocusFrame, 'TOPRIGHT', -42 + CorrectionX, -12 + CorrectionY)

    FocusFrameNameBackground:ClearAllPoints()
    FocusFrameNameBackground:SetTexture(base)
    FocusFrameNameBackground:SetTexCoord(Module.GetCoords('UI-HUD-UnitFrame-Target-PortraitOn-Type'))
    FocusFrameNameBackground:SetSize(135, 18)
    FocusFrameNameBackground:ClearAllPoints()
    FocusFrameNameBackground:SetPoint('BOTTOMLEFT', FocusFrameHealthBar, 'TOPLEFT', -2, -4 - 1)

    -- @TODO: change text spacing
    FocusFrameTextureFrameName:ClearAllPoints()
    FocusFrameTextureFrameName:SetPoint('BOTTOM', FocusFrameHealthBar, 'TOP', 10, 3 - 2)

    FocusFrameTextureFrameLevelText:ClearAllPoints()
    FocusFrameTextureFrameLevelText:SetPoint('BOTTOMRIGHT', FocusFrameHealthBar, 'TOPLEFT', 16, 3 - 2)

    -- HealthText
    if not frame.FocusFrameHealthBarText then
        local t = FocusFrame:CreateFontString('FocusFrameHealthBarText', 'HIGHLIGHT', 'TextStatusBarText')
        t:SetPoint('CENTER', FocusFrameHealthBar, 0, 0)
        t:SetText('HP')
        frame.FocusFrameHealthBarText = t
    end

    if FocusFrameTextureFrame.HealthBarText then
        FocusFrameTextureFrame.HealthBarText:ClearAllPoints()
        FocusFrameTextureFrame.HealthBarText:SetPoint('CENTER', FocusFrameHealthBar, 0, 0)
    end

    -- ManaText
    if not frame.FocusFrameManaBarText then
        local m = FocusFrame:CreateFontString('FocusFrameManaBarText', 'HIGHLIGHT', 'TextStatusBarText')
        m:SetPoint('CENTER', FocusFrameManaBar, -3.5, 0)
        m:SetText('MANA')
        frame.FocusFrameManaBarText = m
    end

    if FocusFrameTextureFrame.ManaBarText then
        FocusFrameTextureFrame.ManaBarText:ClearAllPoints()
        FocusFrameTextureFrame.ManaBarText:SetPoint('CENTER', FocusFrameManaBar, -3.5, 0)
    end

    -- Health 119,12
    FocusFrameHealthBar:ClearAllPoints()
    FocusFrameHealthBar:SetSize(125, 20)
    FocusFrameHealthBar:SetPoint('RIGHT', FocusFramePortrait, 'LEFT', -1, 0)
    FocusFrameHealthBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOff-Bar-Health'
    )
    FocusFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)

    --PlayerFrameHealthBarText:SetPoint('CENTER', PlayerFrameHealthBar, 'CENTER', 0, 0)

    -- Mana 119,12
    FocusFrameManaBar:ClearAllPoints()
    FocusFrameManaBar:SetPoint('RIGHT', FocusFramePortrait, 'LEFT', -1 + 8 - 0.5, -18 + 1 + 0.5)
    FocusFrameManaBar:SetSize(132, 9)
    FocusFrameManaBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana'
    )
    FocusFrameManaBar:SetStatusBarColor(1, 1, 1, 1)

    FocusFrameFlash:SetTexture('')

    if not frame.FocusFrameFlash then
        local flash = FocusFrame:CreateTexture('DragonflightUIFocusFrameFlash')
        flash:SetDrawLayer('BACKGROUND', 2)
        flash:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-InCombat'
        )
        flash:SetPoint('CENTER', FocusFrame, 'CENTER', 20 + CorrectionX, -20 + CorrectionY)
        flash:SetSize(256, 128)
        flash:SetScale(1)
        flash:SetVertexColor(1.0, 0.0, 0.0, 1.0)
        flash:SetBlendMode('ADD')
        frame.FocusFrameFlash = flash
    end

    hooksecurefunc(
        FocusFrameFlash,
        'Show',
        function()
            --print('show')
            FocusFrameFlash:SetTexture('')
            frame.FocusFrameFlash:Show()
            if (UIFrameIsFlashing(frame.FocusFrameFlash)) then
            else
                --print('go flash')
                local dt = 0.5
                UIFrameFlash(frame.FocusFrameFlash, dt, dt, -1)
            end
        end
    )

    hooksecurefunc(
        FocusFrameFlash,
        'Hide',
        function()
            --print('hide')
            FocusFrameFlash:SetTexture('')
            if (UIFrameIsFlashing(frame.FocusFrameFlash)) then
                UIFrameFlashStop(frame.FocusFrameFlash)
            end
            frame.FocusFrameFlash:Hide()
        end
    )

    if not frame.FocusExtra then
        local extra = FocusFrame:CreateTexture('DragonflightUIFocusFramePortraitExtra')
        extra:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiunitframeboss2x')
        extra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
        extra:SetSize(80, 79)
        extra:SetDrawLayer('ARTWORK', 3)
        extra:SetPoint('CENTER', FocusFramePortrait, 'CENTER', 4, 1)

        extra.UpdateStyle = function()
            local class = UnitClassification('focus')
            --[[ "worldboss", "rareelite", "elite", "rare", "normal", "trivial" or "minus" ]]
            if class == 'worldboss' then
                frame.FocusExtra:Show()
                frame.FocusExtra:SetSize(99, 81)
                frame.FocusExtra:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.31835937)
                frame.FocusExtra:SetPoint('CENTER', FocusFramePortrait, 'CENTER', 13, 1)
            elseif class == 'rareelite' or class == 'rare' then
                frame.FocusExtra:Show()
                frame.FocusExtra:SetSize(80, 79)
                frame.FocusExtra:SetTexCoord(0.00390625, 0.31640625, 0.64453125, 0.953125)
                frame.FocusExtra:SetPoint('CENTER', FocusFramePortrait, 'CENTER', 4, 1)
            elseif class == 'elite' then
                frame.FocusExtra:Show()
                frame.FocusExtra:SetTexCoord(0.001953125, 0.314453125, 0.322265625, 0.630859375)
                frame.FocusExtra:SetSize(80, 79)
                frame.FocusExtra:SetPoint('CENTER', FocusFramePortrait, 'CENTER', 4, 1)
            else
                local name, realm = UnitName('target')
                if Module.famous[name] then
                    frame.FocusExtra:Show()
                    frame.FocusExtra:SetSize(99, 81)
                    frame.FocusExtra:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.31835937)
                    frame.FocusExtra:SetPoint('CENTER', FocusFramePortrait, 'CENTER', 13, 1)
                else
                    frame.FocusExtra:Hide()
                end
            end
        end

        frame.FocusExtra = extra
    end
end
--ChangeFocusFrame()
-- frame:RegisterUnitEvent('UNIT_POWER_UPDATE', 'focus')
-- frame:RegisterUnitEvent('UNIT_HEALTH', 'focus')
-- frame:RegisterEvent('PLAYER_FOCUS_CHANGED')

function Module.ReApplyFocusFrame()
    FocusFrameHealthBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health'
    )
    FocusFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)

    local powerType, powerTypeString = UnitPowerType('focus')

    if powerTypeString == 'MANA' then
        FocusFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana'
        )
    elseif powerTypeString == 'RAGE' then
        FocusFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage'
        )
    elseif powerTypeString == 'ENERGY' then
        FocusFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy'
        )
    elseif powerTypeString == 'RUNIC_POWER' then
        FocusFrameManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower'
        )
    end

    FocusFrameManaBar:SetStatusBarColor(1, 1, 1, 1)

    FocusFrameFlash:SetTexture('')

    frame.FocusExtra:UpdateStyle()
end

function Module.ChangeFocusToT()
    FocusFrameToT:ClearAllPoints()
    FocusFrameToT:SetPoint('BOTTOMRIGHT', FocusFrame, 'BOTTOMRIGHT', -35, -10 - 5)

    FocusFrameToTTextureFrameTexture:SetTexture('')

    if not frame.FocusFrameToTBackground then
        local background = FocusFrameToTTextureFrame:CreateTexture('DragonflightUIFocusFrameToTBackground')
        background:SetDrawLayer('BACKGROUND', 1)
        background:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BACKGROUND'
        )
        background:SetPoint('LEFT', FocusFrameToTPortrait, 'CENTER', -25 + 1, -10 + 1)
        frame.FocusFrameToTBackground = background
    end

    if not frame.FocusFrameToTBorder then
        local border = FocusFrameToTHealthBar:CreateTexture('DragonflightUIFocusFrameToTBorder')
        border:SetDrawLayer('ARTWORK', 2)
        border:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BORDER'
        )
        border:SetPoint('LEFT', FocusFrameToTPortrait, 'CENTER', -25 + 1, -10 + 1)
        frame.FocusFrameToTBorder = border
    end

    FocusFrameToTHealthBar:ClearAllPoints()
    FocusFrameToTHealthBar:SetPoint('LEFT', FocusFrameToTPortrait, 'RIGHT', 1 + 1, 0 + 1)
    FocusFrameToTHealthBar:SetFrameLevel(10)
    FocusFrameToTHealthBar:SetSize(70.5, 10)

    FocusFrameToTManaBar:ClearAllPoints()
    FocusFrameToTManaBar:SetPoint('LEFT', FocusFrameToTPortrait, 'RIGHT', 1 - 2 - 1.5 + 1, 2 - 10 - 1)
    FocusFrameToTManaBar:SetFrameLevel(10)
    FocusFrameToTManaBar:SetSize(74, 7.5)

    FocusFrameToTTextureFrameName:ClearAllPoints()
    FocusFrameToTTextureFrameName:SetPoint('LEFT', FocusFrameToTPortrait, 'RIGHT', 1 + 1, 2 + 12 - 1)
end

function Module.UpdateFocusText()
    --print('UpdateFocusText')
    if UnitExists('focus') then
        local max_health = UnitHealthMax('focus')
        local health = UnitHealth('focus')

        frame.FocusFrameHealthBarText:SetText(health .. ' / ' .. max_health)

        local max_mana = UnitPowerMax('focus')
        local mana = UnitPower('focus')

        if max_mana == 0 then
            frame.FocusFrameManaBarText:SetText('')
        else
            frame.FocusFrameManaBarText:SetText(mana .. ' / ' .. max_mana)
        end
    end
end

function Module.HookFunctions()
    hooksecurefunc(
        PlayerFrameTexture,
        'Show',
        function()
            --print('PlayerFrameTexture - Show()')
            Module.ChangePlayerframe()
        end
    )
end

function Module.ChangePetFrame()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    PetFrame:SetPoint('TOPLEFT', PlayerFrame, 'TOPLEFT', 100, -70)
    PetFrameTexture:SetTexture('')
    PetFrameTexture:Hide()

    if not frame.PetFrameBackground then
        local background = PetFrame:CreateTexture('DragonflightUIPetFrameBackground')
        background:SetDrawLayer('BACKGROUND', 1)
        background:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BACKGROUND'
        )
        background:SetPoint('LEFT', PetPortrait, 'CENTER', -25 + 1, -10)
        frame.PetFrameBackground = background
    end

    if not frame.PetFrameBorder then
        local border = PetFrameHealthBar:CreateTexture('DragonflightUIPetFrameBorder')
        border:SetDrawLayer('ARTWORK', 2)
        border:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-BORDER'
        )
        border:SetPoint('LEFT', PetPortrait, 'CENTER', -25 + 1, -10)
        frame.PetFrameBorder = border
    end

    PetFrameHealthBar:ClearAllPoints()
    PetFrameHealthBar:SetPoint('LEFT', PetPortrait, 'RIGHT', 1 + 1 - 2 + 0.5, 0)
    -- PetFrameHealthBar:SetFrameLevel(10)
    PetFrameHealthBar:SetSize(70.5, 10)
    PetFrameHealthBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health'
    )
    PetFrameHealthBar:SetStatusBarColor(1, 1, 1, 1)
    PetFrameHealthBar.SetStatusBarColor = noop

    PetFrameManaBar:ClearAllPoints()
    PetFrameManaBar:SetPoint('LEFT', PetPortrait, 'RIGHT', 1 - 2 - 1.5 + 1 - 2 + 0.5, 2 - 10 - 1)
    --PetFrameManaBar:SetFrameLevel(10)
    PetFrameManaBar:SetSize(74, 7.5)
    PetFrameManaBar:Hide()

    if not frame.PetManaBar then
        local f = CreateFrame('StatusBar', 'DragonflightUIPetManaBar', PetFrame)
        f:SetSize(74, 7.5)
        f:SetPoint('LEFT', PetPortrait, 'RIGHT', 1 - 2 - 1.5 + 1 - 2 + 0.5, 2 - 10 - 1)
        f:SetStatusBarTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana'
        )
        f:SetStatusBarColor(1, 1, 1, 1)
        f:EnableMouse(true)

        local m = f:CreateFontString('PetManaBarText', 'HIGHLIGHT', 'TextStatusBarText')
        m:SetPoint('CENTER', f, 0, 0)
        --m:SetFrameLevel(11)
        m:SetText('MANA')
        frame.PetManaBarText = m

        frame.PetManaBar = f

        frame.PetManaBar.UpdatePetManaBarValues = function()
            local value = other:GetValue()
            local statusMin, statusMax = other:GetMinMaxValues()

            frame.PetManaBar:SetValue(value)
            frame.PetManaBar:SetMinMaxValues(statusMin, statusMax)
        end

        PetFrameManaBar:HookScript(
            'OnShow',
            function(self)
                self:Hide()
            end
        )
    end

    PetName:ClearAllPoints()
    PetName:SetPoint('LEFT', PetPortrait, 'RIGHT', 1 + 1, 2 + 12 - 1)

    PetFrameHealthBarText:SetPoint('CENTER', PetFrameHealthBar, 'CENTER', 0, 0)
    PetFrameManaBarText:SetPoint('CENTER', PetFrameManaBar, 'CENTER', 0, 0)
end

function Module.UpdatePetMana()
    PetFrameManaBar:Hide()

    local powerType, powerTypeString = UnitPowerType('pet')
    local power = UnitPower('pet', powerType)
    local maxpower = UnitPowerMax('pet', powerType)

    frame.PetManaBar:SetValue(power)
    frame.PetManaBar:SetMinMaxValues(0, maxpower)

    if powerTypeString == 'MANA' then
        frame.PetManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana'
        )
    elseif powerTypeString == 'RAGE' then
        frame.PetManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Rage'
        )
    elseif powerTypeString == 'ENERGY' then
        frame.PetManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Energy'
        )
    elseif powerTypeString == 'RUNIC_POWER' then
        frame.PetManaBar:GetStatusBarTexture():SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-RunicPower'
        )
    end

    if maxpower == 0 then
        frame.PetManaBarText:SetText('')
    else
        frame.PetManaBarText:SetText(power .. ' / ' .. maxpower)
    end
end

function frame:OnEvent(event, arg1)
    --print(event, arg1)
    if event == 'UNIT_POWER_UPDATE' and arg1 == 'focus' then
        Module.UpdateFocusText()
    elseif event == 'UNIT_POWER_UPDATE' and arg1 == 'pet' then
        Module.UpdatePetMana()
    elseif event == 'UNIT_POWER_UPDATE' then
        --print(event, arg1)
    elseif event == 'UNIT_HEALTH' and arg1 == 'focus' then
        Module.UpdateFocusText()
    elseif event == 'PLAYER_FOCUS_CHANGED' then
        Module.ReApplyFocusFrame()
        Module.UpdateFocusText()
    elseif event == 'PLAYER_ENTERING_WORLD' then
        --print('PLAYER_ENTERING_WORLD')
        Module.CreatePlayerFrameTextures()
        Module.ChangePlayerframe()
        Module.ChangeTargetFrame()
        Module.ChangeToT()
        Module.ReApplyTargetFrame()
        Module.ReApplyToT()
        if DF.Wrath then
            Module.ChangeFocusFrame()
            Module.ChangeFocusToT()
        end
        Module.ChangePetFrame()
        Module.UpdatePetMana()
    elseif event == 'PLAYER_TARGET_CHANGED' then
        Module.ReApplyTargetFrame()
        Module.ReApplyToT()
        Module.ChangePlayerframe()
    elseif event == 'UNIT_ENTERED_VEHICLE' then
        Module.ChangePlayerframe()
    elseif event == 'UNIT_EXITED_VEHICLE' then
        Module.ChangePlayerframe()
    elseif event == 'ZONE_CHANGED' or event == 'ZONE_CHANGED_INDOORS' or event == 'ZONE_CHANGED_NEW_AREA' then
        Module.ChangePlayerframe()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module.Wrath()
    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
    frame:RegisterEvent('PLAYER_TARGET_CHANGED')
    frame:RegisterEvent('PLAYER_FOCUS_CHANGED')

    frame:RegisterUnitEvent('UNIT_ENTERED_VEHICLE', 'player')
    frame:RegisterUnitEvent('UNIT_EXITED_VEHICLE', 'player')

    frame:RegisterEvent('UNIT_POWER_UPDATE')
    --frame:RegisterUnitEvent('UNIT_POWER_UPDATE', 'pet') -- overriden by other RegisterUnitEvent

    frame:RegisterUnitEvent('UNIT_POWER_UPDATE', 'focus', 'pet')
    frame:RegisterUnitEvent('UNIT_HEALTH', 'focus')

    frame:RegisterEvent('ZONE_CHANGED')
    frame:RegisterEvent('ZONE_CHANGED_INDOORS')
    frame:RegisterEvent('ZONE_CHANGED_NEW_AREA')
end

function Module.Era()
    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
    frame:RegisterEvent('PLAYER_TARGET_CHANGED')
    frame:RegisterEvent('PLAYER_FOCUS_CHANGED')

    frame:RegisterUnitEvent('UNIT_ENTERED_VEHICLE', 'player')
    frame:RegisterUnitEvent('UNIT_EXITED_VEHICLE', 'player')

    frame:RegisterEvent('UNIT_POWER_UPDATE')
    --frame:RegisterUnitEvent('UNIT_POWER_UPDATE', 'pet') -- overriden by other RegisterUnitEvent

    frame:RegisterEvent('ZONE_CHANGED')
    frame:RegisterEvent('ZONE_CHANGED_INDOORS')
    frame:RegisterEvent('ZONE_CHANGED_NEW_AREA')
end
