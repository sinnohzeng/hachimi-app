// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class STr extends S {
  STr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Hachimi - Light Up My Innerverse';

  @override
  String get homeTabToday => 'Bugün';

  @override
  String get homeTabCatHouse => 'CatHouse';

  @override
  String get homeTabStats => 'İstatistik';

  @override
  String get homeTabProfile => 'Profil';

  @override
  String get adoptionStepDefineHabit => 'Alışkanlık Belirle';

  @override
  String get adoptionStepAdoptCat => 'Kedi Sahiplen';

  @override
  String get adoptionStepNameCat => 'Kediye İsim Ver';

  @override
  String get adoptionHabitName => 'Alışkanlık Adı';

  @override
  String get adoptionHabitNameHint => 'ör. Günlük Okuma';

  @override
  String get adoptionDailyGoal => 'Günlük Hedef';

  @override
  String get adoptionTargetHours => 'Hedef Saat';

  @override
  String get adoptionTargetHoursHint =>
      'Bu alışkanlığı tamamlamak için gereken toplam saat';

  @override
  String adoptionMinutes(int count) {
    return '$count dk';
  }

  @override
  String get adoptionRefreshCat => 'Başka dene';

  @override
  String adoptionPersonality(String name) {
    return 'Kişilik: $name';
  }

  @override
  String get adoptionNameYourCat => 'Kedine isim ver';

  @override
  String get adoptionRandomName => 'Rastgele';

  @override
  String get adoptionCreate => 'Alışkanlık Oluştur ve Sahiplen';

  @override
  String get adoptionNext => 'İleri';

  @override
  String get adoptionBack => 'Geri';

  @override
  String get adoptionCatNameLabel => 'Kedi adı';

  @override
  String get adoptionCatNameHint => 'ör. Mochi';

  @override
  String get adoptionRandomNameTooltip => 'Rastgele isim';

  @override
  String get catHouseTitle => 'CatHouse';

  @override
  String get catHouseEmpty =>
      'Henüz kedi yok! Bir alışkanlık oluşturarak ilk kedini sahiplen.';

  @override
  String catHouseGrowth(int minutes, int target) {
    return '$minutes / $target dk';
  }

  @override
  String get catDetailGrowthProgress => 'Büyüme İlerlemesi';

  @override
  String catDetailTotalMinutes(int minutes) {
    return '$minutes dk odaklanıldı';
  }

  @override
  String catDetailTargetMinutes(int minutes) {
    return 'Hedef: $minutes dk';
  }

  @override
  String get catDetailRename => 'Yeniden Adlandır';

  @override
  String get catDetailAccessories => 'Aksesuarlar';

  @override
  String get catDetailStartFocus => 'Odaklanmaya Başla';

  @override
  String get catDetailBoundHabit => 'Bağlı Alışkanlık';

  @override
  String catDetailStage(String stage) {
    return 'Aşama: $stage';
  }

  @override
  String coinBalance(int amount) {
    return '$amount jeton';
  }

  @override
  String coinCheckInReward(int amount) {
    return '+$amount jeton!';
  }

  @override
  String get coinCheckInTitle => 'Günlük Giriş';

  @override
  String get coinInsufficientBalance => 'Yeterli jeton yok';

  @override
  String get shopTitle => 'Aksesuar Dükkanı';

  @override
  String shopPrice(int price) {
    return '$price jeton';
  }

  @override
  String get shopPurchase => 'Satın Al';

  @override
  String get shopEquipped => 'Takılı';

  @override
  String focusCompleteMinutes(int minutes) {
    return '+$minutes dk';
  }

  @override
  String get focusCompleteStageUp => 'Aşama Atladı!';

  @override
  String get focusCompleteGreatJob => 'Harika iş!';

  @override
  String get focusCompleteDone => 'Tamam';

  @override
  String get focusCompleteItsOkay => 'Sorun değil!';

  @override
  String focusCompleteEvolved(String catName) {
    return '$catName evrimleşti!';
  }

  @override
  String focusCompleteFocusedFor(int minutes) {
    return '$minutes dakika odaklandın';
  }

  @override
  String focusCompleteAbandonedMessage(String catName) {
    return '$catName diyor ki: \"Tekrar deneriz!\"';
  }

  @override
  String get focusCompleteFocusTime => 'Odak süresi';

  @override
  String get focusCompleteCoinsEarned => 'Kazanılan jeton';

  @override
  String get focusCompleteBaseXp => 'Temel XP';

  @override
  String get focusCompleteStreakBonus => 'Seri bonusu';

  @override
  String get focusCompleteMilestoneBonus => 'Kilometre taşı bonusu';

  @override
  String get focusCompleteFullHouseBonus => 'Full house bonusu';

  @override
  String get focusCompleteTotal => 'Toplam';

  @override
  String focusCompleteEvolvedTo(String stage) {
    return '$stage aşamasına evrildi!';
  }

  @override
  String get focusCompleteYourCat => 'Kedin';

  @override
  String get focusCompleteDiaryWriting => 'Günlük yazılıyor...';

  @override
  String get focusCompleteDiaryWritten => 'Günlük yazıldı!';

  @override
  String get focusCompleteDiarySkipped => 'Günlük atlandı';

  @override
  String get focusCompleteNotifTitle => 'Görev tamamlandı!';

  @override
  String focusCompleteNotifBody(String catName, int xp, int minutes) {
    return '$catName $minutes dk odaklanarak +$xp XP kazandı';
  }

  @override
  String get stageKitten => 'Yavru Kedi';

  @override
  String get stageAdolescent => 'Ergen';

  @override
  String get stageAdult => 'Yetişkin';

  @override
  String get stageSenior => 'Yaşlı';

  @override
  String get migrationTitle => 'Veri Güncellemesi Gerekli';

  @override
  String get migrationMessage =>
      'Hachimi yeni piksel kedi sistemiyle güncellendi! Eski kedi verilerin artık uyumlu değil. Yeni deneyime başlamak için sıfırla.';

  @override
  String get migrationResetButton => 'Sıfırla ve Yeniden Başla';

  @override
  String get sessionResumeTitle => 'Oturuma devam et?';

  @override
  String sessionResumeMessage(String habitName, String elapsed) {
    return 'Aktif bir odak oturumun var ($habitName, $elapsed). Devam et?';
  }

  @override
  String get sessionResumeButton => 'Devam Et';

  @override
  String get sessionDiscard => 'Vazgeç';

  @override
  String get todaySummaryMinutes => 'Bugün';

  @override
  String get todaySummaryTotal => 'Toplam';

  @override
  String get todaySummaryCats => 'Kediler';

  @override
  String get todayYourQuests => 'Görevlerin';

  @override
  String get todayNoQuests => 'Henüz görev yok';

  @override
  String get todayNoQuestsHint =>
      'Bir görev başlatmak ve kedi sahiplenmek için + simgesine dokun!';

  @override
  String get todayFocus => 'Odaklan';

  @override
  String get todayDeleteQuestTitle => 'Görev silinsin mi?';

  @override
  String todayDeleteQuestMessage(String name) {
    return '\"$name\" silinsin mi? Kedi albümüne mezun olacak.';
  }

  @override
  String todayQuestCompleted(String name) {
    return '$name tamamlandı';
  }

  @override
  String get todayFailedToLoad => 'Görevler yüklenemedi';

  @override
  String todayMinToday(int count) {
    return 'Bugün $count dk';
  }

  @override
  String todayGoalMinPerDay(int count) {
    return 'Hedef: $count dk/gün';
  }

  @override
  String get todayFeaturedCat => 'Öne Çıkan Kedi';

  @override
  String get todayAddHabit => 'Alışkanlık Ekle';

  @override
  String get todayNoHabits => 'Başlamak için ilk alışkanlığını oluştur!';

  @override
  String get todayNewQuest => 'Yeni görev';

  @override
  String get todayStartFocus => 'Odaklanmaya başla';

  @override
  String get timerStart => 'Başla';

  @override
  String get timerPause => 'Duraklat';

  @override
  String get timerResume => 'Devam';

  @override
  String get timerDone => 'Tamam';

  @override
  String get timerGiveUp => 'Pes Et';

  @override
  String get timerRemaining => 'kalan';

  @override
  String get timerElapsed => 'geçen';

  @override
  String get timerPaused => 'DURAKLATILDI';

  @override
  String get timerQuestNotFound => 'Görev bulunamadı';

  @override
  String get timerNotificationBanner =>
      'Uygulama arka plandayken zamanlayıcı ilerlemesini görmek için bildirimleri etkinleştir';

  @override
  String get timerNotificationDismiss => 'Kapat';

  @override
  String get timerNotificationEnable => 'Etkinleştir';

  @override
  String timerGraceBack(int seconds) {
    return 'Geri (${seconds}sn)';
  }

  @override
  String get giveUpTitle => 'Pes et?';

  @override
  String get giveUpMessage =>
      'En az 5 dakika odaklandıysan, bu süre kedinin büyümesi için yine sayılır. Kedin anlayışla karşılar!';

  @override
  String get giveUpKeepGoing => 'Devam Et';

  @override
  String get giveUpConfirm => 'Pes Et';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsGeneral => 'Genel';

  @override
  String get settingsAppearance => 'Görünüm';

  @override
  String get settingsNotifications => 'Bildirimler';

  @override
  String get settingsNotificationFocusReminders => 'Odak Hatırlatıcıları';

  @override
  String get settingsNotificationSubtitle =>
      'Yolunda kalmak için günlük hatırlatıcılar al';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsLanguageSystem => 'Sistem varsayılanı';

  @override
  String get settingsLanguageEnglish => 'İngilizce';

  @override
  String get settingsLanguageChinese => '中文';

  @override
  String get settingsThemeMode => 'Tema Modu';

  @override
  String get settingsThemeModeSystem => 'Sistem';

  @override
  String get settingsThemeModeLight => 'Açık';

  @override
  String get settingsThemeModeDark => 'Koyu';

  @override
  String get settingsThemeColor => 'Tema Rengi';

  @override
  String get settingsThemeColorDynamic => 'Dinamik';

  @override
  String get settingsThemeColorDynamicSubtitle =>
      'Duvar kağıdı renklerini kullan';

  @override
  String get settingsAbout => 'Hakkında';

  @override
  String get settingsVersion => 'Sürüm';

  @override
  String get settingsLicenses => 'Lisanslar';

  @override
  String get settingsAccount => 'Hesap';

  @override
  String get logoutTitle => 'Çıkış yap?';

  @override
  String get logoutMessage => 'Çıkış yapmak istediğinden emin misin?';

  @override
  String get loggingOut => 'Çıkış yapılıyor...';

  @override
  String get deleteAccountTitle => 'Hesap silinsin mi?';

  @override
  String get deleteAccountMessage =>
      'Bu işlem hesabını ve tüm verilerini kalıcı olarak silecek. Bu işlem geri alınamaz.';

  @override
  String get deleteAccountWarning => 'Bu işlem geri alınamaz';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileYourJourney => 'Yolculuğun';

  @override
  String get profileTotalFocus => 'Toplam Odak';

  @override
  String get profileTotalCats => 'Toplam Kedi';

  @override
  String get profileTotalQuests => 'Görevler';

  @override
  String get profileEditName => 'İsim düzenle';

  @override
  String get profileDisplayName => 'Görünen ad';

  @override
  String get profileChooseAvatar => 'Avatar seç';

  @override
  String get profileSaved => 'Profil kaydedildi';

  @override
  String get profileSettings => 'Ayarlar';

  @override
  String get habitDetailStreak => 'Seri';

  @override
  String get habitDetailBestStreak => 'En İyi';

  @override
  String get habitDetailTotalMinutes => 'Toplam';

  @override
  String get commonCancel => 'İptal';

  @override
  String get commonConfirm => 'Onayla';

  @override
  String get commonSave => 'Kaydet';

  @override
  String get commonDelete => 'Sil';

  @override
  String get commonEdit => 'Düzenle';

  @override
  String get commonDone => 'Tamam';

  @override
  String get commonDismiss => 'Kapat';

  @override
  String get commonEnable => 'Etkinleştir';

  @override
  String get commonLoading => 'Yükleniyor...';

  @override
  String get commonError => 'Bir şeyler ters gitti';

  @override
  String get commonRetry => 'Tekrar Dene';

  @override
  String get commonResume => 'Devam';

  @override
  String get commonPause => 'Duraklat';

  @override
  String get commonLogOut => 'Çıkış Yap';

  @override
  String get commonDeleteAccount => 'Hesabı Sil';

  @override
  String get commonYes => 'Evet';

  @override
  String chatDailyRemaining(int count) {
    return 'Bugün $count mesaj hakkın kaldı';
  }

  @override
  String get chatDailyLimitReached => 'Günlük mesaj sınırına ulaşıldı';

  @override
  String get aiTemporarilyUnavailable =>
      'AI özellikleri geçici olarak kullanılamıyor';

  @override
  String get catDetailNotFound => 'Kedi bulunamadı';

  @override
  String get catDetailLoadError => 'Kedi verileri yüklenemedi';

  @override
  String get catDetailChatTooltip => 'Sohbet';

  @override
  String get catDetailRenameTooltip => 'Yeniden Adlandır';

  @override
  String get catDetailGrowthTitle => 'Büyüme İlerlemesi';

  @override
  String catDetailTarget(int hours) {
    return 'Hedef: ${hours}sa';
  }

  @override
  String get catDetailRenameTitle => 'Kediyi Yeniden Adlandır';

  @override
  String get catDetailNewName => 'Yeni isim';

  @override
  String get catDetailRenamed => 'Kedi yeniden adlandırıldı!';

  @override
  String get catDetailQuestBadge => 'Görev';

  @override
  String get catDetailEditQuest => 'Görevi düzenle';

  @override
  String get catDetailDailyGoal => 'Günlük hedef';

  @override
  String get catDetailTodaysFocus => 'Bugünkü odak';

  @override
  String get catDetailTotalFocus => 'Toplam odak';

  @override
  String get catDetailTargetLabel => 'Hedef';

  @override
  String get catDetailCompletion => 'Tamamlanma';

  @override
  String get catDetailCurrentStreak => 'Mevcut seri';

  @override
  String get catDetailBestStreakLabel => 'En iyi seri';

  @override
  String get catDetailAvgDaily => 'Günlük ortalama';

  @override
  String get catDetailDaysActive => 'Aktif günler';

  @override
  String get catDetailCheckInDays => 'Giriş günleri';

  @override
  String get catDetailEditQuestTitle => 'Görevi Düzenle';

  @override
  String get catDetailQuestName => 'Görev adı';

  @override
  String get catDetailDailyGoalMinutes => 'Günlük hedef (dakika)';

  @override
  String get catDetailTargetTotalHours => 'Toplam hedef (saat)';

  @override
  String get catDetailQuestUpdated => 'Görev güncellendi!';

  @override
  String get catDetailTargetCompletedHint =>
      'Hedefe zaten ulaşıldı — şimdi sınırsız modda';

  @override
  String get catDetailDailyReminder => 'Günlük Hatırlatıcı';

  @override
  String catDetailEveryDay(String time) {
    return 'Her gün $time';
  }

  @override
  String get catDetailNoReminder => 'Hatırlatıcı ayarlanmadı';

  @override
  String get catDetailChange => 'Değiştir';

  @override
  String get catDetailRemoveReminder => 'Hatırlatıcıyı kaldır';

  @override
  String get catDetailSet => 'Ayarla';

  @override
  String catDetailReminderSet(String time) {
    return '$time için hatırlatıcı ayarlandı';
  }

  @override
  String get catDetailReminderRemoved => 'Hatırlatıcı kaldırıldı';

  @override
  String get catDetailDiaryTitle => 'Hachimi Günlüğü';

  @override
  String get catDetailDiaryLoading => 'Yükleniyor...';

  @override
  String get catDetailDiaryError => 'Günlük yüklenemedi';

  @override
  String get catDetailDiaryEmpty =>
      'Bugün henüz günlük yok. Bir odak oturumu tamamla!';

  @override
  String catDetailChatWith(String name) {
    return '$name ile sohbet';
  }

  @override
  String get catDetailChatSubtitle => 'Kedinle sohbet et';

  @override
  String get catDetailActivity => 'Etkinlik';

  @override
  String get catDetailActivityError => 'Etkinlik verileri yüklenemedi';

  @override
  String get catDetailAccessoriesTitle => 'Aksesuarlar';

  @override
  String get catDetailEquipped => 'Takılı: ';

  @override
  String get catDetailNone => 'Yok';

  @override
  String get catDetailUnequip => 'Çıkar';

  @override
  String catDetailFromInventory(int count) {
    return 'Envanterden ($count)';
  }

  @override
  String get catDetailNoAccessories => 'Henüz aksesuar yok. Dükkana git!';

  @override
  String catDetailEquippedItem(String name) {
    return '$name takıldı';
  }

  @override
  String get catDetailUnequipped => 'Çıkarıldı';

  @override
  String catDetailAbout(String name) {
    return '$name Hakkında';
  }

  @override
  String get catDetailAppearanceDetails => 'Görünüm detayları';

  @override
  String get catDetailStatus => 'Durum';

  @override
  String get catDetailAdopted => 'Sahiplenildi';

  @override
  String get catDetailFurPattern => 'Kürk deseni';

  @override
  String get catDetailFurColor => 'Kürk rengi';

  @override
  String get catDetailFurLength => 'Kürk uzunluğu';

  @override
  String get catDetailEyes => 'Gözler';

  @override
  String get catDetailWhitePatches => 'Beyaz lekeler';

  @override
  String get catDetailPatchesTint => 'Leke tonu';

  @override
  String get catDetailTint => 'Ton';

  @override
  String get catDetailPoints => 'Noktalar';

  @override
  String get catDetailVitiligo => 'Vitiligo';

  @override
  String get catDetailTortoiseshell => 'Kaplumbağa kabuğu';

  @override
  String get catDetailTortiePattern => 'Tortie deseni';

  @override
  String get catDetailTortieColor => 'Tortie rengi';

  @override
  String get catDetailSkin => 'Cilt';

  @override
  String get offlineMessage =>
      'Çevrimdışısın — değişiklikler yeniden bağlandığında senkronize edilecek';

  @override
  String get offlineModeLabel => 'Çevrimdışı mod';

  @override
  String habitTodayMinutes(int count) {
    return 'Bugün: $count dk';
  }

  @override
  String get habitDeleteTooltip => 'Alışkanlığı sil';

  @override
  String get heatmapActiveDays => 'Aktif günler';

  @override
  String get heatmapTotal => 'Toplam';

  @override
  String get heatmapRate => 'Oran';

  @override
  String get heatmapLess => 'Az';

  @override
  String get heatmapMore => 'Çok';

  @override
  String get accessoryEquipped => 'Takılı';

  @override
  String get accessoryOwned => 'Sahip olunan';

  @override
  String get pickerMinUnit => 'dk';

  @override
  String get settingsBackgroundAnimation => 'Animasyonlu arka plan';

  @override
  String get settingsBackgroundAnimationSubtitle =>
      'Mesh gradyanı ve yüzen parçacıklar';

  @override
  String get settingsUiStyle => 'Arayüz stili';

  @override
  String get settingsUiStyleMaterial => 'Material 3';

  @override
  String get settingsUiStyleRetroPixel => 'Retro Piksel';

  @override
  String get settingsUiStyleMaterialSubtitle =>
      'Modern, yuvarlak Material Design';

  @override
  String get settingsUiStyleRetroPixelSubtitle => 'Sıcak piksel sanat estetiği';

  @override
  String get personalityLazy => 'Tembel';

  @override
  String get personalityCurious => 'Meraklı';

  @override
  String get personalityPlayful => 'Oyuncu';

  @override
  String get personalityShy => 'Utangaç';

  @override
  String get personalityBrave => 'Cesur';

  @override
  String get personalityClingy => 'Yapışkan';

  @override
  String get personalityFlavorLazy =>
      'Günde 23 saat uyuyacak. Diğer saat? O da uyuyor.';

  @override
  String get personalityFlavorCurious =>
      'Şimdiden her şeyi koklayıp inceliyor!';

  @override
  String get personalityFlavorPlayful => 'Kelebekleri kovalamayı bırakamıyor!';

  @override
  String get personalityFlavorShy =>
      'Kutudan dışarı bakmak 3 dakikasını aldı...';

  @override
  String get personalityFlavorBrave => 'Kutu açılmadan önce atladı!';

  @override
  String get personalityFlavorClingy =>
      'Hemen mırlamaya başladı ve bırakmıyor.';

  @override
  String get moodHappy => 'Mutlu';

  @override
  String get moodNeutral => 'Nötr';

  @override
  String get moodLonely => 'Yalnız';

  @override
  String get moodMissing => 'Seni Özlüyor';

  @override
  String get moodMsgLazyHappy => 'Nya~! Hak edilmiş bir uyku zamanı...';

  @override
  String get moodMsgCuriousHappy => 'Bugün ne keşfediyoruz?';

  @override
  String get moodMsgPlayfulHappy => 'Nya~! Çalışmaya hazırım!';

  @override
  String get moodMsgShyHappy => '...B-burada olduğuna sevindim.';

  @override
  String get moodMsgBraveHappy => 'Bugünü birlikte aşalım!';

  @override
  String get moodMsgClingyHappy => 'Yaşasın! Döndün! Bir daha gitme!';

  @override
  String get moodMsgLazyNeutral => '*esneme* Ah, merhaba...';

  @override
  String get moodMsgCuriousNeutral => 'Hmm, orada ne var?';

  @override
  String get moodMsgPlayfulNeutral => 'Oynayalım mı? Belki sonra...';

  @override
  String get moodMsgShyNeutral => '*yavaşça dışarı bakıyor*';

  @override
  String get moodMsgBraveNeutral => 'Her zamanki gibi nöbette.';

  @override
  String get moodMsgClingyNeutral => 'Seni bekliyordum...';

  @override
  String get moodMsgLazyLonely => 'Uyumak bile yalnız hissettiriyor...';

  @override
  String get moodMsgCuriousLonely => 'Acaba ne zaman geri geleceksin...';

  @override
  String get moodMsgPlayfulLonely => 'Oyuncaklar sensiz eğlenceli değil...';

  @override
  String get moodMsgShyLonely => '*sessizce kıvrılıyor*';

  @override
  String get moodMsgBraveLonely =>
      'Beklemeye devam edeceğim. Ben cesaretliyim.';

  @override
  String get moodMsgClingyLonely => 'Nereye gittin... 🥺';

  @override
  String get moodMsgLazyMissing => '*umutla bir gözünü açıyor*';

  @override
  String get moodMsgCuriousMissing => 'Bir şey mi oldu...?';

  @override
  String get moodMsgPlayfulMissing => 'En sevdiğin oyuncağı sakladım...';

  @override
  String get moodMsgShyMissing => '*saklanıyor ama kapıyı izliyor*';

  @override
  String get moodMsgBraveMissing => 'Geri geleceğini biliyorum. İnanıyorum.';

  @override
  String get moodMsgClingyMissing => 'Seni çok özledim... lütfen geri dön.';

  @override
  String get peltTypeTabby => 'Klasik tabby çizgileri';

  @override
  String get peltTypeTicked => 'Ticked agouti deseni';

  @override
  String get peltTypeMackerel => 'Uskumru tabby';

  @override
  String get peltTypeClassic => 'Klasik girdap deseni';

  @override
  String get peltTypeSokoke => 'Sokoke mermer deseni';

  @override
  String get peltTypeAgouti => 'Agouti ticked';

  @override
  String get peltTypeSpeckled => 'Benekli kürk';

  @override
  String get peltTypeRosette => 'Rozet benekli';

  @override
  String get peltTypeSingleColour => 'Düz renk';

  @override
  String get peltTypeTwoColour => 'İki renkli';

  @override
  String get peltTypeSmoke => 'Dumanlı gölgeleme';

  @override
  String get peltTypeSinglestripe => 'Tek çizgi';

  @override
  String get peltTypeBengal => 'Bengal deseni';

  @override
  String get peltTypeMarbled => 'Mermer deseni';

  @override
  String get peltTypeMasked => 'Maskeli yüz';

  @override
  String get peltColorWhite => 'Beyaz';

  @override
  String get peltColorPaleGrey => 'Açık gri';

  @override
  String get peltColorSilver => 'Gümüş';

  @override
  String get peltColorGrey => 'Gri';

  @override
  String get peltColorDarkGrey => 'Koyu gri';

  @override
  String get peltColorGhost => 'Hayalet grisi';

  @override
  String get peltColorBlack => 'Siyah';

  @override
  String get peltColorCream => 'Krem';

  @override
  String get peltColorPaleGinger => 'Açık zencefil';

  @override
  String get peltColorGolden => 'Altın';

  @override
  String get peltColorGinger => 'Zencefil';

  @override
  String get peltColorDarkGinger => 'Koyu zencefil';

  @override
  String get peltColorSienna => 'Sienna';

  @override
  String get peltColorLightBrown => 'Açık kahve';

  @override
  String get peltColorLilac => 'Leylak';

  @override
  String get peltColorBrown => 'Kahverengi';

  @override
  String get peltColorGoldenBrown => 'Altın kahve';

  @override
  String get peltColorDarkBrown => 'Koyu kahve';

  @override
  String get peltColorChocolate => 'Çikolata';

  @override
  String get eyeColorYellow => 'Sarı';

  @override
  String get eyeColorAmber => 'Kehribar';

  @override
  String get eyeColorHazel => 'Ela';

  @override
  String get eyeColorPaleGreen => 'Açık yeşil';

  @override
  String get eyeColorGreen => 'Yeşil';

  @override
  String get eyeColorBlue => 'Mavi';

  @override
  String get eyeColorDarkBlue => 'Koyu mavi';

  @override
  String get eyeColorBlueYellow => 'Mavi-sarı';

  @override
  String get eyeColorBlueGreen => 'Mavi-yeşil';

  @override
  String get eyeColorGrey => 'Gri';

  @override
  String get eyeColorCyan => 'Camgöbeği';

  @override
  String get eyeColorEmerald => 'Zümrüt';

  @override
  String get eyeColorHeatherBlue => 'Lavanta mavisi';

  @override
  String get eyeColorSunlitIce => 'Güneşli buz';

  @override
  String get eyeColorCopper => 'Bakır';

  @override
  String get eyeColorSage => 'Adaçayı';

  @override
  String get eyeColorCobalt => 'Kobalt';

  @override
  String get eyeColorPaleBlue => 'Açık mavi';

  @override
  String get eyeColorBronze => 'Bronz';

  @override
  String get eyeColorSilver => 'Gümüş';

  @override
  String get eyeColorPaleYellow => 'Açık sarı';

  @override
  String eyeDescNormal(String color) {
    return '$color gözler';
  }

  @override
  String eyeDescHeterochromia(String primary, String secondary) {
    return 'Heterokromi ($primary / $secondary)';
  }

  @override
  String get skinColorPink => 'Pembe';

  @override
  String get skinColorRed => 'Kırmızı';

  @override
  String get skinColorBlack => 'Siyah';

  @override
  String get skinColorDark => 'Koyu';

  @override
  String get skinColorDarkBrown => 'Koyu kahve';

  @override
  String get skinColorBrown => 'Kahverengi';

  @override
  String get skinColorLightBrown => 'Açık kahve';

  @override
  String get skinColorDarkGrey => 'Koyu gri';

  @override
  String get skinColorGrey => 'Gri';

  @override
  String get skinColorDarkSalmon => 'Koyu somon';

  @override
  String get skinColorSalmon => 'Somon';

  @override
  String get skinColorPeach => 'Şeftali';

  @override
  String get furLengthLonghair => 'Uzun tüylü';

  @override
  String get furLengthShorthair => 'Kısa tüylü';

  @override
  String get whiteTintOffwhite => 'Kırık beyaz tonu';

  @override
  String get whiteTintCream => 'Krem tonu';

  @override
  String get whiteTintDarkCream => 'Koyu krem tonu';

  @override
  String get whiteTintGray => 'Gri tonu';

  @override
  String get whiteTintPink => 'Pembe tonu';

  @override
  String notifReminderTitle(String catName) {
    return '$catName seni özlüyor!';
  }

  @override
  String notifReminderBody(String habitName) {
    return '$habitName zamanı — kedin seni bekliyor!';
  }

  @override
  String notifStreakTitle(String catName) {
    return '$catName endişeli!';
  }

  @override
  String notifStreakBody(int streak) {
    return '$streak günlük serin risk altında. Kısa bir oturum kurtarabilir!';
  }

  @override
  String notifEvolutionTitle(String catName) {
    return '$catName evrimleşti!';
  }

  @override
  String notifEvolutionBody(String catName, String stageName) {
    return '$catName $stageName aşamasına ulaştı! Harika gidiyorsun!';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '${hours}sa ${minutes}dk';
  }

  @override
  String diaryScreenTitle(String name) {
    return '$name Günlüğü';
  }

  @override
  String get diaryFailedToLoad => 'Günlük yüklenemedi';

  @override
  String get diaryEmptyTitle => 'Henüz günlük girişi yok';

  @override
  String get diaryEmptyHint =>
      'Bir odak oturumu tamamla ve kedin ilk günlük girişini yazsın!';

  @override
  String get focusSetupCountdown => 'Geri Sayım';

  @override
  String get focusSetupStopwatch => 'Kronometre';

  @override
  String get focusSetupStartFocus => 'Odaklanmaya Başla';

  @override
  String get focusSetupQuestNotFound => 'Görev bulunamadı';

  @override
  String get checkInButtonLogMore => 'Daha fazla süre kaydet';

  @override
  String get checkInButtonStart => 'Zamanlayıcıyı başlat';

  @override
  String get adoptionTitleFirst => 'İlk Kedini Sahiplen!';

  @override
  String get adoptionTitleNew => 'Yeni Görev';

  @override
  String get adoptionStepDefineQuest => 'Görev Belirle';

  @override
  String get adoptionStepAdoptCat2 => 'Kedi Sahiplen';

  @override
  String get adoptionStepNameCat2 => 'Kediye İsim Ver';

  @override
  String get adoptionAdopt => 'Sahiplen!';

  @override
  String get adoptionQuestPrompt => 'Hangi göreve başlamak istiyorsun?';

  @override
  String get adoptionKittenHint =>
      'Yolunda kalmana yardımcı olmak için bir yavru kedi atanacak!';

  @override
  String get adoptionQuestName => 'Görev adı';

  @override
  String get adoptionQuestHint => 'ör. Mülakat soruları hazırla';

  @override
  String get adoptionTotalTarget => 'Toplam hedef (saat)';

  @override
  String get adoptionGrowthHint => 'Odak süresi biriktirdikçe kedin büyür';

  @override
  String get adoptionCustom => 'Özel';

  @override
  String get adoptionDailyGoalLabel => 'Günlük odak hedefi (dk)';

  @override
  String get adoptionReminderLabel => 'Günlük hatırlatıcı (isteğe bağlı)';

  @override
  String get adoptionReminderNone => 'Yok';

  @override
  String get adoptionCustomGoalTitle => 'Özel günlük hedef';

  @override
  String get adoptionMinutesPerDay => 'Günlük dakika';

  @override
  String get adoptionMinutesHint => '5 - 180';

  @override
  String get adoptionValidMinutes => '5 ile 180 arasında bir değer gir';

  @override
  String get adoptionCustomTargetTitle => 'Özel hedef saat';

  @override
  String get adoptionTotalHours => 'Toplam saat';

  @override
  String get adoptionHoursHint => '10 - 2000';

  @override
  String get adoptionValidHours => '10 ile 2000 arasında bir değer gir';

  @override
  String get adoptionSet => 'Ayarla';

  @override
  String get adoptionChooseKitten => 'Yavru kedini seç!';

  @override
  String adoptionCompanionFor(String quest) {
    return '\"$quest\" için yol arkadaşın';
  }

  @override
  String get adoptionRerollAll => 'Hepsini Yenile';

  @override
  String get adoptionNameYourCat2 => 'Kedine isim ver';

  @override
  String get adoptionCatName => 'Kedi adı';

  @override
  String get adoptionCatHint => 'ör. Mochi';

  @override
  String get adoptionRandomTooltip => 'Rastgele isim';

  @override
  String adoptionGrowthTarget(String quest, int hours) {
    return '\"$quest\" üzerinde odaklandıkça kedin büyüyecek! Hedef: toplam ${hours}sa.';
  }

  @override
  String get adoptionValidQuestName => 'Bir görev adı gir';

  @override
  String get adoptionValidCatName => 'Kedine isim ver';

  @override
  String adoptionError(String message) {
    return 'Hata: $message';
  }

  @override
  String get adoptionBasicInfo => 'Temel bilgi';

  @override
  String get adoptionGoals => 'Hedefler';

  @override
  String get adoptionUnlimitedMode => 'Sınırsız mod';

  @override
  String get adoptionUnlimitedDesc => 'Üst sınır yok, biriktirmeye devam et';

  @override
  String get adoptionMilestoneMode => 'Kilometre taşı modu';

  @override
  String get adoptionMilestoneDesc => 'Ulaşılacak bir hedef belirle';

  @override
  String get adoptionDeadlineLabel => 'Son tarih';

  @override
  String get adoptionDeadlineNone => 'Ayarlanmadı';

  @override
  String get adoptionReminderSection => 'Hatırlatıcı';

  @override
  String get adoptionMotivationLabel => 'Not';

  @override
  String get adoptionMotivationHint => 'Bir not yaz...';

  @override
  String get adoptionMotivationSwap => 'Rastgele doldur';

  @override
  String get loginAppName => 'Hachimi';

  @override
  String get loginTagline => 'Kedi besle. Görevleri tamamla.';

  @override
  String get loginContinueGoogle => 'Google ile devam et';

  @override
  String get loginContinueEmail => 'E-posta ile devam et';

  @override
  String get loginAlreadyHaveAccount => 'Zaten hesabın var mı? ';

  @override
  String get loginLogIn => 'Giriş Yap';

  @override
  String get loginWelcomeBack => 'Tekrar hoş geldin!';

  @override
  String get loginCreateAccount => 'Hesabını oluştur';

  @override
  String get loginEmail => 'E-posta';

  @override
  String get loginPassword => 'Şifre';

  @override
  String get loginConfirmPassword => 'Şifreyi Onayla';

  @override
  String get loginValidEmail => 'E-postanı gir';

  @override
  String get loginValidEmailFormat => 'Geçerli bir e-posta gir';

  @override
  String get loginValidPassword => 'Şifreni gir';

  @override
  String get loginValidPasswordLength => 'Şifre en az 6 karakter olmalıdır';

  @override
  String get loginValidPasswordMatch => 'Şifreler eşleşmiyor';

  @override
  String get loginCreateAccountButton => 'Hesap Oluştur';

  @override
  String get loginNoAccount => 'Hesabın yok mu? ';

  @override
  String get loginRegister => 'Kayıt Ol';

  @override
  String get checkInTitle => 'Aylık Giriş';

  @override
  String get checkInDays => 'Gün';

  @override
  String get checkInCoinsEarned => 'Kazanılan jeton';

  @override
  String get checkInAllMilestones => 'Tüm kilometre taşları alındı!';

  @override
  String checkInMilestoneProgress(int remaining, int bonus) {
    return '$remaining gün daha → +$bonus jeton';
  }

  @override
  String get checkInMilestones => 'Kilometre Taşları';

  @override
  String get checkInFullMonth => 'Tam ay';

  @override
  String get checkInRewardSchedule => 'Ödül Takvimi';

  @override
  String get checkInWeekday => 'Hafta içi (Pzt–Cum)';

  @override
  String checkInWeekdayReward(int coins) {
    return '$coins jeton/gün';
  }

  @override
  String get checkInWeekend => 'Hafta sonu (Cmt–Paz)';

  @override
  String checkInNDays(int count) {
    return '$count gün';
  }

  @override
  String get onboardTitle1 => 'Yol Arkadaşınla Tanış';

  @override
  String get onboardSubtitle1 => 'Her görev bir yavru kediyle başlar';

  @override
  String get onboardBody1 =>
      'Bir hedef belirle ve yavru kedi sahiplen.\nÜzerine odaklan ve kedinin büyümesini izle!';

  @override
  String get onboardTitle2 => 'Odaklan, Büyü, Evrimleş';

  @override
  String get onboardSubtitle2 => '4 büyüme aşaması';

  @override
  String get onboardBody2 =>
      'Her dakika odaklanman kedinin evrimleşmesine yardımcı olur\nminik bir yavrudan muhteşem bir yaşlı kediye!';

  @override
  String get onboardTitle3 => 'Kedi Odanı Kur';

  @override
  String get onboardSubtitle3 => 'Benzersiz kediler topla';

  @override
  String get onboardBody3 =>
      'Her görev benzersiz görünümlü yeni bir kedi getirir.\nHepsini keşfet ve hayalindeki koleksiyonu kur!';

  @override
  String get onboardSkip => 'Atla';

  @override
  String get onboardLetsGo => 'Hadi Başlayalım!';

  @override
  String get onboardNext => 'İleri';

  @override
  String get catRoomTitle => 'CatHouse';

  @override
  String get catRoomInventory => 'Envanter';

  @override
  String get catRoomShop => 'Aksesuar Dükkanı';

  @override
  String get catRoomLoadError => 'Kediler yüklenemedi';

  @override
  String get catRoomEmptyTitle => 'CatHouse\'un boş';

  @override
  String get catRoomEmptySubtitle =>
      'İlk kedini sahiplenmek için bir görev başlat!';

  @override
  String get catRoomEditQuest => 'Görevi Düzenle';

  @override
  String get catRoomRenameCat => 'Kediyi Yeniden Adlandır';

  @override
  String get catRoomArchiveCat => 'Kediyi Arşivle';

  @override
  String get catRoomNewName => 'Yeni isim';

  @override
  String get catRoomRename => 'Yeniden Adlandır';

  @override
  String get catRoomArchiveTitle => 'Kedi arşivlensin mi?';

  @override
  String catRoomArchiveMessage(String name) {
    return 'Bu işlem \"$name\" adlı kediyi arşivleyecek ve bağlı görevini silecek. Kedi albümünde görünmeye devam edecek.';
  }

  @override
  String get catRoomArchive => 'Arşivle';

  @override
  String catRoomAlbumSection(int count) {
    return 'Albüm ($count)';
  }

  @override
  String get catRoomReactivateCat => 'Kediyi Yeniden Etkinleştir';

  @override
  String get catRoomReactivateTitle => 'Kedi yeniden etkinleştirilsin mi?';

  @override
  String catRoomReactivateMessage(String name) {
    return 'Bu işlem \"$name\" adlı kediyi ve bağlı görevini CatHouse\'a geri getirecek.';
  }

  @override
  String get catRoomReactivate => 'Yeniden Etkinleştir';

  @override
  String get catRoomArchivedLabel => 'Arşivlendi';

  @override
  String catRoomArchiveSuccess(String name) {
    return '\"$name\" arşivlendi';
  }

  @override
  String catRoomReactivateSuccess(String name) {
    return '\"$name\" yeniden etkinleştirildi';
  }

  @override
  String get catRoomArchiveError => 'Kedi arşivlenemedi';

  @override
  String get catRoomReactivateError => 'Kedi yeniden etkinleştirilemedi';

  @override
  String get catRoomArchiveLoadError => 'Arşivlenmiş kediler yüklenemedi';

  @override
  String get catRoomRenameError => 'Kedi yeniden adlandırılamadı';

  @override
  String get addHabitTitle => 'Yeni Görev';

  @override
  String get addHabitQuestName => 'Görev adı';

  @override
  String get addHabitQuestHint => 'ör. LeetCode Pratik';

  @override
  String get addHabitValidName => 'Bir görev adı gir';

  @override
  String get addHabitTargetHours => 'Hedef saat';

  @override
  String get addHabitTargetHint => 'ör. 100';

  @override
  String get addHabitValidTarget => 'Hedef saati gir';

  @override
  String get addHabitValidNumber => 'Geçerli bir sayı gir';

  @override
  String get addHabitCreate => 'Görev Oluştur';

  @override
  String get addHabitHoursSuffix => 'saat';

  @override
  String shopTabPlants(int count) {
    return 'Bitkiler ($count)';
  }

  @override
  String shopTabWild(int count) {
    return 'Vahşi ($count)';
  }

  @override
  String shopTabCollars(int count) {
    return 'Tasmalar ($count)';
  }

  @override
  String get shopNoAccessories => 'Mevcut aksesuar yok';

  @override
  String shopBuyConfirm(String name) {
    return '$name satın alınsın mı?';
  }

  @override
  String get shopPurchaseButton => 'Satın Al';

  @override
  String get shopNotEnoughCoinsButton => 'Yeterli jeton yok';

  @override
  String shopPurchaseSuccess(String name) {
    return 'Satın alındı! $name envantere eklendi';
  }

  @override
  String shopPurchaseFailed(int price) {
    return 'Yeterli jeton yok ($price gerekli)';
  }

  @override
  String get inventoryTitle => 'Envanter';

  @override
  String inventoryInBox(int count) {
    return 'Kutuda ($count)';
  }

  @override
  String get inventoryEmpty =>
      'Envanterin boş.\nAksesuar almak için dükkana git!';

  @override
  String inventoryEquippedOnCats(int count) {
    return 'Kedilere Takılı ($count)';
  }

  @override
  String get inventoryNoEquipped => 'Hiçbir kedide aksesuar takılı değil.';

  @override
  String get inventoryUnequip => 'Çıkar';

  @override
  String get inventoryNoActiveCats => 'Aktif kedi yok';

  @override
  String inventoryEquipTo(String name) {
    return '$name şuraya takılsın:';
  }

  @override
  String inventoryEquipSuccess(String name) {
    return '$name takıldı';
  }

  @override
  String inventoryUnequipSuccess(String catName) {
    return '$catName üzerinden çıkarıldı';
  }

  @override
  String get chatCatNotFound => 'Kedi bulunamadı';

  @override
  String chatTitle(String name) {
    return '$name ile sohbet';
  }

  @override
  String get chatClearHistory => 'Geçmişi temizle';

  @override
  String chatEmptyTitle(String name) {
    return '$name ile tanış!';
  }

  @override
  String get chatEmptySubtitle =>
      'Kedinle sohbet başlat. Kişiliğine göre cevap verecek!';

  @override
  String get chatGenerating => 'Oluşturuluyor...';

  @override
  String get chatTypeMessage => 'Mesaj yaz...';

  @override
  String get chatClearConfirmTitle => 'Sohbet geçmişi silinsin mi?';

  @override
  String get chatClearConfirmMessage =>
      'Tüm mesajlar silinecek. Bu işlem geri alınamaz.';

  @override
  String get chatClearButton => 'Temizle';

  @override
  String get chatSend => 'Gönder';

  @override
  String get chatStop => 'Durdur';

  @override
  String get chatErrorMessage => 'Failed to send message. Tap to retry.';

  @override
  String get chatRetry => 'Retry';

  @override
  String get chatErrorGeneric => 'Bir sorun oluştu. Tekrar deneyin.';

  @override
  String diaryTitle(String name) {
    return '$name Günlüğü';
  }

  @override
  String get diaryLoadFailed => 'Günlük yüklenemedi';

  @override
  String get diaryRetry => 'Tekrar Dene';

  @override
  String get diaryEmptyTitle2 => 'Henüz günlük girişi yok';

  @override
  String get diaryEmptySubtitle =>
      'Bir odak oturumu tamamla ve kedin ilk günlük girişini yazsın!';

  @override
  String get statsTitle => 'İstatistikler';

  @override
  String get statsTotalHours => 'Toplam Saat';

  @override
  String statsTimeValue(int hours, int minutes) {
    return '${hours}sa ${minutes}dk';
  }

  @override
  String get statsBestStreak => 'En İyi Seri';

  @override
  String statsStreakDays(int count) {
    return '$count gün';
  }

  @override
  String get statsOverallProgress => 'Genel İlerleme';

  @override
  String statsPercentOfGoals(String percent) {
    return 'Tüm hedeflerin %$percent\'i';
  }

  @override
  String get statsPerQuestProgress => 'Görev Bazında İlerleme';

  @override
  String get statsQuestLoadError => 'Görev istatistikleri yüklenemedi';

  @override
  String get statsNoQuestData => 'Henüz görev verisi yok';

  @override
  String get statsNoQuestHint =>
      'İlerlemenizi burada görmek için bir görev başlat!';

  @override
  String get statsLast30Days => 'Son 30 Gün';

  @override
  String get habitDetailQuestNotFound => 'Görev bulunamadı';

  @override
  String get habitDetailComplete => 'tamamlandı';

  @override
  String get habitDetailTotalTime => 'Toplam Süre';

  @override
  String get habitDetailCurrentStreak => 'Mevcut Seri';

  @override
  String get habitDetailTarget => 'Hedef';

  @override
  String habitDetailDaysUnit(int count) {
    return '$count gün';
  }

  @override
  String habitDetailHoursUnit(int count) {
    return '$count saat';
  }

  @override
  String checkInBannerSuccess(int coins) {
    return '+$coins jeton! Günlük giriş tamamlandı';
  }

  @override
  String checkInBannerBonus(int bonus) {
    return ' + $bonus kilometre taşı bonusu!';
  }

  @override
  String get checkInBannerSemantics => 'Günlük giriş';

  @override
  String get checkInBannerLoading => 'Giriş durumu yükleniyor...';

  @override
  String checkInBannerPrompt(int coins) {
    return '+$coins jeton için giriş yap';
  }

  @override
  String checkInBannerSummary(int count, int total, int coins) {
    return '$count/$total gün  ·  bugün +$coins';
  }

  @override
  String commonErrorWithDetail(String error) {
    return 'Hata: $error';
  }

  @override
  String get profileFallbackUser => 'Kullanıcı';

  @override
  String get fallbackCatName => 'Kedi';

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
  String get notifFocusing => 'odaklanıyor...';

  @override
  String get notifInProgress => 'Odak oturumu devam ediyor';

  @override
  String get unitMinShort => 'dk';

  @override
  String get unitHourShort => 'sa';

  @override
  String get weekdayMon => 'Pt';

  @override
  String get weekdayTue => 'Sa';

  @override
  String get weekdayWed => 'Ça';

  @override
  String get weekdayThu => 'Pe';

  @override
  String get weekdayFri => 'Cu';

  @override
  String get weekdaySat => 'Ct';

  @override
  String get weekdaySun => 'Pa';

  @override
  String get statsTotalSessions => 'Oturumlar';

  @override
  String get statsTotalHabits => 'Alışkanlıklar';

  @override
  String get statsActiveDays => 'Aktif günler';

  @override
  String get statsWeeklyTrend => 'Haftalık eğilim';

  @override
  String get statsRecentSessions => 'Son odaklanmalar';

  @override
  String get statsViewAllHistory => 'Tüm geçmişi görüntüle';

  @override
  String get historyTitle => 'Odak geçmişi';

  @override
  String get historyFilterAll => 'Tümü';

  @override
  String historySessionCount(int count) {
    return '$count oturum';
  }

  @override
  String historyTotalMinutes(int minutes) {
    return '$minutes dk';
  }

  @override
  String get historyNoSessions => 'Henüz odak kaydı yok';

  @override
  String get historyNoSessionsHint =>
      'Burada görmek için bir odak oturumu tamamla';

  @override
  String get historyLoadMore => 'Daha fazla yükle';

  @override
  String get sessionCompleted => 'Tamamlandı';

  @override
  String get sessionAbandoned => 'Bırakıldı';

  @override
  String get sessionInterrupted => 'Kesildi';

  @override
  String get sessionCountdown => 'Geri sayım';

  @override
  String get sessionStopwatch => 'Kronometre';

  @override
  String get historyDateGroupToday => 'Bugün';

  @override
  String get historyDateGroupYesterday => 'Dün';

  @override
  String get historyLoadError => 'Geçmiş yüklenemedi';

  @override
  String get historySelectMonth => 'Ay seç';

  @override
  String get historyAllMonths => 'Tüm aylar';

  @override
  String get historyAllHabits => 'Tümü';

  @override
  String get homeTabAchievements => 'Başarılar';

  @override
  String get achievementTitle => 'Başarılar';

  @override
  String get achievementTabOverview => 'Genel Bakış';

  @override
  String get achievementTabQuest => 'Görev';

  @override
  String get achievementTabStreak => 'Seri';

  @override
  String get achievementTabCat => 'Kedi';

  @override
  String get achievementTabPersist => 'Azim';

  @override
  String get achievementSummaryTitle => 'Başarı İlerlemesi';

  @override
  String achievementUnlockedCount(int count) {
    return '$count açıldı';
  }

  @override
  String achievementTotalCoins(int coins) {
    return '$coins jeton kazanıldı';
  }

  @override
  String get achievementUnlocked => 'Başarı açıldı!';

  @override
  String get achievementAwesome => 'Harika!';

  @override
  String get achievementIncredible => 'İnanılmaz!';

  @override
  String get achievementHidden => '???';

  @override
  String get achievementHiddenDesc => 'Bu gizli bir başarı';

  @override
  String achievementPersistDesc(int days) {
    return 'Herhangi bir görevde $days giriş günü biriktir';
  }

  @override
  String achievementTitleCount(int count) {
    return '$count unvan açıldı';
  }

  @override
  String get growthPathTitle => 'Büyüme Yolu';

  @override
  String get growthPathKitten => 'Yeni bir yolculuk başlat';

  @override
  String get growthPathAdolescent => 'Temel yapıyı oluştur';

  @override
  String get growthPathAdult => 'Beceriler pekişiyor';

  @override
  String get growthPathSenior => 'Derin ustalık';

  @override
  String get growthPathTip =>
      'Araştırmalar, 20 saatlik odaklı pratikle yeni bir becerinin temelini oluşturmanın yeterli olduğunu gösteriyor — Josh Kaufman';

  @override
  String achievementCelebrationCoins(int count) {
    return '+$count jeton';
  }

  @override
  String achievementCelebrationTitle(String title) {
    return 'Kazanılan unvan: $title';
  }

  @override
  String get achievementCelebrationDismiss => 'Harika!';

  @override
  String get achievementCelebrationSkipAll => 'Hepsini atla';

  @override
  String achievementCelebrationCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String achievementUnlockedAt(String date) {
    return '$date tarihinde açıldı';
  }

  @override
  String get achievementLocked => 'Henüz açılmadı';

  @override
  String achievementRewardCoins(int count) {
    return '+$count jeton';
  }

  @override
  String get reminderModeDaily => 'Her gün';

  @override
  String get reminderModeWeekdays => 'Hafta içi';

  @override
  String get reminderModeMonday => 'Pazartesi';

  @override
  String get reminderModeTuesday => 'Salı';

  @override
  String get reminderModeWednesday => 'Çarşamba';

  @override
  String get reminderModeThursday => 'Perşembe';

  @override
  String get reminderModeFriday => 'Cuma';

  @override
  String get reminderModeSaturday => 'Cumartesi';

  @override
  String get reminderModeSunday => 'Pazar';

  @override
  String get reminderPickerTitle => 'Hatırlatıcı saati seç';

  @override
  String get reminderHourUnit => 'sa';

  @override
  String get reminderMinuteUnit => 'dk';

  @override
  String get reminderAddMore => 'Hatırlatıcı ekle';

  @override
  String get reminderMaxReached => 'En fazla 5 hatırlatıcı';

  @override
  String get reminderConfirm => 'Onayla';

  @override
  String reminderNotificationTitle(String catName) {
    return '$catName seni özlüyor!';
  }

  @override
  String reminderNotificationBody(String habitName) {
    return '$habitName zamanı — kedin seni bekliyor!';
  }

  @override
  String get deleteAccountDataWarning =>
      'Aşağıdaki tüm veriler kalıcı olarak silinecek:';

  @override
  String get deleteAccountQuests => 'Görevler';

  @override
  String get deleteAccountCats => 'Kediler';

  @override
  String get deleteAccountHours => 'Odak saatleri';

  @override
  String get deleteAccountIrreversible => 'Bu işlem geri alınamaz';

  @override
  String get deleteAccountContinue => 'Devam Et';

  @override
  String get deleteAccountConfirmTitle => 'Silmeyi onayla';

  @override
  String get deleteAccountTypeDelete =>
      'Hesap silmeyi onaylamak için DELETE yaz:';

  @override
  String get deleteAccountAuthCancelled => 'Kimlik doğrulama iptal edildi';

  @override
  String deleteAccountAuthFailed(String error) {
    return 'Kimlik doğrulama başarısız: $error';
  }

  @override
  String get deleteAccountProgress => 'Hesap siliniyor...';

  @override
  String get deleteAccountSuccess => 'Hesap silindi';

  @override
  String get drawerGuestLoginSubtitle =>
      'Verileri senkronize et ve AI özelliklerini aç';

  @override
  String get drawerGuestSignIn => 'Giriş yap';

  @override
  String get drawerMilestones => 'Kilometre Taşları';

  @override
  String drawerMilestoneFocus(int hours, int minutes) {
    return 'Toplam odak: ${hours}sa ${minutes}dk';
  }

  @override
  String drawerMilestoneCats(int count) {
    return 'Kedi ailesi: $count';
  }

  @override
  String drawerMilestoneQuests(int count) {
    return 'Aktif görevler: $count';
  }

  @override
  String get drawerMySection => 'Benim';

  @override
  String get drawerSessionHistory => 'Odak geçmişi';

  @override
  String get drawerCheckInCalendar => 'Giriş takvimi';

  @override
  String get drawerAccountSection => 'Hesap';

  @override
  String get settingsResetData => 'Tüm verileri sıfırla';

  @override
  String get settingsResetDataTitle => 'Tüm veriler sıfırlansın mı?';

  @override
  String get settingsResetDataMessage =>
      'Bu işlem tüm yerel verileri silecek ve karşılama ekranına dönecek. Bu işlem geri alınamaz.';

  @override
  String get guestUpgradeTitle => 'Verilerini koru';

  @override
  String get guestUpgradeMessage =>
      'İlerlemenizi yedeklemek, AI günlük ve sohbet özelliklerini açmak ve cihazlar arası senkronizasyon için bir hesap bağla.';

  @override
  String get guestUpgradeLinkButton => 'Hesap bağla';

  @override
  String get guestUpgradeLater => 'Belki sonra';

  @override
  String get loginLinkTagline => 'Verilerini korumak için bir hesap bağla';

  @override
  String get aiTeaserTitle => 'Kedi günlüğü';

  @override
  String aiTeaserPreview(String catName) {
    return 'Bugün yine insanımla çalıştım... $catName her gün daha akıllı hissediyor~';
  }

  @override
  String aiTeaserCta(String catName) {
    return '$catName ne söylemek istediğini görmek için bir hesap bağla';
  }

  @override
  String get authErrorEmailInUse => 'Bu e-posta zaten kayıtlı';

  @override
  String get authErrorWrongPassword => 'Yanlış e-posta veya şifre';

  @override
  String get authErrorUserNotFound => 'Bu e-posta ile kayıtlı hesap bulunamadı';

  @override
  String get authErrorTooManyRequests =>
      'Çok fazla deneme. Daha sonra tekrar dene';

  @override
  String get authErrorNetwork => 'Ağ hatası. Bağlantını kontrol et';

  @override
  String get authErrorAdminRestricted => 'Giriş geçici olarak kısıtlandı';

  @override
  String get authErrorWeakPassword =>
      'Şifre çok zayıf. En az 6 karakter kullan';

  @override
  String get authErrorGeneric => 'Bir şeyler ters gitti. Tekrar dene';

  @override
  String get deleteAccountReauthEmail => 'Devam etmek için şifreni gir';

  @override
  String get deleteAccountReauthPasswordHint => 'Şifre';

  @override
  String get deleteAccountError =>
      'Bir şeyler ters gitti. Daha sonra tekrar dene.';

  @override
  String get deleteAccountPermissionError =>
      'İzin hatası. Çıkış yapıp tekrar giriş yapmayı dene.';

  @override
  String get deleteAccountNetworkError =>
      'İnternet bağlantısı yok. Ağını kontrol et.';

  @override
  String get deleteAccountRetainedData =>
      'Kullanım analitiği ve hata raporları silinemez.';

  @override
  String get deleteAccountStepCloud => 'Bulut verileri siliniyor...';

  @override
  String get deleteAccountStepLocal => 'Yerel veriler temizleniyor...';

  @override
  String get deleteAccountStepDone => 'Tamamlandı';

  @override
  String get deleteAccountQueued =>
      'Yerel veriler silindi. Bulut hesap silme işlemi sıraya alındı ve çevrimiçi olunca tamamlanacak.';

  @override
  String get deleteAccountPending =>
      'Hesap silme beklemede. Bulut ve kimlik doğrulama silme işlemini tamamlamak için uygulamayı çevrimiçi tut.';

  @override
  String get deleteAccountAbandon => 'Yeniden başla';

  @override
  String get archiveConflictTitle => 'Saklanacak arşivi seç';

  @override
  String get archiveConflictMessage =>
      'Hem yerel hem bulut arşivde veri var. Birini seç:';

  @override
  String get archiveConflictLocal => 'Yerel arşiv';

  @override
  String get archiveConflictCloud => 'Bulut arşiv';

  @override
  String get archiveConflictKeepCloud => 'Bulutu sakla';

  @override
  String get archiveConflictKeepLocal => 'Yereli sakla';

  @override
  String get loginShowPassword => 'Şifreyi göster';

  @override
  String get loginHidePassword => 'Şifreyi gizle';

  @override
  String get errorGeneric => 'Bir şeyler ters gitti. Daha sonra tekrar dene';

  @override
  String get errorCreateHabit => 'Alışkanlık oluşturulamadı. Tekrar dene';

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
  String get commonCopyId => 'ID\'yi kopyala';

  @override
  String get adoptionClearDeadline => 'Son tarihi temizle';

  @override
  String get commonIdCopied => 'ID kopyalandı';

  @override
  String get pickerDurationLabel => 'Süre seçici';

  @override
  String pickerMinutesValue(int count) {
    return '$count dakika';
  }

  @override
  String a11yCatImage(String name) {
    return 'Kedi $name';
  }

  @override
  String a11yCatTapToInteract(String name) {
    return '$name, etkileşim için dokun';
  }

  @override
  String a11yProgressPercent(int percent) {
    return '%$percent tamamlandı';
  }

  @override
  String a11yStreakActiveDays(int count) {
    return '$count aktif gün';
  }

  @override
  String get a11yOfflineStatus => 'Çevrimdışı mod';

  @override
  String a11yAchievementUnlocked(String name) {
    return 'Başarım açıldı: $name';
  }

  @override
  String get calendarCheckedIn => 'giriş yapıldı';

  @override
  String get calendarToday => 'bugün';

  @override
  String a11yEquipToCat(Object name) {
    return '$name için giydirin';
  }

  @override
  String a11yRegenerateCat(Object name) {
    return '$name yeniden oluştur';
  }

  @override
  String a11yTimerDisplay(Object time) {
    return 'Zamanlayıcı: $time';
  }

  @override
  String a11yOnboardingPage(Object current, Object total) {
    return '$total sayfadan $current. sayfa';
  }

  @override
  String a11yEditDisplayName(Object name) {
    return 'Görünen adı düzenle: $name';
  }

  @override
  String get routeNotFound => 'Sayfa bulunamadı';

  @override
  String get routeGoHome => 'Ana sayfaya git';

  @override
  String get a11yError => 'Hata';

  @override
  String get a11yDeadline => 'Son tarih';

  @override
  String get a11yReminder => 'Hatırlatma';

  @override
  String get a11yFocusMeditation => 'Odaklanma meditasyonu';

  @override
  String get a11yUnlocked => 'Kilidi açıldı';

  @override
  String get a11ySelected => 'Seçildi';

  @override
  String get a11yDynamicWallpaperColor => 'Dinamik duvar kağıdı rengi';

  @override
  String get awarenessTitle => 'Awareness';

  @override
  String get awarenessTabToday => 'Today';

  @override
  String get awarenessTabThisWeek => 'This Week';

  @override
  String get awarenessTabReview => 'Review';

  @override
  String get moodVeryHappy => 'Very Happy';

  @override
  String get moodCalm => 'Calm';

  @override
  String get moodDown => 'Down';

  @override
  String get moodVeryDown => 'Very Down';

  @override
  String get awarenessLightPlaceholder => 'What made you smile today?';

  @override
  String get awarenessLightSaved => 'Light recorded ✨';

  @override
  String get awarenessLightEdit => 'Edit';

  @override
  String get weeklyReviewTitle => 'Weekly Review';

  @override
  String weeklyReviewHappyMoment(int number) {
    return 'Happy Moment #$number';
  }

  @override
  String get weeklyReviewHappyMomentHint => 'What made you happy this week?';

  @override
  String get weeklyReviewGratitude => 'Gratitude';

  @override
  String get weeklyReviewGratitudeHint => 'Who or what are you grateful for?';

  @override
  String get weeklyReviewLearning => 'Learning';

  @override
  String get weeklyReviewLearningHint => 'What did you learn this week?';

  @override
  String get weeklyReviewSave => 'Save Review';

  @override
  String get weeklyReviewSaved => 'Review saved ✨';

  @override
  String get worryProcessorTitle => 'Worry Processor';

  @override
  String get worryDescriptionHint => 'What\'s bothering you?';

  @override
  String get worrySolutionHint => 'What could you do about it?';

  @override
  String get worryStatusOngoing => 'Ongoing';

  @override
  String get worryStatusResolved => 'Resolved';

  @override
  String get worryStatusDisappeared => 'Gone';

  @override
  String get worryAdd => 'Add Worry';

  @override
  String get worrySave => 'Save';

  @override
  String get worryResolvedSection => 'Resolved & Gone';

  @override
  String get worryManageAll => 'Manage all worries';

  @override
  String get awarenessEmptyLightTitle => 'No light recorded yet';

  @override
  String get awarenessEmptyLightSubtitle => 'Whenever you\'re ready ✨';

  @override
  String get awarenessEmptyLightAction => 'Record';

  @override
  String get awarenessEmptyReviewTitle => 'Take your time';

  @override
  String get awarenessEmptyReviewSubtitle => 'Review when you feel like it 🐱';

  @override
  String get awarenessEmptyReviewAction => 'Start Review';

  @override
  String get awarenessEmptyHistoryTitle => 'Every light matters';

  @override
  String get awarenessEmptyHistorySubtitle => 'Your history will appear here';

  @override
  String get awarenessEmptyWorriesTitle => 'No worries? Great! 🎉';

  @override
  String get awarenessEmptyWorriesSubtitle => 'That\'s wonderful';

  @override
  String get catReactVeryHappy => 'So happy today! Meow~ 🎉';

  @override
  String get catReactHappy => 'Another light recorded ✨';

  @override
  String get catReactCalm => 'A calm day is a good day 🍃';

  @override
  String get catReactDown => 'I\'m here with you 💛';

  @override
  String get catReactVeryDown => 'Not going anywhere 🫂';

  @override
  String get awarenessBridgePrompt => 'What made you smile today? ✨';

  @override
  String get awarenessBridgeRecord => 'Record';

  @override
  String get awarenessBridgeSkip => 'Skip';

  @override
  String get awarenessHabitsSection => 'Today\'s Habits';

  @override
  String get awarenessHabitsEmpty => 'No habits yet. Adopt a cat to start!';

  @override
  String get awarenessReviewComingSoon => 'Coming soon';

  @override
  String get awarenessMoodRequired => 'Please select today\'s mood';

  @override
  String get awarenessSaveFailed => 'Save failed, please try again';

  @override
  String get awarenessLoadFailed => 'Failed to load, please go back and retry';

  @override
  String get awarenessSaved => 'Saved';

  @override
  String get worryDescriptionRequired => 'Please describe your worry';

  @override
  String get worryLoadFailed => 'Failed to load worry';

  @override
  String get awarenessLoginRequired => 'Please log in first';

  @override
  String get tagCustom => '+Custom';

  @override
  String get homeTabAwareness => 'Awareness';

  @override
  String get homeTabHabits => 'Habits';

  @override
  String get monthlyRitualSetupTitle =>
      'A new month — pick a habit to focus on';

  @override
  String get monthlyRitualSetupDesc =>
      'Choose your focus habit, set a flexible goal, and promise yourself a reward.';

  @override
  String get monthlyRitualSetupButton => 'Set up';

  @override
  String get monthlyRitualDialogTitle => 'Monthly ritual';

  @override
  String get monthlyRitualHabitLabel => 'Focus habit';

  @override
  String get monthlyRitualTargetLabel => 'Target days';

  @override
  String monthlyRitualTargetValue(int count) {
    return '$count days';
  }

  @override
  String get monthlyRitualRewardHint => 'Reward myself with...';

  @override
  String get monthlyRitualRewardLabel => 'Reward';

  @override
  String monthlyRitualProgress(int completed, int target) {
    return '$completed/$target days done ✨';
  }

  @override
  String get monthlyRitualAchieved => 'Goal achieved! 🎉';

  @override
  String get monthlyRitualEncouragement => 'Every day counts';

  @override
  String get achievementLightFirstName => 'First Light';

  @override
  String get achievementLightFirstDesc => 'Record your first daily light';

  @override
  String get achievementLight7Name => 'Week of Light';

  @override
  String get achievementLight7Desc =>
      'Record daily light for 7 days (cumulative)';

  @override
  String get achievementLight30Name => 'Month of Light';

  @override
  String get achievementLight30Desc =>
      'Record daily light for 30 days (cumulative)';

  @override
  String get achievementLight100Name => 'Century of Light';

  @override
  String get achievementLight100Desc =>
      'Record daily light for 100 days (cumulative)';

  @override
  String get achievementReviewFirstName => 'First Review';

  @override
  String get achievementReviewFirstDesc => 'Complete your first weekly review';

  @override
  String get achievementReview4Name => 'Monthly Reviewer';

  @override
  String get achievementReview4Desc => 'Complete 4 weekly reviews (cumulative)';

  @override
  String get achievementWorryResolved1Name => 'First Release';

  @override
  String get achievementWorryResolved1Desc =>
      'Resolve or release your first worry';

  @override
  String get achievementWorryResolved10Name => 'Worry Whisperer';

  @override
  String get achievementWorryResolved10Desc =>
      'Resolve or release 10 worries (cumulative)';

  @override
  String get notifBedtimeLight =>
      'How was your day? Take a moment to notice something good ✨';

  @override
  String get notifWeeklyReview =>
      'Sunday evening — a good time to look back at your week 📖';

  @override
  String get notifMonthlyRitual =>
      'A new month begins! Pick a habit to focus on this month 🌙';

  @override
  String get notifGentleReengagement =>
      'No pressure — come back whenever you\'re ready 🌿';

  @override
  String get calendarMon => 'Mon';

  @override
  String get calendarTue => 'Tue';

  @override
  String get calendarWed => 'Wed';

  @override
  String get calendarThu => 'Thu';

  @override
  String get calendarFri => 'Fri';

  @override
  String get calendarSat => 'Sat';

  @override
  String get calendarSun => 'Sun';

  @override
  String get historyWeeklyReviews => 'Weekly Reviews';

  @override
  String historyHappyMoments(int count) {
    return '$count happy moments';
  }

  @override
  String historyWeekRange(String startDate, String endDate) {
    return '$startDate - $endDate';
  }

  @override
  String get dailyDetailTitle => 'Daily Detail';

  @override
  String get dailyDetailEdit => 'Edit Record';

  @override
  String get dailyDetailLight => 'Today\'s Light';

  @override
  String get dailyDetailTimeline => 'Today\'s Timeline';

  @override
  String get dailyDetailNoRecord => 'No record for this day';

  @override
  String get dailyDetailGoRecord => 'Go Record';

  @override
  String get awarenessStatsTitle => 'Awareness Stats';

  @override
  String get awarenessStatsMoodDistribution => 'Mood Distribution';

  @override
  String get awarenessStatsLightDays => 'Light Days';

  @override
  String get awarenessStatsWeeklyReviews => 'Reviews';

  @override
  String get awarenessStatsResolutionRate => 'Resolution Rate';

  @override
  String get awarenessStatsTopTags => 'Top Tags';

  @override
  String get awarenessStatsMonthlyChallenge => 'Monthly Challenge';

  @override
  String get awarenessStatsStartRecording => 'Start recording your first light';

  @override
  String get timelineEventHint => 'What happened?';

  @override
  String get tabToday => 'Today';

  @override
  String get tabJourney => 'Journey';

  @override
  String get tabProfile => 'Me';

  @override
  String get onboardingWelcome => 'Hello';

  @override
  String get onboardingLumiIntro => 'This is LUMI';

  @override
  String get onboardingSlogan =>
      'Every line you write adds a star to your inner universe';

  @override
  String get onboardingNamePrompt => 'The owner of this journal is';

  @override
  String get onboardingNameHint => 'Your name';

  @override
  String get onboardingBirthdayPrompt => 'Your birthday';

  @override
  String get onboardingBirthdayMonth => 'Month';

  @override
  String get onboardingBirthdayDay => 'Day';

  @override
  String get onboardingStartDatePrompt =>
      'When would you like to start this journey?';

  @override
  String get onboardingThreeThings => 'LUMI has just three little things';

  @override
  String get onboardingDailyLight => 'Write one line before bed';

  @override
  String get onboardingDailyLightSub => 'Today\'s little light';

  @override
  String get onboardingWeeklyReview => 'Weekend review';

  @override
  String get onboardingWeeklyReviewSub => 'Three happy moments';

  @override
  String get onboardingWorryJar => 'Write down worries';

  @override
  String get onboardingWorryJarSub => 'Put them in the worry jar';

  @override
  String get onboardingStart => 'Start the journey';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingNext => 'Next';

  @override
  String todayGreeting(String name) {
    return 'Good morning, $name';
  }

  @override
  String get quickLightPlaceholder => 'What made you smile today?';

  @override
  String get recordLight => 'Record';

  @override
  String get noHabitsYet => 'No habits yet. You can set them in monthly plans.';

  @override
  String get segmentWeek => 'This Week';

  @override
  String get segmentMonth => 'This Month';

  @override
  String get segmentYear => 'Year';

  @override
  String get segmentExplore => 'Explore';

  @override
  String get featureLockedTitle => 'Coming Soon';

  @override
  String featureLockedMessage(int days) {
    return 'Record $days more days to unlock. No rush.';
  }

  @override
  String get weeklyPlanTitle => 'Weekly Plan';

  @override
  String get oneLineForSelf => 'Write a line for yourself this week';

  @override
  String get urgentImportant => 'Must Do';

  @override
  String get importantNotUrgent => 'Should Do';

  @override
  String get urgentNotImportant => 'Need to Do';

  @override
  String get wantToDo => 'Want to Do';

  @override
  String get monthlyGoals => 'Monthly Goals';

  @override
  String get smallWinChallenge => 'Small Win Challenge';

  @override
  String get monthlyPassion => 'Monthly Passion';

  @override
  String get moodTracker => 'Mood Tracker';

  @override
  String get monthlyMemory => 'Monthly Memory';

  @override
  String get monthlyAchievement => 'Monthly Achievement';

  @override
  String get yearlyMessages => 'Yearly Messages';

  @override
  String get growthPlan => 'Growth Plan';

  @override
  String get annualCalendar => 'Annual Calendar';

  @override
  String get lumiStats => 'My Stars';

  @override
  String totalStars(int count) {
    return '$count stars';
  }

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get longestStreak => 'Longest Streak';

  @override
  String get catCompanion => 'Cat Companion';

  @override
  String get growthReview => 'Growth Review';

  @override
  String greetingLateNight(String name) {
    return 'Gece oldu, $name';
  }

  @override
  String greetingMorning(String name) {
    return 'Günaydın, $name';
  }

  @override
  String greetingAfternoon(String name) {
    return 'İyi öğlenler, $name';
  }

  @override
  String greetingEvening(String name) {
    return 'İyi akşamlar, $name';
  }

  @override
  String get greetingLateNightNoName => 'Gece oldu';

  @override
  String get greetingMorningNoName => 'Günaydın';

  @override
  String get greetingAfternoonNoName => 'İyi öğlenler';

  @override
  String get greetingEveningNoName => 'İyi akşamlar';

  @override
  String get journeyTitle => 'Yolculuk';

  @override
  String get journeySegmentWeek => 'Hafta';

  @override
  String get journeySegmentMonth => 'Ay';

  @override
  String get journeySegmentYear => 'Yıl';

  @override
  String get journeySegmentExplore => 'Keşfet';

  @override
  String get journeyMonthlyView => 'Aylık görünüm';

  @override
  String get journeyYearlyView => 'Yıllık görünüm';

  @override
  String get journeyExploreActivities => 'Etkinlikler';

  @override
  String get journeyEditMonthlyPlan => 'Aylık planı düzenle';

  @override
  String get journeyEditYearlyPlan => 'Yıllık planı düzenle';

  @override
  String get quickLightTitle => 'Günün düşüncesi';

  @override
  String get quickLightHint => 'Bugün nasıl hissediyorsun?';

  @override
  String get quickLightRecord => 'Kaydet';

  @override
  String get quickLightSaveSuccess => 'Kaydedildi';

  @override
  String get quickLightSaveError => 'Kaydetme başarısız. Tekrar dene';

  @override
  String get habitSnapshotTitle => 'Bugünkü alışkanlıklar';

  @override
  String get habitSnapshotEmpty => 'Henüz alışkanlık yok. Yolculuğunda ayarla';

  @override
  String get habitSnapshotLoadError => 'Yükleme başarısız';

  @override
  String get worryJarTitle => 'Endişe kavanozu';

  @override
  String get worryJarLoadError => 'Yükleme başarısız';

  @override
  String get weeklyReviewEmpty => 'Bu haftanın mutlu anlarını kaydet';

  @override
  String get weeklyReviewHappyMoments => 'Mutlu anlar';

  @override
  String get weeklyReviewLoadError => 'Yükleme başarısız';

  @override
  String get weeklyPlanCardTitle => 'Haftalık plan';

  @override
  String weeklyPlanItemCount(int count) {
    return '$count öğe';
  }

  @override
  String get weeklyPlanEmpty => 'Haftalık plan oluştur';

  @override
  String get weekMoodTitle => 'Haftalık ruh hali';

  @override
  String get weekMoodLoadError => 'Ruh hali yüklenemedi';

  @override
  String featureLockedDaysRemaining(int remaining) {
    return '$remaining gün daha kaydet ve aç';
  }

  @override
  String get featureLockedSoon => 'Yakında';

  @override
  String get weeklyPlanScreenTitle => 'Haftalık plan';

  @override
  String get weeklyPlanSave => 'Kaydet';

  @override
  String get weeklyPlanSaveSuccess => 'Kaydedildi';

  @override
  String get weeklyPlanSaveError => 'Kaydetme başarısız';

  @override
  String get weeklyPlanOneLine => 'Bu hafta kendine bir söz';

  @override
  String get weeklyPlanOneLineHint => 'Bu hafta istiyorum ki...';

  @override
  String get weeklyPlanUrgentImportant => 'Acil ve önemli';

  @override
  String get weeklyPlanImportantNotUrgent => 'Önemli, acil değil';

  @override
  String get weeklyPlanUrgentNotImportant => 'Acil, önemli değil';

  @override
  String get weeklyPlanNotUrgentNotImportant => 'Ne acil ne önemli';

  @override
  String get weeklyPlanAddHint => 'Ekle...';

  @override
  String get weeklyPlanMustDo => 'Yapmalı';

  @override
  String get weeklyPlanShouldDo => 'Yapmalı';

  @override
  String get weeklyPlanNeedToDo => 'Yapabilir';

  @override
  String get weeklyPlanWantToDo => 'İstiyorum';

  @override
  String monthlyCalendarYearMonth(int year, int month) {
    return '$month/$year';
  }

  @override
  String get monthlyCalendarLoadError => 'Yükleme başarısız';

  @override
  String get monthlyGoalsTitle => 'Aylık hedefler';

  @override
  String monthlyGoalHint(int index) {
    return 'Hedef $index';
  }

  @override
  String get monthlySaveError => 'Kaydetme başarısız';

  @override
  String get monthlyMemoryTitle => 'Ayın anısı';

  @override
  String get monthlyMemoryHint => 'Bu ayın en güzel anısı...';

  @override
  String get monthlyAchievementTitle => 'Ayın başarısı';

  @override
  String get monthlyAchievementHint => 'Bu ay en gurur duyduğum şey...';

  @override
  String get yearlyMessagesTitle => 'Yıllık mesajlar';

  @override
  String get yearlyMessageBecome => 'Bu yıl olmak istediğim kişi...';

  @override
  String get yearlyMessageGoals => 'Ulaşılacak hedefler';

  @override
  String get yearlyMessageBreakthrough => 'Atılım';

  @override
  String get yearlyMessageDontDo =>
      'Yapmamak (hayır demek önemli olana yer açar)';

  @override
  String get yearlyMessageKeyword =>
      'Yılın kelimesi (ör: Odak/Cesaret/Sabır/Nezaket)';

  @override
  String get yearlyMessageFutureSelf => 'Gelecekteki bana';

  @override
  String get yearlyMessageMotto => 'Sloganım';

  @override
  String get growthPlanTitle => 'Büyüme planı';

  @override
  String get growthPlanHint => 'Planım...';

  @override
  String get growthPlanSaveError => 'Kaydetme başarısız';

  @override
  String get growthDimensionHealth => 'Fiziksel sağlık';

  @override
  String get growthDimensionEmotion => 'Duygusal denge';

  @override
  String get growthDimensionRelationship => 'İlişkiler';

  @override
  String get growthDimensionCareer => 'Kariyer';

  @override
  String get growthDimensionFinance => 'Finansal sağlık';

  @override
  String get growthDimensionLearning => 'Sürekli öğrenme';

  @override
  String get growthDimensionCreativity => 'Yaratıcılık';

  @override
  String get growthDimensionSpirituality => 'İç büyüme';

  @override
  String get smallWinTitle => 'Küçük zafer challenge';

  @override
  String smallWinEmpty(int days) {
    return '$days günlük challenge başlat, her gün biraz';
  }

  @override
  String smallWinReward(String reward) {
    return 'Ödül: $reward';
  }

  @override
  String get smallWinLoadError => 'Yükleme başarısız';

  @override
  String get smallWinLawVisible => 'Görünür';

  @override
  String get smallWinLawAttractive => 'Çekici';

  @override
  String get smallWinLawEasy => 'Kolay';

  @override
  String get smallWinLawRewarding => 'Ödüllendirici';

  @override
  String get moodTrackerTitle => 'Ruh hali takibi';

  @override
  String get moodTrackerLoadError => 'Yükleme başarısız';

  @override
  String moodTrackerCount(int count) {
    return '$count kez';
  }

  @override
  String get habitTrackerTitle => 'Aylık tutku';

  @override
  String get habitTrackerComingSoon => 'Alışkanlık takibi geliştiriliyor';

  @override
  String get habitTrackerComingSoonHint =>
      'Alışkanlıkları küçük zafer challenge\'da ayarla';

  @override
  String get listsTitle => 'Listelerim';

  @override
  String get listBookTitle => 'Kitaplar';

  @override
  String get listMovieTitle => 'Filmler';

  @override
  String get listCustomTitle => 'Özel liste';

  @override
  String listItemCount(int count) {
    return '$count öğe';
  }

  @override
  String get listDetailBookTitle => 'Kitap listem';

  @override
  String get listDetailMovieTitle => 'Film listem';

  @override
  String get listDetailCustomTitle => 'Listem';

  @override
  String get listDetailSave => 'Kaydet';

  @override
  String get listDetailSaveSuccess => 'Kaydedildi';

  @override
  String get listDetailSaveError => 'Hata';

  @override
  String get listDetailCustomNameLabel => 'Liste adı';

  @override
  String get listDetailCustomNameHint => 'ör: Podcast listem';

  @override
  String get listDetailItemTitleHint => 'Başlık';

  @override
  String get listDetailItemDateHint => 'Tarih';

  @override
  String get listDetailItemGenreHint => 'Tür/Etiket';

  @override
  String get listDetailItemKeywordHint => 'Anahtar kelimeler/İzlenimler';

  @override
  String get listDetailYearTreasure => 'Yılın hazinesi';

  @override
  String get listDetailYearPick => 'Yılın favorisi';

  @override
  String get listDetailYearPickHint => 'Bu yılın en tavsiye edileni';

  @override
  String get listDetailInsight => 'İlham';

  @override
  String get listDetailInsightHint => 'En büyük ilham kaynağın';

  @override
  String get exploreMyMoments => 'Anlarım';

  @override
  String get exploreMyMomentsDesc => 'Mutlu ve özel anları kaydet';

  @override
  String get exploreHabitPact => 'Alışkanlık sözüm';

  @override
  String get exploreHabitPactDesc => 'Dört yasayla yeni alışkanlık tasarla';

  @override
  String get exploreWorryUnload => 'Endişe boşaltma günü';

  @override
  String get exploreWorryUnloadDesc =>
      'Endişeleri sınıfla: bırak, harekete geç veya kabul et';

  @override
  String get exploreSelfPraise => 'Övgü grubum';

  @override
  String get exploreSelfPraiseDesc => '5 güçlü yanını yaz';

  @override
  String get exploreSupportMap => 'Destek çevrem';

  @override
  String get exploreSupportMapDesc => 'Seni destekleyenleri kaydet';

  @override
  String get exploreFutureSelf => 'Gelecekteki ben';

  @override
  String get exploreFutureSelfDesc => '3 gelecek versiyonunu hayal et';

  @override
  String get exploreIdealVsReal => 'İdeal ben vs. Gerçek ben';

  @override
  String get exploreIdealVsRealDesc => 'İdeal ve gerçeğin kesiştiği yeri bul';

  @override
  String get highlightScreenTitle => 'Anlarım';

  @override
  String get highlightTabHappy => 'Mutlu anlar';

  @override
  String get highlightTabHighlight => 'Öne çıkanlar';

  @override
  String get highlightEmptyHappy => 'Henüz mutlu an yok';

  @override
  String get highlightEmptyHighlight => 'Henüz öne çıkan yok';

  @override
  String highlightLoadError(String error) {
    return 'Hata: $error';
  }

  @override
  String get monthlyPlanScreenTitle => 'Aylık plan';

  @override
  String get monthlyPlanSave => 'Kaydet';

  @override
  String get monthlyPlanSaveSuccess => 'Kaydedildi';

  @override
  String get monthlyPlanSaveError => 'Hata';

  @override
  String get monthlyPlanGoalsSection => 'Aylık hedefler';

  @override
  String get monthlyPlanChallengeSection => 'Küçük zafer challenge';

  @override
  String get monthlyPlanChallengeNameLabel => 'Challenge alışkanlığı';

  @override
  String get monthlyPlanChallengeNameHint => 'ör: Günde 10 dk koşu';

  @override
  String get monthlyPlanRewardLabel => 'Ödül';

  @override
  String get monthlyPlanRewardHint => 'ör: Bir kitap al';

  @override
  String get monthlyPlanSelfCareSection => 'Öz bakım';

  @override
  String monthlyPlanActivityHint(int index) {
    return 'Etkinlik $index';
  }

  @override
  String get monthlyPlanMemorySection => 'Ayın anısı';

  @override
  String get monthlyPlanMemoryHint => 'En güzel anı...';

  @override
  String get monthlyPlanAchievementSection => 'Ayın başarısı';

  @override
  String get monthlyPlanAchievementHint => 'En gurur duyduğum...';

  @override
  String yearlyPlanScreenTitle(int year) {
    return '$year yıllık plan';
  }

  @override
  String get yearlyPlanSave => 'Kaydet';

  @override
  String get yearlyPlanSaveSuccess => 'Kaydedildi';

  @override
  String get yearlyPlanSaveError => 'Hata';

  @override
  String get yearlyPlanMessagesSection => 'Yıllık mesajlar';

  @override
  String get yearlyPlanGrowthSection => 'Büyüme planı';

  @override
  String get growthReviewScreenTitle => 'Büyüme değerlendirmesi';

  @override
  String get growthReviewMyMoments => 'Özel anlarım';

  @override
  String get growthReviewEmptyMoments => 'Henüz öne çıkan yok';

  @override
  String get growthReviewMySummary => 'Özetim';

  @override
  String get growthReviewSummaryPrompt =>
      'Bu yolculuğa bakınca kendine ne söylersin?';

  @override
  String get growthReviewSmallWins => 'Küçük zafer ödülleri';

  @override
  String get growthReviewConsistentRecord => 'Tutarlı kayıt';

  @override
  String growthReviewRecordedDays(int count) {
    return '$count gün kaydettin';
  }

  @override
  String get growthReviewWeeklyChamp => 'Haftalık değerlendirme şampiyonu';

  @override
  String growthReviewCompletedReviews(int count) {
    return '$count haftalık değerlendirme tamamlandı';
  }

  @override
  String get growthReviewWarmClose => 'Sıcak bir kapanış';

  @override
  String get growthReviewEveryStar => 'Her gün bir yıldız';

  @override
  String growthReviewKeepShining(int count) {
    return '$count yıldız topladın. Parlamaya devam!';
  }

  @override
  String get futureSelfScreenTitle => 'Gelecekteki ben';

  @override
  String get futureSelfSubtitle => '3 gelecek versiyonunu hayal et';

  @override
  String get futureSelfHint =>
      'Mükemmel cevap gerekmiyor, hayal gücünü serbest bırak';

  @override
  String get futureSelfStable => 'Kararlı gelecek';

  @override
  String get futureSelfStableHint =>
      'Her şey yolunda giderse hayatın nasıl olur?';

  @override
  String get futureSelfFree => 'Özgür gelecek';

  @override
  String get futureSelfFreeHint => 'Hiçbir sınır olmasa ne yapardın?';

  @override
  String get futureSelfPace => 'Kendi hızında gelecek';

  @override
  String get futureSelfPaceHint => 'Acele etmeden, ideal ritmin ne?';

  @override
  String get futureSelfCoreLabel => 'Gerçekten önemsediğin ne?';

  @override
  String get futureSelfCoreHint =>
      '3 versiyonun ortak noktası ne? O belki de en önemli şey...';

  @override
  String get habitPactScreenTitle => 'Alışkanlık sözüm';

  @override
  String get habitPactStep1 => 'Hangi alışkanlığı istiyorum?';

  @override
  String get habitPactCategoryLearning => 'Öğrenme';

  @override
  String get habitPactCategoryHealth => 'Sağlık';

  @override
  String get habitPactCategoryRelationship => 'İlişkiler';

  @override
  String get habitPactCategoryHobby => 'Hobi';

  @override
  String get habitPactHabitLabel => 'Belirli alışkanlık';

  @override
  String get habitPactHabitHint => 'ör: Günde 20 sayfa oku';

  @override
  String get habitPactStep2 => 'Alışkanlığın dört yasası';

  @override
  String get habitPactLawVisible => 'Görünür kıl';

  @override
  String get habitPactLawVisibleHint => 'İpucunu koyacağım yer...';

  @override
  String get habitPactLawAttractive => 'Çekici kıl';

  @override
  String get habitPactLawAttractiveHint => 'Bununla eşleştireceğim...';

  @override
  String get habitPactLawEasy => 'Kolay kıl';

  @override
  String get habitPactLawEasyHint => 'Minimum versiyonum...';

  @override
  String get habitPactLawRewarding => 'Tatmin edici kıl';

  @override
  String get habitPactLawRewardingHint => 'Sonra kendimi ödüllendireceğim...';

  @override
  String get habitPactStep3 => 'Eylem bildirisi';

  @override
  String get habitPactDeclarationEmpty =>
      'Yukarıyı doldur, bildiri otomatik oluşsun...';

  @override
  String habitPactDeclarationPrefix(String habit) {
    return '\"$habit\" alışkanlığını oluşturmaya söz veriyorum';
  }

  @override
  String habitPactDeclarationWhen(String cue) {
    return '$cue olduğunda';
  }

  @override
  String habitPactDeclarationWill(String response) {
    return '$response yapacağım';
  }

  @override
  String habitPactDeclarationThen(String reward) {
    return 'sonra $reward';
  }

  @override
  String get idealVsRealScreenTitle => 'İdeal ben vs. Gerçek ben';

  @override
  String get idealVsRealIdeal => 'İdeal ben';

  @override
  String get idealVsRealIdealHint => 'Nasıl biri olmak istiyorum?';

  @override
  String get idealVsRealReal => 'Gerçek ben';

  @override
  String get idealVsRealRealHint => 'Şu an nasıl biriyim?';

  @override
  String get idealVsRealSame => 'Ortak noktalar?';

  @override
  String get idealVsRealSameHint => 'İdeal ve gerçek zaten nerede örtüşüyor?';

  @override
  String get idealVsRealDiff => 'Farklılıklar?';

  @override
  String get idealVsRealDiffHint => 'Fark nerede? Nasıl hissettiriyor?';

  @override
  String get idealVsRealStep => 'İdeale doğru küçük bir adım';

  @override
  String get idealVsRealStepHint => 'Bugün yapabileceğim küçük bir şey...';

  @override
  String get selfPraiseScreenTitle => 'Övgü grubum';

  @override
  String get selfPraiseSubtitle => '5 güçlü yanını yaz';

  @override
  String get selfPraiseHint =>
      'Herkes görülmeyi hak eder, özellikle kendisi tarafından';

  @override
  String selfPraiseStrengthLabel(int index) {
    return 'Güçlü yan $index';
  }

  @override
  String get selfPraisePrompt1 => 'En sıcak özelliğim...';

  @override
  String get selfPraisePrompt2 => 'İyi olduğum bir şey...';

  @override
  String get selfPraisePrompt3 => 'Sıkça övüldüğüm şey...';

  @override
  String get selfPraisePrompt4 => 'Gurur duyduğum şey...';

  @override
  String get selfPraisePrompt5 => 'Beni benzersiz kılan...';

  @override
  String get supportMapScreenTitle => 'Destek çevrem';

  @override
  String get supportMapSubtitle => 'Seni kim destekliyor?';

  @override
  String get supportMapHint => 'Yalnız olmadığını hatırla';

  @override
  String get supportMapNameLabel => 'İsim';

  @override
  String get supportMapRelationLabel => 'İlişki';

  @override
  String get supportMapRelationHint => 'ör: Arkadaş/Aile/İş arkadaşı';

  @override
  String get supportMapAdd => 'Ekle';

  @override
  String get worryUnloadScreenTitle => 'Endişe boşaltma günü';

  @override
  String worryUnloadLoadError(String error) {
    return 'Hata: $error';
  }

  @override
  String get worryUnloadEmptyTitle => 'Aktif endişe yok';

  @override
  String get worryUnloadEmptyHint => 'Harika! Bugün hafif bir gün';

  @override
  String get worryUnloadIntro => 'Endişelerine bak ve sınıfla';

  @override
  String get worryUnloadLetGo => 'Bırakılabilir';

  @override
  String get worryUnloadTakeAction => 'Harekete geçilebilir';

  @override
  String get worryUnloadAccept => 'Şimdilik kabul';

  @override
  String get worryUnloadResultTitle => 'Sonuçlar';

  @override
  String worryUnloadSummary(String label, int count) {
    return '$label: $count';
  }

  @override
  String get worryUnloadEncouragement => 'Her sınıflama bir adım ileri.';

  @override
  String get commonSaved => 'Kaydedildi';

  @override
  String get commonSaveError => 'Kaydetme başarısız';

  @override
  String get commonLoadError => 'Yükleme başarısız';

  @override
  String get momentEditTitle => 'Anı düzenle';

  @override
  String get momentNewHappy => 'Mutlu bir an kaydet';

  @override
  String get momentNewHighlight => 'Öne çıkan bir an kaydet';

  @override
  String get momentDescHappy => 'Mutlu eden bir şey';

  @override
  String get momentDescHighlight => 'Ne oldu';

  @override
  String get momentCompanionHappy => 'Kiminle birlikte';

  @override
  String get momentCompanionHighlight => 'Ne yaptım';

  @override
  String get momentFeeling => 'Hisler';

  @override
  String get momentDate => 'Tarih (YYYY-AA-GG)';

  @override
  String get momentRating => 'Değerlendirme';

  @override
  String get momentDescRequired => 'Lütfen bir açıklama ekle';

  @override
  String momentWithCompanion(String companion) {
    return '$companion ile birlikte';
  }

  @override
  String momentDidAction(String action) {
    return 'Yaptığım: $action';
  }

  @override
  String get annualCalendarTitle => 'Yıllık takvimim';

  @override
  String annualCalendarMonthLabel(int month) {
    return '$month. ay';
  }
}
