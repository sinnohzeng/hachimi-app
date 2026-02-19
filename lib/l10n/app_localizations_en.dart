// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hachimi';

  @override
  String get homeTabToday => 'Today';

  @override
  String get homeTabCatHouse => 'CatHouse';

  @override
  String get homeTabStats => 'Stats';

  @override
  String get homeTabProfile => 'Profile';

  @override
  String get adoptionStepDefineHabit => 'Define Habit';

  @override
  String get adoptionStepAdoptCat => 'Adopt Cat';

  @override
  String get adoptionStepNameCat => 'Name Cat';

  @override
  String get adoptionHabitName => 'Habit Name';

  @override
  String get adoptionHabitNameHint => 'e.g. Daily Reading';

  @override
  String get adoptionDailyGoal => 'Daily Goal';

  @override
  String get adoptionTargetHours => 'Target Hours';

  @override
  String get adoptionTargetHoursHint => 'Total hours to complete this habit';

  @override
  String adoptionMinutes(int count) {
    return '$count min';
  }

  @override
  String get adoptionRefreshCat => 'Try another';

  @override
  String adoptionPersonality(String name) {
    return 'Personality: $name';
  }

  @override
  String get adoptionNameYourCat => 'Name your cat';

  @override
  String get adoptionRandomName => 'Random';

  @override
  String get adoptionCreate => 'Create Habit & Adopt';

  @override
  String get adoptionNext => 'Next';

  @override
  String get adoptionBack => 'Back';

  @override
  String get catHouseTitle => 'CatHouse';

  @override
  String get catHouseEmpty =>
      'No cats yet! Create a habit to adopt your first cat.';

  @override
  String catHouseGrowth(int minutes, int target) {
    return '$minutes / $target min';
  }

  @override
  String get catDetailGrowthProgress => 'Growth Progress';

  @override
  String catDetailTotalMinutes(int minutes) {
    return '$minutes min focused';
  }

  @override
  String catDetailTargetMinutes(int minutes) {
    return 'Target: $minutes min';
  }

  @override
  String get catDetailRename => 'Rename';

  @override
  String get catDetailAccessories => 'Accessories';

  @override
  String get catDetailStartFocus => 'Start Focus';

  @override
  String get catDetailBoundHabit => 'Bound Habit';

  @override
  String catDetailStage(String stage) {
    return 'Stage: $stage';
  }

  @override
  String coinBalance(int amount) {
    return '$amount coins';
  }

  @override
  String coinCheckInReward(int amount) {
    return '+$amount coins!';
  }

  @override
  String get coinCheckInTitle => 'Daily Check-in';

  @override
  String get coinInsufficientBalance => 'Not enough coins';

  @override
  String get shopTitle => 'Accessory Shop';

  @override
  String shopPrice(int price) {
    return '$price coins';
  }

  @override
  String get shopPurchase => 'Buy';

  @override
  String get shopEquipped => 'Equipped';

  @override
  String focusCompleteMinutes(int minutes) {
    return '+$minutes min';
  }

  @override
  String get focusCompleteStageUp => 'Stage Up!';

  @override
  String get focusCompleteGreatJob => 'Great job!';

  @override
  String get focusCompleteDone => 'Done';

  @override
  String get timerGiveUp => 'Give Up';

  @override
  String get timerPause => 'Pause';

  @override
  String get timerResume => 'Resume';

  @override
  String get timerDone => 'Done';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileAbout => 'About';

  @override
  String get profileAboutAttribution =>
      'Pixel cat sprites based on pixel-cat-maker (CC BY-NC 4.0)';

  @override
  String get profileLogout => 'Log Out';

  @override
  String get profileDeleteAccount => 'Delete Account';

  @override
  String get stageKitten => 'Kitten';

  @override
  String get stageAdolescent => 'Adolescent';

  @override
  String get stageAdult => 'Adult';

  @override
  String get stageSenior => 'Senior';

  @override
  String get migrationTitle => 'Data Update Required';

  @override
  String get migrationMessage =>
      'This version uses a new cat system. Your existing data needs to be cleared to continue.';

  @override
  String get migrationConfirm => 'Clear Data & Continue';

  @override
  String get migrationCancel => 'Cancel';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonRetry => 'Retry';

  @override
  String get todaySummaryMinutes => 'Today';

  @override
  String get todaySummaryTotal => 'Total';

  @override
  String get todaySummaryCats => 'Cats';

  @override
  String get todayFeaturedCat => 'Featured Cat';

  @override
  String get todayAddHabit => 'Add Habit';

  @override
  String get todayNoHabits => 'Create your first habit to get started!';

  @override
  String get habitDetailStreak => 'Streak';

  @override
  String get habitDetailBestStreak => 'Best';

  @override
  String get habitDetailTotalMinutes => 'Total';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsVersion => 'Version';
}
