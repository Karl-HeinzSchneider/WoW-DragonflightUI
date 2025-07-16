debugstack = debug.traceback
strmatch = string.match

loadfile("Libs/LibStub/LibStub.lua")()
loadfile("LibTradeSkillRecipes.lua")()
loadfile("recipes/10/items.lua")()
loadfile("recipes/10/enchantments.lua")()
loadfile("recipes/10/skill_lines.lua")()
loadfile("recipes/expansions.lua")()
loadfile("asserts.lua")()

local LibTradeSkillRecipes = LibStub("LibTradeSkillRecipes-1")

assert(LibTradeSkillRecipes)

local infos = LibTradeSkillRecipes:GetInfoByItemId(170342)
assertEquals(3, #infos)

-- lib:AddRecipe(165, nil, 304415, 170342, nil, nil) -- 41001 Uncanny Combatant's Leather Gauntlets
local info = infos[1]
assertEquals(165, info.categoryId)
assertEquals(7, info.expansionId)
assertTableEquals({}, info.recipeIds)
assertEquals(304415, info.spellId)
assertEquals(170342, info.itemId)
assertEquals(nil, info.itemSpellId)
assertEquals(nil, info.spellEffectId)

-- lib:AddRecipe(165, 170414, 304416, 170342, nil, nil) -- 41002 Uncanny Combatant's Leather Gauntlets
info = infos[2]
assertEquals(165, info.categoryId)
assertEquals(7, info.expansionId)
assertTableEquals({170414}, info.recipeIds)
assertEquals(304416, info.spellId)
assertEquals(170342, info.itemId)
assertEquals(nil, info.itemSpellId)
assertEquals(nil, info.spellEffectId)

-- lib:AddRecipe(165, 170415, 304417, 170342, nil, nil) -- 41003 Uncanny Combatant's Leather Gauntlets
info = infos[3]
assertEquals(165, info.categoryId)
assertEquals(7, info.expansionId)
assertTableEquals({170415}, info.recipeIds)
assertEquals(304417, info.spellId)
assertEquals(170342, info.itemId)
assertEquals(nil, info.itemSpellId)
assertEquals(nil, info.spellEffectId)
print("Tests Passed!")