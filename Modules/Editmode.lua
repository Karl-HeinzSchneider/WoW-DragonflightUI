local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Editmode'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)
Mixin(Module, CallbackRegistryMixin)

local defaults = {
    profile = {
        scale = 1,
        general = {showGrid = true, gridSize = 20, snapGrid = true, snapElements = true},
        advanced = {
            -- actionbar
            ActionBars = true,
            StanceBar = true,
            PossessBar = true,
            PetBar = true,
            TotemBar = true,
            Bags = true,
            MicroMenu = true,
            FPS = true,
            XPBar = true,
            RepBar = true,
            ExtraActionButton = true,
            FlyoutBar = true,
            -- Bossframe
            BossFrames = true,
            -- buffs,
            Buffs = true,
            Debuffs = true,
            -- castbar
            Castbars = true,
            -- minimap
            Minimap = true,
            Tracker = true,
            Durability = true,
            LFG = true,
            -- tooltip
            GameTooltip = true,
            -- UI
            -- unitframes
            PlayerFrame = true,
            Player_PowerBarAlt = true,
            PetFrame = true,
            TargetFrame = true,
            TargetOfTargetFrame = true,
            FocusFrame = true,
            FocusTargetFrame = true,
            PartyFrame = true,
            RaidFrame = true
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

local generalOptions = {
    type = 'group',
    name = 'EditMode',
    get = getOption,
    set = setOption,
    hideDefault = true,
    args = {
        showGrid = {
            type = 'toggle',
            name = 'Show Grid',
            desc = '' .. getDefaultStr('showGrid', 'general'),
            order = 100.5,
            small = true
        },
        gridSize = {
            type = 'range',
            name = 'Grid Size',
            desc = '' .. getDefaultStr('gridSize', 'general'),
            min = 8,
            max = 128,
            bigStep = 4,
            order = 101,
            small = true
        },
        snapGrid = {
            type = 'toggle',
            name = 'Snap to Grid',
            desc = '' .. getDefaultStr('snapGrid', 'general'),
            order = 102,
            small = true
        }
        -- snapElements = {
        --     type = 'toggle',
        --     name = 'Snap to Elements',
        --     desc = '*NOT YET IMPLEMENTED - COMING SOON*' .. getDefaultStr('snapElements', 'general'),
        --     order = 103,
        --     small = true
        -- }
    }
}

local advancedOptions;
if true then
    --
    advancedOptions = {
        type = 'group',
        name = 'EditMode',
        get = getOption,
        set = setOption,
        hideDefault = true,
        args = {
            headerActionbar = {
                type = 'header',
                name = 'Actionbar',
                desc = '...',
                order = 100,
                sortComparator = DFSettingsListMixin.AlphaSortComparator,
                isExpanded = true,
                editmode = true
            },
            headerCombat = {
                type = 'header',
                name = 'Combat',
                desc = '...',
                order = 200,
                sortComparator = DFSettingsListMixin.AlphaSortComparator,
                isExpanded = true,
                editmode = true
            },
            headerFrames = {
                type = 'header',
                name = 'Frames',
                desc = '...',
                order = 300,
                sortComparator = DFSettingsListMixin.AlphaSortComparator,
                isExpanded = true,
                editmode = true
            },
            headerMisc = {
                type = 'header',
                name = 'Misc',
                desc = '...',
                order = 400,
                sortComparator = DFSettingsListMixin.AlphaSortComparator,
                isExpanded = true,
                editmode = true
            }
        }
    }

    local function AddTableToCategory(t, header)
        for k, v in ipairs(t) do
            --
            advancedOptions.args[v] = {
                type = 'toggle',
                name = v,
                desc = '' .. getDefaultStr(v, 'advanced'),
                order = k,
                small = true,
                group = header,
                editmode = true
            }
        end
    end

    -- actionbar
    local actionbarFrames = {'ActionBars', 'FlyoutBar', 'MicroMenu', 'PetBar', 'PossessBar', 'StanceBar', 'TotemBar'};
    if DF.Cata then table.insert(actionbarFrames, 'ExtraActionButton') end
    AddTableToCategory(actionbarFrames, 'headerActionbar');

    -- combat
    local combatFrames = {'Buffs', 'Debuffs', 'Castbars'};
    AddTableToCategory(combatFrames, 'headerCombat');

    -- frames
    local framesFrames = {'PlayerFrame', 'PetFrame', 'TargetFrame', 'TargetOfTargetFrame', 'PartyFrame', 'RaidFrame'}
    if DF.Wrath then
        table.insert(framesFrames, 'FocusFrame')
        table.insert(framesFrames, 'FocusTargetFrame')
    end
    AddTableToCategory(framesFrames, 'headerFrames')

    -- misc
    local miscFrames = {'Bags', 'FPS', 'LFG', 'Minimap', 'Tracker', 'Durability', 'GameTooltip'}
    if DF.Cata then table.insert(miscFrames, 'Player_PowerBarAlt') end
    AddTableToCategory(miscFrames, 'headerMisc')

    advancedOptions.set = function(...)
        -- print(...)
        setOption(...)
        Module:SetEditMode(Module.IsEditMode)
    end
end

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    -- DF:RegisterModuleOptions(mName, generalOptions)

    ---@diagnostic disable-next-line: param-type-mismatch
    CallbackRegistryMixin.OnLoad(self);
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    self:EnableAddonSpecific()

    Module:CreateGrid()
    Module:SetupMainmenuButton()

    Module:RegisterChatCommand('editmode', 'SlashCommand')

    Module:GenerateCallbackEvents({"OnEditMode", 'OnSelection'})
    self:RegisterCallback('OnEditMode', function(self, value)
        DF:Debug(self, '~> OnEditMode', value)
    end, self)
    self:RegisterCallback('OnSelection', function(self, value)
        DF:Debug(self, '~> OnSelection', value and value:GetName())
    end, self)

    Module:ApplySettings()
    Module:RegisterOptionScreens()

    -- self:SecureHook(DF, 'RefreshConfig', function()
    --     -- print('RefreshConfig', mName)
    --     Module:ApplySettings()
    --     Module:RefreshOptionScreens()
    -- end)
end

function Module:OnDisable()
end

function Module:RegisterOptionScreens()
    -- DF.ConfigModule:RegisterOptionScreen('Misc', 'Darkmode', {
    --     name = 'Darkmode',
    --     sub = 'general',
    --     options = generalOptions,
    --     default = function()
    --         setDefaultSubValues('general')
    --     end
    -- })

    Module.EditModeFrame:SetupOptions({
        name = 'EditMode',
        sub = 'general',
        options = generalOptions,
        default = function()
            setDefaultSubValues('general')
        end
    }, true)

    Module.EditModeFrame:SetupAdvancedOptions({
        name = 'EditMode',
        sub = 'advanced',
        options = advancedOptions,
        default = function()
            setDefaultSubValues('advanced')
        end
    })
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame
    local cat = 'Misc'
    configFrame:RefreshCatSub(cat, 'Darkmode')
end

function Module:ApplySettings()
    local db = Module.db.profile
    local state = db.general

    local f = Module.EditModeFrame

    if Module.IsEditMode then
        f.Grid:SetShown(state.showGrid)
        f.Grid:SetGridSpacing(state.gridSize)
    else
        f.Grid:SetShown(false)
    end
end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1, arg2, arg3)
    -- print('event', event, InCombatLockdown())
    if event == 'PLAYER_REGEN_DISABLED' then
        Module:CombatHandler(true)
    elseif event == 'PLAYER_REGEN_ENABLED' then
        Module:CombatHandler(false)
    end
end
frame:SetScript('OnEvent', frame.OnEvent)
frame:RegisterEvent('PLAYER_REGEN_DISABLED')
frame:RegisterEvent('PLAYER_REGEN_ENABLED')

function Module:CreateGrid()
    DF:Debug(self, 'CreateGrid()')
    local editModeFrame = CreateFrame('Frame', 'DragonflightUIEditModeFrame', UIParent,
                                      'DragonflightUIEditModeFrameTemplate');
    editModeFrame:SetupGrid();
    editModeFrame:SetupMouseOverChecker();
    if DF.Era or DF.Cata then editModeFrame:SetupLayoutDropdown(); end
    editModeFrame:Hide()
    -- editModeFrame.Grid:Hide()
    Module.IsEditMode = false;
    Module.EditModeFrame = editModeFrame;
    Module.SelectionFrames = {}
end

function Module:SlashCommand()
    Module:SetEditMode(not Module.IsEditMode);
end

function Module:SetupMainmenuButton()
    local configModule = DF:GetModule('Config')

    local btn = configModule.EditModeButton

    btn:SetScript('OnClick', function()
        -- 
        DF:Debug(self, 'editmode')
        Module:SetEditMode(not Module.IsEditMode)
    end)
end

function Module:CombatHandler(preCombat)
    if preCombat then
        self.WasEditMode = self.IsEditMode

        if self.IsEditMode then
            self:Print('Combat started while in edit mode - deactivating until combat is over.')
            self:SetEditMode(false)
        end
    else
        if self.WasEditMode then
            self:Print('Combat ended - restoring edit mode.')
            self:SetEditMode(true)
            self.WasEditMode = false;
        end
    end
end

function Module:SetEditMode(isEditMode)
    DF:Debug(self, 'SetEditMode', isEditMode)

    Module.IsEditMode = isEditMode;
    Module.EditModeFrame:SetShown(isEditMode)

    Module:ApplySettings()

    if isEditMode then
        if not InCombatLockdown() then
            HideUIPanel(GameMenuFrame)
            HideUIPanel(SettingsPanel)
        end
    else
    end

    self.SelectedFrame = nil;
    self:TriggerEvent(self.Event.OnEditMode, isEditMode)
end

function Module:AddEditModeToFrame(frameRef)
    if not frameRef then return end
    local f = CreateFrame('Frame', frameRef:GetName() .. '_DFEditModeSelection', frameRef,
                          'DFEditModeSystemSelectionTemplate')

    return f;
end

function Module:SelectFrame(frameRef)
    if frameRef and self.SelectedFrame == frameRef then
        -- already selected
    else
        DF:Debug(self, 'Module:SelectFrame(frameRef)', frameRef and frameRef:GetName())
        self.SelectedFrame = frameRef
        self:TriggerEvent(self.Event.OnSelection, frameRef)
    end
end

function Module:Era()
end

function Module:TBC()
end

function Module:Wrath()
end

function Module:Cata()
end

function Module:Mists()
end
