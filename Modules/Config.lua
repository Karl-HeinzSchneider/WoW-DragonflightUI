local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Config'
local Module = DF:NewModule(mName, 'AceConsole-3.0')

local db, getOptions

local defaults = {profile = {scale = 1, dX = 42, dY = 35, sizeX = 460, sizeY = 207}}

local options = {
    type = 'group',
    name = 'DragonflightUI - ' .. mName,
    args = {
        toggle = {
            type = 'toggle',
            name = 'Enable',
            get = function()
                return DF:GetModuleEnabled(mName)
            end,
            set = function(info, v)
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
            order = 69
        }
    }
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)

    -- self:SetEnabledState(DF:GetModuleEnabled(mName))
    self:SetEnabledState(true)

    DF.ConfigModule = self
    -- DF:RegisterModuleOptions(mName, options)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    if DF.Wrath then
        Module:Wrath()
    else
        Module:Era()
    end
end

function Module:OnDisable()
end

function Module:ApplySettings()
    local db = self.db.profile
end

function Module:AddMainMenuButton()
    hooksecurefunc('GameMenuFrame_UpdateVisibleButtons', function(self)
        -- print('GameMenuFrame_UpdateVisibleButtons')
        local blizzHeight = self:GetHeight()

        self:SetHeight(blizzHeight + 22)
    end)

    local btn = CreateFrame('Button', 'DragonflightUIMainMenuButton', GameMenuFrame, 'UIPanelButtonTemplate')
    btn:SetSize(145, 21)
    btn:SetText('DragonflightUI')
    btn:SetPoint('TOP', GameMenuButtonStore, 'BOTTOM', 0, -16)

    -- GameMenuButtonOptions:SetPoint('TOP', GameMenuButtonStore, 'BOTTOM', 0, -16 - 22)
    GameMenuButtonOptions:SetPoint('TOP', btn, 'BOTTOM', 0, -1)

    btn:SetScript('OnClick', function()
        Module.ToggleConfigFrame()
        HideUIPanel(GameMenuFrame)
    end)
end

function Module:AddConfigFrame()
    local config = CreateFrame('Frame', 'DragonflightUIConfigFrame', UIParent, 'DragonflightUIConfigFrameTemplate')
    Module.ConfigFrame = config
    -- config:Show()

    _G['DragonflightUIConfigFrame'] = config
    tinsert(UISpecialFrames, 'DragonflightUIConfigFrame')

    Module:RegisterChatCommand('dragonflight', 'SlashCommand')
    Module:RegisterChatCommand('df', 'SlashCommand')

    Module:AddTestConfig()
end

function Module:AddTestConfig()
    local options = {
        name = 'WhatsNew',
        get = function(info)
            return false
        end,
        args = {
            configSize = {type = 'header', name = 'Size', order = 1},
            tog = {type = 'toggle', name = 'toggle me', order = 42},
            selectTest = {
                type = 'select',
                name = 'selectTest',
                desc = 'testing',
                values = {
                    ['TOP'] = 'TOP',
                    ['RIGHT'] = 'RIGHT',
                    ['BOTTOM'] = 'BOTTOM',
                    ['LEFT'] = 'LEFT',
                    ['TOPRIGHT'] = 'TOPRIGHT',
                    ['TOPLEFT'] = 'TOPLEFT',
                    ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                    ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                    ['CENTER'] = 'CENTER'
                },
                order = 69
            },
            steptog = {type = 'toggle', name = 'toggle me steptoggler', order = 666}
        }
    }
    local config = {name = 'WhatsNew', options = options}
    Module:RegisterOptionScreen('General', 'WhatsNew', config)
end

function Module:ToggleConfigFrame()
    local configFrame = Module.ConfigFrame

    if configFrame:IsShown() then
        configFrame:Hide()
    else
        configFrame:Show()

        HideUIPanel(GameMenuFrame)
        HideUIPanel(SettingsPanel)
    end
end

function Module:SlashCommand()
    Module:ToggleConfigFrame()
end

function Module:RegisterOptionScreen(cat, sub, data)
    print('RegisterOptionScreen', cat, sub)
    local config = Module.ConfigFrame
    local subCategory = config:GetSubCategory(cat, sub)

    if subCategory then
        subCategory:SetDisplayData(data)
        subCategory:SetEnabled(true)
    end
end

local frame = CreateFrame('FRAME', 'DragonflightUIConfigFrame', UIParent)

function frame:OnEvent(event, arg1)
    -- print('event', event)
    if event == 'PLAYER_ENTERING_WORLD' then end
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module:Wrath()
    Module:AddConfigFrame()
    Module:AddMainMenuButton()

    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
end

function Module:Era()
    Module:Wrath()
end
