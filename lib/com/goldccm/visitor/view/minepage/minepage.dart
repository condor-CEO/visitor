import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/securitypage.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/settingpage.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }
}

class MinePageState extends State<MinePage> {
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
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://p.ssl.qhimg.com/dmfd/400_300_/t0120b2f23b554b8402.jpg'),
                      radius: 100,
                    ),
                    width: 60.0,
                    margin: EdgeInsets.all(20),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '黄文坤',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                      Text(
                        '福建小松安信',
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
                ListTile(
                  title:Text( '实名认证'),
                  leading: Image.asset('asset/images/visitor_icon_verify.png',scale: 1.5),
                  trailing: Image.asset('asset/images/visitor_icon_next.png',scale: 2.0),
                  onTap: (){
                    print('a');
                  },
                ),
                Divider(height: 0.0),
                ListTile(
                  title: Text( '身份识别码'),
                  leading: Image.asset('asset/images/visitor_icon_qrcode.png',scale: 1.5),
                  trailing: Image.asset('asset/images/visitor_icon_next.png',scale: 2.0),
                  onTap: (){
                    print('a');
                  },
                ),
                Divider(height: 0.0),
                ListTile(
                  title: Text( '公司管理'),
                  leading: Image.asset('asset/images/visitor_icon_staff.png',scale: 1.5),
                  trailing: Image.asset('asset/images/visitor_icon_next.png',scale: 2.0),
                  onTap: (){
                    print('a');
                  },
                ),
                Divider(height: 0.0),
                ListTile(
                  title: Text( '安全管理'),
                  leading: Image.asset('asset/images/visitor_icon_security.png',scale: 1.5),
                  trailing: Image.asset('asset/images/visitor_icon_next.png',scale: 2.0),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context) => SecurityPage()));
                  },
                ),
                Divider(height: 0.0),
                ListTile(
                  title: Text( '设置'),
                  leading: Image.asset('asset/images/visitor_icon_setting.png',scale: 1.5),
                  trailing: Image.asset('asset/images/visitor_icon_next.png',scale: 2.0),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context) => SettingPage()));
                  },
                ),
              ]),
            ),
          ],
        ));
  }
}
getUserInfo() async{
  String url = Constant.getUserInfoUrl;
  var data = await Http().get(url,queryParameters:{"userId":"","token":""});
  if(data!=null){

  }
}
