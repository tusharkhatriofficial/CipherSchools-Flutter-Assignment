import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';
import '../models/monthly_data.dart';

class ExpenseProvider extends ChangeNotifier {
  late Box<MonthlyData> _box;

  ExpenseProvider() {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox<MonthlyData>('monthly_data');
    _ensureCurrentMonthData();  // Ensure data is created when app starts
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
    return _box.get(monthYear);
  }

  // Add Expense
  Future<void> addExpense(String monthYear, Expense newExpense) async {
    MonthlyData? monthlyData = _box.get(monthYear);

    if (monthlyData == null) {
      await _ensureCurrentMonthData(); // Ensure it exists
      monthlyData = _box.get(monthYear);
    }

    monthlyData!.expenses.add(newExpense);
    monthlyData.totalExpense += newExpense.amount;
    monthlyData.categoryExpenses[newExpense.category] =
        (monthlyData.categoryExpenses[newExpense.category] ?? 0) + newExpense.amount;

    await _box.put(monthYear, monthlyData);
    notifyListeners();
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
