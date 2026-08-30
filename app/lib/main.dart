import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentacion/paginas/pagina_captura.dart';

void main() {
  runApp(const ProviderScope(child: AppMapaRuido()));
}

class AppMapaRuido extends StatelessWidget {
  const AppMapaRuido({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'P5 · Mapa colaborativo de ruido',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const PaginaCaptura(),
    );
  }
}
