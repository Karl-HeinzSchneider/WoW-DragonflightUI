local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

---@type API
local API = DF.API;

--- Game version table
--- @class ModulesAPI
local Modules = {}
API.Modules = Modules

local DF_EVENT = 'DragonflightUI.%s.%s'

--- A mapping of module names to their enabled state (true = enabled)
--- @type {[string]: boolean} 
local enabledModules = {}

--- A mapping of module names to their initialization state (true = initialized)
--- @type {[string]: boolean} 
local initializedModules = {}

hooksecurefunc(DF, 'OnInitialize', function()
    -- Event 'DragonflightUI.Core.OnInitialize'
    -- arg1: DragonflightUI AceAddon table
    EventRegistry:TriggerEvent("DragonflightUI.Core.OnInitialize", DF)
    -- print('DragonflightUI.Core.OnInitialize')

    for moduleName, v in pairs(DF.modules) do
        --   
        do
            local event = DF_EVENT:format(moduleName, 'OnInitialize')
            hooksecurefunc(v, 'OnInitialize', function(self, ...)
                -- e.g. 'Chat'
                -- Event: 'DragonflightUI.Chat.OnInitialize'
                -- arg1: AceModule table
                EventRegistry:TriggerEvent(event, self);
                initializedModules[moduleName] = true;
                -- print(event);
            end)
        end
        do
            local event = DF_EVENT:format(moduleName, 'OnEnable')
            hooksecurefunc(v, 'OnEnable', function(self, ...)
                -- e.g. 'Chat'
                -- Event: 'DragonflightUI.Chat.OnEnable'
                -- arg1: AceModule table
                EventRegistry:TriggerEvent(event, self);
                enabledModules[moduleName] = true;
                -- print(event);
            end)
        end
    end
end)

hooksecurefunc(DF, 'OnEnable', function()
    -- DevTools_Dump(DF.modules)
    EventRegistry:TriggerEvent("DragonflightUI.Core.OnEnable", DF)
    -- print('DragonflightUI.Core.OnEnable')

    -- DevTools_Dump(DF.orderedModules)
    -- for moduleName, v in pairs(DF.orderedModules) do print(v.name) end
end)

--- Returns a table of all registered modules
--- @return {[string]:AceModule} T A table of modules indexed by their names
function Modules:GetModules()
    return DF.modules
end

--- Returns a table of all registered modules in their initialization order
--- @return {[integer]:AceModule} T An ordered array of module references
function Modules:GetOrderedModules()
    return DF.orderedModules
end

--- Returns an addon module by name
---@param moduleName string
---@return AceModule M Addon module
function Modules:GetModule(moduleName)
    return DF:GetModule(moduleName, true)
end

--- Returns whether a module is enabled
---@param moduleName string
---@return boolean b boolean
function Modules:IsModuleEnabled(moduleName)
    return enabledModules[moduleName] or false;
end

--- Returns whether a module is initialized
---@param moduleName string
---@return boolean b boolean
function Modules:IsModuleInitialized(moduleName)
    return initializedModules[moduleName] or false;
end

--- Hook into Module:OnInitialize()
--- 
--- Executes the provided function *after* OnInitialize(),
--- or *straightaway* if the module was already initialized
---  
--- Will also provide the module as argument, e.g. call `func(Module)`
---
--- Example: 
--- 
--- `DragonflightUI_API.Modules:HookInitModule('Chat', function(m) print('chat <3') end)`
---@param moduleName string
---@param func function
---@return boolean b `true` if module was initialized, `false` if the callback is waiting for event
function Modules:HookInitModule(moduleName, func)
    if Modules:IsModuleInitialized(moduleName) then
        func(Modules:GetModule(moduleName))
        return true;
    end

    local event = DF_EVENT:format(moduleName, 'OnInitialize')
    EventRegistry:RegisterCallback(event, function(ownerID, ...)
        func(...)
    end)
    return false;
end

--- Hook into Module:OnEnable()
--- 
--- Executes the provided function *after* OnEnable(),
--- or *straightaway* if the module was already enabled
--- 
--- Will also provide the module as argument, e.g. call `func(Module)`
--- 
--- Example: 
--- 
--- `DragonflightUI_API.Modules:HookEnableModule('Chat', function(m) print('chat <3') end)`
---@param moduleName string
---@param func function
---@return boolean b `true` if module was enabled, `false` if the callback is waiting for event
function Modules:HookEnableModule(moduleName, func)
    if Modules:IsModuleEnabled(moduleName) then
        func(Modules:GetModule(moduleName))
        return true;
    end

    local event = DF_EVENT:format(moduleName, 'OnEnable')
    EventRegistry:RegisterCallback(event, function(ownerID, ...)
        func(...)
    end)
    return false;
end

--- Hook into a Module function, e.g. `Module:ApplySettings()`
---  
--- Will also provide the module as argument, e.g. call `func(Module,...)`
--- 
--- Example
--- 
--- `DragonflightUI_API.Modules:HookModuleFunction('Minimap', 'UpdateMinimapState', function(m, state) print(state.scale) end)`
---@param moduleName string
---@param moduleFunctionName string
---@param func function
function Modules:HookModuleFunction(moduleName, moduleFunctionName, func)
    local m = Modules:GetModule(moduleName);

    hooksecurefunc(m, moduleFunctionName, function(...)
        func(m, ...)
    end)
end
