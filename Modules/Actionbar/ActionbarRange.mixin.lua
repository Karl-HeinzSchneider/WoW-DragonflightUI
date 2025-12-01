local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local CreateColor = DFCreateColor

local subModuleName = 'ActionbarRange';
local SubModuleMixin = {};
addonTable.SubModuleMixins[subModuleName] = SubModuleMixin;

function SubModuleMixin:Init()
    self.ModuleRef = DF:GetModule('Actionbar')
    self:SetDefaults()
    self:SetupOptions()
end

function SubModuleMixin:SetDefaults()
    local defaults = {
        activate = true,
        -- unitframeDesaturate = true,
        hotkeyColor = CreateColor(LIGHTGRAY_FONT_COLOR:GetRGB()):GenerateHexColorNoAlpha(),
        hotkeyColorOutOfRange = CreateColor(RED_FONT_COLOR:GetRGB()):GenerateHexColorNoAlpha(),
        -- not usable
        notUsableColor = CreateColor(0.4, 0.4, 0.4):GenerateHexColorNoAlpha(),
        notUsableDesaturate = false,
        -- out of range
        oorColor = CreateColor(1.0, 0.5, 0.5):GenerateHexColorNoAlpha(),
        oorDesaturate = true,
        -- out of mana
        oomColor = CreateColor(0.5, 0.5, 1.0):GenerateHexColorNoAlpha(),
        oomDesaturate = false
    };
    self.Defaults = defaults;
end

function SubModuleMixin:SetupOptions()
    local Module = self.ModuleRef;
    local function getDefaultStr(key, sub, extra)
        -- return Module:GetDefaultStr(key, sub)
        local value = self.Defaults[key]
        local defaultFormat = L["SettingsDefaultStringFormat"]
        return string.format(defaultFormat, (extra or '') .. tostring(value))
    end

    local function setDefaultValues()
        Module:SetDefaultValues()
    end

    local function setDefaultSubValues(sub)
        Module:SetDefaultSubValues(sub)
    end

    local function getOption(info)
        return Module:GetOption(info)
    end

    local function setOption(info, value)
        Module:SetOption(info, value)
    end

    local function setPreset(T, preset, sub)
        for k, v in pairs(preset) do
            --
            T[k] = v;
        end
        Module:ApplySettings(sub)
        Module:RefreshOptionScreens()
    end

    local options = {
        name = L["ActionbarRangeName"],
        desc = L["ActionbarRangeNameDesc"],
        -- advancedName = 'VehicleLeave',
        sub = 'actionbarRange',
        get = getOption,
        set = setOption,
        type = 'group',
        args = {
            activate = {
                type = 'toggle',
                name = L["ButtonTableActive"],
                desc = L["ButtonTableActiveDesc"] .. getDefaultStr('activate', 'actionbarRange'),
                order = -1,
                new = false
            },
            -- headerRange = {
            --     type = 'header',
            --     name = L["ActionbarRangeHeader"],
            --     desc = L["ActionbarRangeHeaderDesc"],
            --     order = 10,
            --     isExpanded = true
            -- },
            headerHotkey = {
                type = 'header',
                name = L["ActionbarRangeHeaderHotkey"],
                desc = L["ActionbarRangeHeaderHotkeyDesc"],
                order = 60,
                isExpanded = true
            },
            hotkeyColor = {
                type = 'color',
                name = L["ActionbarRangeHotkeyColor"],
                desc = L["ActionbarRangeHotkeyColorDesc"] .. getDefaultStr('hotkeyColor', 'actionbarRange', '#'),
                group = 'headerHotkey',
                order = 1
            },
            hotkeyColorOutOfRange = {
                type = 'color',
                name = L["ActionbarRangeHotkeyOutOfRangeColor"],
                desc = L["ActionbarRangeHotkeyOutOfRangeColorDesc"] ..
                    getDefaultStr('hotkeyColorOutOfRange', 'actionbarRange', '#'),
                group = 'headerHotkey',
                order = 2
            },
            -- not usable
            headerNotUsable = {
                type = 'header',
                name = L["ActionbarRangeHeaderNotUsable"],
                desc = L["ActionbarRangeHeaderNotUsableDesc"],
                order = 30,
                isExpanded = true
            },
            notUsableDesaturate = {
                type = 'toggle',
                name = L["DarkmodeDesaturate"],
                desc = '' .. getDefaultStr('notUsableDesaturate', 'actionbarRange'),
                group = 'headerNotUsable',
                order = 1,
                new = false
            },
            notUsableColor = {
                type = 'color',
                name = L["DarkmodeColor"],
                desc = '' .. getDefaultStr('notUsableColor', 'actionbarRange', '#'),
                group = 'headerNotUsable',
                order = 2
            },
            -- oor
            headerOutOfRange = {
                type = 'header',
                name = L["ActionbarRangeHeaderOutOfRange"],
                desc = L["ActionbarRangeHeaderOutOfRangeDesc"],
                order = 40,
                isExpanded = true
            },
            oorDesaturate = {
                type = 'toggle',
                name = L["DarkmodeDesaturate"],
                desc = '' .. getDefaultStr('oorDesaturate', 'actionbarRange'),
                group = 'headerOutOfRange',
                order = 1,
                new = false
            },
            oorColor = {
                type = 'color',
                name = L["DarkmodeColor"],
                desc = '' .. getDefaultStr('oorColor', 'actionbarRange', '#'),
                group = 'headerOutOfRange',
                order = 2
            },
            -- oom
            headerOutOfMana = {
                type = 'header',
                name = L["ActionbarRangeHeaderOutOfMana"],
                desc = L["ActionbarRangeHeaderOutOfManaDesc"],
                order = 50,
                isExpanded = true
            },
            oomDesaturate = {
                type = 'toggle',
                name = L["DarkmodeDesaturate"],
                desc = '' .. getDefaultStr('oomDesaturate', 'actionbarRange'),
                group = 'headerOutOfMana',
                order = 1,
                new = false
            },
            oomColor = {
                type = 'color',
                name = L["DarkmodeColor"],
                desc = '' .. getDefaultStr('oomColor', 'actionbarRange', '#'),
                group = 'headerOutOfMana',
                order = 2
            }
        }
    }

    self.Options = options;
end

function SubModuleMixin:Setup()
    local function setDefaultSubValues(sub)
        self.ModuleRef:SetDefaultSubValues(sub)
    end

    DF.ConfigModule:RegisterSettingsData('actionbarRange', 'actionbar', {
        options = self.Options,
        default = function()
            setDefaultSubValues(self.Options.sub)
        end
    })

    --

    self.activate = false;
    -- local db = self.ModuleRef.db.profile.actionbarRange;

    -- TOOLTIP_UPDATE_TIME , = 0.2  update frequency
    -- ActionButton_UpdateRangeIndicator

    hooksecurefunc('ActionButton_UpdateRangeIndicator', function(btn, checksRange, inRange)
        if not self.activate then return end
        if not btn.HotKey then return end

        -- if btn ~= _G['ActionButton9'] then return end
        -- print('ActionButton_UpdateRangeIndicator', btn:GetName())

        if (checksRange and not inRange) then
            btn.HotKey:SetVertexColor(self.hotkeyColorOutOfRange:GetRGB());
        else
            btn.HotKey:SetVertexColor(self.hotkeyColor:GetRGB());
        end

        if btn.checksRange ~= checksRange or btn.inRange ~= inRange then
            -- something changed ~> also update icons etc
            btn.checksRange = checksRange;
            btn.inRange = inRange;
            self:UpdateRangeAndUsable(btn, checksRange, inRange);
        end
    end)

    -- ActionButton_UpdateUsable
    if DF.API.Version.IsTBC then
    else
        hooksecurefunc('ActionButton_UpdateUsable', function(btn)
            -- print('ActionButton_UpdateUsable', btn:GetName() or '')
            if not self.activate then return end
            self:UpdateRangeAndUsable(btn, btn.checksRange or false, btn.inRange or false);
        end)
    end
end

function SubModuleMixin:OnEvent(event, ...)
    -- print('event', event, ...)
end

function SubModuleMixin:UpdateState(state)
    self.state = state;
    self:Update();
end

function SubModuleMixin:Update()
    local state = self.state;
    if not state then return end

    self.activate = state.activate;

    self.hotkeyColor = CreateColorFromRGBHexString(state.hotkeyColor)
    self.hotkeyColorOutOfRange = CreateColorFromRGBHexString(state.hotkeyColorOutOfRange)

    self.notUsableColor = CreateColorFromRGBHexString(state.notUsableColor)
    self.oorColor = CreateColorFromRGBHexString(state.oorColor)
    self.oomColor = CreateColorFromRGBHexString(state.oomColor)
end

local function CustomIsUsableAction(action)
    local actionType, id = GetActionInfo(action)

    if actionType == 'macro' then
        -- print('macro!')
        -- local name, icon, body = GetMacroInfo(id)
        local name, _, _ = GetMacroInfo(id)

        if name and name:sub(1, 1) == '#' then
            local spellID = GetMacroSpell(id);

            if spellID then
                local costs = C_Spell.GetSpellPowerCost(spellID)

                if costs then
                    for i = 1, #costs do
                        --
                        local cost = costs[i]
                        if UnitPower('player', cost.type) < cost.minCost then
                            --
                            return false, true;
                        end
                    end
                end
            end
        end
    end

    -- isUsable, notEnoughMana = IsUsableAction(slot)
    return IsUsableAction(action);
end

function SubModuleMixin:UpdateRangeAndUsable(btn, checksRange, inRange)
    if btn.ignoreRange then return end
    local icon = btn.Icon
    if not icon then return end
    local state = self.state;

    local isUsable, notEnoughMana = CustomIsUsableAction(btn.action);
    -- print('UpdateRangeAndUsable', btn:GetName(), checksRange, inRange)  
    -- print('~>', isUsable, notEnoughMana)

    if isUsable then
        -- sufficient mana, reagents and not on cooldown
        if checksRange and not inRange then
            icon:SetVertexColor(self.oorColor:GetRGBA())
            icon:SetDesaturated(state.oorDesaturate)
        else
            icon:SetVertexColor(1.0, 1.0, 1.0, 1.0) -- default
            icon:SetDesaturated(false) -- default
        end
    else
        -- not useable
        if notEnoughMana then
            icon:SetVertexColor(self.oomColor:GetRGBA())
            icon:SetDesaturated(state.oomDesaturate)
        else
            icon:SetVertexColor(self.notUsableColor:GetRGBA())
            icon:SetDesaturated(state.notUsableDesaturate)
        end
    end
end
