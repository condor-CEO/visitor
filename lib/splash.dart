import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'com/goldccm/visitor/util/DataUtils.dart';
import 'home.dart';
import 'package:visitor/com/goldccm/visitor/view/login/Login.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SplashState();
  }
}

class SplashState extends State<SplashPage> {
  Timer _t;
//  Future<UserInfo> _userInfo;
  bool isLogin;
  @override
  initState() {
    super.initState();
    checkIsLogin();
    checkPermission();
  }
  Future checkPermission() async {
    PermissionStatus contactsPermission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    PermissionStatus storagePermission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (contactsPermission.value != 2) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
          .requestPermissions([PermissionGroup.contacts]);
      if(permissions.entries.elementAt(0).value.toString()=="PermissionStatus.denied"){
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    }
    if(storagePermission.value !=2){
      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
      if(permissions.entries.elementAt(0).value.toString()=="PermissionStatus.denied"){
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    }
      _t = new Timer(const Duration(milliseconds: 1500), () {
        //延时操作启动页面后跳转到主页面
        try {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  isLogin == true ? new MyHomeApp() : new Login()
              ),
                  (Route route) => route == null);
        } catch (e) {}
      });
  }
  @override
  void dispose() {
    _t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    return new Material(
//      color: Colors.blue,
//      child: new Padding(
//          padding: const EdgeInsets.only(
//            top: 150,
//          ),
//        child: new Image.asset('asset/images/visitor_bg_splash.png')
//    )
//    );}

    return new Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color:Color.fromRGBO(88, 123, 239, 1.0),
      child: Container(
        child: FittedBox(
          fit: BoxFit.none,
          child: Image.asset('asset/icons/跳转图片.png',scale: 2.0,),
        ),
      ),
    );
    //,new Column(
//          children: <Widget>[
//
//            new Image.asset(""),
//
//            new Text('朋悦比邻',
//              style: new TextStyle(
//                  fontSize: 50.0,
//                  fontWeight: FontWeight.bold,
//                  fontFamily:'楷体_GB2312',
//                  color: Colors.white
//              ),
//            )
//
//          ],
//
//        ),
//        child: new Image.asset('asset/images/visitor_bg_splash.png'), //联客应用初始化可这样加载
//      ),

//    );
    //}
  }

  void checkIsLogin() async {
    isLogin = await DataUtils.isLogin();
  }
}
