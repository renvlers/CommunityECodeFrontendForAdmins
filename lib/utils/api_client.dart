import 'package:dio/dio.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  late Dio _dio;
  String _baseUrl = "http://localhost:8888";
  // String _baseUrl = "http://10.244.43.140:8888";

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 300),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
  }

  Dio get dio => _dio;

  void updateBaseUrl(String newBaseUrl) {
    _baseUrl = newBaseUrl;
    _dio.options.baseUrl = newBaseUrl;
  }
}
