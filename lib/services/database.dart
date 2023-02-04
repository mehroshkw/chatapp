import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance.collection("chatAppUsers").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("chatAppUsers")
        .where("email", isEqualTo: email)
        .snapshots();
    //     .catchError((e) {
    //   print(e.toString());
    // });
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('name', isEqualTo: searchField).snapshots();
        // .getDocuments();
  }

  // Future<bool> addChatRoom(chatRoom, chatRoomId) {
  //   FirebaseFirestore.instance
  //       .collection("chatRoom")
  //       .document(chatRoomId)
  //       .setData(chatRoom)
  //       .catchError((e) {
  //     print(e);
  //   });
  // }

  // getChats(String chatRoomId) async{
  //   return FirebaseFirestore.instance
  //       .collection("chatRoom")
  //       .document(chatRoomId)
  //       .collection("chats")
  //       .orderBy('time')
  //       .snapshots();
  // }


  // Future<void> addMessage(String chatRoomId, chatMessageData){
  //
  //   FirebaseFirestore.instance.collection("chatRoom")
  //       .document(chatRoomId)
  //       .collection("chats")
  //       .add(chatMessageData).catchError((e){
  //     print(e.toString());
  //   });
  // }

  getUserChats(String itIsMyName) async {
    return await FirebaseFirestore.instance
        .collection("chatAppUsers")
        .where('name', arrayContains: itIsMyName)
        .snapshots();
  }

}