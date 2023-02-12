import 'package:chatapp/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'dart:math' as math;


class AudioCalling extends StatefulWidget {
  final String callingID;
  const AudioCalling({ required this.callingID});

  @override
  State<AudioCalling> createState() => _AudioCallingState();
}

class _AudioCallingState extends State<AudioCalling> {

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

          // config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
          //   ..onOnlySelfInRoom = (context) {
          //     Navigator.of(context).pop();
          //   },

          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
          ..onOnlySelfInRoom = (context){
            Navigator.of(context).pop();
          }
          // ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
          //   hideAutomatically: false,
          //   hideByClick: false,
          // )
            ..turnOnCameraWhenJoining = false
            // ..turnOnMicrophoneWhenJoining = false
          ..audioVideoViewConfig = ZegoPrebuiltAudioVideoViewConfig(
            backgroundBuilder: (BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo){
              return Container(
                height: Get.height * 1,
                width: Get.width * 1,
                color: Colors.green,
              );
            },
            // foregroundBuilder: (BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo){
            //   return SizedBox();
            // }
            foregroundBuilder: (BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo){
              return Container(
                height: Get.height * 1,
                width: Get.width * 1,
                color: Colors.black,
              );
            }
          )

          // ..avatarBuilder= (BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo){
          //   return user != null
          //       ? Container(
          //     height: 200,
          //     width: 50,
          //   )
          //       :  SizedBox();
          // },
        ),
      ),
    );
  }
}
