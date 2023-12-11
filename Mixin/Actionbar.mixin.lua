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

function DragonflightUIActionbarMixin:SetButtons(buttons)
    self.buttonTable = buttons
    print('DragonflightUIActionbarMixin:SetButtons(buttons)', #buttons)
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

    local btnSize = self.buttonTable[1]:GetWidth() * state.buttonScale

    local modulo = state.buttons % state.rows

    local buttons = state.buttons
    local rows = state.rows
    if rows > state.buttons then rows = buttons end

    local maxRowButtons = math.ceil(buttons / rows)
    -- print('maxRowButtons', maxRowButtons)

    local padding = state.padding
    local width = maxRowButtons * btnSize + (maxRowButtons + 1) * padding
    local height = rows * btnSize + (rows + 1) * padding

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
            local dx = j * padding + (j - 1) * btnSize
            local dy = i * padding + (i - 1) * btnSize

            if state.orientation == 'horizontal' then
                btn:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', dx, dy)
            else
                btn:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', dy, dx)
            end

            index = index + 1
        end
    end
end
