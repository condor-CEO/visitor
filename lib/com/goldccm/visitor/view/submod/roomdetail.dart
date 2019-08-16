import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/RoomInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'package:visitor/com/goldccm/visitor/view/submod/roomorder.dart';

class RoomDetail extends StatefulWidget {
  final RoomInfo roomInfo;
  RoomDetail({Key key, this.roomInfo}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return RoomDetailState();
  }
}

class ListState {
  List<TimeSquare> _list = <TimeSquare>[
    TimeSquare(0, "9:00- 9:30", 9),
    TimeSquare(0, "9:30- 10:00", 9.5),
    TimeSquare(0, "10:00-11:00", 10),
    TimeSquare(0, "10:30-11:00", 10.5),
    TimeSquare(0, "11:00-11:30", 11),
    TimeSquare(0, "11:30-12:00", 11.5),
    TimeSquare(0, "12:00-12:30", 12),
    TimeSquare(0, "12:30-13:00", 12.5),
    TimeSquare(0, "13:00-13:30", 13),
    TimeSquare(0, "13:30-14:00", 13.5),
    TimeSquare(0, "14:00-14:30", 14),
    TimeSquare(0, "14:30-15:00", 14.5),
    TimeSquare(0, "15:00-15:30", 15),
    TimeSquare(0, "15:30-16:00", 15.5),
    TimeSquare(0, "16:00-16:30", 16),
    TimeSquare(0, "16:30-17:00", 16.5),
    TimeSquare(0, "17:00-17:30", 17),
    TimeSquare(0, "17:30-18:00", 17.5),
    TimeSquare(0, "18:00-18:30", 18),
    TimeSquare(0, "18:30-19:00", 18.5),
    TimeSquare(0, "19:00-19:30", 19),
    TimeSquare(0, "19:30-20:00", 19.5),
    TimeSquare(0, "20:00-20:30", 20),
    TimeSquare(0, "20:30-21:00", 20.5),
    TimeSquare(0, "21:00-21:30", 21),
    TimeSquare(0, "21:30-22:00", 21.5),
    TimeSquare(0, "22:00-22:30", 22),
    TimeSquare(0, "22:30-23:00", 22.5),
    TimeSquare(0, "end", 23)
  ];
  setList(list) {
    _list = list;
  }

  getList() {
    return _list;
  }

  changeStatus(count, status) {
    _list[count].status = status;
  }
}

class RoomDetailState extends State<RoomDetail> {
  ListState _listState1 = new ListState();
  ListState _listState2 = new ListState();
  ListState _listState3 = new ListState();
  ListState _listState4 = new ListState();
  ListState _listState5 = new ListState();
  List<ListState> _stateList = new List<ListState>();
  UserInfo _userInfo = new UserInfo();

  ///获取用户信息
  getUserInfo() async {
    UserInfo userInfo = await DataUtils.getUserInfo();
    String imageServerUrl = await DataUtils.getPararInfo("imageServerUrl");
    if (userInfo != null) {
      setState(() {
        _userInfo = userInfo;
      });
    }
  }

  getRoomStatus() async {
    String url = Constant.testServerUrl+"meeting/roomStatus";
    var res = await Http().post(url, queryParameters: {
      'room_id': widget.roomInfo.id,
    });
    if (res is String) {
      Map map = jsonDecode(res);
      if (map['data'].length > 0) {
        for (int j = 0; j < map['data'].length; j++) {
          String timeInterval = map['data'][j]['time_interval'];
          var result = timeInterval.split(",");
          for (String value in result) {
            for (int i = 0; i < _stateList[j].getList().length; i++) {
              if (_stateList[j].getList()[i].value == double.parse(value)) {
                setState(() {
                  _stateList[j].changeStatus(i, -1);
                });
              }
            }
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _stateList.add(_listState1);
    _stateList.add(_listState2);
    _stateList.add(_listState3);
    _stateList.add(_listState4);
    _stateList.add(_listState5);
    getRoomStatus();
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 5,
      child: new Scaffold(
        appBar: new AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orangeAccent,
          title: new TabBar(
            tabs: [
              new Tab(
                text: DateTime.now().add(Duration(days: 0)).month.toString() +
                    "." +
                    DateTime.now().add(Duration(days: 0)).day.toString(),
              ),
              new Tab(
                text: DateTime.now().add(Duration(days: 1)).month.toString() +
                    "." +
                    DateTime.now().add(Duration(days: 1)).day.toString(),
              ),
              new Tab(
                text: DateTime.now().add(Duration(days: 2)).month.toString() +
                    "." +
                    DateTime.now().add(Duration(days: 2)).day.toString(),
              ),
              new Tab(
                text: DateTime.now().add(Duration(days: 3)).month.toString() +
                    "." +
                    DateTime.now().add(Duration(days: 3)).day.toString(),
              ),
              new Tab(
                text: DateTime.now().add(Duration(days: 4)).month.toString() +
                    "." +
                    DateTime.now().add(Duration(days: 4)).day.toString(),
              ),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        body: new TabBarView(
          children: [
            timeTable(_listState1, 0),
            timeTable(_listState2, 1),
            timeTable(_listState3, 2),
            timeTable(_listState4, 3),
            timeTable(_listState5, 4),
          ],
        ),
      ),
    );
  }

  Widget timeTable(ListState listState, int day) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            width: 400,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Image.network(
                  "http://www.yw2005.com/baike/uploads/allimg/160619/1-160619164J42K.jpg"),
            ),
          ),
          ListTile(
            title: Text('预定时间'),
            subtitle: Text('红色已被预定，灰色可以预定'),
          ),
          TimeTableRow(
            lists: listState,
            index: 0,
          ),
          TimeTableRow(
            lists: listState,
            index: 1,
          ),
          TimeTableRow(
            lists: listState,
            index: 2,
          ),
          TimeTableRow(
            lists: listState,
            index: 3,
          ),
          TimeTableRow(
            lists: listState,
            index: 4,
          ),
          TimeTableRow(
            lists: listState,
            index: 5,
          ),
          TimeTableRow(
            lists: listState,
            index: 6,
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: new SizedBox(
              width: 300.0,
              height: 50.0,
              child: RaisedButton(
                  color: Colors.green,
                  child: Text('确认',style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    String timeLines = "";
                    int count = 0;
                    for (int i = 0; i < listState.getList().length; i++) {
                      if (i + 1 < listState.getList().length &&
                          listState.getList()[i].status != 1 &&
                          listState.getList()[i + 1].status == 1) {
                        count++;
                      }
                      if (listState.getList()[i].status == 1) {
                        timeLines +=
                            listState.getList()[i].value.toString() + ",";
                      }
                    }
                    timeLines = timeLines.substring(0, timeLines.length - 1);
                    if (count > 1) {
                      ToastUtil.showShortToast("请选取连续的时间段");
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RoomOrder(
                                    userInfo: _userInfo,
                                    roomInfo: widget.roomInfo,
                                    timeLines: timeLines,
                                    day: day,
                                  )));
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}

class TimeSquare {
  int status;
  String time;
  double value;
  TimeSquare(this.status, this.time, this.value);
}

class TimeTableRow extends StatefulWidget {
  final ListState lists;
  final int index;
  TimeTableRow({this.lists, this.index});
  @override
  State<StatefulWidget> createState() {
    return TimeTableRowState();
  }
}

class TimeTableRowState extends State<TimeTableRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          width: 80,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(150),
          ),
          margin: EdgeInsets.all(5),
          child: FlatButton(
            child: Text(
                widget.lists.getList()[0 + widget.index * 4].time.toString()),
            color: widget.lists.getList()[0 + widget.index * 4].status == 0
                ? Colors.grey
                : widget.lists.getList()[0 + widget.index * 4].status == 1
                    ? Colors.green
                    : Colors.red,
            onPressed: () {
              setState(() {
                if (widget.lists.getList()[0 + widget.index * 4].status == 0)
                  widget.lists.changeStatus(0 + widget.index * 4, 1);
                else if (widget.lists.getList()[0 + widget.index * 4].status ==
                    1) widget.lists.changeStatus(0 + widget.index * 4, 0);
              });
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
          ),
        ),
        Container(
          width: 80,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(150),
          ),
          child: FlatButton(
            child: Text(
                widget.lists.getList()[1 + widget.index * 4].time.toString()),
            color: widget.lists.getList()[1 + widget.index * 4].status == 0
                ? Colors.grey
                : widget.lists.getList()[1 + widget.index * 4].status == 1
                    ? Colors.green
                    : Colors.red,
            onPressed: () {
              setState(() {
                if (widget.lists.getList()[1 + widget.index * 4].status == 0)
                  widget.lists.changeStatus(1 + widget.index * 4, 1);
                else if (widget.lists.getList()[1 + widget.index * 4].status ==
                    1) widget.lists.changeStatus(1 + widget.index * 4, 0);
              });
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
          ),
        ),
        Container(
          width: 80,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(150),
          ),
          child: FlatButton(
            child: Text(
                widget.lists.getList()[2 + widget.index * 4].time.toString()),
            color: widget.lists.getList()[2 + widget.index * 4].status == 0
                ? Colors.grey
                : widget.lists.getList()[2 + widget.index * 4].status == 1
                    ? Colors.green
                    : Colors.red,
            onPressed: () {
              setState(() {
                if (widget.lists.getList()[2 + widget.index * 4].status == 0)
                  widget.lists.changeStatus(2 + widget.index * 4, 1);
                else if (widget.lists.getList()[2 + widget.index * 4].status ==
                    1) widget.lists.changeStatus(2 + widget.index * 4, 0);
              });
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
          ),
        ),
        Container(
          width: 80,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
          ),
          child: FlatButton(
            child: Text(
                widget.lists.getList()[3 + widget.index * 4].time.toString()),
            color: widget.lists.getList()[3 + widget.index * 4].status == 0
                ? Colors.grey
                : widget.lists.getList()[3 + widget.index * 4].status == 1
                    ? Colors.green
                    : Colors.red,
            onPressed: () {
              setState(() {
                if (widget.lists.getList()[3 + widget.index * 4].status == 0)
                  widget.lists.changeStatus(3 + widget.index * 4, 1);
                else if (widget.lists.getList()[3 + widget.index * 4].status ==
                    1) widget.lists.changeStatus(3 + widget.index * 4, 0);
              });
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
          ),
        ),
      ],
    );
  }
}
