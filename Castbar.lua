local Addon, Core = ...
local Module = 'Castbar'

local noop = function()
end

local frame = CreateFrame('FRAME', 'DragonflightUICastbarFrame', UIParent)

function ChangeCastbar()
    local standardRef = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarStandard2'
    local borderRef = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarFrame2'
    local maskRef = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarMask'

    --print('ChangeCastbar')
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetPoint('CENTER', UIParent, 'BOTTOM', 0, 500)
    --CastingBarFrame:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 500)

    CastingBarFrame.Text:SetPoint('TOP', CastingBarFrame, 'BOTTOM', 1, 0)
end

function CreateNewCastbar()
    local standardRef = 'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarStandard2'

    local sizeX = 250
    local sizeY = 20
    local f = CreateFrame('Frame', 'DragonflightUICastBar', UIParent)
    f:SetSize(sizeX, sizeY)
    f:SetPoint('CENTER', CastingBarFrame, 'CENTER', 0, 50)

    --[[   local tex = f:CreateTexture('Background', 'ARTWORK')
    tex:SetAllPoints()
    --tex:SetColorTexture(0, 0, 0)
    --tex:SetAlpha(0.5)
    tex:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiexperiencebar2x')
    tex:SetTexCoord(.00048828125, 0.55029296875, 0.08203125, 0.15234375)
    f.Background = tex ]]
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

    CastingBarFrame:HookScript(
        'OnValueChanged',
        function(self)
            -- TargetFrameToTManaBar:Hide()
            UpdateCastBarValues(self)
            -- print('OnValueChanged')
        end
    )
    CastingBarFrame:HookScript(
        'OnMinMaxChanged',
        function(self)
            -- TargetFrameToTManaBar:Hide()
            UpdateCastBarValues(self)
            -- UpdateManaBarTextures()
            -- print('OnMinMaxChanged')
        end
    )

    ------

    --[[  frame.CastBarFrame = CreateFrame('Frame', 'DragonflightUICastBarFrame', UIParent)
    frame.CastBarFrame:SetSize(250, 25)
    frame.CastBarFrame:SetPoint('BOTTOM', 0, 300)

    -- actual status bar, child of parent above
    local Castbar = CreateFrame('StatusBar', nil, f)
    Castbar:SetStatusBarTexture(standardRef)
    Castbar:SetPoint('TOPLEFT', 0, 0)
    Castbar:SetPoint('BOTTOMRIGHT', 0, 0)
    Castbar:SetMinMaxValues(0, 100)
    Castbar:SetValue(50)

    local mask = Castbar:CreateMaskTexture()
    mask:SetTexture(
        'Interface\\Addons\\DragonflightUI\\Textures\\Castbar\\CastingBarMask',
        'CLAMPTOBLACKADDITIVE',
        'CLAMPTOBLACKADDITIVE'
    )
    mask:SetPoint('TOPLEFT', Castbar, 'TOPLEFT', 0, 0)
    mask:SetPoint('BOTTOMRIGHT', Castbar, 'BOTTOMRIGHT', 0, 0)

    Castbar:GetStatusBarTexture():AddMaskTexture(mask)
    frame.CastBarFrame.Castbar = Castbar ]]
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
        ChangeCastbar()

        if not frame.test then
            print('if not')
        end
    else
        ChangeCastbar()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)
