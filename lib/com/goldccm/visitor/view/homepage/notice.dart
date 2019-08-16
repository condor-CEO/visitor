import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/NoticeInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';

class NoticePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoticePageState();
  }
}

class NoticePageState extends State<NoticePage> {
  var _noticeBuilderFuture;
  List<Notice> _lists = <Notice>[];
  @override
  void initState() {
    super.initState();
    _noticeBuilderFuture = getNotice();
  }

  getNotice() async {
    String url = "http://192.168.10.154:8080/api_visitor/notice/allList/1/20";
    UserInfo userInfo = await DataUtils.getUserInfo();
    var res = await Http().post(url, queryParameters: {
      'userId': 27,
    });
    if (res is String) {
      Map map = jsonDecode(res);
      for (var info in map['data']['rows']) {
        Notice notice = new Notice(
          noticeTitle: info['noticeTitle'],
          content: info['content'],
          createDate: info['createDate'],
          createTime: info['createTime'],
          orgType: info['orgType'],
        );
        _lists.insert(0, notice);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('公告栏'),
      ),
      body: FutureBuilder(
        builder: noticeFuture,
        future: _noticeBuilderFuture,
      ),
    );
  }

  Widget noticeFuture(BuildContext context, AsyncSnapshot snapshot) {
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
        if (snapshot.hasError) return Text('Error');
        return _buildNoticeList();
        break;
      default:
        return null;
    }
  }

  Widget _buildNoticeList() {
    return ListView.builder(
      itemBuilder: (_, int index) => _lists[index],
      padding: EdgeInsets.all(8),
      itemCount: _lists.length,
    );
  }
}

class Notice extends StatelessWidget {
  final String noticeTitle;
  final String content;
  final String createDate;
  final String createTime;
  final String orgType;
  Notice(
      {this.noticeTitle,
      this.content,
      this.createTime,
      this.createDate,
      this.orgType});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
          title: Text('公告'),
          subtitle: Text(
            content != null ? content : "",
            maxLines: 5,
            softWrap: true,
          )),
    );
  }
}
