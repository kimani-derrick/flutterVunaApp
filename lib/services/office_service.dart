import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class OfficeService {
  static const String baseUrl = 'https://api.vuna.io/fineract-provider/api/v1';
  static const String appUsername = 'mifos';
  static const String appPassword = 'password';

  static Future<List<Map<String, dynamic>>> getAllOffices(
    String username,
    String password,
  ) async {
    final url = '${ApiConfig.baseUrl}/offices';
    final credentials = ApiConfig.getBasicAuth(username, password);

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Basic $credentials',
          'fineract-platform-tenantid': 'default',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> officesJson = json.decode(response.body);
        return officesJson.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch offices: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching offices: $e');
    }
  }

  static Future<Map<String, dynamic>> getOfficeDetails(
    String username,
    String password,
    String officeId,
  ) async {
    final url = '${ApiConfig.baseUrl}/offices/$officeId';
    final credentials = ApiConfig.getBasicAuth(username, password);

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Basic $credentials',
          'fineract-platform-tenantid': 'default',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception(
            'Failed to fetch office details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching office details: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getOfficeGroups(
      String officeId) async {
    try {
      final credentials =
          base64.encode(utf8.encode('$appUsername:$appPassword'));
      final url = '$baseUrl/groups?officeId=$officeId';

      debugPrint('\n🔍 Fetching groups for office $officeId...');
      debugPrint('URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Basic $credentials',
          'fineract-platform-tenantid': 'default',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> groups = json.decode(response.body);
        debugPrint('✅ Successfully fetched ${groups.length} groups for office');
        return groups.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load office groups: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching office groups: $e');
      rethrow;
    }
  }

  static Future<void> transferClient({
    required String clientId,
    required String destinationOfficeId,
    String? staffId,
  }) async {
    try {
      final credentials =
          base64.encode(utf8.encode('$appUsername:$appPassword'));
      final url = '$baseUrl/clients/$clientId?command=proposeAndAcceptTransfer';

      debugPrint('\n🔄 Initiating client transfer...');
      debugPrint('URL: $url');

      final Map<String, dynamic> payload = {
        'destinationOfficeId': destinationOfficeId,
        if (staffId != null) 'staffId': staffId,
      };

      debugPrint('\n📤 Request Details:');
      debugPrint('Headers: {');
      debugPrint('  accept: application/json');
      debugPrint('  content-type: application/json');
      debugPrint(
          '  Authorization: Basic ${credentials.substring(0, 10)}... (truncated)');
      debugPrint('  fineract-platform-tenantid: default');
      debugPrint('}');

      debugPrint('\n📦 Sample Payload Structure:');
      debugPrint('''
{
  "destinationOfficeId": "$destinationOfficeId"  // ID of the office to transfer to
  ${staffId != null ? ',\n  "staffId": "$staffId"  // Optional: ID of staff member' : ''}
}''');

      debugPrint('\n📤 Actual Raw Payload Being Sent:');
      debugPrint(const JsonEncoder.withIndent('  ').convert(payload));

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'Authorization': 'Basic $credentials',
          'fineract-platform-tenantid': 'default',
        },
        body: json.encode(payload),
      );

      debugPrint('\n📥 Response Details:');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Raw Response Body: ${response.body}');
      debugPrint('Response Headers: ${response.headers}');

      if (response.statusCode == 200) {
        debugPrint('✅ Client transfer successful');
        return;
      }

      // If we get here, there was an error
      Map<String, dynamic>? errorBody;
      try {
        errorBody = json.decode(response.body) as Map<String, dynamic>;
        debugPrint('Parsed Error Body: $errorBody');
      } catch (e) {
        debugPrint('Failed to parse error response: $e');
      }

      final errorMessage = errorBody?['errors']?[0]?['defaultUserMessage'] ??
          errorBody?['defaultUserMessage'] ??
          'Server returned status code: ${response.statusCode}';

      debugPrint('❌ Transfer failed: $errorMessage');
      throw Exception(errorMessage);
    } catch (e) {
      debugPrint('❌ Error in client transfer: $e');
      rethrow;
    }
  }
}
