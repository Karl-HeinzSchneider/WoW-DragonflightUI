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
        "Этот модуль перерабатывает стандартную панель действий, включая микроменю и кнопки сумок.\nДобавляет отдельные настройки для панелей действий 1-8, панели питомца, опыта, репутации, управления, стойки, тотемов, сумок и микроменю."
    L["ModuleTooltipBossframe"] =
        "Этот модуль добавляет пользовательские окна боссов.\nВ РАЗРАБОТКЕ."
    L["ModuleTooltipBuffs"] =
        "Этот модуль изменяет стандартный окно баффов.\nДобавляет отдельные настройки для баффов и дебаффов."
    L["ModuleTooltipCastbar"] =
        "Этот модуль изменяет стандартную полосу заклинаний.\nДобавляет отдельные настройки для полосы заклинаний игрока, фокуса и цели."
    L["ModuleTooltipChat"] =
        "Этот модуль изменяет стандартное окно чата.\nВ РАЗРАБОТКЕ."
    L["ModuleTooltipCompatibility"] =
        "Этот модуль добавляет дополнительную совместимость с другими аддонами."
    L["ModuleTooltipDarkmode"] =
        "Этот модуль добавляет темный режим для нескольких окон DragonflightUI.\nВ РАЗРАБОТКЕ - пожалуйста, оставляйте отзывы!"
    --    L["ModuleTooltipFlyout"] = "Flyout"
    L["ModuleTooltipMinimap"] =
        "Этот модуль перерабатывает стандартную миникарту и трекер заданий.\nДобавляет отдельные настройки для миникарты и трекера заданий."
    L["ModuleTooltipTooltip"] =
        "Этот модуль улучшает подсказки в игре.\nВ РАЗРАБОТКЕ"
    L["ModuleTooltipUI"] =
        "Этот модуль добавляет современный стиль интерфейса для различных окон, таких как окно персонажа. Также добавляет редизайн для Era, включая новую книгу заклинаний, окно талантов и окно профессий."
    L["ModuleTooltipUnitframe"] =
        "Этот модуль перерабатывает стандартные окна юнитов и добавляет новые функции, такие как цвет класса или MobHealth (Era).\nДобавляет отдельные настройки для окна игрока, питомца, цели, фокуса и группы."
    L["ModuleTooltipUtility"] =
        "Этот модуль добавляет общие функции и настройки интерфейса.\nВ РАЗРАБОТКЕ"

    --    L["ModuleFlyout"] = "Flyout"
    --    L["ModuleActionbar"] = "Actionbar"
    --    L["ModuleCastbar"] = "Castbar"
    --    L["ModuleChat"] = "Chat"
    --    L["ModuleBuffs"] = "Buffs"
    --    L["ModuleDarkmode"] = "Darkmode"
    --    L["ModuleMinimap"] = "Minimap"
    --    L["ModuleTooltip"] = "Tooltip"
    --    L["ModuleUI"] = "UI"
    --    L["ModuleUnitframe"] = "Unitframe"
    --    L["ModuleUtility"] = "Utility"
    --    L["ModuleCompatibility"] = "Compatibility"
    --    L["ModuleBossframe"] = "Bossframe"
end

-- config 
do
    --    L["ConfigGeneralWhatsNew"] = "What's New"
    --    L["ConfigGeneralModules"] = "Modules"
    --    L["ConfigGeneralInfo"] = "Info"
    --    L["MainMenuDragonflightUI"] = "DragonflightUI"
    --    L["MainMenuEditmode"] = "Editmode"

    -- config.mixin.lua
    --    L["ConfigMixinQuickKeybindMode"] = "Quick Keybind Mode"
    --    L["ConfigMixinGeneral"] = "General"
    --    L["ConfigMixinModules"] = "Modules"
    --    L["ConfigMixinActionBar"] = "Action Bar"
    --    L["ConfigMixinCastBar"] = "Cast Bar"
    --    L["ConfigMixinMisc"] = "Misc"
    --    L["ConfigMixinUnitframes"] = "Unitframes"

    -- modules.mixin.lua
    L["ModuleConditionalMessage"] =
        "'|cff8080ff%s|r' был деактивирован, но соответствующая функция уже была зацеплена, пожалуйста, выполните '|cff8080ff/reload|r'!"

    -- config
    L["ConfigToolbarDiscord"] = "Discord"
    L["ConfigToolbarDiscordTooltip"] = "Вносите идеи и получайте поддержку."
    L["ConfigToolbarGithub"] = "Github"
    L["ConfigToolbarGithubTooltip"] =
        "Просматривайте код, сообщайте об ошибках и вносите вклад."
    L["ConfigToolbarCoffee"] = "BuyMeACoffee"
    L["ConfigToolbarCoffeeTooltip1"] =
        "Каждый комментарий, лайк или репост имеет значение, но если вы чувствуете себя особенно щедрым, вы можете угостить меня куском пиццы, чтобы поддержать дальнейшую разработку!"
    L["ConfigToolbarCoffeeTooltip2"] =
        "Поддерживающие получают эксклюзивные бонусы, узнайте о них в разделе для спонсоров на нашем Discord."
end

-- profiles
do
    L["ProfilesSetActiveProfile"] = "Установить активный профиль."
    L["ProfilesNewProfile"] = "Создать новый профиль."
    L["ProfilesCopyFrom"] =
        "Скопировать настройки из существующего профиля в текущий активный профиль."
    L["ProfilesOpenCopyDialogue"] = "Открыть диалог копирования."
    L["ProfilesDeleteProfile"] = "Удалить существующий профиль из базы данных."
    L["Profiles"] = "Добавить новый профиль"
    L["ProfilesOpenDeleteDialogue"] = "Открыть диалог удаления."
    L["ProfilesAddNewProfile"] = "Добавить новый профиль"
    L["ProfilesChatNewProfile"] = "новый профиль: "
    L["ProfilesErrorNewProfile"] =
        "ОШИБКА: Имя нового профиля не может быть пустым!"
    L["ProfilesDialogueDeleteProfile"] = "Удалить профиль \'%s\'?"
    L["ProfilesDialogueCopyProfile"] =
        "Добавить новый профиль (скопировать из \'|cff8080ff%s|r\')"
    L["ProfilesImportShareHeader"] = "Импорт/Поделиться"
    L["ProfilesImportProfile"] = "Импортировать профиль"
    L["ProfilesImportProfileButton"] = "Импортировать"
    L["ProfilesImportProfileDesc"] = "Открывает диалог импорта."
    L["ProfilesExportProfile"] = "Поделиться профилем"
    L["ProfilesExportProfileButton"] = "Поделиться"
    L["ProfilesExportProfileDesc"] = "Открывает диалог для передачи."
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
    L["EditModeCopyToClipboard"] = HUD_EDIT_MODE_COPY_TO_CLIPBOARD or
                                       "Копировать в буфер обмена |cffffd100(для обмена онлайн)|r"
    L["EditModeExportProfile"] = "Экспорт профиля |cff8080ff%s|r"
    L["EditModeImportProfile"] = "Импорт профиля как |cff8080ff%s|r"
end

-- Compat
do
    L['CompatAuctionator'] = "Auctionator"
    L['CompatAuctionatorDesc'] =
        "Добавляет совместимость с Auctionator при использовании модуля UI с включенной опцией 'Изменить окно профессий'."
    L['CompatBaganator'] = "Baganator"
    L['CompatBaganatorDesc'] =
        "Изменяет стандартную тему 'Blizzard' на стилизованную под DragonflightUI."
    L['CompatCharacterStatsClassic'] = "CharacterStatsClassic"
    L['CompatCharacterStatsClassicDesc'] =
        "Добавляет совместимость с CharacterStatsClassic при использовании модуля UI с включенной опцией 'Изменить окно персонажа'."
    L['CompatClassicCalendar'] = "Classic Calendar"
    L['CompatClassicCalendarDesc'] = "Добавляет совместимость с Classic Calendar."
    -- L['CompatClique'] = "Clique"
    -- L['CompatCliqueDesc'] = "Adds compatibility for Clique"
    L['CompatLFGBulletinBoard'] = "LFG Bulletin Board"
    L['CompatLFGBulletinBoardDesc'] = "Добавляет совместимость с LFG Bulletin Board."
    L['CompatMerInspect'] = "MerInspect"
    L['CompatMerInspectDesc'] =
        "Добавляет совместимость с MerInspect при использовании модуля UI с включенной опцией 'Изменить окно персонажа'."
    L['CompatRanker'] = "Ranker"
    L['CompatRankerDesc'] =
        "Добавляет совместимость с Ranker при использовании модуля UI с включенной опцией 'Изменить окно персонажа'."
    L['CompatTacoTip'] = "TacoTip"
    L['CompatTacoTipDesc'] =
        "Добавляет совместимость с TacoTip при использовании модуля UI с включенной опцией 'Изменить окно персонажа'."
    L['CompatTDInspect'] = "TDInspect"
    L['CompatTDInspectDesc'] =
        "Добавляет совместимость с TDInspect при использовании модуля UI с включенной опцией 'Изменить окно персонажа'."
    L['CompatWhatsTraining'] = "WhatsTraining"
    L['CompatWhatsTrainingDesc'] =
        "Добавляет совместимость с WhatsTraining при использовании модуля UI с включенной опцией 'Изменить книгу заклинаний'."
end

-- __Settings
do
    L["SettingsDefaultStringFormat"] = "\n(По умолчанию: |cff8080ff%s|r)"
    --    L["SettingsCharacterSpecific"] = "\n\n|cff8080ff[Per-character setting]|r"

    -- positionTable
    L["PositionTableHeader"] = "Масштаб и позиция"
    L["PositionTableHeaderDesc"] = ""
    L["PositionTableScale"] = "Масштаб"
    L["PositionTableScaleDesc"] = ""
    L["PositionTableAnchor"] = "Закрепить"
    L["PositionTableAnchorDesc"] = "Закрепить"
    L["PositionTableAnchorParent"] = "Родительский закреп"
    L["PositionTableAnchorParentDesc"] = ""
    L["PositionTableAnchorFrame"] = "Закрепить окно"
    L["PositionTableAnchorFrameDesc"] = ""
    L["PositionTableCustomAnchorFrame"] = "Рамка якоря (пользовательская)"
    L["PositionTableCustomAnchorFrameDesc"] =
        "Используйте эту именованную рамку в качестве якоря (если она действительна). Например, 'CharacterFrame', 'TargetFrame'..."
    L["PositionTableX"] = "X"
    L["PositionTableXDesc"] = ""
    L["PositionTableY"] = "Y"
    L["PositionTableYDesc"] = ""
end

-- darkmode
do
    L["DarkmodeColor"] = "Цвет"
    L["DarkmodeDesaturate"] = "Обесцветить"
end

-- actionbar
do
    L["ActionbarName"] = "Панель действий"
    L["ActionbarNameFormat"] = "Панель действий %d"

    -- bar names
    L["XPBar"] = "Панель опыта"
    L["ReputationBar"] = "Панель репутации"
    L["PetBar"] = "Панель питомца"
    L["StanceBar"] = "Панель стойки"
    L["PossessBar"] = "Панель управления"
    L["MicroMenu"] = "Микроменю"
    L["TotemBar"] = "Панель тотемов"

    -- gryphonsTable
    L["Default"] = "По умолчанию"
    L["Alliance"] = "Альянс"
    L["Horde"] = "Орда"
    L["None"] = "Нет"

    -- buttonTable
    L["ButtonTableActive"] = "Активно"
    L["ButtonTableActiveDesc"] = ""
    L["ButtonTableButtons"] = "Кнопки"
    L["ButtonTableButtonsDesc"] = ""
    L["ButtonTableButtonScale"] = "Масштаб кнопок"
    L["ButtonTableButtonScaleDesc"] = ""
    L["ButtonTableOrientation"] = "Ориентация"
    L["ButtonTableOrientationDesc"] = "Ориентация"
    --    L["ButtonTableGrowthDirection"] = "Growth Direction"
    --    L["ButtonTableGrowthDirectionDesc"] = ""
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
    L["ButtonTableMacroNameFontSize"] = "Размер шрифта имени макроса"
    L["ButtonTableMacroNameFontSizeDesc"] = ""
    L["ButtonTableHideKeybindText"] = "Скрыть текст привязки клавиш"
    L["ButtonTableHideKeybindTextDesc"] = ""
    L["ButtonTableShortenKeybindText"] = "Сократить текст горячих клавиш"
    L["ButtonTableShortenKeybindTextDesc"] =
        "Сокращает текст горячих клавиш, например, 'sF' вместо 's-F' и подобные замены."
    L["ButtonTableKeybindFontSize"] = "Размер шрифта привязки клавиш"
    L["ButtonTableKeybindFontSizeDesc"] = ""

    L["MoreOptionsHideBarArt"] = "Скрыть оформление панели"
    L["MoreOptionsHideBarArtDesc"] = ""
    L["MoreOptionsHideBarScrolling"] = "Скрыть прокрутку панели"
    L["MoreOptionsHideBarScrollingDesc"] = ""
    L["MoreOptionsGryphons"] = "Грифоны"
    L["MoreOptionsGryphonsDesc"] = "Грифоны"
    L["MoreOptionsUseKeyDown"] = ACTION_BUTTON_USE_KEY_DOWN or "Использовать нажатие клавиши"
    L["MoreOptionsUseKeyDownDesc"] = OPTION_TOOLTIP_ACTION_BUTTON_USE_KEY_DOWN or
                                         "Активирует способности при нажатии клавиши."
    L["MoreOptionsIconRangeColor"] = "Цвет иконки вне диапазона"
    L["MoreOptionsIconRangeColorDesc"] =
        "Изменяет цвет иконки, когда цель вне диапазона, аналогично RedRange/tullaRange"

    L["ExtraOptionsPreset"] = "Предустановка"
    L["ExtraOptionsResetToDefaultPosition"] = "Сбросить на позицию по умолчанию"
    L["ExtraOptionsPresetDesc"] =
        "Устанавливает масштаб, закреп, родительский закреп, закреп окна, X и Y в соответствии с выбранной предустановкой, но не изменяет другие настройки."
    L["ExtraOptionsModernLayout"] = "Современный макет (по умолчанию)"
    L["ExtraOptionsModernLayoutDesc"] = ""
    L["ExtraOptionsClassicLayout"] = "Классический макет (боковая панель)"
    L["ExtraOptionsClassicLayoutDesc"] = ""

    -- XP
    L["XPOptionsName"] = "Опыт"
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
    L["RepOptionsName"] = "Репутация"
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
    L["BagsOptionsExpanded"] = "Расширено"
    L["BagsOptionsExpandedDesc"] = ""
    L["BagsOptionsHideArrow"] = "Скрыть стрелку"
    L["BagsOptionsHideArrowDesc"] = ""
    L["BagsOptionsHidden"] = "Скрыто"
    L["BagsOptionsHiddenDesc"] = "Рюкзак скрыт"
    L["BagsOptionsOverrideBagAnchor"] = "Переопределить якорь сумок"
    L["BagsOptionsOverrideBagAnchorDesc"] = ""
    L["BagsOptionsOffsetX"] = "Смещение якоря сумок по X"
    L["BagsOptionsOffsetXDesc"] = ""
    L["BagsOptionsOffsetY"] = "Смещение якоря сумок по Y"
    L["BagsOptionsOffsetYDesc"] = ""

    -- FPS
    L["FPSOptionsName"] = "FPS"
    L["FPSOptionsDesc"] = "FPS"
    L["FPSOptionsStyle"] = L["ButtonTableStyle"]
    L["FPSOptionsStyleDesc"] = ""
    L["FPSOptionsHideDefaultFPS"] = "Скрыть стандартный FPS"
    L["FPSOptionsHideDefaultFPSDesc"] = "Скрыть стандартный текст FPS"
    L["FPSOptionsShowFPS"] = "Показывать FPS"
    L["FPSOptionsShowFPSDesc"] = "Показывать пользовательский текст FPS"
    L["FPSOptionsAlwaysShowFPS"] = "Всегда показывать FPS"
    L["FPSOptionsAlwaysShowFPSDesc"] =
        "Всегда показывать пользовательский текст FPS"
    L["FPSOptionsShowPing"] = "Показывать пинг"
    L["FPSOptionsShowPingDesc"] = "Показывать пинг в мс"

    -- Extra Action Button
    L["ExtraActionButtonOptionsName"] = "Дополнительная кнопка действия"
    L["ExtraActionButtonOptionsNameDesc"] = "FPS"
    L["ExtraActionButtonStyle"] = L["ButtonTableStyle"]
    L["ExtraActionButtonStyleDesc"] = ""
    L["ExtraActionButtonHideBackgroundTexture"] = "Скрыть текстуру фона"
    L["ExtraActionButtonHideBackgroundTextureDesc"] = ""
end

-- Buffs
do
    L["BuffsOptionsName"] = "Баффы"
    L["BuffsOptionsStyle"] = L["ButtonTableStyle"]
    L["BuffsOptionsStyleDesc"] = ""

    L["BuffsOptionsExpanded"] = "Расширено"
    L["BuffsOptionsExpandedDesc"] = ""

    L["BuffsOptionsUseStateHandler"] = "Использовать обработчик состояния"
    L["BuffsOptionsUseStateHandlerDesc"] =
        "Без этого настройки видимости выше не будут работать, но может улучшить совместимость с другими аддонами (например, MinimapAlert), так как не делает окна защищенными."
end

-- Flyout
do
    --    L["FlyoutHeader"] = "Flyout"
    --    L["FlyoutHeaderDesc"] = ""
    --    L["FlyoutDirection"] = "Flyout Direction"
    --    L["FlyoutDirectionDesc"] = "Flyout Direction"
    --    L["FlyoutSpells"] = "Spells"
    --    L["FlyoutSpellsDesc"] = "Insert SpellIDs as comma seperated values, e.g. '688, 697'."
    --    L["FlyoutSpellsAlliance"] = "Spells (Alliance)"
    --    L["FlyoutSpellsAllianceDesc"] = L["FlyoutSpellsDesc"] .. "\n(Only used on alliance side.)"
    --    L["FlyoutSpellsHorde"] = "Spells (Horde)"
    --    L["FlyoutSpellsHordeDesc"] = L["FlyoutSpellsDesc"] .. "\n(Only used on horde side.)"
    --    L["FlyoutItems"] = "Items"
    --    L["FlyoutItemsDesc"] = "Insert ItemIDs as comma seperated values, e.g. '6948, 8490'."
    --    L["FlyoutCloseAfterClick"] = "Close After Click"
    --    L["FlyoutCloseAfterClickDesc"] = "Close the flyout after pressing one of its buttons."
    --    L["FlyoutAlwaysShow"] = "Always Show Buttons"
    --    L["FlyoutAlwaysShowDesc"] = "Always shows the (sub) buttons, even when they are empty.\nUse this if you want to use drag&drop."
    --    L["FlyoutIcon"] = "Icon"
    --    L["FlyoutIconDesc"] = "Insert FileID or the file path to a texture."
    --    L["FlyoutDisplayname"] = "Display Name"
    --    L["FlyoutDisplaynameDesc"] = ""
    --    L["FlyoutTooltip"] = "Tooltip"
    --    L["FlyoutTooltipDesc"] = ""

    --    L["FlyoutButtonWarlock"] = "Warlock Summon Flyout"
    --    L["FlyoutButtonMagePort"] = "Teleport Flyout"
    --    L["FlyoutButtonMagePortals"] = "Portals Flyout"
    --    L["FlyoutButtonMageFood"] = "Conjure Food Flyout"
    --    L["FlyoutButtonMageWater"] = "Conjure Water Flyout"
    --    L["FlyoutWarlock"] = "Summon Demon"
    --    L["FlyoutWarlockDesc"] = "Summons one of your demons to you."
    --    L["FlyoutMagePort"] = "Teleport"
    --    L["FlyoutMagePortDesc"] = "Teleports you to a major city."
    --    L["FlyoutMagePortals"] = "Portal"
    --    L["FlyoutMagePortalsDesc"] = "Creates a portal, teleporting group members who use it to a major city."
    --    L["FlyoutMageWater"] = "Conjure Water"
    --    L["FlyoutMageWaterDesc"] = "Conjured items disappear if logged out for more than 15 minutes."
    --    L["FlyoutMageFood"] = "Conjure Food"
    --    L["FlyoutMageFoodDesc"] = L["FlyoutMageWaterDesc"]

    --    L["FlyoutButtonCustomFormat"] = "Custom Flyout %d"
    --    L["FlyoutCustomNameFormat"] = "Custom Flyout %d"
    --    L["FlyoutCustomNameDescFormat"] = "Per-character flyout button with up to 12 additional actionbuttons."

    -- L["FlyoutHeaderClassPresets"] = "Class Presets"
    -- L["FlyoutHeaderClassPresetsDesc"] =
    -- "Sets the flyout settings and also the buttons of the flyout to a character specific preset."
end

-- Castbar
do
    L["CastbarName"] = "Полоса заклинаний"
    L["CastbarNameFormat"] = "%s Полоса заклинаний"
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
    L["CastbarTableShowCastTimeText"] = "Показывать текст времени заклинания"
    L["CastbarTableShowCastTimeTextDesc"] = ""
    L["CastbarTableShowCastTimeMaxText"] =
        "Показывать текст максимального времени заклинания"
    L["CastbarTableShowCastTimeMaxTextDesc"] = ""
    L["CastbarTableCompactLayout"] = "Компактный макет"
    L["CastbarTableCompactLayoutDesc"] = ""
    L["CastbarTableHoldTimeSuccess"] = "Время удержания (успех)"
    L["CastbarTableHoldTimeSuccessDesc"] =
        "Время до начала исчезновения полосы заклинаний после успешного завершения заклинания."
    L["CastbarTableHoldTimeInterrupt"] = "Время удержания (прерывание)"
    L["CastbarTableHoldTimeInterruptDesc"] =
        "Время до начала исчезновения полосы заклинаний после прерывания заклинания."
    L["CastbarTableShowIcon"] = "Показывать иконку"
    L["CastbarTableShowIconDesc"] = ""
    L["CastbarTableIconSize"] = "Размер иконки"
    L["CastbarTableIconSizeDesc"] = ""
    L["CastbarTableShowTicks"] = "Показывать тики"
    L["CastbarTableShowTicksDesc"] = ""
    L["CastbarTableAutoAdjust"] = "Автонастройка"
    L["CastbarTableAutoAdjustDesc"] =
        "Применяет смещение по Y в зависимости от количества баффов/дебаффов - полезно при привязке полосы заклинаний под окном цели/фокуса"
    L["CastbarTableShowRank"] = "Показывать ранг"
    L["CastbarTableShowRankDesc"] = ""
    L["CastbarTableShowChannelName"] = "Показывать название канала"
    L["CastbarTableShowChannelNameDesc"] =
        "Показывает название заклинания вместо текста отображения (например, 'Канал')"

    L["ExtraOptionsResetToDefaultStyle"] = "Сбросить на стиль по умолчанию"
    L["ExtraOptionsPresetStyleDesc"] =
        "Устанавливает все настройки, изменяющие стиль полосы заклинаний, но не изменяет другие настройки."
end

-- Minimap
do
    L["MinimapName"] = "Миникарта"
    L["MinimapStyle"] = L["ButtonTableStyle"]
    L["MinimapShowPing"] = "Показывать пинг"
    L["MinimapNotYetImplemented"] = "(ЕЩЕ НЕ РЕАЛИЗОВАНО)"
    L["MinimapShowPingInChat"] = "Показывать пинг в чате"
    L["MinimapHideCalendar"] = "Скрыть календарь"
    L["MinimapHideCalendarDesc"] = "Скрывает кнопку календаря"
    L["MinimapHideZoomButtons"] = "Скрыть кнопки масштабирования"
    L["MinimapHideZoomDesc"] = "Скрывает кнопки масштабирования (+) (-)"
    L["MinimapSkinMinimapButtons"] = "Стилизовать кнопки миникарты"
    L["MinimapSkinMinimapButtonsDesc"] =
        "Изменяет стиль кнопок миникарты с использованием LibDBIcon (большинство аддонов используют это)"
    -- L["MinimapZonePanelPosition"] = "Zone Panel Position"
    -- L["MinimapZonePanelPositionDesc"] =
    -- "Sets the position of the zone text panel including the frames anchored to it (e.g. calendar, tracking, mail, ..)."
    L["MinimapUseStateHandler"] = "Использовать обработчик состояния"
    L["MinimapUseStateHandlerDesc"] =
        "Без этого настройки видимости выше не будут работать, но может улучшить совместимость с другими аддонами (например, MinimapAlert), так как не делает окна защищенными."
end

-- UI
do
    L["UIUtility"] = "Утилиты"
    L["UIChangeBags"] = "Изменить сумки"
    L["UIChangeBagsDesc"] = ""
    L["UIColoredInventoryItems"] = "Цветные предметы в инвентаре"
    L["UIColoredInventoryItemsDesc"] =
        "Включить окрашивание предметов в инвентаре в зависимости от их качества."
    L["UIShowQuestlevel"] = "Показывать уровень задания"
    L["UIShowQuestlevelDesc"] =
        "Отображать уровень задания рядом с названием задания."
    L["UIFrames"] = "Окна"
    L["UIFramesDesc"] =
        "Настройки для изменения различных внутриигровых окон."
    L["UIChangeCharacterFrame"] = "Изменить окна персонажа"
    L["UIChangeCharacterFrameDesc"] = "Изменить внешний вид окна персонажа."
    L["UIChangeProfessionWindow"] = "Изменить окно профессии"
    L["UIChangeProfessionWindowDesc"] = "Изменить внешний вид окна профессии."
    L["UIChangeInspectFrame"] = "Изменить окно осмотра"
    L["UIChangeInspectFrameDesc"] = "Изменить внешний вид окна осмотра."
    L["UIChangeTrainerWindow"] = "Изменить окно тренера"
    L["UIChangeTrainerWindowDesc"] = "Изменить внешний вид окна тренера."
    L["UIChangeTalentFrame"] = "Изменить окно талантов"
    L["UIChangeTalentFrameDesc"] =
        "Изменить макет или внешний вид окна талантов. (Недоступно на Wrath)"
    L["UIChangeSpellBook"] = "Изменить книгу заклинаний"
    L["UIChangeSpellBookDesc"] = "Изменить внешний вид книги заклинаний."
    L["UIChangeSpellBookProfessions"] = "Изменить книгу заклинаний для профессий"
    L["UIChangeSpellBookProfessionsDesc"] =
        "Изменить макет книги заклинаний для профессий."

    -- Characterstatspanel
    --    L['CharacterStatsHitMeleeTooltipFormat'] = "Increases your melee chance to hit a target of level %d by %.2f%%." -- CR_HIT_MELEE_TOOLTIP
    --    L['CharacterStatsArp'] = ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT or "Armor Penetration"
    --    L['CharacterStatsArpTooltipFormat'] = "Armor penetration rating %d \n(Enemy armor reduced by up to %.2f%%)." -- CR_HIT_MELEE_TOOLTIP
    --    L['CharacterStatsHitSpellTooltipFormat'] = "Increases your spell chance to hit a target of level %d by %.2f%%." -- CR_HIT_SPELL_TOOLTIP
    --    L['CharacterStatsSpellPen'] = ITEM_MOD_SPELL_PENETRATION_SHORT or "Spell Penetration" -- ITEM_MOD_SPELL_PENETRATION_SHORT
    --    L['CharacterStatsSpellPenTooltipFormat'] = SPELL_PENETRATION_TOOLTIP or "Spell Penetration %d \n(Reduces enemy resistances by %d)."

    -- ProfessionFrame
    L["ProfessionFrameHasSkillUp"] = "Есть повышение навыка"
    L["ProfessionFrameHasMaterials"] = CRAFT_IS_MAKEABLE
    L["ProfessionFrameSubclass"] = "Подкласс"
    L["ProfessionFrameSlot"] = "Слот"
    L["ProfessionCheckAll"] = "Отметить все"
    L["ProfessionUnCheckAll"] = "Снять отметку со всех"
    L["ProfessionFavorites"] = "Избранное"
end

-- Tooltip
do
    L["TooltipName"] = "Подсказка"
    L["TooltipHeaderGameToltip"] = "GameTooltip"
    L["TooltipHeaderSpellTooltip"] = "SpellTooltip"

    L["TooltipCursorAnchorHeader"] = "Якорь на курсоре"
    L["TooltipCursorAnchorHeaderDesc"] = ""
    L["TooltipAnchorToMouse"] = "Якорь на курсоре"
    L["TooltipAnchorToMouseDesc"] =
        "Привязывает некоторые подсказки (например, UnitTooltip на WorldFrame) к курсору мыши."
    L["TooltipMouseAnchor"] = "Якорь на курсоре"
    L["TooltipMouseAnchorDesc"] = ""
    L["TooltipMouseX"] = "X"
    L["TooltipMouseXDesc"] = ""
    L["TooltipMouseY"] = "Y"
    L["TooltipMouseYDesc"] = ""

    -- Подсказки заклинаний
    L["TooltipAnchorSpells"] = "Якорь заклинаний"
    L["TooltipAnchorSpellsDesc"] =
        "Привязывает подсказку заклинаний на панелях действий к кнопке вместо стандартного якоря."
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

    -- Подсказки предметов
    L["TooltipHeaderItemTooltip"] = "Подсказка предмета"
    L["TooltipHeaderItemTooltipDesc"] = ""

    L["TooltipShowItemQuality"] = "Граница качества предмета"
    L["TooltipShowItemQualityDesc"] = ""
    L["TooltipShowItemQualityBackdrop"] = "Фон качества предмета"
    L["TooltipShowItemQualityBackdropDesc"] = ""
    L["TooltipShowItemStackCount"] = "Показывать размер стопки"
    L["TooltipShowItemStackCountDesc"] = ""
    L["TooltipShowItemID"] = "Показывать ID предмета"
    L["TooltipShowItemIDDesc"] = ""

    -- Подсказки юнитов
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

    L["TooltipUnitClassName"] = "Имя класса"
    L["TooltipUnitClassNameDesc"] = ""
    L["TooltipUnitTitle"] = "Показывать титул"
    L["TooltipUnitTitleDesc"] = ""
    L["TooltipUnitRealm"] = "Показывать игровой мир"
    L["TooltipUnitRealmDesc"] = ""
    L["TooltipUnitGuild"] = "Показывать гильдию"
    L["TooltipUnitGuildDesc"] = ""
    L["TooltipUnitGuildRank"] = "Показывать ранг в гильдии"
    L["TooltipUnitGuildRankDesc"] = ""
    L["TooltipUnitGuildRankIndex"] = "Показывать индекс ранга в гильдии"
    L["TooltipUnitGuildRankIndexDesc"] = ""
    L["TooltipUnitGrayOutOnDeath"] = "Серый цвет при смерти"
    L["TooltipUnitGrayOutOnDeathDesc"] = ""
    L["TooltipUnitZone"] = "Показывать текст зоны"
    L["TooltipUnitZoneDesc"] = ""
    L["TooltipUnitHealthbar"] = "Показывать полосу здоровья"
    L["TooltipUnitHealthbarDesc"] = ""
    L["TooltipUnitHealthbarText"] = "Показывать текст полосы здоровья"
    L["TooltipUnitHealthbarTextDesc"] = ""
end

-- Unitframes
do
    L["UnitFramesName"] = "Окна юнитов"
    -- Игрок
    L["PlayerFrameDesc"] = "Настройки окна игрока"
    L["PlayerFrameStyle"] = L["ButtonTableStyle"]
    L["PlayerFrameClassColor"] = "Цвет класса"
    L["PlayerFrameClassColorDesc"] = "Включить цвета класса для полосы здоровья"
    L["PlayerFrameClassIcon"] = "Иконка класса как портрет"
    L["PlayerFrameClassIconDesc"] =
        "Включить иконку класса как портрет (в настоящее время отключено)"
    L["PlayerFrameBreakUpLargeNumbers"] = "Разделять большие числа"
    L["PlayerFrameBreakUpLargeNumbersDesc"] =
        "Включить разделение больших чисел в тексте статуса (например, 7588 K вместо 7588000)"
    L["PlayerFrameBiggerHealthbar"] = "Увеличенная полоса здоровья"
    L["PlayerFrameBiggerHealthbarDesc"] = "Включить увеличенную полосу здоровья"
    L["PlayerFrameHideRedStatus"] = "Скрыть красное свечение статуса в бою"
    L["PlayerFrameHideRedStatusDesc"] = "Скрыть красное свечение статуса в бою"
    L["PlayerFrameHideHitIndicator"] = "Скрыть индикатор попадания"
    L["PlayerFrameHideHitIndicatorDesc"] =
        "Скрыть индикатор попадания на окне игрока"
    L["PlayerFrameHideSecondaryRes"] = "Скрыть вторичный ресурс"
    L["PlayerFrameHideSecondaryResDesc"] =
        "Скрыть вторичный ресурс, например, осколки души."
    L["PlayerFrameHideAlternatePowerBar"] =
        "Скрыть альтернативную полосу силы друида"
    L["PlayerFrameHideAlternatePowerBarDesc"] =
        "Скрыть альтернативную полосу силы друида (полоса маны в форме медведя/кошки)."

    -- Цель
    L["TargetFrameDesc"] = "Настройки окна цели"
    L["TargetFrameStyle"] = L["ButtonTableStyle"]
    L["TargetFrameClassColor"] = L["PlayerFrameClassColor"]
    L["TargetFrameClassColorDesc"] = "Включить цвета класса для полосы здоровья"
    L["TargetFrameClassIcon"] = L["PlayerFrameClassIcon"]
    L["TargetFrameClassIconDesc"] = L["PlayerFrameClassIconDesc"]
    L["TargetFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
    L["TargetFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
    L["TargetFrameNumericThreat"] = "Числовой показатель угрозы"
    L["TargetFrameNumericThreatDesc"] = "Включить числовой показатель угрозы"
    L["TargetFrameNumericThreatAnchor"] = "Якорь числового показателя угрозы"
    L["TargetFrameNumericThreatAnchorDesc"] =
        "Устанавливает якорь числового показателя угрозы (позицию)"
    L["TargetFrameThreatGlow"] = "Свечение угрозы"
    L["TargetFrameThreatGlowDesc"] = "Включить эффект свечения угрозы"
    L["TargetFrameHideNameBackground"] = "Скрыть фон имени"
    L["TargetFrameHideNameBackgroundDesc"] = "Скрыть фон имени цели"
    L["TargetFrameComboPointsOnPlayerFrame"] = "Очки комбо на окне игрока"
    L["TargetFrameComboPointsOnPlayerFrameDesc"] =
        "Показывать очки комбо на окне игрока."
    L["TargetFrameHideComboPoints"] = "Скрыть очки комбо"
    L["TargetFrameHideComboPointsDesc"] = "Скрывает окно очков комбо."
    L["TargetFrameFadeOut"] = "Исчезновение"
    L["TargetFrameFadeOutDesc"] =
        "Окно цели исчезает, когда цель находится на расстоянии более *Расстояние исчезновения*."
    L["TargetFrameFadeOutDistance"] = "Расстояние исчезновения"
    L["TargetFrameFadeOutDistanceDesc"] =
        "Устанавливает расстояние в ярдах для проверки эффекта исчезновения.\nПримечание: не каждое значение может иметь значение, так как используется 'LibRangeCheck-3.0'.\nВычисляется по 'minRange >= fadeOutDistance'."

    -- Питомец
    L["PetFrameDesc"] = "Настройки окна питомца"
    L["PetFrameStyle"] = L["ButtonTableStyle"]
    L["PetFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
    L["PetFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
    L["PetFrameThreatGlow"] = L["TargetFrameThreatGlow"]
    L["PetFrameThreatGlowDesc"] = L["TargetFrameThreatGlowDesc"]
    L["PetFrameHideStatusbarText"] = "Скрыть текст статусбара"
    L["PetFrameHideStatusbarTextDesc"] = "Скрыть текст статусбара"
    L["PetFrameHideIndicator"] = "Скрыть индикатор попадания"
    L["PetFrameHideIndicatorDesc"] = "Скрыть индикатор попадания"

    -- Фокус
    L["FocusFrameDesc"] = "Настройки окна фокуса"
    L["FocusFrameStyle"] = L["ButtonTableStyle"]
    L["FocusFrameClassColor"] = L["PlayerFrameClassColor"]
    L["FocusFrameClassColorDesc"] = "Включить цвета класса для полосы здоровья"
    L["FocusFrameClassIcon"] = L["PlayerFrameClassIcon"]
    L["FocusFrameClassIconDesc"] =
        "Включить иконку класса как портрет для окна фокуса"
    L["FocusFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
    L["FocusFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
    L["FocusFrameHideNameBackground"] = L["TargetFrameHideNameBackground"]
    L["FocusFrameHideNameBackgroundDesc"] = "Скрыть фон имени"

    -- Группа
    L["PartyFrameDesc"] = "Настройки окна группы"
    L["PartyFrameStyle"] = L["ButtonTableStyle"]
    L["PartyFrameClassColor"] = L["PlayerFrameClassColor"]
    L["PartyFrameClassColorDesc"] = "Включить цвета класса для полосы здоровья"
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

-- см. комментарий выше
for k, v in pairs(L) do L_RU[k] = v; end
