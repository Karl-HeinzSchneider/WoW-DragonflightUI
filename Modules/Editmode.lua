local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Editmode'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)
Mixin(Module, CallbackRegistryMixin)

local defaults = {
    profile = {scale = 1, general = {showGrid = true, gridSize = 20, snapGrid = true, snapElements = true}}
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
            bigStep = 1,
            order = 101,
            small = true
        },
        snapGrid = {
            type = 'toggle',
            name = 'Snap to Grid',
            desc = '' .. getDefaultStr('snapGrid', 'general'),
            order = 102,
            small = true
        },
        snapElements = {
            type = 'toggle',
            name = 'Snap to Elements',
            desc = '' .. getDefaultStr('snapElements', 'general'),
            order = 103,
            small = true
        }
    }
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    -- DF:RegisterModuleOptions(mName, generalOptions)

    CallbackRegistryMixin.OnLoad(self);
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

    Module:CreateGrid()
    Module:SetupMainmenuButton()

    Module:RegisterChatCommand('editmode', 'SlashCommand')

    Module:GenerateCallbackEvents({"OnEditMode", 'OnSelection'})
    self:RegisterCallback('OnEditMode', function(self, value)
        print('~> OnEditMode', value)
    end, self)
    self:RegisterCallback('OnSelection', function(self, value)
        print('~> OnSelection', value and value:GetName())
    end, self)

    Module:AddEditModeToFrame(PlayerFrame)

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
    -- print('event', event)   
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module:CreateGrid()
    print('CreateGrid()')
    local editModeFrame = CreateFrame('Frame', 'DragonflightUIEditModeFrame', UIParent,
                                      'DragonflightUIEditModeFrameTemplate');
    editModeFrame:Hide()
    -- editModeFrame.Grid:Hide()
    Module.IsEditMode = false;
    Module.EditModeFrame = editModeFrame;
end

function Module:SlashCommand()
    Module:SetEditMode(not Module.IsEditMode);
end

function Module:SetupMainmenuButton()
    local configModule = DF:GetModule('Config')

    local btn = configModule.EditModeButton

    btn:SetScript('OnClick', function()
        -- 
        print('editmode')
        Module:SetEditMode(not Module.IsEditMode)
    end)
end

function Module:SetEditMode(isEditMode)
    print('SetEditMode', isEditMode)

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
    local f = CreateFrame('Frame', frameRef:GetName() .. '_DFEditModeSelection', frameRef,
                          'DFEditModeSystemSelectionTemplate')

    return f;
end

function Module:SelectFrame(frameRef)
    if frameRef and self.SelectedFrame == frameRef then
        -- already selected
    else
        print('Module:SelectFrame(frameRef)', frameRef and frameRef:GetName())
        self.SelectedFrame = frameRef
        self:TriggerEvent(self.Event.OnSelection, frameRef)
    end
end

-- Cata
function Module.Cata()
end

-- Wrath
function Module.Wrath()
end

-- Era
function Module.Era()
end
