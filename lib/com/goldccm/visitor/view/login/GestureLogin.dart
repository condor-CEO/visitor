import 'package:gesture_password/gesture_password.dart';
import 'package:flutter/material.dart';
import 'package:gesture_password/gesture_password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';
import 'package:visitor/com/goldccm/visitor/util/Md5Util.dart';

class GestureLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new GestureLoginState();
  }
}

class GestureLoginState extends State<GestureLogin> {
  @override
  void initState() {
    super.initState();
  }
//  GlobalKey<GesturePasswordState> miniGesturePassword =
//      new GlobalKey<GesturePasswordState>();
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.lightBlue,
          leading: IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              }),
          centerTitle: true,
          title: new Text(
            "手势密码登录",
            textAlign: TextAlign.center,
            style: new TextStyle(
                fontSize: 18.0, color: Colors.white, fontFamily: '楷体_GB2312'),
          ),
        ),
        body: new Column(children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image.asset("asset/images/visitor_logo.png"),
              ],
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(""),
              ],
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: new Center(
                child: new Container(
              //    color: Colors.red,
              margin: const EdgeInsets.only(top: 10.0),
              child: new GesturePassword(
                //width: 200.0,
                attribute: ItemAttribute.normalAttribute,
                successCallback: (s) {
                  print("successCallback$s");
                  verifyGesturePwd(s);
                  scaffoldState.currentState?.showSnackBar(
                      new SnackBar(content: new Text('successCallback:$s')));
                },
                failCallback: () {
                  print('failCallback');
                  scaffoldState.currentState?.showSnackBar(
                      new SnackBar(content: new Text('failCallback')));
                },
                selectedCallback: (str) {
                  print("selectedCallback$str");
                  scaffoldState.currentState
                      ?.showSnackBar(new SnackBar(content: new Text(str)));
                },
              ),
            )),
          )
        ]));
  }
  getPhone() async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    String phone = prefs.getString("PHONE");
    print(phone);
    return phone;
  }
  verifyGesturePwd (String s) async {
    String phone=await getPhone();
    String url = Constant.serverUrl+Constant.loginUrl;
    String _passNum = Md5Util().encryptByMD5ByHex(s);
    var res = await Http().post(url, queryParameters: {
      "phone": phone,
      "style": "2",
      "sysPwd": _passNum,
    });
  }
}
