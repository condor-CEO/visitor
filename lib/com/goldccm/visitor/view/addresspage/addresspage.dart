import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/UserModel.dart';
import 'package:visitor/com/goldccm/visitor/util/CommonUtil.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/addfriend.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/frienddetail.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/newfriend.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/search.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AddressPage extends StatefulWidget {
  final WebSocketChannel channel;
  AddressPage({Key key,this.channel}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return AddressPageState();
  }
}
class AddressPageState extends State<AddressPage> {
  Presenter _presenter = new Presenter();
  List<User> _userLists=new List<User>();
  UserModel _userModel;
  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }
  @override
  Widget build(BuildContext context) {
    _userModel=Provider.of<UserModel>(context);
    return Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Consumer(builder: (context,UserModel userModel,widget)=>Text('通讯录')),
          backgroundColor: Colors.lightBlue,
          actions: <Widget>[
            PopupMenuButton<Choice>(
              onSelected: (value) {
                if (value.value == 1) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddFriendPage(userInfo: _userModel.info,)));
                }
                if (value.value == 2) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewFriendPage(userInfo: _userModel.info,)));
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
        body: RefreshIndicator(child:  Column(
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
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => FriendSearch(userList: _userLists,)));
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
              color: Color.fromRGBO(255, 193, 37,1),
              child: ListTile(
                title: Text('新的朋友'),
                leading: Icon(Icons.person_add),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>NewFriendPage(userInfo: _userModel.info,)));
                },
              ),
            ),
            Divider(height: 5,color: Colors.white12,),
            Expanded(child: _buildInfo()),
          ],
        ), onRefresh: _handleRefresh)
       );
  }
  Future _handleRefresh() async{
    Future.delayed(Duration(seconds: 2),()async{
      await _presenter.loadUserList(_userModel);
      setState(() {
        _userLists = _presenter.getUserList();
      });
      return null;
    });
  }
  Widget _buildInfo() {
    return ListView.separated(
        itemCount: _userLists.length != null ? _userLists.length : 0,
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
              title: Text(_userLists[index].userName),
              leading: _userLists[index].idHandleImgUrl!=null?CircleAvatar(backgroundImage:NetworkImage(_presenter.getImageUrl()+_userLists[index].idHandleImgUrl),):CircleAvatar(backgroundImage: AssetImage("asset/images/visitor_icon_head.png"),),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>FriendDetailPage(user: _userLists[index],channel: widget.channel,)));
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
  String notice;
  String companyName;
  int userId;
  String imageServerUrl;
  User({this.userName, this.phone, this.idHandleImgUrl,this.notice,this.companyName,this.userId,this.imageServerUrl,});
}

class Choice {
  Choice({this.title, this.icon, this.value});
  String title;
  IconData icon;
  int value;
}

class Presenter {
  List<User> _userlists = new List<User>();
  String _imageUrl="";
  getUserList() {
    return _userlists;
  }
  getImageUrl(){
    return _imageUrl;
  }

  loadUserList(UserModel userModel) async {
    _userlists.clear();
    UserInfo _userInfo=await DataUtils.getUserInfo();
    if(_userInfo==null){
      _userInfo=userModel.info;
    }
    _imageUrl = await DataUtils.getPararInfo("imageServerUrl");
//    String url = Constant.serverUrl+ Constant.fiFndUserFriendUrl;
    String threshold = await CommonUtil.calWorkKey();
    String url = "http://192.168.10.154:8080/api_visitor/userFriend/findUserFriend";
    var res = await Http().post(url, queryParameters: {
//      "token":  _userInfo.token,
//      "userId": _userInfo.id,
//      "factor": CommonUtil.getCurrentTime(),
//      "threshold": threshold,
      "token": "24d16d8a-f9d6-4249-8704-fa6a3fb76ac6",
      "factor":"20170831143600",
      "threshold": "71B7735F3E9EC0814B1DC612A1A4A7F0",
      "requestVer": CommonUtil.getAppVersion(),
      "userId":"27",
    });
    if(res is String) {
      Map map = jsonDecode(res);
      if (map['verify']['sign'] == "success") {
        List userList = map['data'];
        for (var userInfo in userList) {
          User user = User(userName: userInfo['realName'],
              phone: userInfo['phone'],
              idHandleImgUrl: userInfo['idHandleImgUrl'],
              companyName: userInfo['companyName'],
              userId: userInfo['id'],
              notice: userInfo['remark'],
              imageServerUrl: _imageUrl);
          _userlists.add(user);
        }
      }
    }
  }
}

List<Choice> choices = <Choice>[
  Choice(title: '添加好友', icon: Icons.person_add, value: 1),
  Choice(title: '新的朋友', icon: Icons.portrait, value: 2),
];
