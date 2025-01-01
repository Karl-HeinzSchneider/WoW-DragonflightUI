local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

-- DragonflightUIEditModeFrameMixin = {}
DragonflightUIEditModeFrameMixin = CreateFromMixins(CallbackRegistryMixin);
DragonflightUIEditModeFrameMixin:GenerateCallbackEvents({"OnDefaults", "OnRefresh"});

function DragonflightUIEditModeFrameMixin:OnLoad()
    CallbackRegistryMixin.OnLoad(self);

    self:SetupFrame();

    local grid = CreateFrame('Frame', 'DragonflightUIGridFrame', UIParent, 'DragonflightUIEditModeGrid');
    grid:Hide()
    grid:SetAllPoints();

    self.Grid = grid;
end

function DragonflightUIEditModeFrameMixin:OnDragStart()
    self:StartMoving()
end

function DragonflightUIEditModeFrameMixin:OnDragStop()
    self:StopMovingOrSizing()
end

function DragonflightUIEditModeFrameMixin:SetupFrame()
    self.EditmodeModule = DF:GetModule('Editmode')

    self:SetFrameLevel(69)
    self:SetFrameStrata('HIGH')

    self.InstructionText:SetText('InstructionText')
    self.InstructionText:Hide()
    self.CancelDescriptionText:SetText('')
    self.Header.Text:SetText('HUD Edit Mode')

    self.RevertButton:SetText('Revert All Changes');
    self.RevertButton:SetEnabled(false);
    -- self.CancelButton:SetScript("OnClick", function(button, buttonName, down)
    --     self:CancelBinding();
    -- end);

    self.SaveButton:SetText('Save');
    self.SaveButton:SetEnabled(false);
    -- self.OkayButton:SetScript("OnClick", function(button, buttonName, down)
    --     KeybindListener:Commit();

    --     HideUIPanel(self);
    -- end);

    local closeBtn = self.ClosePanelButton
    DragonflightUIMixin:UIPanelCloseButton(closeBtn)
    closeBtn:SetPoint('TOPRIGHT', 1, 0)
    closeBtn:SetScript('OnClick', function(button, buttonName, down)
        --
        print('onclick')
        self.EditmodeModule:SetEditMode(false);
    end)
end

function DragonflightUIEditModeFrameMixin:SetupOptions(data)
    local displayFrame = CreateFrame('Frame', 'DragonflightUIEditModeSettingsList', self, 'SettingsListTemplateDF')
    displayFrame:Display(data)

    displayFrame:ClearAllPoints()
    -- -@diagnostic disable-next-line: param-type-mismatch
    -- displayFrame:SetParent(self)
    displayFrame:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)
    displayFrame:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0)
    displayFrame:CallRefresh()
    displayFrame:Show()

    local scrollBox = displayFrame.ScrollBox
    scrollBox:ClearAllPoints()
    scrollBox:SetPoint('TOPLEFT', self, 'TOPLEFT', -2, -50)
    scrollBox:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -8, 20)

    -- displayFrame.Header.DefaultsButton:Hide()
    displayFrame.Header:Hide()
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
    -- print('DragonflightUIEditModeGridMixin:UpdateGrid()')

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
