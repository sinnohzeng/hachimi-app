// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class SDe extends S {
  SDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Hachimi';

  @override
  String get homeTabToday => 'Heute';

  @override
  String get homeTabCatHouse => 'Katzenhaus';

  @override
  String get homeTabStats => 'Statistik';

  @override
  String get homeTabProfile => 'Profil';

  @override
  String get adoptionStepDefineHabit => 'Gewohnheit festlegen';

  @override
  String get adoptionStepAdoptCat => 'Katze adoptieren';

  @override
  String get adoptionStepNameCat => 'Katze benennen';

  @override
  String get adoptionHabitName => 'Gewohnheitsname';

  @override
  String get adoptionHabitNameHint => 'z.B. Tägliches Lesen';

  @override
  String get adoptionDailyGoal => 'Tagesziel';

  @override
  String get adoptionTargetHours => 'Zielstunden';

  @override
  String get adoptionTargetHoursHint => 'Gesamtstunden für diese Gewohnheit';

  @override
  String adoptionMinutes(int count) {
    return '$count Min.';
  }

  @override
  String get adoptionRefreshCat => 'Andere Katze ausprobieren';

  @override
  String adoptionPersonality(String name) {
    return 'Persönlichkeit: $name';
  }

  @override
  String get adoptionNameYourCat => 'Benenne deine Katze';

  @override
  String get adoptionRandomName => 'Zufällig';

  @override
  String get adoptionCreate => 'Gewohnheit erstellen & adoptieren';

  @override
  String get adoptionNext => 'Weiter';

  @override
  String get adoptionBack => 'Zurück';

  @override
  String get adoptionCatNameLabel => 'Katzenname';

  @override
  String get adoptionCatNameHint => 'z.B. Mochi';

  @override
  String get adoptionRandomNameTooltip => 'Zufälliger Name';

  @override
  String get catHouseTitle => 'Katzenhaus';

  @override
  String get catHouseEmpty =>
      'Noch keine Katzen! Erstelle eine Gewohnheit, um deine erste Katze zu adoptieren.';

  @override
  String catHouseGrowth(int minutes, int target) {
    return '$minutes / $target Min.';
  }

  @override
  String get catDetailGrowthProgress => 'Wachstumsfortschritt';

  @override
  String catDetailTotalMinutes(int minutes) {
    return '$minutes Min. fokussiert';
  }

  @override
  String catDetailTargetMinutes(int minutes) {
    return 'Ziel: $minutes Min.';
  }

  @override
  String get catDetailRename => 'Umbenennen';

  @override
  String get catDetailAccessories => 'Accessoires';

  @override
  String get catDetailStartFocus => 'Fokus starten';

  @override
  String get catDetailBoundHabit => 'Verknüpfte Gewohnheit';

  @override
  String catDetailStage(String stage) {
    return 'Stufe: $stage';
  }

  @override
  String coinBalance(int amount) {
    return '$amount Münzen';
  }

  @override
  String coinCheckInReward(int amount) {
    return '+$amount Münzen!';
  }

  @override
  String get coinCheckInTitle => 'Täglicher Check-in';

  @override
  String get coinInsufficientBalance => 'Nicht genug Münzen';

  @override
  String get shopTitle => 'Accessoire-Shop';

  @override
  String shopPrice(int price) {
    return '$price Münzen';
  }

  @override
  String get shopPurchase => 'Kaufen';

  @override
  String get shopEquipped => 'Ausgerüstet';

  @override
  String focusCompleteMinutes(int minutes) {
    return '+$minutes Min.';
  }

  @override
  String get focusCompleteStageUp => 'Stufenaufstieg!';

  @override
  String get focusCompleteGreatJob => 'Toll gemacht!';

  @override
  String get focusCompleteDone => 'Fertig';

  @override
  String get focusCompleteItsOkay => 'Kein Problem!';

  @override
  String focusCompleteEvolved(String catName) {
    return '$catName hat sich entwickelt!';
  }

  @override
  String focusCompleteFocusedFor(int minutes) {
    return 'Du hast $minutes Minuten fokussiert';
  }

  @override
  String focusCompleteAbandonedMessage(String catName) {
    return '$catName sagt: \"Wir versuchen es nochmal!\"';
  }

  @override
  String get focusCompleteFocusTime => 'Fokuszeit';

  @override
  String get focusCompleteCoinsEarned => 'Verdiente Münzen';

  @override
  String get focusCompleteBaseXp => 'Basis-XP';

  @override
  String get focusCompleteStreakBonus => 'Serienbonus';

  @override
  String get focusCompleteMilestoneBonus => 'Meilensteinbonus';

  @override
  String get focusCompleteFullHouseBonus => 'Vollhaus-Bonus';

  @override
  String get focusCompleteTotal => 'Gesamt';

  @override
  String focusCompleteEvolvedTo(String stage) {
    return 'Zu $stage entwickelt!';
  }

  @override
  String get focusCompleteYourCat => 'Deine Katze';

  @override
  String get focusCompleteDiaryWriting => 'Tagebuch wird geschrieben...';

  @override
  String get focusCompleteDiaryWritten => 'Tagebuch geschrieben!';

  @override
  String get focusCompleteDiarySkipped => 'Diary skipped';

  @override
  String get focusCompleteNotifTitle => 'Quest abgeschlossen!';

  @override
  String focusCompleteNotifBody(String catName, int xp, int minutes) {
    return '$catName hat +$xp XP durch $minutes Min. Fokus verdient';
  }

  @override
  String get stageKitten => 'Kätzchen';

  @override
  String get stageAdolescent => 'Jungtier';

  @override
  String get stageAdult => 'Erwachsen';

  @override
  String get stageSenior => 'Senior';

  @override
  String get migrationTitle => 'Datenaktualisierung erforderlich';

  @override
  String get migrationMessage =>
      'Hachimi wurde mit einem neuen Pixel-Katzensystem aktualisiert! Deine alten Katzendaten sind nicht mehr kompatibel. Bitte setze zurück, um mit der neuen Version frisch zu starten.';

  @override
  String get migrationResetButton => 'Zurücksetzen & neu starten';

  @override
  String get sessionResumeTitle => 'Sitzung fortsetzen?';

  @override
  String sessionResumeMessage(String habitName, String elapsed) {
    return 'Du hattest eine aktive Fokus-Sitzung ($habitName, $elapsed). Fortsetzen?';
  }

  @override
  String get sessionResumeButton => 'Fortsetzen';

  @override
  String get sessionDiscard => 'Verwerfen';

  @override
  String get todaySummaryMinutes => 'Heute';

  @override
  String get todaySummaryTotal => 'Gesamt';

  @override
  String get todaySummaryCats => 'Katzen';

  @override
  String get todayYourQuests => 'Deine Quests';

  @override
  String get todayNoQuests => 'Noch keine Quests';

  @override
  String get todayNoQuestsHint =>
      'Tippe auf +, um eine Quest zu starten und eine Katze zu adoptieren!';

  @override
  String get todayFocus => 'Fokus';

  @override
  String get todayDeleteQuestTitle => 'Quest löschen?';

  @override
  String todayDeleteQuestMessage(String name) {
    return 'Möchtest du \"$name\" wirklich löschen? Die Katze wird in dein Album verschoben.';
  }

  @override
  String todayQuestCompleted(String name) {
    return '$name abgeschlossen';
  }

  @override
  String get todayFailedToLoad => 'Quests konnten nicht geladen werden';

  @override
  String todayMinToday(int count) {
    return '$count Min. heute';
  }

  @override
  String todayGoalMinPerDay(int count) {
    return 'Ziel: $count Min./Tag';
  }

  @override
  String get todayFeaturedCat => 'Katze des Tages';

  @override
  String get todayAddHabit => 'Gewohnheit hinzufügen';

  @override
  String get todayNoHabits => 'Erstelle deine erste Gewohnheit, um loszulegen!';

  @override
  String get todayNewQuest => 'Neue Quest';

  @override
  String get todayStartFocus => 'Fokus starten';

  @override
  String get timerStart => 'Start';

  @override
  String get timerPause => 'Pause';

  @override
  String get timerResume => 'Fortsetzen';

  @override
  String get timerDone => 'Fertig';

  @override
  String get timerGiveUp => 'Aufgeben';

  @override
  String get timerRemaining => 'Verbleibend';

  @override
  String get timerElapsed => 'Vergangen';

  @override
  String get timerPaused => 'PAUSIERT';

  @override
  String get timerQuestNotFound => 'Quest nicht gefunden';

  @override
  String get timerNotificationBanner =>
      'Aktiviere Benachrichtigungen, um den Timer-Fortschritt im Hintergrund zu sehen';

  @override
  String get timerNotificationDismiss => 'Schließen';

  @override
  String get timerNotificationEnable => 'Aktivieren';

  @override
  String timerGraceBack(int seconds) {
    return 'Zurück (${seconds}s)';
  }

  @override
  String get giveUpTitle => 'Aufgeben?';

  @override
  String get giveUpMessage =>
      'Wenn du mindestens 5 Minuten fokussiert hast, zählt die Zeit trotzdem zum Wachstum deiner Katze. Deine Katze versteht das!';

  @override
  String get giveUpKeepGoing => 'Weitermachen';

  @override
  String get giveUpConfirm => 'Aufgeben';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsGeneral => 'Allgemein';

  @override
  String get settingsAppearance => 'Erscheinungsbild';

  @override
  String get settingsNotifications => 'Benachrichtigungen';

  @override
  String get settingsNotificationFocusReminders => 'Fokus-Erinnerungen';

  @override
  String get settingsNotificationSubtitle =>
      'Tägliche Erinnerungen, um am Ball zu bleiben';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageSystem => 'Systemstandard';

  @override
  String get settingsLanguageEnglish => 'Englisch';

  @override
  String get settingsLanguageChinese => '中文';

  @override
  String get settingsThemeMode => 'Design-Modus';

  @override
  String get settingsThemeModeSystem => 'System';

  @override
  String get settingsThemeModeLight => 'Hell';

  @override
  String get settingsThemeModeDark => 'Dunkel';

  @override
  String get settingsThemeColor => 'Designfarbe';

  @override
  String get settingsThemeColorDynamic => 'Dynamisch';

  @override
  String get settingsThemeColorDynamicSubtitle => 'Hintergrundfarben verwenden';

  @override
  String get settingsAbout => 'Über';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsLicenses => 'Lizenzen';

  @override
  String get settingsAccount => 'Konto';

  @override
  String get logoutTitle => 'Abmelden?';

  @override
  String get logoutMessage => 'Möchtest du dich wirklich abmelden?';

  @override
  String get loggingOut => 'Abmelden...';

  @override
  String get deleteAccountTitle => 'Konto löschen?';

  @override
  String get deleteAccountMessage =>
      'Dadurch werden dein Konto und alle Daten dauerhaft gelöscht. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get deleteAccountWarning =>
      'Diese Aktion kann nicht rückgängig gemacht werden';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileYourJourney => 'Deine Reise';

  @override
  String get profileTotalFocus => 'Gesamtfokus';

  @override
  String get profileTotalCats => 'Katzen gesamt';

  @override
  String get profileTotalQuests => 'Quests';

  @override
  String get profileEditName => 'Name bearbeiten';

  @override
  String get profileDisplayName => 'Anzeigename';

  @override
  String get profileChooseAvatar => 'Avatar wählen';

  @override
  String get profileSaved => 'Profil gespeichert';

  @override
  String get profileSettings => 'Einstellungen';

  @override
  String get habitDetailStreak => 'Serie';

  @override
  String get habitDetailBestStreak => 'Bestleistung';

  @override
  String get habitDetailTotalMinutes => 'Gesamt';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonConfirm => 'Bestätigen';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get commonEdit => 'Bearbeiten';

  @override
  String get commonDone => 'Fertig';

  @override
  String get commonDismiss => 'Schließen';

  @override
  String get commonEnable => 'Aktivieren';

  @override
  String get commonLoading => 'Laden...';

  @override
  String get commonError => 'Etwas ist schiefgelaufen';

  @override
  String get commonRetry => 'Erneut versuchen';

  @override
  String get commonResume => 'Fortsetzen';

  @override
  String get commonPause => 'Pause';

  @override
  String get commonLogOut => 'Abmelden';

  @override
  String get commonDeleteAccount => 'Konto löschen';

  @override
  String get commonYes => 'Ja';

  @override
  String chatDailyRemaining(int count) {
    return 'Noch $count Nachrichten heute';
  }

  @override
  String get chatDailyLimitReached => 'Tägliches Nachrichtenlimit erreicht';

  @override
  String get aiTemporarilyUnavailable =>
      'KI-Funktionen sind vorübergehend nicht verfügbar';

  @override
  String get catDetailNotFound => 'Katze nicht gefunden';

  @override
  String get catDetailLoadError => 'Katzendaten konnten nicht geladen werden';

  @override
  String get catDetailChatTooltip => 'Chat';

  @override
  String get catDetailRenameTooltip => 'Umbenennen';

  @override
  String get catDetailGrowthTitle => 'Wachstumsfortschritt';

  @override
  String catDetailTarget(int hours) {
    return 'Ziel: ${hours}h';
  }

  @override
  String get catDetailRenameTitle => 'Katze umbenennen';

  @override
  String get catDetailNewName => 'Neuer Name';

  @override
  String get catDetailRenamed => 'Katze umbenannt!';

  @override
  String get catDetailQuestBadge => 'Quest';

  @override
  String get catDetailEditQuest => 'Quest bearbeiten';

  @override
  String get catDetailDailyGoal => 'Tagesziel';

  @override
  String get catDetailTodaysFocus => 'Heutiger Fokus';

  @override
  String get catDetailTotalFocus => 'Gesamtfokus';

  @override
  String get catDetailTargetLabel => 'Ziel';

  @override
  String get catDetailCompletion => 'Fortschritt';

  @override
  String get catDetailCurrentStreak => 'Aktuelle Serie';

  @override
  String get catDetailBestStreakLabel => 'Beste Serie';

  @override
  String get catDetailAvgDaily => 'Täglicher Durchschnitt';

  @override
  String get catDetailDaysActive => 'Aktive Tage';

  @override
  String get catDetailCheckInDays => 'Check-in-Tage';

  @override
  String get catDetailEditQuestTitle => 'Quest bearbeiten';

  @override
  String get catDetailQuestName => 'Questname';

  @override
  String get catDetailDailyGoalMinutes => 'Tagesziel (Minuten)';

  @override
  String get catDetailTargetTotalHours => 'Gesamtziel (Stunden)';

  @override
  String get catDetailQuestUpdated => 'Quest aktualisiert!';

  @override
  String get catDetailTargetCompletedHint =>
      'Ziel bereits erreicht — jetzt im unbegrenzten Modus';

  @override
  String get catDetailDailyReminder => 'Tägliche Erinnerung';

  @override
  String catDetailEveryDay(String time) {
    return '$time jeden Tag';
  }

  @override
  String get catDetailNoReminder => 'Keine Erinnerung eingestellt';

  @override
  String get catDetailChange => 'Ändern';

  @override
  String get catDetailRemoveReminder => 'Erinnerung entfernen';

  @override
  String get catDetailSet => 'Einstellen';

  @override
  String catDetailReminderSet(String time) {
    return 'Erinnerung für $time eingestellt';
  }

  @override
  String get catDetailReminderRemoved => 'Erinnerung entfernt';

  @override
  String get catDetailDiaryTitle => 'Hachimi-Tagebuch';

  @override
  String get catDetailDiaryLoading => 'Laden...';

  @override
  String get catDetailDiaryError => 'Tagebuch konnte nicht geladen werden';

  @override
  String get catDetailDiaryEmpty =>
      'Noch kein Tagebucheintrag heute. Schließe eine Fokus-Sitzung ab!';

  @override
  String catDetailChatWith(String name) {
    return 'Chat mit $name';
  }

  @override
  String get catDetailChatSubtitle => 'Unterhalte dich mit deiner Katze';

  @override
  String get catDetailActivity => 'Aktivität';

  @override
  String get catDetailActivityError =>
      'Aktivitätsdaten konnten nicht geladen werden';

  @override
  String get catDetailAccessoriesTitle => 'Accessoires';

  @override
  String get catDetailEquipped => 'Ausgerüstet: ';

  @override
  String get catDetailNone => 'Keine';

  @override
  String get catDetailUnequip => 'Ablegen';

  @override
  String catDetailFromInventory(int count) {
    return 'Aus dem Inventar ($count)';
  }

  @override
  String get catDetailNoAccessories =>
      'Noch keine Accessoires. Besuche den Shop!';

  @override
  String catDetailEquippedItem(String name) {
    return '$name ausgerüstet';
  }

  @override
  String get catDetailUnequipped => 'Abgelegt';

  @override
  String catDetailAbout(String name) {
    return 'Über $name';
  }

  @override
  String get catDetailAppearanceDetails => 'Aussehen-Details';

  @override
  String get catDetailStatus => 'Status';

  @override
  String get catDetailAdopted => 'Adoptiert';

  @override
  String get catDetailFurPattern => 'Fellmuster';

  @override
  String get catDetailFurColor => 'Fellfarbe';

  @override
  String get catDetailFurLength => 'Felllänge';

  @override
  String get catDetailEyes => 'Augen';

  @override
  String get catDetailWhitePatches => 'Weiße Flecken';

  @override
  String get catDetailPatchesTint => 'Fleckentönung';

  @override
  String get catDetailTint => 'Tönung';

  @override
  String get catDetailPoints => 'Points-Zeichnung';

  @override
  String get catDetailVitiligo => 'Vitiligo';

  @override
  String get catDetailTortoiseshell => 'Schildpatt';

  @override
  String get catDetailTortiePattern => 'Schildpatt-Muster';

  @override
  String get catDetailTortieColor => 'Schildpatt-Farbe';

  @override
  String get catDetailSkin => 'Haut';

  @override
  String get offlineMessage =>
      'Du bist offline — Änderungen werden synchronisiert, sobald du wieder verbunden bist';

  @override
  String get offlineModeLabel => 'Offline-Modus';

  @override
  String habitTodayMinutes(int count) {
    return 'Heute: $count Min.';
  }

  @override
  String get habitDeleteTooltip => 'Gewohnheit löschen';

  @override
  String get heatmapActiveDays => 'Aktive Tage';

  @override
  String get heatmapTotal => 'Gesamt';

  @override
  String get heatmapRate => 'Rate';

  @override
  String get heatmapLess => 'Weniger';

  @override
  String get heatmapMore => 'Mehr';

  @override
  String get accessoryEquipped => 'Ausgerüstet';

  @override
  String get accessoryOwned => 'Im Besitz';

  @override
  String get pickerMinUnit => 'Min.';

  @override
  String get settingsBackgroundAnimation => 'Animierte Hintergründe';

  @override
  String get settingsBackgroundAnimationSubtitle =>
      'Mesh-Gradient und schwebende Partikel';

  @override
  String get settingsUiStyle => 'UI-Stil';

  @override
  String get settingsUiStyleMaterial => 'Material 3';

  @override
  String get settingsUiStyleRetroPixel => 'Retro Pixel';

  @override
  String get settingsUiStyleMaterialSubtitle =>
      'Modernes, abgerundetes Material Design';

  @override
  String get settingsUiStyleRetroPixelSubtitle => 'Warme Pixel-Art-Ästhetik';

  @override
  String get personalityLazy => 'Faul';

  @override
  String get personalityCurious => 'Neugierig';

  @override
  String get personalityPlayful => 'Verspielt';

  @override
  String get personalityShy => 'Schüchtern';

  @override
  String get personalityBrave => 'Mutig';

  @override
  String get personalityClingy => 'Anhänglich';

  @override
  String get personalityFlavorLazy =>
      'Schläft 23 Stunden am Tag. Die andere Stunde? Auch schlafen.';

  @override
  String get personalityFlavorCurious =>
      'Beschnuppert schon alles in Sichtweite!';

  @override
  String get personalityFlavorPlayful =>
      'Kann nicht aufhören, Schmetterlinge zu jagen!';

  @override
  String get personalityFlavorShy =>
      'Hat 3 Minuten gebraucht, um aus der Box zu lugen...';

  @override
  String get personalityFlavorBrave =>
      'Aus der Box gesprungen, bevor sie überhaupt offen war!';

  @override
  String get personalityFlavorClingy =>
      'Hat sofort angefangen zu schnurren und lässt nicht los.';

  @override
  String get moodHappy => 'Glücklich';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodLonely => 'Einsam';

  @override
  String get moodMissing => 'Vermisst dich';

  @override
  String get moodMsgLazyHappy =>
      'Nya~! Zeit für ein wohlverdientes Nickerchen...';

  @override
  String get moodMsgCuriousHappy => 'Was erkunden wir heute?';

  @override
  String get moodMsgPlayfulHappy => 'Nya~! Bereit loszulegen!';

  @override
  String get moodMsgShyHappy => '...I-Ich bin froh, dass du da bist.';

  @override
  String get moodMsgBraveHappy => 'Lass uns den Tag gemeinsam erobern!';

  @override
  String get moodMsgClingyHappy =>
      'Juhu! Du bist wieder da! Geh nicht mehr weg!';

  @override
  String get moodMsgLazyNeutral => '*gähn* Oh, hey...';

  @override
  String get moodMsgCuriousNeutral => 'Hmm, was ist denn da drüben?';

  @override
  String get moodMsgPlayfulNeutral => 'Willst du spielen? Vielleicht später...';

  @override
  String get moodMsgShyNeutral => '*lugt langsam hervor*';

  @override
  String get moodMsgBraveNeutral => 'Stehe Wache, wie immer.';

  @override
  String get moodMsgClingyNeutral => 'Ich habe auf dich gewartet...';

  @override
  String get moodMsgLazyLonely => 'Selbst Schlafen fühlt sich einsam an...';

  @override
  String get moodMsgCuriousLonely => 'Ob du wohl bald wiederkommst...';

  @override
  String get moodMsgPlayfulLonely =>
      'Die Spielsachen machen ohne dich keinen Spaß...';

  @override
  String get moodMsgShyLonely => '*rollt sich leise zusammen*';

  @override
  String get moodMsgBraveLonely => 'Ich warte weiter. Ich bin mutig.';

  @override
  String get moodMsgClingyLonely => 'Wo bist du hin... 🥺';

  @override
  String get moodMsgLazyMissing => '*öffnet hoffnungsvoll ein Auge*';

  @override
  String get moodMsgCuriousMissing => 'Ist etwas passiert...?';

  @override
  String get moodMsgPlayfulMissing =>
      'Ich habe dein Lieblingsspielzeug aufgehoben...';

  @override
  String get moodMsgShyMissing => '*versteckt sich, aber beobachtet die Tür*';

  @override
  String get moodMsgBraveMissing =>
      'Ich weiß, du kommst zurück. Ich glaube daran.';

  @override
  String get moodMsgClingyMissing =>
      'Ich vermisse dich so sehr... bitte komm zurück.';

  @override
  String get peltTypeTabby => 'Klassische Tabby-Streifen';

  @override
  String get peltTypeTicked => 'Ticked-Agouti-Muster';

  @override
  String get peltTypeMackerel => 'Makrelen-Tabby';

  @override
  String get peltTypeClassic => 'Klassisches Wirbelmuster';

  @override
  String get peltTypeSokoke => 'Sokoke-Marmormuster';

  @override
  String get peltTypeAgouti => 'Agouti-Ticking';

  @override
  String get peltTypeSpeckled => 'Gesprenkeltes Fell';

  @override
  String get peltTypeRosette => 'Rosettenflecken';

  @override
  String get peltTypeSingleColour => 'Einfarbig';

  @override
  String get peltTypeTwoColour => 'Zweifarbig';

  @override
  String get peltTypeSmoke => 'Smoke-Schattierung';

  @override
  String get peltTypeSinglestripe => 'Einzelstreifen';

  @override
  String get peltTypeBengal => 'Bengal-Muster';

  @override
  String get peltTypeMarbled => 'Marmormuster';

  @override
  String get peltTypeMasked => 'Maskiertes Gesicht';

  @override
  String get peltColorWhite => 'Weiß';

  @override
  String get peltColorPaleGrey => 'Hellgrau';

  @override
  String get peltColorSilver => 'Silber';

  @override
  String get peltColorGrey => 'Grau';

  @override
  String get peltColorDarkGrey => 'Dunkelgrau';

  @override
  String get peltColorGhost => 'Geistergrau';

  @override
  String get peltColorBlack => 'Schwarz';

  @override
  String get peltColorCream => 'Creme';

  @override
  String get peltColorPaleGinger => 'Helles Ingwer';

  @override
  String get peltColorGolden => 'Gold';

  @override
  String get peltColorGinger => 'Ingwer';

  @override
  String get peltColorDarkGinger => 'Dunkles Ingwer';

  @override
  String get peltColorSienna => 'Sienna';

  @override
  String get peltColorLightBrown => 'Hellbraun';

  @override
  String get peltColorLilac => 'Lila';

  @override
  String get peltColorBrown => 'Braun';

  @override
  String get peltColorGoldenBrown => 'Goldbraun';

  @override
  String get peltColorDarkBrown => 'Dunkelbraun';

  @override
  String get peltColorChocolate => 'Schokolade';

  @override
  String get eyeColorYellow => 'Gelb';

  @override
  String get eyeColorAmber => 'Bernstein';

  @override
  String get eyeColorHazel => 'Haselnuss';

  @override
  String get eyeColorPaleGreen => 'Hellgrün';

  @override
  String get eyeColorGreen => 'Grün';

  @override
  String get eyeColorBlue => 'Blau';

  @override
  String get eyeColorDarkBlue => 'Dunkelblau';

  @override
  String get eyeColorBlueYellow => 'Blau-Gelb';

  @override
  String get eyeColorBlueGreen => 'Blau-Grün';

  @override
  String get eyeColorGrey => 'Grau';

  @override
  String get eyeColorCyan => 'Cyan';

  @override
  String get eyeColorEmerald => 'Smaragd';

  @override
  String get eyeColorHeatherBlue => 'Heideblau';

  @override
  String get eyeColorSunlitIce => 'Sonniges Eis';

  @override
  String get eyeColorCopper => 'Kupfer';

  @override
  String get eyeColorSage => 'Salbei';

  @override
  String get eyeColorCobalt => 'Kobalt';

  @override
  String get eyeColorPaleBlue => 'Hellblau';

  @override
  String get eyeColorBronze => 'Bronze';

  @override
  String get eyeColorSilver => 'Silber';

  @override
  String get eyeColorPaleYellow => 'Hellgelb';

  @override
  String eyeDescNormal(String color) {
    return '$color Augen';
  }

  @override
  String eyeDescHeterochromia(String primary, String secondary) {
    return 'Heterochromie ($primary / $secondary)';
  }

  @override
  String get skinColorPink => 'Rosa';

  @override
  String get skinColorRed => 'Rot';

  @override
  String get skinColorBlack => 'Schwarz';

  @override
  String get skinColorDark => 'Dunkel';

  @override
  String get skinColorDarkBrown => 'Dunkelbraun';

  @override
  String get skinColorBrown => 'Braun';

  @override
  String get skinColorLightBrown => 'Hellbraun';

  @override
  String get skinColorDarkGrey => 'Dunkelgrau';

  @override
  String get skinColorGrey => 'Grau';

  @override
  String get skinColorDarkSalmon => 'Dunkler Lachs';

  @override
  String get skinColorSalmon => 'Lachs';

  @override
  String get skinColorPeach => 'Pfirsich';

  @override
  String get furLengthLonghair => 'Langhaar';

  @override
  String get furLengthShorthair => 'Kurzhaar';

  @override
  String get whiteTintOffwhite => 'Cremeweiß-Tönung';

  @override
  String get whiteTintCream => 'Cremetönung';

  @override
  String get whiteTintDarkCream => 'Dunkle Cremetönung';

  @override
  String get whiteTintGray => 'Grautönung';

  @override
  String get whiteTintPink => 'Rosatönung';

  @override
  String notifReminderTitle(String catName) {
    return '$catName vermisst dich!';
  }

  @override
  String notifReminderBody(String habitName) {
    return 'Zeit für $habitName — deine Katze wartet!';
  }

  @override
  String notifStreakTitle(String catName) {
    return '$catName macht sich Sorgen!';
  }

  @override
  String notifStreakBody(int streak) {
    return 'Deine $streak-Tage-Serie ist in Gefahr. Eine kurze Sitzung rettet sie!';
  }

  @override
  String notifEvolutionTitle(String catName) {
    return '$catName hat sich entwickelt!';
  }

  @override
  String notifEvolutionBody(String catName, String stageName) {
    return '$catName ist zu einem $stageName herangewachsen!';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String diaryScreenTitle(String name) {
    return '${name}s Tagebuch';
  }

  @override
  String get diaryFailedToLoad => 'Tagebuch konnte nicht geladen werden';

  @override
  String get diaryEmptyTitle => 'Noch keine Tagebucheinträge';

  @override
  String get diaryEmptyHint =>
      'Schließe eine Fokus-Sitzung ab und deine Katze schreibt ihren ersten Tagebucheintrag!';

  @override
  String get focusSetupCountdown => 'Countdown';

  @override
  String get focusSetupStopwatch => 'Stoppuhr';

  @override
  String get focusSetupStartFocus => 'Fokus starten';

  @override
  String get focusSetupQuestNotFound => 'Quest nicht gefunden';

  @override
  String get checkInButtonLogMore => 'Weitere Zeit eintragen';

  @override
  String get checkInButtonStart => 'Timer starten';

  @override
  String get adoptionTitleFirst => 'Adoptiere deine erste Katze!';

  @override
  String get adoptionTitleNew => 'Neue Quest';

  @override
  String get adoptionStepDefineQuest => 'Quest festlegen';

  @override
  String get adoptionStepAdoptCat2 => 'Katze adoptieren';

  @override
  String get adoptionStepNameCat2 => 'Katze benennen';

  @override
  String get adoptionAdopt => 'Adoptieren!';

  @override
  String get adoptionQuestPrompt => 'Welche Quest möchtest du starten?';

  @override
  String get adoptionKittenHint =>
      'Ein Kätzchen wird dir zugeteilt, um dich zu motivieren!';

  @override
  String get adoptionQuestName => 'Questname';

  @override
  String get adoptionQuestHint => 'z.B. Interviewfragen vorbereiten';

  @override
  String get adoptionTotalTarget => 'Gesamtziel (Stunden)';

  @override
  String get adoptionGrowthHint =>
      'Deine Katze wächst, während du Fokuszeit sammelst';

  @override
  String get adoptionCustom => 'Benutzerdefiniert';

  @override
  String get adoptionDailyGoalLabel => 'Tägliches Fokusziel (Min.)';

  @override
  String get adoptionReminderLabel => 'Tägliche Erinnerung (optional)';

  @override
  String get adoptionReminderNone => 'Keine';

  @override
  String get adoptionCustomGoalTitle => 'Benutzerdefiniertes Tagesziel';

  @override
  String get adoptionMinutesPerDay => 'Minuten pro Tag';

  @override
  String get adoptionMinutesHint => '5 - 180';

  @override
  String get adoptionValidMinutes => 'Gib einen Wert zwischen 5 und 180 ein';

  @override
  String get adoptionCustomTargetTitle => 'Benutzerdefinierte Zielstunden';

  @override
  String get adoptionTotalHours => 'Gesamtstunden';

  @override
  String get adoptionHoursHint => '10 - 2000';

  @override
  String get adoptionValidHours => 'Gib einen Wert zwischen 10 und 2000 ein';

  @override
  String get adoptionSet => 'Einstellen';

  @override
  String get adoptionChooseKitten => 'Wähle dein Kätzchen!';

  @override
  String adoptionCompanionFor(String quest) {
    return 'Dein Begleiter für \"$quest\"';
  }

  @override
  String get adoptionRerollAll => 'Alle neu würfeln';

  @override
  String get adoptionNameYourCat2 => 'Benenne deine Katze';

  @override
  String get adoptionCatName => 'Katzenname';

  @override
  String get adoptionCatHint => 'z.B. Mochi';

  @override
  String get adoptionRandomTooltip => 'Zufälliger Name';

  @override
  String adoptionGrowthTarget(String quest, int hours) {
    return 'Deine Katze wächst, während du an \"$quest\" arbeitest! Ziel: ${hours}h insgesamt.';
  }

  @override
  String get adoptionValidQuestName => 'Bitte gib einen Questnamen ein';

  @override
  String get adoptionValidCatName => 'Bitte gib deiner Katze einen Namen';

  @override
  String adoptionError(String message) {
    return 'Fehler: $message';
  }

  @override
  String get adoptionBasicInfo => 'Grundinfos';

  @override
  String get adoptionGoals => 'Ziele';

  @override
  String get adoptionUnlimitedMode => 'Unbegrenzter Modus';

  @override
  String get adoptionUnlimitedDesc => 'Kein Limit, sammle einfach weiter';

  @override
  String get adoptionMilestoneMode => 'Meilenstein-Modus';

  @override
  String get adoptionMilestoneDesc => 'Setze ein Ziel, das du erreichen willst';

  @override
  String get adoptionDeadlineLabel => 'Frist';

  @override
  String get adoptionDeadlineNone => 'Nicht festgelegt';

  @override
  String get adoptionReminderSection => 'Erinnerung';

  @override
  String get adoptionMotivationLabel => 'Notiz';

  @override
  String get adoptionMotivationHint => 'Schreibe eine Notiz...';

  @override
  String get adoptionMotivationSwap => 'Zufällig ausfüllen';

  @override
  String get loginAppName => 'Hachimi';

  @override
  String get loginTagline => 'Ziehe Katzen auf. Erledige Quests.';

  @override
  String get loginContinueGoogle => 'Weiter mit Google';

  @override
  String get loginContinueEmail => 'Weiter mit E-Mail';

  @override
  String get loginAlreadyHaveAccount => 'Du hast schon ein Konto? ';

  @override
  String get loginLogIn => 'Anmelden';

  @override
  String get loginWelcomeBack => 'Willkommen zurück!';

  @override
  String get loginCreateAccount => 'Erstelle dein Konto';

  @override
  String get loginEmail => 'E-Mail';

  @override
  String get loginPassword => 'Passwort';

  @override
  String get loginConfirmPassword => 'Passwort bestätigen';

  @override
  String get loginValidEmail => 'Bitte gib deine E-Mail-Adresse ein';

  @override
  String get loginValidEmailFormat =>
      'Bitte gib eine gültige E-Mail-Adresse ein';

  @override
  String get loginValidPassword => 'Bitte gib dein Passwort ein';

  @override
  String get loginValidPasswordLength =>
      'Das Passwort muss mindestens 6 Zeichen haben';

  @override
  String get loginValidPasswordMatch => 'Die Passwörter stimmen nicht überein';

  @override
  String get loginCreateAccountButton => 'Konto erstellen';

  @override
  String get loginNoAccount => 'Noch kein Konto? ';

  @override
  String get loginRegister => 'Registrieren';

  @override
  String get checkInTitle => 'Monatlicher Check-in';

  @override
  String get checkInDays => 'Tage';

  @override
  String get checkInCoinsEarned => 'Verdiente Münzen';

  @override
  String get checkInAllMilestones => 'Alle Meilensteine eingelöst!';

  @override
  String checkInMilestoneProgress(int remaining, int bonus) {
    return 'Noch $remaining Tage → +$bonus Münzen';
  }

  @override
  String get checkInMilestones => 'Meilensteine';

  @override
  String get checkInFullMonth => 'Ganzer Monat';

  @override
  String get checkInRewardSchedule => 'Belohnungsplan';

  @override
  String get checkInWeekday => 'Wochentage (Mo–Fr)';

  @override
  String checkInWeekdayReward(int coins) {
    return '$coins Münzen/Tag';
  }

  @override
  String get checkInWeekend => 'Wochenende (Sa–So)';

  @override
  String checkInNDays(int count) {
    return '$count Tage';
  }

  @override
  String get onboardTitle1 => 'Triff deinen Begleiter';

  @override
  String get onboardSubtitle1 => 'Jede Quest beginnt mit einem Kätzchen';

  @override
  String get onboardBody1 =>
      'Setze dir ein Ziel und adoptiere ein Kätzchen.\nFokussiere dich darauf und sieh zu, wie deine Katze wächst!';

  @override
  String get onboardTitle2 => 'Fokus, Wachstum, Entwicklung';

  @override
  String get onboardSubtitle2 => '4 Wachstumsstufen';

  @override
  String get onboardBody2 =>
      'Jede Minute Fokus hilft deiner Katze, vom kleinen Kätzchen zum majestätischen Senior zu wachsen!';

  @override
  String get onboardTitle3 => 'Baue dein Katzenzimmer';

  @override
  String get onboardSubtitle3 => 'Sammle einzigartige Katzen';

  @override
  String get onboardBody3 =>
      'Jede Quest bringt eine neue Katze mit einzigartigem Aussehen.\nEntdecke sie alle und baue deine Traumsammlung!';

  @override
  String get onboardSkip => 'Überspringen';

  @override
  String get onboardLetsGo => 'Los geht\'s!';

  @override
  String get onboardNext => 'Weiter';

  @override
  String get catRoomTitle => 'Katzenhaus';

  @override
  String get catRoomInventory => 'Inventar';

  @override
  String get catRoomShop => 'Accessoire-Shop';

  @override
  String get catRoomLoadError => 'Katzen konnten nicht geladen werden';

  @override
  String get catRoomEmptyTitle => 'Dein Katzenhaus ist leer';

  @override
  String get catRoomEmptySubtitle =>
      'Starte eine Quest, um deine erste Katze zu adoptieren!';

  @override
  String get catRoomEditQuest => 'Quest bearbeiten';

  @override
  String get catRoomRenameCat => 'Katze umbenennen';

  @override
  String get catRoomArchiveCat => 'Katze archivieren';

  @override
  String get catRoomNewName => 'Neuer Name';

  @override
  String get catRoomRename => 'Umbenennen';

  @override
  String get catRoomArchiveTitle => 'Katze archivieren?';

  @override
  String catRoomArchiveMessage(String name) {
    return 'Dadurch wird \"$name\" archiviert und die verknüpfte Quest gelöscht. Die Katze erscheint weiterhin in deinem Album.';
  }

  @override
  String get catRoomArchive => 'Archivieren';

  @override
  String catRoomAlbumSection(int count) {
    return 'Album ($count)';
  }

  @override
  String get catRoomReactivateCat => 'Katze reaktivieren';

  @override
  String get catRoomReactivateTitle => 'Katze reaktivieren?';

  @override
  String catRoomReactivateMessage(String name) {
    return 'Dadurch wird \"$name\" und die verknüpfte Quest ins Katzenhaus zurückgeholt.';
  }

  @override
  String get catRoomReactivate => 'Reaktivieren';

  @override
  String get catRoomArchivedLabel => 'Archiviert';

  @override
  String catRoomArchiveSuccess(String name) {
    return '\"$name\" archiviert';
  }

  @override
  String catRoomReactivateSuccess(String name) {
    return '\"$name\" reaktiviert';
  }

  @override
  String get catRoomArchiveError => 'Archivierung der Katze fehlgeschlagen';

  @override
  String get catRoomReactivateError => 'Reaktivierung der Katze fehlgeschlagen';

  @override
  String get catRoomArchiveLoadError =>
      'Archivierte Katzen konnten nicht geladen werden';

  @override
  String get catRoomRenameError => 'Umbenennung der Katze fehlgeschlagen';

  @override
  String get addHabitTitle => 'Neue Quest';

  @override
  String get addHabitQuestName => 'Questname';

  @override
  String get addHabitQuestHint => 'z.B. LeetCode-Übung';

  @override
  String get addHabitValidName => 'Bitte gib einen Questnamen ein';

  @override
  String get addHabitTargetHours => 'Zielstunden';

  @override
  String get addHabitTargetHint => 'z.B. 100';

  @override
  String get addHabitValidTarget => 'Bitte gib die Zielstunden ein';

  @override
  String get addHabitValidNumber => 'Bitte gib eine gültige Zahl ein';

  @override
  String get addHabitCreate => 'Quest erstellen';

  @override
  String get addHabitHoursSuffix => 'Stunden';

  @override
  String shopTabPlants(int count) {
    return 'Pflanzen ($count)';
  }

  @override
  String shopTabWild(int count) {
    return 'Wild ($count)';
  }

  @override
  String shopTabCollars(int count) {
    return 'Halsbänder ($count)';
  }

  @override
  String get shopNoAccessories => 'Keine Accessoires verfügbar';

  @override
  String shopBuyConfirm(String name) {
    return '$name kaufen?';
  }

  @override
  String get shopPurchaseButton => 'Kaufen';

  @override
  String get shopNotEnoughCoinsButton => 'Nicht genug Münzen';

  @override
  String shopPurchaseSuccess(String name) {
    return 'Gekauft! $name zum Inventar hinzugefügt';
  }

  @override
  String shopPurchaseFailed(int price) {
    return 'Nicht genug Münzen (benötigt: $price)';
  }

  @override
  String get inventoryTitle => 'Inventar';

  @override
  String inventoryInBox(int count) {
    return 'In der Box ($count)';
  }

  @override
  String get inventoryEmpty =>
      'Dein Inventar ist leer.\nBesuche den Shop, um Accessoires zu bekommen!';

  @override
  String inventoryEquippedOnCats(int count) {
    return 'Auf Katzen ausgerüstet ($count)';
  }

  @override
  String get inventoryNoEquipped => 'Keine Accessoires auf Katzen ausgerüstet.';

  @override
  String get inventoryUnequip => 'Ablegen';

  @override
  String get inventoryNoActiveCats => 'Keine aktiven Katzen';

  @override
  String inventoryEquipTo(String name) {
    return '$name ausrüsten bei:';
  }

  @override
  String inventoryEquipSuccess(String name) {
    return '$name ausgerüstet';
  }

  @override
  String inventoryUnequipSuccess(String catName) {
    return 'Von $catName abgelegt';
  }

  @override
  String get chatCatNotFound => 'Katze nicht gefunden';

  @override
  String chatTitle(String name) {
    return 'Chat mit $name';
  }

  @override
  String get chatClearHistory => 'Verlauf löschen';

  @override
  String chatEmptyTitle(String name) {
    return 'Sag hallo zu $name!';
  }

  @override
  String get chatEmptySubtitle =>
      'Starte ein Gespräch mit deiner Katze. Sie antwortet basierend auf ihrer Persönlichkeit!';

  @override
  String get chatGenerating => 'Wird generiert...';

  @override
  String get chatTypeMessage => 'Nachricht eingeben...';

  @override
  String get chatClearConfirmTitle => 'Chatverlauf löschen?';

  @override
  String get chatClearConfirmMessage =>
      'Dadurch werden alle Nachrichten gelöscht. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get chatClearButton => 'Löschen';

  @override
  String get chatSend => 'Senden';

  @override
  String get chatStop => 'Stopp';

  @override
  String get chatErrorMessage => 'Failed to send message. Tap to retry.';

  @override
  String get chatRetry => 'Retry';

  @override
  String get chatErrorGeneric => 'Etwas ist schiefgelaufen. Erneut versuchen.';

  @override
  String diaryTitle(String name) {
    return '${name}s Tagebuch';
  }

  @override
  String get diaryLoadFailed => 'Tagebuch konnte nicht geladen werden';

  @override
  String get diaryRetry => 'Erneut versuchen';

  @override
  String get diaryEmptyTitle2 => 'Noch keine Tagebucheinträge';

  @override
  String get diaryEmptySubtitle =>
      'Schließe eine Fokus-Sitzung ab und deine Katze schreibt ihren ersten Tagebucheintrag!';

  @override
  String get statsTitle => 'Statistik';

  @override
  String get statsTotalHours => 'Gesamtstunden';

  @override
  String statsTimeValue(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get statsBestStreak => 'Beste Serie';

  @override
  String statsStreakDays(int count) {
    return '$count Tage';
  }

  @override
  String get statsOverallProgress => 'Gesamtfortschritt';

  @override
  String statsPercentOfGoals(String percent) {
    return '$percent% aller Ziele';
  }

  @override
  String get statsPerQuestProgress => 'Fortschritt pro Quest';

  @override
  String get statsQuestLoadError =>
      'Quest-Statistiken konnten nicht geladen werden';

  @override
  String get statsNoQuestData => 'Noch keine Quest-Daten';

  @override
  String get statsNoQuestHint =>
      'Starte eine Quest, um deinen Fortschritt hier zu sehen!';

  @override
  String get statsLast30Days => 'Letzte 30 Tage';

  @override
  String get habitDetailQuestNotFound => 'Quest nicht gefunden';

  @override
  String get habitDetailComplete => 'abgeschlossen';

  @override
  String get habitDetailTotalTime => 'Gesamtzeit';

  @override
  String get habitDetailCurrentStreak => 'Aktuelle Serie';

  @override
  String get habitDetailTarget => 'Ziel';

  @override
  String habitDetailDaysUnit(int count) {
    return '$count Tage';
  }

  @override
  String habitDetailHoursUnit(int count) {
    return '$count Stunden';
  }

  @override
  String checkInBannerSuccess(int coins) {
    return '+$coins Münzen! Täglicher Check-in abgeschlossen';
  }

  @override
  String checkInBannerBonus(int bonus) {
    return ' + $bonus Meilensteinbonus!';
  }

  @override
  String get checkInBannerSemantics => 'Täglicher Check-in';

  @override
  String get checkInBannerLoading => 'Check-in-Status wird geladen...';

  @override
  String checkInBannerPrompt(int coins) {
    return 'Check-in für +$coins Münzen';
  }

  @override
  String checkInBannerSummary(int count, int total, int coins) {
    return '$count/$total Tage  ·  +$coins heute';
  }

  @override
  String commonErrorWithDetail(String error) {
    return 'Fehler: $error';
  }

  @override
  String get profileFallbackUser => 'Benutzer';

  @override
  String get fallbackCatName => 'Katze';

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
  String get notifFocusing => 'fokussiert...';

  @override
  String get notifInProgress => 'Fokus-Sitzung läuft';

  @override
  String get unitMinShort => 'Min.';

  @override
  String get unitHourShort => 'h';

  @override
  String get weekdayMon => 'Mo';

  @override
  String get weekdayTue => 'Di';

  @override
  String get weekdayWed => 'Mi';

  @override
  String get weekdayThu => 'Do';

  @override
  String get weekdayFri => 'Fr';

  @override
  String get weekdaySat => 'Sa';

  @override
  String get weekdaySun => 'So';

  @override
  String get statsTotalSessions => 'Sitzungen';

  @override
  String get statsTotalHabits => 'Gewohnheiten';

  @override
  String get statsActiveDays => 'Aktive Tage';

  @override
  String get statsWeeklyTrend => 'Wochentrend';

  @override
  String get statsRecentSessions => 'Letzte Sitzungen';

  @override
  String get statsViewAllHistory => 'Gesamten Verlauf anzeigen';

  @override
  String get historyTitle => 'Fokusverlauf';

  @override
  String get historyFilterAll => 'Alle';

  @override
  String historySessionCount(int count) {
    return '$count Sitzungen';
  }

  @override
  String historyTotalMinutes(int minutes) {
    return '$minutes Min.';
  }

  @override
  String get historyNoSessions => 'Noch keine Fokus-Aufzeichnungen';

  @override
  String get historyNoSessionsHint =>
      'Schließe eine Fokus-Sitzung ab, um sie hier zu sehen';

  @override
  String get historyLoadMore => 'Mehr laden';

  @override
  String get sessionCompleted => 'Abgeschlossen';

  @override
  String get sessionAbandoned => 'Abgebrochen';

  @override
  String get sessionInterrupted => 'Unterbrochen';

  @override
  String get sessionCountdown => 'Countdown';

  @override
  String get sessionStopwatch => 'Stoppuhr';

  @override
  String get historyDateGroupToday => 'Heute';

  @override
  String get historyDateGroupYesterday => 'Gestern';

  @override
  String get historyLoadError => 'Verlauf konnte nicht geladen werden';

  @override
  String get historySelectMonth => 'Monat wählen';

  @override
  String get historyAllMonths => 'Alle Monate';

  @override
  String get historyAllHabits => 'Alle';

  @override
  String get homeTabAchievements => 'Erfolge';

  @override
  String get achievementTitle => 'Erfolge';

  @override
  String get achievementTabOverview => 'Übersicht';

  @override
  String get achievementTabQuest => 'Quest';

  @override
  String get achievementTabStreak => 'Serie';

  @override
  String get achievementTabCat => 'Katze';

  @override
  String get achievementTabPersist => 'Durchhalten';

  @override
  String get achievementSummaryTitle => 'Erfolgsfortschritt';

  @override
  String achievementUnlockedCount(int count) {
    return '$count freigeschaltet';
  }

  @override
  String achievementTotalCoins(int coins) {
    return '$coins Münzen verdient';
  }

  @override
  String get achievementUnlocked => 'Erfolg freigeschaltet!';

  @override
  String get achievementAwesome => 'Großartig!';

  @override
  String get achievementIncredible => 'Unglaublich!';

  @override
  String get achievementHidden => '???';

  @override
  String get achievementHiddenDesc => 'Dies ist ein versteckter Erfolg';

  @override
  String achievementPersistDesc(int days) {
    return 'Sammle $days Check-in-Tage bei einer Quest';
  }

  @override
  String achievementTitleCount(int count) {
    return '$count Titel freigeschaltet';
  }

  @override
  String get growthPathTitle => 'Wachstumspfad';

  @override
  String get growthPathKitten => 'Starte eine neue Reise';

  @override
  String get growthPathAdolescent => 'Baue das Fundament auf';

  @override
  String get growthPathAdult => 'Fähigkeiten festigen sich';

  @override
  String get growthPathSenior => 'Tiefe Meisterschaft';

  @override
  String get growthPathTip =>
      'Studien zeigen, dass 20 Stunden konzentriertes Üben ausreichen, um das Fundament einer neuen Fähigkeit aufzubauen — Josh Kaufman';

  @override
  String achievementCelebrationCoins(int count) {
    return '+$count Münzen';
  }

  @override
  String achievementCelebrationTitle(String title) {
    return 'Titel verdient: $title';
  }

  @override
  String get achievementCelebrationDismiss => 'Großartig!';

  @override
  String get achievementCelebrationSkipAll => 'Alle überspringen';

  @override
  String achievementCelebrationCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String achievementUnlockedAt(String date) {
    return 'Freigeschaltet am $date';
  }

  @override
  String get achievementLocked => 'Noch nicht freigeschaltet';

  @override
  String achievementRewardCoins(int count) {
    return '+$count Münzen';
  }

  @override
  String get reminderModeDaily => 'Jeden Tag';

  @override
  String get reminderModeWeekdays => 'Werktage';

  @override
  String get reminderModeMonday => 'Montag';

  @override
  String get reminderModeTuesday => 'Dienstag';

  @override
  String get reminderModeWednesday => 'Mittwoch';

  @override
  String get reminderModeThursday => 'Donnerstag';

  @override
  String get reminderModeFriday => 'Freitag';

  @override
  String get reminderModeSaturday => 'Samstag';

  @override
  String get reminderModeSunday => 'Sonntag';

  @override
  String get reminderPickerTitle => 'Erinnerungszeit wählen';

  @override
  String get reminderHourUnit => 'h';

  @override
  String get reminderMinuteUnit => 'Min.';

  @override
  String get reminderAddMore => 'Erinnerung hinzufügen';

  @override
  String get reminderMaxReached => 'Maximal 5 Erinnerungen';

  @override
  String get reminderConfirm => 'Bestätigen';

  @override
  String reminderNotificationTitle(String catName) {
    return '$catName vermisst dich!';
  }

  @override
  String reminderNotificationBody(String habitName) {
    return 'Zeit für $habitName — deine Katze wartet!';
  }

  @override
  String get deleteAccountDataWarning =>
      'Alle folgenden Daten werden dauerhaft gelöscht:';

  @override
  String get deleteAccountQuests => 'Quests';

  @override
  String get deleteAccountCats => 'Katzen';

  @override
  String get deleteAccountHours => 'Fokus-Stunden';

  @override
  String get deleteAccountIrreversible => 'Diese Aktion ist unwiderruflich';

  @override
  String get deleteAccountContinue => 'Weiter';

  @override
  String get deleteAccountConfirmTitle => 'Löschung bestätigen';

  @override
  String get deleteAccountTypeDelete =>
      'Gib DELETE ein, um die Kontolöschung zu bestätigen:';

  @override
  String get deleteAccountAuthCancelled => 'Authentifizierung abgebrochen';

  @override
  String deleteAccountAuthFailed(String error) {
    return 'Authentifizierung fehlgeschlagen: $error';
  }

  @override
  String get deleteAccountProgress => 'Konto wird gelöscht...';

  @override
  String get deleteAccountSuccess => 'Konto gelöscht';

  @override
  String get drawerGuestLoginSubtitle =>
      'Daten synchronisieren und KI-Funktionen freischalten';

  @override
  String get drawerGuestSignIn => 'Anmelden';

  @override
  String get drawerMilestones => 'Meilensteine';

  @override
  String drawerMilestoneFocus(int hours, int minutes) {
    return 'Gesamtfokus: ${hours}h ${minutes}m';
  }

  @override
  String drawerMilestoneCats(int count) {
    return 'Katzenfamilie: $count';
  }

  @override
  String drawerMilestoneQuests(int count) {
    return 'Aktive Quests: $count';
  }

  @override
  String get drawerMySection => 'Mein Bereich';

  @override
  String get drawerSessionHistory => 'Fokusverlauf';

  @override
  String get drawerCheckInCalendar => 'Check-in-Kalender';

  @override
  String get drawerAccountSection => 'Konto';

  @override
  String get settingsResetData => 'Alle Daten zurücksetzen';

  @override
  String get settingsResetDataTitle => 'Alle Daten zurücksetzen?';

  @override
  String get settingsResetDataMessage =>
      'Dadurch werden alle lokalen Daten gelöscht und du kehrst zum Willkommensbildschirm zurück. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get guestUpgradeTitle => 'Schütze deine Daten';

  @override
  String get guestUpgradeMessage =>
      'Verknüpfe ein Konto, um deinen Fortschritt zu sichern, KI-Tagebuch und Chat freizuschalten und geräteübergreifend zu synchronisieren.';

  @override
  String get guestUpgradeLinkButton => 'Konto verknüpfen';

  @override
  String get guestUpgradeLater => 'Vielleicht später';

  @override
  String get loginLinkTagline =>
      'Verknüpfe ein Konto, um deine Daten zu schützen';

  @override
  String get aiTeaserTitle => 'Katzentagebuch';

  @override
  String aiTeaserPreview(String catName) {
    return 'Heute habe ich wieder mit meinem Menschen gelernt... $catName fühlt sich jeden Tag schlauer~';
  }

  @override
  String aiTeaserCta(String catName) {
    return 'Verknüpfe ein Konto, um zu sehen, was $catName sagen möchte';
  }

  @override
  String get authErrorEmailInUse =>
      'Diese E-Mail-Adresse ist bereits registriert';

  @override
  String get authErrorWrongPassword => 'Falsche E-Mail oder falsches Passwort';

  @override
  String get authErrorUserNotFound => 'Kein Konto mit dieser E-Mail gefunden';

  @override
  String get authErrorTooManyRequests =>
      'Zu viele Versuche. Versuche es später erneut';

  @override
  String get authErrorNetwork => 'Netzwerkfehler. Überprüfe deine Verbindung';

  @override
  String get authErrorAdminRestricted =>
      'Die Anmeldung ist vorübergehend eingeschränkt';

  @override
  String get authErrorWeakPassword =>
      'Passwort zu schwach. Verwende mindestens 6 Zeichen';

  @override
  String get authErrorGeneric => 'Etwas ist schiefgelaufen. Versuche es erneut';

  @override
  String get deleteAccountReauthEmail =>
      'Gib dein Passwort ein, um fortzufahren';

  @override
  String get deleteAccountReauthPasswordHint => 'Passwort';

  @override
  String get deleteAccountError =>
      'Etwas ist schiefgelaufen. Versuche es später erneut.';

  @override
  String get deleteAccountPermissionError =>
      'Berechtigungsfehler. Versuche, dich ab- und wieder anzumelden.';

  @override
  String get deleteAccountNetworkError =>
      'Keine Internetverbindung. Überprüfe dein Netzwerk.';

  @override
  String get deleteAccountRetainedData =>
      'Nutzungsanalysen und Absturzberichte können nicht gelöscht werden.';

  @override
  String get deleteAccountStepCloud => 'Cloud-Daten werden gelöscht...';

  @override
  String get deleteAccountStepLocal => 'Lokale Daten werden gelöscht...';

  @override
  String get deleteAccountStepDone => 'Fertig';

  @override
  String get deleteAccountQueued =>
      'Lokale Daten gelöscht. Die Cloud-Kontolöschung ist in der Warteschlange und wird abgeschlossen, wenn du online bist.';

  @override
  String get deleteAccountPending =>
      'Kontolöschung läuft. Lass die App online, um die Cloud- und Auth-Löschung abzuschließen.';

  @override
  String get deleteAccountAbandon => 'Neu anfangen';

  @override
  String get archiveConflictTitle => 'Archiv zum Behalten wählen';

  @override
  String get archiveConflictMessage =>
      'Sowohl lokales als auch Cloud-Archiv haben Daten. Wähle eines zum Behalten:';

  @override
  String get archiveConflictLocal => 'Lokales Archiv';

  @override
  String get archiveConflictCloud => 'Cloud-Archiv';

  @override
  String get archiveConflictKeepCloud => 'Cloud behalten';

  @override
  String get archiveConflictKeepLocal => 'Lokal behalten';

  @override
  String get loginShowPassword => 'Passwort anzeigen';

  @override
  String get loginHidePassword => 'Passwort verbergen';

  @override
  String get errorGeneric =>
      'Etwas ist schiefgelaufen. Versuche es später erneut';

  @override
  String get errorCreateHabit =>
      'Gewohnheit konnte nicht erstellt werden. Versuche es erneut';

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
  String get commonCopyId => 'ID kopieren';

  @override
  String get adoptionClearDeadline => 'Frist löschen';

  @override
  String get commonIdCopied => 'ID kopiert';

  @override
  String get pickerDurationLabel => 'Dauerauswahl';

  @override
  String pickerMinutesValue(int count) {
    return '$count Minuten';
  }

  @override
  String a11yCatImage(String name) {
    return 'Katze $name';
  }

  @override
  String a11yCatTapToInteract(String name) {
    return '$name, tippen zum Interagieren';
  }

  @override
  String a11yProgressPercent(int percent) {
    return '$percent% abgeschlossen';
  }

  @override
  String a11yStreakActiveDays(int count) {
    return '$count aktive Tage';
  }

  @override
  String get a11yOfflineStatus => 'Offline-Modus';

  @override
  String a11yAchievementUnlocked(String name) {
    return 'Erfolg freigeschaltet: $name';
  }

  @override
  String get calendarCheckedIn => 'eingecheckt';

  @override
  String get calendarToday => 'heute';

  @override
  String a11yEquipToCat(Object name) {
    return 'Ausrüsten für $name';
  }

  @override
  String a11yRegenerateCat(Object name) {
    return '$name neu generieren';
  }

  @override
  String a11yTimerDisplay(Object time) {
    return 'Timer: $time';
  }

  @override
  String a11yOnboardingPage(Object current, Object total) {
    return 'Seite $current von $total';
  }

  @override
  String a11yEditDisplayName(Object name) {
    return 'Anzeigename bearbeiten: $name';
  }

  @override
  String get routeNotFound => 'Seite nicht gefunden';

  @override
  String get routeGoHome => 'Zur Startseite';

  @override
  String get a11yError => 'Fehler';

  @override
  String get a11yDeadline => 'Frist';

  @override
  String get a11yReminder => 'Erinnerung';

  @override
  String get a11yFocusMeditation => 'Fokus-Meditation';

  @override
  String get a11yUnlocked => 'Freigeschaltet';

  @override
  String get a11ySelected => 'Ausgewählt';

  @override
  String get a11yDynamicWallpaperColor => 'Dynamische Hintergrundfarbe';
}
