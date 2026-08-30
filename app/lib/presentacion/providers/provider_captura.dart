import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../datos/servicios/medidor_ruido.dart';
import 'proveedores_nucleo.dart';

class EstadoCaptura {
  final bool capturando;
  final int muestrasPendientes;
  final int lotesEnviados;
  final String? mensaje;

  const EstadoCaptura({
    this.capturando = false,
    this.muestrasPendientes = 0,
    this.lotesEnviados = 0,
    this.mensaje,
  });

  EstadoCaptura copiarCon({
    bool? capturando,
    int? muestrasPendientes,
    int? lotesEnviados,
    String? mensaje,
  }) =>
      EstadoCaptura(
        capturando: capturando ?? this.capturando,
        muestrasPendientes: muestrasPendientes ?? this.muestrasPendientes,
        lotesEnviados: lotesEnviados ?? this.lotesEnviados,
        mensaje: mensaje,
      );
}

class ControladorCaptura extends StateNotifier<EstadoCaptura> {
  final MedidorRuido medidor;

  ControladorCaptura(this.medidor) : super(const EstadoCaptura()) {
    medidor.estado.listen(_reaccionar);
  }

  Future<void> alternar() async {
    if (state.capturando) {
      await medidor.detener();
    } else {
      try {
        await medidor.iniciar();
      } catch (e) {
        state = state.copiarCon(mensaje: e.toString());
      }
    }
  }

  void _reaccionar(EstadoMedicion evento) {
    switch (evento.tipo) {
      case TipoEstadoMedicion.capturando:
        state = state.copiarCon(capturando: true, mensaje: 'Captura iniciada');
      case TipoEstadoMedicion.detenida:
        state = state.copiarCon(capturando: false, mensaje: 'Captura detenida');
      case TipoEstadoMedicion.muestraCapturada:
        state = state.copiarCon(muestrasPendientes: evento.cantidad, mensaje: null);
      case TipoEstadoMedicion.loteEnviado:
        state = state.copiarCon(
          muestrasPendientes: 0,
          lotesEnviados: state.lotesEnviados + 1,
          mensaje: 'Lote de ${evento.cantidad} muestras enviado',
        );
      case TipoEstadoMedicion.errorEnvio:
        state = state.copiarCon(mensaje: 'Error al enviar: ${evento.mensaje}');
      case TipoEstadoMedicion.bateriaBaja:
        state = state.copiarCon(mensaje: 'Batería baja (${evento.cantidad}%): captura detenida');
    }
  }
}

final controladorCapturaProvider =
    StateNotifierProvider.autoDispose<ControladorCaptura, EstadoCaptura>((ref) {
  return ControladorCaptura(ref.watch(medidorRuidoProvider));
});
