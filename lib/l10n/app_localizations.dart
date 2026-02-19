import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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

  /// No description provided for @timerGiveUp.
  ///
  /// In en, this message translates to:
  /// **'Give Up'**
  String get timerGiveUp;

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

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get profileAbout;

  /// No description provided for @profileAboutAttribution.
  ///
  /// In en, this message translates to:
  /// **'Pixel cat sprites based on pixel-cat-maker (CC BY-NC 4.0)'**
  String get profileAboutAttribution;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogout;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profileDeleteAccount;

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
  /// **'This version uses a new cat system. Your existing data needs to be cleared to continue.'**
  String get migrationMessage;

  /// No description provided for @migrationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear Data & Continue'**
  String get migrationConfirm;

  /// No description provided for @migrationCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get migrationCancel;

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

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
