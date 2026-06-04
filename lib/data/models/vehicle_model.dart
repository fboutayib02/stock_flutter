import '../../core/utils/firestore_timestamp.dart';
import '../../domain/entities/vehicle.dart';

class VehicleModel {
  VehicleModel({
    required this.id,
    required this.label,
    required this.plate,
    this.odometerKm,
    required this.createdAt,
  });

  final String id;
  final String label;
  final String plate;
  final int? odometerKm;
  final DateTime createdAt;

  factory VehicleModel.fromFirestore(String id, Map<String, dynamic> data) {
    return VehicleModel(
      id: id,
      label: data['label'] as String? ?? '',
      plate: data['plate'] as String? ?? '',
      odometerKm: data['odometerKm'] as int?,
      createdAt: parseFirestoreDate(data['createdAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'label': label,
        'plate': plate,
        'odometerKm': odometerKm,
        'createdAt': createdAt,
      };

  Vehicle toEntity() => Vehicle(
        id: id,
        label: label,
        plate: plate,
        odometerKm: odometerKm,
        createdAt: createdAt,
      );
}
