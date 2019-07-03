import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';

var _keys = null;

class CompanyPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CompanyPageState();
  }
}
class CompanyPageState extends State<CompanyPage>{
  int groupValue=0;
  @override
  void initState() {
    super.initState();
    getCompanyInfo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('公司管理'),
        centerTitle:true,
      ),
      body:_buildInfo(),
    );
  }
  Widget _buildInfo() {
    if (_keys != null && _keys != "") {
      return ListView.builder(
          itemCount: _keys.length != null ? _keys.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child:
              Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ListTile(
                        title: Text('公司名称：'+_keys[index]['companyName'],style: TextStyle(fontSize: 14.0),),
                      ),
                      ListTile(
                        title: Text('部门名称：'+_keys[index]['sectionName'],style: TextStyle(fontSize: 14.0)),
                      ),
                      ListTile(
                        title: Text('用户姓名：'+_keys[index]['userName'],style: TextStyle(fontSize: 14.0)),
                      ),
                      ListTile(
                        title: Text('邀请时间：'+_keys[index]['createDate'],style: TextStyle(fontSize: 14.0)),
                      ),
                    ],
                  ),
                  Positioned(
                    child: Radio(value:index, groupValue: groupValue, onChanged: (T){updateGroupValue(T);}),
                    right: 10.0,
                    top:80.0,
                  ),
                ],
              ),
            );
          });
    } else {
      return Column(
        children: <Widget>[
          Container(
            child: Center(
                child: Image.asset('asset/images/visitor_icon_nodata.png')),
            padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
          ),
          Center(child: Text('暂无数据，请重新获取'))
        ],
      );
    }
  }
  getCompanyInfo() async {
    String url = "http://192.168.101.20:8080/api_visitor/companyUser/findApplySuc";
    var res = await Http().post(url, queryParameters: {
      "userId": 27,
      "token": "24d16d8a-f9d6-4249-8704-fa6a3fb76ac6",
      "threshold": "71B7735F3E9EC0814B1DC612A1A4A7F0",
      "factor": "20170831143600",
    });
    if (res != null) {
      Map map = jsonDecode(res);
      setState(() {
        _keys = map['data'];
      });
    }
  }
  void updateGroupValue(int v){
    setState(() {
      groupValue=v;
    });
  }
}