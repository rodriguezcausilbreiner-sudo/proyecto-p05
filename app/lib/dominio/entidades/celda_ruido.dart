/// Celda geográfica (~110 m) con estadística agregada. El cliente nunca
/// recibe muestras crudas: el servidor ya oculta celdas con menos de
/// 5 muestras (RF-06), así que si esta clase existe, es representable.
class CeldaRuido {
  final double celdaLat;
  final double celdaLon;
  final double promedioDb;
  final double maximoDb;
  final int muestras;

  const CeldaRuido({
    required this.celdaLat,
    required this.celdaLon,
    required this.promedioDb,
    required this.maximoDb,
    required this.muestras,
  });

  /// Clasificación simple para colorear el mapa. Umbrales documentados
  /// en docs/decisiones.md junto con la calibración usada.
  NivelRuido get nivel {
    if (promedioDb >= -20) return NivelRuido.alto;
    if (promedioDb >= -40) return NivelRuido.medio;
    return NivelRuido.bajo;
  }
}

enum NivelRuido { bajo, medio, alto }
