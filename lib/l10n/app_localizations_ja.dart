// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class SJa extends S {
  SJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Hachimi - Light Up My Innerverse';

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
  String get focusCompleteDiarySkipped => '日記をスキップしました';

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
  String get settingsAbout => 'アプリについて';

  @override
  String get settingsVersion => 'バージョン';

  @override
  String get settingsLicenses => 'ライセンス';

  @override
  String get settingsAccount => 'アカウント';

  @override
  String get logoutTitle => 'ログアウトしますか？';

  @override
  String get logoutMessage => '本当にログアウトしますか？';

  @override
  String get loggingOut => 'ログアウト中...';

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
  String get profileTotalQuests => 'クエスト';

  @override
  String get profileEditName => '名前を変更';

  @override
  String get profileDisplayName => '表示名';

  @override
  String get profileChooseAvatar => 'アバターを選択';

  @override
  String get profileSaved => '保存しました';

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
  String chatDailyRemaining(int count) {
    return '今日残り $count 件のメッセージ';
  }

  @override
  String get chatDailyLimitReached => '本日のメッセージ上限に達しました';

  @override
  String get aiTemporarilyUnavailable => 'AI 機能は一時的に利用できません';

  @override
  String get catDetailNotFound => 'ネコが見つかりません';

  @override
  String get catDetailLoadError => '猫データの読み込みに失敗しました';

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
  String get settingsUiStyle => 'UIスタイル';

  @override
  String get settingsUiStyleMaterial => 'Material 3';

  @override
  String get settingsUiStyleRetroPixel => 'レトロピクセル';

  @override
  String get settingsUiStyleMaterialSubtitle => 'モダンな丸角マテリアルデザイン';

  @override
  String get settingsUiStyleRetroPixelSubtitle => 'あたたかいピクセルアートスタイル';

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
  String get adoptionTotalTarget => '目標合計（時間）';

  @override
  String get adoptionGrowthHint => '集中時間が増えるとネコが成長します';

  @override
  String get adoptionCustom => 'カスタム';

  @override
  String get adoptionDailyGoalLabel => '1日の集中目標（分）';

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
  String get adoptionMotivationLabel => 'メモ';

  @override
  String get adoptionMotivationHint => 'メモを書く...';

  @override
  String get adoptionMotivationSwap => 'ランダム入力';

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
  String get onboardTitle1 => '仲間に会おう';

  @override
  String get onboardSubtitle1 => 'すべての冒険は子猫から始まる';

  @override
  String get onboardBody1 => '目標を決めて、子猫を迎えよう。\n集中すれば、ネコが成長していくよ！';

  @override
  String get onboardTitle2 => '集中、成長、進化';

  @override
  String get onboardSubtitle2 => '4つの成長ステージ';

  @override
  String get onboardBody2 => '集中した1分1分がネコの進化を助けます。\n小さな子猫から立派なシニアネコへ！';

  @override
  String get onboardTitle3 => 'ネコ部屋を作ろう';

  @override
  String get onboardSubtitle3 => 'ユニークなネコを集めよう';

  @override
  String get onboardBody3 => 'クエストごとにユニークな見た目のネコが仲間入り。\nみんな集めて、夢のコレクションを作ろう！';

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
  String catRoomAlbumSection(int count) {
    return 'アルバム（$count）';
  }

  @override
  String get catRoomReactivateCat => '再アクティブ化';

  @override
  String get catRoomReactivateTitle => 'ネコを再アクティブ化しますか？';

  @override
  String catRoomReactivateMessage(String name) {
    return '「$name」と紐づいたクエストをネコハウスに戻します。';
  }

  @override
  String get catRoomReactivate => '再アクティブ化';

  @override
  String get catRoomArchivedLabel => 'アーカイブ済み';

  @override
  String catRoomArchiveSuccess(String name) {
    return '「$name」をアーカイブしました';
  }

  @override
  String catRoomReactivateSuccess(String name) {
    return '「$name」を再アクティブ化しました';
  }

  @override
  String get catRoomArchiveError => '猫のアーカイブに失敗しました';

  @override
  String get catRoomReactivateError => '猫の復帰に失敗しました';

  @override
  String get catRoomArchiveLoadError => 'アーカイブ済みの猫の読み込みに失敗しました';

  @override
  String get catRoomRenameError => '猫の名前変更に失敗しました';

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
  String get chatSend => '送信';

  @override
  String get chatStop => '停止';

  @override
  String get chatErrorMessage => 'Failed to send message. Tap to retry.';

  @override
  String get chatRetry => 'Retry';

  @override
  String get chatErrorGeneric => 'エラーが発生しました。再試行してください';

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
  String get achievementAwesome => 'すばらしい！';

  @override
  String get achievementIncredible => '信じられない！';

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
  String achievementUnlockedAt(String date) {
    return '$date に解除';
  }

  @override
  String get achievementLocked => 'まだ解除されていません';

  @override
  String achievementRewardCoins(int count) {
    return '+$count コイン';
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

  @override
  String get drawerGuestLoginSubtitle => 'データ同期、AI機能を解除';

  @override
  String get drawerGuestSignIn => 'ログイン';

  @override
  String get drawerMilestones => 'マイルストーン';

  @override
  String drawerMilestoneFocus(int hours, int minutes) {
    return '合計集中：${hours}h ${minutes}m';
  }

  @override
  String drawerMilestoneCats(int count) {
    return 'ネコ家族：$count匹';
  }

  @override
  String drawerMilestoneQuests(int count) {
    return '進行中クエスト：$count個';
  }

  @override
  String get drawerMySection => 'マイ';

  @override
  String get drawerSessionHistory => '集中履歴';

  @override
  String get drawerCheckInCalendar => 'チェックインカレンダー';

  @override
  String get drawerAccountSection => 'アカウント';

  @override
  String get settingsResetData => 'すべてのデータをリセット';

  @override
  String get settingsResetDataTitle => 'すべてのデータをリセットしますか？';

  @override
  String get settingsResetDataMessage =>
      'ローカルデータがすべて削除され、ウェルカム画面に戻ります。この操作は取り消せません。';

  @override
  String get guestUpgradeTitle => 'データを保護する';

  @override
  String get guestUpgradeMessage =>
      'アカウント連携で進捗をバックアップし、AI日記やチャット機能を解除し、デバイス間で同期できます。';

  @override
  String get guestUpgradeLinkButton => 'アカウント連携';

  @override
  String get guestUpgradeLater => 'あとで';

  @override
  String get loginLinkTagline => 'アカウントを連携してデータを保護する';

  @override
  String get aiTeaserTitle => 'ネコ日記';

  @override
  String aiTeaserPreview(String catName) {
    return '今日もご主人と一緒に勉強した…$catNameはまた賢くなった気がするにゃ〜';
  }

  @override
  String aiTeaserCta(String catName) {
    return 'アカウントを連携して、$catNameが何を言いたいか見てみよう';
  }

  @override
  String get authErrorEmailInUse => 'このメールアドレスは既に登録されています';

  @override
  String get authErrorWrongPassword => 'メールアドレスまたはパスワードが正しくありません';

  @override
  String get authErrorUserNotFound => 'このメールアドレスのアカウントが見つかりません';

  @override
  String get authErrorTooManyRequests => '試行回数が多すぎます。しばらくしてからお試しください';

  @override
  String get authErrorNetwork => 'ネットワークエラーです。接続を確認してください';

  @override
  String get authErrorAdminRestricted => 'ログインは一時的に制限されています';

  @override
  String get authErrorWeakPassword => 'パスワードが弱すぎます。6文字以上にしてください';

  @override
  String get authErrorGeneric => '問題が発生しました。もう一度お試しください';

  @override
  String get deleteAccountReauthEmail => '続けるにはパスワードを入力してください';

  @override
  String get deleteAccountReauthPasswordHint => 'パスワード';

  @override
  String get deleteAccountError => '問題が発生しました。あとでもう一度お試しください。';

  @override
  String get deleteAccountPermissionError => '権限エラーです。ログアウトしてから再度ログインしてください。';

  @override
  String get deleteAccountNetworkError => 'インターネットに接続されていません。ネットワークを確認してください。';

  @override
  String get deleteAccountRetainedData => '利用統計とクラッシュレポートは削除できません。';

  @override
  String get deleteAccountStepCloud => 'クラウドデータを削除中...';

  @override
  String get deleteAccountStepLocal => 'ローカルデータを削除中...';

  @override
  String get deleteAccountStepDone => '完了';

  @override
  String get deleteAccountQueued => 'ローカルデータは削除されました。クラウド削除はオンライン復帰後に自動完了します。';

  @override
  String get deleteAccountPending => 'アカウント削除処理が保留中です。オンライン状態を維持してください。';

  @override
  String get deleteAccountAbandon => 'やり直す';

  @override
  String get archiveConflictTitle => '保持するアーカイブを選択';

  @override
  String get archiveConflictMessage => 'ローカルとクラウドの両方にデータがあります。保持する方を選択してください：';

  @override
  String get archiveConflictLocal => 'ローカルアーカイブ';

  @override
  String get archiveConflictCloud => 'クラウドアーカイブ';

  @override
  String get archiveConflictKeepCloud => 'クラウドを保持';

  @override
  String get archiveConflictKeepLocal => 'ローカルを保持';

  @override
  String get loginShowPassword => 'パスワードを表示';

  @override
  String get loginHidePassword => 'パスワードを非表示';

  @override
  String get errorGeneric => '問題が発生しました。しばらくしてからもう一度お試しください';

  @override
  String get errorCreateHabit => '習慣の作成に失敗しました。もう一度お試しください';

  @override
  String get loginForgotPassword => 'パスワードを忘れた場合';

  @override
  String get loginForgotPasswordTitle => 'パスワードをリセット';

  @override
  String get loginSendResetEmail => 'リセットメールを送信';

  @override
  String get loginResetEmailSent => 'パスワードリセットメールを送信しました';

  @override
  String get authErrorUserDisabled => 'このアカウントは無効化されています';

  @override
  String get authErrorInvalidEmail => '有効なメールアドレスを入力してください';

  @override
  String get authErrorRequiresRecentLogin => '続行するには再度ログインしてください';

  @override
  String get commonCopyId => 'ID をコピー';

  @override
  String get adoptionClearDeadline => '期限をクリア';

  @override
  String get commonIdCopied => 'ID をコピーしました';

  @override
  String get pickerDurationLabel => '時間選択';

  @override
  String pickerMinutesValue(int count) {
    return '$count 分';
  }

  @override
  String a11yCatImage(String name) {
    return '猫の$name';
  }

  @override
  String a11yCatTapToInteract(String name) {
    return '$name、タップして触れ合う';
  }

  @override
  String a11yProgressPercent(int percent) {
    return '$percent% 完了';
  }

  @override
  String a11yStreakActiveDays(int count) {
    return '$count 日アクティブ';
  }

  @override
  String get a11yOfflineStatus => 'オフラインモード';

  @override
  String a11yAchievementUnlocked(String name) {
    return '実績解除：$name';
  }

  @override
  String get calendarCheckedIn => 'チェックイン済み';

  @override
  String get calendarToday => '今日';

  @override
  String a11yEquipToCat(Object name) {
    return '$nameに装備';
  }

  @override
  String a11yRegenerateCat(Object name) {
    return '$nameを再生成';
  }

  @override
  String a11yTimerDisplay(Object time) {
    return 'タイマー：$time';
  }

  @override
  String a11yOnboardingPage(Object current, Object total) {
    return '$totalページ中$currentページ';
  }

  @override
  String a11yEditDisplayName(Object name) {
    return '表示名を編集：$name';
  }

  @override
  String get routeNotFound => 'ページが見つかりません';

  @override
  String get routeGoHome => 'ホームへ';

  @override
  String get a11yError => 'エラー';

  @override
  String get a11yDeadline => '締切';

  @override
  String get a11yReminder => 'リマインダー';

  @override
  String get a11yFocusMeditation => '集中瞑想';

  @override
  String get a11yUnlocked => 'アンロック済み';

  @override
  String get a11ySelected => '選択済み';

  @override
  String get a11yDynamicWallpaperColor => 'ダイナミック壁紙カラー';

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
    return '夜ふかしだね、$name';
  }

  @override
  String greetingMorning(String name) {
    return 'おはよう、$name';
  }

  @override
  String greetingAfternoon(String name) {
    return 'こんにちは、$name';
  }

  @override
  String greetingEvening(String name) {
    return 'こんばんは、$name';
  }

  @override
  String get greetingLateNightNoName => '夜ふかしだね';

  @override
  String get greetingMorningNoName => 'おはよう';

  @override
  String get greetingAfternoonNoName => 'こんにちは';

  @override
  String get greetingEveningNoName => 'こんばんは';

  @override
  String get journeyTitle => 'ジャーニー';

  @override
  String get journeySegmentWeek => '今週';

  @override
  String get journeySegmentMonth => '今月';

  @override
  String get journeySegmentYear => '年間';

  @override
  String get journeySegmentExplore => '探索';

  @override
  String get journeyMonthlyView => '月間ビュー';

  @override
  String get journeyYearlyView => '年間ビュー';

  @override
  String get journeyExploreActivities => '探索アクティビティ';

  @override
  String get journeyEditMonthlyPlan => '月間プランを編集';

  @override
  String get journeyEditYearlyPlan => '年間プランを編集';

  @override
  String get quickLightTitle => '今日のひとこと';

  @override
  String get quickLightHint => '今日の気分をひとこと...';

  @override
  String get quickLightRecord => '記録';

  @override
  String get quickLightSaveSuccess => '記録しました';

  @override
  String get quickLightSaveError => '保存に失敗しました。もう一度お試しください';

  @override
  String get habitSnapshotTitle => '今日の習慣';

  @override
  String get habitSnapshotEmpty => 'まだ習慣がありません。ジャーニーで設定できます';

  @override
  String get habitSnapshotLoadError => '読み込みに失敗しました';

  @override
  String get worryJarTitle => '心配ごとの瓶';

  @override
  String get worryJarLoadError => '読み込みに失敗しました';

  @override
  String get weeklyReviewEmpty => '今週の幸せな瞬間を記録しましょう';

  @override
  String get weeklyReviewHappyMoments => '幸せな瞬間';

  @override
  String get weeklyReviewLoadError => '読み込みに失敗しました';

  @override
  String get weeklyPlanCardTitle => '今週のプラン';

  @override
  String weeklyPlanItemCount(int count) {
    return '$count 件';
  }

  @override
  String get weeklyPlanEmpty => '今週のプランを立てよう';

  @override
  String get weekMoodTitle => '今週の気分';

  @override
  String get weekMoodLoadError => '気分の読み込みに失敗しました';

  @override
  String featureLockedDaysRemaining(int remaining) {
    return 'あと $remaining 日記録すると解放されます';
  }

  @override
  String get featureLockedSoon => 'もうすぐ解放';

  @override
  String get weeklyPlanScreenTitle => '今週のプラン';

  @override
  String get weeklyPlanSave => '保存';

  @override
  String get weeklyPlanSaveSuccess => '保存しました';

  @override
  String get weeklyPlanSaveError => '保存に失敗しました';

  @override
  String get weeklyPlanOneLine => '今週の自分にひとこと';

  @override
  String get weeklyPlanOneLineHint => '今週は...';

  @override
  String get weeklyPlanUrgentImportant => '緊急かつ重要';

  @override
  String get weeklyPlanImportantNotUrgent => '重要だが緊急でない';

  @override
  String get weeklyPlanUrgentNotImportant => '緊急だが重要でない';

  @override
  String get weeklyPlanNotUrgentNotImportant => '緊急でも重要でもない';

  @override
  String get weeklyPlanAddHint => '追加...';

  @override
  String get weeklyPlanMustDo => '必ずやる';

  @override
  String get weeklyPlanShouldDo => 'やるべき';

  @override
  String get weeklyPlanNeedToDo => 'やった方がいい';

  @override
  String get weeklyPlanWantToDo => 'やりたい';

  @override
  String monthlyCalendarYearMonth(int year, int month) {
    return '$year年$month月';
  }

  @override
  String get monthlyCalendarLoadError => '読み込みに失敗しました';

  @override
  String get monthlyGoalsTitle => '今月の目標';

  @override
  String monthlyGoalHint(int index) {
    return '目標 $index';
  }

  @override
  String get monthlySaveError => '保存に失敗しました';

  @override
  String get monthlyMemoryTitle => '今月の思い出';

  @override
  String get monthlyMemoryHint => '今月いちばん素敵な思い出は...';

  @override
  String get monthlyAchievementTitle => '今月の達成';

  @override
  String get monthlyAchievementHint => '今月いちばん誇らしい達成は...';

  @override
  String get yearlyMessagesTitle => '年間メッセージ';

  @override
  String get yearlyMessageBecome => '今年はこんな自分になりたい...';

  @override
  String get yearlyMessageGoals => '達成したい目標';

  @override
  String get yearlyMessageBreakthrough => 'ブレイクスルー';

  @override
  String get yearlyMessageDontDo => 'やらないこと（ノーと言うのも大切なこと）';

  @override
  String get yearlyMessageKeyword => '年間キーワード（例：集中/勇気/忍耐/優しさ）';

  @override
  String get yearlyMessageFutureSelf => '未来の自分へ';

  @override
  String get yearlyMessageMotto => '座右の銘';

  @override
  String get growthPlanTitle => '年間成長プラン';

  @override
  String get growthPlanHint => 'わたしのプラン...';

  @override
  String get growthPlanSaveError => '保存に失敗しました';

  @override
  String get growthDimensionHealth => '体の健康';

  @override
  String get growthDimensionEmotion => '感情マネジメント';

  @override
  String get growthDimensionRelationship => '人間関係';

  @override
  String get growthDimensionCareer => 'キャリア';

  @override
  String get growthDimensionFinance => 'お金の管理';

  @override
  String get growthDimensionLearning => '学び続ける';

  @override
  String get growthDimensionCreativity => '創造力';

  @override
  String get growthDimensionSpirituality => '内面の成長';

  @override
  String get smallWinTitle => '小さな勝利チャレンジ';

  @override
  String smallWinEmpty(int days) {
    return '$days日間のチャレンジを設定しよう。毎日少しずつ';
  }

  @override
  String smallWinReward(String reward) {
    return 'ごほうび: $reward';
  }

  @override
  String get smallWinLoadError => '読み込みに失敗しました';

  @override
  String get smallWinLawVisible => '目に見える';

  @override
  String get smallWinLawAttractive => 'やりたくなる';

  @override
  String get smallWinLawEasy => 'かんたん';

  @override
  String get smallWinLawRewarding => 'ごほうびがある';

  @override
  String get moodTrackerTitle => '気分トラッカー';

  @override
  String get moodTrackerLoadError => '読み込みに失敗しました';

  @override
  String moodTrackerCount(int count) {
    return '$count 回';
  }

  @override
  String get habitTrackerTitle => '今月の情熱と継続';

  @override
  String get habitTrackerComingSoon => '習慣トラッキング機能を開発中です';

  @override
  String get habitTrackerComingSoonHint => '小さな勝利チャレンジで習慣を設定してください';

  @override
  String get listsTitle => 'マイリスト';

  @override
  String get listBookTitle => '読書リスト';

  @override
  String get listMovieTitle => '映画リスト';

  @override
  String get listCustomTitle => 'カスタムリスト';

  @override
  String listItemCount(int count) {
    return '$count 件';
  }

  @override
  String get listDetailBookTitle => 'わたしの読書リスト';

  @override
  String get listDetailMovieTitle => 'わたしの映画リスト';

  @override
  String get listDetailCustomTitle => 'わたしのリスト';

  @override
  String get listDetailSave => '保存';

  @override
  String get listDetailSaveSuccess => '保存しました';

  @override
  String get listDetailSaveError => '保存に失敗しました';

  @override
  String get listDetailCustomNameLabel => 'リスト名';

  @override
  String get listDetailCustomNameHint => '例：ポッドキャストリスト';

  @override
  String get listDetailItemTitleHint => 'タイトル';

  @override
  String get listDetailItemDateHint => '日付';

  @override
  String get listDetailItemGenreHint => 'ジャンル/タグ';

  @override
  String get listDetailItemKeywordHint => 'キーワード/感想';

  @override
  String get listDetailYearTreasure => '年間のお宝';

  @override
  String get listDetailYearPick => '年間ベスト';

  @override
  String get listDetailYearPickHint => '今年いちばんおすすめの一作';

  @override
  String get listDetailInsight => 'ひらめき';

  @override
  String get listDetailInsightHint => '読書・映画から得た最大の気づき';

  @override
  String get exploreMyMoments => 'わたしの瞬間';

  @override
  String get exploreMyMomentsDesc => '幸せとハイライトの瞬間を記録';

  @override
  String get exploreHabitPact => '習慣との約束';

  @override
  String get exploreHabitPactDesc => '原子習慣の4つの法則で新しい習慣をデザイン';

  @override
  String get exploreWorryUnload => '心配ごとの棚卸し';

  @override
  String get exploreWorryUnloadDesc => '心配ごとを分類：手放す・行動する・受け入れる';

  @override
  String get exploreSelfPraise => '自分を褒める会';

  @override
  String get exploreSelfPraiseDesc => '自分の5つの長所を書き出そう';

  @override
  String get exploreSupportMap => 'わたしを支える人';

  @override
  String get exploreSupportMapDesc => '支えてくれる人を記録';

  @override
  String get exploreFutureSelf => '未来のわたし';

  @override
  String get exploreFutureSelfDesc => '3つの未来の自分を想像しよう';

  @override
  String get exploreIdealVsReal => '理想の自分 vs. 今の自分';

  @override
  String get exploreIdealVsRealDesc => '理想と現実の重なりを見つけよう';

  @override
  String get highlightScreenTitle => 'わたしの瞬間';

  @override
  String get highlightTabHappy => '幸せな瞬間';

  @override
  String get highlightTabHighlight => 'ハイライト';

  @override
  String get highlightEmptyHappy => '幸せな瞬間はまだありません';

  @override
  String get highlightEmptyHighlight => 'ハイライトはまだありません';

  @override
  String highlightLoadError(String error) {
    return '読み込みに失敗: $error';
  }

  @override
  String get monthlyPlanScreenTitle => '月間プラン';

  @override
  String get monthlyPlanSave => '保存';

  @override
  String get monthlyPlanSaveSuccess => '保存しました';

  @override
  String get monthlyPlanSaveError => '保存に失敗しました';

  @override
  String get monthlyPlanGoalsSection => '月間目標';

  @override
  String get monthlyPlanChallengeSection => '小さな勝利チャレンジ';

  @override
  String get monthlyPlanChallengeNameLabel => 'チャレンジ習慣名';

  @override
  String get monthlyPlanChallengeNameHint => '例：毎日10分ランニング';

  @override
  String get monthlyPlanRewardLabel => '達成後のごほうび';

  @override
  String get monthlyPlanRewardHint => '例：読みたい本を買う';

  @override
  String get monthlyPlanSelfCareSection => '自分を大切にする活動';

  @override
  String monthlyPlanActivityHint(int index) {
    return '活動 $index';
  }

  @override
  String get monthlyPlanMemorySection => '今月の思い出';

  @override
  String get monthlyPlanMemoryHint => '今月いちばん素敵な思い出は...';

  @override
  String get monthlyPlanAchievementSection => '今月の達成';

  @override
  String get monthlyPlanAchievementHint => '今月いちばん誇らしい達成は...';

  @override
  String yearlyPlanScreenTitle(int year) {
    return '$year年 年間プラン';
  }

  @override
  String get yearlyPlanSave => '保存';

  @override
  String get yearlyPlanSaveSuccess => '保存しました';

  @override
  String get yearlyPlanSaveError => '保存に失敗しました';

  @override
  String get yearlyPlanMessagesSection => '年間メッセージ';

  @override
  String get yearlyPlanGrowthSection => '成長プラン';

  @override
  String get growthReviewScreenTitle => '成長のふりかえり';

  @override
  String get growthReviewMyMoments => 'わたしの特別な瞬間';

  @override
  String get growthReviewEmptyMoments => 'ハイライトはまだありません';

  @override
  String get growthReviewMySummary => 'わたしのまとめ';

  @override
  String get growthReviewSummaryPrompt => 'この旅を振り返って、自分に何を伝えたい？';

  @override
  String get growthReviewSmallWins => '小さな勝利の表彰';

  @override
  String get growthReviewConsistentRecord => '記録を継続';

  @override
  String growthReviewRecordedDays(int count) {
    return '$count日間記録しました';
  }

  @override
  String get growthReviewWeeklyChamp => '週間レビューの達人';

  @override
  String growthReviewCompletedReviews(int count) {
    return '$count回の週間レビューを完了';
  }

  @override
  String get growthReviewWarmClose => 'あたたかいフィナーレ';

  @override
  String get growthReviewEveryStar => '毎日の記録はひとつの星';

  @override
  String growthReviewKeepShining(int count) {
    return '$count個の星を集めました。これからも輝き続けよう！';
  }

  @override
  String get futureSelfScreenTitle => '未来のわたし';

  @override
  String get futureSelfSubtitle => '3つの未来の自分を想像しよう';

  @override
  String get futureSelfHint => '完璧な答えは要りません。想像を自由に';

  @override
  String get futureSelfStable => '安定した未来';

  @override
  String get futureSelfStableHint => 'すべて順調なら、どんな生活をしている？';

  @override
  String get futureSelfFree => '自由な未来';

  @override
  String get futureSelfFreeHint => '制限がなかったら、何がしたい？';

  @override
  String get futureSelfPace => '自分のペースで歩む未来';

  @override
  String get futureSelfPaceHint => '焦らず、あなたの理想のペースは？';

  @override
  String get futureSelfCoreLabel => '本当に大切にしたいことは？';

  @override
  String get futureSelfCoreHint => '3つの未来に共通するものは？それがあなたの本当に大切なこと...';

  @override
  String get habitPactScreenTitle => '習慣との約束';

  @override
  String get habitPactStep1 => 'どんな習慣を身につけたい？';

  @override
  String get habitPactCategoryLearning => '学び';

  @override
  String get habitPactCategoryHealth => '健康';

  @override
  String get habitPactCategoryRelationship => '人間関係';

  @override
  String get habitPactCategoryHobby => '趣味';

  @override
  String get habitPactHabitLabel => '具体的な習慣';

  @override
  String get habitPactHabitHint => '例：毎日20ページ読む';

  @override
  String get habitPactStep2 => '習慣の4つの法則';

  @override
  String get habitPactLawVisible => '目に見える';

  @override
  String get habitPactLawVisibleHint => 'きっかけを置く場所は...';

  @override
  String get habitPactLawAttractive => 'やりたくなる';

  @override
  String get habitPactLawAttractiveHint => 'これと組み合わせる...';

  @override
  String get habitPactLawEasy => 'かんたん';

  @override
  String get habitPactLawEasyHint => '最小バージョンは...';

  @override
  String get habitPactLawRewarding => 'ごほうびがある';

  @override
  String get habitPactLawRewardingHint => '終わったら自分にごほうび...';

  @override
  String get habitPactStep3 => 'アクション宣言';

  @override
  String get habitPactDeclarationEmpty => '上を入力すると宣言が自動生成されます...';

  @override
  String habitPactDeclarationPrefix(String habit) {
    return '「$habit」の習慣を身につけます';
  }

  @override
  String habitPactDeclarationWhen(String cue) {
    return '$cueのとき';
  }

  @override
  String habitPactDeclarationWill(String response) {
    return '$responseをする';
  }

  @override
  String habitPactDeclarationThen(String reward) {
    return 'そして$reward';
  }

  @override
  String get idealVsRealScreenTitle => '理想の自分 vs. 今の自分';

  @override
  String get idealVsRealIdeal => '理想の自分';

  @override
  String get idealVsRealIdealHint => 'どんな人になりたい？';

  @override
  String get idealVsRealReal => '今の自分';

  @override
  String get idealVsRealRealHint => '今の自分はどんな人？';

  @override
  String get idealVsRealSame => '共通点は？';

  @override
  String get idealVsRealSameHint => '理想と現実で、もう重なっているところは？';

  @override
  String get idealVsRealDiff => '違いは？';

  @override
  String get idealVsRealDiffHint => 'ギャップはどこ？どう感じる？';

  @override
  String get idealVsRealStep => '理想に近づくための小さな一歩';

  @override
  String get idealVsRealStepHint => '今日できる小さなことは...';

  @override
  String get selfPraiseScreenTitle => '自分を褒める会';

  @override
  String get selfPraiseSubtitle => 'あなたの5つの長所を書こう';

  @override
  String get selfPraiseHint => '誰もが認められる価値がある、特に自分自身に';

  @override
  String selfPraiseStrengthLabel(int index) {
    return '長所 $index';
  }

  @override
  String get selfPraisePrompt1 => 'いちばん温かい性格は...';

  @override
  String get selfPraisePrompt2 => '得意なことは...';

  @override
  String get selfPraisePrompt3 => 'よく褒められることは...';

  @override
  String get selfPraisePrompt4 => '自分を誇りに思うところは...';

  @override
  String get selfPraisePrompt5 => 'ユニークなところは...';

  @override
  String get supportMapScreenTitle => 'わたしを支える人';

  @override
  String get supportMapSubtitle => '誰があなたを支えてくれてる？';

  @override
  String get supportMapHint => '大切な人を記録して、ひとりじゃないことを思い出そう';

  @override
  String get supportMapNameLabel => '名前';

  @override
  String get supportMapRelationLabel => '関係';

  @override
  String get supportMapRelationHint => '例：友人/家族/同僚';

  @override
  String get supportMapAdd => '追加';

  @override
  String get worryUnloadScreenTitle => '心配ごとの棚卸し';

  @override
  String worryUnloadLoadError(String error) {
    return '読み込みに失敗: $error';
  }

  @override
  String get worryUnloadEmptyTitle => '心配ごとはありません';

  @override
  String get worryUnloadEmptyHint => 'すばらしい！今日は気楽な一日';

  @override
  String get worryUnloadIntro => '心配ごとを見て、分類してみよう';

  @override
  String get worryUnloadLetGo => '手放せる';

  @override
  String get worryUnloadTakeAction => '行動できる';

  @override
  String get worryUnloadAccept => '今は受け入れる';

  @override
  String get worryUnloadResultTitle => '棚卸し結果';

  @override
  String worryUnloadSummary(String label, int count) {
    return '$label: $count 件';
  }

  @override
  String get worryUnloadEncouragement => '分類するだけでも一歩前進。';

  @override
  String get commonSaved => '保存しました';

  @override
  String get commonSaveError => '保存に失敗しました';

  @override
  String get commonLoadError => '読み込みに失敗しました';

  @override
  String get momentEditTitle => '瞬間を編集';

  @override
  String get momentNewHappy => '幸せな瞬間を記録';

  @override
  String get momentNewHighlight => 'ハイライトを記録';

  @override
  String get momentDescHappy => '幸せなこと';

  @override
  String get momentDescHighlight => '何があった？';

  @override
  String get momentCompanionHappy => '誰と一緒だった？';

  @override
  String get momentCompanionHighlight => '何をした？';

  @override
  String get momentFeeling => '気持ち';

  @override
  String get momentDate => '日付 (YYYY-MM-DD)';

  @override
  String get momentRating => '評価';

  @override
  String get momentDescRequired => '説明を入力してね';

  @override
  String momentWithCompanion(String companion) {
    return '$companionと一緒に';
  }

  @override
  String momentDidAction(String action) {
    return 'やったこと：$action';
  }

  @override
  String get annualCalendarTitle => '年間カレンダー';

  @override
  String annualCalendarMonthLabel(int month) {
    return '$month月';
  }
}
