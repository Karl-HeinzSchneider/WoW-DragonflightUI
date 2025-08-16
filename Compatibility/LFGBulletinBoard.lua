local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

function DF.Compatibility:LFGBulletinBoard()
    -- related issues: #235, Vysci/LFG-Bulletin-Board#301
    -- local btn = _G['LFGBulletinBoardMinimapButton'] or _G['Lib_GPI_Minimap_LFGBulletinBoard']
    -- if not btn then return end

    -- local minimapModule = DF:GetModule('Minimap')
    -- minimapModule.SubMinimap:UpdateButton(btn);

    -- local darkmodeModule = DF:GetModule('Darkmode')
    -- hooksecurefunc(darkmodeModule, 'UpdateMinimap', function()
    --     darkmodeModule:UpdateMinimapButton(btn)
    -- end)
end
