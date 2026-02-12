import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PaymentMethodController extends GetxController {
  RxString selectedValue = "cash".obs;

  // Cash
  final cashAmountController = TextEditingController();
  FocusNode cashFocusNode = FocusNode();

  // UPI
  final referenceIdController = TextEditingController();
  FocusNode referenceIdFocusNode = FocusNode();
}
