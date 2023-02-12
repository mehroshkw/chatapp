import 'package:chatapp/ui/chatrooms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/database.dart';

class Search extends StatefulWidget {
  final String uid, email;
  final String search;
   Search({Key? key, required this.search, required this.uid, required this.email});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DatabaseMethods databaseMethods = new DatabaseMethods();
  late QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if(widget.search.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await databaseMethods.searchByName(widget.search)
          .then((snapshot){
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
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
        .collection("chatAppUsers")
        .where('name', isEqualTo: searchField).snapshots().length;
    // .getDocuments();
  }

  Widget userList(){
    return haveUserSearched ? ListView.builder(
        shrinkWrap: true,
        itemCount: searchByName(widget.search),
        itemBuilder: (context, index){
          return ListTile(
            title: searchByName(widget.search).documents[index].data["name"],
            subtitle: searchByName(widget.search).documents[index].data["email"],

          );
        }) : Container();
  }

  createchatRoom(String username){
    String chatroomID= getChatRoomId(username, widget.email);
    List<String> users = [username, widget.email];
    Map<String, dynamic> chatroomMap = {
      'users' : users,
      'chatroomId' : chatroomID
    };
    databaseMethods.createChatRoom(chatroomID, chatroomMap);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRooms(username: username, chatRoomId: chatroomID, email: widget.email,)));

  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Searched Users"),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection("chatAppUsers").where('name', isEqualTo: widget.search).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index){
                    var result = snapshot.data!.docs[index];
                    return Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade100,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      
                      child: ListTile(
                        title: Text("${result["name"]}"),
                        subtitle: Text(result["email"]),
                        trailing: IconButton(onPressed: (){
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRooms()));
                          createchatRoom("${result["email"]}");
                        }, icon: Icon(Icons.message_outlined),
                      ),
                    ));
                  });
            }
            return Center(child: CircularProgressIndicator(color: Colors.black,));
          },
        ),
      ),
    );
  }
}
