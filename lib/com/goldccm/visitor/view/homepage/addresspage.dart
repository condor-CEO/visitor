import 'package:flutter/material.dart';

class AddressPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new AddressPageState();
  }

}
class AddressPageState extends State<AddressPage>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        centerTitle:true,
        title:const Text('通讯录'),
        actions: <Widget>[
          new PopupMenuButton<Choice>( // overflow menu
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return new PopupMenuItem<Choice>(
                  value: choice,
                  child: new Text(choice.title),
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }

}
class Choice{
  const Choice({this.title,this.icon});
  final String title;
  final IconData icon;
}
const List<Choice> choices = const <Choice>[
  const Choice(title: '通过手机号查找', icon: Icons.directions_car),
  const Choice(title: '通过姓名查找', icon: Icons.directions_bike),
];