import 'dart:convert';



class JsonResult {
  String sign ;
  String desc ;
  var  data;


  JsonResult.fromJson(var result){
    JsonDecoder jsonDecoder = new JsonDecoder();
    var jsonResult =jsonDecoder.convert(result);
    var verify = jsonResult['verify'];
    data = jsonResult['data'];
    sign = verify['sign'];
    desc = verify['desc'];
  }
}