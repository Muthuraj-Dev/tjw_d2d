import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get_it/get_it.dart';

import '../core/model/userSession.dart';
import '../router.dart';

class SessionService {
  static const _sessionKey = 'user_session';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveSession(UserSession session) async {
    await _storage.write(
      key: _sessionKey,
      value: jsonEncode(session.toJson()),
    );
  }

  Future<UserSession?> getSession() async {
    final raw = await _storage.read(key: _sessionKey);
    if (raw == null) return null;

    return UserSession.fromJson(jsonDecode(raw));
  }

  Future<bool> hasSession() async {
    return await _storage.read(key: _sessionKey) != null;
  }

  Future<void> clearSession() async {
    /// 1️⃣ Clear secure storage
    await _storage.delete(key: _sessionKey);

    /// 4️⃣ Remove all GetX controllers
    Get.deleteAll(force: true);

    /// 5️⃣ Navigate to phone screen (clear stack)
    Get.offAllNamed(AppRoutes.phoneScreen);

  }


  // For logout
  // await locator<SessionService>().clearSession();
}
