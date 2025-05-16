---@class DragonflightUI
---@diagnostic disable-next-line: assign-type-mismatch
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Utility'
---@diagnostic disable-next-line: undefined-field
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')
Module.Tmp = {}

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {profile = {scale = 1, first = {friendsColor = true}}}
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

local utilityOptions = {
    type = 'group',
    name = 'Utility',
    get = getOption,
    set = setOption,
    args = {
        friendsHeader = {type = 'header', name = 'Friendsframe', order = 10},
        friendsColor = {
            type = 'toggle',
            name = 'Class Color',
            desc = '' .. getDefaultStr('friendsColor', 'first'),
            order = 11
        }
    }
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)
    hooksecurefunc(DF:GetModule('Config'), 'AddConfigFrame', function()
        Module:RegisterSettings()
    end)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    DF:RegisterModuleOptions(mName, utilityOptions)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    Module:SetupLookupTable()

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
    local moduleName = 'Utility'
    local cat = 'misc'
    local function register(name, data)
        data.module = moduleName;
        DF.ConfigModule:RegisterSettingsElement(name, cat, data, true)
    end

    register('utility', {order = 0, name = 'Utility', descr = 'Utilityss', isNew = false})
end

function Module:RegisterOptionScreens()
    DF.ConfigModule:RegisterSettingsData('utility', 'misc', {
        name = 'Utility',
        sub = 'first',
        options = utilityOptions,
        default = function()
            setDefaultSubValues('first')
        end
    })
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    ---@diagnostic disable-next-line: undefined-field
    local configFrame = DF.ConfigModule.ConfigFrame

    local refreshCat = function(name)
        configFrame:RefreshCatSub('Misc', name)
    end

    refreshCat('Utility')
end

function Module:ApplySettings()
    local db = Module.db.profile

    Module:HookFriendsColor(db.first.friendsColor)
end

function Module:SetupLookupTable()
    local localClassTable = {}
    if GetLocale() ~= "enUS" then
        for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
            --
            localClassTable[v] = k

        end
    else
        for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
            --
            localClassTable[v] = k
        end
    end
    Module.LocalClassTable = localClassTable
end

local FRIENDS_BUTTON_TYPE_DIVIDER = FRIENDS_BUTTON_TYPE_DIVIDER or 1;
local FRIENDS_BUTTON_TYPE_BNET = FRIENDS_BUTTON_TYPE_BNET or 2;
local FRIENDS_BUTTON_TYPE_WOW = FRIENDS_BUTTON_TYPE_WOW or 3;
local FRIENDS_BUTTON_TYPE_INVITE = FRIENDS_BUTTON_TYPE_INVITE or 4;
local FRIENDS_BUTTON_TYPE_INVITE_HEADER = FRIENDS_BUTTON_TYPE_INVITE_HEADER or 5;

function Module:HookFriendsColor(hook)
    self:Unhook('FriendsFrame_UpdateFriendButton')
    if hook then
        self:SecureHook('FriendsFrame_UpdateFriendButton', function(button)
            if (button.buttonType == FRIENDS_BUTTON_TYPE_BNET) then
                local index = button.index
                local bnetIDAccount, accountName, battleTag, isBattleTag, characterName, bnetIDGameAccount, client,
                      isOnline, lastOnline, isBnetAFK, isBnetDND, messageText, noteText, isRIDFriend, messageTime,
                      canSoR = BNGetFriendInfo(button.id);

                if not button.DFHeart then
                    local heart = button:CreateTexture()
                    heart:SetTexture(135451)
                    heart:SetPoint('RIGHT', button.gameIcon, 'LEFT', -2, 0)
                    heart:SetSize(26, 26)
                    button.DFHeart = heart
                end

                if string.match(noteText or '', "<3") then
                    button.DFHeart:Show()
                else
                    button.DFHeart:Hide()
                end

                if not isOnline or client ~= BNET_CLIENT_WOW then return; end

                local hasFocus, characterName, client, realmName, realmID, faction, race, class, guild, zoneName, level,
                      gameText, broadcastText, broadcastTime, canSoR, toonID, bnetIDAccount, isGameAFK, isGameBusy =
                    BNGetGameAccountInfo(bnetIDGameAccount)

                -- print(accountName, characterName, class, faction, realmName, realmID)

                if (characterName) then
                    local classFixed = Module.LocalClassTable[class]
                    local classColors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
                    local color = classColors[classFixed]

                    if not color then return end

                    local englishFaction, localizedFaction = UnitFactionGroup('player')

                    local nameText = accountName .. " " .. "|c" .. color.colorStr .. "(" .. characterName .. ': ' ..
                                         level .. ")" .. FONT_COLOR_CODE_CLOSE;

                    if faction ~= localizedFaction then
                        nameText = nameText .. ' (' .. faction .. ') '
                    end

                    local gameAccountInfo = C_BattleNet.GetGameAccountInfoByID(bnetIDGameAccount);
                    local infoText = gameAccountInfo.richPresence
                    -- DevTools_Dump(gameAccountInfo)

                    -- print(accountName, characterName, class, faction, realmName, realmID, gameAccountInfo.wowProjectID)

                    local localRealmID = GetRealmID()
                    if realmID == localRealmID then
                        local flavor = 'WoW'

                        if gameAccountInfo.wowProjectID == 2 then
                            flavor = 'Classic Era'
                        elseif gameAccountInfo.wowProjectID == 14 then
                            flavor = 'Cataclysm Classic'
                        end

                        infoText = flavor .. ' - ' .. "|cFFFFFFFF" .. gameAccountInfo.realmName .. FONT_COLOR_CODE_CLOSE

                        button.info:SetText(infoText)
                        -- button.info:SetTextColor(255, 255, 255)
                        -- button.info:SetTextColor(FRIENDS_GRAY_COLOR.r, FRIENDS_GRAY_COLOR.g, FRIENDS_GRAY_COLOR.b)
                    else
                        button.info:SetText(infoText)
                        button.info:SetTextColor(FRIENDS_GRAY_COLOR.r, FRIENDS_GRAY_COLOR.g, FRIENDS_GRAY_COLOR.b)
                    end

                    button.name:SetText(nameText)
                    button.info:SetText(infoText)
                end
            end
        end)
    end
end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1)
    -- print('event', event) 
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module:Era()
end

function Module:TBC()
end

function Module:Wrath()
end

function Module:Cata()
end

function Module:Mists()
end
