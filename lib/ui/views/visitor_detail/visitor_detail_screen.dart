import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:tjwd2d/common_widget/common_button.dart';
import 'package:tjwd2d/common_widget/common_dialog.dart';
import 'package:tjwd2d/common_widget/common_text_field.dart';
import 'package:tjwd2d/core/res/colors.dart';
import 'package:tjwd2d/ui/views/visitor_detail/visitor_detail_controller.dart';

import '../../../common_widget/common_dropdown.dart';
import '../../../locator.dart';
import '../../../services/session_service.dart';
import '../payment_mode/payment_method.dart';

class VisitorDetailScreen extends StatefulWidget {
  const VisitorDetailScreen({super.key});

  @override
  State<VisitorDetailScreen> createState() => _VisitorDetailScreenState();
}

class _VisitorDetailScreenState extends State<VisitorDetailScreen> {
  final VisitorDetailController controller = Get.put(VisitorDetailController());

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffEFF2FF),
        title: const Text('Visitor Details'),
        // SvgPicture.asset("assets/tjwd2d_Logo.svg", height: 40),
        actions: [
          InkWell(
            onTap: () async {
              await locator<SessionService>().clearSession();
            },
            child: Row(
              children: [
                Icon(Icons.logout),
                SizedBox(width: 6),
                Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColor.primary,
                  ),
                ),
                SizedBox(width: 26),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: controller.scrollController,
          // padding: EdgeInsets.only(
          //   bottom: MediaQuery.of(context).viewInsets.bottom > 0
          //       ? MediaQuery.of(context).viewInsets.bottom + 140
          //       : 140,
          // ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xffECF4FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if ((controller.visitor.registrationID ?? '')
                            .isNotEmpty)
                          Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Color(0xffD8E9FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/user_id.svg"),
                                SizedBox(width: 10),
                                Text(
                                  'Registration ID: ${controller.visitor.registrationID ?? '-'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.visitor.visitorName ?? '-',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  if ((controller.visitor.gstN ?? '')
                                      .isNotEmpty)
                                    Text(
                                      'GSTN: ${controller.visitor.gstN}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff4B4B4B),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  Text(
                                    controller.visitor.mobileNumber ?? '-',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff4B4B4B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'ID: ${controller.visitor.visitorID ?? '-'}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: controller.visitor.photoURL ?? '',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (_, __, ___) =>
                                    const Icon(Icons.person, size: 40),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Location',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xff525252),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${controller.visitor.address ?? ''}'
                          '${controller.visitor.city != null ? ', ${controller.visitor.city}' : ''}'
                          '${controller.visitor.pincode != null ? ' - ${controller.visitor.pincode}' : ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 8),
                        const Divider(color: Color(0xffB4B4B4)),
                        const SizedBox(height: 8),
                        Obx(() {
                          if (controller.selectedStatus.value == 1) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xffFFF4E5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'The status is Paid and is pending for '
                                'approval by the Admin. Hence, the '
                                'promoter cannot change the status.',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.textPrimary,
                                ),
                              ),
                            );
                          }

                          return Row(
                            children: [
                              Expanded(
                                child: CommonDropdown<String>(
                                  items: const [
                                    'Paid',
                                    'Complimentary',
                                    'Unpaid',
                                    'Rejected',
                                  ],
                                  hintText: 'Select',
                                  selectedItem:
                                      controller
                                          .statusController
                                          .text
                                          .isNotEmpty
                                      ? controller.statusController.text
                                      : null,
                                  onChanged: (value) {
                                    if (value != null) {
                                      controller.onStatusChanged(value);
                                    }
                                  },
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Please select branch';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          );
                        }),

                        // Payment Method Option - Display for only like - PAID / COMPLIMENTARY
                        Obx(() {
                          final status = controller.selectedStatus.value;

                          // ❌ Hide for UNPAID / REJECTED
                          if (status != 3) {
                            //  && status != 6
                            return const SizedBox.shrink();
                          }

                          // ✅ Show only for PAID / COMPLIMENTARY
                          return Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Divider(),
                                const SizedBox(height: 16),
                                Text(
                                  "Payment Method",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColor.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                radioTile("cash", "Cash"),
                                radioTile("upi", "UPI"),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        if (controller.selectedStatus.value == 1) {
          return const SizedBox.shrink();
        }

        final bottomInset = MediaQuery.of(context).viewInsets.bottom;

        return AnimatedPadding(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: bottomInset > 0 ? bottomInset + 12 : 20,
            top: 12,
          ),
          child: SafeArea(
            top: false,
            child: CommonButton(
              text: "Submit",
              isLoading: controller.isLoading.value,
              onPressed: () {
                final status = controller.selectedStatus.value;

                // 🔴 UNPAID / REJECTED / COMPLIMENTARY
                if (status == 0 || status == -1 || status == 6) {
                  controller.submitWithoutPayment();
                  return;
                }

                // 🟢 PAID
                if (!controller.validatePayment(formkey: formKey)) {
                  return;
                }

                controller.submit();
              },
            ),
          ),
        );
      }),
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
                  validator: (value) {
                    if (controller.selectedValue.value != 'cash') {
                      return null; // ❗ skip validation
                    }
                    if (value == null || value.trim().isEmpty) {
                      return 'Cash amount is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
              ),
            ],

            if (isSelected && value == "upi") ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    "assets/qr_code.jpeg",
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CommonTextField(
                  controller: controller.upiAmountController,
                  hintText: "Enter Cash Amount",
                  focusNode: controller.upiAmountFocusNode,
                  validator: (value) {
                    if (controller.selectedValue.value != 'upi') {
                      return null;
                    }
                    if (value == null || value.trim().isEmpty) {
                      return 'UPI amount is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CommonTextField(
                  key: controller.referenceFieldKey,
                  controller: controller.referenceIdController,
                  hintText: "Enter UPI Reference ID",
                  focusNode: controller.referenceIdFocusNode,
                  validator: (value) {
                    if (controller.selectedValue.value != 'upi') {
                      return null;
                    }
                    if (value == null || value.trim().isEmpty) {
                      return 'Reference ID is required';
                    }
                    if (value.length < 6) {
                      return 'Invalid reference ID';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}
