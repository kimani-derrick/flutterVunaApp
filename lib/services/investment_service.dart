import 'dart:convert';
import '../config/api_config.dart';
import 'http_client.dart';
import '../services/cache_service.dart';
import 'package:flutter/foundation.dart';

class InvestmentService {
  static final InvestmentService _instance = InvestmentService._internal();
  factory InvestmentService() => _instance;
  InvestmentService._internal();

  static final HttpClient _httpClient = HttpClient();
  static const String PRODUCTS_CACHE_KEY = 'investment_products';

  // Hardcoded API credentials (different from user login)
  static const String _apiUsername = 'mifos';
  static const String _apiPassword = 'password';

  static Future<List<Map<String, dynamic>>> getSavingsProducts() async {
    try {
      debugPrint('\n🔍 Checking investment products cache...');
      // Try to get cached data first
      final cachedProducts = await CacheService.getData(PRODUCTS_CACHE_KEY);
      if (cachedProducts != null) {
        debugPrint('✅ Using cached investment products');
        return List<Map<String, dynamic>>.from(cachedProducts);
      }

      debugPrint('🌐 Fetching investment products from API...');
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

      debugPrint('📡 API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        if (response.data is List) {
          final products = List<Map<String, dynamic>>.from(response.data);
          debugPrint('📦 Fetched ${products.length} investment products');

          // Cache the products
          debugPrint('💾 Caching investment products...');
          await CacheService.setData(PRODUCTS_CACHE_KEY, products);
          debugPrint('✅ Investment products cached successfully');

          return products;
        } else {
          throw Exception(
              'Invalid response format: expected a list of products');
        }
      } else {
        throw Exception(
            'Failed to load savings products: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error in investment products operation: $e');
      throw Exception('Error fetching savings products: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getAccountTransactions(
    String accountId, {
    DateTime? fromDate,
    DateTime? toDate,
    double? fromAmount,
    double? toAmount,
  }) async {
    try {
      await _httpClient.init();

      final apiCredentials =
          base64Encode(utf8.encode('$_apiUsername:$_apiPassword'));

      // Default to last 30 days if no dates provided
      final now = DateTime.now();
      final defaultFromDate = now.subtract(const Duration(days: 30));

      final queryParams = {
        'fromDate': (fromDate ?? defaultFromDate).toString().split(' ')[0],
        'toDate': (toDate ?? now).toString().split(' ')[0],
        'fromAmount': (fromAmount ?? 1).toString(),
        'toAmount': (toAmount ?? 50000000).toString(),
        'types': '1,2,3,4,20,21',
        'orderBy': 'createdDate,transactionDate,id',
        'sortOrder': 'DESC',
        'dateFormat': 'yyyy-MM-dd',
        'offset': '0',
        'limit': '5', // Limit to 5 transactions
      };

      final response = await _httpClient.get(
        '${ApiConfig.savingsAccountsEndpoint}/$accountId/transactions/search',
        queryParameters: queryParams,
        headers: {
          'Authorization': 'Basic $apiCredentials',
          'Fineract-Platform-TenantId': 'default',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      print('Transactions API Response: ${response.statusCode}');
      print('Transactions API Response Body: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          final content = response.data['content'];
          if (content is List) {
            return List<Map<String, dynamic>>.from(content);
          }
        }
        throw Exception(
            'Invalid response format: content field not found or not a list');
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Detailed error: $e');
      throw Exception('Error fetching transactions: $e');
    }
  }
}
