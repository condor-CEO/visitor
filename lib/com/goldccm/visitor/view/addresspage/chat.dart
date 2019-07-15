import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ChatPageState();
  }
}
class ChatPageState extends State<ChatPage>{
  final List<chatMessage> _message = <chatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing =false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('与xxx洽谈'),
        centerTitle: true,
      ),
      body: _drawChat(),
    );
  }
  Widget _drawChat(){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
                child: new SizedBox(
                  height: 40.0,
                  child: new RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: new Text('邀约'),
                    onPressed: (){

                    },
                  ),
                ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: new SizedBox(
                height: 40.0,
                child: new RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: new Text('访问'),
                  onPressed: (){

                  },
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.all(5),
                child: new SizedBox(
                  height: 40.0,
                  child: new RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: new Text('催审'),
                    onPressed: (){

                    },
                  ),
                ),
            ),
          ],
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                    itemBuilder: (_,int index)=>_message[index],
                    padding: EdgeInsets.all(8),
                    reverse: true,
                    itemCount: _message.length,
                ),
              ),
              Divider(height: 1.0,),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildTextComposer(){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      children: <Widget>[
        Flexible(
          child: TextField(
            controller: _textController,
            onSubmitted: _handleSubmmited,
            decoration: InputDecoration.collapsed(hintText: "Send a message"),
            onChanged: (String text){
                _isComposing =text.length>0;
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          child: IconButton(
              icon: Icon(Icons.send),
              onPressed:_isComposing?()=>_handleSubmmited(_textController.text):null,
          ),
        ),
      ],
    ),
  );
  }
  void _handleSubmmited(String text){
    _textController.clear();
    chatMessage message = new chatMessage(
      text: text,
      type: "other",
    );
    setState(() {
      _message.insert(0, message);
      _isComposing=false;
    });
  }
}
class chatMessage extends StatelessWidget{
  final String text;
  final String type;
  chatMessage({this.text,this.type});
  @override
  Widget build(BuildContext context) {
    return _switchMessage(context);
  }
  _switchMessage(context){
    if(type!=null){
      if(type=="me"){
       return  new Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('我',style: Theme.of(context).textTheme.subhead,),
                  Container(
                    width: 250,
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text('我的信息我的信息我的信息我的信息我的信息我的信息我的信息我的信息',softWrap: true,),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(right: 16.0),
                child: CircleAvatar(child: Icon(Icons.more),),
              ),
            ],
          ),
        );
      }
      else{
        return  new Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 16.0),
                child: CircleAvatar(child: Icon(Icons.more),),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('我',style: Theme.of(context).textTheme.subhead,),
                  Container(
                    width: 250,
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text('我的信息我的信息我的信息我的信息我的信息我的信息我的信息我的信息',softWrap: true,),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    }else{
      return  new Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Icon(Icons.more),),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('',style: Theme.of(context).textTheme.subhead,),
                Container(
                  width: 250,
                  margin: EdgeInsets.only(top: 5.0),
                  child: Text('该条信息缺失',softWrap: true,),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}