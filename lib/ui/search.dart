import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/database.dart';

class Search extends StatefulWidget {
  final String search;
   Search({Key? key, required this.search});

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
        .collection("users")
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
                        trailing: IconButton(onPressed: (){}, icon: Icon(Icons.message_outlined),
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
