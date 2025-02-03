import 'env_config.dart';
import 'dart:convert';

class ApiConfig {
  static const String baseUrl = 'https://api.vuna.io/fineract-provider/api/v1';
  static const String defaultUsername = 'mifos';
  static const String defaultPassword = 'password';
  static const String tenantId = 'default';

  // API Endpoints
  static String get authEndpoint => '/self/clients';
  static String get accountsEndpoint => '/self/clients';
  static String get savingsProductsEndpoint => '/savingsproducts';
  static String get savingsAccountsEndpoint => '/savingsaccounts';
  static String get clientsEndpoint => '/clients';
  static String get usersEndpoint => '/users';
  static String get productsEndpoint => '/products';

  // Full URLs
  static String getAccountsUrl(String clientId) =>
      '$baseUrl$accountsEndpoint/$clientId/accounts';
  static String get savingsProductsUrl => '$baseUrl$savingsProductsEndpoint';
  static String get authUrl => '$baseUrl$authEndpoint';

  // API Versions
  static const String apiVersion = 'v1';

  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Headers
  static Map<String, String> get defaultHeaders => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'fineract-platform-tenantid': tenantId,
      };

  // Rate Limiting
  static const int maxRequestsPerMinute = 60;

  static String getBasicAuth(String username, String password) {
    return base64.encode(utf8.encode('$username:$password'));
  }

  static Map<String, String> getHeaders(String username, String password) {
    return {
      'accept': 'application/json',
      'content-type': 'application/json',
      'Authorization': 'Basic ${getBasicAuth(username, password)}',
      'fineract-platform-tenantid': tenantId,
    };
  }
}
