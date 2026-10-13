// U1-S01-A04 — EcoTrack en tres capas (solución de referencia)
//
//   flutter run                          -> versión en capas
//   flutter run -t lib/main_mezclado.dart -> la misma pantalla, mezclada
//
// Este archivo es el único lugar que conoce las implementaciones concretas.
// Pregunta 3 de la exposición: "¿qué hay que editar si los consumos salen
// de una lista y no de la nube?" -> la línea marcada abajo. Nada más.

import 'package:flutter/material.dart';

import 'datos/consumo_repository.dart';
import 'datos/consumo_service.dart';
import 'datos/memoria_consumo_repository.dart';
import 'datos/nube_consumo_repository.dart';
import 'presentacion/registro_page.dart';
import 'presentacion/registro_view_model.dart';

const usarNube = false; // DOCENTE: cámbialo a true y haz hot restart.

void main() {
  final ConsumoRepository repositorio = usarNube
      ? NubeConsumoRepository(ConsumoService())
      : MemoriaConsumoRepository();

  runApp(EcoTrackApp(repositorio: repositorio));
}

class EcoTrackApp extends StatelessWidget {
  const EcoTrackApp({super.key, required this.repositorio});

  final ConsumoRepository repositorio;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoTrack',
      theme: ThemeData(colorSchemeSeed: Colors.green),
      home: RegistroPage(viewModel: RegistroViewModel(repositorio)),
    );
  }
}
