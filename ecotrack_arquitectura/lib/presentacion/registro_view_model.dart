// CAPA: PRESENTACIÓN — ViewModel
// Guarda el estado de la pantalla (cargando, error, lista) y orquesta:
// pide la regla al dominio y el guardado al repositorio.
// No importa material.dart: no pinta y no conoce widgets.
// ChangeNotifier viene de foundation; solo sabe avisar "cambié".

import 'package:flutter/foundation.dart';

import '../datos/consumo_repository.dart';
import '../dominio/consumo.dart';
import '../dominio/regla_consumo.dart';

class RegistroViewModel extends ChangeNotifier {
  RegistroViewModel(this._repositorio, {DateTime Function()? reloj})
      : _reloj = reloj ?? DateTime.now;

  final ConsumoRepository _repositorio;
  final DateTime Function() _reloj;

  String laboratorio = laboratoriosUtez.first;
  bool cargando = false;
  String? error;
  List<Consumo> historial = [];

  Future<void> cambiarLaboratorio(String nuevo) async {
    laboratorio = nuevo;
    error = null;
    await _recargarHistorial();
  }

  /// Devuelve `true` si el consumo quedó guardado.
  Future<bool> guardar(String litrosTexto) async {
    final litros = double.tryParse(litrosTexto.trim().replaceAll(',', '.'));
    if (litros == null) {
      _mostrarError('Escribe los litros con número');
      return false;
    }

    final consumo = Consumo(
      laboratorio: laboratorio,
      litros: litros,
      fecha: _reloj(),
    );
    final motivo = ReglaConsumo.validar(consumo, hoy: _reloj());
    if (motivo != null) {
      _mostrarError(motivo);
      return false;
    }

    cargando = true;
    error = null;
    notifyListeners();

    await _repositorio.guardar(consumo);
    await _recargarHistorial();
    return true;
  }

  Future<void> _recargarHistorial() async {
    cargando = true;
    notifyListeners();
    historial = await _repositorio.listarPorLaboratorio(laboratorio);
    cargando = false;
    notifyListeners();
  }

  void _mostrarError(String mensaje) {
    error = mensaje;
    notifyListeners();
  }

  double get totalLitros => historial.fold(0, (suma, c) => suma + c.litros);
}
