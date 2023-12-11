DragonflightUIActionbarMixin = {}

function DragonflightUIActionbarMixin:Init()
    self:SetPoint('BOTTOMLEFT', UIParent, 'CENTER', 0, 380)
    self:SetSize(250, 142)

    self.box = CreateFrame('FRAME')
    self.box:SetParent(self)
    self.box:SetAllPoints()
    self.box:SetFrameLevel(42)
    self.box:SetFrameStrata('HIGH')

    self.box.texture = self.box:CreateTexture(nil, 'OVERLAY')
    self.box.texture:SetAllPoints()
    self.box.texture:SetColorTexture(0, 0.8, 0, 0.42)
end

function DragonflightUIActionbarMixin:ShowHighlight(show)
    self.box:SetShown(show)
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
    self:Update()
end

function DragonflightUIActionbarMixin:Update()
    local state = self.state
    -- print("DragonflightUIActionbarMixin:Update()", state)
    -- DevTools_Dump(state)

    local btnScale = state.buttonScale
    local btnSize = self.buttonTable[1]:GetWidth()
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

    for i = buttons + 1, 12 do
        local btn = self.buttonTable[i]
        btn:ClearAllPoints()
        btn:Hide()
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
            local btn = self.buttonTable[index]
            -- print('btn', i, btn:GetName())
            btn:ClearAllPoints()
            btn:Show()
            btn:SetScale(btnScale)
            local dx = (2 * j - 1) * padding + (j - 1) * btnSize
            local dy = (2 * i - 1) * padding + (i - 1) * btnSize

            if state.orientation == 'horizontal' then
                btn:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', dx, dy)
            else
                btn:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', dy, dx)
            end

            -- ActionButton_ShowGrid(btn)
            -- btn:SetAttribute('showgrid', 1)

            index = index + 1
        end
    end
    self:ShowHighlight(true)

    -- print(self.buttonTable[1]:GetName(), 'update')
    -- self:UpdateGrid(state.alwaysShow)
end

function DragonflightUIActionbarMixin:UpdateGrid(show)
    for k, v in pairs(self.buttonTable) do
        -- print(k, v:GetName(), show)
        if show then
            v:SetAttribute('showgrid', 1)
        else
            v:SetAttribute('showgrid', 0)
        end
        ActionButton_Update(v)
    end

    for i = self.state.buttons + 1, 12 do
        local btn = self.buttonTable[i]
        btn:Hide()
    end
end
