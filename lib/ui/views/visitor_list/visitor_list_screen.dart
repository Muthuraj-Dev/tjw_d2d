import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tjwd2d/ui/views/visitor_list/visitor_list_controller.dart';

import '../../../core/model/searchResponse.dart';
import '../../../core/res/colors.dart';
import '../../../locator.dart';
import '../../../services/session_service.dart';

class VisitorListScreen extends StatelessWidget {
  const VisitorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VisitorListController());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffEFF2FF),
        title: const Text('Visitor List'),
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
      body: Column(
        children: [
          /// 🔍 Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(
              () => TextField(
                controller: controller.searchController,
                focusNode: controller.searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search for name / city / company / mobile',

                  prefixIcon: const Icon(Icons.search),

                  /// ✅ Clear icon ONLY when text exists
                  suffixIcon: controller.hasText.value
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: controller.clearSearch,
                        )
                      : null,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          /// 📋 List
          Expanded(
            child: Obx(() {
              if (controller.filteredVisitors.isEmpty) {
                return const Center(child: Text('No visitors found'));
              }

              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.filteredVisitors.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      // Get.toNamed(
                      //   '/visitorDetailsScreen',
                      //   arguments: controller.filteredVisitors[index],
                      // );

                      final shouldRefresh = await Get.toNamed(
                        '/visitorDetailsScreen',
                        arguments: controller.filteredVisitors[index],
                      );

                      if (shouldRefresh == true) {
                        controller.searchController.clear();
                        controller.searchFocusNode.unfocus();
                        await controller.refreshVisitorList();
                      }
                    },
                    child: _VisitorCard(
                      visitor: controller.filteredVisitors[index],
                      controller: controller,
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _VisitorCard extends StatelessWidget {
  final Data visitor;
  final VisitorListController controller;

  const _VisitorCard({required this.visitor, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color(0xffECF4FF),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.person_outline_rounded, size: 36, color: Colors.black54),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Name
                Text(
                  visitor.visitorName ?? '—',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                //      const SizedBox(height: 2),

                /// Company
                if (visitor.company != null && visitor.company!.isNotEmpty)
                  Text(
                    visitor.company!,
                    style: const TextStyle(
                      color: Color(0xff555454),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                //    const SizedBox(height: 6),
                if (visitor.city != null)
                  Text(
                    visitor.city!,
                    style: const TextStyle(
                      color: Color(0xff555454),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                if (visitor.mobileNumber != null)
                  Text(
                    visitor.mobileNumber!,
                    style: const TextStyle(
                      color: Color(0xff555454),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (visitor.status != null)
                  Text(
                    controller.statusLabelFromCode(visitor.status!),
                    style: TextStyle(
                      color: controller.statusColorFromCode(visitor.status!),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
