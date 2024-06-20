DragonFlightUIConfigMixin = {}
DragonFlightUIConfigMixin2 = {}

local QUICK_KEYBIND_MODE = QUICK_KEYBIND_MODE or "Quick Keybind Mode";

function DragonFlightUIConfigMixin:OnLoad()
    -- print('DragonFlightUIConfigMixin:OnLoad')

    self.NineSlice.Text:SetText('DragonflightUI')

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

function DragonFlightUIConfigMixin:InitCategorys()
    local list = self.DFCategoryList

    local addCat = function(name)
        list:AddElement({name = name, header = true})
    end

    local addSubCat = function(name, cat, new)
        list:AddElement({name = name, cat = cat, new = new})
    end

    local addSpacer = function()
        list:AddElement({name = '*spacer*', spacer = true})
    end

    do
        -- General
        local cat = 'General'
        addCat(cat)
        addSubCat('Info', cat)
        addSubCat('Modules', cat, true)
        addSubCat('Profiles', cat)
        addSubCat('WhatsNew', cat)
    end

    do
        -- Actionbar
        local cat = 'Actionbar'
        addCat(cat)
        addSubCat('Actionbar1', cat, true)
        addSubCat('Actionbar2', cat)
        addSubCat('Actionbar3', cat)
        addSubCat('Actionbar4', cat)
        addSubCat('Actionbar5', cat)

        addSubCat('Petbar', cat)
        addSubCat('XPbar', cat)
        addSubCat('Repbar', cat)
        addSubCat('Stancebar', cat)
        addSubCat('Totembar', cat, true)
        addSubCat('Bags', cat)
        addSubCat('Micromenu', cat)
    end

    do
        -- Castbar
        local cat = 'Castbar'
        addCat(cat)
        addSubCat('Focus', cat)
        addSubCat('Player', cat)
        addSubCat('Target', cat)
    end

    do
        -- Misc
        local cat = 'Misc'
        addCat(cat)
        addSubCat('Buffs', cat, true)
        addSubCat('Chat', cat)
        addSubCat('Minimap', cat)
        addSubCat('Questtracker', cat)
    end

    do
        -- Unitframes
        local cat = 'Unitframes'
        addCat(cat)
        addSubCat('Boss', cat, true)
        addSubCat('Focus', cat)
        addSubCat('Party', cat)
        addSubCat('Pet', cat)
        addSubCat('Player', cat, true)
        addSubCat('Target', cat, true)
    end

    addSpacer()

    -- for i = 0, 35 do addSubCat('TEST', 'General') end
    list:RegisterCallback('OnSelectionChanged', self.OnSelectionChanged, self)
end

function DragonFlightUIConfigMixin:OnSelectionChanged(elementData, selected)
    if not selected then return end
    -- print('DragonFlightUIConfigMixin:OnSelectionChanged', elementData.cat, elementData.name)

    local cats = self.DFCategoryList.Cats

    local cat = cats[elementData.cat]
    local sub = cat[elementData.name]
    local newFrame = sub.displayFrame

    if not newFrame then return end

    local oldFrame = self.selectedFrame
    if oldFrame then oldFrame:Hide() end

    local f = self.Container

    newFrame:ClearAllPoints()
    newFrame:SetParent(f)
    newFrame:SetPoint('TOPLEFT', f, 'TOPLEFT', 0, 0)
    newFrame:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 0, 0)
    newFrame:CallRefresh()
    newFrame:Show()
    self.selectedFrame = newFrame
    self.selected = true
end

function DragonFlightUIConfigMixin:RefreshCatSub(cat, sub)
    local cats = self.DFCategoryList.Cats

    local _cat = cats[cat]
    local _sub = _cat[sub]
    local newFrame = _sub.displayFrame

    if not newFrame then return end

    newFrame:CallRefresh()
end
