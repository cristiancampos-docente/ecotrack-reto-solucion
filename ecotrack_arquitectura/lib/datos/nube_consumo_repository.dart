// CAPA: DATOS — implementación de mañana
// Cumple el MISMO contrato, pero traduce Consumo <-> JSON y usa el servicio.
// Enchufarla solo requiere cambiar una línea en main.dart.

import '../dominio/consumo.dart';
import 'consumo_repository.dart';
import 'consumo_service.dart';

class NubeConsumoRepository implements ConsumoRepository {
  NubeConsumoRepository(this._service);

  final ConsumoService _service;

  @override
  Future<void> guardar(Consumo consumo) {
    return _service.post({
      'laboratorio': consumo.laboratorio,
      'litros': consumo.litros,
      'fecha': consumo.fecha.toIso8601String(),
    });
  }

  @override
  Future<List<Consumo>> listarPorLaboratorio(String laboratorio) async {
    final filas = await _service.get(laboratorio);
    return filas
        .map(
          (j) => Consumo(
            laboratorio: j['laboratorio']! as String,
            litros: (j['litros']! as num).toDouble(),
            fecha: DateTime.parse(j['fecha']! as String),
          ),
        )
        .toList();
  }
}
