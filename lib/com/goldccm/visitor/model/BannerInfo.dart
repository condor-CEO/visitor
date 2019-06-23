import 'dart:convert';
import 'package:meta/meta.dart';

class BannerInfo{
   String id;
   String title;
   String imgUrl;
   String hrefUrl;
   int status;
   String createTime;
   int orders;
   String androidParams;


  BannerInfo({
     this.id,
     this.title,
     this.imgUrl,
     this.hrefUrl,
     this.status,
     this.createTime,
     this.orders,
     this.androidParams,
  });

   BannerInfo.fromJson(Map json){
     this.id=json['id'];
     this.title=json['title'];
     this.imgUrl=json['imgUrl'];
     this.hrefUrl=json['hrefUrl'];
     this.status=json['status'];
     this.createTime=json['createTime'];
     this.orders=json['orders'];
     this.androidParams=json['androidParams'];
   }


}