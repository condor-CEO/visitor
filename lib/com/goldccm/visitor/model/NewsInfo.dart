import 'package:meta/meta.dart';
import 'dart:convert';

class NewsInfo{
   String id;
   String newsDate;//日期
   String newsName;//标题
   String newsDetail ;//简单描述
   String newsImageUrl;//图片
   String newsUrl;//跳转URL
   String newsStatus;//normarl:正常  disable:禁止

  NewsInfo({
     this.id,
     this.newsDate,
     this.newsName,
     this.newsDetail,
     this.newsImageUrl,
     this.newsUrl,
     this.newsStatus,
});

  NewsInfo.fromJson(Map json){
     this.id=json['id'];
     this.newsDate=json['newsDate'];
     this.newsName=json['newsName'];
     this.newsDetail=json['newsDetail'];
     this.newsImageUrl=json['newsImageUrl'];
     this.newsUrl=json['newsUrl'];
     this.newsStatus=json['newsStatus'];
   }
}