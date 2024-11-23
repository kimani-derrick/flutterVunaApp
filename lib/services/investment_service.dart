import 'dart:convert';
import 'package:http/http.dart' as http;

class InvestmentService {
  static const String baseUrl = 'https://api.vuna.io/fineract-provider/api/v1';
  
  // App Authentication (different from user authentication)
  static const String username = 'mifos';
  static const String password = 'password';
  
  // Generate base64 encoded credentials for app authentication
  static String get _appAuthToken {
    final credentials = base64Encode(utf8.encode('$username:$password'));
    return 'Basic $credentials';
  }

  static Map<String, String> get _headers => {
    'accept': 'application/json',
    'Authorization': _appAuthToken,
    'fineract-platform-tenantid': 'default',
  };

  static Future<List<Map<String, dynamic>>> getSavingsProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/savingsproducts'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load savings products');
      }
    } catch (e) {
      throw Exception('Error fetching savings products: $e');
    }
  }
}
