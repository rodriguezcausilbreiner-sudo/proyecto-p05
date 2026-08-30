import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/provider_mapa.dart';
import '../widgets/tarjeta_celda.dart';

class PaginaMapa extends ConsumerWidget {
  const PaginaMapa({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final celdasAsync = ref.watch(celdasRuidoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa agregado de ruido')),
      body: celdasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('No se pudo cargar el mapa: $err', textAlign: TextAlign.center),
          ),
        ),
        data: (celdas) {
          if (celdas.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Aún no hay celdas con al menos 5 muestras (RF-06).\nSigue capturando para verlas aquí.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(celdasRuidoProvider.future),
            child: ListView.builder(
              itemCount: celdas.length,
              itemBuilder: (context, i) => TarjetaCelda(celda: celdas[i]),
            ),
          );
        },
      ),
    );
  }
}
