local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

function DF.Compatibility:LFGBulletinBoard(func)
    -- related issues: #235, Vysci/LFG-Bulletin-Board#301
    local btn = _G['LFGBulletinBoardMinimapButton'] or _G['Lib_GPI_Minimap_LFGBulletinBoard']
    if not btn then return end
    func(btn)
end
