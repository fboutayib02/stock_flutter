import 'package:dio/dio.dart';

/// Client HTTP (dio) — prêt pour une API REST future (ex. taux carburant).
Dio createDioClient({String baseUrl = 'https://api.example.com'}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );
  dio.interceptors.add(
    LogInterceptor(requestBody: true, responseBody: true),
  );
  return dio;
}
