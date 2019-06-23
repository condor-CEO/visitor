import 'package:flutter/material.dart';
import 'dart:async';

final TextStyle _labelStyle = new TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontFamily: '楷体_GB2312');

final TextStyle _hintlStyle = new TextStyle(
    fontSize: 14.0, color: Colors.black54, fontFamily: '楷体_GB2312');


final Color _availableStyle = Colors.blue;

/// 墨水瓶（`InkWell`）不可用时使用的样式。
final Color _unavailableStyle = Colors.grey;
class Regisit extends StatefulWidget {

  final int countdown;

  /// 用户点击时的回调函数。
  final Function onTapCallback;

  /// 是否可以获取验证码，默认为`false`。
  final bool available;

  Regisit({
    this.countdown: 60,
    this.onTapCallback,
    this.available: false,
  });
  @override
  State<StatefulWidget> createState() {
    return new RegisitState();
  }
}

class RegisitState extends State<Regisit> {
  bool isCheck=true;
  bool isAgree=true;
  bool _codeBtnflag = true;

  Timer _timer;


  /// 当前倒计时的秒数。
  int _seconds;

  /// 当前墨水瓶（`InkWell`）的字体样式。
  Color colorStyle = _availableStyle;

  /// 当前墨水瓶（`InkWell`）的文本。
  String _verifyStr = '发送验证码';

  @override
  void initState() {
    super.initState();
    _seconds = widget.countdown;
  }

  /// 启动倒计时的计时器。
  void _startTimer() {
    // 计时器（`Timer`）组件的定期（`periodic`）构造函数，创建一个新的重复计时器。
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        _seconds = widget.countdown;
        colorStyle = _availableStyle;
        _codeBtnflag = true;
        setState(() {});
        return;
      }
      _seconds--;
      _verifyStr = '已发送$_seconds' + 's';
      colorStyle = _unavailableStyle;
      _codeBtnflag = false;
      setState(() {});
      if (_seconds == 0) {
        _verifyStr = '重新发送';
      }
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.lightBlue,
          leading: IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              }),
          centerTitle: true,
          title: new Text(
            "注册",
            textAlign: TextAlign.center,
            style: new TextStyle(
                fontSize: 18.0, color: Colors.white, fontFamily: '楷体_GB2312'),
          ),
        ),
        body: new SingleChildScrollView(
            child: new ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: 120.0,
                ),

              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,

                  children: <Widget>[
                    buildForm('手机号', '请输入您的手机号', true, 20),
                    new Divider(
                      color: Colors.black54,
                    ),
                    _buildCode('验证码', '请输入验证码', false, 20),
                    new Divider(
                      color: Colors.black54,
                    ),
                    buildForm('密码', '请输入密码', false, 35),
                    new Divider(
                      color: Colors.black54,
                    ),
                    buildForm('确认密码', '请再次输入密码', false, 8),
                    new Divider(
                      color: Colors.black54,
                    ),

                    new Padding(padding: EdgeInsets.only(left: 30.0,right: 30.0),
                    child: new Row(
                      children: <Widget>[
                        new Checkbox(
                            value: isCheck,
                            activeColor: Colors.lightBlue,
                            onChanged: (bool){
                              setState(() {
                                isCheck=bool;
                              });
                            }
                        ),
                      new Text('添加实名认证',style: new TextStyle(fontFamily: '楷体_GB2312',fontSize: 12.0,color: Colors.black87),),
                        new Expanded(child: new Text('（稍后可在个人中心完善资料）',style: new TextStyle(fontFamily: '楷体_GB2312',fontSize: 12.0,color: Colors.deepOrange),))


                      ],
                    )


                    ),
                    new Padding(
                      padding: new EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new RaisedButton(
                              onPressed: () {
                                print("  我点击了  Padding  下的  RaisedButton");
                              },
                              //通过控制 Text 的边距来控制控件的高度
                              child: new Padding(
                                padding: new EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                                child: new Text(
                                  "注册",
                                  style: new TextStyle(color: Colors.white, fontSize: 18,fontFamily:'楷体_GB2312',),
                                ),
                              ),
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
//                    new Expanded(child:
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Checkbox(
                            value: isAgree,
                            activeColor: Colors.lightBlue,
                            onChanged: (bool){
                              setState(() {
                                isAgree=bool;
                              });
                            }
                        ),
                        new Text('已同意',style: new TextStyle(fontFamily: '楷体_GB2312',fontSize: 12.0,color: Colors.grey),),
                        new Text('《联客用户协议》',style: new TextStyle(fontFamily: '楷体_GB2312',fontSize: 12.0,color: Colors.blue),)


                      ],
                    )

                  ]),
            ),
          ),
        );
  }

  Widget buildForm(
      String labelText, String hintText, bool autofocus, double left) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Container(
          padding: EdgeInsets.all(10.0).copyWith(right: 20.0),
          child: new Text(
            labelText,
            style: _labelStyle,
          ),
        ),
        // 右边部分输入，用Expanded限制子控件的大小
        new Expanded(
          child: new TextField(
            controller: null,
            autofocus: autofocus,
            // 焦点控制，类似于Android中View的Focus
            style: _hintlStyle,
            decoration: InputDecoration(
              hintText: hintText,
              // 去掉下划线
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: left),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCode(
      String labelText, String hintText, bool autofocus, double left) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Container(
          padding: EdgeInsets.all(10.0).copyWith(right: 20.0),
          child: new Text(
            labelText,
            style: _labelStyle,
          ),
        ),
        // 右边部分输入，用Expanded限制子控件的大小
        new Expanded(
          child: new TextField(
            controller: null,
            autofocus: autofocus,
            // 焦点控制，类似于Android中View的Focus
            style: _hintlStyle,
            decoration: InputDecoration(
              hintText: hintText,
              // 去掉下划线
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: left),
            ),
          ),
        ),
        new Text(
          '|',
          style: new TextStyle(color: Colors.blue, fontSize: 15),
        ),
        new Expanded(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new GestureDetector(
                onTap:() {
                    if (_codeBtnflag) {
                      _startTimer();
                    } else {
                      return null;
                    }
                  },

                child: new Text(_verifyStr,
                    style: new TextStyle(
                        color: colorStyle,
                        fontFamily: '楷体_GB2312',
                        fontSize: 14.0)),
              )
            ],
          ),
        ),
      ],
    );
  }
}
