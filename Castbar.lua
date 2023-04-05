local Addon, Core = ...
local Module = 'Castbar'

local noop = function()
end

local frame = CreateFrame('FRAME', 'DragonflightUICastbarFrame', UIParent)

function ChangeCastbar()
    --print('ChangeCastbar')
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    CastingBarFrame:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 500)
end

function CastbarModule()
    frame:RegisterEvent('PLAYER_ENTERING_WORLD')

    frame:RegisterEvent('UNIT_SPELLCAST_INTERRUPTED')
    frame:RegisterEvent('UNIT_SPELLCAST_DELAYED')
    frame:RegisterEvent('UNIT_SPELLCAST_CHANNEL_START')
    frame:RegisterEvent('UNIT_SPELLCAST_CHANNEL_UPDATE')
    frame:RegisterEvent('UNIT_SPELLCAST_CHANNEL_STOP')

    frame:RegisterUnitEvent('UNIT_SPELLCAST_START', 'PLAYER')
    frame:RegisterUnitEvent('UNIT_SPELLCAST_STOP', 'PLAYER')
    frame:RegisterUnitEvent('UNIT_SPELLCAST_FAILED', 'PLAYER')
    print('CASTBAR MODULE')
    ChangeCastbar()
end

Core.RegisterModule(Module, {}, {}, false, CastbarModule)

function frame:OnEvent(event, arg1)
    --print('event', event, arg1)
    if event == 'PLAYER_ENTERING_WORLD' then
        ChangeCastbar()
    else
        ChangeCastbar()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)
