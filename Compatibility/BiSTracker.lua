local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

function DF.Compatibility:BiSTracker()
    -- print('DF.Compatibility:BiSTracker()');
    if not BiSTracker and not BiSTracker.db.profile.mainframe then return end

    local fixedX = -6;
    local fixedY = -26;

    local override = function()
        if not BiSTracker.db.profile.mainframe.connectedToCharacterFrame then return; end

        -- BiSTracker.MainFrame.characterFrameToggle:SetScale(0.8)
        BiSTracker.MainFrame.characterFrameToggle:SetPoint("TOPRIGHT", CharacterFrame, "TOPRIGHT", fixedX, fixedY, true)
    end

    if not BiSTracker.MainFrame.characterFrameToggle then return end

    hooksecurefunc(BiSTracker.MainFrame.characterFrameToggle, 'SetPoint',
                   function(btn, point, relativeFrame, relativePoint, ofsx, ofsy, isOverride)
        if isOverride or not btn:IsVisible() then return end

        -- print('SetPoint', point, relativeFrame, relativePoint, ofsx, ofsy)
        override()
    end)
    override()

    BiSTracker.MainFrame:SetPoint("TOPLEFT", CharacterFrame, "TOPRIGHT", 0, 0)
end

