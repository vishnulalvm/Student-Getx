import 'package:get/get.dart';
import 'package:myapp/controllers/data_controller.dart';


class ShopdetailBind extends Bindings {
  @override
  void dependencies() {
     Get.put(DataController());
  }
}