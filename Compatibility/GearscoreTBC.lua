local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

function DF.Compatibility:GearscoreCharacter()
    -- print('DF.Compatibility:GearscoreCharacter()')
    local f = CharacterModelFrame or CharacterModelScene
    local display = _G['GearScoreDisplay']
    if not f or not display then return end
    display:ClearAllPoints()
    display:SetPoint('BOTTOMLEFT', f, 'BOTTOMLEFT', 10 + 2, 30 - 16)
end

function DF.Compatibility:GearscoreInspect()
    local f = InspectModelFrame
    local display = _G['InspectGearScoreDisplay']
    if not f or not display then return end
    display:ClearAllPoints()
    display:SetPoint('BOTTOMLEFT', f, 'BOTTOMLEFT', 10 + 2, 30 - 16)
end
