/// Entidad pura de dominio: sin dependencias de Flutter, Dio ni SQLite.
/// nivelDb es dBFS (relativo al máximo del conversor del micrófono, no
/// dB SPL absoluto — ver limitación declarada en docs/decisiones.md).
class MuestraRuido {
  final double nivelDb;
  final double latitud;
  final double longitud;
  final double? precisionM;
  final DateTime medidoEn;

  const MuestraRuido({
    required this.nivelDb,
    required this.latitud,
    required this.longitud,
    this.precisionM,
    required this.medidoEn,
  });
}
