import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:tjwd2d/ui/views/visitor_list/visitor_list_controller.dart';

class VisitorListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitorListController>(() => VisitorListController());
  }
}
