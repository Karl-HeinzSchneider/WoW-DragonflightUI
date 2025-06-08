local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Darkmode'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local CreateColor = DFCreateColor

local defaults = {
    profile = {
        scale = 1,
        general = {
            -- Unitframes
            unitframeDesaturate = true,
            -- unitframeHealthDesaturate = true,
            unitframeColor = CreateColor(77 / 255, 77 / 255, 77 / 255):GenerateHexColorNoAlpha(),
            -- Minimap
            minimapDesaturate = true,
            minimapColor = CreateColor(0.4, 0.4, 0.4):GenerateHexColorNoAlpha(),
            -- Actionbar
            actionbarDesaturate = true,
            actionbarColor = CreateColor(0.4, 0.4, 0.4):GenerateHexColorNoAlpha(),
            -- Buffs
            buffDesaturate = true,
            buffColor = CreateColor(0.4, 0.4, 0.4):GenerateHexColorNoAlpha(),
            -- Castbar
            castbarDesaturate = true,
            castbarColor = CreateColor(0.4, 0.4, 0.4):GenerateHexColorNoAlpha(),
            -- Flyout
            flyoutDesaturate = true,
            flyoutColor = CreateColor(0.4, 0.4, 0.4):GenerateHexColorNoAlpha()
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

local generalOptions = {
    type = 'group',
    name = 'Darkmode',
    get = getOption,
    set = setOption,
    sortComparator = DFSettingsListMixin.AlphaSortComparator,
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
        headerUnitframes = {
            type = 'header',
            name = L["UnitFramesName"],
            desc = '...',
            order = 100,
            isExpanded = true,
            sortComparator = DFSettingsListMixin.AlphaSortComparator
        },
        unitframeDesaturate = {
            type = 'toggle',
            name = 'Desaturate',
            desc = '' .. getDefaultStr('unitframeDesaturate', 'general'),
            group = 'headerUnitframes',
            order = 100.5
        },
        -- unitframeHealthDesaturate = {
        --     type = 'toggle',
        --     name = 'Desaturate Healthbar',
        --     desc = '' .. getDefaultStr('unitframeHealthDesaturate', 'general'),
        --     order = 100.6
        -- },

        unitframeColor = {
            type = 'color',
            name = L["DarkmodeColor"],
            desc = '' .. getDefaultStr('unitframeColor', 'general', '#'),
            group = 'headerUnitframes',
            order = 105
        },
        headerMinimap = {
            type = 'header',
            name = L["MinimapName"],
            desc = '...',
            order = 200,
            isExpanded = true,
            sortComparator = DFSettingsListMixin.AlphaSortComparator
        },
        minimapDesaturate = {
            type = 'toggle',
            name = L["DarkmodeDesaturate"],
            desc = '' .. getDefaultStr('minimapDesaturate', 'general'),
            group = 'headerMinimap',
            order = 200.5
        },
        minimapColor = {
            type = 'color',
            name = L["DarkmodeColor"],
            desc = '' .. getDefaultStr('minimapColor', 'general', '#'),
            group = 'headerMinimap',
            order = 201
        },
        headerActionbar = {
            type = 'header',
            name = L["ActionbarName"],
            desc = '...',
            order = 300,
            isExpanded = true,
            sortComparator = DFSettingsListMixin.AlphaSortComparator
        },
        actionbarDesaturate = {
            type = 'toggle',
            name = L["DarkmodeDesaturate"],
            desc = '' .. getDefaultStr('actionbarDesaturate', 'general'),
            group = 'headerActionbar',
            order = 300.5
        },
        actionbarColor = {
            type = 'color',
            name = L["DarkmodeColor"],
            desc = '' .. getDefaultStr('actionbarColor', 'general', '#'),
            group = 'headerActionbar',
            order = 301
        },
        headerBuff = {
            type = 'header',
            name = L["BuffsOptionsName"],
            desc = '...',
            order = 400,
            isExpanded = true,
            sortComparator = DFSettingsListMixin.AlphaSortComparator
        },
        buffDesaturate = {
            type = 'toggle',
            name = L["DarkmodeDesaturate"],
            desc = '' .. getDefaultStr('buffDesaturate', 'general'),
            group = 'headerBuff',
            order = 400.5
        },
        buffColor = {
            type = 'color',
            name = L["DarkmodeColor"],
            desc = '' .. getDefaultStr('buffColor', 'general', '#'),
            group = 'headerBuff',
            order = 401
        },
        headerCastbar = {
            type = 'header',
            name = L["CastbarName"],
            desc = '...',
            order = 500,
            isExpanded = true,
            sortComparator = DFSettingsListMixin.AlphaSortComparator
        },
        castbarDesaturate = {
            type = 'toggle',
            name = L["DarkmodeDesaturate"],
            desc = '' .. getDefaultStr('castbarDesaturate', 'general'),
            group = 'headerCastbar',
            order = 500.1
        },
        castbarColor = {
            type = 'color',
            name = L["DarkmodeColor"],
            desc = '' .. getDefaultStr('castbarColor', 'general', '#'),
            group = 'headerCastbar',
            order = 501
        },
        headerFlyout = {
            type = 'header',
            name = L["FlyoutHeader"],
            desc = '...',
            order = 600,
            isExpanded = true,
            sortComparator = DFSettingsListMixin.AlphaSortComparator
        },
        flyoutDesaturate = {
            type = 'toggle',
            name = L["DarkmodeDesaturate"],
            desc = '' .. getDefaultStr('flyoutDesaturate', 'general'),
            group = 'headerFlyout',
            order = 600.1
        },
        flyoutColor = {
            type = 'color',
            name = L["DarkmodeColor"],
            desc = '' .. getDefaultStr('flyoutColor', 'general', '#'),
            group = 'headerFlyout',
            order = 600.2
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
    DF.ConfigModule:RegisterSettingsData('darkmode', 'misc', {
        name = 'Darkmode',
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
    configFrame:RefreshCatSub(cat, 'Darkmode')
end

function Module:ApplySettings()
    local db = Module.db.profile
    local state = db.general

    Module:UpdateMinimap(state)
    Module:UpdateUnitframe(state)
    Module:UpdateActionbar(state)
    Module:UpdateFlyout(state)
    Module:UpdateBuff(state)
    Module:UpdateCastbar(state)
end

function Module:UpdateMinimapButton(btn)
    -- print('darkmode button:', btn:GetName())
    local border = btn.DFTrackingBorder
    if not border then return end

    local state = Module.db.profile.general
    local c = CreateColorFromRGBHexString(state.minimapColor)

    border:SetDesaturated(state.minimapDesaturate)
    border:SetVertexColor(c:GetRGB())
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

    -- local minimapBorderTex = minimapModule.Frame.minimap
    local minimapBorderTex = _G['DragonflightUIMinimapBorder']
    if not minimapBorderTex then return end -- TODO: HACK

    local c = CreateColorFromRGBHexString(state.minimapColor)

    -- minimapBorderTex:SetDesaturated(true)
    -- minimapBorderTex:SetVertexColor(0.4, 0.4, 0.4)  

    minimapBorderTex:SetDesaturated(state.minimapDesaturate)
    minimapBorderTex:SetVertexColor(c:GetRGB())

    MinimapCompassTexture:SetDesaturated(state.minimapDesaturate)
    MinimapCompassTexture:SetVertexColor(c:GetRGB())

    MinimapZoomIn:GetNormalTexture():SetDesaturated(state.minimapDesaturate)
    MinimapZoomIn:GetNormalTexture():SetVertexColor(c:GetRGB())
    MinimapZoomIn:GetDisabledTexture():SetDesaturated(state.minimapDesaturate)
    MinimapZoomIn:GetDisabledTexture():SetVertexColor(c:GetRGB())

    MinimapZoomOut:GetNormalTexture():SetDesaturated(state.minimapDesaturate)
    MinimapZoomOut:GetNormalTexture():SetVertexColor(c:GetRGB())
    MinimapZoomOut:GetDisabledTexture():SetDesaturated(state.minimapDesaturate)
    MinimapZoomOut:GetDisabledTexture():SetVertexColor(c:GetRGB())

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
            _G['LFGMinimapFrameBorder']:SetVertexColor(c:GetRGB())
        else
            if not f.DarkModeLFGHooked then
                f.DarkModeLFGHooked = true

                hooksecurefunc(minimapModule, 'ChangeLFGEra', function()
                    --
                    local db = Module.db.profile
                    local state = db.general
                    if _G['LFGMinimapFrameBorder'] then
                        _G['LFGMinimapFrameBorder']:SetDesaturated(state.minimapDesaturate)
                        _G['LFGMinimapFrameBorder']:SetVertexColor(c:GetRGB())
                    end
                end)
            end
        end

        if _G['MiniMapTrackingBorder'] then
            _G['MiniMapTrackingBorder']:SetDesaturated(state.minimapDesaturate)
            _G['MiniMapTrackingBorder']:SetVertexColor(c:GetRGB())
        end
    end
end

function Module:UpdateUnitframe(state)
    local moduleName = 'Unitframe'
    if not DF.ConfigModule:GetModuleEnabled(moduleName) then return end

    local unitModule = DF:GetModule(moduleName)
    local f = unitModule.Frame
    local c = CreateColorFromRGBHexString(state.unitframeColor)

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
    local c = CreateColorFromRGBHexString(state.unitframeColor)

    if not f.PlayerFrameDeco then return end

    local playerFrameBorder = f.PlayerFrameBorder
    local playerFrameDeco = f.PlayerFrameDeco
    local playerFramePortaitExtra = f.PlayerPortraitExtra

    playerFrameBorder:SetDesaturated(state.unitframeDesaturate)
    playerFrameBorder:SetVertexColor(c:GetRGB())

    playerFrameDeco:SetDesaturated(state.unitframeDesaturate)
    playerFrameDeco:SetVertexColor(c:GetRGB())

    -- playerFramePortaitExtra:SetDesaturated(state.unitframeDesaturate)
    -- playerFramePortaitExtra:SetVertexColor(c:GetRGB())
    playerFramePortaitExtra:SetVertexColor(0.6, 0.6, 0.6) -- TODO

    -- PlayerFrameHealthBar:GetStatusBarTexture():SetDesaturated(state.unitframeHealthDesaturate)
end

function Module:UpdatePetFrame(state)
    local unitModule = DF:GetModule('Unitframe')
    local f = unitModule.Frame
    local c = CreateColorFromRGBHexString(state.unitframeColor)

    if not f.PetFrameBackground then return end

    local petBackground = f.PetFrameBackground
    local petBorder = f.PetFrameBorder

    petBackground:SetDesaturated(state.unitframeDesaturate)
    petBackground:SetVertexColor(c:GetRGB())

    petBorder:SetDesaturated(state.unitframeDesaturate)
    petBorder:SetVertexColor(c:GetRGB())
end

function Module:UpdateTargetFrame(state)
    local unitModule = DF:GetModule('Unitframe')
    local f = unitModule.Frame
    local c = CreateColorFromRGBHexString(state.unitframeColor)

    if not f.TargetFrameBorder then return end

    local targetFrameBorder = f.TargetFrameBorder
    local targetPortExtra = f.PortraitExtra
    local targetOfTargetBorder = f.TargetFrameToTBorder

    targetFrameBorder:SetDesaturated(state.unitframeDesaturate)
    targetFrameBorder:SetVertexColor(c:GetRGB())

    targetOfTargetBorder:SetDesaturated(state.unitframeDesaturate)
    targetOfTargetBorder:SetVertexColor(c:GetRGB())

    -- TODO
    targetPortExtra:SetVertexColor(0.6, 0.6, 0.6)

    -- editmode
    local e = unitModule.PreviewTarget
    e.TargetFrameBorder:SetDesaturated(state.unitframeDesaturate)
    e.TargetFrameBorder:SetVertexColor(c:GetRGB())
end

function Module:UpdatePartyFrame(state)
    local unitModule = DF:GetModule('Unitframe')
    local f = unitModule.Frame
    local c = CreateColorFromRGBHexString(state.unitframeColor)

    for i = 1, 4 do
        local pf = _G['PartyMemberFrame' .. i]

        if pf.PartyFrameBorder then
            -- print('yes')
            pf.PartyFrameBorder:SetDesaturated(state.unitframeDesaturate)
            pf.PartyFrameBorder:SetVertexColor(c:GetRGB())
        else
            -- print('not')
        end
    end

    -- editmode
    local e = unitModule.PreviewParty
    for k, v in ipairs(e.PartyFrames) do
        --
        v.TargetFrameBorder:SetDesaturated(state.unitframeDesaturate)
        v.TargetFrameBorder:SetVertexColor(c:GetRGB())
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

    local c = CreateColorFromRGBHexString(state.unitframeColor)

    focusBorder:SetDesaturated(state.unitframeDesaturate)
    focusBorder:SetVertexColor(c:GetRGB())

    focusBackground:SetDesaturated(state.unitframeDesaturate)
    focusBackground:SetVertexColor(c:GetRGB())

    focusToTBorder:SetDesaturated(state.unitframeDesaturate)
    focusToTBorder:SetVertexColor(c:GetRGB())

    -- TODO
    focusPortExtra:SetVertexColor(0.6, 0.6, 0.6)

    -- editmode
    local e = unitModule.PreviewFocus
    e.TargetFrameBorder:SetDesaturated(state.unitframeDesaturate)
    e.TargetFrameBorder:SetVertexColor(c:GetRGB())
end

function Module:UpdateActionbar(state)
    local moduleName = 'Actionbar'
    if not DF.ConfigModule:GetModuleEnabled(moduleName) then return end

    local unitModule = DF:GetModule(moduleName)
    local f = unitModule.Frame
    local c = CreateColorFromRGBHexString(state.actionbarColor)

    local mainbar = unitModule.bar1
    if not mainbar then return end

    local gryphonLeft = mainbar.gryphonLeft.texture
    local gryphonRight = mainbar.gryphonRight.texture

    gryphonLeft:SetDesaturated(state.actionbarDesaturate)
    gryphonLeft:SetVertexColor(c:GetRGB())

    gryphonRight:SetDesaturated(state.actionbarDesaturate)
    gryphonRight:SetVertexColor(c:GetRGB())

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
                if not state.actionbarColor then return end
                local c = CreateColorFromRGBHexString(state.actionbarColor)

                local buttonTable = bar.buttonTable
                local btnCount = #buttonTable

                for j = 1, btnCount do
                    --
                    local btn = buttonTable[j]
                    if btn.DFNormalTexture then
                        btn.DFNormalTexture:SetVertexColor(c:GetRGB())
                    else
                        btn:GetNormalTexture():SetVertexColor(c:GetRGB())
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
            if not state.actionbarColor then return end
            local c = CreateColorFromRGBHexString(state.actionbarColor)
            if btn.DFNormalTexture then
                btn.DFNormalTexture:SetVertexColor(c:GetRGB())
            else
                -- btn:GetNormalTexture():SetVertexColor(c:GetRGB())
                local normal = btn:GetNormalTexture();
                if normal then
                    normal:SetVertexColor(c:GetRGB())
                else
                    -- print('else', btn:GetName(), c)
                end
            end
        end)
    end

    if true then
        --   
        -- SetItemButtonDesaturated(MainMenuBarBackpackButton, state.actionbarDesaturate)
        -- SetItemButtonTextureVertexColor(MainMenuBarBackpackButton, state.actionbarR / 255, state.actionbarG / 255,
        --                                 state.actionbarB / 255)

        MainMenuBarBackpackButton.Border:SetDesaturated(state.actionbarDesaturate)
        MainMenuBarBackpackButton.Border:SetVertexColor(c:GetRGB())

        for i = 0, 3 do
            --
            local slot = _G['CharacterBag' .. i .. 'Slot']
            slot.Border:SetDesaturated(state.actionbarDesaturate)
            slot.Border:SetVertexColor(c:GetRGB())
        end

        if KeyRingButton and KeyRingButton.Border then
            --       
            KeyRingButton.Border:SetDesaturated(state.actionbarDesaturate)
            KeyRingButton.Border:SetVertexColor(c:GetRGB())
        end
    end

    -- XP/Repbar   
    local XPBar = unitModule.xpbar
    if XPBar and XPBar.Border then
        --
        XPBar.Border:SetDesaturated(state.actionbarDesaturate)
        XPBar.Border:SetVertexColor(c:GetRGB())
    end
    local RepBar = unitModule.repbar
    if RepBar and RepBar.Border then
        --
        RepBar.Border:SetDesaturated(state.actionbarDesaturate)
        RepBar.Border:SetVertexColor(c:GetRGB())
    end
end

function Module:UpdateFlyout(state)
    -- print('UpdateFlyout')
    local moduleName = 'Flyout'
    if not DF.ConfigModule:GetModuleEnabled(moduleName) then return end

    local unitModule = DF:GetModule(moduleName)
    -- local f = unitModule.Frame
    -- local c = CreateColorFromRGBHexString(state.flyoutColor)

    for i = 1, unitModule.NumCustomButtons do
        local f = unitModule['Custom' .. i .. 'Button']

        if f then
            if not f.DFDarkmodeUpdateBarButtons then
                f.DFDarkmodeUpdateBarButtons = function()
                    -- print('DFDarkmodeUpdateBarButtons', f:GetName())
                    local c = CreateColorFromRGBHexString(state.flyoutColor)

                    if f.DFNormalTexture then
                        f.DFNormalTexture:SetVertexColor(c:GetRGB())
                    else
                        f:GetNormalTexture():SetVertexColor(c:GetRGB())
                    end

                    local buttonTable = f.buttonTable
                    local btnCount = #buttonTable

                    for j = 1, btnCount do
                        --
                        local btn = buttonTable[j]
                        if btn.DFNormalTexture then
                            btn.DFNormalTexture:SetVertexColor(c:GetRGB())
                        else
                            btn:GetNormalTexture():SetVertexColor(c:GetRGB())
                        end
                    end
                end

                hooksecurefunc(f, 'Update', function()
                    --
                    -- print('updatehook', k, bar:GetName())
                    f.DFDarkmodeUpdateBarButtons()
                end)

            end
            f.DFDarkmodeUpdateBarButtons()
        end

    end
end

function Module:UpdateBuff(state)
    local unitModule = DF:GetModule('Buffs')
    local f = unitModule.Frame

    if not unitModule:IsEnabled() then return end
    local c = CreateColorFromRGBHexString(state.buffColor)

    -- update defaults
    unitModule.BuffVertexColorR = c.r;
    unitModule.BuffVertexColorG = c.g;
    unitModule.BuffVertexColorB = c.b;

    local buff;
    -- player
    for i = 1, 40 do
        --
        buff = _G['BuffButton' .. i]
        if buff and buff.DFIconBorder then
            --
            buff.DFIconBorder:SetDesaturated(state.buffDesaturate)
            buff.DFIconBorder:SetVertexColor(c:GetRGB())
        end
    end
    -- target 
    for i = 1, MAX_TARGET_BUFFS do
        --   
        buff = _G['TargetFrameBuff' .. i];
        if buff and buff.DFIconBorder then
            --
            buff.DFIconBorder:SetDesaturated(state.buffDesaturate)
            buff.DFIconBorder:SetVertexColor(c:GetRGB())
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
                buff.DFIconBorder:SetVertexColor(c:GetRGB())
            end
        end
    end
end

function Module:UpdateCastbar(state)
    local unitModule = DF:GetModule('Castbar')
    local f = unitModule.Frame
    local c = CreateColorFromRGBHexString(state.castbarColor)

    if not unitModule:IsEnabled() then return end

    local player = unitModule.PlayerCastbar
    local target = unitModule.TargetCastbar
    local focus = unitModule.FocusCastbar

    local frameTable = {player, target, focus}

    for k, v in pairs(frameTable) do
        v.Background:SetDesaturated(state.castbarDesaturate)
        v.Background:SetVertexColor(c:GetRGB())

        v.Border:SetDesaturated(state.castbarDesaturate)
        v.Border:SetVertexColor(c:GetRGB())

        v.BorderShield:SetDesaturated(state.castbarDesaturate)
        v.BorderShield:SetVertexColor(c:GetRGB())

        v.Icon.Border:SetDesaturated(state.castbarDesaturate)
        v.Icon.Border:SetVertexColor(c:GetRGB())
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
            local m = DF:GetModule(k, true)
            if m then
                hooksecurefunc(m, 'OnEnable', function()
                    --
                    -- print('enabless!')
                    Module:ApplySettings()
                end)
            end
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

function Module:Era()
    Module:HookOnEnable()
end

function Module:TBC()
end

function Module:Wrath()
    Module:HookOnEnable()
end

function Module:Cata()
    Module:HookOnEnable()
end

function Module:Mists()
    Module:HookOnEnable()
end
