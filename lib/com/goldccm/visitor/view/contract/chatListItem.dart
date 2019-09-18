import 'dart:async';
import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/component/MessageCompent.dart';
import 'package:visitor/com/goldccm/visitor/model/ChatMessage.dart';
import 'package:visitor/com/goldccm/visitor/db/chatDao.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';
import 'package:visitor/com/goldccm/visitor/util/MessageUtils.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/addresspage.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/chat.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new ChatListState();
  }
}

class ChatListState extends State<ChatList> {
  WebSocketChannel channel=MessageUtils.getChannel();
  List<ChatMessage> _chatHis = [];
  Timer _timer;
  countDown() {
    const oneCall = const Duration(milliseconds: 3000);
    var callback = (timer) => {getLatestMessage()};
    _timer = Timer.periodic(oneCall, callback);
  }
  getLatestMessage() async {
    List<ChatMessage> list=await MessageUtils.getLatestMessage();
    setState(() {
      _chatHis=list;
    });
  }
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    countDown();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        centerTitle: true,
        title: new Text(
          "访客",
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontSize: 18.0, color: Colors.white),
        ),
      ),
      body: new ListView.builder(
        itemCount: _chatHis!=null?_chatHis.length:0,
        itemBuilder: buildMessageListItem,
      ),
    );
  }

  Widget buildMessageListItem(BuildContext context, int index) {
    ChatMessage message = _chatHis[index];
    return new InkWell(
      onTap: () {
        User user =new User(userId: message.M_FriendId,userName: message.M_FrealName,idHandleImgUrl: message.M_FheadImgUrl,imageServerUrl: Constant.imageServerUrl,orgId:message.M_orgId.toString());
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(user:user)));
      },
      child: MessageCompent(
        headImgUrl: message.M_FheadImgUrl,
        realName: message.M_FrealName,
        latestTime: message.M_Time,
        latestMsg: message.M_MessageContent,
        isSend: message.M_IsSend,
        unreadCount: message.unreadCount,
        imageServerUrl: Constant.imageServerUrl,
      ),
    );
  }

}