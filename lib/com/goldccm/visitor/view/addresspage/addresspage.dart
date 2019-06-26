import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/findbynamepage.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/findbyphonepage.dart';

class AddressPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddressPageState();
  }
}

class AddressPageState extends State<AddressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('通讯录'),
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: (value){
              if(value.value==1){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>FindByPhonePage()));
              }
              if(value.value==2){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>FindByNamePage()));
              }
            },
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }
}

class Choice {
  Choice({this.title, this.icon,this.value});
  String title;
  IconData icon;
  int value;
}

List<Choice> choices = <Choice>[
   Choice(title: '通过手机号查找', icon: Icons.directions_car,value:1),
   Choice(title: '通过姓名查找', icon: Icons.directions_bike,value:2),
];


