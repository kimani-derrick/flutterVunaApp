import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _prefix = 'cache_';
  static const Duration defaultExpiration = Duration(minutes: 30);

  static Future<void> setData(String key, dynamic data,
      {Duration? expiration}) async {
    final prefs = await SharedPreferences.getInstance();
    final expirationTime = DateTime.now().add(expiration ?? defaultExpiration);

    final cacheData = {
      'data': data,
      'expiration': expirationTime.toIso8601String(),
    };

    await prefs.setString('$_prefix$key', json.encode(cacheData));
  }

  static Future<dynamic> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('$_prefix$key');

    if (cachedData == null) return null;

    final decodedData = json.decode(cachedData);
    final expiration = DateTime.parse(decodedData['expiration']);

    if (DateTime.now().isAfter(expiration)) {
      await prefs.remove('$_prefix$key');
      return null;
    }

    return decodedData['data'];
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(_prefix));

    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  static Future<void> removeItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix$key');
  }
}
