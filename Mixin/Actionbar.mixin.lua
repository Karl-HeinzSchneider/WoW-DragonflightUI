DragonflightUIEditModeMixin = {}

function DragonflightUIEditModeMixin:InitEditMode()
    self.box = CreateFrame('FRAME')
    self.box:SetParent(self)
    self.box:SetAllPoints()
    self.box:SetFrameLevel(42)
    self.box:SetFrameStrata('HIGH')

    self.box.texture = self.box:CreateTexture(nil, 'OVERLAY')
    self.box.texture:SetAllPoints()
    self.box.texture:SetColorTexture(0, 0.8, 0, 0.42)
end

function DragonflightUIEditModeMixin:ShowHighlight(show)
    self.box:SetShown(show)
end

DragonflightUIActionbarMixin = CreateFromMixins(DragonflightUIEditModeMixin)

function DragonflightUIActionbarMixin:Init()
    self:SetPoint('BOTTOMLEFT', UIParent, 'CENTER', 0, 380)
    self:SetSize(250, 142)

    self:InitEditMode()

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:SetScript('OnEvent', function(event, arg1)
        self:Update()
    end)
end

function DragonflightUIActionbarMixin:SetButtons(buttons)
    self.buttonTable = buttons
    -- print('DragonflightUIActionbarMixin:SetButtons(buttons)', #buttons, buttons[1]:GetName())
end

--[[ local defaultsActionbarPROTO = {
    scale = 1,
    anchorFrame = 'UIParent',
    anchor = 'CENTER',
    anchorParent = 'CENTER',
    x = 0,
    y = 0,
    orientation = 'horizontal',
    buttonScale = 1,
    rows = 1,
    buttons = 12,
    padding = 3,
    alwaysShow = true
} ]]
function DragonflightUIActionbarMixin:SetState(state)
    self.state = state
    self.savedAlwaysShow = state.alwaysShow
    self:Update()
end

function DragonflightUIActionbarMixin:Update()
    local state = self.state
    -- print("DragonflightUIActionbarMixin:Update()", state)
    -- DevTools_Dump(state)
    local buttonTable = self.buttonTable
    local btnCount = #buttonTable

    if state.reverse then
        local tmp = {}
        for i = 1, btnCount do tmp[i] = buttonTable[i] end
        buttonTable = {}
        for i = 1, btnCount do buttonTable[btnCount + 1 - i] = tmp[i] end
    end

    local btnScale = state.buttonScale
    local btnSize = buttonTable[1]:GetWidth()
    -- local btnSize = self.buttonTable[1]:GetWidth() * state.buttonScale
    -- local btnSize = (self.buttonTable[1]:GetWidth() / self.buttonTable[1]:GetScale()) * btnScale
    -- local btnSize = 36 * state.buttonScale

    -- print(btnScale, btnSize)

    local modulo = state.buttons % state.rows

    local buttons = state.buttons
    local rows = state.rows
    if rows > state.buttons then rows = buttons end

    local maxRowButtons = math.ceil(buttons / rows)
    -- print('maxRowButtons', maxRowButtons)

    local padding = state.padding
    -- local width = (maxRowButtons * btnSize + (maxRowButtons + 1) * padding) * btnScale
    local width = (maxRowButtons * (btnSize + 2 * padding)) * btnScale
    local height = (rows * (btnSize + 2 * padding)) * btnScale

    if state.orientation == 'horizontal' then
        self:SetSize(width, height)
    else
        self:SetSize(height, width)
    end

    local parent = _G[state.anchorFrame]
    self:ClearAllPoints()
    self:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

    for i = buttons + 1, btnCount do
        local btn = buttonTable[i]
        btn:ClearAllPoints()
        btn:SetPoint('CENTER', UIParent, 'BOTTOM', 0, -666)
        btn:Hide()

        if btn.decoDF then btn.decoDF:Hide() end
    end

    local index = 1

    -- i = rowIndex
    for i = 1, rows do
        local rowButtons = buttons / rows

        if i <= modulo then
            rowButtons = math.ceil(rowButtons)
        else
            rowButtons = math.floor(rowButtons)
        end
        -- print('row', i, rowButtons)

        -- j = btn in row index
        for j = 1, rowButtons do
            local btn = buttonTable[index]
            -- print('btn', i, btn:GetName())
            btn:ClearAllPoints()
            btn:Show()
            if btn.decoDF then btn.decoDF:SetShown(not state.hideArt) end

            btn:SetScale(btnScale)
            local dx = (2 * j - 1) * padding + (j - 1) * btnSize
            local dy = (2 * i - 1) * padding + (i - 1) * btnSize

            if state.orientation == 'horizontal' then
                btn:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', dx, dy)
            else
                btn:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', dy, dx)
            end

            -- btn:GetAttribute("showgrid") can be nil
            if state.alwaysShow then
                if btn:GetAttribute("showgrid") then
                    if btn:GetAttribute("showgrid") < 1 then btn:SetAttribute("showgrid", 1) end
                else
                    btn:SetAttribute("showgrid", 1)
                end

            else
                if btn:GetAttribute("showgrid") and btn:GetAttribute("showgrid") > 0 then
                    btn:SetAttribute("showgrid", 0)
                end

                if btn.action then
                    if not HasAction(btn.action) then btn:Hide() end
                else
                    btn:Hide()
                end
            end

            if state.hideArt then
                if btn.DFDeco then btn.DFDeco:Hide() end
            else
                if btn.DFDeco then btn.DFDeco:Show() end
            end

            local name = btn:GetName()
            local macroText = _G[name .. 'Name']
            local keybindText = _G[name .. 'HotKey']

            if state.hideMacro then
                macroText:SetAlpha(0)
            else
                macroText:SetAlpha(1)
            end

            if state.hideKeybind then
                keybindText:SetAlpha(0)
            else
                keybindText:SetAlpha(1)
            end

            index = index + 1
        end
    end
    self:ShowHighlight(false)

    -- print(self.buttonTable[1]:GetName(), 'update')
    -- self:UpdateGrid(state.alwaysShow)

    -- mainbar only
    if self.gryphonLeft and self.gryphonRight then self:UpdateGryphons(state.gryphons) end

    if self.numberFrame then self:UpdateNumberFrame() end

    -- if self.decoFrame then self.decoFrame.update(state) end

    if state.activate ~= nil then
        --
        -- print('state.activate ~= nil', state.activate, self:GetName())
        -- self:SetShown(state.activate)
        if state.activate == false then

            for i = 1, btnCount do
                local btn = buttonTable[i]
                btn:ClearAllPoints()
                btn:SetPoint('CENTER', UIParent, 'BOTTOM', 0, -666)
                btn:Hide()
                if btn.decoDF then btn.decoDF:Hide() end
            end
        end
    end
end

function DragonflightUIActionbarMixin:HookQuickbindMode()
    EventRegistry:RegisterCallback("DragonflightUI.ToggleQuickKeybindMode", self.OnToggleQuickKeybindMode, self);
end

function DragonflightUIActionbarMixin:OnToggleQuickKeybindMode(on)
    -- print('OnToggleQuickKeybindMode', on)
    if on then
        self.state.alwaysShow = true
    else
        self.state.alwaysShow = self.savedAlwaysShow
    end
    self:Update()
end

function DragonflightUIActionbarMixin:SetupMainBar()
    self:AddGryphons()
    self:SetupPageNumberFrame()
    -- self:AddDeco()
    self:AddDecoNew()
end

function DragonflightUIActionbarMixin:AddGryphons()
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'
    local scale = 0.42
    local dy = self.buttonTable[1]:GetHeight()

    local gryphonLeft = CreateFrame('Frame', 'DragonflightUIGryphonLeft', self)
    gryphonLeft:SetSize(200, 188)
    gryphonLeft:SetScale(scale)
    gryphonLeft:SetPoint('RIGHT', self, 'BOTTOMLEFT', 0, dy)
    gryphonLeft:SetFrameStrata('MEDIUM')
    gryphonLeft:SetFrameLevel(5)

    gryphonLeft.texture = gryphonLeft:CreateTexture()
    gryphonLeft.texture:SetTexture(textureRef)
    gryphonLeft.texture:SetSize(200, 188)
    gryphonLeft.texture:SetTexCoord(0.001953125, 0.697265625, 0.10205078125, 0.26513671875)
    gryphonLeft.texture:SetPoint('CENTER')

    self.gryphonLeft = gryphonLeft

    local gryphonRight = CreateFrame('Frame', 'DragonflightUIGryphonRight', self)
    gryphonRight:SetSize(200, 188)
    gryphonRight:SetScale(scale)
    gryphonRight:SetPoint('LEFT', self, 'BOTTOMRIGHT', 0, dy)
    gryphonRight:SetFrameStrata('MEDIUM')
    gryphonRight:SetFrameLevel(5)

    gryphonRight.texture = gryphonRight:CreateTexture()
    gryphonRight.texture:SetTexture(textureRef)
    gryphonRight.texture:SetSize(200, 188)
    gryphonRight.texture:SetTexCoord(0.001953125, 0.697265625, 0.26611328125, 0.42919921875)
    gryphonRight.texture:SetPoint('CENTER')

    self.gryphonRight = gryphonRight
end

function DragonflightUIActionbarMixin:UpdateGryphons(gryphons)
    self.gryphonLeft:Show()
    self.gryphonRight:Show()

    local state = self.state
    local padding = state.padding
    local btnCount = state.buttons

    -- local dy = self.buttonTable[1]:GetHeight() + padding

    local btnScale = state.buttonScale
    local gryphonScale = btnScale * 0.42

    local dx = padding + 15
    local dy = 6

    local rows = state.rows
    if rows > btnCount then rows = btnCount end

    local maxRowButtons = math.ceil(btnCount / rows)

    if state.reverse then
        self.gryphonLeft:SetPoint('RIGHT', self.buttonTable[12], 'LEFT', dx, dy)
        self.gryphonLeft:SetScale(gryphonScale)

        self.gryphonRight:SetPoint('LEFT', self.buttonTable[12 - maxRowButtons + 1], 'RIGHT', -dx, dy)
        self.gryphonRight:SetScale(gryphonScale)
    else
        self.gryphonLeft:SetPoint('RIGHT', self.buttonTable[1], 'LEFT', dx, dy)
        self.gryphonLeft:SetScale(gryphonScale)

        self.gryphonRight:SetPoint('LEFT', self.buttonTable[maxRowButtons], 'RIGHT', -dx, dy)
        self.gryphonRight:SetScale(gryphonScale)
    end

    self.numberFrame:SetScale(btnScale)

    if gryphons == 'DEFAULT' then
        local englishFaction, localizedFaction = UnitFactionGroup('player')
        if englishFaction == 'Alliance' then
            self.gryphonLeft.texture:SetTexCoord(0.001953125, 0.697265625, 0.10205078125, 0.26513671875)
            self.gryphonRight.texture:SetTexCoord(0.001953125, 0.697265625, 0.26611328125, 0.42919921875)
        else
            self.gryphonLeft.texture:SetTexCoord(0.001953125, 0.697265625, 0.43017578125, 0.59326171875)
            self.gryphonRight.texture:SetTexCoord(0.001953125, 0.697265625, 0.59423828125, 0.75732421875)
        end
    elseif gryphons == 'ALLY' then
        self.gryphonLeft.texture:SetTexCoord(0.001953125, 0.697265625, 0.10205078125, 0.26513671875)
        self.gryphonRight.texture:SetTexCoord(0.001953125, 0.697265625, 0.26611328125, 0.42919921875)
    elseif gryphons == 'HORDE' then
        self.gryphonLeft.texture:SetTexCoord(0.001953125, 0.697265625, 0.43017578125, 0.59326171875)
        self.gryphonRight.texture:SetTexCoord(0.001953125, 0.697265625, 0.59423828125, 0.75732421875)
    elseif gryphons == 'NONE' then
        self.gryphonLeft:Hide()
        self.gryphonRight:Hide()
    end
end

function DragonflightUIActionbarMixin:SetupPageNumberFrame()
    local f = CreateFrame('Frame', 'DragonflightUIPageNumberFrame', UIParent)
    f:SetSize(25, 25)
    f:SetPoint('RIGHT', ActionButton1, 'LEFT')
    f:SetFrameStrata('MEDIUM')
    f:SetFrameLevel(6)

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
    ActionBarUpButton:SetParent(f)
    ActionBarUpButton:ClearAllPoints()
    ActionBarUpButton:SetPoint('CENTER', f, 'TOP', 0, 0)
    ActionBarUpButton:SetFrameStrata('MEDIUM')
    ActionBarUpButton:SetFrameLevel(6)
    ActionBarUpButton:SetScale(buttonScale)

    ActionBarDownButton:SetParent(f)
    ActionBarDownButton:ClearAllPoints()
    ActionBarDownButton:SetPoint('CENTER', f, 'BOTTOM', 0, 0)
    ActionBarDownButton:SetFrameStrata('MEDIUM')
    ActionBarDownButton:SetFrameLevel(6)
    ActionBarDownButton:SetScale(buttonScale)

    MainMenuBarPageNumber:ClearAllPoints()
    MainMenuBarPageNumber:SetPoint('CENTER', f, 'CENTER', 0, 0)
    MainMenuBarPageNumber:SetParent(f)
    MainMenuBarPageNumber:SetScale(1.25)

    self.numberFrame = f
    -- f:Hide()
end

function DragonflightUIActionbarMixin:UpdateNumberFrame()
    local state = self.state
    local padding = state.padding
    local btnCount = state.buttons

    -- local dy = self.buttonTable[1]:GetHeight() + padding

    local btnScale = state.buttonScale
    local gryphonScale = btnScale * 0.42

    local dx = padding + 15
    local dy = 6

    local rows = state.rows
    if rows > btnCount then rows = btnCount end

    local maxRowButtons = math.ceil(btnCount / rows)

    if state.hideScrolling then
        self.numberFrame:Hide()
    else
        self.numberFrame:Show()
    end

    if state.reverse then
        self.numberFrame:SetPoint('RIGHT', ActionButton12, 'LEFT')
    else
        self.numberFrame:SetPoint('RIGHT', ActionButton1, 'LEFT')
    end
end

function DragonflightUIActionbarMixin:AddDecoNew()
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'

    -- self.decoFrame:SetPoint('TOPLEFT')
    -- self.decoFrame:SetPoint('BOTTOMRIGHT')

    do
        self.decoFrame = CreateFrame('Frame', 'DragonflightUIMainActionBarDecoFrame', self)
        self.decoFrame:SetFrameStrata('LOW')
        self.decoFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
        self.decoFrame:SetSize(1, 1)
        self.decoFrame.decoTable = {}

        local tex = self.decoFrame:CreateTexture()

        -- tex:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\Actionbar-nineslice')
        -- tex:SetTextureSliceMargins(36, 36, 36, 36)

    end

    for k, v in ipairs(self.buttonTable) do
        local tex = v:CreateTexture('DragonflightUISlotDeco')
        v.DFDeco = tex
        tex:SetTexture(textureRef)
        tex:SetSize(45, 45 - 2)
        tex:SetPoint('TOPLEFT')
        tex:SetTexCoord(0.701171875, 0.951171875, 0.10205078125, 0.16259765625)
        tex:SetDrawLayer('BACKGROUND', -5)
        -- tex:SetFrameLevel('1')
    end

    --[[    for i = 1, 1 do
        local tex = self.decoFrame:CreateTexture()
        tex:SetTexture(textureRef)
        tex:SetSize(45, 45)
        -- tex:SetScale(1)
        tex:SetTexCoord(0.701171875, 0.951171875, 0.10205078125, 0.16259765625)
        self.decoFrame.decoTable[i] = tex
    end ]]
end

function DragonflightUIActionbarMixin:AddDeco()
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'

    self.decoFrame = CreateFrame('Frame', 'DragonflightUIMainActionBarDecoFrame')
    self.decoFrame:SetFrameStrata('LOW')
    self.decoFrame:SetPoint('CENTER')
    self.decoFrame.decoTable = {}

    for i = 1, 12 do

        local tex = self.decoFrame:CreateTexture()
        tex:SetTexture(textureRef)
        tex:SetSize(128, 124)
        tex:SetScale(0.3)
        tex:SetTexCoord(0.701171875, 0.951171875, 0.10205078125, 0.16259765625)
        self.decoFrame.decoTable[i] = tex
    end

    self.decoFrame.update = function(state)
        local a1, a2 = self:GetSize()
        self.decoFrame:SetSize(a1, a2)

        local padding = state.padding
        local btnSize = self.buttonTable[1]:GetWidth()

        for i = 1, 1 do

            local point, relativeTo, relativePoint, xOfs, yOfs = self.buttonTable[i]:GetPoint(1)

            local deco = self.decoFrame.decoTable[i]
            deco:Show()
            deco:ClearAllPoints()
            deco:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
            deco:SetSize(btnSize, btnSize)
            deco:SetScale(1)
        end
    end
end

function DragonflightUIActionbarMixin:StyleButtons()
    local count = #(self.buttonTable)
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar'
    local textureRefTwo = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'
    local maskRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbariconframemask'

    self.mask = self:CreateMaskTexture()
    self.mask:SetTexture(maskRef, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    self.mask:SetSize(45, 45)
    self.mask:SetPoint('CENTER')

    for i = 1, count do
        local btn = self.buttonTable[i]
        local btnName = btn:GetName()

        btn:SetSize(45, 45)
        -- print(btn:GetName())
        -- print(btn:GetName(), btn:GetAttribute("statehidden"))

        local icon = _G[btnName .. 'Icon']
        -- icon:ClearAllPoints()
        icon:SetSize(45, 45)
        -- icon:SetPoint('CENTER')
        -- icon:SetAlpha(0)
        btn.Icon = icon

        local mask = btn:CreateMaskTexture('DragonflightUIIconMask')
        btn.Mask = mask
        mask:SetAllPoints(icon)
        mask:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\maskNew')
        mask:SetSize(45, 45)

        icon:AddMaskTexture(mask)
        --[[  OLD: #hack
        -- mask
        do
              local mask = btn:CreateTexture('DragonflightUIMaskTexture')
            btn.DragonflightUIMaskTexture = mask
            mask:SetSize(45, 45)
            mask:SetPoint('CENTER', 0, 0)
            -- mask:SetColorTexture(0, 1, 0, 1)       
            mask:SetMask('Interface\\Addons\\DragonflightUI\\Textures\\maskNew')
            mask:SetDrawLayer('BACKGROUND')
            -- mask:SetTexture(136197)

            hooksecurefunc(icon, 'Show', function(self)
                local tex = self:GetTexture()
                if tex then
                    mask:Show()
                    mask:SetTexture(tex)
                end
            end) ]]
        --[[ 
            hooksecurefunc(icon, 'Hide', function(self)
                mask:Hide()
            end)
            hooksecurefunc(icon, 'SetVertexColor', function(self)
                local r, g, b = self:GetVertexColor()
                mask:SetVertexColor(r, g, b)
            end) 
        end
        ]]

        local cd = _G[btnName .. 'Cooldown']
        cd:SetSwipeTexture('Interface\\Addons\\DragonflightUI\\Textures\\maskNewAlpha')
        -- cd:GetSwipeTexture():SetAlpha(0.5)

        local floatingBG = _G[btnName .. 'FloatingBG']
        if floatingBG then
            floatingBG:ClearAllPoints()
            floatingBG:SetSize(46, 45)
            floatingBG:SetTexture(textureRef)
            floatingBG:SetTexCoord(0.707031, 0.886719, 0.401367, 0.445312)
            floatingBG:SetAllPoints()
        end

        -- TODO: better visibility
        -- iconframe-border
        local border = _G[btnName .. 'Border']
        border:ClearAllPoints()
        border:SetSize(46, 45)
        border:SetPoint('TOPLEFT')
        border:SetTexture(textureRefTwo)
        border:SetTexCoord(0.701171875, 0.880859375, 0.36181640625, 0.40576171875)
        border:SetDrawLayer('OVERLAY')

        -- iconframe
        local normal = btn:GetNormalTexture()
        normal:ClearAllPoints()
        normal:SetSize(46, 45)
        normal:SetPoint('TOPLEFT')
        normal:SetTexture(textureRefTwo)
        normal:SetTexCoord(0.701171875, 0.880859375, 0.31689453125, 0.36083984375)
        normal:SetAlpha(1)

        -- iconframe-down
        local pushed = btn:GetPushedTexture()
        pushed:ClearAllPoints()
        pushed:SetSize(46, 45)
        pushed:SetPoint('TOPLEFT')
        pushed:SetTexture(textureRefTwo)
        pushed:SetTexCoord(0.701171875, 0.880859375, 0.43017578125, 0.47412109375)

        -- iconframe-mouseover
        local highlight = btn:GetHighlightTexture()
        highlight:ClearAllPoints()
        highlight:SetSize(46, 45)
        highlight:SetPoint('TOPLEFT')
        highlight:SetTexture(textureRefTwo)
        highlight:SetTexCoord(0.701171875, 0.880859375, 0.52001953125, 0.56396484375)

        -- iconframe-mouseover
        local checked = btn:GetCheckedTexture()
        checked:ClearAllPoints()
        checked:SetSize(46, 45)
        checked:SetPoint('TOPLEFT')
        checked:SetTexture(textureRefTwo)
        checked:SetTexCoord(0.701171875, 0.880859375, 0.52001953125, 0.56396484375)

        btn.DragonflightFixHotkeyPosition = function()
            local hotkey = _G[btnName .. 'HotKey']
            hotkey:ClearAllPoints()
            hotkey:SetSize(32, 10)
            hotkey:SetPoint('TOPRIGHT', -5, -5)
        end
        btn.DragonflightFixHotkeyPosition()

        local name = _G[btnName .. 'Name']
        name:ClearAllPoints()
        name:SetSize(32, 10)
        name:SetPoint('BOTTOM', 0, 2)

        do
            local count = _G[btnName .. 'Count']
            count:ClearAllPoints()
            count:SetPoint('BOTTOMRIGHT', btn, 'BOTTOMRIGHT', -5, 5)
            local fontFile, fontHeight, flags = count:GetFont()
            count:SetFont(fontFile, 14 + 2, flags)
        end
    end
end

function DragonflightUIActionbarMixin:UpdateRange(btn, checksRange, inRange)
    local mask = btn.Icon
    if not mask then return end

    -- local normal = btn:GetNormalTexture()
    -- normal:SetVertexColor(0.5, 0.5, 1.0, 1.0)

    local isUsable, notEnoughMana = IsUsableAction(btn.action);

    -- mask:SetVertexColor(1.0, 1.0, 1.0, 1.0)
    -- mask:SetDesaturated(true)
    -- if true then return end
    if not isUsable then
        mask:SetVertexColor(0.4, 0.4, 0.4, 1.0)
        mask:SetDesaturated(true)
    elseif (checksRange) then
        if (inRange) then
            if notEnoughMana then
                mask:SetVertexColor(0.5, 0.5, 1.0, 1.0)
                mask:SetDesaturated(true)
            else
                mask:SetVertexColor(1.0, 1.0, 1.0, 1.0)
                mask:SetDesaturated(false)
            end
        else
            -- mask:SetVertexColor(1, 0.3, 0.1, 1)
            -- mask:SetVertexColor(0.9, 0.1, 0.1, 1)
            mask:SetVertexColor(1.0, 1.0, 1.0, 1.0)
            mask:SetDesaturated(true)
        end
    else
        if notEnoughMana then
            mask:SetVertexColor(0.5, 0.5, 1.0, 1.0)
            mask:SetDesaturated(true)
        else
            mask:SetVertexColor(1.0, 1.0, 1.0, 1.0)
            mask:SetDesaturated(false)
        end
    end
end

-- TODO only debug for now..
function DragonflightUIActionbarMixin:HookGrid()
    hooksecurefunc('ActionButton_ShowGrid', function(btn)
        if (btn.NormalTexture) then btn.NormalTexture:SetVertexColor(1.0, 1.0, 1.0, 1); end
    end)
end

DragonflightUIPetbarMixin = CreateFromMixins(DragonflightUIActionbarMixin)

--[[ function DragonflightUIPetbarMixin:Update()
    local state = self.state
    print("DragonflightUIPetbarMixin:Update()", state)
    DevTools_Dump(state)
end ]]

function DragonflightUIPetbarMixin:UpdateGrid()
end

