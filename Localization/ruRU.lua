-- print('ruRU')  - Translator ZamestoTV
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L_RU = LibStub("AceLocale-3.0"):NewLocale("DragonflightUI", "ruRU")

if not L_RU then return end

local L = {}

-- modules - config.lua
L_EN["ModuleModules"] = "Модули"

L_EN["ModuleTooltipActionbar"] =
    "Этот модуль полностью перерабатывает стандартную панель действий, включая микроменю и кнопки сумок.\nДобавляет отдельные настройки для панелей действий 1-8, панели питомцев, опыта, репутации, контроля, стойки и тотемов, сумок и микроменю."
L_EN["ModuleTooltipBossframe"] = "Этот модуль добавляет пользовательские рамки боссов.\nВ РАЗРАБОТКЕ."
L_EN["ModuleTooltipBuffs"] = "Этот модуль изменяет стандартное окно баффов.\nДобавляет отдельные настройки для баффов и дебаффов."
L_EN["ModuleTooltipCastbar"] =
    "Этот модуль изменяет стандартную полосу заклинаний.\nДобавляет отдельные настройки для полос заклинаний игрока, фокуса и цели."
L_EN["ModuleTooltipChat"] = "Этот модуль изменяет стандартное окно чата.\nВ РАЗРАБОТКЕ."
L_EN["ModuleTooltipCompatibility"] = "Этот модуль добавляет дополнительную совместимость с другими аддонами."
L_EN["ModuleTooltipDarkmode"] =
    "Этот модуль добавляет темный режим для нескольких рамок DragonflightUI.\nВ РАЗРАБОТКЕ — пожалуйста, оставляйте отзывы!"
L_EN["ModuleTooltipMinimap"] =
    "Этот модуль перерабатывает стандартную миникарту и трекер заданий.\nДобавляет отдельные настройки для миникарты и трекера заданий."
L_EN["ModuleTooltipTooltip"] = "Этот модуль улучшает игровые подсказки.\nВ РАЗРАБОТКЕ."
L_EN["ModuleTooltipUI"] =
    "Этот модуль добавляет современный стиль интерфейса к различным окнам, таким как окно персонажа. Также добавляет переработки, специфичные для Classic, с новым окном заклинаний, рамкой талантов или окном профессий."
L_EN["ModuleTooltipUnitframe"] =
    "Этот модуль перерабатывает стандартные рамки юнитов и добавляет новые функции, такие как цвета классов или здоровье мобов (Classic).\nДобавляет отдельные настройки для рамок игрока, питомца, цели, фокуса и группы."
L_EN["ModuleTooltipUtility"] = "Этот модуль добавляет общие функции и улучшения интерфейса.\nВ РАЗРАБОТКЕ."

L_EN["ModuleConditionalMessage"] =
    "'|cff8080ff%s|r' был деактивирован, но соответствующая функция уже была зацеплена, пожалуйста, выполните '|cff8080ff/reload|r'!"

-- config
L_EN["ConfigToolbarCopyPopup"] = "Скопируйте ссылку ниже (Ctrl+C, Enter):"

L_EN["ConfigToolbarDiscord"] = "Discord"
L_EN["ConfigToolbarDiscordTooltip"] = "Вносите идеи и получайте поддержку."
L_EN["ConfigToolbarGithub"] = "Github"
L_EN["ConfigToolbarGithubTooltip"] = "Просматривайте код, сообщайте об ошибках и вносите вклад."
L_EN["ConfigToolbarCoffee"] = "BuyMeACoffee"
L_EN["ConfigToolbarCoffeeTooltip1"] =
    "Каждый комментарий, лайк или репост имеет значение, но если вы чувствуете себя особенно щедрым, вы можете угостить меня куском пиццы, чтобы поддержать дальнейшую разработку!"
L_EN["ConfigToolbarCoffeeTooltip2"] = "Поддерживающие получают эксклюзивные бонусы, узнайте о них в разделе для спонсоров на нашем Discord."

-- profiles
L_EN["ProfilesSetActiveProfile"] = "Установить активный профиль."
L_EN["ProfilesNewProfile"] = "Создать новый профиль."
L_EN["ProfilesCopyFrom"] = "Скопировать настройки из одного существующего профиля в текущий активный профиль."
L_EN["ProfilesOpenCopyDialogue"] = "Открывает диалог копирования."
L_EN["ProfilesDeleteProfile"] = "Удалить существующий профиль из базы данных."
L_EN["Profiles"] = "Добавить новый профиль"

L_EN["ProfilesOpenDeleteDialogue"] = "Открывает диалог удаления."

L_EN["ProfilesAddNewProfile"] = "Добавить новый профиль"

L_EN["ProfilesChatNewProfile"] = "новый профиль: "
L_EN["ProfilesErrorNewProfile"] = "ОШИБКА: Имя нового профиля не может быть пустым!"

L_EN["ProfilesDialogueDeleteProfile"] = "Удалить профиль \'%s\'?"
L_EN["ProfilesDialogueCopyProfile"] = "Добавить новый профиль (скопировать из \'|cff8080ff%s|r\')"

L_EN["ProfilesImportShareHeader"] = "Импорт/Поделиться"
L_EN["ProfilesImportProfile"] = "Импортировать профиль"
L_EN["ProfilesImportProfileButton"] = "Импортировать"
L_EN["ProfilesImportProfileDesc"] = "Открывает диалог импорта."
L_EN["ProfilesExportProfile"] = "Поделиться профилем"
L_EN["ProfilesExportProfileButton"] = "Поделиться"
L_EN["ProfilesExportProfileDesc"] = "Открывает диалог для передачи."

-- Editmode
L_EN["EditModeBasicOptions"] = "Основные настройки"
L_EN["EditModeAdvancedOptions"] = "Расширенные настройки"

L_EN["EditModeLayoutDropdown"] = "Профиль"
L_EN["EditModeCopyLayout"] = "Копировать профиль"
L_EN["EditModeRenameLayout"] = ""
L_EN["EditModeRenameOrCopyLayout"] = "Переименовать/Копировать профиль"
L_EN["EditModeDeleteLayout"] = "Удалить профиль"
L_EN["EditModeNewLayoutDisabled"] = "%s Новый профиль"
L_EN["EditModeNewLayout"] = "%s |cnPURE_GREEN_COLOR:Новый профиль|r"

L_EN["EditModeImportLayout"] = "Импортировать"
L_EN["EditModeShareLayout"] = "Поделиться"
L_EN["EditModeCopyToClipboard"] = "Скопировать в буфер обмена |cffffd100(для передачи онлайн)|r"

L_EN["EditModeExportProfile"] = "Экспортировать профиль |cff8080ff%s|r"
L_EN["EditModeImportProfile"] = "Импортировать профиль как |cff8080ff%s|r"

-- Compat
L_EN['CompatName'] = "Совместимость"

L_EN['CompatAuctionator'] = "Auctionator"
L_EN['CompatAuctionatorDesc'] =
    "Добавляет совместимость с Auctionator при использовании модуля UI с включенной опцией 'Изменить окно профессий'."
L_EN['CompatBaganator'] = "Baganator"
L_EN['CompatBaganatorDesc'] = "Изменяет стандартную тему 'Blizzard' на стилизованную под DragonflightUI."
L_EN['CompatCharacterStatsClassic'] = "CharacterStatsClassic"
L_EN['CompatCharacterStatsClassicDesc'] =
    "Добавляет совместимость с CharacterStatsClassic при использовании модуля UI с включенной опцией 'Изменить окно персонажа'."
L_EN['CompatClassicCalendar'] = "Classic Calendar"
L_EN['CompatClassicCalendarDesc'] = "Добавляет совместимость с Classic Calendar."
L_EN['CompatLFGBulletinBoard'] = "LFG Bulletin Board"
L_EN['CompatLFGBulletinBoardDesc'] = "Добавляет совместимость с LFG Bulletin Board."
L_EN['CompatMerInspect'] = "MerInspect"
L_EN['CompatMerInspectDesc'] =
    "Добавляет совместимость с MerInspect при использовании модуля UI с включенной опцией 'Изменить окно персонажа'."
L_EN['CompatRanker'] = "Ranker"
L_EN['CompatRankerDesc'] =
    "Добавляет совместимость с Ranker при использовании модуля UI с включенной опцией 'Изменить окно персонажа'."
L_EN['CompatTacoTip'] = "TacoTip"
L_EN['CompatTacoTipDesc'] =
    "Добавляет совместимость с TacoTip при использовании модуля UI с включенной опцией 'Изменить окно персонажа'."
L_EN['CompatTDInspect'] = "TDInspect"
L_EN['CompatTDInspectDesc'] =
    "Добавляет совместимость с TDInspect при использовании модуля UI с включенной опцией 'Изменить окно персонажа'."
L_EN['CompatWhatsTraining'] = "WhatsTraining"
L_EN['CompatWhatsTrainingDesc'] =
    "Добавляет совместимость с WhatsTraining при использовании модуля UI с включенной опцией 'Изменить книгу заклинаний'."

-- __Settings
L_EN["SettingsDefaultStringFormat"] = "\n(По умолчанию: |cff8080ff%s|r)"

-- positionTable
L_EN["PositionTableHeader"] = "Масштаб и положение"
L_EN["PositionTableHeaderDesc"] = ""
L_EN["PositionTableScale"] = "Масштаб"
L_EN["PositionTableScaleDesc"] = ""
L_EN["PositionTableAnchor"] = "Якорь"
L_EN["PositionTableAnchorDesc"] = "Якорь"
L_EN["PositionTableAnchorParent"] = "Родительский якорь"
L_EN["PositionTableAnchorParentDesc"] = ""
L_EN["PositionTableAnchorFrame"] = "Рамка якоря"
L_EN["PositionTableAnchorFrameDesc"] = ""
L_EN["PositionTableCustomAnchorFrame"] = "Рамка якоря (пользовательская)"
L_EN["PositionTableCustomAnchorFrameDesc"] =
    "Используйте эту именованную рамку в качестве якоря (если она действительна). Например, 'CharacterFrame', 'TargetFrame'..."
L_EN["PositionTableX"] = "X"
L_EN["PositionTableXDesc"] = ""
L_EN["PositionTableY"] = "Y"
L_EN["PositionTableYDesc"] = ""

-- darkmode
L_EN["DarkmodeColor"] = "Цвет"
L_EN["DarkmodeDesaturate"] = "Обесцвечивание"

-- actionbar
L_EN["ActionbarName"] = "Панель действий"
L_EN["ActionbarNameFormat"] = "Панель действий %d"

-- bar names
L_EN["XPBar"] = "Полоса опыта"
L_EN["ReputationBar"] = "Полоса репутации"
L_EN["PetBar"] = "Панель питомца"
L_EN["StanceBar"] = "Панель стоек"
L_EN["PossessBar"] = "Панель контроля"
L_EN["MicroMenu"] = "Микроменю"
L_EN["TotemBar"] = "Панель тотемов"

-- gryphonsTable
L_EN["Default"] = "По умолчанию"
L_EN["Alliance"] = "Альянс"
L_EN["Horde"] = "Орда"
L_EN["None"] = "Нет"

-- buttonTable
L_EN["ButtonTableActive"] = "Активно"
L_EN["ButtonTableActiveDesc"] = ""

L_EN["ButtonTableButtons"] = "Кнопки"
L_EN["ButtonTableButtonsDesc"] = ""

L_EN["ButtonTableButtonScale"] = "Масштаб кнопок"
L_EN["ButtonTableButtonScaleDesc"] = ""

L_EN["ButtonTableOrientation"] = "Ориентация"
L_EN["ButtonTableOrientationDesc"] = "Ориентация"

L_EN["ButtonTableReverseButtonOrder"] = "Обратный порядок кнопок"
L_EN["ButtonTableReverseButtonOrderDesc"] = ""

L_EN["ButtonTableNumRows"] = "Количество строк"
L_EN["ButtonTableNumRowsDesc"] = ""

L_EN["ButtonTableNumButtons"] = "Количество кнопок"
L_EN["ButtonTableNumButtonsDesc"] = ""

L_EN["ButtonTablePadding"] = "Отступ"
L_EN["ButtonTablePaddingDesc"] = ""

L_EN["ButtonTableStyle"] = "Стиль"
L_EN["ButtonTableStyleDesc"] = ""

L_EN["ButtonTableAlwaysShowActionbar"] = "Всегда показывать панель действий"
L_EN["ButtonTableAlwaysShowActionbarDesc"] = ""

L_EN["ButtonTableHideMacroText"] = "Скрыть текст макросов"
L_EN["ButtonTableHideMacroTextDesc"] = ""

L_EN["ButtonTableMacroNameFontSize"] = "Размер шрифта имени макроса"
L_EN["ButtonTableMacroNameFontSizeDesc"] = ""

L_EN["ButtonTableHideKeybindText"] = "Скрыть текст горячих клавиш"
L_EN["ButtonTableHideKeybindTextDesc"] = ""

L_EN["ButtonTableShortenKeybindText"] = "Сократить текст горячих клавиш"
L_EN["ButtonTableShortenKeybindTextDesc"] =
    "Сокращает текст горячих клавиш, например, 'sF' вместо 's-F' и подобные замены."

L_EN["ButtonTableKeybindFontSize"] = "Размер шрифта горячих клавиш"
L_EN["ButtonTableKeybindFontSizeDesc"] = ""

L_EN["MoreOptionsHideBarArt"] = "Скрыть оформление панели"
L_EN["MoreOptionsHideBarArtDesc"] = ""

L_EN["MoreOptionsHideBarScrolling"] = "Скрыть прокрутку панели"
L_EN["MoreOptionsHideBarScrollingDesc"] = ""

L_EN["MoreOptionsGryphons"] = "Грифоны"
L_EN["MoreOptionsGryphonsDesc"] = "Грифоны"

L_EN["MoreOptionsUseKeyDown"] = "Использовать нажатие клавиши"
L_EN["MoreOptionsUseKeyDownDesc"] = "Активирует способности при нажатии клавиши."

L_EN["MoreOptionsIconRangeColor"] = "Цвет значка вне зоны действия"
L_EN["MoreOptionsIconRangeColorDesc"] = "Изменяет цвет значка, когда цель вне зоны действия, аналогично RedRange/tullaRange."

L_EN["ExtraOptionsPreset"] = "Предустановка"
L_EN["ExtraOptionsResetToDefaultPosition"] = "Сбросить на позицию по умолчанию"
L_EN["ExtraOptionsPresetDesc"] =
    "Устанавливает масштаб, якорь, родительский якорь, рамку якоря, X и Y в соответствии с выбранной предустановкой, но не изменяет другие настройки."

L_EN["ExtraOptionsModernLayout"] = "Современный макет (по умолчанию)"
L_EN["ExtraOptionsModernLayoutDesc"] = ""

L_EN["ExtraOptionsClassicLayout"] = "Классический макет (боковая панель)"
L_EN["ExtraOptionsClassicLayoutDesc"] = ""

-- XP
L_EN["XPOptionsName"] = "Опыт"
L_EN["XPOptionsDesc"] = "Опыт"

L_EN["XPOptionsStyle"] = L_EN["ButtonTableStyle"]
L_EN["XPOptionsStyleDesc"] = ""

L_EN["XPOptionsWidth"] = "Ширина"
L_EN["XPOptionsWidthDesc"] = ""

L_EN["XPOptionsHeight"] = "Высота"
L_EN["XPOptionsHeightDesc"] = ""

L_EN["XPOptionsAlwaysShowXPText"] = "Всегда показывать текст опыта"
L_EN["XPOptionsAlwaysShowXPTextDesc"] = ""

L_EN["XPOptionsShowXPPercent"] = "Показывать процент опыта"
L_EN["XPOptionsShowXPPercentDesc"] = ""

-- rep
L_EN["RepOptionsName"] = "Репутация"
L_EN["RepOptionsDesc"] = "Репутация"

L_EN["RepOptionsStyle"] = L_EN["ButtonTableStyle"]
L_EN["RepOptionsStyleDesc"] = ""

L_EN["RepOptionsWidth"] = L_EN["XPOptionsWidth"]
L_EN["RepOptionsWidthDesc"] = L_EN["XPOptionsWidthDesc"]

L_EN["RepOptionsHeight"] = L_EN["XPOptionsHeight"]
L_EN["RepOptionsHeightDesc"] = L_EN["XPOptionsHeightDesc"]

L_EN["RepOptionsAlwaysShowRepText"] = "Всегда показывать текст репутации"
L_EN["RepOptionsAlwaysShowRepTextDesc"] = ""

-- Bags
L_EN["BagsOptionsName"] = "Сумки"
L_EN["BagsOptionsDesc"] = "Сумки"

L_EN["BagsOptionsStyle"] = L_EN["ButtonTableStyle"]
L_EN["BagsOptionsStyleDesc"] = ""

L_EN["BagsOptionsExpanded"] = "Развернуто"
L_EN["BagsOptionsExpandedDesc"] = ""

L_EN["BagsOptionsHideArrow"] = "Скрыть стрелку"
L_EN["BagsOptionsHideArrowDesc"] = ""

L_EN["BagsOptionsHidden"] = "Скрыто"
L_EN["BagsOptionsHiddenDesc"] = "Рюкзак скрыт"

L_EN["BagsOptionsOverrideBagAnchor"] = "Переопределить якорь сумок"
L_EN["BagsOptionsOverrideBagAnchorDesc"] = ""

L_EN["BagsOptionsOffsetX"] = "Смещение якоря сумок по X"
L_EN["BagsOptionsOffsetXDesc"] = ""

L_EN["BagsOptionsOffsetY"] = "Смещение якоря сумок по Y"
L_EN["BagsOptionsOffsetYDesc"] = ""

-- FPS
L_EN["FPSOptionsName"] = "FPS"
L_EN["FPSOptionsDesc"] = "FPS"

L_EN["FPSOptionsStyle"] = L_EN["ButtonTableStyle"]
L_EN["FPSOptionsStyleDesc"] = ""

L_EN["FPSOptionsHideDefaultFPS"] = "Скрыть стандартный FPS"
L_EN["FPSOptionsHideDefaultFPSDesc"] = "Скрыть стандартный текст FPS"

L_EN["FPSOptionsShowFPS"] = "Показать FPS"
L_EN["FPSOptionsShowFPSDesc"] = "Показать пользовательский текст FPS"

L_EN["FPSOptionsAlwaysShowFPS"] = "Всегда показывать FPS"
L_EN["FPSOptionsAlwaysShowFPSDesc"] = "Всегда показывать пользовательский текст FPS"

L_EN["FPSOptionsShowPing"] = "Показать пинг"
L_EN["FPSOptionsShowPingDesc"] = "Показать пинг в мс"

-- Extra Action Button
L_EN["ExtraActionButtonOptionsName"] = "Дополнительная кнопка действия"
L_EN["ExtraActionButtonOptionsNameDesc"] = "FPS"
L_EN["ExtraActionButtonStyle"] = L_EN["ButtonTableStyle"]
L_EN["ExtraActionButtonStyleDesc"] = ""
L_EN["ExtraActionButtonHideBackgroundTexture"] = "Скрыть фоновую текстуру"
L_EN["ExtraActionButtonHideBackgroundTextureDesc"] = ""

-- Buffs
L_EN["BuffsOptionsName"] = "Баффы"
L_EN["BuffsOptionsStyle"] = L_EN["ButtonTableStyle"]
L_EN["BuffsOptionsStyleDesc"] = ""

L_EN["BuffsOptionsExpanded"] = "Развернуто"
L_EN["BuffsOptionsExpandedDesc"] = ""

L_EN["BuffsOptionsUseStateHandler"] = "Использовать обработчик состояния"
L_EN["BuffsOptionsUseStateHandlerDesc"] =
    "Без этого настройки видимости выше не будут работать, но это может улучшить совместимость с другими аддонами (например, MinimapAlert), так как не делает рамки защищенными."

-- Castbar
L_EN["CastbarName"] = "Полоса заклинаний"
L_EN["CastbarNameFormat"] = "Полоса заклинаний %s"
L_EN["CastbarTableActive"] = "Активно"
L_EN["CastbarTableActivateDesc"] = ""
L_EN["CastbarTableStyle"] = L_EN["ButtonTableStyle"]
L_EN["CastbarTableStyleDesc"] = ""
L_EN["CastbarTableWidth"] = L_EN["XPOptionsWidth"]
L_EN["CastbarTableWidthDesc"] = L_EN["XPOptionsWidthDesc"]
L_EN["CastbarTableHeight"] = L_EN["XPOptionsHeight"]
L_EN["CastbarTableHeightDesc"] = L_EN["XPOptionsHeightDesc"]
L_EN["CastbarTablePrecisionTimeLeft"] = "Точность (оставшееся время)"
L_EN["CastbarTablePrecisionTimeLeftDesc"] = ""
L_EN["CastbarTablePrecisionTimeMax"] = "Точность (максимальное время)"
L_EN["CastbarTablePrecisionTimeMaxDesc"] = ""
L_EN["CastbarTableShowCastTimeText"] = "Показывать текст времени произнесения"
L_EN["CastbarTableShowCastTimeTextDesc"] = ""
L_EN["CastbarTableShowCastTimeMaxText"] = "Показывать текст максимального времени произнесения"
L_EN["CastbarTableShowCastTimeMaxTextDesc"] = ""
L_EN["CastbarTableCompactLayout"] = "Компактный макет"
L_EN["CastbarTableCompactLayoutDesc"] = ""
L_EN["CastbarTableHoldTimeSuccess"] = "Время задержки (успех)"
L_EN["CastbarTableHoldTimeSuccessDesc"] = "Время до начала затухания полосы после успешного произнесения заклинания."
L_EN["CastbarTableHoldTimeInterrupt"] = "Время задержки (прерывание)"
L_EN["CastbarTableHoldTimeInterruptDesc"] = "Время до начала затухания полосы после прерывания заклинания."
L_EN["CastbarTableShowIcon"] = "Показывать значок"
L_EN["CastbarTableShowIconDesc"] = ""
L_EN["CastbarTableIconSize"] = "Размер значка"
L_EN["CastbarTableIconSizeDesc"] = ""
L_EN["CastbarTableShowTicks"] = "Показывать тики"
L_EN["CastbarTableShowTicksDesc"] = ""
L_EN["CastbarTableAutoAdjust"] = "Автоматическая настройка"
L_EN["CastbarTableAutoAdjustDesc"] =
    "Применяет смещение по Y в зависимости от количества баффов/дебаффов — полезно, когда полоса заклинаний привязана под рамкой цели/фокуса."
L_EN["CastbarTableShowRank"] = "Показывать ранг"
L_EN["CastbarTableShowRankDesc"] = ""
L_EN["CastbarTableShowChannelName"] = "Показывать название канала"
L_EN["CastbarTableShowChannelNameDesc"] = "Показывает название заклинания вместо отображаемого текста (например, 'Направляем')."

L_EN["ExtraOptionsResetToDefaultStyle"] = "Сбросить на стиль по умолчанию"
L_EN["ExtraOptionsPresetStyleDesc"] =
    "Устанавливает все настройки, изменяющие стиль полосы заклинаний, но не изменяет другие настройки."

-- Minimap
L_EN["MinimapName"] = "Миникарта"
L_EN["MinimapStyle"] = L_EN["ButtonTableStyle"]
L_EN["MinimapShowPing"] = "Показывать пинг"
L_EN["MinimapNotYetImplemented"] = "(ЕЩЕ НЕ РЕАЛИЗОВАНО)"
L_EN["MinimapShowPingInChat"] = "Показывать пинг в чате"
L_EN["MinimapHideCalendar"] = "Скрыть календарь"
L_EN["MinimapHideCalendarDesc"] = "Скрывает кнопку календаря"
L_EN["MinimapHideZoomButtons"] = "Скрыть кнопки масштаба"
L_EN["MinimapHideZoomDesc"] = "Скрывает кнопки масштаба (+) (-)"
L_EN["MinimapSkinMinimapButtons"] = "Стилизовать кнопки миникарты"
L_EN["MinimapSkinMinimapButtonsDesc"] = "Изменяет стиль кнопок миникарты с использованием LibDBIcon (используется большинством аддонов)."
L_EN["MinimapUseStateHandler"] = "Использовать обработчик состояния"
L_EN["MinimapUseStateHandlerDesc"] =
    "Без этого настройки видимости выше не будут работать, но это может улучшить совместимость с другими аддонами (например, MinimapAlert), так как не делает рамки защищенными."

-- UI
L_EN["UIUtility"] = "Утилиты"
L_EN["UIChangeBags"] = "Изменить сумки"
L_EN["UIChangeBagsDesc"] = ""
L_EN["UIColoredInventoryItems"] = "Цветные предметы инвентаря"
L_EN["UIColoredInventoryItemsDesc"] = "Включить окраску предметов инвентаря в зависимости от их качества."
L_EN["UIShowQuestlevel"] = "Показывать уровень задания"
L_EN["UIShowQuestlevelDesc"] = "Отображать уровень задания рядом с его названием."
L_EN["UIFrames"] = "Рамки"
L_EN["UIFramesDesc"] = "Настройки для изменения различных игровых рамок."
L_EN["UIChangeCharacterFrame"] = "Изменить окно персонажа"
L_EN["UIChangeCharacterFrameDesc"] = "Изменить внешний вид окна персонажа."
L_EN["UIChangeProfessionWindow"] = "Изменить окно профессий"
L_EN["UIChangeProfessionWindowDesc"] = "Изменить внешний вид окна профессий."
L_EN["UIChangeInspectFrame"] = "Изменить окно осмотра"
L_EN["UIChangeInspectFrameDesc"] = "Изменить внешний вид окна осмотра."
L_EN["UIChangeTrainerWindow"] = "Изменить окно тренера"
L_EN["UIChangeTrainerWindowDesc"] = "Изменить внешний вид окна тренера."
L_EN["UIChangeTalentFrame"] = "Изменить окно талантов"
L_EN["UIChangeTalentFrameDesc"] = "Изменить макет или внешний вид окна талантов. (Недоступно в Wrath)"
L_EN["UIChangeSpellBook"] = "Изменить книгу заклинаний"
L_EN["UIChangeSpellBookDesc"] = "Изменить внешний вид книги заклинаний."
L_EN["UIChangeSpellBookProfessions"] = "Изменить профессии в книге заклинаний"
L_EN["UIChangeSpellBookProfessionsDesc"] = "Изменить макет книги заклинаний для профессий."

-- ProfessionFrame
L_EN["ProfessionFrameHasSkillUp"] = "Имеет повышение навыка"
L_EN["ProfessionFrameHasMaterials"] = "Можно создать"
L_EN["ProfessionFrameSubclass"] = "Подкласс"
L_EN["ProfessionFrameSlot"] = "Слот"
L_EN["ProfessionCheckAll"] = "Выбрать все"
L_EN["ProfessionUnCheckAll"] = "Снять выбор со всех"
L_EN["ProfessionFavorites"] = "Избранное"

-- Tooltip
L_EN["TooltipName"] = "Подсказка"
L_EN["TooltipHeaderGameToltip"] = "Игровая подсказка"
L_EN["TooltipHeaderSpellTooltip"] = "Подсказка заклинания"

L_EN["TooltipCursorAnchorHeader"] = "Якорь курсора"
L_EN["TooltipCursorAnchorHeaderDesc"] = ""
L_EN["TooltipAnchorToMouse"] = "Якорь на курсоре"
L_EN["TooltipAnchorToMouseDesc"] = "Привязывает некоторые подсказки (например, подсказку юнита на мировом фрейме) к курсору мыши."
L_EN["TooltipMouseAnchor"] = "Якорь курсора"
L_EN["TooltipMouseAnchorDesc"] = ""
L_EN["TooltipMouseX"] = "X"
L_EN["TooltipMouseXDesc"] = ""
L_EN["TooltipMouseY"] = "Y"
L_EN["TooltipMouseYDesc"] = ""

-- spelltooltip
L_EN["TooltipAnchorSpells"] = "Якорь заклинаний"
L_EN["TooltipAnchorSpellsDesc"] = "Привязывает подсказку заклинания на панелях действий к кнопке вместо стандартного якоря."
L_EN["TooltipShowSpellID"] = "Показывать ID заклинания"
L_EN["TooltipShowSpellIDDesc"] = ""
L_EN["TooltipShowSpellSource"] = "Показывать источник заклинания"
L_EN["TooltipShowSpellSourceDesc"] = ""
L_EN["TooltipShowSpellIcon"] = "Показывать значок заклинания"
L_EN["TooltipShowSpellIconDesc"] = ""
L_EN["TooltipShowIconID"] = "Показывать ID значка"
L_EN["TooltipShowIconIDDesc"] = ""

L_EN["TooltipShowIcon"] = "Показывать значок"
L_EN["TooltipShowIconDesc"] = ""

-- itemtooltip
L_EN["TooltipHeaderItemTooltip"] = "Подсказка предмета"
L_EN["TooltipHeaderItemTooltipDesc"] = ""

L_EN["TooltipShowItemQuality"] = "Граница качества предмета"
L_EN["TooltipShowItemQualityDesc"] = ""
L_EN["TooltipShowItemQualityBackdrop"] = "Фон качества предмета"
L_EN["TooltipShowItemQualityBackdropDesc"] = ""
L_EN["TooltipShowItemStackCount"] = "Показывать размер стака"
L_EN["TooltipShowItemStackCountDesc"] = ""
L_EN["TooltipShowItemID"] = "Показывать ID предмета"
L_EN["TooltipShowItemIDDesc"] = ""

-- unittooltip
L_EN["TooltipUnitTooltip"] = "Подсказка юнита"
L_EN["TooltipUnitTooltipDesc"] = ""

L_EN["TooltipUnitClassBorder"] = "Граница класса"
L_EN["TooltipUnitClassBorderDesc"] = ""
L_EN["TooltipUnitClassBackdrop"] = "Фон класса"
L_EN["TooltipUnitClassBackdropDesc"] = ""

L_EN["TooltipUnitReactionBorder"] = "Граница реакции"
L_EN["TooltipUnitReactionBorderDesc"] = ""
L_EN["TooltipUnitReactionBackdrop"] = "Фон реакции"
L_EN["TooltipUnitReactionBackdropDesc"] = ""

L_EN["TooltipUnitClassName"] = "Имя класса"
L_EN["TooltipUnitClassNameDesc"] = ""
L_EN["TooltipUnitTitle"] = "Показывать титул"
L_EN["TooltipUnitTitleDesc"] = ""
L_EN["TooltipUnitRealm"] = "Показывать игровой мир"
L_EN["TooltipUnitRealmDesc"] = ""
L_EN["TooltipUnitGuild"] = "Показывать гильдию"
L_EN["TooltipUnitGuildDesc"] = ""
L_EN["TooltipUnitGuildRank"] = "Показывать ранг гильдии"
L_EN["TooltipUnitGuildRankDesc"] = ""
L_EN["TooltipUnitGuildRankIndex"] = "Показывать индекс ранга гильдии"
L_EN["TooltipUnitGuildRankIndexDesc"] = ""
L_EN["TooltipUnitGrayOutOnDeath"] = "Затемнять при смерти"
L_EN["TooltipUnitGrayOutOnDeathDesc"] = ""
L_EN["TooltipUnitZone"] = "Показывать текст зоны"
L_EN["TooltipUnitZoneDesc"] = ""
L_EN["TooltipUnitHealthbar"] = "Показывать полосу здоровья"
L_EN["TooltipUnitHealthbarDesc"] = ""
L_EN["TooltipUnitHealthbarText"] = "Показывать текст полосы здоровья"
L_EN["TooltipUnitHealthbarTextDesc"] = ""

-- Unitframes
L_EN["UnitFramesName"] = "Рамки юнитов"

-- Player
L_EN["PlayerFrameDesc"] = "Настройки рамки игрока"
L_EN["PlayerFrameStyle"] = L_EN["ButtonTableStyle"]
L_EN["PlayerFrameClassColor"] = "Цвет класса"
L_EN["PlayerFrameClassColorDesc"] = "Включить цвета классов для полосы здоровья"
L_EN["PlayerFrameClassIcon"] = "Портрет с иконкой класса"
L_EN["PlayerFrameClassIconDesc"] = "Включить иконку класса в качестве портрета (в настоящее время отключено)"
L_EN["PlayerFrameBreakUpLargeNumbers"] = "Разбивать большие числа"
L_EN["PlayerFrameBreakUpLargeNumbersDesc"] =
    "Включить разбивку больших чисел в статусном тексте (например, 7588 K вместо 7588000)"
L_EN["PlayerFrameBiggerHealthbar"] = "Увеличенная полоса здоровья"
L_EN["PlayerFrameBiggerHealthbarDesc"] = "Включить увеличенную полосу здоровья"
L_EN["PlayerFramePortraitExtra"] = "Дополнительный портрет"
L_EN["PlayerFramePortraitExtraDesc"] = "Показывает дракона элиты, редкого моба или мирового босса вокруг рамки игрока."
L_EN["PlayerFrameHideRedStatus"] = "Скрыть красное свечение в бою"
L_EN["PlayerFrameHideRedStatusDesc"] = "Скрыть красное свечение статуса в бою"
L_EN["PlayerFrameHideHitIndicator"] = "Скрыть индикатор попадания"
L_EN["PlayerFrameHideHitIndicatorDesc"] = "Скрыть индикатор попадания на рамке игрока"
L_EN["PlayerFrameHideSecondaryRes"] = "Скрыть вторичный ресурс"
L_EN["PlayerFrameHideSecondaryResDesc"] = "Скрыть вторичный ресурс, например, осколки души."
L_EN["PlayerFrameHideAlternatePowerBar"] = "Скрыть альтернативную полосу силы друида"
L_EN["PlayerFrameHideAlternatePowerBarDesc"] = "Скрыть альтернативную полосу силы друида (полосу маны в формах медведя/кошки)."

-- Target
L_EN["TargetFrameDesc"] = "Настройки рамки цели"
L_EN["TargetFrameStyle"] = L_EN["ButtonTableStyle"]
L_EN["TargetFrameClassColor"] = L_EN["PlayerFrameClassColor"]
L_EN["TargetFrameClassColorDesc"] = "Включить цвета классов для полосы здоровья"
L_EN["TargetFrameClassIcon"] = L_EN["PlayerFrameClassIcon"]
L_EN["TargetFrameClassIconDesc"] = L_EN["PlayerFrameClassIconDesc"]
L_EN["TargetFrameBreakUpLargeNumbers"] = L_EN["PlayerFrameBreakUpLargeNumbers"]
L_EN["TargetFrameBreakUpLargeNumbersDesc"] = L_EN["PlayerFrameBreakUpLargeNumbersDesc"]
L_EN["TargetFrameNumericThreat"] = "Числовой уровень угрозы"
L_EN["TargetFrameNumericThreatDesc"] = "Включить отображение числового уровня угрозы"
L_EN["TargetFrameNumericThreatAnchor"] = "Якорь числового уровня угрозы"
L_EN["TargetFrameNumericThreatAnchorDesc"] = "Устанавливает якорь (позицию) числового уровня угрозы"
L_EN["TargetFrameThreatGlow"] = "Свечение угрозы"
L_EN["TargetFrameThreatGlowDesc"] = "Включить эффект свечения угрозы"
L_EN["TargetFrameHideNameBackground"] = "Скрыть фон имени"
L_EN["TargetFrameHideNameBackgroundDesc"] = "Скрыть фон имени цели"
L_EN["TargetFrameComboPointsOnPlayerFrame"] = "Очки комбо на рамке игрока"
L_EN["TargetFrameComboPointsOnPlayerFrameDesc"] = "Показывать очки комбо на рамке игрока."
L_EN["TargetFrameHideComboPoints"] = "Скрыть очки комбо"
L_EN["TargetFrameHideComboPointsDesc"] = "Скрывает рамку очков комбо."
L_EN["TargetFrameFadeOut"] = "Затухание"
L_EN["TargetFrameFadeOutDesc"] = "Затухает рамка цели, если цель находится дальше, чем *Расстояние затухания*."
L_EN["TargetFrameFadeOutDistance"] = "Расстояние затухания"
L_EN["TargetFrameFadeOutDistanceDesc"] =
    "Устанавливает расстояние в ярдах для проверки эффекта затухания.\nПримечание: не каждое значение может иметь значение, так как используется 'LibRangeCheck-3.0'.\nРассчитывается по 'minRange >= fadeOutDistance'."

-- Pet
L_EN["PetFrameDesc"] = "Настройки рамки питомца"
L_EN["PetFrameStyle"] = L_EN["ButtonTableStyle"]
L_EN["PetFrameBreakUpLargeNumbers"] = L_EN["PlayerFrameBreakUpLargeNumbers"]
L_EN["PetFrameBreakUpLargeNumbersDesc"] = L_EN["PlayerFrameBreakUpLargeNumbersDesc"]
L_EN["PetFrameThreatGlow"] = L_EN["TargetFrameThreatGlow"]
L_EN["PetFrameThreatGlowDesc"] = L_EN["TargetFrameThreatGlowDesc"]
L_EN["PetFrameHideStatusbarText"] = "Скрыть текст статусной полосы"
L_EN["PetFrameHideStatusbarTextDesc"] = "Скрыть текст статусной полосы"
L_EN["PetFrameHideIndicator"] = "Скрыть индикатор попадания"
L_EN["PetFrameHideIndicatorDesc"] = "Скрыть индикатор попадания"

-- Focus
L_EN["FocusFrameDesc"] = "Настройки рамки фокуса"
L_EN["FocusFrameStyle"] = L_EN["ButtonTableStyle"]
L_EN["FocusFrameClassColor"] = L_EN["PlayerFrameClassColor"]
L_EN["FocusFrameClassColorDesc"] = "Включить цвета классов для полосы здоровья"
L_EN["FocusFrameClassIcon"] = L_EN["PlayerFrameClassIcon"]
L_EN["FocusFrameClassIconDesc"] = "Включить иконку класса в качестве портрета для рамки фокуса"
L_EN["FocusFrameBreakUpLargeNumbers"] = L_EN["PlayerFrameBreakUpLargeNumbers"]
L_EN["FocusFrameBreakUpLargeNumbersDesc"] = L_EN["PlayerFrameBreakUpLargeNumbersDesc"]
L_EN["FocusFrameHideNameBackground"] = L_EN["TargetFrameHideNameBackground"]
L_EN["FocusFrameHideNameBackgroundDesc"] = "Скрыть фон имени"

-- party
L_EN["PartyFrameDesc"] = "Настройки рамки группы"
L_EN["PartyFrameStyle"] = L_EN["ButtonTableStyle"]
L_EN["PartyFrameClassColor"] = L_EN["PlayerFrameClassColor"]
L_EN["PartyFrameClassColorDesc"] = "Включить цвета классов для полосы здоровья"
L_EN["PartyFrameBreakUpLargeNumbers"] = L_EN["PlayerFrameBreakUpLargeNumbers"]
L_EN["PartyFrameBreakUpLargeNumbersDesc"] = L_EN["PlayerFrameBreakUpLargeNumbersDesc"]

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

for k, v in pairs(L) do L_RU[k] = v; end
