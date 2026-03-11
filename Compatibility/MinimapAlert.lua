local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

local DFMinimapBaseName = 'DragonflightUIMinimapBase'

function DF.Compatibility:MinimapAlert()
    if not DF:IsAddOnLoaded('Minimap_Alert') then return end
    if not Minimap or not MinimapCluster or Minimap.DF_FixedSetPointForAlerts then
        return
    end

    Minimap.DF_FixedSetPointForAlerts = true

    local dfBase = nil
    local scanning = false

    -- Prevent DF from re-parenting the Minimap.
    -- Re-parenting permanently breaks the engine's internal tracking-icon
    -- tooltip detection that Minimap Alert relies on for node scanning.
    local oldSetParent = Minimap.SetParent
    Minimap.SetParent = function(frame, parent)
        if frame == Minimap and parent and parent.GetName
           and parent:GetName() == DFMinimapBaseName then
            dfBase = parent
            return
        end
        return oldSetParent(frame, parent)
    end

    -- Sync Minimap scale with BaseFrame; suppressed while MMA is scanning.
    local function syncFromBase()
        if scanning or not dfBase then return end
        Minimap:SetScale(dfBase:GetScale())
    end

    -- Track scanning state (MMA uses scale < 0.5 during its scan cycle)
    local oldSetScale = Minimap.SetScale
    Minimap.SetScale = function(frame, scale)
        if frame == Minimap and scale then
            scanning = scale < 0.5
        end
        return oldSetScale(frame, scale)
    end

    -- Deferred setup: BaseFrame may not exist yet when this runs
    C_Timer.After(0, function()
        if not dfBase then
            dfBase = _G[DFMinimapBaseName]
        end
        if dfBase then
            hooksecurefunc(dfBase, 'SetScale', syncFromBase)
            dfBase:HookScript('OnShow', function()
                if not scanning then Minimap:Show() end
            end)
            dfBase:HookScript('OnHide', function()
                if not scanning then Minimap:Hide() end
            end)
            syncFromBase()
        end
    end)
end
