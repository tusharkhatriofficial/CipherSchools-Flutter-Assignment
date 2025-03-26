import 'package:cipherx/helpers/auth_helper.dart';
import 'package:cipherx/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void logout(BuildContext context) async {
    bool isSignedOut = await signOut();
    if(isSignedOut == true){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return WelcomeScreen();
      }));
    }else{
      print("Error signing out");
    }
  }

  @override
  Widget build(BuildContext context) {
    String? user = FirebaseAuth.instance.currentUser!.email;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Hello, ${user}")),
          ElevatedButton(
            onPressed: () async {
              //TODO: signuout
              logout(context);
            },
            child: Text("Logout"),
          ),

        ],
      ),
    );
  }
}
