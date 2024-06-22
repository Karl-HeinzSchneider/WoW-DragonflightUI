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
