

import 'package:flutter/material.dart';

class SecurityPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return SecurityPageState();
  }
}
class SecurityPageState extends State<SecurityPage>{

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
            trailing: Image.asset('asset/images/visitor_icon_next.png',scale: 2.0),
          ),
          Divider(height: 0.0),
          ListTile(
            title: Text('修改登录密码'),
            trailing: Image.asset('asset/images/visitor_icon_next.png',scale: 2.0),
          ),
          Divider(height: 0.0),
          ListTile(
            title: Text('设置手势密码'),
            trailing: Image.asset('asset/images/visitor_icon_next.png',scale: 2.0),
          ),
        ],
      ),
    );
  }

}