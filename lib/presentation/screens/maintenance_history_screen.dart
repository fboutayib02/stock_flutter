import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/maintenance.dart';
import '../providers/app_providers.dart';

final _historyVehicleFilterProvider = StateProvider<String?>((ref) => null);
final _historyFromProvider = StateProvider<DateTime?>((ref) => null);
final _historyToProvider = StateProvider<DateTime?>((ref) => null);

final filteredMaintenancesProvider = Provider<List<Maintenance>>((ref) {
  final all = ref.watch(maintenancesProvider).value ?? [];
  final vehicleId = ref.watch(_historyVehicleFilterProvider);
  final from = ref.watch(_historyFromProvider);
  final to = ref.watch(_historyToProvider);

  return all.where((m) {
    if (vehicleId != null && m.vehicleId != vehicleId) return false;
    if (from != null) {
      final start = DateTime(from.year, from.month, from.day);
      if (m.performedAt.isBefore(start)) return false;
    }
    if (to != null) {
      final end = DateTime(to.year, to.month, to.day, 23, 59, 59);
      if (m.performedAt.isAfter(end)) return false;
    }
    return true;
  }).toList();
});

class MaintenanceHistoryScreen extends ConsumerWidget {
  const MaintenanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicles = ref.watch(vehiclesProvider);
    final vehicleLabels = ref.watch(vehicleLabelsProvider);
    final categoryLabels = ref.watch(categoryLabelsProvider);
    final items = ref.watch(filteredMaintenancesProvider);
    final vehicleFilter = ref.watch(_historyVehicleFilterProvider);
    final from = ref.watch(_historyFromProvider);
    final to = ref.watch(_historyToProvider);
    final dateFormat = DateFormat.yMMMd('fr_FR');
    final currency = NumberFormat.currency(locale: 'fr_FR', symbol: '€');

    Future<void> pickDate({required bool isFrom}) async {
      final initial =
          isFrom ? (from ?? DateTime.now()) : (to ?? DateTime.now());
      final picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        initialDate: initial,
      );
      if (picked == null) return;
      if (isFrom) {
        ref.read(_historyFromProvider.notifier).state = picked;
      } else {
        ref.read(_historyToProvider.notifier).state = picked;
      }
    }

    return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                vehicles.when(
                  data: (list) => DropdownButtonFormField<String?>(
                    initialValue: vehicleFilter,
                    decoration: const InputDecoration(
                      labelText: 'Véhicule',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Tous'),
                      ),
                      ...list.map(
                        (v) => DropdownMenuItem(
                          value: v.id,
                          child: Text(v.label),
                        ),
                      ),
                    ],
                    onChanged: (v) =>
                        ref.read(_historyVehicleFilterProvider.notifier).state =
                            v,
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('$e'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => pickDate(isFrom: true),
                        child: Text(
                          from == null
                              ? 'Du...'
                              : 'Du ${dateFormat.format(from)}',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => pickDate(isFrom: false),
                        child: Text(
                          to == null
                              ? 'Au...'
                              : 'Au ${dateFormat.format(to)}',
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Réinitialiser filtres',
                      onPressed: () {
                        ref.read(_historyVehicleFilterProvider.notifier).state =
                            null;
                        ref.read(_historyFromProvider.notifier).state = null;
                        ref.read(_historyToProvider.notifier).state = null;
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('Aucun entretien'))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final m = items[index];
                      final vehicle =
                          vehicleLabels[m.vehicleId] ?? m.vehicleId;
                      final category =
                          categoryLabels[m.categoryId] ?? 'Entretien';
                      return ListTile(
                        leading: const Icon(Icons.build),
                        title: Text(m.description),
                        subtitle: Text(
                          '$vehicle · $category · '
                          '${dateFormat.format(m.performedAt)}',
                        ),
                        trailing: Text(currency.format(m.amount)),
                      );
                    },
                  ),
          ),
        ],
      );
  }
}
