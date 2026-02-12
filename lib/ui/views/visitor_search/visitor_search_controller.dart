import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class VisitorSearchController extends GetxController{
  final formKey = GlobalKey<FormState>();

  final TextEditingController searchVisitorController = TextEditingController();
  FocusNode searchVisitorFocusNode = FocusNode();

  RxString selectedValue = "".obs;

  var isLoading = false.obs;



}