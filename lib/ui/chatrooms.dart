import 'package:chatapp/services/database.dart';
import 'package:flutter/material.dart';

class ChatRooms extends StatefulWidget {
  String username;
   ChatRooms({required this.username});

  @override
  State<ChatRooms> createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  // DatabaseMethods databaseMethods = new DatabaseMethods();
  // createchatRoom(String username){
  //   List<String> users = [username, myName];
  //   databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(widget.username),
      ),
    );
  }
}
