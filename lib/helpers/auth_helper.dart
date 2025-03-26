import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Shared preference
Future<String?> getUserUID() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_uid');
}


Future<void> saveUserUID(String uid) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_uid', uid);
  print("User Session saved offline");
}

//Signup with google
Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Creating credential for Firebase authentication
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in with the Google credential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    print("Google Sign-In Error: $e");
    return null;
  }
}


//Signup with Email and password
Future<UserCredential?> signupWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  } catch (e) {
    print("Sign-Up Error: $e");
    return null;
  }
}

Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  } catch (e) {
    print("Sign-Up Error: $e");
    return null;
  }
}

Future<bool> signOut() async {
  try{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await FirebaseAuth.instance.signOut();
    await prefs.remove("user_uid");
    print("User id is now set to: ${prefs.get("user_uid")}");
    return true;
  }catch(e){
    print("Error Signing out!");
    return false;
  }

}