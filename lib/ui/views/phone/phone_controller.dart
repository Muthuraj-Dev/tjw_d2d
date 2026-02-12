import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/api_base_service.dart';
import '../../../services/request_method.dart';

class PhoneController extends GetxController {
  final isLoading = false.obs;
  final isMobileOtpCalled = false.obs;

  final String helplineNumber = "+919935043504";

  /// Called from UI
  void onPhoneChanged(String val) {
    if (val.length == 10) {
      isMobileOtpCalled.value = true;
    }
  }

  /// Validation logic (safe to keep here)
  String? validatePhone(String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter phone number';
    }

    final phoneRegExp = RegExp(r'^[0-9]{10}$');
    if (!phoneRegExp.hasMatch(val)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  Future<void> mobileOtp(String mobileNumber) async {
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
        Fluttertoast.showToast(msg: response['message']);

        /// 🔑 STORE otpId
        final otpId = response['data']['otpId'];

        // Get.toNamed('/otp');
        Get.toNamed('/otp', arguments: otpId);
      }

      //    Get.toNamed('/otp');
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> launchCaller() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: helplineNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}
