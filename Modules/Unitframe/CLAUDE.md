# Unitframe module

[Unitframe.lua](Unitframe.lua) is a thin parent. It instantiates the sub-modules, holds the shared db, and contains cross-cutting hooks: `HookEnergyBar`, `ChangeFonts`, `HookDrag`, `AddPortraitMasks`, `HookClassIcon`, `AddRoleSelectDropdownOption` (TBC only) and `FixBlizzardBug`. Almost all real work happens in the `*.mixin.lua` sub-modules. The general sub-module pattern is described in [../CLAUDE.md](../CLAUDE.md#sub-module-pattern).

| File | `SubModuleMixins` key | db sub-table | Settings page | DF container frame |
| --- | --- | --- | --- | --- |
| Player.mixin.lua | `PlayerFrame` | `player` | player | `DragonflightUIPlayerFrame` |
| PlayerSecondaryRes.mixin.lua | `PlayerFrameSecondaryRes` | `playerSecondaryRes` | playerSecondaryRes | – (class bars: runes, holy power, shards, …; combo points are handled in Target) |
| Player.TotemFrame.mixin.lua | `TotemFrame` | `playerTotemFrame` | playerTotemFrame | – |
| Pet.mixin.lua | `PetFrame` | `pet` | pet | `DragonflightUIPetFrame` |
| Target.mixin.lua | `Target` | `target` | target | `DragonflightUITargetFrame` |
| TargetOfTarget.mixin.lua | `TargetOfTarget` | `tot` | targetoftarget | `DragonflightUITargetToTFrame` |
| Focus.mixin.lua | `Focus` | `focus` | focus (Wrath+ and TBC) | `DragonflightUIFocusFrame` |
| FocusTarget.mixin.lua | `FocusTarget` | `focusTarget` | focusTarget (Wrath+ and TBC) | `DragonflightUIFocusToTFrame` |
| Party.mixin.lua | `Party` | `party` | party | `PartyMoveFrame` and the `PreviewParty` preview |
| Raid.mixin.lua | `RaidFrame` | `raid` | raid | – |
| AltPower.mixin.lua | `AltPower` | `altpower` | altpower (`DF.Cata` only) | `PowerBarAltPreview` |

The container frames are declared in [Load.xml](Load.xml) as hidden `SecureFrameTemplate,SecureHandlerEnterLeaveTemplate` frames.

## Which sub-modules run per client

Each version handler (`Module:Era()` and so on, at the bottom of Unitframe.lua) calls `Setup()` on a subset of the sub-modules:

- **Era:** no Focus/FocusTarget, no TotemFrame, no AltPower.
- **TBC:** like Wrath, plus `AddRoleSelectDropdownOption()` and an EditMode warning for the "Target and Focus" setting.
- **Wrath:** everything except AltPower.
- **Cata and Mists:** everything.

A sub-module's `Update()` must not assume its `Setup()` ran. Sub-modules are instantiated on every client, but frames such as `FocusFrame` only exist on some.

## Per-sub-module flow

`Setup()` does the following:

1. registers the settings page (`RegisterSettingsData`);
2. restyles the Blizzard frame (`ChangePlayerframe`, `ChangePetFrame`, …);
3. parents or anchors the Blizzard frame to the DF container;
4. adds the state handler (visibility rules);
5. adds DF edit mode with a fake preview frame from the `DFEditModePreview*Template` templates.

`Update()` then applies scale, position, textures (LibSharedMedia `customHealthBarTexture`/`customPowerBarTexture`), text visibility and so on from `self.state`.

## TBC specifics

- The Blizzard frame is attached to the container with `addonTable:OverrideBlizzEditmode(PlayerFrame, 'CENTER', f, 'CENTER', 0, 0)`; the same applies to Target, Focus and Pet.
- `customAnchorFrame` is forced to `''`.
- Pet scale is clamped to 1.0–2.0 and written to EditMode's `FrameSize` setting instead of `SetScale`.
- Target "buffs on top" is read from and written to the EditMode setting `BuffsOnTop`.
- **Known gaps** (`-- TODOTBC`): `Party:Update()` returns immediately on TBC, and the Pet frame gets no state handler on TBC.
- `TextStatusBar_UpdateTextString` doesn't exist on TBC. Several files wrap it in a local fallback that calls `f:UpdateTextString()`.

## Misc

- Target buffs and debuffs go through the embedded `AuraDurations-1.0` library on every client. `Target.mixin.lua` gets it with `LibStub:GetLibrary(...)` and calls `AuraDurations.frame:SetState(state)` from `Update()`. The library lives in `Embed/AuraDurations/` and bundles LibClassicDurations.
- `Module.famous` and `/cheeese` (the `TakePicture` debug or picture helper) are easter eggs.
- `Module:SaveLocalSettings()` captures the Blizzard Player and Target positions after `UIParent_UpdateTopFramePositions` runs.
