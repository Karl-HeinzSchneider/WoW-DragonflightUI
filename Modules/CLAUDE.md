# Modules

Each folder here is one AceAddon module, loaded through its `Load.xml`, which is included from [LoadModules.xml](LoadModules.xml). `Core/` must load first, because `Config` sets `DF.ConfigModule`, which every other module uses in `OnInitialize`. Inside a `Load.xml`, sub-module mixin files come **before** the module file, because the module instantiates them at file scope.

The per-module docs [Actionbar/CLAUDE.md](Actionbar/CLAUDE.md), [Unitframe/CLAUDE.md](Unitframe/CLAUDE.md) and [UI/CLAUDE.md](UI/CLAUDE.md) cover the three largest modules.

## Module catalog

| Module | On by default | Settings category / pages | Sub-modules (`addonTable.SubModuleMixins`) | Main external files |
| --- | --- | --- | --- | --- |
| **Config** (`Core/`) | always | general: info, modules, whatsnew | – | `Mixin/Config.mixin.lua`, `Mixin/DFSettings*.lua`, `XML/Config.xml` |
| **Profiles** (`Core/`) | always | general: profiles | – | AceDB profiles; import/export through AceSerializer + LibDeflate |
| **Editmode** (`Core/`) | always | (DF edit-mode panel) | – | `Mixin/Editmode*.lua`, `XML/Editmode.xml`; also the TBC Blizzard EditMode bridge |
| Actionbar | yes | actionbar: bars 1–8, pet, xp, rep, possess, stance, bags, micromenu, fps, vehicleLeave, actionbarRange; on `DF.Cata` also totem and extra action button | VehicleLeaveButton, ActionbarRange | `Mixin/Actionbar,Micromenu,Statusbar.mixin.lua`, `XML/Actionbar.xml`, `Bindings.xml` |
| Bossframe | no | unitframes: boss | – | `BossData.lua`, `Mixin/Bossframe.mixin.lua`, `Mixin/ThreatIndicator.mixin.lua`. Its toggle only shows when `DF.Cata`. |
| Buffs | yes | misc: buffs, debuffs | Buff, Debuff | `Mixin/Buff.mixin.lua`, `XML/Buff.xml` |
| Castbar | yes | castbar: player, target, focus (Wrath+ and TBC), mirrorTimer | MirrorTimer | `Mixin/Castbar.mixin.lua`, `Mixin/Castbar.Mirror.mixin.lua`, `XML/Castbar.xml` |
| Chat | no | misc: chat | – | Moves and sizes `ChatFrame1` only; marked WIP |
| Compatibility | yes | general: compatibility | – | Glue only. The implementations live in top-level `Compatibility/`; see [../Compatibility/CLAUDE.md](../Compatibility/CLAUDE.md) |
| Darkmode | no | misc: darkmode | – | Recolors textures created by other modules (`UpdateActionbar`, `UpdateUnitframe` and so on). Config always enables it **last**. |
| Flyout | yes | flyout: custom1..N | – | Secure custom spell/item flyout buttons; `Mixin/Spellflyout.mixin.lua`, `XML/Spellflyout.xml`. Class presets in `AddClassDefaults`. |
| Minimap | yes | misc: minimap, questtracker, durability, lfg | Minimap, Durability | `Mixin/LFG.mixin.lua` (LFG eye) |
| Tooltip | yes | misc: tooltip | – | GameTooltip hooks: unit, spell, item and quest lines, statusbar, anchor |
| UI | yes | misc: ui, roll, widgetBelow | GroupLootContainer | Restyles Blizzard windows; see [UI/CLAUDE.md](UI/CLAUDE.md) |
| Unitframe | yes | unitframes: player, pet, target, targetoftarget, party, raid, playerSecondaryRes, playerTotemFrame; plus focus and focusTarget (Wrath+ and TBC) and altpower (`DF.Cata`) | AltPower, Focus, FocusTarget, Party, PetFrame, PlayerFrame, PlayerFrameSecondaryRes, TotemFrame, RaidFrame, Target, TargetOfTarget | see [Unitframe/CLAUDE.md](Unitframe/CLAUDE.md) |
| Utility | no | misc: utility | – | Currently only class colors in the friends list |

`_Prototype.lua` and `__NewPrototypeSubModule.lua` are templates and are not loaded. `_Prototype.lua` is **outdated**, so copy the shape of a current module such as [Buffs/Buffs.lua](Buffs/Buffs.lua) instead. `__Settings.lua` is loaded from the TOC and defines `DF.Settings`.

## Anatomy of a module (current pattern)

```lua
local addonName, addonTable = ...;
local Helper = addonTable.Helper;
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Foo'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')
Mixin(Module, DragonflightUIModulesMixin)

Module.SubBar = DF:CreateFrameFromMixinAndInit(addonTable.SubModuleMixins['Bar']) -- optional

local defaults = {profile = {scale = 1, bar = Module.SubBar.Defaults, general = {...}}}
Module:SetDefaults(defaults)

function Module:OnInitialize()
    self.db = DF.db:RegisterNamespace(mName, defaults)
    hooksecurefunc(DF:GetModule('Config'), 'AddConfigFrame', function() Module:RegisterSettings() end)
    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))
end

function Module:OnEnable()
    self:SetWasEnabled(true)
    self:EnableAddonSpecific()            -- calls exactly one of Era/TBC/Wrath/Cata/Mists
    Module:ApplySettings()
    Module:RegisterOptionScreens()        -- DF.ConfigModule:RegisterSettingsData(...)
    self:SecureHook(DF, 'RefreshConfig', function() Module:ApplySettings(); Module:RefreshOptionScreens() end)
end

function Module:ApplySettings(sub, key)   -- wrapper so the work is benchmarked
    Helper:Benchmark(string.format('ApplySettings(%s,%s)', tostring(sub), tostring(key)), function()
        Module:ApplySettingsInternal(sub, key)
    end, 0, self)
end

function Module:Era() ... end   function Module:TBC() ... end   function Module:Wrath() ... end
function Module:Cata() ... end  function Module:Mists() ... end
```

### Lifecycle (the order matters)

1. **File load.** Defaults and option tables are built at file scope. Sub-modules are instantiated here, so their `Init()`, `SetDefaults()` and `SetupOptions()` already run at load time.
2. **`OnInitialize`** runs for every module in creation order (Config first). It registers the AceDB namespace and sets the enabled state from `Config.db.profile.modules[mName]`.
3. **AceAddon enables Config.** `Config:OnEnable` calls `EnableAddonSpecific()`, which calls `AddConfigFrame()`. Each module hooked that function in `OnInitialize`, so every module's `RegisterSettings()` now adds its entries to the category list. Entries stay greyed out until their data is registered in step 4.
4. **`Config:ApplySettingsInternal`** calls `DF:EnableModule` for `Profiles` and `Editmode` (always), then for every enabled module in `pairs()` order (non-deterministic), then for `Darkmode`. Each module's `OnEnable` runs its version function and calls `RegisterSettingsData`.
5. **Profile change, copy or reset** calls `DF:RefreshConfig()`. Each module's `SecureHook` on it re-applies settings.

**Disabling a module needs a `/reload`.** `OnDisable` is empty everywhere. If a module was already enabled and the user turns it off, Config only prints a "reload" message.

### `EnableAddonSpecific` (in [../Mixin/Modules.mixin.lua](../Mixin/Modules.mixin.lua))

This walks `IsClassic → Era`, `IsTBC → TBC`, `IsWotlk → Wrath`, `IsCata → Cata`, `IsMoP → Mists`. It calls the first matching `self[...]` method, using **colon** syntax, and stops. A missing handler only produces a debug line, so a client silently gets no setup. Many modules forward one handler to another (`function Module:Cata() Module:Wrath() end`). `Profiles` and the template still use the older `if DF.Cata … elseif DF.Wrath … else` style, which does not handle TBC.

## Settings plumbing

**Option tables** follow the AceConfig shape. They are still registered with AceConfigRegistry, but they are rendered by DF's own list ([../Mixin/DFSettingsList.mixin.lua](../Mixin/DFSettingsList.mixin.lua)), not by AceConfigDialog.

- Group-level fields: `name`, `desc`, `type='group'`, `get`, `set`, `args`. Also `sub` (the db sub-table), `advancedName` (adds an edit-mode visibility toggle to the page header) and `sortComparator`.
- Element `type` can be `header`, `divider`, `toggle`, `range`, `execute`, `select`, `editbox` or `color`. Anything else prints `~no factory`.
- DF-specific element keys:
  - `group = '<headerKey>'` puts the element under a collapsible header (headers can set `isExpanded`).
  - `editmode = true` shows the element in DF's edit-mode side panel.
  - `new = true` adds a "new" badge.
  - `select` needs both `values` (AceConfig map) and `dropdownValues` (an array of `{value,text,tooltip,label}`; the shared tables live in `DF.Settings`).
  - `range` uses `min`, `max` and `bigStep`.
  - `editbox` can have `Validate`.
  - `execute` can have `btnName`.
- `desc` strings usually end with `getDefaultStr(key, sub)`, which appends "(Default: X)".

**Data flow.** For a page registered with `sub = 'pet'`, the list calls `get` and `set` with `info = {'pet', optionKey}`. `DragonflightUIModulesMixin:SetOption` writes `db.profile.pet[optionKey]` and calls `Module:ApplySettings('pet', optionKey)`. Most `ApplySettingsInternal` methods ignore the arguments and re-apply everything, or dispatch on `sub`, as Actionbar does.

**Registration**, both through `DF.ConfigModule`:

- `RegisterSettingsElement(id, categoryID, {order, name, descr, isNew, module}, true)` adds the left-hand list entry, from `RegisterSettings()`.
- `RegisterSettingsData(id, categoryID, {options, sub?, name?, default = fn, sortComparator?})` adds the page content and enables the entry, from `OnEnable`/`Setup`.
- Category IDs: `general`, `actionbar`, `castbar`, `flyout`, `misc`, `unitframes`, defined in `DragonFlightUIConfigMixin:SetupSettingsCategorys`.

**Defaults buttons.** `SetDefaultValues()` resets the whole module and `SetDefaultSubValues(sub)` resets one sub-table. Both call `ApplySettings`.

**One-shot hooks.** `self:ConditionalOption(optionKey, sub, displayName, func)` runs `func` once when the toggle is on. Turning it off later only prints "needs /reload", because Blizzard frames can't be cleanly un-hooked. The `UI`, `Compatibility` and `Utility` modules use this heavily.

## Positioning, visibility and edit mode (shared building blocks)

- **Position defaults** in a sub-table are `scale`, `anchorFrame`, `customAnchorFrame`, `anchor`, `anchorParent`, `x` and `y`. `DF.Settings:AddPositionTable(Module, options, sub, displayName, getDefaultStr, frameTable)` adds the matching option rows. When applying, use `customAnchorFrame` if `DF.Settings.ValidateFrame()` accepts it, otherwise `anchorFrame`. On TBC, several unit frames force `customAnchorFrame = ''`.
- **Visibility defaults** are `alphaNormal`, `alphaCombat`, `showMouseover`, `hideAlways`, `hideCombat`, `hideOutOfCombat`, `hideVehicle`, `hidePet`, `hideNoPet`, `hideStance`, `hideStealth`, `hideNoStealth`, `hideCustom` and `hideCustomCond`. They are driven by `Mixin(f, DragonflightUIStateHandlerMixin); f:InitStateHandler(); f:UpdateStateHandler(state)`, which uses secure state drivers ([../Mixin/StateHandler.mixin.lua](../Mixin/StateHandler.mixin.lua)). `DragonflightUIStateHandlerMixin:AddStateTable(...)` adds the option rows.
- **DF edit mode.** `DF:GetModule('Editmode'):AddEditModeToFrame(f)` creates `f.DFEditModeSelection`. Then call `f.DFEditModeSelection:SetGetLabelTextFunction(fn)` and `:RegisterOptions({options, extra, default, moduleRef, showFunction, hideFunction})`. `showFunction` and `hideFunction` typically toggle a fake preview frame built from the `DFEditModePreview*` templates, filled with `DF:GetRandomVIP()` data. `:RefreshOptionScreen()` re-syncs the panel after a profile change.
- **Container pattern.** Most moved Blizzard frames are parented or anchored to a DF-owned frame (e.g. `DragonflightUIPlayerFrame`, declared in `Unitframe/Load.xml` as `SecureFrameTemplate,SecureHandlerEnterLeaveTemplate`). DF moves the container, not the Blizzard frame. On TBC the Blizzard frame is attached to the container through `addonTable:OverrideBlizzEditmode`; see the root [CLAUDE.md](../CLAUDE.md#tbc-and-blizzard-editmode).

## Sub-module pattern

```lua
local subModuleName = 'PetFrame';
local SubModuleMixin = {};
addonTable.SubModuleMixins[subModuleName] = SubModuleMixin;

function SubModuleMixin:Init()      self.ModuleRef = DF:GetModule('Unitframe'); self:SetDefaults(); self:SetupOptions() end
function SubModuleMixin:SetDefaults() self.Defaults = {...} end        -- becomes defaults.profile.<sub>
function SubModuleMixin:SetupOptions() self.Options = {..., sub = 'pet'}; self.OptionsEditmode = {...} end
function SubModuleMixin:Setup()     -- called from the parent's Era/TBC/Wrath/... handler
    DF.ConfigModule:RegisterSettingsData('pet', 'unitframes', {options = self.Options, default = ...})
    -- create/hook frames, state handler, edit mode
end
function SubModuleMixin:UpdateState(state) self.state = state; self:Update() end -- from parent ApplySettingsInternal
function SubModuleMixin:Update() ... end
```

The sub-module object is a frame (`CreateFrame('Frame')` plus the mixin), so it can register events. The parent module owns the db. The sub-module reads `self.ModuleRef.db` and uses the parent's `GetOption`, `SetOption` and `ApplySettings`.

## Adding a module (checklist)

1. Create `Modules/Foo/Foo.lua` (plus any sub-module files) and `Modules/Foo/Load.xml`, and include it in [LoadModules.xml](LoadModules.xml) after `Core`.
2. Add `['Foo'] = true/false` to `defaults.profile.modules` and a toggle to `modulesOptions` in [Core/Config.lua](Core/Config.lua).
3. Add the `L["ModuleFoo"]` and `L["ModuleTooltipFoo"]` strings to [../Localization/enUS.lua](../Localization/enUS.lua).
4. Implement all five version handlers, even if some only forward to another.
