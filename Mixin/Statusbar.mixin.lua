local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

DragonflightUIXPBarMixin = {}

function DragonflightUIXPBarMixin:OnLoad()
    self:CreateBar()
    self:SetupTooltip()
    -- self:Update()

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('PLAYER_XP_UPDATE')
    self:RegisterEvent('UPDATE_EXHAUSTION')
    self:RegisterEvent('PLAYER_REGEN_ENABLED')

    self:SetScript('OnEvent', self.OnEvent)
end

function DragonflightUIXPBarMixin:OnEvent(event, arg1)
    self:Update()
end

function DragonflightUIXPBarMixin:CreateBar()
    local sizeX, sizeY = 466, 20
    self:SetSize(sizeX, sizeY)
    self:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)

    local f = self

    local tex = f:CreateTexture('Background', 'BACKGROUND')
    tex:SetAllPoints()
    tex:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\XP\\Background')
    tex:SetTexCoord(0, 0.55517578, 0, 1)
    f.Background = tex

    -- actual status bar, child of parent above
    f.Bar = CreateFrame('StatusBar', nil, f)
    f.Bar:SetPoint('TOPLEFT', 0, 0)
    f.Bar:SetPoint('BOTTOMRIGHT', 0, 0)
    f.Bar:SetStatusBarTexture('Interface\\Addons\\DragonflightUI\\Textures\\XP\\Main')

    f.RestedBar = CreateFrame('StatusBar', nil, f)
    f.RestedBar:SetPoint('CENTER')
    f.RestedBar:SetSize(sizeX, sizeY)

    f.RestedBar.Texture = f.RestedBar:CreateTexture(nil, 'BORDER', nil)
    f.RestedBar.Texture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\XP\\RestedBackground')
    f.RestedBar.Texture:SetAllPoints()
    f.RestedBar:SetStatusBarTexture(f.RestedBar.Texture)

    -- @TODO: needs more visibility
    local restedBarMarkSizeX, restedBarMarkSizeY = 14, 20
    local restedBarMarkOffsetX, restedBarMarkOffsetY = -1, 2

    f.RestedBarMark = CreateFrame('Frame', nil, f)
    f.RestedBarMark:SetPoint('CENTER', restedBarMarkOffsetX, restedBarMarkOffsetY)
    f.RestedBarMark:SetSize(restedBarMarkSizeX, restedBarMarkSizeY)

    f.RestedBarMark.Texture = f.RestedBarMark:CreateTexture(nil, 'OVERLAY')
    f.RestedBarMark.Texture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiexperiencebar2x')
    f.RestedBarMark.Texture:SetTexCoord(1170 / 2048, 1192 / 2048, 201 / 256, 231 / 256)
    f.RestedBarMark.Texture:SetAllPoints()

    -- border
    local border = f.Bar:CreateTexture('Border', 'OVERLAY')
    border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\XP\\Overlay')
    border:SetTexCoord(0, 0.55517578, 0, 1)
    border:SetSize(sizeX, sizeY)
    border:SetPoint('CENTER')
    f.Border = border

    -- text
    local Path, Size, Flags = MainMenuBarExpText:GetFont()
    f.Bar:EnableMouse(true)

    f.Text = f.Bar:CreateFontString('Text', 'HIGHLIGHT', 'GameFontNormal')
    -- f.Text = f.Bar:CreateFontString('Text', 'OVERLAY', 'GameFontNormal')

    f.Text:SetFont('Fonts\\FRIZQT__.TTF', 10, 'THINOUTLINE')
    f.Text:SetTextColor(1, 1, 1, 1)
    f.Text:SetText('')
    f.Text:ClearAllPoints()
    f.Text:SetParent(f.Bar)
    f.Text:SetPoint('CENTER', 0, 1.5)

end

function DragonflightUIXPBarMixin:SetupTooltip()
    self.Bar:SetScript('OnEnter', function(self)
        local label = XPBAR_LABEL
        GameTooltip_AddNewbieTip(self, label, 1.0, 1.0, 1.0, NEWBIE_TOOLTIP_XPBAR, 1)
        GameTooltip.canAddRestStateLine = 1
        ExhaustionToolTipText()

        local playerCurrXP = UnitXP('player')
        local playerMaxXP = UnitXPMax('player')
        local playerPercent = 100 * playerCurrXP / playerMaxXP
        local playerXPLeft = playerMaxXP - playerCurrXP
        local playerXPLeftPercent = 100 - playerPercent

        local restedXP = GetXPExhaustion() or 0
        local restedMax = playerMaxXP * 1.5
        local restedPercent = 100 * restedXP / restedMax

        GameTooltip:AddDoubleLine(' ')
        GameTooltip:AddDoubleLine('XP: ',
                                  '|cFFFFFFFF' .. FormatLargeNumber(playerCurrXP) .. '/' ..
                                      FormatLargeNumber(playerMaxXP) .. ' (' .. string.format('%.2f', playerPercent) ..
                                      '%)')
        GameTooltip:AddDoubleLine('XP left:', '|cFFFFFFFF' .. FormatLargeNumber(playerXPLeft) .. ' (' ..
                                      string.format('%.2f', playerXPLeftPercent) .. '%)')
        GameTooltip:AddDoubleLine('Rested: ', '|cFFFFFFFF' .. FormatLargeNumber(restedXP) .. ' (' ..
                                      string.format('%.2f', restedPercent) .. '%)')

        if restedPercent < 100 then
            local restedTime = (100 * (restedMax - restedXP) / restedMax) / 10 * 3 * 8 * 60 * 60
            GameTooltip:AddDoubleLine('Time to max rested:', '|cFFFFFFFF' .. SecondsToTime(restedTime))
        end

        GameTooltip:Show()
    end)

    self.Bar:SetScript('OnLeave', function(self)
        local label = XPBAR_LABEL
        GameTooltip:Hide()
    end)
end

function DragonflightUIXPBarMixin:SetState(state)
    self.state = state
    self:Update()
end

function DragonflightUIXPBarMixin:Update()
    local state = self.state

    local showXP = false
    if DF.Wrath then
        showXP = UnitLevel('player') < GetMaxPlayerLevel() and not IsXPUserDisabled()
    else
        showXP = UnitLevel('player') < GetMaxPlayerLevel()
    end

    if showXP then
        self:UpdateText()
    else
    end

    if state.alwaysShowXP then
        self.Text:SetDrawLayer('OVERLAY')
    else
        self.Text:SetDrawLayer('HIGHLIGHT')
    end

    if InCombatLockdown() then
        -- print('XP-bar update after combat fades...')
    else
        local parent = _G[state.anchorFrame]
        self:ClearAllPoints()
        self:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

        self:Collapse(not showXP)
    end
end

function DragonflightUIXPBarMixin:UpdateText()
    local sizeX, sizeY = 466, 20
    -- @TODO: needs more visibility
    local restedBarMarkSizeX, restedBarMarkSizeY = 14, 20
    local restedBarMarkOffsetX, restedBarMarkOffsetY = -1, 2

    -- exhaustion
    local exhaustionStateID = GetRestState()
    if (exhaustionStateID == 1) then
        self.Bar:SetStatusBarTexture('Interface\\Addons\\DragonflightUI\\Textures\\XP\\Rested')
    elseif (exhaustionStateID == 2) then
        self.Bar:SetStatusBarTexture('Interface\\Addons\\DragonflightUI\\Textures\\XP\\Main')
    end

    -- value
    local playerCurrXP = UnitXP('player')
    local playerMaxXP = UnitXPMax('player')
    local restedXP = GetXPExhaustion()

    if (restedXP and restedXP > 0) then
        if (playerCurrXP + restedXP > playerMaxXP) then
            self.RestedBar:Hide()

            self.RestedBarMark:Hide()
        else
            self.RestedBar:Show()
            self.RestedBar:SetMinMaxValues(0, playerMaxXP)
            self.RestedBar:SetValue(playerCurrXP + restedXP)

            self.RestedBarMark:Show()
            self.RestedBarMark:SetPoint('LEFT',
                                        (playerCurrXP + restedXP) / playerMaxXP * sizeX + restedBarMarkOffsetX -
                                            restedBarMarkSizeX / 2, restedBarMarkOffsetY)
        end
    else
        self.RestedBar:Hide()
        self.RestedBarMark:Hide()
    end

    self.Bar:SetMinMaxValues(0, playerMaxXP)
    self.Bar:SetValue(playerCurrXP)

    self.Text:SetText('XP: ' .. playerCurrXP .. '/' .. playerMaxXP)
end

function DragonflightUIXPBarMixin:Collapse(collapse)
    -- @TODO: add combatlock
    if collapse then
        self:Hide()
        self:SetHeight(0.00000001)
    else
        self:Show()
        self:SetHeight(20)
    end
end

-----

DragonflightUIRepBarMixin = {}

function DragonflightUIRepBarMixin:OnLoad()
    self:CreateBar()
    self:SetupTooltip()
    -- self:Update()

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('UPDATE_FACTION')
    self:RegisterEvent('PLAYER_REGEN_ENABLED')

    self:SetScript('OnEvent', self.OnEvent)
end

function DragonflightUIRepBarMixin:OnEvent(event, arg1)
    self:Update()
end

function DragonflightUIRepBarMixin:CreateBar()
    local f = self

    local sizeX, sizeY = 466, 20
    self:SetSize(sizeX, sizeY)
    self:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    -- print('BARS')

    local tex = f:CreateTexture('Background', 'BACKGROUND')
    tex:SetAllPoints()
    tex:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\XP\\Background')
    tex:SetTexCoord(0, 0.55517578, 0, 1)
    f.Background = tex

    -- actual status bar, child of parent above
    f.Bar = CreateFrame('StatusBar', nil, f)
    f.Bar:SetPoint('TOPLEFT', 0, 0)
    f.Bar:SetPoint('BOTTOMRIGHT', 0, 0)
    f.Bar:SetStatusBarTexture('Interface\\Addons\\DragonflightUI\\Textures\\Reputation\\Rep')

    -- border
    local border = f.Bar:CreateTexture('Border', 'OVERLAY')
    border:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\XP\\Overlay')
    border:SetTexCoord(0, 0.55517578, 0, 1)
    border:SetSize(sizeX, sizeY)
    border:SetPoint('CENTER')
    f.Border = border

    -- text
    f.Bar:EnableMouse(true)
    f.Text = f.Bar:CreateFontString('Text', 'HIGHLIGHT', 'GameFontNormal')
    -- f.Text = f.Bar:CreateFontString('Text', 'OVERLAY', 'GameFontNormal')
    f.Text:SetFont('Fonts\\FRIZQT__.TTF', 10, 'THINOUTLINE')
    f.Text:SetTextColor(1, 1, 1, 1)
    f.Text:SetText('')
    f.Text:ClearAllPoints()
    f.Text:SetParent(f.Bar)
    f.Text:SetPoint('CENTER', 0, 1)

    self.Bar:SetMinMaxValues(0, 125)
    self.Bar:SetValue(69)
end

function DragonflightUIRepBarMixin:SetupTooltip()
    self.Bar:SetScript('OnMouseDown', function(self, button)
        if button == 'LeftButton' then ToggleCharacter('ReputationFrame') end
    end)
end

function DragonflightUIRepBarMixin:SetState(state)
    self.state = state
    self:Update()
end

function DragonflightUIRepBarMixin:Update()
    local state = self.state

    local name, standing, min, max, value = GetWatchedFactionInfo()
    if name then
        self:UpdateText()
    else
    end

    if state.alwaysShowRep then
        self.Text:SetDrawLayer('OVERLAY')
    else
        self.Text:SetDrawLayer('HIGHLIGHT')
    end

    if InCombatLockdown() then
        -- print('Rep-bar update after combat fades...')
    else
        local parent = _G[state.anchorFrame]
        self:ClearAllPoints()
        self:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

        self:Collapse(not name)
    end
end

function DragonflightUIRepBarMixin:UpdateText()
    local name, standing, min, max, value = GetWatchedFactionInfo()
    if name then
        -- frame.RepBar.Bar:SetStatusBarColor(color.r, color.g, color.b)
        self.valid = true
        self.Text:SetText(name .. ' ' .. (value - min) .. ' / ' .. (max - min))
        self.Bar:SetMinMaxValues(0, max - min)
        self.Bar:SetValue(value - min)

        if standing == 1 or standing == 2 then
            -- hated, hostile
            self.Bar:SetStatusBarTexture('Interface\\Addons\\DragonflightUI\\Textures\\Reputation\\RepRed')
        elseif standing == 3 then
            -- unfriendly
            self.Bar:SetStatusBarTexture('Interface\\Addons\\DragonflightUI\\Textures\\Reputation\\RepOrange')
        elseif standing == 4 then
            -- neutral
            self.Bar:SetStatusBarTexture('Interface\\Addons\\DragonflightUI\\Textures\\Reputation\\RepYellow')
        elseif standing == 5 or standing == 6 or standing == 7 or standing == 8 then
            -- friendly, honored, revered, exalted
            self.Bar:SetStatusBarTexture('Interface\\Addons\\DragonflightUI\\Textures\\Reputation\\RepGreen')
        else
            self.Bar:SetStatusBarTexture('Interface\\Addons\\DragonflightUI\\Textures\\Reputation\\RepGreen')
        end
    else
    end
end

function DragonflightUIRepBarMixin:Collapse(collapse)
    -- @TODO: add combatlock
    if collapse then
        self:Hide()
        self:SetHeight(0.00000001)
    else
        self:Show()
        self:SetHeight(20)
    end
end
