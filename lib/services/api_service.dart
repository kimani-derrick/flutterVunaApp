import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  static const String baseUrl = 'https://api.vuna.io/fineract-provider/api/v1';
  static const String tenantId = 'default';

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      debugPrint('🔐 Attempting login for user: $username');
      
      final credentials = base64.encode(utf8.encode('$username:$password'));
      final response = await http.get(
        Uri.parse('$baseUrl/self/clients'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Basic $credentials',
          'fineract-platform-tenantid': tenantId,
        },
      );

      debugPrint('📡 API Response Status Code: ${response.statusCode}');
      debugPrint('📦 API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['totalFilteredRecords'] > 0 && data['pageItems'].isNotEmpty) {
          debugPrint('✅ Login successful for user: ${data['pageItems'][0]['displayName']}');
          return {
            'success': true,
            'userData': data['pageItems'][0],
          };
        } else {
          debugPrint('⚠️ No user data found in response');
          return {
            'success': false,
            'error': 'No user data found',
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
      return {
        'success': false,
        'error': 'Network error occurred',
      };
    }
  }
}
