-- print('ruRU')  - Translator ZamestoTV
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L_RU = LibStub("AceLocale-3.0"):NewLocale("DragonflightUI", "ruRU")
if not L_RU then return end

-- preprocess to reuse strings - without this L[XY] = L['X'] will fail in AceLocale
local L = {}

-- modules - config.lua
do
    L["ModuleModules"] = "Модули"

    L["ModuleTooltipActionbar"] =
        "Этот модуль перерабатывает стандартную панель действий, включая микроменю и кнопки сумок.\nДобавляет отдельные настройки для панелей действий 1-8, панели питомца, опыта, репутации, владения, стойки и тотемов, сумок и микроменю."
    L["ModuleTooltipBossframe"] = "Этот модуль добавляет пользовательские рамки боссов.\nРАБОТА В ПРОЦЕССЕ."
    L["ModuleTooltipBuffs"] = "Этот модуль изменяет стандартную рамку баффов.\nДобавляет отдельные настройки для баффов и дебаффов."
    L["ModuleTooltipCastbar"] =
        "Этот модуль изменяет стандартную полосу заклинаний.\nДобавляет отдельные настройки для полос заклинаний игрока, фокуса и цели."
    L["ModuleTooltipChat"] = "Этот модуль изменяет стандартное окно чата.\nРАБОТА В ПРОЦЕССЕ."
    L["ModuleTooltipCompatibility"] = "Этот модуль добавляет дополнительную совместимость с другими аддонами."
    L["ModuleTooltipDarkmode"] =
        "Этот модуль добавляет темный режим для нескольких рамок DragonflightUI.\nРАБОТА В ПРОЦЕССЕ - пожалуйста, оставьте отзывы!"
    L["ModuleTooltipFlyout"] = "Выпадающее меню"
    L["ModuleTooltipMinimap"] =
        "Этот модуль перерабатывает стандартную миникарту и трекер заданий.\nДобавляет отдельные настройки для миникарты и трекера заданий."
    L["ModuleTooltipTooltip"] = "Этот модуль улучшает игровые подсказки.\nРАБОТА В ПРОЦЕССЕ"
    L["ModuleTooltipUI"] =
        "Этот модуль добавляет современный стиль интерфейса для различных окон, таких как окно персонажа. Также добавляет переработки, специфичные для эпохи, с новым спеллбуком, окном талантов или окном профессий."
    L["ModuleTooltipUnitframe"] =
        "Этот модуль перерабатывает стандартные рамки юнитов и добавляет новые функции, такие как классовые цвета или здоровье мобов (Эра).\nДобавляет отдельные настройки для рамок игрока, питомца, цели, фокуса и группы."
    L["ModuleTooltipUtility"] = "Этот модуль добавляет общие функции и настройки интерфейса.\nРАБОТА В ПРОЦЕССЕ"

    L["ModuleFlyout"] = "Выпадающее меню"
    L["ModuleActionbar"] = "Панель действий"
    L["ModuleCastbar"] = "Полоса заклинаний"
    L["ModuleChat"] = "Чат"
    L["ModuleBuffs"] = "Баффы"
    L["ModuleDarkmode"] = "Темный режим"
    L["ModuleMinimap"] = "Миникарта"
    L["ModuleTooltip"] = "Подсказка"
    L["ModuleUI"] = "Интерфейс"
    L["ModuleUnitframe"] = "Рамки юнитов"
    L["ModuleUtility"] = "Утилиты"
    L["ModuleCompatibility"] = "Совместимость"
    L["ModuleBossframe"] = "Рамка босса"

    L["ModuleAlreadyLoadedWasDeactivated"] = "Уже загруженный модуль был деактивирован, пожалуйста, выполните '/reload'!"
    L["ModuleAlreadyLoadedWasDeactivatedMultiple"] =
        "Несколько уже загруженных модулей были деактивированы, пожалуйста, выполните '/reload'!"
end

-- config 
do
    L["ConfigGeneralWhatsNew"] = "Что нового"
    L["ConfigGeneralModules"] = "Модули"
    L["ConfigGeneralInfo"] = "Информация"
    L["MainMenuDragonflightUI"] = "DragonflightUI"
    L["MainMenuEditmode"] = "Режим редактирования"

    -- config.mixin.lua
    L["ConfigMixinQuickKeybindMode"] = "Режим быстрой привязки клавиш"
    L["ConfigMixinGeneral"] = "Общие"
    L["ConfigMixinModules"] = "Модули"
    L["ConfigMixinActionBar"] = "Панель действий"
    L["ConfigMixinCastBar"] = "Полоса заклинаний"
    L["ConfigMixinMisc"] = "Разное"
    L["ConfigMixinUnitframes"] = "Рамки юнитов"

    -- modules.mixin.lua
    L["ModuleConditionalMessage"] =
        "'|cff8080ff%s|r' был деактивирован, но соответствующая функция уже была зацеплена, пожалуйста, выполните '|cff8080ff/reload|r'!"

    -- config
    L["ConfigToolbarCopyPopup"] = "Скопируйте ссылку ниже (Ctrl+C, Enter):"
    L["ConfigToolbarDiscord"] = "Discord"
    L["ConfigToolbarDiscordTooltip"] = "Предлагайте идеи и получайте поддержку."
    L["ConfigToolbarGithub"] = "Github"
    L["ConfigToolbarGithubTooltip"] = "Просматривайте код, сообщайте о проблемах и вносите вклад."
    L["ConfigToolbarCoffee"] = "BuyMeACoffee"
    L["ConfigToolbarCoffeeTooltip1"] =
        "Каждый комментарий, лайк или репост имеет значение, но если вы чувствуете себя очень добрым, вы можете угостить меня куском пиццы для дальнейшей разработки!"
    L["ConfigToolbarCoffeeTooltip2"] =
        "Поддерживающие получают эксклюзивные привилегии, узнайте о них в разделе для спонсоров на нашем Discord."
end

-- profiles
do
    L["ProfilesSetActiveProfile"] = "Установить активный профиль."
    L["ProfilesNewProfile"] = "Создать новый профиль."
    L["ProfilesCopyFrom"] = "Скопировать настройки из одного существующего профиля в текущий активный профиль."
    L["ProfilesOpenCopyDialogue"] = "Открывает диалог копирования."
    L["ProfilesDeleteProfile"] = "Удалить существующий профиль из базы данных."
    L["Profiles"] = "Добавить новый профиль"
    L["ProfilesOpenDeleteDialogue"] = "Открывает диалог удаления."
    L["ProfilesAddNewProfile"] = "Добавить новый профиль"
    L["ProfilesChatNewProfile"] = "новый профиль: "
    L["ProfilesErrorNewProfile"] = "ОШИБКА: Имя нового профиля не может быть пустым!"
    L["ProfilesDialogueDeleteProfile"] = "Удалить профиль \'%s\'?"
    L["ProfilesDialogueCopyProfile"] = "Добавить новый профиль (скопировать из \'|cff8080ff%s|r\')"
    L["ProfilesImportShareHeader"] = "Импорт/Поделиться"
    L["ProfilesImportProfile"] = "Импортировать профиль"
    L["ProfilesImportProfileButton"] = HUD_EDIT_MODE_IMPORT_LAYOUT or "Импорт"
    L["ProfilesImportProfileDesc"] = "Открывает диалог импорта."
    L["ProfilesExportProfile"] = "Поделиться профилем"
    L["ProfilesExportProfileButton"] = HUD_EDIT_MODE_SHARE_LAYOUT or "Поделиться"
    L["ProfilesExportProfileDesc"] = "Открывает диалог分享."
end

-- Editmode
do
    L["EditModeBasicOptions"] = "Основные настройки"
    L["EditModeAdvancedOptions"] = "Расширенные настройки"
    L["EditModeLayoutDropdown"] = "Профиль"
    L["EditModeCopyLayout"] = "Копировать профиль"
    L["EditModeRenameLayout"] = ""
    L["EditModeRenameOrCopyLayout"] = "Переименовать/Копировать профиль"
    L["EditModeDeleteLayout"] = "Удалить профиль"
    L["EditModeNewLayoutDisabled"] = "%s Новый профиль"
    L["EditModeNewLayout"] = "%s |cnPURE_GREEN_COLOR:Новый профиль|r"
    L["EditModeImportLayout"] = HUD_EDIT_MODE_IMPORT_LAYOUT or "Импорт"
    L["EditModeShareLayout"] = HUD_EDIT_MODE_SHARE_LAYOUT or "Поделиться"
    L["EditModeCopyToClipboard"] = HUD_EDIT_MODE_COPY_TO_CLIPBOARD or "Скопировать в буфер обмена |cffffd100(для分享 в интернете)|r"
    L["EditModeExportProfile"] = "Экспортировать профиль |cff8080ff%s|r"
    L["EditModeImportProfile"] = "Импортировать профиль как |cff8080ff%s|r"
    L["EditModeVisible"] = "Видимость в режиме редактирования"
    L["EditModeVisibleDescFormat"] =
        "Устанавливает видимость текущей рамки и всех других рамок той же категории (|cff8080ff%s|r), пока активен режим редактирования." ..
            "\n\nВы всегда можете настроить это через |cff8080ffРасширенные настройки|r в главном окне режима редактирования или в окне настроек DragonflightUI |cff8080ffConfig Window|r."
end

-- Compat
do
    L['CompatName'] = "Совместимость"
    L['CompatAuctionator'] = "Auctionator"
    L['CompatAuctionatorDesc'] =
        "Добавляет совместимость с Auctionator при использовании модуля интерфейса с включенной опцией 'Изменить окно профессий'."
    L['CompatBaganator'] = "Baganator_Skin"
    L['CompatBaganatorDesc'] = "Изменяет стандартную тему 'Blizzard' на стилизованную под DragonflightUI."
    L['CompatBaganatorEquipment'] = "Baganator_EquipmentSets"
    L['CompatBaganatorEquipmentDesc'] = "Добавляет поддержку наборов экипировки как источника предметов."
    L['CompatBisTracker'] = "BISTracker"
    L['CompatBisTrackerDesc'] =
        "Добавляет совместимость с BISTracker при использовании модуля интерфейса с включенной опцией 'Изменить окно персонажа'."
    L['CompatCharacterStatsClassic'] = "CharacterStatsClassic"
    L['CompatCharacterStatsClassicDesc'] =
        "Добавляет совместимость с CharacterStatsClassic при использовании модуля интерфейса с включенной опцией 'Изменить окно персонажа'."
    L['CompatClassicCalendar'] = "Classic Calendar"
    L['CompatClassicCalendarDesc'] = "Добавляет совместимость с Classic Calendar"
    L['CompatClique'] = "Clique"
    L['CompatCliqueDesc'] = "Добавляет совместимость с Clique"
    L['CompatLeatrixPlus'] = "LeatrixPlus"
    L['CompatLeatrixPlusDesc'] =
        "Добавляет совместимость с LeatrixPlus, например, убирает уродливый фон названия класса на рамке игрока."
    L['CompatLFGBulletinBoard'] = "LFG Bulletin Board"
    L['CompatLFGBulletinBoardDesc'] = "Добавляет совместимость с LFG Bulletin Board"
    L['CompatMerInspect'] = "MerInspect"
    L['CompatMerInspectDesc'] =
        "Добавляет совместимость с MerInspect при использовании модуля интерфейса с включенной опцией 'Изменить окно персонажа'."
    L['CompatPawn'] = "Pawn"
    L['CompatPawnDesc'] = "Добавляет совместимость с Pawn при использовании модуля интерфейса с включенной опцией 'Изменить окно персонажа'."
    L['CompatRanker'] = "Ranker"
    L['CompatRankerDesc'] =
        "Добавляет совместимость с Ranker при использовании модуля интерфейса с включенной опцией 'Изменить окно персонажа'."
    L['CompatTacoTip'] = "TacoTip"
    L['CompatTacoTipDesc'] =
        "Добавляет совместимость с TacoTip при использовании модуля интерфейса с включенной опцией 'Изменить окно персонажа'."
    L['CompatTDInspect'] = "TDInspect"
    L['CompatTDInspectDesc'] =
        "Добавляет совместимость с TDInspect при использовании модуля интерфейса с включенной опцией 'Изменить окно персонажа'."
    L['CompatWhatsTraining'] = "WhatsTraining"
    L['CompatWhatsTrainingDesc'] =
        "Добавляет совместимость с WhatsTraining при использовании модуля интерфейса с включенной опцией 'Изменить спеллбук'."
end

-- __Settings
do
    L["SettingsDefaultStringFormat"] = "\n(По умолчанию: |cff8080ff%s|r)"
    L["SettingsCharacterSpecific"] = "\n\n|cff8080ff[Настройка для персонажа]|r"

    -- positionTable
    L["PositionTableHeader"] = "Масштаб и положение"
    L["PositionTableHeaderDesc"] = ""
    L["PositionTableScale"] = "Масштаб"
    L["PositionTableScaleDesc"] = ""
    L["PositionTableAnchor"] = "Якорь"
    L["PositionTableAnchorDesc"] = "Якорь"
    L["PositionTableAnchorParent"] = "Родительский якорь"
    L["PositionTableAnchorParentDesc"] = ""
    L["PositionTableAnchorFrame"] = "Рамка-якорь"
    L["PositionTableAnchorFrameDesc"] = ""
    L["PositionTableCustomAnchorFrame"] = "Рамка-якорь (пользовательская)"
    L["PositionTableCustomAnchorFrameDesc"] =
        "Использовать эту именованную рамку как якорь (если она действительна). Например, 'CharacterFrame', 'TargetFrame'..."
    L["PositionTableX"] = "X"
    L["PositionTableXDesc"] = ""
    L["PositionTableY"] = "Y"
    L["PositionTableYDesc"] = ""
end

-- darkmode
do
    L["DarkmodeColor"] = "Цвет"
    L["DarkmodeDesaturate"] = "Обесцвечивание"
end

-- actionbar
do
    L["ActionbarName"] = "Панель действий"
    L["ActionbarNameFormat"] = "Панель действий %d"

    -- bar names
    L["XPBar"] = "Полоса опыта"
    L["ReputationBar"] = "Полоса репутации"
    L["PetBar"] = "Полоса питомца"
    L["StanceBar"] = "Полоса стоек"
    L["PossessBar"] = "Полоса владения"
    L["MicroMenu"] = "Микроменю"
    L["TotemBar"] = "Полоса тотемов"

    -- gryphonsTable
    L["Default"] = "По умолчанию"
    L["Alliance"] = "Альянс"
    L["Horde"] = "Орда"
    L["None"] = "Нет"

    -- stateDriverTable
    L["ActionbarDriverDefault"] = "По умолчанию"
    L["ActionbarDriverSmart"] = "Умная"
    L["ActionbarDriverNoPaging"] = "Без перелистывания"

    -- stateDriver
    L['ActionbarDriverName'] = "Перелистывание"
    L['ActionbarDriverNameDesc'] =
        "Изменяет поведение перелистывания главной панели действий, например, при смене стойки или скрытности.\n'По умолчанию' - без изменений\n'Умная' - добавляет пользовательскую страницу для скрытности кошачьей формы друида\n'Без перелистывания' - отключает все перелистывания"

    -- targetStateDriver
    L["ActionbarTargetDriverConditionalFormat"] = "\n\n(Это эквивалентно условной макрокоманде: |cff8080ff%s|r)\n"
    L["ActionbarTargetDriverMultipleConditionalFormat"] =
        "\n\n(Это эквивалентно следующим условным макрокомам (в зависимости от |cffffffffтипа|r заклинания): %s)\n"

    local function cond(str)
        return string.format(L["ActionbarTargetDriverConditionalFormat"], str)
    end

    local function condMultiple(t)
        local str = '';

        for k, v in ipairs(t) do
            --
            str = string.format('%s%s', str, string.format('\n(|cffffffff%s|r) |cff8080ff%s|r', v.type, v.str))
        end

        return string.format(L["ActionbarTargetDriverMultipleConditionalFormat"], str)
    end

    L['ActionbarTargetDriverHeader'] = "Выбор цели"
    L['ActionbarTargetDriverUseMouseover'] = "Использовать наведение мыши"
    L['ActionbarTargetDriverUseMouseoverDesc'] =
        "Когда включено, кнопки действий пытаются выбрать юнит под курсором мыши." .. condMultiple({
            {type = 'help', str = '[@mouseover, exists, help, mod:XY]'},
            {type = 'harm', str = '[@mouseover, nodead, exists, harm, mod:XY]'},
            {type = 'both', str = '[@mouseover, nodead, exists, mod:XY]'}
        })
    L['ActionbarTargetDriverMouseOverModifier'] = "Клавиша для наведения мыши"
    L['ActionbarTargetDriverMouseOverModifierDesc'] =
        "При удержании этой клавиши заклинания будут применяться к цели под курсором мыши, даже если выбрана другая цель."
    L['ActionbarTargetDriverUseAutoAssist'] = "Использовать авто-помощь"
    L['ActionbarTargetDriverUseAutoAssistDesc'] =
        "Когда включено, кнопки действий автоматически применяют заклинания к цели вашей цели, если текущая цель недействительна для выбранного заклинания." ..
            condMultiple({
                {type = 'help', str = '[help]target; [@targettarget, help]targettarget'},
                {type = 'harm', str = '[harm]target; [@targettarget, harm]targettarget'}
            })
    L['ActionbarTargetDriverFocusCast'] = "Применение к фокусу"
    L['ActionbarTargetDriverFocusCastDesc'] =
        "Когда включено (и установлена 'Клавиша применения к фокусу'), кнопки действий пытаются выбрать цель фокуса." ..
            cond('[mod:FOCUSCAST, @focus, exists, nodead]')
    L['ActionbarTargetDriverFocusCastModifier'] = FOCUS_CAST_KEY_TEXT or "Клавиша применения к фокусу"
    L['ActionbarTargetDriverFocusCastModifierDesc'] =
        "При удержании этой клавиши заклинания будут применяться к цели фокуса, даже если выбрана другая цель."
    L['ActionbarTargetDriverSelfCast'] = (SELF_CAST or "Самоприменение")
    L['ActionbarTargetDriverSelfCastDesc'] = (OPTION_TOOLTIP_AUTO_SELF_CAST or "") .. cond('[mod: SELFCAST]')
    L['ActionbarTargetDriverSelfCastModifier'] = AUTO_SELF_CAST_KEY_TEXT or "Клавиша самоприменения"
    L['ActionbarTargetDriverSelfCastModifierDesc'] = OPTION_TOOLTIP_AUTO_SELF_CAST_KEY_TEXT or ""

    -- buttonTable
    L["ButtonTableActive"] = "Активно"
    L["ButtonTableActiveDesc"] = ""
    L["ButtonTableButtons"] = "Кнопки"
    L["ButtonTableButtonsDesc"] = ""
    L["ButtonTableButtonScale"] = "Масштаб кнопок"
    L["ButtonTableButtonScaleDesc"] = ""
    L["ButtonTableOrientation"] = "Ориентация"
    L["ButtonTableOrientationDesc"] = "Ориентация"
    L["ButtonTableGrowthDirection"] = "Направление роста"
    L["ButtonTableGrowthDirectionDesc"] =
        "Устанавливает направление, в котором панель 'растет' при использовании нескольких строк/столбцов."
    L["ButtonTableFlyoutDirection"] = "Направление выпадающего меню"
    L["ButtonTableFlyoutDirectionDesc"] = "Устанавливает направление выпадающего меню заклинаний."
    L["ButtonTableReverseButtonOrder"] = "Обратный порядок кнопок"
    L["ButtonTableReverseButtonOrderDesc"] = ""
    L["ButtonTableNumRows"] = "Количество строк"
    L["ButtonTableNumRowsDesc"] = ""
    L["ButtonTableNumButtons"] = "Количество кнопок"
    L["ButtonTableNumButtonsDesc"] = ""
    L["ButtonTablePadding"] = "Отступ"
    L["ButtonTablePaddingDesc"] = ""
    L["ButtonTableStyle"] = "Стиль"
    L["ButtonTableStyleDesc"] = ""
    L["ButtonTableAlwaysShowActionbar"] = "Всегда показывать панель действий"
    L["ButtonTableAlwaysShowActionbarDesc"] = ""
    L["ButtonTableHideMacroText"] = "Скрыть текст макроса"
    L["ButtonTableHideMacroTextDesc"] = ""
    L["ButtonTableMacroNameFontSize"] = "Размер шрифта названия макроса"
    L["ButtonTableMacroNameFontSizeDesc"] = ""
    L["ButtonTableHideKeybindText"] = "Скрыть текст привязки клавиш"
    L["ButtonTableHideKeybindTextDesc"] = ""
    L["ButtonTableShortenKeybindText"] = "Сократить текст привязки клавиш"
    L["ButtonTableShortenKeybindTextDesc"] =
        "Сокращает текст привязки клавиш, например, 'sF' вместо 's-F' и аналогичные замены."
    L["ButtonTableKeybindFontSize"] = "Размер шрифта привязки клавиш"
    L["ButtonTableKeybindFontSizeDesc"] = ""

    L["MoreOptionsHideBarArt"] = "Скрыть оформление панели"
    L["MoreOptionsHideBarArtDesc"] = ""
    L["MoreOptionsHideBarScrolling"] = "Скрыть прокрутку панели"
    L["MoreOptionsHideBarScrollingDesc"] = ""
    L["MoreOptionsHideBorder"] = "Скрыть оформление границы"
    L["MoreOptionsHideBorderDesc"] = "*Работа в процессе*"
    L["MoreOptionsHideDivider"] = "Скрыть разделитель панели"
    L["MoreOptionsHideDividerDesc"] = ""

    L["MoreOptionsGryphons"] = "Грифоны"
    L["MoreOptionsGryphonsDesc"] = "Грифоны"
    L["MoreOptionsUseKeyDown"] = ACTION_BUTTON_USE_KEY_DOWN or "Использовать нажатие клавиши"
    L["MoreOptionsUseKeyDownDesc"] = OPTION_TOOLTIP_ACTION_BUTTON_USE_KEY_DOWN or "Активирует способности при нажатии клавиши."
    L["MoreOptionsIconRangeColor"] = "Цвет иконки вне досягаемости"
    L["MoreOptionsIconRangeColorDesc"] = "Изменяет цвет иконки, когда цель вне досягаемости, аналогично RedRange/tullaRange." ..
                                             "\nДля настроек см. категорию настроек 'Диапазон панели действий'."

    L["ExtraOptionsPreset"] = "Пресет"
    L["ExtraOptionsResetToDefaultPosition"] = "Сбросить на стандартное положение"
    L["ExtraOptionsPresetDesc"] =
        "Устанавливает масштаб, якорь, родительский якорь, рамку-якорь, X и Y в соответствии с выбранным пресетом, но не изменяет другие настройки."
    L["ExtraOptionsModernLayout"] = "Современный макет (по умолчанию)"
    L["ExtraOptionsModernLayoutDesc"] = ""
    L["ExtraOptionsClassicLayout"] = "Классический макет (боковая панель)"
    L["ExtraOptionsClassicLayoutDesc"] = ""

    -- Range
    L["ActionbarRangeName"] = "Диапазон панели действий"
    L["ActionbarRangeNameDesc"] = ""

    L["ActionbarRangeHeader"] = "Настройки диапазона"
    L["ActionbarRangeHeaderDesc"] = ""

    L["ActionbarRangeHeaderHotkey"] = "Привязка клавиш"
    L["ActionbarRangeHeaderHotkeyDesc"] = ""
    L["ActionbarRangeHotkeyColor"] = "Обычный"
    L["ActionbarRangeHotkeyColorDesc"] = "Обычный цвет шрифта привязки клавиш."
    L["ActionbarRangeHotkeyOutOfRangeColor"] = "Вне досягаемости"
    L["ActionbarRangeHotkeyOutOfRangeColorDesc"] = "Цвет шрифта привязки клавиш, когда цель вне досягаемости."

    L["ActionbarRangeHeaderNotUsable"] = "Недоступно"
    L["ActionbarRangeHeaderNotUsableDesc"] = ""
    L["ActionbarRangeHeaderOutOfRange"] = "Вне досягаемости"
    L["ActionbarRangeHeaderOutOfRangeDesc"] = ""
    L["ActionbarRangeHeaderOutOfMana"] = "Недостаточно маны"
    L["ActionbarRangeHeaderOutOfManaDesc"] = ""

    -- XP
    L["XPOptionsName"] = "Полоса опыта"
    L["XPOptionsDesc"] = "Опыт"
    L["XPOptionsStyle"] = L["ButtonTableStyle"]
    L["XPOptionsStyleDesc"] = ""
    L["XPOptionsWidth"] = "Ширина"
    L["XPOptionsWidthDesc"] = ""
    L["XPOptionsHeight"] = "Высота"
    L["XPOptionsHeightDesc"] = ""
    L["XPOptionsAlwaysShowXPText"] = "Всегда показывать текст опыта"
    L["XPOptionsAlwaysShowXPTextDesc"] = ""
    L["XPOptionsShowXPPercent"] = "Показывать процент опыта"
    L["XPOptionsShowXPPercentDesc"] = ""

    -- rep
    L["RepOptionsName"] = "Полоса репутации"
    L["RepOptionsDesc"] = "Репутация"
    L["RepOptionsStyle"] = L["ButtonTableStyle"]
    L["RepOptionsStyleDesc"] = ""
    L["RepOptionsWidth"] = L["XPOptionsWidth"]
    L["RepOptionsWidthDesc"] = L["XPOptionsWidthDesc"]
    L["RepOptionsHeight"] = L["XPOptionsHeight"]
    L["RepOptionsHeightDesc"] = L["XPOptionsHeightDesc"]
    L["RepOptionsAlwaysShowRepText"] = "Всегда показывать текст репутации"
    L["RepOptionsAlwaysShowRepTextDesc"] = ""

    -- Bags
    L["BagsOptionsName"] = "Сумки"
    L["BagsOptionsDesc"] = "Сумки"
    L["BagsOptionsStyle"] = L["ButtonTableStyle"]
    L["BagsOptionsStyleDesc"] = ""
    L["BagsOptionsExpanded"] = "Развернуто"
    L["BagsOptionsExpandedDesc"] = ""
    L["BagsOptionsHideArrow"] = "Скрыть стрелку"
    L["BagsOptionsHideArrowDesc"] = ""
    L["BagsOptionsHidden"] = "Скрыто"
    L["BagsOptionsHiddenDesc"] = "Рюкзак скрыт"
    L["BagsOptionsOverrideBagAnchor"] = "Переопределить якорь сумок"
    L["BagsOptionsOverrideBagAnchorDesc"] = ""
    L["BagsOptionsOffsetX"] = "Смещение X якоря сумок"
    L["BagsOptionsOffsetXDesc"] = ""
    L["BagsOptionsOffsetY"] = "Смещение Y якоря сумок"
    L["BagsOptionsOffsetYDesc"] = ""

    -- FPS
    L["FPSOptionsName"] = "FPS"
    L["FPSOptionsDesc"] = "FPS"
    L["FPSOptionsStyle"] = L["ButtonTableStyle"]
    L["FPSOptionsStyleDesc"] = ""
    L["FPSOptionsHideDefaultFPS"] = "Скрыть стандартный FPS"
    L["FPSOptionsHideDefaultFPSDesc"] = "Скрыть стандартный текст FPS"
    L["FPSOptionsShowFPS"] = "Показать FPS"
    L["FPSOptionsShowFPSDesc"] = "Показать пользовательский текст FPS"
    L["FPSOptionsAlwaysShowFPS"] = "Всегда показывать FPS"
    L["FPSOptionsAlwaysShowFPSDesc"] = "Всегда показывать пользовательский текст FPS"
    L["FPSOptionsShowPing"] = "Показать пинг"
    L["FPSOptionsShowPingDesc"] = "Показать пинг в миллисекундах"

    -- Extra Action Button
    L["ExtraActionButtonOptionsName"] = "Дополнительная кнопка действия"
    L["ExtraActionButtonOptionsNameDesc"] = "FPS"
    L["ExtraActionButtonStyle"] = L["ButtonTableStyle"]
    L["ExtraActionButtonStyleDesc"] = ""
    L["ExtraActionButtonHideBackgroundTexture"] = "Скрыть фоновую текстуру"
    L["ExtraActionButtonHideBackgroundTextureDesc"] = ""

    -- Roll
    L["GroupLootContainerName"] = "Контейнер группового лута"
    L["GroupLootContainerDesc"] = ""

    -- widget below
    L["WidgetBelowName"] = "Виджет под миникартой"
    L["WidgetBelowNameDesc"] = ""

    -- widget below
    L["VehicleLeaveButton"] = "Кнопка выхода из транспорта"
    L["VehicleLeaveButtonDesc"] = ""
end

-- Buffs
do
    L["BuffsOptionsName"] = "Баффы"
    L["DebuffsOptionsName"] = "Дебаффы"
    L["BuffsOptionsStyle"] = L["ButtonTableStyle"]
    L["BuffsOptionsStyleDesc"] = ""

    L["BuffsOptionsExpanded"] = "Развернуто"
    L["BuffsOptionsExpandedDesc"] = ""

    L["BuffsOptionsUseStateHandler"] = "Использовать обработчик состояния"
    L["BuffsOptionsUseStateHandlerDesc"] =
        "Без этого настройки видимости выше не будут работать, но это может улучшить совместимость с другими аддонами (например, для MinimapAlert), так как не делает рамки защищенными."
end

-- Flyout
do
    L["FlyoutHeader"] = "Выпадающее меню"
    L["FlyoutHeaderDesc"] = ""
    L["FlyoutDirection"] = "Направление выпадающего меню"
    L["FlyoutDirectionDesc"] = "Направление выпадающего меню"
    L["FlyoutSpells"] = "Заклинания"
    L["FlyoutSpellsDesc"] = "Вставьте ID заклинаний через запятую, например, '688, 697'."
    L["FlyoutSpellsAlliance"] = "Заклинания (Альянс)"
    L["FlyoutSpellsAllianceDesc"] = L["FlyoutSpellsDesc"] .. "\n(Используется только на стороне Альянса.)"
    L["FlyoutSpellsHorde"] = "Заклинания (Орда)"
    L["FlyoutSpellsHordeDesc"] = L["FlyoutSpellsDesc"] .. "\n(Используется только на стороне Орды.)"
    L["FlyoutItems"] = "Предметы"
    L["FlyoutItemsDesc"] = "Вставьте ID предметов через запятую, например, '6948, 8490'."
    L["FlyoutCloseAfterClick"] = "Закрывать после клика"
    L["FlyoutCloseAfterClickDesc"] = "Закрывать выпадающее меню после нажатия одной из его кнопок."
    L["FlyoutAlwaysShow"] = "Всегда показывать кнопки"
    L["FlyoutAlwaysShowDesc"] =
        "Всегда показывает (под)кнопки, даже если они пусты.\nИспользуйте это, если хотите использовать перетаскивание."
    L["FlyoutIcon"] = "Иконка"
    L["FlyoutIconDesc"] = "Вставьте ID файла или путь к текстуре."
    L["FlyoutDisplayname"] = "Отображаемое имя"
    L["FlyoutDisplaynameDesc"] = ""
    L["FlyoutTooltip"] = "Подсказка"
    L["FlyoutTooltipDesc"] = ""

    L["FlyoutButtonWarlock"] = "Выпадающее меню призыва чернокнижника"
    L["FlyoutButtonMagePort"] = "Выпадающее меню телепорта"
    L["FlyoutButtonMagePortals"] = "Выпадающее меню порталов"
    L["FlyoutButtonMageFood"] = "Выпадающее меню создания еды"
    L["FlyoutButtonMageWater"] = "Выпадающее меню создания воды"
    L["FlyoutWarlock"] = "Призыв демона"
    L["FlyoutWarlockDesc"] = "Призывает одного из ваших демонов к вам."
    L["FlyoutMagePort"] = "Телепорт"
    L["FlyoutMagePortDesc"] = "Телепортирует вас в крупный город."
    L["FlyoutMagePortals"] = "Портал"
    L["FlyoutMagePortalsDesc"] = "Создает портал, телепортирующий членов группы, которые его используют, в крупный город."
    L["FlyoutMageWater"] = "Создать воду"
    L["FlyoutMageWaterDesc"] = "Созданные предметы исчезают, если выйти из игры более чем на 15 минут."
    L["FlyoutMageFood"] = "Создать еду"
    L["FlyoutMageFoodDesc"] = L["FlyoutMageWaterDesc"]

    L["FlyoutButtonCustomFormat"] = "Пользовательское выпадающее меню %d"
    L["FlyoutCustomNameFormat"] = "Пользовательское выпадающее меню %d"
    L["FlyoutCustomNameDescFormat"] = "Персональное выпадающее меню для персонажа с до 12 дополнительными кнопками действий."

    L["FlyoutHeaderClassPresets"] = "Пресеты классов"
    L["FlyoutHeaderClassPresetsDesc"] =
        "Устанавливает настройки выпадающего меню и кнопки выпадающего меню в соответствии с пресетом, специфичным для персонажа."
end

-- Castbar
do
    L["CastbarName"] = "Полоса заклинаний"
    L["CastbarNameFormat"] = "Полоса заклинаний %s"
    L["CastbarNamePlayer"] = format(L["CastbarNameFormat"], 'Игрок')
    L["CastbarNameTarget"] = format(L["CastbarNameFormat"], 'Цель')
    L["CastbarNameFocus"] = format(L["CastbarNameFormat"], 'Фокус')
    L["CastbarTableActive"] = "Активно"
    L["CastbarTableActivateDesc"] = ""
    L["CastbarTableStyle"] = L["ButtonTableStyle"]
    L["CastbarTableStyleDesc"] = ""
    L["CastbarTableWidth"] = L["XPOptionsWidth"]
    L["CastbarTableWidthDesc"] = L["XPOptionsWidthDesc"]
    L["CastbarTableHeight"] = L["XPOptionsHeight"]
    L["CastbarTableHeightDesc"] = L["XPOptionsHeightDesc"]
    L["CastbarTablePrecisionTimeLeft"] = "Точность (оставшееся время)"
    L["CastbarTablePrecisionTimeLeftDesc"] = ""
    L["CastbarTablePrecisionTimeMax"] = "Точность (максимальное время)"
    L["CastbarTablePrecisionTimeMaxDesc"] = ""
    L["CastbarTableShowCastTimeText"] = "Показывать текст времени каста"
    L["CastbarTableShowCastTimeTextDesc"] = ""
    L["CastbarTableShowCastTimeMaxText"] = "Показывать текст максимального времени каста"
    L["CastbarTableShowCastTimeMaxTextDesc"] = ""
    L["CastbarTableCompactLayout"] = "Компактный макет"
    L["CastbarTableCompactLayoutDesc"] = ""
    L["CastbarTableHoldTimeSuccess"] = "Время задержки (успех)"
    L["CastbarTableHoldTimeSuccessDesc"] = "Время до начала затухания полосы заклинаний после успешного каста."
    L["CastbarTableHoldTimeInterrupt"] = "Время задержки (прерывание)"
    L["CastbarTableHoldTimeInterruptDesc"] = "Время до начала затухания полосы заклинаний после прерывания каста."
    L["CastbarTableShowIcon"] = "Показывать иконку"
    L["CastbarTableShowIconDesc"] = ""
    L["CastbarTableIconSize"] = "Размер иконки"
    L["CastbarTableIconSizeDesc"] = ""
    L["CastbarTableShowTicks"] = "Показывать тики"
    L["CastbarTableShowTicksDesc"] = ""
    L["CastbarTableShowRank"] = "Показывать ранг"
    L["CastbarTableShowRankDesc"] = ""
    L["CastbarTableShowChannelName"] = "Показывать название канала"
    L["CastbarTableShowChannelNameDesc"] = "Показывает название заклинания вместо текста отображения (например, 'Канал')."

    L["ExtraOptionsResetToDefaultStyle"] = "Сбросить на стандартный стиль"
    L["ExtraOptionsPresetStyleDesc"] =
        "Сбрасывает все настройки, изменяющие стиль полосы заклинаний, но не изменяет другие настройки."

    L["CastbarTableAutoAdjustHeader"] = "Автонастройка"
    L["CastbarTableAutoAdjustHeaderDesc"] = ""
    L["CastbarTableAutoAdjust"] = "Автонастройка"
    L["CastbarTableAutoAdjustDesc"] =
        "Исправляет положение полосы заклинаний в зависимости от количества баффов/дебаффов - полезно при привязке полосы заклинаний под рамкой цели/фокуса." ..
            "\n\nРаботает только если опция включена *и* родитель является родителем по умолчанию, например, TargetFrame для полосы заклинаний цели."

    local info =
        string.format("\n\nАвтонастройка использует:\n%s", "SetPoint('TOPLEFT', parent, 'BOTTOMLEFT', dx, autoDy + dy)")
    L["CastbarTableAutoAdjustX"] = "Авто Delta X"
    L["CastbarTableAutoAdjustXDesc"] = "Delta X, применяемая к значению X, рассчитанному с помощью автонастройки." .. info
    L["CastbarTableAutoAdjustY"] = "Авто Delta Y"
    L["CastbarTableAutoAdjustYDesc"] = "Delta Y, применяемая к значению Y, рассчитанному с помощью автонастройки." .. info

    -- mirror timer
    L["CastbarMirrorTimerName"] = "Таймер зеркала игрока"
    L["CastbarMirrorTimerNameDesc"] = ""
    L["CastbarMirrorHideBlizzard"] = "Скрыть Blizzard"
    L["CastbarMirrorHideBlizzardDesc"] = "Скрыть стандартный таймер зеркала Blizzard."
end

-- Minimap
do
    L["MinimapName"] = "Миникарта"
    L["MinimapStyle"] = L["ButtonTableStyle"]
    L["MinimapShowPing"] = "Показывать пинг"
    L["MinimapNotYetImplemented"] = "(ЕЩЕ НЕ РЕАЛИЗОВАНО)"
    L["MinimapShowPingInChat"] = "Показывать пинг в чате"
    L["MinimapShape"] = "Форма миникарты"
    L["MinimapShapeDesc"] = ""
    L["MinimapRotateDescAdditional"] = "\n\nПримечание: Работает только с круглой формой миникарты."
    L["MinimapHideCalendar"] = "Скрыть календарь"
    L["MinimapHideCalendarDesc"] = "Скрывает кнопку календаря"
    L["MinimapHideHeader"] = "Скрыть заголовок"
    L["MinimapHideHeaderDesc"] = "Скрывает заголовок миникарты"
    L["MinimapHideClock"] = "Скрыть часы"
    L["MinimapHideClockDesc"] = ""
    L["MinimapHideZoneText"] = "Скрыть текст зоны"
    L["MinimapHideZoneTextDesc"] = ""
    L["MinimapHideZoomButtons"] = "Скрыть кнопки масштаба"
    L["MinimapHideZoomDesc"] = "Скрывает кнопки масштаба (+) (-)"
    L["MinimapSkinMinimapButtons"] = "Оформление кнопок миникарты"
    L["MinimapSkinMinimapButtonsDesc"] = "Изменяет стиль кнопок миникарты, используя LibDBIcon (большинство аддонов используют это)"
    L["MinimapSkinMinimapHideButtons"] = "Скрыть кнопки миникарты"
    L["MinimapSkinMinimapHideButtonsDesc"] = "Скрывает кнопки миникарты, когда курсор не находится над миникартой." ..
                                                 "\n\nПримечание: работает только для кнопок, использующих LibDBIcon"
    L["MinimapZonePanelPosition"] = "Положение заголовка"
    L["MinimapZonePanelPositionDesc"] = "Устанавливает положение заголовка."
    L["MinimapUseStateHandler"] = "Использовать обработчик состояния"
    L["MinimapUseStateHandlerDesc"] =
        "Без этого настройки видимости выше не будут работать, но это может улучшить совместимость с другими аддонами (например, для MinimapAlert), так как не делает рамки защищенными."

    L["MinimapTrackerName"] = "Трекер"
    L["MinimapDurabilityName"] = "Прочность"
    L["MinimapLFGName"] = "LFG"
end

-- UI
do
    L["UIUtility"] = "Утилиты"
    L["UIName"] = "Интерфейс"
    L["UIChangeBags"] = "Изменить сумки"
    L["UIChangeBagsDesc"] = ""
    L["UIColoredInventoryItems"] = "Цветные предметы инвентаря"
    L["UIColoredInventoryItemsDesc"] = "Включить окрашивание предметов инвентаря в зависимости от их качества."
    L["UIShowQuestlevel"] = "Показывать уровень квеста"
    L["UIShowQuestlevelDesc"] = "Отображать уровень квеста рядом с названием квеста."
    L["UIFrames"] = "Рамки"
    L["UIFramesDesc"] = "Настройки для изменения различных игровых рамок."
    L["UIChangeCharacterFrame"] = "Изменить окно персонажа"
    L["UIChangeCharacterFrameDesc"] = "Изменить внешний вид окна персонажа."
    L["UIChangeProfessionWindow"] = "Изменить окно профессий"
    L["UIChangeProfessionWindowDesc"] = "Изменить внешний вид окна профессий."
    L["UIChangeInspectFrame"] = "Изменить окно осмотра"
    L["UIChangeInspectFrameDesc"] = "Изменить внешний вид окна осмотра."
    L["UIChangeTrainerWindow"] = "Изменить окно тренера"
    L["UIChangeTrainerWindowDesc"] = "Изменить внешний вид окна тренера."
    L["UIChangeTalentFrame"] = "Изменить окно талантов"
    L["UIChangeTalentFrameDesc"] = "Изменить макет или внешний вид окна талантов. (Недоступно в Wrath)"
    L["UIChangeSpellBook"] = "Изменить спеллбук"
    L["UIChangeSpellBookDesc"] = "Изменить внешний вид спеллбука."
    L["UIChangeSpellBookProfessions"] = "Изменить профессии спеллбука"
    L["UIChangeSpellBookProfessionsDesc"] = "Изменить макет спеллбука для профессий."

    -- Characterstatspanel
    L['CharacterStatsHitMeleeTooltipFormat'] = "Увеличивает шанс попадания в ближнем бою по цели уровня %d на %.2f%%."
    L['CharacterStatsArp'] = ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT or "Пробивание брони"
    L['CharacterStatsArpTooltipFormat'] = "Рейтинг пробивания брони %d \n(Броня врага снижена до %.2f%%)."
    L['CharacterStatsHitSpellTooltipFormat'] = "Увеличивает шанс попадания заклинания по цели уровня %d на %.2f%%."
    L['CharacterStatsSpellPen'] = ITEM_MOD_SPELL_PENETRATION_SHORT or "Проникающая способность заклинаний"
    L['CharacterStatsSpellPenTooltipFormat'] = SPELL_PENETRATION_TOOLTIP or
                                                   "Проникающая способность заклинаний %d \n(Снижает сопротивление врага на %d)."

    -- ProfessionFrame
    L["ProfessionFrameHasSkillUp"] = TRADESKILL_FILTER_HAS_SKILL_UP or "Имеет повышение навыка"
    L["ProfessionFrameHasMaterials"] = CRAFT_IS_MAKEABLE or "Изготавливаемо"
    L["ProfessionFrameSubclass"] = "Подкласс"
    L["ProfessionFrameSlot"] = "Слот"
    L["ProfessionCheckAll"] = "Выбрать все"
    L["ProfessionUnCheckAll"] = "Снять все"
    L["ProfessionFavorites"] = "Избранное"
    L["ProfessionExpansionFormat"] = "|cFFFFFFFFРецепт из|r %s"
end

-- Tooltip
do
    L["TooltipName"] = "Подсказка"
    L["TooltipAnchorName"] = "Якорь подсказки"
    L["TooltipHeaderGameToltip"] = "Игровая подсказка"
    L["TooltipHeaderSpellTooltip"] = "Подсказка заклинания"
    L["TooltipCursorAnchorHeader"] = "Якорь на курсоре"
    L["TooltipCursorAnchorHeaderDesc"] = ""
    L["TooltipAnchorToMouse"] = "Привязка к курсору"
    L["TooltipAnchorToMouseDesc"] = "Привязывает некоторые подсказки (например, UnitTooltip на WorldFrame) к курсору мыши."
    L["TooltipDefaultAnchorWhileCombat"] = "Стандартный якорь в бою"
    L["TooltipDefaultAnchorWhileCombatDesc"] =
        "Использовать стандартный якорь подсказки в бою вместо якоря на курсоре."
    L["TooltipMouseAnchor"] = "Якорь на курсоре"
    L["TooltipMouseAnchorDesc"] = ""
    L["TooltipMouseX"] = "X"
    L["TooltipMouseXDesc"] = ""
    L["TooltipMouseY"] = "Y"
    L["TooltipMouseYDesc"] = ""

    -- spelltooltip
    L["TooltipAnchorSpells"] = "Якорь заклинаний"
    L["TooltipAnchorSpellsDesc"] = "Привязывает подсказку заклинаний на панелях действий к кнопке вместо стандартного якоря."
    L["TooltipShowSpellID"] = "Показывать ID заклинания"
    L["TooltipShowSpellIDDesc"] = ""
    L["TooltipShowSpellSource"] = "Показывать источник заклинания"
    L["TooltipShowSpellSourceDesc"] = ""
    L["TooltipShowSpellIcon"] = "Показывать иконку заклинания"
    L["TooltipShowSpellIconDesc"] = ""
    L["TooltipShowIconID"] = "Показывать ID иконки"
    L["TooltipShowIconIDDesc"] = ""
    L["TooltipShowIcon"] = "Показывать иконку"
    L["TooltipShowIconDesc"] = ""

    -- itemtooltip
    L["TooltipHeaderItemTooltip"] = "Подсказка предмета"
    L["TooltipHeaderItemTooltipDesc"] = ""
    L["TooltipShowItemQuality"] = "Граница качества предмета"
    L["TooltipShowItemQualityDesc"] = ""
    L["TooltipShowItemQualityBackdrop"] = "Фон качества предмета"
    L["TooltipShowItemQualityBackdropDesc"] = ""
    L["TooltipShowItemStackCount"] = "Показывать размер стака"
    L["TooltipShowItemStackCountDesc"] = ""
    L["TooltipShowItemID"] = "Показывать ID предмета"
    L["TooltipShowItemIDDesc"] = ""

    -- backdrop
    L["TooltipBackdropHeader"] = "Фон"
    L["TooltipBackdropHeaderDesc"] = ""
    L["TooltipBackdropColor"] = "Цвет фона"
    L["TooltipBackdropColorDesc"] = ""
    L["TooltipBackdropAlpha"] = "Прозрачность фона"
    L["TooltipBackdropAlphaDesc"] = ""
    L["TooltipBackdropCustomTexture"] = "Текстура фона"
    L["TooltipBackdropCustomTextureDesc"] = ""

    -- border
    L["TooltipBorderName"] = "Граница"
    L["TooltipBorderNameDesc"] = ""
    L["TooltipBorderCustomTexture"] = "Текстура границы"
    L["TooltipBorderCustomTextureDesc"] = ""
    L["TooltipBorderColor"] = "Цвет границы"
    L["TooltipBorderColorDesc"] = ""
    L["TooltipBorderAlpha"] = "Прозрачность границы"
    L["TooltipBorderAlphaDesc"] = ""

    L["TooltipBorderInsetLeft"] = "Отступ слева"
    L["TooltipBorderInsetRight"] = "Отступ справа"
    L["TooltipBorderInsetTop"] = "Отступ сверху"
    L["TooltipBorderInsetBottom"] = "Отступ снизу"
    L["TooltipBorderInsetDesc"] = ""

    L["TooltipBorderInsetEdgeSize"] = "Размер края"
    L["TooltipBorderInsetEdgeSizeDesc"] = ""

    -- statusbar
    L["TooltipUnitHealthbarName"] = "Полоса состояния"
    L["TooltipUnitHealthbarNameDesc"] = ""
    L["TooltipUnitHealthbar"] = "Показывать полосу здоровья"
    L["TooltipUnitHealthbarDesc"] = ""
    L["TooltipUnitHealthbarHeight"] = "Высота полосы здоровья"
    L["TooltipUnitHealthbarHeightDesc"] = "."
    L["TooltipUnitHealthbarText"] = "Показывать текст полосы здоровья"
    L["TooltipUnitHealthbarTextDesc"] = ""

    -- unittooltip
    L["TooltipUnitTooltip"] = "Подсказка юнита"
    L["TooltipUnitTooltipDesc"] = ""
    L["TooltipUnitClassBorder"] = "Граница класса"
    L["TooltipUnitClassBorderDesc"] = ""
    L["TooltipUnitClassBackdrop"] = "Фон класса"
    L["TooltipUnitClassBackdropDesc"] = ""
    L["TooltipUnitReactionBorder"] = "Граница реакции"
    L["TooltipUnitReactionBorderDesc"] = ""
    L["TooltipUnitReactionBackdrop"] = "Фон реакции"
    L["TooltipUnitReactionBackdropDesc"] = ""
    L["TooltipUnitClassName"] = "Название класса"
    L["TooltipUnitClassNameDesc"] = ""
    L["TooltipUnitTitle"] = "Показывать титул"
    L["TooltipUnitTitleDesc"] = ""
    L["TooltipUnitRealm"] = "Показывать мир"
    L["TooltipUnitRealmDesc"] = ""
    L["TooltipUnitGuild"] = "Показывать гильдию"
    L["TooltipUnitGuildDesc"] = ""
    L["TooltipUnitGuildRank"] = "Показывать ранг гильдии"
    L["TooltipUnitGuildRankDesc"] = ""
    L["TooltipUnitGuildRankIndex"] = "Показывать индекс ранга гильдии"
    L["TooltipUnitGuildRankIndexDesc"] = ""
    L["TooltipUnitGrayOutOnDeath"] = "Серый при смерти"
    L["TooltipUnitGrayOutOnDeathDesc"] = ""
    L["TooltipUnitZone"] = "Показывать текст зоны"
    L["TooltipUnitZoneDesc"] = ""
    L["TooltipUnitTarget"] = "Показывать цель"
    L["TooltipUnitTargetDesc"] = "Показывать цель юнита"
end

-- Unitframes
do
    L["UnitFramesName"] = "Рамки юнитов"

    -- Player
    L["PlayerFrameName"] = "Рамка игрока"
    L["PlayerFrameDesc"] = "Настройки рамки игрока"
    L["PlayerFrameStyle"] = L["ButtonTableStyle"]
    L["PlayerFrameClassColor"] = "Цвет класса"
    L["PlayerFrameClassColorDesc"] = "Включить цвета классов для полосы здоровья."
    L["PlayerFrameClassIcon"] = "Иконка класса в портрете"
    L["PlayerFrameClassIconDesc"] = "Включить иконку класса в качестве портрета (в настоящее время отключено)"
    L["PlayerFrameBreakUpLargeNumbers"] = "Разбивать большие числа"
    L["PlayerFrameBreakUpLargeNumbersDesc"] =
        "Включить разбивку больших чисел в тексте состояния (например, 7588 K вместо 7588000)"
    L["PlayerFrameBiggerHealthbar"] = "Большая полоса здоровья"
    L["PlayerFrameBiggerHealthbarDesc"] = "Включить большую полосу здоровья"
    L["PlayerFramePortraitExtra"] = "Дополнительный портрет"
    L["PlayerFramePortraitExtraDesc"] = "Показывает дракона элиты, редкого или мирового босса вокруг рамки игрока."
    L["PlayerFrameHideRedStatus"] = "Скрыть красное свечение в бою"
    L["PlayerFrameHideRedStatusDesc"] = "Скрыть красное свечение статуса в бою"
    L["PlayerFrameHideHitIndicator"] = "Скрыть индикатор попадания"
    L["PlayerFrameHideHitIndicatorDesc"] = "Скрыть индикатор попадания на рамке игрока"
    L["PlayerFrameHideSecondaryRes"] = "Скрыть вторичный ресурс"
    L["PlayerFrameHideSecondaryResDesc"] = "Скрыть вторичный ресурс, например, осколки душ."
    L["PlayerFrameHideAlternatePowerBar"] = "Скрыть альтернативную полосу силы друида"
    L["PlayerFrameHideAlternatePowerBarDesc"] = "Скрыть альтернативную полосу силы друида (полоса маны в формах медведя/кошки)."
    L["PlayerFrameHideRestingGlow"] = "Скрыть свечение отдыха"
    L["PlayerFrameHideRestingGlowDesc"] = "Скрывает свечение статуса отдыха на рамке игрока."
    L["PlayerFrameHideRestingIcon"] = "Скрыть иконку отдыха"
    L["PlayerFrameHideRestingIconDesc"] = "Скрывает иконку отдыха на рамке игрока."
    L["PlayerFrameHidePVP"] = "Скрыть иконку PVP"
    L["PlayerFrameHidePVPDesc"] = "Скрыть иконку PVP."

    local note =
        "\n\nПРИМЕЧАНИЕ: Пользовательские текстуры используют стандартный цвет полосы состояния от Blizzard.\nЕсли вы хотите что-то другое, вам придется изменить это через код.\n"
    L["PlayerFrameCustomHealthbarTexture"] = "Текстура полосы здоровья"
    L["PlayerFrameCustomHealthbarTextureDesc"] =
        "Изменяет текстуру полосы здоровья на пользовательскую из LibSharedMedia." .. note
    L["PlayerFrameCustomPowerbarTexture"] = "Текстура полосы силы"
    L["PlayerFrameCustomPowerbarTextureDesc"] = "Изменяет текстуру полосы силы на пользовательскую из LibSharedMedia." ..
                                                    note
    -- Player Secondary Res
    L["PlayerSecondaryResName"] = "Вторичный ресурс игрока"
    L["PlayerSecondaryResNameDesc"] = ""

    -- TotemFrame
    L["PlayerTotemFrameName"] = "Рамка тотемов игрока"
    L["PlayerTotemFrameNameDesc"] = ""

    -- PowerBar_Alt
    L["PowerBarAltName"] = "Player_PowerBarAlt"
    L["PowerBarAltNameDesc"] = ""

    -- Target
    L["TargetFrameName"] = "Рамка цели"
    L["TargetFrameDesc"] = "Настройки рамки цели"
    L["TargetFrameStyle"] = L["ButtonTableStyle"]
    L["TargetFrameClassColor"] = L["PlayerFrameClassColor"]
    L["TargetFrameClassColorDesc"] = L["PlayerFrameClassColorDesc"]
    L["TargetFrameReactionColor"] = "Цвет реакции"
    L["TargetFrameReactionColorDesc"] = "Включить цвета реакции для полосы здоровья."
    L["TargetFrameClassIcon"] = L["PlayerFrameClassIcon"]
    L["TargetFrameClassIconDesc"] = L["PlayerFrameClassIconDesc"]
    L["TargetFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
    L["TargetFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
    L["TargetFrameNumericThreat"] = "Числовая угроза"
    L["TargetFrameNumericThreatDesc"] = "Включить отображение числовой угрозы"
    L["TargetFrameNumericThreatAnchor"] = "Якорь числовой угрозы"
    L["TargetFrameNumericThreatAnchorDesc"] = "Устанавливает якорь (позицию) числовой угрозы"
    L["TargetFrameThreatGlow"] = "Свечение угрозы"
    L["TargetFrameThreatGlowDesc"] = "Включить эффект свечения угрозы"
    L["TargetFrameHideNameBackground"] = "Скрыть фон имени"
    L["TargetFrameHideNameBackgroundDesc"] = "Скрыть фон имени цели"
    L["TargetFrameComboPointsOnPlayerFrame"] = "Очки комбо на рамке игрока"
    L["TargetFrameComboPointsOnPlayerFrameDesc"] = "Показывать очки комбо на рамке игрока."
    L["TargetFrameHideComboPoints"] = "Скрыть очки комбо"
    L["TargetFrameHideComboPointsDesc"] = "Скрывает рамку очков комбо."
    L["TargetFrameFadeOut"] = "Затухание"
    L["TargetFrameFadeOutDesc"] = "Затухает рамка цели, если цель находится дальше, чем *Дистанция затухания*."
    L["TargetFrameFadeOutDistance"] = "Дистанция затухания"
    L["TargetFrameFadeOutDistanceDesc"] =
        "Устанавливает дистанцию в ярдах для проверки эффекта затухания.\nПримечание: не каждое значение может повлиять, так как используется 'LibRangeCheck-3.0'.\nРассчитывается по 'minRange >= fadeOutDistance'."

    L["TargetFrameHeaderBuffs"] = "Баффы/Дебаффы"
    L["TargetFrameAuraSizeSmall"] = "Малый размер ауры"
    L["TargetFrameAuraSizeSmallDesc"] =
        "Устанавливает размер аур, не принадлежащих игроку, на рамке цели при использовании 'Динамический размер баффов'."
    L["TargetFrameAuraSizeLarge"] = "Размер ауры"
    L["TargetFrameAuraSizeLargeDesc"] = "Устанавливает размер ауры на рамке цели."
    L["TargetFrameNoDebuffFilter"] = "Показывать все вражеские дебаффы"
    L["TargetFrameNoDebuffFilterDesc"] =
        "Отображает дружеские и вражеские дебаффы на рамке цели, а не только ваши собственные."
    L["TargetFrameDynamicBuffSize"] = "Динамический размер баффов"
    L["TargetFrameDynamicBuffSizeDesc"] = "Увеличивает размер баффов и дебаффов игрока на цели."

    L["TargetFrameHeaderBuffsAdvanced"] = "Баффы/Дебаффы (расширенные)"
    L["TargetFrameAuraOffsetY"] = "Смещение ауры по Y"
    L["TargetFrameAuraOffsetYDesc"] = "Смещение по Y между строками и баффами/дебаффами."
    L["TargetFrameAuraRowWidth"] = "Ширина строки ауры"
    L["TargetFrameAuraRowWidthDesc"] = "Максимальная ширина строки для баффов/дебаффов."
    L["TargetFrameAuraRowWidthToT"] = "Ширина строки ауры (ToT)"
    L["TargetFrameAuraRowWidthToTDesc"] = "То же, что и 'Ширина строки ауры', но только для первых X (=NumToTAuraRows) строк." ..
                                              "\n\nЭто предназначено для оставления места для рамки TargetOfTarget."
    L["TargetFrameToTAuraRows"] = "Количество строк ауры ToT"
    L["TargetFrameToTAuraRowsDesc"] =
        "Количество строк ауры, использующих 'Ширина строки ауры (ToT)' вместо обычной ширины." ..
            "\n\nУстановите 0, если хотите, чтобы все строки ауры имели одинаковую ширину, например, когда вы переместили рамку ToT."

    -- ToT
    L["TargetOfTargetFrameName"] = "Цель цели"
    L["TargetOfTargetFrameDesc"] = ""
    -- Pet
    L["PetFrameName"] = "Рамка питомца"
    L["PetFrameDesc"] = "Настройки рамки питомца"
    L["PetFrameStyle"] = L["ButtonTableStyle"]
    L["PetFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
    L["PetFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
    L["PetFrameThreatGlow"] = L["TargetFrameThreatGlow"]
    L["PetFrameThreatGlowDesc"] = L["TargetFrameThreatGlowDesc"]
    L["PetFrameHideStatusbarText"] = "Скрыть текст полосы состояния"
    L["PetFrameHideStatusbarTextDesc"] = "Скрыть текст полосы состояния"
    L["PetFrameHideIndicator"] = "Скрыть индикатор попадания"
    L["PetFrameHideIndicatorDesc"] = "Скрыть индикатор попадания"
    L["PetFrameHideDebuffs"] = "Скрыть дебаффы"
    L["PetFrameHideDebuffsDesc"] = "Скрывает дебаффы питомца."

    -- Focus
    L["FocusFrameName"] = "Рамка фокуса"
    L["FocusFrameToTName"] = "Цель фокуса"
    L["FocusFrameDesc"] = "Настройки рамки фокуса"
    L["FocusFrameStyle"] = L["ButtonTableStyle"]
    L["FocusFrameClassColor"] = L["PlayerFrameClassColor"]
    L["FocusFrameClassColorDesc"] = "Включить цвета классов для полосы здоровья"
    L["FocusFrameClassIcon"] = L["PlayerFrameClassIcon"]
    L["FocusFrameClassIconDesc"] = "Включить иконку класса в качестве портрета для рамки фокуса"
    L["FocusFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
    L["FocusFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
    L["FocusFrameHideNameBackground"] = L["TargetFrameHideNameBackground"]
    L["FocusFrameHideNameBackgroundDesc"] = "Скрыть фон имени"

    -- party
    L["PartyFrameName"] = "Рамка группы"
    L["PartyFrameDesc"] = "Настройки рамки группы"
    L["PartyFrameStyle"] = L["ButtonTableStyle"]
    L["PartyFrameClassColor"] = L["PlayerFrameClassColor"]
    L["PartyFrameClassColorDesc"] = "Включить цвета классов для полосы здоровья"
    L["PartyFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
    L["PartyFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
    L["PartyFrameDisableBuffTooltip"] = "Отключить подсказку баффов"
    L["PartyFrameDisableBuffTooltipDesc"] = "Отключает подсказку баффов (при наведении мыши)."

    -- raid
    L["RaidFrameName"] = "Рамка рейда"

    -- Bosss
    L["BossFrameName"] = "Рамка босса"
    L["BossFrameNameDesc"] = "Настройки рамки босса"
end

-- keybindings
do
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

    for k, v in pairs(KEY_REPLACEMENTS) do L_RU[k] = v; end
    DF.KEY_REPLACEMENTS = KEY_REPLACEMENTS;
end

-- see comment above
for k, v in pairs(L) do L_RU[k] = v; end
