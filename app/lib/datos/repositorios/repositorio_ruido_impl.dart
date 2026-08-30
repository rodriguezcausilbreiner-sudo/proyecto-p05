import '../../dominio/contratos/repositorio_ruido.dart';
import '../../dominio/entidades/muestra_ruido.dart';
import '../../dominio/entidades/celda_ruido.dart';
import '../datasources/api_ruido_datasource.dart';
import '../modelos/muestra_ruido_modelo.dart';

class RepositorioRuidoImpl implements RepositorioRuido {
  final ApiRuidoDatasource datasource;
  const RepositorioRuidoImpl(this.datasource);

  @override
  Future<String> abrirSesion() => datasource.crearSesion();

  @override
  Future<void> enviarLote(String sesionId, List<MuestraRuido> muestras) {
    final modelos = muestras.map(MuestraRuidoModelo.desdeEntidad).toList();
    return datasource.enviarLote(sesionId, modelos);
  }

  @override
  Future<List<CeldaRuido>> obtenerMapa() => datasource.obtenerMapa();
}
