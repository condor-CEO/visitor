import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/JsonResult.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';
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
  @override
  void initState() {
    super.initState();
    getUserInfo();
    getImageServerApiUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text('我'),
          elevation: 0,
        ),
        body: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.blue, boxShadow: [
                BoxShadow(
                  offset: Offset(0.0, 5.0),
                  color: Colors.black12,
                  blurRadius: 20.0,
                )
              ]),
              height: 100,
              child: Row(
                children: <Widget>[
                  Container(
                    child:
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HeadImagePage()));
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            _imageServerUrl+_userInfo.idHandleImgUrl,
                        ),
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
                        _userInfo.realName != null
                            ? _userInfo.realName
                            : '暂未获取到数据',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                      Text(
                        _userInfo.companyName != null ? _userInfo.companyName : '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(children: <Widget>[
                getAuth(),
                Divider(height: 0.0),
                ListTile(
                  title: Text('身份识别码',style:TextStyle(fontSize: Constant.fontSize)),
                  leading: Image.asset('asset/images/visitor_icon_qrcode.png',
                      scale: 1.5),
                  trailing: Image.asset('asset/images/visitor_icon_next.png',
                      scale: 2.0),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IdentifyCodePage()));
                  },
                ),
                Divider(height: 0.0),
                ListTile(
                  title: Text('公司管理',style:TextStyle(fontSize: Constant.fontSize)),
                  leading: Image.asset('asset/images/visitor_icon_staff.png',
                      scale: 1.5),
                  trailing: Image.asset('asset/images/visitor_icon_next.png',
                      scale: 2.0),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CompanyPage()));
                  },
                ),
                Divider(height: 0.0),
                ListTile(
                  title: Text('安全管理',style:TextStyle(fontSize: Constant.fontSize)),
                  leading: Image.asset('asset/images/visitor_icon_security.png',
                      scale: 1.5),
                  trailing: Image.asset('asset/images/visitor_icon_next.png',
                      scale: 2.0),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SecurityPage(userInfo: _userInfo)));
                  },
                ),
                Divider(height: 0.0),
                ListTile(
                  title: Text('设置',style:TextStyle(fontSize: Constant.fontSize)),
                  leading: Image.asset('asset/images/visitor_icon_setting.png',
                      scale: 1.5),
                  trailing: Image.asset('asset/images/visitor_icon_next.png',
                      scale: 2.0),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SettingPage()));
                  },
                ),
              ]),
            ),
          ],
        ));
  }

  getUserInfo() async {
    Future<UserInfo> userInfo=DataUtils.getUserInfo();
    Future<String>imageServerUrl = DataUtils.getPararInfo("imageServerUrl");
    setState(() async {
    await userInfo.then((onValue){
        _userInfo=onValue;
        auth=getAuth();
    });
    await imageServerUrl.then((onValue){
        _imageServerUrl=onValue;
    });
    });
  }
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

  Widget auth;
  Widget getAuth() {
    if (_userInfo.isAuth == 'F') {
      return ListTile(
        title: Text('实名认证',style:TextStyle(fontSize: Constant.fontSize)),
        leading:
            Image.asset('asset/images/visitor_icon_verify.png', scale: 1.5),
        trailing: Image.asset('asset/images/visitor_icon_next.png', scale: 2.0),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => IdentifyPage()));
        },
      );
    } else {
      return ListTile(
        title: Text('实名认证',style:TextStyle(fontSize: Constant.fontSize)),
        leading: Image.asset('asset/images/visitor_icon_verify.png',
            scale: 1.5),
        trailing: Text('已实名',style: TextStyle(color: Colors.grey),),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => IdentifyPage()));
        },
      );
    }
  }
}
class HeadImagePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HeadImagePageState();
  }
}
class HeadImagePageState extends State<HeadImagePage>{
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
              child:_image == null
                  ? Image.network(_imageServerUrl+_userInfo.idHandleImgUrl,width: 200,height: 200,fit:BoxFit.cover,)
                  : Image.file(_image,fit: BoxFit.cover,width: 200,height: 200,),
            ),
          ),
          Center(
            child: RaisedButton(child:Text('点击从相册中选取照片'),onPressed:getImage),
          ),
          Center(
            child: RaisedButton(child:Text('点击拍摄照片'),onPressed:getPhoto),
          ),
        ],
      )
    );
  }
  _uploadImg()async{
      String url=_imageServerApiUrl;
      var name=_image.path.split("/");
      var filename=name[name.length-1];
      FormData formData=FormData.from({
        "userId":_userInfo.id,
        "type":"3",
        "file":new UploadFileInfo(_image,filename),
      });
      var res = await Http().post(url,data:formData);
      Map map = jsonDecode(res);
      print(map['data']['imageFileName']);
      String nickurl=Constant.updateNickAndHeadUrl;
      var nickres = await Http().postWithHeader(nickurl,queryParameters: {
        "headImgUrl":map['data']['imageFileName'],
      });
  }
}
