local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
-- local EditModeModule = DF:GetModule('Editmode');
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

-- DragonflightUIEditModeFrameMixin = {}
DragonflightUIEditModeFrameMixin = CreateFromMixins(CallbackRegistryMixin);
DragonflightUIEditModeFrameMixin:GenerateCallbackEvents({"OnDefaults", "OnRefresh"});

function DragonflightUIEditModeFrameMixin:OnLoad()
    CallbackRegistryMixin.OnLoad(self);

    self:SetupFrame();
end

function DragonflightUIEditModeFrameMixin:SetupGrid()
    local grid = CreateFrame('Frame', 'DragonflightUIGridFrame', UIParent, 'DragonflightUIEditModeGrid');
    grid:Hide()
    grid:SetAllPoints();

    self.Grid = grid;
end

function DragonflightUIEditModeFrameMixin:SetupMouseOverChecker()
    local over = CreateFrame('Frame', 'DragonflightUIEditModeMouseOverChecker', self,
                             'DFEditModeSystemSelectionMouseOverChecker');
    -- grid:Hide()
    over:SetAllPoints();

    self.MouseOverChecker = over;
end

function DragonflightUIEditModeFrameMixin:SetupLayoutDropdown()
    -- print('~~~~SetupLayoutDropdown()')
    local dd = CreateFrame('Frame', 'DragonflightUIEditModeLayoutDropdown', self,
                           'DragonflightUIEditModeLayoutDropdownTemplate');
    -- grid:Hide()
    -- dd:SetAllPoints();
    dd:SetPoint('TOPLEFT', self, 'TOPLEFT', 32, -38)
    dd:SetSize(155, 25)

    self.LayoutDropdown = dd;
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
    local windowH = 250 - 35 + 20
    local windowHAdv = 450
    self:SetHeight(windowH);

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
        -- print('onclick')
        self.EditmodeModule:SetEditMode(false);
    end)

    self.AdvancedOptions = false;
    local advButton = self.AdvancedButton
    advButton:Show()
    advButton:SetText(L["EditModeAdvancedOptions"])
    advButton:SetScript('OnClick', function(button, buttonName, down)
        --
        -- print('onclick')
        if self.AdvancedOptions then
            -- switch to basic options
            advButton:SetText(L["EditModeAdvancedOptions"])
            self.DisplayFrame:Display(self.DataOptions, true)
            self:SetHeight(windowH);
            self.DisplayFrame:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0)
        else
            -- switch to advanced options
            advButton:SetText(L["EditModeBasicOptions"])
            self.DisplayFrame:Display(self.DataAdvancedOptions, true)
            self:SetHeight(windowHAdv);
            self.DisplayFrame:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0 + 24)
        end
        self.AdvancedOptions = not self.AdvancedOptions;

    end)
end

function DragonflightUIEditModeFrameMixin:SetupOptions(data, main)
    local displayFrame = CreateFrame('Frame', 'DragonflightUIEditModeSettingsList', self, 'DFSettingsList')
    displayFrame:Display(data, true)
    self.DisplayFrame = displayFrame
    self.DataOptions = data;

    displayFrame:ClearAllPoints()
    -- -@diagnostic disable-next-line: param-type-mismatch
    -- displayFrame:SetParent(self)
    displayFrame:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)
    displayFrame:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0)
    -- displayFrame:CallRefresh()
    displayFrame:Show()

    local scrollBox = displayFrame.ScrollBox
    scrollBox:ClearAllPoints()
    if main then
        scrollBox:SetPoint('TOPLEFT', displayFrame, 'TOPLEFT', -2, -50 - 20)
    else
        scrollBox:SetPoint('TOPLEFT', displayFrame, 'TOPLEFT', -2, -50)
    end
    scrollBox:SetPoint('BOTTOMRIGHT', displayFrame, 'BOTTOMRIGHT', -8 - 18, 20 + 10)

    displayFrame.Header.DefaultsButton:Hide()
    displayFrame.Header:Hide()
end

function DragonflightUIEditModeFrameMixin:SetupAdvancedOptions(data)
    self.DataAdvancedOptions = data;
end

function DragonflightUIEditModeFrameMixin:SetupExtraOptions(data)
    local displayFrame = CreateFrame('Frame', 'DragonflightUIEditModeSettingsListExtra', self, 'DFSettingsList')
    displayFrame:Display(data, true)
    self.DisplayFrameExtra = displayFrame
    self.DataExtraOptions = data;

    displayFrame:ClearAllPoints()
    -- -@diagnostic disable-next-line: param-type-mismatch
    -- displayFrame:SetParent(self)
    displayFrame:SetPoint('TOPLEFT', self.DisplayFrame, 'BOTTOMLEFT', 0, 80 + 10)
    displayFrame:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0)
    -- displayFrame:CallRefresh()
    displayFrame:Show()

    local scrollBox = displayFrame.ScrollBox
    scrollBox:ClearAllPoints()
    scrollBox:SetPoint('TOPLEFT', displayFrame, 'TOPLEFT', -2, -50)
    scrollBox:SetPoint('BOTTOMRIGHT', displayFrame, 'BOTTOMRIGHT', -8 - 18, 20 + 10)

    displayFrame.Header.DefaultsButton:Hide()
    displayFrame.Header:Hide()
end

DragonflightUIEditModeSelectionOptionsMixin = {}

function DragonflightUIEditModeSelectionOptionsMixin:SetupFrame()
    self.EditmodeModule = DF:GetModule('Editmode')

    self:SetFrameLevel(69 + 5)
    self:SetFrameStrata('HIGH')
    self:SetPoint('CENTER', 0 + 450, 150)

    self.InstructionText:SetText('InstructionTextsss')
    self.InstructionText:Hide()
    self.CancelDescriptionText:SetText('')
    self.Header.Text:SetText('HUD Edit Modesss')

    self.RevertButton:SetText('Revert All Changes');
    self.RevertButton:SetEnabled(false);
    -- self.CancelButton:SetScript("OnClick", function(button, buttonName, down)
    --     self:CancelBinding();
    -- end);
    self.RevertButton:Hide();

    self.SaveButton:SetText('Save');
    self.SaveButton:SetEnabled(false);
    -- self.OkayButton:SetScript("OnClick", function(button, buttonName, down)
    --     KeybindListener:Commit();

    --     HideUIPanel(self);
    -- end);
    self.SaveButton:Hide();

    local closeBtn = self.ClosePanelButton
    DragonflightUIMixin:UIPanelCloseButton(closeBtn)
    closeBtn:SetPoint('TOPRIGHT', 1, 0)
    closeBtn:SetScript('OnClick', function(button, buttonName, down)
        --
        -- print('onclick')
        -- self.EditmodeModule:SetEditMode(false);
        self.EditmodeModule:SelectFrame(nil);
    end)
end

DragonflightUIEditModeGridMixin = {}

function DragonflightUIEditModeGridMixin:OnLoad()
    self.linePool = DragonflightUIEditModeGridMixin:CreateLinePool(self, "DFEditModeGridLineTemplate");
    self:SetGridSpacing(20)

    self:RegisterEvent("DISPLAY_SIZE_CHANGED");
    self:RegisterEvent("UI_SCALE_CHANGED");
    if UpdateUIParentPosition then
        hooksecurefunc("UpdateUIParentPosition", function()
            if self:IsShown() then self:UpdateGrid() end
        end);
    end
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

----------

DFEditModeSystemSelectionBaseMixin = {};

function DFEditModeSystemSelectionBaseMixin:OnLoad()
    self.parent = self:GetParent();
    self.parent.DFEditModeSelection = self;
    self.IsDFEditModeSelection = true;
    -- print('DFEditModeSystemSelectionBaseMixin:OnLoad()', self.parent:GetName())
    if self.Label then
        self.Label:SetFontObjectsToTry("GameFontHighlightLarge", "GameFontHighlightMedium", "GameFontHighlightSmall");
        -- self.Label:SetText('PlayerFrame')
        -- self.Label:Show()
    end
    if self.HorizontalLabel then
        self.HorizontalLabel:SetFontObjectsToTry("GameFontHighlightLarge", "GameFontHighlightMedium",
                                                 "GameFontHighlightSmall");
    end
    -- self:SetIgnoreParentScale()
    self:SetPoint('TOPLEFT', self.parent, 'TOPLEFT', 0, 0)
    self:SetPoint('BOTTOMRIGHT', self.parent, 'BOTTOMRIGHT', 0, 0)

    self:AddNineslice()
    self:SetNinesliceSelected(false)

    local EditModeModule = DF:GetModule('Editmode');
    table.insert(EditModeModule.SelectionFrames, self);

    EditModeModule:RegisterCallback('OnEditMode', function(self, editValue)
        -- print('SELECTION: OnEditMode', value)
        local db = EditModeModule.db.profile
        local state = db.advanced

        local value = editValue and state[self.AdvancedName]

        self:ShowHighlighted()
        self:SetShown(value)

        if value then
            self.parent.DFEditMode = true;
            if self.parent.SetEditMode then
                self.parent:SetEditMode(true)
            else
                self.parent:Show();
            end
            -- self:SetFrameLevel(self.Prio or 1000)

            if self.ModuleRef then
                --            
                local db = self.ModuleRef.db.profile[self.ModuleSub]
                if db then db.EditModeActive = true; end
                -- 
                if self.ShowFunction then
                    self.ShowFunction();
                else
                    self.ModuleRef:ApplySettings(self.ModuleSub or false);
                end
            end
        else
            self.parent.DFEditMode = false;
            if self.parent.SetEditMode then
                self.parent:SetEditMode(false)
            else
                self.parent:Hide()
            end
            if self.ModuleRef then
                --            
                local db = self.ModuleRef.db.profile[self.ModuleSub]
                if db then db.EditModeActive = false; end
                -- self.ModuleRef:ApplySettings(self.ModuleSub or false)
                if self.HideFunction then
                    self.HideFunction();
                else
                    self.ModuleRef:ApplySettings(self.ModuleSub or false);
                end
            end

        end
    end, self)

    EditModeModule:RegisterCallback('OnSelection', function(self, value)
        -- self:SetFrameLevel(self.Prio or 1000)
        if value and value == self then
            DF:Debug(EditModeModule, 'SELECTION', value:GetName())
            self:ShowSelected()
        else
            local db = EditModeModule.db.profile
            local state = db.advanced

            if state[self.AdvancedName] then
                -- 
                self:ShowHighlighted()
            else
                -- deactivated ~> dont change
            end
        end
    end, self)

    -- self:SetMovable(true)
    -- self:EnableMouse(true)      
    self:RegisterForDrag("LeftButton")
    -- self:SetClampedToScreen(true) --TODO
end

function DFEditModeSystemSelectionBaseMixin:OnEnter()
    if self.getLabelText then self.Label:SetText(self.getLabelText()); end

    self.Label:SetShown(true);
end

function DFEditModeSystemSelectionBaseMixin:OnLeave()
    self:UpdateLabelVisibility()
end

function DFEditModeSystemSelectionBaseMixin:AddNineslice()
    self.NineSlice = {}
    local slice = self.NineSlice

    slice.TopLeftCorner = self:CreateTexture('TopLeftCorner')
    slice.TopLeftCorner:SetSize(16, 16)
    slice.TopLeftCorner:SetPoint('TOPLEFT', -8, 8)

    slice.TopRightCorner = self:CreateTexture('TopRightCorner')
    slice.TopRightCorner:SetSize(16, 16)
    slice.TopRightCorner:SetPoint('TOPRIGHT', 8, 8)
    slice.TopRightCorner:SetRotation(-math.pi / 2)

    slice.BottomLeftCorner = self:CreateTexture('BottomLeftCorner')
    slice.BottomLeftCorner:SetSize(16, 16)
    slice.BottomLeftCorner:SetPoint('BOTTOMLEFT', -8, -8)
    slice.BottomLeftCorner:SetRotation(math.pi / 2)

    slice.BottomRightCorner = self:CreateTexture('BottomRightCorner')
    slice.BottomRightCorner:SetSize(16, 16)
    slice.BottomRightCorner:SetPoint('BOTTOMRIGHT', 8, -8)
    slice.BottomRightCorner:SetRotation(-math.pi)

    slice.TopEdge = self:CreateTexture('TopEdge')
    slice.TopEdge:SetPoint('TOPLEFT', slice.TopLeftCorner, 'TOPRIGHT')
    slice.TopEdge:SetPoint('BOTTOMRIGHT', slice.TopRightCorner, 'BOTTOMLEFT')

    slice.BottomEdge = self:CreateTexture('BottomEdge')
    slice.BottomEdge:SetPoint('TOPLEFT', slice.BottomLeftCorner, 'TOPRIGHT')
    slice.BottomEdge:SetPoint('BOTTOMRIGHT', slice.BottomRightCorner, 'BOTTOMLEFT')

    slice.LeftEdge = self:CreateTexture('LeftEdge')
    slice.LeftEdge:SetPoint('TOPLEFT', slice.TopLeftCorner, 'BOTTOMLEFT')
    slice.LeftEdge:SetPoint('BOTTOMRIGHT', slice.BottomLeftCorner, 'TOPRIGHT')

    slice.RightEdge = self:CreateTexture('RightEdge')
    slice.RightEdge:SetPoint('TOPLEFT', slice.TopRightCorner, 'BOTTOMLEFT')
    slice.RightEdge:SetPoint('BOTTOMRIGHT', slice.BottomRightCorner, 'TOPRIGHT')

    slice.Center = self:CreateTexture('Center')
    slice.Center:SetSize(16, 16)
    -- slice.Center:SetPoint('TOPLEFT', -8, 8)
    -- slice.Center:SetPoint('BOTTOMRIGHT', 8, -8)
    slice.Center:SetPoint('TOPLEFT', 0, 0)
    slice.Center:SetPoint('BOTTOMRIGHT', 0, 0)
end

-- ["Interface/Editmode/EditModeUI"]={
--     ["editmode-actionbar-highlight-nineslice-corner"]={16, 16, 0.03125, 0.53125, 0.285156, 0.347656, false, false, "1x"},
--     ["_editmode-actionbar-highlight-nineslice-edgebottom"]={16, 16, 0, 0.5, 0.00390625, 0.0664062, true, false, "1x"},
--     ["_editmode-actionbar-highlight-nineslice-edgetop"]={16, 16, 0, 0.5, 0.0742188, 0.136719, true, false, "1x"},
--     ["editmode-actionbar-selected-nineslice-corner"]={16, 16, 0.03125, 0.53125, 0.355469, 0.417969, false, false, "1x"},
--     ["_editmode-actionbar-selected-nineslice-edgebottom"]={16, 16, 0, 0.5, 0.144531, 0.207031, true, false, "1x"},
--     ["_editmode-actionbar-selected-nineslice-edgetop"]={16, 16, 0, 0.5, 0.214844, 0.277344, true, false, "1x"},
--     ["editmode-down-arrow"]={16, 11, 0.03125, 0.53125, 0.566406, 0.609375, false, false, "1x"},
--     ["editmode-up-arrow"]={16, 11, 0.03125, 0.53125, 0.617188, 0.660156, false, false, "1x"},
--     ["editmode-new-layout-plus-disabled"]={16, 16, 0.03125, 0.53125, 0.425781, 0.488281, false, false, "1x"},
--     ["editmode-new-layout-plus"]={16, 16, 0.03125, 0.53125, 0.496094, 0.558594, false, false, "1x"},
-- }, -- Interface/Editmode/EditModeUI
-- ["Interface/Editmode/EditModeUIHighlightBackground"]={
--     ["editmode-actionbar-highlight-nineslice-center"]={16, 16, 0, 1, 0, 1, true, true, "1x"},
-- }, -- Interface/Editmode/EditModeUIHighlightBackground
-- ["Interface/Editmode/EditModeUISelectedBackground"]={
--     ["editmode-actionbar-selected-nineslice-center"]={16, 16, 0, 1, 0, 1, true, true, "1x"},
-- }, -- Interface/Editmode/EditModeUISelectedBackground
-- ["Interface/Editmode/EditModeUIVertical"]={
--     ["!editmode-actionbar-highlight-nineslice-edgeleft"]={16, 16, 0.0078125, 0.132812, 0, 1, false, true, "1x"},
--     ["!editmode-actionbar-highlight-nineslice-edgeright"]={16, 16, 0.148438, 0.273438, 0, 1, false, true, "1x"},
--     ["!editmode-actionbar-selected-nineslice-edgeleft"]={16, 16, 0.289062, 0.414062, 0, 1, false, true, "1x"},
--     ["!editmode-actionbar-selected-nineslice-edgeright"]={16, 16, 0.429688, 0.554688, 0, 1, false, true, "1x"},
-- }, -- Interface/Editmode/EditModeUIVertical

function DFEditModeSystemSelectionBaseMixin:SetNinesliceSelected(selected)
    -- print('DFEditModeSystemSelectionBaseMixin:SetNinesliceSelected(selected)', selected)
    local slice = self.NineSlice
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\Editmode\\'

    if selected then
        --
        slice.TopLeftCorner:SetTexture(base .. 'EditModeUI')
        slice.TopLeftCorner:SetTexCoord(0.03125, 0.53125, 0.355469, 0.417969)
        slice.TopRightCorner:SetTexture(base .. 'EditModeUI')
        slice.TopRightCorner:SetTexCoord(0.03125, 0.53125, 0.355469, 0.417969)
        slice.BottomLeftCorner:SetTexture(base .. 'EditModeUI')
        slice.BottomLeftCorner:SetTexCoord(0.03125, 0.53125, 0.355469, 0.417969)
        slice.BottomRightCorner:SetTexture(base .. 'EditModeUI')
        slice.BottomRightCorner:SetTexCoord(0.03125, 0.53125, 0.355469, 0.417969)

        slice.TopEdge:SetTexture(base .. 'EditModeUI')
        slice.TopEdge:SetTexCoord(0, 0.5, 0.214844, 0.277344)
        slice.BottomEdge:SetTexture(base .. 'EditModeUI')
        slice.BottomEdge:SetTexCoord(0, 0.5, 0.144531, 0.207031)

        slice.LeftEdge:SetTexture(base .. 'EditModeUIVertical')
        slice.LeftEdge:SetTexCoord(0.289062, 0.414062, 0, 1)
        slice.RightEdge:SetTexture(base .. 'EditModeUIVertical')
        slice.RightEdge:SetTexCoord(0.429688, 0.554688, 0, 1)

        slice.Center:SetTexture(base .. 'editmodeuiselectedbackground')
        slice.Center:SetTexCoord(0, 1, 0, 1)
    else
        --
        slice.TopLeftCorner:SetTexture(base .. 'EditModeUI')
        slice.TopLeftCorner:SetTexCoord(0.03125, 0.53125, 0.285156, 0.347656)
        slice.TopRightCorner:SetTexture(base .. 'EditModeUI')
        slice.TopRightCorner:SetTexCoord(0.03125, 0.53125, 0.285156, 0.347656)
        slice.BottomLeftCorner:SetTexture(base .. 'EditModeUI')
        slice.BottomLeftCorner:SetTexCoord(0.03125, 0.53125, 0.285156, 0.347656)
        slice.BottomRightCorner:SetTexture(base .. 'EditModeUI')
        slice.BottomRightCorner:SetTexCoord(0.03125, 0.53125, 0.285156, 0.347656)

        slice.TopEdge:SetTexture(base .. 'EditModeUI')
        slice.TopEdge:SetTexCoord(0, 0.5, 0.0742188, 0.136719)
        slice.BottomEdge:SetTexture(base .. 'EditModeUI')
        slice.BottomEdge:SetTexCoord(0, 0.5, 0.00390625, 0.0664062)

        slice.LeftEdge:SetTexture(base .. 'EditModeUIVertical')
        slice.LeftEdge:SetTexCoord(0.0078125, 0.132812, 0, 1)
        slice.RightEdge:SetTexture(base .. 'EditModeUIVertical')
        slice.RightEdge:SetTexCoord(0.148438, 0.273438, 0, 1)

        slice.Center:SetTexture(base .. 'EditModeUIHighlightBackground')
        slice.Center:SetTexCoord(0, 1, 0, 1)
    end
end

function DFEditModeSystemSelectionBaseMixin:ShowHighlighted()
    -- NineSliceUtil.ApplyLayout(self, EditModeSystemSelectionLayout, self.highlightTextureKit);
    self:SetNinesliceSelected(false);
    self.isSelected = false;
    self:UpdateLabelVisibility();
    -- self:SetFrameStrata('MEDIUM')
    self:Show();
    if self.SelectionOptions then
        -- self:RefreshOptionScreen();
        self.SelectionOptions:Hide()
    end
end

function DFEditModeSystemSelectionBaseMixin:ShowSelected()
    -- NineSliceUtil.ApplyLayout(self, EditModeSystemSelectionLayout, self.selectedTextureKit);
    self:SetNinesliceSelected(true);
    self.isSelected = true;
    self:UpdateLabelVisibility();
    -- self:SetFrameStrata('HIGH')
    self:Show();
    if self.SelectionOptions then
        self:RefreshOptionScreen();
        self.SelectionOptions:Show()
    end
end

function DFEditModeSystemSelectionBaseMixin:OnUpdate()
    if self.isDragging then
        --
        -- print('drag drag')
        -- local anchor, anchorFrame, anchorParent, xxx, yyy = self:CalcSnapParentToGrid()
        -- self:SetPoint(anchor, anchorFrame, anchorParent, xxx, yyy)
    end
end

function DFEditModeSystemSelectionBaseMixin:CalcSnapParentToGrid()
    local EditModeModule = DF:GetModule('Editmode')
    local state = EditModeModule.db.profile.general;

    local gridSize = state.gridSize;

    if not state.snapGrid then gridSize = 1 end

    local scale = self.parent:GetScale()
    local effectiveScale, screenScale = self.parent:GetEffectiveScale(), UIParent:GetEffectiveScale()
    local screenW = GetScreenWidth() * (screenScale / effectiveScale)
    local screenH = GetScreenHeight() * (screenScale / effectiveScale)

    local x, y = self.parent:GetCenter()
    local centerX = x - screenW / 2
    local centerY = y - screenH / 2

    -- db.anchor = 'CENTER';
    -- db.anchorFrame = 'UIParent';
    -- db.anchorParent = 'CENTER';
    -- db.x = self:SnapToGrid(centerX, gridSize / scale)
    -- db.y = self:SnapToGrid(centerY, gridSize / scale)

    return 'CENTER', 'UIParent', 'CENTER', self:SnapToGrid(centerX, gridSize / scale),
           self:SnapToGrid(centerY, gridSize / scale)
end

function DFEditModeSystemSelectionBaseMixin:SnapToGrid(value, gridSize)
    return math.floor((value + gridSize / 2) / gridSize) * gridSize
end

function DFEditModeSystemSelectionBaseMixin:OnDragStart()
    if not self.isSelected then return end
    -- self.parent:OnDragStart();
    local x, y = self:GetCenter()

    self.StartX = x;
    self.StartY = y;

    -- self:StartMoving()
    local parent = self.parent;
    self.StartMovable = parent:IsMovable()

    self.parent:SetMovable(true)
    self.parent:RegisterForDrag("LeftButton")

    if self.parentExtra then
        local parentExtra = self.parentExtra;
        -- self.StartMovableExtra = parentExtra:IsMovable()
        -- self.parentExtra:SetMovable(true)
        -- self.parentExtra:StartMoving()
        parentExtra:ClearAllPoints()
        parentExtra:SetPoint('CENTER', self, 'CENTER', 0, 0)
    end

    self.isDragging = true;
    self.parent:StartMoving()

    if self.DragStartFunc then self.DragStartFunc(); end
end

function DFEditModeSystemSelectionBaseMixin:OnDragStop()
    -- print('DFEditModeSystemSelectionBaseMixin:OnDragStop()')
    if not self.isSelected or not self.isDragging then return end
    self.isDragging = false;
    -- self.parent:OnDragStop();
    local parent = self.parent;
    local EditModeModule = DF:GetModule('Editmode')
    local state = EditModeModule.db.profile.general;

    self:StopMovingOrSizing()
    parent:StopMovingOrSizing()
    self.parent:SetMovable(self.StartMovable)

    if self.parentExtra then
        -- self.parentExtra:StopMovingOrSizing()
        -- self.parentExtra:SetMovable(self.StartMovableExtra)
    end

    -- local x, y = self:GetCenter()
    -- local dx = self.StartX - x;
    -- local dy = self.StartY - y;

    if not self.ModuleRef then return end

    local db;
    if self.ModuleSub then
        db = self.ModuleRef.db.profile[self.ModuleSub]
    else
        db = self.ModuleRef.db.profile
    end
    if not db then return end

    -- local gridSize = state.gridSize;

    -- if not state.snapGrid then gridSize = 1 end

    -- local scale = self.parent:GetScale()
    -- local effectiveScale, screenScale = self.parent:GetEffectiveScale(), UIParent:GetEffectiveScale()
    -- local screenW = GetScreenWidth() * (screenScale / effectiveScale)
    -- local screenH = GetScreenHeight() * (screenScale / effectiveScale)

    -- x, y = self.parent:GetCenter()
    -- local centerX = x - screenW / 2
    -- local centerY = y - screenH / 2

    -- db.anchor = 'CENTER';
    -- db.anchorFrame = 'UIParent';
    -- db.anchorParent = 'CENTER';
    -- db.x = self:SnapToGrid(centerX, gridSize / scale)
    -- db.y = self:SnapToGrid(centerY, gridSize / scale)

    local anchor, anchorFrame, anchorParent, xxx, yyy = self:CalcSnapParentToGrid()

    db.anchor = anchor;
    db.anchorFrame = anchorFrame;
    db.anchorParent = anchorParent;
    db.x = xxx
    db.y = yyy

    self.ModuleRef:ApplySettings(self.ModuleSub or false)
    self.ModuleRef:RefreshOptionScreens()
    parent:Show()

    if self.DragStopFunc then self.DragStopFunc(); end
end

function DFEditModeSystemSelectionBaseMixin:OnMouseDown()
    -- EditModeManagerFrame:SelectSystem(self.parent);
    -- print('DFEditModeSystemSelectionBaseMixin:OnMouseDown()')
    -- self:SetNinesliceSelected(true)
    local EditModeModule = DF:GetModule('Editmode');
    EditModeModule:SelectFrame(self)
end

function DFEditModeSystemSelectionBaseMixin:SetGetLabelTextFunction(getLabelText)
    self.getLabelText = getLabelText;
end

function DFEditModeSystemSelectionBaseMixin:UpdateLabelVisibility()
    if self.getLabelText then self.Label:SetText(self.getLabelText()); end

    self.Label:SetShown(self.isSelected);
end

function DFEditModeSystemSelectionBaseMixin:RegisterOptions(data)
    -- print('DFEditModeSystemSelectionBaseMixin:RegisterOptions(data)')
    -- DevTools_Dump(data)
    self.parentExtra = data.parentExtra

    self.AdvancedName = data.advancedName;
    self.ModuleRef = data.moduleRef;
    self.ModuleSub = data.sub;

    local db = self.ModuleRef.db.profile[self.ModuleSub]
    if db then db.EditModeActive = false; end

    self.ShowFunction = data.showFunction;
    self.HideFunction = data.hideFunction;
    self.DragStopFunc = data.dragStopFunction;
    self.DragStartFunc = data.dragStartFunction;

    local editModeFrame = CreateFrame('Frame', 'DragonflightUIEditModeFrame', UIParent,
                                      'DragonflightUIEditModeSelectionOptionsTemplate');
    editModeFrame:ClearAllPoints()
    editModeFrame:SetPoint('TOP', UIParent, 'TOP', 0, -100)
    local dx = 4 + editModeFrame:GetWidth() / 2
    editModeFrame:SetPoint('LEFT', UIParent, 'CENTER', dx, 0)
    editModeFrame.Header.Text:SetText(data.name)
    editModeFrame.BG.Bg:SetVertexColor(1, 0, 0, 1) -- TODO?
    self.SelectionOptions = editModeFrame

    local filteredData = {name = data.name, sub = data.sub, default = data.default}

    local filteredOptions = {
        type = data.options.type,
        name = data.options.name,
        get = data.options.get,
        set = data.options.set,
        args = {}
    }
    local numOptions = 0;
    local elementH = 0;
    local elementSize = DFSettingsListMixin.ElementSize;

    for k, v in pairs(data.options.args) do
        if v.editmode then
            filteredOptions.args[k] = v
            numOptions = numOptions + 1
            if numOptions < 11 then
                elementH = elementH + elementSize[v.type] + 9
            else
            end
        end
    end

    filteredData.options = filteredOptions
    editModeFrame:SetupOptions(filteredData)
    editModeFrame:Hide()

    numOptions = math.min(numOptions, 10)

    -- 9 = spacing, 11 = verticalPad + 1
    local optionsH = elementH + 11

    local displayFrame = editModeFrame.DisplayFrame
    displayFrame:ClearAllPoints()
    -- -@diagnostic disable-next-line: param-type-mismatch
    -- displayFrame:SetParent(self)
    displayFrame:SetPoint('TOPLEFT', editModeFrame, 'TOPLEFT', 0, 0)
    displayFrame:SetPoint('BOTTOMRIGHT', editModeFrame, 'TOPRIGHT', 0, -80 - optionsH)
    displayFrame:SetHeight(optionsH)

    if numOptions == 0 then displayFrame:Hide() end

    local extraH = 0;
    local extraElementH = 0;
    if data.extra then
        --  
        local extraData = {name = data.name, sub = data.sub, default = data.default, hideDefault = true}

        local extraOptions = {
            type = data.extra.type,
            name = data.extra.name,
            get = data.extra.get,
            set = data.extra.set,
            args = {divider = {type = 'divider', name = '*divider*', desc = '***', order = 1, editmode = true}}
        }

        local numExtraOptions = 0;
        for k, v in pairs(data.extra.args) do
            if v.editmode then
                extraOptions.args[k] = v
                numExtraOptions = numExtraOptions + 1
                extraElementH = extraElementH + elementSize[v.type] + 9
            end
        end
        extraData.options = extraOptions
        editModeFrame:SetupExtraOptions(extraData)

        -- 26 = divider
        extraH = 26 + extraElementH + 11
    end

    local newH = 80 + optionsH + extraH
    editModeFrame:SetHeight(newH)

    self.Prio = 1000 + (data.prio or 0)
    -- self:SetFrameLevel(self.Prio)
end

function DFEditModeSystemSelectionBaseMixin:RefreshOptionScreen()
    -- print('---DFEditModeSystemSelectionBaseMixin:RefreshOptionScreen()---')
    -- self.SelectionOptions
    self.SelectionOptions.DisplayFrame:CallRefresh()
end

----------

DFEditModeSystemSelectionMouseOverCheckerMixin = {};

function DFEditModeSystemSelectionMouseOverCheckerMixin:OnLoad()
    -- print('~~DFEditModeSystemSelectionMouseOverCheckerMixin:OnLoad()')
    self.timeElapsed = 0
    self.EditModeRef = DF:GetModule('Editmode');

    local fontStr = self:GetParent():CreateFontString(nil, 'OVERLAY', 'GameFontNormalLarge')
    fontStr:SetPoint('TOP', self:GetParent(), 'BOTTOM', 0, -5);
    fontStr:SetText('')
    self.FontStr = fontStr;

    self:SetScript("OnKeyDown", function(_, key)
        self:KeyPress(key);
    end)
    self:SetPropagateKeyboardInput(true)
end

function DFEditModeSystemSelectionMouseOverCheckerMixin:KeyPress(key)
    -- print('KeyPress(key)', key)
    if key == 'LALT' and self.ShouldCycle then
        --
        -- print('cycle')
        self:CycleFrames()
    end
end

function DFEditModeSystemSelectionMouseOverCheckerMixin:CycleFrames()
    -- print('CycleFrames()')
    -- local foci = GetMouseFoci()
    -- for k, v in ipairs(foci) do
    --     --
    --     print(k, v:GetName())
    --     if v.IsDFEditModeSelection then
    --         print('lower', v:GetName())
    --         v:Lower()
    --         return;
    --     end
    -- end

    -- return;

    local nextFrame;
    for k, v in ipairs(self.OverTable) do
        if v == self.EditModeRef.SelectedFrame then
            --   
            nextFrame = self.OverTable[k + 1] or self.OverTable[1]
        end
        -- v:SetFrameLevel(999)
        v:Lower()
    end

    if not nextFrame then return end -- nothing selected under cursor - skip
    -- nextFrame:SetFrameLevel(1001)
    nextFrame:Raise()
end

function DFEditModeSystemSelectionMouseOverCheckerMixin:OnUpdate(elapsed)
    self.timeElapsed = self.timeElapsed + elapsed

    if self.timeElapsed > 0.25 then
        self.timeElapsed = 0
        -- do something
        -- print('OnUpdate')
        self:UpdateMouseover()
    end
end
local mouseOverCheckerTextFormat =
    "(|cff8080ff%d|r) frames under cursor - press (|cff8080ffleft alt|r) to cycle through them"

function DFEditModeSystemSelectionMouseOverCheckerMixin:UpdateMouseover()
    local num = #self.EditModeRef.SelectionFrames;
    local overTable = {}

    for k, v in ipairs(self.EditModeRef.SelectionFrames) do
        --
        if v:IsMouseOver() then
            -- print('~over: ', v:GetName())            
            table.insert(overTable, v)
        end
    end

    if #overTable < 2 then
        self.ShouldCycle = false;
        self.FontStr:SetText('')
        return;
    end

    self.ShouldCycle = true;
    self.FontStr:SetText(mouseOverCheckerTextFormat:format(#overTable))
    self.OverTable = overTable;
end

-- layout dropdown
DragonflightUIEditModeLayoutDropdownMixin = {}

function DragonflightUIEditModeLayoutDropdownMixin:OnLoad()
    -- print('OnLoad()')

    -- self:SetSize(100, 20)

    self.Button:ClearAllPoints()
    -- self.Button:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0);
    self.Button:SetPoint('TOPLEFT')
    self.Button:SetPoint('BOTTOMRIGHT')
    -- self.Button:SetEnabled(false)

    self.Button.Dropdown:ClearAllPoints()
    self.Button.Dropdown:SetPoint('TOPLEFT')
    self.Button.Dropdown:SetPoint('BOTTOMRIGHT')

    self.Button.Label:ClearAllPoints();
    self.Button.Label:SetPoint("BOTTOMLEFT", self.Button.Dropdown, "TOPLEFT", 0, 2);
    self.Button.Label:SetText(L["EditModeLayoutDropdown"]);

    -- self.Button.Dropdown:SetWidth(125)
    self.Button.Dropdown.Text:SetText('*profile*')

    self.Button.IncrementButton:Hide()
    self.Button.DecrementButton:Hide()

    local module = DF:GetModule('Profiles')
    self.ProfileModule = module

    self.Button.Dropdown:SetupMenu(module:GeneratorEditmodeLayout(true, function(name)
        -- print('IsSelected', name)
        return module:GetCurrentProfile() == name;
    end, function(name)
        -- print('SetSelected', name)
        module:SetCurrentProfile(name)
    end))

    hooksecurefunc(DF, 'RefreshConfig', function()
        -- print('ssss')
        self.Button.Dropdown.Text:SetText(module:GetCurrentProfile())
    end)
end
