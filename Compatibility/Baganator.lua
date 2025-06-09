local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

function DF.Compatibility:Baganator()
    -- print('DF.Compatibility:Baganator()')

    local function ConvertTags(tags)
        local res = {}
        for _, tag in ipairs(tags) do res[tag] = true end
        return res
    end

    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

    local skinners = {
        ItemButton = function(frame)
            if frame.SlotBackground then
                -- frame.SlotBackground:SetAlpha(0.5)
                local bg = frame.SlotBackground
                bg:SetTexture(base .. 'BagsItemSlot2x')
                bg:SetSize(37, 37)
                -- bg:SetPoint('CENTER', 0, 0)
                -- bg:SetDrawLayer('BACKGROUND', 3)
            end

            -- if frame:GetNormalTexture() then
            --     local normal = frame:GetNormalTexture()
            --     normal:SetTexture(base .. 'BagsItemSlot2x')
            --     normal:SetSize(37, 37)
            --     normal:SetPoint('CENTER', 0, 0)
            --     normal:SetDrawLayer('BACKGROUND', 3)
            -- end

            -- if frame:GetPushedTexture() then
            --     local pushed = frame:GetPushedTexture()
            --     pushed:SetTexture(base .. 'ui-quickslot-depress')
            --     pushed:SetSize(37, 37)
            --     pushed:SetPoint('CENTER', 0, 0)
            -- end

            -- if frame:GetHighlightTexture() then
            --     local high = frame:GetHighlightTexture()
            --     high:SetTexture(base .. 'buttonhilight-square')
            --     -- high:SetTexCoord(0.408203, 0.478516, 0.679688, 0.820312)
            --     high:SetSize(37, 37)
            --     high:SetPoint('CENTER', 0, 0)
            --     -- high:SetDrawLayer('BACKGROUND', 3)
            -- end

            -- local iconBorder = frame.IconBorder
            -- iconBorder:Hide()

            -- if not frame.DFBorder then
            --     local border = frame:CreateTexture('DragonflightUIBorder')
            --     border:SetTexture(base .. 'ui-quickslot2')
            --     border:SetSize(64, 64)
            --     border:SetPoint('CENTER', 0, -1)
            --     border:SetDrawLayer('BACKGROUND', 4)
            --     frame.DFBorder = border
            -- end
        end,
        IconButton = function(button, tags)
            if tags.sort then
                -- do something
            elseif tags.bank then
                -- do something
            elseif tags.guildBank then
                -- do something
            elseif tags.allCharacters then
                -- do something
            elseif tags.customise then
                -- do something
            elseif tags.bagSlots then
                -- do something
            else
                -- generic
            end
        end,
        Button = function(frame)
        end,
        ButtonFrame = function(frame, tags)
            if tags.backpack then
                -- do something
            elseif tags.bank then
                -- do something
            elseif tags.guild then
                -- do something
            else
                -- generic
            end

            -- corner
            do
                local tex = base .. 'uiframemetal2x'

                local tlc = frame.TopLeftCorner
                tlc:SetTexture(tex)
                tlc:SetTexCoord(0.00195312, 0.294922, 0.00195312, 0.294922)
                tlc:SetSize(75, 74)
                tlc:SetPoint('TOPLEFT', -12, 16)

                local trc = frame.TopRightCorner
                trc:SetTexture(tex)
                trc:SetTexCoord(0.298828, 0.591797, 0.00195312, 0.294922)
                trc:SetSize(75, 74)
                trc:SetPoint('TOPRIGHT', 4, 16)

                local blc = frame.BotLeftCorner
                blc:SetTexture(tex)
                blc:SetTexCoord(0.298828, 0.423828, 0.298828, 0.423828)
                blc:SetSize(32, 32)
                blc:SetPoint('BOTTOMLEFT', -12, -3)

                local brc = frame.BotRightCorner
                brc:SetTexture(tex)
                brc:SetTexCoord(0.427734, 0.552734, 0.298828, 0.423828)
                brc:SetSize(32, 32)
                brc:SetPoint('BOTTOMRIGHT', 4, -3)
            end

            -- edge bottom/top
            do
                local tex = base .. 'UIFrameMetalHorizontal2x'

                local te = frame.TopBorder
                te:SetTexture(tex)
                te:SetTexCoord(0, 1, 0.00390625, 0.589844)
                te:SetSize(32, 74)
                te:SetPoint('TOPLEFT', frame.TopLeftCorner, 'TOPRIGHT', 0, 0)
                te:SetPoint('TOPRIGHT', frame.TopRightCorner, 'TOPLEFT', 0, 0)

                local be = frame.BottomBorder
                be:SetTexture(tex)
                be:SetTexCoord(0, 0.5, 0.597656, 0.847656)
                be:SetSize(16, 32)
                be:SetPoint('TOPLEFT', frame.BotLeftCorner, 'TOPRIGHT', 0, 0)
                be:SetPoint('TOPRIGHT', frame.BotRightCorner, 'TOPLEFT', 0, 0)
            end

            -- edge left/right
            do
                local tex = base .. 'UIFrameMetalVertical2x'

                local le = frame.LeftBorder
                le:SetTexture(tex)
                le:SetTexCoord(0.00195312, 0.294922, 0, 1)
                le:SetSize(75, 16)
                le:SetPoint('TOPLEFT', frame.TopLeftCorner, 'BOTTOMLEFT', 0, 0)
                le:SetPoint('BOTTOMLEFT', frame.BotLeftCorner, 'TOPLEFT', 0, 0)

                local re = frame.RightBorder
                re:SetTexture(tex)
                re:SetTexCoord(0.298828, 0.591797, 0, 1)
                re:SetSize(75, 16)
                re:SetPoint('TOPRIGHT', frame.TopRightCorner, 'BOTTOMRIGHT', 0, 0)
                re:SetPoint('BOTTOMRIGHT', frame.BotRightCorner, 'TOPRIGHT', 0, 0)
            end

            -- DevTools_Dump(frame.CloseButton)

            local closeBtn = frame.CloseButton
            if closeBtn then
                DragonflightUIMixin:UIPanelCloseButton(closeBtn)
                closeBtn:SetPoint('TOPRIGHT', 1, 0)
            end

            -- bg
            -- frame.Bg:SetAlpha(1)

            local bg = frame.Bg
            bg:SetTexture(base .. 'ui-background-rock')
            -- top:ClearAllPoints()
            -- -- top:SetPoint('TOPLEFT', frame.Bg, 'TOPLEFT', 0, 0)
            -- -- top:SetPoint('BOTTOMRIGHT', frame.Bg.BottomRight, 'BOTTOMRIGHT', 0, 0)
            -- top:SetDrawLayer('BACKGROUND', 2)

        end,
        SearchBox = function(frame)
        end,
        EditBox = function(frame)
        end,
        TabButton = function(frame)
        end,
        TopTabButton = function(frame)
        end,
        SideTabButton = function(frame)
        end,
        TrimScrollBar = function(frame)
        end,
        CheckBox = function(frame)
        end,
        Slider = function(frame)
        end,
        InsetFrame = function(frame)
        end,
        Divider = function(tex)
            tex:SetAlpha(0)

            if tex.DF then return end

            local customTex = tex:GetParent():CreateTexture('DividerDF')
            customTex:SetTexCoord(0, 1, 0, 1)
            customTex:SetTexture(base .. 'activities-divider')

            -- customTex:ClearAllPoints()
            -- customTex:SetPoint("TOPLEFT", tex,'TOPLEFT', 0, 0)
            -- customTex:SetPoint("BOTTOMRIGHT",tex,'BOTTOMRIGHT', 0, 0)
            customTex:SetHeight(2)
            customTex:SetPoint("CENTER", tex, 'CENTER', 0, 0)

            tex.DF = customTex;
        end,
        CategoryLabel = function(btn)
        end,
        CategorySectionHeader = function(btn)
        end,
        CornerWidget = function(frame, tags)
            -- Example widget
            if frame:IsObjectType("FontString") then
                -- modify the scale/font size
            end
        end,
        DropDownWithPopout = function(button)
        end
    }

    local function SkinFrame(details)
        if Baganator.API.Skins.GetCurrentSkin() ~= 'blizzard' then return end
        -- print('~~~~~SKINFRAME', details.regionType)
        local func = skinners[details.regionType]
        if func then func(details.region, details.tags and ConvertTags(details.tags) or {}) end
    end

    Baganator.API.Skins.RegisterListener(SkinFrame)

    for _, details in ipairs(Baganator.API.Skins.GetAllFrames()) do SkinFrame(details) end

end

function DF.Compatibility:BaganatorEquipment()
    -- print('DF.Compatibility:BaganatorEquipment()')
    if not DF.API.Version.IsClassic or not Syndicator then return end

    local EquipmentManager_UnpackLocation = EquipmentManager_UnpackLocation or
                                                function(location) -- Use me, I'm here to be used.
            if (location < 0) then -- Thanks Seerah!
                return false, false, false, 0;
            end

            local player = (bit.band(location, ITEM_INVENTORY_LOCATION_PLAYER) ~= 0);
            local bank = (bit.band(location, ITEM_INVENTORY_LOCATION_BANK) ~= 0);
            local bags = (bit.band(location, ITEM_INVENTORY_LOCATION_BAGS) ~= 0);

            if (player) then
                location = location - ITEM_INVENTORY_LOCATION_PLAYER;
            elseif (bank) then
                location = location - ITEM_INVENTORY_LOCATION_BANK;
            end

            if (bags) then
                location = location - ITEM_INVENTORY_LOCATION_BAGS;
                local bag = bit.rshift(location, ITEM_INVENTORY_BAG_BIT_OFFSET);
                local slot = location - bit.lshift(bag, ITEM_INVENTORY_BAG_BIT_OFFSET);

                if (bank) then bag = bag + ITEM_INVENTORY_BANK_BAG_OFFSET; end
                return player, bank, bags, slot, bag
            else
                return player, bank, bags, location
            end
        end

    -- from baganator EquipmentSets.lua
    local addonTable = Baganator; -- change

    local BlizzardSetTracker = CreateFrame("Frame")
    local EQUIPMENT_SETS_PATTERN = EQUIPMENT_SETS:gsub("%%s", "(.*)")

    function BlizzardSetTracker:OnLoad()
        FrameUtil.RegisterFrameForEvents(self, {"BANKFRAME_OPENED", "EQUIPMENT_SETS_CHANGED"})
        Syndicator.CallbackRegistry:RegisterCallback("BagCacheUpdate", function()
            self:QueueScan()
            Syndicator.CallbackRegistry:UnregisterCallback("BagCacheUpdate", self)
        end, self)
        self.equipmentSetInfo = {}
        self.equipmentSetNames = {}

        -- change to BAGANATOR_LOCALES
        Baganator.API.RegisterItemSetSource('Blizzard', "blizzard", function(_, guid)
            return self.equipmentSetInfo[guid]
        end, function()
            return self.equipmentSetNames
        end)
    end
    BlizzardSetTracker:OnLoad()

    function BlizzardSetTracker:QueueScan()
        self:SetScript("OnUpdate", self.OnUpdate)
    end

    BlizzardSetTracker:SetScript("OnEvent", function(self, eventName)
        self.bankScan = eventName == "BANKFRAME_OPENED"
        self:QueueScan()
    end)

    function BlizzardSetTracker:OnUpdate()
        self:SetScript("OnUpdate", nil)
        self:ScanEquipmentSets()
    end

    -- Determine the GUID of all accessible items in an equipment set
    function BlizzardSetTracker:ScanEquipmentSets()
        local start = debugprofilestop()

        local oldSetInfo = CopyTable(self.equipmentSetInfo)

        local cache = {}
        local waiting = 0
        local loopComplete = false
        self.equipmentSetNames = {}
        local namesRef = self.equipmentSetNames -- Skip if another callback was triggered

        local function Finish()
            -- if addonTable.Config.Get(addonTable.Config.Options.DEBUG_TIMERS) then
            -- print("equipment set tracking took", debugprofilestop() - start)
            -- end
            if namesRef == self.equipmentSetNames and not tCompare(oldSetInfo, cache, 15) then
                self.equipmentSetInfo = cache
                Baganator.API.RequestItemButtonsRefresh()
            end
        end

        for _, setID in ipairs(C_EquipmentSet.GetEquipmentSetIDs()) do
            local name, iconTexture = C_EquipmentSet.GetEquipmentSetInfo(setID)
            table.insert(self.equipmentSetNames, name)
            local info = {name = name, iconTexture = iconTexture}

            -- Check for invalid items as attempting to get their locations will cause
            -- a crash on Max OS X
            local validItems = true
            if IsMacClient() then
                for _, itemID in pairs(C_EquipmentSet.GetItemIDs(setID)) do
                    if not C_Item.GetItemInfoInstant(itemID) then validItems = false end
                end
            end

            if validItems then
                -- Uses or {} because a set might exist without any associated item
                -- locations
                for _, locationID in pairs(C_EquipmentSet.GetItemLocations(setID) or {}) do
                    if locationID ~= -1 and locationID ~= 0 and locationID ~= 1 then
                        local player, bank, bags, _, slot, bag
                        if DF.API.Version.IsClassic then --   if addonTable.Constants.IsClassic then
                            player, bank, bags, slot, bag = EquipmentManager_UnpackLocation(locationID)
                        else
                            player, bank, bags, _, slot, bag = EquipmentManager_UnpackLocation(locationID)
                        end
                        local location, bagID, slotID
                        if (player or bank) and bags then
                            bagID = bag
                            slotID = slot
                            location = ItemLocation:CreateFromBagAndSlot(bagID, slotID)
                        elseif bank and not bags then
                            bagID = Syndicator.Constants.AllBankIndexes[1]
                            slotID = slot - BankButtonIDToInvSlotID(0)
                            location = ItemLocation:CreateFromBagAndSlot(bagID, slotID)
                        elseif player then
                            location = ItemLocation:CreateFromEquipmentSlot(slot)
                        end
                        if location then
                            local guid = C_Item.GetItemGUID(location)
                            if not cache[guid] then cache[guid] = {} end
                            table.insert(cache[guid], info)
                        end
                    end
                end
            else
                -- API will crash, so we do a much more intensive tooltip scan of all possible items
                local matchingItemIDs = {}
                for _, itemID in pairs(C_EquipmentSet.GetItemIDs(setID)) do
                    matchingItemIDs[itemID] = true
                end
                local function ProcessSlot(slot, location)
                    if matchingItemIDs[slot.itemID] and C_Item.DoesItemExist(location) then
                        local guid = C_Item.GetItemGUID(location)
                        waiting = waiting + 1
                        addonTable.Utilities.LoadItemData(slot.itemID, function()
                            waiting = waiting - 1
                            local tooltipInfo
                            if addonTable.Constants.IsRetail then
                                tooltipInfo = C_TooltipInfo.GetBagItem(location.bagID, location.slotIndex)
                            elseif location.bagID == Syndicator.Constants.AllBankIndexes[1] then
                                tooltipInfo = Syndicator.Search.DumpClassicTooltip(function(tooltip)
                                    tooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(location.slotIndex))
                                end)
                            else
                                tooltipInfo = Syndicator.Search.DumpClassicTooltip(function(tooltip)
                                    tooltip:SetBagItem(location.bagID, location.slotIndex)
                                end)
                            end
                            for _, line in ipairs(tooltipInfo.lines) do
                                local match = line.leftText:match(EQUIPMENT_SETS_PATTERN)
                                if match then
                                    for setName in match:gmatch("%s*([^" .. LIST_DELIMITER:gsub("%s", "") .. "]+)") do
                                        if setName == name then
                                            if not cache[guid] then
                                                cache[guid] = {}
                                            end
                                            table.insert(cache[guid], info)
                                            break
                                        end
                                    end
                                end
                            end
                            if loopComplete and waiting == 0 then Finish() end
                        end)
                    end
                end
                local characterData = Syndicator.API.GetCharacter(Syndicator.API.GetCurrentCharacter())
                for bagIndex, bag in ipairs(characterData.bags) do
                    for slotIndex, slot in ipairs(bag) do
                        local location = {bagID = Syndicator.Constants.AllBagIndexes[bagIndex], slotIndex = slotIndex}
                        ProcessSlot(slot, location)
                    end
                end
                if self.bankScan then
                    for bankIndex, bag in ipairs(characterData.bank) do
                        for slotIndex, slot in ipairs(bag) do
                            local location = {
                                bagID = Syndicator.Constants.AllBankIndexes[bankIndex],
                                slotIndex = slotIndex
                            }
                            ProcessSlot(slot, location)
                        end
                    end
                end
            end
        end
        self.bankScan = false

        if waiting == 0 then Finish() end
        loopComplete = true
    end
end

-- DF.Compatibility:FuncOrWaitframe('Baganator', DF.Compatibility.Baganator)
