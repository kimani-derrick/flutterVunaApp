import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../config/api_config.dart';
import '../core/security/credentials_manager.dart';
import 'http_client.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static final HttpClient _httpClient = HttpClient();
  static final CredentialsManager _credentialsManager = CredentialsManager();

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      // debugPrint('🔐 Attempting login for user: $username');

      // Store credentials securely
      await _credentialsManager.storeCredentials(username, password);

      // Create basic auth header
      final credentials = base64Encode(utf8.encode('$username:$password'));
      final headers = {
        'Authorization': 'Basic $credentials',
        'fineract-platform-tenantid': ApiConfig.tenantId,
      };

      // debugPrint('🌐 Making request to: ${ApiConfig.authUrl}');
      final response = await _httpClient.get(
        ApiConfig.authEndpoint,
        headers: headers,
      );

      // debugPrint('📡 API Response Status Code: ${response.statusCode}');
      // debugPrint('📦 API Response Body: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['totalFilteredRecords'] > 0 && data['pageItems'].isNotEmpty) {
          // debugPrint('✅ Login successful for user: ${data['pageItems'][0]['displayName']}');
          return {
            'success': true,
            'userData': data['pageItems'][0],
          };
        } else {
          // debugPrint('⚠️ No user data found in response');
          return {
            'success': false,
            'error': 'Invalid credentials',
          };
        }
      } else {
        // debugPrint('❌ Login failed with status code: ${response.statusCode}');
        return {
          'success': false,
          'error': 'Authentication failed',
        };
      }
    } catch (e) {
      // debugPrint('🔥 Error during login: $e');
      String errorMessage = 'Network error occurred';
      if (e.toString().contains('SocketException')) {
        errorMessage =
            'Could not connect to server. Please check your internet connection.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Connection timed out. Please try again.';
      } else if (e.toString().contains('DioError')) {
        errorMessage = 'Server error. Please try again later.';
      }
      return {
        'success': false,
        'error': errorMessage,
      };
    }
  }

  Future<void> logout() async {
    await _credentialsManager.clearCredentials();
  }

  static Future<Map<String, dynamic>> signup({
    required String firstName,
    required String lastName,
    required String nationalId,
    required String mobileNumber,
    required String email,
    required String username,
    required String password,
    required int officeId,
    String? middleName,
  }) async {
    try {
      // debugPrint('\n🚀 Starting signup process...');
      // debugPrint('📋 Using Office ID: $officeId (${officeId == 1 ? 'Default from app auth' : 'Custom'})');

      // Initialize HTTP client
      await _httpClient.init();

      // Generate auth token by encoding the actual credentials
      final credentials = utf8.encode('mifos:password');
      final authToken = base64.encode(credentials);
      // debugPrint('\n🔐 Generated auth token from credentials (not hardcoded)');

      final headers = {
        'Authorization': 'Basic $authToken',
        'fineract-platform-tenantid': 'default',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // debugPrint('\n📝 API Headers:');
      // debugPrint(const JsonEncoder.withIndent('  ').convert(headers));

      // STEP 1: Create Client
      // debugPrint('\n👤 STEP 1: Creating client...');

      final now = DateTime.now();
      final activationDate = DateFormat('dd MMMM yyyy').format(now);

      final clientData = {
        'officeId': officeId,
        'firstname': firstName,
        'lastname': lastName,
        'externalId': nationalId,
        'dateFormat': 'dd MMMM yyyy',
        'locale': 'en',
        'active': true,
        'activationDate': activationDate,
        'legalFormId': 1,
        'mobileNo': mobileNumber,
        'emailAddress': email,
        'address': [
          {
            'addressLine1': 'Kivali',
            'addressLine2': 'plot47',
            'addressLine3': 'arkop',
            'addressTypeId': 1,
            'city': 'Kenya',
            'countryId': 802,
            'isActive': true,
            'postalCode': 400064,
            'stateProvinceId': 800,
            'street': 'Ipca'
          }
        ],
      };

      // debugPrint('\n📦 Client Creation Payload:');
      // debugPrint(const JsonEncoder.withIndent('  ').convert(clientData));

      final Response clientResponse = await _httpClient.post(
        ApiConfig.clientsEndpoint,
        data: jsonEncode(clientData),
        options: Options(headers: headers),
      );

      // debugPrint('\n📡 Client API Response:');
      // debugPrint('Status Code: ${clientResponse.statusCode}');
      // debugPrint('Response Body: ${const JsonEncoder.withIndent('  ').convert(clientResponse.data)}');

      if (clientResponse.statusCode != 200) {
        throw Exception('Failed to create client: ${clientResponse.data}');
      }

      final clientId = clientResponse.data['clientId'];
      if (clientId == null) {
        throw Exception('Client creation successful but no clientId returned');
      }

      // debugPrint('\n✅ Client created successfully with ID: $clientId');

      // STEP 2: Create User with the obtained clientId
      // debugPrint('\n👥 STEP 2: Creating user for client $clientId...');

      final userData = {
        'clients': [clientId],
        'email': email,
        'firstname': firstName,
        'isSelfServiceUser': true,
        'lastname': lastName,
        'officeId': officeId,
        'password': password,
        'passwordNeverExpires': true,
        'repeatPassword': password,
        'roles': [1, 2],
        'sendPasswordToEmail': false,
        'username': username
      };

      // debugPrint('\n📦 User Creation Payload:');
      // debugPrint(const JsonEncoder.withIndent('  ').convert(userData));

      final Response userResponse = await _httpClient.post(
        ApiConfig.usersEndpoint,
        data: jsonEncode(userData),
        options: Options(headers: headers),
      );

      // debugPrint('\n📡 User API Response:');
      // debugPrint('Status Code: ${userResponse.statusCode}');
      // debugPrint('Response Body: ${const JsonEncoder.withIndent('  ').convert(userResponse.data)}');

      if (userResponse.statusCode != 200) {
        throw Exception('Failed to create user: ${userResponse.data}');
      }

      final userId = userResponse.data['resourceId'];
      // debugPrint('\n✅ User created successfully with ID: $userId');
      // debugPrint('\n🎉 Complete signup process successful!\n');

      return {
        'success': true,
        'clientId': clientId,
        'userId': userId,
        'message': 'Account created successfully'
      };
    } catch (e) {
      // debugPrint('\n❌ Error during signup process: $e');
      throw Exception('Signup failed: $e');
    }
  }
}
