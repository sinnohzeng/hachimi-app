// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class SPt extends S {
  SPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Hachimi';

  @override
  String get homeTabToday => 'Hoje';

  @override
  String get homeTabCatHouse => 'CatHouse';

  @override
  String get homeTabStats => 'Estatísticas';

  @override
  String get homeTabProfile => 'Perfil';

  @override
  String get adoptionStepDefineHabit => 'Definir hábito';

  @override
  String get adoptionStepAdoptCat => 'Adotar gato';

  @override
  String get adoptionStepNameCat => 'Nomear gato';

  @override
  String get adoptionHabitName => 'Nome do hábito';

  @override
  String get adoptionHabitNameHint => 'ex. Leitura diária';

  @override
  String get adoptionDailyGoal => 'Meta diária';

  @override
  String get adoptionTargetHours => 'Horas alvo';

  @override
  String get adoptionTargetHoursHint =>
      'Total de horas para completar este hábito';

  @override
  String adoptionMinutes(int count) {
    return '$count min';
  }

  @override
  String get adoptionRefreshCat => 'Tentar outro';

  @override
  String adoptionPersonality(String name) {
    return 'Personalidade: $name';
  }

  @override
  String get adoptionNameYourCat => 'Dê um nome ao seu gato';

  @override
  String get adoptionRandomName => 'Aleatório';

  @override
  String get adoptionCreate => 'Criar hábito e adotar';

  @override
  String get adoptionNext => 'Próximo';

  @override
  String get adoptionBack => 'Voltar';

  @override
  String get adoptionCatNameLabel => 'Nome do gato';

  @override
  String get adoptionCatNameHint => 'ex. Mochi';

  @override
  String get adoptionRandomNameTooltip => 'Nome aleatório';

  @override
  String get catHouseTitle => 'CatHouse';

  @override
  String get catHouseEmpty =>
      'Nenhum gato ainda! Crie um hábito para adotar seu primeiro gato.';

  @override
  String catHouseGrowth(int minutes, int target) {
    return '$minutes / $target min';
  }

  @override
  String get catDetailGrowthProgress => 'Progresso de crescimento';

  @override
  String catDetailTotalMinutes(int minutes) {
    return '$minutes min focados';
  }

  @override
  String catDetailTargetMinutes(int minutes) {
    return 'Meta: $minutes min';
  }

  @override
  String get catDetailRename => 'Renomear';

  @override
  String get catDetailAccessories => 'Acessórios';

  @override
  String get catDetailStartFocus => 'Iniciar foco';

  @override
  String get catDetailBoundHabit => 'Hábito vinculado';

  @override
  String catDetailStage(String stage) {
    return 'Estágio: $stage';
  }

  @override
  String coinBalance(int amount) {
    return '$amount moedas';
  }

  @override
  String coinCheckInReward(int amount) {
    return '+$amount moedas!';
  }

  @override
  String get coinCheckInTitle => 'Check-in diário';

  @override
  String get coinInsufficientBalance => 'Moedas insuficientes';

  @override
  String get shopTitle => 'Loja de acessórios';

  @override
  String shopPrice(int price) {
    return '$price moedas';
  }

  @override
  String get shopPurchase => 'Comprar';

  @override
  String get shopEquipped => 'Equipado';

  @override
  String focusCompleteMinutes(int minutes) {
    return '+$minutes min';
  }

  @override
  String get focusCompleteStageUp => 'Subiu de estágio!';

  @override
  String get focusCompleteGreatJob => 'Ótimo trabalho!';

  @override
  String get focusCompleteDone => 'Pronto';

  @override
  String get focusCompleteItsOkay => 'Tudo bem!';

  @override
  String focusCompleteEvolved(String catName) {
    return '$catName evoluiu!';
  }

  @override
  String focusCompleteFocusedFor(int minutes) {
    return 'Você focou por $minutes minutos';
  }

  @override
  String focusCompleteAbandonedMessage(String catName) {
    return '$catName diz: \"Vamos tentar de novo!\"';
  }

  @override
  String get focusCompleteFocusTime => 'Tempo de foco';

  @override
  String get focusCompleteCoinsEarned => 'Moedas ganhas';

  @override
  String get focusCompleteBaseXp => 'XP base';

  @override
  String get focusCompleteStreakBonus => 'Bônus de sequência';

  @override
  String get focusCompleteMilestoneBonus => 'Bônus de meta';

  @override
  String get focusCompleteFullHouseBonus => 'Bônus de casa cheia';

  @override
  String get focusCompleteTotal => 'Total';

  @override
  String focusCompleteEvolvedTo(String stage) {
    return 'Evoluiu para $stage!';
  }

  @override
  String get focusCompleteYourCat => 'Seu gato';

  @override
  String get focusCompleteDiaryWriting => 'Escrevendo diário...';

  @override
  String get focusCompleteDiaryWritten => 'Diário escrito!';

  @override
  String get focusCompleteDiarySkipped => 'Diário ignorado';

  @override
  String get focusCompleteNotifTitle => 'Missão completa!';

  @override
  String focusCompleteNotifBody(String catName, int xp, int minutes) {
    return '$catName ganhou +$xp XP com $minutes min de foco';
  }

  @override
  String get stageKitten => 'Filhote';

  @override
  String get stageAdolescent => 'Adolescente';

  @override
  String get stageAdult => 'Adulto';

  @override
  String get stageSenior => 'Sênior';

  @override
  String get migrationTitle => 'Atualização de dados necessária';

  @override
  String get migrationMessage =>
      'O Hachimi foi atualizado com um novo sistema de gatos pixel! Seus dados antigos não são mais compatíveis. Reinicie para começar do zero com a nova experiência.';

  @override
  String get migrationResetButton => 'Reiniciar e começar do zero';

  @override
  String get sessionResumeTitle => 'Retomar sessão?';

  @override
  String sessionResumeMessage(String habitName, String elapsed) {
    return 'Você tinha uma sessão de foco ativa ($habitName, $elapsed). Retomar?';
  }

  @override
  String get sessionResumeButton => 'Retomar';

  @override
  String get sessionDiscard => 'Descartar';

  @override
  String get todaySummaryMinutes => 'Hoje';

  @override
  String get todaySummaryTotal => 'Total';

  @override
  String get todaySummaryCats => 'Gatos';

  @override
  String get todayYourQuests => 'Suas missões';

  @override
  String get todayNoQuests => 'Nenhuma missão ainda';

  @override
  String get todayNoQuestsHint =>
      'Toque em + para iniciar uma missão e adotar um gato!';

  @override
  String get todayFocus => 'Focar';

  @override
  String get todayDeleteQuestTitle => 'Excluir missão?';

  @override
  String todayDeleteQuestMessage(String name) {
    return 'Tem certeza que deseja excluir \"$name\"? O gato será graduado para o seu álbum.';
  }

  @override
  String todayQuestCompleted(String name) {
    return '$name completada';
  }

  @override
  String get todayFailedToLoad => 'Falha ao carregar missões';

  @override
  String todayMinToday(int count) {
    return '$count min hoje';
  }

  @override
  String todayGoalMinPerDay(int count) {
    return 'Meta: $count min/dia';
  }

  @override
  String get todayFeaturedCat => 'Gato em destaque';

  @override
  String get todayAddHabit => 'Adicionar hábito';

  @override
  String get todayNoHabits => 'Crie seu primeiro hábito para começar!';

  @override
  String get todayNewQuest => 'Nova missão';

  @override
  String get todayStartFocus => 'Iniciar foco';

  @override
  String get timerStart => 'Iniciar';

  @override
  String get timerPause => 'Pausar';

  @override
  String get timerResume => 'Retomar';

  @override
  String get timerDone => 'Pronto';

  @override
  String get timerGiveUp => 'Desistir';

  @override
  String get timerRemaining => 'restante';

  @override
  String get timerElapsed => 'decorrido';

  @override
  String get timerPaused => 'Pausado';

  @override
  String get timerQuestNotFound => 'Missão não encontrada';

  @override
  String get timerNotificationBanner =>
      'Ative as notificações para ver o progresso do timer quando o app estiver em segundo plano';

  @override
  String get timerNotificationDismiss => 'Fechar';

  @override
  String get timerNotificationEnable => 'Ativar';

  @override
  String timerGraceBack(int seconds) {
    return 'Voltar (${seconds}s)';
  }

  @override
  String get giveUpTitle => 'Desistir?';

  @override
  String get giveUpMessage =>
      'Se você focou por pelo menos 5 minutos, o tempo ainda conta para o crescimento do seu gato. Seu gato vai entender!';

  @override
  String get giveUpKeepGoing => 'Continuar';

  @override
  String get giveUpConfirm => 'Desistir';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsGeneral => 'Geral';

  @override
  String get settingsAppearance => 'Aparência';

  @override
  String get settingsNotifications => 'Notificações';

  @override
  String get settingsNotificationFocusReminders => 'Lembretes de foco';

  @override
  String get settingsNotificationSubtitle =>
      'Receba lembretes diários para manter o ritmo';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Padrão do sistema';

  @override
  String get settingsLanguageEnglish => 'Inglês';

  @override
  String get settingsLanguageChinese => '中文';

  @override
  String get settingsThemeMode => 'Modo do tema';

  @override
  String get settingsThemeModeSystem => 'Sistema';

  @override
  String get settingsThemeModeLight => 'Claro';

  @override
  String get settingsThemeModeDark => 'Escuro';

  @override
  String get settingsThemeColor => 'Cor do tema';

  @override
  String get settingsThemeColorDynamic => 'Dinâmico';

  @override
  String get settingsThemeColorDynamicSubtitle =>
      'Usar cores do papel de parede';

  @override
  String get settingsAbout => 'Sobre';

  @override
  String get settingsVersion => 'Versão';

  @override
  String get settingsLicenses => 'Licenças';

  @override
  String get settingsAccount => 'Conta';

  @override
  String get logoutTitle => 'Sair?';

  @override
  String get logoutMessage => 'Tem certeza que deseja sair?';

  @override
  String get loggingOut => 'Saindo...';

  @override
  String get deleteAccountTitle => 'Excluir conta?';

  @override
  String get deleteAccountMessage =>
      'Isso excluirá permanentemente sua conta e todos os seus dados. Essa ação não pode ser desfeita.';

  @override
  String get deleteAccountWarning => 'Essa ação não pode ser desfeita';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileYourJourney => 'Sua jornada';

  @override
  String get profileTotalFocus => 'Foco total';

  @override
  String get profileTotalCats => 'Total de gatos';

  @override
  String get profileTotalQuests => 'Missões';

  @override
  String get profileEditName => 'Editar nome';

  @override
  String get profileDisplayName => 'Nome de exibição';

  @override
  String get profileChooseAvatar => 'Escolher avatar';

  @override
  String get profileSaved => 'Perfil salvo';

  @override
  String get profileSettings => 'Configurações';

  @override
  String get habitDetailStreak => 'Sequência';

  @override
  String get habitDetailBestStreak => 'Melhor';

  @override
  String get habitDetailTotalMinutes => 'Total';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get commonSave => 'Salvar';

  @override
  String get commonDelete => 'Excluir';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonDone => 'Pronto';

  @override
  String get commonDismiss => 'Fechar';

  @override
  String get commonEnable => 'Ativar';

  @override
  String get commonLoading => 'Carregando...';

  @override
  String get commonError => 'Algo deu errado';

  @override
  String get commonRetry => 'Tentar novamente';

  @override
  String get commonResume => 'Retomar';

  @override
  String get commonPause => 'Pausar';

  @override
  String get commonLogOut => 'Sair';

  @override
  String get commonDeleteAccount => 'Excluir conta';

  @override
  String get commonYes => 'Sim';

  @override
  String chatDailyRemaining(int count) {
    return '$count mensagens restantes hoje';
  }

  @override
  String get chatDailyLimitReached => 'Limite diário de mensagens atingido';

  @override
  String get aiTemporarilyUnavailable =>
      'Os recursos de IA estão temporariamente indisponíveis';

  @override
  String get catDetailNotFound => 'Gato não encontrado';

  @override
  String get catDetailLoadError => 'Falha ao carregar dados do gato';

  @override
  String get catDetailChatTooltip => 'Chat';

  @override
  String get catDetailRenameTooltip => 'Renomear';

  @override
  String get catDetailGrowthTitle => 'Progresso de crescimento';

  @override
  String catDetailTarget(int hours) {
    return 'Meta: ${hours}h';
  }

  @override
  String get catDetailRenameTitle => 'Renomear gato';

  @override
  String get catDetailNewName => 'Novo nome';

  @override
  String get catDetailRenamed => 'Gato renomeado!';

  @override
  String get catDetailQuestBadge => 'Missão';

  @override
  String get catDetailEditQuest => 'Editar missão';

  @override
  String get catDetailDailyGoal => 'Meta diária';

  @override
  String get catDetailTodaysFocus => 'Foco de hoje';

  @override
  String get catDetailTotalFocus => 'Foco total';

  @override
  String get catDetailTargetLabel => 'Meta';

  @override
  String get catDetailCompletion => 'Progresso';

  @override
  String get catDetailCurrentStreak => 'Sequência atual';

  @override
  String get catDetailBestStreakLabel => 'Melhor sequência';

  @override
  String get catDetailAvgDaily => 'Média diária';

  @override
  String get catDetailDaysActive => 'Dias ativos';

  @override
  String get catDetailCheckInDays => 'Dias de check-in';

  @override
  String get catDetailEditQuestTitle => 'Editar missão';

  @override
  String get catDetailQuestName => 'Nome da missão';

  @override
  String get catDetailDailyGoalMinutes => 'Meta diária (minutos)';

  @override
  String get catDetailTargetTotalHours => 'Meta total (horas)';

  @override
  String get catDetailQuestUpdated => 'Missão atualizada!';

  @override
  String get catDetailTargetCompletedHint =>
      'Meta alcançada — agora em modo ilimitado';

  @override
  String get catDetailDailyReminder => 'Lembrete diário';

  @override
  String catDetailEveryDay(String time) {
    return '$time todos os dias';
  }

  @override
  String get catDetailNoReminder => 'Nenhum lembrete definido';

  @override
  String get catDetailChange => 'Alterar';

  @override
  String get catDetailRemoveReminder => 'Remover lembrete';

  @override
  String get catDetailSet => 'Definir';

  @override
  String catDetailReminderSet(String time) {
    return 'Lembrete definido para $time';
  }

  @override
  String get catDetailReminderRemoved => 'Lembrete removido';

  @override
  String get catDetailDiaryTitle => 'Diário Hachimi';

  @override
  String get catDetailDiaryLoading => 'Carregando...';

  @override
  String get catDetailDiaryError => 'Não foi possível carregar o diário';

  @override
  String get catDetailDiaryEmpty =>
      'Nenhuma entrada no diário hoje. Complete uma sessão de foco!';

  @override
  String catDetailChatWith(String name) {
    return 'Conversar com $name';
  }

  @override
  String get catDetailChatSubtitle => 'Converse com seu gato';

  @override
  String get catDetailActivity => 'Atividade';

  @override
  String get catDetailActivityError => 'Falha ao carregar dados de atividade';

  @override
  String get catDetailAccessoriesTitle => 'Acessórios';

  @override
  String get catDetailEquipped => 'Equipado: ';

  @override
  String get catDetailNone => 'Nenhum';

  @override
  String get catDetailUnequip => 'Desequipar';

  @override
  String catDetailFromInventory(int count) {
    return 'Do inventário ($count)';
  }

  @override
  String get catDetailNoAccessories => 'Nenhum acessório ainda. Visite a loja!';

  @override
  String catDetailEquippedItem(String name) {
    return '$name equipado';
  }

  @override
  String get catDetailUnequipped => 'Desequipado';

  @override
  String catDetailAbout(String name) {
    return 'Sobre $name';
  }

  @override
  String get catDetailAppearanceDetails => 'Detalhes da aparência';

  @override
  String get catDetailStatus => 'Status';

  @override
  String get catDetailAdopted => 'Adotado';

  @override
  String get catDetailFurPattern => 'Padrão da pelagem';

  @override
  String get catDetailFurColor => 'Cor da pelagem';

  @override
  String get catDetailFurLength => 'Comprimento da pelagem';

  @override
  String get catDetailEyes => 'Olhos';

  @override
  String get catDetailWhitePatches => 'Manchas brancas';

  @override
  String get catDetailPatchesTint => 'Tom das manchas';

  @override
  String get catDetailTint => 'Tom';

  @override
  String get catDetailPoints => 'Pontas';

  @override
  String get catDetailVitiligo => 'Vitiligo';

  @override
  String get catDetailTortoiseshell => 'Tartaruga';

  @override
  String get catDetailTortiePattern => 'Padrão tartaruga';

  @override
  String get catDetailTortieColor => 'Cor tartaruga';

  @override
  String get catDetailSkin => 'Pele';

  @override
  String get offlineMessage =>
      'Você está offline — as alterações serão sincronizadas quando reconectar';

  @override
  String get offlineModeLabel => 'Modo offline';

  @override
  String habitTodayMinutes(int count) {
    return 'Hoje: $count min';
  }

  @override
  String get habitDeleteTooltip => 'Excluir hábito';

  @override
  String get heatmapActiveDays => 'Dias ativos';

  @override
  String get heatmapTotal => 'Total';

  @override
  String get heatmapRate => 'Taxa';

  @override
  String get heatmapLess => 'Menos';

  @override
  String get heatmapMore => 'Mais';

  @override
  String get accessoryEquipped => 'Equipado';

  @override
  String get accessoryOwned => 'Adquirido';

  @override
  String get pickerMinUnit => 'min';

  @override
  String get settingsBackgroundAnimation => 'Fundos animados';

  @override
  String get settingsBackgroundAnimationSubtitle =>
      'Gradiente em malha e partículas flutuantes';

  @override
  String get settingsUiStyle => 'Estilo da interface';

  @override
  String get settingsUiStyleMaterial => 'Material 3';

  @override
  String get settingsUiStyleRetroPixel => 'Retro Pixel';

  @override
  String get settingsUiStyleMaterialSubtitle =>
      'Material Design moderno e arredondado';

  @override
  String get settingsUiStyleRetroPixelSubtitle =>
      'Estética quente de pixel art';

  @override
  String get personalityLazy => 'Preguiçoso';

  @override
  String get personalityCurious => 'Curioso';

  @override
  String get personalityPlayful => 'Brincalhão';

  @override
  String get personalityShy => 'Tímido';

  @override
  String get personalityBrave => 'Corajoso';

  @override
  String get personalityClingy => 'Apegado';

  @override
  String get personalityFlavorLazy =>
      'Vai dormir 23 horas por dia. A outra hora? Também dormindo.';

  @override
  String get personalityFlavorCurious => 'Já está cheirando tudo ao redor!';

  @override
  String get personalityFlavorPlayful => 'Não para de perseguir borboletas!';

  @override
  String get personalityFlavorShy =>
      'Levou 3 minutos para espiar fora da caixa...';

  @override
  String get personalityFlavorBrave => 'Pulou da caixa antes mesmo de abrirem!';

  @override
  String get personalityFlavorClingy =>
      'Começou a ronronar e não quer mais largar.';

  @override
  String get moodHappy => 'Feliz';

  @override
  String get moodNeutral => 'Neutro';

  @override
  String get moodLonely => 'Solitário';

  @override
  String get moodMissing => 'Com saudade';

  @override
  String get moodMsgLazyHappy => 'Nya~! Hora de uma soneca merecida...';

  @override
  String get moodMsgCuriousHappy => 'O que vamos explorar hoje?';

  @override
  String get moodMsgPlayfulHappy => 'Nya~! Pronto pra trabalhar!';

  @override
  String get moodMsgShyHappy => '...E-eu fico feliz que você esteja aqui.';

  @override
  String get moodMsgBraveHappy => 'Vamos conquistar o dia juntos!';

  @override
  String get moodMsgClingyHappy => 'Eba! Você voltou! Não vai embora de novo!';

  @override
  String get moodMsgLazyNeutral => '*bocejo* Ah, oi...';

  @override
  String get moodMsgCuriousNeutral => 'Hmm, o que é aquilo ali?';

  @override
  String get moodMsgPlayfulNeutral => 'Quer brincar? Talvez depois...';

  @override
  String get moodMsgShyNeutral => '*espia devagar*';

  @override
  String get moodMsgBraveNeutral => 'De guarda, como sempre.';

  @override
  String get moodMsgClingyNeutral => 'Estava te esperando...';

  @override
  String get moodMsgLazyLonely => 'Até cochilar é solitário...';

  @override
  String get moodMsgCuriousLonely => 'Será que você vai voltar...';

  @override
  String get moodMsgPlayfulLonely => 'Os brinquedos não são legais sem você...';

  @override
  String get moodMsgShyLonely => '*se encolhe em silêncio*';

  @override
  String get moodMsgBraveLonely => 'Vou continuar esperando. Sou corajoso.';

  @override
  String get moodMsgClingyLonely => 'Pra onde você foi... 🥺';

  @override
  String get moodMsgLazyMissing => '*abre um olho com esperança*';

  @override
  String get moodMsgCuriousMissing => 'Aconteceu alguma coisa...?';

  @override
  String get moodMsgPlayfulMissing => 'Guardei seu brinquedo favorito...';

  @override
  String get moodMsgShyMissing => '*escondido, mas olhando a porta*';

  @override
  String get moodMsgBraveMissing => 'Sei que você vai voltar. Eu acredito.';

  @override
  String get moodMsgClingyMissing => 'Sinto muita saudade... por favor, volta.';

  @override
  String get peltTypeTabby => 'Listras tabby clássicas';

  @override
  String get peltTypeTicked => 'Padrão aguti ticked';

  @override
  String get peltTypeMackerel => 'Tabby cavala';

  @override
  String get peltTypeClassic => 'Padrão clássico em espiral';

  @override
  String get peltTypeSokoke => 'Padrão mármore sokoke';

  @override
  String get peltTypeAgouti => 'Aguti ticked';

  @override
  String get peltTypeSpeckled => 'Pelagem salpicada';

  @override
  String get peltTypeRosette => 'Manchas em roseta';

  @override
  String get peltTypeSingleColour => 'Cor sólida';

  @override
  String get peltTypeTwoColour => 'Bicolor';

  @override
  String get peltTypeSmoke => 'Sombreado fumaça';

  @override
  String get peltTypeSinglestripe => 'Listra única';

  @override
  String get peltTypeBengal => 'Padrão bengal';

  @override
  String get peltTypeMarbled => 'Padrão marmorizado';

  @override
  String get peltTypeMasked => 'Face mascarada';

  @override
  String get peltColorWhite => 'Branco';

  @override
  String get peltColorPaleGrey => 'Cinza claro';

  @override
  String get peltColorSilver => 'Prateado';

  @override
  String get peltColorGrey => 'Cinza';

  @override
  String get peltColorDarkGrey => 'Cinza escuro';

  @override
  String get peltColorGhost => 'Cinza fantasma';

  @override
  String get peltColorBlack => 'Preto';

  @override
  String get peltColorCream => 'Creme';

  @override
  String get peltColorPaleGinger => 'Ruivo claro';

  @override
  String get peltColorGolden => 'Dourado';

  @override
  String get peltColorGinger => 'Ruivo';

  @override
  String get peltColorDarkGinger => 'Ruivo escuro';

  @override
  String get peltColorSienna => 'Siena';

  @override
  String get peltColorLightBrown => 'Marrom claro';

  @override
  String get peltColorLilac => 'Lilás';

  @override
  String get peltColorBrown => 'Marrom';

  @override
  String get peltColorGoldenBrown => 'Marrom dourado';

  @override
  String get peltColorDarkBrown => 'Marrom escuro';

  @override
  String get peltColorChocolate => 'Chocolate';

  @override
  String get eyeColorYellow => 'Amarelo';

  @override
  String get eyeColorAmber => 'Âmbar';

  @override
  String get eyeColorHazel => 'Avelã';

  @override
  String get eyeColorPaleGreen => 'Verde claro';

  @override
  String get eyeColorGreen => 'Verde';

  @override
  String get eyeColorBlue => 'Azul';

  @override
  String get eyeColorDarkBlue => 'Azul escuro';

  @override
  String get eyeColorBlueYellow => 'Azul-amarelo';

  @override
  String get eyeColorBlueGreen => 'Azul-verde';

  @override
  String get eyeColorGrey => 'Cinza';

  @override
  String get eyeColorCyan => 'Ciano';

  @override
  String get eyeColorEmerald => 'Esmeralda';

  @override
  String get eyeColorHeatherBlue => 'Azul lavanda';

  @override
  String get eyeColorSunlitIce => 'Gelo ensolarado';

  @override
  String get eyeColorCopper => 'Cobre';

  @override
  String get eyeColorSage => 'Sálvia';

  @override
  String get eyeColorCobalt => 'Cobalto';

  @override
  String get eyeColorPaleBlue => 'Azul claro';

  @override
  String get eyeColorBronze => 'Bronze';

  @override
  String get eyeColorSilver => 'Prateado';

  @override
  String get eyeColorPaleYellow => 'Amarelo claro';

  @override
  String eyeDescNormal(String color) {
    return 'Olhos $color';
  }

  @override
  String eyeDescHeterochromia(String primary, String secondary) {
    return 'Heterocromia ($primary / $secondary)';
  }

  @override
  String get skinColorPink => 'Rosa';

  @override
  String get skinColorRed => 'Vermelho';

  @override
  String get skinColorBlack => 'Preto';

  @override
  String get skinColorDark => 'Escuro';

  @override
  String get skinColorDarkBrown => 'Marrom escuro';

  @override
  String get skinColorBrown => 'Marrom';

  @override
  String get skinColorLightBrown => 'Marrom claro';

  @override
  String get skinColorDarkGrey => 'Cinza escuro';

  @override
  String get skinColorGrey => 'Cinza';

  @override
  String get skinColorDarkSalmon => 'Salmão escuro';

  @override
  String get skinColorSalmon => 'Salmão';

  @override
  String get skinColorPeach => 'Pêssego';

  @override
  String get furLengthLonghair => 'Pelo longo';

  @override
  String get furLengthShorthair => 'Pelo curto';

  @override
  String get whiteTintOffwhite => 'Tom esbranquiçado';

  @override
  String get whiteTintCream => 'Tom creme';

  @override
  String get whiteTintDarkCream => 'Tom creme escuro';

  @override
  String get whiteTintGray => 'Tom cinza';

  @override
  String get whiteTintPink => 'Tom rosa';

  @override
  String notifReminderTitle(String catName) {
    return '$catName sente sua falta!';
  }

  @override
  String notifReminderBody(String habitName) {
    return 'Hora de $habitName — seu gato está esperando!';
  }

  @override
  String notifStreakTitle(String catName) {
    return '$catName está preocupado!';
  }

  @override
  String notifStreakBody(int streak) {
    return 'Sua sequência de $streak dias está em risco. Uma sessão rápida vai salvar!';
  }

  @override
  String notifEvolutionTitle(String catName) {
    return '$catName evoluiu!';
  }

  @override
  String notifEvolutionBody(String catName, String stageName) {
    return '$catName cresceu para $stageName! Continue assim!';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String diaryScreenTitle(String name) {
    return 'Diário de $name';
  }

  @override
  String get diaryFailedToLoad => 'Falha ao carregar o diário';

  @override
  String get diaryEmptyTitle => 'Nenhuma entrada no diário ainda';

  @override
  String get diaryEmptyHint =>
      'Complete uma sessão de foco e seu gato vai escrever a primeira entrada do diário!';

  @override
  String get focusSetupCountdown => 'Contagem regressiva';

  @override
  String get focusSetupStopwatch => 'Cronômetro';

  @override
  String get focusSetupStartFocus => 'Iniciar foco';

  @override
  String get focusSetupQuestNotFound => 'Missão não encontrada';

  @override
  String get checkInButtonLogMore => 'Registrar mais tempo';

  @override
  String get checkInButtonStart => 'Iniciar timer';

  @override
  String get adoptionTitleFirst => 'Adote seu primeiro gato!';

  @override
  String get adoptionTitleNew => 'Nova missão';

  @override
  String get adoptionStepDefineQuest => 'Definir missão';

  @override
  String get adoptionStepAdoptCat2 => 'Adotar gato';

  @override
  String get adoptionStepNameCat2 => 'Nomear gato';

  @override
  String get adoptionAdopt => 'Adotar!';

  @override
  String get adoptionQuestPrompt => 'Que missão você quer começar?';

  @override
  String get adoptionKittenHint =>
      'Um filhote será designado para ajudar você a manter o foco!';

  @override
  String get adoptionQuestName => 'Nome da missão';

  @override
  String get adoptionQuestHint => 'ex. Preparar perguntas da entrevista';

  @override
  String get adoptionTotalTarget => 'Meta total (horas)';

  @override
  String get adoptionGrowthHint =>
      'Seu gato cresce conforme você acumula tempo de foco';

  @override
  String get adoptionCustom => 'Personalizado';

  @override
  String get adoptionDailyGoalLabel => 'Meta diária de foco (min)';

  @override
  String get adoptionReminderLabel => 'Lembrete diário (opcional)';

  @override
  String get adoptionReminderNone => 'Nenhum';

  @override
  String get adoptionCustomGoalTitle => 'Meta diária personalizada';

  @override
  String get adoptionMinutesPerDay => 'Minutos por dia';

  @override
  String get adoptionMinutesHint => '5 - 180';

  @override
  String get adoptionValidMinutes => 'Insira um valor entre 5 e 180';

  @override
  String get adoptionCustomTargetTitle => 'Horas alvo personalizadas';

  @override
  String get adoptionTotalHours => 'Total de horas';

  @override
  String get adoptionHoursHint => '10 - 2000';

  @override
  String get adoptionValidHours => 'Insira um valor entre 10 e 2000';

  @override
  String get adoptionSet => 'Definir';

  @override
  String get adoptionChooseKitten => 'Escolha seu filhote!';

  @override
  String adoptionCompanionFor(String quest) {
    return 'Seu companheiro para \"$quest\"';
  }

  @override
  String get adoptionRerollAll => 'Sortear todos';

  @override
  String get adoptionNameYourCat2 => 'Dê um nome ao seu gato';

  @override
  String get adoptionCatName => 'Nome do gato';

  @override
  String get adoptionCatHint => 'ex. Mochi';

  @override
  String get adoptionRandomTooltip => 'Nome aleatório';

  @override
  String adoptionGrowthTarget(String quest, int hours) {
    return 'Seu gato vai crescer enquanto você foca em \"$quest\"! Meta: ${hours}h no total.';
  }

  @override
  String get adoptionValidQuestName => 'Insira um nome para a missão';

  @override
  String get adoptionValidCatName => 'Dê um nome ao seu gato';

  @override
  String adoptionError(String message) {
    return 'Erro: $message';
  }

  @override
  String get adoptionBasicInfo => 'Informações básicas';

  @override
  String get adoptionGoals => 'Metas';

  @override
  String get adoptionUnlimitedMode => 'Modo ilimitado';

  @override
  String get adoptionUnlimitedDesc => 'Sem limite, continue acumulando';

  @override
  String get adoptionMilestoneMode => 'Modo de meta';

  @override
  String get adoptionMilestoneDesc => 'Defina um objetivo a alcançar';

  @override
  String get adoptionDeadlineLabel => 'Prazo';

  @override
  String get adoptionDeadlineNone => 'Não definido';

  @override
  String get adoptionReminderSection => 'Lembrete';

  @override
  String get adoptionMotivationLabel => 'Nota';

  @override
  String get adoptionMotivationHint => 'Escreva uma nota...';

  @override
  String get adoptionMotivationSwap => 'Preencher aleatoriamente';

  @override
  String get loginAppName => 'Hachimi';

  @override
  String get loginTagline => 'Crie gatos. Complete missões.';

  @override
  String get loginContinueGoogle => 'Continuar com Google';

  @override
  String get loginContinueEmail => 'Continuar com Email';

  @override
  String get loginAlreadyHaveAccount => 'Já tem uma conta? ';

  @override
  String get loginLogIn => 'Entrar';

  @override
  String get loginWelcomeBack => 'Bem-vindo de volta!';

  @override
  String get loginCreateAccount => 'Crie sua conta';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Senha';

  @override
  String get loginConfirmPassword => 'Confirmar senha';

  @override
  String get loginValidEmail => 'Insira seu email';

  @override
  String get loginValidEmailFormat => 'Insira um email válido';

  @override
  String get loginValidPassword => 'Insira sua senha';

  @override
  String get loginValidPasswordLength =>
      'A senha deve ter pelo menos 6 caracteres';

  @override
  String get loginValidPasswordMatch => 'As senhas não coincidem';

  @override
  String get loginCreateAccountButton => 'Criar conta';

  @override
  String get loginNoAccount => 'Não tem uma conta? ';

  @override
  String get loginRegister => 'Cadastre-se';

  @override
  String get checkInTitle => 'Check-in mensal';

  @override
  String get checkInDays => 'Dias';

  @override
  String get checkInCoinsEarned => 'Moedas ganhas';

  @override
  String get checkInAllMilestones => 'Todas as metas alcançadas!';

  @override
  String checkInMilestoneProgress(int remaining, int bonus) {
    return 'Mais $remaining dias → +$bonus moedas';
  }

  @override
  String get checkInMilestones => 'Metas';

  @override
  String get checkInFullMonth => 'Mês completo';

  @override
  String get checkInRewardSchedule => 'Programa de recompensas';

  @override
  String get checkInWeekday => 'Dias úteis (seg–sex)';

  @override
  String checkInWeekdayReward(int coins) {
    return '$coins moedas/dia';
  }

  @override
  String get checkInWeekend => 'Fim de semana (sáb–dom)';

  @override
  String checkInNDays(int count) {
    return '$count dias';
  }

  @override
  String get onboardTitle1 => 'Conheça seu companheiro';

  @override
  String get onboardSubtitle1 => 'Toda missão começa com um filhote';

  @override
  String get onboardBody1 =>
      'Defina uma meta e adote um filhote.\nFoque nela e veja seu gato crescer!';

  @override
  String get onboardTitle2 => 'Foque, cresça, evolua';

  @override
  String get onboardSubtitle2 => '4 estágios de crescimento';

  @override
  String get onboardBody2 =>
      'Cada minuto de foco ajuda seu gato a evoluir\nde um pequeno filhote a um magnífico sênior!';

  @override
  String get onboardTitle3 => 'Monte sua CatHouse';

  @override
  String get onboardSubtitle3 => 'Colecione gatos únicos';

  @override
  String get onboardBody3 =>
      'Cada missão traz um novo gato com aparência única.\nDescubra todos e monte sua coleção dos sonhos!';

  @override
  String get onboardSkip => 'Pular';

  @override
  String get onboardLetsGo => 'Vamos lá!';

  @override
  String get onboardNext => 'Próximo';

  @override
  String get catRoomTitle => 'CatHouse';

  @override
  String get catRoomInventory => 'Inventário';

  @override
  String get catRoomShop => 'Loja de acessórios';

  @override
  String get catRoomLoadError => 'Falha ao carregar gatos';

  @override
  String get catRoomEmptyTitle => 'Sua CatHouse está vazia';

  @override
  String get catRoomEmptySubtitle =>
      'Inicie uma missão para adotar seu primeiro gato!';

  @override
  String get catRoomEditQuest => 'Editar missão';

  @override
  String get catRoomRenameCat => 'Renomear gato';

  @override
  String get catRoomArchiveCat => 'Arquivar gato';

  @override
  String get catRoomNewName => 'Novo nome';

  @override
  String get catRoomRename => 'Renomear';

  @override
  String get catRoomArchiveTitle => 'Arquivar gato?';

  @override
  String catRoomArchiveMessage(String name) {
    return 'Isso vai arquivar \"$name\" e excluir sua missão vinculada. O gato ainda aparecerá no seu álbum.';
  }

  @override
  String get catRoomArchive => 'Arquivar';

  @override
  String catRoomAlbumSection(int count) {
    return 'Álbum ($count)';
  }

  @override
  String get catRoomReactivateCat => 'Reativar gato';

  @override
  String get catRoomReactivateTitle => 'Reativar gato?';

  @override
  String catRoomReactivateMessage(String name) {
    return 'Isso vai restaurar \"$name\" e sua missão vinculada na CatHouse.';
  }

  @override
  String get catRoomReactivate => 'Reativar';

  @override
  String get catRoomArchivedLabel => 'Arquivado';

  @override
  String catRoomArchiveSuccess(String name) {
    return '\"$name\" arquivado';
  }

  @override
  String catRoomReactivateSuccess(String name) {
    return '\"$name\" reativado';
  }

  @override
  String get catRoomArchiveError => 'Falha ao arquivar o gato';

  @override
  String get catRoomReactivateError => 'Falha ao reativar o gato';

  @override
  String get catRoomArchiveLoadError => 'Falha ao carregar gatos arquivados';

  @override
  String get catRoomRenameError => 'Falha ao renomear o gato';

  @override
  String get addHabitTitle => 'Nova missão';

  @override
  String get addHabitQuestName => 'Nome da missão';

  @override
  String get addHabitQuestHint => 'ex. Prática de LeetCode';

  @override
  String get addHabitValidName => 'Insira um nome para a missão';

  @override
  String get addHabitTargetHours => 'Horas alvo';

  @override
  String get addHabitTargetHint => 'ex. 100';

  @override
  String get addHabitValidTarget => 'Insira as horas alvo';

  @override
  String get addHabitValidNumber => 'Insira um número válido';

  @override
  String get addHabitCreate => 'Criar missão';

  @override
  String get addHabitHoursSuffix => 'horas';

  @override
  String shopTabPlants(int count) {
    return 'Plantas ($count)';
  }

  @override
  String shopTabWild(int count) {
    return 'Selvagem ($count)';
  }

  @override
  String shopTabCollars(int count) {
    return 'Coleiras ($count)';
  }

  @override
  String get shopNoAccessories => 'Nenhum acessório disponível';

  @override
  String shopBuyConfirm(String name) {
    return 'Comprar $name?';
  }

  @override
  String get shopPurchaseButton => 'Comprar';

  @override
  String get shopNotEnoughCoinsButton => 'Moedas insuficientes';

  @override
  String shopPurchaseSuccess(String name) {
    return 'Comprado! $name adicionado ao inventário';
  }

  @override
  String shopPurchaseFailed(int price) {
    return 'Moedas insuficientes (precisa de $price)';
  }

  @override
  String get inventoryTitle => 'Inventário';

  @override
  String inventoryInBox(int count) {
    return 'Na caixa ($count)';
  }

  @override
  String get inventoryEmpty =>
      'Seu inventário está vazio.\nVisite a loja para conseguir acessórios!';

  @override
  String inventoryEquippedOnCats(int count) {
    return 'Equipados nos gatos ($count)';
  }

  @override
  String get inventoryNoEquipped => 'Nenhum acessório equipado em nenhum gato.';

  @override
  String get inventoryUnequip => 'Desequipar';

  @override
  String get inventoryNoActiveCats => 'Nenhum gato ativo';

  @override
  String inventoryEquipTo(String name) {
    return 'Equipar $name em:';
  }

  @override
  String inventoryEquipSuccess(String name) {
    return '$name equipado';
  }

  @override
  String inventoryUnequipSuccess(String catName) {
    return 'Desequipado de $catName';
  }

  @override
  String get chatCatNotFound => 'Gato não encontrado';

  @override
  String chatTitle(String name) {
    return 'Conversa com $name';
  }

  @override
  String get chatClearHistory => 'Limpar histórico';

  @override
  String chatEmptyTitle(String name) {
    return 'Diga oi para $name!';
  }

  @override
  String get chatEmptySubtitle =>
      'Comece uma conversa com seu gato. Ele vai responder de acordo com sua personalidade!';

  @override
  String get chatGenerating => 'Gerando...';

  @override
  String get chatTypeMessage => 'Digite uma mensagem...';

  @override
  String get chatClearConfirmTitle => 'Limpar histórico do chat?';

  @override
  String get chatClearConfirmMessage =>
      'Isso vai excluir todas as mensagens. Não pode ser desfeito.';

  @override
  String get chatClearButton => 'Limpar';

  @override
  String get chatSend => 'Enviar';

  @override
  String get chatStop => 'Parar';

  @override
  String get chatErrorMessage => 'Failed to send message. Tap to retry.';

  @override
  String get chatRetry => 'Retry';

  @override
  String get chatErrorGeneric => 'Algo deu errado. Tente novamente.';

  @override
  String diaryTitle(String name) {
    return 'Diário de $name';
  }

  @override
  String get diaryLoadFailed => 'Falha ao carregar o diário';

  @override
  String get diaryRetry => 'Tentar novamente';

  @override
  String get diaryEmptyTitle2 => 'Nenhuma entrada no diário ainda';

  @override
  String get diaryEmptySubtitle =>
      'Complete uma sessão de foco e seu gato vai escrever a primeira entrada do diário!';

  @override
  String get statsTitle => 'Estatísticas';

  @override
  String get statsTotalHours => 'Horas totais';

  @override
  String statsTimeValue(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get statsBestStreak => 'Melhor sequência';

  @override
  String statsStreakDays(int count) {
    return '$count dias';
  }

  @override
  String get statsOverallProgress => 'Progresso geral';

  @override
  String statsPercentOfGoals(String percent) {
    return '$percent% de todas as metas';
  }

  @override
  String get statsPerQuestProgress => 'Progresso por missão';

  @override
  String get statsQuestLoadError => 'Falha ao carregar estatísticas de missões';

  @override
  String get statsNoQuestData => 'Nenhum dado de missão ainda';

  @override
  String get statsNoQuestHint =>
      'Inicie uma missão para ver seu progresso aqui!';

  @override
  String get statsLast30Days => 'Últimos 30 dias';

  @override
  String get habitDetailQuestNotFound => 'Missão não encontrada';

  @override
  String get habitDetailComplete => 'completo';

  @override
  String get habitDetailTotalTime => 'Tempo total';

  @override
  String get habitDetailCurrentStreak => 'Sequência atual';

  @override
  String get habitDetailTarget => 'Meta';

  @override
  String habitDetailDaysUnit(int count) {
    return '$count dias';
  }

  @override
  String habitDetailHoursUnit(int count) {
    return '$count horas';
  }

  @override
  String checkInBannerSuccess(int coins) {
    return '+$coins moedas! Check-in diário completo';
  }

  @override
  String checkInBannerBonus(int bonus) {
    return ' + $bonus bônus de meta!';
  }

  @override
  String get checkInBannerSemantics => 'Check-in diário';

  @override
  String get checkInBannerLoading => 'Carregando status do check-in...';

  @override
  String checkInBannerPrompt(int coins) {
    return 'Faça check-in por +$coins moedas';
  }

  @override
  String checkInBannerSummary(int count, int total, int coins) {
    return '$count/$total dias  ·  +$coins hoje';
  }

  @override
  String commonErrorWithDetail(String error) {
    return 'Erro: $error';
  }

  @override
  String get profileFallbackUser => 'Usuário';

  @override
  String get fallbackCatName => 'Gato';

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
  String get notifFocusing => 'focando...';

  @override
  String get notifInProgress => 'Sessão de foco em andamento';

  @override
  String get unitMinShort => 'min';

  @override
  String get unitHourShort => 'h';

  @override
  String get weekdayMon => 'Seg';

  @override
  String get weekdayTue => 'Ter';

  @override
  String get weekdayWed => 'Qua';

  @override
  String get weekdayThu => 'Qui';

  @override
  String get weekdayFri => 'Sex';

  @override
  String get weekdaySat => 'Sáb';

  @override
  String get weekdaySun => 'Dom';

  @override
  String get statsTotalSessions => 'Sessões';

  @override
  String get statsTotalHabits => 'Hábitos';

  @override
  String get statsActiveDays => 'Dias ativos';

  @override
  String get statsWeeklyTrend => 'Tendência semanal';

  @override
  String get statsRecentSessions => 'Foco recente';

  @override
  String get statsViewAllHistory => 'Ver todo o histórico';

  @override
  String get historyTitle => 'Histórico de foco';

  @override
  String get historyFilterAll => 'Todos';

  @override
  String historySessionCount(int count) {
    return '$count sessões';
  }

  @override
  String historyTotalMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get historyNoSessions => 'Nenhum registro de foco ainda';

  @override
  String get historyNoSessionsHint =>
      'Complete uma sessão de foco para vê-la aqui';

  @override
  String get historyLoadMore => 'Carregar mais';

  @override
  String get sessionCompleted => 'Completada';

  @override
  String get sessionAbandoned => 'Abandonada';

  @override
  String get sessionInterrupted => 'Interrompida';

  @override
  String get sessionCountdown => 'Contagem regressiva';

  @override
  String get sessionStopwatch => 'Cronômetro';

  @override
  String get historyDateGroupToday => 'Hoje';

  @override
  String get historyDateGroupYesterday => 'Ontem';

  @override
  String get historyLoadError => 'Falha ao carregar histórico';

  @override
  String get historySelectMonth => 'Selecionar mês';

  @override
  String get historyAllMonths => 'Todos os meses';

  @override
  String get historyAllHabits => 'Todos';

  @override
  String get homeTabAchievements => 'Conquistas';

  @override
  String get achievementTitle => 'Conquistas';

  @override
  String get achievementTabOverview => 'Resumo';

  @override
  String get achievementTabQuest => 'Missão';

  @override
  String get achievementTabStreak => 'Sequência';

  @override
  String get achievementTabCat => 'Gato';

  @override
  String get achievementTabPersist => 'Constância';

  @override
  String get achievementSummaryTitle => 'Progresso de conquistas';

  @override
  String achievementUnlockedCount(int count) {
    return '$count desbloqueadas';
  }

  @override
  String achievementTotalCoins(int coins) {
    return '$coins moedas ganhas';
  }

  @override
  String get achievementUnlocked => 'Conquista desbloqueada!';

  @override
  String get achievementAwesome => 'Incrível!';

  @override
  String get achievementIncredible => 'Fenomenal!';

  @override
  String get achievementHidden => '???';

  @override
  String get achievementHiddenDesc => 'Esta é uma conquista oculta';

  @override
  String achievementPersistDesc(int days) {
    return 'Acumule $days dias de check-in em qualquer missão';
  }

  @override
  String achievementTitleCount(int count) {
    return '$count títulos desbloqueados';
  }

  @override
  String get growthPathTitle => 'Caminho de crescimento';

  @override
  String get growthPathKitten => 'Comece uma nova jornada';

  @override
  String get growthPathAdolescent => 'Construa as bases';

  @override
  String get growthPathAdult => 'Habilidades se consolidam';

  @override
  String get growthPathSenior => 'Domínio profundo';

  @override
  String get growthPathTip =>
      'Pesquisas mostram que 20 horas de prática focada são suficientes para construir a base de uma nova habilidade — Josh Kaufman';

  @override
  String achievementCelebrationCoins(int count) {
    return '+$count moedas';
  }

  @override
  String achievementCelebrationTitle(String title) {
    return 'Título conquistado: $title';
  }

  @override
  String get achievementCelebrationDismiss => 'Incrível!';

  @override
  String get achievementCelebrationSkipAll => 'Pular tudo';

  @override
  String achievementCelebrationCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String achievementUnlockedAt(String date) {
    return 'Desbloqueada em $date';
  }

  @override
  String get achievementLocked => 'Ainda não desbloqueada';

  @override
  String achievementRewardCoins(int count) {
    return '+$count moedas';
  }

  @override
  String get reminderModeDaily => 'Todos os dias';

  @override
  String get reminderModeWeekdays => 'Dias úteis';

  @override
  String get reminderModeMonday => 'Segunda-feira';

  @override
  String get reminderModeTuesday => 'Terça-feira';

  @override
  String get reminderModeWednesday => 'Quarta-feira';

  @override
  String get reminderModeThursday => 'Quinta-feira';

  @override
  String get reminderModeFriday => 'Sexta-feira';

  @override
  String get reminderModeSaturday => 'Sábado';

  @override
  String get reminderModeSunday => 'Domingo';

  @override
  String get reminderPickerTitle => 'Selecionar horário do lembrete';

  @override
  String get reminderHourUnit => 'h';

  @override
  String get reminderMinuteUnit => 'min';

  @override
  String get reminderAddMore => 'Adicionar lembrete';

  @override
  String get reminderMaxReached => 'Máximo de 5 lembretes';

  @override
  String get reminderConfirm => 'Confirmar';

  @override
  String reminderNotificationTitle(String catName) {
    return '$catName sente sua falta!';
  }

  @override
  String reminderNotificationBody(String habitName) {
    return 'Hora de $habitName — seu gato está esperando!';
  }

  @override
  String get deleteAccountDataWarning =>
      'Todos os dados a seguir serão excluídos permanentemente:';

  @override
  String get deleteAccountQuests => 'Missões';

  @override
  String get deleteAccountCats => 'Gatos';

  @override
  String get deleteAccountHours => 'Horas de foco';

  @override
  String get deleteAccountIrreversible => 'Essa ação é irreversível';

  @override
  String get deleteAccountContinue => 'Continuar';

  @override
  String get deleteAccountConfirmTitle => 'Confirmar exclusão';

  @override
  String get deleteAccountTypeDelete =>
      'Digite DELETE para confirmar a exclusão da conta:';

  @override
  String get deleteAccountAuthCancelled => 'Autenticação cancelada';

  @override
  String deleteAccountAuthFailed(String error) {
    return 'Falha na autenticação: $error';
  }

  @override
  String get deleteAccountProgress => 'Excluindo conta...';

  @override
  String get deleteAccountSuccess => 'Conta excluída';

  @override
  String get drawerGuestLoginSubtitle =>
      'Sincronize dados e desbloqueie recursos de IA';

  @override
  String get drawerGuestSignIn => 'Entrar';

  @override
  String get drawerMilestones => 'Metas';

  @override
  String drawerMilestoneFocus(int hours, int minutes) {
    return 'Foco total: ${hours}h ${minutes}m';
  }

  @override
  String drawerMilestoneCats(int count) {
    return 'Família de gatos: $count';
  }

  @override
  String drawerMilestoneQuests(int count) {
    return 'Missões ativas: $count';
  }

  @override
  String get drawerMySection => 'Meu';

  @override
  String get drawerSessionHistory => 'Histórico de foco';

  @override
  String get drawerCheckInCalendar => 'Calendário de check-in';

  @override
  String get drawerAccountSection => 'Conta';

  @override
  String get settingsResetData => 'Redefinir todos os dados';

  @override
  String get settingsResetDataTitle => 'Redefinir todos os dados?';

  @override
  String get settingsResetDataMessage =>
      'Isso vai excluir todos os dados locais e voltar para a tela de boas-vindas. Não pode ser desfeito.';

  @override
  String get guestUpgradeTitle => 'Proteja seus dados';

  @override
  String get guestUpgradeMessage =>
      'Vincule uma conta para fazer backup do seu progresso, desbloquear diário IA e chat, e sincronizar entre dispositivos.';

  @override
  String get guestUpgradeLinkButton => 'Vincular conta';

  @override
  String get guestUpgradeLater => 'Talvez depois';

  @override
  String get loginLinkTagline => 'Vincule uma conta para proteger seus dados';

  @override
  String get aiTeaserTitle => 'Diário do gato';

  @override
  String aiTeaserPreview(String catName) {
    return 'Hoje eu estudei com meu humano de novo... $catName se sente mais inteligente a cada dia~';
  }

  @override
  String aiTeaserCta(String catName) {
    return 'Vincule uma conta para ver o que $catName quer dizer';
  }

  @override
  String get authErrorEmailInUse => 'Este email já está cadastrado';

  @override
  String get authErrorWrongPassword => 'Email ou senha incorretos';

  @override
  String get authErrorUserNotFound => 'Nenhuma conta encontrada com este email';

  @override
  String get authErrorTooManyRequests =>
      'Muitas tentativas. Tente novamente mais tarde';

  @override
  String get authErrorNetwork => 'Erro de rede. Verifique sua conexão';

  @override
  String get authErrorAdminRestricted =>
      'O login está temporariamente restrito';

  @override
  String get authErrorWeakPassword =>
      'A senha é muito fraca. Use pelo menos 6 caracteres';

  @override
  String get authErrorGeneric => 'Algo deu errado. Tente novamente';

  @override
  String get deleteAccountReauthEmail => 'Insira sua senha para continuar';

  @override
  String get deleteAccountReauthPasswordHint => 'Senha';

  @override
  String get deleteAccountError =>
      'Algo deu errado. Tente novamente mais tarde.';

  @override
  String get deleteAccountPermissionError =>
      'Erro de permissão. Tente sair e entrar novamente.';

  @override
  String get deleteAccountNetworkError =>
      'Sem conexão com a internet. Verifique sua rede.';

  @override
  String get deleteAccountRetainedData =>
      'Análises de uso e relatórios de erros não podem ser excluídos.';

  @override
  String get deleteAccountStepCloud => 'Excluindo dados na nuvem...';

  @override
  String get deleteAccountStepLocal => 'Limpando dados locais...';

  @override
  String get deleteAccountStepDone => 'Concluído';

  @override
  String get deleteAccountQueued =>
      'Dados locais excluídos. A exclusão da conta na nuvem está na fila e será concluída quando estiver online.';

  @override
  String get deleteAccountPending =>
      'A exclusão da conta está pendente. Mantenha o app online para concluir a exclusão na nuvem e autenticação.';

  @override
  String get deleteAccountAbandon => 'Começar do zero';

  @override
  String get archiveConflictTitle => 'Escolha o arquivo para manter';

  @override
  String get archiveConflictMessage =>
      'Tanto o arquivo local quanto o da nuvem têm dados. Escolha um para manter:';

  @override
  String get archiveConflictLocal => 'Arquivo local';

  @override
  String get archiveConflictCloud => 'Arquivo na nuvem';

  @override
  String get archiveConflictKeepCloud => 'Manter nuvem';

  @override
  String get archiveConflictKeepLocal => 'Manter local';

  @override
  String get loginShowPassword => 'Mostrar senha';

  @override
  String get loginHidePassword => 'Ocultar senha';

  @override
  String get errorGeneric => 'Algo deu errado. Tente novamente mais tarde';

  @override
  String get errorCreateHabit => 'Falha ao criar hábito. Tente novamente';

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
  String get commonCopyId => 'Copiar ID';

  @override
  String get adoptionClearDeadline => 'Limpar prazo';

  @override
  String get commonIdCopied => 'ID copiado';

  @override
  String get pickerDurationLabel => 'Seletor de duração';

  @override
  String pickerMinutesValue(int count) {
    return '$count minutos';
  }

  @override
  String a11yCatImage(String name) {
    return 'Gato $name';
  }

  @override
  String a11yCatTapToInteract(String name) {
    return '$name, toque para interagir';
  }

  @override
  String a11yProgressPercent(int percent) {
    return '$percent% concluído';
  }

  @override
  String a11yStreakActiveDays(int count) {
    return '$count dias ativos';
  }

  @override
  String get a11yOfflineStatus => 'Modo offline';

  @override
  String a11yAchievementUnlocked(String name) {
    return 'Conquista desbloqueada: $name';
  }

  @override
  String get calendarCheckedIn => 'registrado';

  @override
  String get calendarToday => 'hoje';

  @override
  String a11yEquipToCat(Object name) {
    return 'Equipar em $name';
  }

  @override
  String a11yRegenerateCat(Object name) {
    return 'Regenerar $name';
  }

  @override
  String a11yTimerDisplay(Object time) {
    return 'Temporizador: $time';
  }

  @override
  String a11yOnboardingPage(Object current, Object total) {
    return 'Página $current de $total';
  }

  @override
  String a11yEditDisplayName(Object name) {
    return 'Editar nome: $name';
  }

  @override
  String get routeNotFound => 'Página não encontrada';

  @override
  String get routeGoHome => 'Ir para início';

  @override
  String get a11yError => 'Erro';

  @override
  String get a11yDeadline => 'Prazo';

  @override
  String get a11yReminder => 'Lembrete';

  @override
  String get a11yFocusMeditation => 'Meditação focada';

  @override
  String get a11yUnlocked => 'Desbloqueado';

  @override
  String get a11ySelected => 'Selecionado';

  @override
  String get a11yDynamicWallpaperColor => 'Cor dinâmica do papel de parede';
}
