# Compatibility/

This folder holds fixes that make specific third-party addons look and behave right next to DF's changes. The feature is split across two places:

1. **This folder** (loaded through [../Compatibility.xml](../Compatibility.xml), before the modules) only **defines** functions on `DF.Compatibility`, for example `DF.Compatibility:TDInspect()` or `DF.Compatibility:GearscoreInspect()`. Nothing here should run at load time. The one exception is the NovaWorldBuffs tweak at the bottom of `_Compatibility.lua`.
2. **The `Compatibility` module** ([../Modules/Compatibility/Compatibility.lua](../Modules/Compatibility/Compatibility.lua)) holds one toggle per addon in `db.profile.general.<key>` (all default to `true`). In `ApplySettingsInternal` it calls `self:ConditionalOption(key, 'general', L['Compat…'], fn)`, where `fn` waits for the target addon and calls the function from step 1.

Some calls bypass the module and come straight from other modules. For example, [../Modules/UI/UI.lua](../Modules/UI/UI.lua) calls `DF.Compatibility:TacoTipInspect()`, `GearscoreInspect()` and `ClassicRanker()`.

## Helpers ([_Compatibility.lua](_Compatibility.lua))

- `DF:IsAddOnLoaded(name)` and `DF:LoadAddOn(name)` wrap `C_AddOns.*` and fall back to the old globals. Use them everywhere.
- `DF.Compatibility:FuncOrWaitframe(addon, fn)` runs `fn` now if the addon is loaded, otherwise on its `ADDON_LOADED`. Modules have a similar `Module:FuncOrWaitframe` from `DragonflightUIModulesMixin`.

## Many integrations depend on the UI module

The character-frame, inspect and profession integrations only make sense if the UI module actually replaced those frames. The module checks for this in one of three ways:

- `UIModule['changeCharacterframeHooked']`, the flag `ConditionalOption` sets;
- whether `_G['DragonflightUIProfessionFrame']` exists;
- hooking `UI:ApplySettings`, `UI:UpdateTradeskills` or `DragonflightUIMixin:ChangeCharacterFrameEra` and running later.

If you rename those UI functions or flags, update this folder too.

## Adding a compatibility fix

1. Add `Compatibility/<Addon>.lua` that defines `function DF.Compatibility:<Addon>() … end`, and include it in `Compatibility.xml`.
2. In the Compatibility module, add a default `general.<key> = true`, an option entry (with `L["Compat<Addon>"]` and `L["Compat<Addon>Desc"]`) and a `ConditionalOption` block.
3. Add the strings to [../Localization/enUS.lua](../Localization/enUS.lua).
4. If needed, add the addon to `## OptionalDeps` in the TOC, so it loads first.
5. Guard by client if the target addon only exists on some flavors.
