import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/di/use_case_providers.dart';

class ShellScreen extends ConsumerWidget {
  const ShellScreen({super.key, required this.child});

  final Widget child;

  String _titleForPath(String path) {
    return switch (path) {
      '/' => 'Tableau de bord',
      '/vehicles/add' => 'Nouveau véhicule',
      '/fuel/add' => 'Plein carburant',
      '/fuel/history' => 'Historique carburant',
      '/maintenance/add' => 'Entretien',
      '/maintenance/history' => 'Historique entretiens',
      _ => 'Stock Tracker',
    };
  }

  bool _showFab(String path) => path == '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = GoRouterState.of(context).uri.path;
    final title = _titleForPath(path);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Déconnexion',
            onPressed: () => ref.read(signOutUseCaseProvider).call(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Stock Tracker',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
                context.go('/');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Ajouter un véhicule'),
              onTap: () {
                Navigator.pop(context);
                context.push('/vehicles/add');
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_gas_station),
              title: const Text('Plein carburant'),
              onTap: () {
                Navigator.pop(context);
                context.push('/fuel/add');
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_gas_station_outlined),
              title: const Text('Historique carburant'),
              onTap: () {
                Navigator.pop(context);
                context.push('/fuel/history');
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Entretien'),
              onTap: () {
                Navigator.pop(context);
                context.push('/maintenance/add');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historique entretiens'),
              onTap: () {
                Navigator.pop(context);
                context.push('/maintenance/history');
              },
            ),
          ],
        ),
      ),
      body: child,
      floatingActionButton: _showFab(path)
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/vehicles/add'),
              icon: const Icon(Icons.add),
              label: const Text('Véhicule'),
            )
          : null,
    );
  }
}
