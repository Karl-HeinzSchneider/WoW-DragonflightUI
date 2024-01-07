DragonFlightUIConfigCategoryMixin = {}

function DragonFlightUIConfigCategoryMixin:OnLoad()
    -- print('DragonFlightUIConfigCategoryMixin:OnLoad()')
    self.category = nil
    self.configRef = nil
    self.subCategorys = {}
end

function DragonFlightUIConfigCategoryMixin:SetCategory(cat, configRef)
    self.category = cat
    self.configRef = configRef
    -- print('SetCat', self.category, cat)
end

function DragonFlightUIConfigCategoryMixin:AddSubCategory(sub, name)
    -- print('AddSubCat', self.category, name)
    self.subCategorys[name] = sub
end

