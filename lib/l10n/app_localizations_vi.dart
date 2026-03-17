// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class SVi extends S {
  SVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Hachimi';

  @override
  String get homeTabToday => 'Hôm nay';

  @override
  String get homeTabCatHouse => 'CatHouse';

  @override
  String get homeTabStats => 'Thống kê';

  @override
  String get homeTabProfile => 'Hồ sơ';

  @override
  String get adoptionStepDefineHabit => 'Tạo thói quen';

  @override
  String get adoptionStepAdoptCat => 'Nhận mèo';

  @override
  String get adoptionStepNameCat => 'Đặt tên';

  @override
  String get adoptionHabitName => 'Tên thói quen';

  @override
  String get adoptionHabitNameHint => 'VD: Đọc sách mỗi ngày';

  @override
  String get adoptionDailyGoal => 'Mục tiêu hàng ngày';

  @override
  String get adoptionTargetHours => 'Số giờ mục tiêu';

  @override
  String get adoptionTargetHoursHint =>
      'Tổng số giờ để hoàn thành thói quen này';

  @override
  String adoptionMinutes(int count) {
    return '$count phút';
  }

  @override
  String get adoptionRefreshCat => 'Thử con khác';

  @override
  String adoptionPersonality(String name) {
    return 'Tính cách: $name';
  }

  @override
  String get adoptionNameYourCat => 'Đặt tên cho mèo của bạn';

  @override
  String get adoptionRandomName => 'Ngẫu nhiên';

  @override
  String get adoptionCreate => 'Tạo thói quen & Nhận mèo';

  @override
  String get adoptionNext => 'Tiếp';

  @override
  String get adoptionBack => 'Quay lại';

  @override
  String get adoptionCatNameLabel => 'Tên mèo';

  @override
  String get adoptionCatNameHint => 'VD: Mochi';

  @override
  String get adoptionRandomNameTooltip => 'Tên ngẫu nhiên';

  @override
  String get catHouseTitle => 'CatHouse';

  @override
  String get catHouseEmpty =>
      'Chưa có mèo nào! Tạo thói quen để nhận mèo đầu tiên.';

  @override
  String catHouseGrowth(int minutes, int target) {
    return '$minutes / $target phút';
  }

  @override
  String get catDetailGrowthProgress => 'Tiến trình tăng trưởng';

  @override
  String catDetailTotalMinutes(int minutes) {
    return 'Đã tập trung $minutes phút';
  }

  @override
  String catDetailTargetMinutes(int minutes) {
    return 'Mục tiêu: $minutes phút';
  }

  @override
  String get catDetailRename => 'Đổi tên';

  @override
  String get catDetailAccessories => 'Phụ kiện';

  @override
  String get catDetailStartFocus => 'Bắt đầu tập trung';

  @override
  String get catDetailBoundHabit => 'Thói quen liên kết';

  @override
  String catDetailStage(String stage) {
    return 'Giai đoạn: $stage';
  }

  @override
  String coinBalance(int amount) {
    return '$amount xu';
  }

  @override
  String coinCheckInReward(int amount) {
    return '+$amount xu!';
  }

  @override
  String get coinCheckInTitle => 'Điểm danh hàng ngày';

  @override
  String get coinInsufficientBalance => 'Không đủ xu';

  @override
  String get shopTitle => 'Cửa hàng phụ kiện';

  @override
  String shopPrice(int price) {
    return '$price xu';
  }

  @override
  String get shopPurchase => 'Mua';

  @override
  String get shopEquipped => 'Đang đeo';

  @override
  String focusCompleteMinutes(int minutes) {
    return '+$minutes phút';
  }

  @override
  String get focusCompleteStageUp => 'Lên cấp!';

  @override
  String get focusCompleteGreatJob => 'Tuyệt vời!';

  @override
  String get focusCompleteDone => 'Xong';

  @override
  String get focusCompleteItsOkay => 'Không sao!';

  @override
  String focusCompleteEvolved(String catName) {
    return '$catName đã tiến hóa!';
  }

  @override
  String focusCompleteFocusedFor(int minutes) {
    return 'Bạn đã tập trung $minutes phút';
  }

  @override
  String focusCompleteAbandonedMessage(String catName) {
    return '$catName nói: \"Mình sẽ thử lại nhé!\"';
  }

  @override
  String get focusCompleteFocusTime => 'Thời gian tập trung';

  @override
  String get focusCompleteCoinsEarned => 'Xu đã kiếm';

  @override
  String get focusCompleteBaseXp => 'XP cơ bản';

  @override
  String get focusCompleteStreakBonus => 'Thưởng chuỗi ngày';

  @override
  String get focusCompleteMilestoneBonus => 'Thưởng mốc';

  @override
  String get focusCompleteFullHouseBonus => 'Thưởng full house';

  @override
  String get focusCompleteTotal => 'Tổng';

  @override
  String focusCompleteEvolvedTo(String stage) {
    return 'Tiến hóa thành $stage!';
  }

  @override
  String get focusCompleteYourCat => 'Mèo của bạn';

  @override
  String get focusCompleteDiaryWriting => 'Đang viết nhật ký...';

  @override
  String get focusCompleteDiaryWritten => 'Đã viết nhật ký!';

  @override
  String get focusCompleteNotifTitle => 'Hoàn thành nhiệm vụ!';

  @override
  String focusCompleteNotifBody(String catName, int xp, int minutes) {
    return '$catName nhận +$xp XP từ $minutes phút tập trung';
  }

  @override
  String get stageKitten => 'Mèo con';

  @override
  String get stageAdolescent => 'Mèo thiếu niên';

  @override
  String get stageAdult => 'Mèo trưởng thành';

  @override
  String get stageSenior => 'Mèo lão làng';

  @override
  String get migrationTitle => 'Cần cập nhật dữ liệu';

  @override
  String get migrationMessage =>
      'Hachimi đã được cập nhật hệ thống mèo pixel mới! Dữ liệu mèo cũ không còn tương thích. Hãy đặt lại để bắt đầu trải nghiệm mới.';

  @override
  String get migrationResetButton => 'Đặt lại & Bắt đầu mới';

  @override
  String get sessionResumeTitle => 'Tiếp tục phiên?';

  @override
  String sessionResumeMessage(String habitName, String elapsed) {
    return 'Bạn có phiên tập trung đang dở ($habitName, $elapsed). Tiếp tục?';
  }

  @override
  String get sessionResumeButton => 'Tiếp tục';

  @override
  String get sessionDiscard => 'Bỏ qua';

  @override
  String get todaySummaryMinutes => 'Hôm nay';

  @override
  String get todaySummaryTotal => 'Tổng';

  @override
  String get todaySummaryCats => 'Mèo';

  @override
  String get todayYourQuests => 'Nhiệm vụ của bạn';

  @override
  String get todayNoQuests => 'Chưa có nhiệm vụ';

  @override
  String get todayNoQuestsHint => 'Nhấn + để bắt đầu nhiệm vụ và nhận mèo!';

  @override
  String get todayFocus => 'Tập trung';

  @override
  String get todayDeleteQuestTitle => 'Xóa nhiệm vụ?';

  @override
  String todayDeleteQuestMessage(String name) {
    return 'Bạn có chắc muốn xóa \"$name\"? Mèo sẽ được chuyển vào album.';
  }

  @override
  String todayQuestCompleted(String name) {
    return '$name đã hoàn thành';
  }

  @override
  String get todayFailedToLoad => 'Không tải được nhiệm vụ';

  @override
  String todayMinToday(int count) {
    return '$count phút hôm nay';
  }

  @override
  String todayGoalMinPerDay(int count) {
    return 'Mục tiêu: $count phút/ngày';
  }

  @override
  String get todayFeaturedCat => 'Mèo nổi bật';

  @override
  String get todayAddHabit => 'Thêm thói quen';

  @override
  String get todayNoHabits => 'Tạo thói quen đầu tiên để bắt đầu!';

  @override
  String get todayNewQuest => 'Nhiệm vụ mới';

  @override
  String get todayStartFocus => 'Bắt đầu tập trung';

  @override
  String get timerStart => 'Bắt đầu';

  @override
  String get timerPause => 'Tạm dừng';

  @override
  String get timerResume => 'Tiếp tục';

  @override
  String get timerDone => 'Xong';

  @override
  String get timerGiveUp => 'Bỏ cuộc';

  @override
  String get timerRemaining => 'còn lại';

  @override
  String get timerElapsed => 'đã trôi qua';

  @override
  String get timerPaused => 'Tạm dừng';

  @override
  String get timerQuestNotFound => 'Không tìm thấy nhiệm vụ';

  @override
  String get timerNotificationBanner =>
      'Bật thông báo để xem tiến trình bộ hẹn giờ khi ứng dụng chạy nền';

  @override
  String get timerNotificationDismiss => 'Bỏ qua';

  @override
  String get timerNotificationEnable => 'Bật';

  @override
  String timerGraceBack(int seconds) {
    return 'Quay lại (${seconds}s)';
  }

  @override
  String get giveUpTitle => 'Bỏ cuộc?';

  @override
  String get giveUpMessage =>
      'Nếu bạn đã tập trung ít nhất 5 phút, thời gian vẫn được tính vào sự phát triển của mèo. Mèo sẽ hiểu!';

  @override
  String get giveUpKeepGoing => 'Tiếp tục';

  @override
  String get giveUpConfirm => 'Bỏ cuộc';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsGeneral => 'Chung';

  @override
  String get settingsAppearance => 'Giao diện';

  @override
  String get settingsNotifications => 'Thông báo';

  @override
  String get settingsNotificationFocusReminders => 'Nhắc nhở tập trung';

  @override
  String get settingsNotificationSubtitle =>
      'Nhận nhắc nhở hàng ngày để duy trì tiến độ';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get settingsLanguageSystem => 'Mặc định hệ thống';

  @override
  String get settingsLanguageEnglish => 'Tiếng Anh';

  @override
  String get settingsLanguageChinese => '中文';

  @override
  String get settingsThemeMode => 'Chế độ giao diện';

  @override
  String get settingsThemeModeSystem => 'Hệ thống';

  @override
  String get settingsThemeModeLight => 'Sáng';

  @override
  String get settingsThemeModeDark => 'Tối';

  @override
  String get settingsThemeColor => 'Màu chủ đề';

  @override
  String get settingsThemeColorDynamic => 'Động';

  @override
  String get settingsThemeColorDynamicSubtitle => 'Dùng màu từ hình nền';

  @override
  String get settingsAbout => 'Giới thiệu';

  @override
  String get settingsVersion => 'Phiên bản';

  @override
  String get settingsLicenses => 'Giấy phép';

  @override
  String get settingsAccount => 'Tài khoản';

  @override
  String get logoutTitle => 'Đăng xuất?';

  @override
  String get logoutMessage => 'Bạn có chắc muốn đăng xuất?';

  @override
  String get loggingOut => 'Đang đăng xuất...';

  @override
  String get deleteAccountTitle => 'Xóa tài khoản?';

  @override
  String get deleteAccountMessage =>
      'Thao tác này sẽ xóa vĩnh viễn tài khoản và toàn bộ dữ liệu. Không thể hoàn tác.';

  @override
  String get deleteAccountWarning => 'Không thể hoàn tác thao tác này';

  @override
  String get profileTitle => 'Hồ sơ';

  @override
  String get profileYourJourney => 'Hành trình của bạn';

  @override
  String get profileTotalFocus => 'Tổng tập trung';

  @override
  String get profileTotalCats => 'Tổng mèo';

  @override
  String get profileTotalQuests => 'Nhiệm vụ';

  @override
  String get profileEditName => 'Đổi tên';

  @override
  String get profileDisplayName => 'Tên hiển thị';

  @override
  String get profileChooseAvatar => 'Chọn avatar';

  @override
  String get profileSaved => 'Đã lưu hồ sơ';

  @override
  String get profileSettings => 'Cài đặt';

  @override
  String get habitDetailStreak => 'Chuỗi ngày';

  @override
  String get habitDetailBestStreak => 'Tốt nhất';

  @override
  String get habitDetailTotalMinutes => 'Tổng';

  @override
  String get commonCancel => 'Hủy';

  @override
  String get commonConfirm => 'Xác nhận';

  @override
  String get commonSave => 'Lưu';

  @override
  String get commonDelete => 'Xóa';

  @override
  String get commonEdit => 'Sửa';

  @override
  String get commonDone => 'Xong';

  @override
  String get commonDismiss => 'Bỏ qua';

  @override
  String get commonEnable => 'Bật';

  @override
  String get commonLoading => 'Đang tải...';

  @override
  String get commonError => 'Đã xảy ra lỗi';

  @override
  String get commonRetry => 'Thử lại';

  @override
  String get commonResume => 'Tiếp tục';

  @override
  String get commonPause => 'Tạm dừng';

  @override
  String get commonLogOut => 'Đăng xuất';

  @override
  String get commonDeleteAccount => 'Xóa tài khoản';

  @override
  String get commonYes => 'Có';

  @override
  String chatDailyRemaining(int count) {
    return 'Còn $count tin nhắn hôm nay';
  }

  @override
  String get chatDailyLimitReached => 'Đã hết giới hạn tin nhắn hôm nay';

  @override
  String get aiTemporarilyUnavailable => 'Tính năng AI tạm thời không khả dụng';

  @override
  String get catDetailNotFound => 'Không tìm thấy mèo';

  @override
  String get catDetailChatTooltip => 'Trò chuyện';

  @override
  String get catDetailRenameTooltip => 'Đổi tên';

  @override
  String get catDetailGrowthTitle => 'Tiến trình tăng trưởng';

  @override
  String catDetailTarget(int hours) {
    return 'Mục tiêu: $hours giờ';
  }

  @override
  String get catDetailRenameTitle => 'Đổi tên mèo';

  @override
  String get catDetailNewName => 'Tên mới';

  @override
  String get catDetailRenamed => 'Đã đổi tên mèo!';

  @override
  String get catDetailQuestBadge => 'Nhiệm vụ';

  @override
  String get catDetailEditQuest => 'Sửa nhiệm vụ';

  @override
  String get catDetailDailyGoal => 'Mục tiêu hàng ngày';

  @override
  String get catDetailTodaysFocus => 'Tập trung hôm nay';

  @override
  String get catDetailTotalFocus => 'Tổng tập trung';

  @override
  String get catDetailTargetLabel => 'Mục tiêu';

  @override
  String get catDetailCompletion => 'Hoàn thành';

  @override
  String get catDetailCurrentStreak => 'Chuỗi ngày hiện tại';

  @override
  String get catDetailBestStreakLabel => 'Chuỗi ngày tốt nhất';

  @override
  String get catDetailAvgDaily => 'Trung bình mỗi ngày';

  @override
  String get catDetailDaysActive => 'Ngày hoạt động';

  @override
  String get catDetailCheckInDays => 'Ngày điểm danh';

  @override
  String get catDetailEditQuestTitle => 'Sửa nhiệm vụ';

  @override
  String get catDetailQuestName => 'Tên nhiệm vụ';

  @override
  String get catDetailDailyGoalMinutes => 'Mục tiêu hàng ngày (phút)';

  @override
  String get catDetailTargetTotalHours => 'Mục tiêu tổng (giờ)';

  @override
  String get catDetailQuestUpdated => 'Đã cập nhật nhiệm vụ!';

  @override
  String get catDetailTargetCompletedHint =>
      'Đã đạt mục tiêu — hiện ở chế độ không giới hạn';

  @override
  String get catDetailDailyReminder => 'Nhắc nhở hàng ngày';

  @override
  String catDetailEveryDay(String time) {
    return '$time mỗi ngày';
  }

  @override
  String get catDetailNoReminder => 'Chưa đặt nhắc nhở';

  @override
  String get catDetailChange => 'Thay đổi';

  @override
  String get catDetailRemoveReminder => 'Xóa nhắc nhở';

  @override
  String get catDetailSet => 'Đặt';

  @override
  String catDetailReminderSet(String time) {
    return 'Đã đặt nhắc nhở lúc $time';
  }

  @override
  String get catDetailReminderRemoved => 'Đã xóa nhắc nhở';

  @override
  String get catDetailDiaryTitle => 'Nhật ký Hachimi';

  @override
  String get catDetailDiaryLoading => 'Đang tải...';

  @override
  String get catDetailDiaryError => 'Không tải được nhật ký';

  @override
  String get catDetailDiaryEmpty =>
      'Chưa có nhật ký hôm nay. Hãy hoàn thành một phiên tập trung!';

  @override
  String catDetailChatWith(String name) {
    return 'Trò chuyện với $name';
  }

  @override
  String get catDetailChatSubtitle =>
      'Nói chuyện với mèo. Chúng sẽ trả lời theo tính cách!';

  @override
  String get catDetailActivity => 'Hoạt động';

  @override
  String get catDetailActivityError => 'Không tải được dữ liệu hoạt động';

  @override
  String get catDetailAccessoriesTitle => 'Phụ kiện';

  @override
  String get catDetailEquipped => 'Đang đeo: ';

  @override
  String get catDetailNone => 'Không có';

  @override
  String get catDetailUnequip => 'Tháo';

  @override
  String catDetailFromInventory(int count) {
    return 'Từ kho đồ ($count)';
  }

  @override
  String get catDetailNoAccessories => 'Chưa có phụ kiện. Ghé cửa hàng nhé!';

  @override
  String catDetailEquippedItem(String name) {
    return 'Đã đeo $name';
  }

  @override
  String get catDetailUnequipped => 'Đã tháo';

  @override
  String catDetailAbout(String name) {
    return 'Về $name';
  }

  @override
  String get catDetailAppearanceDetails => 'Chi tiết ngoại hình';

  @override
  String get catDetailStatus => 'Trạng thái';

  @override
  String get catDetailAdopted => 'Đã nhận nuôi';

  @override
  String get catDetailFurPattern => 'Hoa văn lông';

  @override
  String get catDetailFurColor => 'Màu lông';

  @override
  String get catDetailFurLength => 'Độ dài lông';

  @override
  String get catDetailEyes => 'Mắt';

  @override
  String get catDetailWhitePatches => 'Mảng trắng';

  @override
  String get catDetailPatchesTint => 'Sắc mảng';

  @override
  String get catDetailTint => 'Sắc';

  @override
  String get catDetailPoints => 'Điểm';

  @override
  String get catDetailVitiligo => 'Bạch biến';

  @override
  String get catDetailTortoiseshell => 'Lông đồi mồi';

  @override
  String get catDetailTortiePattern => 'Hoa văn tortie';

  @override
  String get catDetailTortieColor => 'Màu tortie';

  @override
  String get catDetailSkin => 'Da';

  @override
  String get offlineMessage =>
      'Bạn đang ngoại tuyến — thay đổi sẽ đồng bộ khi kết nối lại';

  @override
  String get offlineModeLabel => 'Chế độ ngoại tuyến';

  @override
  String habitTodayMinutes(int count) {
    return 'Hôm nay: $count phút';
  }

  @override
  String get habitDeleteTooltip => 'Xóa thói quen';

  @override
  String get heatmapActiveDays => 'Ngày hoạt động';

  @override
  String get heatmapTotal => 'Tổng';

  @override
  String get heatmapRate => 'Tỷ lệ';

  @override
  String get heatmapLess => 'Ít';

  @override
  String get heatmapMore => 'Nhiều';

  @override
  String get accessoryEquipped => 'Đang đeo';

  @override
  String get accessoryOwned => 'Đã mua';

  @override
  String get pickerMinUnit => 'phút';

  @override
  String get settingsBackgroundAnimation => 'Hình nền động';

  @override
  String get settingsBackgroundAnimationSubtitle =>
      'Gradient lưới và hạt trôi nổi';

  @override
  String get settingsUiStyle => 'Kiểu giao diện';

  @override
  String get settingsUiStyleMaterial => 'Material 3';

  @override
  String get settingsUiStyleRetroPixel => 'Retro Pixel';

  @override
  String get settingsUiStyleMaterialSubtitle =>
      'Thiết kế Material hiện đại, bo tròn';

  @override
  String get settingsUiStyleRetroPixelSubtitle => 'Phong cách pixel art ấm áp';

  @override
  String get personalityLazy => 'Lười biếng';

  @override
  String get personalityCurious => 'Tò mò';

  @override
  String get personalityPlayful => 'Tinh nghịch';

  @override
  String get personalityShy => 'Nhút nhát';

  @override
  String get personalityBrave => 'Dũng cảm';

  @override
  String get personalityClingy => 'Bám dính';

  @override
  String get personalityFlavorLazy =>
      'Sẽ ngủ 23 tiếng mỗi ngày. Giờ còn lại? Cũng ngủ nốt.';

  @override
  String get personalityFlavorCurious => 'Đã bắt đầu ngửi mọi thứ rồi!';

  @override
  String get personalityFlavorPlayful => 'Không ngừng đuổi bướm!';

  @override
  String get personalityFlavorShy => 'Mất 3 phút mới dám ló ra khỏi hộp...';

  @override
  String get personalityFlavorBrave => 'Nhảy ra khỏi hộp trước khi nó được mở!';

  @override
  String get personalityFlavorClingy =>
      'Bắt đầu kêu gừ gừ ngay và không chịu buông.';

  @override
  String get moodHappy => 'Vui vẻ';

  @override
  String get moodNeutral => 'Bình thường';

  @override
  String get moodLonely => 'Cô đơn';

  @override
  String get moodMissing => 'Nhớ bạn';

  @override
  String get moodMsgLazyHappy => 'Nya~! Đến giờ ngủ trưa xứng đáng rồi...';

  @override
  String get moodMsgCuriousHappy => 'Hôm nay mình khám phá gì nhỉ?';

  @override
  String get moodMsgPlayfulHappy => 'Nya~! Sẵn sàng làm việc!';

  @override
  String get moodMsgShyHappy => '...T-tớ vui vì bạn ở đây.';

  @override
  String get moodMsgBraveHappy => 'Cùng chinh phục ngày hôm nay nào!';

  @override
  String get moodMsgClingyHappy => 'Yay! Bạn về rồi! Đừng đi nữa nhé!';

  @override
  String get moodMsgLazyNeutral => '*ngáp* Ồ, chào...';

  @override
  String get moodMsgCuriousNeutral => 'Hmm, cái gì ở đằng kia?';

  @override
  String get moodMsgPlayfulNeutral => 'Chơi không? Để lát nữa vậy...';

  @override
  String get moodMsgShyNeutral => '*từ từ ló ra*';

  @override
  String get moodMsgBraveNeutral => 'Đứng gác như mọi khi.';

  @override
  String get moodMsgClingyNeutral => 'Tớ đợi bạn mãi...';

  @override
  String get moodMsgLazyLonely => 'Ngủ cũng buồn khi ở một mình...';

  @override
  String get moodMsgCuriousLonely => 'Không biết khi nào bạn mới quay lại...';

  @override
  String get moodMsgPlayfulLonely => 'Đồ chơi không vui nếu thiếu bạn...';

  @override
  String get moodMsgShyLonely => '*cuộn tròn im lặng*';

  @override
  String get moodMsgBraveLonely => 'Tớ sẽ tiếp tục chờ. Tớ dũng cảm mà.';

  @override
  String get moodMsgClingyLonely => 'Bạn đi đâu rồi... 🥺';

  @override
  String get moodMsgLazyMissing => '*mở một mắt đầy hy vọng*';

  @override
  String get moodMsgCuriousMissing => 'Có chuyện gì xảy ra không...?';

  @override
  String get moodMsgPlayfulMissing => 'Tớ giữ đồ chơi yêu thích của bạn rồi...';

  @override
  String get moodMsgShyMissing => '*trốn nhưng vẫn nhìn ra cửa*';

  @override
  String get moodMsgBraveMissing => 'Tớ biết bạn sẽ quay lại. Tớ tin.';

  @override
  String get moodMsgClingyMissing => 'Tớ nhớ bạn lắm... quay lại đi mà.';

  @override
  String get peltTypeTabby => 'Vằn tabby cổ điển';

  @override
  String get peltTypeTicked => 'Vằn ticked agouti';

  @override
  String get peltTypeMackerel => 'Vằn mackerel tabby';

  @override
  String get peltTypeClassic => 'Hoa văn xoáy cổ điển';

  @override
  String get peltTypeSokoke => 'Vân đá cẩm thạch sokoke';

  @override
  String get peltTypeAgouti => 'Ticked agouti';

  @override
  String get peltTypeSpeckled => 'Đốm nhỏ';

  @override
  String get peltTypeRosette => 'Đốm hoa hồng';

  @override
  String get peltTypeSingleColour => 'Một màu';

  @override
  String get peltTypeTwoColour => 'Hai màu';

  @override
  String get peltTypeSmoke => 'Khói';

  @override
  String get peltTypeSinglestripe => 'Sọc đơn';

  @override
  String get peltTypeBengal => 'Vằn Bengal';

  @override
  String get peltTypeMarbled => 'Vân đá cẩm thạch';

  @override
  String get peltTypeMasked => 'Mặt nạ';

  @override
  String get peltColorWhite => 'Trắng';

  @override
  String get peltColorPaleGrey => 'Xám nhạt';

  @override
  String get peltColorSilver => 'Bạc';

  @override
  String get peltColorGrey => 'Xám';

  @override
  String get peltColorDarkGrey => 'Xám đậm';

  @override
  String get peltColorGhost => 'Xám ma';

  @override
  String get peltColorBlack => 'Đen';

  @override
  String get peltColorCream => 'Kem';

  @override
  String get peltColorPaleGinger => 'Gừng nhạt';

  @override
  String get peltColorGolden => 'Vàng kim';

  @override
  String get peltColorGinger => 'Gừng';

  @override
  String get peltColorDarkGinger => 'Gừng đậm';

  @override
  String get peltColorSienna => 'Nâu đỏ';

  @override
  String get peltColorLightBrown => 'Nâu nhạt';

  @override
  String get peltColorLilac => 'Tử đinh hương';

  @override
  String get peltColorBrown => 'Nâu';

  @override
  String get peltColorGoldenBrown => 'Nâu vàng';

  @override
  String get peltColorDarkBrown => 'Nâu đậm';

  @override
  String get peltColorChocolate => 'Sô cô la';

  @override
  String get eyeColorYellow => 'Vàng';

  @override
  String get eyeColorAmber => 'Hổ phách';

  @override
  String get eyeColorHazel => 'Nâu hạt dẻ';

  @override
  String get eyeColorPaleGreen => 'Xanh lá nhạt';

  @override
  String get eyeColorGreen => 'Xanh lá';

  @override
  String get eyeColorBlue => 'Xanh dương';

  @override
  String get eyeColorDarkBlue => 'Xanh dương đậm';

  @override
  String get eyeColorBlueYellow => 'Xanh dương-Vàng';

  @override
  String get eyeColorBlueGreen => 'Xanh dương-Xanh lá';

  @override
  String get eyeColorGrey => 'Xám';

  @override
  String get eyeColorCyan => 'Lam';

  @override
  String get eyeColorEmerald => 'Ngọc lục bảo';

  @override
  String get eyeColorHeatherBlue => 'Xanh heather';

  @override
  String get eyeColorSunlitIce => 'Băng nắng';

  @override
  String get eyeColorCopper => 'Đồng';

  @override
  String get eyeColorSage => 'Xanh xô thơm';

  @override
  String get eyeColorCobalt => 'Xanh cobalt';

  @override
  String get eyeColorPaleBlue => 'Xanh dương nhạt';

  @override
  String get eyeColorBronze => 'Đồng thau';

  @override
  String get eyeColorSilver => 'Bạc';

  @override
  String get eyeColorPaleYellow => 'Vàng nhạt';

  @override
  String eyeDescNormal(String color) {
    return 'Mắt $color';
  }

  @override
  String eyeDescHeterochromia(String primary, String secondary) {
    return 'Dị sắc tố ($primary / $secondary)';
  }

  @override
  String get skinColorPink => 'Hồng';

  @override
  String get skinColorRed => 'Đỏ';

  @override
  String get skinColorBlack => 'Đen';

  @override
  String get skinColorDark => 'Tối';

  @override
  String get skinColorDarkBrown => 'Nâu đậm';

  @override
  String get skinColorBrown => 'Nâu';

  @override
  String get skinColorLightBrown => 'Nâu nhạt';

  @override
  String get skinColorDarkGrey => 'Xám đậm';

  @override
  String get skinColorGrey => 'Xám';

  @override
  String get skinColorDarkSalmon => 'Cá hồi đậm';

  @override
  String get skinColorSalmon => 'Cá hồi';

  @override
  String get skinColorPeach => 'Đào';

  @override
  String get furLengthLonghair => 'Lông dài';

  @override
  String get furLengthShorthair => 'Lông ngắn';

  @override
  String get whiteTintOffwhite => 'Sắc trắng ngà';

  @override
  String get whiteTintCream => 'Sắc kem';

  @override
  String get whiteTintDarkCream => 'Sắc kem đậm';

  @override
  String get whiteTintGray => 'Sắc xám';

  @override
  String get whiteTintPink => 'Sắc hồng';

  @override
  String notifReminderTitle(String catName) {
    return '$catName nhớ bạn!';
  }

  @override
  String notifReminderBody(String habitName) {
    return 'Đến giờ $habitName rồi — mèo đang đợi bạn!';
  }

  @override
  String notifStreakTitle(String catName) {
    return '$catName lo lắng!';
  }

  @override
  String notifStreakBody(int streak) {
    return 'Chuỗi $streak ngày của bạn sắp mất. Một phiên ngắn sẽ cứu được!';
  }

  @override
  String notifEvolutionTitle(String catName) {
    return '$catName đã tiến hóa!';
  }

  @override
  String notifEvolutionBody(String catName, String stageName) {
    return '$catName đã lớn thành $stageName! Tiếp tục phát huy nhé!';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '${hours}g ${minutes}p';
  }

  @override
  String diaryScreenTitle(String name) {
    return 'Nhật ký $name';
  }

  @override
  String get diaryFailedToLoad => 'Không tải được nhật ký';

  @override
  String get diaryEmptyTitle => 'Chưa có mục nhật ký';

  @override
  String get diaryEmptyHint =>
      'Hoàn thành phiên tập trung để mèo viết nhật ký đầu tiên!';

  @override
  String get focusSetupCountdown => 'Đếm ngược';

  @override
  String get focusSetupStopwatch => 'Bấm giờ';

  @override
  String get focusSetupStartFocus => 'Bắt đầu tập trung';

  @override
  String get focusSetupQuestNotFound => 'Không tìm thấy nhiệm vụ';

  @override
  String get checkInButtonLogMore => 'Ghi thêm thời gian';

  @override
  String get checkInButtonStart => 'Bắt đầu hẹn giờ';

  @override
  String get adoptionTitleFirst => 'Nhận mèo đầu tiên!';

  @override
  String get adoptionTitleNew => 'Nhiệm vụ mới';

  @override
  String get adoptionStepDefineQuest => 'Tạo nhiệm vụ';

  @override
  String get adoptionStepAdoptCat2 => 'Nhận mèo';

  @override
  String get adoptionStepNameCat2 => 'Đặt tên';

  @override
  String get adoptionAdopt => 'Nhận nuôi!';

  @override
  String get adoptionQuestPrompt => 'Bạn muốn bắt đầu nhiệm vụ gì?';

  @override
  String get adoptionKittenHint =>
      'Một chú mèo con sẽ giúp bạn duy trì tiến độ!';

  @override
  String get adoptionQuestName => 'Tên nhiệm vụ';

  @override
  String get adoptionQuestHint => 'VD: Chuẩn bị câu hỏi phỏng vấn';

  @override
  String get adoptionTotalTarget => 'Mục tiêu tổng (giờ)';

  @override
  String get adoptionGrowthHint =>
      'Mèo sẽ lớn lên khi bạn tích lũy thời gian tập trung';

  @override
  String get adoptionCustom => 'Tùy chỉnh';

  @override
  String get adoptionDailyGoalLabel => 'Mục tiêu tập trung mỗi ngày (phút)';

  @override
  String get adoptionReminderLabel => 'Nhắc nhở hàng ngày (tùy chọn)';

  @override
  String get adoptionReminderNone => 'Không';

  @override
  String get adoptionCustomGoalTitle => 'Tùy chỉnh mục tiêu hàng ngày';

  @override
  String get adoptionMinutesPerDay => 'Phút mỗi ngày';

  @override
  String get adoptionMinutesHint => '5 - 180';

  @override
  String get adoptionValidMinutes => 'Nhập giá trị từ 5 đến 180';

  @override
  String get adoptionCustomTargetTitle => 'Tùy chỉnh giờ mục tiêu';

  @override
  String get adoptionTotalHours => 'Tổng số giờ';

  @override
  String get adoptionHoursHint => '10 - 2000';

  @override
  String get adoptionValidHours => 'Nhập giá trị từ 10 đến 2000';

  @override
  String get adoptionSet => 'Đặt';

  @override
  String get adoptionChooseKitten => 'Chọn mèo con!';

  @override
  String adoptionCompanionFor(String quest) {
    return 'Bạn đồng hành cho \"$quest\"';
  }

  @override
  String get adoptionRerollAll => 'Đổi tất cả';

  @override
  String get adoptionNameYourCat2 => 'Đặt tên cho mèo';

  @override
  String get adoptionCatName => 'Tên mèo';

  @override
  String get adoptionCatHint => 'VD: Mochi';

  @override
  String get adoptionRandomTooltip => 'Tên ngẫu nhiên';

  @override
  String adoptionGrowthTarget(String quest, int hours) {
    return 'Mèo sẽ lớn lên khi bạn tập trung vào \"$quest\"! Mục tiêu: $hours giờ.';
  }

  @override
  String get adoptionValidQuestName => 'Vui lòng nhập tên nhiệm vụ';

  @override
  String get adoptionValidCatName => 'Vui lòng đặt tên cho mèo';

  @override
  String adoptionError(String message) {
    return 'Lỗi: $message';
  }

  @override
  String get adoptionBasicInfo => 'Thông tin cơ bản';

  @override
  String get adoptionGoals => 'Mục tiêu';

  @override
  String get adoptionUnlimitedMode => 'Chế độ không giới hạn';

  @override
  String get adoptionUnlimitedDesc => 'Không giới hạn trên, cứ tích lũy';

  @override
  String get adoptionMilestoneMode => 'Chế độ mốc';

  @override
  String get adoptionMilestoneDesc => 'Đặt mục tiêu để đạt';

  @override
  String get adoptionDeadlineLabel => 'Hạn chót';

  @override
  String get adoptionDeadlineNone => 'Chưa đặt';

  @override
  String get adoptionReminderSection => 'Nhắc nhở';

  @override
  String get adoptionMotivationLabel => 'Ghi chú';

  @override
  String get adoptionMotivationHint => 'Viết ghi chú...';

  @override
  String get adoptionMotivationSwap => 'Điền ngẫu nhiên';

  @override
  String get loginAppName => 'Hachimi';

  @override
  String get loginTagline => 'Nuôi mèo. Hoàn thành nhiệm vụ.';

  @override
  String get loginContinueGoogle => 'Tiếp tục với Google';

  @override
  String get loginContinueEmail => 'Tiếp tục với Email';

  @override
  String get loginAlreadyHaveAccount => 'Đã có tài khoản? ';

  @override
  String get loginLogIn => 'Đăng nhập';

  @override
  String get loginWelcomeBack => 'Chào mừng quay lại!';

  @override
  String get loginCreateAccount => 'Tạo tài khoản';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Mật khẩu';

  @override
  String get loginConfirmPassword => 'Xác nhận mật khẩu';

  @override
  String get loginValidEmail => 'Vui lòng nhập email';

  @override
  String get loginValidEmailFormat => 'Vui lòng nhập email hợp lệ';

  @override
  String get loginValidPassword => 'Vui lòng nhập mật khẩu';

  @override
  String get loginValidPasswordLength => 'Mật khẩu phải có ít nhất 6 ký tự';

  @override
  String get loginValidPasswordMatch => 'Mật khẩu không khớp';

  @override
  String get loginCreateAccountButton => 'Tạo tài khoản';

  @override
  String get loginNoAccount => 'Chưa có tài khoản? ';

  @override
  String get loginRegister => 'Đăng ký';

  @override
  String get checkInTitle => 'Điểm danh hàng tháng';

  @override
  String get checkInDays => 'Ngày';

  @override
  String get checkInCoinsEarned => 'Xu đã nhận';

  @override
  String get checkInAllMilestones => 'Đã nhận hết mốc thưởng!';

  @override
  String checkInMilestoneProgress(int remaining, int bonus) {
    return 'Còn $remaining ngày → +$bonus xu';
  }

  @override
  String get checkInMilestones => 'Mốc thưởng';

  @override
  String get checkInFullMonth => 'Trọn tháng';

  @override
  String get checkInRewardSchedule => 'Lịch thưởng';

  @override
  String get checkInWeekday => 'Ngày thường (T2–T6)';

  @override
  String checkInWeekdayReward(int coins) {
    return '$coins xu/ngày';
  }

  @override
  String get checkInWeekend => 'Cuối tuần (T7–CN)';

  @override
  String checkInNDays(int count) {
    return '$count ngày';
  }

  @override
  String get onboardTitle1 => 'Gặp người bạn đồng hành';

  @override
  String get onboardSubtitle1 => 'Mọi nhiệm vụ đều bắt đầu từ mèo con';

  @override
  String get onboardBody1 =>
      'Đặt mục tiêu và nhận nuôi mèo con.\nTập trung và xem mèo lớn lên!';

  @override
  String get onboardTitle2 => 'Tập trung, Phát triển, Tiến hóa';

  @override
  String get onboardSubtitle2 => '4 giai đoạn phát triển';

  @override
  String get onboardBody2 =>
      'Mỗi phút tập trung giúp mèo tiến hóa\ntừ mèo con bé nhỏ thành mèo lão làng oai vệ!';

  @override
  String get onboardTitle3 => 'Xây dựng phòng mèo';

  @override
  String get onboardSubtitle3 => 'Thu thập mèo độc đáo';

  @override
  String get onboardBody3 =>
      'Mỗi nhiệm vụ mang đến một chú mèo ngoại hình riêng.\nKhám phá tất cả và xây bộ sưu tập mơ ước!';

  @override
  String get onboardSkip => 'Bỏ qua';

  @override
  String get onboardLetsGo => 'Bắt đầu thôi!';

  @override
  String get onboardNext => 'Tiếp';

  @override
  String get catRoomTitle => 'CatHouse';

  @override
  String get catRoomInventory => 'Kho đồ';

  @override
  String get catRoomShop => 'Cửa hàng phụ kiện';

  @override
  String get catRoomLoadError => 'Không tải được mèo';

  @override
  String get catRoomEmptyTitle => 'CatHouse đang trống';

  @override
  String get catRoomEmptySubtitle => 'Bắt đầu nhiệm vụ để nhận mèo đầu tiên!';

  @override
  String get catRoomEditQuest => 'Sửa nhiệm vụ';

  @override
  String get catRoomRenameCat => 'Đổi tên mèo';

  @override
  String get catRoomArchiveCat => 'Lưu trữ mèo';

  @override
  String get catRoomNewName => 'Tên mới';

  @override
  String get catRoomRename => 'Đổi tên';

  @override
  String get catRoomArchiveTitle => 'Lưu trữ mèo?';

  @override
  String catRoomArchiveMessage(String name) {
    return 'Thao tác này sẽ lưu trữ \"$name\" và xóa nhiệm vụ liên kết. Mèo vẫn sẽ xuất hiện trong album.';
  }

  @override
  String get catRoomArchive => 'Lưu trữ';

  @override
  String catRoomAlbumSection(int count) {
    return 'Album ($count)';
  }

  @override
  String get catRoomReactivateCat => 'Kích hoạt lại mèo';

  @override
  String get catRoomReactivateTitle => 'Kích hoạt lại mèo?';

  @override
  String catRoomReactivateMessage(String name) {
    return 'Thao tác này sẽ đưa \"$name\" và nhiệm vụ trở lại CatHouse.';
  }

  @override
  String get catRoomReactivate => 'Kích hoạt lại';

  @override
  String get catRoomArchivedLabel => 'Đã lưu trữ';

  @override
  String catRoomArchiveSuccess(String name) {
    return 'Đã lưu trữ \"$name\"';
  }

  @override
  String catRoomReactivateSuccess(String name) {
    return 'Đã kích hoạt lại \"$name\"';
  }

  @override
  String get addHabitTitle => 'Nhiệm vụ mới';

  @override
  String get addHabitQuestName => 'Tên nhiệm vụ';

  @override
  String get addHabitQuestHint => 'VD: Luyện LeetCode';

  @override
  String get addHabitValidName => 'Vui lòng nhập tên nhiệm vụ';

  @override
  String get addHabitTargetHours => 'Giờ mục tiêu';

  @override
  String get addHabitTargetHint => 'VD: 100';

  @override
  String get addHabitValidTarget => 'Vui lòng nhập giờ mục tiêu';

  @override
  String get addHabitValidNumber => 'Vui lòng nhập số hợp lệ';

  @override
  String get addHabitCreate => 'Tạo nhiệm vụ';

  @override
  String get addHabitHoursSuffix => 'giờ';

  @override
  String shopTabPlants(int count) {
    return 'Cây ($count)';
  }

  @override
  String shopTabWild(int count) {
    return 'Hoang dã ($count)';
  }

  @override
  String shopTabCollars(int count) {
    return 'Vòng cổ ($count)';
  }

  @override
  String get shopNoAccessories => 'Không có phụ kiện';

  @override
  String shopBuyConfirm(String name) {
    return 'Mua $name?';
  }

  @override
  String get shopPurchaseButton => 'Mua';

  @override
  String get shopNotEnoughCoinsButton => 'Không đủ xu';

  @override
  String shopPurchaseSuccess(String name) {
    return 'Đã mua! $name đã thêm vào kho đồ';
  }

  @override
  String shopPurchaseFailed(int price) {
    return 'Không đủ xu (cần $price)';
  }

  @override
  String get inventoryTitle => 'Kho đồ';

  @override
  String inventoryInBox(int count) {
    return 'Trong hộp ($count)';
  }

  @override
  String get inventoryEmpty => 'Kho đồ trống.\nGhé cửa hàng để mua phụ kiện!';

  @override
  String inventoryEquippedOnCats(int count) {
    return 'Đang đeo trên mèo ($count)';
  }

  @override
  String get inventoryNoEquipped => 'Chưa có phụ kiện nào được đeo trên mèo.';

  @override
  String get inventoryUnequip => 'Tháo';

  @override
  String get inventoryNoActiveCats => 'Không có mèo đang hoạt động';

  @override
  String inventoryEquipTo(String name) {
    return 'Đeo $name cho:';
  }

  @override
  String inventoryEquipSuccess(String name) {
    return 'Đã đeo $name';
  }

  @override
  String inventoryUnequipSuccess(String catName) {
    return 'Đã tháo khỏi $catName';
  }

  @override
  String get chatCatNotFound => 'Không tìm thấy mèo';

  @override
  String chatTitle(String name) {
    return 'Trò chuyện với $name';
  }

  @override
  String get chatClearHistory => 'Xóa lịch sử';

  @override
  String chatEmptyTitle(String name) {
    return 'Chào $name!';
  }

  @override
  String get chatEmptySubtitle =>
      'Bắt đầu trò chuyện với mèo. Chúng sẽ trả lời theo tính cách!';

  @override
  String get chatGenerating => 'Đang tạo...';

  @override
  String get chatTypeMessage => 'Nhập tin nhắn...';

  @override
  String get chatClearConfirmTitle => 'Xóa lịch sử trò chuyện?';

  @override
  String get chatClearConfirmMessage =>
      'Thao tác này sẽ xóa tất cả tin nhắn. Không thể hoàn tác.';

  @override
  String get chatClearButton => 'Xóa';

  @override
  String diaryTitle(String name) {
    return 'Nhật ký $name';
  }

  @override
  String get diaryLoadFailed => 'Không tải được nhật ký';

  @override
  String get diaryRetry => 'Thử lại';

  @override
  String get diaryEmptyTitle2 => 'Chưa có mục nhật ký';

  @override
  String get diaryEmptySubtitle =>
      'Hoàn thành phiên tập trung để mèo viết nhật ký đầu tiên!';

  @override
  String get statsTitle => 'Thống kê';

  @override
  String get statsTotalHours => 'Tổng giờ';

  @override
  String statsTimeValue(int hours, int minutes) {
    return '${hours}g ${minutes}p';
  }

  @override
  String get statsBestStreak => 'Chuỗi ngày tốt nhất';

  @override
  String statsStreakDays(int count) {
    return '$count ngày';
  }

  @override
  String get statsOverallProgress => 'Tiến trình tổng thể';

  @override
  String statsPercentOfGoals(String percent) {
    return '$percent% tất cả mục tiêu';
  }

  @override
  String get statsPerQuestProgress => 'Tiến trình theo nhiệm vụ';

  @override
  String get statsQuestLoadError => 'Không tải được thống kê nhiệm vụ';

  @override
  String get statsNoQuestData => 'Chưa có dữ liệu nhiệm vụ';

  @override
  String get statsNoQuestHint => 'Bắt đầu nhiệm vụ để xem tiến trình!';

  @override
  String get statsLast30Days => '30 ngày qua';

  @override
  String get habitDetailQuestNotFound => 'Không tìm thấy nhiệm vụ';

  @override
  String get habitDetailComplete => 'hoàn thành';

  @override
  String get habitDetailTotalTime => 'Tổng thời gian';

  @override
  String get habitDetailCurrentStreak => 'Chuỗi ngày hiện tại';

  @override
  String get habitDetailTarget => 'Mục tiêu';

  @override
  String habitDetailDaysUnit(int count) {
    return '$count ngày';
  }

  @override
  String habitDetailHoursUnit(int count) {
    return '$count giờ';
  }

  @override
  String checkInBannerSuccess(int coins) {
    return '+$coins xu! Điểm danh hàng ngày hoàn tất';
  }

  @override
  String checkInBannerBonus(int bonus) {
    return ' + $bonus thưởng mốc!';
  }

  @override
  String get checkInBannerSemantics => 'Điểm danh hàng ngày';

  @override
  String get checkInBannerLoading => 'Đang tải trạng thái điểm danh...';

  @override
  String checkInBannerPrompt(int coins) {
    return 'Điểm danh nhận +$coins xu';
  }

  @override
  String checkInBannerSummary(int count, int total, int coins) {
    return '$count/$total ngày  ·  hôm nay +$coins';
  }

  @override
  String commonErrorWithDetail(String error) {
    return 'Lỗi: $error';
  }

  @override
  String get profileFallbackUser => 'Người dùng';

  @override
  String get fallbackCatName => 'Mèo';

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
  String get notifFocusing => 'đang tập trung...';

  @override
  String get notifInProgress => 'Phiên tập trung đang diễn ra';

  @override
  String get unitMinShort => 'p';

  @override
  String get unitHourShort => 'g';

  @override
  String get weekdayMon => 'T2';

  @override
  String get weekdayTue => 'T3';

  @override
  String get weekdayWed => 'T4';

  @override
  String get weekdayThu => 'T5';

  @override
  String get weekdayFri => 'T6';

  @override
  String get weekdaySat => 'T7';

  @override
  String get weekdaySun => 'CN';

  @override
  String get statsTotalSessions => 'Phiên';

  @override
  String get statsTotalHabits => 'Thói quen';

  @override
  String get statsActiveDays => 'Ngày hoạt động';

  @override
  String get statsWeeklyTrend => 'Xu hướng tuần';

  @override
  String get statsRecentSessions => 'Tập trung gần đây';

  @override
  String get statsViewAllHistory => 'Xem toàn bộ lịch sử';

  @override
  String get historyTitle => 'Lịch sử tập trung';

  @override
  String get historyFilterAll => 'Tất cả';

  @override
  String historySessionCount(int count) {
    return '$count phiên';
  }

  @override
  String historyTotalMinutes(int minutes) {
    return '$minutes phút';
  }

  @override
  String get historyNoSessions => 'Chưa có bản ghi tập trung';

  @override
  String get historyNoSessionsHint =>
      'Hoàn thành phiên tập trung để xem tại đây';

  @override
  String get historyLoadMore => 'Tải thêm';

  @override
  String get sessionCompleted => 'Hoàn thành';

  @override
  String get sessionAbandoned => 'Đã bỏ';

  @override
  String get sessionInterrupted => 'Bị gián đoạn';

  @override
  String get sessionCountdown => 'Đếm ngược';

  @override
  String get sessionStopwatch => 'Bấm giờ';

  @override
  String get historyDateGroupToday => 'Hôm nay';

  @override
  String get historyDateGroupYesterday => 'Hôm qua';

  @override
  String get historyLoadError => 'Không tải được lịch sử';

  @override
  String get historySelectMonth => 'Chọn tháng';

  @override
  String get historyAllMonths => 'Tất cả tháng';

  @override
  String get historyAllHabits => 'Tất cả';

  @override
  String get homeTabAchievements => 'Thành tựu';

  @override
  String get achievementTitle => 'Thành tựu';

  @override
  String get achievementTabOverview => 'Tổng quan';

  @override
  String get achievementTabQuest => 'Nhiệm vụ';

  @override
  String get achievementTabStreak => 'Chuỗi ngày';

  @override
  String get achievementTabCat => 'Mèo';

  @override
  String get achievementTabPersist => 'Kiên trì';

  @override
  String get achievementSummaryTitle => 'Tiến trình thành tựu';

  @override
  String achievementUnlockedCount(int count) {
    return 'Đã mở khóa $count';
  }

  @override
  String achievementTotalCoins(int coins) {
    return 'Đã nhận $coins xu';
  }

  @override
  String get achievementUnlocked => 'Đã mở khóa thành tựu!';

  @override
  String get achievementAwesome => 'Tuyệt vời!';

  @override
  String get achievementIncredible => 'Đáng kinh ngạc!';

  @override
  String get achievementHidden => '???';

  @override
  String get achievementHiddenDesc => 'Đây là thành tựu ẩn';

  @override
  String achievementPersistDesc(int days) {
    return 'Tích lũy $days ngày điểm danh trên bất kỳ nhiệm vụ nào';
  }

  @override
  String achievementTitleCount(int count) {
    return 'Đã mở khóa $count danh hiệu';
  }

  @override
  String get growthPathTitle => 'Lộ trình phát triển';

  @override
  String get growthPathKitten => 'Bắt đầu hành trình mới';

  @override
  String get growthPathAdolescent => 'Xây nền tảng ban đầu';

  @override
  String get growthPathAdult => 'Kỹ năng vững chắc';

  @override
  String get growthPathSenior => 'Chuyên sâu thành thạo';

  @override
  String get growthPathTip =>
      'Nghiên cứu cho thấy 20 giờ luyện tập tập trung đủ để xây nền tảng một kỹ năng mới — Josh Kaufman';

  @override
  String achievementCelebrationCoins(int count) {
    return '+$count xu';
  }

  @override
  String achievementCelebrationTitle(String title) {
    return 'Đạt danh hiệu: $title';
  }

  @override
  String get achievementCelebrationDismiss => 'Tuyệt!';

  @override
  String get achievementCelebrationSkipAll => 'Bỏ qua tất cả';

  @override
  String achievementCelebrationCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String achievementUnlockedAt(String date) {
    return 'Mở khóa ngày $date';
  }

  @override
  String get achievementLocked => 'Chưa mở khóa';

  @override
  String achievementRewardCoins(int count) {
    return '+$count xu';
  }

  @override
  String get reminderModeDaily => 'Mỗi ngày';

  @override
  String get reminderModeWeekdays => 'Ngày thường';

  @override
  String get reminderModeMonday => 'Thứ Hai';

  @override
  String get reminderModeTuesday => 'Thứ Ba';

  @override
  String get reminderModeWednesday => 'Thứ Tư';

  @override
  String get reminderModeThursday => 'Thứ Năm';

  @override
  String get reminderModeFriday => 'Thứ Sáu';

  @override
  String get reminderModeSaturday => 'Thứ Bảy';

  @override
  String get reminderModeSunday => 'Chủ Nhật';

  @override
  String get reminderPickerTitle => 'Chọn giờ nhắc nhở';

  @override
  String get reminderHourUnit => 'g';

  @override
  String get reminderMinuteUnit => 'p';

  @override
  String get reminderAddMore => 'Thêm nhắc nhở';

  @override
  String get reminderMaxReached => 'Tối đa 5 nhắc nhở';

  @override
  String get reminderConfirm => 'Xác nhận';

  @override
  String reminderNotificationTitle(String catName) {
    return '$catName nhớ bạn!';
  }

  @override
  String reminderNotificationBody(String habitName) {
    return 'Đến giờ $habitName rồi — mèo đang đợi bạn!';
  }

  @override
  String get deleteAccountDataWarning =>
      'Toàn bộ dữ liệu sau sẽ bị xóa vĩnh viễn:';

  @override
  String get deleteAccountQuests => 'Nhiệm vụ';

  @override
  String get deleteAccountCats => 'Mèo';

  @override
  String get deleteAccountHours => 'Giờ tập trung';

  @override
  String get deleteAccountIrreversible => 'Không thể hoàn tác thao tác này';

  @override
  String get deleteAccountContinue => 'Tiếp tục';

  @override
  String get deleteAccountConfirmTitle => 'Xác nhận xóa';

  @override
  String get deleteAccountTypeDelete =>
      'Nhập DELETE để xác nhận xóa tài khoản:';

  @override
  String get deleteAccountAuthCancelled => 'Xác thực đã bị hủy';

  @override
  String deleteAccountAuthFailed(String error) {
    return 'Xác thực thất bại: $error';
  }

  @override
  String get deleteAccountProgress => 'Đang xóa tài khoản...';

  @override
  String get deleteAccountSuccess => 'Đã xóa tài khoản';

  @override
  String get drawerGuestLoginSubtitle =>
      'Đồng bộ dữ liệu và mở khóa tính năng AI';

  @override
  String get drawerGuestSignIn => 'Đăng nhập';

  @override
  String get drawerMilestones => 'Mốc thưởng';

  @override
  String drawerMilestoneFocus(int hours, int minutes) {
    return 'Tổng tập trung: ${hours}g ${minutes}p';
  }

  @override
  String drawerMilestoneCats(int count) {
    return 'Gia đình mèo: $count';
  }

  @override
  String drawerMilestoneQuests(int count) {
    return 'Nhiệm vụ đang hoạt động: $count';
  }

  @override
  String get drawerMySection => 'Của tôi';

  @override
  String get drawerSessionHistory => 'Lịch sử tập trung';

  @override
  String get drawerCheckInCalendar => 'Lịch điểm danh';

  @override
  String get drawerAccountSection => 'Tài khoản';

  @override
  String get settingsResetData => 'Đặt lại toàn bộ dữ liệu';

  @override
  String get settingsResetDataTitle => 'Đặt lại toàn bộ dữ liệu?';

  @override
  String get settingsResetDataMessage =>
      'Thao tác này sẽ xóa toàn bộ dữ liệu cục bộ và quay về màn hình chào mừng. Không thể hoàn tác.';

  @override
  String get guestUpgradeTitle => 'Bảo vệ dữ liệu của bạn';

  @override
  String get guestUpgradeMessage =>
      'Liên kết tài khoản để sao lưu tiến trình, mở khóa nhật ký AI và trò chuyện, đồng bộ giữa các thiết bị.';

  @override
  String get guestUpgradeLinkButton => 'Liên kết tài khoản';

  @override
  String get guestUpgradeLater => 'Để sau';

  @override
  String get loginLinkTagline => 'Liên kết tài khoản để bảo vệ dữ liệu';

  @override
  String get aiTeaserTitle => 'Nhật ký mèo';

  @override
  String aiTeaserPreview(String catName) {
    return 'Hôm nay tớ lại học cùng chủ nhân... $catName cảm thấy thông minh hơn mỗi ngày~';
  }

  @override
  String aiTeaserCta(String catName) {
    return 'Liên kết tài khoản để xem $catName muốn nói gì';
  }

  @override
  String get authErrorEmailInUse => 'Email này đã được đăng ký';

  @override
  String get authErrorWrongPassword => 'Email hoặc mật khẩu không đúng';

  @override
  String get authErrorUserNotFound => 'Không tìm thấy tài khoản với email này';

  @override
  String get authErrorTooManyRequests =>
      'Quá nhiều lần thử. Vui lòng thử lại sau';

  @override
  String get authErrorNetwork => 'Lỗi mạng. Kiểm tra kết nối của bạn';

  @override
  String get authErrorAdminRestricted => 'Đăng nhập tạm thời bị hạn chế';

  @override
  String get authErrorWeakPassword => 'Mật khẩu quá yếu. Dùng ít nhất 6 ký tự';

  @override
  String get authErrorGeneric => 'Đã xảy ra lỗi. Thử lại nhé';

  @override
  String get deleteAccountReauthEmail => 'Nhập mật khẩu để tiếp tục';

  @override
  String get deleteAccountReauthPasswordHint => 'Mật khẩu';

  @override
  String get deleteAccountError => 'Đã xảy ra lỗi. Vui lòng thử lại sau.';

  @override
  String get deleteAccountPermissionError =>
      'Lỗi quyền truy cập. Thử đăng xuất rồi đăng nhập lại.';

  @override
  String get deleteAccountNetworkError =>
      'Không có kết nối mạng. Kiểm tra lại mạng.';

  @override
  String get deleteAccountRetainedData =>
      'Dữ liệu phân tích và báo cáo lỗi không thể xóa.';

  @override
  String get deleteAccountStepCloud => 'Đang xóa dữ liệu đám mây...';

  @override
  String get deleteAccountStepLocal => 'Đang xóa dữ liệu cục bộ...';

  @override
  String get deleteAccountStepDone => 'Hoàn tất';

  @override
  String get deleteAccountQueued =>
      'Đã xóa dữ liệu cục bộ. Xóa tài khoản đám mây đang chờ xử lý và sẽ hoàn tất khi có mạng.';

  @override
  String get deleteAccountPending =>
      'Đang chờ xóa tài khoản. Giữ ứng dụng trực tuyến để hoàn tất xóa đám mây và xác thực.';

  @override
  String get deleteAccountAbandon => 'Bắt đầu mới';

  @override
  String get archiveConflictTitle => 'Chọn bản lưu trữ giữ lại';

  @override
  String get archiveConflictMessage =>
      'Cả lưu trữ cục bộ và đám mây đều có dữ liệu. Chọn bản muốn giữ:';

  @override
  String get archiveConflictLocal => 'Lưu trữ cục bộ';

  @override
  String get archiveConflictCloud => 'Lưu trữ đám mây';

  @override
  String get archiveConflictKeepCloud => 'Giữ đám mây';

  @override
  String get archiveConflictKeepLocal => 'Giữ cục bộ';

  @override
  String get loginShowPassword => 'Hiện mật khẩu';

  @override
  String get loginHidePassword => 'Ẩn mật khẩu';

  @override
  String get errorGeneric => 'Đã xảy ra lỗi. Vui lòng thử lại sau';

  @override
  String get errorCreateHabit => 'Không tạo được thói quen. Thử lại nhé';

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
}
