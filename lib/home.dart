import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/addresspage.dart';
import 'package:visitor/com/goldccm/visitor/view/homepage/homepage.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/minepage.dart';
//import 'package:visitor/com/goldccm/visitor/view/homepage/homepage1.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/minepage.dart';
import 'package:visitor/com/goldccm/visitor/view/minepage/settingpage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';



class MyHomeApp extends StatefulWidget{
  @override
  HomeState createState()=> new HomeState();
}

const double _kTabTextSize =10.0;
const int INDEX_HOME=0;
const int INDEX_FRIEND=1;
const int INDEX_VISITOR=2;
const int INDEX_MINE=3;
Color _keyPrimaryColor = Colors.lightBlue ;

class HomeState extends State<MyHomeApp> with SingleTickerProviderStateMixin{

  int _tabIndex = 0;
  var tabImages;
  var appBarTitles = ['首页', '访客','通讯录', '我的'];
  var _pageList;
  WebSocketChannel channel;

  /*
   * 根据选择获得对应的normal或是press的icon
   */
  Image getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }
  /*
   * 获取bottomTab的颜色和文字
   */
  Text getTabTitle(int curIndex) {
    if (curIndex == _tabIndex) {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 14.0, color: const Color(0xff1296db),fontFamily:'楷体_GB2312' ));
    } else {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 14.0, color: const Color(0xff515151),fontFamily:'楷体_GB2312'));
    }
  }
  /*
   * 根据image路径获取图片
   */
  Image getTabImage(path) {
    return new Image.asset(path, width: 24.0, height: 24.0);
  }

  @override
  void initState() {
    super.initState();
    initData();
    channel = IOWebSocketChannel.connect('ws://192.168.3.4:8088/echo');
  }


  void initData() {
    /*
     * 初始化选中和未选中的icon
     */
    tabImages = [
      [getTabImage('asset/images/visitor_tab_homepage_normal.png'), getTabImage('asset/images/visitor_tab_homepage_selected.png')],
      [getTabImage('asset/images/visitor_tab_visitors_normal.png'), getTabImage('asset/images/visitor_tab_visitors_selected.png')],
      [getTabImage('asset/images/visitor_tab_friends_normal.png'), getTabImage('asset/images/visitor_tab_friends_selected.png')],
      [getTabImage('asset/images/visitor_tab_profile_center_normal.png'), getTabImage('asset/images/visitor_tab_profile_center_selected.png')]
    ];
    /*
     * 三个子界面
     */
    _pageList = [
      new HomePage(),
      new AddressPage(),
      new HomePage(),
      new MinePage(),
    ];
  }


  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop()=>new Future.value(false);
    return new WillPopScope(child: Scaffold(
          body: IndexedStack(
      index: _tabIndex,
      children: _pageList,
    ),
        bottomNavigationBar: new BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
                icon: getTabIcon(0), title: getTabTitle(0)),
            new BottomNavigationBarItem(
                icon: getTabIcon(1), title: getTabTitle(1)),
            new BottomNavigationBarItem(
                icon: getTabIcon(2), title: getTabTitle(2)),
            new BottomNavigationBarItem(
                icon: getTabIcon(3), title: getTabTitle(3)),
          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          //默认选中首页
          currentIndex: _tabIndex,
          iconSize: 20.0,
          //点击事件
          onTap: (index) {
            setState(() {
              _tabIndex = index;
            });
          },
        )), onWillPop: _onWillPop);;
  }

  }