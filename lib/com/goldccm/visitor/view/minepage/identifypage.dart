
import 'package:flutter/material.dart';

class IdentifyPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return IdentifyPageState();
  }
}
class IdentifyPageState extends State<IdentifyPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('实名认证'),
        centerTitle:true,
      ),
    );
  }
}