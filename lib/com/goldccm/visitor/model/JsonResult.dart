import 'dart:convert';



class JsonResult {
  String sign ;
  String desc ;
  Map<String,dynamic>  data;


  JsonResult.fromJson(var result){
    JsonDecoder jsonDecoder = new JsonDecoder();
    Map<String,dynamic> jsonResult =json.decode(result);
    var verify = jsonResult['verify'];
    data = jsonResult['data'];
    sign = jsonResult['verify']['sign'];
    desc = jsonResult['verify']['desc'];
  }
}