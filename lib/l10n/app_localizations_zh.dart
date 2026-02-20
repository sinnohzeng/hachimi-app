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
  String get catDetailIconEmoji => '图标（emoji）';

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
}
