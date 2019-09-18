import 'package:visitor/com/goldccm/visitor/model/QrcodeMode.dart';
import 'package:visitor/com/goldccm/visitor/model/RoomOrderInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/VisitInfo.dart';

import 'CommonUtil.dart';

/**
 * 二维码内容构造器
 */
class QrcodeHandler {



  /**
   *  构建二维码信息
   */
  static List<String> buildQrcodeData(QrcodeMode qrCodeMode){
    List<String> header = buildQrcodeComHeader(qrCodeMode);
    List<String> content = buildQrcodeBody(qrCodeMode);
    List<String> qrCodeMsg =[];
    for(var t=0;t<qrCodeMode.totalPages;t++){
      print('header==${header[t]}');
      print('body==${content[t]}');
      String qrCodeMsgTemp = header[t]+"|"+content[t];
      qrCodeMsg.add(qrCodeMsgTemp);
    }
    return qrCodeMsg;
  }

  /**
   * 二维码构造公共报文头
   */
  static List<String> buildQrcodeComHeader(QrcodeMode qrCodeMode){
    var qccodeType = qrCodeMode.bitMapType;//二维码类型1-员工门禁,2-访客门禁,3-身份证 4-huiyi 5-chashi
    var totalPage = qrCodeMode.totalPages;//二维码显示的总页数
    String qrCodeHeader ="";
    List<String> qrCodeHeaderList = [];
    for(var i=0;i<totalPage;i++){
      qrCodeHeader = qccodeType.toString()
      +"&"
      + CommonUtil.getRandData(1, 5)
      +"&"
      +(i+1).toString()
      +"&"
      +totalPage.toString()
      +"&"
      +CommonUtil.getCurrentTimeMinis();

      qrCodeHeaderList.add(qrCodeHeader);
    }
    return qrCodeHeaderList;

  }

  /**
   * type 1 2 3 公共报文体
   */
  static List<String> buildQrcodeBody(QrcodeMode qrCodeMode){
    UserInfo userInfo = qrCodeMode.userInfo;
    VisitInfo visitInfo = qrCodeMode.visitInfo;
    int totalPage = qrCodeMode.totalPages;
    List<String> qrContentList =[];
    String qrContent = '';
    qrContent = (userInfo.soleCode==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+userInfo.soleCode+']');
    qrContent = (userInfo.realName==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+userInfo.realName+']');
    qrContent = (userInfo.idNO==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+userInfo.idNO+']');
    if(visitInfo==null){
      qrContent = qrContent+'[]';
      qrContent = qrContent=qrContent+'[]';
      qrContent = qrContent=qrContent+'[]';
      qrContent = qrContent=qrContent+'[]';
    }else{
      qrContent = (visitInfo.province==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+visitInfo.province+']');
      qrContent = (visitInfo.city==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+visitInfo.city+']');
      qrContent = (visitInfo.companyName==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+visitInfo.companyName+']');
      qrContent = (visitInfo.realName==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+visitInfo.realName+']');
    }

    qrContent = (userInfo.loginName==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+userInfo.loginName+']');
    qrContent = (userInfo.headImgUrl==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+userInfo.headImgUrl+']');
    if(visitInfo==null){
      qrContent = qrContent+'[]';
      qrContent = qrContent+'[]';
    }else{
      qrContent = (visitInfo.startDate==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+visitInfo.startDate+']');
      qrContent = (visitInfo.endDate==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+visitInfo.endDate+']');
    }
    qrContent = (userInfo.companyId.toString()==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+userInfo.companyId.toString()+']');
    qrContent = (userInfo.companyName==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+userInfo.companyName+']');
    int pageLength = qrContent.length ~/ totalPage;//每页文本内容
    for(var i=0;i<totalPage;i++){
      String contentTemp = '';
      if(i==totalPage-1){
        contentTemp = CommonUtil.encodeBase64(qrContent.substring(i*pageLength));
      }else{
        contentTemp = CommonUtil.encodeBase64(qrContent.substring(i*pageLength,(i+1)*pageLength));
      }
      contentTemp = contentTemp+"|"+CommonUtil.getRandData(1, 1);
      if(contentTemp.length<256){
        String pageRight =CommonUtil.getRandData(1, 256-contentTemp.length);
        print('$pageRight');
        contentTemp = contentTemp+CommonUtil.getRandData(1, 256-contentTemp.length-26);
      }
      qrContentList.add(contentTemp);
    }
    return qrContentList;

  }


  /**
   * type 4 5 公共报文体
   */
  static List<String> buildQrcodeBodyV2(QrcodeMode qrCodeMode){
    UserInfo userInfo = qrCodeMode.userInfo;
    RoomOrderInfo orderInfo = qrCodeMode.roomOrderInfo;
    int totalPage = qrCodeMode.totalPages;
    List<String> qrContentList =[];
    String qrContent = '';
    if(userInfo==null){
      qrContent = qrContent+'[]';
      qrContent = qrContent+'[]';
      qrContent = qrContent+'[]';
    }else{
      qrContent = (userInfo.realName==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+userInfo.realName+']');
      qrContent = (userInfo.phone==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+userInfo.phone+']');
      qrContent = (userInfo.idNO==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+userInfo.idNO+']');
    }
    if(orderInfo==null){
      qrContent = qrContent+'[]';
      qrContent = qrContent+'[]';
      qrContent = qrContent+'[]';
      qrContent = qrContent+'[]';
      qrContent = qrContent+'[]';
      qrContent = qrContent+'[]';
      qrContent = qrContent+'[]';
    }else{
      qrContent = (orderInfo.createTime==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+orderInfo.createTime+']');
      qrContent = (orderInfo.applyStartTime==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+orderInfo.applyStartTime+']');
      qrContent = (orderInfo.applyEndTime==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+orderInfo.applyEndTime+']');
      qrContent = (orderInfo.roomSize==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+orderInfo.roomSize.toString()+']');
      qrContent = (orderInfo.roomAddress==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+orderInfo.roomAddress+']');
      qrContent = (orderInfo.roomName==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+orderInfo.roomName+']');
      qrContent = (orderInfo.tradeNO==null?qrContent=qrContent+'[]':qrContent=qrContent+'['+orderInfo.tradeNO+']');
    }
    int pageLength = qrContent.length ~/ totalPage;//每页文本内容
    for(var i=0;i<totalPage;i++){
      String contentTemp = '';
      if(i==totalPage-1){
        contentTemp = CommonUtil.encodeBase64(qrContent.substring(i*pageLength));
      }else{
        contentTemp = CommonUtil.encodeBase64(qrContent.substring(i*pageLength,(i+1)*pageLength));
      }
      contentTemp = contentTemp+"|"+CommonUtil.getRandData(1, 1);
      if(contentTemp.length<256){
        String pageRight =CommonUtil.getRandData(1, 256-contentTemp.length);
        print('$pageRight');
        contentTemp = contentTemp+CommonUtil.getRandData(1, 256-contentTemp.length-26);
      }
      qrContentList.add(contentTemp);
    }
    return qrContentList;

  }








}