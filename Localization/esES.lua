-- print('esES, esMX')
-- Spanish Translations by Woopy
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = {}

-- modules - config.lua
do
    L["ModuleModules"] = "Módulos"

    L["ModuleTooltipActionbar"] =
        "Este módulo mejora la barra de acción predeterminada, incluyendo el micromenú y los botones de bolsas.\nAñade opciones separadas para las barras de acción 1-8, barra de mascotas, EXP, reputación, posesión, actitud, tótems, bolsas y micromenú."
    L["ModuleTooltipBossframe"] = "Este módulo añade marcos personalizados para los jefes.\nEN DESARROLLO."
    L["ModuleTooltipBuffs"] =
        "Este módulo modifica el marco de beneficios predeterminado.\nAñade opciones separadas para Beneficios y Perjuicios."
    L["ModuleTooltipCastbar"] =
        "Este módulo modifica la barra de lanzamiento predeterminada.\nAñade opciones separadas para la barra de lanzamiento del Jugador, Enfoque y Objetivo."
    L["ModuleTooltipChat"] = "Este módulo modifica la ventana de chat predeterminada.\nEN DESARROLLO."
    -- L["ModuleTooltipCompatibility"] = "This module adds extra compatibility for other addons."
    L["ModuleTooltipDarkmode"] =
        "Este módulo añade un modo oscuro a múltiples marcos de la interfaz de Dragonflight.\nEN DESARROLLO - ¡por favor, envía tus comentarios!"
    -- L["ModuleTooltipFlyout"] = "Flyout"
    L["ModuleTooltipMinimap"] =
        "Este módulo mejora el minimapa y el rastreador de misiones.\nAñade opciones separadas para el minimapa y el rastreador de misiones."
    -- L["ModuleTooltipTooltip"] = "This module enhances GameTooltips.\nWORK IN PROGRESS"
    L["ModuleTooltipUI"] =
        "Este módulo añade un estilo moderno a diferentes ventanas como el marco de personaje. También añade rediseños específicos de la Era con el nuevo libro de hechizos, el marco de talentos y la ventana de profesiones."
    L["ModuleTooltipUnitframe"] =
        "Este módulo mejora los marcos de unidad predeterminados y añade nuevas funciones como el color de clase o la salud de los enemigos (Era).\nAñade opciones separadas para los marcos de jugador, mascota, objetivo, enfoque y grupo."
    L["ModuleTooltipUtility"] = "Este módulo añade funciones y ajustes generales a la interfaz.\nEN DESARROLLO."

    -- L["ModuleFlyout"] = "Flyout"
    L["ModuleActionbar"] = "Barra de acción"
    L["ModuleCastbar"] = "Barra de lanzamiento"
    L["ModuleChat"] = "Chat"
    L["ModuleBuffs"] = "Beneficios"
    L["ModuleDarkmode"] = "Modo oscuro"
    L["ModuleMinimap"] = "Minimapa"
    -- L["ModuleTooltip"] = "Tooltip"
    -- L["ModuleUI"] = "UI"
    L["ModuleUnitframe"] = "Marcos de unidad"
    L["ModuleUtility"] = "Utilidad"
    -- L["ModuleCompatibility"] = "Compatibility"
    L["ModuleBossframe"] = "Marcos de jefe"
end

-- config 
do
    L["ConfigGeneralWhatsNew"] = "Novedades"
    L["ConfigGeneralModules"] = "Módulos"
    L["ConfigGeneralInfo"] = "Información"
    L["MainMenuDragonflightUI"] = "DragonflightUI"
    L["MainMenuEditmode"] = "Modo edición"

    -- config.mixin.lua
    L["ConfigMixinQuickKeybindMode"] = "Modo rápido de asignación de teclas"
    L["ConfigMixinGeneral"] = "General"
    L["ConfigMixinModules"] = "Módulos"
    L["ConfigMixinActionBar"] = "Barra de acción"
    L["ConfigMixinCastBar"] = "Barra de lanzamiento"
    L["ConfigMixinMisc"] = "Varios"
    L["ConfigMixinUnitframes"] = "Marcos de unidad"

    -- modules.mixin.lua
    -- L["ModuleConditionalMessage"] = "'|cff8080ff%s|r' was deactivated, but the corresponding function was already hooked, please '|cff8080ff/reload|r'!"

    -- config
    L["ConfigToolbarCopyPopup"] = "Copia el enlace de abajo (Ctrl+C, Enter):"
    L["ConfigToolbarDiscord"] = "Discord"
    L["ConfigToolbarDiscordTooltip"] = "Contribuye con ideas y obtén soporte."
    L["ConfigToolbarGithub"] = "Github"
    L["ConfigToolbarGithubTooltip"] = "Ver código, reportar problemas y contribuir."
    L["ConfigToolbarCoffee"] = "BuyMeACoffee"
    L["ConfigToolbarCoffeeTooltip1"] =
        "¡Cada comentario, like o compartir cuenta, pero si te sientes muy generoso, puedes comprarme una porción de pizza para alimentar el desarrollo futuro!"
    L["ConfigToolbarCoffeeTooltip2"] =
        "Los patrocinadores disfrutan de beneficios exclusivos, descúbrelos en la sección de patrocinadores de nuestro Discord."
end

-- profiles
do
    L["ProfilesSetActiveProfile"] = "Establecer perfil activo."
    L["ProfilesNewProfile"] = "Crear un nuevo perfil."
    L["ProfilesCopyFrom"] = "Copiar la configuración de un perfil existente en el perfil activo."
    L["ProfilesOpenCopyDialogue"] = "Abrir diálogo de copia."
    L["ProfilesDeleteProfile"] = "Eliminar un perfil existente de la base de datos."
    L["Profiles"] = "Añadir nuevo perfil"
    L["ProfilesOpenDeleteDialogue"] = "Abrir diálogo de eliminación."
    L["ProfilesAddNewProfile"] = "Añadir nuevo perfil"
    L["ProfilesChatNewProfile"] = "nuevo perfil: "
    L["ProfilesErrorNewProfile"] = "ERROR: ¡El nombre del nuevo perfil no puede estar vacío!"
    L["ProfilesDialogueDeleteProfile"] = "¿Eliminar el perfil \'%s\'?"
    L["ProfilesDialogueCopyProfile"] = "Añadir nuevo perfil (copiar de \'|cff8080ff%s|r\')"
    -- L["ProfilesImportShareHeader"] = "Import/Share"
    -- L["ProfilesImportProfile"] = "Import Profile"
    -- L["ProfilesImportProfileButton"] = HUD_EDIT_MODE_IMPORT_LAYOUT or "Import"
    -- L["ProfilesImportProfileDesc"] = "Opens the import dialogue."
    -- L["ProfilesExportProfile"] = "Share Profile"
    -- L["ProfilesExportProfileButton"] = HUD_EDIT_MODE_SHARE_LAYOUT or "Share"
    -- L["ProfilesExportProfileDesc"] = "Opens the share dialogue."
end

-- Editmode
do
    L["EditModeBasicOptions"] = "Opciones básicas"
    L["EditModeAdvancedOptions"] = "Opciones avanzadas"
    L["EditModeLayoutDropdown"] = "Perfil"
    L["EditModeCopyLayout"] = "Copiar perfil"
    L["EditModeRenameLayout"] = ""
    L["EditModeRenameOrCopyLayout"] = "Renombrar/copiar perfil"
    L["EditModeDeleteLayout"] = "Eliminar perfil"
    L["EditModeNewLayoutDisabled"] = "%s Nuevo perfil"
    L["EditModeNewLayout"] = "%s |cnPURE_GREEN_COLOR:Nuevo perfil|r"
    -- L["EditModeImportLayout"] = HUD_EDIT_MODE_IMPORT_LAYOUT or "Import"
    -- L["EditModeShareLayout"] = HUD_EDIT_MODE_SHARE_LAYOUT or "Share"
    L["EditModeCopyToClipboard"] = "Copiar al portapapeles |cffffd100(para compartir en línea)|r"
    L["EditModeExportProfile"] = "Exportar perfil |cff8080ff%s|r"
    L["EditModeImportProfile"] = "Importar perfil como |cff8080ff%s|r"
end

-- Compat
do
    -- L['CompatName'] = "Compatibility"
    -- L['CompatAuctionator'] = "Auctionator"
    -- L['CompatAuctionatorDesc'] = "Adds compatibility for Auctionator when using the UI Module with 'Change Profession Window' enabled."
    -- L['CompatBaganator'] = "Baganator_Skin"
    -- L['CompatBaganatorDesc'] = "Changes the default 'Blizzard' skin to a DragonflightUI styled one."
    -- L['CompatBaganatorEquipment'] = "Baganator_EquipmentSets"
    -- L['CompatBaganatorEquipmentDesc'] = "Adds support for equipment sets as item source."
    -- L['CompatCharacterStatsClassic'] = "CharacterStatsClassic"
    -- L['CompatCharacterStatsClassicDesc'] = "Adds compatibility for CharacterStatsClassic when using the UI Module with 'Change CharacterFrame' enabled."
    -- L['CompatClassicCalendar'] = "Classic Calendar"
    -- L['CompatClassicCalendarDesc'] = "Adds compatibility for Classic Calendar"
    -- L['CompatLFGBulletinBoard'] = "LFG Bulletin Board"
    -- L['CompatLFGBulletinBoardDesc'] = "Adds compatibility for LFG Bulletin Board"
    -- L['CompatMerInspect'] = "MerInspect"
    -- L['CompatMerInspectDesc'] = "Adds compatibility for MerInspect when using the UI Module with 'Change CharacterFrame' enabled."
    -- L['CompatRanker'] = "Ranker"
    -- L['CompatRankerDesc'] = "Adds compatibility for Ranker when using the UI Module with 'Change CharacterFrame' enabled."
    -- L['CompatTacoTip'] = "TacoTip"
    -- L['CompatTacoTipDesc'] = "Adds compatibility for TacoTip when using the UI Module with 'Change CharacterFrame' enabled."
    -- L['CompatTDInspect'] = "TDInspect"
    -- L['CompatTDInspectDesc'] = "Adds compatibility for TDInspect when using the UI Module with 'Change CharacterFrame' enabled."
    -- L['CompatWhatsTraining'] = "WhatsTraining"
    -- L['CompatWhatsTrainingDesc'] = "Adds compatibility for WhatsTraining when using the UI Module with 'Change SpellBook' enabled."
end

-- __Settings
do
    L["SettingsDefaultStringFormat"] = "\n(Predeterminado: |cff8080ff%s|r)"
    -- L["SettingsCharacterSpecific"] = "\n\n|cff8080ff[Per-character setting]|r"

    -- positionTable
    L["PositionTableHeader"] = "Escala y posición"
    L["PositionTableHeaderDesc"] = ""
    L["PositionTableScale"] = "Escala"
    L["PositionTableScaleDesc"] = ""
    L["PositionTableAnchor"] = "Ancla"
    L["PositionTableAnchorDesc"] = "Ancla"
    L["PositionTableAnchorParent"] = "Padre del ancla"
    L["PositionTableAnchorParentDesc"] = ""
    L["PositionTableAnchorFrame"] = "Marco del ancla"
    L["PositionTableAnchorFrameDesc"] = ""
    -- L["PositionTableCustomAnchorFrame"] = "Anchor Frame (custom)"
    -- L["PositionTableCustomAnchorFrameDesc"] = "Use this named frame as anchor frame (if it's valid). E.g. 'CharacterFrame', 'TargetFrame'..."
    L["PositionTableX"] = "X"
    L["PositionTableXDesc"] = ""
    L["PositionTableY"] = "Y"
    L["PositionTableYDesc"] = ""
end

-- darkmode
do
    L["DarkmodeColor"] = "Color"
    L["DarkmodeDesaturate"] = "Desaturar"
end

-- actionbar
do
    -- L["ActionbarName"] = "Action Bar"
    L["ActionbarNameFormat"] = "Barra de acción %d"

    -- bar names
    L["XPBar"] = "Barra de EXP"
    L["ReputationBar"] = "Barra de reputación"
    L["PetBar"] = "Barra de mascota"
    L["StanceBar"] = "Barra de actitud"
    L["PossessBar"] = "Barra de posesión"
    L["MicroMenu"] = "Micromenú"
    L["TotemBar"] = "Barra de tótems"

    -- gryphonsTable
    L["Default"] = "Predeterminado"
    L["Alliance"] = "Alianza"
    L["Horde"] = "Horda"
    L["None"] = "Ninguno"

    -- buttonTable
    L["ButtonTableActive"] = "Activo"
    L["ButtonTableActiveDesc"] = ""
    L["ButtonTableButtons"] = "Botones"
    L["ButtonTableButtonsDesc"] = ""
    L["ButtonTableButtonScale"] = "Escala del botón"
    L["ButtonTableButtonScaleDesc"] = ""
    L["ButtonTableOrientation"] = "Orientación"
    L["ButtonTableOrientationDesc"] = "Orientación"
    L["ButtonTableReverseButtonOrder"] = "Invertir orden de botones"
    L["ButtonTableReverseButtonOrderDesc"] = ""
    L["ButtonTableNumRows"] = "Número de filas"
    L["ButtonTableNumRowsDesc"] = ""
    L["ButtonTableNumButtons"] = "Número de botones"
    L["ButtonTableNumButtonsDesc"] = ""
    L["ButtonTablePadding"] = "Relleno"
    L["ButtonTablePaddingDesc"] = ""
    L["ButtonTableStyle"] = "Estilo"
    L["ButtonTableStyleDesc"] = ""
    L["ButtonTableAlwaysShowActionbar"] = "Mostrar siempre la barra de acción"
    L["ButtonTableAlwaysShowActionbarDesc"] = ""
    L["ButtonTableHideMacroText"] = "Ocultar texto de macro"
    L["ButtonTableHideMacroTextDesc"] = ""
    L["ButtonTableMacroNameFontSize"] = "Tamaño de fuente del nombre de macro"
    L["ButtonTableMacroNameFontSizeDesc"] = ""
    L["ButtonTableHideKeybindText"] = "Ocultar texto de asignación de teclas"
    L["ButtonTableHideKeybindTextDesc"] = ""
    L["ButtonTableKeybindFontSize"] = "Tamaño de fuente de asignación de teclas"
    L["ButtonTableKeybindFontSizeDesc"] = ""
    L["MoreOptionsHideBarArt"] = "Ocultar arte de la barra"
    L["MoreOptionsHideBarArtDesc"] = ""
    L["MoreOptionsHideBarScrolling"] = "Ocultar desplazamiento de barra"
    L["MoreOptionsHideBarScrollingDesc"] = ""
    L["MoreOptionsGryphons"] = "Grifos"
    L["MoreOptionsGryphonsDesc"] = "Grifos"
    L["MoreOptionsIconRangeColor"] = "Color del icono por alcance"
    L["MoreOptionsIconRangeColorDesc"] =
        "Cambia el color del icono cuando esté fuera de alcance, similar a RedRange/tullaRange"
    L["ExtraOptionsPreset"] = "Preajuste"
    L["ExtraOptionsResetToDefaultPosition"] = "Restablecer a la posición predeterminada"
    L["ExtraOptionsPresetDesc"] =
        "Establece la escala, anclaje, anchorparent, anchorframe, X y Y al preajuste elegido, pero no cambia ninguna otra configuración."
    L["ExtraOptionsModernLayout"] = "Diseño moderno (predeterminado)"
    L["ExtraOptionsModernLayoutDesc"] = ""
    L["ExtraOptionsClassicLayout"] = "Diseño clásico (barra lateral)"
    L["ExtraOptionsClassicLayoutDesc"] = ""

    -- XP
    L["XPOptionsName"] = "EXP"
    L["XPOptionsDesc"] = "EXP"
    L["XPOptionsStyle"] = L["ButtonTableStyle"]
    L["XPOptionsStyleDesc"] = ""
    L["XPOptionsWidth"] = "Anchura"
    L["XPOptionsWidthDesc"] = ""
    L["XPOptionsHeight"] = "Altura"
    L["XPOptionsHeightDesc"] = ""
    L["XPOptionsAlwaysShowXPText"] = "Mostrar siempre el texto de EXP"
    L["XPOptionsAlwaysShowXPTextDesc"] = ""
    L["XPOptionsShowXPPercent"] = "Mostrar porcentaje de EXP"
    L["XPOptionsShowXPPercentDesc"] = ""

    -- Reputación
    L["RepOptionsName"] = "Reputación"
    L["RepOptionsDesc"] = "Reputación"
    L["RepOptionsStyle"] = L["ButtonTableStyle"]
    L["RepOptionsStyleDesc"] = ""
    L["RepOptionsWidth"] = L["XPOptionsWidth"]
    L["RepOptionsWidthDesc"] = L["XPOptionsWidthDesc"]
    L["RepOptionsHeight"] = L["XPOptionsHeight"]
    L["RepOptionsHeightDesc"] = L["XPOptionsHeightDesc"]
    L["RepOptionsAlwaysShowRepText"] = "Siempre mostrar el texto de reputación"
    L["RepOptionsAlwaysShowRepTextDesc"] = ""

    -- Bags
    L["BagsOptionsName"] = "Bolsas"
    L["BagsOptionsDesc"] = "Bolsas"
    L["BagsOptionsStyle"] = L["ButtonTableStyle"]
    L["BagsOptionsStyleDesc"] = ""
    L["BagsOptionsExpanded"] = "Expandido"
    L["BagsOptionsExpandedDesc"] = ""
    L["BagsOptionsHideArrow"] = "Ocultar flecha"
    L["BagsOptionsHideArrowDesc"] = ""
    L["BagsOptionsHidden"] = "Oculto"
    L["BagsOptionsHiddenDesc"] = "Mochila oculta"
    L["BagsOptionsOverrideBagAnchor"] = "Sobrescribir BagAnchor"
    L["BagsOptionsOverrideBagAnchorDesc"] = ""
    L["BagsOptionsOffsetX"] = "Desplazamiento X de BagAnchor"
    L["BagsOptionsOffsetXDesc"] = ""
    L["BagsOptionsOffsetY"] = "Desplazamiento Y de BagAnchor"
    L["BagsOptionsOffsetYDesc"] = ""

    -- FPS
    L["FPSOptionsName"] = "FPS"
    L["FPSOptionsDesc"] = "FPS"
    L["FPSOptionsStyle"] = L["ButtonTableStyle"]
    L["FPSOptionsStyleDesc"] = ""
    L["FPSOptionsHideDefaultFPS"] = "Ocultar FPS predeterminado"
    L["FPSOptionsHideDefaultFPSDesc"] = "Oculta el texto de FPS predeterminado"
    L["FPSOptionsShowFPS"] = "Mostrar FPS"
    L["FPSOptionsShowFPSDesc"] = "Muestra el texto de FPS personalizado"
    L["FPSOptionsAlwaysShowFPS"] = "Mostrar FPS siempre"
    L["FPSOptionsAlwaysShowFPSDesc"] = "Muestra siempre el texto de FPS personalizado"
    L["FPSOptionsShowPing"] = "Mostrar latencia"
    L["FPSOptionsShowPingDesc"] = "Muestra la latencia en ms"

    -- Extra Action Button
    -- L["ExtraActionButtonOptionsName"] = "Extra Action Button"
    -- L["ExtraActionButtonOptionsNameDesc"] = "FPS"
    -- L["ExtraActionButtonStyle"] = L["ButtonTableStyle"]
    -- L["ExtraActionButtonStyleDesc"] = ""
    -- L["ExtraActionButtonHideBackgroundTexture"] = "Hide Background Texture"
    -- L["ExtraActionButtonHideBackgroundTextureDesc"] = ""
end

-- Buffs
do
    L["BuffsOptionsName"] = "Beneficios"
    L["BuffsOptionsStyle"] = L["ButtonTableStyle"]
    L["BuffsOptionsStyleDesc"] = ""

    L["BuffsOptionsExpanded"] = "Expandido"
    L["BuffsOptionsExpandedDesc"] = ""

    L["BuffsOptionsUseStateHandler"] = "Usar manejador de estado"
    L["BuffsOptionsUseStateHandlerDesc"] =
        "Sin esto, la configuración de visibilidad anterior no funcionará, pero podría mejorar la compatibilidad con otros complementos (por ejemplo, MinimapAlert), ya que no hace que los marcos sean seguros."
end

-- Flyout
do
    -- L["FlyoutHeader"] = "Flyout"
    -- L["FlyoutHeaderDesc"] = ""
    -- L["FlyoutDirection"] = "Flyout Direction"
    -- L["FlyoutDirectionDesc"] = "Flyout Direction"
    -- L["FlyoutSpells"] = "Spells"
    -- L["FlyoutSpellsDesc"] = "Insert SpellIDs as comma seperated values, e.g. '688, 697'."
    -- L["FlyoutSpellsAlliance"] = "Spells (Alliance)"
    -- L["FlyoutSpellsAllianceDesc"] = L["FlyoutSpellsDesc"] .. "\n(Only used on alliance side.)"
    -- L["FlyoutSpellsHorde"] = "Spells (Horde)"
    -- L["FlyoutSpellsHordeDesc"] = L["FlyoutSpellsDesc"] .. "\n(Only used on horde side.)"
    -- L["FlyoutItems"] = "Items"
    -- L["FlyoutItemsDesc"] = "Insert ItemIDs as comma seperated values, e.g. '6948, 8490'."
    -- L["FlyoutCloseAfterClick"] = "Close After Click"
    -- L["FlyoutCloseAfterClickDesc"] = "Close the flyout after pressing one of its buttons."
    -- L["FlyoutAlwaysShow"] = "Always Show Buttons"
    -- L["FlyoutAlwaysShowDesc"] = "Always shows the (sub) buttons, even when they are empty.\nUse this if you want to use drag&drop."
    -- L["FlyoutIcon"] = "Icon"
    -- L["FlyoutIconDesc"] = "Insert FileID or the file path to a texture."
    -- L["FlyoutDisplayname"] = "Display Name"
    -- L["FlyoutDisplaynameDesc"] = ""
    -- L["FlyoutTooltip"] = "Tooltip"
    -- L["FlyoutTooltipDesc"] = ""

    -- L["FlyoutButtonWarlock"] = "Warlock Summon Flyout"
    -- L["FlyoutButtonMagePort"] = "Teleport Flyout"
    -- L["FlyoutButtonMagePortals"] = "Portals Flyout"
    -- L["FlyoutButtonMageFood"] = "Conjure Food Flyout"
    -- L["FlyoutButtonMageWater"] = "Conjure Water Flyout"
    -- L["FlyoutWarlock"] = "Summon Demon"
    -- L["FlyoutWarlockDesc"] = "Summons one of your demons to you."
    -- L["FlyoutMagePort"] = "Teleport"
    -- L["FlyoutMagePortDesc"] = "Teleports you to a major city."
    -- L["FlyoutMagePortals"] = "Portal"
    -- L["FlyoutMagePortalsDesc"] = "Creates a portal, teleporting group members who use it to a major city."
    -- L["FlyoutMageWater"] = "Conjure Water"
    -- L["FlyoutMageWaterDesc"] = "Conjured items disappear if logged out for more than 15 minutes."
    -- L["FlyoutMageFood"] = "Conjure Food"
    -- L["FlyoutMageFoodDesc"] = L["FlyoutMageWaterDesc"]

    -- L["FlyoutButtonCustomFormat"] = "Custom Flyout %d"
    -- L["FlyoutCustomNameFormat"] = "Custom Flyout %d"
    -- L["FlyoutCustomNameDescFormat"] = "Per-character flyout button with up to 12 additional actionbuttons."
end

-- Castbar
do
    -- L["CastbarName"] = "Cast Bar"
    L["CastbarNameFormat"] = "Barra de lanzamiento %s"
    L["CastbarTableActive"] = "Activo"
    L["CastbarTableActivateDesc"] = ""
    L["CastbarTableStyle"] = L["ButtonTableStyle"]
    L["CastbarTableStyleDesc"] = ""
    L["CastbarTableWidth"] = L["XPOptionsWidth"]
    L["CastbarTableWidthDesc"] = L["XPOptionsWidthDesc"]
    L["CastbarTableHeight"] = L["XPOptionsHeight"]
    L["CastbarTableHeightDesc"] = L["XPOptionsHeightDesc"]
    L["CastbarTablePrecisionTimeLeft"] = "Precisión (tiempo restante)"
    L["CastbarTablePrecisionTimeLeftDesc"] = ""
    L["CastbarTablePrecisionTimeMax"] = "Precisión (tiempo máximo)"
    L["CastbarTablePrecisionTimeMaxDesc"] = ""
    L["CastbarTableShowCastTimeText"] = "Mostrar texto de tiempo de lanzamiento"
    L["CastbarTableShowCastTimeTextDesc"] = ""
    L["CastbarTableShowCastTimeMaxText"] = "Mostrar texto de tiempo máximo de lanzamiento"
    L["CastbarTableShowCastTimeMaxTextDesc"] = ""
    L["CastbarTableCompactLayout"] = "Diseño compacto"
    L["CastbarTableCompactLayoutDesc"] = ""
    L["CastbarTableHoldTimeSuccess"] = "Tiempo de retención (éxito)"
    L["CastbarTableHoldTimeSuccessDesc"] =
        "Tiempo antes de que la barra de lanzamiento comience a desvanecerse tras un lanzamiento exitoso."
    L["CastbarTableHoldTimeInterrupt"] = "Tiempo de retención (interrupción)"
    L["CastbarTableHoldTimeInterruptDesc"] =
        "Tiempo antes de que la barra de lanzamiento comience a desvanecerse tras una interrupción."
    L["CastbarTableShowIcon"] = "Mostrar icono"
    L["CastbarTableShowIconDesc"] = ""
    L["CastbarTableIconSize"] = "Tamaño del icono"
    L["CastbarTableIconSizeDesc"] = ""
    L["CastbarTableShowTicks"] = "Mostrar tics"
    L["CastbarTableShowTicksDesc"] = ""
    L["CastbarTableAutoAdjust"] = "Ajuste automático"
    L["CastbarTableAutoAdjustDesc"] =
        "Aplica un desplazamiento en Y dependiendo de la cantidad de beneficios/afectaciones - útil cuando se ancla la barra de lanzamiento debajo del marco de objetivo/enfoque."
    L["CastbarTableShowRank"] = "Mostrar rango"
    L["CastbarTableShowRankDesc"] = ""
    L["CastbarTableShowChannelName"] = "Mostrar nombre de canal"
    L["CastbarTableShowChannelNameDesc"] =
        "Muestra el nombre del hechizo en lugar del texto de visualización (ej. 'Canalizando')"

    L["ExtraOptionsResetToDefaultStyle"] = "Restablecer al estilo predeterminado"
    L["ExtraOptionsPresetStyleDesc"] =
        "Restablece todas las configuraciones que cambian el estilo de la barra de lanzamiento, pero no modifica ninguna otra configuración."
end

-- Minimap
do
    L["MinimapName"] = "Minimapa"
    L["MinimapStyle"] = L["ButtonTableStyle"]
    L["MinimapShowPing"] = "Mostrar ping"
    L["MinimapNotYetImplemented"] = "(NO IMPLEMENTADO AÚN)"
    L["MinimapShowPingInChat"] = "Mostrar ping en el chat"
    L["MinimapHideCalendar"] = "Ocultar calendario"
    L["MinimapHideCalendarDesc"] = "Oculta el botón del calendario"
    L["MinimapHideZoomButtons"] = "Ocultar botones de zoom"
    L["MinimapHideZoomDesc"] = "Oculta los botones de zoom (+) (-)"
    L["MinimapSkinMinimapButtons"] = "Personalizar botones del minimapa"
    L["MinimapSkinMinimapButtonsDesc"] =
        "Cambia el estilo de los botones del minimapa usando LibDBIcon (la mayoría de los addons lo usan)"
    -- L["MinimapZonePanelPosition"] = "Zone Panel Position"
    -- L["MinimapZonePanelPositionDesc"] =
    -- "Sets the position of the zone text panel including the frames anchored to it (e.g. calendar, tracking, mail, ..)."
    L["MinimapUseStateHandler"] = "Usar controlador de estado"
    L["MinimapUseStateHandlerDesc"] =
        "Sin esto, la configuración de visibilidad anterior no funcionará, pero podría mejorar la compatibilidad con otros addons (por ejemplo, MinimapAlert) ya que no hace que los marcos sean seguros."
end

-- UI
do
    L["UIUtility"] = "Utilidad"
    L["UIChangeBags"] = "Cambiar bolsas"
    L["UIChangeBagsDesc"] = ""
    L["UIColoredInventoryItems"] = "Colorear objetos del inventario"
    L["UIColoredInventoryItemsDesc"] = "Activa para colorear los objetos del inventario según su calidad."
    L["UIShowQuestlevel"] = "Mostrar nivel de misión"
    L["UIShowQuestlevelDesc"] = "Muestra el nivel de la misión junto al nombre de la misión."
    L["UIFrames"] = "Marcos"
    L["UIFramesDesc"] = "Opciones para modificar varios marcos del juego."
    L["UIChangeCharacterFrame"] = "Cambiar marco de personaje"
    L["UIChangeCharacterFrameDesc"] = "Cambia la apariencia del marco de personaje."
    L["UIChangeProfessionWindow"] = "Cambiar ventana de profesiones"
    L["UIChangeProfessionWindowDesc"] = "Modifica la apariencia de la ventana de profesiones."
    L["UIChangeInspectFrame"] = "Cambiar marco de inspección"
    L["UIChangeInspectFrameDesc"] = "Cambia la apariencia del marco de inspección."
    L["UIChangeTrainerWindow"] = "Cambiar ventana de instructor"
    L["UIChangeTrainerWindowDesc"] = "Cambia la apariencia de la ventana del instructor."
    L["UIChangeTalentFrame"] = "Cambiar marco de talentos"
    L["UIChangeTalentFrameDesc"] = "Cambia el diseño o apariencia del marco de talentos. (No disponible en Wrath)"
    L["UIChangeSpellBook"] = "Cambiar libro de hechizos"
    L["UIChangeSpellBookDesc"] = "Cambia la apariencia del libro de hechizos."
    L["UIChangeSpellBookProfessions"] = "Cambiar profesiones en el libro de hechizos"
    L["UIChangeSpellBookProfessionsDesc"] = "Modifica el diseño del libro de hechizos para las profesiones."

    -- ProfessionFrame
    L["ProfessionFrameHasSkillUp"] = "Has subido de habilidad"
    L["ProfessionFrameHasMaterials"] = CRAFT_IS_MAKEABLE
    L["ProfessionFrameSubclass"] = "Subclase"
    L["ProfessionFrameSlot"] = "Ranura"
    L["ProfessionCheckAll"] = "Marcar todo"
    L["ProfessionUnCheckAll"] = "Desmarcar todo"
    L["ProfessionFavorites"] = "Favoritos"
end

-- Tooltip
do
    -- L["TooltipName"] = "Tooltip"
    -- L["TooltipHeaderGameToltip"] = "GameTooltip"
    -- L["TooltipHeaderSpellTooltip"] = "SpellTooltip"
    -- L["TooltipCursorAnchorHeader"] = "Cursor Anchor"
    -- L["TooltipCursorAnchorHeaderDesc"] = ""
    L["TooltipAnchorToMouse"] = "Anclar al cursor"
    L["TooltipAnchorToMouseDesc"] =
        "Ancla algunas herramientas (por ejemplo, UnitTooltip en WorldFrame) al cursor del ratón."
    -- L["TooltipMouseAnchor"] = "Cursor Anchor"
    -- L["TooltipMouseAnchorDesc"] = ""
    -- L["TooltipMouseX"] = "X"
    -- L["TooltipMouseXDesc"] = ""
    -- L["TooltipMouseY"] = "Y"
    -- L["TooltipMouseYDesc"] = ""

    -- spelltooltip
    L["TooltipAnchorSpells"] = "Anclar hechizos"
    L["TooltipAnchorSpellsDesc"] =
        "Ancla el SpellTooltip en las barras de acción al botón en lugar del anclaje predeterminado."
    L["TooltipShowSpellID"] = "Mostrar ID del hechizo"
    L["TooltipShowSpellIDDesc"] = ""
    L["TooltipShowSpellSource"] = "Mostrar fuente del hechizo"
    L["TooltipShowSpellSourceDesc"] = ""
    L["TooltipShowSpellIcon"] = "Mostrar icono del hechizo"
    L["TooltipShowSpellIconDesc"] = ""
    L["TooltipShowIconID"] = "Mostrar ID del icono"
    L["TooltipShowIconIDDesc"] = ""
    L["TooltipShowIcon"] = "Mostrar icono"
    L["TooltipShowIconDesc"] = ""

    -- itemtooltip
    -- L["TooltipHeaderItemTooltip"] = "ItemTooltip"
    -- L["TooltipHeaderItemTooltipDesc"] = ""
    L["TooltipShowItemQuality"] = "Borde de calidad del objeto"
    L["TooltipShowItemQualityDesc"] = ""
    L["TooltipShowItemQualityBackdrop"] = "Fondo de calidad del objeto"
    L["TooltipShowItemQualityBackdropDesc"] = ""
    L["TooltipShowItemStackCount"] = "Mostrar tamaño de pila"
    L["TooltipShowItemStackCountDesc"] = ""
    L["TooltipShowItemID"] = "Mostrar ID del objeto"
    L["TooltipShowItemIDDesc"] = ""

    -- unittooltip
    -- L["TooltipUnitTooltip"] = "UnitTooltip"
    -- L["TooltipUnitTooltipDesc"] = ""
    L["TooltipUnitClassBorder"] = "Borde de clase"
    L["TooltipUnitClassBorderDesc"] = ""
    L["TooltipUnitClassBackdrop"] = "Fondo de clase"
    L["TooltipUnitClassBackdropDesc"] = ""
    L["TooltipUnitReactionBorder"] = "Borde de reacción"
    L["TooltipUnitReactionBorderDesc"] = ""
    L["TooltipUnitReactionBackdrop"] = "Fondo de reacción"
    L["TooltipUnitReactionBackdropDesc"] = ""
    L["TooltipUnitClassName"] = "Nombre de clase"
    L["TooltipUnitClassNameDesc"] = ""
    L["TooltipUnitTitle"] = "Mostrar título"
    L["TooltipUnitTitleDesc"] = ""
    L["TooltipUnitRealm"] = "Mostrar reino"
    L["TooltipUnitRealmDesc"] = ""
    L["TooltipUnitGuild"] = "Mostrar hermandad"
    L["TooltipUnitGuildDesc"] = ""
    L["TooltipUnitGuildRank"] = "Mostrar rango de hermandad"
    L["TooltipUnitGuildRankDesc"] = ""
    L["TooltipUnitGuildRankIndex"] = "Mostrar índice de rango de hermandad"
    L["TooltipUnitGuildRankIndexDesc"] = ""
    L["TooltipUnitGrayOutOnDeath"] = "Aturdir al morir"
    L["TooltipUnitGrayOutOnDeathDesc"] = ""
    -- L["TooltipUnitZone"] = "Show Zone Text"
    -- L["TooltipUnitZoneDesc"] = ""
    -- L["TooltipUnitHealthbar"] = "Show Health Bar"
    -- L["TooltipUnitHealthbarDesc"] = ""
    -- L["TooltipUnitHealthbarText"] = "Show Health Bar Text"
    -- L["TooltipUnitHealthbarTextDesc"] = ""
    -- L["TooltipUnitTarget"] = "Show Target"
    -- L["TooltipUnitTargetDesc"] = "Show unit target"
end

-- Unitframes
do
    -- L["UnitFramesName"] = "Unitframes"

    -- Player
    L["PlayerFrameDesc"] = "Configuración del marco del jugador"
    L["PlayerFrameStyle"] = L["ButtonTableStyle"]
    L["PlayerFrameClassColor"] = "Color de clase"
    L["PlayerFrameClassColorDesc"] = "Activa los colores de clase para la barra de vida"
    L["PlayerFrameClassIcon"] = "Retrato con icono de clase"
    L["PlayerFrameClassIconDesc"] = "Activa el icono de clase como retrato (actualmente desactivado)"
    L["PlayerFrameBreakUpLargeNumbers"] = "Separar números grandes"
    L["PlayerFrameBreakUpLargeNumbersDesc"] =
        "Activa la separación de números grandes en el texto de estado (por ejemplo, 7588 K en lugar de 7588000)"
    L["PlayerFrameBiggerHealthbar"] = "Barra de vida más grande"
    L["PlayerFrameBiggerHealthbarDesc"] = "Activa una barra de vida más grande"
    L["PlayerFramePortraitExtra"] = "Retrato extra"
    L["PlayerFramePortraitExtraDesc"] =
        "Muestra un dragón de élite, raro o jefe de mundo alrededor del marco del jugador."
    L["PlayerFrameHideRedStatus"] = "Ocultar resplandor rojo en combate"
    L["PlayerFrameHideRedStatusDesc"] = "Oculta el resplandor rojo de estado en combate"
    L["PlayerFrameHideHitIndicator"] = "Ocultar indicador de golpe"
    L["PlayerFrameHideHitIndicatorDesc"] = "Oculta el indicador de golpe en el marco del jugador"
    L["PlayerFrameHideSecondaryRes"] = "Ocultar recurso secundario"
    L["PlayerFrameHideSecondaryResDesc"] = "Oculta el recurso secundario, por ejemplo, fragmentos de alma."
    L["PlayerFrameHideAlternatePowerBar"] = "Ocultar barra de poder alternativo de druida"
    L["PlayerFrameHideAlternatePowerBarDesc"] =
        "Oculta la barra de poder alternativo de druida (barra de maná en forma de oso/gato)."

    -- Target
    L["TargetFrameDesc"] = "Configuraciones del marco del objetivo"
    L["TargetFrameStyle"] = L["ButtonTableStyle"]
    L["TargetFrameClassColor"] = L["PlayerFrameClassColor"]
    L["TargetFrameClassColorDesc"] = "Activar colores de clase para la barra de vida"
    L["TargetFrameClassIcon"] = L["PlayerFrameClassIcon"]
    L["TargetFrameClassIconDesc"] = L["PlayerFrameClassIconDesc"]
    L["TargetFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
    L["TargetFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
    L["TargetFrameNumericThreat"] = "Amenaza numérica"
    L["TargetFrameNumericThreatDesc"] = "Activar visualización numérica de amenaza"
    L["TargetFrameNumericThreatAnchor"] = "Ancla de amenaza numérica"
    L["TargetFrameNumericThreatAnchorDesc"] = "Establece la posición del ancla de amenaza numérica"
    L["TargetFrameThreatGlow"] = "Resplandor de amenaza"
    L["TargetFrameThreatGlowDesc"] = "Activar efecto de resplandor de amenaza"
    L["TargetFrameHideNameBackground"] = "Ocultar fondo del nombre"
    L["TargetFrameHideNameBackgroundDesc"] = "Ocultar el fondo del nombre del objetivo"
    L["TargetFrameComboPointsOnPlayerFrame"] = "Puntos de combo en el marco del jugador"
    L["TargetFrameComboPointsOnPlayerFrameDesc"] = "Mostrar puntos de combo en el marco del jugador"
    L["TargetFrameHideComboPoints"] = "Ocultar puntos de combo"
    L["TargetFrameHideComboPointsDesc"] = "Ocultar el marco de puntos de combo"
    L["TargetFrameFadeOut"] = "Desvanecimiento"
    L["TargetFrameFadeOutDesc"] =
        "Desvanece el marco de objetivo cuando el objetivo está a más de *Distancia de desvanecimiento* de distancia."
    L["TargetFrameFadeOutDistance"] = "Distancia de desvanecimiento"
    L["TargetFrameFadeOutDistanceDesc"] =
        "Establece la distancia en yardas para comprobar el efecto de desvanecimiento.\nNota: no todos los valores pueden hacer diferencia, ya que usa 'LibRangeCheck-3.0'.\nSe calcula por 'minRange >= fadeOutDistance'."

    L["TargetFrameHeaderBuffs"] = "Beneficios/Perjuicios"
    L["TargetFrameAuraSizeSmall"] = "Tamaño pequeño de auras"
    L["TargetFrameAuraSizeSmallDesc"] =
        "Establece el tamaño de las auras no del jugador en el marco de objetivo cuando se usa 'Tamaño dinámico de beneficios'."
    L["TargetFrameAuraSizeLarge"] = "Tamaño de auras"
    L["TargetFrameAuraSizeLargeDesc"] = "Establece el tamaño de una aura en el marco de objetivo."
    L["TargetFrameNoDebuffFilter"] = "Mostrar todos los perjuicios enemigos"
    L["TargetFrameNoDebuffFilterDesc"] =
        "Muestra perjuicios aliados y enemigos en el marco de objetivo, y no solo los tuyos."
    L["TargetFrameDynamicBuffSize"] = "Tamaño dinámico de beneficios"
    L["TargetFrameDynamicBuffSizeDesc"] =
        "Aumenta el tamaño de los beneficios y perjuicios del jugador en el objetivo."

    -- Pet
    L["PetFrameDesc"] = "Configuraciones del marco de la mascota"
    L["PetFrameStyle"] = L["ButtonTableStyle"]
    L["PetFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
    L["PetFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
    L["PetFrameThreatGlow"] = L["TargetFrameThreatGlow"]
    L["PetFrameThreatGlowDesc"] = L["TargetFrameThreatGlowDesc"]
    L["PetFrameHideStatusbarText"] = "Ocultar texto de la barra de estado"
    L["PetFrameHideStatusbarTextDesc"] = "Ocultar el texto de la barra de estado"
    L["PetFrameHideIndicator"] = "Ocultar indicador de golpe"
    L["PetFrameHideIndicatorDesc"] = "Ocultar el indicador de golpe"

    -- Focus
    L["FocusFrameDesc"] = "Configuraciones del marco de enfoque"
    L["FocusFrameStyle"] = L["ButtonTableStyle"]
    L["FocusFrameClassColor"] = L["PlayerFrameClassColor"]
    L["FocusFrameClassColorDesc"] = "Activar colores de clase para la barra de vida"
    L["FocusFrameClassIcon"] = L["PlayerFrameClassIcon"]
    L["FocusFrameClassIconDesc"] = "Activar icono de clase como retrato para el marco de enfoque"
    L["FocusFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
    L["FocusFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
    L["FocusFrameHideNameBackground"] = L["TargetFrameHideNameBackground"]
    L["FocusFrameHideNameBackgroundDesc"] = "Ocultar el fondo del nombre"

    -- party
    L["PartyFrameDesc"] = "Configuraciones del marco de grupo"
    L["PartyFrameStyle"] = L["ButtonTableStyle"]
    L["PartyFrameClassColor"] = L["PlayerFrameClassColor"]
    L["PartyFrameClassColorDesc"] = "Activar colores de clase para la barra de vida"
    L["PartyFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
    L["PartyFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
end

-- keybindings
do
    -- local KEY_REPLACEMENTS = {
    --     ["ALT%-"] = "a",
    --     ["CTRL%-"] = "c",
    --     ["SHIFT%-"] = "s",
    --     ["META%-"] = "c", -- Note: META is also mapped to C like CTRL
    --     ["NUMPAD"] = "N",
    --     ["PLUS"] = "+",
    --     ["MINUS"] = "-",
    --     ["MULTIPLY"] = "*",
    --     ["DIVIDE"] = "/",
    --     ["BACKSPACE"] = "BS",
    --     ["CAPSLOCK"] = "CP",
    --     ["CLEAR"] = "CL",
    --     ["DELETE"] = "Del",
    --     ["END"] = "En",
    --     ["HOME"] = "HM",
    --     ["INSERT"] = "Ins",
    --     ["MOUSEWHEELDOWN"] = "WD",
    --     ["MOUSEWHEELUP"] = "WU",
    --     ["NUMLOCK"] = "NL",
    --     ["PAGEDOWN"] = "PD",
    --     ["PAGEUP"] = "PU",
    --     ["SCROLLLOCK"] = "SL",
    --     ["SPACEBAR"] = "SP",
    --     ["SPACE"] = "SP",
    --     ["TAB"] = "TB",
    --     ["DOWNARROW"] = "Dn",
    --     ["LEFTARROW"] = "Lf",
    --     ["RIGHTARROW"] = "Rt",
    --     ["UPARROW"] = "Up"
    -- }

    -- local NUM_MOUSE_BUTTONS = 31
    -- for i = 1, NUM_MOUSE_BUTTONS do KEY_REPLACEMENTS["BUTTON" .. i] = "B" .. i end

    -- for k, v in pairs(KEY_REPLACEMENTS) do L[k] = v; end
    -- DF.KEY_REPLACEMENTS = KEY_REPLACEMENTS;
end

local L_ES = LibStub("AceLocale-3.0"):NewLocale("DragonflightUI", "esES")
local L_MX = LibStub("AceLocale-3.0"):NewLocale("DragonflightUI", "esMX")

if L_ES then for k, v in pairs(L) do L_ES[k] = v; end end

if L_MX then for k, v in pairs(L) do L_MX[k] = v; end end
