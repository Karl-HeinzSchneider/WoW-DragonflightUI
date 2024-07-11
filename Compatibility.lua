local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
DF.Compatibility = {}

function DF.Compatibility:FuncOrWaitframe(addon, func)
    local checkAddonFunc = C_AddOns.IsAddOnLoaded or IsAddOnLoaded
    if checkAddonFunc(addon) then
        -- print('Module:FuncOrWaitframe(addon,func)', addon, 'ISLOADED')
        func()
    else
        local waitFrame = CreateFrame("FRAME")
        waitFrame:RegisterEvent("ADDON_LOADED")
        waitFrame:SetScript("OnEvent", function(self, event, arg1)
            if arg1 == addon then
                -- print('Module:FuncOrWaitframe(addon,func)', addon, 'WAITFRAME')
                func()
                waitFrame:UnregisterAllEvents()
            end
        end)
    end
end

local novaLoaded = IsAddOnLoaded('NovaWorldBuffs')
-- print('Nova loaded: ', novaLoaded)
if novaLoaded then if _G['MinimapLayerFrame'] then _G['MinimapLayerFrame']:SetPoint('BOTTOM', 0, 4) end end

function DF.Compatibility:AuctionatorCraftingInfoFrame()
    -- print('DF.Compatibility:AuctionatorCraftingInfoFrame()')

    hooksecurefunc(Auctionator.CraftingInfo, 'Initialize', function()
        --
        -- print('Auctionator.CraftingInfo:Initialize()')

        local auctionCraftingFrame = _G['AuctionatorCraftingInfo']
        if not auctionCraftingFrame then
            -- print('no frame!')
            return
        end

        if auctionCraftingFrame.DFHooked == true then return end
        auctionCraftingFrame.DFHooked = true

        local prof = _G['DragonflightUIProfessionFrame']
        auctionCraftingFrame:SetParent(prof)

        local fixFrame = function()
            -- print('fixFrame')
            local first = TradeSkillDescription or TradeSkillReagentLabel

            auctionCraftingFrame:ClearAllPoints()
            auctionCraftingFrame:SetPoint('TOPLEFT', TradeSkillSkillIcon, 'BOTTOMLEFT', -1, -12)

            first:ClearAllPoints()
            first:SetPoint('TOPLEFT', TradeSkillSkillIcon, 'BOTTOMLEFT', -1, -48)
        end

        hooksecurefunc(auctionCraftingFrame, 'ShowIfRelevant', function()
            --
            -- print('ShowIfRelevant')
            fixFrame()
        end)
        hooksecurefunc(auctionCraftingFrame, 'UpdateTotal', function()
            --
            -- print('UpdateTotal')
            fixFrame()
        end)
        prof:HookScript('OnShow', function()
            --
            -- print('OnShow')
            fixFrame()
        end)
        fixFrame()
    end)
end

if DF.Era then
    function DF.Compatibility:ClassicCalendarEra()
        -- print('DF.Compatibility:ClassicCalendarEra()')

        local btn = _G['CalendarButtonFrame']
        btn:ClearAllPoints()
        btn:SetPoint('BOTTOMLEFT', UIParent, 'TOPRIGHT', 69, 69)
        btn:Hide()

        local frame = _G['CalendarFrame']
        local DFBtn = _G['DragonflightUICalendarButton']

        DFBtn:SetScript('OnClick', function()
            -- print('override!')
            CalendarButtonFrame_OnClick(btn)
        end)
    end
end
