import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/CommonUtil.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';

var _keys = null;

///公司管理
///userInfo接收来自上一级页面传递过来的变量
class CompanyPage extends StatefulWidget{
  CompanyPage({Key key,this.userInfo}):super(key:key);
  final UserInfo userInfo;
  @override
  State<StatefulWidget> createState() {
    return CompanyPageState();
  }
}
class CompanyPageState extends State<CompanyPage>{
  UserInfo userInfo;
  int groupValue=0;
  @override
  void initState() {
    super.initState();
    getCompanyInfo();
    userInfo=widget.userInfo;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('公司管理'),
        centerTitle:true,
      ),
      body:_buildInfo(),
    );
  }
  Widget _buildInfo() {
    if (_keys != null && _keys != "") {
      return ListView.builder(
          itemCount: _keys.length != null ? _keys.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child:
              Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ListTile(
                        title: Text('公司名称：'+_keys[index]['companyName'],style: TextStyle(fontSize: Constant.fontSize),),
                      ),
                      ListTile(
                        title: Text('部门名称：'+_keys[index]['sectionName'],style: TextStyle(fontSize: Constant.fontSize)),
                      ),
                      ListTile(
                        title: Text('用户姓名：'+_keys[index]['userName'],style: TextStyle(fontSize: Constant.fontSize)),
                      ),
                      ListTile(
                        title: Text('邀请时间：'+_keys[index]['createDate'],style: TextStyle(fontSize: Constant.fontSize)),
                      ),
                    ],
                  ),
                  Positioned(
                    child: Radio(value:index, groupValue: groupValue, onChanged: (T){updateGroupValue(T);}),
                    right: 10.0,
                    top:80.0,
                  ),
                ],
              ),
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
  ///获取公司信息
  getCompanyInfo() async {
    String url = Constant.serverUrl+Constant.findApplySucUrl;
    String threshold = await CommonUtil.calWorkKey();
    var res = await Http().post(url, queryParameters: {
      "token": userInfo.token,
      "userId": userInfo.id,
      "factor": CommonUtil.getCurrentTime(),
      "threshold": threshold,
      "requestVer": CommonUtil.getAppVersion(),
    });
    if (res != null) {
      Map map = jsonDecode(res);
      setState(() {
        _keys = map['data'];
        int index=0;
        for(var data in map['data']){
          if(data['companyId']==userInfo.companyId){
            groupValue=index;
            break;
          }
          index++;
        }
      });
    }
  }
  ///更新默认公司
  Future updateGroupValue(int v) async {
    String url = Constant.serverUrl+Constant.updateCompanyIdAndRoleUrl;
    String threshold = await CommonUtil.calWorkKey();
    var res = await Http().post(url,queryParameters: {
      "token": userInfo.token,
      "userId": userInfo.id,
      "factor": CommonUtil.getCurrentTime(),
      "threshold": threshold,
      "requestVer": CommonUtil.getAppVersion(),
      "companyId":_keys[v]['companyId'],
      "role":_keys[v]['roleType'],
    });
    Map map = jsonDecode(res);
    if(map['verify']['sign']=="success"){
      ToastUtil.showShortClearToast("修改公司成功");
      setState(() {
        groupValue=v;
      });
    }else{
      ToastUtil.showShortClearToast("修改公司失败");
    }
  }
}