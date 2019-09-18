import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:visitor/com/goldccm/visitor/component/Qrcode.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/FunctionLists.dart';
import 'package:visitor/com/goldccm/visitor/model/JsonResult.dart';
import 'package:visitor/com/goldccm/visitor/model/QrcodeMode.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/UserModel.dart';
import 'package:visitor/com/goldccm/visitor/util/CommonUtil.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';
import 'package:visitor/com/goldccm/visitor/util/QrcodeHandler.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/companypage.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/identifypage.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/securitypage.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/settingpage.dart';
import 'package:visitor/com/goldccm/visitor/view/shareroom/roomHistory.dart';
import 'package:visitor/com/goldccm/visitor/view/visitor/friendHistory.dart';
import 'package:visitor/com/goldccm/visitor/view/visitor/inviteHistory.dart';
import 'package:visitor/com/goldccm/visitor/view/visitor/visithistory.dart';
//个人中心界面
//包含个人信息显示、历史消息记录、公司管理、安全管理、设置
class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }
}
//_userInfo存放用户个人信息
//_imageServerUrl是图片访问服务器地址
//_imageServerApiUrl是图书上传服务器地址
UserInfo _userInfo = new UserInfo();
UserInfo userInfo=new UserInfo();
String _imageServerUrl;
String _imageServerApiUrl;

class MinePageState extends State<MinePage> {
  List<FunctionLists> _addlist=[FunctionLists(iconImage: 'asset/icons/实名认证V.png',iconTitle: '实名认证',iconType: '_verify'),FunctionLists(iconImage: 'asset/icons/会议室icon@2x.png',iconTitle:'会议室',iconType:'_meetingRoom'),FunctionLists(iconImage: 'asset/icons/公司管理@2x.png',iconTitle:'公司管理',iconType: '_companySetting' ),];
  List<FunctionLists> _baseList=[FunctionLists(iconImage:'asset/icons/安全管理@2x.png',iconTitle:'安全管理',iconType: '_securitySetting' ),FunctionLists(iconImage:'asset/icons/设置@2x.png',iconTitle: '设置',iconType:'_setting' )];
  List<FunctionLists> _list = [];
  ScrollController _minescrollController = new ScrollController();
  final double expandedHeight = 65.0;
  double get top {
    double res = expandedHeight;
    if ( _minescrollController.hasClients) {
      double offset =  _minescrollController.offset;
      res -= offset;
    }
    return res;
  }
  //初始化
  //获取个人信息和图片服务器地址
  @override
  void initState() {
    super.initState();
    getUserInfo();
    getImageServerApiUrl();
    _minescrollController.addListener(() {
      var maxScroll = _minescrollController.position.maxScrollExtent;
      var pixel = _minescrollController.position.pixels;
      if(maxScroll==pixel){
        setState(() {});
      }else{
        setState(() {});
      }
    });
  }
  //个人中心角色权限获取
  Future getPrivilege() async {
    String url = Constant.serverUrl+"userAppRole/getRoleMenu";
    String threshold = await CommonUtil.calWorkKey(userInfo: _userInfo);
    var res = await Http().post(url, queryParameters: {
      "token": _userInfo.token,
      "userId": _userInfo.id,
      "factor": CommonUtil.getCurrentTime(),
      "threshold": threshold,
      "requestVer": CommonUtil.getAppVersion(),
      "userId":"45",
      "orgId":"20",
    });
    //附加权限
    if(res != null){
      if(res is String){
        Map map = jsonDecode(res);
        if(map['data']!=null){
          for(int i=0;i<map['data'].length;i++){
            for(int j=0;j<_addlist.length;j++){
                if(_addlist[j].iconTitle==map['data'][i]['menu_name']){
                  _list.add(_addlist[j]);
                }
            }
          }
        }
      }
    }else{

    }
    //基础权限
    for(int i=0;i<_baseList.length;i++){
      _list.add(_baseList[i]);
    }
  }
  @override
  void dispose() {
    _minescrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    UserInfo _userInfo=Provider.of<UserModel>(context).info;
    if(userInfo==null||userInfo.id==null){
      userInfo=_userInfo;
    }
    var user = Provider.of<UserModel>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            controller:  _minescrollController,
            slivers: <Widget>[
              SliverAppBar(
                title: Text(
                  "我的",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontSize: 18.0, color: Colors.white),
                ),
                expandedHeight: 100.0,
                backgroundColor: Theme.of(context).appBarTheme.color,
                centerTitle: true,
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 150, 20, 0),
                sliver: new SliverGrid(
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                  ),
                  delegate: new SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return _buildIconTab(_list[index].iconImage,_list[index].iconTitle,_list[index].iconType);
                    },
                    childCount: _list.length
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: top,
            height: 200,
            left: 15,
            right: 15,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 20.0,
              child: Container(
                  height: 120,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: GestureDetector(
                              onTap: () {
                                if(_userInfo.headImgUrl != null||_userInfo.idHandleImgUrl!=null){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HeadImagePage()));
                                }
                              },
                              child: CircleAvatar(
                                backgroundImage: _userInfo.headImgUrl != null?NetworkImage(
                                        Constant.imageServerUrl +
                                            (_userInfo.headImgUrl ),)
                                    : _userInfo.idHandleImgUrl!=null?NetworkImage(
                                  Constant.imageServerUrl +
                                      (_userInfo.idHandleImgUrl ),):AssetImage('asset/images/visitor_icon_account.png'),
                                radius: 100,
                              ),
                            ),
                            width: 60.0,
                            margin: EdgeInsets.all(20),
                            height: 60.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Consumer(
                                  builder:
                                      (context, UserModel userModel, widget) =>
                                          Text(
                                            userModel.info.realName != null
                                                ? userModel.info.realName
                                                : '暂未获取到数据',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.0,
                                            ),
                                          )),
                              Consumer(
                                builder:
                                    (context, UserModel userModel, widget) =>
                                        Text(
                                          userModel.info.companyName != null
                                              ? userModel.info.companyName
                                              : '暂未获取到数据',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                          ),
                                        ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Container(
                        child: Divider(
                          height: 5,
                          color: Colors.black12,
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Row(
                            children: <Widget>[
                              Material(
                                color: Colors.white,
                                child: InkWell(
                                  child: Container(
                                    width: 80,
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(Icons.person),
                                        Text('访问'),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>VisitHistory(userInfo: user.info,)));
                                  },
                                  splashColor: Colors.black12,
                                  borderRadius: BorderRadius.circular(18.0),
                                  radius: 30,
                                ),
                              ),
                              Material(
                                color: Colors.white,
                                child: InkWell(
                                  child: Container(
                                    width: 80,
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(Icons.perm_contact_calendar),
                                        Text('邀约'),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>InviteHistory(userInfo:user.info,)));
                                  },
                                  splashColor: Colors.black12,
                                  borderRadius: BorderRadius.circular(18.0),
                                  radius: 30,
                                ),
                              ),
                              Material(
                                color: Colors.white,
                                child: InkWell(
                                  child: Container(
                                    width: 80,
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(Icons.person_add),
                                        Text('好友'),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>FriendHistory(userInfo: user.info,)));
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
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildIconTab(String url, String text,String method) {
    return InkWell(
          onTap: (){
            if(method=="_meetingRoom"){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>RoomHistory (userInfo: _userInfo,)));
            }else if(method=="_companySetting"){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CompanyPage(userInfo: _userInfo,)));
            }else if(method=="_securitySetting"){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SecurityPage(userInfo: _userInfo)));
            }else if(method=="_setting"){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));
            }else if(method=="_verify"){
              if(_userInfo.isAuth=="T") {
                ToastUtil.showShortClearToast("您已实名，请勿重复操作");
              }else {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => IdentifyPage(userInfo: _userInfo,)));
              }
            }
          },
          child: new Container(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Padding(padding: EdgeInsets.only(top: 0.0),child: new Image.asset(url, width: 49, height: 49,)),
                new Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: new Text(text, style: new TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
    );
  }
  ///获取用户信息
  getUserInfo() async {
    UserInfo userInfo = await DataUtils.getUserInfo();
    String imageServerUrl = await DataUtils.getPararInfo("imageServerUrl");
    if (userInfo != null) {
      setState(() {
        _userInfo = userInfo;
        _imageServerUrl = imageServerUrl;
        getPrivilege();
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
      String imageServerUrl = await DataUtils.getPararInfo("imageServerUrl");
      if (userInfo != null) {
        if (_userInfo.id == null) {
          reloadUserInfo(userInfo);
        }else {
          setState(() {
            _userInfo = userInfo;
            _imageServerUrl = imageServerUrl;
            getPrivilege();
          });
        }
      } else {
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
          centerTitle: true,
          backgroundColor: Theme.of(context).appBarTheme.color,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);}),
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
                        Constant.imageServerUrl +
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
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width-40,
                    height: 50,
                    child: RaisedButton(child: Text('点击从相册中选取照片',style: TextStyle(fontSize: 16.0),), onPressed: getImage,elevation: 5.0,color: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),),
                  )
            ),
            Center(
              child:  Container(
                color: Colors.white,
                margin: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width-40,
                height: 50,
                child:RaisedButton(child: Text('点击拍摄照片',style: TextStyle(fontSize: 16.0),), onPressed: getPhoto,elevation: 5.0,color: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
          ],
        ));
  }

  ///修改后的头像上传和个人信息内的头像地址的修改
  _uploadImg() async {
    String url = Constant.imageServerApiUrl;
    var name = _image.path.split("/");
    var filename = name[name.length - 1];
    FormData formData = FormData.from({
      "userId": _userInfo.id,
      "type": "4",
      "file": new UploadFileInfo(_image, filename),
    });
    var res = await Http().post(url, data: formData);
    Map map = jsonDecode(res);
    String nickurl = Constant.serverUrl+ Constant.updateNickAndHeadUrl;
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
      DataUtils.updateUserInfo(_userInfo);
    });
    if(nickres is String){
      Map nickmap = jsonDecode(nickres);
      if(nickmap['verify']['desc']=="success"){
        ToastUtil.showShortClearToast(nickmap['verify']['desc']);
        Navigator.pop(context);
      }else{
        ToastUtil.showShortClearToast(nickmap['verify']['desc']);
      }
    }
  }
}
