local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
DF.Compatibility = {}

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
