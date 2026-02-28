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
  String get adoptionCatNameLabel => 'Cat name';

  @override
  String get adoptionCatNameHint => 'e.g. Mochi';

  @override
  String get adoptionRandomNameTooltip => 'Random name';

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
  String get settingsThemeColor => 'Theme Color';

  @override
  String get settingsThemeColorDynamic => 'Dynamic';

  @override
  String get settingsThemeColorDynamicSubtitle => 'Use wallpaper colors';

  @override
  String get settingsAiModel => 'AI Model';

  @override
  String get settingsAiFeatures => 'AI Features';

  @override
  String get settingsAiSubtitle =>
      'Enable cat diary and chat powered by cloud AI';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsLicenses => 'Licenses';

  @override
  String get settingsAccount => 'Account';

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
  String get profileTotalQuests => 'Quests';

  @override
  String get profileEditName => 'Edit name';

  @override
  String get profileDisplayName => 'Display name';

  @override
  String get profileChooseAvatar => 'Choose avatar';

  @override
  String get profileSaved => 'Profile saved';

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
  String get commonYes => 'Yes';

  @override
  String get testChatTitle => 'Test AI';

  @override
  String get testChatModelReady => 'AI Ready';

  @override
  String get testChatSendToTest => 'Send a message to test the AI.';

  @override
  String get testChatGenerating => 'Generating...';

  @override
  String get testChatTypeMessage => 'Type a message...';

  @override
  String get settingsAiProvider => 'Provider';

  @override
  String get settingsAiProviderMinimax => 'MiniMax (default)';

  @override
  String get settingsAiProviderGemini => 'Gemini';

  @override
  String get settingsAiCloudBadge => 'Powered by cloud AI — requires network';

  @override
  String get settingsAiWhatYouGet => 'What you get:';

  @override
  String get settingsAiFeatureDiary =>
      'Hachimi Diary — Your cat writes daily diary entries';

  @override
  String get settingsAiFeatureChat =>
      'Cat Chat — Have conversations with your cat';

  @override
  String get settingsTestConnection => 'Test Connection';

  @override
  String get settingsConnectionSuccess => 'Connection successful';

  @override
  String get settingsConnectionFailed => 'Connection failed';

  @override
  String get settingsTestModel => 'Test Chat';

  @override
  String get settingsStatusReady => 'Ready';

  @override
  String get settingsStatusError => 'Error';

  @override
  String get settingsStatusDisabled => 'Disabled';

  @override
  String get aiPrivacyTitle => 'Cloud AI Privacy Notice';

  @override
  String get aiPrivacyMessage =>
      'When AI features are enabled, your cat\'s name, personality, and focus data will be sent to cloud servers for generating diary entries and chat responses. An internet connection is required. You can disable AI features at any time.';

  @override
  String get aiPrivacyAccept => 'I understand';

  @override
  String get aiRequiresNetwork => 'Requires network connection';

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
  String get catDetailCheckInDays => 'Check-in days';

  @override
  String get catDetailEditQuestTitle => 'Edit Quest';

  @override
  String get catDetailQuestName => 'Quest name';

  @override
  String get catDetailDailyGoalMinutes => 'Daily goal (minutes)';

  @override
  String get catDetailTargetTotalHours => 'Target total (hours)';

  @override
  String get catDetailQuestUpdated => 'Quest updated!';

  @override
  String get catDetailTargetCompletedHint =>
      'Target already reached — now in unlimited mode';

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

  @override
  String get personalityLazy => 'Lazy';

  @override
  String get personalityCurious => 'Curious';

  @override
  String get personalityPlayful => 'Playful';

  @override
  String get personalityShy => 'Shy';

  @override
  String get personalityBrave => 'Brave';

  @override
  String get personalityClingy => 'Clingy';

  @override
  String get personalityFlavorLazy =>
      'Will nap 23 hours a day. The other hour? Also napping.';

  @override
  String get personalityFlavorCurious =>
      'Already sniffing everything in sight!';

  @override
  String get personalityFlavorPlayful => 'Can\'t stop chasing butterflies!';

  @override
  String get personalityFlavorShy => 'Took 3 minutes to peek out of the box...';

  @override
  String get personalityFlavorBrave =>
      'Jumped out of the box before it was even opened!';

  @override
  String get personalityFlavorClingy =>
      'Immediately started purring and won\'t let go.';

  @override
  String get moodHappy => 'Happy';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodLonely => 'Lonely';

  @override
  String get moodMissing => 'Missing You';

  @override
  String get moodMsgLazyHappy => 'Nya~! Time for a well-deserved nap...';

  @override
  String get moodMsgCuriousHappy => 'What are we exploring today?';

  @override
  String get moodMsgPlayfulHappy => 'Nya~! Ready to work!';

  @override
  String get moodMsgShyHappy => '...I-I\'m glad you\'re here.';

  @override
  String get moodMsgBraveHappy => 'Let\'s conquer today together!';

  @override
  String get moodMsgClingyHappy => 'Yay! You\'re back! Don\'t leave again!';

  @override
  String get moodMsgLazyNeutral => '*yawn* Oh, hey...';

  @override
  String get moodMsgCuriousNeutral => 'Hmm, what\'s that over there?';

  @override
  String get moodMsgPlayfulNeutral => 'Wanna play? Maybe later...';

  @override
  String get moodMsgShyNeutral => '*peeks out slowly*';

  @override
  String get moodMsgBraveNeutral => 'Standing guard, as always.';

  @override
  String get moodMsgClingyNeutral => 'I\'ve been waiting for you...';

  @override
  String get moodMsgLazyLonely => 'Even napping feels lonely...';

  @override
  String get moodMsgCuriousLonely => 'I wonder when you\'ll come back...';

  @override
  String get moodMsgPlayfulLonely => 'The toys aren\'t fun without you...';

  @override
  String get moodMsgShyLonely => '*curls up quietly*';

  @override
  String get moodMsgBraveLonely => 'I\'ll keep waiting. I\'m brave.';

  @override
  String get moodMsgClingyLonely => 'Where did you go... 🥺';

  @override
  String get moodMsgLazyMissing => '*opens one eye hopefully*';

  @override
  String get moodMsgCuriousMissing => 'Did something happen...?';

  @override
  String get moodMsgPlayfulMissing => 'I saved your favorite toy...';

  @override
  String get moodMsgShyMissing => '*hiding, but watching the door*';

  @override
  String get moodMsgBraveMissing => 'I know you\'ll come back. I believe.';

  @override
  String get moodMsgClingyMissing => 'I miss you so much... please come back.';

  @override
  String get peltTypeTabby => 'Classic tabby stripes';

  @override
  String get peltTypeTicked => 'Ticked agouti pattern';

  @override
  String get peltTypeMackerel => 'Mackerel tabby';

  @override
  String get peltTypeClassic => 'Classic swirl pattern';

  @override
  String get peltTypeSokoke => 'Sokoke marble pattern';

  @override
  String get peltTypeAgouti => 'Agouti ticked';

  @override
  String get peltTypeSpeckled => 'Speckled coat';

  @override
  String get peltTypeRosette => 'Rosette spotted';

  @override
  String get peltTypeSingleColour => 'Solid color';

  @override
  String get peltTypeTwoColour => 'Two-tone';

  @override
  String get peltTypeSmoke => 'Smoke shading';

  @override
  String get peltTypeSinglestripe => 'Single stripe';

  @override
  String get peltTypeBengal => 'Bengal pattern';

  @override
  String get peltTypeMarbled => 'Marbled pattern';

  @override
  String get peltTypeMasked => 'Masked face';

  @override
  String get peltColorWhite => 'White';

  @override
  String get peltColorPaleGrey => 'Pale grey';

  @override
  String get peltColorSilver => 'Silver';

  @override
  String get peltColorGrey => 'Grey';

  @override
  String get peltColorDarkGrey => 'Dark grey';

  @override
  String get peltColorGhost => 'Ghost grey';

  @override
  String get peltColorBlack => 'Black';

  @override
  String get peltColorCream => 'Cream';

  @override
  String get peltColorPaleGinger => 'Pale ginger';

  @override
  String get peltColorGolden => 'Golden';

  @override
  String get peltColorGinger => 'Ginger';

  @override
  String get peltColorDarkGinger => 'Dark ginger';

  @override
  String get peltColorSienna => 'Sienna';

  @override
  String get peltColorLightBrown => 'Light brown';

  @override
  String get peltColorLilac => 'Lilac';

  @override
  String get peltColorBrown => 'Brown';

  @override
  String get peltColorGoldenBrown => 'Golden brown';

  @override
  String get peltColorDarkBrown => 'Dark brown';

  @override
  String get peltColorChocolate => 'Chocolate';

  @override
  String get eyeColorYellow => 'Yellow';

  @override
  String get eyeColorAmber => 'Amber';

  @override
  String get eyeColorHazel => 'Hazel';

  @override
  String get eyeColorPaleGreen => 'Pale green';

  @override
  String get eyeColorGreen => 'Green';

  @override
  String get eyeColorBlue => 'Blue';

  @override
  String get eyeColorDarkBlue => 'Dark blue';

  @override
  String get eyeColorBlueYellow => 'Blue-yellow';

  @override
  String get eyeColorBlueGreen => 'Blue-green';

  @override
  String get eyeColorGrey => 'Grey';

  @override
  String get eyeColorCyan => 'Cyan';

  @override
  String get eyeColorEmerald => 'Emerald';

  @override
  String get eyeColorHeatherBlue => 'Heather blue';

  @override
  String get eyeColorSunlitIce => 'Sunlit ice';

  @override
  String get eyeColorCopper => 'Copper';

  @override
  String get eyeColorSage => 'Sage';

  @override
  String get eyeColorCobalt => 'Cobalt';

  @override
  String get eyeColorPaleBlue => 'Pale blue';

  @override
  String get eyeColorBronze => 'Bronze';

  @override
  String get eyeColorSilver => 'Silver';

  @override
  String get eyeColorPaleYellow => 'Pale yellow';

  @override
  String eyeDescNormal(String color) {
    return '$color eyes';
  }

  @override
  String eyeDescHeterochromia(String primary, String secondary) {
    return 'Heterochromia ($primary / $secondary)';
  }

  @override
  String get skinColorPink => 'Pink';

  @override
  String get skinColorRed => 'Red';

  @override
  String get skinColorBlack => 'Black';

  @override
  String get skinColorDark => 'Dark';

  @override
  String get skinColorDarkBrown => 'Dark brown';

  @override
  String get skinColorBrown => 'Brown';

  @override
  String get skinColorLightBrown => 'Light brown';

  @override
  String get skinColorDarkGrey => 'Dark grey';

  @override
  String get skinColorGrey => 'Grey';

  @override
  String get skinColorDarkSalmon => 'Dark salmon';

  @override
  String get skinColorSalmon => 'Salmon';

  @override
  String get skinColorPeach => 'Peach';

  @override
  String get furLengthLonghair => 'Longhair';

  @override
  String get furLengthShorthair => 'Shorthair';

  @override
  String get whiteTintOffwhite => 'Off-white tint';

  @override
  String get whiteTintCream => 'Cream tint';

  @override
  String get whiteTintDarkCream => 'Dark cream tint';

  @override
  String get whiteTintGray => 'Grey tint';

  @override
  String get whiteTintPink => 'Pink tint';

  @override
  String notifReminderTitle(String catName) {
    return '$catName misses you!';
  }

  @override
  String notifReminderBody(String habitName) {
    return 'Time for $habitName — your cat is waiting!';
  }

  @override
  String notifStreakTitle(String catName) {
    return '$catName is worried!';
  }

  @override
  String notifStreakBody(int streak) {
    return 'Your $streak-day streak is at risk. A quick session will save it!';
  }

  @override
  String notifEvolutionTitle(String catName) {
    return '$catName evolved!';
  }

  @override
  String notifEvolutionBody(String catName, String stageName) {
    return '$catName grew into a $stageName! Keep up the great work!';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String diaryScreenTitle(String name) {
    return '$name Diary';
  }

  @override
  String get diaryFailedToLoad => 'Failed to load diary';

  @override
  String get diaryEmptyTitle => 'No diary entries yet';

  @override
  String get diaryEmptyHint =>
      'Complete a focus session and your cat will write their first diary entry!';

  @override
  String get focusSetupCountdown => 'Countdown';

  @override
  String get focusSetupStopwatch => 'Stopwatch';

  @override
  String get focusSetupStartFocus => 'Start Focus';

  @override
  String get focusSetupQuestNotFound => 'Quest not found';

  @override
  String get checkInButtonLogMore => 'Log more time';

  @override
  String get checkInButtonStart => 'Start timer';

  @override
  String get adoptionTitleFirst => 'Adopt Your First Cat!';

  @override
  String get adoptionTitleNew => 'New Quest';

  @override
  String get adoptionStepDefineQuest => 'Define Quest';

  @override
  String get adoptionStepAdoptCat2 => 'Adopt Cat';

  @override
  String get adoptionStepNameCat2 => 'Name Cat';

  @override
  String get adoptionAdopt => 'Adopt!';

  @override
  String get adoptionQuestPrompt => 'What quest do you want to start?';

  @override
  String get adoptionKittenHint =>
      'A kitten will be assigned to help you stay on track!';

  @override
  String get adoptionQuestName => 'Quest name';

  @override
  String get adoptionQuestHint => 'e.g. Prepare interview questions';

  @override
  String get adoptionTotalTarget => 'Total target hours';

  @override
  String get adoptionGrowthHint =>
      'Your cat grows as you accumulate focus time';

  @override
  String get adoptionCustom => 'Custom';

  @override
  String get adoptionDailyGoalLabel => 'Daily focus goal';

  @override
  String get adoptionReminderLabel => 'Daily reminder (optional)';

  @override
  String get adoptionReminderNone => 'None';

  @override
  String get adoptionCustomGoalTitle => 'Custom daily goal';

  @override
  String get adoptionMinutesPerDay => 'Minutes per day';

  @override
  String get adoptionMinutesHint => '5 - 180';

  @override
  String get adoptionValidMinutes => 'Enter a value between 5 and 180';

  @override
  String get adoptionCustomTargetTitle => 'Custom target hours';

  @override
  String get adoptionTotalHours => 'Total hours';

  @override
  String get adoptionHoursHint => '10 - 2000';

  @override
  String get adoptionValidHours => 'Enter a value between 10 and 2000';

  @override
  String get adoptionSet => 'Set';

  @override
  String get adoptionChooseKitten => 'Choose your kitten!';

  @override
  String adoptionCompanionFor(String quest) {
    return 'Your companion for \"$quest\"';
  }

  @override
  String get adoptionRerollAll => 'Reroll All';

  @override
  String get adoptionNameYourCat2 => 'Name your cat';

  @override
  String get adoptionCatName => 'Cat name';

  @override
  String get adoptionCatHint => 'e.g. Mochi';

  @override
  String get adoptionRandomTooltip => 'Random name';

  @override
  String adoptionGrowthTarget(String quest, int hours) {
    return 'Your cat will grow as you focus on \"$quest\"! Target: ${hours}h total.';
  }

  @override
  String get adoptionValidQuestName => 'Please enter a quest name';

  @override
  String get adoptionValidCatName => 'Please name your cat';

  @override
  String adoptionError(String message) {
    return 'Error: $message';
  }

  @override
  String get adoptionBasicInfo => 'Basic info';

  @override
  String get adoptionGoals => 'Goals';

  @override
  String get adoptionUnlimitedMode => 'Unlimited mode';

  @override
  String get adoptionUnlimitedDesc => 'No upper limit, keep accumulating';

  @override
  String get adoptionMilestoneMode => 'Milestone mode';

  @override
  String get adoptionMilestoneDesc => 'Set a target to reach';

  @override
  String get adoptionDeadlineLabel => 'Deadline';

  @override
  String get adoptionDeadlineNone => 'Not set';

  @override
  String get adoptionReminderSection => 'Reminder';

  @override
  String get adoptionMotivationLabel => 'Note';

  @override
  String get adoptionMotivationHint => 'Write a note...';

  @override
  String get adoptionMotivationSwap => 'Random fill';

  @override
  String get loginAppName => 'Hachimi';

  @override
  String get loginTagline => 'Raise cats. Complete quests.';

  @override
  String get loginContinueGoogle => 'Continue with Google';

  @override
  String get loginContinueEmail => 'Continue with Email';

  @override
  String get loginAlreadyHaveAccount => 'Already have an account? ';

  @override
  String get loginLogIn => 'Log In';

  @override
  String get loginWelcomeBack => 'Welcome back!';

  @override
  String get loginCreateAccount => 'Create your account';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginConfirmPassword => 'Confirm Password';

  @override
  String get loginValidEmail => 'Please enter your email';

  @override
  String get loginValidEmailFormat => 'Please enter a valid email';

  @override
  String get loginValidPassword => 'Please enter your password';

  @override
  String get loginValidPasswordLength =>
      'Password must be at least 6 characters';

  @override
  String get loginValidPasswordMatch => 'Passwords do not match';

  @override
  String get loginCreateAccountButton => 'Create Account';

  @override
  String get loginNoAccount => 'Don\'t have an account? ';

  @override
  String get loginRegister => 'Register';

  @override
  String get checkInTitle => 'Monthly Check-In';

  @override
  String get checkInDays => 'Days';

  @override
  String get checkInCoinsEarned => 'Coins earned';

  @override
  String get checkInAllMilestones => 'All milestones claimed!';

  @override
  String checkInMilestoneProgress(int remaining, int bonus) {
    return '$remaining more days → +$bonus coins';
  }

  @override
  String get checkInMilestones => 'Milestones';

  @override
  String get checkInFullMonth => 'Full month';

  @override
  String get checkInRewardSchedule => 'Reward Schedule';

  @override
  String get checkInWeekday => 'Weekday (Mon–Fri)';

  @override
  String checkInWeekdayReward(int coins) {
    return '$coins coins/day';
  }

  @override
  String get checkInWeekend => 'Weekend (Sat–Sun)';

  @override
  String checkInNDays(int count) {
    return '$count days';
  }

  @override
  String get onboardTitle1 => 'Welcome to Hachimi';

  @override
  String get onboardSubtitle1 => 'Raise cats, complete quests';

  @override
  String get onboardBody1 =>
      'Every quest you start comes with a kitten.\nFocus on your goals and watch them grow\nfrom tiny kittens into shiny cats!';

  @override
  String get onboardTitle2 => 'Focus & Grow';

  @override
  String get onboardSubtitle2 => 'Every minute counts';

  @override
  String get onboardBody2 =>
      'Start a focus session and your cat grows with you.\nThe more time you invest, the faster it evolves\nthrough each stage!';

  @override
  String get onboardTitle3 => 'Watch Them Evolve';

  @override
  String get onboardSubtitle3 => '4 stages of growth';

  @override
  String get onboardBody3 =>
      'Cats evolve through 4 stages as they grow.\nCollect different breeds, discover unique personalities,\nand build your dream cat room!';

  @override
  String get onboardSkip => 'Skip';

  @override
  String get onboardLetsGo => 'Let\'s Go!';

  @override
  String get onboardNext => 'Next';

  @override
  String get catRoomTitle => 'CatHouse';

  @override
  String get catRoomInventory => 'Inventory';

  @override
  String get catRoomShop => 'Accessory Shop';

  @override
  String get catRoomLoadError => 'Failed to load cats';

  @override
  String get catRoomEmptyTitle => 'Your CatHouse is empty';

  @override
  String get catRoomEmptySubtitle => 'Start a quest to adopt your first cat!';

  @override
  String get catRoomEditQuest => 'Edit Quest';

  @override
  String get catRoomRenameCat => 'Rename Cat';

  @override
  String get catRoomArchiveCat => 'Archive Cat';

  @override
  String get catRoomNewName => 'New name';

  @override
  String get catRoomRename => 'Rename';

  @override
  String get catRoomArchiveTitle => 'Archive cat?';

  @override
  String catRoomArchiveMessage(String name) {
    return 'This will archive \"$name\" and delete its bound quest. The cat will still appear in your album.';
  }

  @override
  String get catRoomArchive => 'Archive';

  @override
  String get addHabitTitle => 'New Quest';

  @override
  String get addHabitQuestName => 'Quest name';

  @override
  String get addHabitQuestHint => 'e.g. LeetCode Practice';

  @override
  String get addHabitValidName => 'Please enter a quest name';

  @override
  String get addHabitTargetHours => 'Target hours';

  @override
  String get addHabitTargetHint => 'e.g. 100';

  @override
  String get addHabitValidTarget => 'Please enter target hours';

  @override
  String get addHabitValidNumber => 'Please enter a valid number';

  @override
  String get addHabitCreate => 'Create Quest';

  @override
  String get addHabitHoursSuffix => 'hours';

  @override
  String shopTabPlants(int count) {
    return 'Plants ($count)';
  }

  @override
  String shopTabWild(int count) {
    return 'Wild ($count)';
  }

  @override
  String shopTabCollars(int count) {
    return 'Collars ($count)';
  }

  @override
  String get shopNoAccessories => 'No accessories available';

  @override
  String shopBuyConfirm(String name) {
    return 'Buy $name?';
  }

  @override
  String get shopPurchaseButton => 'Purchase';

  @override
  String get shopNotEnoughCoinsButton => 'Not enough coins';

  @override
  String shopPurchaseSuccess(String name) {
    return 'Purchased! $name added to inventory';
  }

  @override
  String shopPurchaseFailed(int price) {
    return 'Not enough coins (need $price)';
  }

  @override
  String get inventoryTitle => 'Inventory';

  @override
  String inventoryInBox(int count) {
    return 'In Box ($count)';
  }

  @override
  String get inventoryEmpty =>
      'Your inventory is empty.\nVisit the shop to get accessories!';

  @override
  String inventoryEquippedOnCats(int count) {
    return 'Equipped on Cats ($count)';
  }

  @override
  String get inventoryNoEquipped => 'No accessories equipped on any cat.';

  @override
  String get inventoryUnequip => 'Unequip';

  @override
  String get inventoryNoActiveCats => 'No active cats';

  @override
  String inventoryEquipTo(String name) {
    return 'Equip $name to:';
  }

  @override
  String inventoryEquipSuccess(String name) {
    return 'Equipped $name';
  }

  @override
  String inventoryUnequipSuccess(String catName) {
    return 'Unequipped from $catName';
  }

  @override
  String get chatCatNotFound => 'Cat not found';

  @override
  String chatTitle(String name) {
    return 'Chat with $name';
  }

  @override
  String get chatClearHistory => 'Clear history';

  @override
  String chatEmptyTitle(String name) {
    return 'Say hi to $name!';
  }

  @override
  String get chatEmptySubtitle =>
      'Start a conversation with your cat. They will reply based on their personality!';

  @override
  String get chatGenerating => 'Generating...';

  @override
  String get chatTypeMessage => 'Type a message...';

  @override
  String get chatClearConfirmTitle => 'Clear chat history?';

  @override
  String get chatClearConfirmMessage =>
      'This will delete all messages. This cannot be undone.';

  @override
  String get chatClearButton => 'Clear';

  @override
  String diaryTitle(String name) {
    return '$name Diary';
  }

  @override
  String get diaryLoadFailed => 'Failed to load diary';

  @override
  String get diaryRetry => 'Retry';

  @override
  String get diaryEmptyTitle2 => 'No diary entries yet';

  @override
  String get diaryEmptySubtitle =>
      'Complete a focus session and your cat will write their first diary entry!';

  @override
  String get statsTitle => 'Statistics';

  @override
  String get statsTotalHours => 'Total Hours';

  @override
  String statsTimeValue(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get statsBestStreak => 'Best Streak';

  @override
  String statsStreakDays(int count) {
    return '$count days';
  }

  @override
  String get statsOverallProgress => 'Overall Progress';

  @override
  String statsPercentOfGoals(String percent) {
    return '$percent% of all goals';
  }

  @override
  String get statsPerQuestProgress => 'Per-Quest Progress';

  @override
  String get statsQuestLoadError => 'Failed to load quest stats';

  @override
  String get statsNoQuestData => 'No quest data yet';

  @override
  String get statsNoQuestHint => 'Start a quest to see your progress here!';

  @override
  String get statsLast30Days => 'Last 30 Days';

  @override
  String get habitDetailQuestNotFound => 'Quest not found';

  @override
  String get habitDetailComplete => 'complete';

  @override
  String get habitDetailTotalTime => 'Total Time';

  @override
  String get habitDetailCurrentStreak => 'Current Streak';

  @override
  String get habitDetailTarget => 'Target';

  @override
  String habitDetailDaysUnit(int count) {
    return '$count days';
  }

  @override
  String habitDetailHoursUnit(int count) {
    return '$count hours';
  }

  @override
  String checkInBannerSuccess(int coins) {
    return '+$coins coins! Daily check-in complete';
  }

  @override
  String checkInBannerBonus(int bonus) {
    return ' + $bonus milestone bonus!';
  }

  @override
  String get checkInBannerSemantics => 'Daily check-in';

  @override
  String get checkInBannerLoading => 'Loading check-in status...';

  @override
  String checkInBannerPrompt(int coins) {
    return 'Check in for +$coins coins';
  }

  @override
  String checkInBannerSummary(int count, int total, int coins) {
    return '$count/$total days  ·  +$coins today';
  }

  @override
  String commonErrorWithDetail(String error) {
    return 'Error: $error';
  }

  @override
  String get profileFallbackUser => 'User';

  @override
  String get fallbackCatName => 'Cat';

  @override
  String get settingsLanguageTraditionalChinese => 'Traditional Chinese';

  @override
  String get settingsLanguageJapanese => 'Japanese';

  @override
  String get settingsLanguageKorean => 'Korean';

  @override
  String get notifFocusing => 'focusing...';

  @override
  String get notifInProgress => 'Focus session in progress';

  @override
  String get unitMinShort => 'min';

  @override
  String get unitHourShort => 'h';

  @override
  String get weekdayMon => 'M';

  @override
  String get weekdayTue => 'T';

  @override
  String get weekdayWed => 'W';

  @override
  String get weekdayThu => 'T';

  @override
  String get weekdayFri => 'F';

  @override
  String get weekdaySat => 'S';

  @override
  String get weekdaySun => 'S';

  @override
  String get statsTotalSessions => 'Sessions';

  @override
  String get statsTotalHabits => 'Habits';

  @override
  String get statsActiveDays => 'Active days';

  @override
  String get statsWeeklyTrend => 'Weekly trend';

  @override
  String get statsRecentSessions => 'Recent focus';

  @override
  String get statsViewAllHistory => 'View all history';

  @override
  String get historyTitle => 'Focus history';

  @override
  String get historyFilterAll => 'All';

  @override
  String historySessionCount(int count) {
    return '$count sessions';
  }

  @override
  String historyTotalMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get historyNoSessions => 'No focus records yet';

  @override
  String get historyNoSessionsHint => 'Complete a focus session to see it here';

  @override
  String get historyLoadMore => 'Load more';

  @override
  String get sessionCompleted => 'Completed';

  @override
  String get sessionAbandoned => 'Abandoned';

  @override
  String get sessionInterrupted => 'Interrupted';

  @override
  String get sessionCountdown => 'Countdown';

  @override
  String get sessionStopwatch => 'Stopwatch';

  @override
  String get historyDateGroupToday => 'Today';

  @override
  String get historyDateGroupYesterday => 'Yesterday';

  @override
  String get historyLoadError => 'Failed to load history';

  @override
  String get historySelectMonth => 'Select month';

  @override
  String get historyAllMonths => 'All months';

  @override
  String get historyAllHabits => 'All';

  @override
  String get homeTabAchievements => 'Achievements';

  @override
  String get achievementTitle => 'Achievements';

  @override
  String get achievementTabOverview => 'Overview';

  @override
  String get achievementTabQuest => 'Quest';

  @override
  String get achievementTabStreak => 'Streak';

  @override
  String get achievementTabCat => 'Cat';

  @override
  String get achievementTabPersist => 'Persist';

  @override
  String get achievementSummaryTitle => 'Achievement Progress';

  @override
  String achievementUnlockedCount(int count) {
    return '$count unlocked';
  }

  @override
  String achievementTotalCoins(int coins) {
    return '$coins coins earned';
  }

  @override
  String get achievementUnlocked => 'Achievement unlocked!';

  @override
  String get achievementHidden => '???';

  @override
  String get achievementHiddenDesc => 'This is a hidden achievement';

  @override
  String achievementPersistDesc(int days) {
    return 'Accumulate $days check-in days on any quest';
  }

  @override
  String achievementTitleCount(int count) {
    return '$count titles unlocked';
  }

  @override
  String get growthPathTitle => 'Growth Path';

  @override
  String get growthPathKitten => 'Start a new journey';

  @override
  String get growthPathAdolescent => 'Build initial foundation';

  @override
  String get growthPathAdult => 'Skills consolidate';

  @override
  String get growthPathSenior => 'Deep mastery';

  @override
  String get growthPathTip =>
      'Research shows that 20 hours of focused practice is enough to build the foundation of a new skill — Josh Kaufman';

  @override
  String achievementCelebrationCoins(int count) {
    return '+$count coins';
  }

  @override
  String achievementCelebrationTitle(String title) {
    return 'Title earned: $title';
  }

  @override
  String get achievementCelebrationDismiss => 'Awesome!';

  @override
  String get achievementCelebrationSkipAll => 'Skip all';

  @override
  String achievementCelebrationCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String achievementUnlockedAt(String date) {
    return 'Unlocked on $date';
  }

  @override
  String get achievementLocked => 'Not yet unlocked';

  @override
  String achievementRewardCoins(int count) {
    return '+$count coins';
  }

  @override
  String get reminderModeDaily => 'Every day';

  @override
  String get reminderModeWeekdays => 'Weekdays';

  @override
  String get reminderModeMonday => 'Monday';

  @override
  String get reminderModeTuesday => 'Tuesday';

  @override
  String get reminderModeWednesday => 'Wednesday';

  @override
  String get reminderModeThursday => 'Thursday';

  @override
  String get reminderModeFriday => 'Friday';

  @override
  String get reminderModeSaturday => 'Saturday';

  @override
  String get reminderModeSunday => 'Sunday';

  @override
  String get reminderPickerTitle => 'Select reminder time';

  @override
  String get reminderHourUnit => 'h';

  @override
  String get reminderMinuteUnit => 'min';

  @override
  String get reminderAddMore => 'Add reminder';

  @override
  String get reminderMaxReached => 'Up to 5 reminders';

  @override
  String get reminderConfirm => 'Confirm';

  @override
  String reminderNotificationTitle(String catName) {
    return '$catName misses you!';
  }

  @override
  String reminderNotificationBody(String habitName) {
    return 'Time for $habitName — your cat is waiting!';
  }

  @override
  String get deleteAccountDataWarning =>
      'All the following data will be permanently deleted:';

  @override
  String get deleteAccountQuests => 'Quests';

  @override
  String get deleteAccountCats => 'Cats';

  @override
  String get deleteAccountHours => 'Focus hours';

  @override
  String get deleteAccountIrreversible => 'This action is irreversible';

  @override
  String get deleteAccountContinue => 'Continue';

  @override
  String get deleteAccountConfirmTitle => 'Confirm deletion';

  @override
  String get deleteAccountTypeDelete =>
      'Type DELETE to confirm account deletion:';

  @override
  String get deleteAccountAuthCancelled => 'Authentication cancelled';

  @override
  String deleteAccountAuthFailed(String error) {
    return 'Authentication failed: $error';
  }

  @override
  String get deleteAccountProgress => 'Deleting account...';

  @override
  String get deleteAccountSuccess => 'Account deleted';

  @override
  String get drawerGuestLoginSubtitle => 'Sync data and unlock AI features';

  @override
  String get drawerGuestSignIn => 'Sign in';

  @override
  String get drawerMilestones => 'Milestones';

  @override
  String drawerMilestoneFocus(int hours, int minutes) {
    return 'Total focus: ${hours}h ${minutes}m';
  }

  @override
  String drawerMilestoneCats(int count) {
    return 'Cat family: $count';
  }

  @override
  String drawerMilestoneQuests(int count) {
    return 'Active quests: $count';
  }

  @override
  String get drawerMySection => 'My';

  @override
  String get drawerSessionHistory => 'Focus history';

  @override
  String get drawerCheckInCalendar => 'Check-in calendar';

  @override
  String get drawerAccountSection => 'Account';

  @override
  String get settingsResetData => 'Reset all data';

  @override
  String get settingsResetDataTitle => 'Reset all data?';

  @override
  String get settingsResetDataMessage =>
      'This will delete all local data and return to the welcome screen. This cannot be undone.';

  @override
  String get guestUpgradeTitle => 'Protect your data';

  @override
  String get guestUpgradeMessage =>
      'Link an account to back up your progress, unlock AI diary and chat features, and sync across devices.';

  @override
  String get guestUpgradeLinkButton => 'Link account';

  @override
  String get guestUpgradeLater => 'Maybe later';

  @override
  String get loginLinkTagline => 'Link an account to protect your data';

  @override
  String get aiTeaserTitle => 'Cat diary';

  @override
  String aiTeaserPreview(String catName) {
    return 'Today I studied with my human again... $catName feels smarter every day~';
  }

  @override
  String aiTeaserCta(String catName) {
    return 'Link an account to see what $catName wants to say';
  }

  @override
  String get authErrorEmailInUse => 'This email is already registered';

  @override
  String get authErrorWrongPassword => 'Incorrect email or password';

  @override
  String get authErrorUserNotFound => 'No account found with this email';

  @override
  String get authErrorTooManyRequests => 'Too many attempts. Try again later';

  @override
  String get authErrorNetwork => 'Network error. Check your connection';

  @override
  String get authErrorAdminRestricted => 'Sign-in is temporarily restricted';

  @override
  String get authErrorWeakPassword =>
      'Password is too weak. Use at least 6 characters';

  @override
  String get authErrorGeneric => 'Something went wrong. Try again';

  @override
  String get deleteAccountReauthEmail => 'Enter your password to continue';

  @override
  String get deleteAccountReauthPasswordHint => 'Password';

  @override
  String get deleteAccountError => 'Something went wrong. Try again later.';

  @override
  String get deleteAccountPermissionError =>
      'Permission error. Try signing out and back in.';

  @override
  String get deleteAccountNetworkError =>
      'No internet connection. Check your network.';

  @override
  String get deleteAccountRetainedData =>
      'Usage analytics and crash reports cannot be deleted.';
}
