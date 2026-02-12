import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

import '../../../services/api_base_service.dart';
import '../../../services/request_method.dart';
import '../visitor_search/visitor_search_screen.dart';

class OtpController extends GetxController with WidgetsBindingObserver {
  final formKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();

  final otpId = 0.obs;
  final TextEditingController otpController = TextEditingController();
  FocusNode otpFocusNode = FocusNode();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    otpId.value = Get.arguments as int;
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset > 0) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 10),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void onClose() {
    otpFocusNode.dispose();
    otpController.dispose();
    scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  resendOtp() {}


  Future<void> verifyOtp({
    required int otpId,
    required int enteredOtp,
  }) async {

    if (otpController.text.length != 4) {
      Fluttertoast.showToast(msg: 'Enter valid OTP');
      return;
    }

    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final Map<String, dynamic> response =
      await ApiBaseService.request<Map<String, dynamic>>(
        'OTP/VerifyOTP?otpId=$otpId&enteredOtp=$enteredOtp',
        method: RequestMethod.GET,
        authenticated: false,
      );

      if (response['status'] == 200) {
        Fluttertoast.showToast(msg: response['message']);

        /// Navigate after success
        Get.offAll(() => VisitorSearchScreen());
      } else {
        Fluttertoast.showToast(
          msg: response['message'] ?? 'OTP verification failed',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to verify OTP. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

}
