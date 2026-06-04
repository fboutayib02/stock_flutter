import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../../domain/entities/monthly_stats.dart';
import '../../domain/repositories/dashboard_repository.dart';

class FirestoreDashboardRepository implements DashboardRepository {
  FirestoreDashboardRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<MonthlyStats> monthlyStats({
    required String userId,
    required DateTime month,
  }) async {
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1);

    final fuelSnap = await _firestore
        .collection(FirestorePaths.fuelEntries(userId))
        .where('filledAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('filledAt', isLessThan: Timestamp.fromDate(end))
        .get();

    final maintSnap = await _firestore
        .collection(FirestorePaths.maintenances(userId))
        .where(
          'performedAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(start),
        )
        .where('performedAt', isLessThan: Timestamp.fromDate(end))
        .get();

    var fuelTotal = 0.0;
    var fuelLiters = 0.0;
    final fuelByVehicle = <String, double>{};

    for (final doc in fuelSnap.docs) {
      final data = doc.data();
      final amount = (data['amount'] as num?)?.toDouble() ?? 0;
      final liters = (data['liters'] as num?)?.toDouble() ?? 0;
      final vehicleId = data['vehicleId'] as String? ?? '';
      fuelTotal += amount;
      fuelLiters += liters;
      fuelByVehicle[vehicleId] = (fuelByVehicle[vehicleId] ?? 0) + liters;
    }

    var maintenanceTotal = 0.0;
    for (final doc in maintSnap.docs) {
      maintenanceTotal += (doc.data()['amount'] as num?)?.toDouble() ?? 0;
    }

    return MonthlyStats(
      month: start,
      fuelTotal: fuelTotal,
      maintenanceTotal: maintenanceTotal,
      fuelLiters: fuelLiters,
      fuelByVehicle: fuelByVehicle,
    );
  }
}
