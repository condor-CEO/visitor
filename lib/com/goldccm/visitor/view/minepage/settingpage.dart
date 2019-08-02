import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitor/com/goldccm/visitor/util/CacheUtils.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';


///设置
class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingPageState();
  }
}
class SettingPageState extends State<SettingPage>{
  String size;
  @override
  void initState() {
    super.initState();
    getCacheSize();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('设置'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            child: new Column(
              children: <Widget>[
                Center(
                  child: new Image.asset('asset/images/visitor_logo.png',
                      scale: 0.7),
                ),
                new Container(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: new Text('版本号 1.1.3'),
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(0, 50.0, 0, 0),
          ),
          new Container(
            padding: EdgeInsets.all(10.0),
            child: new SizedBox(
              width: 300.0,
              height: 50.0,
              child: new RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: new Text('清除缓存$size'),
                //清除缓存
                onPressed: () async {
                  CacheUtils cacheUtils=new CacheUtils();
                  if(size!="0.00B") {
                    cacheUtils.clearCache();
                  }
                  ToastUtil.showShortToast("清除完毕");
                },
              ),
            ),
          ),
          new Container(
            padding: EdgeInsets.all(10.0),
            child: new SizedBox(
              width: 300.0,
              height: 50.0,
              child: new RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: new Text('安全退出'),
                //将保存在sp内的登录识别isLogin置为false
                //然后退出应用
                onPressed: () async {
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  sp.setBool("isLogin", false);
                  await SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop');
                },
              ),
            ),
          )
        ],
      ),
    );
  }
  //获取缓存的大小
  getCacheSize()async {
    CacheUtils cacheUtils=new CacheUtils();
    size=await cacheUtils.loadCache();
    setState(() {
    });
  }
}
