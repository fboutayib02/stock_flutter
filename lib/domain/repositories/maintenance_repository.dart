import '../entities/maintenance.dart';
import '../entities/maintenance_category.dart';

abstract class MaintenanceRepository {
  Stream<List<MaintenanceCategory>> watchCategories(String userId);
  Stream<List<Maintenance>> watchMaintenances(
    String userId, {
    String? vehicleId,
    DateTime? from,
    DateTime? to,
  });
  Future<void> ensureDefaultCategories(String userId);
  Future<void> addMaintenance({
    required String userId,
    required String vehicleId,
    required String categoryId,
    required String description,
    required double amount,
    required DateTime performedAt,
  });
}
