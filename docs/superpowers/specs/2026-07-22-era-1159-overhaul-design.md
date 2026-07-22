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
