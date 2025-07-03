---@diagnostic disable: undefined-global
---@class DragonflightUI
---@diagnostic disable-next-line: assign-type-mismatch
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

DragonflightUIMixin = {}

local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

function DragonflightUIMixin:UIPanelCloseButton(btn)
    -- print('DragonflightUIMixin:UIPanelCloseButton(btn)', btn:GetName())  
    local tex = base .. 'redbutton2x'

    btn:SetSize(24, 24)

    local normal = btn:GetNormalTexture()
    normal:SetTexture(tex)
    normal:SetTexCoord(0.152344, 0.292969, 0.0078125, 0.304688)

    local disabled = btn:GetDisabledTexture()
    disabled:SetTexture(tex)
    disabled:SetTexCoord(0.152344, 0.292969, 0.320312, 0.617188)

    local pushed = btn:GetPushedTexture()
    pushed:SetTexture(tex)
    pushed:SetTexCoord(0.152344, 0.292969, 0.632812, 0.929688)

    local highlight = btn:GetHighlightTexture()
    highlight:SetTexture(tex)
    highlight:SetTexCoord(0.449219, 0.589844, 0.0078125, 0.304688)
end

--[[ 
["Interface/Buttons/redbutton2x"]={
    ["RedButton-Condense"]={36, 38, 0.00390625, 0.144531, 0.0078125, 0.304688, false, false, "1x"},
    ["RedButton-Condense-disabled"]={36, 38, 0.00390625, 0.144531, 0.320312, 0.617188, false, false, "1x"},
    ["RedButton-Condense-Pressed"]={36, 38, 0.00390625, 0.144531, 0.632812, 0.929688, false, false, "1x"},
    ["RedButton-Exit"]={36, 38, 0.152344, 0.292969, 0.0078125, 0.304688, false, false, "1x"},
    ["RedButton-Exit-Disabled"]={36, 38, 0.152344, 0.292969, 0.320312, 0.617188, false, false, "1x"},
    ["RedButton-exit-pressed"]={36, 38, 0.152344, 0.292969, 0.632812, 0.929688, false, false, "1x"},
    ["RedButton-Expand"]={36, 38, 0.300781, 0.441406, 0.0078125, 0.304688, false, false, "1x"},
    ["RedButton-Expand-Disabled"]={36, 38, 0.300781, 0.441406, 0.320312, 0.617188, false, false, "1x"},
    ["RedButton-Expand-Pressed"]={36, 38, 0.300781, 0.441406, 0.632812, 0.929688, false, false, "1x"},
    ["RedButton-MiniCondense"]={36, 38, 0.449219, 0.589844, 0.320312, 0.617188, false, false, "1x"},
    ["RedButton-MiniCondense-disabled"]={36, 38, 0.449219, 0.589844, 0.632812, 0.929688, false, false, "1x"},
    ["RedButton-MiniCondense-pressed"]={36, 38, 0.597656, 0.738281, 0.0078125, 0.304688, false, false, "1x"},
    ["RedButton-Highlight"]={36, 38, 0.449219, 0.589844, 0.0078125, 0.304688, false, false, "1x"},
} ]]

function DragonflightUIMixin:MaximizeMinimizeButtonFrameTemplate(btn)
    -- print('DragonflightUIMixin:MaximizeMinimizeButtonFrameTemplate(btn)', btn:GetName())  
    local tex = base .. 'redbutton2x'

    btn:SetSize(24, 24)
    -- maximize
    do
        local ref = btn.MaximizeButton

        local normal = ref:GetNormalTexture()
        normal:SetTexture(tex)
        normal:SetTexCoord(0.300781, 0.441406, 0.0078125, 0.304688)

        local disabled = ref:GetDisabledTexture()
        disabled:SetTexture(tex)
        disabled:SetTexCoord(0.300781, 0.441406, 0.320312, 0.617188)

        local pushed = ref:GetPushedTexture()
        pushed:SetTexture(tex)
        pushed:SetTexCoord(0.300781, 0.441406, 0.632812, 0.929688)

        local highlight = ref:GetHighlightTexture()
        highlight:SetTexture(tex)
        highlight:SetTexCoord(0.449219, 0.589844, 0.0078125, 0.304688)
    end

    -- minimize
    do
        local ref = btn.MinimizeButton

        local normal = ref:GetNormalTexture()
        normal:SetTexture(tex)
        normal:SetTexCoord(0.00390625, 0.144531, 0.0078125, 0.304688)

        local disabled = ref:GetDisabledTexture()
        disabled:SetTexture(tex)
        disabled:SetTexCoord(0.00390625, 0.144531, 0.320312, 0.617188)

        local pushed = ref:GetPushedTexture()
        pushed:SetTexture(tex)
        pushed:SetTexCoord(0.00390625, 0.144531, 0.632812, 0.929688)

        local highlight = ref:GetHighlightTexture()
        highlight:SetTexture(tex)
        highlight:SetTexCoord(0.449219, 0.589844, 0.0078125, 0.304688)
    end
end

function DragonflightUIMixin:ChangeBag(frame)
    -- print('DragonflightUIMixin:ChangeBag(frame)', frame:GetName(), frame:GetID())
    local name = frame:GetName()

    do
        local alpha = 0
        local top = _G[name .. 'BackgroundTop']
        top:SetAlpha(alpha)

        local mid1 = _G[name .. 'BackgroundMiddle1']
        mid1:SetAlpha(alpha)

        local mid2 = _G[name .. 'BackgroundMiddle2']
        mid2:SetAlpha(alpha)

        local bottom = _G[name .. 'BackgroundBottom']
        bottom:SetAlpha(alpha)
    end

    local port = _G[name .. 'Portrait']
    port:ClearAllPoints()
    port:SetAlpha(1)
    port:SetSize(36, 36)
    port:SetPoint('TOPLEFT', frame, 'TOPLEFT', -4, 1)
    port:SetDrawLayer('OVERLAY', 5)

    local newPort = frame:CreateTexture('DFPortrait')
    -- newPort:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\bigbag')        
    newPort:SetTexture(133633)
    newPort:SetSize(36, 36)
    newPort:SetPoint('TOPLEFT', frame, 'TOPLEFT', -4, 1)
    newPort:SetDrawLayer('OVERLAY', 6)
    newPort:Hide()
    SetPortraitToTexture(newPort, newPort:GetTexture())

    frame.DFPortrait = newPort

    local portBtn = _G[name .. 'PortraitButton']
    portBtn:ClearAllPoints()
    -- portBtn:SetAlpha(0)
    portBtn:SetSize(36, 36)
    portBtn:SetPoint('TOPLEFT', frame, 'TOPLEFT', -4, 1)

    frame.ClosePanelButton = _G[name .. 'CloseButton']
    DragonflightUIMixin:AddNineSliceTextures(frame, true)
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(frame)

    frame.Bg:SetPoint('TOPLEFT', frame, 'TOPLEFT', 2, -20)
    frame.Bg:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -2, 3)

    local pp = frame:CreateTexture('DFPortraitBorder')
    pp:SetTexture(base .. 'ui-frame-portraitmetal-cornertopleftsmall')
    pp:SetSize(75, 76)
    pp:SetTexCoord(0, 150 / 256, 0, 150 / 256)
    pp:ClearAllPoints()
    pp:SetPoint('TOPLEFT', frame, 'TOPLEFT', -13, 16)
    pp:SetDrawLayer('OVERLAY', 7)

    frame.TitleContainer = CreateFrame('FRAME', 'TitleContainer', frame)
    frame.TitleContainer:SetSize(0, 20)
    frame.TitleContainer:SetPoint('TOPLEFT', 35, -1)
    frame.TitleContainer:SetPoint('TOPRIGHT', -24, -1)

    local title = _G[name .. 'Name']
    title:ClearAllPoints()
    title:SetPoint('TOP', frame.TitleContainer, 'TOP', 0, -5)
    title:SetPoint('RIGHT', frame.TitleContainer, 'RIGHT', 0, 0)
    title:SetPoint('LEFT', frame.TitleContainer, 'LEFT', 0, 0)
    title:SetFontObject("GameFontNormal")

    do
        local moneyFrame = _G[frame:GetName() .. 'MoneyFrame']
        moneyFrame:ClearAllPoints()
        moneyFrame:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT', 8, 8)
        moneyFrame:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -8, 8)
        MoneyFrame_SetMaxDisplayWidth(moneyFrame, 178 - 2 * 8)
        moneyFrame:SetHeight(17)

        local border = CreateFrame('FRAME', 'Border', moneyFrame, 'ContainerMoneyFrameBorderTemplate')
        border:SetParent(moneyFrame)
        border:SetAllPoints()
        moneyFrame.border = border
    end
    -- size
    do
        local CONTAINER_WIDTH = 178;
        local CONTAINER_SPACING = 8;
        local ITEM_SPACING_X = 5;
        local ITEM_SPACING_Y = 5;
        local CONTAINER_SCALE = 0.75;
        local BACKPACK_BASE_SIZE = 16;
        local FRAME_THAT_OPENED_BAGS = nil;
        local CONTAINER_HELPTIP_SYSTEM = "ContainerFrame";

        frame:SetWidth(CONTAINER_WIDTH)

        local bagSize = 42
        local rows = math.ceil(bagSize / 4)

        local updateSize = function(bag)
            bag:SetWidth(CONTAINER_WIDTH)

        end

    end
end

--[[ 
["Interface/ContainerFrame/BagsItemBankSlot2x"]={
    ["bags-item-bankslot64"]={64, 64, 0, 1, 0, 1, true, true, "1x"},
  }, -- Interface/ContainerFrame/BagsItemBankSlot2x
  ["Interface/ContainerFrame/BagsItemSlot2x"]={
    ["bags-item-slot64"]={64, 64, 0, 1, 0, 1, true, true, "1x"},
  }, -- Interface/ContainerFrame/BagsItemSlot2x
 ]]

function DragonflightUIMixin:ChangeBagButton(btn)
    local bg = btn:CreateTexture('DragonflightUIBg')
    bg:SetTexture(base .. 'BagsItemSlot2x')
    bg:SetSize(37, 37)
    bg:SetPoint('CENTER', 0, 0)
    bg:SetDrawLayer('BACKGROUND', 3)

    local normal = btn:GetNormalTexture()
    normal:SetTexture(base .. 'BagsItemSlot2x')
    normal:SetSize(37, 37)
    normal:SetPoint('CENTER', 0, 0)
    normal:SetDrawLayer('BACKGROUND', 3)

    local pushed = btn:GetPushedTexture()
    pushed:SetTexture(base .. 'ui-quickslot-depress')
    pushed:SetSize(37, 37)
    pushed:SetPoint('CENTER', 0, 0)
    -- pushed:SetDrawLayer('BACKGROUND', 3)

    local high = btn:GetHighlightTexture()
    high:SetTexture(base .. 'buttonhilight-square')
    -- high:SetTexCoord(0.408203, 0.478516, 0.679688, 0.820312)
    high:SetSize(37, 37)
    high:SetPoint('CENTER', 0, 0)
    -- high:SetDrawLayer('BACKGROUND', 3)

    local iconBorder = btn.IconBorder
    iconBorder:Hide()

    local border = btn:CreateTexture('DragonflightUIBorder')
    border:SetTexture(base .. 'ui-quickslot2')
    border:SetSize(64, 64)
    border:SetPoint('CENTER', 0, -1)
    border:SetDrawLayer('BACKGROUND', 4)
    -- border:SetAlpha(0.5)
end

function DragonflightUIMixin:ChangeBackpackTokenFrame()
    local frame = BackpackTokenFrame

    local regions = {frame:GetRegions()}

    for k, child in ipairs(regions) do
        --
        if child:GetObjectType() == 'Texture' then child:SetTexture('') end
    end

    frame:SetHeight(17)

    local border = CreateFrame('FRAME', 'Border', frame, 'ContainerTokenFrameBorderTemplate')
    border:SetParent(frame)
    border:SetAllPoints()
    frame.border = border

    local other;
    for i = 1, 3 do
        --
        -- <Size x="50" y="12"/>
        local token = _G['BackpackTokenFrameToken' .. i]
        token:ClearAllPoints()

        if other then
            token:SetPoint('LEFT', other, 'RIGHT', 0, 0)
        else
            token:SetPoint('LEFT', frame, 'LEFT', 6.5, -1)
        end
        other = token
    end

end

function DragonflightUIMixin:CreateSearchBox()
    local frame = CreateFrame('EditBox', 'DragonflightUIBackpackSearchBox', ContainerFrame1, 'BagSearchBoxTemplate')
    frame:SetSize(115, 20)
    frame:SetMaxLetters(15)

    -- frame:SetPoint("TOPLEFT", ContainerFrame1, "TOPLEFT", 42, -37)
    -- frame:Show()

    return frame
end

function DragonflightUIMixin:CreateBankSearchBox()
    local frame = CreateFrame('EditBox', 'DragonflightUIBankkSearchBox', BankFrame, 'BagSearchBoxTemplate')
    frame:SetSize(110, 20)
    frame:SetMaxLetters(15)
    frame:SetPoint('TOPRIGHT', BankFrame, 'TOPRIGHT', -48, -33)

    return frame
end

local DragonglightUIGuildBankSearchMixin = {}

function DragonglightUIGuildBankSearchMixin:UpdateFiltered()
    -- print('DragonglightUIGuildBankSearchMixin:UpdateFiltered()', self:GetID())

    if not GuildBankFrame:IsVisible() then return end

    local id = self:GetID();
    local activeTab = GetCurrentGuildBankTab()

    -- if id ~= activeTab then return end

    -- print('DragonglightUIGuildBankSearchMixin:UpdateFiltered()', id)

    local itemButton;
    local buttonID;
    local texture, itemCount, locked, isFiltered, quality;
    local hasItem = false
    local items = 0

    if id == activeTab then
        for c = 1, 7 do
            local column = GuildBankFrame['Column' .. c]
            for i = 1, 14 do
                itemButton = column['Button' .. i]
                buttonID = (c - 1) * 14 + i
                texture, itemCount, locked, isFiltered, quality = GetGuildBankItemInfo(id, buttonID)
                -- print(buttonID, '|', texture, itemCount, locked, isFiltered, quality)     
                if not texture then
                    -- no item
                    itemButton.searchOverlay:Hide();
                elseif (isFiltered) then
                    -- filtered
                    itemButton.searchOverlay:Show();
                else
                    -- searched item
                    hasItem = true
                    items = items + 1
                    itemButton.searchOverlay:Hide();
                end
            end
        end
    else
        for c = 1, 7 do
            for i = 1, 14 do
                buttonID = (c - 1) * 14 + i
                texture, itemCount, locked, isFiltered, quality = GetGuildBankItemInfo(id, buttonID)
                -- print(buttonID, '|', texture, itemCount, locked, isFiltered, quality)  

                if not texture then
                    -- no item              
                elseif (isFiltered) then
                    -- filtered                 
                else
                    -- searched item
                    hasItem = true
                    items = items + 1
                end
            end
        end

    end

    -- print('hasItem', id, hasItem, items)
    if hasItem then
        self.SearchOverlay:Hide()
    else
        self.SearchOverlay:Show()
    end
end

function DragonflightUIMixin:AddGuildbankSearch()
    if GuildBankFrame.DFGuildbankSearch then return end
    GuildBankFrame.DFGuildbankSearch = true

    local frame = CreateFrame('EditBox', 'DragonflightUIGuildBankkSearchBox', GuildBankFrame, 'BagSearchBoxTemplate')
    frame:SetSize(110, 20)
    frame:SetMaxLetters(15)
    frame:SetPoint('TOPRIGHT', GuildBankFrame, 'TOPRIGHT', -48, -40)

    for i = 1, MAX_GUILDBANK_TABS do
        --   
        -- _G['GuildBankTab' .. i].Button:UnregisterEvent('INVENTORY_SEARCH_UPDATE')
        local tab = _G['GuildBankTab' .. i]
        tab.Button:SetID(i)
        Mixin(tab.Button, DragonglightUIGuildBankSearchMixin)
        hooksecurefunc(tab, 'OnClick', function()
            tab.Button:UpdateFiltered()
        end)
    end
end

function DragonflightUIMixin:CreateProfessionFrame()
    -- print('DragonflightUIMixin:CreateProfessionFrame()')
    local frame = CreateFrame('FRAME', 'DragonflightUIProfessionFrame', UIParent,
                              'DragonflightUIProfessionFrameTemplate')
    return frame
end

function DragonflightUIMixin:CreateProfessionCraftFrame()
    -- print('DragonflightUIMixin:CreateProfessionFrame()')
    local frame = CreateFrame('FRAME', 'DragonflightUIProfessionCraftFrame', UIParent,
                              'DragonflightUIProfessionCraftFrameTemplate')
    return frame
end

function DragonflightUIMixin:ChangeTradeskillFrameCata(frame)
    -- print('DragonflightUIMixin:ChangeTradeskillFrameCata()')

    local regions = {frame:GetRegions()}
    local port

    for k, child in ipairs(regions) do
        --
        -- print('child:', child:GetName())
        if child:GetObjectType() == 'Texture' then
            -- child:SetTexture('')
            print('child:', 'Texture', child:GetTexture(), child:GetSize())
            local tex = child:GetTexture()

            if tex == 136797 then
                -- <Texture file="Interface\QuestFrame\UI-QuestLog-BookIcon">
                -- port = child
            elseif tex == 309665 then
                -- 	<Texture file="Interface\QuestFrame\UI-QuestLogDualPane-Left">
                -- child:Hide()
                -- child:SetTexture(base .. 'UI-QuestLogDualPane-Left')
            elseif tex == 309666 then
                -- <Texture file="Interface\QuestFrame\UI-QuestLogDualPane-RIGHT">
                -- child:Hide()          
                -- child:SetTexture(base .. 'ui-questlogdualpane-right')
            end
        end
    end
end

function DragonflightUIMixin:ChangeTrainerFrame()
    if DF:IsAddOnLoaded('Leatrix_Plus') then
        --
        if ClassTrainerFrame:GetWidth() > 400 then
            --
            DF:Print(
                "Leatrix_Plus detected with 'Interface -> Enhance trainers' activated - please deactivate or you might encounter bugs.")
        end
    end

    local frame = ClassTrainerFrame

    local regions = {frame:GetRegions()}
    local port

    for k, child in ipairs(regions) do
        --     
        if child:GetObjectType() == 'Texture' then
            local layer, layerNr = child:GetDrawLayer()
            if layer == 'ARTWORK' then child:Hide() end
            if layer == 'BORDER' then child:Hide() end
        end
    end

    local frameW = 4 + 11 + 296 + 32 + 296 + 24 + 4 + 6
    local frameH = 520 + 16
    frame:SetSize(frameW, frameH)

    DragonflightUIMixin:AddNineSliceTextures(frame, true)
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(frame)
    DragonflightUIMixin:FrameBackgroundSolid(frame, true)

    DragonflightUIMixin:UIPanelCloseButton(ClassTrainerFrameCloseButton)
    ClassTrainerFrameCloseButton:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', 1, 0)

    local filterDropdown = ClassTrainerFrameFilterDropDown or ClassTrainerFrame.FilterDropdown
    filterDropdown:SetPoint('TOPRIGHT', ClassTrainerFrameCloseButton, 'BOTTOMRIGHT', -4, -4)

    ClassTrainerNameText:ClearAllPoints()
    ClassTrainerNameText:SetPoint('TOP', frame, 'TOP', 0, -5)
    ClassTrainerNameText:SetPoint('LEFT', frame, 'LEFT', 60, 0)
    ClassTrainerNameText:SetPoint('RIGHT', frame, 'RIGHT', -60, 0)
    ClassTrainerNameText:SetDrawLayer('OVERLAY', 7)

    ClassTrainerGreetingText:ClearAllPoints()
    ClassTrainerGreetingText:SetPoint('TOPLEFT', frame, 'TOPLEFT', 62, -32)
    ClassTrainerGreetingText:SetDrawLayer('ARTWORK')

    local closeButton = ClassTrainerCancelButton
    closeButton:ClearAllPoints()
    closeButton:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -9, 7)
    closeButton:SetText(CLOSE)

    local trainButton = ClassTrainerTrainButton
    trainButton:ClearAllPoints()
    trainButton:SetPoint('RIGHT', closeButton, 'LEFT', 0, 0)

    local icon = ClassTrainerSkillIcon
    icon:SetPoint('TOPLEFT', ClassTrainerDetailScrollChildFrame, 'TOPLEFT', 12, -4)

    local skillName = ClassTrainerSkillName
    skillName:SetPoint('TOPLEFT', icon, 'TOPRIGHT', 10, 0)

    do
        local newMoney = CreateFrame('FRAME', 'DFTrainerMoneyFrame', frame)
        newMoney:SetSize(178 - 2 * 8, 17)
        newMoney:SetPoint('RIGHT', ClassTrainerFrameFilterDropDown, 'LEFT', 0, 0)

        local border = CreateFrame('FRAME', 'DFMoneyBorder', newMoney, 'ContainerMoneyFrameBorderTemplate')
        border:SetParent(newMoney)
        border:SetAllPoints()

        local money = ClassTrainerMoneyFrame
        money:ClearAllPoints()
        -- money:SetPoint('RIGHT', trainButton, 'LEFT', 0, 0)
        money:SetPoint('RIGHT', newMoney, 'RIGHT', 0, 0)
    end

    do
        local port = ClassTrainerFramePortrait
        port:SetSize(62, 62)
        port:ClearAllPoints()
        port:SetPoint('TOPLEFT', -5, 7)
        port:SetDrawLayer('OVERLAY', 6)

        frame.PortraitFrame = frame:CreateTexture('DFPortraitFrame')
        local pp = frame.PortraitFrame
        pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
        pp:SetTexCoord(0.0078125, 0.0078125, 0.0078125, 0.6171875, 0.6171875, 0.0078125, 0.6171875, 0.6171875)
        pp:SetSize(84, 84)
        pp:ClearAllPoints()
        pp:SetPoint('CENTER', port, 'CENTER', 0, 0)
        pp:SetDrawLayer('OVERLAY', 7)
    end

    do
        local inset = CreateFrame('Frame', 'DFTrainerInsetLeft', frame, 'InsetFrameTemplate')
        inset:SetPoint('TOPLEFT', 6, -70 + 6)
        inset:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMLEFT', 6 + 296 + 32 + 4, 6)

        frame.InsetLeft = inset

        local newBG = inset:CreateTexture('DragonflightUITrainerFrameInsetLeftBG')
        newBG:SetTexture(base .. 'professions')
        newBG:SetTexCoord(0.000488281, 0.131348, 0.0771484, 0.635742)
        newBG:SetSize(268, 572)
        newBG:ClearAllPoints()
        newBG:SetPoint('TOPLEFT', inset, 'TOPLEFT', 0, 0)
        newBG:SetPoint('BOTTOMRIGHT', inset, 'BOTTOMRIGHT', 0, 0)
        newBG:SetDrawLayer('BACKGROUND', -4)

        local oldBG = _G[inset:GetName() .. 'Bg']
        oldBG:Hide()
    end

    do
        -- ClassTrainerListScrollFrame
        local inset = CreateFrame('Frame', 'DFTrainerInsetRight', frame, 'InsetFrameTemplate')
        inset:ClearAllPoints()
        inset:SetPoint('TOPLEFT', frame.InsetLeft, 'TOPRIGHT', 2, 0)
        inset:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -6, 32)

        frame.InsetRight = inset

        local newBG = inset:CreateTexture('DragonflightUITrainerFrameInsetRightBG')
        newBG:SetTexture(base .. 'professionsminimizedview')
        newBG:SetTexCoord(0.00195312, 0.787109, 0.000976562, 0.576172 - 24 / 589)
        newBG:SetSize(402, 589)
        newBG:ClearAllPoints()
        newBG:SetPoint('TOPLEFT', inset, 'TOPLEFT', 0, 0)
        newBG:SetPoint('BOTTOMRIGHT', inset, 'BOTTOMRIGHT', 0, 0)
        newBG:SetDrawLayer('BACKGROUND', -4)

        local oldBG = _G[inset:GetName() .. 'Bg']
        oldBG:Hide()
    end

    frame.Bg:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -2, 2)

    do
        local padding = 4

        local expand = ClassTrainerExpandButtonFrame
        expand:ClearAllPoints()
        expand:SetPoint('TOPLEFT', frame, 'TOPLEFT', padding, -70)

        local expandRegions = {expand:GetRegions()}

        -- ClassTrainerExpandTabLeft:SetAlpha(0)
        -- ClassTrainerExpandTabMiddle:SetAlpha(0)

        for k, child in ipairs(expandRegions) do
            --     
            if child:GetObjectType() == 'Texture' then child:Hide() end
        end

        local skill1 = ClassTrainerSkill1
        skill1:ClearAllPoints()
        skill1:SetPoint('TOPLEFT', frame, 'TOPLEFT', padding + 7, -100)

        -- ClassTrainerSkill1:GetSize()  [1]=323.00003051758, [2]=15.99998664856

        local oldTrainerSkillsDisplayed = CLASS_TRAINER_SKILLS_DISPLAYED -- default: 11     
        local newTrainerSkillsDisplayed = 25

        local deltaY = -1
        CLASS_TRAINER_SKILL_HEIGHT = 16 - deltaY

        local scroll = ClassTrainerListScrollFrame
        local scrollH = newTrainerSkillsDisplayed * (16 - deltaY)
        scroll:ClearAllPoints()
        scroll:SetPoint("TOPLEFT", frame, "TOPLEFT", padding + 7, -70)
        scroll:SetSize(295, scrollH)

        local scrollRegions = {scroll:GetRegions()}

        for k, child in ipairs(scrollRegions) do
            --     
            if child:GetObjectType() == 'Texture' then child:Hide() end
        end
        ClassTrainerListScrollFrameScrollBar:SetPoint('TOPLEFT', scroll, 'TOPRIGHT', 6 + 4, -16)
        ClassTrainerListScrollFrameScrollBar:SetPoint('BOTTOMLEFT', scroll, 'BOTTOMRIGHT', 6 + 4, 16 - 30)

        for i = 2, CLASS_TRAINER_SKILLS_DISPLAYED do
            _G["ClassTrainerSkill" .. i]:ClearAllPoints()
            _G["ClassTrainerSkill" .. i]:SetPoint("TOPLEFT", _G["ClassTrainerSkill" .. (i - 1)], "BOTTOMLEFT", 0, deltaY)
        end

        CLASS_TRAINER_SKILLS_DISPLAYED = newTrainerSkillsDisplayed -- 25, default: 11

        for i = oldTrainerSkillsDisplayed + 1, newTrainerSkillsDisplayed do
            local btn = CreateFrame("Button", "ClassTrainerSkill" .. i, frame, "ClassTrainerSkillButtonTemplate")
            btn:SetID(i)
            btn:ClearAllPoints()
            btn:SetPoint("TOPLEFT", _G["ClassTrainerSkill" .. (i - 1)], "BOTTOMLEFT", 0, deltaY)
            btn:Hide()
        end

        ------
        local detail = ClassTrainerDetailScrollFrame

        detail:ClearAllPoints()
        detail:SetPoint("TOPLEFT", scroll, "TOPRIGHT", 32 + 6, 0)
        detail:SetSize(296, scrollH)

        hooksecurefunc("ClassTrainer_SetToTradeSkillTrainer", function()
            CLASS_TRAINER_SKILLS_DISPLAYED = newTrainerSkillsDisplayed
            ClassTrainerListScrollFrame:SetHeight(scrollH)
            ClassTrainerDetailScrollFrame:SetHeight(scrollH)
        end)

        hooksecurefunc("ClassTrainer_SetToClassTrainer", function()
            CLASS_TRAINER_SKILLS_DISPLAYED = newTrainerSkillsDisplayed - 1
            ClassTrainerListScrollFrame:SetHeight(scrollH)
            ClassTrainerDetailScrollFrame:SetHeight(scrollH)
        end)
    end

    do
        local trainAll = CreateFrame('BUTTON', 'DragonflightUITrainerFrameTrainAllButton', frame,
                                     'UIPanelButtonTemplate')
        trainAll:SetSize(80, 22)
        trainAll:SetText('Train All')

        trainAll:SetPoint('RIGHT', trainButton, 'LEFT', -82, 0)

        trainAll:SetScript('OnEnter', function(btn)
            local count = 0
            local cost = 0
            local numTrainerSkills = GetNumTrainerServices()

            for i = 1, numTrainerSkills do
                --
                local name, rank, category, expanded = GetTrainerServiceInfo(i);
                if category and category == 'available' then
                    --
                    local moneyCost, talentCost, professionCost = GetTrainerServiceCost(i);
                    count = count + 1
                    cost = cost + moneyCost
                end
            end

            if count > 0 then
                local coinString = C_CurrencyInfo.GetCoinTextureString(cost)

                GameTooltip:SetOwner(btn, 'ANCHOR_TOP', 0, 4)
                GameTooltip:ClearLines()

                GameTooltip:AddLine('Train ' .. count .. ' skill(s) for ' .. coinString)
                GameTooltip:Show()
            end
        end)

        trainAll:SetScript('OnClick', function(btn)
            --
            local num = GetNumTrainerServices()
            for i = 1, num do
                local name, rank, category, expanded = GetTrainerServiceInfo(i);
                if category and category == 'available' then
                    --
                    BuyTrainerService(i)
                end
            end
        end)

        local skillsToBuy = function()
            local num = GetNumTrainerServices()

            for i = 1, num do
                local name, rank, category, expanded = GetTrainerServiceInfo(i);
                if category and category == 'available' then
                    --
                    return true
                end
            end

            return false
        end

        hooksecurefunc('ClassTrainerFrame_Update', function()
            local shouldShow = skillsToBuy()

            trainAll:SetEnabled(shouldShow)

            if trainAll:IsMouseOver() and shouldShow then
                local func = trainAll:GetScript("OnEnter")
                if func then func(trainAll) end
                -- trainAll:OnEnter(trainAll)             
            end
        end)

    end

    ClassTrainerFrame:HookScript('OnShow', function()
        ClassTrainerFrame:SetAttribute("UIPanelLayout-width", ClassTrainerFrame:GetWidth());
        ClassTrainerFrame:SetAttribute("UIPanelLayout-" .. "xoffset", 0);
        ClassTrainerFrame:SetAttribute("UIPanelLayout-" .. "yoffset", 0);
        UpdateUIPanelPositions(ClassTrainerFrame)
    end)
end

function DragonflightUIMixin:ChangeDressupFrame()
    local frame = DressUpFrame

    local regions = {frame:GetRegions()}
    local port

    for k, child in ipairs(regions) do
        --     
        if child:GetObjectType() == 'Texture' then
            local layer, layerNr = child:GetDrawLayer()
            if layer == 'ARTWORK' then child:Hide() end
        end
    end

    frame:SetSize(354, 447 + 6)

    DragonflightUIMixin:AddNineSliceTextures(frame, true)
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(frame)

    DragonflightUIMixin:UIPanelCloseButton(DressUpFrameCloseButton)
    DressUpFrameCloseButton:SetPoint('TOPRIGHT', DressUpFrame, 'TOPRIGHT', 1, 0)

    DressUpFrameCancelButton:SetPoint('BOTTOMRIGHT', DressUpFrame, 'BOTTOMRIGHT', -7, 14)

    DressUpFrameTitleText:ClearAllPoints()
    DressUpFrameTitleText:SetPoint('TOP', DressUpFrame, 'TOP', 0, -5)
    DressUpFrameTitleText:SetPoint('LEFT', DressUpFrame, 'LEFT', 60, 0)
    DressUpFrameTitleText:SetPoint('RIGHT', DressUpFrame, 'RIGHT', -60, 0)

    DressUpModelFrame:ClearAllPoints()
    DressUpModelFrame:SetPoint('TOPLEFT', DressUpFrame, 'TOPLEFT', 19, -75)
    DressUpModelFrame:SetHeight(351 - 18)

    do
        local inset = CreateFrame('Frame', 'DragonflightUIInset', DressUpModelFrame, 'InsetFrameTemplate')
        inset:ClearAllPoints()
        inset:SetPoint('TOPLEFT', DressUpModelFrame, 'TOPLEFT', 0, 0)
        inset:SetPoint('BOTTOMRIGHT', DressUpModelFrame, 'BOTTOMRIGHT', 0, 0)
        -- inset:SetFrameLevel(1)

        _G[inset:GetName() .. 'Bg']:Hide()
    end

    DressUpFrameBackgroundTopLeft:SetPoint('TOPLEFT', DressUpFrame, 'TOPLEFT', 19, -75)

    do
        local port = DressUpFramePortrait
        port:SetSize(62, 62)
        port:ClearAllPoints()
        port:SetPoint('TOPLEFT', -5, 7)
        port:SetDrawLayer('OVERLAY', 6)

        local pp = frame.PortraitFrame
        pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
        pp:SetTexCoord(0.0078125, 0.0078125, 0.0078125, 0.6171875, 0.6171875, 0.0078125, 0.6171875, 0.6171875)
        pp:SetSize(84, 84)
        pp:ClearAllPoints()
        pp:SetPoint('CENTER', port, 'CENTER', 0, 0)
        pp:SetDrawLayer('OVERLAY', 7)
    end

    DragonflightUIMixin:FrameBackgroundSolid(frame, true)

    -- default -16 
    ShowUIPanel(frame)
    DressUpFrame:SetAttribute("UIPanelLayout-" .. "xoffset", 0);
    DressUpFrame:SetAttribute("UIPanelLayout-" .. "yoffset", 0);
    HideUIPanel(frame)
end

function DragonflightUIMixin:EnhanceDressupFrame()
    DressUpModelFrame:EnableMouseWheel(true)
    DressUpModelFrame:HookScript('OnMouseWheel', Model_OnMouseWheel)
    DressUpModelFrame:HookScript('OnMouseDown', function(self, button)
        --
        -- function Model_StartPanning(self, usePanningFrame)
        if button == 'RightButton' then Model_StartPanning(self) end
    end)
    DressUpModelFrame:HookScript('OnMouseUp', function(self, button)
        --
        -- function Model_StopPanning(self)
        Model_StopPanning(self)
    end)

    -- default reset is not at 0
    DressUpFrameResetButton:HookScript('OnClick', function()
        --
        DressUpModelFrame:SetRotation(0)
        DressUpModelFrame:SetPosition(0, 0, 0)
        DressUpModelFrame:SetPortraitZoom(0)
        DressUpModelFrame:RefreshCamera()
    end)
end

function DragonflightUIMixin:ChangeInspectFrame()
    if not InspectFrame or InspectFrame.DFHooked then return end
    if DF.API.Version.IsMoP then return end-- TODO

    do
        local regions = {InspectPaperDollFrame:GetRegions()}

        for k, child in ipairs(regions) do
            --     
            if child:GetObjectType() == 'Texture' then
                local layer, layerNr = child:GetDrawLayer()
                if layer == 'BORDER' then child:Hide() end
            end
        end
    end

    -- honor
    if InspectPVPFrame then
        local regions = {InspectPVPFrame:GetRegions()}
        for k, child in ipairs(regions) do
            --     
            if child:GetObjectType() == 'Texture' then
                local layer, layerNr = child:GetDrawLayer()
                -- print(layer, layerNr, child:GetTexture())
                if layer == 'BACKGROUND' then child:Hide() end
                -- if layer == 'ARTWORK' then child:Hide() end
            end
        end
        local dx = -16
        local dy = 12

        InspectPVPFrame:SetPoint('TOPLEFT', InspectFrame, 'TOPLEFT', 0 + dx, 0 + dy)
        InspectPVPFrame:SetPoint('BOTTOMRIGHT', InspectFrame, 'BOTTOMRIGHT', 0 + dx, 0 + dy)
    end

    -- honor Era
    if InspectHonorFrame then
        local regions = {InspectHonorFrame:GetRegions()}
        for k, child in ipairs(regions) do
            --     
            if child:GetObjectType() == 'Texture' then
                local layer, layerNr = child:GetDrawLayer()
                -- print(layer, layerNr, child:GetTexture())
                if layer == 'BACKGROUND' then child:Hide() end
                -- if layer == 'ARTWORK' then child:Hide() end
            end
        end
        local dx = -14
        local dy = 14

        InspectHonorFrame:SetPoint('TOPLEFT', InspectFrame, 'TOPLEFT', 0 + dx, 0 + dy)
        InspectHonorFrame:SetPoint('BOTTOMRIGHT', InspectFrame, 'BOTTOMRIGHT', 0 + dx, 0 + dy)
    end

    -- talent
    if InspectTalentFrame then
        local regions = {InspectTalentFrame:GetRegions()}
        for k, child in ipairs(regions) do
            --     
            if child:GetObjectType() == 'Texture' then
                local layer, layerNr = child:GetDrawLayer()
                -- print(layer, layerNr, child:GetTexture())
                if layer == 'BORDER' then child:Hide() end
                -- if layer == 'ARTWORK' then child:Hide() end
            end
        end
        local dx = -14
        local dy = 12

        InspectTalentFrame:SetPoint('TOPLEFT', InspectFrame, 'TOPLEFT', 0 + dx, 0 + dy)
        InspectTalentFrame:SetPoint('BOTTOMRIGHT', InspectFrame, 'BOTTOMRIGHT', 0 + dx, 0 + dy)

        if InspectTalentFrameCloseButton then InspectTalentFrameCloseButton:Hide() end

        if InspectTalentFramePointsBar then
            local pointsBar = InspectTalentFramePointsBar
            pointsBar:ClearAllPoints()
            pointsBar:SetPoint('BOTTOM', InspectFrame, 'BOTTOM', 0, 4)
        end

        local scroll = InspectTalentFrameScrollFrame
        scroll:SetPoint('TOPRIGHT', InspectFrame, 'TOPRIGHT', -32, -66)

        for i = 1, 28 do
            --
            local talent = _G['InspectTalentFrameTalent' .. i]
            talent:SetScript('OnEnter', function(self)
                -- 
                local selectedTab = PanelTemplates_GetSelectedTab(InspectTalentFrame) or InspectTalentFrame.talentTree;
                local talentGroup = GetActiveTalentGroup(true, false);
                -- print(talent:GetName(), selectedTab, talentGroup)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
                ---@diagnostic disable-next-line: redundant-parameter
                GameTooltip:SetTalent(selectedTab, i, true, false, talentGroup, true)
            end)

        end
    end

    InspectFrame:SetSize(336, 424)

    DragonflightUIMixin:AddNineSliceTextures(InspectFrame, true)
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(InspectFrame)

    DragonflightUIMixin:UIPanelCloseButton(InspectFrameCloseButton)
    InspectFrameCloseButton:SetPoint('TOPRIGHT', InspectFrame, 'TOPRIGHT', 1, 0)

    do
        local port = InspectFramePortrait
        port:SetSize(62, 62)
        port:ClearAllPoints()
        port:SetPoint('TOPLEFT', -5, 7)
        port:SetDrawLayer('OVERLAY', 6)

        InspectFrame.PortraitFrame = InspectFrame:CreateTexture('PortraitFrame')
        local pp = InspectFrame.PortraitFrame
        pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
        pp:SetTexCoord(0.0078125, 0.0078125, 0.0078125, 0.6171875, 0.6171875, 0.0078125, 0.6171875, 0.6171875)
        pp:SetSize(84, 84)
        pp:ClearAllPoints()
        pp:SetPoint('CENTER', port, 'CENTER', 0, 0)
        pp:SetDrawLayer('OVERLAY', 7)
    end

    DragonflightUIMixin:FrameBackgroundSolid(InspectFrame, true)

    do
        local name = _G['InspectNameFrame']
        name:ClearAllPoints()
        name:SetPoint('TOP', InspectFrame, 'TOP', 0, -5)
        name:SetPoint('LEFT', InspectFrame, 'LEFT', 60, 0)
        name:SetPoint('RIGHT', InspectFrame, 'RIGHT', -60, 0)

        local level = InspectLevelText
        level:ClearAllPoints()
        level:SetPoint('TOP', name, 'BOTTOM', 0, -10)
        level:SetDrawLayer('ARTWORK')
    end

    do
        local head = _G['InspectHeadSlot']
        head:ClearAllPoints()
        head:SetPoint('TOPLEFT', InspectPaperDollItemsFrame, 'TOPLEFT', 8, -74) -- -64 = charframe
    end

    do
        local model = _G['InspectModelFrame']
        model:ClearAllPoints()
        model:SetPoint('TOPLEFT', InspectPaperDollFrame, 'TOPLEFT', 52, -74)

        local inset = CreateFrame('Frame', 'DragonflightUICharacterFrameInset', InspectPaperDollFrame,
                                  'InsetFrameTemplate')
        inset:ClearAllPoints()
        inset:SetPoint('TOPLEFT', model, 'TOPLEFT', 0, 0)
        inset:SetPoint('BOTTOMRIGHT', model, 'BOTTOMRIGHT', 0, 8)

        local tl = model:CreateTexture('DragonflightUIInspectModelFrame' .. 'TopLeft', 'BACKGROUND')
        tl:SetSize(212, 245)
        tl:SetPoint('TOPLEFT')
        tl:SetTexCoord(0.171875, 1, 0.0392156862745098, 1)

        local tr = model:CreateTexture('DragonflightUIInspectModelFrame' .. 'TopRight', 'BACKGROUND')
        tr:SetSize(19, 245)
        tr:SetPoint('TOPLEFT', tl, 'TOPRIGHT')
        tr:SetTexCoord(0, 0.296875, 0.0392156862745098, 1)

        local delta = 80

        local bl = model:CreateTexture('DragonflightUIInspectModelFrame' .. 'BotLeft', 'BACKGROUND')
        bl:SetSize(212, 128 - delta)
        bl:SetPoint('TOPLEFT', tl, 'BOTTOMLEFT')
        bl:SetTexCoord(0.171875, 1, 0, 1 - delta / 128)

        local br = model:CreateTexture('DragonflightUIInspectModelFrame' .. 'BotRight', 'BACKGROUND')
        br:SetSize(19, 128 - delta)
        br:SetPoint('TOPLEFT', tl, 'BOTTOMRIGHT')
        br:SetTexCoord(0, 0.296875, 0, 1 - delta / 128)

        local overlay = model:CreateTexture('DragonflightUIInspectModelFrame' .. 'Overlay', 'BORDER')
        overlay:SetPoint('TOPLEFT', tl, 'TOPLEFT', 0, 0)
        overlay:SetPoint('BOTTOMRIGHT', br, 'BOTTOMRIGHT', 0, 0)
        overlay:SetColorTexture(0, 0, 0)

        local backgroundDesaturate = function(on)
            tl:SetDesaturated(on);
            tr:SetDesaturated(on);
            bl:SetDesaturated(on);
            br:SetDesaturated(on);
        end

        local updateBackground = function(unit)
            -- print('updateBackground', unit, UnitRace(unit))
            local race, fileName = UnitRace(unit);
            if not fileName then return end
            local texture = DressUpTexturePath(fileName);
            tl:SetTexture(texture .. 1);
            tr:SetTexture(texture .. 2);
            bl:SetTexture(texture .. 3);
            br:SetTexture(texture .. 4);

            if (strupper(fileName) == "BLOODELF") then
                overlay:SetAlpha(0.8);
            elseif (strupper(fileName) == "NIGHTELF") then
                overlay:SetAlpha(0.6);
            elseif (strupper(fileName) == "SCOURGE") then
                overlay:SetAlpha(0.3);
            elseif (strupper(fileName) == "TROLL" or strupper(fileName) == "ORC") then
                overlay:SetAlpha(0.6);
            elseif (strupper(fileName) == "WORGEN") then
                overlay:SetAlpha(0.5);
            elseif (strupper(fileName) == "GOBLIN") then
                overlay:SetAlpha(0.6);
            else
                overlay:SetAlpha(0.7);
            end
        end

        InspectFrame:HookScript('OnEvent', function(self, event, unit, ...)
            --  
            -- print('hookEvent', self:GetName(), event, unit, ...)
            if event == 'INSPECT_READY' then
                if InspectFrame and InspectFrame.unit then updateBackground(InspectFrame.unit) end
                backgroundDesaturate(true)
            end
        end)
    end

    do
        local hands = _G['InspectHandsSlot']
        hands:ClearAllPoints()
        hands:SetPoint('TOPRIGHT', InspectPaperDollItemsFrame, 'TOPRIGHT', -8, -74) -- -64 = charframe
    end

    do
        -- <Anchor point="BOTTOMLEFT" x="130" y="16"/>
        local main = _G['InspectMainHandSlot']
        main:ClearAllPoints()
        local x = (InspectPaperDollItemsFrame:GetWidth() / 2) - 1.5 * main:GetWidth() - 5
        main:SetPoint('BOTTOMLEFT', InspectPaperDollItemsFrame, 'BOTTOMLEFT', x, 16)
    end

    UIPanelWindows["InspectFrame"] = {
        whileDead = 1,
        height = InspectFrame:GetHeight(),
        width = InspectFrame:GetWidth(),
        bottomClampOverride = 152,
        xoffset = 0,
        yoffset = 0,
        pushable = 3,
        area = "left"
    }

    do
        local firstTab = _G['InspectFrameTab1']
        firstTab:ClearAllPoints()
        firstTab:SetPoint('TOPLEFT', InspectFrame, 'BOTTOMLEFT', 12, 1)

        for i = 1, 3 do
            --
            local tab = _G['InspectFrameTab' .. i]

            if tab then
                DragonflightUIMixin:CharacterFrameTabButtonTemplate(tab)

                if i == 1 then
                    tab.DFFirst = true
                elseif i > 1 then
                    tab.DFChangePoint = true
                end
            end
        end
    end

    InspectFrame.DFHooked = true
end

function DragonflightUIMixin:ChangeCharacterFrameEra()
    local frameTable = {PaperDollFrame, ReputationFrame, SkillFrame}
    if DF.Wrath and not DF.Cata then -- Need test Era or Cata or Mop need hide TokenFrame.
        table.insert(frameTable, TokenFrame)
    end

    for i, f in ipairs(frameTable) do
        local regions = {f:GetRegions()}

        for k, child in ipairs(regions) do
            --     
            if child:GetObjectType() == 'Texture' then
                local layer, layerNr = child:GetDrawLayer()
                -- print(layer, layerNr, child:GetTexture())
                if layer == 'BORDER' then child:Hide() end
                -- if layer == 'ARTWORK' then child:Hide() end
                if DF.Wrath and not DF.Cata then
                    if f == TokenFrame and layer == 'ARTWORK' then child:Hide() end
                end
            end
        end
    end

    -- honor
    if HonorFrame then
        local regions = {HonorFrame:GetRegions()}
        for k, child in ipairs(regions) do
            --     
            if child:GetObjectType() == 'Texture' then
                local layer, layerNr = child:GetDrawLayer()
                -- print(layer, layerNr, child:GetTexture())
                if layer == 'BACKGROUND' then child:Hide() end
                -- if layer == 'ARTWORK' then child:Hide() end
            end
        end
        local dx = -14
        local dy = 12

        HonorFrame:SetPoint('TOPLEFT', CharacterFrame, 'TOPLEFT', 0 + dx, 0 + dy)
        HonorFrame:SetPoint('BOTTOMRIGHT', CharacterFrame, 'BOTTOMRIGHT', 0 + dx, 0 + dy)

        local honorLevel = HonorLevelText
        honorLevel:ClearAllPoints()
        honorLevel:SetPoint('TOP', header, 'BOTTOM', 0, -10)
        honorLevel:SetDrawLayer('ARTWORK')
    end
    --

    local frame = CharacterFrame
    frame:SetSize(338 - 2, 424)

    DragonflightUIMixin:AddNineSliceTextures(frame, true)
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(frame)
    DragonflightUIMixin:FrameBackgroundSolid(frame, true)

    local header = CharacterNameFrame
    header:ClearAllPoints()
    header:SetPoint('TOP', frame, 'TOP', 0, -5)
    header:SetPoint('LEFT', frame, 'LEFT', 60, 0)
    header:SetPoint('RIGHT', frame, 'RIGHT', -60, 0)

    local level = CharacterLevelText
    level:ClearAllPoints()
    level:SetPoint('TOP', header, 'BOTTOM', 0, -10)
    level:SetDrawLayer('ARTWORK')

    local closeButton = CharacterFrameCloseButton
    DragonflightUIMixin:UIPanelCloseButton(closeButton)
    closeButton:ClearAllPoints()
    closeButton:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', 1, 0)

    -- Portrait
    do
        local port = CharacterFramePortrait
        port:SetSize(62, 62)
        port:ClearAllPoints()
        port:SetPoint('TOPLEFT', frame, 'TOPLEFT', -5, 7)
        port:SetDrawLayer('OVERLAY', 6)
        port:SetParent(frame)
        port:Show()

        frame.PortraitFrame = frame:CreateTexture('PortraitFrame')
        local pp = frame.PortraitFrame
        pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
        pp:SetTexCoord(0.0078125, 0.0078125, 0.0078125, 0.6171875, 0.6171875, 0.0078125, 0.6171875, 0.6171875)
        pp:SetSize(84, 84)
        pp:ClearAllPoints()
        pp:SetPoint('CENTER', port, 'CENTER', 0, 0)
        pp:SetDrawLayer('OVERLAY', 7)
    end

    -- Background
    local inset = CreateFrame('Frame', 'DragonflightUICharacterFrameInset', frame, 'InsetFrameTemplate')
    inset:ClearAllPoints()
    inset:SetPoint('TOPLEFT', frame, 'TOPLEFT', 4, -60)
    -- if DF.API.Version.IsWotlk then inset:SetPoint('TOPLEFT', frame, 'TOPLEFT', 4, -73) end
    inset:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMLEFT', 332, 4)
    frame.DFInset = inset
    -- _G['DragonflightUICharacterFrameInsetBg']:SetAlpha(0.25)

    -- Item Slots
    local head = CharacterHeadSlot
    head:SetPoint('TOPLEFT', inset, 'TOPLEFT', 4, -2)

    local hand = CharacterHandsSlot
    hand:ClearAllPoints()
    hand:SetPoint('TOPRIGHT', inset, 'TOPRIGHT', -4, -2)

    if DF.API.Version.IsWotlk then
        -- head:SetPoint('TOPLEFT', inset, 'TOPLEFT', 4, -10)
        -- hand:SetPoint('TOPRIGHT', inset, 'TOPRIGHT', -4, -10)
        local equipManagerBtn = GearManagerToggleButton
        equipManagerBtn:ClearAllPoints()
        -- equipManagerBtn:SetPoint("TOPRIGHT", inset, "TOPRIGHT", -8, 40)

        local modelRotateRightBtn = CharacterModelFrameRotateRightButton
        modelRotateRightBtn:ClearAllPoints()
        modelRotateRightBtn:SetPoint("TOPLEFT", inset, "TOPLEFT", 40 + 10, -7)

        local modelRotateLeftBtn = CharacterModelFrameRotateLeftButton
        modelRotateLeftBtn:ClearAllPoints()
        modelRotateLeftBtn:SetPoint("TOPLEFT", inset, "TOPLEFT", 70 + 10, -7)

        local magicRes = MagicResFrame1
        magicRes:ClearAllPoints()
        magicRes:SetPoint("TOPRIGHT", inset, "TOPRIGHT", -45, -10)
    end

    -- Model
    local model = CharacterModelFrame
    model:SetPoint('TOPLEFT', PaperDollFrame, 'TOPLEFT', 52, -66)
    model:SetHeight(224 - 12)

    -- wheel 
    model:EnableMouseWheel(true)
    model:HookScript('OnMouseWheel', Model_OnMouseWheel)
    -- panning? maybe
    -- model:HookScript('OnMouseDown', function(self, button)
    --     --
    --     -- function Model_StartPanning(self, usePanningFrame)
    --     if button == 'RightButton' then Model_StartPanning(self) end
    -- end)
    -- model:HookScript('OnMouseUp', function(self, button)
    --     --
    --     -- function Model_StopPanning(self)
    --     Model_StopPanning(self)
    -- end)

    local res = CharacterResistanceFrame
    res:SetPoint('TOPRIGHT', PaperDollFrame, 'TOPLEFT', 297 - 10 + 2, -77 + 10 + 2)

    -- Attributes
    local att = CharacterAttributesFrame
    local attX = (inset:GetWidth() - att:GetWidth()) / 2
    att:SetPoint('TOPLEFT', PaperDollFrame, 'TOPLEFT', attX + 4, -291 + 12)

    local main = CharacterMainHandSlot
    main:ClearAllPoints()
    -- main:SetPoint('TOPLEFT', PaperDollItemsFrame, 'TOPLEFT', 122, 127)
    main:SetPoint('BOTTOMLEFT', PaperDollItemsFrame, 'BOTTOMLEFT', 107.5, 16)
    -- if DF.API.Version.IsWotlk then main:SetPoint('BOTTOMLEFT', PaperDollItemsFrame, 'BOTTOMLEFT', 87, 13) end -- @TODO
    -- tabs
    do
        for i = 1, 5 do
            local tab = _G['CharacterFrameTab' .. i]

            if tab then
                --         
                DragonflightUIMixin:CharacterFrameTabButtonTemplate(tab)
                tab.DFFirst = nil
                tab.DFChangePoint = nil
                tab.DFTabWidth = 62
            end
        end

        local updateTabs = function()
            local lastElem = nil
            local width = 79
            if _G['CharacterFrameTab2']:IsShown() then width = 62.4 end
            for i = 1, 5 do
                local tab = _G['CharacterFrameTab' .. i]
                if tab and (tab:IsShown()) then
                    tab:SetWidth(width)
                    tab:ClearAllPoints();
                    if lastElem then
                        tab:SetPoint('TOPLEFT', lastElem, 'TOPRIGHT', 4, 0)
                    else
                        tab:SetPoint('TOPLEFT', CharacterFrame, 'BOTTOMLEFT', 6, 1)
                    end
                    lastElem = tab
                end
            end
        end
        hooksecurefunc('ToggleCharacter', function(panel)
            --   
            updateTabs()
        end)
        _G['CharacterFrameTab2']:HookScript('OnShow', updateTabs)
        _G['CharacterFrameTab2']:HookScript('OnHide', updateTabs)
    end

    local PANEL_DEFAULT_WIDTH = frame:GetWidth();
    local CHARACTERFRAME_EXPANDED_WIDTH = 540;

    function frame:DFUpdateFrameWidth(expanded)
        local frameW = expanded and CHARACTERFRAME_EXPANDED_WIDTH or PANEL_DEFAULT_WIDTH;
        frame:SetWidth(frameW)
        frame:SetAttribute("UIPanelLayout-width", frameW);
        frame:SetAttribute("UIPanelLayout-" .. "xoffset", 0);
        frame:SetAttribute("UIPanelLayout-" .. "yoffset", 0);
        UpdateUIPanelPositions(frame)
    end

    frame:HookScript('OnShow', function()
        frame:DFUpdateFrameWidth(frame.Expanded)
    end)

    -- add characterstats panel + equzipment manager
    if DF.API.Version.IsClassic or DF.API.Version.IsWotlk then
        --
        local btn = CreateFrame('Button', 'DragonflightUICharacterFrameExpandButton', PaperDollFrame,
                                'DFCharacterFrameExpandButton')
        btn:SetPoint('BOTTOMRIGHT', CharacterFrame.DFInset, 'BOTTOMRIGHT', -2, -1)
        CharacterFrame.DFExpandButton = btn;

        local insetRight = CreateFrame('Frame', 'DragonflightUICharacterFrameInsetRight', PaperDollFrame,
                                       'InsetFrameTemplate')
        insetRight:ClearAllPoints()
        insetRight:SetPoint('TOPLEFT', CharacterFrame.DFInset, 'TOPRIGHT', 1, 0)
        insetRight:SetPoint('BOTTOMRIGHT', CharacterFrame, 'BOTTOMRIGHT', -4, 4)
        CharacterFrame.DFInsetRight = insetRight

        local statsTemplate
        if DF.API.Version.IsClassic then
            statsTemplate = 'DFCharacterStatsPanelEra';
        elseif DF.API.Version.IsWotlk then
            statsTemplate = 'DFCharacterStatsPanelWrath';
        else
            --
        end

        local p = CreateFrame('Frame', 'DragonflightUICharacterStatsPanel', insetRight, statsTemplate)
        p:SetSize(100, 100)
        p:SetPoint('TOPLEFT', insetRight, 'TOPLEFT', 3, -3)
        p:SetPoint('BOTTOMRIGHT', insetRight, 'BOTTOMRIGHT', -3, 2);
        p:Hide()

        local titlePanel = CreateFrame('Frame', 'DragonflightUICharacterTitlePanel', insetRight)
        titlePanel:SetSize(100, 100)
        titlePanel:SetPoint('TOPLEFT', insetRight, 'TOPLEFT', 3, -3)
        titlePanel:SetPoint('BOTTOMRIGHT', insetRight, 'BOTTOMRIGHT', -3, 2);
        titlePanel:Hide()

        local equipmentPanel = CreateFrame('Frame', 'DragonflightUICharacterEquipmentManagerPanel', insetRight,
                                           'DFEquipmentManagerPanel')
        equipmentPanel:SetSize(100, 100)
        equipmentPanel:SetPoint('TOPLEFT', insetRight, 'TOPLEFT', 3, -3)
        equipmentPanel:SetPoint('BOTTOMRIGHT', insetRight, 'BOTTOMRIGHT', -3, 2);
        equipmentPanel:Hide()

        -- tabs

        local sidebar = CreateFrame('Frame', 'DragonflightUICharacterFrameSidebar', insetRight,
                                    'DragonflightUISidebarTemplate')
        sidebar:SetPoint('BOTTOMRIGHT', insetRight, 'TOPRIGHT', -6, -1)
        sidebar:SetSize(168, 35)

        sidebar:SetSidebar(1)

        CharacterFrame:Expand()

        hooksecurefunc('ToggleCharacter', function(tab)
            --   
            -- print('ToggleCharacter', tab)       
            if tab == 'PaperDollFrame' and frame.Expanded then
                frame:DFUpdateFrameWidth(true)
            else
                frame:DFUpdateFrameWidth(false)
            end
        end)

        -- remove default
        local res = CharacterResistanceFrame
        res:ClearAllPoints()
        res:Hide()

        local att = CharacterAttributesFrame
        att:ClearAllPoints()
        att:Hide()

        -- local model = CharacterModelFrame
        model:SetPoint('TOPLEFT', PaperDollFrame, 'TOPLEFT', 52, -66)
        -- model:SetWidth(233)
        model:SetHeight(320 - 2)

        do
            local inset = CreateFrame('Frame', 'DragonflightUICharacterModelFrameInset', model, 'InsetFrameTemplate')
            inset:ClearAllPoints()
            local deltaInset = 0.0;
            inset:SetPoint('TOPLEFT', model, 'TOPLEFT', -0, 0)
            inset:SetPoint('BOTTOMRIGHT', model, 'BOTTOMRIGHT', 0, -0)
            inset:SetFrameLevel(3)

            _G[inset:GetName() .. 'Bg']:Hide()

            local tl = model:CreateTexture('DragonflightUIInspectModelFrame' .. 'TopLeft', 'BACKGROUND')
            tl:SetSize(212, 245)
            tl:SetPoint('TOPLEFT')
            tl:SetTexCoord(0.171875, 1, 0.0392156862745098, 1)

            local tr = model:CreateTexture('DragonflightUIInspectModelFrame' .. 'TopRight', 'BACKGROUND')
            tr:SetSize(19, 245)
            tr:SetPoint('TOPLEFT', tl, 'TOPRIGHT')
            tr:SetTexCoord(0, 0.296875, 0.0392156862745098, 1)

            local delta = 55

            local bl = model:CreateTexture('DragonflightUIInspectModelFrame' .. 'BotLeft', 'BACKGROUND')
            bl:SetSize(212, 128 - delta)
            bl:SetPoint('TOPLEFT', tl, 'BOTTOMLEFT')
            bl:SetTexCoord(0.171875, 1, 0, 1 - delta / 128)

            local br = model:CreateTexture('DragonflightUIInspectModelFrame' .. 'BotRight', 'BACKGROUND')
            br:SetSize(19, 128 - delta)
            br:SetPoint('TOPLEFT', tl, 'BOTTOMRIGHT')
            br:SetTexCoord(0, 0.296875, 0, 1 - delta / 128)

            local overlay = model:CreateTexture('DragonflightUIInspectModelFrame' .. 'Overlay', 'BORDER')
            overlay:SetPoint('TOPLEFT', tl, 'TOPLEFT', 0, 0)
            overlay:SetPoint('BOTTOMRIGHT', br, 'BOTTOMRIGHT', 0, 0)
            overlay:SetColorTexture(0, 0, 0)

            local backgroundDesaturate = function(on)
                tl:SetDesaturated(on);
                tr:SetDesaturated(on);
                bl:SetDesaturated(on);
                br:SetDesaturated(on);
            end

            local updateBackground = function(unit)
                -- print('updateBackground', unit, UnitRace(unit))
                local race, fileName = UnitRace(unit);
                local texture = DressUpTexturePath(fileName);
                tl:SetTexture(texture .. 1);
                tr:SetTexture(texture .. 2);
                bl:SetTexture(texture .. 3);
                br:SetTexture(texture .. 4);

                if (strupper(fileName) == "BLOODELF") then
                    overlay:SetAlpha(0.8);
                elseif (strupper(fileName) == "NIGHTELF") then
                    overlay:SetAlpha(0.6);
                elseif (strupper(fileName) == "SCOURGE") then
                    overlay:SetAlpha(0.3);
                elseif (strupper(fileName) == "TROLL" or strupper(fileName) == "ORC") then
                    overlay:SetAlpha(0.6);
                elseif (strupper(fileName) == "WORGEN") then
                    overlay:SetAlpha(0.5);
                elseif (strupper(fileName) == "GOBLIN") then
                    overlay:SetAlpha(0.6);
                else
                    overlay:SetAlpha(0.7);
                end
            end

            backgroundDesaturate(true)
            updateBackground('player')
        end
    end

    -- rep
    do
        if DF.Wrath then
            local regions = {ReputationFrame:GetRegions()}
            for k, child in ipairs(regions) do
                --     
                if child:GetObjectType() == 'Texture' then
                    local layer, layerNr = child:GetDrawLayer()
                    -- print(layer, layerNr, child:GetTexture())
                    if layer == 'BACKGROUND' then child:Hide() end
                    -- if layer == 'ARTWORK' then child:Hide() end
                end
            end
        end

        local rep = ReputationFrame

        local factionLabel = ReputationFrameFactionLabel
        factionLabel:SetPoint('TOPLEFT', rep, 'TOPLEFT', 70, -42)

        local standingLabel = ReputationFrameStandingLabel
        standingLabel:SetPoint('TOPLEFT', rep, 'TOPLEFT', 215, -42)

        local scroll = ReputationListScrollFrame
        scroll:ClearAllPoints()
        scroll:SetPoint('TOPLEFT', inset, 'TOPLEFT', 0, 0)
        scroll:SetWidth(300)

        local function UpdateRepulationBarsPos()
            local first = ReputationBar1
            first:ClearAllPoints()
            first:SetPoint('TOPRIGHT', inset, 'TOPRIGHT', -50, -10)
            -- first:SetPoint('LEFT', rep, 'LEFT', 10, 0)
        end

        if DF.Wrath and not DF.Cata then
            scroll:HookScript("OnShow", UpdateRepulationBarsPos)
            scroll:HookScript("OnHide", UpdateRepulationBarsPos)
        else
            UpdateRepulationBarsPos()
        end

        local detail = ReputationDetailFrame
        detail:SetPoint('TOPLEFT', rep, 'TOPRIGHT', 0, -13)

        local btn = ReputationDetailCloseButton
        DragonflightUIMixin:UIPanelCloseButton(btn)
        btn:SetPoint('TOPRIGHT', detail, 'TOPRIGHT', -5, -6)

    end

    -- pet
    do
        local regions = {PetPaperDollFrame:GetRegions()}
        for k, child in ipairs(regions) do
            --     
            if child:GetObjectType() == 'Texture' then
                local layer, layerNr = child:GetDrawLayer()
                -- print(layer, layerNr, child:GetTexture())
                if layer == 'BORDER' then child:Hide() end
                -- if layer == 'ARTWORK' then child:Hide() end
                if DF.Wrath and not DF.Cata then if layer == 'BACKGROUND' then child:Hide() end end
            end
        end

        local model = PetModelFrame
        model:SetPoint('TOPLEFT', PetPaperDollFrame, 'TOPLEFT', 9, -66)

        local rotateleft = PetModelFrameRotateLeftButton
        if rotateleft then
            rotateleft:ClearAllPoints()
            rotateleft:SetPoint('TOPLEFT', model, 'TOPLEFT', 0, 0)
        end

        local rotate = PetModelFrameRotateRightButton
        rotate:ClearAllPoints()
        rotate:SetPoint('TOPLEFT', rotateleft or model, 'TOPRIGHT', 0, 0)

        local res = PetResistanceFrame
        res:ClearAllPoints()
        res:SetPoint('TOPRIGHT', model, 'TOPRIGHT', 0, 0)

        local att = PetAttributesFrame
        local attX = (inset:GetWidth() - att:GetWidth()) / 2
        att:SetPoint('TOPLEFT', PetPaperDollFrame, 'TOPLEFT', attX + 4, -300 + 10)

        local expBar = PetPaperDollFrameExpBar
        expBar:ClearAllPoints()
        expBar:SetPoint('BOTTOM', PetPaperDollFrame, 'BOTTOM', 0, 36)

        local close = PetPaperDollCloseButton
        close:ClearAllPoints()
        close:SetPoint('BOTTOMRIGHT', PetPaperDollFrame, 'BOTTOMRIGHT', -9, 7)
        close:Hide()

        local newMoney = CreateFrame('FRAME', 'DFPetTrainingPointsFrame', PetPaperDollFrame)
        -- newMoney:SetSize(178 - 2 * 8, 17)
        newMoney:SetHeight(22)
        newMoney:SetPoint('BOTTOMLEFT', PetPaperDollFrame, 'BOTTOMLEFT', 9, 7)
        newMoney:SetPoint('RIGHT', close, 'LEFT', 0, 0)

        local border = CreateFrame('FRAME', 'DFMoneyBorder', newMoney, 'ContainerMoneyFrameBorderTemplate')
        border:SetParent(newMoney)
        border:SetAllPoints()

        local trainingFrame = CreateFrame('FRAME', 'DFPetTrainingPointsFrameS', PetPaperDollFrame)
        trainingFrame:SetHeight(22)
        trainingFrame:SetWidth(newMoney:GetWidth())
        trainingFrame:SetPoint('CENTER', newMoney, 'CENTER', 0, 0)
        trainingFrame:SetFrameLevel(10)

        if PetTrainingPointText then
            local trainPoint = PetTrainingPointText
            trainPoint:ClearAllPoints()
            trainPoint:SetPoint('RIGHT', trainingFrame, 'RIGHT', -16, 0)
            trainPoint:SetDrawLayer('OVERLAY', 5)
            trainPoint:SetParent(trainingFrame)

            PetTrainingPointLabel:SetDrawLayer('OVERLAY', 5)
            PetTrainingPointLabel:SetParent(trainingFrame)
        end

        local nameFrame = CreateFrame('FRAME', 'DragonflightUIPetNameFrame', PetPaperDollFrame)
        nameFrame:SetPoint('TOP', PetPaperDollFrame, 'TOP', 0, -5)
        nameFrame:SetPoint('LEFT', PetPaperDollFrame, 'LEFT', 60, 0)
        nameFrame:SetPoint('RIGHT', PetPaperDollFrame, 'RIGHT', -60, 0)
        nameFrame:SetHeight(12)

        local headerPet = PetNameText
        headerPet:ClearAllPoints()
        -- headerPet:SetPoint('TOP', PetPaperDollFrame, 'TOP', 0, -5)
        -- headerPet:SetPoint('LEFT', PetPaperDollFrame, 'LEFT', 60, 0)
        -- headerPet:SetPoint('RIGHT', PetPaperDollFrame, 'RIGHT', -60, 0)
        headerPet:SetPoint('CENTER', nameFrame, 'CENTER', 0, 0)
        headerPet:SetDrawLayer('ARTWORK')

        local levelPet = PetLevelText
        levelPet:ClearAllPoints()
        levelPet:SetPoint('TOP', nameFrame, 'BOTTOM', 0, -10)
        levelPet:SetDrawLayer('ARTWORK')

        if PetLoyaltyText then
            local loyal = PetLoyaltyText
            loyal:ClearAllPoints()
            loyal:SetPoint('TOP', levelPet, 'BOTTOM', 0, -1)
            loyal:SetDrawLayer('ARTWORK')
        end
        --[[
        local level = CharacterLevelText
        level:ClearAllPoints()
        level:SetPoint('TOP', header, 'BOTTOM', 0, -10)
        level:SetDrawLayer('ARTWORK')

        local honorLevel = HonorLevelText
        honorLevel:ClearAllPoints()
        honorLevel:SetPoint('TOP', header, 'BOTTOM', 0, -10)
        honorLevel:SetDrawLayer('ARTWORK')
        ]]
    end

    -- skills
    do
        local skills = SkillFrame

        local scroll = SkillListScrollFrame
        scroll:ClearAllPoints()
        scroll:SetPoint('TOPLEFT', inset, 'TOPLEFT', 0, 0)
        scroll:SetWidth(300)

        local first = SkillTypeLabel1
        first:SetPoint('LEFT', skills, 'TOPLEFT', 22 - 16, -86)

        local firstSkill = SkillRankFrame1
        -- firstSkill:ClearAllPoints()
        -- firstSkill:SetPoint('TOPLEFT', skills, 'TOPLEFT', 38, -86)

        local expand = SkillFrameExpandButtonFrame
        expand:SetPoint('TOPLEFT', skills, 'TOPLEFT', 70 - 10, -49 + 14)

        for i = 1, 15 do
            --
            local sr = _G['SkillRankFrame' .. i]
            local border = _G['SkillRankFrame' .. i .. 'Border']
            if sr then
                --
                sr:SetWidth(271 - 11)
                border:SetWidth(281 - 11)
            end
        end

        local cancel = SkillFrameCancelButton
        cancel:ClearAllPoints()
        cancel:SetPoint('BOTTOMRIGHT', skills, 'BOTTOMRIGHT', -9 - 26, 7)
        cancel:Hide()

        local dividerLeft = SkillFrameHorizontalBarLeft
        dividerLeft:SetPoint('TOPLEFT', skills, 'TOPLEFT', 15 - 10, -290)
        dividerLeft:SetWidth(256 - 6)
        -- dividerLeft:SetDrawLayer('OVERLAY')

        local detail = SkillDetailScrollFrame
        detail:SetPoint('TOPLEFT', scroll, 'BOTTOMLEFT', 0, -8 - 10)
        detail:SetWidth(300)

    end

    -- token
    do
        if DF.Wrath and not DF.Cata then -- Need test Era or Cata or Mop
            local token = TokenFrame

            local container = TokenFrameContainer
            container:ClearAllPoints()
            container:SetPoint('TOPLEFT', token, 'TOPLEFT', 12, -63)

            local pop = TokenFramePopup
            pop:ClearAllPoints()
            pop:SetPoint('TOPLEFT', token, 'TOPRIGHT', 0, 0)

            local money = TokenFrameMoneyFrame
            money:ClearAllPoints()
            money:SetPoint('BOTTOMRIGHT', token, 'BOTTOMRIGHT', 6, 6)

            local cancel = TokenFrameCancelButton
            cancel:ClearAllPoints()
            cancel:SetPoint('BOTTOMRIGHT', token, 'BOTTOMRIGHT', -9 - 26, 7)
            cancel:Hide()

            local children = {token:GetChildren()}
            for i, child in ipairs(children) do
                local name = child:GetName()
                if not name then child:Hide() end
            end
        end
    end
end

function DragonflightUIMixin:ChangeCharacterFrameCata()
    DragonflightUIMixin:PortraitFrameTemplate(CharacterFrame)

    CharacterFrameBg:SetTexture(base .. 'ui-background-rock')
    CharacterFrameBg:ClearAllPoints()
    CharacterFrameBg:SetPoint('TOPLEFT', CharacterFrame, 'TOPLEFT', 3, -18)
    CharacterFrameBg:SetPoint('BOTTOMRIGHT', CharacterFrame, 'BOTTOMRIGHT', 0, 3)
    -- CharacterFrameBg:SetDrawLayer('BACKGROUND', 2)

    if DF.API.Version.IsCata then
        -- <Anchor point="BOTTOMLEFT" x="130" y="16"/>
        local main = _G['CharacterMainHandSlot']
        main:ClearAllPoints()
        local x = (328 / 2) + 4 - 1.5 * main:GetWidth() - 5
        main:SetPoint('BOTTOMLEFT', PaperDollItemsFrame, 'BOTTOMLEFT', x, 16)
    end
end

function DragonflightUIMixin:ChangeTaxiFrame()
    local frame = TaxiFrame

    local regions = {frame:GetRegions()}
    local port

    for k, child in ipairs(regions) do
        --
        if child:GetObjectType() == 'Texture' then
            --
            child:Hide()
        end
    end
    -- <AbsDimension x="316" y="352"/>

    frame:SetSize(332, 424)

    DragonflightUIMixin:AddNineSliceTextures(frame, true)
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(frame)
    DragonflightUIMixin:FrameBackgroundSolid(frame, true)

    local header = TaxiMerchant
    header:ClearAllPoints()
    header:SetPoint('TOP', frame, 'TOP', 0, -5)
    header:SetPoint('LEFT', frame, 'LEFT', 60, 0)
    header:SetPoint('RIGHT', frame, 'RIGHT', -60, 0)

    local closeButton = TaxiCloseButton
    DragonflightUIMixin:UIPanelCloseButton(closeButton)
    closeButton:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', 1, 0)

    do
        local map = TaxiRouteMap
        map:ClearAllPoints()
        map:SetPoint('TOPLEFT', frame, 'TOPLEFT', 8, -62)

        local taxi = TaxiMap
        taxi:Show()
        taxi:ClearAllPoints()
        taxi:SetPoint('TOPLEFT', frame, 'TOPLEFT', 8, -62)
    end

    do
        local port = TaxiPortrait
        port:SetSize(62, 62)
        port:ClearAllPoints()
        port:SetPoint('TOPLEFT', frame, 'TOPLEFT', -5, 7)
        port:SetDrawLayer('OVERLAY', 6)
        port:SetParent(frame)
        port:Show()

        frame.PortraitFrame = frame:CreateTexture('PortraitFrame')
        local pp = frame.PortraitFrame
        pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
        pp:SetTexCoord(0.0078125, 0.0078125, 0.0078125, 0.6171875, 0.6171875, 0.0078125, 0.6171875, 0.6171875)
        pp:SetSize(84, 84)
        pp:ClearAllPoints()
        pp:SetPoint('CENTER', port, 'CENTER', 0, 0)
        pp:SetDrawLayer('OVERLAY', 7)
    end

    -- default -16 
    -- ShowUIPanel(frame)
    -- frame:SetAttribute("UIPanelLayout-" .. "xoffset", 0);
    -- frame:SetAttribute("UIPanelLayout-" .. "yoffset", 0);
    -- HideUIPanel(frame)
end

function DragonflightUIMixin:ImproveTaxiFrame()
    do
        local minmax =
            CreateFrame('Button', 'DFTaxiFrameMinMaxButton', TaxiFrame, 'MaximizeMinimizeButtonFrameTemplate')
        minmax:SetSize(32, 32)
        minmax:SetPoint('RIGHT', TaxiCloseButton, 'LEFT', 0, 0)
        DragonflightUIMixin:MaximizeMinimizeButtonFrameTemplate(minmax)
        minmax:Hide()
    end

    local scale = 1.3
    local padding = 8
    local deltaY = 62

    -- <AbsDimension x="316" y="352"/>
    TAXI_MAP_WIDTH = 316 * scale
    TAXI_MAP_HEIGHT = 352 * scale
    TaxiMap:SetWidth(TAXI_MAP_WIDTH)
    TaxiMap:SetHeight(TAXI_MAP_HEIGHT)
    TaxiRouteMap:SetWidth(TAXI_MAP_WIDTH)
    TaxiRouteMap:SetHeight(TAXI_MAP_HEIGHT)

    -- frame:SetSize(332, 424)
    -- TaxiFrame:SetSize(332 * scale, 424 * scale)
    TaxiFrame:SetWidth(TAXI_MAP_WIDTH + 2 * padding)
    TaxiFrame:SetHeight(TAXI_MAP_HEIGHT + deltaY + padding)

    TaxiFrame:HookScript('OnShow', function()
        TaxiFrame:SetAttribute("UIPanelLayout-width", TaxiFrame:GetWidth());
        TaxiFrame:SetAttribute("UIPanelLayout-" .. "xoffset", 0);
        TaxiFrame:SetAttribute("UIPanelLayout-" .. "yoffset", 0);
        UpdateUIPanelPositions(TaxiFrame)
    end)
end

function DragonflightUIMixin:ChangeTaxiFrameMists()
    local frame = TaxiFrame

    local regions = {frame:GetRegions()}

    for k, child in ipairs(regions) do
        --
        if child:GetObjectType() == 'Texture' then
            --
            local drawlayer, level = child:GetDrawLayer()
            -- print(child:GetName(), child:GetDrawLayer())

            if drawlayer == 'OVERLAY' then
                child:Hide()
            elseif drawlayer == 'BORDER' then
                -- child:Hide()
            elseif drawlayer == 'BACKGROUND' then
                -- child:Hide()
            end

            if level < 0 then child:Hide() end
        end
    end

    frame.BottomBorder:Hide()
    frame.RightBorder:Hide()
    frame.LeftBorder:Hide()
    frame.BotLeftCorner:Hide()
    frame.BotRightCorner:Hide()

    DragonflightUIMixin:AddNineSliceTextures(frame, true)
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(frame)
    DragonflightUIMixin:FrameBackgroundSolid(frame, true)

    local closeButton = frame.CloseButton
    DragonflightUIMixin:UIPanelCloseButton(closeButton)
    closeButton:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', 1, 0)

    frame.Bg:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -3 + 1, 3)
    frame.InsetBg:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -6 + 2, 4)

    do
        -- local map = TaxiRouteMap
        -- map:ClearAllPoints()
        -- map:SetPoint('TOPLEFT', frame, 'TOPLEFT', 8, -62)
        -- map:Show()

        -- local taxi = TaxiMap
        -- taxi:Show()
        -- taxi:ClearAllPoints()
        -- taxi:SetPoint('TOPLEFT', frame, 'TOPLEFT', 8, -62)

    end

end

function DragonflightUIMixin:ChangeLootFrame()
    local frame = LootFrame
    DragonflightUIMixin:PortraitFrameTemplate(frame)

    local regions = {frame:GetRegions()}

    for k, child in ipairs(regions) do
        if child:GetObjectType() == 'FontString' and child:GetText() == ITEMS then
            --             
            child:Hide()
        end
    end

    local header = frame:CreateFontString('DFLootFrameTitle', 'OVERLAY', 'GameFontNormal')
    header:SetText(ITEMS)
    header:SetPoint('TOP', frame, 'TOP', 12, -5)
    frame.DFHeader = header

    local topleft = _G[frame:GetName() .. 'TopLeftCornerDF']
    topleft:SetDrawLayer('OVERLAY', -2)

    local port = _G['LootFramePortrait']
    port:SetDrawLayer('OVERLAY', 7)
end

function DragonflightUIMixin:ChangeQuestFrame()
    local frame = QuestFrame
    local detail = QuestFrameDetailPanel
    local reward = QuestFrameRewardPanel
    local progress = QuestFrameProgressPanel
    local greeting = QuestFrameGreetingPanel

    local regions = {detail:GetRegions()}
    local port

    for k, child in ipairs(regions) do
        --
        -- print('child:', child:GetName())
        if child:GetObjectType() == 'Texture' then
            -- child:SetTexture('')
            -- print('child:', 'Texture', child:GetTexture(), child:GetWidth(), child:GetHeight())
            local tex = child:GetTexture()

            if tex == 136785 then
                -- bottom left
                child:Hide()

            elseif tex == 136791 then
                -- bottom left corner
                child:Hide()
            elseif tex == 136792 then
                -- bottom right corner
                child:Hide()
            elseif tex == 136793 then
                --
                child:Hide()
            elseif tex == 136794 then
                --
                child:Hide()
            else
                -- child:Hide()
            end
        end
    end

    local regionsReward = {reward:GetRegions()}

    for k, child in ipairs(regionsReward) do
        --
        -- print('child:', child:GetName())
        if child:GetObjectType() == 'Texture' then
            -- child:SetTexture('')
            -- print('child:', 'Texture', child:GetTexture(), child:GetWidth(), child:GetHeight())         
            child:Hide()
        end
    end

    local regionsProgress = {progress:GetRegions()}

    for k, child in ipairs(regionsProgress) do
        --
        -- print('child:', child:GetName())
        if child:GetObjectType() == 'Texture' then
            -- child:SetTexture('')
            -- print('child:', 'Texture', child:GetTexture(), child:GetWidth(), child:GetHeight())         
            child:Hide()
        end
    end

    local regionsGreeting = {greeting:GetRegions()}

    for k, child in ipairs(regionsGreeting) do
        --
        -- print('child:', child:GetName())
        if child:GetObjectType() == 'Texture' then
            -- child:SetTexture('')
            -- print('child:', 'Texture', child:GetTexture(), child:GetWidth(), child:GetHeight())         
            child:Hide()
        end
    end

    frame:SetSize(338, 496)
    detail:SetSize(338, 496)
    reward:SetSize(338, 496)
    progress:SetSize(338, 496)
    greeting:SetSize(338, 496)

    DragonflightUIMixin:AddNineSliceTextures(frame, true)
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(frame)

    if DF.API.Version.IsMoP then
        --
        DragonflightUIMixin:FrameBackgroundSolidMoP(frame, true)
    else
        DragonflightUIMixin:FrameBackgroundSolid(frame, true)
    end

    local header = QuestNpcNameFrame
    header:ClearAllPoints()
    header:SetPoint('TOP', QuestFrame, 'TOP', 0, -5)
    header:SetPoint('LEFT', QuestFrame, 'LEFT', 60, 0)
    header:SetPoint('RIGHT', QuestFrame, 'RIGHT', -60, 0)

    local closeButton = QuestFrameCloseButton
    DragonflightUIMixin:UIPanelCloseButton(closeButton)
    closeButton:SetPoint('TOPRIGHT', QuestFrame, 'TOPRIGHT', 1, 0)

    local decline = QuestFrameDeclineButton
    decline:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -6, 4)

    local cancel = QuestFrameCancelButton
    cancel:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -6, 4)

    local accept = QuestFrameAcceptButton
    accept:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT', 6, 4)

    local complete = QuestFrameCompleteQuestButton
    complete:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT', 6, 4)

    local gb = QuestFrameGoodbyeButton
    gb:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -6, 4)

    local greetGb = QuestFrameGreetingGoodbyeButton
    greetGb:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -6, 4)

    local completeP = QuestFrameCompleteButton
    completeP:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT', 6, 4)

    do
        local scroll = QuestDetailScrollFrame
        scroll:SetSize(300, 403)
        scroll:SetPoint('TOPLEFT', detail, 'TOPLEFT', 8, -65)

        local deltaX = 4
        local deltaY = 20
        local bar = QuestDetailScrollFrameScrollBar
        bar:SetPoint('TOPLEFT', scroll, 'TOPRIGHT', 6 - 5 + deltaX, -3 - deltaY)
        bar:SetPoint('BOTTOMLEFT', scroll, 'BOTTOMRIGHT', 6 - 5 + deltaX, 3 + deltaY)

        QuestDetailScrollFrameTop:Hide()
        QuestDetailScrollFrameMiddle:Hide()
        QuestDetailScrollFrameBottom:Hide()
    end

    do
        local scroll = QuestRewardScrollFrame
        scroll:SetSize(300, 403)
        scroll:SetPoint('TOPLEFT', reward, 'TOPLEFT', 8, -65)
    end

    do
        local scroll = QuestProgressScrollFrame
        scroll:SetSize(300, 403)
        scroll:SetPoint('TOPLEFT', progress, 'TOPLEFT', 8, -65)
    end

    do
        local scroll = QuestGreetingScrollFrame
        scroll:SetSize(300, 403)
        scroll:SetPoint('TOPLEFT', greeting, 'TOPLEFT', 8, -65)
    end

    do
        local tex = base .. 'questbackgroundparchment'
        local bg = frame:CreateTexture('DFQuestBackground')
        bg:SetTexture(tex)
        bg:SetTexCoord(0.0009765625, 0.29296875, 0.0009765625, 0.3984375)
        bg:SetSize(299, 407)
        bg:SetDrawLayer('BACKGROUND', 0)
        bg:SetPoint('TOPLEFT', detail, 'TOPLEFT', 7, -62)
    end

    do
        local port = QuestFramePortrait
        port:SetSize(62, 62)
        port:ClearAllPoints()
        port:SetPoint('TOPLEFT', frame, 'TOPLEFT', -5, 7)
        port:SetDrawLayer('OVERLAY', 6)
        port:SetParent(frame)

        frame.PortraitFrame = frame:CreateTexture('PortraitFrame')
        local pp = frame.PortraitFrame
        pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
        pp:SetTexCoord(0.0078125, 0.0078125, 0.0078125, 0.6171875, 0.6171875, 0.0078125, 0.6171875, 0.6171875)
        pp:SetSize(84, 84)
        pp:ClearAllPoints()
        pp:SetPoint('CENTER', port, 'CENTER', 0, 0)
        pp:SetDrawLayer('OVERLAY', 7)
    end

    -- default -16 
    ShowUIPanel(frame)
    frame:SetAttribute("UIPanelLayout-" .. "xoffset", 0);
    frame:SetAttribute("UIPanelLayout-" .. "yoffset", 0);
    HideUIPanel(frame)
end

function DragonflightUIMixin:ShowQuestXP()
    if not QuestLogFrame.DFQuestXP then

        local str = QuestLogDetailScrollChildFrame:CreateFontString('DragonflightUIQuestXPText', 'OVERLAY', 'QuestFont')
        str:SetText(REWARD_ITEMS)
        -- str:SetPoint('LEFT', _G["DragonflightUIQuestLogFrameTrackButton"], 'RIGHT', 10, 0)

        local strXP = QuestLogDetailScrollChildFrame:CreateFontString('DragonflightUIQuestXPText2', 'OVERLAY',
                                                                      'QuestFont')
        strXP:SetText(FormatLargeNumber(9999999) .. ' XP')
        strXP:SetPoint('LEFT', str, 'RIGHT', 15, 0)

        QuestLogFrame.DFQuestXP = str
        QuestLogFrame.DFQuestXP2 = strXP
    end

    local function hookFunc(questLogIndex)
        local point, relativeToOrig, relativePoint, xOfs, yOfs = QuestLogSpacerFrame:GetPoint(1)
        -- print('relativeTo', relativeToOrig:GetName())

        local relativeTo = relativeToOrig;

        if relativeToOrig == _G["QuestLogSpellLearnText"] then
            relativeTo = QuestLogItem1
        else
            local numChoices = GetNumQuestLogChoices(questLogIndex)
            local numRewards = GetNumQuestLogRewards(questLogIndex)

            -- print('choices:', numChoices, ', rewards:', numRewards)

            local num = numChoices + numRewards;
            if num > 0 then
                if numRewards % 2 == 0 then num = num - 1; end

                local choose = _G['QuestLogItem' .. num];
                if choose then relativeTo = choose end
                -- print('choose', choose:GetName())
            else
                -- print('leave')
            end
        end

        local str = QuestLogFrame.DFQuestXP
        local strXP = QuestLogFrame.DFQuestXP2
        local rewardText = _G['QuestLogRewardTitleText']
        -- local learnSpellText = _G["QuestLogSpellLearnText"];

        if rewardText:IsShown() then
            -- 'You will also receive' 
            str:SetText(REWARD_ITEMS)

            str:ClearAllPoints()
            str:SetPoint('TOPLEFT', relativeTo, 'BOTTOMLEFT', 0, -15)
            QuestFrame_SetAsLastShown(str, nil)
        else
            local material = QuestFrame_GetMaterial();
            rewardText:Show();
            QuestFrame_SetTitleTextColor(rewardText, material);
            QuestFrame_SetAsLastShown(rewardText, nil);

            -- 'You will receive'
            str:SetText(REWARD_ITEMS_ONLY)

            str:ClearAllPoints()
            str:SetPoint('TOPLEFT', rewardText, 'BOTTOMLEFT', 3, -5)
            QuestFrame_SetAsLastShown(str, nil)
        end

        local xp = GetQuestLogRewardXP()
        ---@diagnostic disable-next-line: param-type-mismatch
        strXP:SetText(FormatLargeNumber(xp) .. ' XP')

        if QuestLogFrame.DFCompletedQuestsFrame then QuestLogFrame.DFCompletedQuestsFrame:Update() end
    end

    hooksecurefunc('QuestFrameItems_Update', hookFunc)
end

function DragonflightUIMixin:GetCompletedQuestsAndXP()
    -- print('DragonflightUIMixin:GetCompletedQuestsAndXP()')
    -- C_QuestLog.GetMaxNumQuestsCanAccept() -- 20
    -- local maxQuests = C_QuestLog.GetMaxNumQuests(); -- 25
    local numEntries, numQuests = GetNumQuestLogEntries();
    local returnTable = {}
    returnTable.completedQuests = {};
    returnTable.numQuests = numQuests;
    returnTable.numCompletedQuests = 0;
    returnTable.numQuestXP = 0;

    if DF.API.Version.IsCata or DF.API.Version.IsMoP then
        local currentSelection = GetQuestLogSelection()
        -- print('current:', currentSelection)
        for i = 1, numEntries do
            --  
            local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent,
                  displayQuestID, isOnMap, hasLocalPOI, isTask, isBounty, isStory, isHidden, isScaling =
                GetQuestLogTitle(i);

            if isComplete then
                SelectQuestLogEntry(i)

                local questXP, questLevel = GetQuestLogRewardXP();
                returnTable.numCompletedQuests = returnTable.numCompletedQuests + 1;
                returnTable.numQuestXP = returnTable.numQuestXP + questXP;

                local info = {title = title, questID = questID, questXP = questXP, questLevel = questLevel};
                table.insert(returnTable.completedQuests, info);
            end
        end

        SelectQuestLogEntry(currentSelection)
        -- print('after:', GetQuestLogSelection())

        return returnTable;
    end
    for i = 1, numEntries do
        local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent,
              displayQuestID, isOnMap, hasLocalPOI, isTask, isBounty, isStory, isHidden, isScaling = GetQuestLogTitle(i);
        if isComplete then
            ---@diagnostic disable-next-line: redundant-parameter
            local questXP, questLevel = GetQuestLogRewardXP(questID);
            returnTable.numCompletedQuests = returnTable.numCompletedQuests + 1;
            returnTable.numQuestXP = returnTable.numQuestXP + questXP;

            local info = {title = title, questID = questID, questXP = questXP, questLevel = questLevel};
            table.insert(returnTable.completedQuests, info);
        end
    end

    return returnTable;
end

function DragonflightUIMixin:ChangeGossipFrame()
    local frame = GossipFrame
    local greeting = frame.GreetingPanel

    local regions = {greeting:GetRegions()}
    local port

    for k, child in ipairs(regions) do
        --
        -- print('child:', child:GetName())
        if child:GetObjectType() == 'Texture' then
            -- child:SetTexture('')
            -- print('child:', 'Texture', child:GetTexture(), child:GetWidth(), child:GetHeight())
            local tex = child:GetTexture()

            local layer = child:GetDrawLayer()

            if tex == 136785 then
                -- bottom left
                child:Hide()

            elseif tex == 136791 then
                -- bottom left corner
                child:Hide()
            elseif tex == 136792 then
                -- bottom right corner
                child:Hide()
            elseif tex == 136793 then
                --
                child:Hide()
            elseif tex == 136794 then
                --
                child:Hide()
            else
                -- child:Hide()
            end
        end
    end

    frame:SetSize(338, 496)
    greeting:SetSize(338, 496)

    if DF.API.Version.IsMoP then
        local slice = frame.NineSlice

        slice.TopLeftCorner = _G[frame:GetName() .. 'TopLeftCorner']
        slice.TopLeftCorner:Show()
        slice.TopRightCorner = _G[frame:GetName() .. 'TopRightCorner']

        slice.BottomLeftCorner = _G[frame:GetName() .. 'BtnCornerLeft']
        _G[frame:GetName() .. 'BotLeftCorner']:Hide()
        slice.BottomRightCorner = _G[frame:GetName() .. 'BotRightCorner']
        slice.BottomRightCorner = _G[frame:GetName() .. 'BtnCornerRight']
        _G[frame:GetName() .. 'BotRightCorner']:Hide()

        slice.TopEdge = _G[frame:GetName() .. 'TopBorder']
        slice.BottomEdge = _G[frame:GetName() .. 'BottomBorder']
        _G[frame:GetName() .. 'ButtonBottomBorder']:Hide()

        slice.LeftEdge = _G[frame:GetName() .. 'LeftBorder']
        slice.RightEdge = _G[frame:GetName() .. 'RightBorder']

        _G['GossipFramePortraitFrame']:Hide()
    end

    DragonflightUIMixin:AddNineSliceTextures(frame, true)
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(frame)
    DragonflightUIMixin:FrameBackgroundSolid(frame, true)

    local header = frame.TitleContainer
    header:ClearAllPoints()
    header:SetPoint('TOP', GossipFrame, 'TOP', 0, -5)
    header:SetPoint('LEFT', GossipFrame, 'LEFT', 60, 0)
    header:SetPoint('RIGHT', GossipFrame, 'RIGHT', -60, 0)

    local closeButton = frame.CloseButton
    DragonflightUIMixin:UIPanelCloseButton(closeButton)
    closeButton:SetPoint('TOPRIGHT', GossipFrame, 'TOPRIGHT', 1, 0)

    local gbButton = greeting.GoodbyeButton
    gbButton:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -6, 4)

    do
        local scroll = greeting.ScrollBox
        scroll:SetSize(300, 403)
        if DF.API.Version.IsMoP then
            scroll:SetPoint('TOPLEFT', frame, 'TOPLEFT', 8, -65)
        else
            scroll:SetPoint('TOPLEFT', greeting, 'TOPLEFT', 8, -65)
        end

        local bar = greeting.ScrollBar
        bar:SetPoint('TOPLEFT', scroll, 'TOPRIGHT', 6 - 5, -3)
        bar:SetPoint('BOTTOMLEFT', scroll, 'BOTTOMRIGHT', 6 - 5, 3)
    end

    do
        local tex = base .. 'questbackgroundparchment'
        local bg = frame:CreateTexture('DFQuestBackground')
        bg:SetTexture(tex)
        bg:SetTexCoord(0.0009765625, 0.29296875, 0.0009765625, 0.3984375)
        bg:SetSize(299, 407)
        bg:SetDrawLayer('BACKGROUND', 0)
        if DF.API.Version.IsMoP then
            bg:SetPoint('TOPLEFT', frame, 'TOPLEFT', 7, -62)
        else
            bg:SetPoint('TOPLEFT', greeting, 'TOPLEFT', 7, -62)
        end
    end

    do
        local port = GossipFramePortrait
        port:SetSize(62, 62)
        port:ClearAllPoints()
        port:SetPoint('TOPLEFT', frame, 'TOPLEFT', -5, 7)
        port:SetDrawLayer('OVERLAY', 6)
        port:SetParent(frame)

        frame.PortraitFrame = frame:CreateTexture('PortraitFrame')
        local pp = frame.PortraitFrame
        pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
        pp:SetTexCoord(0.0078125, 0.0078125, 0.0078125, 0.6171875, 0.6171875, 0.0078125, 0.6171875, 0.6171875)
        pp:SetSize(84, 84)
        pp:ClearAllPoints()
        pp:SetPoint('CENTER', port, 'CENTER', 0, 0)
        pp:SetDrawLayer('OVERLAY', 7)
    end

    -- default -16 
    ShowUIPanel(frame)
    frame:SetAttribute("UIPanelLayout-" .. "xoffset", 0);
    frame:SetAttribute("UIPanelLayout-" .. "yoffset", 0);
    HideUIPanel(frame)
end

function DragonflightUIMixin:ChangeTradeFrame()
    local frame = TradeFrame
    DragonflightUIMixin:PortraitFrameTemplate(frame)

    TradeFramePlayerPortrait:SetDrawLayer('OVERLAY', 6)

    do
        --
        local port = TradeFrameRecipientPortrait
        port:SetSize(62, 62)
        port:ClearAllPoints()
        port:SetPoint('TOPLEFT', frame, 'TOPRIGHT', -180, 7)
        port:SetDrawLayer('OVERLAY', 6)

        local tex = base .. 'uiframemetal2x'

        local pp = _G['TradeRecipientPortraitFrame']
        pp:SetTexture(tex)
        pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
        pp:SetSize(84, 84)
        pp:ClearAllPoints()
        pp:SetPoint('CENTER', port, 'CENTER', 0, 0)
        pp:SetDrawLayer('OVERLAY', 7)
    end

    do
        TradeFramePlayerNameText:SetDrawLayer('OVERLAY', 1)
        TradeFramePlayerNameText:ClearAllPoints()
        TradeFramePlayerNameText:SetPoint('TOPLEFT', frame, 'TOPLEFT', 65 - 6, -5)
        TradeFramePlayerNameText:SetSize(100, 12)

        TradeFrameRecipientNameText:SetDrawLayer('OVERLAY', 1)
        TradeFrameRecipientNameText:ClearAllPoints()
        TradeFrameRecipientNameText:SetPoint('TOPLEFT', frame, 'TOPLEFT', 230, -5)
        TradeFrameRecipientNameText:SetSize(80 + 8, 12)
    end

    do
        local tex = base .. 'UIFrameMetalVertical2x'

        local left = _G['TradeRecipientLeftBorder']
        left:SetTexture(tex)
        left:SetTexCoord(0.00195312, 0.294922, 0, 1)
        left:SetSize(75, 16)
        left:SetPoint('TOPLEFT', _G['TradeRecipientPortraitFrame'], 'BOTTOMLEFT', 8, 0 + 20)
        left:SetPoint('BOTTOMLEFT', _G['TradeRecipientBotLeftCorner'], 'TOPLEFT', 0, 0 - 20)

    end

    do
        local tex = base .. 'uiframemetal2x'

        local bottom = _G['TradeRecipientBotLeftCorner']
        bottom:SetTexture(tex)
        bottom:SetTexCoord(0.298828, 0.423828, 0.298828, 0.423828)
        bottom:SetSize(32, 32)
        bottom:SetPoint('BOTTOMLEFT', TradeFrame, 'BOTTOMRIGHT', -178 - 5, -3)
    end
end

function DragonflightUIMixin:ChangeQuestLogFrameEra()
    local frame = QuestLogFrame

    local regions = {frame:GetRegions()}
    local port

    for k, child in ipairs(regions) do
        --
        -- print('child:', child:GetName())
        if child:GetObjectType() == 'Texture' then
            -- child:SetTexture('')
            -- print('child:', 'Texture', child:GetTexture(), child:GetWidth(), child:GetHeight())
            local tex = child:GetTexture()

            if tex == 136797 then
                -- <Texture file="Interface\QuestFrame\UI-QuestLog-BookIcon">
                port = child
            else
                child:Hide()
            end
        end
    end

    do
        local left = frame:CreateTexture('DragonflightUIQuestLogDualPane-Left')
        left:SetSize(512, 445)
        left:SetTexture(base .. 'UI-QuestLogDualPane-Left')
        left:SetTexCoord(0, 0, 0, 0.86914002895355, 1, 0, 1, 0.86914002895355)
        left:SetPoint('TOPLEFT', frame, 'TOPLEFT', 0, 0)

        local right = frame:CreateTexture('DragonflightUIQuestLogDualPane-Right')
        right:SetSize(170, 445)
        right:SetTexture(base .. 'ui-questlogdualpane-right')
        right:SetTexCoord(0, 0, 0, 0.86914002895355, 0.6640625, 0, 0.6640625, 0.86914002895355)
        right:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', 0, 0)
    end

    frame:SetSize(682, 447)

    DragonflightUIMixin:AddNineSliceTextures(frame, true)
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(frame)
    DragonflightUIMixin:FrameBackgroundSolid(frame, true)

    do
        port:SetSize(62, 62)
        port:ClearAllPoints()
        port:SetPoint('TOPLEFT', frame, 'TOPLEFT', -5, 7)
        port:SetDrawLayer('OVERLAY', 6)
        port:SetParent(frame)
        port:Show()

        frame.PortraitFrame = frame:CreateTexture('PortraitFrame')
        local pp = frame.PortraitFrame
        pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
        pp:SetTexCoord(0.0078125, 0.0078125, 0.0078125, 0.6171875, 0.6171875, 0.0078125, 0.6171875, 0.6171875)
        pp:SetSize(84, 84)
        pp:ClearAllPoints()
        pp:SetPoint('CENTER', port, 'CENTER', 0, 0)
        pp:SetDrawLayer('OVERLAY', 7)
    end

    QuestLogTitleText:ClearAllPoints()
    QuestLogTitleText:SetPoint('TOP', QuestLogFrame, 'TOP', 0, -5)
    QuestLogTitleText:SetPoint('LEFT', QuestLogFrame, 'LEFT', 60, 0)
    QuestLogTitleText:SetPoint('RIGHT', QuestLogFrame, 'RIGHT', -60, 0)

    local closeButton = QuestLogFrameCloseButton
    DragonflightUIMixin:UIPanelCloseButton(closeButton)
    closeButton:ClearAllPoints()
    closeButton:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', 1, 0)

    local exit = QuestFrameExitButton
    exit:ClearAllPoints()
    exit:SetSize(80, 22)
    exit:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -7, 14)
    exit:SetText(CLOSE)

    QuestLogDetailScrollFrame:ClearAllPoints()
    QuestLogDetailScrollFrame:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -32, -77)
    QuestLogDetailScrollFrame:SetSize(298, 333)

    QuestLogDetailScrollFrameScrollBar:SetPoint('TOPLEFT', QuestLogDetailScrollFrame, 'TOPRIGHT', 6, -13)

    QuestLogListScrollFrame:ClearAllPoints()
    QuestLogListScrollFrame:SetPoint('TOPLEFT', frame, 'TOPLEFT', 19, -75)
    QuestLogListScrollFrame:SetSize(305, 335)

    QuestLogListScrollFrameScrollBar:SetPoint('TOPLEFT', QuestLogListScrollFrame, 'TOPRIGHT', 2, -14.5)
    QuestLogListScrollFrameScrollBar:SetPoint('BOTTOMLEFT', QuestLogListScrollFrame, 'BOTTOMRIGHT', 2, 15.25)

    local QUESTS_DISPLAYED_old = QUESTS_DISPLAYED
    QUESTS_DISPLAYED = 22
    for i = QUESTS_DISPLAYED_old + 1, QUESTS_DISPLAYED do
        --
        local btn = CreateFrame('BUTTON', 'QuestLogTitle' .. i, frame, 'QuestLogTitleButtonTemplate')
        btn:ClearAllPoints()
        btn:SetPoint('TOPLEFT', _G['QuestLogTitle' .. (i - 1)], 'BOTTOMLEFT', 0, 1)
        btn:SetID(i)
        btn:Hide()
    end

    local panel = CreateFrame('FRAME', 'DragonflightUIQuestLogControlPanel', frame)
    panel:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT', 18, 11)
    panel:SetSize(307, 26)

    QuestLogFrameAbandonButton:ClearAllPoints()
    QuestLogFrameAbandonButton:SetPoint('LEFT', panel, 'LEFT', 0, 1)
    QuestLogFrameAbandonButton:SetSize(110, 21)
    QuestLogFrameAbandonButton:SetText(ABANDON_QUEST_ABBREV)

    local track = CreateFrame('BUTTON', 'DragonflightUIQuestLogFrameTrackButton', frame, 'UIPanelButtonTemplate')
    track:SetPoint('RIGHT', panel, 'RIGHT', -3, 1)
    track:SetSize(100, 21)
    track:SetText(TRACK_QUEST_ABBREV)
    track:SetEnabled(true)
    track:SetScript('OnEnter', function(self)
        --
        GameTooltip_AddNewbieTip(self, TRACK_QUEST, 1.0, 1.0, 1.0, NEWBIE_TOOLTIP_TRACKQUEST, 1);
    end)
    track:SetScript('OnLeave', function(self)
        --
        GameTooltip:Hide()
    end)
    local DF_QuestLogTitleButton_OnClick = function(self)
        local questIndex = GetQuestLogSelection()

        -- Shift-click toggles quest-watch on this quest.
        if (IsQuestWatched(questIndex)) then
            local questID = GetQuestIDFromLogIndex(questIndex);
            for index, value in ipairs(QUEST_WATCH_LIST) do
                if (value.id == questID) then tremove(QUEST_WATCH_LIST, index); end
            end
            RemoveQuestWatch(questIndex);
            QuestWatch_Update();
        else
            -- Set error if no objectives
            if (GetNumQuestLeaderBoards(questIndex) == 0) then
                UIErrorsFrame:AddMessage(QUEST_WATCH_NO_OBJECTIVES, 1.0, 0.1, 0.1, 1.0);
                return;
            end
            -- Set an error message if trying to show too many quests
            if (GetNumQuestWatches() >= MAX_WATCHABLE_QUESTS) then
                UIErrorsFrame:AddMessage(format(QUEST_WATCH_TOO_MANY, MAX_WATCHABLE_QUESTS), 1.0, 0.1, 0.1, 1.0);
                return;
            end
            AutoQuestWatch_Insert(questIndex, QUEST_WATCH_NO_EXPIRE);
            QuestWatch_Update();
        end
        QuestLog_SetSelection(questIndex)
        QuestLog_Update();
    end
    track:SetScript('OnClick', function(self)
        --
        DF_QuestLogTitleButton_OnClick()
    end)

    QuestFramePushQuestButton:ClearAllPoints()
    QuestFramePushQuestButton:SetPoint('LEFT', QuestLogFrameAbandonButton, 'RIGHT', 0, 0)
    QuestFramePushQuestButton:SetPoint('RIGHT', track, 'LEFT', 0, 0)
    QuestFramePushQuestButton:SetWidth(1)
    QuestFramePushQuestButton:SetText(SHARE_QUEST_ABBREV)

    QuestLogTrack:Hide()

    do
        EmptyQuestLogFrame:ClearAllPoints()
        EmptyQuestLogFrame:SetPoint('TOPLEFT', frame, 'TOPLEFT', 19, -73)
        EmptyQuestLogFrame:SetSize(302, 356)

        hooksecurefunc(EmptyQuestLogFrame, "Show", function()
            EmptyQuestLogFrame:ClearAllPoints()
            EmptyQuestLogFrame:SetPoint('TOPLEFT', frame, 'TOPLEFT', 19, -73)
            EmptyQuestLogFrame:SetSize(302, 356)
        end)

        QuestLogNoQuestsText:ClearAllPoints()
        QuestLogNoQuestsText:SetPoint('CENTER', EmptyQuestLogFrame, 'CENTER', -6, 16)

        local regionsE = {EmptyQuestLogFrame:GetRegions()}

        for k, child in ipairs(regionsE) do
            --        
            if child:GetObjectType() == 'Texture' then child:Hide() end
        end

        local tl = EmptyQuestLogFrame:CreateTexture(nil, 'BACKGROUND')
        tl:SetSize(256, 256)
        tl:SetPoint('TOPLEFT', EmptyQuestLogFrame, 'TOPLEFT', 0, 0)
        tl:SetTexture(base .. 'UI-QuestLog-Empty-TopLeft')
        tl:SetTexCoord(0, 1.0, 0, 1.0)

        local bl = EmptyQuestLogFrame:CreateTexture(nil, 'BACKGROUND')
        bl:SetSize(256, 106)
        bl:SetPoint('TOPRIGHT', tl, 'BOTTOMRIGHT', 0, 0)
        bl:SetPoint('BOTTOMLEFT', EmptyQuestLogFrame, 'BOTTOMLEFT', 0, 0)
        bl:SetTexture(base .. 'UI-QuestLog-Empty-BotLeft')
        bl:SetTexCoord(0, 1.0, 0, 0.828125)

        local tr = EmptyQuestLogFrame:CreateTexture(nil, 'BACKGROUND')
        tr:SetSize(46, 256)
        tr:SetPoint('TOPRIGHT', EmptyQuestLogFrame, 'TOPRIGHT', 0, 0)
        tr:SetPoint('BOTTOMLEFT', tl, 'BOTTOMRIGHT', 0, 0)
        tr:SetTexture(base .. 'UI-QuestLog-Empty-TopRight')
        tr:SetTexCoord(0, 0.71875, 0, 1.0)

        local br = EmptyQuestLogFrame:CreateTexture(nil, 'BACKGROUND')
        br:SetSize(46, 256)
        br:SetPoint('BOTTOMRIGHT', EmptyQuestLogFrame, 'BOTTOMRIGHT', 0, 0)
        br:SetPoint('TOPLEFT', tl, 'BOTTOMRIGHT', 0, 0)
        br:SetTexture(base .. 'UI-QuestLog-Empty-BotRight')
        br:SetTexCoord(0, 0.71875, 0, 0.828125)
    end

    do
        local count = CreateFrame('FRAME', 'DragonflightUIQuestLogCount', frame, 'DFQuestLogCount')
        count:SetSize(82.8, 20) -- TODO
        count:SetPoint("TOPLEFT", frame, "TOPLEFT", 80, -41);

        local hPadding = 15;
        local width = QuestLogQuestCount:GetWidth();
        count:SetWidth(width + hPadding);

        QuestLogQuestCount:ClearAllPoints()
        QuestLogQuestCount:SetParent(count)
        QuestLogQuestCount:SetPoint('TOPRIGHT', _G['DragonflightUIQuestLogCountTopRight'], 'BOTTOMLEFT', 1, 3)
    end

    do
        -- quest xp
        local count = CreateFrame('FRAME', 'DragonflightUIQuestCompletedQuestsFrame', frame, 'DFQuestLogCount')
        count:SetSize(180, 20) -- TODO
        count:SetPoint("LEFT", _G['DragonflightUIQuestLogCount'], "RIGHT", 6, 0);

        local textOne = count:CreateFontString('DragonflightUICompletedQuests', 'OVERLAY', 'GameFontNormalSmall')
        textOne:SetPoint('TOPLEFT', _G['DragonflightUIQuestCompletedQuestsFrameTopLeft'], 'BOTTOMRIGHT', 1, 3)

        frame.DFCompletedQuestsFrame = count;

        count.Update = function()
            -- print('QuestLogFrame.DFCompletedQuestsFrame:Update()')
            local questXPInfo = DragonflightUIMixin:GetCompletedQuestsAndXP();

            local first = 'Completed: ' .. '|cffffffff' .. tostring(questXPInfo.numCompletedQuests) .. '/' ..
                              tostring(questXPInfo.numQuests) .. '|r';
            local second = 'XP: ' .. '|cffffffff' .. FormatLargeNumber(tostring(questXPInfo.numQuestXP)) .. '|r'
            textOne:SetText(first .. '   ' .. second);

            local hPadding = 15;
            local width = textOne:GetWidth();
            count:SetWidth(width + hPadding);
        end

        count.Update()
    end

    QuestLogExpandButtonFrame:ClearAllPoints()
    QuestLogExpandButtonFrame:SetPoint('TOPLEFT', frame, 'TOPLEFT', 70 - 47, -48)

    do
        local map = CreateFrame('BUTTON', 'DragonflightUIQuestLogFrameShowMapButton', frame)
        map:SetScript('OnClick', ToggleWorldMap)
        map:SetSize(48, 32)
        map:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', -25, -38)

        map:SetNormalTexture('Interface\\QuestFrame\\UI-QuestMap_Button')
        map:GetNormalTexture():SetTexCoord(0.125, 0.875, 0, 0.5)
        map:SetPushedTexture('Interface\\QuestFrame\\UI-QuestMap_Button')
        map:GetPushedTexture():SetTexCoord(0.125, 0.875, 0.5, 1.0)
        map:SetHighlightTexture('Interface\\Buttons\\ButtonHilight-Square')

        map:SetHighlightTexture('Interface\\Buttons\\ButtonHilight-Square')
        local high = map:GetHighlightTexture()
        high:SetSize(38, 25)
        high:ClearAllPoints()
        high:SetPoint('RIGHT', -7, 0)

        local text = map:CreateFontString('DragonflightUIQuestLogFrameShowMapButtonText', 'ARTWORK', 'GameFontNormal')
        text:SetText(SHOW_MAP)
        text:SetPoint('RIGHT', map, 'LEFT', 0, 0)
    end

    UIPanelWindows["QuestLogFrame"] = {
        area = "doublewide",
        pushable = 0,
        xoffset = 0,
        yoffset = 0,
        bottomClampOverride = 140 + 12,
        whileDead = 1,
        width = frame:GetWidth(),
        height = frame:GetHeight()
    };
end

function DragonflightUIMixin:ChangeQuestLogFrameCata()
    local frame = QuestLogFrame

    local regions = {frame:GetRegions()}
    local port

    for k, child in ipairs(regions) do
        --
        -- print('child:', child:GetName())
        if child:GetObjectType() == 'Texture' then
            -- child:SetTexture('')
            -- print('child:', 'Texture', child:GetTexture(), child:GetSize())
            local tex = child:GetTexture()

            if tex == 136797 then
                -- <Texture file="Interface\QuestFrame\UI-QuestLog-BookIcon">
                port = child
            elseif tex == 309665 then
                -- 	<Texture file="Interface\QuestFrame\UI-QuestLogDualPane-Left">
                -- child:Hide()
                child:SetTexture(base .. 'UI-QuestLogDualPane-Left')
            elseif tex == 309666 then
                -- <Texture file="Interface\QuestFrame\UI-QuestLogDualPane-RIGHT">
                -- child:Hide()          
                child:SetTexture(base .. 'ui-questlogdualpane-right')
            end
        end
    end

    -- DevTools_Dump(frame.NineSlice)
    if DF.API.Version.IsMoP then
        local slice = frame.NineSlice

        slice.TopLeftCorner = _G[frame:GetName() .. 'TopLeftCorner']
        slice.TopLeftCorner:Show()
        slice.TopRightCorner = _G[frame:GetName() .. 'TopRightCorner']

        slice.BottomLeftCorner = _G[frame:GetName() .. 'BtnCornerLeft']
        _G[frame:GetName() .. 'BotLeftCorner']:Hide()
        -- slice.BottomRightCorner = _G[frame:GetName() .. 'BotRightCorner']
        slice.BottomRightCorner = _G[frame:GetName() .. 'BtnCornerRight']
        _G[frame:GetName() .. 'BotRightCorner']:Hide()

        slice.TopEdge = _G[frame:GetName() .. 'TopBorder']
        slice.BottomEdge = _G[frame:GetName() .. 'BottomBorder']
        _G[frame:GetName() .. 'ButtonBottomBorder']:Hide()

        slice.LeftEdge = _G[frame:GetName() .. 'LeftBorder']
        slice.RightEdge = _G[frame:GetName() .. 'RightBorder']

        local br = _G['EmptyQuestLogFrameBackgroundBottomRight']
        br:ClearAllPoints()
        br:SetPoint('TOPLEFT', _G['EmptyQuestLogFrameBackgroundTopLeft'], 'BOTTOMRIGHT', 0, 0)
    end
    DragonflightUIMixin:AddNineSliceTextures(frame, true)
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(frame)

    QuestLogTitleText:ClearAllPoints()
    QuestLogTitleText:SetPoint('TOP', QuestLogFrame, 'TOP', 0, -5)
    QuestLogTitleText:SetPoint('LEFT', QuestLogFrame, 'LEFT', 60, 0)
    QuestLogTitleText:SetPoint('RIGHT', QuestLogFrame, 'RIGHT', -60, 0)
    DragonflightUIMixin:UIPanelCloseButton(QuestLogFrameCloseButton)
    QuestLogFrameCloseButton:SetPoint('TOPRIGHT', QuestLogFrame, 'TOPRIGHT', 1, 0)

    do
        port:SetSize(62, 62)
        port:ClearAllPoints()
        port:SetPoint('TOPLEFT', -5, 7)
        port:SetDrawLayer('OVERLAY', 6)

        local pp = frame.PortraitFrame
        pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
        pp:SetTexCoord(0.0078125, 0.0078125, 0.0078125, 0.6171875, 0.6171875, 0.0078125, 0.6171875, 0.6171875)
        pp:SetSize(84, 84)
        pp:ClearAllPoints()
        pp:SetPoint('CENTER', port, 'CENTER', 0, 0)
        pp:SetDrawLayer('OVERLAY', 7)
    end

    if DF.API.Version.IsMoP then
        --
        DragonflightUIMixin:FrameBackgroundSolidMoP(frame, true)
    else
        DragonflightUIMixin:FrameBackgroundSolid(frame, true)
    end

    do
        -- quest xp
        local count = CreateFrame('FRAME', 'DragonflightUIQuestCompletedQuestsFrame', frame, 'DFQuestLogCount')
        count:SetSize(180, 20) -- TODO
        count:SetPoint("LEFT", QuestLogCount, "RIGHT", 6, 0);

        local textOne = count:CreateFontString('DragonflightUICompletedQuests', 'OVERLAY', 'GameFontNormalSmall')
        textOne:SetPoint('TOPLEFT', _G['DragonflightUIQuestCompletedQuestsFrameTopLeft'], 'BOTTOMRIGHT', 1, 3)

        frame.DFCompletedQuestsFrame = count;

        count.Update = function()
            -- print('QuestLogFrame.DFCompletedQuestsFrame:Update()')
            local questXPInfo = DragonflightUIMixin:GetCompletedQuestsAndXP();

            local first = 'Completed: ' .. '|cffffffff' .. tostring(questXPInfo.numCompletedQuests) .. '/' ..
                              tostring(questXPInfo.numQuests) .. '|r';
            local second = 'XP: ' .. '|cffffffff' .. FormatLargeNumber(tostring(questXPInfo.numQuestXP)) .. '|r'
            textOne:SetText(first .. '   ' .. second);

            local hPadding = 15;
            local width = textOne:GetWidth();
            count:SetWidth(width + hPadding);
        end

        count.Update()

        hooksecurefunc('QuestLog_Update', function()
            -- print('QuestLog_Update')
            count.Update()
        end)
    end

    -- default -16 
    ShowUIPanel(frame)
    QuestLogFrame:SetAttribute("UIPanelLayout-" .. "xoffset", 0);
    QuestLogFrame:SetAttribute("UIPanelLayout-" .. "yoffset", 0);
    HideUIPanel(frame)
end

function DragonflightUIMixin:AddQuestLevel()

    local questInfo = function(id)
        local title, level, suggestedGroup, isHeader = GetQuestLogTitle(id)
        if not title or not level then return nil, nil, nil, nil, nil end

        local suffix = ''

        if suggestedGroup then
            if suggestedGroup == GROUP or suggestedGroup == ELITE then
                suffix = '+'
            elseif suggestedGroup == LFG_TYPE_DUNGEON then
                suffix = 'D'
            elseif suggestedGroup == RAID then
                suffix = 'R'
            elseif suggestedGroup == PVP then
                suffix = 'P'
            end
        end

        return title, level, suggestedGroup, isHeader, suffix
    end
    -- Details
    hooksecurefunc('QuestLog_UpdateQuestDetails', function()
        local id = GetQuestLogSelection()
        if not id then return end

        local title, level, suggestedGroup, isHeader, suffix = questInfo(id)
        if not title or not level then return end

        local questLogTitle = QuestLogQuestTitle or QuestInfoTitleHeader
        questLogTitle:SetText('[' .. level .. suffix .. '] ' .. title)
    end)

    -- Log

    if DF.Cata then
        --
        hooksecurefunc('QuestLogTitleButton_Resize', function(btn)
            --
            local questIndex = btn:GetID()

            local title, level, suggestedGroup, isHeader, suffix = questInfo(questIndex)

            if title and level and not isHeader then
                --
                local padding = (level > 0 and level < 10) and '0' or ''
                local questLogText = ' [' .. padding .. level .. suffix .. '] ' .. title

                local normal = btn.normalText
                normal:SetText(questLogText)
            end
        end)
    elseif DF.Era then
        --
        hooksecurefunc('QuestLog_Update', function()
            --
            local numEntries, numQuests = GetNumQuestLogEntries();
            if numEntries == 0 then return end

            local offset = FauxScrollFrame_GetOffset(QuestLogListScrollFrame)

            for i = 1, QUESTS_DISPLAYED do
                --
                local questIndex = i + offset

                if questIndex <= numEntries then
                    --

                    local logTitle = _G['QuestLogTitle' .. i]
                    local title, level, suggestedGroup, isHeader, suffix = questInfo(questIndex)

                    if title and level and not isHeader then
                        --
                        local padding = (level > 0 and level < 10) and '0' or ''
                        local questLogText = ' [' .. padding .. level .. suffix .. '] ' .. title
                        logTitle:SetText(questLogText)
                        QuestLogDummyText:SetText(questLogText)

                        local normal = _G['QuestLogTitle' .. i .. 'NormalText']
                        local check = _G['QuestLogTitle' .. i .. 'Check']

                        local textW = normal:GetWrappedWidth()
                        local dx = textW + 2
                        check:ClearAllPoints()
                        -- check:SetPoint('LEFT', normal, 'RIGHT', 2, 0)
                        check:SetPoint('LEFT', normal, 'LEFT', dx, 0)
                    end
                end
            end
        end)
    end
end

function DragonflightUIMixin:ChangeTalentsEra()
    -- print('DragonflightUIMixin:ChangeTalentsEra()')
    local frame = PlayerTalentFrame

    local regions = {frame:GetRegions()}

    local port

    for k, child in ipairs(regions) do
        --     
        if child:GetObjectType() == 'Texture' then
            local layer, layerNr = child:GetDrawLayer()
            -- print(layer, layerNr, child:GetTexture())
            if layer == 'BORDER' then child:Hide() end
            if layer == 'BACKGROUND' then child:Hide() end
        end
    end

    frame:SetSize(646, 468)

    DragonflightUIMixin:AddNineSliceTextures(frame, true)
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(frame)
    DragonflightUIMixin:FrameBackgroundSolid(frame, true)

    local closeButton = PlayerTalentFrameCloseButton
    DragonflightUIMixin:UIPanelCloseButton(closeButton)
    closeButton:ClearAllPoints()
    closeButton:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', 1, 0)

    PlayerTalentFrameTitleText:ClearAllPoints()
    PlayerTalentFrameTitleText:SetPoint('TOP', frame, 'TOP', 0, -5)
    PlayerTalentFrameTitleText:SetPoint('LEFT', frame, 'LEFT', 60, 0)
    PlayerTalentFrameTitleText:SetPoint('RIGHT', frame, 'RIGHT', -60, 0)

    do
        local port = frame:CreateTexture('DragonflightUIPlayerTalentFramePortrait')
        port:SetSize(62, 62)
        port:ClearAllPoints()
        port:SetPoint('TOPLEFT', frame, 'TOPLEFT', -5, 7)
        port:SetParent(frame)
        port:SetTexture('Interface\\Icons\\Ability_Marksmanship')
        SetPortraitToTexture(port, port:GetTexture())
        port:SetDrawLayer('OVERLAY', 6)
        port:Show()

        frame.PortraitFrame = frame:CreateTexture('DragonflightUIPlayerTalentFramePortraitFrame')
        local pp = frame.PortraitFrame
        pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
        pp:SetTexCoord(0.0078125, 0.0078125, 0.0078125, 0.6171875, 0.6171875, 0.0078125, 0.6171875, 0.6171875)
        pp:SetSize(84, 84)
        pp:ClearAllPoints()
        pp:SetPoint('CENTER', port, 'CENTER', 0, 0)
        pp:SetDrawLayer('OVERLAY', 7)
        -- pp:SetFrameLevel(4)
    end

    local scroll = PlayerTalentFrameScrollFrame
    scroll:ClearAllPoints()
    scroll:Hide()

    local bar = PlayerTalentFramePointsBar
    bar:ClearAllPoints()
    bar:Hide()

    for i = 1, 3 do
        local tab = _G['PlayerTalentFrameTab' .. i]
        tab:ClearAllPoints()
        tab:Hide()
    end

    local inset = CreateFrame('FRAME', 'DragonflightUIPlayerTalentFrameInset', frame, 'InsetFrameTemplate')
    inset:SetPoint('TOPLEFT', frame, 'TOPLEFT', 4, -60)
    inset:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -6, 26)
    inset:SetFrameLevel(1)
    frame.DFInset = inset

    -- DragonflightUITalentsFrameMixin
    local DFFrame = CreateFrame('FRAME', 'DragonflightUIPlayerTalentFrame', frame, 'DFPlayerTalentFrameTemplate')
    DFFrame:SetSize(32, 32)
    DFFrame:SetPoint('TOPLEFT', frame, 'TOPLEFT', 0, 0)

    ----
    frame:HookScript('OnShow', function()
        frame:SetAttribute("UIPanelLayout-width", frame:GetWidth());
        frame:SetAttribute("UIPanelLayout-" .. "xoffset", 0);
        frame:SetAttribute("UIPanelLayout-" .. "yoffset", 0);
        UpdateUIPanelPositions(frame)
    end)
end

function DragonflightUIMixin:ChangeLFGListingFrameEra()
    print('DragonflightUIMixin:ChangeLFGListingFrameEra()')
    local frame = LFGListingFrame
    local parentFrame = LFGParentFrame
    if not frame then return end

    DragonflightUIMixin:AddNineSliceTextures(frame, true)
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(frame)
    DragonflightUIMixin:FrameBackgroundSolid(frame, true)

    frame:SetSize(338 - 2, 424)
    parentFrame:SetSize(338 - 2, 424)

    _G['LFGListingFrameFrameBackgroundTop']:Hide()
    _G['LFGListingFrameFrameBackgroundBottom']:Hide()

    do
        local port = _G['LFGParentFramePortrait']
        port:SetSize(62, 62)
        port:ClearAllPoints()
        port:SetPoint('TOPLEFT', -5, 7)
        -- port:SetDrawLayer('OVERLAY', 6)

        frame.PortraitFrame = frame:CreateTexture('PortraitFrame')
        local pp = frame.PortraitFrame
        pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
        pp:SetTexCoord(0.0078125, 0.0078125, 0.0078125, 0.6171875, 0.6171875, 0.0078125, 0.6171875, 0.6171875)
        pp:SetSize(84, 84)
        pp:ClearAllPoints()
        pp:SetPoint('CENTER', port, 'CENTER', 0, 0)
        pp:SetDrawLayer('OVERLAY', 7)

        local icon = _G['LFGParentFramePortraitIcon']
        icon:SetDrawLayer('OVERLAY', 7)

        local text = _G['LFGParentFramePortraitTexture']
        text:SetDrawLayer('OVERLAY', 7)
    end
end

function DragonflightUIMixin:ChangeSpellbookEra()
    local frame = SpellBookFrame

    local regions = {frame:GetRegions()}

    local port

    for k, child in ipairs(regions) do
        --     
        if child:GetObjectType() == 'Texture' then
            local layer, layerNr = child:GetDrawLayer()
            -- print(layer, layerNr, child:GetTexture())
            if layer == 'ARTWORK' then child:Hide() end
            if layer == 'BACKGROUND' then
                if child:GetTexture() == 136830 then
                    -- port
                    port = child
                end
            end
        end
    end

    frame:SetSize(550, 525)

    DragonflightUIMixin:AddNineSliceTextures(frame, true)
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(frame)
    DragonflightUIMixin:FrameBackgroundSolid(frame, true)

    local closeButton = SpellBookCloseButton
    DragonflightUIMixin:UIPanelCloseButton(closeButton)
    closeButton:ClearAllPoints()
    closeButton:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', 1, 0)

    SpellBookTitleText:ClearAllPoints()
    SpellBookTitleText:SetPoint('TOP', frame, 'TOP', 0, -5)
    SpellBookTitleText:SetPoint('LEFT', frame, 'LEFT', 60, 0)
    SpellBookTitleText:SetPoint('RIGHT', frame, 'RIGHT', -60, 0)

    do
        port:SetSize(62, 62)
        port:ClearAllPoints()
        port:SetPoint('TOPLEFT', frame, 'TOPLEFT', -5, 7)
        port:SetDrawLayer('OVERLAY', 6)
        port:SetParent(frame)
        port:Show()

        SetPortraitToTexture(port, port:GetTexture())

        frame.PortraitFrame = frame:CreateTexture('PortraitFrame')
        local pp = frame.PortraitFrame
        pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
        pp:SetTexCoord(0.0078125, 0.0078125, 0.0078125, 0.6171875, 0.6171875, 0.0078125, 0.6171875, 0.6171875)
        pp:SetSize(84, 84)
        pp:ClearAllPoints()
        pp:SetPoint('CENTER', port, 'CENTER', 0, 0)
        pp:SetDrawLayer('OVERLAY', 7)
    end

    SpellBookSkillLineTab1:SetPoint('TOPLEFT', SpellBookSideTabsFrame, 'TOPRIGHT', 0, -36)

    SpellBookNextPageButton:ClearAllPoints()
    SpellBookNextPageButton:SetPoint('BOTTOMRIGHT', SpellBookPageNavigationFrame, 'BOTTOMRIGHT', -31, 26)

    SpellBookPrevPageButton:ClearAllPoints()
    SpellBookPrevPageButton:SetPoint('BOTTOMRIGHT', SpellBookPageNavigationFrame, 'BOTTOMRIGHT', -66, 26)

    --[[   -- TODO: Taint :(
    frame:HookScript('OnMouseWheel', function(self, arg1)
        --
        -- print('OnMouseWheel', arg1)
        if arg1 > 0 then
            -- 1 for spinning up
            SpellBookPrevPageButton:Click()

        elseif arg1 < 0 then
            -- -1 for spinning down
            SpellBookNextPageButton:Click()
        end
    end)
    frame:SetHitRectInsets(0, 0, 0, 0); ]]

    SpellBookPageText:ClearAllPoints()
    SpellBookPageText:SetPoint('BOTTOMRIGHT', SpellBookPageNavigationFrame, 'BOTTOMRIGHT', -110, 38)

    do
        --
        local inset = CreateFrame('FRAME', 'DragonflightUISpellBookInset', frame, 'InsetFrameTemplate')
        inset:SetPoint('TOPLEFT', frame, 'TOPLEFT', 4, -24)
        inset:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -6, 4)
        inset:SetFrameLevel(1)

        local first = frame:CreateTexture('DragonflightUISpellBookPage1', 'BACKGROUND')
        first:SetTexture(base .. 'Spellbook-Page-1')
        first:SetPoint('TOPLEFT', frame, 'TOPLEFT', 7, -25)

        local second = frame:CreateTexture('DragonflightUISpellBookPage2', 'BACKGROUND')
        second:SetTexture(base .. 'Spellbook-Page-2')
        second:SetPoint('TOPLEFT', first, 'TOPRIGHT', 0, 0)

        local bg = frame:CreateTexture('DragonflightUISpellBookBG', 'BACKGROUND')
        bg:SetTexture(base .. 'UI-Background-RockCata')
        bg:SetPoint('TOPLEFT', frame, 'TOPLEFT', 2, -21)
        bg:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -2, 2)
        bg:SetDrawLayer('BACKGROUND', -6)
        -- TODO: bugged?
        -- bg:SetVertTile(true) 
        -- bg:SetHorizTile(true)
    end

    do
        --
        for i = 1, 12 do
            --
            local btn = _G['SpellButton' .. i]
            btn:ClearAllPoints()

            -- modulo
            local modulo = i - math.floor(i / 2) * 2

            if i == 1 then
                btn:SetPoint('TOPLEFT', SpellBookSpellIconsFrame, 'TOPLEFT', 100, -72)

            elseif modulo == 0 then
                btn:SetPoint('TOPLEFT', _G['SpellButton' .. (i - 1)], 'TOPLEFT', 225, 0)
            elseif modulo == 1 then
                btn:SetPoint('TOPLEFT', _G['SpellButton' .. (i - 2)], 'BOTTOMLEFT', 0, -29)
            end

            local first = btn:CreateTexture('TextBackground', 'BACKGROUND')
            first:SetTexture(base .. 'Spellbook-Parts')
            first:SetPoint('TOPLEFT', _G['SpellButton' .. i .. 'Highlight'], 'TOPRIGHT', -4, 0 - 1)
            first:SetSize(167, 39)
            first:SetTexCoord(0.31250000, 0.96484375, 0.37109375, 0.52343750)

            local second = btn:CreateTexture('TextBackground2', 'BACKGROUND')
            second:SetTexture(base .. 'Spellbook-Parts')
            second:SetPoint('TOPLEFT', _G['SpellButton' .. i .. 'Highlight'], 'TOPRIGHT', -4, 0 - 1)
            second:SetSize(167, 39)
            second:SetTexCoord(0.31250000, 0.96484375, 0.37109375, 0.52343750)

            local spellName = _G['SpellButton' .. i .. 'SpellName']
            spellName:SetDrawLayer('ARTWORK', 6)

            local bg = _G['SpellButton' .. i .. 'Background']
            bg:ClearAllPoints()
            bg:SetSize(43, 43)
            bg:SetTexture(base .. 'Spellbook-Parts')
            bg:SetTexCoord(0.79296875, 0.96093750, 0.00390625, 0.17187500)
            bg:SetPoint('CENTER', btn, 'CENTER', 0, 0)

            local slotframe = btn:CreateTexture('DragonflightUISpellbookSlotFrame', 'OVERLAY')
            slotframe:SetDrawLayer('OVERLAY', -1)
            slotframe:SetTexture(base .. 'Spellbook-Parts')
            slotframe:SetTexCoord(0.00390625, 0.27734375, 0.44140625, 0.69531250)
            slotframe:SetSize(70, 65)
            slotframe:SetPoint('CENTER', btn, 'CENTER', 1.5, 0)
            btn.DFSlotFrame = slotframe

            btn.ShowSlotFrame = function(show)
                if show then
                    btn.DFSlotFrame:Show()
                else
                    btn.DFSlotFrame:Hide()
                end
            end
        end

        do
            --
            for i = 1, 8 do
                -- SpellBookSkillLineTab1
                local skill = _G['SpellBookSkillLineTab' .. i]

                local children = {skill:GetRegions()}

                for k, child in ipairs(children) do
                    if child:GetObjectType() == 'Texture' then
                        local tex = child:GetTexture()
                        if tex == 136831 then
                            -- 
                            -- child:Hide() 
                            child:SetTexture(base .. 'spellbook-skilllinetab')
                        end
                    end
                end
            end

        end

        hooksecurefunc('SpellButton_UpdateButton', function(self)
            --
            local name = self:GetName()

            local spellname = _G[name .. 'SpellName']
            spellname:ClearAllPoints()
            spellname:SetPoint('LEFT', self, 'RIGHT', 8, 4)
            spellname:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

            local icon = _G[name .. 'IconTexture']

            if self.isPassive then
                self.ShowSlotFrame(false)
            else
                self.ShowSlotFrame(icon:IsVisible())
            end
        end)
    end

    local checkbox = ShowAllSpellRanksCheckBox or ShowAllSpellRanksCheckbox
    checkbox:ClearAllPoints()
    checkbox:SetPoint('BOTTOMLEFT', _G['SpellButton1'], 'TOPLEFT', -4, 8)

    for i = 1, 5 do
        local tab = _G['SpellBookFrameTabButton' .. i]

        if tab then
            --         
            -- DragonflightUIMixin:CharacterFrameTabButtonTemplate(tab)
            -- if i > 1 then tab.DFChangePoint = true end
            if i == 1 then
                tab:ClearAllPoints()
                tab:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT', 12, 19)
            end
        end
    end

    UIPanelWindows["SpellBookFrame"] = {
        whileDead = 1,
        height = 424,
        width = SpellBookFrame:GetWidth() + 32,
        bottomClampOverride = 152,
        xoffset = 0,
        yoffset = 0,
        pushable = 3,
        area = "left"
    }
    UpdateUIPanelPositions(SpellBookFrame)
end

function DragonflightUIMixin:SpellbookEraAddTabs()
    local frame = SpellBookFrame

    -- remove default
    for i = 1, 5 do
        local tab = _G['SpellBookFrameTabButton' .. i]
        if tab then
            tab:ClearAllPoints()
            tab:Hide()
        end
    end

    local tabFrame = CreateFrame('FRAME', 'DragonflightUISpellbookFrameTabFrame', SpellBookFrame, 'SecureFrameTemplate')
    function tabFrame:OnEvent(event, arg1)
        if event == 'PLAYER_REGEN_ENABLED' then
            --
            -- print('PLAYER_REGEN_ENABLED', self.ShouldUpdate)
            if self.ShouldUpdate then self:UpdateTabs() end
        end
    end
    tabFrame:SetScript('OnEvent', tabFrame.OnEvent)
    tabFrame:RegisterEvent('PLAYER_REGEN_ENABLED')

    SpellBookFrame.DFTabFrame = tabFrame
    local numTabs = 3
    tabFrame.numTabs = numTabs
    tabFrame.Tabs = {}

    for i = 1, 3 do
        local tab = CreateFrame('BUTTON', 'DragonflightUISpellBookFrameTabButton' .. i, tabFrame,
                                'DFCharacterFrameTabButtonTemplate', i)
        ---@diagnostic disable-next-line: param-type-mismatch
        tab:SetParent(tabFrame)
        local text = _G[tab:GetName() .. 'Text']
        tinsert(tabFrame.Tabs, i, tab)

        DragonflightUIMixin:CharacterFrameTabButtonTemplate(tab, true, true)

        tab:SetAttribute('type', 'macro')

        tab:SetScript('PostClick', function(self, button, down)
            --        
            DragonflightUICharacterTabMixin:Tab_OnClick(self, tabFrame)
        end)

        if i == 1 then
            tab:ClearAllPoints()
            tab:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT', 12, 1)
            text:SetText(SPELLBOOK)
            tab:SetScript('OnEnter', function(self)
                --
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
                GameTooltip:SetText(MicroButtonTooltipText(tab:GetText(), 'TOGGLESPELLBOOK'), 1.0, 1.0, 1.0);
            end)
        elseif i == 2 then
            tab.DFChangePoint = true
            tab:SetPoint('LEFT', _G['DragonflightUISpellBookFrameTabButton' .. (i - 1)], 'RIGHT', 0, 0)
            text:SetText(TRADE_SKILLS)
            tab:SetScript('OnEnter', function(self)
                --
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
                GameTooltip:SetText(MicroButtonTooltipText(tab:GetText(), ''), 1.0, 1.0, 1.0);
            end)
        elseif i == 3 then
            tab.DFChangePoint = true
            tab:SetPoint('LEFT', _G['DragonflightUISpellBookFrameTabButton' .. (i - 1)], 'RIGHT', 0, 0)
            text:SetText(PET)
            tab:SetScript('OnEnter', function(self)
                --
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
                GameTooltip:SetText(MicroButtonTooltipText(tab:GetText(), SpellBookFrameTabButton2.binding), 1.0, 1.0,
                                    1.0);
            end)
        end
        DragonflightUIMixin:TabResize(tab)
    end

    function tabFrame:UpdateTabs()
        if InCombatLockdown() then
            -- prevent unsecure update in combat TODO: message?
            self.ShouldUpdate = true
            return
        end
        self.ShouldUpdate = false

        local numTabs = PetHasSpellbook() and 3 or 2

        local tab1 = self.Tabs[1]
        local tab2 = self.Tabs[2]
        local tab3 = self.Tabs[3]

        if numTabs == 2 then
            tab3:Hide()

            tab1:SetAttribute('macrotext', "/click DragonflightUISpellbookProfessionFrameHideButton")
            tab2:SetAttribute('macrotext', "/click DragonflightUISpellbookProfessionFrameShowButton")

            if self.selectedTab == 3 then
                --
                DragonflightUICharacterTabMixin:Tab_OnClick(tab1, self)
            end
        else
            -- PET
            tab3:Show()

            tab1:SetAttribute('macrotext',
                              "/click SpellBookFrameTabButton1\n/click DragonflightUISpellbookProfessionFrameHideButton")
            tab2:SetAttribute('macrotext', "/click DragonflightUISpellbookProfessionFrameShowButton")
            tab3:SetAttribute('macrotext',
                              "/click SpellBookFrameTabButton2\n/click DragonflightUISpellbookProfessionFrameHideButton")
        end
    end

    DragonflightUICharacterTabMixin:Tab_OnClick(_G['DragonflightUISpellBookFrameTabButton1'], tabFrame)
    tabFrame:UpdateTabs()

    PetFrame:HookScript('OnShow', function()
        --
        -- print('OnShow PETS')
        tabFrame:UpdateTabs()
    end)
    PetFrame:HookScript('OnHide', function()
        --
        -- print('OnShow PETS')
        tabFrame:UpdateTabs()
    end)
end

function DragonflightUIMixin:SpellbookEraProfessions()
    local frame = CreateFrame('FRAME', 'DragonflightUISpellBookProfessionFrame', SpellBookFrame,
                              'DFSpellBookProfessionFrame')
    frame:SetSize(550, 525)
    -- frame:SetPoint('LEFT', SpellBookFrame, 'RIGHT', 200, 0)
    frame:SetPoint('TOPLEFT', SpellBookFrame, 'TOPLEFT', 0, 0)
    frame:SetFrameLevel(69)
    frame:Hide()
    SpellBookFrame.DFSpellBookProfessionFrame = frame

    frame.buttonShow = CreateFrame("Button", "DragonflightUISpellbookProfessionFrameShowButton", frame,
                                   "SecureHandlerClickTemplate");
    frame.buttonShow:SetAttribute("_onclick", [[      
        local frame = self:GetFrameRef("ProfessionFrame");
        frame:Show();    
        
        -- local tabs = self:GetFrameRef("TabsFrame");
        -- tabs:Hide();   
    ]]);
    frame.buttonShow:SetFrameRef("ProfessionFrame", frame)
    -- frame.buttonShow:SetFrameRef("TabsFrame", SpellBookSideTabsFrame)

    ---@diagnostic disable-next-line: param-type-mismatch
    frame.buttonShow:SetAllPoints(frame);
    frame:SetAttribute("addchild", frame.buttonShow);

    frame.buttonHide = CreateFrame("Button", "DragonflightUISpellbookProfessionFrameHideButton", frame,
                                   "SecureHandlerClickTemplate");
    frame.buttonHide:SetAttribute("_onclick", [[      
        local frame = self:GetFrameRef("ProfessionFrame");
        frame:Hide();   
        
        -- local tabs = self:GetFrameRef("TabsFrame");
        -- tabs:Show();    
    ]]);
    frame.buttonHide:SetFrameRef("ProfessionFrame", frame)
    -- frame.buttonHide:SetFrameRef("TabsFrame", SpellBookSideTabsFrame)
    ---@diagnostic disable-next-line: param-type-mismatch
    frame.buttonHide:SetAllPoints(frame);
    frame:SetAttribute("addchild", frame.buttonHide);

    -- local showButton = CreateFrame('BUTTON', 'DragonflightUISpellbookProfessionFrameShowButton', SpellBookFrame,
    --                                'SecureActionButtonTemplate')
    -- showButton:SetAttribute('type', 'macro')
    -- showButton:SetAttribute('macrotext', "")
    -- showButton:SetScript('PostClick', function(self, button, down)
    --     --
    --     -- SpellBookFrame.DFSpellBookProfessionFrame:Show()
    -- end)
    -- SpellBookFrame.DFShowButton = showButton

    DragonflightUIMixin:AddNineSliceTextures(frame, true)
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(frame)
    DragonflightUIMixin:FrameBackgroundSolid(frame, true)

    -- local closeButton = CreateFrame('BUTTON', 'DragonflightUISpellbookProfessionFrameCloseButton', frame,
    --                                 'UIPanelCloseButton')
    -- DragonflightUIMixin:UIPanelCloseButton(closeButton)
    -- closeButton:ClearAllPoints()
    -- closeButton:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', 1, 0)
    SpellBookCloseButton:SetFrameLevel(80)

    -- closeButton:SetScript('OnClick', function(self)
    --     --
    --     HideUIPanel(SpellBookFrame)
    -- end)

    local titleText = frame:CreateFontString('DragonflightUISpellbookProfessionFrameTitleText', 'ARTWORK',
                                             'GameFontNormal')
    titleText:SetPoint('TOP', frame, 'TOP', 0, -5)
    titleText:SetPoint('LEFT', frame, 'LEFT', 60, 0)
    titleText:SetPoint('RIGHT', frame, 'RIGHT', -60, 0)
    titleText:SetText(TRADE_SKILLS)

    do
        local port = frame:CreateTexture('DragonflightUISpellbookProfessionFramePortrait')
        port:SetSize(62, 62)
        port:ClearAllPoints()
        port:SetPoint('TOPLEFT', frame, 'TOPLEFT', -5, 7)
        ---@diagnostic disable-next-line: param-type-mismatch
        port:SetParent(frame)
        port:SetTexture(136830)
        ---@diagnostic disable-next-line: param-type-mismatch
        SetPortraitToTexture(port, port:GetTexture())
        port:SetDrawLayer('OVERLAY', 6)
        port:Show()

        frame.PortraitFrame = frame:CreateTexture('DragonflightUISpellbookProfessionFramePortraitFrame')
        local pp = frame.PortraitFrame
        pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
        pp:SetTexCoord(0.0078125, 0.0078125, 0.0078125, 0.6171875, 0.6171875, 0.0078125, 0.6171875, 0.6171875)
        pp:SetSize(84, 84)
        pp:ClearAllPoints()
        pp:SetPoint('CENTER', port, 'CENTER', 0, 0)
        pp:SetDrawLayer('OVERLAY', 7)
        -- pp:SetFrameLevel(4)
    end

    do
        -- TODO different color
        local inset = CreateFrame('FRAME', 'DragonflightUISpellBookInset', frame, 'InsetFrameTemplate')
        inset:SetPoint('TOPLEFT', frame, 'TOPLEFT', 4, -24)
        inset:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -6, 4)
        inset:SetFrameLevel(1)

        local first = frame:CreateTexture('DragonflightUISpellBookPage1', 'BACKGROUND')
        first:SetTexture(base .. 'Professions-Book-Left')
        first:SetPoint('TOPLEFT', frame, 'TOPLEFT', 7, -25)

        local second = frame:CreateTexture('DragonflightUISpellBookPage2', 'BACKGROUND')
        second:SetTexture(base .. 'Professions-Book-Right')
        second:SetPoint('TOPLEFT', first, 'TOPRIGHT', 0, 0)

        local bg = frame:CreateTexture('DragonflightUISpellBookBG', 'BACKGROUND')
        bg:SetTexture(base .. 'UI-Background-RockCata')
        bg:SetPoint('TOPLEFT', frame, 'TOPLEFT', 2, -21)
        bg:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -2, 2)
        bg:SetDrawLayer('BACKGROUND', -6)
        -- TODO: bugged?
        -- bg:SetVertTile(true) 
        -- bg:SetHorizTile(true)
    end

    -- Mixin(frame, DragonFlightUIProfessionSpellbookMixin)
    frame:InitHook()
    frame:Update()

    if SpellBookFrame_Update then
        hooksecurefunc('SpellBookFrame_Update', function()
            --
            -- print('SpellBookFrame_Update')
            frame:Update()
        end)
    end
end

function DragonflightUIMixin:ChangeWrathPVPFrame()
    local frame = _G['PVPFrame']

    local regions = {frame:GetRegions()}

    for k, child in ipairs(regions) do
        --     
        if child:GetObjectType() == 'Texture' then
            local layer, layerNr = child:GetDrawLayer()
            -- print(layer, layerNr, child:GetTexture())
            if layer == 'ARTWORK' then child:Hide() end
        end
    end

    frame.PortraitFrame = frame:CreateTexture('PortraitFrame')
end

function DragonflightUIMixin:AddNineSliceTextures(frame, portrait)
    if frame.NineSlice then return end

    frame.NineSlice = {}
    local slice = frame.NineSlice

    slice.TopLeftCorner = frame:CreateTexture('TopLeftCorner')
    slice.TopRightCorner = frame:CreateTexture('TopRightCorner')
    slice.BottomLeftCorner = frame:CreateTexture('BottomLeftCorner')
    slice.BottomRightCorner = frame:CreateTexture('BottomRightCorner')

    slice.TopEdge = frame:CreateTexture('TopEdge')
    slice.BottomEdge = frame:CreateTexture('BottomEdge')

    slice.LeftEdge = frame:CreateTexture('LeftEdge')
    slice.RightEdge = frame:CreateTexture('RightEdge')

    frame.Bg = CreateFrame('FRAME', 'Bg', frame, 'FlatPanelBackgroundTemplate')
    frame.Bg:SetPoint('TOPLEFT', frame, 'TOPLEFT', 7, -18)
    frame.Bg:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -3, 3)
    frame.Bg:SetFrameLevel(0)

    if portrait then frame.PortraitFrame = frame:CreateTexture('PortraitFrame') end
end

function DragonflightUIMixin:FrameBackgroundSolid(frame, streak)
    local top = frame.Bg.TopSection
    if not top then return end

    top:SetTexture(base .. 'ui-background-rock')
    top:ClearAllPoints()
    top:SetPoint('TOPLEFT', frame.Bg, 'TOPLEFT', 0, 0)
    top:SetPoint('BOTTOMRIGHT', frame.Bg.BottomRight, 'BOTTOMRIGHT', 0, 0)
    top:SetDrawLayer('BACKGROUND', 2)

    if streak then
        --[[      <Texture parentKey="TopTileStreak" hidden="false" file="Interface/AddOns/DragonflightUI/Textures/UI/uiframehorizontal">
        <Size x="256" y="43" />
        <Anchors>
            <Anchor point="TOPLEFT" x="6" y="-21" />
            <Anchor point="TOPRIGHT" x="-2" y="-21" />
        </Anchors>
        <TexCoords left="0" right="1" top="0.0078125" bottom="0.34375" />
    </Texture> ]]
        local TopTileStreak = _G[frame:GetName() .. 'TopTileStreaks'] or frame:CreateTexture()
        TopTileStreak:ClearAllPoints()
        TopTileStreak:SetSize(256, 43)
        TopTileStreak:SetTexture(base .. 'uiframehorizontal')
        TopTileStreak:SetTexCoord(0, 1, 0.0078125, 0.34375)
        TopTileStreak:SetPoint('TOPLEFT', 6, -21)
        TopTileStreak:SetPoint('TOPRIGHT', -2, -21)
    end
end

-- MoP, e.g. QuestLogFrame or TaxiFrame
function DragonflightUIMixin:FrameBackgroundSolidMoP(frame, streak)
    -- print('~FrameBackgroundSolidMoP~', frame:GetName(), streak, top)
    local bg = _G[frame:GetName() .. 'Bg']
    if not bg then return end

    bg:SetTexture(base .. 'ui-background-rock')
    bg:SetDrawLayer('BACKGROUND', -2)

    if streak then
        local TopTileStreak = _G[frame:GetName() .. 'TopTileStreaks'] or frame:CreateTexture()
        TopTileStreak:SetSize(256, 43)
        TopTileStreak:SetTexture(base .. 'uiframehorizontal')
        TopTileStreak:SetTexCoord(0, 1, 0.0078125, 0.34375)
        TopTileStreak:SetPoint('TOPLEFT', 6, -21)
        TopTileStreak:SetPoint('TOPRIGHT', -2, -21)
    end
end

function DragonflightUIMixin:ButtonFrameTemplateNoPortrait(frame)
    -- print('DragonflightUIMixin:ButtonFrameTemplateNoPortrait(frame)', frame:GetName())

    local slice = frame.NineSlice

    -- corner
    if slice.TopLeftCorner then
        local tex = base .. 'uiframemetal2x'

        local tlc = slice.TopLeftCorner
        tlc:ClearAllPoints()
        tlc:SetTexture(tex)
        tlc:SetTexCoord(0.00195312, 0.294922, 0.00195312, 0.294922)
        tlc:SetSize(75, 74)
        tlc:SetPoint('TOPLEFT', -12, 16)

        local trc = slice.TopRightCorner
        trc:ClearAllPoints()
        trc:SetTexture(tex)
        trc:SetTexCoord(0.298828, 0.591797, 0.00195312, 0.294922)
        trc:SetSize(75, 74)
        trc:SetPoint('TOPRIGHT', 4, 16)

        local blc = slice.BottomLeftCorner
        blc:ClearAllPoints()
        blc:SetTexture(tex)
        blc:SetTexCoord(0.298828, 0.423828, 0.298828, 0.423828)
        blc:SetSize(32, 32)
        blc:SetPoint('BOTTOMLEFT', -12, -3)

        local brc = slice.BottomRightCorner
        brc:ClearAllPoints()
        brc:SetTexture(tex)
        brc:SetTexCoord(0.427734, 0.552734, 0.298828, 0.423828)
        brc:SetSize(32, 32)
        brc:SetPoint('BOTTOMRIGHT', 4, -3)
    end

    -- edge bottom/top
    if slice.TopEdge then
        local tex = base .. 'UIFrameMetalHorizontal2x'

        local te = slice.TopEdge
        te:ClearAllPoints()
        te:SetTexture(tex)
        te:SetTexCoord(0, 1, 0.00390625, 0.589844)
        te:SetSize(32, 74)
        te:SetPoint('TOPLEFT', slice.TopLeftCorner, 'TOPRIGHT', 0, 0)
        te:SetPoint('TOPRIGHT', slice.TopRightCorner, 'TOPLEFT', 0, 0)

        local be = slice.BottomEdge
        be:ClearAllPoints()
        be:SetTexture(tex)
        be:SetTexCoord(0, 0.5, 0.597656, 0.847656)
        be:SetSize(16, 32)
        be:SetPoint('TOPLEFT', slice.BottomLeftCorner, 'TOPRIGHT', 0, 0)
        be:SetPoint('TOPRIGHT', slice.BottomRightCorner, 'TOPLEFT', 0, 0)
    end

    -- edge left/right
    if slice.LeftEdge then
        local tex = base .. 'UIFrameMetalVertical2x'

        local le = slice.LeftEdge
        le:SetTexture(tex)
        le:SetTexCoord(0.00195312, 0.294922, 0, 1)
        le:SetSize(75, 16)
        le:SetPoint('TOPLEFT', slice.TopLeftCorner, 'BOTTOMLEFT', 0, 0)
        le:SetPoint('BOTTOMLEFT', slice.BottomLeftCorner, 'TOPLEFT', 0, 0)

        local re = slice.RightEdge
        re:SetTexture(tex)
        re:SetTexCoord(0.298828, 0.591797, 0, 1)
        re:SetSize(75, 16)
        re:SetPoint('TOPRIGHT', slice.TopRightCorner, 'BOTTOMRIGHT', 0, 0)
        re:SetPoint('BOTTOMRIGHT', slice.BottomRightCorner, 'TOPRIGHT', 0, 0)
    end

    local bg = frame.Bg
    bg:SetPoint('TOPLEFT', frame, 'TOPLEFT', 3, -18)

    local closeBtn = frame.ClosePanelButton
    if closeBtn then
        DragonflightUIMixin:UIPanelCloseButton(closeBtn)
        closeBtn:SetPoint('TOPRIGHT', 1, 0)
    end
end

--[[ 
["Interface/FrameGeneral/UIFrameMetal2x"]={
    ["UI-Frame-Metal-CornerBottomLeft"]={32, 16, 0.298828, 0.423828, 0.298828, 0.423828, false, false, "2x"},
    ["UI-Frame-Metal-CornerBottomRight"]={32, 16, 0.427734, 0.552734, 0.298828, 0.423828, false, false, "2x"},
    ["UI-Frame-Metal-CornerTopLeft"]={75, 37, 0.00195312, 0.294922, 0.00195312, 0.294922, false, false, "2x"},
    ["UI-Frame-Metal-CornerTopRight"]={75, 37, 0.298828, 0.591797, 0.00195312, 0.294922, false, false, "2x"},
    ["UI-Frame-PortraitMetal-CornerTopLeft"]={75, 37, 0.00195312, 0.294922, 0.298828, 0.591797, false, false, "2x"},
    ["UI-Frame-Metal-CornerTopRightDouble"]={75, 37, 0.595703, 0.888672, 0.00195312, 0.294922, false, false, "2x"},
    ["ui-frame-portraitmetal-cornertopleftsmall"]={75, 37, 0.00195312, 0.294922, 0.595703, 0.888672, false, false, "2x"},
  }, -- Interface/FrameGeneral/UIFrameMetal2x
  ["Interface/FrameGeneral/UIFrameMetalHorizontal2x"]={
    ["_UI-Frame-Metal-EdgeBottom"]={16, 16, 0, 0.5, 0.597656, 0.847656, true, false, "2x"},
    ["_UI-Frame-Metal-EdgeTop"]={32, 37, 0, 1, 0.00390625, 0.589844, true, false, "2x"},
  }, -- Interface/FrameGeneral/UIFrameMetalHorizontal2x
  ["Interface/FrameGeneral/UIFrameMetalVertical2x"]={
    ["!UI-Frame-Metal-EdgeLeft"]={75, 8, 0.00195312, 0.294922, 0, 1, false, true, "2x"},
    ["!UI-Frame-Metal-EdgeRight"]={75, 8, 0.298828, 0.591797, 0, 1, false, true, "2x"},
  }, -- Interface/FrameGeneral/UIFrameMetalVertical2x
  
    ["Interface/FrameGeneral/UIFrameBackground"]={
    ["UIFrameBackground-NineSlice-CornerBottomLeft"]={16, 16, 0.015625, 0.265625, 0.03125, 0.53125, false, false, "1x"},
    ["UIFrameBackground-NineSlice-CornerBottomRight"]={16, 16, 0.296875, 0.546875, 0.03125, 0.53125, false, false, "1x"},
  ]]

function DragonflightUIMixin:PortraitFrameTemplate(frame)
    -- print('DragonflightUIMixin:PortraitFrameTemplate(frame)', frame:GetName())

    local name = frame:GetName()

    -- portrait
    do
        local tex = base .. 'uiframemetal2x'

        local port = _G[name .. 'Portrait']
        if port then
            port:SetSize(62, 62)
            port:ClearAllPoints()
            port:SetPoint('TOPLEFT', -5, 7)
            port:SetDrawLayer('OVERLAY', 6)

            local pp = _G[name .. 'PortraitFrame'] or frame.PortraitFrame
            pp:SetTexture(tex)
            pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
            pp:SetSize(84, 84)
            pp:ClearAllPoints()
            pp:SetPoint('CENTER', port, 'CENTER', 0, 0)
            pp:SetDrawLayer('OVERLAY', 7)

            -- port:Hide()
            -- pp:Hide()
            -- FriendsFrameIcon:Hide()

            local icon = _G[name .. 'Icon']

            if icon then
                icon:SetSize(62, 62)
                icon:ClearAllPoints()
                icon:SetPoint('TOPLEFT', -5, 7)
                icon:SetDrawLayer('OVERLAY', 6)
            end
        else
            --

        end
    end

    -- corner
    do
        local tex = base .. 'uiframemetal2x'

        local tlc = _G[name .. 'TopLeftCorner']
        if tlc then
            tlc:SetTexture(tex)
            tlc:SetTexCoord(0.00195312, 0.294922, 0.00195312, 0.294922)
            tlc:SetSize(75, 74)
            tlc:SetPoint('TOPLEFT', -12, 16)
        end

        local tlcDF = frame:CreateTexture(name .. 'TopLeftCornerDF', 'OVERLAY')
        tlcDF:SetTexture(tex)
        tlcDF:SetTexCoord(0.00195312, 0.294922, 0.00195312, 0.294922)
        tlcDF:SetSize(75, 74)
        tlcDF:SetPoint('TOPLEFT', -13, 16)
        tlcDF:SetDrawLayer('ARTWORK', 0)

        local trc = _G[name .. 'TopRightCorner'] or frame.TopRightCorner
        trc:SetTexture(tex)
        trc:SetTexCoord(0.298828, 0.591797, 0.00195312, 0.294922)
        trc:SetSize(75, 74)
        trc:SetPoint('TOPRIGHT', 4, 16)

        local blc = _G[name .. 'BotLeftCorner'] or frame.BotLeftCorner
        blc:SetTexture(tex)
        blc:SetTexCoord(0.298828, 0.423828, 0.298828, 0.423828)
        blc:SetSize(32, 32)
        blc:SetPoint('BOTTOMLEFT', -13, -3)

        local brc = _G[name .. 'BotRightCorner'] or frame.BotRightCorner
        brc:SetTexture(tex)
        brc:SetTexCoord(0.427734, 0.552734, 0.298828, 0.423828)
        brc:SetSize(32, 32)
        brc:SetPoint('BOTTOMRIGHT', 4, -3)

        local brcFake = _G[name .. 'BtnCornerRight']
        if brcFake then brcFake:SetAlpha(0) end

        local blcFake = _G[name .. 'BtnCornerLeft']
        if blcFake then blcFake:SetAlpha(0) end
    end

    -- edge bottom/top
    do
        local tex = base .. 'UIFrameMetalHorizontal2x'

        local te = _G[name .. 'TopBorder'] or frame.TopBorder
        te:SetTexture(tex)
        te:SetTexCoord(0, 1, 0.00390625, 0.589844)
        te:SetSize(32, 74)
        -- local point, relativeTo, relativePoint, xOfs, yOfs = te:GetPoint(1)   
        te:ClearAllPoints()
        te:SetPoint('TOPLEFT', _G[name .. 'TopLeftCornerDF'], 'TOPRIGHT', 0, 0)
        te:SetPoint('TOPRIGHT', _G[name .. 'TopRightCorner'], 'TOPLEFT', 0, 0)

        local be = _G[name .. 'BottomBorder'] or frame.BottomBorder
        be:SetTexture(tex)
        be:SetTexCoord(0, 0.5, 0.597656, 0.847656)
        be:SetSize(16, 32)

        local beFake = _G[name .. 'ButtonBottomBorder']
        if beFake then beFake:SetAlpha(0) end
    end

    -- edge left/right
    do
        local tex = base .. 'UIFrameMetalVertical2x'

        local le = _G[name .. 'LeftBorder'] or frame.LeftBorder
        le:SetTexture(tex)
        le:SetTexCoord(0.00195312, 0.294922, 0, 1)
        le:SetSize(75, 16)
        local tlc = _G[name .. 'TopLeftCornerDF']
        le:SetPoint('TOPLEFT', tlc, 'BOTTOMLEFT', 0, 0)

        local re = _G[name .. 'RightBorder'] or frame.RightBorder
        re:SetTexture(tex)
        re:SetTexCoord(0.298828, 0.591797, 0, 1)
        re:SetSize(75, 16)
        re:SetPoint('TOPRIGHT', _G[name .. 'TopRightCorner'], 'BOTTOMRIGHT', 0, 0)
        re:SetPoint('BOTTOMRIGHT', _G[name .. 'BotRightCorner'], 'TOPRIGHT', 0, 0)
    end

    local closeBtn = _G[name .. 'CloseButton']
    if closeBtn then
        DragonflightUIMixin:UIPanelCloseButton(closeBtn)
        closeBtn:SetPoint('TOPRIGHT', 1, 0)
    end

    do

        -- local bg = _G[name .. 'Bg']
        -- bg:SetDrawLayer('OVERLAY', 7)
    end

    -- e.g. spellbook
    for i = 1, 5 do
        local tab = _G[name .. 'TabButton' .. i]

        if tab then
            --         
            DragonflightUIMixin:CharacterFrameTabButtonTemplate(tab)

            if i > 1 then tab.DFChangePoint = true end
        end
    end

    -- e.g. characterframe
    for i = 1, 5 do
        local tab = _G[name .. 'Tab' .. i]

        if tab and name ~= 'MacroFrame' then
            --         
            DragonflightUIMixin:CharacterFrameTabButtonTemplate(tab)

            if i == 1 then
                tab.DFFirst = true
            elseif i > 1 then
                tab.DFChangePoint = true
            end
        end
    end

    if name == 'SpellBookFrame' then

        local setTabWidths = function()
            for i = 1, 5 do
                local tab = _G['SpellBookFrameTabButton' .. i]

                if tab then
                    --        
                    local text = _G['SpellBookFrameTabButton' .. i .. 'Text']
                    tab.DFTabWidth = math.max(text:GetWrappedWidth() + 16, 78)
                    -- DragonflightUIMixin:TabResize(tab)
                    tab:SetWidth(tab.DFTabWidth)
                end
            end
        end

        if SpellBookFrame_Update then
            hooksecurefunc('SpellBookFrame_Update', function()
                --
                --  print('SpellBookFrame_Update')
                setTabWidths()
            end)
        end

        for i = 1, 8 do
            -- SpellBookSkillLineTab1
            local skill = _G['SpellBookSkillLineTab' .. i]

            local children = {skill:GetRegions()}

            for k, child in ipairs(children) do
                if child:GetObjectType() == 'Texture' then
                    local tex = child:GetTexture()
                    if tex == 136831 then
                        -- 
                        -- child:Hide() 
                        child:SetTexture(base .. 'spellbook-skilllinetab')
                    end
                end
            end
        end

        --[[   -- TODO: Taint :(
        SpellBookFrame:HookScript('OnMouseWheel', function(self, arg1)
            --
            -- print('OnMouseWheel', arg1)
            if arg1 > 0 then
                -- 1 for spinning up
                SpellBookPrevPageButton:Click()
            elseif arg1 < 0 then
                -- -1 for spinning down
                SpellBookNextPageButton:Click()
            end
        end) ]]

        hooksecurefunc('ToggleSpellBook', function(panel)
            --         
            if panel == 'spell' then
                _G[name .. 'TabButton1']:Disable()
            elseif panel == 'professions' then
                _G[name .. 'TabButton2']:Disable()
            elseif panel == 'pet' then
                _G[name .. 'TabButton3']:Disable()
            end
        end)
    elseif name == 'CharacterFrame' then
        --
        for i = 1, 5 do
            local tab = _G[name .. 'Tab' .. i]
            if tab then
                tab.DFFirst = nil
                tab.DFChangePoint = nil
            end
        end

        local updateTabs = function()
            local lastElem = nil
            for i = 1, 5 do
                local tab = _G[name .. 'Tab' .. i]
                if tab and (tab:IsShown()) then
                    local text = _G[name .. 'Tab' .. i .. 'Text']
                    tab:SetWidth(math.max(text:GetWrappedWidth() + 16, 78))
                    tab:ClearAllPoints();
                    if lastElem then
                        tab:SetPoint('TOPLEFT', lastElem, 'TOPRIGHT', 4, 0)
                    else
                        tab:SetPoint('TOPLEFT', CharacterFrame, 'BOTTOMLEFT', 12, 1)
                    end
                    lastElem = tab
                end
            end
        end
        hooksecurefunc('ToggleCharacter', function(panel)
            --   
            updateTabs()
        end)
        _G[name .. 'Tab' .. 2]:HookScript('OnShow', updateTabs)
        _G[name .. 'Tab' .. 2]:HookScript('OnHide', updateTabs)
    elseif name == 'PlayerTalentFrame' then
        --
        for i = 1, 5 do
            local tab = _G[name .. 'Tab' .. i]
            if tab then
                tab.DFFirst = nil
                tab.DFChangePoint = nil
            end
        end
        hooksecurefunc('PlayerTalentFrame_UpdateTabs', function()
            --  
            local lastElem = nil
            for i = 1, NUM_TALENT_FRAME_TABS do
                local tab = _G["PlayerTalentFrameTab" .. i];
                if (tab:IsShown()) then
                    tab:SetWidth(78)
                    tab:ClearAllPoints();
                    if lastElem then
                        tab:SetPoint('TOPLEFT', lastElem, 'TOPRIGHT', 4, 0)
                    else
                        tab:SetPoint('TOPLEFT', PlayerTalentFrame, 'BOTTOMLEFT', 12, 1)
                    end
                    lastElem = tab
                end
            end
        end)
    elseif name == 'CollectionsJournal' then
        --   
        for i = 1, 5 do
            local tab = _G[name .. 'Tab' .. i]

            if tab then
                --        
                local text = _G[name .. 'Tab' .. i .. 'Text']
                tab.DFTabWidth = math.max(text:GetWrappedWidth() + 16, 78)
                DragonflightUIMixin:TabResize(tab)
            end
        end
        -- btn:SetWidth(btn.DFTabWidth or 78)
    elseif name == 'CommunitiesFrame' then
        --   
        local bg = _G['CommunitiesFrameBg']
        if bg then
            --
            bg:SetTexture(base .. 'ui-background-rock')
            bg:ClearAllPoints()
            bg:SetPoint('TOPLEFT', CommunitiesFrame, 'TOPLEFT', 3, -18)
            bg:SetPoint('BOTTOMRIGHT', CommunitiesFrame, 'BOTTOMRIGHT', 0, 3)
            -- bg:SetDrawLayer('BACKGROUND', 2)
        end

        local fixTop = function()
            local te = _G[name .. 'TopBorder']
            te:ClearAllPoints()
            te:SetPoint('TOPLEFT', _G[name .. 'TopLeftCornerDF'], 'TOPRIGHT', 0, 0)
            te:SetPoint('TOPRIGHT', _G[name .. 'TopRightCorner'], 'TOPLEFT', 0, 0)
        end
        frame:HookScript('OnShow', function()
            -- 
            fixTop()
        end)

        local minBtn = frame.MaximizeMinimizeFrame
        DragonflightUIMixin:MaximizeMinimizeButtonFrameTemplate(minBtn)

        local oldMaximizedCallback = minBtn.maximizedCallback
        minBtn:SetOnMaximizedCallback(function()
            oldMaximizedCallback(minBtn)
            fixTop()
        end)

        local oldminimizedCallback = minBtn.minimizedCallback
        minBtn:SetOnMinimizedCallback(function()
            oldminimizedCallback(minBtn)
            fixTop()
        end)
    elseif name == 'EncounterJournal' then
        local dung = _G[name .. 'DungeonTab']
        -- dung.DFFirst = true
        -- DragonflightUIMixin:BottomEncounterTierTabTemplate(dung)
        dung:ClearAllPoints()
        dung:SetAlpha(0)
        -- dung:EnableMouse(false)

        local newDung = CreateFrame('BUTTON', 'DragonflightUIEncounterJournalDungeonTab', frame, 'DFDungeonTab')
        newDung:Show()
        newDung:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT', 12, 1)
        newDung:GetFontString():SetText(DUNGEONS)
        newDung.DFTabWidth = math.max(newDung:GetFontString():GetWrappedWidth() + 16, 78)
        DragonflightUIMixin:CharacterFrameTabButtonTemplate(newDung, true)

        local raid = _G[name .. 'RaidTab']
        -- raid.DFChangePoint = true
        -- DragonflightUIMixin:BottomEncounterTierTabTemplate(raid)
        raid:ClearAllPoints()
        raid:SetAlpha(0)
        raid:EnableMouse(false)

        local newRaid = CreateFrame('BUTTON', 'DragonflightUIEncounterJournalRaidTab', frame, 'DFRaidTab')
        newRaid:Show()
        newRaid:SetPoint('TOPLEFT', newDung, 'TOPRIGHT', 4, 0)
        newRaid:GetFontString():SetText(RAIDS)
        newRaid.DFTabWidth = math.max(newRaid:GetFontString():GetWrappedWidth() + 16, 78)
        DragonflightUIMixin:CharacterFrameTabButtonTemplate(newRaid, true)
    elseif name == 'MacroFrame' then
        --  
        local children = {frame:GetRegions()}

        for k, child in ipairs(children) do
            if child:GetObjectType() == 'Texture' then
                local tex = child:GetTexture()
                if tex == 136377 then
                    -- 
                    -- child:Hide() 
                    -- child:SetTexture(base .. 'spellbook-skilllinetab')
                    child:SetSize(62, 62)
                    child:ClearAllPoints()
                    child:SetPoint('TOPLEFT', -5, 7)
                    child:SetDrawLayer('OVERLAY', 6)

                    SetPortraitToTexture(child, child:GetTexture())
                end
            end
        end
    elseif name == 'FriendsFrame' then
        -- DFFirstOffsetX
        if DF.Era then
            --
            for i = 1, 5 do
                --
                local tab = _G[name .. 'Tab' .. i]
                if tab then
                    tab.DFFirstOffsetX = 4
                    tab.DFTabWidth = 62.8

                    if i == 1 then
                        tab:ClearAllPoints()
                        tab:SetPoint('TOPLEFT', FriendsFrame, 'BOTTOMLEFT', 6, -1)
                    end

                    if i == 4 then
                        -- raid 
                        -- tab:SetText('Schlachtzug')
                        local text = _G['FriendsFrameTab' .. i .. 'Text']
                        -- print('ss', text:GetWrappedWidth())
                        if text:GetWrappedWidth() > 24 then
                            tab.DFTabWidth = math.min(text:GetWrappedWidth() + 16, 84)
                        end
                    end

                    if i == 5 then
                        local tabHigh = _G[name .. 'Tab' .. i .. 'HighlightTexture']
                        if tabHigh then tabHigh:Hide() end
                    end
                end
            end

            -- title text bug @BLIZZBUG
            do
                -- local title = _G['FriendsFrameTitleText']
                hooksecurefunc('FriendsFrame_Update', function()
                    --
                    -- print('FriendsFrame_Update')
                    if FriendsFrame.TitleText then FriendsFrame.TitleText:Hide() end
                end)
            end

            -- guild 

            local originalGuild = _G[name .. 'Tab' .. 3];

            local newGuildBtn = CreateFrame('Button', 'DragonflightUIFixedGuildButton', FriendsFrame,
                                            'DFGuildTab, SecureActionButtonTemplate')

            DragonflightUIMixin:CharacterFrameTabButtonTemplate(newGuildBtn, true, true)
            newGuildBtn.DFFirstOffsetX = 4
            newGuildBtn.DFTabWidth = 62.8
            DragonflightUIMixin:TabResize(newGuildBtn)

            local dx = newGuildBtn.DFFirstOffsetX + 2 * newGuildBtn.DFTabWidth + 2 * 4

            newGuildBtn:ClearAllPoints()
            newGuildBtn:SetPoint('TOPLEFT', FriendsFrame, 'BOTTOMLEFT', dx, 1)
            DragonflightUIMixin:TabResize(originalGuild)

            _G[newGuildBtn:GetName() .. 'LeftDisabled']:Hide()
            _G[newGuildBtn:GetName() .. 'RightDisabled']:Hide()
            _G[newGuildBtn:GetName() .. 'MiddleDisabled']:Hide()

            newGuildBtn:SetText(originalGuild:GetText())

            newGuildBtn:SetAttribute("type", "macro"); -- Set type to "macro"
            newGuildBtn:SetAttribute("macrotext", "/click GuildMicroButton");

            -- CommunitiesFrame:HookScript('OnShow', function()
            --     -- newGuildBtn:SetNormal(false)
            --     -- newGuildBtn:DFHighlight(true)
            --     -- newGuildBtn:SetNormalFontObject(GameFontHighlightSmall)
            -- end)
            -- CommunitiesFrame:HookScript('OnHide', function()
            --     -- newGuildBtn:SetNormal(true)
            --     -- newGuildBtn:DFHighlight(false)
            --     -- newGuildBtn:SetNormalFontObject(GameFontNormalSmall)
            -- end)

            originalGuild.DFNewGuildButton = newGuildBtn

            hooksecurefunc('FriendsFrame_UpdateGuildTabVisibility', function()
                --
                if InCombatLockdown() then return end -- TODO
                local classicUI = Settings.GetValue('useClassicGuildUI')
                -- print('FriendsFrame_UpdateGuildTabVisibility', classicUI, newGuildBtn:IsVisible())
                if classicUI and newGuildBtn:IsVisible() then
                    newGuildBtn:Hide()
                elseif not classicUI and not newGuildBtn:IsVisible() then
                    newGuildBtn:Show()
                end
            end)
            newGuildBtn:SetShown(not Settings.GetValue('useClassicGuildUI'))
            newGuildBtn:SetScript('OnEvent', function(self, event, cvarName, value)
                --
                if InCombatLockdown() then return end -- TODO
                if event == "CVAR_UPDATE" then
                    if cvarName == "useClassicGuildUI" then
                        if value == "1" then
                            newGuildBtn:Hide()
                        else
                            newGuildBtn:Show()
                        end
                    end
                end
            end)
            newGuildBtn:RegisterEvent("CVAR_UPDATE")
        else
            for i = 1, 5 do
                --
                local tab = _G[name .. 'Tab' .. i]
                if tab then
                    local text = _G['FriendsFrameTab' .. i .. 'Text']
                    tab.DFTabWidth = math.max(text:GetWrappedWidth() + 16, 78)

                    if i == 1 then
                        tab:ClearAllPoints()
                        tab:SetPoint('TOPLEFT', FriendsFrame, 'BOTTOMLEFT', 6, -1)
                    end
                end
            end
        end

        local bg = _G['FriendsFrameBg']
        if bg then
            --
            bg:SetTexture(base .. 'ui-background-rock')
            bg:ClearAllPoints()
            bg:SetPoint('TOPLEFT', FriendsFrame, 'TOPLEFT', 3, -18)
            bg:SetPoint('BOTTOMRIGHT', FriendsFrame, 'BOTTOMRIGHT', 0, 3)
            -- bg:SetDrawLayer('BACKGROUND', 2)
        end

        -- title text bug @BLIZZBUG
        do
            -- local title = _G['FriendsFrameTitleText']
            hooksecurefunc('FriendsFrame_Update', function()
                --
                -- print('FriendsFrame_Update')
                if FriendsFrame.TitleText then FriendsFrame.TitleText:Hide() end
            end)
        end

        local conv = RaidFrameConvertToRaidButton
        if conv then
            -- print('conv!')
            conv:SetHeight(22)
            conv:SetPoint('BOTTOMRIGHT', RaidFrame, 'BOTTOMRIGHT', -6, 4)

            local btnText = _G[conv:GetName() .. 'Text'];
            if btnText then
                local fontName, fontHeight, fontFlags = btnText:GetFont()
                btnText:SetFont(fontName, 12, fontFlags)
            end
        else
            -- print(':(((')
        end
    elseif name == 'MailFrame' then
        --
        for i = 1, 5 do
            local tab = _G[name .. 'Tab' .. i]

            if tab then
                --
                local text = _G[name .. 'Tab' .. i .. 'Text']
                tab.DFTabWidth = math.max(text:GetWrappedWidth() + 16, 78)
                DragonflightUIMixin:TabResize(tab)
            end
        end

        local children = {frame:GetRegions()}

        for k, child in ipairs(children) do
            if child:GetObjectType() == 'Texture' then
                local tex = child:GetTexture()
                if tex == 136382 then
                    -- 
                    -- child:Hide() 
                    -- child:SetTexture(base .. 'spellbook-skilllinetab')
                    child:SetSize(62, 62)
                    child:ClearAllPoints()
                    child:SetPoint('TOPLEFT', -5, 7)
                    child:SetDrawLayer('OVERLAY', 6)

                    SetPortraitToTexture(child, child:GetTexture())
                end
            end
        end
    end
end

function DragonflightUIMixin:TabResize(btn)
    -- PanelTemplates_TabResize(btn, 35, nil, 60, 80);
    btn:SetWidth(btn.DFTabWidth or 78)

    if btn.DFFirst then
        local point, relativeTo, relativePoint, xOfs, yOfs = btn:GetPoint(1)
        btn:SetPoint('TOPLEFT', relativeTo, 'BOTTOMLEFT', btn.DFFirstOffsetX or 6, 1)
    elseif btn.DFChangePoint then
        local point, relativeTo, relativePoint, xOfs, yOfs = btn:GetPoint(1)
        btn:ClearAllPoints()
        btn:SetPoint('TOPLEFT', relativeTo, 'TOPRIGHT', 4, 0)
    end
end

function DragonflightUIMixin:CharacterFrameTabButtonTemplate(frame, hideDisabled, dontResize)
    -- print('DragonflightUIMixin:CharacterFrameTabButtonTemplate(frame)', frame:GetName())

    local name = frame:GetName()
    if not name then return false end -- TODO: ..'UI.mixin.lua:3671: attempt to concatenate local 'name' (a nil value)'

    local tex = base .. 'uiframetabs'

    frame:SetSize(10, 32)

    -- function PanelTemplates_TabResize(tab, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)
    -- 100 - 150
    -- PanelTemplates_TabResize(self, 0, nil, 36, self:GetParent().maxTabWidth or 88);

    if not dontResize then
        frame:HookScript('OnEvent', function()
            DragonflightUIMixin:TabResize(frame)
        end)

        frame:HookScript('OnShow', function()
            DragonflightUIMixin:TabResize(frame)
        end)
        DragonflightUIMixin:TabResize(frame)
    end

    -- inactive
    do
        local left = _G[name .. 'Left']
        left:ClearAllPoints()
        left:SetSize(35, 36)
        left:SetTexture(tex)
        left:SetTexCoord(0.015625, 0.5625, 0.816406, 0.957031)
        left:SetPoint('TOPLEFT', -3, 0)

        local right = _G[name .. 'Right']
        right:ClearAllPoints()
        right:SetSize(37, 36)
        right:SetTexture(tex)
        right:SetTexCoord(0.015625, 0.59375, 0.667969, 0.808594)
        right:SetPoint('TOPRIGHT', 7, 0)

        local middle = _G[name .. 'Middle']
        middle:ClearAllPoints()
        middle:SetSize(1, 36)
        middle:SetTexture(tex)
        middle:SetTexCoord(0, 0.015625, 0.175781, 0.316406)
        middle:SetPoint('TOPLEFT', left, 'TOPRIGHT', 0, 0)
        middle:SetPoint('TOPRIGHT', right, 'TOPLEFT', 0, 0)

        function frame:SetNormal(normal, keepSize)
            if normal then
                --   
                if not keepSize then frame:SetHeight(32) end

                left:SetSize(35, 36)
                left:SetTexCoord(0.015625, 0.5625, 0.816406, 0.957031)

                right:SetSize(37, 36)
                right:SetTexCoord(0.015625, 0.59375, 0.667969, 0.808594)

                middle:SetSize(1, 36)
                middle:SetTexCoord(0, 0.015625, 0.175781, 0.316406)
            else
                --
                if not keepSize then frame:SetHeight(42) end

                left:SetSize(35, 42)
                left:SetTexCoord(0.015625, 0.5625, 0.496094, 0.660156)

                right:SetSize(37, 42)
                right:SetTexCoord(0.015625, 0.59375, 0.324219, 0.488281)

                middle:SetSize(1, 42)
                middle:SetTexCoord(0, 0.015625, 0.00390625, 0.167969)
            end
        end

        frame:HookScript('OnEnable', function()
            frame:SetNormal(true)
        end)

        frame:HookScript('OnDisable', function()
            frame:SetNormal(false)
        end)
    end

    -- disabled
    if true then
        local left = _G[name .. 'LeftDisabled']
        -- left:SetTexture()
        -- left:Hide()
        left:ClearAllPoints()
        left:SetSize(35, 42)
        left:SetTexture(tex)
        left:SetTexCoord(0.015625, 0.5625, 0.496094, 0.660156)
        left:SetPoint('TOPLEFT', -1, 0)

        local right = _G[name .. 'RightDisabled']
        -- right:SetTexture()
        -- right:Hide()
        right:ClearAllPoints()
        right:SetSize(37, 42)
        right:SetTexture(tex)
        right:SetTexCoord(0.015625, 0.59375, 0.324219, 0.488281)
        right:SetPoint('TOPRIGHT', 8, 0)

        local middle = _G[name .. 'MiddleDisabled']
        -- middle:SetTexture()
        -- middle:Hide()
        middle:ClearAllPoints()
        middle:SetSize(1, 42)
        middle:SetTexture(tex)
        middle:SetTexCoord(0, 0.015625, 0.00390625, 0.167969)
        middle:SetPoint('TOPLEFT', left, 'TOPRIGHT', 0, 0)
        middle:SetPoint('TOPRIGHT', right, 'TOPLEFT', 0, 0)

        if hideDisabled then
            left:Hide()
            right:Hide()
            middle:Hide()
        end
    end

    -- highlight
    if true then
        local highlight = frame:GetHighlightTexture()
        if highlight then highlight:SetTexture() end

        local left = frame:CreateTexture('DragonflightUIHighlight' .. 'Left', 'HIGHLIGHT')
        left:SetTexture(tex)
        left:SetTexCoord(0.015625, 0.5625, 0.816406, 0.957031)
        left:SetSize(35, 36)
        left:SetPoint('TOPLEFT', -3, 0)
        left:SetBlendMode('ADD')
        left:SetAlpha(0.4)

        local right = frame:CreateTexture('DragonflightUIHighlight' .. 'Right', 'HIGHLIGHT')
        right:SetTexture(tex)
        right:SetTexCoord(0.015625, 0.59375, 0.667969, 0.808594)
        right:SetSize(37, 36)
        right:SetPoint('TOPRIGHT', 7, 0)
        right:SetBlendMode('ADD')
        right:SetAlpha(0.4)

        local middle = frame:CreateTexture('DragonflightUIHighlight' .. 'Middle', 'HIGHLIGHT')
        middle:SetTexture(tex)
        middle:SetTexCoord(0, 0.015625, 0.175781, 0.316406)
        middle:SetSize(1, 36)
        middle:SetPoint('TOPLEFT', left, 'TOPRIGHT', 0, 0)
        middle:SetPoint('TOPRIGHT', right, 'TOPLEFT', 0, 0)
        middle:SetBlendMode('ADD')
        middle:SetAlpha(0.4)

        function frame:DFHighlight(big)
            if big then
                left:SetHeight(42)
                right:SetHeight(42)
                middle:SetHeight(42)
            else
                left:SetHeight(36)
                right:SetHeight(36)
                middle:SetHeight(36)
            end
        end
    end
end

function DragonflightUIMixin:BottomEncounterTierTabTemplate(frame)

    frame:SetSize(80, 36)
    do
        local left = frame.left
        left:ClearAllPoints()
        left:SetSize(35, 36)
        left:SetTexture(tex)
        left:SetTexCoord(0.015625, 0.5625, 0.816406, 0.957031)
        left:SetPoint('TOPLEFT', -3, 0)

        local right = frame.right
        right:ClearAllPoints()
        right:SetSize(37, 36)
        right:SetTexture(tex)
        right:SetTexCoord(0.015625, 0.59375, 0.667969, 0.808594)
        right:SetPoint('TOPRIGHT', 7, 0)

        local middle = frame.mid
        middle:ClearAllPoints()
        middle:SetSize(1, 36)
        middle:SetTexture(tex)
        middle:SetTexCoord(0, 0.015625, 0.175781, 0.316406)
        middle:SetPoint('TOPLEFT', left, 'TOPRIGHT', 0, 0)
        middle:SetPoint('TOPRIGHT', right, 'TOPLEFT', 0, 0)

        local setNormal = function(normal, keepSize)
            if normal then
                --   
                frame:SetHeight(32)

                left:SetSize(35, 36)
                left:SetTexCoord(0.015625, 0.5625, 0.816406, 0.957031)

                right:SetSize(37, 36)
                right:SetTexCoord(0.015625, 0.59375, 0.667969, 0.808594)

                middle:SetSize(1, 36)
                middle:SetTexCoord(0, 0.015625, 0.175781, 0.316406)
            else
                --
                frame:SetHeight(42)

                left:SetSize(35, 42)
                left:SetTexCoord(0.015625, 0.5625, 0.496094, 0.660156)

                right:SetSize(37, 42)
                right:SetTexCoord(0.015625, 0.59375, 0.324219, 0.488281)

                middle:SetSize(1, 42)
                middle:SetTexCoord(0, 0.015625, 0.00390625, 0.167969)
            end
        end

        frame:HookScript('OnEnable', function()
            setNormal(true)
        end)

        frame:HookScript('OnDisable', function()
            setNormal(false)
        end)
    end

    -- active
    if true then
        local left = frame.leftSelect
        left:ClearAllPoints()
        left:SetSize(35, 42)
        left:SetTexture(tex)
        left:SetTexCoord(0.015625, 0.5625, 0.496094, 0.660156)
        left:SetPoint('TOPLEFT', -1, 0)

        local right = frame.rightSelect
        right:ClearAllPoints()
        right:SetSize(37, 42)
        right:SetTexture(tex)
        right:SetTexCoord(0.015625, 0.59375, 0.324219, 0.488281)
        right:SetPoint('TOPRIGHT', 8, 0)

        local middle = frame.midSelect
        middle:ClearAllPoints()
        middle:SetSize(1, 42)
        middle:SetTexture(tex)
        middle:SetTexCoord(0, 0.015625, 0.00390625, 0.167969)
        middle:SetPoint('TOPLEFT', left, 'TOPRIGHT', 0, 0)
        middle:SetPoint('TOPRIGHT', right, 'TOPLEFT', 0, 0)
    end

    -- highlight
    if true then

        local left = frame.leftHighlight
        left:SetTexture(tex)
        left:SetTexCoord(0.015625, 0.5625, 0.816406, 0.957031)
        left:SetSize(35, 36)
        left:ClearAllPoints()
        left:SetPoint('TOPLEFT', -3, 0)
        left:SetBlendMode('ADD')
        left:SetAlpha(0.4)

        local right = frame.rightHighlight
        right:SetTexture(tex)
        right:SetTexCoord(0.015625, 0.59375, 0.667969, 0.808594)
        right:SetSize(37, 36)
        right:ClearAllPoints()
        right:SetPoint('TOPRIGHT', 7, 0)
        right:SetBlendMode('ADD')
        right:SetAlpha(0.4)

        local middle = frame.midHighlight
        middle:SetTexture(tex)
        middle:SetTexCoord(0, 0.015625, 0.175781, 0.316406)
        middle:SetSize(1, 36)
        middle:ClearAllPoints()
        middle:SetPoint('TOPLEFT', left, 'TOPRIGHT', 0, 0)
        middle:SetPoint('TOPRIGHT', right, 'TOPLEFT', 0, 0)
        middle:SetBlendMode('ADD')
        middle:SetAlpha(0.4)
    end
end

function DragonflightUIMixin:AddIconBorder(btn, helpful)
    if btn.DFIconBorder then return end
    btn.DFIconBorder = btn:CreateTexture('DragonflightUIIconBorder')
    local border = btn.DFIconBorder;
    border:ClearAllPoints()
    border:SetPoint('TOPLEFT', btn, 'TOPLEFT', 0, 0.25)
    border:SetPoint('BOTTOMRIGHT', btn, 'BOTTOMRIGHT', 1.75, -0.75)
    border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x')
    border:SetTexCoord(0.701171875, 0.880859375, 0.31689453125, 0.36083984375)
    -- border:SetTexCoord(0.701171875, 0.880859375, 0.52001953125, 0.56396484375)
    border:SetDrawLayer('OVERLAY')

    if not helpful then
        border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\iconborderWhite')
        border:SetTexCoord(0, 92 / 128, 0, 90 / 128)
    end

    local mask = btn:CreateMaskTexture('DragonflightUIIconMask')
    local delta = 1.25
    mask:SetPoint('TOPLEFT', btn, 'TOPLEFT', -delta, delta)
    mask:SetPoint('BOTTOMRIGHT', btn, 'BOTTOMRIGHT', delta, -delta)
    mask:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\maskNew')
    _G[btn:GetName() .. 'Icon']:AddMaskTexture(mask)
end

--[[ ["Interface/FrameGeneral/UIFrameTabs"]={
    ["uiframe-activetab-left"]={35, 42, 0.015625, 0.5625, 0.496094, 0.660156, false, false, "1x"},
    ["uiframe-activetab-right"]={37, 42, 0.015625, 0.59375, 0.324219, 0.488281, false, false, "1x"},
    ["uiframe-tab-left"]={35, 36, 0.015625, 0.5625, 0.816406, 0.957031, false, false, "1x"},
    ["uiframe-tab-right"]={37, 36, 0.015625, 0.59375, 0.667969, 0.808594, false, false, "1x"},
    ["_uiframe-activetab-center"]={1, 42, 0, 0.015625, 0.00390625, 0.167969, true, false, "1x"},
    ["_uiframe-tab-center"]={1, 36, 0, 0.015625, 0.175781, 0.316406, true, false, "1x"},
  }, -- Interface/FrameGeneral/UIFrameTabs ]]

ContainerFrameCurrencyBorderMixin = {};

function ContainerFrameCurrencyBorderMixin:OnLoad()
    self:SetupPiece(self.Left, self.leftEdge);
    self:SetupPiece(self.Right, self.rightEdge);
    self:SetupPiece(self.Middle, self.centerEdge);
end

local commoncoinboxTexture = base .. 'commoncoinbox'
local commoncurrencyboxTexture = base .. 'commoncurrencybox'
local currencyBorderAtlas = {
    -- commoncoinboxTexture
    ["common-coinbox-left"] = {commoncoinboxTexture, 16, 34, 0.03125, 0.53125, 0.289062, 0.554688, false, false, "1x"},
    ["common-coinbox-right"] = {commoncoinboxTexture, 16, 34, 0.03125, 0.53125, 0.570312, 0.835938, false, false, "1x"},
    ["_common-coinbox-center"] = {commoncoinboxTexture, 16, 34, 0, 0.5, 0.0078125, 0.273438, true, false, "1x"},
    -- commoncurrencyboxTexture
    ["common-currencybox-left"] = {
        commoncurrencyboxTexture, 16, 34, 0.03125, 0.53125, 0.289062, 0.554688, false, false, "1x"
    },
    ["common-currencybox-right"] = {
        commoncurrencyboxTexture, 16, 34, 0.03125, 0.53125, 0.570312, 0.835938, false, false, "1x"
    },
    ["_common-currencybox-center"] = {commoncurrencyboxTexture, 16, 34, 0, 0.5, 0.0078125, 0.273438, true, false, "1x"}
}

function ContainerFrameCurrencyBorderMixin:SetupPiece(piece, atlas)
    piece:SetTexelSnappingBias(0);
    -- piece:SetAtlas(atlas);

    local data = currencyBorderAtlas[atlas]

    piece:SetTexture(data[1])
    piece:SetTexCoord(data[4], data[5], data[6], data[7])
end
