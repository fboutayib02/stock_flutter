import '../../../domain/repositories/vehicle_repository.dart';

class AddVehicleUseCase {
  const AddVehicleUseCase(this._repository);

  final VehicleRepository _repository;

  Future<void> call({
    required String userId,
    required String label,
    required String plate,
    int? odometerKm,
  }) =>
      _repository.addVehicle(
        userId: userId,
        label: label,
        plate: plate,
        odometerKm: odometerKm,
      );
}
