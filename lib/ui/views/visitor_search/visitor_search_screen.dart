import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:tjwd2d/common_widget/common_text_field.dart';
import 'package:tjwd2d/ui/views/visitor_search/visitor_search_controller.dart';

import '../../../common_widget/common_button.dart';
import '../../../common_widget/common_dropdown.dart';
import '../../../common_widget/tap_outside_unfocus.dart';
import '../../../core/res/colors.dart';
import '../../../locator.dart';
import '../../../services/session_service.dart';
import '../visitor_detail/visitor_detail_screen.dart';

class VisitorSearchScreen extends StatefulWidget {
  const VisitorSearchScreen({super.key});

  @override
  State<VisitorSearchScreen> createState() => _VisitorSearchScreenState();
}

class _VisitorSearchScreenState extends State<VisitorSearchScreen> {
  final VisitorSearchController controller = Get.put(VisitorSearchController());

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.selectedValue.value = "Search by GST";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffEFF2FF),
        title: SvgPicture.asset("assets/tjwd2d_Logo.svg", height: 40),
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
                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
      body: TapOutsideUnFocus(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //     SizedBox(height: 78),
                Text(
                  "Search For Visitor",
                  style: TextStyle(fontSize: 22, color: AppColor.textPrimary),
                ),
                SizedBox(height: 20),
                CommonDropdown<String>(
                  items: const [
                    'Search by GST',
                    'Search by Mobile Number',
                    'Search by Name',
                    'Search by Company Name',
                  ],
                  hintText: 'Select',
                  selectedItem: controller.selectedValue.value.isNotEmpty
                      ? controller.selectedValue.value
                      : null,
                  onChanged: (value) {
                    if (value != null) {
                      controller.onSearchTypeChanged(value);
                    }
                    // 🔥 Clear all validation errors
                    formKey.currentState?.reset();
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please select search type';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                Obx(() {
                  switch (controller.selectedValue.value) {
                    case 'Search by GST':
                      return CommonTextField(
                        controller: controller.searchGstController,
                        focusNode: controller.searchGstFocusNode,
                        hintText: 'Enter GST Number',
                        suffixIcon: const Icon(Icons.search),
                        textCapitalization: TextCapitalization.characters,
                        extraInputFormatters: [UpperCaseTextFormatter()],
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter GST';
                          }
                          return null;
                        },
                      );

                    case 'Search by Mobile Number':
                      return CommonTextField.phone(
                        controller: controller.searchMobileNumberController,
                        focusNode: controller.searchMobileNumberFocusNode,
                        hintText: 'Enter Mobile Number',
                        suffixIcon: const Icon(Icons.search),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter mobile number';
                          }
                          return null;
                        },
                      );

                    case 'Search by Name':
                      return Column(
                        children: [
                          CommonTextField(
                            controller: controller.searchNameController,
                            focusNode: controller.searchNameFocusNode,
                            hintText: 'Enter Name',
                            suffixIcon: const Icon(Icons.search),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          CommonTextField(
                            controller: controller.searchCityController,
                            focusNode: controller.searchCityFocusNode,
                            hintText: 'Enter City',
                            suffixIcon: const Icon(Icons.search),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter city';
                              }
                              return null;
                            },
                          ),
                        ],
                      );

                    case 'Search by Company Name':
                      return Column(
                        children: [
                          CommonTextField(
                            controller: controller.searchCompanyNameController,
                            focusNode: controller.searchCompanyNameFocusNode,
                            hintText: 'Enter Company Name',
                            suffixIcon: const Icon(Icons.search),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter company name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          CommonTextField(
                            controller: controller.searchCityController,
                            focusNode: controller.searchCityFocusNode,
                            hintText: 'Enter City',
                            suffixIcon: const Icon(Icons.search),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter city';
                              }
                              return null;
                            },
                          ),
                        ],
                      );

                    default:
                      return const SizedBox.shrink();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (MediaQuery.of(context).viewInsets.bottom > 0)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    child: const Text('Done'),
                  ),
                ),
              Obx(() {
                return CommonButton(
                  text: "Search",
                  onPressed: () {
                    if (formKey.currentState?.validate() != true) {
                      print('Form is invalid. Please correct the errors.');
                      return;
                    }
                    controller.searchApiCall();
                  },
                  isLoading: controller.isLoading.value,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget radioTile(String value, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: controller.selectedValue.value,
        onChanged: (val) {
          controller.selectedValue.value = val!;
        },
        title: Text(label),
      ),
    );
  }
}
