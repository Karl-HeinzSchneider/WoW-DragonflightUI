local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Darkmode'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        scale = 1,
        general = {
            -- Unitframes
            unitframeDesaturate = true,
            -- unitframeHealthDesaturate = true,
            unitframeR = 77, -- 0.3 * 255 = 67.5
            unitframeG = 77,
            unitframeB = 77,
            -- Minimap
            minimapDesaturate = true,
            minimapR = 0.4 * 255,
            minimapG = 0.4 * 255,
            minimapB = 0.4 * 255,
            -- Actionbar
            actionbarDesaturate = true,
            actionbarR = 0.4 * 255,
            actionbarG = 0.4 * 255,
            actionbarB = 0.4 * 255,
            -- Buffs
            buffDesaturate = true,
            buffR = 0.4 * 255,
            buffG = 0.4 * 255,
            buffB = 0.4 * 255,
            -- Castbar
            castbarDesaturate = true,
            castbarR = 0.4 * 255,
            castbarG = 0.4 * 255,
            castbarB = 0.4 * 255
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
        headerUnitframes = {type = 'header', name = 'Unitframes', desc = '...', order = 100},
        unitframeDesaturate = {
            type = 'toggle',
            name = 'Desaturate',
            desc = '' .. getDefaultStr('unitframeDesaturate', 'general'),
            order = 100.5
        },
        -- unitframeHealthDesaturate = {
        --     type = 'toggle',
        --     name = 'Desaturate Healthbar',
        --     desc = '' .. getDefaultStr('unitframeHealthDesaturate', 'general'),
        --     order = 100.6
        -- },
        unitframeR = {
            type = 'range',
            name = 'r',
            desc = '' .. getDefaultStr('unitframeR', 'general'),
            min = 0,
            max = 255,
            bigStep = 1,
            order = 101
        },
        unitframeG = {
            type = 'range',
            name = 'g',
            desc = '' .. getDefaultStr('unitframeG', 'general'),
            min = 0,
            max = 255,
            bigStep = 1,
            order = 102
        },
        unitframeB = {
            type = 'range',
            name = 'b',
            desc = '' .. getDefaultStr('unitframeB', 'general'),
            min = 0,
            max = 255,
            bigStep = 1,
            order = 103
        },
        headerMinimap = {type = 'header', name = 'Minimap', desc = '...', order = 200},
        minimapDesaturate = {
            type = 'toggle',
            name = 'Desaturate',
            desc = '' .. getDefaultStr('minimapDesaturate', 'general'),
            order = 200.5
        },
        minimapR = {
            type = 'range',
            name = 'r',
            desc = '' .. getDefaultStr('minimapR', 'general'),
            min = 0,
            max = 255,
            bigStep = 1,
            order = 201
        },
        minimapG = {
            type = 'range',
            name = 'g',
            desc = '' .. getDefaultStr('minimapG', 'general'),
            min = 0,
            max = 255,
            bigStep = 1,
            order = 202
        },
        minimapB = {
            type = 'range',
            name = 'b',
            desc = '' .. getDefaultStr('minimapB', 'general'),
            min = 0,
            max = 255,
            bigStep = 1,
            order = 203
        },
        headerActionbar = {type = 'header', name = 'Actionbar', desc = '...', order = 300},
        actionbarDesaturate = {
            type = 'toggle',
            name = 'Desaturate',
            desc = '' .. getDefaultStr('actionbarDesaturate', 'general'),
            order = 300.5
        },
        actionbarR = {
            type = 'range',
            name = 'r',
            desc = '' .. getDefaultStr('actionbarR', 'general'),
            min = 0,
            max = 255,
            bigStep = 1,
            order = 301
        },
        actionbarG = {
            type = 'range',
            name = 'g',
            desc = '' .. getDefaultStr('actionbarG', 'general'),
            min = 0,
            max = 255,
            bigStep = 1,
            order = 302
        },
        actionbarB = {
            type = 'range',
            name = 'b',
            desc = '' .. getDefaultStr('actionbarB', 'general'),
            min = 0,
            max = 255,
            bigStep = 1,
            order = 303
        },
        headerBuff = {type = 'header', name = 'Buffs', desc = '...', order = 400},
        buffDesaturate = {
            type = 'toggle',
            name = 'Desaturate',
            desc = '' .. getDefaultStr('buffDesaturate', 'general'),
            order = 400.5
        },
        buffR = {
            type = 'range',
            name = 'r',
            desc = '' .. getDefaultStr('buffR', 'general'),
            min = 0,
            max = 255,
            bigStep = 1,
            order = 401
        },
        buffG = {
            type = 'range',
            name = 'g',
            desc = '' .. getDefaultStr('buffG', 'general'),
            min = 0,
            max = 255,
            bigStep = 1,
            order = 402
        },
        buffB = {
            type = 'range',
            name = 'b',
            desc = '' .. getDefaultStr('buffB', 'general'),
            min = 0,
            max = 255,
            bigStep = 1,
            order = 403
        },
        headerCastbar = {type = 'header', name = 'Castbar', desc = '...', order = 500},
        castbarDesaturate = {
            type = 'toggle',
            name = 'Desaturate',
            desc = '' .. getDefaultStr('castbarDesaturate', 'general'),
            order = 500.1
        },
        castbarR = {
            type = 'range',
            name = 'r',
            desc = '' .. getDefaultStr('castbarR', 'general'),
            min = 0,
            max = 255,
            bigStep = 1,
            order = 500.5
        },
        castbarG = {
            type = 'range',
            name = 'g',
            desc = '' .. getDefaultStr('castbarG', 'general'),
            min = 0,
            max = 255,
            bigStep = 1,
            order = 500.6
        },
        castbarB = {
            type = 'range',
            name = 'b',
            desc = '' .. getDefaultStr('castbarB', 'general'),
            min = 0,
            max = 255,
            bigStep = 1,
            order = 500.7
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

    Module:ApplySettings()
    Module:RegisterOptionScreens()

    -- TODO: hack, bar 2-5 gets overriden
    C_Timer.After(0, function()
        --
        local db = Module.db.profile
        local state = db.general
        Module:UpdateActionbar(state)
    end)

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)
        Module:ApplySettings()
        Module:RefreshOptionScreens()
    end)
end

function Module:OnDisable()
end

function Module:RegisterSettings()
    local moduleName = 'Darkmode'
    local cat = 'misc'
    local function register(name, data)
        data.module = moduleName;
        DF.ConfigModule:RegisterSettingsElement(name, cat, data, true)
    end

    register('darkmode', {order = 0, name = 'Dark Mode', descr = 'Darkmodess', isNew = false})
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
    local state = db.general

    Module:UpdateMinimap(state)
    Module:UpdateUnitframe(state)
    Module:UpdateActionbar(state)
    Module:UpdateBuff(state)
    Module:UpdateCastbar(state)
end

function Module:UpdateMinimapButton(btn)
    -- print('darkmode button:', btn:GetName())
    local border = btn.DFTrackingBorder
    if not border then return end

    local state = Module.db.profile.general

    border:SetDesaturated(state.minimapDesaturate)
    border:SetVertexColor(state.minimapR / 255, state.minimapG / 255, state.minimapB / 255)
end

function Module:UpdateMinimap(state)
    local moduleName = 'Minimap'
    local minimapModule = DF:GetModule(moduleName)

    if not DF.ConfigModule:GetModuleEnabled(moduleName) then
        -- default
        -- minimapBorderTex:SetDesaturated(false)
        -- minimapBorderTex:SetVertexColor(1.0, 1.0, 1.0)
        return
    end

    local minimapBorderTex = minimapModule.Frame.minimap
    if not minimapBorderTex then return end -- TODO: HACK

    -- minimapBorderTex:SetDesaturated(true)
    -- minimapBorderTex:SetVertexColor(0.4, 0.4, 0.4)  

    minimapBorderTex:SetDesaturated(state.minimapDesaturate)
    minimapBorderTex:SetVertexColor(state.minimapR / 255, state.minimapG / 255, state.minimapB / 255)

    MinimapZoomIn:GetNormalTexture():SetDesaturated(state.minimapDesaturate)
    MinimapZoomIn:GetNormalTexture():SetVertexColor(state.minimapR / 255, state.minimapG / 255, state.minimapB / 255)
    MinimapZoomIn:GetDisabledTexture():SetDesaturated(state.minimapDesaturate)
    MinimapZoomIn:GetDisabledTexture():SetVertexColor(state.minimapR / 255, state.minimapG / 255, state.minimapB / 255)

    MinimapZoomOut:GetNormalTexture():SetDesaturated(state.minimapDesaturate)
    MinimapZoomOut:GetNormalTexture():SetVertexColor(state.minimapR / 255, state.minimapG / 255, state.minimapB / 255)
    MinimapZoomOut:GetDisabledTexture():SetDesaturated(state.minimapDesaturate)
    MinimapZoomOut:GetDisabledTexture():SetVertexColor(state.minimapR / 255, state.minimapG / 255, state.minimapB / 255)

    -- TODO: minimap buttons

    -- if dark then
    --     minimapBorderTex:SetDesaturated(true)
    --     minimapBorderTex:SetVertexColor(0.4, 0.4, 0.4)
    -- else
    --     minimapBorderTex:SetDesaturated(false)
    --     minimapBorderTex:SetVertexColor(1.0, 1.0, 1.0)
    -- end

    local libIcon = LibStub("LibDBIcon-1.0")

    if not libIcon then return end

    local f = minimapModule.Frame;
    if not f.DarkmodeButtonHooked then
        f.DarkmodeButtonHooked = true

        hooksecurefunc(minimapModule, 'UpdateButton', function(btn)
            Module:UpdateMinimapButton(btn)
        end)
    end

    local buttons = libIcon:GetButtonList()

    for k, v in ipairs(buttons) do
        ---@diagnostic disable-next-line: param-type-mismatch
        local btn = libIcon:GetMinimapButton(v)

        if btn then
            --
            Module:UpdateMinimapButton(btn)
        end
    end

    if DF.Era then
        if _G['LFGMinimapFrameBorder'] then
            _G['LFGMinimapFrameBorder']:SetDesaturated(state.minimapDesaturate)
            _G['LFGMinimapFrameBorder']:SetVertexColor(state.minimapR / 255, state.minimapG / 255, state.minimapB / 255)
        else
            if not f.DarkModeLFGHooked then
                f.DarkModeLFGHooked = true

                hooksecurefunc(minimapModule, 'CreateQueueStatus', function()
                    --
                    local db = Module.db.profile
                    local state = db.general
                    if _G['LFGMinimapFrameBorder'] then
                        _G['LFGMinimapFrameBorder']:SetDesaturated(state.minimapDesaturate)
                        _G['LFGMinimapFrameBorder']:SetVertexColor(state.minimapR / 255, state.minimapG / 255,
                                                                   state.minimapB / 255)
                    end
                end)
            end
        end

        if _G['MiniMapTrackingBorder'] then
            _G['MiniMapTrackingBorder']:SetDesaturated(state.minimapDesaturate)
            _G['MiniMapTrackingBorder']:SetVertexColor(state.minimapR / 255, state.minimapG / 255, state.minimapB / 255)
        end
    end
end

function Module:UpdateUnitframe(state)
    local moduleName = 'Unitframe'
    if not DF.ConfigModule:GetModuleEnabled(moduleName) then return end

    local unitModule = DF:GetModule(moduleName)
    local f = unitModule.Frame

    -- player
    if not f.DarkmodePlayerStatusHooked then
        f.DarkmodePlayerStatusHooked = true
        hooksecurefunc(unitModule, 'UpdatePlayerStatus', function()
            --  
            local state = Module.db.profile.general
            Module:UpdatePlayerFrame(state)
        end)
    end
    Module:UpdatePlayerFrame(state)

    -- target
    if not f.DarkmodeTargetHooked then
        f.DarkmodeTargetHooked = true
        hooksecurefunc(unitModule, 'ChangeToT', function()
            --  
            local state = Module.db.profile.general
            Module:UpdateTargetFrame(state)
        end)
    end
    Module:UpdateTargetFrame(state)

    -- pet
    Module:UpdatePetFrame(state)

    -- party
    Module:UpdatePartyFrame(state)

    -- focus
    if DF.Wrath then
        --      
        if not f.DarkmodeFocusHooked then
            f.DarkmodeFocusHooked = true
            hooksecurefunc(unitModule, 'ChangeFocusToT', function()
                --  
                local state = Module.db.profile.general
                Module:UpdateFocusFrame(state)
            end)
        end
        Module:UpdateFocusFrame(state)
    end
end

function Module:UpdatePlayerFrame(state)
    local unitModule = DF:GetModule('Unitframe')
    local f = unitModule.Frame

    if not f.PlayerFrameDeco then return end

    local playerFrameBorder = f.PlayerFrameBorder
    local playerFrameDeco = f.PlayerFrameDeco

    playerFrameBorder:SetDesaturated(state.unitframeDesaturate)
    playerFrameBorder:SetVertexColor(state.unitframeR / 255, state.unitframeG / 255, state.unitframeB / 255)

    playerFrameDeco:SetDesaturated(state.unitframeDesaturate)
    playerFrameDeco:SetVertexColor(state.unitframeR / 255, state.unitframeG / 255, state.unitframeB / 255)

    -- PlayerFrameHealthBar:GetStatusBarTexture():SetDesaturated(state.unitframeHealthDesaturate)
end

function Module:UpdatePetFrame(state)
    local unitModule = DF:GetModule('Unitframe')
    local f = unitModule.Frame

    if not f.PetFrameBackground then return end

    local petBackground = f.PetFrameBackground
    local petBorder = f.PetFrameBorder

    petBackground:SetDesaturated(state.unitframeDesaturate)
    petBackground:SetVertexColor(state.unitframeR / 255, state.unitframeG / 255, state.unitframeB / 255)

    petBorder:SetDesaturated(state.unitframeDesaturate)
    petBorder:SetVertexColor(state.unitframeR / 255, state.unitframeG / 255, state.unitframeB / 255)
end

function Module:UpdateTargetFrame(state)
    local unitModule = DF:GetModule('Unitframe')
    local f = unitModule.Frame

    if not f.TargetFrameBorder then return end

    local targetFrameBorder = f.TargetFrameBorder
    local targetPortExtra = f.PortraitExtra
    local targetOfTargetBorder = f.TargetFrameToTBorder

    targetFrameBorder:SetDesaturated(state.unitframeDesaturate)
    targetFrameBorder:SetVertexColor(state.unitframeR / 255, state.unitframeG / 255, state.unitframeB / 255)

    targetOfTargetBorder:SetDesaturated(state.unitframeDesaturate)
    targetOfTargetBorder:SetVertexColor(state.unitframeR / 255, state.unitframeG / 255, state.unitframeB / 255)

    -- TODO
    targetPortExtra:SetVertexColor(0.6, 0.6, 0.6)

    -- editmode
    local e = unitModule.PreviewTarget
    e.TargetFrameBorder:SetDesaturated(state.unitframeDesaturate)
    e.TargetFrameBorder:SetVertexColor(state.unitframeR / 255, state.unitframeG / 255, state.unitframeB / 255)
end

function Module:UpdatePartyFrame(state)
    local unitModule = DF:GetModule('Unitframe')
    local f = unitModule.Frame

    for i = 1, 4 do
        local pf = _G['PartyMemberFrame' .. i]

        if pf.PartyFrameBorder then
            -- print('yes')
            pf.PartyFrameBorder:SetDesaturated(state.unitframeDesaturate)
            pf.PartyFrameBorder:SetVertexColor(state.unitframeR / 255, state.unitframeG / 255, state.unitframeB / 255)
        else
            -- print('not')
        end
    end

    -- editmode
    local e = unitModule.PreviewParty
    for k, v in ipairs(e.PartyFrames) do
        --
        v.TargetFrameBorder:SetDesaturated(state.unitframeDesaturate)
        v.TargetFrameBorder:SetVertexColor(state.unitframeR / 255, state.unitframeG / 255, state.unitframeB / 255)
    end
end

function Module:UpdateFocusFrame(state)
    local unitModule = DF:GetModule('Unitframe')
    local f = unitModule.Frame

    if not f.FocusFrameBorder then return end

    local focusBorder = f.FocusFrameBorder
    local focusBackground = f.FocusFrameBackground
    local focusPortExtra = f.FocusExtra
    local focusToTBorder = f.FocusFrameToTBorder

    focusBorder:SetDesaturated(state.unitframeDesaturate)
    focusBorder:SetVertexColor(state.unitframeR / 255, state.unitframeG / 255, state.unitframeB / 255)

    focusBackground:SetDesaturated(state.unitframeDesaturate)
    focusBackground:SetVertexColor(state.unitframeR / 255, state.unitframeG / 255, state.unitframeB / 255)

    focusToTBorder:SetDesaturated(state.unitframeDesaturate)
    focusToTBorder:SetVertexColor(state.unitframeR / 255, state.unitframeG / 255, state.unitframeB / 255)

    -- TODO
    focusPortExtra:SetVertexColor(0.6, 0.6, 0.6)

    -- editmode
    local e = unitModule.PreviewFocus
    e.TargetFrameBorder:SetDesaturated(state.unitframeDesaturate)
    e.TargetFrameBorder:SetVertexColor(state.unitframeR / 255, state.unitframeG / 255, state.unitframeB / 255)
end

function Module:UpdateActionbar(state)
    local moduleName = 'Actionbar'
    if not DF.ConfigModule:GetModuleEnabled(moduleName) then return end

    local unitModule = DF:GetModule(moduleName)
    local f = unitModule.Frame

    local mainbar = unitModule.bar1
    if not mainbar then return end

    local gryphonLeft = mainbar.gryphonLeft.texture
    local gryphonRight = mainbar.gryphonRight.texture

    gryphonLeft:SetDesaturated(state.actionbarDesaturate)
    gryphonLeft:SetVertexColor(state.actionbarR / 255, state.actionbarG / 255, state.actionbarB / 255)

    gryphonRight:SetDesaturated(state.actionbarDesaturate)
    gryphonRight:SetVertexColor(state.actionbarR / 255, state.actionbarG / 255, state.actionbarB / 255)

    local barTable = {}
    for i = 1, 8 do
        local bar = unitModule['bar' .. i]
        if bar then table.insert(barTable, bar) end
    end
    if unitModule['petbar'] then table.insert(barTable, unitModule['petbar']) end
    if unitModule['stancebar'] then table.insert(barTable, unitModule['stancebar']) end

    for k, bar in ipairs(barTable) do
        if not bar.DFDarkmodeUpdateBarButtons then
            bar.DFDarkmodeUpdateBarButtons = function()
                local buttonTable = bar.buttonTable
                local btnCount = #buttonTable

                for j = 1, btnCount do
                    --
                    local btn = buttonTable[j]
                    if btn.DFNormalTexture then
                        btn.DFNormalTexture:SetVertexColor(state.actionbarR / 255, state.actionbarG / 255,
                                                           state.actionbarB / 255)
                    else
                        btn:GetNormalTexture():SetVertexColor(state.actionbarR / 255, state.actionbarG / 255,
                                                              state.actionbarB / 255)
                    end
                end
            end

            hooksecurefunc(bar, 'Update', function()
                --
                -- print('updatehook', k, bar:GetName())
                bar.DFDarkmodeUpdateBarButtons()
            end)
        end

        bar.DFDarkmodeUpdateBarButtons()
    end

    if not Module.DFActionbarGridHooked then
        Module.DFActionbarGridHooked = true

        hooksecurefunc('ActionButton_ShowGrid', function(btn)
            for k, bar in ipairs(barTable) do
                --
                bar.DFDarkmodeUpdateBarButtons()
            end
        end)

        hooksecurefunc('ActionButton_HideGrid', function(btn)
            for k, bar in ipairs(barTable) do
                --
                bar.DFDarkmodeUpdateBarButtons()
            end
        end)

        hooksecurefunc('ActionButton_UpdateUsable', function(btn)
            --
            -- print('ActionButton_UpdateUsable', btn:GetName())
            if btn.DFNormalTexture then
                btn.DFNormalTexture:SetVertexColor(state.actionbarR / 255, state.actionbarG / 255,
                                                   state.actionbarB / 255)
            else
                btn:GetNormalTexture():SetVertexColor(state.actionbarR / 255, state.actionbarG / 255,
                                                      state.actionbarB / 255)
            end
        end)
    end

    -- for i = 0, 8 do
    --     local bar = unitModule['bar' .. i]
    --     if i == 0 then bar = unitModule['petbar'] end
    --     if bar then
    --         --     
    --         if not bar.DFDarkmodeUpdateBarButtons then
    --             bar.DFDarkmodeUpdateBarButtons = function()
    --                 local buttonTable = bar.buttonTable
    --                 local btnCount = #buttonTable

    --                 for j = 1, btnCount do
    --                     --
    --                     local btn = buttonTable[j]
    --                     btn:GetNormalTexture():SetVertexColor(state.actionbarR / 255, state.actionbarG / 255,
    --                                                           state.actionbarB / 255)
    --                 end
    --             end

    --             hooksecurefunc(bar, 'Update', function()
    --                 --
    --                 -- print('updatehook', i)
    --                 bar.DFDarkmodeUpdateBarButtons()
    --             end)
    --         end

    --         bar.DFDarkmodeUpdateBarButtons()
    --     end
    -- end

    if true then
        --   
        -- SetItemButtonDesaturated(MainMenuBarBackpackButton, state.actionbarDesaturate)
        -- SetItemButtonTextureVertexColor(MainMenuBarBackpackButton, state.actionbarR / 255, state.actionbarG / 255,
        --                                 state.actionbarB / 255)

        MainMenuBarBackpackButton.Border:SetDesaturated(state.actionbarDesaturate)
        MainMenuBarBackpackButton.Border:SetVertexColor(state.actionbarR / 255, state.actionbarG / 255,
                                                        state.actionbarB / 255)

        for i = 0, 3 do
            --
            local slot = _G['CharacterBag' .. i .. 'Slot']
            slot.Border:SetDesaturated(state.actionbarDesaturate)
            slot.Border:SetVertexColor(state.actionbarR / 255, state.actionbarG / 255, state.actionbarB / 255)
        end

        if KeyRingButton and KeyRingButton.Border then
            --       
            KeyRingButton.Border:SetDesaturated(state.actionbarDesaturate)
            KeyRingButton.Border:SetVertexColor(state.actionbarR / 255, state.actionbarG / 255, state.actionbarB / 255)
        end
    end

    -- XP/Repbar   
    local XPBar = unitModule.xpbar
    if XPBar and XPBar.Border then
        --
        XPBar.Border:SetDesaturated(state.actionbarDesaturate)
        XPBar.Border:SetVertexColor(state.actionbarR / 255, state.actionbarG / 255, state.actionbarB / 255)
    end
    local RepBar = unitModule.repbar
    if RepBar and RepBar.Border then
        --
        RepBar.Border:SetDesaturated(state.actionbarDesaturate)
        RepBar.Border:SetVertexColor(state.actionbarR / 255, state.actionbarG / 255, state.actionbarB / 255)
    end
end

function Module:UpdateBuff(state)
    local unitModule = DF:GetModule('Buffs')
    local f = unitModule.Frame

    if not unitModule:IsEnabled() then return end

    -- update defaults
    unitModule.BuffVertexColorR = state.buffR / 255;
    unitModule.BuffVertexColorG = state.buffG / 255;
    unitModule.BuffVertexColorB = state.buffB / 255;

    local buff;
    -- player
    for i = 1, 40 do
        --
        buff = _G['BuffButton' .. i]
        if buff and buff.DFIconBorder then
            --
            buff.DFIconBorder:SetDesaturated(state.buffDesaturate)
            buff.DFIconBorder:SetVertexColor(unitModule.BuffVertexColorR, unitModule.BuffVertexColorG,
                                             unitModule.BuffVertexColorB)
        end
    end
    -- target 
    for i = 1, MAX_TARGET_BUFFS do
        --   
        buff = _G['TargetFrameBuff' .. i];
        if buff and buff.DFIconBorder then
            --
            buff.DFIconBorder:SetDesaturated(state.buffDesaturate)
            buff.DFIconBorder:SetVertexColor(unitModule.BuffVertexColorR, unitModule.BuffVertexColorG,
                                             unitModule.BuffVertexColorB)
        end
    end
    -- focus 
    if DF.Wrath then
        for i = 1, MAX_TARGET_BUFFS do
            --   
            buff = _G['FocusFrameBuff' .. i];
            if buff and buff.DFIconBorder then
                --
                buff.DFIconBorder:SetDesaturated(state.buffDesaturate)
                buff.DFIconBorder:SetVertexColor(unitModule.BuffVertexColorR, unitModule.BuffVertexColorG,
                                                 unitModule.BuffVertexColorB)
            end
        end
    end
end

function Module:UpdateCastbar(state)
    local unitModule = DF:GetModule('Castbar')
    local f = unitModule.Frame

    if not unitModule:IsEnabled() then return end

    local player = unitModule.PlayerCastbar
    local target = unitModule.TargetCastbar
    local focus = unitModule.FocusCastbar

    local frameTable = {player, target, focus}

    for k, v in pairs(frameTable) do
        v.Background:SetDesaturated(state.castbarDesaturate)
        v.Background:SetVertexColor(state.castbarR / 255, state.castbarG / 255, state.castbarB / 255)

        v.Border:SetDesaturated(state.castbarDesaturate)
        v.Border:SetVertexColor(state.castbarR / 255, state.castbarG / 255, state.castbarB / 255)

        v.BorderShield:SetDesaturated(state.castbarDesaturate)
        v.BorderShield:SetVertexColor(state.castbarR / 255, state.castbarG / 255, state.castbarB / 255)

        v.Icon.Border:SetDesaturated(state.castbarDesaturate)
        v.Icon.Border:SetVertexColor(state.castbarR / 255, state.castbarG / 255, state.castbarB / 255)
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
                Module:ApplySettings()
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
    Module:HookOnEnable()
end

-- Era
function Module.Era()
    Module:HookOnEnable()
end
