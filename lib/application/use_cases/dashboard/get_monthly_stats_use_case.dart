import '../../../domain/entities/monthly_stats.dart';
import '../../../domain/repositories/dashboard_repository.dart';

class GetMonthlyStatsUseCase {
  const GetMonthlyStatsUseCase(this._repository);

  final DashboardRepository _repository;

  Future<MonthlyStats> call({
    required String userId,
    required DateTime month,
  }) =>
      _repository.monthlyStats(userId: userId, month: month);
}
