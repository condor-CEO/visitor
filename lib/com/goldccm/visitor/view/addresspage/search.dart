import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/addresspage.dart';
import 'package:visitor/com/goldccm/visitor/view/addresspage/frienddetail.dart';

///通讯录搜索
class FriendSearch extends StatefulWidget {
  final userList;
  FriendSearch({Key key, this.userList}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return FriendSearchState();
  }
}

class FriendSearchState extends State<FriendSearch> {
  List<User> _userLists = new List<User>();
  List<User> _selectUserLists = new List<User>();
  TextEditingController textController = new TextEditingController();
  String _imageUrl;

  @override
  void dispose() {
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _userLists = widget.userList;
    init();
  }
  init() async {
    _imageUrl = await DataUtils.getPararInfo("imageServerUrl");
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('搜索好友'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Container(
                height: 52.0,
                child: new Card(
                    child: new Container(
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: TextField(
                                decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 0.0),
                                    hintText: '查找',
                                    border: InputBorder.none),
                                onChanged: onSearchTextChanged,
                                controller: textController,
                              ),
                            ),
                          ),
                          new IconButton(
                            icon: new Icon(Icons.cancel),
                            color: Colors.grey,
                            iconSize: 18.0,
                            onPressed: () {
                              onSearchTextChanged(textController.text);
                            },
                          ),
                        ],
                      ),
                    ))),
          ),
          Expanded(child: _buildInfo()),
        ],
      ),
    );
  }
  Widget _buildInfo() {
    return ListView.separated(
        itemCount:  _selectUserLists.length != null ?  _selectUserLists.length : 0,
        separatorBuilder: (context,index){
          return Container(
            child: Divider(
              height: 0,
            ),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.white,
            child: ListTile(
              title: Text( _selectUserLists[index].userName),
              leading:  _selectUserLists[index].idHandleImgUrl!=null?CircleAvatar(backgroundImage:NetworkImage(_imageUrl+ _selectUserLists[index].idHandleImgUrl),):CircleAvatar(backgroundImage: AssetImage("asset/images/visitor_icon_head.png"),),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>FriendDetailPage(user:  _selectUserLists[index],)));
              },
            ),
          );
        });
  }

  void onSearchTextChanged(String value) {
    print(value);
    List<User> _lists = new List<User>();
    if (value == "") {
      textController.text = "";
    } else {
      for(var user in _userLists){
        if(user.userName.contains(textController.text)){
          _lists.add(user);
        }
      }
    }
    setState(() {
      _selectUserLists=_lists;
    });
  }
}
