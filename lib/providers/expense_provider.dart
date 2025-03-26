import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';
import '../models/monthly_data.dart';

class ExpenseProvider extends ChangeNotifier {
  late Box<MonthlyData> _box;
  bool _isInitialized = false;

  ExpenseProvider() {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox<MonthlyData>('monthly_data');
    _ensureCurrentMonthData();  // Ensure data is created when app starts
    _isInitialized = true;
    notifyListeners();
  }

  // Ensure current month has data in Hive
  Future<void> _ensureCurrentMonthData() async {
    String currentMonth = getCurrentMonthYear();

    if (!_box.containsKey(currentMonth)) {
      await _box.put(
        currentMonth,
        MonthlyData(
          monthYear: currentMonth,
          totalIncome: 0,
          totalExpense: 0,
          categoryExpenses: {},
          expenses: [],
        ),
      );
      notifyListeners();
    }
  }

  // Function to get current month in "March 2025" format
  String getCurrentMonthYear() {
    DateTime now = DateTime.now();
    List<String> monthNames = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return "${monthNames[now.month - 1]} ${now.year}";
  }

  // Get Monthly Data
  MonthlyData? getMonthlyData(String monthYear) {
    if(!_isInitialized) return null;
    return _box.get(monthYear);
  }

  // Add Expense
  Future<void> addExpense(String category, String description, double amount) async {
    final box = Hive.box<MonthlyData>('monthly_data');

    String currentMonth = getCurrentMonthYear();

    // Get existing MonthlyData for the month or create a new one
    MonthlyData? monthlyData = box.get(currentMonth);

    if (monthlyData == null) {
      monthlyData = MonthlyData(
        monthYear: currentMonth,
        totalIncome: 0.0,
        totalExpense: 0.0,
        categoryExpenses: {},
        expenses: [],
      );
    }

    // Create a new Expense object
    Expense newExpense = Expense(
      category: category,
      description: description,
      amount: amount,
      date: DateTime.now(),
    );

    // Add new expense to the expenses list
    monthlyData.expenses.add(newExpense);

    // Update category-wise expenses
    monthlyData.categoryExpenses[category] =
        (monthlyData.categoryExpenses[category] ?? 0) + amount;

    // Update total expense
    monthlyData.totalExpense += amount;

    // Save updated data back to Hive
    await box.put(currentMonth, monthlyData);
    notifyListeners();

    print("Expense added to ${monthlyData.monthYear}");
  }

  void deleteExpense(String monthYear, int index) {
    MonthlyData? monthlyData = _box.get(monthYear);

    if (monthlyData != null && index >= 0 &&
        index < monthlyData.expenses.length) {
      //Subtract deleted items cost from total expense
      double deletedAmount = monthlyData.expenses[index].amount;

      // Remove the expense
      monthlyData.expenses.removeAt(index);

      // Update total expense
      monthlyData.totalExpense -= deletedAmount;

      _box.put(monthYear, monthlyData); // Update Hive
      notifyListeners(); // Notify the UI to refresh
    }
  }


  // Update Income
  Future<void> updateMonthlyIncome(String monthYear, double income) async {
    MonthlyData? monthlyData = _box.get(monthYear);

    if (monthlyData != null) {
      monthlyData.totalIncome = income;
      await _box.put(monthYear, monthlyData);
      notifyListeners();
    }
  }
}
