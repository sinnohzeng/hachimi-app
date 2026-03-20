// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class SIt extends S {
  SIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Hachimi - Light Up My Innerverse';

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
  String get focusCompleteDiarySkipped => 'Diario saltato';

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
  String get catDetailLoadError => 'Impossibile caricare i dati del gatto';

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
  String get catRoomArchiveError => 'Impossibile archiviare il gatto';

  @override
  String get catRoomReactivateError => 'Impossibile riattivare il gatto';

  @override
  String get catRoomArchiveLoadError =>
      'Impossibile caricare i gatti archiviati';

  @override
  String get catRoomRenameError => 'Impossibile rinominare il gatto';

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
  String get chatSend => 'Invia';

  @override
  String get chatStop => 'Ferma';

  @override
  String get chatErrorMessage => 'Failed to send message. Tap to retry.';

  @override
  String get chatRetry => 'Retry';

  @override
  String get chatErrorGeneric => 'Qualcosa è andato storto. Riprova.';

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

  @override
  String get commonCopyId => 'Copia ID';

  @override
  String get adoptionClearDeadline => 'Cancella scadenza';

  @override
  String get commonIdCopied => 'ID copiato';

  @override
  String get pickerDurationLabel => 'Selettore durata';

  @override
  String pickerMinutesValue(int count) {
    return '$count minuti';
  }

  @override
  String a11yCatImage(String name) {
    return 'Gatto $name';
  }

  @override
  String a11yCatTapToInteract(String name) {
    return '$name, tocca per interagire';
  }

  @override
  String a11yProgressPercent(int percent) {
    return '$percent% completato';
  }

  @override
  String a11yStreakActiveDays(int count) {
    return '$count giorni attivi';
  }

  @override
  String get a11yOfflineStatus => 'Modalità offline';

  @override
  String a11yAchievementUnlocked(String name) {
    return 'Traguardo sbloccato: $name';
  }

  @override
  String get calendarCheckedIn => 'registrato';

  @override
  String get calendarToday => 'oggi';

  @override
  String a11yEquipToCat(Object name) {
    return 'Equipaggia a $name';
  }

  @override
  String a11yRegenerateCat(Object name) {
    return 'Rigenera $name';
  }

  @override
  String a11yTimerDisplay(Object time) {
    return 'Timer: $time';
  }

  @override
  String a11yOnboardingPage(Object current, Object total) {
    return 'Pagina $current di $total';
  }

  @override
  String a11yEditDisplayName(Object name) {
    return 'Modifica nome: $name';
  }

  @override
  String get routeNotFound => 'Pagina non trovata';

  @override
  String get routeGoHome => 'Vai alla home';

  @override
  String get a11yError => 'Errore';

  @override
  String get a11yDeadline => 'Scadenza';

  @override
  String get a11yReminder => 'Promemoria';

  @override
  String get a11yFocusMeditation => 'Meditazione di concentrazione';

  @override
  String get a11yUnlocked => 'Sbloccato';

  @override
  String get a11ySelected => 'Selezionato';

  @override
  String get a11yDynamicWallpaperColor => 'Colore dinamico dello sfondo';

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
    return 'È tardi, $name';
  }

  @override
  String greetingMorning(String name) {
    return 'Buongiorno, $name';
  }

  @override
  String greetingAfternoon(String name) {
    return 'Buon pomeriggio, $name';
  }

  @override
  String greetingEvening(String name) {
    return 'Buonasera, $name';
  }

  @override
  String get greetingLateNightNoName => 'È tardi';

  @override
  String get greetingMorningNoName => 'Buongiorno';

  @override
  String get greetingAfternoonNoName => 'Buon pomeriggio';

  @override
  String get greetingEveningNoName => 'Buonasera';

  @override
  String get journeyTitle => 'Viaggio';

  @override
  String get journeySegmentWeek => 'Settimana';

  @override
  String get journeySegmentMonth => 'Mese';

  @override
  String get journeySegmentYear => 'Anno';

  @override
  String get journeySegmentExplore => 'Esplora';

  @override
  String get journeyMonthlyView => 'Vista mensile';

  @override
  String get journeyYearlyView => 'Vista annuale';

  @override
  String get journeyExploreActivities => 'Attività';

  @override
  String get journeyEditMonthlyPlan => 'Modifica piano mensile';

  @override
  String get journeyEditYearlyPlan => 'Modifica piano annuale';

  @override
  String get quickLightTitle => 'Il tuo pensiero del giorno';

  @override
  String get quickLightHint => 'Come ti senti oggi?';

  @override
  String get quickLightRecord => 'Registra';

  @override
  String get quickLightSaveSuccess => 'Registrato';

  @override
  String get quickLightSaveError => 'Salvataggio fallito. Riprova';

  @override
  String get habitSnapshotTitle => 'Abitudini di oggi';

  @override
  String get habitSnapshotEmpty =>
      'Nessuna abitudine ancora. Impostale nel tuo viaggio';

  @override
  String get habitSnapshotLoadError => 'Caricamento fallito';

  @override
  String get worryJarTitle => 'Barattolo delle preoccupazioni';

  @override
  String get worryJarLoadError => 'Caricamento fallito';

  @override
  String get weeklyReviewEmpty => 'Registra i momenti felici della settimana';

  @override
  String get weeklyReviewHappyMoments => 'Momenti felici';

  @override
  String get weeklyReviewLoadError => 'Caricamento fallito';

  @override
  String get weeklyPlanCardTitle => 'Piano settimanale';

  @override
  String weeklyPlanItemCount(int count) {
    return '$count elementi';
  }

  @override
  String get weeklyPlanEmpty => 'Crea il piano settimanale';

  @override
  String get weekMoodTitle => 'Umore settimanale';

  @override
  String get weekMoodLoadError => 'Caricamento umore fallito';

  @override
  String featureLockedDaysRemaining(int remaining) {
    return 'Registra ancora $remaining giorni per sbloccare';
  }

  @override
  String get featureLockedSoon => 'In arrivo';

  @override
  String get weeklyPlanScreenTitle => 'Piano settimanale';

  @override
  String get weeklyPlanSave => 'Salva';

  @override
  String get weeklyPlanSaveSuccess => 'Salvato';

  @override
  String get weeklyPlanSaveError => 'Salvataggio fallito';

  @override
  String get weeklyPlanOneLine => 'Una frase per te questa settimana';

  @override
  String get weeklyPlanOneLineHint => 'Questa settimana voglio...';

  @override
  String get weeklyPlanUrgentImportant => 'Urgente e importante';

  @override
  String get weeklyPlanImportantNotUrgent => 'Importante, non urgente';

  @override
  String get weeklyPlanUrgentNotImportant => 'Urgente, non importante';

  @override
  String get weeklyPlanNotUrgentNotImportant => 'Né urgente né importante';

  @override
  String get weeklyPlanAddHint => 'Aggiungi...';

  @override
  String get weeklyPlanMustDo => 'Devo';

  @override
  String get weeklyPlanShouldDo => 'Dovrei';

  @override
  String get weeklyPlanNeedToDo => 'Potrei';

  @override
  String get weeklyPlanWantToDo => 'Voglio';

  @override
  String monthlyCalendarYearMonth(int year, int month) {
    return '$month/$year';
  }

  @override
  String get monthlyCalendarLoadError => 'Caricamento fallito';

  @override
  String get monthlyGoalsTitle => 'Obiettivi del mese';

  @override
  String monthlyGoalHint(int index) {
    return 'Obiettivo $index';
  }

  @override
  String get monthlySaveError => 'Salvataggio fallito';

  @override
  String get monthlyMemoryTitle => 'Ricordo del mese';

  @override
  String get monthlyMemoryHint => 'Il ricordo più bello di questo mese...';

  @override
  String get monthlyAchievementTitle => 'Traguardo del mese';

  @override
  String get monthlyAchievementHint =>
      'Il mio più grande orgoglio questo mese...';

  @override
  String get yearlyMessagesTitle => 'Messaggi dell\'anno';

  @override
  String get yearlyMessageBecome => 'Quest\'anno vorrei diventare...';

  @override
  String get yearlyMessageGoals => 'Obiettivi da raggiungere';

  @override
  String get yearlyMessageBreakthrough => 'Svolta';

  @override
  String get yearlyMessageDontDo =>
      'Non fare (dire no crea spazio per ciò che conta)';

  @override
  String get yearlyMessageKeyword =>
      'Parola dell\'anno (es: Focus/Coraggio/Pazienza/Gentilezza)';

  @override
  String get yearlyMessageFutureSelf => 'Al mio caro me futuro';

  @override
  String get yearlyMessageMotto => 'Il mio motto';

  @override
  String get growthPlanTitle => 'Piano di crescita annuale';

  @override
  String get growthPlanHint => 'Il mio piano...';

  @override
  String get growthPlanSaveError => 'Salvataggio fallito';

  @override
  String get growthDimensionHealth => 'Salute fisica';

  @override
  String get growthDimensionEmotion => 'Benessere emotivo';

  @override
  String get growthDimensionRelationship => 'Relazioni';

  @override
  String get growthDimensionCareer => 'Carriera';

  @override
  String get growthDimensionFinance => 'Finanze';

  @override
  String get growthDimensionLearning => 'Apprendimento continuo';

  @override
  String get growthDimensionCreativity => 'Creatività';

  @override
  String get growthDimensionSpirituality => 'Crescita interiore';

  @override
  String get smallWinTitle => 'Sfida piccole vittorie';

  @override
  String smallWinEmpty(int days) {
    return 'Inizia una sfida di $days giorni, un passo alla volta';
  }

  @override
  String smallWinReward(String reward) {
    return 'Premio: $reward';
  }

  @override
  String get smallWinLoadError => 'Caricamento fallito';

  @override
  String get smallWinLawVisible => 'Visibile';

  @override
  String get smallWinLawAttractive => 'Attraente';

  @override
  String get smallWinLawEasy => 'Facile';

  @override
  String get smallWinLawRewarding => 'Gratificante';

  @override
  String get moodTrackerTitle => 'Traccia umore';

  @override
  String get moodTrackerLoadError => 'Caricamento fallito';

  @override
  String moodTrackerCount(int count) {
    return '$count volte';
  }

  @override
  String get habitTrackerTitle => 'Passione mensile';

  @override
  String get habitTrackerComingSoon => 'Tracciamento abitudini in sviluppo';

  @override
  String get habitTrackerComingSoonHint =>
      'Imposta abitudini nella sfida piccole vittorie';

  @override
  String get listsTitle => 'Le mie liste';

  @override
  String get listBookTitle => 'Libri';

  @override
  String get listMovieTitle => 'Film';

  @override
  String get listCustomTitle => 'Lista personalizzata';

  @override
  String listItemCount(int count) {
    return '$count elementi';
  }

  @override
  String get listDetailBookTitle => 'I miei libri';

  @override
  String get listDetailMovieTitle => 'I miei film';

  @override
  String get listDetailCustomTitle => 'La mia lista';

  @override
  String get listDetailSave => 'Salva';

  @override
  String get listDetailSaveSuccess => 'Salvato';

  @override
  String get listDetailSaveError => 'Errore';

  @override
  String get listDetailCustomNameLabel => 'Nome lista';

  @override
  String get listDetailCustomNameHint => 'es: I miei podcast';

  @override
  String get listDetailItemTitleHint => 'Titolo';

  @override
  String get listDetailItemDateHint => 'Data';

  @override
  String get listDetailItemGenreHint => 'Genere/Tag';

  @override
  String get listDetailItemKeywordHint => 'Parole chiave/Impressioni';

  @override
  String get listDetailYearTreasure => 'Tesoro dell\'anno';

  @override
  String get listDetailYearPick => 'Preferito dell\'anno';

  @override
  String get listDetailYearPickHint => 'Il più consigliato dell\'anno';

  @override
  String get listDetailInsight => 'Ispirazione';

  @override
  String get listDetailInsightHint =>
      'La più grande ispirazione dalle tue letture/film';

  @override
  String get exploreMyMoments => 'I miei momenti';

  @override
  String get exploreMyMomentsDesc => 'Registra momenti felici e speciali';

  @override
  String get exploreHabitPact => 'Il mio patto con le abitudini';

  @override
  String get exploreHabitPactDesc =>
      'Progetta un\'abitudine con le quattro leggi';

  @override
  String get exploreWorryUnload => 'Giornata di scarico';

  @override
  String get exploreWorryUnloadDesc =>
      'Classifica le preoccupazioni: lasciare, agire o accettare';

  @override
  String get exploreSelfPraise => 'Il mio gruppo di incoraggiamento';

  @override
  String get exploreSelfPraiseDesc => 'Scrivi 5 dei tuoi punti di forza';

  @override
  String get exploreSupportMap => 'La mia rete di supporto';

  @override
  String get exploreSupportMapDesc => 'Registra chi ti supporta';

  @override
  String get exploreFutureSelf => 'Il mio io futuro';

  @override
  String get exploreFutureSelfDesc => 'Immagina 3 versioni del tuo futuro';

  @override
  String get exploreIdealVsReal => 'Io ideale vs. Io reale';

  @override
  String get exploreIdealVsRealDesc =>
      'Scopri dove ideale e realtà si incontrano';

  @override
  String get highlightScreenTitle => 'I miei momenti';

  @override
  String get highlightTabHappy => 'Momenti felici';

  @override
  String get highlightTabHighlight => 'Momenti speciali';

  @override
  String get highlightEmptyHappy => 'Nessun momento felice';

  @override
  String get highlightEmptyHighlight => 'Nessun momento speciale';

  @override
  String highlightLoadError(String error) {
    return 'Errore: $error';
  }

  @override
  String get monthlyPlanScreenTitle => 'Piano mensile';

  @override
  String get monthlyPlanSave => 'Salva';

  @override
  String get monthlyPlanSaveSuccess => 'Salvato';

  @override
  String get monthlyPlanSaveError => 'Errore';

  @override
  String get monthlyPlanGoalsSection => 'Obiettivi mensili';

  @override
  String get monthlyPlanChallengeSection => 'Sfida piccole vittorie';

  @override
  String get monthlyPlanChallengeNameLabel => 'Abitudine della sfida';

  @override
  String get monthlyPlanChallengeNameHint => 'es: Correre 10 min/giorno';

  @override
  String get monthlyPlanRewardLabel => 'Premio';

  @override
  String get monthlyPlanRewardHint => 'es: Comprare un libro';

  @override
  String get monthlyPlanSelfCareSection => 'Cura di sé';

  @override
  String monthlyPlanActivityHint(int index) {
    return 'Attività $index';
  }

  @override
  String get monthlyPlanMemorySection => 'Ricordo del mese';

  @override
  String get monthlyPlanMemoryHint => 'Il ricordo più bello...';

  @override
  String get monthlyPlanAchievementSection => 'Traguardo del mese';

  @override
  String get monthlyPlanAchievementHint => 'Il mio più grande orgoglio...';

  @override
  String yearlyPlanScreenTitle(int year) {
    return 'Piano annuale $year';
  }

  @override
  String get yearlyPlanSave => 'Salva';

  @override
  String get yearlyPlanSaveSuccess => 'Salvato';

  @override
  String get yearlyPlanSaveError => 'Errore';

  @override
  String get yearlyPlanMessagesSection => 'Messaggi dell\'anno';

  @override
  String get yearlyPlanGrowthSection => 'Piano di crescita';

  @override
  String get growthReviewScreenTitle => 'Revisione crescita';

  @override
  String get growthReviewMyMoments => 'I miei momenti speciali';

  @override
  String get growthReviewEmptyMoments => 'Nessun momento speciale';

  @override
  String get growthReviewMySummary => 'Il mio riepilogo';

  @override
  String get growthReviewSummaryPrompt =>
      'Guardando indietro, cosa vuoi dirti?';

  @override
  String get growthReviewSmallWins => 'Premiazione piccole vittorie';

  @override
  String get growthReviewConsistentRecord => 'Costanza nel registrare';

  @override
  String growthReviewRecordedDays(int count) {
    return 'Hai registrato $count giorni';
  }

  @override
  String get growthReviewWeeklyChamp => 'Campione revisioni settimanali';

  @override
  String growthReviewCompletedReviews(int count) {
    return '$count revisioni settimanali completate';
  }

  @override
  String get growthReviewWarmClose => 'Un finale caldo';

  @override
  String get growthReviewEveryStar => 'Ogni giorno è una stella';

  @override
  String growthReviewKeepShining(int count) {
    return 'Hai raccolto $count stelle. Continua a brillare!';
  }

  @override
  String get futureSelfScreenTitle => 'Il mio io futuro';

  @override
  String get futureSelfSubtitle => 'Immagina 3 versioni del tuo futuro';

  @override
  String get futureSelfHint =>
      'Non servono risposte perfette, lascia fluire l\'immaginazione';

  @override
  String get futureSelfStable => 'Futuro stabile';

  @override
  String get futureSelfStableHint => 'Se tutto va bene, come sarà la tua vita?';

  @override
  String get futureSelfFree => 'Futuro libero';

  @override
  String get futureSelfFreeHint => 'Senza limiti, cosa faresti?';

  @override
  String get futureSelfPace => 'Futuro al tuo ritmo';

  @override
  String get futureSelfPaceHint => 'Senza fretta, qual è il tuo ritmo ideale?';

  @override
  String get futureSelfCoreLabel => 'Cosa ti sta veramente a cuore?';

  @override
  String get futureSelfCoreHint =>
      'Cosa hanno in comune le 3 versioni? Potrebbe essere l\'essenziale...';

  @override
  String get habitPactScreenTitle => 'Il mio patto con le abitudini';

  @override
  String get habitPactStep1 => 'Quale abitudine voglio creare?';

  @override
  String get habitPactCategoryLearning => 'Apprendimento';

  @override
  String get habitPactCategoryHealth => 'Salute';

  @override
  String get habitPactCategoryRelationship => 'Relazioni';

  @override
  String get habitPactCategoryHobby => 'Hobby';

  @override
  String get habitPactHabitLabel => 'Abitudine concreta';

  @override
  String get habitPactHabitHint => 'es: Leggere 20 pagine al giorno';

  @override
  String get habitPactStep2 => 'Le quattro leggi dell\'abitudine';

  @override
  String get habitPactLawVisible => 'Rendilo ovvio';

  @override
  String get habitPactLawVisibleHint => 'Metto il segnale a...';

  @override
  String get habitPactLawAttractive => 'Rendilo attraente';

  @override
  String get habitPactLawAttractiveHint => 'Lo associo con...';

  @override
  String get habitPactLawEasy => 'Rendilo facile';

  @override
  String get habitPactLawEasyHint => 'La mia versione minima è...';

  @override
  String get habitPactLawRewarding => 'Rendilo soddisfacente';

  @override
  String get habitPactLawRewardingHint => 'Poi mi premio con...';

  @override
  String get habitPactStep3 => 'Dichiarazione d\'azione';

  @override
  String get habitPactDeclarationEmpty => 'Compila sopra per generare...';

  @override
  String habitPactDeclarationPrefix(String habit) {
    return 'Mi impegno a creare l\'abitudine di \"$habit\"';
  }

  @override
  String habitPactDeclarationWhen(String cue) {
    return 'quando $cue';
  }

  @override
  String habitPactDeclarationWill(String response) {
    return 'farò $response';
  }

  @override
  String habitPactDeclarationThen(String reward) {
    return 'poi $reward';
  }

  @override
  String get idealVsRealScreenTitle => 'Io ideale vs. Io reale';

  @override
  String get idealVsRealIdeal => 'Io ideale';

  @override
  String get idealVsRealIdealHint => 'Che persona voglio essere?';

  @override
  String get idealVsRealReal => 'Io reale';

  @override
  String get idealVsRealRealHint => 'Che persona sono adesso?';

  @override
  String get idealVsRealSame => 'Cosa è uguale?';

  @override
  String get idealVsRealSameHint =>
      'Dove ideale e realtà si sovrappongono già?';

  @override
  String get idealVsRealDiff => 'Cosa è diverso?';

  @override
  String get idealVsRealDiffHint => 'Dove è il divario? Come ti fa sentire?';

  @override
  String get idealVsRealStep => 'Un piccolo passo verso l\'ideale';

  @override
  String get idealVsRealStepHint => 'Una cosa piccola che posso fare oggi...';

  @override
  String get selfPraiseScreenTitle => 'Il mio gruppo di incoraggiamento';

  @override
  String get selfPraiseSubtitle => 'Scrivi 5 dei tuoi punti di forza';

  @override
  String get selfPraiseHint =>
      'Tutti meritano di essere visti, soprattutto da se stessi';

  @override
  String selfPraiseStrengthLabel(int index) {
    return 'Punto di forza $index';
  }

  @override
  String get selfPraisePrompt1 => 'La mia qualità più calda è...';

  @override
  String get selfPraisePrompt2 => 'Qualcosa in cui sono bravo/a...';

  @override
  String get selfPraisePrompt3 => 'Mi fanno spesso complimenti per...';

  @override
  String get selfPraisePrompt4 => 'Sono orgoglioso/a di...';

  @override
  String get selfPraisePrompt5 => 'Ciò che mi rende unico/a...';

  @override
  String get supportMapScreenTitle => 'La mia rete di supporto';

  @override
  String get supportMapSubtitle => 'Chi ti supporta?';

  @override
  String get supportMapHint => 'Ricorda che non sei solo/a';

  @override
  String get supportMapNameLabel => 'Nome';

  @override
  String get supportMapRelationLabel => 'Relazione';

  @override
  String get supportMapRelationHint => 'es: Amico/Famiglia/Collega';

  @override
  String get supportMapAdd => 'Aggiungi';

  @override
  String get worryUnloadScreenTitle => 'Giornata di scarico';

  @override
  String worryUnloadLoadError(String error) {
    return 'Errore: $error';
  }

  @override
  String get worryUnloadEmptyTitle => 'Nessuna preoccupazione attiva';

  @override
  String get worryUnloadEmptyHint => 'Ottimo! Oggi è una giornata leggera';

  @override
  String get worryUnloadIntro => 'Guarda le tue preoccupazioni e classificale';

  @override
  String get worryUnloadLetGo => 'Lasciare andare';

  @override
  String get worryUnloadTakeAction => 'Agire';

  @override
  String get worryUnloadAccept => 'Accettare per ora';

  @override
  String get worryUnloadResultTitle => 'Risultati';

  @override
  String worryUnloadSummary(String label, int count) {
    return '$label: $count';
  }

  @override
  String get worryUnloadEncouragement =>
      'Ogni classificazione è un passo avanti.';

  @override
  String get commonSaved => 'Salvato';

  @override
  String get commonSaveError => 'Salvataggio fallito';

  @override
  String get commonLoadError => 'Caricamento fallito';

  @override
  String get momentEditTitle => 'Modifica momento';

  @override
  String get momentNewHappy => 'Registra un momento felice';

  @override
  String get momentNewHighlight => 'Registra un momento speciale';

  @override
  String get momentDescHappy => 'Qualcosa di bello';

  @override
  String get momentDescHighlight => 'Cos\'è successo';

  @override
  String get momentCompanionHappy => 'Con chi eri';

  @override
  String get momentCompanionHighlight => 'Cosa ho fatto';

  @override
  String get momentFeeling => 'Sensazione';

  @override
  String get momentDate => 'Data (AAAA-MM-GG)';

  @override
  String get momentRating => 'Valutazione';

  @override
  String get momentDescRequired => 'Aggiungi una descrizione';

  @override
  String momentWithCompanion(String companion) {
    return 'Con $companion';
  }

  @override
  String momentDidAction(String action) {
    return 'Ho fatto: $action';
  }

  @override
  String get annualCalendarTitle => 'Il mio calendario annuale';

  @override
  String annualCalendarMonthLabel(int month) {
    return 'Mese $month';
  }
}
