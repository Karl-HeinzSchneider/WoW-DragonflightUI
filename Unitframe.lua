print('Unitframe.lua')

local frame = CreateFrame('FRAME', 'DragonflightUIUnitframeFrame', UIParent)

function GetCoords(key)
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

function ChangePlayerframe()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    PlayerFrameTexture:Hide()
    PlayerFrameBackground:Hide()
    --PlayerFrameTexture:SetTexture(base)
    --PlayerFrameTexture:SetTexCoord(GetCoords('UI-HUD-UnitFrame-Player-PortraitOn'))

    local texture = PlayerFrame:CreateTexture('DragonflightUIPlayerFrame')
    texture:SetDrawLayer('ARTWORK', 5)
    texture:SetTexture(base)
    texture:SetTexCoord(GetCoords('UI-HUD-UnitFrame-Player-PortraitOn'))
    texture:SetPoint('RIGHT', PlayerFrameHealthBar, 'RIGHT', 5, 0)
    texture:SetSize(198, 73)
    texture:SetScale(1)
    frame.PlayerFrameBorder = texture

    local textureSmall = PlayerFrame:CreateTexture('DragonflightUIPlayerFrameDeco')
    textureSmall:SetDrawLayer('ARTWORK', 5)
    textureSmall:SetTexture(base)
    textureSmall:SetTexCoord(GetCoords('UI-HUD-UnitFrame-Player-PortraitOn-CornerEmbellishment'))
    local delta = 15
    textureSmall:SetPoint('CENTER', PlayerPortrait, 'CENTER', delta, -delta)
    textureSmall:SetSize(23, 23)
    textureSmall:SetScale(1)
    frame.PlayerFrameDeco = textureSmall

    -- @TODO: change text spacing
    PlayerName:ClearAllPoints()
    PlayerName:SetPoint('BOTTOMLEFT', PlayerFrameHealthBar, 'TOPLEFT', 0, 3)

    PlayerLevelText:ClearAllPoints()
    PlayerLevelText:SetPoint('BOTTOMRIGHT', PlayerFrameHealthBar, 'TOPRIGHT', -5, 3)

    -- Health 119,12
    PlayerFrameHealthBar:SetSize(124, 20)
    PlayerFrameHealthBar:SetPoint('TOPLEFT', PlayerFrame, 'TOPLEFT', 106 - 2, -41 + 8)
    PlayerFrameHealthBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOff-Bar-Health'
    )

    PlayerFrameHealthBarText:SetPoint('CENTER', PlayerFrameHealthBar, 'CENTER', 0, 0)

    -- Mana 119,12
    PlayerFrameManaBar:SetPoint('TOPLEFT', PlayerFrame, 'TOPLEFT', 106 - 2, -52 - 3)
    PlayerFrameManaBar:SetSize(124, 10)
    PlayerFrameManaBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOff-Bar-Mana'
    )

    --UI-HUD-UnitFrame-Player-PortraitOn-Status
    PlayerStatusTexture:SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-InCombat'
    )
end
--ChangePlayerframe()
frame:RegisterEvent('PLAYER_ENTERING_WORLD')

function ChangeTargetFrame()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    TargetFrameTextureFrameTexture:Hide()
    TargetFrameBackground:Hide()

    local texture = TargetFrame:CreateTexture('DragonflightUITargetFrame')
    texture:SetDrawLayer('BACKGROUND', 2)
    texture:SetTexture(base)
    texture:SetTexCoord(GetCoords('UI-HUD-UnitFrame-Target-PortraitOn'))
    --texture:SetPoint('LEFT', PlayerFrame, 'RIGHT', 0, 6)
    texture:SetPoint('RIGHT', TargetFramePortrait, 'CENTER', 36, -1)
    texture:SetSize(192, 67)
    texture:SetScale(1)
    frame.TargetFrameBorder = texture

    TargetFramePortrait:SetDrawLayer('BACKGROUND', 1)
    TargetFramePortrait:SetSize(56, 56)

    TargetFrameNameBackground:ClearAllPoints()
    TargetFrameNameBackground:SetPoint('BOTTOMLEFT', TargetFrameHealthBar, 'TOPLEFT', 0, 2)
    TargetFrameNameBackground:SetSize(124, 10)
    TargetFrameNameBackground:SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health-Status'
    )
    --[[ TargetFrameNameBackground:SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Type'
    ) ]]
    --TargetFrameBuff1:SetPoint('TOPLEFT', TargetFrame, 'BOTTOMLEFT', 5, 0)

    -- @TODO: change text spacing
    TargetFrameTextureFrameName:ClearAllPoints()
    TargetFrameTextureFrameName:SetPoint('BOTTOM', TargetFrameHealthBar, 'TOP', 10, 3)

    TargetFrameTextureFrameLevelText:ClearAllPoints()
    TargetFrameTextureFrameLevelText:SetPoint('BOTTOMRIGHT', TargetFrameHealthBar, 'TOPLEFT', 16, 3)

    TargetFrameTextureFrame.HealthBarText:ClearAllPoints()
    TargetFrameTextureFrame.HealthBarText:SetPoint('CENTER', TargetFrameHealthBar, 'CENTER', 0, 0)

    TargetFrameTextureFrame.ManaBarText:ClearAllPoints()
    TargetFrameTextureFrame.ManaBarText:SetPoint('CENTER', TargetFrameManaBar, 'CENTER', 0, 0)

    -- Health 119,12
    TargetFrameHealthBar:ClearAllPoints()
    TargetFrameHealthBar:SetSize(124, 20)
    TargetFrameHealthBar:SetPoint('RIGHT', TargetFramePortrait, 'LEFT', -1, 0)
    TargetFrameHealthBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOff-Bar-Health'
    )

    --PlayerFrameHealthBarText:SetPoint('CENTER', PlayerFrameHealthBar, 'CENTER', 0, 0)

    -- Mana 119,12
    TargetFrameManaBar:ClearAllPoints()
    TargetFrameManaBar:SetPoint('RIGHT', TargetFramePortrait, 'LEFT', -1, -18 + 1)
    TargetFrameManaBar:SetSize(124, 8)
    TargetFrameManaBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana'
    )

    TargetFrameFlash:SetTexture('')

    local flash = TargetFrame:CreateTexture('DragonflightUITargetFrameFlash')
    flash:SetDrawLayer('BACKGROUND', 2)
    flash:SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-InCombat'
    )
    flash:SetPoint('CENTER', TargetFrame, 'CENTER', 20, -20)
    flash:SetSize(256, 128)
    flash:SetScale(1)
    flash:SetVertexColor(1.0, 0.0, 0.0, 1.0)
    flash:SetBlendMode('ADD')
    frame.TargetFrameFlash = flash

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
function ReApplyTargetFrame()
    TargetFrameManaBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana',
        'BACKGROUND'
    )
    TargetFrameFlash:SetTexture('')
end
frame:RegisterEvent('PLAYER_TARGET_CHANGED')

function ChangeFocusFrame()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiunitframe'

    FocusFrameTextureFrameTexture:Hide()
    FocusFrameBackground:Hide()

    local texture = FocusFrame:CreateTexture('DragonflightUIFocusFrame')
    texture:SetDrawLayer('BACKGROUND', 2)
    texture:SetTexture(base)
    texture:SetTexCoord(GetCoords('UI-HUD-UnitFrame-Target-PortraitOn'))
    --texture:SetPoint('LEFT', PlayerFrame, 'RIGHT', 0, 6)
    texture:SetPoint('RIGHT', FocusFramePortrait, 'CENTER', 36, -1)
    texture:SetSize(192, 67)
    texture:SetScale(1)
    frame.FocusFrameBorder = texture

    FocusFramePortrait:SetDrawLayer('BACKGROUND', 1)
    FocusFramePortrait:SetSize(56, 56)

    FocusFrameNameBackground:ClearAllPoints()
    FocusFrameNameBackground:SetPoint('BOTTOMLEFT', FocusFrameHealthBar, 'TOPLEFT', 0, 2)
    FocusFrameNameBackground:SetSize(124, 10)
    FocusFrameNameBackground:SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health-Status'
    )

    -- @TODO: change text spacing
    FocusFrameTextureFrameName:ClearAllPoints()
    FocusFrameTextureFrameName:SetPoint('BOTTOM', FocusFrameHealthBar, 'TOP', 10, 3)

    FocusFrameTextureFrameLevelText:ClearAllPoints()
    FocusFrameTextureFrameLevelText:SetPoint('BOTTOMRIGHT', FocusFrameHealthBar, 'TOPLEFT', 16, 3)

    -- HealthText
    local t = FocusFrame:CreateFontString('FocusFrameHealthBarText', 'HIGHLIGHT', 'TextStatusBarText')
    t:SetPoint('CENTER', FocusFrameHealthBar, 0, 0)
    t:SetText('HP')
    frame.FocusFrameHealthBarText = t

    -- ManaText
    local m = FocusFrame:CreateFontString('FocusFrameManaBarText', 'HIGHLIGHT', 'TextStatusBarText')
    m:SetPoint('CENTER', FocusFrameManaBar, 0, 0)
    m:SetText('MANA')
    frame.FocusFrameManaBarText = m

    -- Health 119,12
    FocusFrameHealthBar:ClearAllPoints()
    FocusFrameHealthBar:SetSize(124, 20)
    FocusFrameHealthBar:SetPoint('RIGHT', FocusFramePortrait, 'LEFT', -1, 0)
    FocusFrameHealthBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Player-PortraitOff-Bar-Health'
    )

    --PlayerFrameHealthBarText:SetPoint('CENTER', PlayerFrameHealthBar, 'CENTER', 0, 0)

    -- Mana 119,12
    FocusFrameManaBar:ClearAllPoints()
    FocusFrameManaBar:SetPoint('RIGHT', FocusFramePortrait, 'LEFT', -1, -18 + 1)
    FocusFrameManaBar:SetSize(124, 8)
    FocusFrameManaBar:GetStatusBarTexture():SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana'
    )
end
ChangeFocusFrame()
frame:RegisterUnitEvent('UNIT_POWER_UPDATE', 'focus')
frame:RegisterUnitEvent('UNIT_HEALTH', 'focus')
frame:RegisterEvent('PLAYER_FOCUS_CHANGED')

function UpdateFocusText()
    print('UpdateFocusText')
    if UnitExists('focus') then
        local max_health = UnitHealthMax('focus')
        local health = UnitHealth('focus')

        frame.FocusFrameHealthBarText:SetText(health .. ' / ' .. max_health)

        local max_mana = UnitPowerMax('focus')
        local mana = UnitPower('focus')

        frame.FocusFrameManaBarText:SetText(mana .. ' / ' .. max_mana)
    end
end

function HookFunctions()
    hooksecurefunc(
        PlayerFrameTexture,
        'Show',
        function()
            print('PlayerFrameTexture - Show()')
            ChangePlayerframe()
        end
    )
end
--HookFunctions()

function frame:OnEvent(event, arg1)
    if event == 'UNIT_POWER_UPDATE' then
        if arg1 == 'focus' then
            UpdateFocusText()
        end
    elseif event == 'UNIT_HEALTH' then
        if arg1 == 'focus' then
            UpdateFocusText()
        end
    elseif event == 'PLAYER_FOCUS_CHANGED' then
        UpdateFocusText()
        if FocusFrame then
            FocusFrameBuff1:SetPoint('TOPLEFT', FocusFrame, 'BOTTOMLEFT', 10, 35)
        end
    elseif event == 'PLAYER_ENTERING_WORLD' then
        --print('Blizzard_TimeManager')
        ChangePlayerframe()
        ChangeTargetFrame()
        print('PLAYER_ENTERING_WORLD')
    elseif event == 'PLAYER_TARGET_CHANGED' then
        ReApplyTargetFrame()
        if TargetFrame and TargetFrameBuff1 then
            TargetFrameBuff1:SetPoint('TOPLEFT', TargetFrame, 'BOTTOMLEFT', 10, 35)
        end
    end
end
frame:SetScript('OnEvent', frame.OnEvent)

print('Unitframe.lua - END')
