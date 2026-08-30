import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/red/cliente_dio.dart';
import '../../core/permisos/gestor_permisos.dart';
import '../../datos/datasources/api_ruido_datasource.dart';
import '../../datos/repositorios/repositorio_ruido_impl.dart';
import '../../datos/servicios/medidor_ruido.dart';
import '../../dominio/contratos/repositorio_ruido.dart';
import '../../dominio/casos_uso/obtener_mapa_ruido.dart';

final dioProvider = Provider<Dio>((ref) => ClienteDio.crear());

final apiRuidoDatasourceProvider = Provider<ApiRuidoDatasource>(
  (ref) => ApiRuidoDatasource(ref.watch(dioProvider)),
);

final repositorioRuidoProvider = Provider<RepositorioRuido>(
  (ref) => RepositorioRuidoImpl(ref.watch(apiRuidoDatasourceProvider)),
);

final obtenerMapaRuidoProvider = Provider<ObtenerMapaRuido>(
  (ref) => ObtenerMapaRuido(ref.watch(repositorioRuidoProvider)),
);

/// autoDispose: al salir de la pantalla se cancelan las suscripciones a
/// sensores automáticamente (criterio bloqueante de la rúbrica).
final medidorRuidoProvider = Provider.autoDispose<MedidorRuido>((ref) {
  final medidor = MedidorRuido(
    repositorio: ref.watch(repositorioRuidoProvider),
    permisos: GestorPermisos(),
  );
  ref.onDispose(() {
    medidor.detener();
    medidor.dispose();
  });
  return medidor;
});
