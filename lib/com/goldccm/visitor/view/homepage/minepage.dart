import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/view/itempage/settingpage.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }
}

class MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text('我'),
          elevation: 0,
        ),
        body: new Column(
          children: <Widget>[
            new Container(
              decoration: BoxDecoration(color: Colors.blue, boxShadow: [
                BoxShadow(
                  offset: Offset(0.0, 5.0),
                  color: Colors.black12,
                  blurRadius: 20.0,
                )
              ]),
              height: 100,
              child: new Row(
                children: <Widget>[
                  new Container(
                    child: new CircleAvatar(
                      backgroundImage: new NetworkImage(
                          'https://p.ssl.qhimg.com/dmfd/400_300_/t0120b2f23b554b8402.jpg'),
                      radius: 100,
                    ),
                    width: 60.0,
                    margin: const EdgeInsets.all(20),
                  ),
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        '黄文坤',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                      new Text(
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
              child: new ListView(children: <Widget>[
                new ListTile(
                  title:new Text( '实名认证'),
                  leading: new Image.asset('asset/images/visitor_icon_verify.png',scale: 1.5),
                  trailing: new Image.asset('asset/images/visitor_icon_next.png',scale: 2.0),
                  onTap: (){
                    print('a');
                  },
                ),
                new Divider(height: 0.0),
                new ListTile(
                  title:new Text( '身份识别码'),
                  leading: new Image.asset('asset/images/visitor_icon_qrcode.png',scale: 1.5),
                  trailing: new Image.asset('asset/images/visitor_icon_next.png',scale: 2.0),
                  onTap: (){
                    print('a');
                  },
                ),
                new Divider(height: 0.0),
                new ListTile(
                  title:new Text( '公司管理'),
                  leading: new Image.asset('asset/images/visitor_icon_staff.png',scale: 1.5),
                  trailing: new Image.asset('asset/images/visitor_icon_next.png',scale: 2.0),
                  onTap: (){
                    print('a');
                  },
                ),
                new Divider(height: 0.0),
                new ListTile(
                  title:new Text( '安全管理'),
                  leading: new Image.asset('asset/images/visitor_icon_security.png',scale: 1.5),
                  trailing: new Image.asset('asset/images/visitor_icon_next.png',scale: 2.0),
                  onTap: (){
                    print('a');
                  },
                ),
                new Divider(height: 0.0),
                new ListTile(
                  title:new Text( '设置'),
                  leading: new Image.asset('asset/images/visitor_icon_setting.png',scale: 1.5),
                  trailing: new Image.asset('asset/images/visitor_icon_next.png',scale: 2.0),
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(builder:(context) =>new SettingPage()));
                  },
                ),
              ]),
            ),
          ],
        ));
  }
}
