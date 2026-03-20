// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class SZh extends S {
  SZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Hachimi - 点亮内心宇宙';

  @override
  String get homeTabToday => '今天';

  @override
  String get homeTabCatHouse => '猫屋';

  @override
  String get homeTabStats => '统计';

  @override
  String get homeTabProfile => '我的';

  @override
  String get adoptionStepDefineHabit => '定义习惯';

  @override
  String get adoptionStepAdoptCat => '领养猫猫';

  @override
  String get adoptionStepNameCat => '起个名字';

  @override
  String get adoptionHabitName => '习惯名称';

  @override
  String get adoptionHabitNameHint => '例如：每日阅读';

  @override
  String get adoptionDailyGoal => '每日目标';

  @override
  String get adoptionTargetHours => '目标时长';

  @override
  String get adoptionTargetHoursHint => '完成这个习惯的总时长';

  @override
  String adoptionMinutes(int count) {
    return '$count 分钟';
  }

  @override
  String get adoptionRefreshCat => '换一只';

  @override
  String adoptionPersonality(String name) {
    return '性格：$name';
  }

  @override
  String get adoptionNameYourCat => '给猫猫起个名字';

  @override
  String get adoptionRandomName => '随机';

  @override
  String get adoptionCreate => '创建习惯并领养';

  @override
  String get adoptionNext => '下一步';

  @override
  String get adoptionBack => '上一步';

  @override
  String get adoptionCatNameLabel => '猫猫名字';

  @override
  String get adoptionCatNameHint => '例如：小年糕';

  @override
  String get adoptionRandomNameTooltip => '随机名字';

  @override
  String get catHouseTitle => '猫屋';

  @override
  String get catHouseEmpty => '还没有猫猫！创建一个习惯来领养你的第一只猫。';

  @override
  String catHouseGrowth(int minutes, int target) {
    return '$minutes / $target 分钟';
  }

  @override
  String get catDetailGrowthProgress => '成长进度';

  @override
  String catDetailTotalMinutes(int minutes) {
    return '已专注 $minutes 分钟';
  }

  @override
  String catDetailTargetMinutes(int minutes) {
    return '目标：$minutes 分钟';
  }

  @override
  String get catDetailRename => '重命名';

  @override
  String get catDetailAccessories => '饰品';

  @override
  String get catDetailStartFocus => '开始专注';

  @override
  String get catDetailBoundHabit => '绑定习惯';

  @override
  String catDetailStage(String stage) {
    return '阶段：$stage';
  }

  @override
  String coinBalance(int amount) {
    return '$amount 金币';
  }

  @override
  String coinCheckInReward(int amount) {
    return '+$amount 金币！';
  }

  @override
  String get coinCheckInTitle => '每日签到';

  @override
  String get coinInsufficientBalance => '金币不足';

  @override
  String get shopTitle => '饰品商店';

  @override
  String shopPrice(int price) {
    return '$price 金币';
  }

  @override
  String get shopPurchase => '购买';

  @override
  String get shopEquipped => '已装备';

  @override
  String focusCompleteMinutes(int minutes) {
    return '+$minutes 分钟';
  }

  @override
  String get focusCompleteStageUp => '阶段提升！';

  @override
  String get focusCompleteGreatJob => '干得好！';

  @override
  String get focusCompleteDone => '完成';

  @override
  String get focusCompleteItsOkay => '没关系！';

  @override
  String focusCompleteEvolved(String catName) {
    return '$catName 进化了！';
  }

  @override
  String focusCompleteFocusedFor(int minutes) {
    return '你专注了 $minutes 分钟';
  }

  @override
  String focusCompleteAbandonedMessage(String catName) {
    return '$catName 说：「我们下次再来！」';
  }

  @override
  String get focusCompleteFocusTime => '专注时长';

  @override
  String get focusCompleteCoinsEarned => '获得金币';

  @override
  String get focusCompleteBaseXp => '基础 XP';

  @override
  String get focusCompleteStreakBonus => '连续奖励';

  @override
  String get focusCompleteMilestoneBonus => '里程碑奖励';

  @override
  String get focusCompleteFullHouseBonus => '全勤奖励';

  @override
  String get focusCompleteTotal => '总计';

  @override
  String focusCompleteEvolvedTo(String stage) {
    return '进化到 $stage！';
  }

  @override
  String get focusCompleteYourCat => '你的猫猫';

  @override
  String get focusCompleteDiaryWriting => '正在写日记...';

  @override
  String get focusCompleteDiaryWritten => '日记已写好！';

  @override
  String get focusCompleteDiarySkipped => '日记已跳过';

  @override
  String get focusCompleteNotifTitle => '任务完成！';

  @override
  String focusCompleteNotifBody(String catName, int xp, int minutes) {
    return '$catName 通过 $minutes 分钟专注获得了 +$xp XP';
  }

  @override
  String get stageKitten => '幼猫';

  @override
  String get stageAdolescent => '少年猫';

  @override
  String get stageAdult => '成年猫';

  @override
  String get stageSenior => '长老猫';

  @override
  String get migrationTitle => '数据更新';

  @override
  String get migrationMessage => 'Hachimi 已升级为全新的像素猫系统！旧的猫猫数据不再兼容，请重置以体验全新版本。';

  @override
  String get migrationResetButton => '重置并开始';

  @override
  String get sessionResumeTitle => '恢复会话？';

  @override
  String sessionResumeMessage(String habitName, String elapsed) {
    return '你有一个未完成的专注会话（$habitName，$elapsed）。是否恢复？';
  }

  @override
  String get sessionResumeButton => '恢复';

  @override
  String get sessionDiscard => '丢弃';

  @override
  String get todaySummaryMinutes => '今天';

  @override
  String get todaySummaryTotal => '总计';

  @override
  String get todaySummaryCats => '猫猫';

  @override
  String get todayYourQuests => '你的任务';

  @override
  String get todayNoQuests => '还没有任务';

  @override
  String get todayNoQuestsHint => '点击 + 开始一个任务并领养一只猫！';

  @override
  String get todayFocus => '专注';

  @override
  String get todayDeleteQuestTitle => '删除任务？';

  @override
  String todayDeleteQuestMessage(String name) {
    return '确定要删除「$name」吗？猫猫将被送入图鉴。';
  }

  @override
  String todayQuestCompleted(String name) {
    return '$name 已完成';
  }

  @override
  String get todayFailedToLoad => '加载任务失败';

  @override
  String todayMinToday(int count) {
    return '今天 $count 分钟';
  }

  @override
  String todayGoalMinPerDay(int count) {
    return '目标：$count 分钟/天';
  }

  @override
  String get todayFeaturedCat => '明星猫猫';

  @override
  String get todayAddHabit => '添加习惯';

  @override
  String get todayNoHabits => '创建第一个习惯来开始吧！';

  @override
  String get todayNewQuest => '新任务';

  @override
  String get todayStartFocus => '开始专注';

  @override
  String get timerStart => '开始';

  @override
  String get timerPause => '暂停';

  @override
  String get timerResume => '继续';

  @override
  String get timerDone => '完成';

  @override
  String get timerGiveUp => '放弃';

  @override
  String get timerRemaining => '剩余';

  @override
  String get timerElapsed => '已用时';

  @override
  String get timerPaused => '已暂停';

  @override
  String get timerQuestNotFound => '未找到任务';

  @override
  String get timerNotificationBanner => '启用通知以在后台查看计时进度';

  @override
  String get timerNotificationDismiss => '忽略';

  @override
  String get timerNotificationEnable => '启用';

  @override
  String timerGraceBack(int seconds) {
    return '返回（${seconds}s）';
  }

  @override
  String get giveUpTitle => '放弃？';

  @override
  String get giveUpMessage => '如果你已专注超过 5 分钟，时间仍会计入猫猫的成长。猫猫会理解的！';

  @override
  String get giveUpKeepGoing => '继续加油';

  @override
  String get giveUpConfirm => '放弃';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsGeneral => '通用';

  @override
  String get settingsAppearance => '外观';

  @override
  String get settingsNotifications => '通知';

  @override
  String get settingsNotificationFocusReminders => '专注提醒';

  @override
  String get settingsNotificationSubtitle => '接收每日提醒以保持进度';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageSystem => '跟随系统';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageChinese => '中文';

  @override
  String get settingsThemeMode => '主题模式';

  @override
  String get settingsThemeModeSystem => '跟随系统';

  @override
  String get settingsThemeModeLight => '浅色';

  @override
  String get settingsThemeModeDark => '深色';

  @override
  String get settingsThemeColor => '主题颜色';

  @override
  String get settingsThemeColorDynamic => '动态';

  @override
  String get settingsThemeColorDynamicSubtitle => '使用壁纸颜色';

  @override
  String get settingsAbout => '关于';

  @override
  String get settingsVersion => '版本';

  @override
  String get settingsLicenses => '开源许可';

  @override
  String get settingsAccount => '账号';

  @override
  String get logoutTitle => '退出登录？';

  @override
  String get logoutMessage => '确定要退出登录吗？';

  @override
  String get loggingOut => '正在退出...';

  @override
  String get deleteAccountTitle => '删除账号？';

  @override
  String get deleteAccountMessage => '这将永久删除你的账号和所有数据，此操作无法撤销。';

  @override
  String get deleteAccountWarning => '此操作无法撤销';

  @override
  String get profileTitle => '我的';

  @override
  String get profileYourJourney => '你的旅程';

  @override
  String get profileTotalFocus => '总专注';

  @override
  String get profileTotalCats => '猫猫总数';

  @override
  String get profileTotalQuests => '任务';

  @override
  String get profileEditName => '修改名称';

  @override
  String get profileDisplayName => '显示名称';

  @override
  String get profileChooseAvatar => '选择头像';

  @override
  String get profileSaved => '资料已保存';

  @override
  String get profileSettings => '设置';

  @override
  String get habitDetailStreak => '连续';

  @override
  String get habitDetailBestStreak => '最佳';

  @override
  String get habitDetailTotalMinutes => '总计';

  @override
  String get commonCancel => '取消';

  @override
  String get commonConfirm => '确认';

  @override
  String get commonSave => '保存';

  @override
  String get commonDelete => '删除';

  @override
  String get commonEdit => '编辑';

  @override
  String get commonDone => '完成';

  @override
  String get commonDismiss => '忽略';

  @override
  String get commonEnable => '启用';

  @override
  String get commonLoading => '加载中...';

  @override
  String get commonError => '出了点问题';

  @override
  String get commonRetry => '重试';

  @override
  String get commonResume => '继续';

  @override
  String get commonPause => '暂停';

  @override
  String get commonLogOut => '退出登录';

  @override
  String get commonDeleteAccount => '删除账号';

  @override
  String get commonYes => '是';

  @override
  String chatDailyRemaining(int count) {
    return '今天还可以发送 $count 条消息';
  }

  @override
  String get chatDailyLimitReached => '今日消息额度已用完';

  @override
  String get aiTemporarilyUnavailable => 'AI 功能暂时不可用';

  @override
  String get catDetailNotFound => '未找到猫猫';

  @override
  String get catDetailLoadError => '加载猫咪数据失败';

  @override
  String get catDetailChatTooltip => '聊天';

  @override
  String get catDetailRenameTooltip => '重命名';

  @override
  String get catDetailGrowthTitle => '成长进度';

  @override
  String catDetailTarget(int hours) {
    return '目标：${hours}h';
  }

  @override
  String get catDetailRenameTitle => '重命名猫猫';

  @override
  String get catDetailNewName => '新名字';

  @override
  String get catDetailRenamed => '猫猫已重命名！';

  @override
  String get catDetailQuestBadge => '任务';

  @override
  String get catDetailEditQuest => '编辑任务';

  @override
  String get catDetailDailyGoal => '每日目标';

  @override
  String get catDetailTodaysFocus => '今日专注';

  @override
  String get catDetailTotalFocus => '总专注';

  @override
  String get catDetailTargetLabel => '目标';

  @override
  String get catDetailCompletion => '完成度';

  @override
  String get catDetailCurrentStreak => '当前连续';

  @override
  String get catDetailBestStreakLabel => '最长连续';

  @override
  String get catDetailAvgDaily => '日均';

  @override
  String get catDetailDaysActive => '活跃天数';

  @override
  String get catDetailCheckInDays => '打卡天数';

  @override
  String get catDetailEditQuestTitle => '编辑任务';

  @override
  String get catDetailQuestName => '任务名称';

  @override
  String get catDetailDailyGoalMinutes => '每日目标（分钟）';

  @override
  String get catDetailTargetTotalHours => '目标总时长（小时）';

  @override
  String get catDetailQuestUpdated => '任务已更新！';

  @override
  String get catDetailTargetCompletedHint => '目标已达成，已转为永续模式';

  @override
  String get catDetailDailyReminder => '每日提醒';

  @override
  String catDetailEveryDay(String time) {
    return '每天 $time';
  }

  @override
  String get catDetailNoReminder => '未设置提醒';

  @override
  String get catDetailChange => '更改';

  @override
  String get catDetailRemoveReminder => '移除提醒';

  @override
  String get catDetailSet => '设置';

  @override
  String catDetailReminderSet(String time) {
    return '提醒已设置为 $time';
  }

  @override
  String get catDetailReminderRemoved => '提醒已移除';

  @override
  String get catDetailDiaryTitle => 'Hachimi 日记';

  @override
  String get catDetailDiaryLoading => '加载中...';

  @override
  String get catDetailDiaryError => '无法加载日记';

  @override
  String get catDetailDiaryEmpty => '今天还没有日记。完成一次专注吧！';

  @override
  String catDetailChatWith(String name) {
    return '和 $name 聊天';
  }

  @override
  String get catDetailChatSubtitle => '和你的猫猫对话';

  @override
  String get catDetailActivity => '活动';

  @override
  String get catDetailActivityError => '加载活动数据失败';

  @override
  String get catDetailAccessoriesTitle => '饰品';

  @override
  String get catDetailEquipped => '已装备：';

  @override
  String get catDetailNone => '无';

  @override
  String get catDetailUnequip => '卸下';

  @override
  String catDetailFromInventory(int count) {
    return '道具箱（$count）';
  }

  @override
  String get catDetailNoAccessories => '还没有饰品。去商店看看吧！';

  @override
  String catDetailEquippedItem(String name) {
    return '已装备 $name';
  }

  @override
  String get catDetailUnequipped => '已卸下';

  @override
  String catDetailAbout(String name) {
    return '关于 $name';
  }

  @override
  String get catDetailAppearanceDetails => '外观详情';

  @override
  String get catDetailStatus => '状态';

  @override
  String get catDetailAdopted => '领养日期';

  @override
  String get catDetailFurPattern => '毛色花纹';

  @override
  String get catDetailFurColor => '毛色';

  @override
  String get catDetailFurLength => '毛长';

  @override
  String get catDetailEyes => '眼睛';

  @override
  String get catDetailWhitePatches => '白色斑块';

  @override
  String get catDetailPatchesTint => '斑块色调';

  @override
  String get catDetailTint => '色调';

  @override
  String get catDetailPoints => '重点色';

  @override
  String get catDetailVitiligo => '白斑';

  @override
  String get catDetailTortoiseshell => '玳瑁';

  @override
  String get catDetailTortiePattern => '玳瑁花纹';

  @override
  String get catDetailTortieColor => '玳瑁颜色';

  @override
  String get catDetailSkin => '肤色';

  @override
  String get offlineMessage => '你已离线——重新连接时将自动同步';

  @override
  String get offlineModeLabel => '离线模式';

  @override
  String habitTodayMinutes(int count) {
    return '今天：$count分钟';
  }

  @override
  String get habitDeleteTooltip => '删除习惯';

  @override
  String get heatmapActiveDays => '活跃天数';

  @override
  String get heatmapTotal => '总计';

  @override
  String get heatmapRate => '达标率';

  @override
  String get heatmapLess => '少';

  @override
  String get heatmapMore => '多';

  @override
  String get accessoryEquipped => '已装备';

  @override
  String get accessoryOwned => '已拥有';

  @override
  String get pickerMinUnit => '分钟';

  @override
  String get settingsBackgroundAnimation => '动态背景';

  @override
  String get settingsBackgroundAnimationSubtitle => '流体渐变和浮动粒子效果';

  @override
  String get settingsUiStyle => '界面风格';

  @override
  String get settingsUiStyleMaterial => 'Material 3';

  @override
  String get settingsUiStyleRetroPixel => '复古像素';

  @override
  String get settingsUiStyleMaterialSubtitle => '现代圆角 Material 设计';

  @override
  String get settingsUiStyleRetroPixelSubtitle => '温暖的像素艺术风格';

  @override
  String get personalityLazy => '慵懒';

  @override
  String get personalityCurious => '好奇';

  @override
  String get personalityPlayful => '活泼';

  @override
  String get personalityShy => '害羞';

  @override
  String get personalityBrave => '勇敢';

  @override
  String get personalityClingy => '粘人';

  @override
  String get personalityFlavorLazy => '一天要睡 23 个小时。剩下那小时？也在睡。';

  @override
  String get personalityFlavorCurious => '已经在到处闻来闻去了！';

  @override
  String get personalityFlavorPlayful => '停不下来追蝴蝶！';

  @override
  String get personalityFlavorShy => '花了 3 分钟才从箱子里探出头来...';

  @override
  String get personalityFlavorBrave => '箱子还没打开就跳出来了！';

  @override
  String get personalityFlavorClingy => '马上开始呼噜，死活不撒手。';

  @override
  String get moodHappy => '开心';

  @override
  String get moodNeutral => '平静';

  @override
  String get moodLonely => '孤单';

  @override
  String get moodMissing => '想你了';

  @override
  String get moodMsgLazyHappy => '喵~！该美美地睡一觉了...';

  @override
  String get moodMsgCuriousHappy => '今天我们去探索什么？';

  @override
  String get moodMsgPlayfulHappy => '喵~！准备好干活了！';

  @override
  String get moodMsgShyHappy => '...你、你在就好了。';

  @override
  String get moodMsgBraveHappy => '一起征服今天吧！';

  @override
  String get moodMsgClingyHappy => '耶！你回来了！别再走了！';

  @override
  String get moodMsgLazyNeutral => '*哈欠* 哦，嗨...';

  @override
  String get moodMsgCuriousNeutral => '嗯？那边是什么？';

  @override
  String get moodMsgPlayfulNeutral => '想玩吗？算了，待会再说...';

  @override
  String get moodMsgShyNeutral => '*慢慢探出头来*';

  @override
  String get moodMsgBraveNeutral => '一如既往地站岗。';

  @override
  String get moodMsgClingyNeutral => '我一直在等你...';

  @override
  String get moodMsgLazyLonely => '连睡觉都觉得孤单了...';

  @override
  String get moodMsgCuriousLonely => '不知道你什么时候回来...';

  @override
  String get moodMsgPlayfulLonely => '没有你，玩具都不好玩了...';

  @override
  String get moodMsgShyLonely => '*安静地蜷缩起来*';

  @override
  String get moodMsgBraveLonely => '我会继续等。我很勇敢。';

  @override
  String get moodMsgClingyLonely => '你去哪儿了... 🥺';

  @override
  String get moodMsgLazyMissing => '*满怀期待地睁开一只眼*';

  @override
  String get moodMsgCuriousMissing => '是不是发生了什么事...？';

  @override
  String get moodMsgPlayfulMissing => '我帮你留着你最喜欢的玩具...';

  @override
  String get moodMsgShyMissing => '*藏起来了，但一直盯着门口*';

  @override
  String get moodMsgBraveMissing => '我知道你会回来的。我相信。';

  @override
  String get moodMsgClingyMissing => '好想你... 快回来吧。';

  @override
  String get peltTypeTabby => '经典虎斑纹';

  @override
  String get peltTypeTicked => '刺鼠纹';

  @override
  String get peltTypeMackerel => '鲭鱼纹';

  @override
  String get peltTypeClassic => '经典漩涡纹';

  @override
  String get peltTypeSokoke => '索科克大理石纹';

  @override
  String get peltTypeAgouti => '刺鼠色';

  @override
  String get peltTypeSpeckled => '斑点毛';

  @override
  String get peltTypeRosette => '玫瑰斑纹';

  @override
  String get peltTypeSingleColour => '纯色';

  @override
  String get peltTypeTwoColour => '双色';

  @override
  String get peltTypeSmoke => '烟色渐层';

  @override
  String get peltTypeSinglestripe => '单条纹';

  @override
  String get peltTypeBengal => '豹纹';

  @override
  String get peltTypeMarbled => '大理石纹';

  @override
  String get peltTypeMasked => '面罩脸';

  @override
  String get peltColorWhite => '白色';

  @override
  String get peltColorPaleGrey => '浅灰色';

  @override
  String get peltColorSilver => '银色';

  @override
  String get peltColorGrey => '灰色';

  @override
  String get peltColorDarkGrey => '深灰色';

  @override
  String get peltColorGhost => '幽灰色';

  @override
  String get peltColorBlack => '黑色';

  @override
  String get peltColorCream => '奶油色';

  @override
  String get peltColorPaleGinger => '浅姜黄色';

  @override
  String get peltColorGolden => '金色';

  @override
  String get peltColorGinger => '姜黄色';

  @override
  String get peltColorDarkGinger => '深姜黄色';

  @override
  String get peltColorSienna => '赭色';

  @override
  String get peltColorLightBrown => '浅棕色';

  @override
  String get peltColorLilac => '丁香色';

  @override
  String get peltColorBrown => '棕色';

  @override
  String get peltColorGoldenBrown => '金棕色';

  @override
  String get peltColorDarkBrown => '深棕色';

  @override
  String get peltColorChocolate => '巧克力色';

  @override
  String get eyeColorYellow => '黄色';

  @override
  String get eyeColorAmber => '琥珀色';

  @override
  String get eyeColorHazel => '榛色';

  @override
  String get eyeColorPaleGreen => '浅绿色';

  @override
  String get eyeColorGreen => '绿色';

  @override
  String get eyeColorBlue => '蓝色';

  @override
  String get eyeColorDarkBlue => '深蓝色';

  @override
  String get eyeColorBlueYellow => '蓝黄色';

  @override
  String get eyeColorBlueGreen => '蓝绿色';

  @override
  String get eyeColorGrey => '灰色';

  @override
  String get eyeColorCyan => '青色';

  @override
  String get eyeColorEmerald => '翡翠色';

  @override
  String get eyeColorHeatherBlue => '石楠蓝';

  @override
  String get eyeColorSunlitIce => '冰晶色';

  @override
  String get eyeColorCopper => '铜色';

  @override
  String get eyeColorSage => '鼠尾草色';

  @override
  String get eyeColorCobalt => '钴蓝色';

  @override
  String get eyeColorPaleBlue => '浅蓝色';

  @override
  String get eyeColorBronze => '青铜色';

  @override
  String get eyeColorSilver => '银色';

  @override
  String get eyeColorPaleYellow => '浅黄色';

  @override
  String eyeDescNormal(String color) {
    return '$color眼睛';
  }

  @override
  String eyeDescHeterochromia(String primary, String secondary) {
    return '异色瞳（$primary / $secondary）';
  }

  @override
  String get skinColorPink => '粉色';

  @override
  String get skinColorRed => '红色';

  @override
  String get skinColorBlack => '黑色';

  @override
  String get skinColorDark => '深色';

  @override
  String get skinColorDarkBrown => '深棕色';

  @override
  String get skinColorBrown => '棕色';

  @override
  String get skinColorLightBrown => '浅棕色';

  @override
  String get skinColorDarkGrey => '深灰色';

  @override
  String get skinColorGrey => '灰色';

  @override
  String get skinColorDarkSalmon => '深鲑色';

  @override
  String get skinColorSalmon => '鲑色';

  @override
  String get skinColorPeach => '桃色';

  @override
  String get furLengthLonghair => '长毛';

  @override
  String get furLengthShorthair => '短毛';

  @override
  String get whiteTintOffwhite => '米白色调';

  @override
  String get whiteTintCream => '奶油色调';

  @override
  String get whiteTintDarkCream => '深奶油色调';

  @override
  String get whiteTintGray => '灰色调';

  @override
  String get whiteTintPink => '粉色调';

  @override
  String notifReminderTitle(String catName) {
    return '$catName想你了！';
  }

  @override
  String notifReminderBody(String habitName) {
    return '$habitName的时间到了——猫猫在等你！';
  }

  @override
  String notifStreakTitle(String catName) {
    return '$catName很担心！';
  }

  @override
  String notifStreakBody(int streak) {
    return '你的 $streak 天连续记录有危险。快来一次专注吧！';
  }

  @override
  String notifEvolutionTitle(String catName) {
    return '$catName进化了！';
  }

  @override
  String notifEvolutionBody(String catName, String stageName) {
    return '$catName成长为了$stageName！继续加油！';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours时$minutes分';
  }

  @override
  String diaryScreenTitle(String name) {
    return '$name的日记';
  }

  @override
  String get diaryFailedToLoad => '加载日记失败';

  @override
  String get diaryEmptyTitle => '还没有日记';

  @override
  String get diaryEmptyHint => '完成一次专注，猫猫就会写下第一篇日记！';

  @override
  String get focusSetupCountdown => '倒计时';

  @override
  String get focusSetupStopwatch => '正计时';

  @override
  String get focusSetupStartFocus => '开始专注';

  @override
  String get focusSetupQuestNotFound => '找不到任务';

  @override
  String get checkInButtonLogMore => '继续记录';

  @override
  String get checkInButtonStart => '开始计时';

  @override
  String get adoptionTitleFirst => '领养你的第一只猫！';

  @override
  String get adoptionTitleNew => '新任务';

  @override
  String get adoptionStepDefineQuest => '定义任务';

  @override
  String get adoptionStepAdoptCat2 => '领养猫猫';

  @override
  String get adoptionStepNameCat2 => '给猫取名';

  @override
  String get adoptionAdopt => '领养！';

  @override
  String get adoptionQuestPrompt => '你想开始什么任务？';

  @override
  String get adoptionKittenHint => '一只小猫会被分配来陪你坚持！';

  @override
  String get adoptionQuestName => '任务名称';

  @override
  String get adoptionQuestHint => '例如 准备面试题';

  @override
  String get adoptionTotalTarget => '总目标（小时）';

  @override
  String get adoptionGrowthHint => '你的猫会随着你积累专注时间而成长';

  @override
  String get adoptionCustom => '自定义';

  @override
  String get adoptionDailyGoalLabel => '每日专注目标（分钟）';

  @override
  String get adoptionReminderLabel => '每日提醒（可选）';

  @override
  String get adoptionReminderNone => '不设置';

  @override
  String get adoptionCustomGoalTitle => '自定义每日目标';

  @override
  String get adoptionMinutesPerDay => '每天分钟数';

  @override
  String get adoptionMinutesHint => '5 - 180';

  @override
  String get adoptionValidMinutes => '请输入 5 到 180 之间的值';

  @override
  String get adoptionCustomTargetTitle => '自定义目标小时数';

  @override
  String get adoptionTotalHours => '总小时数';

  @override
  String get adoptionHoursHint => '10 - 2000';

  @override
  String get adoptionValidHours => '请输入 10 到 2000 之间的值';

  @override
  String get adoptionSet => '设定';

  @override
  String get adoptionChooseKitten => '选择你的小猫！';

  @override
  String adoptionCompanionFor(String quest) {
    return '「$quest」的伙伴';
  }

  @override
  String get adoptionRerollAll => '全部重选';

  @override
  String get adoptionNameYourCat2 => '给猫取个名字';

  @override
  String get adoptionCatName => '猫名';

  @override
  String get adoptionCatHint => '例如 年糕';

  @override
  String get adoptionRandomTooltip => '随机名字';

  @override
  String adoptionGrowthTarget(String quest, int hours) {
    return '你的猫会在你专注「$quest」时成长！目标：$hours小时。';
  }

  @override
  String get adoptionValidQuestName => '请输入任务名称';

  @override
  String get adoptionValidCatName => '请给猫猫取个名字';

  @override
  String adoptionError(String message) {
    return '错误：$message';
  }

  @override
  String get adoptionBasicInfo => '基础信息';

  @override
  String get adoptionGoals => '目标设置';

  @override
  String get adoptionUnlimitedMode => '永续模式';

  @override
  String get adoptionUnlimitedDesc => '不设上限，持续累积';

  @override
  String get adoptionMilestoneMode => '里程碑模式';

  @override
  String get adoptionMilestoneDesc => '设定一个目标';

  @override
  String get adoptionDeadlineLabel => '截止日期';

  @override
  String get adoptionDeadlineNone => '不设';

  @override
  String get adoptionReminderSection => '提醒';

  @override
  String get adoptionMotivationLabel => '备忘';

  @override
  String get adoptionMotivationHint => '写点什么备忘...';

  @override
  String get adoptionMotivationSwap => '随机填充';

  @override
  String get loginAppName => 'Hachimi';

  @override
  String get loginTagline => '养猫咪，完成任务。';

  @override
  String get loginContinueGoogle => '使用 Google 登录';

  @override
  String get loginContinueEmail => '使用邮箱登录';

  @override
  String get loginAlreadyHaveAccount => '已有账号？';

  @override
  String get loginLogIn => '登录';

  @override
  String get loginWelcomeBack => '欢迎回来！';

  @override
  String get loginCreateAccount => '创建账号';

  @override
  String get loginEmail => '邮箱';

  @override
  String get loginPassword => '密码';

  @override
  String get loginConfirmPassword => '确认密码';

  @override
  String get loginValidEmail => '请输入邮箱';

  @override
  String get loginValidEmailFormat => '请输入有效的邮箱地址';

  @override
  String get loginValidPassword => '请输入密码';

  @override
  String get loginValidPasswordLength => '密码至少 6 个字符';

  @override
  String get loginValidPasswordMatch => '两次密码不一致';

  @override
  String get loginCreateAccountButton => '创建账号';

  @override
  String get loginNoAccount => '还没有账号？';

  @override
  String get loginRegister => '注册';

  @override
  String get checkInTitle => '月度签到';

  @override
  String get checkInDays => '天数';

  @override
  String get checkInCoinsEarned => '获得金币';

  @override
  String get checkInAllMilestones => '所有里程碑已达成！';

  @override
  String checkInMilestoneProgress(int remaining, int bonus) {
    return '还差 $remaining 天 → +$bonus 金币';
  }

  @override
  String get checkInMilestones => '里程碑';

  @override
  String get checkInFullMonth => '全月签到';

  @override
  String get checkInRewardSchedule => '奖励说明';

  @override
  String get checkInWeekday => '工作日（周一至周五）';

  @override
  String checkInWeekdayReward(int coins) {
    return '$coins 金币/天';
  }

  @override
  String get checkInWeekend => '周末（周六、周日）';

  @override
  String checkInNDays(int count) {
    return '$count 天';
  }

  @override
  String get onboardTitle1 => '认识哈奇米';

  @override
  String get onboardSubtitle1 => '你的觉知伴侣';

  @override
  String get onboardBody1 => '哈奇米是一只会感应你心情的猫咪，陪你在每天的小事中觉察自己。';

  @override
  String get onboardTitle2 => '每天 5 分钟';

  @override
  String get onboardSubtitle2 => '记录你的一点光';

  @override
  String get onboardBody2 => '睡前记录一个让你微笑的瞬间，选一个心情，写一句话就够了。';

  @override
  String get onboardTitle3 => '猫咪陪你觉知自己';

  @override
  String get onboardSubtitle3 => '慢慢变好';

  @override
  String get onboardBody3 => '专注习惯、记录心情、觉察烦恼。不完美也没关系，猫咪一直在。';

  @override
  String get onboardSkip => '跳过';

  @override
  String get onboardLetsGo => '开始吧！';

  @override
  String get onboardNext => '下一步';

  @override
  String get catRoomTitle => '猫猫小屋';

  @override
  String get catRoomInventory => '背包';

  @override
  String get catRoomShop => '饰品商店';

  @override
  String get catRoomLoadError => '加载猫猫失败';

  @override
  String get catRoomEmptyTitle => '猫猫小屋空空如也';

  @override
  String get catRoomEmptySubtitle => '开始一个任务来领养你的第一只猫！';

  @override
  String get catRoomEditQuest => '编辑任务';

  @override
  String get catRoomRenameCat => '重命名猫猫';

  @override
  String get catRoomArchiveCat => '归档猫猫';

  @override
  String get catRoomNewName => '新名字';

  @override
  String get catRoomRename => '重命名';

  @override
  String get catRoomArchiveTitle => '归档猫猫？';

  @override
  String catRoomArchiveMessage(String name) {
    return '这将归档「$name」并删除其绑定的任务。猫猫仍会出现在图鉴中。';
  }

  @override
  String get catRoomArchive => '归档';

  @override
  String catRoomAlbumSection(int count) {
    return '相册（$count）';
  }

  @override
  String get catRoomReactivateCat => '重新激活';

  @override
  String get catRoomReactivateTitle => '重新激活猫猫？';

  @override
  String catRoomReactivateMessage(String name) {
    return '将「$name」和其关联的任务恢复到猫猫小屋。';
  }

  @override
  String get catRoomReactivate => '激活';

  @override
  String get catRoomArchivedLabel => '已归档';

  @override
  String catRoomArchiveSuccess(String name) {
    return '已归档「$name」';
  }

  @override
  String catRoomReactivateSuccess(String name) {
    return '已重新激活「$name」';
  }

  @override
  String get catRoomArchiveError => '归档猫咪失败';

  @override
  String get catRoomReactivateError => '恢复猫咪失败';

  @override
  String get catRoomArchiveLoadError => '加载归档猫咪失败';

  @override
  String get catRoomRenameError => '重命名猫咪失败';

  @override
  String get addHabitTitle => '新任务';

  @override
  String get addHabitQuestName => '任务名称';

  @override
  String get addHabitQuestHint => '例如 LeetCode 刷题';

  @override
  String get addHabitValidName => '请输入任务名称';

  @override
  String get addHabitTargetHours => '目标小时数';

  @override
  String get addHabitTargetHint => '例如 100';

  @override
  String get addHabitValidTarget => '请输入目标小时数';

  @override
  String get addHabitValidNumber => '请输入有效数字';

  @override
  String get addHabitCreate => '创建任务';

  @override
  String get addHabitHoursSuffix => '小时';

  @override
  String shopTabPlants(int count) {
    return '植物（$count）';
  }

  @override
  String shopTabWild(int count) {
    return '野生（$count）';
  }

  @override
  String shopTabCollars(int count) {
    return '项圈（$count）';
  }

  @override
  String get shopNoAccessories => '暂无饰品';

  @override
  String shopBuyConfirm(String name) {
    return '购买 $name？';
  }

  @override
  String get shopPurchaseButton => '购买';

  @override
  String get shopNotEnoughCoinsButton => '金币不足';

  @override
  String shopPurchaseSuccess(String name) {
    return '购买成功！$name 已加入背包';
  }

  @override
  String shopPurchaseFailed(int price) {
    return '金币不足（需要 $price）';
  }

  @override
  String get inventoryTitle => '背包';

  @override
  String inventoryInBox(int count) {
    return '箱中（$count）';
  }

  @override
  String get inventoryEmpty => '背包空空如也。\n去商店购买饰品吧！';

  @override
  String inventoryEquippedOnCats(int count) {
    return '已装备在猫上（$count）';
  }

  @override
  String get inventoryNoEquipped => '还没有给猫猫装备饰品。';

  @override
  String get inventoryUnequip => '卸下';

  @override
  String get inventoryNoActiveCats => '没有活跃的猫猫';

  @override
  String inventoryEquipTo(String name) {
    return '将 $name 装备给：';
  }

  @override
  String inventoryEquipSuccess(String name) {
    return '已装备 $name';
  }

  @override
  String inventoryUnequipSuccess(String catName) {
    return '已从 $catName 卸下';
  }

  @override
  String get chatCatNotFound => '找不到猫猫';

  @override
  String chatTitle(String name) {
    return '和 $name 聊天';
  }

  @override
  String get chatClearHistory => '清除记录';

  @override
  String chatEmptyTitle(String name) {
    return '和 $name 打个招呼吧！';
  }

  @override
  String get chatEmptySubtitle => '开始和猫猫对话吧，它会根据自己的性格来回复你！';

  @override
  String get chatGenerating => '生成中...';

  @override
  String get chatTypeMessage => '输入消息...';

  @override
  String get chatClearConfirmTitle => '清除聊天记录？';

  @override
  String get chatClearConfirmMessage => '这将删除所有消息，此操作无法撤销。';

  @override
  String get chatClearButton => '清除';

  @override
  String get chatSend => '发送';

  @override
  String get chatStop => '停止';

  @override
  String get chatErrorMessage => '发送失败，点击重试';

  @override
  String get chatRetry => '重试';

  @override
  String get chatErrorGeneric => '出了点问题，请重试';

  @override
  String diaryTitle(String name) {
    return '$name的日记';
  }

  @override
  String get diaryLoadFailed => '加载日记失败';

  @override
  String get diaryRetry => '重试';

  @override
  String get diaryEmptyTitle2 => '还没有日记';

  @override
  String get diaryEmptySubtitle => '完成一次专注，猫猫就会写下第一篇日记！';

  @override
  String get statsTitle => '统计';

  @override
  String get statsTotalHours => '总时长';

  @override
  String statsTimeValue(int hours, int minutes) {
    return '$hours时$minutes分';
  }

  @override
  String get statsBestStreak => '最长连续';

  @override
  String statsStreakDays(int count) {
    return '$count 天';
  }

  @override
  String get statsOverallProgress => '总体进度';

  @override
  String statsPercentOfGoals(String percent) {
    return '$percent% 目标达成';
  }

  @override
  String get statsPerQuestProgress => '各任务进度';

  @override
  String get statsQuestLoadError => '加载任务统计失败';

  @override
  String get statsNoQuestData => '还没有任务数据';

  @override
  String get statsNoQuestHint => '开始一个任务来查看进度吧！';

  @override
  String get statsLast30Days => '最近 30 天';

  @override
  String get habitDetailQuestNotFound => '未找到任务';

  @override
  String get habitDetailComplete => '完成';

  @override
  String get habitDetailTotalTime => '总时长';

  @override
  String get habitDetailCurrentStreak => '当前连续';

  @override
  String get habitDetailTarget => '目标';

  @override
  String habitDetailDaysUnit(int count) {
    return '$count 天';
  }

  @override
  String habitDetailHoursUnit(int count) {
    return '$count 小时';
  }

  @override
  String checkInBannerSuccess(int coins) {
    return '+$coins 金币！每日签到完成';
  }

  @override
  String checkInBannerBonus(int bonus) {
    return ' + $bonus 里程碑奖励！';
  }

  @override
  String get checkInBannerSemantics => '每日签到';

  @override
  String get checkInBannerLoading => '加载签到状态...';

  @override
  String checkInBannerPrompt(int coins) {
    return '签到领 +$coins 金币';
  }

  @override
  String checkInBannerSummary(int count, int total, int coins) {
    return '$count/$total 天  ·  今天 +$coins';
  }

  @override
  String commonErrorWithDetail(String error) {
    return '错误：$error';
  }

  @override
  String get profileFallbackUser => '用户';

  @override
  String get fallbackCatName => '猫猫';

  @override
  String get settingsLanguageTraditionalChinese => '繁體中文';

  @override
  String get settingsLanguageJapanese => '日本語';

  @override
  String get settingsLanguageKorean => '한국어';

  @override
  String get settingsLanguageSpanish => 'Español';

  @override
  String get settingsLanguagePortuguese => 'Português';

  @override
  String get settingsLanguageFrench => 'Français';

  @override
  String get settingsLanguageGerman => 'Deutsch';

  @override
  String get settingsLanguageItalian => 'Italiano';

  @override
  String get settingsLanguageHindi => 'हिन्दी';

  @override
  String get settingsLanguageThai => 'ไทย';

  @override
  String get settingsLanguageVietnamese => 'Tiếng Việt';

  @override
  String get settingsLanguageIndonesian => 'Bahasa Indonesia';

  @override
  String get settingsLanguageTurkish => 'Türkçe';

  @override
  String get notifFocusing => '专注中…';

  @override
  String get notifInProgress => '正在专注';

  @override
  String get unitMinShort => '分钟';

  @override
  String get unitHourShort => '小时';

  @override
  String get weekdayMon => '一';

  @override
  String get weekdayTue => '二';

  @override
  String get weekdayWed => '三';

  @override
  String get weekdayThu => '四';

  @override
  String get weekdayFri => '五';

  @override
  String get weekdaySat => '六';

  @override
  String get weekdaySun => '日';

  @override
  String get statsTotalSessions => '专注次数';

  @override
  String get statsTotalHabits => '任务数';

  @override
  String get statsActiveDays => '活跃天数';

  @override
  String get statsWeeklyTrend => '本周趋势';

  @override
  String get statsRecentSessions => '最近专注';

  @override
  String get statsViewAllHistory => '查看全部历史';

  @override
  String get historyTitle => '专注历史';

  @override
  String get historyFilterAll => '全部';

  @override
  String historySessionCount(int count) {
    return '$count 次专注';
  }

  @override
  String historyTotalMinutes(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String get historyNoSessions => '还没有专注记录';

  @override
  String get historyNoSessionsHint => '完成一次专注就能在这里看到记录';

  @override
  String get historyLoadMore => '加载更多';

  @override
  String get sessionCompleted => '已完成';

  @override
  String get sessionAbandoned => '已放弃';

  @override
  String get sessionInterrupted => '被中断';

  @override
  String get sessionCountdown => '倒计时';

  @override
  String get sessionStopwatch => '正计时';

  @override
  String get historyDateGroupToday => '今天';

  @override
  String get historyDateGroupYesterday => '昨天';

  @override
  String get historyLoadError => '加载历史记录失败';

  @override
  String get historySelectMonth => '选择月份';

  @override
  String get historyAllMonths => '全部月份';

  @override
  String get historyAllHabits => '全部';

  @override
  String get homeTabAchievements => '成就';

  @override
  String get achievementTitle => '成就';

  @override
  String get achievementTabOverview => '概览';

  @override
  String get achievementTabQuest => '任务';

  @override
  String get achievementTabStreak => '连续';

  @override
  String get achievementTabCat => '猫咪';

  @override
  String get achievementTabPersist => '坚持';

  @override
  String get achievementSummaryTitle => '成就进度';

  @override
  String achievementUnlockedCount(int count) {
    return '已解锁 $count 个';
  }

  @override
  String achievementTotalCoins(int coins) {
    return '共获 $coins 金币';
  }

  @override
  String get achievementUnlocked => '成就解锁！';

  @override
  String get achievementAwesome => '太棒了！';

  @override
  String get achievementIncredible => '不可思议！';

  @override
  String get achievementHidden => '???';

  @override
  String get achievementHiddenDesc => '这是一个隐藏成就';

  @override
  String achievementPersistDesc(int days) {
    return '累计打卡 $days 天';
  }

  @override
  String achievementTitleCount(int count) {
    return '已解锁 $count 个称号';
  }

  @override
  String get growthPathTitle => '成长之路';

  @override
  String get growthPathKitten => '开始新的旅程';

  @override
  String get growthPathAdolescent => '初步入门，建立基础';

  @override
  String get growthPathAdult => '技能巩固，完成一个项目';

  @override
  String get growthPathSenior => '深度投入，持续精进';

  @override
  String get growthPathTip => '研究表明，20 小时的专注练习足以建立一项新技能的基础 —— Josh Kaufman';

  @override
  String achievementCelebrationCoins(int count) {
    return '+$count 金币';
  }

  @override
  String achievementCelebrationTitle(String title) {
    return '获得称号：$title';
  }

  @override
  String get achievementCelebrationDismiss => '太棒了！';

  @override
  String get achievementCelebrationSkipAll => '跳过全部';

  @override
  String achievementCelebrationCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String achievementUnlockedAt(String date) {
    return '解锁于 $date';
  }

  @override
  String get achievementLocked => '尚未解锁';

  @override
  String achievementRewardCoins(int count) {
    return '+$count 金币';
  }

  @override
  String get reminderModeDaily => '每天';

  @override
  String get reminderModeWeekdays => '工作日';

  @override
  String get reminderModeMonday => '周一';

  @override
  String get reminderModeTuesday => '周二';

  @override
  String get reminderModeWednesday => '周三';

  @override
  String get reminderModeThursday => '周四';

  @override
  String get reminderModeFriday => '周五';

  @override
  String get reminderModeSaturday => '周六';

  @override
  String get reminderModeSunday => '周日';

  @override
  String get reminderPickerTitle => '选择提醒时间';

  @override
  String get reminderHourUnit => '点';

  @override
  String get reminderMinuteUnit => '分';

  @override
  String get reminderAddMore => '添加提醒';

  @override
  String get reminderMaxReached => '最多 5 个提醒';

  @override
  String get reminderConfirm => '确认';

  @override
  String reminderNotificationTitle(String catName) {
    return '$catName想你了！';
  }

  @override
  String reminderNotificationBody(String habitName) {
    return '$habitName的时间到了，你的猫咪在等你！';
  }

  @override
  String get deleteAccountDataWarning => '以下所有数据将被永久删除：';

  @override
  String get deleteAccountQuests => '任务';

  @override
  String get deleteAccountCats => '猫咪';

  @override
  String get deleteAccountHours => '专注时长';

  @override
  String get deleteAccountIrreversible => '此操作不可撤销';

  @override
  String get deleteAccountContinue => '继续';

  @override
  String get deleteAccountConfirmTitle => '确认删除';

  @override
  String get deleteAccountTypeDelete => '输入 DELETE 以确认删除账号：';

  @override
  String get deleteAccountAuthCancelled => '认证已取消';

  @override
  String deleteAccountAuthFailed(String error) {
    return '认证失败：$error';
  }

  @override
  String get deleteAccountProgress => '正在删除账号...';

  @override
  String get deleteAccountSuccess => '账号已删除';

  @override
  String get drawerGuestLoginSubtitle => '同步数据，解锁 AI 功能';

  @override
  String get drawerGuestSignIn => '登录';

  @override
  String get drawerMilestones => '里程碑';

  @override
  String drawerMilestoneFocus(int hours, int minutes) {
    return '累计专注：${hours}h ${minutes}m';
  }

  @override
  String drawerMilestoneCats(int count) {
    return '猫咪家族：$count 只';
  }

  @override
  String drawerMilestoneQuests(int count) {
    return '进行中任务：$count 个';
  }

  @override
  String get drawerMySection => '我的';

  @override
  String get drawerSessionHistory => '专注历史';

  @override
  String get drawerCheckInCalendar => '签到日历';

  @override
  String get drawerAccountSection => '账号';

  @override
  String get settingsResetData => '清除所有数据';

  @override
  String get settingsResetDataTitle => '清除所有数据？';

  @override
  String get settingsResetDataMessage => '此操作将删除所有本地数据并返回欢迎页面，且无法撤销。';

  @override
  String get guestUpgradeTitle => '保护你的数据';

  @override
  String get guestUpgradeMessage => '关联账号可备份进度、解锁 AI 日记和聊天功能，并在多设备间同步。';

  @override
  String get guestUpgradeLinkButton => '关联账号';

  @override
  String get guestUpgradeLater => '以后再说';

  @override
  String get loginLinkTagline => '关联账号以保护你的数据';

  @override
  String get aiTeaserTitle => '猫猫日记';

  @override
  String aiTeaserPreview(String catName) {
    return '今天和主人一起学习了…$catName感觉自己又变聪明了喵~';
  }

  @override
  String aiTeaserCta(String catName) {
    return '关联账号，看看$catName想说什么';
  }

  @override
  String get authErrorEmailInUse => '该邮箱已被注册';

  @override
  String get authErrorWrongPassword => '邮箱或密码不正确';

  @override
  String get authErrorUserNotFound => '未找到该邮箱对应的账号';

  @override
  String get authErrorTooManyRequests => '尝试次数过多，请稍后再试';

  @override
  String get authErrorNetwork => '网络异常，请检查连接';

  @override
  String get authErrorAdminRestricted => '登录暂时受限';

  @override
  String get authErrorWeakPassword => '密码强度不足，至少需要 6 个字符';

  @override
  String get authErrorGeneric => '出了点问题，请重试';

  @override
  String get deleteAccountReauthEmail => '输入密码以继续';

  @override
  String get deleteAccountReauthPasswordHint => '密码';

  @override
  String get deleteAccountError => '出了点问题，稍后再试';

  @override
  String get deleteAccountPermissionError => '权限错误，尝试重新登录';

  @override
  String get deleteAccountNetworkError => '无网络连接，检查网络后再试';

  @override
  String get deleteAccountRetainedData => '使用统计和崩溃报告无法删除';

  @override
  String get deleteAccountStepCloud => '正在删除云端数据...';

  @override
  String get deleteAccountStepLocal => '正在清理本地数据...';

  @override
  String get deleteAccountStepDone => '已完成';

  @override
  String get deleteAccountQueued => '本地数据已删除。云端账号删除已排队，将在联网后自动完成。';

  @override
  String get deleteAccountPending => '账号删除任务处理中，请保持网络连接以完成云端与认证删除。';

  @override
  String get deleteAccountAbandon => '重新开始';

  @override
  String get archiveConflictTitle => '选择保留存档';

  @override
  String get archiveConflictMessage => '检测到本地和云端都有存档数据，请选择保留其一：';

  @override
  String get archiveConflictLocal => '本地存档';

  @override
  String get archiveConflictCloud => '云端存档';

  @override
  String get archiveConflictKeepCloud => '保留云端';

  @override
  String get archiveConflictKeepLocal => '保留本地';

  @override
  String get loginShowPassword => '显示密码';

  @override
  String get loginHidePassword => '隐藏密码';

  @override
  String get errorGeneric => '出了点问题，稍后再试';

  @override
  String get errorCreateHabit => '创建习惯失败，请重试';

  @override
  String get loginForgotPassword => '忘记密码？';

  @override
  String get loginForgotPasswordTitle => '重置密码';

  @override
  String get loginSendResetEmail => '发送重置邮件';

  @override
  String get loginResetEmailSent => '密码重置邮件已发送，请查收';

  @override
  String get authErrorUserDisabled => '此账号已被停用';

  @override
  String get authErrorInvalidEmail => '请输入有效的邮箱地址';

  @override
  String get authErrorRequiresRecentLogin => '请重新登录后继续';

  @override
  String get commonCopyId => '复制 ID';

  @override
  String get adoptionClearDeadline => '清除截止日期';

  @override
  String get commonIdCopied => 'ID 已复制';

  @override
  String get pickerDurationLabel => '时长选择器';

  @override
  String pickerMinutesValue(int count) {
    return '$count 分钟';
  }

  @override
  String a11yCatImage(String name) {
    return '猫咪 $name';
  }

  @override
  String a11yCatTapToInteract(String name) {
    return '$name，点击互动';
  }

  @override
  String a11yProgressPercent(int percent) {
    return '已完成 $percent%';
  }

  @override
  String a11yStreakActiveDays(int count) {
    return '$count 个活跃日';
  }

  @override
  String get a11yOfflineStatus => '离线模式';

  @override
  String a11yAchievementUnlocked(String name) {
    return '成就解锁：$name';
  }

  @override
  String get calendarCheckedIn => '已签到';

  @override
  String get calendarToday => '今天';

  @override
  String a11yEquipToCat(Object name) {
    return '装备给$name';
  }

  @override
  String a11yRegenerateCat(Object name) {
    return '重新生成$name';
  }

  @override
  String a11yTimerDisplay(Object time) {
    return '计时器：$time';
  }

  @override
  String a11yOnboardingPage(Object current, Object total) {
    return '第 $current 页，共 $total 页';
  }

  @override
  String a11yEditDisplayName(Object name) {
    return '编辑显示名：$name';
  }

  @override
  String get routeNotFound => '页面未找到';

  @override
  String get routeGoHome => '返回首页';

  @override
  String get a11yError => '错误';

  @override
  String get a11yDeadline => '截止日期';

  @override
  String get a11yReminder => '提醒';

  @override
  String get a11yFocusMeditation => '专注冥想';

  @override
  String get a11yUnlocked => '已解锁';

  @override
  String get a11ySelected => '已选中';

  @override
  String get a11yDynamicWallpaperColor => '动态壁纸颜色';

  @override
  String get awarenessTitle => '觉知';

  @override
  String get awarenessTabToday => '今天';

  @override
  String get awarenessTabThisWeek => '本周';

  @override
  String get awarenessTabReview => '回顾';

  @override
  String get moodVeryHappy => '很开心';

  @override
  String get moodCalm => '平静';

  @override
  String get moodDown => '低落';

  @override
  String get moodVeryDown => '很低落';

  @override
  String get awarenessLightPlaceholder => '今天有什么让你微笑的事？';

  @override
  String get awarenessLightSaved => '已记录今天的光 ✨';

  @override
  String get awarenessLightEdit => '编辑';

  @override
  String get weeklyReviewTitle => '周回顾';

  @override
  String weeklyReviewHappyMoment(int number) {
    return '幸福时刻 #$number';
  }

  @override
  String get weeklyReviewHappyMomentHint => '这周有什么让你开心的？';

  @override
  String get weeklyReviewGratitude => '感恩';

  @override
  String get weeklyReviewGratitudeHint => '这周想感谢谁或什么？';

  @override
  String get weeklyReviewLearning => '学到了什么';

  @override
  String get weeklyReviewLearningHint => '这周学到了什么？';

  @override
  String get weeklyReviewSave => '保存回顾';

  @override
  String get weeklyReviewSaved => '回顾已保存 ✨';

  @override
  String get worryProcessorTitle => '烦恼处理器';

  @override
  String get worryDescriptionHint => '什么在烦你？';

  @override
  String get worrySolutionHint => '你打算怎么应对？';

  @override
  String get worryStatusOngoing => '还在';

  @override
  String get worryStatusResolved => '搞定了';

  @override
  String get worryStatusDisappeared => '消失了';

  @override
  String get worryAdd => '添加烦恼';

  @override
  String get worrySave => '保存';

  @override
  String get worryResolvedSection => '已解决';

  @override
  String get worryManageAll => '管理全部烦恼';

  @override
  String get awarenessEmptyLightTitle => '今天还没有记录光哦';

  @override
  String get awarenessEmptyLightSubtitle => '什么时候都可以来 ✨';

  @override
  String get awarenessEmptyLightAction => '记录';

  @override
  String get awarenessEmptyReviewTitle => '慢慢来';

  @override
  String get awarenessEmptyReviewSubtitle => '等你准备好了再回顾 🐱';

  @override
  String get awarenessEmptyReviewAction => '开始回顾';

  @override
  String get awarenessEmptyHistoryTitle => '每一天的光都值得被记住';

  @override
  String get awarenessEmptyHistorySubtitle => '你的历史记录会出现在这里';

  @override
  String get awarenessEmptyWorriesTitle => '没有烦恼？太好了！🎉';

  @override
  String get awarenessEmptyWorriesSubtitle => '这真是太棒了';

  @override
  String get catReactVeryHappy => '铲屎官今天好开心，本猫也开心！🎉';

  @override
  String get catReactHappy => '记录了今天的光，真棒 ✨';

  @override
  String get catReactCalm => '平静的一天也很好呢 🍃';

  @override
  String get catReactDown => '不开心的日子，本猫陪着你 💛';

  @override
  String get catReactVeryDown => '没事的，本猫哪都不去 🫂';

  @override
  String get awarenessBridgePrompt => '今天有什么让你微笑的事？✨';

  @override
  String get awarenessBridgeRecord => '记录';

  @override
  String get awarenessBridgeSkip => '跳过';

  @override
  String get awarenessHabitsSection => '今日习惯';

  @override
  String get awarenessHabitsEmpty => '还没有习惯，去领养一只猫吧';

  @override
  String get awarenessReviewComingSoon => '即将推出';

  @override
  String get awarenessMoodRequired => '请先选择今天的心情';

  @override
  String get awarenessSaveFailed => '保存失败，请重试';

  @override
  String get awarenessLoadFailed => '加载失败，请返回重试';

  @override
  String get awarenessSaved => '已保存';

  @override
  String get worryDescriptionRequired => '请描述你的烦恼';

  @override
  String get worryLoadFailed => '加载烦恼失败';

  @override
  String get awarenessLoginRequired => '请先登录';

  @override
  String get tagCustom => '+自定义';

  @override
  String get homeTabAwareness => '觉知';

  @override
  String get homeTabHabits => '习惯';

  @override
  String get monthlyRitualSetupTitle => '新的一月，选一个习惯来专注';

  @override
  String get monthlyRitualSetupDesc => '选一个这个月最想坚持的习惯，设定一个灵活的目标，给自己一个小奖励。';

  @override
  String get monthlyRitualSetupButton => '开始设定';

  @override
  String get monthlyRitualDialogTitle => '月度仪式';

  @override
  String get monthlyRitualHabitLabel => '专注习惯';

  @override
  String get monthlyRitualTargetLabel => '目标天数';

  @override
  String monthlyRitualTargetValue(int count) {
    return '$count 天';
  }

  @override
  String get monthlyRitualRewardHint => '完成后我要奖励自己...';

  @override
  String get monthlyRitualRewardLabel => '奖励';

  @override
  String monthlyRitualProgress(int completed, int target) {
    return '已完成 $completed/$target 天 ✨';
  }

  @override
  String get monthlyRitualAchieved => '达成目标！🎉';

  @override
  String get monthlyRitualEncouragement => '每一天都算数';

  @override
  String get achievementLightFirstName => '第一缕光';

  @override
  String get achievementLightFirstDesc => '记录第一个每日一点光';

  @override
  String get achievementLight7Name => '一周之光';

  @override
  String get achievementLight7Desc => '累计记录 7 天一点光';

  @override
  String get achievementLight30Name => '月光收集者';

  @override
  String get achievementLight30Desc => '累计记录 30 天一点光';

  @override
  String get achievementLight100Name => '百日之光';

  @override
  String get achievementLight100Desc => '累计记录 100 天一点光';

  @override
  String get achievementReviewFirstName => '初次回顾';

  @override
  String get achievementReviewFirstDesc => '完成第一次周回顾';

  @override
  String get achievementReview4Name => '每月回顾家';

  @override
  String get achievementReview4Desc => '累计完成 4 次周回顾';

  @override
  String get achievementWorryResolved1Name => '第一次释然';

  @override
  String get achievementWorryResolved1Desc => '解决或释放你的第一个烦恼';

  @override
  String get achievementWorryResolved10Name => '烦恼轻语者';

  @override
  String get achievementWorryResolved10Desc => '累计解决或释放 10 个烦恼';

  @override
  String get notifBedtimeLight => '今天过得怎么样？花一点时间，留意一件美好的事 ✨';

  @override
  String get notifWeeklyReview => '周日晚上，适合回顾这一周 📖';

  @override
  String get notifMonthlyRitual => '新的一个月开始了！选一个习惯来专注吧 🌙';

  @override
  String get notifGentleReengagement => '没关系，什么时候回来都好 🌿';

  @override
  String get calendarMon => '一';

  @override
  String get calendarTue => '二';

  @override
  String get calendarWed => '三';

  @override
  String get calendarThu => '四';

  @override
  String get calendarFri => '五';

  @override
  String get calendarSat => '六';

  @override
  String get calendarSun => '日';

  @override
  String get historyWeeklyReviews => '周回顾';

  @override
  String historyHappyMoments(int count) {
    return '$count个幸福时刻';
  }

  @override
  String historyWeekRange(String startDate, String endDate) {
    return '$startDate - $endDate';
  }

  @override
  String get dailyDetailTitle => '每日详情';

  @override
  String get dailyDetailEdit => '编辑记录';

  @override
  String get dailyDetailLight => '今日一点光';

  @override
  String get dailyDetailTimeline => '今日时间轴';

  @override
  String get dailyDetailNoRecord => '该日未记录';

  @override
  String get dailyDetailGoRecord => '去记录';

  @override
  String get awarenessStatsTitle => '觉知统计';

  @override
  String get awarenessStatsMoodDistribution => '心情分布';

  @override
  String get awarenessStatsLightDays => '光之日';

  @override
  String get awarenessStatsWeeklyReviews => '周回顾';

  @override
  String get awarenessStatsResolutionRate => '解忧率';

  @override
  String get awarenessStatsTopTags => '高频标签';

  @override
  String get awarenessStatsMonthlyChallenge => '本月挑战';

  @override
  String get awarenessStatsStartRecording => '开始记录你的第一点光';

  @override
  String get timelineEventHint => '发生了什么？';

  @override
  String get tabToday => '今天';

  @override
  String get tabJourney => '旅程';

  @override
  String get tabProfile => '我的';

  @override
  String get onboardingWelcome => '你好';

  @override
  String get onboardingLumiIntro => '这里是 LUMI';

  @override
  String get onboardingSlogan => '每写一行，都是在为你的内心宇宙添一颗星';

  @override
  String get onboardingNamePrompt => '这本手册的主人是';

  @override
  String get onboardingNameHint => '你的名字';

  @override
  String get onboardingBirthdayPrompt => '你的生日';

  @override
  String get onboardingBirthdayMonth => '月';

  @override
  String get onboardingBirthdayDay => '日';

  @override
  String get onboardingStartDatePrompt => '你想从哪天开始这段旅程？';

  @override
  String get onboardingThreeThings => 'LUMI 只有三件小事';

  @override
  String get onboardingDailyLight => '睡前写一句';

  @override
  String get onboardingDailyLightSub => '今天的一点光';

  @override
  String get onboardingWeeklyReview => '周末回顾';

  @override
  String get onboardingWeeklyReviewSub => '三个幸福时刻';

  @override
  String get onboardingWorryJar => '写下烦恼';

  @override
  String get onboardingWorryJarSub => '放进烦恼罐';

  @override
  String get onboardingStart => '开始旅程';

  @override
  String get onboardingContinue => '继续';

  @override
  String get onboardingNext => '下一步';

  @override
  String todayGreeting(String name) {
    return '早上好，$name';
  }

  @override
  String get quickLightPlaceholder => '今天有什么让你微笑的事？';

  @override
  String get recordLight => '记录';

  @override
  String get noHabitsYet => '你还没有习惯，可以在月度计划里设定';

  @override
  String get segmentWeek => '本周';

  @override
  String get segmentMonth => '本月';

  @override
  String get segmentYear => '年度';

  @override
  String get segmentExplore => '探索';

  @override
  String get featureLockedTitle => '即将开放';

  @override
  String featureLockedMessage(int days) {
    return '再记录 $days 天就可以解锁了，不急，慢慢来';
  }

  @override
  String get weeklyPlanTitle => '本周计划';

  @override
  String get oneLineForSelf => '写一句话给这周的自己';

  @override
  String get urgentImportant => '必须做';

  @override
  String get importantNotUrgent => '要做';

  @override
  String get urgentNotImportant => '该做';

  @override
  String get wantToDo => '想做';

  @override
  String get monthlyGoals => '本月目标';

  @override
  String get smallWinChallenge => '小赢挑战';

  @override
  String get monthlyPassion => '本月热爱与坚持';

  @override
  String get moodTracker => '心情追踪';

  @override
  String get monthlyMemory => '本月记忆';

  @override
  String get monthlyAchievement => '本月成就';

  @override
  String get yearlyMessages => '年度寄语';

  @override
  String get growthPlan => '年度成长计划';

  @override
  String get annualCalendar => '我的年历';

  @override
  String get lumiStats => '我的星星';

  @override
  String totalStars(int count) {
    return '$count 颗星';
  }

  @override
  String get currentStreak => '当前连续';

  @override
  String get longestStreak => '最长连续';

  @override
  String get catCompanion => '猫咪伴侣';

  @override
  String get growthReview => '成长回望';

  @override
  String greetingLateNight(String name) {
    return '夜深了，$name';
  }

  @override
  String greetingMorning(String name) {
    return '早安，$name';
  }

  @override
  String greetingAfternoon(String name) {
    return '下午好，$name';
  }

  @override
  String greetingEvening(String name) {
    return '晚上好，$name';
  }

  @override
  String get greetingLateNightNoName => '夜深了';

  @override
  String get greetingMorningNoName => '早安';

  @override
  String get greetingAfternoonNoName => '下午好';

  @override
  String get greetingEveningNoName => '晚上好';

  @override
  String get journeyTitle => '旅程';

  @override
  String get journeySegmentWeek => '本周';

  @override
  String get journeySegmentMonth => '本月';

  @override
  String get journeySegmentYear => '年度';

  @override
  String get journeySegmentExplore => '探索';

  @override
  String get journeyMonthlyView => '月度视图';

  @override
  String get journeyYearlyView => '年度视图';

  @override
  String get journeyExploreActivities => '探索活动';

  @override
  String get journeyEditMonthlyPlan => '编辑月计划';

  @override
  String get journeyEditYearlyPlan => '编辑年度计划';

  @override
  String get quickLightTitle => '今天的一点光';

  @override
  String get quickLightHint => '写一句今天的心情...';

  @override
  String get quickLightRecord => '记录';

  @override
  String get quickLightSaveSuccess => '记录成功';

  @override
  String get quickLightSaveError => '保存失败，请重试';

  @override
  String get habitSnapshotTitle => '今日习惯';

  @override
  String get habitSnapshotEmpty => '你还没有习惯，可以在旅程里设定';

  @override
  String get habitSnapshotLoadError => '加载失败';

  @override
  String get worryJarTitle => '烦恼罐';

  @override
  String get worryJarLoadError => '加载失败';

  @override
  String get weeklyReviewEmpty => '记录本周的幸福时刻';

  @override
  String get weeklyReviewHappyMoments => '幸福时刻';

  @override
  String get weeklyReviewLoadError => '加载失败';

  @override
  String get weeklyPlanCardTitle => '本周计划';

  @override
  String weeklyPlanItemCount(int count) {
    return '$count 项';
  }

  @override
  String get weeklyPlanEmpty => '制定本周计划';

  @override
  String get weekMoodTitle => '本周心情';

  @override
  String get weekMoodLoadError => '心情加载失败';

  @override
  String featureLockedDaysRemaining(int remaining) {
    return '再记录 $remaining 天后解锁';
  }

  @override
  String get featureLockedSoon => '即将解锁';

  @override
  String get weeklyPlanScreenTitle => '本周计划';

  @override
  String get weeklyPlanSave => '保存';

  @override
  String get weeklyPlanSaveSuccess => '已保存';

  @override
  String get weeklyPlanSaveError => '保存失败';

  @override
  String get weeklyPlanOneLine => '写一句话给这周的自己';

  @override
  String get weeklyPlanOneLineHint => '这周我想...';

  @override
  String get weeklyPlanUrgentImportant => '紧急且重要';

  @override
  String get weeklyPlanImportantNotUrgent => '重要不紧急';

  @override
  String get weeklyPlanUrgentNotImportant => '紧急不重要';

  @override
  String get weeklyPlanNotUrgentNotImportant => '不紧急不重要';

  @override
  String get weeklyPlanAddHint => '添加...';

  @override
  String get weeklyPlanMustDo => '必须做';

  @override
  String get weeklyPlanShouldDo => '要做';

  @override
  String get weeklyPlanNeedToDo => '该做';

  @override
  String get weeklyPlanWantToDo => '想做';

  @override
  String monthlyCalendarYearMonth(int year, int month) {
    return '$year 年 $month 月';
  }

  @override
  String get monthlyCalendarLoadError => '加载失败';

  @override
  String get monthlyGoalsTitle => '本月目标';

  @override
  String monthlyGoalHint(int index) {
    return '目标 $index';
  }

  @override
  String get monthlySaveError => '保存失败';

  @override
  String get monthlyMemoryTitle => '本月记忆';

  @override
  String get monthlyMemoryHint => '这个月最美好的记忆是...';

  @override
  String get monthlyAchievementTitle => '本月成就';

  @override
  String get monthlyAchievementHint => '这个月我最骄傲的成就是...';

  @override
  String get yearlyMessagesTitle => '年度寄语';

  @override
  String get yearlyMessageBecome => '这一年我希望自己成为......';

  @override
  String get yearlyMessageGoals => '达成目标';

  @override
  String get yearlyMessageBreakthrough => '突破性完成';

  @override
  String get yearlyMessageDontDo => '不做（说不，也是在为重要的事腾位置）';

  @override
  String get yearlyMessageKeyword => '年度关键词（例：专注/勇敢/耐心/温柔）';

  @override
  String get yearlyMessageFutureSelf => '给亲爱的未来的我';

  @override
  String get yearlyMessageMotto => '我的座右铭';

  @override
  String get growthPlanTitle => '年度成长计划';

  @override
  String get growthPlanHint => '我的计划...';

  @override
  String get growthPlanSaveError => '保存失败';

  @override
  String get growthDimensionHealth => '身体健康';

  @override
  String get growthDimensionEmotion => '情绪管理';

  @override
  String get growthDimensionRelationship => '人际关系';

  @override
  String get growthDimensionCareer => '职业发展';

  @override
  String get growthDimensionFinance => '财务管理';

  @override
  String get growthDimensionLearning => '持续学习';

  @override
  String get growthDimensionCreativity => '创造力';

  @override
  String get growthDimensionSpirituality => '内在成长';

  @override
  String get smallWinTitle => '小赢挑战';

  @override
  String smallWinEmpty(int days) {
    return '设定一个 $days 天小挑战，每天坚持一点点';
  }

  @override
  String smallWinReward(String reward) {
    return '奖励: $reward';
  }

  @override
  String get smallWinLoadError => '加载失败';

  @override
  String get smallWinLawVisible => '看得见';

  @override
  String get smallWinLawAttractive => '想去做';

  @override
  String get smallWinLawEasy => '易上手';

  @override
  String get smallWinLawRewarding => '有奖励';

  @override
  String get moodTrackerTitle => '心情追踪';

  @override
  String get moodTrackerLoadError => '加载失败';

  @override
  String moodTrackerCount(int count) {
    return '$count 次';
  }

  @override
  String get habitTrackerTitle => '本月热爱与坚持';

  @override
  String get habitTrackerComingSoon => '习惯追踪功能正在开发中';

  @override
  String get habitTrackerComingSoonHint => '在小赢挑战中设定你的习惯';

  @override
  String get listsTitle => '我的清单';

  @override
  String get listBookTitle => '书单';

  @override
  String get listMovieTitle => '影单';

  @override
  String get listCustomTitle => '自定义清单';

  @override
  String listItemCount(int count) {
    return '$count 条';
  }

  @override
  String get listDetailBookTitle => '我的书单';

  @override
  String get listDetailMovieTitle => '我的影单';

  @override
  String get listDetailCustomTitle => '我的清单';

  @override
  String get listDetailSave => '保存';

  @override
  String get listDetailSaveSuccess => '已保存';

  @override
  String get listDetailSaveError => '保存失败';

  @override
  String get listDetailCustomNameLabel => '清单名称';

  @override
  String get listDetailCustomNameHint => '例：我的播客清单';

  @override
  String get listDetailItemTitleHint => '标题';

  @override
  String get listDetailItemDateHint => '日期';

  @override
  String get listDetailItemGenreHint => '类型/标签';

  @override
  String get listDetailItemKeywordHint => '关键词/感受';

  @override
  String get listDetailYearTreasure => '年度宝藏';

  @override
  String get listDetailYearPick => '年度之选';

  @override
  String get listDetailYearPickHint => '这一年最值得推荐的一部';

  @override
  String get listDetailInsight => '灵感一击';

  @override
  String get listDetailInsightHint => '阅读/观影带给你的最大启发';

  @override
  String get exploreMyMoments => '我的时刻';

  @override
  String get exploreMyMomentsDesc => '记录幸福与高光时刻';

  @override
  String get exploreHabitPact => '我与习惯的约定';

  @override
  String get exploreHabitPactDesc => '基于原子习惯四定律设计你的新习惯';

  @override
  String get exploreWorryUnload => '烦恼减负日';

  @override
  String get exploreWorryUnloadDesc => '为你的烦恼分类：放下、行动或接受';

  @override
  String get exploreSelfPraise => '我的夸夸群';

  @override
  String get exploreSelfPraiseDesc => '写下自己的 5 个优点';

  @override
  String get exploreSupportMap => '我身边的人';

  @override
  String get exploreSupportMapDesc => '记录支持你的人';

  @override
  String get exploreFutureSelf => '未来照见我';

  @override
  String get exploreFutureSelfDesc => '想象 3 种未来的自己';

  @override
  String get exploreIdealVsReal => '理想的我 vs. 现在的我';

  @override
  String get exploreIdealVsRealDesc => '发现理想与现实的交集';

  @override
  String get highlightScreenTitle => '我的时刻';

  @override
  String get highlightTabHappy => '幸福时刻';

  @override
  String get highlightTabHighlight => '高光时刻';

  @override
  String get highlightEmptyHappy => '还没有记录幸福时刻';

  @override
  String get highlightEmptyHighlight => '还没有记录高光时刻';

  @override
  String highlightLoadError(String error) {
    return '加载失败: $error';
  }

  @override
  String get monthlyPlanScreenTitle => '月计划';

  @override
  String get monthlyPlanSave => '保存';

  @override
  String get monthlyPlanSaveSuccess => '已保存';

  @override
  String get monthlyPlanSaveError => '保存失败';

  @override
  String get monthlyPlanGoalsSection => '月目标';

  @override
  String get monthlyPlanChallengeSection => '小赢挑战';

  @override
  String get monthlyPlanChallengeNameLabel => '挑战习惯名称';

  @override
  String get monthlyPlanChallengeNameHint => '例：每天跑步 10 分钟';

  @override
  String get monthlyPlanRewardLabel => '完成后的奖励';

  @override
  String get monthlyPlanRewardHint => '例：买一本想看的书';

  @override
  String get monthlyPlanSelfCareSection => '爱自己活动';

  @override
  String monthlyPlanActivityHint(int index) {
    return '活动 $index';
  }

  @override
  String get monthlyPlanMemorySection => '本月记忆';

  @override
  String get monthlyPlanMemoryHint => '这个月最美好的记忆是...';

  @override
  String get monthlyPlanAchievementSection => '本月成就';

  @override
  String get monthlyPlanAchievementHint => '这个月我最骄傲的成就是...';

  @override
  String yearlyPlanScreenTitle(int year) {
    return '$year 年度计划';
  }

  @override
  String get yearlyPlanSave => '保存';

  @override
  String get yearlyPlanSaveSuccess => '已保存';

  @override
  String get yearlyPlanSaveError => '保存失败';

  @override
  String get yearlyPlanMessagesSection => '年度寄语';

  @override
  String get yearlyPlanGrowthSection => '成长计划';

  @override
  String get growthReviewScreenTitle => '成长回望';

  @override
  String get growthReviewMyMoments => '属于我的时刻';

  @override
  String get growthReviewEmptyMoments => '还没有记录高光时刻';

  @override
  String get growthReviewMySummary => '我的总结';

  @override
  String get growthReviewSummaryPrompt => '回顾这段旅程，你有什么想对自己说的？';

  @override
  String get growthReviewSmallWins => '小赢颁奖';

  @override
  String get growthReviewConsistentRecord => '坚持记录';

  @override
  String growthReviewRecordedDays(int count) {
    return '你已经记录了 $count 天';
  }

  @override
  String get growthReviewWeeklyChamp => '周回顾达人';

  @override
  String growthReviewCompletedReviews(int count) {
    return '完成了 $count 次周回顾';
  }

  @override
  String get growthReviewWarmClose => '温暖的收官';

  @override
  String get growthReviewEveryStar => '每一天的记录都是一颗星星';

  @override
  String growthReviewKeepShining(int count) {
    return '你已经收集了 $count 颗星星，继续闪耀吧！';
  }

  @override
  String get futureSelfScreenTitle => '未来照见我';

  @override
  String get futureSelfSubtitle => '想象 3 种未来的自己';

  @override
  String get futureSelfHint => '不需要完美答案，让想象自由流动';

  @override
  String get futureSelfStable => '稳定的未来';

  @override
  String get futureSelfStableHint => '如果一切顺利，稳定发展，你的生活会是什么样？';

  @override
  String get futureSelfFree => '自由的未来';

  @override
  String get futureSelfFreeHint => '如果没有任何限制，你最想做什么？';

  @override
  String get futureSelfPace => '按自己节奏发展的未来';

  @override
  String get futureSelfPaceHint => '不急不缓，你理想中的节奏是什么样的？';

  @override
  String get futureSelfCoreLabel => '你真正在意的是什么？';

  @override
  String get futureSelfCoreHint => '看看上面的 3 个版本，它们有什么共同点？那可能就是你内心最在意的...';

  @override
  String get habitPactScreenTitle => '我与习惯的约定';

  @override
  String get habitPactStep1 => '我想养成什么习惯？';

  @override
  String get habitPactCategoryLearning => '学习';

  @override
  String get habitPactCategoryHealth => '健康';

  @override
  String get habitPactCategoryRelationship => '关系';

  @override
  String get habitPactCategoryHobby => '兴趣';

  @override
  String get habitPactHabitLabel => '具体习惯';

  @override
  String get habitPactHabitHint => '例：每天读 20 页书';

  @override
  String get habitPactStep2 => '习惯四定律设计';

  @override
  String get habitPactLawVisible => '看得见';

  @override
  String get habitPactLawVisibleHint => '我会把提示放在...';

  @override
  String get habitPactLawAttractive => '想去做';

  @override
  String get habitPactLawAttractiveHint => '我会把它和...连在一起';

  @override
  String get habitPactLawEasy => '易上手';

  @override
  String get habitPactLawEasyHint => '我设计的最小版本是...';

  @override
  String get habitPactLawRewarding => '有奖励';

  @override
  String get habitPactLawRewardingHint => '完成后我会奖励自己...';

  @override
  String get habitPactStep3 => '行动宣言';

  @override
  String get habitPactDeclarationEmpty => '填写上方内容，自动生成宣言...';

  @override
  String habitPactDeclarationPrefix(String habit) {
    return '我决定养成「$habit」的习惯';
  }

  @override
  String habitPactDeclarationWhen(String cue) {
    return '当$cue时';
  }

  @override
  String habitPactDeclarationWill(String response) {
    return '我会$response';
  }

  @override
  String habitPactDeclarationThen(String reward) {
    return '然后$reward';
  }

  @override
  String get idealVsRealScreenTitle => '理想的我 vs. 现在的我';

  @override
  String get idealVsRealIdeal => '理想的我';

  @override
  String get idealVsRealIdealHint => '我希望自己是什么样的人？';

  @override
  String get idealVsRealReal => '现在的我';

  @override
  String get idealVsRealRealHint => '我现在是什么样的人？';

  @override
  String get idealVsRealSame => '有哪些相同点？';

  @override
  String get idealVsRealSameHint => '理想和现实之间，已经有哪些重合的地方？';

  @override
  String get idealVsRealDiff => '有哪些不同？';

  @override
  String get idealVsRealDiffHint => '差距在哪里？这些差距让你有什么感受？';

  @override
  String get idealVsRealStep => '靠近理想，我只需要迈出一小步';

  @override
  String get idealVsRealStepHint => '今天就可以做的一件小事是...';

  @override
  String get selfPraiseScreenTitle => '我的夸夸群';

  @override
  String get selfPraiseSubtitle => '写下你的 5 个优点';

  @override
  String get selfPraiseHint => '每个人都值得被看见，尤其是自己';

  @override
  String selfPraiseStrengthLabel(int index) {
    return '优点 $index';
  }

  @override
  String get selfPraisePrompt1 => '我最温暖的品质是...';

  @override
  String get selfPraisePrompt2 => '我擅长的一件事是...';

  @override
  String get selfPraisePrompt3 => '别人常夸我的是...';

  @override
  String get selfPraisePrompt4 => '我为自己骄傲的地方是...';

  @override
  String get selfPraisePrompt5 => '我的独特之处是...';

  @override
  String get supportMapScreenTitle => '我身边的人';

  @override
  String get supportMapSubtitle => '谁在支持你？';

  @override
  String get supportMapHint => '记录身边重要的人，提醒自己并不孤单';

  @override
  String get supportMapNameLabel => '姓名';

  @override
  String get supportMapRelationLabel => '关系';

  @override
  String get supportMapRelationHint => '例：朋友/家人/同事';

  @override
  String get supportMapAdd => '添加';

  @override
  String get worryUnloadScreenTitle => '烦恼减负日';

  @override
  String worryUnloadLoadError(String error) {
    return '加载失败: $error';
  }

  @override
  String get worryUnloadEmptyTitle => '没有进行中的烦恼';

  @override
  String get worryUnloadEmptyHint => '太棒了！今天是轻松的一天';

  @override
  String get worryUnloadIntro => '看看你的烦恼，为它们分个类吧';

  @override
  String get worryUnloadLetGo => '可以放下';

  @override
  String get worryUnloadTakeAction => '可以行动';

  @override
  String get worryUnloadAccept => '暂时接受';

  @override
  String get worryUnloadResultTitle => '减负结果';

  @override
  String worryUnloadSummary(String label, int count) {
    return '$label: $count 个';
  }

  @override
  String get worryUnloadEncouragement => '每一个分类都是前进的一步。';

  @override
  String get commonSaved => '已保存';

  @override
  String get commonSaveError => '保存失败';

  @override
  String get commonLoadError => '加载失败';

  @override
  String get momentEditTitle => '编辑时刻';

  @override
  String get momentNewHappy => '记录幸福时刻';

  @override
  String get momentNewHighlight => '记录高光时刻';

  @override
  String get momentDescHappy => '幸福的事';

  @override
  String get momentDescHighlight => '发生了什么';

  @override
  String get momentCompanionHappy => '和谁在一起';

  @override
  String get momentCompanionHighlight => '我做了什么';

  @override
  String get momentFeeling => '感受';

  @override
  String get momentDate => '日期 (YYYY-MM-DD)';

  @override
  String get momentRating => '评分';

  @override
  String get momentDescRequired => '请填写描述';

  @override
  String momentWithCompanion(String companion) {
    return '和$companion一起';
  }

  @override
  String momentDidAction(String action) {
    return '我做了：$action';
  }

  @override
  String get annualCalendarTitle => '我的年历';

  @override
  String annualCalendarMonthLabel(int month) {
    return '$month 月';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class SZhHant extends SZh {
  SZhHant() : super('zh_Hant');

  @override
  String get appTitle => 'Hachimi - 點亮內心宇宙';

  @override
  String get homeTabToday => '今日';

  @override
  String get homeTabCatHouse => '貓屋';

  @override
  String get homeTabStats => '統計';

  @override
  String get homeTabProfile => '我的';

  @override
  String get adoptionStepDefineHabit => '設定習慣';

  @override
  String get adoptionStepAdoptCat => '領養貓咪';

  @override
  String get adoptionStepNameCat => '改個名字';

  @override
  String get adoptionHabitName => '習慣名稱';

  @override
  String get adoptionHabitNameHint => '例如：每日閱讀';

  @override
  String get adoptionDailyGoal => '每日目標';

  @override
  String get adoptionTargetHours => '目標時數';

  @override
  String get adoptionTargetHoursHint => '完成呢個習慣嘅總時數';

  @override
  String adoptionMinutes(int count) {
    return '$count 分鐘';
  }

  @override
  String get adoptionRefreshCat => '換一隻';

  @override
  String adoptionPersonality(String name) {
    return '性格：$name';
  }

  @override
  String get adoptionNameYourCat => '幫貓咪改個名';

  @override
  String get adoptionRandomName => '隨機';

  @override
  String get adoptionCreate => '建立習慣並領養';

  @override
  String get adoptionNext => '下一步';

  @override
  String get adoptionBack => '上一步';

  @override
  String get adoptionCatNameLabel => '貓咪名字';

  @override
  String get adoptionCatNameHint => '例如：麻糬';

  @override
  String get adoptionRandomNameTooltip => '隨機名字';

  @override
  String get catHouseTitle => '貓屋';

  @override
  String get catHouseEmpty => '仲未有貓咪！建立一個習慣嚟領養你第一隻貓。';

  @override
  String catHouseGrowth(int minutes, int target) {
    return '$minutes / $target 分鐘';
  }

  @override
  String get catDetailGrowthProgress => '成長進度';

  @override
  String catDetailTotalMinutes(int minutes) {
    return '已專注 $minutes 分鐘';
  }

  @override
  String catDetailTargetMinutes(int minutes) {
    return '目標：$minutes 分鐘';
  }

  @override
  String get catDetailRename => '改名';

  @override
  String get catDetailAccessories => '飾品';

  @override
  String get catDetailStartFocus => '開始專注';

  @override
  String get catDetailBoundHabit => '綁定習慣';

  @override
  String catDetailStage(String stage) {
    return '階段：$stage';
  }

  @override
  String coinBalance(int amount) {
    return '$amount 金幣';
  }

  @override
  String coinCheckInReward(int amount) {
    return '+$amount 金幣！';
  }

  @override
  String get coinCheckInTitle => '每日簽到';

  @override
  String get coinInsufficientBalance => '金幣不足';

  @override
  String get shopTitle => '飾品商店';

  @override
  String shopPrice(int price) {
    return '$price 金幣';
  }

  @override
  String get shopPurchase => '購買';

  @override
  String get shopEquipped => '已裝備';

  @override
  String focusCompleteMinutes(int minutes) {
    return '+$minutes 分鐘';
  }

  @override
  String get focusCompleteStageUp => '階段提升！';

  @override
  String get focusCompleteGreatJob => '做得好！';

  @override
  String get focusCompleteDone => '完成';

  @override
  String get focusCompleteItsOkay => '冇關係！';

  @override
  String focusCompleteEvolved(String catName) {
    return '$catName 進化咗！';
  }

  @override
  String focusCompleteFocusedFor(int minutes) {
    return '你專注咗 $minutes 分鐘';
  }

  @override
  String focusCompleteAbandonedMessage(String catName) {
    return '$catName 話：「我哋下次再嚟！」';
  }

  @override
  String get focusCompleteFocusTime => '專注時長';

  @override
  String get focusCompleteCoinsEarned => '獲得金幣';

  @override
  String get focusCompleteBaseXp => '基礎 XP';

  @override
  String get focusCompleteStreakBonus => '連續獎勵';

  @override
  String get focusCompleteMilestoneBonus => '里程碑獎勵';

  @override
  String get focusCompleteFullHouseBonus => '全勤獎勵';

  @override
  String get focusCompleteTotal => '總計';

  @override
  String focusCompleteEvolvedTo(String stage) {
    return '進化到 $stage！';
  }

  @override
  String get focusCompleteYourCat => '你嘅貓咪';

  @override
  String get focusCompleteDiaryWriting => '正在寫日記⋯';

  @override
  String get focusCompleteDiaryWritten => '日記寫好喇！';

  @override
  String get focusCompleteDiarySkipped => '日記已跳過';

  @override
  String get focusCompleteNotifTitle => '任務完成！';

  @override
  String focusCompleteNotifBody(String catName, int xp, int minutes) {
    return '$catName 透過 $minutes 分鐘專注獲得咗 +$xp XP';
  }

  @override
  String get stageKitten => '幼貓';

  @override
  String get stageAdolescent => '少年貓';

  @override
  String get stageAdult => '成年貓';

  @override
  String get stageSenior => '長老貓';

  @override
  String get migrationTitle => '資料更新';

  @override
  String get migrationMessage => 'Hachimi 已升級為全新嘅像素貓系統！舊嘅貓咪資料唔再兼容，請重置以體驗全新版本。';

  @override
  String get migrationResetButton => '重置並開始';

  @override
  String get sessionResumeTitle => '恢復工作階段？';

  @override
  String sessionResumeMessage(String habitName, String elapsed) {
    return '你有一個未完成嘅專注工作階段（$habitName，$elapsed）。係咪恢復？';
  }

  @override
  String get sessionResumeButton => '恢復';

  @override
  String get sessionDiscard => '捨棄';

  @override
  String get todaySummaryMinutes => '今日';

  @override
  String get todaySummaryTotal => '總計';

  @override
  String get todaySummaryCats => '貓咪';

  @override
  String get todayYourQuests => '你嘅任務';

  @override
  String get todayNoQuests => '仲未有任務';

  @override
  String get todayNoQuestsHint => '撳 + 開始一個任務並領養一隻貓！';

  @override
  String get todayFocus => '專注';

  @override
  String get todayDeleteQuestTitle => '刪除任務？';

  @override
  String todayDeleteQuestMessage(String name) {
    return '確定要刪除「$name」？貓咪會被送入圖鑑。';
  }

  @override
  String todayQuestCompleted(String name) {
    return '$name 已完成';
  }

  @override
  String get todayFailedToLoad => '載入任務失敗';

  @override
  String todayMinToday(int count) {
    return '今日 $count 分鐘';
  }

  @override
  String todayGoalMinPerDay(int count) {
    return '目標：$count 分鐘/日';
  }

  @override
  String get todayFeaturedCat => '明星貓咪';

  @override
  String get todayAddHabit => '新增習慣';

  @override
  String get todayNoHabits => '建立你第一個習慣嚟開始啦！';

  @override
  String get todayNewQuest => '新任務';

  @override
  String get todayStartFocus => '開始專注';

  @override
  String get timerStart => '開始';

  @override
  String get timerPause => '暫停';

  @override
  String get timerResume => '繼續';

  @override
  String get timerDone => '完成';

  @override
  String get timerGiveUp => '放棄';

  @override
  String get timerRemaining => '剩餘';

  @override
  String get timerElapsed => '已用時';

  @override
  String get timerPaused => '已暫停';

  @override
  String get timerQuestNotFound => '搵唔到任務';

  @override
  String get timerNotificationBanner => '啟用通知以喺背景查睇計時進度';

  @override
  String get timerNotificationDismiss => '忽略';

  @override
  String get timerNotificationEnable => '啟用';

  @override
  String timerGraceBack(int seconds) {
    return '返回（${seconds}s）';
  }

  @override
  String get giveUpTitle => '放棄？';

  @override
  String get giveUpMessage => '如果你已專注超過 5 分鐘，時間仍會計入貓咪嘅成長。貓咪會明白㗎！';

  @override
  String get giveUpKeepGoing => '繼續努力';

  @override
  String get giveUpConfirm => '放棄';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsGeneral => '一般';

  @override
  String get settingsAppearance => '外觀';

  @override
  String get settingsNotifications => '通知';

  @override
  String get settingsNotificationFocusReminders => '專注提醒';

  @override
  String get settingsNotificationSubtitle => '接收每日提醒以保持進度';

  @override
  String get settingsLanguage => '語言';

  @override
  String get settingsLanguageSystem => '跟隨系統';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageChinese => '中文';

  @override
  String get settingsThemeMode => '主題模式';

  @override
  String get settingsThemeModeSystem => '跟隨系統';

  @override
  String get settingsThemeModeLight => '淺色';

  @override
  String get settingsThemeModeDark => '深色';

  @override
  String get settingsThemeColor => '主題顏色';

  @override
  String get settingsThemeColorDynamic => '動態';

  @override
  String get settingsThemeColorDynamicSubtitle => '使用桌布顏色';

  @override
  String get settingsAbout => '關於';

  @override
  String get settingsVersion => '版本';

  @override
  String get settingsLicenses => '開放原始碼授權';

  @override
  String get settingsAccount => '帳號';

  @override
  String get logoutTitle => '登出？';

  @override
  String get logoutMessage => '確定要登出？';

  @override
  String get loggingOut => '正在登出...';

  @override
  String get deleteAccountTitle => '刪除帳號？';

  @override
  String get deleteAccountMessage => '呢個操作會永久刪除你嘅帳號同所有資料，無法復原。';

  @override
  String get deleteAccountWarning => '呢個操作無法復原';

  @override
  String get profileTitle => '我的';

  @override
  String get profileYourJourney => '你嘅旅程';

  @override
  String get profileTotalFocus => '總專注';

  @override
  String get profileTotalCats => '貓咪總數';

  @override
  String get profileTotalQuests => '任務';

  @override
  String get profileEditName => '修改名稱';

  @override
  String get profileDisplayName => '顯示名稱';

  @override
  String get profileChooseAvatar => '選擇頭像';

  @override
  String get profileSaved => '資料已儲存';

  @override
  String get profileSettings => '設定';

  @override
  String get habitDetailStreak => '連續';

  @override
  String get habitDetailBestStreak => '最佳';

  @override
  String get habitDetailTotalMinutes => '總計';

  @override
  String get commonCancel => '取消';

  @override
  String get commonConfirm => '確認';

  @override
  String get commonSave => '儲存';

  @override
  String get commonDelete => '刪除';

  @override
  String get commonEdit => '編輯';

  @override
  String get commonDone => '完成';

  @override
  String get commonDismiss => '忽略';

  @override
  String get commonEnable => '啟用';

  @override
  String get commonLoading => '載入中⋯';

  @override
  String get commonError => '出咗啲問題';

  @override
  String get commonRetry => '重試';

  @override
  String get commonResume => '繼續';

  @override
  String get commonPause => '暫停';

  @override
  String get commonLogOut => '登出';

  @override
  String get commonDeleteAccount => '刪除帳號';

  @override
  String get commonYes => '係';

  @override
  String chatDailyRemaining(int count) {
    return '今天還可以傳送 $count 條訊息';
  }

  @override
  String get chatDailyLimitReached => '今日訊息額度已用完';

  @override
  String get aiTemporarilyUnavailable => 'AI 功能暫時無法使用';

  @override
  String get catDetailNotFound => '搵唔到貓咪';

  @override
  String get catDetailLoadError => '載入貓咪資料失敗';

  @override
  String get catDetailChatTooltip => '聊天';

  @override
  String get catDetailRenameTooltip => '改名';

  @override
  String get catDetailGrowthTitle => '成長進度';

  @override
  String catDetailTarget(int hours) {
    return '目標：${hours}h';
  }

  @override
  String get catDetailRenameTitle => '幫貓咪改名';

  @override
  String get catDetailNewName => '新名字';

  @override
  String get catDetailRenamed => '貓咪已改名！';

  @override
  String get catDetailQuestBadge => '任務';

  @override
  String get catDetailEditQuest => '編輯任務';

  @override
  String get catDetailDailyGoal => '每日目標';

  @override
  String get catDetailTodaysFocus => '今日專注';

  @override
  String get catDetailTotalFocus => '總專注';

  @override
  String get catDetailTargetLabel => '目標';

  @override
  String get catDetailCompletion => '完成度';

  @override
  String get catDetailCurrentStreak => '目前連續';

  @override
  String get catDetailBestStreakLabel => '最長連續';

  @override
  String get catDetailAvgDaily => '日均';

  @override
  String get catDetailDaysActive => '活躍天數';

  @override
  String get catDetailCheckInDays => '打卡天數';

  @override
  String get catDetailEditQuestTitle => '編輯任務';

  @override
  String get catDetailQuestName => '任務名稱';

  @override
  String get catDetailDailyGoalMinutes => '每日目標（分鐘）';

  @override
  String get catDetailTargetTotalHours => '目標總時數（小時）';

  @override
  String get catDetailQuestUpdated => '任務已更新！';

  @override
  String get catDetailTargetCompletedHint => '目標已達成，已轉為永續模式';

  @override
  String get catDetailDailyReminder => '每日提醒';

  @override
  String catDetailEveryDay(String time) {
    return '每日 $time';
  }

  @override
  String get catDetailNoReminder => '未設定提醒';

  @override
  String get catDetailChange => '更改';

  @override
  String get catDetailRemoveReminder => '移除提醒';

  @override
  String get catDetailSet => '設定';

  @override
  String catDetailReminderSet(String time) {
    return '提醒已設定為 $time';
  }

  @override
  String get catDetailReminderRemoved => '提醒已移除';

  @override
  String get catDetailDiaryTitle => 'Hachimi 日記';

  @override
  String get catDetailDiaryLoading => '載入中⋯';

  @override
  String get catDetailDiaryError => '無法載入日記';

  @override
  String get catDetailDiaryEmpty => '今日仲未有日記。完成一次專注啦！';

  @override
  String catDetailChatWith(String name) {
    return '同 $name 傾偈';
  }

  @override
  String get catDetailChatSubtitle => '同你嘅貓咪對話';

  @override
  String get catDetailActivity => '活動';

  @override
  String get catDetailActivityError => '載入活動資料失敗';

  @override
  String get catDetailAccessoriesTitle => '飾品';

  @override
  String get catDetailEquipped => '已裝備：';

  @override
  String get catDetailNone => '無';

  @override
  String get catDetailUnequip => '卸下';

  @override
  String catDetailFromInventory(int count) {
    return '道具箱（$count）';
  }

  @override
  String get catDetailNoAccessories => '仲未有飾品。去商店睇吓啦！';

  @override
  String catDetailEquippedItem(String name) {
    return '已裝備 $name';
  }

  @override
  String get catDetailUnequipped => '已卸下';

  @override
  String catDetailAbout(String name) {
    return '關於 $name';
  }

  @override
  String get catDetailAppearanceDetails => '外觀詳情';

  @override
  String get catDetailStatus => '狀態';

  @override
  String get catDetailAdopted => '領養日期';

  @override
  String get catDetailFurPattern => '毛色花紋';

  @override
  String get catDetailFurColor => '毛色';

  @override
  String get catDetailFurLength => '毛長';

  @override
  String get catDetailEyes => '眼睛';

  @override
  String get catDetailWhitePatches => '白色斑塊';

  @override
  String get catDetailPatchesTint => '斑塊色調';

  @override
  String get catDetailTint => '色調';

  @override
  String get catDetailPoints => '重點色';

  @override
  String get catDetailVitiligo => '白斑';

  @override
  String get catDetailTortoiseshell => '玳瑁';

  @override
  String get catDetailTortiePattern => '玳瑁花紋';

  @override
  String get catDetailTortieColor => '玳瑁顏色';

  @override
  String get catDetailSkin => '膚色';

  @override
  String get offlineMessage => '你已離線——重新連線時會自動同步';

  @override
  String get offlineModeLabel => '離線模式';

  @override
  String habitTodayMinutes(int count) {
    return '今日：$count分鐘';
  }

  @override
  String get habitDeleteTooltip => '刪除習慣';

  @override
  String get heatmapActiveDays => '活躍天數';

  @override
  String get heatmapTotal => '總計';

  @override
  String get heatmapRate => '達標率';

  @override
  String get heatmapLess => '少';

  @override
  String get heatmapMore => '多';

  @override
  String get accessoryEquipped => '已裝備';

  @override
  String get accessoryOwned => '已擁有';

  @override
  String get pickerMinUnit => '分鐘';

  @override
  String get settingsBackgroundAnimation => '動態背景';

  @override
  String get settingsBackgroundAnimationSubtitle => '流體漸層同浮動粒子效果';

  @override
  String get settingsUiStyle => '介面風格';

  @override
  String get settingsUiStyleMaterial => 'Material 3';

  @override
  String get settingsUiStyleRetroPixel => '復古像素';

  @override
  String get settingsUiStyleMaterialSubtitle => '現代圓角 Material 設計';

  @override
  String get settingsUiStyleRetroPixelSubtitle => '溫暖的像素藝術風格';

  @override
  String get personalityLazy => '慵懶';

  @override
  String get personalityCurious => '好奇';

  @override
  String get personalityPlayful => '活潑';

  @override
  String get personalityShy => '怕醜';

  @override
  String get personalityBrave => '勇敢';

  @override
  String get personalityClingy => '痴纏';

  @override
  String get personalityFlavorLazy => '一日要瞓 23 個鐘。剩低嗰個鐘？都係瞓。';

  @override
  String get personalityFlavorCurious => '已經周圍聞嚟聞去喇！';

  @override
  String get personalityFlavorPlayful => '停唔到咁追蝴蝶！';

  @override
  String get personalityFlavorShy => '用咗 3 分鐘先至肯從箱入面探個頭出嚟⋯';

  @override
  String get personalityFlavorBrave => '箱都未打開就跳咗出嚟！';

  @override
  String get personalityFlavorClingy => '即刻開始咕嚕咕嚕，點都唔肯放手。';

  @override
  String get moodHappy => '開心';

  @override
  String get moodNeutral => '平靜';

  @override
  String get moodLonely => '孤單';

  @override
  String get moodMissing => '掛住你';

  @override
  String get moodMsgLazyHappy => '喵~！係時候瞓個靚覺喇⋯';

  @override
  String get moodMsgCuriousHappy => '今日我哋去探索啲咩？';

  @override
  String get moodMsgPlayfulHappy => '喵~！準備好做嘢喇！';

  @override
  String get moodMsgShyHappy => '⋯你、你喺度就好喇。';

  @override
  String get moodMsgBraveHappy => '一齊征服今日啦！';

  @override
  String get moodMsgClingyHappy => '耶！你返嚟喇！唔好再走喇！';

  @override
  String get moodMsgLazyNeutral => '*呵欠* 噢，你嚟喇⋯';

  @override
  String get moodMsgCuriousNeutral => '嗯？嗰邊係咩嚟㗎？';

  @override
  String get moodMsgPlayfulNeutral => '想玩嘢？算喇，遲啲先⋯';

  @override
  String get moodMsgShyNeutral => '*慢慢咁探個頭出嚟*';

  @override
  String get moodMsgBraveNeutral => '一如既往咁企崗。';

  @override
  String get moodMsgClingyNeutral => '我一直等緊你⋯';

  @override
  String get moodMsgLazyLonely => '連瞓覺都覺得好孤獨⋯';

  @override
  String get moodMsgCuriousLonely => '唔知你幾時返嚟⋯';

  @override
  String get moodMsgPlayfulLonely => '冇咗你，啲玩具都唔好玩⋯';

  @override
  String get moodMsgShyLonely => '*靜靜咁捲埋自己*';

  @override
  String get moodMsgBraveLonely => '我會繼續等。我好勇敢㗎。';

  @override
  String get moodMsgClingyLonely => '你去咗邊⋯ 🥺';

  @override
  String get moodMsgLazyMissing => '*滿懷期待咁擘開一隻眼*';

  @override
  String get moodMsgCuriousMissing => '係咪發生咗啲咩事⋯？';

  @override
  String get moodMsgPlayfulMissing => '我幫你留住咗你最鍾意嘅玩具⋯';

  @override
  String get moodMsgShyMissing => '*收埋咗，但係一直望住度門*';

  @override
  String get moodMsgBraveMissing => '我知你會返嚟。我相信。';

  @override
  String get moodMsgClingyMissing => '好掛住你⋯ 快啲返嚟啦。';

  @override
  String get peltTypeTabby => '經典虎斑紋';

  @override
  String get peltTypeTicked => '刺鼠紋';

  @override
  String get peltTypeMackerel => '鯖魚紋';

  @override
  String get peltTypeClassic => '經典漩渦紋';

  @override
  String get peltTypeSokoke => '索科克大理石紋';

  @override
  String get peltTypeAgouti => '刺鼠色';

  @override
  String get peltTypeSpeckled => '斑點毛';

  @override
  String get peltTypeRosette => '玫瑰斑紋';

  @override
  String get peltTypeSingleColour => '純色';

  @override
  String get peltTypeTwoColour => '雙色';

  @override
  String get peltTypeSmoke => '煙色漸層';

  @override
  String get peltTypeSinglestripe => '單條紋';

  @override
  String get peltTypeBengal => '豹紋';

  @override
  String get peltTypeMarbled => '大理石紋';

  @override
  String get peltTypeMasked => '面罩臉';

  @override
  String get peltColorWhite => '白色';

  @override
  String get peltColorPaleGrey => '淺灰色';

  @override
  String get peltColorSilver => '銀色';

  @override
  String get peltColorGrey => '灰色';

  @override
  String get peltColorDarkGrey => '深灰色';

  @override
  String get peltColorGhost => '幽灰色';

  @override
  String get peltColorBlack => '黑色';

  @override
  String get peltColorCream => '忌廉色';

  @override
  String get peltColorPaleGinger => '淺薑黃色';

  @override
  String get peltColorGolden => '金色';

  @override
  String get peltColorGinger => '薑黃色';

  @override
  String get peltColorDarkGinger => '深薑黃色';

  @override
  String get peltColorSienna => '赭色';

  @override
  String get peltColorLightBrown => '淺棕色';

  @override
  String get peltColorLilac => '丁香色';

  @override
  String get peltColorBrown => '棕色';

  @override
  String get peltColorGoldenBrown => '金棕色';

  @override
  String get peltColorDarkBrown => '深棕色';

  @override
  String get peltColorChocolate => '朱古力色';

  @override
  String get eyeColorYellow => '黃色';

  @override
  String get eyeColorAmber => '琥珀色';

  @override
  String get eyeColorHazel => '榛色';

  @override
  String get eyeColorPaleGreen => '淺綠色';

  @override
  String get eyeColorGreen => '綠色';

  @override
  String get eyeColorBlue => '藍色';

  @override
  String get eyeColorDarkBlue => '深藍色';

  @override
  String get eyeColorBlueYellow => '藍黃色';

  @override
  String get eyeColorBlueGreen => '藍綠色';

  @override
  String get eyeColorGrey => '灰色';

  @override
  String get eyeColorCyan => '青色';

  @override
  String get eyeColorEmerald => '翡翠色';

  @override
  String get eyeColorHeatherBlue => '石楠藍';

  @override
  String get eyeColorSunlitIce => '冰晶色';

  @override
  String get eyeColorCopper => '銅色';

  @override
  String get eyeColorSage => '鼠尾草色';

  @override
  String get eyeColorCobalt => '鈷藍色';

  @override
  String get eyeColorPaleBlue => '淺藍色';

  @override
  String get eyeColorBronze => '青銅色';

  @override
  String get eyeColorSilver => '銀色';

  @override
  String get eyeColorPaleYellow => '淺黃色';

  @override
  String eyeDescNormal(String color) {
    return '$color眼睛';
  }

  @override
  String eyeDescHeterochromia(String primary, String secondary) {
    return '異色瞳（$primary / $secondary）';
  }

  @override
  String get skinColorPink => '粉紅色';

  @override
  String get skinColorRed => '紅色';

  @override
  String get skinColorBlack => '黑色';

  @override
  String get skinColorDark => '深色';

  @override
  String get skinColorDarkBrown => '深棕色';

  @override
  String get skinColorBrown => '棕色';

  @override
  String get skinColorLightBrown => '淺棕色';

  @override
  String get skinColorDarkGrey => '深灰色';

  @override
  String get skinColorGrey => '灰色';

  @override
  String get skinColorDarkSalmon => '深三文魚色';

  @override
  String get skinColorSalmon => '三文魚色';

  @override
  String get skinColorPeach => '桃色';

  @override
  String get furLengthLonghair => '長毛';

  @override
  String get furLengthShorthair => '短毛';

  @override
  String get whiteTintOffwhite => '米白色調';

  @override
  String get whiteTintCream => '忌廉色調';

  @override
  String get whiteTintDarkCream => '深忌廉色調';

  @override
  String get whiteTintGray => '灰色調';

  @override
  String get whiteTintPink => '粉紅色調';

  @override
  String notifReminderTitle(String catName) {
    return '$catName 掛住你！';
  }

  @override
  String notifReminderBody(String habitName) {
    return '$habitName 嘅時間到喇——貓咪喺度等你！';
  }

  @override
  String notifStreakTitle(String catName) {
    return '$catName 好擔心！';
  }

  @override
  String notifStreakBody(int streak) {
    return '你嘅 $streak 日連續紀錄有危險。快啲嚟一次專注啦！';
  }

  @override
  String notifEvolutionTitle(String catName) {
    return '$catName 進化咗！';
  }

  @override
  String notifEvolutionBody(String catName, String stageName) {
    return '$catName 成長為咗 $stageName！繼續努力！';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours時$minutes分';
  }

  @override
  String diaryScreenTitle(String name) {
    return '$name 嘅日記';
  }

  @override
  String get diaryFailedToLoad => '載入日記失敗';

  @override
  String get diaryEmptyTitle => '仲未有日記';

  @override
  String get diaryEmptyHint => '完成一次專注，貓咪就會寫低第一篇日記！';

  @override
  String get focusSetupCountdown => '倒數計時';

  @override
  String get focusSetupStopwatch => '正計時';

  @override
  String get focusSetupStartFocus => '開始專注';

  @override
  String get focusSetupQuestNotFound => '搵唔到任務';

  @override
  String get checkInButtonLogMore => '繼續記錄';

  @override
  String get checkInButtonStart => '開始計時';

  @override
  String get adoptionTitleFirst => '領養你第一隻貓！';

  @override
  String get adoptionTitleNew => '新任務';

  @override
  String get adoptionStepDefineQuest => '設定任務';

  @override
  String get adoptionStepAdoptCat2 => '領養貓咪';

  @override
  String get adoptionStepNameCat2 => '幫貓改名';

  @override
  String get adoptionAdopt => '領養！';

  @override
  String get adoptionQuestPrompt => '你想開始咩任務？';

  @override
  String get adoptionKittenHint => '會有一隻小貓分配嚟陪你堅持！';

  @override
  String get adoptionQuestName => '任務名稱';

  @override
  String get adoptionQuestHint => '例如 準備面試題目';

  @override
  String get adoptionTotalTarget => '總目標（小時）';

  @override
  String get adoptionGrowthHint => '你嘅貓會隨住你累積專注時間而成長';

  @override
  String get adoptionCustom => '自訂';

  @override
  String get adoptionDailyGoalLabel => '每日專注目標（分鐘）';

  @override
  String get adoptionReminderLabel => '每日提醒（可選）';

  @override
  String get adoptionReminderNone => '唔設定';

  @override
  String get adoptionCustomGoalTitle => '自訂每日目標';

  @override
  String get adoptionMinutesPerDay => '每日分鐘數';

  @override
  String get adoptionMinutesHint => '5 - 180';

  @override
  String get adoptionValidMinutes => '請輸入 5 至 180 之間嘅數值';

  @override
  String get adoptionCustomTargetTitle => '自訂目標時數';

  @override
  String get adoptionTotalHours => '總時數';

  @override
  String get adoptionHoursHint => '10 - 2000';

  @override
  String get adoptionValidHours => '請輸入 10 至 2000 之間嘅數值';

  @override
  String get adoptionSet => '設定';

  @override
  String get adoptionChooseKitten => '揀你嘅小貓！';

  @override
  String adoptionCompanionFor(String quest) {
    return '「$quest」嘅夥伴';
  }

  @override
  String get adoptionRerollAll => '全部重選';

  @override
  String get adoptionNameYourCat2 => '幫貓改個名';

  @override
  String get adoptionCatName => '貓名';

  @override
  String get adoptionCatHint => '例如 麻糬';

  @override
  String get adoptionRandomTooltip => '隨機名字';

  @override
  String adoptionGrowthTarget(String quest, int hours) {
    return '你嘅貓會喺你專注「$quest」時成長！目標：$hours 小時。';
  }

  @override
  String get adoptionValidQuestName => '請輸入任務名稱';

  @override
  String get adoptionValidCatName => '請幫貓咪改個名';

  @override
  String adoptionError(String message) {
    return '錯誤：$message';
  }

  @override
  String get adoptionBasicInfo => '基本資訊';

  @override
  String get adoptionGoals => '目標設定';

  @override
  String get adoptionUnlimitedMode => '永續模式';

  @override
  String get adoptionUnlimitedDesc => '不設上限，持續累積';

  @override
  String get adoptionMilestoneMode => '里程碑模式';

  @override
  String get adoptionMilestoneDesc => '設定一個目標';

  @override
  String get adoptionDeadlineLabel => '截止日期';

  @override
  String get adoptionDeadlineNone => '不設';

  @override
  String get adoptionReminderSection => '提醒';

  @override
  String get adoptionMotivationLabel => '備忘';

  @override
  String get adoptionMotivationHint => '寫點什麼備忘...';

  @override
  String get adoptionMotivationSwap => '隨機填充';

  @override
  String get loginAppName => 'Hachimi';

  @override
  String get loginTagline => '養貓咪，完成任務。';

  @override
  String get loginContinueGoogle => '以 Google 繼續';

  @override
  String get loginContinueEmail => '以電郵繼續';

  @override
  String get loginAlreadyHaveAccount => '已有帳號？';

  @override
  String get loginLogIn => '登入';

  @override
  String get loginWelcomeBack => '歡迎返嚟！';

  @override
  String get loginCreateAccount => '建立帳號';

  @override
  String get loginEmail => '電郵';

  @override
  String get loginPassword => '密碼';

  @override
  String get loginConfirmPassword => '確認密碼';

  @override
  String get loginValidEmail => '請輸入電郵';

  @override
  String get loginValidEmailFormat => '請輸入有效嘅電郵地址';

  @override
  String get loginValidPassword => '請輸入密碼';

  @override
  String get loginValidPasswordLength => '密碼至少要 6 個字元';

  @override
  String get loginValidPasswordMatch => '兩次密碼唔一致';

  @override
  String get loginCreateAccountButton => '建立帳號';

  @override
  String get loginNoAccount => '仲未有帳號？';

  @override
  String get loginRegister => '註冊';

  @override
  String get checkInTitle => '每月簽到';

  @override
  String get checkInDays => '日數';

  @override
  String get checkInCoinsEarned => '獲得金幣';

  @override
  String get checkInAllMilestones => '所有里程碑已達成！';

  @override
  String checkInMilestoneProgress(int remaining, int bonus) {
    return '仲差 $remaining 日 → +$bonus 金幣';
  }

  @override
  String get checkInMilestones => '里程碑';

  @override
  String get checkInFullMonth => '全月簽到';

  @override
  String get checkInRewardSchedule => '獎勵說明';

  @override
  String get checkInWeekday => '平日（週一至週五）';

  @override
  String checkInWeekdayReward(int coins) {
    return '$coins 金幣/日';
  }

  @override
  String get checkInWeekend => '週末（週六、週日）';

  @override
  String checkInNDays(int count) {
    return '$count 日';
  }

  @override
  String get onboardTitle1 => '認識你嘅伙伴';

  @override
  String get onboardSubtitle1 => '每段旅程由一隻小貓開始';

  @override
  String get onboardBody1 => '設定目標，領養一隻小貓。\n專注目標，睇住你嘅貓咪成長！';

  @override
  String get onboardTitle2 => '專注、成長、進化';

  @override
  String get onboardSubtitle2 => '4 個成長階段';

  @override
  String get onboardBody2 => '每分鐘嘅專注都幫助貓咪進化，\n由小小幼貓到威風凜凜嘅大貓！';

  @override
  String get onboardTitle3 => '打造你嘅貓屋';

  @override
  String get onboardSubtitle3 => '收集獨特貓咪';

  @override
  String get onboardBody3 => '每個任務都帶嚟一隻獨特外觀嘅新貓。\n收集佢哋，打造你嘅夢想收藏！';

  @override
  String get onboardSkip => '跳過';

  @override
  String get onboardLetsGo => '出發！';

  @override
  String get onboardNext => '下一步';

  @override
  String get catRoomTitle => '貓咪小屋';

  @override
  String get catRoomInventory => '背包';

  @override
  String get catRoomShop => '飾品商店';

  @override
  String get catRoomLoadError => '載入貓咪失敗';

  @override
  String get catRoomEmptyTitle => '貓咪小屋空空如也';

  @override
  String get catRoomEmptySubtitle => '開始一個任務嚟領養你第一隻貓！';

  @override
  String get catRoomEditQuest => '編輯任務';

  @override
  String get catRoomRenameCat => '幫貓咪改名';

  @override
  String get catRoomArchiveCat => '封存貓咪';

  @override
  String get catRoomNewName => '新名字';

  @override
  String get catRoomRename => '改名';

  @override
  String get catRoomArchiveTitle => '封存貓咪？';

  @override
  String catRoomArchiveMessage(String name) {
    return '呢個操作會封存「$name」並刪除其綁定嘅任務。貓咪仍會出現喺圖鑑。';
  }

  @override
  String get catRoomArchive => '封存';

  @override
  String catRoomAlbumSection(int count) {
    return '相簿（$count）';
  }

  @override
  String get catRoomReactivateCat => '重新啟用';

  @override
  String get catRoomReactivateTitle => '重新啟用貓咪？';

  @override
  String catRoomReactivateMessage(String name) {
    return '將「$name」同其綁定嘅任務恢復返貓咪小屋。';
  }

  @override
  String get catRoomReactivate => '啟用';

  @override
  String get catRoomArchivedLabel => '已封存';

  @override
  String catRoomArchiveSuccess(String name) {
    return '已封存「$name」';
  }

  @override
  String catRoomReactivateSuccess(String name) {
    return '已重新啟用「$name」';
  }

  @override
  String get catRoomArchiveError => '歸檔貓咪失敗';

  @override
  String get catRoomReactivateError => '恢復貓咪失敗';

  @override
  String get catRoomArchiveLoadError => '載入歸檔貓咪失敗';

  @override
  String get catRoomRenameError => '重新命名貓咪失敗';

  @override
  String get addHabitTitle => '新任務';

  @override
  String get addHabitQuestName => '任務名稱';

  @override
  String get addHabitQuestHint => '例如 LeetCode 練習';

  @override
  String get addHabitValidName => '請輸入任務名稱';

  @override
  String get addHabitTargetHours => '目標時數';

  @override
  String get addHabitTargetHint => '例如 100';

  @override
  String get addHabitValidTarget => '請輸入目標時數';

  @override
  String get addHabitValidNumber => '請輸入有效數字';

  @override
  String get addHabitCreate => '建立任務';

  @override
  String get addHabitHoursSuffix => '小時';

  @override
  String shopTabPlants(int count) {
    return '植物（$count）';
  }

  @override
  String shopTabWild(int count) {
    return '野生（$count）';
  }

  @override
  String shopTabCollars(int count) {
    return '頸圈（$count）';
  }

  @override
  String get shopNoAccessories => '暫無飾品';

  @override
  String shopBuyConfirm(String name) {
    return '購買 $name？';
  }

  @override
  String get shopPurchaseButton => '購買';

  @override
  String get shopNotEnoughCoinsButton => '金幣不足';

  @override
  String shopPurchaseSuccess(String name) {
    return '購買成功！$name 已加入背包';
  }

  @override
  String shopPurchaseFailed(int price) {
    return '金幣不足（需要 $price）';
  }

  @override
  String get inventoryTitle => '背包';

  @override
  String inventoryInBox(int count) {
    return '箱中（$count）';
  }

  @override
  String get inventoryEmpty => '背包空空如也。\n去商店購買飾品啦！';

  @override
  String inventoryEquippedOnCats(int count) {
    return '已裝備喺貓身上（$count）';
  }

  @override
  String get inventoryNoEquipped => '仲未有幫貓咪裝備飾品。';

  @override
  String get inventoryUnequip => '卸下';

  @override
  String get inventoryNoActiveCats => '冇活躍嘅貓咪';

  @override
  String inventoryEquipTo(String name) {
    return '將 $name 裝備畀：';
  }

  @override
  String inventoryEquipSuccess(String name) {
    return '已裝備 $name';
  }

  @override
  String inventoryUnequipSuccess(String catName) {
    return '已從 $catName 卸下';
  }

  @override
  String get chatCatNotFound => '搵唔到貓咪';

  @override
  String chatTitle(String name) {
    return '同 $name 傾偈';
  }

  @override
  String get chatClearHistory => '清除紀錄';

  @override
  String chatEmptyTitle(String name) {
    return '同 $name 打個招呼啦！';
  }

  @override
  String get chatEmptySubtitle => '開始同貓咪傾偈啦，佢會根據自己嘅性格嚟回覆你！';

  @override
  String get chatGenerating => '產生中⋯';

  @override
  String get chatTypeMessage => '輸入訊息⋯';

  @override
  String get chatClearConfirmTitle => '清除聊天紀錄？';

  @override
  String get chatClearConfirmMessage => '呢個操作會刪除所有訊息，無法復原。';

  @override
  String get chatClearButton => '清除';

  @override
  String get chatSend => '傳送';

  @override
  String get chatStop => '停止';

  @override
  String get chatErrorMessage => '傳送失敗，點擊重試';

  @override
  String get chatRetry => '重試';

  @override
  String get chatErrorGeneric => '出了點問題，請重試';

  @override
  String diaryTitle(String name) {
    return '$name 嘅日記';
  }

  @override
  String get diaryLoadFailed => '載入日記失敗';

  @override
  String get diaryRetry => '重試';

  @override
  String get diaryEmptyTitle2 => '仲未有日記';

  @override
  String get diaryEmptySubtitle => '完成一次專注，貓咪就會寫低第一篇日記！';

  @override
  String get statsTitle => '統計';

  @override
  String get statsTotalHours => '總時數';

  @override
  String statsTimeValue(int hours, int minutes) {
    return '$hours時$minutes分';
  }

  @override
  String get statsBestStreak => '最長連續';

  @override
  String statsStreakDays(int count) {
    return '$count 日';
  }

  @override
  String get statsOverallProgress => '整體進度';

  @override
  String statsPercentOfGoals(String percent) {
    return '$percent% 目標達成';
  }

  @override
  String get statsPerQuestProgress => '各任務進度';

  @override
  String get statsQuestLoadError => '載入任務統計失敗';

  @override
  String get statsNoQuestData => '仲未有任務資料';

  @override
  String get statsNoQuestHint => '開始一個任務嚟查看進度啦！';

  @override
  String get statsLast30Days => '最近 30 日';

  @override
  String get habitDetailQuestNotFound => '搵唔到任務';

  @override
  String get habitDetailComplete => '完成';

  @override
  String get habitDetailTotalTime => '總時數';

  @override
  String get habitDetailCurrentStreak => '目前連續';

  @override
  String get habitDetailTarget => '目標';

  @override
  String habitDetailDaysUnit(int count) {
    return '$count 日';
  }

  @override
  String habitDetailHoursUnit(int count) {
    return '$count 小時';
  }

  @override
  String checkInBannerSuccess(int coins) {
    return '+$coins 金幣！每日簽到完成';
  }

  @override
  String checkInBannerBonus(int bonus) {
    return ' + $bonus 里程碑獎勵！';
  }

  @override
  String get checkInBannerSemantics => '每日簽到';

  @override
  String get checkInBannerLoading => '載入簽到狀態⋯';

  @override
  String checkInBannerPrompt(int coins) {
    return '簽到領 +$coins 金幣';
  }

  @override
  String checkInBannerSummary(int count, int total, int coins) {
    return '$count/$total 日  ·  今日 +$coins';
  }

  @override
  String commonErrorWithDetail(String error) {
    return '錯誤：$error';
  }

  @override
  String get profileFallbackUser => '用戶';

  @override
  String get fallbackCatName => '貓咪';

  @override
  String get settingsLanguageTraditionalChinese => '繁體中文';

  @override
  String get settingsLanguageJapanese => '日本語';

  @override
  String get settingsLanguageKorean => '한국어';

  @override
  String get settingsLanguageSpanish => 'Español';

  @override
  String get settingsLanguagePortuguese => 'Português';

  @override
  String get settingsLanguageFrench => 'Français';

  @override
  String get settingsLanguageGerman => 'Deutsch';

  @override
  String get settingsLanguageItalian => 'Italiano';

  @override
  String get settingsLanguageHindi => 'हिन्दी';

  @override
  String get settingsLanguageThai => 'ไทย';

  @override
  String get settingsLanguageVietnamese => 'Tiếng Việt';

  @override
  String get settingsLanguageIndonesian => 'Bahasa Indonesia';

  @override
  String get settingsLanguageTurkish => 'Türkçe';

  @override
  String get notifFocusing => '專注中…';

  @override
  String get notifInProgress => '正在專注';

  @override
  String get unitMinShort => '分鐘';

  @override
  String get unitHourShort => '小時';

  @override
  String get weekdayMon => '一';

  @override
  String get weekdayTue => '二';

  @override
  String get weekdayWed => '三';

  @override
  String get weekdayThu => '四';

  @override
  String get weekdayFri => '五';

  @override
  String get weekdaySat => '六';

  @override
  String get weekdaySun => '日';

  @override
  String get statsTotalSessions => '專注次數';

  @override
  String get statsTotalHabits => '任務數';

  @override
  String get statsActiveDays => '活躍天數';

  @override
  String get statsWeeklyTrend => '本週趨勢';

  @override
  String get statsRecentSessions => '最近專注';

  @override
  String get statsViewAllHistory => '查看全部歷史';

  @override
  String get historyTitle => '專注歷史';

  @override
  String get historyFilterAll => '全部';

  @override
  String historySessionCount(int count) {
    return '$count 次專注';
  }

  @override
  String historyTotalMinutes(int minutes) {
    return '$minutes 分鐘';
  }

  @override
  String get historyNoSessions => '還沒有專注紀錄';

  @override
  String get historyNoSessionsHint => '完成一次專注就能在這裡看到紀錄';

  @override
  String get historyLoadMore => '載入更多';

  @override
  String get sessionCompleted => '已完成';

  @override
  String get sessionAbandoned => '已放棄';

  @override
  String get sessionInterrupted => '被中斷';

  @override
  String get sessionCountdown => '倒計時';

  @override
  String get sessionStopwatch => '正計時';

  @override
  String get historyDateGroupToday => '今天';

  @override
  String get historyDateGroupYesterday => '昨天';

  @override
  String get historyLoadError => '載入歷史記錄失敗';

  @override
  String get historySelectMonth => '選擇月份';

  @override
  String get historyAllMonths => '全部月份';

  @override
  String get historyAllHabits => '全部';

  @override
  String get homeTabAchievements => '成就';

  @override
  String get achievementTitle => '成就';

  @override
  String get achievementTabOverview => '概覽';

  @override
  String get achievementTabQuest => '任務';

  @override
  String get achievementTabStreak => '連續';

  @override
  String get achievementTabCat => '貓咪';

  @override
  String get achievementTabPersist => '堅持';

  @override
  String get achievementSummaryTitle => '成就進度';

  @override
  String achievementUnlockedCount(int count) {
    return '已解鎖 $count 個';
  }

  @override
  String achievementTotalCoins(int coins) {
    return '共獲 $coins 金幣';
  }

  @override
  String get achievementUnlocked => '成就解鎖！';

  @override
  String get achievementAwesome => '太棒了！';

  @override
  String get achievementIncredible => '不可思議！';

  @override
  String get achievementHidden => '???';

  @override
  String get achievementHiddenDesc => '這是一個隱藏成就';

  @override
  String achievementPersistDesc(int days) {
    return '累計打卡 $days 天';
  }

  @override
  String achievementTitleCount(int count) {
    return '已解鎖 $count 個稱號';
  }

  @override
  String get growthPathTitle => '成長之路';

  @override
  String get growthPathKitten => '開始新的旅程';

  @override
  String get growthPathAdolescent => '初步入門，建立基礎';

  @override
  String get growthPathAdult => '技能鞏固，完成一個項目';

  @override
  String get growthPathSenior => '深度投入，持續精進';

  @override
  String get growthPathTip => '研究表明，20 小時的專注練習足以建立一項新技能的基礎 —— Josh Kaufman';

  @override
  String achievementCelebrationCoins(int count) {
    return '+$count 金幣';
  }

  @override
  String achievementCelebrationTitle(String title) {
    return '獲得稱號：$title';
  }

  @override
  String get achievementCelebrationDismiss => '太棒了！';

  @override
  String get achievementCelebrationSkipAll => '跳過全部';

  @override
  String achievementCelebrationCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String achievementUnlockedAt(String date) {
    return '解鎖於 $date';
  }

  @override
  String get achievementLocked => '尚未解鎖';

  @override
  String achievementRewardCoins(int count) {
    return '+$count 金幣';
  }

  @override
  String get reminderModeDaily => '每天';

  @override
  String get reminderModeWeekdays => '工作日';

  @override
  String get reminderModeMonday => '週一';

  @override
  String get reminderModeTuesday => '週二';

  @override
  String get reminderModeWednesday => '週三';

  @override
  String get reminderModeThursday => '週四';

  @override
  String get reminderModeFriday => '週五';

  @override
  String get reminderModeSaturday => '週六';

  @override
  String get reminderModeSunday => '週日';

  @override
  String get reminderPickerTitle => '選擇提醒時間';

  @override
  String get reminderHourUnit => '點';

  @override
  String get reminderMinuteUnit => '分';

  @override
  String get reminderAddMore => '添加提醒';

  @override
  String get reminderMaxReached => '最多 5 個提醒';

  @override
  String get reminderConfirm => '確認';

  @override
  String reminderNotificationTitle(String catName) {
    return '$catName想你了！';
  }

  @override
  String reminderNotificationBody(String habitName) {
    return '$habitName的時間到了，你的貓咪在等你！';
  }

  @override
  String get deleteAccountDataWarning => '以下所有資料將被永久刪除：';

  @override
  String get deleteAccountQuests => '任務';

  @override
  String get deleteAccountCats => '貓咪';

  @override
  String get deleteAccountHours => '專注時長';

  @override
  String get deleteAccountIrreversible => '此操作不可撤銷';

  @override
  String get deleteAccountContinue => '繼續';

  @override
  String get deleteAccountConfirmTitle => '確認刪除';

  @override
  String get deleteAccountTypeDelete => '輸入 DELETE 以確認刪除帳號：';

  @override
  String get deleteAccountAuthCancelled => '認證已取消';

  @override
  String deleteAccountAuthFailed(String error) {
    return '認證失敗：$error';
  }

  @override
  String get deleteAccountProgress => '正在刪除帳號...';

  @override
  String get deleteAccountSuccess => '帳號已刪除';

  @override
  String get drawerGuestLoginSubtitle => '同步資料，解鎖 AI 功能';

  @override
  String get drawerGuestSignIn => '登入';

  @override
  String get drawerMilestones => '里程碑';

  @override
  String drawerMilestoneFocus(int hours, int minutes) {
    return '累計專注：${hours}h ${minutes}m';
  }

  @override
  String drawerMilestoneCats(int count) {
    return '貓咪家族：$count 隻';
  }

  @override
  String drawerMilestoneQuests(int count) {
    return '進行中任務：$count 個';
  }

  @override
  String get drawerMySection => '我的';

  @override
  String get drawerSessionHistory => '專注歷史';

  @override
  String get drawerCheckInCalendar => '簽到日曆';

  @override
  String get drawerAccountSection => '帳號';

  @override
  String get settingsResetData => '清除所有資料';

  @override
  String get settingsResetDataTitle => '清除所有資料？';

  @override
  String get settingsResetDataMessage => '此操作將刪除所有本地資料並返回歡迎頁面，且無法撤銷。';

  @override
  String get guestUpgradeTitle => '保護你的資料';

  @override
  String get guestUpgradeMessage => '關聯帳號可備份進度、解鎖 AI 日記和聊天功能，並在多裝置間同步。';

  @override
  String get guestUpgradeLinkButton => '關聯帳號';

  @override
  String get guestUpgradeLater => '以後再說';

  @override
  String get loginLinkTagline => '關聯帳號以保護你的資料';

  @override
  String get aiTeaserTitle => '貓貓日記';

  @override
  String aiTeaserPreview(String catName) {
    return '今天和主人一起學習了…$catName覺得自己又變聰明了喵~';
  }

  @override
  String aiTeaserCta(String catName) {
    return '關聯帳號，看看$catName想說什麼';
  }

  @override
  String get authErrorEmailInUse => '該電郵已被註冊';

  @override
  String get authErrorWrongPassword => '電郵或密碼不正確';

  @override
  String get authErrorUserNotFound => '未找到該電郵對應的帳號';

  @override
  String get authErrorTooManyRequests => '嘗試次數過多，請稍後再試';

  @override
  String get authErrorNetwork => '網路異常，請檢查連線';

  @override
  String get authErrorAdminRestricted => '登入暫時受限';

  @override
  String get authErrorWeakPassword => '密碼強度不足，至少需要 6 個字元';

  @override
  String get authErrorGeneric => '出了點問題，請重試';

  @override
  String get deleteAccountReauthEmail => '輸入密碼以繼續';

  @override
  String get deleteAccountReauthPasswordHint => '密碼';

  @override
  String get deleteAccountError => '出了點問題，稍後再試';

  @override
  String get deleteAccountPermissionError => '權限錯誤，嘗試重新登入';

  @override
  String get deleteAccountNetworkError => '無網絡連接，檢查網絡後再試';

  @override
  String get deleteAccountRetainedData => '使用統計和當機報告無法刪除';

  @override
  String get deleteAccountStepCloud => '正在刪除雲端資料...';

  @override
  String get deleteAccountStepLocal => '正在清理本機資料...';

  @override
  String get deleteAccountStepDone => '已完成';

  @override
  String get deleteAccountQueued => '本機資料已刪除。雲端帳號刪除已排隊，恢復連線後會自動完成。';

  @override
  String get deleteAccountPending => '帳號刪除任務處理中，請保持網路連線以完成雲端與認證刪除。';

  @override
  String get deleteAccountAbandon => '重新開始';

  @override
  String get archiveConflictTitle => '選擇保留存檔';

  @override
  String get archiveConflictMessage => '偵測到本機與雲端都有存檔資料，請選擇保留其中一個：';

  @override
  String get archiveConflictLocal => '本機存檔';

  @override
  String get archiveConflictCloud => '雲端存檔';

  @override
  String get archiveConflictKeepCloud => '保留雲端';

  @override
  String get archiveConflictKeepLocal => '保留本機';

  @override
  String get loginShowPassword => '顯示密碼';

  @override
  String get loginHidePassword => '隱藏密碼';

  @override
  String get errorGeneric => '出了點問題，稍後再試';

  @override
  String get errorCreateHabit => '建立習慣失敗，請重試';

  @override
  String get loginForgotPassword => '忘記密碼？';

  @override
  String get loginForgotPasswordTitle => '重置密碼';

  @override
  String get loginSendResetEmail => '發送重置郵件';

  @override
  String get loginResetEmailSent => '密碼重置郵件已發送，請查收';

  @override
  String get authErrorUserDisabled => '此帳號已被停用';

  @override
  String get authErrorInvalidEmail => '請輸入有效的電子郵件地址';

  @override
  String get authErrorRequiresRecentLogin => '請重新登錄後繼續';

  @override
  String get commonCopyId => '複製 ID';

  @override
  String get adoptionClearDeadline => '清除截止日期';

  @override
  String get commonIdCopied => 'ID 已複製';

  @override
  String get pickerDurationLabel => '時長選擇器';

  @override
  String pickerMinutesValue(int count) {
    return '$count 分鐘';
  }

  @override
  String a11yCatImage(String name) {
    return '貓咪 $name';
  }

  @override
  String a11yCatTapToInteract(String name) {
    return '$name，點擊互動';
  }

  @override
  String a11yProgressPercent(int percent) {
    return '已完成 $percent%';
  }

  @override
  String a11yStreakActiveDays(int count) {
    return '$count 個活躍日';
  }

  @override
  String get a11yOfflineStatus => '離線模式';

  @override
  String a11yAchievementUnlocked(String name) {
    return '成就解鎖：$name';
  }

  @override
  String get calendarCheckedIn => '已簽到';

  @override
  String get calendarToday => '今天';

  @override
  String a11yEquipToCat(Object name) {
    return '裝備給$name';
  }

  @override
  String a11yRegenerateCat(Object name) {
    return '重新生成$name';
  }

  @override
  String a11yTimerDisplay(Object time) {
    return '計時器：$time';
  }

  @override
  String a11yOnboardingPage(Object current, Object total) {
    return '第 $current 頁，共 $total 頁';
  }

  @override
  String a11yEditDisplayName(Object name) {
    return '編輯顯示名：$name';
  }

  @override
  String get routeNotFound => '頁面未找到';

  @override
  String get routeGoHome => '返回首頁';

  @override
  String get a11yError => '錯誤';

  @override
  String get a11yDeadline => '截止日期';

  @override
  String get a11yReminder => '提醒';

  @override
  String get a11yFocusMeditation => '專注冥想';

  @override
  String get a11yUnlocked => '已解鎖';

  @override
  String get a11ySelected => '已選中';

  @override
  String get a11yDynamicWallpaperColor => '動態桌布顏色';

  @override
  String get awarenessTitle => 'Awareness';

  @override
  String get awarenessTabToday => 'Today';

  @override
  String get awarenessTabThisWeek => 'This Week';

  @override
  String get awarenessTabReview => 'Review';

  @override
  String get moodVeryHappy => 'Very Happy';

  @override
  String get moodCalm => 'Calm';

  @override
  String get moodDown => 'Down';

  @override
  String get moodVeryDown => 'Very Down';

  @override
  String get awarenessLightPlaceholder => 'What made you smile today?';

  @override
  String get awarenessLightSaved => 'Light recorded ✨';

  @override
  String get awarenessLightEdit => 'Edit';

  @override
  String get weeklyReviewTitle => 'Weekly Review';

  @override
  String weeklyReviewHappyMoment(int number) {
    return 'Happy Moment #$number';
  }

  @override
  String get weeklyReviewHappyMomentHint => 'What made you happy this week?';

  @override
  String get weeklyReviewGratitude => 'Gratitude';

  @override
  String get weeklyReviewGratitudeHint => 'Who or what are you grateful for?';

  @override
  String get weeklyReviewLearning => 'Learning';

  @override
  String get weeklyReviewLearningHint => 'What did you learn this week?';

  @override
  String get weeklyReviewSave => 'Save Review';

  @override
  String get weeklyReviewSaved => 'Review saved ✨';

  @override
  String get worryProcessorTitle => 'Worry Processor';

  @override
  String get worryDescriptionHint => 'What\'s bothering you?';

  @override
  String get worrySolutionHint => 'What could you do about it?';

  @override
  String get worryStatusOngoing => 'Ongoing';

  @override
  String get worryStatusResolved => 'Resolved';

  @override
  String get worryStatusDisappeared => 'Gone';

  @override
  String get worryAdd => 'Add Worry';

  @override
  String get worrySave => 'Save';

  @override
  String get worryResolvedSection => 'Resolved & Gone';

  @override
  String get worryManageAll => 'Manage all worries';

  @override
  String get awarenessEmptyLightTitle => 'No light recorded yet';

  @override
  String get awarenessEmptyLightSubtitle => 'Whenever you\'re ready ✨';

  @override
  String get awarenessEmptyLightAction => 'Record';

  @override
  String get awarenessEmptyReviewTitle => 'Take your time';

  @override
  String get awarenessEmptyReviewSubtitle => 'Review when you feel like it 🐱';

  @override
  String get awarenessEmptyReviewAction => 'Start Review';

  @override
  String get awarenessEmptyHistoryTitle => 'Every light matters';

  @override
  String get awarenessEmptyHistorySubtitle => 'Your history will appear here';

  @override
  String get awarenessEmptyWorriesTitle => 'No worries? Great! 🎉';

  @override
  String get awarenessEmptyWorriesSubtitle => 'That\'s wonderful';

  @override
  String get catReactVeryHappy => 'So happy today! Meow~ 🎉';

  @override
  String get catReactHappy => 'Another light recorded ✨';

  @override
  String get catReactCalm => 'A calm day is a good day 🍃';

  @override
  String get catReactDown => 'I\'m here with you 💛';

  @override
  String get catReactVeryDown => 'Not going anywhere 🫂';

  @override
  String get awarenessBridgePrompt => 'What made you smile today? ✨';

  @override
  String get awarenessBridgeRecord => 'Record';

  @override
  String get awarenessBridgeSkip => 'Skip';

  @override
  String get awarenessHabitsSection => 'Today\'s Habits';

  @override
  String get awarenessHabitsEmpty => 'No habits yet. Adopt a cat to start!';

  @override
  String get awarenessReviewComingSoon => 'Coming soon';

  @override
  String get awarenessMoodRequired => 'Please select today\'s mood';

  @override
  String get awarenessSaveFailed => 'Save failed, please try again';

  @override
  String get awarenessLoadFailed => 'Failed to load, please go back and retry';

  @override
  String get awarenessSaved => 'Saved';

  @override
  String get worryDescriptionRequired => 'Please describe your worry';

  @override
  String get worryLoadFailed => 'Failed to load worry';

  @override
  String get awarenessLoginRequired => 'Please log in first';

  @override
  String get tagCustom => '+Custom';

  @override
  String get homeTabAwareness => 'Awareness';

  @override
  String get homeTabHabits => 'Habits';

  @override
  String get monthlyRitualSetupTitle =>
      'A new month — pick a habit to focus on';

  @override
  String get monthlyRitualSetupDesc =>
      'Choose your focus habit, set a flexible goal, and promise yourself a reward.';

  @override
  String get monthlyRitualSetupButton => 'Set up';

  @override
  String get monthlyRitualDialogTitle => 'Monthly ritual';

  @override
  String get monthlyRitualHabitLabel => 'Focus habit';

  @override
  String get monthlyRitualTargetLabel => 'Target days';

  @override
  String monthlyRitualTargetValue(int count) {
    return '$count days';
  }

  @override
  String get monthlyRitualRewardHint => 'Reward myself with...';

  @override
  String get monthlyRitualRewardLabel => 'Reward';

  @override
  String monthlyRitualProgress(int completed, int target) {
    return '$completed/$target days done ✨';
  }

  @override
  String get monthlyRitualAchieved => 'Goal achieved! 🎉';

  @override
  String get monthlyRitualEncouragement => 'Every day counts';

  @override
  String get achievementLightFirstName => 'First Light';

  @override
  String get achievementLightFirstDesc => 'Record your first daily light';

  @override
  String get achievementLight7Name => 'Week of Light';

  @override
  String get achievementLight7Desc =>
      'Record daily light for 7 days (cumulative)';

  @override
  String get achievementLight30Name => 'Month of Light';

  @override
  String get achievementLight30Desc =>
      'Record daily light for 30 days (cumulative)';

  @override
  String get achievementLight100Name => 'Century of Light';

  @override
  String get achievementLight100Desc =>
      'Record daily light for 100 days (cumulative)';

  @override
  String get achievementReviewFirstName => 'First Review';

  @override
  String get achievementReviewFirstDesc => 'Complete your first weekly review';

  @override
  String get achievementReview4Name => 'Monthly Reviewer';

  @override
  String get achievementReview4Desc => 'Complete 4 weekly reviews (cumulative)';

  @override
  String get achievementWorryResolved1Name => 'First Release';

  @override
  String get achievementWorryResolved1Desc =>
      'Resolve or release your first worry';

  @override
  String get achievementWorryResolved10Name => 'Worry Whisperer';

  @override
  String get achievementWorryResolved10Desc =>
      'Resolve or release 10 worries (cumulative)';

  @override
  String get notifBedtimeLight =>
      'How was your day? Take a moment to notice something good ✨';

  @override
  String get notifWeeklyReview =>
      'Sunday evening — a good time to look back at your week 📖';

  @override
  String get notifMonthlyRitual =>
      'A new month begins! Pick a habit to focus on this month 🌙';

  @override
  String get notifGentleReengagement =>
      'No pressure — come back whenever you\'re ready 🌿';

  @override
  String get calendarMon => 'Mon';

  @override
  String get calendarTue => 'Tue';

  @override
  String get calendarWed => 'Wed';

  @override
  String get calendarThu => 'Thu';

  @override
  String get calendarFri => 'Fri';

  @override
  String get calendarSat => 'Sat';

  @override
  String get calendarSun => 'Sun';

  @override
  String get historyWeeklyReviews => 'Weekly Reviews';

  @override
  String historyHappyMoments(int count) {
    return '$count happy moments';
  }

  @override
  String historyWeekRange(String startDate, String endDate) {
    return '$startDate - $endDate';
  }

  @override
  String get dailyDetailTitle => 'Daily Detail';

  @override
  String get dailyDetailEdit => 'Edit Record';

  @override
  String get dailyDetailLight => 'Today\'s Light';

  @override
  String get dailyDetailTimeline => 'Today\'s Timeline';

  @override
  String get dailyDetailNoRecord => 'No record for this day';

  @override
  String get dailyDetailGoRecord => 'Go Record';

  @override
  String get awarenessStatsTitle => 'Awareness Stats';

  @override
  String get awarenessStatsMoodDistribution => 'Mood Distribution';

  @override
  String get awarenessStatsLightDays => 'Light Days';

  @override
  String get awarenessStatsWeeklyReviews => 'Reviews';

  @override
  String get awarenessStatsResolutionRate => 'Resolution Rate';

  @override
  String get awarenessStatsTopTags => 'Top Tags';

  @override
  String get awarenessStatsMonthlyChallenge => 'Monthly Challenge';

  @override
  String get awarenessStatsStartRecording => 'Start recording your first light';

  @override
  String get timelineEventHint => 'What happened?';

  @override
  String get tabToday => 'Today';

  @override
  String get tabJourney => 'Journey';

  @override
  String get tabProfile => 'Me';

  @override
  String get onboardingWelcome => 'Hello';

  @override
  String get onboardingLumiIntro => 'This is LUMI';

  @override
  String get onboardingSlogan =>
      'Every line you write adds a star to your inner universe';

  @override
  String get onboardingNamePrompt => 'The owner of this journal is';

  @override
  String get onboardingNameHint => 'Your name';

  @override
  String get onboardingBirthdayPrompt => 'Your birthday';

  @override
  String get onboardingBirthdayMonth => 'Month';

  @override
  String get onboardingBirthdayDay => 'Day';

  @override
  String get onboardingStartDatePrompt =>
      'When would you like to start this journey?';

  @override
  String get onboardingThreeThings => 'LUMI has just three little things';

  @override
  String get onboardingDailyLight => 'Write one line before bed';

  @override
  String get onboardingDailyLightSub => 'Today\'s little light';

  @override
  String get onboardingWeeklyReview => 'Weekend review';

  @override
  String get onboardingWeeklyReviewSub => 'Three happy moments';

  @override
  String get onboardingWorryJar => 'Write down worries';

  @override
  String get onboardingWorryJarSub => 'Put them in the worry jar';

  @override
  String get onboardingStart => 'Start the journey';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingNext => 'Next';

  @override
  String todayGreeting(String name) {
    return 'Good morning, $name';
  }

  @override
  String get quickLightPlaceholder => 'What made you smile today?';

  @override
  String get recordLight => 'Record';

  @override
  String get noHabitsYet => 'No habits yet. You can set them in monthly plans.';

  @override
  String get segmentWeek => 'This Week';

  @override
  String get segmentMonth => 'This Month';

  @override
  String get segmentYear => 'Year';

  @override
  String get segmentExplore => 'Explore';

  @override
  String get featureLockedTitle => 'Coming Soon';

  @override
  String featureLockedMessage(int days) {
    return 'Record $days more days to unlock. No rush.';
  }

  @override
  String get weeklyPlanTitle => 'Weekly Plan';

  @override
  String get oneLineForSelf => 'Write a line for yourself this week';

  @override
  String get urgentImportant => 'Must Do';

  @override
  String get importantNotUrgent => 'Should Do';

  @override
  String get urgentNotImportant => 'Need to Do';

  @override
  String get wantToDo => 'Want to Do';

  @override
  String get monthlyGoals => 'Monthly Goals';

  @override
  String get smallWinChallenge => 'Small Win Challenge';

  @override
  String get monthlyPassion => 'Monthly Passion';

  @override
  String get moodTracker => 'Mood Tracker';

  @override
  String get monthlyMemory => 'Monthly Memory';

  @override
  String get monthlyAchievement => 'Monthly Achievement';

  @override
  String get yearlyMessages => 'Yearly Messages';

  @override
  String get growthPlan => 'Growth Plan';

  @override
  String get annualCalendar => 'Annual Calendar';

  @override
  String get lumiStats => 'My Stars';

  @override
  String totalStars(int count) {
    return '$count stars';
  }

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get longestStreak => 'Longest Streak';

  @override
  String get catCompanion => 'Cat Companion';

  @override
  String get growthReview => 'Growth Review';

  @override
  String greetingLateNight(String name) {
    return '夜深了，$name';
  }

  @override
  String greetingMorning(String name) {
    return '早安，$name';
  }

  @override
  String greetingAfternoon(String name) {
    return '午安，$name';
  }

  @override
  String greetingEvening(String name) {
    return '晚安，$name';
  }

  @override
  String get greetingLateNightNoName => '夜深了';

  @override
  String get greetingMorningNoName => '早安';

  @override
  String get greetingAfternoonNoName => '午安';

  @override
  String get greetingEveningNoName => '晚安';

  @override
  String get journeyTitle => '旅程';

  @override
  String get journeySegmentWeek => '本週';

  @override
  String get journeySegmentMonth => '本月';

  @override
  String get journeySegmentYear => '年度';

  @override
  String get journeySegmentExplore => '探索';

  @override
  String get journeyMonthlyView => '月度檢視';

  @override
  String get journeyYearlyView => '年度檢視';

  @override
  String get journeyExploreActivities => '探索活動';

  @override
  String get journeyEditMonthlyPlan => '編輯月計畫';

  @override
  String get journeyEditYearlyPlan => '編輯年度計畫';

  @override
  String get quickLightTitle => '今天的一點光';

  @override
  String get quickLightHint => '寫下今天的心情...';

  @override
  String get quickLightRecord => '記錄';

  @override
  String get quickLightSaveSuccess => '記錄成功';

  @override
  String get quickLightSaveError => '儲存失敗，請重試';

  @override
  String get habitSnapshotTitle => '今日習慣';

  @override
  String get habitSnapshotEmpty => '還沒有習慣，可以在旅程裡設定';

  @override
  String get habitSnapshotLoadError => '載入失敗';

  @override
  String get worryJarTitle => '煩惱罐';

  @override
  String get worryJarLoadError => '載入失敗';

  @override
  String get weeklyReviewEmpty => '記錄本週的幸福時刻';

  @override
  String get weeklyReviewHappyMoments => '幸福時刻';

  @override
  String get weeklyReviewLoadError => '載入失敗';

  @override
  String get weeklyPlanCardTitle => '本週計畫';

  @override
  String weeklyPlanItemCount(int count) {
    return '$count 項';
  }

  @override
  String get weeklyPlanEmpty => '制定本週計畫';

  @override
  String get weekMoodTitle => '本週心情';

  @override
  String get weekMoodLoadError => '心情載入失敗';

  @override
  String featureLockedDaysRemaining(int remaining) {
    return '再記錄 $remaining 天後解鎖';
  }

  @override
  String get featureLockedSoon => '即將解鎖';

  @override
  String get weeklyPlanScreenTitle => '本週計畫';

  @override
  String get weeklyPlanSave => '儲存';

  @override
  String get weeklyPlanSaveSuccess => '已儲存';

  @override
  String get weeklyPlanSaveError => '儲存失敗';

  @override
  String get weeklyPlanOneLine => '寫一句話給這週的自己';

  @override
  String get weeklyPlanOneLineHint => '這週我想...';

  @override
  String get weeklyPlanUrgentImportant => '緊急且重要';

  @override
  String get weeklyPlanImportantNotUrgent => '重要不緊急';

  @override
  String get weeklyPlanUrgentNotImportant => '緊急不重要';

  @override
  String get weeklyPlanNotUrgentNotImportant => '不緊急不重要';

  @override
  String get weeklyPlanAddHint => '新增...';

  @override
  String get weeklyPlanMustDo => '必須做';

  @override
  String get weeklyPlanShouldDo => '要做';

  @override
  String get weeklyPlanNeedToDo => '該做';

  @override
  String get weeklyPlanWantToDo => '想做';

  @override
  String monthlyCalendarYearMonth(int year, int month) {
    return '$year 年 $month 月';
  }

  @override
  String get monthlyCalendarLoadError => '載入失敗';

  @override
  String get monthlyGoalsTitle => '本月目標';

  @override
  String monthlyGoalHint(int index) {
    return '目標 $index';
  }

  @override
  String get monthlySaveError => '儲存失敗';

  @override
  String get monthlyMemoryTitle => '本月回憶';

  @override
  String get monthlyMemoryHint => '這個月最美好的回憶是...';

  @override
  String get monthlyAchievementTitle => '本月成就';

  @override
  String get monthlyAchievementHint => '這個月最驕傲的成就是...';

  @override
  String get yearlyMessagesTitle => '年度寄語';

  @override
  String get yearlyMessageBecome => '這一年我希望自己成為......';

  @override
  String get yearlyMessageGoals => '達成目標';

  @override
  String get yearlyMessageBreakthrough => '突破性完成';

  @override
  String get yearlyMessageDontDo => '不做（說不，也是在為重要的事騰位置）';

  @override
  String get yearlyMessageKeyword => '年度關鍵詞（例：專注/勇敢/耐心/溫柔）';

  @override
  String get yearlyMessageFutureSelf => '給親愛的未來的我';

  @override
  String get yearlyMessageMotto => '我的座右銘';

  @override
  String get growthPlanTitle => '年度成長計畫';

  @override
  String get growthPlanHint => '我的計畫...';

  @override
  String get growthPlanSaveError => '儲存失敗';

  @override
  String get growthDimensionHealth => '身體健康';

  @override
  String get growthDimensionEmotion => '情緒管理';

  @override
  String get growthDimensionRelationship => '人際關係';

  @override
  String get growthDimensionCareer => '職涯發展';

  @override
  String get growthDimensionFinance => '財務管理';

  @override
  String get growthDimensionLearning => '持續學習';

  @override
  String get growthDimensionCreativity => '創造力';

  @override
  String get growthDimensionSpirituality => '內在成長';

  @override
  String get smallWinTitle => '小贏挑戰';

  @override
  String smallWinEmpty(int days) {
    return '設定一個 $days 天的小挑戰，每天堅持一點點';
  }

  @override
  String smallWinReward(String reward) {
    return '獎勵：$reward';
  }

  @override
  String get smallWinLoadError => '載入失敗';

  @override
  String get smallWinLawVisible => '看得見';

  @override
  String get smallWinLawAttractive => '想去做';

  @override
  String get smallWinLawEasy => '易上手';

  @override
  String get smallWinLawRewarding => '有獎勵';

  @override
  String get moodTrackerTitle => '心情追蹤';

  @override
  String get moodTrackerLoadError => '載入失敗';

  @override
  String moodTrackerCount(int count) {
    return '$count 次';
  }

  @override
  String get habitTrackerTitle => '本月熱愛與堅持';

  @override
  String get habitTrackerComingSoon => '習慣追蹤功能開發中';

  @override
  String get habitTrackerComingSoonHint => '在小贏挑戰中設定你的習慣';

  @override
  String get listsTitle => '我的清單';

  @override
  String get listBookTitle => '書單';

  @override
  String get listMovieTitle => '影單';

  @override
  String get listCustomTitle => '自訂清單';

  @override
  String listItemCount(int count) {
    return '$count 條';
  }

  @override
  String get listDetailBookTitle => '我的書單';

  @override
  String get listDetailMovieTitle => '我的影單';

  @override
  String get listDetailCustomTitle => '我的清單';

  @override
  String get listDetailSave => '儲存';

  @override
  String get listDetailSaveSuccess => '已儲存';

  @override
  String get listDetailSaveError => '儲存失敗';

  @override
  String get listDetailCustomNameLabel => '清單名稱';

  @override
  String get listDetailCustomNameHint => '例：我的 Podcast 清單';

  @override
  String get listDetailItemTitleHint => '標題';

  @override
  String get listDetailItemDateHint => '日期';

  @override
  String get listDetailItemGenreHint => '類型/標籤';

  @override
  String get listDetailItemKeywordHint => '關鍵詞/感受';

  @override
  String get listDetailYearTreasure => '年度寶藏';

  @override
  String get listDetailYearPick => '年度之選';

  @override
  String get listDetailYearPickHint => '這一年最值得推薦的一部';

  @override
  String get listDetailInsight => '靈感一擊';

  @override
  String get listDetailInsightHint => '閱讀/觀影帶給你的最大啟發';

  @override
  String get exploreMyMoments => '我的時刻';

  @override
  String get exploreMyMomentsDesc => '記錄幸福與高光時刻';

  @override
  String get exploreHabitPact => '我與習慣的約定';

  @override
  String get exploreHabitPactDesc => '用原子習慣四定律設計新習慣';

  @override
  String get exploreWorryUnload => '煩惱減負日';

  @override
  String get exploreWorryUnloadDesc => '為煩惱分類：放下、行動或接受';

  @override
  String get exploreSelfPraise => '我的誇誇群';

  @override
  String get exploreSelfPraiseDesc => '寫下自己的 5 個優點';

  @override
  String get exploreSupportMap => '我身邊的人';

  @override
  String get exploreSupportMapDesc => '記錄支持你的人';

  @override
  String get exploreFutureSelf => '未來照見我';

  @override
  String get exploreFutureSelfDesc => '想像 3 種未來的自己';

  @override
  String get exploreIdealVsReal => '理想的我 vs. 現在的我';

  @override
  String get exploreIdealVsRealDesc => '發現理想與現實的交集';

  @override
  String get highlightScreenTitle => '我的時刻';

  @override
  String get highlightTabHappy => '幸福時刻';

  @override
  String get highlightTabHighlight => '高光時刻';

  @override
  String get highlightEmptyHappy => '還沒有記錄幸福時刻';

  @override
  String get highlightEmptyHighlight => '還沒有記錄高光時刻';

  @override
  String highlightLoadError(String error) {
    return '載入失敗: $error';
  }

  @override
  String get monthlyPlanScreenTitle => '月計畫';

  @override
  String get monthlyPlanSave => '儲存';

  @override
  String get monthlyPlanSaveSuccess => '已儲存';

  @override
  String get monthlyPlanSaveError => '儲存失敗';

  @override
  String get monthlyPlanGoalsSection => '月目標';

  @override
  String get monthlyPlanChallengeSection => '小贏挑戰';

  @override
  String get monthlyPlanChallengeNameLabel => '挑戰習慣名稱';

  @override
  String get monthlyPlanChallengeNameHint => '例：每天跑步 10 分鐘';

  @override
  String get monthlyPlanRewardLabel => '完成後的獎勵';

  @override
  String get monthlyPlanRewardHint => '例：買一本想看的書';

  @override
  String get monthlyPlanSelfCareSection => '愛自己活動';

  @override
  String monthlyPlanActivityHint(int index) {
    return '活動 $index';
  }

  @override
  String get monthlyPlanMemorySection => '本月回憶';

  @override
  String get monthlyPlanMemoryHint => '這個月最美好的回憶是...';

  @override
  String get monthlyPlanAchievementSection => '本月成就';

  @override
  String get monthlyPlanAchievementHint => '這個月最驕傲的成就是...';

  @override
  String yearlyPlanScreenTitle(int year) {
    return '$year 年度計畫';
  }

  @override
  String get yearlyPlanSave => '儲存';

  @override
  String get yearlyPlanSaveSuccess => '已儲存';

  @override
  String get yearlyPlanSaveError => '儲存失敗';

  @override
  String get yearlyPlanMessagesSection => '年度寄語';

  @override
  String get yearlyPlanGrowthSection => '成長計畫';

  @override
  String get growthReviewScreenTitle => '成長回望';

  @override
  String get growthReviewMyMoments => '屬於我的時刻';

  @override
  String get growthReviewEmptyMoments => '還沒有記錄高光時刻';

  @override
  String get growthReviewMySummary => '我的總結';

  @override
  String get growthReviewSummaryPrompt => '回顧這段旅程，你有什麼想對自己說的？';

  @override
  String get growthReviewSmallWins => '小贏頒獎';

  @override
  String get growthReviewConsistentRecord => '堅持記錄';

  @override
  String growthReviewRecordedDays(int count) {
    return '你已經記錄了 $count 天';
  }

  @override
  String get growthReviewWeeklyChamp => '週回顧達人';

  @override
  String growthReviewCompletedReviews(int count) {
    return '完成了 $count 次週回顧';
  }

  @override
  String get growthReviewWarmClose => '溫暖的收官';

  @override
  String get growthReviewEveryStar => '每一天的記錄都是一顆星星';

  @override
  String growthReviewKeepShining(int count) {
    return '你已經收集了 $count 顆星星，繼續閃耀吧！';
  }

  @override
  String get futureSelfScreenTitle => '未來照見我';

  @override
  String get futureSelfSubtitle => '想像 3 種未來的自己';

  @override
  String get futureSelfHint => '不需要完美答案，讓想像自由流動';

  @override
  String get futureSelfStable => '穩定的未來';

  @override
  String get futureSelfStableHint => '如果一切順利，穩定發展，你的生活會是什麼樣？';

  @override
  String get futureSelfFree => '自由的未來';

  @override
  String get futureSelfFreeHint => '如果沒有任何限制，你最想做什麼？';

  @override
  String get futureSelfPace => '按自己節奏發展的未來';

  @override
  String get futureSelfPaceHint => '不急不緩，你理想中的節奏是什麼樣的？';

  @override
  String get futureSelfCoreLabel => '你真正在意的是什麼？';

  @override
  String get futureSelfCoreHint => '看看上面的 3 個版本，它們有什麼共同點？那可能就是你內心最在意的...';

  @override
  String get habitPactScreenTitle => '我與習慣的約定';

  @override
  String get habitPactStep1 => '我想養成什麼習慣？';

  @override
  String get habitPactCategoryLearning => '學習';

  @override
  String get habitPactCategoryHealth => '健康';

  @override
  String get habitPactCategoryRelationship => '關係';

  @override
  String get habitPactCategoryHobby => '興趣';

  @override
  String get habitPactHabitLabel => '具體習慣';

  @override
  String get habitPactHabitHint => '例：每天讀 20 頁書';

  @override
  String get habitPactStep2 => '習慣四定律設計';

  @override
  String get habitPactLawVisible => '看得見';

  @override
  String get habitPactLawVisibleHint => '我會把提示放在...';

  @override
  String get habitPactLawAttractive => '想去做';

  @override
  String get habitPactLawAttractiveHint => '我會把它和...連在一起';

  @override
  String get habitPactLawEasy => '易上手';

  @override
  String get habitPactLawEasyHint => '我設計的最小版本是...';

  @override
  String get habitPactLawRewarding => '有獎勵';

  @override
  String get habitPactLawRewardingHint => '完成後我會獎勵自己...';

  @override
  String get habitPactStep3 => '行動宣言';

  @override
  String get habitPactDeclarationEmpty => '填寫上方內容，自動產生宣言...';

  @override
  String habitPactDeclarationPrefix(String habit) {
    return '我決定養成「$habit」的習慣';
  }

  @override
  String habitPactDeclarationWhen(String cue) {
    return '當$cue時';
  }

  @override
  String habitPactDeclarationWill(String response) {
    return '我會$response';
  }

  @override
  String habitPactDeclarationThen(String reward) {
    return '然後$reward';
  }

  @override
  String get idealVsRealScreenTitle => '理想的我 vs. 現在的我';

  @override
  String get idealVsRealIdeal => '理想的我';

  @override
  String get idealVsRealIdealHint => '我希望自己是什麼樣的人？';

  @override
  String get idealVsRealReal => '現在的我';

  @override
  String get idealVsRealRealHint => '我現在是什麼樣的人？';

  @override
  String get idealVsRealSame => '有哪些相同點？';

  @override
  String get idealVsRealSameHint => '理想和現實之間，已經有哪些重合的地方？';

  @override
  String get idealVsRealDiff => '有哪些不同？';

  @override
  String get idealVsRealDiffHint => '差距在哪裡？這些差距讓你有什麼感受？';

  @override
  String get idealVsRealStep => '靠近理想，我只需要邁出一小步';

  @override
  String get idealVsRealStepHint => '今天就可以做的一件小事是...';

  @override
  String get selfPraiseScreenTitle => '我的誇誇群';

  @override
  String get selfPraiseSubtitle => '寫下你的 5 個優點';

  @override
  String get selfPraiseHint => '每個人都值得被看見，尤其是自己';

  @override
  String selfPraiseStrengthLabel(int index) {
    return '優點 $index';
  }

  @override
  String get selfPraisePrompt1 => '我最溫暖的品質是...';

  @override
  String get selfPraisePrompt2 => '我擅長的一件事是...';

  @override
  String get selfPraisePrompt3 => '別人常誇我的是...';

  @override
  String get selfPraisePrompt4 => '我為自己驕傲的地方是...';

  @override
  String get selfPraisePrompt5 => '我的獨特之處是...';

  @override
  String get supportMapScreenTitle => '我身邊的人';

  @override
  String get supportMapSubtitle => '誰在支持你？';

  @override
  String get supportMapHint => '記錄身邊重要的人，提醒自己並不孤單';

  @override
  String get supportMapNameLabel => '姓名';

  @override
  String get supportMapRelationLabel => '關係';

  @override
  String get supportMapRelationHint => '例：朋友/家人/同事';

  @override
  String get supportMapAdd => '新增';

  @override
  String get worryUnloadScreenTitle => '煩惱減負日';

  @override
  String worryUnloadLoadError(String error) {
    return '載入失敗: $error';
  }

  @override
  String get worryUnloadEmptyTitle => '沒有進行中的煩惱';

  @override
  String get worryUnloadEmptyHint => '太棒了！今天是輕鬆的一天';

  @override
  String get worryUnloadIntro => '看看你的煩惱，為它們分個類吧';

  @override
  String get worryUnloadLetGo => '可以放下';

  @override
  String get worryUnloadTakeAction => '可以行動';

  @override
  String get worryUnloadAccept => '暫時接受';

  @override
  String get worryUnloadResultTitle => '減負結果';

  @override
  String worryUnloadSummary(String label, int count) {
    return '$label：$count 個';
  }

  @override
  String get worryUnloadEncouragement => '每一個分類都是前進的一步。';

  @override
  String get commonSaved => '已儲存';

  @override
  String get commonSaveError => '儲存失敗';

  @override
  String get commonLoadError => '載入失敗';

  @override
  String get momentEditTitle => '編輯時刻';

  @override
  String get momentNewHappy => '記錄幸福時刻';

  @override
  String get momentNewHighlight => '記錄高光時刻';

  @override
  String get momentDescHappy => '幸福的事';

  @override
  String get momentDescHighlight => '發生了什麼';

  @override
  String get momentCompanionHappy => '和誰在一起';

  @override
  String get momentCompanionHighlight => '我做了什麼';

  @override
  String get momentFeeling => '感受';

  @override
  String get momentDate => '日期 (YYYY-MM-DD)';

  @override
  String get momentRating => '評分';

  @override
  String get momentDescRequired => '請填寫描述';

  @override
  String momentWithCompanion(String companion) {
    return '和$companion一起';
  }

  @override
  String momentDidAction(String action) {
    return '我做了：$action';
  }

  @override
  String get annualCalendarTitle => '我的年曆';

  @override
  String annualCalendarMonthLabel(int month) {
    return '$month 月';
  }
}
