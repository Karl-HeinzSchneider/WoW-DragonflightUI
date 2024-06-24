local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'UI'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')
Module.Tmp = {}

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {profile = {scale = 1, first = {}}}
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
    args = {friendsHeader = {type = 'header', name = 'Friendsframe', order = 10}}
}

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
    local db = Module.db.profile
end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1, ...)
    -- print('event', event, arg1, ...)
    if event == 'ADDON_LOADED' then
        -- print('ADDON_LOADED', arg1, ...)
        if arg1 == 'Blizzard_EncounterJournal' then
            DragonflightUIMixin:PortraitFrameTemplate(_G['EncounterJournal'])
        end
    elseif event == 'PLAYER_ENTERING_WORLD' then
        Module:ChangeLateFrames()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)
frame:RegisterEvent('ADDON_LOADED')

function Module:ChangeButtons()
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

    DragonflightUIMixin:PortraitFrameTemplate(_G['SpellBookFrame'])
    DragonflightUIMixin:PortraitFrameTemplate(_G['CharacterFrame'])
    -- DragonflightUIMixin:PortraitFrameTemplate(_G['QuestLogFrame'])
    DragonflightUIMixin:PortraitFrameTemplate(_G['FriendsFrame'])
    DragonflightUIMixin:PortraitFrameTemplate(_G['PVPFrame'])
    DragonflightUIMixin:PortraitFrameTemplate(_G['PVEFrame'])
    DragonflightUIMixin:PortraitFrameTemplate(_G['MailFrame'])
    DragonflightUIMixin:PortraitFrameTemplate(_G['AddonList'])
end

function Module:ChangeLateFrames()
    if IsAddOnLoaded('Blizzard_EncounterJournal') then
        DragonflightUIMixin:PortraitFrameTemplate(_G['EncounterJournal'])
    end
    if IsAddOnLoaded('Blizzard_Collections') then DragonflightUIMixin:PortraitFrameTemplate(_G['CollectionsJournal']) end
    if IsAddOnLoaded('Blizzard_TalentUI') then DragonflightUIMixin:PortraitFrameTemplate(_G['PlayerTalentFrame']) end
    if IsAddOnLoaded('Blizzard_Communities') then DragonflightUIMixin:PortraitFrameTemplate(_G['CommunitiesFrame']) end
    if IsAddOnLoaded('Blizzard_MacroUI') then DragonflightUIMixin:PortraitFrameTemplate(_G['MacroFrame']) end
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
    end

    do
        --	@blizz: Accounts for the vertical anchor offset at the bottom and the height of the titlebar and attic.
        local GetPaddingHeight = function(frame, id)
            if id == 0 then
                return 9 + 48 + 30
            else
                return 9 + 48
            end
        end

        local CalculateExtraHeight = function(frame, id)
            if id == 0 then
                -- ContainerFrameTokenWatcherMixin.CalculateExtraHeight(self) + self.MoneyFrame:GetHeight();
                local moneyFrame = _G[frame:GetName() .. 'MoneyFrame']
                return moneyFrame:GetHeight()
            else
                return 0
            end
        end

        local CONTAINER_WIDTH = 178;
        local CONTAINER_SPACING = 8;
        local ITEM_SPACING_X = 5;
        local ITEM_SPACING_Y = 5;

        hooksecurefunc('ContainerFrame_GenerateFrame', function(frame, size, id)
            --
            local rows = math.ceil(size / 4)
            local itemButton = _G[frame:GetName() .. "Item1"];
            local itemsHeight = (rows * itemButton:GetHeight()) + ((rows - 1) * ITEM_SPACING_Y);
            local newHeight = itemsHeight + GetPaddingHeight(frame, id) + CalculateExtraHeight(frame, id);
            frame:SetHeight(newHeight)

            local newWidth = 4 * itemButton:GetWidth() + 3 * ITEM_SPACING_X + 2 * CONTAINER_SPACING
            frame:SetWidth(newWidth)

            -- print('ContainerFrame_GenerateFrame', frame:GetName(), size, id, 'w: ' .. newWidth, 'h: ' .. newHeight)

            if id == 0 then
                frame.DFPortrait:Show()
                local moneyFrame = _G[frame:GetName() .. 'MoneyFrame']
                moneyFrame:ClearAllPoints()
                moneyFrame:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT', 8, 8)
                moneyFrame:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -8, 8)

                itemButton:SetPoint('BOTTOMRIGHT', moneyFrame, 'TOPRIGHT', 0, 4)
            else
                frame.DFPortrait:Hide()
                itemButton:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -7, 9)
            end
        end)
    end
end

-- Cata
function Module.Cata()
    Module:ChangeButtons()
    Module:HookCharacterFrame()
    Module:HookCharacterLevel()
    Module:ChangeBags()

    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
end

-- Wrath
function Module.Wrath()
end

-- Era
function Module.Era()
end
