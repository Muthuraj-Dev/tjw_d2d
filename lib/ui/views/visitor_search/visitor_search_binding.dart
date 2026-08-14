import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import 'package:tjwd2d/ui/views/visitor_search/visitor_search_controller.dart';

class VisitorSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitorSearchController>(() => VisitorSearchController());
  }
}
