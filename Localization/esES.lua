-- print('esES, esMX')
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L_ES = LibStub("AceLocale-3.0"):NewLocale("DragonflightUI", "esES") or LibStub("AceLocale-3.0"):NewLocale("DragonflightUI", "esMX")

-- @TODO
-- preprocess to reuse strings - without this L[XY] = L['X'] will fail in AceLocale
local L = {}

-- modules - config.lua
L["ModuleTooltipActionbar"] =
    "Este módulo mejora la barra de acción predeterminada, incluyendo el micromenú y los botones de bolsas.\nAñade opciones separadas para las barras de acción 1-8, barra de mascotas, XP, reputación, posesión, actitud, tótems, bolsas y micromenú."
L["ModuleTooltipBossframe"] = "Este módulo añade marcos personalizados para los jefes.\nEN DESARROLLO."
L["ModuleTooltipBuffs"] =
    "Este módulo modifica el marco de beneficios predeterminado.\nAñade opciones separadas para Beneficios y Perjuicios."
L["ModuleTooltipCastbar"] =
    "Este módulo modifica la barra de lanzamiento predeterminada.\nAñade opciones separadas para la barra de lanzamiento del Jugador, Enfoque y Objetivo."
L["ModuleTooltipChat"] = "Este módulo modifica la ventana de bate-papo predeterminada.\nEN DESARROLLO."
L["ModuleTooltipDarkmode"] =
    "Este módulo añade un modo oscuro a múltiples marcos de la interfaz de Dragonflight.\nEN DESARROLLO - ¡por favor, envía tus comentarios!"
L["ModuleTooltipMinimap"] =
    "Este módulo mejora el minimapa y el rastreador de misiones.\nAñade opciones separadas para el minimapa y el rastreador de misiones."
L["ModuleTooltipUI"] =
    "Este módulo añade un estilo moderno a diferentes ventanas como el marco de personaje. También añade rediseños específicos de la Era con el nuevo libro de hechizos, el marco de talentos y la ventana de profesiones."
L["ModuleTooltipUnitframe"] =
    "Este módulo mejora los marcos de unidad predeterminados y añade nuevas funciones como el color de clase o la salud de los enemigos (Era).\nAñade opciones separadas para los marcos de jugador, mascota, objetivo, enfoque y grupo."
L["ModuleTooltipUtility"] = "Este módulo añade funciones y ajustes generales a la interfaz.\nEN DESARROLLO."

-- perfiles
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

-- Editmode
L["EditModeBasicOptions"] = "Opciones básicas"
L["EditModeAdvancedOptions"] = "Opciones avanzadas"
-- L["EditModeLayoutDropdown"] = HUD_EDIT_MODE_LAYOUT or "Layout"
-- L["EditModeCopyLayout"] = HUD_EDIT_MODE_COPY_LAYOUT or "Copy Layout"
-- L["EditModeRenameLayout"] = HUD_EDIT_MODE_RENAME_LAYOUT or "Change Name"
-- L["EditModeRenameOrCopyLayout"] = HUD_EDIT_MODE_RENAME_OR_COPY_LAYOUT or "Rename/Copy Layout"
-- L["EditModeDeleteLayout"] = HUD_EDIT_MODE_DELETE_LAYOUT or "Delete Layout"
-- L["EditModeNewLayoutDisabled"] = HUD_EDIT_MODE_NEW_LAYOUT_DISABLED or "%s New Layout"
-- L["EditModeNewLayout"] = HUD_EDIT_MODE_NEW_LAYOUT or "%s |cnPURE_GREEN_COLOR:New Layout|r"

L["EditModeLayoutDropdown"] = "Perfil"
L["EditModeCopyLayout"] = "Copiar perfil"
L["EditModeRenameLayout"] = ""
L["EditModeRenameOrCopyLayout"] = "Renombrar/copiar perfil"
L["EditModeDeleteLayout"] = "Eliminar perfil"
L["EditModeNewLayoutDisabled"] = "%s Nuevo perfil"
L["EditModeNewLayout"] = "%s |cnPURE_GREEN_COLOR:Nuevo perfil|r"

L["EditModeImportLayout"] = "Importar"
L["EditModeShareLayout"] = "Compartir"
L["EditModeCopyToClipboard"] = "Copiar al portapapeles |cffffd100(para compartir en línea)|r"

L["EditModeExportProfile"] = "Exportar perfil |cff8080ff%s|r"
L["EditModeImportProfile"] = "Importar perfil como |cff8080ff%s|r"

-- __Settings
L["SettingsDefaultStringFormat"] = "\n(Predeterminado: |cff8080ff%s|r)"

-- Tabla de posiciones
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
L["PositionTableX"] = "X"
L["PositionTableXDesc"] = ""
L["PositionTableY"] = "Y"
L["PositionTableYDesc"] = ""

-- Barra de acción
L["ActionbarNameFormat"] = "Barra de acción %d"

-- bar names
L["XPBar"] = "Barra de XP"
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
L["XPOptionsName"] = "XP"
L["XPOptionsDesc"] = "XP"

L["XPOptionsStyle"] = L["ButtonTableStyle"]
L["XPOptionsStyleDesc"] = ""

L["XPOptionsWidth"] = "Anchura"
L["XPOptionsWidthDesc"] = ""

L["XPOptionsHeight"] = "Altura"
L["XPOptionsHeightDesc"] = ""

L["XPOptionsAlwaysShowXPText"] = "Mostrar siempre el texto de XP"
L["XPOptionsAlwaysShowXPTextDesc"] = ""

L["XPOptionsShowXPPercent"] = "Mostrar porcentaje de XP"
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

-- Buffs
L["BuffsOptionsName"] = "Beneficios"
L["BuffsOptionsStyle"] = L["ButtonTableStyle"]
L["BuffsOptionsStyleDesc"] = ""

L["BuffsOptionsExpanded"] = "Expandido"
L["BuffsOptionsExpandedDesc"] = ""

L["BuffsOptionsUseStateHandler"] = "Usar manejador de estado"
L["BuffsOptionsUseStateHandlerDesc"] =
    "Sin esto, la configuración de visibilidad anterior no funcionará, pero podría mejorar la compatibilidad con otros complementos (por ejemplo, MinimapAlert), ya que no hace que los marcos sean seguros."

-- Castbar
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

L["ExtraOptionsResetToDefaultStyle"] = "Restablecer al estilo predeterminado"
L["ExtraOptionsPresetStyleDesc"] =
    "Restablece todas las configuraciones que cambian el estilo de la barra de lanzamiento, pero no modifica ninguna otra configuración."

-- Minimap
L["MinimapName"] = "Minimapa"
L["MinimapShowPing"] = "Mostrar ping"
L["MinimapNotYetImplemented"] = "(NO IMPLEMENTADO AÚN)"
L["MinimapShowPingInChat"] = "Mostrar..."
L["MinimapHideCalendar"] = "Ocultar calendario"
L["MinimapHideCalendarDesc"] = "Oculta el botón del calendario"
L["MinimapHideZoomButtons"] = "Ocultar botones de zoom"
L["MinimapHideZoomDesc"] = "Oculta los botones de zoom (+) (-)"
L["MinimapSkinMinimapButtons"] = "Personalizar botones del minimapa"
L["MinimapSkinMinimapButtonsDesc"] =
    "Cambia el estilo de los botones del minimapa usando LibDBIcon (la mayoría de los addons lo usan)"
L["MinimapUseStateHandler"] = "Usar controlador de estado"
L["MinimapUseStateHandlerDesc"] =
    "Sin esto, la configuración de visibilidad anterior no funcionará, pero podría mejorar la compatibilidad con otros addons (por ejemplo, MinimapAlert) ya que no hace que los marcos sean seguros."

-- UI
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

-- unit frames
-- player
L["PlayerFrameDesc"] = "Configuración del marco del jugador"
L["PlayerFrameStyle"] = L["ButtonTableStyle"]
L["PlayerFrameClassColor"] = "Color de clase"
L["PlayerFrameClassColorDesc"] = "Habilita los colores de clase para la barra de vida"
L["PlayerFrameClassIcon"] = "Retrato con icono de clase"
L["PlayerFrameClassIconDesc"] = "Habilita el icono de clase como retrato (actualmente deshabilitado)"
L["PlayerFrameBreakUpLargeNumbers"] = "Separar números grandes"
L["PlayerFrameBreakUpLargeNumbersDesc"] =
    "Habilita la separación de números grandes en el texto de estado (por ejemplo, 7588 K en lugar de 7588000)"
L["PlayerFrameBiggerHealthbar"] = "Barra de vida más grande"
L["PlayerFrameBiggerHealthbarDesc"] = "Habilita una barra de vida más grande"
L["PlayerFrameHideRedStatus"] = "Ocultar resplandor rojo en combate"
L["PlayerFrameHideRedStatusDesc"] = "Oculta el resplandor rojo de estado en combate"
L["PlayerFrameHideHitIndicator"] = "Ocultar indicador de golpe"
L["PlayerFrameHideHitIndicatorDesc"] = "Oculta el indicador de golpe en el marco del jugador"
L["PlayerFrameHideSecondaryRes"] = "Ocultar recurso secundario"
L["PlayerFrameHideSecondaryResDesc"] = "Oculta el recurso secundario, por ejemplo, fragmentos de alma."

-- Target
L["TargetFrameDesc"] = "Configuraciones del marco del objetivo"
L["TargetFrameStyle"] = L["ButtonTableStyle"]
L["TargetFrameClassColor"] = L["PlayerFrameClassColor"]
L["TargetFrameClassColorDesc"] = "Habilitar colores de clase para la barra de vida"
L["TargetFrameClassIcon"] = L["PlayerFrameClassIcon"]
L["TargetFrameClassIconDesc"] = L["PlayerFrameClassIconDesc"]
L["TargetFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
L["TargetFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
L["TargetFrameNumericThreat"] = "Amenaza numérica"
L["TargetFrameNumericThreatDesc"] = "Habilitar visualización numérica de amenaza"
L["TargetFrameNumericThreatAnchor"] = "Ancla de amenaza numérica"
L["TargetFrameNumericThreatAnchorDesc"] = "Establece la posición del ancla de amenaza numérica"
L["TargetFrameThreatGlow"] = "Resplandor de amenaza"
L["TargetFrameThreatGlowDesc"] = "Habilitar efecto de resplandor de amenaza"
L["TargetFrameHideNameBackground"] = "Ocultar fondo del nombre"
L["TargetFrameHideNameBackgroundDesc"] = "Ocultar el fondo del nombre del objetivo"
L["TargetFrameComboPointsOnPlayerFrame"] = "Puntos de combo en el marco del jugador"
L["TargetFrameComboPointsOnPlayerFrameDesc"] = "Mostrar puntos de combo en el marco del jugador"
L["TargetFrameHideComboPoints"] = "Ocultar puntos de combo"
L["TargetFrameHideComboPointsDesc"] = "Ocultar el marco de puntos de combo"

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
L["FocusFrameClassColorDesc"] = "Habilitar colores de clase para la barra de vida"
L["FocusFrameClassIcon"] = L["PlayerFrameClassIcon"]
L["FocusFrameClassIconDesc"] = "Habilitar icono de clase como retrato para el marco de enfoque"
L["FocusFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
L["FocusFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
L["FocusFrameHideNameBackground"] = L["TargetFrameHideNameBackground"]
L["FocusFrameHideNameBackgroundDesc"] = "Ocultar el fondo del nombre"

-- Party
L["PartyFrameDesc"] = "Configuraciones del marco de grupo"
L["PartyFrameStyle"] = L["ButtonTableStyle"]
L["PartyFrameClassColor"] = L["PlayerFrameClassColor"]
L["PartyFrameClassColorDesc"] = "Habilitar colores de clase para la barra de vida"
L["PartyFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
L["PartyFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]

-- see comment above
for k, v in pairs(L) do L_ES[k] = v; end
