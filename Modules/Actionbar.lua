local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Actionbar'
local Module = DF:NewModule(mName, 'AceConsole-3.0')

function Module:OnInitialize()
    -- Called when the addon is loaded
    self:Print('Module ' .. mName .. ' loaded!')
end

function Module:OnEnable()
    -- Called when the addon is enabled
    self:Print('Module ' .. mName .. ' enabled!')
end

function Module:OnDisable()
    -- Called when the addon is disabled
end
