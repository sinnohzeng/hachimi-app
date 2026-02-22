// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class SJa extends S {
  SJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Hachimi';

  @override
  String get homeTabToday => '今日';

  @override
  String get homeTabCatHouse => 'ネコハウス';

  @override
  String get homeTabStats => '統計';

  @override
  String get homeTabProfile => 'プロフィール';

  @override
  String get adoptionStepDefineHabit => '習慣を決める';

  @override
  String get adoptionStepAdoptCat => 'ネコを迎える';

  @override
  String get adoptionStepNameCat => '名前をつける';

  @override
  String get adoptionHabitName => '習慣の名前';

  @override
  String get adoptionHabitNameHint => '例: 毎日の読書';

  @override
  String get adoptionDailyGoal => '1日の目標';

  @override
  String get adoptionTargetHours => '目標時間';

  @override
  String get adoptionTargetHoursHint => 'この習慣を達成するための合計時間';

  @override
  String adoptionMinutes(int count) {
    return '$count分';
  }

  @override
  String get adoptionRefreshCat => '別のネコを見る';

  @override
  String adoptionPersonality(String name) {
    return '性格: $name';
  }

  @override
  String get adoptionNameYourCat => 'ネコに名前をつけよう';

  @override
  String get adoptionRandomName => 'ランダム';

  @override
  String get adoptionCreate => '習慣を作成してネコを迎える';

  @override
  String get adoptionNext => '次へ';

  @override
  String get adoptionBack => '戻る';

  @override
  String get adoptionCatNameLabel => 'ネコの名前';

  @override
  String get adoptionCatNameHint => '例: もち';

  @override
  String get adoptionRandomNameTooltip => 'ランダムな名前';

  @override
  String get catHouseTitle => 'ネコハウス';

  @override
  String get catHouseEmpty => 'まだネコがいません！習慣を作成して最初のネコを迎えましょう。';

  @override
  String catHouseGrowth(int minutes, int target) {
    return '$minutes / $target分';
  }

  @override
  String get catDetailGrowthProgress => '成長の進捗';

  @override
  String catDetailTotalMinutes(int minutes) {
    return '$minutes分集中しました';
  }

  @override
  String catDetailTargetMinutes(int minutes) {
    return '目標: $minutes分';
  }

  @override
  String get catDetailRename => '名前を変更';

  @override
  String get catDetailAccessories => 'アクセサリー';

  @override
  String get catDetailStartFocus => '集中を開始';

  @override
  String get catDetailBoundHabit => '紐づけた習慣';

  @override
  String catDetailStage(String stage) {
    return 'ステージ: $stage';
  }

  @override
  String coinBalance(int amount) {
    return '$amountコイン';
  }

  @override
  String coinCheckInReward(int amount) {
    return '+$amountコイン！';
  }

  @override
  String get coinCheckInTitle => 'デイリーチェックイン';

  @override
  String get coinInsufficientBalance => 'コインが足りません';

  @override
  String get shopTitle => 'アクセサリーショップ';

  @override
  String shopPrice(int price) {
    return '$priceコイン';
  }

  @override
  String get shopPurchase => '購入';

  @override
  String get shopEquipped => '装備中';

  @override
  String focusCompleteMinutes(int minutes) {
    return '+$minutes分';
  }

  @override
  String get focusCompleteStageUp => 'ステージアップ！';

  @override
  String get focusCompleteGreatJob => 'よく頑張りました！';

  @override
  String get focusCompleteDone => '完了';

  @override
  String get focusCompleteItsOkay => '大丈夫！';

  @override
  String focusCompleteEvolved(String catName) {
    return '$catNameが進化しました！';
  }

  @override
  String focusCompleteFocusedFor(int minutes) {
    return '$minutes分間集中しました';
  }

  @override
  String focusCompleteAbandonedMessage(String catName) {
    return '$catName「また一緒にがんばろうね！」';
  }

  @override
  String get focusCompleteFocusTime => '集中時間';

  @override
  String get focusCompleteCoinsEarned => '獲得コイン';

  @override
  String get focusCompleteBaseXp => '基本XP';

  @override
  String get focusCompleteStreakBonus => '連続ボーナス';

  @override
  String get focusCompleteMilestoneBonus => 'マイルストーンボーナス';

  @override
  String get focusCompleteFullHouseBonus => 'フルハウスボーナス';

  @override
  String get focusCompleteTotal => '合計';

  @override
  String focusCompleteEvolvedTo(String stage) {
    return '$stageに進化しました！';
  }

  @override
  String get focusCompleteYourCat => 'あなたのネコ';

  @override
  String get focusCompleteDiaryWriting => '日記を書いています...';

  @override
  String get focusCompleteDiaryWritten => '日記を書きました！';

  @override
  String get focusCompleteNotifTitle => 'クエスト完了！';

  @override
  String focusCompleteNotifBody(String catName, int xp, int minutes) {
    return '$catNameが$minutes分の集中で+$xp XPを獲得しました';
  }

  @override
  String get stageKitten => '子猫';

  @override
  String get stageAdolescent => '若猫';

  @override
  String get stageAdult => '成猫';

  @override
  String get stageSenior => '長老猫';

  @override
  String get migrationTitle => 'データの更新が必要です';

  @override
  String get migrationMessage =>
      'Hachimiが新しいピクセルネコシステムにアップデートされました！以前のネコデータは互換性がありません。新しい体験を始めるためにリセットしてください。';

  @override
  String get migrationResetButton => 'リセットして始める';

  @override
  String get sessionResumeTitle => 'セッションを再開しますか？';

  @override
  String sessionResumeMessage(String habitName, String elapsed) {
    return 'アクティブな集中セッションがあります（$habitName、$elapsed）。再開しますか？';
  }

  @override
  String get sessionResumeButton => '再開';

  @override
  String get sessionDiscard => '破棄';

  @override
  String get todaySummaryMinutes => '今日';

  @override
  String get todaySummaryTotal => '合計';

  @override
  String get todaySummaryCats => 'ネコ';

  @override
  String get todayYourQuests => 'あなたのクエスト';

  @override
  String get todayNoQuests => 'クエストはまだありません';

  @override
  String get todayNoQuestsHint => '＋をタップしてクエストを始め、ネコを迎えましょう！';

  @override
  String get todayFocus => '集中';

  @override
  String get todayDeleteQuestTitle => 'クエストを削除しますか？';

  @override
  String todayDeleteQuestMessage(String name) {
    return '「$name」を削除してもよいですか？ネコはアルバムに卒業します。';
  }

  @override
  String todayQuestCompleted(String name) {
    return '$nameを達成しました';
  }

  @override
  String get todayFailedToLoad => 'クエストの読み込みに失敗しました';

  @override
  String todayMinToday(int count) {
    return '今日$count分';
  }

  @override
  String todayGoalMinPerDay(int count) {
    return '目標: $count分/日';
  }

  @override
  String get todayFeaturedCat => '注目のネコ';

  @override
  String get todayAddHabit => '習慣を追加';

  @override
  String get todayNoHabits => '最初の習慣を作成して始めましょう！';

  @override
  String get todayNewQuest => '新しいクエスト';

  @override
  String get todayStartFocus => '集中を開始';

  @override
  String get timerStart => '開始';

  @override
  String get timerPause => '一時停止';

  @override
  String get timerResume => '再開';

  @override
  String get timerDone => '完了';

  @override
  String get timerGiveUp => 'やめる';

  @override
  String get timerRemaining => '残り';

  @override
  String get timerElapsed => '経過';

  @override
  String get timerPaused => '一時停止中';

  @override
  String get timerQuestNotFound => 'クエストが見つかりません';

  @override
  String get timerNotificationBanner =>
      'アプリがバックグラウンドにあるときにタイマーの進捗を確認するには、通知を有効にしてください';

  @override
  String get timerNotificationDismiss => '閉じる';

  @override
  String get timerNotificationEnable => '有効にする';

  @override
  String timerGraceBack(int seconds) {
    return '戻る ($seconds秒)';
  }

  @override
  String get giveUpTitle => 'やめますか？';

  @override
  String get giveUpMessage => '5分以上集中していれば、その時間はネコの成長に反映されます。ネコは理解してくれますよ！';

  @override
  String get giveUpKeepGoing => '続ける';

  @override
  String get giveUpConfirm => 'やめる';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsGeneral => '一般';

  @override
  String get settingsAppearance => '外観';

  @override
  String get settingsNotifications => '通知';

  @override
  String get settingsNotificationFocusReminders => '集中リマインダー';

  @override
  String get settingsNotificationSubtitle => '毎日のリマインダーで目標を維持しましょう';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsLanguageSystem => 'システム既定';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageChinese => '中文';

  @override
  String get settingsThemeMode => 'テーマモード';

  @override
  String get settingsThemeModeSystem => 'システム';

  @override
  String get settingsThemeModeLight => 'ライト';

  @override
  String get settingsThemeModeDark => 'ダーク';

  @override
  String get settingsThemeColor => 'テーマカラー';

  @override
  String get settingsThemeColorDynamic => 'ダイナミック';

  @override
  String get settingsThemeColorDynamicSubtitle => '壁紙の色を使用';

  @override
  String get settingsAiModel => 'AIモデル';

  @override
  String get settingsAiFeatures => 'AI機能';

  @override
  String get settingsAiSubtitle => 'オンデバイスAIによるネコ日記とチャットを有効にする';

  @override
  String get settingsAbout => 'アプリについて';

  @override
  String get settingsVersion => 'バージョン';

  @override
  String get settingsLicenses => 'ライセンス';

  @override
  String get settingsAccount => 'アカウント';

  @override
  String get settingsDownloadModel => 'モデルをダウンロード (1.2 GB)';

  @override
  String get settingsDeleteModel => 'モデルを削除';

  @override
  String get settingsDeleteModelTitle => 'モデルを削除しますか？';

  @override
  String get settingsDeleteModelMessage =>
      'ダウンロード済みのAIモデル (1.2 GB) を削除します。後で再ダウンロードできます。';

  @override
  String get logoutTitle => 'ログアウトしますか？';

  @override
  String get logoutMessage => '本当にログアウトしますか？';

  @override
  String get deleteAccountTitle => 'アカウントを削除しますか？';

  @override
  String get deleteAccountMessage => 'アカウントとすべてのデータが完全に削除されます。この操作は取り消せません。';

  @override
  String get deleteAccountWarning => 'この操作は取り消せません';

  @override
  String get profileTitle => 'プロフィール';

  @override
  String get profileYourJourney => 'あなたの軌跡';

  @override
  String get profileTotalFocus => '合計集中時間';

  @override
  String get profileTotalCats => 'ネコの数';

  @override
  String get profileBestStreak => '最長連続日数';

  @override
  String get profileCatAlbum => 'ネコアルバム';

  @override
  String profileCatAlbumCount(int count) {
    return '$count匹';
  }

  @override
  String profileSeeAll(int count) {
    return 'すべてのネコを見る ($count匹)';
  }

  @override
  String get profileGraduated => '卒業済み';

  @override
  String get profileSettings => '設定';

  @override
  String get habitDetailStreak => '連続日数';

  @override
  String get habitDetailBestStreak => '最長';

  @override
  String get habitDetailTotalMinutes => '合計';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonConfirm => '確認';

  @override
  String get commonSave => '保存';

  @override
  String get commonDelete => '削除';

  @override
  String get commonEdit => '編集';

  @override
  String get commonDone => '完了';

  @override
  String get commonDismiss => '閉じる';

  @override
  String get commonEnable => '有効にする';

  @override
  String get commonLoading => '読み込み中...';

  @override
  String get commonError => 'エラーが発生しました';

  @override
  String get commonRetry => '再試行';

  @override
  String get commonResume => '再開';

  @override
  String get commonPause => '一時停止';

  @override
  String get commonLogOut => 'ログアウト';

  @override
  String get commonDeleteAccount => 'アカウントを削除';

  @override
  String get commonYes => 'はい';

  @override
  String get testChatTitle => 'AIモデルをテスト';

  @override
  String get testChatLoadingModel => 'モデルを読み込み中...';

  @override
  String get testChatModelLoaded => 'モデルを読み込みました';

  @override
  String get testChatErrorLoading => 'モデルの読み込みエラー';

  @override
  String get testChatCouldNotLoad => 'モデルを読み込めませんでした';

  @override
  String get testChatFailedToLoad => 'モデルの読み込みに失敗しました';

  @override
  String get testChatUnknownError => '不明なエラー';

  @override
  String get testChatFileCorrupted => 'モデルファイルが破損または不完全です。再ダウンロードしてください。';

  @override
  String get testChatRedownload => '再ダウンロード';

  @override
  String get testChatModelReady => 'モデル準備完了';

  @override
  String get testChatSendToTest => 'メッセージを送信してAIモデルをテストしてください。';

  @override
  String get testChatGenerating => '生成中...';

  @override
  String get testChatTypeMessage => 'メッセージを入力...';

  @override
  String get settingsAiPrivacyBadge => 'オンデバイスAI搭載 — すべての処理はローカルで実行されます';

  @override
  String get settingsAiWhatYouGet => '利用できる機能:';

  @override
  String get settingsAiFeatureDiary => 'Hachimi日記 — あなたのネコが毎日日記を書きます';

  @override
  String get settingsAiFeatureChat => 'ネコチャット — ネコと会話しましょう';

  @override
  String get settingsRedownload => '再ダウンロード';

  @override
  String get settingsTestModel => 'モデルをテスト';

  @override
  String get settingsStatusDownloading => 'ダウンロード中';

  @override
  String get settingsStatusReady => '準備完了';

  @override
  String get settingsStatusError => 'エラー';

  @override
  String get settingsStatusLoading => '読み込み中';

  @override
  String get settingsStatusNotDownloaded => '未ダウンロード';

  @override
  String get settingsStatusDisabled => '無効';

  @override
  String get catDetailNotFound => 'ネコが見つかりません';

  @override
  String get catDetailChatTooltip => 'チャット';

  @override
  String get catDetailRenameTooltip => '名前を変更';

  @override
  String get catDetailGrowthTitle => '成長の進捗';

  @override
  String catDetailTarget(int hours) {
    return '目標: $hours時間';
  }

  @override
  String get catDetailRenameTitle => 'ネコの名前を変更';

  @override
  String get catDetailNewName => '新しい名前';

  @override
  String get catDetailRenamed => '名前を変更しました！';

  @override
  String get catDetailQuestBadge => 'クエスト';

  @override
  String get catDetailEditQuest => 'クエストを編集';

  @override
  String get catDetailDailyGoal => '1日の目標';

  @override
  String get catDetailTodaysFocus => '今日の集中';

  @override
  String get catDetailTotalFocus => '合計集中時間';

  @override
  String get catDetailTargetLabel => '目標';

  @override
  String get catDetailCompletion => '達成率';

  @override
  String get catDetailCurrentStreak => '現在の連続日数';

  @override
  String get catDetailBestStreakLabel => '最長連続日数';

  @override
  String get catDetailAvgDaily => '1日の平均';

  @override
  String get catDetailDaysActive => 'アクティブ日数';

  @override
  String get catDetailCheckInDays => 'チェックイン日数';

  @override
  String get catDetailEditQuestTitle => 'クエストを編集';

  @override
  String get catDetailQuestName => 'クエスト名';

  @override
  String get catDetailDailyGoalMinutes => '1日の目標（分）';

  @override
  String get catDetailTargetTotalHours => '目標合計（時間）';

  @override
  String get catDetailQuestUpdated => 'クエストを更新しました！';

  @override
  String get catDetailTargetCompletedHint => '目標達成済み、永続モードに移行しました';

  @override
  String get catDetailDailyReminder => 'デイリーリマインダー';

  @override
  String catDetailEveryDay(String time) {
    return '毎日 $time';
  }

  @override
  String get catDetailNoReminder => 'リマインダー未設定';

  @override
  String get catDetailChange => '変更';

  @override
  String get catDetailRemoveReminder => 'リマインダーを削除';

  @override
  String get catDetailSet => '設定';

  @override
  String catDetailReminderSet(String time) {
    return '$timeにリマインダーを設定しました';
  }

  @override
  String get catDetailReminderRemoved => 'リマインダーを削除しました';

  @override
  String get catDetailDiaryTitle => 'Hachimi日記';

  @override
  String get catDetailDiaryLoading => '読み込み中...';

  @override
  String get catDetailDiaryError => '日記を読み込めませんでした';

  @override
  String get catDetailDiaryEmpty => '今日の日記はまだありません。集中セッションを完了しましょう！';

  @override
  String catDetailChatWith(String name) {
    return '$nameとチャット';
  }

  @override
  String get catDetailChatSubtitle => 'ネコと会話しましょう';

  @override
  String get catDetailActivity => 'アクティビティ';

  @override
  String get catDetailActivityError => 'アクティビティデータの読み込みに失敗しました';

  @override
  String get catDetailAccessoriesTitle => 'アクセサリー';

  @override
  String get catDetailEquipped => '装備中: ';

  @override
  String get catDetailNone => 'なし';

  @override
  String get catDetailUnequip => '外す';

  @override
  String catDetailFromInventory(int count) {
    return 'インベントリから ($count)';
  }

  @override
  String get catDetailNoAccessories => 'アクセサリーがありません。ショップへ行きましょう！';

  @override
  String catDetailEquippedItem(String name) {
    return '$nameを装備しました';
  }

  @override
  String get catDetailUnequipped => '装備を外しました';

  @override
  String catDetailAbout(String name) {
    return '$nameについて';
  }

  @override
  String get catDetailAppearanceDetails => '外見の詳細';

  @override
  String get catDetailStatus => 'ステータス';

  @override
  String get catDetailAdopted => '引き取り済み';

  @override
  String get catDetailFurPattern => '毛柄';

  @override
  String get catDetailFurColor => '毛色';

  @override
  String get catDetailFurLength => '毛の長さ';

  @override
  String get catDetailEyes => '目';

  @override
  String get catDetailWhitePatches => '白い斑点';

  @override
  String get catDetailPatchesTint => '斑点の色合い';

  @override
  String get catDetailTint => '色合い';

  @override
  String get catDetailPoints => 'ポイント模様';

  @override
  String get catDetailVitiligo => '白斑';

  @override
  String get catDetailTortoiseshell => '三毛';

  @override
  String get catDetailTortiePattern => '三毛柄';

  @override
  String get catDetailTortieColor => '三毛色';

  @override
  String get catDetailSkin => '肌';

  @override
  String get offlineMessage => 'オフラインです — 再接続時に変更が同期されます';

  @override
  String get offlineModeLabel => 'オフラインモード';

  @override
  String habitTodayMinutes(int count) {
    return '今日: $count分';
  }

  @override
  String get habitDeleteTooltip => '習慣を削除';

  @override
  String get heatmapActiveDays => 'アクティブ日数';

  @override
  String get heatmapTotal => '合計';

  @override
  String get heatmapRate => '達成率';

  @override
  String get heatmapLess => '少ない';

  @override
  String get heatmapMore => '多い';

  @override
  String get accessoryEquipped => '装備中';

  @override
  String get accessoryOwned => '所持中';

  @override
  String get pickerMinUnit => '分';

  @override
  String get settingsBackgroundAnimation => 'アニメーション背景';

  @override
  String get settingsBackgroundAnimationSubtitle => 'メッシュグラデーションと浮遊パーティクル';

  @override
  String get personalityLazy => 'のんびり屋';

  @override
  String get personalityCurious => '好奇心旺盛';

  @override
  String get personalityPlayful => '遊び好き';

  @override
  String get personalityShy => '恥ずかしがり屋';

  @override
  String get personalityBrave => '勇敢';

  @override
  String get personalityClingy => '甘えん坊';

  @override
  String get personalityFlavorLazy => '1日23時間お昼寝します。残りの1時間も…お昼寝です。';

  @override
  String get personalityFlavorCurious => 'もう何でもクンクン嗅ぎ回っています！';

  @override
  String get personalityFlavorPlayful => '蝶々を追いかけるのが止まりません！';

  @override
  String get personalityFlavorShy => '箱からちらっと覗くまで3分かかりました…';

  @override
  String get personalityFlavorBrave => '箱を開ける前に飛び出してきました！';

  @override
  String get personalityFlavorClingy => 'すぐにゴロゴロ鳴り始めて離れません。';

  @override
  String get moodHappy => 'ハッピー';

  @override
  String get moodNeutral => 'ふつう';

  @override
  String get moodLonely => 'さみしい';

  @override
  String get moodMissing => '会いたい';

  @override
  String get moodMsgLazyHappy => 'にゃ〜！ゆっくりお昼寝の時間…';

  @override
  String get moodMsgCuriousHappy => '今日は何を探検するの？';

  @override
  String get moodMsgPlayfulHappy => 'にゃ〜！お仕事がんばろ！';

  @override
  String get moodMsgShyHappy => '…き、来てくれてうれしい。';

  @override
  String get moodMsgBraveHappy => '今日も一緒に頑張ろう！';

  @override
  String get moodMsgClingyHappy => 'やった！おかえり！もう行かないで！';

  @override
  String get moodMsgLazyNeutral => 'ふぁぁ…あ、やぁ…';

  @override
  String get moodMsgCuriousNeutral => 'んー、あれは何だろう？';

  @override
  String get moodMsgPlayfulNeutral => '遊ぶ？…まぁ、あとでもいいか…';

  @override
  String get moodMsgShyNeutral => '…そっと覗く…';

  @override
  String get moodMsgBraveNeutral => 'いつも通り、見張り中。';

  @override
  String get moodMsgClingyNeutral => 'ずっと待ってたよ…';

  @override
  String get moodMsgLazyLonely => 'お昼寝もさみしいにゃ…';

  @override
  String get moodMsgCuriousLonely => 'いつ帰ってくるのかなぁ…';

  @override
  String get moodMsgPlayfulLonely => '一人じゃおもちゃも楽しくない…';

  @override
  String get moodMsgShyLonely => '…静かに丸まる…';

  @override
  String get moodMsgBraveLonely => '待ち続けるよ。ぼくは勇敢だから。';

  @override
  String get moodMsgClingyLonely => 'どこに行っちゃったの… 🥺';

  @override
  String get moodMsgLazyMissing => '…片目だけそっと開ける…';

  @override
  String get moodMsgCuriousMissing => '何かあったのかな…？';

  @override
  String get moodMsgPlayfulMissing => 'お気に入りのおもちゃ、とっておいたよ…';

  @override
  String get moodMsgShyMissing => '…隠れてるけど、ドアをじっと見てる…';

  @override
  String get moodMsgBraveMissing => 'きっと帰ってくる。信じてるよ。';

  @override
  String get moodMsgClingyMissing => 'すごく会いたいよ…お願い、帰ってきて。';

  @override
  String get peltTypeTabby => 'クラシックタビー縞';

  @override
  String get peltTypeTicked => 'ティックドアグーチ柄';

  @override
  String get peltTypeMackerel => 'マッカレルタビー';

  @override
  String get peltTypeClassic => 'クラシック渦巻き柄';

  @override
  String get peltTypeSokoke => 'ソコケマーブル柄';

  @override
  String get peltTypeAgouti => 'アグーチティックド';

  @override
  String get peltTypeSpeckled => 'スペックルド';

  @override
  String get peltTypeRosette => 'ロゼットスポット';

  @override
  String get peltTypeSingleColour => '単色';

  @override
  String get peltTypeTwoColour => 'ツートン';

  @override
  String get peltTypeSmoke => 'スモーク';

  @override
  String get peltTypeSinglestripe => '一本縞';

  @override
  String get peltTypeBengal => 'ベンガル柄';

  @override
  String get peltTypeMarbled => 'マーブル柄';

  @override
  String get peltTypeMasked => 'マスクフェイス';

  @override
  String get peltColorWhite => 'ホワイト';

  @override
  String get peltColorPaleGrey => 'ペールグレー';

  @override
  String get peltColorSilver => 'シルバー';

  @override
  String get peltColorGrey => 'グレー';

  @override
  String get peltColorDarkGrey => 'ダークグレー';

  @override
  String get peltColorGhost => 'ゴーストグレー';

  @override
  String get peltColorBlack => 'ブラック';

  @override
  String get peltColorCream => 'クリーム';

  @override
  String get peltColorPaleGinger => 'ペールジンジャー';

  @override
  String get peltColorGolden => 'ゴールデン';

  @override
  String get peltColorGinger => 'ジンジャー';

  @override
  String get peltColorDarkGinger => 'ダークジンジャー';

  @override
  String get peltColorSienna => 'シエナ';

  @override
  String get peltColorLightBrown => 'ライトブラウン';

  @override
  String get peltColorLilac => 'ライラック';

  @override
  String get peltColorBrown => 'ブラウン';

  @override
  String get peltColorGoldenBrown => 'ゴールデンブラウン';

  @override
  String get peltColorDarkBrown => 'ダークブラウン';

  @override
  String get peltColorChocolate => 'チョコレート';

  @override
  String get eyeColorYellow => 'イエロー';

  @override
  String get eyeColorAmber => 'アンバー';

  @override
  String get eyeColorHazel => 'ヘーゼル';

  @override
  String get eyeColorPaleGreen => 'ペールグリーン';

  @override
  String get eyeColorGreen => 'グリーン';

  @override
  String get eyeColorBlue => 'ブルー';

  @override
  String get eyeColorDarkBlue => 'ダークブルー';

  @override
  String get eyeColorBlueYellow => 'ブルーイエロー';

  @override
  String get eyeColorBlueGreen => 'ブルーグリーン';

  @override
  String get eyeColorGrey => 'グレー';

  @override
  String get eyeColorCyan => 'シアン';

  @override
  String get eyeColorEmerald => 'エメラルド';

  @override
  String get eyeColorHeatherBlue => 'ヘザーブルー';

  @override
  String get eyeColorSunlitIce => 'サンリットアイス';

  @override
  String get eyeColorCopper => 'コッパー';

  @override
  String get eyeColorSage => 'セージ';

  @override
  String get eyeColorCobalt => 'コバルト';

  @override
  String get eyeColorPaleBlue => 'ペールブルー';

  @override
  String get eyeColorBronze => 'ブロンズ';

  @override
  String get eyeColorSilver => 'シルバー';

  @override
  String get eyeColorPaleYellow => 'ペールイエロー';

  @override
  String eyeDescNormal(String color) {
    return '$colorの目';
  }

  @override
  String eyeDescHeterochromia(String primary, String secondary) {
    return 'オッドアイ ($primary / $secondary)';
  }

  @override
  String get skinColorPink => 'ピンク';

  @override
  String get skinColorRed => 'レッド';

  @override
  String get skinColorBlack => 'ブラック';

  @override
  String get skinColorDark => 'ダーク';

  @override
  String get skinColorDarkBrown => 'ダークブラウン';

  @override
  String get skinColorBrown => 'ブラウン';

  @override
  String get skinColorLightBrown => 'ライトブラウン';

  @override
  String get skinColorDarkGrey => 'ダークグレー';

  @override
  String get skinColorGrey => 'グレー';

  @override
  String get skinColorDarkSalmon => 'ダークサーモン';

  @override
  String get skinColorSalmon => 'サーモン';

  @override
  String get skinColorPeach => 'ピーチ';

  @override
  String get furLengthLonghair => '長毛';

  @override
  String get furLengthShorthair => '短毛';

  @override
  String get whiteTintOffwhite => 'オフホワイト';

  @override
  String get whiteTintCream => 'クリーム';

  @override
  String get whiteTintDarkCream => 'ダーククリーム';

  @override
  String get whiteTintGray => 'グレー';

  @override
  String get whiteTintPink => 'ピンク';

  @override
  String notifReminderTitle(String catName) {
    return '$catNameが会いたがっています！';
  }

  @override
  String notifReminderBody(String habitName) {
    return '$habitNameの時間です — ネコが待っています！';
  }

  @override
  String notifStreakTitle(String catName) {
    return '$catNameが心配しています！';
  }

  @override
  String notifStreakBody(int streak) {
    return '$streak日連続の記録が途切れそうです。少しだけ集中して記録を守りましょう！';
  }

  @override
  String notifEvolutionTitle(String catName) {
    return '$catNameが進化しました！';
  }

  @override
  String notifEvolutionBody(String catName, String stageName) {
    return '$catNameが$stageNameに成長しました！この調子で頑張りましょう！';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours時間$minutes分';
  }

  @override
  String diaryScreenTitle(String name) {
    return '$nameの日記';
  }

  @override
  String get diaryFailedToLoad => '日記の読み込みに失敗しました';

  @override
  String get diaryEmptyTitle => 'まだ日記がありません';

  @override
  String get diaryEmptyHint => '集中セッションを完了すると、ネコが最初の日記を書きます！';

  @override
  String get focusSetupCountdown => 'カウントダウン';

  @override
  String get focusSetupStopwatch => 'ストップウォッチ';

  @override
  String get focusSetupStartFocus => '集中を開始';

  @override
  String get focusSetupQuestNotFound => 'クエストが見つかりません';

  @override
  String get checkInButtonLogMore => '時間を追加記録';

  @override
  String get checkInButtonStart => 'タイマーを開始';

  @override
  String get adoptionTitleFirst => '最初のネコを迎えよう！';

  @override
  String get adoptionTitleNew => '新しいクエスト';

  @override
  String get adoptionStepDefineQuest => 'クエストを決める';

  @override
  String get adoptionStepAdoptCat2 => 'ネコを迎える';

  @override
  String get adoptionStepNameCat2 => '名前をつける';

  @override
  String get adoptionAdopt => '迎える！';

  @override
  String get adoptionQuestPrompt => 'どんなクエストを始めたいですか？';

  @override
  String get adoptionKittenHint => '子猫があなたの目標達成をサポートします！';

  @override
  String get adoptionQuestName => 'クエスト名';

  @override
  String get adoptionQuestHint => '例: 面接の準備';

  @override
  String get adoptionTotalTarget => '目標合計時間';

  @override
  String get adoptionGrowthHint => '集中時間が増えるとネコが成長します';

  @override
  String get adoptionCustom => 'カスタム';

  @override
  String get adoptionDailyGoalLabel => '1日の集中目標';

  @override
  String get adoptionReminderLabel => 'デイリーリマインダー（任意）';

  @override
  String get adoptionReminderNone => 'なし';

  @override
  String get adoptionCustomGoalTitle => 'カスタム1日目標';

  @override
  String get adoptionMinutesPerDay => '1日あたりの分数';

  @override
  String get adoptionMinutesHint => '5 - 180';

  @override
  String get adoptionValidMinutes => '5から180の間で入力してください';

  @override
  String get adoptionCustomTargetTitle => 'カスタム目標時間';

  @override
  String get adoptionTotalHours => '合計時間';

  @override
  String get adoptionHoursHint => '10 - 2000';

  @override
  String get adoptionValidHours => '10から2000の間で入力してください';

  @override
  String get adoptionSet => '設定';

  @override
  String get adoptionChooseKitten => '子猫を選ぼう！';

  @override
  String adoptionCompanionFor(String quest) {
    return '「$quest」のパートナー';
  }

  @override
  String get adoptionRerollAll => '全部やりなおし';

  @override
  String get adoptionNameYourCat2 => 'ネコに名前をつけよう';

  @override
  String get adoptionCatName => 'ネコの名前';

  @override
  String get adoptionCatHint => '例: もち';

  @override
  String get adoptionRandomTooltip => 'ランダムな名前';

  @override
  String adoptionGrowthTarget(String quest, int hours) {
    return '「$quest」に集中するとネコが成長します！目標: $hours時間';
  }

  @override
  String get adoptionValidQuestName => 'クエスト名を入力してください';

  @override
  String get adoptionValidCatName => 'ネコの名前を入力してください';

  @override
  String adoptionError(String message) {
    return 'エラー: $message';
  }

  @override
  String get adoptionBasicInfo => '基本情報';

  @override
  String get adoptionGoals => '目標設定';

  @override
  String get adoptionUnlimitedMode => '永続モード';

  @override
  String get adoptionUnlimitedDesc => '上限なし、ずっと積み上げ';

  @override
  String get adoptionMilestoneMode => 'マイルストーンモード';

  @override
  String get adoptionMilestoneDesc => '目標を設定する';

  @override
  String get adoptionDeadlineLabel => '期限';

  @override
  String get adoptionDeadlineNone => '設定なし';

  @override
  String get adoptionReminderSection => 'リマインダー';

  @override
  String get adoptionMotivationLabel => 'モチベーション';

  @override
  String get adoptionMotivationHint => '自分を励ます言葉を書こう';

  @override
  String get adoptionMotivationSwap => '別の言葉';

  @override
  String get loginAppName => 'Hachimi';

  @override
  String get loginTagline => 'ネコを育てて、クエストを達成しよう。';

  @override
  String get loginContinueGoogle => 'Googleで続ける';

  @override
  String get loginContinueEmail => 'メールで続ける';

  @override
  String get loginAlreadyHaveAccount => 'すでにアカウントをお持ちですか？ ';

  @override
  String get loginLogIn => 'ログイン';

  @override
  String get loginWelcomeBack => 'おかえりなさい！';

  @override
  String get loginCreateAccount => 'アカウントを作成';

  @override
  String get loginEmail => 'メールアドレス';

  @override
  String get loginPassword => 'パスワード';

  @override
  String get loginConfirmPassword => 'パスワードを確認';

  @override
  String get loginValidEmail => 'メールアドレスを入力してください';

  @override
  String get loginValidEmailFormat => '有効なメールアドレスを入力してください';

  @override
  String get loginValidPassword => 'パスワードを入力してください';

  @override
  String get loginValidPasswordLength => 'パスワードは6文字以上にしてください';

  @override
  String get loginValidPasswordMatch => 'パスワードが一致しません';

  @override
  String get loginCreateAccountButton => 'アカウントを作成';

  @override
  String get loginNoAccount => 'アカウントをお持ちでないですか？ ';

  @override
  String get loginRegister => '登録';

  @override
  String get checkInTitle => '月間チェックイン';

  @override
  String get checkInDays => '日';

  @override
  String get checkInCoinsEarned => '獲得コイン';

  @override
  String get checkInAllMilestones => '全マイルストーン達成！';

  @override
  String checkInMilestoneProgress(int remaining, int bonus) {
    return 'あと$remaining日 → +$bonusコイン';
  }

  @override
  String get checkInMilestones => 'マイルストーン';

  @override
  String get checkInFullMonth => '1ヶ月達成';

  @override
  String get checkInRewardSchedule => '報酬スケジュール';

  @override
  String get checkInWeekday => '平日（月〜金）';

  @override
  String checkInWeekdayReward(int coins) {
    return '$coinsコイン/日';
  }

  @override
  String get checkInWeekend => '週末（土〜日）';

  @override
  String checkInNDays(int count) {
    return '$count日';
  }

  @override
  String get onboardTitle1 => 'Hachimiへようこそ';

  @override
  String get onboardSubtitle1 => 'ネコを育てて、クエストを達成しよう';

  @override
  String get onboardBody1 =>
      '始めるクエストごとに子猫がやってきます。\n目標に集中して、小さな子猫が\n立派なネコに育つのを見届けましょう！';

  @override
  String get onboardTitle2 => '集中してXPを獲得';

  @override
  String get onboardSubtitle2 => '時間が成長の源';

  @override
  String get onboardBody2 =>
      '集中セッションを始めるとネコがXPを獲得します。\n連続ボーナスで報酬アップ。\n1分1分が進化につながります！';

  @override
  String get onboardTitle3 => '進化を見届けよう';

  @override
  String get onboardSubtitle3 => '子猫 → シャイニー';

  @override
  String get onboardBody3 =>
      'ネコは成長とともに4つのステージを経て進化します。\nさまざまな種類を集めて、レアネコを解放し、\n居心地のよいネコ部屋を作りましょう！';

  @override
  String get onboardSkip => 'スキップ';

  @override
  String get onboardLetsGo => 'はじめよう！';

  @override
  String get onboardNext => '次へ';

  @override
  String get catRoomTitle => 'ネコハウス';

  @override
  String get catRoomInventory => 'インベントリ';

  @override
  String get catRoomShop => 'アクセサリーショップ';

  @override
  String get catRoomLoadError => 'ネコの読み込みに失敗しました';

  @override
  String get catRoomEmptyTitle => 'ネコハウスは空です';

  @override
  String get catRoomEmptySubtitle => 'クエストを始めて最初のネコを迎えましょう！';

  @override
  String get catRoomEditQuest => 'クエストを編集';

  @override
  String get catRoomRenameCat => '名前を変更';

  @override
  String get catRoomArchiveCat => 'ネコをアーカイブ';

  @override
  String get catRoomNewName => '新しい名前';

  @override
  String get catRoomRename => '名前を変更';

  @override
  String get catRoomArchiveTitle => 'ネコをアーカイブしますか？';

  @override
  String catRoomArchiveMessage(String name) {
    return '「$name」をアーカイブし、紐づいたクエストを削除します。ネコはアルバムに残ります。';
  }

  @override
  String get catRoomArchive => 'アーカイブ';

  @override
  String get addHabitTitle => '新しいクエスト';

  @override
  String get addHabitQuestName => 'クエスト名';

  @override
  String get addHabitQuestHint => '例: LeetCode練習';

  @override
  String get addHabitValidName => 'クエスト名を入力してください';

  @override
  String get addHabitTargetHours => '目標時間';

  @override
  String get addHabitTargetHint => '例: 100';

  @override
  String get addHabitValidTarget => '目標時間を入力してください';

  @override
  String get addHabitValidNumber => '有効な数値を入力してください';

  @override
  String get addHabitCreate => 'クエストを作成';

  @override
  String get addHabitHoursSuffix => '時間';

  @override
  String shopTabPlants(int count) {
    return '植物 ($count)';
  }

  @override
  String shopTabWild(int count) {
    return 'ワイルド ($count)';
  }

  @override
  String shopTabCollars(int count) {
    return '首輪 ($count)';
  }

  @override
  String get shopNoAccessories => 'アクセサリーがありません';

  @override
  String shopBuyConfirm(String name) {
    return '$nameを購入しますか？';
  }

  @override
  String get shopPurchaseButton => '購入';

  @override
  String get shopNotEnoughCoinsButton => 'コインが足りません';

  @override
  String shopPurchaseSuccess(String name) {
    return '購入しました！$nameをインベントリに追加しました';
  }

  @override
  String shopPurchaseFailed(int price) {
    return 'コインが足りません（$priceコイン必要）';
  }

  @override
  String get inventoryTitle => 'インベントリ';

  @override
  String inventoryInBox(int count) {
    return 'ボックス内 ($count)';
  }

  @override
  String get inventoryEmpty => 'インベントリは空です。\nショップでアクセサリーを手に入れましょう！';

  @override
  String inventoryEquippedOnCats(int count) {
    return '装備中のネコ ($count)';
  }

  @override
  String get inventoryNoEquipped => 'どのネコにもアクセサリーが装備されていません。';

  @override
  String get inventoryUnequip => '外す';

  @override
  String get inventoryNoActiveCats => 'アクティブなネコがいません';

  @override
  String inventoryEquipTo(String name) {
    return '$nameを装備する:';
  }

  @override
  String inventoryEquipSuccess(String name) {
    return '$nameを装備しました';
  }

  @override
  String inventoryUnequipSuccess(String catName) {
    return '$catNameの装備を外しました';
  }

  @override
  String get chatCatNotFound => 'ネコが見つかりません';

  @override
  String chatTitle(String name) {
    return '$nameとチャット';
  }

  @override
  String get chatClearHistory => '履歴を削除';

  @override
  String chatEmptyTitle(String name) {
    return '$nameに挨拶しよう！';
  }

  @override
  String get chatEmptySubtitle => 'ネコと会話を始めましょう。性格に合わせて返事をしてくれます！';

  @override
  String get chatGenerating => '生成中...';

  @override
  String get chatTypeMessage => 'メッセージを入力...';

  @override
  String get chatClearConfirmTitle => 'チャット履歴を削除しますか？';

  @override
  String get chatClearConfirmMessage => 'すべてのメッセージが削除されます。この操作は取り消せません。';

  @override
  String get chatClearButton => '削除';

  @override
  String diaryTitle(String name) {
    return '$nameの日記';
  }

  @override
  String get diaryLoadFailed => '日記の読み込みに失敗しました';

  @override
  String get diaryRetry => '再試行';

  @override
  String get diaryEmptyTitle2 => 'まだ日記がありません';

  @override
  String get diaryEmptySubtitle => '集中セッションを完了すると、ネコが最初の日記を書きます！';

  @override
  String get statsTitle => '統計';

  @override
  String get statsTotalHours => '合計時間';

  @override
  String statsTimeValue(int hours, int minutes) {
    return '$hours時間$minutes分';
  }

  @override
  String get statsBestStreak => '最長連続日数';

  @override
  String statsStreakDays(int count) {
    return '$count日';
  }

  @override
  String get statsOverallProgress => '全体の進捗';

  @override
  String statsPercentOfGoals(String percent) {
    return '全目標の$percent%';
  }

  @override
  String get statsPerQuestProgress => 'クエストごとの進捗';

  @override
  String get statsQuestLoadError => 'クエスト統計の読み込みに失敗しました';

  @override
  String get statsNoQuestData => 'クエストデータがありません';

  @override
  String get statsNoQuestHint => 'クエストを始めて進捗を確認しましょう！';

  @override
  String get statsLast30Days => '過去30日間';

  @override
  String get habitDetailQuestNotFound => 'クエストが見つかりません';

  @override
  String get habitDetailComplete => '達成';

  @override
  String get habitDetailTotalTime => '合計時間';

  @override
  String get habitDetailCurrentStreak => '現在の連続日数';

  @override
  String get habitDetailTarget => '目標';

  @override
  String habitDetailDaysUnit(int count) {
    return '$count日';
  }

  @override
  String habitDetailHoursUnit(int count) {
    return '$count時間';
  }

  @override
  String checkInBannerSuccess(int coins) {
    return '+$coinsコイン！デイリーチェックイン完了';
  }

  @override
  String checkInBannerBonus(int bonus) {
    return ' + $bonusマイルストーンボーナス！';
  }

  @override
  String get checkInBannerSemantics => 'デイリーチェックイン';

  @override
  String get checkInBannerLoading => 'チェックイン状況を読み込み中...';

  @override
  String checkInBannerPrompt(int coins) {
    return 'チェックインで+$coinsコイン';
  }

  @override
  String checkInBannerSummary(int count, int total, int coins) {
    return '$count/$total日  ·  今日+$coins';
  }

  @override
  String commonErrorWithDetail(String error) {
    return 'エラー: $error';
  }

  @override
  String get profileFallbackUser => 'ユーザー';

  @override
  String get fallbackCatName => 'ネコ';

  @override
  String get settingsLanguageTraditionalChinese => '繁體中文';

  @override
  String get settingsLanguageJapanese => '日本語';

  @override
  String get settingsLanguageKorean => '한국어';

  @override
  String get notifFocusing => '集中中…';

  @override
  String get notifInProgress => '集中セッション実行中';

  @override
  String get unitMinShort => '分';

  @override
  String get unitHourShort => '時間';

  @override
  String get weekdayMon => '月';

  @override
  String get weekdayTue => '火';

  @override
  String get weekdayWed => '水';

  @override
  String get weekdayThu => '木';

  @override
  String get weekdayFri => '金';

  @override
  String get weekdaySat => '土';

  @override
  String get weekdaySun => '日';

  @override
  String get statsTotalSessions => 'セッション数';

  @override
  String get statsTotalHabits => 'タスク数';

  @override
  String get statsActiveDays => 'アクティブ日数';

  @override
  String get statsWeeklyTrend => '週間トレンド';

  @override
  String get statsRecentSessions => '最近の集中';

  @override
  String get statsViewAllHistory => '全履歴を見る';

  @override
  String get historyTitle => '集中履歴';

  @override
  String get historyFilterAll => 'すべて';

  @override
  String historySessionCount(int count) {
    return '$count 回';
  }

  @override
  String historyTotalMinutes(int minutes) {
    return '$minutes 分';
  }

  @override
  String get historyNoSessions => '集中記録がありません';

  @override
  String get historyNoSessionsHint => '集中セッションを完了すると、ここに表示されます';

  @override
  String get historyLoadMore => 'もっと読み込む';

  @override
  String get sessionCompleted => '完了';

  @override
  String get sessionAbandoned => '中断';

  @override
  String get sessionInterrupted => '中断された';

  @override
  String get sessionCountdown => 'カウントダウン';

  @override
  String get sessionStopwatch => 'ストップウォッチ';

  @override
  String get historyDateGroupToday => '今日';

  @override
  String get historyDateGroupYesterday => '昨日';

  @override
  String get historyLoadError => '履歴の読み込みに失敗しました';

  @override
  String get historySelectMonth => '月を選択';

  @override
  String get historyAllMonths => 'すべての月';

  @override
  String get historyAllHabits => 'すべて';

  @override
  String get homeTabAchievements => '実績';

  @override
  String get achievementTitle => '実績';

  @override
  String get achievementTabOverview => '概要';

  @override
  String get achievementTabQuest => 'クエスト';

  @override
  String get achievementTabStreak => '連続';

  @override
  String get achievementTabCat => '猫';

  @override
  String get achievementTabPersist => '継続';

  @override
  String get achievementSummaryTitle => '実績の進捗';

  @override
  String achievementUnlockedCount(int count) {
    return '$count個解除済み';
  }

  @override
  String achievementTotalCoins(int coins) {
    return '$coinsコイン獲得';
  }

  @override
  String get achievementUnlocked => '実績解除！';

  @override
  String get achievementHidden => '???';

  @override
  String get achievementHiddenDesc => 'これは隠し実績です';

  @override
  String achievementPersistDesc(int days) {
    return '任意のクエストで$days日チェックイン';
  }

  @override
  String achievementTitleCount(int count) {
    return '$count個の称号を解除';
  }

  @override
  String get growthPathTitle => '成長の道';

  @override
  String get growthPathKitten => '新しい旅の始まり';

  @override
  String get growthPathAdolescent => '基礎を築く';

  @override
  String get growthPathAdult => 'スキルの定着';

  @override
  String get growthPathSenior => '深い習熟';

  @override
  String get growthPathTip =>
      '研究によると、20時間の集中練習で新しいスキルの基礎を築くことができます —— Josh Kaufman';

  @override
  String achievementCelebrationCoins(int count) {
    return '+$count コイン';
  }

  @override
  String achievementCelebrationTitle(String title) {
    return '称号獲得：$title';
  }

  @override
  String get achievementCelebrationDismiss => 'すごい！';

  @override
  String get achievementCelebrationSkipAll => 'すべてスキップ';

  @override
  String achievementCelebrationCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String get reminderModeDaily => '毎日';

  @override
  String get reminderModeWeekdays => '平日';

  @override
  String get reminderModeMonday => '月曜日';

  @override
  String get reminderModeTuesday => '火曜日';

  @override
  String get reminderModeWednesday => '水曜日';

  @override
  String get reminderModeThursday => '木曜日';

  @override
  String get reminderModeFriday => '金曜日';

  @override
  String get reminderModeSaturday => '土曜日';

  @override
  String get reminderModeSunday => '日曜日';

  @override
  String get reminderPickerTitle => 'リマインダー時間を選択';

  @override
  String get reminderHourUnit => '時';

  @override
  String get reminderMinuteUnit => '分';

  @override
  String get reminderAddMore => 'リマインダーを追加';

  @override
  String get reminderMaxReached => '最大 5 件のリマインダー';

  @override
  String get reminderConfirm => '確認';

  @override
  String reminderNotificationTitle(String catName) {
    return '$catNameが会いたがってるよ！';
  }

  @override
  String reminderNotificationBody(String habitName) {
    return '$habitNameの時間だよ。猫が待ってるよ！';
  }

  @override
  String get deleteAccountDataWarning => '以下のすべてのデータが完全に削除されます：';

  @override
  String get deleteAccountQuests => 'クエスト';

  @override
  String get deleteAccountCats => '猫';

  @override
  String get deleteAccountHours => '集中時間';

  @override
  String get deleteAccountIrreversible => 'この操作は取り消せません';

  @override
  String get deleteAccountContinue => '続ける';

  @override
  String get deleteAccountConfirmTitle => '削除を確認';

  @override
  String get deleteAccountTypeDelete => 'DELETE と入力してアカウント削除を確認：';

  @override
  String get deleteAccountAuthCancelled => '認証がキャンセルされました';

  @override
  String deleteAccountAuthFailed(String error) {
    return '認証に失敗しました：$error';
  }

  @override
  String get deleteAccountProgress => 'アカウントを削除中...';

  @override
  String get deleteAccountSuccess => 'アカウントが削除されました';
}
