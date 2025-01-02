import 'dart:convert';
import '../config/api_config.dart';
import 'http_client.dart';

class InvestmentService {
  static final InvestmentService _instance = InvestmentService._internal();
  factory InvestmentService() => _instance;
  InvestmentService._internal();

  static final HttpClient _httpClient = HttpClient();

  // Hardcoded API credentials (different from user login)
  static const String _apiUsername = 'mifos';
  static const String _apiPassword = 'password';

  static Future<List<Map<String, dynamic>>> getSavingsProducts() async {
    try {
      // Initialize the HTTP client if not already initialized
      await _httpClient.init();

      // Create API auth header with hardcoded credentials
      final apiCredentials =
          base64Encode(utf8.encode('$_apiUsername:$_apiPassword'));

      final response = await _httpClient.get(
        ApiConfig.savingsProductsEndpoint,
        headers: {
          'Authorization': 'Basic $apiCredentials',
          'Fineract-Platform-TenantId': 'default',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      print('Savings API Response: ${response.statusCode}');
      print('Savings API Response Body: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data is List) {
          return List<Map<String, dynamic>>.from(response.data);
        } else {
          throw Exception(
              'Invalid response format: expected a list of products');
        }
      } else {
        throw Exception(
            'Failed to load savings products: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Detailed error: $e');
      throw Exception('Error fetching savings products: $e');
    }
  }
}
