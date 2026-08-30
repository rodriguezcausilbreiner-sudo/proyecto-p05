import 'package:dio/dio.dart';
import '../../core/errores/excepciones.dart';
import '../modelos/muestra_ruido_modelo.dart';
import '../modelos/celda_ruido_modelo.dart';

/// Única clase que sabe que existe una API REST. Si mañana cambia de Dio
/// a otro cliente HTTP, solo se toca este archivo.
class ApiRuidoDatasource {
  final Dio dio;
  const ApiRuidoDatasource(this.dio);

  Future<String> crearSesion() async {
    try {
      final r = await dio.post('/sesiones');
      return r.data['sesionId'] as String;
    } on DioException catch (e) {
      throw ErrorRed(_mensajeDe(e));
    }
  }

  Future<void> enviarLote(String sesionId, List<MuestraRuidoModelo> muestras) async {
    try {
      await dio.post('/muestras/lote', data: {
        'sesionId': sesionId,
        'muestras': muestras.map((m) => m.aJson()).toList(),
      });
    } on DioException catch (e) {
      throw ErrorRed(_mensajeDe(e));
    }
  }

  Future<List<CeldaRuidoModelo>> obtenerMapa() async {
    try {
      final r = await dio.get('/mapa');
      final celdas = (r.data['celdas'] as List).cast<Map<String, dynamic>>();
      return celdas.map(CeldaRuidoModelo.desdeJson).toList();
    } on DioException catch (e) {
      throw ErrorRed(_mensajeDe(e));
    }
  }

  String _mensajeDe(DioException e) {
    if (e.response?.data is Map && e.response?.data['error'] != null) {
      return e.response!.data['error'] as String;
    }
    return e.message ?? 'Error de red desconocido';
  }
}
