import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class CredentialsManager {
  static final CredentialsManager _instance = CredentialsManager._internal();
  factory CredentialsManager() => _instance;
  CredentialsManager._internal();

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userCredentialsKey = 'user_credentials';

  // Store encrypted credentials
  Future<void> storeCredentials(String username, String password) async {
    try {
      final credentials = base64Encode(utf8.encode('$username:$password'));
      await _storage.write(key: _userCredentialsKey, value: credentials);
    } catch (e) {
      debugPrint('🔒 Error storing credentials: $e');
      rethrow;
    }
  }

  // Get stored credentials
  Future<String?> getStoredCredentials() async {
    try {
      return await _storage.read(key: _userCredentialsKey);
    } catch (e) {
      debugPrint('🔒 Error retrieving credentials: $e');
      rethrow;
    }
  }

  // Store auth token
  Future<void> storeAuthToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (e) {
      debugPrint('🔒 Error storing auth token: $e');
      rethrow;
    }
  }

  // Get auth token
  Future<String?> getAuthToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      debugPrint('🔒 Error retrieving auth token: $e');
      rethrow;
    }
  }

  // Clear all stored credentials
  Future<void> clearCredentials() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      debugPrint('🔒 Error clearing credentials: $e');
      rethrow;
    }
  }

  // Generate authorization header
  Future<Map<String, String>> getAuthHeader() async {
    final credentials = await getStoredCredentials();
    if (credentials == null) {
      throw Exception('No stored credentials found');
    }
    return {
      'Authorization': 'Basic $credentials',
    };
  }
}
