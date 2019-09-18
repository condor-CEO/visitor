import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitor/com/goldccm/visitor/db/chatDao.dart';
import 'package:visitor/com/goldccm/visitor/model/ChatMessage.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

//websocket 管理websocket消息监听类

class MessageUtils {
  static WebSocketChannel _channel;
  static bool _isOpen = false;
  static String userID;
  static String userToken;
  static int count=0;
  static setChannel(String id,String token) {
    if (_channel == null) {
      userID=id;
      userToken=token;
      debugPrint('userId${id}token${token}Websocket连接');
      _channel = IOWebSocketChannel.connect(
          Constant.webSocketServerUrl+'chat?userId=$id&token=$token');
      _connect();
    }
  }
  static reconnect(){
      if (_channel == null) {
        debugPrint('Websocket重新连接');
        _channel = IOWebSocketChannel.connect(
            Constant.webSocketServerUrl+'chat?token=$userID&token=$userToken');
        _connect();
        ToastUtil.showShortClearToast("重新连接成功");
      }else{
        ToastUtil.showShortToast("重连失败");
      }
  }
  static closeChannel(){
    if(_channel!=null){
      _channel.sink?.close();
    }
  }
  static isOpen() {
    return _isOpen;
  }

  static _connect() {
    _channel.stream.listen(_onData, onError: _onError, onDone: _onDone);
    _isOpen = true;
  }

  static _onDone() async {
    debugPrint("Websocket关闭");
    _channel=null;
    _isOpen = false;
  }

  static _onError(err) {
    debugPrint(err.runtimeType.toString());
    WebSocketChannelException ex = err;
    debugPrint(ex.message);
  }
  //接收数据
  //type=1是普通消息
  //type=2是接收好友发送的访问邀约消息
  //type=3是自己发送的访问邀约消息被通过或拒绝的回馈消息
  static _onData(event) async {
    print(event);
    Map map = jsonDecode(event);
    if(map['code']!=null){
      if(map['sign']=="fail"){
        ToastUtil.showShortClearToast(map['desc']);
        if(map['type']==2){
          await removeLastMessage();
        }
      }
    }else {
      print('接收到一条数据');
      ChatMessage msg;
      ChatDao chatDao = new ChatDao();
      if (map['type'] == 1) {
        msg = new ChatMessage(
          M_FriendId: int.parse(map['fromUserId'].toString()),
          M_Status: "0",
          M_IsSend: "1",
          M_MessageContent: map['message'].toString(),
          M_Time: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          M_MessageType: map['type'].toString(),
          M_userId: int.parse(map['toUserId'].toString()),
          M_FrealName: map['realName'].toString(),
          M_FheadImgUrl: map['headImgUrl'].toString(),
          M_FnickName: map['nickName'].toString(),
          M_orgId: map['orgId'],
        );
        chatDao.insertNewMessage(msg);
      } else if (map['type'] == 2) {
        msg = new ChatMessage(
          M_cStatus: map['cstatus'].toString(),
          M_Status: "0",
          M_IsSend: "1",
          M_MessageType: "3",
          M_userId: int.parse(map['toUserId'].toString()),
          M_FriendId: int.parse(map['fromUserId'].toString()),
          M_Time: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          M_StartDate: map['startDate'].toString(),
          M_visitId: int.parse(map['id'].toString()),
          M_EndDate: map['endDate'].toString(),
          M_companyName: map['companyName'].toString(),
          M_recordType: map['recordType'].toString(),
          M_answerContent: map['answerContent'].toString(),
        );
        chatDao.insertNewMessage(msg);
      } else if (map['type'] == 3) {
        msg = new ChatMessage(
          M_FriendId: int.parse(map['fromUserId'].toString()),
          M_userId: int.parse(map['userId'].toString()),
          M_Status: "0",
          M_IsSend: "1",
          M_Time: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          M_cStatus: map['cstatus'].toString(),
          M_visitId: int.parse(map['id'].toString()),
          M_StartDate: map['startDate'].toString(),
          M_EndDate: map['endDate'].toString(),
          M_companyName: map['companyName'].toString(),
          M_MessageType: "2",
          M_recordType: map['recordType'].toString(),
          M_answerContent: map['answerContent'].toString(),
        );
        chatDao.updateMessage(msg);
        chatDao.insertNewMessage(msg);
      } else {

      }
      if (msg == null) {
        debugPrint('插入数据库失败');
      }
    }
  }

  static getMessageList(int id) async {
    ChatDao chatDao = new ChatDao();
    List<ChatMessage> list = await chatDao.getMessageListByUserId(id);
    return list;
  }

  static insertSingleMessage(ChatMessage chatMsg) {
    ChatDao chatDao = new ChatDao();
    chatDao.insertNewMessage(chatMsg);
  }
  static getLatestMessage() async {
    ChatDao chatDao = new ChatDao();
    List<ChatMessage> list = await chatDao.getLatestMessage();
    return list;
  }
  static getUnreadMessageList(int id) async {
    ChatDao chatDao = new ChatDao();
    List<ChatMessage> list = await chatDao.getUnreadMessageListByUserId(id);
    return list;
  }
  static removeLastMessage() async {
    ChatDao chatDao = new ChatDao();
    int count= await chatDao.removeLastMessage();
    return count;
  }
  static updateMessageStatus(int id) async {
    ChatDao chatDao = new ChatDao();
    int count = await chatDao.updateMessageStatus(id);
    return count;
  }
  static updateInviteMessage(ChatMessage msg) async {
    ChatDao chatDao = new ChatDao();
    int count = await chatDao.updateMessageByVisitId(msg);
    return count;
  }
  static getChannel() {
    return _channel;
  }
}
