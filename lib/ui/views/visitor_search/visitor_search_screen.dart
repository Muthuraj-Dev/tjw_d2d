import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:tjwd2d/common_widget/common_text_field.dart';
import 'package:tjwd2d/ui/views/visitor_search/visitor_search_controller.dart';

import '../../../common_widget/common_button.dart';
import '../../../core/res/colors.dart';
import '../visitor_detail/visitor_detail_screen.dart';

class VisitorSearchScreen extends StatefulWidget {
  const VisitorSearchScreen({super.key});

  @override
  State<VisitorSearchScreen> createState() => _VisitorSearchScreenState();
}

class _VisitorSearchScreenState extends State<VisitorSearchScreen> {
  final VisitorSearchController controller = Get.put(VisitorSearchController());

  @override
  void initState() {
    super.initState();
    controller.selectedValue.value = "visitor_name";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 78),
            Text(
              "Search For Visitor",
              style: TextStyle(fontSize: 22, color: AppColor.textPrimary),
            ),
            SizedBox(height: 20),
            CommonTextField(
              controller: controller.searchVisitorController,
              focusNode: controller.searchVisitorFocusNode,
              hintText: "Search for visitor",
              // prefixIcon: Icon(Icons.search),
              suffixIcon: Icon(Icons.search),
            ),
            SizedBox(height: 12),
            Obx(() {
              return Column(
                children: [
                  radioTile("visitor_name", "Visitor Name"),
                  radioTile("company_gstn", "Company GSTN"),
                  radioTile("company_name", "Company Name"),
                  radioTile("mobile_number", "Mobile Number"),
                ],
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CommonButton(
            text: "Search",
            onPressed: () {
              Get.to(() => VisitorDetailScreen());
            },
            isLoading: controller.isLoading.value,
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
