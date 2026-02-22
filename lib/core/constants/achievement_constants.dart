import 'package:flutter/material.dart';
import 'package:hachimi_app/models/achievement.dart';

/// Achievement System Constants — Single Source of Truth for all 163 achievement definitions.
/// See docs/architecture/achievement-system.md for the full specification.

// ─── 称号 ID 常量 ───

class AchievementTitles {
  AchievementTitles._();

  static const String marathonCat = 'title_marathon_cat';
  static const String perseveranceStar = 'title_perseverance_star';
  static const String centurion = 'title_centurion';
  static const String catYear = 'title_cat_year';
  static const String elderCat = 'title_elder_cat';
  static const String unbreakable = 'title_unbreakable';
  static const String fourSeasons = 'title_four_seasons';
  static const String speedOfLight = 'title_speed_of_light';
  static const String thousandHours = 'title_thousand_hours';
  static const String aheadOfTime = 'title_ahead_of_time';

  static const List<String> all = [
    marathonCat,
    perseveranceStar,
    centurion,
    catYear,
    elderCat,
    unbreakable,
    fourSeasons,
    speedOfLight,
    thousandHours,
    aheadOfTime,
  ];
}

// ─── 成就分类常量 ───

class AchievementCategory {
  AchievementCategory._();

  static const String quest = 'quest';
  static const String cat = 'cat';
  static const String persist = 'persist';

  static const List<String> all = [quest, cat, persist];
}

// ─── 坚持成就数据表 (days, coins, titleReward?, isHidden?) ───

const List<(int, int, String?, bool)> _persistData = [
  (1, 10, null, false),
  (2, 10, null, false),
  (3, 15, null, false),
  (4, 15, null, false),
  (5, 20, null, false),
  (6, 20, null, false),
  (7, 30, null, false),
  (8, 30, null, false),
  (9, 30, null, false),
  (10, 35, null, false),
  (11, 35, null, false),
  (12, 35, null, false),
  (13, 40, null, false),
  (14, 50, null, false),
  (15, 50, null, false),
  (16, 50, null, false),
  (17, 50, null, false),
  (18, 55, null, false),
  (19, 55, null, false),
  (20, 60, null, false),
  (21, 70, null, false),
  (22, 70, null, false),
  (23, 70, null, false),
  (24, 75, null, false),
  (25, 80, null, false),
  (26, 80, null, false),
  (27, 80, null, false),
  (28, 85, null, false),
  (29, 85, null, false),
  (30, 100, null, false),
  (31, 100, null, false),
  (32, 100, null, false),
  (33, 100, null, false),
  (35, 110, null, false),
  (36, 110, null, false),
  (38, 120, null, false),
  (41, 120, null, false),
  (42, 120, null, false),
  (44, 130, null, false),
  (45, 130, null, false),
  (47, 130, null, false),
  (48, 130, null, false),
  (50, 150, null, false),
  (51, 150, null, false),
  (52, 150, null, false),
  (53, 150, null, false),
  (54, 150, null, false),
  (59, 170, null, false),
  (60, 170, null, false),
  (64, 180, null, false),
  (69, 190, null, false),
  (71, 200, null, false),
  (72, 200, null, false),
  (73, 200, null, false),
  (76, 210, null, false),
  (77, 210, null, false),
  (78, 210, null, false),
  (79, 220, null, false),
  (80, 220, null, false),
  (81, 220, null, false),
  (84, 230, null, false),
  (85, 230, null, false),
  (86, 230, null, false),
  (88, 240, null, false),
  (90, 250, null, false),
  (91, 250, null, false),
  (92, 250, null, false),
  (95, 260, null, false),
  (99, 270, null, false),
  (100, 300, AchievementTitles.unbreakable, false),
  (101, 300, null, false),
  (108, 320, null, false),
  (112, 330, null, false),
  (116, 340, null, false),
  (120, 350, null, false),
  (122, 350, null, false),
  (125, 360, null, false),
  (128, 380, null, false),
  (135, 390, null, false),
  (137, 400, null, false),
  (144, 420, null, false),
  (146, 430, null, false),
  (150, 450, null, false),
  (151, 450, null, false),
  (155, 460, null, false),
  (165, 480, null, false),
  (167, 490, null, false),
  (168, 500, null, false),
  (175, 510, null, false),
  (180, 530, null, false),
  (193, 560, null, false),
  (197, 570, null, false),
  (206, 600, null, false),
  (214, 620, null, false),
  (225, 650, null, false),
  (240, 680, null, false),
  (243, 690, null, false),
  (249, 700, null, false),
  (250, 720, null, false),
  (255, 730, null, false),
  (260, 740, null, false),
  (277, 780, null, false),
  (280, 790, null, false),
  (282, 800, null, false),
  (287, 810, null, false),
  (293, 820, null, false),
  (294, 830, null, false),
  (305, 850, null, false),
  (314, 880, null, false),
  (322, 900, null, false),
  (324, 910, null, false),
  (333, 930, null, false),
  (360, 960, null, false),
  (361, 970, null, false),
  (365, 1000, AchievementTitles.fourSeasons, false),
  (366, 1010, null, false),
  (382, 1050, null, false),
  (400, 1100, null, false),
  (403, 1100, null, false),
  (404, 1110, null, false),
  (410, 1120, null, false),
  (419, 1130, null, false),
  (437, 1150, null, false),
  (500, 1200, null, false),
  (507, 1210, null, false),
  (512, 1230, null, false),
  (520, 1250, null, false),
  (525, 1260, null, false),
  (527, 1270, null, false),
  (601, 1350, null, false),
  (666, 1400, null, false),
  (687, 1450, null, false),
  (828, 1600, null, false),
  (878, 1650, null, false),
  (930, 1700, null, false),
  (1420, 2200, null, false),
  (2997, 2997, AchievementTitles.speedOfLight, true),
];

// ─── 全部成就定义 ───

class AchievementDefinitions {
  AchievementDefinitions._();

  // ─── 任务成就 (Quest, 8 个) ───

  static const List<AchievementDef> questAchievements = [
    AchievementDef(
      id: 'quest_first_session',
      category: AchievementCategory.quest,
      nameKey: 'achievementQuestFirstSessionName',
      descKey: 'achievementQuestFirstSessionDesc',
      icon: Icons.star_outline,
      coinReward: 50,
    ),
    AchievementDef(
      id: 'quest_100_sessions',
      category: AchievementCategory.quest,
      nameKey: 'achievementQuest100SessionsName',
      descKey: 'achievementQuest100SessionsDesc',
      icon: Icons.workspace_premium,
      targetValue: 100,
      coinReward: 200,
    ),
    AchievementDef(
      id: 'quest_3_habits',
      category: AchievementCategory.quest,
      nameKey: 'achievementQuest3HabitsName',
      descKey: 'achievementQuest3HabitsDesc',
      icon: Icons.format_list_numbered,
      targetValue: 3,
      coinReward: 100,
    ),
    AchievementDef(
      id: 'quest_5_habits',
      category: AchievementCategory.quest,
      nameKey: 'achievementQuest5HabitsName',
      descKey: 'achievementQuest5HabitsDesc',
      icon: Icons.view_list,
      targetValue: 5,
      coinReward: 200,
    ),
    AchievementDef(
      id: 'quest_all_done',
      category: AchievementCategory.quest,
      nameKey: 'achievementQuestAllDoneName',
      descKey: 'achievementQuestAllDoneDesc',
      icon: Icons.done_all,
      coinReward: 80,
    ),
    AchievementDef(
      id: 'quest_5_workdays',
      category: AchievementCategory.quest,
      nameKey: 'achievementQuest5WorkdaysName',
      descKey: 'achievementQuest5WorkdaysDesc',
      icon: Icons.work_outline,
      targetValue: 5,
      coinReward: 150,
    ),
    AchievementDef(
      id: 'quest_first_checkin',
      category: AchievementCategory.quest,
      nameKey: 'achievementQuestFirstCheckinName',
      descKey: 'achievementQuestFirstCheckinDesc',
      icon: Icons.how_to_reg,
      coinReward: 30,
    ),
    AchievementDef(
      id: 'quest_marathon',
      category: AchievementCategory.quest,
      nameKey: 'achievementQuestMarathonName',
      descKey: 'achievementQuestMarathonDesc',
      icon: Icons.timer,
      targetValue: 120,
      coinReward: 300,
      titleReward: AchievementTitles.marathonCat,
    ),
  ];

  // ─── 累计小时成就 (Hours, 4 个) ───

  static const List<AchievementDef> hoursAchievements = [
    AchievementDef(
      id: 'hours_100',
      category: AchievementCategory.quest,
      nameKey: 'achievementHours100Name',
      descKey: 'achievementHours100Desc',
      icon: Icons.military_tech,
      targetValue: 6000, // 100h = 6000min
      coinReward: 300,
      titleReward: AchievementTitles.centurion,
    ),
    AchievementDef(
      id: 'hours_1000',
      category: AchievementCategory.quest,
      nameKey: 'achievementHours1000Name',
      descKey: 'achievementHours1000Desc',
      icon: Icons.auto_awesome,
      targetValue: 60000, // 1000h = 60000min
      coinReward: 1000,
      titleReward: AchievementTitles.thousandHours,
      isHidden: true,
    ),
    AchievementDef(
      id: 'goal_on_time',
      category: AchievementCategory.quest,
      nameKey: 'achievementGoalOnTimeName',
      descKey: 'achievementGoalOnTimeDesc',
      icon: Icons.flag,
      coinReward: 200,
    ),
    AchievementDef(
      id: 'goal_ahead',
      category: AchievementCategory.quest,
      nameKey: 'achievementGoalAheadName',
      descKey: 'achievementGoalAheadDesc',
      icon: Icons.rocket_launch,
      coinReward: 500,
      titleReward: AchievementTitles.aheadOfTime,
    ),
  ];

  // ─── 猫咪成就 (Cat, 9 个) ───

  static const List<AchievementDef> catAchievements = [
    AchievementDef(
      id: 'cat_first_adopt',
      category: AchievementCategory.cat,
      nameKey: 'achievementCatFirstAdoptName',
      descKey: 'achievementCatFirstAdoptDesc',
      icon: Icons.pets,
      coinReward: 30,
    ),
    AchievementDef(
      id: 'cat_3_adopted',
      category: AchievementCategory.cat,
      nameKey: 'achievementCat3AdoptedName',
      descKey: 'achievementCat3AdoptedDesc',
      icon: Icons.groups,
      targetValue: 3,
      coinReward: 100,
    ),
    AchievementDef(
      id: 'cat_adolescent',
      category: AchievementCategory.cat,
      nameKey: 'achievementCatAdolescentName',
      descKey: 'achievementCatAdolescentDesc',
      icon: Icons.trending_up,
      coinReward: 50,
    ),
    AchievementDef(
      id: 'cat_adult',
      category: AchievementCategory.cat,
      nameKey: 'achievementCatAdultName',
      descKey: 'achievementCatAdultDesc',
      icon: Icons.emoji_events,
      coinReward: 100,
    ),
    AchievementDef(
      id: 'cat_senior', // 保留 ID 以兼容已解锁用户
      category: AchievementCategory.cat,
      nameKey: 'achievementCatSeniorName',
      descKey: 'achievementCatSeniorDesc',
      icon: Icons.emoji_events,
      coinReward: 200,
      titleReward: AchievementTitles.elderCat,
    ),
    AchievementDef(
      id: 'cat_graduated',
      category: AchievementCategory.cat,
      nameKey: 'achievementCatGraduatedName',
      descKey: 'achievementCatGraduatedDesc',
      icon: Icons.school,
      coinReward: 150,
    ),
    AchievementDef(
      id: 'cat_accessory',
      category: AchievementCategory.cat,
      nameKey: 'achievementCatAccessoryName',
      descKey: 'achievementCatAccessoryDesc',
      icon: Icons.checkroom,
      coinReward: 30,
    ),
    AchievementDef(
      id: 'cat_5_accessories',
      category: AchievementCategory.cat,
      nameKey: 'achievementCat5AccessoriesName',
      descKey: 'achievementCat5AccessoriesDesc',
      icon: Icons.style,
      targetValue: 5,
      coinReward: 100,
    ),
    AchievementDef(
      id: 'cat_all_happy',
      category: AchievementCategory.cat,
      nameKey: 'achievementCatAllHappyName',
      descKey: 'achievementCatAllHappyDesc',
      icon: Icons.mood,
      coinReward: 80,
    ),
  ];

  // ─── 单项目坚持成就 (Persist, 138 个) ───

  static final List<AchievementDef> persistAchievements = _persistData
      .map(
        (r) => AchievementDef(
          id: 'persist_${r.$1}',
          category: AchievementCategory.persist,
          nameKey: 'achievementPersist${r.$1}Name',
          descKey: 'achievementPersistDesc',
          icon: r.$4 ? Icons.auto_awesome : Icons.emoji_events_outlined,
          targetValue: r.$1,
          coinReward: r.$2,
          titleReward: r.$3,
          isHidden: r.$4,
        ),
      )
      .toList(growable: false);

  /// 所有成就列表
  static final List<AchievementDef> all = [
    ...questAchievements,
    ...hoursAchievements,
    ...catAchievements,
    ...persistAchievements,
  ];

  /// 按 ID 查找
  static final Map<String, AchievementDef> _byId = {
    for (final def in all) def.id: def,
  };

  static AchievementDef? byId(String id) => _byId[id];

  /// 按分类查找
  static List<AchievementDef> byCategory(String category) =>
      all.where((d) => d.category == category).toList();

  /// 总数
  static int get totalCount => all.length;
}
