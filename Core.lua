-- Vars

local colorTable = {
    ['yellow'] = '|c00ffff00',
    ['green'] = '|c0000ff00',
    ['orange'] = '|c00ffc400',
    ['red'] = '|c00ff0000'
}

-- Frame

local frame = CreateFrame('FRAME')
frame:RegisterEvent('ADDON_LOADED')

function frame:OnEvent(event, arg1)
    if event == 'ADDON_LOADED' and arg1 == 'DragonflightUI' then
        local version = GetAddOnMetadata('DragonflightUI', 'Version')
        print('Dragonflight UI Loaded!')
    end
end
frame:SetScript('OnEvent', frame.OnEvent)
