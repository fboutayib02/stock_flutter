import '../../../domain/repositories/maintenance_repository.dart';

class EnsureDefaultCategoriesUseCase {
  const EnsureDefaultCategoriesUseCase(this._repository);

  final MaintenanceRepository _repository;

  Future<void> call(String userId) => _repository.ensureDefaultCategories(userId);
}
