// CAPA: DATOS — servicio
// El detalle de un canal. Aquí fingimos una API que habla JSON y tarda.
// El repositorio lo usa. La pantalla y el ViewModel no saben que existe.

class ConsumoService {
  final List<Map<String, Object>> _servidor = [];

  Future<void> post(Map<String, Object> json) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _servidor.add(json);
  }

  Future<List<Map<String, Object>>> get(String laboratorio) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _servidor.where((j) => j['laboratorio'] == laboratorio).toList();
  }
}
