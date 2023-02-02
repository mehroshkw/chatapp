import 'package:chatapp/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'dart:math' as math;

import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';


class InvitationScreen extends StatefulWidget {
  const InvitationScreen({Key? key}) : super(key: key);

  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  final String localUserID = math.Random().nextInt(10000).toString();

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCallWithInvitation(
      appID: Utils.appid,
      appSign: Utils.appSign,
      userID: localUserID,
      userName: "user_$localUserID",
      plugins: [ZegoUIKitSignalingPlugin()],
      // Modify your custom configurations here.
      ringtoneConfig: const ZegoRingtoneConfig(
        incomingCallPath: "assets/ringtone/incomingCallRingtone.mp3",
        outgoingCallPath: "assets/ringtone/outgoingCallRingtone.mp3",
      ),
      child: Container(
        width: Get.width * 1,
        height: 200,
        color: Colors.red,
      ),
    );
  }
}
