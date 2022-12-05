print('Micromenu.lua')

local frame = CreateFrame('FRAME')

function ChangeGryphon()
end
ChangeGryphon()

function ChangeMicroMenu()
    SpellbookMicroButton:SetSize(19, 26)
    SpellbookMicroButton:SetScale(1.5)
    SpellbookMicroButton:SetHitRectInsets(0, 0, 0, 0)

    SpellbookMicroButton:SetNormalTexture('Interface\\Addons\\DragonflightUI\\Textures\\uimicromenu2x')
    SpellbookMicroButton:GetNormalTexture():SetTexCoord(0.47265625, 0.62109375, 0.107421875, 0.208984375)

    SpellbookMicroButton:SetPushedTexture('Interface\\Addons\\DragonflightUI\\Textures\\uimicromenu2x')
    SpellbookMicroButton:GetPushedTexture():SetTexCoord(0.47265625, 0.62109375, 0.107421875, 0.208984375)

    SpellbookMicroButton:SetDisabledTexture('Interface\\Addons\\DragonflightUI\\Textures\\uimicromenu2x')
    SpellbookMicroButton:GetDisabledTexture():SetTexCoord(0.47265625, 0.62109375, 0.107421875, 0.208984375)
    --SpellbookMicroButton:GetDisabledTexture():SetDesaturated(1)

    SpellbookMicroButton:SetHighlightTexture('Interface\\Addons\\DragonflightUI\\Textures\\uimicromenu2x')
    SpellbookMicroButton:GetHighlightTexture():SetTexCoord(0.47265625, 0.62109375, 0.107421875, 0.208984375)
end
ChangeMicroMenu()

-- Events
frame:RegisterEvent('ADDON_LOADED')

function frame:OnEvent(event, arg1)
    if IsAddOnLoaded('Bartender4') then
        print('bar4 loaded')
        ChangeGryphon()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)

print('Micromenu.lua - END')
