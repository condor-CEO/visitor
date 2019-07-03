import 'package:meta/meta.dart';
import 'dart:convert';

class NoticeInfo{
   num id;
   num  orgId;
   String relationNo;
   String noticeTitle;
   String content;
   String createDate;
   String createTime;
   String cstatus;

  NoticeInfo({
     this.id,
     this.orgId,
     this.relationNo,
     this.noticeTitle,
     this.content,
     this.createDate,
     this.createTime,
     this.cstatus,
});

   NoticeInfo.fromJson(Map json){
      this.id=json['id'];
      this.orgId=json['orgId'];
      this.relationNo=json['relationNo'];
      this.noticeTitle=json['noticeTitle'];
      this.content=json['content'];
      this.createDate=json['createDate'];
      this.createTime=json['createTime'];
      this.cstatus=json['cstatus'];
   }

   static List<NoticeInfo> getJsonFromDataList(var content){
      List<NoticeInfo> _noticeList =[];
      var mapData = content['rows'];
      mapData.forEach((obj){
         NoticeInfo noticeInfo = new NoticeInfo(
         id:obj['id'],
         orgId:obj['orgId'],
         relationNo:obj['relationNo'],
         noticeTitle:obj['noticeTitle'],
         content:obj['content'],
         createDate:obj['createDate'],
         createTime:obj['createTime'],
         cstatus:obj['cstatus'],

         );
         _noticeList.add(noticeInfo);
      });
return _noticeList;
   }
}