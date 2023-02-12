
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'dart:math' as math;
import '../utils.dart';

class VideoCalling extends StatefulWidget {
  final String callingID;
   VideoCalling({ required this.callingID});

  @override
  State<VideoCalling> createState() => _VideoCallingState();
}

class _VideoCallingState extends State<VideoCalling> {
  final String localUserID = math.Random().nextInt(10000).toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ZegoUIKitPrebuiltCall(
            appID: Utils.appid,
            appSign:Utils.appSign,
            userID: localUserID,
            userName: "user_$localUserID",
            callID: widget.callingID,
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            ..onOnlySelfInRoom = (context) {
              Navigator.of(context).pop();
            },
    ),
        ),
      );
  }
}
