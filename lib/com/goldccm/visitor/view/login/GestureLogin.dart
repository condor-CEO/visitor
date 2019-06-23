import 'package:gesture_password/gesture_password.dart';
import 'package:flutter/material.dart';
import 'package:gesture_password/gesture_password.dart';

class GestureLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new GestureLoginState();
  }
}

class GestureLoginState extends State<GestureLogin> {
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
          new Padding(padding: EdgeInsets.only(top: 20.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset("asset/images/visitor_logo.png"),
            ],
          ),
          ),

          new Padding(padding: EdgeInsets.only(top: 10.0),
         child: new Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      new Text('13696831165')

    ],


    ),

    ),

          new Padding(padding: EdgeInsets.only(top: 10.0),
    child:  new Center(
        child: new Container(
//    color: Colors.red,
          margin: const EdgeInsets.only(top: 10.0),
          child: new GesturePassword(
            //width: 200.0,
            attribute: ItemAttribute.normalAttribute,
            successCallback: (s) {
              print("successCallback$s");
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
              scaffoldState.currentState?.showSnackBar(
                  new SnackBar(content: new Text(str)));
            },
          ),
        )),

    )





        ]));
  }
}
