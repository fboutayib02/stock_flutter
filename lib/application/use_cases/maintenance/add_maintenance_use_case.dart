import '../../../domain/repositories/maintenance_repository.dart';

class AddMaintenanceUseCase {
  const AddMaintenanceUseCase(this._repository);

  final MaintenanceRepository _repository;

  Future<void> call({
    required String userId,
    required String vehicleId,
    required String categoryId,
    required String description,
    required double amount,
    required DateTime performedAt,
  }) =>
      _repository.addMaintenance(
        userId: userId,
        vehicleId: vehicleId,
        categoryId: categoryId,
        description: description,
        amount: amount,
        performedAt: performedAt,
      );
}
