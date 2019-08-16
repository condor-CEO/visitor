import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/CommonUtil.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';
import 'package:visitor/com/goldccm/visitor/view/submod/roomlist.dart';

class MoreFunction extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MoreFunctionState();
  }
}
class MoreFunctionState extends State<MoreFunction>{
  List<String> _iconImage=[];
  List<String> _iconTitle=[];
  List<String> _iconType = [];
  @override
  void initState() {
    super.initState();
    initFun();
  }
  initFun() async {
    UserInfo userInfo=await DataUtils.getUserInfo();
    String url = Constant.serverUrl + Constant.getUserInfoUrl;
    String threshold = await CommonUtil.calWorkKey();
    var res = await Http().post(url, queryParameters: {
      "token": userInfo.token,
      "userId": userInfo.id,
      "factor": CommonUtil.getCurrentTime(),
      "threshold": threshold,
      "requestVer": CommonUtil.getAppVersion(),
    });
    if(res is String){
      Map map = jsonDecode(res);
      if(map['verify']['sign']=="success"){
        if(map['data']['role']=="manage"){
          setState(() {
            _iconImage.add("asset/images/visitor_icon_meetingroom.png");
            _iconTitle.add("会议室");
            _iconType.add("_meetingRoom");
          });
        }
      }
    }
  }
  Widget _buildIconTab(String imageurl, String text,String iconType) {
    return new InkWell(
      onTap: (){
        if(iconType=="_meetingRoom"){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>RoomList()));
        }
      },
      child: new Container(
        height: 80.0,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(padding: EdgeInsets.only(top: 10.0),child: new Image.asset(
              imageurl,
              width: 40,
              height: 40,
            ),),
            new Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: new Text(
                text,
                style: new TextStyle(fontSize: 14, fontFamily: '楷体_GB2312',fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GridView.count(
        crossAxisCount: 4,
        children: List.generate(_iconImage!=null?_iconImage.length:0, (index){
        return _buildIconTab(_iconImage[index],_iconTitle[index],_iconType[index]);
        })
      )
    );
  }
}