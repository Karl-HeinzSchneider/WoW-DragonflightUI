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
    portBtn:SetAlpha(0)
    -- portBtn:SetPoint('TOPLEFT', frame, 'TOPLEFT', 7 - 25, -5)

    frame.ClosePanelButton = _G[name .. 'CloseButton']
    DragonflightUIMixin:AddNineSliceTextures(frame, true)
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(frame)

    frame.Bg:SetPoint('TOPLEFT', frame, 'TOPLEFT', 2, -20)
    frame.Bg:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -2, 3)

    local pp = frame:CreateTexture()
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

    frame:SetPoint("TOPLEFT", ContainerFrame1, "TOPLEFT", 42, -37)
    frame:Show()

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

    frame:SetSize(354, 447)

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

function DragonflightUIMixin:ChangeCharacterFrameCata()
    DragonflightUIMixin:PortraitFrameTemplate(CharacterFrame)

    CharacterFrameBg:SetTexture(base .. 'ui-background-rock')
    CharacterFrameBg:ClearAllPoints()
    CharacterFrameBg:SetPoint('TOPLEFT', CharacterFrame, 'TOPLEFT', 3, -18)
    CharacterFrameBg:SetPoint('BOTTOMRIGHT', CharacterFrame, 'BOTTOMRIGHT', 0, 3)
    -- CharacterFrameBg:SetDrawLayer('BACKGROUND', 2)

    do
        -- <Anchor point="BOTTOMLEFT" x="130" y="16"/>
        local main = _G['CharacterMainHandSlot']
        main:ClearAllPoints()
        local x = (328 / 2) + 4 - 1.5 * main:GetWidth() - 5
        main:SetPoint('BOTTOMLEFT', PaperDollItemsFrame, 'BOTTOMLEFT', x, 16)
    end
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

function DragonflightUIMixin:ChangeQuestLogFrameCata()
    frame = QuestLogFrame

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

    DragonflightUIMixin:FrameBackgroundSolid(frame, true)

    -- default -16 
    ShowUIPanel(frame)
    QuestLogFrame:SetAttribute("UIPanelLayout-" .. "xoffset", 0);
    QuestLogFrame:SetAttribute("UIPanelLayout-" .. "yoffset", 0);
    HideUIPanel(frame)
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
        local TopTileStreak = frame:CreateTexture()
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
    do
        local tex = base .. 'uiframemetal2x'

        local tlc = slice.TopLeftCorner
        tlc:SetTexture(tex)
        tlc:SetTexCoord(0.00195312, 0.294922, 0.00195312, 0.294922)
        tlc:SetSize(75, 74)
        tlc:SetPoint('TOPLEFT', -12, 16)

        local trc = slice.TopRightCorner
        trc:SetTexture(tex)
        trc:SetTexCoord(0.298828, 0.591797, 0.00195312, 0.294922)
        trc:SetSize(75, 74)
        trc:SetPoint('TOPRIGHT', 4, 16)

        local blc = slice.BottomLeftCorner
        blc:SetTexture(tex)
        blc:SetTexCoord(0.298828, 0.423828, 0.298828, 0.423828)
        blc:SetSize(32, 32)
        blc:SetPoint('BOTTOMLEFT', -12, -3)

        local brc = slice.BottomRightCorner
        brc:SetTexture(tex)
        brc:SetTexCoord(0.427734, 0.552734, 0.298828, 0.423828)
        brc:SetSize(32, 32)
        brc:SetPoint('BOTTOMRIGHT', 4, -3)
    end

    -- edge bottom/top
    do
        local tex = base .. 'UIFrameMetalHorizontal2x'

        local te = slice.TopEdge
        te:SetTexture(tex)
        te:SetTexCoord(0, 1, 0.00390625, 0.589844)
        te:SetSize(32, 74)
        te:SetPoint('TOPLEFT', slice.TopLeftCorner, 'TOPRIGHT', 0, 0)
        te:SetPoint('TOPRIGHT', slice.TopRightCorner, 'TOPLEFT', 0, 0)

        local be = slice.BottomEdge
        be:SetTexture(tex)
        be:SetTexCoord(0, 0.5, 0.597656, 0.847656)
        be:SetSize(16, 32)
        be:SetPoint('TOPLEFT', slice.BottomLeftCorner, 'TOPRIGHT', 0, 0)
        be:SetPoint('TOPRIGHT', slice.BottomRightCorner, 'TOPLEFT', 0, 0)
    end

    -- edge left/right
    do
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
                    tab:SetWidth(78)
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
                tab = _G["PlayerTalentFrameTab" .. i];
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
        newDung:GetFontString():SetText('Dungeons')
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
        newRaid:GetFontString():SetText('Raids')
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
                tab.DFFirstOffsetX = 4
                tab.DFTabWidth = 62.8

                if i == 5 then
                    local tabHigh = _G[name .. 'Tab' .. i .. 'HighlightTexture']
                    tabHigh:Hide()
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
    elseif name == 'MailFrame' then
        --
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

function DragonflightUIMixin:CharacterFrameTabButtonTemplate(frame, hideDisabled)
    -- print('DragonflightUIMixin:CharacterFrameTabButtonTemplate(frame)', frame:GetName())

    local name = frame:GetName()

    local tex = base .. 'uiframetabs'

    frame:SetSize(10, 32)

    -- function PanelTemplates_TabResize(tab, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)
    -- 100 - 150
    -- PanelTemplates_TabResize(self, 0, nil, 36, self:GetParent().maxTabWidth or 88);

    frame:HookScript('OnEvent', function()
        DragonflightUIMixin:TabResize(frame)
    end)

    frame:HookScript('OnShow', function()
        DragonflightUIMixin:TabResize(frame)
    end)
    DragonflightUIMixin:TabResize(frame)

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

        local setNormal = function(normal)
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

        local setNormal = function(normal)
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
