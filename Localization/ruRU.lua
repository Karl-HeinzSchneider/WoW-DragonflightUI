-- print('ruRU') - Translator ZamestoTV
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L_RU = LibStub("AceLocale-3.0"):NewLocale("DragonflightUI", "ruRU")

if not L_RU then return end

-- @TODO
-- preprocess to reuse strings - without this L[XY] = L['X'] will fail in AceLocale
local L = {}

-- modules - config.lua
L["ModuleTooltipActionbar"] =
    "Этот аддон изменяет стандартную панель действий, включая кнопки «Микроменю» и «Сумка».\nДобавляет отдельные параметры для панели действий 1-8, Петов-/XP-/Реп.-/Possess-/Позиция-/Тотембар, Сумки и микроменю."
L["ModuleTooltipBossframe"] =
    "Этот модуль добавляет пользовательские фреймы босса.\nРАБОТА В ПРОЦЕССЕ."
L["ModuleTooltipBuffs"] =
    "Этот модуль изменяет фрейм баффов по умолчанию.\nДобавляет отдельные параметры для баффов и дебаффов."
L["ModuleTooltipCastbar"] =
    "Этот модуль изменяет панель кастов по умолчанию.\nДобавляет отдельные параметры для Игрока-, Фокуса- и TargetCastbar."
L["ModuleTooltipChat"] =
    "Этот модуль изменяет окно чата по умолчанию.\nРАБОТА В ПРОЦЕССЕ."
L["ModuleTooltipDarkmode"] =
    "Этот модуль добавляет темный режим к нескольким фреймам DragonflightUI.\nРАБОТА В ПРОЦЕССЕ - пожалуйста, оставьте отзыв!"
L["ModuleTooltipMinimap"] =
    "Этот модуль модернизирует стандартную миникарту и квесттрекер.\nДобавляет отдельные опции для миникарты и квесттрекера."
L["ModuleTooltipUI"] =
    "Этот модуль добавляет современный стиль пользовательского интерфейса в различные окна, такие как окно персонажа. Также добавляет специфичные для Era переделки с новой книгой заклинаний, окном талантов или окном профессии."
L["ModuleTooltipUnitframe"] =
    "Этот модуль перерабатывает стандартные юнитфреймы и добавляет новые функции, такие как цвет класса или здоровье монстра (Era).\nДобавляет отдельные опции для Игрока-, Пета-, Цели-, Фокуса-, и PartyUnitframes."
L["ModuleTooltipUtility"] =
    "Этот модуль добавляет общие функции и настройки пользовательского интерфейса.\nРАБОТА В ПРОЦЕССЕ"

-- profiles
L["ProfilesSetActiveProfile"] = "Установить активный профиль."
L["ProfilesNewProfile"] = "Создать новый профиль."
L["ProfilesCopyFrom"] =
    "Скопируйте настройки из одного существующего профиля в текущий активный профиль."
L["ProfilesOpenCopyDialogue"] = "Открывает диалог копирования."
L["ProfilesDeleteProfile"] = "Удалить существующий профиль из базы данных."
L["Profiles"] = "Add New Profile"

L["ProfilesOpenDeleteDialogue"] = "Открывает диалог удаления."

-- L["ProfilesAddNewProfile"] = "Add New Profile"

L["ProfilesChatNewProfile"] = "новый профиль: "
L["ProfilesErrorNewProfile"] = "ОШИБКА: Имя нового профиля не может быть пустым!"

L["ProfilesDialogueDeleteProfile"] = "Удалить профиль \'%s\'?"
L["ProfilesDialogueCopyProfile"] = "Копировать профиль \'%s\'?"

-- Editmode
-- L["EditModeLayoutDropdown"] = "Profile"
-- L["EditModeCopyLayout"] = "Copy Profile"
-- L["EditModeRenameLayout"] = ""
-- L["EditModeRenameOrCopyLayout"] = "Rename/Copy Profile"
-- L["EditModeDeleteLayout"] = "Delete Profile"
-- L["EditModeNewLayoutDisabled"] = "%s New Profile"
-- L["EditModeNewLayout"] = "%s |cnPURE_GREEN_COLOR:New Profile|r"

-- L["EditModeImportLayout"] = HUD_EDIT_MODE_IMPORT_LAYOUT or "Import"
-- L["EditModeShareLayout"] = HUD_EDIT_MODE_SHARE_LAYOUT or "Share"
-- L["EditModeCopyToClipboard"] = HUD_EDIT_MODE_COPY_TO_CLIPBOARD or "Copy To Clipboard |cffffd100(to share online)|r"

-- L["EditModeExportProfile"] = "Export profile |cff8080ff%s|r"
-- L["EditModeImportProfile"] = "Import profile as |cff8080ff%s|r"

-- __Settings
-- L["SettingsDefaultStringFormat"] = "\n(Default: |cff8080ff%s|r)"

-- positionTable
-- L["PositionTableHeader"] = "Scale and Position"
-- L["PositionTableHeaderDesc"] = ""
-- L["PositionTableScale"] = "Scale"
-- L["PositionTableScaleDesc"] = ""
-- L["PositionTableAnchor"] = "Anchor"
-- L["PositionTableAnchorDesc"] = "Anchor"
-- L["PositionTableAnchorParent"] = "Anchor Parent"
-- L["PositionTableAnchorParentDesc"] = ""
-- L["PositionTableAnchorFrame"] = "Anchor Frame"
-- L["PositionTableAnchorFrameDesc"] = ""
-- L["PositionTableX"] = "X"
-- L["PositionTableXDesc"] = ""
-- L["PositionTableY"] = "Y"
-- L["PositionTableYDesc"] = ""

-- darkmode
-- L["DarkmodeColor"] = "Color"
-- L["DarkmodeDesaturate"] = "Desaturate"

-- actionbar
-- L["ActionbarName"] = "Action Bar"
-- L["ActionbarNameFormat"] = "Action Bar %d"

-- bar names
-- L["XPBar"] = "XP Bar"
-- L["ReputationBar"] = "Reputation Bar"
-- L["PetBar"] = "Pet Bar"
-- L["StanceBar"] = "Stance Bar"
-- L["PossessBar"] = "Possess Bar"
-- L["MicroMenu"] = "Micromenu"
-- L["TotemBar"] = "Totem Bar"

-- gryphonsTable
-- L["Default"] = "Default"
-- L["Alliance"] = "Alliance"
-- L["Horde"] = "Horde"
-- L["None"] = "None"

-- buttonTable
-- L["ButtonTableActive"] = "Active"
-- L["ButtonTableActiveDesc"] = ""

-- L["ButtonTableButtons"] = "Buttons"
-- L["ButtonTableButtonsDesc"] = ""

-- L["ButtonTableButtonScale"] = "Button Scale"
-- L["ButtonTableButtonScaleDesc"] = ""

-- L["ButtonTableOrientation"] = "Orientation"
-- L["ButtonTableOrientationDesc"] = "Orientation"

-- L["ButtonTableReverseButtonOrder"] = "Reverse Button Order"
-- L["ButtonTableReverseButtonOrderDesc"] = ""

-- L["ButtonTableNumRows"] = "Number of Rows"
-- L["ButtonTableNumRowsDesc"] = ""

-- L["ButtonTableNumButtons"] = "Number of Buttons"
-- L["ButtonTableNumButtonsDesc"] = ""

-- L["ButtonTablePadding"] = "Padding"
-- L["ButtonTablePaddingDesc"] = ""

-- L["ButtonTableStyle"] = "Style"
-- L["ButtonTableStyleDesc"] = ""

-- L["ButtonTableAlwaysShowActionbar"] = "Always Show Action Bar"
-- L["ButtonTableAlwaysShowActionbarDesc"] = ""

-- L["ButtonTableHideMacroText"] = "Hide Macro Text"
-- L["ButtonTableHideMacroTextDesc"] = ""

-- L["ButtonTableMacroNameFontSize"] = "Macro Name Font Size"
-- L["ButtonTableMacroNameFontSizeDesc"] = ""

-- L["ButtonTableHideKeybindText"] = "Hide Keybind Text"
-- L["ButtonTableHideKeybindTextDesc"] = ""

-- L["ButtonTableKeybindFontSize"] = "Keybind Font Size"
-- L["ButtonTableKeybindFontSizeDesc"] = ""

-- L["MoreOptionsHideBarArt"] = "Hide Bar Art"
-- L["MoreOptionsHideBarArtDesc"] = ""

-- L["MoreOptionsHideBarScrolling"] = "Hide Bar Scrolling"
-- L["MoreOptionsHideBarScrollingDesc"] = ""

-- L["MoreOptionsGryphons"] = "Gryphons"
-- L["MoreOptionsGryphonsDesc"] = "Gryphons"

-- L["MoreOptionsIconRangeColor"] = "Icon Range Color"
-- L["MoreOptionsIconRangeColorDesc"] = "Changes the Icon color when Out Of Range, similar to RedRange/tullaRange"

-- L["ExtraOptionsPreset"] = "Preset"
-- L["ExtraOptionsResetToDefaultPosition"] = "Reset to Default Position"
-- L["ExtraOptionsPresetDesc"] =
--     "Sets Scale, Anchor, AnchorParent, AnchorFrame, X and Y to that of the chosen preset, but does not change any other setting.";

-- L["ExtraOptionsModernLayout"] = "Modern Layout (default)"
-- L["ExtraOptionsModernLayoutDesc"] = ""

-- L["ExtraOptionsClassicLayout"] = "Classic Layout (sidebar)"
-- L["ExtraOptionsClassicLayoutDesc"] = ""

-- XP
-- L["XPOptionsName"] = "XP"
-- L["XPOptionsDesc"] = "XP"

-- L["XPOptionsStyle"] = L["ButtonTableStyle"]
-- L["XPOptionsStyleDesc"] = ""

-- L["XPOptionsWidth"] = "Width"
-- L["XPOptionsWidthDesc"] = ""

-- L["XPOptionsHeight"] = "Height"
-- L["XPOptionsHeightDesc"] = ""

-- L["XPOptionsAlwaysShowXPText"] = "Always show XP text"
-- L["XPOptionsAlwaysShowXPTextDesc"] = ""

-- L["XPOptionsShowXPPercent"] = "Show XP Percent"
-- L["XPOptionsShowXPPercentDesc"] = ""

-- rep
-- L["RepOptionsName"] = "Rep"
-- L["RepOptionsDesc"] = "Rep"

-- L["RepOptionsStyle"] = L["ButtonTableStyle"]
-- L["RepOptionsStyleDesc"] = ""

-- L["RepOptionsWidth"] = L["XPOptionsWidth"]
-- L["RepOptionsWidthDesc"] = L["XPOptionsWidthDesc"]

-- L["RepOptionsHeight"] = L["XPOptionsHeight"]
-- L["RepOptionsHeightDesc"] = L["XPOptionsHeightDesc"]

-- L["RepOptionsAlwaysShowRepText"] = "Always show Rep text"
-- L["RepOptionsAlwaysShowRepTextDesc"] = ""

-- Bags
-- L["BagsOptionsName"] = "Bags"
-- L["BagsOptionsDesc"] = "Bags"

-- L["BagsOptionsStyle"] = L["ButtonTableStyle"]
-- L["BagsOptionsStyleDesc"] = ""

-- L["BagsOptionsExpanded"] = "Expanded"
-- L["BagsOptionsExpandedDesc"] = ""

-- L["BagsOptionsHideArrow"] = "HideArrow"
-- L["BagsOptionsHideArrowDesc"] = ""

-- L["BagsOptionsHidden"] = "Hidden"
-- L["BagsOptionsHiddenDesc"] = "Backpack hidden"

-- L["BagsOptionsOverrideBagAnchor"] = "Override BagAnchor"
-- L["BagsOptionsOverrideBagAnchorDesc"] = ""

-- L["BagsOptionsOffsetX"] = "BagAnchor OffsetX"
-- L["BagsOptionsOffsetXDesc"] = ""

-- L["BagsOptionsOffsetY"] = "BagAnchor OffsetY"
-- L["BagsOptionsOffsetYDesc"] = ""

-- FPS
-- L["FPSOptionsName"] = "FPS"
-- L["FPSOptionsDesc"] = "FPS"

-- L["FPSOptionsStyle"] = L["ButtonTableStyle"]
-- L["FPSOptionsStyleDesc"] = ""

-- L["FPSOptionsHideDefaultFPS"] = "Hide Default FPS"
-- L["FPSOptionsHideDefaultFPSDesc"] = "Hide Default FPS Text"

-- L["FPSOptionsShowFPS"] = "Show FPS"
-- L["FPSOptionsShowFPSDesc"] = "Show Custom FPS Text"

-- L["FPSOptionsAlwaysShowFPS"] = "Always Show FPS"
-- L["FPSOptionsAlwaysShowFPSDesc"] = "Always Show Custom FPS Text"

-- L["FPSOptionsShowPing"] = "Show Ping"
-- L["FPSOptionsShowPingDesc"] = "Show Ping In MS"

-- Buffs
-- L["BuffsOptionsName"] = "Buffs"
-- L["BuffsOptionsStyle"] = L["ButtonTableStyle"]
-- L["BuffsOptionsStyleDesc"] = ""

-- L["BuffsOptionsExpanded"] = "Expanded"
-- L["BuffsOptionsExpandedDesc"] = ""

-- L["BuffsOptionsUseStateHandler"] = "Use State Handler"
-- L["BuffsOptionsUseStateHandlerDesc"] =
--     "Without this, the visibility settings above won't work, but might improve other addon compatibility (e.g. for MinimapAlert) as it does not make frames secure."

-- Castbar
-- L["CastbarName"] = "Cast Bar"
-- L["CastbarNameFormat"] = "%s Cast Bar"
-- L["CastbarTableActive"] = "Active"
-- L["CastbarTableActivateDesc"] = ""
-- L["CastbarTableStyle"] = L["ButtonTableStyle"]
-- L["CastbarTableStyleDesc"] = ""
-- L["CastbarTableWidth"] = L["XPOptionsWidth"]
-- L["CastbarTableWidthDesc"] = L["XPOptionsWidthDesc"]
-- L["CastbarTableHeight"] = L["XPOptionsHeight"]
-- L["CastbarTableHeightDesc"] = L["XPOptionsHeightDesc"]
-- L["CastbarTablePrecisionTimeLeft"] = "Precision (time left)"
-- L["CastbarTablePrecisionTimeLeftDesc"] = ""
-- L["CastbarTablePrecisionTimeMax"] = "Precision (time max)"
-- L["CastbarTablePrecisionTimeMaxDesc"] = ""
-- L["CastbarTableShowCastTimeText"] = "Show cast time text"
-- L["CastbarTableShowCastTimeTextDesc"] = ""
-- L["CastbarTableShowCastTimeMaxText"] = "Show cast time max text"
-- L["CastbarTableShowCastTimeMaxTextDesc"] = ""
-- L["CastbarTableCompactLayout"] = "Compact Layout"
-- L["CastbarTableCompactLayoutDesc"] = ""
-- L["CastbarTableHoldTimeSuccess"] = "Hold Time (Success)"
-- L["CastbarTableHoldTimeSuccessDesc"] = "Time before the Castbar starts fading after the Cast was successful."
-- L["CastbarTableHoldTimeInterrupt"] = "Hold Time (Interrupt)"
-- L["CastbarTableHoldTimeInterruptDesc"] = "Time before the Castbar starts fading after the Cast was interrupted."
-- L["CastbarTableShowIcon"] = "Show Icon"
-- L["CastbarTableShowIconDesc"] = ""
-- L["CastbarTableIconSize"] = "Icon Size"
-- L["CastbarTableIconSizeDesc"] = ""
-- L["CastbarTableShowTicks"] = "Show Ticks"
-- L["CastbarTableShowTicksDesc"] = ""
-- L["CastbarTableAutoAdjust"] = "Auto Adjust"
-- L["CastbarTableAutoAdjustDesc"] =
--     "This applies an Y-offset depending on the amount of buffs/debuffs - useful when anchoring the castbar beneath the Target/FocusFrame"
-- L["CastbarTableShowRank"] = "Show Rank"
-- L["CastbarTableShowRankDesc"] = ""

-- L["ExtraOptionsResetToDefaultStyle"] = "Reset to Default Style"
-- L["ExtraOptionsPresetStyleDesc"] =
--     "Sets all settings that change the style of the castbar, but does not change any other setting."

-- Minimap
-- L["MinimapName"] = "Minimap"
-- L["MinimapStyle"] = L["ButtonTableStyle"]
-- L["MinimapShowPing"] = "Show Ping"
-- L["MinimapNotYetImplemented"] = "(NOT YET IMPLEMENTED)"
-- L["MinimapShowPingInChat"] = "Show Ping in Chat"
-- L["MinimapHideCalendar"] = "Hide Calendar"
-- L["MinimapHideCalendarDesc"] = "Hides the calendar button"
-- L["MinimapHideZoomButtons"] = "Hide Zoom Buttons"
-- L["MinimapHideZoomDesc"] = "Hides the zoom buttons (+) (-)"
-- L["MinimapSkinMinimapButtons"] = "Skin Minimap Buttons"
-- L["MinimapSkinMinimapButtonsDesc"] = "Changes the Style of Minimap Buttons using LibDBIcon (most addons use this)"
-- L["MinimapUseStateHandler"] = "Use State Handler"
-- L["MinimapUseStateHandlerDesc"] =
--     "Without this, the visibility settings above won't work, but might improve other addon compatibility (e.g. for MinimapAlert) as it does not make frames secure."

-- UI
-- L["UIUtility"] = "Utility"
-- L["UIChangeBags"] = "Change Bags"
-- L["UIChangeBagsDesc"] = ""
-- L["UIColoredInventoryItems"] = "Colored Inventory Items"
-- L["UIColoredInventoryItemsDesc"] = "Toggle to color inventory items based on their quality."
-- L["UIShowQuestlevel"] = "Show Questlevel"
-- L["UIShowQuestlevelDesc"] = "Display the quest level next to the quest name."
-- L["UIFrames"] = "Frames"
-- L["UIFramesDesc"] = "Options for modifying various in-game frames."
-- L["UIChangeCharacterFrame"] = "Change CharacterFrame"
-- L["UIChangeCharacterFrameDesc"] = "Change the appearance of the  character frame."
-- L["UIChangeProfessionWindow"] = "Change Profession Window"
-- L["UIChangeProfessionWindowDesc"] = "Modify the appearance of the profession window."
-- L["UIChangeInspectFrame"] = "Change InspectFrame"
-- L["UIChangeInspectFrameDesc"] = "Change the appearance of the inspect frame."
-- L["UIChangeTrainerWindow"] = "Change Trainer Window"
-- L["UIChangeTrainerWindowDesc"] = "Change the appearance of the trainer window."
-- L["UIChangeTalentFrame"] = "Change TalentFrame"
-- L["UIChangeTalentFrameDesc"] = "Change the layout or appearance of the Talent Frame. (Not available on Wrath)"
-- L["UIChangeSpellBook"] = "Change SpellBook"
-- L["UIChangeSpellBookDesc"] = "Change the appearance of the SpellBook."
-- L["UIChangeSpellBookProfessions"] = "Change SpellBook Professions"
-- L["UIChangeSpellBookProfessionsDesc"] = "Modify the SpellBook layout for professions."

-- ProfessionFrame
-- L["ProfessionFrameHasSkillUp"] = "Has skill up"
-- L["ProfessionFrameHasMaterials"] = CRAFT_IS_MAKEABLE
-- L["ProfessionFrameSubclass"] = "Subclass"
-- L["ProfessionFrameSlot"] = "Slot"
-- L["ProfessionCheckAll"] = "Check All"
-- L["ProfessionUnCheckAll"] = "Uncheck All"
-- L["ProfessionFavorites"] = "Favorites"

-- Unitframes
-- L["UnitFramesName"] = "Unitframes"
-- Player
-- L["PlayerFrameDesc"] = "Player frame settings"
-- L["PlayerFrameStyle"] = L["ButtonTableStyle"]
-- L["PlayerFrameClassColor"] = "Class Color"
-- L["PlayerFrameClassColorDesc"] = "Enable class colors for the health bar"
-- L["PlayerFrameClassIcon"] = "Class Icon Portrait"
-- L["PlayerFrameClassIconDesc"] = "Enable class icon as portrait (currently disabled)"
-- L["PlayerFrameBreakUpLargeNumbers"] = "Break Up Large Numbers"
-- L["PlayerFrameBreakUpLargeNumbersDesc"] =
--     "Enable breaking up large numbers in the StatusText (e.g., 7588 K instead of 7588000)"
-- L["PlayerFrameBiggerHealthbar"] = "Bigger Healthbar"
-- L["PlayerFrameBiggerHealthbarDesc"] = "Enable a bigger health bar"
-- L["PlayerFrameHideRedStatus"] = "Hide In Combat Red Statusglow"
-- L["PlayerFrameHideRedStatusDesc"] = "Hide the red status glow in combat"
-- L["PlayerFrameHideHitIndicator"] = "Hide Hit Indicator"
-- L["PlayerFrameHideHitIndicatorDesc"] = "Hide the hit indicator on the player frame"
-- L["PlayerFrameHideSecondaryRes"] = "Hide Secondary Ressource"
-- L["PlayerFrameHideSecondaryResDesc"] = "Hide the secondary ressource, e.g. soul shards."

-- Target
-- L["TargetFrameDesc"] = "Target frame settings"
-- L["TargetFrameStyle"] = L["ButtonTableStyle"]
-- L["TargetFrameClassColor"] = L["PlayerFrameClassColor"]
-- L["TargetFrameClassColorDesc"] = "Enable class colors for the health bar"
-- L["TargetFrameClassIcon"] = L["PlayerFrameClassIcon"]
-- L["TargetFrameClassIconDesc"] = L["PlayerFrameClassIconDesc"]
-- L["TargetFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
-- L["TargetFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
-- L["TargetFrameNumericThreat"] = "Numeric Threat"
-- L["TargetFrameNumericThreatDesc"] = "Enable numeric threat display"
-- L["TargetFrameNumericThreatAnchor"] = "Numeric Threat Anchor"
-- L["TargetFrameNumericThreatAnchorDesc"] = "Sets the numeric threat anchor(position)"
-- L["TargetFrameThreatGlow"] = "Threat Glow"
-- L["TargetFrameThreatGlowDesc"] = "Enable threat glow effect"
-- L["TargetFrameHideNameBackground"] = "Hide Name Background"
-- L["TargetFrameHideNameBackgroundDesc"] = "Hide the background of the target's name"
-- L["TargetFrameComboPointsOnPlayerFrame"] = "Combo Points on PlayerFrame"
-- L["TargetFrameComboPointsOnPlayerFrameDesc"] = "Show combo points on the player frame."
-- L["TargetFrameHideComboPoints"] = "Hide Combo Points"
-- L["TargetFrameHideComboPointsDesc"] = "Hides the combo points frame."
-- L["TargetFrameFadeOut"] = "Fadeout"
-- L["TargetFrameFadeOutDesc"] = "Fades the TargetFrame when the target is more than 40y away."

-- Pet
-- L["PetFrameDesc"] = "Pet frame settings"
-- L["PetFrameStyle"] = L["ButtonTableStyle"]
-- L["PetFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
-- L["PetFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
-- L["PetFrameThreatGlow"] = L["TargetFrameThreatGlow"]
-- L["PetFrameThreatGlowDesc"] = L["TargetFrameThreatGlowDesc"]
-- L["PetFrameHideStatusbarText"] = "Hide Statusbar Text"
-- L["PetFrameHideStatusbarTextDesc"] = "Hide the statusbar text"
-- L["PetFrameHideIndicator"] = "Hide Hit Indicator"
-- L["PetFrameHideIndicatorDesc"] = "Hide the hit indicator"

-- Focus
-- L["FocusFrameDesc"] = "Focus frame settings"
-- L["FocusFrameStyle"] = L["ButtonTableStyle"]
-- L["FocusFrameClassColor"] = L["PlayerFrameClassColor"]
-- L["FocusFrameClassColorDesc"] = "Enable class colors for the healthbar"
-- L["FocusFrameClassIcon"] = L["PlayerFrameClassIcon"]
-- L["FocusFrameClassIconDesc"] = "Enable class icon as a portrait for the focus frame"
-- L["FocusFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
-- L["FocusFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
-- L["FocusFrameHideNameBackground"] = L["TargetFrameHideNameBackground"]
-- L["FocusFrameHideNameBackgroundDesc"] = "Hide the name background"

-- party
-- L["PartyFrameDesc"] = "Party frame settings"
-- L["PartyFrameStyle"] = L["ButtonTableStyle"]
-- L["PartyFrameClassColor"] = L["PlayerFrameClassColor"]
-- L["PartyFrameClassColorDesc"] = "Enable class colors for the healthbar"
-- L["PartyFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
-- L["PartyFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]

-- see comment above
for k, v in pairs(L) do L_RU[k] = v; end
