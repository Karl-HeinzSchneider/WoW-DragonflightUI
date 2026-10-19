local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

-- On 1.15.9 the client's per-frame script limiter kills Questie's init
-- coroutine during the database compile, so EventHandler:RegisterLateEvents()
-- never runs and QuestiePlayer.numberOfGroupMembers stays 0 forever. Every
-- raid-size safety in Questie keys off that counter (tooltip early-outs at
-- >6 members, comms shutoff at >15, yell throttle at >4) - all silently
-- disabled exactly when a raid needs them. The result is party-objective
-- packets grinding the uncompiled database with raw stream decodes mid-raid:
-- the "hovering raid members causes frame skips" reports.
--
-- Keep the counter honest ourselves while Questie is loaded but never
-- finished init. The moment Questie.started goes true its own
-- GroupEventHandler owns the value and this watcher stands down for good.
function DF.Compatibility:Questie()
    if DF.Compatibility.QuestieGroupCountWatcher then return end

    local function update()
        if not (Questie and QuestieLoader and QuestieLoader.ImportModule) then return end
        if Questie.started then return true end
        pcall(function()
            local QuestiePlayer = QuestieLoader:ImportModule('QuestiePlayer')
            if QuestiePlayer and QuestiePlayer.numberOfGroupMembers ~= nil then
                QuestiePlayer.numberOfGroupMembers = GetNumGroupMembers() or 0
            end
        end)
    end

    local watcher = CreateFrame('Frame')
    DF.Compatibility.QuestieGroupCountWatcher = watcher
    watcher:RegisterEvent('PLAYER_ENTERING_WORLD')
    watcher:RegisterEvent('GROUP_ROSTER_UPDATE')
    watcher:SetScript('OnEvent', function(self)
        if update() then self:UnregisterAllEvents() end
    end)
    update()
end
