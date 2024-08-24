local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Darkmode'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {profile = {scale = 1, general = {}}}
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
    name = 'Darkmode',
    get = getOption,
    set = setOption,
    args = {
        -- scale = {
        --     type = 'range',
        --     name = 'Scale',
        --     desc = '' .. getDefaultStr('scale', 'minimap'),
        --     min = 0.1,
        --     max = 5,
        --     bigStep = 0.1,
        --     order = 1
        -- }    
    }
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)

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

    Module.ApplySettings()
    Module:RegisterOptionScreens()

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)
        Module:ApplySettings()
        Module:RefreshOptionScreens()
    end)
end

function Module:OnDisable()
end

function Module:RegisterOptionScreens()
    DF.ConfigModule:RegisterOptionScreen('Misc', 'Darkmode', {
        name = 'Darkmode',
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

    Module:UpdateMinimap(true)
    Module:UpdateUnitframe(true)
end

function Module:UpdateMinimap(dark)
    local moduleName = 'Minimap'
    if not DF.ConfigModule:GetModuleEnabled(moduleName) then return end

    local minimapModule = DF:GetModule(moduleName)

    local minimapBorderTex = minimapModule.Frame.minimap

    if dark then
        minimapBorderTex:SetDesaturated(true)
        minimapBorderTex:SetVertexColor(0.4, 0.4, 0.4)
    else
        minimapBorderTex:SetDesaturated(false)
        minimapBorderTex:SetVertexColor(1.0, 1.0, 1.0)
    end
end

function Module:UpdateUnitframe(dark)
    local moduleName = 'Unitframe'
    if not DF.ConfigModule:GetModuleEnabled(moduleName) then return end

    local unitModule = DF:GetModule(moduleName)
    local f = unitModule.Frame

    -- player
    if not f.DarkmodePlayerStatusHooked then
        f.DarkmodePlayerStatusHooked = true
        hooksecurefunc(unitModule, 'UpdatePlayerStatus', function()
            --  
            local db = Module.db.profile.general
            local dark = true

            Module:UpdatePlayerFrame(dark)
        end)
    end
    Module:UpdatePlayerFrame(dark)

    -- target
    if not f.DarkmodeTargetHooked then
        f.DarkmodeTargetHooked = true
        hooksecurefunc(unitModule, 'ChangeToT', function()
            --  
            local db = Module.db.profile.general
            local dark = true

            Module:UpdateTargetFrame(dark)
        end)
    end
    Module:UpdateTargetFrame(dark)

    -- pet
    Module:UpdatePetFrame(dark)

    -- focus
    if DF.Wrath then
        --      
        if not f.DarkmodeFocusHooked then
            f.DarkmodeFocusHooked = true
            hooksecurefunc(unitModule, 'ChangeFocusToT', function()
                --  
                local db = Module.db.profile.general
                local dark = true

                Module:UpdateFocusFrame(dark)
            end)
        end
        Module:UpdateFocusFrame(dark)
    end
end

function Module:UpdatePlayerFrame(dark)
    local unitModule = DF:GetModule('Unitframe')
    local f = unitModule.Frame

    if not f.PlayerFrameDeco then return end

    local playerFrameBorder = f.PlayerFrameBorder
    local playerFrameDeco = f.PlayerFrameDeco

    if dark then
        playerFrameBorder:SetDesaturated(true)
        playerFrameBorder:SetVertexColor(0.3, 0.3, 0.3)

        playerFrameDeco:SetDesaturated(true)
        playerFrameDeco:SetVertexColor(0.3, 0.3, 0.3)
    else

    end
end

function Module:UpdatePetFrame(dark)
    local unitModule = DF:GetModule('Unitframe')
    local f = unitModule.Frame

    if not f.PetFrameBackground then return end

    local petBackground = f.PetFrameBackground
    local petBorder = f.PetFrameBorder

    if dark then
        petBackground:SetDesaturated(true)
        petBackground:SetVertexColor(0.3, 0.3, 0.3)

        petBorder:SetDesaturated(true)
        petBorder:SetVertexColor(0.3, 0.3, 0.3)
    else

    end
end

function Module:UpdateTargetFrame(dark)
    local unitModule = DF:GetModule('Unitframe')
    local f = unitModule.Frame

    if not f.TargetFrameBorder then return end

    local targetFrameBorder = f.TargetFrameBorder
    local targetPortExtra = f.PortraitExtra
    local targetOfTargetBorder = f.TargetFrameToTBorder

    if dark then
        targetFrameBorder:SetDesaturated(true)
        targetFrameBorder:SetVertexColor(0.3, 0.3, 0.3)

        targetPortExtra:SetVertexColor(0.6, 0.6, 0.6)

        targetOfTargetBorder:SetDesaturated(true)
        targetOfTargetBorder:SetVertexColor(0.3, 0.3, 0.3)
    else

    end
end

function Module:UpdateFocusFrame(dark)
    local unitModule = DF:GetModule('Unitframe')
    local f = unitModule.Frame

    if not f.FocusFrameBorder then return end

    local focusBorder = f.FocusFrameBorder
    local focusBackground = f.FocusFrameBackground
    local focusPortExtra = f.FocusExtra

    if dark then
        focusBorder:SetDesaturated(true)
        focusBorder:SetVertexColor(0.3, 0.3, 0.3)

        focusBackground:SetDesaturated(true)
        focusBackground:SetVertexColor(0.3, 0.3, 0.3)

        focusPortExtra:SetVertexColor(0.6, 0.6, 0.6)
    else

    end
end

function Module:HookOnEnable()
    local config = DF:GetModule('Config')
    local modules = config.db.profile.modules

    for k, v in pairs(modules) do
        --
        -- print(k, v)
        if not v then
            --
            local m = DF:GetModule(k)
            hooksecurefunc(m, 'OnEnable', function()
                --
                -- print('enabless!')
                Module.ApplySettings()
            end)
        end
    end

end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1, arg2, arg3)
    -- print('event', event) 
    if event == 'MINIMAP_PING' then
        --
        Module.HandlePing(arg1, arg2, arg3)
    elseif event == 'MINIMAP_UPDATE_TRACKING' then
        -- print('MINIMAP_UPDATE_TRACKING', GetTrackingTexture())
        Module.UpdateTrackingEra()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)

-- Cata
function Module.Cata()
    Module:HookOnEnable()
end

-- Wrath
function Module.Wrath()
end

-- Era
function Module.Era()
end
