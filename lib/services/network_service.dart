import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../core/res/images.dart';
import '../core/res/spacing.dart';
import '../ui/widgets/button.dart';

class NetworkService extends GetxController {

  bool _dialogShown = false;

  StreamSubscription<List<ConnectivityResult>>? subscription;

  @override
  void onInit() {
    super.onInit();

    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> resultList) {
      final hasConnection = resultList.any((r) => r != ConnectivityResult.none);

      if (!hasConnection) {
        if (!_dialogShown) {
          _dialogShown = true;
          _showNoNetworkDialog();
        }
      } else {
        if (_dialogShown) {
          _dialogShown = false;
          if (Get.isDialogOpen ?? false) {
            Get.back(); // Close dialog
          }
        }
      }
    });
  }


  void _showNoNetworkDialog() {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          content: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(Images.passShow),
                VerticalSpacing.custom(value: 30),
                Text('No Network', style: TextStyle(fontSize: 18)),
                VerticalSpacing.custom(value: 12),
                const Text(
                  "Seems like you don’t have an active internet connection",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff414141)),
                  textAlign: TextAlign.center,
                ),
                VerticalSpacing.custom(value: 20),
                Button(
                  "Retry",
                  key: const ValueKey("retry"),
                  width: double.infinity,
                  onPressed: () async {
                    List<ConnectivityResult> results = await Connectivity().checkConnectivity();
                    final hasConnection = results.any((r) => r != ConnectivityResult.none);

                    if (hasConnection) {
                      if (Get.isDialogOpen ?? false) {
                        Get.back();
                      }
                      _dialogShown = false;
                    } else {
                      // errorToast("Check Internet Connection");
                    }
                  },

                ),
                VerticalSpacing.custom(value: 16),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    subscription?.cancel();
    super.onClose();
  }
}

