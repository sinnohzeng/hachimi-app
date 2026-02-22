import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
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
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
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

  /// No description provided for @adoptionCatNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Cat name'**
  String get adoptionCatNameLabel;

  /// No description provided for @adoptionCatNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mochi'**
  String get adoptionCatNameHint;

  /// No description provided for @adoptionRandomNameTooltip.
  ///
  /// In en, this message translates to:
  /// **'Random name'**
  String get adoptionRandomNameTooltip;

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

  /// No description provided for @settingsThemeColor.
  ///
  /// In en, this message translates to:
  /// **'Theme Color'**
  String get settingsThemeColor;

  /// No description provided for @settingsThemeColorDynamic.
  ///
  /// In en, this message translates to:
  /// **'Dynamic'**
  String get settingsThemeColorDynamic;

  /// No description provided for @settingsThemeColorDynamicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use wallpaper colors'**
  String get settingsThemeColorDynamicSubtitle;

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

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

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

  /// No description provided for @testChatFileCorrupted.
  ///
  /// In en, this message translates to:
  /// **'Model file is corrupted or incomplete. Please re-download.'**
  String get testChatFileCorrupted;

  /// No description provided for @testChatRedownload.
  ///
  /// In en, this message translates to:
  /// **'Re-download'**
  String get testChatRedownload;

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

  /// No description provided for @offlineMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline — changes will sync when reconnected'**
  String get offlineMessage;

  /// No description provided for @offlineModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Offline mode'**
  String get offlineModeLabel;

  /// No description provided for @habitTodayMinutes.
  ///
  /// In en, this message translates to:
  /// **'Today: {count}min'**
  String habitTodayMinutes(int count);

  /// No description provided for @habitDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete habit'**
  String get habitDeleteTooltip;

  /// No description provided for @heatmapActiveDays.
  ///
  /// In en, this message translates to:
  /// **'Active days'**
  String get heatmapActiveDays;

  /// No description provided for @heatmapTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get heatmapTotal;

  /// No description provided for @heatmapRate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get heatmapRate;

  /// No description provided for @heatmapLess.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get heatmapLess;

  /// No description provided for @heatmapMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get heatmapMore;

  /// No description provided for @accessoryEquipped.
  ///
  /// In en, this message translates to:
  /// **'Equipped'**
  String get accessoryEquipped;

  /// No description provided for @accessoryOwned.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get accessoryOwned;

  /// No description provided for @pickerMinUnit.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get pickerMinUnit;

  /// No description provided for @settingsBackgroundAnimation.
  ///
  /// In en, this message translates to:
  /// **'Animated backgrounds'**
  String get settingsBackgroundAnimation;

  /// No description provided for @settingsBackgroundAnimationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mesh gradient and floating particles'**
  String get settingsBackgroundAnimationSubtitle;

  /// No description provided for @personalityLazy.
  ///
  /// In en, this message translates to:
  /// **'Lazy'**
  String get personalityLazy;

  /// No description provided for @personalityCurious.
  ///
  /// In en, this message translates to:
  /// **'Curious'**
  String get personalityCurious;

  /// No description provided for @personalityPlayful.
  ///
  /// In en, this message translates to:
  /// **'Playful'**
  String get personalityPlayful;

  /// No description provided for @personalityShy.
  ///
  /// In en, this message translates to:
  /// **'Shy'**
  String get personalityShy;

  /// No description provided for @personalityBrave.
  ///
  /// In en, this message translates to:
  /// **'Brave'**
  String get personalityBrave;

  /// No description provided for @personalityClingy.
  ///
  /// In en, this message translates to:
  /// **'Clingy'**
  String get personalityClingy;

  /// No description provided for @personalityFlavorLazy.
  ///
  /// In en, this message translates to:
  /// **'Will nap 23 hours a day. The other hour? Also napping.'**
  String get personalityFlavorLazy;

  /// No description provided for @personalityFlavorCurious.
  ///
  /// In en, this message translates to:
  /// **'Already sniffing everything in sight!'**
  String get personalityFlavorCurious;

  /// No description provided for @personalityFlavorPlayful.
  ///
  /// In en, this message translates to:
  /// **'Can\'t stop chasing butterflies!'**
  String get personalityFlavorPlayful;

  /// No description provided for @personalityFlavorShy.
  ///
  /// In en, this message translates to:
  /// **'Took 3 minutes to peek out of the box...'**
  String get personalityFlavorShy;

  /// No description provided for @personalityFlavorBrave.
  ///
  /// In en, this message translates to:
  /// **'Jumped out of the box before it was even opened!'**
  String get personalityFlavorBrave;

  /// No description provided for @personalityFlavorClingy.
  ///
  /// In en, this message translates to:
  /// **'Immediately started purring and won\'t let go.'**
  String get personalityFlavorClingy;

  /// No description provided for @moodHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get moodHappy;

  /// No description provided for @moodNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get moodNeutral;

  /// No description provided for @moodLonely.
  ///
  /// In en, this message translates to:
  /// **'Lonely'**
  String get moodLonely;

  /// No description provided for @moodMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing You'**
  String get moodMissing;

  /// No description provided for @moodMsgLazyHappy.
  ///
  /// In en, this message translates to:
  /// **'Nya~! Time for a well-deserved nap...'**
  String get moodMsgLazyHappy;

  /// No description provided for @moodMsgCuriousHappy.
  ///
  /// In en, this message translates to:
  /// **'What are we exploring today?'**
  String get moodMsgCuriousHappy;

  /// No description provided for @moodMsgPlayfulHappy.
  ///
  /// In en, this message translates to:
  /// **'Nya~! Ready to work!'**
  String get moodMsgPlayfulHappy;

  /// No description provided for @moodMsgShyHappy.
  ///
  /// In en, this message translates to:
  /// **'...I-I\'m glad you\'re here.'**
  String get moodMsgShyHappy;

  /// No description provided for @moodMsgBraveHappy.
  ///
  /// In en, this message translates to:
  /// **'Let\'s conquer today together!'**
  String get moodMsgBraveHappy;

  /// No description provided for @moodMsgClingyHappy.
  ///
  /// In en, this message translates to:
  /// **'Yay! You\'re back! Don\'t leave again!'**
  String get moodMsgClingyHappy;

  /// No description provided for @moodMsgLazyNeutral.
  ///
  /// In en, this message translates to:
  /// **'*yawn* Oh, hey...'**
  String get moodMsgLazyNeutral;

  /// No description provided for @moodMsgCuriousNeutral.
  ///
  /// In en, this message translates to:
  /// **'Hmm, what\'s that over there?'**
  String get moodMsgCuriousNeutral;

  /// No description provided for @moodMsgPlayfulNeutral.
  ///
  /// In en, this message translates to:
  /// **'Wanna play? Maybe later...'**
  String get moodMsgPlayfulNeutral;

  /// No description provided for @moodMsgShyNeutral.
  ///
  /// In en, this message translates to:
  /// **'*peeks out slowly*'**
  String get moodMsgShyNeutral;

  /// No description provided for @moodMsgBraveNeutral.
  ///
  /// In en, this message translates to:
  /// **'Standing guard, as always.'**
  String get moodMsgBraveNeutral;

  /// No description provided for @moodMsgClingyNeutral.
  ///
  /// In en, this message translates to:
  /// **'I\'ve been waiting for you...'**
  String get moodMsgClingyNeutral;

  /// No description provided for @moodMsgLazyLonely.
  ///
  /// In en, this message translates to:
  /// **'Even napping feels lonely...'**
  String get moodMsgLazyLonely;

  /// No description provided for @moodMsgCuriousLonely.
  ///
  /// In en, this message translates to:
  /// **'I wonder when you\'ll come back...'**
  String get moodMsgCuriousLonely;

  /// No description provided for @moodMsgPlayfulLonely.
  ///
  /// In en, this message translates to:
  /// **'The toys aren\'t fun without you...'**
  String get moodMsgPlayfulLonely;

  /// No description provided for @moodMsgShyLonely.
  ///
  /// In en, this message translates to:
  /// **'*curls up quietly*'**
  String get moodMsgShyLonely;

  /// No description provided for @moodMsgBraveLonely.
  ///
  /// In en, this message translates to:
  /// **'I\'ll keep waiting. I\'m brave.'**
  String get moodMsgBraveLonely;

  /// No description provided for @moodMsgClingyLonely.
  ///
  /// In en, this message translates to:
  /// **'Where did you go... 🥺'**
  String get moodMsgClingyLonely;

  /// No description provided for @moodMsgLazyMissing.
  ///
  /// In en, this message translates to:
  /// **'*opens one eye hopefully*'**
  String get moodMsgLazyMissing;

  /// No description provided for @moodMsgCuriousMissing.
  ///
  /// In en, this message translates to:
  /// **'Did something happen...?'**
  String get moodMsgCuriousMissing;

  /// No description provided for @moodMsgPlayfulMissing.
  ///
  /// In en, this message translates to:
  /// **'I saved your favorite toy...'**
  String get moodMsgPlayfulMissing;

  /// No description provided for @moodMsgShyMissing.
  ///
  /// In en, this message translates to:
  /// **'*hiding, but watching the door*'**
  String get moodMsgShyMissing;

  /// No description provided for @moodMsgBraveMissing.
  ///
  /// In en, this message translates to:
  /// **'I know you\'ll come back. I believe.'**
  String get moodMsgBraveMissing;

  /// No description provided for @moodMsgClingyMissing.
  ///
  /// In en, this message translates to:
  /// **'I miss you so much... please come back.'**
  String get moodMsgClingyMissing;

  /// No description provided for @peltTypeTabby.
  ///
  /// In en, this message translates to:
  /// **'Classic tabby stripes'**
  String get peltTypeTabby;

  /// No description provided for @peltTypeTicked.
  ///
  /// In en, this message translates to:
  /// **'Ticked agouti pattern'**
  String get peltTypeTicked;

  /// No description provided for @peltTypeMackerel.
  ///
  /// In en, this message translates to:
  /// **'Mackerel tabby'**
  String get peltTypeMackerel;

  /// No description provided for @peltTypeClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic swirl pattern'**
  String get peltTypeClassic;

  /// No description provided for @peltTypeSokoke.
  ///
  /// In en, this message translates to:
  /// **'Sokoke marble pattern'**
  String get peltTypeSokoke;

  /// No description provided for @peltTypeAgouti.
  ///
  /// In en, this message translates to:
  /// **'Agouti ticked'**
  String get peltTypeAgouti;

  /// No description provided for @peltTypeSpeckled.
  ///
  /// In en, this message translates to:
  /// **'Speckled coat'**
  String get peltTypeSpeckled;

  /// No description provided for @peltTypeRosette.
  ///
  /// In en, this message translates to:
  /// **'Rosette spotted'**
  String get peltTypeRosette;

  /// No description provided for @peltTypeSingleColour.
  ///
  /// In en, this message translates to:
  /// **'Solid color'**
  String get peltTypeSingleColour;

  /// No description provided for @peltTypeTwoColour.
  ///
  /// In en, this message translates to:
  /// **'Two-tone'**
  String get peltTypeTwoColour;

  /// No description provided for @peltTypeSmoke.
  ///
  /// In en, this message translates to:
  /// **'Smoke shading'**
  String get peltTypeSmoke;

  /// No description provided for @peltTypeSinglestripe.
  ///
  /// In en, this message translates to:
  /// **'Single stripe'**
  String get peltTypeSinglestripe;

  /// No description provided for @peltTypeBengal.
  ///
  /// In en, this message translates to:
  /// **'Bengal pattern'**
  String get peltTypeBengal;

  /// No description provided for @peltTypeMarbled.
  ///
  /// In en, this message translates to:
  /// **'Marbled pattern'**
  String get peltTypeMarbled;

  /// No description provided for @peltTypeMasked.
  ///
  /// In en, this message translates to:
  /// **'Masked face'**
  String get peltTypeMasked;

  /// No description provided for @peltColorWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get peltColorWhite;

  /// No description provided for @peltColorPaleGrey.
  ///
  /// In en, this message translates to:
  /// **'Pale grey'**
  String get peltColorPaleGrey;

  /// No description provided for @peltColorSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get peltColorSilver;

  /// No description provided for @peltColorGrey.
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get peltColorGrey;

  /// No description provided for @peltColorDarkGrey.
  ///
  /// In en, this message translates to:
  /// **'Dark grey'**
  String get peltColorDarkGrey;

  /// No description provided for @peltColorGhost.
  ///
  /// In en, this message translates to:
  /// **'Ghost grey'**
  String get peltColorGhost;

  /// No description provided for @peltColorBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get peltColorBlack;

  /// No description provided for @peltColorCream.
  ///
  /// In en, this message translates to:
  /// **'Cream'**
  String get peltColorCream;

  /// No description provided for @peltColorPaleGinger.
  ///
  /// In en, this message translates to:
  /// **'Pale ginger'**
  String get peltColorPaleGinger;

  /// No description provided for @peltColorGolden.
  ///
  /// In en, this message translates to:
  /// **'Golden'**
  String get peltColorGolden;

  /// No description provided for @peltColorGinger.
  ///
  /// In en, this message translates to:
  /// **'Ginger'**
  String get peltColorGinger;

  /// No description provided for @peltColorDarkGinger.
  ///
  /// In en, this message translates to:
  /// **'Dark ginger'**
  String get peltColorDarkGinger;

  /// No description provided for @peltColorSienna.
  ///
  /// In en, this message translates to:
  /// **'Sienna'**
  String get peltColorSienna;

  /// No description provided for @peltColorLightBrown.
  ///
  /// In en, this message translates to:
  /// **'Light brown'**
  String get peltColorLightBrown;

  /// No description provided for @peltColorLilac.
  ///
  /// In en, this message translates to:
  /// **'Lilac'**
  String get peltColorLilac;

  /// No description provided for @peltColorBrown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get peltColorBrown;

  /// No description provided for @peltColorGoldenBrown.
  ///
  /// In en, this message translates to:
  /// **'Golden brown'**
  String get peltColorGoldenBrown;

  /// No description provided for @peltColorDarkBrown.
  ///
  /// In en, this message translates to:
  /// **'Dark brown'**
  String get peltColorDarkBrown;

  /// No description provided for @peltColorChocolate.
  ///
  /// In en, this message translates to:
  /// **'Chocolate'**
  String get peltColorChocolate;

  /// No description provided for @eyeColorYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get eyeColorYellow;

  /// No description provided for @eyeColorAmber.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get eyeColorAmber;

  /// No description provided for @eyeColorHazel.
  ///
  /// In en, this message translates to:
  /// **'Hazel'**
  String get eyeColorHazel;

  /// No description provided for @eyeColorPaleGreen.
  ///
  /// In en, this message translates to:
  /// **'Pale green'**
  String get eyeColorPaleGreen;

  /// No description provided for @eyeColorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get eyeColorGreen;

  /// No description provided for @eyeColorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get eyeColorBlue;

  /// No description provided for @eyeColorDarkBlue.
  ///
  /// In en, this message translates to:
  /// **'Dark blue'**
  String get eyeColorDarkBlue;

  /// No description provided for @eyeColorBlueYellow.
  ///
  /// In en, this message translates to:
  /// **'Blue-yellow'**
  String get eyeColorBlueYellow;

  /// No description provided for @eyeColorBlueGreen.
  ///
  /// In en, this message translates to:
  /// **'Blue-green'**
  String get eyeColorBlueGreen;

  /// No description provided for @eyeColorGrey.
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get eyeColorGrey;

  /// No description provided for @eyeColorCyan.
  ///
  /// In en, this message translates to:
  /// **'Cyan'**
  String get eyeColorCyan;

  /// No description provided for @eyeColorEmerald.
  ///
  /// In en, this message translates to:
  /// **'Emerald'**
  String get eyeColorEmerald;

  /// No description provided for @eyeColorHeatherBlue.
  ///
  /// In en, this message translates to:
  /// **'Heather blue'**
  String get eyeColorHeatherBlue;

  /// No description provided for @eyeColorSunlitIce.
  ///
  /// In en, this message translates to:
  /// **'Sunlit ice'**
  String get eyeColorSunlitIce;

  /// No description provided for @eyeColorCopper.
  ///
  /// In en, this message translates to:
  /// **'Copper'**
  String get eyeColorCopper;

  /// No description provided for @eyeColorSage.
  ///
  /// In en, this message translates to:
  /// **'Sage'**
  String get eyeColorSage;

  /// No description provided for @eyeColorCobalt.
  ///
  /// In en, this message translates to:
  /// **'Cobalt'**
  String get eyeColorCobalt;

  /// No description provided for @eyeColorPaleBlue.
  ///
  /// In en, this message translates to:
  /// **'Pale blue'**
  String get eyeColorPaleBlue;

  /// No description provided for @eyeColorBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get eyeColorBronze;

  /// No description provided for @eyeColorSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get eyeColorSilver;

  /// No description provided for @eyeColorPaleYellow.
  ///
  /// In en, this message translates to:
  /// **'Pale yellow'**
  String get eyeColorPaleYellow;

  /// No description provided for @eyeDescNormal.
  ///
  /// In en, this message translates to:
  /// **'{color} eyes'**
  String eyeDescNormal(String color);

  /// No description provided for @eyeDescHeterochromia.
  ///
  /// In en, this message translates to:
  /// **'Heterochromia ({primary} / {secondary})'**
  String eyeDescHeterochromia(String primary, String secondary);

  /// No description provided for @skinColorPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get skinColorPink;

  /// No description provided for @skinColorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get skinColorRed;

  /// No description provided for @skinColorBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get skinColorBlack;

  /// No description provided for @skinColorDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get skinColorDark;

  /// No description provided for @skinColorDarkBrown.
  ///
  /// In en, this message translates to:
  /// **'Dark brown'**
  String get skinColorDarkBrown;

  /// No description provided for @skinColorBrown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get skinColorBrown;

  /// No description provided for @skinColorLightBrown.
  ///
  /// In en, this message translates to:
  /// **'Light brown'**
  String get skinColorLightBrown;

  /// No description provided for @skinColorDarkGrey.
  ///
  /// In en, this message translates to:
  /// **'Dark grey'**
  String get skinColorDarkGrey;

  /// No description provided for @skinColorGrey.
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get skinColorGrey;

  /// No description provided for @skinColorDarkSalmon.
  ///
  /// In en, this message translates to:
  /// **'Dark salmon'**
  String get skinColorDarkSalmon;

  /// No description provided for @skinColorSalmon.
  ///
  /// In en, this message translates to:
  /// **'Salmon'**
  String get skinColorSalmon;

  /// No description provided for @skinColorPeach.
  ///
  /// In en, this message translates to:
  /// **'Peach'**
  String get skinColorPeach;

  /// No description provided for @furLengthLonghair.
  ///
  /// In en, this message translates to:
  /// **'Longhair'**
  String get furLengthLonghair;

  /// No description provided for @furLengthShorthair.
  ///
  /// In en, this message translates to:
  /// **'Shorthair'**
  String get furLengthShorthair;

  /// No description provided for @whiteTintOffwhite.
  ///
  /// In en, this message translates to:
  /// **'Off-white tint'**
  String get whiteTintOffwhite;

  /// No description provided for @whiteTintCream.
  ///
  /// In en, this message translates to:
  /// **'Cream tint'**
  String get whiteTintCream;

  /// No description provided for @whiteTintDarkCream.
  ///
  /// In en, this message translates to:
  /// **'Dark cream tint'**
  String get whiteTintDarkCream;

  /// No description provided for @whiteTintGray.
  ///
  /// In en, this message translates to:
  /// **'Grey tint'**
  String get whiteTintGray;

  /// No description provided for @whiteTintPink.
  ///
  /// In en, this message translates to:
  /// **'Pink tint'**
  String get whiteTintPink;

  /// No description provided for @notifReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'{catName} misses you!'**
  String notifReminderTitle(String catName);

  /// No description provided for @notifReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Time for {habitName} — your cat is waiting!'**
  String notifReminderBody(String habitName);

  /// No description provided for @notifStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'{catName} is worried!'**
  String notifStreakTitle(String catName);

  /// No description provided for @notifStreakBody.
  ///
  /// In en, this message translates to:
  /// **'Your {streak}-day streak is at risk. A quick session will save it!'**
  String notifStreakBody(int streak);

  /// No description provided for @notifEvolutionTitle.
  ///
  /// In en, this message translates to:
  /// **'{catName} evolved!'**
  String notifEvolutionTitle(String catName);

  /// No description provided for @notifEvolutionBody.
  ///
  /// In en, this message translates to:
  /// **'{catName} grew into a {stageName}! Keep up the great work!'**
  String notifEvolutionBody(String catName, String stageName);

  /// No description provided for @durationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String durationHoursMinutes(int hours, int minutes);

  /// No description provided for @diaryScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} Diary'**
  String diaryScreenTitle(String name);

  /// No description provided for @diaryFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load diary'**
  String get diaryFailedToLoad;

  /// No description provided for @diaryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No diary entries yet'**
  String get diaryEmptyTitle;

  /// No description provided for @diaryEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Complete a focus session and your cat will write their first diary entry!'**
  String get diaryEmptyHint;

  /// No description provided for @focusSetupCountdown.
  ///
  /// In en, this message translates to:
  /// **'Countdown'**
  String get focusSetupCountdown;

  /// No description provided for @focusSetupStopwatch.
  ///
  /// In en, this message translates to:
  /// **'Stopwatch'**
  String get focusSetupStopwatch;

  /// No description provided for @focusSetupStartFocus.
  ///
  /// In en, this message translates to:
  /// **'Start Focus'**
  String get focusSetupStartFocus;

  /// No description provided for @focusSetupQuestNotFound.
  ///
  /// In en, this message translates to:
  /// **'Quest not found'**
  String get focusSetupQuestNotFound;

  /// No description provided for @checkInButtonLogMore.
  ///
  /// In en, this message translates to:
  /// **'Log more time'**
  String get checkInButtonLogMore;

  /// No description provided for @checkInButtonStart.
  ///
  /// In en, this message translates to:
  /// **'Start timer'**
  String get checkInButtonStart;

  /// No description provided for @adoptionTitleFirst.
  ///
  /// In en, this message translates to:
  /// **'Adopt Your First Cat!'**
  String get adoptionTitleFirst;

  /// No description provided for @adoptionTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New Quest'**
  String get adoptionTitleNew;

  /// No description provided for @adoptionStepDefineQuest.
  ///
  /// In en, this message translates to:
  /// **'Define Quest'**
  String get adoptionStepDefineQuest;

  /// No description provided for @adoptionStepAdoptCat2.
  ///
  /// In en, this message translates to:
  /// **'Adopt Cat'**
  String get adoptionStepAdoptCat2;

  /// No description provided for @adoptionStepNameCat2.
  ///
  /// In en, this message translates to:
  /// **'Name Cat'**
  String get adoptionStepNameCat2;

  /// No description provided for @adoptionAdopt.
  ///
  /// In en, this message translates to:
  /// **'Adopt!'**
  String get adoptionAdopt;

  /// No description provided for @adoptionQuestPrompt.
  ///
  /// In en, this message translates to:
  /// **'What quest do you want to start?'**
  String get adoptionQuestPrompt;

  /// No description provided for @adoptionKittenHint.
  ///
  /// In en, this message translates to:
  /// **'A kitten will be assigned to help you stay on track!'**
  String get adoptionKittenHint;

  /// No description provided for @adoptionQuestName.
  ///
  /// In en, this message translates to:
  /// **'Quest name'**
  String get adoptionQuestName;

  /// No description provided for @adoptionQuestHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Prepare interview questions'**
  String get adoptionQuestHint;

  /// No description provided for @adoptionTotalTarget.
  ///
  /// In en, this message translates to:
  /// **'Total target hours'**
  String get adoptionTotalTarget;

  /// No description provided for @adoptionGrowthHint.
  ///
  /// In en, this message translates to:
  /// **'Your cat grows as you accumulate focus time'**
  String get adoptionGrowthHint;

  /// No description provided for @adoptionCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get adoptionCustom;

  /// No description provided for @adoptionDailyGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily focus goal'**
  String get adoptionDailyGoalLabel;

  /// No description provided for @adoptionReminderLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder (optional)'**
  String get adoptionReminderLabel;

  /// No description provided for @adoptionReminderNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get adoptionReminderNone;

  /// No description provided for @adoptionCustomGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom daily goal'**
  String get adoptionCustomGoalTitle;

  /// No description provided for @adoptionMinutesPerDay.
  ///
  /// In en, this message translates to:
  /// **'Minutes per day'**
  String get adoptionMinutesPerDay;

  /// No description provided for @adoptionMinutesHint.
  ///
  /// In en, this message translates to:
  /// **'5 - 180'**
  String get adoptionMinutesHint;

  /// No description provided for @adoptionValidMinutes.
  ///
  /// In en, this message translates to:
  /// **'Enter a value between 5 and 180'**
  String get adoptionValidMinutes;

  /// No description provided for @adoptionCustomTargetTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom target hours'**
  String get adoptionCustomTargetTitle;

  /// No description provided for @adoptionTotalHours.
  ///
  /// In en, this message translates to:
  /// **'Total hours'**
  String get adoptionTotalHours;

  /// No description provided for @adoptionHoursHint.
  ///
  /// In en, this message translates to:
  /// **'10 - 2000'**
  String get adoptionHoursHint;

  /// No description provided for @adoptionValidHours.
  ///
  /// In en, this message translates to:
  /// **'Enter a value between 10 and 2000'**
  String get adoptionValidHours;

  /// No description provided for @adoptionSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get adoptionSet;

  /// No description provided for @adoptionChooseKitten.
  ///
  /// In en, this message translates to:
  /// **'Choose your kitten!'**
  String get adoptionChooseKitten;

  /// No description provided for @adoptionCompanionFor.
  ///
  /// In en, this message translates to:
  /// **'Your companion for \"{quest}\"'**
  String adoptionCompanionFor(String quest);

  /// No description provided for @adoptionRerollAll.
  ///
  /// In en, this message translates to:
  /// **'Reroll All'**
  String get adoptionRerollAll;

  /// No description provided for @adoptionNameYourCat2.
  ///
  /// In en, this message translates to:
  /// **'Name your cat'**
  String get adoptionNameYourCat2;

  /// No description provided for @adoptionCatName.
  ///
  /// In en, this message translates to:
  /// **'Cat name'**
  String get adoptionCatName;

  /// No description provided for @adoptionCatHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mochi'**
  String get adoptionCatHint;

  /// No description provided for @adoptionRandomTooltip.
  ///
  /// In en, this message translates to:
  /// **'Random name'**
  String get adoptionRandomTooltip;

  /// No description provided for @adoptionGrowthTarget.
  ///
  /// In en, this message translates to:
  /// **'Your cat will grow as you focus on \"{quest}\"! Target: {hours}h total.'**
  String adoptionGrowthTarget(String quest, int hours);

  /// No description provided for @adoptionValidQuestName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a quest name'**
  String get adoptionValidQuestName;

  /// No description provided for @adoptionValidCatName.
  ///
  /// In en, this message translates to:
  /// **'Please name your cat'**
  String get adoptionValidCatName;

  /// No description provided for @adoptionError.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String adoptionError(String message);

  /// No description provided for @adoptionBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic info'**
  String get adoptionBasicInfo;

  /// No description provided for @adoptionGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get adoptionGoals;

  /// No description provided for @adoptionReminderSection.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get adoptionReminderSection;

  /// No description provided for @adoptionMotivationLabel.
  ///
  /// In en, this message translates to:
  /// **'Motivational quote'**
  String get adoptionMotivationLabel;

  /// No description provided for @adoptionMotivationHint.
  ///
  /// In en, this message translates to:
  /// **'Write something to encourage yourself'**
  String get adoptionMotivationHint;

  /// No description provided for @adoptionMotivationSwap.
  ///
  /// In en, this message translates to:
  /// **'New quote'**
  String get adoptionMotivationSwap;

  /// No description provided for @loginAppName.
  ///
  /// In en, this message translates to:
  /// **'Hachimi'**
  String get loginAppName;

  /// No description provided for @loginTagline.
  ///
  /// In en, this message translates to:
  /// **'Raise cats. Complete quests.'**
  String get loginTagline;

  /// No description provided for @loginContinueGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginContinueGoogle;

  /// No description provided for @loginContinueEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with Email'**
  String get loginContinueEmail;

  /// No description provided for @loginAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get loginAlreadyHaveAccount;

  /// No description provided for @loginLogIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginLogIn;

  /// No description provided for @loginWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get loginWelcomeBack;

  /// No description provided for @loginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get loginCreateAccount;

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get loginConfirmPassword;

  /// No description provided for @loginValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get loginValidEmail;

  /// No description provided for @loginValidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get loginValidEmailFormat;

  /// No description provided for @loginValidPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get loginValidPassword;

  /// No description provided for @loginValidPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get loginValidPasswordLength;

  /// No description provided for @loginValidPasswordMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get loginValidPasswordMatch;

  /// No description provided for @loginCreateAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get loginCreateAccountButton;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get loginNoAccount;

  /// No description provided for @loginRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get loginRegister;

  /// No description provided for @checkInTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly Check-In'**
  String get checkInTitle;

  /// No description provided for @checkInDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get checkInDays;

  /// No description provided for @checkInCoinsEarned.
  ///
  /// In en, this message translates to:
  /// **'Coins earned'**
  String get checkInCoinsEarned;

  /// No description provided for @checkInAllMilestones.
  ///
  /// In en, this message translates to:
  /// **'All milestones claimed!'**
  String get checkInAllMilestones;

  /// No description provided for @checkInMilestoneProgress.
  ///
  /// In en, this message translates to:
  /// **'{remaining} more days → +{bonus} coins'**
  String checkInMilestoneProgress(int remaining, int bonus);

  /// No description provided for @checkInMilestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get checkInMilestones;

  /// No description provided for @checkInFullMonth.
  ///
  /// In en, this message translates to:
  /// **'Full month'**
  String get checkInFullMonth;

  /// No description provided for @checkInRewardSchedule.
  ///
  /// In en, this message translates to:
  /// **'Reward Schedule'**
  String get checkInRewardSchedule;

  /// No description provided for @checkInWeekday.
  ///
  /// In en, this message translates to:
  /// **'Weekday (Mon–Fri)'**
  String get checkInWeekday;

  /// No description provided for @checkInWeekdayReward.
  ///
  /// In en, this message translates to:
  /// **'{coins} coins/day'**
  String checkInWeekdayReward(int coins);

  /// No description provided for @checkInWeekend.
  ///
  /// In en, this message translates to:
  /// **'Weekend (Sat–Sun)'**
  String get checkInWeekend;

  /// No description provided for @checkInNDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String checkInNDays(int count);

  /// No description provided for @onboardTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Hachimi'**
  String get onboardTitle1;

  /// No description provided for @onboardSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Raise cats, complete quests'**
  String get onboardSubtitle1;

  /// No description provided for @onboardBody1.
  ///
  /// In en, this message translates to:
  /// **'Every quest you start comes with a kitten.\nFocus on your goals and watch them grow\nfrom tiny kittens into shiny cats!'**
  String get onboardBody1;

  /// No description provided for @onboardTitle2.
  ///
  /// In en, this message translates to:
  /// **'Focus & Earn XP'**
  String get onboardTitle2;

  /// No description provided for @onboardSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Time fuels growth'**
  String get onboardSubtitle2;

  /// No description provided for @onboardBody2.
  ///
  /// In en, this message translates to:
  /// **'Start a focus session and your cat earns XP.\nBuild streaks for bonus rewards.\nEvery minute counts toward evolution!'**
  String get onboardBody2;

  /// No description provided for @onboardTitle3.
  ///
  /// In en, this message translates to:
  /// **'Watch Them Evolve'**
  String get onboardTitle3;

  /// No description provided for @onboardSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Kitten → Shiny'**
  String get onboardSubtitle3;

  /// No description provided for @onboardBody3.
  ///
  /// In en, this message translates to:
  /// **'Cats evolve through 4 stages as they grow.\nCollect different breeds, unlock rare cats,\nand fill your cozy cat room!'**
  String get onboardBody3;

  /// No description provided for @onboardSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardSkip;

  /// No description provided for @onboardLetsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Go!'**
  String get onboardLetsGo;

  /// No description provided for @onboardNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardNext;

  /// No description provided for @catRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'CatHouse'**
  String get catRoomTitle;

  /// No description provided for @catRoomInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get catRoomInventory;

  /// No description provided for @catRoomShop.
  ///
  /// In en, this message translates to:
  /// **'Accessory Shop'**
  String get catRoomShop;

  /// No description provided for @catRoomLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cats'**
  String get catRoomLoadError;

  /// No description provided for @catRoomEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your CatHouse is empty'**
  String get catRoomEmptyTitle;

  /// No description provided for @catRoomEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start a quest to adopt your first cat!'**
  String get catRoomEmptySubtitle;

  /// No description provided for @catRoomEditQuest.
  ///
  /// In en, this message translates to:
  /// **'Edit Quest'**
  String get catRoomEditQuest;

  /// No description provided for @catRoomRenameCat.
  ///
  /// In en, this message translates to:
  /// **'Rename Cat'**
  String get catRoomRenameCat;

  /// No description provided for @catRoomArchiveCat.
  ///
  /// In en, this message translates to:
  /// **'Archive Cat'**
  String get catRoomArchiveCat;

  /// No description provided for @catRoomNewName.
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get catRoomNewName;

  /// No description provided for @catRoomRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get catRoomRename;

  /// No description provided for @catRoomArchiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive cat?'**
  String get catRoomArchiveTitle;

  /// No description provided for @catRoomArchiveMessage.
  ///
  /// In en, this message translates to:
  /// **'This will archive \"{name}\" and delete its bound quest. The cat will still appear in your album.'**
  String catRoomArchiveMessage(String name);

  /// No description provided for @catRoomArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get catRoomArchive;

  /// No description provided for @addHabitTitle.
  ///
  /// In en, this message translates to:
  /// **'New Quest'**
  String get addHabitTitle;

  /// No description provided for @addHabitQuestName.
  ///
  /// In en, this message translates to:
  /// **'Quest name'**
  String get addHabitQuestName;

  /// No description provided for @addHabitQuestHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. LeetCode Practice'**
  String get addHabitQuestHint;

  /// No description provided for @addHabitValidName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a quest name'**
  String get addHabitValidName;

  /// No description provided for @addHabitTargetHours.
  ///
  /// In en, this message translates to:
  /// **'Target hours'**
  String get addHabitTargetHours;

  /// No description provided for @addHabitTargetHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 100'**
  String get addHabitTargetHint;

  /// No description provided for @addHabitValidTarget.
  ///
  /// In en, this message translates to:
  /// **'Please enter target hours'**
  String get addHabitValidTarget;

  /// No description provided for @addHabitValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get addHabitValidNumber;

  /// No description provided for @addHabitCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Quest'**
  String get addHabitCreate;

  /// No description provided for @addHabitHoursSuffix.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get addHabitHoursSuffix;

  /// No description provided for @shopTabPlants.
  ///
  /// In en, this message translates to:
  /// **'Plants ({count})'**
  String shopTabPlants(int count);

  /// No description provided for @shopTabWild.
  ///
  /// In en, this message translates to:
  /// **'Wild ({count})'**
  String shopTabWild(int count);

  /// No description provided for @shopTabCollars.
  ///
  /// In en, this message translates to:
  /// **'Collars ({count})'**
  String shopTabCollars(int count);

  /// No description provided for @shopNoAccessories.
  ///
  /// In en, this message translates to:
  /// **'No accessories available'**
  String get shopNoAccessories;

  /// No description provided for @shopBuyConfirm.
  ///
  /// In en, this message translates to:
  /// **'Buy {name}?'**
  String shopBuyConfirm(String name);

  /// No description provided for @shopPurchaseButton.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get shopPurchaseButton;

  /// No description provided for @shopNotEnoughCoinsButton.
  ///
  /// In en, this message translates to:
  /// **'Not enough coins'**
  String get shopNotEnoughCoinsButton;

  /// No description provided for @shopPurchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchased! {name} added to inventory'**
  String shopPurchaseSuccess(String name);

  /// No description provided for @shopPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Not enough coins (need {price})'**
  String shopPurchaseFailed(int price);

  /// No description provided for @inventoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventoryTitle;

  /// No description provided for @inventoryInBox.
  ///
  /// In en, this message translates to:
  /// **'In Box ({count})'**
  String inventoryInBox(int count);

  /// No description provided for @inventoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your inventory is empty.\nVisit the shop to get accessories!'**
  String get inventoryEmpty;

  /// No description provided for @inventoryEquippedOnCats.
  ///
  /// In en, this message translates to:
  /// **'Equipped on Cats ({count})'**
  String inventoryEquippedOnCats(int count);

  /// No description provided for @inventoryNoEquipped.
  ///
  /// In en, this message translates to:
  /// **'No accessories equipped on any cat.'**
  String get inventoryNoEquipped;

  /// No description provided for @inventoryUnequip.
  ///
  /// In en, this message translates to:
  /// **'Unequip'**
  String get inventoryUnequip;

  /// No description provided for @inventoryNoActiveCats.
  ///
  /// In en, this message translates to:
  /// **'No active cats'**
  String get inventoryNoActiveCats;

  /// No description provided for @inventoryEquipTo.
  ///
  /// In en, this message translates to:
  /// **'Equip {name} to:'**
  String inventoryEquipTo(String name);

  /// No description provided for @inventoryEquipSuccess.
  ///
  /// In en, this message translates to:
  /// **'Equipped {name}'**
  String inventoryEquipSuccess(String name);

  /// No description provided for @inventoryUnequipSuccess.
  ///
  /// In en, this message translates to:
  /// **'Unequipped from {catName}'**
  String inventoryUnequipSuccess(String catName);

  /// No description provided for @chatCatNotFound.
  ///
  /// In en, this message translates to:
  /// **'Cat not found'**
  String get chatCatNotFound;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat with {name}'**
  String chatTitle(String name);

  /// No description provided for @chatClearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get chatClearHistory;

  /// No description provided for @chatEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Say hi to {name}!'**
  String chatEmptyTitle(String name);

  /// No description provided for @chatEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation with your cat. They will reply based on their personality!'**
  String get chatEmptySubtitle;

  /// No description provided for @chatGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get chatGenerating;

  /// No description provided for @chatTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get chatTypeMessage;

  /// No description provided for @chatClearConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear chat history?'**
  String get chatClearConfirmTitle;

  /// No description provided for @chatClearConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will delete all messages. This cannot be undone.'**
  String get chatClearConfirmMessage;

  /// No description provided for @chatClearButton.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get chatClearButton;

  /// No description provided for @diaryTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} Diary'**
  String diaryTitle(String name);

  /// No description provided for @diaryLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load diary'**
  String get diaryLoadFailed;

  /// No description provided for @diaryRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get diaryRetry;

  /// No description provided for @diaryEmptyTitle2.
  ///
  /// In en, this message translates to:
  /// **'No diary entries yet'**
  String get diaryEmptyTitle2;

  /// No description provided for @diaryEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete a focus session and your cat will write their first diary entry!'**
  String get diaryEmptySubtitle;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statsTitle;

  /// No description provided for @statsTotalHours.
  ///
  /// In en, this message translates to:
  /// **'Total Hours'**
  String get statsTotalHours;

  /// No description provided for @statsTimeValue.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String statsTimeValue(int hours, int minutes);

  /// No description provided for @statsBestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best Streak'**
  String get statsBestStreak;

  /// No description provided for @statsStreakDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String statsStreakDays(int count);

  /// No description provided for @statsOverallProgress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get statsOverallProgress;

  /// No description provided for @statsPercentOfGoals.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of all goals'**
  String statsPercentOfGoals(String percent);

  /// No description provided for @statsPerQuestProgress.
  ///
  /// In en, this message translates to:
  /// **'Per-Quest Progress'**
  String get statsPerQuestProgress;

  /// No description provided for @statsQuestLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load quest stats'**
  String get statsQuestLoadError;

  /// No description provided for @statsNoQuestData.
  ///
  /// In en, this message translates to:
  /// **'No quest data yet'**
  String get statsNoQuestData;

  /// No description provided for @statsNoQuestHint.
  ///
  /// In en, this message translates to:
  /// **'Start a quest to see your progress here!'**
  String get statsNoQuestHint;

  /// No description provided for @statsLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get statsLast30Days;

  /// No description provided for @habitDetailQuestNotFound.
  ///
  /// In en, this message translates to:
  /// **'Quest not found'**
  String get habitDetailQuestNotFound;

  /// No description provided for @habitDetailComplete.
  ///
  /// In en, this message translates to:
  /// **'complete'**
  String get habitDetailComplete;

  /// No description provided for @habitDetailTotalTime.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get habitDetailTotalTime;

  /// No description provided for @habitDetailCurrentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get habitDetailCurrentStreak;

  /// No description provided for @habitDetailTarget.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get habitDetailTarget;

  /// No description provided for @habitDetailDaysUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String habitDetailDaysUnit(int count);

  /// No description provided for @habitDetailHoursUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} hours'**
  String habitDetailHoursUnit(int count);

  /// No description provided for @checkInBannerSuccess.
  ///
  /// In en, this message translates to:
  /// **'+{coins} coins! Daily check-in complete'**
  String checkInBannerSuccess(int coins);

  /// No description provided for @checkInBannerBonus.
  ///
  /// In en, this message translates to:
  /// **' + {bonus} milestone bonus!'**
  String checkInBannerBonus(int bonus);

  /// No description provided for @checkInBannerSemantics.
  ///
  /// In en, this message translates to:
  /// **'Daily check-in'**
  String get checkInBannerSemantics;

  /// No description provided for @checkInBannerLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading check-in status...'**
  String get checkInBannerLoading;

  /// No description provided for @checkInBannerPrompt.
  ///
  /// In en, this message translates to:
  /// **'Check in for +{coins} coins'**
  String checkInBannerPrompt(int coins);

  /// No description provided for @checkInBannerSummary.
  ///
  /// In en, this message translates to:
  /// **'{count}/{total} days  ·  +{coins} today'**
  String checkInBannerSummary(int count, int total, int coins);

  /// No description provided for @commonErrorWithDetail.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String commonErrorWithDetail(String error);

  /// No description provided for @profileFallbackUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get profileFallbackUser;

  /// No description provided for @fallbackCatName.
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get fallbackCatName;

  /// No description provided for @settingsLanguageTraditionalChinese.
  ///
  /// In en, this message translates to:
  /// **'Traditional Chinese'**
  String get settingsLanguageTraditionalChinese;

  /// No description provided for @settingsLanguageJapanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get settingsLanguageJapanese;

  /// No description provided for @settingsLanguageKorean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get settingsLanguageKorean;

  /// No description provided for @notifFocusing.
  ///
  /// In en, this message translates to:
  /// **'focusing...'**
  String get notifFocusing;

  /// No description provided for @notifInProgress.
  ///
  /// In en, this message translates to:
  /// **'Focus session in progress'**
  String get notifInProgress;

  /// No description provided for @unitMinShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get unitMinShort;

  /// No description provided for @unitHourShort.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get unitHourShort;

  /// No description provided for @weekdayMon.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get weekdaySun;

  /// No description provided for @statsTotalSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get statsTotalSessions;

  /// No description provided for @statsTotalHabits.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get statsTotalHabits;

  /// No description provided for @statsActiveDays.
  ///
  /// In en, this message translates to:
  /// **'Active days'**
  String get statsActiveDays;

  /// No description provided for @statsWeeklyTrend.
  ///
  /// In en, this message translates to:
  /// **'Weekly trend'**
  String get statsWeeklyTrend;

  /// No description provided for @statsRecentSessions.
  ///
  /// In en, this message translates to:
  /// **'Recent focus'**
  String get statsRecentSessions;

  /// No description provided for @statsViewAllHistory.
  ///
  /// In en, this message translates to:
  /// **'View all history'**
  String get statsViewAllHistory;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus history'**
  String get historyTitle;

  /// No description provided for @historyFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get historyFilterAll;

  /// No description provided for @historySessionCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions'**
  String historySessionCount(int count);

  /// No description provided for @historyTotalMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String historyTotalMinutes(int minutes);

  /// No description provided for @historyNoSessions.
  ///
  /// In en, this message translates to:
  /// **'No focus records yet'**
  String get historyNoSessions;

  /// No description provided for @historyNoSessionsHint.
  ///
  /// In en, this message translates to:
  /// **'Complete a focus session to see it here'**
  String get historyNoSessionsHint;

  /// No description provided for @historyLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get historyLoadMore;

  /// No description provided for @sessionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get sessionCompleted;

  /// No description provided for @sessionAbandoned.
  ///
  /// In en, this message translates to:
  /// **'Abandoned'**
  String get sessionAbandoned;

  /// No description provided for @sessionInterrupted.
  ///
  /// In en, this message translates to:
  /// **'Interrupted'**
  String get sessionInterrupted;

  /// No description provided for @sessionCountdown.
  ///
  /// In en, this message translates to:
  /// **'Countdown'**
  String get sessionCountdown;

  /// No description provided for @sessionStopwatch.
  ///
  /// In en, this message translates to:
  /// **'Stopwatch'**
  String get sessionStopwatch;

  /// No description provided for @historyDateGroupToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get historyDateGroupToday;

  /// No description provided for @historyDateGroupYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get historyDateGroupYesterday;

  /// No description provided for @historyLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load history'**
  String get historyLoadError;

  /// No description provided for @historySelectMonth.
  ///
  /// In en, this message translates to:
  /// **'Select month'**
  String get historySelectMonth;

  /// No description provided for @historyAllMonths.
  ///
  /// In en, this message translates to:
  /// **'All months'**
  String get historyAllMonths;

  /// No description provided for @historyAllHabits.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get historyAllHabits;

  /// No description provided for @homeTabAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get homeTabAchievements;

  /// No description provided for @achievementTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementTitle;

  /// No description provided for @achievementTabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get achievementTabOverview;

  /// No description provided for @achievementTabQuest.
  ///
  /// In en, this message translates to:
  /// **'Quest'**
  String get achievementTabQuest;

  /// No description provided for @achievementTabStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get achievementTabStreak;

  /// No description provided for @achievementTabCat.
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get achievementTabCat;

  /// No description provided for @achievementTabPersist.
  ///
  /// In en, this message translates to:
  /// **'Persist'**
  String get achievementTabPersist;

  /// No description provided for @achievementSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievement Progress'**
  String get achievementSummaryTitle;

  /// No description provided for @achievementUnlockedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} unlocked'**
  String achievementUnlockedCount(int count);

  /// No description provided for @achievementTotalCoins.
  ///
  /// In en, this message translates to:
  /// **'{coins} coins earned'**
  String achievementTotalCoins(int coins);

  /// No description provided for @achievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Achievement unlocked!'**
  String get achievementUnlocked;

  /// No description provided for @achievementHidden.
  ///
  /// In en, this message translates to:
  /// **'???'**
  String get achievementHidden;

  /// No description provided for @achievementHiddenDesc.
  ///
  /// In en, this message translates to:
  /// **'This is a hidden achievement'**
  String get achievementHiddenDesc;

  /// No description provided for @achievementPersistDesc.
  ///
  /// In en, this message translates to:
  /// **'Accumulate {days} check-in days on any quest'**
  String achievementPersistDesc(int days);

  /// No description provided for @achievementTitleCount.
  ///
  /// In en, this message translates to:
  /// **'{count} titles unlocked'**
  String achievementTitleCount(int count);
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return SZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'ja':
      return SJa();
    case 'ko':
      return SKo();
    case 'zh':
      return SZh();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
