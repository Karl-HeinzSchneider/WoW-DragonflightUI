debugstack = debug.traceback
strmatch = string.match

loadfile("Libs/LibStub/LibStub.lua")()
loadfile("LibTradeSkillRecipes.lua")()
loadfile("recipes/3/items.lua")()
loadfile("recipes/3/enchantments.lua")()
loadfile("recipes/3/skill_lines.lua")()
loadfile("recipes/expansions.lua")()
loadfile("asserts.lua")()

local LibTradeSkillRecipes = LibStub("LibTradeSkillRecipes-1")

-- lib:AddRecipe(165, 2406, 2158, 2307, nil, nil) -- 1359 Fine Leather Boots
local info = LibTradeSkillRecipes:GetInfoByRecipeId(2406)
assertEquals(165, info.categoryId)
assertEquals(0, info.expansionId)
assertTableEquals({2406}, info.recipeIds)
assertEquals(2158, info.spellId)
assertEquals(2307, info.itemId)
assertEquals(nil, info.itemSpellId)
assertEquals(nil, info.spellEffectId)

-- lib:AddRecipe(165, nil, 2152, 2304, 2831, 15) -- 1356 Light Armor Kit
local infos = LibTradeSkillRecipes:GetInfoByItemId(2304)
assertEquals(1, #infos)
info = infos[1]
assertEquals(165, info.categoryId)
assertEquals(0, info.expansionId)
assertTableEquals({}, info.recipeIds)
assertEquals(2152, info.spellId)
assertEquals(2304, info.itemId)
assertEquals(2831, info.itemSpellId)
assertEquals(15, info.spellEffectId)

-- lib:AddRecipe(165, nil, 2153, 2303, nil, nil) -- 1355 Handstitched Leather Pants
info = LibTradeSkillRecipes:GetInfoBySpellId(2153)
assertEquals(165, info.categoryId)
assertEquals(0, info.expansionId)
assertTableEquals({}, info.recipeIds)
assertEquals(2153, info.spellId)
assertEquals(2303, info.itemId)
assertEquals(nil, info.itemSpellId)
assertEquals(nil, info.spellEffectId)

-- lib:AddRecipe(333, 11813, 15596, 11811, nil, nil) -- 8440 Smoking Heart of the Mountain
-- lib:AddRecipe(333, 45050, 15596, 11811, nil, nil) -- 8440 Smoking Heart of the Mountain
info = LibTradeSkillRecipes:GetInfoBySpellId(15596)
assertEquals(333, info.categoryId)
assertEquals(0, info.expansionId)
assertTableEquals({11813, 45050}, info.recipeIds)
assertEquals(15596, info.spellId)
assertEquals(11811, info.itemId)
assertEquals(nil, info.itemSpellId)
assertEquals(nil, info.spellEffectId)

-- lib:AddEnchantmentRecipe(333, 16214, 20008, 1883) -- 11373 Enchant Bracer - Greater Intellect
info = LibTradeSkillRecipes:GetInfoBySpellId(20008)
assertEquals(333, info.categoryId)
assertEquals(0, info.expansionId)
assertTableEquals({16214}, info.recipeIds)
assertEquals(20008, info.spellId)
assertEquals(nil, info.item)
assertEquals(nil, info.itemSpellId)
assertEquals(1883, info.spellEffectId)

-- lib:AddRecipe(186, nil, 55208, 37663, nil, nil) -- 19245 Smelt Titansteel
info = LibTradeSkillRecipes:GetInfoBySpellId(55208)
assertEquals(186, info.categoryId)
assertEquals(2, info.expansionId)
assertTableEquals({}, info.recipeIds)
assertEquals(55208, info.spellId)
assertEquals(37663, info.itemId)
assertEquals(nil, info.itemSpellId)
assertEquals(nil, info.spellEffectId)

info = LibTradeSkillRecipes:GetInfoBySpellId(0)
assertEquals(nil, info)

info = LibTradeSkillRecipes:GetInfoByItemId(0)
assertEquals(nil, info)

info = LibTradeSkillRecipes:GetInfoByRecipeId(0)
assertEquals(nil, info)

local effectName = LibTradeSkillRecipes:GetEffect(15)
assertEquals("Reinforced (+8 Armor)", effectName)

local effects = LibTradeSkillRecipes:GetEffects()
assert(effects ~= nil)

local categorySpells = LibTradeSkillRecipes:GetCategorySpells(165)
assert(categorySpells ~= nil)

local categories = LibTradeSkillRecipes:GetCategories()
assert(categories ~= nil)

local expansionSpells = LibTradeSkillRecipes:GetExpansionSpells(0)
assert(expansionSpells ~= nil)

local expansions = LibTradeSkillRecipes:GetExpansions()
assert(expansions ~= nil)

print("Tests Passed!")