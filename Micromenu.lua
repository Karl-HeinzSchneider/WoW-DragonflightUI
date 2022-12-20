print('Micromenu.lua')

local frame = CreateFrame('FRAME', 'DragonflightUIMicromenuFrame', UIParent)

function SetButtonFromAtlas(frame, atlas, textureRef, pre, name)
    local key = pre .. name

    local up = atlas[key .. '-Up']
    frame:SetSize(up[1], up[2])
    frame:SetScale(0.7)
    frame:SetHitRectInsets(0, 0, 0, 0)

    frame:SetNormalTexture(textureRef)
    frame:GetNormalTexture():SetTexCoord(up[3], up[4], up[5], up[6])

    local disabled = atlas[key .. '-Disabled']
    frame:SetDisabledTexture(textureRef)
    frame:GetDisabledTexture():SetTexCoord(disabled[3], disabled[4], disabled[5], disabled[6])

    local down = atlas[key .. '-Down']
    frame:SetPushedTexture(textureRef)
    frame:GetPushedTexture():SetTexCoord(down[3], down[4], down[5], down[6])

    local mouseover = atlas[key .. '-Mouseover']
    frame:SetHighlightTexture(textureRef)
    frame:GetHighlightTexture():SetTexCoord(mouseover[3], mouseover[4], mouseover[5], mouseover[6])

    return frame
end

function ChangeMicroMenu()
    -- from https://www.townlong-yak.com/framexml/live/Helix/AtlasInfo.lua
    local Atlas = {
        ['UI-HUD-MicroMenu-Achievements-Disabled'] = {
            38,
            52,
            0.78515625,
            0.93359375,
            0.212890625,
            0.314453125,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Achievements-Down'] = {
            38,
            52,
            0.62890625,
            0.77734375,
            0.107421875,
            0.208984375,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Achievements-Mouseover'] = {
            38,
            52,
            0.78515625,
            0.93359375,
            0.107421875,
            0.208984375,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Achievements-Up'] = {38, 52, 0.62890625, 0.77734375, 0.212890625, 0.314453125, false, false},
        ['UI-HUD-MicroMenu-AdventureGuide-Disabled'] = {
            38,
            52,
            0.31640625,
            0.46484375,
            0.318359375,
            0.419921875,
            false,
            false
        },
        ['UI-HUD-MicroMenu-AdventureGuide-Down'] = {
            38,
            52,
            0.78515625,
            0.93359375,
            0.318359375,
            0.419921875,
            false,
            false
        },
        ['UI-HUD-MicroMenu-AdventureGuide-Mouseover'] = {
            38,
            52,
            0.62890625,
            0.77734375,
            0.318359375,
            0.419921875,
            false,
            false
        },
        ['UI-HUD-MicroMenu-AdventureGuide-Up'] = {
            38,
            52,
            0.00390625,
            0.15234375,
            0.529296875,
            0.630859375,
            false,
            false
        },
        ['UI-HUD-MicroMenu-CharacterInfo-Disabled'] = {
            38,
            52,
            0.00390625,
            0.15234375,
            0.423828125,
            0.525390625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-CharacterInfo-Down'] = {
            38,
            52,
            0.47265625,
            0.62109375,
            0.318359375,
            0.419921875,
            false,
            false
        },
        ['UI-HUD-MicroMenu-CharacterInfo-Mouseover'] = {
            38,
            52,
            0.31640625,
            0.46484375,
            0.423828125,
            0.525390625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-CharacterInfo-Up'] = {38, 52, 0.00390625, 0.15234375, 0.634765625, 0.736328125, false, false},
        ['UI-HUD-MicroMenu-Collections-Disabled'] = {
            38,
            52,
            0.47265625,
            0.62109375,
            0.001953125,
            0.103515625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Collections-Down'] = {38, 52, 0.00390625, 0.15234375, 0.740234375, 0.841796875, false, false},
        ['UI-HUD-MicroMenu-Collections-Mouseover'] = {
            38,
            52,
            0.00390625,
            0.15234375,
            0.845703125,
            0.947265625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Collections-Up'] = {38, 52, 0.16015625, 0.30859375, 0.318359375, 0.419921875, false, false},
        ['UI-HUD-MicroMenu-Communities-Icon-Notification'] = {
            20,
            22,
            0.00390625,
            0.08203125,
            0.951171875,
            0.994140625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-GameMenu-Disabled'] = {
            38,
            52,
            0.16015625,
            0.30859375,
            0.423828125,
            0.525390625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-GameMenu-Down'] = {38, 52, 0.47265625, 0.62109375, 0.423828125, 0.525390625, false, false},
        ['UI-HUD-MicroMenu-GameMenu-Mouseover'] = {
            38,
            52,
            0.62890625,
            0.77734375,
            0.423828125,
            0.525390625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-GameMenu-Up'] = {38, 52, 0.78515625, 0.93359375, 0.423828125, 0.525390625, false, false},
        ['UI-HUD-MicroMenu-Groupfinder-Disabled'] = {
            38,
            52,
            0.16015625,
            0.30859375,
            0.529296875,
            0.630859375,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Groupfinder-Down'] = {38, 52, 0.31640625, 0.46484375, 0.212890625, 0.314453125, false, false},
        ['UI-HUD-MicroMenu-Groupfinder-Mouseover'] = {
            38,
            52,
            0.16015625,
            0.30859375,
            0.212890625,
            0.314453125,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Groupfinder-Up'] = {38, 52, 0.00390625, 0.15234375, 0.318359375, 0.419921875, false, false},
        ['UI-HUD-MicroMenu-GuildCommunities-Disabled'] = {
            38,
            52,
            0.78515625,
            0.93359375,
            0.001953125,
            0.103515625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-GuildCommunities-Down'] = {
            38,
            52,
            0.00390625,
            0.15234375,
            0.001953125,
            0.103515625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-GuildCommunities-Mouseover'] = {
            38,
            52,
            0.16015625,
            0.30859375,
            0.001953125,
            0.103515625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-GuildCommunities-Up'] = {
            38,
            52,
            0.16015625,
            0.30859375,
            0.107421875,
            0.208984375,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Highlightalert'] = {66, 80, 0.47265625, 0.73046875, 0.740234375, 0.896484375, false, false},
        ['UI-HUD-MicroMenu-Questlog-Disabled'] = {
            38,
            52,
            0.16015625,
            0.30859375,
            0.740234375,
            0.841796875,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Questlog-Down'] = {38, 52, 0.47265625, 0.62109375, 0.529296875, 0.630859375, false, false},
        ['UI-HUD-MicroMenu-Questlog-Mouseover'] = {
            38,
            52,
            0.16015625,
            0.30859375,
            0.845703125,
            0.947265625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Questlog-Up'] = {38, 52, 0.78515625, 0.93359375, 0.529296875, 0.630859375, false, false},
        ['UI-HUD-MicroMenu-Shop-Disabled'] = {38, 52, 0.16015625, 0.30859375, 0.634765625, 0.736328125, false, false},
        ['UI-HUD-MicroMenu-Shop-Down'] = {38, 52, 0.62890625, 0.77734375, 0.529296875, 0.630859375, false, false},
        ['UI-HUD-MicroMenu-Shop-Mouseover'] = {38, 52, 0.47265625, 0.62109375, 0.634765625, 0.736328125, false, false},
        ['UI-HUD-MicroMenu-Shop-Up'] = {38, 52, 0.00390625, 0.15234375, 0.212890625, 0.314453125, false, false},
        ['UI-HUD-MicroMenu-SpecTalents-Disabled'] = {
            38,
            52,
            0.31640625,
            0.46484375,
            0.107421875,
            0.208984375,
            false,
            false
        },
        ['UI-HUD-MicroMenu-SpecTalents-Down'] = {38, 52, 0.31640625, 0.46484375, 0.529296875, 0.630859375, false, false},
        ['UI-HUD-MicroMenu-SpecTalents-Mouseover'] = {
            38,
            52,
            0.31640625,
            0.46484375,
            0.001953125,
            0.103515625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-SpecTalents-Up'] = {38, 52, 0.62890625, 0.77734375, 0.001953125, 0.103515625, false, false},
        ['UI-HUD-MicroMenu-SpellbookAbilities-Disabled'] = {
            38,
            52,
            0.00390625,
            0.15234375,
            0.107421875,
            0.208984375,
            false,
            false
        },
        ['UI-HUD-MicroMenu-SpellbookAbilities-Down'] = {
            38,
            52,
            0.31640625,
            0.46484375,
            0.845703125,
            0.947265625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-SpellbookAbilities-Mouseover'] = {
            38,
            52,
            0.73828125,
            0.88671875,
            0.845703125,
            0.947265625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-SpellbookAbilities-Up'] = {
            38,
            52,
            0.47265625,
            0.62109375,
            0.107421875,
            0.208984375,
            false,
            false
        },
        ['UI-HUD-MicroMenu-StreamDLGreen-Down'] = {
            38,
            52,
            0.31640625,
            0.46484375,
            0.634765625,
            0.736328125,
            false,
            false
        },
        ['UI-HUD-MicroMenu-StreamDLGreen-Up'] = {38, 52, 0.47265625, 0.62109375, 0.212890625, 0.314453125, false, false},
        ['UI-HUD-MicroMenu-StreamDLRed-Down'] = {38, 52, 0.31640625, 0.46484375, 0.740234375, 0.841796875, false, false},
        ['UI-HUD-MicroMenu-StreamDLRed-Up'] = {38, 52, 0.62890625, 0.77734375, 0.634765625, 0.736328125, false, false},
        ['UI-HUD-MicroMenu-StreamDLYellow-Down'] = {
            38,
            52,
            0.73828125,
            0.88671875,
            0.740234375,
            0.841796875,
            false,
            false
        },
        ['UI-HUD-MicroMenu-StreamDLYellow-Up'] = {
            38,
            52,
            0.78515625,
            0.93359375,
            0.634765625,
            0.736328125,
            false,
            false
        }
    }
    local microTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\uimicromenu2x'
    SetButtonFromAtlas(CharacterMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'CharacterInfo')
    MicroButtonPortrait:Hide()
    SetButtonFromAtlas(SpellbookMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'SpellbookAbilities')
    SetButtonFromAtlas(TalentMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'SpecTalents')
    SetButtonFromAtlas(AchievementMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'Achievements')
    SetButtonFromAtlas(QuestLogMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'Questlog')
    SetButtonFromAtlas(SocialsMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'GuildCommunities')
    SetButtonFromAtlas(PVPMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'AdventureGuide')
    PVPMicroButtonTexture:Hide()
    SetButtonFromAtlas(LFGMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'Groupfinder')
    SetButtonFromAtlas(MainMenuMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'Shop')
    MainMenuBarPerformanceBar:Hide()
    SetButtonFromAtlas(HelpMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'GameMenu')
end
ChangeMicroMenu()

function ChangeBackpack()
    --MainMenuBarBackpackButton MainMenuBarBackpackButtonIconTexture
    local texture = 'Interface\\Addons\\DragonflightUI\\Textures\\bigbag'
    local highlight = 'Interface\\Addons\\DragonflightUI\\Textures\\bigbagHighlight'

    MainMenuBarBackpackButton:SetScale(1.5)

    SetItemButtonTexture(MainMenuBarBackpackButton, texture)
    MainMenuBarBackpackButton:SetHighlightTexture(highlight)
    MainMenuBarBackpackButton:SetPushedTexture(highlight)
    MainMenuBarBackpackButton:SetCheckedTexture(highlight)

    MainMenuBarBackpackButtonNormalTexture:Hide()
    MainMenuBarBackpackButtonNormalTexture:SetTexture()
    --MainMenuBarBackpackButton.IconBorder:Hide()

    for i = 0, 3 do
        local slot = 'Interface\\Addons\\DragonflightUI\\Textures\\bagborder2'
        local slothighlight = 'Interface\\Addons\\DragonflightUI\\Textures\\baghighlight2'

        local bagtexture = 'Interface\\Addons\\DragonflightUI\\Textures\\bagslots2x'
        _G['CharacterBag' .. i .. 'Slot']:GetNormalTexture():SetTexture(bagtexture)
        --  _G['CharacterBag' .. i .. 'Slot']:GetNormalTexture():SetTexCoord(0.576171875, 0.6953125, 0.5, 0.9765625) -- empty
        -- dx/dy => better center
        local dy = 0.015
        local dx = -0.001
        _G['CharacterBag' .. i .. 'Slot']:GetNormalTexture():SetTexCoord(
            0.576171875 + dx,
            0.6953125 + dx,
            0.0078125 + dy,
            0.484375 + dy
        )
        _G['CharacterBag' .. i .. 'Slot']:GetNormalTexture():SetSize(35, 35)

        _G['CharacterBag' .. i .. 'Slot']:GetHighlightTexture():SetTexture(bagtexture)
        _G['CharacterBag' .. i .. 'Slot']:GetHighlightTexture():SetTexCoord(
            0.69921875,
            0.818359375,
            0.0078125,
            0.484375
        )
        _G['CharacterBag' .. i .. 'Slot']:GetHighlightTexture():SetSize(35, 35)

        _G['CharacterBag' .. i .. 'Slot']:GetCheckedTexture():SetTexture()
        _G['CharacterBag' .. i .. 'Slot']:GetPushedTexture():SetTexture()

        _G['CharacterBag' .. i .. 'SlotIconTexture']:SetMask('Interface\\Addons\\DragonflightUI\\Textures\\bagmask')

        -- Note:
        -- bagID = 4 3 2 1 0  , 0 = backpack
        -- texture bag id = 3 2 1 0  , backpack seperate
        local slothook = function(self, id)
            local slots = GetContainerNumSlots(id)
            local name = 'CharacterBag' .. (id - 1) .. 'Slot'
            if slots == 0 then
                _G[name]:GetNormalTexture():SetTexCoord(0.576171875, 0.6953125, 0.5, 0.9765625)
            else
                _G[name]:GetNormalTexture():SetTexCoord(0.576171875 + dx, 0.6953125 + dx, 0.0078125 + dy, 0.484375 + dy)
            end
        end

        hooksecurefunc(
            _G['CharacterBag' .. i .. 'SlotIconTexture'],
            'SetTexture',
            function(args)
                slothook(args, i + 1)
            end
        )
    end
end
ChangeBackpack()

function MoveBars()
    MainMenuBarBackpackButton:ClearAllPoints()
    MainMenuBarBackpackButton:SetPoint('BOTTOMRIGHT', UIParent, 0, 26)

    CharacterMicroButton:ClearAllPoints()
    CharacterMicroButton:SetPoint('BOTTOMRIGHT', UIParent, -300 - 20, 0)
end
MoveBars()

function ChangeFramerate()
    FramerateLabel:ClearAllPoints()
    FramerateLabel:SetPoint('BOTTOM', CharacterMicroButton, 'BOTTOM', -80, 6)
    local scale = 0.75
    FramerateLabel:SetScale(scale)
    FramerateText:SetScale(scale)
    UIPARENT_MANAGED_FRAME_POSITIONS.FramerateLabel = nil

    -- text

    local f = CreateFrame('Frame', 'PingTextFrame', UIParent)
    f:SetWidth(1)
    f:SetHeight(1)
    f:ClearAllPoints()
    f:SetPoint('LEFT', FramerateLabel, 'LEFT', 0, 14)
    local t = f:CreateFontString('PingText', 'OVERLAY', 'SystemFont_Shadow_Med1')
    t:SetPoint('LEFT', 0, 0)
    t:SetText('')

    local Path, Size, Flags = FramerateText:GetFont()
    t:SetFont(Path, Size, Flags)

    hooksecurefunc(
        FramerateText,
        'SetFormattedText',
        function()
            local down, up, lagHome, lagWorld = GetNetStats()
            local str = 'MS: ' .. lagHome .. '|' .. lagWorld
            t:SetText(str)
        end
    )
    hooksecurefunc(
        FramerateText,
        'Show',
        function()
            f:Show()
        end
    )
    hooksecurefunc(
        FramerateText,
        'Hide',
        function()
            f:Hide()
        end
    )
end
ChangeFramerate()

print('Micromenu.lua - END')
