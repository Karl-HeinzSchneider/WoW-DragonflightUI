local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

DragonFlightUIConfigMixin = {}
DragonFlightUIConfigMixin2 = {}

local QUICK_KEYBIND_MODE = QUICK_KEYBIND_MODE or "Quick Keybind Mode";

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
end

function DragonFlightUIConfigMixin:OnShow()
    -- print('DragonFlightUIConfigMixin:OnShow')
    if not self.selected then
        -- local btn = self.categorys['General'].subCategorys['Info']
        -- self:SubCategoryBtnClicked(btn)
        -- btn:UpdateState()
        -- self:SelectCategory('General', 'Modules')
        self:OnSelectionChanged({cat = 'General', name = 'Modules'}, true)
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
    list:RegisterCategory('general', {name = 'General', descr = 'descr..', order = 1}, nil, true)
    list:RegisterCategory('actionbar', {name = 'Action Bar', descr = 'descr..', order = 2}, nil, true)
    list:RegisterCategory('castbar', {name = 'Cast Bar', descr = 'descr..', order = 3}, alphaSortComparator, true)
    list:RegisterCategory('misc', {name = 'Misc', descr = 'descr..', order = 4}, alphaSortComparator, true)
    list:RegisterCategory('unitframes', {name = 'Unitframes', descr = 'descr..', order = 5}, alphaSortComparator, true)

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
