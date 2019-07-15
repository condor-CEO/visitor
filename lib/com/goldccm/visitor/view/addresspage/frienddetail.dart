import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/chat.dart';

class FriendDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FriendDetailPageState();
  }
}

class FriendDetailPageState extends State<FriendDetailPage> {
  UserDetail _userDetail;
  Presenter _presenter = new Presenter();
  String _imageServerUrl;
  @override
  void initState() {
    super.initState();
    _presenter.loadDetail();
    _userDetail = _presenter.getDetail();
    _imageServerUrl = _presenter.getImgServerUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('好友信息'),
        centerTitle: true,
      ),
      body: _drawDetail(),
    );
  }

  Widget _drawDetail() {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          height: 200,
          child: Row(
            children: <Widget>[
              Container(
                height: 60,
                child: CircleAvatar(
                  backgroundImage: _imageServerUrl != null
                      ? NetworkImage(
                          _imageServerUrl + _userDetail.headImgUrl,
                        )
                      : AssetImage('asset/images/visitor_icon_account.png'),
                  radius: 100,
                ),
                width: 60.0,
                margin: EdgeInsets.all(20),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _userDetail.name != null ? _userDetail.name : '昵称',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "手机号码："+(_userDetail.phone != null ? _userDetail.phone : '手机号码'),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    "备注："+(_userDetail.notice != null ? _userDetail.notice : '备注'),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    "所属公司："+(_userDetail.company != null ? _userDetail.company : '所属公司') ,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                    ),
                  ),
                ],
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
                '洽谈',
                style: TextStyle(fontSize: Constant.fontSize),
              ),
              onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage()));
              },
            ),
          ),
        ),
      ],
    );
  }
}

class UserDetail {
  String name;
  String phone;
  String notice;
  String company;
  String headImgUrl;
  UserDetail({name, phone, notice, company, headImgUrl});
}

class Presenter {
  UserDetail userDetail = new UserDetail();
  loadDetail() {
    userDetail.phone = "15880485249";
    userDetail.notice = "this is a message";
    userDetail.name = "乘风";
    userDetail.company = "福建小松安信";
  }

  getDetail() {
    return userDetail;
  }

  getImgServerUrl() {
    return null;
  }
}
