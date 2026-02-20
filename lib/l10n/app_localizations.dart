import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Hachimi'**
  String get appTitle;

  /// No description provided for @homeTabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeTabToday;

  /// No description provided for @homeTabCatHouse.
  ///
  /// In en, this message translates to:
  /// **'CatHouse'**
  String get homeTabCatHouse;

  /// No description provided for @homeTabStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get homeTabStats;

  /// No description provided for @homeTabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get homeTabProfile;

  /// No description provided for @adoptionStepDefineHabit.
  ///
  /// In en, this message translates to:
  /// **'Define Habit'**
  String get adoptionStepDefineHabit;

  /// No description provided for @adoptionStepAdoptCat.
  ///
  /// In en, this message translates to:
  /// **'Adopt Cat'**
  String get adoptionStepAdoptCat;

  /// No description provided for @adoptionStepNameCat.
  ///
  /// In en, this message translates to:
  /// **'Name Cat'**
  String get adoptionStepNameCat;

  /// No description provided for @adoptionHabitName.
  ///
  /// In en, this message translates to:
  /// **'Habit Name'**
  String get adoptionHabitName;

  /// No description provided for @adoptionHabitNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Daily Reading'**
  String get adoptionHabitNameHint;

  /// No description provided for @adoptionDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get adoptionDailyGoal;

  /// No description provided for @adoptionTargetHours.
  ///
  /// In en, this message translates to:
  /// **'Target Hours'**
  String get adoptionTargetHours;

  /// No description provided for @adoptionTargetHoursHint.
  ///
  /// In en, this message translates to:
  /// **'Total hours to complete this habit'**
  String get adoptionTargetHoursHint;

  /// No description provided for @adoptionMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String adoptionMinutes(int count);

  /// No description provided for @adoptionRefreshCat.
  ///
  /// In en, this message translates to:
  /// **'Try another'**
  String get adoptionRefreshCat;

  /// No description provided for @adoptionPersonality.
  ///
  /// In en, this message translates to:
  /// **'Personality: {name}'**
  String adoptionPersonality(String name);

  /// No description provided for @adoptionNameYourCat.
  ///
  /// In en, this message translates to:
  /// **'Name your cat'**
  String get adoptionNameYourCat;

  /// No description provided for @adoptionRandomName.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get adoptionRandomName;

  /// No description provided for @adoptionCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Habit & Adopt'**
  String get adoptionCreate;

  /// No description provided for @adoptionNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get adoptionNext;

  /// No description provided for @adoptionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get adoptionBack;

  /// No description provided for @catHouseTitle.
  ///
  /// In en, this message translates to:
  /// **'CatHouse'**
  String get catHouseTitle;

  /// No description provided for @catHouseEmpty.
  ///
  /// In en, this message translates to:
  /// **'No cats yet! Create a habit to adopt your first cat.'**
  String get catHouseEmpty;

  /// No description provided for @catHouseGrowth.
  ///
  /// In en, this message translates to:
  /// **'{minutes} / {target} min'**
  String catHouseGrowth(int minutes, int target);

  /// No description provided for @catDetailGrowthProgress.
  ///
  /// In en, this message translates to:
  /// **'Growth Progress'**
  String get catDetailGrowthProgress;

  /// No description provided for @catDetailTotalMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min focused'**
  String catDetailTotalMinutes(int minutes);

  /// No description provided for @catDetailTargetMinutes.
  ///
  /// In en, this message translates to:
  /// **'Target: {minutes} min'**
  String catDetailTargetMinutes(int minutes);

  /// No description provided for @catDetailRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get catDetailRename;

  /// No description provided for @catDetailAccessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get catDetailAccessories;

  /// No description provided for @catDetailStartFocus.
  ///
  /// In en, this message translates to:
  /// **'Start Focus'**
  String get catDetailStartFocus;

  /// No description provided for @catDetailBoundHabit.
  ///
  /// In en, this message translates to:
  /// **'Bound Habit'**
  String get catDetailBoundHabit;

  /// No description provided for @catDetailStage.
  ///
  /// In en, this message translates to:
  /// **'Stage: {stage}'**
  String catDetailStage(String stage);

  /// No description provided for @coinBalance.
  ///
  /// In en, this message translates to:
  /// **'{amount} coins'**
  String coinBalance(int amount);

  /// No description provided for @coinCheckInReward.
  ///
  /// In en, this message translates to:
  /// **'+{amount} coins!'**
  String coinCheckInReward(int amount);

  /// No description provided for @coinCheckInTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Check-in'**
  String get coinCheckInTitle;

  /// No description provided for @coinInsufficientBalance.
  ///
  /// In en, this message translates to:
  /// **'Not enough coins'**
  String get coinInsufficientBalance;

  /// No description provided for @shopTitle.
  ///
  /// In en, this message translates to:
  /// **'Accessory Shop'**
  String get shopTitle;

  /// No description provided for @shopPrice.
  ///
  /// In en, this message translates to:
  /// **'{price} coins'**
  String shopPrice(int price);

  /// No description provided for @shopPurchase.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get shopPurchase;

  /// No description provided for @shopEquipped.
  ///
  /// In en, this message translates to:
  /// **'Equipped'**
  String get shopEquipped;

  /// No description provided for @focusCompleteMinutes.
  ///
  /// In en, this message translates to:
  /// **'+{minutes} min'**
  String focusCompleteMinutes(int minutes);

  /// No description provided for @focusCompleteStageUp.
  ///
  /// In en, this message translates to:
  /// **'Stage Up!'**
  String get focusCompleteStageUp;

  /// No description provided for @focusCompleteGreatJob.
  ///
  /// In en, this message translates to:
  /// **'Great job!'**
  String get focusCompleteGreatJob;

  /// No description provided for @focusCompleteDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get focusCompleteDone;

  /// No description provided for @focusCompleteItsOkay.
  ///
  /// In en, this message translates to:
  /// **'It\'s okay!'**
  String get focusCompleteItsOkay;

  /// No description provided for @focusCompleteEvolved.
  ///
  /// In en, this message translates to:
  /// **'{catName} evolved!'**
  String focusCompleteEvolved(String catName);

  /// No description provided for @focusCompleteFocusedFor.
  ///
  /// In en, this message translates to:
  /// **'You focused for {minutes} minutes'**
  String focusCompleteFocusedFor(int minutes);

  /// No description provided for @focusCompleteAbandonedMessage.
  ///
  /// In en, this message translates to:
  /// **'{catName} says: \"We\'ll try again!\"'**
  String focusCompleteAbandonedMessage(String catName);

  /// No description provided for @focusCompleteFocusTime.
  ///
  /// In en, this message translates to:
  /// **'Focus time'**
  String get focusCompleteFocusTime;

  /// No description provided for @focusCompleteCoinsEarned.
  ///
  /// In en, this message translates to:
  /// **'Coins earned'**
  String get focusCompleteCoinsEarned;

  /// No description provided for @focusCompleteBaseXp.
  ///
  /// In en, this message translates to:
  /// **'Base XP'**
  String get focusCompleteBaseXp;

  /// No description provided for @focusCompleteStreakBonus.
  ///
  /// In en, this message translates to:
  /// **'Streak bonus'**
  String get focusCompleteStreakBonus;

  /// No description provided for @focusCompleteMilestoneBonus.
  ///
  /// In en, this message translates to:
  /// **'Milestone bonus'**
  String get focusCompleteMilestoneBonus;

  /// No description provided for @focusCompleteFullHouseBonus.
  ///
  /// In en, this message translates to:
  /// **'Full house bonus'**
  String get focusCompleteFullHouseBonus;

  /// No description provided for @focusCompleteTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get focusCompleteTotal;

  /// No description provided for @focusCompleteEvolvedTo.
  ///
  /// In en, this message translates to:
  /// **'Evolved to {stage}!'**
  String focusCompleteEvolvedTo(String stage);

  /// No description provided for @focusCompleteYourCat.
  ///
  /// In en, this message translates to:
  /// **'Your cat'**
  String get focusCompleteYourCat;

  /// No description provided for @focusCompleteDiaryWriting.
  ///
  /// In en, this message translates to:
  /// **'Writing diary...'**
  String get focusCompleteDiaryWriting;

  /// No description provided for @focusCompleteDiaryWritten.
  ///
  /// In en, this message translates to:
  /// **'Diary written!'**
  String get focusCompleteDiaryWritten;

  /// No description provided for @focusCompleteNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Quest complete!'**
  String get focusCompleteNotifTitle;

  /// No description provided for @focusCompleteNotifBody.
  ///
  /// In en, this message translates to:
  /// **'{catName} earned +{xp} XP from {minutes}min of focus'**
  String focusCompleteNotifBody(String catName, int xp, int minutes);

  /// No description provided for @stageKitten.
  ///
  /// In en, this message translates to:
  /// **'Kitten'**
  String get stageKitten;

  /// No description provided for @stageAdolescent.
  ///
  /// In en, this message translates to:
  /// **'Adolescent'**
  String get stageAdolescent;

  /// No description provided for @stageAdult.
  ///
  /// In en, this message translates to:
  /// **'Adult'**
  String get stageAdult;

  /// No description provided for @stageSenior.
  ///
  /// In en, this message translates to:
  /// **'Senior'**
  String get stageSenior;

  /// No description provided for @migrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Update Required'**
  String get migrationTitle;

  /// No description provided for @migrationMessage.
  ///
  /// In en, this message translates to:
  /// **'Hachimi has been updated with a new pixel cat system! Your old cat data is no longer compatible. Please reset to start fresh with the new experience.'**
  String get migrationMessage;

  /// No description provided for @migrationResetButton.
  ///
  /// In en, this message translates to:
  /// **'Reset & Start Fresh'**
  String get migrationResetButton;

  /// No description provided for @sessionResumeTitle.
  ///
  /// In en, this message translates to:
  /// **'Resume session?'**
  String get sessionResumeTitle;

  /// No description provided for @sessionResumeMessage.
  ///
  /// In en, this message translates to:
  /// **'You had an active focus session ({habitName}, {elapsed}). Resume?'**
  String sessionResumeMessage(String habitName, String elapsed);

  /// No description provided for @sessionResumeButton.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get sessionResumeButton;

  /// No description provided for @sessionDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get sessionDiscard;

  /// No description provided for @todaySummaryMinutes.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todaySummaryMinutes;

  /// No description provided for @todaySummaryTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get todaySummaryTotal;

  /// No description provided for @todaySummaryCats.
  ///
  /// In en, this message translates to:
  /// **'Cats'**
  String get todaySummaryCats;

  /// No description provided for @todayYourQuests.
  ///
  /// In en, this message translates to:
  /// **'Your Quests'**
  String get todayYourQuests;

  /// No description provided for @todayNoQuests.
  ///
  /// In en, this message translates to:
  /// **'No quests yet'**
  String get todayNoQuests;

  /// No description provided for @todayNoQuestsHint.
  ///
  /// In en, this message translates to:
  /// **'Tap + to start a quest and adopt a cat!'**
  String get todayNoQuestsHint;

  /// No description provided for @todayFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get todayFocus;

  /// No description provided for @todayDeleteQuestTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete quest?'**
  String get todayDeleteQuestTitle;

  /// No description provided for @todayDeleteQuestMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? The cat will be graduated to your album.'**
  String todayDeleteQuestMessage(String name);

  /// No description provided for @todayQuestCompleted.
  ///
  /// In en, this message translates to:
  /// **'{name} completed'**
  String todayQuestCompleted(String name);

  /// No description provided for @todayFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load quests'**
  String get todayFailedToLoad;

  /// No description provided for @todayMinToday.
  ///
  /// In en, this message translates to:
  /// **'{count}min today'**
  String todayMinToday(int count);

  /// No description provided for @todayGoalMinPerDay.
  ///
  /// In en, this message translates to:
  /// **'Goal: {count}min/day'**
  String todayGoalMinPerDay(int count);

  /// No description provided for @todayFeaturedCat.
  ///
  /// In en, this message translates to:
  /// **'Featured Cat'**
  String get todayFeaturedCat;

  /// No description provided for @todayAddHabit.
  ///
  /// In en, this message translates to:
  /// **'Add Habit'**
  String get todayAddHabit;

  /// No description provided for @todayNoHabits.
  ///
  /// In en, this message translates to:
  /// **'Create your first habit to get started!'**
  String get todayNoHabits;

  /// No description provided for @todayNewQuest.
  ///
  /// In en, this message translates to:
  /// **'New quest'**
  String get todayNewQuest;

  /// No description provided for @todayStartFocus.
  ///
  /// In en, this message translates to:
  /// **'Start focus'**
  String get todayStartFocus;

  /// No description provided for @timerStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get timerStart;

  /// No description provided for @timerPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get timerPause;

  /// No description provided for @timerResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get timerResume;

  /// No description provided for @timerDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get timerDone;

  /// No description provided for @timerGiveUp.
  ///
  /// In en, this message translates to:
  /// **'Give Up'**
  String get timerGiveUp;

  /// No description provided for @timerRemaining.
  ///
  /// In en, this message translates to:
  /// **'remaining'**
  String get timerRemaining;

  /// No description provided for @timerElapsed.
  ///
  /// In en, this message translates to:
  /// **'elapsed'**
  String get timerElapsed;

  /// No description provided for @timerPaused.
  ///
  /// In en, this message translates to:
  /// **'PAUSED'**
  String get timerPaused;

  /// No description provided for @timerQuestNotFound.
  ///
  /// In en, this message translates to:
  /// **'Quest not found'**
  String get timerQuestNotFound;

  /// No description provided for @timerNotificationBanner.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications to see timer progress when the app is in the background'**
  String get timerNotificationBanner;

  /// No description provided for @timerNotificationDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get timerNotificationDismiss;

  /// No description provided for @timerNotificationEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get timerNotificationEnable;

  /// No description provided for @timerGraceBack.
  ///
  /// In en, this message translates to:
  /// **'Back ({seconds}s)'**
  String timerGraceBack(int seconds);

  /// No description provided for @giveUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Give up?'**
  String get giveUpTitle;

  /// No description provided for @giveUpMessage.
  ///
  /// In en, this message translates to:
  /// **'If you focused for at least 5 minutes, the time still counts towards your cat\'s growth. Your cat will understand!'**
  String get giveUpMessage;

  /// No description provided for @giveUpKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep Going'**
  String get giveUpKeepGoing;

  /// No description provided for @giveUpConfirm.
  ///
  /// In en, this message translates to:
  /// **'Give Up'**
  String get giveUpConfirm;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsNotificationFocusReminders.
  ///
  /// In en, this message translates to:
  /// **'Focus Reminders'**
  String get settingsNotificationFocusReminders;

  /// No description provided for @settingsNotificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive daily reminders to stay on track'**
  String get settingsNotificationSubtitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get settingsLanguageChinese;

  /// No description provided for @settingsThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get settingsThemeMode;

  /// No description provided for @settingsThemeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeModeSystem;

  /// No description provided for @settingsThemeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeModeLight;

  /// No description provided for @settingsThemeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeModeDark;

  /// No description provided for @settingsMaterialYou.
  ///
  /// In en, this message translates to:
  /// **'Material You'**
  String get settingsMaterialYou;

  /// No description provided for @settingsMaterialYouSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use wallpaper colors for theme'**
  String get settingsMaterialYouSubtitle;

  /// No description provided for @settingsThemeColor.
  ///
  /// In en, this message translates to:
  /// **'Theme Color'**
  String get settingsThemeColor;

  /// No description provided for @settingsAiModel.
  ///
  /// In en, this message translates to:
  /// **'AI Model'**
  String get settingsAiModel;

  /// No description provided for @settingsAiFeatures.
  ///
  /// In en, this message translates to:
  /// **'AI Features'**
  String get settingsAiFeatures;

  /// No description provided for @settingsAiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable cat diary and chat powered by on-device AI'**
  String get settingsAiSubtitle;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsPixelCatSprites.
  ///
  /// In en, this message translates to:
  /// **'Pixel Cat Sprites'**
  String get settingsPixelCatSprites;

  /// No description provided for @settingsLicenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get settingsLicenses;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsDownloadModel.
  ///
  /// In en, this message translates to:
  /// **'Download Model (1.2 GB)'**
  String get settingsDownloadModel;

  /// No description provided for @settingsDeleteModel.
  ///
  /// In en, this message translates to:
  /// **'Delete Model'**
  String get settingsDeleteModel;

  /// No description provided for @settingsDeleteModelTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete model?'**
  String get settingsDeleteModelTitle;

  /// No description provided for @settingsDeleteModelMessage.
  ///
  /// In en, this message translates to:
  /// **'This will delete the downloaded AI model (1.2 GB). You can download it again later.'**
  String get settingsDeleteModelMessage;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logoutTitle;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutMessage;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and all your data. This action cannot be undone.'**
  String get deleteAccountMessage;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone'**
  String get deleteAccountWarning;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Your Journey'**
  String get profileYourJourney;

  /// No description provided for @profileTotalFocus.
  ///
  /// In en, this message translates to:
  /// **'Total Focus'**
  String get profileTotalFocus;

  /// No description provided for @profileTotalCats.
  ///
  /// In en, this message translates to:
  /// **'Total Cats'**
  String get profileTotalCats;

  /// No description provided for @profileBestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best Streak'**
  String get profileBestStreak;

  /// No description provided for @profileCatAlbum.
  ///
  /// In en, this message translates to:
  /// **'Cat Album'**
  String get profileCatAlbum;

  /// No description provided for @profileCatAlbumCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cats'**
  String profileCatAlbumCount(int count);

  /// No description provided for @profileSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all {count} cats'**
  String profileSeeAll(int count);

  /// No description provided for @profileGraduated.
  ///
  /// In en, this message translates to:
  /// **'Graduated'**
  String get profileGraduated;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @habitDetailStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get habitDetailStreak;

  /// No description provided for @habitDetailBestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get habitDetailBestStreak;

  /// No description provided for @habitDetailTotalMinutes.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get habitDetailTotalMinutes;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get commonDismiss;

  /// No description provided for @commonEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get commonEnable;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonError;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get commonResume;

  /// No description provided for @commonPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get commonPause;

  /// No description provided for @commonLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get commonLogOut;

  /// No description provided for @commonDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get commonDeleteAccount;

  /// No description provided for @testChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Test AI Model'**
  String get testChatTitle;

  /// No description provided for @testChatLoadingModel.
  ///
  /// In en, this message translates to:
  /// **'Loading model...'**
  String get testChatLoadingModel;

  /// No description provided for @testChatModelLoaded.
  ///
  /// In en, this message translates to:
  /// **'Model loaded'**
  String get testChatModelLoaded;

  /// No description provided for @testChatErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading model'**
  String get testChatErrorLoading;

  /// No description provided for @testChatCouldNotLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load model'**
  String get testChatCouldNotLoad;

  /// No description provided for @testChatFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load model'**
  String get testChatFailedToLoad;

  /// No description provided for @testChatUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get testChatUnknownError;

  /// No description provided for @testChatModelReady.
  ///
  /// In en, this message translates to:
  /// **'Model ready'**
  String get testChatModelReady;

  /// No description provided for @testChatSendToTest.
  ///
  /// In en, this message translates to:
  /// **'Send a message to test the AI model.'**
  String get testChatSendToTest;

  /// No description provided for @testChatGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get testChatGenerating;

  /// No description provided for @testChatTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get testChatTypeMessage;

  /// No description provided for @settingsAiPrivacyBadge.
  ///
  /// In en, this message translates to:
  /// **'Powered by on-device AI — all processing runs locally'**
  String get settingsAiPrivacyBadge;

  /// No description provided for @settingsAiWhatYouGet.
  ///
  /// In en, this message translates to:
  /// **'What you get:'**
  String get settingsAiWhatYouGet;

  /// No description provided for @settingsAiFeatureDiary.
  ///
  /// In en, this message translates to:
  /// **'Hachimi Diary — Your cat writes daily diary entries'**
  String get settingsAiFeatureDiary;

  /// No description provided for @settingsAiFeatureChat.
  ///
  /// In en, this message translates to:
  /// **'Cat Chat — Have conversations with your cat'**
  String get settingsAiFeatureChat;

  /// No description provided for @settingsRedownload.
  ///
  /// In en, this message translates to:
  /// **'Redownload'**
  String get settingsRedownload;

  /// No description provided for @settingsTestModel.
  ///
  /// In en, this message translates to:
  /// **'Test Model'**
  String get settingsTestModel;

  /// No description provided for @settingsStatusDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get settingsStatusDownloading;

  /// No description provided for @settingsStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get settingsStatusReady;

  /// No description provided for @settingsStatusError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get settingsStatusError;

  /// No description provided for @settingsStatusLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get settingsStatusLoading;

  /// No description provided for @settingsStatusNotDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Not downloaded'**
  String get settingsStatusNotDownloaded;

  /// No description provided for @settingsStatusDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get settingsStatusDisabled;

  /// No description provided for @catDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Cat not found'**
  String get catDetailNotFound;

  /// No description provided for @catDetailChatTooltip.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get catDetailChatTooltip;

  /// No description provided for @catDetailRenameTooltip.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get catDetailRenameTooltip;

  /// No description provided for @catDetailGrowthTitle.
  ///
  /// In en, this message translates to:
  /// **'Growth Progress'**
  String get catDetailGrowthTitle;

  /// No description provided for @catDetailTarget.
  ///
  /// In en, this message translates to:
  /// **'Target: {hours}h'**
  String catDetailTarget(int hours);

  /// No description provided for @catDetailRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename Cat'**
  String get catDetailRenameTitle;

  /// No description provided for @catDetailNewName.
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get catDetailNewName;

  /// No description provided for @catDetailRenamed.
  ///
  /// In en, this message translates to:
  /// **'Cat renamed!'**
  String get catDetailRenamed;

  /// No description provided for @catDetailQuestBadge.
  ///
  /// In en, this message translates to:
  /// **'Quest'**
  String get catDetailQuestBadge;

  /// No description provided for @catDetailEditQuest.
  ///
  /// In en, this message translates to:
  /// **'Edit quest'**
  String get catDetailEditQuest;

  /// No description provided for @catDetailDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get catDetailDailyGoal;

  /// No description provided for @catDetailTodaysFocus.
  ///
  /// In en, this message translates to:
  /// **'Today\'s focus'**
  String get catDetailTodaysFocus;

  /// No description provided for @catDetailTotalFocus.
  ///
  /// In en, this message translates to:
  /// **'Total focus'**
  String get catDetailTotalFocus;

  /// No description provided for @catDetailTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get catDetailTargetLabel;

  /// No description provided for @catDetailCompletion.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get catDetailCompletion;

  /// No description provided for @catDetailCurrentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get catDetailCurrentStreak;

  /// No description provided for @catDetailBestStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get catDetailBestStreakLabel;

  /// No description provided for @catDetailAvgDaily.
  ///
  /// In en, this message translates to:
  /// **'Avg daily'**
  String get catDetailAvgDaily;

  /// No description provided for @catDetailDaysActive.
  ///
  /// In en, this message translates to:
  /// **'Days active'**
  String get catDetailDaysActive;

  /// No description provided for @catDetailEditQuestTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Quest'**
  String get catDetailEditQuestTitle;

  /// No description provided for @catDetailIconEmoji.
  ///
  /// In en, this message translates to:
  /// **'Icon (emoji)'**
  String get catDetailIconEmoji;

  /// No description provided for @catDetailQuestName.
  ///
  /// In en, this message translates to:
  /// **'Quest name'**
  String get catDetailQuestName;

  /// No description provided for @catDetailDailyGoalMinutes.
  ///
  /// In en, this message translates to:
  /// **'Daily goal (minutes)'**
  String get catDetailDailyGoalMinutes;

  /// No description provided for @catDetailTargetTotalHours.
  ///
  /// In en, this message translates to:
  /// **'Target total (hours)'**
  String get catDetailTargetTotalHours;

  /// No description provided for @catDetailQuestUpdated.
  ///
  /// In en, this message translates to:
  /// **'Quest updated!'**
  String get catDetailQuestUpdated;

  /// No description provided for @catDetailDailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get catDetailDailyReminder;

  /// No description provided for @catDetailEveryDay.
  ///
  /// In en, this message translates to:
  /// **'{time} every day'**
  String catDetailEveryDay(String time);

  /// No description provided for @catDetailNoReminder.
  ///
  /// In en, this message translates to:
  /// **'No reminder set'**
  String get catDetailNoReminder;

  /// No description provided for @catDetailChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get catDetailChange;

  /// No description provided for @catDetailRemoveReminder.
  ///
  /// In en, this message translates to:
  /// **'Remove reminder'**
  String get catDetailRemoveReminder;

  /// No description provided for @catDetailSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get catDetailSet;

  /// No description provided for @catDetailReminderSet.
  ///
  /// In en, this message translates to:
  /// **'Reminder set for {time}'**
  String catDetailReminderSet(String time);

  /// No description provided for @catDetailReminderRemoved.
  ///
  /// In en, this message translates to:
  /// **'Reminder removed'**
  String get catDetailReminderRemoved;

  /// No description provided for @catDetailDiaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Hachimi Diary'**
  String get catDetailDiaryTitle;

  /// No description provided for @catDetailDiaryLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get catDetailDiaryLoading;

  /// No description provided for @catDetailDiaryError.
  ///
  /// In en, this message translates to:
  /// **'Could not load diary'**
  String get catDetailDiaryError;

  /// No description provided for @catDetailDiaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No diary entry today yet. Complete a focus session!'**
  String get catDetailDiaryEmpty;

  /// No description provided for @catDetailChatWith.
  ///
  /// In en, this message translates to:
  /// **'Chat with {name}'**
  String catDetailChatWith(String name);

  /// No description provided for @catDetailChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Have a conversation with your cat'**
  String get catDetailChatSubtitle;

  /// No description provided for @catDetailActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get catDetailActivity;

  /// No description provided for @catDetailActivityError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load activity data'**
  String get catDetailActivityError;

  /// No description provided for @catDetailAccessoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get catDetailAccessoriesTitle;

  /// No description provided for @catDetailEquipped.
  ///
  /// In en, this message translates to:
  /// **'Equipped: '**
  String get catDetailEquipped;

  /// No description provided for @catDetailNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get catDetailNone;

  /// No description provided for @catDetailUnequip.
  ///
  /// In en, this message translates to:
  /// **'Unequip'**
  String get catDetailUnequip;

  /// No description provided for @catDetailFromInventory.
  ///
  /// In en, this message translates to:
  /// **'From Inventory ({count})'**
  String catDetailFromInventory(int count);

  /// No description provided for @catDetailNoAccessories.
  ///
  /// In en, this message translates to:
  /// **'No accessories yet. Visit the shop!'**
  String get catDetailNoAccessories;

  /// No description provided for @catDetailEquippedItem.
  ///
  /// In en, this message translates to:
  /// **'Equipped {name}'**
  String catDetailEquippedItem(String name);

  /// No description provided for @catDetailUnequipped.
  ///
  /// In en, this message translates to:
  /// **'Unequipped'**
  String get catDetailUnequipped;

  /// No description provided for @catDetailAbout.
  ///
  /// In en, this message translates to:
  /// **'About {name}'**
  String catDetailAbout(String name);

  /// No description provided for @catDetailAppearanceDetails.
  ///
  /// In en, this message translates to:
  /// **'Appearance details'**
  String get catDetailAppearanceDetails;

  /// No description provided for @catDetailStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get catDetailStatus;

  /// No description provided for @catDetailAdopted.
  ///
  /// In en, this message translates to:
  /// **'Adopted'**
  String get catDetailAdopted;

  /// No description provided for @catDetailFurPattern.
  ///
  /// In en, this message translates to:
  /// **'Fur pattern'**
  String get catDetailFurPattern;

  /// No description provided for @catDetailFurColor.
  ///
  /// In en, this message translates to:
  /// **'Fur color'**
  String get catDetailFurColor;

  /// No description provided for @catDetailFurLength.
  ///
  /// In en, this message translates to:
  /// **'Fur length'**
  String get catDetailFurLength;

  /// No description provided for @catDetailEyes.
  ///
  /// In en, this message translates to:
  /// **'Eyes'**
  String get catDetailEyes;

  /// No description provided for @catDetailWhitePatches.
  ///
  /// In en, this message translates to:
  /// **'White patches'**
  String get catDetailWhitePatches;

  /// No description provided for @catDetailPatchesTint.
  ///
  /// In en, this message translates to:
  /// **'Patches tint'**
  String get catDetailPatchesTint;

  /// No description provided for @catDetailTint.
  ///
  /// In en, this message translates to:
  /// **'Tint'**
  String get catDetailTint;

  /// No description provided for @catDetailPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get catDetailPoints;

  /// No description provided for @catDetailVitiligo.
  ///
  /// In en, this message translates to:
  /// **'Vitiligo'**
  String get catDetailVitiligo;

  /// No description provided for @catDetailTortoiseshell.
  ///
  /// In en, this message translates to:
  /// **'Tortoiseshell'**
  String get catDetailTortoiseshell;

  /// No description provided for @catDetailTortiePattern.
  ///
  /// In en, this message translates to:
  /// **'Tortie pattern'**
  String get catDetailTortiePattern;

  /// No description provided for @catDetailTortieColor.
  ///
  /// In en, this message translates to:
  /// **'Tortie color'**
  String get catDetailTortieColor;

  /// No description provided for @catDetailSkin.
  ///
  /// In en, this message translates to:
  /// **'Skin'**
  String get catDetailSkin;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'zh':
      return SZh();
  }

  throw FlutterError(
      'S.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
