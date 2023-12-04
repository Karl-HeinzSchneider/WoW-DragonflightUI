DragonFlightUIConfigMixin = {}
DragonFlightUIConfigMixin2 = {}

function DragonFlightUIConfigMixin:OnLoad()
    print('DragonFlightUIConfigMixin:OnLoad')

    self.NineSlice.Text:SetText('DragonflightUI')

    local function closePanel()
        self:Close();
    end

    self.CloseButton.Text:SetText(SETTINGS_CLOSE);
    self.CloseButton:SetScript("OnClick", closePanel);

    local settingsList = self:GetSettingsList();
    settingsList.Header.DefaultsButton.Text:SetText(SETTINGS_DEFAULTS);
    settingsList.Header.DefaultsButton:SetScript("OnClick", function(button, buttonName, down)
        -- TODO: defaults
    end);

    self.categorys = {}
    self.lastElement = nil
    self:SetupCategorys()
end

function DragonFlightUIConfigMixin:OnShow()
    print('DragonFlightUIConfigMixin:OnShow')
end

function DragonFlightUIConfigMixin:OnHide()
    print('DragonFlightUIConfigMixin:OnHide')
end

function DragonFlightUIConfigMixin:OnEvent(event, ...)
    print('DragonFlightUIConfigMixin:OnEvent')
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
        self:AddSubCategory(cat, 'Actionbar')
        self:AddSubCategory(cat, 'Castbar')
        self:AddSubCategory(cat, 'Chat')
        self:AddSubCategory(cat, 'Minimap')

        self:AddSpacer(20)
    end

    do
        -- Unitframes
        local cat = self:AddCategory('Unitframes')

        self:AddSubCategory(cat, 'Focus')
        self:AddSubCategory(cat, 'Party')
        self:AddSubCategory(cat, 'Pet')
        self:AddSubCategory(cat, 'Player')
        self:AddSubCategory(cat, 'Target')

        self:AddSpacer(20)
    end

    do
        -- Misc
        local cat = self:AddCategory('Misc')
    end
end

function DragonFlightUIConfigMixin:AddCategory(name)
    local categoryList = self:GetCategoryList()

    local cat = CreateFrame('Frame', 'DragonflightUIConfigCategory' .. name, self,
                            'SettingsCategoryListHeaderTemplateDF')
    cat.Label:SetText(name)
    cat.Background:SetAtlas('Options_CategoryHeader_1', true)

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

function DragonFlightUIConfigMixin:GetAllCategories()
    return self:GetCategoryList():GetAllCategories();
end

function DragonFlightUIConfigMixin:RegisterCategory(category, group, addon)
    self:GetCategoryList():AddCategory(category, group, addon);
end

function DragonFlightUIConfigMixin:GetCategory(categoryName)
    return self:GetCategoryList():GetCategory(categoryName);
end

function DragonFlightUIConfigMixin:GetOrCreateGroup(group, order)
    return self:GetCategoryList():GetOrCreateGroup(group, order);
end

function DragonFlightUIConfigMixin:SelectFirstCategory()
    local categories = self:GetAllCategories();
    if #categories > 0 then self:SelectCategory(categories[1]); end
end
