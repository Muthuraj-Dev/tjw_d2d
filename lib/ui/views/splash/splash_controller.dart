import 'dart:async';
import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tjwd2d/ui/views/phone/phone_screen.dart';

import '../../../locator.dart';
import '../../../router.dart';
import '../../../services/appconfig_service.dart';
import '../../../services/session_service.dart';

class SplashController extends GetxController {
  var isLoading = true.obs;

  final SessionService _sessionService = locator<SessionService>();

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    print("INSIDE INIT SPLASH CONTROLLER");
    await _loadRemoteConfig();

    final hasSession = await _sessionService.hasSession();

    await Future.delayed(const Duration(seconds: 1));

    if (hasSession) {
      Get.offAllNamed(AppRoutes.searchScreen);
    } else {
      Get.offAllNamed(AppRoutes.phoneScreen);
    }
  }

  Future<void> _loadRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setDefaults({'config': '{}'});

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 2),
        minimumFetchInterval: Duration.zero,
      ),
    );

    await remoteConfig.fetchAndActivate();

    final rawJson = remoteConfig.getString('config');
    if (rawJson.isNotEmpty && rawJson != '{}') {
      locator<AppConfigService>().setConfig(jsonDecode(rawJson));
    }
  }



}
