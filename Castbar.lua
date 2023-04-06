local Addon, Core = ...
local Module = 'Castbar'

local noop = function()
end

local frame = CreateFrame('FRAME', 'DragonflightUICastbarFrame', UIParent)

function ChangeCastbar()
    CastingBarFrame.Text:Hide()
    CastingBarFrame:GetStatusBarTexture():SetVertexColor(0, 0, 0, 0)
    CastingBarFrame:GetStatusBarTexture():SetAlpha(0)
    -- CastingBarFrame.Spark:Hide()
end

function CreateNewCastbar()
    local standardRef = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarStandard2'
    local borderRef = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarFrame2'
    local backgroundRef = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarBackground2'
    local sparkRef = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarSpark'

    local sizeX = 250
    local sizeY = 20
    local f = CreateFrame('Frame', 'DragonflightUICastBar', CastingBarFrame)
    f:SetSize(sizeX, sizeY)
    f:SetPoint('CENTER', UIParent, 'BOTTOM', 0, 230)

    local tex = f:CreateTexture('Background', 'ARTWORK')
    tex:SetAllPoints()
    tex:SetTexture(backgroundRef)
    f.Background = tex

    -- actual status bar, child of parent above
    f.Bar = CreateFrame('StatusBar', nil, f)
    f.Bar:SetStatusBarTexture(standardRef)
    f.Bar:SetPoint('TOPLEFT', 0, 0)
    f.Bar:SetPoint('BOTTOMRIGHT', 0, 0)

    f.Bar:SetMinMaxValues(0, 100)
    f.Bar:SetValue(50)

    frame.Castbar = f

    local UpdateCastBarValues = function(other)
        local value = other:GetValue()
        local statusMin, statusMax = other:GetMinMaxValues()

        frame.Castbar.Bar:SetValue(value)
        frame.Castbar.Bar:SetMinMaxValues(statusMin, statusMax)
    end

    local border = f.Bar:CreateTexture('Border', 'OVERLAY')
    border:SetTexture(borderRef)
    local dx, dy = 2, 4
    border:SetSize(sizeX + dx, sizeY + dy)
    border:SetPoint('CENTER', f.Bar, 'CENTER', 0, 0)
    f.Border = border

    local spark = f.Bar:CreateTexture('Spark', 'OVERLAY')
    spark:SetTexture(sparkRef)
    spark:SetSize(20, 32)
    spark:SetPoint('CENTER', f.Bar, 'CENTER', 0, 0)
    spark:SetBlendMode('ADD')
    f.Spark = spark

    local UpdateSpark = function(other)
        local value = other:GetValue()
        local statusMin, statusMax = other:GetMinMaxValues()
        local percent = value / statusMax
        if percent == 1 then
            f.Spark:Hide()
        else
            f.Spark:Show()
            f.Spark:SetPoint('CENTER', f.Bar, 'LEFT', percent * sizeX, 0)
        end
    end

    CastingBarFrame:HookScript(
        'OnValueChanged',
        function(self)
            UpdateCastBarValues(self)
            UpdateSpark(self)
        end
    )
    CastingBarFrame:HookScript(
        'OnMinMaxChanged',
        function(self)
            UpdateCastBarValues(self)
        end
    )

    local bg = CreateFrame('Frame', 'DragonflightUICastbarNameBackground', CastingBarFrame)
    bg:SetSize(sizeX, sizeY)
    bg:SetPoint('TOP', f, 'BOTTOM', 0, 0)

    local bgTex = bg:CreateTexture('DragonflightUIMinimapTopBackground', 'ARTWORK')
    bgTex:ClearAllPoints()
    bgTex:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\MinimapBorder')
    bgTex:SetSize(sizeX, 30)
    bgTex:SetPoint('TOP', f, 'BOTTOM', 2, 2)

    bg.tex = bgTex
    f.Background = bg

    local text = bg:CreateFontString('DragonflightUICastbarText', 'OVERLAY', 'GameFontHighlight')
    text:SetText('12')
    text:SetPoint('TOP', f, 'BOTTOM', 0, -1)
    text:SetText('SHADOW BOLT')

    f.Text = text

    hooksecurefunc(
        CastingBarFrame.Text,
        'SetText',
        function(self)
            text:SetText(self:GetText())
        end
    )
end

function UpdateCastbarChanges()
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetPoint('CENTER', UIParent, 'BOTTOM', 0, -300)
    --CastingBarFrame:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 500)

    local standardRef = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarStandard2'
    frame.Castbar.Bar:SetStatusBarTexture(standardRef)
end

function Interrupted()
    local interruptedRef = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarInterrupted2'
    frame.Castbar.Bar:SetStatusBarTexture(interruptedRef)
end

function CastbarModule()
    frame:RegisterEvent('PLAYER_ENTERING_WORLD')

    frame:RegisterEvent('UNIT_SPELLCAST_INTERRUPTED')
    frame:RegisterEvent('UNIT_SPELLCAST_DELAYED')
    frame:RegisterEvent('UNIT_SPELLCAST_CHANNEL_START')
    frame:RegisterEvent('UNIT_SPELLCAST_CHANNEL_UPDATE')
    frame:RegisterEvent('UNIT_SPELLCAST_CHANNEL_STOP')

    frame:RegisterUnitEvent('UNIT_SPELLCAST_START', 'PLAYER')
    frame:RegisterUnitEvent('UNIT_SPELLCAST_STOP', 'PLAYER')
    frame:RegisterUnitEvent('UNIT_SPELLCAST_FAILED', 'PLAYER')
    print('CASTBAR MODULE')
    ChangeCastbar()
    CreateNewCastbar()
end

Core.RegisterModule(Module, {}, {}, false, CastbarModule)

function frame:OnEvent(event, arg1)
    --print('event', event, arg1)
    if event == 'PLAYER_ENTERING_WORLD' then
        UpdateCastbarChanges()
    elseif event == 'UNIT_SPELLCAST_INTERRUPTED' or event == 'UNIT_SPELLCAST_STOP' then
        Interrupted()
    else
        UpdateCastbarChanges()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)
