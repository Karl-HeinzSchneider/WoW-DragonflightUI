local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

function DF.Compatibility:TacoTipCharacter()
    local text = _G['PersonalGearScoreText']
    text:ClearAllPoints()
    text:SetPoint('BOTTOMLEFT', CharacterModelFrame, 'BOTTOMLEFT', 10, 30)

    local score = _G['PersonalGearScore']
    score:ClearAllPoints()
    score:SetPoint('BOTTOMLEFT', text, 'TOPLEFT', 0, 2)

    local itemlvltext = _G['PersonalAvgItemLvlText']
    itemlvltext:ClearAllPoints()
    itemlvltext:SetPoint('BOTTOMRIGHT', CharacterModelFrame, 'BOTTOMRIGHT', -10, 30)

    local itemlvl = _G['PersonalAvgItemLvl']
    itemlvl:ClearAllPoints()
    itemlvl:SetPoint('BOTTOMRIGHT', itemlvltext, 'TOPRIGHT', 0, 2)
end

function DF.Compatibility:TacoTipInspect()
    local text = _G['InspectGearScoreText']
    if text ~= nil then
        text:ClearAllPoints()
        text:SetPoint('BOTTOMLEFT', InspectModelFrame, 'BOTTOMLEFT', 10, 30)
    end

    local score = _G['InspectGearScore']
    if score ~= nil then
        score:ClearAllPoints()
        score:SetPoint('BOTTOMLEFT', text, 'TOPLEFT', 0, 2)
    end

    local itemlvltext = _G['InspectAvgItemLvlText']
    if itemlvltext ~= nil then
        itemlvltext:ClearAllPoints()
        itemlvltext:SetPoint('BOTTOMRIGHT', InspectModelFrame, 'BOTTOMRIGHT', -10, 30)
    end

    local itemlvl = _G['InspectAvgItemLvl']
    if itemlvl ~= nil then
        itemlvl:ClearAllPoints()
        itemlvl:SetPoint('BOTTOMRIGHT', itemlvltext, 'TOPRIGHT', 0, 2)
    end
end
