import 'package:chatapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/msgTile.dart';

class ChatRooms extends StatefulWidget {
  String username, chatRoomId, email;
   ChatRooms({required this.username, required this.chatRoomId, required this.email});

  @override
  State<ChatRooms> createState() => _ChatRoomsState();

}

class _ChatRoomsState extends State<ChatRooms> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController msgC = TextEditingController();
  // late Stream chatMessageStream;
  // DatabaseMethods databaseMethods = new DatabaseMethods();
  // createchatRoom(String username){
  //   List<String> users = [username, myName];
  //   databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
  // }
  DatabaseMethods databaseMethods = new DatabaseMethods();

  // Widget chatMessages(){
  //   return StreamBuilder(
  //     stream: chatMessageStream,
  //     builder: (context, snapshot){
  //       return snapshot.hasData ?  ListView.builder(
  //           itemCount: snapshot.data!.docs.length,
  //           itemBuilder: (context, index){
  //             var result = snapshot.data!.docs[index];
  //             return MessageTile(
  //               message: result["message"],
  //               sendByMe: widget.email == result["sendBy"],
  //             );
  //           }) : Container();
  //     },
  //   );
  // }

  @override
  void initState() {
    // chatMessageStream=  databaseMethods.getChats(widget.chatRoomId).then((val) {
    //   setState(() {
    //     chatMessageStream = val;
    //   });
    // });
    super.initState();
  }

  sendMsg(){
    if(msgC.text.isNotEmpty){
      Map<String, dynamic> msgMap = {
        'message' : msgC.text,
        'sendby' : widget.email,
        'time' : DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addChats(widget.chatRoomId, msgMap);
      msgC.text="";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.username),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 63),
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection("chatRoom").doc(widget.chatRoomId).collection("chats").orderBy("time", descending: false).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      // itemCount: 5,
                      itemBuilder: (c, i) {
                        var result = snapshot.data!.docs[i];
                        return MessageTile(
                          // message:'Data',
                          // sendByMe: true,
                                        message: result["message"],
                          sendByMe: widget.email == result["sendby"] ? true:false,

                                        // sendByMe: widget.email == result["sendBy"],
                                      );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator(color: Colors.black,));
                },
              ),
            ),
            Container(height: 20,),
            // chatMessages(),
            Container(alignment: Alignment.bottomCenter,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                color: Color(0x54FFFFFF),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: msgC,
                          // style: simpleTextStyle(),
                          decoration: InputDecoration(
                              hintText: "Message ...",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              border: InputBorder.none
                          ),
                        )),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                        // addMessage();
                        sendMsg();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.send)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
