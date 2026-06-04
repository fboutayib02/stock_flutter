import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../models/vehicle_model.dart';

class FirestoreVehicleRepository implements VehicleRepository {
  FirestoreVehicleRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Stream<List<Vehicle>> watchVehicles(String userId) {
    return _firestore
        .collection(FirestorePaths.vehicles(userId))
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => VehicleModel.fromFirestore(doc.id, doc.data()))
              .map((m) => m.toEntity())
              .toList(),
        );
  }

  @override
  Future<void> addVehicle({
    required String userId,
    required String label,
    required String plate,
    int? odometerKm,
  }) {
    return _firestore.collection(FirestorePaths.vehicles(userId)).add({
      'label': label,
      'plate': plate,
      if (odometerKm != null) 'odometerKm': odometerKm,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
