
import 'package:flutter/material.dart';

class IdentifyCodePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return IdentifyCodePageState();
  }
}
class IdentifyCodePageState extends State<IdentifyCodePage>{
  @override
  void initState() {
    super.initState();
    getSoleCode();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('身份识别码'),
        centerTitle:true,
      ),
    );
  }
  getSoleCode(){

  }
}