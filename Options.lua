local Addon, Core = ...

function SetupOptions()
    local panel = CreateFrame('Frame')
    panel.name = 'DragonflightUI' -- see panel fields
    InterfaceOptions_AddCategory(panel) -- see InterfaceOptions API

    -- add widgets to the panel as desired
    local title = panel:CreateFontString('ARTWORK', nil, 'GameFontNormalLarge')
    title:SetPoint('TOPLEFT', 16, -16)
    title:SetText('DragonflightUI')

    local deltaY = 35
    local last = title
    for k, v in pairs(Core.Modules) do
        local checkbox = CreateFrame('CheckButton', 'DragonflightUICheckbox' .. k, panel, 'UICheckButtonTemplate')
        last = checkbox
        checkbox:SetPoint('TOPLEFT', title, 'BOTTOMLEFT', 0, -k * deltaY)
        local descr = checkbox:CreateFontString('ARTWORK', nil, 'GameFontNormal')
        descr:SetPoint('LEFT', checkbox, 'RIGHT', 5, 0)
        --descr:SetText(v.name .. ': ' .. k)
        descr:SetText(v.name)

        local cfg = ConfigTable[v.name]

        checkbox:SetChecked(cfg.active)

        checkbox:SetScript(
            'OnClick',
            function()
                if checkbox:GetChecked() then
                    --print('Button is checked')
                    ConfigTable[v.name].active = true
                else
                    --print('Button is unchecked')
                    ConfigTable[v.name].active = false
                end
                print("'/reload' ")
            end
        )
    end

    local reloadBtn = CreateFrame('Button', 'DragonflightUIReloadButton', panel, 'UIPanelButtonTemplate')
    reloadBtn:SetPoint('TOPLEFT', last, 'BOTTOMLEFT', 0, -10)
    reloadBtn:SetSize(100, 30)
    reloadBtn:SetText('RELOAD')
    reloadBtn:SetScript(
        'OnClick',
        function()
            ReloadUI()
        end
    )
end

function CreateDefaultConfig()
    local cfg = {}
    for k, v in pairs(Core.Modules) do
        --cfg[v.]
    end

    return {}
end

function CheckConfig()
    ConfigTable = ConfigTable or CreateDefaultConfig()

    for k, v in pairs(Core.Modules) do
        if not ConfigTable[v.name] then
            ConfigTable[v.name] = {
                ['options'] = v.options,
                ['active'] = v.default
            }
        end

        if ConfigTable[v.name].active then
            v.func()
        else
        end
    end
end

-- Frame

local frame = CreateFrame('FRAME')
frame:RegisterEvent('ADDON_LOADED')

function frame:OnEvent(event, arg1)
    if event == 'ADDON_LOADED' and arg1 == 'DragonflightUI' then
        local version = GetAddOnMetadata('DragonflightUI', 'Version')
        print('Dragonflight UI Loaded!')
        CheckConfig()
        SetupOptions()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)
