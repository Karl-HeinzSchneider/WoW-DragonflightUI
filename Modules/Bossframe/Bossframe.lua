local addonName, addonTable = ...;
local Helper = addonTable.Helper;
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

local mName = 'Bossframe'

local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')
Module.Tmp = {}

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        scale = 1,
        boss = {
            scale = 1,
            anchorFrame = 'MinimapCluster',
            customAnchorFrame = '',
            anchor = 'TOPRIGHT',
            anchorParent = 'BOTTOMRIGHT',
            x = -210,
            y = -118,
            padding = 8,
            breakUpLargeNumbers = true,
            hideNameBackground = false,
            fadeOut = true,
            fadeOutDistance = 40,
            orientation = 'vertical'
        }
    }
}
Module:SetDefaults(defaults)

local function getDefaultStr(key, sub)
    return Module:GetDefaultStr(key, sub)
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
    print('setPreset')
    for k, v in pairs(preset) do
        --
        print(k, v)
        T[k] = v;
    end
    Module:ApplySettings(sub)
    Module:RefreshOptionScreens()
end

local options = {
    type = 'group',
    name = 'DragonflightUI - ' .. mName,
    get = getOption,
    set = setOption,
    args = {
        toggle = {
            type = 'toggle',
            name = 'Enable',
            get = function()
                ---@diagnostic disable-next-line: undefined-field
                return DF:GetModuleEnabled(mName)
            end,
            set = function(info, v)
                ---@diagnostic disable-next-line: undefined-field
                DF:SetModuleEnabled(mName, v)
            end,
            order = 1
        },
        reload = {
            type = 'execute',
            name = '/reload',
            desc = 'reloads UI',
            func = function()
                ReloadUI()
            end,
            order = 1.1
        },
        defaults = {
            type = 'execute',
            name = 'Defaults',
            desc = 'Sets Config to default values',
            func = setDefaultValues,
            order = 1.1
        },
        --[[ config = {type = 'header', name = 'Config - Player', order = 100}, ]]
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale'),
            min = 0.2,
            max = 3,
            bigStep = 0.025,
            order = 101,
            disabled = false
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to TOPRIGHT' .. getDefaultStr('x'),
            min = -2500,
            max = 2500,
            bigStep = 0.50,
            order = 102
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to TOPRIGHT' .. getDefaultStr('y'),
            min = -2500,
            max = 2500,
            bigStep = 0.50,
            order = 102
        },
        locked = {
            type = 'toggle',
            name = 'Locked',
            desc = 'Lock the Preview Frame.' .. getDefaultStr('locked'),
            order = 103
        },
        trackerHeader = {type = 'header', name = 'Questtracker', desc = '', order = 120}
    }
}

local frameTable = {
    {value = 'UIParent', text = 'UIParent', tooltip = 'descr', label = 'label'},
    {value = 'MinimapCluster', text = 'MinimapCluster', tooltip = 'descr', label = 'label'}
}

local bossOptions = {
    type = 'group',
    name = L["BossFrameName"],
    desc = L["BossFrameNameDesc"],
    advancedName = 'BossFrames',
    sub = "boss",
    get = getOption,
    set = setOption,
    args = {
        headerStyling = {
            type = 'header',
            name = L["TargetFrameStyle"],
            desc = '',
            order = 20,
            isExpanded = true,
            editmode = true
        },
        breakUpLargeNumbers = {
            type = 'toggle',
            name = L["TargetFrameBreakUpLargeNumbers"],
            desc = L["TargetFrameBreakUpLargeNumbersDesc"] .. getDefaultStr('breakUpLargeNumbers', 'boss'),
            group = 'headerStyling',
            order = 3,
            editmode = true
        },
        hideNameBackground = {
            type = 'toggle',
            name = L["TargetFrameHideNameBackground"],
            desc = L["TargetFrameHideNameBackgroundDesc"] .. getDefaultStr('hideNameBackground', 'boss'),
            group = 'headerStyling',
            order = 5,
            new = false,
            editmode = true
        },
        fadeOut = {
            type = 'toggle',
            name = L["TargetFrameFadeOut"],
            desc = L["TargetFrameFadeOutDesc"] .. getDefaultStr('fadeOut', 'boss'),
            group = 'headerStyling',
            order = 15,
            new = false,
            editmode = true
        },
        fadeOutDistance = {
            type = 'range',
            name = L["TargetFrameFadeOutDistance"],
            desc = L["TargetFrameFadeOutDistanceDesc"] .. getDefaultStr('fadeOutDistance', 'boss'),
            min = 0,
            max = 50,
            bigStep = 1,
            order = 16,
            group = 'headerStyling',
            new = false,
            editmode = true
        },
        orientation = {
            type = 'select',
            name = L["ButtonTableOrientation"],
            desc = L["ButtonTableOrientationDesc"] .. getDefaultStr('orientation', 'boss'),
            dropdownValues = DF.Settings.OrientationTable,
            order = 2,
            group = 'headerStyling',
            editmode = true
        }
    }
}
DF.Settings:AddPositionTable(Module, bossOptions, 'boss', 'Boss', getDefaultStr, frameTable)
local bossOptionsEditmode = {
    name = 'Target',
    desc = 'Targetframedesc',
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
                local dbTable = Module.db.profile.boss
                local defaultsTable = defaults.profile.boss
                -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                setPreset(dbTable, {
                    scale = defaultsTable.scale,
                    anchor = defaultsTable.anchor,
                    anchorParent = defaultsTable.anchorParent,
                    anchorFrame = defaultsTable.anchorFrame,
                    x = defaultsTable.x,
                    y = defaultsTable.y
                }, 'boss')
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

    DF:RegisterModuleOptions(mName, options)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    if not DF.Cata then return end -- guard TODO

    self:EnableAddonSpecific()

    self:AddEditMode()
    self:RegisterOptionScreens()

    self:ApplySettings()

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)
        Module:ApplySettings()
        Module:RefreshOptionScreens()
    end)
end

function Module:OnDisable()
end

function Module:RegisterSettings()
    local moduleName = 'Boss'
    local cat = 'unitframes'
    local function register(name, data)
        data.module = moduleName;
        DF.ConfigModule:RegisterSettingsElement(name, cat, data, true)
    end

    if not DF.Cata then return end
    register('boss', {order = 0, name = bossOptions.name, descr = bossOptions.desc, isNew = false})
end

function Module:RegisterOptionScreens()
    if not DF.Cata then return end
    DF.ConfigModule:RegisterSettingsData('boss', 'unitframes', {
        options = bossOptions,
        default = function()
            setDefaultSubValues('boss')
        end
    })
end

function Module:AddEditMode()
    local EditModeModule = DF:GetModule('Editmode');
    local fakeWidget = self.PreviewFrame

    EditModeModule:AddEditModeToFrame(fakeWidget)

    fakeWidget.DFEditModeSelection:SetGetLabelTextFunction(function()
        return bossOptions.name
    end)

    fakeWidget.DFEditModeSelection:RegisterOptions({
        options = bossOptions,
        extra = bossOptionsEditmode,
        default = function()
            setDefaultSubValues(bossOptions.sub)
        end,
        moduleRef = self,
        showFunction = function()
            --         
            -- fakeWidget.FakePreview:Show()
            self.PreviewParent:Show()
        end,
        hideFunction = function()
            --
            fakeWidget:Show()
            -- fakeWidget.FakePreview:Hide()
            self.PreviewParent:Hide()
        end
    });
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame

    local refreshCat = function(name)
        configFrame:RefreshCatSub('Unitframes', name)
    end

    refreshCat('Boss')

    self.PreviewFrame.DFEditModeSelection:RefreshOptionScreen();
end

function Module:ApplySettings(sub, key)
    Helper:Benchmark(string.format('ApplySettings(%s,%s)', tostring(sub), tostring(key)), function()
        Module:ApplySettingsInternal(sub, key)
    end, 0, self)
end

function Module:ApplySettingsInternal(sub, key)
    local state = Module.db.profile.boss
    if not DF.Cata then return end

    local f = self.PreviewFrame

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    -- f:SetParent(parent)
    f:SetScale(state.scale)

    f:ClearAllPoints()
    f:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

    local sizeX, sizeY = self['BossFrame1']:GetSize()

    if state.orientation == 'vertical' then
        self.PreviewFrame:SetSize(sizeX, sizeY * 4 + 3 * state.padding)
    else
        self.PreviewFrame:SetSize(sizeX * 4 + 3 * state.padding, sizeY)
    end

    for id = 1, 4 do
        local boss = Module['BossFrame' .. id]
        local fake = Module['FakeBoss' .. id]

        boss:ClearAllPoints()
        fake:ClearAllPoints()

        if id == 1 then
            boss:SetPoint('TOPLEFT', f, 'TOPLEFT', 0, 0)
            fake:SetPoint('TOPLEFT', self.PreviewParent, 'TOPLEFT', 0, 0)
        else
            if state.orientation == 'vertical' then
                boss:SetPoint('TOPLEFT', self['BossFrame' .. (id - 1)], 'BOTTOMLEFT', 0, -state.padding)
                fake:SetPoint('TOPLEFT', self['FakeBoss' .. (id - 1)], 'BOTTOMLEFT', 0, -state.padding)
            else
                boss:SetPoint('TOPLEFT', self['BossFrame' .. (id - 1)], 'TOPRIGHT', state.padding, 0)
                fake:SetPoint('TOPLEFT', self['FakeBoss' .. (id - 1)], 'TOPRIGHT', state.padding, 0)
            end
        end

        boss:UpdateState(state)
    end
end

function Module:CreateBossFrames()
    local fakeWidget = CreateFrame('Frame', 'DragonflightUIBossFramesFrame', UIParent)
    fakeWidget:SetSize(232, 100 + 3 * 70)
    self.PreviewFrame = fakeWidget

    for id = 1, 4 do
        -- print('createBossFrames', id)
        local f = Module:CreateBossFrame(id)

        Module['BossFrame' .. id] = f
    end

    local previewParent = CreateFrame("Frame", 'DragonflightUIBossFramesPreviewParent', self.PreviewFrame)
    previewParent:SetPoint('TOPLEFT', self.PreviewFrame, 'TOPLEFT', 0, 0)
    previewParent:SetPoint('BOTTOMRIGHT', self.PreviewFrame, 'BOTTOMRIGHT', 0, 0)
    self.PreviewParent = previewParent;
    self.PreviewParent:Hide()

    for id = 1, 4 do
        --
        local f = CreateFrame('Frame', self['BossFrame' .. id]:GetName() .. 'Preview', previewParent,
                              'DFEditModePreviewTargetTemplate')
        f:OnLoad()
        Module['FakeBoss' .. id] = f
        f:Show()
        local unit = DF:GetRandomBoss();
        f:SetUnit(unit)
        f.NameBackground:SetColor('red')

        local fakeTargetOfTarget = CreateFrame('Frame', self['BossFrame' .. id]:GetName() .. 'ToTPreview', f,
                                               'DFEditModePreviewTargetOfTargetTemplate')
        fakeTargetOfTarget.IsToT = true;
        fakeTargetOfTarget:OnLoad()
        fakeTargetOfTarget:Show()
        fakeTargetOfTarget:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -35 + 27, -15)
    end

    -- frame = CreateFrame(frameType [, name, parent, template, id])

    -- for id = 1, 5 do
    --     local name = 'DragonflightUIBoss' .. id .. 'Frame'
    --     print('create', name)
    --     local f = CreateFrame('Button', name, UIParent, 'BossTargetFrameTemplate', id)
    --     f:SetPoint('CENTER', UIParent, 'CENTER', 0, 80 * id)

    --     if (id == 1) then
    --         BossTargetFrame_OnLoad(f, "boss1", "INSTANCE_ENCOUNTER_ENGAGE_UNIT");
    --     else
    --         BossTargetFrame_OnLoad(f, "boss" .. id);
    --     end
    --     TargetFrame_CreateSpellbar(f, "INSTANCE_ENCOUNTER_ENGAGE_UNIT", true);
    -- end

end

function Module:HideDefault()
    for id = 1, 4 do
        local f = _G['Boss' .. id .. 'TargetFrame']
        f:SetAlpha(0)
    end
end

function Module:CreateBossFrame(id)
    local unitframeModule = DF:GetModule('Unitframe')

    local name = 'DragonflightUIBoss' .. id .. 'Frame'
    local f = CreateFrame('Button', name, UIParent, 'DragonflightUIBossframeTemplate', id)
    f:SetFrameLevel(5)
    local unit = 'boss' .. id
    -- unit = 'player'
    f:Setup(unit, id)
    unitframeModule.SubTarget:ChangeTargetFrameGeneral(f, f)
    f:AddThreatIndicator()
    -- f:AddCastbar()

    -- tot
    do
        local totName = 'DragonflightUIBoss' .. id .. 'ToTFrame'
        local tot = CreateFrame('Button', totName, UIParent, 'DragonflightUIBossframeTemplate', id)
        tot:SetFrameLevel(10)
        local totUnt = 'boss' .. id .. 'target'
        -- totUnt = 'pettarget'
        tot:Setup(totUnt, id)
        tot:ClearAllPoints()
        tot:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -35 + 27, -15)
        -- tot:SetPoint('RIGHT', f, 'LEFT', -10, 0)

        unitframeModule.SubTargetOfTarget:ChangeToTFrame(tot, tot)

        tot.PortraitExtra:Hide()
        tot.UpdatePortraitExtra = function(frameRef, u)
            -- print(u)
        end

        tot.NameBackground:SetTexture('')
        tot.LevelText:SetAlpha(0)
        tot.HighLevelTexture:SetAlpha(0)

        local function smallerFont(ff, newSize)
            local fontFile, fontHeight, flags = ff:GetFont()
            ff:SetFont(fontFile, newSize, flags)
        end

        local raidTargetIconSize = 26 - 6;
        tot.RaidTargetIcon:SetSize(raidTargetIconSize, raidTargetIconSize)

        tot.HealthBar.breakUpLargeNumbers = true
        tot.HealthBar.capNumericDisplay = true
        tot.HealthBar.showPercentage = true
        smallerFont(tot.HealthBar.HealthBarText, 14 - 3)
        TextStatusBar_UpdateTextString(tot.HealthBar)

        local deltaSize = 70 - 74
        tot.ManaBar.ManaBarText:ClearAllPoints()
        tot.ManaBar.ManaBarText:SetPoint('CENTER', tot.ManaBar, 'CENTER', -deltaSize / 2, 0)
        smallerFont(tot.ManaBar.ManaBarText, 14 - 3)

        tot.ManaBar.breakUpLargeNumbers = true
        tot.ManaBar.capNumericDisplay = true
        tot.ManaBar.showPercentage = true
        TextStatusBar_UpdateTextString(tot.ManaBar)

        tot.UpdatePowerType = function(totself, powerTypeString)
            local mana = totself.ManaBar

            if powerTypeString == 'MANA' then
                mana:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana')
            elseif powerTypeString == 'FOCUS' then
                mana:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Focus')
            elseif powerTypeString == 'RAGE' then
                mana:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Rage')
            elseif powerTypeString == 'ENERGY' or powerTypeString == 'POWER_TYPE_FEL_ENERGY' then
                mana:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Energy')
            elseif powerTypeString == 'RUNIC_POWER' then
                mana:GetStatusBarTexture():SetTexture(
                    'Interface\\Addons\\DragonflightUI\\Textures\\Unitframe\\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-RunicPower')
            end
        end
    end

    return f
end

function Module:HookBossframe()
    local b = _G.Boss1TargetFrame
    b:SetMovable(true)
    b:SetUserPlaced(true)
    b:ClearAllPoints()
    b:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -350, -470)
    b:SetMovable(false)

    local moving
    hooksecurefunc(Boss1TargetFrame, "SetPoint", function(self)
        if moving then return end
        moving = true
        self:SetMovable(true)
        self:SetUserPlaced(true)
        self:ClearAllPoints()
        self:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -350, -470)
        self:SetMovable(false)
        moving = nil
    end)
end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1)
    -- print('event', event) 
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module:Era()
end

function Module:TBC()
end

function Module:Wrath()
end

function Module:Cata()
    Module:CreateBossFrames()
    Module:HideDefault()
end

function Module:Mists()
    Module:CreateBossFrames()
    Module:HideDefault()
end
