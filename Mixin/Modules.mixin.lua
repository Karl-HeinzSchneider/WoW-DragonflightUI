DragonflightUIModulesMixin = {}

function DragonflightUIModulesMixin:SetDefaults(data)
    self.defaults = data
    self.wasEnabled = false
    -- print('DEFAULTS')
    -- DevTools_Dump(data)
end

function DragonflightUIModulesMixin:GetDefaultStr(key, sub)
    -- print('default str', sub, key)
    local obj
    if sub then
        obj = self.defaults.profile[sub]
    else
        obj = self.defaults.profile
    end

    local value = obj[key]
    return '\n' .. '(Default: ' .. '|cff8080ff' .. tostring(value) .. '|r' .. ')'
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
        self:ApplySettings()
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
    else
        self.db.profile[key] = value
    end
    self:ApplySettings()
end

function DragonflightUIModulesMixin:SetWasEnabled(state)
    if state then self.wasEnabled = true end
end

function DragonflightUIModulesMixin:GetWasEnabled()
    return self.wasEnabled
end

