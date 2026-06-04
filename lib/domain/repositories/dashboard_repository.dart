import '../entities/monthly_stats.dart';

abstract class DashboardRepository {
  Future<MonthlyStats> monthlyStats({
    required String userId,
    required DateTime month,
  });
}
