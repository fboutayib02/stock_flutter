import '../entities/vehicle.dart';

abstract class VehicleRepository {
  Stream<List<Vehicle>> watchVehicles(String userId);
  Future<void> addVehicle({
    required String userId,
    required String label,
    required String plate,
    int? odometerKm,
  });
}
