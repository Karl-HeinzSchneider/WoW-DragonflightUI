local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Utility'
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

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    DF:RegisterModuleOptions(mName, utilityOptions)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    Module:SetupLookupTable()

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
    DF.ConfigModule:RegisterOptionScreen('Misc', 'Utility', {
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

                if not isOnline or client ~= BNET_CLIENT_WOW then return; end

                local hasFocus, characterName, client, realmName, realmID, faction, race, class, guild, zoneName, level,
                      gameText, broadcastText, broadcastTime, canSoR, toonID, bnetIDAccount, isGameAFK, isGameBusy =
                    BNGetGameAccountInfo(bnetIDGameAccount)

                -- print(accountName, characterName, class, faction)

                if (characterName) then
                    local classFixed = Module.LocalClassTable[class]
                    local color = RAID_CLASS_COLORS[classFixed]

                    if not color then return end

                    local englishFaction, localizedFaction = UnitFactionGroup('player')

                    nameText = accountName .. " " .. "|c" .. color.colorStr .. "(" .. characterName .. ': ' .. level ..
                                   ")" .. FONT_COLOR_CODE_CLOSE;

                    if faction ~= localizedFaction then nameText = nameText .. ' (' .. faction .. ')' end

                    button.name:SetText(nameText)
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

-- Cata
function Module.Cata()
end

-- Wrath
function Module.Wrath()
end

-- Era
function Module.Era()
end
