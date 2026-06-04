import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../providers/app_providers.dart';
import '../widgets/quick_actions_row.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicles = ref.watch(vehiclesProvider);
    final stats = ref.watch(monthlyStatsProvider);
    final ecoTip = ref.watch(ecoTipProvider);
    final labels = ref.watch(vehicleLabelsProvider);
    final month = ref.watch(dashboardMonthProvider);
    final monthLabel = DateFormat.yMMMM('fr_FR').format(month);
    final currency = NumberFormat.currency(locale: 'fr_FR', symbol: 'MAD');

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(monthlyStatsProvider);
        ref.invalidate(ecoTipProvider);
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  ref.read(dashboardMonthProvider.notifier).state =
                      DateTime(month.year, month.month - 1);
                  ref.invalidate(monthlyStatsProvider);
                },
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  monthLabel,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                onPressed: () {
                  ref.read(dashboardMonthProvider.notifier).state =
                      DateTime(month.year, month.month + 1);
                  ref.invalidate(monthlyStatsProvider);
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const QuickActionsRow(),
          const SizedBox(height: 16),
          ecoTip.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (tip) => Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: ListTile(
                leading: const Icon(Icons.eco),
                title: const Text('Conseil éco-conduite'),
                subtitle: Text(tip.message),
              ),
            ),
          ),
          const SizedBox(height: 12),
          stats.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Impossible de charger les stats.\n'
                  'Vérifiez Firebase et les index Firestore.\n$e',
                ),
              ),
            ),
            data: (s) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dépenses du mois',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currency.format(s.total),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    _ShareRow(
                      label: 'Carburant',
                      percent: s.fuelSharePercent,
                      amount: s.fuelTotal,
                      color: Colors.orange,
                      currency: currency,
                    ),
                    _ShareRow(
                      label: 'Entretien',
                      percent: s.maintenanceSharePercent,
                      amount: s.maintenanceTotal,
                      color: Colors.teal,
                      currency: currency,
                    ),
                    const Divider(height: 24),
                    Text(
                      'Litres consommés : ${s.fuelLiters.toStringAsFixed(1)} L',
                    ),
                    if (s.fuelByVehicle.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Consommation par véhicule',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      ...s.fuelByVehicle.entries.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '• ${labels[e.key] ?? e.key}: '
                            '${e.value.toStringAsFixed(1)} L',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Véhicules', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          vehicles.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('Erreur: $e'),
            data: (list) {
              if (list.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Aucun véhicule. Commencez par en ajouter un.',
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () => context.push('/vehicles/add'),
                          icon: const Icon(Icons.add),
                          label: const Text('Ajouter un véhicule'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Column(
                children: list
                    .map(
                      (v) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.directions_car),
                          title: Text(v.label),
                          subtitle: Text(v.plate),
                          trailing: v.odometerKm != null
                              ? Text('${v.odometerKm} km')
                              : null,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ShareRow extends StatelessWidget {
  const _ShareRow({
    required this.label,
    required this.percent,
    required this.amount,
    required this.color,
    required this.currency,
  });

  final String label;
  final double percent;
  final double amount;
  final Color color;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$label (${percent.toStringAsFixed(0)}%)'),
              Text(currency.format(amount)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percent / 100,
            color: color,
            backgroundColor: color.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}
