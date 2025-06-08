import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 1)
class ExpenseModel {
  ExpenseModel({
    this.uuid,
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

  @HiveField(4)
  int? uuid;

  Map<String, dynamic> toJson() {
    return {
      'id': uuid,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
    };
  }
}
