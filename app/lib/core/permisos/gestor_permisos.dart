import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import '../errores/excepciones.dart';

/// Centraliza la solicitud de permisos para que ningún servicio los pida
/// por su cuenta con lógica distinta. Lanza excepciones de dominio en vez
/// de booleanos sueltos, para que la UI pueda mostrar un mensaje concreto.
class GestorPermisos {
  Future<void> asegurarMicrofono() async {
    final estado = await ph.Permission.microphone.request();
    if (!estado.isGranted) throw const SinPermisoMicrofono();
  }

  Future<void> asegurarUbicacion() async {
    final servicioActivo = await Geolocator.isLocationServiceEnabled();
    if (!servicioActivo) {
      throw const SinPermisoUbicacion('Activa el GPS del dispositivo para continuar.');
    }
    var permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }
    if (permiso == LocationPermission.denied || permiso == LocationPermission.deniedForever) {
      throw const SinPermisoUbicacion();
    }
  }
}
