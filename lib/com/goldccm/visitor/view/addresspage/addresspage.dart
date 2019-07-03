import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/findbynamepage.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/findbyphonepage.dart';

class AddressPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddressPageState();
  }
}

var _keys = null;
var _maps = null;

  class AddressPageState extends State<AddressPage> {
  @override
  void initState() {
    super.initState();
    getAddressInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('通讯录'),
          actions: <Widget>[
            PopupMenuButton<Choice>(
              onSelected: (value) {
                if (value.value == 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FindByPhonePage()));
                }
                if (value.value == 2) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FindByNamePage()));
                }
              },
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              child: Container(
                  height: 52.0,
                  child: new Card(
                      child: new Container(
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 5.0,
                        ),
                        Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: TextField(
                              decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 0.0),
                                  hintText: '查找',
                                  border: InputBorder.none),
                              // onChanged: onSearchTextChanged,
                            ),
                          ),
                        ),
                        new IconButton(
                          icon: new Icon(Icons.cancel),
                          color: Colors.grey,
                          iconSize: 18.0,
                          onPressed: () {
                            // onSearchTextChanged('');
                          },
                        ),
                      ],
                    ),
                  ))),
            ),
            Expanded(child: _buildInfo()),
          ],
        ));
  }

  Widget _buildInfo() {
    if (_keys != null && _keys != "") {
      return ListView.builder(
          itemCount: _keys.length != null ? _keys.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: new Text(_keys[index]['realName'] != null
                  ? _keys[index]['realName']
                  : '暂无数据'),
            );
          });
    } else {
      return Column(
        children: <Widget>[
          Container(
            child: Center(
                child: Image.asset('asset/images/visitor_icon_nodata.png')),
            padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
          ),
          Center(child: Text('暂无数据，请重新获取'))
        ],
      );
    }
  }

  getAddressInfo() async {
    String url =
        "http://192.168.101.20:8080/api_visitor/userFriend/findUserFriend";
    var res = await Http().post(url, queryParameters: {
      "userId": 27,
      "token": "24d16d8a-f9d6-4249-8704-fa6a3fb76ac6",
      "threshold": "71B7735F3E9EC0814B1DC612A1A4A7F0",
      "factor": "20170831143600"
    });
    if (res != null) {
      Map map = jsonDecode(res);
      setState(() {
        _keys = map['data'];
      });
    }
  }
}

class User {
  String userName;
  String phone;
  String idHandleImgUrl;
}

class Choice {
  Choice({this.title, this.icon, this.value});
  String title;
  IconData icon;
  int value;
}

List<Choice> choices = <Choice>[
  Choice(title: '通过手机号查找', icon: Icons.directions_car, value: 1),
  Choice(title: '通过姓名查找', icon: Icons.directions_bike, value: 2),
];
