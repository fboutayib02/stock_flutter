import 'package:dio/dio.dart';

/// Appel HTTP via dio (conseil éco-conduite, API publique).
class EcoTipRemoteDataSource {
  EcoTipRemoteDataSource(this._dio);

  final Dio _dio;

  static const _url = 'https://api.adviceslip.com/advice';

  Future<String> fetchAdvice() async {
    final response = await _dio.get<Map<String, dynamic>>(_url);
    final slip = response.data?['slip'] as Map<String, dynamic>?;
    final advice = slip?['advice'] as String?;
    if (advice == null || advice.isEmpty) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Réponse API invalide',
      );
    }
    return advice;
  }
}
