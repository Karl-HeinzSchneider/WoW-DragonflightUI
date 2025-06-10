DragonflightUIItemColorMixin = {}

local DFUpdateFrame = CreateFrame('FRAME', 'DragonflightUIItemColorMixinUpdateFrame')
DFUpdateFrame:RegisterEvent('BAG_UPDATE_DELAYED')

-- DFUpdateFrame:SetScript('OnEvent', DragonflightUIItemColorMixin.OnEvent)

function DragonflightUIItemColorMixin:OnEvent(event, arg1, ...)
    print(' DragonflightUIItemColorMixin:OnEvent', event, arg1)
end

local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'
---@return texture 
function DragonflightUIItemColorMixin:AddOverlayToFrame(frame)
    if frame.DFQuality then
        --
        -- print('already frame.DFQuality', frame:GetName())
        return frame.DFQuality
    end

    local tex = base .. 'whiteiconframeEdit'

    local overlay = frame:CreateTexture('DragonflightUIQuality')
    overlay:SetDrawLayer('OVERLAY', 6)
    overlay:SetTexture(tex)
    overlay:SetSize(37, 37)
    -- overlay:SetTexCoord(0.32959, 0.349121, 0.000976562, 0.0400391)
    overlay:Hide()
    frame.DFQuality = overlay

    local subIcon = _G[(frame:GetName() or '******') .. 'SubIconTexture']

    if subIcon then subIcon:SetDrawLayer('OVERLAY', 7) end

    return overlay
end

local qualityToIconBorderAtlas = {
    [0] = {0.32959, 0.349121, 0.000976562, 0.0400391}, -- poor
    [1] = {0.32959, 0.349121, 0.000976562, 0.0400391}, -- common
    [2] = {0.411621, 0.431152, 0.0273438, 0.0664062}, -- uncommon
    [3] = {0.377441, 0.396973, 0.0273438, 0.0664062}, -- rare

    [4] = {0.579102, 0.598633, 0.0351562, 0.0742188}, -- epic
    [5] = {0.558594, 0.578125, 0.0351562, 0.0742188}, -- legendary

    [6] = {0.32959, 0.349121, 0.000976562, 0.0400391}, -- artifact
    [7] = {0.32959, 0.349121, 0.000976562, 0.0400391}, -- heirloom
    [8] = {0.32959, 0.349121, 0.000976562, 0.0400391} -- wow token
};

local DF_LE_ITEM_QUALITY_QUEST = #BAG_ITEM_QUALITY_COLORS + 1;
local DF_LE_ITEM_QUALITY_POOR = 0;

local DF_BAG_ITEM_QUALITY_COLORS = {}
for i = 1, #BAG_ITEM_QUALITY_COLORS do DF_BAG_ITEM_QUALITY_COLORS[i] = BAG_ITEM_QUALITY_COLORS[i] end
DF_BAG_ITEM_QUALITY_COLORS[DF_LE_ITEM_QUALITY_POOR] = {r = 0.1, g = 0.1, b = 0.1}
DF_BAG_ITEM_QUALITY_COLORS[DF_LE_ITEM_QUALITY_QUEST] = {r = 1.0, g = 1.0, b = 0}

function DragonflightUIItemColorMixin:UpdateOverlayQuality(frame, quality)
    if not frame.DFQuality then
        -- print('No frame.DFQuality:', frame:GetName(), quality)
        return
    end
    frame.DFQuality:Show()

    local color = DF_BAG_ITEM_QUALITY_COLORS[quality]
    if not color then
        color = DF_BAG_ITEM_QUALITY_COLORS[1]
        -- print('No Color:', frame:GetName(), quality)
    end
    -- print('color', color)
    frame.DFQuality:SetVertexColor(color.r, color.g, color.b, color.a)
    -- frame.DFQuality:SetTexCoord(unpack(qualityToIconBorderAtlas[quality]))
end

--[[ local overlay = DragonflightUIItemColorMixin:AddOverlayToFrame(CharacterTrinket0Slot)
overlay:SetPoint('CENTER', CharacterTrinket0Slot, 'CENTER', 0, 0)

DragonflightUIItemColorMixin:UpdateOverlayQuality(CharacterTrinket0Slot, 3) ]]

-- local color = BAG_ITEM_QUALITY_COLORS[quality];

function DragonflightUIItemColorMixin:HookCharacterFrame()
    if CharacterFrame.DFHooked then return end
    local ignored = {}
    ignored[CharacterBag0Slot] = true;
    ignored[CharacterBag1Slot] = true;
    ignored[CharacterBag2Slot] = true;
    ignored[CharacterBag3Slot] = true;

    hooksecurefunc('PaperDollItemSlotButton_Update', function(self)
        if ignored[self] then return end
        if not self.DFQuality then
            --
            local overlay = DragonflightUIItemColorMixin:AddOverlayToFrame(self)
            overlay:SetPoint('CENTER')
        end

        -- print('PaperDollItemSlotButton_Update', self:GetName())

        local textureName = GetInventoryItemTexture("player", self:GetID());
        local hasItem = textureName ~= nil;

        if hasItem then
            local quality = GetInventoryItemQuality("player", self:GetID())
            DragonflightUIItemColorMixin:UpdateOverlayQuality(self, quality)
        else
            self.DFQuality:Hide()
        end
    end)
    CharacterFrame.DFHooked = true
end

function DragonflightUIItemColorMixin:HookInspectFrame()
    -- print(' DragonflightUIItemColorMixin:HookInspectFrame()')
    if not InspectFrame or InspectFrame.DFColorHooked then return end
    local ignored = {}

    hooksecurefunc('InspectPaperDollItemSlotButton_Update', function(self)
        if ignored[self] then return end
        if not self.DFQuality then
            --           
            local overlay = DragonflightUIItemColorMixin:AddOverlayToFrame(self)
            overlay:SetPoint('CENTER')
        end

        local unit = InspectFrame.unit;
        local textureName = GetInventoryItemTexture(unit, self:GetID());
        local hasItem = textureName ~= nil;

        if hasItem then
            local quality = GetInventoryItemQuality(unit, self:GetID()) or 0
            -- print('InspectPaperDollItemSlotButton_Update', self:GetName(), quality)
            DragonflightUIItemColorMixin:UpdateOverlayQuality(self, quality)
        else
            self.DFQuality:Hide()
        end
    end)
    InspectFrame.DFColorHooked = true
end

-- DragonflightUIItemColorMixin:HookCharacterFrame()
-- DragonflightUIItemColorMixin:HookInspectFrame()

function DragonflightUIItemColorMixin:HookBags()
    -- print('DragonflightUIItemColorMixin:HookBags()')

    for bag = 1, NUM_CONTAINER_FRAMES do
        --
        for i = 1, 36 do
            --
            local ref = _G['ContainerFrame' .. bag .. 'Item' .. i]
            local overlay = DragonflightUIItemColorMixin:AddOverlayToFrame(ref)
            overlay:SetPoint('CENTER')
        end
    end

    local bankSlots = C_Container.GetContainerNumSlots(BANK_CONTAINER)

    for slot = 1, bankSlots do
        --
        local ref = _G['BankFrameItem' .. slot]
        local overlay = DragonflightUIItemColorMixin:AddOverlayToFrame(ref)
        overlay:SetPoint('CENTER')
    end

    for slot = 1, MERCHANT_ITEMS_PER_PAGE do
        --
        local ref = _G['MerchantItem' .. slot .. 'ItemButton']
        local overlay = DragonflightUIItemColorMixin:AddOverlayToFrame(ref)

        local icon = _G['MerchantItem' .. slot .. 'ItemButtonIconTexture']
        overlay:SetPoint('CENTER', icon, 'CENTER', 0, 0)

        DragonflightUIItemColorMixin:UpdateOverlayQuality(ref, 5)
    end

    do
        local ref = _G['MerchantBuyBackItemItemButton']
        local overlay = DragonflightUIItemColorMixin:AddOverlayToFrame(ref)

        local icon = _G['MerchantBuyBackItemItemButtonIconTexture']
        overlay:SetPoint('CENTER', icon, 'CENTER', 0, 0)

        DragonflightUIItemColorMixin:UpdateOverlayQuality(ref, 5)
    end

    hooksecurefunc('ToggleBackpack', function()
        --   
        local containerFrame = _G['ContainerFrame1'];
        -- print('ToggleBackpack', 'allBags: ', (containerFrame.allBags == true))

        if (containerFrame.allBags == true) then
            DragonflightUIItemColorMixin:UpdateAllBags(true)
        else
            DragonflightUIItemColorMixin:UpdateAllBags(false)
        end
    end);

    hooksecurefunc('ToggleBag', function(id)
        --   
        -- print('ToggleBag', id)
        DragonflightUIItemColorMixin:UpdateBag(id)
    end);

    hooksecurefunc('MerchantFrame_UpdateMerchantInfo', function()
        --        
        -- print('MerchantFrame_UpdateMerchantInfo')
        DragonflightUIItemColorMixin:UpdateMerchant()
    end)

    hooksecurefunc('MerchantFrame_UpdateBuybackInfo', function()
        --       
        -- print('MerchantFrame_UpdateBuybackInfo')
        DragonflightUIItemColorMixin:UpdateMerchantBuyback()
    end)
end

function DragonflightUIItemColorMixin:UpdateAllBags(force)
    -- print('DragonflightUIItemColorMixin:UpdateAllBags()', force)
    for bag = 0, NUM_BAG_SLOTS do
        --
        if force then OpenBag(bag) end
        DragonflightUIItemColorMixin:UpdateBag(bag)
    end

    -- local bankSlots = C_Container.GetNumBankSlots()

    for bank = 5, 11 do
        --
        if force then OpenBag(bank) end
        DragonflightUIItemColorMixin:UpdateBag(bank)
    end
end

function DragonflightUIItemColorMixin:UpdateBag(bag)
    local frameID = IsBagOpen(bag)
    -- print('UpdateBag()', bag, frameID)

    if frameID then
        --
        local numSlots = C_Container.GetContainerNumSlots(bag)

        for slot = 1, numSlots do
            local containerInfo = C_Container.GetContainerItemInfo(bag, slot)

            local slotFrame = _G['ContainerFrame' .. frameID .. 'Item' .. (numSlots + 1 - slot)]
            if containerInfo then
                local quality = containerInfo.quality or 0
                DragonflightUIItemColorMixin:UpdateOverlayQuality(slotFrame, quality)
            else
                if slotFrame and slotFrame.DFQuality then slotFrame.DFQuality:Hide() end
            end
        end
    end
end

function DragonflightUIItemColorMixin:UpdateBankSlots()
    -- print('DragonflightUIItemColorMixin:UpdateBankSlots()')
    local bankSlots = C_Container.GetContainerNumSlots(BANK_CONTAINER)

    for slot = 1, bankSlots do
        --
        local containerInfo = C_Container.GetContainerItemInfo(BANK_CONTAINER, slot)

        local slotFrame = _G['BankFrameItem' .. slot]
        if containerInfo then
            local quality = containerInfo.quality or 0
            DragonflightUIItemColorMixin:UpdateOverlayQuality(slotFrame, quality)
        else
            if slotFrame and slotFrame.DFQuality then slotFrame.DFQuality:Hide() end
        end
    end
end

function DragonflightUIItemColorMixin:UpdateMerchant()
    local numMerchantItems = GetMerchantNumItems()

    for i = 1, MERCHANT_ITEMS_PER_PAGE do
        local index = (((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i);
        local itemButton = _G["MerchantItem" .. i .. "ItemButton"];

        if (index <= numMerchantItems) then
            local link = GetMerchantItemLink(index);

            if link then
                local quality, classId;
                if C_Item.GetItemInfo then
                    quality, _, _, _, _, _, _, _, _, classId = select(3, C_Item.GetItemInfo(link));
                else
                    quality, _, _, _, _, _, _, _, _, classId = select(3, GetItemInfo(link));
                end

                if (classId == 12) then quality = DF_LE_ITEM_QUALITY_POOR; end

                DragonflightUIItemColorMixin:UpdateOverlayQuality(itemButton, quality)
            end
        end
    end

    do
        local itemButton = _G['MerchantBuyBackItemItemButton']

        local numBuybackItems = GetNumBuybackItems();
        local buybackName, buybackTexture, buybackPrice, buybackQuantity, buybackNumAvailable, buybackIsUsable =
            GetBuybackItemInfo(numBuybackItems);

        if buybackName then
            --
            local link = GetBuybackItemLink(numBuybackItems)

            if link then
                local quality, classId;
                if C_Item.GetItemInfo then
                    quality, _, _, _, _, _, _, _, _, classId = select(3, C_Item.GetItemInfo(link));
                else
                    quality, _, _, _, _, _, _, _, _, classId = select(3, GetItemInfo(link));
                end

                if (classId == 12) then quality = DF_LE_ITEM_QUALITY_POOR; end

                DragonflightUIItemColorMixin:UpdateOverlayQuality(itemButton, quality)
            end
        else
            itemButton.DFQuality:Hide()
        end
    end
end

function DragonflightUIItemColorMixin:UpdateMerchantBuyback()
    local numMerchantItems = GetNumBuybackItems()

    for index = 1, MERCHANT_ITEMS_PER_PAGE do
        local itemButton = _G["MerchantItem" .. index .. "ItemButton"];

        if (index <= numMerchantItems) then
            local link = GetBuybackItemLink(index);

            if link then
                local quality, classId;
                if C_Item.GetItemInfo then
                    quality, _, _, _, _, _, _, _, _, classId = select(3, C_Item.GetItemInfo(link));
                else
                    quality, _, _, _, _, _, _, _, _, classId = select(3, GetItemInfo(link));
                end

                if (classId == 12) then quality = DF_LE_ITEM_QUALITY_POOR; end

                DragonflightUIItemColorMixin:UpdateOverlayQuality(itemButton, quality)
            end
        end
    end
end

function DragonflightUIItemColorMixin:HookGuildbankBags()
    for c = 1, 7 do
        local column = GuildBankFrame['Column' .. c]
        for i = 1, 14 do
            local itemButton = column['Button' .. i]
            local buttonID = (c - 1) * 14 + i

            local overlay = DragonflightUIItemColorMixin:AddOverlayToFrame(itemButton)
            overlay:SetPoint('CENTER')

            -- DragonflightUIItemColorMixin:UpdateOverlayQuality(itemButton, 5)
        end
    end
end

function DragonflightUIItemColorMixin:UpdateGuildBankSlots()
    if not GuildBankFrame then return end
    ---@diagnostic disable-next-line: assign-type-mismatch
    local activeTab = GetCurrentGuildBankTab() ---@type number

    local itemButton;
    local buttonID;
    local texture, itemCount, locked, isFiltered, quality;

    for c = 1, 7 do
        local column = GuildBankFrame['Column' .. c]
        for i = 1, 14 do
            itemButton = column['Button' .. i]
            buttonID = (c - 1) * 14 + i

            texture, itemCount, locked, isFiltered, quality = GetGuildBankItemInfo(activeTab, buttonID)

            if not texture then
                -- no item
                itemButton.DFQuality:Hide();
            elseif (isFiltered) then
                -- filtered
                itemButton.DFQuality:Hide();
            else
                -- searched item
                DragonflightUIItemColorMixin:UpdateOverlayQuality(itemButton, quality)
            end
        end
    end
end
