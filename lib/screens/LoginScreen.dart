import 'package:basecode/screens/DashboardScreen.dart';
import 'package:basecode/screens/ForgotPasswordScreen.dart';
import 'package:basecode/screens/RegistrationScreen.dart';
import 'package:basecode/services/AuthService.dart';
import 'package:basecode/services/LocalStorageService.dart';
import 'package:basecode/widgets/SecondaryButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../widgets/PrimaryButton.dart';
import '../widgets/CustomTextFormField.dart';
import '../widgets/PasswordField.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  AuthService authService = AuthService();
  bool _obscureText = true;
  bool isLogginIn = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
    child: ModalProgressHUD(inAsyncCall: isLogginIn,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  CustomTextFormField(
                      labelText: "Email",
                      hintText: "Enter a valid email.",
                      iconData: FontAwesomeIcons.solidEnvelope,
                      controller: TextEditingController()),
                  SizedBox(
                    height: 20.0,
                  ),
                  PasswordField(
                      obscureText: _obscureText,
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      labelText: "Password",
                      hintText: "Enter your password",
                      controller: TextEditingController()),
                  SizedBox(
                    height: 20.0,
                  ),
                  PrimaryButton(
                      text: "Login",
                      iconData: FontAwesomeIcons.doorOpen,
                      onPress: logIn),
                  SizedBox(
                    height: 20.0,
                  ),
                  PrimaryButton(
                      text: "Sign-in with Google",
                      iconData: FontAwesomeIcons.google,
                      onPress: login),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SecondaryButton(
                          text: "New User? Register",
                          onPress: () {
                            Get.offNamed(RegistrationScreen.routeName);
                          }),
                      SecondaryButton(
                          text: "Forgot Password?",
                          onPress: () {
                            Get.toNamed(ForgotPasswordScreen.routeName);
                          }),
                    ],
                  ),
                ],
              )),
            ),
          ),
        ),
      ),
    )
    );
  }

  logIn() async {
    try {
  UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: "barry.allen@example.com",
    password: "SuperSecretPassword!"
  );
  } on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    print('No user found for that email.');
  } else if (e.code == 'wrong-password') {
    print('Wrong password provided for that user.');
  }
}
   Get.offNamed(DashboardScreen.routeName);
  }

  login() async {
    try {
      setState(() {
        isLogginIn = true;
      });
      var user = await authService.signInWithGoogle();

      if(user == null) {
        print("Invalid user credentials");
        return;
      }

      LocalStorageService.setName(user.user.displayName);
      LocalStorageService.setUid(user.user.uid);

      Get.offNamed(DashboardScreen.routeName);
    } catch (e) {
      print(e.toString());
    }
    setState(() {
        isLogginIn = false;
      });
  }
}
