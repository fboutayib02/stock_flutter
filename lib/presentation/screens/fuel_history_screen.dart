import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/fuel_entry.dart';
import '../providers/app_providers.dart';

final _fuelHistoryVehicleProvider = StateProvider<String?>((ref) => null);
final _fuelHistoryFromProvider = StateProvider<DateTime?>((ref) => null);
final _fuelHistoryToProvider = StateProvider<DateTime?>((ref) => null);

final filteredFuelEntriesProvider = Provider<List<FuelEntry>>((ref) {
  final all = ref.watch(fuelEntriesProvider).value ?? [];
  final vehicleId = ref.watch(_fuelHistoryVehicleProvider);
  final from = ref.watch(_fuelHistoryFromProvider);
  final to = ref.watch(_fuelHistoryToProvider);

  return all.where((entry) {
    if (vehicleId != null && entry.vehicleId != vehicleId) return false;
    if (from != null) {
      final start = DateTime(from.year, from.month, from.day);
      if (entry.filledAt.isBefore(start)) return false;
    }
    if (to != null) {
      final end = DateTime(to.year, to.month, to.day, 23, 59, 59);
      if (entry.filledAt.isAfter(end)) return false;
    }
    return true;
  }).toList();
});

class FuelHistoryScreen extends ConsumerWidget {
  const FuelHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicles = ref.watch(vehiclesProvider);
    final labels = ref.watch(vehicleLabelsProvider);
    final items = ref.watch(filteredFuelEntriesProvider);
    final vehicleFilter = ref.watch(_fuelHistoryVehicleProvider);
    final from = ref.watch(_fuelHistoryFromProvider);
    final to = ref.watch(_fuelHistoryToProvider);
    final dateFormat = DateFormat.yMMMd('fr_FR');
    final currency = NumberFormat.currency(locale: 'fr_FR', symbol: 'MAD');

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
        ref.read(_fuelHistoryFromProvider.notifier).state = picked;
      } else {
        ref.read(_fuelHistoryToProvider.notifier).state = picked;
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
                        ref.read(_fuelHistoryVehicleProvider.notifier).state =
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
                      tooltip: 'Réinitialiser',
                      onPressed: () {
                        ref.read(_fuelHistoryVehicleProvider.notifier).state =
                            null;
                        ref.read(_fuelHistoryFromProvider.notifier).state =
                            null;
                        ref.read(_fuelHistoryToProvider.notifier).state = null;
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
                ? const Center(child: Text('Aucun plein enregistré'))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final entry = items[index];
                      final vehicleName =
                          labels[entry.vehicleId] ?? entry.vehicleId;
                      return ListTile(
                        leading: const Icon(Icons.local_gas_station),
                        title: Text(vehicleName),
                        subtitle: Text(
                          '${dateFormat.format(entry.filledAt)} · '
                          '${entry.liters.toStringAsFixed(1)} L'
                          '${entry.station != null ? ' · ${entry.station}' : ''}',
                        ),
                        trailing: Text(currency.format(entry.amount)),
                      );
                    },
                  ),
          ),
        ],
      );
  }
}
