local Addon, Core = ...
local Module = 'Minimap'

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
--HideDefaultStuff()

function MoveDefaultStuff()
    --print(Minimap:GetPoint())
    --CENTER table: 000001F816E0E7B0 TOP 9 -92
    Minimap:SetPoint('CENTER', MinimapCluster, 'TOP', -10, -105)
    Minimap:SetScale(1.25)
end
--MoveDefaultStuff()

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
--ChangeZoom()

function CreateMinimapInfoFrame()
    local f = CreateFrame('Frame', 'DragonflightUIMinimapTop', UIParent)
    f:SetSize(180, 22)
    f:SetPoint('CENTER', Minimap, 'TOP', -5, 25)

    local tex = f:CreateTexture('Background', 'ARTWORK')
    tex:SetAllPoints()
    tex:SetColorTexture(0, 0, 0)
    tex:SetAlpha(0.5)
    f.Background = tex

    frame.MinimapInfo = f
end
--CreateMinimapInfoFrame()

function ChangeCalendar()
    GameTimeFrame:ClearAllPoints()
    --GameTimeFrame:SetPoint('CENTER', MinimapCluster, 'TOPRIGHT', -16, -20)
    GameTimeFrame:SetPoint('LEFT', frame.MinimapInfo, 'RIGHT', 0, -2)

    --GameTimeFrame:SetParent(MinimapBackdrop)
    GameTimeFrame:SetScale(0.75)

    local texture = 'Interface\\Addons\\DragonflightUI\\Textures\\uicalendar32'
    GameTimeFrame:SetSize(35, 35)
    GameTimeFrame:GetNormalTexture():SetTexture(texture)
    GameTimeFrame:GetNormalTexture():SetTexCoord(0.18359375, 0.265625, 0.00390625, 0.078125)
    GameTimeFrame:GetPushedTexture():SetTexture(texture)
    GameTimeFrame:GetPushedTexture():SetTexCoord(0.00390625, 0.0859375, 0.00390625, 0.078125)
    GameTimeFrame:GetHighlightTexture():SetTexture(texture)
    GameTimeFrame:GetHighlightTexture():SetTexCoord(0.09375, 0.17578125, 0.00390625, 0.078125)

    --@TODO: change Font/size/center etc
    --local fontstring = GameTimeFrame:GetFontString()
    -- print(fontstring[1])
    --GameTimeFrame:SetNormalFontObject(GameFontHighlightLarge)

    --local obj = GameTimeFrame:GetNormalFontObject()
    --obj:SetJustifyH('LEFT')
end
--ChangeCalendar()

function ChangeClock()
    if IsAddOnLoaded('Blizzard_TimeManager') then
        local regions = {TimeManagerClockButton:GetRegions()}
        regions[1]:Hide()
        TimeManagerClockButton:ClearAllPoints()
        TimeManagerClockButton:SetPoint('RIGHT', frame.MinimapInfo, 'RIGHT', 5, 0)
        TimeManagerClockButton:SetParent(frame.MinimapInfo)
    end
end
--ChangeClock()

function ChangeZoneText()
    MinimapZoneTextButton:SetPoint('LEFT', frame.MinimapInfo, 'LEFT', 0, 0)
    MinimapZoneTextButton:SetParent(frame.MinimapInfo)
end
--ChangeZoneText()

function ChangeTracking()
    MiniMapTracking:ClearAllPoints()
    --MiniMapTracking:SetPoint('TOPRIGHT', MinimapCluster, 'TOPRIGHT', -200 - 5, 0)
    MiniMapTracking:SetPoint('RIGHT', frame.MinimapInfo, 'LEFT', 0, 0)

    MiniMapTracking:SetScale(0.75)

    MiniMapTrackingButtonBorder:Hide()
    MiniMapTrackingIcon:SetPoint('CENTER', MiniMapTrackingButton, -25, 0)
    --print(MiniMapTrackingBackground:GetTexture())
    --MiniMapTrackingBackground:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    --MiniMapTrackingBackground:SetTexCoord(0.291015625, 0.349609375, 0.5078125, 0.53515625)
end
--ChangeTracking()

function DrawMinimapBorder()
    local texture = MinimapCluster:CreateTexture()
    texture:SetDrawLayer('ARTWORK', 7)
    texture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    texture:SetTexCoord(0.001953125, 0.857421875, 0.056640625, 0.505859375)
    texture:SetPoint('CENTER', 'Minimap', 'CENTER', 0, 0)
    texture:SetSize(219, 230)
    texture:SetScale(0.88)

    frame.minimap = texture
end
--DrawMinimapBorder()

function ReplaceTextures()
end

function MoveBuffs()
    local dx = -45 - 10
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint('TOPRIGHT', MinimapCluster, 'TOPLEFT', dx, -13)
    hooksecurefunc(
        'UIParent_UpdateTopFramePositions',
        function()
            BuffFrame:ClearAllPoints()
            BuffFrame:SetPoint('TOPRIGHT', MinimapCluster, 'TOPLEFT', dx, -13)
        end
    )
    -- @TODO: Taint ingame
    --[[ BuffFrame.SetPoint = function()
    end ]]
    -- BuffFrame.ClearAllPoints() = function()     end
end
--MoveBuffs()

function MoveTracker()
    local setting
    hooksecurefunc(
        WatchFrame,
        'SetPoint',
        function(self)
            if not setting then
                setting = true
                self:ClearAllPoints()
                if MultiBarRight:IsShown() and MultiBarLeft:IsShown() then
                    self:SetPoint('TOPRIGHT', MinimapCluster, 'BOTTOMRIGHT', -100, -50)
                elseif MultiBarRight:IsShown() then
                    self:SetPoint('TOPRIGHT', MinimapCluster, 'BOTTOMRIGHT', -25, -50)
                else
                    self:SetPoint('TOPRIGHT', MinimapCluster, 'BOTTOMRIGHT', 0, -50)
                end
                self:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', 0, 100)
                setting = nil
            end
        end
    )
end
--MoveTracker()

-- Events
--frame:RegisterEvent('ADDON_LOADED')

function MinimapModule()
    HideDefaultStuff()
    MoveDefaultStuff()
    ChangeZoom()
    CreateMinimapInfoFrame()
    ChangeCalendar()
    ChangeClock()
    ChangeZoneText()
    ChangeTracking()
    DrawMinimapBorder()
    MoveBuffs()
    MoveTracker()

    frame:RegisterEvent('ADDON_LOADED')
end

Core.RegisterModule(Module, {}, {}, true, MinimapModule)

function frame:OnEvent(event, arg1)
    if event == 'ADDON_LOADED' and arg1 == 'Blizzard_TimeManager' then
        --print('Blizzard_TimeManager')
        ChangeClock()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)
