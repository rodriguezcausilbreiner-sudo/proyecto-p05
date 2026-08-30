import '../entidades/muestra_ruido.dart';
import '../entidades/celda_ruido.dart';

/// La capa de presentación y los casos de uso dependen de esta interfaz,
/// nunca de la implementación con Dio. Así, las pruebas pueden usar un
/// repositorio falso sin tocar la red.
abstract class RepositorioRuido {
  Future<String> abrirSesion();
  Future<void> enviarLote(String sesionId, List<MuestraRuido> muestras);
  Future<List<CeldaRuido>> obtenerMapa();
}
