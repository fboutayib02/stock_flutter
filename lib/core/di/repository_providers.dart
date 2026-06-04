import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/eco_tip_remote_data_source.dart';
import '../../data/repositories/eco_tip_repository_impl.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../../data/repositories/firestore_dashboard_repository.dart';
import '../../data/repositories/firestore_fuel_repository.dart';
import '../../data/repositories/firestore_maintenance_repository.dart';
import '../../data/repositories/firestore_vehicle_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/eco_tip_repository.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/repositories/fuel_repository.dart';
import '../../domain/repositories/maintenance_repository.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../network/dio_client.dart';

/// Couche Data : implémentations concrètes (Firestore, Auth, dio).
final dioProvider = Provider<Dio>((ref) => createDioClient());

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FirebaseAuthRepository(FirebaseAuth.instance),
);

final vehicleRepositoryProvider = Provider<VehicleRepository>(
  (ref) => FirestoreVehicleRepository(FirebaseFirestore.instance),
);

final fuelRepositoryProvider = Provider<FuelRepository>(
  (ref) => FirestoreFuelRepository(FirebaseFirestore.instance),
);

final maintenanceRepositoryProvider = Provider<MaintenanceRepository>(
  (ref) => FirestoreMaintenanceRepository(FirebaseFirestore.instance),
);

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => FirestoreDashboardRepository(FirebaseFirestore.instance),
);

final ecoTipRemoteDataSourceProvider = Provider(
  (ref) => EcoTipRemoteDataSource(ref.watch(dioProvider)),
);

final ecoTipRepositoryProvider = Provider<EcoTipRepository>(
  (ref) => EcoTipRepositoryImpl(ref.watch(ecoTipRemoteDataSourceProvider)),
);
