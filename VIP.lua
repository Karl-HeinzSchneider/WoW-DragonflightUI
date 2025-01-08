local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

DF.VIPTable = {}

local getIndex = 1;
local maxVIPs = 0;

function DF:GetRandomVIP()
    local vip = DF.VIPTable[getIndex];

    getIndex = getIndex + 1;

    if getIndex > maxVIPs then getIndex = 1; end

    return vip;
end

table.insert(DF.VIPTable, {
    name = 'Zimtschnecke',
    level = '69',
    class = 'PALADIN',
    powerType = 'MANA',
    hpAmount = 100,
    energyAmount = 100,
    targetIcon = 0,
    role = 'TANK',
    extra = 'worldboss',
    displayID = 176 -- awrwrwrll
})

table.insert(DF.VIPTable, {
    name = 'Dratini',
    level = '??',
    class = 'MAGE',
    powerType = 'RAGE',
    hpAmount = 100,
    energyAmount = 100,
    targetIcon = 0,
    role = 'TANK',
    extra = 'worldboss',
    displayID = 6290 -- dragon
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
    displayID = 73 -- wolf
})

-- DevTools_Dump(DF.VIPTable)
maxVIPs = #DF.VIPTable;
