import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/CommonUtil.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class NewFriendPage extends StatefulWidget {
  final UserInfo userInfo;

  NewFriendPage({Key key, this.userInfo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NewFriendPageState();
  }
}

class NewFriendPageState extends State<NewFriendPage> {
  Presenter presenter = new Presenter();
  List<Person> _request = new List();
  List<Person> _friends = new List();
  UserInfo _userInfo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('新的朋友'),
          centerTitle: true,
        ),
        body: RefreshIndicator(
            child: CustomScrollView(
              slivers: <Widget>[
                _friendRequest(),
                _findNew(),
              ],
            ),
            onRefresh: init));
  }

  Future init() async {
      await presenter.loadRequest();
      await presenter.loadConcacts();
      await presenter.loadFriend();
      setState(() {
        _request = presenter.getRequest();
        _friends = presenter.getFriend();
      });
    return null;
  }

  @override
  void initState() {
    super.initState();
    _userInfo = widget.userInfo;
    init();
  }

  Widget _findNew() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  presenter.getImageUrl() + _friends[index].imageUrl),
            ),
            title: Text('来自通讯录的好友'),
            subtitle: Text('${_friends[index].name}'),
            trailing: Container(
              child: SizedBox(
                width: 70,
                height: 40,
                child: _friends[index].applyType==null?RaisedButton(
                    textColor: Colors.white,
                    color: Colors.green,
                    child: Text('添加'),
                    onPressed: () async {
                      presenter.addFriend(_friends[index].name, _friends[index].phone);
                    }):Align(child:Text('已添加'),alignment: Alignment.centerRight,)
              ),
            ));
      }, childCount: _friends.length != null ? _friends.length : 0),
    );
  }

  Widget _friendRequest() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Column(children: <Widget>[
          ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    presenter.getImageUrl() + _request[index].imageUrl),
              ),
              title: Text(_request[index].name),
              subtitle: Text('留言'),
              trailing: Container(
                child: SizedBox(
                  width: 70,
                  height: 40,
                  child: _request[index].applyType==0?RaisedButton(
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text('同意'),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => remarkFriendPage(
                                      userId: _request[index].userId,
                                    ))).then((val) => {init()});
                      }):Align(child:Text('已添加'),alignment: Alignment.centerRight,)
                ),
              )),
          Divider(height: 0),
        ]);
      }, childCount: _request.length != null ? _request.length : 0),
    );
  }
}

class Person {
  String name;
  String nickname;
  String phone;
  String imageUrl;
  int applyType;
  int userId;

  Person(
      {this.name,
      this.nickname,
      this.phone,
      this.imageUrl,
      this.applyType,
      this.userId});
}

class Presenter {
  List<Person> _request = new List<Person>();
  List<Person> _friends = new List<Person>();
  String _phoneStr = "";
  String _imageUrl;

  Future<bool> agreeRequest(int friendId, String remark) async {
    String url =
        "http://192.168.10.154:8080/api_visitor/userFriend/agreeFriend";
    String threshold = await CommonUtil.calWorkKey();
    var res = await Http().post(url, queryParameters: {
      "token": "24d16d8a-f9d6-4249-8704-fa6a3fb76ac6",
      "factor": "20170831143600",
      "threshold": "71B7735F3E9EC0814B1DC612A1A4A7F0",
      "requestVer": CommonUtil.getAppVersion(),
      "userId": "27",
      "friendId": friendId,
      "type": "1",
      "remark": remark,
    });
    if (res is String) {
      Map map = jsonDecode(res);
      ToastUtil.showShortClearToast(map['verify']['desc']);
      if (map['verify']['sign'] == "success") {
        return true;
      }
      ToastUtil.showShortClearToast(map['verify']['desc']);
    }
    return false;
  }
  addFriend(String name,String phone) async {
    String url = "http://192.168.10.154:8080/api_visitor/userFriend/addFriendByPhoneAndUser";
    String threshold = await CommonUtil.calWorkKey();
    var res = await Http().post(url, queryParameters: {
      "token": "24d16d8a-f9d6-4249-8704-fa6a3fb76ac6",
      "factor":"20170831143600",
      "threshold": "71B7735F3E9EC0814B1DC612A1A4A7F0",
      "requestVer": CommonUtil.getAppVersion(),
      "userId":"27",
      "phone":phone,
      "realName":name,
    });
    if(res is String){
      Map map = jsonDecode(res);
      ToastUtil.showShortClearToast(map['verify']['desc']);
    }
  }
  loadConcacts() async {
    _phoneStr="";
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission.value != 2) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
    } else {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      for (Contact contact in contacts) {
        for (var phone in contact.phones) {
          if (phone != null && phone.value != null) {
            String str = "";
            var cuts = phone.value.split(" ");
            for (var cut in cuts) {
              str = str + cut;
            }
            _phoneStr += str + ",";
          }
        }
      }
    }
  }

  getFriend() {
    return _friends;
  }

  getImageUrl() {
    return _imageUrl;
  }

  getRequest() {
    return _request;
  }

  Future loadFriend() async {
    _friends.clear();
    String url = "http://192.168.10.154:8080/api_visitor/userFriend/findIsUserByPhone";
    String threshold = await CommonUtil.calWorkKey();
    _imageUrl = await DataUtils.getPararInfo("imageServerUrl");
    if(_phoneStr!="") {
      var res = await Http().post(url, queryParameters: {
        "token": "24d16d8a-f9d6-4249-8704-fa6a3fb76ac6",
        "factor": "20170831143600",
        "threshold": "71B7735F3E9EC0814B1DC612A1A4A7F0",
        "requestVer": CommonUtil.getAppVersion(),
        "userId": "27",
        "phoneStr": _phoneStr,
      });
      if (res is String) {
        Map map = jsonDecode(res);
        if (map['verify']['sign'] == "success") {
          List userList = map['data'];
          if (userList == null) {
            return;
          }
          for (var userInfo in userList) {
            Person user = Person(
                name: userInfo['realName'],
                phone: userInfo['phone'],
                imageUrl: userInfo['idHandleImgUrl'],
                userId: userInfo['id'],
                nickname: userInfo['nickName']);
            _friends.add(user);
          }
        }
      }
    }
  }

  Future loadRequest() async {
    _request.clear();
    String url =
        "http://192.168.10.154:8080/api_visitor/userFriend/beAgreeingFriendList";
    String threshold = await CommonUtil.calWorkKey();
    _imageUrl = await DataUtils.getPararInfo("imageServerUrl");
    var res = await Http().post(url, queryParameters: {
      "token": "24d16d8a-f9d6-4249-8704-fa6a3fb76ac6",
      "factor": "20170831143600",
      "threshold": "71B7735F3E9EC0814B1DC612A1A4A7F0",
      "requestVer": CommonUtil.getAppVersion(),
      "userId": "27",
    });
    if (res is String) {
      Map map = jsonDecode(res);
      if (map['verify']['sign'] == "success") {
        List userList = map['data'];
        if (userList == null) {
          return;
        }
        for (var userInfo in userList) {
          Person user = Person(
              name: userInfo['realName'],
              phone: userInfo['phone'],
              imageUrl: userInfo['idHandleImgUrl'],
              userId: userInfo['id'],
              nickname: userInfo['nickName'],
              applyType: userInfo['applyType']
          );
          _request.add(user);
        }
      }
    }
  }
}

class remarkFriendPage extends StatelessWidget {
  final int userId;
  remarkFriendPage({Key key, this.userId}) : super(key: key);
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Presenter _presenter = new Presenter();
  String remark = "";
  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Scaffold(
            appBar: AppBar(
              title: Text('朋友备注'),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: new RaisedButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    child: new Text(
                      '完成',
                      style: TextStyle(fontSize: Constant.fontSize),
                    ),
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        _presenter.agreeRequest(userId, remark);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
                child: Container(
              height: 120,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Align(
                    child: Container(
                      child: Text(
                        '为朋友添加备注',
                      ),
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    alignment: Alignment(-0.85, 0),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: '请输入备注',
                        enabledBorder: new UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black12, width: 1.0),
                        ),
                        hintStyle: TextStyle(fontSize: Constant.fontSize),
                      ),
                      onSaved: (value) {
                        remark = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return '输入不能为空';
                        }
                      },
                    ),
                  ),
                ],
              ),
            ))));
  }
}
