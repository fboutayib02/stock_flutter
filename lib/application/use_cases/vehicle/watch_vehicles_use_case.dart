import '../../../domain/entities/vehicle.dart';
import '../../../domain/repositories/vehicle_repository.dart';

class WatchVehiclesUseCase {
  const WatchVehiclesUseCase(this._repository);

  final VehicleRepository _repository;

  Stream<List<Vehicle>> call(String userId) => _repository.watchVehicles(userId);
}
