import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/providers/app_providers.dart';
import '../../presentation/screens/add_fuel_screen.dart';
import '../../presentation/screens/add_maintenance_screen.dart';
import '../../presentation/screens/add_vehicle_screen.dart';
import '../../presentation/screens/dashboard_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/fuel_history_screen.dart';
import '../../presentation/screens/maintenance_history_screen.dart';
import '../../presentation/screens/shell_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: _AuthRefreshListenable(ref),
    redirect: (context, state) {
      final user = authState.value;
      final loggingIn = state.matchedLocation == '/login';

      if (user == null) {
        return loggingIn ? null : '/login';
      }
      if (loggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/vehicles/add',
            builder: (context, state) => const AddVehicleScreen(),
          ),
          GoRoute(
            path: '/fuel/add',
            builder: (context, state) => const AddFuelScreen(),
          ),
          GoRoute(
            path: '/fuel/history',
            builder: (context, state) => const FuelHistoryScreen(),
          ),
          GoRoute(
            path: '/maintenance/add',
            builder: (context, state) => const AddMaintenanceScreen(),
          ),
          GoRoute(
            path: '/maintenance/history',
            builder: (context, state) => const MaintenanceHistoryScreen(),
          ),
        ],
      ),
    ],
  );
});

class _AuthRefreshListenable extends ChangeNotifier {
  _AuthRefreshListenable(this._ref) {
    _sub = _ref.listen(authStateProvider, (_, _) => notifyListeners());
  }

  final Ref _ref;
  late final ProviderSubscription<AsyncValue<dynamic>> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
