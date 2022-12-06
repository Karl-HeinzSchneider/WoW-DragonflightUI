print('Artframe.lua')

local frame = CreateFrame('FRAME', 'DragonflightUIArtframe', UIParent)
--frame:SetFrameStrata('MEDIUM')
--frame:SetPoint('CENTER')

local atlasActionbar = {
    ['_UI-HUD-ActionBar-Frame-Divider-Threeslice-Center'] = {
        32,
        28,
        0,
        0.0625,
        0.08740234375,
        0.10107421875,
        true,
        false
    },
    ['_UI-HUD-ActionBar-Frame-NineSlice-EdgeBottom'] = {32, 46, 0, 0.0625, 0.04736328125, 0.06982421875, true, false},
    ['_UI-HUD-ActionBar-Frame-NineSlice-EdgeTop'] = {32, 32, 0, 0.0625, 0.07080078125, 0.08642578125, true, false},
    ['UI-HUD-ActionBar-Flyout'] = {36, 14, 0.884765625, 0.955078125, 0.43896484375, 0.44580078125, false, false},
    ['UI-HUD-ActionBar-Flyout-Down'] = {38, 16, 0.884765625, 0.958984375, 0.43017578125, 0.43798828125, false, false},
    ['UI-HUD-ActionBar-Flyout-Mouseover'] = {
        36,
        14,
        0.884765625,
        0.955078125,
        0.44677734375,
        0.45361328125,
        false,
        false
    },
    ['UI-HUD-ActionBar-Frame-Divider-ThreeSlice-EdgeBottom'] = {
        24,
        30,
        0.771484375,
        0.818359375,
        0.40673828125,
        0.42138671875,
        false,
        false
    },
    ['UI-HUD-ActionBar-Frame-Divider-Threeslice-EdgeLeft'] = {
        24,
        28,
        0.884765625,
        0.931640625,
        0.40869140625,
        0.42236328125,
        false,
        false
    },
    ['UI-HUD-ActionBar-Frame-Divider-Threeslice-EdgeRight'] = {
        24,
        28,
        0.935546875,
        0.982421875,
        0.40869140625,
        0.42236328125,
        false,
        false
    },
    ['UI-HUD-ActionBar-Frame-Divider-ThreeSlice-EdgeTop'] = {
        24,
        28,
        0.822265625,
        0.869140625,
        0.40673828125,
        0.42041015625,
        false,
        false
    },
    ['UI-HUD-ActionBar-Frame-NineSlice-CornerBottomLeft'] = {
        34,
        46,
        0.908203125,
        0.974609375,
        0.18701171875,
        0.20947265625,
        false,
        false
    },
    ['UI-HUD-ActionBar-Frame-NineSlice-CornerBottomRight'] = {
        44,
        46,
        0.908203125,
        0.994140625,
        0.16357421875,
        0.18603515625,
        false,
        false
    },
    ['UI-HUD-ActionBar-Frame-NineSlice-CornerTopLeft'] = {
        34,
        32,
        0.904296875,
        0.970703125,
        0.23193359375,
        0.24755859375,
        false,
        false
    },
    ['UI-HUD-ActionBar-Frame-NineSlice-CornerTopRight'] = {
        44,
        32,
        0.904296875,
        0.990234375,
        0.21533203125,
        0.23095703125,
        false,
        false
    },
    ['UI-HUD-ActionBar-Gryphon-Left'] = {200, 188, 0.001953125, 0.697265625, 0.10205078125, 0.26513671875, false, false},
    ['UI-HUD-ActionBar-Gryphon-Right'] = {
        200,
        188,
        0.001953125,
        0.697265625,
        0.26611328125,
        0.42919921875,
        false,
        false
    },
    ['UI-HUD-ActionBar-IconFrame'] = {92, 90, 0.701171875, 0.880859375, 0.31689453125, 0.36083984375, false, false},
    ['UI-HUD-ActionBar-IconFrame-AddRow'] = {
        102,
        102,
        0.701171875,
        0.900390625,
        0.21533203125,
        0.26513671875,
        false,
        false
    },
    ['UI-HUD-ActionBar-IconFrame-AddRow-Down'] = {
        102,
        102,
        0.701171875,
        0.900390625,
        0.26611328125,
        0.31591796875,
        false,
        false
    },
    ['UI-HUD-ActionBar-IconFrame-Border'] = {
        92,
        90,
        0.701171875,
        0.880859375,
        0.36181640625,
        0.40576171875,
        false,
        false
    },
    ['UI-HUD-ActionBar-IconFrame-Down'] = {92, 90, 0.701171875, 0.880859375, 0.43017578125, 0.47412109375, false, false},
    ['UI-HUD-ActionBar-IconFrame-Flash'] = {
        92,
        90,
        0.701171875,
        0.880859375,
        0.47509765625,
        0.51904296875,
        false,
        false
    },
    ['UI-HUD-ActionBar-IconFrame-FlyoutBorderShadow'] = {
        104,
        104,
        0.701171875,
        0.904296875,
        0.16357421875,
        0.21435546875,
        false,
        false
    },
    ['UI-HUD-ActionBar-IconFrame-FlyoutBottom'] = {
        94,
        10,
        0.701171875,
        0.884765625,
        0.59423828125,
        0.59912109375,
        false,
        false
    },
    ['UI-HUD-ActionBar-IconFrame-FlyoutBottomLeft'] = {
        10,
        94,
        0.955078125,
        0.974609375,
        0.10205078125,
        0.14794921875,
        false,
        false
    },
    ['UI-HUD-ActionBar-IconFrame-FlyoutButton'] = {
        94,
        58,
        0.701171875,
        0.884765625,
        0.56494140625,
        0.59326171875,
        false,
        false
    },
    ['UI-HUD-ActionBar-IconFrame-FlyoutButtonLeft'] = {
        58,
        94,
        0.884765625,
        0.998046875,
        0.36181640625,
        0.40771484375,
        false,
        false
    },
    ['UI-HUD-ActionBar-IconFrame-Mouseover'] = {
        92,
        90,
        0.701171875,
        0.880859375,
        0.52001953125,
        0.56396484375,
        false,
        false
    },
    ['UI-HUD-ActionBar-IconFrame-Slot'] = {
        128,
        124,
        0.701171875,
        0.951171875,
        0.10205078125,
        0.16259765625,
        false,
        false
    },
    ['UI-HUD-ActionBar-PageDownArrow-Disabled'] = {
        34,
        28,
        0.904296875,
        0.970703125,
        0.24853515625,
        0.26220703125,
        false,
        false
    },
    ['UI-HUD-ActionBar-PageDownArrow-Down'] = {
        34,
        28,
        0.904296875,
        0.970703125,
        0.26611328125,
        0.27978515625,
        false,
        false
    },
    ['UI-HUD-ActionBar-PageDownArrow-Mouseover'] = {
        34,
        28,
        0.904296875,
        0.970703125,
        0.28076171875,
        0.29443359375,
        false,
        false
    },
    ['UI-HUD-ActionBar-PageDownArrow-Up'] = {
        34,
        28,
        0.904296875,
        0.970703125,
        0.29541015625,
        0.30908203125,
        false,
        false
    },
    ['UI-HUD-ActionBar-PageUpArrow-Disabled'] = {
        34,
        28,
        0.884765625,
        0.951171875,
        0.31689453125,
        0.33056640625,
        false,
        false
    },
    ['UI-HUD-ActionBar-PageUpArrow-Down'] = {
        34,
        28,
        0.884765625,
        0.951171875,
        0.33154296875,
        0.34521484375,
        false,
        false
    },
    ['UI-HUD-ActionBar-PageUpArrow-Mouseover'] = {
        34,
        28,
        0.884765625,
        0.951171875,
        0.34619140625,
        0.35986328125,
        false,
        false
    },
    ['UI-HUD-ActionBar-PageUpArrow-Up'] = {34, 28, 0.701171875, 0.767578125, 0.40673828125, 0.42041015625, false, false},
    ['UI-HUD-ActionBar-Wyvern-Left'] = {200, 188, 0.001953125, 0.697265625, 0.43017578125, 0.59326171875, false, false},
    ['UI-HUD-ActionBar-Wyvern-Right'] = {200, 188, 0.001953125, 0.697265625, 0.59423828125, 0.75732421875, false, false}
}

function CreateFrameFromAtlas(atlas, name, textureRef, frameName)
    local data = atlas[name]

    local f = CreateFrame('Frame', frameName, UIParent)
    f:SetSize(data[1], data[2])
    f:SetPoint('CENTER', UIParent, 'CENTER')

    f.texture = f:CreateTexture()
    f.texture:SetTexture(textureRef)
    f.texture:SetSize(data[1], data[2])
    f.texture:SetTexCoord(data[3], data[4], data[5], data[6])
    f.texture:SetPoint('CENTER')
    return f
end

function ChangeGryphon()
    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()
    --MainMenuBarArtFrame:Hide()
    MainMenuBarTexture0:Hide()
    MainMenuBarTexture1:Hide()
    MainMenuBarTexture2:Hide()
    MainMenuBarTexture3:Hide()
end
ChangeGryphon()

function DrawGryphon()
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'

    local GryphonLeft = CreateFrameFromAtlas(atlasActionbar, 'UI-HUD-ActionBar-Gryphon-Left', textureRef, 'GrpyhonLeft')
    GryphonLeft:SetScale(0.5)
    GryphonLeft:SetPoint('CENTER', ActionButton1, 'CENTER', -120, 5)
    GryphonLeft:SetFrameStrata('HIGH')
    GryphonLeft:SetFrameLevel(100)

    local GryphonRight =
        CreateFrameFromAtlas(atlasActionbar, 'UI-HUD-ActionBar-Gryphon-Right', textureRef, 'GryphonRight')
    GryphonRight:SetScale(0.5)
    GryphonRight:SetPoint('CENTER', ActionButton12, 'CENTER', 120, 5)
    GryphonRight:SetFrameStrata('HIGH')
    GryphonRight:SetFrameLevel(100)
end
DrawGryphon()

function DrawActionbarDeco()
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'
    for i = 1, 12 do
        local deco =
            CreateFrameFromAtlas(atlasActionbar, 'UI-HUD-ActionBar-IconFrame-Slot', textureRef, 'ActionbarDeco' .. i)
        --print(deco:GetSize())
        deco:SetScale(0.3)
        --deco:SetSize(35, 35)
        deco:SetPoint('CENTER', _G['ActionButton' .. i], 'CENTER', 0, 0)
        --deco:SetPoint('CENTER', ActionButton4, 'CENTER', 0, 0)
    end
    --[[ 
    local decoBar = CreateFrameFromAtlas(atlasActionbar, 'UI-HUD-ActionBar-IconFrame', textureRef, 'ActionbarDecoBar')
    decoBar:SetScale(1)
    decoBar:SetSize(427, 35)
    decoBar:SetPoint('CENTER', UIParent, 'CENTER', 0, 0) ]]
    --[[  local backdropInfo = {
        bgFile = 'Interface\\Tooltips\\UI-Tooltip-Background',
        edgeFile = 'Interface\\Addons\\DragonflightUI\\Textures\\Border',
        tile = true,
        tileEdge = true,
        tileSize = 8,
        edgeSize = 8,
        insets = {left = 1, right = 1, top = 1, bottom = 1}
    }

    local bd = CreateFrame('Frame', nil, nil, 'BackdropTemplate')
    bd:SetSize(330, 31)
    bd:SetScale(1)
    bd:SetBackdrop(backdropInfo)
    bd:SetPoint('LEFT', ActionButton1, 'LEFT', -3, -1 + 200)

    local texture = UIParent:CreateTexture()
    texture:SetDrawLayer('ARTWORK', 7)
    texture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\border')
    texture:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    texture:SetSize(330, 31)
    texture:SetScale(1) ]]
end
DrawActionbarDeco()

for i = 1, 10 do
    --print(i)
end

print('Artframe.lua - End')
