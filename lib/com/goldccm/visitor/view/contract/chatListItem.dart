import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/component/MessageCompent.dart';
import 'package:visitor/com/goldccm/visitor/model/ChatMessage.dart';
import 'package:visitor/com/goldccm/visitor/db/chatDao.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';



class ChatList extends StatefulWidget{
  WebSocketChannel channel;
  var backendData ;
  ChatList({this.channel});

  @override
  State<StatefulWidget> createState() {
    return new ChatListState();
  }
}


class ChatListState extends State<ChatList> {

  List<ChatMessage> _chatHis = [];

  @override
  void initState() {
    super.initState();
//    getMessageList();
//    widget.channel.stream.listen(this.onData, onError: onError, onDone: onDone);
    // ignore: unnecessary_statements
    (() async {
      setState(() {
          //新增数据库记录
        //更新_chatHis列表
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: new Text(
          "访客",
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontSize: 17.0, color: Colors.white, fontFamily: '楷体_GB2312'),
        ),
      ),
      body: new ListView.builder(
        itemCount: _chatHis.length,
        itemBuilder: buildMessageListItem,
      ),
    );
  }

  Widget buildMessageListItem(BuildContext context, int index) {
    ChatMessage message = _chatHis[index];
    return new InkWell(
      onTap: () {
        showDialog(
            context: context,
            child: new AlertDialog(
              content: new Text(
                "敬请期待",
                style: new TextStyle(fontSize: 20.0),
              ),
            ));
      },
      child: MessageCompent(headImgUrl: message.M_FheadImgUrl,
        realName: message.M_FrealName,
        latestTime: message.M_Time,
        latestMsg: message.M_MessageContent,
        isSend: message.M_IsSend,unreadCount: message.unreadCount,),
    );
  }

  onDone(){
    debugPrint("Socket is closed");
    widget.channel=IOWebSocketChannel.connect('ws://192.168.10.154:8080/api_visitor/chat?token=27');
  }

  onError(err){
    debugPrint(err.runtimeType.toString());
    WebSocketChannelException ex = err;
    debugPrint(ex.message);
  }

  onData(event) {
    setState(() {
      widget.backendData = event;
      ChatMessage mess = ChatMessage.fromJson(widget.backendData);
      ChatDao  chatDao = new ChatDao();
      chatDao.insertNewMessage(mess);
      _chatHis.clear();
      getMessageList();
    });
  }


  getMessageList() async{
    ChatDao  chatDao = new ChatDao();
    List<ChatMessage> list = await chatDao.getlatestMessage();
    if(list!=null) {
      setState(() {
        print('获取到几条信息：${list.length}');
        print('获取到几条信息：${list[0].toString()}');
        _chatHis = list;
      });
    }
  }

}