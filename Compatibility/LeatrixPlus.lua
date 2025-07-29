local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

local _, _, _, origX, origY = TargetFrameNameBackground:GetPoint(1)

function DF.Compatibility:LeatrixPlus()
    -- print('DF.Compatibility:LeatrixPlus()')
    -- print('orig', origX, origY)

    local fixPlayerNameBackground = function()
        local _, _, _, x, y = TargetFrameNameBackground:GetPoint(1)

        local children = {PlayerFrame:GetChildren()}

        for k, child in ipairs(children) do
            --

            if not child:GetName() then
                -- namebackground has name nil
                -- print(k, child:GetObjectType())

                local point, relativeTo, relativePoint, xOfs, yOfs = child:GetPoint(1)
                local point2 = child:GetPoint(2)

                -- print(child:GetPoint(1))
                -- print(child:GetPoint(2))

                if (not point2) and (point == 'TOPLEFT') and (relativeTo == PlayerFrame) and
                    (relativePoint == 'TOPLEFT') then
                    --
                    -- print('2nd')
                    -- local _, _, _, x, y = TargetFrameNameBackground:GetPoint(1) -- leatrix
                    -- print(xOfs, yOfs, origX, origY)
                    -- print(xOfs == -origX)
                    -- print(yOfs == origY)

                    if ((xOfs == -origX) and (yOfs == origY)) or ((xOfs == -x) and (yOfs == y)) then
                        -- should be leatrix
                        -- print('leatrix?')
                        local regions = {child:GetRegions()}

                        for i, cr in ipairs(regions) do
                            if cr:GetObjectType() == 'Texture' then

                                local drawlayer, level = cr:GetDrawLayer()
                                -- print(drawlayer, level)
                                if drawlayer == 'BORDER' and level == 0 then
                                    -- should be namebackground
                                    -- print('leatrix found!')
                                    cr:Hide()
                                end
                            end
                        end
                    end

                end
            end
        end
    end

    C_Timer.After(0, fixPlayerNameBackground)
    -- fixPlayerNameBackground()
end
