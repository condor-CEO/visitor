import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/JsonResult.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/CommonUtil.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:city_picker/city_picker.dart';
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';

///实名验证
class IdentifyPage extends StatefulWidget {
  IdentifyPage({Key key, this.userInfo}) : super(key: key);
  final UserInfo userInfo;
  @override
  State<StatefulWidget> createState() {
    return IdentifyPageState();
  }
}

class IdentifyPageState extends State<IdentifyPage> {
  File _image;
  final formKey = GlobalKey<FormState>();
  String realName;
  String idNumber;
  String address;
  String deatilAddress;
  UserInfo userInfo;
  String _imageServerApiUrl;
  var areaController = new TextEditingController();
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
    userInfo = widget.userInfo;
    getImageServerApiUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('实名认证'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 100,
                      child: ClipOval(
                        child: _image == null
                            ? Image.asset('asset/images/visitor_icon_head.png',
                            width: 100, height: 100)
                            : Image.file(
                          _image,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    Center(
                      child: RaisedButton(
                          child: Text('点击拍摄照片'), onPressed: getImage),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  '身份信息（必填）',
                  style: TextStyle(fontSize: Constant.fontSize),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                color: Colors.white,
                child: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '请输入您的真实姓名',
                      hintStyle: TextStyle(
                        fontSize: Constant.fontSize,
                      )),
                  style: TextStyle(
                    fontSize: Constant.fontSize,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '请填入您的真实姓名';
                    }
                  },
                  onSaved: (value) {
                    realName = value;
                  },
                ),
              ),
              Divider(
                height: 0,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                color: Colors.white,
                child: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '请输入您的身份证号码（将加密处理）',
                      hintStyle: TextStyle(
                        fontSize: Constant.fontSize,
                      )),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '请输入您的身份证号码';
                    }
                  },
                  style: TextStyle(
                    fontSize: Constant.fontSize,
                  ),
                  onSaved: (value) {
                    idNumber = value;
                  },
                ),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text('身份证上地址信息（选填）',
                    style: TextStyle(fontSize: Constant.fontSize)),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                color: Colors.white,
                child: GestureDetector(
                  onTap: () async {
                    print(1);
                    CityResult result = await showCityPicker(context);
                    setState(() {
                      print(result);
                      if (result != null) {
                        areaController.text = result?.province +
                            "-" +
                            result?.city +
                            "-" +
                            result?.county;
                        address = result?.province +
                            result?.city +
                            result?.county;
                      }
                    });
                  },
                  child: TextFormField(
                    enabled: false,
                    controller: areaController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '请选择所在地区',
                        hintStyle: TextStyle(
                          fontSize: Constant.fontSize,
                        )),
                    style: TextStyle(
                      fontSize: Constant.fontSize,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return '请选择所在地区';
                      }
                    },
                  ),
                ),
              ),
              Divider(
                height: 0,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                color: Colors.white,
                child: TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '请输入详细地址信息，如道路、门牌号、小区、楼栋号、单元室等',
                      hintStyle: TextStyle(
                        fontSize: Constant.fontSize,
                      )),
                  style: TextStyle(
                    fontSize: Constant.fontSize,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '请输入详细地址信息';
                    }
                  },
                  onSaved: (value) {
                    deatilAddress = value;
                  },
                ),
              ),
              new Container(
                padding: EdgeInsets.all(10.0),
                child: new SizedBox(
                  width: 300.0,
                  height: 50.0,
                  child: new RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: new Text('提交'),
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        identify();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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

  identify() async {
    if (_image == null) {
      ToastUtil.showShortClearToast("未检测到头像");
    } else {
      String preurl = Constant.serverUrl + Constant.isVerifyUrl;
      String url = Constant.serverUrl + Constant.verifyUrl;
      String threshold = await CommonUtil.calWorkKey();
      var preres = await Http().post(preurl, queryParameters: {
        "token": userInfo.token,
        "userId": userInfo.id,
        "factor": CommonUtil.getCurrentTime(),
        "threshold": threshold,
        "requestVer": CommonUtil.getAppVersion(),
      });
      Map premap = jsonDecode(preres);
      if (premap['verify']['sign'] == "fail") {
        String imageurl = _imageServerApiUrl;
        var name = _image.path.split("/");
        var filename = name[name.length - 1];
        FormData formData = FormData.from({
          "userId": userInfo.id,
          "type": "3",
          "file": new UploadFileInfo(_image, filename),
        });
        var imageres = await Http().post(imageurl, data: formData);
        Map imagemap = jsonDecode(imageres);
        if (imagemap['data']['imageFileName'] != null) {
          var res = await Http().post(url, queryParameters: {
            "token": userInfo.token,
            "userId": userInfo.id,
            "factor": CommonUtil.getCurrentTime(),
            "threshold": threshold,
            "requestVer": CommonUtil.getAppVersion(),
            "realName": realName,
            "idNo": idNumber,
            "address": address + " " + deatilAddress,
            "idHandelImgUrl": imagemap['data']['imageFileName'],
          });
          Map map = jsonDecode(res);
        } else {
          ToastUtil.showShortClearToast("头像上传失败，请重新上传！");
        }
      } else {
        ToastUtil.showShortClearToast("已经实名验证过");
      }
    }
  }
}

