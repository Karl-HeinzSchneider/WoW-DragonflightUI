-- print('enUS')
local L = LibStub("AceLocale-3.0"):NewLocale("DragonflightUI", "enUS", true)

-- modules - config.lua
L["ModuleTooltipActionbar"] =
    "This module overhauls the default Actionbar including the Micromenu and Bagbuttons.\nAdds seperate options for Actionbar1-8, Pet-/XP-/Rep-/Possess-/Stance-/Totembar, Bags and Micromenu."
L["ModuleTooltipBossframe"] = "This module adds custom BossFrames.\nWORK IN PROGRESS."
L["ModuleTooltipBuffs"] = "This module changes the default BuffFrame.\nAdds seperate options for Buffs and Debuffs."
L["ModuleTooltipCastbar"] =
    "This module changes the default Castbar.\nAdds seperate options for the Player-, Focus- and TargetCastbar."
L["ModuleTooltipChat"] = "This module changes the default Chatwindow.\nWORK IN PROGRESS."
L["ModuleTooltipDarkmode"] =
    "This module adds a Darkmode to multiple frames of DragonflightUI.\nWORK IN PROGRESS - please give feedback!"
L["ModuleTooltipMinimap"] =
    "This module overhauls the default Minimap and Questtracker.\nAdds seperate options for Minimap and Questtracker."
L["ModuleTooltipUI"] =
    "This module adds the modern UI style to different windows like the CharacterFrame. Also adds Era specific reworks with the new Spellbook, Talentframe or Professionwindow."
L["ModuleTooltipUnitframe"] =
    "This module overhauls the default Unitframes, and adds new features like ClassColor or MobHealth(Era).\nAdds seperate options for Player-, Pet-, Target-, Focus-, and PartyUnitframes."
L["ModuleTooltipUtility"] = "This module adds general UI features and tweaks.\nWORK IN PROGRESS"

-- profiles
L["ProfilesSetActiveProfile"] = "Set active profile."
L["ProfilesNewProfile"] = "Create a new profile."
L["ProfilesCopyFrom"] = "Copy the settings from one existing profile into the currently active profile."
L["ProfilesOpenCopyDialogue"] = "Opens copy dialogue."
L["ProfilesDeleteProfile"] = "Delete existing profile from the database."
L["ProfilesOpenDeleteDialogue"] = "Opens delete dialogue."

L["ProfilesChatNewProfile"] = "new profile: "
L["ProfilesErrorNewProfile"] = "ERROR: New profile name cant be empty!"

L["ProfilesDialogueDeleteProfile"] = "Delete profile \'%s\'?"
L["ProfilesDialogueCopyProfile"] = "Copy profile \'%s\'?"

-- __Settings
L["SettingsDefaultStringFormat"] = "\n(Default: |cff8080ff%s|r)"

-- positionTable
L["PositionTableHeader"] = "Scale and Position"
L["PositionTableHeaderDesc"] = ""
L["PositionTableScale"] = "Scale"
L["PositionTableScaleDesc"] = ""
L["PositionTableAnchor"] = "Anchor"
L["PositionTableAnchorDesc"] = "Anchor"
L["PositionTableAnchorParent"] = "Anchor Parent"
L["PositionTableAnchorParentDesc"] = ""
L["PositionTableAnchorFrame"] = "Anchor Frame"
L["PositionTableAnchorFrameDesc"] = ""
L["PositionTableX"] = "X"
L["PositionTableXDesc"] = ""
L["PositionTableY"] = "Y"
L["PositionTableYDesc"] = ""

-- actionbar
L["ActionbarNameFormat"] = "Action Bar %d"

-- bar names
L["XPBar"] = "XP Bar"
L["ReputationBar"] = "Reputation Bar"
L["PetBar"] = "Pet Bar"
L["StanceBar"] = "Stance Bar"
L["PossessBar"] = "Possess Bar"
L["MicroMenu"] = "Micromenu"
L["TotemBar"] = "Totem Bar"

-- gryphonsTable
L["Default"] = "Default"
L["Alliance"] = "Alliance"
L["Horde"] = "Horde"
L["None"] = "None"

-- buttonTable
L["ButtonTableActive"] = "Active"
L["ButtonTableActiveDesc"] = ""

L["ButtonTableButtons"] = "Buttons"
L["ButtonTableButtonsDesc"] = ""

L["ButtonTableButtonScale"] = "Button Scale"
L["ButtonTableButtonScaleDesc"] = ""

L["ButtonTableOrientation"] = "Orientation"
L["ButtonTableOrientationDesc"] = "Orientation"

L["ButtonTableReverseButtonOrder"] = "Reverse Button Order"
L["ButtonTableReverseButtonOrderDesc"] = ""

L["ButtonTableNumRows"] = "Number of Rows"
L["ButtonTableNumRowsDesc"] = ""

L["ButtonTableNumButtons"] = "Number of Buttons"
L["ButtonTableNumButtonsDesc"] = ""

L["ButtonTablePadding"] = "Padding"
L["ButtonTablePaddingDesc"] = ""

L["ButtonTableStyle"] = "Style"
L["ButtonTableStyleDesc"] = ""

L["ButtonTableAlwaysShowActionbar"] = "Always Show Action Bar"
L["ButtonTableAlwaysShowActionbarDesc"] = ""

L["ButtonTableHideMacroText"] = "Hide Macro Text"
L["ButtonTableHideMacroTextDesc"] = ""

L["ButtonTableMacroNameFontSize"] = "Macro Name Font Size"
L["ButtonTableMacroNameFontSizeDesc"] = ""

L["ButtonTableHideKeybindText"] = "Hide Keybind Text"
L["ButtonTableHideKeybindTextDesc"] = ""

L["ButtonTableKeybindFontSize"] = "Keybind Font Size"
L["ButtonTableKeybindFontSizeDesc"] = ""

L["MoreOptionsHideBarArt"] = "Hide Bar Art"
L["MoreOptionsHideBarArtDesc"] = ""

L["MoreOptionsHideBarScrolling"] = "Hide Bar Scrolling"
L["MoreOptionsHideBarScrollingDesc"] = ""

L["MoreOptionsGryphons"] = "Gryphons"
L["MoreOptionsGryphonsDesc"] = "Gryphons"

L["MoreOptionsIconRangeColor"] = "Icon Range Color"
L["MoreOptionsIconRangeColorDesc"] = "Changes the Icon color when Out Of Range, similar to RedRange/tullaRange"

L["ExtraOptionsPreset"] = "Preset"
L["ExtraOptionsResetToDefaultPosition"] = "Reset to Default Position"
L["ExtraOptionsPresetDesc"] =
    "Sets Scale, Anchor, AnchorParent, AnchorFrame, X and Y to that of the chosen preset, but does not change any other setting.";

L["ExtraOptionsModernLayout"] = "Modern Layout (default)"
L["ExtraOptionsModernLayoutDesc"] = ""

L["ExtraOptionsClassicLayout"] = "Classic Layout (sidebar)"
L["ExtraOptionsClassicLayoutDesc"] = ""

-- XP
L["XPOptionsName"] = "XP"
L["XPOptionsDesc"] = "XP"

L["XPOptionsStyle"] = "Style"
L["XPOptionsStyleDesc"] = ""

L["XPOptionsWidth"] = "Width"
L["XPOptionsWidthDesc"] = ""

L["XPOptionsHeight"] = "Height"
L["XPOptionsHeightDesc"] = ""

L["XPOptionsAlwaysShowXPText"] = "Always show XP text"
L["XPOptionsAlwaysShowXPTextDesc"] = ""

L["XPOptionsShowXPPercent"] = "Show XP Percent"
L["XPOptionsShowXPPercentDesc"] = ""

-- rep
L["RepOptionsName"] = "Rep"
L["RepOptionsDesc"] = "Rep"

L["RepOptionsStyle"] = "Style"
L["RepOptionsStyleDesc"] = ""

L["RepOptionsWidth"] = "Width"
L["RepOptionsWidthDesc"] = ""

L["RepOptionsHeight"] = "Height"
L["RepOptionsHeightDesc"] = ""

L["RepOptionsAlwaysShowRepText"] = "Always show Rep text"
L["RepOptionsAlwaysShowRepTextDesc"] = ""

-- Bags
L["BagsOptionsName"] = "Bags"
L["BagsOptionsDesc"] = "Bags"

L["BagsOptionsStyle"] = "Style"
L["BagsOptionsStyleDesc"] = ""

L["BagsOptionsExpanded"] = "Expanded"
L["BagsOptionsExpandedDesc"] = ""

L["BagsOptionsHideArrow"] = "HideArrow"
L["BagsOptionsHideArrowDesc"] = ""

L["BagsOptionsHidden"] = "Hidden"
L["BagsOptionsHiddenDesc"] = "Backpack hidden"

L["BagsOptionsOverrideBagAnchor"] = "Override BagAnchor"
L["BagsOptionsOverrideBagAnchorDesc"] = ""

L["BagsOptionsOffsetX"] = "BagAnchor OffsetX"
L["BagsOptionsOffsetXDesc"] = ""

L["BagsOptionsOffsetY"] = "BagAnchor OffsetY"
L["BagsOptionsOffsetYDesc"] = ""

-- FPS
L["FPSOptionsName"] = "FPS"
L["FPSOptionsDesc"] = "FPS"

L["FPSOptionsStyle"] = "Style"
L["FPSOptionsStyleDesc"] = ""

L["FPSOptionsHideDefaultFPS"] = "Hide Default FPS"
L["FPSOptionsHideDefaultFPSDesc"] = "Hide Default FPS Text"

L["FPSOptionsShowFPS"] = "Show FPS"
L["FPSOptionsShowFPSDesc"] = "Show Custom FPS Text"

L["FPSOptionsAlwaysShowFPS"] = "Always Show FPS"
L["FPSOptionsAlwaysShowFPSDesc"] = "Always Show Custom FPS Text"

L["FPSOptionsShowPing"] = "Show Ping"
L["FPSOptionsShowPingDesc"] = "Show Ping In MS"

-- Buffs
L["BuffsOptionsName"] = "Buffs"
L["BuffsOptionsStyle"] = "Style"
L["BuffsOptionsStyleDesc"] = ""

L["BuffsOptionsExpanded"] = "Expanded"
L["BuffsOptionsExpandedDesc"] = ""

L["BuffsOptionsUseStateHandler"] = "Use State Handler"
L["BuffsOptionsUseStateHandlerDesc"] =
    "Without this, the visibility settings above won't work, but might improve other addon compatibility (e.g. for MinimapAlert) as it does not make frames secure."

