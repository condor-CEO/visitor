import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/model/ChatMessage.dart';
import 'package:visitor/com/goldccm/visitor/util/MessageUtils.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class InviteRequest extends StatefulWidget{
  final int id;
  final int sendId;
  final String startDate;
  final String endDate;
  final String companyName;
  final String visitor;
  final String inviter;
  final int isAccept;
  InviteRequest({Key key,this.id,this.sendId,this.startDate,this.endDate,this.companyName,this.visitor,this.inviter,this.isAccept});
  @override
  State<StatefulWidget> createState() {
    return InviteRequestState();
  }
}
class InviteRequestState extends State<InviteRequest>{
   static int _isAccept;
  _responseToApply(int select){
    //拒绝请求
    if(select == 0 ){
      print("拒绝");
      if (MessageUtils.isOpen()) {
        var object = {
          'toUserId': widget.sendId,
          'cstatus':'applyFail',
          'id':widget.id,
          'answerContent':'回复',
          'type': 3,
        };
        ChatMessage msg=new ChatMessage(
          M_visitId: widget.id,
          M_cStatus: 'applyFail',
        );
        var send = jsonEncode(object);
        WebSocketChannel channel=MessageUtils.getChannel();
        channel.sink.add(send);
        //更新信息至本地数据库
        MessageUtils.updateInviteMessage(msg);
      } else {
        ToastUtil.showShortToast("与服务器断开连接");
      }
    }
    //通过请求
    if(select == 1){
      print("通过");
      if (MessageUtils.isOpen()) {
        var object = {
          'toUserId': widget.sendId,
          'cstatus':'applySuccess',
          'id':widget.id,
          'answerContent':'回复',
          'type':3
        };
        ChatMessage msg=new ChatMessage(
          M_visitId: widget.id,
          M_cStatus: 'applySuccess',
        );
        var send = jsonEncode(object);
        WebSocketChannel channel=MessageUtils.getChannel();
        channel.sink.add(send);
        //更新信息至本地数据库
        MessageUtils.updateInviteMessage(msg);
      } else {
        ToastUtil.showShortToast("与服务器断开连接");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('邀约审核'),
        centerTitle:true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(30),
            child: Text('某某希望在以下地点以下时间对您进行访问，请您审核'),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
             child: ListTile(
               title: Text('访问地址'),
               subtitle: Text('华林星座'),
             ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
              title: Text('访问地址'),
              subtitle: Text('华林星座'),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
              title: Text('访问地址'),
              subtitle: Text('华林星座'),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: new SizedBox(
                width: 170.0,
                height: 50.0,
                child: new FlatButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  child: new Text('同意受邀'),
                  onPressed: () async {
                    _responseToApply(1);
                    setState(() {
                      _isAccept=1;
                    });
                  },
                ),
              ),
            ),
            Container(
              child: new SizedBox(
                width: 170.0,
                height: 50.0,
                child: new FlatButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  child: new Text('拒绝受邀'),
                  onPressed: () async {
                    _responseToApply(0);
                    setState(() {
                      _isAccept=-1;
                    });
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