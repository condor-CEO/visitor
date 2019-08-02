import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visitor/com/goldccm/visitor/db/chatDao.dart';
import 'package:visitor/com/goldccm/visitor/model/ChatMessage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//websocket 管理websocket消息监听类

class MessageUtils {
  static WebSocketChannel _channel;
  static bool _isOpen = false;
  static setChannel(String id) {
    if (_channel == null) {
      debugPrint('Websocket连接');
      _channel = IOWebSocketChannel.connect(
          'ws://192.168.10.154:8080/api_visitor/chat?token=27');
      _connect();
    }
  }

  static isOpen() {
    return _isOpen;
  }

  static _connect() {
    _channel.stream.listen(_onData, onError: _onError, onDone: _onDone);
    _isOpen = true;
  }

  static _onDone() {
    debugPrint("Websocket关闭");
    _isOpen = false;
    _channel = null;
  }

  static _onError(err) {
    debugPrint(err.runtimeType.toString());
    WebSocketChannelException ex = err;
    debugPrint(ex.message);
  }

  static _onData(event) {
    print(event);
    if (event == "0") {
      return;
    }
    if (event == "1") {
      return;
    }
    if (event == "2") {
      return;
    }
    Map map = jsonDecode(event);
    ChatMessage msg;
    ChatDao chatDao = new ChatDao();
    if (map['type'] == 1) {
      msg = new ChatMessage(
        M_ID: 1,
        M_FriendId: int.parse(map['fromUserId'].toString()),
        M_Status: "0",
        M_IsSend: "1",
        M_MessageContent: map['message'].toString(),
        M_Time: map['update_time'].toString(),
        M_MessageType: map['type'].toString(),
        M_userId: int.parse(map['toUserId'].toString()),
      );
      chatDao.insertNewMessage(msg);
    } else if (map['type'] == 2) {
      msg = new ChatMessage(
        M_ID: 2,
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
        M_companyName: "test",
      );
      chatDao.insertNewMessage(msg);
    } else if (map['type'] == 3) {
      msg = new ChatMessage(
        M_ID: 3,
        M_FriendId: int.parse(map['fromUserId'].toString()),
        M_userId: int.parse(map['userId'].toString()),
        M_Status: "0",
        M_IsSend: "1",
        M_Time: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        M_cStatus: map['cstatus'].toString(),
        M_visitId: int.parse(map['id'].toString()),
        M_StartDate: map['startDate'].toString(),
        M_EndDate: map['endDate'].toString(),
        M_companyName: "test",
        M_MessageType: "2",
      );
      chatDao.insertNewMessage(msg);
    }
    if (msg == null) {
      debugPrint('插入数据库失败');
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

  static getUnreadMessageList(int id) async {
    ChatDao chatDao = new ChatDao();
    List<ChatMessage> list = await chatDao.getUnreadMessageListByUserId(id);
    return list;
  }

  static updateMessageStatus(int id) async {
    ChatDao chatDao = new ChatDao();
    int count = await chatDao.updateMessageStatus(id);
    return count;
  }
  static updateInviteMessage(ChatMessage msg) async {
    ChatDao chatDao = new ChatDao();
    int count = await chatDao.updateMessage(msg);
    return count;
  }
  static getChannel() {
    return _channel;
  }
}
