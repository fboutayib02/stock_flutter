import '../../core/utils/firestore_timestamp.dart';
import '../../domain/entities/fuel_entry.dart';

class FuelEntryModel {
  FuelEntryModel({
    required this.id,
    required this.vehicleId,
    required this.liters,
    required this.amount,
    required this.filledAt,
    this.station,
  });

  final String id;
  final String vehicleId;
  final double liters;
  final double amount;
  final DateTime filledAt;
  final String? station;

  factory FuelEntryModel.fromFirestore(String id, Map<String, dynamic> data) {
    return FuelEntryModel(
      id: id,
      vehicleId: data['vehicleId'] as String? ?? '',
      liters: (data['liters'] as num?)?.toDouble() ?? 0,
      amount: (data['amount'] as num?)?.toDouble() ?? 0,
      filledAt: parseFirestoreDate(data['filledAt']),
      station: data['station'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'vehicleId': vehicleId,
        'liters': liters,
        'amount': amount,
        'filledAt': filledAt,
        if (station != null) 'station': station,
      };

  FuelEntry toEntity() => FuelEntry(
        id: id,
        vehicleId: vehicleId,
        liters: liters,
        amount: amount,
        filledAt: filledAt,
        station: station,
      );
}
