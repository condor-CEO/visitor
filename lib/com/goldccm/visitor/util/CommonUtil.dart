import 'DataUtils.dart';
import 'Md5Util.dart';
import 'dart:io';
import 'package:package_info/package_info.dart';


class CommonUtil{

  //获取当前系统时间yyyymmddHHMMss

  static String getCurrentTime(){
    var current = DateTime.now();
    return current.year.toString()+current.month.toString().padLeft(2,'0')+current.day.toString().padLeft(2,'0')+current.hour.toString().padLeft(2,'0')+
    current.minute.toString().padLeft(2,'2')+current.second.toString().padLeft(2,'0');
  }

  //计算当前的key，上送服务端校验
  static String calWorkKey() {
    String userId = Md5Util.instance .encryptByMD5ByHex(DataUtils.getUserId().toString().padLeft(12,'F'));
    String token = Md5Util.instance.encryptByMD5ByHex(DataUtils.getAccessToken().toString());
    String currDate = Md5Util.instance.encryptByMD5ByHex(getCurrentTime());
    String keyStr = userId.substring(6,12)+currDate.substring(2,14)+token.substring(5,10);
    return Md5Util.instance.encryptByMD5ByHex(keyStr).toUpperCase();

  }

  //获取平台信息
   static String getAppPlat(){
    String appPlat='';
    if(Platform.isAndroid){
      appPlat ="android";
    }else if(Platform.isIOS){
      appPlat = "ios";
    }else if(Platform.isMacOS){
      appPlat = "macos";
    }else if(Platform.isWindows){
      appPlat = "windows";
    }else if(Platform.isLinux){
      appPlat = "linux";
    }else{
      appPlat ="other";
    }
    return appPlat;
   }

   //获取app版本信息
static String  getAppVersion(){
    String appVersion="";
    //异步获取
   PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
     appVersion = packageInfo.version;
  });
  return appVersion;


}



}