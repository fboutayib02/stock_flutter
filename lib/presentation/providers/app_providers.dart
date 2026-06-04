import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../application/di/use_case_providers.dart';
import '../../domain/entities/fuel_entry.dart';
import '../../domain/entities/maintenance.dart';
import '../../domain/entities/maintenance_category.dart';
import '../../domain/entities/monthly_stats.dart';
import '../../domain/entities/vehicle.dart';

/// Couche Présentation : état UI via Riverpod, branché sur les use cases.
final authStateProvider = StreamProvider(
  (ref) => ref.watch(watchAuthStateUseCaseProvider).call(),
);

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(watchAuthStateUseCaseProvider).currentUserId();
});

final vehiclesProvider = StreamProvider<List<Vehicle>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Stream.empty();
  return ref.watch(watchVehiclesUseCaseProvider).call(userId);
});

final fuelEntriesProvider = StreamProvider<List<FuelEntry>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Stream.empty();
  return ref.watch(watchFuelEntriesUseCaseProvider).call(userId);
});

final maintenanceCategoriesProvider =
    StreamProvider<List<MaintenanceCategory>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Stream.empty();
  return ref.watch(watchMaintenanceCategoriesUseCaseProvider).call(userId);
});

final maintenancesProvider = StreamProvider<List<Maintenance>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Stream.empty();
  return ref.watch(watchMaintenancesUseCaseProvider).call(userId);
});

final dashboardMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

/// Map vehicleId → libellé affiché (dashboard, historiques).
final vehicleLabelsProvider = Provider<Map<String, String>>((ref) {
  final vehicles = ref.watch(vehiclesProvider).value ?? [];
  return {for (final v in vehicles) v.id: '${v.label} (${v.plate})'};
});

final categoryLabelsProvider = Provider<Map<String, String>>((ref) {
  final categories = ref.watch(maintenanceCategoriesProvider).value ?? [];
  return {for (final c in categories) c.id: c.name};
});

final ecoTipProvider = FutureProvider((ref) async {
  return ref.watch(getEcoTipUseCaseProvider).call();
});

final monthlyStatsProvider = FutureProvider<MonthlyStats>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    throw StateError('Utilisateur non connecté');
  }
  final month = ref.watch(dashboardMonthProvider);
  return ref.watch(getMonthlyStatsUseCaseProvider).call(
        userId: userId,
        month: month,
      );
});
