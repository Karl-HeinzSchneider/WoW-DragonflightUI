local Addon, Core = ...
local Module = 'Chat'

local frame = CreateFrame('FRAME', 'DragonflightUIChatFrame', UIParent)

function ChatModule()
    ChangeSizeAndPosition()

    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
end

function ChangeSizeAndPosition()
    ChatFrame1:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 42, 35)
    ChatFrame1:SetSize(420, 200)
end

Core.RegisterModule(Module, {}, {}, false, ChatModule)

function frame:OnEvent(event, arg1)
    --print('event', event)
    if event == 'PLAYER_ENTERING_WORLD' then
        ChangeSizeAndPosition()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)
