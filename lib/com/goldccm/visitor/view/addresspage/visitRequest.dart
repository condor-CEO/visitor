import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/model/ChatMessage.dart';
import 'package:visitor/com/goldccm/visitor/util/MessageUtils.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class VisitRequest extends StatefulWidget{
  final int id;
  final int sendId;
  final String startDate;
  final String endDate;
  final String companyName;
  final String visitor;
  final String inviter;
  final int isAccept;
  final String recordType;
  final String answerContent;
  VisitRequest({Key key,this.id,this.sendId,this.startDate,this.endDate,this.companyName,this.visitor,this.inviter,this.isAccept,this.recordType,this.answerContent});
  @override
  State<StatefulWidget> createState() {
    return VisitRequestState();
  }
}
class VisitRequestState extends State<VisitRequest>{
  int _isAccept=0;
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
  void initState() {
    super.initState();
    if(widget.isAccept!=0) {
      _isAccept = widget.isAccept;
    }
  }
  @override
  Widget build(BuildContext context) {
    return  switchType();
  }

  Widget switchType(){
    if(widget.recordType=="1"){
      return Scaffold(
        appBar: AppBar(
          title: Text('访问审核'),
          centerTitle:true,
          backgroundColor: Theme.of(context).appBarTheme.color,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context,_isAccept);}),
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(30),
              child: Text('${widget.visitor}希望在以下地点以下时间对您进行访问，请您审核',),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                title: Text('访问地址'),
                subtitle: Text(widget.companyName!=null?widget.companyName:"地址未获取到"),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                title: Text('访问开始时间'),
                subtitle: Text(widget.startDate),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                title: Text('访问结束时间'),
                subtitle: Text(widget.endDate),
              ),
            ),
          ],
        ),
        bottomSheet: _isAccept==-2?Container(height:50,child: Text("审核中",style: TextStyle(fontSize: 24,color: Colors.green)),alignment: Alignment.center,):_isAccept==0?Container(
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
                    child: new Text('同意访问'),
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
                    child: new Text('拒绝访问'),
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
        ):_isAccept==1?Container(height:50,child: Text("已通过",style: TextStyle(fontSize: 24,color: Colors.green)),alignment: Alignment.center,):Container(height:50,child: Text("已拒绝",style: TextStyle(fontSize: 24,color: Colors.red),),alignment: Alignment.center),
      );
    }
    else{
      return Scaffold(
        appBar: AppBar(
          title: Text('邀约审核'),
          centerTitle:true,
          backgroundColor: Theme.of(context).appBarTheme.color,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context,_isAccept);}),
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(30),
              child: Text('${widget.visitor}邀请您在以下地点以下时间进行访问洽谈，请您审核',),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                title: Text('洽谈地址'),
                subtitle: Text(widget.companyName!=null?widget.companyName:""),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                title: Text('洽谈开始时间'),
                subtitle: Text(widget.startDate),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                title: Text('洽谈结束时间'),
                subtitle: Text(widget.endDate),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                title: Text('理由'),
                subtitle: Text(""),
              ),
            ),
          ],
        ),
        bottomSheet: _isAccept==-2?Container(height:50,child: Text("审核中",style: TextStyle(fontSize: 24,color: Colors.green)),alignment: Alignment.center,):_isAccept==0?Container(
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
        ):_isAccept==1?Container(height:50,child: Text("已接受",style: TextStyle(fontSize: 24,color: Colors.green)),alignment: Alignment.center,):Container(height:50,child: Text("已拒绝",style: TextStyle(fontSize: 24,color: Colors.red),),alignment: Alignment.center),
      );
    }
  }
}