-- print('enUS')
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
-- local L_EN = LibStub("AceLocale-3.0"):NewLocale("DragonflightUI", "enUS", true)
local L_EN = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

-- @TODO
-- preprocess to reuse strings - without this L[XY] = L['X'] will fail in AceLocale
local L = {}

-- modules - config.lua
L["ModuleModules"] = "Modules"

L["ModuleTooltipActionbar"] =
    "This module overhauls the default Actionbar including the Micromenu and Bagbuttons.\nAdds seperate options for Actionbar1-8, Pet-/XP-/Rep-/Possess-/Stance-/Totembar, Bags and Micromenu."
L["ModuleTooltipBossframe"] = "This module adds custom BossFrames.\nWORK IN PROGRESS."
L["ModuleTooltipBuffs"] = "This module changes the default BuffFrame.\nAdds seperate options for Buffs and Debuffs."
L["ModuleTooltipCastbar"] =
    "This module changes the default Castbar.\nAdds seperate options for the Player-, Focus- and TargetCastbar."
L["ModuleTooltipChat"] = "This module changes the default Chatwindow.\nWORK IN PROGRESS."
L["ModuleTooltipCompatibility"] = "This module adds extra compatibility for other addons."
L["ModuleTooltipDarkmode"] =
    "This module adds a Darkmode to multiple frames of DragonflightUI.\nWORK IN PROGRESS - please give feedback!"
L["ModuleTooltipMinimap"] =
    "This module overhauls the default Minimap and Questtracker.\nAdds seperate options for Minimap and Questtracker."
L["ModuleTooltipTooltip"] = "This module enhances GameTooltips.\nWORK IN PROGRESS"
L["ModuleTooltipUI"] =
    "This module adds the modern UI style to different windows like the CharacterFrame. Also adds Era specific reworks with the new Spellbook, Talentframe or Professionwindow."
L["ModuleTooltipUnitframe"] =
    "This module overhauls the default Unitframes, and adds new features like ClassColor or MobHealth(Era).\nAdds seperate options for Player-, Pet-, Target-, Focus-, and PartyUnitframes."
L["ModuleTooltipUtility"] = "This module adds general UI features and tweaks.\nWORK IN PROGRESS"

L["ModuleActionbar"] = "Actionbar"
L["ModuleCastbar"] = "Castbar"
L["ModuleChat"] = "Chat"
L["ModuleBuffs"] = "Buffs"
L["ModuleDarkmode"] = "Darkmode"
L["ModuleMinimap"] = "Minimap"
L["ModuleTooltip"] = "Tooltip"
L["ModuleUI"] = "UI"
L["ModuleUnitframe"] = "Unitframe"
L["ModuleUtility"] = "Utility"
L["ModuleCompatibility"] = "Compatibility"
L["ModuleBossframe"] = "Bossframe"

L["ConfigGeneralWhatsNew"] = "What's New"
L["ConfigGeneralModules"] = "Modules"
L["ConfigGeneralInfo"] = "Info"

L["MainMenuDragonflightUI"] = "DragonflightUI"
L["MainMenuEditmode"] = "Editmode"

-- config.mixin.lua
L["ConfigMixinQuickKeybindMode"] = "Quick Keybind Mode"
L["ConfigMixinGeneral"] = "General"
L["ConfigMixinActionBar"] = "Action Bar"
L["ConfigMixinCastBar"] = "Cast Bar"
L["ConfigMixinMisc"] = "Misc"
L["ConfigMixinUnitframes"] = "Unitframes"

-- modules.mixin.lua
L["ModuleConditionalMessage"] =
    "'|cff8080ff%s|r' was deactivated, but the corresponding function was already hooked, please '|cff8080ff/reload|r'!"

-- config
L["ConfigToolbarCopyPopup"] = "Copy the link below (Ctrl+C, Enter):"

L["ConfigToolbarDiscord"] = "Discord"
L["ConfigToolbarDiscordTooltip"] = "Contribute ideas & get support."
L["ConfigToolbarGithub"] = "Github"
L["ConfigToolbarGithubTooltip"] = "View code, report issues & contribute."
L["ConfigToolbarCoffee"] = "BuyMeACoffee"
L["ConfigToolbarCoffeeTooltip1"] =
    "Every comment, like or share counts, but if you're feeling very kind, you can buy me a slice of pizza to fuel further development!"
L["ConfigToolbarCoffeeTooltip2"] = "Supporters enjoy exclusive perks, discover them in our Discord's supporter section."

-- profiles
L["ProfilesSetActiveProfile"] = "Set active profile."
L["ProfilesNewProfile"] = "Create a new profile."
L["ProfilesCopyFrom"] = "Copy the settings from one existing profile into the currently active profile."
L["ProfilesOpenCopyDialogue"] = "Opens copy dialogue."
L["ProfilesDeleteProfile"] = "Delete existing profile from the database."
L["Profiles"] = "Add New Profile"

L["ProfilesOpenDeleteDialogue"] = "Opens delete dialogue."

L["ProfilesAddNewProfile"] = "Add New Profile"

L["ProfilesChatNewProfile"] = "new profile: "
L["ProfilesErrorNewProfile"] = "ERROR: New profile name cant be empty!"

L["ProfilesDialogueDeleteProfile"] = "Delete profile \'%s\'?"
L["ProfilesDialogueCopyProfile"] = "Add New Profile (copy from \'|cff8080ff%s|r\')"

L["ProfilesImportShareHeader"] = "Import/Share"
L["ProfilesImportProfile"] = "Import Profile"
L["ProfilesImportProfileButton"] = HUD_EDIT_MODE_IMPORT_LAYOUT or "Import"
L["ProfilesImportProfileDesc"] = "Opens the import dialogue."
L["ProfilesExportProfile"] = "Share Profile"
L["ProfilesExportProfileButton"] = HUD_EDIT_MODE_SHARE_LAYOUT or "Share"
L["ProfilesExportProfileDesc"] = "Opens the share dialogue."

-- Editmode
L["EditModeBasicOptions"] = "Basic Options"
L["EditModeAdvancedOptions"] = "Advanced Options"
-- L["EditModeLayoutDropdown"] = HUD_EDIT_MODE_LAYOUT or "Layout"
-- L["EditModeCopyLayout"] = HUD_EDIT_MODE_COPY_LAYOUT or "Copy Layout"
-- L["EditModeRenameLayout"] = HUD_EDIT_MODE_RENAME_LAYOUT or "Change Name"
-- L["EditModeRenameOrCopyLayout"] = HUD_EDIT_MODE_RENAME_OR_COPY_LAYOUT or "Rename/Copy Layout"
-- L["EditModeDeleteLayout"] = HUD_EDIT_MODE_DELETE_LAYOUT or "Delete Layout"
-- L["EditModeNewLayoutDisabled"] = HUD_EDIT_MODE_NEW_LAYOUT_DISABLED or "%s New Layout"
-- L["EditModeNewLayout"] = HUD_EDIT_MODE_NEW_LAYOUT or "%s |cnPURE_GREEN_COLOR:New Layout|r"

L["EditModeLayoutDropdown"] = "Profile"
L["EditModeCopyLayout"] = "Copy Profile"
L["EditModeRenameLayout"] = ""
L["EditModeRenameOrCopyLayout"] = "Rename/Copy Profile"
L["EditModeDeleteLayout"] = "Delete Profile"
L["EditModeNewLayoutDisabled"] = "%s New Profile"
L["EditModeNewLayout"] = "%s |cnPURE_GREEN_COLOR:New Profile|r"

L["EditModeImportLayout"] = HUD_EDIT_MODE_IMPORT_LAYOUT or "Import"
L["EditModeShareLayout"] = HUD_EDIT_MODE_SHARE_LAYOUT or "Share"
L["EditModeCopyToClipboard"] = HUD_EDIT_MODE_COPY_TO_CLIPBOARD or "Copy To Clipboard |cffffd100(to share online)|r"

L["EditModeExportProfile"] = "Export profile |cff8080ff%s|r"
L["EditModeImportProfile"] = "Import profile as |cff8080ff%s|r"

-- Compat

L['CompatName'] = "Compatibility"

L['CompatAuctionator'] = "Auctionator"
L['CompatAuctionatorDesc'] =
    "Adds compatibility for Auctionator when using the UI Module with 'Change Profession Window' enabled."
L['CompatBaganator'] = "Baganator"
L['CompatBaganatorDesc'] = "Changes the default 'Blizzard' skin to a DragonflightUI styled one."
L['CompatCharacterStatsClassic'] = "CharacterStatsClassic"
L['CompatCharacterStatsClassicDesc'] =
    "Adds compatibility for Auctionator when using the UI Module with 'Change CharacterFrame' enabled."
L['CompatClassicCalendar'] = "Classic Calendar"
L['CompatClassicCalendarDesc'] = "Adds compatibility for Classic Calendar"
L['CompatLFGBulletinBoard'] = "LFG Bulletin Board"
L['CompatLFGBulletinBoardDesc'] = "Adds compatibility for LFG Bulletin Board"
L['CompatMerInspect'] = "MerInspect"
L['CompatMerInspectDesc'] =
    "Adds compatibility for MerInspect when using the UI Module with 'Change CharacterFrame' enabled."
L['CompatRanker'] = "Ranker"
L['CompatRankerDesc'] = "Adds compatibility for Ranker when using the UI Module with 'Change CharacterFrame' enabled."
L['CompatTacoTip'] = "TacoTip"
L['CompatTacoTipDesc'] = "Adds compatibility for TacoTip when using the UI Module with 'Change CharacterFrame' enabled."
L['CompatTDInspect'] = "TDInspect"
L['CompatTDInspectDesc'] =
    "Adds compatibility for TDInspect when using the UI Module with 'Change CharacterFrame' enabled."
L['CompatWhatsTraining'] = "WhatsTraining"
L['CompatWhatsTrainingDesc'] =
    "Adds compatibility for WhatsTraining when using the UI Module with 'Change SpellBook' enabled."

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
L["PositionTableCustomAnchorFrame"] = "Anchor Frame (custom)"
L["PositionTableCustomAnchorFrameDesc"] =
    "Use this named frame as anchor frame (if it's valid). E.g. 'CharacterFrame', 'TargetFrame'..."
L["PositionTableX"] = "X"
L["PositionTableXDesc"] = ""
L["PositionTableY"] = "Y"
L["PositionTableYDesc"] = ""

-- darkmode
L["DarkmodeColor"] = "Color"
L["DarkmodeDesaturate"] = "Desaturate"

-- actionbar
L["ActionbarName"] = "Action Bar"
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

L["ButtonTableShortenKeybindText"] = "Shorten Keybind Text"
L["ButtonTableShortenKeybindTextDesc"] =
    "Shortens the keybind text, e.g. 'sF' instead of 's-F' and similar replacements."

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

L["XPOptionsStyle"] = L["ButtonTableStyle"]
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

L["RepOptionsStyle"] = L["ButtonTableStyle"]
L["RepOptionsStyleDesc"] = ""

L["RepOptionsWidth"] = L["XPOptionsWidth"]
L["RepOptionsWidthDesc"] = L["XPOptionsWidthDesc"]

L["RepOptionsHeight"] = L["XPOptionsHeight"]
L["RepOptionsHeightDesc"] = L["XPOptionsHeightDesc"]

L["RepOptionsAlwaysShowRepText"] = "Always show Rep text"
L["RepOptionsAlwaysShowRepTextDesc"] = ""

-- Bags
L["BagsOptionsName"] = "Bags"
L["BagsOptionsDesc"] = "Bags"

L["BagsOptionsStyle"] = L["ButtonTableStyle"]
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

L["FPSOptionsStyle"] = L["ButtonTableStyle"]
L["FPSOptionsStyleDesc"] = ""

L["FPSOptionsHideDefaultFPS"] = "Hide Default FPS"
L["FPSOptionsHideDefaultFPSDesc"] = "Hide Default FPS Text"

L["FPSOptionsShowFPS"] = "Show FPS"
L["FPSOptionsShowFPSDesc"] = "Show Custom FPS Text"

L["FPSOptionsAlwaysShowFPS"] = "Always Show FPS"
L["FPSOptionsAlwaysShowFPSDesc"] = "Always Show Custom FPS Text"

L["FPSOptionsShowPing"] = "Show Ping"
L["FPSOptionsShowPingDesc"] = "Show Ping In MS"

-- Extra Action Button
L["ExtraActionButtonOptionsName"] = "Extra Action Button"
L["ExtraActionButtonOptionsNameDesc"] = "FPS"
L["ExtraActionButtonStyle"] = L["ButtonTableStyle"]
L["ExtraActionButtonStyleDesc"] = ""
L["ExtraActionButtonHideBackgroundTexture"] = "Hide Background Texture"
L["ExtraActionButtonHideBackgroundTextureDesc"] = ""
-- Buffs
L["BuffsOptionsName"] = "Buffs"
L["BuffsOptionsStyle"] = L["ButtonTableStyle"]
L["BuffsOptionsStyleDesc"] = ""

L["BuffsOptionsExpanded"] = "Expanded"
L["BuffsOptionsExpandedDesc"] = ""

L["BuffsOptionsUseStateHandler"] = "Use State Handler"
L["BuffsOptionsUseStateHandlerDesc"] =
    "Without this, the visibility settings above won't work, but might improve other addon compatibility (e.g. for MinimapAlert) as it does not make frames secure."

-- Castbar
L["CastbarName"] = "Cast Bar"
L["CastbarNameFormat"] = "%s Cast Bar"
L["CastbarTableActive"] = "Active"
L["CastbarTableActivateDesc"] = ""
L["CastbarTableStyle"] = L["ButtonTableStyle"]
L["CastbarTableStyleDesc"] = ""
L["CastbarTableWidth"] = L["XPOptionsWidth"]
L["CastbarTableWidthDesc"] = L["XPOptionsWidthDesc"]
L["CastbarTableHeight"] = L["XPOptionsHeight"]
L["CastbarTableHeightDesc"] = L["XPOptionsHeightDesc"]
L["CastbarTablePrecisionTimeLeft"] = "Precision (time left)"
L["CastbarTablePrecisionTimeLeftDesc"] = ""
L["CastbarTablePrecisionTimeMax"] = "Precision (time max)"
L["CastbarTablePrecisionTimeMaxDesc"] = ""
L["CastbarTableShowCastTimeText"] = "Show cast time text"
L["CastbarTableShowCastTimeTextDesc"] = ""
L["CastbarTableShowCastTimeMaxText"] = "Show cast time max text"
L["CastbarTableShowCastTimeMaxTextDesc"] = ""
L["CastbarTableCompactLayout"] = "Compact Layout"
L["CastbarTableCompactLayoutDesc"] = ""
L["CastbarTableHoldTimeSuccess"] = "Hold Time (Success)"
L["CastbarTableHoldTimeSuccessDesc"] = "Time before the Castbar starts fading after the Cast was successful."
L["CastbarTableHoldTimeInterrupt"] = "Hold Time (Interrupt)"
L["CastbarTableHoldTimeInterruptDesc"] = "Time before the Castbar starts fading after the Cast was interrupted."
L["CastbarTableShowIcon"] = "Show Icon"
L["CastbarTableShowIconDesc"] = ""
L["CastbarTableIconSize"] = "Icon Size"
L["CastbarTableIconSizeDesc"] = ""
L["CastbarTableShowTicks"] = "Show Ticks"
L["CastbarTableShowTicksDesc"] = ""
L["CastbarTableAutoAdjust"] = "Auto Adjust"
L["CastbarTableAutoAdjustDesc"] =
    "This applies an Y-offset depending on the amount of buffs/debuffs - useful when anchoring the castbar beneath the Target/FocusFrame"
L["CastbarTableShowRank"] = "Show Rank"
L["CastbarTableShowRankDesc"] = ""
L["CastbarTableShowChannelName"] = "Show Channel Name"
L["CastbarTableShowChannelNameDesc"] = "Shows the spell name instead of the display text (e.g. 'Channeling')"

L["ExtraOptionsResetToDefaultStyle"] = "Reset to Default Style"
L["ExtraOptionsPresetStyleDesc"] =
    "Sets all settings that change the style of the castbar, but does not change any other setting."

-- Minimap
L["MinimapName"] = "Minimap"
L["MinimapStyle"] = L["ButtonTableStyle"]
L["MinimapShowPing"] = "Show Ping"
L["MinimapNotYetImplemented"] = "(NOT YET IMPLEMENTED)"
L["MinimapShowPingInChat"] = "Show Ping in Chat"
L["MinimapHideCalendar"] = "Hide Calendar"
L["MinimapHideCalendarDesc"] = "Hides the calendar button"
L["MinimapHideZoomButtons"] = "Hide Zoom Buttons"
L["MinimapHideZoomDesc"] = "Hides the zoom buttons (+) (-)"
L["MinimapSkinMinimapButtons"] = "Skin Minimap Buttons"
L["MinimapSkinMinimapButtonsDesc"] = "Changes the Style of Minimap Buttons using LibDBIcon (most addons use this)"
L["MinimapUseStateHandler"] = "Use State Handler"
L["MinimapUseStateHandlerDesc"] =
    "Without this, the visibility settings above won't work, but might improve other addon compatibility (e.g. for MinimapAlert) as it does not make frames secure."

-- UI
L["UIUtility"] = "Utility"
L["UIChangeBags"] = "Change Bags"
L["UIChangeBagsDesc"] = ""
L["UIColoredInventoryItems"] = "Colored Inventory Items"
L["UIColoredInventoryItemsDesc"] = "Toggle to color inventory items based on their quality."
L["UIShowQuestlevel"] = "Show Questlevel"
L["UIShowQuestlevelDesc"] = "Display the quest level next to the quest name."
L["UIFrames"] = "Frames"
L["UIFramesDesc"] = "Options for modifying various in-game frames."
L["UIChangeCharacterFrame"] = "Change CharacterFrame"
L["UIChangeCharacterFrameDesc"] = "Change the appearance of the  character frame."
L["UIChangeProfessionWindow"] = "Change Profession Window"
L["UIChangeProfessionWindowDesc"] = "Modify the appearance of the profession window."
L["UIChangeInspectFrame"] = "Change InspectFrame"
L["UIChangeInspectFrameDesc"] = "Change the appearance of the inspect frame."
L["UIChangeTrainerWindow"] = "Change Trainer Window"
L["UIChangeTrainerWindowDesc"] = "Change the appearance of the trainer window."
L["UIChangeTalentFrame"] = "Change TalentFrame"
L["UIChangeTalentFrameDesc"] = "Change the layout or appearance of the Talent Frame. (Not available on Wrath)"
L["UIChangeSpellBook"] = "Change SpellBook"
L["UIChangeSpellBookDesc"] = "Change the appearance of the SpellBook."
L["UIChangeSpellBookProfessions"] = "Change SpellBook Professions"
L["UIChangeSpellBookProfessionsDesc"] = "Modify the SpellBook layout for professions."

-- ProfessionFrame
L["ProfessionFrameHasSkillUp"] = "Has skill up"
L["ProfessionFrameHasMaterials"] = CRAFT_IS_MAKEABLE
L["ProfessionFrameSubclass"] = "Subclass"
L["ProfessionFrameSlot"] = "Slot"
L["ProfessionCheckAll"] = "Check All"
L["ProfessionUnCheckAll"] = "Uncheck All"
L["ProfessionFavorites"] = "Favorites"

-- Tooltip
L["TooltipName"] = "Tooltip"
L["TooltipHeaderGameToltip"] = "GameTooltip"
L["TooltipHeaderSpellTooltip"] = "SpellTooltip"

L["TooltipCursorAnchorHeader"] = "Cursor Anchor"
L["TooltipCursorAnchorHeaderDesc"] = ""
L["TooltipAnchorToMouse"] = "Anchor on Cursor"
L["TooltipAnchorToMouseDesc"] = "Anchors some tooltips (e.g. UnitTooltip on WorldFrame) to the mouse cursor."
L["TooltipMouseAnchor"] = "Cursor Anchor"
L["TooltipMouseAnchorDesc"] = ""
L["TooltipMouseX"] = "X"
L["TooltipMouseXDesc"] = ""
L["TooltipMouseY"] = "Y"
L["TooltipMouseYDesc"] = ""

-- spelltooltip
L["TooltipAnchorSpells"] = "Anchor Spells"
L["TooltipAnchorSpellsDesc"] = "Anchors the SpellTooltip on action bars to the button instead of default anchor."
L["TooltipShowSpellID"] = "Show Spell ID"
L["TooltipShowSpellIDDesc"] = ""
L["TooltipShowSpellSource"] = "Show Spell Source"
L["TooltipShowSpellSourceDesc"] = ""
L["TooltipShowSpellIcon"] = "Show Spell Icon"
L["TooltipShowSpellIconDesc"] = ""
L["TooltipShowIconID"] = "Show Icon ID"
L["TooltipShowIconIDDesc"] = ""

L["TooltipShowIcon"] = "Show Icon"
L["TooltipShowIconDesc"] = ""

-- itemtooltip
L["TooltipHeaderItemTooltip"] = "ItemTooltip"
L["TooltipHeaderItemTooltipDesc"] = ""

L["TooltipShowItemQuality"] = "Item Quality Border"
L["TooltipShowItemQualityDesc"] = ""
L["TooltipShowItemQualityBackdrop"] = "Item Quality Backdrop"
L["TooltipShowItemQualityBackdropDesc"] = ""
L["TooltipShowItemStackCount"] = "Show Stack Size"
L["TooltipShowItemStackCountDesc"] = ""
L["TooltipShowItemID"] = "Show Item ID"
L["TooltipShowItemIDDesc"] = ""

-- unittooltip
L["TooltipUnitTooltip"] = "UnitTooltip"
L["TooltipUnitTooltipDesc"] = ""

L["TooltipUnitClassBorder"] = "Class Border"
L["TooltipUnitClassBorderDesc"] = ""
L["TooltipUnitClassBackdrop"] = "Class Backdrop"
L["TooltipUnitClassBackdropDesc"] = ""

L["TooltipUnitReactionBorder"] = "Reaction Border"
L["TooltipUnitReactionBorderDesc"] = ""
L["TooltipUnitReactionBackdrop"] = "Reaction Backdrop"
L["TooltipUnitReactionBackdropDesc"] = ""

L["TooltipUnitClassName"] = "Class Name"
L["TooltipUnitClassNameDesc"] = ""
L["TooltipUnitTitle"] = "Show Title"
L["TooltipUnitTitleDesc"] = ""
L["TooltipUnitRealm"] = "Show Realm"
L["TooltipUnitRealmDesc"] = ""
L["TooltipUnitGuild"] = "Show Guild"
L["TooltipUnitGuildDesc"] = ""
L["TooltipUnitGuildRank"] = "Show Guild Rank"
L["TooltipUnitGuildRankDesc"] = ""
L["TooltipUnitGuildRankIndex"] = "Show Guild Rank Index"
L["TooltipUnitGuildRankIndexDesc"] = ""
L["TooltipUnitGrayOutOnDeath"] = "Gray Out On Death"
L["TooltipUnitGrayOutOnDeathDesc"] = ""
L["TooltipUnitZone"] = "Show Zone Text"
L["TooltipUnitZoneDesc"] = ""
L["TooltipUnitHealthbar"] = "Show Health Bar"
L["TooltipUnitHealthbarDesc"] = ""
L["TooltipUnitHealthbarText"] = "Show Health Bar Text"
L["TooltipUnitHealthbarTextDesc"] = ""
-- Unitframes
L["UnitFramesName"] = "Unitframes"
-- Player
L["PlayerFrameDesc"] = "Player frame settings"
L["PlayerFrameStyle"] = L["ButtonTableStyle"]
L["PlayerFrameClassColor"] = "Class Color"
L["PlayerFrameClassColorDesc"] = "Enable class colors for the health bar"
L["PlayerFrameClassIcon"] = "Class Icon Portrait"
L["PlayerFrameClassIconDesc"] = "Enable class icon as portrait (currently disabled)"
L["PlayerFrameBreakUpLargeNumbers"] = "Break Up Large Numbers"
L["PlayerFrameBreakUpLargeNumbersDesc"] =
    "Enable breaking up large numbers in the StatusText (e.g., 7588 K instead of 7588000)"
L["PlayerFrameBiggerHealthbar"] = "Bigger Healthbar"
L["PlayerFrameBiggerHealthbarDesc"] = "Enable a bigger health bar"
L["PlayerFramePortraitExtra"] = "Portrait Extra"
L["PlayerFramePortraitExtraDesc"] = "Shows an elite, rare or world boss dragon around the PlayerFrame."
L["PlayerFrameHideRedStatus"] = "Hide In Combat Red Statusglow"
L["PlayerFrameHideRedStatusDesc"] = "Hide the red status glow in combat"
L["PlayerFrameHideHitIndicator"] = "Hide Hit Indicator"
L["PlayerFrameHideHitIndicatorDesc"] = "Hide the hit indicator on the player frame"
L["PlayerFrameHideSecondaryRes"] = "Hide Secondary Ressource"
L["PlayerFrameHideSecondaryResDesc"] = "Hide the secondary ressource, e.g. soul shards."
L["PlayerFrameHideAlternatePowerBar"] = "Hide Druid Alternate Power Bar"
L["PlayerFrameHideAlternatePowerBarDesc"] = "Hide the Druid Alternate Power Bar (Mana Bar while Bear/Cat form)."

-- Target
L["TargetFrameDesc"] = "Target frame settings"
L["TargetFrameStyle"] = L["ButtonTableStyle"]
L["TargetFrameClassColor"] = L["PlayerFrameClassColor"]
L["TargetFrameClassColorDesc"] = "Enable class colors for the health bar"
L["TargetFrameClassIcon"] = L["PlayerFrameClassIcon"]
L["TargetFrameClassIconDesc"] = L["PlayerFrameClassIconDesc"]
L["TargetFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
L["TargetFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
L["TargetFrameNumericThreat"] = "Numeric Threat"
L["TargetFrameNumericThreatDesc"] = "Enable numeric threat display"
L["TargetFrameNumericThreatAnchor"] = "Numeric Threat Anchor"
L["TargetFrameNumericThreatAnchorDesc"] = "Sets the numeric threat anchor(position)"
L["TargetFrameThreatGlow"] = "Threat Glow"
L["TargetFrameThreatGlowDesc"] = "Enable threat glow effect"
L["TargetFrameHideNameBackground"] = "Hide Name Background"
L["TargetFrameHideNameBackgroundDesc"] = "Hide the background of the target's name"
L["TargetFrameComboPointsOnPlayerFrame"] = "Combo Points on PlayerFrame"
L["TargetFrameComboPointsOnPlayerFrameDesc"] = "Show combo points on the player frame."
L["TargetFrameHideComboPoints"] = "Hide Combo Points"
L["TargetFrameHideComboPointsDesc"] = "Hides the combo points frame."
L["TargetFrameFadeOut"] = "Fadeout"
L["TargetFrameFadeOutDesc"] = "Fades the TargetFrame when the target is more than *Fadeout Distance* away."
L["TargetFrameFadeOutDistance"] = "Fadeout Distance"
L["TargetFrameFadeOutDistanceDesc"] =
    "Sets the distance in yards to check against for the fadout effect.\nNote: not every value might make a diffence, as it uses 'LibRangeCheck-3.0'.\nCalculated by 'minRange >= fadeOutDistance'."

-- Pet
L["PetFrameDesc"] = "Pet frame settings"
L["PetFrameStyle"] = L["ButtonTableStyle"]
L["PetFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
L["PetFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
L["PetFrameThreatGlow"] = L["TargetFrameThreatGlow"]
L["PetFrameThreatGlowDesc"] = L["TargetFrameThreatGlowDesc"]
L["PetFrameHideStatusbarText"] = "Hide Statusbar Text"
L["PetFrameHideStatusbarTextDesc"] = "Hide the statusbar text"
L["PetFrameHideIndicator"] = "Hide Hit Indicator"
L["PetFrameHideIndicatorDesc"] = "Hide the hit indicator"

-- Focus
L["FocusFrameDesc"] = "Focus frame settings"
L["FocusFrameStyle"] = L["ButtonTableStyle"]
L["FocusFrameClassColor"] = L["PlayerFrameClassColor"]
L["FocusFrameClassColorDesc"] = "Enable class colors for the healthbar"
L["FocusFrameClassIcon"] = L["PlayerFrameClassIcon"]
L["FocusFrameClassIconDesc"] = "Enable class icon as a portrait for the focus frame"
L["FocusFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
L["FocusFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
L["FocusFrameHideNameBackground"] = L["TargetFrameHideNameBackground"]
L["FocusFrameHideNameBackgroundDesc"] = "Hide the name background"

-- party
L["PartyFrameDesc"] = "Party frame settings"
L["PartyFrameStyle"] = L["ButtonTableStyle"]
L["PartyFrameClassColor"] = L["PlayerFrameClassColor"]
L["PartyFrameClassColorDesc"] = "Enable class colors for the healthbar"
L["PartyFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
L["PartyFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]

-- keybindings
local KEY_REPLACEMENTS = {
    ["ALT%-"] = "a",
    ["CTRL%-"] = "c",
    ["SHIFT%-"] = "s",
    ["META%-"] = "c", -- Note: META is also mapped to C like CTRL
    ["NUMPAD"] = "N",
    ["PLUS"] = "+",
    ["MINUS"] = "-",
    ["MULTIPLY"] = "*",
    ["DIVIDE"] = "/",
    ["BACKSPACE"] = "BS",
    ["CAPSLOCK"] = "CP",
    ["CLEAR"] = "CL",
    ["DELETE"] = "Del",
    ["END"] = "En",
    ["HOME"] = "HM",
    ["INSERT"] = "Ins",
    ["MOUSEWHEELDOWN"] = "WD",
    ["MOUSEWHEELUP"] = "WU",
    ["NUMLOCK"] = "NL",
    ["PAGEDOWN"] = "PD",
    ["PAGEUP"] = "PU",
    ["SCROLLLOCK"] = "SL",
    ["SPACEBAR"] = "SP",
    ["SPACE"] = "SP",
    ["TAB"] = "TB",
    ["DOWNARROW"] = "Dn",
    ["LEFTARROW"] = "Lf",
    ["RIGHTARROW"] = "Rt",
    ["UPARROW"] = "Up"
}

local NUM_MOUSE_BUTTONS = 31
for i = 1, NUM_MOUSE_BUTTONS do KEY_REPLACEMENTS["BUTTON" .. i] = "B" .. i end

for k, v in pairs(KEY_REPLACEMENTS) do L_EN[k] = v; end
DF.KEY_REPLACEMENTS = KEY_REPLACEMENTS;

-- see comment above
for k, v in pairs(L) do L_EN[k] = v; end
