DragonflightUIMixin = {}

local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

function DragonflightUIMixin:UIPanelCloseButton(btn)
    -- print('DragonflightUIMixin:UIPanelCloseButton(btn)', btn:GetName())  
    local tex = base .. 'redbutton2x'

    btn:SetSize(24, 24)

    local normal = btn:GetNormalTexture()
    normal:SetTexture(tex)
    normal:SetTexCoord(0.152344, 0.292969, 0.0078125, 0.304688)

    local disabled = btn:GetDisabledTexture()
    disabled:SetTexture(tex)
    disabled:SetTexCoord(0.152344, 0.292969, 0.320312, 0.617188)

    local pushed = btn:GetPushedTexture()
    pushed:SetTexture(tex)
    pushed:SetTexCoord(0.152344, 0.292969, 0.632812, 0.929688)

    local highlight = btn:GetHighlightTexture()
    highlight:SetTexture(tex)
    highlight:SetTexCoord(0.449219, 0.589844, 0.0078125, 0.304688)
end

--[[ 
["Interface/Buttons/redbutton2x"]={
    ["RedButton-Condense"]={36, 38, 0.00390625, 0.144531, 0.0078125, 0.304688, false, false, "1x"},
    ["RedButton-Condense-disabled"]={36, 38, 0.00390625, 0.144531, 0.320312, 0.617188, false, false, "1x"},
    ["RedButton-Condense-Pressed"]={36, 38, 0.00390625, 0.144531, 0.632812, 0.929688, false, false, "1x"},
    ["RedButton-Exit"]={36, 38, 0.152344, 0.292969, 0.0078125, 0.304688, false, false, "1x"},
    ["RedButton-Exit-Disabled"]={36, 38, 0.152344, 0.292969, 0.320312, 0.617188, false, false, "1x"},
    ["RedButton-exit-pressed"]={36, 38, 0.152344, 0.292969, 0.632812, 0.929688, false, false, "1x"},
    ["RedButton-Expand"]={36, 38, 0.300781, 0.441406, 0.0078125, 0.304688, false, false, "1x"},
    ["RedButton-Expand-Disabled"]={36, 38, 0.300781, 0.441406, 0.320312, 0.617188, false, false, "1x"},
    ["RedButton-Expand-Pressed"]={36, 38, 0.300781, 0.441406, 0.632812, 0.929688, false, false, "1x"},
    ["RedButton-MiniCondense"]={36, 38, 0.449219, 0.589844, 0.320312, 0.617188, false, false, "1x"},
    ["RedButton-MiniCondense-disabled"]={36, 38, 0.449219, 0.589844, 0.632812, 0.929688, false, false, "1x"},
    ["RedButton-MiniCondense-pressed"]={36, 38, 0.597656, 0.738281, 0.0078125, 0.304688, false, false, "1x"},
    ["RedButton-Highlight"]={36, 38, 0.449219, 0.589844, 0.0078125, 0.304688, false, false, "1x"},
} ]]

function DragonflightUIMixin:MaximizeMinimizeButtonFrameTemplate(btn)
    -- print('DragonflightUIMixin:MaximizeMinimizeButtonFrameTemplate(btn)', btn:GetName())  
    local tex = base .. 'redbutton2x'

    btn:SetSize(24, 24)
    -- maximize
    do
        local ref = btn.MaximizeButton

        local normal = ref:GetNormalTexture()
        normal:SetTexture(tex)
        normal:SetTexCoord(0.300781, 0.441406, 0.0078125, 0.304688)

        local disabled = ref:GetDisabledTexture()
        disabled:SetTexture(tex)
        disabled:SetTexCoord(0.300781, 0.441406, 0.320312, 0.617188)

        local pushed = ref:GetPushedTexture()
        pushed:SetTexture(tex)
        pushed:SetTexCoord(0.300781, 0.441406, 0.632812, 0.929688)

        local highlight = ref:GetHighlightTexture()
        highlight:SetTexture(tex)
        highlight:SetTexCoord(0.449219, 0.589844, 0.0078125, 0.304688)
    end

    -- minimize
    do
        local ref = btn.MinimizeButton

        local normal = ref:GetNormalTexture()
        normal:SetTexture(tex)
        normal:SetTexCoord(0.00390625, 0.144531, 0.0078125, 0.304688)

        local disabled = ref:GetDisabledTexture()
        disabled:SetTexture(tex)
        disabled:SetTexCoord(0.00390625, 0.144531, 0.320312, 0.617188)

        local pushed = ref:GetPushedTexture()
        pushed:SetTexture(tex)
        pushed:SetTexCoord(0.00390625, 0.144531, 0.632812, 0.929688)

        local highlight = ref:GetHighlightTexture()
        highlight:SetTexture(tex)
        highlight:SetTexCoord(0.449219, 0.589844, 0.0078125, 0.304688)
    end
end

function DragonflightUIMixin:ButtonFrameTemplateNoPortrait(frame)
    print('DragonflightUIMixin:ButtonFrameTemplateNoPortrait(frame)', frame:GetName())

    local slice = frame.NineSlice

    -- corner
    do
        local tex = base .. 'uiframemetal2x'

        local tlc = slice.TopLeftCorner
        tlc:SetTexture(tex)
        tlc:SetTexCoord(0.00195312, 0.294922, 0.00195312, 0.294922)
        tlc:SetSize(75, 74)
        tlc:SetPoint('TOPLEFT', -12, 16)

        local trc = slice.TopRightCorner
        trc:SetTexture(tex)
        trc:SetTexCoord(0.298828, 0.591797, 0.00195312, 0.294922)
        trc:SetSize(75, 74)
        trc:SetPoint('TOPRIGHT', 4, 16)

        local blc = slice.BottomLeftCorner
        blc:SetTexture(tex)
        blc:SetTexCoord(0.298828, 0.423828, 0.298828, 0.423828)
        blc:SetSize(32, 32)
        blc:SetPoint('BOTTOMLEFT', -12, -3)

        local brc = slice.BottomRightCorner
        brc:SetTexture(tex)
        brc:SetTexCoord(0.427734, 0.552734, 0.298828, 0.423828)
        brc:SetSize(32, 32)
        brc:SetPoint('BOTTOMRIGHT', 4, -3)
    end

    -- edge bottom/top
    do
        local tex = base .. 'UIFrameMetalHorizontal2x'

        local te = slice.TopEdge
        te:SetTexture(tex)
        te:SetTexCoord(0, 1, 0.00390625, 0.589844)
        te:SetSize(32, 74)

        local be = slice.BottomEdge
        be:SetTexture(tex)
        be:SetTexCoord(0, 0.5, 0.597656, 0.847656)
        be:SetSize(16, 32)
    end

    -- edge left/right
    do
        local tex = base .. 'UIFrameMetalVertical2x'

        local le = slice.LeftEdge
        le:SetTexture(tex)
        le:SetTexCoord(0.00195312, 0.294922, 0, 1)
        le:SetSize(75, 16)

        local re = slice.RightEdge
        re:SetTexture(tex)
        re:SetTexCoord(0.298828, 0.591797, 0, 1)
        re:SetSize(75, 16)
    end

    local bg = frame.Bg
    bg:SetPoint('TOPLEFT', frame, 'TOPLEFT', 3, -18)

    local closeBtn = frame.ClosePanelButton
    DragonflightUIMixin:UIPanelCloseButton(closeBtn)
    closeBtn:SetPoint('TOPRIGHT', 1, 0)
end

--[[ 
["Interface/FrameGeneral/UIFrameMetal2x"]={
    ["UI-Frame-Metal-CornerBottomLeft"]={32, 16, 0.298828, 0.423828, 0.298828, 0.423828, false, false, "2x"},
    ["UI-Frame-Metal-CornerBottomRight"]={32, 16, 0.427734, 0.552734, 0.298828, 0.423828, false, false, "2x"},
    ["UI-Frame-Metal-CornerTopLeft"]={75, 37, 0.00195312, 0.294922, 0.00195312, 0.294922, false, false, "2x"},
    ["UI-Frame-Metal-CornerTopRight"]={75, 37, 0.298828, 0.591797, 0.00195312, 0.294922, false, false, "2x"},
    ["UI-Frame-PortraitMetal-CornerTopLeft"]={75, 37, 0.00195312, 0.294922, 0.298828, 0.591797, false, false, "2x"},
    ["UI-Frame-Metal-CornerTopRightDouble"]={75, 37, 0.595703, 0.888672, 0.00195312, 0.294922, false, false, "2x"},
    ["ui-frame-portraitmetal-cornertopleftsmall"]={75, 37, 0.00195312, 0.294922, 0.595703, 0.888672, false, false, "2x"},
  }, -- Interface/FrameGeneral/UIFrameMetal2x
  ["Interface/FrameGeneral/UIFrameMetalHorizontal2x"]={
    ["_UI-Frame-Metal-EdgeBottom"]={16, 16, 0, 0.5, 0.597656, 0.847656, true, false, "2x"},
    ["_UI-Frame-Metal-EdgeTop"]={32, 37, 0, 1, 0.00390625, 0.589844, true, false, "2x"},
  }, -- Interface/FrameGeneral/UIFrameMetalHorizontal2x
  ["Interface/FrameGeneral/UIFrameMetalVertical2x"]={
    ["!UI-Frame-Metal-EdgeLeft"]={75, 8, 0.00195312, 0.294922, 0, 1, false, true, "2x"},
    ["!UI-Frame-Metal-EdgeRight"]={75, 8, 0.298828, 0.591797, 0, 1, false, true, "2x"},
  }, -- Interface/FrameGeneral/UIFrameMetalVertical2x
  
    ["Interface/FrameGeneral/UIFrameBackground"]={
    ["UIFrameBackground-NineSlice-CornerBottomLeft"]={16, 16, 0.015625, 0.265625, 0.03125, 0.53125, false, false, "1x"},
    ["UIFrameBackground-NineSlice-CornerBottomRight"]={16, 16, 0.296875, 0.546875, 0.03125, 0.53125, false, false, "1x"},
  ]]

function DragonflightUIMixin:PortraitFrameTemplate(frame)
    print('DragonflightUIMixin:PortraitFrameTemplate(frame)', frame:GetName())

    local name = frame:GetName()

    -- portrait
    do
        local tex = base .. 'uiframemetal2x'

        local port = _G[name .. 'Portrait']
        port:SetSize(62, 62)
        port:ClearAllPoints()
        port:SetPoint('TOPLEFT', -5, 7)
        port:SetDrawLayer('OVERLAY', 6)

        local pp = _G[name .. 'PortraitFrame']
        pp:SetTexture(tex)
        pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
        pp:SetSize(84, 84)
        pp:ClearAllPoints()
        pp:SetPoint('CENTER', port, 'CENTER', 0, 0)
        pp:SetDrawLayer('OVERLAY', 7)
    end

    -- corner
    do
        local tex = base .. 'uiframemetal2x'

        local tlc = frame:CreateTexture(name .. 'TopLeftCornerDF', 'OVERLAY')
        tlc:SetTexture(tex)
        tlc:SetTexCoord(0.00195312, 0.294922, 0.00195312, 0.294922)
        tlc:SetSize(75, 74)
        tlc:SetPoint('TOPLEFT', -13, 16)

        local trc = _G[name .. 'TopRightCorner']
        trc:SetTexture(tex)
        trc:SetTexCoord(0.298828, 0.591797, 0.00195312, 0.294922)
        trc:SetSize(75, 74)
        trc:SetPoint('TOPRIGHT', 4, 16)

        local blc = _G[name .. 'BotLeftCorner']
        blc:SetTexture(tex)
        blc:SetTexCoord(0.298828, 0.423828, 0.298828, 0.423828)
        blc:SetSize(32, 32)
        blc:SetPoint('BOTTOMLEFT', -13, -3)

        local brc = _G[name .. 'BotRightCorner']
        brc:SetTexture(tex)
        brc:SetTexCoord(0.427734, 0.552734, 0.298828, 0.423828)
        brc:SetSize(32, 32)
        brc:SetPoint('BOTTOMRIGHT', 4, -3)
    end

    -- edge bottom/top
    do
        local tex = base .. 'UIFrameMetalHorizontal2x'

        local te = _G[name .. 'TopBorder']
        te:SetTexture(tex)
        te:SetTexCoord(0, 1, 0.00390625, 0.589844)
        te:SetSize(32, 74)
        -- local point, relativeTo, relativePoint, xOfs, yOfs = te:GetPoint(1)   
        te:ClearAllPoints()
        te:SetPoint('TOPLEFT', _G[name .. 'TopLeftCornerDF'], 'TOPRIGHT', 0, 0)
        te:SetPoint('TOPRIGHT', _G[name .. 'TopRightCorner'], 'TOPLEFT', 0, 0)

        local be = _G[name .. 'BottomBorder']
        be:SetTexture(tex)
        be:SetTexCoord(0, 0.5, 0.597656, 0.847656)
        be:SetSize(16, 32)
    end

    -- edge left/right
    do
        local tex = base .. 'UIFrameMetalVertical2x'

        local le = _G[name .. 'LeftBorder']
        le:SetTexture(tex)
        le:SetTexCoord(0.00195312, 0.294922, 0, 1)
        le:SetSize(75, 16)
        local tlc = _G[name .. 'TopLeftCornerDF']
        le:SetPoint('TOPLEFT', tlc, 'BOTTOMLEFT', 0, 0)

        local re = _G[name .. 'RightBorder']
        re:SetTexture(tex)
        re:SetTexCoord(0.298828, 0.591797, 0, 1)
        re:SetSize(75, 16)
        re:SetPoint('TOPRIGHT', _G[name .. 'TopRightCorner'], 'BOTTOMRIGHT', 0, 0)
        re:SetPoint('BOTTOMRIGHT', _G[name .. 'BotRightCorner'], 'TOPRIGHT', 0, 0)
    end

    local closeBtn = _G[name .. 'CloseButton']
    DragonflightUIMixin:UIPanelCloseButton(closeBtn)
    closeBtn:SetPoint('TOPRIGHT', 1, 0)

    for i = 1, 3 do
        local tab = _G[name .. 'TabButton' .. i]

        if tab then
            --
            DragonflightUIMixin:CharacterFrameTabButtonTemplate(tab)
        end

        if i > 1 then tab.changePoint = true end
    end
end

function DragonflightUIMixin:TabResize(btn)
    -- PanelTemplates_TabResize(btn, 35, nil, 60, 80);
    btn:SetWidth(80)

    if btn.changePoint then
        local point, relativeTo, relativePoint, xOfs, yOfs = btn:GetPoint(1)
        btn:SetPoint('LEFT', relativeTo, 'RIGHT', 4, 0)
    end
end

function DragonflightUIMixin:CharacterFrameTabButtonTemplate(frame)
    print('DragonflightUIMixin:CharacterFrameTabButtonTemplate(frame)', frame:GetName())

    local name = frame:GetName()

    local tex = base .. 'uiframetabs'

    frame:SetSize(10, 32)

    -- function PanelTemplates_TabResize(tab, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)
    -- 100 - 150
    -- PanelTemplates_TabResize(self, 0, nil, 36, self:GetParent().maxTabWidth or 88);

    frame:HookScript('OnEvent', function()
        DragonflightUIMixin:TabResize(frame)
    end)

    frame:HookScript('OnShow', function()
        DragonflightUIMixin:TabResize(frame)
    end)

    -- inactive
    do
        local left = _G[name .. 'Left']
        left:ClearAllPoints()
        left:SetSize(35, 36)
        left:SetTexture(tex)
        left:SetTexCoord(0.015625, 0.5625, 0.816406, 0.957031)
        left:SetPoint('TOPLEFT', -3, 0)

        local right = _G[name .. 'Right']
        right:ClearAllPoints()
        right:SetSize(37, 36)
        right:SetTexture(tex)
        right:SetTexCoord(0.015625, 0.59375, 0.667969, 0.808594)
        right:SetPoint('TOPRIGHT', 7, 0)

        local middle = _G[name .. 'Middle']
        middle:ClearAllPoints()
        middle:SetSize(1, 36)
        middle:SetTexture(tex)
        middle:SetTexCoord(0, 0.015625, 0.175781, 0.316406)
        middle:SetPoint('TOPLEFT', left, 'TOPRIGHT', 0, 0)
        middle:SetPoint('TOPRIGHT', right, 'TOPLEFT', 0, 0)
    end

    -- disabled
    do
        local left = _G[name .. 'LeftDisabled']
        left:SetTexture()
        left:Hide()

        -- left:ClearAllPoints()
        -- left:SetSize(35, 42)
        -- left:SetTexture(tex)
        -- left:SetTexCoord(0.015625, 0.5625, 0.496094, 0.660156)
        -- left:SetPoint('TOPLEFT', -1, 0)

        local right = _G[name .. 'RightDisabled']
        right:SetTexture()
        right:Hide()

        -- right:ClearAllPoints()
        -- right:SetSize(37, 42)
        -- right:SetTexture(tex)
        -- right:SetTexCoord(0.015625, 0.59375, 0.324219, 0.488281)
        -- right:SetPoint('TOPRIGHT', 8, 0)

        local middle = _G[name .. 'MiddleDisabled']
        middle:SetTexture()
        middle:Hide()
        -- middle:ClearAllPoints()
        -- middle:SetSize(1, 42)
        -- middle:SetTexture(tex)
        -- middle:SetTexCoord(0, 0.015625, 0.00390625, 0.167969)
        -- middle:SetPoint('TOPLEFT', left, 'TOPRIGHT', 0, 0)
        -- middle:SetPoint('TOPRIGHT', right, 'TOPLEFT', 0, 0)
    end

    -- highlight
    do
        local highlight = frame:GetHighlightTexture()
        highlight:SetTexture()

        local left = frame:CreateTexture('DragonflightUIHighlight' .. 'Left', 'HIGHLIGHT')
        left:SetTexture(tex)
        left:SetTexCoord(0.015625, 0.5625, 0.816406, 0.957031)
        left:SetSize(35, 36)
        left:SetPoint('TOPLEFT', -3, 0)
        left:SetBlendMode('ADD')
        left:SetAlpha(0.4)

        local right = frame:CreateTexture('DragonflightUIHighlight' .. 'Right', 'HIGHLIGHT')
        right:SetTexture(tex)
        right:SetTexCoord(0.015625, 0.59375, 0.667969, 0.808594)
        right:SetSize(37, 36)
        right:SetPoint('TOPRIGHT', 7, 0)
        right:SetBlendMode('ADD')
        right:SetAlpha(0.4)

        local middle = frame:CreateTexture('DragonflightUIHighlight' .. 'Middle', 'HIGHLIGHT')
        middle:SetTexture(tex)
        middle:SetTexCoord(0, 0.015625, 0.175781, 0.316406)
        middle:SetSize(1, 36)
        middle:SetPoint('TOPLEFT', left, 'TOPRIGHT', 0, 0)
        middle:SetPoint('TOPRIGHT', right, 'TOPLEFT', 0, 0)
        middle:SetBlendMode('ADD')
        middle:SetAlpha(0.4)
    end
end

--[[ ["Interface/FrameGeneral/UIFrameTabs"]={
    ["uiframe-activetab-left"]={35, 42, 0.015625, 0.5625, 0.496094, 0.660156, false, false, "1x"},
    ["uiframe-activetab-right"]={37, 42, 0.015625, 0.59375, 0.324219, 0.488281, false, false, "1x"},
    ["uiframe-tab-left"]={35, 36, 0.015625, 0.5625, 0.816406, 0.957031, false, false, "1x"},
    ["uiframe-tab-right"]={37, 36, 0.015625, 0.59375, 0.667969, 0.808594, false, false, "1x"},
    ["_uiframe-activetab-center"]={1, 42, 0, 0.015625, 0.00390625, 0.167969, true, false, "1x"},
    ["_uiframe-tab-center"]={1, 36, 0, 0.015625, 0.175781, 0.316406, true, false, "1x"},
  }, -- Interface/FrameGeneral/UIFrameTabs ]]

