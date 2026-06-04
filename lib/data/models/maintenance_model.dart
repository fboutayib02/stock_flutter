import '../../core/utils/firestore_timestamp.dart';
import '../../domain/entities/maintenance.dart';
import '../../domain/entities/maintenance_category.dart';

class MaintenanceCategoryModel {
  MaintenanceCategoryModel({required this.id, required this.name});

  final String id;
  final String name;

  factory MaintenanceCategoryModel.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return MaintenanceCategoryModel(
      id: id,
      name: data['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {'name': name};

  MaintenanceCategory toEntity() => MaintenanceCategory(id: id, name: name);
}

class MaintenanceModel {
  MaintenanceModel({
    required this.id,
    required this.vehicleId,
    required this.categoryId,
    required this.description,
    required this.amount,
    required this.performedAt,
  });

  final String id;
  final String vehicleId;
  final String categoryId;
  final String description;
  final double amount;
  final DateTime performedAt;

  factory MaintenanceModel.fromFirestore(String id, Map<String, dynamic> data) {
    return MaintenanceModel(
      id: id,
      vehicleId: data['vehicleId'] as String? ?? '',
      categoryId: data['categoryId'] as String? ?? '',
      description: data['description'] as String? ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0,
      performedAt: parseFirestoreDate(data['performedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'vehicleId': vehicleId,
        'categoryId': categoryId,
        'description': description,
        'amount': amount,
        'performedAt': performedAt,
      };

  Maintenance toEntity() => Maintenance(
        id: id,
        vehicleId: vehicleId,
        categoryId: categoryId,
        description: description,
        amount: amount,
        performedAt: performedAt,
      );
}
