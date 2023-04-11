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
        if statusMax == 0 then
            return
        end

        local percent = value / statusMax
        if percent == 1 then
            f.Spark:Hide()
        else
            --f.Spark:SetPoint('CENTER', f.Bar, 'LEFT', sizeX / 2, 0 + 15)
            f.Spark:Show()
            local dx = 2
            f.Spark:SetPoint('CENTER', f.Bar, 'LEFT', (value * sizeX) / statusMax, 0 + 15)
        end
    end

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
    text:SetText('SHADOW BOLT DEBUG')
    f.Text = text

    local textValueMax = bg:CreateFontString('DragonflightUICastbarText', 'OVERLAY', 'GameFontHighlight')
    textValueMax:SetPoint('TOP', f, 'BOTTOM', 0, -1)
    textValueMax:SetPoint('RIGHT', f.Background, 'RIGHT', -10, 0)
    textValueMax:SetText('/ 4.2')
    f.TextValueMax = textValueMax

    local textValue = bg:CreateFontString('DragonflightUICastbarText', 'OVERLAY', 'GameFontHighlight')
    textValue:SetPoint('RIGHT', f.TextValueMax, 'LEFT', 0, 0)
    textValue:SetText('0.69')
    f.TextValue = textValue

    local UpdateExtratext = function(other)
        local value = other:GetValue()
        local statusMin, statusMax = other:GetMinMaxValues()

        if value == statusMax then
            frame.Castbar.TextValue:SetText('')
            frame.Castbar.TextValueMax:SetText('')
        elseif frame.Castbar.bChanneling then
            f.TextValue:SetText(string.format('%.1f', value))
            f.TextValueMax:SetText(' / ' .. string.format('%.2f', statusMax))
        else
            f.TextValue:SetText(string.format('%.1f', statusMax - value))
            f.TextValueMax:SetText(' / ' .. string.format('%.2f', statusMax))
        end
    end

    --[[     hooksecurefunc(
        CastingBarFrame.Text,
        'SetText',
        function(self)
            --text:SetText(self:GetText())
        end
    ) ]]
    CastingBarFrame:HookScript(
        'OnValueChanged',
        function(self)
            UpdateCastBarValues(self)
            UpdateSpark(self)
            UpdateExtratext(self)
        end
    )
    CastingBarFrame:HookScript(
        'OnMinMaxChanged',
        function(self)
            UpdateCastBarValues(self)
        end
    )
end

function UpdateCastbarChanges()
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetPoint('CENTER', UIParent, 'BOTTOM', 0, -300)
    --CastingBarFrame:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 500)
end

function SetBarNormal()
    local standardRef = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarStandard2'
    frame.Castbar.Bar:SetStatusBarTexture(standardRef)

    frame.Castbar.bChanneling = false
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId =
        UnitCastingInfo('player')

    frame.Castbar.Text:SetText(text:sub(1, 15))
end

function SetBarChannel()
    local channelRef = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarChannel'
    frame.Castbar.Bar:SetStatusBarTexture(channelRef)

    frame.Castbar.bChanneling = true
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible, spellId =
        UnitChannelInfo('player')
    frame.Castbar.Text:SetText(name:sub(1, 15))
end

function SetBarInterrupted()
    local interruptedRef = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarInterrupted2'
    frame.Castbar.Bar:SetStatusBarTexture(interruptedRef)

    frame.Castbar.Text:SetText(CastingBarFrame.Text:GetText())
end

function CastbarModule()
    frame:RegisterEvent('PLAYER_ENTERING_WORLD')

    frame:RegisterUnitEvent('UNIT_SPELLCAST_INTERRUPTED', 'player')
    frame:RegisterUnitEvent('UNIT_SPELLCAST_DELAYED', 'player')
    frame:RegisterUnitEvent('UNIT_SPELLCAST_CHANNEL_START', 'player')
    frame:RegisterUnitEvent('UNIT_SPELLCAST_CHANNEL_UPDATE', 'player')
    frame:RegisterUnitEvent('UNIT_SPELLCAST_CHANNEL_STOP', 'player')
    frame:RegisterUnitEvent('UNIT_SPELLCAST_START', 'player')
    frame:RegisterUnitEvent('UNIT_SPELLCAST_STOP', 'player')
    frame:RegisterUnitEvent('UNIT_SPELLCAST_FAILED', 'player')

    --print('CASTBAR MODULE')
    ChangeCastbar()
    CreateNewCastbar()
end

Core.RegisterModule(Module, {}, {}, false, CastbarModule)

function frame:OnEvent(event, arg1)
    --print('event', event, arg1)
    UpdateCastbarChanges()
    if event == 'PLAYER_ENTERING_WORLD' then
    elseif (event == 'UNIT_SPELLCAST_START' and arg1 == 'player') then
        SetBarNormal()
    elseif (event == 'UNIT_SPELLCAST_INTERRUPTED' and arg1 == 'player') then
        SetBarInterrupted()
    elseif (event == 'UNIT_SPELLCAST_CHANNEL_START' and arg1 == 'player') then
        SetBarChannel()
    else
    end
end
frame:SetScript('OnEvent', frame.OnEvent)
