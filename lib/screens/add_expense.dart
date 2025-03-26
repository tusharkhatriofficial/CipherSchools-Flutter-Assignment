import 'package:cipherx/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';

class AddExpense extends StatefulWidget {

  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {

  final List<String> categories = [
    "Category",
    "Food",
    "Transport",
    "Shopping",
    "Entertainment"];


  @override
  Widget build(BuildContext context) {
    TextEditingController _descController = TextEditingController();
    TextEditingController _howMuchController = TextEditingController();
    final ValueNotifier<String?> selectedCategory = ValueNotifier<String?>(null);

    void addExpense(){
      //TODO: addExpense
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add Expense", style: GoogleFonts.poppins(color: Colors.white),),
        centerTitle: true,
        leading: IconButton( onPressed: (){Navigator.pop(context);},icon: Icon(Icons.arrow_back), color: Colors.white,),
        backgroundColor: kSecondaryColor,
        elevation: 0,
      ),
      backgroundColor: kSecondaryColor,
      body: Stack(
        children: [
          //Top part
          Container(
            height: 380.0,
            padding: const EdgeInsets.all(21.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("How Much?", style: GoogleFonts.poppins(fontSize: 25.0, color: Colors.white70, fontWeight: FontWeight.w400),),
                TextField(
                  controller: _howMuchController,
                  cursorHeight: 55.0,
                  cursorColor: kPrimaryTextColor,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: "₹ 0",
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 66.0, color: kPrimaryTextColor, fontWeight: FontWeight.w500),
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  ),
                  style: TextStyle(fontSize: 66.0, color: kPrimaryTextColor),
                )

              ],
            ),
          ),
          //Bottom Part
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 500.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0))
                ),
                child: Column(
                  children: [
                    SizedBox(height: 60.0,),
                    //Category dropdown
                    Padding(
                      padding: const EdgeInsets.all(21.0),
                      child: DropdownButtonFormField(
                        value: categories[0], // Default value
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          hintText: "Select Category",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        items: categories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (value) {
                          print(value);
                          if(value == "Category"){
                            selectedCategory.value = null;
                          }else{
                            selectedCategory.value = value;
                          }


                        },
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    //Description text box
                    Padding(
                      padding: const EdgeInsets.only(left: 21.0, right: 21.0),
                      child: TextField(
                        controller: _descController, // Controller for text handling
                        decoration: InputDecoration(
                          hintText: "Description",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30), // Rounded corners
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.deepPurple, width: 2), // Highlight color when focused
                          ),

                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Spacing inside field
                        ),

                        style: TextStyle(fontSize: 16), // Text style
                      ),
                    ),
                    SizedBox(height: 40.0,),
                    //Add Expense Button
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 21.0),
                      width: double.infinity,
                      height: 60.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kSecondaryColor
                        ),
                          onPressed: (){
                            //TODO: Add Expense
                            final expenseProvider =
                            Provider.of<ExpenseProvider>(context, listen: false);

                            expenseProvider.addExpense(
                              selectedCategory.value as String,
                              _descController.text,
                              double.tryParse(_howMuchController.text) ?? 0.0,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Expense Added Successfully!")),
                            );

                            Navigator.pop(context); // Go back after adding
                            print(
                              "${_howMuchController.text} and ${_descController.text} and ${selectedCategory.value}"
                            );
                          },
                          child: Text("Continue", style: GoogleFonts.poppins(fontSize: 21.0, color: kPrimaryTextColor),)
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
