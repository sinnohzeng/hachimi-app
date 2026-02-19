// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

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
  String get timerGiveUp => '放弃';

  @override
  String get timerPause => '暂停';

  @override
  String get timerResume => '继续';

  @override
  String get timerDone => '完成';

  @override
  String get profileLanguage => '语言';

  @override
  String get profileAbout => '关于';

  @override
  String get profileAboutAttribution => '像素猫素材基于 pixel-cat-maker（CC BY-NC 4.0）';

  @override
  String get profileLogout => '退出登录';

  @override
  String get profileDeleteAccount => '删除账号';

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
  String get migrationMessage => '此版本使用了全新的猫猫系统，需要清除现有数据才能继续。';

  @override
  String get migrationConfirm => '清除数据并继续';

  @override
  String get migrationCancel => '取消';

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
  String get commonLoading => '加载中...';

  @override
  String get commonError => '出了点问题';

  @override
  String get commonRetry => '重试';

  @override
  String get todaySummaryMinutes => '今天';

  @override
  String get todaySummaryTotal => '总计';

  @override
  String get todaySummaryCats => '猫猫';

  @override
  String get todayFeaturedCat => '明星猫猫';

  @override
  String get todayAddHabit => '添加习惯';

  @override
  String get todayNoHabits => '创建第一个习惯来开始吧！';

  @override
  String get habitDetailStreak => '连续';

  @override
  String get habitDetailBestStreak => '最佳';

  @override
  String get habitDetailTotalMinutes => '总计';

  @override
  String get settingsNotifications => '通知';

  @override
  String get settingsVersion => '版本';
}
