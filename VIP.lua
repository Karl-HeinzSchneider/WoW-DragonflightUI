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
    extra = 'worldboss',
    displayID = 369 -- awrwrwrll
})

table.insert(DF.VIPTable, {
    name = 'Dratini',
    level = '??',
    class = 'MAGE',
    powerType = 'RAGE',
    hpAmount = 100,
    energyAmount = 100,
    targetIcon = 0,
    extra = 'worldboss',
    displayID = 6290 -- dragon
})

-- DevTools_Dump(DF.VIPTable)
maxVIPs = #DF.VIPTable;
