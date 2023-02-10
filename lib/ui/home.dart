import 'dart:convert';

import 'package:chatapp/ui/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../calling_ui/video_calling.dart';
import '../services/auth.dart';
import 'package:http/http.dart' as http;

import '../services/database.dart';


class Home extends StatefulWidget {
  final String uid, email;
  const Home({required this.uid, required this.email});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final callingId = TextEditingController();
  final search = TextEditingController();

  DatabaseMethods databaseMethods = new DatabaseMethods();
  late QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if(search.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await databaseMethods.searchByName(search.text)
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
        .collection("users")
        .where('name', isEqualTo: searchField).snapshots().length;
    // .getDocuments();
  }
  
  Widget userList(){
    return haveUserSearched ? ListView.builder(
        shrinkWrap: true,
        itemCount: searchByName(search.text),
        itemBuilder: (context, index){
          return ListTile(
            title: searchByName(search.text).documents[index].data["name"],
            subtitle: searchByName(search.text).documents[index].data["email"],
            
          );
        }) : Container();
  }

  @override
  void initState() {
    print("user id after login is: ${widget.uid}");
    super.initState();
    subToTopic(widget.uid);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(onPressed: (){
            FBAuth().logoutUser();
            unSubToTopic(widget.uid);
            },
              icon: Icon(Icons.logout)),
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:  Column(
          children: [
            Expanded(flex: 3,
              child: Container(
                child: Column(
                children: [
                  TextFormField(
                    controller: search,
                    decoration:  InputDecoration(
                        hintText: "search",
                        suffixIcon: IconButton(
                            onPressed: (){
                              // initiateSearch();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Search(search: search.text, uid: widget.uid, email: widget.email,)));
                            },
                            icon: Icon(Icons.search)
                        ),
                        border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: callingId,
                    decoration: const InputDecoration(
                        hintText: "Enter Call ID",
                        border: OutlineInputBorder()
                    ),
                  ),
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

                ],
              ),
            ),),
            Expanded(
              flex: 6,
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection("chatAppUsers").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (c, i) {
                        var result = snapshot.data!.docs[i];
                        return result['uid'] != widget.uid? Card(
                            elevation: 4,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: BorderSide(
                                    color: Colors.black,
                                    width: 1
                                )
                            ),
                            color: Color.fromARGB(162, 251, 253, 255),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              ("${result['email']}"),
                                            ),
                                            SizedBox(
                                              height: 8.0,
                                            ),
                                            Row(children: [
                                              IconButton(onPressed: (){}, icon: Icon(Icons.message_outlined)),
                                              IconButton(onPressed: (){
                                                print(result['uid']);
                                                callOnFcmApiSendPushNotifications(topic: result['uid'],title: 'Test Notification', body: 'Hi! This is Hassan XD');
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => VideoCalling(
                                                    callingID: result['uid']
                                                )
                                                )
                                                );

                                              }, icon: Icon(Icons.call))
                                            ],)

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )):SizedBox();
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator(color: Colors.black,));
                },
              ),
            ),
            // Expanded(
            //     flex: 4,
            //     child: StreamBuilder<QuerySnapshot>(
            //       stream: firestore.collection("chatAppUsers").snapshots(),
            //       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //         if (snapshot.hasData) {
            //           return userList();
            //         }
            //         return Center(child: CircularProgressIndicator(color: Colors.black,));
            //       },
            //     ))
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
  Future<bool> callOnFcmApiSendPushNotifications(
      {required String topic,required String title, required String body}) async {
    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "to": "/topics/$topic",
      "notification": {
        "title": title,
        "body": body,
      },
      "data": {
        "type": '0rder',
        "id": '28',
        "click_action": 'FLUTTER_NOTIFICATION_CLICK',
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
      'key=AAAACij4-PM:APA91bEbjQGqQXdlyeb3TdWLi3zN0koIpFjl686qUVl-ZcsS9QsTMvvJq4DcDT5o-oPgXpX0-TSlx_-kSeN6v24L55mTIAMpgNdQ2LFdYy9uAcRfzZRupcDwDf4JibjFWkeDfJhoQioH' // 'key=YOUR_SERVER_KEY'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }
}
