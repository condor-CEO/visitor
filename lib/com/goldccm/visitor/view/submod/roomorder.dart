import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/RoomInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'package:visitor/com/goldccm/visitor/view/submod/roomHistory.dart';
import 'package:visitor/com/goldccm/visitor/view/submod/roomlist.dart';

class RoomOrder extends StatefulWidget{
  final UserInfo userInfo;
  final RoomInfo roomInfo;
  final String timeLines;
  final int day;
  RoomOrder({Key key,this.userInfo,this.roomInfo,this.timeLines,this.day}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return  RoomOrderState();
  }
}
class RoomOrderState extends State<RoomOrder>{
  var splits;
  bookRoom(int userID,int roomID,String timeLines,int day) async {
    var splits = timeLines.split(",");
    String url=Constant.testServerUrl+"meeting/reserve";
    var res = await Http().post(url,queryParameters: ({
      'apply_userid':27,
      'room_id':roomID,
      'apply_date':DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: day))),
      'time_interval':timeLines,
      'apply_start_time':splits[0],
      'apply_end_time':(double.parse(splits[splits.length-1])+0.5).toString(),
      'user_name':widget.userInfo.realName,
      'phone':widget.userInfo.phone,
    }));
    if(res is String){
      Map map = jsonDecode(res);
      if(map['verify']['sign']=="success"){
        ToastUtil.showShortToast("预定成功");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>RoomHistory()));
      }else{
        ToastUtil.showShortToast(map['verify']['desc']);
        Navigator.pop(context);
      }
    }
  }
  @override
  void initState() {
    super.initState();
    splits=widget.timeLines.split(",");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('确认订单'),),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(title: Text(widget.roomInfo.roomName),),
            ListTile(title: Text('${splits[0].replaceAll(".5", ":30")
                .replaceAll(".0", ":00")}点至${(double.parse(splits[splits.length-1])+0.5).toString().replaceAll(".5", ":30")
                .replaceAll(".0", ":00")}点')),
          ],
        ),
      ),
      bottomSheet: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: new SizedBox(
                width: 300.0,
                height: 50.0,
                child: new FlatButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  child: new Text('确认预定'),
                  onPressed: () async {
                    bookRoom(widget.userInfo.id,widget.roomInfo.id,widget.timeLines,widget.day);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}