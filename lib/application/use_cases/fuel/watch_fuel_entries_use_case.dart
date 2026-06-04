import '../../../domain/entities/fuel_entry.dart';
import '../../../domain/repositories/fuel_repository.dart';

class WatchFuelEntriesUseCase {
  const WatchFuelEntriesUseCase(this._repository);

  final FuelRepository _repository;

  Stream<List<FuelEntry>> call(String userId, {String? vehicleId}) =>
      _repository.watchFuelEntries(userId, vehicleId: vehicleId);
}
