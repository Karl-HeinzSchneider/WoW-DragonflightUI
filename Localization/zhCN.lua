-- print('zhCN') - Translator ***
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L_CN = LibStub("AceLocale-3.0"):NewLocale("DragonflightUI", "zhCN")

if not L_CN then return end

local L = {}

-- modules - config.lua
L["ModuleModules"] = "模块"

L["ModuleTooltipActionbar"] =
    "此模块彻底改进了默认的动作条，包括微型菜单和背包按钮。\n为动作条 1-8、宠物/经验/声望/控制/姿态/图腾条、背包和微型菜单添加了单独的选项。"
L["ModuleTooltipBossframe"] = "此模块添加了自定义的首领框架。\n正在进行中。"
L["ModuleTooltipBuffs"] = "此模块更改了默认的增益框架。\n为增益和减益添加了单独的选项。"
L["ModuleTooltipCastbar"] =
    "此模块更改了默认的施法条。\n为玩家、焦点和目标施法条添加了单独的选项。"
L["ModuleTooltipChat"] = "此模块更改了默认的聊天窗口。\n正在进行中。"
L["ModuleTooltipDarkmode"] =
    "此模块为 DragonflightUI 的多个框架添加了暗黑模式。\n正在进行中 - 请提供反馈！"
L["ModuleTooltipMinimap"] =
    "此模块彻底改进了默认的小地图和任务追踪器。\n为小地图和任务追踪器添加了单独的选项。"
L["ModuleTooltipTooltip"] = "此模块增强了游戏提示框。\n正在进行中"
L["ModuleTooltipUI"] =
    "此模块为不同窗口（如角色框架）添加了现代 UI 风格。还为经典版本添加了新的法术书、天赋框架或专业窗口的重做。"
L["ModuleTooltipUnitframe"] =
    "此模块彻底改进了默认的单位框架，并添加了新功能，如职业颜色或怪物生命值（经典版本）。\n为玩家、宠物、目标、焦点和队伍单位框架添加了单独的选项。"
L["ModuleTooltipUtility"] = "此模块添加了通用的 UI 功能和调整。\n正在进行中"

-- profiles
L["ProfilesSetActiveProfile"] = "设置激活的配置文件。"
L["ProfilesNewProfile"] = "创建一个新的配置文件。"
L["ProfilesCopyFrom"] = "将现有配置文件的设置复制到当前激活的配置文件中。"
L["ProfilesOpenCopyDialogue"] = "打开复制对话框。"
L["ProfilesDeleteProfile"] = "从数据库中删除现有的配置文件。"
L["Profiles"] = "添加新配置文件"

L["ProfilesOpenDeleteDialogue"] = "打开删除对话框。"

L["ProfilesAddNewProfile"] = "添加新配置文件"

L["ProfilesChatNewProfile"] = "新建配置文件："
L["ProfilesErrorNewProfile"] = "错误：新配置文件名不能为空！"

L["ProfilesDialogueDeleteProfile"] = "删除配置文件 '%s'？"
L["ProfilesDialogueCopyProfile"] = "添加新配置文件（从 '|cff8080ff%s|r' 复制）"

-- Editmode
L["EditModeBasicOptions"] = "基本选项"
L["EditModeAdvancedOptions"] = "高级选项"
L["EditModeLayoutDropdown"] = "配置文件"
L["EditModeCopyLayout"] = "复制配置文件"
L["EditModeRenameLayout"] = ""
L["EditModeRenameOrCopyLayout"] = "重命名/复制配置文件"
L["EditModeDeleteLayout"] = "删除配置文件"
L["EditModeNewLayoutDisabled"] = "%s 新建配置文件"
L["EditModeNewLayout"] = "%s |cnPURE_GREEN_COLOR:新建配置文件|r"

L["EditModeImportLayout"] = HUD_EDIT_MODE_IMPORT_LAYOUT or "导入"
L["EditModeShareLayout"] = HUD_EDIT_MODE_SHARE_LAYOUT or "分享"
L["EditModeCopyToClipboard"] = HUD_EDIT_MODE_COPY_TO_CLIPBOARD or
                                   "复制到剪贴板 |cffffd100（用于在线分享）|r"

L["EditModeExportProfile"] = "导出配置文件 |cff8080ff%s|r"
L["EditModeImportProfile"] = "导入配置文件为 |cff8080ff%s|r"

-- __Settings
L["SettingsDefaultStringFormat"] = "\n（默认：|cff8080ff%s|r）"

-- positionTable
L["PositionTableHeader"] = "缩放和位置"
L["PositionTableHeaderDesc"] = "缩放和位置"
L["PositionTableScale"] = "缩放"
L["PositionTableScaleDesc"] = "缩放"
L["PositionTableAnchor"] = "锚点"
L["PositionTableAnchorDesc"] = "锚点"
L["PositionTableAnchorParent"] = "锚点父级"
L["PositionTableAnchorParentDesc"] = "锚点父级"
L["PositionTableAnchorFrame"] = "锚点框架"
L["PositionTableAnchorFrameDesc"] = "锚点框架"
L["PositionTableX"] = "X"
L["PositionTableXDesc"] = "X"
L["PositionTableY"] = "Y"
L["PositionTableYDesc"] = "Y"

-- darkmode
L["Dark Mode"] = "深色模式"
L["DarkmodeColor"] = "颜色"
L["Desaturate"] = "去饱和度"
L["DarkmodeDesaturate"] = "去饱和度"

-- actionbar
L["ActionbarName"] = "动作条"
L["ActionbarNameFormat"] = "动作条 %d"

-- bar names
L["XPBar"] = "经验条"
L["XPbar"] = "经验条"
L["ReputationBar"] = "声望条"
L["Repbar"] = "声望条"
L["PetBar"] = "宠物条"
L["Petbar"] = "宠物条"
L["StanceBar"] = "姿态条"
L["Stancebar"] = "姿态条"
L["PossessBar"] = "控制条"
L["Possessbar"] = "控制条"
L["MicroMenu"] = "微型菜单"
L["Micromenu"] = "微型菜单"
L["TotemBar"] = "图腾条"
L["Totembar"] = "图腾条"
L["Bags"] = "背包"
L["FPS"] = "帧率"
L["Extra Action Button"] = "额外动作按钮"

-- gryphonsTable
L["Default"] = "默认"
L["Alliance"] = "联盟"
L["Horde"] = "部落"
L["None"] = "无"

-- buttonTable
L["ButtonTableActive"] = "激活"
L["ButtonTableActiveDesc"] = "激活"

L["ButtonTableButtons"] = "按钮"
L["ButtonTableButtonsDesc"] = "按钮"

L["ButtonTableButtonScale"] = "按钮缩放"
L["ButtonTableButtonScaleDesc"] = "按钮缩放"

L["ButtonTableOrientation"] = "方向"
L["ButtonTableOrientationDesc"] = "方向"

L["ButtonTableReverseButtonOrder"] = "反转按钮顺序"
L["ButtonTableReverseButtonOrderDesc"] = "反转按钮顺序"

L["ButtonTableNumRows"] = "行数"
L["ButtonTableNumRowsDesc"] = "行数"

L["ButtonTableNumButtons"] = "按钮数量"
L["ButtonTableNumButtonsDesc"] = "按钮数量"

L["ButtonTablePadding"] = "间距"
L["ButtonTablePaddingDesc"] = "按钮间的水平和纵向间距"

L["ButtonTableStyle"] = "样式"
L["ButtonTableStyleDesc"] = "样式"

L["ButtonTableAlwaysShowActionbar"] = "始终显示动作条"
L["ButtonTableAlwaysShowActionbarDesc"] = "始终显示动作条"

L["ButtonTableHideMacroText"] = "隐藏宏文本"
L["ButtonTableHideMacroTextDesc"] = "隐藏宏文本"

L["ButtonTableMacroNameFontSize"] = "宏名称字体大小"
L["ButtonTableMacroNameFontSizeDesc"] = "宏名称字体大小"

L["ButtonTableHideKeybindText"] = "隐藏按键绑定文本"
L["ButtonTableHideKeybindTextDesc"] = "隐藏按键绑定文本"

L["ButtonTableKeybindFontSize"] = "按键绑定字体大小"
L["ButtonTableKeybindFontSizeDesc"] = "按键绑定字体大小"

L["MoreOptionsHideBarArt"] = "隐藏条艺术"
L["MoreOptionsHideBarArtDesc"] = "隐藏条艺术"

L["MoreOptionsHideBarScrolling"] = "隐藏条滚动"
L["MoreOptionsHideBarScrollingDesc"] = "隐藏条滚动"

L["MoreOptionsGryphons"] = "狮鹫"
L["MoreOptionsGryphonsDesc"] = "狮鹫"

L["MoreOptionsIconRangeColor"] = "图标范围颜色"
L["MoreOptionsIconRangeColorDesc"] = "当超出范围时更改图标颜色，类似于 RedRange/tullaRange"

L["ExtraOptionsPreset"] = "预设"
L["ExtraOptionsResetToDefaultPosition"] = "重置为默认位置"
L["ExtraOptionsPresetDesc"] =
    "将缩放、锚点、锚点父级、锚点框架、X 和 Y 设置为所选预设的值，但不更改任何其他设置。"

L["ExtraOptionsModernLayout"] = "现代布局（默认）"
L["ExtraOptionsModernLayoutDesc"] = "现代布局（默认）"

L["ExtraOptionsClassicLayout"] = "经典布局（侧边栏）"
L["ExtraOptionsClassicLayoutDesc"] = "经典布局（侧边栏）"

-- XP
L["XPOptionsName"] = "经验值"
L["XPOptionsDesc"] = "经验值"

L["XPOptionsStyle"] = L["ButtonTableStyle"]
L["XPOptionsStyleDesc"] = L["ButtonTableStyle"]

L["XPOptionsWidth"] = "宽度"
L["XPOptionsWidthDesc"] = "宽度"

L["XPOptionsHeight"] = "高度"
L["XPOptionsHeightDesc"] = "高度"

L["XPOptionsAlwaysShowXPText"] = "始终显示经验值文本"
L["XPOptionsAlwaysShowXPTextDesc"] = "始终显示经验值文本"

L["XPOptionsShowXPPercent"] = "显示经验值百分比"
L["XPOptionsShowXPPercentDesc"] = "显示经验值百分比"

-- rep
L["RepOptionsName"] = "声望"
L["RepOptionsDesc"] = "声望"

L["RepOptionsStyle"] = L["ButtonTableStyle"]
L["RepOptionsStyleDesc"] = L["ButtonTableStyle"]

L["RepOptionsWidth"] = L["XPOptionsWidth"]
L["RepOptionsWidthDesc"] = L["XPOptionsWidthDesc"]

L["RepOptionsHeight"] = L["XPOptionsHeight"]
L["RepOptionsHeightDesc"] = L["XPOptionsHeightDesc"]

L["RepOptionsAlwaysShowRepText"] = "始终显示声望文本"
L["RepOptionsAlwaysShowRepTextDesc"] = "始终显示声望文本"

-- Bags
L["BagsOptionsName"] = "背包"
L["BagsOptionsDesc"] = "背包"

L["BagsOptionsStyle"] = L["ButtonTableStyle"]
L["BagsOptionsStyleDesc"] = L["ButtonTableStyle"]

L["BagsOptionsExpanded"] = "扩展"
L["BagsOptionsExpandedDesc"] = "扩展"

L["BagsOptionsHideArrow"] = "隐藏箭头"
L["BagsOptionsHideArrowDesc"] = "隐藏箭头"

L["BagsOptionsHidden"] = "隐藏背包"
L["BagsOptionsHiddenDesc"] = "隐藏背包"

L["BagsOptionsOverrideBagAnchor"] = "覆盖背包锚点"
L["BagsOptionsOverrideBagAnchorDesc"] = "覆盖背包锚点"

L["BagsOptionsOffsetX"] = "背包锚点X偏移"
L["BagsOptionsOffsetXDesc"] = "背包锚点X偏移"

L["BagsOptionsOffsetY"] = "背包锚点Y偏移"
L["BagsOptionsOffsetYDesc"] = "背包锚点Y偏移"

-- FPS
L["FPSOptionsName"] = "帧率"
L["FPSOptionsDesc"] = "帧率"

L["FPSOptionsStyle"] = L["ButtonTableStyle"]
L["FPSOptionsStyleDesc"] = L["ButtonTableStyle"]
L["FPSOptionsHideDefaultFPS"] = "隐藏默认FPS"
L["FPSOptionsHideDefaultFPSDesc"] = "隐藏默认FPS文本"

L["FPSOptionsShowFPS"] = "显示FPS"
L["FPSOptionsShowFPSDesc"] = "显示自定义FPS文本"

L["FPSOptionsAlwaysShowFPS"] = "始终显示 FPS"
L["FPSOptionsAlwaysShowFPSDesc"] = "始终显示自定义 FPS 文本"

L["FPSOptionsShowPing"] = "显示延迟"
L["FPSOptionsShowPingDesc"] = "显示延迟（毫秒）"

-- Extra Action Button
L["ExtraActionButtonOptionsName"] = "额外动作按钮"
L["ExtraActionButtonOptionsNameDesc"] = "帧率"
L["ExtraActionButtonStyle"] = L["ButtonTableStyle"]
L["ExtraActionButtonStyleDesc"] = L["ButtonTableStyle"]
L["ExtraActionButtonHideBackgroundTexture"] = "隐藏背景纹理"
L["ExtraActionButtonHideBackgroundTextureDesc"] = "隐藏背景纹理"
-- Buffs
L["Debuffs"] = "Debuff"
L["BuffsOptionsName"] = "增益效果"
L["BuffsOptionsStyle"] = L["ButtonTableStyle"]
L["BuffsOptionsStyleDesc"] = L["ButtonTableStyle"]

L["BuffsOptionsExpanded"] = "扩展"
L["BuffsOptionsExpandedDesc"] = "扩展"

L["BuffsOptionsUseStateHandler"] = "使用状态处理器"
L["BuffsOptionsUseStateHandlerDesc"] =
    "如果没有此选项，上述可见性设置将不起作用，但可能会提高其他插件的兼容性（例如 MinimapAlert），因为它不会使框架安全。"

-- Castbar
L["CastbarName"] = "施法条"
L["CastbarNameFormat"] = "%s 施法条"
L["CastbarTableActive"] = "激活"
L["CastbarTableActivateDesc"] = "激活"
L["CastbarTableStyle"] = L["ButtonTableStyle"]
L["CastbarTableStyleDesc"] = L["ButtonTableStyle"]
L["CastbarTableWidth"] = L["XPOptionsWidth"]
L["CastbarTableWidthDesc"] = L["XPOptionsWidthDesc"]
L["CastbarTableHeight"] = L["XPOptionsHeight"]
L["CastbarTableHeightDesc"] = L["XPOptionsHeightDesc"]
L["CastbarTablePrecisionTimeLeft"] = "精度（剩余时间）"
L["CastbarTablePrecisionTimeLeftDesc"] = "精度（剩余时间）"
L["CastbarTablePrecisionTimeMax"] = "精度（最大时间）"
L["CastbarTablePrecisionTimeMaxDesc"] = "精度（最大时间）"
L["CastbarTableShowCastTimeText"] = "显示施法时间文本"
L["CastbarTableShowCastTimeTextDesc"] = "显示施法时间文本"
L["CastbarTableShowCastTimeMaxText"] = "显示最大施法时间文本"
L["CastbarTableShowCastTimeMaxTextDesc"] = "显示最大施法时间文本"
L["CastbarTableCompactLayout"] = "紧凑布局"
L["CastbarTableCompactLayoutDesc"] = "紧凑布局"
L["CastbarTableHoldTimeSuccess"] = "保持时间（成功）"
L["CastbarTableHoldTimeSuccessDesc"] = "施法成功后施法条开始淡出的时间。"
L["CastbarTableHoldTimeInterrupt"] = "保持时间（打断）"
L["CastbarTableHoldTimeInterruptDesc"] = "施法被打断后施法条开始淡出的时间。"
L["CastbarTableShowIcon"] = "显示图标"
L["CastbarTableShowIconDesc"] = "显示图标"
L["CastbarTableIconSize"] = "图标大小"
L["CastbarTableIconSizeDesc"] = "图标大小"
L["CastbarTableShowTicks"] = "显示跳数"
L["CastbarTableShowTicksDesc"] = "显示跳数"
L["CastbarTableAutoAdjust"] = "自动调整"
L["CastbarTableAutoAdjustDesc"] =
    "根据增益/减益的数量应用 Y 偏移 - 在将施法条锚定到目标/焦点框架下方时很有用。"
L["CastbarTableShowRank"] = "显示等级"
L["CastbarTableShowRankDesc"] = "显示等级"
L["CastbarTableShowChannelName"] = "显示频道名称"
L["CastbarTableShowChannelNameDesc"] = "显示法术名称而不是显示文本（例如 '引导中'）。"

L["ExtraOptionsResetToDefaultStyle"] = "重置为默认样式"
L["ExtraOptionsPresetStyleDesc"] = "设置所有更改施法条样式的选项，但不更改任何其他设置。"

-- Minimap
L["MinimapName"] = "小地图"
L["MinimapStyle"] = L["ButtonTableStyle"]
L["MinimapShowPing"] = "显示延迟"
L["MinimapNotYetImplemented"] = "(尚未实现)"
L["MinimapShowPingInChat"] = "在聊天中显示延迟"
L["MinimapHideCalendar"] = "隐藏日历"
L["MinimapHideCalendarDesc"] = "隐藏日历按钮"
L["MinimapHideZoomButtons"] = "隐藏缩放按钮"
L["MinimapHideZoomDesc"] = "隐藏缩放按钮 (+) (-)"
L["MinimapSkinMinimapButtons"] = "美化小地图按钮"
L["MinimapSkinMinimapButtonsDesc"] =
    "使用 LibDBIcon 更改小地图按钮的样式（大多数插件使用此功能）"
L["MinimapUseStateHandler"] = "使用状态处理器"
L["MinimapUseStateHandlerDesc"] =
    "如果没有此选项，上述可见性设置将不起作用，但可能会提高其他插件的兼容性（例如 MinimapAlert），因为它不会使框架安全。"

-- UI
L["UIUtility"] = "实用工具"
L["UIChangeBags"] = "更改背包"
L["UIChangeBagsDesc"] = "更改背包"
L["UIColoredInventoryItems"] = "彩色背包物品"
L["UIColoredInventoryItemsDesc"] = "切换以根据物品品质为背包物品着色。"
L["UIShowQuestlevel"] = "显示任务等级"
L["Quest Tracker"] = "任务追踪器"
L["Questtracker"] = "任务追踪器"
L["UIShowQuestlevelDesc"] = "在任务名称旁边显示任务等级。"
L["UIFrames"] = "框架"
L["UIFramesDesc"] = "用于修改各种游戏内框架的选项。"
L["UIChangeCharacterFrame"] = "更改角色框架"
L["UIChangeCharacterFrameDesc"] = "Change the appearance of the character frame."
L["UIChangeProfessionWindow"] = "更改专业窗口"
L["UIChangeProfessionWindowDesc"] = "修改专业窗口的外观。"
L["UIChangeInspectFrame"] = "更改观察框架"
L["UIChangeInspectFrameDesc"] = "更改观察框架的外观。"
L["UIChangeTrainerWindow"] = "更改训练师窗口"
L["UIChangeTrainerWindowDesc"] = "更改训练师窗口的外观。"
L["UIChangeTalentFrame"] = "更改天赋框架"
L["UIChangeTalentFrameDesc"] = "更改天赋框架的布局或外观。（在巫妖王版本中不可用）"
L["UIChangeSpellBook"] = "更改法术书"
L["UIChangeSpellBookDesc"] = "更改法术书的外观。"
L["UIChangeSpellBookProfessions"] = "更改法术书专业"
L["UIChangeSpellBookProfessionsDesc"] = "修改法术书的专业布局。"

-- ProfessionFrame
L["ProfessionFrameHasSkillUp"] = "有技能提升"
L["ProfessionFrameHasMaterials"] = CRAFT_IS_MAKEABLE
L["ProfessionFrameSubclass"] = "子类"
L["ProfessionFrameSlot"] = "槽位"
L["ProfessionCheckAll"] = "全选"
L["ProfessionUnCheckAll"] = "取消全选"
L["ProfessionFavorites"] = "收藏"

-- Tooltip
L["TooltipName"] = "提示框"
L["TooltipHeaderGameToltip"] = "游戏提示框"
L["TooltipHeaderSpellTooltip"] = "法术提示框"

L["TooltipCursorAnchorHeader"] = "光标锚点"
L["TooltipCursorAnchorHeaderDesc"] = ""
L["TooltipAnchorToMouse"] = "锚点在光标"
L["TooltipAnchorToMouseDesc"] =
    "将一些提示框（例如世界框架上的单位提示框）锚定到鼠标光标。"
L["TooltipMouseAnchor"] = "鼠标提示锚点"
L["TooltipMouseAnchorDesc"] = "鼠标提示锚点"
L["TooltipMouseX"] = "X"
L["TooltipMouseXDesc"] = "X"
L["TooltipMouseY"] = "Y"
L["TooltipMouseYDesc"] = "Y"

-- spelltooltip
L["TooltipAnchorSpells"] = "锚点法术"
L["TooltipAnchorSpellsDesc"] = "将动作条上的法术提示框锚定到按钮，而不是默认锚点。"
L["TooltipShowSpellID"] = "显示法术ID"
L["TooltipShowSpellIDDesc"] = "显示法术ID"
L["TooltipShowSpellSource"] = "显示法术来源"
L["TooltipShowSpellSourceDesc"] = "显示法术来源"
L["TooltipShowSpellIcon"] = "显示法术图标"
L["TooltipShowSpellIconDesc"] = "显示法术图标"
L["TooltipShowIconID"] = "显示图标ID"
L["TooltipShowIconIDDesc"] = "显示图标ID"

L["TooltipShowIcon"] = "显示图标"
L["TooltipShowIconDesc"] = "显示图标"

-- itemtooltip
L["TooltipHeaderItemTooltip"] = "物品提示框"
L["TooltipHeaderItemTooltipDesc"] = "物品提示框"

L["TooltipShowItemQuality"] = "物品品质边框"
L["TooltipShowItemQualityDesc"] = "物品品质边框"
L["TooltipShowItemQualityBackdrop"] = "物品品质背景"
L["TooltipShowItemQualityBackdropDesc"] = "物品品质背景"
L["TooltipShowItemStackCount"] = "显示堆叠数量"
L["TooltipShowItemStackCountDesc"] = "显示堆叠数量"
L["TooltipShowItemID"] = "显示物品ID"
L["TooltipShowItemIDDesc"] = "显示物品ID"

-- unittooltip
L["TooltipUnitTooltip"] = "单位提示框"
L["TooltipUnitTooltipDesc"] = "单位提示框"

L["TooltipUnitClassBorder"] = "职业边框"
L["TooltipUnitClassBorderDesc"] = "职业边框"
L["TooltipUnitClassBackdrop"] = "职业背景"
L["TooltipUnitClassBackdropDesc"] = "职业背景"

L["TooltipUnitReactionBorder"] = "反应边框"
L["TooltipUnitReactionBorderDesc"] = "反应边框"
L["TooltipUnitReactionBackdrop"] = "反应背景"
L["TooltipUnitReactionBackdropDesc"] = "反应背景"

L["TooltipUnitClassName"] = "职业名称"
L["TooltipUnitClassNameDesc"] = "职业名称"
L["TooltipUnitTitle"] = "显示标题"
L["TooltipUnitTitleDesc"] = "显示标题"
L["TooltipUnitRealm"] = "显示服务器"
L["TooltipUnitRealmDesc"] = "显示服务器"
L["TooltipUnitGuild"] = "显示公会"
L["TooltipUnitGuildDesc"] = "显示公会"
L["TooltipUnitGuildRank"] = "显示公会等级"
L["TooltipUnitGuildRankDesc"] = "显示公会等级"
L["TooltipUnitGuildRankIndex"] = "显示公会等级索引"
L["TooltipUnitGuildRankIndexDesc"] = "显示公会等级"
L["TooltipUnitGrayOutOnDeath"] = "死亡时变灰"
L["TooltipUnitGrayOutOnDeathDesc"] = "死亡时变灰"
L["TooltipUnitZone"] = "显示区域文本"
L["TooltipUnitZoneDesc"] = "显示区域文本"
L["TooltipUnitHealthbar"] = "显示生命条"
L["TooltipUnitHealthbarDesc"] = "显示生命条"
L["TooltipUnitHealthbarText"] = "显示生命条文本"
L["TooltipUnitHealthbarTextDesc"] = "显示生命条文本"
-- Unitframes
L["UnitFramesName"] = "单位框架"
-- Player
L["PlayerFrameDesc"] = "玩家框架设置"
L["PlayerFrameStyle"] = L["ButtonTableStyle"]
L["PlayerFrameClassColor"] = "职业颜色"
L["PlayerFrameClassColorDesc"] = "为生命条启用职业颜色"
L["PlayerFrameClassIcon"] = "职业图标头像"
L["PlayerFrameClassIconDesc"] = "启用职业图标作为头像（当前已禁用）"
L["PlayerFrameBreakUpLargeNumbers"] = "拆分大数字"
L["PlayerFrameBreakUpLargeNumbersDesc"] =
    "启用拆分状态文本中的大数字（例如，7588 K 而不是 7588000）"
L["PlayerFrameBiggerHealthbar"] = "更大的生命条"
L["PlayerFrameBiggerHealthbarDesc"] = "启用更大的生命条"
L["PlayerFrameHideRedStatus"] = "隐藏战斗中的红色状态发光"
L["PlayerFrameHideRedStatusDesc"] = "隐藏战斗中的红色状态发光"
L["PlayerFrameHideHitIndicator"] = "隐藏命中指示器"
L["PlayerFrameHideHitIndicatorDesc"] = "隐藏玩家框架上的命中指示器"
L["PlayerFrameHideSecondaryRes"] = "隐藏次要资源"
L["PlayerFrameHideSecondaryResDesc"] = "隐藏次要资源，例如灵魂碎片。"
L["PlayerFrameHideAlternatePowerBar"] = "隐藏德鲁伊替代能量条"
L["PlayerFrameHideAlternatePowerBarDesc"] = "隐藏德鲁伊替代能量条（熊/猫形态时的法力条）。"

-- Target
L["TargetFrameDesc"] = "目标框架设置"
L["TargetFrameStyle"] = L["ButtonTableStyle"]
L["TargetFrameClassColor"] = L["PlayerFrameClassColor"]
L["TargetFrameClassColorDesc"] = "为生命条启用职业颜色"
L["TargetFrameClassIcon"] = L["PlayerFrameClassIcon"]
L["TargetFrameClassIconDesc"] = L["PlayerFrameClassIconDesc"]
L["TargetFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
L["TargetFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
L["TargetFrameNumericThreat"] = "数字仇恨"
L["TargetFrameNumericThreatDesc"] = "启用数字仇恨显示"
L["TargetFrameNumericThreatAnchor"] = "数字仇恨锚点"
L["TargetFrameNumericThreatAnchorDesc"] = "设置数字仇恨锚点（位置）"
L["TargetFrameThreatGlow"] = "仇恨发光"
L["TargetFrameThreatGlowDesc"] = "启用仇恨发光效果"
L["TargetFrameHideNameBackground"] = "隐藏名称背景"
L["TargetFrameHideNameBackgroundDesc"] = "隐藏目标名称的背景"
L["TargetFrameComboPointsOnPlayerFrame"] = "玩家框架上的连击点"
L["TargetFrameComboPointsOnPlayerFrameDesc"] = "在玩家框架上显示连击点。"
L["TargetFrameHideComboPoints"] = "隐藏连击点"
L["TargetFrameHideComboPointsDesc"] = "隐藏连击点框架。"
L["TargetFrameFadeOut"] = "淡出"
L["TargetFrameFadeOutDesc"] = "当目标距离超过 淡出距离 时，淡出目标框架。"
L["TargetFrameFadeOutDistance"] = "淡出距离"
L["TargetFrameFadeOutDistanceDesc"] =
    "设置淡出效果的检查距离（以码为单位）。\n注意：并非每个值都会产生影响，因为它使用 'LibRangeCheck-3.0'。\n通过 'minRange >= fadeOutDistance' 计算。"

-- Pet
L["PetFrameDesc"] = "宠物框架设置"
L["PetFrameStyle"] = L["ButtonTableStyle"]
L["PetFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
L["PetFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
L["PetFrameThreatGlow"] = L["TargetFrameThreatGlow"]
L["PetFrameThreatGlowDesc"] = L["TargetFrameThreatGlowDesc"]
L["PetFrameHideStatusbarText"] = "隐藏状态栏文本"
L["PetFrameHideStatusbarTextDesc"] = "隐藏状态栏文本"
L["PetFrameHideIndicator"] = "隐藏命中指示器"
L["PetFrameHideIndicatorDesc"] = "隐藏命中指示器"

-- Focus
L["FocusFrameDesc"] = "焦点框架设置"
L["FocusFrameStyle"] = L["ButtonTableStyle"]
L["FocusFrameClassColor"] = L["PlayerFrameClassColor"]
L["FocusFrameClassColorDesc"] = "为生命条启用职业颜色"
L["FocusFrameClassIcon"] = L["PlayerFrameClassIcon"]
L["FocusFrameClassIconDesc"] = "启用职业图标作为焦点框架的头像"
L["FocusFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
L["FocusFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]
L["FocusFrameHideNameBackground"] = L["TargetFrameHideNameBackground"]
L["FocusFrameHideNameBackgroundDesc"] = "隐藏名称背景"

-- party
L["PartyFrameDesc"] = "队伍框架设置"
L["PartyFrameStyle"] = L["ButtonTableStyle"]
L["PartyFrameClassColor"] = L["PlayerFrameClassColor"]
L["PartyFrameClassColorDesc"] = "为生命条启用职业颜色"
L["PartyFrameBreakUpLargeNumbers"] = L["PlayerFrameBreakUpLargeNumbers"]
L["PartyFrameBreakUpLargeNumbersDesc"] = L["PlayerFrameBreakUpLargeNumbersDesc"]

-- L["Friendsframe"] = "好友框"
-- L["Class Color"] = "职业颜色"
-- L["Durability"] = "耐久"
-- L["LFG"] = "队伍查找器"
-- L["Chat"] = "聊天栏"
-- L["TOP"] = "顶部"
-- L["RIGHT"] = "右侧"
-- L["BOTTOM"] = "底部"
-- L["LEFT"] = "左侧"
-- L["TOPRIGHT"] = "右上"
-- L["TOPLEFT"] = "左上"
-- L["BOTTOMLEFT"] = "左下"
-- L["BOTTOMRIGHT"] = "右下"
-- L["CENTER"] = "中间"
-- L["Anchor"] = "锚点"
-- L["Scale"] = "缩放"
-- L["Anchorframe"] = "锚点框架"
-- L["AnchorParent"] = "锚点父框架"
-- L["X relative to BOTTOM LEFT"] = "X相对于左下角"
-- L["Y relative to BOTTOM LEFT"] = "Y相对于左下角"
-- L["Size X"] = "X尺寸"
-- L["Size Y"] = "Y尺寸"
-- L["What's New"] = "新增内容"
-- L["Modules"] = "模块"
-- L["Info"] = "信息"
-- L["Actionbar"] = "动作条"
-- L["Castbar"] = "施法条"
-- L["Buffs"] = "Buff"
-- L["Darkmode"] = "深色模式"
-- L["Minimap"] = "小地图"
-- L["Tooltip"] = "鼠标提示"
-- L["UI"] = "用户界面"
-- L["Unitframe"] = "单位框架"
-- L["Utility"] = "实用工具"
-- L["Action Bar"] = "动作条"
-- L["Cast Bar"] = "施法条"
-- L["Misc"] = "杂项"
-- L["Unitframes"] = "单位框架"
-- L["FocusTarget"] = "焦点目标"
-- L["Party"] = "小队"
-- L["Pet"] = "宠物"
-- L["Player"] = "玩家"
-- L["Focus"] = "焦点"
-- L["Raid"] = "团队"
-- L["Target"] = "目标"
-- L["TargetOfTarget"] = "目标的目标"
-- L["Player_PowerBarAlt"] = "玩家_能量条替代"
-- L["Use the blizzard settings, as setting them through addons taints the UI."] =
--     "使用暴雪设置，因为通过插件设置它们会污染UI"
-- L["Raid Frame Settings"] = "团队框架设置"
-- L["Current Profile"] = "当前配置文件"
-- L["New Profile"] = "新配置文件"
-- L["Delete Profile"] = "删除配置文件"
-- L["Profile To Delete"] = "要删除的配置文件"
-- L["Delete"] = "删除"
-- L["Create"] = "创建"
-- L["Profiles"] = "配置"
-- L["Open"] = "打开"
-- L["General"] = "常规"
-- L["Quick Keybind Mode"] = "快速键盘绑定模式"
-- L["Press the escape key to unbind this action."] = "按Esc键取消绑定快捷键。"
-- L["Press a key to set the binding for this action."] = "按一个键来设置此快捷键的绑定。"
-- L["Canceling will remove you from Quick Keybind Mode."] = "取消将使您退出快速键盘绑定模式"
-- L["Not Bound"] = "未绑定"
-- L["You are in Quick Keybind Mode. Mouse over a button and press the desired key to set the binding for that button."] =
--     "您处于快速键盘绑定模式。将鼠标悬停在按钮上，然后按所需的键以设置该按钮的绑定"
-- L["Defaults"] = "默认"

-- see comment above
for k, v in pairs(L) do L_CN[k] = v; end
