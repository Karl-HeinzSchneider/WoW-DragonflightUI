local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

function DF.Compatibility:ClassicRanker()
    --
    -- print('DF.Compatibility:ClassicRanker()')

    local modify = function()
        local mf = _G['RankerMainFrame']
        -- mf:SetPoint('LEFT', HonorFrame, 'RIGHT', -30, 30.5) -- default
        if not mf then return end
        mf:SetPoint('LEFT', HonorFrame, 'RIGHT', 16, 30.5)

        local tb = _G['RankerToggleButton']
        if not tb then return end
        -- tb:SetPoint('TOPRIGHT', HonorFrame, 'TOPRIGHT', -32, 8) -- default
        tb:SetPoint('TOPRIGHT', HonorFrame, 'TOPRIGHT', 15, 9)
    end

    local mf = _G['RankerMainFrame']
    if mf then
        modify()
    else
        -- print('~not mf')

        hooksecurefunc(Ranker, 'CreateUserInterface', function()
            --
            -- print('~~CreateUserInterface')
            modify()
        end)
    end
end
