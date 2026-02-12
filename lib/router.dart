

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:tjwd2d/ui/views/otp/otp_binding.dart';
import 'package:tjwd2d/ui/views/otp/otp_screen.dart';
import 'package:tjwd2d/ui/views/phone/phone_binding.dart';
import 'package:tjwd2d/ui/views/phone/phone_screen.dart';
import 'package:tjwd2d/ui/views/splash/splash_binding.dart';
import 'package:tjwd2d/ui/views/splash/splash_controller.dart';
import 'package:tjwd2d/ui/views/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String loginScreen = '/login';
  static const String phoneScreen = '/phone';
  static const String otpScreen = '/otp';
  static const String searchScreen = '/searchScreen';
  static const String visitorDetailsScreen = '/visitoDetailsScreen';

  static final List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: phoneScreen,
      page: () => const PhoneScreen(),
      binding: PhoneBinding(),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: otpScreen,
      page: () => const OtpScreen(),
      binding: OtpBinding(),
      transition: Transition.fadeIn,
    ),

  ];
}
