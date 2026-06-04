import '../../../domain/entities/maintenance.dart';
import '../../../domain/repositories/maintenance_repository.dart';

class WatchMaintenancesUseCase {
  const WatchMaintenancesUseCase(this._repository);

  final MaintenanceRepository _repository;

  Stream<List<Maintenance>> call(String userId) =>
      _repository.watchMaintenances(userId);
}
