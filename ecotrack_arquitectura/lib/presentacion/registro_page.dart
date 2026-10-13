// CAPA: PRESENTACIÓN — View
// Lee el estado del ViewModel y le pasa intenciones (guardar, cambiar lab).
// No valida litros, no guarda, no sabe si hay nube o lista.

import 'package:flutter/material.dart';

import '../dominio/consumo.dart';
import 'registro_view_model.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key, required this.viewModel});

  final RegistroViewModel viewModel;

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final _litros = TextEditingController();

  RegistroViewModel get vm => widget.viewModel;

  @override
  void dispose() {
    _litros.dispose();
    super.dispose();
  }

  Future<void> _alPulsarGuardar() async {
    final guardado = await vm.guardar(_litros.text);
    if (!mounted || !guardado) return;
    _litros.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Consumo guardado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EcoTrack — Registro')),
      body: ListenableBuilder(
        listenable: vm,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: vm.laboratorio,
                  decoration: const InputDecoration(labelText: 'Laboratorio'),
                  items: [
                    for (final lab in laboratoriosUtez)
                      DropdownMenuItem(value: lab, child: Text(lab)),
                  ],
                  onChanged: (lab) => vm.cambiarLaboratorio(lab!),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('campoLitros'),
                  controller: _litros,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Litros',
                    errorText: vm.error,
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: vm.cargando ? null : _alPulsarGuardar,
                  icon: vm.cargando
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Guardar'),
                ),
                const Divider(height: 32),
                Text(
                  'Historial de ${vm.laboratorio} · '
                  '${vm.totalLitros.toStringAsFixed(1)} L',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Expanded(
                  child: vm.historial.isEmpty
                      ? const Center(child: Text('Sin consumos todavía'))
                      : ListView(
                          children: [
                            for (final c in vm.historial.reversed)
                              ListTile(
                                leading: const Icon(Icons.water_drop),
                                title: Text('${c.litros} L'),
                                subtitle: Text(
                                  '${c.fecha.hour}:'
                                  '${c.fecha.minute.toString().padLeft(2, '0')}',
                                ),
                              ),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
