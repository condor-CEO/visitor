import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visitor/com/goldccm/visitor/component/Qrcode.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/JsonResult.dart';
import 'package:visitor/com/goldccm/visitor/model/QrcodeMode.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/CommonUtil.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';
import 'package:visitor/com/goldccm/visitor/util/QrcodeHandler.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/companypage.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/identifycodepage.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/identifypage.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/securitypage.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/settingpage.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }
}

UserInfo _userInfo = new UserInfo();
String _imageServerUrl;
String _imageServerApiUrl;

class MinePageState extends State<MinePage> {
  String companyName = "";
  @override
  void initState() {
    super.initState();
    getUserInfo();
    getImageServerApiUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            '我',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                height: 120,
                child: Row(
                  children: <Widget>[
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HeadImagePage()));
                        },
                        child: CircleAvatar(
                          backgroundImage: _imageServerUrl != null
                              ? NetworkImage(
                                  _imageServerUrl +
                                      (_userInfo.headImgUrl != null
                                          ? _userInfo.headImgUrl
                                          : _userInfo.idHandleImgUrl),
                                )
                              : AssetImage(
                                  'asset/images/visitor_icon_account.png'),
                          radius: 100,
                        ),
                      ),
                      width: 60.0,
                      margin: EdgeInsets.all(20),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _userInfo != null
                              ? _userInfo.realName != null
                                  ? _userInfo.realName
                                  : '暂未获取到数据'
                              : '暂未获取到数据',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                        ),
                        Text(
                          companyName,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Container(
                    child: Divider(
                      height: 10,
                      color: Colors.white12,
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(
                        children: <Widget>[
                          Material(
                            color: Colors.white,
                            child: InkWell(
                              child:
                              Container(
                                width: 100,
                                padding: EdgeInsets.all(15),
                                child:Column(
                                  children: <Widget>[
                                    Icon(Icons.person),
                                    Text('3条'),
                                  ],
                                ),
                              ),
                              onTap: (){
                              },
                              splashColor: Colors.black12,
                              borderRadius: BorderRadius.circular(18.0),
                              radius: 30,
                            ),
                          ),
                          Material(
                            color: Colors.white,
                            child: InkWell(
                              child:
                              Container(
                                width: 100,
                                padding: EdgeInsets.all(15),
                                child:Column(
                                  children: <Widget>[
                                    Icon(Icons.person),
                                    Text('3条'),
                                  ],
                                ),
                              ),
                              onTap: (){
                              },
                              splashColor: Colors.black12,
                              borderRadius: BorderRadius.circular(18.0),
                              radius: 30,
                            ),
                          ),
                          Material(
                            color: Colors.white,
                            child: InkWell(
                              child:
                              Container(
                                width: 100,
                                padding: EdgeInsets.all(15),
                                child:Column(
                                  children: <Widget>[
                                    Icon(Icons.person),
                                    Text('3条'),
                                  ],
                                ),
                              ),
                              onTap: (){
                              },
                              splashColor: Colors.black12,
                              borderRadius: BorderRadius.circular(18.0),
                              radius: 30,
                            ),
                          ),
                        ],
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround),
                  ),
                  Container(
                    child: Divider(
                      height: 10,
                      color: Colors.white12,
                    ),
                  ),
//                  Container(
//                    color: Colors.white,
//                    child: auth != null
//                        ? auth
//                        : ListTile(
//                            title: Text('实名认证',
//                                style: TextStyle(fontSize: Constant.fontSize)),
//                            leading: Image.asset(
//                                'asset/images/visitor_icon_verify.png',
//                                scale: 1.5),
//                          ),
//                  ),
//                  Divider(height: 0.0),
//                  Container(
//                    color: Colors.white,
//                    child: soleCode != null
//                        ? soleCode
//                        : ListTile(
//                            title: Text('身份识别码',
//                                style: TextStyle(fontSize: Constant.fontSize)),
//                            leading: Image.asset(
//                                'asset/images/visitor_icon_qrcode.png',
//                                scale: 1.5),
//                            trailing: Image.asset(
//                                'asset/images/visitor_icon_next.png',
//                                scale: 2.0),
//                          ),
//                  ),
//                  Divider(height: 0.0),
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      title: Text('公司管理',
                          style: TextStyle(fontSize: Constant.fontSize)),
                      leading: Image.asset(
                          'asset/images/visitor_icon_staff.png',
                          scale: 1.5),
                      trailing: Image.asset(
                          'asset/images/visitor_icon_next.png',
                          scale: 2.0),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompanyPage(
                                      userInfo: _userInfo,
                                    )));
                      },
                    ),
                  ),
                  Divider(height: 0.0),
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      title: Text('安全管理',
                          style: TextStyle(fontSize: Constant.fontSize)),
                      leading: Image.asset(
                          'asset/images/visitor_icon_security.png',
                          scale: 1.5),
                      trailing: Image.asset(
                          'asset/images/visitor_icon_next.png',
                          scale: 2.0),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SecurityPage(userInfo: _userInfo)));
                      },
                    ),
                  ),
                  Container(
                    child: Divider(
                      height: 10,
                      color: Colors.white12,
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      title: Text('设置',
                          style: TextStyle(fontSize: Constant.fontSize)),
                      leading: Image.asset(
                          'asset/images/visitor_icon_setting.png',
                          scale: 1.5),
                      trailing: Image.asset(
                          'asset/images/visitor_icon_next.png',
                          scale: 2.0),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingPage()));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  ///身份识别码
  getSoleCode() {
    setState(() {
      QrcodeMode model =
          new QrcodeMode(userInfo: _userInfo, totalPages: 1, bitMapType: 1);
      List<String> qrMsg = QrcodeHandler.buildQrcodeData(model);
      Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return new Qrcode(qrCodecontent: qrMsg);
      }));
    });
  }

  ///获取用户信息
  getUserInfo() async {

      UserInfo userInfo = await DataUtils.getUserInfo();
      String imageServerUrl = await DataUtils.getPararInfo("imageServerUrl");
      if (userInfo != null) {
        setState(() {
          _userInfo = userInfo;
          _imageServerUrl = imageServerUrl;
          companyName = _userInfo.companyName;
          auth = getAuth();
          soleCode = getSoleCodeAuth();
        });
      }else{
        reloadUserInfo(userInfo);
      }
  }
  reloadUserInfo(UserInfo userInfo){
    Future.delayed(Duration(seconds: 1),() async {
      UserInfo userInfo = await DataUtils.getUserInfo();
      String imageServerUrl = await DataUtils.getPararInfo("imageServerUrl");
      if (userInfo != null) {
          setState(() {
            _userInfo = userInfo;
            companyName = _userInfo.companyName;
            _imageServerUrl = imageServerUrl;
            auth = getAuth();
            soleCode = getSoleCodeAuth();
          });
         if(_userInfo.id==null){
           print(_userInfo);
           print(userInfo);
           reloadUserInfo(userInfo);
         }
      }else{
        reloadUserInfo(userInfo);
      }
    });
  }
  ///获取图片上传的url
  getImageServerApiUrl() async {
    String url = Constant.getParamUrl + "imageServerApiUrl";
    var response = await Http.instance
        .get(url, queryParameters: {"paramName": "imageServerApiUrl"});
    if (!mounted) return;
    setState(() {
      JsonResult responseResult = JsonResult.fromJson(response);
      if (responseResult.sign == 'success') {
        _imageServerApiUrl = responseResult.data;
        DataUtils.savePararInfo("imageServerApiUrl", _imageServerApiUrl);
      } else {
        ToastUtil.showShortToast(responseResult.desc);
      }
    });
  }

  ///实名认证栏
  Widget auth;
  Widget getAuth() {
    if (_userInfo != null) {
      if (_userInfo.isAuth == 'F') {
        return ListTile(
          title: Text('实名认证', style: TextStyle(fontSize: Constant.fontSize)),
          leading:
              Image.asset('asset/images/visitor_icon_verify.png', scale: 1.5),
          trailing:
              Image.asset('asset/images/visitor_icon_next.png', scale: 2.0),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => IdentifyPage(
                          userInfo: _userInfo,
                        )));
          },
        );
      } else {
        return ListTile(
          title: Text('实名认证', style: TextStyle(fontSize: Constant.fontSize)),
          leading:
              Image.asset('asset/images/visitor_icon_verify.png', scale: 1.5),
          trailing: Text(
            '已实名',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }
    } else {
      return ListTile(
        title: Text('实名认证', style: TextStyle(fontSize: Constant.fontSize)),
        leading:
            Image.asset('asset/images/visitor_icon_verify.png', scale: 1.5),
        trailing: Text(
          '已实名',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
  }

  ///个人识别码栏
  Widget soleCode;
  Widget getSoleCodeAuth() {
    if (_userInfo != null) {
      if (_userInfo.isAuth == "T") {
        return ListTile(
          title: Text('身份识别码', style: TextStyle(fontSize: Constant.fontSize)),
          leading:
              Image.asset('asset/images/visitor_icon_qrcode.png', scale: 1.5),
          trailing:
              Image.asset('asset/images/visitor_icon_next.png', scale: 2.0),
          onTap: () {
            getSoleCode();
          },
        );
      } else {
        return ListTile(
          title: Text('身份识别码', style: TextStyle(fontSize: Constant.fontSize)),
          leading:
              Image.asset('asset/images/visitor_icon_qrcode.png', scale: 1.5),
          trailing:
              Image.asset('asset/images/visitor_icon_next.png', scale: 2.0),
          onTap: () {
            ToastUtil.showShortToast("请先进行实名认证，认证后开启该功能");
          },
        );
      }
    } else {
      return null;
    }
  }
}

//头像修改
class HeadImagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HeadImagePageState();
  }
}

class HeadImagePageState extends State<HeadImagePage> {
  File _image;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    _uploadImg();
  }

  Future getPhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
    _uploadImg();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('修改头像'),
        ),
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 300,
              width: 300,
              child: ClipOval(
                child: _image == null
                    ? Image.network(
                        _imageServerUrl +
                            (_userInfo.headImgUrl != null
                                ? _userInfo.headImgUrl
                                : _userInfo.idHandleImgUrl),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        _image,
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                      ),
              ),
            ),
            Center(
              child:
                  RaisedButton(child: Text('点击从相册中选取照片'), onPressed: getImage),
            ),
            Center(
              child: RaisedButton(child: Text('点击拍摄照片'), onPressed: getPhoto),
            ),
          ],
        ));
  }

  ///修改后的头像上传和个人信息内的头像地址的修改
  _uploadImg() async {
    String url = _imageServerApiUrl;
    var name = _image.path.split("/");
    var filename = name[name.length - 1];
    FormData formData = FormData.from({
      "userId": _userInfo.id,
      "type": "3",
      "file": new UploadFileInfo(_image, filename),
    });
    var res = await Http().post(url, data: formData);
    Map map = jsonDecode(res);
    String nickurl = Constant.serverUrl + Constant.updateNickAndHeadUrl;
    String threshold = await CommonUtil.calWorkKey();
    var nickres = await Http().post(nickurl, queryParameters: {
      "headImgUrl": map['data']['imageFileName'],
      "token": _userInfo.token,
      "userId": _userInfo.id,
      "factor": CommonUtil.getCurrentTime(),
      "threshold": threshold,
      "requestVer": CommonUtil.getAppVersion(),
    });
    setState(() {
      _userInfo.headImgUrl = map['data']['imageFileName'];
    });
    Map nickmap = jsonDecode(nickres);
    ToastUtil.showShortClearToast(nickmap['verify']['desc']);
  }
}
