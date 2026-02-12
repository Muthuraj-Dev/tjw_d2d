// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:tjwd2d/ui/views/phone/phone_controller.dart';
// import '../../../common_widget/common_button.dart';
// import '../../../common_widget/common_text_field.dart';
// import '../../../common_widget/tap_outside_unfocus.dart';
// import '../../../core/res/colors.dart';
//
// class PhoneScreen extends StatefulWidget {
//   bool? isOptScreen;
//
//   PhoneScreen({this.isOptScreen, super.key});
//
//   @override
//   State<PhoneScreen> createState() => _PhoneScreenState();
// }
//
// class _PhoneScreenState extends State<PhoneScreen> {
//   final PhoneController controller = Get.put(PhoneController());
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: AppColor.lightGrey,
//       extendBodyBehindAppBar: true,
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         return TapOutsideUnFocus(
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               return SingleChildScrollView(
//                 padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).viewInsets.bottom,
//                 ),
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                   child: IntrinsicHeight(
//                     child: Form(
//                       key: controller.formKey,
//                       child: Column(
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               border: Border.all(color: AppColor.primary,width: 1.2),
//                               borderRadius: BorderRadius.only(
//                                 bottomLeft: Radius.circular(30),
//                                 bottomRight: Radius.circular(30),
//                               ),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(20),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SizedBox(height: 132),
//                                   Center(
//                                     child: SvgPicture.asset("assets/tjwd2d_Logo.svg"),
//                                   ),
//                                   SizedBox(height: 125),
//                                   Text(
//                                     "Enter your Mobile Number",
//                                     style: const TextStyle(
//                                       fontSize: 32,
//                                       color: AppColor.textPrimary,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 12),
//                                   Text(
//                                     "We will send you confirmation code",
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       color: AppColor.textPrimary,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 12),
//                                   CommonTextField.phone(
//                                     controller: controller.phoneController,
//                                     focusNode: controller.phoneFocusNode,
//                                     hintText: 'Phone Number *',
//                                     textStyle: const TextStyle(
//                                       fontSize: 18,
//                                       color: AppColor.textPrimary,
//                                     ),
//                                     errorTextColor: Colors.black54,
//                                     onChanged: (val) {
//                                       if (val.isNotEmpty) {
//                                         RegExp phoneRegExp = RegExp(
//                                           r'^[0-9]{10}$',
//                                         );
//                                         if (phoneRegExp.hasMatch(val)) {
//                                           // ✅ Close keyboard once phone is valid
//                                           FocusScope.of(
//                                             controller.phoneFocusNode.context!,
//                                           ).unfocus();
//                                         }
//                                       }
//                                     },
//                                     validator: (val) {
//                                       if (val == null || val.isEmpty) {
//                                         return 'Please enter phone number';
//                                       }
//                                       RegExp phoneRegExp = RegExp(
//                                         r'^[0-9]{10}$',
//                                       );
//                                       if (!phoneRegExp.hasMatch(val)) {
//                                         return 'Please enter a valid phone number';
//                                       }
//                                       return null; // ✅ don’t unfocus here
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       }),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child: Obx(() {
//             return CommonButton(
//               text: "Continue",
//               onPressed: controller.mobileOtp,
//               isLoading: controller.isLoading.value,
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../common_widget/common_button.dart';
import '../../../common_widget/common_text_field.dart';
import '../../../common_widget/tap_outside_unfocus.dart';
import '../../../core/res/colors.dart';
import '../../ui_spacing.dart';
import 'phone_controller.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  // GetX controller (already created by Binding)
  final PhoneController controller = Get.find<PhoneController>();

  // UI lifecycle objects
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController phoneTextController = TextEditingController();
  final FocusNode phoneFocusNode = FocusNode();

  @override
  void dispose() {
    phoneTextController.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightGrey,
      // extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      extendBody: true,

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return TapOutsideUnFocus(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColor.primary,
                              width: 1.2,
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                SizedBox(height: UISpacing.h(context, 0.18)), // logo top space
                                Center(child: SvgPicture.asset("assets/tjwd2d_Logo.svg")),
                                SizedBox(height: UISpacing.h(context, 0.15)), // logo → title
                                
                                const Text(
                                  "Enter your Mobile Number",
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: AppColor.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  "We will send you confirmation code",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                /// Phone field
                                CommonTextField.phone(
                                  controller: phoneTextController,
                                  focusNode: phoneFocusNode,
                                  hintText: 'Phone Number *',
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    color: AppColor.textPrimary,
                                  ),
                                  errorTextColor: Colors.black54,
                                  //   onChanged: controller.onPhoneChanged,
                                  onChanged: (val) {
                                    if (val.isNotEmpty) {
                                      RegExp phoneRegExp = RegExp(
                                        r'^[0-9]{10}$',
                                      );
                                      if (phoneRegExp.hasMatch(val)) {
                                        // ✅ Close keyboard once phone is valid
                                        FocusScope.of(
                                          phoneFocusNode.context!,
                                        ).unfocus();
                                      }
                                    }
                                  },
                                  validator: controller.validatePhone,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),

      bottomNavigationBar : SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Obx(
                () => CommonButton(
              text: "Continue",
              isLoading: controller.isLoading.value,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  controller.mobileOtp(phoneTextController.text.trim());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
