import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/JsonResult.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';
import 'package:visitor/com/goldccm/visitor/model/BannerInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/NoticeInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/NewsInfo.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:visitor/com/goldccm/visitor/view/homepage/NewsView.dart';

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


  @override
  void initState() {
    super.initState();
    getImageServerUrl();
    getBanner();
    getNoticeInfo();
    getNewsInfoList();
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
      body: new CustomScrollView(slivers: <Widget>[
        // 这个部件一般用于最后填充用的，会占有一个屏幕的高度，
        // 可以在 child 属性加入需要展示的部件
        SliverFillRemaining(
          child: new Column(
            children: <Widget>[
              new Container(
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
              ),
              new Container(
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
              ),
              new Container(
                height: 85,
                decoration: new BoxDecoration(
                  border: new Border(
                      bottom: new BorderSide(color: Colors.grey, width: 5)),
                ),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                        child:
                            _buildIconTab('asset/images/open_door.png', '门禁卡')),
                    new Expanded(
                        child: _buildIconTab(
                            'asset/images/visitor_icon_action_visit.png',
                            '发起访问')),
                    new Expanded(
                        child: _buildIconTab(
                            'asset/images/visitor_icon_action_qrcode.png',
                            '访客二维码')),
                    new Expanded(
                        child: _buildIconTab(
                            'asset/images/visitor_icon_action_more.png', '全部')),
                  ],
                ),
              ),
             new Padding(
               padding: EdgeInsets.only(top: 5.0,left: 15.0),
               child:
               new Row(mainAxisAlignment: MainAxisAlignment.start,
               children: <Widget>[
                 new Text('新闻公告',style: new TextStyle(fontSize: 14.0,fontFamily: '楷体_GB2312'),),
               ],),

             ),
             new Expanded(child: new ListView.builder(
               itemCount: newsInfoList.length,
               itemBuilder: buildJobItem,
             ),)



            ],
          ),
        ),
      ]),
    );
  }


  Widget buildJobItem(BuildContext context, int index) {
    NewsInfo newsinfo = newsInfoList[index];
    return  new InkWell(
      onTap: () {
        showDialog(
            context: context,
            child: new AlertDialog(
              content: new Text(
                "敬请期待",
                style: new TextStyle(fontSize: 20.0),
              ),
            ));
      },
      child: new NewsView(newsinfo,imageServerUrl),
    );
  }

  /*
  * 获取首页图片
  *
  * */

  Widget _buildIconTab(String imageurl, String text) {
    return new Container(
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
    );
  }

  Widget _buildItemImage(BuildContext context, int index) {
    return Image.network(
      imageList[index],
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
    if (!mounted) return;
    setState(() {
      JsonResult responseResult = JsonResult.fromJson(response);
      if (responseResult.sign == 'success') {
        bannerList = BannerInfo.fromJsonDataList(responseResult.data);
        bannerList.forEach((banner) {
          String imageUrl = imageServerUrl + banner.imgUrl;
          imageList.add(imageUrl);
        });
      } else {
        ToastUtil.showShortToast('获取图片错误');
      }
    });
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

  getNewsInfoList() async{
    String url = Constant.getNewsListUrl+"1"+"/"+"10";
    var response = await Http.instance.get(url,queryParameters: {"pageNum":"1","pageSize":"10"});
    setState(() {
      JsonResult responseResult = JsonResult.fromJson(response);
      if(responseResult.sign=='success') {
        newsInfoList = NewsInfo.getJsonFromDataList(responseResult.data);
      }else {
        ToastUtil.showShortToast('获取消息列表错误');
      }

      } );

      }

}
