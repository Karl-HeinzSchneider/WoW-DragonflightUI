print('Actionbar.lua')

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
    StanceButton1:SetPoint('LEFT', MultiBarBottomLeft, 'LEFT', 0, 77)
    StanceButton1.SetPoint = function()
    end

    PetActionBarFrame:ClearAllPoints()
    PetActionBarFrame:SetPoint('CENTER', MultiBarBottomLeft, 'CENTER', 30, 90)
    PetActionBarFrame.SetPoint = function()
    end

    ActionBarUpButton:ClearAllPoints()
    ActionBarUpButton:SetPoint('LEFT', ActionButton1, 'TOPLEFT', -40, -8)
    ActionBarDownButton:ClearAllPoints()
    ActionBarDownButton:SetPoint('LEFT', ActionButton1, 'BOTTOMLEFT', -40, 5)

    --MainMenuBarPageNumber:ClearAllPoints()
    --MainMenuBarPageNumber:SetPoint('LEFT', MultiBarBottomRight, 'LEFT', -50, 0)
    MainMenuExpBar:Hide()
    hooksecurefunc(
        MainMenuExpBar,
        'Show',
        function()
            MainMenuExpBar:Hide()
        end
    )
    ReputationWatchBar:Hide()
    hooksecurefunc(
        ReputationWatchBar,
        'Show',
        function()
            ReputationWatchBar:Hide()
        end
    )
    MainMenuBarMaxLevelBar:Hide()
    hooksecurefunc(
        MainMenuBarMaxLevelBar,
        'Show',
        function()
            MainMenuBarMaxLevelBar:Hide()
        end
    )
end
ChangeActionbar()

function CreateNewXPBar()
    local size = 460
    local f = CreateFrame('Frame', 'DragonflightUIXPBar', UIParent)
    f:SetSize(size, 14)
    f:SetPoint('BOTTOM', 0, 5)

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
    f.Text:ClearAllPoints()
    f.Text:SetParent(f.Bar)
    f.Text:SetPoint('CENTER', 0, 1)

    frame.XPBar = f

    frame.UpdateXPBar = function()
        local showXP = UnitLevel('player') < GetMaxPlayerLevel() and not IsXPUserDisabled()
        if showXP then
            -- exhaustion
            local exhaustionStateID = GetRestState()
            if (exhaustionStateID == 1) then
                frame.XPBar.Bar:SetStatusBarColor(0.0, 0.39, 0.88, 1.0)
            elseif (exhaustionStateID == 2) then
                frame.XPBar.Bar:SetStatusBarColor(0.58, 0.0, 0.55, 1.0) -- purple
            end

            -- value
            local playerCurrXP = UnitXP('player')
            local playerMaxXP = UnitXPMax('player')
            frame.XPBar.Bar:SetMinMaxValues(0, playerMaxXP)
            frame.XPBar.Bar:SetValue(playerCurrXP)

            frame.XPBar.Text:SetText('XP: ' .. playerCurrXP .. '/' .. playerMaxXP)
            frame.XPBar:Show()
        else
            frame.XPBar:Hide()
        end
    end

    frame:RegisterEvent('PLAYER_XP_UPDATE')
    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
    frame:RegisterEvent('UPDATE_EXHAUSTION')
end
CreateNewXPBar()

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

    frame.UpdateRepBar = function()
        local name, standing, min, max, value = GetWatchedFactionInfo()
        if name then
            frame.RepBar:Show()
            frame.RepBar.Text:SetText(name .. ' ' .. (value - min) .. ' / ' .. (max - min))
            frame.RepBar.Bar:SetMinMaxValues(0, max - min)
            frame.RepBar.Bar:SetValue(value - min)

            local color = FACTION_BAR_COLORS[standing]
            frame.RepBar.Bar:SetStatusBarColor(color.r, color.g, color.b)
        else
            frame.RepBar:Hide()
        end
    end

    frame:RegisterEvent('UPDATE_FACTION')
end
CreateNewRepBar()

function StyleButtons()
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'

    local buttonTable = {'MultiBarBottomRightButton', 'MultiBarBottomLeftButton', 'ActionButton'}
    for k, v in pairs(buttonTable) do
        for i = 1, 12 do
            --MultiBarBottomRightButton1NormalTexture
            local name = v .. i

            _G[name .. 'NormalTexture']:SetTexture(textureRef)
            _G[name .. 'NormalTexture']:SetTexCoord(0.701171875, 0.880859375, 0.31689453125, 0.36083984375)
            _G[name .. 'NormalTexture']:SetSize(38, 38)
            _G[name .. 'NormalTexture']:SetPoint('CENTER', 0.5, -0.5)
            _G[name .. 'NormalTexture']:SetAlpha(1)

            -- Border
            _G[name .. 'Border']:SetTexture()
            _G[name .. 'Border']:SetTexCoord(0.701171875, 0.880859375, 0.36181640625, 0.40576171875)
            _G[name .. 'Border']:SetSize(45, 45)

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
            _G[name .. 'Icon']:SetMask('Interface\\Addons\\DragonflightUI\\Textures\\mask3')
        end
    end

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
    ActionBarUpButton:SetFrameStrata('HIGH')
    ActionBarUpButton:SetFrameLevel(105)
    ActionBarUpButton:SetScale(0.5)
    ActionBarDownButton:SetFrameStrata('HIGH')
    ActionBarDownButton:SetFrameLevel(105)
    ActionBarDownButton:SetScale(0.5)
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
    MainMenuBarPageNumber:SetScale(1.5)
end
StyleButtons()

function ChangeButtonSpacing()
    local spacing = 3 -- default: 6
    local buttonTable = {'MultiBarBottomRightButton', 'MultiBarBottomLeftButton', 'ActionButton'}
    for k, v in pairs(buttonTable) do
        for i = 2, 12 do
            _G[v .. i]:SetPoint('LEFT', _G[v .. (i - 1)], 'RIGHT', spacing, 0)
        end
    end
end
ChangeButtonSpacing()

function SetNumBars()
    local i = 0
    if frame.RepBar:IsVisible() then
        i = i + 1
    end
    if frame.XPBar:IsVisible() then
        i = i + 1
    end
    --print('SetNumBars', i)

    if true then
        return
    end

    local dy = 20
    if i == 2 then
        --ActionButton1:ClearAllPoints()
        ActionButton1:SetPoint('CENTER', MainMenuBar, 'CENTER', -230 + 3 * 5.5, 30 + 18)
    elseif i == 1 then
        --ActionButton1:ClearAllPoints()
        ActionButton1:SetPoint('CENTER', MainMenuBar, 'CENTER', -230 + 3 * 5.5, 30 + 18 - dy)
    else
        --ActionButton1:ClearAllPoints()
        ActionButton1:SetPoint('CENTER', MainMenuBar, 'CENTER', -230 + 3 * 5.5, 30 + 18 - 2 * dy)
    end
end

function frame:OnEvent(event, arg1)
    --print('event', event)
    if event == 'PLAYER_ENTERING_WORLD' then
        frame.UpdateXPBar()
        frame.UpdateRepBar()
        SetNumBars()
    elseif event == 'UPDATE_FACTION' then
        frame.UpdateRepBar()
        SetNumBars()
    elseif event == 'PLAYER_XP_UPDATE' then
        frame.UpdateXPBar()
        SetNumBars()
    elseif event == 'UPDATE_EXHAUSTION' then
        frame.UpdateXPBar()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)

print('Actionbar.lua - End')
