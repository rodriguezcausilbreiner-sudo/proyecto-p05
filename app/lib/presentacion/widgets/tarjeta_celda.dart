import 'package:flutter/material.dart';
import '../../dominio/entidades/celda_ruido.dart';

class TarjetaCelda extends StatelessWidget {
  final CeldaRuido celda;
  const TarjetaCelda({super.key, required this.celda});

  Color get _color => switch (celda.nivel) {
        NivelRuido.bajo => Colors.green,
        NivelRuido.medio => Colors.orange,
        NivelRuido.alto => Colors.red,
      };

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: _color, child: const Icon(Icons.graphic_eq, color: Colors.white)),
        title: Text('${celda.celdaLat.toStringAsFixed(3)}, ${celda.celdaLon.toStringAsFixed(3)}'),
        subtitle: Text('Promedio: ${celda.promedioDb.toStringAsFixed(1)} dBFS · Máx: ${celda.maximoDb.toStringAsFixed(1)} dBFS'),
        trailing: Text('${celda.muestras} muestras', style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }
}
