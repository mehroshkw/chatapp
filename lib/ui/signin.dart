import 'package:chatapp/ui/signup.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../services/auth.dart';

class Signin extends StatefulWidget {
   Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();

}

class _SigninState extends State<Signin> {
  final formKey = GlobalKey<FormState>();

  FBAuth authController = FBAuth();
  String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  Future<void> validate(String email, String password) async {
    if (formKey.currentState!.validate()) {
      // authController.emailController.toString();
      authController.signInWithEmailAndPassword(email, password);
      print("Success");
    }
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: appBarMain(context),
      ),
      body: Container(
        height: height/2,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
key:formKey ,
                child: Column(children: [
                  TextFormField(
                    controller: authController.emailController,
                    validator: (v) {
                      if (authController.emailController.text.isEmpty) {
                        return "Please Enter the Email";
                      }else if (!authController.emailController.text.isEmail){
                        return "Please Enter a Valid Email";
                      }
                    },
                style: TextStyle(
                    color: Colors.white
                ),
                // controller: ,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(fontSize: 16.0, color: Colors.white),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white
                      )
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white
                      )
                  ),
                ),
              ),
                   TextFormField(
                     controller: authController.passwordController,
                     validator: (v) {
                       if (authController.emailController.text.isEmpty) {
                         return "Please Enter the Password";
                       }else if(!RegExp(pattern).hasMatch(authController.passwordController.text)){
                         return "Password Must contain 1 Uppercase, 1 symbol and length must be 8";
                       }
                     },
                     obscureText: true,
                style: TextStyle(
                    color: Colors.white
                ),
                // controller: ,
                // obscuringCharacter: ,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(fontSize: 16.0, color: Colors.white),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white
                      )
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white
                      )
                  ),
                ),
              ),
            ],
            )
            ),

            SizedBox(height: 20 ,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: (){}, child: Text("Forgot Password?",
                style: TextStyle(
                  color: Colors.white
                ),
                )),

              ],
            ),
            SizedBox(height: 20 ,),
            GestureDetector(
              onTap: () {
                // signIn();
                validate(authController.emailController.text, authController.passwordController.text);
                Fluttertoast.showToast(
                    msg: "Checking Authentications",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xff007EF4),
                        const Color(0xff2A75BC)
                      ],
                    )),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Sign In",
                  style: biggerTextStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 20 ,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Sign In with Google",
                style:
                TextStyle(fontSize: 17, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have account? ",
                  style: simpleTextStyle(),
                ),
                GestureDetector(
                  onTap: () {
                    // widget.toggleView();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  child: Text(
                    "Register now",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            // SizedBox(
            //   height: 50,
            // )
          ],
        ),
      ),
    );
  }
}
