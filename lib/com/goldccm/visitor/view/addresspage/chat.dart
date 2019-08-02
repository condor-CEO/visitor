import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitor/com/goldccm/visitor/model/ChatMessage.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/UserModel.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/MessageUtils.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/addresspage.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class ChatPage extends StatefulWidget {
  final WebSocketChannel channel;
  final User user;

  ChatPage({Key key, this.channel, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChatPageState();
  }
}

class ChatPageState extends State<ChatPage> {
   List<chatMessage> _message = <chatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  WebSocketChannel _channel = MessageUtils.getChannel();
  var _messageBuilderFuture;
  bool _isComposing = false;
  UserInfo _userInfo;
  Timer _timer;
  static String visitStartDate = "开始时间";
  static String visitEndDate = "结束时间";
  static DateTime startDate;
  static DateTime endDate;
  static String inviteStartDate = "开始时间";
  static String inviteEndDate = "结束时间";
  static DateTime IstartDate;
  static DateTime IendDate;

  countDown() {
    const oneCall = const Duration(milliseconds: 1000);
    var callback = (timer) => {getUnreadMessage()};
    _timer = Timer.periodic(oneCall, callback);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  getUnreadMessage() async {
    if (widget.user.userId != null) {
      List<ChatMessage> msgLists = await MessageUtils.getUnreadMessageList(widget.user.userId);
      if (msgLists != null) {
        for (ChatMessage msg in msgLists) {
          print(msg);
          if (msg.M_MessageType == "1") {
            chatMessage message = new chatMessage(
              text: msg.M_MessageContent,
              type: msg.M_IsSend,
            );
            setState(() {
              _message.insert(0, message);
            });
          }
          if (msg.M_MessageType == "2") {
            chatMessage message = new chatMessage(
              type:   msg.M_IsSend=="0"?"2":"3",
              status: msg.M_cStatus,
              startDate: msg.M_StartDate,
              endDate: msg.M_EndDate,
              companyName: widget.user.companyName,
              visitor: _userInfo.realName,
              inviter: widget.user.userName,
            );
            setState(() {
              _message.insert(0, message);
            });
          }
          if(msg.M_MessageType == "3"){
            chatMessage message = new chatMessage(
              type:  "4",
              status: msg.M_cStatus,
              startDate: msg.M_StartDate,
              endDate: msg.M_EndDate,
              companyName: widget.user.companyName,
              visitor: widget.user.userName,
              inviter: _userInfo.realName,
              id: msg.M_visitId,
              sendId: widget.user.userId,
              isAccept:msg.M_cStatus=="applying"?0:msg.M_cStatus=="applySuccess"?1:-1,
            );
            _timer?.cancel();
            _timer = null;
            _messageBuilderFuture=null;
             reInit();
          }
        }
        int count = await MessageUtils.updateMessageStatus(widget.user.userId);
        if (count > 0) {
          print('已读最新信息$count条');
        }
        setState(() {

        });
      }
    }
  }

  @override
  initState() {
    super.initState();
    countDown();
    _messageBuilderFuture = getMessage();
  }
  reInit(){
    countDown();
    _messageBuilderFuture = getMessage();
  }

  getMessage() async {
    _message.clear();
    if (widget.user.userId != null) {
      List<ChatMessage> msgLists = await MessageUtils.getMessageList(widget.user.userId);
      if (msgLists != null) {
        for (ChatMessage msg in msgLists) {
          if (msg.M_MessageType == "1") {
            chatMessage message = new chatMessage(
              text: msg.M_MessageContent,
              type: msg.M_IsSend,
            );
            _message.insert(0, message);
          }
          if (msg.M_MessageType == "2") {
            chatMessage message = new chatMessage(
              type:   msg.M_IsSend=="0"?"2":"3",
              status: msg.M_cStatus,
              startDate: msg.M_StartDate,
              endDate: msg.M_EndDate,
              companyName: msg.M_companyName,
              visitor: _userInfo.realName,
              inviter: widget.user.userName,
            );
             _message.insert(0, message);
          }
          if(msg.M_MessageType == "3"){
            chatMessage message = new chatMessage(
              type:  "4",
              status: msg.M_cStatus,
              startDate: msg.M_StartDate,
              endDate: msg.M_EndDate,
              companyName: widget.user.companyName,
              visitor: widget.user.userName,
              inviter:  _userInfo.realName,
              id: msg.M_visitId,
              sendId: widget.user.userId,
              isAccept:msg.M_cStatus=="applying"?0:msg.M_cStatus=="applySuccess"?1:-1,
            );
              _message.insert(0, message);
          }

        }
        int count = await MessageUtils.updateMessageStatus(widget.user.userId);
        if (count > 0) {
          print('已读全部信息$count条');
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_userInfo == null) {
      var user = Provider.of<UserModel>(context);
      _userInfo = user.info;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('与${widget.user.userName}洽谈'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  child: new SizedBox(
                    height: 40.0,
                    child: new RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: new Text('邀约'),
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                              title: Text('访问时间'),
                              content: StatefulBuilder(
                                  builder: (context, StateSetter setState) {
                                    return Container(
                                        height: 100,
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.date_range),
                                                Container(
                                                    width: 200,
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: OutlineButton(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey),
                                                      onPressed: () {
                                                        DatePicker
                                                            .showDateTimePicker(context, showTitleActions: true, onConfirm: (date) {
                                                          if (IendDate == null ||date.compareTo(IendDate) == -1) {
                                                            setState(() {
                                                              IstartDate = date;
                                                              inviteStartDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
                                                            });
                                                          }
                                                        },currentTime: DateTime.now(), locale: LocaleType.zh);
                                                      },
                                                      child: Text(
                                                        inviteStartDate,
                                                        style: TextStyle(color: Colors.blue),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.date_range),
                                                Container(
                                                    width: 200,
                                                    padding: EdgeInsets.only(left: 10),
                                                    child: OutlineButton(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey),
                                                      onPressed: () {
                                                        DatePicker.showDateTimePicker(context, showTitleActions: true, onConfirm: (date) {
                                                          if (IstartDate == null ||date.compareTo(IstartDate) == 1) {
                                                            setState(() {
                                                              IendDate = date;
                                                              inviteEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
                                                            });
                                                          }
                                                        }, currentTime: DateTime.now(), locale: LocaleType.zh);
                                                      },
                                                      child: Text(inviteEndDate, style: TextStyle(color: Colors.blue),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ));
                                  }),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text("取消",
                                      style: TextStyle(color: Colors.red)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                new FlatButton(
                                  child: new Text("确定",
                                      style: TextStyle(color: Colors.blue)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _handleInvite();
                                  },
                                ),
                              ],
                            ));
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: new SizedBox(
                    height: 40.0,
                    child: new RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: new Text('访问'),
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                                  title: Text('访问时间'),
                                  content: StatefulBuilder(
                                      builder: (context, StateSetter setState) {
                                    return Container(
                                        height: 100,
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.date_range),
                                                Container(
                                                    width: 200,
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: OutlineButton(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey),
                                                      onPressed: () {
                                                        DatePicker
                                                            .showDateTimePicker(context, showTitleActions: true, onConfirm: (date) {
                                                          if (endDate == null ||date.compareTo(endDate) == -1) {
                                                            setState(() {
                                                              startDate = date;
                                                              visitStartDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
                                                            });
                                                          }
                                                        },currentTime: DateTime.now(), locale: LocaleType.zh);
                                                      },
                                                      child: Text(
                                                        visitStartDate,
                                                        style: TextStyle(color: Colors.blue),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.date_range),
                                                Container(
                                                    width: 200,
                                                    padding: EdgeInsets.only(left: 10),
                                                    child: OutlineButton(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey),
                                                      onPressed: () {
                                                        DatePicker.showDateTimePicker(context, showTitleActions: true, onConfirm: (date) {
                                                          if (startDate == null ||date.compareTo(startDate) == 1) {
                                                            setState(() {
                                                              endDate = date;
                                                              visitEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
                                                            });
                                                          }
                                                        }, currentTime: DateTime.now(), locale: LocaleType.zh);
                                                      },
                                                      child: Text(visitEndDate, style: TextStyle(color: Colors.blue),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ));
                                  }),
                                  actions: <Widget>[
                                    new FlatButton(
                                      child: new Text("取消",
                                          style: TextStyle(color: Colors.red)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    new FlatButton(
                                      child: new Text("确定",
                                          style: TextStyle(color: Colors.blue)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        _handleVisiting();
                                      },
                                    ),
                                  ],
                                ));
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: new SizedBox(
                    height: 40.0,
                    child: new RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: new Text('催审'),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  FutureBuilder(
                    builder: _messageFuture,
                    future: _messageBuilderFuture,
                  ),
                  Divider(
                    height: 1.0,
                  ),
                  Container(
                    decoration:
                        BoxDecoration(color: Theme.of(context).cardColor),
                    child: _buildTextComposer(),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _messageFuture(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('无连接');
        break;
      case ConnectionState.waiting:
        print("loading");
        return Text('加载中');
        break;
      case ConnectionState.active:
        return Text('active');
        break;
      case ConnectionState.done:
        print("done");
        if (snapshot.hasError) return Text('Error');
        return _buildMessageList();
        break;
      default:
        return null;
    }
  }

  Widget _buildMessageList() {
    return Flexible(
      child: ListView.builder(
        itemBuilder: (_, int index) => _message[index],
        padding: EdgeInsets.all(8),
        reverse: true,
        itemCount: _message.length,
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmmited,
              decoration: InputDecoration.collapsed(),
              onChanged: (String text) {
                _isComposing = text.length > 0;
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: _isComposing
                  ? () => _handleSubmmited(_textController.text)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

   void _handleInvite() {
     chatMessage message = new chatMessage(
       companyName: widget.user.companyName,
       startDate: visitStartDate,
       endDate: visitEndDate,
       status: "applying",
       visitor: widget.user.userName,
       inviter: _userInfo.realName,
       type: "2",
     );
     if (MessageUtils.isOpen()) {
       var object = {
         "toUserId": widget.user.userId,
         "startDate": inviteStartDate,
         "endDate": inviteEndDate,
         "cstatus": 'applying',
         "recordType": 2,
         "type": 2,
       };
       var send = jsonEncode(object);
       _channel.sink.add(send);
       //保存信息至本地数据库
       String time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
       ChatMessage chatMessage = new ChatMessage(
         M_cStatus: "applying",
         M_Time: time,
         M_userId: 27,
         M_FriendId: widget.user.userId,
         M_StartDate: inviteStartDate,
         M_EndDate: inviteEndDate,
         M_Status: "1",
         M_IsSend: "0",
         M_companyName: widget.user.companyName,
         M_MessageType: "2",
         M_ID: 2,
       );
       MessageUtils.insertSingleMessage(chatMessage);
       //插入到当前页面消息中
       setState(() {
         _message.insert(0, message);
         _isComposing = false;
       });
     } else {
       ToastUtil.showShortToast("与服务器断开连接");
     }
   }
  void _handleVisiting() {
    chatMessage message = new chatMessage(
      companyName: widget.user.companyName,
      startDate: visitStartDate,
      endDate: visitEndDate,
      status: "applying",
      visitor: _userInfo.realName,
      inviter: widget.user.userName,
      type: "2",
    );
    if (MessageUtils.isOpen()) {
      var object = {
        "toUserId": widget.user.userId,
        "startDate": visitStartDate,
        "endDate": visitEndDate,
        "cstatus": 'applying',
        "recordType": 1,
        "type": 2,
      };
      var send = jsonEncode(object);
      _channel.sink.add(send);
      //保存信息至本地数据库
      String time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      ChatMessage chatMessage = new ChatMessage(
        M_cStatus: "applying",
        M_Time: time,
        M_userId: 27,
        M_FriendId: widget.user.userId,
        M_StartDate: visitStartDate,
        M_EndDate: visitEndDate,
        M_Status: "1",
        M_IsSend: "0",
        M_companyName: widget.user.companyName,
        M_MessageType: "2",
        M_ID: 2,
      );
      MessageUtils.insertSingleMessage(chatMessage);
      //插入到当前页面消息中
      setState(() {
        _message.insert(0, message);
        _isComposing = false;
      });
    } else {
      ToastUtil.showShortToast("与服务器断开连接");
    }
  }

  void _handleSubmmited(String text) {
    _textController.clear();
    chatMessage message = new chatMessage(
      text: text,
      type: "0",
    );
    if (MessageUtils.isOpen()) {
      //向websocket服务器发送json消息体
      var object = {
        "toUserId": widget.user.userId,
        "message": text,
        "type": 1,
      };
      var send = jsonEncode(object);
      _channel.sink.add(send);
      //将这条消息保存至本地数据库
      String time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      ChatMessage chat = new ChatMessage(
          M_userId: 27,
          M_Status: "1",
          M_Time: time,
          M_IsSend: "0",
          M_MessageType: "1",
          M_FriendId: widget.user.userId,
          M_MessageContent: text,
          M_FrealName: widget.user.userName,
          M_FheadImgUrl: widget.user.idHandleImgUrl,
          M_ID: 1);
      MessageUtils.insertSingleMessage(chat);
      //插入到当前页面消息中
      setState(() {
        _message.insert(0, message);
        _isComposing = false;
      });
    } else {
      ToastUtil.showShortToast("与服务器断开连接");
    }
  }
  _responseToApply(int select,int id){
    //拒绝请求
    if(select == 0 ){
      print("拒绝");
      if (MessageUtils.isOpen()) {
        var object = {
          'toUserId': widget.user.userId,
          'cstatus':'applyFail',
          'id':id,
          'answerContent':'回复',
          'type': 3,
        };
        ChatMessage msg=new ChatMessage(
          M_visitId: id,
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
          'toUserId':  widget.user.userId,
          'cstatus':'applySuccess',
          'id':id,
          'answerContent':'回复',
          'type':3
        };
        ChatMessage msg=new ChatMessage(
          M_visitId: id,
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
}


class chatMessageState extends State<chatMessage>{
  int _isAccept = 0;
  @override
  void initState() {
    super.initState();
    _isAccept=widget.isAccept;
  }
  @override
  Widget build(BuildContext context) {
    return _switchMessage(context);
  }
  _switchMessage(context) {
    if (widget.type != null) {
      if (widget.type == "0") {
        return new Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
//                  Text('我',style: Theme.of(context).textTheme.subhead,),
                  Container(
                    alignment: Alignment.centerRight,
                    width: 250,
                    child: Container(
                      child: Text(widget.text,
                          softWrap: true,
                          style: TextStyle(fontSize: 17, color: Colors.white)),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 16.0),
                child: CircleAvatar(
                  child: Icon(Icons.more),
                ),
              ),
            ],
          ),
        );
      } else if (widget.type == "1") {
        return new Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  child: Icon(Icons.more),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
//                  Text('对方',style: Theme.of(context).textTheme.subhead,),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 250,
                    child: Container(
                      child: Text(widget.text,
                          softWrap: true,
                          style: TextStyle(fontSize: 17, color: Colors.white)),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      } else if (widget.type == "2") {
        return Card(
            margin:  EdgeInsets.fromLTRB(10, 10, 100, 10),
            child: Container(
              height: 200,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('开始时间',style: TextStyle(fontWeight: FontWeight.w500,)),
                        Text(widget.startDate,style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('结束',style: TextStyle(fontWeight: FontWeight.w500,)),
                        Text(widget.endDate,style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('申请人',style: TextStyle(fontWeight: FontWeight.w500,)),
                        Text(widget.visitor,style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical:0,horizontal: 10),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('审批者',style: TextStyle(fontWeight: FontWeight.w500,)),
                        Text(widget.inviter,style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                  Container(
                    child: widget.status=="applying"?Text('您已提交申请',style: TextStyle(color: Colors.red,fontSize: 20),):Text('您的申请已通过',style: TextStyle(color:Colors.green,fontSize: 20),),
                  )
                ],
              ),
            )
        );
      }
      else if (widget.type == "3") {
        return Card(
            margin:  EdgeInsets.fromLTRB(100, 10, 10, 10),
            child: Container(
              height: 200,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('开始时间',style: TextStyle(fontWeight: FontWeight.w500,)),
                        Text(widget.startDate,style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('结束',style: TextStyle(fontWeight: FontWeight.w500,)),
                        Text(widget.endDate,style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('申请人',style: TextStyle(fontWeight: FontWeight.w500,)),
                        Text(widget.visitor,style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical:0,horizontal: 10),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('审批者',style: TextStyle(fontWeight: FontWeight.w500,)),
                        Text(widget.inviter,style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                  Container(
                    child: widget.status=="applying"?Text('您已提交申请',style: TextStyle(color: Colors.blue,fontSize: 20),):widget.status=="applySuccess"?Text('您的申请已通过',style: TextStyle(color:Colors.green,fontSize: 20),):Text('您的申请已被拒绝',style: TextStyle(color:Colors.red,fontSize: 20),),
                  )
                ],
              ),
            )
        );
      }
      else if(widget.type=="4"){
        return Card(
            margin:  EdgeInsets.fromLTRB(10, 10, 100, 10),
            child: Container(
              height: 210,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('开始时间',style: TextStyle(fontWeight: FontWeight.w500,)),
                        Text(widget.startDate,style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('结束',style: TextStyle(fontWeight: FontWeight.w500,)),
                        Text(widget.endDate,style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('申请人',style: TextStyle(fontWeight: FontWeight.w500,)),
                        Text(widget.visitor,style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical:0,horizontal: 10),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('审批者',style: TextStyle(fontWeight: FontWeight.w500,)),
                        Text(widget.inviter,style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                  _isAccept!=0?Container(
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _isAccept==1?Text('已通过',style: TextStyle(color: Colors.green,fontSize: 20)):Text('已拒绝',style: TextStyle(color: Colors.red,fontSize: 20))
                        ],
                      )
                  ):Container(
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new FlatButton(
                            child: new Text("拒绝", style: TextStyle(color: Colors.red,fontSize: 18)),
                            onPressed: () {
                              _responseToApply(0);
                              setState(() {
                                _isAccept=-1;
                              });
                            },
                          ),
                          new FlatButton(
                            child: new Text("通过", style: TextStyle(color: Colors.green,fontSize: 18)),
                            onPressed: () {
                              _responseToApply(1);
                              setState(() {
                                _isAccept=1;
                              });
                            },
                          ),
                        ],
                      )
                  )
                ],
              ),
            )
        );
      }
    }
  }
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
}

class chatMessage extends StatefulWidget {
  final String text;
  final String type;
  final String companyName;
  final String visitor;
  final String inviter;
  final String status;
  final String startDate;
  final String endDate;
  final int sendId;
  final int id;
  final int isAccept;
  @override
  State<StatefulWidget> createState() {
    return chatMessageState();
  }
  chatMessage(
      {this.text,
        this.type,
        this.visitor,
        this.inviter,
        this.companyName,
        this.startDate,
        this.endDate,
        this.status,
        this.id,
        this.sendId,
        this.isAccept,
      });
}
