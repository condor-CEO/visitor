import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/CommonUtil.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';

class AddFriendPage extends StatefulWidget{
  final UserInfo userInfo;
  AddFriendPage({Key key,this.userInfo}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return AddFriendPageState();
  }
}
class AddFriendPageState extends State<AddFriendPage>{
  UserInfo _userInfo;
  String _phone;
  String _name;
  var textController =  new TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _userInfo=widget.userInfo;
  }
  addFriend() async {
    String url = "http://192.168.10.154:8080/api_visitor/userFriend/addFriendByPhoneAndUser";
    String threshold = await CommonUtil.calWorkKey();
    var res = await Http().post(url, queryParameters: {
      "token": "24d16d8a-f9d6-4249-8704-fa6a3fb76ac6",
      "factor":"20170831143600",
      "threshold": "71B7735F3E9EC0814B1DC612A1A4A7F0",
      "requestVer": CommonUtil.getAppVersion(),
      "userId":"27",
      "phone":_phone,
      "realName":_name,
    });
    if(res is String){
      Map map = jsonDecode(res);
      ToastUtil.showShortClearToast(map['verify']['desc']);
    }
  }
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
    return SingleChildScrollView(
      child: Form(
        key: formKey,
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
                    onSaved: (value){
                      _name=value;
                    },
                    validator: (value){
                      if(value.isEmpty){
                        return '请不要为空';
                      }
                    },
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
                    onSaved: (value){
                      _phone=value;
                    },
                    validator: (value){
                      if(value.isEmpty){
                        return '请不要为空';
                      }
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
                child: new Text(
                  '添加好友',
                  style: TextStyle(fontSize: Constant.fontSize),
                ),
                onPressed: () async {
                  if(formKey.currentState.validate()){
                    formKey.currentState.save();
                    addFriend();
                  }
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
      )
    );
  }
}
