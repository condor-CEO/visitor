import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/RoomInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/CommonUtil.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'package:visitor/com/goldccm/visitor/view/shareroom/RoomDetail.dart';

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
    UserInfo userInfo=await DataUtils.getUserInfo();
    String url = Constant.serverUrl+"meeting/list/$count/10";
    String threshold = await CommonUtil.calWorkKey();
    var res = await Http().post(url,queryParameters: {
      "orgCode":"hlxz",
      "token": userInfo.token,
      "factor": CommonUtil.getCurrentTime(),
      "threshold": threshold,
      "requestVer": CommonUtil.getAppVersion(),
      "userId": userInfo.id,
    });
    if(res is String) {
      Map map = jsonDecode(res);
      if (map['verify']['sign'] == "success") {
        for (var room in map['data']['rows']) {
          RoomInfo info = new RoomInfo(id: room['id'],
              roomName: room['room_name'],
              roomOpenTime: room['room_open_time'],
              roomCloseTime: room['room_close_time'],
              roomIntro: room['room_short_content'],
              roomPrice: room['room_price'].toString(),
              roomAddress: room['room_addr'],
              roomStatus: room['room_status'].toString(),
              roomManager: room['room_manager'].toString(),
              roomType: room['room_type'],
              roomSize: room['room_size'],
              roomImage: room['room_image'],
              roomCancelHour: room['rooom_cancle_hour'],
              roomOrgCode: room['room_orgcode'],
              roomPercent: room['room_percent'].toString());
          setState(() {
            roomLists.add(info);
          });
        }
        setState(() {
          count++;
        });
      }
      else{
        ToastUtil.showShortClearToast(map['verify']['desc']);
      }
    }
  }
  _getMoreData() async {
    if (!isPerformingRequest) {
      Future.delayed(Duration(seconds: 1),() async {
        setState(() => isPerformingRequest = true);
        UserInfo userInfo=await DataUtils.getUserInfo();
        String url=Constant.serverUrl+"meeting/list/$count/10";
        String threshold = await CommonUtil.calWorkKey();
        var res = await Http().post(url,queryParameters: ({
          "orgCode":"hlxz",
          "token": userInfo.token,
          "factor": CommonUtil.getCurrentTime(),
          "threshold": threshold,
          "requestVer": CommonUtil.getAppVersion(),
          "userId": userInfo.id,
        }));
        if(res is String){
          Map map = jsonDecode(res);
          for(var room in map['data']['rows']){
            RoomInfo info = new RoomInfo(id:room['id'],roomName: room['room_name'],roomOpenTime: room['room_open_time'],roomCloseTime: room['room_close_time'],roomIntro: room['room_short_content'],roomPrice: room['room_price'],roomAddress: room['room_addr'],roomStatus: room['room_status'],roomManager: room['room_manager'],roomType: room['room_type'],roomImage: room['room_image'],roomCancelHour: room['rooom_cancle_hour'],roomOrgCode: room['room_orgcode'],roomPercent: room['room_percent']);
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
            ToastUtil.showShortClearToast("已加载到底哦！");
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
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title:Text( '共享会议室',   style: new TextStyle(
            fontSize: 17.0, color: Colors.white),),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.color,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);}),
      ),
      body: ListView.separated(
        separatorBuilder: (context,index){
          return Container(
            child: Divider(
              height: 0,
            ),
          );
        },
        itemBuilder: (_, int index) => index==roomLists.length?ListTile(title: Text('加载中'),):roomListWidget(roomLists[index]),
        itemCount: isPerformingRequest==true?roomLists.length:roomLists.length+1,
        controller: _scrollController,
      ),
    );
  }
  Widget roomListWidget(RoomInfo room){
    return   Container(
        width: MediaQuery.of(context).size.width,
        height: 188,
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
                  height: 132,
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
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.blue[200],
                    ),
                    child: Text('开放时间：${room.roomOpenTime}-${room.roomCloseTime}',style: TextStyle(fontSize: 12.0,color: Colors.blue[700]),),
                  ),
                  top: 88,
                  left:120,
                ),
                Positioned(
                  child:  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.orange[200],
                    ),
                    child: room.roomType==1?Text('容纳约1-10人',style: TextStyle(fontSize: 12.0,color: Colors.orange[700]),):room.roomType==2?Text('容纳约10-20人',style: TextStyle(fontSize: 12.0,color: Colors.orange[700]),):Text('容纳约30人以上',style: TextStyle(fontSize: 12.0,color: Colors.orange[700]),)
                  ),
                  top: 88,
                  left: 246,
                ),
                Positioned(
                  child: RichText(
                    text: TextSpan(
                      text: '¥',
                      style: TextStyle(fontSize: 14.0,color: Colors.red),
                      children: <TextSpan>[
                        TextSpan(
                          text: '${room.roomPrice}',
                          style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold,color: Colors.red),
                        ),
                        TextSpan(
                          text: '/小时',
                          style: TextStyle(fontSize: 16.0,color: Colors.black87),
                        )
                      ],
                    ),
                  ),
                  top: 115,
                  left: 120,
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
