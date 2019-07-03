import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';


class Qrcode extends StatefulWidget{
 final List<String> qrCodecontent;
  Qrcode({Key key,this.qrCodecontent}): super(key: key);

  @override
  QrcodeState createState() => QrcodeState();

}

class QrcodeState extends State<Qrcode>with SingleTickerProviderStateMixin {

  int currentContent =0;
  String data;


  @override
void initState(){
    super.initState();
  }


  Widget build(BuildContext context) {
    _timer();
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
          '二维码',
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontSize: 18.0, color: Colors.white, fontFamily: '楷体_GB2312'),
        ),
      ),
      body: new Center(

        child: new QrImage(
          data: data,
          size: 220,
          version: 10,
          padding: EdgeInsets.all(20),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
        ),
      ),



    );
  }

  Timer timer;
  _timer() async{
    if(timer==null&&widget.qrCodecontent.length>1){
      timer= Timer.periodic( Duration(milliseconds: 200), (as) {
        setState(() {
          data = widget.qrCodecontent[currentContent];
          print('$data');
            currentContent++;
            if (currentContent == widget.qrCodecontent.length) {
              currentContent = 0;
          }

        });
      });
    }else{
      data = widget.qrCodecontent[currentContent];
      print('$data');
    }


  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }


}