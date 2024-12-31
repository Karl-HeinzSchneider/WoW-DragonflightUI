DragonflightUIEditModeFrameMixin = {}

function DragonflightUIEditModeFrameMixin:OnLoad()
    self.InstructionText:SetText('InstructionText')
    self.CancelDescriptionText:SetText('')
    self.Header.Text:SetText('HUD Edit Mode')

    self.RevertButton:SetText('Revert All Changes');
    -- self.CancelButton:SetScript("OnClick", function(button, buttonName, down)
    --     self:CancelBinding();
    -- end);

    self.SaveButton:SetText('Save');
    -- self.OkayButton:SetScript("OnClick", function(button, buttonName, down)
    --     KeybindListener:Commit();

    --     HideUIPanel(self);
    -- end);

    local grid = CreateFrame('Frame', 'DragonflightUIGridFrame', UIParent, 'DragonflightUIEditModeGrid');
    grid:Show()
    grid:SetAllPoints();

    self.Grid = grid;

    local closeBtn = self.ClosePanelButton
    DragonflightUIMixin:UIPanelCloseButton(closeBtn)
    closeBtn:SetPoint('TOPRIGHT', 1, 0)
end

function DragonflightUIEditModeFrameMixin:OnDragStart()
    self:StartMoving()
end

function DragonflightUIEditModeFrameMixin:OnDragStop()
    self:StopMovingOrSizing()
end

DragonflightUIEditModeGridMixin = {}

function DragonflightUIEditModeGridMixin:OnLoad()
    self.linePool = DragonflightUIEditModeGridMixin:CreateLinePool(self, "DFEditModeGridLineTemplate");
    self:SetGridSpacing(20)

    self:RegisterEvent("DISPLAY_SIZE_CHANGED");
    self:RegisterEvent("UI_SCALE_CHANGED");
    hooksecurefunc("UpdateUIParentPosition", function()
        if self:IsShown() then self:UpdateGrid() end
    end);

    local function startTimer()
        C_Timer.After(1, function()
            local spacing = self.gridSpacing;
            self:SetGridSpacing(spacing + 5);
            startTimer()
        end)
    end
    -- startTimer()
end

function DragonflightUIEditModeGridMixin:OnHide()
    -- EditModeMagnetismManager:UnregisterGrid();
    self.linePool:ReleaseAll();
end

function DragonflightUIEditModeGridMixin:CreateLinePool(ownerFrame, template)
    local function resetLine(pool, line)
        line:Hide();
        line:ClearAllPoints();
    end

    local linePool = CreateObjectPool(function(pool)
        return ownerFrame:CreateLine(nil, nil, template);
    end, resetLine);

    return linePool;
end

function DragonflightUIEditModeGridMixin:SetGridSpacing(spacing)
    self.gridSpacing = spacing;
    self:UpdateGrid();
end

function DragonflightUIEditModeGridMixin:UpdateGrid()
    print('DragonflightUIEditModeGridMixin:UpdateGrid()')

    if not self:IsVisible() then return; end

    self.linePool:ReleaseAll();
    -- EditModeMagnetismManager:RegisterGrid(self:GetCenter());

    local centerLine = true;
    local centerLineNo = false;
    local verticalLine = true;
    local verticalLineNo = false;

    local centerVerticalLine = self.linePool:Acquire();
    centerVerticalLine:SetupLine(centerLine, verticalLine, 0, 0);
    centerVerticalLine:Show();

    local centerHorizontalLine = self.linePool:Acquire();
    centerHorizontalLine:SetupLine(centerLine, verticalLineNo, 0, 0);
    centerHorizontalLine:Show();

    local halfNumVerticalLines = floor((self:GetWidth() / self.gridSpacing) / 2);
    local halfNumHorizontalLines = floor((self:GetHeight() / self.gridSpacing) / 2);

    for i = 1, halfNumVerticalLines do
        local xOffset = i * self.gridSpacing;

        local line = self.linePool:Acquire();
        line:SetupLine(centerLineNo, verticalLine, xOffset, 0);
        line:Show();

        line = self.linePool:Acquire();
        line:SetupLine(centerLineNo, verticalLine, -xOffset, 0);
        line:Show();
    end

    for i = 1, halfNumHorizontalLines do
        local yOffset = i * self.gridSpacing;

        local line = self.linePool:Acquire();
        line:SetupLine(centerLineNo, verticalLineNo, 0, yOffset);
        line:Show();

        line = self.linePool:Acquire();
        line:SetupLine(centerLineNo, verticalLineNo, 0, -yOffset);
        line:Show();
    end
end

----------

DFEditModeGridLineMixin = {};

local editModeGridLinePixelWidth = 1.2;

local function SetupLineThickness(line, linePixelWidth)
    local lineThickness = PixelUtil.GetNearestPixelSize(linePixelWidth, line:GetEffectiveScale(), linePixelWidth);
    line:SetThickness(lineThickness);
end

function DFEditModeGridLineMixin:SetupLine(centerLine, verticalLine, xOffset, yOffset, grid)
    -- local color = centerLine and EDIT_MODE_GRID_CENTER_LINE_COLOR or EDIT_MODE_GRID_LINE_COLOR;
    -- self:SetColorTexture(color:GetRGBA());
    if centerLine then
        self:SetColorTexture(0.78431379795074, 0.27058824896812, 0.98039221763611, 0.49803924560547)
    else
        self:SetColorTexture(1, 1, 1, 0.24705883860588)
    end

    self:SetStartPoint(verticalLine and "TOP" or "LEFT", grid, xOffset, yOffset);
    self:SetEndPoint(verticalLine and "BOTTOM" or "RIGHT", grid, xOffset, yOffset);

    SetupLineThickness(self, editModeGridLinePixelWidth);

    -- EditModeMagnetismManager:RegisterGridLine(self, verticalLine, verticalLine and xOffset or yOffset);
end
