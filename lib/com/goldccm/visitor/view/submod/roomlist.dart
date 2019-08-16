import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/RoomInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/view/submod/roomdetail.dart';

class RoomList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return RoomListState();
  }
}
class RoomListState extends State<RoomList>{
  int count=1;
  List<RoomInfo> roomLists=new List<RoomInfo>();
  bool isPerformingRequest = false;
  ScrollController _scrollController = new ScrollController();
  getRoomLists() async {
    String url = Constant.testServerUrl+"meeting/list/$count/10";
    var res = await Http().post(url,queryParameters: {
      "orgCode":"hlxz",
    });
    if(res is String){
      Map map = jsonDecode(res);
      for(var room in map['data']['rows']){
        RoomInfo info = new RoomInfo(id:room['id'],roomName: room['room_name'],roomOpenTime: room['room_open_time'],roomCloseTime: room['room_close_time'],roomIntro: room['room_short_content']);
        setState(() {
          roomLists.add(info);
        });
      }
      setState(() {
        count++;
      });
    }
  }
  _getMoreData() async {
    if (!isPerformingRequest) {
      Future.delayed(Duration(seconds: 1),() async {
        setState(() => isPerformingRequest = true);
        String url=Constant.testServerUrl+"meeting/list/$count/10";
        var res = await Http().post(url,queryParameters: ({
          "orgCode":"hlxz",
        }));
        if(res is String){
          Map map = jsonDecode(res);
          for(var room in map['data']['rows']){
            RoomInfo info = new RoomInfo(id:room['id'],roomName: room['room_name'],roomOpenTime: room['room_open_time'],roomCloseTime: room['room_close_time'],roomIntro: room['room_short_content']);
            roomLists.add(info);
          }
          setState(() {
            count++;
            isPerformingRequest = false;
          });
          if(map['data']['rows'].length==0){
            setState(() {
              count--;
              isPerformingRequest = true;
            });
          }
        }
      });
    }
  }
  @override
  void initState() {
    super.initState();
    getRoomLists();
    _scrollController.addListener((){
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        _getMoreData();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text( '共享会议室')),
      body: ListView.builder(
        itemBuilder: (_, int index) => index==roomLists.length?ListTile(title: Text('加载中'),):roomListWidget(roomLists[index]),
        itemCount: isPerformingRequest==true?roomLists.length:roomLists.length+1,
        controller: _scrollController,
      ),
    );
  }
  Widget roomListWidget(RoomInfo room){
    return   Container(
        width: 400,
        height: 230,
        child:GestureDetector(
          child:Container(
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
            padding: EdgeInsets.all(10),
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Image.network("http://www.yw2005.com/baike/uploads/allimg/160619/1-160619164J42K.jpg"),
                  ),
                  height: 150,
                  left: 8,
                  right: 8,
                  top: 8,
                ),
                Positioned(
                  child: Text('地址：${room.roomIntro}',overflow: TextOverflow.ellipsis,maxLines: 1,),
                  left: 8,
                  width: 250,
                  top: 160,
                ),
                Positioned(
                  child: Text('开放时间：${room.roomOpenTime}'),
                  top: 180,
                  left: 8,
                ),
                Positioned(
                  child: Text('关闭时间：${room.roomCloseTime}'),
                  top: 180,
                  left: 140,
                ),
                Positioned(
                  child: Text('100元/小时'),
                  top: 170,
                  right: 8,
                )
              ],
            ),
          ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>RoomDetail(roomInfo: room,)));
          },
        )
    );
  }
}
