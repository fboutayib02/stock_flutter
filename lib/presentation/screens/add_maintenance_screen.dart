import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/maintenance_category.dart';
import '../../domain/entities/vehicle.dart';
import '../../application/di/use_case_providers.dart';
import '../providers/app_providers.dart';

class AddMaintenanceScreen extends ConsumerStatefulWidget {
  const AddMaintenanceScreen({super.key});

  @override
  ConsumerState<AddMaintenanceScreen> createState() =>
      _AddMaintenanceScreenState();
}

class _AddMaintenanceScreenState extends ConsumerState<AddMaintenanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  final _amount = TextEditingController();
  Vehicle? _vehicle;
  MaintenanceCategory? _category;
  DateTime _date = DateTime.now();
  var _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = ref.read(currentUserIdProvider);
      if (userId != null) {
        await ref.read(ensureDefaultCategoriesUseCaseProvider).call(userId);
      }
    });
  }

  @override
  void dispose() {
    _description.dispose();
    _amount.dispose();
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
    if (!_formKey.currentState!.validate() ||
        _vehicle == null ||
        _category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Véhicule et catégorie requis')),
      );
      return;
    }
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    setState(() => _loading = true);
    try {
      await ref.read(addMaintenanceUseCaseProvider).call(
            userId: userId,
            vehicleId: _vehicle!.id,
            categoryId: _category!.id,
            description: _description.text.trim(),
            amount: double.parse(_amount.text.replaceAll(',', '.')),
            performedAt: _date,
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
    final categories = ref.watch(maintenanceCategoriesProvider);

    return vehicles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (vehicleList) {
          if (vehicleList.isEmpty) {
            return const Center(child: Text('Ajoutez d\'abord un véhicule.'));
          }
          _vehicle ??= vehicleList.first;

          return categories.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (catList) {
              if (catList.isEmpty) {
                return const Center(child: Text('Chargement catégories...'));
              }
              _category ??= catList.first;

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
                        items: vehicleList
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
                      DropdownButtonFormField<MaintenanceCategory>(
                        value: _category,
                        decoration: const InputDecoration(
                          labelText: 'Catégorie',
                          border: OutlineInputBorder(),
                        ),
                        items: catList
                            .map(
                              (c) => DropdownMenuItem(
                                value: c,
                                child: Text(c.name),
                              ),
                            )
                            .toList(),
                        onChanged: (c) => setState(() => _category = c),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _description,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Requis' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _amount,
                        decoration: const InputDecoration(
                          labelText: 'Coût (€)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Requis' : null,
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        title: const Text('Date'),
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
        },
      );
  }
}
