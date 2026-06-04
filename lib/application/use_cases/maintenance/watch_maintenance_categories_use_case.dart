import '../../../domain/entities/maintenance_category.dart';
import '../../../domain/repositories/maintenance_repository.dart';

class WatchMaintenanceCategoriesUseCase {
  const WatchMaintenanceCategoriesUseCase(this._repository);

  final MaintenanceRepository _repository;

  Stream<List<MaintenanceCategory>> call(String userId) =>
      _repository.watchCategories(userId);
}
