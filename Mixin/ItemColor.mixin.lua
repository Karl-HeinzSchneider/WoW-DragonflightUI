DragonflightUIItemColorMixin = {}

local DFUpdateFrame = CreateFrame('FRAME', 'DragonflightUIItemColorMixinUpdateFrame')
DFUpdateFrame:RegisterEvent('BAG_UPDATE_DELAYED')

-- DFUpdateFrame:SetScript('OnEvent', DragonflightUIItemColorMixin.OnEvent)

function DragonflightUIItemColorMixin:OnEvent(event, arg1, ...)
    print(' DragonflightUIItemColorMixin:OnEvent', event, arg1)
end

local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

function DragonflightUIItemColorMixin:AddOverlayToFrame(frame)
    if frame.DFQuality then
        --
        print('already frame.DFQuality', frame:GetName())
        return
    end

    local tex = base .. 'whiteiconframeEdit'

    local overlay = frame:CreateTexture('DragonflightUIQuality')
    overlay:SetDrawLayer('OVERLAY', 7)
    overlay:SetTexture(tex)
    overlay:SetSize(37, 37)
    -- overlay:SetTexCoord(0.32959, 0.349121, 0.000976562, 0.0400391)
    frame.DFQuality = overlay

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

LE_ITEM_QUALITY_QUEST = #BAG_ITEM_QUALITY_COLORS + 1;
LE_ITEM_QUALITY_POOR = 0;
BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_POOR] = {r = 0.1, g = 0.1, b = 0.1}
BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_QUEST] = {r = 1.0, g = 1.0, b = 0}

function DragonflightUIItemColorMixin:UpdateOverlayQuality(frame, quality)
    if not frame.DFQuality then return end
    frame.DFQuality:Show()

    local color = BAG_ITEM_QUALITY_COLORS[quality]
    if not color then
        color = BAG_ITEM_QUALITY_COLORS[1]
        print('No Color:', frame:GetName(), quality)
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
    if not InspectFrame or InspectFrame.DFHooked then return end
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
            local quality = GetInventoryItemQuality(unit, self:GetID())
            -- print('InspectPaperDollItemSlotButton_Update', self:GetName(), quality)
            DragonflightUIItemColorMixin:UpdateOverlayQuality(self, quality)
        else
            self.DFQuality:Hide()
        end
    end)
    InspectFrame.DFHooked = true
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

    hooksecurefunc('ToggleBackpack', function()
        --   
        local containerFrame = _G['ContainerFrame1'];
        print('ToggleBackpack', 'allBags: ', (containerFrame.allBags == true))

        if (containerFrame.allBags == true) then
            DragonflightUIItemColorMixin:UpdateAllBags(true)
        else
            DragonflightUIItemColorMixin:UpdateAllBags(false)
        end
    end);

    hooksecurefunc('ToggleBag', function(id)
        --   
        print('ToggleBag', id)
        DragonflightUIItemColorMixin:UpdateBag(id)
    end);
end

function DragonflightUIItemColorMixin:UpdateAllBags(force)
    print('DragonflightUIItemColorMixin:UpdateAllBags()', force)
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
    print('UpdateBag()', bag, frameID)

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
                slotFrame.DFQuality:Hide()
            end
        end
    end
end

function DragonflightUIItemColorMixin:UpdateBankSlots()
    print('DragonflightUIItemColorMixin:UpdateBankSlots()')
    local bankSlots = C_Container.GetContainerNumSlots(BANK_CONTAINER)

    for slot = 1, bankSlots do
        --
        local containerInfo = C_Container.GetContainerItemInfo(BANK_CONTAINER, slot)

        local slotFrame = _G['BankFrameItem' .. slot]
        if containerInfo then
            local quality = containerInfo.quality or 0
            DragonflightUIItemColorMixin:UpdateOverlayQuality(slotFrame, quality)
        else
            slotFrame.DFQuality:Hide()
        end
    end
end
