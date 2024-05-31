DragonFlightUIConfigMixin = {}
DragonFlightUIConfigMixin2 = {}

function DragonFlightUIConfigMixin:OnLoad()
    -- print('DragonFlightUIConfigMixin:OnLoad')

    self.NineSlice.Text:SetText('DragonflightUI')

    local function closePanel()
        self:Close();
    end

    self.CloseButton.Text:SetText(SETTINGS_CLOSE);
    self.CloseButton:SetScript("OnClick", closePanel);

    --[[    local settingsList = self:GetSettingsList();
    settingsList.Header.DefaultsButton.Text:SetText(SETTINGS_DEFAULTS);
    settingsList.Header.DefaultsButton:SetScript("OnClick", function(button, buttonName, down)
        -- TODO: defaults
    end);

    settingsList.Header.Title:SetText('Title') ]]

    self.categorys = {}
    self.lastElement = nil
    self:SetupCategorys()

    self.selected = nil
    self.selectedFrame = nil
end

function DragonFlightUIConfigMixin:OnShow()
    -- print('DragonFlightUIConfigMixin:OnShow')
    if not self.selected then
        -- local btn = self.categorys['General'].subCategorys['Info']
        -- self:SubCategoryBtnClicked(btn)
        -- btn:UpdateState()
        self:SelectCategory('General', 'Modules')
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

function DragonFlightUIConfigMixin:GetCategoryList()
    return self.CategoryList;
end

function DragonFlightUIConfigMixin:SetupCategorys()
    do
        -- General
        local cat = self:AddCategory('General')
        -- self:AddSubCategory(cat, 'Info')
        self:AddSubCategory(cat, 'Modules')
        self:AddSubCategory(cat, 'Profiles')
        self:AddSubCategory(cat, 'WhatsNew')

        -- self:AddSpacer(20)
    end

    do
        -- Actionbar
        local cat = self:AddCategory('Actionbar')

        self:AddSubCategory(cat, 'Actionbar1')
        self:AddSubCategory(cat, 'Actionbar2')
        self:AddSubCategory(cat, 'Actionbar3')
        self:AddSubCategory(cat, 'Actionbar4')
        self:AddSubCategory(cat, 'Actionbar5')
        self:AddSubCategory(cat, 'Petbar')
        self:AddSubCategory(cat, 'XPbar')
        self:AddSubCategory(cat, 'Repbar')
        self:AddSubCategory(cat, 'Stancebar')
        self:AddSubCategory(cat, 'Bags')
        self:AddSubCategory(cat, 'Micromenu')

        -- self:AddSpacer(20)
    end

    do
        -- Misc
        local cat = self:AddCategory('Misc')
        self:AddSubCategory(cat, 'Castbar')
        self:AddSubCategory(cat, 'Chat')
        self:AddSubCategory(cat, 'Minimap')
        self:AddSubCategory(cat, 'Questtracker')

        -- self:AddSpacer(20)
    end

    do
        -- Unitframes
        local cat = self:AddCategory('Unitframes')

        self:AddSubCategory(cat, 'Boss')
        self:AddSubCategory(cat, 'Focus')
        self:AddSubCategory(cat, 'Party')
        self:AddSubCategory(cat, 'Pet')
        self:AddSubCategory(cat, 'Player')
        self:AddSubCategory(cat, 'Target')
    end
end

function DragonFlightUIConfigMixin:AddCategory(name)
    local categoryList = self:GetCategoryList()

    local cat = CreateFrame('Frame', 'DragonflightUIConfigCategory' .. name, self,
                            'SettingsCategoryListHeaderTemplateDF')
    cat.Label:SetText(name)
    cat.Background:SetAtlas('Options_CategoryHeader_1', true)

    cat:SetCategory(name, self)

    if self.lastElement then
        cat:SetPoint('TOPLEFT', self.lastElement, 'BOTTOMLEFT', 0, 0)
        cat:SetPoint('TOPRIGHT', self.lastElement, 'BOTTOMRIGHT', 0, 0)
    else
        cat:SetPoint('TOPLEFT', self.CategoryList, 'TOPLEFT', 0, 0)
        cat:SetPoint('TOPRIGHT', self.CategoryList, 'TOPRIGHT', 0, 0)
    end

    self.lastElement = cat
    self.categorys[name] = cat

    return cat
end

function DragonFlightUIConfigMixin:AddSubCategory(cat, sub)
    local btn = CreateFrame('Frame', 'DragonflightUIConfigCategoryButton' .. sub, self,
                            'SettingsCategoryListButtonTemplateDF')
    btn.Label:SetText(sub)

    cat:AddSubCategory(btn, sub)
    btn:SetCategory(cat, sub)
    btn:SetCallback(self.SubCategoryBtnClicked)
    --[[    btn:RegisterCallback('BtnClicked', function(self)
        print('ccallback')
    end) ]]

    local gap = 2

    if self.lastElement then
        btn:SetPoint('TOPLEFT', self.lastElement, 'BOTTOMLEFT', 0, -gap)
        btn:SetPoint('TOPRIGHT', self.lastElement, 'BOTTOMRIGHT', 0, -gap)
    else
        btn:SetPoint('TOPLEFT', self.CategoryList, 'TOPLEFT', 0, -gap)
        btn:SetPoint('TOPRIGHT', self.CategoryList, 'TOPRIGHT', 0, -gap)
    end

    self.lastElement = btn

    return btn
end

function DragonFlightUIConfigMixin:AddSpacer(h)
    local sp = CreateFrame('Frame', 'Spacer', self)
    sp:SetHeight(h)

    if self.lastElement then
        sp:SetPoint('TOPLEFT', self.lastElement, 'BOTTOMLEFT', 0, 0)
        sp:SetPoint('TOPRIGHT', self.lastElement, 'BOTTOMRIGHT', 0, 0)
    else
        sp:SetPoint('TOPLEFT', self.CategoryList, 'TOPLEFT', 0, 0)
        sp:SetPoint('TOPRIGHT', self.CategoryList, 'TOPRIGHT', 0, 0)
    end

    self.lastElement = sp

    return sp
end

function DragonFlightUIConfigMixin:GetSettingsList()
    return self.Container.SettingsList;
end

function DragonFlightUIConfigMixin:GetSettingsCanvas()
    return self.Container.SettingsCanvas;
end

function DragonFlightUIConfigMixin:SubCategoryBtnClicked(btn)
    -- print('SubCategoryBtnClicked', btn.category, btn.subCategory)

    self:SelectCategory(btn.category, btn.subCategory)
end

function DragonFlightUIConfigMixin:SelectCategory(cat, sub)
    -- print('select Cat:', cat, sub)

    local category = self.categorys[cat]
    if not category then
        -- print("Category doesn't exist!", cat, sub)
        return
    end
    local subCategory = category.subCategorys[sub]
    if not subCategory then
        -- print("Subcategory doesn't exist!", cat, sub)
        return
    end
    -- local btn = self.categorys['General'].subCategorys['Info']

    local old = self.selected

    if old then
        old.isSelected = false
        old:UpdateState()
    end

    subCategory.isSelected = true
    subCategory:UpdateState()
    self.selected = subCategory

    -- local settingsList = self:GetSettingsList()
    -- settingsList:Display(subCategory.displayData)
    -- settingsList.Header.Title:SetText(subCategory.subCategory)

    local oldFrame = self.selectedFrame
    if oldFrame then oldFrame:Hide() end

    local newFrame = subCategory.displayFrame
    if newFrame then
        newFrame:ClearAllPoints()
        newFrame:SetParent(self.Container)
        newFrame:SetPoint('TOPLEFT', self.Container, 'TOPLEFT', 0, 0)
        newFrame:SetPoint('BOTTOMRIGHT', self.Container, 'BOTTOMRIGHT', 0, 0)
        newFrame:CallRefresh()
        newFrame:Show()
        self.selectedFrame = newFrame
    else
        -- print('no displayframe - nothing to show!')
    end

end

function DragonFlightUIConfigMixin:GetSubCategory(cat, sub)
    local category = self.categorys[cat]
    if not category then
        -- print("Category doesn't exist!", cat, sub)
        return nil
    end
    local subCategory = category.subCategorys[sub]
    if not subCategory then
        -- print("Subcategory doesn't exist!", cat, sub)
        return nil
    end

    return subCategory
end
