import '../../dominio/entidades/muestra_ruido.dart';

/// Acumula muestras y decide cuándo el lote está listo para enviarse.
/// Se separa del servicio de hardware (MedidorRuido) a propósito: esta
/// clase no importa nada de sensors_plus/geolocator/record, así que
/// corre en `flutter test` sin dispositivo físico (RF-04, criterio de
/// "pruebas que corren sin dispositivo" de la rúbrica).
class LoteadorMuestras {
  final int tamanoLote;
  final List<MuestraRuido> _pendientes = [];

  LoteadorMuestras({this.tamanoLote = 20});

  int get pendientes => _pendientes.length;

  /// Agrega una muestra y devuelve el lote completo si alcanzó el tamaño
  /// configurado; en ese caso también limpia el buffer interno.
  List<MuestraRuido>? agregar(MuestraRuido muestra) {
    _pendientes.add(muestra);
    if (_pendientes.length >= tamanoLote) {
      final lote = List<MuestraRuido>.unmodifiable(_pendientes);
      _pendientes.clear();
      return lote;
    }
    return null;
  }

  /// Vacía el buffer sin exigir que esté lleno (por ejemplo, al detener
  /// la captura manualmente).
  List<MuestraRuido> vaciar() {
    final restante = List<MuestraRuido>.unmodifiable(_pendientes);
    _pendientes.clear();
    return restante;
  }
}
