import 'package:meta/meta.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/VisitInfo.dart';



class QrcodeMode{

   UserInfo userInfo;
   int totalPages;
   VisitInfo visitInfo;
   int bitMapType;
   QrcodeMode({this.userInfo,this.totalPages,this.visitInfo,this.bitMapType});



}