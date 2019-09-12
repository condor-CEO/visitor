import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/RoomOrderInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/CommonUtil.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/minepage.dart';
import 'package:visitor/com/goldccm/visitor/view/shareroom/roomCancel.dart';

import '../../../../../home.dart';

class RoomHistory extends StatefulWidget {
  final UserInfo userInfo;
  RoomHistory({Key key, this.userInfo}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return RoomHistoryState();
  }
}

class RoomHistoryState extends State<RoomHistory> {
  int count = 1;
  List<RoomOrderInfo> _roomLists = <RoomOrderInfo>[];
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  bool notEmpty=true;
  var _roomBuilderFuture;
  @override
  void initState() {
    super.initState();
    _roomBuilderFuture = getHistory();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
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
      Future.delayed(Duration(seconds: 1), () async {
        setState(() => isPerformingRequest = true);
        String url = Constant.serverUrl + "meeting/myReserveList/$count/10";
        String threshold = await CommonUtil.calWorkKey();
        var res = await Http().post(url,
            queryParameters: ({
              "token": widget.userInfo.token,
              "factor": CommonUtil.getCurrentTime(),
              "threshold": threshold,
              "requestVer": CommonUtil.getAppVersion(),
              "userId": widget.userInfo.id,
            }));
        if (res is String) {
          Map map = jsonDecode(res);
            for (var data in map['data']['rows']) {
              RoomOrderInfo roomOrderInfo = new RoomOrderInfo(
                  id: data['id'],
                  roomID: data['room_id'],
                  applyUserID: data['apply_userid'],
                  applyDate: data['apply_date'],
                  applyStartTime: data['apply_start_time'].toString(),
                  applyEndTime: data['apply_end_time'].toString(),
                  timeInterval: data['time_interval'],
                  recordStatus: data['record_status'],
                  createTime: data['create_time'],
                  cancelTime: data['cancle_time'],
                  roomName: data['room_name'],
                  roomAddress: data['room_addr'],
                  roomIntro: data['room_short_content'],
                  roomImage: data['room_image'],
                  roomType: data['room_type']);
              _roomLists.add(roomOrderInfo);
            }
            setState(() {
              count++;
              isPerformingRequest = false;
            });
            if (map['data']['rows'].length == 0) {
              setState(() {
                count--;
                isPerformingRequest = true;
              });
            }
          }
      });
    } else {
      ToastUtil.showShortToast("已加载到底哦！");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('会议室记录'),
          centerTitle: true,
          backgroundColor: Theme.of(context).appBarTheme.color,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                beforeDispose();
              }),
        ),
        body: notEmpty==true?FutureBuilder(
          builder: _roomFuture,
          future: _roomBuilderFuture,
        ):Column(
          children: <Widget>[
            Container(
              child: Center(
                  child: Image.asset('asset/images/visitor_icon_nodata.png')),
              padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
            ),
            Center(child: Text('您还没有会议室订单记录'))
          ],
        ),
      ),
      onWillPop: (){
        beforeDispose();
      },
    );
  }
  beforeDispose(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomeApp(tabIndex: 3,)));
  }
  getHistory() async {
    String url = Constant.serverUrl + "meeting/myReserveList/$count/10";
    String threshold = await CommonUtil.calWorkKey();
    var res = await Http().post(url,
        queryParameters: ({
          "token": widget.userInfo.token,
          "factor": CommonUtil.getCurrentTime(),
          "threshold": threshold,
          "requestVer": CommonUtil.getAppVersion(),
          "userId": widget.userInfo.id,
        }));
    if (res is String) {
      Map map = jsonDecode(res);
      if(map['verify']['sign']=="success") {
        if (map['data']['total'] ==0) {
          setState(() {
            isPerformingRequest = true;
            notEmpty = false;
          });
        } else {
          if(map['data']['total']<10){
            setState(() {
              isPerformingRequest = true;
            });
          }
          for (var data in map['data']['rows']) {
            RoomOrderInfo roomOrderInfo = new RoomOrderInfo(
                id: data['id'],
                roomID: data['room_id'],
                applyUserID: data['apply_userid'],
                applyDate: data['apply_date'],
                applyStartTime: data['apply_start_time'].toString(),
                applyEndTime: data['apply_end_time'].toString(),
                timeInterval: data['time_interval'],
                recordStatus: data['record_status'],
                createTime: data['create_time'],
                cancelTime: data['cancle_time'],
                roomName: data['room_name'],
                roomAddress: data['room_addr'],
                roomIntro: data['room_short_content'],
                roomImage: data['room_image'],
                roomType: data['room_type'],
                price: data['price'].toString());
            _roomLists.add(roomOrderInfo);
          }
          setState(() {
            count++;
          });
        }
      }else{
        ToastUtil.showShortClearToast(map['verify']['desc']);
      }
    }
  }

  Widget _roomFuture(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('无连接');
        break;
      case ConnectionState.waiting:
        return Stack(
          children: <Widget>[
            Opacity(
                opacity: 0.1,
                child: ModalBarrier(
                  color: Colors.black,
                )
            ),
            Center(
              child:Container(
                padding: const EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  //黑色背景
                    color: Colors.black87,
                    //圆角边框
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  //控件里面内容主轴负轴剧中显示
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //主轴高度最小
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text(
                      '加载中',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
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

  _buildRoomList() {
    return ListView.separated(
      itemCount: isPerformingRequest == true
          ? _roomLists.length
          : _roomLists.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == _roomLists.length) {
          return ListTile(
            title: Text('加载中'),
          );
        } else {
          return ListTile(
            title: Text(_roomLists[index].roomName.toString()),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_roomLists[index].roomAddress),
                Text(_roomLists[index].recordStatus == 1
                    ? _roomLists[index].applyDate +
                        " " +
                        _roomLists[index]
                            .applyStartTime
                            .replaceAll("\.5", ":30")
                            .replaceAll("\.0", ":00") +
                        "-" +
                        _roomLists[index]
                            .applyEndTime
                            .replaceAll("\.5", ":30")
                            .replaceAll("\.0", ":00")
                    : '预定已取消'),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RoomBook(
                            order: _roomLists[index],
                            userInfo: widget.userInfo,
                          )));
            },
          );
        }
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          child: Divider(
            height: 0,
          ),
        );
      },
      padding: EdgeInsets.all(8),
      controller: _scrollController,
    );
  }
}
