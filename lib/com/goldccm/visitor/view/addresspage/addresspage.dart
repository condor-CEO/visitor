import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/addfriend.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/frienddetail.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/newfriend.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/search.dart';

class AddressPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddressPageState();
  }
}

var _keys = null;

class AddressPageState extends State<AddressPage> {
  Presenter presenter = new Presenter();
  List<User> userLists;
  @override
  void initState() {
    super.initState();
    presenter.loadUserList();
    userLists = presenter.getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('通讯录'),
          actions: <Widget>[
            PopupMenuButton<Choice>(
              onSelected: (value) {
                if (value.value == 1) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddFriendPage()));
                }
                if (value.value == 2) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewFriendPage()));
                }
              },
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                      value: choice,
                      child: Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                              child: Icon(choice.icon)),
                          Text(choice.title),
                        ],
                      ));
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
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => FriendSearch()));
                              },
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
            Container(
              color: Colors.white,
              child: ListTile(
                title: Text('新的朋友'),
                leading: Icon(Icons.person_add)
              ),
            ),
            Divider(height: 5,color: Colors.white12,),
            Expanded(child: _buildInfo()),
          ],
        ));
  }

  Widget _buildInfo() {
    return ListView.separated(
        itemCount: userLists.length != null ? userLists.length : 0,
        separatorBuilder: (context,index){
          return Container(
            child: Divider(
              height: 0,
            ),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.white,
            child: ListTile(
              title: Text(userLists[index].userName),
              leading: Icon(Icons.person),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>FriendDetailPage()));
              },
            ),
          );
        });
  }
}

class User {
  String userName;
  String phone;
  String idHandleImgUrl;
  User({this.userName, this.phone, this.idHandleImgUrl});
}

class Choice {
  Choice({this.title, this.icon, this.value});
  String title;
  IconData icon;
  int value;
}

class Presenter {
  List<User> userlists;
  getUserList() {
    return userlists;
  }

  loadUserList() {
    userlists = new List<User>();
    userlists.add(
        new User(userName: 'a', phone: '15880485249', idHandleImgUrl: '11'));
    userlists.add(
        new User(userName: 'b', phone: '15880485249', idHandleImgUrl: '11'));
    userlists.add(
        new User(userName: 'c', phone: '15880485249', idHandleImgUrl: '11'));
    userlists.add(
        new User(userName: 'd', phone: '15880485249', idHandleImgUrl: '11'));
  }
}

List<Choice> choices = <Choice>[
  Choice(title: '添加好友', icon: Icons.person_add, value: 1),
  Choice(title: '新的朋友', icon: Icons.portrait, value: 2),
];
