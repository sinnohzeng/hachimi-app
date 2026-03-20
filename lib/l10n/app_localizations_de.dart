// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class SDe extends S {
  SDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Hachimi - Light Up My Innerverse';

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
  String get focusCompleteDiarySkipped => 'Tagebuch übersprungen';

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
    return 'Noch wach, $name?';
  }

  @override
  String greetingMorning(String name) {
    return 'Guten Morgen, $name';
  }

  @override
  String greetingAfternoon(String name) {
    return 'Guten Nachmittag, $name';
  }

  @override
  String greetingEvening(String name) {
    return 'Guten Abend, $name';
  }

  @override
  String get greetingLateNightNoName => 'Noch wach?';

  @override
  String get greetingMorningNoName => 'Guten Morgen';

  @override
  String get greetingAfternoonNoName => 'Guten Nachmittag';

  @override
  String get greetingEveningNoName => 'Guten Abend';

  @override
  String get journeyTitle => 'Reise';

  @override
  String get journeySegmentWeek => 'Woche';

  @override
  String get journeySegmentMonth => 'Monat';

  @override
  String get journeySegmentYear => 'Jahr';

  @override
  String get journeySegmentExplore => 'Entdecken';

  @override
  String get journeyMonthlyView => 'Monatsansicht';

  @override
  String get journeyYearlyView => 'Jahresansicht';

  @override
  String get journeyExploreActivities => 'Aktivitäten entdecken';

  @override
  String get journeyEditMonthlyPlan => 'Monatsplan bearbeiten';

  @override
  String get journeyEditYearlyPlan => 'Jahresplan bearbeiten';

  @override
  String get quickLightTitle => 'Dein Tagesgedanke';

  @override
  String get quickLightHint => 'Wie fühlst du dich heute?';

  @override
  String get quickLightRecord => 'Eintragen';

  @override
  String get quickLightSaveSuccess => 'Eingetragen';

  @override
  String get quickLightSaveError =>
      'Speichern fehlgeschlagen. Bitte erneut versuchen';

  @override
  String get habitSnapshotTitle => 'Heutige Gewohnheiten';

  @override
  String get habitSnapshotEmpty =>
      'Noch keine Gewohnheiten. Lege sie in deiner Reise fest';

  @override
  String get habitSnapshotLoadError => 'Laden fehlgeschlagen';

  @override
  String get worryJarTitle => 'Sorgenglas';

  @override
  String get worryJarLoadError => 'Laden fehlgeschlagen';

  @override
  String get weeklyReviewEmpty => 'Halte die Glücksmomente der Woche fest';

  @override
  String get weeklyReviewHappyMoments => 'Glücksmomente';

  @override
  String get weeklyReviewLoadError => 'Laden fehlgeschlagen';

  @override
  String get weeklyPlanCardTitle => 'Wochenplan';

  @override
  String weeklyPlanItemCount(int count) {
    return '$count Einträge';
  }

  @override
  String get weeklyPlanEmpty => 'Erstelle deinen Wochenplan';

  @override
  String get weekMoodTitle => 'Wochenstimmung';

  @override
  String get weekMoodLoadError => 'Stimmung konnte nicht geladen werden';

  @override
  String featureLockedDaysRemaining(int remaining) {
    return 'Noch $remaining Tage aufzeichnen zum Freischalten';
  }

  @override
  String get featureLockedSoon => 'Bald verfügbar';

  @override
  String get weeklyPlanScreenTitle => 'Wochenplan';

  @override
  String get weeklyPlanSave => 'Speichern';

  @override
  String get weeklyPlanSaveSuccess => 'Gespeichert';

  @override
  String get weeklyPlanSaveError => 'Speichern fehlgeschlagen';

  @override
  String get weeklyPlanOneLine => 'Ein Satz für dich selbst diese Woche';

  @override
  String get weeklyPlanOneLineHint => 'Diese Woche möchte ich...';

  @override
  String get weeklyPlanUrgentImportant => 'Dringend & Wichtig';

  @override
  String get weeklyPlanImportantNotUrgent => 'Wichtig, nicht dringend';

  @override
  String get weeklyPlanUrgentNotImportant => 'Dringend, nicht wichtig';

  @override
  String get weeklyPlanNotUrgentNotImportant => 'Weder dringend noch wichtig';

  @override
  String get weeklyPlanAddHint => 'Hinzufügen...';

  @override
  String get weeklyPlanMustDo => 'Muss';

  @override
  String get weeklyPlanShouldDo => 'Sollte';

  @override
  String get weeklyPlanNeedToDo => 'Könnte';

  @override
  String get weeklyPlanWantToDo => 'Möchte';

  @override
  String monthlyCalendarYearMonth(int year, int month) {
    return '$month/$year';
  }

  @override
  String get monthlyCalendarLoadError => 'Laden fehlgeschlagen';

  @override
  String get monthlyGoalsTitle => 'Monatsziele';

  @override
  String monthlyGoalHint(int index) {
    return 'Ziel $index';
  }

  @override
  String get monthlySaveError => 'Speichern fehlgeschlagen';

  @override
  String get monthlyMemoryTitle => 'Monatserinnerung';

  @override
  String get monthlyMemoryHint => 'Die schönste Erinnerung dieses Monats...';

  @override
  String get monthlyAchievementTitle => 'Monatserfolg';

  @override
  String get monthlyAchievementHint =>
      'Mein stolzester Erfolg dieses Monats...';

  @override
  String get yearlyMessagesTitle => 'Jahresbotschaften';

  @override
  String get yearlyMessageBecome => 'Dieses Jahr möchte ich werden...';

  @override
  String get yearlyMessageGoals => 'Ziele erreichen';

  @override
  String get yearlyMessageBreakthrough => 'Durchbruch schaffen';

  @override
  String get yearlyMessageDontDo =>
      'Nicht tun (Nein sagen schafft Raum für Wichtiges)';

  @override
  String get yearlyMessageKeyword =>
      'Jahres-Schlagwort (z.B. Fokus/Mut/Geduld/Sanftmut)';

  @override
  String get yearlyMessageFutureSelf => 'An mein zukünftiges Ich';

  @override
  String get yearlyMessageMotto => 'Mein Leitmotto';

  @override
  String get growthPlanTitle => 'Jahres-Wachstumsplan';

  @override
  String get growthPlanHint => 'Mein Plan...';

  @override
  String get growthPlanSaveError => 'Speichern fehlgeschlagen';

  @override
  String get growthDimensionHealth => 'Körperliche Gesundheit';

  @override
  String get growthDimensionEmotion => 'Emotionale Gesundheit';

  @override
  String get growthDimensionRelationship => 'Beziehungen';

  @override
  String get growthDimensionCareer => 'Karriere';

  @override
  String get growthDimensionFinance => 'Finanzen';

  @override
  String get growthDimensionLearning => 'Weiterbildung';

  @override
  String get growthDimensionCreativity => 'Kreativität';

  @override
  String get growthDimensionSpirituality => 'Inneres Wachstum';

  @override
  String get smallWinTitle => 'Kleine-Siege-Challenge';

  @override
  String smallWinEmpty(int days) {
    return 'Starte eine $days-Tage-Challenge, jeden Tag ein kleines Stück';
  }

  @override
  String smallWinReward(String reward) {
    return 'Belohnung: $reward';
  }

  @override
  String get smallWinLoadError => 'Laden fehlgeschlagen';

  @override
  String get smallWinLawVisible => 'Sichtbar';

  @override
  String get smallWinLawAttractive => 'Attraktiv';

  @override
  String get smallWinLawEasy => 'Einfach';

  @override
  String get smallWinLawRewarding => 'Belohnend';

  @override
  String get moodTrackerTitle => 'Stimmungstracker';

  @override
  String get moodTrackerLoadError => 'Laden fehlgeschlagen';

  @override
  String moodTrackerCount(int count) {
    return '$count Mal';
  }

  @override
  String get habitTrackerTitle => 'Monatliche Leidenschaft';

  @override
  String get habitTrackerComingSoon => 'Gewohnheits-Tracking in Entwicklung';

  @override
  String get habitTrackerComingSoonHint =>
      'Setze Gewohnheiten in der Kleine-Siege-Challenge';

  @override
  String get listsTitle => 'Meine Listen';

  @override
  String get listBookTitle => 'Bücherliste';

  @override
  String get listMovieTitle => 'Filmliste';

  @override
  String get listCustomTitle => 'Eigene Liste';

  @override
  String listItemCount(int count) {
    return '$count Einträge';
  }

  @override
  String get listDetailBookTitle => 'Meine Bücherliste';

  @override
  String get listDetailMovieTitle => 'Meine Filmliste';

  @override
  String get listDetailCustomTitle => 'Meine Liste';

  @override
  String get listDetailSave => 'Speichern';

  @override
  String get listDetailSaveSuccess => 'Gespeichert';

  @override
  String get listDetailSaveError => 'Speichern fehlgeschlagen';

  @override
  String get listDetailCustomNameLabel => 'Listenname';

  @override
  String get listDetailCustomNameHint => 'z.B. Meine Podcast-Liste';

  @override
  String get listDetailItemTitleHint => 'Titel';

  @override
  String get listDetailItemDateHint => 'Datum';

  @override
  String get listDetailItemGenreHint => 'Genre/Tag';

  @override
  String get listDetailItemKeywordHint => 'Schlagwörter/Gedanken';

  @override
  String get listDetailYearTreasure => 'Jahresschatz';

  @override
  String get listDetailYearPick => 'Jahresfavorit';

  @override
  String get listDetailYearPickHint => 'Die Empfehlung des Jahres';

  @override
  String get listDetailInsight => 'Aha-Moment';

  @override
  String get listDetailInsightHint =>
      'Die größte Inspiration aus Büchern/Filmen';

  @override
  String get exploreMyMoments => 'Meine Momente';

  @override
  String get exploreMyMomentsDesc => 'Glücks- und Highlight-Momente festhalten';

  @override
  String get exploreHabitPact => 'Mein Gewohnheitspakt';

  @override
  String get exploreHabitPactDesc =>
      'Gestalte eine neue Gewohnheit mit den vier Gesetzen';

  @override
  String get exploreWorryUnload => 'Sorgen-Entladetag';

  @override
  String get exploreWorryUnloadDesc =>
      'Sortiere Sorgen: loslassen, handeln oder akzeptieren';

  @override
  String get exploreSelfPraise => 'Mein Lobkreis';

  @override
  String get exploreSelfPraiseDesc => 'Schreibe 5 deiner Stärken auf';

  @override
  String get exploreSupportMap => 'Meine Unterstützer';

  @override
  String get exploreSupportMapDesc => 'Halte fest, wer dich unterstützt';

  @override
  String get exploreFutureSelf => 'Mein zukünftiges Ich';

  @override
  String get exploreFutureSelfDesc =>
      'Stelle dir 3 Versionen deiner Zukunft vor';

  @override
  String get exploreIdealVsReal => 'Ideal-Ich vs. Real-Ich';

  @override
  String get exploreIdealVsRealDesc =>
      'Finde heraus, wo Ideal und Realität sich treffen';

  @override
  String get highlightScreenTitle => 'Meine Momente';

  @override
  String get highlightTabHappy => 'Glücksmomente';

  @override
  String get highlightTabHighlight => 'Highlights';

  @override
  String get highlightEmptyHappy => 'Noch keine Glücksmomente erfasst';

  @override
  String get highlightEmptyHighlight => 'Noch keine Highlights erfasst';

  @override
  String highlightLoadError(String error) {
    return 'Laden fehlgeschlagen: $error';
  }

  @override
  String get monthlyPlanScreenTitle => 'Monatsplan';

  @override
  String get monthlyPlanSave => 'Speichern';

  @override
  String get monthlyPlanSaveSuccess => 'Gespeichert';

  @override
  String get monthlyPlanSaveError => 'Speichern fehlgeschlagen';

  @override
  String get monthlyPlanGoalsSection => 'Monatsziele';

  @override
  String get monthlyPlanChallengeSection => 'Kleine-Siege-Challenge';

  @override
  String get monthlyPlanChallengeNameLabel => 'Challenge-Gewohnheit';

  @override
  String get monthlyPlanChallengeNameHint => 'z.B. Täglich 10 Min. laufen';

  @override
  String get monthlyPlanRewardLabel => 'Belohnung nach Abschluss';

  @override
  String get monthlyPlanRewardHint => 'z.B. Ein Buch kaufen';

  @override
  String get monthlyPlanSelfCareSection => 'Selbstfürsorge';

  @override
  String monthlyPlanActivityHint(int index) {
    return 'Aktivität $index';
  }

  @override
  String get monthlyPlanMemorySection => 'Monatserinnerung';

  @override
  String get monthlyPlanMemoryHint =>
      'Die schönste Erinnerung dieses Monats...';

  @override
  String get monthlyPlanAchievementSection => 'Monatserfolg';

  @override
  String get monthlyPlanAchievementHint =>
      'Mein stolzester Erfolg dieses Monats...';

  @override
  String yearlyPlanScreenTitle(int year) {
    return 'Jahresplan $year';
  }

  @override
  String get yearlyPlanSave => 'Speichern';

  @override
  String get yearlyPlanSaveSuccess => 'Gespeichert';

  @override
  String get yearlyPlanSaveError => 'Speichern fehlgeschlagen';

  @override
  String get yearlyPlanMessagesSection => 'Jahresbotschaften';

  @override
  String get yearlyPlanGrowthSection => 'Wachstumsplan';

  @override
  String get growthReviewScreenTitle => 'Wachstumsrückblick';

  @override
  String get growthReviewMyMoments => 'Meine Momente';

  @override
  String get growthReviewEmptyMoments => 'Noch keine Highlights erfasst';

  @override
  String get growthReviewMySummary => 'Mein Fazit';

  @override
  String get growthReviewSummaryPrompt =>
      'Wenn du auf diese Reise zurückblickst, was möchtest du dir sagen?';

  @override
  String get growthReviewSmallWins => 'Kleine-Siege-Auszeichnungen';

  @override
  String get growthReviewConsistentRecord => 'Konsequentes Aufzeichnen';

  @override
  String growthReviewRecordedDays(int count) {
    return 'Du hast $count Tage aufgezeichnet';
  }

  @override
  String get growthReviewWeeklyChamp => 'Wochenreview-Champion';

  @override
  String growthReviewCompletedReviews(int count) {
    return '$count Wochenreviews abgeschlossen';
  }

  @override
  String get growthReviewWarmClose => 'Ein warmer Abschluss';

  @override
  String get growthReviewEveryStar => 'Jeder Tag ist ein Stern';

  @override
  String growthReviewKeepShining(int count) {
    return 'Du hast $count Sterne gesammelt. Strahle weiter!';
  }

  @override
  String get futureSelfScreenTitle => 'Mein zukünftiges Ich';

  @override
  String get futureSelfSubtitle => 'Stelle dir 3 Versionen deiner Zukunft vor';

  @override
  String get futureSelfHint =>
      'Keine perfekten Antworten nötig, lass deine Fantasie fließen';

  @override
  String get futureSelfStable => 'Stabile Zukunft';

  @override
  String get futureSelfStableHint =>
      'Wenn alles glatt läuft, wie sieht dein Leben aus?';

  @override
  String get futureSelfFree => 'Freie Zukunft';

  @override
  String get futureSelfFreeHint =>
      'Ohne Einschränkungen, was würdest du am liebsten tun?';

  @override
  String get futureSelfPace => 'Zukunft in deinem Tempo';

  @override
  String get futureSelfPaceHint => 'Ohne Eile, was wäre dein ideales Tempo?';

  @override
  String get futureSelfCoreLabel => 'Was ist dir wirklich wichtig?';

  @override
  String get futureSelfCoreHint =>
      'Was haben die 3 Versionen gemeinsam? Das könnte dein wahrer Kern sein...';

  @override
  String get habitPactScreenTitle => 'Mein Gewohnheitspakt';

  @override
  String get habitPactStep1 => 'Welche Gewohnheit möchte ich aufbauen?';

  @override
  String get habitPactCategoryLearning => 'Lernen';

  @override
  String get habitPactCategoryHealth => 'Gesundheit';

  @override
  String get habitPactCategoryRelationship => 'Beziehungen';

  @override
  String get habitPactCategoryHobby => 'Hobby';

  @override
  String get habitPactHabitLabel => 'Konkrete Gewohnheit';

  @override
  String get habitPactHabitHint => 'z.B. Täglich 20 Seiten lesen';

  @override
  String get habitPactStep2 => 'Die vier Gesetze der Gewohnheit';

  @override
  String get habitPactLawVisible => 'Sichtbar machen';

  @override
  String get habitPactLawVisibleHint => 'Ich platziere den Auslöser bei...';

  @override
  String get habitPactLawAttractive => 'Attraktiv machen';

  @override
  String get habitPactLawAttractiveHint => 'Ich verknüpfe es mit...';

  @override
  String get habitPactLawEasy => 'Einfach machen';

  @override
  String get habitPactLawEasyHint => 'Meine Minimalversion ist...';

  @override
  String get habitPactLawRewarding => 'Befriedigend machen';

  @override
  String get habitPactLawRewardingHint => 'Danach belohne ich mich mit...';

  @override
  String get habitPactStep3 => 'Aktionserklärung';

  @override
  String get habitPactDeclarationEmpty =>
      'Fülle oben aus, um deine Erklärung zu generieren...';

  @override
  String habitPactDeclarationPrefix(String habit) {
    return 'Ich verpflichte mich, die Gewohnheit \"$habit\" aufzubauen';
  }

  @override
  String habitPactDeclarationWhen(String cue) {
    return 'wenn $cue';
  }

  @override
  String habitPactDeclarationWill(String response) {
    return 'werde ich $response';
  }

  @override
  String habitPactDeclarationThen(String reward) {
    return 'und dann $reward';
  }

  @override
  String get idealVsRealScreenTitle => 'Ideal-Ich vs. Real-Ich';

  @override
  String get idealVsRealIdeal => 'Ideal-Ich';

  @override
  String get idealVsRealIdealHint => 'Was für ein Mensch möchte ich sein?';

  @override
  String get idealVsRealReal => 'Real-Ich';

  @override
  String get idealVsRealRealHint => 'Was für ein Mensch bin ich jetzt?';

  @override
  String get idealVsRealSame => 'Was ist gleich?';

  @override
  String get idealVsRealSameHint =>
      'Wo überschneiden sich Ideal und Realität bereits?';

  @override
  String get idealVsRealDiff => 'Was ist anders?';

  @override
  String get idealVsRealDiffHint =>
      'Wo liegt die Lücke? Wie fühlt sie sich an?';

  @override
  String get idealVsRealStep => 'Ein kleiner Schritt näher ans Ideal';

  @override
  String get idealVsRealStepHint =>
      'Eine Kleinigkeit, die ich heute tun kann...';

  @override
  String get selfPraiseScreenTitle => 'Mein Lobkreis';

  @override
  String get selfPraiseSubtitle => 'Schreibe 5 deiner Stärken auf';

  @override
  String get selfPraiseHint =>
      'Jeder verdient es, gesehen zu werden, besonders von sich selbst';

  @override
  String selfPraiseStrengthLabel(int index) {
    return 'Stärke $index';
  }

  @override
  String get selfPraisePrompt1 => 'Meine wärmste Eigenschaft ist...';

  @override
  String get selfPraisePrompt2 => 'Etwas, worin ich gut bin...';

  @override
  String get selfPraisePrompt3 => 'Wofür werde ich oft gelobt...';

  @override
  String get selfPraisePrompt4 => 'Worauf ich stolz bin...';

  @override
  String get selfPraisePrompt5 => 'Was mich einzigartig macht...';

  @override
  String get supportMapScreenTitle => 'Meine Unterstützer';

  @override
  String get supportMapSubtitle => 'Wer unterstützt dich?';

  @override
  String get supportMapHint =>
      'Halte wichtige Menschen fest, um dich zu erinnern: Du bist nicht allein';

  @override
  String get supportMapNameLabel => 'Name';

  @override
  String get supportMapRelationLabel => 'Beziehung';

  @override
  String get supportMapRelationHint => 'z.B. Freund/Familie/Kollege';

  @override
  String get supportMapAdd => 'Hinzufügen';

  @override
  String get worryUnloadScreenTitle => 'Sorgen-Entladetag';

  @override
  String worryUnloadLoadError(String error) {
    return 'Laden fehlgeschlagen: $error';
  }

  @override
  String get worryUnloadEmptyTitle => 'Keine aktiven Sorgen';

  @override
  String get worryUnloadEmptyHint => 'Super! Heute ist ein leichter Tag';

  @override
  String get worryUnloadIntro => 'Schau dir deine Sorgen an und sortiere sie';

  @override
  String get worryUnloadLetGo => 'Loslassen';

  @override
  String get worryUnloadTakeAction => 'Handeln';

  @override
  String get worryUnloadAccept => 'Vorerst akzeptieren';

  @override
  String get worryUnloadResultTitle => 'Entlade-Ergebnis';

  @override
  String worryUnloadSummary(String label, int count) {
    return '$label: $count';
  }

  @override
  String get worryUnloadEncouragement =>
      'Jedes Sortieren ist ein Schritt nach vorn.';

  @override
  String get commonSaved => 'Gespeichert';

  @override
  String get commonSaveError => 'Speichern fehlgeschlagen';

  @override
  String get commonLoadError => 'Laden fehlgeschlagen';

  @override
  String get momentEditTitle => 'Moment bearbeiten';

  @override
  String get momentNewHappy => 'Glücksmoment festhalten';

  @override
  String get momentNewHighlight => 'Highlight festhalten';

  @override
  String get momentDescHappy => 'Etwas Schönes';

  @override
  String get momentDescHighlight => 'Was ist passiert';

  @override
  String get momentCompanionHappy => 'Mit wem warst du zusammen';

  @override
  String get momentCompanionHighlight => 'Was ich getan habe';

  @override
  String get momentFeeling => 'Gefühl';

  @override
  String get momentDate => 'Datum (JJJJ-MM-TT)';

  @override
  String get momentRating => 'Bewertung';

  @override
  String get momentDescRequired => 'Bitte eine Beschreibung eingeben';

  @override
  String momentWithCompanion(String companion) {
    return 'Mit $companion';
  }

  @override
  String momentDidAction(String action) {
    return 'Ich habe: $action';
  }

  @override
  String get annualCalendarTitle => 'Mein Jahreskalender';

  @override
  String annualCalendarMonthLabel(int month) {
    return 'Monat $month';
  }
}
