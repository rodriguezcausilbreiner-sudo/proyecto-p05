import '../contratos/repositorio_ruido.dart';
import '../entidades/celda_ruido.dart';

class ObtenerMapaRuido {
  final RepositorioRuido repositorio;
  const ObtenerMapaRuido(this.repositorio);

  Future<List<CeldaRuido>> call() => repositorio.obtenerMapa();
}
