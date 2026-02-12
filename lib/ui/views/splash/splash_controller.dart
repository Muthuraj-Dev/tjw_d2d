import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tjwd2d/ui/views/phone/phone_screen.dart';

import '../../../router.dart';

class SplashController extends GetxController {
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  /// Initial method called on splash screen load
  Future<void> init() async {
    print("INSIDE INIT SPLASH CONTROLLER");
    await Future.delayed(const Duration(seconds: 2));
    // Get.off(() => PhoneScreen());
    // ✅ CORRECT
    Get.offAllNamed(AppRoutes.phoneScreen);

  }
}
