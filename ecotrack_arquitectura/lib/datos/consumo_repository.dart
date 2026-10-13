// CAPA: DATOS — el contrato
// Habla en lenguaje del dominio: guardar, listarPorLaboratorio.
// No dice "lista", ni "HTTP", ni "Firebase".

import '../dominio/consumo.dart';

abstract class ConsumoRepository {
  Future<void> guardar(Consumo consumo);

  Future<List<Consumo>> listarPorLaboratorio(String laboratorio);
}
