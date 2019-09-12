import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visitor/com/goldccm/visitor/httpinterface/http.dart';
import 'package:visitor/com/goldccm/visitor/model/RoomInfo.dart';
import 'package:visitor/com/goldccm/visitor/model/UserInfo.dart';
import 'package:visitor/com/goldccm/visitor/util/CommonUtil.dart';
import 'package:visitor/com/goldccm/visitor/util/Constant.dart';
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';
import 'package:visitor/com/goldccm/visitor/util/ToastUtil.dart';
import 'package:visitor/com/goldccm/visitor/view/shareroom/RoomAfterOrder.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:visitor/com/goldccm/visitor/view/shareroom/RoomCheckOut.dart';
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
  ScrollController _scrollController = new ScrollController();
  final double expandedHeight = 70.0;
  int _index=0;
  DateTime bookDate=DateTime.now();
  ///获取用户信息
  getUserInfo() async {
    UserInfo userInfo = await DataUtils.getUserInfo();
    if (userInfo != null) {
      setState(() {
        _userInfo = userInfo;
      });
    }
  }

  getRoomStatus() async {
    String url = Constant.serverUrl+"meeting/roomStatus";
    String threshold = await CommonUtil.calWorkKey();
    var res = await Http().post(url, queryParameters: {
      'room_id': widget.roomInfo.id,
      "token": _userInfo.token,
      "factor": CommonUtil.getCurrentTime(),
      "threshold": threshold,
      "requestVer": CommonUtil.getAppVersion(),
      "userId": _userInfo.id,
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
  double get top {
    double res = expandedHeight;
    if ( _scrollController.hasClients) {
      double offset =  _scrollController.offset;
      res -= offset;
    }
    return res;
  }
  @override
  void initState() {
    super.initState();
    getUserInfo();
    _stateList.add(_listState1);
    _stateList.add(_listState2);
    _stateList.add(_listState3);
    _stateList.add(_listState4);
    _stateList.add(_listState5);
    getRoomStatus();
    _scrollController.addListener(() {
      var maxScroll = _scrollController.position.maxScrollExtent;
      var pixel = _scrollController.position.pixels;
      if(maxScroll==pixel){
        setState(() {

        });
      }else{
        setState(() {

        });
      }
    });
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Stack(
          children: <Widget>[
            CustomScrollView(
              controller:  _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  title: Text(
                    "共享会议室",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 17.0, color: Colors.white),
                  ),
                  leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);}),
                  expandedHeight: 100.0,
                  backgroundColor: Theme.of(context).appBarTheme.color,
                  centerTitle: true,
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(10, 280, 10, 0),
                  sliver: SliverToBoxAdapter(
                    child: IndexedStack(
                      index: _index,
                      children: <Widget>[
                        Container(
                          child: Card(
                            child: timeTable(_listState1,0),
                            elevation: 10.0,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              new BoxShadow(
                                color: Colors.white12,
                                blurRadius: 3.0,
                                offset: new Offset(0.0, 3.0),
                              ),
                            ],
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          child: Card(
                            child: timeTable(_listState2,1),
                            elevation: 10.0,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              new BoxShadow(
                                color: Colors.white12,
                                blurRadius: 3.0,
                                offset: new Offset(0.0, 3.0),
                              ),
                            ],
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          child: Card(
                            child: timeTable(_listState3,2),
                            elevation: 10.0,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              new BoxShadow(
                                color: Colors.white12,
                                blurRadius: 3.0,
                                offset: new Offset(0.0, 3.0),
                              ),
                            ],
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          child: Card(
                            child: timeTable(_listState4,3),
                            elevation: 10.0,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              new BoxShadow(
                                color: Colors.white12,
                                blurRadius: 3.0,
                                offset: new Offset(0.0, 3.0),
                              ),
                            ],
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          child: Card(
                            child: timeTable(_listState5,4),
                            elevation: 10.0,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              new BoxShadow(
                                color: Colors.white12,
                                blurRadius: 3.0,
                                offset: new Offset(0.0, 3.0),
                              ),
                            ],
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ),
              ],
            ),
            Positioned(
              left: 10,
              right: 10,
              top: top,
              child: Container(
                child: Card(
                  child: roomListWidget(widget.roomInfo),
                  elevation: 10.0,
                ),
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                      color: Colors.white12,
                      blurRadius: 3.0,
                      offset: new Offset(0.0, 3.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
  Widget roomListWidget(RoomInfo room){
    return   Container(
        width: MediaQuery.of(context).size.width,
        height: 328,
        child:GestureDetector(
          child:Container(
            padding: EdgeInsets.all(10),
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Image.network("http://www.yw2005.com/baike/uploads/allimg/160619/1-160619164J42K.jpg"),
                  ),
                  height: 180,
                  left: 8,
                  right: 8,
                  bottom: 18,
                ),
                Positioned(
                  child: Text('${room.roomName}',overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                  left: 8,
                  width: 250,
                  top: 8,
                ),
                Positioned(
                  child: Text('${room.roomAddress}',overflow: TextOverflow.ellipsis,maxLines: 1,),
                  left: 8,
                  width: 250,
                  top: 42,
                ),
                Positioned(
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.blue[200],
                    ),
                    child: Text('开放时间：${room.roomOpenTime}-${room.roomCloseTime}',style: TextStyle(fontSize: 12.0,color: Colors.blue[700]),),
                  ),
                  top: 68,
                  left:8,
                ),
                Positioned(
                  child:  Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.0),
                        color: Colors.orange[200],
                      ),
                      child: room.roomType==1?Text('容纳约1-10人',style: TextStyle(fontSize: 12.0,color: Colors.orange[700]),):room.roomType==2?Text('容纳约10-20人',style: TextStyle(fontSize: 12.0,color: Colors.orange[700]),):Text('容纳约30人以上',style: TextStyle(fontSize: 12.0,color: Colors.orange[700]),)
                  ),
                  top: 68,
                  left: 130,
                ),
              ],
            ),
          ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>RoomDetail(roomInfo: room,)));
          },
        )
    );
  }
  switchWeekDay(int weekDay){
    if(weekDay==1){
      return '周一';
    }else if(weekDay==2){
      return '周二';
    }else if(weekDay==3){
      return '周三';
    }else if(weekDay==4){
      return '周四';
    }else if(weekDay==5){
      return '周五';
    }else if(weekDay==6){
      return '周六';
    }else if(weekDay==7){
      return '周日';
    }else{
      return '';
    }
  }
  bookRoom(int userID,int roomID,String timeLines,int day) async {
    var splits = timeLines.split(",");
    String url=Constant.serverUrl+"meeting/reserve";
    String threshold=await CommonUtil.calWorkKey();
    var res = await Http().post(url,queryParameters: ({
      "userId": userID,
      'room_id':roomID,
      'apply_date':DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: day))),
      'time_interval':timeLines,
      'apply_start_time':splits[0],
      'apply_end_time':(double.parse(splits[splits.length-1])+0.5).toString(),
      "token": _userInfo.token,
      "factor": CommonUtil.getCurrentTime(),
      "threshold": threshold,
      "requestVer": CommonUtil.getAppVersion(),
    }));
    if(res is String){
      Map map = jsonDecode(res);
      if(map['verify']['sign']=="success"){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RoomCheckOut(
                  userInfo: _userInfo,
                  roomInfo: widget.roomInfo,
                  timeLines: timeLines,
                  startTime: splits[0],
                  endTime:(double.parse(splits[splits.length-1])+0.5).toString(),
                  day: day,
                  count: splits.length,
                )));
      }else{
        ToastUtil.showShortToast(map['verify']['desc']);
      }
    }
  }
  Widget timeTable(ListState listState, int day) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('预定日期',style: TextStyle(fontSize: 14.0),),
            subtitle: Text(
              '${bookDate.month}月${bookDate.day}日 ${switchWeekDay(bookDate.weekday)}',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.black),
            ),
            onTap:(){
              DatePicker.showDatePicker(context, showTitleActions: true, minTime:DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day),maxTime:DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().add(Duration(days: 4)).day),onConfirm: (date) {
                setState(() {
                  bookDate=date;
                  _index=date.difference(DateTime.now()).inDays;
                });
              },currentTime: DateTime.now(), locale: LocaleType.zh);
            },
          ),
          Divider(
            height: 0,
          ),
          ListTile(
            title: Text('预定时间',style: TextStyle(fontSize: 14.0),),
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
            padding: EdgeInsets.only(top:10),
            child: new SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              child: RaisedButton(
                  color: Colors.blue,
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
                      showDialog(context:context,barrierDismissible: false,builder: (context){
                        return new Material( //创建透明层
                          type: MaterialType.transparency, //透明类型
                          child: new Center( //保证控件居中效果
                            child: new SizedBox(
                              width: MediaQuery.of(context).size.width/1.5,
                              height: MediaQuery.of(context).size.width/3,
                              child: new Container(
                                decoration: ShapeDecoration(
                                  color: Color(0xffffffff),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                ),
                                child: new Stack(
                                  children: <Widget>[
                                    Positioned(
                                      child: new Padding(
                                        padding: const EdgeInsets.only(
                                          top: 20.0,
                                          bottom: 20.0
                                        ),
                                        child: new Text(
                                          '确认预定？',
                                          style: new TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      left: 85,
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      left: 8,
                                      child: FlatButton(onPressed: (){
                                        Navigator.pop(context);
                                        bookRoom(_userInfo.id, widget.roomInfo.id, timeLines, day);
                                      }, child: Text('预定',textAlign: TextAlign.center,style: TextStyle(fontSize: 16.0,color: Colors.blue),)),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: FlatButton(onPressed:(){
                                        Navigator.pop(context);
                                      }, child: Text('我再想想',textAlign: TextAlign.center,style: TextStyle(fontSize: 16.0),)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
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
          width: 100,
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(150),
          ),
          margin: EdgeInsets.only(top: 10,bottom: 5),
          child: FlatButton(
            child: Text(
                widget.lists.getList()[0 + widget.index * 3].time.toString(),style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold),),
            color: widget.lists.getList()[0 + widget.index * 3].status == 0
                ? Colors.white
                : widget.lists.getList()[0 + widget.index * 3].status == 1
                    ? Colors.green
                    : Colors.red,
            onPressed: () {
              setState(() {
                if (widget.lists.getList()[0 + widget.index * 3].status == 0)
                  widget.lists.changeStatus(0 + widget.index * 3, 1);
                else if (widget.lists.getList()[0 + widget.index * 3].status ==
                    1) widget.lists.changeStatus(0 + widget.index * 3, 0);
              });
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),side: BorderSide(color: Colors.black12)),
          ),
        ),
        Container(
          width: 100,
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(150),
          ),
          child: FlatButton(
            child: Text(
                widget.lists.getList()[1 + widget.index * 3].time.toString(),style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold),),
            color: widget.lists.getList()[1 + widget.index * 3].status == 0
                ? Colors.white
                : widget.lists.getList()[1 + widget.index * 3].status == 1
                    ? Colors.green
                    : Colors.red,
            onPressed: () {
              print(widget.lists.getList()[1 + widget.index * 3].status);
              setState(() {
                if (widget.lists.getList()[1 + widget.index * 3].status == 0)
                  widget.lists.changeStatus(1 + widget.index * 3, 1);
                else if (widget.lists.getList()[1 + widget.index * 3].status ==
                    1) widget.lists.changeStatus(1 + widget.index * 3, 0);
              });
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),side: BorderSide(color: Colors.black12)),
          ),
        ),
        Container(
          width: 100,
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(150),
          ),
          child: FlatButton(
            child: Text(
                widget.lists.getList()[2 + widget.index * 3].time.toString(),style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold),),
            color: widget.lists.getList()[2 + widget.index * 3].status == 0
                ? Colors.white
                : widget.lists.getList()[2 + widget.index * 3].status == 1
                    ? Colors.green
                    : Colors.red,
            onPressed: () {
              setState(() {
                if (widget.lists.getList()[2 + widget.index * 3].status == 0)
                  widget.lists.changeStatus(2 + widget.index * 3, 1);
                else if (widget.lists.getList()[2 + widget.index * 3].status ==
                    1) widget.lists.changeStatus(2 + widget.index * 3, 0);
              });
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),side: BorderSide(color: Colors.black12)),
          ),
        ),
      ],
    );
  }
}
