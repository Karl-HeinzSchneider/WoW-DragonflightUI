local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

function DF.Compatibility:AuctionatorCraftingInfoFrame()
    -- print('DF.Compatibility:AuctionatorCraftingInfoFrame()')

    hooksecurefunc(Auctionator.CraftingInfo, 'Initialize', function()
        --
        -- print('Auctionator.CraftingInfo:Initialize()')

        local auctionCraftingFrame = _G['AuctionatorCraftingInfo']
        local craftSearchButton = auctionCraftingFrame.SearchButton

        if not auctionCraftingFrame then
            -- print('no frame!')
            return
        end

        if auctionCraftingFrame.DFHooked == true then return end
        auctionCraftingFrame.DFHooked = true

        local prof = _G['DragonflightUIProfessionFrame']
        local extra = prof.SchematicForm.ExtraDataFrame

        local fixFrameCraft = function()
            -- print('fixFrameCraft')

            -- "craft" e.g. tradeskills
            auctionCraftingFrame:SetParent(prof)
            auctionCraftingFrame:ClearAllPoints()
            auctionCraftingFrame:SetPoint('TOPLEFT', extra, 'TOPLEFT', 0, 0)

            -- craftSearchButton:SetParent(prof)
            -- craftSearchButton:ClearAllPoints()
            -- craftSearchButton:SetPoint('TOPLEFT', auctionCraftingFrame, 'TOPLEFT', 205, 6)
            -- -- searchButton:Show()
            -- -- print(searchButton:GetPoint(1))
            -- craftSearchButton:SetScript('OnClick', function()
            --     --
            --     auctionCraftingFrame:SearchButtonClicked()
            -- end)

            -- extra
            local newH = auctionCraftingFrame:GetHeight() + 0.01
            extra:SetHeight(newH)
        end
        fixFrameCraft()

        hooksecurefunc(auctionCraftingFrame, 'ShowIfRelevant', function()
            --
            -- print('ShowIfRelevant')
            fixFrameCraft()
        end)
        hooksecurefunc(auctionCraftingFrame, 'UpdateTotal', function()
            --
            -- print('UpdateTotal')
            fixFrameCraft()
        end)
        hooksecurefunc(auctionCraftingFrame, 'AdjustPosition', function()
            --
            -- print('UpdateTotal')
            fixFrameCraft()
        end)
        prof:HookScript('OnEvent', function()
            --
            -- print('OnShow')     
            if prof.TradeSkillOpen then
                fixFrameCraft()
                auctionCraftingFrame:Show()
            else
                auctionCraftingFrame:Hide()
            end
        end)
    end)

    if DF.Era then
        hooksecurefunc(Auctionator.EnchantInfo, 'Initialize', function()
            --
            -- print('Auctionator.CraftingInfo:Initialize()')

            local enchantFrame = _G['AuctionatorEnchantInfoFrame']
            local enchantSearchButton = enchantFrame.SearchButton

            if not enchantFrame then
                -- print('no frame!')
                return
            end

            if enchantFrame.DFHooked == true then return end
            enchantFrame.DFHooked = true

            local prof = _G['DragonflightUIProfessionFrame']
            local extra = prof.SchematicForm.ExtraDataFrame

            local fixFrameEnchant = function()
                -- print('fixFrameEnchant')

                enchantFrame:SetParent(prof)
                enchantFrame:ClearAllPoints()
                enchantFrame:SetPoint('TOPLEFT', extra, 'TOPLEFT', 0, 0)

                -- enchantSearchButton:SetParent(prof)
                -- enchantSearchButton:ClearAllPoints()
                -- enchantSearchButton:SetPoint('TOPLEFT', enchantFrame, 'TOPLEFT', 205, 6)
                -- -- searchButton:Show()
                -- -- print(searchButton:GetPoint(1))
                -- enchantSearchButton:SetScript('OnClick', function()
                --     --
                --     enchantFrame:SearchButtonClicked()
                -- end)

                -- extra
                local newH = enchantFrame:GetHeight() + 0.01
                extra:SetHeight(newH)
            end
            fixFrameEnchant()

            hooksecurefunc(enchantFrame, 'ShowIfRelevant', function()
                --
                -- print('ShowIfRelevant')
                fixFrameEnchant()
            end)
            hooksecurefunc(enchantFrame, 'UpdateTotal', function()
                --
                -- print('UpdateTotal')
                fixFrameEnchant()
            end)
            -- hooksecurefunc(enchantFrame, 'AdjustPosition', function()
            --     --
            --     -- print('UpdateTotal')
            --     fixFrameEnchant()
            -- end)
            prof:HookScript('OnEvent', function()
                --
                -- print('OnShow')     
                if prof.CraftOpen then
                    fixFrameEnchant()
                    enchantFrame:Show()
                else
                    enchantFrame:Hide()
                end
            end)
        end)
    end
end
