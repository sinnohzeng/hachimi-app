// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class SId extends S {
  SId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Hachimi';

  @override
  String get homeTabToday => 'Hari Ini';

  @override
  String get homeTabCatHouse => 'CatHouse';

  @override
  String get homeTabStats => 'Statistik';

  @override
  String get homeTabProfile => 'Profil';

  @override
  String get adoptionStepDefineHabit => 'Tentukan Kebiasaan';

  @override
  String get adoptionStepAdoptCat => 'Adopsi Kucing';

  @override
  String get adoptionStepNameCat => 'Beri Nama Kucing';

  @override
  String get adoptionHabitName => 'Nama Kebiasaan';

  @override
  String get adoptionHabitNameHint => 'mis. Membaca Harian';

  @override
  String get adoptionDailyGoal => 'Target Harian';

  @override
  String get adoptionTargetHours => 'Jam Target';

  @override
  String get adoptionTargetHoursHint =>
      'Total jam untuk menyelesaikan kebiasaan ini';

  @override
  String adoptionMinutes(int count) {
    return '$count mnt';
  }

  @override
  String get adoptionRefreshCat => 'Coba lagi';

  @override
  String adoptionPersonality(String name) {
    return 'Kepribadian: $name';
  }

  @override
  String get adoptionNameYourCat => 'Beri nama kucingmu';

  @override
  String get adoptionRandomName => 'Acak';

  @override
  String get adoptionCreate => 'Buat Kebiasaan & Adopsi';

  @override
  String get adoptionNext => 'Lanjut';

  @override
  String get adoptionBack => 'Kembali';

  @override
  String get adoptionCatNameLabel => 'Nama kucing';

  @override
  String get adoptionCatNameHint => 'mis. Mochi';

  @override
  String get adoptionRandomNameTooltip => 'Nama acak';

  @override
  String get catHouseTitle => 'CatHouse';

  @override
  String get catHouseEmpty =>
      'Belum ada kucing! Buat kebiasaan untuk mengadopsi kucing pertamamu.';

  @override
  String catHouseGrowth(int minutes, int target) {
    return '$minutes / $target mnt';
  }

  @override
  String get catDetailGrowthProgress => 'Progres Pertumbuhan';

  @override
  String catDetailTotalMinutes(int minutes) {
    return '$minutes mnt fokus';
  }

  @override
  String catDetailTargetMinutes(int minutes) {
    return 'Target: $minutes mnt';
  }

  @override
  String get catDetailRename => 'Ubah Nama';

  @override
  String get catDetailAccessories => 'Aksesori';

  @override
  String get catDetailStartFocus => 'Mulai Fokus';

  @override
  String get catDetailBoundHabit => 'Kebiasaan Terkait';

  @override
  String catDetailStage(String stage) {
    return 'Tahap: $stage';
  }

  @override
  String coinBalance(int amount) {
    return '$amount koin';
  }

  @override
  String coinCheckInReward(int amount) {
    return '+$amount koin!';
  }

  @override
  String get coinCheckInTitle => 'Absen Harian';

  @override
  String get coinInsufficientBalance => 'Koin tidak cukup';

  @override
  String get shopTitle => 'Toko Aksesori';

  @override
  String shopPrice(int price) {
    return '$price koin';
  }

  @override
  String get shopPurchase => 'Beli';

  @override
  String get shopEquipped => 'Dipakai';

  @override
  String focusCompleteMinutes(int minutes) {
    return '+$minutes mnt';
  }

  @override
  String get focusCompleteStageUp => 'Naik Tahap!';

  @override
  String get focusCompleteGreatJob => 'Kerja bagus!';

  @override
  String get focusCompleteDone => 'Selesai';

  @override
  String get focusCompleteItsOkay => 'Tidak apa-apa!';

  @override
  String focusCompleteEvolved(String catName) {
    return '$catName berevolusi!';
  }

  @override
  String focusCompleteFocusedFor(int minutes) {
    return 'Kamu fokus selama $minutes menit';
  }

  @override
  String focusCompleteAbandonedMessage(String catName) {
    return '$catName berkata: \"Kita coba lagi!\"';
  }

  @override
  String get focusCompleteFocusTime => 'Waktu fokus';

  @override
  String get focusCompleteCoinsEarned => 'Koin diperoleh';

  @override
  String get focusCompleteBaseXp => 'XP dasar';

  @override
  String get focusCompleteStreakBonus => 'Bonus beruntun';

  @override
  String get focusCompleteMilestoneBonus => 'Bonus pencapaian';

  @override
  String get focusCompleteFullHouseBonus => 'Bonus full house';

  @override
  String get focusCompleteTotal => 'Total';

  @override
  String focusCompleteEvolvedTo(String stage) {
    return 'Berevolusi ke $stage!';
  }

  @override
  String get focusCompleteYourCat => 'Kucingmu';

  @override
  String get focusCompleteDiaryWriting => 'Menulis diari...';

  @override
  String get focusCompleteDiaryWritten => 'Diari sudah ditulis!';

  @override
  String get focusCompleteDiarySkipped => 'Diari dilewati';

  @override
  String get focusCompleteNotifTitle => 'Misi selesai!';

  @override
  String focusCompleteNotifBody(String catName, int xp, int minutes) {
    return '$catName mendapat +$xp XP dari $minutes mnt fokus';
  }

  @override
  String get stageKitten => 'Anak Kucing';

  @override
  String get stageAdolescent => 'Remaja';

  @override
  String get stageAdult => 'Dewasa';

  @override
  String get stageSenior => 'Senior';

  @override
  String get migrationTitle => 'Pembaruan Data Diperlukan';

  @override
  String get migrationMessage =>
      'Hachimi telah diperbarui dengan sistem kucing piksel baru! Data kucing lama kamu tidak lagi kompatibel. Silakan reset untuk memulai pengalaman baru.';

  @override
  String get migrationResetButton => 'Reset & Mulai Baru';

  @override
  String get sessionResumeTitle => 'Lanjutkan sesi?';

  @override
  String sessionResumeMessage(String habitName, String elapsed) {
    return 'Kamu punya sesi fokus aktif ($habitName, $elapsed). Lanjutkan?';
  }

  @override
  String get sessionResumeButton => 'Lanjutkan';

  @override
  String get sessionDiscard => 'Buang';

  @override
  String get todaySummaryMinutes => 'Hari Ini';

  @override
  String get todaySummaryTotal => 'Total';

  @override
  String get todaySummaryCats => 'Kucing';

  @override
  String get todayYourQuests => 'Misi Kamu';

  @override
  String get todayNoQuests => 'Belum ada misi';

  @override
  String get todayNoQuestsHint =>
      'Ketuk + untuk memulai misi dan mengadopsi kucing!';

  @override
  String get todayFocus => 'Fokus';

  @override
  String get todayDeleteQuestTitle => 'Hapus misi?';

  @override
  String todayDeleteQuestMessage(String name) {
    return 'Yakin ingin menghapus \"$name\"? Kucing akan lulus ke albummu.';
  }

  @override
  String todayQuestCompleted(String name) {
    return '$name selesai';
  }

  @override
  String get todayFailedToLoad => 'Gagal memuat misi';

  @override
  String todayMinToday(int count) {
    return '$count mnt hari ini';
  }

  @override
  String todayGoalMinPerDay(int count) {
    return 'Target: $count mnt/hari';
  }

  @override
  String get todayFeaturedCat => 'Kucing Pilihan';

  @override
  String get todayAddHabit => 'Tambah Kebiasaan';

  @override
  String get todayNoHabits => 'Buat kebiasaan pertamamu untuk memulai!';

  @override
  String get todayNewQuest => 'Misi baru';

  @override
  String get todayStartFocus => 'Mulai fokus';

  @override
  String get timerStart => 'Mulai';

  @override
  String get timerPause => 'Jeda';

  @override
  String get timerResume => 'Lanjut';

  @override
  String get timerDone => 'Selesai';

  @override
  String get timerGiveUp => 'Menyerah';

  @override
  String get timerRemaining => 'tersisa';

  @override
  String get timerElapsed => 'berlalu';

  @override
  String get timerPaused => 'DIJEDA';

  @override
  String get timerQuestNotFound => 'Misi tidak ditemukan';

  @override
  String get timerNotificationBanner =>
      'Aktifkan notifikasi untuk melihat progres timer saat aplikasi di latar belakang';

  @override
  String get timerNotificationDismiss => 'Tutup';

  @override
  String get timerNotificationEnable => 'Aktifkan';

  @override
  String timerGraceBack(int seconds) {
    return 'Kembali (${seconds}d)';
  }

  @override
  String get giveUpTitle => 'Menyerah?';

  @override
  String get giveUpMessage =>
      'Jika kamu sudah fokus setidaknya 5 menit, waktu tersebut tetap dihitung untuk pertumbuhan kucingmu. Kucingmu pasti mengerti!';

  @override
  String get giveUpKeepGoing => 'Lanjutkan';

  @override
  String get giveUpConfirm => 'Menyerah';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsGeneral => 'Umum';

  @override
  String get settingsAppearance => 'Tampilan';

  @override
  String get settingsNotifications => 'Notifikasi';

  @override
  String get settingsNotificationFocusReminders => 'Pengingat Fokus';

  @override
  String get settingsNotificationSubtitle =>
      'Terima pengingat harian agar tetap konsisten';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsLanguageSystem => 'Bawaan sistem';

  @override
  String get settingsLanguageEnglish => 'Inggris';

  @override
  String get settingsLanguageChinese => '中文';

  @override
  String get settingsThemeMode => 'Mode Tema';

  @override
  String get settingsThemeModeSystem => 'Sistem';

  @override
  String get settingsThemeModeLight => 'Terang';

  @override
  String get settingsThemeModeDark => 'Gelap';

  @override
  String get settingsThemeColor => 'Warna Tema';

  @override
  String get settingsThemeColorDynamic => 'Dinamis';

  @override
  String get settingsThemeColorDynamicSubtitle => 'Gunakan warna wallpaper';

  @override
  String get settingsAbout => 'Tentang';

  @override
  String get settingsVersion => 'Versi';

  @override
  String get settingsLicenses => 'Lisensi';

  @override
  String get settingsAccount => 'Akun';

  @override
  String get logoutTitle => 'Keluar?';

  @override
  String get logoutMessage => 'Yakin ingin keluar?';

  @override
  String get loggingOut => 'Sedang keluar...';

  @override
  String get deleteAccountTitle => 'Hapus akun?';

  @override
  String get deleteAccountMessage =>
      'Ini akan menghapus akun dan semua datamu secara permanen. Tindakan ini tidak bisa dibatalkan.';

  @override
  String get deleteAccountWarning => 'Tindakan ini tidak bisa dibatalkan';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileYourJourney => 'Perjalananmu';

  @override
  String get profileTotalFocus => 'Total Fokus';

  @override
  String get profileTotalCats => 'Total Kucing';

  @override
  String get profileTotalQuests => 'Misi';

  @override
  String get profileEditName => 'Ubah nama';

  @override
  String get profileDisplayName => 'Nama tampilan';

  @override
  String get profileChooseAvatar => 'Pilih avatar';

  @override
  String get profileSaved => 'Profil disimpan';

  @override
  String get profileSettings => 'Pengaturan';

  @override
  String get habitDetailStreak => 'Beruntun';

  @override
  String get habitDetailBestStreak => 'Terbaik';

  @override
  String get habitDetailTotalMinutes => 'Total';

  @override
  String get commonCancel => 'Batal';

  @override
  String get commonConfirm => 'Konfirmasi';

  @override
  String get commonSave => 'Simpan';

  @override
  String get commonDelete => 'Hapus';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonDone => 'Selesai';

  @override
  String get commonDismiss => 'Tutup';

  @override
  String get commonEnable => 'Aktifkan';

  @override
  String get commonLoading => 'Memuat...';

  @override
  String get commonError => 'Terjadi kesalahan';

  @override
  String get commonRetry => 'Coba Lagi';

  @override
  String get commonResume => 'Lanjut';

  @override
  String get commonPause => 'Jeda';

  @override
  String get commonLogOut => 'Keluar';

  @override
  String get commonDeleteAccount => 'Hapus Akun';

  @override
  String get commonYes => 'Ya';

  @override
  String chatDailyRemaining(int count) {
    return '$count pesan tersisa hari ini';
  }

  @override
  String get chatDailyLimitReached => 'Batas pesan harian tercapai';

  @override
  String get aiTemporarilyUnavailable => 'Fitur AI sementara tidak tersedia';

  @override
  String get catDetailNotFound => 'Kucing tidak ditemukan';

  @override
  String get catDetailLoadError => 'Gagal memuat data kucing';

  @override
  String get catDetailChatTooltip => 'Obrolan';

  @override
  String get catDetailRenameTooltip => 'Ubah Nama';

  @override
  String get catDetailGrowthTitle => 'Progres Pertumbuhan';

  @override
  String catDetailTarget(int hours) {
    return 'Target: ${hours}j';
  }

  @override
  String get catDetailRenameTitle => 'Ubah Nama Kucing';

  @override
  String get catDetailNewName => 'Nama baru';

  @override
  String get catDetailRenamed => 'Kucing berhasil diubah namanya!';

  @override
  String get catDetailQuestBadge => 'Misi';

  @override
  String get catDetailEditQuest => 'Edit misi';

  @override
  String get catDetailDailyGoal => 'Target harian';

  @override
  String get catDetailTodaysFocus => 'Fokus hari ini';

  @override
  String get catDetailTotalFocus => 'Total fokus';

  @override
  String get catDetailTargetLabel => 'Target';

  @override
  String get catDetailCompletion => 'Penyelesaian';

  @override
  String get catDetailCurrentStreak => 'Beruntun saat ini';

  @override
  String get catDetailBestStreakLabel => 'Beruntun terbaik';

  @override
  String get catDetailAvgDaily => 'Rata-rata harian';

  @override
  String get catDetailDaysActive => 'Hari aktif';

  @override
  String get catDetailCheckInDays => 'Hari absen';

  @override
  String get catDetailEditQuestTitle => 'Edit Misi';

  @override
  String get catDetailQuestName => 'Nama misi';

  @override
  String get catDetailDailyGoalMinutes => 'Target harian (menit)';

  @override
  String get catDetailTargetTotalHours => 'Target total (jam)';

  @override
  String get catDetailQuestUpdated => 'Misi diperbarui!';

  @override
  String get catDetailTargetCompletedHint =>
      'Target sudah tercapai — sekarang dalam mode tanpa batas';

  @override
  String get catDetailDailyReminder => 'Pengingat Harian';

  @override
  String catDetailEveryDay(String time) {
    return '$time setiap hari';
  }

  @override
  String get catDetailNoReminder => 'Tidak ada pengingat';

  @override
  String get catDetailChange => 'Ubah';

  @override
  String get catDetailRemoveReminder => 'Hapus pengingat';

  @override
  String get catDetailSet => 'Atur';

  @override
  String catDetailReminderSet(String time) {
    return 'Pengingat diatur untuk $time';
  }

  @override
  String get catDetailReminderRemoved => 'Pengingat dihapus';

  @override
  String get catDetailDiaryTitle => 'Diari Hachimi';

  @override
  String get catDetailDiaryLoading => 'Memuat...';

  @override
  String get catDetailDiaryError => 'Tidak dapat memuat diari';

  @override
  String get catDetailDiaryEmpty =>
      'Belum ada diari hari ini. Selesaikan sesi fokus!';

  @override
  String catDetailChatWith(String name) {
    return 'Obrolan dengan $name';
  }

  @override
  String get catDetailChatSubtitle =>
      'Dia akan membalas sesuai kepribadiannya!';

  @override
  String get catDetailActivity => 'Aktivitas';

  @override
  String get catDetailActivityError => 'Gagal memuat data aktivitas';

  @override
  String get catDetailAccessoriesTitle => 'Aksesori';

  @override
  String get catDetailEquipped => 'Dipakai: ';

  @override
  String get catDetailNone => 'Tidak ada';

  @override
  String get catDetailUnequip => 'Lepas';

  @override
  String catDetailFromInventory(int count) {
    return 'Dari Inventaris ($count)';
  }

  @override
  String get catDetailNoAccessories => 'Belum ada aksesori. Kunjungi toko!';

  @override
  String catDetailEquippedItem(String name) {
    return '$name dipasang';
  }

  @override
  String get catDetailUnequipped => 'Dilepas';

  @override
  String catDetailAbout(String name) {
    return 'Tentang $name';
  }

  @override
  String get catDetailAppearanceDetails => 'Detail penampilan';

  @override
  String get catDetailStatus => 'Status';

  @override
  String get catDetailAdopted => 'Diadopsi';

  @override
  String get catDetailFurPattern => 'Pola bulu';

  @override
  String get catDetailFurColor => 'Warna bulu';

  @override
  String get catDetailFurLength => 'Panjang bulu';

  @override
  String get catDetailEyes => 'Mata';

  @override
  String get catDetailWhitePatches => 'Bercak putih';

  @override
  String get catDetailPatchesTint => 'Warna bercak';

  @override
  String get catDetailTint => 'Warna';

  @override
  String get catDetailPoints => 'Titik warna';

  @override
  String get catDetailVitiligo => 'Vitiligo';

  @override
  String get catDetailTortoiseshell => 'Kura-kura';

  @override
  String get catDetailTortiePattern => 'Pola tortie';

  @override
  String get catDetailTortieColor => 'Warna tortie';

  @override
  String get catDetailSkin => 'Kulit';

  @override
  String get offlineMessage =>
      'Kamu sedang offline — perubahan akan disinkronkan saat terhubung kembali';

  @override
  String get offlineModeLabel => 'Mode offline';

  @override
  String habitTodayMinutes(int count) {
    return 'Hari ini: $count mnt';
  }

  @override
  String get habitDeleteTooltip => 'Hapus kebiasaan';

  @override
  String get heatmapActiveDays => 'Hari aktif';

  @override
  String get heatmapTotal => 'Total';

  @override
  String get heatmapRate => 'Rasio';

  @override
  String get heatmapLess => 'Sedikit';

  @override
  String get heatmapMore => 'Banyak';

  @override
  String get accessoryEquipped => 'Dipakai';

  @override
  String get accessoryOwned => 'Dimiliki';

  @override
  String get pickerMinUnit => 'mnt';

  @override
  String get settingsBackgroundAnimation => 'Animasi latar belakang';

  @override
  String get settingsBackgroundAnimationSubtitle =>
      'Gradien mesh dan partikel melayang';

  @override
  String get settingsUiStyle => 'Gaya UI';

  @override
  String get settingsUiStyleMaterial => 'Material 3';

  @override
  String get settingsUiStyleRetroPixel => 'Retro Piksel';

  @override
  String get settingsUiStyleMaterialSubtitle =>
      'Desain Material modern dan bulat';

  @override
  String get settingsUiStyleRetroPixelSubtitle =>
      'Estetika pixel art yang hangat';

  @override
  String get personalityLazy => 'Pemalas';

  @override
  String get personalityCurious => 'Penasaran';

  @override
  String get personalityPlayful => 'Suka Bermain';

  @override
  String get personalityShy => 'Pemalu';

  @override
  String get personalityBrave => 'Pemberani';

  @override
  String get personalityClingy => 'Manja';

  @override
  String get personalityFlavorLazy =>
      'Akan tidur 23 jam sehari. Jam sisanya? Juga tidur.';

  @override
  String get personalityFlavorCurious =>
      'Sudah mengendus-endus segala sesuatu!';

  @override
  String get personalityFlavorPlayful =>
      'Tidak bisa berhenti mengejar kupu-kupu!';

  @override
  String get personalityFlavorShy =>
      'Butuh 3 menit untuk mengintip dari dalam kotak...';

  @override
  String get personalityFlavorBrave =>
      'Lompat keluar dari kotak sebelum dibuka!';

  @override
  String get personalityFlavorClingy =>
      'Langsung mendengkur dan tidak mau lepas.';

  @override
  String get moodHappy => 'Senang';

  @override
  String get moodNeutral => 'Netral';

  @override
  String get moodLonely => 'Kesepian';

  @override
  String get moodMissing => 'Merindukanmu';

  @override
  String get moodMsgLazyHappy => 'Nya~! Saatnya tidur siang yang layak...';

  @override
  String get moodMsgCuriousHappy => 'Hari ini kita jelajahi apa?';

  @override
  String get moodMsgPlayfulHappy => 'Nya~! Siap bekerja!';

  @override
  String get moodMsgShyHappy => '...A-aku senang kamu di sini.';

  @override
  String get moodMsgBraveHappy => 'Ayo taklukkan hari ini bersama!';

  @override
  String get moodMsgClingyHappy => 'Hore! Kamu kembali! Jangan pergi lagi!';

  @override
  String get moodMsgLazyNeutral => '*menguap* Oh, hai...';

  @override
  String get moodMsgCuriousNeutral => 'Hmm, itu apa di sana?';

  @override
  String get moodMsgPlayfulNeutral => 'Mau main? Mungkin nanti...';

  @override
  String get moodMsgShyNeutral => '*mengintip perlahan*';

  @override
  String get moodMsgBraveNeutral => 'Berjaga, seperti biasa.';

  @override
  String get moodMsgClingyNeutral => 'Aku sudah menunggumu...';

  @override
  String get moodMsgLazyLonely => 'Tidur pun terasa sepi...';

  @override
  String get moodMsgCuriousLonely => 'Kapan ya kamu kembali...';

  @override
  String get moodMsgPlayfulLonely => 'Mainan tidak seru tanpamu...';

  @override
  String get moodMsgShyLonely => '*meringkuk diam-diam*';

  @override
  String get moodMsgBraveLonely => 'Aku akan terus menunggu. Aku pemberani.';

  @override
  String get moodMsgClingyLonely => 'Kamu ke mana... 🥺';

  @override
  String get moodMsgLazyMissing => '*membuka satu mata dengan harap*';

  @override
  String get moodMsgCuriousMissing => 'Ada sesuatu yang terjadi...?';

  @override
  String get moodMsgPlayfulMissing => 'Aku simpan mainan favoritmu...';

  @override
  String get moodMsgShyMissing => '*bersembunyi, tapi mengawasi pintu*';

  @override
  String get moodMsgBraveMissing => 'Aku tahu kamu akan kembali. Aku percaya.';

  @override
  String get moodMsgClingyMissing =>
      'Aku sangat merindukanmu... tolong kembali.';

  @override
  String get peltTypeTabby => 'Garis tabby klasik';

  @override
  String get peltTypeTicked => 'Pola agouti ticked';

  @override
  String get peltTypeMackerel => 'Tabby mackerel';

  @override
  String get peltTypeClassic => 'Pola pusaran klasik';

  @override
  String get peltTypeSokoke => 'Pola marmer sokoke';

  @override
  String get peltTypeAgouti => 'Agouti ticked';

  @override
  String get peltTypeSpeckled => 'Bulu berbintik';

  @override
  String get peltTypeRosette => 'Bintik rosette';

  @override
  String get peltTypeSingleColour => 'Warna solid';

  @override
  String get peltTypeTwoColour => 'Dua warna';

  @override
  String get peltTypeSmoke => 'Bayangan smoke';

  @override
  String get peltTypeSinglestripe => 'Garis tunggal';

  @override
  String get peltTypeBengal => 'Pola bengal';

  @override
  String get peltTypeMarbled => 'Pola marmer';

  @override
  String get peltTypeMasked => 'Wajah bertopeng';

  @override
  String get peltColorWhite => 'Putih';

  @override
  String get peltColorPaleGrey => 'Abu-abu pucat';

  @override
  String get peltColorSilver => 'Perak';

  @override
  String get peltColorGrey => 'Abu-abu';

  @override
  String get peltColorDarkGrey => 'Abu-abu gelap';

  @override
  String get peltColorGhost => 'Abu-abu hantu';

  @override
  String get peltColorBlack => 'Hitam';

  @override
  String get peltColorCream => 'Krem';

  @override
  String get peltColorPaleGinger => 'Jahe pucat';

  @override
  String get peltColorGolden => 'Emas';

  @override
  String get peltColorGinger => 'Jahe';

  @override
  String get peltColorDarkGinger => 'Jahe gelap';

  @override
  String get peltColorSienna => 'Sienna';

  @override
  String get peltColorLightBrown => 'Cokelat muda';

  @override
  String get peltColorLilac => 'Lilac';

  @override
  String get peltColorBrown => 'Cokelat';

  @override
  String get peltColorGoldenBrown => 'Cokelat emas';

  @override
  String get peltColorDarkBrown => 'Cokelat gelap';

  @override
  String get peltColorChocolate => 'Cokelat tua';

  @override
  String get eyeColorYellow => 'Kuning';

  @override
  String get eyeColorAmber => 'Amber';

  @override
  String get eyeColorHazel => 'Hazel';

  @override
  String get eyeColorPaleGreen => 'Hijau pucat';

  @override
  String get eyeColorGreen => 'Hijau';

  @override
  String get eyeColorBlue => 'Biru';

  @override
  String get eyeColorDarkBlue => 'Biru gelap';

  @override
  String get eyeColorBlueYellow => 'Biru-kuning';

  @override
  String get eyeColorBlueGreen => 'Biru-hijau';

  @override
  String get eyeColorGrey => 'Abu-abu';

  @override
  String get eyeColorCyan => 'Cyan';

  @override
  String get eyeColorEmerald => 'Zamrud';

  @override
  String get eyeColorHeatherBlue => 'Biru heather';

  @override
  String get eyeColorSunlitIce => 'Es bercahaya';

  @override
  String get eyeColorCopper => 'Tembaga';

  @override
  String get eyeColorSage => 'Sage';

  @override
  String get eyeColorCobalt => 'Kobalt';

  @override
  String get eyeColorPaleBlue => 'Biru pucat';

  @override
  String get eyeColorBronze => 'Perunggu';

  @override
  String get eyeColorSilver => 'Perak';

  @override
  String get eyeColorPaleYellow => 'Kuning pucat';

  @override
  String eyeDescNormal(String color) {
    return 'Mata $color';
  }

  @override
  String eyeDescHeterochromia(String primary, String secondary) {
    return 'Heterokromia ($primary / $secondary)';
  }

  @override
  String get skinColorPink => 'Merah muda';

  @override
  String get skinColorRed => 'Merah';

  @override
  String get skinColorBlack => 'Hitam';

  @override
  String get skinColorDark => 'Gelap';

  @override
  String get skinColorDarkBrown => 'Cokelat gelap';

  @override
  String get skinColorBrown => 'Cokelat';

  @override
  String get skinColorLightBrown => 'Cokelat muda';

  @override
  String get skinColorDarkGrey => 'Abu-abu gelap';

  @override
  String get skinColorGrey => 'Abu-abu';

  @override
  String get skinColorDarkSalmon => 'Salmon gelap';

  @override
  String get skinColorSalmon => 'Salmon';

  @override
  String get skinColorPeach => 'Peach';

  @override
  String get furLengthLonghair => 'Bulu panjang';

  @override
  String get furLengthShorthair => 'Bulu pendek';

  @override
  String get whiteTintOffwhite => 'Warna off-white';

  @override
  String get whiteTintCream => 'Warna krem';

  @override
  String get whiteTintDarkCream => 'Warna krem gelap';

  @override
  String get whiteTintGray => 'Warna abu-abu';

  @override
  String get whiteTintPink => 'Warna merah muda';

  @override
  String notifReminderTitle(String catName) {
    return '$catName merindukanmu!';
  }

  @override
  String notifReminderBody(String habitName) {
    return 'Waktunya $habitName — kucingmu menunggu!';
  }

  @override
  String notifStreakTitle(String catName) {
    return '$catName khawatir!';
  }

  @override
  String notifStreakBody(int streak) {
    return 'Rekor beruntun $streak harimu terancam. Sesi singkat bisa menyelamatkannya!';
  }

  @override
  String notifEvolutionTitle(String catName) {
    return '$catName berevolusi!';
  }

  @override
  String notifEvolutionBody(String catName, String stageName) {
    return '$catName tumbuh menjadi $stageName! Terus pertahankan!';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '${hours}j ${minutes}m';
  }

  @override
  String diaryScreenTitle(String name) {
    return 'Diari $name';
  }

  @override
  String get diaryFailedToLoad => 'Gagal memuat diari';

  @override
  String get diaryEmptyTitle => 'Belum ada catatan diari';

  @override
  String get diaryEmptyHint =>
      'Selesaikan sesi fokus dan kucingmu akan menulis catatan diari pertamanya!';

  @override
  String get focusSetupCountdown => 'Hitung Mundur';

  @override
  String get focusSetupStopwatch => 'Stopwatch';

  @override
  String get focusSetupStartFocus => 'Mulai Fokus';

  @override
  String get focusSetupQuestNotFound => 'Misi tidak ditemukan';

  @override
  String get checkInButtonLogMore => 'Catat lebih banyak waktu';

  @override
  String get checkInButtonStart => 'Mulai timer';

  @override
  String get adoptionTitleFirst => 'Adopsi Kucing Pertamamu!';

  @override
  String get adoptionTitleNew => 'Misi Baru';

  @override
  String get adoptionStepDefineQuest => 'Tentukan Misi';

  @override
  String get adoptionStepAdoptCat2 => 'Adopsi Kucing';

  @override
  String get adoptionStepNameCat2 => 'Beri Nama Kucing';

  @override
  String get adoptionAdopt => 'Adopsi!';

  @override
  String get adoptionQuestPrompt => 'Misi apa yang ingin kamu mulai?';

  @override
  String get adoptionKittenHint =>
      'Anak kucing akan ditugaskan untuk membantumu tetap konsisten!';

  @override
  String get adoptionQuestName => 'Nama misi';

  @override
  String get adoptionQuestHint => 'mis. Persiapan pertanyaan wawancara';

  @override
  String get adoptionTotalTarget => 'Target total (jam)';

  @override
  String get adoptionGrowthHint =>
      'Kucingmu tumbuh saat kamu mengumpulkan waktu fokus';

  @override
  String get adoptionCustom => 'Kustom';

  @override
  String get adoptionDailyGoalLabel => 'Target fokus harian (mnt)';

  @override
  String get adoptionReminderLabel => 'Pengingat harian (opsional)';

  @override
  String get adoptionReminderNone => 'Tidak ada';

  @override
  String get adoptionCustomGoalTitle => 'Target harian kustom';

  @override
  String get adoptionMinutesPerDay => 'Menit per hari';

  @override
  String get adoptionMinutesHint => '5 - 180';

  @override
  String get adoptionValidMinutes => 'Masukkan nilai antara 5 dan 180';

  @override
  String get adoptionCustomTargetTitle => 'Target jam kustom';

  @override
  String get adoptionTotalHours => 'Total jam';

  @override
  String get adoptionHoursHint => '10 - 2000';

  @override
  String get adoptionValidHours => 'Masukkan nilai antara 10 dan 2000';

  @override
  String get adoptionSet => 'Atur';

  @override
  String get adoptionChooseKitten => 'Pilih anak kucingmu!';

  @override
  String adoptionCompanionFor(String quest) {
    return 'Temanmu untuk \"$quest\"';
  }

  @override
  String get adoptionRerollAll => 'Acak Semua';

  @override
  String get adoptionNameYourCat2 => 'Beri nama kucingmu';

  @override
  String get adoptionCatName => 'Nama kucing';

  @override
  String get adoptionCatHint => 'mis. Mochi';

  @override
  String get adoptionRandomTooltip => 'Nama acak';

  @override
  String adoptionGrowthTarget(String quest, int hours) {
    return 'Kucingmu akan tumbuh saat kamu fokus pada \"$quest\"! Target: ${hours}j total.';
  }

  @override
  String get adoptionValidQuestName => 'Masukkan nama misi';

  @override
  String get adoptionValidCatName => 'Beri nama kucingmu';

  @override
  String adoptionError(String message) {
    return 'Error: $message';
  }

  @override
  String get adoptionBasicInfo => 'Info dasar';

  @override
  String get adoptionGoals => 'Target';

  @override
  String get adoptionUnlimitedMode => 'Mode tanpa batas';

  @override
  String get adoptionUnlimitedDesc => 'Tanpa batas atas, terus mengumpulkan';

  @override
  String get adoptionMilestoneMode => 'Mode pencapaian';

  @override
  String get adoptionMilestoneDesc => 'Tetapkan target untuk dicapai';

  @override
  String get adoptionDeadlineLabel => 'Tenggat waktu';

  @override
  String get adoptionDeadlineNone => 'Belum diatur';

  @override
  String get adoptionReminderSection => 'Pengingat';

  @override
  String get adoptionMotivationLabel => 'Catatan';

  @override
  String get adoptionMotivationHint => 'Tulis catatan...';

  @override
  String get adoptionMotivationSwap => 'Isi acak';

  @override
  String get loginAppName => 'Hachimi';

  @override
  String get loginTagline => 'Pelihara kucing. Selesaikan misi.';

  @override
  String get loginContinueGoogle => 'Lanjutkan dengan Google';

  @override
  String get loginContinueEmail => 'Lanjutkan dengan Email';

  @override
  String get loginAlreadyHaveAccount => 'Sudah punya akun? ';

  @override
  String get loginLogIn => 'Masuk';

  @override
  String get loginWelcomeBack => 'Selamat datang kembali!';

  @override
  String get loginCreateAccount => 'Buat akun kamu';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Kata sandi';

  @override
  String get loginConfirmPassword => 'Konfirmasi Kata Sandi';

  @override
  String get loginValidEmail => 'Masukkan email kamu';

  @override
  String get loginValidEmailFormat => 'Masukkan email yang valid';

  @override
  String get loginValidPassword => 'Masukkan kata sandi kamu';

  @override
  String get loginValidPasswordLength => 'Kata sandi minimal 6 karakter';

  @override
  String get loginValidPasswordMatch => 'Kata sandi tidak cocok';

  @override
  String get loginCreateAccountButton => 'Buat Akun';

  @override
  String get loginNoAccount => 'Belum punya akun? ';

  @override
  String get loginRegister => 'Daftar';

  @override
  String get checkInTitle => 'Absen Bulanan';

  @override
  String get checkInDays => 'Hari';

  @override
  String get checkInCoinsEarned => 'Koin diperoleh';

  @override
  String get checkInAllMilestones => 'Semua pencapaian sudah diklaim!';

  @override
  String checkInMilestoneProgress(int remaining, int bonus) {
    return '$remaining hari lagi → +$bonus koin';
  }

  @override
  String get checkInMilestones => 'Pencapaian';

  @override
  String get checkInFullMonth => 'Sebulan penuh';

  @override
  String get checkInRewardSchedule => 'Jadwal Hadiah';

  @override
  String get checkInWeekday => 'Hari kerja (Sen–Jum)';

  @override
  String checkInWeekdayReward(int coins) {
    return '$coins koin/hari';
  }

  @override
  String get checkInWeekend => 'Akhir pekan (Sab–Min)';

  @override
  String checkInNDays(int count) {
    return '$count hari';
  }

  @override
  String get onboardTitle1 => 'Temui Pendampingmu';

  @override
  String get onboardSubtitle1 => 'Setiap misi dimulai dengan anak kucing';

  @override
  String get onboardBody1 =>
      'Tetapkan tujuan dan adopsi anak kucing.\nFokus padanya, dan saksikan kucingmu tumbuh!';

  @override
  String get onboardTitle2 => 'Fokus, Tumbuh, Evolusi';

  @override
  String get onboardSubtitle2 => '4 tahap pertumbuhan';

  @override
  String get onboardBody2 =>
      'Setiap menit fokusmu membantu kucing berevolusi\ndari anak kucing kecil menjadi senior yang megah!';

  @override
  String get onboardTitle3 => 'Bangun Rumah Kucingmu';

  @override
  String get onboardSubtitle3 => 'Kumpulkan kucing unik';

  @override
  String get onboardBody3 =>
      'Setiap misi membawa kucing baru dengan tampilan unik.\nTemukan semuanya dan bangun koleksi impianmu!';

  @override
  String get onboardSkip => 'Lewati';

  @override
  String get onboardLetsGo => 'Ayo Mulai!';

  @override
  String get onboardNext => 'Lanjut';

  @override
  String get catRoomTitle => 'CatHouse';

  @override
  String get catRoomInventory => 'Inventaris';

  @override
  String get catRoomShop => 'Toko Aksesori';

  @override
  String get catRoomLoadError => 'Gagal memuat kucing';

  @override
  String get catRoomEmptyTitle => 'CatHouse-mu kosong';

  @override
  String get catRoomEmptySubtitle =>
      'Mulai misi untuk mengadopsi kucing pertamamu!';

  @override
  String get catRoomEditQuest => 'Edit Misi';

  @override
  String get catRoomRenameCat => 'Ubah Nama Kucing';

  @override
  String get catRoomArchiveCat => 'Arsipkan Kucing';

  @override
  String get catRoomNewName => 'Nama baru';

  @override
  String get catRoomRename => 'Ubah Nama';

  @override
  String get catRoomArchiveTitle => 'Arsipkan kucing?';

  @override
  String catRoomArchiveMessage(String name) {
    return 'Ini akan mengarsipkan \"$name\" dan menghapus misi terkaitnya. Kucing tetap muncul di albummu.';
  }

  @override
  String get catRoomArchive => 'Arsipkan';

  @override
  String catRoomAlbumSection(int count) {
    return 'Album ($count)';
  }

  @override
  String get catRoomReactivateCat => 'Aktifkan Kembali Kucing';

  @override
  String get catRoomReactivateTitle => 'Aktifkan kembali kucing?';

  @override
  String catRoomReactivateMessage(String name) {
    return 'Ini akan mengembalikan \"$name\" dan misi terkaitnya ke CatHouse.';
  }

  @override
  String get catRoomReactivate => 'Aktifkan Kembali';

  @override
  String get catRoomArchivedLabel => 'Diarsipkan';

  @override
  String catRoomArchiveSuccess(String name) {
    return '\"$name\" diarsipkan';
  }

  @override
  String catRoomReactivateSuccess(String name) {
    return '\"$name\" diaktifkan kembali';
  }

  @override
  String get catRoomArchiveError => 'Gagal mengarsipkan kucing';

  @override
  String get catRoomReactivateError => 'Gagal mengaktifkan kembali kucing';

  @override
  String get catRoomArchiveLoadError => 'Gagal memuat kucing yang diarsipkan';

  @override
  String get catRoomRenameError => 'Gagal mengganti nama kucing';

  @override
  String get addHabitTitle => 'Misi Baru';

  @override
  String get addHabitQuestName => 'Nama misi';

  @override
  String get addHabitQuestHint => 'mis. Latihan LeetCode';

  @override
  String get addHabitValidName => 'Masukkan nama misi';

  @override
  String get addHabitTargetHours => 'Jam target';

  @override
  String get addHabitTargetHint => 'mis. 100';

  @override
  String get addHabitValidTarget => 'Masukkan jam target';

  @override
  String get addHabitValidNumber => 'Masukkan angka yang valid';

  @override
  String get addHabitCreate => 'Buat Misi';

  @override
  String get addHabitHoursSuffix => 'jam';

  @override
  String shopTabPlants(int count) {
    return 'Tanaman ($count)';
  }

  @override
  String shopTabWild(int count) {
    return 'Liar ($count)';
  }

  @override
  String shopTabCollars(int count) {
    return 'Kalung ($count)';
  }

  @override
  String get shopNoAccessories => 'Tidak ada aksesori tersedia';

  @override
  String shopBuyConfirm(String name) {
    return 'Beli $name?';
  }

  @override
  String get shopPurchaseButton => 'Beli';

  @override
  String get shopNotEnoughCoinsButton => 'Koin tidak cukup';

  @override
  String shopPurchaseSuccess(String name) {
    return 'Berhasil dibeli! $name ditambahkan ke inventaris';
  }

  @override
  String shopPurchaseFailed(int price) {
    return 'Koin tidak cukup (butuh $price)';
  }

  @override
  String get inventoryTitle => 'Inventaris';

  @override
  String inventoryInBox(int count) {
    return 'Di Kotak ($count)';
  }

  @override
  String get inventoryEmpty =>
      'Inventarismu kosong.\nKunjungi toko untuk mendapatkan aksesori!';

  @override
  String inventoryEquippedOnCats(int count) {
    return 'Dipakai di Kucing ($count)';
  }

  @override
  String get inventoryNoEquipped =>
      'Tidak ada aksesori yang dipakai di kucing mana pun.';

  @override
  String get inventoryUnequip => 'Lepas';

  @override
  String get inventoryNoActiveCats => 'Tidak ada kucing aktif';

  @override
  String inventoryEquipTo(String name) {
    return 'Pasang $name ke:';
  }

  @override
  String inventoryEquipSuccess(String name) {
    return '$name dipasang';
  }

  @override
  String inventoryUnequipSuccess(String catName) {
    return 'Dilepas dari $catName';
  }

  @override
  String get chatCatNotFound => 'Kucing tidak ditemukan';

  @override
  String chatTitle(String name) {
    return 'Obrolan dengan $name';
  }

  @override
  String get chatClearHistory => 'Hapus riwayat';

  @override
  String chatEmptyTitle(String name) {
    return 'Sapa $name!';
  }

  @override
  String get chatEmptySubtitle =>
      'Mulai percakapan dengan kucingmu. Mereka akan membalas sesuai kepribadiannya!';

  @override
  String get chatGenerating => 'Menghasilkan...';

  @override
  String get chatTypeMessage => 'Ketik pesan...';

  @override
  String get chatClearConfirmTitle => 'Hapus riwayat obrolan?';

  @override
  String get chatClearConfirmMessage =>
      'Ini akan menghapus semua pesan. Tindakan ini tidak bisa dibatalkan.';

  @override
  String get chatClearButton => 'Hapus';

  @override
  String get chatSend => 'Kirim';

  @override
  String get chatStop => 'Berhenti';

  @override
  String get chatErrorMessage => 'Failed to send message. Tap to retry.';

  @override
  String get chatRetry => 'Retry';

  @override
  String get chatErrorGeneric => 'Terjadi kesalahan. Coba lagi.';

  @override
  String diaryTitle(String name) {
    return 'Diari $name';
  }

  @override
  String get diaryLoadFailed => 'Gagal memuat diari';

  @override
  String get diaryRetry => 'Coba Lagi';

  @override
  String get diaryEmptyTitle2 => 'Belum ada catatan diari';

  @override
  String get diaryEmptySubtitle =>
      'Selesaikan sesi fokus dan kucingmu akan menulis catatan diari pertamanya!';

  @override
  String get statsTitle => 'Statistik';

  @override
  String get statsTotalHours => 'Total Jam';

  @override
  String statsTimeValue(int hours, int minutes) {
    return '${hours}j ${minutes}m';
  }

  @override
  String get statsBestStreak => 'Beruntun Terbaik';

  @override
  String statsStreakDays(int count) {
    return '$count hari';
  }

  @override
  String get statsOverallProgress => 'Progres Keseluruhan';

  @override
  String statsPercentOfGoals(String percent) {
    return '$percent% dari semua target';
  }

  @override
  String get statsPerQuestProgress => 'Progres Per Misi';

  @override
  String get statsQuestLoadError => 'Gagal memuat statistik misi';

  @override
  String get statsNoQuestData => 'Belum ada data misi';

  @override
  String get statsNoQuestHint => 'Mulai misi untuk melihat progresmu di sini!';

  @override
  String get statsLast30Days => '30 Hari Terakhir';

  @override
  String get habitDetailQuestNotFound => 'Misi tidak ditemukan';

  @override
  String get habitDetailComplete => 'selesai';

  @override
  String get habitDetailTotalTime => 'Total Waktu';

  @override
  String get habitDetailCurrentStreak => 'Beruntun Saat Ini';

  @override
  String get habitDetailTarget => 'Target';

  @override
  String habitDetailDaysUnit(int count) {
    return '$count hari';
  }

  @override
  String habitDetailHoursUnit(int count) {
    return '$count jam';
  }

  @override
  String checkInBannerSuccess(int coins) {
    return '+$coins koin! Absen harian selesai';
  }

  @override
  String checkInBannerBonus(int bonus) {
    return ' + $bonus bonus pencapaian!';
  }

  @override
  String get checkInBannerSemantics => 'Absen harian';

  @override
  String get checkInBannerLoading => 'Memuat status absen...';

  @override
  String checkInBannerPrompt(int coins) {
    return 'Absen untuk +$coins koin';
  }

  @override
  String checkInBannerSummary(int count, int total, int coins) {
    return '$count/$total hari  ·  +$coins hari ini';
  }

  @override
  String commonErrorWithDetail(String error) {
    return 'Error: $error';
  }

  @override
  String get profileFallbackUser => 'Pengguna';

  @override
  String get fallbackCatName => 'Kucing';

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
  String get notifFocusing => 'sedang fokus...';

  @override
  String get notifInProgress => 'Sesi fokus sedang berlangsung';

  @override
  String get unitMinShort => 'mnt';

  @override
  String get unitHourShort => 'j';

  @override
  String get weekdayMon => 'Sen';

  @override
  String get weekdayTue => 'Sel';

  @override
  String get weekdayWed => 'Rab';

  @override
  String get weekdayThu => 'Kam';

  @override
  String get weekdayFri => 'Jum';

  @override
  String get weekdaySat => 'Sab';

  @override
  String get weekdaySun => 'Min';

  @override
  String get statsTotalSessions => 'Sesi';

  @override
  String get statsTotalHabits => 'Kebiasaan';

  @override
  String get statsActiveDays => 'Hari aktif';

  @override
  String get statsWeeklyTrend => 'Tren mingguan';

  @override
  String get statsRecentSessions => 'Fokus terbaru';

  @override
  String get statsViewAllHistory => 'Lihat semua riwayat';

  @override
  String get historyTitle => 'Riwayat fokus';

  @override
  String get historyFilterAll => 'Semua';

  @override
  String historySessionCount(int count) {
    return '$count sesi';
  }

  @override
  String historyTotalMinutes(int minutes) {
    return '$minutes mnt';
  }

  @override
  String get historyNoSessions => 'Belum ada catatan fokus';

  @override
  String get historyNoSessionsHint =>
      'Selesaikan sesi fokus untuk melihatnya di sini';

  @override
  String get historyLoadMore => 'Muat lainnya';

  @override
  String get sessionCompleted => 'Selesai';

  @override
  String get sessionAbandoned => 'Dihentikan';

  @override
  String get sessionInterrupted => 'Terputus';

  @override
  String get sessionCountdown => 'Hitung mundur';

  @override
  String get sessionStopwatch => 'Stopwatch';

  @override
  String get historyDateGroupToday => 'Hari ini';

  @override
  String get historyDateGroupYesterday => 'Kemarin';

  @override
  String get historyLoadError => 'Gagal memuat riwayat';

  @override
  String get historySelectMonth => 'Pilih bulan';

  @override
  String get historyAllMonths => 'Semua bulan';

  @override
  String get historyAllHabits => 'Semua';

  @override
  String get homeTabAchievements => 'Pencapaian';

  @override
  String get achievementTitle => 'Pencapaian';

  @override
  String get achievementTabOverview => 'Ringkasan';

  @override
  String get achievementTabQuest => 'Misi';

  @override
  String get achievementTabStreak => 'Beruntun';

  @override
  String get achievementTabCat => 'Kucing';

  @override
  String get achievementTabPersist => 'Konsisten';

  @override
  String get achievementSummaryTitle => 'Progres Pencapaian';

  @override
  String achievementUnlockedCount(int count) {
    return '$count terbuka';
  }

  @override
  String achievementTotalCoins(int coins) {
    return '$coins koin diperoleh';
  }

  @override
  String get achievementUnlocked => 'Pencapaian terbuka!';

  @override
  String get achievementAwesome => 'Keren!';

  @override
  String get achievementIncredible => 'Luar biasa!';

  @override
  String get achievementHidden => '???';

  @override
  String get achievementHiddenDesc => 'Ini adalah pencapaian tersembunyi';

  @override
  String achievementPersistDesc(int days) {
    return 'Kumpulkan $days hari absen di misi mana pun';
  }

  @override
  String achievementTitleCount(int count) {
    return '$count gelar terbuka';
  }

  @override
  String get growthPathTitle => 'Jalur Pertumbuhan';

  @override
  String get growthPathKitten => 'Mulai perjalanan baru';

  @override
  String get growthPathAdolescent => 'Bangun fondasi awal';

  @override
  String get growthPathAdult => 'Keterampilan menguat';

  @override
  String get growthPathSenior => 'Penguasaan mendalam';

  @override
  String get growthPathTip =>
      'Riset menunjukkan bahwa 20 jam latihan terfokus cukup untuk membangun fondasi keterampilan baru — Josh Kaufman';

  @override
  String achievementCelebrationCoins(int count) {
    return '+$count koin';
  }

  @override
  String achievementCelebrationTitle(String title) {
    return 'Gelar diperoleh: $title';
  }

  @override
  String get achievementCelebrationDismiss => 'Keren!';

  @override
  String get achievementCelebrationSkipAll => 'Lewati semua';

  @override
  String achievementCelebrationCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String achievementUnlockedAt(String date) {
    return 'Terbuka pada $date';
  }

  @override
  String get achievementLocked => 'Belum terbuka';

  @override
  String achievementRewardCoins(int count) {
    return '+$count koin';
  }

  @override
  String get reminderModeDaily => 'Setiap hari';

  @override
  String get reminderModeWeekdays => 'Hari kerja';

  @override
  String get reminderModeMonday => 'Senin';

  @override
  String get reminderModeTuesday => 'Selasa';

  @override
  String get reminderModeWednesday => 'Rabu';

  @override
  String get reminderModeThursday => 'Kamis';

  @override
  String get reminderModeFriday => 'Jumat';

  @override
  String get reminderModeSaturday => 'Sabtu';

  @override
  String get reminderModeSunday => 'Minggu';

  @override
  String get reminderPickerTitle => 'Pilih waktu pengingat';

  @override
  String get reminderHourUnit => 'j';

  @override
  String get reminderMinuteUnit => 'mnt';

  @override
  String get reminderAddMore => 'Tambah pengingat';

  @override
  String get reminderMaxReached => 'Maksimal 5 pengingat';

  @override
  String get reminderConfirm => 'Konfirmasi';

  @override
  String reminderNotificationTitle(String catName) {
    return '$catName merindukanmu!';
  }

  @override
  String reminderNotificationBody(String habitName) {
    return 'Waktunya $habitName — kucingmu menunggu!';
  }

  @override
  String get deleteAccountDataWarning =>
      'Semua data berikut akan dihapus secara permanen:';

  @override
  String get deleteAccountQuests => 'Misi';

  @override
  String get deleteAccountCats => 'Kucing';

  @override
  String get deleteAccountHours => 'Jam fokus';

  @override
  String get deleteAccountIrreversible => 'Tindakan ini tidak dapat dibatalkan';

  @override
  String get deleteAccountContinue => 'Lanjutkan';

  @override
  String get deleteAccountConfirmTitle => 'Konfirmasi penghapusan';

  @override
  String get deleteAccountTypeDelete =>
      'Ketik DELETE untuk mengonfirmasi penghapusan akun:';

  @override
  String get deleteAccountAuthCancelled => 'Autentikasi dibatalkan';

  @override
  String deleteAccountAuthFailed(String error) {
    return 'Autentikasi gagal: $error';
  }

  @override
  String get deleteAccountProgress => 'Menghapus akun...';

  @override
  String get deleteAccountSuccess => 'Akun dihapus';

  @override
  String get drawerGuestLoginSubtitle => 'Sinkronkan data dan buka fitur AI';

  @override
  String get drawerGuestSignIn => 'Masuk';

  @override
  String get drawerMilestones => 'Pencapaian';

  @override
  String drawerMilestoneFocus(int hours, int minutes) {
    return 'Total fokus: ${hours}j ${minutes}m';
  }

  @override
  String drawerMilestoneCats(int count) {
    return 'Keluarga kucing: $count';
  }

  @override
  String drawerMilestoneQuests(int count) {
    return 'Misi aktif: $count';
  }

  @override
  String get drawerMySection => 'Saya';

  @override
  String get drawerSessionHistory => 'Riwayat fokus';

  @override
  String get drawerCheckInCalendar => 'Kalender absen';

  @override
  String get drawerAccountSection => 'Akun';

  @override
  String get settingsResetData => 'Reset semua data';

  @override
  String get settingsResetDataTitle => 'Reset semua data?';

  @override
  String get settingsResetDataMessage =>
      'Ini akan menghapus semua data lokal dan kembali ke layar selamat datang. Tindakan ini tidak bisa dibatalkan.';

  @override
  String get guestUpgradeTitle => 'Lindungi datamu';

  @override
  String get guestUpgradeMessage =>
      'Tautkan akun untuk mencadangkan progresmu, membuka fitur diari dan obrolan AI, serta sinkronisasi antar perangkat.';

  @override
  String get guestUpgradeLinkButton => 'Tautkan akun';

  @override
  String get guestUpgradeLater => 'Nanti saja';

  @override
  String get loginLinkTagline => 'Tautkan akun untuk melindungi datamu';

  @override
  String get aiTeaserTitle => 'Diari kucing';

  @override
  String aiTeaserPreview(String catName) {
    return 'Hari ini aku belajar lagi dengan manusiaku... $catName merasa makin pintar setiap hari~';
  }

  @override
  String aiTeaserCta(String catName) {
    return 'Tautkan akun untuk melihat apa yang ingin $catName katakan';
  }

  @override
  String get authErrorEmailInUse => 'Email ini sudah terdaftar';

  @override
  String get authErrorWrongPassword => 'Email atau kata sandi salah';

  @override
  String get authErrorUserNotFound => 'Tidak ada akun dengan email ini';

  @override
  String get authErrorTooManyRequests =>
      'Terlalu banyak percobaan. Coba lagi nanti';

  @override
  String get authErrorNetwork => 'Kesalahan jaringan. Periksa koneksimu';

  @override
  String get authErrorAdminRestricted => 'Login sementara dibatasi';

  @override
  String get authErrorWeakPassword =>
      'Kata sandi terlalu lemah. Gunakan minimal 6 karakter';

  @override
  String get authErrorGeneric => 'Terjadi kesalahan. Coba lagi';

  @override
  String get deleteAccountReauthEmail =>
      'Masukkan kata sandi untuk melanjutkan';

  @override
  String get deleteAccountReauthPasswordHint => 'Kata sandi';

  @override
  String get deleteAccountError => 'Terjadi kesalahan. Coba lagi nanti.';

  @override
  String get deleteAccountPermissionError =>
      'Error izin. Coba keluar dan masuk kembali.';

  @override
  String get deleteAccountNetworkError =>
      'Tidak ada koneksi internet. Periksa jaringanmu.';

  @override
  String get deleteAccountRetainedData =>
      'Analitik penggunaan dan laporan error tidak dapat dihapus.';

  @override
  String get deleteAccountStepCloud => 'Menghapus data cloud...';

  @override
  String get deleteAccountStepLocal => 'Menghapus data lokal...';

  @override
  String get deleteAccountStepDone => 'Selesai';

  @override
  String get deleteAccountQueued =>
      'Data lokal dihapus. Penghapusan akun cloud sedang dalam antrean dan akan selesai saat online.';

  @override
  String get deleteAccountPending =>
      'Penghapusan akun sedang ditunda. Biarkan aplikasi tetap online untuk menyelesaikan penghapusan cloud dan autentikasi.';

  @override
  String get deleteAccountAbandon => 'Mulai baru';

  @override
  String get archiveConflictTitle => 'Pilih arsip yang disimpan';

  @override
  String get archiveConflictMessage =>
      'Arsip lokal dan cloud sama-sama memiliki data. Pilih salah satu untuk disimpan:';

  @override
  String get archiveConflictLocal => 'Arsip lokal';

  @override
  String get archiveConflictCloud => 'Arsip cloud';

  @override
  String get archiveConflictKeepCloud => 'Simpan cloud';

  @override
  String get archiveConflictKeepLocal => 'Simpan lokal';

  @override
  String get loginShowPassword => 'Tampilkan kata sandi';

  @override
  String get loginHidePassword => 'Sembunyikan kata sandi';

  @override
  String get errorGeneric => 'Terjadi kesalahan. Coba lagi nanti';

  @override
  String get errorCreateHabit => 'Gagal membuat kebiasaan. Coba lagi';

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
  String get commonCopyId => 'Salin ID';

  @override
  String get adoptionClearDeadline => 'Hapus tenggat';

  @override
  String get commonIdCopied => 'ID disalin';

  @override
  String get pickerDurationLabel => 'Pemilih durasi';

  @override
  String pickerMinutesValue(int count) {
    return '$count menit';
  }

  @override
  String a11yCatImage(String name) {
    return 'Kucing $name';
  }

  @override
  String a11yCatTapToInteract(String name) {
    return '$name, ketuk untuk berinteraksi';
  }

  @override
  String a11yProgressPercent(int percent) {
    return '$percent% selesai';
  }

  @override
  String a11yStreakActiveDays(int count) {
    return '$count hari aktif';
  }

  @override
  String get a11yOfflineStatus => 'Mode offline';

  @override
  String a11yAchievementUnlocked(String name) {
    return 'Pencapaian terbuka: $name';
  }

  @override
  String get calendarCheckedIn => 'sudah absen';

  @override
  String get calendarToday => 'hari ini';

  @override
  String a11yEquipToCat(Object name) {
    return 'Pasang ke $name';
  }

  @override
  String a11yRegenerateCat(Object name) {
    return 'Buat ulang $name';
  }

  @override
  String a11yTimerDisplay(Object time) {
    return 'Timer: $time';
  }

  @override
  String a11yOnboardingPage(Object current, Object total) {
    return 'Halaman $current dari $total';
  }

  @override
  String a11yEditDisplayName(Object name) {
    return 'Edit nama tampilan: $name';
  }

  @override
  String get routeNotFound => 'Halaman tidak ditemukan';

  @override
  String get routeGoHome => 'Ke beranda';

  @override
  String get a11yError => 'Error';

  @override
  String get a11yDeadline => 'Tenggat';

  @override
  String get a11yReminder => 'Pengingat';

  @override
  String get a11yFocusMeditation => 'Meditasi fokus';

  @override
  String get a11yUnlocked => 'Terbuka';

  @override
  String get a11ySelected => 'Dipilih';

  @override
  String get a11yDynamicWallpaperColor => 'Warna wallpaper dinamis';

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
}
