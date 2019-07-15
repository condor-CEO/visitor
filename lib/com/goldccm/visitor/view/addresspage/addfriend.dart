
import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';

class AddFriendPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AddFriendPageState();
  }
}
class AddFriendPageState extends State<AddFriendPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加好友'),
        centerTitle:true,
      ),
      body: _addFriend(),
    );
  }
  Widget _addFriend(){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            color: Colors.white,
            height: 60,
            child: Row(
              children: <Widget>[
                Text(
                  '姓名',
                  style: TextStyle(fontSize: Constant.fontSize),
                ),
                Container(
                  width: 180,
                  padding: EdgeInsets.fromLTRB(60, 0.0, 0.0, 0.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: '请输入好友姓名',
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: Constant.fontSize),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            color: Colors.white,
            height: 60,
            child: Row(
              children: <Widget>[
                Text(
                  '手机号',
                  style: TextStyle(fontSize: Constant.fontSize),
                ),
                Container(
                  width: 180,
                  padding: EdgeInsets.fromLTRB(45, 0.0, 0.0, 0.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: '请输入他的手机号码',
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: Constant.fontSize),
                    ),
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
                child: new Text(
                  '添加好友',
                  style: TextStyle(fontSize: Constant.fontSize),
                ),
                onPressed: () async {

                },
              ),
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
                child: new Text(
                  '申请访问',
                  style: TextStyle(fontSize: Constant.fontSize),
                ),
                onPressed: () async {

                },
              ),
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
                child: new Text(
                  '邀约来访',
                  style: TextStyle(fontSize: Constant.fontSize),
                ),
                onPressed: () async {

                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
