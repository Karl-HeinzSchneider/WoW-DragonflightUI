local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

DragonFlightUIConfigMixin = {}
DragonFlightUIConfigMixin2 = {}

local QUICK_KEYBIND_MODE = QUICK_KEYBIND_MODE or L["ConfigMixinQuickKeybindMode"];

function DragonFlightUIConfigMixin:OnLoad()
    -- print('DragonFlightUIConfigMixin:OnLoad')

    local version = C_AddOns.GetAddOnMetadata('DragonflightUI', 'Version')
    local headerTextStr = 'DragonflightUI' .. ' |cff8080ff' .. version .. '|r'
    self.NineSlice.Text:SetText(headerTextStr)

    local function closePanel()
        self:Close();
    end

    self.CloseButton.Text:SetText(SETTINGS_CLOSE);
    self.CloseButton:SetScript("OnClick", closePanel);

    self.KeybindButton:Hide()

    self.MinimizeButton:SetOnMaximizedCallback(function(btn)
        -- print('SetOnMaximizedCallback')
        self:Minimize(false)
    end)
    self.MinimizeButton:SetOnMinimizedCallback(function(btn)
        -- print('SetOnMinimizedCallback')
        self:Minimize(true)
    end)

    --[[    local settingsList = self:GetSettingsList();
    settingsList.Header.DefaultsButton.Text:SetText(SETTINGS_DEFAULTS);
    settingsList.Header.DefaultsButton:SetScript("OnClick", function(button, buttonName, down)
        -- TODO: defaults
    end);

    settingsList.Header.Title:SetText('Title') ]]

    self:InitCategorys()
    self.selectedFrame = nil

    self:SetupSettingsCategorys()
    self:AddToolbar()
end

function DragonFlightUIConfigMixin:OnShow()
    -- print('DragonFlightUIConfigMixin:OnShow')
    if not self.selected then
        -- local btn = self.categorys['General'].subCategorys['Info']
        -- self:SubCategoryBtnClicked(btn)
        -- btn:UpdateState()
        -- self:SelectCategory('General', 'Modules')
        self:OnSelectionChanged({cat = L["ConfigMixinGeneral"], name = L["ConfigMixinModules"]}, true)
    end
end

function DragonFlightUIConfigMixin:OnHide()
    -- print('DragonFlightUIConfigMixin:OnHide')
end

function DragonFlightUIConfigMixin:OnEvent(event, ...)
    -- print('DragonFlightUIConfigMixin:OnEvent')
end

function DragonFlightUIConfigMixin:Close()
    self:Hide()
end

function DragonFlightUIConfigMixin:Minimize(minimize)
    -- print('Minimize', minimize)
    -- <Size x="920" y="724" />
    if minimize then
        self:SetSize(920, 250)
    else
        self:SetSize(920, 724)
    end
end

function DragonFlightUIConfigMixin:InitQuickKeybind()
    self.KeybindButton:Show()
    self.KeybindButton.Text:SetText(QUICK_KEYBIND_MODE);
    self.KeybindButton:SetScript("OnClick", GenerateClosure(self.ShowQuickKeybind, self, true));

    local quick = CreateFrame('Frame', 'DragonflightUIQuickKeybindFrame', UIParent,
                              'DragonflightUIQuickKeybindFrameTemplate')
    quick:Hide()
    self.QuickKeybind = quick
end

function DragonFlightUIConfigMixin:ShowQuickKeybind(show)
    if show then
        self:Close()
        self.QuickKeybind:Show()
    else
        self.QuickKeybind:Hide()
    end
end

function DragonFlightUIConfigMixin:SetupSettingsCategorys()
    local list = self.DFSettingsCategoryList;

    -- first selected
    list.selectedElement = 'general_modules'

    -- default
    local orderSortComparator = function(a, b)
        return b.data.order > a.data.order
    end
    -- alphabetical
    local alphaSortComparator = function(a, b)
        return b.data.elementInfo.name > a.data.elementInfo.name
    end

    -- default categorys
    list:RegisterCategory('general', {name = L["ConfigMixinGeneral"], descr = 'descr..', order = 1, isExpanded = true},
                          alphaSortComparator, true)
    list:RegisterCategory('actionbar',
                          {name = L["ConfigMixinActionBar"], descr = 'descr..', order = 2, isExpanded = true}, nil, true)
    list:RegisterCategory('castbar', {name = L["ConfigMixinCastBar"], descr = 'descr..', order = 3, isExpanded = true},
                          alphaSortComparator, true)
    list:RegisterCategory('flyout', {name = 'Flyout', descr = 'descr..', order = 3.5, isExpanded = true},
                          orderSortComparator, true)
    list:RegisterCategory('misc', {name = L["ConfigMixinMisc"], descr = 'descr..', order = 4, isExpanded = true},
                          alphaSortComparator, true)
    list:RegisterCategory('unitframes',
                          {name = L["ConfigMixinUnitframes"], descr = 'descr..', order = 5, isExpanded = true},
                          alphaSortComparator, true)

    self.SettingsDataTable = {}

    EventRegistry:RegisterCallback("DFSettingsCategoryListMixin.Event.OnSelectionChanged", function(_, newSelected, _)
        --
        -- print('~~OnSelectionChanged', newSelected);
        local displayData = self.SettingsDataTable[newSelected];
        if displayData then
            -- update display
            self.Container.DFSettingsList:Display(displayData)
        else
            -- hide
            self.Container.DFSettingsList:FlushDisplay()
        end
    end, self);

end

function DragonFlightUIConfigMixin:RegisterSettingsElement(id, categoryID, data, firstTime)
    -- e.g. 'minimap', 'misc', {order = 1, name = 'Minimap', descr = 'MinimapDescr', isNew = false}
    if firstTime then
        self.DFSettingsCategoryList:RegisterElement(id, categoryID, data)
    else
        self.DFSettingsCategoryList:UpdateElementData(id, categoryID, data)
    end
end

function DragonFlightUIConfigMixin:RegisterSettingsData(id, categoryID, data)
    local key = categoryID .. '_' .. id;
    self.SettingsDataTable[key] = data;

    local node = self.DFSettingsCategoryList:FindElementDataByKey(key)
    -- print('node?!', key, node:GetData().key)
    if not node then print(id, categoryID, data) end
    local nodeData = node:GetData()
    -- print('node?!', key, nodeData.key)

    -- nodeData.isEnabled = true;
    -- self.DFSettingsCategoryList:UpdateElementData(id, categoryID, nodeData)
    self.DFSettingsCategoryList:EnableElement(id, categoryID)

    if self.DFSettingsCategoryList.selectedElement == key then self.Container.DFSettingsList:Display(data) end
end

function DragonFlightUIConfigMixin:InitCategorys()
    -- local list = self.DFCategoryList

    -- local addCat = function(name)
    --     list:AddElement({name = name, header = true})
    -- end

    -- local addSubCat = function(name, cat, new)
    --     list:AddElement({name = name, cat = cat, new = new})
    -- end

    -- local addSpacer = function()
    --     list:AddElement({name = '*spacer*', spacer = true})
    -- end

    -- do
    --     -- General
    --     local cat = 'General'
    --     addCat(cat)
    --     addSubCat('Info', cat)
    --     addSubCat('Modules', cat)
    --     addSubCat('Profiles', cat)
    --     addSubCat('WhatsNew', cat)
    -- end

    -- do
    --     -- Actionbar
    --     local cat = 'Actionbar'
    --     addCat(cat)
    --     addSubCat('Actionbar1', cat)
    --     addSubCat('Actionbar2', cat)
    --     addSubCat('Actionbar3', cat)
    --     addSubCat('Actionbar4', cat)
    --     addSubCat('Actionbar5', cat)

    --     addSubCat('Actionbar6', cat)
    --     addSubCat('Actionbar7', cat)
    --     addSubCat('Actionbar8', cat)

    --     addSubCat('Petbar', cat)
    --     addSubCat('XPbar', cat)
    --     addSubCat('Repbar', cat)
    --     addSubCat('Possessbar', cat)
    --     addSubCat('Stancebar', cat)
    --     addSubCat('Totembar', cat)
    --     addSubCat('Bags', cat)
    --     addSubCat('Micromenu', cat)
    --     addSubCat('FPS', cat, true)
    -- end

    -- do
    --     -- Castbar
    --     local cat = 'Castbar'
    --     addCat(cat)
    --     if DF.Wrath then addSubCat('Focus', cat, true) end
    --     addSubCat('Player', cat, true)
    --     addSubCat('Target', cat, true)
    -- end

    -- do
    --     -- Misc
    --     local cat = 'Misc'
    --     addCat(cat)
    --     addSubCat('Buffs', cat)
    --     addSubCat('Chat', cat)
    --     addSubCat('Darkmode', cat, true)
    --     addSubCat('Debuffs', cat)
    --     addSubCat('Durability', cat, true)
    --     addSubCat('Minimap', cat)
    --     addSubCat('Questtracker', cat)
    --     addSubCat('UI', cat)
    --     addSubCat('Utility', cat)
    -- end

    -- do
    --     -- Unitframes
    --     local cat = 'Unitframes'
    --     addCat(cat)
    --     if DF.Cata then addSubCat('Boss', cat) end
    --     if DF.Wrath then addSubCat('Focus', cat) end
    --     addSubCat('Party', cat)
    --     addSubCat('Pet', cat)
    --     addSubCat('Player', cat)
    --     addSubCat('Raid', cat)
    --     addSubCat('Target', cat)
    -- end

    -- addSpacer()

    -- for i = 0, 35 do addSubCat('TEST', 'General') end
    -- list:RegisterCallback('OnSelectionChanged', self.OnSelectionChanged, self)
end

function DragonFlightUIConfigMixin:OnSelectionChanged(elementData, selected)
    -- if not selected then return end
    -- -- print('DragonFlightUIConfigMixin:OnSelectionChanged', elementData.cat, elementData.name)

    -- local cats = self.DFCategoryList.Cats

    -- local cat = cats[elementData.cat]
    -- local sub = cat[elementData.name]
    -- local newFrame = sub.displayFrame

    -- if not newFrame then return end

    -- local oldFrame = self.selectedFrame
    -- if oldFrame then oldFrame:Hide() end

    -- local f = self.Container
    -- f.SettingsList:Hide()

    -- newFrame:ClearAllPoints()
    -- newFrame:SetParent(f)
    -- newFrame:SetPoint('TOPLEFT', f, 'TOPLEFT', 0, 0)
    -- newFrame:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 0, 0)
    -- newFrame:CallRefresh()
    -- newFrame:Hide()
    -- self.selectedFrame = newFrame
    -- self.selected = true
end

function DragonFlightUIConfigMixin:RefreshCatSub(cat, sub)
    -- local cats = self.DFCategoryList.Cats

    -- local _cat = cats[cat]
    -- local _sub = _cat[sub]
    -- local newFrame = _sub.displayFrame

    -- if not newFrame then return end

    -- newFrame:CallRefresh()
end

function DragonFlightUIConfigMixin:AddToolbar()
    -- print('DragonFlightUIConfigMixin:AddToolbar()')
    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\Art\\'

    local t = {}
    table.insert(t, {
        name = L["ConfigToolbarDiscord"],
        tooltip = L["ConfigToolbarDiscordTooltip"],
        link = "https://discord.gg/D7CtUHT87G",
        icon = 'discord'
    })
    table.insert(t, {
        name = L["ConfigToolbarGithub"],
        tooltip = L["ConfigToolbarGithubTooltip"],
        link = "https://github.com/Karl-HeinzSchneider/WoW-DragonflightUI",
        icon = 'github',
        sizeDelta = 4
    })
    table.insert(t, {
        name = L["ConfigToolbarCoffee"],
        tooltipTable = {L["ConfigToolbarCoffeeTooltip1"], ' ', L["ConfigToolbarCoffeeTooltip2"]},
        link = "https://buymeacoffee.com/karlheinzschneider",
        icon = 'coffee',
        sizeDelta = 4
    })

    local dialogOpen = false;
    StaticPopupDialogs['DragonflightUILinkCopyPopup'] = {
        text = L["ConfigToolbarCopyPopup"],
        button1 = ACCEPT,
        hasEditBox = true,
        editBoxWidth = 250,
        maxLetters = 0,
        OnShow = function(self, data)
            self.editBox:SetText(data)
            self.editBox:HighlightText()
            self.editBox:SetFocus()
            -- print(dialogOpen, data)
            -- dialogOpen = data;
        end,
        OnHide = function(self)
            self.editBox:SetText("")
            dialogOpen = false
        end,
        EditBoxOnEnterPressed = function(self)
            self:GetParent():Hide()
            dialogOpen = false
        end,
        EditBoxOnEscapePressed = function(self)
            self:GetParent():Hide()
            dialogOpen = false
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3
    }

    local btnT = {}

    for k, v in ipairs(t) do
        local b = CreateFrame("Button", "DragonflightUIConfigToolbar" .. v.name .. 'Button', self)
        table.insert(btnT, b)
        b:SetSize(80, 22)

        b:SetScript("OnClick", function()
            -- print(v.name .. 'Button clicked, open ', v.link)      
            if dialogOpen then
                if dialogOpen == v.name then
                    -- print('same')
                    StaticPopup_Hide('DragonflightUILinkCopyPopup')
                    dialogOpen = false;
                else
                    -- print('different')
                    StaticPopup_Show("DragonflightUILinkCopyPopup", nil, nil, v.link)
                    dialogOpen = v.name
                end
            else
                -- print('not open')
                StaticPopup_Show("DragonflightUILinkCopyPopup", nil, nil, v.link)
                dialogOpen = v.name
            end
        end)

        b:SetScript('OnEnter', function()
            --         
            GameTooltip:SetOwner(b, "ANCHOR_RIGHT");
            -- GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE .. self.collapseTooltip .. FONT_COLOR_CODE_CLOSE);
            GameTooltip:SetText(v.name, 1.0, 1.0, 1.0);

            if v.tooltip then
                GameTooltip:AddLine(v.tooltip or '', NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true);
            elseif v.tooltipTable then
                for i, l in ipairs(v.tooltipTable) do
                    GameTooltip:AddLine(l or '', NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true);
                end
            end
            GameTooltip:Show()
        end)
        b:SetScript('OnLeave', function()
            --      
            GameTooltip:Hide();
        end)

        local tex = b:CreateTexture('Tex')
        tex:SetTexture(base .. v.icon)
        tex:SetSize(22 - (v.sizeDelta or 0), 22 - (v.sizeDelta or 0))
        tex:SetPoint('LEFT', b, 'LEFT', 4, 0)

        local highlight = b:CreateTexture(nil, "HIGHLIGHT")
        highlight:SetAllPoints(b)
        highlight:SetColorTexture(1, 1, 1, 0.1) -- RGB values (yellow) with 0.3 alpha

        local str = b:CreateFontString(nil, 'ARTWORK', 'GameTooltipText')
        str:SetPoint('LEFT', tex, 'RIGHT', 4, 0)
        str:SetText(v.name)

        b:SetWidth(4 + 22 + 4 + str:GetStringWidth() + 4)
    end

    for k, v in ipairs(btnT) do
        if k == 1 then
            v:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 16, 16);
        else
            v:SetPoint('LEFT', btnT[k - 1], 'RIGHT', 4, 0);
        end
    end
end
