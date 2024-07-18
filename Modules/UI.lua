local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'UI'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')
Module.Tmp = {}

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {scale = 1, first = {changeBag = true, itemcolor = true, changeTradeskill = true, changeTrainer = true}}
}
Module:SetDefaults(defaults)

local function getDefaultStr(key, sub)
    return Module:GetDefaultStr(key, sub)
end

local function setDefaultValues()
    Module:SetDefaultValues()
end

local function setDefaultSubValues(sub)
    Module:SetDefaultSubValues(sub)
end

local function getOption(info)
    return Module:GetOption(info)
end

local function setOption(info, value)
    Module:SetOption(info, value)
end

local UIOptions = {
    type = 'group',
    name = 'Utility',
    get = getOption,
    set = setOption,
    args = {
        changeBag = {
            type = 'toggle',
            name = 'Change Bags',
            desc = '' .. getDefaultStr('changeBag', 'first'),
            order = 21
        },
        itemcolor = {
            type = 'toggle',
            name = 'Colored Inventory Items',
            desc = '' .. getDefaultStr('itemcolor', 'first'),
            order = 22
        },
        changeTradeskill = {
            type = 'toggle',
            name = 'Change Profession Window',
            desc = 'Only on Cata for now' .. getDefaultStr('changeTradeskill', 'first'),
            order = 22
        },
        changeTrainer = {
            type = 'toggle',
            name = 'Change Trainer Window',
            desc = '' .. getDefaultStr('changeTrainer', 'first'),
            order = 24
        }
    }
}

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1, ...)
    -- print('event', event, arg1, ...)   
    if event == 'INSPECT_READY' then
        -- print('INSPECT_READY')
        local db = Module.db.profile.first
        if db.itemcolor then DragonflightUIItemColorMixin:HookInspectFrame() end
        DragonflightUIMixin:ChangeInspectFrame()
        if InspectFrame and not InspectFrame.DFTacoTipHooked then
            --    
            Module:FuncOrWaitframe('TacoTip', function()
                DF.Compatibility:TacoTipInspect()
            end)
            InspectFrame.DFTacoTipHooked = true
        end
    elseif event == 'BAG_UPDATE_DELAYED' then
        -- print('BAG_UPDATE_DELAYED')
        DragonflightUIItemColorMixin:UpdateAllBags(false)
    elseif event == 'BANKFRAME_OPENED' then
        -- print('BANKFRAME_OPENED')
        DragonflightUIItemColorMixin:UpdateBankSlots()
    elseif event == 'PLAYERBANKSLOTS_CHANGED' then
        -- print('PLAYERBANKSLOTS_CHANGED')
        DragonflightUIItemColorMixin:UpdateBankSlots()
    elseif event == 'GUILDBANKBAGSLOTS_CHANGED' then
        -- print('GUILDBANKBAGSLOTS_CHANGED')
        DragonflightUIItemColorMixin:UpdateGuildBankSlots()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    DF:RegisterModuleOptions(mName, UIOptions)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    if DF.Cata then
        Module.Cata()
    elseif DF.Wrath then
        Module.Wrath()
    else
        Module.Era()
    end

    Module.ApplySettings()
    Module:RegisterOptionScreens()

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)
        Module:ApplySettings()
        Module:RefreshOptionScreens()
    end)
end

function Module:OnDisable()
end

function Module:RegisterOptionScreens()
    DF.ConfigModule:RegisterOptionScreen('Misc', 'UI', {
        name = 'UI',
        sub = 'first',
        options = UIOptions,
        default = function()
            setDefaultSubValues('first')
        end
    })
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame

    local refreshCat = function(name)
        configFrame:RefreshCatSub('Misc', name)
    end

    refreshCat('UI')
end

function Module:ApplySettings()
    local db = Module.db.profile.first

    if db.changeBag and not ContainerFrame1.DFHooked then
        ContainerFrame1.DFHooked = true

        Module:ChangeBags()

        frame:RegisterEvent('BAG_UPDATE_DELAYED')
        frame:RegisterEvent('BANKFRAME_OPENED')
        frame:RegisterEvent('PLAYERBANKSLOTS_CHANGED')
        frame:RegisterEvent('GUILDBANKBAGSLOTS_CHANGED')
    elseif not db.changeBag and ContainerFrame1.DFHooked then
        DF:Print("'Change Bags' was deactivated, but bags were already modified, please /reload.")
    end

    if db.itemcolor and not Module.ItemColorHooked then
        Module.ItemColorHooked = true
        Module:HookColor()

        frame:RegisterEvent('INSPECT_READY')
    elseif not db.itemcolor and Module.ItemColorHooked then
        DF:Print("'Colored Inventory Items' was deactivated, but Icons were already modified, please /reload.")
    end

    if DF.Cata then
        if db.changeTradeskill and not Module.TradeskillHooked then
            Module.TradeskillHooked = true
            Module:UpdateTradeskills()
        elseif not db.changeTradeskill and Module.TradeskillHooked then
            DF:Print(
                "'Change Profession Window' was deactivated, but Professions were already modified, please /reload.")
        end
    end

    if db.changeTrainer and not Module.TrainerHooked then
        Module.TrainerHooked = true
        Module:FuncOrWaitframe('Blizzard_TrainerUI', function()
            DragonflightUIMixin:ChangeTrainerFrame()
        end)
    elseif not db.changeTrainer and Module.TrainerHooked then
        DF:Print("'Change Trainer Window' was deactivated, but TrainerFrame were already modified, please /reload.")
    end
end

function Module:ChangeFrames()
    -- DragonflightUIMixin:UIPanelCloseButton(_G['DragonflightUIConfigFrame'].ClosePanelButton)

    -- Dragonflight Config
    do
        local config = _G['DragonflightUIConfigFrame']
        DragonflightUIMixin:ButtonFrameTemplateNoPortrait(config)
        DragonflightUIMixin:MaximizeMinimizeButtonFrameTemplate(config.MinimizeButton)
        config.MinimizeButton:ClearAllPoints()
        config.MinimizeButton:SetPoint('RIGHT', config.ClosePanelButton, 'LEFT', 0, 0)

        config.KeybindButton:SetPoint('RIGHT', config.MinimizeButton, 'LEFT', 0, 0)
    end

    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(_G['SettingsPanel'])
    -- DragonflightUIMixin:ButtonFrameTemplateNoPortrait(_G['HelpFrame'])

    if DF.Cata then
        --
        DragonflightUIMixin:PortraitFrameTemplate(_G['SpellBookFrame'])
        DragonflightUIMixin:ChangeCharacterFrameCata()
        DragonflightUIMixin:ChangeQuestLogFrameCata()
        DragonflightUIMixin:ChangeDressupFrame()
        DragonflightUIMixin:ChangeTradeFrame()
        DragonflightUIMixin:ChangeGossipFrame()
        DragonflightUIMixin:ChangeQuestFrame()
        DragonflightUIMixin:ChangeTaxiFrame()
        DragonflightUIMixin:ImproveTaxiFrame()
        DragonflightUIMixin:ChangeLootFrame()
        DragonflightUIMixin:PortraitFrameTemplate(_G['FriendsFrame'])
        DragonflightUIMixin:PortraitFrameTemplate(_G['PVPFrame'])
        DragonflightUIMixin:PortraitFrameTemplate(_G['PVEFrame'])
        DragonflightUIMixin:PortraitFrameTemplate(_G['MailFrame'])
        DragonflightUIMixin:PortraitFrameTemplate(_G['AddonList'])
        DragonflightUIMixin:PortraitFrameTemplate(_G['MerchantFrame'])

        Module:FuncOrWaitframe('Blizzard_EncounterJournal', function()
            DragonflightUIMixin:PortraitFrameTemplate(_G['EncounterJournal'])
        end)

        Module:FuncOrWaitframe('Blizzard_Collections', function()
            DragonflightUIMixin:PortraitFrameTemplate(_G['CollectionsJournal'])
        end)

        Module:FuncOrWaitframe('Blizzard_TalentUI', function()
            DragonflightUIMixin:PortraitFrameTemplate(_G['PlayerTalentFrame'])
        end)

        Module:FuncOrWaitframe('Blizzard_Communities', function()
            DragonflightUIMixin:PortraitFrameTemplate(_G['CommunitiesFrame'])
        end)

        Module:FuncOrWaitframe('Blizzard_MacroUI', function()
            DragonflightUIMixin:PortraitFrameTemplate(_G['MacroFrame'])
        end)

        Module:FuncOrWaitframe('Blizzard_TimeManager', function()
            DragonflightUIMixin:PortraitFrameTemplate(_G['TimeManagerFrame'])
            _G['TimeManagerGlobe']:SetDrawLayer('OVERLAY', 5)
        end)

    elseif DF.Wrath then
        --
        print('WRATHHHHHHH')
        -- DragonflightUIMixin:PortraitFrameTemplate(_G['SpellBookFrame'])
        -- DragonflightUIMixin:ChangeCharacterFrameCata()
        DragonflightUIMixin:ChangeQuestLogFrameCata()
        DragonflightUIMixin:ChangeDressupFrame()
        DragonflightUIMixin:ChangeTradeFrame()
        DragonflightUIMixin:ChangeGossipFrame()
        DragonflightUIMixin:ChangeQuestFrame()
        DragonflightUIMixin:ChangeTaxiFrame()
        DragonflightUIMixin:ImproveTaxiFrame()
        DragonflightUIMixin:ChangeLootFrame()
        DragonflightUIMixin:PortraitFrameTemplate(_G['FriendsFrame'])
        -- DragonflightUIMixin:PortraitFrameTemplate(_G['PVPFrame']) -- pp missing
        DragonflightUIMixin:PortraitFrameTemplate(_G['PVEFrame'])
        DragonflightUIMixin:PortraitFrameTemplate(_G['MailFrame'])
        DragonflightUIMixin:PortraitFrameTemplate(_G['AddonList'])
        DragonflightUIMixin:PortraitFrameTemplate(_G['MerchantFrame'])

        -- Module:FuncOrWaitframe('Blizzard_EncounterJournal', function()
        --     DragonflightUIMixin:PortraitFrameTemplate(_G['EncounterJournal'])
        -- end)

        Module:FuncOrWaitframe('Blizzard_Collections', function()
            DragonflightUIMixin:PortraitFrameTemplate(_G['CollectionsJournal'])
        end)

        -- Module:FuncOrWaitframe('Blizzard_TalentUI', function()
        --     DragonflightUIMixin:PortraitFrameTemplate(_G['PlayerTalentFrame'])
        -- end)

        -- Module:FuncOrWaitframe('Blizzard_Communities', function()
        --     DragonflightUIMixin:PortraitFrameTemplate(_G['CommunitiesFrame'])
        -- end)

        Module:FuncOrWaitframe('Blizzard_MacroUI', function()
            DragonflightUIMixin:PortraitFrameTemplate(_G['MacroFrame'])
        end)

        Module:FuncOrWaitframe('Blizzard_TimeManager', function()
            DragonflightUIMixin:PortraitFrameTemplate(_G['TimeManagerFrame'])
            _G['TimeManagerGlobe']:SetDrawLayer('OVERLAY', 5)
        end)
    elseif DF.Era then
        --
        -- DragonflightUIMixin:PortraitFrameTemplate(_G['SpellBookFrame'])
        DragonflightUIMixin:ChangeCharacterFrameEra()
        Module:FuncOrWaitframe('Blizzard_EngravingUI', function()
            EngravingFrame:SetPoint('TOPLEFT', CharacterFrame, 'TOPRIGHT', 9, -75)
        end)
        Module:FuncOrWaitframe('CharacterStatsClassic', function()
            DF.Compatibility:CharacterStatsClassic()
        end)
        Module:FuncOrWaitframe('TacoTip', function()
            DF.Compatibility:TacoTipCharacter()
        end)
        if IsAddOnLoaded('Leatrix_Plus') then
            --
            if QuestLogFrame:GetWidth() > 400 then
                --
                DF:Print(
                    "Leatrix_Plus detected with 'Interface -> Enhance quest log' activated - please deactivate or you might encounter bugs.")
            end
        end
        DragonflightUIMixin:ChangeQuestLogFrameEra()
        DragonflightUIMixin:ChangeDressupFrame()
        DragonflightUIMixin:ChangeTradeFrame()
        DragonflightUIMixin:ChangeGossipFrame()
        DragonflightUIMixin:ChangeQuestFrame()
        DragonflightUIMixin:ChangeTaxiFrame()
        DragonflightUIMixin:ImproveTaxiFrame()
        DragonflightUIMixin:ChangeLootFrame()
        DragonflightUIMixin:PortraitFrameTemplate(_G['FriendsFrame'])
        -- DragonflightUIMixin:PortraitFrameTemplate(_G['PVPFrame'])
        -- DragonflightUIMixin:PortraitFrameTemplate(_G['PVEFrame'])
        DragonflightUIMixin:PortraitFrameTemplate(_G['MailFrame'])
        DragonflightUIMixin:PortraitFrameTemplate(_G['AddonList'])
        DragonflightUIMixin:PortraitFrameTemplate(_G['MerchantFrame'])

        --[[   Module:FuncOrWaitframe('Blizzard_TalentUI', function()
            DragonflightUIMixin:PortraitFrameTemplate(_G['PlayerTalentFrame'])
        end) ]]

        Module:FuncOrWaitframe('Blizzard_Communities', function()
            DragonflightUIMixin:PortraitFrameTemplate(_G['CommunitiesFrame'])
        end)

        Module:FuncOrWaitframe('Blizzard_MacroUI', function()
            DragonflightUIMixin:PortraitFrameTemplate(_G['MacroFrame'])
        end)

        Module:FuncOrWaitframe('Blizzard_TimeManager', function()
            DragonflightUIMixin:PortraitFrameTemplate(_G['TimeManagerFrame'])
            _G['TimeManagerGlobe']:SetDrawLayer('OVERLAY', 5)
        end)
    end
end

function Module:FuncOrWaitframe(addon, func)
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

function Module:UpdateTradeskills()
    local DFProfessionFrame = DragonflightUIMixin:CreateProfessionFrame()

    Module:FuncOrWaitframe('Blizzard_TradeSkillUI', function()
        --[[      local default = {
            whileDead = 1,
            height = 424,
            width = 353,
            bottomClampOverride = 152,
            xoffset = -16,
            yoffset = 12,
            pushable = 3,
            area = "left"
        } ]]
        UIPanelWindows["TradeSkillFrame"] = {
            whileDead = 1,
            height = 424,
            width = 942,
            bottomClampOverride = 152,
            xoffset = -16 + 4,
            yoffset = 12,
            pushable = 3,
            area = "left"
        }

        if IsAddOnLoaded('Leatrix_Plus') then
            --
            if TradeSkillFrame:GetWidth() > 700 then
                --
                DF:Print(
                    "Leatrix_Plus detected with 'Interface -> Enhance professions' activated - please deactivate or you might encounter bugs.")
            end
        end
    end)

    if IsAddOnLoaded('Auctionator') then DF.Compatibility:AuctionatorCraftingInfoFrame() end
end

function Module:HookCharacterFrame()
    local expand = function()
        CharacterFrame:Expand();
    end

    PaperDollFrame:HookScript('OnShow', expand)
    PetPaperDollFrame:HookScript('OnShow', expand)
end

function Module:HookCharacterLevel()
    hooksecurefunc('PaperDollFrame_SetLevel', function()
        local w = CharacterLevelText:GetWidth()
        local y = -32
        CharacterLevelText:ClearAllPoints()
        if (w > 210) then
            if (CharacterFrameInsetRight:IsVisible()) then
                CharacterLevelText:SetPoint("TOP", -10, y);
            else
                CharacterLevelText:SetPoint("TOP", 10, y);
            end
        else
            CharacterLevelText:SetPoint("TOP", 0, y);
        end
    end)
end

function Module:ChangeBags()

    for i = 1, 13 do
        local name = 'ContainerFrame' .. i
        local bag = _G[name]
        DragonflightUIMixin:ChangeBag(bag)

        hooksecurefunc(bag, 'SetHeight', function(frame, height)
            --
            -- print('SetHeight', frame:GetName(), height)
            if bag.DFHeight then
                --
                if math.abs(bag:GetHeight() - bag.DFHeight) > 0.1 then
                    --
                    -- bag:SetHeight(bag.DFHeight)
                    bag:SetSize(bag:GetWidth(), bag.DFHeight)
                end
            end
        end)

        for j = 1, 36 do DragonflightUIMixin:ChangeBagButton(_G[name .. 'Item' .. j]) end
    end

    do
        --	@blizz: Accounts for the vertical anchor offset at the bottom and the height of the titlebar and attic.
        local GetPaddingHeight = function(frame, id)
            if id == 0 then
                return 9 + 48 + 18
            else
                return 9 + 48 - 7
            end
        end

        local CalculateExtraHeight = function(frame, id)
            if id == 0 then
                -- ContainerFrameTokenWatcherMixin.CalculateExtraHeight(self) + self.MoneyFrame:GetHeight();
                local moneyFrame = _G[frame:GetName() .. 'MoneyFrame']
                local tokenFrame = _G['BackpackTokenFrame']

                if tokenFrame:IsVisible() then
                    -- return moneyFrame:GetHeight() + tokenFrame:GetHeight()
                    return 17 + 17
                else
                    -- return moneyFrame:GetHeight()
                    return 17
                end
            else
                return 0
            end
        end

        local CONTAINER_WIDTH = 178;
        local CONTAINER_SPACING = 8;
        local ITEM_SPACING_X = 5;
        local ITEM_SPACING_Y = 5;

        local updateSize = function(frame, size, id)
            local rows = math.ceil(size / 4)
            local itemButton = _G[frame:GetName() .. "Item1"];
            local itemsHeight = (rows * itemButton:GetHeight()) + ((rows - 1) * ITEM_SPACING_Y);
            local newHeight = itemsHeight + GetPaddingHeight(frame, id) + CalculateExtraHeight(frame, id);
            frame.DFHeight = newHeight
            frame:SetHeight(newHeight)

            local newWidth = 4 * itemButton:GetWidth() + 3 * ITEM_SPACING_X + 2 * CONTAINER_SPACING
            frame.DFWidth = newWidth
            frame:SetWidth(newWidth)

            -- print('updateSize', frame:GetName(), size, id, 'w: ' .. newWidth, 'h: ' .. newHeight, '| ' .. frame:GetID())

            if id == 0 then
                frame.DFPortrait:Show()
                local moneyFrame = _G[frame:GetName() .. 'MoneyFrame']
                local tokenFrame = _G['BackpackTokenFrame']

                moneyFrame:ClearAllPoints()
                if tokenFrame:IsVisible() then
                    tokenFrame:ClearAllPoints()
                    tokenFrame:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT', 8, 8)
                    tokenFrame:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -8, 8)

                    moneyFrame:SetPoint('BOTTOMLEFT', tokenFrame, 'TOPLEFT', 0, 3)
                    moneyFrame:SetPoint('BOTTOMRIGHT', tokenFrame, 'TOPRIGHT', 0, 3)
                else
                    moneyFrame:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT', 8, 8)
                    moneyFrame:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -8, 8)
                end

                itemButton:SetPoint('BOTTOMRIGHT', moneyFrame, 'TOPRIGHT', 0, 4)
            else
                frame.DFPortrait:Hide()
                itemButton:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -7, 9)
            end
        end

        --[[   hooksecurefunc('ContainerFrame_GenerateFrame', function(frame, size, id)
            --
            updateSize(frame, size, id)
        end) ]]

        hooksecurefunc('ManageBackpackTokenFrame', function(backpack)
            --   
            local point, relativeTo, relativePoint, xOfs, yOfs = BackpackTokenFrame:GetPoint(1)

            if relativeTo then
                local id = relativeTo:GetID()
                local size = C_Container.GetContainerNumSlots(0)
                updateSize(relativeTo, size, id)
            end
        end)

        do
            --    
            ContainerFrame1.CONTAINER_OFFSET_X_DF = 5
            ContainerFrame1.CONTAINER_OFFSET_Y_DF = 95

            ContainerFrame1.VISIBLE_CONTAINER_SPACING_DF = 3
            ContainerFrame1.CONTAINER_SPACING_DF = 5
        end

        DragonflightUIMixin:ChangeBackpackTokenFrame()
        local searchBox = DragonflightUIMixin:CreateSearchBox()
        local bankSearchBox = DragonflightUIMixin:CreateBankSearchBox()

        Module:FuncOrWaitframe('Blizzard_GuildBankUI', function()
            DragonflightUIMixin:AddGuildbankSearch()
            DragonflightUIItemColorMixin:HookGuildbankBags()
        end)

        hooksecurefunc('ContainerFrame_Update', function(frame)
            --
            local id = frame:GetID()

            -- print('ContainerFrame_Update', frame:GetName(), id)

            if id == 0 then
                --
                searchBox:SetParent(frame)
                searchBox:SetPoint('TOPLEFT', frame, 'TOPLEFT', 42, -37 + 2)
                -- searchBox:SetWidth(frame:GetWidth() - 2 * 42)
                searchBox.AnchorBagRef = frame
                searchBox:Show()

                local addSlotsButton = _G[frame:GetName() .. 'AddSlotsButton']
                if addSlotsButton then
                    --
                    addSlotsButton:ClearAllPoints()
                    addSlotsButton:SetPoint('LEFT', _G[frame:GetName() .. 'Name'], 'LEFT', 0, 0)
                end
            elseif searchBox.AnchorBagRef == frame then
                --
                searchBox:ClearAllPoints()
                searchBox:Hide()
                searchBox.AnchorBagRef = nil
            end

            local size = C_Container.GetContainerNumSlots(id)
            if id == KEYRING_CONTAINER then
                local keyringSize = GetKeyRingSize()
                updateSize(frame, keyringSize, id)
            else
                updateSize(frame, size, id)
            end
        end)
    end
end

function Module:HookColor()
    DragonflightUIItemColorMixin:HookCharacterFrame()
    DragonflightUIItemColorMixin:HookBags()
end

function Module:HookColorInspect()
    DragonflightUIItemColorMixin:HookInspectFrame()
end

-- Cata
function Module.Cata()
    Module:ChangeFrames()
    Module:HookCharacterFrame()
    Module:HookCharacterLevel()

    frame:RegisterEvent('ADDON_LOADED')
    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
    frame:RegisterEvent('INSPECT_READY')
end

-- Wrath
function Module.Wrath()
    Module:ChangeFrames()
end

-- Era
function Module.Era()
    Module:ChangeFrames()
    -- Module:HookCharacterFrame()
    -- Module:HookCharacterLevel()

    -- DragonflightUIMixin:ChangeQuestLogFrameCata()
    -- Module:UpdateTradeskills()

    frame:RegisterEvent('ADDON_LOADED')
    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
end
