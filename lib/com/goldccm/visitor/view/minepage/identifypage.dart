import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class IdentifyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IdentifyPageState();
  }
}

class IdentifyPageState extends State<IdentifyPage> {
  File _image;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('实名认证'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: 100,
                    child: ClipOval(
                      child:_image == null
                          ? Image.asset('asset/images/visitor_icon_head.png',width: 100,height: 100)
                          : Image.file(_image,fit: BoxFit.cover,width: 100,height: 100,),
                    ),
                  ),
                  Center(
                    child: RaisedButton(
                        child: Text('点击拍摄照片'), onPressed: getImage),
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text('身份信息（必填）'),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              color: Colors.white,
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '请输入您的真实姓名',
                ),
              ),
            ),
            Divider(
              height: 0,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              color: Colors.white,
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '请输入您的身份证号码（将加密处理）',
                ),
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text('身份证上地址信息（选填）'),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              color: Colors.white,
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '请选择所在地区',
                ),
              ),
            ),
            Divider(
              height: 0,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              color: Colors.white,
              child: TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '请输入详细地址信息，如道路、门牌号、小区、楼栋号、单元室等',
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
                  child: new Text('提交'),
                  onPressed: () async {

                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
