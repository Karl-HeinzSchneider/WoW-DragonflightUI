local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

DF.Settings = DF.Settings or {}

DF.Settings.DropdownAnchorTable = {
    {value = 'CENTER', text = 'CENTER', tooltip = 'descr', label = 'label'},
    {value = 'TOP', text = 'TOP', tooltip = 'descr', label = 'label'},
    {value = 'RIGHT', text = 'RIGHT', tooltip = 'descr', label = 'label'},
    {value = 'BOTTOM', text = 'BOTTOM', tooltip = 'descr', label = 'label'},
    {value = 'LEFT', text = 'LEFT', tooltip = 'descr', label = 'label'},
    {value = 'TOPRIGHT', text = 'TOPRIGHT', tooltip = 'descr', label = 'label'},
    {value = 'TOPLEFT', text = 'TOPLEFT', tooltip = 'descr', label = 'label'},
    {value = 'BOTTOMLEFT', text = 'BOTTOMLEFT', tooltip = 'descr', label = 'label'},
    {value = 'BOTTOMRIGHT', text = 'BOTTOMRIGHT', tooltip = 'descr', label = 'label'}
}

DF.Settings.DropdownCrossAnchorTable = {
    {value = 'TOP', text = 'TOP', tooltip = 'descr', label = 'label'},
    {value = 'RIGHT', text = 'RIGHT', tooltip = 'descr', label = 'label'},
    {value = 'BOTTOM', text = 'BOTTOM', tooltip = 'descr', label = 'label'},
    {value = 'LEFT', text = 'LEFT', tooltip = 'descr', label = 'label'}
}

DF.Settings.DropdownTopBottomAnchorTable = {
    {value = 'TOP', text = 'TOP', tooltip = 'descr', label = 'label'},
    {value = 'BOTTOM', text = 'BOTTOM', tooltip = 'descr', label = 'label'}
}

DF.Settings.OrientationTable = {
    {value = 'horizontal', text = 'Horizontal', tooltip = 'descr', label = 'label'},
    {value = 'vertical', text = 'Vertical', tooltip = 'descr', label = 'label'}
}

DF.Settings.GrowthDirectionTable = {
    {value = 'up', text = 'Up', tooltip = 'descr', label = 'label'},
    {value = 'down', text = 'Down', tooltip = 'descr', label = 'label'}
}

DF.Settings.ValidateFrame = function(t)
    if not t or t == '' then return false end
    local f = _G[t];

    if f and f.SetPoint then
        return true
    else
        return false
    end
    -- local result, target = SecureCmdOptionParse(t)
    -- if result ~= 'show' and result ~= 'hide' and result ~= '' then
    --     Module:Print('|cFFFF0000Error: Custom Condition for ' .. displayName .. ' does not return ' ..
    --                      [['show' or 'hide'!|r]])
    --     return
    -- end

    -- -- valid
    -- Module:Print('Set Custom Condition for ' .. displayName .. ': \'' .. t .. '\'')
    -- Module:Print('Current Value: ' .. result)

    -- -- valid, reset
    -- return true, true;
end

function DF.Settings:AddPositionTable(Module, optionTable, sub, displayName, getDefaultStr, frameTable)
    local extraOptions = {
        headerPosition = {
            type = 'header',
            name = L["PositionTableHeader"],
            desc = L["PositionTableHeaderDesc"],
            order = 0,
            isExpanded = true,
            editmode = true
        },
        scale = {
            type = 'range',
            name = L["PositionTableScale"],
            desc = L["PositionTableScaleDesc"] .. getDefaultStr('scale', sub),
            min = 0.1,
            max = 5,
            bigStep = 0.05,
            order = 1,
            group = 'headerPosition',
            editmode = true
        },
        anchor = {
            type = 'select',
            name = L["PositionTableAnchor"],
            desc = L["PositionTableAnchorDesc"] .. getDefaultStr('anchor', sub),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            dropdownValues = DF.Settings.DropdownAnchorTable,
            order = 2,
            group = 'headerPosition',
            editmode = true
        },
        anchorParent = {
            type = 'select',
            name = L["PositionTableAnchorParent"],
            desc = L["PositionTableAnchorParentDesc"] .. getDefaultStr('anchorParent', sub),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            dropdownValues = DF.Settings.DropdownAnchorTable,
            order = 3,
            group = 'headerPosition',
            editmode = true
        },
        anchorFrame = {
            type = 'select',
            name = L["PositionTableAnchorFrame"],
            desc = L["PositionTableAnchorFrameDesc"] .. getDefaultStr('anchorFrame', sub),
            values = frameTable,
            dropdownValues = frameTable,
            order = 4,
            group = 'headerPosition',
            editmode = true
        },
        customAnchorFrame = {
            type = 'editbox',
            name = L["PositionTableCustomAnchorFrame"],
            desc = L["PositionTableCustomAnchorFrameDesc"] .. getDefaultStr('customAnchorFrame', sub),
            Validate = DF.Settings.ValidateFrame,
            order = 4.5,
            group = 'headerPosition',
            editmode = true
        },
        x = {
            type = 'range',
            name = L["PositionTableX"],
            desc = L["PositionTableXDesc"] .. getDefaultStr('x', sub),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5,
            group = 'headerPosition',
            editmode = true
        },
        y = {
            type = 'range',
            name = L["PositionTableY"],
            desc = L["PositionTableYDesc"] .. getDefaultStr('y', sub),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 6,
            group = 'headerPosition',
            editmode = true
        }
    }

    for k, v in pairs(extraOptions) do
        --
        optionTable.args[k] = v
    end
end
