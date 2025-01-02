import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../core/security/credentials_manager.dart';
import 'http_client.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final HttpClient _httpClient = HttpClient();
  final CredentialsManager _credentialsManager = CredentialsManager();

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      debugPrint('🔐 Attempting login for user: $username');

      // Store credentials securely
      await _credentialsManager.storeCredentials(username, password);

      // Create basic auth header
      final credentials = base64Encode(utf8.encode('$username:$password'));
      final headers = {
        'Authorization': 'Basic $credentials',
        'fineract-platform-tenantid': ApiConfig.tenantId,
      };

      debugPrint('🌐 Making request to: ${ApiConfig.authUrl}');
      final response = await _httpClient.get(
        ApiConfig.authEndpoint,
        headers: headers,
      );

      debugPrint('📡 API Response Status Code: ${response.statusCode}');
      debugPrint('📦 API Response Body: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['totalFilteredRecords'] > 0 && data['pageItems'].isNotEmpty) {
          debugPrint(
              '✅ Login successful for user: ${data['pageItems'][0]['displayName']}');
          return {
            'success': true,
            'userData': data['pageItems'][0],
          };
        } else {
          debugPrint('⚠️ No user data found in response');
          return {
            'success': false,
            'error': 'Invalid credentials',
          };
        }
      } else {
        debugPrint('❌ Login failed with status code: ${response.statusCode}');
        return {
          'success': false,
          'error': 'Authentication failed',
        };
      }
    } catch (e) {
      debugPrint('🔥 Error during login: $e');
      String errorMessage = 'Network error occurred';
      if (e.toString().contains('SocketException')) {
        errorMessage =
            'Could not connect to server. Please check your internet connection.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Connection timed out. Please try again.';
      } else if (e.toString().contains('DioError')) {
        errorMessage = 'Server error. Please try again later.';
      }
      return {
        'success': false,
        'error': errorMessage,
      };
    }
  }

  Future<void> logout() async {
    await _credentialsManager.clearCredentials();
  }
}
