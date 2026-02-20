// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

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
  String get focusCompleteItsOkay => 'It\'s okay!';

  @override
  String focusCompleteEvolved(String catName) {
    return '$catName evolved!';
  }

  @override
  String focusCompleteFocusedFor(int minutes) {
    return 'You focused for $minutes minutes';
  }

  @override
  String focusCompleteAbandonedMessage(String catName) {
    return '$catName says: \"We\'ll try again!\"';
  }

  @override
  String get focusCompleteFocusTime => 'Focus time';

  @override
  String get focusCompleteCoinsEarned => 'Coins earned';

  @override
  String get focusCompleteBaseXp => 'Base XP';

  @override
  String get focusCompleteStreakBonus => 'Streak bonus';

  @override
  String get focusCompleteMilestoneBonus => 'Milestone bonus';

  @override
  String get focusCompleteFullHouseBonus => 'Full house bonus';

  @override
  String get focusCompleteTotal => 'Total';

  @override
  String focusCompleteEvolvedTo(String stage) {
    return 'Evolved to $stage!';
  }

  @override
  String get focusCompleteYourCat => 'Your cat';

  @override
  String get focusCompleteDiaryWriting => 'Writing diary...';

  @override
  String get focusCompleteDiaryWritten => 'Diary written!';

  @override
  String get focusCompleteNotifTitle => 'Quest complete!';

  @override
  String focusCompleteNotifBody(String catName, int xp, int minutes) {
    return '$catName earned +$xp XP from ${minutes}min of focus';
  }

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
      'Hachimi has been updated with a new pixel cat system! Your old cat data is no longer compatible. Please reset to start fresh with the new experience.';

  @override
  String get migrationResetButton => 'Reset & Start Fresh';

  @override
  String get sessionResumeTitle => 'Resume session?';

  @override
  String sessionResumeMessage(String habitName, String elapsed) {
    return 'You had an active focus session ($habitName, $elapsed). Resume?';
  }

  @override
  String get sessionResumeButton => 'Resume';

  @override
  String get sessionDiscard => 'Discard';

  @override
  String get todaySummaryMinutes => 'Today';

  @override
  String get todaySummaryTotal => 'Total';

  @override
  String get todaySummaryCats => 'Cats';

  @override
  String get todayYourQuests => 'Your Quests';

  @override
  String get todayNoQuests => 'No quests yet';

  @override
  String get todayNoQuestsHint => 'Tap + to start a quest and adopt a cat!';

  @override
  String get todayFocus => 'Focus';

  @override
  String get todayDeleteQuestTitle => 'Delete quest?';

  @override
  String todayDeleteQuestMessage(String name) {
    return 'Are you sure you want to delete \"$name\"? The cat will be graduated to your album.';
  }

  @override
  String todayQuestCompleted(String name) {
    return '$name completed';
  }

  @override
  String get todayFailedToLoad => 'Failed to load quests';

  @override
  String todayMinToday(int count) {
    return '${count}min today';
  }

  @override
  String todayGoalMinPerDay(int count) {
    return 'Goal: ${count}min/day';
  }

  @override
  String get todayFeaturedCat => 'Featured Cat';

  @override
  String get todayAddHabit => 'Add Habit';

  @override
  String get todayNoHabits => 'Create your first habit to get started!';

  @override
  String get todayNewQuest => 'New quest';

  @override
  String get todayStartFocus => 'Start focus';

  @override
  String get timerStart => 'Start';

  @override
  String get timerPause => 'Pause';

  @override
  String get timerResume => 'Resume';

  @override
  String get timerDone => 'Done';

  @override
  String get timerGiveUp => 'Give Up';

  @override
  String get timerRemaining => 'remaining';

  @override
  String get timerElapsed => 'elapsed';

  @override
  String get timerPaused => 'PAUSED';

  @override
  String get timerQuestNotFound => 'Quest not found';

  @override
  String get timerNotificationBanner =>
      'Enable notifications to see timer progress when the app is in the background';

  @override
  String get timerNotificationDismiss => 'Dismiss';

  @override
  String get timerNotificationEnable => 'Enable';

  @override
  String timerGraceBack(int seconds) {
    return 'Back (${seconds}s)';
  }

  @override
  String get giveUpTitle => 'Give up?';

  @override
  String get giveUpMessage =>
      'If you focused for at least 5 minutes, the time still counts towards your cat\'s growth. Your cat will understand!';

  @override
  String get giveUpKeepGoing => 'Keep Going';

  @override
  String get giveUpConfirm => 'Give Up';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsNotificationFocusReminders => 'Focus Reminders';

  @override
  String get settingsNotificationSubtitle =>
      'Receive daily reminders to stay on track';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System default';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageChinese => 'Chinese';

  @override
  String get settingsThemeMode => 'Theme Mode';

  @override
  String get settingsThemeModeSystem => 'System';

  @override
  String get settingsThemeModeLight => 'Light';

  @override
  String get settingsThemeModeDark => 'Dark';

  @override
  String get settingsMaterialYou => 'Material You';

  @override
  String get settingsMaterialYouSubtitle => 'Use wallpaper colors for theme';

  @override
  String get settingsThemeColor => 'Theme Color';

  @override
  String get settingsAiModel => 'AI Model';

  @override
  String get settingsAiFeatures => 'AI Features';

  @override
  String get settingsAiSubtitle =>
      'Enable cat diary and chat powered by on-device AI';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsPixelCatSprites => 'Pixel Cat Sprites';

  @override
  String get settingsLicenses => 'Licenses';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsDownloadModel => 'Download Model (1.2 GB)';

  @override
  String get settingsDeleteModel => 'Delete Model';

  @override
  String get settingsDeleteModelTitle => 'Delete model?';

  @override
  String get settingsDeleteModelMessage =>
      'This will delete the downloaded AI model (1.2 GB). You can download it again later.';

  @override
  String get logoutTitle => 'Log out?';

  @override
  String get logoutMessage => 'Are you sure you want to log out?';

  @override
  String get deleteAccountTitle => 'Delete account?';

  @override
  String get deleteAccountMessage =>
      'This will permanently delete your account and all your data. This action cannot be undone.';

  @override
  String get deleteAccountWarning => 'This action cannot be undone';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileYourJourney => 'Your Journey';

  @override
  String get profileTotalFocus => 'Total Focus';

  @override
  String get profileTotalCats => 'Total Cats';

  @override
  String get profileBestStreak => 'Best Streak';

  @override
  String get profileCatAlbum => 'Cat Album';

  @override
  String profileCatAlbumCount(int count) {
    return '$count cats';
  }

  @override
  String profileSeeAll(int count) {
    return 'See all $count cats';
  }

  @override
  String get profileGraduated => 'Graduated';

  @override
  String get profileSettings => 'Settings';

  @override
  String get habitDetailStreak => 'Streak';

  @override
  String get habitDetailBestStreak => 'Best';

  @override
  String get habitDetailTotalMinutes => 'Total';

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
  String get commonDone => 'Done';

  @override
  String get commonDismiss => 'Dismiss';

  @override
  String get commonEnable => 'Enable';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonResume => 'Resume';

  @override
  String get commonPause => 'Pause';

  @override
  String get commonLogOut => 'Log Out';

  @override
  String get commonDeleteAccount => 'Delete Account';

  @override
  String get testChatTitle => 'Test AI Model';

  @override
  String get testChatLoadingModel => 'Loading model...';

  @override
  String get testChatModelLoaded => 'Model loaded';

  @override
  String get testChatErrorLoading => 'Error loading model';

  @override
  String get testChatCouldNotLoad => 'Could not load model';

  @override
  String get testChatFailedToLoad => 'Failed to load model';

  @override
  String get testChatUnknownError => 'Unknown error';

  @override
  String get testChatModelReady => 'Model ready';

  @override
  String get testChatSendToTest => 'Send a message to test the AI model.';

  @override
  String get testChatGenerating => 'Generating...';

  @override
  String get testChatTypeMessage => 'Type a message...';

  @override
  String get settingsAiPrivacyBadge =>
      'Powered by on-device AI — all processing runs locally';

  @override
  String get settingsAiWhatYouGet => 'What you get:';

  @override
  String get settingsAiFeatureDiary =>
      'Hachimi Diary — Your cat writes daily diary entries';

  @override
  String get settingsAiFeatureChat =>
      'Cat Chat — Have conversations with your cat';

  @override
  String get settingsRedownload => 'Redownload';

  @override
  String get settingsTestModel => 'Test Model';

  @override
  String get settingsStatusDownloading => 'Downloading';

  @override
  String get settingsStatusReady => 'Ready';

  @override
  String get settingsStatusError => 'Error';

  @override
  String get settingsStatusLoading => 'Loading';

  @override
  String get settingsStatusNotDownloaded => 'Not downloaded';

  @override
  String get settingsStatusDisabled => 'Disabled';

  @override
  String get catDetailNotFound => 'Cat not found';

  @override
  String get catDetailChatTooltip => 'Chat';

  @override
  String get catDetailRenameTooltip => 'Rename';

  @override
  String get catDetailGrowthTitle => 'Growth Progress';

  @override
  String catDetailTarget(int hours) {
    return 'Target: ${hours}h';
  }

  @override
  String get catDetailRenameTitle => 'Rename Cat';

  @override
  String get catDetailNewName => 'New name';

  @override
  String get catDetailRenamed => 'Cat renamed!';

  @override
  String get catDetailQuestBadge => 'Quest';

  @override
  String get catDetailEditQuest => 'Edit quest';

  @override
  String get catDetailDailyGoal => 'Daily goal';

  @override
  String get catDetailTodaysFocus => 'Today\'s focus';

  @override
  String get catDetailTotalFocus => 'Total focus';

  @override
  String get catDetailTargetLabel => 'Target';

  @override
  String get catDetailCompletion => 'Completion';

  @override
  String get catDetailCurrentStreak => 'Current streak';

  @override
  String get catDetailBestStreakLabel => 'Best streak';

  @override
  String get catDetailAvgDaily => 'Avg daily';

  @override
  String get catDetailDaysActive => 'Days active';

  @override
  String get catDetailEditQuestTitle => 'Edit Quest';

  @override
  String get catDetailIconEmoji => 'Icon (emoji)';

  @override
  String get catDetailQuestName => 'Quest name';

  @override
  String get catDetailDailyGoalMinutes => 'Daily goal (minutes)';

  @override
  String get catDetailTargetTotalHours => 'Target total (hours)';

  @override
  String get catDetailQuestUpdated => 'Quest updated!';

  @override
  String get catDetailDailyReminder => 'Daily Reminder';

  @override
  String catDetailEveryDay(String time) {
    return '$time every day';
  }

  @override
  String get catDetailNoReminder => 'No reminder set';

  @override
  String get catDetailChange => 'Change';

  @override
  String get catDetailRemoveReminder => 'Remove reminder';

  @override
  String get catDetailSet => 'Set';

  @override
  String catDetailReminderSet(String time) {
    return 'Reminder set for $time';
  }

  @override
  String get catDetailReminderRemoved => 'Reminder removed';

  @override
  String get catDetailDiaryTitle => 'Hachimi Diary';

  @override
  String get catDetailDiaryLoading => 'Loading...';

  @override
  String get catDetailDiaryError => 'Could not load diary';

  @override
  String get catDetailDiaryEmpty =>
      'No diary entry today yet. Complete a focus session!';

  @override
  String catDetailChatWith(String name) {
    return 'Chat with $name';
  }

  @override
  String get catDetailChatSubtitle => 'Have a conversation with your cat';

  @override
  String get catDetailActivity => 'Activity';

  @override
  String get catDetailActivityError => 'Failed to load activity data';

  @override
  String get catDetailAccessoriesTitle => 'Accessories';

  @override
  String get catDetailEquipped => 'Equipped: ';

  @override
  String get catDetailNone => 'None';

  @override
  String get catDetailUnequip => 'Unequip';

  @override
  String catDetailFromInventory(int count) {
    return 'From Inventory ($count)';
  }

  @override
  String get catDetailNoAccessories => 'No accessories yet. Visit the shop!';

  @override
  String catDetailEquippedItem(String name) {
    return 'Equipped $name';
  }

  @override
  String get catDetailUnequipped => 'Unequipped';

  @override
  String catDetailAbout(String name) {
    return 'About $name';
  }

  @override
  String get catDetailAppearanceDetails => 'Appearance details';

  @override
  String get catDetailStatus => 'Status';

  @override
  String get catDetailAdopted => 'Adopted';

  @override
  String get catDetailFurPattern => 'Fur pattern';

  @override
  String get catDetailFurColor => 'Fur color';

  @override
  String get catDetailFurLength => 'Fur length';

  @override
  String get catDetailEyes => 'Eyes';

  @override
  String get catDetailWhitePatches => 'White patches';

  @override
  String get catDetailPatchesTint => 'Patches tint';

  @override
  String get catDetailTint => 'Tint';

  @override
  String get catDetailPoints => 'Points';

  @override
  String get catDetailVitiligo => 'Vitiligo';

  @override
  String get catDetailTortoiseshell => 'Tortoiseshell';

  @override
  String get catDetailTortiePattern => 'Tortie pattern';

  @override
  String get catDetailTortieColor => 'Tortie color';

  @override
  String get catDetailSkin => 'Skin';

  @override
  String get offlineMessage =>
      'You\'re offline — changes will sync when reconnected';

  @override
  String get offlineModeLabel => 'Offline mode';

  @override
  String habitTodayMinutes(int count) {
    return 'Today: ${count}min';
  }

  @override
  String get habitDeleteTooltip => 'Delete habit';

  @override
  String get heatmapActiveDays => 'Active days';

  @override
  String get heatmapTotal => 'Total';

  @override
  String get heatmapRate => 'Rate';

  @override
  String get heatmapLess => 'Less';

  @override
  String get heatmapMore => 'More';

  @override
  String get accessoryEquipped => 'Equipped';

  @override
  String get accessoryOwned => 'Owned';

  @override
  String get pickerMinUnit => 'min';

  @override
  String get settingsBackgroundAnimation => 'Animated backgrounds';

  @override
  String get settingsBackgroundAnimationSubtitle =>
      'Mesh gradient and floating particles';
}
