local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

function DF.Compatibility:Pawn()
    -- print('DF.Compatibility:Pawn()');
    local btn = _G['PawnUI_InventoryPawnButton']
    if not btn then return end

    local moveLeft = function()
        btn:ClearAllPoints()
        btn:SetPoint("TOPLEFT", "CharacterWristSlot", "BOTTOMLEFT", 1, -8)
        -- btn:Show()
    end

    local moveBtn = function()
        if PawnCommon then
            if PawnCommon.ButtonPosition == PawnButtonPositionRight then moveLeft() end
        else
            moveLeft()
        end
    end
    moveBtn()

    if PawnUI_InventoryPawnButton_Move then
        hooksecurefunc('PawnUI_InventoryPawnButton_Move', function()
            moveBtn()
        end)
    end
end

