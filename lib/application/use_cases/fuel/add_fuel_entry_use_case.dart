import '../../../domain/repositories/fuel_repository.dart';

class AddFuelEntryUseCase {
  const AddFuelEntryUseCase(this._repository);

  final FuelRepository _repository;

  Future<void> call({
    required String userId,
    required String vehicleId,
    required double liters,
    required double amount,
    required DateTime filledAt,
    String? station,
  }) =>
      _repository.addFuelEntry(
        userId: userId,
        vehicleId: vehicleId,
        liters: liters,
        amount: amount,
        filledAt: filledAt,
        station: station,
      );
}
