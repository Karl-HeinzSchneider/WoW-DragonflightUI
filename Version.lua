---@class DragonflightUI
---@diagnostic disable-next-line: assign-type-mismatch
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

local DFPrefix = 'DragonflightUI'
local DFPlayer = UnitName('player')

local DFTimestamp = C_AddOns.GetAddOnMetadata('DragonflightUI', 'X-Date')
local newerVersionFound = false

function DF:InitVersionCheck()
    --  DF:Print('DF:InitVersionCheck()---------------')
    DF:RegisterComm(DFPrefix)

    -- DF:SendCommMessage(DFPrefix, 'TESTSSS', "WHISPER", UnitName("player"))
end

function DF:OnCommReceived(prefix, payload, distribution, sender)
    if prefix ~= DFPrefix or sender == DFPlayer then return end
    -- print('OnCommReceived:', prefix, payload, distribution, sender)

    if payload == 'GIV VERSION' then
        --
        DF:SendCommMessage(DFPrefix, 'DFTimestamp:' .. DFTimestamp, distribution, sender)
        return
    end

    local k, v = strsplit(':', payload, 2)
    if k == 'DFTimestamp' then
        --   print('DFTimestamp', v)
        if v > DFTimestamp and not newerVersionFound then
            --
            newerVersionFound = true
        end
    end
end
