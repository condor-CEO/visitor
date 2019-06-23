import 'package:meta/meta.dart';
import 'dart:convert';


class VisitInfo{

   String id;
   String visitDate;
   String visitTime;
   String userId;
   String visitorId;
   String reason;
   String cstatus;
   String dateType;
   String startDate;
   String endDate;
   String answerContent;
   String orgCode;
   String realName;
   String userRealName;
   String visitorRealName;
   String province;
   String city;
   String orgName;
   String companyName;

  VisitInfo({
     this.id,
     this.visitDate,
     this.visitTime,
     this.userId,
     this.visitorId,
     this.reason,
     this.cstatus,
     this.dateType,
     this.startDate,
     this.endDate,
     this.answerContent,
     this.orgCode,
     this.realName,
     this.userRealName,
     this.visitorRealName,
     this.province,
     this.city,
     this.orgName,
     this.companyName,
});

  VisitInfo.fromJson(Map json) {
    id = json['id'];
    visitDate = json['visitDate'];
    visitTime = json['visitTime'];
    userId = json['userId'];
    visitorId = json['visitorId'];
    reason = json['reason'];
    cstatus = json['cstatus'];
    dateType = json['dateType'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    answerContent = json['answerContent'];
    orgCode = json['orgCode'];
    realName = json['realName'];
    userRealName = json['userRealName'];
    visitorRealName = json['visitorRealName'];
    province = json['province'];
    city = json['city'];
    orgName = json['orgName'];
    companyName = json['companyName'];
  }

}