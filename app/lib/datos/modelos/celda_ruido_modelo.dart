import '../../dominio/entidades/celda_ruido.dart';

class CeldaRuidoModelo extends CeldaRuido {
  const CeldaRuidoModelo({
    required super.celdaLat,
    required super.celdaLon,
    required super.promedioDb,
    required super.maximoDb,
    required super.muestras,
  });

  factory CeldaRuidoModelo.desdeJson(Map<String, dynamic> json) => CeldaRuidoModelo(
        celdaLat: (json['celdaLat'] as num).toDouble(),
        celdaLon: (json['celdaLon'] as num).toDouble(),
        promedioDb: (json['promedioDb'] as num).toDouble(),
        maximoDb: (json['maximoDb'] as num).toDouble(),
        muestras: json['muestras'] as int,
      );
}
