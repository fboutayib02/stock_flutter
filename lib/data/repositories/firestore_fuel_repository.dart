import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../../domain/entities/fuel_entry.dart';
import '../../domain/repositories/fuel_repository.dart';
import '../models/fuel_entry_model.dart';

class FirestoreFuelRepository implements FuelRepository {
  FirestoreFuelRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Stream<List<FuelEntry>> watchFuelEntries(
    String userId, {
    String? vehicleId,
  }) {
    Query<Map<String, dynamic>> query = _firestore
        .collection(FirestorePaths.fuelEntries(userId))
        .orderBy('filledAt', descending: true);
    if (vehicleId != null) {
      query = query.where('vehicleId', isEqualTo: vehicleId);
    }
    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => FuelEntryModel.fromFirestore(doc.id, doc.data()))
              .map((m) => m.toEntity())
              .toList(),
        );
  }

  @override
  Future<void> addFuelEntry({
    required String userId,
    required String vehicleId,
    required double liters,
    required double amount,
    required DateTime filledAt,
    String? station,
  }) {
    final model = FuelEntryModel(
      id: '',
      vehicleId: vehicleId,
      liters: liters,
      amount: amount,
      filledAt: filledAt,
      station: station,
    );
    return _firestore.collection(FirestorePaths.fuelEntries(userId)).add(
          model.toFirestore()
            ..['filledAt'] = Timestamp.fromDate(filledAt),
        );
  }
}
