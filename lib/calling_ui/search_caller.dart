import 'package:chatapp/calling_ui/video_calling.dart';
import 'package:flutter/material.dart';

class SearchCaller extends StatefulWidget {
  const SearchCaller({Key? key}) : super(key: key);

  @override
  State<SearchCaller> createState() => _SearchCallerState();
}

class _SearchCallerState extends State<SearchCaller> {
  final callingId = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VideoCalling(callingID: callingId.text.toString())));
                },
                child: Text(
                    "Join"
                )
            )
          ],
        ),
      ),
    );
  }
}
