local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

DF.VIPTable = {}

local getIndex = 1;
local maxVIPs = 0;

local alreadyRandom = {};
local maxReroll = 5;

function DF:GetRandomVIP()
    -- local vip = DF.VIPTable[getIndex];

    -- getIndex = getIndex + 1;

    -- if getIndex > maxVIPs then getIndex = 1; end

    -- return vip;

    local rand;

    for k = 1, maxReroll do
        rand = fastrandom(1, maxVIPs);
        if not alreadyRandom[rand] then
            alreadyRandom[rand] = true;
            return DF.VIPTable[rand]
        else
            -- print('REROLL', k, rand)
        end
    end
    return DF.VIPTable[rand]
end

table.insert(DF.VIPTable, {
    name = 'Zimtschnecke',
    titleAfter = ", Death's Demise",
    realm = 'Everlook',
    guild = 'Zimtschneckendepot',
    guildRank = 'Oberschnecke',
    zone = 'Stormwind City',
    race = 'Human',
    female = true,
    level = '85',
    class = 'PALADIN',
    powerType = 'MANA',
    hpAmount = 100,
    energyAmount = 100,
    targetIcon = 0,
    role = 'TANK',
    extra = 'worldboss',
    displayID = 176, -- awrwrwrll
    displayTexture = 'zimtschnecke128'
})

table.insert(DF.VIPTable, {
    name = 'Zimtgirly',
    titleAfter = ", Death's Demise",
    realm = 'Everlook',
    guild = 'Zimtschneckendepot',
    guildRank = 'Schnecke',
    -- zone = 'Stormwind City',
    race = 'Gnome',
    female = true,
    level = '85',
    class = 'DEATHKNIGHT',
    powerType = 'RUNIC_POWER',
    hpAmount = 100,
    energyAmount = 100,
    targetIcon = 0,
    role = 'TANK',
    extra = 'worldboss',
    displayID = 176, -- awrwrwrll
    displayTexture = 'zimtgirly'
})

table.insert(DF.VIPTable, {
    name = 'Dratini',
    -- titleAfter = ", Death's Demise",
    -- realm = 'Razorfen',
    -- guild = 'Zimtschnecken Depot',
    -- guildRank = 'Oberschnecke',
    -- zone = 'Stormwind City',
    race = 'Gnome',
    female = true,
    level = '??',
    class = 'MAGE',
    powerType = 'RUNIC_POWER',
    hpAmount = 100,
    energyAmount = 100,
    targetIcon = 0,
    role = 'TANK',
    extra = 'worldboss',
    displayID = 6290, -- dragon
    displayTexture = 'dratini'
})

table.insert(DF.VIPTable, {
    name = 'Norbert',
    titleAfter = " The Great",
    realm = 'Razorfen',
    guild = 'Affenbande Reloaded',
    guildRank = 'WOLF',
    -- zone = 'Stormwind City',
    race = 'Wolf',
    female = false,
    level = '??',
    class = 'WARRIOR',
    powerType = 'FOCUS',
    hpAmount = 100,
    energyAmount = 69,
    targetIcon = 0,
    role = 'DAMAGER',
    extra = 'worldboss',
    displayID = 73, -- wolf
    displayTexture = 'norbert'
})

table.insert(DF.VIPTable, {
    name = 'Matada',
    -- titleAfter = ", Death's Demise",
    -- realm = 'Razorfen',
    -- guild = 'Zimtschnecken Depot',
    -- guildRank = 'Oberschnecke',
    -- zone = 'Stormwind City',
    race = 'Human',
    female = true,
    level = '60',
    class = 'PRIEST',
    powerType = 'MANA',
    hpAmount = 100,
    energyAmount = 100,
    targetIcon = 0,
    role = 'HEALER',
    extra = '',
    displayID = 176 -- wolf
})

table.insert(DF.VIPTable, {
    name = 'Schokobon',
    -- titleAfter = ", Death's Demise",
    -- realm = 'Razorfen',
    -- guild = 'Zimtschnecken Depot',
    -- guildRank = 'Oberschnecke',
    -- zone = 'Stormwind City',
    race = 'Gnome',
    female = false,
    level = '85',
    class = 'MAGE',
    powerType = 'MANA',
    hpAmount = 100,
    energyAmount = 100,
    targetIcon = 0,
    role = 'DAMAGER',
    extra = '',
    displayID = 176, -- wolf
    displayTexture = 'schokobon'
})

table.insert(DF.VIPTable, {
    name = 'Jagrune',
    -- titleAfter = ", Death's Demise",
    realm = 'Razorfen',
    guild = 'Horizon',
    -- guildRank = 'Oberschnecke',
    -- zone = 'Stormwind City',
    race = 'Nightelf',
    female = true,
    level = '60',
    class = 'HUNTER',
    powerType = 'MANA',
    hpAmount = 100,
    energyAmount = 100,
    targetIcon = 0,
    role = 'DAMAGER',
    extra = '',
    displayID = 176, -- wolf
    displayTexture = 'jag'
})

-- jag2
table.insert(DF.VIPTable, {
    name = 'Turqoise',
    -- titleAfter = ", Death's Demise",
    -- realm = 'Razorfen',
    -- guild = 'Horizon',
    -- guildRank = 'Oberschnecke',
    -- zone = 'Stormwind City',
    race = 'Nightelf',
    female = true,
    level = '60',
    class = 'HUNTER',
    powerType = 'MANA',
    hpAmount = 100,
    energyAmount = 100,
    targetIcon = 0,
    role = 'DAMAGER',
    extra = '',
    -- displayID = XXX, -- cat !?
    displayTexture = 'jag'
})

table.insert(DF.VIPTable, {
    name = 'Baldvin',
    -- titleAfter = ", Death's Demise",
    -- realm = 'Razorfen',
    -- guild = 'Zimtschnecken Depot',
    -- guildRank = 'Oberschnecke',
    -- zone = 'Stormwind City',
    -- race = 'Human',
    -- female = true,
    level = '60',
    class = 'PALADIN',
    powerType = 'MANA',
    hpAmount = 100,
    energyAmount = 100,
    targetIcon = 0,
    role = 'TANK',
    extra = 'worldboss',
    displayID = 176, -- awrwrwrll
    displayTexture = 'baldvin'
})

table.insert(DF.VIPTable, {
    name = 'Marnik',
    -- titleAfter = ", Death's Demise",
    -- realm = 'Razorfen',
    -- guild = 'Zimtschnecken Depot',
    -- guildRank = 'Oberschnecke',
    -- zone = 'Stormwind City',
    -- race = 'Human',
    -- female = true, 
    level = '60',
    class = 'PALADIN',
    powerType = 'MANA',
    hpAmount = 100,
    energyAmount = 100,
    targetIcon = 0,
    role = 'HEALER',
    extra = '',
    displayTexture = 'marnik'
})

table.insert(DF.VIPTable, {
    name = 'Theunder ',
    -- titleAfter = ", Death's Demise",
    -- realm = 'Razorfen',
    -- guild = 'Zimtschnecken Depot',
    -- guildRank = 'Oberschnecke',
    -- zone = 'Stormwind City',
    -- race = 'Human',
    -- female = true,
    level = '60',
    class = 'WARRIOR',
    powerType = 'RAGE',
    hpAmount = 100,
    energyAmount = 100,
    targetIcon = 0,
    role = 'TANK',
    extra = '',
    displayTexture = 'marnik2'
})

table.insert(DF.VIPTable, {
    name = 'Shirin',
    titleAfter = " the Kingslayer",
    realm = 'Everlook',
    guild = 'Horizon',
    guildRank = 'Ghettobitch',
    zone = 'Stormwind City',
    race = 'Human',
    female = true,
    level = '90',
    class = 'PRIEST',
    powerType = 'MANA',
    hpAmount = 100,
    energyAmount = 100,
    targetIcon = 0,
    role = 'HEALER',
    extra = 'worldboss',
    displayID = 176, -- awrwrwrll
    displayTexture = 'shirin'
})

table.insert(DF.VIPTable, {
    name = 'Nalany',
    titleAfter = " the Ringless",
    realm = 'Thunderstrike',
    guild = 'Dinos',
    guildRank = 'Officer',
    zone = 'Darnassus',
    race = 'Nightelf',
    female = true,
    level = '60',
    class = 'DRUID',
    powerType = 'MANA',
    hpAmount = 100,
    energyAmount = 100,
    targetIcon = 0,
    role = 'HEALER',
    extra = 'worldboss',
    displayID = 176, -- awrwrwrll
    displayTexture = 'nalany'
})

table.insert(DF.VIPTable, {
    name = 'Mayomay',
    -- titleAfter = ", ?",
    realm = 'Thunderstrike',
    guild = 'Wolfrudel',
    guildRank = 'Sergeant Major',
    zone = 'Stormwind City',
    race = 'Human',
    female = true,
    level = '60',
    class = 'WARLOCK',
    powerType = 'MANA',
    hpAmount = 100, -- 5514
    energyAmount = 100,
    targetIcon = 0,
    role = 'DAMAGER',
    extra = '',
    displayTexture = 'mayomay'
})

-- DevTools_Dump(DF.VIPTable)
maxVIPs = #DF.VIPTable;
