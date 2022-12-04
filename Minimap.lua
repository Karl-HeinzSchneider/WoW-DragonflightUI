print('Minimap.lua')

local frame = CreateFrame('FRAME')

function HideDefaultStuff()
    _G['MinimapBorder']:Hide()
end
HideDefaultStuff()

function DrawMinimapBorder()
    local texture = UIParent:CreateTexture()
    texture:SetDrawLayer('ARTWORK', 7)
    texture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    texture:SetTexCoord(0.001953125, 0.857421875, 0.056640625, 0.505859375)
    texture:SetPoint('CENTER', 'Minimap', 'CENTER', 0, 0)
    texture:SetSize(219, 230)
    texture:SetScale(0.7)

    frame.minimap = texture
end
DrawMinimapBorder()

print('Minimap.lua - END')
