local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

function DF.Compatibility:MerInspectClassicEra()
    -- print('DF.Compatibility:MerInspectClassicEra()');
    if not ShowInspectItemListFrame then return end
    hooksecurefunc("ShowInspectItemListFrame", function(unit, parent, ilevel, maxLevel)
        -- print('ShowInspectItemListFrame: ', unit, parent:GetName(), ilevel, maxLevel);
        local inspectRef = parent.inspectFrame;
        if not inspectRef then return end

        inspectRef:ClearAllPoints();
        inspectRef:SetMovable(false);
        inspectRef:RegisterForDrag();
        inspectRef:SetPoint('TOPLEFT', parent, 'TOPRIGHT', 0, 0);
    end)
end

function DF.Compatibility:MerInspect()
    -- print('DF.Compatibility:MerInspect()')
    if not ShowInspectItemListFrame then return end
    hooksecurefunc("ShowInspectItemListFrame", function(unit, parent, ilevel, maxLevel)
        -- print('ShowInspectItemListFrame: ', unit, parent:GetName(), ilevel, maxLevel);
        local inspectRef = parent.inspectFrame;
        if not inspectRef then return end

        inspectRef:ClearAllPoints();
        inspectRef:SetMovable(false);
        inspectRef:RegisterForDrag();
        inspectRef:SetPoint('TOPLEFT', parent, 'TOPRIGHT', 0, 0);
    end)
end
