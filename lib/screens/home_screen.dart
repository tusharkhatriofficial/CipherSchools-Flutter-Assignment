import 'package:cipherx/helpers/auth_helper.dart';
import 'package:cipherx/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';

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
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    String currentMonth = expenseProvider.getMonthlyData(expenseProvider.getCurrentMonthYear())?.monthYear ?? "Unknown";
    final monthlyData = expenseProvider.getMonthlyData(currentMonth);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 10.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWkpRcVB4hMuHQo3ZoEu0ySR4ZgHCYIz45QQ&s"),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.arrow_drop_down)),
            Text(currentMonth.toString(), style: GoogleFonts.poppins(fontSize: 14.0),),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.notifications, size: 29.0,))
        ],
      ),
      //monthlyData is null
      body: monthlyData == null? Center(child: Text("No data found for $currentMonth"))
          :
          //monthly data is not null (btw it wont be null in any case.)
      Column(
        children: [

        ],
      )
    );
  }
}
