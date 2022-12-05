print('Actionbar.lua')

function ChangeActionbar()
    ActionButton1:ClearAllPoints()
    ActionButton1:SetPoint('CENTER', -230, 42)
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

function ChangeGryphon()
    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()
    --MainMenuBarArtFrame:Hide()
    MainMenuBarTexture0:Hide()
    MainMenuBarTexture1:Hide()
    MainMenuBarTexture2:Hide()
    MainMenuBarTexture3:Hide()
end
ChangeGryphon()

print('Actionbar.lua - End')
