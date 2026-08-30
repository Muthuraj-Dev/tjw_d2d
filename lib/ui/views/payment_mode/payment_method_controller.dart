import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../common_widget/common_button.dart';
import '../../../common_widget/common_dialog.dart';
import '../../../core/model/searchResponse.dart';
import '../../../core/res/colors.dart';
import '../../../locator.dart';
import '../../../services/api_base_service.dart';
import '../../../services/request_method.dart';
import '../../../services/session_service.dart';

class PaymentMethodController extends GetxController {
  RxString selectedValue = "cash".obs;

  final formKey = GlobalKey<FormState>();

  // Cash
  final cashAmountController = TextEditingController();
  FocusNode cashFocusNode = FocusNode();

  // UPI
  final upiAmountController = TextEditingController(); // ✅ NEW
  final FocusNode upiAmountFocusNode = FocusNode();

  // UPI
  final referenceIdController = TextEditingController();
  FocusNode referenceIdFocusNode = FocusNode();

  var isLoading = false.obs;

  late final Data visitor;
  late final int status;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    visitor = args['visitor'];
    status = args['status'];

    print("STATUS $status}");
  }

  Future<void> submit() async {
    if (isLoading.value) return;

    try {
      _validatePayment();
      isLoading.value = true;

      final session = await locator<SessionService>().getSession();

      if (session == null) {
        Fluttertoast.showToast(msg: 'Session expired. Please verify OTP again.');
        return;
      }

      final int userId = session.userId;
      final int visitorId = visitor.visitorID!;

      final String paymentMode = selectedValue.value;

      // final String amount =
      // selectedValue.value == 'cash'
      //     ? cashAmountController.text.trim()
      //     : '0';
      //
      // final String referenceId =
      // selectedValue.value == 'upi'
      //     ? referenceIdController.text.trim()
      //     : '';

      final String amount = selectedValue.value == 'cash'
          ? cashAmountController.text.trim()
          : upiAmountController.text.trim();

      final String referenceId = selectedValue.value == 'upi'
          ? referenceIdController.text.trim()
          : '';

      final String url =
          'Save'
          '?VisitorID=$visitorId'
          '&status=$status'
          '&PaymentMode=$paymentMode'
          '&Amount=$amount'
          '&ReferenceID=$referenceId'
          '&userId=$userId';

      final Map<String, dynamic> response =
          await ApiBaseService.request<Map<String, dynamic>>(
            url,
            method: RequestMethod.GET,
            authenticated: false,
          );

      if (response['status'] == "200") {
        final data = response['data'];

        Fluttertoast.showToast(msg: 'Saved successfully');

        // Optional local update
        visitor.status = data['status'];
        visitor.registrationID = data['registrationID'];

        CommonDialog.showCustomDialog(
          borderRadius: 26.0,
          content: AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(Get.context!).size.height * 0.8,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Updated",
                        style: TextStyle(
                          fontSize: 28,
                          color: AppColor.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xffD8E9FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/user_id.svg"),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Registration ID : ${visitor.registrationID}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Your data has been saved",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff6B6B6B),
                        ),
                      ),

                      const SizedBox(height: 26),

                      CommonButton(
                        text: "Close",
                        onPressed: () {
                          if (Get.isDialogOpen ?? false) {
                            Get.back(result: true);
                          }
                          Get.back(result: true);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        //     Get.back(result: true);
      } else {
        Fluttertoast.showToast(msg: 'Failed to save payment');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _validatePayment() {
    if (selectedValue.value == 'cash') {
      if (cashAmountController.text.trim().isEmpty) {
        throw Exception('Enter cash amount');
      }
    }

    if (selectedValue.value == 'upi') {
      if (upiAmountController.text.trim().isEmpty) {
        throw Exception('Enter UPI amount');
      }
      if (referenceIdController.text.trim().isEmpty) {
        throw Exception('Enter UPI reference ID');
      }
    }
  }
}
