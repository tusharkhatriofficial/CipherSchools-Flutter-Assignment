import 'package:cipherx/constants/colors.dart';
import 'package:cipherx/helpers/auth_helper.dart';
import 'package:cipherx/screens/add_expense.dart';
import 'package:cipherx/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';
import 'add_income.dart';

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

    void deleteExpense(int index){
      print("Yayy! delete expense here!");
      //pass another month if not the current to delete data
      expenseProvider.deleteExpense(currentMonth, index);
    }


    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return AddExpense();
            }));
          },
        child: Icon(Icons.add, color: kPrimaryTextColor,),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xfffdf7eb),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 10.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWkpRcVB4hMuHQo3ZoEu0ySR4ZgHCYIz45QQ&s"),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_drop_down),
            Consumer<ExpenseProvider>(
                builder: (context, expenseProvider, child){
                  return Text(currentMonth.toString(), style: GoogleFonts.poppins(fontSize: 14.0),);
                }
            ),
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
      Scaffold(
        backgroundColor: Color(0xfffdf7eb),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Center(child: Text("Account Balance", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 18.0),)),
                SizedBox(height: 10.0,),
                Center(child: Text("₹ ${monthlyData.totalIncome - monthlyData.totalExpense}", style: GoogleFonts.poppins(fontSize: 55.0, fontWeight: FontWeight.w500),)),
                SizedBox(height: 10.0,),
                //Income and expense cards
                Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          //Income Card
                          Container(
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20.0)
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 10.0,),
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.arrow_downward),
                                  radius: 27.0,
                                ),
                                SizedBox(width: 10.0,),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Income", style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500),),
                                      Text("₹ ${monthlyData.totalIncome}", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                              child: IconButton(onPressed: (){
                                //TODO: Edit income
                                showAmountBottomSheet(context);

                              }, icon: Icon(Icons.edit, size: 30.0, color: kPrimaryTextColor,)),
                            right: 1.0,
                            top: 1.0,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20.0,),
                    //Expense Card
                    Expanded(
                      child: Container(
                        height: 100.0,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10.0,),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.arrow_upward),
                              radius: 27.0,
                            ),
                            SizedBox(width: 10.0,),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Expense", style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500),),
                                  Consumer<ExpenseProvider>(
                                      builder: (context, expenseProvider, child){
                                        return Text("₹ ${monthlyData.totalExpense}", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),);
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.0,),
                //Expenses List
                Column(
                  children: [
                    for(int i = 0; i <monthlyData.expenses.length; i++)...[
                      //Expense card with slide functionality
                      Slidable(
                        key: ValueKey(monthlyData.expenses[i].date.millisecondsSinceEpoch),
                        startActionPane: ActionPane(
                            motion:  ScrollMotion(),
                            children:  [
                              SlidableAction(
                                onPressed: (context) => {deleteExpense(i)},
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ]
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(12.0),
                          elevation: 1.0,
                          color: kPrimaryTextColor,
                          child: ListTile(
                            title: Text("${monthlyData.expenses[i].description}"),
                            subtitle: Text("${monthlyData.expenses[i].category}"),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("- ${monthlyData.expenses[i].amount}", style: GoogleFonts.poppins(fontSize: 18.0, color: Colors.red, fontWeight: FontWeight.w600),),
                                Text("${DateFormat.jm().format(monthlyData.expenses[i].date)}"),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,)
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
