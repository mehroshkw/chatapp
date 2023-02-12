import 'package:chatapp/calling_ui/invitation_screen.dart';
import 'package:chatapp/calling_ui/audio_calling.dart';
import 'package:chatapp/ui/chatrooms.dart';
import 'package:chatapp/ui/home.dart';
import 'package:chatapp/ui/signin.dart';
import 'package:chatapp/ui/signup.dart';
import 'package:chatapp/ui/test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', //id
    'High importance Notifications' //title
        'This channel is used for important notification.', // desscription
    importance: Importance.high,
    playSound: true
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var emails = prefs.getString("email");
  var uid = prefs.getString("uid");
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    // if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      // RemoteNotification? notification = message.notification;
      // flutterLocalNotificationsPlugin.show(
      //     notification.hashCode,
      //     notification?.title,
      //     notification?.body,
      //     NotificationDetails(
      //       android: AndroidNotificationDetails(
      //         channel.id,
      //         channel.name,
      //         color: Colors.blue,
      //         playSound: true,
      //         icon: '@mipmap/ic_launcher',
      //       ),
      //     )
      // );
      print('recieved');
      // Get.to(Test());
    Get.to(AudioCalling(callingID: uid.toString()));
    // Get.to(InvitationScreen());
    // }
  });

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black38,
        primaryColor: Colors.white,
      ),
    home: emails == null ? Signin() : Home(uid: uid!, email: emails!,),
  ));
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         scaffoldBackgroundColor: Colors.black38,
//         primaryColor: Colors.white,
//       ),
//       home: emails == null ? SignUp() : ChatRooms(),
//       // Signin(),
//     );
//   }
// }

