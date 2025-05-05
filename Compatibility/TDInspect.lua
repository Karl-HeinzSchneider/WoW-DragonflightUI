local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

function DF.Compatibility:TDInspect()
    -- print('DF.Compatibility:TDInspect()')
    local tdinspect = LibStub('AceAddon-3.0'):GetAddon('tdInspect', true)

    if (tdinspect and tdinspect.SetupGearParent and tdinspect.CharacterGearParent) then
        local function updatePosition()
            if not tdinspect.CharacterGearParent then return end
            tdinspect.CharacterGearParent:ClearAllPoints()
            tdinspect.CharacterGearParent:SetPoint('TOPLEFT', PaperDollFrame, 'TOPRIGHT', 0, 0)
        end

        hooksecurefunc(tdinspect, 'SetupGearParent', updatePosition)
        updatePosition()
    end
end
