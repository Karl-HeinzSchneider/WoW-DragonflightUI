local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Minimap'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')
Module.Tmp = {}

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {profile = {scale = 1, x = -10, y = -105, locked = true}}
Module:SetDefaults(defaults)

local function getDefaultStr(key, sub)
    return Module:GetDefaultStr(key, sub)
end

local function setDefaultValues()
    Module:SetDefaultValues()
end

local function setDefaultSubValues(sub)
    Module:SetDefaultSubValues(sub)
end

local function getOption(info)
    return Module:GetOption(info)
end

local function setOption(info, value)
    Module:SetOption(info, value)
end

local options = {
    type = 'group',
    name = 'DragonflightUI - ' .. mName,
    get = getOption,
    set = setOption,
    args = {
        toggle = {
            type = 'toggle',
            name = 'Enable',
            get = function()
                return DF:GetModuleEnabled(mName)
            end,
            set = function(info, v)
                DF:SetModuleEnabled(mName, v)
            end,
            order = 1
        },
        reload = {
            type = 'execute',
            name = '/reload',
            desc = 'reloads UI',
            func = function()
                ReloadUI()
            end,
            order = 1.1
        },
        defaults = {
            type = 'execute',
            name = 'Defaults',
            desc = 'Sets Config to default values',
            func = setDefaultValues,
            order = 1.1
        },
        --[[ config = {type = 'header', name = 'Config - Player', order = 100}, ]]
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale'),
            min = 0.2,
            max = 3,
            bigStep = 0.025,
            order = 101,
            disabled = false
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to TOPRIGHT' .. getDefaultStr('x'),
            min = -2500,
            max = 2500,
            bigStep = 0.50,
            order = 102
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to TOPRIGHT' .. getDefaultStr('y'),
            min = -2500,
            max = 2500,
            bigStep = 0.50,
            order = 102
        },
        locked = {
            type = 'toggle',
            name = 'Locked',
            desc = 'Lock the Minimap. Unlocked Minimap can be moved with shift-click and drag ' ..
                getDefaultStr('locked'),
            order = 103
        }
    }
}

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    DF:RegisterModuleOptions(mName, options)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    if DF.Wrath then
        Module.Wrath()
    else
        Module.Era()
    end

    Module.Tmp.MinimapX = 0
    Module.Tmp.MinimapY = 0

    Module.ApplySettings()

    DF.ConfigModule:RegisterOptionScreen('Misc', 'Minimap',
                                         {name = 'Minimap', options = options, default = setDefaultValues})

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)
        Module:ApplySettings()
        Module:RefreshOptionScreens()
    end)
end

function Module:OnDisable()
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame

    local refreshCat = function(name)
        local subCat = configFrame:GetSubCategory('Misc', name)
        subCat.displayFrame:CallRefresh()
    end

    refreshCat('Minimap')
end

function Module:ApplySettings()
    local db = Module.db.profile

    Module.MoveMinimap(db.x, db.y)
    local dfScale = 1.25
    Minimap:SetScale(db.scale * dfScale)

    Module.LockMinimap(db.locked)
end

local frame = CreateFrame('FRAME')

function Module.GetCoords(key)
    local uiunitframe = {
        ['UI-HUD-Calendar-1-Down'] = {21, 19, 0.00390625, 0.0859375, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-1-Mouseover'] = {21, 19, 0.09375, 0.17578125, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-1-Up'] = {21, 19, 0.18359375, 0.265625, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-10-Down'] = {21, 19, 0.2734375, 0.35546875, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-10-Mouseover'] = {21, 19, 0.36328125, 0.4453125, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-10-Up'] = {21, 19, 0.453125, 0.53515625, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-11-Down'] = {21, 19, 0.54296875, 0.625, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-11-Mouseover'] = {21, 19, 0.6328125, 0.71484375, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-11-Up'] = {21, 19, 0.72265625, 0.8046875, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-12-Down'] = {21, 19, 0.8125, 0.89453125, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-12-Mouseover'] = {21, 19, 0.90234375, 0.984375, 0.00390625, 0.078125, false, false},
        ['UI-HUD-Calendar-12-Up'] = {21, 19, 0.00390625, 0.0859375, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-13-Down'] = {21, 19, 0.09375, 0.17578125, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-13-Mouseover'] = {21, 19, 0.18359375, 0.265625, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-13-Up'] = {21, 19, 0.2734375, 0.35546875, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-14-Down'] = {21, 19, 0.36328125, 0.4453125, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-14-Mouseover'] = {21, 19, 0.453125, 0.53515625, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-14-Up'] = {21, 19, 0.54296875, 0.625, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-15-Down'] = {21, 19, 0.6328125, 0.71484375, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-15-Mouseover'] = {21, 19, 0.72265625, 0.8046875, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-15-Up'] = {21, 19, 0.8125, 0.89453125, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-16-Down'] = {21, 19, 0.90234375, 0.984375, 0.0859375, 0.16015625, false, false},
        ['UI-HUD-Calendar-16-Mouseover'] = {21, 19, 0.00390625, 0.0859375, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-16-Up'] = {21, 19, 0.00390625, 0.0859375, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-17-Down'] = {21, 19, 0.00390625, 0.0859375, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-17-Mouseover'] = {21, 19, 0.00390625, 0.0859375, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-17-Up'] = {21, 19, 0.00390625, 0.0859375, 0.49609375, 0.5703125, false, false},
        ['UI-HUD-Calendar-18-Down'] = {21, 19, 0.00390625, 0.0859375, 0.578125, 0.65234375, false, false},
        ['UI-HUD-Calendar-18-Mouseover'] = {21, 19, 0.00390625, 0.0859375, 0.66015625, 0.734375, false, false},
        ['UI-HUD-Calendar-18-Up'] = {21, 19, 0.00390625, 0.0859375, 0.7421875, 0.81640625, false, false},
        ['UI-HUD-Calendar-19-Down'] = {21, 19, 0.00390625, 0.0859375, 0.82421875, 0.8984375, false, false},
        ['UI-HUD-Calendar-19-Mouseover'] = {21, 19, 0.00390625, 0.0859375, 0.90625, 0.98046875, false, false},
        ['UI-HUD-Calendar-19-Up'] = {21, 19, 0.09375, 0.17578125, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-2-Down'] = {21, 19, 0.18359375, 0.265625, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-2-Mouseover'] = {21, 19, 0.2734375, 0.35546875, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-2-Up'] = {21, 19, 0.36328125, 0.4453125, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-20-Down'] = {21, 19, 0.453125, 0.53515625, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-20-Mouseover'] = {21, 19, 0.54296875, 0.625, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-20-Up'] = {21, 19, 0.6328125, 0.71484375, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-21-Down'] = {21, 19, 0.72265625, 0.8046875, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-21-Mouseover'] = {21, 19, 0.8125, 0.89453125, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-21-Up'] = {21, 19, 0.90234375, 0.984375, 0.16796875, 0.2421875, false, false},
        ['UI-HUD-Calendar-22-Down'] = {21, 19, 0.09375, 0.17578125, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-22-Mouseover'] = {21, 19, 0.09375, 0.17578125, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-22-Up'] = {21, 19, 0.09375, 0.17578125, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-23-Down'] = {21, 19, 0.09375, 0.17578125, 0.49609375, 0.5703125, false, false},
        ['UI-HUD-Calendar-23-Mouseover'] = {21, 19, 0.09375, 0.17578125, 0.578125, 0.65234375, false, false},
        ['UI-HUD-Calendar-23-Up'] = {21, 19, 0.09375, 0.17578125, 0.66015625, 0.734375, false, false},
        ['UI-HUD-Calendar-24-Down'] = {21, 19, 0.09375, 0.17578125, 0.7421875, 0.81640625, false, false},
        ['UI-HUD-Calendar-24-Mouseover'] = {21, 19, 0.09375, 0.17578125, 0.82421875, 0.8984375, false, false},
        ['UI-HUD-Calendar-24-Up'] = {21, 19, 0.09375, 0.17578125, 0.90625, 0.98046875, false, false},
        ['UI-HUD-Calendar-25-Down'] = {21, 19, 0.18359375, 0.265625, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-25-Mouseover'] = {21, 19, 0.2734375, 0.35546875, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-25-Up'] = {21, 19, 0.36328125, 0.4453125, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-26-Down'] = {21, 19, 0.453125, 0.53515625, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-26-Mouseover'] = {21, 19, 0.54296875, 0.625, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-26-Up'] = {21, 19, 0.6328125, 0.71484375, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-27-Down'] = {21, 19, 0.72265625, 0.8046875, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-27-Mouseover'] = {21, 19, 0.8125, 0.89453125, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-27-Up'] = {21, 19, 0.90234375, 0.984375, 0.25, 0.32421875, false, false},
        ['UI-HUD-Calendar-28-Down'] = {21, 19, 0.18359375, 0.265625, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-28-Mouseover'] = {21, 19, 0.18359375, 0.265625, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-28-Up'] = {21, 19, 0.18359375, 0.265625, 0.49609375, 0.5703125, false, false},
        ['UI-HUD-Calendar-29-Down'] = {21, 19, 0.18359375, 0.265625, 0.578125, 0.65234375, false, false},
        ['UI-HUD-Calendar-29-Mouseover'] = {21, 19, 0.18359375, 0.265625, 0.66015625, 0.734375, false, false},
        ['UI-HUD-Calendar-29-Up'] = {21, 19, 0.18359375, 0.265625, 0.7421875, 0.81640625, false, false},
        ['UI-HUD-Calendar-3-Down'] = {21, 19, 0.18359375, 0.265625, 0.82421875, 0.8984375, false, false},
        ['UI-HUD-Calendar-3-Mouseover'] = {21, 19, 0.18359375, 0.265625, 0.90625, 0.98046875, false, false},
        ['UI-HUD-Calendar-3-Up'] = {21, 19, 0.2734375, 0.35546875, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-30-Down'] = {21, 19, 0.36328125, 0.4453125, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-30-Mouseover'] = {21, 19, 0.453125, 0.53515625, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-30-Up'] = {21, 19, 0.54296875, 0.625, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-31-Down'] = {21, 19, 0.6328125, 0.71484375, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-31-Mouseover'] = {21, 19, 0.72265625, 0.8046875, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-31-Up'] = {21, 19, 0.8125, 0.89453125, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-4-Down'] = {21, 19, 0.90234375, 0.984375, 0.33203125, 0.40625, false, false},
        ['UI-HUD-Calendar-4-Mouseover'] = {21, 19, 0.2734375, 0.35546875, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-4-Up'] = {21, 19, 0.2734375, 0.35546875, 0.49609375, 0.5703125, false, false},
        ['UI-HUD-Calendar-5-Down'] = {21, 19, 0.2734375, 0.35546875, 0.578125, 0.65234375, false, false},
        ['UI-HUD-Calendar-5-Mouseover'] = {21, 19, 0.2734375, 0.35546875, 0.66015625, 0.734375, false, false},
        ['UI-HUD-Calendar-5-Up'] = {21, 19, 0.2734375, 0.35546875, 0.7421875, 0.81640625, false, false},
        ['UI-HUD-Calendar-6-Down'] = {21, 19, 0.2734375, 0.35546875, 0.82421875, 0.8984375, false, false},
        ['UI-HUD-Calendar-6-Mouseover'] = {21, 19, 0.2734375, 0.35546875, 0.90625, 0.98046875, false, false},
        ['UI-HUD-Calendar-6-Up'] = {21, 19, 0.36328125, 0.4453125, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-7-Down'] = {21, 19, 0.453125, 0.53515625, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-7-Mouseover'] = {21, 19, 0.54296875, 0.625, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-7-Up'] = {21, 19, 0.6328125, 0.71484375, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-8-Down'] = {21, 19, 0.72265625, 0.8046875, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-8-Mouseover'] = {21, 19, 0.8125, 0.89453125, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-8-Up'] = {21, 19, 0.90234375, 0.984375, 0.4140625, 0.48828125, false, false},
        ['UI-HUD-Calendar-9-Down'] = {21, 19, 0.36328125, 0.4453125, 0.49609375, 0.5703125, false, false},
        ['UI-HUD-Calendar-9-Mouseover'] = {21, 19, 0.36328125, 0.4453125, 0.578125, 0.65234375, false, false},
        ['UI-HUD-Calendar-9-Up'] = {21, 19, 0.36328125, 0.4453125, 0.66015625, 0.734375, false, false}
    }

    local data = uiunitframe[key]
    return data[3], data[4], data[5], data[6]
end

function Module.HideDefaultStuff()
    _G['MinimapBorder']:Hide()
    _G['MinimapBorderTop']:Hide()

    -- Hide WorldMapButton
    MiniMapWorldMapButton:Hide()
    hooksecurefunc(MiniMapWorldMapButton, 'Show', function()
        MiniMapWorldMapButton:Hide()
    end)
    -- Hide North Tag
    hooksecurefunc(MinimapNorthTag, 'Show', function()
        MinimapNorthTag:Hide()
    end)
end

function Module.MoveDefaultStuff()
    -- CENTER table: 000001F816E0E7B0 TOP 9 -92
    Minimap:SetPoint('CENTER', MinimapCluster, 'TOP', -10, -105)
    -- Minimap:SetScale(1.25)

    DurabilityFrame:ClearAllPoints()
    -- DurabilityFrame:SetPoint('CENTER',Minimap,'CENTER',0,-100)
    -- DurabilityFrame:SetPoint('TOPRIGHT',MinimapCluster,'BOTTOMRIGHT',-84,-100)
    DurabilityFrame:SetPoint('CENTER', Minimap, 'CENTER', 0, -142)

    DurabilityFrame.SetPoint = function()
    end

end

function Module.MoveMinimap(x, y)
    Minimap:ClearAllPoints()
    Minimap:SetClampedToScreen(true)
    Minimap:SetPoint('CENTER', MinimapCluster, 'TOP', x, y)
    -- MinimapCluster:ClearAllPoints()
    -- MinimapCluster:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', 0, 0)
    -- MinimapCluster:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', x, y)
end

function Module.ChangeZoom()
    local dx, dy = 5, 90
    MinimapZoomIn:SetScale(0.55)
    MinimapZoomIn:SetPoint('CENTER', Minimap, 'RIGHT', -dx, -dy)
    MinimapZoomIn:SetNormalTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomIn:GetNormalTexture():SetTexCoord(0.001953125, 0.068359375, 0.5390625, 0.572265625)
    -- MinimapZoomIn:SetPushedTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap')
    -- MinimapZoomIn:GetPushedTexture():SetTexCoord(0.001953125, 0.068359375, 0.57421875, 0.607421875)
    MinimapZoomIn:SetPushedTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomIn:GetPushedTexture():SetTexCoord(0.001953125, 0.068359375, 0.5390625, 0.572265625)
    MinimapZoomIn:SetDisabledTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomIn:GetDisabledTexture():SetTexCoord(0.001953125, 0.068359375, 0.5390625, 0.572265625)
    MinimapZoomIn:GetDisabledTexture():SetDesaturated(1)
    MinimapZoomIn:SetHighlightTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomIn:GetHighlightTexture():SetTexCoord(0.001953125, 0.068359375, 0.5390625, 0.572265625)

    MinimapZoomOut:SetScale(0.55)
    MinimapZoomOut:SetPoint('CENTER', Minimap, 'BOTTOM', dy, dx)
    MinimapZoomOut:SetNormalTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomOut:GetNormalTexture():SetTexCoord(0.353515625, 0.419921875, 0.5078125, 0.525390625)
    MinimapZoomOut:SetPushedTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomOut:GetPushedTexture():SetTexCoord(0.353515625, 0.419921875, 0.5078125, 0.525390625)
    MinimapZoomOut:SetDisabledTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomOut:GetDisabledTexture():SetTexCoord(0.353515625, 0.419921875, 0.5078125, 0.525390625)
    MinimapZoomOut:GetDisabledTexture():SetDesaturated(1)
    MinimapZoomOut:SetHighlightTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    MinimapZoomOut:GetHighlightTexture():SetTexCoord(0.353515625, 0.419921875, 0.5078125, 0.525390625)
end

function Module.HookMouseWheel()
    Minimap:SetScript('OnMouseWheel', function(self, delta)
        if (delta == -1) then
            MinimapZoomIn:Enable()
            -- PlaySound(SOUNDKIT.IG_MINIMAP_ZOOM_OUT);
            Minimap:SetZoom(math.max(Minimap:GetZoom() - 1, 0))
            if (Minimap:GetZoom() == 0) then MinimapZoomOut:Disable() end
        elseif (delta == 1) then
            MinimapZoomOut:Enable()
            -- PlaySound(SOUNDKIT.IG_MINIMAP_ZOOM_IN);
            Minimap:SetZoom(math.min(Minimap:GetZoom() + 1, Minimap:GetZoomLevels() - 1))
            if (Minimap:GetZoom() == (Minimap:GetZoomLevels() - 1)) then MinimapZoomIn:Disable() end
        end
    end)
end

function Module.CreateMinimapInfoFrame()
    local f = CreateFrame('Frame', 'DragonflightUIMinimapTop', UIParent)
    f:SetSize(170, 22)
    f:SetScale(0.8)
    f:SetParent(Minimap)
    f:SetPoint('CENTER', Minimap, 'TOP', 0, 25)

    local background = f:CreateTexture('DragonflightUIMinimapTopBackground', 'ARTWORK')
    background:ClearAllPoints()
    background:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\MinimapBorder')
    background:SetSize(170, 38)
    background:SetPoint('LEFT', f, 'LEFT', 0, -8)

    f.Background = background

    frame.MinimapInfo = f
end

function Module.ChangeCalendar()
    GameTimeFrame:ClearAllPoints()
    -- GameTimeFrame:SetPoint('CENTER', MinimapCluster, 'TOPRIGHT', -16, -20)
    GameTimeFrame:SetPoint('LEFT', frame.MinimapInfo, 'RIGHT', 0, -2)

    -- GameTimeFrame:SetParent(MinimapBackdrop)
    GameTimeFrame:SetScale(0.75)

    local texture = 'Interface\\Addons\\DragonflightUI\\Textures\\uicalendar32'
    GameTimeFrame:SetSize(35, 35)
    GameTimeFrame:GetNormalTexture():SetTexture(texture)
    GameTimeFrame:GetNormalTexture():SetTexCoord(0.18359375, 0.265625, 0.00390625, 0.078125)
    GameTimeFrame:GetPushedTexture():SetTexture(texture)
    GameTimeFrame:GetPushedTexture():SetTexCoord(0.00390625, 0.0859375, 0.00390625, 0.078125)
    GameTimeFrame:GetHighlightTexture():SetTexture(texture)
    GameTimeFrame:GetHighlightTexture():SetTexCoord(0.09375, 0.17578125, 0.00390625, 0.078125)

    GameTimeFrame:Hide()
    -- @TODO: change Font/size/center etc
    -- local fontstring = GameTimeFrame:GetFontString()
    -- print(fontstring[1])
    -- GameTimeFrame:SetNormalFontObject(GameFontHighlightLarge)

    -- local obj = GameTimeFrame:GetNormalFontObject()
    -- obj:SetJustifyH('LEFT')
end

function Module.UpdateCalendar()
    local button = frame.CalendarButton

    if button then
        local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uicalendar'

        local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime()
        local day = currentCalendarTime.monthDay
        -- print('UpdateCalendar', day, GetCoords('UI-HUD-Calendar-' .. day .. '-Up'))
        frame.CalendarButtonText:SetText(day)

        -- @TODO
        -- button:GetNormalTexture():SetTexCoord(GetCoords('UI-HUD-Calendar-' .. day .. '-Up'))
        -- button:GetHighlightTexture():SetTexCoord(GetCoords('UI-HUD-Calendar-' .. day .. '-Mouseover'))
        -- button:GetPushedTexture():SetTexCoord(GetCoords('UI-HUD-Calendar-' .. day .. '-Down'))

        local fix
    else
        -- print('no Calendarbutton => RIP')
    end
end

function Module.HookCalendar()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uicalendar32'

    local button = CreateFrame('Button', 'DragonflightUICalendarButton', UIParent)
    -- button:SetPoint('CENTER', 0, 75)
    local size = 24
    button:SetSize(size * 1.105, size)
    button:SetScale(0.8)

    -- button:SetParent(Minimap)
    local relativeScale = 0.8
    -- workaround, because sometimes the button dissappears when parent = Minimap
    hooksecurefunc(Minimap, 'SetScale', function()
        button:SetScale(Minimap:GetScale() * relativeScale)
    end)

    button:SetPoint('LEFT', frame.MinimapInfo, 'RIGHT', -2, -2)

    -- button:ClearAllPoints()
    -- button:SetPoint('LEFT', frame.MinimapInfo, 'RIGHT', -2, -2)

    local text = button:CreateFontString('DragonflightUICalendarButtonText', 'ARTWORK', 'GameFontBlack')
    text:SetText('12')
    text:SetPoint('CENTER', -2, 1)

    button:SetScript('OnClick', function()
        if DF.Wrath then
            ToggleCalendar()
        elseif DF.Era then
            Module:Print("Era doesn't have an ingame Calendar, sorry.")
        end
    end)

    button:SetNormalTexture(base)
    button:SetPushedTexture(base)
    button:SetHighlightTexture(base)
    button:GetNormalTexture():SetTexCoord(Module.GetCoords('UI-HUD-Calendar-1-Up'))
    button:GetHighlightTexture():SetTexCoord(Module.GetCoords('UI-HUD-Calendar-1-Mouseover'))
    button:GetPushedTexture():SetTexCoord(Module.GetCoords('UI-HUD-Calendar-1-Down'))

    frame.CalendarButton = button
    frame.CalendarButtonText = text

    hooksecurefunc(TimeManagerClockTicker, 'SetText', function()
        Module.UpdateCalendar()
    end)
end

function Module.ChangeClock()
    if IsAddOnLoaded('Blizzard_TimeManager') then
        local regions = {TimeManagerClockButton:GetRegions()}
        regions[1]:Hide()
        TimeManagerClockButton:ClearAllPoints()
        TimeManagerClockButton:SetPoint('RIGHT', frame.MinimapInfo, 'RIGHT', 5, 0)
        TimeManagerClockButton:SetParent(frame.MinimapInfo)
    end
end

function Module.ChangeZoneText()
    MinimapZoneTextButton:ClearAllPoints()
    MinimapZoneTextButton:SetPoint('LEFT', frame.MinimapInfo, 'LEFT', 1, 0)
    MinimapZoneTextButton:SetParent(frame.MinimapInfo)
    MinimapZoneTextButton:SetSize(130, 12)

    MinimapZoneText:ClearAllPoints()
    MinimapZoneText:SetSize(130, 12)
    MinimapZoneText:SetPoint('LEFT', frame.MinimapInfo, 'LEFT', 1, 0)
end

function Module.ChangeTracking()
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x'

    MiniMapTracking:ClearAllPoints()
    -- MiniMapTracking:SetPoint('TOPRIGHT', MinimapCluster, 'TOPRIGHT', -200 - 5, 0)
    MiniMapTracking:SetPoint('RIGHT', frame.MinimapInfo, 'LEFT', 0, 0)
    MiniMapTracking:SetScale(0.75)
    MiniMapTrackingIcon:Hide()

    -- MiniMapTrackingBackground:Hide()
    MiniMapTrackingBackground:ClearAllPoints()
    MiniMapTrackingBackground:SetPoint('CENTER', MiniMapTracking, 'CENTER')
    MiniMapTrackingBackground:SetTexture(base)
    MiniMapTrackingBackground:SetTexCoord(0.861328125, 0.9375, 0.392578125, 0.4296875)

    MiniMapTrackingButtonBorder:Hide()

    MiniMapTrackingButton:SetSize(19.5, 19)
    MiniMapTrackingButton:ClearAllPoints()
    MiniMapTrackingButton:SetPoint('CENTER', MiniMapTracking, 'CENTER')

    MiniMapTrackingButton:SetNormalTexture(base)
    MiniMapTrackingButton:GetNormalTexture():SetTexCoord(0.291015625, 0.349609375, 0.5078125, 0.53515625)
    MiniMapTrackingButton:SetHighlightTexture(base)
    MiniMapTrackingButton:GetHighlightTexture():SetTexCoord(0.228515625, 0.287109375, 0.5078125, 0.53515625)
    MiniMapTrackingButton:SetPushedTexture(base)
    MiniMapTrackingButton:GetPushedTexture():SetTexCoord(0.162109375, 0.224609375, 0.5078125, 0.537109375)
end

function Module.DrawMinimapBorder()
    local texture = Minimap:CreateTexture()
    texture:SetDrawLayer('ARTWORK', 7)
    texture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x')
    texture:SetTexCoord(0.001953125, 0.857421875, 0.056640625, 0.505859375)
    texture:SetPoint('CENTER', 'Minimap', 'CENTER', 1, 0)
    local delta = 22
    local dx = 6
    texture:SetSize(140 + delta - dx, 140 + delta)
    -- texture:SetScale(0.88)

    frame.minimap = texture
end

function Module.ReplaceTextures()
end

function Module.LockMinimap(locked)
    if locked then
        -- print('locked')
        Minimap:SetMovable(false)
        Minimap:SetScript('OnDragStart', nil)
        Minimap:SetScript('OnDragStop', nil)

        -- Minimap:EnableMouse(false)
    else
        -- print('not locked')

        Minimap:SetMovable(true)
        -- Minimap:EnableMouse(true)      
        Minimap:RegisterForDrag("LeftButton")
        Minimap:SetScript("OnDragStart", function(self)
            local x, y = Minimap:GetCenter()
            -- print('before', x, y)
            Module.Tmp.MinimapX = x
            Module.Tmp.MinimapY = y

            if IsShiftKeyDown() then self:StartMoving() end
        end)
        Minimap:SetScript("OnDragStop", function(self)
            -- print('OnDragStop')
            self:StopMovingOrSizing()
            -- local point, relativeTo, relativePoint, xOfs, yOfs = Minimap:GetPoint(1)
            -- print(xOfs, yOfs)
            local x, y = Minimap:GetCenter()
            -- print('after', x, y)

            local dx = Module.Tmp.MinimapX - x
            local dy = Module.Tmp.MinimapY - y
            -- print('delta', dx, dy)

            local db = Module.db.profile

            db.x = db.x - dx
            db.y = db.y - dy
            Module.ApplySettings()
        end)
        Minimap:SetUserPlaced(true)
    end
end

function Module.MoveBuffs()
    local dx = -45 - 10
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint('TOPRIGHT', MinimapCluster, 'TOPLEFT', dx, -13)
    hooksecurefunc('UIParent_UpdateTopFramePositions', function()
        BuffFrame:ClearAllPoints()
        BuffFrame:SetPoint('TOPRIGHT', MinimapCluster, 'TOPLEFT', dx, -13)
    end)
    -- @TODO: Taint ingame
    --[[ BuffFrame.SetPoint = function()
    end ]]
    -- BuffFrame.ClearAllPoints() = function()     end
end

function Module.MoveTracker()
    local setting
    hooksecurefunc(WatchFrame, 'SetPoint', function(self)
        if not setting then
            setting = true
            Module.MoveTrackerFunc()
            setting = nil
        end
    end)
end

function Module.MoveTrackerFunc()
    if WatchFrame then
        WatchFrame:ClearAllPoints()
        local ActionbarModule = DF:GetModule('Actionbar')

        if ActionbarModule and ActionbarModule:IsEnabled() and ActionbarModule.db.profile.changeSides then
            WatchFrame:SetPoint('TOPRIGHT', MinimapCluster, 'BOTTOMRIGHT', 0, -50)
        elseif MultiBarRight:IsShown() and MultiBarLeft:IsShown() then
            WatchFrame:SetPoint('TOPRIGHT', MinimapCluster, 'BOTTOMRIGHT', -100, -50)
        elseif MultiBarRight:IsShown() then
            WatchFrame:SetPoint('TOPRIGHT', MinimapCluster, 'BOTTOMRIGHT', -25, -50)
        else
            WatchFrame:SetPoint('TOPRIGHT', MinimapCluster, 'BOTTOMRIGHT', 0, -50)
        end
        WatchFrame:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', 0, 100)
    end
end

function Module.ChangeLFG()
    MiniMapLFGFrame:ClearAllPoints()
    MiniMapLFGFrame:SetPoint('CENTER', Minimap, 'BOTTOMLEFT', 10, 30)
    -- MinimapZoomIn:SetPoint('CENTER', Minimap, 'RIGHT', -dx, -dy)
end

function Module.ChangeDifficulty()
    MiniMapInstanceDifficulty:ClearAllPoints()
    MiniMapInstanceDifficulty:SetPoint('TOPRIGHT', _G['DragonflightUIMinimapTop'], 'BOTTOMRIGHT', 0, 0)
end

function Module.ChangeMail()
    MiniMapMailBorder:Hide()
    MiniMapMailIcon:Hide()
    -- MiniMapMailFrame:SetPoint('TOPRIGHT', Minimap, 'TOPRIGHT', 24 - 5, -52 + 25)
    MiniMapMailFrame:SetSize(19.5, 15)

    if MiniMapTracking then
        MiniMapMailFrame:SetPoint('TOPRIGHT', MiniMapTracking, 'BOTTOMRIGHT', 2, -1)
    else
        -- MiniMapMailFrame:SetPoint('TOPRIGHT', _G['DragonflightUIMinimapTop'], 'BOTTOMLEFT', 2, -1)
        MiniMapMailFrame:ClearAllPoints()
        MiniMapMailFrame:SetPoint('RIGHT', _G['DragonflightUIMinimapTop'], 'LEFT', 0, 0)
    end

    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\uiminimap2x'

    local mail = MiniMapMailFrame:CreateTexture('DragonflightUIMinimapMailFrame', 'ARTWORK')
    mail:ClearAllPoints()
    mail:SetTexture(base)
    mail:SetTexCoord(0.08203125, 0.158203125, 0.5078125, 0.537109375)
    mail:SetSize(19.5, 15)
    mail:SetPoint('CENTER', MiniMapMailFrame, 'CENTER', -3, 0)
    mail:SetScale(1)
end

function Module.ChangeEra()
    GameTimeFrame:Hide()
    MinimapToggleButton:Hide()
end

function frame:OnEvent(event, arg1)
    -- print('event', event) 
end
frame:SetScript('OnEvent', frame.OnEvent)

-- Wrath
function Module.Wrath()
    Module.HideDefaultStuff()
    Module.MoveDefaultStuff()
    Module.ChangeZoom()
    Module.CreateMinimapInfoFrame()
    Module.ChangeCalendar()
    Module.ChangeClock()
    Module.ChangeZoneText()
    Module.ChangeTracking()
    Module.DrawMinimapBorder()
    Module.MoveBuffs()
    Module.MoveTracker()
    Module.ChangeLFG()
    Module.ChangeDifficulty()
    Module.HookMouseWheel()
    Module.ChangeMail()

    Module.HookCalendar()
    Module.UpdateCalendar()

    -- frame:RegisterEvent('ADDON_LOADED')
end

-- Era
function Module.Era()
    Module.HideDefaultStuff()
    Module.MoveDefaultStuff()
    Module.ChangeZoom()
    Module.CreateMinimapInfoFrame()
    Module.ChangeClock()
    Module.ChangeZoneText()
    Module.DrawMinimapBorder()
    Module.MoveBuffs()
    Module.HookMouseWheel()
    Module.ChangeMail()
    Module.ChangeEra()

    Module.HookCalendar()
    Module.UpdateCalendar()

    -- frame:RegisterEvent('ADDON_LOADED')
end
