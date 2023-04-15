local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

local options, moduleOptions = nil, {}
local function getOptions()
    return {}
end

function DF:SetupOptions()
    self.optFrames = {}
    LibStub('AceConfigRegistry-3.0'):RegisterOptionsTable('DragonflightUI', getOptions)
    self.optFrames.DragonflightUI =
        LibStub('AceConfigDialog-3.0'):AddToBlizOptions('DragonflightUI', 'DragonflightUI', nil, 'general')

    local profileOptions = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)

    self:RegisterModuleOptions('Profiles', profileOptions, 'Profiles')
end

function DF:RegisterModuleOptions(name, optTable, displayName)
    moduleOptions[name] = optTable
    self.optFrames[name] =
        LibStub('AceConfigDialog-3.0'):AddToBlizOptions('DragonflightUI', displayName or name, 'DragonflightUI', name)
end
