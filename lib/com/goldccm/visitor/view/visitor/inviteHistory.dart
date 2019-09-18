import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/VisitInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/CommonUtil.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';

class InviteHistory extends StatefulWidget{
  final UserInfo userInfo;
  InviteHistory({Key key,this.userInfo}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return InviteHistoryState();
  }
}
class InviteHistoryState extends State<InviteHistory>{
  int count = 1;
  List<VisitInfo> _inviteLists = <VisitInfo>[];
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  bool notEmpty=true;
  var _inviteBuilderFuture;
  @override
  void initState() {
    super.initState();
    _inviteBuilderFuture=_getMoreData();
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
  _buildInviteList(){
    return ListView.separated(
      itemCount: isPerformingRequest == true
          ? _inviteLists.length
          : _inviteLists.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == _inviteLists.length) {
          return ListTile(
            title: Text('加载中'),
          );
        } else {
          return ListTile(
            title: Text(_inviteLists[index].companyName!=null?_inviteLists[index].companyName:""),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_inviteLists[index].startDate!=null?_inviteLists[index].startDate:""),
                  Text(_inviteLists[index].endDate!=null?"至 ${_inviteLists[index].endDate}":""),
                ]
            ),
            trailing: Text(_inviteLists[index].cstatus!=null?(_inviteLists[index].cstatus=="applying"?"审核中":_inviteLists[index].cstatus=="applySuccess"?"已通过":"未通过"):""),
            onTap: () {

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
  _getMoreData() async {
    if (!isPerformingRequest) {
      Future.delayed(Duration(seconds: 1), () async {
        setState(() => isPerformingRequest = true);
        String url = Constant.serverUrl + "visitorRecord/inviteRecord/$count/10";
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
          if(map['verify']['sign']=="success"){
            if(map['data']['total']==0){
              setState(() {
                isPerformingRequest = true;
                notEmpty = false;
              });
            }else{
              for (var data in map['data']['rows']) {
                VisitInfo visitInfo = new VisitInfo(
                  companyName: data['realName'],
                  visitDate: data['visitDate'],
                  visitTime: data['visitTime'],
                  userId: data['userId'].toString(),
                  visitorId: data['visitorId'].toString(),
                  reason: data['reason'],
                  cstatus: data['cstatus'],
                  dateType: data['dateType'],
                  endDate: data['endDate'],
                  startDate: data['startDate'],
                );
                _inviteLists.add(visitInfo);
              }
              setState(() {
                count++;
                isPerformingRequest = false;
              });
              if (map['data']['rows'].length < 10) {
                setState(() {
                  count--;
                  isPerformingRequest = true;
                });
              }
            }
          }
        }
      });
    } else {
      ToastUtil.showShortToast("已加载到底哦！");
    }
  }
  Widget _inviteFuture(BuildContext context, AsyncSnapshot snapshot) {
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
        return _buildInviteList();
        break;
      default:
        return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('邀约记录'),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.color,
      ),
      body: notEmpty==true?FutureBuilder(
        builder: _inviteFuture,
        future: _inviteBuilderFuture,
      ):Column(
        children: <Widget>[
          Container(
            child: Center(
                child: Image.asset('asset/images/visitor_icon_nodata.png')),
            padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
          ),
          Center(child: Text('您还没有邀约记录'))
        ],
      ),
    );
  }
}