import 'package:flutter/foundation.dart';

enum Environment {
  dev,
  staging,
  prod,
}

class EnvConfig {
  static late Environment _environment;
  static late String _apiBaseUrl;
  static late String _tenantId;

  // Initialize environment configuration
  static void initialize({
    required Environment env,
    required String apiBaseUrl,
    required String tenantId,
  }) {
    _environment = env;
    _apiBaseUrl = apiBaseUrl;
    _tenantId = tenantId;

    // Log configuration in debug mode only
    if (kDebugMode) {
      print('🔧 Environment: $_environment');
      print('🌐 API Base URL: $_apiBaseUrl');
      print('👤 Tenant ID: $_tenantId');
    }
  }

  // Getters
  static Environment get environment => _environment;
  static String get apiBaseUrl => _apiBaseUrl;
  static String get tenantId => _tenantId;
  static bool get isProduction => _environment == Environment.prod;
  static bool get isDevelopment => _environment == Environment.dev;
  static bool get isStaging => _environment == Environment.staging;
}
