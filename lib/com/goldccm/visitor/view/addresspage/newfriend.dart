import 'package:flutter/material.dart';

class NewFriendPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewFriendPageState();
  }
}

class NewFriendPageState extends State<NewFriendPage> {
  Presenter presenter = new Presenter();
  List<Person> _request;
  List<Person> _friends;
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新的朋友'),
        centerTitle: true,
      ),
      body: _newFriend(),
    );
  }

  Widget _newFriend() {
    return
       CustomScrollView(
        slivers: <Widget>[
            _friendRequest(),
            _findNew(),
        ],
      );
  }

  Widget _friendRequest() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context,int index){
        return ListTile(
          leading: Icon(Icons.person),
          title: Text('好友名称'),
          subtitle: Text('留言'),
          trailing: RaisedButton(child: Text('同意'), onPressed: null),
        );
      },
        childCount: _request.length),);
  }

  Widget _findNew() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context,int index){
        return ListTile(
          leading: Icon(Icons.person),
          title: Text('通讯录名称'),
          subtitle: Text('app昵称'),
          trailing: RaisedButton(child: Text('添加'), onPressed: null),
        );
      },
        childCount: _friends.length
      ),
    );
  }

  init() {
    presenter.loadFriend();
    presenter.loadRequest();
    _request = presenter.getRequest();
    _friends = presenter.getFriend();
    print(_request);
    print(_friends);
  }
}

class Person {
  String name;
  String nickname;
  String phone;
  String imageUrl;
  Person(this.name, this.nickname, this.phone, this.imageUrl);
}

class Presenter {
  List<Person> _request;
  List<Person> _friends;
  getRequest() {
    return _request;
  }

  getFriend() {
    return _friends;
  }

  void loadRequest() {
    _request = new List<Person>();
    _request.add(new Person('hwk', 'westrain', '15880485249', 'image'));
    _request.add(new Person('hwk', 'westrain', '15880485249', 'image'));
    _request.add(new Person('hwk', 'westrain', '15880485249', 'image'));
    _request.add(new Person('hwk', 'westrain', '15880485249', 'image'));
    _request.add(new Person('hwk', 'westrain', '15880485249', 'image'));
    _request.add(new Person('hwk', 'westrain', '15880485249', 'image'));
  }

  void loadFriend() {
    _friends = new List<Person>();
    _friends.add(new Person('hwk', 'westrain', '15880485249', 'image'));
    _friends.add(new Person('hwk', 'westrain', '15880485249', 'image'));
    _friends.add(new Person('hwk', 'westrain', '15880485249', 'image'));
    _friends.add(new Person('hwk', 'westrain', '15880485249', 'image'));
    _friends.add(new Person('hwk', 'westrain', '15880485249', 'image'));
    _friends.add(new Person('hwk', 'westrain', '15880485249', 'image'));
  }
}
