import '../../dominio/entidades/muestra_ruido.dart';

class MuestraRuidoModelo extends MuestraRuido {
  const MuestraRuidoModelo({
    required super.nivelDb,
    required super.latitud,
    required super.longitud,
    super.precisionM,
    required super.medidoEn,
  });

  Map<String, dynamic> aJson() => {
        'nivelDb': nivelDb,
        'latitud': latitud,
        'longitud': longitud,
        'precisionM': precisionM,
        'medidoEn': medidoEn.toUtc().toIso8601String(),
      };

  factory MuestraRuidoModelo.desdeEntidad(MuestraRuido m) => MuestraRuidoModelo(
        nivelDb: m.nivelDb,
        latitud: m.latitud,
        longitud: m.longitud,
        precisionM: m.precisionM,
        medidoEn: m.medidoEn,
      );
}
