import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:visitor/com/goldccm/visitor/component/Qrcode.dart';
import 'package:visitor/com/goldccm/visitor/db/chatDao.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/ChatMessage.dart';
import 'package:visitor/com/goldccm/visitor/model/FunctionLists.dart';
import 'package:visitor/com/goldccm/visitor/model/JsonResult.dart';
import 'package:visitor/com/goldccm/visitor/model/QrcodeMode.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/UserModel.dart';
import 'package:visitor/com/goldccm/visitor/util/CommonUtil.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/QrcodeHandler.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';
import 'package:visitor/com/goldccm/visitor/model/BannerInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/NoticeInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/NewsInfo.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/addresspage.dart';
import 'package:visitor/com/goldccm/visitor/view/homepage/NewsView.dart';
import 'package:visitor/com/goldccm/visitor/view/homepage/notice.dart';
import 'package:visitor/com/goldccm/visitor/view/shareroom/RoomList.dart';
import 'package:visitor/com/goldccm/visitor/view/visitor/fastvisitreq.dart';
import 'dart:async';

import '../../../../../home.dart';
import 'NewsWebView.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}
class HomePageState extends State<HomePage> {
  List<BannerInfo> bannerList = []; //公告信息
  List<NoticeInfo> noticeList = []; //消息列表
  List<NewsInfo>  newsInfoList = [];//新闻列表
  List<String> imageList = [];
  List<String> noticeContentList = [];
  String imageServerUrl; //图片服务器地址
  List<FunctionLists> _addLists=[FunctionLists(iconImage:'asset/icons/门禁卡icon@2x.png',iconTitle: '门禁卡',iconType: '_mineCard'),FunctionLists(iconImage:'asset/icons/会议室icon@2x.png',iconTitle: '会议室',iconType: '_meetingRoom'),];
  List<FunctionLists> _baseLists=[FunctionLists(iconImage:'asset/icons/发起访问icon@2x.png',iconTitle: '发起访问',iconType: '_visitReq'),FunctionLists(iconImage:'asset/icons/访客二维码icon@2x.png',iconTitle: '访客二维码',iconType: '_visitorCard'),FunctionLists(iconImage:'asset/icons/全部icon@2x.png',iconTitle: '全部',iconType: '_more')];
  List<FunctionLists> _lists=[];
  var newsCurrentPage = 0;
  int totalSize = 0; //总条数
  ScrollController _scrollController = new ScrollController();
  String loadMoreText = "没有更多数据";
  TextStyle loadMoreTextStyle =
  new TextStyle(color: const Color(0xFF999999), fontSize: 14.0);
  TextStyle titleStyle =
  new TextStyle(color: const Color(0xFF757575), fontSize: 14.0);
  UserInfo  userInfo=new UserInfo();
  UserInfo _userInfo=new UserInfo();
  final double expandedHight = 200.0;
  @override
  void initState() {
    super.initState();
//    Future(getImageServerUrl()).then(getBanner()).then(getNoticeInfo()).then(getNewsInfoList());
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    getImageServerUrl();
    getBanner();
    getNoticeInfo();
    getNewsInfoList();
    getUserInfo();
    _scrollController.addListener(() {
      var maxScroll = _scrollController.position.maxScrollExtent;
      var pixel = _scrollController.position.pixels;
      if (maxScroll == pixel && newsInfoList.length < totalSize) {
        setState(() {
          loadMoreText = "正在加载中...";
          loadMoreTextStyle =
          new TextStyle(color: const Color(0xFF4483f6), fontSize: 14.0);
        });
        getNewsInfoList();
      } else {
        setState(() {
          loadMoreText = "没有更多数据";
          loadMoreTextStyle =
          new TextStyle(color: const Color(0xFF999999), fontSize: 14.0);
        });
      }
    });


  }
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
  double get top {
    double res = expandedHight;
    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
        res -= offset;

    }
    return res;
  }
  @override
  Widget build(BuildContext context) {
    UserInfo _userInfo=Provider.of<UserModel>(context).info;
    if(userInfo==null||userInfo.id==null){
      userInfo=_userInfo;
    }
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: new Stack(
         children: <Widget>[
           new CustomScrollView(
               controller: _scrollController,
               slivers: <Widget>[
                 SliverAppBar(
                    title: Text(
                      "首页",
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontSize: 18.0, color: Colors.white),
                    ),
                   expandedHeight: 200.0,
                   flexibleSpace: FlexibleSpaceBar(
                     background: _buildBannerImage(),
                   ),
                   backgroundColor: Theme.of(context).appBarTheme.color,
                   centerTitle: true,
                   actions: <Widget>[
                     Badge(
                       child: new IconButton(icon:Image.asset("asset/images/visitor_icon_message.png",height: 25,),onPressed: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>NoticePage()));
                       }),
                       badgeContent: Text(' ',style: TextStyle(color: Colors.white),),
                       position: BadgePosition(top: 0,right: 5),
                     ),
                   ],
                 ),
                 SliverPadding(
                   padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                   sliver: new SliverGrid( //Grid
                     gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                       crossAxisCount: 5,
                     ),
                     delegate: new SliverChildBuilderDelegate(
                           (BuildContext context, int index) {
                         return _buildIconTab(_lists[index].iconImage,_lists[index].iconTitle,_lists[index].iconType);
                       },
                       childCount: _lists.length,
                     ),
                   ),
                 ),
                 SliverPadding(
                   padding: EdgeInsets.only(left:16.0),
                   sliver: new SliverToBoxAdapter(
                     child: new Text('新闻公告',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,letterSpacing:2),),
                   ),
                 ),
                 new SliverFixedExtentList(
                   itemExtent:140,
                   delegate: new SliverChildBuilderDelegate(
                         (BuildContext context, int index) {
                       //创建列表项
                       if (index == newsInfoList.length) {
                         return _buildProgressMoreIndicator();
                       } else {
                         return buildJobItem(context,index);
                       }
                     },
                     childCount: newsInfoList.length,
                   ),
                 ),
               ]
           ),
           Positioned(
             top: top,
             width: MediaQuery.of(context).size.width,
             height: 44,
             child: Container(
               margin: EdgeInsets.symmetric(horizontal: 20),
               child: RaisedButton(
                 color: Colors.white,
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(20),
                 ),
                 onPressed: () => print('message press'),
                 child: _buildSwiperNotice(),
               ),
             ),
           ),
           Positioned(
             top: top+12,
             left: 30,
             height: 21,
             width: 21,
             child: Container(
               child: Image.asset("asset/icons/消息@2x.png"),
             ),
           ),
           Positioned(
             top: top+17,
             right: 35,
             height: 10,
             child: Container(
               child: Image.asset("asset/icons/gengduo@2x.png"),
             ),
           ),
         ],
        )
    );
  }

  Widget _buildProgressMoreIndicator() {
    return new SliverPadding(
      padding: const EdgeInsets.all(15.0),
      sliver: new Center(
        child: new Text(loadMoreText, style: loadMoreTextStyle),
      ),
    );
  }



  Widget buildJobItem(BuildContext context, int index) {
    NewsInfo newsinfo = newsInfoList[index];
    return  new InkWell(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new NewsWebPage(news_url:newsinfo.newsUrl, title:newsinfo.newsName)));
      },
      child: new NewsView(newsinfo,imageServerUrl),
    );
  }


  Widget _buildBannerImage(){
    return Container(
      height: 200.0,
      child: Swiper(
        scrollDirection: Axis.horizontal, // 横向
        itemCount: imageList.length, // 数量
        autoplay: true, // 自动翻页
        itemBuilder: _buildItemImage, // 构建
        onTap: (index) {
          print('点击了第${index}');
        }, // 点击事件 onTap
        pagination: SwiperPagination(
          // 分页指示器
            alignment: Alignment
                .bottomCenter, // 位置 Alignment.bottomCenter 底部中间
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 5), // 距离调整
            builder: DotSwiperPaginationBuilder(
              // 指示器构建
                space: 5, // 点之间的间隔
                size: 10, // 没选中时的
                activeSize: 12, // 选中时的大小
                color: Colors.black54, // 没选中时的颜色
                activeColor: Colors.white)), // 选中时的颜色
        //control: new SwiperControl(color: Colors.pink), // 页面控制器 左右翻页按钮
        scale: 1, // 两张图片之间的间隔
      ),
    );
  }

  Widget _buildSwiperNotice(){
    return Container(
      height: 40.0,
      padding: EdgeInsets.only(left: 25.0, top: 12.0),
      child: Swiper(
        scrollDirection: Axis.vertical, // 横向
        itemCount: noticeContentList.length<=5?noticeContentList.length:5, // 数量
        autoplay: true, // 自动翻页
        itemBuilder: _buildNoticeContent, // 构建
        autoplayDelay: 5000,
        onTap: (index) {
          ToastUtil.showShortToast("暂未开放");
        }, // 点击事件 onTap
        scale: 1, // 两张图片之间的间隔
      ),
    );
  }

  /*
  * 获取首页图片
  *
  * */

  Widget _buildIconTab(String imageurl, String text,String iconType) {
    return new InkWell(
      onTap: (){
        if(iconType=='_mineCard'){
          _mineCard();
        }else if(iconType=='_visitReq'){
          _requestVisitor();
        }else if(iconType=='_visitorCard'){
          _visitiorCard();
        }else if(iconType=='_more') {
          _more();
        }else if(iconType=="_meetingRoom"){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>RoomList()));
        }
      },
      child: new Container(
        height: 140.0,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(padding: EdgeInsets.only(top: 0.0),child: new Image.asset(imageurl, width: 49, height: 49,)),
            new Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: new Text(text, style: new TextStyle(fontSize: 14, fontFamily: '楷体_GB2312',fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemImage(BuildContext context, int index) {
    return Image.network(
      Constant.imageServerUrl+ imageList[index],
      fit: BoxFit.cover,
    );
  }

  Widget _buildNoticeContent(BuildContext context, int index) {
    return new Text(
      noticeContentList[index],
      style: new TextStyle(
          fontSize: 14.0, fontFamily: '楷体_GB2312', color: Colors.black,fontWeight: FontWeight.w500),
    );
  }
  ///获取用户信息
  getUserInfo() async {
    UserInfo userInfo = await DataUtils.getUserInfo();
    String imageServerUrl = await DataUtils.getPararInfo("imageServerUrl");
    if (userInfo != null) {
      setState(() {
        _userInfo = userInfo;
        getPrivilege();
      });
    } else {
      reloadUserInfo(userInfo);
    }
  }

  //重载用户信息
  //为了防止第一次登录时用户信息获取延迟
  //设定一个递归函数直到获取到用户的信息
  reloadUserInfo(UserInfo userInfo) {
    Future.delayed(Duration(seconds: 1), () async {
      UserInfo userInfo = await DataUtils.getUserInfo();
      String imageServerUrl = await DataUtils.getPararInfo("imageServerUrl");
      if (userInfo != null) {
        if (_userInfo.id == null) {
          reloadUserInfo(userInfo);
        }else {
          setState(() {
            _userInfo = userInfo;
            getPrivilege();
          });
        }
      } else {
        reloadUserInfo(userInfo);
      }
    });
  }
  getBanner() async {
    var response = await Http.instance.get(Constant.getBannerUrl);
//    new Timer(Duration(milliseconds: 500),(){
    setState(() {
      JsonResult responseResult = JsonResult.fromJson(response);
      if (responseResult.sign == 'success') {
        bannerList = BannerInfo.fromJsonDataList(responseResult.data);
        bannerList.forEach((banner) {
          String imageUrl = banner.imgUrl;
          imageList.add(imageUrl);
        });
      } else {
        ToastUtil.showShortToast('获取图片错误');
      }
    });
//    );

  }



  getNoticeInfo() async {
    String url = Constant.serverUrl+Constant.getNoticeListUrl + "/1/10";
    var response = await Http.instance
        .get(url, queryParameters: {"pageNum": "1", "pageSize": "10"});
    if (!mounted) return;
    setState(() {
      JsonResult responseResult = JsonResult.fromJson(response);
      if (responseResult.sign == 'success') {
        noticeList = NoticeInfo.getJsonFromDataList(responseResult.data);
        noticeList.forEach((notice) {
          String noticeContent = notice.content;
          if(noticeContent.length>=15){
            noticeContent=noticeContent.substring(0,15);
          }
          noticeContent+="...";
          noticeContentList.add(noticeContent);
        });
      } else {
        ToastUtil.showShortToast('获取消息列表错误');
      }
    });
  }

  getImageServerUrl() async {
    String url = Constant.serverUrl+Constant.getParamUrl + "imageServerUrl";
    var response = await Http.instance
        .get(url, queryParameters: {"paramName": "imageServerUrl"});
    if (!mounted) return;
    setState(() {
      JsonResult responseResult = JsonResult.fromJson(response);
      if (responseResult.sign == 'success') {
        imageServerUrl = responseResult.data;
        DataUtils.savePararInfo("imageServerUrl", imageServerUrl);
      } else {
        ToastUtil.showShortToast(responseResult.desc);
      }
    });
  }

  Future _pullToRefresh() async {
    newsCurrentPage = 0;
    newsInfoList.clear();
    getNewsInfoList();
    return null;
  }

  getNewsInfoList() async{
    this.newsCurrentPage++;
    String url = Constant.serverUrl+Constant.getNewsListUrl+newsCurrentPage.toString()+"/5";
    var response = await Http.instance.get(url,queryParameters: {"pageNum":newsCurrentPage,"pageSize":"5"});
    setState(() {
      JsonResult responseResult = JsonResult.fromJson(response);
      if(responseResult.sign=='success') {
        newsInfoList.addAll(NewsInfo.getJsonFromDataList(responseResult.data))  ;
        totalSize = responseResult.data['total'];
      }else {
        ToastUtil.showShortToast('获取消息列表错误');
      }

    } );

  }
//个人中心角色权限获取
  Future getPrivilege() async {
    String url = Constant.serverUrl+"userAppRole/getRoleMenu";
    String threshold = await CommonUtil.calWorkKey(userInfo: _userInfo);
    var res = await Http().post(url, queryParameters: {
      "token": _userInfo.token,
      "userId": _userInfo.id,
      "factor": CommonUtil.getCurrentTime(),
      "threshold": threshold,
      "requestVer": CommonUtil.getAppVersion(),
      "userId":"45",
      "orgId":"20",
    });
    //附加权限
    if(res != null){
      if(res is String){
        Map map = jsonDecode(res);
        if(map['data']!=null){
          for(int i=0;i<map['data'].length;i++){
            for(int j=0;j<_addLists.length;j++){
              if(_addLists[j].iconTitle==map['data'][i]['menu_name']){
                _lists.add(_addLists[j]);
              }
            }
          }
        }
      }
    }else{

    }
    //基础权限
    for(int i=0;i<_baseLists.length;i++){
      _lists.add(_baseLists[i]);
    }
  }
  Future<bool> checkAuth() async{
    userInfo = await DataUtils.getUserInfo();
    if(userInfo!=null&&userInfo.isAuth=='T'){
      return true;
    }else{
      return false;
    }
  }

  _mineCard() async{
    bool isAuth = await checkAuth();
    print('是否已进行实人认证：$isAuth');
    setState(() {
      if(isAuth){
        QrcodeMode model = new QrcodeMode(userInfo: userInfo,totalPages: 1,bitMapType: 1);
        List<String> qrMsg = QrcodeHandler.buildQrcodeData(model);
        print('$qrMsg[0]');
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
              return new Qrcode(qrCodecontent:qrMsg);
            }));

      }else{
        ToastUtil.showShortToast('请先进行实名认证，认证后开启该功能');
      }
    });

  }
  _requestVisitor(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomeApp(tabIndex: 2,)));
  }
  _visitiorCard(){
    ToastUtil.showShortToast("暂未开放，敬请期待");
  }
  _more(){
    ToastUtil.showShortToast("暂未开放，敬请期待");
  }
}
