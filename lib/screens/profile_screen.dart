import 'package:cipherx/constants/colors.dart';
import 'package:cipherx/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../helpers/auth_helper.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    void logout(BuildContext context) async {
      bool isSignedOut = await signOut();
      if(isSignedOut == true){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()), // Replace with your Welcome screen
              (route) => false, // Removes all previous routes
        );
      }else{
        print("Error signing out");
      }
    }

    return Scaffold(
      backgroundColor: Color(0xfffdf7eb),
      appBar: AppBar(
        backgroundColor: Color(0xfffdf7eb),
      ),
      body: Padding(
        padding: const EdgeInsets.all(21.0),
        child: Column(
          children: [
            //User details row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 55.0,
                  backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWkpRcVB4hMuHQo3ZoEu0ySR4ZgHCYIz45QQ&s"),
                ),
                Expanded(
                  child: ListTile(
                    title: Text("@USER${(FirebaseAuth.instance.currentUser!.uid).substring(0, 5)}", style: GoogleFonts.poppins(fontSize: 15.0),),
                    subtitle: Text("${(FirebaseAuth.instance.currentUser!.displayName!).substring(0, 9)}..", style: GoogleFonts.poppins(fontSize: 30.0),),
                    trailing: Icon(Icons.edit, size: 40.0, color: kPrimaryColor,),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.0,),
            //Additional Options
            Container(
              height: 300.0,

              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(21.0)
              ),
              child: ListView(
                children: [
                  //Logout tile
                  Padding(
                    padding: const EdgeInsets.all(21.0),
                    child: Material(
                      elevation: 0.5,
                      color: kPrimaryTextColor,
                      shadowColor: kPrimaryColor,
                      borderRadius: BorderRadius.circular(21.0),
                      child: ListTile(
                        title: Text("Logout"),
                        trailing: InkWell(
                          onTap: (){
                            logout(context);
                          },
                            child: Icon(Icons.logout)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
