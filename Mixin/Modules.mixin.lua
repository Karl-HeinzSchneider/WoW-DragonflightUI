local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
---@type API
local API = DF.API;
---@type VersionAPI
local Version = API.Version;

DragonflightUIModulesMixin = {}

function DragonflightUIModulesMixin:SetDefaults(data)
    self.defaults = data
    self.wasEnabled = false
    -- print('DEFAULTS')
    -- DevTools_Dump(data)
end

function DragonflightUIModulesMixin:GetDefaultStr(key, sub, extra)
    -- print('default str', sub, key)
    local obj
    if sub then
        obj = self.defaults.profile[sub]
    else
        obj = self.defaults.profile
    end

    local value = obj[key]
    -- return '\n' .. '(Default: ' .. '|cff8080ff' .. tostring(value) .. '|r' .. ')'

    local defaultFormat = L["SettingsDefaultStringFormat"]
    return string.format(defaultFormat, (extra or '') .. tostring(value))
end

function DragonflightUIModulesMixin:SetDefaultValues()
    -- print('DragonflightUIModulesMixin:SetDefaultValues()')
    for k, v in pairs(self.defaults.profile) do
        if type(v) == 'table' then
            local obj = self.db.profile[k]
            for kSub, vSub in pairs(v) do obj[kSub] = vSub end
        else
            self.db.profile[k] = v
        end
    end
    self:ApplySettings()
end

function DragonflightUIModulesMixin:SetDefaultSubValues(sub)
    -- print('DragonflightUIModulesMixin:SetDefaultSubValues(sub)', sub)
    local db = self.db.profile

    if db[sub] then
        for k, v in pairs(self.defaults.profile[sub]) do db[sub][k] = v end
        self:ApplySettings(sub)
    end
end

function DragonflightUIModulesMixin:GetOption(info)
    local key = info[1]
    local sub = info[2]
    -- print('getOption', key, sub)
    -- print('db', db[key])

    if sub then
        local t = self.db.profile[key]
        return t[sub]
    else
        -- return db[info[#info]]
        return self.db.profile[key]
    end
end

function DragonflightUIModulesMixin:SetOption(info, value)
    local key = info[1]
    local sub = info[2]
    -- print('setOption', key, sub)

    if sub then
        local t = self.db.profile[key]
        t[sub] = value
        self:ApplySettings(key)
    else
        self.db.profile[key] = value
        self:ApplySettings()
    end
end

function DragonflightUIModulesMixin:SetWasEnabled(state)
    if state then self.wasEnabled = true end
end

function DragonflightUIModulesMixin:GetWasEnabled()
    return self.wasEnabled
end

function DragonflightUIModulesMixin:ConditionalOption(cond, sub, displayName, func, message)
    local state = self.db.profile[sub]

    local shouldDo = state[cond]
    local hookName = cond .. 'Hooked'

    if shouldDo then
        if self[hookName] then
            -- already hooked - do nothing
        else
            -- needs hooking
            self[hookName] = true;
            func()
        end
    else
        if self[hookName] then
            -- already hooked, but needs deactivate
            if message then
                DF:Print(message);
                return;
            end

            local m = L["ModuleConditionalMessage"]:format(displayName)
            DF:Print(m)
        else
            -- should not and is not hooked
        end
    end
end

function DragonflightUIModulesMixin:FuncOrWaitframe(addon, func)
    if DF:IsAddOnLoaded(addon) then
        -- print('Module:FuncOrWaitframe(addon,func)', addon, 'ISLOADED')
        func()
    else
        local waitFrame = CreateFrame("FRAME")
        waitFrame:RegisterEvent("ADDON_LOADED")
        waitFrame:SetScript("OnEvent", function(self, event, arg1)
            if arg1 == addon then
                -- print('Module:FuncOrWaitframe(addon,func)', addon, 'WAITFRAME')
                func()
                waitFrame:UnregisterAllEvents()
            end
        end)
    end
end

function DragonflightUIModulesMixin:EnableAddonSpecific()
    -- print('DragonflightUIModulesMixin:EnableAddonSpecific()')
    -- DevTools_Dump(Version)

    local versionTable = {
        {'IsClassic', 'Era'}, {'IsTBC', 'TBC'}, {'IsWotlk', 'Wrath'}, {'IsCata', 'Cata'}, {'IsMoP', 'Mists'}
    }

    for k, v in ipairs(versionTable) do
        -- print(v[1], v[2])
        local versionName = v[1]
        local versionFunc = v[2]
        if Version[versionName] then
            if self[versionFunc] then
                self[versionFunc]();
            else
                DF:Debug(self, 'No self.' .. versionFunc);
            end
            return;
        end
    end
end

