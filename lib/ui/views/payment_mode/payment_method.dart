import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:tjwd2d/ui/views/payment_mode/payment_method_controller.dart';

import '../../../common_widget/common_button.dart';
import '../../../common_widget/common_dialog.dart';
import '../../../common_widget/common_text_field.dart';
import '../../../core/res/colors.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  final controller = Get.put(PaymentMethodController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment Method"), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Payment Method",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  radioTile("cash", "Cash"),
                  radioTile("upi", "UPI"),
                  SizedBox(height: 26),
                  Obx((){
                    return   CommonButton(
                      text: "Submit",
                      isLoading: controller.isLoading.value,
                      onPressed: () {
                        controller.submit();
                        // Get.back();
                        //
                        //  CommonDialog.showCustomDialog(
                        //    borderRadius: 26.0,
                        //    content: AnimatedPadding(
                        //      duration: const Duration(milliseconds: 200),
                        //      curve: Curves.easeOut,
                        //      padding: EdgeInsets.only(
                        //        bottom: MediaQuery.of(
                        //          Get.context!,
                        //        ).viewInsets.bottom,
                        //      ),
                        //      child: SingleChildScrollView(
                        //        physics: const BouncingScrollPhysics(),
                        //        child: ConstrainedBox(
                        //          constraints: BoxConstraints(
                        //            maxHeight:
                        //                MediaQuery.of(Get.context!).size.height *
                        //                0.8,
                        //          ),
                        //          child: Padding(
                        //            padding: const EdgeInsets.all(28.0),
                        //            child: Column(
                        //              mainAxisSize: MainAxisSize.min,
                        //              children: [
                        //                Text(
                        //                  "Updated",
                        //                  style: TextStyle(
                        //                    fontSize: 28,
                        //                    color: AppColor.textPrimary,
                        //                    fontWeight: FontWeight.w600,
                        //                  ),
                        //                ),
                        //                const SizedBox(height: 6),
                        //
                        //                Container(
                        //                  padding: const EdgeInsets.all(14),
                        //                  decoration: BoxDecoration(
                        //                    color: const Color(0xffD8E9FF),
                        //                    borderRadius: BorderRadius.circular(8),
                        //                  ),
                        //                  child: Row(
                        //                    children: [
                        //                      SvgPicture.asset(
                        //                        "assets/user_id.svg",
                        //                      ),
                        //                      const SizedBox(width: 10),
                        //                      Expanded(
                        //                        child: Text(
                        //                          'Registration ID : GF25-TV20097',
                        //                          style: TextStyle(
                        //                            fontSize: 14,
                        //                            fontWeight: FontWeight.bold,
                        //                            color: AppColor.textPrimary,
                        //                          ),
                        //                        ),
                        //                      ),
                        //                    ],
                        //                  ),
                        //                ),
                        //
                        //                const SizedBox(height: 6),
                        //
                        //                Text(
                        //                  "Your data has been saved",
                        //                  style: TextStyle(
                        //                    fontSize: 14,
                        //                    color: Color(0xff6B6B6B),
                        //                  ),
                        //                ),
                        //
                        //                const SizedBox(height: 26),
                        //
                        //                CommonButton(
                        //                  text: "Close",
                        //                  onPressed: () {
                        //                    Get.back();
                        //                  },
                        //                ),
                        //              ],
                        //            ),
                        //          ),
                        //        ),
                        //      ),
                        //    ),
                        //  );
                      },
                    );
                  })

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget radioTile(String value, String label) {
    return Obx(() {
      final isSelected = controller.selectedValue.value == value;

      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.only(bottom: isSelected ? 12 : 0),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColor.primary : AppColor.border,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            RadioListTile<String>(
              value: value,
              groupValue: controller.selectedValue.value,
              onChanged: (val) {
                controller.selectedValue.value = val!;

                if (val == 'cash') {
                  controller.upiAmountController.clear();
                  controller.referenceIdController.clear();
                } else {
                  controller.cashAmountController.clear();
                }
              },
              title: Text(label),
            ),

            // 👇 EXPAND CONTENT INSIDE SAME CONTAINER
            if (isSelected && value == "cash") ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CommonTextField(
                  controller: controller.cashAmountController,
                  hintText: "Enter cash amount",
                  keyboardType: TextInputType.number,
                  focusNode: controller.cashFocusNode,
                ),
              ),
            ],

            if (isSelected && value == "upi") ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.network(
                    "https://storage.googleapis.com/dara-c1b52.appspot.com/daras_ai/media/a3202e58-17ef-11ee-9a70-8e93953183bb/cleaned_qr.png",
                  ),
                  //   SvgPicture.asset("assets/tjwd2d_Logo.svg"),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CommonTextField(
                  controller: controller.upiAmountController,
                  hintText: "Enter Cash Amount",
                  focusNode: controller.upiAmountFocusNode,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CommonTextField(
                  controller: controller.referenceIdController,
                  hintText: "Enter UPI Reference ID",
                  focusNode: controller.referenceIdFocusNode,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}
