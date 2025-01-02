import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../config/api_config.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;
  HttpClient._internal();

  final Dio _dio = Dio();
  final Logger _logger = Logger();

  Future<void> init() async {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.connectTimeout =
        Duration(milliseconds: ApiConfig.connectionTimeout);
    _dio.options.receiveTimeout =
        Duration(milliseconds: ApiConfig.receiveTimeout);
    _dio.options.headers = ApiConfig.defaultHeaders;

    // Add interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        _logger.i('Making request to: ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.i('📡 API Response Status Code: ${response.statusCode}');
        _logger.i('📦 API Response Body: ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) {
        _logger.e('❌ API Error: ${error.message}');
        return handler.next(error);
      },
    ));
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? headers}) async {
    try {
      if (headers != null) {
        _dio.options.headers.addAll(headers);
      }
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      _logger.e('GET request failed: $e');
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      _logger.e('POST request failed: $e');
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      _logger.e('PUT request failed: $e');
      rethrow;
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } catch (e) {
      _logger.e('DELETE request failed: $e');
      rethrow;
    }
  }
}
