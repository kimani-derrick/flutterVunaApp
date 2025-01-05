import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../models/product_model.dart';
import 'http_client.dart';

class MarketplaceService {
  static final MarketplaceService _instance = MarketplaceService._internal();
  factory MarketplaceService() => _instance;
  MarketplaceService._internal();

  static final HttpClient _httpClient = HttpClient();

  static Future<List<ProductModel>> getProducts() async {
    try {
      debugPrint('\n🛍️ Fetching marketplace products...');
      await _httpClient.init();

      final apiCredentials = base64.encode(utf8.encode('mifos:password'));

      final response = await _httpClient.get(
        ApiConfig.savingsProductsEndpoint,
        headers: {
          'Authorization': 'Basic $apiCredentials',
          'Fineract-Platform-TenantId': 'default',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('📡 Products API Response: ${response.statusCode}');
      debugPrint('📦 Products API Response Body: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data is List) {
          return List<ProductModel>.from(
            response.data.map((item) => ProductModel(
                  id: (item['id'] as num).toInt(),
                  name: item['name'] as String,
                  description:
                      item['description'] ?? 'No description available',
                  price: (item['minDepositAmount'] ?? 0.0).toDouble(),
                  imageUrl: _getImageForProduct(item['name'] as String),
                  category: _getCategoryForProduct(item['name'] as String),
                  isAvailable: true,
                  rating: 4.5 + (item['id'] % 5) * 0.1,
                  reviewCount: 100 + ((item['id'] as num).toInt() * 23) % 400,
                  features: _getFeaturesForProduct(item),
                )),
          );
        } else {
          throw Exception(
              'Invalid response format: expected a list of products');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching products: $e');
      return _getMockProducts();
    }
  }

  static String _getImageForProduct(String productName) {
    if (productName.toLowerCase().contains('savings')) {
      return 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-4.0.3&q=85&w=1600&auto=format';
    } else if (productName.toLowerCase().contains('loan')) {
      return 'https://images.unsplash.com/photo-1556742111-a301076d9d18?ixlib=rb-4.0.3&q=85&w=1600&auto=format';
    } else if (productName.toLowerCase().contains('investment')) {
      return 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?ixlib=rb-4.0.3&q=85&w=1600&auto=format';
    } else if (productName.toLowerCase().contains('fixed')) {
      return 'https://images.unsplash.com/photo-1565514020179-026b92b84bb6?ixlib=rb-4.0.3&q=85&w=1600&auto=format';
    } else if (productName.toLowerCase().contains('education')) {
      return 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?ixlib=rb-4.0.3&q=85&w=1600&auto=format';
    } else {
      return 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-4.0.3&q=85&w=1600&auto=format';
    }
  }

  static String _getCategoryForProduct(String productName) {
    if (productName.toLowerCase().contains('savings')) {
      return 'Savings';
    } else if (productName.toLowerCase().contains('loan')) {
      return 'Loans';
    } else if (productName.toLowerCase().contains('investment')) {
      return 'Investments';
    } else if (productName.toLowerCase().contains('fixed')) {
      return 'Deposits';
    } else if (productName.toLowerCase().contains('education')) {
      return 'Education';
    } else {
      return 'Other';
    }
  }

  static List<String> _getFeaturesForProduct(Map<String, dynamic> product) {
    List<String> features = [];

    if (product['nominalAnnualInterestRate'] != null) {
      features
          .add('${product['nominalAnnualInterestRate']}% annual interest rate');
    }

    if (product['minDepositAmount'] != null) {
      features.add('Minimum deposit: KES ${product['minDepositAmount']}');
    }

    if (product['interestCompoundingPeriodType'] != null &&
        product['interestCompoundingPeriodType']['value'] != null) {
      features.add(
          '${product['interestCompoundingPeriodType']['value']} compounding');
    }

    if (features.isEmpty) {
      features = ['Flexible terms', 'No hidden fees', 'Quick processing'];
    }

    return features;
  }

  static List<ProductModel> _getMockProducts() {
    return [
      ProductModel(
        id: 1,
        name: 'Premium Savings Account',
        description:
            'High-yield savings account with competitive interest rates',
        price: 0,
        imageUrl:
            'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-4.0.3&q=85&w=1600&auto=format',
        category: 'Savings',
        isAvailable: true,
        rating: 4.8,
        reviewCount: 245,
        features: [
          'No minimum balance',
          '5% annual interest',
          'Free transfers'
        ],
      ),
      ProductModel(
        id: 2,
        name: 'Business Loan',
        description: 'Flexible business loans for your growing enterprise',
        price: 10000,
        imageUrl:
            'https://images.unsplash.com/photo-1556742111-a301076d9d18?ixlib=rb-4.0.3&q=85&w=1600&auto=format',
        category: 'Loans',
        isAvailable: true,
        rating: 4.5,
        reviewCount: 189,
        features: ['Low interest rates', 'Quick approval', 'Flexible terms'],
      ),
      ProductModel(
        id: 3,
        name: 'Investment Fund',
        description: 'Diversified investment portfolio managed by experts',
        price: 5000,
        imageUrl:
            'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?ixlib=rb-4.0.3&q=85&w=1600&auto=format',
        category: 'Investments',
        isAvailable: true,
        rating: 4.7,
        reviewCount: 312,
        features: [
          'Professional management',
          'Diversified portfolio',
          'Regular returns'
        ],
      ),
      ProductModel(
        id: 4,
        name: 'Fixed Deposit',
        description: 'Secure your money with guaranteed returns',
        price: 1000,
        imageUrl:
            'https://images.unsplash.com/photo-1565514020179-026b92b84bb6?ixlib=rb-4.0.3&q=85&w=1600&auto=format',
        category: 'Deposits',
        isAvailable: true,
        rating: 4.9,
        reviewCount: 423,
        features: ['High interest rates', 'Flexible tenure', 'Safe investment'],
      ),
      ProductModel(
        id: 5,
        name: 'Education Savings Plan',
        description: 'Plan for your children\'s future education',
        price: 2000,
        imageUrl:
            'https://images.unsplash.com/photo-1523240795612-9a054b0db644?ixlib=rb-4.0.3&q=85&w=1600&auto=format',
        category: 'Education',
        isAvailable: true,
        rating: 4.6,
        reviewCount: 156,
        features: [
          'Tax benefits',
          'Insurance coverage',
          'Flexible withdrawals'
        ],
      ),
      ProductModel(
        id: 6,
        name: 'Retirement Plan',
        description: 'Secure your golden years with our retirement plans',
        price: 3000,
        imageUrl:
            'https://images.unsplash.com/photo-1556742205-e7edb6e8e036?ixlib=rb-4.0.3&q=85&w=1600&auto=format',
        category: 'Retirement',
        isAvailable: true,
        rating: 4.7,
        reviewCount: 289,
        features: ['Regular pension', 'Life coverage', 'Tax savings'],
      ),
    ];
  }
}
