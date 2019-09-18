import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/component/Qrcode.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/QrcodeMode.dart';
import 'package:visitor/com/goldccm/visitor/model/RoomInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/RoomOrderInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/CommonUtil.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/QrcodeHandler.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'package:visitor/com/goldccm/visitor/view/shareroom/RoomCheckOut.dart';

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
  RoomInfo _roomInfo = new RoomInfo();
  cancelOrder(RoomOrderInfo room) async {
    String url = Constant.serverUrl+"meeting/cancle";
    String threshold = await CommonUtil.calWorkKey();
    print(widget.userInfo.id);
    var res = await Http().post(url,queryParameters:({
      'record_id':room.id,
      'user_name':widget.userInfo.realName,
      'phone':widget.userInfo.phone,
      'room_id':room.roomID,
      "token": widget.userInfo.token,
      "factor": CommonUtil.getCurrentTime(),
      "threshold": threshold,
      "requestVer": CommonUtil.getAppVersion(),
      "userId": widget.userInfo.id,
    }));
    if(res is String){
      Map map = jsonDecode(res);
      if(map['verify']['sign']=="success"){
        ToastUtil.showShortClearToast("取消预约成功");
        Navigator.pop(context);
      }else{
        ToastUtil.showShortClearToast(map['verify']['desc']);
      }
    }
  }
  @override
  void initState() {
    super.initState();
    RoomInfo roomInfo =new RoomInfo(id: widget.order.roomID,roomAddress: widget.order.roomAddress,roomName: widget.order.roomName,roomPrice: (double.parse(widget.order.price)/widget.order.timeInterval.split(",").length).toString());
    setState(() {
      _roomInfo=roomInfo;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('您的预定'),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.color,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);}),
      ),
      body: SingleChildScrollView(
        child:  Column(
          children: <Widget>[
            Divider(height: 0,),
            ListTile(title: Text('名称'),trailing: Text(widget.order.roomName),),
            Divider(height: 0,),
            ListTile(title: Text('时间'),trailing: Text(widget.order.applyStartTime.replaceAll("\.5", ":30").replaceAll("\.0", ":00")+"-"+widget.order.applyEndTime.replaceAll("\.5", ":30").replaceAll("\.0", ":00")),),
            Divider(height: 0,),
            ListTile(title: Text('地点'),trailing: Text(widget.order.roomAddress),),
            Divider(height: 0,),
            Container(
              padding: EdgeInsets.only(top: 50,left: 10,right: 10),
              child: new SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: (widget.order.tradeStatus=="1"||widget.order.tradeNO==null)?new FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: new Text('前往支付',style: TextStyle(fontSize: 18.0),),
                  onPressed: () async {
                    String applyDate=widget.order.applyDate;
                    var diff= DateTime.now().difference(DateTime.parse(applyDate));
                    if(diff.inDays<=6&&diff.inDays>=0){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>RoomCheckOut(userInfo: widget.userInfo,timeLines: widget.order.timeInterval,startTime: widget.order.applyStartTime,endTime: widget.order.applyEndTime,count: widget.order.timeInterval.split(",").length,roomInfo: _roomInfo,day: diff.inDays,roomOrderInfo: widget.order,)));
                    }else{
                      ToastUtil.showShortClearToast("超过支付时间");
                    }
                  },
                ):switchPassWay(widget.order.gate),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: new SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: new FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  color: Colors.grey,
                  textColor: Colors.white,
                  child: new Text('取消预定',style: TextStyle(fontSize: 18.0),),
                  onPressed: () async {
//                    cancelOrder(widget.order);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget switchPassWay(int status){
    if(status==1){
      return new FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.blue,
        textColor: Colors.white,
        child: new Text('人脸扫描进出',style: TextStyle(fontSize: 18.0),),
        onPressed: () async {

        },
      );
    }
    else if(status==2){
      return new FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.blue,
        textColor: Colors.white,
        child: new Text('显示二维码',style: TextStyle(fontSize: 18.0),),
        onPressed: () async {
          QrcodeMode model = new QrcodeMode(userInfo: widget.userInfo,totalPages: 1,bitMapType: 4,roomOrderInfo: widget.order);
          List<String> qrMsg = QrcodeHandler.buildQrcodeData(model);
          print('$qrMsg[0]');
          Navigator.push(context,
              new MaterialPageRoute(builder: (BuildContext context) {
                return new Qrcode(qrCodecontent:qrMsg);
              }));

        },
      );
    }else{
      return new FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.blue,
        textColor: Colors.white,
        child: new Text('未知方式，请到现场联系工作人员开门',style: TextStyle(fontSize: 18.0),),
        onPressed: () async {

        },
      );
    }
  }
}
