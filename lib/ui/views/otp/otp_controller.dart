import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

import '../../../core/model/userSession.dart';
import '../../../locator.dart';
import '../../../services/api_base_service.dart';
import '../../../services/request_method.dart';
import '../../../services/session_service.dart';
import '../visitor_search/visitor_search_screen.dart';

class OtpController extends GetxController with WidgetsBindingObserver {
  final formKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();

  final otpId = 0.obs;
  final mobileNumber = ''.obs;

  final TextEditingController otpController = TextEditingController();
  FocusNode otpFocusNode = FocusNode();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // otpId.value = Get.arguments as int;

    final args = Get.arguments as Map<String, dynamic>;

    otpId.value = args['otpId'] as int;
    mobileNumber.value = args['mobileNumber'] as String;
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



  Future<void> resendOtp() async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      final Map<String, dynamic> response =
      await ApiBaseService.request<Map<String, dynamic>>(
        'OTP/SentOTP?mobileNumber=$mobileNumber',
        method: RequestMethod.GET,
        authenticated: false,
      );

      if (response['status'] == "200") {
        Fluttertoast.showToast(msg: response['message'] ?? "OTP sent Successfully");

        // /// 🔑 STORE otpId
        // final otpId = response['data']['otpId'];
        //
        // Get.toNamed(
        //   '/otp',
        //   arguments: {
        //     'otpId': otpId,
        //     'mobileNumber': mobileNumber,
        //   },
        // );

      }

    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }


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

        final session = UserSession(
          userId: response['data']['userId'],
          mobileNumber: response['data']['mobileNumber'],
          userName: response['data']['userName'],
        );

        await locator<SessionService>().saveSession(session);


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
