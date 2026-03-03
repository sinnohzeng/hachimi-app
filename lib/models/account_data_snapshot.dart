/// 用户存档摘要，用于本地/云端冲突对比。
class AccountDataSnapshot {
  final int focusMinutes;
  final int achievements;
  final int cats;
  final int habits;
  final int coins;

  const AccountDataSnapshot({
    this.focusMinutes = 0,
    this.achievements = 0,
    this.cats = 0,
    this.habits = 0,
    this.coins = 0,
  });

  bool get isEmpty {
    final total = focusMinutes + achievements + cats + habits + coins;
    return total == 0;
  }

  int get focusHours => focusMinutes ~/ 60;
}

enum ArchiveConflictChoice { keepLocal, keepCloud }
