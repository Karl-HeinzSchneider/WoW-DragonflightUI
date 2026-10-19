# Actionbar module

The largest module. [Actionbar.lua](Actionbar.lua) (about 3.9k lines) holds the defaults, option tables, setup and per-client wiring. The per-bar logic lives in global mixins elsewhere:

- [../../Mixin/Actionbar.mixin.lua](../../Mixin/Actionbar.mixin.lua) (about 2.7k lines): `DragonflightUIActionbarMixin` (one instance per bar), plus `DragonflightUIPetbarMixin`, `DragonflightUIStancebarMixin(Code)` and `DragonflightUIFPSMixin`.
- [../../Mixin/Micromenu.mixin.lua](../../Mixin/Micromenu.mixin.lua): `DragonflightUIMicroMenuMixin`, for the micro menu.
- [../../Mixin/Statusbar.mixin.lua](../../Mixin/Statusbar.mixin.lua): `DragonflightUIXPBarMixin` and `DragonflightUIRepBarMixin`.
- [../../XML/Actionbar.xml](../../XML/Actionbar.xml): `DragonflightUIActionbarFrameTemplate` and related templates.
- [Load.xml](Load.xml) also declares the secure containers `DragonflightUIVehicleLeaveButton`, `DragonflightUIMicroMenuBar` and `DragonflightUIBagBar`.
- Sub-modules: [VehicleLeaveButton.mixin.lua](VehicleLeaveButton.mixin.lua) and [ActionbarRange.mixin.lua](ActionbarRange.mixin.lua), which tints out-of-range buttons.

## Layout of Actionbar.lua

| Lines (approx.) | Contents |
| --- | --- |
| 1–720 | `defaults.profile`: `bar1`…`bar8`, `pet`, `xp`, `rep`, `possess`, `stance`, `totem`, `extraActionButton`, `bags`, `micro`, `fps`, plus the sub-module defaults |
| 720–2050 | Option tables (`GetBarOption(n)`, `GetBarExtraOptions(n)`, `petOptions`, `xpOptions`, `bagsOptions`, `microOptions`, …) and presets |
| 2053–2130 | `OnInitialize`, `OnEnable`, `RegisterSettings` |
| 2130–2460 | `SetupActionbarFrames`: creates `Module.bar1..8` and the secure key-down handler |
| 2463–2830 | `AddEditMode`, `RegisterOptionScreens`, `RefreshOptionScreens` |
| 2832–2910 | `ApplySettingsInternal(sub, key)`, which dispatches on `sub` (`'ALL'`, `'bar1'`…`'bar8'`, `'pet'`, `'xp'`, …) |
| 2913–3810 | Blizzard bar changes: XP/rep, pet bar, possess bar, totems, gryphons, micro menu, backpack/bag bar, FPS |
| 3811–end | `Era/TBC/Wrath/Cata/Mists` handlers. Era and TBC are near-identical; Wrath adds `MoveTotem`; Cata and Mists forward to Wrath. |

## Bars

- Bars 1–5 wrap the Blizzard buttons: `ActionButton`, `MultiBarBottomLeftButton`, `MultiBarBottomRightButton`, `MultiBarLeftButton`, `MultiBarRightButton`. Bar 1 also gets `SetupMainBar()` and `AddPagingStateDriver()`.
- **Bars 6–8 differ by client:**
  - **TBC:** they wrap the native `MultiBar5Button`, `MultiBar6Button` and `MultiBar7Button`. Each bar also gets `bar.BlizzEditmodeFrame` (`MainActionBar`, `MultiBarBottomLeft`, …, `MultiBar7`), and visibility and grid settings are mirrored into Blizzard EditMode (`UpdateBlizzEditmodeState`). The old DF keybinds are moved over by `MigrateOldKeybindsTBC()`. [Localization/Bindings.lua](../../Localization/Bindings.lua) prefixes them with `(OLD)`.
  - **All other clients:** DF creates its own secure `ActionBarButtonTemplate` buttons, `DragonflightUIMultiactionBar{6,7,8}Button{1..12}`, on action slots 145–180. Their key-down/key-up behaviour is handled by a `WrapScript` on the secure handler `DragonflightUIActionBarHandler`, which mirrors the `ActionButtonUseKeyDown` CVar. Their keybinds live in [Bindings.xml](../../Bindings.xml) (`CLICK …:Keybind`).
- `OnEnable` forces the CVar `alwaysShowActionBars = 1`. DF then handles grid visibility per bar through the `alwaysShow` state.
- Quick keybind mode (`/kb`, [../../Mixin/QuickKeybind.mixin.lua](../../Mixin/QuickKeybind.mixin.lua)) has its own hooks for the extra bars (`HookExtraButtons` and `HookExtraButtonsTBC`).

## Things to watch

- This module is heavy on taint. Button attributes, `showgrid`, state drivers and re-parenting must not run in combat. Follow the existing `InCombatLockdown()` checks, `PLAYER_REGEN_ENABLED` deferral and `TrySetAttribute` patterns.
- Several Blizzard globals don't exist on every client (`PossessBarFrame`, `ActionButton_ShowGrid`, `ActionButton_UpdateFlyout`, `ActionButton_UpdateHotkeys`, …). The code either creates fakes (`FAKEPOSSES`) or checks before use. These spots are marked `-- TODOTBC`.
- `Darkmode:UpdateActionbar` re-colors these bars after load through a `C_Timer.After(0)` hack, because bars 2–5 otherwise override it.
- `AddButtonTable` is accidentally a global function.
