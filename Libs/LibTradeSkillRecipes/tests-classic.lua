debugstack = debug.traceback
strmatch = string.match

loadfile("Libs/LibStub/LibStub.lua")()
loadfile("LibTradeSkillRecipes.lua")()
loadfile("recipes/1/items.lua")()
loadfile("recipes/1/enchantments.lua")()
loadfile("recipes/1/skill_lines.lua")()
loadfile("recipes/expansions.lua")()

local LibTradeSkillRecipes = LibStub("LibTradeSkillRecipes-1")

assert(LibTradeSkillRecipes)
print("Tests Passed!")