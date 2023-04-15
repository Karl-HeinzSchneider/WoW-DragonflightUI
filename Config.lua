local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

local moduleOptions = {}
local options = {
    type = 'group',
    args = {
        general = {
            type = 'group',
            inline = true,
            name = 'General Options',
            args = {
                unlock = {
                    type = 'execute',
                    name = 'Do Nothing',
                    desc = 'Does nothing',
                    func = function()
                        DF:Print('Dont press me, i do nothing!')
                    end,
                    order = 69
                }
            }
        }
    }
}
function DF:SetupOptions()
    self:Print('SetupOptions()')
    self.optFrames = {}
    LibStub('AceConfigRegistry-3.0'):RegisterOptionsTable('DragonflightUI', options)
    self.optFrames['DragonflightUI'] =
        LibStub('AceConfigDialog-3.0'):AddToBlizOptions('DragonflightUI', 'DragonflightUI', nil, 'general')
end

function DF:RegisterModuleOptions(name, options)
    self:Print('RegisterModuleOptions()', name, options)

    moduleOptions[name] = options
    -- function AceConfigDialog:AddToBlizOptions(appName, name, parent, ...)
    self.optFrames[name] =
        LibStub('AceConfigDialog-3.0'):AddToBlizOptions('DragonflightUI', name, 'Dragonflight UI', name)
end
