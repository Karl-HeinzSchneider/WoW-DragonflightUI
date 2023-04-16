local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Actionbar'
local Module = DF:NewModule(mName, 'AceConsole-3.0')

local noop = function()
end

local db, getOptions

local defaults = {
    profile = {
        scale = 1,
        x = 0,
        y = 0,
        showGryphon = true,
        changeSides = true
    }
}

local function getDefaultStr(key)
    return ' (Default: ' .. tostring(defaults.profile[key]) .. ')'
end

local function setDefaultValues()
    for k, v in pairs(defaults.profile) do
        Module.db.profile[k] = v
    end
    Module.ApplySettings()
end

-- db[info[#info] = VALUE
local function getOption(info)
    return db[info[#info]]
end

local function setOption(info, value)
    local key = info[1]
    Module.db.profile[key] = value
    Module.ApplySettings()
end

local options = {
    type = 'group',
    name = 'DragonflightUI - ' .. mName,
    get = getOption,
    set = setOption,
    args = {
        toggle = {
            type = 'toggle',
            name = 'Enable',
            get = function()
                return DF:GetModuleEnabled(mName)
            end,
            set = function(info, v)
                DF:SetModuleEnabled(mName, v)
            end,
            order = 1
        },
        reload = {
            type = 'execute',
            name = '/reload',
            desc = 'reloads UI',
            func = function()
                ReloadUI()
            end,
            order = 1.1
        },
        defaults = {
            type = 'execute',
            name = 'Defaults',
            desc = 'Sets Config to default values',
            func = setDefaultValues,
            order = 1.1
        },
        config = {
            type = 'header',
            name = 'Config - Actionbar',
            order = 100
        },
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale'),
            min = 0.2,
            max = 1.5,
            bigStep = 0.025,
            order = 101,
            disabled = true
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to BOTTOM CENTER' .. getDefaultStr('x'),
            min = -2500,
            max = 2500,
            bigStep = 0.50,
            order = 102,
            disabled = true
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to BOTTOM CENTER' .. getDefaultStr('y'),
            min = -2500,
            max = 2500,
            bigStep = 0.50,
            order = 102,
            disabled = true
        },
        showGryphon = {
            type = 'toggle',
            name = 'Show Gryphon Art',
            desc = 'Shows/Hides Gryphon Art on the side' .. getDefaultStr('showGryphon'),
            order = 105.1
        },
        changeSides = {
            type = 'toggle',
            name = 'Change Right Bar 1+2',
            desc = 'Moves the Right Bar 1 + 2 to the side of the mainbar ' .. getDefaultStr('changeSides'),
            order = 105.2
        }
    }
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)
    db = self.db.profile

    self:SetEnabledState(DF:GetModuleEnabled(mName))
    DF:RegisterModuleOptions(mName, options)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    if DF.Wrath then
        Module.Wrath()
    else
        Module.Era()
    end
    Module:ApplySettings()
end

function Module:OnDisable()
end

function Module:ApplySettings()
    db = Module.db.profile
    Module.ChangeGryphonVisibility(db.showGryphon)
    Module.MoveSideBars(db.changeSides)
end

-- Actionbar
local frame = CreateFrame('FRAME', 'DragonflightUIActionbarFrame', UIParent)
frame:SetFrameStrata('HIGH')

function Module.ChangeActionbar()
    ActionButton1:ClearAllPoints()
    ActionButton1:SetPoint('CENTER', MainMenuBar, 'CENTER', -230 + 3 * 5.5, 30 + 18)

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

function Module.CreateNewXPBar()
    local size = 460
    local f = CreateFrame('Frame', 'DragonflightUIXPBar', UIParent)
    f:SetSize(size, 14)
    f:SetPoint('BOTTOM', 0, 5)

    local tex = f:CreateTexture('Background', 'ARTWORK')
    tex:SetAllPoints()
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

    frame.XPBar.valid = false

    frame.UpdateXPBar = function()
        local showXP = false
        if DF.Wrath then
            showXP = UnitLevel('player') < GetMaxPlayerLevel() and not IsXPUserDisabled()
        else
            showXP = UnitLevel('player') < GetMaxPlayerLevel()
        end

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

            frame.XPBar.valid = true
        else
            frame.XPBar.valid = false
        end
    end

    frame:RegisterEvent('PLAYER_XP_UPDATE')
    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
    frame:RegisterEvent('UPDATE_EXHAUSTION')
end

function Module.CreateNewRepBar()
    local size = 460
    local f = CreateFrame('Frame', 'DragonflightUIRepBar', UIParent)
    f:SetSize(size, 14)
    f:SetPoint('BOTTOM', 0, 5 + 20)

    local tex = f:CreateTexture('Background', 'ARTWORK')
    tex:SetAllPoints()
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
            frame.RepBar.valid = true
            frame.RepBar.Text:SetText(name .. ' ' .. (value - min) .. ' / ' .. (max - min))
            frame.RepBar.Bar:SetMinMaxValues(0, max - min)
            frame.RepBar.Bar:SetValue(value - min)

            local color = FACTION_BAR_COLORS[standing]
            frame.RepBar.Bar:SetStatusBarColor(color.r, color.g, color.b)
        else
            frame.RepBar.valid = false
        end
    end
end

function Module.StyleButtons()
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
        end
    end
end

function Module.StylePageNumber()
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
    MainMenuBarPageNumber:SetScale(1.25)
end

function Module.ApplyMask()
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

function Module.ChangeButtonSpacing()
    local spacing = 3 -- default: 6
    local buttonTable = {'MultiBarBottomRightButton', 'MultiBarBottomLeftButton', 'ActionButton'}
    for k, v in pairs(buttonTable) do
        for i = 2, 12 do
            _G[v .. i]:SetPoint('LEFT', _G[v .. (i - 1)], 'RIGHT', spacing, 0)
        end
    end
end

-- @TODO: better system
function Module.SetNumBars()
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

function Module.GetPetbarOffset()
    local localizedClass, englishClass, classIndex = UnitClass('player')

    -- 1=warrior, 2=paladin, 5=priest, 6=DK, 11=druid
    if (classIndex == 1 or classIndex == 2 or classIndex == 5 or classIndex == 6 or classIndex == 11) then
        return 34
    else
        return 0
    end
end

function Module.HookPetBar()
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
    local offset = Module.GetPetbarOffset()
    PetActionButton1:SetPoint('BOTTOMLEFT', MultiBarBottomRight, 'TOPLEFT', 0.5, 4 + offset)
end

function Module.MoveSideBars(shouldMove)
    DF:Debug(Module, 'MoveSideBars: ' .. tostring(shouldMove))
    local gap = 3
    local delta = 70

    if shouldMove then
        -- right
        for i = 1, 12 do
            _G['MultiBarRightButton' .. i]:ClearAllPoints()
        end

        -- first row 1 2 3 4
        _G['MultiBarRightButton4']:SetPoint('RIGHT', MultiBarBottomRightButton1, 'LEFT', -delta, 0)
        for i = 1, 3 do
            _G['MultiBarRightButton' .. i]:SetPoint('RIGHT', _G['MultiBarRightButton' .. (i + 1)], 'LEFT', -gap, 0)
        end

        -- second row 5 6 7 8
        _G['MultiBarRightButton5']:SetPoint('TOP', _G['MultiBarRightButton1'], 'BOTTOM', 0, -gap)
        for i = 6, 8 do
            _G['MultiBarRightButton' .. i]:SetPoint('LEFT', _G['MultiBarRightButton' .. (i - 1)], 'RIGHT', gap, 0)
        end

        -- third row 9 10 11 12
        _G['MultiBarRightButton9']:SetPoint('TOP', _G['MultiBarRightButton5'], 'BOTTOM', 0, -gap)
        for i = 10, 12 do
            _G['MultiBarRightButton' .. i]:SetPoint('LEFT', _G['MultiBarRightButton' .. (i - 1)], 'RIGHT', gap, 0)
        end

        -- left
        for i = 1, 12 do
            _G['MultiBarLeftButton' .. i]:ClearAllPoints()
        end

        -- first row 1 2 3 4
        _G['MultiBarLeftButton1']:SetPoint('LEFT', MultiBarBottomRightButton12, 'RIGHT', delta, 0)
        for i = 2, 4 do
            _G['MultiBarLeftButton' .. i]:SetPoint('LEFT', _G['MultiBarLeftButton' .. (i - 1)], 'RIGHT', gap, 0)
        end

        -- second row 5 6 7 8
        _G['MultiBarLeftButton5']:SetPoint('TOP', _G['MultiBarLeftButton1'], 'BOTTOM', 0, -gap)
        for i = 6, 8 do
            _G['MultiBarLeftButton' .. i]:SetPoint('LEFT', _G['MultiBarLeftButton' .. (i - 1)], 'RIGHT', gap, 0)
        end

        -- third row 9 10 11 12
        _G['MultiBarLeftButton9']:SetPoint('TOP', _G['MultiBarLeftButton5'], 'BOTTOM', 0, -gap)
        for i = 10, 12 do
            _G['MultiBarLeftButton' .. i]:SetPoint('LEFT', _G['MultiBarLeftButton' .. (i - 1)], 'RIGHT', gap, 0)
        end
    else
        -- Default
        -- right
        _G['MultiBarRightButton1']:ClearAllPoints()
        _G['MultiBarRightButton1']:SetPoint('TOPRIGHT', MultiBarRight, 'TOPRIGHT', -2, -gap)

        for i = 2, 12 do
            _G['MultiBarRightButton' .. i]:ClearAllPoints()
            _G['MultiBarRightButton' .. i]:SetPoint('TOP', _G['MultiBarRightButton' .. (i - 1)], 'BOTTOM', 0, -gap)
        end

        -- left
        _G['MultiBarLeftButton1']:ClearAllPoints()
        _G['MultiBarLeftButton1']:SetPoint('TOPRIGHT', MultiBarLeft, 'TOPRIGHT', -2, -gap)

        for i = 2, 12 do
            _G['MultiBarLeftButton' .. i]:ClearAllPoints()
            _G['MultiBarLeftButton' .. i]:SetPoint('TOP', _G['MultiBarLeftButton' .. (i - 1)], 'BOTTOM', 0, -gap)
        end
    end
end

function Module.MoveSideBarsOLD()
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

function frame:OnEvent(event, arg1)
    --print('event', event)
    if event == 'PLAYER_ENTERING_WORLD' then
        frame.UpdateXPBar()
        frame.UpdateRepBar()
        Module.SetNumBars()
        frame:RegisterEvent('UPDATE_FACTION')
    elseif event == 'UPDATE_FACTION' then
        frame.UpdateRepBar()
        Module.SetNumBars()
    elseif event == 'PLAYER_XP_UPDATE' then
        frame.UpdateXPBar()
        Module.SetNumBars()
    elseif event == 'UPDATE_EXHAUSTION' then
        frame.UpdateXPBar()
        Module.SetNumBars()
    elseif event == 'PLAYER_REGEN_ENABLED' then
        frame.UpdateXPBar()
        frame.UpdateRepBar()
        Module.SetNumBars()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)

-- Artframe
local frameArt = CreateFrame('FRAME', 'DragonflightUIArtframe', UIParent)
--frame:SetFrameStrata('MEDIUM')
--frame:SetPoint('CENTER')

local atlasActionbar = {
    ['UI-HUD-ActionBar-Gryphon-Left'] = {200, 188, 0.001953125, 0.697265625, 0.10205078125, 0.26513671875, false, false},
    ['UI-HUD-ActionBar-Gryphon-Right'] = {
        200,
        188,
        0.001953125,
        0.697265625,
        0.26611328125,
        0.42919921875,
        false,
        false
    },
    ['UI-HUD-ActionBar-IconFrame-Slot'] = {
        128,
        124,
        0.701171875,
        0.951171875,
        0.10205078125,
        0.16259765625,
        false,
        false
    },
    ['UI-HUD-ActionBar-Wyvern-Left'] = {200, 188, 0.001953125, 0.697265625, 0.43017578125, 0.59326171875, false, false},
    ['UI-HUD-ActionBar-Wyvern-Right'] = {200, 188, 0.001953125, 0.697265625, 0.59423828125, 0.75732421875, false, false}
}

function Module.CreateFrameFromAtlas(atlas, name, textureRef, frameName)
    local data = atlas[name]

    local f = CreateFrame('Frame', frameName, UIParent)
    f:SetSize(data[1], data[2])
    f:SetPoint('CENTER', UIParent, 'CENTER')

    f.texture = f:CreateTexture()
    f.texture:SetTexture(textureRef)
    f.texture:SetSize(data[1], data[2])
    f.texture:SetTexCoord(data[3], data[4], data[5], data[6])
    f.texture:SetPoint('CENTER')
    return f
end

function Module.ChangeGryphon()
    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()
    MainMenuBarTexture0:Hide()
    MainMenuBarTexture1:Hide()
    MainMenuBarTexture2:Hide()
    MainMenuBarTexture3:Hide()
end

function Module.DrawGryphon()
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'
    local scale = 0.42
    local dx, dy = 125, 5
    local GryphonLeft =
        Module.CreateFrameFromAtlas(atlasActionbar, 'UI-HUD-ActionBar-Gryphon-Left', textureRef, 'GryphonLeft')
    GryphonLeft:SetScale(scale)
    GryphonLeft:SetPoint('CENTER', ActionButton1, 'CENTER', -dx, dy)
    GryphonLeft:SetFrameStrata('HIGH')
    GryphonLeft:SetFrameLevel(100)
    frameArt.GryphonLeft = GryphonLeft

    local GryphonRight =
        Module.CreateFrameFromAtlas(atlasActionbar, 'UI-HUD-ActionBar-Gryphon-Right', textureRef, 'GryphonRight')
    GryphonRight:SetScale(scale)
    GryphonRight:SetPoint('CENTER', ActionButton12, 'CENTER', dx, dy)
    GryphonRight:SetFrameStrata('HIGH')
    GryphonRight:SetFrameLevel(100)
    frameArt.GryphonRight = GryphonRight
end

function Module.ChangeGryphonStyle(ally)
    if ally then
        frameArt.GryphonRight.texture:SetTexCoord(0.001953125, 0.697265625, 0.26611328125, 0.42919921875)
        frameArt.GryphonLeft.texture:SetTexCoord(0.001953125, 0.697265625, 0.10205078125, 0.26513671875)
    else
        frameArt.GryphonRight.texture:SetTexCoord(0.001953125, 0.697265625, 0.59423828125, 0.75732421875)
        frameArt.GryphonLeft.texture:SetTexCoord(0.001953125, 0.697265625, 0.43017578125, 0.59326171875)
    end
end

function Module.DrawActionbarDeco()
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'
    for i = 1, 12 do
        local deco =
            Module.CreateFrameFromAtlas(
            atlasActionbar,
            'UI-HUD-ActionBar-IconFrame-Slot',
            textureRef,
            'ActionbarDeco' .. i
        )
        deco:SetScale(0.3)
        deco:SetPoint('CENTER', _G['ActionButton' .. i], 'CENTER', 0, 0)
    end
end

function Module.ChangeGryphonVisibility(visible)
    if visible then
        --MainMenuBarPageNumber:Show()
        frameArt.GryphonRight:Show()
        frameArt.GryphonLeft:Show()
    else
        --MainMenuBarPageNumber:Hide()
        frameArt.GryphonRight:Hide()
        frameArt.GryphonLeft:Hide()
    end
end

function frameArt:OnEvent(event, arg1)
    --print('art event', event)
    if event == 'UNIT_ENTERED_VEHICLE' then
        Module.ChangeGryphonVisibility(false)
    elseif event == 'UNIT_EXITED_VEHICLE' then
        Module.ChangeGryphonVisibility(true)
    elseif event == 'PLAYER_ENTERING_WORLD' then
        local englishFaction, localizedFaction = UnitFactionGroup('player')

        if englishFaction == 'Alliance' then
            Module.ChangeGryphonStyle(true)
        else
            Module.ChangeGryphonStyle(false)
        end
    end
end
frameArt:SetScript('OnEvent', frameArt.OnEvent)

-- Micromenu
function Module.SetButtonFromAtlas(frame, atlas, textureRef, pre, name)
    local key = pre .. name

    local up = atlas[key .. '-Up']
    frame:SetSize(up[1], up[2])
    frame:SetScale(0.7)
    frame:SetHitRectInsets(0, 0, 0, 0)

    frame:SetNormalTexture(textureRef)
    frame:GetNormalTexture():SetTexCoord(up[3], up[4], up[5], up[6])

    local disabled = atlas[key .. '-Disabled']
    frame:SetDisabledTexture(textureRef)
    frame:GetDisabledTexture():SetTexCoord(disabled[3], disabled[4], disabled[5], disabled[6])

    local down = atlas[key .. '-Down']
    frame:SetPushedTexture(textureRef)
    frame:GetPushedTexture():SetTexCoord(down[3], down[4], down[5], down[6])

    local mouseover = atlas[key .. '-Mouseover']
    frame:SetHighlightTexture(textureRef)
    frame:GetHighlightTexture():SetTexCoord(mouseover[3], mouseover[4], mouseover[5], mouseover[6])

    return frame
end

function Module.ChangeMicroMenu()
    -- from https://www.townlong-yak.com/framexml/live/Helix/AtlasInfo.lua
    local Atlas = {
        ['UI-HUD-MicroMenu-Achievements-Disabled'] = {
            38,
            52,
            0.78515625,
            0.93359375,
            0.212890625,
            0.314453125,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Achievements-Down'] = {
            38,
            52,
            0.62890625,
            0.77734375,
            0.107421875,
            0.208984375,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Achievements-Mouseover'] = {
            38,
            52,
            0.78515625,
            0.93359375,
            0.107421875,
            0.208984375,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Achievements-Up'] = {38, 52, 0.62890625, 0.77734375, 0.212890625, 0.314453125, false, false},
        ['UI-HUD-MicroMenu-AdventureGuide-Disabled'] = {
            38,
            52,
            0.31640625,
            0.46484375,
            0.318359375,
            0.419921875,
            false,
            false
        },
        ['UI-HUD-MicroMenu-AdventureGuide-Down'] = {
            38,
            52,
            0.78515625,
            0.93359375,
            0.318359375,
            0.419921875,
            false,
            false
        },
        ['UI-HUD-MicroMenu-AdventureGuide-Mouseover'] = {
            38,
            52,
            0.62890625,
            0.77734375,
            0.318359375,
            0.419921875,
            false,
            false
        },
        ['UI-HUD-MicroMenu-AdventureGuide-Up'] = {
            38,
            52,
            0.00390625,
            0.15234375,
            0.529296875,
            0.630859375,
            false,
            false
        },
        ['UI-HUD-MicroMenu-CharacterInfo-Disabled'] = {
            38,
            52,
            0.00390625,
            0.15234375,
            0.423828125,
            0.525390625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-CharacterInfo-Down'] = {
            38,
            52,
            0.47265625,
            0.62109375,
            0.318359375,
            0.419921875,
            false,
            false
        },
        ['UI-HUD-MicroMenu-CharacterInfo-Mouseover'] = {
            38,
            52,
            0.31640625,
            0.46484375,
            0.423828125,
            0.525390625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-CharacterInfo-Up'] = {38, 52, 0.00390625, 0.15234375, 0.634765625, 0.736328125, false, false},
        ['UI-HUD-MicroMenu-Collections-Disabled'] = {
            38,
            52,
            0.47265625,
            0.62109375,
            0.001953125,
            0.103515625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Collections-Down'] = {38, 52, 0.00390625, 0.15234375, 0.740234375, 0.841796875, false, false},
        ['UI-HUD-MicroMenu-Collections-Mouseover'] = {
            38,
            52,
            0.00390625,
            0.15234375,
            0.845703125,
            0.947265625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Collections-Up'] = {38, 52, 0.16015625, 0.30859375, 0.318359375, 0.419921875, false, false},
        ['UI-HUD-MicroMenu-Communities-Icon-Notification'] = {
            20,
            22,
            0.00390625,
            0.08203125,
            0.951171875,
            0.994140625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-GameMenu-Disabled'] = {
            38,
            52,
            0.16015625,
            0.30859375,
            0.423828125,
            0.525390625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-GameMenu-Down'] = {38, 52, 0.47265625, 0.62109375, 0.423828125, 0.525390625, false, false},
        ['UI-HUD-MicroMenu-GameMenu-Mouseover'] = {
            38,
            52,
            0.62890625,
            0.77734375,
            0.423828125,
            0.525390625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-GameMenu-Up'] = {38, 52, 0.78515625, 0.93359375, 0.423828125, 0.525390625, false, false},
        ['UI-HUD-MicroMenu-Groupfinder-Disabled'] = {
            38,
            52,
            0.16015625,
            0.30859375,
            0.529296875,
            0.630859375,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Groupfinder-Down'] = {38, 52, 0.31640625, 0.46484375, 0.212890625, 0.314453125, false, false},
        ['UI-HUD-MicroMenu-Groupfinder-Mouseover'] = {
            38,
            52,
            0.16015625,
            0.30859375,
            0.212890625,
            0.314453125,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Groupfinder-Up'] = {38, 52, 0.00390625, 0.15234375, 0.318359375, 0.419921875, false, false},
        ['UI-HUD-MicroMenu-GuildCommunities-Disabled'] = {
            38,
            52,
            0.78515625,
            0.93359375,
            0.001953125,
            0.103515625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-GuildCommunities-Down'] = {
            38,
            52,
            0.00390625,
            0.15234375,
            0.001953125,
            0.103515625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-GuildCommunities-Mouseover'] = {
            38,
            52,
            0.16015625,
            0.30859375,
            0.001953125,
            0.103515625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-GuildCommunities-Up'] = {
            38,
            52,
            0.16015625,
            0.30859375,
            0.107421875,
            0.208984375,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Highlightalert'] = {66, 80, 0.47265625, 0.73046875, 0.740234375, 0.896484375, false, false},
        ['UI-HUD-MicroMenu-Questlog-Disabled'] = {
            38,
            52,
            0.16015625,
            0.30859375,
            0.740234375,
            0.841796875,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Questlog-Down'] = {38, 52, 0.47265625, 0.62109375, 0.529296875, 0.630859375, false, false},
        ['UI-HUD-MicroMenu-Questlog-Mouseover'] = {
            38,
            52,
            0.16015625,
            0.30859375,
            0.845703125,
            0.947265625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-Questlog-Up'] = {38, 52, 0.78515625, 0.93359375, 0.529296875, 0.630859375, false, false},
        ['UI-HUD-MicroMenu-Shop-Disabled'] = {38, 52, 0.16015625, 0.30859375, 0.634765625, 0.736328125, false, false},
        ['UI-HUD-MicroMenu-Shop-Down'] = {38, 52, 0.62890625, 0.77734375, 0.529296875, 0.630859375, false, false},
        ['UI-HUD-MicroMenu-Shop-Mouseover'] = {38, 52, 0.47265625, 0.62109375, 0.634765625, 0.736328125, false, false},
        ['UI-HUD-MicroMenu-Shop-Up'] = {38, 52, 0.00390625, 0.15234375, 0.212890625, 0.314453125, false, false},
        ['UI-HUD-MicroMenu-SpecTalents-Disabled'] = {
            38,
            52,
            0.31640625,
            0.46484375,
            0.107421875,
            0.208984375,
            false,
            false
        },
        ['UI-HUD-MicroMenu-SpecTalents-Down'] = {38, 52, 0.31640625, 0.46484375, 0.529296875, 0.630859375, false, false},
        ['UI-HUD-MicroMenu-SpecTalents-Mouseover'] = {
            38,
            52,
            0.31640625,
            0.46484375,
            0.001953125,
            0.103515625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-SpecTalents-Up'] = {38, 52, 0.62890625, 0.77734375, 0.001953125, 0.103515625, false, false},
        ['UI-HUD-MicroMenu-SpellbookAbilities-Disabled'] = {
            38,
            52,
            0.00390625,
            0.15234375,
            0.107421875,
            0.208984375,
            false,
            false
        },
        ['UI-HUD-MicroMenu-SpellbookAbilities-Down'] = {
            38,
            52,
            0.31640625,
            0.46484375,
            0.845703125,
            0.947265625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-SpellbookAbilities-Mouseover'] = {
            38,
            52,
            0.73828125,
            0.88671875,
            0.845703125,
            0.947265625,
            false,
            false
        },
        ['UI-HUD-MicroMenu-SpellbookAbilities-Up'] = {
            38,
            52,
            0.47265625,
            0.62109375,
            0.107421875,
            0.208984375,
            false,
            false
        },
        ['UI-HUD-MicroMenu-StreamDLGreen-Down'] = {
            38,
            52,
            0.31640625,
            0.46484375,
            0.634765625,
            0.736328125,
            false,
            false
        },
        ['UI-HUD-MicroMenu-StreamDLGreen-Up'] = {38, 52, 0.47265625, 0.62109375, 0.212890625, 0.314453125, false, false},
        ['UI-HUD-MicroMenu-StreamDLRed-Down'] = {38, 52, 0.31640625, 0.46484375, 0.740234375, 0.841796875, false, false},
        ['UI-HUD-MicroMenu-StreamDLRed-Up'] = {38, 52, 0.62890625, 0.77734375, 0.634765625, 0.736328125, false, false},
        ['UI-HUD-MicroMenu-StreamDLYellow-Down'] = {
            38,
            52,
            0.73828125,
            0.88671875,
            0.740234375,
            0.841796875,
            false,
            false
        },
        ['UI-HUD-MicroMenu-StreamDLYellow-Up'] = {
            38,
            52,
            0.78515625,
            0.93359375,
            0.634765625,
            0.736328125,
            false,
            false
        }
    }
    local microTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\uimicromenu2x'
    Module.SetButtonFromAtlas(CharacterMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'CharacterInfo')
    MicroButtonPortrait:Hide()
    Module.SetButtonFromAtlas(SpellbookMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'SpellbookAbilities')
    Module.SetButtonFromAtlas(TalentMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'SpecTalents')
    Module.SetButtonFromAtlas(QuestLogMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'Questlog')
    Module.SetButtonFromAtlas(SocialsMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'GuildCommunities')

    Module.SetButtonFromAtlas(HelpMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'GameMenu')

    if DF.Wrath then
        Module.SetButtonFromAtlas(AchievementMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'Achievements')
        Module.SetButtonFromAtlas(PVPMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'AdventureGuide')
        PVPMicroButtonTexture:Hide()
        Module.SetButtonFromAtlas(LFGMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'Groupfinder')
        Module.SetButtonFromAtlas(MainMenuMicroButton, Atlas, microTexture, 'UI-HUD-MicroMenu-', 'Shop')
        MainMenuBarPerformanceBar:Hide()
    else
        MainMenuBarPerformanceBarFrame:Hide()
    end
end

function Module.GetBagSlots(id)
    local build, _, _, _ = GetBuildInfo()
    if build == '3.4.1' then
        local slots = C_Container.GetContainerNumSlots(id)
        return slots
    else
        local slots = GetContainerNumSlots(id)
        return slots
    end
end

function Module.ChangeBackpack()
    --MainMenuBarBackpackButton MainMenuBarBackpackButtonIconTexture
    local texture = 'Interface\\Addons\\DragonflightUI\\Textures\\bigbag'
    local highlight = 'Interface\\Addons\\DragonflightUI\\Textures\\bigbagHighlight'

    MainMenuBarBackpackButton:SetScale(1.5)

    SetItemButtonTexture(MainMenuBarBackpackButton, texture)
    MainMenuBarBackpackButton:SetHighlightTexture(highlight)
    MainMenuBarBackpackButton:SetPushedTexture(highlight)
    MainMenuBarBackpackButton:SetCheckedTexture(highlight)

    MainMenuBarBackpackButtonNormalTexture:Hide()
    MainMenuBarBackpackButtonNormalTexture:SetTexture()
    --MainMenuBarBackpackButton.IconBorder:Hide()

    local slot = 'Interface\\Addons\\DragonflightUI\\Textures\\bagborder2'
    local slothighlight = 'Interface\\Addons\\DragonflightUI\\Textures\\baghighlight2'

    local bagtexture = 'Interface\\Addons\\DragonflightUI\\Textures\\bagslots2x'
    local bagmask = 'Interface\\Addons\\DragonflightUI\\Textures\\bagmask'
    -- dx/dy => better center
    local dy = 0.015
    local dx = -0.001

    for i = 0, 3 do
        _G['CharacterBag' .. i .. 'Slot']:GetNormalTexture():SetTexture(bagtexture)
        --  _G['CharacterBag' .. i .. 'Slot']:GetNormalTexture():SetTexCoord(0.576171875, 0.6953125, 0.5, 0.9765625) -- empty

        _G['CharacterBag' .. i .. 'Slot']:GetNormalTexture():SetTexCoord(
            0.576171875 + dx,
            0.6953125 + dx,
            0.0078125 + dy,
            0.484375 + dy
        )
        _G['CharacterBag' .. i .. 'Slot']:GetNormalTexture():SetSize(35, 35)

        _G['CharacterBag' .. i .. 'Slot']:GetHighlightTexture():SetTexture(bagtexture)
        _G['CharacterBag' .. i .. 'Slot']:GetHighlightTexture():SetTexCoord(
            0.69921875,
            0.818359375,
            0.0078125,
            0.484375
        )
        _G['CharacterBag' .. i .. 'Slot']:GetHighlightTexture():SetSize(35, 35)

        _G['CharacterBag' .. i .. 'Slot']:GetCheckedTexture():SetTexture()
        _G['CharacterBag' .. i .. 'Slot']:GetPushedTexture():SetTexture()

        _G['CharacterBag' .. i .. 'SlotIconTexture']:SetMask(bagmask)

        -- Note:
        -- bagID = 4 3 2 1 0  , 0 = backpack
        -- texture bag id = 3 2 1 0  , backpack seperate
        local slothook = function(self, id)
            local slots = Module.GetBagSlots(id)
            local name = 'CharacterBag' .. (id - 1) .. 'Slot'
            if slots == 0 then
                _G[name]:GetNormalTexture():SetTexCoord(0.576171875, 0.6953125, 0.5, 0.9765625)
            else
                _G[name]:GetNormalTexture():SetTexCoord(0.576171875 + dx, 0.6953125 + dx, 0.0078125 + dy, 0.484375 + dy)
            end
        end

        hooksecurefunc(
            _G['CharacterBag' .. i .. 'SlotIconTexture'],
            'SetTexture',
            function(args)
                slothook(args, i + 1)
            end
        )
    end

    --keyring
    KeyRingButton:SetSize(34.5, 34.5)
    KeyRingButton:SetPoint('RIGHT', CharacterBag3Slot, 'LEFT', -6 + 3, 0 - 2)

    KeyRingButton:GetNormalTexture():SetTexture(bagtexture)
    KeyRingButton:GetNormalTexture():SetSize(35, 35)
    KeyRingButton:GetNormalTexture():SetTexCoord(0.576171875 + dx, 0.6953125 + dx, 0.0078125 + dy, 0.484375 + dy)
    KeyRingButton:GetNormalTexture():SetTexCoord(0.822265625, 0.94140625, 0.0078125, 0.484375)

    KeyRingButton:GetHighlightTexture():SetTexture(bagtexture)
    KeyRingButton:GetHighlightTexture():SetSize(35, 35)
    KeyRingButton:GetHighlightTexture():SetTexCoord(0.69921875, 0.818359375, 0.0078125, 0.484375)

    --KeyRingButton:GetPushedTexture():SetTexture(bagtexture)
    KeyRingButton:GetPushedTexture():SetSize(35, 35)
    -- KeyRingButton:GetPushedTexture():SetTexture(0.69921875, 0.818359375, 0.0078125, 0.484375)
    --KeyRingButton:GetCheckedTexture():SetTexture()
end

function Module.MoveBars()
    MainMenuBarBackpackButton:ClearAllPoints()
    MainMenuBarBackpackButton:SetPoint('BOTTOMRIGHT', UIParent, 0, 26)

    CharacterMicroButton:ClearAllPoints()
    CharacterMicroButton:SetPoint('BOTTOMRIGHT', UIParent, -300 - 20, 0)

    CharacterMicroButton.SetPoint = noop
    CharacterMicroButton.ClearAllPoints = noop

    if DF.Wrath then
        PVPMicroButton.SetPoint = noop
        PVPMicroButton.ClearAllPoints = noop
    end
end

function Module.ChangeFramerate()
    FramerateLabel:ClearAllPoints()
    FramerateLabel:SetPoint('BOTTOM', CharacterMicroButton, 'BOTTOM', -80, 6)
    local scale = 0.75
    FramerateLabel:SetScale(scale)
    FramerateText:SetScale(scale)
    UIPARENT_MANAGED_FRAME_POSITIONS.FramerateLabel = nil

    -- text

    local f = CreateFrame('Frame', 'PingTextFrame', UIParent)
    f:SetWidth(1)
    f:SetHeight(1)
    f:ClearAllPoints()
    f:SetPoint('LEFT', FramerateLabel, 'LEFT', 0, 14)
    local t = f:CreateFontString('PingText', 'OVERLAY', 'SystemFont_Shadow_Med1')
    t:SetPoint('LEFT', 0, 0)
    t:SetText('')

    local Path, Size, Flags = FramerateText:GetFont()
    t:SetFont(Path, Size, Flags)

    hooksecurefunc(
        FramerateText,
        'SetFormattedText',
        function()
            local down, up, lagHome, lagWorld = GetNetStats()
            --local str = 'MS: ' .. lagHome .. '|' .. lagWorld
            local str = 'MS: ' .. math.max(lagHome, lagWorld)
            t:SetText(str)
        end
    )
    hooksecurefunc(
        FramerateText,
        'Show',
        function()
            f:Show()
        end
    )
    hooksecurefunc(
        FramerateText,
        'Hide',
        function()
            f:Hide()
        end
    )
end

-- WRATH
function Module.Wrath()
    Module.ChangeActionbar()
    Module.CreateNewXPBar()
    Module.CreateNewRepBar()
    Module.StyleButtons()
    Module.StylePageNumber()
    Module.ApplyMask()
    Module.ChangeButtonSpacing()
    frame.UpdateXPBar()
    frame.UpdateRepBar()
    Module.SetNumBars()
    Module.HookPetBar()

    --Module.MoveSideBars()

    frame:RegisterEvent('PLAYER_REGEN_ENABLED')

    --Core.Sub.Artframe()
    Module.ChangeGryphon()
    Module.DrawGryphon()
    Module.DrawActionbarDeco()

    frameArt:RegisterUnitEvent('UNIT_ENTERED_VEHICLE', 'player')
    frameArt:RegisterUnitEvent('UNIT_EXITED_VEHICLE', 'player')
    frameArt:RegisterEvent('PLAYER_ENTERING_WORLD')

    --Core.Sub.Micromenu()
    Module.ChangeMicroMenu()
    Module.ChangeBackpack()
    Module.MoveBars()
    Module.ChangeFramerate()
end

-- ERA
function Module.Era()
    Module.Wrath()
end
