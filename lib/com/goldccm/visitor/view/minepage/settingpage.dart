import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return SettingPageState();
  }
}
class SettingPageState extends State<SettingPage>{
  @override
  Widget build(BuildContext context) {
    return  new Scaffold(
        appBar: new AppBar(
          title: const Text('设置'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          automaticallyImplyLeading: false,
        ),
        body: new Column(
          children: <Widget>[
            new Container(
              child:  new Column(
                children: <Widget>[
                  Center(
                    child: new Image.asset('asset/images/visitor_logo.png',scale: 0.7),
                  ),
                  new Container(
                    padding: EdgeInsets.all(10.0),
                    child:  Center(
                      child: new Text('版本号 1.1.3'),
                    ),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(0,50.0,0,0),
            ),
            new Container(
              padding: EdgeInsets.all(10.0),
              child: new SizedBox(
                width: 300.0,
                height: 50.0,
                child: new RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: new Text('安全退出'),
                  onPressed: () async{
                    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                ),
              ),
            )
          ],
        ),
      );
  }
}