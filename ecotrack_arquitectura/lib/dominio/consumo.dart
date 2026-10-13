// CAPA: DOMINIO
// Prueba en voz alta: "si apago Flutter, ¿esta clase sigue teniendo sentido?".
// Sí. Por eso no importa package:flutter.

const laboratoriosUtez = ['Lab Química', 'Lab Redes', 'Lab Física'];

class Consumo {
  const Consumo({
    required this.laboratorio,
    required this.litros,
    required this.fecha,
  });

  final String laboratorio;
  final double litros;
  final DateTime fecha;
}
