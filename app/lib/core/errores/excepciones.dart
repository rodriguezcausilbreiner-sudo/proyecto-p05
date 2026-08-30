/// Excepciones propias del dominio. Se lanzan cuando un caso límite de
/// hardware o permisos impide continuar, para que la capa de presentación
/// decida cómo degradar la experiencia sin cerrar la app (regla del banco:
/// "la aplicación no puede cerrarse ni quedar en blanco").
library;

class SinPermisoMicrofono implements Exception {
  final String mensaje;
  const SinPermisoMicrofono([this.mensaje = 'Se requiere permiso de micrófono para medir el ruido.']);
  @override
  String toString() => mensaje;
}

class SinPermisoUbicacion implements Exception {
  final String mensaje;
  const SinPermisoUbicacion([this.mensaje = 'Se requiere permiso de ubicación para georreferenciar las muestras.']);
  @override
  String toString() => mensaje;
}

class BateriaInsuficiente implements Exception {
  final int nivelActual;
  const BateriaInsuficiente(this.nivelActual);
  @override
  String toString() => 'Batería insuficiente ($nivelActual%). Captura suspendida (RF-03).';
}

class ErrorRed implements Exception {
  final String mensaje;
  const ErrorRed(this.mensaje);
  @override
  String toString() => mensaje;
}
