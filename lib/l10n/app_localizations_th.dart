// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class STh extends S {
  STh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'Hachimi';

  @override
  String get homeTabToday => 'วันนี้';

  @override
  String get homeTabCatHouse => 'CatHouse';

  @override
  String get homeTabStats => 'สถิติ';

  @override
  String get homeTabProfile => 'โปรไฟล์';

  @override
  String get adoptionStepDefineHabit => 'กำหนดนิสัย';

  @override
  String get adoptionStepAdoptCat => 'รับเลี้ยงแมว';

  @override
  String get adoptionStepNameCat => 'ตั้งชื่อแมว';

  @override
  String get adoptionHabitName => 'ชื่อนิสัย';

  @override
  String get adoptionHabitNameHint => 'เช่น อ่านหนังสือทุกวัน';

  @override
  String get adoptionDailyGoal => 'เป้าหมายรายวัน';

  @override
  String get adoptionTargetHours => 'ชั่วโมงเป้าหมาย';

  @override
  String get adoptionTargetHoursHint =>
      'จำนวนชั่วโมงทั้งหมดเพื่อทำนิสัยนี้ให้สำเร็จ';

  @override
  String adoptionMinutes(int count) {
    return '$count นาที';
  }

  @override
  String get adoptionRefreshCat => 'ลองตัวอื่น';

  @override
  String adoptionPersonality(String name) {
    return 'บุคลิก: $name';
  }

  @override
  String get adoptionNameYourCat => 'ตั้งชื่อให้แมวของคุณ';

  @override
  String get adoptionRandomName => 'สุ่ม';

  @override
  String get adoptionCreate => 'สร้างนิสัยและรับเลี้ยงแมว';

  @override
  String get adoptionNext => 'ถัดไป';

  @override
  String get adoptionBack => 'ย้อนกลับ';

  @override
  String get adoptionCatNameLabel => 'ชื่อแมว';

  @override
  String get adoptionCatNameHint => 'เช่น โมจิ';

  @override
  String get adoptionRandomNameTooltip => 'ชื่อสุ่ม';

  @override
  String get catHouseTitle => 'CatHouse';

  @override
  String get catHouseEmpty => 'ยังไม่มีแมว! สร้างนิสัยเพื่อรับเลี้ยงแมวตัวแรก';

  @override
  String catHouseGrowth(int minutes, int target) {
    return '$minutes / $target นาที';
  }

  @override
  String get catDetailGrowthProgress => 'ความก้าวหน้าการเติบโต';

  @override
  String catDetailTotalMinutes(int minutes) {
    return 'โฟกัส $minutes นาที';
  }

  @override
  String catDetailTargetMinutes(int minutes) {
    return 'เป้าหมาย: $minutes นาที';
  }

  @override
  String get catDetailRename => 'เปลี่ยนชื่อ';

  @override
  String get catDetailAccessories => 'เครื่องประดับ';

  @override
  String get catDetailStartFocus => 'เริ่มโฟกัส';

  @override
  String get catDetailBoundHabit => 'นิสัยที่ผูกไว้';

  @override
  String catDetailStage(String stage) {
    return 'ระดับ: $stage';
  }

  @override
  String coinBalance(int amount) {
    return '$amount เหรียญ';
  }

  @override
  String coinCheckInReward(int amount) {
    return '+$amount เหรียญ!';
  }

  @override
  String get coinCheckInTitle => 'เช็คอินรายวัน';

  @override
  String get coinInsufficientBalance => 'เหรียญไม่เพียงพอ';

  @override
  String get shopTitle => 'ร้านเครื่องประดับ';

  @override
  String shopPrice(int price) {
    return '$price เหรียญ';
  }

  @override
  String get shopPurchase => 'ซื้อ';

  @override
  String get shopEquipped => 'สวมใส่อยู่';

  @override
  String focusCompleteMinutes(int minutes) {
    return '+$minutes นาที';
  }

  @override
  String get focusCompleteStageUp => 'เลื่อนระดับ!';

  @override
  String get focusCompleteGreatJob => 'เก่งมาก!';

  @override
  String get focusCompleteDone => 'เสร็จสิ้น';

  @override
  String get focusCompleteItsOkay => 'ไม่เป็นไร!';

  @override
  String focusCompleteEvolved(String catName) {
    return '$catName วิวัฒนาการแล้ว!';
  }

  @override
  String focusCompleteFocusedFor(int minutes) {
    return 'คุณโฟกัสได้ $minutes นาที';
  }

  @override
  String focusCompleteAbandonedMessage(String catName) {
    return '$catName บอกว่า: \"เราจะลองใหม่นะ!\"';
  }

  @override
  String get focusCompleteFocusTime => 'เวลาโฟกัส';

  @override
  String get focusCompleteCoinsEarned => 'เหรียญที่ได้';

  @override
  String get focusCompleteBaseXp => 'XP พื้นฐาน';

  @override
  String get focusCompleteStreakBonus => 'โบนัสสตรีค';

  @override
  String get focusCompleteMilestoneBonus => 'โบนัสไมล์สโตน';

  @override
  String get focusCompleteFullHouseBonus => 'โบนัสฟูลเฮาส์';

  @override
  String get focusCompleteTotal => 'รวม';

  @override
  String focusCompleteEvolvedTo(String stage) {
    return 'วิวัฒนาการเป็น $stage!';
  }

  @override
  String get focusCompleteYourCat => 'แมวของคุณ';

  @override
  String get focusCompleteDiaryWriting => 'กำลังเขียนไดอารี่...';

  @override
  String get focusCompleteDiaryWritten => 'เขียนไดอารี่แล้ว!';

  @override
  String get focusCompleteNotifTitle => 'เควสต์สำเร็จ!';

  @override
  String focusCompleteNotifBody(String catName, int xp, int minutes) {
    return '$catName ได้ +$xp XP จากการโฟกัส $minutes นาที';
  }

  @override
  String get stageKitten => 'ลูกแมว';

  @override
  String get stageAdolescent => 'แมววัยรุ่น';

  @override
  String get stageAdult => 'แมวโตเต็มวัย';

  @override
  String get stageSenior => 'แมวอาวุโส';

  @override
  String get migrationTitle => 'ต้องอัปเดตข้อมูล';

  @override
  String get migrationMessage =>
      'Hachimi ได้อัปเดตระบบแมวพิกเซลใหม่แล้ว! ข้อมูลแมวเก่าไม่สามารถใช้งานร่วมกันได้ กรุณารีเซ็ตเพื่อเริ่มต้นใหม่';

  @override
  String get migrationResetButton => 'รีเซ็ตและเริ่มใหม่';

  @override
  String get sessionResumeTitle => 'ทำต่อไหม?';

  @override
  String sessionResumeMessage(String habitName, String elapsed) {
    return 'คุณมีเซสชันโฟกัสค้างอยู่ ($habitName, $elapsed) ทำต่อไหม?';
  }

  @override
  String get sessionResumeButton => 'ทำต่อ';

  @override
  String get sessionDiscard => 'ยกเลิก';

  @override
  String get todaySummaryMinutes => 'วันนี้';

  @override
  String get todaySummaryTotal => 'ทั้งหมด';

  @override
  String get todaySummaryCats => 'แมว';

  @override
  String get todayYourQuests => 'เควสต์ของคุณ';

  @override
  String get todayNoQuests => 'ยังไม่มีเควสต์';

  @override
  String get todayNoQuestsHint => 'แตะ + เพื่อเริ่มเควสต์และรับเลี้ยงแมว!';

  @override
  String get todayFocus => 'โฟกัส';

  @override
  String get todayDeleteQuestTitle => 'ลบเควสต์?';

  @override
  String todayDeleteQuestMessage(String name) {
    return 'คุณแน่ใจว่าต้องการลบ \"$name\" ไหม? แมวจะถูกย้ายไปอัลบั้มของคุณ';
  }

  @override
  String todayQuestCompleted(String name) {
    return '$name สำเร็จแล้ว';
  }

  @override
  String get todayFailedToLoad => 'โหลดเควสต์ไม่สำเร็จ';

  @override
  String todayMinToday(int count) {
    return 'วันนี้ $count นาที';
  }

  @override
  String todayGoalMinPerDay(int count) {
    return 'เป้าหมาย: $count นาที/วัน';
  }

  @override
  String get todayFeaturedCat => 'แมวเด่น';

  @override
  String get todayAddHabit => 'เพิ่มนิสัย';

  @override
  String get todayNoHabits => 'สร้างนิสัยแรกเพื่อเริ่มต้น!';

  @override
  String get todayNewQuest => 'เควสต์ใหม่';

  @override
  String get todayStartFocus => 'เริ่มโฟกัส';

  @override
  String get timerStart => 'เริ่ม';

  @override
  String get timerPause => 'หยุดชั่วคราว';

  @override
  String get timerResume => 'ทำต่อ';

  @override
  String get timerDone => 'เสร็จสิ้น';

  @override
  String get timerGiveUp => 'ยอมแพ้';

  @override
  String get timerRemaining => 'เหลือ';

  @override
  String get timerElapsed => 'ผ่านไป';

  @override
  String get timerPaused => 'หยุดชั่วคราว';

  @override
  String get timerQuestNotFound => 'ไม่พบเควสต์';

  @override
  String get timerNotificationBanner =>
      'เปิดการแจ้งเตือนเพื่อดูความก้าวหน้าของตัวจับเวลาเมื่อแอปทำงานเบื้องหลัง';

  @override
  String get timerNotificationDismiss => 'ปิด';

  @override
  String get timerNotificationEnable => 'เปิด';

  @override
  String timerGraceBack(int seconds) {
    return 'กลับ (${seconds}s)';
  }

  @override
  String get giveUpTitle => 'ยอมแพ้?';

  @override
  String get giveUpMessage =>
      'หากคุณโฟกัสได้อย่างน้อย 5 นาที เวลาจะยังนับเข้าการเติบโตของแมว แมวของคุณจะเข้าใจ!';

  @override
  String get giveUpKeepGoing => 'ทำต่อ';

  @override
  String get giveUpConfirm => 'ยอมแพ้';

  @override
  String get settingsTitle => 'การตั้งค่า';

  @override
  String get settingsGeneral => 'ทั่วไป';

  @override
  String get settingsAppearance => 'การแสดงผล';

  @override
  String get settingsNotifications => 'การแจ้งเตือน';

  @override
  String get settingsNotificationFocusReminders => 'แจ้งเตือนโฟกัส';

  @override
  String get settingsNotificationSubtitle =>
      'รับการแจ้งเตือนรายวันเพื่อไม่ให้หลุดเป้า';

  @override
  String get settingsLanguage => 'ภาษา';

  @override
  String get settingsLanguageSystem => 'ค่าเริ่มต้นของระบบ';

  @override
  String get settingsLanguageEnglish => 'อังกฤษ';

  @override
  String get settingsLanguageChinese => '中文';

  @override
  String get settingsThemeMode => 'โหมดธีม';

  @override
  String get settingsThemeModeSystem => 'ระบบ';

  @override
  String get settingsThemeModeLight => 'สว่าง';

  @override
  String get settingsThemeModeDark => 'มืด';

  @override
  String get settingsThemeColor => 'สีธีม';

  @override
  String get settingsThemeColorDynamic => 'ไดนามิก';

  @override
  String get settingsThemeColorDynamicSubtitle => 'ใช้สีจากวอลเปเปอร์';

  @override
  String get settingsAbout => 'เกี่ยวกับ';

  @override
  String get settingsVersion => 'เวอร์ชัน';

  @override
  String get settingsLicenses => 'ใบอนุญาต';

  @override
  String get settingsAccount => 'บัญชี';

  @override
  String get logoutTitle => 'ออกจากระบบ?';

  @override
  String get logoutMessage => 'คุณแน่ใจว่าต้องการออกจากระบบไหม?';

  @override
  String get loggingOut => 'กำลังออกจากระบบ...';

  @override
  String get deleteAccountTitle => 'ลบบัญชี?';

  @override
  String get deleteAccountMessage =>
      'การดำเนินการนี้จะลบบัญชีและข้อมูลทั้งหมดของคุณอย่างถาวร ไม่สามารถยกเลิกได้';

  @override
  String get deleteAccountWarning => 'ไม่สามารถยกเลิกการดำเนินการนี้ได้';

  @override
  String get profileTitle => 'โปรไฟล์';

  @override
  String get profileYourJourney => 'เส้นทางของคุณ';

  @override
  String get profileTotalFocus => 'โฟกัสทั้งหมด';

  @override
  String get profileTotalCats => 'แมวทั้งหมด';

  @override
  String get profileTotalQuests => 'เควสต์';

  @override
  String get profileEditName => 'แก้ไขชื่อ';

  @override
  String get profileDisplayName => 'ชื่อที่แสดง';

  @override
  String get profileChooseAvatar => 'เลือกอวาตาร์';

  @override
  String get profileSaved => 'บันทึกโปรไฟล์แล้ว';

  @override
  String get profileSettings => 'การตั้งค่า';

  @override
  String get habitDetailStreak => 'สตรีค';

  @override
  String get habitDetailBestStreak => 'ดีที่สุด';

  @override
  String get habitDetailTotalMinutes => 'ทั้งหมด';

  @override
  String get commonCancel => 'ยกเลิก';

  @override
  String get commonConfirm => 'ยืนยัน';

  @override
  String get commonSave => 'บันทึก';

  @override
  String get commonDelete => 'ลบ';

  @override
  String get commonEdit => 'แก้ไข';

  @override
  String get commonDone => 'เสร็จสิ้น';

  @override
  String get commonDismiss => 'ปิด';

  @override
  String get commonEnable => 'เปิด';

  @override
  String get commonLoading => 'กำลังโหลด...';

  @override
  String get commonError => 'เกิดข้อผิดพลาด';

  @override
  String get commonRetry => 'ลองอีกครั้ง';

  @override
  String get commonResume => 'ทำต่อ';

  @override
  String get commonPause => 'หยุดชั่วคราว';

  @override
  String get commonLogOut => 'ออกจากระบบ';

  @override
  String get commonDeleteAccount => 'ลบบัญชี';

  @override
  String get commonYes => 'ใช่';

  @override
  String chatDailyRemaining(int count) {
    return 'เหลือ $count ข้อความวันนี้';
  }

  @override
  String get chatDailyLimitReached => 'ถึงลิมิตข้อความรายวันแล้ว';

  @override
  String get aiTemporarilyUnavailable => 'ฟีเจอร์ AI ไม่พร้อมใช้งานชั่วคราว';

  @override
  String get catDetailNotFound => 'ไม่พบแมว';

  @override
  String get catDetailChatTooltip => 'แชท';

  @override
  String get catDetailRenameTooltip => 'เปลี่ยนชื่อ';

  @override
  String get catDetailGrowthTitle => 'ความก้าวหน้าการเติบโต';

  @override
  String catDetailTarget(int hours) {
    return 'เป้าหมาย: $hours ชม.';
  }

  @override
  String get catDetailRenameTitle => 'เปลี่ยนชื่อแมว';

  @override
  String get catDetailNewName => 'ชื่อใหม่';

  @override
  String get catDetailRenamed => 'เปลี่ยนชื่อแมวแล้ว!';

  @override
  String get catDetailQuestBadge => 'เควสต์';

  @override
  String get catDetailEditQuest => 'แก้ไขเควสต์';

  @override
  String get catDetailDailyGoal => 'เป้าหมายรายวัน';

  @override
  String get catDetailTodaysFocus => 'โฟกัสวันนี้';

  @override
  String get catDetailTotalFocus => 'โฟกัสทั้งหมด';

  @override
  String get catDetailTargetLabel => 'เป้าหมาย';

  @override
  String get catDetailCompletion => 'ความสำเร็จ';

  @override
  String get catDetailCurrentStreak => 'สตรีคปัจจุบัน';

  @override
  String get catDetailBestStreakLabel => 'สตรีคดีที่สุด';

  @override
  String get catDetailAvgDaily => 'เฉลี่ยรายวัน';

  @override
  String get catDetailDaysActive => 'วันที่ใช้งาน';

  @override
  String get catDetailCheckInDays => 'วันเช็คอิน';

  @override
  String get catDetailEditQuestTitle => 'แก้ไขเควสต์';

  @override
  String get catDetailQuestName => 'ชื่อเควสต์';

  @override
  String get catDetailDailyGoalMinutes => 'เป้าหมายรายวัน (นาที)';

  @override
  String get catDetailTargetTotalHours => 'เป้าหมายรวม (ชั่วโมง)';

  @override
  String get catDetailQuestUpdated => 'อัปเดตเควสต์แล้ว!';

  @override
  String get catDetailTargetCompletedHint =>
      'ถึงเป้าหมายแล้ว — ตอนนี้อยู่ในโหมดไม่จำกัด';

  @override
  String get catDetailDailyReminder => 'แจ้งเตือนรายวัน';

  @override
  String catDetailEveryDay(String time) {
    return '$time ทุกวัน';
  }

  @override
  String get catDetailNoReminder => 'ไม่มีการแจ้งเตือน';

  @override
  String get catDetailChange => 'เปลี่ยน';

  @override
  String get catDetailRemoveReminder => 'ลบการแจ้งเตือน';

  @override
  String get catDetailSet => 'ตั้งค่า';

  @override
  String catDetailReminderSet(String time) {
    return 'ตั้งแจ้งเตือนเวลา $time';
  }

  @override
  String get catDetailReminderRemoved => 'ลบการแจ้งเตือนแล้ว';

  @override
  String get catDetailDiaryTitle => 'ไดอารี่ Hachimi';

  @override
  String get catDetailDiaryLoading => 'กำลังโหลด...';

  @override
  String get catDetailDiaryError => 'โหลดไดอารี่ไม่สำเร็จ';

  @override
  String get catDetailDiaryEmpty =>
      'ยังไม่มีไดอารี่วันนี้ ทำเซสชันโฟกัสให้สำเร็จก่อน!';

  @override
  String catDetailChatWith(String name) {
    return 'แชทกับ $name';
  }

  @override
  String get catDetailChatSubtitle =>
      'พูดคุยกับแมวของคุณ พวกเขาจะตอบตามบุคลิก!';

  @override
  String get catDetailActivity => 'กิจกรรม';

  @override
  String get catDetailActivityError => 'โหลดข้อมูลกิจกรรมไม่สำเร็จ';

  @override
  String get catDetailAccessoriesTitle => 'เครื่องประดับ';

  @override
  String get catDetailEquipped => 'สวมใส่: ';

  @override
  String get catDetailNone => 'ไม่มี';

  @override
  String get catDetailUnequip => 'ถอด';

  @override
  String catDetailFromInventory(int count) {
    return 'จากคลัง ($count)';
  }

  @override
  String get catDetailNoAccessories => 'ยังไม่มีเครื่องประดับ ไปร้านค้าเลย!';

  @override
  String catDetailEquippedItem(String name) {
    return 'สวม $name แล้ว';
  }

  @override
  String get catDetailUnequipped => 'ถอดแล้ว';

  @override
  String catDetailAbout(String name) {
    return 'เกี่ยวกับ $name';
  }

  @override
  String get catDetailAppearanceDetails => 'รายละเอียดรูปลักษณ์';

  @override
  String get catDetailStatus => 'สถานะ';

  @override
  String get catDetailAdopted => 'รับเลี้ยงแล้ว';

  @override
  String get catDetailFurPattern => 'ลายขน';

  @override
  String get catDetailFurColor => 'สีขน';

  @override
  String get catDetailFurLength => 'ความยาวขน';

  @override
  String get catDetailEyes => 'ตา';

  @override
  String get catDetailWhitePatches => 'ลายขาว';

  @override
  String get catDetailPatchesTint => 'โทนสีลาย';

  @override
  String get catDetailTint => 'โทนสี';

  @override
  String get catDetailPoints => 'จุด';

  @override
  String get catDetailVitiligo => 'ด่างขาว';

  @override
  String get catDetailTortoiseshell => 'ลายกระ';

  @override
  String get catDetailTortiePattern => 'ลายทอร์ตี้';

  @override
  String get catDetailTortieColor => 'สีทอร์ตี้';

  @override
  String get catDetailSkin => 'ผิว';

  @override
  String get offlineMessage =>
      'คุณออฟไลน์อยู่ — การเปลี่ยนแปลงจะซิงค์เมื่อเชื่อมต่อ';

  @override
  String get offlineModeLabel => 'โหมดออฟไลน์';

  @override
  String habitTodayMinutes(int count) {
    return 'วันนี้: $count นาที';
  }

  @override
  String get habitDeleteTooltip => 'ลบนิสัย';

  @override
  String get heatmapActiveDays => 'วันที่ใช้งาน';

  @override
  String get heatmapTotal => 'ทั้งหมด';

  @override
  String get heatmapRate => 'อัตรา';

  @override
  String get heatmapLess => 'น้อย';

  @override
  String get heatmapMore => 'มาก';

  @override
  String get accessoryEquipped => 'สวมใส่อยู่';

  @override
  String get accessoryOwned => 'เป็นเจ้าของ';

  @override
  String get pickerMinUnit => 'นาที';

  @override
  String get settingsBackgroundAnimation => 'พื้นหลังเคลื่อนไหว';

  @override
  String get settingsBackgroundAnimationSubtitle => 'เมชเกรเดียนท์และอนุภาคลอย';

  @override
  String get settingsUiStyle => 'สไตล์ UI';

  @override
  String get settingsUiStyleMaterial => 'Material 3';

  @override
  String get settingsUiStyleRetroPixel => 'เรโทรพิกเซล';

  @override
  String get settingsUiStyleMaterialSubtitle =>
      'ดีไซน์ Material ทันสมัย โค้งมน';

  @override
  String get settingsUiStyleRetroPixelSubtitle => 'สุนทรียะพิกเซลอาร์ตอบอุ่น';

  @override
  String get personalityLazy => 'ขี้เกียจ';

  @override
  String get personalityCurious => 'ช่างสงสัย';

  @override
  String get personalityPlayful => 'ขี้เล่น';

  @override
  String get personalityShy => 'ขี้อาย';

  @override
  String get personalityBrave => 'กล้าหาญ';

  @override
  String get personalityClingy => 'ขี้ติด';

  @override
  String get personalityFlavorLazy =>
      'จะนอนวันละ 23 ชั่วโมง อีก 1 ชั่วโมง? ก็นอนเหมือนกัน';

  @override
  String get personalityFlavorCurious => 'เริ่มสูดดมทุกอย่างแล้ว!';

  @override
  String get personalityFlavorPlayful => 'หยุดไล่ผีเสื้อไม่ได้เลย!';

  @override
  String get personalityFlavorShy => 'ใช้เวลา 3 นาทีถึงจะโผล่จากกล่อง...';

  @override
  String get personalityFlavorBrave => 'กระโดดออกจากกล่องก่อนจะเปิดเสียอีก!';

  @override
  String get personalityFlavorClingy => 'เริ่มคลอเคลียทันทีและไม่ยอมปล่อย';

  @override
  String get moodHappy => 'มีความสุข';

  @override
  String get moodNeutral => 'ปกติ';

  @override
  String get moodLonely => 'เหงา';

  @override
  String get moodMissing => 'คิดถึง';

  @override
  String get moodMsgLazyHappy => 'เนี้ย~! ถึงเวลานอนพักผ่อนแล้ว...';

  @override
  String get moodMsgCuriousHappy => 'วันนี้จะสำรวจอะไรกัน?';

  @override
  String get moodMsgPlayfulHappy => 'เนี้ย~! พร้อมทำงาน!';

  @override
  String get moodMsgShyHappy => '...ดี-ดีใจที่คุณอยู่นี่';

  @override
  String get moodMsgBraveHappy => 'มาพิชิตวันนี้ด้วยกัน!';

  @override
  String get moodMsgClingyHappy => 'เย้! คุณกลับมาแล้ว! อย่าไปอีกนะ!';

  @override
  String get moodMsgLazyNeutral => '*หาว* อ้อ หวัดดี...';

  @override
  String get moodMsgCuriousNeutral => 'อืม นั่นอะไรตรงนั้น?';

  @override
  String get moodMsgPlayfulNeutral => 'เล่นกันไหม? ไว้ทีหลังดีกว่า...';

  @override
  String get moodMsgShyNeutral => '*ค่อยๆ โผล่ออกมา*';

  @override
  String get moodMsgBraveNeutral => 'ยืนเฝ้ายามเหมือนเดิม';

  @override
  String get moodMsgClingyNeutral => 'รอคุณอยู่นะ...';

  @override
  String get moodMsgLazyLonely => 'แม้แต่การนอนก็เหงา...';

  @override
  String get moodMsgCuriousLonely => 'สงสัยว่าคุณจะกลับมาเมื่อไหร่...';

  @override
  String get moodMsgPlayfulLonely => 'ของเล่นไม่สนุกถ้าไม่มีคุณ...';

  @override
  String get moodMsgShyLonely => '*นอนขดตัวเงียบๆ*';

  @override
  String get moodMsgBraveLonely => 'ฉันจะรอต่อไป ฉันกล้าหาญ';

  @override
  String get moodMsgClingyLonely => 'คุณไปไหน... 🥺';

  @override
  String get moodMsgLazyMissing => '*ลืมตาข้างเดียวด้วยความหวัง*';

  @override
  String get moodMsgCuriousMissing => 'มีอะไรเกิดขึ้นหรือเปล่า...?';

  @override
  String get moodMsgPlayfulMissing => 'ฉันเก็บของเล่นที่คุณชอบไว้ให้...';

  @override
  String get moodMsgShyMissing => '*ซ่อนอยู่ แต่จ้องมองประตู*';

  @override
  String get moodMsgBraveMissing => 'ฉันรู้ว่าคุณจะกลับมา ฉันเชื่อ';

  @override
  String get moodMsgClingyMissing => 'คิดถึงคุณมาก... กลับมานะ';

  @override
  String get peltTypeTabby => 'ลายแท็บบี้คลาสสิก';

  @override
  String get peltTypeTicked => 'ลายทิคอะกูตี';

  @override
  String get peltTypeMackerel => 'ลายแท็บบี้แมคเคอเรล';

  @override
  String get peltTypeClassic => 'ลายหมุนวนคลาสสิก';

  @override
  String get peltTypeSokoke => 'ลายหินอ่อนโซโกเก';

  @override
  String get peltTypeAgouti => 'ทิคอะกูตี';

  @override
  String get peltTypeSpeckled => 'ขนจุดกระ';

  @override
  String get peltTypeRosette => 'ลายจุดโรเซ็ตต์';

  @override
  String get peltTypeSingleColour => 'สีเดียว';

  @override
  String get peltTypeTwoColour => 'สองสี';

  @override
  String get peltTypeSmoke => 'สโมค';

  @override
  String get peltTypeSinglestripe => 'ลายเดี่ยว';

  @override
  String get peltTypeBengal => 'ลายเบงกอล';

  @override
  String get peltTypeMarbled => 'ลายหินอ่อน';

  @override
  String get peltTypeMasked => 'หน้ากาก';

  @override
  String get peltColorWhite => 'ขาว';

  @override
  String get peltColorPaleGrey => 'เทาอ่อน';

  @override
  String get peltColorSilver => 'เงิน';

  @override
  String get peltColorGrey => 'เทา';

  @override
  String get peltColorDarkGrey => 'เทาเข้ม';

  @override
  String get peltColorGhost => 'เทาผี';

  @override
  String get peltColorBlack => 'ดำ';

  @override
  String get peltColorCream => 'ครีม';

  @override
  String get peltColorPaleGinger => 'ขิงอ่อน';

  @override
  String get peltColorGolden => 'ทอง';

  @override
  String get peltColorGinger => 'ขิง';

  @override
  String get peltColorDarkGinger => 'ขิงเข้ม';

  @override
  String get peltColorSienna => 'เซียนน่า';

  @override
  String get peltColorLightBrown => 'น้ำตาลอ่อน';

  @override
  String get peltColorLilac => 'ไลแลค';

  @override
  String get peltColorBrown => 'น้ำตาล';

  @override
  String get peltColorGoldenBrown => 'น้ำตาลทอง';

  @override
  String get peltColorDarkBrown => 'น้ำตาลเข้ม';

  @override
  String get peltColorChocolate => 'ช็อกโกแลต';

  @override
  String get eyeColorYellow => 'เหลือง';

  @override
  String get eyeColorAmber => 'อำพัน';

  @override
  String get eyeColorHazel => 'เฮเซล';

  @override
  String get eyeColorPaleGreen => 'เขียวอ่อน';

  @override
  String get eyeColorGreen => 'เขียว';

  @override
  String get eyeColorBlue => 'น้ำเงิน';

  @override
  String get eyeColorDarkBlue => 'น้ำเงินเข้ม';

  @override
  String get eyeColorBlueYellow => 'น้ำเงิน-เหลือง';

  @override
  String get eyeColorBlueGreen => 'น้ำเงิน-เขียว';

  @override
  String get eyeColorGrey => 'เทา';

  @override
  String get eyeColorCyan => 'ฟ้า';

  @override
  String get eyeColorEmerald => 'มรกต';

  @override
  String get eyeColorHeatherBlue => 'น้ำเงินเฮเธอร์';

  @override
  String get eyeColorSunlitIce => 'น้ำแข็งแดดส่อง';

  @override
  String get eyeColorCopper => 'ทองแดง';

  @override
  String get eyeColorSage => 'เสจ';

  @override
  String get eyeColorCobalt => 'โคบอลต์';

  @override
  String get eyeColorPaleBlue => 'ฟ้าอ่อน';

  @override
  String get eyeColorBronze => 'บรอนซ์';

  @override
  String get eyeColorSilver => 'เงิน';

  @override
  String get eyeColorPaleYellow => 'เหลืองอ่อน';

  @override
  String eyeDescNormal(String color) {
    return 'ตาสี$color';
  }

  @override
  String eyeDescHeterochromia(String primary, String secondary) {
    return 'ตาสองสี ($primary / $secondary)';
  }

  @override
  String get skinColorPink => 'ชมพู';

  @override
  String get skinColorRed => 'แดง';

  @override
  String get skinColorBlack => 'ดำ';

  @override
  String get skinColorDark => 'เข้ม';

  @override
  String get skinColorDarkBrown => 'น้ำตาลเข้ม';

  @override
  String get skinColorBrown => 'น้ำตาล';

  @override
  String get skinColorLightBrown => 'น้ำตาลอ่อน';

  @override
  String get skinColorDarkGrey => 'เทาเข้ม';

  @override
  String get skinColorGrey => 'เทา';

  @override
  String get skinColorDarkSalmon => 'แซลมอนเข้ม';

  @override
  String get skinColorSalmon => 'แซลมอน';

  @override
  String get skinColorPeach => 'พีช';

  @override
  String get furLengthLonghair => 'ขนยาว';

  @override
  String get furLengthShorthair => 'ขนสั้น';

  @override
  String get whiteTintOffwhite => 'โทนออฟไวท์';

  @override
  String get whiteTintCream => 'โทนครีม';

  @override
  String get whiteTintDarkCream => 'โทนครีมเข้ม';

  @override
  String get whiteTintGray => 'โทนเทา';

  @override
  String get whiteTintPink => 'โทนชมพู';

  @override
  String notifReminderTitle(String catName) {
    return '$catName คิดถึงคุณ!';
  }

  @override
  String notifReminderBody(String habitName) {
    return 'ถึงเวลา $habitName แล้ว';
  }

  @override
  String notifStreakTitle(String catName) {
    return '$catName เป็นห่วง!';
  }

  @override
  String notifStreakBody(int streak) {
    return 'สตรีค $streak วันของคุณกำลังจะหาย เซสชันสั้นๆ จะช่วยรักษาได้!';
  }

  @override
  String notifEvolutionTitle(String catName) {
    return '$catName วิวัฒนาการแล้ว!';
  }

  @override
  String notifEvolutionBody(String catName, String stageName) {
    return '$catName เติบโตเป็น $stageName แล้ว!';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours ชม. $minutes น.';
  }

  @override
  String diaryScreenTitle(String name) {
    return 'ไดอารี่ $name';
  }

  @override
  String get diaryFailedToLoad => 'โหลดไดอารี่ไม่สำเร็จ';

  @override
  String get diaryEmptyTitle => 'ยังไม่มีไดอารี่';

  @override
  String get diaryEmptyHint =>
      'ทำเซสชันโฟกัสให้สำเร็จ แล้วแมวจะเขียนไดอารี่เรื่องแรก!';

  @override
  String get focusSetupCountdown => 'นับถอยหลัง';

  @override
  String get focusSetupStopwatch => 'นาฬิกาจับเวลา';

  @override
  String get focusSetupStartFocus => 'เริ่มโฟกัส';

  @override
  String get focusSetupQuestNotFound => 'ไม่พบเควสต์';

  @override
  String get checkInButtonLogMore => 'บันทึกเวลาเพิ่ม';

  @override
  String get checkInButtonStart => 'เริ่มตัวจับเวลา';

  @override
  String get adoptionTitleFirst => 'รับเลี้ยงแมวตัวแรก!';

  @override
  String get adoptionTitleNew => 'เควสต์ใหม่';

  @override
  String get adoptionStepDefineQuest => 'กำหนดเควสต์';

  @override
  String get adoptionStepAdoptCat2 => 'รับเลี้ยงแมว';

  @override
  String get adoptionStepNameCat2 => 'ตั้งชื่อแมว';

  @override
  String get adoptionAdopt => 'รับเลี้ยง!';

  @override
  String get adoptionQuestPrompt => 'คุณอยากเริ่มเควสต์อะไร?';

  @override
  String get adoptionKittenHint => 'ลูกแมวจะช่วยให้คุณไม่หลุดเป้า!';

  @override
  String get adoptionQuestName => 'ชื่อเควสต์';

  @override
  String get adoptionQuestHint => 'เช่น เตรียมคำถามสัมภาษณ์';

  @override
  String get adoptionTotalTarget => 'เป้าหมายรวม (ชั่วโมง)';

  @override
  String get adoptionGrowthHint => 'แมวจะเติบโตเมื่อคุณสะสมเวลาโฟกัส';

  @override
  String get adoptionCustom => 'กำหนดเอง';

  @override
  String get adoptionDailyGoalLabel => 'เป้าหมายโฟกัสรายวัน (นาที)';

  @override
  String get adoptionReminderLabel => 'แจ้งเตือนรายวัน (ไม่บังคับ)';

  @override
  String get adoptionReminderNone => 'ไม่มี';

  @override
  String get adoptionCustomGoalTitle => 'เป้าหมายรายวันกำหนดเอง';

  @override
  String get adoptionMinutesPerDay => 'นาทีต่อวัน';

  @override
  String get adoptionMinutesHint => '5 - 180';

  @override
  String get adoptionValidMinutes => 'กรอกค่าระหว่าง 5 ถึง 180';

  @override
  String get adoptionCustomTargetTitle => 'ชั่วโมงเป้าหมายกำหนดเอง';

  @override
  String get adoptionTotalHours => 'ชั่วโมงทั้งหมด';

  @override
  String get adoptionHoursHint => '10 - 2000';

  @override
  String get adoptionValidHours => 'กรอกค่าระหว่าง 10 ถึง 2000';

  @override
  String get adoptionSet => 'ตั้งค่า';

  @override
  String get adoptionChooseKitten => 'เลือกลูกแมวของคุณ!';

  @override
  String adoptionCompanionFor(String quest) {
    return 'เพื่อนร่วมทางสำหรับ \"$quest\"';
  }

  @override
  String get adoptionRerollAll => 'สุ่มใหม่ทั้งหมด';

  @override
  String get adoptionNameYourCat2 => 'ตั้งชื่อให้แมว';

  @override
  String get adoptionCatName => 'ชื่อแมว';

  @override
  String get adoptionCatHint => 'เช่น โมจิ';

  @override
  String get adoptionRandomTooltip => 'ชื่อสุ่ม';

  @override
  String adoptionGrowthTarget(String quest, int hours) {
    return 'แมวจะเติบโตเมื่อคุณโฟกัสทำ \"$quest\"! เป้าหมาย: $hours ชม.';
  }

  @override
  String get adoptionValidQuestName => 'กรุณากรอกชื่อเควสต์';

  @override
  String get adoptionValidCatName => 'กรุณาตั้งชื่อให้แมว';

  @override
  String adoptionError(String message) {
    return 'ข้อผิดพลาด: $message';
  }

  @override
  String get adoptionBasicInfo => 'ข้อมูลเบื้องต้น';

  @override
  String get adoptionGoals => 'เป้าหมาย';

  @override
  String get adoptionUnlimitedMode => 'โหมดไม่จำกัด';

  @override
  String get adoptionUnlimitedDesc => 'ไม่มีขีดจำกัด สะสมต่อไปเรื่อยๆ';

  @override
  String get adoptionMilestoneMode => 'โหมดไมล์สโตน';

  @override
  String get adoptionMilestoneDesc => 'ตั้งเป้าหมายให้ถึง';

  @override
  String get adoptionDeadlineLabel => 'กำหนดส่ง';

  @override
  String get adoptionDeadlineNone => 'ยังไม่ตั้ง';

  @override
  String get adoptionReminderSection => 'การแจ้งเตือน';

  @override
  String get adoptionMotivationLabel => 'โน้ต';

  @override
  String get adoptionMotivationHint => 'เขียนโน้ต...';

  @override
  String get adoptionMotivationSwap => 'สุ่มเติม';

  @override
  String get loginAppName => 'Hachimi';

  @override
  String get loginTagline => 'เลี้ยงแมว ทำเควสต์';

  @override
  String get loginContinueGoogle => 'ดำเนินการต่อด้วย Google';

  @override
  String get loginContinueEmail => 'ดำเนินการต่อด้วยอีเมล';

  @override
  String get loginAlreadyHaveAccount => 'มีบัญชีแล้ว? ';

  @override
  String get loginLogIn => 'เข้าสู่ระบบ';

  @override
  String get loginWelcomeBack => 'ยินดีต้อนรับกลับ!';

  @override
  String get loginCreateAccount => 'สร้างบัญชีของคุณ';

  @override
  String get loginEmail => 'อีเมล';

  @override
  String get loginPassword => 'รหัสผ่าน';

  @override
  String get loginConfirmPassword => 'ยืนยันรหัสผ่าน';

  @override
  String get loginValidEmail => 'กรุณากรอกอีเมล';

  @override
  String get loginValidEmailFormat => 'กรุณากรอกอีเมลที่ถูกต้อง';

  @override
  String get loginValidPassword => 'กรุณากรอกรหัสผ่าน';

  @override
  String get loginValidPasswordLength => 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';

  @override
  String get loginValidPasswordMatch => 'รหัสผ่านไม่ตรงกัน';

  @override
  String get loginCreateAccountButton => 'สร้างบัญชี';

  @override
  String get loginNoAccount => 'ยังไม่มีบัญชี? ';

  @override
  String get loginRegister => 'ลงทะเบียน';

  @override
  String get checkInTitle => 'เช็คอินรายเดือน';

  @override
  String get checkInDays => 'วัน';

  @override
  String get checkInCoinsEarned => 'เหรียญที่ได้';

  @override
  String get checkInAllMilestones => 'รับไมล์สโตนครบทุกอันแล้ว!';

  @override
  String checkInMilestoneProgress(int remaining, int bonus) {
    return 'อีก $remaining วัน → +$bonus เหรียญ';
  }

  @override
  String get checkInMilestones => 'ไมล์สโตน';

  @override
  String get checkInFullMonth => 'ครบเดือน';

  @override
  String get checkInRewardSchedule => 'ตารางรางวัล';

  @override
  String get checkInWeekday => 'วันธรรมดา (จ.–ศ.)';

  @override
  String checkInWeekdayReward(int coins) {
    return '$coins เหรียญ/วัน';
  }

  @override
  String get checkInWeekend => 'วันหยุด (ส.–อา.)';

  @override
  String checkInNDays(int count) {
    return '$count วัน';
  }

  @override
  String get onboardTitle1 => 'พบกับเพื่อนของคุณ';

  @override
  String get onboardSubtitle1 => 'ทุกเควสต์เริ่มจากลูกแมว';

  @override
  String get onboardBody1 =>
      'ตั้งเป้าหมายและรับเลี้ยงลูกแมว\nโฟกัส แล้วดูแมวเติบโต!';

  @override
  String get onboardTitle2 => 'โฟกัส เติบโต วิวัฒนาการ';

  @override
  String get onboardSubtitle2 => '4 ขั้นตอนการเติบโต';

  @override
  String get onboardBody2 =>
      'ทุกนาทีของการโฟกัสช่วยให้แมววิวัฒนาการ\nจากลูกแมวน้อยเป็นแมวอาวุโสสง่างาม!';

  @override
  String get onboardTitle3 => 'สร้างห้องแมว';

  @override
  String get onboardSubtitle3 => 'สะสมแมวที่ไม่ซ้ำกัน';

  @override
  String get onboardBody3 =>
      'ทุกเควสต์มาพร้อมแมวที่มีลุคเฉพาะตัว\nค้นพบทุกตัวและสร้างคอลเลกชันในฝัน!';

  @override
  String get onboardSkip => 'ข้าม';

  @override
  String get onboardLetsGo => 'เริ่มกันเลย!';

  @override
  String get onboardNext => 'ถัดไป';

  @override
  String get catRoomTitle => 'CatHouse';

  @override
  String get catRoomInventory => 'คลัง';

  @override
  String get catRoomShop => 'ร้านเครื่องประดับ';

  @override
  String get catRoomLoadError => 'โหลดแมวไม่สำเร็จ';

  @override
  String get catRoomEmptyTitle => 'CatHouse ของคุณว่างเปล่า';

  @override
  String get catRoomEmptySubtitle => 'เริ่มเควสต์เพื่อรับเลี้ยงแมวตัวแรก!';

  @override
  String get catRoomEditQuest => 'แก้ไขเควสต์';

  @override
  String get catRoomRenameCat => 'เปลี่ยนชื่อแมว';

  @override
  String get catRoomArchiveCat => 'เก็บแมวเข้าอัลบั้ม';

  @override
  String get catRoomNewName => 'ชื่อใหม่';

  @override
  String get catRoomRename => 'เปลี่ยนชื่อ';

  @override
  String get catRoomArchiveTitle => 'เก็บแมวเข้าอัลบั้ม?';

  @override
  String catRoomArchiveMessage(String name) {
    return 'การดำเนินการนี้จะเก็บ \"$name\" เข้าอัลบั้มและลบเควสต์ที่ผูกไว้ แมวจะยังปรากฏในอัลบั้ม';
  }

  @override
  String get catRoomArchive => 'เก็บเข้าอัลบั้ม';

  @override
  String catRoomAlbumSection(int count) {
    return 'อัลบั้ม ($count)';
  }

  @override
  String get catRoomReactivateCat => 'เปิดใช้แมวอีกครั้ง';

  @override
  String get catRoomReactivateTitle => 'เปิดใช้แมวอีกครั้ง?';

  @override
  String catRoomReactivateMessage(String name) {
    return 'การดำเนินการนี้จะนำ \"$name\" และเควสต์กลับมาที่ CatHouse';
  }

  @override
  String get catRoomReactivate => 'เปิดใช้อีกครั้ง';

  @override
  String get catRoomArchivedLabel => 'เก็บในอัลบั้ม';

  @override
  String catRoomArchiveSuccess(String name) {
    return 'เก็บ \"$name\" เข้าอัลบั้มแล้ว';
  }

  @override
  String catRoomReactivateSuccess(String name) {
    return 'เปิดใช้ \"$name\" อีกครั้งแล้ว';
  }

  @override
  String get addHabitTitle => 'เควสต์ใหม่';

  @override
  String get addHabitQuestName => 'ชื่อเควสต์';

  @override
  String get addHabitQuestHint => 'เช่น ฝึก LeetCode';

  @override
  String get addHabitValidName => 'กรุณากรอกชื่อเควสต์';

  @override
  String get addHabitTargetHours => 'ชั่วโมงเป้าหมาย';

  @override
  String get addHabitTargetHint => 'เช่น 100';

  @override
  String get addHabitValidTarget => 'กรุณากรอกชั่วโมงเป้าหมาย';

  @override
  String get addHabitValidNumber => 'กรุณากรอกตัวเลขที่ถูกต้อง';

  @override
  String get addHabitCreate => 'สร้างเควสต์';

  @override
  String get addHabitHoursSuffix => 'ชั่วโมง';

  @override
  String shopTabPlants(int count) {
    return 'ต้นไม้ ($count)';
  }

  @override
  String shopTabWild(int count) {
    return 'ป่า ($count)';
  }

  @override
  String shopTabCollars(int count) {
    return 'ปลอกคอ ($count)';
  }

  @override
  String get shopNoAccessories => 'ไม่มีเครื่องประดับ';

  @override
  String shopBuyConfirm(String name) {
    return 'ซื้อ $name?';
  }

  @override
  String get shopPurchaseButton => 'ซื้อ';

  @override
  String get shopNotEnoughCoinsButton => 'เหรียญไม่พอ';

  @override
  String shopPurchaseSuccess(String name) {
    return 'ซื้อแล้ว! เพิ่ม $name ลงคลังแล้ว';
  }

  @override
  String shopPurchaseFailed(int price) {
    return 'เหรียญไม่พอ (ต้องการ $price)';
  }

  @override
  String get inventoryTitle => 'คลัง';

  @override
  String inventoryInBox(int count) {
    return 'ในกล่อง ($count)';
  }

  @override
  String get inventoryEmpty => 'คลังว่างเปล่า\nไปร้านค้าเพื่อรับเครื่องประดับ!';

  @override
  String inventoryEquippedOnCats(int count) {
    return 'สวมใส่บนแมว ($count)';
  }

  @override
  String get inventoryNoEquipped => 'ไม่มีเครื่องประดับที่สวมใส่บนแมว';

  @override
  String get inventoryUnequip => 'ถอด';

  @override
  String get inventoryNoActiveCats => 'ไม่มีแมวที่ใช้งานอยู่';

  @override
  String inventoryEquipTo(String name) {
    return 'สวม $name ให้:';
  }

  @override
  String inventoryEquipSuccess(String name) {
    return 'สวม $name แล้ว';
  }

  @override
  String inventoryUnequipSuccess(String catName) {
    return 'ถอดจาก $catName แล้ว';
  }

  @override
  String get chatCatNotFound => 'ไม่พบแมว';

  @override
  String chatTitle(String name) {
    return 'แชทกับ $name';
  }

  @override
  String get chatClearHistory => 'ล้างประวัติ';

  @override
  String chatEmptyTitle(String name) {
    return 'ทักทาย $name!';
  }

  @override
  String get chatEmptySubtitle => 'เริ่มสนทนากับแมว พวกเขาจะตอบตามบุคลิก!';

  @override
  String get chatGenerating => 'กำลังสร้าง...';

  @override
  String get chatTypeMessage => 'พิมพ์ข้อความ...';

  @override
  String get chatClearConfirmTitle => 'ล้างประวัติแชท?';

  @override
  String get chatClearConfirmMessage => 'จะลบข้อความทั้งหมด ไม่สามารถยกเลิกได้';

  @override
  String get chatClearButton => 'ล้าง';

  @override
  String diaryTitle(String name) {
    return 'ไดอารี่ $name';
  }

  @override
  String get diaryLoadFailed => 'โหลดไดอารี่ไม่สำเร็จ';

  @override
  String get diaryRetry => 'ลองอีกครั้ง';

  @override
  String get diaryEmptyTitle2 => 'ยังไม่มีไดอารี่';

  @override
  String get diaryEmptySubtitle =>
      'ทำเซสชันโฟกัสให้สำเร็จ แล้วแมวจะเขียนไดอารี่เรื่องแรก!';

  @override
  String get statsTitle => 'สถิติ';

  @override
  String get statsTotalHours => 'ชั่วโมงรวม';

  @override
  String statsTimeValue(int hours, int minutes) {
    return '$hours ชม. $minutes น.';
  }

  @override
  String get statsBestStreak => 'สตรีคดีที่สุด';

  @override
  String statsStreakDays(int count) {
    return '$count วัน';
  }

  @override
  String get statsOverallProgress => 'ความก้าวหน้ารวม';

  @override
  String statsPercentOfGoals(String percent) {
    return '$percent% ของเป้าหมายทั้งหมด';
  }

  @override
  String get statsPerQuestProgress => 'ความก้าวหน้าแต่ละเควสต์';

  @override
  String get statsQuestLoadError => 'โหลดสถิติเควสต์ไม่สำเร็จ';

  @override
  String get statsNoQuestData => 'ยังไม่มีข้อมูลเควสต์';

  @override
  String get statsNoQuestHint => 'เริ่มเควสต์เพื่อดูความก้าวหน้า!';

  @override
  String get statsLast30Days => '30 วันล่าสุด';

  @override
  String get habitDetailQuestNotFound => 'ไม่พบเควสต์';

  @override
  String get habitDetailComplete => 'สำเร็จ';

  @override
  String get habitDetailTotalTime => 'เวลาทั้งหมด';

  @override
  String get habitDetailCurrentStreak => 'สตรีคปัจจุบัน';

  @override
  String get habitDetailTarget => 'เป้าหมาย';

  @override
  String habitDetailDaysUnit(int count) {
    return '$count วัน';
  }

  @override
  String habitDetailHoursUnit(int count) {
    return '$count ชั่วโมง';
  }

  @override
  String checkInBannerSuccess(int coins) {
    return '+$coins เหรียญ! เช็คอินรายวันสำเร็จ';
  }

  @override
  String checkInBannerBonus(int bonus) {
    return ' + $bonus โบนัสไมล์สโตน!';
  }

  @override
  String get checkInBannerSemantics => 'เช็คอินรายวัน';

  @override
  String get checkInBannerLoading => 'กำลังโหลดสถานะเช็คอิน...';

  @override
  String checkInBannerPrompt(int coins) {
    return 'เช็คอินรับ +$coins เหรียญ';
  }

  @override
  String checkInBannerSummary(int count, int total, int coins) {
    return '$count/$total วัน  ·  วันนี้ +$coins';
  }

  @override
  String commonErrorWithDetail(String error) {
    return 'ข้อผิดพลาด: $error';
  }

  @override
  String get profileFallbackUser => 'ผู้ใช้';

  @override
  String get fallbackCatName => 'แมว';

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
  String get notifFocusing => 'กำลังโฟกัส...';

  @override
  String get notifInProgress => 'เซสชันโฟกัสกำลังดำเนินอยู่';

  @override
  String get unitMinShort => 'น.';

  @override
  String get unitHourShort => 'ชม.';

  @override
  String get weekdayMon => 'จ';

  @override
  String get weekdayTue => 'อ';

  @override
  String get weekdayWed => 'พ';

  @override
  String get weekdayThu => 'พฤ';

  @override
  String get weekdayFri => 'ศ';

  @override
  String get weekdaySat => 'ส';

  @override
  String get weekdaySun => 'อา';

  @override
  String get statsTotalSessions => 'เซสชัน';

  @override
  String get statsTotalHabits => 'นิสัย';

  @override
  String get statsActiveDays => 'วันที่ใช้งาน';

  @override
  String get statsWeeklyTrend => 'แนวโน้มรายสัปดาห์';

  @override
  String get statsRecentSessions => 'โฟกัสล่าสุด';

  @override
  String get statsViewAllHistory => 'ดูประวัติทั้งหมด';

  @override
  String get historyTitle => 'ประวัติโฟกัส';

  @override
  String get historyFilterAll => 'ทั้งหมด';

  @override
  String historySessionCount(int count) {
    return '$count เซสชัน';
  }

  @override
  String historyTotalMinutes(int minutes) {
    return '$minutes นาที';
  }

  @override
  String get historyNoSessions => 'ยังไม่มีบันทึกโฟกัส';

  @override
  String get historyNoSessionsHint => 'ทำเซสชันโฟกัสให้สำเร็จเพื่อดูที่นี่';

  @override
  String get historyLoadMore => 'โหลดเพิ่ม';

  @override
  String get sessionCompleted => 'สำเร็จ';

  @override
  String get sessionAbandoned => 'ยกเลิก';

  @override
  String get sessionInterrupted => 'ถูกขัดจังหวะ';

  @override
  String get sessionCountdown => 'นับถอยหลัง';

  @override
  String get sessionStopwatch => 'นาฬิกาจับเวลา';

  @override
  String get historyDateGroupToday => 'วันนี้';

  @override
  String get historyDateGroupYesterday => 'เมื่อวาน';

  @override
  String get historyLoadError => 'โหลดประวัติไม่สำเร็จ';

  @override
  String get historySelectMonth => 'เลือกเดือน';

  @override
  String get historyAllMonths => 'ทุกเดือน';

  @override
  String get historyAllHabits => 'ทั้งหมด';

  @override
  String get homeTabAchievements => 'ความสำเร็จ';

  @override
  String get achievementTitle => 'ความสำเร็จ';

  @override
  String get achievementTabOverview => 'ภาพรวม';

  @override
  String get achievementTabQuest => 'เควสต์';

  @override
  String get achievementTabStreak => 'สตรีค';

  @override
  String get achievementTabCat => 'แมว';

  @override
  String get achievementTabPersist => 'ความพากเพียร';

  @override
  String get achievementSummaryTitle => 'ความก้าวหน้าความสำเร็จ';

  @override
  String achievementUnlockedCount(int count) {
    return 'ปลดล็อก $count รายการ';
  }

  @override
  String achievementTotalCoins(int coins) {
    return 'ได้ $coins เหรียญ';
  }

  @override
  String get achievementUnlocked => 'ปลดล็อกความสำเร็จ!';

  @override
  String get achievementAwesome => 'เยี่ยมเลย!';

  @override
  String get achievementIncredible => 'เหลือเชื่อ!';

  @override
  String get achievementHidden => '???';

  @override
  String get achievementHiddenDesc => 'นี่คือความสำเร็จที่ซ่อนอยู่';

  @override
  String achievementPersistDesc(int days) {
    return 'สะสมวันเช็คอิน $days วันบนเควสต์ใดก็ได้';
  }

  @override
  String achievementTitleCount(int count) {
    return 'ปลดล็อก $count ตำแหน่ง';
  }

  @override
  String get growthPathTitle => 'เส้นทางเติบโต';

  @override
  String get growthPathKitten => 'เริ่มต้นเส้นทางใหม่';

  @override
  String get growthPathAdolescent => 'สร้างพื้นฐานเบื้องต้น';

  @override
  String get growthPathAdult => 'ทักษะแข็งแกร่งขึ้น';

  @override
  String get growthPathSenior => 'เชี่ยวชาญเชิงลึก';

  @override
  String get growthPathTip =>
      'งานวิจัยบอกว่าการฝึกฝนอย่างตั้งใจ 20 ชั่วโมงเพียงพอที่จะสร้างพื้นฐานทักษะใหม่ — Josh Kaufman';

  @override
  String achievementCelebrationCoins(int count) {
    return '+$count เหรียญ';
  }

  @override
  String achievementCelebrationTitle(String title) {
    return 'ได้ตำแหน่ง: $title';
  }

  @override
  String get achievementCelebrationDismiss => 'เยี่ยม!';

  @override
  String get achievementCelebrationSkipAll => 'ข้ามทั้งหมด';

  @override
  String achievementCelebrationCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String achievementUnlockedAt(String date) {
    return 'ปลดล็อกเมื่อ $date';
  }

  @override
  String get achievementLocked => 'ยังไม่ปลดล็อก';

  @override
  String achievementRewardCoins(int count) {
    return '+$count เหรียญ';
  }

  @override
  String get reminderModeDaily => 'ทุกวัน';

  @override
  String get reminderModeWeekdays => 'วันธรรมดา';

  @override
  String get reminderModeMonday => 'วันจันทร์';

  @override
  String get reminderModeTuesday => 'วันอังคาร';

  @override
  String get reminderModeWednesday => 'วันพุธ';

  @override
  String get reminderModeThursday => 'วันพฤหัสบดี';

  @override
  String get reminderModeFriday => 'วันศุกร์';

  @override
  String get reminderModeSaturday => 'วันเสาร์';

  @override
  String get reminderModeSunday => 'วันอาทิตย์';

  @override
  String get reminderPickerTitle => 'เลือกเวลาแจ้งเตือน';

  @override
  String get reminderHourUnit => 'ชม.';

  @override
  String get reminderMinuteUnit => 'น.';

  @override
  String get reminderAddMore => 'เพิ่มการแจ้งเตือน';

  @override
  String get reminderMaxReached => 'ได้สูงสุด 5 รายการ';

  @override
  String get reminderConfirm => 'ยืนยัน';

  @override
  String reminderNotificationTitle(String catName) {
    return '$catName คิดถึงคุณ!';
  }

  @override
  String reminderNotificationBody(String habitName) {
    return 'ถึงเวลา $habitName แล้ว — แมวกำลังรอคุณอยู่!';
  }

  @override
  String get deleteAccountDataWarning =>
      'ข้อมูลต่อไปนี้ทั้งหมดจะถูกลบอย่างถาวร:';

  @override
  String get deleteAccountQuests => 'เควสต์';

  @override
  String get deleteAccountCats => 'แมว';

  @override
  String get deleteAccountHours => 'ชั่วโมงโฟกัส';

  @override
  String get deleteAccountIrreversible => 'ไม่สามารถยกเลิกการดำเนินการนี้ได้';

  @override
  String get deleteAccountContinue => 'ดำเนินการต่อ';

  @override
  String get deleteAccountConfirmTitle => 'ยืนยันการลบ';

  @override
  String get deleteAccountTypeDelete => 'พิมพ์ DELETE เพื่อยืนยันการลบบัญชี:';

  @override
  String get deleteAccountAuthCancelled => 'การยืนยันตัวตนถูกยกเลิก';

  @override
  String deleteAccountAuthFailed(String error) {
    return 'การยืนยันตัวตนล้มเหลว: $error';
  }

  @override
  String get deleteAccountProgress => 'กำลังลบบัญชี...';

  @override
  String get deleteAccountSuccess => 'ลบบัญชีแล้ว';

  @override
  String get drawerGuestLoginSubtitle => 'ซิงค์ข้อมูลและปลดล็อกฟีเจอร์ AI';

  @override
  String get drawerGuestSignIn => 'เข้าสู่ระบบ';

  @override
  String get drawerMilestones => 'ไมล์สโตน';

  @override
  String drawerMilestoneFocus(int hours, int minutes) {
    return 'โฟกัสรวม: $hours ชม. $minutes น.';
  }

  @override
  String drawerMilestoneCats(int count) {
    return 'ครอบครัวแมว: $count';
  }

  @override
  String drawerMilestoneQuests(int count) {
    return 'เควสต์ที่ใช้งาน: $count';
  }

  @override
  String get drawerMySection => 'ของฉัน';

  @override
  String get drawerSessionHistory => 'ประวัติโฟกัส';

  @override
  String get drawerCheckInCalendar => 'ปฏิทินเช็คอิน';

  @override
  String get drawerAccountSection => 'บัญชี';

  @override
  String get settingsResetData => 'รีเซ็ตข้อมูลทั้งหมด';

  @override
  String get settingsResetDataTitle => 'รีเซ็ตข้อมูลทั้งหมด?';

  @override
  String get settingsResetDataMessage =>
      'จะลบข้อมูลในเครื่องทั้งหมดและกลับไปหน้าต้อนรับ ไม่สามารถยกเลิกได้';

  @override
  String get guestUpgradeTitle => 'ปกป้องข้อมูลของคุณ';

  @override
  String get guestUpgradeMessage =>
      'เชื่อมต่อบัญชีเพื่อสำรองความก้าวหน้า ปลดล็อกไดอารี่และแชท AI และซิงค์ข้ามอุปกรณ์';

  @override
  String get guestUpgradeLinkButton => 'เชื่อมต่อบัญชี';

  @override
  String get guestUpgradeLater => 'ไว้ทีหลัง';

  @override
  String get loginLinkTagline => 'เชื่อมต่อบัญชีเพื่อปกป้องข้อมูลของคุณ';

  @override
  String get aiTeaserTitle => 'ไดอารี่แมว';

  @override
  String aiTeaserPreview(String catName) {
    return 'วันนี้ฉันเรียนกับมนุษย์อีกแล้ว... $catName รู้สึกฉลาดขึ้นทุกวัน~';
  }

  @override
  String aiTeaserCta(String catName) {
    return 'เชื่อมต่อบัญชีเพื่อดูว่า $catName อยากบอกอะไร';
  }

  @override
  String get authErrorEmailInUse => 'อีเมลนี้ถูกลงทะเบียนแล้ว';

  @override
  String get authErrorWrongPassword => 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';

  @override
  String get authErrorUserNotFound => 'ไม่พบบัญชีที่ใช้อีเมลนี้';

  @override
  String get authErrorTooManyRequests =>
      'ลองหลายครั้งเกินไป ลองอีกครั้งในภายหลัง';

  @override
  String get authErrorNetwork => 'ข้อผิดพลาดเครือข่าย ตรวจสอบการเชื่อมต่อ';

  @override
  String get authErrorAdminRestricted => 'การเข้าสู่ระบบถูกจำกัดชั่วคราว';

  @override
  String get authErrorWeakPassword =>
      'รหัสผ่านอ่อนแอเกินไป ใช้อย่างน้อย 6 ตัวอักษร';

  @override
  String get authErrorGeneric => 'เกิดข้อผิดพลาด ลองอีกครั้ง';

  @override
  String get deleteAccountReauthEmail => 'กรอกรหัสผ่านเพื่อดำเนินการต่อ';

  @override
  String get deleteAccountReauthPasswordHint => 'รหัสผ่าน';

  @override
  String get deleteAccountError => 'เกิดข้อผิดพลาด ลองอีกครั้งในภายหลัง';

  @override
  String get deleteAccountPermissionError =>
      'ข้อผิดพลาดสิทธิ์ ลองออกจากระบบแล้วเข้าสู่ระบบอีกครั้ง';

  @override
  String get deleteAccountNetworkError => 'ไม่มีอินเทอร์เน็ต ตรวจสอบเครือข่าย';

  @override
  String get deleteAccountRetainedData =>
      'ข้อมูลการวิเคราะห์และรายงานข้อผิดพลาดไม่สามารถลบได้';

  @override
  String get deleteAccountStepCloud => 'กำลังลบข้อมูลคลาวด์...';

  @override
  String get deleteAccountStepLocal => 'กำลังล้างข้อมูลในเครื่อง...';

  @override
  String get deleteAccountStepDone => 'เสร็จสิ้น';

  @override
  String get deleteAccountQueued =>
      'ลบข้อมูลในเครื่องแล้ว การลบบัญชีคลาวด์อยู่ในคิวและจะเสร็จเมื่อออนไลน์';

  @override
  String get deleteAccountPending =>
      'การลบบัญชีรอดำเนินการ เปิดแอปให้ออนไลน์เพื่อลบคลาวด์และการยืนยันตัวตน';

  @override
  String get deleteAccountAbandon => 'เริ่มต้นใหม่';

  @override
  String get archiveConflictTitle => 'เลือกอัลบั้มที่จะเก็บ';

  @override
  String get archiveConflictMessage =>
      'อัลบั้มในเครื่องและคลาวด์มีข้อมูลทั้งคู่ เลือกที่จะเก็บ:';

  @override
  String get archiveConflictLocal => 'อัลบั้มในเครื่อง';

  @override
  String get archiveConflictCloud => 'อัลบั้มคลาวด์';

  @override
  String get archiveConflictKeepCloud => 'เก็บคลาวด์';

  @override
  String get archiveConflictKeepLocal => 'เก็บในเครื่อง';

  @override
  String get loginShowPassword => 'แสดงรหัสผ่าน';

  @override
  String get loginHidePassword => 'ซ่อนรหัสผ่าน';

  @override
  String get errorGeneric => 'เกิดข้อผิดพลาด ลองอีกครั้งในภายหลัง';

  @override
  String get errorCreateHabit => 'สร้างนิสัยไม่สำเร็จ ลองอีกครั้ง';
}
