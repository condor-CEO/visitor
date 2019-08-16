import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/RoomOrderInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/view/submod/roombook.dart';

class RoomHistory extends StatefulWidget{
  final UserInfo userInfo;
  RoomHistory({Key key,this.userInfo}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return RoomHistoryState();
  }
}
class RoomHistoryState extends State<RoomHistory>{
  int count=1;
  List<RoomOrderInfo> _roomLists= <RoomOrderInfo>[];
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  var _roomBuilderFuture;
  @override
  void initState() {
    super.initState();
    _roomBuilderFuture=getHistory();
    _scrollController.addListener((){
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        _getMoreData();
      }
    });
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  _getMoreData() async {
    if (!isPerformingRequest) {
      Future.delayed(Duration(seconds: 1),() async {
        setState(() => isPerformingRequest = true);
        String url=Constant.testServerUrl+"meeting/myReserveList/$count/10";
        var res = await Http().post(url,queryParameters: ({
          'apply_userid':27,
        }));
        if(res is String){
          Map map = jsonDecode(res);

          for(var data in map['data']['rows']){
            RoomOrderInfo roomOrderInfo=new RoomOrderInfo(id: data['id'],roomID: data['room_id'],applyUserID: data['apply_userid'],applyDate: data['apply_date'],applyStartTime: data['apply_start_time'].toString(),applyEndTime: data['apply_end_time'].toString(),timeInterval: data['time_interval'],recordStatus: data['record_status'],createTime: data['create_time'],cancelTime: data['cancle_time'],roomName: data['room_name'],roomAddress: data['room_addr'],roomIntro: data['room_short_content'],roomImage: data['room_image'],roomType: data['room_type']);
            _roomLists.add(roomOrderInfo);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('会议室记录'),
      ),

      body: FutureBuilder(
          builder: _roomFuture,
          future: _roomBuilderFuture,
        ),
    );
  }
  getHistory() async {
    String url=Constant.testServerUrl+"meeting/myReserveList/$count/10";
          var res = await Http().post(url,queryParameters: ({
            'apply_userid':27,
          }));
          if(res is String){
            Map map = jsonDecode(res);
            for(var data in map['data']['rows']){
              RoomOrderInfo roomOrderInfo=new RoomOrderInfo(id: data['id'],roomID: data['room_id'],applyUserID: data['apply_userid'],applyDate: data['apply_date'],applyStartTime: data['apply_start_time'].toString(),applyEndTime: data['apply_end_time'].toString(),timeInterval: data['time_interval'],recordStatus: data['record_status'],createTime: data['create_time'],cancelTime: data['cancle_time'],roomName: data['room_name'],roomAddress: data['room_addr'],roomIntro: data['room_short_content'],roomImage: data['room_image'],roomType: data['room_type']);
              _roomLists.add(roomOrderInfo);
            }
            setState(() {
              count++;
            });
    }
  }
  Widget _roomFuture(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('无连接');
        break;
      case ConnectionState.waiting:
        return Text('加载中');
        break;
      case ConnectionState.active:
        return Text('active');
        break;
      case ConnectionState.done:
        if (snapshot.hasError) return Text(snapshot.error.toString());
        return _buildRoomList();
        break;
      default:
        return null;
    }
  }
  _buildRoomList(){
    return  ListView.builder(
        itemCount:isPerformingRequest==true?_roomLists.length:_roomLists.length+1,
        itemBuilder: (BuildContext context,int index) {
          if(index == _roomLists.length){
            return ListTile(title: Text('加载中'),);
          }else {
            return ListTile(
              title: Text(_roomLists[index].roomName.toString()),
              subtitle: Text(_roomLists[index].recordStatus == 1
                  ? _roomLists[index].applyDate + " " +
                  _roomLists[index].applyStartTime.replaceAll(".5", ":30")
                      .replaceAll(".0", ":00") + "-" +
                  _roomLists[index].applyEndTime.replaceAll(".5", ":30")
                      .replaceAll(".0", ":00")
                  : '预定取消'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => RoomBook(order: _roomLists[index],userInfo: widget.userInfo,)));
              },
            );
          }
        },
        padding: EdgeInsets.all(8),
        controller: _scrollController,
    );
  }
}