import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/UserModel.dart';
import 'package:visitor/com/goldccm/visitor/util/CommonUtil.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';
import 'package:visitor/com/goldccm/visitor/util/MessageUtils.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/addfriend.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/frienddetail.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/newfriend.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/search.dart';
import 'package:visitor/com/goldccm/visitor/view/login/Login.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:lpinyin/lpinyin.dart';

///通讯录模块
///提供一个用户好友列表
///用于查看用户详情和开启聊天
class AddressPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddressPageState();
  }
}

///_userList是存放好友信息的列表
///_userModel是Provider管理的变量类
class AddressPageState extends State<AddressPage> {
  Presenter _presenter = new Presenter();
  List<User> _userLists = new List<User>();
  UserModel _userModel;
  UserInfo _userInfo =new UserInfo();
  bool initFlag = false;
  var alphabet = [
    '☀',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    '#'
  ];
  @override
  void initState() {
    super.initState();
    _initRefresh();
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Consumer(
            builder: (context, UserModel userModel, widget) => Text(
                  '通讯录',
                  style: new TextStyle(fontSize: 18.0, color: Colors.white),
                ),
          ),
          backgroundColor: Theme.of(context).appBarTheme.color,
          actions: <Widget>[
            IconButton(
                icon: Image.asset(
                  "asset/icons/添加新好友@2x.png",
                  scale: 2.0,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Material(
                            //创建透明层
                            type: MaterialType.transparency, //透明类型
                            child: Container(
                              //保证控件居中效果
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(top: 60, right: 10.0),
                              child: new SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 3.5,
                                width: 160,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: ShapeDecoration(
                                        color: Color(0xffffffff),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                      child: new Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0, bottom: 0),
                                            child: FlatButton(
                                              onPressed: () async {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddFriendPage(
                                                              userInfo:
                                                                  _userModel
                                                                      .info,
                                                            )));
                                              },
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      30,
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Positioned(
                                                        child: Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              15,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            '添加好友',
                                                            style: TextStyle(
                                                              fontSize: 18.0,
                                                            ),
                                                          ),
                                                        ),
                                                        left: 30,
                                                      ),
                                                      Positioned(
                                                        child: Container(
                                                          width: 20,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              15,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5),
                                                          child: Image.asset(
                                                            'asset/icons/添加@2x.png',
                                                            scale: 2.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                          Divider(
                                            height: 0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0, bottom: 0),
                                            child: FlatButton(
                                              onPressed: () async {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            NewFriendPage(
                                                              userInfo:
                                                                  _userModel
                                                                      .info,
                                                            ))).then((value) {
                                                  Navigator.pop(context);
                                                  _handleRefresh();
                                                  print(initFlag);
                                                });
                                              },
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      30,
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Positioned(
                                                        child: Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              15,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            '新的朋友',
                                                            style: TextStyle(
                                                              fontSize: 18.0,
                                                            ),
                                                          ),
                                                        ),
                                                        left: 30,
                                                      ),
                                                      Positioned(
                                                        child: Container(
                                                          width: 20,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              15,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5),
                                                          child: Image.asset(
                                                            'asset/icons/新的好友@2x.png',
                                                            scale: 2.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }),
          ],
        ),
        body: RefreshIndicator(
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    initFlag == true
                        ? Expanded(child: _buildInfoWithoutData())
                        : Expanded(child: _buildInfo()),
                  ],
                ),
                Positioned(
                  top: 120,
                  right: 0,
                  bottom: 10,
                  width: 40,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return new Container(
                        margin:
                            EdgeInsets.only(left: 20.0, right: 10.0, top: 3.5),
                        height: 8.0,
                        child: new Text(
                          '${alphabet[index]}',
                          style: TextStyle(
                            fontSize: 8.0,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                    itemCount: alphabet.length,
                  ),
                ),
              ],
            ),
            onRefresh: _handleRefresh
        )
    );
  }

  Future _handleRefresh() async {
      await _presenter.loadUserList(_userInfo,_userModel);
      setState(() {
        _userLists = _presenter.getUserList();
        initFlag = _presenter.getFlag();
      });
      return null;
  }
  Future _initRefresh() async {
    Future.delayed(Duration(seconds: 2), () async {
      await _presenter.loadUserList(_userInfo,_userModel);
      setState(() {
        _userLists = _presenter.getUserList();
        initFlag = _presenter.getFlag();
      });
      return null;
    });
  }
  ///获取用户信息
  getUserInfo() async {
    UserInfo userInfo = await DataUtils.getUserInfo();
    if (userInfo != null) {
      setState(() {
        _userInfo = userInfo;
      });
    } else {
      reloadUserInfo(userInfo);
    }
  }

  //重载用户信息
  //为了防止第一次登录时用户信息获取延迟
  //设定一个递归函数直到获取到用户的信息
  reloadUserInfo(UserInfo userInfo) {
    Future.delayed(Duration(seconds: 1), () async {
      UserInfo userInfo = await DataUtils.getUserInfo();
      if (userInfo != null) {
        setState(() {
          _userInfo = userInfo;
        });
        if (_userInfo.id == null) {
          reloadUserInfo(userInfo);
        }
      } else {
        reloadUserInfo(userInfo);
      }
    });
  }
  Widget _buildInfoWithoutData() {
    return Column(
      children: <Widget>[
        Container(
          child: Container(
              height: 58.0,
              child: new Card(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  color: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
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
                              textAlign: TextAlign.center,
                              cursorWidth: 0.0,
                              decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 0.0),
                                  hintText: '查找',
                                  border: InputBorder.none),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FriendSearch(
                                              userList: _userLists,
                                            )));
                              },
                            ),
                          ),
                        ),
                        new IconButton(
                          icon: new Icon(Icons.cancel),
                          color: Colors.grey,
                          iconSize: 18.0,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ))),
        ),
        Container(
          child: ListTile(
            title: Text('新的朋友'),
            leading: Container(
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
              child: Image.asset(
                "asset/icons/添加新好友@2x.png",
                color: Colors.white,
                scale: 1.7,
              ),
            ),
            trailing: Image.asset('asset/icons/更多@2x.png', scale: 1.7),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewFriendPage(
                            userInfo: _userModel.info,
                          )));
            },
          ),
        ),
        Divider(
          height: 0,
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return ListView.separated(
        itemCount: _userLists.length != null ? _userLists.length : 0,
        separatorBuilder: (context, index) {
          return Container(
            child: Divider(
              height: 0,
            ),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Column(
              children: <Widget>[
                Container(
                  child: Container(
                      height: 58.0,
                      child: new Card(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          color: Colors.white70,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
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
                                      textAlign: TextAlign.center,
                                      cursorWidth: 0.0,
                                      decoration: new InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(top: 0.0),
                                          hintText: '查找',
                                          border: InputBorder.none),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FriendSearch(
                                                      userList: _userLists,
                                                    )));
                                      },
                                    ),
                                  ),
                                ),
                                new IconButton(
                                  icon: new Icon(Icons.cancel),
                                  color: Colors.grey,
                                  iconSize: 18.0,
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ))),
                ),
                Container(
                  child: ListTile(
                    title: Text('新的朋友'),
                    leading: Container(
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange,
                      ),
                      child: Image.asset(
                        "asset/icons/添加新好友@2x.png",
                        color: Colors.white,
                        scale: 1.7,
                      ),
                    ),
                    trailing: Image.asset('asset/icons/更多@2x.png', scale: 1.7),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewFriendPage(
                                    userInfo: _userModel.info,
                                  ))).then((val) {
                        _handleRefresh();
                      });
                    },
                  ),
                ),
                Divider(
                  height: 0,
                ),
                Container(
                  color: Colors.white,
                  height: 40,
                  child: ListTile(
                    title: Text(_userLists[index].firstZiMu),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(_userLists[index].userName),
                    leading: _userLists[index].idHandleImgUrl != null &&
                            _userLists[index].idHandleImgUrl != ""
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                Constant.imageServerUrl +
                                    _userLists[index].idHandleImgUrl),
                          )
                        : CircleAvatar(
                            backgroundImage: AssetImage(
                                "asset/images/visitor_icon_head.png"),
                          ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FriendDetailPage(
                                    user: _userLists[index],
                                  )));
                    },
                  ),
                )
              ],
            );
          }
          if (index == 0 ||
              _userLists[index].firstZiMu != _userLists[index - 1].firstZiMu) {
            return Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: 40,
                  child: ListTile(
                    title: Text(_userLists[index].firstZiMu),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(_userLists[index].userName),
                    leading: _userLists[index].idHandleImgUrl != null &&
                            _userLists[index].idHandleImgUrl != ""
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                Constant.imageServerUrl +
                                    _userLists[index].idHandleImgUrl),
                          )
                        : CircleAvatar(
                            backgroundImage: AssetImage(
                                "asset/images/visitor_icon_head.png"),
                          ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FriendDetailPage(
                                    user: _userLists[index],
                                  )));
                    },
                  ),
                )
              ],
            );
          }
          return Container(
            color: Colors.white,
            child: ListTile(
              title: Text(_userLists[index].userName),
              leading: _userLists[index].idHandleImgUrl != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(Constant.imageServerUrl +
                          _userLists[index].idHandleImgUrl),
                    )
                  : CircleAvatar(
                      backgroundImage:
                          AssetImage("asset/images/visitor_icon_head.png"),
                    ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FriendDetailPage(
                              user: _userLists[index],
                            )));
              },
            ),
          );
        });
  }
}

/// 用户
class User {
  String userName;
  String phone;
  String idHandleImgUrl;
  String notice;
  String companyName;
  int userId;
  String imageServerUrl;
  String firstZiMu;
  String orgId;
  User(
      {this.userName,
      this.phone,
      this.idHandleImgUrl,
      this.notice,
      this.companyName,
      this.userId,
      this.orgId,
      this.imageServerUrl,
      this.firstZiMu});
}

class Choice {
  Choice({this.title, this.icon, this.value});
  String title;
  IconData icon;
  int value;
}

///自定义类
///用于存放变量和操作变量
class Presenter {
  List<User> _userlists = new List<User>();
  String _imageUrl = "";
  bool initFlag = false;
  getUserList() {
    return _userlists;
  }

  getImageUrl() {
    return _imageUrl;
  }

  getFlag() {
    return initFlag;
  }

  loadUserList(UserInfo _userInfo,UserModel userModel) async {
    _userlists.clear();
    UserInfo userInfo = await DataUtils.getUserInfo();
    if(userInfo.id==null){
      if(_userInfo.id !=null){
        userInfo = _userInfo;
      }
      else if (userModel.info.id!=null) {
        userInfo = userModel.info;
      }
    }
    _imageUrl = await DataUtils.getPararInfo("imageServerUrl");
    String threshold = await CommonUtil.calWorkKey();
    String url = Constant.serverUrl + Constant.findUserFriendUrl;
    var res = await Http().post(url, queryParameters: {
      "token": userInfo.token,
      "userId": userInfo.id,
      "factor": CommonUtil.getCurrentTime(),
      "threshold": threshold,
      "requestVer": CommonUtil.getAppVersion(),
    });
    if (res is String) {
      Map map = jsonDecode(res);
      if (map['verify']['sign'] == "success") {
        if (map['data'] != null) {
          initFlag = false;
          List userList = map['data'];
          for (var userInfo in userList) {
            User user = User(
              userName: userInfo['realName'],
              phone: userInfo['phone'],
              idHandleImgUrl: userInfo['idHandleImgUrl'],
              companyName: userInfo['companyName'],
              userId: userInfo['id'],
              notice: userInfo['remark'],
              orgId: userInfo['orgId'].toString(),
              imageServerUrl: _imageUrl,
              firstZiMu: PinyinHelper.getFirstWordPinyin(userInfo['realName'])
                  .substring(0, 1)
                  .toUpperCase(),
            );
            _userlists.add(user);
          }
          _userlists.sort((a, b) => PinyinHelper.getFirstWordPinyin(a.userName)
              .substring(0, 1)
              .compareTo(
                  PinyinHelper.getFirstWordPinyin(b.userName).substring(0, 1)));
        } else {
          initFlag = true;
        }
      }
    }else{
      if(res['verify']['sign']=="tokenFail"){
        ToastUtil.showShortClearToast("您的账号在另一台设备登录，请退出重新登录");
      }
    }
  }
}

List<Choice> choices = <Choice>[
  Choice(title: '添加好友', icon: Icons.person_add, value: 1),
  Choice(title: '新的朋友', icon: Icons.portrait, value: 2),
];
