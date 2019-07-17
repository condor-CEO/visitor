/**
 * 聊天信息体
 */
class ChatMessage {
  int M_ID;
  String M_MessageContet;
  String M_Status;
  String M_Time;
  String M_MessageType;
  String M_IsSend;
  int M_userId;
  int M_FriendId;
  String M_FnickName;
  String M_FrealName;
  String M_FheadImgUrl;
  int unreadCount;

  ChatMessage(
      {this.M_ID,
      this.M_MessageContet,
      this.M_Status,
      this.M_Time,
      this.M_MessageType,
      this.M_IsSend,
      this.M_userId,
      this.M_FriendId,
      this.M_FnickName,
      this.M_FrealName,
      this.M_FheadImgUrl,
      this.unreadCount});

  ChatMessage.fromJson(Map map) {
    this.M_ID = map['M_ID'];
    this.M_MessageContet = map['M_MessageContet'];
    this.M_Status = map['M_Status'];
    this.M_Time = map['M_Time'];
    this.M_MessageType = map['M_MessageType'];
    this.M_IsSend = map['M_IsSend'];
    this.M_userId = map['M_userId'];
    this.M_FriendId = map['M_ID'];
    this.M_FnickName = map['M_FnickName'];
    this.M_FrealName = map['M_FrealName'];
    this.M_FheadImgUrl = map['M_FheadImgUrl'];
    this.unreadCount = map['unreadCount'];
  }

  @override
  String toString() {
    return 'ChatMessage{M_ID: $M_ID, M_MessageContet: $M_MessageContet, M_Status: $M_Status, M_Time: $M_Time, M_MessageType: $M_MessageType, M_IsSend: $M_IsSend, M_userId: $M_userId, M_FriendId: $M_FriendId, M_FnickName: $M_FnickName, M_FrealName: $M_FrealName, M_FheadImgUrl: $M_FheadImgUrl}';
  }
}
