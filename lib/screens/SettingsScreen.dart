import 'package:basecode/services/AuthService.dart';
import 'package:basecode/services/LocalStorageService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'LoginScreen.dart';

class SettingsScreen extends StatefulWidget {
  static String routeName = "/settings";

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: ElevatedButton(
            onPressed: () async {
              await authService.logout();
              LocalStorageService.setName("");
              LocalStorageService.setUid("");
              Get.offAllNamed(LoginScreen.routeName);
            },
            child: Text("Logout"),
          ),
        ),
      ),
    );
  }
}
