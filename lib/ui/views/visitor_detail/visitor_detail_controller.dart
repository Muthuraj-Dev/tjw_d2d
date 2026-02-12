import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class VisitorDetailController extends GetxController{

  final TextEditingController statusController = TextEditingController();
  FocusNode statusFocusNode = FocusNode();

  final formSignUp = GlobalKey<FormState>();

  RxString selectedValue = "cash".obs;

  // Cash
  final cashAmountController = TextEditingController();
  FocusNode cashFocusNode = FocusNode();

  // UPI
  final referenceIdController = TextEditingController();
  FocusNode referenceIdFocusNode = FocusNode();

  final ScrollController scrollController = ScrollController();
  double lastScrollOffset = 0;



}