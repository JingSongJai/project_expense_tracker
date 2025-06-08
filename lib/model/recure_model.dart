// ignore_for_file: public_member_api_docs, 1sort_constructors_first
import 'package:hive/hive.dart';

part 'recure_model.g.dart';

@HiveType(typeId: 3)
class RecureModel {
  RecureModel({
    required this.uuid,
    required this.title,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.frequency,
    required this.isRemind,
    required this.amount,
    required this.isPaused,
    required this.total,
  });

  @HiveField(0)
  int uuid;

  @HiveField(1)
  String title;

  @HiveField(2)
  String category;

  @HiveField(3)
  DateTime startDate;

  @HiveField(4)
  DateTime endDate;

  @HiveField(5)
  String frequency;

  @HiveField(6)
  bool isRemind;

  @HiveField(7)
  double amount;

  @HiveField(8)
  bool isPaused;

  @HiveField(9)
  double total;
}
