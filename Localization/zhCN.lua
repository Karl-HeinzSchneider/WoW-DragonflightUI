-- print('enUS')
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L_CN = LibStub("AceLocale-3.0"):NewLocale("DragonflightUI", "zhCN")
if not L_CN then return end

-- preprocess to reuse strings - without this L[XY] = L['X'] will fail in AceLocale
local L = {}

-- modules - config.lua
do
    L["ModuleModules"] = "模块"

    L["ModuleTooltipActionbar"] =
        "该模块全面改造默认动作条，包括微型菜单和背包按钮。\n为动作条1-8、宠物/经验/声望/控制/姿态/图腾条、背包和微型菜单提供独立选项。"
    L["ModuleTooltipBossframe"] = "该模块添加自定义首领框架。\n开发中。"
    L["ModuleTooltipBuffs"] =
        "该模块修改默认增益效果框架。\n为增益和减益效果提供独立选项。"
    L["ModuleTooltipCastbar"] =
        "该模块修改默认施法条。\n为玩家/焦点/目标施法条提供独立选项。"
    L["ModuleTooltipChat"] = "该模块修改默认聊天窗口。\n开发中。"
    L["ModuleTooltipCompatibility"] = "该模块为其他插件提供额外兼容性支持。"
    L["ModuleTooltipDarkmode"] =
        "该模块为DragonflightUI的多个框架添加暗黑模式。\n开发中 - 请反馈意见！"
    L["ModuleTooltipFlyout"] = "弹出按钮"
    L["ModuleTooltipMinimap"] =
        "该模块全面改造默认小地图和任务追踪器。\n为小地图和任务追踪器提供独立选项。"
    L["ModuleTooltipTooltip"] = "该模块增强游戏提示框功能。\n开发中"
    L["ModuleTooltipUI"] =
        "该模块为角色窗口等界面添加现代UI风格，并针对怀旧服重做法术书、天赋窗和专业窗口。"
    L["ModuleTooltipUnitframe"] =
        "该模块全面改造默认单位框架，添加职业染色等功能。\n为玩家/宠物/目标/焦点/小队框架提供独立选项。"
    L["ModuleTooltipUtility"] = "该模块提供通用UI功能和调整。\n开发中"

    L["ModuleFlyout"] = "弹出按钮"
    L["ModuleActionbar"] = "动作条"
    L["ModuleCastbar"] = "施法条"
    L["ModuleChat"] = "聊天框"
    L["ModuleBuffs"] = "增益"
    L["ModuleDarkmode"] = "暗黑模式"
    L["ModuleMinimap"] = "小地图"
    L["ModuleTooltip"] = "鼠标提示"
    L["ModuleUI"] = "界面"
    L["ModuleUnitframe"] = "单位框体"
    L["ModuleUtility"] = "实用工具"
    L["ModuleCompatibility"] = "插件兼容"
    L["ModuleBossframe"] = "首领框体"
end

-- config 
do
    L["ConfigGeneralWhatsNew"] = "更新"
    L["ConfigGeneralModules"] = "模块"
    L["ConfigGeneralInfo"] = "信息"
    L["MainMenuDragonflightUI"] = "DragonflightUI"
    L["MainMenuEditmode"] = "编辑模式"

    -- config.mixin.lua
    L["ConfigMixinQuickKeybindMode"] = "快速按键绑定模式"
    L["ConfigMixinGeneral"] = "通用"
    L["ConfigMixinModules"] = "模块"
    L["ConfigMixinActionBar"] = "动作条"
    L["ConfigMixinCastBar"] = "施法条"
    L["ConfigMixinMisc"] = "其他"
    L["ConfigMixinUnitframes"] = "单位框体"

    -- modules.mixin.lua
    L["ModuleConditionalMessage"] =
        "'|cff8080ff%s|r'已停用，但相关功能已被挂钩，请执行'|cff8080ff/reload|r'重载界面！"

    -- config
    L["ConfigToolbarCopyPopup"] = "复制下方链接(Ctrl+C, Enter):"
    L["ConfigToolbarDiscord"] = "Discord"
    L["ConfigToolbarDiscordTooltip"] = "交流创意与获取支持"
    L["ConfigToolbarGithub"] = "Github"
    L["ConfigToolbarGithubTooltip"] = "查看代码、提交问题与贡献"
    L["ConfigToolbarCoffee"] = "BuyMeACoffee"
    L["ConfigToolbarCoffeeTooltip1"] =
        "每个点赞分享都是支持，若您愿意，也可以请开发者喝杯咖啡继续开发！"
    L["ConfigToolbarCoffeeTooltip2"] = "支持者可享专属福利，详见Discord支持者频道。"
end

-- profiles
do
    L["ProfilesSetActiveProfile"] = "设置当前配置文件"
    L["ProfilesNewProfile"] = "创建新配置文件"
    L["ProfilesCopyFrom"] = "从现有配置复制设置到当前配置"
    L["ProfilesOpenCopyDialogue"] = "打开复制对话框"
    L["ProfilesDeleteProfile"] = "删除数据库中的配置文件"
    L["Profiles"] = "新建配置文件"
    L["ProfilesOpenDeleteDialogue"] = "打开删除对话框"
    L["ProfilesAddNewProfile"] = "添加新配置文件"
    L["ProfilesChatNewProfile"] = "新建配置文件: "
    L["ProfilesErrorNewProfile"] = "错误: 新配置文件名不能为空！"
    L["ProfilesDialogueDeleteProfile"] = "删除配置文件'%s'?"
    L["ProfilesDialogueCopyProfile"] = "新建配置文件(从'|cff8080ff%s|r'复制)"
    L["ProfilesImportShareHeader"] = "导入/分享"
    L["ProfilesImportProfile"] = "导入配置"
    L["ProfilesImportProfileButton"] = HUD_EDIT_MODE_IMPORT_LAYOUT or "导入"
    L["ProfilesImportProfileDesc"] = "打开导入对话框"
    L["ProfilesExportProfile"] = "分享配置"
    L["ProfilesExportProfileButton"] = HUD_EDIT_MODE_SHARE_LAYOUT or "分享"
    L["ProfilesExportProfileDesc"] = "打开分享对话框"
end

-- Editmode
do
    L["EditModeBasicOptions"] = "基本选项"
    L["EditModeAdvancedOptions"] = "高级选项"
    L["EditModeLayoutDropdown"] = "配置文件"
    L["EditModeCopyLayout"] = "复制配置"
    L["EditModeRenameLayout"] = ""
    L["EditModeRenameOrCopyLayout"] = "重命名/复制配置"
    L["EditModeDeleteLayout"] = "删除配置"
    L["EditModeNewLayoutDisabled"] = "%s 新建配置"
    L["EditModeNewLayout"] = "%s |cnPURE_GREEN_COLOR:新建配置|r"
    L["EditModeImportLayout"] = HUD_EDIT_MODE_IMPORT_LAYOUT or "导入"
    L["EditModeShareLayout"] = HUD_EDIT_MODE_SHARE_LAYOUT or "分享"
    L["EditModeCopyToClipboard"] = HUD_EDIT_MODE_COPY_TO_CLIPBOARD or
                                       "复制到剪贴板 |cffffd100(用于在线分享)|r"
    L["EditModeExportProfile"] = "导出配置 |cff8080ff%s|r"
    L["EditModeImportProfile"] = "导入配置为 |cff8080ff%s|r"
end

-- Compat
do
    L['CompatName'] = "插件兼容"
    L['CompatAuctionator'] = "Auctionator"
    L['CompatAuctionatorDesc'] = "当启用'修改专业窗口'时，为Auctionator添加兼容支持"
    L['CompatBaganator'] = "Baganator"
    L['CompatBaganatorDesc'] = "将默认'暴雪'皮肤改为DragonflightUI风格"
    L['CompatBaganatorEquipment'] = "Baganator_EquipmentSets"
    L['CompatBaganatorEquipmentDesc'] = "增加将装备套装作为物品来源的支持"
    L['CompatCharacterStatsClassic'] = "CharacterStatsClassic"
    L['CompatCharacterStatsClassicDesc'] =
        "当启用'修改角色窗口'时，为CharacterStatsClassic添加兼容支持"
    L['CompatClassicCalendar'] = "Classic Calendar"
    L['CompatClassicCalendarDesc'] = "为Classic Calendar添加兼容支持"
    -- L['CompatClique'] = "Clique"
    -- L['CompatCliqueDesc'] = "Adds compatibility for Clique"
    L['CompatLFGBulletinBoard'] = "LFG Bulletin Board"
    L['CompatLFGBulletinBoardDesc'] = "为LFG Bulletin Board添加兼容支持"
    L['CompatMerInspect'] = "MerInspect"
    L['CompatMerInspectDesc'] = "当启用'修改角色窗口'时，为MerInspect添加兼容支持"
    L['CompatRanker'] = "Ranker"
    L['CompatRankerDesc'] = "当启用'修改角色窗口'时，为Ranker添加兼容支持"
    L['CompatTacoTip'] = "TacoTip"
    L['CompatTacoTipDesc'] = "当启用'修改角色窗口'时，为TacoTip添加兼容支持"
    L['CompatTDInspect'] = "TDInspect"
    L['CompatTDInspectDesc'] = "当启用'修改角色窗口'时，为TDInspect添加兼容支持"
    L['CompatWhatsTraining'] = "WhatsTraining"
    L['CompatWhatsTrainingDesc'] = "当启用'修改法术书'时，为WhatsTraining添加兼容支持"
end

-- __Settings
do
    L["SettingsDefaultStringFormat"] = "\n(默认: |cff8080ff%s|r)"
    L["SettingsCharacterSpecific"] = "\n\n|cff8080ff[每个角色设置]|r"

    -- positionTable
    L["PositionTableHeader"] = "缩放与位置"
    L["PositionTableHeaderDesc"] = ""
    L["PositionTableScale"] = "缩放"
    L["PositionTableScaleDesc"] = ""
    L["PositionTableAnchor"] = "锚点"
    L["PositionTableAnchorDesc"] = "锚点"
    L["PositionTableAnchorParent"] = "父级锚点"
    L["PositionTableAnchorParentDesc"] = ""
    L["PositionTableAnchorFrame"] = "锚点框架"
    L["PositionTableAnchorFrameDesc"] = ""
    L["PositionTableCustomAnchorFrame"] = "锚点框架(自定义)"
    L["PositionTableCustomAnchorFrameDesc"] =
        "使用指定名称的框架作为锚点(如有效)。例如'CharacterFrame', 'TargetFrame'..."
    L["PositionTableX"] = "X"
    L["PositionTableXDesc"] = ""
    L["PositionTableY"] = "Y"
    L["PositionTableYDesc"] = ""
end

-- darkmode
do
    L["DarkmodeColor"] = "颜色"
    L["DarkmodeDesaturate"] = "去饱和度"
end

-- actionbar
do
    L["ActionbarName"] = "动作条"
    L["ActionbarNameFormat"] = "动作条 %d"

    -- bar names
    L["XPBar"] = "经验条"
    L["ReputationBar"] = "声望条"
    L["PetBar"] = "宠物条"
    L["StanceBar"] = "姿态条"
    L["PossessBar"] = "控制条"
    L["MicroMenu"] = "微型菜单"
    L["TotemBar"] = "图腾条"

    -- gryphonsTable
    L["Default"] = "默认"
    L["Alliance"] = "联盟"
    L["Horde"] = "部落"
    L["None"] = "无"

    -- buttonTable
    L["ButtonTableActive"] = "启用"
    L["ButtonTableActiveDesc"] = ""
    L["ButtonTableButtons"] = "按钮数"
    L["ButtonTableButtonsDesc"] = ""
    L["ButtonTableButtonScale"] = "按钮缩放"
    L["ButtonTableButtonScaleDesc"] = ""
    L["ButtonTableOrientation"] = "方向"
    L["ButtonTableOrientationDesc"] = "方向"
    L["ButtonTableGrowthDirection"] = "延展方向"
    L["ButtonTableGrowthDirectionDesc"] = ""
    L["ButtonTableReverseButtonOrder"] = "反转按钮顺序"
    L["ButtonTableReverseButtonOrderDesc"] = ""
    L["ButtonTableNumRows"] = "行数"
    L["ButtonTableNumRowsDesc"] = ""
    L["ButtonTableNumButtons"] = "按钮数量"
    L["ButtonTableNumButtonsDesc"] = ""
    L["ButtonTablePadding"] = "间距"
    L["ButtonTablePaddingDesc"] = ""
    L["ButtonTableStyle"] = "样式"
    L["ButtonTableStyleDesc"] = ""
    L["ButtonTableAlwaysShowActionbar"] = "始终显示动作条"
    L["ButtonTableAlwaysShowActionbarDesc"] = ""
    L["ButtonTableHideMacroText"] = "隐藏宏名称"
    L["ButtonTableHideMacroTextDesc"] = ""
    L["ButtonTableMacroNameFontSize"] = "宏名字体大小"
    L["ButtonTableMacroNameFontSizeDesc"] = ""
    L["ButtonTableHideKeybindText"] = "隐藏按键绑定"
    L["ButtonTableHideKeybindTextDesc"] = ""
    L["ButtonTableShortenKeybindText"] = "简化按键文本"
    L["ButtonTableShortenKeybindTextDesc"] = "简化按键文本显示，例如用'sF'代替's-F'"
    L["ButtonTableKeybindFontSize"] = "按键字体大小"
    L["ButtonTableKeybindFontSizeDesc"] = ""

    L["MoreOptionsHideBarArt"] = "隐藏条背景"
    L["MoreOptionsHideBarArtDesc"] = ""
    L["MoreOptionsHideBarScrolling"] = "隐藏条滚动动画"
    L["MoreOptionsHideBarScrollingDesc"] = ""
    L["MoreOptionsGryphons"] = "狮鹫装饰"
    L["MoreOptionsGryphonsDesc"] = "狮鹫装饰"
    L["MoreOptionsUseKeyDown"] = ACTION_BUTTON_USE_KEY_DOWN or "按下快捷键时施法"
    L["MoreOptionsUseKeyDownDesc"] = OPTION_TOOLTIP_ACTION_BUTTON_USE_KEY_DOWN or
                                         "在按下快捷键时施法，而不是在松开快捷键时施法。"
    L["MoreOptionsIconRangeColor"] = "超出距离图标染色"
    L["MoreOptionsIconRangeColorDesc"] = "当技能超出距离时改变图标颜色，类似RedRange/tullaRange效果"

    L["ExtraOptionsPreset"] = "预设"
    L["ExtraOptionsResetToDefaultPosition"] = "重置为默认位置"
    L["ExtraOptionsPresetDesc"] =
        "将缩放、锚点、X/Y等位置相关设置设为所选预设值，但不影响其他设置。"
    L["ExtraOptionsModernLayout"] = "现代布局(默认)"
    L["ExtraOptionsModernLayoutDesc"] = ""
    L["ExtraOptionsClassicLayout"] = "经典布局(侧边栏)"
    L["ExtraOptionsClassicLayoutDesc"] = ""

    -- XP
    L["XPOptionsName"] = "经验条"
    L["XPOptionsDesc"] = "经验条"
    L["XPOptionsStyle"] = L["ButtonTableStyle"]
    L["XPOptionsStyleDesc"] = ""
    L["XPOptionsWidth"] = "宽度"
    L["XPOptionsWidthDesc"] = ""
    L["XPOptionsHeight"] = "高度"
    L["XPOptionsHeightDesc"] = ""
    L["XPOptionsAlwaysShowXPText"] = "始终显示经验文本"
    L["XPOptionsAlwaysShowXPTextDesc"] = ""
    L["XPOptionsShowXPPercent"] = "显示经验百分比"
    L["XPOptionsShowXPPercentDesc"] = ""

    -- rep
    L["RepOptionsName"] = "声望条"
    L["RepOptionsDesc"] = "声望条"
    L["RepOptionsStyle"] = L["ButtonTableStyle"]
    L["RepOptionsStyleDesc"] = ""
    L["RepOptionsWidth"] = L["XPOptionsWidth"]
    L["RepOptionsWidthDesc"] = L["XPOptionsWidthDesc"]
    L["RepOptionsHeight"] = L["XPOptionsHeight"]
    L["RepOptionsHeightDesc"] = L["XPOptionsHeightDesc"]
    L["RepOptionsAlwaysShowRepText"] = "始终显示声望文本"
    L["RepOptionsAlwaysShowRepTextDesc"] = ""

    -- Bags
    L["BagsOptionsName"] = "背包"
    L["BagsOptionsDesc"] = "背包"
    L["BagsOptionsStyle"] = L["ButtonTableStyle"]
    L["BagsOptionsStyleDesc"] = ""
    L["BagsOptionsExpanded"] = "展开状态"
    L["BagsOptionsExpandedDesc"] = ""
    L["BagsOptionsHideArrow"] = "隐藏箭头"
    L["BagsOptionsHideArrowDesc"] = ""
    L["BagsOptionsHidden"] = "隐藏背包"
    L["BagsOptionsHiddenDesc"] = "隐藏主背包"
    L["BagsOptionsOverrideBagAnchor"] = "覆盖背包锚点"
    L["BagsOptionsOverrideBagAnchorDesc"] = ""
    L["BagsOptionsOffsetX"] = "背包锚点X偏移"
    L["BagsOptionsOffsetXDesc"] = ""
    L["BagsOptionsOffsetY"] = "背包锚点Y偏移"
    L["BagsOptionsOffsetYDesc"] = ""

    -- FPS
    L["FPSOptionsName"] = "帧数显示"
    L["FPSOptionsDesc"] = "帧数显示"
    L["FPSOptionsStyle"] = L["ButtonTableStyle"]
    L["FPSOptionsStyleDesc"] = ""
    L["FPSOptionsHideDefaultFPS"] = "隐藏默认帧数显示"
    L["FPSOptionsHideDefaultFPSDesc"] = "隐藏默认帧数文本"
    L["FPSOptionsShowFPS"] = "显示帧数"
    L["FPSOptionsShowFPSDesc"] = "显示自定义帧数文本"
    L["FPSOptionsAlwaysShowFPS"] = "始终显示帧数"
    L["FPSOptionsAlwaysShowFPSDesc"] = "始终显示自定义帧数文本"
    L["FPSOptionsShowPing"] = "显示延迟"
    L["FPSOptionsShowPingDesc"] = "显示延迟(毫秒)"

    -- Extra Action Button
    L["ExtraActionButtonOptionsName"] = "额外动作按钮"
    L["ExtraActionButtonOptionsNameDesc"] = "帧数显示"
    L["ExtraActionButtonStyle"] = L["ButtonTableStyle"]
    L["ExtraActionButtonStyleDesc"] = ""
    L["ExtraActionButtonHideBackgroundTexture"] = "隐藏背景纹理"
    L["ExtraActionButtonHideBackgroundTextureDesc"] = ""
end

-- Buffs
do
    L["BuffsOptionsName"] = "增益效果"
    L["BuffsOptionsStyle"] = L["ButtonTableStyle"]
    L["BuffsOptionsStyleDesc"] = ""

    L["BuffsOptionsExpanded"] = "展开状态"
    L["BuffsOptionsExpandedDesc"] = ""

    L["BuffsOptionsUseStateHandler"] = "使用状态处理器"
    L["BuffsOptionsUseStateHandlerDesc"] =
        "禁用此项将导致上方可见性设置失效，但可能提升其他插件兼容性(如MinimapAlert)，因为它不会使框架变为安全框架。"
end

-- Flyout
do
    L["FlyoutHeader"] = "弹出按钮"
    L["FlyoutHeaderDesc"] = ""
    L["FlyoutDirection"] = "弹出方向"
    L["FlyoutDirectionDesc"] = "弹出方向"
    L["FlyoutSpells"] = "法术"
    L["FlyoutSpellsDesc"] = "输入逗号分隔的法术ID, 例如 '688, 697'。"
    L["FlyoutSpellsAlliance"] = "法术 (联盟)"
    L["FlyoutSpellsAllianceDesc"] = L["FlyoutSpellsDesc"] .. "\n(仅用于联盟阵营)"
    L["FlyoutSpellsHorde"] = "法术 (部落)"
    L["FlyoutSpellsHordeDesc"] = L["FlyoutSpellsDesc"] .. "\n(仅用于部落阵营)"
    L["FlyoutItems"] = "物品"
    L["FlyoutItemsDesc"] = "输入逗号分隔的物品ID, 例如 '6948, 8490'。"

    L["FlyoutCloseAfterClick"] = "点击后关闭"
    L["FlyoutCloseAfterClickDesc"] = "按下其中一个按钮后关闭弹出框。"
    L["FlyoutAlwaysShow"] = "总是显示按钮"
    L["FlyoutAlwaysShowDesc"] =
        "总是显示子按钮，即便它们是空的。\n如果你想使用拖放，可以使用这个。"
    L["FlyoutIcon"] = "图标"
    L["FlyoutIconDesc"] = "输入材质的文件ID或文件路径。"
    L["FlyoutDisplayname"] = "显示名称"
    L["FlyoutDisplaynameDesc"] = ""
    L["FlyoutTooltip"] = "鼠标提示"
    L["FlyoutTooltipDesc"] = ""

    L["FlyoutButtonWarlock"] = "召唤"
    L["FlyoutButtonMagePort"] = "传送"
    L["FlyoutButtonMagePortals"] = "传送门"
    -- L["FlyoutButtonWarlock"] = "术士"
    L["FlyoutButtonMageFood"] = "造食术"
    L["FlyoutButtonMageWater"] = "造水术"

    L["FlyoutWarlock"] = "召唤恶魔"
    L["FlyoutWarlockDesc"] = "召唤一个恶魔到你身边。"

    L["FlyoutMagePort"] = "传送"
    L["FlyoutMagePortDesc"] = "传送你到一个主城。"
    L["FlyoutMagePortals"] = "传送门"
    L["FlyoutMagePortalsDesc"] = "开启一个传送门，传送适用它的队伍成员到一个主城。"
    L["FlyoutMageWater"] = "造水术"
    L["FlyoutMageWaterDesc"] = "如果登出超过15分钟，魔法物品会消失。"
    L["FlyoutMageFood"] = "造食术"
    L["FlyoutMageFoodDesc"] = L["FlyoutMageWaterDesc"]

    L["FlyoutButtonCustomFormat"] = "自定义弹出按钮 %d"
    L["FlyoutCustomNameFormat"] = "自定义弹出按钮 %d"
    L["FlyoutCustomNameDescFormat"] = "每个角色的弹出按钮，拥有最多12个额外的动作按钮。"

    L["FlyoutHeaderClassPresets"] = "职业预设"
    L["FlyoutHeaderClassPresetsDesc"] = "将弹出按钮预设设置为角色专有预设。"
end

-- Castbar
do
    L["CastbarName"] = "施法条"
    L["CastbarNameFormat"] = "%s 施法条"
    L["CastbarTableActive"] = "启用"
    L["CastbarTableActivateDesc"] = ""
    L["CastbarTableStyle"] = L["ButtonTableStyle"]
    L["CastbarTableStyleDesc"] = ""
    L["CastbarTableWidth"] = L["XPOptionsWidth"]
    L["CastbarTableWidthDesc"] = L["XPOptionsWidthDesc"]
    L["CastbarTableHeight"] = L["XPOptionsHeight"]
    L["CastbarTableHeightDesc"] = L["XPOptionsHeightDesc"]
    L["CastbarTablePrecisionTimeLeft"] = "精度(剩余时间)"
    L["CastbarTablePrecisionTimeLeftDesc"] = ""
    L["CastbarTablePrecisionTimeMax"] = "精度(总时间)"
    L["CastbarTablePrecisionTimeMaxDesc"] = ""
    L["CastbarTableShowCastTimeText"] = "显示施法时间文本"
    L["CastbarTableShowCastTimeTextDesc"] = ""
    L["CastbarTableShowCastTimeMaxText"] = "显示总施法时间"
    L["CastbarTableShowCastTimeMaxTextDesc"] = ""
    L["CastbarTableCompactLayout"] = "紧凑布局"
    L["CastbarTableCompactLayoutDesc"] = ""
    L["CastbarTableHoldTimeSuccess"] = "保持时间(成功)"
    L["CastbarTableHoldTimeSuccessDesc"] = "施法成功后施法条开始淡出的时间"
    L["CastbarTableHoldTimeInterrupt"] = "保持时间(打断)"
    L["CastbarTableHoldTimeInterruptDesc"] = "施法被打断后施法条开始淡出的时间"
    L["CastbarTableShowIcon"] = "显示图标"
    L["CastbarTableShowIconDesc"] = ""
    L["CastbarTableIconSize"] = "图标大小"
    L["CastbarTableIconSizeDesc"] = ""
    L["CastbarTableShowTicks"] = "显示周期标记"
    L["CastbarTableShowTicksDesc"] = ""
    L["CastbarTableAutoAdjust"] = "自动调整"
    L["CastbarTableAutoAdjustDesc"] =
        "根据增益/减益数量自动调整Y轴偏移 - 当施法条锚定在目标/焦点框架下方时很有用"
    L["CastbarTableShowRank"] = "显示等级"
    L["CastbarTableShowRankDesc"] = ""
    L["CastbarTableShowChannelName"] = "显示引导名称"
    L["CastbarTableShowChannelNameDesc"] = "显示法术名称而非默认文本(如'引导中')"

    L["ExtraOptionsResetToDefaultStyle"] = "重置为默认样式"
    L["ExtraOptionsPresetStyleDesc"] = "重置所有影响施法条样式的设置，但不影响其他设置。"
end

-- Minimap
do
    L["MinimapName"] = "小地图"
    L["MinimapStyle"] = L["ButtonTableStyle"]
    L["MinimapShowPing"] = "显示点击信号"
    L["MinimapNotYetImplemented"] = "(尚未实现)"
    L["MinimapShowPingInChat"] = "在聊天框显示点击信号"
    L["MinimapHideCalendar"] = "隐藏日历按钮"
    L["MinimapHideCalendarDesc"] = "隐藏日历按钮"
    L["MinimapHideZoomButtons"] = "隐藏缩放按钮"
    L["MinimapHideZoomDesc"] = "隐藏缩放按钮(+)(-)"
    L["MinimapSkinMinimapButtons"] = "美化小地图按钮"
    L["MinimapSkinMinimapButtonsDesc"] = "使用LibDBIcon美化小地图按钮(多数插件使用此库)"
    L["MinimapZonePanelPosition"] = "区域面板位置"
    L["MinimapZonePanelPositionDesc"] =
        "设置区域文本面板的位置，包括锚定在上面的框体（例如：日历、跟踪、邮件等）。"
    L["MinimapUseStateHandler"] = "使用状态处理器"
    L["MinimapUseStateHandlerDesc"] =
        "禁用此项将导致上方可见性设置失效，但可能提升其他插件兼容性(如MinimapAlert)，因为它不会使框架变为安全框架。"
end

-- UI
do
    L["UIUtility"] = "实用功能"
    L["UIChangeBags"] = "修改背包"
    L["UIChangeBagsDesc"] = ""
    L["UIColoredInventoryItems"] = "物品品质染色"
    L["UIColoredInventoryItemsDesc"] = "根据物品品质显示不同颜色边框"
    L["UIShowQuestlevel"] = "显示任务等级"
    L["UIShowQuestlevelDesc"] = "在任务名称旁显示任务等级"
    L["UIFrames"] = "窗口框架"
    L["UIFramesDesc"] = "修改各类游戏窗口的选项"
    L["UIChangeCharacterFrame"] = "修改角色窗口"
    L["UIChangeCharacterFrameDesc"] = "修改角色窗口外观"
    L["UIChangeProfessionWindow"] = "修改专业窗口"
    L["UIChangeProfessionWindowDesc"] = "修改专业窗口外观"
    L["UIChangeInspectFrame"] = "修改观察窗口"
    L["UIChangeInspectFrameDesc"] = "修改观察其他玩家时的窗口外观"
    L["UIChangeTrainerWindow"] = "修改训练师窗口"
    L["UIChangeTrainerWindowDesc"] = "修改训练师窗口外观"
    L["UIChangeTalentFrame"] = "修改天赋窗口"
    L["UIChangeTalentFrameDesc"] = "修改天赋窗口布局和外观(巫妖王版本不可用)"
    L["UIChangeSpellBook"] = "修改法术书"
    L["UIChangeSpellBookDesc"] = "修改法术书外观"
    L["UIChangeSpellBookProfessions"] = "修改专业技能法术书"
    L["UIChangeSpellBookProfessionsDesc"] = "修改专业技能法术书布局"

    -- Characterstatspanel
    L['CharacterStatsHitMeleeTooltipFormat'] = "使你的近战攻击命中%d级目标的几率提高%.2f%%。"
    L['CharacterStatsArp'] = "护甲穿透"
    L['CharacterStatsArpTooltipFormat'] = "护甲穿透等级 %d \n(敌人的护甲最多减少%.2f%%)."
    L['CharacterStatsHitSpellTooltipFormat'] = "使你的法术命中%d级目标的几率提高%.2f%%。"
    L['CharacterStatsSpellPen'] = "法术穿透"
    L['CharacterStatsSpellPenTooltipFormat'] = "法术穿透%d\n（降低目标抗性%d点）。"

    -- ProfessionFrame
    L["ProfessionFrameHasSkillUp"] = "可提升技能"
    L["ProfessionFrameHasMaterials"] = CRAFT_IS_MAKEABLE or "材料齐备"
    L["ProfessionFrameSubclass"] = "子类别"
    L["ProfessionFrameSlot"] = "装备部位"
    L["ProfessionCheckAll"] = "全选"
    L["ProfessionUnCheckAll"] = "取消全选"
    L["ProfessionFavorites"] = "收藏"
end

-- Tooltip
do
    L["TooltipName"] = "提示框"
    L["TooltipHeaderGameToltip"] = "游戏提示框"
    L["TooltipHeaderSpellTooltip"] = "法术提示框"

    L["TooltipCursorAnchorHeader"] = "鼠标锚点"
    L["TooltipCursorAnchorHeaderDesc"] = ""
    L["TooltipAnchorToMouse"] = "锚定到鼠标"
    L["TooltipAnchorToMouseDesc"] = "将部分提示框(如世界框架的单位提示)锚定到鼠标光标"
    L["TooltipMouseAnchor"] = "鼠标锚点"
    L["TooltipMouseAnchorDesc"] = ""
    L["TooltipMouseX"] = "X轴"
    L["TooltipMouseXDesc"] = ""
    L["TooltipMouseY"] = "Y轴"
    L["TooltipMouseYDesc"] = ""

    -- spelltooltip
    L["TooltipAnchorSpells"] = "法术锚点"
    L["TooltipAnchorSpellsDesc"] = "将动作条上的法术提示框锚定到按钮而非默认位置"
    L["TooltipShowSpellID"] = "显示法术ID"
    L["TooltipShowSpellIDDesc"] = ""
    L["TooltipShowSpellSource"] = "显示法术来源"
    L["TooltipShowSpellSourceDesc"] = ""
    L["TooltipShowSpellIcon"] = "显示法术图标"
    L["TooltipShowSpellIconDesc"] = ""
    L["TooltipShowIconID"] = "显示图标ID"
    L["TooltipShowIconIDDesc"] = ""

    L["TooltipShowIcon"] = "显示图标"
    L["TooltipShowIconDesc"] = ""

    -- itemtooltip
    L["TooltipHeaderItemTooltip"] = "物品提示框"
    L["TooltipHeaderItemTooltipDesc"] = ""

    L["TooltipShowItemQuality"] = "物品品质边框"
    L["TooltipShowItemQualityDesc"] = ""
    L["TooltipShowItemQualityBackdrop"] = "物品品质背景"
    L["TooltipShowItemQualityBackdropDesc"] = ""
    L["TooltipShowItemStackCount"] = "显示堆叠数量"
    L["TooltipShowItemStackCountDesc"] = ""
    L["TooltipShowItemID"] = "显示物品ID"
    L["TooltipShowItemIDDesc"] = ""

    -- unittooltip
    L["TooltipUnitTooltip"] = "单位提示框"
    L["TooltipUnitTooltipDesc"] = ""

    L["TooltipUnitClassBorder"] = "职业边框"
    L["TooltipUnitClassBorderDesc"] = ""
    L["TooltipUnitClassBackdrop"] = "职业背景"
    L["TooltipUnitClassBackdropDesc"] = ""

    L["TooltipUnitReactionBorder"] = "声望边框"
    L["TooltipUnitReactionBorderDesc"] = ""
    L["TooltipUnitReactionBackdrop"] = "声望背景"
    L["TooltipUnitReactionBackdropDesc"] = ""

    L["TooltipUnitClassName"] = "职业名称"
    L["TooltipUnitClassNameDesc"] = ""
    L["TooltipUnitTitle"] = "显示头衔"
    L["TooltipUnitTitleDesc"] = ""
    L["TooltipUnitRealm"] = "显示服务器"
    L["TooltipUnitRealmDesc"] = ""
    L["TooltipUnitGuild"] = "显示公会"
    L["TooltipUnitGuildDesc"] = ""
    L["TooltipUnitGuildRank"] = "显示公会等级"
    L["TooltipUnitGuildRankDesc"] = ""
    L["TooltipUnitGuildRankIndex"] = "显示公会等级序号"
    L["TooltipUnitGuildRankIndexDesc"] = ""
    L["TooltipUnitGrayOutOnDeath"] = "死亡变灰"
    L["TooltipUnitGrayOutOnDeathDesc"] = ""
    L["TooltipUnitZone"] = "显示区域文本"
    L["TooltipUnitZoneDesc"] = ""
    L["TooltipUnitHealthbar"] = "显示生命条"
    L["TooltipUnitHealthbarDesc"] = ""
    L["TooltipUnitHealthbarText"] = "显示生命条文本"
    L["TooltipUnitHealthbarTextDesc"] = ""
    L["TooltipUnitTarget"] = "显示目标"
    L["TooltipUnitTargetDesc"] = "显示单位目标"
end

-- Unitframes
do
    L["UnitFramesName"] = "单位框架"

    -- Player
    L["PlayerFrameDesc"] = "玩家框架设置"
    L["PlayerFrameStyle"] = L["ButtonTableStyle"]
    L["PlayerFrameClassColor"] = "职业颜色"
    L["PlayerFrameClassColorDesc"] = "生命条使用职业颜色"
    L["PlayerFrameClassIcon"] = "职业图标头像"
    L["PlayerFrameClassIconDesc"] = "使用职业图标作为头像(当前禁用)"
    L["PlayerFrameBreakUpLargeNumbers"] = "数字分段显示"
    L["PlayerFrameBreakUpLargeNumbersDesc"] = "在状态文本中使用分段数字显示(如显示7588 K而非7588000)"
    L["PlayerFrameBiggerHealthbar"] = "加宽生命条"
    L["PlayerFrameBiggerHealthbarDesc"] = "启用更宽的生命条"
    L["PlayerFramePortraitExtra"] = "头像边框"
    L["PlayerFramePortraitExtraDesc"] =
        "在玩家框体周围显示一个精英、稀有或世界首领样式的边框。"
    L["PlayerFrameHideRedStatus"] = "隐藏战斗红色光效"
    L["PlayerFrameHideRedStatusDesc"] = "隐藏战斗中的红色状态光效"
    L["PlayerFrameHideHitIndicator"] = "隐藏命中指示器"
    L["PlayerFrameHideHitIndicatorDesc"] = "隐藏玩家框架上的命中指示器"
    L["PlayerFrameHideSecondaryRes"] = "隐藏次要资源"
    L["PlayerFrameHideSecondaryResDesc"] = "隐藏次要资源条，如灵魂碎片"
    L["PlayerFrameHideAlternatePowerBar"] = "隐藏德鲁伊备用能量条"
    L["PlayerFrameHideAlternatePowerBarDesc"] = "隐藏德鲁伊熊/猫形态时的备用能量条(法力条)"

    -- Target
    L["TargetFrameDesc"] = "目标框架设置"
    L["TargetFrameStyle"] = L["ButtonTableStyle"]
    L["TargetFrameClassColor"] = L["PlayerFrameClassColor"]
    L["TargetFrameClassColorDesc"] = "生命条使用职业颜色"
    L["TargetFrameClassIcon"] = L["PlayerFrameClassIcon"]
    L["TargetFrameClassIconDesc"] = L["PlayerFrameClassIconDesc"]
    L["TargetFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
    L["TargetFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
    L["TargetFrameNumericThreat"] = "数值化仇恨值"
    L["TargetFrameNumericThreatDesc"] = "显示数值化仇恨百分比"
    L["TargetFrameNumericThreatAnchor"] = "仇恨值锚点"
    L["TargetFrameNumericThreatAnchorDesc"] = "设置仇恨值显示位置"
    L["TargetFrameThreatGlow"] = "仇恨光效"
    L["TargetFrameThreatGlowDesc"] = "启用仇恨光效"
    L["TargetFrameHideNameBackground"] = "隐藏名称背景"
    L["TargetFrameHideNameBackgroundDesc"] = "隐藏目标名称的背景"
    L["TargetFrameComboPointsOnPlayerFrame"] = "连击点显示在玩家框架"
    L["TargetFrameComboPointsOnPlayerFrameDesc"] = "在玩家框架上显示连击点数"
    L["TargetFrameHideComboPoints"] = "隐藏连击点"
    L["TargetFrameHideComboPointsDesc"] = "隐藏连击点数框架"
    L["TargetFrameFadeOut"] = "淡出效果"
    L["TargetFrameFadeOutDesc"] = "当目标距离超过*淡出距离*时淡出目标框架"
    L["TargetFrameFadeOutDistance"] = "淡出距离"
    L["TargetFrameFadeOutDistanceDesc"] =
        "设置触发淡出效果的距离(码)。\n注意: 并非所有值都有效，因使用'LibRangeCheck-3.0'库。\n计算方式为'最小距离 >= 淡出距离'"

    -- Target Buffs/Debuffs section (not in zhCN.lua)
    -- L["TargetFrameHeaderBuffs"] = "Buffs/Debuffs"
    -- L["TargetFrameAuraSizeSmall"] = "Aura Size Small"
    -- L["TargetFrameAuraSizeSmallDesc"] = "Sets the size of non player auras on the TargetFrame when using 'Dynamic Buff Size'."
    -- L["TargetFrameAuraSizeLarge"] = "Aura Size"
    -- L["TargetFrameAuraSizeLargeDesc"] = "Sets the size of an aura on the TargetFrame."
    -- L["TargetFrameNoDebuffFilter"] = "Show All Enemy Debuffs"
    -- L["TargetFrameNoDebuffFilterDesc"] = "Displays friendly and enemy debuffs on the TargetFrame, and not just your own."
    -- L["TargetFrameDynamicBuffSize"] = "Dynamic Buff Size"
    -- L["TargetFrameDynamicBuffSizeDesc"] = "Increases the size of the player buffs and debuffs on the target."

    -- Pet
    L["PetFrameDesc"] = "宠物框架设置"
    L["PetFrameStyle"] = L["ButtonTableStyle"]
    L["PetFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
    L["PetFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
    L["PetFrameThreatGlow"] = L["TargetFrameThreatGlow"]
    L["PetFrameThreatGlowDesc"] = L["TargetFrameThreatGlowDesc"]
    L["PetFrameHideStatusbarText"] = "隐藏状态条文本"
    L["PetFrameHideStatusbarTextDesc"] = "隐藏状态条文本"
    L["PetFrameHideIndicator"] = "隐藏命中指示器"
    L["PetFrameHideIndicatorDesc"] = "隐藏命中指示器"

    -- Focus
    L["FocusFrameDesc"] = "焦点框架设置"
    L["FocusFrameStyle"] = L["ButtonTableStyle"]
    L["FocusFrameClassColor"] = L["PlayerFrameClassColor"]
    L["FocusFrameClassColorDesc"] = "生命条使用职业颜色"
    L["FocusFrameClassIcon"] = L["PlayerFrameClassIcon"]
    L["FocusFrameClassIconDesc"] = "为焦点框架使用职业图标作为头像"
    L["FocusFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
    L["FocusFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
    L["FocusFrameHideNameBackground"] = L["TargetFrameHideNameBackground"]
    L["FocusFrameHideNameBackgroundDesc"] = "隐藏焦点名称背景"

    -- party
    L["PartyFrameDesc"] = "小队框架设置"
    L["PartyFrameStyle"] = L["ButtonTableStyle"]
    L["PartyFrameClassColor"] = L["PlayerFrameClassColor"]
    L["PartyFrameClassColorDesc"] = "生命条使用职业颜色"
    L["PartyFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
    L["PartyFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
end

-- keybindings
do
    local KEY_REPLACEMENTS = {
        ["ALT%-"] = "A",
        ["CTRL%-"] = "C",
        ["SHIFT%-"] = "S",
        ["META%-"] = "C", -- Note: META is also mapped to C like CTRL
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
    for i = 1, NUM_MOUSE_BUTTONS do KEY_REPLACEMENTS["BUTTON" .. i] = "鼠标" .. i end

    for k, v in pairs(KEY_REPLACEMENTS) do L_CN[k] = v; end
    DF.KEY_REPLACEMENTS = KEY_REPLACEMENTS;
end

-- see comment above
for k, v in pairs(L) do L_CN[k] = v; end
