import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_vi.dart';
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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('th'),
    Locale('tr'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Hachimi - Light Up My Innerverse'**
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

  /// No description provided for @focusCompleteDiarySkipped.
  ///
  /// In en, this message translates to:
  /// **'Diary skipped'**
  String get focusCompleteDiarySkipped;

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

  /// No description provided for @loggingOut.
  ///
  /// In en, this message translates to:
  /// **'Logging out...'**
  String get loggingOut;

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

  /// No description provided for @profileTotalQuests.
  ///
  /// In en, this message translates to:
  /// **'Quests'**
  String get profileTotalQuests;

  /// No description provided for @profileEditName.
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get profileEditName;

  /// No description provided for @profileDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get profileDisplayName;

  /// No description provided for @profileChooseAvatar.
  ///
  /// In en, this message translates to:
  /// **'Choose avatar'**
  String get profileChooseAvatar;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSaved;

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

  /// No description provided for @chatDailyRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} messages left today'**
  String chatDailyRemaining(int count);

  /// No description provided for @chatDailyLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Daily message limit reached'**
  String get chatDailyLimitReached;

  /// No description provided for @aiTemporarilyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'AI features are temporarily unavailable'**
  String get aiTemporarilyUnavailable;

  /// No description provided for @catDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Cat not found'**
  String get catDetailNotFound;

  /// No description provided for @catDetailLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cat data'**
  String get catDetailLoadError;

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

  /// No description provided for @catDetailCheckInDays.
  ///
  /// In en, this message translates to:
  /// **'Check-in days'**
  String get catDetailCheckInDays;

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

  /// No description provided for @catDetailTargetCompletedHint.
  ///
  /// In en, this message translates to:
  /// **'Target already reached — now in unlimited mode'**
  String get catDetailTargetCompletedHint;

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

  /// No description provided for @settingsUiStyle.
  ///
  /// In en, this message translates to:
  /// **'UI style'**
  String get settingsUiStyle;

  /// No description provided for @settingsUiStyleMaterial.
  ///
  /// In en, this message translates to:
  /// **'Material 3'**
  String get settingsUiStyleMaterial;

  /// No description provided for @settingsUiStyleRetroPixel.
  ///
  /// In en, this message translates to:
  /// **'Retro Pixel'**
  String get settingsUiStyleRetroPixel;

  /// No description provided for @settingsUiStyleMaterialSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Modern, rounded Material Design'**
  String get settingsUiStyleMaterialSubtitle;

  /// No description provided for @settingsUiStyleRetroPixelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Warm pixel-art aesthetic'**
  String get settingsUiStyleRetroPixelSubtitle;

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
  /// **'Total target (hours)'**
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
  /// **'Daily focus goal (min)'**
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

  /// No description provided for @adoptionUnlimitedMode.
  ///
  /// In en, this message translates to:
  /// **'Unlimited mode'**
  String get adoptionUnlimitedMode;

  /// No description provided for @adoptionUnlimitedDesc.
  ///
  /// In en, this message translates to:
  /// **'No upper limit, keep accumulating'**
  String get adoptionUnlimitedDesc;

  /// No description provided for @adoptionMilestoneMode.
  ///
  /// In en, this message translates to:
  /// **'Milestone mode'**
  String get adoptionMilestoneMode;

  /// No description provided for @adoptionMilestoneDesc.
  ///
  /// In en, this message translates to:
  /// **'Set a target to reach'**
  String get adoptionMilestoneDesc;

  /// No description provided for @adoptionDeadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get adoptionDeadlineLabel;

  /// No description provided for @adoptionDeadlineNone.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get adoptionDeadlineNone;

  /// No description provided for @adoptionReminderSection.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get adoptionReminderSection;

  /// No description provided for @adoptionMotivationLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get adoptionMotivationLabel;

  /// No description provided for @adoptionMotivationHint.
  ///
  /// In en, this message translates to:
  /// **'Write a note...'**
  String get adoptionMotivationHint;

  /// No description provided for @adoptionMotivationSwap.
  ///
  /// In en, this message translates to:
  /// **'Random fill'**
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
  /// **'Meet Hachimi'**
  String get onboardTitle1;

  /// No description provided for @onboardSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Your awareness companion'**
  String get onboardSubtitle1;

  /// No description provided for @onboardBody1.
  ///
  /// In en, this message translates to:
  /// **'Hachimi is a cat who senses your mood, keeping you company as you notice the little things each day.'**
  String get onboardBody1;

  /// No description provided for @onboardTitle2.
  ///
  /// In en, this message translates to:
  /// **'5 Minutes a Day'**
  String get onboardTitle2;

  /// No description provided for @onboardSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Record your daily light'**
  String get onboardSubtitle2;

  /// No description provided for @onboardBody2.
  ///
  /// In en, this message translates to:
  /// **'Before bed, capture a moment that made you smile. Pick a mood, write one line — that\'s enough.'**
  String get onboardBody2;

  /// No description provided for @onboardTitle3.
  ///
  /// In en, this message translates to:
  /// **'A Cat That Grows With You'**
  String get onboardTitle3;

  /// No description provided for @onboardSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Getting better, slowly'**
  String get onboardSubtitle3;

  /// No description provided for @onboardBody3.
  ///
  /// In en, this message translates to:
  /// **'Focus on habits, record your mood, notice your worries. It\'s okay to be imperfect — your cat is always here.'**
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

  /// No description provided for @catRoomAlbumSection.
  ///
  /// In en, this message translates to:
  /// **'Album ({count})'**
  String catRoomAlbumSection(int count);

  /// No description provided for @catRoomReactivateCat.
  ///
  /// In en, this message translates to:
  /// **'Reactivate Cat'**
  String get catRoomReactivateCat;

  /// No description provided for @catRoomReactivateTitle.
  ///
  /// In en, this message translates to:
  /// **'Reactivate cat?'**
  String get catRoomReactivateTitle;

  /// No description provided for @catRoomReactivateMessage.
  ///
  /// In en, this message translates to:
  /// **'This will restore \"{name}\" and its bound quest to the CatHouse.'**
  String catRoomReactivateMessage(String name);

  /// No description provided for @catRoomReactivate.
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get catRoomReactivate;

  /// No description provided for @catRoomArchivedLabel.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get catRoomArchivedLabel;

  /// No description provided for @catRoomArchiveSuccess.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" archived'**
  String catRoomArchiveSuccess(String name);

  /// No description provided for @catRoomReactivateSuccess.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" reactivated'**
  String catRoomReactivateSuccess(String name);

  /// No description provided for @catRoomArchiveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to archive cat'**
  String get catRoomArchiveError;

  /// No description provided for @catRoomReactivateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to reactivate cat'**
  String get catRoomReactivateError;

  /// No description provided for @catRoomArchiveLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load archived cats'**
  String get catRoomArchiveLoadError;

  /// No description provided for @catRoomRenameError.
  ///
  /// In en, this message translates to:
  /// **'Failed to rename cat'**
  String get catRoomRenameError;

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

  /// No description provided for @chatSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get chatSend;

  /// No description provided for @chatStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get chatStop;

  /// No description provided for @chatErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to send message. Tap to retry.'**
  String get chatErrorMessage;

  /// No description provided for @chatRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get chatRetry;

  /// No description provided for @chatErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get chatErrorGeneric;

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

  /// No description provided for @settingsLanguageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get settingsLanguageSpanish;

  /// No description provided for @settingsLanguagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get settingsLanguagePortuguese;

  /// No description provided for @settingsLanguageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get settingsLanguageFrench;

  /// No description provided for @settingsLanguageGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get settingsLanguageGerman;

  /// No description provided for @settingsLanguageItalian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get settingsLanguageItalian;

  /// No description provided for @settingsLanguageHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get settingsLanguageHindi;

  /// No description provided for @settingsLanguageThai.
  ///
  /// In en, this message translates to:
  /// **'Thai'**
  String get settingsLanguageThai;

  /// No description provided for @settingsLanguageVietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get settingsLanguageVietnamese;

  /// No description provided for @settingsLanguageIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get settingsLanguageIndonesian;

  /// No description provided for @settingsLanguageTurkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get settingsLanguageTurkish;

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

  /// No description provided for @achievementAwesome.
  ///
  /// In en, this message translates to:
  /// **'Awesome!'**
  String get achievementAwesome;

  /// No description provided for @achievementIncredible.
  ///
  /// In en, this message translates to:
  /// **'Incredible!'**
  String get achievementIncredible;

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

  /// Title for the growth path card
  ///
  /// In en, this message translates to:
  /// **'Growth Path'**
  String get growthPathTitle;

  /// Description for kitten stage (0h)
  ///
  /// In en, this message translates to:
  /// **'Start a new journey'**
  String get growthPathKitten;

  /// Description for adolescent stage (20h)
  ///
  /// In en, this message translates to:
  /// **'Build initial foundation'**
  String get growthPathAdolescent;

  /// Description for adult stage (100h)
  ///
  /// In en, this message translates to:
  /// **'Skills consolidate'**
  String get growthPathAdult;

  /// Description for senior stage (200h)
  ///
  /// In en, this message translates to:
  /// **'Deep mastery'**
  String get growthPathSenior;

  /// Research tip about the 20-hour rule
  ///
  /// In en, this message translates to:
  /// **'Research shows that 20 hours of focused practice is enough to build the foundation of a new skill — Josh Kaufman'**
  String get growthPathTip;

  /// Shows coins earned from achievement
  ///
  /// In en, this message translates to:
  /// **'+{count} coins'**
  String achievementCelebrationCoins(int count);

  /// Shows title earned from achievement
  ///
  /// In en, this message translates to:
  /// **'Title earned: {title}'**
  String achievementCelebrationTitle(String title);

  /// Button to dismiss celebration
  ///
  /// In en, this message translates to:
  /// **'Awesome!'**
  String get achievementCelebrationDismiss;

  /// Button to skip all remaining celebrations
  ///
  /// In en, this message translates to:
  /// **'Skip all'**
  String get achievementCelebrationSkipAll;

  /// Shows queue progress for celebrations
  ///
  /// In en, this message translates to:
  /// **'{current} / {total}'**
  String achievementCelebrationCounter(int current, int total);

  /// No description provided for @achievementUnlockedAt.
  ///
  /// In en, this message translates to:
  /// **'Unlocked on {date}'**
  String achievementUnlockedAt(String date);

  /// No description provided for @achievementLocked.
  ///
  /// In en, this message translates to:
  /// **'Not yet unlocked'**
  String get achievementLocked;

  /// No description provided for @achievementRewardCoins.
  ///
  /// In en, this message translates to:
  /// **'+{count} coins'**
  String achievementRewardCoins(int count);

  /// No description provided for @reminderModeDaily.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get reminderModeDaily;

  /// No description provided for @reminderModeWeekdays.
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get reminderModeWeekdays;

  /// No description provided for @reminderModeMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get reminderModeMonday;

  /// No description provided for @reminderModeTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get reminderModeTuesday;

  /// No description provided for @reminderModeWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get reminderModeWednesday;

  /// No description provided for @reminderModeThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get reminderModeThursday;

  /// No description provided for @reminderModeFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get reminderModeFriday;

  /// No description provided for @reminderModeSaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get reminderModeSaturday;

  /// No description provided for @reminderModeSunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get reminderModeSunday;

  /// No description provided for @reminderPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Select reminder time'**
  String get reminderPickerTitle;

  /// No description provided for @reminderHourUnit.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get reminderHourUnit;

  /// No description provided for @reminderMinuteUnit.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get reminderMinuteUnit;

  /// No description provided for @reminderAddMore.
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get reminderAddMore;

  /// No description provided for @reminderMaxReached.
  ///
  /// In en, this message translates to:
  /// **'Up to 5 reminders'**
  String get reminderMaxReached;

  /// No description provided for @reminderConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get reminderConfirm;

  /// No description provided for @reminderNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'{catName} misses you!'**
  String reminderNotificationTitle(String catName);

  /// No description provided for @reminderNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Time for {habitName} — your cat is waiting!'**
  String reminderNotificationBody(String habitName);

  /// No description provided for @deleteAccountDataWarning.
  ///
  /// In en, this message translates to:
  /// **'All the following data will be permanently deleted:'**
  String get deleteAccountDataWarning;

  /// No description provided for @deleteAccountQuests.
  ///
  /// In en, this message translates to:
  /// **'Quests'**
  String get deleteAccountQuests;

  /// No description provided for @deleteAccountCats.
  ///
  /// In en, this message translates to:
  /// **'Cats'**
  String get deleteAccountCats;

  /// No description provided for @deleteAccountHours.
  ///
  /// In en, this message translates to:
  /// **'Focus hours'**
  String get deleteAccountHours;

  /// No description provided for @deleteAccountIrreversible.
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible'**
  String get deleteAccountIrreversible;

  /// No description provided for @deleteAccountContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get deleteAccountContinue;

  /// No description provided for @deleteAccountConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion'**
  String get deleteAccountConfirmTitle;

  /// No description provided for @deleteAccountTypeDelete.
  ///
  /// In en, this message translates to:
  /// **'Type DELETE to confirm account deletion:'**
  String get deleteAccountTypeDelete;

  /// No description provided for @deleteAccountAuthCancelled.
  ///
  /// In en, this message translates to:
  /// **'Authentication cancelled'**
  String get deleteAccountAuthCancelled;

  /// No description provided for @deleteAccountAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed: {error}'**
  String deleteAccountAuthFailed(String error);

  /// No description provided for @deleteAccountProgress.
  ///
  /// In en, this message translates to:
  /// **'Deleting account...'**
  String get deleteAccountProgress;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account deleted'**
  String get deleteAccountSuccess;

  /// No description provided for @drawerGuestLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sync data and unlock AI features'**
  String get drawerGuestLoginSubtitle;

  /// No description provided for @drawerGuestSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get drawerGuestSignIn;

  /// No description provided for @drawerMilestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get drawerMilestones;

  /// No description provided for @drawerMilestoneFocus.
  ///
  /// In en, this message translates to:
  /// **'Total focus: {hours}h {minutes}m'**
  String drawerMilestoneFocus(int hours, int minutes);

  /// No description provided for @drawerMilestoneCats.
  ///
  /// In en, this message translates to:
  /// **'Cat family: {count}'**
  String drawerMilestoneCats(int count);

  /// No description provided for @drawerMilestoneQuests.
  ///
  /// In en, this message translates to:
  /// **'Active quests: {count}'**
  String drawerMilestoneQuests(int count);

  /// No description provided for @drawerMySection.
  ///
  /// In en, this message translates to:
  /// **'My'**
  String get drawerMySection;

  /// No description provided for @drawerSessionHistory.
  ///
  /// In en, this message translates to:
  /// **'Focus history'**
  String get drawerSessionHistory;

  /// No description provided for @drawerCheckInCalendar.
  ///
  /// In en, this message translates to:
  /// **'Check-in calendar'**
  String get drawerCheckInCalendar;

  /// No description provided for @drawerAccountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get drawerAccountSection;

  /// No description provided for @settingsResetData.
  ///
  /// In en, this message translates to:
  /// **'Reset all data'**
  String get settingsResetData;

  /// No description provided for @settingsResetDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all data?'**
  String get settingsResetDataTitle;

  /// No description provided for @settingsResetDataMessage.
  ///
  /// In en, this message translates to:
  /// **'This will delete all local data and return to the welcome screen. This cannot be undone.'**
  String get settingsResetDataMessage;

  /// No description provided for @guestUpgradeTitle.
  ///
  /// In en, this message translates to:
  /// **'Protect your data'**
  String get guestUpgradeTitle;

  /// No description provided for @guestUpgradeMessage.
  ///
  /// In en, this message translates to:
  /// **'Link an account to back up your progress, unlock AI diary and chat features, and sync across devices.'**
  String get guestUpgradeMessage;

  /// No description provided for @guestUpgradeLinkButton.
  ///
  /// In en, this message translates to:
  /// **'Link account'**
  String get guestUpgradeLinkButton;

  /// No description provided for @guestUpgradeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get guestUpgradeLater;

  /// No description provided for @loginLinkTagline.
  ///
  /// In en, this message translates to:
  /// **'Link an account to protect your data'**
  String get loginLinkTagline;

  /// No description provided for @aiTeaserTitle.
  ///
  /// In en, this message translates to:
  /// **'Cat diary'**
  String get aiTeaserTitle;

  /// No description provided for @aiTeaserPreview.
  ///
  /// In en, this message translates to:
  /// **'Today I studied with my human again... {catName} feels smarter every day~'**
  String aiTeaserPreview(String catName);

  /// No description provided for @aiTeaserCta.
  ///
  /// In en, this message translates to:
  /// **'Link an account to see what {catName} wants to say'**
  String aiTeaserCta(String catName);

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password'**
  String get authErrorWrongPassword;

  /// No description provided for @authErrorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email'**
  String get authErrorUserNotFound;

  /// No description provided for @authErrorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later'**
  String get authErrorTooManyRequests;

  /// No description provided for @authErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Check your connection'**
  String get authErrorNetwork;

  /// No description provided for @authErrorAdminRestricted.
  ///
  /// In en, this message translates to:
  /// **'Sign-in is temporarily restricted'**
  String get authErrorAdminRestricted;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Use at least 6 characters'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again'**
  String get authErrorGeneric;

  /// No description provided for @deleteAccountReauthEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to continue'**
  String get deleteAccountReauthEmail;

  /// No description provided for @deleteAccountReauthPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get deleteAccountReauthPasswordHint;

  /// No description provided for @deleteAccountError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again later.'**
  String get deleteAccountError;

  /// No description provided for @deleteAccountPermissionError.
  ///
  /// In en, this message translates to:
  /// **'Permission error. Try signing out and back in.'**
  String get deleteAccountPermissionError;

  /// No description provided for @deleteAccountNetworkError.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network.'**
  String get deleteAccountNetworkError;

  /// No description provided for @deleteAccountRetainedData.
  ///
  /// In en, this message translates to:
  /// **'Usage analytics and crash reports cannot be deleted.'**
  String get deleteAccountRetainedData;

  /// No description provided for @deleteAccountStepCloud.
  ///
  /// In en, this message translates to:
  /// **'Deleting cloud data...'**
  String get deleteAccountStepCloud;

  /// No description provided for @deleteAccountStepLocal.
  ///
  /// In en, this message translates to:
  /// **'Clearing local data...'**
  String get deleteAccountStepLocal;

  /// No description provided for @deleteAccountStepDone.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get deleteAccountStepDone;

  /// No description provided for @deleteAccountQueued.
  ///
  /// In en, this message translates to:
  /// **'Local data deleted. Cloud account deletion is queued and will finish when online.'**
  String get deleteAccountQueued;

  /// No description provided for @deleteAccountPending.
  ///
  /// In en, this message translates to:
  /// **'Account deletion is pending. Keep the app online to finish cloud and auth deletion.'**
  String get deleteAccountPending;

  /// No description provided for @deleteAccountAbandon.
  ///
  /// In en, this message translates to:
  /// **'Start fresh'**
  String get deleteAccountAbandon;

  /// No description provided for @archiveConflictTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose archive to keep'**
  String get archiveConflictTitle;

  /// No description provided for @archiveConflictMessage.
  ///
  /// In en, this message translates to:
  /// **'Both local and cloud archives have data. Choose one to keep:'**
  String get archiveConflictMessage;

  /// No description provided for @archiveConflictLocal.
  ///
  /// In en, this message translates to:
  /// **'Local archive'**
  String get archiveConflictLocal;

  /// No description provided for @archiveConflictCloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud archive'**
  String get archiveConflictCloud;

  /// No description provided for @archiveConflictKeepCloud.
  ///
  /// In en, this message translates to:
  /// **'Keep cloud'**
  String get archiveConflictKeepCloud;

  /// No description provided for @archiveConflictKeepLocal.
  ///
  /// In en, this message translates to:
  /// **'Keep local'**
  String get archiveConflictKeepLocal;

  /// No description provided for @loginShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get loginShowPassword;

  /// No description provided for @loginHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get loginHidePassword;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again later'**
  String get errorGeneric;

  /// No description provided for @errorCreateHabit.
  ///
  /// In en, this message translates to:
  /// **'Failed to create habit. Try again'**
  String get errorCreateHabit;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginForgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get loginForgotPasswordTitle;

  /// No description provided for @loginSendResetEmail.
  ///
  /// In en, this message translates to:
  /// **'Send reset email'**
  String get loginSendResetEmail;

  /// No description provided for @loginResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent. Check your inbox'**
  String get loginResetEmailSent;

  /// No description provided for @authErrorUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled'**
  String get authErrorUserDisabled;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorRequiresRecentLogin.
  ///
  /// In en, this message translates to:
  /// **'Please log in again to continue'**
  String get authErrorRequiresRecentLogin;

  /// No description provided for @commonCopyId.
  ///
  /// In en, this message translates to:
  /// **'Copy ID'**
  String get commonCopyId;

  /// No description provided for @adoptionClearDeadline.
  ///
  /// In en, this message translates to:
  /// **'Clear deadline'**
  String get adoptionClearDeadline;

  /// No description provided for @commonIdCopied.
  ///
  /// In en, this message translates to:
  /// **'ID copied'**
  String get commonIdCopied;

  /// No description provided for @pickerDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration picker'**
  String get pickerDurationLabel;

  /// No description provided for @pickerMinutesValue.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String pickerMinutesValue(int count);

  /// No description provided for @a11yCatImage.
  ///
  /// In en, this message translates to:
  /// **'{name} cat'**
  String a11yCatImage(String name);

  /// No description provided for @a11yCatTapToInteract.
  ///
  /// In en, this message translates to:
  /// **'{name}, tap to interact'**
  String a11yCatTapToInteract(String name);

  /// No description provided for @a11yProgressPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% complete'**
  String a11yProgressPercent(int percent);

  /// No description provided for @a11yStreakActiveDays.
  ///
  /// In en, this message translates to:
  /// **'{count} active days'**
  String a11yStreakActiveDays(int count);

  /// No description provided for @a11yOfflineStatus.
  ///
  /// In en, this message translates to:
  /// **'Offline mode'**
  String get a11yOfflineStatus;

  /// No description provided for @a11yAchievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Achievement unlocked: {name}'**
  String a11yAchievementUnlocked(String name);

  /// No description provided for @calendarCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'checked in'**
  String get calendarCheckedIn;

  /// No description provided for @calendarToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get calendarToday;

  /// No description provided for @a11yEquipToCat.
  ///
  /// In en, this message translates to:
  /// **'Equip to {name}'**
  String a11yEquipToCat(Object name);

  /// No description provided for @a11yRegenerateCat.
  ///
  /// In en, this message translates to:
  /// **'Regenerate {name}'**
  String a11yRegenerateCat(Object name);

  /// No description provided for @a11yTimerDisplay.
  ///
  /// In en, this message translates to:
  /// **'Timer: {time}'**
  String a11yTimerDisplay(Object time);

  /// No description provided for @a11yOnboardingPage.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String a11yOnboardingPage(Object current, Object total);

  /// No description provided for @a11yEditDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Edit display name: {name}'**
  String a11yEditDisplayName(Object name);

  /// No description provided for @routeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get routeNotFound;

  /// No description provided for @routeGoHome.
  ///
  /// In en, this message translates to:
  /// **'Go home'**
  String get routeGoHome;

  /// No description provided for @a11yError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get a11yError;

  /// No description provided for @a11yDeadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get a11yDeadline;

  /// No description provided for @a11yReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get a11yReminder;

  /// No description provided for @a11yFocusMeditation.
  ///
  /// In en, this message translates to:
  /// **'Focus meditation'**
  String get a11yFocusMeditation;

  /// No description provided for @a11yUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get a11yUnlocked;

  /// No description provided for @a11ySelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get a11ySelected;

  /// No description provided for @a11yDynamicWallpaperColor.
  ///
  /// In en, this message translates to:
  /// **'Dynamic wallpaper color'**
  String get a11yDynamicWallpaperColor;

  /// No description provided for @awarenessTitle.
  ///
  /// In en, this message translates to:
  /// **'Awareness'**
  String get awarenessTitle;

  /// No description provided for @awarenessTabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get awarenessTabToday;

  /// No description provided for @awarenessTabThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get awarenessTabThisWeek;

  /// No description provided for @awarenessTabReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get awarenessTabReview;

  /// No description provided for @moodVeryHappy.
  ///
  /// In en, this message translates to:
  /// **'Very Happy'**
  String get moodVeryHappy;

  /// No description provided for @moodCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get moodCalm;

  /// No description provided for @moodDown.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get moodDown;

  /// No description provided for @moodVeryDown.
  ///
  /// In en, this message translates to:
  /// **'Very Down'**
  String get moodVeryDown;

  /// No description provided for @awarenessLightPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'What made you smile today?'**
  String get awarenessLightPlaceholder;

  /// No description provided for @awarenessLightSaved.
  ///
  /// In en, this message translates to:
  /// **'Light recorded ✨'**
  String get awarenessLightSaved;

  /// No description provided for @awarenessLightEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get awarenessLightEdit;

  /// No description provided for @weeklyReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Review'**
  String get weeklyReviewTitle;

  /// No description provided for @weeklyReviewHappyMoment.
  ///
  /// In en, this message translates to:
  /// **'Happy Moment #{number}'**
  String weeklyReviewHappyMoment(int number);

  /// No description provided for @weeklyReviewHappyMomentHint.
  ///
  /// In en, this message translates to:
  /// **'What made you happy this week?'**
  String get weeklyReviewHappyMomentHint;

  /// No description provided for @weeklyReviewGratitude.
  ///
  /// In en, this message translates to:
  /// **'Gratitude'**
  String get weeklyReviewGratitude;

  /// No description provided for @weeklyReviewGratitudeHint.
  ///
  /// In en, this message translates to:
  /// **'Who or what are you grateful for?'**
  String get weeklyReviewGratitudeHint;

  /// No description provided for @weeklyReviewLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get weeklyReviewLearning;

  /// No description provided for @weeklyReviewLearningHint.
  ///
  /// In en, this message translates to:
  /// **'What did you learn this week?'**
  String get weeklyReviewLearningHint;

  /// No description provided for @weeklyReviewSave.
  ///
  /// In en, this message translates to:
  /// **'Save Review'**
  String get weeklyReviewSave;

  /// No description provided for @weeklyReviewSaved.
  ///
  /// In en, this message translates to:
  /// **'Review saved ✨'**
  String get weeklyReviewSaved;

  /// No description provided for @worryProcessorTitle.
  ///
  /// In en, this message translates to:
  /// **'Worry Processor'**
  String get worryProcessorTitle;

  /// No description provided for @worryDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'What\'s bothering you?'**
  String get worryDescriptionHint;

  /// No description provided for @worrySolutionHint.
  ///
  /// In en, this message translates to:
  /// **'What could you do about it?'**
  String get worrySolutionHint;

  /// No description provided for @worryStatusOngoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get worryStatusOngoing;

  /// No description provided for @worryStatusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get worryStatusResolved;

  /// No description provided for @worryStatusDisappeared.
  ///
  /// In en, this message translates to:
  /// **'Gone'**
  String get worryStatusDisappeared;

  /// No description provided for @worryAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Worry'**
  String get worryAdd;

  /// No description provided for @worrySave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get worrySave;

  /// No description provided for @worryResolvedSection.
  ///
  /// In en, this message translates to:
  /// **'Resolved & Gone'**
  String get worryResolvedSection;

  /// No description provided for @worryManageAll.
  ///
  /// In en, this message translates to:
  /// **'Manage all worries'**
  String get worryManageAll;

  /// No description provided for @awarenessEmptyLightTitle.
  ///
  /// In en, this message translates to:
  /// **'No light recorded yet'**
  String get awarenessEmptyLightTitle;

  /// No description provided for @awarenessEmptyLightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Whenever you\'re ready ✨'**
  String get awarenessEmptyLightSubtitle;

  /// No description provided for @awarenessEmptyLightAction.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get awarenessEmptyLightAction;

  /// No description provided for @awarenessEmptyReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Take your time'**
  String get awarenessEmptyReviewTitle;

  /// No description provided for @awarenessEmptyReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review when you feel like it 🐱'**
  String get awarenessEmptyReviewSubtitle;

  /// No description provided for @awarenessEmptyReviewAction.
  ///
  /// In en, this message translates to:
  /// **'Start Review'**
  String get awarenessEmptyReviewAction;

  /// No description provided for @awarenessEmptyHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Every light matters'**
  String get awarenessEmptyHistoryTitle;

  /// No description provided for @awarenessEmptyHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your history will appear here'**
  String get awarenessEmptyHistorySubtitle;

  /// No description provided for @awarenessEmptyWorriesTitle.
  ///
  /// In en, this message translates to:
  /// **'No worries? Great! 🎉'**
  String get awarenessEmptyWorriesTitle;

  /// No description provided for @awarenessEmptyWorriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'That\'s wonderful'**
  String get awarenessEmptyWorriesSubtitle;

  /// No description provided for @catReactVeryHappy.
  ///
  /// In en, this message translates to:
  /// **'So happy today! Meow~ 🎉'**
  String get catReactVeryHappy;

  /// No description provided for @catReactHappy.
  ///
  /// In en, this message translates to:
  /// **'Another light recorded ✨'**
  String get catReactHappy;

  /// No description provided for @catReactCalm.
  ///
  /// In en, this message translates to:
  /// **'A calm day is a good day 🍃'**
  String get catReactCalm;

  /// No description provided for @catReactDown.
  ///
  /// In en, this message translates to:
  /// **'I\'m here with you 💛'**
  String get catReactDown;

  /// No description provided for @catReactVeryDown.
  ///
  /// In en, this message translates to:
  /// **'Not going anywhere 🫂'**
  String get catReactVeryDown;

  /// No description provided for @awarenessBridgePrompt.
  ///
  /// In en, this message translates to:
  /// **'What made you smile today? ✨'**
  String get awarenessBridgePrompt;

  /// No description provided for @awarenessBridgeRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get awarenessBridgeRecord;

  /// No description provided for @awarenessBridgeSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get awarenessBridgeSkip;

  /// No description provided for @awarenessHabitsSection.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Habits'**
  String get awarenessHabitsSection;

  /// No description provided for @awarenessHabitsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No habits yet. Adopt a cat to start!'**
  String get awarenessHabitsEmpty;

  /// No description provided for @awarenessReviewComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get awarenessReviewComingSoon;

  /// No description provided for @awarenessMoodRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select today\'s mood'**
  String get awarenessMoodRequired;

  /// No description provided for @awarenessSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed, please try again'**
  String get awarenessSaveFailed;

  /// No description provided for @awarenessLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load, please go back and retry'**
  String get awarenessLoadFailed;

  /// No description provided for @awarenessSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get awarenessSaved;

  /// No description provided for @worryDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Please describe your worry'**
  String get worryDescriptionRequired;

  /// No description provided for @worryLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load worry'**
  String get worryLoadFailed;

  /// No description provided for @awarenessLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please log in first'**
  String get awarenessLoginRequired;

  /// No description provided for @tagCustom.
  ///
  /// In en, this message translates to:
  /// **'+Custom'**
  String get tagCustom;

  /// No description provided for @homeTabAwareness.
  ///
  /// In en, this message translates to:
  /// **'Awareness'**
  String get homeTabAwareness;

  /// No description provided for @homeTabHabits.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get homeTabHabits;

  /// No description provided for @monthlyRitualSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'A new month — pick a habit to focus on'**
  String get monthlyRitualSetupTitle;

  /// No description provided for @monthlyRitualSetupDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose your focus habit, set a flexible goal, and promise yourself a reward.'**
  String get monthlyRitualSetupDesc;

  /// No description provided for @monthlyRitualSetupButton.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get monthlyRitualSetupButton;

  /// No description provided for @monthlyRitualDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly ritual'**
  String get monthlyRitualDialogTitle;

  /// No description provided for @monthlyRitualHabitLabel.
  ///
  /// In en, this message translates to:
  /// **'Focus habit'**
  String get monthlyRitualHabitLabel;

  /// No description provided for @monthlyRitualTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Target days'**
  String get monthlyRitualTargetLabel;

  /// No description provided for @monthlyRitualTargetValue.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String monthlyRitualTargetValue(int count);

  /// No description provided for @monthlyRitualRewardHint.
  ///
  /// In en, this message translates to:
  /// **'Reward myself with...'**
  String get monthlyRitualRewardHint;

  /// No description provided for @monthlyRitualRewardLabel.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get monthlyRitualRewardLabel;

  /// No description provided for @monthlyRitualProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{target} days done ✨'**
  String monthlyRitualProgress(int completed, int target);

  /// No description provided for @monthlyRitualAchieved.
  ///
  /// In en, this message translates to:
  /// **'Goal achieved! 🎉'**
  String get monthlyRitualAchieved;

  /// No description provided for @monthlyRitualEncouragement.
  ///
  /// In en, this message translates to:
  /// **'Every day counts'**
  String get monthlyRitualEncouragement;

  /// No description provided for @achievementLightFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Light'**
  String get achievementLightFirstName;

  /// No description provided for @achievementLightFirstDesc.
  ///
  /// In en, this message translates to:
  /// **'Record your first daily light'**
  String get achievementLightFirstDesc;

  /// No description provided for @achievementLight7Name.
  ///
  /// In en, this message translates to:
  /// **'Week of Light'**
  String get achievementLight7Name;

  /// No description provided for @achievementLight7Desc.
  ///
  /// In en, this message translates to:
  /// **'Record daily light for 7 days (cumulative)'**
  String get achievementLight7Desc;

  /// No description provided for @achievementLight30Name.
  ///
  /// In en, this message translates to:
  /// **'Month of Light'**
  String get achievementLight30Name;

  /// No description provided for @achievementLight30Desc.
  ///
  /// In en, this message translates to:
  /// **'Record daily light for 30 days (cumulative)'**
  String get achievementLight30Desc;

  /// No description provided for @achievementLight100Name.
  ///
  /// In en, this message translates to:
  /// **'Century of Light'**
  String get achievementLight100Name;

  /// No description provided for @achievementLight100Desc.
  ///
  /// In en, this message translates to:
  /// **'Record daily light for 100 days (cumulative)'**
  String get achievementLight100Desc;

  /// No description provided for @achievementReviewFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Review'**
  String get achievementReviewFirstName;

  /// No description provided for @achievementReviewFirstDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete your first weekly review'**
  String get achievementReviewFirstDesc;

  /// No description provided for @achievementReview4Name.
  ///
  /// In en, this message translates to:
  /// **'Monthly Reviewer'**
  String get achievementReview4Name;

  /// No description provided for @achievementReview4Desc.
  ///
  /// In en, this message translates to:
  /// **'Complete 4 weekly reviews (cumulative)'**
  String get achievementReview4Desc;

  /// No description provided for @achievementWorryResolved1Name.
  ///
  /// In en, this message translates to:
  /// **'First Release'**
  String get achievementWorryResolved1Name;

  /// No description provided for @achievementWorryResolved1Desc.
  ///
  /// In en, this message translates to:
  /// **'Resolve or release your first worry'**
  String get achievementWorryResolved1Desc;

  /// No description provided for @achievementWorryResolved10Name.
  ///
  /// In en, this message translates to:
  /// **'Worry Whisperer'**
  String get achievementWorryResolved10Name;

  /// No description provided for @achievementWorryResolved10Desc.
  ///
  /// In en, this message translates to:
  /// **'Resolve or release 10 worries (cumulative)'**
  String get achievementWorryResolved10Desc;

  /// No description provided for @notifBedtimeLight.
  ///
  /// In en, this message translates to:
  /// **'How was your day? Take a moment to notice something good ✨'**
  String get notifBedtimeLight;

  /// No description provided for @notifWeeklyReview.
  ///
  /// In en, this message translates to:
  /// **'Sunday evening — a good time to look back at your week 📖'**
  String get notifWeeklyReview;

  /// No description provided for @notifMonthlyRitual.
  ///
  /// In en, this message translates to:
  /// **'A new month begins! Pick a habit to focus on this month 🌙'**
  String get notifMonthlyRitual;

  /// No description provided for @notifGentleReengagement.
  ///
  /// In en, this message translates to:
  /// **'No pressure — come back whenever you\'re ready 🌿'**
  String get notifGentleReengagement;

  /// No description provided for @calendarMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get calendarMon;

  /// No description provided for @calendarTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get calendarTue;

  /// No description provided for @calendarWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get calendarWed;

  /// No description provided for @calendarThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get calendarThu;

  /// No description provided for @calendarFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get calendarFri;

  /// No description provided for @calendarSat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get calendarSat;

  /// No description provided for @calendarSun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get calendarSun;

  /// No description provided for @historyWeeklyReviews.
  ///
  /// In en, this message translates to:
  /// **'Weekly Reviews'**
  String get historyWeeklyReviews;

  /// No description provided for @historyHappyMoments.
  ///
  /// In en, this message translates to:
  /// **'{count} happy moments'**
  String historyHappyMoments(int count);

  /// No description provided for @historyWeekRange.
  ///
  /// In en, this message translates to:
  /// **'{startDate} - {endDate}'**
  String historyWeekRange(String startDate, String endDate);

  /// No description provided for @dailyDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Detail'**
  String get dailyDetailTitle;

  /// No description provided for @dailyDetailEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Record'**
  String get dailyDetailEdit;

  /// No description provided for @dailyDetailLight.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Light'**
  String get dailyDetailLight;

  /// No description provided for @dailyDetailTimeline.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Timeline'**
  String get dailyDetailTimeline;

  /// No description provided for @dailyDetailNoRecord.
  ///
  /// In en, this message translates to:
  /// **'No record for this day'**
  String get dailyDetailNoRecord;

  /// No description provided for @dailyDetailGoRecord.
  ///
  /// In en, this message translates to:
  /// **'Go Record'**
  String get dailyDetailGoRecord;

  /// No description provided for @awarenessStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Awareness Stats'**
  String get awarenessStatsTitle;

  /// No description provided for @awarenessStatsMoodDistribution.
  ///
  /// In en, this message translates to:
  /// **'Mood Distribution'**
  String get awarenessStatsMoodDistribution;

  /// No description provided for @awarenessStatsLightDays.
  ///
  /// In en, this message translates to:
  /// **'Light Days'**
  String get awarenessStatsLightDays;

  /// No description provided for @awarenessStatsWeeklyReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get awarenessStatsWeeklyReviews;

  /// No description provided for @awarenessStatsResolutionRate.
  ///
  /// In en, this message translates to:
  /// **'Resolution Rate'**
  String get awarenessStatsResolutionRate;

  /// No description provided for @awarenessStatsTopTags.
  ///
  /// In en, this message translates to:
  /// **'Top Tags'**
  String get awarenessStatsTopTags;

  /// No description provided for @awarenessStatsMonthlyChallenge.
  ///
  /// In en, this message translates to:
  /// **'Monthly Challenge'**
  String get awarenessStatsMonthlyChallenge;

  /// No description provided for @awarenessStatsStartRecording.
  ///
  /// In en, this message translates to:
  /// **'Start recording your first light'**
  String get awarenessStatsStartRecording;

  /// No description provided for @timelineEventHint.
  ///
  /// In en, this message translates to:
  /// **'What happened?'**
  String get timelineEventHint;

  /// No description provided for @tabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tabToday;

  /// No description provided for @tabJourney.
  ///
  /// In en, this message translates to:
  /// **'Journey'**
  String get tabJourney;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get tabProfile;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get onboardingWelcome;

  /// No description provided for @onboardingLumiIntro.
  ///
  /// In en, this message translates to:
  /// **'This is LUMI'**
  String get onboardingLumiIntro;

  /// No description provided for @onboardingSlogan.
  ///
  /// In en, this message translates to:
  /// **'Every line you write adds a star to your inner universe'**
  String get onboardingSlogan;

  /// No description provided for @onboardingNamePrompt.
  ///
  /// In en, this message translates to:
  /// **'The owner of this journal is'**
  String get onboardingNamePrompt;

  /// No description provided for @onboardingNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get onboardingNameHint;

  /// No description provided for @onboardingBirthdayPrompt.
  ///
  /// In en, this message translates to:
  /// **'Your birthday'**
  String get onboardingBirthdayPrompt;

  /// No description provided for @onboardingBirthdayMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get onboardingBirthdayMonth;

  /// No description provided for @onboardingBirthdayDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get onboardingBirthdayDay;

  /// No description provided for @onboardingStartDatePrompt.
  ///
  /// In en, this message translates to:
  /// **'When would you like to start this journey?'**
  String get onboardingStartDatePrompt;

  /// No description provided for @onboardingThreeThings.
  ///
  /// In en, this message translates to:
  /// **'LUMI has just three little things'**
  String get onboardingThreeThings;

  /// No description provided for @onboardingDailyLight.
  ///
  /// In en, this message translates to:
  /// **'Write one line before bed'**
  String get onboardingDailyLight;

  /// No description provided for @onboardingDailyLightSub.
  ///
  /// In en, this message translates to:
  /// **'Today\'s little light'**
  String get onboardingDailyLightSub;

  /// No description provided for @onboardingWeeklyReview.
  ///
  /// In en, this message translates to:
  /// **'Weekend review'**
  String get onboardingWeeklyReview;

  /// No description provided for @onboardingWeeklyReviewSub.
  ///
  /// In en, this message translates to:
  /// **'Three happy moments'**
  String get onboardingWeeklyReviewSub;

  /// No description provided for @onboardingWorryJar.
  ///
  /// In en, this message translates to:
  /// **'Write down worries'**
  String get onboardingWorryJar;

  /// No description provided for @onboardingWorryJarSub.
  ///
  /// In en, this message translates to:
  /// **'Put them in the worry jar'**
  String get onboardingWorryJarSub;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Start the journey'**
  String get onboardingStart;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @todayGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String todayGreeting(String name);

  /// No description provided for @quickLightPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'What made you smile today?'**
  String get quickLightPlaceholder;

  /// No description provided for @recordLight.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get recordLight;

  /// No description provided for @noHabitsYet.
  ///
  /// In en, this message translates to:
  /// **'No habits yet. You can set them in monthly plans.'**
  String get noHabitsYet;

  /// No description provided for @segmentWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get segmentWeek;

  /// No description provided for @segmentMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get segmentMonth;

  /// No description provided for @segmentYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get segmentYear;

  /// No description provided for @segmentExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get segmentExplore;

  /// No description provided for @featureLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get featureLockedTitle;

  /// No description provided for @featureLockedMessage.
  ///
  /// In en, this message translates to:
  /// **'Record {days} more days to unlock. No rush.'**
  String featureLockedMessage(int days);

  /// No description provided for @weeklyPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Plan'**
  String get weeklyPlanTitle;

  /// No description provided for @oneLineForSelf.
  ///
  /// In en, this message translates to:
  /// **'Write a line for yourself this week'**
  String get oneLineForSelf;

  /// No description provided for @urgentImportant.
  ///
  /// In en, this message translates to:
  /// **'Must Do'**
  String get urgentImportant;

  /// No description provided for @importantNotUrgent.
  ///
  /// In en, this message translates to:
  /// **'Should Do'**
  String get importantNotUrgent;

  /// No description provided for @urgentNotImportant.
  ///
  /// In en, this message translates to:
  /// **'Need to Do'**
  String get urgentNotImportant;

  /// No description provided for @wantToDo.
  ///
  /// In en, this message translates to:
  /// **'Want to Do'**
  String get wantToDo;

  /// No description provided for @monthlyGoals.
  ///
  /// In en, this message translates to:
  /// **'Monthly Goals'**
  String get monthlyGoals;

  /// No description provided for @smallWinChallenge.
  ///
  /// In en, this message translates to:
  /// **'Small Win Challenge'**
  String get smallWinChallenge;

  /// No description provided for @monthlyPassion.
  ///
  /// In en, this message translates to:
  /// **'Monthly Passion'**
  String get monthlyPassion;

  /// No description provided for @moodTracker.
  ///
  /// In en, this message translates to:
  /// **'Mood Tracker'**
  String get moodTracker;

  /// No description provided for @monthlyMemory.
  ///
  /// In en, this message translates to:
  /// **'Monthly Memory'**
  String get monthlyMemory;

  /// No description provided for @monthlyAchievement.
  ///
  /// In en, this message translates to:
  /// **'Monthly Achievement'**
  String get monthlyAchievement;

  /// No description provided for @yearlyMessages.
  ///
  /// In en, this message translates to:
  /// **'Yearly Messages'**
  String get yearlyMessages;

  /// No description provided for @growthPlan.
  ///
  /// In en, this message translates to:
  /// **'Growth Plan'**
  String get growthPlan;

  /// No description provided for @annualCalendar.
  ///
  /// In en, this message translates to:
  /// **'Annual Calendar'**
  String get annualCalendar;

  /// No description provided for @lumiStats.
  ///
  /// In en, this message translates to:
  /// **'My Stars'**
  String get lumiStats;

  /// No description provided for @totalStars.
  ///
  /// In en, this message translates to:
  /// **'{count} stars'**
  String totalStars(int count);

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get longestStreak;

  /// No description provided for @catCompanion.
  ///
  /// In en, this message translates to:
  /// **'Cat Companion'**
  String get catCompanion;

  /// No description provided for @growthReview.
  ///
  /// In en, this message translates to:
  /// **'Growth Review'**
  String get growthReview;

  /// No description provided for @greetingLateNight.
  ///
  /// In en, this message translates to:
  /// **'Late night, {name}'**
  String greetingLateNight(String name);

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String greetingMorning(String name);

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}'**
  String greetingAfternoon(String name);

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}'**
  String greetingEvening(String name);

  /// No description provided for @greetingLateNightNoName.
  ///
  /// In en, this message translates to:
  /// **'Late night'**
  String get greetingLateNightNoName;

  /// No description provided for @greetingMorningNoName.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorningNoName;

  /// No description provided for @greetingAfternoonNoName.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoonNoName;

  /// No description provided for @greetingEveningNoName.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEveningNoName;

  /// No description provided for @journeyTitle.
  ///
  /// In en, this message translates to:
  /// **'Journey'**
  String get journeyTitle;

  /// No description provided for @journeySegmentWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get journeySegmentWeek;

  /// No description provided for @journeySegmentMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get journeySegmentMonth;

  /// No description provided for @journeySegmentYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get journeySegmentYear;

  /// No description provided for @journeySegmentExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get journeySegmentExplore;

  /// No description provided for @journeyMonthlyView.
  ///
  /// In en, this message translates to:
  /// **'Monthly View'**
  String get journeyMonthlyView;

  /// No description provided for @journeyYearlyView.
  ///
  /// In en, this message translates to:
  /// **'Yearly View'**
  String get journeyYearlyView;

  /// No description provided for @journeyExploreActivities.
  ///
  /// In en, this message translates to:
  /// **'Explore Activities'**
  String get journeyExploreActivities;

  /// No description provided for @journeyEditMonthlyPlan.
  ///
  /// In en, this message translates to:
  /// **'Edit monthly plan'**
  String get journeyEditMonthlyPlan;

  /// No description provided for @journeyEditYearlyPlan.
  ///
  /// In en, this message translates to:
  /// **'Edit yearly plan'**
  String get journeyEditYearlyPlan;

  /// No description provided for @quickLightTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s little light'**
  String get quickLightTitle;

  /// No description provided for @quickLightHint.
  ///
  /// In en, this message translates to:
  /// **'Write how you feel today...'**
  String get quickLightHint;

  /// No description provided for @quickLightRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get quickLightRecord;

  /// No description provided for @quickLightSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get quickLightSaveSuccess;

  /// No description provided for @quickLightSaveError.
  ///
  /// In en, this message translates to:
  /// **'Save failed, please try again'**
  String get quickLightSaveError;

  /// No description provided for @habitSnapshotTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s habits'**
  String get habitSnapshotTitle;

  /// No description provided for @habitSnapshotEmpty.
  ///
  /// In en, this message translates to:
  /// **'No habits yet. Set them in your journey.'**
  String get habitSnapshotEmpty;

  /// No description provided for @habitSnapshotLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get habitSnapshotLoadError;

  /// No description provided for @worryJarTitle.
  ///
  /// In en, this message translates to:
  /// **'Worry jar'**
  String get worryJarTitle;

  /// No description provided for @worryJarLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get worryJarLoadError;

  /// No description provided for @weeklyReviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'Record this week\'s happy moments'**
  String get weeklyReviewEmpty;

  /// No description provided for @weeklyReviewHappyMoments.
  ///
  /// In en, this message translates to:
  /// **'Happy moments'**
  String get weeklyReviewHappyMoments;

  /// No description provided for @weeklyReviewLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get weeklyReviewLoadError;

  /// No description provided for @weeklyPlanCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly plan'**
  String get weeklyPlanCardTitle;

  /// No description provided for @weeklyPlanItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String weeklyPlanItemCount(int count);

  /// No description provided for @weeklyPlanEmpty.
  ///
  /// In en, this message translates to:
  /// **'Make a weekly plan'**
  String get weeklyPlanEmpty;

  /// No description provided for @weekMoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Week mood'**
  String get weekMoodTitle;

  /// No description provided for @weekMoodLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load mood'**
  String get weekMoodLoadError;

  /// No description provided for @featureLockedDaysRemaining.
  ///
  /// In en, this message translates to:
  /// **'Record {remaining} more days to unlock'**
  String featureLockedDaysRemaining(int remaining);

  /// No description provided for @featureLockedSoon.
  ///
  /// In en, this message translates to:
  /// **'Unlocking soon'**
  String get featureLockedSoon;

  /// No description provided for @weeklyPlanScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly plan'**
  String get weeklyPlanScreenTitle;

  /// No description provided for @weeklyPlanSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get weeklyPlanSave;

  /// No description provided for @weeklyPlanSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get weeklyPlanSaveSuccess;

  /// No description provided for @weeklyPlanSaveError.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get weeklyPlanSaveError;

  /// No description provided for @weeklyPlanOneLine.
  ///
  /// In en, this message translates to:
  /// **'Write a line for yourself this week'**
  String get weeklyPlanOneLine;

  /// No description provided for @weeklyPlanOneLineHint.
  ///
  /// In en, this message translates to:
  /// **'This week I want to...'**
  String get weeklyPlanOneLineHint;

  /// No description provided for @weeklyPlanUrgentImportant.
  ///
  /// In en, this message translates to:
  /// **'Urgent & Important'**
  String get weeklyPlanUrgentImportant;

  /// No description provided for @weeklyPlanImportantNotUrgent.
  ///
  /// In en, this message translates to:
  /// **'Important, Not Urgent'**
  String get weeklyPlanImportantNotUrgent;

  /// No description provided for @weeklyPlanUrgentNotImportant.
  ///
  /// In en, this message translates to:
  /// **'Urgent, Not Important'**
  String get weeklyPlanUrgentNotImportant;

  /// No description provided for @weeklyPlanNotUrgentNotImportant.
  ///
  /// In en, this message translates to:
  /// **'Not Urgent, Not Important'**
  String get weeklyPlanNotUrgentNotImportant;

  /// No description provided for @weeklyPlanAddHint.
  ///
  /// In en, this message translates to:
  /// **'Add...'**
  String get weeklyPlanAddHint;

  /// No description provided for @weeklyPlanMustDo.
  ///
  /// In en, this message translates to:
  /// **'Must do'**
  String get weeklyPlanMustDo;

  /// No description provided for @weeklyPlanShouldDo.
  ///
  /// In en, this message translates to:
  /// **'Should do'**
  String get weeklyPlanShouldDo;

  /// No description provided for @weeklyPlanNeedToDo.
  ///
  /// In en, this message translates to:
  /// **'Need to do'**
  String get weeklyPlanNeedToDo;

  /// No description provided for @weeklyPlanWantToDo.
  ///
  /// In en, this message translates to:
  /// **'Want to do'**
  String get weeklyPlanWantToDo;

  /// No description provided for @monthlyCalendarYearMonth.
  ///
  /// In en, this message translates to:
  /// **'{year}/{month}'**
  String monthlyCalendarYearMonth(int year, int month);

  /// No description provided for @monthlyCalendarLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get monthlyCalendarLoadError;

  /// No description provided for @monthlyGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly goals'**
  String get monthlyGoalsTitle;

  /// No description provided for @monthlyGoalHint.
  ///
  /// In en, this message translates to:
  /// **'Goal {index}'**
  String monthlyGoalHint(int index);

  /// No description provided for @monthlySaveError.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get monthlySaveError;

  /// No description provided for @monthlyMemoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly memory'**
  String get monthlyMemoryTitle;

  /// No description provided for @monthlyMemoryHint.
  ///
  /// In en, this message translates to:
  /// **'The most beautiful memory this month is...'**
  String get monthlyMemoryHint;

  /// No description provided for @monthlyAchievementTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly achievement'**
  String get monthlyAchievementTitle;

  /// No description provided for @monthlyAchievementHint.
  ///
  /// In en, this message translates to:
  /// **'My proudest achievement this month is...'**
  String get monthlyAchievementHint;

  /// No description provided for @yearlyMessagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Yearly messages'**
  String get yearlyMessagesTitle;

  /// No description provided for @yearlyMessageBecome.
  ///
  /// In en, this message translates to:
  /// **'This year I hope to become...'**
  String get yearlyMessageBecome;

  /// No description provided for @yearlyMessageGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals to achieve'**
  String get yearlyMessageGoals;

  /// No description provided for @yearlyMessageBreakthrough.
  ///
  /// In en, this message translates to:
  /// **'Breakthrough completion'**
  String get yearlyMessageBreakthrough;

  /// No description provided for @yearlyMessageDontDo.
  ///
  /// In en, this message translates to:
  /// **'Don\'t do (saying no makes room for what matters)'**
  String get yearlyMessageDontDo;

  /// No description provided for @yearlyMessageKeyword.
  ///
  /// In en, this message translates to:
  /// **'Year keyword (e.g. Focus / Brave / Patient / Kind)'**
  String get yearlyMessageKeyword;

  /// No description provided for @yearlyMessageFutureSelf.
  ///
  /// In en, this message translates to:
  /// **'To my dear future self'**
  String get yearlyMessageFutureSelf;

  /// No description provided for @yearlyMessageMotto.
  ///
  /// In en, this message translates to:
  /// **'My motto'**
  String get yearlyMessageMotto;

  /// No description provided for @growthPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Growth plan'**
  String get growthPlanTitle;

  /// No description provided for @growthPlanHint.
  ///
  /// In en, this message translates to:
  /// **'My plan...'**
  String get growthPlanHint;

  /// No description provided for @growthPlanSaveError.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get growthPlanSaveError;

  /// No description provided for @growthDimensionHealth.
  ///
  /// In en, this message translates to:
  /// **'Physical health'**
  String get growthDimensionHealth;

  /// No description provided for @growthDimensionEmotion.
  ///
  /// In en, this message translates to:
  /// **'Emotional wellness'**
  String get growthDimensionEmotion;

  /// No description provided for @growthDimensionRelationship.
  ///
  /// In en, this message translates to:
  /// **'Relationships'**
  String get growthDimensionRelationship;

  /// No description provided for @growthDimensionCareer.
  ///
  /// In en, this message translates to:
  /// **'Career growth'**
  String get growthDimensionCareer;

  /// No description provided for @growthDimensionFinance.
  ///
  /// In en, this message translates to:
  /// **'Financial wellness'**
  String get growthDimensionFinance;

  /// No description provided for @growthDimensionLearning.
  ///
  /// In en, this message translates to:
  /// **'Continuous learning'**
  String get growthDimensionLearning;

  /// No description provided for @growthDimensionCreativity.
  ///
  /// In en, this message translates to:
  /// **'Creativity'**
  String get growthDimensionCreativity;

  /// No description provided for @growthDimensionSpirituality.
  ///
  /// In en, this message translates to:
  /// **'Inner growth'**
  String get growthDimensionSpirituality;

  /// No description provided for @smallWinTitle.
  ///
  /// In en, this message translates to:
  /// **'Small win challenge'**
  String get smallWinTitle;

  /// No description provided for @smallWinEmpty.
  ///
  /// In en, this message translates to:
  /// **'Set a {days}-day challenge, a little bit every day'**
  String smallWinEmpty(int days);

  /// No description provided for @smallWinReward.
  ///
  /// In en, this message translates to:
  /// **'Reward: {reward}'**
  String smallWinReward(String reward);

  /// No description provided for @smallWinLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get smallWinLoadError;

  /// No description provided for @smallWinLawVisible.
  ///
  /// In en, this message translates to:
  /// **'Visible'**
  String get smallWinLawVisible;

  /// No description provided for @smallWinLawAttractive.
  ///
  /// In en, this message translates to:
  /// **'Attractive'**
  String get smallWinLawAttractive;

  /// No description provided for @smallWinLawEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get smallWinLawEasy;

  /// No description provided for @smallWinLawRewarding.
  ///
  /// In en, this message translates to:
  /// **'Rewarding'**
  String get smallWinLawRewarding;

  /// No description provided for @moodTrackerTitle.
  ///
  /// In en, this message translates to:
  /// **'Mood tracker'**
  String get moodTrackerTitle;

  /// No description provided for @moodTrackerLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get moodTrackerLoadError;

  /// No description provided for @moodTrackerCount.
  ///
  /// In en, this message translates to:
  /// **'{count} times'**
  String moodTrackerCount(int count);

  /// No description provided for @habitTrackerTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly passion & persistence'**
  String get habitTrackerTitle;

  /// No description provided for @habitTrackerComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Habit tracking is under development'**
  String get habitTrackerComingSoon;

  /// No description provided for @habitTrackerComingSoonHint.
  ///
  /// In en, this message translates to:
  /// **'Set your habits in the small win challenge'**
  String get habitTrackerComingSoonHint;

  /// No description provided for @listsTitle.
  ///
  /// In en, this message translates to:
  /// **'My lists'**
  String get listsTitle;

  /// No description provided for @listBookTitle.
  ///
  /// In en, this message translates to:
  /// **'Book list'**
  String get listBookTitle;

  /// No description provided for @listMovieTitle.
  ///
  /// In en, this message translates to:
  /// **'Movie list'**
  String get listMovieTitle;

  /// No description provided for @listCustomTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom list'**
  String get listCustomTitle;

  /// No description provided for @listItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String listItemCount(int count);

  /// No description provided for @listDetailBookTitle.
  ///
  /// In en, this message translates to:
  /// **'My book list'**
  String get listDetailBookTitle;

  /// No description provided for @listDetailMovieTitle.
  ///
  /// In en, this message translates to:
  /// **'My movie list'**
  String get listDetailMovieTitle;

  /// No description provided for @listDetailCustomTitle.
  ///
  /// In en, this message translates to:
  /// **'My list'**
  String get listDetailCustomTitle;

  /// No description provided for @listDetailSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get listDetailSave;

  /// No description provided for @listDetailSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get listDetailSaveSuccess;

  /// No description provided for @listDetailSaveError.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get listDetailSaveError;

  /// No description provided for @listDetailCustomNameLabel.
  ///
  /// In en, this message translates to:
  /// **'List name'**
  String get listDetailCustomNameLabel;

  /// No description provided for @listDetailCustomNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. My podcast list'**
  String get listDetailCustomNameHint;

  /// No description provided for @listDetailItemTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get listDetailItemTitleHint;

  /// No description provided for @listDetailItemDateHint.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get listDetailItemDateHint;

  /// No description provided for @listDetailItemGenreHint.
  ///
  /// In en, this message translates to:
  /// **'Genre / Tag'**
  String get listDetailItemGenreHint;

  /// No description provided for @listDetailItemKeywordHint.
  ///
  /// In en, this message translates to:
  /// **'Keywords / Thoughts'**
  String get listDetailItemKeywordHint;

  /// No description provided for @listDetailYearTreasure.
  ///
  /// In en, this message translates to:
  /// **'Year\'s treasure'**
  String get listDetailYearTreasure;

  /// No description provided for @listDetailYearPick.
  ///
  /// In en, this message translates to:
  /// **'Pick of the year'**
  String get listDetailYearPick;

  /// No description provided for @listDetailYearPickHint.
  ///
  /// In en, this message translates to:
  /// **'The one most worth recommending this year'**
  String get listDetailYearPickHint;

  /// No description provided for @listDetailInsight.
  ///
  /// In en, this message translates to:
  /// **'Aha moment'**
  String get listDetailInsight;

  /// No description provided for @listDetailInsightHint.
  ///
  /// In en, this message translates to:
  /// **'The biggest inspiration from reading / watching'**
  String get listDetailInsightHint;

  /// No description provided for @exploreMyMoments.
  ///
  /// In en, this message translates to:
  /// **'My moments'**
  String get exploreMyMoments;

  /// No description provided for @exploreMyMomentsDesc.
  ///
  /// In en, this message translates to:
  /// **'Record happy and highlight moments'**
  String get exploreMyMomentsDesc;

  /// No description provided for @exploreHabitPact.
  ///
  /// In en, this message translates to:
  /// **'My habit pact'**
  String get exploreHabitPact;

  /// No description provided for @exploreHabitPactDesc.
  ///
  /// In en, this message translates to:
  /// **'Design a new habit using Atomic Habits\' four laws'**
  String get exploreHabitPactDesc;

  /// No description provided for @exploreWorryUnload.
  ///
  /// In en, this message translates to:
  /// **'Worry unload day'**
  String get exploreWorryUnload;

  /// No description provided for @exploreWorryUnloadDesc.
  ///
  /// In en, this message translates to:
  /// **'Sort your worries: let go, take action, or accept'**
  String get exploreWorryUnloadDesc;

  /// No description provided for @exploreSelfPraise.
  ///
  /// In en, this message translates to:
  /// **'My cheer squad'**
  String get exploreSelfPraise;

  /// No description provided for @exploreSelfPraiseDesc.
  ///
  /// In en, this message translates to:
  /// **'Write down 5 of your strengths'**
  String get exploreSelfPraiseDesc;

  /// No description provided for @exploreSupportMap.
  ///
  /// In en, this message translates to:
  /// **'My support circle'**
  String get exploreSupportMap;

  /// No description provided for @exploreSupportMapDesc.
  ///
  /// In en, this message translates to:
  /// **'Record the people who support you'**
  String get exploreSupportMapDesc;

  /// No description provided for @exploreFutureSelf.
  ///
  /// In en, this message translates to:
  /// **'Future me'**
  String get exploreFutureSelf;

  /// No description provided for @exploreFutureSelfDesc.
  ///
  /// In en, this message translates to:
  /// **'Imagine 3 versions of your future self'**
  String get exploreFutureSelfDesc;

  /// No description provided for @exploreIdealVsReal.
  ///
  /// In en, this message translates to:
  /// **'Ideal me vs. Real me'**
  String get exploreIdealVsReal;

  /// No description provided for @exploreIdealVsRealDesc.
  ///
  /// In en, this message translates to:
  /// **'Discover where ideal and reality meet'**
  String get exploreIdealVsRealDesc;

  /// No description provided for @highlightScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'My moments'**
  String get highlightScreenTitle;

  /// No description provided for @highlightTabHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy moments'**
  String get highlightTabHappy;

  /// No description provided for @highlightTabHighlight.
  ///
  /// In en, this message translates to:
  /// **'Highlight moments'**
  String get highlightTabHighlight;

  /// No description provided for @highlightEmptyHappy.
  ///
  /// In en, this message translates to:
  /// **'No happy moments recorded yet'**
  String get highlightEmptyHappy;

  /// No description provided for @highlightEmptyHighlight.
  ///
  /// In en, this message translates to:
  /// **'No highlight moments recorded yet'**
  String get highlightEmptyHighlight;

  /// No description provided for @highlightLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load: {error}'**
  String highlightLoadError(String error);

  /// No description provided for @monthlyPlanScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly plan'**
  String get monthlyPlanScreenTitle;

  /// No description provided for @monthlyPlanSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get monthlyPlanSave;

  /// No description provided for @monthlyPlanSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get monthlyPlanSaveSuccess;

  /// No description provided for @monthlyPlanSaveError.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get monthlyPlanSaveError;

  /// No description provided for @monthlyPlanGoalsSection.
  ///
  /// In en, this message translates to:
  /// **'Monthly goals'**
  String get monthlyPlanGoalsSection;

  /// No description provided for @monthlyPlanChallengeSection.
  ///
  /// In en, this message translates to:
  /// **'Small win challenge'**
  String get monthlyPlanChallengeSection;

  /// No description provided for @monthlyPlanChallengeNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Challenge habit name'**
  String get monthlyPlanChallengeNameLabel;

  /// No description provided for @monthlyPlanChallengeNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Run 10 minutes daily'**
  String get monthlyPlanChallengeNameHint;

  /// No description provided for @monthlyPlanRewardLabel.
  ///
  /// In en, this message translates to:
  /// **'Reward after completion'**
  String get monthlyPlanRewardLabel;

  /// No description provided for @monthlyPlanRewardHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Buy a book I want'**
  String get monthlyPlanRewardHint;

  /// No description provided for @monthlyPlanSelfCareSection.
  ///
  /// In en, this message translates to:
  /// **'Self-care activities'**
  String get monthlyPlanSelfCareSection;

  /// No description provided for @monthlyPlanActivityHint.
  ///
  /// In en, this message translates to:
  /// **'Activity {index}'**
  String monthlyPlanActivityHint(int index);

  /// No description provided for @monthlyPlanMemorySection.
  ///
  /// In en, this message translates to:
  /// **'Monthly memory'**
  String get monthlyPlanMemorySection;

  /// No description provided for @monthlyPlanMemoryHint.
  ///
  /// In en, this message translates to:
  /// **'The most beautiful memory this month is...'**
  String get monthlyPlanMemoryHint;

  /// No description provided for @monthlyPlanAchievementSection.
  ///
  /// In en, this message translates to:
  /// **'Monthly achievement'**
  String get monthlyPlanAchievementSection;

  /// No description provided for @monthlyPlanAchievementHint.
  ///
  /// In en, this message translates to:
  /// **'My proudest achievement this month is...'**
  String get monthlyPlanAchievementHint;

  /// No description provided for @yearlyPlanScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'{year} Yearly plan'**
  String yearlyPlanScreenTitle(int year);

  /// No description provided for @yearlyPlanSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get yearlyPlanSave;

  /// No description provided for @yearlyPlanSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get yearlyPlanSaveSuccess;

  /// No description provided for @yearlyPlanSaveError.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get yearlyPlanSaveError;

  /// No description provided for @yearlyPlanMessagesSection.
  ///
  /// In en, this message translates to:
  /// **'Yearly messages'**
  String get yearlyPlanMessagesSection;

  /// No description provided for @yearlyPlanGrowthSection.
  ///
  /// In en, this message translates to:
  /// **'Growth plan'**
  String get yearlyPlanGrowthSection;

  /// No description provided for @growthReviewScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Growth review'**
  String get growthReviewScreenTitle;

  /// No description provided for @growthReviewMyMoments.
  ///
  /// In en, this message translates to:
  /// **'My moments'**
  String get growthReviewMyMoments;

  /// No description provided for @growthReviewEmptyMoments.
  ///
  /// In en, this message translates to:
  /// **'No highlight moments recorded yet'**
  String get growthReviewEmptyMoments;

  /// No description provided for @growthReviewMySummary.
  ///
  /// In en, this message translates to:
  /// **'My summary'**
  String get growthReviewMySummary;

  /// No description provided for @growthReviewSummaryPrompt.
  ///
  /// In en, this message translates to:
  /// **'Looking back on this journey, what would you say to yourself?'**
  String get growthReviewSummaryPrompt;

  /// No description provided for @growthReviewSmallWins.
  ///
  /// In en, this message translates to:
  /// **'Small win awards'**
  String get growthReviewSmallWins;

  /// No description provided for @growthReviewConsistentRecord.
  ///
  /// In en, this message translates to:
  /// **'Consistent recording'**
  String get growthReviewConsistentRecord;

  /// No description provided for @growthReviewRecordedDays.
  ///
  /// In en, this message translates to:
  /// **'You\'ve recorded {count} days'**
  String growthReviewRecordedDays(int count);

  /// No description provided for @growthReviewWeeklyChamp.
  ///
  /// In en, this message translates to:
  /// **'Weekly review champ'**
  String get growthReviewWeeklyChamp;

  /// No description provided for @growthReviewCompletedReviews.
  ///
  /// In en, this message translates to:
  /// **'Completed {count} weekly reviews'**
  String growthReviewCompletedReviews(int count);

  /// No description provided for @growthReviewWarmClose.
  ///
  /// In en, this message translates to:
  /// **'A warm closing'**
  String get growthReviewWarmClose;

  /// No description provided for @growthReviewEveryStar.
  ///
  /// In en, this message translates to:
  /// **'Every record is a star'**
  String get growthReviewEveryStar;

  /// No description provided for @growthReviewKeepShining.
  ///
  /// In en, this message translates to:
  /// **'You\'ve collected {count} stars. Keep shining!'**
  String growthReviewKeepShining(int count);

  /// No description provided for @futureSelfScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Future me'**
  String get futureSelfScreenTitle;

  /// No description provided for @futureSelfSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Imagine 3 versions of your future self'**
  String get futureSelfSubtitle;

  /// No description provided for @futureSelfHint.
  ///
  /// In en, this message translates to:
  /// **'No perfect answers needed, let your imagination flow'**
  String get futureSelfHint;

  /// No description provided for @futureSelfStable.
  ///
  /// In en, this message translates to:
  /// **'Stable future'**
  String get futureSelfStable;

  /// No description provided for @futureSelfStableHint.
  ///
  /// In en, this message translates to:
  /// **'If everything goes smoothly, what would your life look like?'**
  String get futureSelfStableHint;

  /// No description provided for @futureSelfFree.
  ///
  /// In en, this message translates to:
  /// **'Free future'**
  String get futureSelfFree;

  /// No description provided for @futureSelfFreeHint.
  ///
  /// In en, this message translates to:
  /// **'If there were no limits, what would you most want to do?'**
  String get futureSelfFreeHint;

  /// No description provided for @futureSelfPace.
  ///
  /// In en, this message translates to:
  /// **'Your-pace future'**
  String get futureSelfPace;

  /// No description provided for @futureSelfPaceHint.
  ///
  /// In en, this message translates to:
  /// **'Unhurried, what\'s your ideal rhythm?'**
  String get futureSelfPaceHint;

  /// No description provided for @futureSelfCoreLabel.
  ///
  /// In en, this message translates to:
  /// **'What do you truly care about?'**
  String get futureSelfCoreLabel;

  /// No description provided for @futureSelfCoreHint.
  ///
  /// In en, this message translates to:
  /// **'Look at the 3 versions above. What do they have in common? That might be what you care about most...'**
  String get futureSelfCoreHint;

  /// No description provided for @habitPactScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'My habit pact'**
  String get habitPactScreenTitle;

  /// No description provided for @habitPactStep1.
  ///
  /// In en, this message translates to:
  /// **'What habit do I want to build?'**
  String get habitPactStep1;

  /// No description provided for @habitPactCategoryLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get habitPactCategoryLearning;

  /// No description provided for @habitPactCategoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get habitPactCategoryHealth;

  /// No description provided for @habitPactCategoryRelationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get habitPactCategoryRelationship;

  /// No description provided for @habitPactCategoryHobby.
  ///
  /// In en, this message translates to:
  /// **'Hobby'**
  String get habitPactCategoryHobby;

  /// No description provided for @habitPactHabitLabel.
  ///
  /// In en, this message translates to:
  /// **'Specific habit'**
  String get habitPactHabitLabel;

  /// No description provided for @habitPactHabitHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Read 20 pages every day'**
  String get habitPactHabitHint;

  /// No description provided for @habitPactStep2.
  ///
  /// In en, this message translates to:
  /// **'Four laws of habits'**
  String get habitPactStep2;

  /// No description provided for @habitPactLawVisible.
  ///
  /// In en, this message translates to:
  /// **'Make it obvious'**
  String get habitPactLawVisible;

  /// No description provided for @habitPactLawVisibleHint.
  ///
  /// In en, this message translates to:
  /// **'I\'ll place the cue at...'**
  String get habitPactLawVisibleHint;

  /// No description provided for @habitPactLawAttractive.
  ///
  /// In en, this message translates to:
  /// **'Make it attractive'**
  String get habitPactLawAttractive;

  /// No description provided for @habitPactLawAttractiveHint.
  ///
  /// In en, this message translates to:
  /// **'I\'ll pair it with...'**
  String get habitPactLawAttractiveHint;

  /// No description provided for @habitPactLawEasy.
  ///
  /// In en, this message translates to:
  /// **'Make it easy'**
  String get habitPactLawEasy;

  /// No description provided for @habitPactLawEasyHint.
  ///
  /// In en, this message translates to:
  /// **'My minimum version is...'**
  String get habitPactLawEasyHint;

  /// No description provided for @habitPactLawRewarding.
  ///
  /// In en, this message translates to:
  /// **'Make it satisfying'**
  String get habitPactLawRewarding;

  /// No description provided for @habitPactLawRewardingHint.
  ///
  /// In en, this message translates to:
  /// **'After completing, I\'ll reward myself with...'**
  String get habitPactLawRewardingHint;

  /// No description provided for @habitPactStep3.
  ///
  /// In en, this message translates to:
  /// **'Action declaration'**
  String get habitPactStep3;

  /// No description provided for @habitPactDeclarationEmpty.
  ///
  /// In en, this message translates to:
  /// **'Fill in above to auto-generate your declaration...'**
  String get habitPactDeclarationEmpty;

  /// No description provided for @habitPactDeclarationPrefix.
  ///
  /// In en, this message translates to:
  /// **'I commit to building the habit of \"{habit}\"'**
  String habitPactDeclarationPrefix(String habit);

  /// No description provided for @habitPactDeclarationWhen.
  ///
  /// In en, this message translates to:
  /// **'when {cue}'**
  String habitPactDeclarationWhen(String cue);

  /// No description provided for @habitPactDeclarationWill.
  ///
  /// In en, this message translates to:
  /// **'I will {response}'**
  String habitPactDeclarationWill(String response);

  /// No description provided for @habitPactDeclarationThen.
  ///
  /// In en, this message translates to:
  /// **'then {reward}'**
  String habitPactDeclarationThen(String reward);

  /// No description provided for @idealVsRealScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Ideal me vs. Real me'**
  String get idealVsRealScreenTitle;

  /// No description provided for @idealVsRealIdeal.
  ///
  /// In en, this message translates to:
  /// **'Ideal me'**
  String get idealVsRealIdeal;

  /// No description provided for @idealVsRealIdealHint.
  ///
  /// In en, this message translates to:
  /// **'What kind of person do I want to be?'**
  String get idealVsRealIdealHint;

  /// No description provided for @idealVsRealReal.
  ///
  /// In en, this message translates to:
  /// **'Real me'**
  String get idealVsRealReal;

  /// No description provided for @idealVsRealRealHint.
  ///
  /// In en, this message translates to:
  /// **'What kind of person am I now?'**
  String get idealVsRealRealHint;

  /// No description provided for @idealVsRealSame.
  ///
  /// In en, this message translates to:
  /// **'What\'s similar?'**
  String get idealVsRealSame;

  /// No description provided for @idealVsRealSameHint.
  ///
  /// In en, this message translates to:
  /// **'Where do ideal and reality already overlap?'**
  String get idealVsRealSameHint;

  /// No description provided for @idealVsRealDiff.
  ///
  /// In en, this message translates to:
  /// **'What\'s different?'**
  String get idealVsRealDiff;

  /// No description provided for @idealVsRealDiffHint.
  ///
  /// In en, this message translates to:
  /// **'Where\'s the gap? How does it make you feel?'**
  String get idealVsRealDiffHint;

  /// No description provided for @idealVsRealStep.
  ///
  /// In en, this message translates to:
  /// **'To get closer to ideal, I just need one small step'**
  String get idealVsRealStep;

  /// No description provided for @idealVsRealStepHint.
  ///
  /// In en, this message translates to:
  /// **'One small thing I can do today is...'**
  String get idealVsRealStepHint;

  /// No description provided for @selfPraiseScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'My cheer squad'**
  String get selfPraiseScreenTitle;

  /// No description provided for @selfPraiseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Write down your 5 strengths'**
  String get selfPraiseSubtitle;

  /// No description provided for @selfPraiseHint.
  ///
  /// In en, this message translates to:
  /// **'Everyone deserves to be seen, especially by yourself'**
  String get selfPraiseHint;

  /// No description provided for @selfPraiseStrengthLabel.
  ///
  /// In en, this message translates to:
  /// **'Strength {index}'**
  String selfPraiseStrengthLabel(int index);

  /// No description provided for @selfPraisePrompt1.
  ///
  /// In en, this message translates to:
  /// **'My warmest quality is...'**
  String get selfPraisePrompt1;

  /// No description provided for @selfPraisePrompt2.
  ///
  /// In en, this message translates to:
  /// **'Something I\'m good at is...'**
  String get selfPraisePrompt2;

  /// No description provided for @selfPraisePrompt3.
  ///
  /// In en, this message translates to:
  /// **'People often praise me for...'**
  String get selfPraisePrompt3;

  /// No description provided for @selfPraisePrompt4.
  ///
  /// In en, this message translates to:
  /// **'I\'m proud of myself for...'**
  String get selfPraisePrompt4;

  /// No description provided for @selfPraisePrompt5.
  ///
  /// In en, this message translates to:
  /// **'What makes me unique is...'**
  String get selfPraisePrompt5;

  /// No description provided for @supportMapScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'My support circle'**
  String get supportMapScreenTitle;

  /// No description provided for @supportMapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Who\'s supporting you?'**
  String get supportMapSubtitle;

  /// No description provided for @supportMapHint.
  ///
  /// In en, this message translates to:
  /// **'Note the important people around you, to remind yourself you\'re not alone'**
  String get supportMapHint;

  /// No description provided for @supportMapNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get supportMapNameLabel;

  /// No description provided for @supportMapRelationLabel.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get supportMapRelationLabel;

  /// No description provided for @supportMapRelationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Friend / Family / Colleague'**
  String get supportMapRelationHint;

  /// No description provided for @supportMapAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get supportMapAdd;

  /// No description provided for @worryUnloadScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Worry unload day'**
  String get worryUnloadScreenTitle;

  /// No description provided for @worryUnloadLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load: {error}'**
  String worryUnloadLoadError(String error);

  /// No description provided for @worryUnloadEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No active worries'**
  String get worryUnloadEmptyTitle;

  /// No description provided for @worryUnloadEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Great! Today is a light day'**
  String get worryUnloadEmptyHint;

  /// No description provided for @worryUnloadIntro.
  ///
  /// In en, this message translates to:
  /// **'Look at your worries and sort them'**
  String get worryUnloadIntro;

  /// No description provided for @worryUnloadLetGo.
  ///
  /// In en, this message translates to:
  /// **'Can let go'**
  String get worryUnloadLetGo;

  /// No description provided for @worryUnloadTakeAction.
  ///
  /// In en, this message translates to:
  /// **'Can take action'**
  String get worryUnloadTakeAction;

  /// No description provided for @worryUnloadAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept for now'**
  String get worryUnloadAccept;

  /// No description provided for @worryUnloadResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Unload results'**
  String get worryUnloadResultTitle;

  /// No description provided for @worryUnloadSummary.
  ///
  /// In en, this message translates to:
  /// **'{label}: {count}'**
  String worryUnloadSummary(String label, int count);

  /// No description provided for @worryUnloadEncouragement.
  ///
  /// In en, this message translates to:
  /// **'Every sorting is a step forward.'**
  String get worryUnloadEncouragement;

  /// No description provided for @commonSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get commonSaved;

  /// No description provided for @commonSaveError.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get commonSaveError;

  /// No description provided for @commonLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get commonLoadError;

  /// No description provided for @momentEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit moment'**
  String get momentEditTitle;

  /// No description provided for @momentNewHappy.
  ///
  /// In en, this message translates to:
  /// **'Record a happy moment'**
  String get momentNewHappy;

  /// No description provided for @momentNewHighlight.
  ///
  /// In en, this message translates to:
  /// **'Record a highlight moment'**
  String get momentNewHighlight;

  /// No description provided for @momentDescHappy.
  ///
  /// In en, this message translates to:
  /// **'Something happy'**
  String get momentDescHappy;

  /// No description provided for @momentDescHighlight.
  ///
  /// In en, this message translates to:
  /// **'What happened'**
  String get momentDescHighlight;

  /// No description provided for @momentCompanionHappy.
  ///
  /// In en, this message translates to:
  /// **'Who were you with'**
  String get momentCompanionHappy;

  /// No description provided for @momentCompanionHighlight.
  ///
  /// In en, this message translates to:
  /// **'What I did'**
  String get momentCompanionHighlight;

  /// No description provided for @momentFeeling.
  ///
  /// In en, this message translates to:
  /// **'Feeling'**
  String get momentFeeling;

  /// No description provided for @momentDate.
  ///
  /// In en, this message translates to:
  /// **'Date (YYYY-MM-DD)'**
  String get momentDate;

  /// No description provided for @momentRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get momentRating;

  /// No description provided for @momentDescRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get momentDescRequired;

  /// No description provided for @momentWithCompanion.
  ///
  /// In en, this message translates to:
  /// **'With {companion}'**
  String momentWithCompanion(String companion);

  /// No description provided for @momentDidAction.
  ///
  /// In en, this message translates to:
  /// **'I did: {action}'**
  String momentDidAction(String action);

  /// No description provided for @annualCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'My year calendar'**
  String get annualCalendarTitle;

  /// No description provided for @annualCalendarMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'{month}'**
  String annualCalendarMonthLabel(int month);
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'pt',
    'th',
    'tr',
    'vi',
    'zh',
  ].contains(locale.languageCode);

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
    case 'de':
      return SDe();
    case 'en':
      return SEn();
    case 'es':
      return SEs();
    case 'fr':
      return SFr();
    case 'hi':
      return SHi();
    case 'id':
      return SId();
    case 'it':
      return SIt();
    case 'ja':
      return SJa();
    case 'ko':
      return SKo();
    case 'pt':
      return SPt();
    case 'th':
      return STh();
    case 'tr':
      return STr();
    case 'vi':
      return SVi();
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
