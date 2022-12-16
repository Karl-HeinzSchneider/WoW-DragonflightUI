print('Actionbar.lua')

local frame = CreateFrame('FRAME', 'DragonflightUIActionbarFrame', UIParent)
frame:SetFrameStrata('HIGH')

function ChangeActionbar()
    ActionButton1:ClearAllPoints()
    --ActionButton1:SetPoint('CENTER', MainMenuBar, 'CENTER', -230 + 3 * 5.5, 42 + 25)
    ActionButton1:SetPoint('CENTER', MainMenuBar, 'CENTER', -230 + 3 * 5.5, 30 + 25)
    ActionButton1.SetPoint = function()
    end

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
end
ChangeActionbar()

function ChangeExp()
    local expTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\uiexperiencebar2x'
    local size = 460 -- 500
    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetPoint('CENTER', UIParent, 'BOTTOM', 0, 12)
    MainMenuExpBar:SetSize(size, 10)
    MainMenuExpBar:SetScale(1)

    MainMenuXPBarTexture0:ClearAllPoints()
    MainMenuXPBarTexture0:SetPoint('CENTER', MainMenuExpBar, 'CENTER', 2, -2.5)
    MainMenuXPBarTexture0:SetSize(size + 8, 20)
    MainMenuXPBarTexture0:SetTexture(expTexture)
    MainMenuXPBarTexture0:SetTexCoord(0.00048828125, 0.55810546875, 0.78515625, 0.91796875)

    local Path, Size, Flags = MainMenuBarExpText:GetFont()
    MainMenuBarExpText:SetFont(Path, 12, Flags)
    MainMenuBarExpText:ClearAllPoints()
    MainMenuBarExpText:SetPoint('CENTER', MainMenuExpBar, 'CENTER', 0, 0)

    MainMenuXPBarTexture1:Hide()
    MainMenuXPBarTexture2:Hide()
    MainMenuXPBarTexture3:Hide()

    ExhaustionTick:SetNormalTexture(expTexture)
    ExhaustionTick:GetNormalTexture():SetTexCoord(0.57177734375, 0.58154296875, 0.78515625, 0.89453125)
    ExhaustionTick:SetHighlightTexture(expTexture)
    ExhaustionTick:GetHighlightTexture():SetTexCoord(0.55908203125, 0.57080078125, 0.78515625, 0.89453125)
    local scaling = 1.2
    ExhaustionTick:SetSize(12 * scaling, 14 * scaling)

    MainMenuMaxLevelBar0:SetTexture('')
    MainMenuMaxLevelBar1:SetTexture('')
    MainMenuMaxLevelBar2:SetTexture('')
    MainMenuMaxLevelBar3:SetTexture('')

    hooksecurefunc(
        MainMenuMaxLevelBar0,
        'Show',
        function(self)
            print('show maxlvl')
        end
    )
end
ChangeExp()

function NewExpText()
    -- hide default
    hooksecurefunc(
        MainMenuBarExpText,
        'SetText',
        function(self)
            MainMenuBarExpText:Hide()
        end
    )

    local Path, Size, Flags = MainMenuBarExpText:GetFont()
    frame.ExpText = frame:CreateFontString(nil, 'ARTWORK', 'TextStatusBarText')
    frame.ExpText:SetFont(Path, 12, Flags)
    frame.ExpText:SetText('')
    frame.ExpText:SetPoint('CENTER', MainMenuExpBar, 'CENTER', 0, 0)

    frame.UpdateExpText = function()
        local newLevel = UnitLevel('player')
        local showXP = newLevel < GetMaxPlayerLevel() and not IsXPUserDisabled()
        if showXP then
            local XP = UnitXP('player')
            local XPMax = UnitXPMax('player')
            frame.ExpText:SetText('XP: ' .. XP .. '/' .. XPMax)
        else
            frame.ExpText:SetText('')
        end
    end
    frame.UpdateExpText()
    frame:RegisterEvent('PLAYER_XP_UPDATE')
end
NewExpText()

function ChangeRep()
    local expTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\uiexperiencebar2x'
    local bottomDelta = 27
    MainMenuBar:SetPoint('CENTER', UIParent, 'BOTTOM', 0, bottomDelta)
    MainMenuBar:SetPoint('TOPLEFT', UIParent, 'BOTTOM', 0, bottomDelta)
    MainMenuBar:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOM', 0, bottomDelta)

    local targetSize = 500
    local scale = 10 / 7

    local size = 460 -- 500

    --print(ReputationWatchBar.StatusBar:GetSize())
    ReputationWatchBar.StatusBar:SetSize(size / scale, 10)
    --print(ReputationWatchBar.StatusBar:GetSize())
    ReputationWatchBar.StatusBar:SetScale(scale)
    ReputationWatchBar.OverlayFrame:SetSize(size, 10)

    ReputationWatchBar.StatusBar.WatchBarTexture1:Hide()
    ReputationWatchBar.StatusBar.WatchBarTexture2:Hide()
    ReputationWatchBar.StatusBar.WatchBarTexture3:Hide()
    ReputationWatchBar.StatusBar.WatchBarTexture1:SetTexture()
    ReputationWatchBar.StatusBar.WatchBarTexture2:SetTexture()
    ReputationWatchBar.StatusBar.WatchBarTexture3:SetTexture()

    -- border
    ReputationWatchBar.StatusBar.WatchBarTexture0:ClearAllPoints()
    ReputationWatchBar.StatusBar.WatchBarTexture0:SetPoint('CENTER', ReputationWatchBar.StatusBar, 'CENTER', 2, -2.5)
    ReputationWatchBar.StatusBar.WatchBarTexture0:SetSize(size + 8, 20)
    ReputationWatchBar.StatusBar.WatchBarTexture0:SetScale(0.7)
    ReputationWatchBar.StatusBar.WatchBarTexture0:SetTexture(expTexture)
    ReputationWatchBar.StatusBar.WatchBarTexture0:SetTexCoord(0.00048828125, 0.55810546875, 0.78515625, 0.91796875)

    --ReputationWatchBar.OverlayFrame.Text
    local Path, Size, Flags = MainMenuBarExpText:GetFont()
    --print(Path, Size, Flags)
    ReputationWatchBar.OverlayFrame.Text:SetFont(Path, 12, Flags)
    ReputationWatchBar.OverlayFrame.Text:ClearAllPoints()
    ReputationWatchBar.OverlayFrame.Text:SetPoint('CENTER', ReputationWatchBar.OverlayFrame, 0, 0)

    -- max level
    --ReputationWatchBar.StatusBar.XPBarTexture0:Hide()
    ReputationWatchBar.StatusBar.XPBarTexture1:Hide()
    ReputationWatchBar.StatusBar.XPBarTexture2:Hide()
    --ReputationWatchBar.StatusBar.XPBarTexture0:SetTexture()
    ReputationWatchBar.StatusBar.XPBarTexture1:SetTexture()
    ReputationWatchBar.StatusBar.XPBarTexture2:SetTexture()

    ReputationWatchBar.StatusBar.XPBarTexture0:ClearAllPoints()
    ReputationWatchBar.StatusBar.XPBarTexture0:SetPoint('CENTER', ReputationWatchBar.StatusBar, 'CENTER', 2, -2.5)
    ReputationWatchBar.StatusBar.XPBarTexture0:SetSize(size + 8, 20)
    ReputationWatchBar.StatusBar.XPBarTexture0:SetScale(0.7)
    ReputationWatchBar.StatusBar.XPBarTexture0:SetTexture(expTexture)
    ReputationWatchBar.StatusBar.XPBarTexture0:SetTexCoord(0.00048828125, 0.55810546875, 0.78515625, 0.91796875)
end
ChangeRep()

function NewRepText()
    -- hide default
    hooksecurefunc(
        ReputationWatchBar.OverlayFrame.Text,
        'SetText',
        function(self)
            ReputationWatchBar.OverlayFrame.Text:Hide()
        end
    )

    local Path, Size, Flags = MainMenuBarExpText:GetFont()
    frame.RepText = frame:CreateFontString(nil, 'ARTWORK', 'TextStatusBarText')
    frame.RepText:SetFont(Path, 12, Flags)
    frame.RepText:SetText('HALLLOOOOO')
    frame.RepText:SetPoint('CENTER', ReputationWatchBar, 'CENTER', 0, 0)

    frame.UpdateRepText = function()
        local name, standing, min, max, value = GetWatchedFactionInfo()
        if name then
            ReputationWatchBar.OverlayFrame.Text:SetText('')
            frame.RepText:SetText(name .. ' ' .. (value - min) .. ' / ' .. (max - min))
        else
            frame.RepText:SetText('')
        end
    end
    frame.UpdateRepText()
    frame:RegisterEvent('UPDATE_FACTION')

    hooksecurefunc(
        'SetWatchedFactionIndex',
        function(index)
            --print('SetWatchedFactionIndex', index)
            frame.UpdateRepText()
        end
    )
end
--NewRepText()

function CreateNewXPBar()
    local f = CreateFrame('Frame', 'DragonflightUIXPBar', UIParent)
    f:SetSize(460, 14)
    f:SetPoint('CENTER')

    local tex = f:CreateTexture('ARTWORK')
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
    local border = f.Bar:CreateTexture('OVERLAY')
    border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiexperiencebar2x')
    border:SetTexCoord(0.00048828125, 0.55810546875, 0.78515625, 0.91796875)
    local dx, dy = 6, 5
    border:SetSize(460 + dx, 20 + dy)
    border:SetPoint('CENTER', f.Bar, 'CENTER', 1, -2)
    f.Border = border

    -- text
    local Path, Size, Flags = MainMenuBarExpText:GetFont()
    f.Text = f.Bar:CreateFontString(nil, 'ARTWORK', 'TextStatusBarText')
    f.Text:SetFont(Path, 12, Flags)
    f.Text:SetText('')
    f.Text:SetPoint('CENTER', f.bar, 'CENTER', 0, 0)

    frame.XPBar = f

    frame.UpdateXPBar = function()
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
    end

    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
    frame:RegisterEvent('UPDATE_EXHAUSTION')
end
CreateNewXPBar()

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

function frame:OnEvent(event, arg1)
    if event == 'PLAYER_XP_UPDATE' then
        frame.UpdateXPBar()
    elseif event == 'UPDATE_FACTION' then
        frame.UpdateRepText()
    elseif ((event == 'PLAYER_ENTERING_WORLD') or (event == 'UPDATE_EXHAUSTION')) then
        frame.UpdateXPBar()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)

print('Actionbar.lua - End')
