local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

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

DF.Settings.OrientationTable = {
    {value = 'horizontal', text = 'Horizontal', tooltip = 'descr', label = 'label'},
    {value = 'vertical', text = 'Vertical', tooltip = 'descr', label = 'label'}
}

function DF.Settings:AddPositionTable(Module, optionTable, sub, displayName, getDefaultStr, frameTable)
    local extraOptions = {
        headerPosition = {type = 'header', name = 'Scale and Position', desc = '', order = 0, isExpanded = true},
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale', sub),
            min = 0.1,
            max = 5,
            bigStep = 0.05,
            order = 1,
            group = 'headerPosition',
            editmode = true
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor', sub),
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
            name = 'AnchorParent',
            desc = 'AnchorParent' .. getDefaultStr('anchorParent', sub),
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
            name = 'AnchorFrame',
            desc = 'Anchor' .. getDefaultStr('anchorFrame', sub),
            values = frameTable,
            dropdownValues = frameTable,
            order = 4,
            group = 'headerPosition',
            editmode = true
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to *ANCHOR*' .. getDefaultStr('x', sub),
            min = -2500,
            max = 2500,
            bigStep = 1,
            order = 5,
            group = 'headerPosition',
            editmode = true
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to *ANCHOR*' .. getDefaultStr('y', sub),
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
