
import 'package:flutter/material.dart';

class CompanyPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CompanyPageState();
  }
}
class CompanyPageState extends State<CompanyPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('公司管理'),
        centerTitle:true,
      ),
    );
  }
}