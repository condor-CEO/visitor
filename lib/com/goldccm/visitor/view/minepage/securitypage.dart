import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:gesture_password/gesture_password.dart';
import 'package:gesture_password/mini_gesture_password.dart';
import 'package:visitor/com/goldccm/visitor/util/Md5Util.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';

class SecurityPage extends StatefulWidget {
  SecurityPage({Key key, this.userInfo}) : super(key: key);
  final UserInfo userInfo;
  @override
  State<StatefulWidget> createState() {
    return SecurityPageState();
  }
}

class SecurityPageState extends State<SecurityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('安全管理'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('换绑手机'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                widget.userInfo.phone != null
                    ? Text(widget.userInfo.phone)
                    : Text(""),
                Image.asset('asset/images/visitor_icon_next.png', scale: 2.0),
              ],
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChangePhonePage()));
            },
          ),
          Divider(height: 0.0),
          ListTile(
            title: Text('修改登录密码'),
            trailing:
                Image.asset('asset/images/visitor_icon_next.png', scale: 2.0),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChangePwdPage(userInfo: widget.userInfo)));
            },
          ),
          Divider(height: 0.0),
          ListTile(
            title: Text('设置手势密码'),
            trailing:
                Image.asset('asset/images/visitor_icon_next.png', scale: 2.0),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChangeGesturePage()));
            },
          ),
        ],
      ),
    );
  }
}

class ChangePhonePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChangePhonePageState();
  }
}

class ChangePhonePageState extends State<ChangePhonePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('更换手机'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            color: Colors.white,
            height: 60,
            child: Row(
              children: <Widget>[
                Text(
                  '新手机号',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Container(
                  width: 180,
                  padding: EdgeInsets.fromLTRB(30, 0.0, 0.0, 0.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '请输入手机号',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0.0,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            color: Colors.white,
            height: 60,
            child: Row(
              children: <Widget>[
                Text(
                  '验证码',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Container(
                  width: 180,
                  padding: EdgeInsets.fromLTRB(45, 0.0, 0.0, 0.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '请输入验证码',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                RaisedButton(
                    color: Colors.white,
                    textColor: Colors.blue,
                    elevation: 0,
                    child: Text('发送验证码'),
                    onPressed: () {})
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: new SizedBox(
              width: 300.0,
              height: 50.0,
              child: new RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: new Text('提交', style: TextStyle(fontSize: 16)),
                onPressed: () async {},
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ChangePwdPage extends StatefulWidget {
  ChangePwdPage({Key key, this.userInfo}) : super(key: key);
  final UserInfo userInfo;
  @override
  State<StatefulWidget> createState() {
    return ChangePwdPageState();
  }
}

class ChangePwdPageState extends State<ChangePwdPage> {
  var _phone;
  final _formKey = GlobalKey<FormState>();
  String _oldPassword;
  String _newPassword;
  String _confirmPassword;
  @override
  void initState() {
    super.initState();
    _phone = widget.userInfo.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('更换手机'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(30),
                child: Container(
                  height: 20,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('为你的账号'),
                      _phone != null
                          ? Text(_phone, style: TextStyle(color: Colors.red))
                          : Text(""),
                      Text('设定新的登录密码'),
                    ],
                  ),
                )),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              color: Colors.white,
              height: 60,
              child: Row(
                children: <Widget>[
                  Text(
                    '旧密码',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Container(
                    width: 180,
                    padding: EdgeInsets.fromLTRB(45, 0.0, 0.0, 0.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: '请输入旧密码',
                        border: InputBorder.none,
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return '请不要输入空密码';
                        }
                        _oldPassword=value;
                      },
                      onSaved: (value){
                        _oldPassword=value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0.0,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              color: Colors.white,
              height: 60,
              child: Row(
                children: <Widget>[
                  Text(
                    '新密码',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Container(
                    width: 180,
                    padding: EdgeInsets.fromLTRB(45, 0.0, 0.0, 0.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: '请输入新密码',
                        border: InputBorder.none,
                      ),
                      validator: (value){
                        if(value.isEmpty&&_oldPassword!=null){
                          return '请不要输入空密码';
                        }
                        _newPassword=value;
                      },
                      onSaved: (value){
                        _newPassword=value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0.0,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              color: Colors.white,
              height: 60,
              child: Row(
                children: <Widget>[
                  Text(
                    '确认密码',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Container(
                    width: 180,
                    padding: EdgeInsets.fromLTRB(30, 0.0, 0.0, 0.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: '请确认新密码',
                        border: InputBorder.none,
                      ),
                      validator: (value){
                        if(value.isEmpty&&_newPassword!=null&&_oldPassword!=null&&_newPassword!=""&&_oldPassword!=""){
                          return '请不要输入空密码';
                        }
                        if(value!=_newPassword){
                          return '两次密码不一致';
                        }
                      },
                      onSaved: (value){
                        _confirmPassword=value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: new SizedBox(
                width: 300.0,
                height: 50.0,
                child: new RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: new Text('提交', style: TextStyle(fontSize: 16)),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                        _formKey.currentState.save();
                        _updatePwd();
                    }
                  },
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
   _updatePwd()  async {
    String url = "http://192.168.101.20:8080/api_visitor/user/update/sysPwd";
    var res = await Http().post(url, queryParameters: {
      "userId": 27,
      "token": "24d16d8a-f9d6-4249-8704-fa6a3fb76ac6",
      "threshold": "71B7735F3E9EC0814B1DC612A1A4A7F0",
      "factor": "20170831143600",
      "newPassword":Md5Util().encryptByMD5ByHex(_newPassword),
      "oldPassword":Md5Util().encryptByMD5ByHex(_oldPassword),
    });
    if (res != null) {
      Map map = jsonDecode(res);
      if(map['verify']['sign']=='success'){
        ToastUtil.showShortClearToast(map['verify']['desc']);
      }else{
        ToastUtil.showShortClearToast(map['verify']['desc']);
      }
    }
  }
}

class ChangeGesturePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChangeGesturePageState();
  }
}

bool _value = false;

class ChangeGesturePageState extends State<ChangeGesturePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设定手势密码'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text('手势密码'),
            trailing: Switch(
              value: _value,
              onChanged: (newValue) {
                setState(() {
                  _value = newValue;
                  if (newValue == true) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => GesturePage()));
                  }
                });
              },
              activeColor: Colors.blue,
            ),
          ),
          showUpdateGesture(context)
        ],
      ),
    );
  }
}

Widget showUpdateGesture(BuildContext context) {
  if (_value == true) {
    return ListTile(
      title: Text('修改手势密码'),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UpdateGesturePage()));
      },
    );
  } else {
    return ListTile();
  }
}
class UpdateGesturePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UpdateGesturePageState();
  }
}

class UpdateGesturePageState extends State<UpdateGesturePage> {
  var pastStr;
  var firstStr;
  var repeatStr;
  var _noticeStr = "请绘制解锁图案";
  var _color = Colors.blue;
  Timer _timer;
  int _countdownTime = 0;
  @override
  void initState() {
    super.initState();
    _noticeStr='请绘制旧解锁图案';
  }
  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);

    var callback = (timer) => {
      setState(() {
        if (_countdownTime < 1) {
          _timer.cancel();
          _noticeStr = "请绘制旧解锁图案";
          _color = Colors.blue;
        } else {
          _countdownTime = _countdownTime - 1;
          print(_countdownTime);
        }
      })
    };

    _timer = Timer.periodic(oneSec, callback);
  }
  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
      _noticeStr = "请绘制旧解锁图案";
      _color = Colors.blue;
    }
  }
  GlobalKey<MiniGesturePasswordState> miniGesturePassword =
  new GlobalKey<MiniGesturePasswordState>();
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('更新手势密码'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Center(
              child: MiniGesturePassword(key: miniGesturePassword),
            ),
            padding: EdgeInsets.all(20),
          ),
          Center(
            child: Text(
              '$_noticeStr',
              style: TextStyle(color: _color, fontSize: 16),
            ),
          ),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                margin: EdgeInsets.only(top: 30.0),
                child: GesturePassword(
                  successCallback: (s) {
                    print("successCallback$s");
                    if(pastStr==null){
                      pastStr=s;
                      setState(() {
                        _noticeStr = "请绘制新解锁图案";
                      });
                    }
                    else if (firstStr == null) {
                      firstStr = s;
                      print('first$s');
                      setState(() {
                        _noticeStr = "请重新绘制新解锁图案";
                      });
                    } else {
                      repeatStr = s;
                      if(firstStr==repeatStr){
                        _updateGesPwd();
                      }
                      firstStr = null;
                      pastStr=null;
                      print('repeat$s');
                      setState(() {
                        _countdownTime = 1;
                        _noticeStr = "两次绘制的解锁图案不同";
                        _color = Colors.red;
                      });
                      startCountdownTimer();
                    }
                    scaffoldState.currentState?.showSnackBar(
                        SnackBar(content: Text('successCallback:$s')));
                    miniGesturePassword.currentState?.setSelected('');
                  },
                  failCallback: () {
                    print('failCallback');
                    if (_countdownTime == 0) {
                      setState(() {
                        _countdownTime = 1;
                        _noticeStr = "绘制失败，请重新绘制解锁图案";
                        _color = Colors.red;
                      });
                      startCountdownTimer();
                    }
                    scaffoldState.currentState
                        ?.showSnackBar(SnackBar(content: Text('failCallback')));
                    miniGesturePassword.currentState?.setSelected('');
                  },
                  selectedCallback: (str) {
                    miniGesturePassword.currentState?.setSelected(str);
                  },
                  attribute: ItemAttribute(
                      lineStrokeWidth: 2.0,
                      circleStrokeWidth: 2.0,
                      smallCircleR: 10.0,
                      bigCircleR: 30.0,
                      focusDistance: 25.0,
                      normalColor: const Color(0xFFBBDEFB),
                      selectedColor: const Color(0xFF1565C0)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  _updateGesPwd()async{
    String url = "http://192.168.101.20:8080/api_visitor/user/updateGesturePwd";
    var res = await Http().post(url, queryParameters: {
      "userId": 27,
      "token": "24d16d8a-f9d6-4249-8704-fa6a3fb76ac6",
      "threshold": "71B7735F3E9EC0814B1DC612A1A4A7F0",
      "factor": "20170831143600",
      "newPassword":Md5Util().encryptByMD5ByHex(firstStr),
      "oldPassword":Md5Util().encryptByMD5ByHex(pastStr),
    });
    if (res != null) {
      Map map = jsonDecode(res);
      if(map['verify']['sign']=='success'){
        Navigator.pop(context);
        ToastUtil.showShortClearToast(map['verify']['desc']);
      }else{
        Navigator.pop(context);
        ToastUtil.showShortClearToast(map['verify']['desc']);
      }
    }
  }
}

class GesturePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GesturePageState();
  }
}
 class GesturePageState extends State<GesturePage> {
  var firstStr;
  var repeatStr;
  var _noticeStr = "请绘制解锁图案";
  var _color = Colors.blue;
  Timer _timer;
  int _countdownTime = 0;
  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);

    var callback = (timer) => {
          setState(() {
            if (_countdownTime < 1) {
              _timer.cancel();
              _noticeStr = "请绘制解锁图案";
              _color = Colors.blue;
            } else {
              _countdownTime = _countdownTime - 1;
              print(_countdownTime);
            }
          })
        };

    _timer = Timer.periodic(oneSec, callback);
  }
  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
        _noticeStr = "请绘制解锁图案";
        _color = Colors.blue;
    }
  }
  GlobalKey<MiniGesturePasswordState> miniGesturePassword =
      new GlobalKey<MiniGesturePasswordState>();
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设定手势密码'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Center(
              child: MiniGesturePassword(key: miniGesturePassword),
            ),
            padding: EdgeInsets.all(20),
          ),
          Center(
            child: Text(
              '$_noticeStr',
              style: TextStyle(color: _color, fontSize: 16),
            ),
          ),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                margin: EdgeInsets.only(top: 30.0),
                child: GesturePassword(
                  successCallback: (s) {
                    print("successCallback$s");
                    if (firstStr == null) {
                      firstStr = s;
                      print('first$s');
                      setState(() {
                        _noticeStr = "请重复解锁图案";
                      });
                    } else {
                      repeatStr = s;
                      if(firstStr==repeatStr){
                        _setGesPwd();
                      }
                      firstStr = null;
                      print('repeat$s');
                      setState(() {
                        _countdownTime = 1;
                        _noticeStr = "两次绘制的解锁图案不同";
                        _color = Colors.red;
                      });
                      startCountdownTimer();
                    }
                    scaffoldState.currentState?.showSnackBar(
                        SnackBar(content: Text('successCallback:$s')));
                    miniGesturePassword.currentState?.setSelected('');
                  },
                  failCallback: () {
                    print('failCallback');
                    if (_countdownTime == 0) {
                      setState(() {
                        _countdownTime = 1;
                        _noticeStr = "绘制失败，请重新绘制解锁图案";
                        _color = Colors.red;
                      });
                      startCountdownTimer();
                    }
                    scaffoldState.currentState
                        ?.showSnackBar(SnackBar(content: Text('failCallback')));
                    miniGesturePassword.currentState?.setSelected('');
                  },
                  selectedCallback: (str) {
                    miniGesturePassword.currentState?.setSelected(str);
                  },
                  attribute: ItemAttribute(
                      lineStrokeWidth: 2.0,
                      circleStrokeWidth: 2.0,
                      smallCircleR: 10.0,
                      bigCircleR: 30.0,
                      focusDistance: 25.0,
                      normalColor: const Color(0xFFBBDEFB),
                      selectedColor: const Color(0xFF1565C0)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  _setGesPwd()async{
    String url = "http://192.168.101.20:8080/api_visitor/user/setGesturePwd";
    var res = await Http().post(url, queryParameters: {
      "userId": 27,
      "token": "24d16d8a-f9d6-4249-8704-fa6a3fb76ac6",
      "threshold": "71B7735F3E9EC0814B1DC612A1A4A7F0",
      "factor": "20170831143600",
      "gesturePwd":Md5Util().encryptByMD5ByHex(firstStr),
    });
    if (res != null) {
      Map map = jsonDecode(res);
      if(map['verify']['sign']=='success'){
        Navigator.pop(context);
        ToastUtil.showShortClearToast(map['verify']['desc']);
      }else{
        Navigator.pop(context);
        ToastUtil.showShortClearToast(map['verify']['desc']);
      }
    }
  }
}
