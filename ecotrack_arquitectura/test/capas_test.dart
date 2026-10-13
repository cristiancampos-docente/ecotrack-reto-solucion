// La recompensa de separar capas: la regla y el ViewModel se prueban
// sin abrir una pantalla y sin red.
//
//   flutter test

import 'package:ecotrack_arquitectura/datos/consumo_repository.dart';
import 'package:ecotrack_arquitectura/dominio/consumo.dart';
import 'package:ecotrack_arquitectura/dominio/regla_consumo.dart';
import 'package:ecotrack_arquitectura/presentacion/registro_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

class RepositorioEspia implements ConsumoRepository {
  final List<Consumo> guardados = [];

  @override
  Future<void> guardar(Consumo consumo) async => guardados.add(consumo);

  @override
  Future<List<Consumo>> listarPorLaboratorio(String laboratorio) async =>
      guardados.where((c) => c.laboratorio == laboratorio).toList();
}

void main() {
  final hoy = DateTime(2026, 9, 4, 10);

  group('Dominio: ReglaConsumo', () {
    Consumo con(double litros, {DateTime? fecha}) => Consumo(
          laboratorio: 'Lab Química',
          litros: litros,
          fecha: fecha ?? hoy,
        );

    test('acepta un consumo en rango', () {
      expect(ReglaConsumo.validar(con(12.5), hoy: hoy), isNull);
    });

    test('rechaza litros en cero', () {
      expect(ReglaConsumo.validar(con(0), hoy: hoy), isNotNull);
    });

    test('rechaza litros sobre el tope', () {
      expect(ReglaConsumo.validar(con(10001), hoy: hoy), isNotNull);
    });

    test('rechaza fecha futura', () {
      final manana = hoy.add(const Duration(days: 1));
      expect(ReglaConsumo.validar(con(5, fecha: manana), hoy: hoy), isNotNull);
    });
  });

  group('Presentación: RegistroViewModel', () {
    test('con litros válidos guarda en el repositorio y actualiza historial',
        () async {
      final repo = RepositorioEspia();
      final vm = RegistroViewModel(repo, reloj: () => hoy);

      final ok = await vm.guardar('12.5');

      expect(ok, isTrue);
      expect(repo.guardados, hasLength(1));
      expect(vm.historial.single.litros, 12.5);
      expect(vm.error, isNull);
    });

    test('con litros inválidos muestra error y no llama al repositorio',
        () async {
      final repo = RepositorioEspia();
      final vm = RegistroViewModel(repo, reloj: () => hoy);

      final ok = await vm.guardar('0');

      expect(ok, isFalse);
      expect(repo.guardados, isEmpty);
      expect(vm.error, isNotNull);
    });
  });
}
