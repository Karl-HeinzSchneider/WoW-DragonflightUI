# Mixin/ and XML/

This doc covers both folders, because they come in pairs. `XML/*.xml` defines virtual frame templates (`<Frame name="…Template" mixin="SomeMixin" virtual="true">`) and loads the matching Lua with `<Script file="Mixin/…">` or `<Include>`. The mixins have to be **globals**, because XML can only refer to them by name. The XML files are listed in [DragonflightUI.toc](../DragonflightUI.toc) after Localization. They load before `Modules/`, so modules can rely on every template and mixin below being defined.

## Map

| XML | Mixin file(s) | Main globals | Used by |
| --- | --- | --- | --- |
| `Includes.xml` (no templates) | `Modules.mixin.lua`, `LFG.mixin.lua`, `UI.mixin.lua`, `UI.Tabs.mixin.lua`, `ItemColor.mixin.lua`, `StateHandler.mixin.lua` | `DragonflightUIModulesMixin`, `DragonflightUIEyeTemplateMixin`/`DragonflightUILFGButtonImprovedMixin`, `DragonflightUIMixin`, `DragonflightUIItemColorMixin`, `DragonflightUIStateHandlerMixin` | every module; Minimap (LFG); UI |
| `Actionbar.xml` | `Actionbar.mixin.lua`, `Micromenu.mixin.lua`, `Statusbar.mixin.lua` | `DragonflightUIActionbarMixin`, `…PetbarMixin`, `…StancebarMixin`, `…FPSMixin`, `DragonflightUIMicroMenuMixin`, `DragonflightUIXPBarMixin`, `DragonflightUIRepBarMixin` | Actionbar |
| `Bossframe.xml` | `ThreatIndicator.mixin.lua`, `Bossframe.mixin.lua` | `DragonflightUIBossframeMixin`, `DragonflightUIThreatIndicatorMixin` | Bossframe |
| `Buff.xml` | `Buff.mixin.lua` | `DragonflightUIBuffContainerMixin`, `DragonflightUIAuraButtonTemplateMixin` | Buffs |
| `Castbar.xml` | `Castbar.mixin.lua`, `Castbar.Mirror.mixin.lua` | castbar and mirror-timer mixins | Castbar |
| `CharacterStatsPanel.xml` | `CharacterStatsPanel.mixin.lua`, `CharacterStats{Era,Tbc,Wrath}.mixin.lua` | `DFCharacterStats*Mixin` | UI (character frame) |
| `Config.xml` | `Config.mixin.lua` (+ legacy files, see below) | `DragonFlightUIConfigMixin`, template `DragonflightUIConfigFrameTemplate` | Config |
| `DFSettingsCategory.xml` | `DFSettingsCategory.mixin.lua` | `DFSettingsCategoryListMixin` (left-hand category tree) | Config |
| `DFSettingsList.xml` | `DFSettingsList.mixin.lua` | `DFSettingsListMixin` and one mixin per element type (`…CheckboxContainer`, `…SliderContainer`, `…DropdownContainer`, `…Editbox`, `…ColorPicker`, `…Button`, `…Header`, `…Divider`, `…EditModeButton`) | Config, edit-mode panel |
| `DFSettingsList_Compat.xml` | `DFSettingsList_Compat.mixin.lua` | `DFSettingsListDropdownContainer_CompatMixin` and others | the dropdown widget used on **Wrath only** (`DF.Wrath and not DF.Cata`, chosen in `DFSettingsListMixin:OnLoad`). The other clients use the modern `Menu`-based dropdown. |
| `DFColorPicker.xml` | `DFColor.mixin.lua`, `DFColorPicker.mixin.lua` | `DFCreateColor`, `DFCreateColorFromRGB[A]HexString`, `DFColorPickerMixin` | colour options |
| `Editmode.xml` | `Editmode.mixin.lua`, `EditmodePreview.mixin.lua` | `DragonflightUIEditModeFrameMixin`, `DFEditModeSystemSelectionBaseMixin` (the `DFEditModeSelection` on each frame), grid and magnetism, `DragonflightUIEditModePreview*Mixin` (fake target, party, raid, … frames filled with `DF:GetRandomVIP()`) | Editmode, and any module with edit mode |
| `EquipmentManager.xml` | `EquipmentManager.mixin.lua` | `DFEquipmentManagerMixin`, `DFGearManagerPopupFrameMixin` | UI |
| `ProfessionFrame.xml` | `ProfessionFrame.mixin.lua` | `DFProfessionMixin`, `DFProfessionFrameRecipe*Mixin` | UI |
| `ProfessionSpellbook.xml` | `ProfessionSpellbook.mixin.lua` | spellbook professions tab | UI |
| `QuickKeybind.xml` | `QuickKeybind.mixin.lua` | `DragonFlightUIQuickKeybindMixin`, `DragonflightUIQuickKeybindFrameTemplate` | Config (`/kb`), Actionbar |
| `Spellflyout.xml` | `Spellflyout.mixin.lua` | `DragonflightUISpellFlyoutButtonMixin`, `…SpellSubButtonMixin` | Flyout |
| `Talents.xml` | `Talents.mixin.lua` | `DragonflightUITalentsFrameMixin`, `…TalentsPanelMixin`, `DragonflightUIPlayerSpec*Mixin` | UI |
| `UI.xml` | `CharacterTab.mixin.lua` | `DragonflightUICharacterTabMixin` and shared UI templates | UI |
| `SettingsList.xml` | `SettingsList.mixin.lua` | legacy | – |
| `ConfigCategoryList.xml` | `DFConfigCategoryList.mixin.lua` | legacy | – |

`DFColor.mixin.lua` is also listed directly in the TOC, before `Core.lua`, because `Helper.lua` calls `DFCreateColor` at file scope. As a result it loads twice, which is harmless. The house style is DF's own color object rather than Blizzard's `CreateColor`. Several files alias it with `local CreateColor = DFCreateColor`, so follow that.

## Settings UI (what modules actually render through)

The window is `DragonflightUIConfigFrame`. On the left is `DFSettingsCategoryList` and on the right `Container.DFSettingsList`. `DFSettingsListMixin:Display(data)` turns a module's AceConfig-style option table into a `TreeDataProvider`. Headers come first, then each element is placed under the header named by its `group`. The supported element types and the DF-specific keys are described in [../Modules/CLAUDE.md](../Modules/CLAUDE.md#settings-plumbing). The edit-mode side panel (`DFEditModeSystemSelectionBaseMixin:RegisterOptions`) reuses the same list for the options marked `editmode = true`.

## Legacy and dead code here

- `SettingsList.mixin.lua`, `SettingsCategoryList.mixin.lua`, `ConfigCategory.mixin.lua`, `ConfigCategoryButton.mixin.lua` and `DFConfigCategoryList.mixin.lua` belong to the previous config UI. They are still loaded through `Config.xml`, `SettingsList.xml` and `ConfigCategoryList.xml`, but the frame that used them is commented out in `Config.xml`. Don't build on them.
- `Castbar.mixinRetail.lua` is git-ignored reference code and is not loaded.
- `DragonFlightUIConfigMixin:RefreshCatSub`, `OnSelectionChanged` and `InitCategorys` have commented-out bodies.

## Conventions

- New global names need the `DragonflightUI…` or `DF…` prefix. Template names live in the same global namespace as frames.
- A mixin file is either loaded by its XML or listed in `Includes.xml`, never both. The two files above that load twice are known mistakes.
- `DragonflightUIMixin` (in `UI.mixin.lua`) is a static helper table, called as `DragonflightUIMixin:ChangeX(...)`. It is not mixed into frames.
