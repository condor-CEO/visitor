import 'package:sqflite/sqflite.dart';
import 'package:visitor/com/goldccm/visitor/model/ChatMessage.dart';

import 'BaseDBProvider.dart';



 //聊天信息,聊天记录Dao操作类

class ChatDao extends BaseDBProvider{

  //存储表明
  String table_name = "tbl_ChatMessage";

  //主键
  String primary_Key = "_id";

  @override
  tableName() {
    return table_name;
  }


   //建表语句

  @override
  tableSqlString() {
    return    tableBaseString(table_name,primary_Key)+'''
    M_ID integer not null,
    M_MessageContet text,
    M_Status text,
    M_Time text,
    M_MessageType text,
    M_IsSend text,
    M_userId integer,
    M_FriendId integer,
    M_FnickName text,
    M_FrealName text,
    M_FheadImgUrl text
     )
    ''';
  }


   //插入一条消息

  Future insertNewMessage(ChatMessage msg) async{
    Database db = await getDataBase();
    return await db.insert(table_name, toMap(msg));
  }


   //根据内容查找信息

  Future<List<ChatMessage>> queryMessage(String content) async {
    Database db = await getDataBase();
    List<Map<String,dynamic>> listRes = await db.query(table_name,where: 'content like %?%',whereArgs: [content]);
    if(listRes.length>0){
      List<ChatMessage> msgs = listRes.map((item)=>ChatMessage.fromJson(item)).toList();
      return msgs;
    }
    return null;
  }


   //查询消息列表

  Future<List<ChatMessage>> getMessageList() async{
    Database db = await getDataBase();
    List<Map<String,dynamic>> listRes = await db.query(table_name);
    if(listRes.length>0){
      List<ChatMessage> msgs = listRes.map((item)=>ChatMessage.fromJson(item)).toList();
      return msgs;
    }
    return null;

  }

  //查询每个好友的最新消息以及未读信息条数
  Future<List<ChatMessage>> getlatestMessage() async {
    Database db = await getDataBase();
    List<Map<String,dynamic>> listRes = await db.rawQuery("select c.unreadCount,a.* from tbl_ChatMessage a  join (select M_FriendId,max(M_Time) M_Time from tbl_ChatMessage group by M_FriendId) b on a.M_FriendId = b.M_FriendId and a.M_Time = b.M_Time left join (select M_FriendId,count(*) unreadCount from tbl_ChatMessage where M_status='1' group by M_FriendId) c on a.M_FriendId = c.M_FriendId order by a.M_Time desc");
    if(listRes.length>0){
      List<ChatMessage> msgs = listRes.map((item)=>ChatMessage.fromJson(item)).toList();
      return msgs;
    }
    return null;
  }


  //查询所有未读消息
  Future<int> getNoRedMessage() async {
    Database db = await getDataBase();
    int  count = Sqflite.firstIntValue(await db.rawQuery("select count(*) from tbl_ChatMessage where M_status ='1' and M_issend='1'"));
    return count;
  }

   //根据好友ID更新状态
   //用于更新已读未读消息
  Future updateMessageStatus(int friendID) async{
    Database db = await getDataBase();
    int count = await db.rawUpdate('update tbl_ChatMessage set M_status=0 where M_FUserID= ? and M_status=1',[friendID]);

  }

   //删除会话信息
  Future  deleteSession(int friendId) async{
    Database db = await getDataBase();
    int count = await db.rawDelete('delete from tbl_ChatMessage where M_FUserID= ? ',[friendId]);
  }



  //消息转map
  Map<String,dynamic> toMap(ChatMessage msg){
    Map<String,dynamic>  map = {
    'M_ID': msg.M_ID,
    'M_MessageContet' : msg.M_MessageContet,
    'M_Status':msg.M_Status,
    'M_Time':msg.M_Time,
    'M_MessageType':msg.M_MessageType,
    'M_IsSend':msg.M_IsSend,
    'M_userId':msg.M_userId,
    'M_FriendId':msg.M_FriendId,
     'M_FnickName':msg.M_FnickName,
     'M_FrealName':msg.M_FrealName,
      'M_FheadImgUrl':msg.M_FheadImgUrl,
    };
    return map;

  }

}