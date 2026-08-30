import 'package:flutter_test/flutter_test.dart';
import 'package:p5_mapa_ruido/datos/servicios/loteador_muestras.dart';
import 'package:p5_mapa_ruido/dominio/entidades/muestra_ruido.dart';

MuestraRuido _muestra() => MuestraRuido(
      nivelDb: -35.2,
      latitud: 4.6486,
      longitud: -74.0844,
      precisionM: 8,
      medidoEn: DateTime.now().toUtc(),
    );

void main() {
  group('LoteadorMuestras', () {
    test('no devuelve lote antes de alcanzar el tamaño configurado', () {
      final loteador = LoteadorMuestras(tamanoLote: 20);
      for (var i = 0; i < 19; i++) {
        expect(loteador.agregar(_muestra()), isNull);
      }
      expect(loteador.pendientes, 19);
    });

    test('devuelve el lote completo al llegar a 20 muestras (RF-04)', () {
      final loteador = LoteadorMuestras(tamanoLote: 20);
      List<MuestraRuido>? lote;
      for (var i = 0; i < 20; i++) {
        lote = loteador.agregar(_muestra());
      }
      expect(lote, isNotNull);
      expect(lote!.length, 20);
      expect(loteador.pendientes, 0, reason: 'el buffer debe limpiarse tras emitir el lote');
    });

    test('vaciar() devuelve las muestras restantes sin exigir el tamaño completo', () {
      final loteador = LoteadorMuestras(tamanoLote: 20);
      loteador.agregar(_muestra());
      loteador.agregar(_muestra());
      final restante = loteador.vaciar();
      expect(restante.length, 2);
      expect(loteador.pendientes, 0);
    });
  });
}
