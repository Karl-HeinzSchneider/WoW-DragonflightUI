print('Actionbar.lua')

function ChangeActionbar()
    ActionButton1:ClearAllPoints()
    ActionButton1:SetPoint('CENTER', MainMenuBar, 'CENTER', -230, 42 + 25)
    ActionButton1.SetPoint = function()
    end

    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetPoint('LEFT', ActionButton1, 'LEFT', 0, 45)
    MultiBarBottomLeft.SetPoint = function()
    end

    MultiBarBottomRight:ClearAllPoints()
    MultiBarBottomRight:SetPoint('LEFT', MultiBarBottomLeft, 'LEFT', 0, 45)
    MultiBarBottomRight.SetPoint = function()
    end

    StanceButton1:ClearAllPoints()
    StanceButton1:SetPoint('LEFT', MultiBarBottomLeft, 'LEFT', 0, 42)
    StanceButton1.SetPoint = function()
    end

    PetActionBarFrame:ClearAllPoints()
    PetActionBarFrame:SetPoint('CENTER', MultiBarBottomLeft, 'CENTER', 30, 90)
    PetActionBarFrame.SetPoint = function()
    end

    ActionBarUpButton:ClearAllPoints()
    ActionBarUpButton:SetPoint('LEFT', MultiBarBottomLeft, 'TOPLEFT', -40, -5)
    ActionBarDownButton:ClearAllPoints()
    ActionBarDownButton:SetPoint('LEFT', MultiBarBottomLeft, 'BOTTOMLEFT', -40, 5)

    MainMenuBarPageNumber:ClearAllPoints()
    MainMenuBarPageNumber:SetPoint('LEFT', MultiBarBottomLeft, 'LEFT', -50, 0)
end
ChangeActionbar()

function ChangeExp()
    local expTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\uiexperiencebar2x'

    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetPoint('CENTER', UIParent, 'BOTTOM', 0, 20)
    MainMenuExpBar:SetSize(500, 10)
    MainMenuExpBar:SetScale(1)

    MainMenuXPBarTexture0:ClearAllPoints()
    MainMenuXPBarTexture0:SetPoint('CENTER', MainMenuExpBar, 'CENTER', 2, -2.5)
    MainMenuXPBarTexture0:SetSize(500 + 8, 20)
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
end
ChangeExp()

function ChangeRep()
    local expTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\uiexperiencebar2x'
    local bottomDelta = 35
    MainMenuBar:SetPoint('CENTER', UIParent, 'BOTTOM', 0, bottomDelta)
    MainMenuBar:SetPoint('TOPLEFT', UIParent, 'BOTTOM', 0, bottomDelta)
    MainMenuBar:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOM', 0, bottomDelta)

    local targetSize = 500
    local scale = 10 / 7

    --print(ReputationWatchBar.StatusBar:GetSize())
    ReputationWatchBar.StatusBar:SetSize(targetSize / scale, 10)
    --print(ReputationWatchBar.StatusBar:GetSize())
    ReputationWatchBar.StatusBar:SetScale(scale)
    ReputationWatchBar.OverlayFrame:SetSize(500, 10)

    ReputationWatchBar.StatusBar.WatchBarTexture1:Hide()
    ReputationWatchBar.StatusBar.WatchBarTexture2:Hide()
    ReputationWatchBar.StatusBar.WatchBarTexture3:Hide()
    ReputationWatchBar.StatusBar.WatchBarTexture1:SetTexture()
    ReputationWatchBar.StatusBar.WatchBarTexture2:SetTexture()
    ReputationWatchBar.StatusBar.WatchBarTexture3:SetTexture()

    -- border
    ReputationWatchBar.StatusBar.WatchBarTexture0:ClearAllPoints()
    ReputationWatchBar.StatusBar.WatchBarTexture0:SetPoint('CENTER', ReputationWatchBar.StatusBar, 'CENTER', 2, -2.5)
    ReputationWatchBar.StatusBar.WatchBarTexture0:SetSize(500 + 8, 20)
    ReputationWatchBar.StatusBar.WatchBarTexture0:SetScale(0.7)
    ReputationWatchBar.StatusBar.WatchBarTexture0:SetTexture(expTexture)
    ReputationWatchBar.StatusBar.WatchBarTexture0:SetTexCoord(0.00048828125, 0.55810546875, 0.78515625, 0.91796875)

    --ReputationWatchBar.OverlayFrame.Text
    local Path, Size, Flags = MainMenuBarExpText:GetFont()
    --print(Path, Size, Flags)
    ReputationWatchBar.OverlayFrame.Text:SetFont(Path, 12, Flags)
    ReputationWatchBar.OverlayFrame.Text:ClearAllPoints()
    ReputationWatchBar.OverlayFrame.Text:SetPoint('CENTER', ReputationWatchBar.OverlayFrame, 0, 0)
end
ChangeRep()

function StyleButtons()
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'

    local buttonTable = {'MultiBarBottomRightButton'}
    for k, v in pairs(buttonTable) do
        for i = 1, 12 do
            --MultiBarBottomRightButton1NormalTexture
            local name = v .. i

            _G[name .. 'NormalTexture']:SetTexture(textureRef)
            _G[name .. 'NormalTexture']:SetTexCoord(0.701171875, 0.900390625, 0.21533203125, 0.26513671875)
            _G[name .. 'NormalTexture']:SetSize(37, 44)

            -- Border
            _G[name .. 'Border']:SetTexture()
            _G[name .. 'Border']:SetTexCoord(0.701171875, 0.880859375, 0.36181640625, 0.40576171875)
            _G[name .. 'Border']:SetSize(45, 45)

            -- Highlight
            _G[name]:SetHighlightTexture(textureRef)
            _G[name]:GetHighlightTexture():SetTexCoord(0.701171875, 0.880859375, 0.52001953125, 0.56396484375)
            --_G[name]:GetHighlightTexture():SetSize(55, 25)

            -- Background
            _G[name .. 'FloatingBG']:SetTexture()
            _G[name .. 'FloatingBG']:SetTexCoord(0, 0, 0, 0)
            _G[name .. 'FloatingBG']:SetSize(45, 45)
        end
    end
end
StyleButtons()

print('Actionbar.lua - End')
