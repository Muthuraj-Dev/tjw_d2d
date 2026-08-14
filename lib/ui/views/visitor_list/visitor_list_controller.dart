import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../core/model/searchResponse.dart';
import '../../../services/api_base_service.dart';
import '../../../services/request_method.dart';

class VisitorListController extends GetxController {
  /// Original list (never mutate)
  late final List<Data> originalVisitors;

  /// Filtered list (UI listens to this)
  final RxList<Data> filteredVisitors = <Data>[].obs;

  Map<String, String>? searchParams;

  /// Search controller
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  /// Observable to track text state
  final RxBool hasText = false.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('Initial text: "${searchController.text}"');

    final args = Get.arguments as Map<String, dynamic>?;

    /// Get visitors from previous screen
    // originalVisitors = (args['visitors'] as List).cast<Data>();
    // searchParams = (args['searchParams'] as Map<String, String>);

    // initialize only if args exist
    if (args != null) {
      originalVisitors = (args['visitors'] as List).cast<Data>();
      filteredVisitors.assignAll(originalVisitors);

      // store searchParams permanently
      searchParams = (args['searchParams'] as Map<String, String>?);
    } else {
      originalVisitors = [];
    }

    /// Initial load
    filteredVisitors.assignAll(originalVisitors);

    /// Listen to search changes
    searchController.addListener(() {
      hasText.value = searchController.text.isNotEmpty;
      _onSearchChanged();
    });
  }

  String statusLabelFromCode(int status) {
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

  Color statusColorFromCode(int status) {
    switch (status) {
      case 3: // Paid
        return Colors.green;

      case 6: // Complimentary
        return Colors.blue;

      case 0: // Unpaid
        return Colors.orange;

      case -1: // Rejected
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  void _onSearchChanged() {
    final query = searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      filteredVisitors.assignAll(originalVisitors);
      return;
    }

    filteredVisitors.assignAll(
      originalVisitors.where((visitor) {
        final name = visitor.visitorName?.toLowerCase() ?? '';
        final city = visitor.city?.toLowerCase() ?? '';
        final mobileNumber = visitor.mobileNumber?.toLowerCase() ?? '';
        final companyName = visitor.company?.toLowerCase() ?? '';

        return name.contains(query) ||
            city.contains(query) ||
            mobileNumber.contains(query) ||
            companyName.contains(query);
      }).toList(),
    );
  }

  var isLoading = false.obs;

  Future<void> refreshVisitorList() async {
    print("REFRESH API CALLS");

    if (isLoading.value) return;

    isLoading.value = true;

    final type = searchParams!['type'] ?? '';
    String query = '';

    switch (type) {
      case 'Search by GST':
        query = 'GSTNValue=${searchParams!['gst']}';
        break;
      case 'Search by Mobile Number':
        query = 'VisitorPhoneValue=${searchParams!['mobile']}';
        break;
      case 'Search by Name':
        query =
            'VisitorNameValue=${searchParams!['name']}&CityValue=${searchParams!['city']}';
        break;
      case 'Search by Company Name':
        query =
            'CompanyNameValue=${searchParams!['company']}&CityValue=${searchParams!['city']}';
        break;
    }

    try {
      final SearchResponse response =
          await ApiBaseService.request<SearchResponse>(
            'Search?$query',
            method: RequestMethod.GET,
            authenticated: false,
          );

      if (response.status == "200") {
        final searchResponse = SearchResponse.fromJson(response.toJson());
        filteredVisitors.assignAll(searchResponse.data ?? []);
        originalVisitors.assignAll(searchResponse.data ?? []);
      } else {
        originalVisitors.clear();
        filteredVisitors.clear();
        Fluttertoast.showToast(msg: 'No data found for search parameters');
      }
    } catch (e) {
      //    Get.snackbar('Error', 'Unable to fetch visitors');
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    searchController.clear();
    hasText.value = false;
    searchFocusNode.unfocus();

    /// Restore full list
    filteredVisitors.assignAll(originalVisitors);
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  void onBackFromDetails() {
    Get.back(result: true); // bubble signal up to search page
  }
}
