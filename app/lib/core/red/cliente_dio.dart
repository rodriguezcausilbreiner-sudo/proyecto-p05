import 'package:dio/dio.dart';

/// Configuración única del cliente HTTP. En un emulador Android, la API
/// local se ve en 10.0.2.2; en dispositivo físico, usa la IP de tu equipo
/// en la red del laboratorio (ver README).
class ClienteDio {
  static Dio crear({String baseUrl = 'http://10.0.2.2:3000/api'}) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => null, // silenciado en release; útil en debug con print
    ));

    return dio;
  }
}
