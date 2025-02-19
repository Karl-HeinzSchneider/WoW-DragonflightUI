local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Tooltip'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        scale = 1,
        general = {
            scale = 1.0,
            anchorFrame = 'UIParent',
            anchor = 'BOTTOMRIGHT',
            anchorParent = 'BOTTOMRIGHT',
            x = -97,
            y = 132,
            -- gametooltip
            anchorMouse = false,
            -- spell
            anchorSpells = true,
            showSpellID = true,
            showSpellSource = true,
            showIconID = true,
            showStealable = false
        }
    }
}
Module:SetDefaults(defaults)

local function getDefaultStr(key, sub, extra)
    return Module:GetDefaultStr(key, sub, extra)
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

-- 
local GetItemInfo = (C_Item and C_Item.GetItemInfo) and C_Item.GetItemInfo or GetItemInfo
local GetItemQualityColor = (C_Item and C_Item.GetItemQualityColor) and C_Item.GetItemQualityColor or
                                GetItemQualityColor

local frameTable = {{value = 'UIParent', text = 'UIParent', tooltip = 'descr', label = 'label'}}

local function setPreset(T, preset, sub)
    -- print('setPreset')
    -- DevTools_Dump(T)
    -- print('---')
    -- DevTools_Dump(preset)

    for k, v in pairs(preset) do
        --
        T[k] = v;
    end
    Module:ApplySettings(sub)
    Module:RefreshOptionScreens()
end

local generalOptions = {
    type = 'group',
    name = 'GameTooltip',
    get = getOption,
    set = setOption,
    args = {
        headerGameTooltip = {
            type = 'header',
            name = L["TooltipHeaderGameToltip"],
            desc = L["TooltipHeaderGameToltip"],
            order = 1,
            isExpanded = true,
            editmode = true,
            sortComparator = DFSettingsListMixin.AlphaSortComparator
        },
        anchorMouse = {
            type = 'toggle',
            name = L["TooltipAnchorMouse"],
            desc = L["TooltipAnchorMouseDesc"] .. getDefaultStr('anchorMouse', 'general'),
            order = 1,
            editmode = true,
            group = 'headerGameTooltip'
        },
        headerSpellTooltip = {
            type = 'header',
            name = L["TooltipHeaderSpellTooltip"],
            desc = L["TooltipHeaderSpellTooltip"],
            order = 2,
            isExpanded = true,
            editmode = true,
            sortComparator = DFSettingsListMixin.AlphaSortComparator
        },
        anchorSpells = {
            type = 'toggle',
            name = L["TooltipAnchorSpells"],
            desc = L["TooltipAnchorSpellsDesc"] .. getDefaultStr('anchorSpells', 'general'),
            order = 1,
            editmode = true,
            group = 'headerSpellTooltip'
        },
        showSpellID = {
            type = 'toggle',
            name = L["TooltipShowSpellID"],
            desc = L["TooltipShowSpellIDDesc"] .. getDefaultStr('showSpellID', 'general'),
            order = 1,
            editmode = true,
            group = 'headerSpellTooltip'
        },
        showSpellSource = {
            type = 'toggle',
            name = L["TooltipShowSpellSource"],
            desc = L["TooltipShowSpellSourceDesc"] .. getDefaultStr('showSpellSource', 'general'),
            order = 1,
            editmode = true,
            group = 'headerSpellTooltip'
        },
        showIconID = {
            type = 'toggle',
            name = L["TooltipShowIconID"],
            desc = L["TooltipShowIconIDDesc"] .. getDefaultStr('showIconID', 'general'),
            order = 1,
            editmode = true,
            group = 'headerSpellTooltip'
        }
    }
}
DF.Settings:AddPositionTable(Module, generalOptions, 'general', 'GameTooltip', getDefaultStr, frameTable)

local optionsGeneralEditmode = {
    name = 'party',
    desc = 'party',
    get = getOption,
    set = setOption,
    type = 'group',
    args = {
        resetPosition = {
            type = 'execute',
            name = L["ExtraOptionsPreset"],
            btnName = L["ExtraOptionsResetToDefaultPosition"],
            desc = L["ExtraOptionsPresetDesc"],
            func = function()
                local dbTable = Module.db.profile.general
                local defaultsTable = defaults.profile.general
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y,
                    orientation = defaultsTable.orientation,
                    padding = defaultsTable.padding
                })
            end,
            order = 16,
            editmode = true,
            new = true
        }
    }
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)
    hooksecurefunc(DF:GetModule('Config'), 'AddConfigFrame', function()
        Module:RegisterSettings()
    end)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    DF:RegisterModuleOptions(mName, generalOptions)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    if DF.Cata then
        Module.Cata()
    elseif DF.Wrath then
        Module.Wrath()
    else
        Module.Era()
    end

    Module:AddEditMode()

    Module:ApplySettings()
    Module:RegisterOptionScreens()

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)
        Module:ApplySettings()
        Module:RefreshOptionScreens()
    end)
end

function Module:OnDisable()
end

function Module:RegisterSettings()
    local moduleName = 'Tooltip'
    local cat = 'misc'
    local function register(name, data)
        data.module = moduleName;
        DF.ConfigModule:RegisterSettingsElement(name, cat, data, true)
    end

    register('tooltip', {order = 0, name = 'Tooltip', descr = '...', isNew = true})
end

function Module:RegisterOptionScreens()
    DF.ConfigModule:RegisterSettingsData('tooltip', 'misc', {
        name = 'Tooltip',
        sub = 'general',
        options = generalOptions,
        sortComparator = generalOptions.sortComparator,
        default = function()
            setDefaultSubValues('general')
        end
    })
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame
    local cat = 'Misc'
    configFrame:RefreshCatSub(cat, 'Tooltip')

    Module.GametooltipPreview.DFEditModeSelection:RefreshOptionScreen();
end

function Module:ApplySettings(sub)
    local db = Module.db.profile
    local state = db.general

    local parent = _G[state.anchorFrame]

    Module.GametooltipPreview:ClearAllPoints()
    Module.GametooltipPreview:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    Module.GametooltipPreview:SetScale(state.scale)
end

function Module:AddEditMode()
    local EditModeModule = DF:GetModule('Editmode');

    local f = CreateFrame('FRAME', 'DragonflightUIGameTooltipPreviewFrame', UIParent)
    f:SetSize(250, 90)

    Module.GametooltipPreview = f;

    EditModeModule:AddEditModeToFrame(f)

    f.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'GameTooltip'
    end)

    f.DFEditModeSelection:RegisterOptions({
        name = 'GameTooltip',
        sub = 'general',
        advancedName = 'GameTooltip',
        options = generalOptions,
        extra = optionsGeneralEditmode,
        -- parentExtra = TargetFrame,
        default = function()
            setDefaultSubValues('general')
        end,
        moduleRef = self
        -- showFunction = function()
        --     --
        --     -- TargetFrame.unit = 'player';
        --     -- TargetFrame_Update(TargetFrame);
        --     -- TargetFrame:Show()
        --     TargetFrame:SetAlpha(0)
        -- end,
        -- hideFunction = function()
        --     --        
        --     -- TargetFrame.unit = 'target';
        --     -- TargetFrame_Update(TargetFrame);
        --     TargetFrame:SetAlpha(1)
        -- end
    });
end

function Module:HookDefaultAnchor()
    hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self, parent)
        --
        -- DF:Debug(Module, 'GameTooltip_SetDefaultAnchor', self:GetName(), parent:GetName())

        local state = Module.db.profile.general;

        -- spells
        if state.anchorSpells then
            local parentparent = parent and parent:GetParent();

            if (parent.action or parent.spellId) or (parentparent and parentparent.action) or
                (parentparent and parentparent.spellId) then
                self:SetOwner(parent, 'ANCHOR_RIGHT');
                return;
            end
        end

        --
        if state.anchorMouse then
            --
            local focused;
            if GetMouseFoci then
                local foci = GetMouseFoci()
                focused = foci[1]
            else
                focused = GetMouseFocus()
            end

            if focused == WorldFrame then
                -- units etc
                self:ClearAllPoints();
                self:SetOwner(parent, 'ANCHOR_CURSOR_RIGHT', 24, 5); -- TODO config           
                return;
            end
        end

        -- default
        self:SetOwner(parent, 'ANCHOR_NONE');
        self:ClearAllPoints();
        self:SetPoint('BOTTOMRIGHT', Module.GametooltipPreview, 'BOTTOMRIGHT', 0, 0);
    end)
end

function Module:AddBackdrops()
    local state = Module.db.profile.general

    local tooltips = {
        GameTooltip, WorldMapTooltip, ShoppingTooltip1, ShoppingTooltip2, ItemRefTooltip, ItemRefShoppingTooltip1,
        ItemRefShoppingTooltip2, FriendsTooltip
    }

    -- TODO config
    local backdrop = {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 14,
        insets = {left = 2, right = 2, top = 2, bottom = 2}
    }

    for k, v in ipairs(tooltips) do
        v:SetScale(state.scale)

        if not v.SetBackdrop then
            -- 
            -- print(v:GetName(), 'no Setbackdrop')
            Mixin(v, BackdropTemplateMixin)
        end
        v:SetBackdrop(backdrop)

        v:HookScript('OnShow', function(self)
            --
            self:SetBackdropColor(0, 0, 0, 0.2) -- TODO config
            self:SetBackdropBorderColor(0.7, 0.7, 0.7) -- TODO config

            if self.GetItem then
                --
                Module:SetItemQuality(self)
            end
        end)
    end
end

function Module:HookSpellTooltip()
    local sourceColor = "|cffffc000%s|r"
    local whiteColor = "|cffffffff%s|r"

    GameTooltip:HookScript('OnTooltipSetSpell', function(self)
        --
        -- print('OnTooltipSetSpell', tip:GetName())
        local state = Module.db.profile.general;

        local spellName, spellId = self:GetSpell();

        if not spellId then return end

        local strTable = {}

        if state.showSpellID then
            local spellIDLine = string.format(whiteColor, "Spell ID: ") .. string.format(sourceColor, spellId);
            table.insert(strTable, spellIDLine);
        end

        -- if state.showSpellSource and source then
        --     local localizedClass, englishClass, classIndex = UnitClass(source);
        --     local nameString = DF:GetClassColoredText(UnitName(source), englishClass);

        --     local sourceStr = string.format(whiteColor, "Source: ") .. nameString;
        --     table.insert(strTable, sourceStr);
        -- end

        if state.showIconID then
            local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(spellId)
            local iconStr = string.format(whiteColor, "Icon ID: ") .. string.format(sourceColor, icon);
            table.insert(strTable, iconStr);
        end

        local numStrings = #strTable
        if numStrings == 0 then return end

        self:AddLine(" ")

        for i = 1, numStrings, 2 do
            -- 
            -- print('..', i, ' / ', numStrings)

            if strTable[i + 1] then
                self:AddLine(strTable[i] .. string.format(whiteColor, ', ') .. strTable[i + 1])
            else
                self:AddLine(strTable[i])
            end
        end
        self:Show()
    end)

    local function attachSpellTooltip(self, unit, slotNumber, auraType)
        --
        -- print('~attachSpellTooltip~', self:GetName(), unit, slotNumber, auraType)
        -- local name = select(1, UnitAura(unit, slotNumber, auraType))
        -- local id = select(10, UnitAura(unit, slotNumber, auraType))
        local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
              spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitAura(unit, slotNumber,
                                                                                                      auraType)
        if not name or not spellId then return end
        -- print('~~', name, spellId)

        local state = Module.db.profile.general;

        local strTable = {}

        if state.showSpellID then
            local spellIDLine = string.format(whiteColor, "Spell ID: ") .. string.format(sourceColor, spellId);
            table.insert(strTable, spellIDLine);
        end

        if state.showSpellSource and source then
            local localizedClass, englishClass, classIndex = UnitClass(source);
            local nameString = DF:GetClassColoredText(UnitName(source), englishClass);

            local sourceStr = string.format(whiteColor, "Source: ") .. nameString;
            table.insert(strTable, sourceStr);
        end

        if state.showIconID and icon then
            local iconStr = string.format(whiteColor, "Icon ID: ") .. string.format(sourceColor, icon);
            table.insert(strTable, iconStr);
        end

        if state.showStealable then
            local stealStr = string.format(whiteColor, "Stealable: ") ..
                                 string.format(sourceColor, tostring(isStealable));
            table.insert(strTable, stealStr);
        end

        local numStrings = #strTable
        if numStrings == 0 then return end

        self:AddLine(" ")

        for i = 1, numStrings, 2 do
            -- 
            -- print('..', i, ' / ', numStrings)

            if strTable[i + 1] then
                self:AddLine(strTable[i] .. string.format(whiteColor, ', ') .. strTable[i + 1])
            else
                self:AddLine(strTable[i])
            end
        end
        self:Show()
    end

    hooksecurefunc(GameTooltip, 'SetUnitAura', function(self, unit, slotNumber, auraType)
        attachSpellTooltip(self, unit, slotNumber, auraType)
    end)
    hooksecurefunc(GameTooltip, "SetUnitBuff", function(self, unit, slotNumber)
        attachSpellTooltip(self, unit, slotNumber, "HELPFUL")
    end)
    hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self, unit, slotNumber)
        attachSpellTooltip(self, unit, slotNumber, "HARMFUL")
    end)
end

function Module:SetItemQuality(tip)
    -- print('SetItemQuality', tip:GetName())
    local name, link = tip:GetItem();

    if not link then return end
    -- local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc,
    --       itemTexture, sellPrice, classID, subclassID, bindType, expansionID, setID, isCraftingReagent = GetItemInfo(
    --                                                                                                          link)
    local itemName, itemLink, itemQuality = GetItemInfo(link);

    if not itemQuality then return end

    local r, g, b = GetItemQualityColor(itemQuality);

    if true then
        -- TODO config
        tip:SetBackdropBorderColor(r, g, b);
    end

    if false then
        -- TODO config
        tip:SetBackdropColor(r, g, b, 0.2);
    end
end

function Module:HookItemRefTooltip()
    -- item from chat etc
    ItemRefTooltip:HookScript('OnTooltipSetItem', function(self)
        --
        -- print('OnTooltipSetItem'  
        Module:SetItemQuality(self)
    end)
    ItemRefTooltip:HookScript('OnTooltipCleared', function(self)
        --
        -- print('OnTooltipCleared')   
        self:SetBackdropColor(0, 0, 0, 0.2) -- TODO config
        self:SetBackdropBorderColor(0.7, 0.7, 0.7) -- TODO config
    end)
end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1, arg2, arg3)
    -- print('event', event) 
    if event == 'MINIMAP_PING' then
    elseif event == 'MINIMAP_UPDATE_TRACKING' then
    end
end
frame:SetScript('OnEvent', frame.OnEvent)

-- Cata
function Module.Cata()
    Module.Era()
end

-- Wrath
function Module.Wrath()
    Module.Era()
end

-- Era
function Module.Era()
    Module:HookDefaultAnchor()
    Module:AddBackdrops()

    Module:HookSpellTooltip()
    Module:HookItemRefTooltip()
end
