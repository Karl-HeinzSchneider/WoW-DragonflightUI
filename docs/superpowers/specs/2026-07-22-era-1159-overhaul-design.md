# DragonflightUI Era-1159 Fork — Design

**Date:** 2026-07-22
**Base:** upstream Karl-HeinzSchneider/WoW-DragonflightUI master @ v0.40.3 (2026-05-06)
**Branch:** `era-1159` · **Version:** `0.40.3-era1`

## Goal

Personal fork of DragonflightUI that runs flawlessly on WoW Classic Era 1.15.9
(interface 11509), with the standalone DFMinimap addon's visual treatment merged
into the fork's Minimap module (DFUI plumbing, DFMinimap look), after which
DFMinimap is retired.

## Decisions (from brainstorm)

- **Era only.** Other flavors' code stays in-tree, untouched, no promises.
- **Personal fork.** Free to restructure; not upstream-mergeable.
- **All modules kept.** Nothing stripped.
- **Minimap base:** DFMinimap's look rebuilt inside `Modules/Minimap`;
  DFUI provides settings/position/scale plumbing.

## Why 1.15.9 breaks things

The patch backports the Midnight-era UI to Classic (2,060 files changed in the
exported source): Blizzard Edit Mode arrives, nameplates and raid frames are
replaced with the Midnight versions, panel management goes retail
(`RestoreUIPanelArea`; see Meridian's fix for the same patch).

DFUI exposure found in recon:
- `Unitframe/Party` anchors to `CompactRaidFrameManager` (raid frames replaced)
- DFUI ships its own positioning system named "EditMode"
  (`DragonflightUIEditMode*`, 364 refs) that now coexists with Blizzard's real
  Edit Mode
- 23 `SetBackdrop` call sites
- `Buffs`, `Castbar`, `Minimap`, `Chat` are Midnight-backport territory
- Zero usage of `UIDropDownMenu_`, `UIPanelWindows`, `WorldMapFrame` — the
  Meridian-class breakage does not apply here

## Method (Approach A — surgical compat pass)

1. **Removed-globals list.** Diff the 1.15.8 vs 1.15.9 exported UI source
   (both trees downloaded): every named XML frame, template, and FrameXML
   global defined in 1.15.8 but absent in 1.15.9 forms the breakage
   dictionary for this patch.
2. **Reference audit.** Extract every Blizzard global DFUI's Era code paths
   reference; intersect with the removed list → finite worklist.
3. **Hand review of hot areas** regardless of audit results: Party/raid
   anchoring, Minimap vs the new Edit-Mode-managed `MinimapCluster`, Buffs,
   Castbar, all `SetBackdrop` sites, DFUI-EditMode vs Blizzard-EditMode.
4. **Edit Mode policy:** DFUI's positioning wins. Where Blizzard Edit Mode
   re-anchors managed frames, re-assert with guarded hooks (Meridian's
   reentrancy discipline: every re-assert idempotent, hooks guarded).
5. **Module isolation.** Wrap module init in pcall so one broken module
   degrades to a chat warning instead of killing the addon.
6. **Minimap merge.** Port DFMinimap's geometry (124-line Init.lua + XML) and
   texture art into `Modules/Minimap` as the Era style; verify Meridian's
   under-minimap HUD still anchors; disable DFMinimap on success.

## Testing

- **Parse pass:** every Lua file must loadfile() cleanly.
- **Boot smoke:** load the TOC's Era file list under a recording stub
  environment; every Blizzard global touched at load time is checked against
  the 1.15.9 export. Catches load-time nil-global crashes headlessly.
- **In-game:** `scriptErrors 1`, iterate on real errors/screenshots,
  module by module. Acceptance: boots clean with all modules on, no Lua
  errors through a normal session, hot areas user-verified, minimap wearing
  the DFMinimap look.

## Deploy

`scripts/deploy.sh` copies the fork over the installed addon. The pre-fork
installed copy is preserved at `DragonflightUI.pre1159.bak` for rollback.

## Implementation notes (as built, 2026-07-22)

- Upstream PR #691 (icebreethe, TBC 2.5.6 + MoP 5.5.4 compat) cherry-picked
  clean onto the fork base: its guards and TextStatusBarMixin fallbacks were
  written for the same Midnight backport and apply to Era unchanged.
- `DF.API.Version.IsModern` added (EditModeManagerFrame /
  StatusTrackingBarManager feature probe); Era routes onto the PR's
  modern-UI paths. BagsBar sites became direct feature checks because Era
  1.15.9 keeps MainMenuBarBagButtons and has no BagsBar.
- Party reskin is skipped on modern clients (1.15.9 pools anonymous
  PartyFrame member frames; upstream has the same TODO for TBC). Blizzard's
  Edit-Mode party frames take over.
- DFMinimap merge implemented as adoption, not texture port: DFUI's Minimap
  module already ships the same retail Dragonflight atlas at 2x resolution;
  DFMinimap's differentiators were geometry (198px map ~ scale 1.4) and
  zone-text click-to-map. On first login the fork detects DFMinimap, applies
  the scale preset, adds the click behavior, disables the old addon
  (one-time, `dfminimapAdopted` flag). DFMinimap was already dead on 1.15.9
  (its RawHook target was removed).
- Module isolation came free: AceAddon safecalls module lifecycle methods,
  so a failing module degrades to an error report without killing the rest.
- Testing as built: luac parse pass over all non-lib Lua (0 failures) plus
  the removed-symbol audit (55 flagged references — all now guarded,
  feature-detected, or on skipped paths; audit script accounts for
  $parent-composed XML names and dynamic CreateFrame concat names). The
  recording-stub boot sim was dropped: with auto-stubbing it cannot
  distinguish removed globals from XML-created frames, so its signal beyond
  the parse pass and static audit is negligible. In-game scriptErrors
  iteration remains the acceptance gate.
