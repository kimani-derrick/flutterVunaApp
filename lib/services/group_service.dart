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

  static Future<List<Map<String, dynamic>>> getGroupTransactions(
    String accountId, {
    String? fromDate,
    String? toDate,
  }) async {
    try {
      final credentials =
          base64.encode(utf8.encode('$appUsername:$appPassword'));
      final now = DateTime.now();
      final defaultFromDate = DateTime(now.year - 1, now.month, now.day)
          .toIso8601String()
          .split('T')
          .first;
      final defaultToDate = now.toIso8601String().split('T').first;

      debugPrint(
          '\n🔍 Fetching transactions for savings account ID: $accountId');

      final url =
          Uri.parse('$baseUrl/savingsaccounts/$accountId/transactions/search'
              '?fromDate=${fromDate ?? defaultFromDate}'
              '&toDate=${toDate ?? defaultToDate}'
              '&fromSubmittedDate=${fromDate ?? defaultFromDate}'
              '&toSubmittedDate=${toDate ?? defaultToDate}'
              '&fromAmount=1'
              '&toAmount=50000000'
              '&types=1,2,3,4,20,21'
              '&orderBy=createdDate,transactionDate,id'
              '&sortOrder=DESC'
              '&dateFormat=yyyy-MM-dd');

      debugPrint('URL: $url');
      debugPrint('Headers: {');
      debugPrint('  Authorization: Basic $credentials');
      debugPrint('  fineract-platform-tenantid: default');
      debugPrint('  accept: application/json');
      debugPrint('}');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Basic $credentials',
          'fineract-platform-tenantid': 'default',
          'accept': 'application/json',
        },
      );

      debugPrint('\n📥 Response:');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('✅ Successfully fetched transactions');
        return List<Map<String, dynamic>>.from(data['content'] ?? []);
      } else {
        debugPrint('❌ Failed to fetch transactions: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
        throw Exception('Failed to fetch transactions');
      }
    } catch (e) {
      debugPrint('❌ Error fetching transactions: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getGroupMembers(
      String username, String password, String groupId) async {
    try {
      final credentials =
          base64.encode(utf8.encode('$appUsername:$appPassword'));
      final url = '$baseUrl/groups/$groupId?associations=clientMembers';

      debugPrint('\n🔍 Fetching group members...');
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
        final data = json.decode(response.body);
        debugPrint('✅ Successfully fetched group members');
        return data;
      } else {
        throw Exception('Failed to load group members: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching group members: $e');
      rethrow;
    }
  }
}
