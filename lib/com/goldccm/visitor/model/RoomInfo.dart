class RoomInfo<T>{

  int id;
  String roomName;
  int roomType;
  String roomIntro;
  String roomAddress;
  String roomImage;
  String roomOpenTime;
  String roomCloseTime;
  String roomPrice;
  String roomManager;
  String roomStatus;
  String roomOrgCode;
  String roomCancelHour;
  String roomPercent;

  RoomInfo({this.id, this.roomName, this.roomType, this.roomIntro,this.roomAddress,
      this.roomImage, this.roomOpenTime, this.roomCloseTime, this.roomPrice,
      this.roomManager, this.roomStatus, this.roomOrgCode, this.roomCancelHour,
      this.roomPercent});

  RoomInfo.fromJson(Map json){
    this.id=json['id'];
    this.roomName=json['room_name'];
    this.roomType=json['room_type'];
    this.roomIntro=json['room_short_content'];
    this.roomImage=json['room_image'];
    this.roomOpenTime=json['room_open_time'];
    this.roomCloseTime=json['room_close_time'];
    this.roomPrice=json['room_price'];
    this.roomManager=json['room_manager'];
    this.roomStatus=json['room_status'];
    this.roomOrgCode=json['room_orgcode'];
    this.roomCancelHour=json['room_cancle_hour'];
    this.roomPercent=json['room_percent'];
  }
}