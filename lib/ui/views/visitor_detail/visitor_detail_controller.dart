import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../common_widget/common_button.dart';
import '../../../common_widget/common_dialog.dart';
import '../../../core/model/searchResponse.dart';
import '../../../core/res/colors.dart';
import '../../../services/api_base_service.dart';
import '../../../services/request_method.dart';

class VisitorDetailController extends GetxController {
  final TextEditingController statusController = TextEditingController();
  FocusNode statusFocusNode = FocusNode();




  RxString selectedValue = "cash".obs;

  // Cash
  final cashAmountController = TextEditingController();
  FocusNode cashFocusNode = FocusNode();

  // UPI
  final upiAmountController = TextEditingController(); // ✅ NEW
  final FocusNode upiAmountFocusNode = FocusNode();

  // UPI
  final referenceIdController = TextEditingController();
  FocusNode referenceIdFocusNode = FocusNode();

  final ScrollController scrollController = ScrollController();
  double lastScrollOffset = 0;

  late final Data visitor;

  var isLoading = false.obs;

  final referenceFieldKey = GlobalKey();


  @override
  void onInit() {
    super.onInit();
    visitor = Get.arguments as Data; // ✅ receive visitor

    // ✅ Prefill status from API
    selectedStatus.value = visitor.status ?? 0;

    final label = _statusLabelFromCode(selectedStatus.value);

    if (label.isNotEmpty) {
      statusController.text = label;
    }

    referenceIdFocusNode.addListener(() {
      if (referenceIdFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 300), () {
          final context = referenceFieldKey.currentContext;
          if (context != null) {
            Scrollable.ensureVisible(
              context,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              alignment: 0.2, // keeps it ABOVE the button
            );
          }
        });
      }
    });

  }

  /// Call this on submit
  bool validatePayment({required GlobalKey<FormState> formkey}) {
    return formkey.currentState?.validate() ?? false;
  }

  String _statusLabelFromCode(int status) {
    switch (status) {
      case 3:
        return 'Paid';
      case 6:
        return 'Complimentary';
      case 0:
        return 'Unpaid';
      case 2:
        return 'Rejected';
      default:
        return '';
    }
  }

  /// numeric status for API

  final RxInt selectedStatus = (-999).obs; // default invalid


  void onStatusChanged(String value) {
    statusController.text = value;

    switch (value) {
      case 'Paid':
        selectedStatus.value = 3;
        break;
      case 'Complimentary':
        selectedStatus.value = 6;
        break;
      case 'Unpaid':
        selectedStatus.value = 0;
        break;
      case 'Rejected':
        selectedStatus.value = -1;
        break;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    statusController.dispose();
    super.onClose();
  }

  Future<void> submitWithoutPayment() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final int visitorId = visitor.visitorID!;

      final String url =
          'Save'
          '?VisitorID=$visitorId'
          '&status=${selectedStatus.value}'
          '&PaymentMode='
          '&Amount=0'
          '&ReferenceID=';

      final response = await ApiBaseService.request<Map<String, dynamic>>(
        url,
        method: RequestMethod.GET,
        authenticated: false,
      );

      if (response['status'] == "200") {
        final data = response['data'];

        visitor.status = data['status'];
        visitor.registrationID = data['registrationID'];

        Fluttertoast.showToast(msg: 'Status updated successfully');
        // Get.back();

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

                      // Container(
                      //   padding: const EdgeInsets.all(14),
                      //   decoration: BoxDecoration(
                      //     color: const Color(0xffD8E9FF),
                      //     borderRadius: BorderRadius.circular(8),
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       SvgPicture.asset("assets/user_id.svg"),
                      //       const SizedBox(width: 10),
                      //       Expanded(
                      //         child: Text(
                      //           'Registration ID : ${visitor.registrationID}',
                      //           style: TextStyle(
                      //             fontSize: 14,
                      //             fontWeight: FontWeight.bold,
                      //             color: AppColor.textPrimary,
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

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
        //   Get.back(result: true);
      } else {
        Fluttertoast.showToast(msg: 'Failed to update status');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally{
      isLoading.value = false;
    }
  }

  Future<void> submit() async {
    if (isLoading.value) return;

    try {
      _validatePayment();
      isLoading.value = true;

      final int visitorId = visitor.visitorID!;

      final String paymentMode = selectedValue.value;


      final String amount =
      selectedValue.value == 'cash'
          ? cashAmountController.text.trim()
          : upiAmountController.text.trim();

      final String referenceId =
      selectedValue.value == 'upi'
          ? referenceIdController.text.trim()
          : '';


      final String url =
          'Save'
          '?VisitorID=$visitorId'
          '&status=${selectedStatus.value}'
          '&PaymentMode=$paymentMode'
          '&Amount=$amount'
          '&ReferenceID=$referenceId';

      final Map<String, dynamic> response =
      await ApiBaseService.request<Map<String, dynamic>>(
        url,
        method: RequestMethod.GET,
        authenticated: false,
      );

      if (response['status'] == "200") {
        final data = response['data'];

        Fluttertoast.showToast(
          msg: 'Saved successfully',
        );

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
