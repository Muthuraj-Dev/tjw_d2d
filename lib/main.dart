
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tjwd2d/router.dart';
import 'package:tjwd2d/services/network_service.dart';
import 'core/res/styles.dart';
import 'locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  // Init network service (after config is set)
  locator<NetworkService>().onInit();

  // Run the app
   runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return GetMaterialApp(
      title: 'TJW D2D',
      initialRoute: '/',  //  / ,  login
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.pages,
      theme: AppStyle.appTheme,
      useInheritedMediaQuery: true,
    );
  }

}


// approved - complimentaer , paid,
// unpain , rejected