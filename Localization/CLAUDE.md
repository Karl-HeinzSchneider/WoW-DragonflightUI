# Localization/

AceLocale-3.0 with the locale name `"DragonflightUI"`. Code reads strings through `L["Key"]`, where `L = addonTable.L` or `LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")`. Missing keys fall back to enUS.

| File | Notes |
| --- | --- |
| [enUS.lua](enUS.lua) | The source of truth, about 670 keys. It is created with `NewLocale(..., "enUS", true)` (the default locale), so it always loads. |
| [esES.lua](esES.lua) | Also used for esMX. Missing about 118 keys compared with enUS. |
| [ruRU.lua](ruRU.lua), [zhCN.lua](zhCN.lua) | Each missing about 35 keys. |
| [Bindings.lua](Bindings.lua) | The `BINDING_*` globals for [../Bindings.xml](../Bindings.xml) (action bars 6–8). It uses `DF.API.Version.IsTBC` to add an `(OLD)` prefix on TBC. |
| [BlizzardData/Professions.lua](BlizzardData/Professions.lua) | Localized profession and skill names, plus `DragonflightUILocalizationData:GetSkillIDFromProfessionName(name)`. Used by `Mixin/ProfessionFrame.mixin.lua` and `Mixin/ProfessionSpellbook.mixin.lua`. Recent fixes went here (e.g. Mining/Smelting names on the esES client). |

[../LocalizationData.lua](../LocalizationData.lua) at the repo root creates the global `DragonflightUILocalizationData` table that `Professions.lua` extends. Its `:Get()` (and `Professions.lua`'s `:Getss()`) are leftover debug stubs that print.

There are no deDE, frFR, koKR, ptBR, zhTW or itIT files; those clients show English.

## File pattern (keep it)

```lua
local L_EN = LibStub("AceLocale-3.0"):NewLocale("DragonflightUI", "enUS", true)
-- (other locales: local L_RU = …NewLocale("DragonflightUI", "ruRU"); if not L_RU then return end)
local L = {}            -- plain table so that L["B"] = L["A"] .. "x" works while building
do
    L["ModuleModules"] = "Modules"
    ...
end
for k, v in pairs(L) do L_EN[k] = v; end   -- copy into AceLocale at the very end
```

AceLocale's write proxy can't be read back while you are filling it, which is why the file builds a local table first. Keys are grouped in `do … end` blocks by feature, with a comment naming the source file.

## Adding or changing strings

- Always add the key to `enUS.lua` first. Other locales are optional, and a key missing there falls back to English.
- Key naming follows the feature, for example `ModuleTooltipX`, `CompatXDesc`, `PositionTableAnchor`, `<Frame>Name`/`<Frame>Desc`. Grep for a nearby key and follow its style.
- Prefer Blizzard's global strings (`SETTINGS_CLOSE`, `NONE_KEY`, …) when they exist on every client.
- A few option tables still use hard-coded English (`'Chat'`, `'Scale'`, …). That is legacy, and new UI text should go through `L`.
