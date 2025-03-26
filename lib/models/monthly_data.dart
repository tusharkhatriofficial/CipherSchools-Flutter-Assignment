import 'package:hive/hive.dart';
import 'expense.dart';
part 'monthly_data.g.dart';

@HiveType(typeId: 2)
class MonthlyData {
  @HiveField(0)
  String monthYear;

  @HiveField(1)
  double totalIncome;

  @HiveField(2)
  double totalExpense;

  @HiveField(3)
  Map<String, double> categoryExpenses; // Category-wise expenses

  @HiveField(4)
  List<Expense> expenses; // List of expenses

  MonthlyData({
    required this.monthYear,
    required this.totalIncome,
    required this.totalExpense,
    required this.categoryExpenses,
    required this.expenses,
  });
}
