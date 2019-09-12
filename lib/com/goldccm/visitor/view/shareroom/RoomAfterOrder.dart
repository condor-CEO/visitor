import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/RoomInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'package:visitor/com/goldccm/visitor/view/shareroom/roomHistory.dart';
import 'package:visitor/com/goldccm/visitor/view/shareroom/RoomList.dart';

class RoomAfterOrder extends StatefulWidget{
  final UserInfo userInfo;
  final RoomInfo roomInfo;
  final String timeLines;
  final int day;
  RoomAfterOrder({Key key,this.userInfo,this.roomInfo,this.timeLines,this.day}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return  RoomAfterOrderState();
  }
}
class RoomAfterOrderState extends State<RoomAfterOrder>{
  var splits;
  @override
  void initState() {
    super.initState();
    splits=widget.timeLines.split(",");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title:Text('预定详情',style: new TextStyle(
            fontSize: 17.0, color: Colors.white),),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.color,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);}),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 210,
              padding: EdgeInsets.only(right: 30),
              child: FittedBox(
                child: Image.asset("asset/icons/预定成功@2x.png",scale: 2.0),
                fit: BoxFit.scaleDown,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text('预订成功！',style: TextStyle(color: Colors.blue,fontSize: 18.0),),
            ),
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(left: 20,top: 40,bottom: 10),
                  child: Text('预定详情',style: TextStyle(color: Colors.black,fontSize: 18.0),),
                ),
                roomListWidget(widget.roomInfo),
              ],
            )
          ],
        ),
      )
    );
  }
  Widget roomListWidget(RoomInfo room){
    return   Container(
        width: MediaQuery.of(context).size.width,
        height: 130,
        child:InkWell(
          child:Container(
            padding: EdgeInsets.all(10),
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Image.network("http://www.yw2005.com/baike/uploads/allimg/160619/1-160619164J42K.jpg"),
                  ),
                  width: 104,
                  height: 110,
                  left: 8,
                  top: 8,
                ),
                Positioned(
                  child: Text('${room.roomName}',overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                  left: 120,
                  width: 250,
                  top: 8,
                ),
                Positioned(
                  child: Text('${room.roomAddress}',overflow: TextOverflow.ellipsis,maxLines: 2,),
                  left: 120,
                  width: 250,
                  top: 38,
                ),
                Positioned(
                  child: Container(
                    height: 30,
                    padding: EdgeInsets.all(2),
                    child: Text('预定时间：${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: widget.day)))}',style: TextStyle(fontSize: 12.0,color: Colors.blue[700]),),
                  ),
                  top: 88,
                  left:120,
                ),
                Positioned(
                  child:  Container(
                    height: 30,
                      padding: EdgeInsets.all(2),
                      child: Text('${splits[0].replaceAll(".5", ":30")
                          .replaceAll(".0", ":00")}-${(double.parse(splits[splits.length-1])+0.5).toString().replaceAll(".5", ":30")
                          .replaceAll(".0", ":00")}',style: TextStyle(fontSize: 12.0,color: Colors.blue[700]),),
                  ),
                  top: 90,
                  left: 246,
                ),
              ],
            ),
          ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>RoomHistory(userInfo: widget.userInfo,)));
          },
        )
    );
  }
}