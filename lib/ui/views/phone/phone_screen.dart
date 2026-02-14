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
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../common_widget/common_button.dart';
import '../../../common_widget/common_dialog.dart';
import '../../../common_widget/common_text_field.dart';
import '../../../common_widget/tap_outside_unfocus.dart';
import '../../../core/res/colors.dart';
import '../../../locator.dart';
import '../../../services/appconfig_service.dart';
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


  late final AppConfig? appConfig;

  @override
  void initState() {
    super.initState();

    appConfig = locator<AppConfigService>().config;

    /// 🔴 Show dialog AFTER first frame
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (appConfig?.isAppActive == false) {
    //     _showAppInactiveDialog();
    //   }
    // });
  }


  DateTime? _lastBackPressed;

  void _handleBack(bool didPop, dynamic result) {
    debugPrint("⬅️ BACK PRESSED | didPop = $didPop");
    if (didPop) return;

    final now = DateTime.now();

    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Press back again to exit"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    SystemNavigator.pop();
  }



  @override
  void dispose() {
    phoneTextController.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return PopScope (
      canPop: false,
      onPopInvokedWithResult: _handleBack,
      child: Scaffold(
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

                                  SizedBox(height: UISpacing.h(context, 0.14)), // logo top space
                                  Center(child: SvgPicture.asset("assets/tjwd2d_Logo.svg")),
                                  SizedBox(height: UISpacing.h(context, 0.10)), // logo → title

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
      ),
    );
  }

  void _showAppInactiveDialog() {
    CommonDialog.showCustomDialog(
      barrierDismissible: false, // ⛔ block tap outside
      borderRadius: 26.0,
      content: PopScope(
        canPop: false,
        onPopInvokedWithResult: _handleBack,
        child: AnimatedPadding(
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
                    /// 🔴 Title
                    Text(
                      "App Temporarily Unavailable",
                      style: TextStyle(
                        fontSize: 28,
                        color: AppColor.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    /// Info Box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xffD8E9FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info,size: 22,),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              "This application is currently inactive.\n"
                                  "Please try again later.",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColor.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// Subtitle
                    const Text(
                      "We are performing maintenance or updates.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff6B6B6B),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 26),

                    /// Close button (optional exit)
                    CommonButton(
                      text: "Close",
                      onPressed: () {
                        // Option 1: Just close dialog (app stays blocked)
                        // Get.back();

                        // Option 2: Exit app (recommended)
                         SystemNavigator.pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
