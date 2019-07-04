import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/component/Qrcode.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/JsonResult.dart';
import 'package:visitor/com/goldccm/visitor/model/QrcodeMode.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/QrcodeHandler.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';
import 'package:visitor/com/goldccm/visitor/model/BannerInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/NoticeInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/NewsInfo.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:visitor/com/goldccm/visitor/view/homepage/NewsView.dart';
import 'package:visitor/com/goldccm/visitor/view/visitor/fastvisitreq.dart';
import 'dart:async';

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
  List<String> icomImage=['asset/images/open_door.png','asset/images/visitor_icon_action_visit.png','asset/images/visitor_icon_action_qrcode.png','asset/images/visitor_icon_action_more.png'];
  List<String> iconTitle=['门禁卡','发起访问','访客二维码','全部'];
  var newsCurrentPage = 0;
  int totalSize = 0; //总条数
  ScrollController _scrollController = new ScrollController();
  String loadMoreText = "没有更多数据";
  TextStyle loadMoreTextStyle =
  new TextStyle(color: const Color(0xFF999999), fontSize: 14.0);
  TextStyle titleStyle =
  new TextStyle(color: const Color(0xFF757575), fontSize: 14.0);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<
      RefreshIndicatorState>();
  List<String> _iconType = ['_mineCard','_visitReq','_visitorCard','_more'];
  UserInfo userInfo;


  @override
  void initState() {
    super.initState();
    getImageServerUrl();
    getBanner();
    getNoticeInfo();
    getNewsInfoList();
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

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          title: new Text(
            "首页",
            textAlign: TextAlign.center,
            style: new TextStyle(
                fontSize: 17.0, color: Colors.white, fontFamily: '楷体_GB2312'),
          ),
          actions: <Widget>[
            new ImageIcon(new AssetImage("asset/images/visitor_icon_message.png"))
          ],
        ),
        body: new RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _pullToRefresh,
          child: new CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.all(1.0),
                  sliver: new SliverToBoxAdapter(
                    child: _buildBannerImage(),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(1.0),
                  sliver: new SliverToBoxAdapter(
                    child: _buildSwiperNotice(),
                  ),
                ),


                SliverPadding(
                  padding: const EdgeInsets.all(0.0),
                  sliver: new SliverGrid( //Grid
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, //Grid按两列显示
                    ),
                    delegate: new SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        //创建子widget
                        return _buildIconTab(icomImage[index],iconTitle[index],_iconType[index]);

                      },
                      childCount: icomImage.length,
                    ),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.all(0.0),
                  sliver: new SliverToBoxAdapter(
                    child: new Divider(color: Colors.grey,),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.only(left:20.0),
                  sliver: new SliverToBoxAdapter(
                    child: new Text('新闻公告'),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.only(left:0.0),
                  sliver: new SliverToBoxAdapter(
                    child: new Divider(color: Colors.black,),
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
              ]),
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
                builder: (context) => new NewsWebPage(newsinfo.newsUrl, newsinfo.newsName)));
      },
      child: new NewsView(newsinfo,imageServerUrl),
    );
  }


  Widget _buildBannerImage(){
    return Container(
      height: 150.0,
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
    return new Container(
      decoration: new BoxDecoration(
        border: new Border(
            bottom: new BorderSide(color: Colors.grey, width: 0.8)),
      ),
      height: 40.0,
      padding: EdgeInsets.only(left: 20.0, top: 12.0),
      //color: Colors.white,
      child: Swiper(
        scrollDirection: Axis.vertical, // 横向
        itemCount: noticeContentList.length, // 数量
        autoplay: true, // 自动翻页
        itemBuilder: _buildNoticeContent, // 构建
        onTap: (index) {
          print('点击了第${index}');
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
          print('点击门禁卡');
          _mineCard();
        }else if(iconType=='_visitReq'){
          _requestVisitor();
        }else if(iconType=='_visitorCard'){
          _visitiorCard();
        }else if(iconType=='_more'){
          _more();
        }
      },
      child: new Container(
        height: 80.0,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(padding: EdgeInsets.only(top: 10.0),child: new Image.asset(
              imageurl,
              width: 40,
              height: 40,
            ),),

            new Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: new Text(
                text,
                style: new TextStyle(fontSize: 14, fontFamily: '楷体_GB2312',fontWeight: FontWeight.bold),
              ),
            ),

          ],
        ),

      ),


    );
  }

  Widget _buildItemImage(BuildContext context, int index) {
    return Image.network(
      imageServerUrl+ imageList[index],
      fit: BoxFit.cover,
    );
  }

  Widget _buildNoticeContent(BuildContext context, int index) {
    return new Text(
      noticeContentList[index],
      style: new TextStyle(
          fontSize: 14.0, fontFamily: '楷体_GB2312', color: Colors.red),
    );
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
    String url = Constant.getNoticeListUrl + "/1/10";
    var response = await Http.instance
        .get(url, queryParameters: {"pageNum": "1", "pageSize": "10"});
    if (!mounted) return;
    setState(() {
      JsonResult responseResult = JsonResult.fromJson(response);
      if (responseResult.sign == 'success') {
        noticeList = NoticeInfo.getJsonFromDataList(responseResult.data);
        noticeList.forEach((notice) {
          String noticeContent = notice.content;
          noticeContentList.add(noticeContent);
        });
      } else {
        ToastUtil.showShortToast('获取消息列表错误');
      }
    });
  }

  getImageServerUrl() async {
    String url = Constant.getParamUrl + "imageServerUrl";
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
    String url = Constant.getNewsListUrl+newsCurrentPage.toString()+"/5";
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
        print('123123${userInfo}');
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
    DataUtils.clearLoginInfo();
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
          return new FastVisitReq();
        }));


  }

  _visitiorCard(){

  }

  _more(){
    ToastUtil.showShortToast('敬请期待');
  }



}
