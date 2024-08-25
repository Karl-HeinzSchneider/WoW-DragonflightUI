---@diagnostic disable: undefined-global
-- SettingsCategoryListMixinDF   - Blizzard_CategoryList.lua
SettingsCategoryListMixinDF = {}
function SettingsCategoryListMixinDF:OnLoad()
    self.ScrollBar:Hide()

    self.allCategories = {};
    self.groups = {};
    -- self.categorySet = Settings.CategorySet.Game;
end

function SettingsCategoryListMixinDF:GetAllCategories()
    return self.allCategories;
end

function SettingsCategoryListMixinDF:GetOrCreateGroup(groupText, order)
    local index, tbl = FindInTableIf(self.groups, function(tbl)
        return tbl.groupText == groupText;
    end);

    if not index then
        tbl = {groupText = groupText, order = order or 10, categories = {}};
        table.insert(self.groups, tbl);

        local function Sorter(lhs, rhs)
            return lhs.order < rhs.order;
        end
        table.sort(self.groups, Sorter);
    end
    return tbl;
end

function SettingsCategoryListMixinDF:GetCategory(categoryID)
    for index, tbl in ipairs(self.groups) do
        for index, category in ipairs(tbl.categories) do
            -- local id = securecallfunction(SettingsCategoryMixin.GetID, category);
            local id = category.ID
            if id == categoryID then return category; end
        end
    end
    return nil;
end

function SettingsCategoryListMixinDF:AddCategoryInternal(category, group, addOn)
    -- @TODO
    local hasParentCategory = securecallfunction(SettingsCategoryMixin.HasParentCategory, category);
    if hasParentCategory then
        -- FIXME Will replace when we're not building the whole category list on insert/removal.
        self:CreateCategories();
        return;
    end

    local tbl = self:GetOrCreateGroup(group);
    tbl.categorySet = addOn
    category:SetCategorySet(tbl.categorySet);

    local categories = tbl.categories;
    table.insert(categories, category);
    table.sort(categories, function(lhs, rhs)
        return lhs:GetOrder() < rhs:GetOrder();
    end);

    self.allCategories = {};
    for index, tbl in ipairs(self.groups) do tAppendAll(self.allCategories, tbl.categories); end

    self:CreateCategories();
end

function SettingsCategoryListMixinDF:AddCategory(category, groupText, addon)
    self:AddCategoryInternal(category, groupText, addon);
end

function SettingsCategoryListMixinDF:GetCurrentCategory()
    return self.currentCategory;
end

function SettingsCategoryListMixinDF:FindCategoryElementData(category)
    return self.ScrollBox:FindElementDataByPredicate(function(elementData)
        -- Spacer has no data.
        return elementData.data and (elementData.data.category == category);
    end);
end

function SettingsCategoryListMixinDF:SetCurrentCategory(category)
    self.currentCategory = category;

    -- Ensure that our current category list set contains the category, otherwise select the required set.
    self:SetCategorySet(category:GetCategorySet());

    -- We won't find the category if it is a subcategory whose parent is not expanded. Expand the parent
    -- if necessary, then regenerate the list.
    local parentCategory = category:GetParentCategory();
    if parentCategory and not parentCategory.expanded then
        parentCategory.expanded = true;
        self:CreateCategories();
    end

    -- Under normal circumstances we always expect the category to be found, however this can fail to be found
    -- when initializing the settings categories for the first time.
    local found = self:FindCategoryElementData(category);
    if found then
        -- g_selectionBehavior:SelectElementData(found);
    end

    return self:GetCategorySet();
end

function SettingsCategoryListMixinDF:SetCategorySet(categorySet)
    assert(EnumUtil.IsValid(Settings.CategorySet, categorySet));
    if self.categorySet ~= categorySet then
        self.categorySet = categorySet;
        self:CreateCategories();
    end
end

function SettingsCategoryListMixinDF:GetCategorySet()
    return self.categorySet;
end

function SettingsCategoryListMixinDF:GenerateElementList()
    local currentCategory = self:GetCurrentCategory();
    local headerCounter = CreateCounter();

    local function CreateSection(elementList, categories, indent)
        for index, category in ipairs(categories) do
            if not category.redirectCategory then
                local initializer = CreateCategoryButtonInitializer(category, indent);
                table.insert(elementList, initializer);

                if category == currentCategory then g_selectionBehavior:SelectElementData(initializer); end

                if category.expanded then
                    CreateSection(elementList, category:GetSubcategories(), indent + 10);
                end
            end
        end
    end

    local function CreateGroup(elementList, categories, groupText)
        local indent = 0;
        if self:GetCategorySet() == Settings.CategorySet.Game then
            if groupText then
                local headerIndex = ((headerCounter() - 1) % 3) + 1;
                table.insert(elementList, CreateHeaderInitializer(groupText, headerIndex));
            end
        end

        CreateSection(elementList, categories, indent);
    end

    local elementList = {};

    local createSpacer = false;

    for index, tbl in ipairs(self.groups) do
        local groupText = tbl.groupText;

        if tbl.categorySet == self:GetCategorySet() then
            local categories = tbl.categories;
            if createSpacer then table.insert(elementList, CreateSpacerInitializer()); end

            CreateGroup(elementList, categories, groupText);
            createSpacer = true;
        end
    end

    return elementList;
end

function SettingsCategoryListMixinDF:CreateCategories()
    self.elementList = self:GenerateElementList();
    local dataProvider = CreateDataProvider(self.elementList);
    self.ScrollBox:SetDataProvider(dataProvider, ScrollBoxConstants.RetainScrollPosition);
end

-- stuff

local function CreateCategoryButtonInitializer(category, indent)
    local initializer = CreateFromMixins(CategoryButtonInitializerMixin);
    initializer:Init("SettingsCategoryListButtonTemplate");
    initializer.data = {category = category, indent = indent or 0};
    return initializer;
end

