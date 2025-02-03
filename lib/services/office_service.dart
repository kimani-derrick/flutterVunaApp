import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OfficeService {
  static const String baseUrl = 'https://api.vuna.io/fineract-provider/api/v1';
  static const String appUsername = 'mifos';
  static const String appPassword = 'password';

  static Future<List<Map<String, dynamic>>> getAllOffices() async {
    try {
      final credentials =
          base64.encode(utf8.encode('$appUsername:$appPassword'));
      final url = '$baseUrl/offices';

      debugPrint('\n🔍 Fetching all offices...');
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
        final List<dynamic> offices = json.decode(response.body);
        debugPrint('✅ Successfully fetched ${offices.length} offices');

        // Sort offices by hierarchy to maintain proper order
        final List<Map<String, dynamic>> sortedOffices =
            offices.cast<Map<String, dynamic>>()
              ..sort((a, b) {
                final aHierarchy = a['hierarchy'] as String? ?? '';
                final bHierarchy = b['hierarchy'] as String? ?? '';
                return aHierarchy.compareTo(bHierarchy);
              });

        return sortedOffices;
      } else {
        throw Exception('Failed to load offices: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching offices: $e');
      rethrow;
    }
  }
}
