import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myapp/models/apidata_model.dart';

class DataService {
  var url = "https://fakestoreapi.com/products/1";

  Future<ApiDataModel?> getService() async {
    var responce = await http.get(Uri.parse(url));
    if (responce.statusCode == 200) {
      var data = await jsonDecode(responce.body);
      return ApiDataModel.fromJson(data);
    }

    return null;
  }
}
