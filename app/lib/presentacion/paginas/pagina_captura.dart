import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/provider_captura.dart';
import '../providers/provider_mapa.dart';
import 'pagina_mapa.dart';

class PaginaCaptura extends ConsumerWidget {
  const PaginaCaptura({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(controladorCapturaProvider);
    final controlador = ref.read(controladorCapturaProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('P5 · Mapa colaborativo de ruido'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            tooltip: 'Ver mapa agregado',
            onPressed: () {
              ref.invalidate(celdasRuidoProvider);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaginaMapa()));
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                estado.capturando ? Icons.mic : Icons.mic_none,
                size: 96,
                color: estado.capturando ? Colors.red : Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                estado.capturando ? 'Capturando ruido…' : 'Captura detenida',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text('Muestras pendientes en el lote: ${estado.muestrasPendientes} / 20'),
              Text('Lotes enviados: ${estado.lotesEnviados}'),
              if (estado.mensaje != null) ...[
                const SizedBox(height: 12),
                Text(estado.mensaje!, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
              ],
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: controlador.alternar,
                icon: Icon(estado.capturando ? Icons.stop : Icons.play_arrow),
                label: Text(estado.capturando ? 'Detener' : 'Iniciar captura'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
