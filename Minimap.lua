print('Minimap.lua')

local frame = CreateFrame('FRAME')

function HideDefaultStuff()
    _G['MinimapBorder']:Hide()
    _G['MinimapBorderTop']:Hide()

    -- Hide WorldMapButton
    MiniMapWorldMapButton:Hide()
    hooksecurefunc(
        MiniMapWorldMapButton,
        'Show',
        function()
            MiniMapWorldMapButton:Hide()
        end
    )
    -- Hide North Tag
    hooksecurefunc(
        MinimapNorthTag,
        'Show',
        function()
            MinimapNorthTag:Hide()
        end
    )
end
HideDefaultStuff()

function MoveDefaultStuff()
    --print(Minimap:GetPoint())
    --CENTER table: 000001F816E0E7B0 TOP 9 -92
    Minimap:SetPoint('CENTER', MinimapCluster, 'TOP', -10, -105)
    Minimap:SetScale(1.25)
end
MoveDefaultStuff()

function ChangeZoom()
    local dx, dy = 5, 65
    MinimapZoomIn:SetScale(0.75)
    MinimapZoomIn:SetPoint('CENTER', Minimap, 'RIGHT', -dx, -dy)
    MinimapZoomIn:SetNormalTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomIn:GetNormalTexture():SetTexCoord(0.001953125, 0.068359375, 0.5390625, 0.572265625)
    --MinimapZoomIn:SetPushedTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap')
    --MinimapZoomIn:GetPushedTexture():SetTexCoord(0.001953125, 0.068359375, 0.57421875, 0.607421875)
    MinimapZoomIn:SetPushedTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomIn:GetPushedTexture():SetTexCoord(0.001953125, 0.068359375, 0.5390625, 0.572265625)
    MinimapZoomIn:SetDisabledTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomIn:GetDisabledTexture():SetTexCoord(0.001953125, 0.068359375, 0.5390625, 0.572265625)
    MinimapZoomIn:GetDisabledTexture():SetDesaturated(1)
    MinimapZoomIn:SetHighlightTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomIn:GetHighlightTexture():SetTexCoord(0.001953125, 0.068359375, 0.5390625, 0.572265625)

    MinimapZoomOut:SetScale(0.75)
    MinimapZoomOut:SetPoint('CENTER', Minimap, 'BOTTOM', dy, dx)
    MinimapZoomOut:SetNormalTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomOut:GetNormalTexture():SetTexCoord(0.353515625, 0.419921875, 0.5078125, 0.525390625)
    MinimapZoomOut:SetPushedTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomOut:GetPushedTexture():SetTexCoord(0.353515625, 0.419921875, 0.5078125, 0.525390625)
    MinimapZoomOut:SetDisabledTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomOut:GetDisabledTexture():SetTexCoord(0.353515625, 0.419921875, 0.5078125, 0.525390625)
    MinimapZoomOut:GetDisabledTexture():SetDesaturated(1)
    MinimapZoomOut:SetHighlightTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomOut:GetHighlightTexture():SetTexCoord(0.353515625, 0.419921875, 0.5078125, 0.525390625)
end
ChangeZoom()

function ChangeCalendar()
    GameTimeFrame:SetPoint('TOPRIGHT', MinimapCluster, 'TOPRIGHT', 0, 0)
    --GameTimeFrame:SetParent(MinimapBackdrop)
    GameTimeFrame:SetScale(0.75)
    --GameTimeFrame:SetSize(32, 32)
end
ChangeCalendar()

function ChangeClock()
    if IsAddOnLoaded('Blizzard_TimeManager') then
        local regions = {TimeManagerClockButton:GetRegions()}
        regions[1]:Hide()
        TimeManagerClockButton:ClearAllPoints()
        TimeManagerClockButton:SetPoint('TOPRIGHT', MinimapCluster, 'TOPRIGHT', -15, 2)
    end
end
ChangeClock()

function ChangeZoneText()
    MinimapZoneTextButton:SetPoint('TOPRIGHT', MinimapCluster, 'TOPRIGHT', -65, -8)
end
ChangeZoneText()

function ChangeTracking()
    MiniMapTracking:ClearAllPoints()
    MiniMapTracking:SetPoint('TOPRIGHT', MinimapCluster, 'TOPRIGHT', -200, 0)
    MiniMapTracking:SetScale(0.75)
    --print(MiniMapTrackingBackground:GetTexture())
    --MiniMapTrackingBackground:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    --MiniMapTrackingBackground:SetTexCoord(0.291015625, 0.349609375, 0.5078125, 0.53515625)
end
ChangeTracking()

function DrawMinimapBorder()
    local texture = UIParent:CreateTexture()
    texture:SetDrawLayer('ARTWORK', 7)
    texture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    texture:SetTexCoord(0.001953125, 0.857421875, 0.056640625, 0.505859375)
    texture:SetPoint('CENTER', 'Minimap', 'CENTER', 0, 0)
    texture:SetSize(219, 230)
    texture:SetScale(0.88)

    frame.minimap = texture
end
DrawMinimapBorder()

function ReplaceTextures()
end

function MoveBuffs()
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint('TOPRIGHT', MinimapCluster, 'TOPLEFT', -45, -13)
    hooksecurefunc(
        'UIParent_UpdateTopFramePositions',
        function()
            BuffFrame:ClearAllPoints()
            BuffFrame:SetPoint('TOPRIGHT', MinimapCluster, 'TOPLEFT', -45, -13)
        end
    )
    -- @TODO: Taint ingame
    --[[ BuffFrame.SetPoint = function()
    end ]]
    -- BuffFrame.ClearAllPoints() = function()     end
end
MoveBuffs()

-- Events
frame:RegisterEvent('ADDON_LOADED')

function frame:OnEvent(event, arg1)
    if event == 'ADDON_LOADED' and arg1 == 'Blizzard_TimeManager' then
        --print('Blizzard_TimeManager')
        ChangeClock()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)

print('Minimap.lua - END')
