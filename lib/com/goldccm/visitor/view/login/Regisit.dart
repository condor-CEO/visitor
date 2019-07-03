import 'package:flutter/material.dart';
import 'dart:async';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/JsonResult.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/Md5Util.dart';
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';
import 'package:visitor/com/goldccm/visitor/util/SharedPreferenceUtil.dart';
import 'package:visitor/home.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';



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
  bool isAuth=true;
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

  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _passwordConfirmController = new TextEditingController();
  TextEditingController _checkCodeController=new TextEditingController();
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
                    buildForm('手机号', '请输入您的手机号', true, 20,_userNameController),
                    new Divider(
                      color: Colors.black54,
                    ),
                    _buildCode('验证码', '请输入验证码', false, 20,_checkCodeController),
                    new Divider(
                      color: Colors.black54,
                    ),
                    buildForm('密码', '请输入密码', false, 35,_passwordController),
                    new Divider(
                      color: Colors.black54,
                    ),
                    buildForm('确认密码', '请再次输入密码', false, 8,_passwordConfirmController),
                    new Divider(
                      color: Colors.black54,
                    ),

                    new Padding(padding: EdgeInsets.only(left: 30.0,right: 30.0),
                    child: new Row(
                      children: <Widget>[
                        new Checkbox(
                            value: isAuth,
                            activeColor: Colors.lightBlue,
                            onChanged: (bool){
                              setState(() {
                                isAuth=bool;
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
                              onPressed: (){
                               if(isAgree) {
                              _register();
                    }else{
                                 return null;
                    }
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
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.grey,
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
      String labelText, String hintText, bool autofocus, double left,TextEditingController controller) {
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
            controller: controller,
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

  /**
   * 注册
   */
  void _register() async{
    if(checkLoignUser()&&checkCode()&&checkPass()&&checkConfirmPass()){
      if(isAgree){
        String phone = _userNameController.text.toString();
        String code = _checkCodeController.text.toString();
        String sysPwd = Md5Util.instance.encryptByMD5ByHex(_passwordController.text.toString());
        var response = await Http.instance.post(Constant.registerUrl,queryParameters: {"phone":phone,"code":code,"sysPwd":sysPwd});
        JsonResult result = JsonResult.fromJson(response);
        if(result.sign=='success'){
          var data = await Http.instance.post(Constant.loginUrl,queryParameters:{"phone":phone,"style":"1","sysPwd":sysPwd});
          JsonResult loginResult = JsonResult.fromJson(data);
          if(loginResult.sign=='success'){
            Map userMap = result.data['user'];
            UserInfo userInfo = UserInfo.fromJson(userMap);
            DataUtils.saveLoginInfo(userMap);
            DataUtils.saveUserInfo(userMap);
            //DataUtils.saveNoticeInfo(noticeMap);
            SharedPreferenceUtil.saveUser(userInfo);
            Navigator.push(context, new MaterialPageRoute(
                builder: (BuildContext context) =>/*isAuth==true?new AuthCheck():*/new MyHomeApp()));
          }else{
            ToastUtil.showShortToast(loginResult.desc);
            return ;
          }
        }else{
          ToastUtil.showShortToast(result.desc);
          return ;
        }
      }else{
        ToastUtil.showShortToast('请先同意联客用户协议');
        return ;
      }
    }
  }

  Widget _buildCode(
      String labelText, String hintText, bool autofocus, double left,TextEditingController controller) {
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
                onTap:() async {
                    if (_codeBtnflag) {
                      bool sendResult = await getCheckCode();
                      if(sendResult){
                        _startTimer();
                      }

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

  /*
  *  用户名校验
   */
  bool checkLoignUser(){
    String _loginName = _userNameController.text.toString();
    bool checkResult =true;
    if(_loginName==null||_loginName==""){
      ToastUtil.showShortToast('手机号不能为空');
      checkResult= false;
    }else if(_loginName!=''&&_loginName.length!=11){
      ToastUtil.showShortToast('手机号长度不正确');
      checkResult= false;
    }else{
      checkResult= true;
    }
    return checkResult;

  }

  /**
   * 密码校验
   */
  bool checkPass(){
    String _pass = _passwordController.text.toString();
    bool checkResult = true;
    if(_pass==null||_pass==""){
      ToastUtil.showShortToast('密码不能为空');
      checkResult= false;
    }else if(_pass!=''&&_pass.length<6&&_pass.length>=32){
      ToastUtil.showShortToast('密码长度不能小于6位大于32位');
      checkResult= false;
    }else{
      checkResult= true;
    }
    return checkResult;
  }

  bool checkConfirmPass(){
    String _confirmPass = _passwordConfirmController.text.toString();
    String _pass = _passwordController.text.toString();
    if(_confirmPass!=_pass){
      ToastUtil.showShortToast('两次输入密码不一致');
      return false;
    }else{
      return true;
    }

  }

  /**
   * 手机验证码校验
   */
  bool checkCode(){
    String _checkCode = _checkCodeController.text.toString();
    bool checkResult = true;
    if(_checkCode==null||_checkCode==""){
      ToastUtil.showShortToast('验证码不能为空');
      checkResult= false;
    }else if(_checkCode!=''&&_checkCode.length!=6){
      ToastUtil.showShortToast('验证码必须为6位数字');
      checkResult= false;
    }else{
      checkResult= true;
    }
    return checkResult;

  }

  /**
   * 获取验证码
   */
  Future<bool> getCheckCode() async {
    bool _userNameCheck = checkLoignUser();
    if(_userNameCheck){
      String url = Constant.sendCodeUrl+"/"+_userNameController.text.toString()+"/1";
      var data = await Http().get(url,queryParameters:{"phone":_userNameController.text.toString(),"type":"1"});
      if(data!=null){
        JsonResult result = JsonResult.fromJson(data);
        if(result.sign=='success'){
          return true;
        }else{
          ToastUtil.showShortToast(result.desc);
          return false;
        }
      }

    }else{
      return _userNameCheck;
    }
  }


}
