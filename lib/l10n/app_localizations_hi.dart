// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class SHi extends S {
  SHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Hachimi';

  @override
  String get homeTabToday => 'आज';

  @override
  String get homeTabCatHouse => 'CatHouse';

  @override
  String get homeTabStats => 'आँकड़े';

  @override
  String get homeTabProfile => 'प्रोफ़ाइल';

  @override
  String get adoptionStepDefineHabit => 'आदत तय करें';

  @override
  String get adoptionStepAdoptCat => 'बिल्ली अपनाएँ';

  @override
  String get adoptionStepNameCat => 'नाम रखें';

  @override
  String get adoptionHabitName => 'आदत का नाम';

  @override
  String get adoptionHabitNameHint => 'जैसे: रोज़ाना पढ़ाई';

  @override
  String get adoptionDailyGoal => 'दैनिक लक्ष्य';

  @override
  String get adoptionTargetHours => 'लक्ष्य घंटे';

  @override
  String get adoptionTargetHoursHint => 'इस आदत को पूरा करने के लिए कुल घंटे';

  @override
  String adoptionMinutes(int count) {
    return '$count मिनट';
  }

  @override
  String get adoptionRefreshCat => 'कोई और देखें';

  @override
  String adoptionPersonality(String name) {
    return 'स्वभाव: $name';
  }

  @override
  String get adoptionNameYourCat => 'अपनी बिल्ली का नाम रखें';

  @override
  String get adoptionRandomName => 'रैंडम';

  @override
  String get adoptionCreate => 'आदत बनाएँ और बिल्ली अपनाएँ';

  @override
  String get adoptionNext => 'आगे';

  @override
  String get adoptionBack => 'पीछे';

  @override
  String get adoptionCatNameLabel => 'बिल्ली का नाम';

  @override
  String get adoptionCatNameHint => 'जैसे: मोची';

  @override
  String get adoptionRandomNameTooltip => 'रैंडम नाम';

  @override
  String get catHouseTitle => 'CatHouse';

  @override
  String get catHouseEmpty =>
      'अभी कोई बिल्ली नहीं! आदत बनाकर अपनी पहली बिल्ली अपनाएँ।';

  @override
  String catHouseGrowth(int minutes, int target) {
    return '$minutes / $target मिनट';
  }

  @override
  String get catDetailGrowthProgress => 'विकास प्रगति';

  @override
  String catDetailTotalMinutes(int minutes) {
    return '$minutes मिनट फ़ोकस';
  }

  @override
  String catDetailTargetMinutes(int minutes) {
    return 'लक्ष्य: $minutes मिनट';
  }

  @override
  String get catDetailRename => 'नाम बदलें';

  @override
  String get catDetailAccessories => 'एक्सेसरीज़';

  @override
  String get catDetailStartFocus => 'फ़ोकस शुरू करें';

  @override
  String get catDetailBoundHabit => 'जुड़ी आदत';

  @override
  String catDetailStage(String stage) {
    return 'चरण: $stage';
  }

  @override
  String coinBalance(int amount) {
    return '$amount सिक्के';
  }

  @override
  String coinCheckInReward(int amount) {
    return '+$amount सिक्के!';
  }

  @override
  String get coinCheckInTitle => 'दैनिक चेक-इन';

  @override
  String get coinInsufficientBalance => 'पर्याप्त सिक्के नहीं हैं';

  @override
  String get shopTitle => 'एक्सेसरी शॉप';

  @override
  String shopPrice(int price) {
    return '$price सिक्के';
  }

  @override
  String get shopPurchase => 'ख़रीदें';

  @override
  String get shopEquipped => 'पहना हुआ';

  @override
  String focusCompleteMinutes(int minutes) {
    return '+$minutes मिनट';
  }

  @override
  String get focusCompleteStageUp => 'चरण बढ़ा!';

  @override
  String get focusCompleteGreatJob => 'शाबाश!';

  @override
  String get focusCompleteDone => 'हो गया';

  @override
  String get focusCompleteItsOkay => 'कोई बात नहीं!';

  @override
  String focusCompleteEvolved(String catName) {
    return '$catName का विकास हुआ!';
  }

  @override
  String focusCompleteFocusedFor(int minutes) {
    return 'आपने $minutes मिनट फ़ोकस किया';
  }

  @override
  String focusCompleteAbandonedMessage(String catName) {
    return '$catName कहता है: \"हम फिर से कोशिश करेंगे!\"';
  }

  @override
  String get focusCompleteFocusTime => 'फ़ोकस समय';

  @override
  String get focusCompleteCoinsEarned => 'अर्जित सिक्के';

  @override
  String get focusCompleteBaseXp => 'बेस XP';

  @override
  String get focusCompleteStreakBonus => 'स्ट्रीक बोनस';

  @override
  String get focusCompleteMilestoneBonus => 'माइलस्टोन बोनस';

  @override
  String get focusCompleteFullHouseBonus => 'फ़ुल हाउस बोनस';

  @override
  String get focusCompleteTotal => 'कुल';

  @override
  String focusCompleteEvolvedTo(String stage) {
    return '$stage में विकसित!';
  }

  @override
  String get focusCompleteYourCat => 'आपकी बिल्ली';

  @override
  String get focusCompleteDiaryWriting => 'डायरी लिख रहे हैं...';

  @override
  String get focusCompleteDiaryWritten => 'डायरी लिखी गई!';

  @override
  String get focusCompleteDiarySkipped => 'डायरी छोड़ दी गई';

  @override
  String get focusCompleteNotifTitle => 'क्वेस्ट पूरा!';

  @override
  String focusCompleteNotifBody(String catName, int xp, int minutes) {
    return '$catName ने $minutes मिनट फ़ोकस से +$xp XP कमाया';
  }

  @override
  String get stageKitten => 'बिल्ली का बच्चा';

  @override
  String get stageAdolescent => 'किशोर';

  @override
  String get stageAdult => 'वयस्क';

  @override
  String get stageSenior => 'वरिष्ठ';

  @override
  String get migrationTitle => 'डेटा अपडेट ज़रूरी';

  @override
  String get migrationMessage =>
      'Hachimi को नए पिक्सल कैट सिस्टम के साथ अपडेट किया गया है! आपका पुराना कैट डेटा अब संगत नहीं है। नए अनुभव के लिए रीसेट करें।';

  @override
  String get migrationResetButton => 'रीसेट करें और नई शुरुआत करें';

  @override
  String get sessionResumeTitle => 'सत्र जारी रखें?';

  @override
  String sessionResumeMessage(String habitName, String elapsed) {
    return 'आपका एक सक्रिय फ़ोकस सत्र था ($habitName, $elapsed)। जारी रखें?';
  }

  @override
  String get sessionResumeButton => 'जारी रखें';

  @override
  String get sessionDiscard => 'छोड़ें';

  @override
  String get todaySummaryMinutes => 'आज';

  @override
  String get todaySummaryTotal => 'कुल';

  @override
  String get todaySummaryCats => 'बिल्लियाँ';

  @override
  String get todayYourQuests => 'आपके क्वेस्ट';

  @override
  String get todayNoQuests => 'अभी कोई क्वेस्ट नहीं';

  @override
  String get todayNoQuestsHint =>
      'क्वेस्ट शुरू करने और बिल्ली अपनाने के लिए + दबाएँ!';

  @override
  String get todayFocus => 'फ़ोकस';

  @override
  String get todayDeleteQuestTitle => 'क्वेस्ट हटाएँ?';

  @override
  String todayDeleteQuestMessage(String name) {
    return 'क्या आप \"$name\" हटाना चाहते हैं? बिल्ली आपके एल्बम में चली जाएगी।';
  }

  @override
  String todayQuestCompleted(String name) {
    return '$name पूरा हुआ';
  }

  @override
  String get todayFailedToLoad => 'क्वेस्ट लोड नहीं हो पाए';

  @override
  String todayMinToday(int count) {
    return 'आज $count मिनट';
  }

  @override
  String todayGoalMinPerDay(int count) {
    return 'लक्ष्य: $count मिनट/दिन';
  }

  @override
  String get todayFeaturedCat => 'फ़ीचर्ड कैट';

  @override
  String get todayAddHabit => 'आदत जोड़ें';

  @override
  String get todayNoHabits => 'शुरू करने के लिए अपनी पहली आदत बनाएँ!';

  @override
  String get todayNewQuest => 'नया क्वेस्ट';

  @override
  String get todayStartFocus => 'फ़ोकस शुरू करें';

  @override
  String get timerStart => 'शुरू';

  @override
  String get timerPause => 'रुकें';

  @override
  String get timerResume => 'जारी रखें';

  @override
  String get timerDone => 'हो गया';

  @override
  String get timerGiveUp => 'छोड़ दें';

  @override
  String get timerRemaining => 'शेष';

  @override
  String get timerElapsed => 'बीता हुआ';

  @override
  String get timerPaused => 'रुका हुआ';

  @override
  String get timerQuestNotFound => 'क्वेस्ट नहीं मिला';

  @override
  String get timerNotificationBanner =>
      'ऐप बैकग्राउंड में होने पर टाइमर की प्रगति देखने के लिए नोटिफ़िकेशन सक्षम करें';

  @override
  String get timerNotificationDismiss => 'बंद करें';

  @override
  String get timerNotificationEnable => 'सक्षम करें';

  @override
  String timerGraceBack(int seconds) {
    return 'वापस (${seconds}s)';
  }

  @override
  String get giveUpTitle => 'छोड़ दें?';

  @override
  String get giveUpMessage =>
      'अगर आपने कम से कम 5 मिनट फ़ोकस किया है, तो वह समय आपकी बिल्ली की वृद्धि में गिना जाएगा। आपकी बिल्ली समझेगी!';

  @override
  String get giveUpKeepGoing => 'जारी रखें';

  @override
  String get giveUpConfirm => 'छोड़ दें';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsGeneral => 'सामान्य';

  @override
  String get settingsAppearance => 'दिखावट';

  @override
  String get settingsNotifications => 'सूचनाएँ';

  @override
  String get settingsNotificationFocusReminders => 'फ़ोकस रिमाइंडर';

  @override
  String get settingsNotificationSubtitle =>
      'ट्रैक पर रहने के लिए दैनिक रिमाइंडर पाएँ';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsLanguageSystem => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get settingsLanguageEnglish => 'अंग्रेज़ी';

  @override
  String get settingsLanguageChinese => '中文';

  @override
  String get settingsThemeMode => 'थीम मोड';

  @override
  String get settingsThemeModeSystem => 'सिस्टम';

  @override
  String get settingsThemeModeLight => 'लाइट';

  @override
  String get settingsThemeModeDark => 'डार्क';

  @override
  String get settingsThemeColor => 'थीम रंग';

  @override
  String get settingsThemeColorDynamic => 'डायनेमिक';

  @override
  String get settingsThemeColorDynamicSubtitle =>
      'वॉलपेपर के रंग इस्तेमाल करें';

  @override
  String get settingsAbout => 'ऐप के बारे में';

  @override
  String get settingsVersion => 'वर्शन';

  @override
  String get settingsLicenses => 'लाइसेंस';

  @override
  String get settingsAccount => 'खाता';

  @override
  String get logoutTitle => 'लॉग आउट करें?';

  @override
  String get logoutMessage => 'क्या आप लॉग आउट करना चाहते हैं?';

  @override
  String get loggingOut => 'लॉग आउट हो रहा है...';

  @override
  String get deleteAccountTitle => 'खाता हटाएँ?';

  @override
  String get deleteAccountMessage =>
      'इससे आपका खाता और सारा डेटा हमेशा के लिए हट जाएगा। यह क्रिया पूर्ववत नहीं की जा सकती।';

  @override
  String get deleteAccountWarning => 'यह क्रिया पूर्ववत नहीं की जा सकती';

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get profileYourJourney => 'आपकी यात्रा';

  @override
  String get profileTotalFocus => 'कुल फ़ोकस';

  @override
  String get profileTotalCats => 'कुल बिल्लियाँ';

  @override
  String get profileTotalQuests => 'क्वेस्ट';

  @override
  String get profileEditName => 'नाम बदलें';

  @override
  String get profileDisplayName => 'प्रदर्शित नाम';

  @override
  String get profileChooseAvatar => 'अवतार चुनें';

  @override
  String get profileSaved => 'प्रोफ़ाइल सहेजी गई';

  @override
  String get profileSettings => 'सेटिंग्स';

  @override
  String get habitDetailStreak => 'स्ट्रीक';

  @override
  String get habitDetailBestStreak => 'सर्वश्रेष्ठ';

  @override
  String get habitDetailTotalMinutes => 'कुल';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonConfirm => 'पुष्टि करें';

  @override
  String get commonSave => 'सहेजें';

  @override
  String get commonDelete => 'हटाएँ';

  @override
  String get commonEdit => 'संपादित करें';

  @override
  String get commonDone => 'हो गया';

  @override
  String get commonDismiss => 'बंद करें';

  @override
  String get commonEnable => 'सक्षम करें';

  @override
  String get commonLoading => 'लोड हो रहा है...';

  @override
  String get commonError => 'कुछ गड़बड़ हो गई';

  @override
  String get commonRetry => 'पुनः प्रयास';

  @override
  String get commonResume => 'जारी रखें';

  @override
  String get commonPause => 'रुकें';

  @override
  String get commonLogOut => 'लॉग आउट';

  @override
  String get commonDeleteAccount => 'खाता हटाएँ';

  @override
  String get commonYes => 'हाँ';

  @override
  String chatDailyRemaining(int count) {
    return 'आज $count संदेश बाकी हैं';
  }

  @override
  String get chatDailyLimitReached => 'दैनिक संदेश सीमा पूरी हो गई';

  @override
  String get aiTemporarilyUnavailable =>
      'AI सुविधाएँ अस्थायी रूप से अनुपलब्ध हैं';

  @override
  String get catDetailNotFound => 'बिल्ली नहीं मिली';

  @override
  String get catDetailLoadError => 'बिल्ली का डेटा लोड नहीं हो सका';

  @override
  String get catDetailChatTooltip => 'चैट';

  @override
  String get catDetailRenameTooltip => 'नाम बदलें';

  @override
  String get catDetailGrowthTitle => 'विकास प्रगति';

  @override
  String catDetailTarget(int hours) {
    return 'लक्ष्य: $hours घंटे';
  }

  @override
  String get catDetailRenameTitle => 'बिल्ली का नाम बदलें';

  @override
  String get catDetailNewName => 'नया नाम';

  @override
  String get catDetailRenamed => 'बिल्ली का नाम बदला गया!';

  @override
  String get catDetailQuestBadge => 'क्वेस्ट';

  @override
  String get catDetailEditQuest => 'क्वेस्ट संपादित करें';

  @override
  String get catDetailDailyGoal => 'दैनिक लक्ष्य';

  @override
  String get catDetailTodaysFocus => 'आज का फ़ोकस';

  @override
  String get catDetailTotalFocus => 'कुल फ़ोकस';

  @override
  String get catDetailTargetLabel => 'लक्ष्य';

  @override
  String get catDetailCompletion => 'पूर्णता';

  @override
  String get catDetailCurrentStreak => 'वर्तमान स्ट्रीक';

  @override
  String get catDetailBestStreakLabel => 'सर्वश्रेष्ठ स्ट्रीक';

  @override
  String get catDetailAvgDaily => 'दैनिक औसत';

  @override
  String get catDetailDaysActive => 'सक्रिय दिन';

  @override
  String get catDetailCheckInDays => 'चेक-इन दिन';

  @override
  String get catDetailEditQuestTitle => 'क्वेस्ट संपादित करें';

  @override
  String get catDetailQuestName => 'क्वेस्ट का नाम';

  @override
  String get catDetailDailyGoalMinutes => 'दैनिक लक्ष्य (मिनट)';

  @override
  String get catDetailTargetTotalHours => 'कुल लक्ष्य (घंटे)';

  @override
  String get catDetailQuestUpdated => 'क्वेस्ट अपडेट हो गया!';

  @override
  String get catDetailTargetCompletedHint =>
      'लक्ष्य पहले ही पूरा हो चुका है — अब अनलिमिटेड मोड में';

  @override
  String get catDetailDailyReminder => 'दैनिक रिमाइंडर';

  @override
  String catDetailEveryDay(String time) {
    return 'हर दिन $time';
  }

  @override
  String get catDetailNoReminder => 'कोई रिमाइंडर सेट नहीं';

  @override
  String get catDetailChange => 'बदलें';

  @override
  String get catDetailRemoveReminder => 'रिमाइंडर हटाएँ';

  @override
  String get catDetailSet => 'सेट करें';

  @override
  String catDetailReminderSet(String time) {
    return '$time के लिए रिमाइंडर सेट';
  }

  @override
  String get catDetailReminderRemoved => 'रिमाइंडर हटाया गया';

  @override
  String get catDetailDiaryTitle => 'Hachimi डायरी';

  @override
  String get catDetailDiaryLoading => 'लोड हो रहा है...';

  @override
  String get catDetailDiaryError => 'डायरी लोड नहीं हो पाई';

  @override
  String get catDetailDiaryEmpty =>
      'आज अभी तक कोई डायरी एंट्री नहीं। एक फ़ोकस सत्र पूरा करें!';

  @override
  String catDetailChatWith(String name) {
    return '$name से चैट करें';
  }

  @override
  String get catDetailChatSubtitle => 'वह अपने स्वभाव के अनुसार जवाब देगी!';

  @override
  String get catDetailActivity => 'गतिविधि';

  @override
  String get catDetailActivityError => 'गतिविधि डेटा लोड नहीं हो पाया';

  @override
  String get catDetailAccessoriesTitle => 'एक्सेसरीज़';

  @override
  String get catDetailEquipped => 'पहना हुआ: ';

  @override
  String get catDetailNone => 'कुछ नहीं';

  @override
  String get catDetailUnequip => 'उतारें';

  @override
  String catDetailFromInventory(int count) {
    return 'इन्वेंट्री से ($count)';
  }

  @override
  String get catDetailNoAccessories => 'अभी कोई एक्सेसरी नहीं। शॉप पर जाएँ!';

  @override
  String catDetailEquippedItem(String name) {
    return '$name पहनाया';
  }

  @override
  String get catDetailUnequipped => 'उतार दिया';

  @override
  String catDetailAbout(String name) {
    return '$name के बारे में';
  }

  @override
  String get catDetailAppearanceDetails => 'दिखावट का विवरण';

  @override
  String get catDetailStatus => 'स्थिति';

  @override
  String get catDetailAdopted => 'अपनाया गया';

  @override
  String get catDetailFurPattern => 'फ़र पैटर्न';

  @override
  String get catDetailFurColor => 'फ़र का रंग';

  @override
  String get catDetailFurLength => 'फ़र की लंबाई';

  @override
  String get catDetailEyes => 'आँखें';

  @override
  String get catDetailWhitePatches => 'सफ़ेद धब्बे';

  @override
  String get catDetailPatchesTint => 'धब्बों का रंग';

  @override
  String get catDetailTint => 'रंगत';

  @override
  String get catDetailPoints => 'पॉइंट्स';

  @override
  String get catDetailVitiligo => 'विटिलिगो';

  @override
  String get catDetailTortoiseshell => 'टॉर्टोइसशेल';

  @override
  String get catDetailTortiePattern => 'टॉर्टी पैटर्न';

  @override
  String get catDetailTortieColor => 'टॉर्टी रंग';

  @override
  String get catDetailSkin => 'त्वचा';

  @override
  String get offlineMessage =>
      'आप ऑफ़लाइन हैं — कनेक्ट होने पर बदलाव सिंक होंगे';

  @override
  String get offlineModeLabel => 'ऑफ़लाइन मोड';

  @override
  String habitTodayMinutes(int count) {
    return 'आज: $count मिनट';
  }

  @override
  String get habitDeleteTooltip => 'आदत हटाएँ';

  @override
  String get heatmapActiveDays => 'सक्रिय दिन';

  @override
  String get heatmapTotal => 'कुल';

  @override
  String get heatmapRate => 'दर';

  @override
  String get heatmapLess => 'कम';

  @override
  String get heatmapMore => 'ज़्यादा';

  @override
  String get accessoryEquipped => 'पहना हुआ';

  @override
  String get accessoryOwned => 'खरीदा हुआ';

  @override
  String get pickerMinUnit => 'मिनट';

  @override
  String get settingsBackgroundAnimation => 'एनिमेटेड बैकग्राउंड';

  @override
  String get settingsBackgroundAnimationSubtitle =>
      'मेश ग्रेडिएंट और फ़्लोटिंग पार्टिकल्स';

  @override
  String get settingsUiStyle => 'UI शैली';

  @override
  String get settingsUiStyleMaterial => 'Material 3';

  @override
  String get settingsUiStyleRetroPixel => 'रेट्रो पिक्सल';

  @override
  String get settingsUiStyleMaterialSubtitle =>
      'आधुनिक, गोलाकार Material डिज़ाइन';

  @override
  String get settingsUiStyleRetroPixelSubtitle => 'गरम पिक्सल-आर्ट शैली';

  @override
  String get personalityLazy => 'आलसी';

  @override
  String get personalityCurious => 'जिज्ञासु';

  @override
  String get personalityPlayful => 'चंचल';

  @override
  String get personalityShy => 'शर्मीली';

  @override
  String get personalityBrave => 'बहादुर';

  @override
  String get personalityClingy => 'चिपकू';

  @override
  String get personalityFlavorLazy =>
      'दिन में 23 घंटे सोएगी। बाकी 1 घंटा? वो भी सोएगी।';

  @override
  String get personalityFlavorCurious => 'पहले से ही सब कुछ सूँघ रही है!';

  @override
  String get personalityFlavorPlayful =>
      'तितलियों का पीछा करना बंद ही नहीं करती!';

  @override
  String get personalityFlavorShy => 'बॉक्स से झाँकने में 3 मिनट लगे...';

  @override
  String get personalityFlavorBrave => 'बॉक्स खुलने से पहले ही बाहर कूद गई!';

  @override
  String get personalityFlavorClingy =>
      'तुरंत गड़गड़ाने लगी और छोड़ने को तैयार नहीं।';

  @override
  String get moodHappy => 'खुश';

  @override
  String get moodNeutral => 'सामान्य';

  @override
  String get moodLonely => 'अकेली';

  @override
  String get moodMissing => 'याद आ रही है';

  @override
  String get moodMsgLazyHappy => 'न्या~! अब एक अच्छी सी नींद का समय है...';

  @override
  String get moodMsgCuriousHappy => 'आज क्या खोजने वाले हैं?';

  @override
  String get moodMsgPlayfulHappy => 'न्या~! काम के लिए तैयार!';

  @override
  String get moodMsgShyHappy => '...मुझे खुशी है कि तुम यहाँ हो।';

  @override
  String get moodMsgBraveHappy => 'चलो आज को साथ मिलकर जीतें!';

  @override
  String get moodMsgClingyHappy => 'याय! तुम वापस आ गए! फिर मत जाना!';

  @override
  String get moodMsgLazyNeutral => '*जम्हाई* ओह, हैलो...';

  @override
  String get moodMsgCuriousNeutral => 'हम्म, वो क्या है वहाँ?';

  @override
  String get moodMsgPlayfulNeutral => 'खेलना है? शायद बाद में...';

  @override
  String get moodMsgShyNeutral => '*धीरे से झाँकती है*';

  @override
  String get moodMsgBraveNeutral => 'हमेशा की तरह पहरा दे रही हूँ।';

  @override
  String get moodMsgClingyNeutral => 'मैं तुम्हारा इंतज़ार कर रही थी...';

  @override
  String get moodMsgLazyLonely => 'सोना भी अकेले में अच्छा नहीं लगता...';

  @override
  String get moodMsgCuriousLonely => 'सोच रही हूँ तुम कब वापस आओगे...';

  @override
  String get moodMsgPlayfulLonely => 'खिलौने तुम्हारे बिना मज़ेदार नहीं हैं...';

  @override
  String get moodMsgShyLonely => '*चुपचाप सिमट गई*';

  @override
  String get moodMsgBraveLonely => 'मैं इंतज़ार करूँगी। मैं बहादुर हूँ।';

  @override
  String get moodMsgClingyLonely => 'तुम कहाँ चले गए... 🥺';

  @override
  String get moodMsgLazyMissing => '*उम्मीद से एक आँख खोलती है*';

  @override
  String get moodMsgCuriousMissing => 'क्या कुछ हो गया...?';

  @override
  String get moodMsgPlayfulMissing =>
      'मैंने तुम्हारा पसंदीदा खिलौना बचाकर रखा है...';

  @override
  String get moodMsgShyMissing => '*छिपी हुई, लेकिन दरवाज़े की ओर देख रही है*';

  @override
  String get moodMsgBraveMissing =>
      'मुझे पता है तुम वापस आओगे। मुझे विश्वास है।';

  @override
  String get moodMsgClingyMissing =>
      'मुझे तुम्हारी बहुत याद आ रही है... कृपया वापस आओ।';

  @override
  String get peltTypeTabby => 'क्लासिक टैबी धारियाँ';

  @override
  String get peltTypeTicked => 'टिक्ड एगूटी पैटर्न';

  @override
  String get peltTypeMackerel => 'मैकरेल टैबी';

  @override
  String get peltTypeClassic => 'क्लासिक स्वर्ल पैटर्न';

  @override
  String get peltTypeSokoke => 'सोकोक मार्बल पैटर्न';

  @override
  String get peltTypeAgouti => 'एगूटी टिक्ड';

  @override
  String get peltTypeSpeckled => 'चित्तीदार कोट';

  @override
  String get peltTypeRosette => 'रोज़ेट स्पॉटेड';

  @override
  String get peltTypeSingleColour => 'एक रंग';

  @override
  String get peltTypeTwoColour => 'दो रंग';

  @override
  String get peltTypeSmoke => 'स्मोक शेडिंग';

  @override
  String get peltTypeSinglestripe => 'एकल धारी';

  @override
  String get peltTypeBengal => 'बंगाल पैटर्न';

  @override
  String get peltTypeMarbled => 'मार्बल्ड पैटर्न';

  @override
  String get peltTypeMasked => 'नकाबपोश चेहरा';

  @override
  String get peltColorWhite => 'सफ़ेद';

  @override
  String get peltColorPaleGrey => 'हल्का स्लेटी';

  @override
  String get peltColorSilver => 'चाँदी';

  @override
  String get peltColorGrey => 'स्लेटी';

  @override
  String get peltColorDarkGrey => 'गहरा स्लेटी';

  @override
  String get peltColorGhost => 'भूतिया स्लेटी';

  @override
  String get peltColorBlack => 'काला';

  @override
  String get peltColorCream => 'क्रीम';

  @override
  String get peltColorPaleGinger => 'हल्का अदरकी';

  @override
  String get peltColorGolden => 'सुनहरा';

  @override
  String get peltColorGinger => 'अदरकी';

  @override
  String get peltColorDarkGinger => 'गहरा अदरकी';

  @override
  String get peltColorSienna => 'सिएना';

  @override
  String get peltColorLightBrown => 'हल्का भूरा';

  @override
  String get peltColorLilac => 'लाइलैक';

  @override
  String get peltColorBrown => 'भूरा';

  @override
  String get peltColorGoldenBrown => 'सुनहरा भूरा';

  @override
  String get peltColorDarkBrown => 'गहरा भूरा';

  @override
  String get peltColorChocolate => 'चॉकलेट';

  @override
  String get eyeColorYellow => 'पीला';

  @override
  String get eyeColorAmber => 'एम्बर';

  @override
  String get eyeColorHazel => 'हेज़ल';

  @override
  String get eyeColorPaleGreen => 'हल्का हरा';

  @override
  String get eyeColorGreen => 'हरा';

  @override
  String get eyeColorBlue => 'नीला';

  @override
  String get eyeColorDarkBlue => 'गहरा नीला';

  @override
  String get eyeColorBlueYellow => 'नीला-पीला';

  @override
  String get eyeColorBlueGreen => 'नीला-हरा';

  @override
  String get eyeColorGrey => 'स्लेटी';

  @override
  String get eyeColorCyan => 'सियान';

  @override
  String get eyeColorEmerald => 'पन्ना';

  @override
  String get eyeColorHeatherBlue => 'हीदर नीला';

  @override
  String get eyeColorSunlitIce => 'धूपी बर्फ़';

  @override
  String get eyeColorCopper => 'ताम्र';

  @override
  String get eyeColorSage => 'सेज';

  @override
  String get eyeColorCobalt => 'कोबाल्ट';

  @override
  String get eyeColorPaleBlue => 'हल्का नीला';

  @override
  String get eyeColorBronze => 'काँसा';

  @override
  String get eyeColorSilver => 'चाँदी';

  @override
  String get eyeColorPaleYellow => 'हल्का पीला';

  @override
  String eyeDescNormal(String color) {
    return '$color आँखें';
  }

  @override
  String eyeDescHeterochromia(String primary, String secondary) {
    return 'हेटरोक्रोमिया ($primary / $secondary)';
  }

  @override
  String get skinColorPink => 'गुलाबी';

  @override
  String get skinColorRed => 'लाल';

  @override
  String get skinColorBlack => 'काला';

  @override
  String get skinColorDark => 'गहरा';

  @override
  String get skinColorDarkBrown => 'गहरा भूरा';

  @override
  String get skinColorBrown => 'भूरा';

  @override
  String get skinColorLightBrown => 'हल्का भूरा';

  @override
  String get skinColorDarkGrey => 'गहरा स्लेटी';

  @override
  String get skinColorGrey => 'स्लेटी';

  @override
  String get skinColorDarkSalmon => 'गहरा सैल्मन';

  @override
  String get skinColorSalmon => 'सैल्मन';

  @override
  String get skinColorPeach => 'पीच';

  @override
  String get furLengthLonghair => 'लंबे बाल';

  @override
  String get furLengthShorthair => 'छोटे बाल';

  @override
  String get whiteTintOffwhite => 'ऑफ़-वाइट रंगत';

  @override
  String get whiteTintCream => 'क्रीम रंगत';

  @override
  String get whiteTintDarkCream => 'गहरी क्रीम रंगत';

  @override
  String get whiteTintGray => 'स्लेटी रंगत';

  @override
  String get whiteTintPink => 'गुलाबी रंगत';

  @override
  String notifReminderTitle(String catName) {
    return '$catName को आपकी याद आ रही है!';
  }

  @override
  String notifReminderBody(String habitName) {
    return '$habitName का समय — आपकी बिल्ली इंतज़ार कर रही है!';
  }

  @override
  String notifStreakTitle(String catName) {
    return '$catName चिंतित है!';
  }

  @override
  String notifStreakBody(int streak) {
    return 'आपकी $streak दिन की स्ट्रीक ख़तरे में है। एक छोटा सत्र बचा लेगा!';
  }

  @override
  String notifEvolutionTitle(String catName) {
    return '$catName का विकास हुआ!';
  }

  @override
  String notifEvolutionBody(String catName, String stageName) {
    return '$catName अब $stageName बन गई! शानदार काम जारी रखें!';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours घंटे $minutes मिनट';
  }

  @override
  String diaryScreenTitle(String name) {
    return '$name की डायरी';
  }

  @override
  String get diaryFailedToLoad => 'डायरी लोड नहीं हो पाई';

  @override
  String get diaryEmptyTitle => 'अभी कोई डायरी एंट्री नहीं';

  @override
  String get diaryEmptyHint =>
      'एक फ़ोकस सत्र पूरा करें और आपकी बिल्ली अपनी पहली डायरी लिखेगी!';

  @override
  String get focusSetupCountdown => 'काउंटडाउन';

  @override
  String get focusSetupStopwatch => 'स्टॉपवॉच';

  @override
  String get focusSetupStartFocus => 'फ़ोकस शुरू करें';

  @override
  String get focusSetupQuestNotFound => 'क्वेस्ट नहीं मिला';

  @override
  String get checkInButtonLogMore => 'और समय जोड़ें';

  @override
  String get checkInButtonStart => 'टाइमर शुरू करें';

  @override
  String get adoptionTitleFirst => 'अपनी पहली बिल्ली अपनाएँ!';

  @override
  String get adoptionTitleNew => 'नया क्वेस्ट';

  @override
  String get adoptionStepDefineQuest => 'क्वेस्ट तय करें';

  @override
  String get adoptionStepAdoptCat2 => 'बिल्ली अपनाएँ';

  @override
  String get adoptionStepNameCat2 => 'नाम रखें';

  @override
  String get adoptionAdopt => 'अपनाएँ!';

  @override
  String get adoptionQuestPrompt => 'आप कौन सा क्वेस्ट शुरू करना चाहते हैं?';

  @override
  String get adoptionKittenHint =>
      'एक बिल्ली का बच्चा आपको ट्रैक पर रहने में मदद करेगा!';

  @override
  String get adoptionQuestName => 'क्वेस्ट का नाम';

  @override
  String get adoptionQuestHint => 'जैसे: इंटरव्यू के सवाल तैयार करना';

  @override
  String get adoptionTotalTarget => 'कुल लक्ष्य (घंटे)';

  @override
  String get adoptionGrowthHint =>
      'जैसे-जैसे आप फ़ोकस समय जमा करेंगे, आपकी बिल्ली बढ़ेगी';

  @override
  String get adoptionCustom => 'कस्टम';

  @override
  String get adoptionDailyGoalLabel => 'दैनिक फ़ोकस लक्ष्य (मिनट)';

  @override
  String get adoptionReminderLabel => 'दैनिक रिमाइंडर (वैकल्पिक)';

  @override
  String get adoptionReminderNone => 'कोई नहीं';

  @override
  String get adoptionCustomGoalTitle => 'कस्टम दैनिक लक्ष्य';

  @override
  String get adoptionMinutesPerDay => 'प्रतिदिन मिनट';

  @override
  String get adoptionMinutesHint => '5 - 180';

  @override
  String get adoptionValidMinutes => '5 से 180 के बीच मान डालें';

  @override
  String get adoptionCustomTargetTitle => 'कस्टम लक्ष्य घंटे';

  @override
  String get adoptionTotalHours => 'कुल घंटे';

  @override
  String get adoptionHoursHint => '10 - 2000';

  @override
  String get adoptionValidHours => '10 से 2000 के बीच मान डालें';

  @override
  String get adoptionSet => 'सेट करें';

  @override
  String get adoptionChooseKitten => 'अपना बिल्ली का बच्चा चुनें!';

  @override
  String adoptionCompanionFor(String quest) {
    return '\"$quest\" के लिए आपका साथी';
  }

  @override
  String get adoptionRerollAll => 'सब बदलें';

  @override
  String get adoptionNameYourCat2 => 'अपनी बिल्ली का नाम रखें';

  @override
  String get adoptionCatName => 'बिल्ली का नाम';

  @override
  String get adoptionCatHint => 'जैसे: मोची';

  @override
  String get adoptionRandomTooltip => 'रैंडम नाम';

  @override
  String adoptionGrowthTarget(String quest, int hours) {
    return 'आपकी बिल्ली \"$quest\" पर फ़ोकस करते हुए बढ़ेगी! लक्ष्य: $hours घंटे।';
  }

  @override
  String get adoptionValidQuestName => 'कृपया क्वेस्ट का नाम डालें';

  @override
  String get adoptionValidCatName => 'कृपया अपनी बिल्ली का नाम रखें';

  @override
  String adoptionError(String message) {
    return 'त्रुटि: $message';
  }

  @override
  String get adoptionBasicInfo => 'मूल जानकारी';

  @override
  String get adoptionGoals => 'लक्ष्य';

  @override
  String get adoptionUnlimitedMode => 'अनलिमिटेड मोड';

  @override
  String get adoptionUnlimitedDesc => 'कोई ऊपरी सीमा नहीं, जमा करते रहें';

  @override
  String get adoptionMilestoneMode => 'माइलस्टोन मोड';

  @override
  String get adoptionMilestoneDesc => 'पूरा करने के लिए लक्ष्य सेट करें';

  @override
  String get adoptionDeadlineLabel => 'समय-सीमा';

  @override
  String get adoptionDeadlineNone => 'सेट नहीं';

  @override
  String get adoptionReminderSection => 'रिमाइंडर';

  @override
  String get adoptionMotivationLabel => 'नोट';

  @override
  String get adoptionMotivationHint => 'एक नोट लिखें...';

  @override
  String get adoptionMotivationSwap => 'रैंडम भरें';

  @override
  String get loginAppName => 'Hachimi';

  @override
  String get loginTagline => 'बिल्लियाँ पालें। क्वेस्ट पूरे करें।';

  @override
  String get loginContinueGoogle => 'Google से जारी रखें';

  @override
  String get loginContinueEmail => 'ईमेल से जारी रखें';

  @override
  String get loginAlreadyHaveAccount => 'पहले से खाता है? ';

  @override
  String get loginLogIn => 'लॉग इन';

  @override
  String get loginWelcomeBack => 'वापसी पर स्वागत!';

  @override
  String get loginCreateAccount => 'अपना खाता बनाएँ';

  @override
  String get loginEmail => 'ईमेल';

  @override
  String get loginPassword => 'पासवर्ड';

  @override
  String get loginConfirmPassword => 'पासवर्ड पुष्टि करें';

  @override
  String get loginValidEmail => 'कृपया अपना ईमेल डालें';

  @override
  String get loginValidEmailFormat => 'कृपया मान्य ईमेल डालें';

  @override
  String get loginValidPassword => 'कृपया अपना पासवर्ड डालें';

  @override
  String get loginValidPasswordLength =>
      'पासवर्ड कम से कम 6 अक्षर का होना चाहिए';

  @override
  String get loginValidPasswordMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get loginCreateAccountButton => 'खाता बनाएँ';

  @override
  String get loginNoAccount => 'खाता नहीं है? ';

  @override
  String get loginRegister => 'रजिस्टर करें';

  @override
  String get checkInTitle => 'मासिक चेक-इन';

  @override
  String get checkInDays => 'दिन';

  @override
  String get checkInCoinsEarned => 'अर्जित सिक्के';

  @override
  String get checkInAllMilestones => 'सभी माइलस्टोन क्लेम हो चुके!';

  @override
  String checkInMilestoneProgress(int remaining, int bonus) {
    return '$remaining और दिन → +$bonus सिक्के';
  }

  @override
  String get checkInMilestones => 'माइलस्टोन';

  @override
  String get checkInFullMonth => 'पूरा महीना';

  @override
  String get checkInRewardSchedule => 'इनाम अनुसूची';

  @override
  String get checkInWeekday => 'सप्ताह के दिन (सोम–शुक्र)';

  @override
  String checkInWeekdayReward(int coins) {
    return '$coins सिक्के/दिन';
  }

  @override
  String get checkInWeekend => 'सप्ताहांत (शनि–रवि)';

  @override
  String checkInNDays(int count) {
    return '$count दिन';
  }

  @override
  String get onboardTitle1 => 'अपने साथी से मिलें';

  @override
  String get onboardSubtitle1 =>
      'हर क्वेस्ट एक बिल्ली के बच्चे से शुरू होता है';

  @override
  String get onboardBody1 =>
      'एक लक्ष्य तय करें और बिल्ली का बच्चा अपनाएँ।\nफ़ोकस करें, और अपनी बिल्ली को बढ़ते देखें!';

  @override
  String get onboardTitle2 => 'फ़ोकस, बढ़ो, विकसित हो';

  @override
  String get onboardSubtitle2 => 'विकास के 4 चरण';

  @override
  String get onboardBody2 =>
      'फ़ोकस का हर मिनट आपकी बिल्ली को विकसित होने में मदद करता है\nनन्हे बच्चे से शानदार वरिष्ठ तक!';

  @override
  String get onboardTitle3 => 'अपना कैट रूम बनाएँ';

  @override
  String get onboardSubtitle3 => 'अनोखी बिल्लियाँ इकट्ठा करें';

  @override
  String get onboardBody3 =>
      'हर क्वेस्ट एक अनोखी दिखावट वाली बिल्ली लाता है।\nसबको खोजें और अपना सपनों का संग्रह बनाएँ!';

  @override
  String get onboardSkip => 'छोड़ें';

  @override
  String get onboardLetsGo => 'चलो शुरू करें!';

  @override
  String get onboardNext => 'आगे';

  @override
  String get catRoomTitle => 'CatHouse';

  @override
  String get catRoomInventory => 'इन्वेंट्री';

  @override
  String get catRoomShop => 'एक्सेसरी शॉप';

  @override
  String get catRoomLoadError => 'बिल्लियाँ लोड नहीं हो पाईं';

  @override
  String get catRoomEmptyTitle => 'आपका CatHouse खाली है';

  @override
  String get catRoomEmptySubtitle =>
      'अपनी पहली बिल्ली अपनाने के लिए क्वेस्ट शुरू करें!';

  @override
  String get catRoomEditQuest => 'क्वेस्ट संपादित करें';

  @override
  String get catRoomRenameCat => 'बिल्ली का नाम बदलें';

  @override
  String get catRoomArchiveCat => 'बिल्ली आर्काइव करें';

  @override
  String get catRoomNewName => 'नया नाम';

  @override
  String get catRoomRename => 'नाम बदलें';

  @override
  String get catRoomArchiveTitle => 'बिल्ली आर्काइव करें?';

  @override
  String catRoomArchiveMessage(String name) {
    return 'इससे \"$name\" आर्काइव हो जाएगी और उसका क्वेस्ट हट जाएगा। बिल्ली अभी भी एल्बम में दिखेगी।';
  }

  @override
  String get catRoomArchive => 'आर्काइव करें';

  @override
  String catRoomAlbumSection(int count) {
    return 'एल्बम ($count)';
  }

  @override
  String get catRoomReactivateCat => 'बिल्ली पुनः सक्रिय करें';

  @override
  String get catRoomReactivateTitle => 'बिल्ली पुनः सक्रिय करें?';

  @override
  String catRoomReactivateMessage(String name) {
    return 'इससे \"$name\" और उसका क्वेस्ट CatHouse में वापस आ जाएगा।';
  }

  @override
  String get catRoomReactivate => 'पुनः सक्रिय करें';

  @override
  String get catRoomArchivedLabel => 'आर्काइव किया गया';

  @override
  String catRoomArchiveSuccess(String name) {
    return '\"$name\" आर्काइव हो गई';
  }

  @override
  String catRoomReactivateSuccess(String name) {
    return '\"$name\" पुनः सक्रिय हो गई';
  }

  @override
  String get catRoomArchiveError => 'बिल्ली को संग्रह करने में विफल';

  @override
  String get catRoomReactivateError => 'बिल्ली को पुनः सक्रिय करने में विफल';

  @override
  String get catRoomArchiveLoadError => 'संग्रहीत बिल्लियों को लोड नहीं हो सका';

  @override
  String get catRoomRenameError => 'बिल्ली का नाम बदलने में विफल';

  @override
  String get addHabitTitle => 'नया क्वेस्ट';

  @override
  String get addHabitQuestName => 'क्वेस्ट का नाम';

  @override
  String get addHabitQuestHint => 'जैसे: LeetCode अभ्यास';

  @override
  String get addHabitValidName => 'कृपया क्वेस्ट का नाम डालें';

  @override
  String get addHabitTargetHours => 'लक्ष्य घंटे';

  @override
  String get addHabitTargetHint => 'जैसे: 100';

  @override
  String get addHabitValidTarget => 'कृपया लक्ष्य घंटे डालें';

  @override
  String get addHabitValidNumber => 'कृपया मान्य संख्या डालें';

  @override
  String get addHabitCreate => 'क्वेस्ट बनाएँ';

  @override
  String get addHabitHoursSuffix => 'घंटे';

  @override
  String shopTabPlants(int count) {
    return 'पौधे ($count)';
  }

  @override
  String shopTabWild(int count) {
    return 'जंगली ($count)';
  }

  @override
  String shopTabCollars(int count) {
    return 'कॉलर ($count)';
  }

  @override
  String get shopNoAccessories => 'कोई एक्सेसरी उपलब्ध नहीं';

  @override
  String shopBuyConfirm(String name) {
    return '$name ख़रीदें?';
  }

  @override
  String get shopPurchaseButton => 'ख़रीदें';

  @override
  String get shopNotEnoughCoinsButton => 'पर्याप्त सिक्के नहीं';

  @override
  String shopPurchaseSuccess(String name) {
    return 'ख़रीद लिया! $name इन्वेंट्री में जोड़ दिया गया';
  }

  @override
  String shopPurchaseFailed(int price) {
    return 'पर्याप्त सिक्के नहीं ($price चाहिए)';
  }

  @override
  String get inventoryTitle => 'इन्वेंट्री';

  @override
  String inventoryInBox(int count) {
    return 'बॉक्स में ($count)';
  }

  @override
  String get inventoryEmpty =>
      'आपकी इन्वेंट्री खाली है।\nएक्सेसरीज़ पाने के लिए शॉप पर जाएँ!';

  @override
  String inventoryEquippedOnCats(int count) {
    return 'बिल्लियों पर पहनी हुई ($count)';
  }

  @override
  String get inventoryNoEquipped =>
      'किसी भी बिल्ली पर कोई एक्सेसरी नहीं पहनाई गई।';

  @override
  String get inventoryUnequip => 'उतारें';

  @override
  String get inventoryNoActiveCats => 'कोई सक्रिय बिल्ली नहीं';

  @override
  String inventoryEquipTo(String name) {
    return '$name पहनाएँ:';
  }

  @override
  String inventoryEquipSuccess(String name) {
    return '$name पहनाया';
  }

  @override
  String inventoryUnequipSuccess(String catName) {
    return '$catName से उतारा';
  }

  @override
  String get chatCatNotFound => 'बिल्ली नहीं मिली';

  @override
  String chatTitle(String name) {
    return '$name से चैट';
  }

  @override
  String get chatClearHistory => 'इतिहास मिटाएँ';

  @override
  String chatEmptyTitle(String name) {
    return '$name को हैलो कहें!';
  }

  @override
  String get chatEmptySubtitle =>
      'अपनी बिल्ली से बात करें। वे अपने स्वभाव के अनुसार जवाब देंगे!';

  @override
  String get chatGenerating => 'जवाब लिख रहे हैं...';

  @override
  String get chatTypeMessage => 'संदेश लिखें...';

  @override
  String get chatClearConfirmTitle => 'चैट इतिहास मिटाएँ?';

  @override
  String get chatClearConfirmMessage =>
      'इससे सभी संदेश हट जाएँगे। यह पूर्ववत नहीं किया जा सकता।';

  @override
  String get chatClearButton => 'मिटाएँ';

  @override
  String get chatSend => 'भेजें';

  @override
  String get chatStop => 'रोकें';

  @override
  String get chatErrorMessage => 'Failed to send message. Tap to retry.';

  @override
  String get chatRetry => 'Retry';

  @override
  String get chatErrorGeneric => 'कुछ गलत हो गया। फिर से कोशिश करें।';

  @override
  String diaryTitle(String name) {
    return '$name की डायरी';
  }

  @override
  String get diaryLoadFailed => 'डायरी लोड नहीं हो पाई';

  @override
  String get diaryRetry => 'पुनः प्रयास';

  @override
  String get diaryEmptyTitle2 => 'अभी कोई डायरी एंट्री नहीं';

  @override
  String get diaryEmptySubtitle =>
      'एक फ़ोकस सत्र पूरा करें और आपकी बिल्ली अपनी पहली डायरी लिखेगी!';

  @override
  String get statsTitle => 'आँकड़े';

  @override
  String get statsTotalHours => 'कुल घंटे';

  @override
  String statsTimeValue(int hours, int minutes) {
    return '$hours घंटे $minutes मिनट';
  }

  @override
  String get statsBestStreak => 'सर्वश्रेष्ठ स्ट्रीक';

  @override
  String statsStreakDays(int count) {
    return '$count दिन';
  }

  @override
  String get statsOverallProgress => 'समग्र प्रगति';

  @override
  String statsPercentOfGoals(String percent) {
    return 'सभी लक्ष्यों का $percent%';
  }

  @override
  String get statsPerQuestProgress => 'क्वेस्ट-वार प्रगति';

  @override
  String get statsQuestLoadError => 'क्वेस्ट आँकड़े लोड नहीं हो पाए';

  @override
  String get statsNoQuestData => 'अभी कोई क्वेस्ट डेटा नहीं';

  @override
  String get statsNoQuestHint => 'अपनी प्रगति देखने के लिए क्वेस्ट शुरू करें!';

  @override
  String get statsLast30Days => 'पिछले 30 दिन';

  @override
  String get habitDetailQuestNotFound => 'क्वेस्ट नहीं मिला';

  @override
  String get habitDetailComplete => 'पूरा';

  @override
  String get habitDetailTotalTime => 'कुल समय';

  @override
  String get habitDetailCurrentStreak => 'वर्तमान स्ट्रीक';

  @override
  String get habitDetailTarget => 'लक्ष्य';

  @override
  String habitDetailDaysUnit(int count) {
    return '$count दिन';
  }

  @override
  String habitDetailHoursUnit(int count) {
    return '$count घंटे';
  }

  @override
  String checkInBannerSuccess(int coins) {
    return '+$coins सिक्के! दैनिक चेक-इन पूरा';
  }

  @override
  String checkInBannerBonus(int bonus) {
    return ' + $bonus माइलस्टोन बोनस!';
  }

  @override
  String get checkInBannerSemantics => 'दैनिक चेक-इन';

  @override
  String get checkInBannerLoading => 'चेक-इन स्थिति लोड हो रही है...';

  @override
  String checkInBannerPrompt(int coins) {
    return '+$coins सिक्कों के लिए चेक इन करें';
  }

  @override
  String checkInBannerSummary(int count, int total, int coins) {
    return '$count/$total दिन  ·  आज +$coins';
  }

  @override
  String commonErrorWithDetail(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get profileFallbackUser => 'उपयोगकर्ता';

  @override
  String get fallbackCatName => 'बिल्ली';

  @override
  String get settingsLanguageTraditionalChinese => '繁體中文';

  @override
  String get settingsLanguageJapanese => '日本語';

  @override
  String get settingsLanguageKorean => '한국어';

  @override
  String get settingsLanguageSpanish => 'Español';

  @override
  String get settingsLanguagePortuguese => 'Português';

  @override
  String get settingsLanguageFrench => 'Français';

  @override
  String get settingsLanguageGerman => 'Deutsch';

  @override
  String get settingsLanguageItalian => 'Italiano';

  @override
  String get settingsLanguageHindi => 'हिन्दी';

  @override
  String get settingsLanguageThai => 'ไทย';

  @override
  String get settingsLanguageVietnamese => 'Tiếng Việt';

  @override
  String get settingsLanguageIndonesian => 'Bahasa Indonesia';

  @override
  String get settingsLanguageTurkish => 'Türkçe';

  @override
  String get notifFocusing => 'फ़ोकस कर रहे हैं...';

  @override
  String get notifInProgress => 'फ़ोकस सत्र चल रहा है';

  @override
  String get unitMinShort => 'मिनट';

  @override
  String get unitHourShort => 'घंटे';

  @override
  String get weekdayMon => 'सो';

  @override
  String get weekdayTue => 'मं';

  @override
  String get weekdayWed => 'बु';

  @override
  String get weekdayThu => 'गु';

  @override
  String get weekdayFri => 'शु';

  @override
  String get weekdaySat => 'श';

  @override
  String get weekdaySun => 'र';

  @override
  String get statsTotalSessions => 'सत्र';

  @override
  String get statsTotalHabits => 'आदतें';

  @override
  String get statsActiveDays => 'सक्रिय दिन';

  @override
  String get statsWeeklyTrend => 'साप्ताहिक रुझान';

  @override
  String get statsRecentSessions => 'हालिया फ़ोकस';

  @override
  String get statsViewAllHistory => 'पूरा इतिहास देखें';

  @override
  String get historyTitle => 'फ़ोकस इतिहास';

  @override
  String get historyFilterAll => 'सभी';

  @override
  String historySessionCount(int count) {
    return '$count सत्र';
  }

  @override
  String historyTotalMinutes(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String get historyNoSessions => 'अभी कोई फ़ोकस रिकॉर्ड नहीं';

  @override
  String get historyNoSessionsHint => 'एक फ़ोकस सत्र पूरा करें और यहाँ देखें';

  @override
  String get historyLoadMore => 'और लोड करें';

  @override
  String get sessionCompleted => 'पूरा हुआ';

  @override
  String get sessionAbandoned => 'छोड़ दिया';

  @override
  String get sessionInterrupted => 'बाधित हुआ';

  @override
  String get sessionCountdown => 'काउंटडाउन';

  @override
  String get sessionStopwatch => 'स्टॉपवॉच';

  @override
  String get historyDateGroupToday => 'आज';

  @override
  String get historyDateGroupYesterday => 'कल';

  @override
  String get historyLoadError => 'इतिहास लोड नहीं हो पाया';

  @override
  String get historySelectMonth => 'महीना चुनें';

  @override
  String get historyAllMonths => 'सभी महीने';

  @override
  String get historyAllHabits => 'सभी';

  @override
  String get homeTabAchievements => 'उपलब्धियाँ';

  @override
  String get achievementTitle => 'उपलब्धियाँ';

  @override
  String get achievementTabOverview => 'सिंहावलोकन';

  @override
  String get achievementTabQuest => 'क्वेस्ट';

  @override
  String get achievementTabStreak => 'स्ट्रीक';

  @override
  String get achievementTabCat => 'बिल्ली';

  @override
  String get achievementTabPersist => 'लगन';

  @override
  String get achievementSummaryTitle => 'उपलब्धि प्रगति';

  @override
  String achievementUnlockedCount(int count) {
    return '$count अनलॉक';
  }

  @override
  String achievementTotalCoins(int coins) {
    return '$coins सिक्के अर्जित';
  }

  @override
  String get achievementUnlocked => 'उपलब्धि अनलॉक!';

  @override
  String get achievementAwesome => 'शानदार!';

  @override
  String get achievementIncredible => 'अविश्वसनीय!';

  @override
  String get achievementHidden => '???';

  @override
  String get achievementHiddenDesc => 'यह एक छिपी उपलब्धि है';

  @override
  String achievementPersistDesc(int days) {
    return 'किसी भी क्वेस्ट पर $days चेक-इन दिन जमा करें';
  }

  @override
  String achievementTitleCount(int count) {
    return '$count उपाधियाँ अनलॉक';
  }

  @override
  String get growthPathTitle => 'विकास पथ';

  @override
  String get growthPathKitten => 'एक नई यात्रा शुरू करें';

  @override
  String get growthPathAdolescent => 'प्रारंभिक नींव बनाएँ';

  @override
  String get growthPathAdult => 'कौशल मजबूत होते हैं';

  @override
  String get growthPathSenior => 'गहन महारत';

  @override
  String get growthPathTip =>
      'शोध बताता है कि किसी नए कौशल की नींव बनाने के लिए 20 घंटे का केंद्रित अभ्यास पर्याप्त है — Josh Kaufman';

  @override
  String achievementCelebrationCoins(int count) {
    return '+$count सिक्के';
  }

  @override
  String achievementCelebrationTitle(String title) {
    return 'उपाधि अर्जित: $title';
  }

  @override
  String get achievementCelebrationDismiss => 'शानदार!';

  @override
  String get achievementCelebrationSkipAll => 'सब छोड़ें';

  @override
  String achievementCelebrationCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String achievementUnlockedAt(String date) {
    return '$date को अनलॉक हुआ';
  }

  @override
  String get achievementLocked => 'अभी अनलॉक नहीं हुआ';

  @override
  String achievementRewardCoins(int count) {
    return '+$count सिक्के';
  }

  @override
  String get reminderModeDaily => 'हर दिन';

  @override
  String get reminderModeWeekdays => 'सप्ताह के दिन';

  @override
  String get reminderModeMonday => 'सोमवार';

  @override
  String get reminderModeTuesday => 'मंगलवार';

  @override
  String get reminderModeWednesday => 'बुधवार';

  @override
  String get reminderModeThursday => 'गुरुवार';

  @override
  String get reminderModeFriday => 'शुक्रवार';

  @override
  String get reminderModeSaturday => 'शनिवार';

  @override
  String get reminderModeSunday => 'रविवार';

  @override
  String get reminderPickerTitle => 'रिमाइंडर समय चुनें';

  @override
  String get reminderHourUnit => 'घंटे';

  @override
  String get reminderMinuteUnit => 'मिनट';

  @override
  String get reminderAddMore => 'रिमाइंडर जोड़ें';

  @override
  String get reminderMaxReached => 'अधिकतम 5 रिमाइंडर';

  @override
  String get reminderConfirm => 'पुष्टि करें';

  @override
  String reminderNotificationTitle(String catName) {
    return '$catName को आपकी याद आ रही है!';
  }

  @override
  String reminderNotificationBody(String habitName) {
    return '$habitName का समय — आपकी बिल्ली इंतज़ार कर रही है!';
  }

  @override
  String get deleteAccountDataWarning =>
      'निम्नलिखित सभी डेटा हमेशा के लिए हटा दिया जाएगा:';

  @override
  String get deleteAccountQuests => 'क्वेस्ट';

  @override
  String get deleteAccountCats => 'बिल्लियाँ';

  @override
  String get deleteAccountHours => 'फ़ोकस घंटे';

  @override
  String get deleteAccountIrreversible => 'यह क्रिया अपरिवर्तनीय है';

  @override
  String get deleteAccountContinue => 'जारी रखें';

  @override
  String get deleteAccountConfirmTitle => 'हटाने की पुष्टि करें';

  @override
  String get deleteAccountTypeDelete =>
      'खाता हटाने की पुष्टि के लिए DELETE टाइप करें:';

  @override
  String get deleteAccountAuthCancelled => 'प्रमाणीकरण रद्द हुआ';

  @override
  String deleteAccountAuthFailed(String error) {
    return 'प्रमाणीकरण विफल: $error';
  }

  @override
  String get deleteAccountProgress => 'खाता हटाया जा रहा है...';

  @override
  String get deleteAccountSuccess => 'खाता हटाया गया';

  @override
  String get drawerGuestLoginSubtitle =>
      'डेटा सिंक करें और AI सुविधाएँ अनलॉक करें';

  @override
  String get drawerGuestSignIn => 'साइन इन करें';

  @override
  String get drawerMilestones => 'माइलस्टोन';

  @override
  String drawerMilestoneFocus(int hours, int minutes) {
    return 'कुल फ़ोकस: $hours घंटे $minutes मिनट';
  }

  @override
  String drawerMilestoneCats(int count) {
    return 'बिल्ली परिवार: $count';
  }

  @override
  String drawerMilestoneQuests(int count) {
    return 'सक्रिय क्वेस्ट: $count';
  }

  @override
  String get drawerMySection => 'मेरा';

  @override
  String get drawerSessionHistory => 'फ़ोकस इतिहास';

  @override
  String get drawerCheckInCalendar => 'चेक-इन कैलेंडर';

  @override
  String get drawerAccountSection => 'खाता';

  @override
  String get settingsResetData => 'सारा डेटा रीसेट करें';

  @override
  String get settingsResetDataTitle => 'सारा डेटा रीसेट करें?';

  @override
  String get settingsResetDataMessage =>
      'इससे सारा लोकल डेटा हट जाएगा और स्वागत स्क्रीन पर लौट जाएँगे। यह पूर्ववत नहीं किया जा सकता।';

  @override
  String get guestUpgradeTitle => 'अपना डेटा सुरक्षित रखें';

  @override
  String get guestUpgradeMessage =>
      'अपनी प्रगति का बैकअप लेने, AI डायरी और चैट सुविधाएँ अनलॉक करने, और सभी डिवाइस पर सिंक करने के लिए खाता लिंक करें।';

  @override
  String get guestUpgradeLinkButton => 'खाता लिंक करें';

  @override
  String get guestUpgradeLater => 'बाद में';

  @override
  String get loginLinkTagline =>
      'अपना डेटा सुरक्षित रखने के लिए खाता लिंक करें';

  @override
  String get aiTeaserTitle => 'बिल्ली की डायरी';

  @override
  String aiTeaserPreview(String catName) {
    return 'आज मैंने फिर से अपने इंसान के साथ पढ़ाई की... $catName हर दिन ज़्यादा स्मार्ट महसूस कर रही है~';
  }

  @override
  String aiTeaserCta(String catName) {
    return '$catName क्या कहना चाहती है, देखने के लिए खाता लिंक करें';
  }

  @override
  String get authErrorEmailInUse => 'यह ईमेल पहले से रजिस्टर है';

  @override
  String get authErrorWrongPassword => 'ग़लत ईमेल या पासवर्ड';

  @override
  String get authErrorUserNotFound => 'इस ईमेल से कोई खाता नहीं मिला';

  @override
  String get authErrorTooManyRequests =>
      'बहुत ज़्यादा प्रयास। बाद में कोशिश करें';

  @override
  String get authErrorNetwork => 'नेटवर्क त्रुटि। अपना कनेक्शन जाँचें';

  @override
  String get authErrorAdminRestricted => 'साइन-इन अस्थायी रूप से प्रतिबंधित है';

  @override
  String get authErrorWeakPassword =>
      'पासवर्ड कमज़ोर है। कम से कम 6 अक्षर इस्तेमाल करें';

  @override
  String get authErrorGeneric => 'कुछ गड़बड़ हो गई। पुनः प्रयास करें';

  @override
  String get deleteAccountReauthEmail => 'जारी रखने के लिए अपना पासवर्ड डालें';

  @override
  String get deleteAccountReauthPasswordHint => 'पासवर्ड';

  @override
  String get deleteAccountError =>
      'कुछ गड़बड़ हो गई। बाद में पुनः प्रयास करें।';

  @override
  String get deleteAccountPermissionError =>
      'अनुमति त्रुटि। लॉग आउट करके फिर से लॉग इन करें।';

  @override
  String get deleteAccountNetworkError =>
      'इंटरनेट कनेक्शन नहीं है। अपना नेटवर्क जाँचें।';

  @override
  String get deleteAccountRetainedData =>
      'उपयोग विश्लेषण और क्रैश रिपोर्ट हटाए नहीं जा सकते।';

  @override
  String get deleteAccountStepCloud => 'क्लाउड डेटा हटाया जा रहा है...';

  @override
  String get deleteAccountStepLocal => 'लोकल डेटा साफ़ किया जा रहा है...';

  @override
  String get deleteAccountStepDone => 'पूरा हुआ';

  @override
  String get deleteAccountQueued =>
      'लोकल डेटा हटाया गया। क्लाउड खाता हटाने की कतार में है और ऑनलाइन होने पर पूरा होगा।';

  @override
  String get deleteAccountPending =>
      'खाता हटाना लंबित है। क्लाउड और प्रमाणीकरण हटाने के लिए ऐप को ऑनलाइन रखें।';

  @override
  String get deleteAccountAbandon => 'नई शुरुआत करें';

  @override
  String get archiveConflictTitle => 'रखने के लिए आर्काइव चुनें';

  @override
  String get archiveConflictMessage =>
      'लोकल और क्लाउड दोनों आर्काइव में डेटा है। किसे रखना है चुनें:';

  @override
  String get archiveConflictLocal => 'लोकल आर्काइव';

  @override
  String get archiveConflictCloud => 'क्लाउड आर्काइव';

  @override
  String get archiveConflictKeepCloud => 'क्लाउड रखें';

  @override
  String get archiveConflictKeepLocal => 'लोकल रखें';

  @override
  String get loginShowPassword => 'पासवर्ड दिखाएँ';

  @override
  String get loginHidePassword => 'पासवर्ड छिपाएँ';

  @override
  String get errorGeneric => 'कुछ गड़बड़ हो गई। बाद में पुनः प्रयास करें';

  @override
  String get errorCreateHabit => 'आदत बनाने में विफल। पुनः प्रयास करें';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginForgotPasswordTitle => 'Reset password';

  @override
  String get loginSendResetEmail => 'Send reset email';

  @override
  String get loginResetEmailSent =>
      'Password reset email sent. Check your inbox';

  @override
  String get authErrorUserDisabled => 'This account has been disabled';

  @override
  String get authErrorInvalidEmail => 'Please enter a valid email address';

  @override
  String get authErrorRequiresRecentLogin => 'Please log in again to continue';

  @override
  String get commonCopyId => 'ID कॉपी करें';

  @override
  String get adoptionClearDeadline => 'समय सीमा हटाएं';

  @override
  String get commonIdCopied => 'ID कॉपी हो गई';

  @override
  String get pickerDurationLabel => 'अवधि चयनकर्ता';

  @override
  String pickerMinutesValue(int count) {
    return '$count मिनट';
  }

  @override
  String a11yCatImage(String name) {
    return 'बिल्ली $name';
  }

  @override
  String a11yCatTapToInteract(String name) {
    return '$name, बातचीत के लिए टैप करें';
  }

  @override
  String a11yProgressPercent(int percent) {
    return '$percent% पूर्ण';
  }

  @override
  String a11yStreakActiveDays(int count) {
    return '$count सक्रिय दिन';
  }

  @override
  String get a11yOfflineStatus => 'ऑफ़लाइन मोड';

  @override
  String a11yAchievementUnlocked(String name) {
    return 'उपलब्धि अनलॉक: $name';
  }

  @override
  String get calendarCheckedIn => 'चेक इन किया';

  @override
  String get calendarToday => 'आज';

  @override
  String a11yEquipToCat(Object name) {
    return '$name को लगाएँ';
  }

  @override
  String a11yRegenerateCat(Object name) {
    return '$name पुनः बनाएँ';
  }

  @override
  String a11yTimerDisplay(Object time) {
    return 'टाइमर: $time';
  }

  @override
  String a11yOnboardingPage(Object current, Object total) {
    return '$total में से $current पेज';
  }

  @override
  String a11yEditDisplayName(Object name) {
    return 'प्रदर्शन नाम संपादित करें: $name';
  }

  @override
  String get routeNotFound => 'पेज नहीं मिला';

  @override
  String get routeGoHome => 'होम पर जाएँ';

  @override
  String get a11yError => 'त्रुटि';

  @override
  String get a11yDeadline => 'समय सीमा';

  @override
  String get a11yReminder => 'रिमाइंडर';

  @override
  String get a11yFocusMeditation => 'ध्यान';

  @override
  String get a11yUnlocked => 'अनलॉक किया गया';

  @override
  String get a11ySelected => 'चयनित';

  @override
  String get a11yDynamicWallpaperColor => 'डायनामिक वॉलपेपर रंग';
}
