import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GroupService {
  static const String baseUrl = 'https://api.vuna.io/fineract-provider/api/v1';
  static const String appUsername = 'mifos';
  static const String appPassword = 'password';

  static Future<List<Map<String, dynamic>>> getGroupsByOfficeId(
      String username, String password, String officeId) async {
    try {
      final credentials =
          base64.encode(utf8.encode('$appUsername:$appPassword'));
      final url = '$baseUrl/groups?officeId=$officeId';

      debugPrint('\n🔍 Fetching groups...');
      debugPrint('URL: $url');
      debugPrint('Headers: {');
      debugPrint('  accept: application/json');
      debugPrint('  Authorization: Basic $credentials');
      debugPrint('  fineract-platform-tenantid: default');
      debugPrint('}');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Basic $credentials',
          'fineract-platform-tenantid': 'default',
        },
      );

      debugPrint('\n📥 Response:');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> groups = json.decode(response.body);
        debugPrint('\n✅ Successfully fetched ${groups.length} groups');
        return groups.cast<Map<String, dynamic>>();
      } else {
        debugPrint('\n❌ Failed to fetch groups');
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');
        throw Exception('Failed to load groups: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('\n💥 Error in getGroupsByOfficeId: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getGroupBalance(
      String username, String password, String groupId) async {
    try {
      final credentials =
          base64.encode(utf8.encode('$appUsername:$appPassword'));
      final url = '$baseUrl/groups/$groupId/accounts?fields=savingsAccounts';

      debugPrint('\n🔍 Fetching group balance...');
      debugPrint('URL: $url');
      debugPrint('Headers: {');
      debugPrint('  accept: application/json');
      debugPrint('  Authorization: Basic $credentials');
      debugPrint('  fineract-platform-tenantid: default');
      debugPrint('}');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Basic $credentials',
          'fineract-platform-tenantid': 'default',
        },
      );

      debugPrint('\n📥 Response:');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('\n✅ Successfully fetched group balance');
        return data;
      } else {
        debugPrint('\n❌ Failed to fetch group balance');
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');
        throw Exception('Failed to load group balance: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('\n💥 Error in getGroupBalance: $e');
      rethrow;
    }
  }
}
