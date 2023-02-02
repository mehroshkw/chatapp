import 'package:chatapp/ui/chatrooms.dart';
import 'package:chatapp/ui/home.dart';
import 'package:chatapp/ui/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FBAuth{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      User? user = result.user;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("email",emailController.text );
      prefs.setString("uid","${user?.uid.toString()}" );
      if (user != null) {
        print("login user catch id: ${user?.uid.toString()}");
        Get.to(Home(uid: '${user?.uid}',));
      } else {
        print('Error in Creating Account');
      }
      print(user?.uid.toString());
      return user;

    } catch (e) {
      print('testing ${e.toString()}');
      return  Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

  }

  Future signUpWithEmailAndPassword(String email, String password, String name) async {
    try {
      FirebaseFirestore firestore;
      final user = await _auth.createUserWithEmailAndPassword(
        // email: emailController.text, password: passwordController.text).whenComplete(() => Get.to(Login()));
          email: emailController.text,
          password: passwordController.text,

      ).then((value) {
        firestore = FirebaseFirestore.instance;
        firestore.collection('chatAppUsers').doc(value.user!.uid).set(
            {"uid": value.user!.uid.toString(),
              "email": emailController.text,
              "password": passwordController.text,
            "name" : nameController.text
            });
        if (value.user != null) {
          Get.to(Signin());
        } else {
          print('Error in Creating Account');
        }
      });
    } catch (e) {
      String getMessageFromErrorCode() {
        switch (e) {
          // case "ERROR_EMAIL_ALREADY_IN_USE":
          // case "account-exists-with-different-credential":
          case "email-already-in-use":
            return "Email already used. Go to login page.";
            break;
          // case "ERROR_WRONG_PASSWORD":
          case "wrong-password":
            return "Wrong email/password combination.";
            break;
          // case "ERROR_USER_NOT_FOUND":
          case "user-not-found":
            return "No user found with this email.";
            break;
          // case "ERROR_USER_DISABLED":
          case "user-disabled":
            return "User disabled.";
            break;
          // case "ERROR_TOO_MANY_REQUESTS":
          case "operation-not-allowed":
            return "Too many requests to log into this account.";
            break;
          // case "ERROR_OPERATION_NOT_ALLOWED":
          case "operation-not-allowed":
            return "Server error, please try again later.";
            break;
          // case "ERROR_INVALID_EMAIL":
          case "invalid-email":
            return "Email address is invalid.";
            break;
          default:
            return "Login failed. Please try again.";
            break;
        }
      }
      print(e.toString());
      return  Fluttertoast.showToast(
          msg: getMessageFromErrorCode().toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.offAll(Signin());
  }

  Future<void> sendpasswordresetemail(String email) async{
    await _auth.sendPasswordResetEmail(email: email).then((value) {
      Get.offAll(Signin());
      Get.snackbar("Password Reset email link is been sent", "Success");
    }).catchError((onError)=> Get.snackbar("Error In Email Reset", onError.message) );
  }
}