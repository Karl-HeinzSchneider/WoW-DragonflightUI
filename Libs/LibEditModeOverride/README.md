# LibEditModeOverride

Modify anchors and settings of frames controlled by edit mode _without_
triggering taint issues or requiring a `/reload`.

```lua
local LibEditModeOverride = LibStub("LibEditModeOverride-1.0")
LibEditModeOverride:LoadLayouts()
LibEditModeOverride:ReanchorFrame(MainMenuBar, "TOP", UIParent)
LibEditModeOverride:ApplyChanges()
```

# Usage

## Initialization and saving
### `LibEditModeOverride:IsReady()`
Returns `true` once the Blizzard APIs have loaded the edit mode state. This
happens on `EDIT_MODE_LAYOUTS_UPDATED`.

### `LibEditModeOverride:LoadLayouts()`

Required to call before using any other functions in this library. Queries and saves from
the Blizzard API last saved edit mode frame settings and positions. You **will**
need to call this again if the edit mode UI updates the layouts.

### `LibEditModeOverride:AreLayoutsLoaded()`

Has `LibEditModeOverride:LoadLayouts()` been called at some point?

### `LibEditModeOverride:ApplyChanges()`

Save any changes made and apply any layout changes to the frames. Does not work
during combat.

### `LibEditModeOverride:SaveOnly()`

Save any changes made. Works during combat.

## Frame configuration

### `LibEditModeOverride:ReanchorFrame(frame, ...)`

For a frame that is managed by edit mode change the default anchor. Uses the
same parameters as a `frame:SetPoint(...)` call for the anchor.

### `LibEditModeOverride:SetFrameSetting(frame, setting, value)`

Set an edit mode setting on an edit mode managed frame. Use the enumerations
found in the Blizzard Lua dumps for the setting parameter. See
https://github.com/Gethe/wow-ui-source/blob/live/Interface/FrameXML/EditModePresetLayouts.lua

### `LibEditModeOverride:SetGlobalSetting(setting, value)`

Set an edit mode account-wide setting. This is just an alias for
`C_EditMode.SetAccountSetting`. This setting won't affect the UI outside of edit
mode.

### `LibEditModeOverride:HasEditModeSettings(frame)`

Does this frame have edit mode settings available?

### `LibEditModeOverride:GetFrameSetting(frame, setting)`

Get the value of a specific edit mode setting on an edit mode managed frame.
Use the enumerations found in the Blizzard Lua dumps for the setting parameter.

### `LibEditModeOverride:GetGlobalSetting(setting)`

Get the value of a specific edit mode account-wide setting. This setting won't
affect the UI outside of edit mode.

## Layout management

### `LibEditModeOverride:AddLayout(layoutType, layoutName)`

Create a new layout called `layoutName`. This name must not already be in use.
Set `layoutType` to `Enum.EditModeLayoutType.Account` or
`Enum.EditModeLayoutType.Character` depending on where you want the layout to be
saved.

### `LibEditModeOverride:DeleteLayout(layoutName)`

Delete a layout named `layoutName`. This layout must exist.

### `LibEditModeOverride:SetActiveLayout(layoutName)`

Change the active layout to `layoutName`. This name must exist. You need to call
`LibEditModeOverride:ApplyChanges` or similar for  this to take effect and persist.


### `LibEditModeOverride:DoesLayoutExist(layoutName)`

Does a layout with the name `layoutName` exist?

### `LibEditModeOverride:GetPresetLayoutNames()`

Returns a table of the names of all preset non-editable layouts.

### `LibEditModeOverride:GetEditableLayoutNames()`

Returns a table of the names of all editable layouts.

### `LibEditModeOverride:CanEditActiveLayout()`

Can the current layout be modified, either via edit mode or this library. If it
cannot you will need to create or select a new layout to edit.

### `LibEditModeOverride:GetActiveLayout()`

Returns the string name of the currently active layout.
