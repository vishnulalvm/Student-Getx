import 'package:get/get.dart';
import 'package:myapp/controllers/student_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
     Get.put(StudentController());
  }
}