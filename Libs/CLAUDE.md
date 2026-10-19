# Libs/ (vendored third-party code)

Everything here is external code that is copied in, not fetched by the packager (`.pkgmeta` has no `externals`). **Don't edit, reformat or lint these files** unless the task is specifically about a library. If you do patch one, say so in the commit message, because the next library update will overwrite the change.

Loaded from [../DragonflightUI.toc](../DragonflightUI.toc) in this order: LibStub, CallbackHandler, Ace3 (Addon, Comm, Event, DB, DBOptions, Console, GUI, Locale, Serializer, Hook, Config), LibDeflate, LibDataBroker, LibDBIcon, LibEditModeOverride, LibQuestXP, LibRangeCheck-3.0, LibSharedMedia-3.0, TaintLess, LibTradeSkillRecipes. AceBucket, AceTab and AceTimer are present but not loaded.

| Library | What DF uses it for |
| --- | --- |
| Ace3 | Addon and module framework, AceDB profiles, AceLocale, AceHook `SecureHook`, AceComm version ping, AceSerializer for profile export |
| LibDeflate | Profile import/export strings ([../Modules/Core/Profiles.lua](../Modules/Core/Profiles.lua)) |
| LibEditModeOverride-1.0 | **TBC only.** Drives Blizzard EditMode (the `DragonflightUI_Layout` layout, reanchoring, frame settings) |
| LibQuestXP-4.0 | Defines the **global** polyfill `GetQuestLogRewardXP(questID)`, which DF uses for the quest-log XP text (`DragonflightUIMixin:ShowQuestXP` and `GetCompletedQuestsAndXP`). **Locally patched:** recent commits fixed it and its DBs for TBC, Wrath and Cata. |
| LibTradeSkillRecipes-1 | Recipe and expansion data for the profession frame (`Mixin/ProfessionFrame.mixin.lua`) |
| LibRangeCheck-3.0 | The "fade out by distance" alpha on the target, ToT, focus and boss frames |
| LibSharedMedia-3.0 | Statusbar texture choices; DF registers its own textures in [../SharedMedia.lua](../SharedMedia.lua) |
| LibDBIcon-1.0 (+ LibDataBroker) | DF has no button of its own. It uses `GetButtonList()` to hide other addons' minimap buttons until mouseover (Minimap) and to recolor them (Darkmode). |
| TaintLess | Townlong-Yak's fixes for common Blizzard taint |

## Embed/AuraDurations

[../Embed/AuraDurations/](../Embed/AuraDurations/) is the `AuraDurations-1.0` library. It also runs as a standalone addon (`standalone = addonName == 'AuraDurations'`). It bundles its own LibStub, CallbackHandler and LibClassicDurations. It is loaded through `AuraDurations_embed.xml` and supplies the target-frame aura durations. The repo author maintains it, and git history shows both "update embedded version" commits and direct fixes made here. Keep any changes here in sync with its upstream.
