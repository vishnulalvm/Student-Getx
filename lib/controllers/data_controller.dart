import 'package:get/get.dart';
import 'package:myapp/models/apidata_model.dart';
import 'package:myapp/services/data_service.dart';

class DataController extends GetxController {
  var apiDataModel = ApiDataModel().obs;
  getData ()async{
    var data = await DataService().getService();
  try{
      if(data !=null){
      apiDataModel.value = data;
    }
  }catch(e){
    Get.snackbar('Error', "error ${e.toString()}");
  }
  }
  @override
  void onInit() {
    super.onInit();
    getData();
  }
}
