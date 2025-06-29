---@class DragonflightUI
---@diagnostic disable-next-line: assign-type-mismatch
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
---@type API
local API = DF.API;
---@type VersionAPI
local Version = API.Version;

local mName = 'UI'
---@diagnostic disable-next-line: undefined-field
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')
Module.Tmp = {}

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        scale = 1,
        first = {
            changeBag = true,
            itemcolor = true,
            changeCharacterframe = true,
            changeSpellBook = true,
            changeSpellBookProfessions = true,
            changeInspect = true,
            changeTradeskill = true,
            changeTrainer = true,
            changeTalents = true,
            questLevel = true
        }
    }
}

if DF.Wrath and not DF.Cata then
    defaults.profile.first.changeSpellBook = false
    defaults.profile.first.changeSpellBookProfessions = false
    defaults.profile.first.changeTradeskill = false
    defaults.profile.first.changeTalents = false
end

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
    name = L["UIUtility"],
    get = getOption,
    set = setOption,
    args = {
        changeBag = {
            type = 'toggle',
            name = L["UIChangeBags"],
            desc = L["UIChangeBagsDesc"] .. getDefaultStr('changeBag', 'first'),
            order = 21
        },
        itemcolor = {
            type = 'toggle',
            name = L["UIColoredInventoryItems"],
            desc = L["UIColoredInventoryItemsDesc"] .. getDefaultStr('itemcolor', 'first'),
            order = 22
        },
        questLevel = {
            type = 'toggle',
            name = L["UIShowQuestlevel"],
            desc = L["UIShowQuestlevelDesc"] .. getDefaultStr('questLevel', 'first'),
            order = 23
        },
        headerFrames = {type = 'header', name = L["UIFrames"], desc = L["UIFramesDesc"], order = 100},
        changeCharacterframe = {
            type = 'toggle',
            name = L["UIChangeCharacterFrame"],
            desc = L["UIChangeCharacterFrameDesc"] .. getDefaultStr('changeCharacterframe', 'first'),
            order = 101,
            new = false
        },
        changeTradeskill = {
            type = 'toggle',
            name = L["UIChangeProfessionWindow"],
            desc = L["UIChangeProfessionWindowDesc"] .. getDefaultStr('changeTradeskill', 'first'),
            order = 102
        },
        changeInspect = {
            type = 'toggle',
            name = L["UIChangeInspectFrame"],
            desc = L["UIChangeInspectFrameDesc"] .. getDefaultStr('changeInspect', 'first'),
            order = 104,
            new = false
        },
        changeTrainer = {
            type = 'toggle',
            name = L["UIChangeTrainerWindow"],
            desc = L["UIChangeTrainerWindowDesc"] .. getDefaultStr('changeTrainer', 'first'),
            order = 104
        }
    }
}

if DF.Era or (DF.Wrath and not DF.Cata) then
    local moreOptions = {
        changeTalents = {
            type = 'toggle',
            name = L["UIChangeTalentFrame"],
            desc = L["UIChangeTalentFrameDesc"] .. getDefaultStr('changeTalents', 'first'),
            order = 103,
            new = false
        },
        changeSpellBook = {
            type = 'toggle',
            name = L["UIChangeSpellBook"],
            desc = L["UIChangeSpellBookDesc"] .. getDefaultStr('changeSpellBook', 'first'),
            order = 101.1,
            new = false
        },
        changeSpellBookProfessions = {
            type = 'toggle',
            name = L["UIChangeSpellBookProfessions"],
            desc = L["UIChangeSpellBookProfessionsDesc"] .. getDefaultStr('changeSpellBookProfessions', 'first'),
            order = 101.2,
            new = false
        }
    }

    for k, v in pairs(moreOptions) do UIOptions.args[k] = v end
end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1, ...)
    -- print('event', event, arg1, ...)   
    if event == 'INSPECT_READY' then
        -- print('INSPECT_READY')
        local db = Module.db.profile.first
        if db.itemcolor then DragonflightUIItemColorMixin:HookInspectFrame() end
        if db.changeInspect and not Module.InspectHooked then
            Module.InspectHooked = true

            Module:FuncOrWaitframe('Blizzard_InspectUI', function()
                DragonflightUIMixin:ChangeInspectFrame()
            end)

            if InspectFrame and not InspectFrame.DFTacoTipHooked then
                --    
                Module:FuncOrWaitframe('TacoTip', function()
                    DF.Compatibility:TacoTipInspect()
                end)
                InspectFrame.DFTacoTipHooked = true
            end
        elseif not db.changeInspect and Module.InspectHooked then
            DF:Print(
                "'Change InspectFrame Window' was deactivated, but InspectFrame was already modified, please /reload.")
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
    hooksecurefunc(DF:GetModule('Config'), 'AddConfigFrame', function()
        Module:RegisterSettings()
    end)

    ---@diagnostic disable-next-line: undefined-field
    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    DF:RegisterModuleOptions(mName, UIOptions)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    self:EnableAddonSpecific()

    Module:ApplySettings()
    Module:RegisterOptionScreens()

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)
        Module:ApplySettings()
        Module:RefreshOptionScreens()
    end)
end

function Module:OnDisable()
end

function Module:RegisterSettings()
    local moduleName = 'UI'
    local cat = 'misc'
    local function register(name, data)
        data.module = moduleName;
        DF.ConfigModule:RegisterSettingsElement(name, cat, data, true)
    end

    register('ui', {order = 0, name = 'UI', descr = 'UIsss', isNew = false})
end

function Module:RegisterOptionScreens()
    DF.ConfigModule:RegisterSettingsData('ui', 'misc', {
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

    self:ConditionalOption('changeBag', 'first', 'Change Bags', function()
        Module:ChangeBags()

        frame:RegisterEvent('BAG_UPDATE_DELAYED')
        frame:RegisterEvent('BANKFRAME_OPENED')
        frame:RegisterEvent('PLAYERBANKSLOTS_CHANGED')
        frame:RegisterEvent('GUILDBANKBAGSLOTS_CHANGED')
    end)

    self:ConditionalOption('itemcolor', 'first', 'Colored Inventory Items', function()
        Module:HookColor()

        frame:RegisterEvent('INSPECT_READY')
    end)

    self:ConditionalOption('changeTradeskill', 'first', 'Change Profession Window', function()
        Module:UpdateTradeskills()
    end)

    if DF.Era or (DF.Wrath and not DF.Cata) then
        self:ConditionalOption('changeSpellBook', 'first', 'Change SpellBook', function()
            DragonflightUIMixin:ChangeSpellbookEra()
        end)

        self:ConditionalOption('changeSpellBookProfessions', 'first', 'Change SpellBook Professions', function()
            DragonflightUIMixin:SpellbookEraAddTabs()
            DragonflightUIMixin:SpellbookEraProfessions()
        end)
    end

    self:ConditionalOption('changeTrainer', 'first', 'Change Trainer Window', function()
        Module:FuncOrWaitframe('Blizzard_TrainerUI', function()
            DragonflightUIMixin:ChangeTrainerFrame()
        end)
    end)

    self:ConditionalOption('changeCharacterframe', 'first', 'Change Characterframe', function()
        if DF.Cata then
            -- DragonflightUIMixin:ChangeCharacterFrameCata()
            Module:HookCharacterLevel()
        elseif DF.Wrath then
            DragonflightUIMixin:ChangeCharacterFrameEra()
        elseif DF.Era then
            DragonflightUIMixin:ChangeCharacterFrameEra()
            Module:FuncOrWaitframe('Blizzard_EngravingUI', function()
                EngravingFrame:SetPoint('TOPLEFT', CharacterFrame, 'TOPRIGHT', 9, -75)

                RuneFrameControlButton:ClearAllPoints()
                RuneFrameControlButton:SetPoint('TOPRIGHT', CharacterFrame, 'TOPRIGHT', -8, -26)
            end)
        end
    end)

    if (DF.Era or (DF.Wrath and not DF.Cata and false)) then
        self:ConditionalOption('changeTalents', 'first', 'Change Talentframe', function()
            Module:FuncOrWaitframe('Blizzard_TalentUI', function()
                DragonflightUIMixin:ChangeTalentsEra()
            end)
        end)
    end

    self:ConditionalOption('questLevel', 'first', 'Show Questlevel', function()
        DragonflightUIMixin:AddQuestLevel()
    end)
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

    if Version.IsClassic then
        --
        -- DragonflightUIMixin:ChangeSpellbookEra()
        -- DragonflightUIMixin:SpellbookEraAddTabs()
        -- DragonflightUIMixin:SpellbookEraProfessions()  
        --[[ DragonflightUIMixin:ChangeCharacterFrameEra()
        Module:FuncOrWaitframe('Blizzard_EngravingUI', function()
            EngravingFrame:SetPoint('TOPLEFT', CharacterFrame, 'TOPRIGHT', 9, -75)
        end)
        Module:FuncOrWaitframe('CharacterStatsClassic', function()
            DF.Compatibility:CharacterStatsClassic()
        end) 
        Module:FuncOrWaitframe('TacoTip', function()
            DF.Compatibility:TacoTipCharacter()
        end) ]]
        if DF:IsAddOnLoaded('Leatrix_Plus') then
            --
            if QuestLogFrame:GetWidth() > 400 then
                --
                DF:Print(
                    "Leatrix_Plus detected with 'Interface -> Enhance quest log' activated - please deactivate or you might encounter bugs.")
            end
        end
        DragonflightUIMixin:ChangeQuestLogFrameEra()
        DragonflightUIMixin:ChangeDressupFrame()
        DragonflightUIMixin:EnhanceDressupFrame()
        DragonflightUIMixin:ChangeTradeFrame()
        DragonflightUIMixin:ChangeGossipFrame()
        DragonflightUIMixin:ChangeQuestFrame()
        DragonflightUIMixin:ShowQuestXP()
        DragonflightUIMixin:ChangeTaxiFrame()
        DragonflightUIMixin:ImproveTaxiFrame()
        DragonflightUIMixin:ChangeLootFrame()
        DragonflightUIMixin:PortraitFrameTemplate(_G['FriendsFrame'])
        -- DragonflightUIMixin:PortraitFrameTemplate(_G['PVPFrame'])
        -- DragonflightUIMixin:PortraitFrameTemplate(_G['PVEFrame'])
        DragonflightUIMixin:PortraitFrameTemplate(_G['MailFrame'])
        DragonflightUIMixin:PortraitFrameTemplate(_G['AddonList'])
        DragonflightUIMixin:PortraitFrameTemplate(_G['MerchantFrame'])

        Module:FuncOrWaitframe('Blizzard_Communities', function()
            DragonflightUIMixin:PortraitFrameTemplate(_G['CommunitiesFrame'])
        end)

        Module:FuncOrWaitframe('Blizzard_GroupFinder_VanillaStyle', function()
            --
            -- DragonflightUIMixin:ChangeLFGListingFrameEra()
        end)

        Module:FuncOrWaitframe('Blizzard_MacroUI', function()
            DragonflightUIMixin:PortraitFrameTemplate(_G['MacroFrame'])
        end)

        Module:FuncOrWaitframe('Blizzard_TimeManager', function()
            DragonflightUIMixin:PortraitFrameTemplate(_G['TimeManagerFrame'])
            _G['TimeManagerGlobe']:SetDrawLayer('OVERLAY', 5)
        end)
    elseif Version.IsTBC then
    elseif Version.IsWotlk then
        DragonflightUIMixin:ChangeQuestLogFrameCata()
        DragonflightUIMixin:ChangeDressupFrame()
        DragonflightUIMixin:EnhanceDressupFrame()
        DragonflightUIMixin:ChangeTradeFrame()
        DragonflightUIMixin:ChangeGossipFrame()
        DragonflightUIMixin:ChangeQuestFrame()
        DragonflightUIMixin:ChangeTaxiFrame()
        DragonflightUIMixin:ImproveTaxiFrame()
        DragonflightUIMixin:ChangeLootFrame()
        DragonflightUIMixin:PortraitFrameTemplate(_G['FriendsFrame'])
        -- DragonflightUIMixin:PortraitFrameTemplate(_G['PVPFrame']) -- pp missing
        -- DragonflightUIMixin:ChangeWrathPVPFrame()
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
    elseif Version.IsCata then
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
    elseif Version.IsMoP then
        DragonflightUIMixin:PortraitFrameTemplate(_G['SpellBookFrame'])
        DragonflightUIMixin:ChangeCharacterFrameCata()
        DragonflightUIMixin:ChangeQuestLogFrameCata()
        -- DragonflightUIMixin:ChangeDressupFrame() -- TODO
        DragonflightUIMixin:ChangeTradeFrame()
        DragonflightUIMixin:ChangeGossipFrame()
        DragonflightUIMixin:ChangeQuestFrame()
        DragonflightUIMixin:ChangeTaxiFrameMists()
        -- DragonflightUIMixin:ImproveTaxiFrame()
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
    end
end

function Module:UpdateTradeskills()
    do
        local loaded, reason = DF:LoadAddOn('Blizzard_TradeSkillUI')
        -- print('--', loaded, reason)    
    end
    if not DF.API.Version.IsWotlk then
        local loaded, reason = DF:LoadAddOn('Blizzard_CraftUI')
        -- print('--', loaded, reason)
    end

    local prof = CreateFrame('Frame', 'DragonflightUIProfessionFrame', UIParent, 'DFProfessionFrameTemplate')
    Module.ProfessionFrame = prof
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
        local searchBox = _G['BagItemSearchBox'] or DragonflightUIMixin:CreateSearchBox()
        searchBox:SetSize(115, 20)
        local bankSearchBox = _G['BankItemSearchBox'] or DragonflightUIMixin:CreateBankSearchBox()
        bankSearchBox:SetSize(110, 20)

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
                searchBox:ClearAllPoints()
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

function Module:Era()
    Module:ChangeFrames()

    frame:RegisterEvent('ADDON_LOADED')
    frame:RegisterEvent('PLAYER_ENTERING_WORLD')

    DF.Compatibility:FuncOrWaitframe('Ranker', function()
        DF.Compatibility:ClassicRanker()
    end)
end

function Module:TBC()
end

function Module:Wrath()
    Module:ChangeFrames()
end

function Module:Cata()
    Module:ChangeFrames()
    Module:HookCharacterFrame()

    frame:RegisterEvent('ADDON_LOADED')
    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
    frame:RegisterEvent('INSPECT_READY')
end

function Module:Mists()
    Module:ChangeFrames()
    Module:HookCharacterFrame()

    frame:RegisterEvent('ADDON_LOADED')
    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
    frame:RegisterEvent('INSPECT_READY')
end
