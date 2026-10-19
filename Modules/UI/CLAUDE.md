# UI module

This module restyles Blizzard windows: bags, bank, the character frame, inspect, spellbook, talents, professions, trainer, quest, quest log, gossip, taxi, trade, loot, dress-up, PvP and others. [UI.lua](UI.lua) itself is small. It decides **what** to change, and nearly all of the **how** lives in other files:

| File | Contents |
| --- | --- |
| [../../Mixin/UI.mixin.lua](../../Mixin/UI.mixin.lua) (about 5.3k lines) | `DragonflightUIMixin`, a stateless toolbox. It holds the `Change<Frame>[Era\|Cata\|Mists]` methods plus generic reskin helpers (`PortraitFrameTemplate`, `ButtonFrameTemplateNoPortrait`, `CharacterFrameTabButtonTemplate`, `UIPanelCloseButton`, `AddNineSliceTextures`, …). |
| [../../Mixin/ProfessionFrame.mixin.lua](../../Mixin/ProfessionFrame.mixin.lua) and [XML/ProfessionFrame.xml](../../XML/ProfessionFrame.xml) | The replacement profession window `DragonflightUIProfessionFrame` (`DFProfessionFrameTemplate`), created in `UI:UpdateTradeskills()`. Recipe data comes from `Libs/LibTradeSkillRecipes` and [Localization/BlizzardData/Professions.lua](../../Localization/BlizzardData/Professions.lua). |
| [../../Mixin/ProfessionSpellbook.mixin.lua](../../Mixin/ProfessionSpellbook.mixin.lua) and its XML | The "Professions" tab added to the Era-style spellbook |
| [../../Mixin/Talents.mixin.lua](../../Mixin/Talents.mixin.lua) and [XML/Talents.xml](../../XML/Talents.xml) | The Era/TBC talent frame (`ChangeTalentsEra`), with dual-spec and preview |
| `Mixin/CharacterStats{Panel,Era,Tbc,Wrath}.mixin.lua` and `XML/CharacterStatsPanel.xml` | The stat sidebar in the character frame. The template is chosen per client inside `ChangeCharacterFrameEra`. |
| [../../Mixin/EquipmentManager.mixin.lua](../../Mixin/EquipmentManager.mixin.lua) and its XML | DF-styled equipment-set panel built on `C_EquipmentSet`. It is part of the reworked character frame on Era, TBC and Wrath. |
| [../../Mixin/CharacterTab.mixin.lua](../../Mixin/CharacterTab.mixin.lua), `UI.Tabs.mixin.lua`, `XML/UI.xml` | Sidebar tabs and templates |
| [../../Mixin/ItemColor.mixin.lua](../../Mixin/ItemColor.mixin.lua) | Item-quality borders on bags, bank, guild bank, character and inspect frames |
| [GroupLootContainer.mixin.lua](GroupLootContainer.mixin.lua) | Sub-module `GroupLootContainer` (db `roll`): positions the roll frames |

## How UI.lua decides what to change

- `Module:ChangeFrames()` always runs from every version handler. It reskins the DF config frame and the `SettingsPanel`, then applies the per-client reskins. It branches heavily on `Version.IsClassic`, `IsTBC`, `DF.Wrath`, `DF.Cata` and `IsMoP`.
- `ApplySettingsInternal` uses `ConditionalOption` for the user-toggleable one-shot changes in `db.first.*`: `changeBag`, `itemcolor`, `changeTradeskill`, `changeSpellBook`, `changeSpellBookProfessions`, `changeTrainer`, `changeCharacterframe`, `changeInspect`, `changeTalents` and `questLevel`. Turning one off requires a `/reload`.
- Frames from load-on-demand Blizzard addons are handled with `DF:LoadAddOn(...)` plus `Module:FuncOrWaitframe('<Blizzard_X>', fn)`. Examples are `Blizzard_InspectUI`, `Blizzard_TalentUI`, `Blizzard_TrainerUI` and `Blizzard_TradeSkillUI`/`Blizzard_CraftUI`.
- Some options only exist on some clients. The spellbook and talent toggles only appear for Era, TBC and Wrath-only. On Wrath-only, the spellbook, tradeskill and talent toggles default to `false`.
- Several of these frames carry hooks from compatibility code (BiSTracker, CharacterStatsClassic, TacoTip, GearScore, Auctionator). Those integrations check `UIModule['changeCharacterframeHooked']` or hook `UpdateTradeskills`, so rename these carefully. See [../../Compatibility/CLAUDE.md](../../Compatibility/CLAUDE.md).

## Notes

- `DragonflightUIMixin` is used as a static table (`DragonflightUIMixin:ChangeX()`), not mixed into frames. Most methods assume the target Blizzard frame already exists.
- Methods with the `Era` suffix are also used on TBC, and often on Wrath. Check the call site in UI.lua rather than trusting the suffix.
- Leatrix Plus's "Enhance quest log" conflicts with the quest-log reskin. DF prints a warning when it detects it.
