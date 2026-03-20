// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class SKo extends S {
  SKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '하치미 - Light Up My Innerverse';

  @override
  String get homeTabToday => '오늘';

  @override
  String get homeTabCatHouse => '고양이 집';

  @override
  String get homeTabStats => '통계';

  @override
  String get homeTabProfile => '프로필';

  @override
  String get adoptionStepDefineHabit => '습관 설정';

  @override
  String get adoptionStepAdoptCat => '고양이 입양';

  @override
  String get adoptionStepNameCat => '이름 짓기';

  @override
  String get adoptionHabitName => '습관 이름';

  @override
  String get adoptionHabitNameHint => '예: 매일 독서';

  @override
  String get adoptionDailyGoal => '일일 목표';

  @override
  String get adoptionTargetHours => '목표 시간';

  @override
  String get adoptionTargetHoursHint => '이 습관을 완료하기 위한 총 시간';

  @override
  String adoptionMinutes(int count) {
    return '$count분';
  }

  @override
  String get adoptionRefreshCat => '다른 고양이';

  @override
  String adoptionPersonality(String name) {
    return '성격: $name';
  }

  @override
  String get adoptionNameYourCat => '고양이 이름을 지어주세요';

  @override
  String get adoptionRandomName => '랜덤';

  @override
  String get adoptionCreate => '습관 만들기 & 입양';

  @override
  String get adoptionNext => '다음';

  @override
  String get adoptionBack => '뒤로';

  @override
  String get adoptionCatNameLabel => '고양이 이름';

  @override
  String get adoptionCatNameHint => '예: 모찌';

  @override
  String get adoptionRandomNameTooltip => '랜덤 이름';

  @override
  String get catHouseTitle => '고양이 집';

  @override
  String get catHouseEmpty => '아직 고양이가 없어요! 습관을 만들어 첫 고양이를 입양해 보세요.';

  @override
  String catHouseGrowth(int minutes, int target) {
    return '$minutes / $target분';
  }

  @override
  String get catDetailGrowthProgress => '성장 진행도';

  @override
  String catDetailTotalMinutes(int minutes) {
    return '$minutes분 집중함';
  }

  @override
  String catDetailTargetMinutes(int minutes) {
    return '목표: $minutes분';
  }

  @override
  String get catDetailRename => '이름 변경';

  @override
  String get catDetailAccessories => '액세서리';

  @override
  String get catDetailStartFocus => '집중 시작';

  @override
  String get catDetailBoundHabit => '연결된 습관';

  @override
  String catDetailStage(String stage) {
    return '단계: $stage';
  }

  @override
  String coinBalance(int amount) {
    return '$amount 코인';
  }

  @override
  String coinCheckInReward(int amount) {
    return '+$amount 코인!';
  }

  @override
  String get coinCheckInTitle => '일일 출석';

  @override
  String get coinInsufficientBalance => '코인이 부족해요';

  @override
  String get shopTitle => '액세서리 상점';

  @override
  String shopPrice(int price) {
    return '$price 코인';
  }

  @override
  String get shopPurchase => '구매';

  @override
  String get shopEquipped => '장착 중';

  @override
  String focusCompleteMinutes(int minutes) {
    return '+$minutes분';
  }

  @override
  String get focusCompleteStageUp => '단계 업!';

  @override
  String get focusCompleteGreatJob => '잘했어요!';

  @override
  String get focusCompleteDone => '완료';

  @override
  String get focusCompleteItsOkay => '괜찮아요!';

  @override
  String focusCompleteEvolved(String catName) {
    return '$catName이(가) 진화했어요!';
  }

  @override
  String focusCompleteFocusedFor(int minutes) {
    return '$minutes분 동안 집중했어요';
  }

  @override
  String focusCompleteAbandonedMessage(String catName) {
    return '$catName이(가) 말해요: \"다음에 다시 해보자!\"';
  }

  @override
  String get focusCompleteFocusTime => '집중 시간';

  @override
  String get focusCompleteCoinsEarned => '획득한 코인';

  @override
  String get focusCompleteBaseXp => '기본 XP';

  @override
  String get focusCompleteStreakBonus => '연속 보너스';

  @override
  String get focusCompleteMilestoneBonus => '마일스톤 보너스';

  @override
  String get focusCompleteFullHouseBonus => '풀하우스 보너스';

  @override
  String get focusCompleteTotal => '합계';

  @override
  String focusCompleteEvolvedTo(String stage) {
    return '$stage(으)로 진화했어요!';
  }

  @override
  String get focusCompleteYourCat => '내 고양이';

  @override
  String get focusCompleteDiaryWriting => '일기 작성 중...';

  @override
  String get focusCompleteDiaryWritten => '일기 작성 완료!';

  @override
  String get focusCompleteDiarySkipped => '일기 건너뜀';

  @override
  String get focusCompleteNotifTitle => '퀘스트 완료!';

  @override
  String focusCompleteNotifBody(String catName, int xp, int minutes) {
    return '$catName이(가) $minutes분 집중으로 +$xp XP를 획득했어요';
  }

  @override
  String get stageKitten => '아기 고양이';

  @override
  String get stageAdolescent => '청소년';

  @override
  String get stageAdult => '성인';

  @override
  String get stageSenior => '노년';

  @override
  String get migrationTitle => '데이터 업데이트 필요';

  @override
  String get migrationMessage =>
      '하치미가 새로운 픽셀 고양이 시스템으로 업데이트되었어요! 기존 고양이 데이터는 더 이상 호환되지 않아요. 초기화하여 새로운 경험을 시작해 주세요.';

  @override
  String get migrationResetButton => '초기화 & 새로 시작';

  @override
  String get sessionResumeTitle => '세션을 이어할까요?';

  @override
  String sessionResumeMessage(String habitName, String elapsed) {
    return '진행 중인 집중 세션이 있어요 ($habitName, $elapsed). 이어할까요?';
  }

  @override
  String get sessionResumeButton => '이어하기';

  @override
  String get sessionDiscard => '취소';

  @override
  String get todaySummaryMinutes => '오늘';

  @override
  String get todaySummaryTotal => '전체';

  @override
  String get todaySummaryCats => '고양이';

  @override
  String get todayYourQuests => '내 퀘스트';

  @override
  String get todayNoQuests => '아직 퀘스트가 없어요';

  @override
  String get todayNoQuestsHint => '+ 를 눌러 퀘스트를 시작하고 고양이를 입양해 보세요!';

  @override
  String get todayFocus => '집중';

  @override
  String get todayDeleteQuestTitle => '퀘스트를 삭제할까요?';

  @override
  String todayDeleteQuestMessage(String name) {
    return '\"$name\"을(를) 삭제하시겠어요? 고양이는 앨범으로 이동해요.';
  }

  @override
  String todayQuestCompleted(String name) {
    return '$name 완료';
  }

  @override
  String get todayFailedToLoad => '퀘스트를 불러오지 못했어요';

  @override
  String todayMinToday(int count) {
    return '오늘 $count분';
  }

  @override
  String todayGoalMinPerDay(int count) {
    return '목표: $count분/일';
  }

  @override
  String get todayFeaturedCat => '오늘의 고양이';

  @override
  String get todayAddHabit => '습관 추가';

  @override
  String get todayNoHabits => '첫 번째 습관을 만들어 시작해 보세요!';

  @override
  String get todayNewQuest => '새 퀘스트';

  @override
  String get todayStartFocus => '집중 시작';

  @override
  String get timerStart => '시작';

  @override
  String get timerPause => '일시정지';

  @override
  String get timerResume => '이어하기';

  @override
  String get timerDone => '완료';

  @override
  String get timerGiveUp => '포기';

  @override
  String get timerRemaining => '남음';

  @override
  String get timerElapsed => '경과';

  @override
  String get timerPaused => '일시정지됨';

  @override
  String get timerQuestNotFound => '퀘스트를 찾을 수 없어요';

  @override
  String get timerNotificationBanner =>
      '앱이 백그라운드에 있을 때 타이머 진행 상황을 보려면 알림을 켜주세요';

  @override
  String get timerNotificationDismiss => '닫기';

  @override
  String get timerNotificationEnable => '켜기';

  @override
  String timerGraceBack(int seconds) {
    return '돌아가기 ($seconds초)';
  }

  @override
  String get giveUpTitle => '포기할까요?';

  @override
  String get giveUpMessage => '5분 이상 집중했다면, 그 시간은 고양이 성장에 반영돼요. 고양이가 이해할 거예요!';

  @override
  String get giveUpKeepGoing => '계속하기';

  @override
  String get giveUpConfirm => '포기';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsGeneral => '일반';

  @override
  String get settingsAppearance => '외관';

  @override
  String get settingsNotifications => '알림';

  @override
  String get settingsNotificationFocusReminders => '집중 알림';

  @override
  String get settingsNotificationSubtitle => '매일 알림을 받아 꾸준히 진행해 보세요';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsLanguageSystem => '시스템 기본값';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageChinese => '中文';

  @override
  String get settingsThemeMode => '테마 모드';

  @override
  String get settingsThemeModeSystem => '시스템';

  @override
  String get settingsThemeModeLight => '밝게';

  @override
  String get settingsThemeModeDark => '어둡게';

  @override
  String get settingsThemeColor => '테마 색상';

  @override
  String get settingsThemeColorDynamic => '다이내믹';

  @override
  String get settingsThemeColorDynamicSubtitle => '배경화면 색상 사용';

  @override
  String get settingsAbout => '정보';

  @override
  String get settingsVersion => '버전';

  @override
  String get settingsLicenses => '라이선스';

  @override
  String get settingsAccount => '계정';

  @override
  String get logoutTitle => '로그아웃할까요?';

  @override
  String get logoutMessage => '정말 로그아웃하시겠어요?';

  @override
  String get loggingOut => '로그아웃 중...';

  @override
  String get deleteAccountTitle => '계정을 삭제할까요?';

  @override
  String get deleteAccountMessage => '계정과 모든 데이터가 영구적으로 삭제돼요. 이 작업은 되돌릴 수 없어요.';

  @override
  String get deleteAccountWarning => '이 작업은 되돌릴 수 없어요';

  @override
  String get profileTitle => '프로필';

  @override
  String get profileYourJourney => '나의 여정';

  @override
  String get profileTotalFocus => '총 집중 시간';

  @override
  String get profileTotalCats => '총 고양이 수';

  @override
  String get profileTotalQuests => '퀘스트';

  @override
  String get profileEditName => '이름 변경';

  @override
  String get profileDisplayName => '표시 이름';

  @override
  String get profileChooseAvatar => '아바타 선택';

  @override
  String get profileSaved => '저장되었습니다';

  @override
  String get profileSettings => '설정';

  @override
  String get habitDetailStreak => '연속';

  @override
  String get habitDetailBestStreak => '최고';

  @override
  String get habitDetailTotalMinutes => '전체';

  @override
  String get commonCancel => '취소';

  @override
  String get commonConfirm => '확인';

  @override
  String get commonSave => '저장';

  @override
  String get commonDelete => '삭제';

  @override
  String get commonEdit => '편집';

  @override
  String get commonDone => '완료';

  @override
  String get commonDismiss => '닫기';

  @override
  String get commonEnable => '켜기';

  @override
  String get commonLoading => '불러오는 중...';

  @override
  String get commonError => '문제가 발생했어요';

  @override
  String get commonRetry => '다시 시도';

  @override
  String get commonResume => '이어하기';

  @override
  String get commonPause => '일시정지';

  @override
  String get commonLogOut => '로그아웃';

  @override
  String get commonDeleteAccount => '계정 삭제';

  @override
  String get commonYes => '네';

  @override
  String chatDailyRemaining(int count) {
    return '오늘 $count개의 메시지를 더 보낼 수 있어요';
  }

  @override
  String get chatDailyLimitReached => '오늘의 메시지 한도에 도달했어요';

  @override
  String get aiTemporarilyUnavailable => 'AI 기능을 일시적으로 사용할 수 없어요';

  @override
  String get catDetailNotFound => '고양이를 찾을 수 없어요';

  @override
  String get catDetailLoadError => '고양이 데이터를 불러오지 못했어요';

  @override
  String get catDetailChatTooltip => '채팅';

  @override
  String get catDetailRenameTooltip => '이름 변경';

  @override
  String get catDetailGrowthTitle => '성장 진행도';

  @override
  String catDetailTarget(int hours) {
    return '목표: $hours시간';
  }

  @override
  String get catDetailRenameTitle => '고양이 이름 변경';

  @override
  String get catDetailNewName => '새 이름';

  @override
  String get catDetailRenamed => '이름이 변경되었어요!';

  @override
  String get catDetailQuestBadge => '퀘스트';

  @override
  String get catDetailEditQuest => '퀘스트 편집';

  @override
  String get catDetailDailyGoal => '일일 목표';

  @override
  String get catDetailTodaysFocus => '오늘의 집중';

  @override
  String get catDetailTotalFocus => '총 집중 시간';

  @override
  String get catDetailTargetLabel => '목표';

  @override
  String get catDetailCompletion => '달성률';

  @override
  String get catDetailCurrentStreak => '현재 연속 기록';

  @override
  String get catDetailBestStreakLabel => '최고 연속 기록';

  @override
  String get catDetailAvgDaily => '일 평균';

  @override
  String get catDetailDaysActive => '활동 일수';

  @override
  String get catDetailCheckInDays => '체크인 일수';

  @override
  String get catDetailEditQuestTitle => '퀘스트 편집';

  @override
  String get catDetailQuestName => '퀘스트 이름';

  @override
  String get catDetailDailyGoalMinutes => '일일 목표 (분)';

  @override
  String get catDetailTargetTotalHours => '총 목표 (시간)';

  @override
  String get catDetailQuestUpdated => '퀘스트가 업데이트되었어요!';

  @override
  String get catDetailTargetCompletedHint => '목표 달성 완료, 무제한 모드로 전환됨';

  @override
  String get catDetailDailyReminder => '일일 알림';

  @override
  String catDetailEveryDay(String time) {
    return '매일 $time';
  }

  @override
  String get catDetailNoReminder => '알림이 설정되지 않았어요';

  @override
  String get catDetailChange => '변경';

  @override
  String get catDetailRemoveReminder => '알림 제거';

  @override
  String get catDetailSet => '설정';

  @override
  String catDetailReminderSet(String time) {
    return '$time에 알림이 설정되었어요';
  }

  @override
  String get catDetailReminderRemoved => '알림이 제거되었어요';

  @override
  String get catDetailDiaryTitle => '하치미 일기';

  @override
  String get catDetailDiaryLoading => '불러오는 중...';

  @override
  String get catDetailDiaryError => '일기를 불러올 수 없어요';

  @override
  String get catDetailDiaryEmpty => '아직 오늘의 일기가 없어요. 집중 세션을 완료해 보세요!';

  @override
  String catDetailChatWith(String name) {
    return '$name와(과) 채팅';
  }

  @override
  String get catDetailChatSubtitle => '고양이와 대화해 보세요';

  @override
  String get catDetailActivity => '활동';

  @override
  String get catDetailActivityError => '활동 데이터를 불러오지 못했어요';

  @override
  String get catDetailAccessoriesTitle => '액세서리';

  @override
  String get catDetailEquipped => '장착 중: ';

  @override
  String get catDetailNone => '없음';

  @override
  String get catDetailUnequip => '해제';

  @override
  String catDetailFromInventory(int count) {
    return '보관함에서 ($count)';
  }

  @override
  String get catDetailNoAccessories => '아직 액세서리가 없어요. 상점을 방문해 보세요!';

  @override
  String catDetailEquippedItem(String name) {
    return '$name 장착 완료';
  }

  @override
  String get catDetailUnequipped => '장착 해제됨';

  @override
  String catDetailAbout(String name) {
    return '$name 정보';
  }

  @override
  String get catDetailAppearanceDetails => '외형 정보';

  @override
  String get catDetailStatus => '상태';

  @override
  String get catDetailAdopted => '입양됨';

  @override
  String get catDetailFurPattern => '털 무늬';

  @override
  String get catDetailFurColor => '털 색상';

  @override
  String get catDetailFurLength => '털 길이';

  @override
  String get catDetailEyes => '눈';

  @override
  String get catDetailWhitePatches => '흰 무늬';

  @override
  String get catDetailPatchesTint => '무늬 색조';

  @override
  String get catDetailTint => '색조';

  @override
  String get catDetailPoints => '포인트';

  @override
  String get catDetailVitiligo => '백반증';

  @override
  String get catDetailTortoiseshell => '삼색';

  @override
  String get catDetailTortiePattern => '삼색 무늬';

  @override
  String get catDetailTortieColor => '삼색 색상';

  @override
  String get catDetailSkin => '피부';

  @override
  String get offlineMessage => '오프라인 상태예요 — 다시 연결되면 변경 사항이 동기화돼요';

  @override
  String get offlineModeLabel => '오프라인 모드';

  @override
  String habitTodayMinutes(int count) {
    return '오늘: $count분';
  }

  @override
  String get habitDeleteTooltip => '습관 삭제';

  @override
  String get heatmapActiveDays => '활동 일수';

  @override
  String get heatmapTotal => '전체';

  @override
  String get heatmapRate => '비율';

  @override
  String get heatmapLess => '적음';

  @override
  String get heatmapMore => '많음';

  @override
  String get accessoryEquipped => '장착 중';

  @override
  String get accessoryOwned => '보유 중';

  @override
  String get pickerMinUnit => '분';

  @override
  String get settingsBackgroundAnimation => '배경 애니메이션';

  @override
  String get settingsBackgroundAnimationSubtitle => '메시 그라디언트와 떠다니는 파티클';

  @override
  String get settingsUiStyle => 'UI 스타일';

  @override
  String get settingsUiStyleMaterial => 'Material 3';

  @override
  String get settingsUiStyleRetroPixel => '레트로 픽셀';

  @override
  String get settingsUiStyleMaterialSubtitle => '모던한 라운드 Material 디자인';

  @override
  String get settingsUiStyleRetroPixelSubtitle => '따뜻한 픽셀 아트 스타일';

  @override
  String get personalityLazy => '게으른';

  @override
  String get personalityCurious => '호기심 많은';

  @override
  String get personalityPlayful => '장난스러운';

  @override
  String get personalityShy => '수줍은';

  @override
  String get personalityBrave => '용감한';

  @override
  String get personalityClingy => '집착하는';

  @override
  String get personalityFlavorLazy =>
      '하루 23시간을 낮잠으로 보낼 거예요. 나머지 1시간? 그것도 낮잠이에요.';

  @override
  String get personalityFlavorCurious => '이미 눈에 보이는 모든 걸 킁킁거리고 있어요!';

  @override
  String get personalityFlavorPlayful => '나비 쫓기를 멈출 수가 없어요!';

  @override
  String get personalityFlavorShy => '상자 밖을 살짝 내다보는 데 3분이 걸렸어요...';

  @override
  String get personalityFlavorBrave => '상자가 열리기도 전에 뛰어나왔어요!';

  @override
  String get personalityFlavorClingy => '바로 골골거리기 시작했고 절대 놓아주지 않아요.';

  @override
  String get moodHappy => '행복';

  @override
  String get moodNeutral => '보통';

  @override
  String get moodLonely => '외로움';

  @override
  String get moodMissing => '보고 싶음';

  @override
  String get moodMsgLazyHappy => '냐~! 잘 잔 낮잠 시간이다...';

  @override
  String get moodMsgCuriousHappy => '오늘은 뭘 탐험할까?';

  @override
  String get moodMsgPlayfulHappy => '냐~! 일할 준비 됐다!';

  @override
  String get moodMsgShyHappy => '...와-와줘서 기뻐.';

  @override
  String get moodMsgBraveHappy => '오늘도 함께 정복하자!';

  @override
  String get moodMsgClingyHappy => '야호! 돌아왔구나! 다시 가지 마!';

  @override
  String get moodMsgLazyNeutral => '*하품* 오, 안녕...';

  @override
  String get moodMsgCuriousNeutral => '흠, 저기 저건 뭐지?';

  @override
  String get moodMsgPlayfulNeutral => '놀래? 아마 나중에...';

  @override
  String get moodMsgShyNeutral => '*천천히 밖을 내다봄*';

  @override
  String get moodMsgBraveNeutral => '언제나 보초를 서고 있어.';

  @override
  String get moodMsgClingyNeutral => '기다리고 있었어...';

  @override
  String get moodMsgLazyLonely => '낮잠도 외롭게 느껴져...';

  @override
  String get moodMsgCuriousLonely => '언제 돌아올까...';

  @override
  String get moodMsgPlayfulLonely => '너 없으면 장난감도 재미없어...';

  @override
  String get moodMsgShyLonely => '*조용히 웅크림*';

  @override
  String get moodMsgBraveLonely => '계속 기다릴게. 나는 용감하니까.';

  @override
  String get moodMsgClingyLonely => '어디 간 거야... 🥺';

  @override
  String get moodMsgLazyMissing => '*한쪽 눈을 기대하며 뜸*';

  @override
  String get moodMsgCuriousMissing => '무슨 일이 있었던 거야...?';

  @override
  String get moodMsgPlayfulMissing => '네가 좋아하는 장난감 남겨뒀어...';

  @override
  String get moodMsgShyMissing => '*숨어 있지만, 문을 지켜보고 있어*';

  @override
  String get moodMsgBraveMissing => '꼭 돌아올 거라고 믿어.';

  @override
  String get moodMsgClingyMissing => '너무 보고 싶어... 제발 돌아와.';

  @override
  String get peltTypeTabby => '클래식 태비 줄무늬';

  @override
  String get peltTypeTicked => '틱트 아구티 패턴';

  @override
  String get peltTypeMackerel => '고등어 태비';

  @override
  String get peltTypeClassic => '클래식 소용돌이 패턴';

  @override
  String get peltTypeSokoke => '소코게 마블 패턴';

  @override
  String get peltTypeAgouti => '아구티 틱트';

  @override
  String get peltTypeSpeckled => '반점 코트';

  @override
  String get peltTypeRosette => '로제트 반점';

  @override
  String get peltTypeSingleColour => '단색';

  @override
  String get peltTypeTwoColour => '투톤';

  @override
  String get peltTypeSmoke => '스모크 쉐이딩';

  @override
  String get peltTypeSinglestripe => '단일 줄무늬';

  @override
  String get peltTypeBengal => '벵갈 패턴';

  @override
  String get peltTypeMarbled => '마블 패턴';

  @override
  String get peltTypeMasked => '마스크 얼굴';

  @override
  String get peltColorWhite => '흰색';

  @override
  String get peltColorPaleGrey => '연한 회색';

  @override
  String get peltColorSilver => '실버';

  @override
  String get peltColorGrey => '회색';

  @override
  String get peltColorDarkGrey => '진한 회색';

  @override
  String get peltColorGhost => '고스트 그레이';

  @override
  String get peltColorBlack => '검정';

  @override
  String get peltColorCream => '크림';

  @override
  String get peltColorPaleGinger => '연한 진저';

  @override
  String get peltColorGolden => '골든';

  @override
  String get peltColorGinger => '진저';

  @override
  String get peltColorDarkGinger => '진한 진저';

  @override
  String get peltColorSienna => '시에나';

  @override
  String get peltColorLightBrown => '연한 갈색';

  @override
  String get peltColorLilac => '라일락';

  @override
  String get peltColorBrown => '갈색';

  @override
  String get peltColorGoldenBrown => '골든 브라운';

  @override
  String get peltColorDarkBrown => '진한 갈색';

  @override
  String get peltColorChocolate => '초콜릿';

  @override
  String get eyeColorYellow => '노랑';

  @override
  String get eyeColorAmber => '앰버';

  @override
  String get eyeColorHazel => '헤이즐';

  @override
  String get eyeColorPaleGreen => '연한 초록';

  @override
  String get eyeColorGreen => '초록';

  @override
  String get eyeColorBlue => '파랑';

  @override
  String get eyeColorDarkBlue => '진한 파랑';

  @override
  String get eyeColorBlueYellow => '파랑-노랑';

  @override
  String get eyeColorBlueGreen => '파랑-초록';

  @override
  String get eyeColorGrey => '회색';

  @override
  String get eyeColorCyan => '시안';

  @override
  String get eyeColorEmerald => '에메랄드';

  @override
  String get eyeColorHeatherBlue => '헤더 블루';

  @override
  String get eyeColorSunlitIce => '선릿 아이스';

  @override
  String get eyeColorCopper => '코퍼';

  @override
  String get eyeColorSage => '세이지';

  @override
  String get eyeColorCobalt => '코발트';

  @override
  String get eyeColorPaleBlue => '연한 파랑';

  @override
  String get eyeColorBronze => '브론즈';

  @override
  String get eyeColorSilver => '실버';

  @override
  String get eyeColorPaleYellow => '연한 노랑';

  @override
  String eyeDescNormal(String color) {
    return '$color 눈';
  }

  @override
  String eyeDescHeterochromia(String primary, String secondary) {
    return '오드아이 ($primary / $secondary)';
  }

  @override
  String get skinColorPink => '분홍';

  @override
  String get skinColorRed => '빨강';

  @override
  String get skinColorBlack => '검정';

  @override
  String get skinColorDark => '어두운';

  @override
  String get skinColorDarkBrown => '진한 갈색';

  @override
  String get skinColorBrown => '갈색';

  @override
  String get skinColorLightBrown => '연한 갈색';

  @override
  String get skinColorDarkGrey => '진한 회색';

  @override
  String get skinColorGrey => '회색';

  @override
  String get skinColorDarkSalmon => '진한 살몬';

  @override
  String get skinColorSalmon => '살몬';

  @override
  String get skinColorPeach => '피치';

  @override
  String get furLengthLonghair => '장모';

  @override
  String get furLengthShorthair => '단모';

  @override
  String get whiteTintOffwhite => '오프화이트 색조';

  @override
  String get whiteTintCream => '크림 색조';

  @override
  String get whiteTintDarkCream => '진한 크림 색조';

  @override
  String get whiteTintGray => '회색 색조';

  @override
  String get whiteTintPink => '핑크 색조';

  @override
  String notifReminderTitle(String catName) {
    return '$catName이(가) 보고 싶어해요!';
  }

  @override
  String notifReminderBody(String habitName) {
    return '$habitName 시간이에요 — 고양이가 기다리고 있어요!';
  }

  @override
  String notifStreakTitle(String catName) {
    return '$catName이(가) 걱정하고 있어요!';
  }

  @override
  String notifStreakBody(int streak) {
    return '$streak일 연속 기록이 위험해요. 짧은 세션이면 지킬 수 있어요!';
  }

  @override
  String notifEvolutionTitle(String catName) {
    return '$catName이(가) 진화했어요!';
  }

  @override
  String notifEvolutionBody(String catName, String stageName) {
    return '$catName이(가) $stageName(으)로 성장했어요! 계속 파이팅!';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours시간 $minutes분';
  }

  @override
  String diaryScreenTitle(String name) {
    return '$name의 일기';
  }

  @override
  String get diaryFailedToLoad => '일기를 불러오지 못했어요';

  @override
  String get diaryEmptyTitle => '아직 일기가 없어요';

  @override
  String get diaryEmptyHint => '집중 세션을 완료하면 고양이가 첫 일기를 써요!';

  @override
  String get focusSetupCountdown => '카운트다운';

  @override
  String get focusSetupStopwatch => '스톱워치';

  @override
  String get focusSetupStartFocus => '집중 시작';

  @override
  String get focusSetupQuestNotFound => '퀘스트를 찾을 수 없어요';

  @override
  String get checkInButtonLogMore => '시간 추가 기록';

  @override
  String get checkInButtonStart => '타이머 시작';

  @override
  String get adoptionTitleFirst => '첫 고양이를 입양하세요!';

  @override
  String get adoptionTitleNew => '새 퀘스트';

  @override
  String get adoptionStepDefineQuest => '퀘스트 설정';

  @override
  String get adoptionStepAdoptCat2 => '고양이 입양';

  @override
  String get adoptionStepNameCat2 => '이름 짓기';

  @override
  String get adoptionAdopt => '입양!';

  @override
  String get adoptionQuestPrompt => '어떤 퀘스트를 시작할까요?';

  @override
  String get adoptionKittenHint => '꾸준히 진행할 수 있도록 아기 고양이가 함께해요!';

  @override
  String get adoptionQuestName => '퀘스트 이름';

  @override
  String get adoptionQuestHint => '예: 면접 질문 준비';

  @override
  String get adoptionTotalTarget => '총 목표 (시간)';

  @override
  String get adoptionGrowthHint => '집중 시간이 쌓이면 고양이가 성장해요';

  @override
  String get adoptionCustom => '직접 설정';

  @override
  String get adoptionDailyGoalLabel => '일일 집중 목표 (분)';

  @override
  String get adoptionReminderLabel => '일일 알림 (선택)';

  @override
  String get adoptionReminderNone => '없음';

  @override
  String get adoptionCustomGoalTitle => '일일 목표 직접 설정';

  @override
  String get adoptionMinutesPerDay => '하루 분';

  @override
  String get adoptionMinutesHint => '5 - 180';

  @override
  String get adoptionValidMinutes => '5에서 180 사이의 값을 입력해 주세요';

  @override
  String get adoptionCustomTargetTitle => '목표 시간 직접 설정';

  @override
  String get adoptionTotalHours => '총 시간';

  @override
  String get adoptionHoursHint => '10 - 2000';

  @override
  String get adoptionValidHours => '10에서 2000 사이의 값을 입력해 주세요';

  @override
  String get adoptionSet => '설정';

  @override
  String get adoptionChooseKitten => '아기 고양이를 골라보세요!';

  @override
  String adoptionCompanionFor(String quest) {
    return '\"$quest\"의 동반자';
  }

  @override
  String get adoptionRerollAll => '전부 다시 뽑기';

  @override
  String get adoptionNameYourCat2 => '고양이 이름을 지어주세요';

  @override
  String get adoptionCatName => '고양이 이름';

  @override
  String get adoptionCatHint => '예: 모찌';

  @override
  String get adoptionRandomTooltip => '랜덤 이름';

  @override
  String adoptionGrowthTarget(String quest, int hours) {
    return '\"$quest\"에 집중하면 고양이가 성장해요! 목표: 총 $hours시간.';
  }

  @override
  String get adoptionValidQuestName => '퀘스트 이름을 입력해 주세요';

  @override
  String get adoptionValidCatName => '고양이 이름을 지어주세요';

  @override
  String adoptionError(String message) {
    return '오류: $message';
  }

  @override
  String get adoptionBasicInfo => '기본 정보';

  @override
  String get adoptionGoals => '목표 설정';

  @override
  String get adoptionUnlimitedMode => '무제한 모드';

  @override
  String get adoptionUnlimitedDesc => '상한 없이 계속 쌓기';

  @override
  String get adoptionMilestoneMode => '마일스톤 모드';

  @override
  String get adoptionMilestoneDesc => '목표 설정하기';

  @override
  String get adoptionDeadlineLabel => '마감일';

  @override
  String get adoptionDeadlineNone => '미설정';

  @override
  String get adoptionReminderSection => '알림';

  @override
  String get adoptionMotivationLabel => '메모';

  @override
  String get adoptionMotivationHint => '메모를 적어보세요...';

  @override
  String get adoptionMotivationSwap => '랜덤 입력';

  @override
  String get loginAppName => '하치미';

  @override
  String get loginTagline => '고양이를 키우고, 퀘스트를 완료하세요.';

  @override
  String get loginContinueGoogle => 'Google로 계속하기';

  @override
  String get loginContinueEmail => '이메일로 계속하기';

  @override
  String get loginAlreadyHaveAccount => '이미 계정이 있으신가요? ';

  @override
  String get loginLogIn => '로그인';

  @override
  String get loginWelcomeBack => '다시 오신 것을 환영해요!';

  @override
  String get loginCreateAccount => '계정 만들기';

  @override
  String get loginEmail => '이메일';

  @override
  String get loginPassword => '비밀번호';

  @override
  String get loginConfirmPassword => '비밀번호 확인';

  @override
  String get loginValidEmail => '이메일을 입력해 주세요';

  @override
  String get loginValidEmailFormat => '올바른 이메일을 입력해 주세요';

  @override
  String get loginValidPassword => '비밀번호를 입력해 주세요';

  @override
  String get loginValidPasswordLength => '비밀번호는 최소 6자 이상이어야 해요';

  @override
  String get loginValidPasswordMatch => '비밀번호가 일치하지 않아요';

  @override
  String get loginCreateAccountButton => '계정 만들기';

  @override
  String get loginNoAccount => '계정이 없으신가요? ';

  @override
  String get loginRegister => '등록';

  @override
  String get checkInTitle => '월간 출석';

  @override
  String get checkInDays => '일';

  @override
  String get checkInCoinsEarned => '획득한 코인';

  @override
  String get checkInAllMilestones => '모든 마일스톤을 달성했어요!';

  @override
  String checkInMilestoneProgress(int remaining, int bonus) {
    return '$remaining일 더 → +$bonus 코인';
  }

  @override
  String get checkInMilestones => '마일스톤';

  @override
  String get checkInFullMonth => '한 달 전체';

  @override
  String get checkInRewardSchedule => '보상 일정';

  @override
  String get checkInWeekday => '평일 (월~금)';

  @override
  String checkInWeekdayReward(int coins) {
    return '$coins 코인/일';
  }

  @override
  String get checkInWeekend => '주말 (토~일)';

  @override
  String checkInNDays(int count) {
    return '$count일';
  }

  @override
  String get onboardTitle1 => '동반자를 만나보세요';

  @override
  String get onboardSubtitle1 => '모든 여정은 아기 고양이에서 시작돼요';

  @override
  String get onboardBody1 => '목표를 정하고 아기 고양이를 입양하세요.\n집중하면 고양이가 함께 성장해요!';

  @override
  String get onboardTitle2 => '집중, 성장, 진화';

  @override
  String get onboardSubtitle2 => '4단계 성장 여정';

  @override
  String get onboardBody2 =>
      '집중하는 매 순간이 고양이의 진화를 도와요.\n작은 아기 고양이에서 멋진 시니어 고양이까지!';

  @override
  String get onboardTitle3 => '고양이 방을 꾸며보세요';

  @override
  String get onboardSubtitle3 => '독특한 고양이를 모으세요';

  @override
  String get onboardBody3 =>
      '퀘스트마다 독특한 외모의 새 고양이가 찾아와요.\n모두 모아 꿈의 컬렉션을 만들어 보세요!';

  @override
  String get onboardSkip => '건너뛰기';

  @override
  String get onboardLetsGo => '시작하기!';

  @override
  String get onboardNext => '다음';

  @override
  String get catRoomTitle => '고양이 집';

  @override
  String get catRoomInventory => '보관함';

  @override
  String get catRoomShop => '액세서리 상점';

  @override
  String get catRoomLoadError => '고양이를 불러오지 못했어요';

  @override
  String get catRoomEmptyTitle => '고양이 집이 비어있어요';

  @override
  String get catRoomEmptySubtitle => '퀘스트를 시작하여 첫 고양이를 입양해 보세요!';

  @override
  String get catRoomEditQuest => '퀘스트 편집';

  @override
  String get catRoomRenameCat => '고양이 이름 변경';

  @override
  String get catRoomArchiveCat => '고양이 보관';

  @override
  String get catRoomNewName => '새 이름';

  @override
  String get catRoomRename => '이름 변경';

  @override
  String get catRoomArchiveTitle => '고양이를 보관할까요?';

  @override
  String catRoomArchiveMessage(String name) {
    return '\"$name\"을(를) 보관하고 연결된 퀘스트가 삭제돼요. 고양이는 여전히 앨범에 남아 있어요.';
  }

  @override
  String get catRoomArchive => '보관';

  @override
  String catRoomAlbumSection(int count) {
    return '앨범 ($count)';
  }

  @override
  String get catRoomReactivateCat => '고양이 다시 활성화';

  @override
  String get catRoomReactivateTitle => '고양이를 다시 활성화할까요?';

  @override
  String catRoomReactivateMessage(String name) {
    return '\"$name\"과(와) 연결된 퀘스트를 고양이 집에 복원해요.';
  }

  @override
  String get catRoomReactivate => '활성화';

  @override
  String get catRoomArchivedLabel => '보관됨';

  @override
  String catRoomArchiveSuccess(String name) {
    return '\"$name\"을(를) 보관했어요';
  }

  @override
  String catRoomReactivateSuccess(String name) {
    return '\"$name\"을(를) 다시 활성화했어요';
  }

  @override
  String get catRoomArchiveError => '고양이 보관에 실패했어요';

  @override
  String get catRoomReactivateError => '고양이 복구에 실패했어요';

  @override
  String get catRoomArchiveLoadError => '보관된 고양이를 불러오지 못했어요';

  @override
  String get catRoomRenameError => '고양이 이름 변경에 실패했어요';

  @override
  String get addHabitTitle => '새 퀘스트';

  @override
  String get addHabitQuestName => '퀘스트 이름';

  @override
  String get addHabitQuestHint => '예: 릿코드 연습';

  @override
  String get addHabitValidName => '퀘스트 이름을 입력해 주세요';

  @override
  String get addHabitTargetHours => '목표 시간';

  @override
  String get addHabitTargetHint => '예: 100';

  @override
  String get addHabitValidTarget => '목표 시간을 입력해 주세요';

  @override
  String get addHabitValidNumber => '올바른 숫자를 입력해 주세요';

  @override
  String get addHabitCreate => '퀘스트 만들기';

  @override
  String get addHabitHoursSuffix => '시간';

  @override
  String shopTabPlants(int count) {
    return '식물 ($count)';
  }

  @override
  String shopTabWild(int count) {
    return '야생 ($count)';
  }

  @override
  String shopTabCollars(int count) {
    return '목걸이 ($count)';
  }

  @override
  String get shopNoAccessories => '액세서리가 없어요';

  @override
  String shopBuyConfirm(String name) {
    return '$name을(를) 구매할까요?';
  }

  @override
  String get shopPurchaseButton => '구매';

  @override
  String get shopNotEnoughCoinsButton => '코인 부족';

  @override
  String shopPurchaseSuccess(String name) {
    return '구매 완료! $name이(가) 보관함에 추가되었어요';
  }

  @override
  String shopPurchaseFailed(int price) {
    return '코인이 부족해요 ($price 코인 필요)';
  }

  @override
  String get inventoryTitle => '보관함';

  @override
  String inventoryInBox(int count) {
    return '보관 중 ($count)';
  }

  @override
  String get inventoryEmpty => '보관함이 비어있어요.\n상점에서 액세서리를 구매해 보세요!';

  @override
  String inventoryEquippedOnCats(int count) {
    return '고양이에게 장착 중 ($count)';
  }

  @override
  String get inventoryNoEquipped => '어떤 고양이에게도 액세서리가 장착되어 있지 않아요.';

  @override
  String get inventoryUnequip => '해제';

  @override
  String get inventoryNoActiveCats => '활성 고양이가 없어요';

  @override
  String inventoryEquipTo(String name) {
    return '$name을(를) 장착할 고양이:';
  }

  @override
  String inventoryEquipSuccess(String name) {
    return '$name 장착 완료';
  }

  @override
  String inventoryUnequipSuccess(String catName) {
    return '$catName에게서 해제됨';
  }

  @override
  String get chatCatNotFound => '고양이를 찾을 수 없어요';

  @override
  String chatTitle(String name) {
    return '$name와(과) 채팅';
  }

  @override
  String get chatClearHistory => '기록 삭제';

  @override
  String chatEmptyTitle(String name) {
    return '$name에게 인사해 보세요!';
  }

  @override
  String get chatEmptySubtitle => '고양이와 대화를 시작해 보세요. 성격에 따라 다르게 대답해요!';

  @override
  String get chatGenerating => '생성 중...';

  @override
  String get chatTypeMessage => '메시지를 입력하세요...';

  @override
  String get chatClearConfirmTitle => '채팅 기록을 삭제할까요?';

  @override
  String get chatClearConfirmMessage => '모든 메시지가 삭제돼요. 이 작업은 되돌릴 수 없어요.';

  @override
  String get chatClearButton => '삭제';

  @override
  String get chatSend => '보내기';

  @override
  String get chatStop => '중지';

  @override
  String get chatErrorMessage => 'Failed to send message. Tap to retry.';

  @override
  String get chatRetry => 'Retry';

  @override
  String get chatErrorGeneric => '문제가 발생했어요. 다시 시도해 주세요';

  @override
  String diaryTitle(String name) {
    return '$name의 일기';
  }

  @override
  String get diaryLoadFailed => '일기를 불러오지 못했어요';

  @override
  String get diaryRetry => '다시 시도';

  @override
  String get diaryEmptyTitle2 => '아직 일기가 없어요';

  @override
  String get diaryEmptySubtitle => '집중 세션을 완료하면 고양이가 첫 일기를 써요!';

  @override
  String get statsTitle => '통계';

  @override
  String get statsTotalHours => '총 시간';

  @override
  String statsTimeValue(int hours, int minutes) {
    return '$hours시간 $minutes분';
  }

  @override
  String get statsBestStreak => '최고 연속 기록';

  @override
  String statsStreakDays(int count) {
    return '$count일';
  }

  @override
  String get statsOverallProgress => '전체 진행도';

  @override
  String statsPercentOfGoals(String percent) {
    return '전체 목표의 $percent%';
  }

  @override
  String get statsPerQuestProgress => '퀘스트별 진행도';

  @override
  String get statsQuestLoadError => '퀘스트 통계를 불러오지 못했어요';

  @override
  String get statsNoQuestData => '아직 퀘스트 데이터가 없어요';

  @override
  String get statsNoQuestHint => '퀘스트를 시작하면 여기에서 진행 상황을 볼 수 있어요!';

  @override
  String get statsLast30Days => '최근 30일';

  @override
  String get habitDetailQuestNotFound => '퀘스트를 찾을 수 없어요';

  @override
  String get habitDetailComplete => '완료';

  @override
  String get habitDetailTotalTime => '총 시간';

  @override
  String get habitDetailCurrentStreak => '현재 연속 기록';

  @override
  String get habitDetailTarget => '목표';

  @override
  String habitDetailDaysUnit(int count) {
    return '$count일';
  }

  @override
  String habitDetailHoursUnit(int count) {
    return '$count시간';
  }

  @override
  String checkInBannerSuccess(int coins) {
    return '+$coins 코인! 일일 출석 완료';
  }

  @override
  String checkInBannerBonus(int bonus) {
    return ' + $bonus 마일스톤 보너스!';
  }

  @override
  String get checkInBannerSemantics => '일일 출석';

  @override
  String get checkInBannerLoading => '출석 상태 확인 중...';

  @override
  String checkInBannerPrompt(int coins) {
    return '출석하면 +$coins 코인';
  }

  @override
  String checkInBannerSummary(int count, int total, int coins) {
    return '$count/$total일  ·  오늘 +$coins';
  }

  @override
  String commonErrorWithDetail(String error) {
    return '오류: $error';
  }

  @override
  String get profileFallbackUser => '사용자';

  @override
  String get fallbackCatName => '고양이';

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
  String get notifFocusing => '집중 중...';

  @override
  String get notifInProgress => '집중 세션 진행 중';

  @override
  String get unitMinShort => '분';

  @override
  String get unitHourShort => '시간';

  @override
  String get weekdayMon => '월';

  @override
  String get weekdayTue => '화';

  @override
  String get weekdayWed => '수';

  @override
  String get weekdayThu => '목';

  @override
  String get weekdayFri => '금';

  @override
  String get weekdaySat => '토';

  @override
  String get weekdaySun => '일';

  @override
  String get statsTotalSessions => '집중 횟수';

  @override
  String get statsTotalHabits => '작업 수';

  @override
  String get statsActiveDays => '활동 일수';

  @override
  String get statsWeeklyTrend => '주간 추세';

  @override
  String get statsRecentSessions => '최근 집중';

  @override
  String get statsViewAllHistory => '전체 기록 보기';

  @override
  String get historyTitle => '집중 기록';

  @override
  String get historyFilterAll => '전체';

  @override
  String historySessionCount(int count) {
    return '$count회 집중';
  }

  @override
  String historyTotalMinutes(int minutes) {
    return '$minutes분';
  }

  @override
  String get historyNoSessions => '집중 기록이 없습니다';

  @override
  String get historyNoSessionsHint => '집중 세션을 완료하면 여기에 표시됩니다';

  @override
  String get historyLoadMore => '더 불러오기';

  @override
  String get sessionCompleted => '완료';

  @override
  String get sessionAbandoned => '포기';

  @override
  String get sessionInterrupted => '중단됨';

  @override
  String get sessionCountdown => '카운트다운';

  @override
  String get sessionStopwatch => '스톱워치';

  @override
  String get historyDateGroupToday => '오늘';

  @override
  String get historyDateGroupYesterday => '어제';

  @override
  String get historyLoadError => '기록 불러오기 실패';

  @override
  String get historySelectMonth => '월 선택';

  @override
  String get historyAllMonths => '전체 월';

  @override
  String get historyAllHabits => '전체';

  @override
  String get homeTabAchievements => '업적';

  @override
  String get achievementTitle => '업적';

  @override
  String get achievementTabOverview => '개요';

  @override
  String get achievementTabQuest => '퀘스트';

  @override
  String get achievementTabStreak => '연속';

  @override
  String get achievementTabCat => '고양이';

  @override
  String get achievementTabPersist => '꾸준함';

  @override
  String get achievementSummaryTitle => '업적 현황';

  @override
  String achievementUnlockedCount(int count) {
    return '$count개 달성';
  }

  @override
  String achievementTotalCoins(int coins) {
    return '$coins 코인 획득';
  }

  @override
  String get achievementUnlocked => '업적 달성!';

  @override
  String get achievementAwesome => '대단해!';

  @override
  String get achievementIncredible => '놀라워!';

  @override
  String get achievementHidden => '???';

  @override
  String get achievementHiddenDesc => '숨겨진 업적입니다';

  @override
  String achievementPersistDesc(int days) {
    return '아무 퀘스트에서 $days일 체크인 달성';
  }

  @override
  String achievementTitleCount(int count) {
    return '$count개 칭호 달성';
  }

  @override
  String get growthPathTitle => '성장의 길';

  @override
  String get growthPathKitten => '새로운 여정의 시작';

  @override
  String get growthPathAdolescent => '기초를 다지다';

  @override
  String get growthPathAdult => '스킬 정착';

  @override
  String get growthPathSenior => '깊은 숙련';

  @override
  String get growthPathTip =>
      '연구에 따르면 20시간의 집중 연습만으로도 새로운 기술의 기초를 쌓을 수 있습니다 — Josh Kaufman';

  @override
  String achievementCelebrationCoins(int count) {
    return '+$count 코인';
  }

  @override
  String achievementCelebrationTitle(String title) {
    return '칭호 획득: $title';
  }

  @override
  String get achievementCelebrationDismiss => '대단해!';

  @override
  String get achievementCelebrationSkipAll => '모두 건너뛰기';

  @override
  String achievementCelebrationCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String achievementUnlockedAt(String date) {
    return '$date에 달성';
  }

  @override
  String get achievementLocked => '아직 달성하지 못했습니다';

  @override
  String achievementRewardCoins(int count) {
    return '+$count 코인';
  }

  @override
  String get reminderModeDaily => '매일';

  @override
  String get reminderModeWeekdays => '평일';

  @override
  String get reminderModeMonday => '월요일';

  @override
  String get reminderModeTuesday => '화요일';

  @override
  String get reminderModeWednesday => '수요일';

  @override
  String get reminderModeThursday => '목요일';

  @override
  String get reminderModeFriday => '금요일';

  @override
  String get reminderModeSaturday => '토요일';

  @override
  String get reminderModeSunday => '일요일';

  @override
  String get reminderPickerTitle => '알림 시간 선택';

  @override
  String get reminderHourUnit => '시';

  @override
  String get reminderMinuteUnit => '분';

  @override
  String get reminderAddMore => '알림 추가';

  @override
  String get reminderMaxReached => '최대 5개 알림';

  @override
  String get reminderConfirm => '확인';

  @override
  String reminderNotificationTitle(String catName) {
    return '$catName이(가) 보고 싶어해요!';
  }

  @override
  String reminderNotificationBody(String habitName) {
    return '$habitName 시간이에요. 고양이가 기다리고 있어요!';
  }

  @override
  String get deleteAccountDataWarning => '다음 모든 데이터가 영구적으로 삭제됩니다:';

  @override
  String get deleteAccountQuests => '퀘스트';

  @override
  String get deleteAccountCats => '고양이';

  @override
  String get deleteAccountHours => '집중 시간';

  @override
  String get deleteAccountIrreversible => '이 작업은 되돌릴 수 없습니다';

  @override
  String get deleteAccountContinue => '계속';

  @override
  String get deleteAccountConfirmTitle => '삭제 확인';

  @override
  String get deleteAccountTypeDelete => '계정 삭제를 확인하려면 DELETE를 입력하세요:';

  @override
  String get deleteAccountAuthCancelled => '인증이 취소되었습니다';

  @override
  String deleteAccountAuthFailed(String error) {
    return '인증 실패: $error';
  }

  @override
  String get deleteAccountProgress => '계정 삭제 중...';

  @override
  String get deleteAccountSuccess => '계정이 삭제되었습니다';

  @override
  String get drawerGuestLoginSubtitle => '데이터 동기화, AI 기능 잠금 해제';

  @override
  String get drawerGuestSignIn => '로그인';

  @override
  String get drawerMilestones => '마일스톤';

  @override
  String drawerMilestoneFocus(int hours, int minutes) {
    return '총 집중: ${hours}h ${minutes}m';
  }

  @override
  String drawerMilestoneCats(int count) {
    return '고양이 가족: $count마리';
  }

  @override
  String drawerMilestoneQuests(int count) {
    return '진행 중 퀘스트: $count개';
  }

  @override
  String get drawerMySection => '나의';

  @override
  String get drawerSessionHistory => '집중 기록';

  @override
  String get drawerCheckInCalendar => '출석 달력';

  @override
  String get drawerAccountSection => '계정';

  @override
  String get settingsResetData => '모든 데이터 초기화';

  @override
  String get settingsResetDataTitle => '모든 데이터를 초기화하시겠습니까?';

  @override
  String get settingsResetDataMessage =>
      '모든 로컬 데이터가 삭제되고 환영 화면으로 돌아갑니다. 이 작업은 되돌릴 수 없습니다.';

  @override
  String get guestUpgradeTitle => '데이터 보호';

  @override
  String get guestUpgradeMessage =>
      '계정 연결로 진행 상황을 백업하고, AI 일기 및 채팅 기능을 잠금 해제하고, 기기 간 동기화할 수 있습니다.';

  @override
  String get guestUpgradeLinkButton => '계정 연결';

  @override
  String get guestUpgradeLater => '나중에';

  @override
  String get loginLinkTagline => '계정을 연결하여 데이터를 보호하세요';

  @override
  String get aiTeaserTitle => '고양이 일기';

  @override
  String aiTeaserPreview(String catName) {
    return '오늘도 주인과 함께 공부했어... $catName은(는) 또 똑똑해진 것 같다냥~';
  }

  @override
  String aiTeaserCta(String catName) {
    return '계정을 연결하여 $catName이(가) 무슨 말을 하고 싶은지 확인하세요';
  }

  @override
  String get authErrorEmailInUse => '이미 등록된 이메일입니다';

  @override
  String get authErrorWrongPassword => '이메일 또는 비밀번호가 올바르지 않습니다';

  @override
  String get authErrorUserNotFound => '해당 이메일로 등록된 계정이 없습니다';

  @override
  String get authErrorTooManyRequests => '시도 횟수가 너무 많습니다. 나중에 다시 시도해 주세요';

  @override
  String get authErrorNetwork => '네트워크 오류입니다. 연결을 확인해 주세요';

  @override
  String get authErrorAdminRestricted => '로그인이 일시적으로 제한되었습니다';

  @override
  String get authErrorWeakPassword => '비밀번호가 너무 약합니다. 6자 이상으로 설정해 주세요';

  @override
  String get authErrorGeneric => '문제가 발생했습니다. 다시 시도해 주세요';

  @override
  String get deleteAccountReauthEmail => '계속하려면 비밀번호를 입력하세요';

  @override
  String get deleteAccountReauthPasswordHint => '비밀번호';

  @override
  String get deleteAccountError => '문제가 발생했습니다. 나중에 다시 시도해 주세요.';

  @override
  String get deleteAccountPermissionError => '권한 오류입니다. 로그아웃 후 다시 로그인해 주세요.';

  @override
  String get deleteAccountNetworkError => '인터넷에 연결되어 있지 않습니다. 네트워크를 확인해 주세요.';

  @override
  String get deleteAccountRetainedData => '사용 통계 및 오류 보고서는 삭제할 수 없습니다.';

  @override
  String get deleteAccountStepCloud => '클라우드 데이터 삭제 중...';

  @override
  String get deleteAccountStepLocal => '로컬 데이터 정리 중...';

  @override
  String get deleteAccountStepDone => '완료';

  @override
  String get deleteAccountQueued =>
      '로컬 데이터가 삭제되었습니다. 클라우드 계정 삭제는 온라인 복구 후 자동 완료됩니다.';

  @override
  String get deleteAccountPending => '계정 삭제가 대기 중입니다. 온라인 상태를 유지해 주세요.';

  @override
  String get deleteAccountAbandon => '새로 시작';

  @override
  String get archiveConflictTitle => '보관할 아카이브 선택';

  @override
  String get archiveConflictMessage => '로컬과 클라우드 모두 데이터가 있습니다. 하나를 선택해 보관하세요:';

  @override
  String get archiveConflictLocal => '로컬 아카이브';

  @override
  String get archiveConflictCloud => '클라우드 아카이브';

  @override
  String get archiveConflictKeepCloud => '클라우드 유지';

  @override
  String get archiveConflictKeepLocal => '로컬 유지';

  @override
  String get loginShowPassword => '비밀번호 표시';

  @override
  String get loginHidePassword => '비밀번호 숨기기';

  @override
  String get errorGeneric => '문제가 발생했어요. 나중에 다시 시도해 주세요';

  @override
  String get errorCreateHabit => '습관 만들기에 실패했어요. 다시 시도해 주세요';

  @override
  String get loginForgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get loginForgotPasswordTitle => '비밀번호 재설정';

  @override
  String get loginSendResetEmail => '재설정 이메일 보내기';

  @override
  String get loginResetEmailSent => '비밀번호 재설정 이메일이 전송되었습니다';

  @override
  String get authErrorUserDisabled => '이 계정은 비활성화되었습니다';

  @override
  String get authErrorInvalidEmail => '유효한 이메일 주소를 입력하세요';

  @override
  String get authErrorRequiresRecentLogin => '계속하려면 다시 로그인하세요';

  @override
  String get commonCopyId => 'ID 복사';

  @override
  String get adoptionClearDeadline => '기한 지우기';

  @override
  String get commonIdCopied => 'ID 복사됨';

  @override
  String get pickerDurationLabel => '시간 선택기';

  @override
  String pickerMinutesValue(int count) {
    return '$count분';
  }

  @override
  String a11yCatImage(String name) {
    return '고양이 $name';
  }

  @override
  String a11yCatTapToInteract(String name) {
    return '$name, 탭하여 상호작용';
  }

  @override
  String a11yProgressPercent(int percent) {
    return '$percent% 완료';
  }

  @override
  String a11yStreakActiveDays(int count) {
    return '활동 $count일';
  }

  @override
  String get a11yOfflineStatus => '오프라인 모드';

  @override
  String a11yAchievementUnlocked(String name) {
    return '업적 달성: $name';
  }

  @override
  String get calendarCheckedIn => '체크인 완료';

  @override
  String get calendarToday => '오늘';

  @override
  String a11yEquipToCat(Object name) {
    return '$name에게 장착';
  }

  @override
  String a11yRegenerateCat(Object name) {
    return '$name 재생성';
  }

  @override
  String a11yTimerDisplay(Object time) {
    return '타이머: $time';
  }

  @override
  String a11yOnboardingPage(Object current, Object total) {
    return '$total페이지 중 $current페이지';
  }

  @override
  String a11yEditDisplayName(Object name) {
    return '표시 이름 편집: $name';
  }

  @override
  String get routeNotFound => '페이지를 찾을 수 없습니다';

  @override
  String get routeGoHome => '홈으로';

  @override
  String get a11yError => '오류';

  @override
  String get a11yDeadline => '마감일';

  @override
  String get a11yReminder => '알림';

  @override
  String get a11yFocusMeditation => '집중 명상';

  @override
  String get a11yUnlocked => '잠금 해제됨';

  @override
  String get a11ySelected => '선택됨';

  @override
  String get a11yDynamicWallpaperColor => '동적 배경화면 색상';

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
    return '늦은 밤이에요, $name';
  }

  @override
  String greetingMorning(String name) {
    return '좋은 아침이에요, $name';
  }

  @override
  String greetingAfternoon(String name) {
    return '좋은 오후에요, $name';
  }

  @override
  String greetingEvening(String name) {
    return '좋은 저녁이에요, $name';
  }

  @override
  String get greetingLateNightNoName => '늦은 밤이에요';

  @override
  String get greetingMorningNoName => '좋은 아침이에요';

  @override
  String get greetingAfternoonNoName => '좋은 오후에요';

  @override
  String get greetingEveningNoName => '좋은 저녁이에요';

  @override
  String get journeyTitle => '여정';

  @override
  String get journeySegmentWeek => '이번 주';

  @override
  String get journeySegmentMonth => '이번 달';

  @override
  String get journeySegmentYear => '올해';

  @override
  String get journeySegmentExplore => '탐색';

  @override
  String get journeyMonthlyView => '월간 보기';

  @override
  String get journeyYearlyView => '연간 보기';

  @override
  String get journeyExploreActivities => '탐색 활동';

  @override
  String get journeyEditMonthlyPlan => '월간 계획 편집';

  @override
  String get journeyEditYearlyPlan => '연간 계획 편집';

  @override
  String get quickLightTitle => '오늘의 한 줄';

  @override
  String get quickLightHint => '오늘의 기분을 한 줄로...';

  @override
  String get quickLightRecord => '기록';

  @override
  String get quickLightSaveSuccess => '기록했어요';

  @override
  String get quickLightSaveError => '저장에 실패했어요. 다시 시도해 주세요';

  @override
  String get habitSnapshotTitle => '오늘의 습관';

  @override
  String get habitSnapshotEmpty => '아직 습관이 없어요. 여정에서 설정할 수 있어요';

  @override
  String get habitSnapshotLoadError => '불러오기 실패';

  @override
  String get worryJarTitle => '걱정 항아리';

  @override
  String get worryJarLoadError => '불러오기 실패';

  @override
  String get weeklyReviewEmpty => '이번 주 행복한 순간을 기록해요';

  @override
  String get weeklyReviewHappyMoments => '행복한 순간';

  @override
  String get weeklyReviewLoadError => '불러오기 실패';

  @override
  String get weeklyPlanCardTitle => '이번 주 계획';

  @override
  String weeklyPlanItemCount(int count) {
    return '$count개';
  }

  @override
  String get weeklyPlanEmpty => '이번 주 계획을 세워요';

  @override
  String get weekMoodTitle => '이번 주 기분';

  @override
  String get weekMoodLoadError => '기분 불러오기 실패';

  @override
  String featureLockedDaysRemaining(int remaining) {
    return '$remaining일 더 기록하면 잠금 해제돼요';
  }

  @override
  String get featureLockedSoon => '곧 잠금 해제';

  @override
  String get weeklyPlanScreenTitle => '이번 주 계획';

  @override
  String get weeklyPlanSave => '저장';

  @override
  String get weeklyPlanSaveSuccess => '저장했어요';

  @override
  String get weeklyPlanSaveError => '저장 실패';

  @override
  String get weeklyPlanOneLine => '이번 주 나에게 한마디';

  @override
  String get weeklyPlanOneLineHint => '이번 주는...';

  @override
  String get weeklyPlanUrgentImportant => '긴급하고 중요한';

  @override
  String get weeklyPlanImportantNotUrgent => '중요하지만 급하지 않은';

  @override
  String get weeklyPlanUrgentNotImportant => '급하지만 중요하지 않은';

  @override
  String get weeklyPlanNotUrgentNotImportant => '급하지도 중요하지도 않은';

  @override
  String get weeklyPlanAddHint => '추가...';

  @override
  String get weeklyPlanMustDo => '반드시';

  @override
  String get weeklyPlanShouldDo => '해야 할';

  @override
  String get weeklyPlanNeedToDo => '하면 좋은';

  @override
  String get weeklyPlanWantToDo => '하고 싶은';

  @override
  String monthlyCalendarYearMonth(int year, int month) {
    return '$year년 $month월';
  }

  @override
  String get monthlyCalendarLoadError => '불러오기 실패';

  @override
  String get monthlyGoalsTitle => '이번 달 목표';

  @override
  String monthlyGoalHint(int index) {
    return '목표 $index';
  }

  @override
  String get monthlySaveError => '저장 실패';

  @override
  String get monthlyMemoryTitle => '이번 달 추억';

  @override
  String get monthlyMemoryHint => '이번 달 가장 아름다운 추억은...';

  @override
  String get monthlyAchievementTitle => '이번 달 성취';

  @override
  String get monthlyAchievementHint => '이번 달 가장 자랑스러운 성취는...';

  @override
  String get yearlyMessagesTitle => '올해의 메시지';

  @override
  String get yearlyMessageBecome => '올해 이런 사람이 되고 싶어요...';

  @override
  String get yearlyMessageGoals => '이루고 싶은 목표';

  @override
  String get yearlyMessageBreakthrough => '돌파 성과';

  @override
  String get yearlyMessageDontDo => '하지 않을 것 (거절도 중요한 일을 위한 자리를 마련하는 것)';

  @override
  String get yearlyMessageKeyword => '올해 키워드 (예: 집중/용기/인내/따뜻함)';

  @override
  String get yearlyMessageFutureSelf => '사랑하는 미래의 나에게';

  @override
  String get yearlyMessageMotto => '나의 좌우명';

  @override
  String get growthPlanTitle => '연간 성장 계획';

  @override
  String get growthPlanHint => '나의 계획...';

  @override
  String get growthPlanSaveError => '저장 실패';

  @override
  String get growthDimensionHealth => '신체 건강';

  @override
  String get growthDimensionEmotion => '감정 관리';

  @override
  String get growthDimensionRelationship => '인간관계';

  @override
  String get growthDimensionCareer => '커리어 성장';

  @override
  String get growthDimensionFinance => '재무 관리';

  @override
  String get growthDimensionLearning => '지속 학습';

  @override
  String get growthDimensionCreativity => '창의력';

  @override
  String get growthDimensionSpirituality => '내면 성장';

  @override
  String get smallWinTitle => '작은 승리 챌린지';

  @override
  String smallWinEmpty(int days) {
    return '$days일 챌린지를 설정하고, 매일 조금씩';
  }

  @override
  String smallWinReward(String reward) {
    return '보상: $reward';
  }

  @override
  String get smallWinLoadError => '불러오기 실패';

  @override
  String get smallWinLawVisible => '보이게';

  @override
  String get smallWinLawAttractive => '끌리게';

  @override
  String get smallWinLawEasy => '쉽게';

  @override
  String get smallWinLawRewarding => '보상있게';

  @override
  String get moodTrackerTitle => '기분 트래커';

  @override
  String get moodTrackerLoadError => '불러오기 실패';

  @override
  String moodTrackerCount(int count) {
    return '$count회';
  }

  @override
  String get habitTrackerTitle => '이번 달 열정과 꾸준함';

  @override
  String get habitTrackerComingSoon => '습관 트래킹 기능 개발 중이에요';

  @override
  String get habitTrackerComingSoonHint => '작은 승리 챌린지에서 습관을 설정해 보세요';

  @override
  String get listsTitle => '내 리스트';

  @override
  String get listBookTitle => '독서 리스트';

  @override
  String get listMovieTitle => '영화 리스트';

  @override
  String get listCustomTitle => '맞춤 리스트';

  @override
  String listItemCount(int count) {
    return '$count개';
  }

  @override
  String get listDetailBookTitle => '나의 독서 리스트';

  @override
  String get listDetailMovieTitle => '나의 영화 리스트';

  @override
  String get listDetailCustomTitle => '나의 리스트';

  @override
  String get listDetailSave => '저장';

  @override
  String get listDetailSaveSuccess => '저장했어요';

  @override
  String get listDetailSaveError => '저장 실패';

  @override
  String get listDetailCustomNameLabel => '리스트 이름';

  @override
  String get listDetailCustomNameHint => '예: 팟캐스트 리스트';

  @override
  String get listDetailItemTitleHint => '제목';

  @override
  String get listDetailItemDateHint => '날짜';

  @override
  String get listDetailItemGenreHint => '장르/태그';

  @override
  String get listDetailItemKeywordHint => '키워드/느낌';

  @override
  String get listDetailYearTreasure => '올해의 보물';

  @override
  String get listDetailYearPick => '올해의 선택';

  @override
  String get listDetailYearPickHint => '올해 가장 추천하고 싶은 한 편';

  @override
  String get listDetailInsight => '영감 한 방';

  @override
  String get listDetailInsightHint => '읽기/감상에서 얻은 가장 큰 영감';

  @override
  String get exploreMyMoments => '나의 순간';

  @override
  String get exploreMyMomentsDesc => '행복하고 빛나는 순간을 기록';

  @override
  String get exploreHabitPact => '습관과의 약속';

  @override
  String get exploreHabitPactDesc => '아토믹 해빗 4법칙으로 새 습관 디자인';

  @override
  String get exploreWorryUnload => '걱정 내려놓기';

  @override
  String get exploreWorryUnloadDesc => '걱정을 분류해요: 내려놓기, 행동하기, 받아들이기';

  @override
  String get exploreSelfPraise => '나를 칭찬하는 모임';

  @override
  String get exploreSelfPraiseDesc => '나의 장점 5가지를 적어요';

  @override
  String get exploreSupportMap => '나를 지지하는 사람들';

  @override
  String get exploreSupportMapDesc => '나를 지지해주는 사람들을 기록';

  @override
  String get exploreFutureSelf => '미래의 나';

  @override
  String get exploreFutureSelfDesc => '3가지 미래의 나를 상상해요';

  @override
  String get exploreIdealVsReal => '이상적인 나 vs. 지금의 나';

  @override
  String get exploreIdealVsRealDesc => '이상과 현실의 교차점을 발견';

  @override
  String get highlightScreenTitle => '나의 순간';

  @override
  String get highlightTabHappy => '행복한 순간';

  @override
  String get highlightTabHighlight => '하이라이트';

  @override
  String get highlightEmptyHappy => '아직 행복한 순간이 없어요';

  @override
  String get highlightEmptyHighlight => '아직 하이라이트가 없어요';

  @override
  String highlightLoadError(String error) {
    return '불러오기 실패: $error';
  }

  @override
  String get monthlyPlanScreenTitle => '월간 계획';

  @override
  String get monthlyPlanSave => '저장';

  @override
  String get monthlyPlanSaveSuccess => '저장했어요';

  @override
  String get monthlyPlanSaveError => '저장 실패';

  @override
  String get monthlyPlanGoalsSection => '월간 목표';

  @override
  String get monthlyPlanChallengeSection => '작은 승리 챌린지';

  @override
  String get monthlyPlanChallengeNameLabel => '챌린지 습관 이름';

  @override
  String get monthlyPlanChallengeNameHint => '예: 매일 10분 달리기';

  @override
  String get monthlyPlanRewardLabel => '완료 후 보상';

  @override
  String get monthlyPlanRewardHint => '예: 읽고 싶은 책 사기';

  @override
  String get monthlyPlanSelfCareSection => '나를 위한 활동';

  @override
  String monthlyPlanActivityHint(int index) {
    return '활동 $index';
  }

  @override
  String get monthlyPlanMemorySection => '이번 달 추억';

  @override
  String get monthlyPlanMemoryHint => '이번 달 가장 아름다운 추억은...';

  @override
  String get monthlyPlanAchievementSection => '이번 달 성취';

  @override
  String get monthlyPlanAchievementHint => '이번 달 가장 자랑스러운 성취는...';

  @override
  String yearlyPlanScreenTitle(int year) {
    return '$year년 연간 계획';
  }

  @override
  String get yearlyPlanSave => '저장';

  @override
  String get yearlyPlanSaveSuccess => '저장했어요';

  @override
  String get yearlyPlanSaveError => '저장 실패';

  @override
  String get yearlyPlanMessagesSection => '올해의 메시지';

  @override
  String get yearlyPlanGrowthSection => '성장 계획';

  @override
  String get growthReviewScreenTitle => '성장 돌아보기';

  @override
  String get growthReviewMyMoments => '나만의 순간';

  @override
  String get growthReviewEmptyMoments => '아직 하이라이트가 없어요';

  @override
  String get growthReviewMySummary => '나의 정리';

  @override
  String get growthReviewSummaryPrompt => '이 여정을 돌아보며, 자신에게 하고 싶은 말은?';

  @override
  String get growthReviewSmallWins => '작은 승리 시상';

  @override
  String get growthReviewConsistentRecord => '꾸준한 기록';

  @override
  String growthReviewRecordedDays(int count) {
    return '$count일 기록했어요';
  }

  @override
  String get growthReviewWeeklyChamp => '주간 리뷰 달인';

  @override
  String growthReviewCompletedReviews(int count) {
    return '$count번의 주간 리뷰를 완료';
  }

  @override
  String get growthReviewWarmClose => '따뜻한 마무리';

  @override
  String get growthReviewEveryStar => '매일의 기록은 하나의 별';

  @override
  String growthReviewKeepShining(int count) {
    return '$count개의 별을 모았어요. 계속 빛나세요!';
  }

  @override
  String get futureSelfScreenTitle => '미래의 나';

  @override
  String get futureSelfSubtitle => '3가지 미래의 나를 상상해요';

  @override
  String get futureSelfHint => '완벽한 답이 아니어도 괜찮아요. 상상을 자유롭게';

  @override
  String get futureSelfStable => '안정적인 미래';

  @override
  String get futureSelfStableHint => '모든 게 순조롭다면, 어떤 삶을 살고 있을까?';

  @override
  String get futureSelfFree => '자유로운 미래';

  @override
  String get futureSelfFreeHint => '아무 제약이 없다면, 가장 하고 싶은 건?';

  @override
  String get futureSelfPace => '나만의 속도로 걷는 미래';

  @override
  String get futureSelfPaceHint => '서두르지 않고, 나의 이상적인 속도는?';

  @override
  String get futureSelfCoreLabel => '진짜 소중한 것은?';

  @override
  String get futureSelfCoreHint => '위 3가지에 공통점이 있나요? 그것이 가장 소중한 것...';

  @override
  String get habitPactScreenTitle => '습관과의 약속';

  @override
  String get habitPactStep1 => '어떤 습관을 만들고 싶어요?';

  @override
  String get habitPactCategoryLearning => '학습';

  @override
  String get habitPactCategoryHealth => '건강';

  @override
  String get habitPactCategoryRelationship => '관계';

  @override
  String get habitPactCategoryHobby => '취미';

  @override
  String get habitPactHabitLabel => '구체적인 습관';

  @override
  String get habitPactHabitHint => '예: 매일 20페이지 읽기';

  @override
  String get habitPactStep2 => '습관의 4가지 법칙';

  @override
  String get habitPactLawVisible => '보이게';

  @override
  String get habitPactLawVisibleHint => '단서를 놓을 곳은...';

  @override
  String get habitPactLawAttractive => '끌리게';

  @override
  String get habitPactLawAttractiveHint => '이것과 연결할 것은...';

  @override
  String get habitPactLawEasy => '쉽게';

  @override
  String get habitPactLawEasyHint => '최소 버전은...';

  @override
  String get habitPactLawRewarding => '보상있게';

  @override
  String get habitPactLawRewardingHint => '완료 후 나에게 보상...';

  @override
  String get habitPactStep3 => '행동 선언';

  @override
  String get habitPactDeclarationEmpty => '위를 채우면 선언이 자동 생성돼요...';

  @override
  String habitPactDeclarationPrefix(String habit) {
    return '「$habit」 습관을 만들겠습니다';
  }

  @override
  String habitPactDeclarationWhen(String cue) {
    return '$cue할 때';
  }

  @override
  String habitPactDeclarationWill(String response) {
    return '$response을 할게요';
  }

  @override
  String habitPactDeclarationThen(String reward) {
    return '그리고 $reward';
  }

  @override
  String get idealVsRealScreenTitle => '이상적인 나 vs. 지금의 나';

  @override
  String get idealVsRealIdeal => '이상적인 나';

  @override
  String get idealVsRealIdealHint => '어떤 사람이 되고 싶어요?';

  @override
  String get idealVsRealReal => '지금의 나';

  @override
  String get idealVsRealRealHint => '지금 나는 어떤 사람인가요?';

  @override
  String get idealVsRealSame => '공통점은?';

  @override
  String get idealVsRealSameHint => '이상과 현실에서 이미 겹치는 부분은?';

  @override
  String get idealVsRealDiff => '다른 점은?';

  @override
  String get idealVsRealDiffHint => '차이는 어디에? 어떤 기분이 드나요?';

  @override
  String get idealVsRealStep => '이상에 가까워지려면 작은 한 걸음만';

  @override
  String get idealVsRealStepHint => '오늘 할 수 있는 작은 일은...';

  @override
  String get selfPraiseScreenTitle => '나를 칭찬하는 모임';

  @override
  String get selfPraiseSubtitle => '나의 장점 5가지를 적어요';

  @override
  String get selfPraiseHint => '누구나 인정받을 자격이 있어요, 특히 자기 자신에게';

  @override
  String selfPraiseStrengthLabel(int index) {
    return '장점 $index';
  }

  @override
  String get selfPraisePrompt1 => '가장 따뜻한 나의 성격은...';

  @override
  String get selfPraisePrompt2 => '잘하는 한 가지는...';

  @override
  String get selfPraisePrompt3 => '자주 칭찬받는 것은...';

  @override
  String get selfPraisePrompt4 => '나를 자랑스럽게 만드는 것은...';

  @override
  String get selfPraisePrompt5 => '나만의 특별함은...';

  @override
  String get supportMapScreenTitle => '나를 지지하는 사람들';

  @override
  String get supportMapSubtitle => '누가 나를 지지해주나요?';

  @override
  String get supportMapHint => '소중한 사람을 기록하고, 혼자가 아님을 기억해요';

  @override
  String get supportMapNameLabel => '이름';

  @override
  String get supportMapRelationLabel => '관계';

  @override
  String get supportMapRelationHint => '예: 친구/가족/동료';

  @override
  String get supportMapAdd => '추가';

  @override
  String get worryUnloadScreenTitle => '걱정 내려놓기';

  @override
  String worryUnloadLoadError(String error) {
    return '불러오기 실패: $error';
  }

  @override
  String get worryUnloadEmptyTitle => '진행 중인 걱정이 없어요';

  @override
  String get worryUnloadEmptyHint => '멋져요! 오늘은 가벼운 하루';

  @override
  String get worryUnloadIntro => '걱정을 살펴보고 분류해 봐요';

  @override
  String get worryUnloadLetGo => '내려놓을 수 있는';

  @override
  String get worryUnloadTakeAction => '행동할 수 있는';

  @override
  String get worryUnloadAccept => '잠시 받아들이는';

  @override
  String get worryUnloadResultTitle => '내려놓기 결과';

  @override
  String worryUnloadSummary(String label, int count) {
    return '$label: $count개';
  }

  @override
  String get worryUnloadEncouragement => '분류하는 것만으로도 한 걸음 전진.';

  @override
  String get commonSaved => '저장했어요';

  @override
  String get commonSaveError => '저장 실패';

  @override
  String get commonLoadError => '불러오기 실패';

  @override
  String get momentEditTitle => '순간 수정';

  @override
  String get momentNewHappy => '행복한 순간 기록하기';

  @override
  String get momentNewHighlight => '하이라이트 기록하기';

  @override
  String get momentDescHappy => '행복한 일';

  @override
  String get momentDescHighlight => '무슨 일이 있었나요';

  @override
  String get momentCompanionHappy => '누구와 함께했나요';

  @override
  String get momentCompanionHighlight => '내가 한 일';

  @override
  String get momentFeeling => '느낌';

  @override
  String get momentDate => '날짜 (YYYY-MM-DD)';

  @override
  String get momentRating => '평가';

  @override
  String get momentDescRequired => '설명을 입력해 주세요';

  @override
  String momentWithCompanion(String companion) {
    return '$companion와 함께';
  }

  @override
  String momentDidAction(String action) {
    return '한 일: $action';
  }

  @override
  String get annualCalendarTitle => '나의 연간 달력';

  @override
  String annualCalendarMonthLabel(int month) {
    return '$month월';
  }
}
