local Addon, Core = ...
local Module = 'Actionbar'

local frame = CreateFrame('FRAME', 'DragonflightUIActionbarFrame', UIParent)
frame:SetFrameStrata('HIGH')

local SetPointActionButton1

function ChangeActionbar()
    ActionButton1:ClearAllPoints()
    --ActionButton1:SetPoint('CENTER', MainMenuBar, 'CENTER', -230 + 3 * 5.5, 42 + 25)
    ActionButton1:SetPoint('CENTER', MainMenuBar, 'CENTER', -230 + 3 * 5.5, 30 + 18)
    --SetPointActionButton1 = ActionButton1.SetPoint()
    --[[ ActionButton1.SetPoint = function()
    end ]]
    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetPoint('LEFT', ActionButton1, 'LEFT', 0, 40)
    MultiBarBottomLeft.SetPoint = function()
    end

    MultiBarBottomRight:ClearAllPoints()
    MultiBarBottomRight:SetPoint('LEFT', MultiBarBottomLeft, 'LEFT', 0, 40)
    MultiBarBottomRight.SetPoint = function()
    end

    StanceButton1:ClearAllPoints()
    StanceButton1:SetPoint('LEFT', MultiBarBottomLeft, 'LEFT', 1, 77)
    StanceButton1.SetPoint = function()
    end

    ActionBarUpButton:ClearAllPoints()
    ActionBarUpButton:SetPoint('LEFT', ActionButton1, 'TOPLEFT', -40, -6)
    ActionBarDownButton:ClearAllPoints()
    ActionBarDownButton:SetPoint('LEFT', ActionButton1, 'BOTTOMLEFT', -40, 7)

    --MainMenuBarPageNumber:ClearAllPoints()
    --MainMenuBarPageNumber:SetPoint('LEFT', MultiBarBottomRight, 'LEFT', -50, 0)
    MainMenuExpBar:Hide()
    hooksecurefunc(
        MainMenuExpBar,
        'Show',
        function()
            --print('Show MainMenuExpBar')
            MainMenuExpBar:Hide()
        end
    )
    ReputationWatchBar:Hide()
    hooksecurefunc(
        ReputationWatchBar,
        'Show',
        function()
            --print('Show ReputationWatchBar')
            ReputationWatchBar:Hide()
        end
    )
    MainMenuBarMaxLevelBar:Hide()
    hooksecurefunc(
        MainMenuBarMaxLevelBar,
        'Show',
        function()
            --print('Show MainMenuBarMaxLevelBar')
            MainMenuBarMaxLevelBar:Hide()
        end
    )
end
--ChangeActionbar()

function CreateNewXPBar()
    local f = CreateFrame('Frame', 'DragonflightUIXPBar', UIParent)
    f:SetSize(1137, 32)
    f:SetPoint('BOTTOM', 0, 5)
    f:SetScale(0.5)
    local tex = f:CreateTexture('Background', 'BACKGROUND')
    tex:SetAllPoints()
    tex:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\XP\\Background')
    tex:SetTexCoord(0, 1137 / 2048, 0, 1)
    f.Background = tex

    -- actual status bar, child of parent above
    f.Bar = CreateFrame('StatusBar', nil, f)
    f.Bar:SetPoint('CENTER')
    f.Bar:SetSize(1137, 32)

    f.Bar.Texture = f.Bar:CreateTexture(nil, 'BORDER')
    f.Bar.Texture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\XP\\Main')
    f.Bar.Texture:SetAllPoints()

    f.Bar:SetStatusBarTexture(f.Bar.Texture)

    --border
    local border = f.Bar:CreateTexture('Border', 'OVERLAY')
    border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\XP\\Overlay')
    border:SetTexCoord(0, 1137 / 2048, 0, 1)
    border:SetSize(1137, 32)
    border:SetPoint('CENTER')
    f.Border = border

    -- text
    local Path, Size, Flags = MainMenuBarExpText:GetFont()
    f.Bar:EnableMouse(true);

    f.Text = f.Bar:CreateFontString('Text', 'HIGHLIGHT', 'GameFontNormal')
    f.Text:SetFont("Fonts\\FRIZQT__.TTF", 18, "THINOUTLINE")
    f.Text:SetTextColor(1, 1, 1, 1)
    f.Text:SetText('')
    f.Text:ClearAllPoints()
    f.Text:SetParent(f.Bar)
    f.Text:SetPoint('CENTER', 0, 4)

    frame.XPBar = f

    frame.XPBar.valid = false

    frame.UpdateXPBar = function()
        local showXP = false
        if Core.Wrath then
            showXP = UnitLevel('player') < GetMaxPlayerLevel() and not IsXPUserDisabled()
        else
            showXP = UnitLevel('player') < GetMaxPlayerLevel()
        end

        if showXP then
            -- exhaustion
            local exhaustionStateID = GetRestState()
            if (exhaustionStateID == 1) then
                f.Bar.Texture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\XP\\Main')
            elseif (exhaustionStateID == 2) then
                f.Bar.Texture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\XP\\Rested')
            end

            -- value
            local playerCurrXP = UnitXP('player')
            local playerMaxXP = UnitXPMax('player')
            frame.XPBar.Bar:SetMinMaxValues(0, playerMaxXP)
            frame.XPBar.Bar:SetValue(playerCurrXP)

            frame.XPBar.Text:SetText('XP: ' .. playerCurrXP .. '/' .. playerMaxXP)
            --frame.XPBar:Show()
            frame.XPBar.valid = true
        else
            --frame.XPBar:Hide()
            frame.XPBar.valid = false
        end
    end

    frame:RegisterEvent('PLAYER_XP_UPDATE')
    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
    frame:RegisterEvent('UPDATE_EXHAUSTION')
end
--CreateNewXPBar()

function CreateNewRepBar()
    local size = 460
    local f = CreateFrame('Frame', 'DragonflightUIRepBar', UIParent)
    f:SetSize(size, 14)
    f:SetPoint('BOTTOM', 0, 5 + 20)

    local tex = f:CreateTexture('Background', 'ARTWORK')
    tex:SetAllPoints()
    --tex:SetColorTexture(0, 0, 0)
    --tex:SetAlpha(0.5)
    tex:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiexperiencebar2x')
    tex:SetTexCoord(.00048828125, 0.55029296875, 0.08203125, 0.15234375)
    f.Background = tex

    -- actual status bar, child of parent above
    f.Bar = CreateFrame('StatusBar', nil, f)
    f.Bar:SetStatusBarTexture('Interface\\TargetingFrame\\UI-StatusBar')
    f.Bar:SetPoint('TOPLEFT', 0, 0)
    f.Bar:SetPoint('BOTTOMRIGHT', 0, 0)
    f.Bar:SetStatusBarColor(0.0, 0.39, 0.88, 1.0)

    --border
    local border = f.Bar:CreateTexture('Border', 'OVERLAY')
    border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiexperiencebar2x')
    border:SetTexCoord(0.00048828125, 0.55810546875, 0.78515625, 0.91796875)
    local dx, dy = 6, 5
    border:SetSize(size + dx, 20 + dy)
    border:SetPoint('CENTER', f.Bar, 'CENTER', 1, -2)
    f.Border = border

    -- text
    local Path, Size, Flags = MainMenuBarExpText:GetFont()
    f.Text = f.Bar:CreateFontString('Text', 'OVERLAY', 'TextStatusBarText')
    f.Text:SetFont(Path, 12, Flags)
    f.Text:SetText('')
    f.Text:SetPoint('CENTER', 0, 1)

    frame.RepBar = f

    frame.RepBar.Bar:SetMinMaxValues(0, 125)
    frame.RepBar.Bar:SetValue(69)

    frame.RepBar.valid = false

    frame.UpdateRepBar = function()
        local name, standing, min, max, value = GetWatchedFactionInfo()
        if name then
            --frame.RepBar:Show()
            frame.RepBar.valid = true
            frame.RepBar.Text:SetText(name .. ' ' .. (value - min) .. ' / ' .. (max - min))
            frame.RepBar.Bar:SetMinMaxValues(0, max - min)
            frame.RepBar.Bar:SetValue(value - min)

            local color = FACTION_BAR_COLORS[standing]
            frame.RepBar.Bar:SetStatusBarColor(color.r, color.g, color.b)
        else
            --frame.RepBar:Hide()
            frame.RepBar.valid = false
        end
    end

    --frame:RegisterEvent('UPDATE_FACTION')
end
--CreateNewRepBar()

function StyleButtons()
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'

    local buttonTable = {
        'MultiBarBottomRightButton',
        'MultiBarBottomLeftButton',
        'ActionButton',
        'MultiBarLeftButton',
        'MultiBarRightButton'
    }
    for k, v in pairs(buttonTable) do
        for i = 1, 12 do
            --MultiBarBottomRightButton1NormalTexture
            local name = v .. i
            --print(name)

            _G[name .. 'NormalTexture']:SetTexture(textureRef)
            _G[name .. 'NormalTexture']:SetTexCoord(0.701171875, 0.880859375, 0.31689453125, 0.36083984375)
            _G[name .. 'NormalTexture']:SetSize(38, 38)
            _G[name .. 'NormalTexture']:SetPoint('CENTER', 0.5, -0.5)
            _G[name .. 'NormalTexture']:SetAlpha(1)

            -- Border
            -- _G[name .. 'Border']:SetTexture()
            -- _G[name .. 'Border']:SetTexCoord(0.701171875, 0.880859375, 0.36181640625, 0.40576171875)
            -- _G[name .. 'Border']:SetSize(45, 45)

            -- Highlight
            _G[name]:SetHighlightTexture(textureRef)
            _G[name]:GetHighlightTexture():SetTexCoord(0.701171875, 0.880859375, 0.52001953125, 0.56396484375)
            --_G[name]:GetHighlightTexture():SetSize(55, 25)

            -- Pressed
            _G[name]:SetPushedTexture(textureRef)
            _G[name]:GetPushedTexture():SetTexCoord(0.701171875, 0.880859375, 0.43017578125, 0.47412109375)

            -- Background
            if _G[name .. 'FloatingBG'] then
                _G[name .. 'FloatingBG']:SetTexture()
                _G[name .. 'FloatingBG']:SetTexCoord(0, 0, 0, 0)
                _G[name .. 'FloatingBG']:SetSize(45, 45)
            end
            -- Mask
            if _G[name .. 'Icon'] then
            -- _G[name .. 'Icon']:SetMask('Interface\\Addons\\DragonflightUI\\Textures\\mask3')
            end
            --_G[name .. 'Icon']:SetMask('Interface\\Addons\\DragonflightUI\\Textures\\mask3')
        end
    end
end
--StyleButtons()

function StylePageNumber()
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'

    -- actionbar switch buttons
    ActionBarUpButton:GetNormalTexture():SetTexture(textureRef)
    ActionBarUpButton:GetNormalTexture():SetTexCoord(0.701171875, 0.767578125, 0.40673828125, 0.42041015625)
    ActionBarUpButton:GetHighlightTexture():SetTexture(textureRef)
    ActionBarUpButton:GetHighlightTexture():SetTexCoord(0.884765625, 0.951171875, 0.34619140625, 0.35986328125)
    ActionBarUpButton:GetPushedTexture():SetTexture(textureRef)
    ActionBarUpButton:GetPushedTexture():SetTexCoord(0.884765625, 0.951171875, 0.33154296875, 0.34521484375)

    ActionBarDownButton:GetNormalTexture():SetTexture(textureRef)
    ActionBarDownButton:GetNormalTexture():SetTexCoord(0.904296875, 0.970703125, 0.29541015625, 0.30908203125)
    ActionBarDownButton:GetHighlightTexture():SetTexture(textureRef)
    ActionBarDownButton:GetHighlightTexture():SetTexCoord(0.904296875, 0.970703125, 0.28076171875, 0.29443359375)
    ActionBarDownButton:GetPushedTexture():SetTexture(textureRef)
    ActionBarDownButton:GetPushedTexture():SetTexCoord(0.904296875, 0.970703125, 0.26611328125, 0.27978515625)

    -- gryphon = 100
    local buttonScale = 0.42
    ActionBarUpButton:SetFrameStrata('HIGH')
    ActionBarUpButton:SetFrameLevel(105)
    ActionBarUpButton:SetScale(buttonScale)
    ActionBarDownButton:SetFrameStrata('HIGH')
    ActionBarDownButton:SetFrameLevel(105)
    ActionBarDownButton:SetScale(buttonScale)
    --MainMenuBarPageNumber:SetFrameStrata('HIGH')

    -- MainMenuBarPageNumber:SetFrameLevel(105)
    local frameName = 'DragonflightUIPageNumberFrame'
    local f = CreateFrame('Frame', frameName, UIParent)
    f:SetSize(25, 25)
    f:SetPoint('CENTER', ActionButton1, 'CENTER')
    f:SetFrameStrata('HIGH')
    f:SetFrameLevel(105)

    MainMenuBarPageNumber:ClearAllPoints()
    MainMenuBarPageNumber:SetPoint('LEFT', _G[frameName], 'LEFT', -15.5, 0)
    MainMenuBarPageNumber:SetParent(_G[frameName])
    --MainMenuBarPageNumber:SetDrawLayer('OVERLAY')
    MainMenuBarPageNumber:SetScale(1.25)
end
--StylePageNumber()

function ApplyMask()
    local buttonTable = {
        'MultiBarBottomRightButton',
        'MultiBarBottomLeftButton',
        'ActionButton',
        'MultiBarLeftButton',
        'MultiBarRightButton'
    }
    frame.ButtonMask = frame:CreateMaskTexture()
    frame.ButtonMask:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\ui-chaticon-hots')
    frame.ButtonMask:SetTexture('Interface/ChatFrame/UI-ChatIcon-HotS')

    local f = CreateFrame('Frame', nil, UIParent)
    f:SetPoint('CENTER')
    f:SetSize(64, 64)

    for i = 1, 0 do
        local tex = f:CreateTexture()
        tex:SetAllPoints(f)
        tex:SetTexture('Interface/Icons/spell_shadow_antishadow')
        --  f.tex:SetMask('Interface/ChatFrame/UI-ChatIcon-HotS')
        tex:SetMask('Interface\\Addons\\DragonflightUI\\Textures\\mask3')
        tex:SetPoint('CENTER', f, 'CENTER', i, i)

        f['tex' .. i] = tex
    end

    for k, v in pairs(buttonTable) do
        for i = 1, 12 do
            --MultiBarBottomRightButton1NormalTexture
            local name = v .. i

            -- Mask
            local btn = _G[name]
            local icon = _G[name .. 'Icon']
            if icon then
                icon:SetAlpha(0.1)
                local tex = btn:CreateTexture()
                tex:SetPoint('CENTER', btn)
                local size = 36
                tex:SetSize(size, size)
                tex:SetMask('Interface\\Addons\\DragonflightUI\\Textures\\mask3')
                tex:SetDrawLayer('BACKGROUND')
                btn.DragonflightUIMaskTexture = tex

                hooksecurefunc(
                    icon,
                    'Show',
                    function(self)
                        local tex = self:GetTexture()
                        if tex then
                            btn.DragonflightUIMaskTexture:Show()
                            btn.DragonflightUIMaskTexture:SetTexture(tex)
                        end
                    end
                )
                hooksecurefunc(
                    icon,
                    'Hide',
                    function(self)
                        btn.DragonflightUIMaskTexture:Hide()
                    end
                )

                hooksecurefunc(
                    icon,
                    'SetVertexColor',
                    function(self)
                        --print('vertex')
                        local r, g, b = self:GetVertexColor()
                        btn.DragonflightUIMaskTexture:SetVertexColor(r, g, b)
                    end
                )
            end
        end
    end
end
--ApplyMask()

function ChangeButtonSpacing()
    local spacing = 3 -- default: 6
    local buttonTable = {'MultiBarBottomRightButton', 'MultiBarBottomLeftButton', 'ActionButton'}
    for k, v in pairs(buttonTable) do
        for i = 2, 12 do
            _G[v .. i]:SetPoint('LEFT', _G[v .. (i - 1)], 'RIGHT', spacing, 0)
        end
    end
end
--ChangeButtonSpacing()

function SetNumBars()
    local inLockdown = InCombatLockdown()
    if inLockdown then
        --return
        --print('[DragonflightUI] changing Frames after combat ends..')
    else
        local dy = 20
        local dRep, dButtons = 0, 0

        if frame.XPBar.valid then
            frame.XPBar:Show()
        else
            frame.XPBar:Hide()
            dRep = dRep + dy
            dButtons = dButtons + dy
        end
        if frame.RepBar.valid then
            frame.RepBar:Show()
        else
            frame.RepBar:Hide()
            dButtons = dButtons + dy
        end

        ActionButton1:SetPoint('CENTER', MainMenuBar, 'CENTER', -230 + 3 * 5.5, 30 + 18 - dButtons)
        frame.XPBar:SetPoint('BOTTOM', 0, 5)
        frame.RepBar:SetPoint('BOTTOM', 0, 5 + 20 - dRep)
    end
end
-- frame.UpdateXPBar()
-- frame.UpdateRepBar()
-- SetNumBars()

function GetPetbarOffset()
    local localizedClass, englishClass, classIndex = UnitClass('player')

    -- 1=warrior, 2=paladin, 5=priest, 6=DK, 11=druid
    if (classIndex == 1 or classIndex == 2 or classIndex == 5 or classIndex == 6 or classIndex == 11) then
        return 34
    else
        return 0
    end
end

function HookPetBar()
    PetActionBarFrame:ClearAllPoints()
    PetActionBarFrame:SetPoint('CENTER', MultiBarBottomRight, 'CENTER', 0, 45)

    frame:RegisterEvent('PET_BAR_UPDATE')

    for i = 1, 10 do
        _G['PetActionButton' .. i]:SetSize(30, 30)
        _G['PetActionButton' .. i .. 'NormalTexture2']:SetSize(50, 50)
    end

    local spacing = 7 -- default: 8
    for i = 2, 10 do
        _G['PetActionButton' .. i]:SetPoint('LEFT', _G['PetActionButton' .. (i - 1)], 'RIGHT', spacing, 0)
    end

    -- different offset for each class (stance vs no stance)
    --local offset = 0 + 34
    local offset = GetPetbarOffset()
    PetActionButton1:SetPoint('BOTTOMLEFT', MultiBarBottomRight, 'TOPLEFT', 0.5, 4 + offset)
end
--HookPetBar()

--frame:RegisterEvent('PLAYER_REGEN_ENABLED')

function MoveSideBars()
    -- left
    local gap = 3
    local dx = 220
    _G['MultiBarLeftButton1']:ClearAllPoints()
    _G['MultiBarLeftButton1']:SetPoint('LEFT', ActionButton1, 'LEFT', -dx, 80)

    for i = 2, 4 do
        _G['MultiBarLeftButton' .. i]:ClearAllPoints()
        _G['MultiBarLeftButton' .. i]:SetPoint('LEFT', _G['MultiBarLeftButton' .. (i - 1)], 'RIGHT', gap, 0)
    end

    _G['MultiBarLeftButton5']:ClearAllPoints()
    _G['MultiBarLeftButton5']:SetPoint('LEFT', ActionButton1, 'LEFT', -dx, 40)
    for i = 6, 8 do
        _G['MultiBarLeftButton' .. i]:ClearAllPoints()
        _G['MultiBarLeftButton' .. i]:SetPoint('LEFT', _G['MultiBarLeftButton' .. (i - 1)], 'RIGHT', gap, 0)
    end

    _G['MultiBarLeftButton9']:ClearAllPoints()
    _G['MultiBarLeftButton9']:SetPoint('LEFT', ActionButton1, 'LEFT', -dx, 0)
    for i = 10, 12 do
        _G['MultiBarLeftButton' .. i]:ClearAllPoints()
        _G['MultiBarLeftButton' .. i]:SetPoint('LEFT', _G['MultiBarLeftButton' .. (i - 1)], 'RIGHT', gap, 0)
    end

    -- right
    local dxRight = dx - 4 * 36 - 3 * gap
    _G['MultiBarRightButton1']:ClearAllPoints()
    _G['MultiBarRightButton1']:SetPoint('LEFT', ActionButton12, 'RIGHT', dxRight, 80)

    for i = 2, 4 do
        _G['MultiBarRightButton' .. i]:ClearAllPoints()
        _G['MultiBarRightButton' .. i]:SetPoint('LEFT', _G['MultiBarRightButton' .. (i - 1)], 'RIGHT', gap, 0)
    end

    _G['MultiBarRightButton5']:ClearAllPoints()
    _G['MultiBarRightButton5']:SetPoint('LEFT', ActionButton12, 'RIGHT', dxRight, 40)
    for i = 6, 8 do
        _G['MultiBarRightButton' .. i]:ClearAllPoints()
        _G['MultiBarRightButton' .. i]:SetPoint('LEFT', _G['MultiBarRightButton' .. (i - 1)], 'RIGHT', gap, 0)
    end

    _G['MultiBarRightButton9']:ClearAllPoints()
    _G['MultiBarRightButton9']:SetPoint('LEFT', ActionButton12, 'RIGHT', dxRight, 0)
    for i = 10, 12 do
        _G['MultiBarRightButton' .. i]:ClearAllPoints()
        _G['MultiBarRightButton' .. i]:SetPoint('LEFT', _G['MultiBarRightButton' .. (i - 1)], 'RIGHT', gap, 0)
    end
end

function ActionbarModule()
    ChangeActionbar()
    CreateNewXPBar()
    CreateNewRepBar()
    StyleButtons()
    StylePageNumber()
    ApplyMask()
    ChangeButtonSpacing()
    frame.UpdateXPBar()
    frame.UpdateRepBar()
    SetNumBars()
    HookPetBar()

    frame:RegisterEvent('PLAYER_REGEN_ENABLED')

    Core.Sub.Artframe()
    Core.Sub.Micromenu()
end

function ActionbarSideModule()
    MoveSideBars()
end

Core.RegisterModule(Module, {}, {}, true, ActionbarModule)
Core.RegisterModule(Module .. 'Side', {}, {}, true, ActionbarSideModule)

function frame:OnEvent(event, arg1)
    --print('event', event)
    if event == 'PLAYER_ENTERING_WORLD' then
        frame.UpdateXPBar()
        frame.UpdateRepBar()
        SetNumBars()
        frame:RegisterEvent('UPDATE_FACTION')
    elseif event == 'UPDATE_FACTION' then
        frame.UpdateRepBar()
        SetNumBars()
    elseif event == 'PLAYER_XP_UPDATE' then
        frame.UpdateXPBar()
        SetNumBars()
    elseif event == 'UPDATE_EXHAUSTION' then
        frame.UpdateXPBar()
        SetNumBars()
    elseif event == 'PLAYER_REGEN_ENABLED' then
        frame.UpdateXPBar()
        frame.UpdateRepBar()
        SetNumBars()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)
