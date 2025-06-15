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
            customAnchorFrame = '',
            anchor = 'BOTTOMRIGHT',
            anchorParent = 'BOTTOMRIGHT',
            x = -30,
            y = 120,
            -- mouseanchor
            anchorToMouse = false,
            mouseAnchor = 'ANCHOR_CURSOR_RIGHT',
            mouseX = 16,
            mouseY = 8,
            -- backdrop
            backdropAlpha = 0.2,
            -- gametooltip

            -- statusbar
            statusbarHeight = 9,
            -- spell
            anchorSpells = true,
            showSpellID = true,
            showSpellSource = true,
            showSpellIconID = false,
            showSpellIcon = true,
            showStealable = false,
            -- item
            showItemQuality = true,
            showItemQualityBackdrop = false,
            showItemStackCount = false,
            showItemID = false,
            showItemIconID = false,
            -- unit
            unitClassBorder = true,
            unitClassBackdrop = false,
            unitHealthbar = true,
            unitHealthbarText = true,
            unitReactionBorder = true,
            unitReactionBackdrop = false,
            unitClassName = true,
            unitTitle = true,
            unitRealm = true,
            unitGuild = true,
            unitGuildRank = true,
            unitGuildRankIndex = false,
            unitGrayoutOnDeath = true,
            unitTarget = true,
            unitZone = 'onlydifferent'
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
local CreateColor = DFCreateColor;
local GetItemInfo = (C_Item and C_Item.GetItemInfo) and C_Item.GetItemInfo or GetItemInfo
local GetItemQualityColor = (C_Item and C_Item.GetItemQualityColor) and C_Item.GetItemQualityColor or
                                GetItemQualityColor

local sourceColor = "|cffffc000%s|r"
local whiteColor = "|cffffffff%s|r"

local youText = format(">>%s<<", strupper(YOU))
local afkText = "|cff909090 <AFK>"
local dndText = "|cff909090 <DND>"
local dcText = "|cff909090 <DC>"
local targetText = "|cffffffff@"

local frameTable = {{value = 'UIParent', text = 'UIParent', tooltip = 'descr', label = 'label'}}
local mouseAnchorTable = {
    {value = 'ANCHOR_CURSOR_RIGHT', text = 'Cursor Right', tooltip = 'descr', label = 'label'},
    {value = 'ANCHOR_CURSOR_LEFT', text = 'Cursor Left', tooltip = 'descr', label = 'label'}
}
local zoneTable = {
    {value = 'always', text = 'Always', tooltip = 'descr', label = 'label'},
    {value = 'never', text = 'Never', tooltip = 'descr', label = 'label'},
    {value = 'onlydifferent', text = 'Only Different Zone', tooltip = 'descr', label = 'label'}
}

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
        -- headerGameTooltip = {
        --     type = 'header',
        --     name = L["TooltipHeaderGameToltip"],
        --     desc = L["TooltipHeaderGameToltip"],
        --     order = 1,
        --     isExpanded = true,
        --     editmode = true,
        --     sortComparator = DFSettingsListMixin.AlphaSortComparator
        -- },
        headerMouseAnchor = {
            type = 'header',
            name = L["TooltipCursorAnchorHeader"],
            desc = L["TooltipCursorAnchorHeaderDesc"],
            order = 1,
            isExpanded = true,
            editmode = true,
            sortComparator = DFSettingsListMixin.OrderSortComparator
        },
        anchorToMouse = {
            type = 'toggle',
            name = L["TooltipAnchorToMouse"],
            desc = L["TooltipAnchorToMouseDesc"] .. getDefaultStr('anchorToMouse', 'general'),
            order = 1,
            editmode = true,
            group = 'headerMouseAnchor'
        },
        mouseAnchor = {
            type = 'select',
            name = L["PositionTableAnchor"],
            desc = L["PositionTableAnchorDesc"] .. getDefaultStr('mouseAnchor', 'general'),
            dropdownValues = mouseAnchorTable,
            order = 2,
            group = 'headerMouseAnchor',
            editmode = true
        },
        mouseX = {
            type = 'range',
            name = L["TooltipMouseX"],
            desc = L["TooltipMouseXDesc"] .. getDefaultStr('mouseX', 'general'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5,
            group = 'headerMouseAnchor',
            editmode = true
        },
        mouseY = {
            type = 'range',
            name = L["TooltipMouseY"],
            desc = L["TooltipMouseYDesc"] .. getDefaultStr('mouseY', 'general'),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6,
            group = 'headerMouseAnchor',
            editmode = true
        },
        -- Spelltooltip
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
        showSpellIconID = {
            type = 'toggle',
            name = L["TooltipShowIconID"],
            desc = L["TooltipShowIconIDDesc"] .. getDefaultStr('showSpellIconID', 'general'),
            order = 1,
            editmode = true,
            group = 'headerSpellTooltip'
        },
        showSpellIcon = {
            type = 'toggle',
            name = L["TooltipShowSpellIcon"],
            desc = L["TooltipShowSpellIconDesc"] .. getDefaultStr('showSpellIcon', 'general'),
            order = 1,
            editmode = true,
            group = 'headerSpellTooltip'
        },
        -- Itemtooltip
        headerItemTooltip = {
            type = 'header',
            name = L["TooltipHeaderItemTooltip"],
            desc = L["TooltipHeaderItemTooltipDesc"],
            order = 3,
            isExpanded = true,
            editmode = true,
            sortComparator = DFSettingsListMixin.AlphaSortComparator
        },
        showItemQuality = {
            type = 'toggle',
            name = L["TooltipShowItemQuality"],
            desc = L["TooltipShowItemQualityDesc"] .. getDefaultStr('showItemQuality', 'general'),
            order = 1,
            editmode = true,
            group = 'headerItemTooltip'
        },
        showItemQualityBackdrop = {
            type = 'toggle',
            name = L["TooltipShowItemQualityBackdrop"],
            desc = L["TooltipShowItemQualityBackdropDesc"] .. getDefaultStr('showItemQualityBackdrop', 'general'),
            order = 1,
            editmode = true,
            group = 'headerItemTooltip'
        },
        showItemStackCount = {
            type = 'toggle',
            name = L["TooltipShowItemStackCount"],
            desc = L["TooltipShowItemStackCountDesc"] .. getDefaultStr('showItemStackCount', 'general'),
            order = 1,
            editmode = true,
            group = 'headerItemTooltip'
        },
        showItemID = {
            type = 'toggle',
            name = L["TooltipShowItemID"],
            desc = L["TooltipShowItemIDDesc"] .. getDefaultStr('showItemID', 'general'),
            order = 1,
            editmode = true,
            group = 'headerItemTooltip'
        },
        showItemIconID = {
            type = 'toggle',
            name = L["TooltipShowIconID"],
            desc = L["TooltipShowIconIDDesc"] .. getDefaultStr('showItemIconID', 'general'),
            order = 1,
            editmode = true,
            group = 'headerItemTooltip'
        },
        -- UnitTooltip
        headerUnitTooltip = {
            type = 'header',
            name = L["TooltipUnitTooltip"],
            desc = L["TooltipUnitTooltipDesc"],
            order = 4,
            isExpanded = true,
            editmode = true,
            sortComparator = DFSettingsListMixin.AlphaSortComparator
        },
        unitClassBorder = {
            type = 'toggle',
            name = L["TooltipUnitClassBorder"],
            desc = L["TooltipUnitClassBorderDesc"] .. getDefaultStr('unitClassBorder', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitClassBackdrop = {
            type = 'toggle',
            name = L["TooltipUnitClassBackdrop"],
            desc = L["TooltipUnitClassBackdropDesc"] .. getDefaultStr('unitClassBackdrop', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitReactionBorder = {
            type = 'toggle',
            name = L["TooltipUnitReactionBorder"],
            desc = L["TooltipUnitReactionBorderDesc"] .. getDefaultStr('unitReactionBorder', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitReactionBackdrop = {
            type = 'toggle',
            name = L["TooltipUnitReactionBackdrop"],
            desc = L["TooltipUnitReactionBackdropDesc"] .. getDefaultStr('unitReactionBackdrop', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitClassName = {
            type = 'toggle',
            name = L["TooltipUnitClassName"],
            desc = L["TooltipUnitClassNameDesc"] .. getDefaultStr('unitClassName', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitTitle = {
            type = 'toggle',
            name = L["TooltipUnitTitle"],
            desc = L["TooltipUnitTitleDesc"] .. getDefaultStr('unitTitle', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitRealm = {
            type = 'toggle',
            name = L["TooltipUnitRealm"],
            desc = L["TooltipUnitRealmDesc"] .. getDefaultStr('unitRealm', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitGuild = {
            type = 'toggle',
            name = L["TooltipUnitGuild"],
            desc = L["TooltipUnitGuildDesc"] .. getDefaultStr('unitGuild', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitGuildRank = {
            type = 'toggle',
            name = L["TooltipUnitGuildRank"],
            desc = L["TooltipUnitGuildRankDesc"] .. getDefaultStr('unitGuildRank', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitGuildRankIndex = {
            type = 'toggle',
            name = L["TooltipUnitGuildRankIndex"],
            desc = L["TooltipUnitGuildRankIndexDesc"] .. getDefaultStr('unitGuildRankIndex', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitGrayoutOnDeath = {
            type = 'toggle',
            name = L["TooltipUnitGrayOutOnDeath"],
            desc = L["TooltipUnitGrayOutOnDeathDesc"] .. getDefaultStr('unitGrayoutOnDeath', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitZone = {
            type = 'select',
            name = L["TooltipUnitZone"],
            desc = L["TooltipUnitZoneDesc"] .. getDefaultStr('unitZone', 'general'),
            dropdownValues = zoneTable,
            order = 2,
            group = 'headerUnitTooltip',
            editmode = true
        },
        unitHealthbar = {
            type = 'toggle',
            name = L["TooltipUnitHealthbar"],
            desc = L["TooltipUnitHealthbarDesc"] .. getDefaultStr('unitHealthbar', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitHealthbarText = {
            type = 'toggle',
            name = L["TooltipUnitHealthbarText"],
            desc = L["TooltipUnitHealthbarTextDesc"] .. getDefaultStr('unitHealthbarText', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
        },
        unitTarget = {
            type = 'toggle',
            name = L["TooltipUnitTarget"],
            desc = L["TooltipUnitTargetDesc"] .. getDefaultStr('unitTarget', 'general'),
            order = 1,
            editmode = true,
            group = 'headerUnitTooltip'
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
            new = false
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

    self:EnableAddonSpecific()

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

    register('tooltip', {order = 0, name = 'Tooltip', descr = '...', isNew = false})
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

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

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
        return 'Tooltip Anchor'
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
        Module:GameTooltipSetDefaultAnchor(self, parent);
    end)
end

function Module:GameTooltipSetDefaultAnchor(self, parent)
    -- DF:Debug(Module, 'GameTooltipSetDefaultAnchor', self:GetName(), parent:GetName())
    local state = Module.db.profile.general;

    -- spells
    if state.anchorSpells then
        local parentparent = parent and parent:GetParent();

        if (parent.action or parent.spellId) or (parentparent and parentparent.action) or
            (parentparent and parentparent.spellId) then
            self:SetOwner(parent, 'ANCHOR_RIGHT');
            return;
        end

        local parentName = parent:GetName() or ''
        if string.match(parentName, "^PetActionButton") then
            self:SetOwner(parent, 'ANCHOR_RIGHT');
            return;
        end
        if string.match(parentName, "^StanceButton") then
            self:SetOwner(parent, 'ANCHOR_RIGHT');
            return;
        end
        -- print('ss', parent:GetName())
    end

    --
    if state.anchorToMouse then
        --
        local focused;
        if GetMouseFoci then
            local foci = GetMouseFoci()
            focused = foci[1]
        else
            focused = GetMouseFocus()
        end

        -- @TODO @HACK GetMouseFoci returns empty table on units instead of one with worldframe :(
        if focused == WorldFrame or (DF.Era and not focused) or (DF.API.Version.IsWotlk and not focused) or
            (DF.API.Version.IsMoP and not focused) then
            -- units etc
            self:ClearAllPoints();
            self:SetOwner(parent, state.mouseAnchor, state.mouseX, state.mouseY); -- TODO config           
            return;
        end
    end

    if parent and _G['DragonflightUIXPBar'] and _G['DragonflightUIXPBar'].Bar and parent ==
        _G['DragonflightUIXPBar'].Bar then
        self:SetOwner(parent, 'ANCHOR_RIGHT');
        return;
    end

    -- default
    self:SetOwner(parent, 'ANCHOR_NONE');
    self:ClearAllPoints();
    self:SetPoint('BOTTOMRIGHT', Module.GametooltipPreview, 'BOTTOMRIGHT', 0, 0);
end

function Module:AddBackdrops()
    local state = Module.db.profile.general

    local tooltips = {
        GameTooltip, WorldMapTooltip, ShoppingTooltip1, ShoppingTooltip2, ItemRefTooltip, ItemRefShoppingTooltip1,
        ItemRefShoppingTooltip2, FriendsTooltip
    }
    Module.Tooltips = tooltips

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
        Module:SetDefaultBackdrop(v)
    end
end

function Module:HookFunctions()
    for k, v in ipairs(Module.Tooltips) do
        if v:HasScript('OnTooltipSetSpell') then
            v:HookScript('OnTooltipSetSpell', function(self)
                --
                Module:SetDefaultBackdrop(self)
                Module:OnTooltipSetSpell(self)
            end)
        end
        if v:HasScript('OnTooltipSetItem') then
            v:HookScript('OnTooltipSetItem', function(self)
                --
                Module:SetDefaultBackdrop(self)
                Module:OnTooltipSetItem(self)
            end)
        end
        if v:HasScript('OnTooltipSetUnit') then
            v:HookScript('OnTooltipSetUnit', function(self)
                --
                Module:SetDefaultBackdrop(self)
                Module:OnTooltipSetUnit(self)
            end)
        end
        if v:HasScript('OnTooltipSetQuest') then
            v:HookScript('OnTooltipSetQuest', function(self)
                --
                Module:SetDefaultBackdrop(self)
                Module:OnTooltipSetQuest(self)
            end)
        end
        if v:HasScript('OnTooltipCleared') then
            v:HookScript('OnTooltipCleared', function(self)
                --
                Module:SetDefaultBackdrop(self)
                Module:OnTooltipCleared(self)
            end)
        end
    end
end

function Module:SetDefaultBackdrop(self)
    -- print('Module:SetDefaultBackdrop(self)')
    local state = Module.db.profile.general;
    self:SetBackdropColor(0, 0, 0, state.backdropAlpha) -- TODO config
    self:SetBackdropBorderColor(0.7, 0.7, 0.7) -- TODO config    
end

function Module:HookStatusBar()
    local state = Module.db.profile.general;

    GameTooltipStatusBar:SetStatusBarTexture('Interface\\TargetingFrame\\UI-StatusBar')
    -- print('h', GameTooltipStatusBar:GetHeight())
    GameTooltipStatusBar:SetHeight(state.statusbarHeight)

    local padding = 2;
    local dx = 8;
    local dy = state.statusbarHeight;

    local bar = GameTooltipStatusBar
    bar:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", dx, dy - padding)
    bar:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", -dx, dy - padding)

    -- bar.TextString = bar:CreateFontString('DragonflightUIStatusBarText', 'OVERLAY', 'NumberFontNormal')
    -- bar.TextString:SetPoint('CENTER', bar, 'CENTER', 0, 0);
    -- bar.TextString:SetFont(DAMAGE_TEXT_FONT, 11, 'OUTLINE')

    local text = bar:CreateFontString('DragonflightUIStatusBarText', 'OVERLAY', 'TextStatusBarText');
    text:SetPoint('CENTER', 0, 0);
    bar.TextString = text

    local textLeft = bar:CreateFontString('DragonflightUIStatusBarTextLeft', 'OVERLAY', 'TextStatusBarText');
    textLeft:SetPoint('LEFT', 1, 0);
    bar.LeftText = textLeft

    local textRight = bar:CreateFontString('DragonflightUIStatusBarTextRight', 'OVERLAY', 'TextStatusBarText');
    textRight:SetPoint('RIGHT', -1, 0);
    bar.RightText = textRight

    bar.capNumericDisplay = true;
    bar.lockShow = 1;

    bar:HookScript('OnShow', function(self)
        -- 
        local state = Module.db.profile.general;
        if not state.unitHealthbar then self:Hide() end
    end)

    bar:HookScript('OnValueChanged', function(self, value)
        --       
        -- print('GameTooltipStatusBar OnValueChanged')
        local state = Module.db.profile.general;

        if value <= 0 then
            -- bar.TextString:SetText('DEADS')
            -- TextStatusBar_UpdateTextString(self)
            local _, maxValue = self:GetMinMaxValues()
            bar.LeftText:SetFormattedText('|cffffcc33<%s>|r', DEAD)
            bar.RightText:SetFormattedText('|cff999999%s|r', AbbreviateLargeNumbers(maxValue))

            bar.LeftText:Show()
            bar.RightText:Show()
            bar.TextString:Hide()
        else
            -- bar.TextString:SetText(value)
            TextStatusBar_UpdateTextString(self)
        end

        if not state.unitHealthbarText then
            bar.LeftText:Hide()
            bar.RightText:Hide()
            bar.TextString:Hide()
        end
    end)

    GameTooltip:HookScript('OnShow', function(self)
        --
        -- print('GameTooltip OnShow')
        local state = Module.db.profile.general;

        if not GameTooltipStatusBar:IsShown() or not state.unitHealthbar then
            self.NineSlice:ClearAllPoints()
            self.NineSlice:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0);
            self.NineSlice:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0);

            self.BottomLeftCorner:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 0, 0)
            self.BottomRightCorner:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0)

            self.Center:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0)
            return
        end
        -- print('statusbar')

        local dyyy = dy + padding;

        self.NineSlice:ClearAllPoints()
        self.NineSlice:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0);
        self.NineSlice:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, -dyyy);

        self.BottomLeftCorner:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 0, -dyyy)
        self.BottomRightCorner:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, -dyyy)

        self.Center:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, -dyyy)
    end)

    -- if (SharedTooltip_SetBackdropStyle) then
    --     hooksecurefunc("SharedTooltip_SetBackdropStyle", function(self, style, embedded)
    --         -- print('SharedTooltip_SetBackdropStyle', self:GetName())
    --         if self.NineSlice then
    --             --
    --             -- self.NineSlice:Hide()              
    --         end
    --     end)
    -- end
end

function Module:SetExtraStringTable(self, strTable)
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

function Module:OnTooltipSetSpell(self)
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

    local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(spellId)
    if state.showSpellIcon then
        local texture = GetSpellTexture(spellId)

        local line = _G[self:GetName() .. 'TextLeft1']
        local text = line:GetText()

        line:SetFormattedText('|T%s:16:16:0:0:32:32:2:30:2:30|t %s', texture, text)
    end

    if state.showSpellIconID then
        local iconStr = string.format(whiteColor, "Icon ID: ") .. string.format(sourceColor, icon);
        table.insert(strTable, iconStr);
    end

    Module:SetExtraStringTable(self, strTable)
end

function Module:SetMacroTooltip(self, macroName)
    -- print('SetMacroTooltip', self, macroName)
    local name, icon, body = GetMacroInfo(macroName)

    self:SetText(macroName, 1.0, 1.0, 1.0);

    local line = _G[self:GetName() .. 'TextLeft1']
    local text = line:GetText()
    line:SetFormattedText('|T%s:16:16:0:0:32:32:2:30:2:30|t %s', icon, text)

    self:AddLine(body, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true);
end

function Module:CheckForRecipe(self, classID)
    if classID == LE_ITEM_CLASS_RECIPE then
        if not self.inner then
            self.inner = true
            return false
        else
            return true
        end
    else
        return false
    end
end

function Module:OnTooltipSetItem(self)
    -- print('Module:OnTooltipSetItem(self)')
    -- print('SetItemQuality', tip:GetName())
    local state = Module.db.profile.general;

    local name, link = self:GetItem();

    if not link then return end
    local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc,
          itemTexture, sellPrice, classID, subclassID, bindType, expansionID, setID, isCraftingReagent = GetItemInfo(
                                                                                                             link)

    if not itemQuality then return end

    local r, g, b = GetItemQualityColor(itemQuality);

    if state.showItemQuality then self:SetBackdropBorderColor(r, g, b); end
    if state.showItemQualityBackdrop then self:SetBackdropColor(r, g, b, state.backdropAlpha); end

    local strTable = {}

    if state.showItemID then
        local id = string.match(link, "item:(%d*)")
        -- print('id', id)
        local idLine = string.format(whiteColor, "Item ID: ") .. string.format(sourceColor, id);
        table.insert(strTable, idLine);
    end

    if state.showItemStackCount then
        if itemStackCount then
            local stackLine = string.format(whiteColor, "Stack Size: ") .. string.format(sourceColor, itemStackCount);
            table.insert(strTable, stackLine);
        end
    end

    if state.showItemIconID then
        local iconStr = string.format(whiteColor, "Icon ID: ") .. string.format(sourceColor, itemTexture);
        table.insert(strTable, iconStr);
    end

    if not Module:CheckForRecipe(self, classID) then
        Module:SetExtraStringTable(self, strTable)
    else
        -- print('~~', itemName, classID)
    end
end

function Module:OnTooltipSetUnit(self)
    -- print('Module:OnTooltipSetUnit(self)')
    local state = Module.db.profile.general;

    local name, unit = self:GetUnit()

    if not name or not unit then return end
    local guid = UnitGUID(unit) or ""
    local id = tonumber(guid:match("-(%d+)-%x+$"), 10)

    -- print(name, unit)
    -- print(guid, id)  

    if UnitIsPlayer(unit) then
        Module:UnitPlayerTooltip(self)
    else
        Module:UnitNPCTooltip(self)
    end

    if state.unitTarget then Module:AddTargetLine(self, unit, nil) end
end

function Module:UnitPlayerTooltip(self)
    local state = Module.db.profile.general;

    local name, unit = self:GetUnit()

    local localizedClass, englishClass, classIndex = UnitClass(unit);
    if not class then return end -- TODO

    local r, g, b = GameTooltip_UnitColor(unit)
    local cr, cg, cb, ca, chex = DF:GetClassColor(englishClass);

    -- self:SetBackdropColor(0, 0, 0, state.backdropAlpha) -- TODO config
    -- self:SetBackdropBorderColor(0.7, 0.7, 0.7) -- TODO config   

    if state.unitClassBorder then
        self:SetBackdropBorderColor(cr, cg, cb);
    elseif state.unitReactionBorder then
        self:SetBackdropBorderColor(r, g, b);
    end

    if state.unitClassBackdrop then
        self:SetBackdropColor(cr, cg, cb, state.backdropAlpha);
    elseif state.unitReactionBackdrop then
        self:SetBackdropColor(r, g, b, state.backdropAlpha);
    end

    local name, realm = UnitName(unit)
    if state.unitTitle then
        --
        name = UnitPVPName(unit) or name
    end

    local line = _G[self:GetName() .. 'TextLeft1']
    if realm and realm ~= '' and state.unitRealm then
        --  
        name = name .. ' (' .. realm .. ')';
    end

    if state.unitClassName then
        line:SetText(DF:GetClassColoredText(name, englishClass));
    else
        line:SetText(name);
    end

    if UnitIsAFK(unit) then
        self:AppendText(afkText);
    elseif UnitIsDND(unit) then
        self:AppendText(dndText);
    elseif not UnitIsConnected(unit) then
        self:AppendText(dcText);
    end

    Module:HideLines(self, 2, 3);
    Module:HideLine(self, "^" .. LEVEL);
    Module:HideLine(self, "^" .. FACTION_ALLIANCE);
    Module:HideLine(self, "^" .. FACTION_HORDE);
    Module:HideLine(self, "^" .. PVP);

    local guild, rank, index = GetGuildInfo(unit)
    -- print('~g', guild, rank, index)
    if guild and state.unitGuild then
        --
        local guildLine = Module:GetLine(self, 2);

        if UnitIsInMyGuild(unit) and UnitIsSameServer(unit) and UnitIsFriend(unit, 'player') then
            guildLine:SetTextColor(1.0, 0.3, 1.0)
        else
            guildLine:SetTextColor(r, g, b)
        end

        if state.unitGuildRank then
            local rankColor = "|cff909090"

            if state.unitGuildRankIndex then
                guildLine:SetFormattedText("<%s> %s%s (%d)", guild, rankColor, rank, index)
            else
                guildLine:SetFormattedText("<%s> %s%s", guild, rankColor, rank)
            end
        else
            guildLine:SetFormattedText("<%s>", guild)
        end
    end

    if guild then
        Module:AddUnitLine(self, unit, 3)
        Module:AddLocationLine(self, unit, 4)
    else
        Module:AddUnitLine(self, unit, 2)
        Module:AddLocationLine(self, unit, 3)
    end

    if state.unitGrayoutOnDeath then
        --
        Module:GrayOutOnDeath(self, unit)
    end
end

function Module:GetZone(unit)
    local uname, urealm = UnitName(unit)
    urealm = urealm or ''
    -- print('GetZone', uname, unit)
    if not IsInGroup() then return end

    local str, index = string.match(unit, "(.-)(%d+)")
    if not str or not index then return end -- not in group etc

    if not (str == 'party' or str == 'raid') then return end
    -- print('~', str, index)

    for k = 1, 40 do
        local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole =
            GetRaidRosterInfo(k)

        if name then
            if string.find(name, '-') then
                -- xrealm
                if name == (uname .. '-' .. urealm) then return zone; end
            else
                if name == uname then return zone; end
            end
        end
    end

    return;
end

function Module:AddLocationLine(self, unit, index)
    local state = Module.db.profile.general;

    -- print('AddLocationLine', unit)
    local zone = Module:GetZone(unit)

    if not zone then return end

    -- print('~~~> ', zone)

    if state.unitZone == 'always' then
        local line = Module:GetLine(self, index)
        line:SetText(zone)
        line:SetTextColor(1.0, 1.0, 1.0);
        self:Show()
    elseif state.unitZone == 'never' then
    elseif state.unitZone == 'onlydifferent' then
        if zone ~= GetRealZoneText() then
            local line = Module:GetLine(self, index)
            line:SetText(zone)
            line:SetTextColor(1.0, 1.0, 1.0);
            self:Show()
        end
    end

    -- local line = Module:GetLine(self, index)
    -- line:SetText(zone)
    -- line:SetTextColor(1.0, 0.3, 1.0)
end

function Module:UnitNPCTooltip(self)
    local state = Module.db.profile.general;

    local name, unit = self:GetUnit()

    -- print('Module:UnitNPCTooltip(self)', name, unit)
    local r, g, b = GameTooltip_UnitColor(unit)
    local level = UnitLevel(unit)

    if state.unitReactionBorder then
        --
        self:SetBackdropBorderColor(r, g, b)
    end

    if state.unitReactionBackdrop then
        --
        self:SetBackdropColor(r, g, b, state.backdropAlpha)
    end

    local levelLine = Module:FindLine(self, '^' .. LEVEL)

    if levelLine or self:NumLines() > 1 then
        --

        local titleLine;
        do
            local line, index = Module:FindLine(self, '^' .. LEVEL);
            if line and index > 2 then
                --
                titleLine = Module:GetLine(self, 2);

                local guid = UnitGUID(unit) or ""
                local id = tonumber(guid:match("-(%d+)-%x+$"), 10)
                if (id) and (guid:match("%a+") == "Pet") then
                    -- print('pets', id, guid)
                    local owner, _ = string.split("'", titleLine:GetText())
                    if UnitExists(owner) then
                        --
                        local _, englishClass, _ = UnitClass(owner);
                        if englishClass then
                            -- 
                            local coloredOwner = DF:GetClassColoredText(owner, englishClass)
                            -- print('owner:', owner, coloredOwner)

                            local text = titleLine:GetText() or '';
                            text = text:gsub(owner, coloredOwner);
                            titleLine:SetText(text)
                        end
                    end
                end
            end
        end

        if titleLine then
            Module:AddUnitLine(self, unit, 3)
        else
            Module:AddUnitLine(self, unit, 2)
        end
    end

    if state.unitGrayoutOnDeath then
        --
        Module:GrayOutOnDeath(self, unit)
    end

    -- Module:HideLines(self, 2, 3);
    Module:HideLine(self, "^" .. LEVEL);
    -- Module:HideLine(self, "^" .. FACTION_ALLIANCE);
    -- Module:HideLine(self, "^" .. FACTION_HORDE);
    Module:HideLine(self, "^" .. PVP);
end

function Module:AddUnitLine(self, unit, index)
    -- print('AddUnitLine', unit, index)
    local unitLine = Module:GetLine(self, index);
    unitLine:SetTextColor(1.0, 1.0, 1.0)

    local level = UnitLevel(unit)
    local questColor = GetQuestDifficultyColor(level)
    local levelColor = CreateColor(questColor.r, questColor.g, questColor.b)
    local levelHex = levelColor:GenerateHexColor()
    local levelString = '|c' .. levelHex .. level .. '|r'

    if level == -1 then
        --
        levelString = '|r|cffff0000??|r';
    end

    if UnitIsPlayer(unit) then
        local localizedClass, englishClass, classIndex = UnitClass(unit);

        -- print(levelString, UnitRace(unit), DF:GetClassColoredText(localizedClass, englishClass))

        unitLine:SetFormattedText("%s %s %s", levelString, UnitRace(unit),
                                  DF:GetClassColoredText(localizedClass, englishClass))
    else
        local creature = UnitCreatureFamily(unit) or UnitCreatureType(unit) or ''
        -- @TODO: localization    if 'Non-Combat Pet' => 'Pet' etc

        local class = UnitClassification(unit)
        --[[ "worldboss", "rareelite", "elite", "rare", "normal", "trivial" or "minus" ]]
        if class == 'worldboss' then
            -- e.g. ?? Boss
            unitLine:SetFormattedText("%s %s |r|cffffffff%s", levelString, 'Boss', creature)
        elseif class == 'rareelite' then
            -- e.g. 69+ Rare
            unitLine:SetFormattedText("%s%s |r|cffffffff%s", levelString, format("+ |cffff00da%s", ITEM_QUALITY3_DESC),
                                      creature)
        elseif class == 'elite' then
            -- e.g. 69+
            unitLine:SetFormattedText("%s%s |r|cffffffff%s", levelString, '+', creature)
        elseif class == 'rare' then
            -- e.g. 69 Rare
            unitLine:SetFormattedText("%s %s |r|cffffffff%s", levelString, format("|cffff00da%s", ITEM_QUALITY3_DESC),
                                      creature)
            -- elseif class == 'normal' then
            -- elseif class == 'trivial' then
            -- elseif class == 'minus' then
        else
            -- e.g. 69
            unitLine:SetFormattedText("%s |r|cffffffff%s", levelString, creature)
        end
    end

    self:Show()
end

function Module:AddTargetLine(self, unit, index)
    local tot = unit .. 'target'

    if not UnitExists(tot) then return; end

    local name, _ = UnitName(tot)
    local _, englishClass, _ = UnitClass(tot);

    local prefix = '|cffffffffT:';
    local text;
    local tt;
    local col;
    if UnitIsUnit('player', tot) then
        local r, g, b = GameTooltip_UnitColor(unit)
        col = format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
        tt = format(">>%s<<", strupper(YOU))
        text = format('%s %s%s', prefix, col, tt)
        self:AddLine(text)
    elseif UnitIsPlayer(tot) then
        text = format('%s %s', prefix, DF:GetClassColoredText(name, englishClass))
        self:AddLine(text)
    else
        local r, g, b = GameTooltip_UnitColor(tot)
        col = format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
        text = format('%s %s%s', prefix, col, name)
        self:AddLine(text)
    end
    self:Show()
end

function Module:GrayOutOnDeath(self, unit)
    if not UnitIsDeadOrGhost(unit) then return end
    local state = Module.db.profile.general;

    self:SetBackdropBorderColor(0.6, 0.6, 0.6)
    self:SetBackdropColor(0.1, 0.1, 0.1, state.backdropAlpha)

    local line, text;
    for i = 2, self:NumLines() do
        line = _G[self:GetName() .. 'TextLeft' .. i];
        text = line:GetText() or '';
        if text ~= UNIT_SKINNABLE_LEATHER then
            text = text:gsub("|cff%x%x%x%x%x%x", "|cffaaaaaa");
            line:SetTextColor(0.7, 0.7, 0.7);
            line:SetText(text)
        end
    end
end

function Module:OnTooltipSetQuest(self)
end

function Module:OnTooltipCleared(self)
end

function Module:HookSpellTooltip()
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

        if state.showSpellIcon then
            local texture = GetSpellTexture(spellId)

            local line = _G[self:GetName() .. 'TextLeft1']
            local text = line:GetText()

            line:SetFormattedText('|T%s:16:16:0:0:32:32:2:30:2:30|t %s', texture, text)
        end

        if state.showSpellIconID and icon then
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

function Module:FindLine(self, searching)
    local line, text;

    for i = 2, self:NumLines() do
        --
        line = _G[self:GetName() .. 'TextLeft' .. i];
        text = line:GetText() or '';
        if strfind(text, searching) then
            --
            return line, i;
        end
    end
end

function Module:GetLine(self, index)
    local num = self:NumLines()
    if index > self:NumLines() then
        --
        self:AddLine(' ');
        return Module:GetLine(self, num + 1)
    end
    return _G[self:GetName() .. 'TextLeft' .. index], _G[self:GetName() .. 'TextRight' .. index]

end

function Module:HideLine(self, searching)
    local line, text;

    for i = 2, self:NumLines() do
        --
        line = _G[self:GetName() .. 'TextLeft' .. i];
        text = line:GetText() or '';
        if strfind(text, searching) then
            --
            line:SetText(nil);
            return;
        end
    end
end

function Module:HideLines(self, number, numberEnd)
    numberEnd = numberEnd or 666;

    for i = number, self:NumLines() do
        --
        if i <= numberEnd then
            --
            _G[self:GetName() .. 'TextLeft' .. i]:SetText(nil)
        end
    end
end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1, arg2, arg3)
    -- print('event', event) 
    if event == 'MINIMAP_PING' then
    elseif event == 'MINIMAP_UPDATE_TRACKING' then
    end
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module:Era()
    Module:HookDefaultAnchor()
    Module:AddBackdrops()

    Module:HookFunctions()
    Module:HookSpellTooltip()
    Module:HookStatusBar()
end

function Module:TBC()
end

function Module:Wrath()
    Module:Era()
end

function Module:Cata()
    Module:Era()
end

function Module:Mists()
    Module:Era()
end
