local addonName, addonTable = ...;
local Helper = addonTable.Helper;
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

local t = {}
DF.BossTable = t

local getIndex = 1;
local maxBoss = 0;

local alreadyRandom = {};
local maxReroll = 5;

function DF:GetRandomBoss()
    -- local vip = DF.VIPTable[getIndex];

    -- getIndex = getIndex + 1;

    -- if getIndex > maxVIPs then getIndex = 1; end

    -- return vip;

    local rand;

    for k = 1, maxReroll do
        rand = fastrandom(1, maxBoss);
        if not alreadyRandom[rand] then
            alreadyRandom[rand] = true;
            return t[rand]
        else
            -- print('REROLL', k, rand)
        end
    end
    return t[rand]
end

table.insert(t, {
    name = [[C'Thun]],
    level = '??',
    class = 'PALADIN',
    powerType = 'MANA',
    hpAmount = 100,
    energyAmount = 0,
    targetIcon = 0,
    role = 'TANK',
    extra = 'worldboss',
    displayID = 15787
    -- displayTexture = 'zimtschnecke128'
})

table.insert(t, {
    name = [[Ragnaros]],
    level = '??',
    class = 'PALADIN',
    powerType = 'MANA',
    hpAmount = 100,
    energyAmount = 0,
    targetIcon = 0,
    role = 'TANK',
    extra = 'worldboss',
    displayID = 11121
    -- displayTexture = 'zimtschnecke128'
})

table.insert(t, {
    name = [[Hogger]],
    level = '11',
    class = 'PALADIN',
    powerType = 'MANA',
    hpAmount = 100,
    energyAmount = 0,
    targetIcon = 0,
    role = 'TANK',
    extra = 'elite',
    displayID = 384
    -- displayTexture = 'zimtschnecke128'
})

table.insert(t, {
    name = [[Vaelastrasz]],
    level = '??',
    class = 'PALADIN',
    powerType = 'MANA',
    hpAmount = 100,
    energyAmount = 0,
    targetIcon = 0,
    role = 'TANK',
    extra = 'worldboss',
    displayID = 9909
    -- displayTexture = 'zimtschnecke128'
})

table.insert(t, {
    name = [[Baron Rivendare]],
    level = '62',
    class = 'PALADIN',
    powerType = 'MANA',
    hpAmount = 100,
    energyAmount = 0,
    targetIcon = 0,
    role = 'TANK',
    extra = 'elite',
    displayID = 10729
    -- displayTexture = 'zimtschnecke128'
})

table.insert(t, {
    name = [[Chromie]],
    level = '63',
    class = 'MAGE',
    powerType = 'MANA',
    hpAmount = 100,
    energyAmount = 100,
    targetIcon = 0,
    role = 'TANK',
    extra = 'worldboss',
    displayID = 10008
    -- displayTexture = 'zimtschnecke128'
})

maxBoss = #t;
