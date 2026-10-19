# DragonflightUI (Classic)

World of Warcraft addon that restyles the default Blizzard UI on the **Classic** clients to look like retail's Dragonflight UI. It is modular: each feature area can be switched on or off. Plain Lua 5.1 plus Blizzard FrameXML. There is no build step, no test suite, and no linter in CI. The code only runs inside the game client.

Sub-docs: [Modules/CLAUDE.md](Modules/CLAUDE.md) · [Mixin/CLAUDE.md](Mixin/CLAUDE.md) (also covers `XML/`) · [Compatibility/CLAUDE.md](Compatibility/CLAUDE.md) · [Localization/CLAUDE.md](Localization/CLAUDE.md) · [Libs/CLAUDE.md](Libs/CLAUDE.md)

## Supported clients

One TOC ([DragonflightUI.toc](DragonflightUI.toc)) serves every flavor:

| Flavor | Interface (TOC) | `DF.API.Version` flag | Legacy flags that are `true` |
| --- | --- | --- | --- |
| Classic Era / SoD / Hardcore | 11508 | `IsClassic` (`IsSoD`, `SeasonID`) | `DF.Era` |
| TBC Anniversary | 20505 | `IsTBC` | **none** |
| Wrath Classic | 30404, 30405 | `IsWotlk` | `DF.Wrath` |
| Cata Classic | 40402 | `IsCata` | `DF.Wrath`, `DF.Cata` |
| MoP Classic | 50503 | `IsMoP` | `DF.Wrath`, `DF.Cata` |

These interface numbers date from the last real commit (2026-05). Check them against the live clients before a release.

### Version flags: read this before touching any `if DF.X`

All flags are defined in [API/Version.API.lua](API/Version.API.lua).

- `DF.Wrath` means interface `>= 30400`, so it is **true on Wrath, Cata and MoP**. "Wrath only" is written `DF.Wrath and not DF.Cata`.
- `DF.Cata` means `>= 40000`, so it is **true on Cata and MoP**.
- `DF.Era` means `<= 20000`, so it is **false on TBC**.
- **TBC is neither `DF.Era` nor `DF.Wrath`.** An old-style chain such as `if DF.Cata … elseif DF.Wrath … else <Era>` either drops TBC or treats it as Era. This is the main source of TBC bugs. Newer code checks `DF.API.Version.IsTBC` explicitly. Prefer the `DF.API.Version.Is*` flags in new code.
- The TBC Anniversary client runs on the modern engine. It has Blizzard EditMode, `MultiBar5-7`, the `Menu`/`rootDescription` dropdown API, and so on. In many respects it behaves more like retail than like Era. See [TBC and Blizzard EditMode](#tbc-and-blizzard-editmode).

## Load order (from the TOC)

1. `Libs/*` (Ace3 and others), then `Embed/AuraDurations`.
2. `Mixin/DFColor.mixin.lua`. It defines `DFCreateColor`, which `Helper.lua` uses at file scope.
3. `Core.lua`. Creates the AceAddon `DF` and sets `addonTable.DF`, `addonTable.L` and `addonTable.SubModuleMixins`.
4. `Helper.lua` (`addonTable.Helper`, also `_G.DragonflightUI_Helper`), then `SharedMedia.lua` (LibSharedMedia statusbars and dropdown generators).
5. `API.xml`. Creates `DF.API` (also `_G.DragonflightUI_API`) **and the version flags**. As a result, `DF.Era`, `DF.API` and the other flags are `nil` while steps 3–4 run.
6. `Config.lua` (AceConfig stub in the Blizzard options, `/rl`), `Version.lua` (AceComm version ping), `VIP.lua` (fake units for edit-mode and tooltip previews).
7. `Localization/*`, with `enUS` first.
8. `XML/Includes.xml` and the `XML/*.xml` files. These hold the frame templates and load their `Mixin/*.lua` files.
9. `Modules/__Settings.lua`. Defines `DF.Settings`: shared dropdown tables, `AddPositionTable` and `ValidateFrame`.
10. `Compatibility.xml`, which loads `Compatibility/*.lua` (function definitions only).
11. `Modules/LoadModules.xml`, which loads each module's `Load.xml`. `Core/` must stay first.

Files run top to bottom, so anything a file uses at file scope must already be defined. A new file does nothing until you add it to the matching `.xml` or the TOC.

## Architecture in brief

- `DF` is `LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')`, also reachable as `addonTable.DF`. SavedVariables: `DragonflightUIDB` (AceDB, profile-based, one namespace per module).
- Each feature area is an AceAddon **module** under `Modules/<Name>/`; see [Modules/CLAUDE.md](Modules/CLAUDE.md). Modules mix in `DragonflightUIModulesMixin` and pick per-client code through `Module:Era()/TBC()/Wrath()/Cata()/Mists()`.
- Large modules are split into **sub-modules**: tables registered in `addonTable.SubModuleMixins[name]` and turned into frames with `DF:CreateFrameFromMixinAndInit`.
- The `Config` module ([Modules/Core/Config.lua](Modules/Core/Config.lua)) controls which modules are enabled and owns the custom settings window (`/df`). The Blizzard AddOns options page only holds a button that opens it, plus an AceDBOptions "Profiles" subpage.
- The `Editmode` module is DF's **own** edit mode (`/editmode`). It is separate from Blizzard EditMode.
- Frames are built from XML templates in `XML/`, with their logic in global mixins in `Mixin/`; see [Mixin/CLAUDE.md](Mixin/CLAUDE.md).
- Public API for other addons is `_G.DragonflightUI_API`, with `.Modules` and `.Version` ([API/](API/)). It fires the `EventRegistry` events `DragonflightUI.Core.OnInitialize/OnEnable` and `DragonflightUI.<Module>.OnInitialize/OnEnable`.

## TBC and Blizzard EditMode

On TBC only, `Editmode:TBC()` calls `InitEditmodeOverride()` in [Modules/Core/Editmode.lua](Modules/Core/Editmode.lua). That function:

- uses `LibEditModeOverride` to create the Blizzard EditMode layout `DragonflightUI_Layout` and force it active;
- defines `addonTable:OverrideBlizzEditmode(frame, point, rel, relPoint, x, y)`, `addonTable:GetBlizzEditmodeFrameSetting[Bool]`, `addonTable:SetBlizzEditmodeFrameSetting(f, setting, value, saveOnly)` and `addonTable:HookBlizzEditmodeAndFunc`.

**These functions exist only on TBC**, so guard every call with `DF.API.Version.IsTBC`. On TBC, the unit frames, action bars, bag bar, micro menu and vehicle-leave button use them to anchor Blizzard frames to DF container frames. The minimap, action bars and target frame also read and write EditMode settings through them. Unit-frame scale is translated into EditMode's `FrameSize` setting. If the user selects a different EditMode layout, the addon prints a warning and skips repositioning. `Editmode:ShowEditmodeWarning()` warns about conflicting Blizzard EditMode account settings.

## Development workflow

- To test, link the repo into a client. Run `npm install` once (Node 20+), then `npm run dev:link -- "<WoW>/_<flavor>_/Interface/AddOns"` (or set `WOW_ADDONS_DIR`). This creates a junction (a symlink on non-Windows) named `DragonflightUI`, taken from `.pkgmeta` `package-as`, that points at the repo root. It refuses to replace an existing folder such as a CurseForge install, so remove that first. Run it once per client, then `/reload` in game. Bugs are client-specific, so test on every affected flavor.
- Node tooling ([src/](src/), [package.json](package.json)) currently has only `dev:link`. It deliberately has no formatter or other tooling. The TypeScript typecheck is `npx tsc --noEmit`.
- In an unpackaged checkout the version shows the literal text `@project-version@`. That is expected.
- `DF:Debug(module, ...)`, `DF:Dump(v)` and the output of `Helper:Benchmark` only print when the character is named `Zimtdev` or `Zimtdevtwo`, a check hard-coded in [Core.lua](Core.lua). To see the output, change that locally and don't commit the change.
- Useful in-game commands: `/df` or `/dragonflight` (config), `/editmode`, `/kb` (quick keybind), `/rl`, plus the Blizzard tools `/dump`, `/fstack`, `/etrace`. Use BugGrabber/BugSack for error stacks.
- Editor: [.vscode/settings.json](.vscode/settings.json) expects the Ketho "WoW API" VS Code extension. It sets Lua 5.1, whitelists many Blizzard globals and turns off most diagnostics.
- Formatting: LuaFormatter ([LuaFormatter.config](LuaFormatter.config)) with 4-space indent and 120 columns. Many lines end with `;`, and there are lots of commented-out `print` lines. That is the house style, so don't mass-clean them.

## Release and packaging

- Releases use the BigWigsMods packager on GitHub Actions. Pushing **any tag** (e.g. `v0.40.3`) publishes a release to CurseForge and GitHub ([release.yml](.github/workflows/release.yml)). Pushing a branch named `*-preview` publishes a preview build ([alpha.yml](.github/workflows/alpha.yml)).
- **Never push tags or `*-preview` branches unless asked**, because that publishes to users.
- [.pkgmeta](.pkgmeta) excludes `Screenshots`, `*.png`, the Node tooling (`src`, `package*.json`, `tsconfig.json`) and the `CLAUDE.md` files from the package. The repo root *is* the addon folder, so any new root-level tooling file must be added there too.

## Conventions

- Typical file header: `local addonName, addonTable = ...;`, then `DF`, `L` and `Helper` taken from `addonTable` or from `LibStub(...):GetAddon/GetLocale`.
- Global frame, mixin and template names start with `DragonflightUI…` or `DF…`. Keep that prefix.
- All user-facing text goes through `L["Key"]`; see [Localization/CLAUDE.md](Localization/CLAUDE.md).
- **Combat lockdown and taint:** never touch secure frames in combat. That includes action buttons, unit frames, and the position or visibility of protected frames. Existing code defers the work to `PLAYER_REGEN_ENABLED`, uses secure handlers and state drivers, or checks `InCombatLockdown()`. Hook Blizzard code with `hooksecurefunc` or AceHook `SecureHook` rather than replacing it.
- Client APIs differ by flavor. Use feature detection (`if ActionButton_ShowGrid then`, `C_AddOns` fallbacks) and the `DF:IsAddOnLoaded` and `DF:LoadAddOn` wrappers. `-- TODOTBC` comments mark spots that were patched with fallbacks for TBC.
- This is a maintenance codebase. Keep fixes minimal and inside the existing structure and patterns, with no refactors unless asked.

## Repo map

| Path | Contents |
| --- | --- |
| `Core.lua`, `Helper.lua`, `Config.lua`, `Version.lua`, `SharedMedia.lua`, `VIP.lua` | Bootstrap code and shared helpers |
| `API/`, `API.xml` | Public API and client-version detection |
| `Modules/` | Feature modules |
| `Mixin/`, `XML/` | Frame templates and their mixins |
| `Compatibility/`, `Compatibility.xml` | Fixes for specific third-party addons |
| `Localization/`, `LocalizationData.lua` | Strings and localized profession data (`LocalizationData.lua` only creates the `DragonflightUILocalizationData` global) |
| `Bindings.xml` | Keybinds for DF action bars 6–8 (used on non-TBC clients) |
| `Textures/` | `.blp`/`.tga` art, referenced as `Interface\AddOns\DragonflightUI\Textures\...` |
| `Libs/`, `Embed/AuraDurations/` | Vendored third-party libraries |
| `TexCoordsRetail*.lua`, `Mixin/Castbar.mixinRetail.lua` | Git-ignored local reference dumps of retail atlas data. Not loaded. |
| `src/`, `package.json`, `tsconfig.json` | Node dev tooling (`npm run dev:link`), not shipped |
| `Blizzard/` | Empty and unused |

## Known tech debt (verified when this file was written)

This list is for planning fixes. Don't fix these items in passing unless asked.

- **TBC gaps:** the `Party` sub-module's `Update()` returns early on TBC (`-- TODOTBC`), so party settings are ignored there. The Pet frame's visibility state handler is skipped on TBC. `Chat:TBC()` is empty, while the other clients register `PLAYER_ENTERING_WORLD` to re-apply settings. There are about 20 `TODOTBC` markers in total.
- `ConfigFrame:RefreshCatSub()` is a no-op (its body is commented out), so every `RefreshOptionScreens → RefreshCatSub` call does nothing.
- `Config:ApplySettingsInternal` enables modules in `pairs()` order, which is not deterministic. Only `Profiles` and `Editmode` (always first) and `Darkmode` (always last) have a fixed position.
- [Modules/Core/Config.lua](Modules/Core/Config.lua) creates a helper event frame with the global name `DragonflightUIConfigFrame`, the same name as the real config frame. The global is overwritten later through `_G`.
- `AddButtonTable` in [Modules/Actionbar/Actionbar.lua](Modules/Actionbar/Actionbar.lua) leaks as a global function.
- `Mixin/DFColor.mixin.lua` is loaded twice (TOC and `XML/DFColorPicker.xml`), and so is `Mixin/SettingsList.mixin.lua` (`XML/Config.xml` and `XML/SettingsList.xml`).
- The legacy config-UI mixins (`SettingsList*`, `SettingsCategoryList*`, `ConfigCategory*`, `DFConfigCategoryList*`) are still loaded but have no live use.
- Missing translations compared with enUS: esES lacks about 118 keys, ruRU and zhCN about 35 each. Missing keys fall back to English.
- [Modules/_Prototype.lua](Modules/_Prototype.lua) is an outdated module template that calls the non-existent `DF:GetModuleEnabled`. It is not loaded.
