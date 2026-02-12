import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const _storage = FlutterSecureStorage();

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<void> setToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
    print("ACTUAL TOKEN STORED");
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  static Future<void> setRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
    print("REFRESH TOKEN STORED");
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  static Future<void> deleteRefreshToken() async {
    await _storage.delete(key: 'refresh_token');
  }

  static Future<void> setUserPhone(String phone) async {
    await _storage.write(key: 'user_phone', value: phone);
    print("User Phone STORED");
  }

  static Future<String?> getUserPhone() async {
    return await _storage.read(key: 'user_phone');
  }
}
