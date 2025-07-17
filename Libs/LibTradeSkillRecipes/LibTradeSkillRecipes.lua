local MAJOR = "LibTradeSkillRecipes-1"
local MINOR = 2
assert(LibStub, MAJOR .. " requires LibStub")

local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then
    return
 end

local function getOrCreate(tOfT, key)
    local t = tOfT[key]
    if t == nil then
        t = {}
        tOfT[key] = t
    end
    return t
end

local tInsertUnique = tInsertUnique or table.insert
lib.categories = lib.categories or {}
lib.recipes = lib.recipes or {}
lib.spells = lib.spells or {}
lib.items = lib.items or {}
lib.effects = lib.effects or {}
lib.expansions = lib.expansions or {}
lib.skillLines = lib.skillLines or {}

function lib:AddSkillLine(skillLineId, name, category, spells)
    local hasRecipes = skillLineId ~= 182 and skillLineId ~= 356 and skillLineId ~= 393
    lib.skillLines[skillLineId] = { name = name, isSecondary = category == 9, hasRecipes = hasRecipes, spells = spells}
end

function lib:GetSkillLines()
    return lib.skillLines
end

---Adds the expansion a spell was added.
---@param spellId number 
---@param expansionId number
function lib:AddExpansion(spellId, expansionId)
    local info = lib.spells[spellId]
    if info then
        info.expansionId = expansionId
        local expansions = getOrCreate(lib.expansions, expansionId)
        table.insert(expansions, info)
    end
end

---Adds the name of the enchantment.
---@param id number 
---@param name string
function lib:AddEnchantment(id, name)
    lib.effects[id] = name
end

---Adds an enchantment recipe.
---@param categoryId number
---@param recipeId number|nil
---@param spellId number
---@param effectId number
function lib:AddEnchantmentRecipe(categoryId, recipeId, spellId, effectId)
    self:AddRecipe(categoryId, recipeId, spellId, nil, nil, effectId)
end

function lib:AddCraftingDataRecipe(categoryId, recipeId, spellId, craftingDataId)
    local info = self:AddRecipe(categoryId, recipeId, spellId, nil, nil, nil)
    info.craftingDataId = craftingDataId
end

function lib:AddSalvageRecipe(categoryId, recipeId, spellId, salvageId)
    local info = self:AddRecipe(categoryId, recipeId, spellId, nil, nil, nil)
    info.salvageId = salvageId
end

---Adds a recipe.
---@param categoryId number
---@param recipeId number|nil
---@param spellId number
---@param itemId number|nil
---@param itemSpellId number|nil
---@param effectId number|nil
function lib:AddRecipe(categoryId, recipeId, spellId, itemId, itemSpellId, effectId)
    local info = lib.spells[spellId] or { spellId = spellId }
    lib.spells[spellId] = info
    local categories = getOrCreate(lib.categories, categoryId)
    tInsertUnique(categories, info)

    if info.categoryId then
        -- Currently not sure how retail works, but this works for classic.
        -- assert(info.categoryId == categoryId, "Duplicate spellId doesn't match categoryId: " .. spellId)
    end
    info.categoryId = categoryId

    info.recipeIds = info.recipeIds or {}
    if recipeId then
        lib.recipes[recipeId] = info

        tInsertUnique(info.recipeIds, recipeId)
    end

    if itemId then
        local items = getOrCreate(lib.items, itemId)
        tInsertUnique(items, info)

        if info.itemId then
            assert(info.itemId == itemId, "Duplicate spellId doesn't match itemId: " .. spellId)
        end
        info.itemId = itemId
        if itemSpellId then
            if info.itemSpellId then
                assert(info.itemSpellId == itemSpellId, "Duplicate spellId doesn't match itemSpellId: " .. spellId)
            end
            info.itemSpellId = itemSpellId
        end
    end

    if effectId then
        if info.spellEffectId then
            assert(info.spellEffectId == effectId, "Duplicate spellId doesn't match effectId:" .. spellId)
        end
        info.spellEffectId = effectId
    end
    return info
end

---Gets the name of the effect.
---@param effectId string|number id of the effect
---@return string name of the effect
function lib:GetEffect(effectId)
    return lib.effects[tonumber(effectId)]
end

---Gets all effects, id to name.
---@return table all the effects
function lib:GetEffects()
    return lib.effects
end

---Gets all the associated spells to the given category.
---@param categoryId string|number id of the category
---@return table spell ids associated to the category
function lib:GetCategorySpells(categoryId)
    return lib.categories[tonumber(categoryId)]
end

---Gets all trade categories, id to a table of all the info.
---@return table TradeSkillInfos the categories
function lib:GetCategories()
    return lib.categories
end

---Gets all the associated spells to the given expansion.
---@param expansion string|number
---@return table TradeSkillInfos all skills for that expansion
function lib:GetExpansionSpells(expansion)
    return lib.expansions[tonumber(expansion)]
end

---Gets all expansions, id to a table of all the spells
---@return table expansions to spells
function lib:GetExpansions()
    return lib.expansions
end

---Given an recipe id, returns associated information for crafting.  
---@param recipeId string|number  
---@return table? TradeSkillInfo  
function lib:GetInfoByRecipeId(recipeId)
    ---@diagnostic disable-next-line: cast-local-type
    recipeId = tonumber(recipeId)
    return lib.recipes[recipeId]
end

---Given an item id, returns associated information for crafting.  
---@param itemId string|number  
---@return table? TradeSkillInfos items can have multiple spells if there are different levels created  
function lib:GetInfoByItemId(itemId)
    ---@diagnostic disable-next-line: cast-local-type
    itemId = tonumber(itemId)
    return lib.items[itemId]
end

---Given a spellId id, returns associated information for crafting.  
---@param spellId string|number  
---@return table? TradeSkillInfo  
function lib:GetInfoBySpellId(spellId)
    ---@diagnostic disable-next-line: cast-local-type
    spellId = tonumber(spellId)
    return lib.spells[spellId]
end

---@class TradeSkillInfo
---@field categoryId number trade skill category id for the item or effect 
---@field expansionId number original expansion for the item or effect (0 based)
---@field recipeIds (number)[] list of the all recipe ids to learn the trade skill
---@field spellId number spell used to create the item or effect
---@field itemId? number item that is created from the spell 
---@field spellEffectId? number effect provided by the spell or using the item, e.g. an enchantment
---@field salvageId? number items received from salving, currently has no lookup
---@field craftingDataId? number crafting elements created from the spell