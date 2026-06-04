import '../entities/fuel_entry.dart';

abstract class FuelRepository {
  Stream<List<FuelEntry>> watchFuelEntries(String userId, {String? vehicleId});
  Future<void> addFuelEntry({
    required String userId,
    required String vehicleId,
    required double liters,
    required double amount,
    required DateTime filledAt,
    String? station,
  });
}
