import 'package:cipherx/constants/colors.dart';
import 'package:cipherx/screens/home_screen.dart';
import 'package:cipherx/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/auth_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    void signinWithGoogle() async {
      UserCredential? userCredential = await signInWithGoogle();
      if(userCredential != null){
        await saveUserUID(userCredential.user!.uid);
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return HomeScreen();
        }));
      }else{
        print("Sign-In Failed");
      }
    }

    void signinWithEmailPassword() async {
      UserCredential? userCredential = await signInWithEmailAndPassword(_emailController.text, _passwordController.text);
      if (userCredential != null) {
        await saveUserUID(userCredential.user!.uid);
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return HomeScreen();
        }));
      } else {
        print("Sign-In failed");
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundWhite,
        elevation: 0,
        title: Text("Login", style: GoogleFonts.poppins(),),
        centerTitle: true,
      ),
      body: Scaffold(
        backgroundColor: kBackgroundWhite,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(21.0),
              child: Column(
                children: [
                  SizedBox(height: 60,),
                  //Email
                  CustomTextField(
                      hintText: "Email",
                      obscureText: false,
                      nameController: _emailController),
                  SizedBox(height: 20,),
                  CustomTextField(
                      hintText: "Password",
                      obscureText: true,
                      suffixIcon: Icon(Icons.remove_red_eye),
                      nameController: _passwordController
                  ),
                  SizedBox(height: 40.0,),
                  //Signup Button
                  Container(
                    height: 70.0,
                    width:double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        //TODO: Signup using email and password
                        signinWithEmailPassword();
                      },
                      child: Text("Login", style: GoogleFonts.poppins(color: kPrimaryTextColor, fontSize: 22.0),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Text("Or with", style: GoogleFonts.poppins(fontSize: 18.0),),
                  SizedBox(height: 20.0,),
                  //Google Signup button
                  Container(
                    height: 70.0,
                    width:double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        //TODO: Signup with google
                        signinWithGoogle();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network("https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png"),
                          Text("Login using Google", style: GoogleFonts.poppins(color: Colors.black, fontSize: 22.0,),),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Create new account |  ", style: GoogleFonts.poppins(fontSize: 18.0),),
                      InkWell(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                            return SignupScreen();
                          }));
                        },
                        child: Text("Sign Up", style: GoogleFonts.poppins(
                            fontSize: 18.0,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue
                        ),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required TextEditingController nameController,
    this.suffixIcon
  }) : _nameController = nameController;

  final TextEditingController _nameController;
  final String? hintText;
  final bool obscureText;
  Widget? suffixIcon = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: _nameController,
        obscureText: obscureText,
        decoration: InputDecoration(
          suffixIcon:  suffixIcon,
          border: OutlineInputBorder(
            borderRadius:  BorderRadius.circular(21.0),
          ),
          filled: false,
          hintStyle: GoogleFonts.poppins(color: Colors.grey),
          hintText: hintText,
          focusedBorder:  OutlineInputBorder(
            borderRadius:  BorderRadius.circular(21.0),
            borderSide:  BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
