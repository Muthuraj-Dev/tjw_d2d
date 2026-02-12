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
import '../payment_mode/payment_method.dart';

class VisitorDetailScreen extends StatefulWidget {
  const VisitorDetailScreen({super.key});

  @override
  State<VisitorDetailScreen> createState() => _VisitorDetailScreenState();
}

class _VisitorDetailScreenState extends State<VisitorDetailScreen> {
  final VisitorDetailController controller = Get.put(VisitorDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        leading: const BackButton(
          color: AppColor.black,
        ), // optional, but explicit
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: controller.scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: List.generate(6, (index) {
                return Padding(
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
                                'Registration ID ${index} : GF25-TV20097',
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
                                    'Jonathan Emmanuel Rayappan',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'GSTN: 11GJIIF1234XIZ1',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff4B4B4B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '8888777700',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff4B4B4B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'ID: 8243',
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
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                imageUrl:
                                    'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341',
                                placeholder: (_, __) => const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
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
                        const Text(
                          'G-123, 1st Floor, 5th St, G Block, Annanagar East, Chennai, Tamil Nadu 600102',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: Color(0xffB4B4B4)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: CommonDropdown<String>(
                                items: const [
                                  'Paid',
                                  'Registered',
                                  'Complimentary',
                                  'Unpaid',
                                ],
                                hintText: 'Select',
                                selectedItem:
                                    controller.statusController.text.isNotEmpty
                                    ? controller.statusController.text
                                    : null,
                                onChanged: (value) {},
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Please select branch';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 150,
                              child: CommonButton(
                                text: 'Save',
                                borderRadius: BorderRadius.circular(8),
                                onPressed: () {
                                  controller.lastScrollOffset =
                                      controller.scrollController.offset;

                                  Get.to(() => PaymentMethod());

                                  // Restore scroll when coming back
                                  WidgetsBinding.instance.addPostFrameCallback((_,) {
                                    controller.scrollController.jumpTo(
                                      controller.lastScrollOffset,
                                    );
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
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
                  controller: controller.referenceIdController,
                  hintText: "Enter UPI reference ID",
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

// CommonDialog.showCustomDialog(
//   borderRadius: 26.0,
//   content: Padding(
//     padding: const EdgeInsets.all(
//       28.0,
//     ),
//     child: Column(
//       mainAxisSize:
//           MainAxisSize.min,
//       children: [
//         Text(
//           "Updated",
//           style: TextStyle(
//             fontSize: 28,
//             color: AppColor
//                 .textPrimary,
//             fontWeight:
//                 FontWeight.w600,
//           ),
//         ),
//         SizedBox(height: 6),
//         Container(
//           padding: EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: Color(0xffD8E9FF),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child:   Row(
//             children: [
//               SvgPicture.asset("assets/user_id.svg"),
//               SizedBox(width: 10,),
//               Text(
//                 'Registration ID : GF25-TV20097',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: AppColor.textPrimary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 6),
//         Text(
//           "Your data has been saved",
//           style: TextStyle(
//             fontSize: 14,
//             color: Color(
//               0xff6B6B6B,
//             ),
//           ),
//         ),
//         SizedBox(height: 26),
//         CommonButton(
//           text: "Close",
//           onPressed: () {
//             Get.back();
//           },
//         ),
//       ],
//     ),
//   ),
// );
