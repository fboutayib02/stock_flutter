import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../../domain/entities/maintenance.dart';
import '../../domain/entities/maintenance_category.dart';
import '../../domain/repositories/maintenance_repository.dart';
import '../models/maintenance_model.dart';

class FirestoreMaintenanceRepository implements MaintenanceRepository {
  FirestoreMaintenanceRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static const _defaultCategories = [
    'Vidange',
    'Pneus',
    'Freins',
    'Révision',
    'Autre',
  ];

  @override
  Stream<List<MaintenanceCategory>> watchCategories(String userId) {
    return _firestore
        .collection(FirestorePaths.maintenanceCategories(userId))
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    MaintenanceCategoryModel.fromFirestore(doc.id, doc.data()),
              )
              .map((m) => m.toEntity())
              .toList(),
        );
  }

  @override
  Stream<List<Maintenance>> watchMaintenances(
    String userId, {
    String? vehicleId,
    DateTime? from,
    DateTime? to,
  }) {
    Query<Map<String, dynamic>> query = _firestore
        .collection(FirestorePaths.maintenances(userId))
        .orderBy('performedAt', descending: true);
    if (vehicleId != null) {
      query = query.where('vehicleId', isEqualTo: vehicleId);
    }
    return query.snapshots().map((snapshot) {
      var items = snapshot.docs
          .map((doc) => MaintenanceModel.fromFirestore(doc.id, doc.data()))
          .map((m) => m.toEntity())
          .toList();
      if (from != null) {
        items = items.where((m) => !m.performedAt.isBefore(from)).toList();
      }
      if (to != null) {
        items = items.where((m) => !m.performedAt.isAfter(to)).toList();
      }
      return items;
    });
  }

  @override
  Future<void> ensureDefaultCategories(String userId) async {
    final ref = _firestore.collection(
      FirestorePaths.maintenanceCategories(userId),
    );
    final existing = await ref.limit(1).get();
    if (existing.docs.isNotEmpty) return;

    final batch = _firestore.batch();
    for (final name in _defaultCategories) {
      final doc = ref.doc();
      batch.set(doc, {'name': name});
    }
    await batch.commit();
  }

  @override
  Future<void> addMaintenance({
    required String userId,
    required String vehicleId,
    required String categoryId,
    required String description,
    required double amount,
    required DateTime performedAt,
  }) {
    final model = MaintenanceModel(
      id: '',
      vehicleId: vehicleId,
      categoryId: categoryId,
      description: description,
      amount: amount,
      performedAt: performedAt,
    );
    return _firestore.collection(FirestorePaths.maintenances(userId)).add(
          model.toFirestore()
            ..['performedAt'] = Timestamp.fromDate(performedAt),
        );
  }
}
