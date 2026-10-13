// U1-S01-A04 — Paso 2 "Costo de mezclar" (contraejemplo para proyectar)
//
//   flutter run -t lib/main_mezclado.dart
//
// Se ve igual que la versión en capas. La diferencia está en el código:
// la pantalla guarda la "nube", valida y arma JSON dentro de su State.
// Busca las marcas MEZCLA 1..4; cada una es una fila de la tabla del Paso 2.

import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData(colorSchemeSeed: Colors.red),
        home: const PantallaMezclada(),
      ),
    );

class PantallaMezclada extends StatefulWidget {
  const PantallaMezclada({super.key});

  @override
  State<PantallaMezclada> createState() => _PantallaMezcladaState();
}

class _PantallaMezcladaState extends State<PantallaMezclada> {
  // MEZCLA 1 — La pantalla es dueña de la "nube".
  // Cambiar de fuente obliga a reescribir este widget.
  final List<Map<String, Object>> _nube = [];

  final _litros = TextEditingController();
  String _laboratorio = 'Lab Química';
  String? _error;
  bool _cargando = false;

  @override
  void dispose() {
    _litros.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final litros = double.tryParse(_litros.text.replaceAll(',', '.'));

    // MEZCLA 2 — La regla de litros solo vive aquí.
    // El historial y la meta tendrán que copiarla (y se desfasará).
    if (litros == null || litros <= 0 || litros > 10000) {
      setState(() => _error = 'Litros inválidos');
      return;
    }

    setState(() {
      _error = null;
      _cargando = true;
    });

    // MEZCLA 3 — La pantalla simula la red y arma el JSON.
    // No hay forma de probar "guardar" sin levantar este widget.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _nube.add({
      'laboratorio': _laboratorio,
      'litros': litros,
      'fecha': DateTime.now().toIso8601String(),
    });

    if (!mounted) return;
    setState(() => _cargando = false);
    _litros.clear();

    // MEZCLA 4 — Si mañana "guardar" vive en un repositorio que recibe
    // BuildContext para mostrar este aviso, los datos sabrán pintar.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Consumo guardado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filas = _nube.where((j) => j['laboratorio'] == _laboratorio).toList();
    final total =
        filas.fold<double>(0, (s, j) => s + (j['litros']! as double));

    return Scaffold(
      appBar: AppBar(title: const Text('EcoTrack — versión mezclada')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: _laboratorio,
              items: const [
                DropdownMenuItem(value: 'Lab Química', child: Text('Lab Química')),
                DropdownMenuItem(value: 'Lab Redes', child: Text('Lab Redes')),
                DropdownMenuItem(value: 'Lab Física', child: Text('Lab Física')),
              ],
              onChanged: (v) => setState(() => _laboratorio = v!),
            ),
            TextField(
              controller: _litros,
              decoration: InputDecoration(labelText: 'Litros', errorText: _error),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _cargando ? null : _guardar,
              child: const Text('Guardar'),
            ),
            const Divider(height: 32),
            Text('Historial · ${total.toStringAsFixed(1)} L'),
            Expanded(
              child: ListView(
                children: [
                  for (final j in filas.reversed)
                    ListTile(title: Text('${j['litros']} L')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
