import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/companypage.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/identifycodepage.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/identifypage.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/securitypage.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/settingpage.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }
}

UserInfo _userInfo = new UserInfo();

class MinePageState extends State<MinePage> {
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text('我'),
          elevation: 0,
        ),
        body: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.blue, boxShadow: [
                BoxShadow(
                  offset: Offset(0.0, 5.0),
                  color: Colors.black12,
                  blurRadius: 20.0,
                )
              ]),
              height: 100,
              child: Row(
                children: <Widget>[
                  Container(
                    child:
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HeadImagePage()));
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://p.ssl.qhimg.com/dmfd/400_300_/t0120b2f23b554b8402.jpg'),
                        radius: 100,
                      ),
                    ),
                    width: 60.0,
                    margin: EdgeInsets.all(20),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _userInfo.realName != null
                            ? _userInfo.realName
                            : '暂未获取到数据',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                      Text(
                        _userInfo.addr != null ? _userInfo.addr : '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(children: <Widget>[
                getAuth(),
                Divider(height: 0.0),
                ListTile(
                  title: Text('身份识别码',style:TextStyle(fontSize: Constant.fontSize)),
                  leading: Image.asset('asset/images/visitor_icon_qrcode.png',
                      scale: 1.5),
                  trailing: Image.asset('asset/images/visitor_icon_next.png',
                      scale: 2.0),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IdentifyCodePage()));
                  },
                ),
                Divider(height: 0.0),
                ListTile(
                  title: Text('公司管理',style:TextStyle(fontSize: Constant.fontSize)),
                  leading: Image.asset('asset/images/visitor_icon_staff.png',
                      scale: 1.5),
                  trailing: Image.asset('asset/images/visitor_icon_next.png',
                      scale: 2.0),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CompanyPage()));
                  },
                ),
                Divider(height: 0.0),
                ListTile(
                  title: Text('安全管理',style:TextStyle(fontSize: Constant.fontSize)),
                  leading: Image.asset('asset/images/visitor_icon_security.png',
                      scale: 1.5),
                  trailing: Image.asset('asset/images/visitor_icon_next.png',
                      scale: 2.0),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SecurityPage(userInfo: _userInfo)));
                  },
                ),
                Divider(height: 0.0),
                ListTile(
                  title: Text('设置',style:TextStyle(fontSize: Constant.fontSize)),
                  leading: Image.asset('asset/images/visitor_icon_setting.png',
                      scale: 1.5),
                  trailing: Image.asset('asset/images/visitor_icon_next.png',
                      scale: 2.0),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SettingPage()));
                  },
                ),
              ]),
            ),
          ],
        ));
  }

  getUserInfo() async {
    String url = "http://192.168.101.20:8080/api_visitor/user/getUser";
    var res = await Http().post(url, queryParameters: {
      "userId": 27,
      "token": "24d16d8a-f9d6-4249-8704-fa6a3fb76ac6",
      "threshold": "71B7735F3E9EC0814B1DC612A1A4A7F0",
      "factor": "20170831143600"
    });
    if (res != null) {
      Map map = jsonDecode(res);
      setState(() {
        _userInfo = UserInfo.fromJson(map['data']);
        auth = getAuth();
      });
    }
  }

  Widget auth;
  Widget getAuth() {
    if (_userInfo.isAuth == 'F') {
      return ListTile(
        title: Text('实名认证',style:TextStyle(fontSize: Constant.fontSize)),
        leading:
            Image.asset('asset/images/visitor_icon_verify.png', scale: 1.5),
        trailing: Image.asset('asset/images/visitor_icon_next.png', scale: 2.0),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => IdentifyPage()));
        },
      );
    } else {
      return ListTile(
        title: Text('实名认证',style:TextStyle(fontSize: Constant.fontSize)),
        leading: Image.asset('asset/images/visitor_icon_verify.png',
            scale: 1.5),
        trailing: Text('已实名',style: TextStyle(color: Colors.grey),),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => IdentifyPage()));
        },
      );
    }
  }
}
class HeadImagePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HeadImagePageState();
  }
}
class HeadImagePageState extends State<HeadImagePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('修改头像'),
      ),
    );
  }

}
