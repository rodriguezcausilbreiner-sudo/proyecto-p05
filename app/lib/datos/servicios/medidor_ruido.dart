import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../../core/errores/excepciones.dart';
import '../../core/permisos/gestor_permisos.dart';
import '../../dominio/contratos/repositorio_ruido.dart';
import '../../dominio/entidades/muestra_ruido.dart';
import 'loteador_muestras.dart';

const int _precisionMaximaAceptadaM = 40; // RF-02: sin ubicación fiable, se descarta
const int _nivelBateriaMinimo = 15; // RF-03

/// Orquesta la captura continua: arranca el grabador solo para leer
/// amplitud (no se sube audio, solo el nivel), sigue el GPS con
/// distanceFilter, vigila la batería y delega el envío en lotes de 20
/// al repositorio. Basado en el patrón de la guía didáctica del banco.
class MedidorRuido {
  final RepositorioRuido repositorio;
  final GestorPermisos permisos;
  final AudioRecorder _grabador;
  final Battery _bateria;
  final LoteadorMuestras _loteador;

  StreamSubscription<Amplitude>? _subAmplitud;
  StreamSubscription<Position>? _subPosicion;
  StreamSubscription<BatteryState>? _subBateria;
  Position? _ultimaPosicion;
  String? _sesionId;
  bool _activo = false;

  final _controladorEstado = StreamController<EstadoMedicion>.broadcast();
  Stream<EstadoMedicion> get estado => _controladorEstado.stream;

  MedidorRuido({
    required this.repositorio,
    GestorPermisos? permisos,
    AudioRecorder? grabador,
    Battery? bateria,
    LoteadorMuestras? loteador,
  })  : permisos = permisos ?? GestorPermisos(),
        _grabador = grabador ?? AudioRecorder(),
        _bateria = bateria ?? Battery(),
        _loteador = loteador ?? LoteadorMuestras(tamanoLote: 20);

  bool get activo => _activo;

  Future<void> iniciar() async {
    if (_activo) return;

    await permisos.asegurarMicrofono();
    await permisos.asegurarUbicacion();

    final nivelBateria = await _bateria.batteryLevel;
    if (nivelBateria < _nivelBateriaMinimo) {
      throw BateriaInsuficiente(nivelBateria);
    }

    _sesionId = await repositorio.abrirSesion();

    final directorioTemporal = await getTemporaryDirectory();
    await _grabador.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: '${directorioTemporal.path}/medicion_ruido.m4a',
    );

    _subPosicion = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 15, // RF-02
      ),
    ).listen((p) => _ultimaPosicion = p);

    _subAmplitud = _grabador
        .onAmplitudeChanged(const Duration(seconds: 3))
        .listen(_procesarAmplitud);

    // RF-03: corte automático por batería baja.
    _subBateria = _bateria.onBatteryStateChanged.listen((_) async {
      final nivel = await _bateria.batteryLevel;
      if (nivel < _nivelBateriaMinimo) {
        _controladorEstado.add(EstadoMedicion.bateriaBaja(nivel));
        await detener();
      }
    });

    _activo = true;
    _controladorEstado.add(const EstadoMedicion.capturando());
  }

  void _procesarAmplitud(Amplitude amplitud) {
    final posicion = _ultimaPosicion;
    if (posicion == null || posicion.accuracy > _precisionMaximaAceptadaM) {
      return; // RF-02: sin ubicación fiable, se descarta la muestra
    }

    final muestra = MuestraRuido(
      nivelDb: amplitud.current, // dBFS relativo, ver docs/decisiones.md
      latitud: posicion.latitude,
      longitud: posicion.longitude,
      precisionM: posicion.accuracy,
      medidoEn: DateTime.now().toUtc(),
    );

    final lote = _loteador.agregar(muestra);
    _controladorEstado.add(EstadoMedicion.muestraCapturada(_loteador.pendientes));

    if (lote != null) {
      unawaited(_enviarLote(lote));
    }
  }

  Future<void> _enviarLote(List<MuestraRuido> lote) async {
    final sesion = _sesionId;
    if (sesion == null) return;
    try {
      await repositorio.enviarLote(sesion, lote);
      _controladorEstado.add(EstadoMedicion.loteEnviado(lote.length));
    } on ErrorRed catch (e) {
      // No se pierde el lote: se reintenta en el próximo ciclo de
      // conectividad si el repositorio implementa cola local.
      _controladorEstado.add(EstadoMedicion.errorEnvio(e.toString()));
    }
  }

  Future<void> detener() async {
    if (!_activo) return;
    _activo = false;
    await _subAmplitud?.cancel();
    await _subPosicion?.cancel();
    await _subBateria?.cancel();
    await _grabador.stop();

    final restante = _loteador.vaciar();
    if (restante.isNotEmpty) {
      await _enviarLote(restante);
    }
    _controladorEstado.add(const EstadoMedicion.detenida());
  }

  void dispose() {
    _controladorEstado.close();
  }
}

/// Estados que la UI puede pintar sin acoplarse a los streams crudos.
/// Un solo tipo con un discriminador [tipo] en vez de una jerarquía
/// sellada: más simple de consumir desde providers y widgets externos.
enum TipoEstadoMedicion { capturando, muestraCapturada, loteEnviado, errorEnvio, bateriaBaja, detenida }

class EstadoMedicion {
  final TipoEstadoMedicion tipo;
  final int? cantidad;
  final String? mensaje;

  const EstadoMedicion._(this.tipo, {this.cantidad, this.mensaje});

  const EstadoMedicion.capturando() : this._(TipoEstadoMedicion.capturando);
  const EstadoMedicion.muestraCapturada(int pendientes)
      : this._(TipoEstadoMedicion.muestraCapturada, cantidad: pendientes);
  const EstadoMedicion.loteEnviado(int cantidadEnviada)
      : this._(TipoEstadoMedicion.loteEnviado, cantidad: cantidadEnviada);
  const EstadoMedicion.errorEnvio(String detalle)
      : this._(TipoEstadoMedicion.errorEnvio, mensaje: detalle);
  const EstadoMedicion.bateriaBaja(int nivel) : this._(TipoEstadoMedicion.bateriaBaja, cantidad: nivel);
  const EstadoMedicion.detenida() : this._(TipoEstadoMedicion.detenida);

  @override
  String toString() => 'EstadoMedicion($tipo, cantidad: $cantidad, mensaje: $mensaje)';
}
