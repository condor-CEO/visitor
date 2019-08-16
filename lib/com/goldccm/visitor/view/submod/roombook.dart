import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/RoomOrderInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';

class RoomBook extends StatefulWidget {
  final UserInfo userInfo;
  final RoomOrderInfo order;
  RoomBook({Key key,this.order,this.userInfo}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return RoomBookState();
  }
}

class RoomBookState extends State<RoomBook> {
  cancelOrder(RoomOrderInfo room) async {
    String url = Constant.testServerUrl+"meeting/cancle";
    var res = await Http().post(url,queryParameters:({
      'id':room.id,
      'user_name':widget.userInfo.realName,
      'phone':widget.userInfo.phone,
      'room_id':room.roomID,
    }));
    if(res is String){
      Map map = jsonDecode(res);
      if(map['verify']['sign']=="success"){
        ToastUtil.showShortToast("取消预约成功");
        Navigator.pop(context);
      }else{
        ToastUtil.showShortToast(map['verify']['desc']);
        Navigator.pop(context);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('您的订单'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
             ListTile(title: Text(widget.order.roomName),),
             ListTile(title: Text('${widget.order.applyStartTime.replaceAll(".5", ":30")
                 .replaceAll(".0", ":00")}点至${widget.order.applyEndTime.replaceAll(".5", ":30")
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
                  child: new Text('取消预定'),
                  onPressed: () async {
                    cancelOrder(widget.order);
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
