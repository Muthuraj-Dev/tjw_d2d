import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tjwd2d/ui/views/phone/phone_screen.dart';

import '../../../locator.dart';
import '../../../router.dart';
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

    final hasSession = await _sessionService.hasSession();

    await Future.delayed(const Duration(seconds: 1));

    if (hasSession) {
      Get.offAllNamed(AppRoutes.searchScreen);
    } else {
      Get.offAllNamed(AppRoutes.phoneScreen);
    }
  }
}
