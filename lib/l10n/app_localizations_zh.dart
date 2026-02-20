// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class SZh extends S {
  SZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Hachimi';

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
  String get settingsMaterialYou => 'Material You';

  @override
  String get settingsMaterialYouSubtitle => '使用壁纸颜色作为主题色';

  @override
  String get settingsThemeColor => '主题颜色';

  @override
  String get settingsAiModel => 'AI 模型';

  @override
  String get settingsAiFeatures => 'AI 功能';

  @override
  String get settingsAiSubtitle => '启用由设备端 AI 驱动的猫猫日记和聊天';

  @override
  String get settingsAbout => '关于';

  @override
  String get settingsVersion => '版本';

  @override
  String get settingsPixelCatSprites => '像素猫素材';

  @override
  String get settingsLicenses => '开源许可';

  @override
  String get settingsAccount => '账号';

  @override
  String get settingsDownloadModel => '下载模型（1.2 GB）';

  @override
  String get settingsDeleteModel => '删除模型';

  @override
  String get settingsDeleteModelTitle => '删除模型？';

  @override
  String get settingsDeleteModelMessage => '这将删除已下载的 AI 模型（1.2 GB）。你可以稍后重新下载。';

  @override
  String get logoutTitle => '退出登录？';

  @override
  String get logoutMessage => '确定要退出登录吗？';

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
  String get profileBestStreak => '最长连续';

  @override
  String get profileCatAlbum => '猫猫图鉴';

  @override
  String profileCatAlbumCount(int count) {
    return '$count 只猫';
  }

  @override
  String profileSeeAll(int count) {
    return '查看全部 $count 只猫';
  }

  @override
  String get profileGraduated => '已毕业';

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
  String get testChatTitle => '测试 AI 模型';

  @override
  String get testChatLoadingModel => '模型加载中...';

  @override
  String get testChatModelLoaded => '模型已加载';

  @override
  String get testChatErrorLoading => '模型加载失败';

  @override
  String get testChatCouldNotLoad => '无法加载模型';

  @override
  String get testChatFailedToLoad => '模型加载失败';

  @override
  String get testChatUnknownError => '未知错误';

  @override
  String get testChatModelReady => '模型就绪';

  @override
  String get testChatSendToTest => '发送消息来测试 AI 模型。';

  @override
  String get testChatGenerating => '生成中...';

  @override
  String get testChatTypeMessage => '输入消息...';

  @override
  String get settingsAiPrivacyBadge => '由设备端 AI 驱动 — 所有处理均在本地运行';

  @override
  String get settingsAiWhatYouGet => '你将获得：';

  @override
  String get settingsAiFeatureDiary => 'Hachimi 日记 — 猫猫每天为你写日记';

  @override
  String get settingsAiFeatureChat => '猫猫聊天 — 和你的猫猫对话';

  @override
  String get settingsRedownload => '重新下载';

  @override
  String get settingsTestModel => '测试模型';

  @override
  String get settingsStatusDownloading => '下载中';

  @override
  String get settingsStatusReady => '就绪';

  @override
  String get settingsStatusError => '错误';

  @override
  String get settingsStatusLoading => '加载中';

  @override
  String get settingsStatusNotDownloaded => '未下载';

  @override
  String get settingsStatusDisabled => '已停用';

  @override
  String get catDetailNotFound => '未找到猫猫';

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
  String get adoptionTotalTarget => '总目标小时数';

  @override
  String get adoptionGrowthHint => '你的猫会随着你积累专注时间而成长';

  @override
  String get adoptionCustom => '自定义';

  @override
  String get adoptionDailyGoalLabel => '每日专注目标';

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
  String get onboardTitle1 => '欢迎来到 Hachimi';

  @override
  String get onboardSubtitle1 => '养猫咪，完成任务';

  @override
  String get onboardBody1 => '每个任务都会搭配一只小猫。\n专注你的目标，看着它们\n从小猫成长为闪亮的大猫！';

  @override
  String get onboardTitle2 => '专注 & 赚取 XP';

  @override
  String get onboardSubtitle2 => '时间驱动成长';

  @override
  String get onboardBody2 => '开始专注，猫猫就能获得 XP。\n保持连续签到获取额外奖励。\n每一分钟都能促进进化！';

  @override
  String get onboardTitle3 => '见证它们进化';

  @override
  String get onboardSubtitle3 => '小猫 → 闪亮';

  @override
  String get onboardBody3 => '猫猫在成长过程中会经历 4 个阶段。\n收集不同品种，解锁稀有猫猫，\n填满你温馨的猫房！';

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
}
