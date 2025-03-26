import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 3) // Unique typeId for Expense model
class Expense {
  @HiveField(0)
  String category;

  @HiveField(1)
  String description;

  @HiveField(2)
  double amount;

  @HiveField(3)
  DateTime date; // Timestamp of the expense

  Expense({
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
  });

  @override
  String toString() {
    return 'Expense(category: $category, description: $description, amount: $amount, date: $date)';
  }
}
