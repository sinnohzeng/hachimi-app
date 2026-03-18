import 'package:hachimi_app/l10n/app_localizations.dart';

/// 提醒模式枚举。
enum ReminderMode {
  daily('daily'),
  weekdays('weekdays'),
  monday('monday'),
  tuesday('tuesday'),
  wednesday('wednesday'),
  thursday('thursday'),
  friday('friday'),
  saturday('saturday'),
  sunday('sunday');

  const ReminderMode(this.value);
  final String value;

  static ReminderMode? tryFromValue(String value) {
    for (final mode in values) {
      if (mode.value == value) return mode;
    }
    return null;
  }

  /// mode → DateTime.weekday (1=Monday ... 7=Sunday)。
  /// 仅对具体星期有效，daily 和 weekdays 返回 null。
  int? get weekday => switch (this) {
    monday => DateTime.monday,
    tuesday => DateTime.tuesday,
    wednesday => DateTime.wednesday,
    thursday => DateTime.thursday,
    friday => DateTime.friday,
    saturday => DateTime.saturday,
    sunday => DateTime.sunday,
    _ => null,
  };

  /// 获取本地化名称。
  String localizedName(S l10n) => switch (this) {
    daily => l10n.reminderModeDaily,
    weekdays => l10n.reminderModeWeekdays,
    monday => l10n.reminderModeMonday,
    tuesday => l10n.reminderModeTuesday,
    wednesday => l10n.reminderModeWednesday,
    thursday => l10n.reminderModeThursday,
    friday => l10n.reminderModeFriday,
    saturday => l10n.reminderModeSaturday,
    sunday => l10n.reminderModeSunday,
  };
}

/// 提醒配置数据模型。
/// 每个 ReminderConfig 表示一条提醒规则：模式 + 时间。
class ReminderConfig {
  final ReminderMode mode;

  /// 小时（0-23）
  final int hour;

  /// 分钟（0-59）
  final int minute;

  const ReminderConfig({
    required this.mode,
    required this.hour,
    required this.minute,
  });

  /// mode → DateTime.weekday (1=Monday ... 7=Sunday)。
  int? get weekday => mode.weekday;

  /// 格式化时间部分为 "HH:mm"。
  String get timeString =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  Map<String, dynamic> toMap() => {
    'mode': mode.value,
    'hour': hour,
    'minute': minute,
  };

  factory ReminderConfig.fromMap(Map<String, dynamic> map) => ReminderConfig(
    mode: ReminderMode.tryFromValue(map['mode'] as String) ?? ReminderMode.daily,
    hour: map['hour'] as int,
    minute: map['minute'] as int,
  );

  /// 防御性解析 — 无效数据返回 null（调用方用 whereType 过滤）。
  static ReminderConfig? tryFromMap(Map<String, dynamic> map) {
    final modeStr = map['mode'];
    final hour = map['hour'];
    final minute = map['minute'];
    if (modeStr is! String || hour is! int || minute is! int) return null;
    final mode = ReminderMode.tryFromValue(modeStr);
    if (mode == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return ReminderConfig(mode: mode, hour: hour, minute: minute);
  }

  /// 获取 mode 的本地化名称（兼容旧代码传入 String mode 的场景）。
  static String localizedModeName(String modeStr, S l10n) {
    final mode = ReminderMode.tryFromValue(modeStr);
    return mode?.localizedName(l10n) ?? modeStr;
  }

  /// 获取完整的本地化描述（如 "每天 08:30"）。
  String localizedDescription(S l10n) =>
      '${mode.localizedName(l10n)} $timeString';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderConfig &&
          mode == other.mode &&
          hour == other.hour &&
          minute == other.minute;

  @override
  int get hashCode => Object.hash(mode, hour, minute);

  @override
  String toString() => 'ReminderConfig(${mode.value}, $timeString)';
}
