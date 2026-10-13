// CAPA: DOMINIO
// "¿Dónde vive litros > 0?" -> aquí, y en ningún otro lugar.
// El formulario, el historial y la meta preguntan a esta regla.

import 'consumo.dart';

class ReglaConsumo {
  static const topeLitros = 10000.0;

  /// Devuelve el motivo del rechazo, o `null` si el consumo es aceptable.
  static String? validar(Consumo consumo, {required DateTime hoy}) {
    if (consumo.laboratorio.trim().isEmpty) {
      return 'El laboratorio es obligatorio';
    }
    if (consumo.litros <= 0) {
      return 'Los litros deben ser mayores que cero';
    }
    if (consumo.litros > topeLitros) {
      return 'Los litros superan el tope de ${topeLitros.toStringAsFixed(0)}';
    }
    if (consumo.fecha.isAfter(hoy)) {
      return 'La fecha no puede ser futura';
    }
    return null;
  }
}
