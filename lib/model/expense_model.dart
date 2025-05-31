import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 1)
class ExpenseModel {
  ExpenseModel({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  @HiveField(0)
  String title;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String category;

  @HiveField(3)
  DateTime date;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
    };
  }
}
