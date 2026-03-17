// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class SEs extends S {
  SEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Hachimi';

  @override
  String get homeTabToday => 'Hoy';

  @override
  String get homeTabCatHouse => 'CatHouse';

  @override
  String get homeTabStats => 'Estadísticas';

  @override
  String get homeTabProfile => 'Perfil';

  @override
  String get adoptionStepDefineHabit => 'Definir hábito';

  @override
  String get adoptionStepAdoptCat => 'Adoptar gato';

  @override
  String get adoptionStepNameCat => 'Nombrar gato';

  @override
  String get adoptionHabitName => 'Nombre del hábito';

  @override
  String get adoptionHabitNameHint => 'ej. Lectura diaria';

  @override
  String get adoptionDailyGoal => 'Meta diaria';

  @override
  String get adoptionTargetHours => 'Horas objetivo';

  @override
  String get adoptionTargetHoursHint =>
      'Total de horas para completar este hábito';

  @override
  String adoptionMinutes(int count) {
    return '$count min';
  }

  @override
  String get adoptionRefreshCat => 'Probar otro';

  @override
  String adoptionPersonality(String name) {
    return 'Personalidad: $name';
  }

  @override
  String get adoptionNameYourCat => 'Nombra a tu gato';

  @override
  String get adoptionRandomName => 'Aleatorio';

  @override
  String get adoptionCreate => 'Crear hábito y adoptar';

  @override
  String get adoptionNext => 'Siguiente';

  @override
  String get adoptionBack => 'Atrás';

  @override
  String get adoptionCatNameLabel => 'Nombre del gato';

  @override
  String get adoptionCatNameHint => 'ej. Mochi';

  @override
  String get adoptionRandomNameTooltip => 'Nombre aleatorio';

  @override
  String get catHouseTitle => 'CatHouse';

  @override
  String get catHouseEmpty =>
      'Aún no tienes gatos. Crea un hábito para adoptar tu primer gato.';

  @override
  String catHouseGrowth(int minutes, int target) {
    return '$minutes / $target min';
  }

  @override
  String get catDetailGrowthProgress => 'Progreso de crecimiento';

  @override
  String catDetailTotalMinutes(int minutes) {
    return '$minutes min enfocados';
  }

  @override
  String catDetailTargetMinutes(int minutes) {
    return 'Meta: $minutes min';
  }

  @override
  String get catDetailRename => 'Renombrar';

  @override
  String get catDetailAccessories => 'Accesorios';

  @override
  String get catDetailStartFocus => 'Iniciar enfoque';

  @override
  String get catDetailBoundHabit => 'Hábito vinculado';

  @override
  String catDetailStage(String stage) {
    return 'Etapa: $stage';
  }

  @override
  String coinBalance(int amount) {
    return '$amount monedas';
  }

  @override
  String coinCheckInReward(int amount) {
    return '+$amount monedas';
  }

  @override
  String get coinCheckInTitle => 'Registro diario';

  @override
  String get coinInsufficientBalance => 'Monedas insuficientes';

  @override
  String get shopTitle => 'Tienda de accesorios';

  @override
  String shopPrice(int price) {
    return '$price monedas';
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
  String get focusCompleteStageUp => '¡Subiste de etapa!';

  @override
  String get focusCompleteGreatJob => '¡Buen trabajo!';

  @override
  String get focusCompleteDone => 'Listo';

  @override
  String get focusCompleteItsOkay => '¡No pasa nada!';

  @override
  String focusCompleteEvolved(String catName) {
    return '¡$catName evolucionó!';
  }

  @override
  String focusCompleteFocusedFor(int minutes) {
    return 'Te enfocaste por $minutes minutos';
  }

  @override
  String focusCompleteAbandonedMessage(String catName) {
    return '$catName dice: \"¡Lo intentaremos de nuevo!\"';
  }

  @override
  String get focusCompleteFocusTime => 'Tiempo de enfoque';

  @override
  String get focusCompleteCoinsEarned => 'Monedas ganadas';

  @override
  String get focusCompleteBaseXp => 'XP base';

  @override
  String get focusCompleteStreakBonus => 'Bonus de racha';

  @override
  String get focusCompleteMilestoneBonus => 'Bonus de meta';

  @override
  String get focusCompleteFullHouseBonus => 'Bonus de casa llena';

  @override
  String get focusCompleteTotal => 'Total';

  @override
  String focusCompleteEvolvedTo(String stage) {
    return '¡Evolucionó a $stage!';
  }

  @override
  String get focusCompleteYourCat => 'Tu gato';

  @override
  String get focusCompleteDiaryWriting => 'Escribiendo diario...';

  @override
  String get focusCompleteDiaryWritten => '¡Diario escrito!';

  @override
  String get focusCompleteNotifTitle => '¡Misión completada!';

  @override
  String focusCompleteNotifBody(String catName, int xp, int minutes) {
    return '$catName ganó +$xp XP con $minutes min de enfoque';
  }

  @override
  String get stageKitten => 'Gatito';

  @override
  String get stageAdolescent => 'Adolescente';

  @override
  String get stageAdult => 'Adulto';

  @override
  String get stageSenior => 'Senior';

  @override
  String get migrationTitle => 'Actualización de datos necesaria';

  @override
  String get migrationMessage =>
      'Hachimi se actualizó con un nuevo sistema de gatos pixel. Tus datos anteriores ya no son compatibles. Reinicia para comenzar de nuevo con la nueva experiencia.';

  @override
  String get migrationResetButton => 'Reiniciar y empezar de nuevo';

  @override
  String get sessionResumeTitle => '¿Reanudar sesión?';

  @override
  String sessionResumeMessage(String habitName, String elapsed) {
    return 'Tenías una sesión de enfoque activa ($habitName, $elapsed). ¿Reanudar?';
  }

  @override
  String get sessionResumeButton => 'Reanudar';

  @override
  String get sessionDiscard => 'Descartar';

  @override
  String get todaySummaryMinutes => 'Hoy';

  @override
  String get todaySummaryTotal => 'Total';

  @override
  String get todaySummaryCats => 'Gatos';

  @override
  String get todayYourQuests => 'Tus misiones';

  @override
  String get todayNoQuests => 'Aún no hay misiones';

  @override
  String get todayNoQuestsHint =>
      'Toca + para iniciar una misión y adoptar un gato.';

  @override
  String get todayFocus => 'Enfocar';

  @override
  String get todayDeleteQuestTitle => '¿Eliminar misión?';

  @override
  String todayDeleteQuestMessage(String name) {
    return '¿Seguro que quieres eliminar \"$name\"? El gato será graduado a tu álbum.';
  }

  @override
  String todayQuestCompleted(String name) {
    return '$name completada';
  }

  @override
  String get todayFailedToLoad => 'Error al cargar misiones';

  @override
  String todayMinToday(int count) {
    return '$count min hoy';
  }

  @override
  String todayGoalMinPerDay(int count) {
    return 'Meta: $count min/día';
  }

  @override
  String get todayFeaturedCat => 'Gato destacado';

  @override
  String get todayAddHabit => 'Agregar hábito';

  @override
  String get todayNoHabits => '¡Crea tu primer hábito para comenzar!';

  @override
  String get todayNewQuest => 'Nueva misión';

  @override
  String get todayStartFocus => 'Iniciar enfoque';

  @override
  String get timerStart => 'Iniciar';

  @override
  String get timerPause => 'Pausar';

  @override
  String get timerResume => 'Reanudar';

  @override
  String get timerDone => 'Listo';

  @override
  String get timerGiveUp => 'Rendirse';

  @override
  String get timerRemaining => 'restante';

  @override
  String get timerElapsed => 'transcurrido';

  @override
  String get timerPaused => 'PAUSADO';

  @override
  String get timerQuestNotFound => 'Misión no encontrada';

  @override
  String get timerNotificationBanner =>
      'Activa las notificaciones para ver el progreso del temporizador cuando la app está en segundo plano';

  @override
  String get timerNotificationDismiss => 'Cerrar';

  @override
  String get timerNotificationEnable => 'Activar';

  @override
  String timerGraceBack(int seconds) {
    return 'Volver (${seconds}s)';
  }

  @override
  String get giveUpTitle => '¿Rendirse?';

  @override
  String get giveUpMessage =>
      'Si te enfocaste al menos 5 minutos, el tiempo aún cuenta para el crecimiento de tu gato. ¡Tu gato entenderá!';

  @override
  String get giveUpKeepGoing => 'Seguir adelante';

  @override
  String get giveUpConfirm => 'Rendirse';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get settingsNotifications => 'Notificaciones';

  @override
  String get settingsNotificationFocusReminders => 'Recordatorios de enfoque';

  @override
  String get settingsNotificationSubtitle =>
      'Recibe recordatorios diarios para mantener el ritmo';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Predeterminado del sistema';

  @override
  String get settingsLanguageEnglish => 'Inglés';

  @override
  String get settingsLanguageChinese => '中文';

  @override
  String get settingsThemeMode => 'Modo de tema';

  @override
  String get settingsThemeModeSystem => 'Sistema';

  @override
  String get settingsThemeModeLight => 'Claro';

  @override
  String get settingsThemeModeDark => 'Oscuro';

  @override
  String get settingsThemeColor => 'Color del tema';

  @override
  String get settingsThemeColorDynamic => 'Dinámico';

  @override
  String get settingsThemeColorDynamicSubtitle =>
      'Usar colores del fondo de pantalla';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get settingsVersion => 'Versión';

  @override
  String get settingsLicenses => 'Licencias';

  @override
  String get settingsAccount => 'Cuenta';

  @override
  String get logoutTitle => '¿Cerrar sesión?';

  @override
  String get logoutMessage => '¿Seguro que quieres cerrar sesión?';

  @override
  String get loggingOut => 'Cerrando sesión...';

  @override
  String get deleteAccountTitle => '¿Eliminar cuenta?';

  @override
  String get deleteAccountMessage =>
      'Esto eliminará permanentemente tu cuenta y todos tus datos. Esta acción no se puede deshacer.';

  @override
  String get deleteAccountWarning => 'Esta acción no se puede deshacer';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileYourJourney => 'Tu camino';

  @override
  String get profileTotalFocus => 'Enfoque total';

  @override
  String get profileTotalCats => 'Total de gatos';

  @override
  String get profileTotalQuests => 'Misiones';

  @override
  String get profileEditName => 'Editar nombre';

  @override
  String get profileDisplayName => 'Nombre visible';

  @override
  String get profileChooseAvatar => 'Elegir avatar';

  @override
  String get profileSaved => 'Perfil guardado';

  @override
  String get profileSettings => 'Ajustes';

  @override
  String get habitDetailStreak => 'Racha';

  @override
  String get habitDetailBestStreak => 'Mejor';

  @override
  String get habitDetailTotalMinutes => 'Total';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonDone => 'Listo';

  @override
  String get commonDismiss => 'Cerrar';

  @override
  String get commonEnable => 'Activar';

  @override
  String get commonLoading => 'Cargando...';

  @override
  String get commonError => 'Algo salió mal';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonResume => 'Reanudar';

  @override
  String get commonPause => 'Pausar';

  @override
  String get commonLogOut => 'Cerrar sesión';

  @override
  String get commonDeleteAccount => 'Eliminar cuenta';

  @override
  String get commonYes => 'Sí';

  @override
  String chatDailyRemaining(int count) {
    return '$count mensajes restantes hoy';
  }

  @override
  String get chatDailyLimitReached => 'Límite diario de mensajes alcanzado';

  @override
  String get aiTemporarilyUnavailable =>
      'Las funciones de IA no están disponibles temporalmente';

  @override
  String get catDetailNotFound => 'Gato no encontrado';

  @override
  String get catDetailChatTooltip => 'Chat';

  @override
  String get catDetailRenameTooltip => 'Renombrar';

  @override
  String get catDetailGrowthTitle => 'Progreso de crecimiento';

  @override
  String catDetailTarget(int hours) {
    return 'Meta: ${hours}h';
  }

  @override
  String get catDetailRenameTitle => 'Renombrar gato';

  @override
  String get catDetailNewName => 'Nuevo nombre';

  @override
  String get catDetailRenamed => '¡Gato renombrado!';

  @override
  String get catDetailQuestBadge => 'Misión';

  @override
  String get catDetailEditQuest => 'Editar misión';

  @override
  String get catDetailDailyGoal => 'Meta diaria';

  @override
  String get catDetailTodaysFocus => 'Enfoque de hoy';

  @override
  String get catDetailTotalFocus => 'Enfoque total';

  @override
  String get catDetailTargetLabel => 'Meta';

  @override
  String get catDetailCompletion => 'Progreso';

  @override
  String get catDetailCurrentStreak => 'Racha actual';

  @override
  String get catDetailBestStreakLabel => 'Mejor racha';

  @override
  String get catDetailAvgDaily => 'Promedio diario';

  @override
  String get catDetailDaysActive => 'Días activos';

  @override
  String get catDetailCheckInDays => 'Días de registro';

  @override
  String get catDetailEditQuestTitle => 'Editar misión';

  @override
  String get catDetailQuestName => 'Nombre de la misión';

  @override
  String get catDetailDailyGoalMinutes => 'Meta diaria (minutos)';

  @override
  String get catDetailTargetTotalHours => 'Meta total (horas)';

  @override
  String get catDetailQuestUpdated => '¡Misión actualizada!';

  @override
  String get catDetailTargetCompletedHint =>
      'Meta alcanzada — ahora en modo ilimitado';

  @override
  String get catDetailDailyReminder => 'Recordatorio diario';

  @override
  String catDetailEveryDay(String time) {
    return '$time todos los días';
  }

  @override
  String get catDetailNoReminder => 'Sin recordatorio';

  @override
  String get catDetailChange => 'Cambiar';

  @override
  String get catDetailRemoveReminder => 'Eliminar recordatorio';

  @override
  String get catDetailSet => 'Establecer';

  @override
  String catDetailReminderSet(String time) {
    return 'Recordatorio establecido a las $time';
  }

  @override
  String get catDetailReminderRemoved => 'Recordatorio eliminado';

  @override
  String get catDetailDiaryTitle => 'Diario Hachimi';

  @override
  String get catDetailDiaryLoading => 'Cargando...';

  @override
  String get catDetailDiaryError => 'No se pudo cargar el diario';

  @override
  String get catDetailDiaryEmpty =>
      'Aún no hay entrada de diario hoy. ¡Completa una sesión de enfoque!';

  @override
  String catDetailChatWith(String name) {
    return 'Chatear con $name';
  }

  @override
  String get catDetailChatSubtitle => 'Conversa con tu gato';

  @override
  String get catDetailActivity => 'Actividad';

  @override
  String get catDetailActivityError => 'Error al cargar datos de actividad';

  @override
  String get catDetailAccessoriesTitle => 'Accesorios';

  @override
  String get catDetailEquipped => 'Equipado: ';

  @override
  String get catDetailNone => 'Ninguno';

  @override
  String get catDetailUnequip => 'Desequipar';

  @override
  String catDetailFromInventory(int count) {
    return 'Del inventario ($count)';
  }

  @override
  String get catDetailNoAccessories =>
      'Aún no tienes accesorios. ¡Visita la tienda!';

  @override
  String catDetailEquippedItem(String name) {
    return '$name equipado';
  }

  @override
  String get catDetailUnequipped => 'Desequipado';

  @override
  String catDetailAbout(String name) {
    return 'Acerca de $name';
  }

  @override
  String get catDetailAppearanceDetails => 'Detalles de apariencia';

  @override
  String get catDetailStatus => 'Estado';

  @override
  String get catDetailAdopted => 'Adoptado';

  @override
  String get catDetailFurPattern => 'Patrón del pelaje';

  @override
  String get catDetailFurColor => 'Color del pelaje';

  @override
  String get catDetailFurLength => 'Largo del pelaje';

  @override
  String get catDetailEyes => 'Ojos';

  @override
  String get catDetailWhitePatches => 'Manchas blancas';

  @override
  String get catDetailPatchesTint => 'Tono de las manchas';

  @override
  String get catDetailTint => 'Tono';

  @override
  String get catDetailPoints => 'Puntos';

  @override
  String get catDetailVitiligo => 'Vitiligo';

  @override
  String get catDetailTortoiseshell => 'Carey';

  @override
  String get catDetailTortiePattern => 'Patrón carey';

  @override
  String get catDetailTortieColor => 'Color carey';

  @override
  String get catDetailSkin => 'Piel';

  @override
  String get offlineMessage =>
      'Estás sin conexión — los cambios se sincronizarán cuando te reconectes';

  @override
  String get offlineModeLabel => 'Modo sin conexión';

  @override
  String habitTodayMinutes(int count) {
    return 'Hoy: $count min';
  }

  @override
  String get habitDeleteTooltip => 'Eliminar hábito';

  @override
  String get heatmapActiveDays => 'Días activos';

  @override
  String get heatmapTotal => 'Total';

  @override
  String get heatmapRate => 'Tasa';

  @override
  String get heatmapLess => 'Menos';

  @override
  String get heatmapMore => 'Más';

  @override
  String get accessoryEquipped => 'Equipado';

  @override
  String get accessoryOwned => 'En posesión';

  @override
  String get pickerMinUnit => 'min';

  @override
  String get settingsBackgroundAnimation => 'Fondos animados';

  @override
  String get settingsBackgroundAnimationSubtitle =>
      'Degradado de malla y partículas flotantes';

  @override
  String get settingsUiStyle => 'Estilo de interfaz';

  @override
  String get settingsUiStyleMaterial => 'Material 3';

  @override
  String get settingsUiStyleRetroPixel => 'Retro Pixel';

  @override
  String get settingsUiStyleMaterialSubtitle =>
      'Material Design moderno y redondeado';

  @override
  String get settingsUiStyleRetroPixelSubtitle =>
      'Estética cálida de pixel art';

  @override
  String get personalityLazy => 'Perezoso';

  @override
  String get personalityCurious => 'Curioso';

  @override
  String get personalityPlayful => 'Juguetón';

  @override
  String get personalityShy => 'Tímido';

  @override
  String get personalityBrave => 'Valiente';

  @override
  String get personalityClingy => 'Mimoso';

  @override
  String get personalityFlavorLazy =>
      'Dormirá 23 horas al día. ¿La otra hora? También durmiendo.';

  @override
  String get personalityFlavorCurious =>
      '¡Ya está olfateando todo a su alrededor!';

  @override
  String get personalityFlavorPlayful =>
      '¡No puede dejar de perseguir mariposas!';

  @override
  String get personalityFlavorShy =>
      'Tardó 3 minutos en asomarse de la caja...';

  @override
  String get personalityFlavorBrave =>
      '¡Saltó de la caja antes de que la abrieran!';

  @override
  String get personalityFlavorClingy =>
      'Empezó a ronronear y no quiere soltarte.';

  @override
  String get moodHappy => 'Feliz';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodLonely => 'Solo';

  @override
  String get moodMissing => 'Te extraña';

  @override
  String get moodMsgLazyHappy => 'Nya~! Hora de una siesta bien merecida...';

  @override
  String get moodMsgCuriousHappy => '¿Qué vamos a explorar hoy?';

  @override
  String get moodMsgPlayfulHappy => '¡Nya~! ¡Listo para trabajar!';

  @override
  String get moodMsgShyHappy => '...M-me alegra que estés aquí.';

  @override
  String get moodMsgBraveHappy => '¡Conquistemos el día juntos!';

  @override
  String get moodMsgClingyHappy => '¡Yay! ¡Volviste! ¡No te vayas de nuevo!';

  @override
  String get moodMsgLazyNeutral => '*bostezo* Ah, hola...';

  @override
  String get moodMsgCuriousNeutral => 'Hmm, ¿qué es eso de allá?';

  @override
  String get moodMsgPlayfulNeutral => '¿Jugamos? Tal vez después...';

  @override
  String get moodMsgShyNeutral => '*se asoma lentamente*';

  @override
  String get moodMsgBraveNeutral => 'Montando guardia, como siempre.';

  @override
  String get moodMsgClingyNeutral => 'Te estuve esperando...';

  @override
  String get moodMsgLazyLonely => 'Hasta las siestas se sienten solitarias...';

  @override
  String get moodMsgCuriousLonely => 'Me pregunto cuándo volverás...';

  @override
  String get moodMsgPlayfulLonely => 'Los juguetes no son divertidos sin ti...';

  @override
  String get moodMsgShyLonely => '*se acurruca en silencio*';

  @override
  String get moodMsgBraveLonely => 'Seguiré esperando. Soy valiente.';

  @override
  String get moodMsgClingyLonely => '¿A dónde te fuiste... 🥺';

  @override
  String get moodMsgLazyMissing => '*abre un ojo con esperanza*';

  @override
  String get moodMsgCuriousMissing => '¿Pasó algo...?';

  @override
  String get moodMsgPlayfulMissing => 'Guardé tu juguete favorito...';

  @override
  String get moodMsgShyMissing => '*escondido, pero mirando la puerta*';

  @override
  String get moodMsgBraveMissing => 'Sé que volverás. Yo creo.';

  @override
  String get moodMsgClingyMissing => 'Te extraño mucho... por favor vuelve.';

  @override
  String get peltTypeTabby => 'Rayas tabby clásicas';

  @override
  String get peltTypeTicked => 'Patrón agutí ticked';

  @override
  String get peltTypeMackerel => 'Tabby caballa';

  @override
  String get peltTypeClassic => 'Patrón clásico en espiral';

  @override
  String get peltTypeSokoke => 'Patrón mármol sokoke';

  @override
  String get peltTypeAgouti => 'Agutí ticked';

  @override
  String get peltTypeSpeckled => 'Pelaje moteado';

  @override
  String get peltTypeRosette => 'Manchas en roseta';

  @override
  String get peltTypeSingleColour => 'Color sólido';

  @override
  String get peltTypeTwoColour => 'Bicolor';

  @override
  String get peltTypeSmoke => 'Sombreado humo';

  @override
  String get peltTypeSinglestripe => 'Raya única';

  @override
  String get peltTypeBengal => 'Patrón bengal';

  @override
  String get peltTypeMarbled => 'Patrón marmolado';

  @override
  String get peltTypeMasked => 'Cara enmascarada';

  @override
  String get peltColorWhite => 'Blanco';

  @override
  String get peltColorPaleGrey => 'Gris claro';

  @override
  String get peltColorSilver => 'Plateado';

  @override
  String get peltColorGrey => 'Gris';

  @override
  String get peltColorDarkGrey => 'Gris oscuro';

  @override
  String get peltColorGhost => 'Gris fantasma';

  @override
  String get peltColorBlack => 'Negro';

  @override
  String get peltColorCream => 'Crema';

  @override
  String get peltColorPaleGinger => 'Jengibre claro';

  @override
  String get peltColorGolden => 'Dorado';

  @override
  String get peltColorGinger => 'Jengibre';

  @override
  String get peltColorDarkGinger => 'Jengibre oscuro';

  @override
  String get peltColorSienna => 'Siena';

  @override
  String get peltColorLightBrown => 'Marrón claro';

  @override
  String get peltColorLilac => 'Lila';

  @override
  String get peltColorBrown => 'Marrón';

  @override
  String get peltColorGoldenBrown => 'Marrón dorado';

  @override
  String get peltColorDarkBrown => 'Marrón oscuro';

  @override
  String get peltColorChocolate => 'Chocolate';

  @override
  String get eyeColorYellow => 'Amarillo';

  @override
  String get eyeColorAmber => 'Ámbar';

  @override
  String get eyeColorHazel => 'Avellana';

  @override
  String get eyeColorPaleGreen => 'Verde claro';

  @override
  String get eyeColorGreen => 'Verde';

  @override
  String get eyeColorBlue => 'Azul';

  @override
  String get eyeColorDarkBlue => 'Azul oscuro';

  @override
  String get eyeColorBlueYellow => 'Azul-amarillo';

  @override
  String get eyeColorBlueGreen => 'Azul-verde';

  @override
  String get eyeColorGrey => 'Gris';

  @override
  String get eyeColorCyan => 'Cian';

  @override
  String get eyeColorEmerald => 'Esmeralda';

  @override
  String get eyeColorHeatherBlue => 'Azul brezo';

  @override
  String get eyeColorSunlitIce => 'Hielo soleado';

  @override
  String get eyeColorCopper => 'Cobre';

  @override
  String get eyeColorSage => 'Salvia';

  @override
  String get eyeColorCobalt => 'Cobalto';

  @override
  String get eyeColorPaleBlue => 'Azul claro';

  @override
  String get eyeColorBronze => 'Bronce';

  @override
  String get eyeColorSilver => 'Plateado';

  @override
  String get eyeColorPaleYellow => 'Amarillo claro';

  @override
  String eyeDescNormal(String color) {
    return 'Ojos $color';
  }

  @override
  String eyeDescHeterochromia(String primary, String secondary) {
    return 'Heterocromía ($primary / $secondary)';
  }

  @override
  String get skinColorPink => 'Rosa';

  @override
  String get skinColorRed => 'Rojo';

  @override
  String get skinColorBlack => 'Negro';

  @override
  String get skinColorDark => 'Oscuro';

  @override
  String get skinColorDarkBrown => 'Marrón oscuro';

  @override
  String get skinColorBrown => 'Marrón';

  @override
  String get skinColorLightBrown => 'Marrón claro';

  @override
  String get skinColorDarkGrey => 'Gris oscuro';

  @override
  String get skinColorGrey => 'Gris';

  @override
  String get skinColorDarkSalmon => 'Salmón oscuro';

  @override
  String get skinColorSalmon => 'Salmón';

  @override
  String get skinColorPeach => 'Durazno';

  @override
  String get furLengthLonghair => 'Pelo largo';

  @override
  String get furLengthShorthair => 'Pelo corto';

  @override
  String get whiteTintOffwhite => 'Tono blanco roto';

  @override
  String get whiteTintCream => 'Tono crema';

  @override
  String get whiteTintDarkCream => 'Tono crema oscuro';

  @override
  String get whiteTintGray => 'Tono gris';

  @override
  String get whiteTintPink => 'Tono rosa';

  @override
  String notifReminderTitle(String catName) {
    return '¡$catName te extraña!';
  }

  @override
  String notifReminderBody(String habitName) {
    return 'Es hora de $habitName — ¡tu gato te espera!';
  }

  @override
  String notifStreakTitle(String catName) {
    return '¡$catName está preocupado!';
  }

  @override
  String notifStreakBody(int streak) {
    return 'Tu racha de $streak días está en riesgo. ¡Una sesión rápida la salvará!';
  }

  @override
  String notifEvolutionTitle(String catName) {
    return '¡$catName evolucionó!';
  }

  @override
  String notifEvolutionBody(String catName, String stageName) {
    return '¡$catName creció a $stageName! ¡Sigue así!';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String diaryScreenTitle(String name) {
    return 'Diario de $name';
  }

  @override
  String get diaryFailedToLoad => 'Error al cargar el diario';

  @override
  String get diaryEmptyTitle => 'Aún no hay entradas en el diario';

  @override
  String get diaryEmptyHint =>
      '¡Completa una sesión de enfoque y tu gato escribirá su primera entrada del diario!';

  @override
  String get focusSetupCountdown => 'Cuenta regresiva';

  @override
  String get focusSetupStopwatch => 'Cronómetro';

  @override
  String get focusSetupStartFocus => 'Iniciar enfoque';

  @override
  String get focusSetupQuestNotFound => 'Misión no encontrada';

  @override
  String get checkInButtonLogMore => 'Registrar más tiempo';

  @override
  String get checkInButtonStart => 'Iniciar temporizador';

  @override
  String get adoptionTitleFirst => '¡Adopta tu primer gato!';

  @override
  String get adoptionTitleNew => 'Nueva misión';

  @override
  String get adoptionStepDefineQuest => 'Definir misión';

  @override
  String get adoptionStepAdoptCat2 => 'Adoptar gato';

  @override
  String get adoptionStepNameCat2 => 'Nombrar gato';

  @override
  String get adoptionAdopt => '¡Adoptar!';

  @override
  String get adoptionQuestPrompt => '¿Qué misión quieres comenzar?';

  @override
  String get adoptionKittenHint =>
      '¡Se te asignará un gatito para ayudarte a mantener el ritmo!';

  @override
  String get adoptionQuestName => 'Nombre de la misión';

  @override
  String get adoptionQuestHint => 'ej. Preparar preguntas de entrevista';

  @override
  String get adoptionTotalTarget => 'Meta total (horas)';

  @override
  String get adoptionGrowthHint =>
      'Tu gato crece a medida que acumulas tiempo de enfoque';

  @override
  String get adoptionCustom => 'Personalizado';

  @override
  String get adoptionDailyGoalLabel => 'Meta diaria de enfoque (min)';

  @override
  String get adoptionReminderLabel => 'Recordatorio diario (opcional)';

  @override
  String get adoptionReminderNone => 'Ninguno';

  @override
  String get adoptionCustomGoalTitle => 'Meta diaria personalizada';

  @override
  String get adoptionMinutesPerDay => 'Minutos por día';

  @override
  String get adoptionMinutesHint => '5 - 180';

  @override
  String get adoptionValidMinutes => 'Ingresa un valor entre 5 y 180';

  @override
  String get adoptionCustomTargetTitle => 'Horas objetivo personalizadas';

  @override
  String get adoptionTotalHours => 'Total de horas';

  @override
  String get adoptionHoursHint => '10 - 2000';

  @override
  String get adoptionValidHours => 'Ingresa un valor entre 10 y 2000';

  @override
  String get adoptionSet => 'Establecer';

  @override
  String get adoptionChooseKitten => '¡Elige tu gatito!';

  @override
  String adoptionCompanionFor(String quest) {
    return 'Tu compañero para \"$quest\"';
  }

  @override
  String get adoptionRerollAll => 'Regenerar todos';

  @override
  String get adoptionNameYourCat2 => 'Nombra a tu gato';

  @override
  String get adoptionCatName => 'Nombre del gato';

  @override
  String get adoptionCatHint => 'ej. Mochi';

  @override
  String get adoptionRandomTooltip => 'Nombre aleatorio';

  @override
  String adoptionGrowthTarget(String quest, int hours) {
    return 'Tu gato crecerá mientras te enfocas en \"$quest\". Meta: ${hours}h en total.';
  }

  @override
  String get adoptionValidQuestName => 'Ingresa un nombre para la misión';

  @override
  String get adoptionValidCatName => 'Ponle nombre a tu gato';

  @override
  String adoptionError(String message) {
    return 'Error: $message';
  }

  @override
  String get adoptionBasicInfo => 'Información básica';

  @override
  String get adoptionGoals => 'Metas';

  @override
  String get adoptionUnlimitedMode => 'Modo ilimitado';

  @override
  String get adoptionUnlimitedDesc => 'Sin límite, sigue acumulando';

  @override
  String get adoptionMilestoneMode => 'Modo de meta';

  @override
  String get adoptionMilestoneDesc => 'Establece un objetivo a alcanzar';

  @override
  String get adoptionDeadlineLabel => 'Fecha límite';

  @override
  String get adoptionDeadlineNone => 'No establecida';

  @override
  String get adoptionReminderSection => 'Recordatorio';

  @override
  String get adoptionMotivationLabel => 'Nota';

  @override
  String get adoptionMotivationHint => 'Escribe una nota...';

  @override
  String get adoptionMotivationSwap => 'Rellenar al azar';

  @override
  String get loginAppName => 'Hachimi';

  @override
  String get loginTagline => 'Cría gatos. Completa misiones.';

  @override
  String get loginContinueGoogle => 'Continuar con Google';

  @override
  String get loginContinueEmail => 'Continuar con Email';

  @override
  String get loginAlreadyHaveAccount => '¿Ya tienes una cuenta? ';

  @override
  String get loginLogIn => 'Iniciar sesión';

  @override
  String get loginWelcomeBack => '¡Bienvenido de vuelta!';

  @override
  String get loginCreateAccount => 'Crea tu cuenta';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Contraseña';

  @override
  String get loginConfirmPassword => 'Confirmar contraseña';

  @override
  String get loginValidEmail => 'Ingresa tu email';

  @override
  String get loginValidEmailFormat => 'Ingresa un email válido';

  @override
  String get loginValidPassword => 'Ingresa tu contraseña';

  @override
  String get loginValidPasswordLength =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get loginValidPasswordMatch => 'Las contraseñas no coinciden';

  @override
  String get loginCreateAccountButton => 'Crear cuenta';

  @override
  String get loginNoAccount => '¿No tienes cuenta? ';

  @override
  String get loginRegister => 'Registrarse';

  @override
  String get checkInTitle => 'Registro mensual';

  @override
  String get checkInDays => 'Días';

  @override
  String get checkInCoinsEarned => 'Monedas ganadas';

  @override
  String get checkInAllMilestones => '¡Todas las metas alcanzadas!';

  @override
  String checkInMilestoneProgress(int remaining, int bonus) {
    return '$remaining días más → +$bonus monedas';
  }

  @override
  String get checkInMilestones => 'Metas';

  @override
  String get checkInFullMonth => 'Mes completo';

  @override
  String get checkInRewardSchedule => 'Programa de recompensas';

  @override
  String get checkInWeekday => 'Días de semana (lun–vie)';

  @override
  String checkInWeekdayReward(int coins) {
    return '$coins monedas/día';
  }

  @override
  String get checkInWeekend => 'Fin de semana (sáb–dom)';

  @override
  String checkInNDays(int count) {
    return '$count días';
  }

  @override
  String get onboardTitle1 => 'Conoce a tu compañero';

  @override
  String get onboardSubtitle1 => 'Toda misión comienza con un gatito';

  @override
  String get onboardBody1 =>
      'Establece una meta y adopta un gatito.\n¡Enfócate en ella y mira crecer a tu gato!';

  @override
  String get onboardTitle2 => 'Enfócate, crece, evoluciona';

  @override
  String get onboardSubtitle2 => '4 etapas de crecimiento';

  @override
  String get onboardBody2 =>
      'Cada minuto de enfoque ayuda a tu gato a evolucionar\n¡de un pequeño gatito a un magnífico senior!';

  @override
  String get onboardTitle3 => 'Construye tu CatHouse';

  @override
  String get onboardSubtitle3 => 'Colecciona gatos únicos';

  @override
  String get onboardBody3 =>
      'Cada misión trae un nuevo gato con apariencia única.\n¡Descúbrelos todos y arma tu colección soñada!';

  @override
  String get onboardSkip => 'Omitir';

  @override
  String get onboardLetsGo => '¡Vamos!';

  @override
  String get onboardNext => 'Siguiente';

  @override
  String get catRoomTitle => 'CatHouse';

  @override
  String get catRoomInventory => 'Inventario';

  @override
  String get catRoomShop => 'Tienda de accesorios';

  @override
  String get catRoomLoadError => 'Error al cargar gatos';

  @override
  String get catRoomEmptyTitle => 'Tu CatHouse está vacía';

  @override
  String get catRoomEmptySubtitle =>
      '¡Inicia una misión para adoptar tu primer gato!';

  @override
  String get catRoomEditQuest => 'Editar misión';

  @override
  String get catRoomRenameCat => 'Renombrar gato';

  @override
  String get catRoomArchiveCat => 'Archivar gato';

  @override
  String get catRoomNewName => 'Nuevo nombre';

  @override
  String get catRoomRename => 'Renombrar';

  @override
  String get catRoomArchiveTitle => '¿Archivar gato?';

  @override
  String catRoomArchiveMessage(String name) {
    return 'Esto archivará a \"$name\" y eliminará su misión vinculada. El gato seguirá apareciendo en tu álbum.';
  }

  @override
  String get catRoomArchive => 'Archivar';

  @override
  String catRoomAlbumSection(int count) {
    return 'Álbum ($count)';
  }

  @override
  String get catRoomReactivateCat => 'Reactivar gato';

  @override
  String get catRoomReactivateTitle => '¿Reactivar gato?';

  @override
  String catRoomReactivateMessage(String name) {
    return 'Esto restaurará a \"$name\" y su misión vinculada en el CatHouse.';
  }

  @override
  String get catRoomReactivate => 'Reactivar';

  @override
  String get catRoomArchivedLabel => 'Archivado';

  @override
  String catRoomArchiveSuccess(String name) {
    return '\"$name\" archivado';
  }

  @override
  String catRoomReactivateSuccess(String name) {
    return '\"$name\" reactivado';
  }

  @override
  String get addHabitTitle => 'Nueva misión';

  @override
  String get addHabitQuestName => 'Nombre de la misión';

  @override
  String get addHabitQuestHint => 'ej. Práctica de LeetCode';

  @override
  String get addHabitValidName => 'Ingresa un nombre para la misión';

  @override
  String get addHabitTargetHours => 'Horas objetivo';

  @override
  String get addHabitTargetHint => 'ej. 100';

  @override
  String get addHabitValidTarget => 'Ingresa las horas objetivo';

  @override
  String get addHabitValidNumber => 'Ingresa un número válido';

  @override
  String get addHabitCreate => 'Crear misión';

  @override
  String get addHabitHoursSuffix => 'horas';

  @override
  String shopTabPlants(int count) {
    return 'Plantas ($count)';
  }

  @override
  String shopTabWild(int count) {
    return 'Silvestre ($count)';
  }

  @override
  String shopTabCollars(int count) {
    return 'Collares ($count)';
  }

  @override
  String get shopNoAccessories => 'No hay accesorios disponibles';

  @override
  String shopBuyConfirm(String name) {
    return '¿Comprar $name?';
  }

  @override
  String get shopPurchaseButton => 'Comprar';

  @override
  String get shopNotEnoughCoinsButton => 'Monedas insuficientes';

  @override
  String shopPurchaseSuccess(String name) {
    return '¡Comprado! $name agregado al inventario';
  }

  @override
  String shopPurchaseFailed(int price) {
    return 'Monedas insuficientes (necesitas $price)';
  }

  @override
  String get inventoryTitle => 'Inventario';

  @override
  String inventoryInBox(int count) {
    return 'En la caja ($count)';
  }

  @override
  String get inventoryEmpty =>
      'Tu inventario está vacío.\n¡Visita la tienda para conseguir accesorios!';

  @override
  String inventoryEquippedOnCats(int count) {
    return 'Equipados en gatos ($count)';
  }

  @override
  String get inventoryNoEquipped => 'Ningún accesorio equipado en algún gato.';

  @override
  String get inventoryUnequip => 'Desequipar';

  @override
  String get inventoryNoActiveCats => 'No hay gatos activos';

  @override
  String inventoryEquipTo(String name) {
    return 'Equipar $name a:';
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
  String get chatCatNotFound => 'Gato no encontrado';

  @override
  String chatTitle(String name) {
    return 'Chat con $name';
  }

  @override
  String get chatClearHistory => 'Borrar historial';

  @override
  String chatEmptyTitle(String name) {
    return '¡Saluda a $name!';
  }

  @override
  String get chatEmptySubtitle =>
      'Inicia una conversación con tu gato. ¡Responderá según su personalidad!';

  @override
  String get chatGenerating => 'Generando...';

  @override
  String get chatTypeMessage => 'Escribe un mensaje...';

  @override
  String get chatClearConfirmTitle => '¿Borrar historial de chat?';

  @override
  String get chatClearConfirmMessage =>
      'Esto eliminará todos los mensajes. No se puede deshacer.';

  @override
  String get chatClearButton => 'Borrar';

  @override
  String diaryTitle(String name) {
    return 'Diario de $name';
  }

  @override
  String get diaryLoadFailed => 'Error al cargar el diario';

  @override
  String get diaryRetry => 'Reintentar';

  @override
  String get diaryEmptyTitle2 => 'Aún no hay entradas en el diario';

  @override
  String get diaryEmptySubtitle =>
      '¡Completa una sesión de enfoque y tu gato escribirá su primera entrada del diario!';

  @override
  String get statsTitle => 'Estadísticas';

  @override
  String get statsTotalHours => 'Horas totales';

  @override
  String statsTimeValue(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get statsBestStreak => 'Mejor racha';

  @override
  String statsStreakDays(int count) {
    return '$count días';
  }

  @override
  String get statsOverallProgress => 'Progreso general';

  @override
  String statsPercentOfGoals(String percent) {
    return '$percent% de todas las metas';
  }

  @override
  String get statsPerQuestProgress => 'Progreso por misión';

  @override
  String get statsQuestLoadError => 'Error al cargar estadísticas de misiones';

  @override
  String get statsNoQuestData => 'Aún no hay datos de misiones';

  @override
  String get statsNoQuestHint =>
      '¡Inicia una misión para ver tu progreso aquí!';

  @override
  String get statsLast30Days => 'Últimos 30 días';

  @override
  String get habitDetailQuestNotFound => 'Misión no encontrada';

  @override
  String get habitDetailComplete => 'completo';

  @override
  String get habitDetailTotalTime => 'Tiempo total';

  @override
  String get habitDetailCurrentStreak => 'Racha actual';

  @override
  String get habitDetailTarget => 'Meta';

  @override
  String habitDetailDaysUnit(int count) {
    return '$count días';
  }

  @override
  String habitDetailHoursUnit(int count) {
    return '$count horas';
  }

  @override
  String checkInBannerSuccess(int coins) {
    return '+$coins monedas. Registro diario completado';
  }

  @override
  String checkInBannerBonus(int bonus) {
    return ' + $bonus bonus de meta';
  }

  @override
  String get checkInBannerSemantics => 'Registro diario';

  @override
  String get checkInBannerLoading => 'Cargando estado del registro...';

  @override
  String checkInBannerPrompt(int coins) {
    return 'Regístrate por +$coins monedas';
  }

  @override
  String checkInBannerSummary(int count, int total, int coins) {
    return '$count/$total días  ·  +$coins hoy';
  }

  @override
  String commonErrorWithDetail(String error) {
    return 'Error: $error';
  }

  @override
  String get profileFallbackUser => 'Usuario';

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
  String get notifFocusing => 'enfocando...';

  @override
  String get notifInProgress => 'Sesión de enfoque en curso';

  @override
  String get unitMinShort => 'min';

  @override
  String get unitHourShort => 'h';

  @override
  String get weekdayMon => 'L';

  @override
  String get weekdayTue => 'M';

  @override
  String get weekdayWed => 'X';

  @override
  String get weekdayThu => 'J';

  @override
  String get weekdayFri => 'V';

  @override
  String get weekdaySat => 'S';

  @override
  String get weekdaySun => 'D';

  @override
  String get statsTotalSessions => 'Sesiones';

  @override
  String get statsTotalHabits => 'Hábitos';

  @override
  String get statsActiveDays => 'Días activos';

  @override
  String get statsWeeklyTrend => 'Tendencia semanal';

  @override
  String get statsRecentSessions => 'Enfoque reciente';

  @override
  String get statsViewAllHistory => 'Ver todo el historial';

  @override
  String get historyTitle => 'Historial de enfoque';

  @override
  String get historyFilterAll => 'Todo';

  @override
  String historySessionCount(int count) {
    return '$count sesiones';
  }

  @override
  String historyTotalMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get historyNoSessions => 'Aún no hay registros de enfoque';

  @override
  String get historyNoSessionsHint =>
      'Completa una sesión de enfoque para verla aquí';

  @override
  String get historyLoadMore => 'Cargar más';

  @override
  String get sessionCompleted => 'Completada';

  @override
  String get sessionAbandoned => 'Abandonada';

  @override
  String get sessionInterrupted => 'Interrumpida';

  @override
  String get sessionCountdown => 'Cuenta regresiva';

  @override
  String get sessionStopwatch => 'Cronómetro';

  @override
  String get historyDateGroupToday => 'Hoy';

  @override
  String get historyDateGroupYesterday => 'Ayer';

  @override
  String get historyLoadError => 'Error al cargar historial';

  @override
  String get historySelectMonth => 'Seleccionar mes';

  @override
  String get historyAllMonths => 'Todos los meses';

  @override
  String get historyAllHabits => 'Todos';

  @override
  String get homeTabAchievements => 'Logros';

  @override
  String get achievementTitle => 'Logros';

  @override
  String get achievementTabOverview => 'Resumen';

  @override
  String get achievementTabQuest => 'Misión';

  @override
  String get achievementTabStreak => 'Racha';

  @override
  String get achievementTabCat => 'Gato';

  @override
  String get achievementTabPersist => 'Constancia';

  @override
  String get achievementSummaryTitle => 'Progreso de logros';

  @override
  String achievementUnlockedCount(int count) {
    return '$count desbloqueados';
  }

  @override
  String achievementTotalCoins(int coins) {
    return '$coins monedas ganadas';
  }

  @override
  String get achievementUnlocked => '¡Logro desbloqueado!';

  @override
  String get achievementAwesome => '¡Genial!';

  @override
  String get achievementIncredible => '¡Increíble!';

  @override
  String get achievementHidden => '???';

  @override
  String get achievementHiddenDesc => 'Este es un logro oculto';

  @override
  String achievementPersistDesc(int days) {
    return 'Acumula $days días de registro en cualquier misión';
  }

  @override
  String achievementTitleCount(int count) {
    return '$count títulos desbloqueados';
  }

  @override
  String get growthPathTitle => 'Camino de crecimiento';

  @override
  String get growthPathKitten => 'Inicia un nuevo camino';

  @override
  String get growthPathAdolescent => 'Construye las bases';

  @override
  String get growthPathAdult => 'Las habilidades se consolidan';

  @override
  String get growthPathSenior => 'Dominio profundo';

  @override
  String get growthPathTip =>
      'Investigaciones muestran que 20 horas de práctica enfocada son suficientes para construir las bases de una nueva habilidad — Josh Kaufman';

  @override
  String achievementCelebrationCoins(int count) {
    return '+$count monedas';
  }

  @override
  String achievementCelebrationTitle(String title) {
    return 'Título ganado: $title';
  }

  @override
  String get achievementCelebrationDismiss => '¡Genial!';

  @override
  String get achievementCelebrationSkipAll => 'Omitir todo';

  @override
  String achievementCelebrationCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String achievementUnlockedAt(String date) {
    return 'Desbloqueado el $date';
  }

  @override
  String get achievementLocked => 'Aún no desbloqueado';

  @override
  String achievementRewardCoins(int count) {
    return '+$count monedas';
  }

  @override
  String get reminderModeDaily => 'Todos los días';

  @override
  String get reminderModeWeekdays => 'Días de semana';

  @override
  String get reminderModeMonday => 'Lunes';

  @override
  String get reminderModeTuesday => 'Martes';

  @override
  String get reminderModeWednesday => 'Miércoles';

  @override
  String get reminderModeThursday => 'Jueves';

  @override
  String get reminderModeFriday => 'Viernes';

  @override
  String get reminderModeSaturday => 'Sábado';

  @override
  String get reminderModeSunday => 'Domingo';

  @override
  String get reminderPickerTitle => 'Seleccionar hora del recordatorio';

  @override
  String get reminderHourUnit => 'h';

  @override
  String get reminderMinuteUnit => 'min';

  @override
  String get reminderAddMore => 'Agregar recordatorio';

  @override
  String get reminderMaxReached => 'Máximo 5 recordatorios';

  @override
  String get reminderConfirm => 'Confirmar';

  @override
  String reminderNotificationTitle(String catName) {
    return '¡$catName te extraña!';
  }

  @override
  String reminderNotificationBody(String habitName) {
    return 'Es hora de $habitName — ¡tu gato te espera!';
  }

  @override
  String get deleteAccountDataWarning =>
      'Todos los siguientes datos se eliminarán permanentemente:';

  @override
  String get deleteAccountQuests => 'Misiones';

  @override
  String get deleteAccountCats => 'Gatos';

  @override
  String get deleteAccountHours => 'Horas de enfoque';

  @override
  String get deleteAccountIrreversible => 'Esta acción es irreversible';

  @override
  String get deleteAccountContinue => 'Continuar';

  @override
  String get deleteAccountConfirmTitle => 'Confirmar eliminación';

  @override
  String get deleteAccountTypeDelete =>
      'Escribe DELETE para confirmar la eliminación de tu cuenta:';

  @override
  String get deleteAccountAuthCancelled => 'Autenticación cancelada';

  @override
  String deleteAccountAuthFailed(String error) {
    return 'Error de autenticación: $error';
  }

  @override
  String get deleteAccountProgress => 'Eliminando cuenta...';

  @override
  String get deleteAccountSuccess => 'Cuenta eliminada';

  @override
  String get drawerGuestLoginSubtitle =>
      'Sincroniza datos y desbloquea funciones de IA';

  @override
  String get drawerGuestSignIn => 'Iniciar sesión';

  @override
  String get drawerMilestones => 'Metas';

  @override
  String drawerMilestoneFocus(int hours, int minutes) {
    return 'Enfoque total: ${hours}h ${minutes}m';
  }

  @override
  String drawerMilestoneCats(int count) {
    return 'Familia de gatos: $count';
  }

  @override
  String drawerMilestoneQuests(int count) {
    return 'Misiones activas: $count';
  }

  @override
  String get drawerMySection => 'Mi';

  @override
  String get drawerSessionHistory => 'Historial de enfoque';

  @override
  String get drawerCheckInCalendar => 'Calendario de registros';

  @override
  String get drawerAccountSection => 'Cuenta';

  @override
  String get settingsResetData => 'Reiniciar todos los datos';

  @override
  String get settingsResetDataTitle => '¿Reiniciar todos los datos?';

  @override
  String get settingsResetDataMessage =>
      'Esto eliminará todos los datos locales y volverás a la pantalla de bienvenida. No se puede deshacer.';

  @override
  String get guestUpgradeTitle => 'Protege tus datos';

  @override
  String get guestUpgradeMessage =>
      'Vincula una cuenta para respaldar tu progreso, desbloquear el diario IA y las funciones de chat, y sincronizar entre dispositivos.';

  @override
  String get guestUpgradeLinkButton => 'Vincular cuenta';

  @override
  String get guestUpgradeLater => 'Tal vez después';

  @override
  String get loginLinkTagline => 'Vincula una cuenta para proteger tus datos';

  @override
  String get aiTeaserTitle => 'Diario del gato';

  @override
  String aiTeaserPreview(String catName) {
    return 'Hoy estudié con mi humano otra vez... $catName se siente más inteligente cada día~';
  }

  @override
  String aiTeaserCta(String catName) {
    return 'Vincula una cuenta para ver qué quiere decir $catName';
  }

  @override
  String get authErrorEmailInUse => 'Este email ya está registrado';

  @override
  String get authErrorWrongPassword => 'Email o contraseña incorrectos';

  @override
  String get authErrorUserNotFound =>
      'No se encontró ninguna cuenta con este email';

  @override
  String get authErrorTooManyRequests =>
      'Demasiados intentos. Intenta más tarde';

  @override
  String get authErrorNetwork => 'Error de red. Revisa tu conexión';

  @override
  String get authErrorAdminRestricted =>
      'El inicio de sesión está temporalmente restringido';

  @override
  String get authErrorWeakPassword =>
      'La contraseña es muy débil. Usa al menos 6 caracteres';

  @override
  String get authErrorGeneric => 'Algo salió mal. Intenta de nuevo';

  @override
  String get deleteAccountReauthEmail => 'Ingresa tu contraseña para continuar';

  @override
  String get deleteAccountReauthPasswordHint => 'Contraseña';

  @override
  String get deleteAccountError => 'Algo salió mal. Intenta más tarde.';

  @override
  String get deleteAccountPermissionError =>
      'Error de permisos. Intenta cerrar sesión y volver a entrar.';

  @override
  String get deleteAccountNetworkError =>
      'Sin conexión a internet. Revisa tu red.';

  @override
  String get deleteAccountRetainedData =>
      'Los análisis de uso y reportes de errores no pueden ser eliminados.';

  @override
  String get deleteAccountStepCloud => 'Eliminando datos en la nube...';

  @override
  String get deleteAccountStepLocal => 'Limpiando datos locales...';

  @override
  String get deleteAccountStepDone => 'Completado';

  @override
  String get deleteAccountQueued =>
      'Datos locales eliminados. La eliminación de la cuenta en la nube está en cola y finalizará cuando estés en línea.';

  @override
  String get deleteAccountPending =>
      'La eliminación de la cuenta está pendiente. Mantén la app en línea para completar la eliminación en la nube y la autenticación.';

  @override
  String get deleteAccountAbandon => 'Empezar de nuevo';

  @override
  String get archiveConflictTitle => 'Elige qué archivo conservar';

  @override
  String get archiveConflictMessage =>
      'Tanto el archivo local como el de la nube tienen datos. Elige uno para conservar:';

  @override
  String get archiveConflictLocal => 'Archivo local';

  @override
  String get archiveConflictCloud => 'Archivo en la nube';

  @override
  String get archiveConflictKeepCloud => 'Conservar nube';

  @override
  String get archiveConflictKeepLocal => 'Conservar local';

  @override
  String get loginShowPassword => 'Mostrar contraseña';

  @override
  String get loginHidePassword => 'Ocultar contraseña';

  @override
  String get errorGeneric => 'Algo salió mal. Intenta más tarde';

  @override
  String get errorCreateHabit => 'Error al crear el hábito. Intenta de nuevo';

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
