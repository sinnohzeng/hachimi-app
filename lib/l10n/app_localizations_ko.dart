// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class SKo extends S {
  SKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '하치미';

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
  String get settingsAiModel => 'AI 모델';

  @override
  String get settingsAiFeatures => 'AI 기능';

  @override
  String get settingsAiSubtitle => '온디바이스 AI 기반 고양이 일기와 채팅을 사용해 보세요';

  @override
  String get settingsAbout => '정보';

  @override
  String get settingsVersion => '버전';

  @override
  String get settingsLicenses => '라이선스';

  @override
  String get settingsAccount => '계정';

  @override
  String get settingsDownloadModel => '모델 다운로드 (1.2 GB)';

  @override
  String get settingsDeleteModel => '모델 삭제';

  @override
  String get settingsDeleteModelTitle => '모델을 삭제할까요?';

  @override
  String get settingsDeleteModelMessage =>
      '다운로드한 AI 모델(1.2 GB)이 삭제돼요. 나중에 다시 다운로드할 수 있어요.';

  @override
  String get logoutTitle => '로그아웃할까요?';

  @override
  String get logoutMessage => '정말 로그아웃하시겠어요?';

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
  String get profileBestStreak => '최고 연속 기록';

  @override
  String get profileCatAlbum => '고양이 앨범';

  @override
  String profileCatAlbumCount(int count) {
    return '$count마리';
  }

  @override
  String profileSeeAll(int count) {
    return '$count마리 모두 보기';
  }

  @override
  String get profileGraduated => '졸업';

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
  String get testChatTitle => 'AI 모델 테스트';

  @override
  String get testChatLoadingModel => '모델 불러오는 중...';

  @override
  String get testChatModelLoaded => '모델 로드 완료';

  @override
  String get testChatErrorLoading => '모델 로드 오류';

  @override
  String get testChatCouldNotLoad => '모델을 불러올 수 없어요';

  @override
  String get testChatFailedToLoad => '모델 로드에 실패했어요';

  @override
  String get testChatUnknownError => '알 수 없는 오류';

  @override
  String get testChatFileCorrupted => '모델 파일이 손상되었거나 불완전합니다. 다시 다운로드하세요.';

  @override
  String get testChatRedownload => '다시 다운로드';

  @override
  String get testChatModelReady => '모델 준비 완료';

  @override
  String get testChatSendToTest => '메시지를 보내 AI 모델을 테스트해 보세요.';

  @override
  String get testChatGenerating => '생성 중...';

  @override
  String get testChatTypeMessage => '메시지를 입력하세요...';

  @override
  String get settingsAiPrivacyBadge => '온디바이스 AI — 모든 처리가 기기에서 이루어져요';

  @override
  String get settingsAiWhatYouGet => '제공되는 기능:';

  @override
  String get settingsAiFeatureDiary => '하치미 일기 — 고양이가 매일 일기를 써요';

  @override
  String get settingsAiFeatureChat => '고양이 채팅 — 고양이와 대화해 보세요';

  @override
  String get settingsRedownload => '다시 다운로드';

  @override
  String get settingsTestModel => '모델 테스트';

  @override
  String get settingsStatusDownloading => '다운로드 중';

  @override
  String get settingsStatusReady => '준비 완료';

  @override
  String get settingsStatusError => '오류';

  @override
  String get settingsStatusLoading => '불러오는 중';

  @override
  String get settingsStatusNotDownloaded => '미다운로드';

  @override
  String get settingsStatusDisabled => '비활성화됨';

  @override
  String get catDetailNotFound => '고양이를 찾을 수 없어요';

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
  String get adoptionTotalTarget => '총 목표 시간';

  @override
  String get adoptionGrowthHint => '집중 시간이 쌓이면 고양이가 성장해요';

  @override
  String get adoptionCustom => '직접 설정';

  @override
  String get adoptionDailyGoalLabel => '일일 집중 목표';

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
  String get onboardTitle1 => '하치미에 오신 것을 환영해요';

  @override
  String get onboardSubtitle1 => '고양이를 키우고, 퀘스트를 완료하세요';

  @override
  String get onboardBody1 =>
      '시작하는 모든 퀘스트에 아기 고양이가 함께해요.\n목표에 집중하면 아기 고양이가\n멋진 고양이로 성장하는 걸 볼 수 있어요!';

  @override
  String get onboardTitle2 => '집중하고 XP를 획득하세요';

  @override
  String get onboardSubtitle2 => '시간이 성장의 원동력';

  @override
  String get onboardBody2 =>
      '집중 세션을 시작하면 고양이가 XP를 획득해요.\n연속 기록으로 보너스 보상을 받으세요.\n매분이 진화를 향한 한 걸음이에요!';

  @override
  String get onboardTitle3 => '진화를 지켜보세요';

  @override
  String get onboardSubtitle3 => '아기 고양이 → 빛나는 고양이';

  @override
  String get onboardBody3 =>
      '고양이는 성장하며 4단계를 거쳐 진화해요.\n다양한 품종을 모으고, 희귀 고양이를 잠금 해제하고,\n아늑한 고양이 방을 채워보세요!';

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
}
