import 'env_config.dart';

class ApiConfig {
  static String get baseUrl => EnvConfig.apiBaseUrl;
  static String get tenantId => EnvConfig.tenantId;

  // API Endpoints
  static String get authEndpoint => '/self/clients';
  static String get accountsEndpoint => '/self/clients';
  static String get savingsProductsEndpoint => '/savingsproducts';
  static String get savingsAccountsEndpoint => '/savingsaccounts';
  static String get clientsEndpoint => '/clients';
  static String get usersEndpoint => '/users';

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
}
