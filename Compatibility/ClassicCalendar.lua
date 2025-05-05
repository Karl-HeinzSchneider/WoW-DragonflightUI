local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

function DF.Compatibility:ClassicCalendarEra()
    -- print('DF.Compatibility:ClassicCalendarEra()')

    local btn = _G['CalendarButtonFrame']
    btn:ClearAllPoints()
    btn:SetPoint('BOTTOMLEFT', UIParent, 'TOPRIGHT', 69, 69)
    btn:Hide()

    local frame = _G['CalendarFrame']
    local DFBtn = _G['DragonflightUICalendarButton']

    DFBtn:SetScript('OnClick', function()
        -- print('override!')
        CalendarButtonFrame_OnClick(btn)
    end)
end
