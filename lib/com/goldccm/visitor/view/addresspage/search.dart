import 'package:flutter/material.dart';

///通讯录搜索
class FriendSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FriendSearchState();
  }
}

class FriendSearchState extends State<FriendSearch> {
  TextEditingController textController=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return _searchPage();
  }
  Widget _searchPage() {

    return Scaffold(
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
                           onSearchTextChanged('');
                        },
                      ),
                    ],
                  ),
                ))),
          ),
        ],
      ),
    );
  }

  void onSearchTextChanged(String value) {
    if(value==""){
      print(value);
      textController.text="";
    }else{

    }
  }
}
