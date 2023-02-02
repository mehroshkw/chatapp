import 'package:chatapp/services/auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../calling_ui/video_calling.dart';

class ChatRooms extends StatefulWidget {
  final String uid;
  const ChatRooms({required this.uid});

  @override
  State<ChatRooms> createState() => _ChatRoomsState();

}


class _ChatRoomsState extends State<ChatRooms> {
  final callingId = TextEditingController();
@override
  void initState() {
    print("user id after login is: ${widget.uid}");
    super.initState();
    subToTopic(widget.uid);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: callingId,
              decoration: const InputDecoration(
                  hintText: "Enter Call ID",
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VideoCalling(
                      callingID: callingId.text.toString()
                  )
                  )
                  );
                },
                child: Text(
                    "Join"
                )
            ),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: (){
                  FBAuth().logoutUser();
                  unSubToTopic(widget.uid);
                },
                child: Text(
                    "logout"
                )
            )
          ],
        ),
      ),
    );
  }

  void subToTopic(String uid) async{
    await FirebaseMessaging.instance
        .subscribeToTopic(uid);
  }
  void unSubToTopic(String uid) async{
    await FirebaseMessaging.instance
        .unsubscribeFromTopic(uid);
  }
}
