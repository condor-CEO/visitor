import 'dart:async';
import 'package:flutter/material.dart';
import 'com/goldccm/visitor/util/DataUtils.dart';
import 'home.dart';
import 'package:visitor/com/goldccm/visitor/view/login/Login.dart';


class SplashPage extends StatefulWidget{
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
   initState()  {
    super.initState();
    checkIsLogin();
    _t = new Timer(const Duration(milliseconds: 1500), () {
      //延时操作启动页面后跳转到主页面
      try {
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(
               builder: (BuildContext context) => isLogin==true?new MyHomeApp():new Login()
                //builder: (BuildContext context) =>new MyHomeApp()
            ),
                (Route route) => route == null);
      } catch (e) {

      }
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
      child: new Image.asset('asset/images/visitor_bg_splash.png'),

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

  void checkIsLogin() async{
     isLogin = await DataUtils.isLogin();
  }

}