// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class SIt extends S {
  SIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Hachimi';

  @override
  String get homeTabToday => 'Oggi';

  @override
  String get homeTabCatHouse => 'Casa dei gatti';

  @override
  String get homeTabStats => 'Statistiche';

  @override
  String get homeTabProfile => 'Profilo';

  @override
  String get adoptionStepDefineHabit => 'Definisci abitudine';

  @override
  String get adoptionStepAdoptCat => 'Adotta un gatto';

  @override
  String get adoptionStepNameCat => 'Dai un nome';

  @override
  String get adoptionHabitName => 'Nome abitudine';

  @override
  String get adoptionHabitNameHint => 'es. Lettura quotidiana';

  @override
  String get adoptionDailyGoal => 'Obiettivo giornaliero';

  @override
  String get adoptionTargetHours => 'Ore obiettivo';

  @override
  String get adoptionTargetHoursHint =>
      'Ore totali per completare questa abitudine';

  @override
  String adoptionMinutes(int count) {
    return '$count min';
  }

  @override
  String get adoptionRefreshCat => 'Provane un altro';

  @override
  String adoptionPersonality(String name) {
    return 'Personalità: $name';
  }

  @override
  String get adoptionNameYourCat => 'Dai un nome al tuo gatto';

  @override
  String get adoptionRandomName => 'Casuale';

  @override
  String get adoptionCreate => 'Crea abitudine e adotta';

  @override
  String get adoptionNext => 'Avanti';

  @override
  String get adoptionBack => 'Indietro';

  @override
  String get adoptionCatNameLabel => 'Nome del gatto';

  @override
  String get adoptionCatNameHint => 'es. Mochi';

  @override
  String get adoptionRandomNameTooltip => 'Nome casuale';

  @override
  String get catHouseTitle => 'Casa dei gatti';

  @override
  String get catHouseEmpty =>
      'Nessun gatto ancora! Crea un\'abitudine per adottare il tuo primo gatto.';

  @override
  String catHouseGrowth(int minutes, int target) {
    return '$minutes / $target min';
  }

  @override
  String get catDetailGrowthProgress => 'Progresso di crescita';

  @override
  String catDetailTotalMinutes(int minutes) {
    return '$minutes min di concentrazione';
  }

  @override
  String catDetailTargetMinutes(int minutes) {
    return 'Obiettivo: $minutes min';
  }

  @override
  String get catDetailRename => 'Rinomina';

  @override
  String get catDetailAccessories => 'Accessori';

  @override
  String get catDetailStartFocus => 'Inizia la concentrazione';

  @override
  String get catDetailBoundHabit => 'Abitudine collegata';

  @override
  String catDetailStage(String stage) {
    return 'Stadio: $stage';
  }

  @override
  String coinBalance(int amount) {
    return '$amount monete';
  }

  @override
  String coinCheckInReward(int amount) {
    return '+$amount monete!';
  }

  @override
  String get coinCheckInTitle => 'Check-in giornaliero';

  @override
  String get coinInsufficientBalance => 'Monete insufficienti';

  @override
  String get shopTitle => 'Negozio accessori';

  @override
  String shopPrice(int price) {
    return '$price monete';
  }

  @override
  String get shopPurchase => 'Compra';

  @override
  String get shopEquipped => 'Equipaggiato';

  @override
  String focusCompleteMinutes(int minutes) {
    return '+$minutes min';
  }

  @override
  String get focusCompleteStageUp => 'Stadio superiore!';

  @override
  String get focusCompleteGreatJob => 'Ottimo lavoro!';

  @override
  String get focusCompleteDone => 'Fatto';

  @override
  String get focusCompleteItsOkay => 'Va tutto bene!';

  @override
  String focusCompleteEvolved(String catName) {
    return '$catName si è evoluto!';
  }

  @override
  String focusCompleteFocusedFor(int minutes) {
    return 'Ti sei concentrato per $minutes minuti';
  }

  @override
  String focusCompleteAbandonedMessage(String catName) {
    return '$catName dice: \"Riproveremo!\"';
  }

  @override
  String get focusCompleteFocusTime => 'Tempo di concentrazione';

  @override
  String get focusCompleteCoinsEarned => 'Monete guadagnate';

  @override
  String get focusCompleteBaseXp => 'XP base';

  @override
  String get focusCompleteStreakBonus => 'Bonus serie';

  @override
  String get focusCompleteMilestoneBonus => 'Bonus traguardo';

  @override
  String get focusCompleteFullHouseBonus => 'Bonus casa piena';

  @override
  String get focusCompleteTotal => 'Totale';

  @override
  String focusCompleteEvolvedTo(String stage) {
    return 'Evoluto a $stage!';
  }

  @override
  String get focusCompleteYourCat => 'Il tuo gatto';

  @override
  String get focusCompleteDiaryWriting => 'Scrittura del diario...';

  @override
  String get focusCompleteDiaryWritten => 'Diario scritto!';

  @override
  String get focusCompleteNotifTitle => 'Quest completata!';

  @override
  String focusCompleteNotifBody(String catName, int xp, int minutes) {
    return '$catName ha guadagnato +$xp XP con $minutes min di concentrazione';
  }

  @override
  String get stageKitten => 'Gattino';

  @override
  String get stageAdolescent => 'Adolescente';

  @override
  String get stageAdult => 'Adulto';

  @override
  String get stageSenior => 'Senior';

  @override
  String get migrationTitle => 'Aggiornamento dati necessario';

  @override
  String get migrationMessage =>
      'Hachimi è stato aggiornato con un nuovo sistema di gatti pixel! I tuoi vecchi dati sui gatti non sono più compatibili. Resetta per ricominciare con la nuova esperienza.';

  @override
  String get migrationResetButton => 'Resetta e ricomincia';

  @override
  String get sessionResumeTitle => 'Riprendere la sessione?';

  @override
  String sessionResumeMessage(String habitName, String elapsed) {
    return 'Avevi una sessione di concentrazione attiva ($habitName, $elapsed). Riprendere?';
  }

  @override
  String get sessionResumeButton => 'Riprendi';

  @override
  String get sessionDiscard => 'Scarta';

  @override
  String get todaySummaryMinutes => 'Oggi';

  @override
  String get todaySummaryTotal => 'Totale';

  @override
  String get todaySummaryCats => 'Gatti';

  @override
  String get todayYourQuests => 'Le tue quest';

  @override
  String get todayNoQuests => 'Nessuna quest ancora';

  @override
  String get todayNoQuestsHint =>
      'Tocca + per iniziare una quest e adottare un gatto!';

  @override
  String get todayFocus => 'Concentrazione';

  @override
  String get todayDeleteQuestTitle => 'Eliminare la quest?';

  @override
  String todayDeleteQuestMessage(String name) {
    return 'Vuoi davvero eliminare \"$name\"? Il gatto verrà trasferito nel tuo album.';
  }

  @override
  String todayQuestCompleted(String name) {
    return '$name completata';
  }

  @override
  String get todayFailedToLoad => 'Impossibile caricare le quest';

  @override
  String todayMinToday(int count) {
    return '$count min oggi';
  }

  @override
  String todayGoalMinPerDay(int count) {
    return 'Obiettivo: $count min/giorno';
  }

  @override
  String get todayFeaturedCat => 'Gatto in primo piano';

  @override
  String get todayAddHabit => 'Aggiungi abitudine';

  @override
  String get todayNoHabits => 'Crea la tua prima abitudine per iniziare!';

  @override
  String get todayNewQuest => 'Nuova quest';

  @override
  String get todayStartFocus => 'Inizia la concentrazione';

  @override
  String get timerStart => 'Inizia';

  @override
  String get timerPause => 'Pausa';

  @override
  String get timerResume => 'Riprendi';

  @override
  String get timerDone => 'Fatto';

  @override
  String get timerGiveUp => 'Abbandona';

  @override
  String get timerRemaining => 'Rimanente';

  @override
  String get timerElapsed => 'Trascorso';

  @override
  String get timerPaused => 'IN PAUSA';

  @override
  String get timerQuestNotFound => 'Quest non trovata';

  @override
  String get timerNotificationBanner =>
      'Attiva le notifiche per vedere il progresso del timer quando l\'app è in background';

  @override
  String get timerNotificationDismiss => 'Chiudi';

  @override
  String get timerNotificationEnable => 'Attiva';

  @override
  String timerGraceBack(int seconds) {
    return 'Indietro (${seconds}s)';
  }

  @override
  String get giveUpTitle => 'Abbandonare?';

  @override
  String get giveUpMessage =>
      'Se hai mantenuto la concentrazione per almeno 5 minuti, il tempo conta comunque per la crescita del tuo gatto. Il tuo gatto capirà!';

  @override
  String get giveUpKeepGoing => 'Continua';

  @override
  String get giveUpConfirm => 'Abbandona';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsGeneral => 'Generali';

  @override
  String get settingsAppearance => 'Aspetto';

  @override
  String get settingsNotifications => 'Notifiche';

  @override
  String get settingsNotificationFocusReminders => 'Promemoria concentrazione';

  @override
  String get settingsNotificationSubtitle =>
      'Ricevi promemoria giornalieri per restare in carreggiata';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsLanguageSystem => 'Predefinito del sistema';

  @override
  String get settingsLanguageEnglish => 'Inglese';

  @override
  String get settingsLanguageChinese => '中文';

  @override
  String get settingsThemeMode => 'Modalità tema';

  @override
  String get settingsThemeModeSystem => 'Sistema';

  @override
  String get settingsThemeModeLight => 'Chiaro';

  @override
  String get settingsThemeModeDark => 'Scuro';

  @override
  String get settingsThemeColor => 'Colore del tema';

  @override
  String get settingsThemeColorDynamic => 'Dinamico';

  @override
  String get settingsThemeColorDynamicSubtitle => 'Usa i colori dello sfondo';

  @override
  String get settingsAbout => 'Informazioni';

  @override
  String get settingsVersion => 'Versione';

  @override
  String get settingsLicenses => 'Licenze';

  @override
  String get settingsAccount => 'Account';

  @override
  String get logoutTitle => 'Disconnettersi?';

  @override
  String get logoutMessage => 'Vuoi davvero disconnetterti?';

  @override
  String get loggingOut => 'Disconnessione in corso...';

  @override
  String get deleteAccountTitle => 'Eliminare l\'account?';

  @override
  String get deleteAccountMessage =>
      'Questa azione eliminerà permanentemente il tuo account e tutti i tuoi dati. Non può essere annullata.';

  @override
  String get deleteAccountWarning => 'Questa azione non può essere annullata';

  @override
  String get profileTitle => 'Profilo';

  @override
  String get profileYourJourney => 'Il tuo percorso';

  @override
  String get profileTotalFocus => 'Concentrazione totale';

  @override
  String get profileTotalCats => 'Gatti totali';

  @override
  String get profileTotalQuests => 'Quest';

  @override
  String get profileEditName => 'Modifica nome';

  @override
  String get profileDisplayName => 'Nome visualizzato';

  @override
  String get profileChooseAvatar => 'Scegli avatar';

  @override
  String get profileSaved => 'Profilo salvato';

  @override
  String get profileSettings => 'Impostazioni';

  @override
  String get habitDetailStreak => 'Serie';

  @override
  String get habitDetailBestStreak => 'Migliore';

  @override
  String get habitDetailTotalMinutes => 'Totale';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonConfirm => 'Conferma';

  @override
  String get commonSave => 'Salva';

  @override
  String get commonDelete => 'Elimina';

  @override
  String get commonEdit => 'Modifica';

  @override
  String get commonDone => 'Fatto';

  @override
  String get commonDismiss => 'Chiudi';

  @override
  String get commonEnable => 'Attiva';

  @override
  String get commonLoading => 'Caricamento...';

  @override
  String get commonError => 'Qualcosa è andato storto';

  @override
  String get commonRetry => 'Riprova';

  @override
  String get commonResume => 'Riprendi';

  @override
  String get commonPause => 'Pausa';

  @override
  String get commonLogOut => 'Esci';

  @override
  String get commonDeleteAccount => 'Elimina account';

  @override
  String get commonYes => 'Sì';

  @override
  String chatDailyRemaining(int count) {
    return '$count messaggi rimasti oggi';
  }

  @override
  String get chatDailyLimitReached =>
      'Limite giornaliero di messaggi raggiunto';

  @override
  String get aiTemporarilyUnavailable =>
      'Le funzioni IA sono temporaneamente non disponibili';

  @override
  String get catDetailNotFound => 'Gatto non trovato';

  @override
  String get catDetailChatTooltip => 'Chat';

  @override
  String get catDetailRenameTooltip => 'Rinomina';

  @override
  String get catDetailGrowthTitle => 'Progresso di crescita';

  @override
  String catDetailTarget(int hours) {
    return 'Obiettivo: ${hours}h';
  }

  @override
  String get catDetailRenameTitle => 'Rinomina gatto';

  @override
  String get catDetailNewName => 'Nuovo nome';

  @override
  String get catDetailRenamed => 'Gatto rinominato!';

  @override
  String get catDetailQuestBadge => 'Quest';

  @override
  String get catDetailEditQuest => 'Modifica quest';

  @override
  String get catDetailDailyGoal => 'Obiettivo giornaliero';

  @override
  String get catDetailTodaysFocus => 'Concentrazione di oggi';

  @override
  String get catDetailTotalFocus => 'Concentrazione totale';

  @override
  String get catDetailTargetLabel => 'Obiettivo';

  @override
  String get catDetailCompletion => 'Completamento';

  @override
  String get catDetailCurrentStreak => 'Serie attuale';

  @override
  String get catDetailBestStreakLabel => 'Miglior serie';

  @override
  String get catDetailAvgDaily => 'Media giornaliera';

  @override
  String get catDetailDaysActive => 'Giorni attivi';

  @override
  String get catDetailCheckInDays => 'Giorni di check-in';

  @override
  String get catDetailEditQuestTitle => 'Modifica quest';

  @override
  String get catDetailQuestName => 'Nome quest';

  @override
  String get catDetailDailyGoalMinutes => 'Obiettivo giornaliero (minuti)';

  @override
  String get catDetailTargetTotalHours => 'Obiettivo totale (ore)';

  @override
  String get catDetailQuestUpdated => 'Quest aggiornata!';

  @override
  String get catDetailTargetCompletedHint =>
      'Obiettivo già raggiunto — ora in modalità illimitata';

  @override
  String get catDetailDailyReminder => 'Promemoria giornaliero';

  @override
  String catDetailEveryDay(String time) {
    return '$time ogni giorno';
  }

  @override
  String get catDetailNoReminder => 'Nessun promemoria impostato';

  @override
  String get catDetailChange => 'Cambia';

  @override
  String get catDetailRemoveReminder => 'Rimuovi promemoria';

  @override
  String get catDetailSet => 'Imposta';

  @override
  String catDetailReminderSet(String time) {
    return 'Promemoria impostato per le $time';
  }

  @override
  String get catDetailReminderRemoved => 'Promemoria rimosso';

  @override
  String get catDetailDiaryTitle => 'Diario Hachimi';

  @override
  String get catDetailDiaryLoading => 'Caricamento...';

  @override
  String get catDetailDiaryError => 'Impossibile caricare il diario';

  @override
  String get catDetailDiaryEmpty =>
      'Nessuna voce nel diario oggi. Completa una sessione di concentrazione!';

  @override
  String catDetailChatWith(String name) {
    return 'Chatta con $name';
  }

  @override
  String get catDetailChatSubtitle => 'Fai una conversazione con il tuo gatto';

  @override
  String get catDetailActivity => 'Attività';

  @override
  String get catDetailActivityError =>
      'Impossibile caricare i dati di attività';

  @override
  String get catDetailAccessoriesTitle => 'Accessori';

  @override
  String get catDetailEquipped => 'Equipaggiato: ';

  @override
  String get catDetailNone => 'Nessuno';

  @override
  String get catDetailUnequip => 'Rimuovi';

  @override
  String catDetailFromInventory(int count) {
    return 'Dall\'inventario ($count)';
  }

  @override
  String get catDetailNoAccessories =>
      'Nessun accessorio ancora. Visita il negozio!';

  @override
  String catDetailEquippedItem(String name) {
    return '$name equipaggiato';
  }

  @override
  String get catDetailUnequipped => 'Rimosso';

  @override
  String catDetailAbout(String name) {
    return 'Informazioni su $name';
  }

  @override
  String get catDetailAppearanceDetails => 'Dettagli aspetto';

  @override
  String get catDetailStatus => 'Stato';

  @override
  String get catDetailAdopted => 'Adottato';

  @override
  String get catDetailFurPattern => 'Motivo del pelo';

  @override
  String get catDetailFurColor => 'Colore del pelo';

  @override
  String get catDetailFurLength => 'Lunghezza del pelo';

  @override
  String get catDetailEyes => 'Occhi';

  @override
  String get catDetailWhitePatches => 'Macchie bianche';

  @override
  String get catDetailPatchesTint => 'Tinta delle macchie';

  @override
  String get catDetailTint => 'Tinta';

  @override
  String get catDetailPoints => 'Punte colorate';

  @override
  String get catDetailVitiligo => 'Vitiligine';

  @override
  String get catDetailTortoiseshell => 'Tartaruga';

  @override
  String get catDetailTortiePattern => 'Motivo tartaruga';

  @override
  String get catDetailTortieColor => 'Colore tartaruga';

  @override
  String get catDetailSkin => 'Pelle';

  @override
  String get offlineMessage =>
      'Sei offline — le modifiche verranno sincronizzate alla riconnessione';

  @override
  String get offlineModeLabel => 'Modalità offline';

  @override
  String habitTodayMinutes(int count) {
    return 'Oggi: $count min';
  }

  @override
  String get habitDeleteTooltip => 'Elimina abitudine';

  @override
  String get heatmapActiveDays => 'Giorni attivi';

  @override
  String get heatmapTotal => 'Totale';

  @override
  String get heatmapRate => 'Tasso';

  @override
  String get heatmapLess => 'Meno';

  @override
  String get heatmapMore => 'Di più';

  @override
  String get accessoryEquipped => 'Equipaggiato';

  @override
  String get accessoryOwned => 'Posseduto';

  @override
  String get pickerMinUnit => 'min';

  @override
  String get settingsBackgroundAnimation => 'Sfondi animati';

  @override
  String get settingsBackgroundAnimationSubtitle =>
      'Gradiente mesh e particelle fluttuanti';

  @override
  String get settingsUiStyle => 'Stile UI';

  @override
  String get settingsUiStyleMaterial => 'Material 3';

  @override
  String get settingsUiStyleRetroPixel => 'Retro Pixel';

  @override
  String get settingsUiStyleMaterialSubtitle =>
      'Design Material moderno e arrotondato';

  @override
  String get settingsUiStyleRetroPixelSubtitle => 'Estetica pixel-art calda';

  @override
  String get personalityLazy => 'Pigro';

  @override
  String get personalityCurious => 'Curioso';

  @override
  String get personalityPlayful => 'Giocherellone';

  @override
  String get personalityShy => 'Timido';

  @override
  String get personalityBrave => 'Coraggioso';

  @override
  String get personalityClingy => 'Appiccicoso';

  @override
  String get personalityFlavorLazy =>
      'Dormirà 23 ore al giorno. L\'altra ora? Anche quella dormendo.';

  @override
  String get personalityFlavorCurious =>
      'Sta già annusando tutto quello che vede!';

  @override
  String get personalityFlavorPlayful =>
      'Non riesce a smettere di inseguire farfalle!';

  @override
  String get personalityFlavorShy =>
      'Ci ha messo 3 minuti per sbirciare fuori dalla scatola...';

  @override
  String get personalityFlavorBrave =>
      'È saltato fuori dalla scatola prima ancora che fosse aperta!';

  @override
  String get personalityFlavorClingy =>
      'Ha iniziato subito a fare le fusa e non molla più.';

  @override
  String get moodHappy => 'Felice';

  @override
  String get moodNeutral => 'Neutrale';

  @override
  String get moodLonely => 'Solo';

  @override
  String get moodMissing => 'Ti cerca';

  @override
  String get moodMsgLazyHappy => 'Nya~! È ora di un pisolino meritato...';

  @override
  String get moodMsgCuriousHappy => 'Cosa esploriamo oggi?';

  @override
  String get moodMsgPlayfulHappy => 'Nya~! Pronto a lavorare!';

  @override
  String get moodMsgShyHappy => '...S-Sono contento che tu sia qui.';

  @override
  String get moodMsgBraveHappy => 'Conquistiamo questa giornata insieme!';

  @override
  String get moodMsgClingyHappy => 'Evviva! Sei tornato! Non andartene più!';

  @override
  String get moodMsgLazyNeutral => '*sbadiglio* Oh, ciao...';

  @override
  String get moodMsgCuriousNeutral => 'Hmm, cos\'è quello laggiù?';

  @override
  String get moodMsgPlayfulNeutral => 'Vuoi giocare? Forse dopo...';

  @override
  String get moodMsgShyNeutral => '*sbircia fuori lentamente*';

  @override
  String get moodMsgBraveNeutral => 'Faccio la guardia, come sempre.';

  @override
  String get moodMsgClingyNeutral => 'Ti stavo aspettando...';

  @override
  String get moodMsgLazyLonely => 'Anche dormire è triste senza di te...';

  @override
  String get moodMsgCuriousLonely => 'Chissà quando tornerai...';

  @override
  String get moodMsgPlayfulLonely =>
      'I giocattoli non sono divertenti senza di te...';

  @override
  String get moodMsgShyLonely => '*si raggomitola in silenzio*';

  @override
  String get moodMsgBraveLonely => 'Continuerò ad aspettare. Sono coraggioso.';

  @override
  String get moodMsgClingyLonely => 'Dove sei andato... 🥺';

  @override
  String get moodMsgLazyMissing => '*apre un occhio con speranza*';

  @override
  String get moodMsgCuriousMissing => 'È successo qualcosa...?';

  @override
  String get moodMsgPlayfulMissing =>
      'Ho conservato il tuo giocattolo preferito...';

  @override
  String get moodMsgShyMissing => '*si nasconde, ma guarda la porta*';

  @override
  String get moodMsgBraveMissing => 'So che tornerai. Ci credo.';

  @override
  String get moodMsgClingyMissing => 'Mi manchi tanto... torna, ti prego.';

  @override
  String get peltTypeTabby => 'Strisce tabby classiche';

  @override
  String get peltTypeTicked => 'Motivo ticked agouti';

  @override
  String get peltTypeMackerel => 'Tabby sgombro';

  @override
  String get peltTypeClassic => 'Motivo a spirale classico';

  @override
  String get peltTypeSokoke => 'Motivo marmo sokoke';

  @override
  String get peltTypeAgouti => 'Ticking agouti';

  @override
  String get peltTypeSpeckled => 'Pelo maculato';

  @override
  String get peltTypeRosette => 'Rosette maculate';

  @override
  String get peltTypeSingleColour => 'Tinta unita';

  @override
  String get peltTypeTwoColour => 'Bicolore';

  @override
  String get peltTypeSmoke => 'Sfumatura smoke';

  @override
  String get peltTypeSinglestripe => 'Striscia singola';

  @override
  String get peltTypeBengal => 'Motivo bengala';

  @override
  String get peltTypeMarbled => 'Motivo marmorizzato';

  @override
  String get peltTypeMasked => 'Viso mascherato';

  @override
  String get peltColorWhite => 'Bianco';

  @override
  String get peltColorPaleGrey => 'Grigio chiaro';

  @override
  String get peltColorSilver => 'Argento';

  @override
  String get peltColorGrey => 'Grigio';

  @override
  String get peltColorDarkGrey => 'Grigio scuro';

  @override
  String get peltColorGhost => 'Grigio fantasma';

  @override
  String get peltColorBlack => 'Nero';

  @override
  String get peltColorCream => 'Crema';

  @override
  String get peltColorPaleGinger => 'Zenzero chiaro';

  @override
  String get peltColorGolden => 'Dorato';

  @override
  String get peltColorGinger => 'Zenzero';

  @override
  String get peltColorDarkGinger => 'Zenzero scuro';

  @override
  String get peltColorSienna => 'Terra di Siena';

  @override
  String get peltColorLightBrown => 'Marrone chiaro';

  @override
  String get peltColorLilac => 'Lilla';

  @override
  String get peltColorBrown => 'Marrone';

  @override
  String get peltColorGoldenBrown => 'Marrone dorato';

  @override
  String get peltColorDarkBrown => 'Marrone scuro';

  @override
  String get peltColorChocolate => 'Cioccolato';

  @override
  String get eyeColorYellow => 'Giallo';

  @override
  String get eyeColorAmber => 'Ambra';

  @override
  String get eyeColorHazel => 'Nocciola';

  @override
  String get eyeColorPaleGreen => 'Verde chiaro';

  @override
  String get eyeColorGreen => 'Verde';

  @override
  String get eyeColorBlue => 'Blu';

  @override
  String get eyeColorDarkBlue => 'Blu scuro';

  @override
  String get eyeColorBlueYellow => 'Blu-giallo';

  @override
  String get eyeColorBlueGreen => 'Blu-verde';

  @override
  String get eyeColorGrey => 'Grigio';

  @override
  String get eyeColorCyan => 'Ciano';

  @override
  String get eyeColorEmerald => 'Smeraldo';

  @override
  String get eyeColorHeatherBlue => 'Blu erica';

  @override
  String get eyeColorSunlitIce => 'Ghiaccio luminoso';

  @override
  String get eyeColorCopper => 'Rame';

  @override
  String get eyeColorSage => 'Salvia';

  @override
  String get eyeColorCobalt => 'Cobalto';

  @override
  String get eyeColorPaleBlue => 'Azzurro chiaro';

  @override
  String get eyeColorBronze => 'Bronzo';

  @override
  String get eyeColorSilver => 'Argento';

  @override
  String get eyeColorPaleYellow => 'Giallo chiaro';

  @override
  String eyeDescNormal(String color) {
    return 'Occhi $color';
  }

  @override
  String eyeDescHeterochromia(String primary, String secondary) {
    return 'Eterocromia ($primary / $secondary)';
  }

  @override
  String get skinColorPink => 'Rosa';

  @override
  String get skinColorRed => 'Rosso';

  @override
  String get skinColorBlack => 'Nero';

  @override
  String get skinColorDark => 'Scuro';

  @override
  String get skinColorDarkBrown => 'Marrone scuro';

  @override
  String get skinColorBrown => 'Marrone';

  @override
  String get skinColorLightBrown => 'Marrone chiaro';

  @override
  String get skinColorDarkGrey => 'Grigio scuro';

  @override
  String get skinColorGrey => 'Grigio';

  @override
  String get skinColorDarkSalmon => 'Salmone scuro';

  @override
  String get skinColorSalmon => 'Salmone';

  @override
  String get skinColorPeach => 'Pesca';

  @override
  String get furLengthLonghair => 'Pelo lungo';

  @override
  String get furLengthShorthair => 'Pelo corto';

  @override
  String get whiteTintOffwhite => 'Tinta bianco sporco';

  @override
  String get whiteTintCream => 'Tinta crema';

  @override
  String get whiteTintDarkCream => 'Tinta crema scuro';

  @override
  String get whiteTintGray => 'Tinta grigia';

  @override
  String get whiteTintPink => 'Tinta rosa';

  @override
  String notifReminderTitle(String catName) {
    return '$catName sente la tua mancanza!';
  }

  @override
  String notifReminderBody(String habitName) {
    return 'È ora di $habitName — il tuo gatto ti aspetta!';
  }

  @override
  String notifStreakTitle(String catName) {
    return '$catName è preoccupato!';
  }

  @override
  String notifStreakBody(int streak) {
    return 'La tua serie di $streak giorni è a rischio. Una breve sessione la salverà!';
  }

  @override
  String notifEvolutionTitle(String catName) {
    return '$catName si è evoluto!';
  }

  @override
  String notifEvolutionBody(String catName, String stageName) {
    return '$catName è cresciuto ed è diventato un $stageName! Continua così!';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String diaryScreenTitle(String name) {
    return 'Diario di $name';
  }

  @override
  String get diaryFailedToLoad => 'Impossibile caricare il diario';

  @override
  String get diaryEmptyTitle => 'Ancora nessuna voce nel diario';

  @override
  String get diaryEmptyHint =>
      'Completa una sessione di concentrazione e il tuo gatto scriverà la sua prima pagina di diario!';

  @override
  String get focusSetupCountdown => 'Conto alla rovescia';

  @override
  String get focusSetupStopwatch => 'Cronometro';

  @override
  String get focusSetupStartFocus => 'Inizia la concentrazione';

  @override
  String get focusSetupQuestNotFound => 'Quest non trovata';

  @override
  String get checkInButtonLogMore => 'Registra altro tempo';

  @override
  String get checkInButtonStart => 'Avvia timer';

  @override
  String get adoptionTitleFirst => 'Adotta il tuo primo gatto!';

  @override
  String get adoptionTitleNew => 'Nuova quest';

  @override
  String get adoptionStepDefineQuest => 'Definisci quest';

  @override
  String get adoptionStepAdoptCat2 => 'Adotta gatto';

  @override
  String get adoptionStepNameCat2 => 'Dai un nome';

  @override
  String get adoptionAdopt => 'Adotta!';

  @override
  String get adoptionQuestPrompt => 'Quale quest vuoi iniziare?';

  @override
  String get adoptionKittenHint =>
      'Un gattino ti verrà assegnato per aiutarti a restare motivato!';

  @override
  String get adoptionQuestName => 'Nome quest';

  @override
  String get adoptionQuestHint => 'es. Preparare domande per il colloquio';

  @override
  String get adoptionTotalTarget => 'Obiettivo totale (ore)';

  @override
  String get adoptionGrowthHint =>
      'Il tuo gatto cresce man mano che accumuli tempo di concentrazione';

  @override
  String get adoptionCustom => 'Personalizzato';

  @override
  String get adoptionDailyGoalLabel =>
      'Obiettivo concentrazione giornaliero (min)';

  @override
  String get adoptionReminderLabel => 'Promemoria giornaliero (opzionale)';

  @override
  String get adoptionReminderNone => 'Nessuno';

  @override
  String get adoptionCustomGoalTitle => 'Obiettivo giornaliero personalizzato';

  @override
  String get adoptionMinutesPerDay => 'Minuti al giorno';

  @override
  String get adoptionMinutesHint => '5 - 180';

  @override
  String get adoptionValidMinutes => 'Inserisci un valore tra 5 e 180';

  @override
  String get adoptionCustomTargetTitle => 'Ore obiettivo personalizzate';

  @override
  String get adoptionTotalHours => 'Ore totali';

  @override
  String get adoptionHoursHint => '10 - 2000';

  @override
  String get adoptionValidHours => 'Inserisci un valore tra 10 e 2000';

  @override
  String get adoptionSet => 'Imposta';

  @override
  String get adoptionChooseKitten => 'Scegli il tuo gattino!';

  @override
  String adoptionCompanionFor(String quest) {
    return 'Il tuo compagno per \"$quest\"';
  }

  @override
  String get adoptionRerollAll => 'Rigenera tutti';

  @override
  String get adoptionNameYourCat2 => 'Dai un nome al tuo gatto';

  @override
  String get adoptionCatName => 'Nome del gatto';

  @override
  String get adoptionCatHint => 'es. Mochi';

  @override
  String get adoptionRandomTooltip => 'Nome casuale';

  @override
  String adoptionGrowthTarget(String quest, int hours) {
    return 'Il tuo gatto crescerà mentre ti concentri su \"$quest\"! Obiettivo: ${hours}h in totale.';
  }

  @override
  String get adoptionValidQuestName => 'Inserisci un nome per la quest';

  @override
  String get adoptionValidCatName => 'Dai un nome al tuo gatto';

  @override
  String adoptionError(String message) {
    return 'Errore: $message';
  }

  @override
  String get adoptionBasicInfo => 'Info di base';

  @override
  String get adoptionGoals => 'Obiettivi';

  @override
  String get adoptionUnlimitedMode => 'Modalità illimitata';

  @override
  String get adoptionUnlimitedDesc => 'Nessun limite, continua ad accumulare';

  @override
  String get adoptionMilestoneMode => 'Modalità traguardo';

  @override
  String get adoptionMilestoneDesc => 'Imposta un obiettivo da raggiungere';

  @override
  String get adoptionDeadlineLabel => 'Scadenza';

  @override
  String get adoptionDeadlineNone => 'Non impostata';

  @override
  String get adoptionReminderSection => 'Promemoria';

  @override
  String get adoptionMotivationLabel => 'Nota';

  @override
  String get adoptionMotivationHint => 'Scrivi una nota...';

  @override
  String get adoptionMotivationSwap => 'Riempi casualmente';

  @override
  String get loginAppName => 'Hachimi';

  @override
  String get loginTagline => 'Alleva gatti. Completa quest.';

  @override
  String get loginContinueGoogle => 'Continua con Google';

  @override
  String get loginContinueEmail => 'Continua con email';

  @override
  String get loginAlreadyHaveAccount => 'Hai già un account? ';

  @override
  String get loginLogIn => 'Accedi';

  @override
  String get loginWelcomeBack => 'Bentornato!';

  @override
  String get loginCreateAccount => 'Crea il tuo account';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginConfirmPassword => 'Conferma password';

  @override
  String get loginValidEmail => 'Inserisci la tua email';

  @override
  String get loginValidEmailFormat => 'Inserisci un\'email valida';

  @override
  String get loginValidPassword => 'Inserisci la tua password';

  @override
  String get loginValidPasswordLength =>
      'La password deve avere almeno 6 caratteri';

  @override
  String get loginValidPasswordMatch => 'Le password non corrispondono';

  @override
  String get loginCreateAccountButton => 'Crea account';

  @override
  String get loginNoAccount => 'Non hai un account? ';

  @override
  String get loginRegister => 'Registrati';

  @override
  String get checkInTitle => 'Check-in mensile';

  @override
  String get checkInDays => 'Giorni';

  @override
  String get checkInCoinsEarned => 'Monete guadagnate';

  @override
  String get checkInAllMilestones => 'Tutti i traguardi raggiunti!';

  @override
  String checkInMilestoneProgress(int remaining, int bonus) {
    return 'Ancora $remaining giorni → +$bonus monete';
  }

  @override
  String get checkInMilestones => 'Traguardi';

  @override
  String get checkInFullMonth => 'Mese intero';

  @override
  String get checkInRewardSchedule => 'Piano ricompense';

  @override
  String get checkInWeekday => 'Giorni feriali (lun–ven)';

  @override
  String checkInWeekdayReward(int coins) {
    return '$coins monete/giorno';
  }

  @override
  String get checkInWeekend => 'Fine settimana (sab–dom)';

  @override
  String checkInNDays(int count) {
    return '$count giorni';
  }

  @override
  String get onboardTitle1 => 'Incontra il tuo compagno';

  @override
  String get onboardSubtitle1 => 'Ogni quest inizia con un gattino';

  @override
  String get onboardBody1 =>
      'Fissa un obiettivo e adotta un gattino.\nConcentrati e guarda il tuo gatto crescere!';

  @override
  String get onboardTitle2 => 'Concentrati, cresci, evolvi';

  @override
  String get onboardSubtitle2 => '4 stadi di crescita';

  @override
  String get onboardBody2 =>
      'Ogni minuto di concentrazione aiuta il tuo gatto a evolversi,\nda piccolo gattino a magnifico senior!';

  @override
  String get onboardTitle3 => 'Costruisci la tua stanza dei gatti';

  @override
  String get onboardSubtitle3 => 'Colleziona gatti unici';

  @override
  String get onboardBody3 =>
      'Ogni quest porta un nuovo gatto con un aspetto unico.\nScoprili tutti e costruisci la tua collezione dei sogni!';

  @override
  String get onboardSkip => 'Salta';

  @override
  String get onboardLetsGo => 'Iniziamo!';

  @override
  String get onboardNext => 'Avanti';

  @override
  String get catRoomTitle => 'Casa dei gatti';

  @override
  String get catRoomInventory => 'Inventario';

  @override
  String get catRoomShop => 'Negozio accessori';

  @override
  String get catRoomLoadError => 'Impossibile caricare i gatti';

  @override
  String get catRoomEmptyTitle => 'La tua casa dei gatti è vuota';

  @override
  String get catRoomEmptySubtitle =>
      'Inizia una quest per adottare il tuo primo gatto!';

  @override
  String get catRoomEditQuest => 'Modifica quest';

  @override
  String get catRoomRenameCat => 'Rinomina gatto';

  @override
  String get catRoomArchiveCat => 'Archivia gatto';

  @override
  String get catRoomNewName => 'Nuovo nome';

  @override
  String get catRoomRename => 'Rinomina';

  @override
  String get catRoomArchiveTitle => 'Archiviare il gatto?';

  @override
  String catRoomArchiveMessage(String name) {
    return 'Questo archivierà \"$name\" ed eliminerà la quest collegata. Il gatto apparirà comunque nel tuo album.';
  }

  @override
  String get catRoomArchive => 'Archivia';

  @override
  String catRoomAlbumSection(int count) {
    return 'Album ($count)';
  }

  @override
  String get catRoomReactivateCat => 'Riattiva gatto';

  @override
  String get catRoomReactivateTitle => 'Riattivare il gatto?';

  @override
  String catRoomReactivateMessage(String name) {
    return 'Questo ripristinerà \"$name\" e la quest collegata nella casa dei gatti.';
  }

  @override
  String get catRoomReactivate => 'Riattiva';

  @override
  String get catRoomArchivedLabel => 'Archiviato';

  @override
  String catRoomArchiveSuccess(String name) {
    return '\"$name\" archiviato';
  }

  @override
  String catRoomReactivateSuccess(String name) {
    return '\"$name\" riattivato';
  }

  @override
  String get addHabitTitle => 'Nuova quest';

  @override
  String get addHabitQuestName => 'Nome quest';

  @override
  String get addHabitQuestHint => 'es. Esercizi LeetCode';

  @override
  String get addHabitValidName => 'Inserisci un nome per la quest';

  @override
  String get addHabitTargetHours => 'Ore obiettivo';

  @override
  String get addHabitTargetHint => 'es. 100';

  @override
  String get addHabitValidTarget => 'Inserisci le ore obiettivo';

  @override
  String get addHabitValidNumber => 'Inserisci un numero valido';

  @override
  String get addHabitCreate => 'Crea quest';

  @override
  String get addHabitHoursSuffix => 'ore';

  @override
  String shopTabPlants(int count) {
    return 'Piante ($count)';
  }

  @override
  String shopTabWild(int count) {
    return 'Selvatici ($count)';
  }

  @override
  String shopTabCollars(int count) {
    return 'Collari ($count)';
  }

  @override
  String get shopNoAccessories => 'Nessun accessorio disponibile';

  @override
  String shopBuyConfirm(String name) {
    return 'Comprare $name?';
  }

  @override
  String get shopPurchaseButton => 'Acquista';

  @override
  String get shopNotEnoughCoinsButton => 'Monete insufficienti';

  @override
  String shopPurchaseSuccess(String name) {
    return 'Acquistato! $name aggiunto all\'inventario';
  }

  @override
  String shopPurchaseFailed(int price) {
    return 'Monete insufficienti (servono $price)';
  }

  @override
  String get inventoryTitle => 'Inventario';

  @override
  String inventoryInBox(int count) {
    return 'Nella scatola ($count)';
  }

  @override
  String get inventoryEmpty =>
      'Il tuo inventario è vuoto.\nVisita il negozio per ottenere accessori!';

  @override
  String inventoryEquippedOnCats(int count) {
    return 'Equipaggiati sui gatti ($count)';
  }

  @override
  String get inventoryNoEquipped =>
      'Nessun accessorio equipaggiato su alcun gatto.';

  @override
  String get inventoryUnequip => 'Rimuovi';

  @override
  String get inventoryNoActiveCats => 'Nessun gatto attivo';

  @override
  String inventoryEquipTo(String name) {
    return 'Equipaggia $name a:';
  }

  @override
  String inventoryEquipSuccess(String name) {
    return '$name equipaggiato';
  }

  @override
  String inventoryUnequipSuccess(String catName) {
    return 'Rimosso da $catName';
  }

  @override
  String get chatCatNotFound => 'Gatto non trovato';

  @override
  String chatTitle(String name) {
    return 'Chatta con $name';
  }

  @override
  String get chatClearHistory => 'Cancella cronologia';

  @override
  String chatEmptyTitle(String name) {
    return 'Saluta $name!';
  }

  @override
  String get chatEmptySubtitle =>
      'Inizia una conversazione con il tuo gatto. Risponderà in base alla sua personalità!';

  @override
  String get chatGenerating => 'Generazione in corso...';

  @override
  String get chatTypeMessage => 'Scrivi un messaggio...';

  @override
  String get chatClearConfirmTitle => 'Cancellare la cronologia chat?';

  @override
  String get chatClearConfirmMessage =>
      'Questo eliminerà tutti i messaggi. Non può essere annullato.';

  @override
  String get chatClearButton => 'Cancella';

  @override
  String get chatSend => 'Send';

  @override
  String get chatStop => 'Stop';

  @override
  String get chatErrorMessage => 'Failed to send message. Tap to retry.';

  @override
  String get chatRetry => 'Retry';

  @override
  String diaryTitle(String name) {
    return 'Diario di $name';
  }

  @override
  String get diaryLoadFailed => 'Impossibile caricare il diario';

  @override
  String get diaryRetry => 'Riprova';

  @override
  String get diaryEmptyTitle2 => 'Ancora nessuna voce nel diario';

  @override
  String get diaryEmptySubtitle =>
      'Completa una sessione di concentrazione e il tuo gatto scriverà la sua prima pagina di diario!';

  @override
  String get statsTitle => 'Statistiche';

  @override
  String get statsTotalHours => 'Ore totali';

  @override
  String statsTimeValue(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get statsBestStreak => 'Miglior serie';

  @override
  String statsStreakDays(int count) {
    return '$count giorni';
  }

  @override
  String get statsOverallProgress => 'Progresso complessivo';

  @override
  String statsPercentOfGoals(String percent) {
    return '$percent% di tutti gli obiettivi';
  }

  @override
  String get statsPerQuestProgress => 'Progresso per quest';

  @override
  String get statsQuestLoadError => 'Impossibile caricare le statistiche quest';

  @override
  String get statsNoQuestData => 'Ancora nessun dato sulle quest';

  @override
  String get statsNoQuestHint =>
      'Inizia una quest per vedere i tuoi progressi qui!';

  @override
  String get statsLast30Days => 'Ultimi 30 giorni';

  @override
  String get habitDetailQuestNotFound => 'Quest non trovata';

  @override
  String get habitDetailComplete => 'completata';

  @override
  String get habitDetailTotalTime => 'Tempo totale';

  @override
  String get habitDetailCurrentStreak => 'Serie attuale';

  @override
  String get habitDetailTarget => 'Obiettivo';

  @override
  String habitDetailDaysUnit(int count) {
    return '$count giorni';
  }

  @override
  String habitDetailHoursUnit(int count) {
    return '$count ore';
  }

  @override
  String checkInBannerSuccess(int coins) {
    return '+$coins monete! Check-in giornaliero completato';
  }

  @override
  String checkInBannerBonus(int bonus) {
    return ' + $bonus bonus traguardo!';
  }

  @override
  String get checkInBannerSemantics => 'Check-in giornaliero';

  @override
  String get checkInBannerLoading => 'Caricamento stato check-in...';

  @override
  String checkInBannerPrompt(int coins) {
    return 'Fai il check-in per +$coins monete';
  }

  @override
  String checkInBannerSummary(int count, int total, int coins) {
    return '$count/$total giorni  ·  +$coins oggi';
  }

  @override
  String commonErrorWithDetail(String error) {
    return 'Errore: $error';
  }

  @override
  String get profileFallbackUser => 'Utente';

  @override
  String get fallbackCatName => 'Gatto';

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
  String get notifFocusing => 'concentrazione in corso...';

  @override
  String get notifInProgress => 'Sessione di concentrazione in corso';

  @override
  String get unitMinShort => 'min';

  @override
  String get unitHourShort => 'h';

  @override
  String get weekdayMon => 'L';

  @override
  String get weekdayTue => 'Ma';

  @override
  String get weekdayWed => 'Me';

  @override
  String get weekdayThu => 'G';

  @override
  String get weekdayFri => 'V';

  @override
  String get weekdaySat => 'S';

  @override
  String get weekdaySun => 'D';

  @override
  String get statsTotalSessions => 'Sessioni';

  @override
  String get statsTotalHabits => 'Abitudini';

  @override
  String get statsActiveDays => 'Giorni attivi';

  @override
  String get statsWeeklyTrend => 'Tendenza settimanale';

  @override
  String get statsRecentSessions => 'Concentrazione recente';

  @override
  String get statsViewAllHistory => 'Vedi tutta la cronologia';

  @override
  String get historyTitle => 'Cronologia concentrazione';

  @override
  String get historyFilterAll => 'Tutti';

  @override
  String historySessionCount(int count) {
    return '$count sessioni';
  }

  @override
  String historyTotalMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get historyNoSessions =>
      'Ancora nessuna registrazione di concentrazione';

  @override
  String get historyNoSessionsHint =>
      'Completa una sessione di concentrazione per vederla qui';

  @override
  String get historyLoadMore => 'Carica altro';

  @override
  String get sessionCompleted => 'Completata';

  @override
  String get sessionAbandoned => 'Abbandonata';

  @override
  String get sessionInterrupted => 'Interrotta';

  @override
  String get sessionCountdown => 'Conto alla rovescia';

  @override
  String get sessionStopwatch => 'Cronometro';

  @override
  String get historyDateGroupToday => 'Oggi';

  @override
  String get historyDateGroupYesterday => 'Ieri';

  @override
  String get historyLoadError => 'Impossibile caricare la cronologia';

  @override
  String get historySelectMonth => 'Seleziona mese';

  @override
  String get historyAllMonths => 'Tutti i mesi';

  @override
  String get historyAllHabits => 'Tutte';

  @override
  String get homeTabAchievements => 'Obiettivi';

  @override
  String get achievementTitle => 'Obiettivi';

  @override
  String get achievementTabOverview => 'Panoramica';

  @override
  String get achievementTabQuest => 'Quest';

  @override
  String get achievementTabStreak => 'Serie';

  @override
  String get achievementTabCat => 'Gatto';

  @override
  String get achievementTabPersist => 'Costanza';

  @override
  String get achievementSummaryTitle => 'Progresso obiettivi';

  @override
  String achievementUnlockedCount(int count) {
    return '$count sbloccati';
  }

  @override
  String achievementTotalCoins(int coins) {
    return '$coins monete guadagnate';
  }

  @override
  String get achievementUnlocked => 'Obiettivo sbloccato!';

  @override
  String get achievementAwesome => 'Fantastico!';

  @override
  String get achievementIncredible => 'Incredibile!';

  @override
  String get achievementHidden => '???';

  @override
  String get achievementHiddenDesc => 'Questo è un obiettivo nascosto';

  @override
  String achievementPersistDesc(int days) {
    return 'Accumula $days giorni di check-in su una quest';
  }

  @override
  String achievementTitleCount(int count) {
    return '$count titoli sbloccati';
  }

  @override
  String get growthPathTitle => 'Percorso di crescita';

  @override
  String get growthPathKitten => 'Inizia un nuovo percorso';

  @override
  String get growthPathAdolescent => 'Costruisci le basi';

  @override
  String get growthPathAdult => 'Le competenze si consolidano';

  @override
  String get growthPathSenior => 'Padronanza profonda';

  @override
  String get growthPathTip =>
      'La ricerca dimostra che 20 ore di pratica concentrata bastano per costruire le basi di una nuova competenza — Josh Kaufman';

  @override
  String achievementCelebrationCoins(int count) {
    return '+$count monete';
  }

  @override
  String achievementCelebrationTitle(String title) {
    return 'Titolo ottenuto: $title';
  }

  @override
  String get achievementCelebrationDismiss => 'Fantastico!';

  @override
  String get achievementCelebrationSkipAll => 'Salta tutto';

  @override
  String achievementCelebrationCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String achievementUnlockedAt(String date) {
    return 'Sbloccato il $date';
  }

  @override
  String get achievementLocked => 'Non ancora sbloccato';

  @override
  String achievementRewardCoins(int count) {
    return '+$count monete';
  }

  @override
  String get reminderModeDaily => 'Ogni giorno';

  @override
  String get reminderModeWeekdays => 'Giorni feriali';

  @override
  String get reminderModeMonday => 'Lunedì';

  @override
  String get reminderModeTuesday => 'Martedì';

  @override
  String get reminderModeWednesday => 'Mercoledì';

  @override
  String get reminderModeThursday => 'Giovedì';

  @override
  String get reminderModeFriday => 'Venerdì';

  @override
  String get reminderModeSaturday => 'Sabato';

  @override
  String get reminderModeSunday => 'Domenica';

  @override
  String get reminderPickerTitle => 'Seleziona orario promemoria';

  @override
  String get reminderHourUnit => 'h';

  @override
  String get reminderMinuteUnit => 'min';

  @override
  String get reminderAddMore => 'Aggiungi promemoria';

  @override
  String get reminderMaxReached => 'Massimo 5 promemoria';

  @override
  String get reminderConfirm => 'Conferma';

  @override
  String reminderNotificationTitle(String catName) {
    return '$catName sente la tua mancanza!';
  }

  @override
  String reminderNotificationBody(String habitName) {
    return 'È ora di $habitName — il tuo gatto ti aspetta!';
  }

  @override
  String get deleteAccountDataWarning =>
      'Tutti i seguenti dati verranno eliminati permanentemente:';

  @override
  String get deleteAccountQuests => 'Quest';

  @override
  String get deleteAccountCats => 'Gatti';

  @override
  String get deleteAccountHours => 'Ore di concentrazione';

  @override
  String get deleteAccountIrreversible => 'Questa azione è irreversibile';

  @override
  String get deleteAccountContinue => 'Continua';

  @override
  String get deleteAccountConfirmTitle => 'Conferma eliminazione';

  @override
  String get deleteAccountTypeDelete =>
      'Scrivi DELETE per confermare l\'eliminazione dell\'account:';

  @override
  String get deleteAccountAuthCancelled => 'Autenticazione annullata';

  @override
  String deleteAccountAuthFailed(String error) {
    return 'Autenticazione fallita: $error';
  }

  @override
  String get deleteAccountProgress => 'Eliminazione account in corso...';

  @override
  String get deleteAccountSuccess => 'Account eliminato';

  @override
  String get drawerGuestLoginSubtitle =>
      'Sincronizza i dati e sblocca le funzioni IA';

  @override
  String get drawerGuestSignIn => 'Accedi';

  @override
  String get drawerMilestones => 'Traguardi';

  @override
  String drawerMilestoneFocus(int hours, int minutes) {
    return 'Concentrazione totale: ${hours}h ${minutes}m';
  }

  @override
  String drawerMilestoneCats(int count) {
    return 'Famiglia felina: $count';
  }

  @override
  String drawerMilestoneQuests(int count) {
    return 'Quest attive: $count';
  }

  @override
  String get drawerMySection => 'Il mio';

  @override
  String get drawerSessionHistory => 'Cronologia concentrazione';

  @override
  String get drawerCheckInCalendar => 'Calendario check-in';

  @override
  String get drawerAccountSection => 'Account';

  @override
  String get settingsResetData => 'Resetta tutti i dati';

  @override
  String get settingsResetDataTitle => 'Resettare tutti i dati?';

  @override
  String get settingsResetDataMessage =>
      'Questo eliminerà tutti i dati locali e tornerai alla schermata di benvenuto. Non può essere annullato.';

  @override
  String get guestUpgradeTitle => 'Proteggi i tuoi dati';

  @override
  String get guestUpgradeMessage =>
      'Collega un account per salvare i tuoi progressi, sbloccare il diario IA e la chat, e sincronizzare tra dispositivi.';

  @override
  String get guestUpgradeLinkButton => 'Collega account';

  @override
  String get guestUpgradeLater => 'Forse più tardi';

  @override
  String get loginLinkTagline =>
      'Collega un account per proteggere i tuoi dati';

  @override
  String get aiTeaserTitle => 'Diario del gatto';

  @override
  String aiTeaserPreview(String catName) {
    return 'Oggi ho studiato di nuovo con il mio umano... $catName si sente più intelligente ogni giorno~';
  }

  @override
  String aiTeaserCta(String catName) {
    return 'Collega un account per vedere cosa vuole dire $catName';
  }

  @override
  String get authErrorEmailInUse => 'Questa email è già registrata';

  @override
  String get authErrorWrongPassword => 'Email o password non corretta';

  @override
  String get authErrorUserNotFound => 'Nessun account trovato con questa email';

  @override
  String get authErrorTooManyRequests => 'Troppi tentativi. Riprova più tardi';

  @override
  String get authErrorNetwork => 'Errore di rete. Controlla la connessione';

  @override
  String get authErrorAdminRestricted =>
      'L\'accesso è temporaneamente limitato';

  @override
  String get authErrorWeakPassword =>
      'Password troppo debole. Usa almeno 6 caratteri';

  @override
  String get authErrorGeneric => 'Qualcosa è andato storto. Riprova';

  @override
  String get deleteAccountReauthEmail => 'Inserisci la password per continuare';

  @override
  String get deleteAccountReauthPasswordHint => 'Password';

  @override
  String get deleteAccountError =>
      'Qualcosa è andato storto. Riprova più tardi.';

  @override
  String get deleteAccountPermissionError =>
      'Errore di autorizzazione. Prova a disconnetterti e riaccedere.';

  @override
  String get deleteAccountNetworkError =>
      'Nessuna connessione internet. Controlla la rete.';

  @override
  String get deleteAccountRetainedData =>
      'Le analisi di utilizzo e i report di crash non possono essere eliminati.';

  @override
  String get deleteAccountStepCloud => 'Eliminazione dati cloud...';

  @override
  String get deleteAccountStepLocal => 'Eliminazione dati locali...';

  @override
  String get deleteAccountStepDone => 'Completato';

  @override
  String get deleteAccountQueued =>
      'Dati locali eliminati. L\'eliminazione dell\'account cloud è in coda e verrà completata quando sarai online.';

  @override
  String get deleteAccountPending =>
      'L\'eliminazione dell\'account è in sospeso. Mantieni l\'app online per completare l\'eliminazione cloud e autenticazione.';

  @override
  String get deleteAccountAbandon => 'Ricomincia da zero';

  @override
  String get archiveConflictTitle => 'Scegli l\'archivio da mantenere';

  @override
  String get archiveConflictMessage =>
      'Sia l\'archivio locale che quello cloud hanno dati. Scegli quale mantenere:';

  @override
  String get archiveConflictLocal => 'Archivio locale';

  @override
  String get archiveConflictCloud => 'Archivio cloud';

  @override
  String get archiveConflictKeepCloud => 'Mantieni cloud';

  @override
  String get archiveConflictKeepLocal => 'Mantieni locale';

  @override
  String get loginShowPassword => 'Mostra password';

  @override
  String get loginHidePassword => 'Nascondi password';

  @override
  String get errorGeneric => 'Qualcosa è andato storto. Riprova più tardi';

  @override
  String get errorCreateHabit => 'Impossibile creare l\'abitudine. Riprova';

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
