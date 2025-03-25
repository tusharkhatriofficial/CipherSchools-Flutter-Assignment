import 'package:cipherx/constants/colors.dart';
import 'package:cipherx/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(21.0),
          child: Stack(
            children: [
              Image.asset(
                "assets/images/cypherx.png",
                height: 75.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Welcome to\n CypherX.",
                        style: GoogleFonts.poppins(
                            fontSize: 41.0,
                            color: kPrimaryTextColor,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 20.0,),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return SignupScreen();
                          }));
                        },
                        child: CircleAvatar(
                          radius: 50.0,
                            backgroundColor: Color(0xffD0C1E9),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 50.0,
                              color: kPrimaryIconColor,
                                ),),
                      ),
                    ],
                  ),
                  Text(
                    "The best way to track your expanses.",
                    style: GoogleFonts.poppins(
                        fontSize: 21.0, color: kPrimaryTextColor),
                  ),
                  SizedBox(
                    height: 40.0,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
