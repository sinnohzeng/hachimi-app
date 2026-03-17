// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class SFr extends S {
  SFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Hachimi';

  @override
  String get homeTabToday => 'Aujourd\'hui';

  @override
  String get homeTabCatHouse => 'CatHouse';

  @override
  String get homeTabStats => 'Statistiques';

  @override
  String get homeTabProfile => 'Profil';

  @override
  String get adoptionStepDefineHabit => 'Définir l\'habitude';

  @override
  String get adoptionStepAdoptCat => 'Adopter un chat';

  @override
  String get adoptionStepNameCat => 'Nommer le chat';

  @override
  String get adoptionHabitName => 'Nom de l\'habitude';

  @override
  String get adoptionHabitNameHint => 'ex. Lecture quotidienne';

  @override
  String get adoptionDailyGoal => 'Objectif quotidien';

  @override
  String get adoptionTargetHours => 'Heures cibles';

  @override
  String get adoptionTargetHoursHint =>
      'Nombre total d\'heures pour compléter cette habitude';

  @override
  String adoptionMinutes(int count) {
    return '$count min';
  }

  @override
  String get adoptionRefreshCat => 'Essayer un autre chat';

  @override
  String adoptionPersonality(String name) {
    return 'Personnalité : $name';
  }

  @override
  String get adoptionNameYourCat => 'Nommez votre chat';

  @override
  String get adoptionRandomName => 'Aléatoire';

  @override
  String get adoptionCreate => 'Créer l\'habitude et adopter';

  @override
  String get adoptionNext => 'Suivant';

  @override
  String get adoptionBack => 'Retour';

  @override
  String get adoptionCatNameLabel => 'Nom du chat';

  @override
  String get adoptionCatNameHint => 'ex. Mochi';

  @override
  String get adoptionRandomNameTooltip => 'Nom aléatoire';

  @override
  String get catHouseTitle => 'CatHouse';

  @override
  String get catHouseEmpty =>
      'Pas encore de chats ! Créez une habitude pour adopter votre premier chat.';

  @override
  String catHouseGrowth(int minutes, int target) {
    return '$minutes / $target min';
  }

  @override
  String get catDetailGrowthProgress => 'Progression de croissance';

  @override
  String catDetailTotalMinutes(int minutes) {
    return '$minutes min de concentration';
  }

  @override
  String catDetailTargetMinutes(int minutes) {
    return 'Objectif : $minutes min';
  }

  @override
  String get catDetailRename => 'Renommer';

  @override
  String get catDetailAccessories => 'Accessoires';

  @override
  String get catDetailStartFocus => 'Commencer la concentration';

  @override
  String get catDetailBoundHabit => 'Habitude liée';

  @override
  String catDetailStage(String stage) {
    return 'Stade : $stage';
  }

  @override
  String coinBalance(int amount) {
    return '$amount pièces';
  }

  @override
  String coinCheckInReward(int amount) {
    return '+$amount pièces !';
  }

  @override
  String get coinCheckInTitle => 'Pointage quotidien';

  @override
  String get coinInsufficientBalance => 'Pas assez de pièces';

  @override
  String get shopTitle => 'Boutique d\'accessoires';

  @override
  String shopPrice(int price) {
    return '$price pièces';
  }

  @override
  String get shopPurchase => 'Acheter';

  @override
  String get shopEquipped => 'Équipé';

  @override
  String focusCompleteMinutes(int minutes) {
    return '+$minutes min';
  }

  @override
  String get focusCompleteStageUp => 'Stade supérieur !';

  @override
  String get focusCompleteGreatJob => 'Bravo !';

  @override
  String get focusCompleteDone => 'Terminé';

  @override
  String get focusCompleteItsOkay => 'C\'est pas grave !';

  @override
  String focusCompleteEvolved(String catName) {
    return '$catName a évolué !';
  }

  @override
  String focusCompleteFocusedFor(int minutes) {
    return 'Vous vous êtes concentré pendant $minutes minutes';
  }

  @override
  String focusCompleteAbandonedMessage(String catName) {
    return '$catName dit : « On réessaiera ! »';
  }

  @override
  String get focusCompleteFocusTime => 'Temps de concentration';

  @override
  String get focusCompleteCoinsEarned => 'Pièces gagnées';

  @override
  String get focusCompleteBaseXp => 'XP de base';

  @override
  String get focusCompleteStreakBonus => 'Bonus de série';

  @override
  String get focusCompleteMilestoneBonus => 'Bonus d\'étape';

  @override
  String get focusCompleteFullHouseBonus => 'Bonus maison pleine';

  @override
  String get focusCompleteTotal => 'Total';

  @override
  String focusCompleteEvolvedTo(String stage) {
    return 'A évolué en $stage !';
  }

  @override
  String get focusCompleteYourCat => 'Votre chat';

  @override
  String get focusCompleteDiaryWriting => 'Écriture du journal...';

  @override
  String get focusCompleteDiaryWritten => 'Journal écrit !';

  @override
  String get focusCompleteDiarySkipped => 'Journal ignoré';

  @override
  String get focusCompleteNotifTitle => 'Quête terminée !';

  @override
  String focusCompleteNotifBody(String catName, int xp, int minutes) {
    return '$catName a gagné +$xp XP avec $minutes min de concentration';
  }

  @override
  String get stageKitten => 'Chaton';

  @override
  String get stageAdolescent => 'Adolescent';

  @override
  String get stageAdult => 'Adulte';

  @override
  String get stageSenior => 'Sénior';

  @override
  String get migrationTitle => 'Mise à jour des données requise';

  @override
  String get migrationMessage =>
      'Hachimi a été mis à jour avec un nouveau système de chats pixel ! Vos anciennes données ne sont plus compatibles. Réinitialisez pour recommencer avec la nouvelle expérience.';

  @override
  String get migrationResetButton => 'Réinitialiser et recommencer';

  @override
  String get sessionResumeTitle => 'Reprendre la session ?';

  @override
  String sessionResumeMessage(String habitName, String elapsed) {
    return 'Vous aviez une session de concentration active ($habitName, $elapsed). Reprendre ?';
  }

  @override
  String get sessionResumeButton => 'Reprendre';

  @override
  String get sessionDiscard => 'Abandonner';

  @override
  String get todaySummaryMinutes => 'Aujourd\'hui';

  @override
  String get todaySummaryTotal => 'Total';

  @override
  String get todaySummaryCats => 'Chats';

  @override
  String get todayYourQuests => 'Vos quêtes';

  @override
  String get todayNoQuests => 'Pas encore de quêtes';

  @override
  String get todayNoQuestsHint =>
      'Appuyez sur + pour lancer une quête et adopter un chat !';

  @override
  String get todayFocus => 'Concentration';

  @override
  String get todayDeleteQuestTitle => 'Supprimer la quête ?';

  @override
  String todayDeleteQuestMessage(String name) {
    return 'Êtes-vous sûr de vouloir supprimer « $name » ? Le chat sera diplômé vers votre album.';
  }

  @override
  String todayQuestCompleted(String name) {
    return '$name terminée';
  }

  @override
  String get todayFailedToLoad => 'Échec du chargement des quêtes';

  @override
  String todayMinToday(int count) {
    return '$count min aujourd\'hui';
  }

  @override
  String todayGoalMinPerDay(int count) {
    return 'Objectif : $count min/jour';
  }

  @override
  String get todayFeaturedCat => 'Chat vedette';

  @override
  String get todayAddHabit => 'Ajouter une habitude';

  @override
  String get todayNoHabits => 'Créez votre première habitude pour commencer !';

  @override
  String get todayNewQuest => 'Nouvelle quête';

  @override
  String get todayStartFocus => 'Commencer la concentration';

  @override
  String get timerStart => 'Démarrer';

  @override
  String get timerPause => 'Pause';

  @override
  String get timerResume => 'Reprendre';

  @override
  String get timerDone => 'Terminé';

  @override
  String get timerGiveUp => 'Abandonner';

  @override
  String get timerRemaining => 'Restant';

  @override
  String get timerElapsed => 'Écoulé';

  @override
  String get timerPaused => 'EN PAUSE';

  @override
  String get timerQuestNotFound => 'Quête introuvable';

  @override
  String get timerNotificationBanner =>
      'Activez les notifications pour voir la progression du minuteur quand l\'app est en arrière-plan';

  @override
  String get timerNotificationDismiss => 'Fermer';

  @override
  String get timerNotificationEnable => 'Activer';

  @override
  String timerGraceBack(int seconds) {
    return 'Retour (${seconds}s)';
  }

  @override
  String get giveUpTitle => 'Abandonner ?';

  @override
  String get giveUpMessage =>
      'Si tu t\'es concentré au moins 5 minutes, le temps compte quand même pour la croissance de ton chat. Ton chat comprendra !';

  @override
  String get giveUpKeepGoing => 'Continuer';

  @override
  String get giveUpConfirm => 'Abandonner';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsGeneral => 'Général';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsNotificationFocusReminders => 'Rappels de concentration';

  @override
  String get settingsNotificationSubtitle =>
      'Recevoir des rappels quotidiens pour rester sur la bonne voie';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageSystem => 'Langue du système';

  @override
  String get settingsLanguageEnglish => 'Anglais';

  @override
  String get settingsLanguageChinese => '中文';

  @override
  String get settingsThemeMode => 'Mode du thème';

  @override
  String get settingsThemeModeSystem => 'Système';

  @override
  String get settingsThemeModeLight => 'Clair';

  @override
  String get settingsThemeModeDark => 'Sombre';

  @override
  String get settingsThemeColor => 'Couleur du thème';

  @override
  String get settingsThemeColorDynamic => 'Dynamique';

  @override
  String get settingsThemeColorDynamicSubtitle =>
      'Utiliser les couleurs du fond d\'écran';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsLicenses => 'Licences';

  @override
  String get settingsAccount => 'Compte';

  @override
  String get logoutTitle => 'Se déconnecter ?';

  @override
  String get logoutMessage => 'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get loggingOut => 'Déconnexion...';

  @override
  String get deleteAccountTitle => 'Supprimer le compte ?';

  @override
  String get deleteAccountMessage =>
      'Cela supprimera définitivement votre compte et toutes vos données. Cette action est irréversible.';

  @override
  String get deleteAccountWarning => 'Cette action est irréversible';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileYourJourney => 'Votre parcours';

  @override
  String get profileTotalFocus => 'Concentration totale';

  @override
  String get profileTotalCats => 'Total de chats';

  @override
  String get profileTotalQuests => 'Quêtes';

  @override
  String get profileEditName => 'Modifier le nom';

  @override
  String get profileDisplayName => 'Nom d\'affichage';

  @override
  String get profileChooseAvatar => 'Choisir un avatar';

  @override
  String get profileSaved => 'Profil enregistré';

  @override
  String get profileSettings => 'Paramètres';

  @override
  String get habitDetailStreak => 'Série';

  @override
  String get habitDetailBestStreak => 'Meilleure';

  @override
  String get habitDetailTotalMinutes => 'Total';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonConfirm => 'Confirmer';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonEdit => 'Modifier';

  @override
  String get commonDone => 'Terminé';

  @override
  String get commonDismiss => 'Fermer';

  @override
  String get commonEnable => 'Activer';

  @override
  String get commonLoading => 'Chargement...';

  @override
  String get commonError => 'Une erreur est survenue';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonResume => 'Reprendre';

  @override
  String get commonPause => 'Pause';

  @override
  String get commonLogOut => 'Se déconnecter';

  @override
  String get commonDeleteAccount => 'Supprimer le compte';

  @override
  String get commonYes => 'Oui';

  @override
  String chatDailyRemaining(int count) {
    return '$count messages restants aujourd\'hui';
  }

  @override
  String get chatDailyLimitReached => 'Limite quotidienne de messages atteinte';

  @override
  String get aiTemporarilyUnavailable =>
      'Les fonctionnalités IA sont temporairement indisponibles';

  @override
  String get catDetailNotFound => 'Chat introuvable';

  @override
  String get catDetailLoadError => 'Échec du chargement des données du chat';

  @override
  String get catDetailChatTooltip => 'Chat';

  @override
  String get catDetailRenameTooltip => 'Renommer';

  @override
  String get catDetailGrowthTitle => 'Progression de croissance';

  @override
  String catDetailTarget(int hours) {
    return 'Objectif : ${hours}h';
  }

  @override
  String get catDetailRenameTitle => 'Renommer le chat';

  @override
  String get catDetailNewName => 'Nouveau nom';

  @override
  String get catDetailRenamed => 'Chat renommé !';

  @override
  String get catDetailQuestBadge => 'Quête';

  @override
  String get catDetailEditQuest => 'Modifier la quête';

  @override
  String get catDetailDailyGoal => 'Objectif quotidien';

  @override
  String get catDetailTodaysFocus => 'Concentration du jour';

  @override
  String get catDetailTotalFocus => 'Concentration totale';

  @override
  String get catDetailTargetLabel => 'Objectif';

  @override
  String get catDetailCompletion => 'Progression';

  @override
  String get catDetailCurrentStreak => 'Série actuelle';

  @override
  String get catDetailBestStreakLabel => 'Meilleure série';

  @override
  String get catDetailAvgDaily => 'Moyenne quotidienne';

  @override
  String get catDetailDaysActive => 'Jours actifs';

  @override
  String get catDetailCheckInDays => 'Jours de pointage';

  @override
  String get catDetailEditQuestTitle => 'Modifier la quête';

  @override
  String get catDetailQuestName => 'Nom de la quête';

  @override
  String get catDetailDailyGoalMinutes => 'Objectif quotidien (minutes)';

  @override
  String get catDetailTargetTotalHours => 'Objectif total (heures)';

  @override
  String get catDetailQuestUpdated => 'Quête mise à jour !';

  @override
  String get catDetailTargetCompletedHint =>
      'Objectif atteint — maintenant en mode illimité';

  @override
  String get catDetailDailyReminder => 'Rappel quotidien';

  @override
  String catDetailEveryDay(String time) {
    return '$time chaque jour';
  }

  @override
  String get catDetailNoReminder => 'Aucun rappel défini';

  @override
  String get catDetailChange => 'Modifier';

  @override
  String get catDetailRemoveReminder => 'Supprimer le rappel';

  @override
  String get catDetailSet => 'Définir';

  @override
  String catDetailReminderSet(String time) {
    return 'Rappel défini à $time';
  }

  @override
  String get catDetailReminderRemoved => 'Rappel supprimé';

  @override
  String get catDetailDiaryTitle => 'Journal Hachimi';

  @override
  String get catDetailDiaryLoading => 'Chargement...';

  @override
  String get catDetailDiaryError => 'Impossible de charger le journal';

  @override
  String get catDetailDiaryEmpty =>
      'Pas encore d\'entrée de journal aujourd\'hui. Complétez une session de concentration !';

  @override
  String catDetailChatWith(String name) {
    return 'Discuter avec $name';
  }

  @override
  String get catDetailChatSubtitle => 'Discutez avec votre chat';

  @override
  String get catDetailActivity => 'Activité';

  @override
  String get catDetailActivityError =>
      'Échec du chargement des données d\'activité';

  @override
  String get catDetailAccessoriesTitle => 'Accessoires';

  @override
  String get catDetailEquipped => 'Équipé : ';

  @override
  String get catDetailNone => 'Aucun';

  @override
  String get catDetailUnequip => 'Déséquiper';

  @override
  String catDetailFromInventory(int count) {
    return 'De l\'inventaire ($count)';
  }

  @override
  String get catDetailNoAccessories =>
      'Pas encore d\'accessoires. Visitez la boutique !';

  @override
  String catDetailEquippedItem(String name) {
    return '$name équipé';
  }

  @override
  String get catDetailUnequipped => 'Déséquipé';

  @override
  String catDetailAbout(String name) {
    return 'À propos de $name';
  }

  @override
  String get catDetailAppearanceDetails => 'Détails de l\'apparence';

  @override
  String get catDetailStatus => 'Statut';

  @override
  String get catDetailAdopted => 'Adopté';

  @override
  String get catDetailFurPattern => 'Motif du pelage';

  @override
  String get catDetailFurColor => 'Couleur du pelage';

  @override
  String get catDetailFurLength => 'Longueur du pelage';

  @override
  String get catDetailEyes => 'Yeux';

  @override
  String get catDetailWhitePatches => 'Taches blanches';

  @override
  String get catDetailPatchesTint => 'Teinte des taches';

  @override
  String get catDetailTint => 'Teinte';

  @override
  String get catDetailPoints => 'Pointes';

  @override
  String get catDetailVitiligo => 'Vitiligo';

  @override
  String get catDetailTortoiseshell => 'Écaille de tortue';

  @override
  String get catDetailTortiePattern => 'Motif écaille';

  @override
  String get catDetailTortieColor => 'Couleur écaille';

  @override
  String get catDetailSkin => 'Peau';

  @override
  String get offlineMessage =>
      'Vous êtes hors ligne — les modifications seront synchronisées à la reconnexion';

  @override
  String get offlineModeLabel => 'Mode hors ligne';

  @override
  String habitTodayMinutes(int count) {
    return 'Aujourd\'hui : $count min';
  }

  @override
  String get habitDeleteTooltip => 'Supprimer l\'habitude';

  @override
  String get heatmapActiveDays => 'Jours actifs';

  @override
  String get heatmapTotal => 'Total';

  @override
  String get heatmapRate => 'Taux';

  @override
  String get heatmapLess => 'Moins';

  @override
  String get heatmapMore => 'Plus';

  @override
  String get accessoryEquipped => 'Équipé';

  @override
  String get accessoryOwned => 'Possédé';

  @override
  String get pickerMinUnit => 'min';

  @override
  String get settingsBackgroundAnimation => 'Arrière-plans animés';

  @override
  String get settingsBackgroundAnimationSubtitle =>
      'Dégradé en maille et particules flottantes';

  @override
  String get settingsUiStyle => 'Style d\'interface';

  @override
  String get settingsUiStyleMaterial => 'Material 3';

  @override
  String get settingsUiStyleRetroPixel => 'Retro Pixel';

  @override
  String get settingsUiStyleMaterialSubtitle =>
      'Design Material moderne et arrondi';

  @override
  String get settingsUiStyleRetroPixelSubtitle =>
      'Esthétique chaleureuse de pixel art';

  @override
  String get personalityLazy => 'Paresseux';

  @override
  String get personalityCurious => 'Curieux';

  @override
  String get personalityPlayful => 'Joueur';

  @override
  String get personalityShy => 'Timide';

  @override
  String get personalityBrave => 'Courageux';

  @override
  String get personalityClingy => 'Pot de colle';

  @override
  String get personalityFlavorLazy =>
      'Dormira 23 heures par jour. L\'autre heure ? Aussi à dormir.';

  @override
  String get personalityFlavorCurious => 'Il renifle déjà tout autour de lui !';

  @override
  String get personalityFlavorPlayful =>
      'Impossible d\'arrêter de chasser les papillons !';

  @override
  String get personalityFlavorShy =>
      'A mis 3 minutes pour oser sortir de la boîte...';

  @override
  String get personalityFlavorBrave =>
      'A sauté de la boîte avant même qu\'on l\'ouvre !';

  @override
  String get personalityFlavorClingy =>
      'A commencé à ronronner et ne veut plus te lâcher.';

  @override
  String get moodHappy => 'Content';

  @override
  String get moodNeutral => 'Neutre';

  @override
  String get moodLonely => 'Solitaire';

  @override
  String get moodMissing => 'Tu me manques';

  @override
  String get moodMsgLazyHappy => 'Nya~! L\'heure d\'une sieste bien méritée...';

  @override
  String get moodMsgCuriousHappy => 'On explore quoi aujourd\'hui ?';

  @override
  String get moodMsgPlayfulHappy => 'Nya~! Prêt à travailler !';

  @override
  String get moodMsgShyHappy => '...J-je suis content que tu sois là.';

  @override
  String get moodMsgBraveHappy => 'Conquérons cette journée ensemble !';

  @override
  String get moodMsgClingyHappy => 'Yay ! Tu es revenu ! Ne repars plus !';

  @override
  String get moodMsgLazyNeutral => '*bâillement* Ah, salut...';

  @override
  String get moodMsgCuriousNeutral => 'Hmm, c\'est quoi là-bas ?';

  @override
  String get moodMsgPlayfulNeutral => 'On joue ? Peut-être plus tard...';

  @override
  String get moodMsgShyNeutral => '*sort doucement la tête*';

  @override
  String get moodMsgBraveNeutral => 'Je monte la garde, comme toujours.';

  @override
  String get moodMsgClingyNeutral => 'Je t\'attendais...';

  @override
  String get moodMsgLazyLonely => 'Même les siestes sont tristes...';

  @override
  String get moodMsgCuriousLonely => 'Je me demande quand tu reviendras...';

  @override
  String get moodMsgPlayfulLonely =>
      'Les jouets ne sont pas amusants sans toi...';

  @override
  String get moodMsgShyLonely => '*se roule en boule silencieusement*';

  @override
  String get moodMsgBraveLonely =>
      'Je continuerai d\'attendre. Je suis courageux.';

  @override
  String get moodMsgClingyLonely => 'Où es-tu parti... 🥺';

  @override
  String get moodMsgLazyMissing => '*ouvre un œil avec espoir*';

  @override
  String get moodMsgCuriousMissing => 'Il s\'est passé quelque chose... ?';

  @override
  String get moodMsgPlayfulMissing => 'J\'ai gardé ton jouet préféré...';

  @override
  String get moodMsgShyMissing => '*caché, mais surveille la porte*';

  @override
  String get moodMsgBraveMissing => 'Je sais que tu reviendras. J\'y crois.';

  @override
  String get moodMsgClingyMissing =>
      'Tu me manques tellement... s\'il te plaît, reviens.';

  @override
  String get peltTypeTabby => 'Rayures tabby classiques';

  @override
  String get peltTypeTicked => 'Motif agouti ticked';

  @override
  String get peltTypeMackerel => 'Tabby maquereau';

  @override
  String get peltTypeClassic => 'Motif classique en spirale';

  @override
  String get peltTypeSokoke => 'Motif marbré sokoke';

  @override
  String get peltTypeAgouti => 'Agouti ticked';

  @override
  String get peltTypeSpeckled => 'Pelage moucheté';

  @override
  String get peltTypeRosette => 'Taches en rosette';

  @override
  String get peltTypeSingleColour => 'Couleur unie';

  @override
  String get peltTypeTwoColour => 'Bicolore';

  @override
  String get peltTypeSmoke => 'Ombré fumée';

  @override
  String get peltTypeSinglestripe => 'Rayure unique';

  @override
  String get peltTypeBengal => 'Motif bengal';

  @override
  String get peltTypeMarbled => 'Motif marbré';

  @override
  String get peltTypeMasked => 'Face masquée';

  @override
  String get peltColorWhite => 'Blanc';

  @override
  String get peltColorPaleGrey => 'Gris pâle';

  @override
  String get peltColorSilver => 'Argenté';

  @override
  String get peltColorGrey => 'Gris';

  @override
  String get peltColorDarkGrey => 'Gris foncé';

  @override
  String get peltColorGhost => 'Gris fantôme';

  @override
  String get peltColorBlack => 'Noir';

  @override
  String get peltColorCream => 'Crème';

  @override
  String get peltColorPaleGinger => 'Roux pâle';

  @override
  String get peltColorGolden => 'Doré';

  @override
  String get peltColorGinger => 'Roux';

  @override
  String get peltColorDarkGinger => 'Roux foncé';

  @override
  String get peltColorSienna => 'Sienne';

  @override
  String get peltColorLightBrown => 'Brun clair';

  @override
  String get peltColorLilac => 'Lilas';

  @override
  String get peltColorBrown => 'Brun';

  @override
  String get peltColorGoldenBrown => 'Brun doré';

  @override
  String get peltColorDarkBrown => 'Brun foncé';

  @override
  String get peltColorChocolate => 'Chocolat';

  @override
  String get eyeColorYellow => 'Jaune';

  @override
  String get eyeColorAmber => 'Ambre';

  @override
  String get eyeColorHazel => 'Noisette';

  @override
  String get eyeColorPaleGreen => 'Vert pâle';

  @override
  String get eyeColorGreen => 'Vert';

  @override
  String get eyeColorBlue => 'Bleu';

  @override
  String get eyeColorDarkBlue => 'Bleu foncé';

  @override
  String get eyeColorBlueYellow => 'Bleu-jaune';

  @override
  String get eyeColorBlueGreen => 'Bleu-vert';

  @override
  String get eyeColorGrey => 'Gris';

  @override
  String get eyeColorCyan => 'Cyan';

  @override
  String get eyeColorEmerald => 'Émeraude';

  @override
  String get eyeColorHeatherBlue => 'Bleu bruyère';

  @override
  String get eyeColorSunlitIce => 'Glace ensoleillée';

  @override
  String get eyeColorCopper => 'Cuivre';

  @override
  String get eyeColorSage => 'Sauge';

  @override
  String get eyeColorCobalt => 'Cobalt';

  @override
  String get eyeColorPaleBlue => 'Bleu pâle';

  @override
  String get eyeColorBronze => 'Bronze';

  @override
  String get eyeColorSilver => 'Argenté';

  @override
  String get eyeColorPaleYellow => 'Jaune pâle';

  @override
  String eyeDescNormal(String color) {
    return 'Yeux $color';
  }

  @override
  String eyeDescHeterochromia(String primary, String secondary) {
    return 'Hétérochromie ($primary / $secondary)';
  }

  @override
  String get skinColorPink => 'Rose';

  @override
  String get skinColorRed => 'Rouge';

  @override
  String get skinColorBlack => 'Noir';

  @override
  String get skinColorDark => 'Sombre';

  @override
  String get skinColorDarkBrown => 'Brun foncé';

  @override
  String get skinColorBrown => 'Brun';

  @override
  String get skinColorLightBrown => 'Brun clair';

  @override
  String get skinColorDarkGrey => 'Gris foncé';

  @override
  String get skinColorGrey => 'Gris';

  @override
  String get skinColorDarkSalmon => 'Saumon foncé';

  @override
  String get skinColorSalmon => 'Saumon';

  @override
  String get skinColorPeach => 'Pêche';

  @override
  String get furLengthLonghair => 'Poil long';

  @override
  String get furLengthShorthair => 'Poil court';

  @override
  String get whiteTintOffwhite => 'Teinte blanc cassé';

  @override
  String get whiteTintCream => 'Teinte crème';

  @override
  String get whiteTintDarkCream => 'Teinte crème foncé';

  @override
  String get whiteTintGray => 'Teinte grise';

  @override
  String get whiteTintPink => 'Teinte rose';

  @override
  String notifReminderTitle(String catName) {
    return '$catName s\'ennuie de toi !';
  }

  @override
  String notifReminderBody(String habitName) {
    return 'C\'est l\'heure de $habitName — ton chat t\'attend !';
  }

  @override
  String notifStreakTitle(String catName) {
    return '$catName s\'inquiète !';
  }

  @override
  String notifStreakBody(int streak) {
    return 'Ta série de $streak jours est en danger. Une petite session la sauvera !';
  }

  @override
  String notifEvolutionTitle(String catName) {
    return '$catName a évolué !';
  }

  @override
  String notifEvolutionBody(String catName, String stageName) {
    return '$catName est devenu $stageName ! Continuez comme ça !';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String diaryScreenTitle(String name) {
    return 'Journal de $name';
  }

  @override
  String get diaryFailedToLoad => 'Échec du chargement du journal';

  @override
  String get diaryEmptyTitle => 'Pas encore d\'entrées de journal';

  @override
  String get diaryEmptyHint =>
      'Complétez une session de concentration et votre chat écrira sa première entrée de journal !';

  @override
  String get focusSetupCountdown => 'Compte à rebours';

  @override
  String get focusSetupStopwatch => 'Chronomètre';

  @override
  String get focusSetupStartFocus => 'Commencer la concentration';

  @override
  String get focusSetupQuestNotFound => 'Quête introuvable';

  @override
  String get checkInButtonLogMore => 'Enregistrer plus de temps';

  @override
  String get checkInButtonStart => 'Lancer le minuteur';

  @override
  String get adoptionTitleFirst => 'Adoptez votre premier chat !';

  @override
  String get adoptionTitleNew => 'Nouvelle quête';

  @override
  String get adoptionStepDefineQuest => 'Définir la quête';

  @override
  String get adoptionStepAdoptCat2 => 'Adopter un chat';

  @override
  String get adoptionStepNameCat2 => 'Nommer le chat';

  @override
  String get adoptionAdopt => 'Adopter !';

  @override
  String get adoptionQuestPrompt => 'Quelle quête voulez-vous commencer ?';

  @override
  String get adoptionKittenHint =>
      'Un chaton vous sera attribué pour vous aider à rester motivé !';

  @override
  String get adoptionQuestName => 'Nom de la quête';

  @override
  String get adoptionQuestHint => 'ex. Préparer les questions d\'entretien';

  @override
  String get adoptionTotalTarget => 'Objectif total (heures)';

  @override
  String get adoptionGrowthHint =>
      'Votre chat grandit à mesure que vous accumulez du temps de concentration';

  @override
  String get adoptionCustom => 'Personnalisé';

  @override
  String get adoptionDailyGoalLabel =>
      'Objectif quotidien de concentration (min)';

  @override
  String get adoptionReminderLabel => 'Rappel quotidien (optionnel)';

  @override
  String get adoptionReminderNone => 'Aucun';

  @override
  String get adoptionCustomGoalTitle => 'Objectif quotidien personnalisé';

  @override
  String get adoptionMinutesPerDay => 'Minutes par jour';

  @override
  String get adoptionMinutesHint => '5 - 180';

  @override
  String get adoptionValidMinutes => 'Saisissez une valeur entre 5 et 180';

  @override
  String get adoptionCustomTargetTitle => 'Heures cibles personnalisées';

  @override
  String get adoptionTotalHours => 'Total d\'heures';

  @override
  String get adoptionHoursHint => '10 - 2000';

  @override
  String get adoptionValidHours => 'Saisissez une valeur entre 10 et 2000';

  @override
  String get adoptionSet => 'Définir';

  @override
  String get adoptionChooseKitten => 'Choisissez votre chaton !';

  @override
  String adoptionCompanionFor(String quest) {
    return 'Votre compagnon pour « $quest »';
  }

  @override
  String get adoptionRerollAll => 'Relancer tous';

  @override
  String get adoptionNameYourCat2 => 'Nommez votre chat';

  @override
  String get adoptionCatName => 'Nom du chat';

  @override
  String get adoptionCatHint => 'ex. Mochi';

  @override
  String get adoptionRandomTooltip => 'Nom aléatoire';

  @override
  String adoptionGrowthTarget(String quest, int hours) {
    return 'Votre chat grandira pendant que vous vous concentrez sur « $quest » ! Objectif : ${hours}h au total.';
  }

  @override
  String get adoptionValidQuestName => 'Veuillez saisir un nom de quête';

  @override
  String get adoptionValidCatName => 'Veuillez nommer votre chat';

  @override
  String adoptionError(String message) {
    return 'Erreur : $message';
  }

  @override
  String get adoptionBasicInfo => 'Informations de base';

  @override
  String get adoptionGoals => 'Objectifs';

  @override
  String get adoptionUnlimitedMode => 'Mode illimité';

  @override
  String get adoptionUnlimitedDesc => 'Sans limite, continuez à accumuler';

  @override
  String get adoptionMilestoneMode => 'Mode objectif';

  @override
  String get adoptionMilestoneDesc => 'Définissez un objectif à atteindre';

  @override
  String get adoptionDeadlineLabel => 'Date limite';

  @override
  String get adoptionDeadlineNone => 'Non définie';

  @override
  String get adoptionReminderSection => 'Rappel';

  @override
  String get adoptionMotivationLabel => 'Note';

  @override
  String get adoptionMotivationHint => 'Écrivez une note...';

  @override
  String get adoptionMotivationSwap => 'Remplir aléatoirement';

  @override
  String get loginAppName => 'Hachimi';

  @override
  String get loginTagline => 'Élevez des chats. Accomplissez des quêtes.';

  @override
  String get loginContinueGoogle => 'Continuer avec Google';

  @override
  String get loginContinueEmail => 'Continuer avec Email';

  @override
  String get loginAlreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get loginLogIn => 'Se connecter';

  @override
  String get loginWelcomeBack => 'Bon retour !';

  @override
  String get loginCreateAccount => 'Créez votre compte';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Mot de passe';

  @override
  String get loginConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get loginValidEmail => 'Veuillez saisir votre email';

  @override
  String get loginValidEmailFormat => 'Veuillez saisir un email valide';

  @override
  String get loginValidPassword => 'Veuillez saisir votre mot de passe';

  @override
  String get loginValidPasswordLength =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get loginValidPasswordMatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get loginCreateAccountButton => 'Créer un compte';

  @override
  String get loginNoAccount => 'Pas encore de compte ? ';

  @override
  String get loginRegister => 'S\'inscrire';

  @override
  String get checkInTitle => 'Pointage mensuel';

  @override
  String get checkInDays => 'Jours';

  @override
  String get checkInCoinsEarned => 'Pièces gagnées';

  @override
  String get checkInAllMilestones => 'Toutes les étapes atteintes !';

  @override
  String checkInMilestoneProgress(int remaining, int bonus) {
    return 'Encore $remaining jours → +$bonus pièces';
  }

  @override
  String get checkInMilestones => 'Étapes';

  @override
  String get checkInFullMonth => 'Mois complet';

  @override
  String get checkInRewardSchedule => 'Programme de récompenses';

  @override
  String get checkInWeekday => 'Jours de semaine (lun–ven)';

  @override
  String checkInWeekdayReward(int coins) {
    return '$coins pièces/jour';
  }

  @override
  String get checkInWeekend => 'Week-end (sam–dim)';

  @override
  String checkInNDays(int count) {
    return '$count jours';
  }

  @override
  String get onboardTitle1 => 'Rencontrez votre compagnon';

  @override
  String get onboardSubtitle1 => 'Chaque quête commence avec un chaton';

  @override
  String get onboardBody1 =>
      'Définissez un objectif et adoptez un chaton.\nConcentrez-vous et regardez votre chat grandir !';

  @override
  String get onboardTitle2 => 'Concentrez-vous, grandissez, évoluez';

  @override
  String get onboardSubtitle2 => '4 stades de croissance';

  @override
  String get onboardBody2 =>
      'Chaque minute de concentration aide votre chat à évoluer\nd\'un petit chaton à un magnifique sénior !';

  @override
  String get onboardTitle3 => 'Construisez votre CatHouse';

  @override
  String get onboardSubtitle3 => 'Collectionnez des chats uniques';

  @override
  String get onboardBody3 =>
      'Chaque quête apporte un nouveau chat à l\'apparence unique.\nDécouvre-les tous et construis ta collection de rêves !';

  @override
  String get onboardSkip => 'Passer';

  @override
  String get onboardLetsGo => 'C\'est parti !';

  @override
  String get onboardNext => 'Suivant';

  @override
  String get catRoomTitle => 'CatHouse';

  @override
  String get catRoomInventory => 'Inventaire';

  @override
  String get catRoomShop => 'Boutique d\'accessoires';

  @override
  String get catRoomLoadError => 'Échec du chargement des chats';

  @override
  String get catRoomEmptyTitle => 'Votre CatHouse est vide';

  @override
  String get catRoomEmptySubtitle =>
      'Lancez une quête pour adopter votre premier chat !';

  @override
  String get catRoomEditQuest => 'Modifier la quête';

  @override
  String get catRoomRenameCat => 'Renommer le chat';

  @override
  String get catRoomArchiveCat => 'Archiver le chat';

  @override
  String get catRoomNewName => 'Nouveau nom';

  @override
  String get catRoomRename => 'Renommer';

  @override
  String get catRoomArchiveTitle => 'Archiver le chat ?';

  @override
  String catRoomArchiveMessage(String name) {
    return 'Cela archivera « $name » et supprimera sa quête liée. Le chat apparaîtra toujours dans votre album.';
  }

  @override
  String get catRoomArchive => 'Archiver';

  @override
  String catRoomAlbumSection(int count) {
    return 'Album ($count)';
  }

  @override
  String get catRoomReactivateCat => 'Réactiver le chat';

  @override
  String get catRoomReactivateTitle => 'Réactiver le chat ?';

  @override
  String catRoomReactivateMessage(String name) {
    return 'Cela restaurera « $name » et sa quête liée dans la CatHouse.';
  }

  @override
  String get catRoomReactivate => 'Réactiver';

  @override
  String get catRoomArchivedLabel => 'Archivé';

  @override
  String catRoomArchiveSuccess(String name) {
    return '« $name » archivé';
  }

  @override
  String catRoomReactivateSuccess(String name) {
    return '« $name » réactivé';
  }

  @override
  String get catRoomArchiveError => 'Échec de l\'archivage du chat';

  @override
  String get catRoomReactivateError => 'Échec de la réactivation du chat';

  @override
  String get catRoomArchiveLoadError =>
      'Échec du chargement des chats archivés';

  @override
  String get catRoomRenameError => 'Échec du renommage du chat';

  @override
  String get addHabitTitle => 'Nouvelle quête';

  @override
  String get addHabitQuestName => 'Nom de la quête';

  @override
  String get addHabitQuestHint => 'ex. Pratique LeetCode';

  @override
  String get addHabitValidName => 'Veuillez saisir un nom de quête';

  @override
  String get addHabitTargetHours => 'Heures cibles';

  @override
  String get addHabitTargetHint => 'ex. 100';

  @override
  String get addHabitValidTarget => 'Veuillez saisir les heures cibles';

  @override
  String get addHabitValidNumber => 'Veuillez saisir un nombre valide';

  @override
  String get addHabitCreate => 'Créer la quête';

  @override
  String get addHabitHoursSuffix => 'heures';

  @override
  String shopTabPlants(int count) {
    return 'Plantes ($count)';
  }

  @override
  String shopTabWild(int count) {
    return 'Sauvage ($count)';
  }

  @override
  String shopTabCollars(int count) {
    return 'Colliers ($count)';
  }

  @override
  String get shopNoAccessories => 'Aucun accessoire disponible';

  @override
  String shopBuyConfirm(String name) {
    return 'Acheter $name ?';
  }

  @override
  String get shopPurchaseButton => 'Acheter';

  @override
  String get shopNotEnoughCoinsButton => 'Pas assez de pièces';

  @override
  String shopPurchaseSuccess(String name) {
    return 'Acheté ! $name ajouté à l\'inventaire';
  }

  @override
  String shopPurchaseFailed(int price) {
    return 'Pas assez de pièces (besoin de $price)';
  }

  @override
  String get inventoryTitle => 'Inventaire';

  @override
  String inventoryInBox(int count) {
    return 'Dans la boîte ($count)';
  }

  @override
  String get inventoryEmpty =>
      'Votre inventaire est vide.\nVisitez la boutique pour obtenir des accessoires !';

  @override
  String inventoryEquippedOnCats(int count) {
    return 'Équipés sur les chats ($count)';
  }

  @override
  String get inventoryNoEquipped => 'Aucun accessoire équipé sur les chats.';

  @override
  String get inventoryUnequip => 'Déséquiper';

  @override
  String get inventoryNoActiveCats => 'Aucun chat actif';

  @override
  String inventoryEquipTo(String name) {
    return 'Équiper $name sur :';
  }

  @override
  String inventoryEquipSuccess(String name) {
    return '$name équipé';
  }

  @override
  String inventoryUnequipSuccess(String catName) {
    return 'Déséquipé de $catName';
  }

  @override
  String get chatCatNotFound => 'Chat introuvable';

  @override
  String chatTitle(String name) {
    return 'Discussion avec $name';
  }

  @override
  String get chatClearHistory => 'Effacer l\'historique';

  @override
  String chatEmptyTitle(String name) {
    return 'Dites bonjour à $name !';
  }

  @override
  String get chatEmptySubtitle =>
      'Commencez une conversation avec votre chat. Il répondra selon sa personnalité !';

  @override
  String get chatGenerating => 'Génération...';

  @override
  String get chatTypeMessage => 'Écris un message...';

  @override
  String get chatClearConfirmTitle => 'Effacer l\'historique du chat ?';

  @override
  String get chatClearConfirmMessage =>
      'Cela supprimera tous les messages. Cette action est irréversible.';

  @override
  String get chatClearButton => 'Effacer';

  @override
  String get chatSend => 'Envoyer';

  @override
  String get chatStop => 'Arrêter';

  @override
  String get chatErrorMessage => 'Failed to send message. Tap to retry.';

  @override
  String get chatRetry => 'Retry';

  @override
  String get chatErrorGeneric => 'Une erreur est survenue. Réessayez.';

  @override
  String diaryTitle(String name) {
    return 'Journal de $name';
  }

  @override
  String get diaryLoadFailed => 'Échec du chargement du journal';

  @override
  String get diaryRetry => 'Réessayer';

  @override
  String get diaryEmptyTitle2 => 'Pas encore d\'entrées de journal';

  @override
  String get diaryEmptySubtitle =>
      'Complétez une session de concentration et votre chat écrira sa première entrée de journal !';

  @override
  String get statsTitle => 'Statistiques';

  @override
  String get statsTotalHours => 'Heures totales';

  @override
  String statsTimeValue(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get statsBestStreak => 'Meilleure série';

  @override
  String statsStreakDays(int count) {
    return '$count jours';
  }

  @override
  String get statsOverallProgress => 'Progression globale';

  @override
  String statsPercentOfGoals(String percent) {
    return '$percent% de tous les objectifs';
  }

  @override
  String get statsPerQuestProgress => 'Progression par quête';

  @override
  String get statsQuestLoadError =>
      'Échec du chargement des statistiques de quêtes';

  @override
  String get statsNoQuestData => 'Pas encore de données de quête';

  @override
  String get statsNoQuestHint =>
      'Lancez une quête pour voir votre progression ici !';

  @override
  String get statsLast30Days => '30 derniers jours';

  @override
  String get habitDetailQuestNotFound => 'Quête introuvable';

  @override
  String get habitDetailComplete => 'terminé';

  @override
  String get habitDetailTotalTime => 'Temps total';

  @override
  String get habitDetailCurrentStreak => 'Série actuelle';

  @override
  String get habitDetailTarget => 'Objectif';

  @override
  String habitDetailDaysUnit(int count) {
    return '$count jours';
  }

  @override
  String habitDetailHoursUnit(int count) {
    return '$count heures';
  }

  @override
  String checkInBannerSuccess(int coins) {
    return '+$coins pièces ! Pointage quotidien terminé';
  }

  @override
  String checkInBannerBonus(int bonus) {
    return ' + $bonus bonus d\'étape !';
  }

  @override
  String get checkInBannerSemantics => 'Pointage quotidien';

  @override
  String get checkInBannerLoading => 'Chargement du statut de pointage...';

  @override
  String checkInBannerPrompt(int coins) {
    return 'Pointez pour +$coins pièces';
  }

  @override
  String checkInBannerSummary(int count, int total, int coins) {
    return '$count/$total jours  ·  +$coins aujourd\'hui';
  }

  @override
  String commonErrorWithDetail(String error) {
    return 'Erreur : $error';
  }

  @override
  String get profileFallbackUser => 'Utilisateur';

  @override
  String get fallbackCatName => 'Chat';

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
  String get notifFocusing => 'en concentration...';

  @override
  String get notifInProgress => 'Session de concentration en cours';

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
  String get weekdayThu => 'J';

  @override
  String get weekdayFri => 'V';

  @override
  String get weekdaySat => 'S';

  @override
  String get weekdaySun => 'D';

  @override
  String get statsTotalSessions => 'Sessions';

  @override
  String get statsTotalHabits => 'Habitudes';

  @override
  String get statsActiveDays => 'Jours actifs';

  @override
  String get statsWeeklyTrend => 'Tendance hebdomadaire';

  @override
  String get statsRecentSessions => 'Concentration récente';

  @override
  String get statsViewAllHistory => 'Voir tout l\'historique';

  @override
  String get historyTitle => 'Historique de concentration';

  @override
  String get historyFilterAll => 'Tout';

  @override
  String historySessionCount(int count) {
    return '$count sessions';
  }

  @override
  String historyTotalMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get historyNoSessions => 'Pas encore de sessions de concentration';

  @override
  String get historyNoSessionsHint =>
      'Complétez une session de concentration pour la voir ici';

  @override
  String get historyLoadMore => 'Charger plus';

  @override
  String get sessionCompleted => 'Terminée';

  @override
  String get sessionAbandoned => 'Abandonnée';

  @override
  String get sessionInterrupted => 'Interrompue';

  @override
  String get sessionCountdown => 'Compte à rebours';

  @override
  String get sessionStopwatch => 'Chronomètre';

  @override
  String get historyDateGroupToday => 'Aujourd\'hui';

  @override
  String get historyDateGroupYesterday => 'Hier';

  @override
  String get historyLoadError => 'Échec du chargement de l\'historique';

  @override
  String get historySelectMonth => 'Sélectionner le mois';

  @override
  String get historyAllMonths => 'Tous les mois';

  @override
  String get historyAllHabits => 'Toutes';

  @override
  String get homeTabAchievements => 'Succès';

  @override
  String get achievementTitle => 'Succès';

  @override
  String get achievementTabOverview => 'Résumé';

  @override
  String get achievementTabQuest => 'Quête';

  @override
  String get achievementTabStreak => 'Série';

  @override
  String get achievementTabCat => 'Chat';

  @override
  String get achievementTabPersist => 'Persévérance';

  @override
  String get achievementSummaryTitle => 'Progression des succès';

  @override
  String achievementUnlockedCount(int count) {
    return '$count débloqués';
  }

  @override
  String achievementTotalCoins(int coins) {
    return '$coins pièces gagnées';
  }

  @override
  String get achievementUnlocked => 'Succès débloqué !';

  @override
  String get achievementAwesome => 'Superbe !';

  @override
  String get achievementIncredible => 'Incroyable !';

  @override
  String get achievementHidden => '???';

  @override
  String get achievementHiddenDesc => 'Ceci est un succès caché';

  @override
  String achievementPersistDesc(int days) {
    return 'Accumulez $days jours de pointage sur n\'importe quelle quête';
  }

  @override
  String achievementTitleCount(int count) {
    return '$count titres débloqués';
  }

  @override
  String get growthPathTitle => 'Chemin de croissance';

  @override
  String get growthPathKitten => 'Commencez un nouveau voyage';

  @override
  String get growthPathAdolescent => 'Construisez les bases';

  @override
  String get growthPathAdult => 'Les compétences se consolident';

  @override
  String get growthPathSenior => 'Maîtrise approfondie';

  @override
  String get growthPathTip =>
      'Les recherches montrent que 20 heures de pratique concentrée suffisent pour construire les bases d\'une nouvelle compétence — Josh Kaufman';

  @override
  String achievementCelebrationCoins(int count) {
    return '+$count pièces';
  }

  @override
  String achievementCelebrationTitle(String title) {
    return 'Titre obtenu : $title';
  }

  @override
  String get achievementCelebrationDismiss => 'Superbe !';

  @override
  String get achievementCelebrationSkipAll => 'Tout passer';

  @override
  String achievementCelebrationCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String achievementUnlockedAt(String date) {
    return 'Débloqué le $date';
  }

  @override
  String get achievementLocked => 'Pas encore débloqué';

  @override
  String achievementRewardCoins(int count) {
    return '+$count pièces';
  }

  @override
  String get reminderModeDaily => 'Tous les jours';

  @override
  String get reminderModeWeekdays => 'Jours de semaine';

  @override
  String get reminderModeMonday => 'Lundi';

  @override
  String get reminderModeTuesday => 'Mardi';

  @override
  String get reminderModeWednesday => 'Mercredi';

  @override
  String get reminderModeThursday => 'Jeudi';

  @override
  String get reminderModeFriday => 'Vendredi';

  @override
  String get reminderModeSaturday => 'Samedi';

  @override
  String get reminderModeSunday => 'Dimanche';

  @override
  String get reminderPickerTitle => 'Sélectionner l\'heure du rappel';

  @override
  String get reminderHourUnit => 'h';

  @override
  String get reminderMinuteUnit => 'min';

  @override
  String get reminderAddMore => 'Ajouter un rappel';

  @override
  String get reminderMaxReached => 'Maximum 5 rappels';

  @override
  String get reminderConfirm => 'Confirmer';

  @override
  String reminderNotificationTitle(String catName) {
    return '$catName s\'ennuie de toi !';
  }

  @override
  String reminderNotificationBody(String habitName) {
    return 'C\'est l\'heure de $habitName — ton chat t\'attend !';
  }

  @override
  String get deleteAccountDataWarning =>
      'Toutes les données suivantes seront définitivement supprimées :';

  @override
  String get deleteAccountQuests => 'Quêtes';

  @override
  String get deleteAccountCats => 'Chats';

  @override
  String get deleteAccountHours => 'Heures de concentration';

  @override
  String get deleteAccountIrreversible => 'Cette action est irréversible';

  @override
  String get deleteAccountContinue => 'Continuer';

  @override
  String get deleteAccountConfirmTitle => 'Confirmer la suppression';

  @override
  String get deleteAccountTypeDelete =>
      'Tapez DELETE pour confirmer la suppression du compte :';

  @override
  String get deleteAccountAuthCancelled => 'Authentification annulée';

  @override
  String deleteAccountAuthFailed(String error) {
    return 'Échec de l\'authentification : $error';
  }

  @override
  String get deleteAccountProgress => 'Suppression du compte...';

  @override
  String get deleteAccountSuccess => 'Compte supprimé';

  @override
  String get drawerGuestLoginSubtitle =>
      'Synchronisez vos données et débloquez les fonctionnalités IA';

  @override
  String get drawerGuestSignIn => 'Se connecter';

  @override
  String get drawerMilestones => 'Étapes';

  @override
  String drawerMilestoneFocus(int hours, int minutes) {
    return 'Concentration totale : ${hours}h ${minutes}m';
  }

  @override
  String drawerMilestoneCats(int count) {
    return 'Famille de chats : $count';
  }

  @override
  String drawerMilestoneQuests(int count) {
    return 'Quêtes actives : $count';
  }

  @override
  String get drawerMySection => 'Mon espace';

  @override
  String get drawerSessionHistory => 'Historique de concentration';

  @override
  String get drawerCheckInCalendar => 'Calendrier de pointage';

  @override
  String get drawerAccountSection => 'Compte';

  @override
  String get settingsResetData => 'Réinitialiser toutes les données';

  @override
  String get settingsResetDataTitle => 'Réinitialiser toutes les données ?';

  @override
  String get settingsResetDataMessage =>
      'Cela supprimera toutes les données locales et reviendra à l\'écran d\'accueil. Cette action est irréversible.';

  @override
  String get guestUpgradeTitle => 'Protégez vos données';

  @override
  String get guestUpgradeMessage =>
      'Liez un compte pour sauvegarder votre progression, débloquer le journal IA et les fonctionnalités de chat, et synchroniser entre appareils.';

  @override
  String get guestUpgradeLinkButton => 'Lier un compte';

  @override
  String get guestUpgradeLater => 'Peut-être plus tard';

  @override
  String get loginLinkTagline => 'Liez un compte pour protéger vos données';

  @override
  String get aiTeaserTitle => 'Journal du chat';

  @override
  String aiTeaserPreview(String catName) {
    return 'Aujourd\'hui j\'ai encore étudié avec mon humain... $catName se sent plus intelligent chaque jour~';
  }

  @override
  String aiTeaserCta(String catName) {
    return 'Liez un compte pour voir ce que $catName veut dire';
  }

  @override
  String get authErrorEmailInUse => 'Cet email est déjà utilisé';

  @override
  String get authErrorWrongPassword => 'Email ou mot de passe incorrect';

  @override
  String get authErrorUserNotFound => 'Aucun compte trouvé avec cet email';

  @override
  String get authErrorTooManyRequests =>
      'Trop de tentatives. Réessayez plus tard';

  @override
  String get authErrorNetwork => 'Erreur réseau. Vérifiez votre connexion';

  @override
  String get authErrorAdminRestricted =>
      'La connexion est temporairement restreinte';

  @override
  String get authErrorWeakPassword =>
      'Le mot de passe est trop faible. Utilisez au moins 6 caractères';

  @override
  String get authErrorGeneric => 'Une erreur est survenue. Réessayez';

  @override
  String get deleteAccountReauthEmail =>
      'Saisissez votre mot de passe pour continuer';

  @override
  String get deleteAccountReauthPasswordHint => 'Mot de passe';

  @override
  String get deleteAccountError =>
      'Une erreur est survenue. Réessayez plus tard.';

  @override
  String get deleteAccountPermissionError =>
      'Erreur de permission. Essayez de vous déconnecter et de vous reconnecter.';

  @override
  String get deleteAccountNetworkError =>
      'Pas de connexion internet. Vérifiez votre réseau.';

  @override
  String get deleteAccountRetainedData =>
      'Les analyses d\'utilisation et les rapports d\'erreurs ne peuvent pas être supprimés.';

  @override
  String get deleteAccountStepCloud => 'Suppression des données cloud...';

  @override
  String get deleteAccountStepLocal => 'Nettoyage des données locales...';

  @override
  String get deleteAccountStepDone => 'Terminé';

  @override
  String get deleteAccountQueued =>
      'Données locales supprimées. La suppression du compte cloud est en file d\'attente et sera terminée une fois en ligne.';

  @override
  String get deleteAccountPending =>
      'La suppression du compte est en attente. Gardez l\'application en ligne pour terminer la suppression cloud et de l\'authentification.';

  @override
  String get deleteAccountAbandon => 'Repartir à zéro';

  @override
  String get archiveConflictTitle => 'Choisissez l\'archive à conserver';

  @override
  String get archiveConflictMessage =>
      'Les archives locale et cloud contiennent des données. Choisissez celle à conserver :';

  @override
  String get archiveConflictLocal => 'Archive locale';

  @override
  String get archiveConflictCloud => 'Archive cloud';

  @override
  String get archiveConflictKeepCloud => 'Garder le cloud';

  @override
  String get archiveConflictKeepLocal => 'Garder le local';

  @override
  String get loginShowPassword => 'Afficher le mot de passe';

  @override
  String get loginHidePassword => 'Masquer le mot de passe';

  @override
  String get errorGeneric => 'Une erreur est survenue. Réessayez plus tard';

  @override
  String get errorCreateHabit =>
      'Échec de la création de l\'habitude. Réessayez';

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
  String get commonCopyId => 'Copier l\'ID';

  @override
  String get adoptionClearDeadline => 'Effacer la date limite';

  @override
  String get commonIdCopied => 'ID copié';

  @override
  String get pickerDurationLabel => 'Sélecteur de durée';

  @override
  String pickerMinutesValue(int count) {
    return '$count minutes';
  }

  @override
  String a11yCatImage(String name) {
    return 'Chat $name';
  }

  @override
  String a11yCatTapToInteract(String name) {
    return '$name, appuyez pour interagir';
  }

  @override
  String a11yProgressPercent(int percent) {
    return '$percent% terminé';
  }

  @override
  String a11yStreakActiveDays(int count) {
    return '$count jours actifs';
  }

  @override
  String get a11yOfflineStatus => 'Mode hors ligne';

  @override
  String a11yAchievementUnlocked(String name) {
    return 'Succès débloqué : $name';
  }

  @override
  String get calendarCheckedIn => 'enregistré';

  @override
  String get calendarToday => 'aujourd\'hui';

  @override
  String a11yEquipToCat(Object name) {
    return 'Équiper à $name';
  }

  @override
  String a11yRegenerateCat(Object name) {
    return 'Régénérer $name';
  }

  @override
  String a11yTimerDisplay(Object time) {
    return 'Minuteur : $time';
  }

  @override
  String a11yOnboardingPage(Object current, Object total) {
    return 'Page $current sur $total';
  }

  @override
  String a11yEditDisplayName(Object name) {
    return 'Modifier le nom : $name';
  }

  @override
  String get routeNotFound => 'Page introuvable';

  @override
  String get routeGoHome => 'Retour à l\'accueil';

  @override
  String get a11yError => 'Erreur';

  @override
  String get a11yDeadline => 'Échéance';

  @override
  String get a11yReminder => 'Rappel';

  @override
  String get a11yFocusMeditation => 'Méditation de concentration';

  @override
  String get a11yUnlocked => 'Débloqué';

  @override
  String get a11ySelected => 'Sélectionné';

  @override
  String get a11yDynamicWallpaperColor => 'Couleur dynamique du fond';

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
}
