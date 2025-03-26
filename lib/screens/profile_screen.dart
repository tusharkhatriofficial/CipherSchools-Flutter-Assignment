import 'package:cipherx/constants/colors.dart';
import 'package:cipherx/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../helpers/auth_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future<Map<String, String>?> fetchUserData() async {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (uid.isEmpty) return null;
    try {
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (userDoc.exists) {
        return {
          "name": userDoc["name"] ?? "No Name",
          "email": userDoc["email"] ?? "No Email",
        };
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }


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
            FutureBuilder(
                future: fetchUserData(),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text("Error loading profile"));
                  }
                  final userData = snapshot.data!;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 55.0,
                        backgroundImage: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWkpRcVB4hMuHQo3ZoEu0ySR4ZgHCYIz45QQ&s",
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text("@USER${FirebaseAuth.instance.currentUser!.uid.substring(0, 5)}",
                              style: GoogleFonts.poppins(fontSize: 15.0)),
                          subtitle: Text(userData["name"]!,
                              style: GoogleFonts.poppins(fontSize: 25.0)),
                          trailing: Icon(Icons.edit, size: 40.0, color: kPrimaryColor),
                        ),
                      ),
                    ],
                  );
                }
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
                    child: InkWell(
                      onTap: (){
                        logout(context);
                      },
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
