import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/vehicle.dart';
import '../../application/di/use_case_providers.dart';
import '../providers/app_providers.dart';

class AddFuelScreen extends ConsumerStatefulWidget {
  const AddFuelScreen({super.key});

  @override
  ConsumerState<AddFuelScreen> createState() => _AddFuelScreenState();
}

class _AddFuelScreenState extends ConsumerState<AddFuelScreen> {
  final _formKey = GlobalKey<FormState>();
  final _liters = TextEditingController();
  final _amount = TextEditingController();
  final _station = TextEditingController();
  Vehicle? _vehicle;
  DateTime _date = DateTime.now();
  var _loading = false;

  @override
  void dispose() {
    _liters.dispose();
    _amount.dispose();
    _station.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      initialDate: _date,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _vehicle == null) {
      if (_vehicle == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sélectionnez un véhicule')),
        );
      }
      return;
    }
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    setState(() => _loading = true);
    try {
      await ref.read(addFuelEntryUseCaseProvider).call(
            userId: userId,
            vehicleId: _vehicle!.id,
            liters: double.parse(_liters.text.replaceAll(',', '.')),
            amount: double.parse(_amount.text.replaceAll(',', '.')),
            filledAt: _date,
            station: _station.text.isEmpty ? null : _station.text.trim(),
          );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = ref.watch(vehiclesProvider);

    return vehicles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Text('Ajoutez d\'abord un véhicule.'),
            );
          }
          _vehicle ??= list.first;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  DropdownButtonFormField<Vehicle>(
                    value: _vehicle,
                    decoration: const InputDecoration(
                      labelText: 'Véhicule',
                      border: OutlineInputBorder(),
                    ),
                    items: list
                        .map(
                          (v) => DropdownMenuItem(
                            value: v,
                            child: Text('${v.label} (${v.plate})'),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _vehicle = v),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _liters,
                    decoration: const InputDecoration(
                      labelText: 'Litres',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Requis' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _amount,
                    decoration: const InputDecoration(
                      labelText: 'Montant (€)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Requis' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _station,
                    decoration: const InputDecoration(
                      labelText: 'Station (optionnel)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    title: const Text('Date du plein'),
                    subtitle: Text(
                      '${_date.day}/${_date.month}/${_date.year}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _loading ? null : _save,
                    child: _loading
                        ? const CircularProgressIndicator()
                        : const Text('Enregistrer'),
                  ),
                ],
              ),
            ),
          );
        },
      );
  }
}
