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

  createChatRoom(String chatRoomId, chatRoomMap){
    FirebaseFirestore.instance
          .collection("chatRoom").doc(chatRoomId).set(chatRoomMap).catchError((e){
            print(e.toString());
    });
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

  addChats(String chatRoomId, msgMap) async{
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(msgMap).catchError((e){
          print(e.toString());
        });
  }

 getChats(String chatRoomId) async{
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats").orderBy("time", descending: false).snapshots();
  }


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
  getUser(String username) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('email', arrayContains: username)
        .snapshots();
  }

}