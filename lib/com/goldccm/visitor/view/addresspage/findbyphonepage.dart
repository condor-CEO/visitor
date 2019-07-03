
import 'package:flutter/material.dart';

class FindByPhonePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return FindByPhonePageState();
  }
}
class FindByPhonePageState extends State<FindByPhonePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加朋友'),
        centerTitle:true,
      ),
    );
  }
}