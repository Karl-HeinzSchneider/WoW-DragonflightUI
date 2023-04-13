local Addon, Core = ...
local Module = 'Minimap'

local frame = CreateFrame('FRAME')

local function GetCoords(key)
    local uiunitframe = {
        ['UI-HUD-Calendar-1-Down'] = {21, 19, 0.00390625, 0.0859375, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-1-Mouseover'] = {21, 19, 0.09375, 0.17578125, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-1-Up'] = {21, 19, 0.18359375, 0.265625, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-10-Down'] = {21, 19, 0.2734375, 0.35546875, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-10-Mouseover'] = {21, 19, 0.36328125, 0.4453125, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-10-Up'] = {21, 19, 0.453125, 0.53515625, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-11-Down'] = {21, 19, 0.54296875, 0.625, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-11-Mouseover'] = {21, 19, 0.6328125, 0.71484375, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-11-Up'] = {21, 19, 0.72265625, 0.8046875, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-12-Down'] = {21, 19, 0.8125, 0.89453125, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-12-Mouseover'] = {21, 19, 0.90234375, 0.984375, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-12-Up'] = {21, 19, 0.00390625, 0.0859375, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-13-Down'] = {21, 19, 0.09375, 0.17578125, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-13-Mouseover'] = {21, 19, 0.18359375, 0.265625, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-13-Up'] = {21, 19, 0.2734375, 0.35546875, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-14-Down'] = {21, 19, 0.36328125, 0.4453125, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-14-Mouseover'] = {21, 19, 0.453125, 0.53515625, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-14-Up'] = {21, 19, 0.54296875, 0.625, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-15-Down'] = {21, 19, 0.6328125, 0.71484375, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-15-Mouseover'] = {21, 19, 0.72265625, 0.8046875, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-15-Up'] = {21, 19, 0.8125, 0.89453125, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-16-Down'] = {21, 19, 0.90234375, 0.984375, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-16-Mouseover'] = {21, 19, 0.00390625, 0.0859375, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-16-Up'] = {21, 19, 0.00390625, 0.0859375, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-17-Down'] = {21, 19, 0.00390625, 0.0859375, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-17-Mouseover'] = {21, 19, 0.00390625, 0.0859375, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-17-Up'] = {21, 19, 0.00390625, 0.0859375, 0.49609375, 0.5703125, false, false},
        ['UI-HUD-Calendar-18-Down'] = {21, 19, 0.00390625, 0.0859375, 0.578125, 0.65234375, false, false},
        ['UI-HUD-Calendar-18-Mouseover'] = {21, 19, 0.00390625, 0.0859375, 0.66015625, 0.734375, false, false},
        ['UI-HUD-Calendar-18-Up'] = {21, 19, 0.00390625, 0.0859375, 0.7421875, 0.81640625, false, false},
        ['UI-HUD-Calendar-19-Down'] = {21, 19, 0.00390625, 0.0859375, 0.82421875, 0.8984375, false, false},
        ['UI-HUD-Calendar-19-Mouseover'] = {21, 19, 0.00390625, 0.0859375, 0.90625, 0.98046875, false, false},
        ['UI-HUD-Calendar-19-Up'] = {21, 19, 0.09375, 0.17578125, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-2-Down'] = {21, 19, 0.18359375, 0.265625, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-2-Mouseover'] = {21, 19, 0.2734375, 0.35546875, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-2-Up'] = {21, 19, 0.36328125, 0.4453125, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-20-Down'] = {21, 19, 0.453125, 0.53515625, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-20-Mouseover'] = {21, 19, 0.54296875, 0.625, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-20-Up'] = {21, 19, 0.6328125, 0.71484375, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-21-Down'] = {21, 19, 0.72265625, 0.8046875, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-21-Mouseover'] = {21, 19, 0.8125, 0.89453125, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-21-Up'] = {21, 19, 0.90234375, 0.984375, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-22-Down'] = {21, 19, 0.09375, 0.17578125, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-22-Mouseover'] = {21, 19, 0.09375, 0.17578125, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-22-Up'] = {21, 19, 0.09375, 0.17578125, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-23-Down'] = {21, 19, 0.09375, 0.17578125, 0.49609375, 0.5703125, false, false},
        ['UI-HUD-Calendar-23-Mouseover'] = {21, 19, 0.09375, 0.17578125, 0.578125, 0.65234375, false, false},
        ['UI-HUD-Calendar-23-Up'] = {21, 19, 0.09375, 0.17578125, 0.66015625, 0.734375, false, false},
        ['UI-HUD-Calendar-24-Down'] = {21, 19, 0.09375, 0.17578125, 0.7421875, 0.81640625, false, false},
        ['UI-HUD-Calendar-24-Mouseover'] = {21, 19, 0.09375, 0.17578125, 0.82421875, 0.8984375, false, false},
        ['UI-HUD-Calendar-24-Up'] = {21, 19, 0.09375, 0.17578125, 0.90625, 0.98046875, false, false},
        ['UI-HUD-Calendar-25-Down'] = {21, 19, 0.18359375, 0.265625, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-25-Mouseover'] = {21, 19, 0.2734375, 0.35546875, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-25-Up'] = {21, 19, 0.36328125, 0.4453125, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-26-Down'] = {21, 19, 0.453125, 0.53515625, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-26-Mouseover'] = {21, 19, 0.54296875, 0.625, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-26-Up'] = {21, 19, 0.6328125, 0.71484375, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-27-Down'] = {21, 19, 0.72265625, 0.8046875, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-27-Mouseover'] = {21, 19, 0.8125, 0.89453125, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-27-Up'] = {21, 19, 0.90234375, 0.984375, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-28-Down'] = {21, 19, 0.18359375, 0.265625, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-28-Mouseover'] = {21, 19, 0.18359375, 0.265625, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-28-Up'] = {21, 19, 0.18359375, 0.265625, 0.49609375, 0.5703125, false, false},
        ['UI-HUD-Calendar-29-Down'] = {21, 19, 0.18359375, 0.265625, 0.578125, 0.65234375, false, false},
        ['UI-HUD-Calendar-29-Mouseover'] = {21, 19, 0.18359375, 0.265625, 0.66015625, 0.734375, false, false},
        ['UI-HUD-Calendar-29-Up'] = {21, 19, 0.18359375, 0.265625, 0.7421875, 0.81640625, false, false},
        ['UI-HUD-Calendar-3-Down'] = {21, 19, 0.18359375, 0.265625, 0.82421875, 0.8984375, false, false},
        ['UI-HUD-Calendar-3-Mouseover'] = {21, 19, 0.18359375, 0.265625, 0.90625, 0.98046875, false, false},
        ['UI-HUD-Calendar-3-Up'] = {21, 19, 0.2734375, 0.35546875, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-30-Down'] = {21, 19, 0.36328125, 0.4453125, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-30-Mouseover'] = {21, 19, 0.453125, 0.53515625, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-30-Up'] = {21, 19, 0.54296875, 0.625, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-31-Down'] = {21, 19, 0.6328125, 0.71484375, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-31-Mouseover'] = {21, 19, 0.72265625, 0.8046875, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-31-Up'] = {21, 19, 0.8125, 0.89453125, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-4-Down'] = {21, 19, 0.90234375, 0.984375, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-4-Mouseover'] = {21, 19, 0.2734375, 0.35546875, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-4-Up'] = {21, 19, 0.2734375, 0.35546875, 0.49609375, 0.5703125, false, false},
        ['UI-HUD-Calendar-5-Down'] = {21, 19, 0.2734375, 0.35546875, 0.578125, 0.65234375, false, false},
        ['UI-HUD-Calendar-5-Mouseover'] = {21, 19, 0.2734375, 0.35546875, 0.66015625, 0.734375, false, false},
        ['UI-HUD-Calendar-5-Up'] = {21, 19, 0.2734375, 0.35546875, 0.7421875, 0.81640625, false, false},
        ['UI-HUD-Calendar-6-Down'] = {21, 19, 0.2734375, 0.35546875, 0.82421875, 0.8984375, false, false},
        ['UI-HUD-Calendar-6-Mouseover'] = {21, 19, 0.2734375, 0.35546875, 0.90625, 0.98046875, false, false},
        ['UI-HUD-Calendar-6-Up'] = {21, 19, 0.36328125, 0.4453125, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-7-Down'] = {21, 19, 0.453125, 0.53515625, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-7-Mouseover'] = {21, 19, 0.54296875, 0.625, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-7-Up'] = {21, 19, 0.6328125, 0.71484375, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-8-Down'] = {21, 19, 0.72265625, 0.8046875, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-8-Mouseover'] = {21, 19, 0.8125, 0.89453125, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-8-Up'] = {21, 19, 0.90234375, 0.984375, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-9-Down'] = {21, 19, 0.36328125, 0.4453125, 0.49609375, 0.5703125, false, false},
        ['UI-HUD-Calendar-9-Mouseover'] = {21, 19, 0.36328125, 0.4453125, 0.578125, 0.65234375, false, false},
        ['UI-HUD-Calendar-9-Up'] = {21, 19, 0.36328125, 0.4453125, 0.66015625, 0.734375, false, false}
    }

    local data = uiunitframe[key]
    return data[3], data[4], data[5], data[6]
end

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

function HookMouseWheel()
    Minimap:SetScript("OnMouseWheel", function(self, delta)
        if (delta <= -1) then
            if Minimap:GetZoom() <= 0 then
                MinimapZoomOut:Disable()
                MinimapZoomIn:Enable()
            else 
                Minimap:SetZoom(currentZoom - 1)
            end
        elseif (delta >= 1) then
            if Minimap:GetZoom() >= maximumZoom then
                MinimapZoomOut:Enable()
                MinimapZoomIn:Disable()
            else 
                Minimap:SetZoom(currentZoom + 1)
            end
        end
    end)
end

function CreateMinimapInfoFrame()
    local f = CreateFrame('Frame', 'DragonflightUIMinimapTop', UIParent)
    f:SetSize(170, 22)
    f:SetPoint('CENTER', Minimap, 'TOP', 0, 25)

    local background = f:CreateTexture('DragonflightUIMinimapTopBackground', 'ARTWORK')
    background:ClearAllPoints()
    background:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\MinimapBorder')
    background:SetSize(170, 38)
    background:SetPoint('LEFT', f, 'LEFT', 0, -8)

    f.Background = background

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

    GameTimeFrame:Hide()
    --@TODO: change Font/size/center etc
    --local fontstring = GameTimeFrame:GetFontString()
    -- print(fontstring[1])
    --GameTimeFrame:SetNormalFontObject(GameFontHighlightLarge)

    --local obj = GameTimeFrame:GetNormalFontObject()
    --obj:SetJustifyH('LEFT')
end
--ChangeCalendar()

function UpdateCalendar()
    local button = frame.CalendarButton

    if button then
        local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uicalendar'

        local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime()
        local day = currentCalendarTime.monthDay
        --print('UpdateCalendar', day, GetCoords('UI-HUD-Calendar-' .. day .. '-Up'))
        frame.CalendarButtonText:SetText(day)

        --@TODO
        --button:GetNormalTexture():SetTexCoord(GetCoords('UI-HUD-Calendar-' .. day .. '-Up'))
        --button:GetHighlightTexture():SetTexCoord(GetCoords('UI-HUD-Calendar-' .. day .. '-Mouseover'))
        --button:GetPushedTexture():SetTexCoord(GetCoords('UI-HUD-Calendar-' .. day .. '-Down'))

        local fix
    else
        --print('no Calendarbutton => RIP')
    end
end

function HookCalendar()
    --local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uicalendar'
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uicalendar32'

    local button = CreateFrame('Button', 'DragonflightUICalendarButton', UIParent)
    button:SetPoint('CENTER', 0, 75)
    local size = 24
    button:SetSize(size * 1.105, size)

    button:ClearAllPoints()
    button:SetPoint('LEFT', frame.MinimapInfo, 'RIGHT', -2, -2)

    local text = button:CreateFontString('DragonflightUICalendarButtonText', 'ARTWORK', 'GameFontBlack')
    text:SetText('12')
    text:SetPoint('CENTER', -2, 1)

    button:SetScript(
        'OnClick',
        function()
            ToggleCalendar()
        end
    )

    button:SetNormalTexture(base)
    button:SetPushedTexture(base)
    button:SetHighlightTexture(base)
    button:GetNormalTexture():SetTexCoord(GetCoords('UI-HUD-Calendar-1-Up'))
    button:GetHighlightTexture():SetTexCoord(GetCoords('UI-HUD-Calendar-1-Mouseover'))
    button:GetPushedTexture():SetTexCoord(GetCoords('UI-HUD-Calendar-1-Down'))

    frame.CalendarButton = button
    frame.CalendarButtonText = text

    hooksecurefunc(
        TimeManagerClockTicker,
        'SetText',
        function()
            UpdateCalendar()
        end
    )
end

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
    MinimapZoneTextButton:ClearAllPoints()
    MinimapZoneTextButton:SetPoint('LEFT', frame.MinimapInfo, 'LEFT', 1, 0)
    MinimapZoneTextButton:SetParent(frame.MinimapInfo)
    MinimapZoneTextButton:SetSize(130, 12)

    MinimapZoneText:ClearAllPoints()
    MinimapZoneText:SetSize(130, 12)
    MinimapZoneText:SetPoint('LEFT', frame.MinimapInfo, 'LEFT', 1, 0)
end
--ChangeZoneText()

function ChangeTracking()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x'

    MiniMapTracking:ClearAllPoints()
    --MiniMapTracking:SetPoint('TOPRIGHT', MinimapCluster, 'TOPRIGHT', -200 - 5, 0)
    MiniMapTracking:SetPoint('RIGHT', frame.MinimapInfo, 'LEFT', 0, 0)
    MiniMapTracking:SetScale(0.75)
    MiniMapTrackingIcon:Hide()

    --MiniMapTrackingBackground:Hide()
    MiniMapTrackingBackground:ClearAllPoints()
    MiniMapTrackingBackground:SetPoint('CENTER', MiniMapTracking, 'CENTER')
    MiniMapTrackingBackground:SetTexture(base)
    MiniMapTrackingBackground:SetTexCoord(0.861328125, 0.9375, 0.392578125, 0.4296875)

    MiniMapTrackingButtonBorder:Hide()

    MiniMapTrackingButton:SetSize(19.5, 19)
    MiniMapTrackingButton:ClearAllPoints()
    MiniMapTrackingButton:SetPoint('CENTER', MiniMapTracking, 'CENTER')

    MiniMapTrackingButton:SetNormalTexture(base)
    MiniMapTrackingButton:GetNormalTexture():SetTexCoord(0.291015625, 0.349609375, 0.5078125, 0.53515625)
    MiniMapTrackingButton:SetHighlightTexture(base)
    MiniMapTrackingButton:GetHighlightTexture():SetTexCoord(0.228515625, 0.287109375, 0.5078125, 0.53515625)
    MiniMapTrackingButton:SetPushedTexture(base)
    MiniMapTrackingButton:GetPushedTexture():SetTexCoord(0.162109375, 0.224609375, 0.5078125, 0.537109375)
    --MiniMapTrackingIcon:SetPoint('CENTER', MiniMapTrackingButton, -25, 0)
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
                ConfigTable = ConfigTable or {}
                if ConfigTable['ActionbarSide'].active then
                    self:SetPoint('TOPRIGHT', MinimapCluster, 'BOTTOMRIGHT', 0, -50)
                elseif MultiBarRight:IsShown() and MultiBarLeft:IsShown() then
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

function ChangeLFG()
    MiniMapLFGFrame:ClearAllPoints()
    MiniMapLFGFrame:SetPoint('CENTER', Minimap, 'BOTTOMLEFT', 10, 30)
    --MinimapZoomIn:SetPoint('CENTER', Minimap, 'RIGHT', -dx, -dy)
end
--ChangeLFG()

function MoveBagAnchor()
    ContainerFrame1:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', 0, 132)
    ContainerFrame1.SetPoint = function()
    end
end

function ChangeMail()
    MiniMapMailBorder:Hide()
    MiniMapMailIcon:Hide()
    --MiniMapMailFrame:SetPoint('TOPRIGHT', Minimap, 'TOPRIGHT', 24 - 5, -52 + 25)
    MiniMapMailFrame:SetSize(19.5, 15)
    MiniMapMailFrame:SetPoint('TOPRIGHT', MiniMapTracking, 'BOTTOMRIGHT', 2, -1)

    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x'

    local mail = MiniMapMailFrame:CreateTexture('DragonflightUIMinimapMailFrame', 'ARTWORK')
    mail:ClearAllPoints()
    mail:SetTexture(base)
    mail:SetTexCoord(0.08203125, 0.158203125, 0.5078125, 0.537109375)
    mail:SetSize(19.5, 15)
    mail:SetPoint('CENTER', MiniMapMailFrame, 'CENTER', -3, 0)
    mail:SetScale(1)
end

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
    ChangeLFG()
    --MoveBagAnchor()
    HookMouseWheel()
    ChangeMail()

    frame:RegisterEvent('ADDON_LOADED')
end

Core.RegisterModule(Module, {}, {}, true, MinimapModule)

function frame:OnEvent(event, arg1)
    if event == 'ADDON_LOADED' and arg1 == 'Blizzard_TimeManager' then
        --print('Blizzard_TimeManager')
        ChangeClock()
        HookCalendar()
        UpdateCalendar()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)
