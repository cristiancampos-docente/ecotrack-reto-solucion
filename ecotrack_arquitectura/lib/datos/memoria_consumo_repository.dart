// CAPA: DATOS — implementación de hoy
// Una lista en memoria. Cumple el contrato; nadie arriba sabe que es una lista.

import '../dominio/consumo.dart';
import 'consumo_repository.dart';

class MemoriaConsumoRepository implements ConsumoRepository {
  final List<Consumo> _consumos = [];

  @override
  Future<void> guardar(Consumo consumo) async {
    _consumos.add(consumo);
  }

  @override
  Future<List<Consumo>> listarPorLaboratorio(String laboratorio) async {
    return _consumos.where((c) => c.laboratorio == laboratorio).toList();
  }
}
