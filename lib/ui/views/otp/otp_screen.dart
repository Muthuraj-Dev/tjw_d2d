import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:pinput/pinput.dart';
import 'package:tjwd2d/ui/views/otp/otp_controller.dart';

import '../../../common_widget/common_button.dart';
import '../../../common_widget/tap_outside_unfocus.dart';
import '../../../core/res/colors.dart';
import '../../ui_spacing.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final OtpController controller = Get.find<OtpController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: TapOutsideUnFocus(
        child: SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.primary, width: 1.2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: UISpacing.h(context, 0.12)),
                        // logo top space
                        Center(
                          child: SvgPicture.asset("assets/tjwd2d_Logo.svg"),
                        ),
                        SizedBox(height: UISpacing.h(context, 0.08)),

                        // logo → title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            "Enter code sent to your phone",
                            style: const TextStyle(
                              fontSize: 32,
                              color: AppColor.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            "We sent it to the number - ${controller.mobileNumber}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColor.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 22),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Pinput(
                            length: 4,
                            controller: controller.otpController,
                            focusNode: controller.otpFocusNode,
                            validator: (value) {
                              if (value == null || value.length != 4) {
                                return 'Enter valid 4-digit OTP';
                              }
                              return null;
                            },
                            errorTextStyle: TextStyle(
                              color: Colors.red,
                            ),
                            defaultPinTheme: PinTheme(
                              width: 70,
                              height: 70,
                              textStyle: const TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColor.primary,
                                  width: 1.2,
                                ),
                              ),
                            ),
                            focusedPinTheme: PinTheme(
                              width: 70,
                              height: 70,
                              textStyle: const TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColor.primary,
                                  width: 1.2,
                                ),
                              ),
                            ),
                            submittedPinTheme: PinTheme(
                              width: 70,
                              height: 70,
                              textStyle: const TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColor.primary,
                                  width: 1.2,
                                ),
                              ),
                            ),
                            separatorBuilder: (index) =>
                                const SizedBox(width: 16),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Obx((){
                  return CommonButton(
                    fillColor: AppColor.white,
                    isOutlined: true,
                    textColor: AppColor.primary,
                    text: "Resend",
                    onPressed: () {
                      if (!controller.formKey.currentState!.validate()) {
                        return;
                      }
                      controller.verifyOtp(
                        otpId: controller.otpId.value,
                        enteredOtp: int.parse(controller.otpController.text),
                      );
                    },
                    isLoading: controller.isLoading.value,
                  );
                })
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx((){
                  return  CommonButton(
                    text: "Continue",
                    onPressed: () {
                      if (!controller.formKey.currentState!.validate()) {
                        return;
                      }
                      controller.verifyOtp(
                        otpId: controller.otpId.value,
                        enteredOtp: int.parse(controller.otpController.text),
                      );
                    },
                    isLoading: controller.isLoading.value,
                  );
                })

              ),
            ],
          ),
        ),
      ),
    );
  }
}
