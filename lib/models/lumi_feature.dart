/// LUMI 功能解锁枚举 — 基于累计记录天数渐进解锁。
///
/// [requiredDays] 表示解锁该功能所需的最少每日一光记录天数。
enum LumiFeature {
  dailyLight(0),
  weeklyPlanReview(1),
  worryProcessor(1),
  monthlyView(3),
  smallWinChallenge(7),
  yearlyPlan(14),
  lists(7),
  highlightMoments(14),
  monthlyActivities(30),
  growthReview(90);

  const LumiFeature(this.requiredDays);
  final int requiredDays;
}
