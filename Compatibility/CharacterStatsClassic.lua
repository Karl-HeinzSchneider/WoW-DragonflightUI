local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

function DF.Compatibility:CharacterStatsClassic()
    -- print('DF.Compatibility:CharacterStatsClassic()')
    local children = {CharacterFrame:GetChildren()}

    for k, child in ipairs(children) do
        --
        -- print('children:', k, child:GetName())

        if child:GetName() == nil then
            -- maybe CharacterStatsClassic
            --[[        local point, relativeTo, relativePoint, xOfs, yOfs = child:GetPoint(1)
            print(point, relativeTo, relativePoint, xOfs, yOfs)
            if (point == 'LEFT') and (relativeTo == CharacterFrame) and (relativePoint == 'BOTTOMLEFT') and
                (xOfs == 50) and (yOfs == 75) then
                --
                print('CharacterStatsClassic found!')
            end ]]
            if (child.leftStatsDropDown) and (child.rightStatsDropDown) then
                --
                -- print('CharacterStatsClassic found by dropdown')
                -- SetPoint("LEFT", CharacterFrame, "BOTTOMLEFT", 50, 75); --85 for 6 stats
                child:SetPoint('LEFT', CharacterFrame, 'BOTTOMLEFT', 50 - 15, 75 - 80)
            end
        end
    end
end
