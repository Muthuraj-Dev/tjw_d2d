import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tjwd2d/core/model/searchResponse.dart';

import '../../../services/api_base_service.dart';
import '../../../services/request_method.dart';

class VisitorSearchController extends GetxController{


  final TextEditingController statusController = TextEditingController();
  FocusNode statusFocusNode = FocusNode();

  final TextEditingController searchNameController = TextEditingController();
  final TextEditingController searchGstController = TextEditingController();
  final TextEditingController searchMobileNumberController = TextEditingController();
  final TextEditingController searchCompanyNameController = TextEditingController();
  final TextEditingController searchCityController = TextEditingController();

  FocusNode searchNameFocusNode = FocusNode();
  FocusNode searchGstFocusNode = FocusNode();
  FocusNode searchMobileNumberFocusNode = FocusNode();
  FocusNode searchCompanyNameFocusNode = FocusNode();
  FocusNode searchCityFocusNode = FocusNode();

  RxString selectedValue = "".obs;

  var isLoading = false.obs;


  void onSearchTypeChanged(String value) {
    selectedValue.value = value;
    statusController.text = value;

    /// 🔴 clear previous inputs when switching
    searchNameController.clear();
    searchGstController.clear();
    searchMobileNumberController.clear();
    searchCompanyNameController.clear();
    searchCityController.clear();
  }

  /// result
  RxList<Data> searchResults = <Data>[].obs;
  RxInt dataFound = 0.obs;

  Future<void> searchApiCall() async {

    if (isLoading.value) return;

    isLoading.value = true;
    searchResults.clear();
    dataFound.value = 0;

    try {
      /// 🔹 Build query dynamically
      String query = '';

      switch (selectedValue.value) {
        case 'Search by GST':
          query = 'GSTNValue=${searchGstController.text.trim()}';
          break;

        case 'Search by Mobile Number':
          query = 'VisitorPhoneValue=${searchMobileNumberController.text.trim()}';
          break;

        case 'Search by Name':
          query =
          'VisitorNameValue=${searchNameController.text.trim()}&CityValue=${searchCityController.text.trim()}';
          break;

        case 'Search by Company Name':
          query =
          'CompanyNameValue=${searchCompanyNameController.text.trim()}&CityValue=${searchCityController.text.trim()}';
          break;

        default:
          Fluttertoast.showToast(msg: 'Please select search type');
          return;
      }

      /// 🔹 API call
      final SearchResponse response = await ApiBaseService.request<SearchResponse>(
        'Search?$query',
        method: RequestMethod.GET,
        authenticated: false,
      );

      if (response.status == "200") {
        final searchResponse = SearchResponse.fromJson(response.toJson());

        dataFound.value = searchResponse.dataFound ?? 0;
        searchResults.assignAll(searchResponse.data ?? []);

        final searchParams = {
          'type': selectedValue.value,
          'gst': searchGstController.text.trim(),
          'mobile': searchMobileNumberController.text.trim(),
          'name': searchNameController.text.trim(),
          'city': searchCityController.text.trim(),
          'company': searchCompanyNameController.text.trim(),
        };

        print("searchParams $searchParams");

        Get.toNamed(
          '/visitorListScreen',
          arguments: {
            'visitors': searchResponse.data ?? [],
            'searchParams': searchParams,
          },
        );

    //    Get.toNamed('/visitorListScreen', arguments: searchResponse.data ?? []);

        if (response.dataFound == 0) {
          Fluttertoast.showToast(msg: 'No records found');
        }
      } else {
        Fluttertoast.showToast(
          msg: 'No data found for Search Parameters.',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to fetch search results',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}