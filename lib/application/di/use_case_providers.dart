import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/repository_providers.dart';
import '../use_cases/auth/sign_in_use_case.dart';
import '../use_cases/auth/sign_out_use_case.dart';
import '../use_cases/auth/sign_up_use_case.dart';
import '../use_cases/auth/watch_auth_state_use_case.dart';
import '../use_cases/dashboard/get_monthly_stats_use_case.dart';
import '../use_cases/fuel/add_fuel_entry_use_case.dart';
import '../use_cases/fuel/watch_fuel_entries_use_case.dart';
import '../use_cases/maintenance/add_maintenance_use_case.dart';
import '../use_cases/maintenance/ensure_default_categories_use_case.dart';
import '../use_cases/maintenance/watch_maintenance_categories_use_case.dart';
import '../use_cases/maintenance/watch_maintenances_use_case.dart';
import '../use_cases/tips/get_eco_tip_use_case.dart';
import '../use_cases/vehicle/add_vehicle_use_case.dart';
import '../use_cases/vehicle/watch_vehicles_use_case.dart';

/// Couche Application : cas d'utilisation (orchestration métier).
final signInUseCaseProvider = Provider(
  (ref) => SignInUseCase(ref.watch(authRepositoryProvider)),
);

final signUpUseCaseProvider = Provider(
  (ref) => SignUpUseCase(ref.watch(authRepositoryProvider)),
);

final signOutUseCaseProvider = Provider(
  (ref) => SignOutUseCase(ref.watch(authRepositoryProvider)),
);

final watchAuthStateUseCaseProvider = Provider(
  (ref) => WatchAuthStateUseCase(ref.watch(authRepositoryProvider)),
);

final watchVehiclesUseCaseProvider = Provider(
  (ref) => WatchVehiclesUseCase(ref.watch(vehicleRepositoryProvider)),
);

final addVehicleUseCaseProvider = Provider(
  (ref) => AddVehicleUseCase(ref.watch(vehicleRepositoryProvider)),
);

final watchFuelEntriesUseCaseProvider = Provider(
  (ref) => WatchFuelEntriesUseCase(ref.watch(fuelRepositoryProvider)),
);

final addFuelEntryUseCaseProvider = Provider(
  (ref) => AddFuelEntryUseCase(ref.watch(fuelRepositoryProvider)),
);

final watchMaintenanceCategoriesUseCaseProvider = Provider(
  (ref) => WatchMaintenanceCategoriesUseCase(
    ref.watch(maintenanceRepositoryProvider),
  ),
);

final watchMaintenancesUseCaseProvider = Provider(
  (ref) => WatchMaintenancesUseCase(ref.watch(maintenanceRepositoryProvider)),
);

final ensureDefaultCategoriesUseCaseProvider = Provider(
  (ref) => EnsureDefaultCategoriesUseCase(
    ref.watch(maintenanceRepositoryProvider),
  ),
);

final addMaintenanceUseCaseProvider = Provider(
  (ref) => AddMaintenanceUseCase(ref.watch(maintenanceRepositoryProvider)),
);

final getMonthlyStatsUseCaseProvider = Provider(
  (ref) => GetMonthlyStatsUseCase(ref.watch(dashboardRepositoryProvider)),
);

final getEcoTipUseCaseProvider = Provider(
  (ref) => GetEcoTipUseCase(ref.watch(ecoTipRepositoryProvider)),
);
