import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dominio/entidades/celda_ruido.dart';
import 'proveedores_nucleo.dart';

final celdasRuidoProvider = FutureProvider.autoDispose<List<CeldaRuido>>((ref) async {
  final obtenerMapa = ref.watch(obtenerMapaRuidoProvider);
  return obtenerMapa();
});
