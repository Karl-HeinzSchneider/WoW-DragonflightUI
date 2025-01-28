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

table.insert(DF.VIPTable, {
    name = 'Baldvin',
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

-- DevTools_Dump(DF.VIPTable)
maxVIPs = #DF.VIPTable;
