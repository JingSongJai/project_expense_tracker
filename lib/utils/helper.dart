import 'dart:developer';
import 'dart:math';

import 'package:expanse_tracker/data/box.dart';
import 'package:expanse_tracker/data/constant.dart';
import 'package:expanse_tracker/main.dart';
import 'package:expanse_tracker/model/expense_model.dart';
import 'package:expanse_tracker/model/recure_model.dart';
import 'package:expanse_tracker/view/main_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper {
  Helper._();

  static ValueNotifier<List<dynamic>> alerts = ValueNotifier([]);

  static double getCategoryTotal(String category) {
    var expenses =
        (expenseBox.values.toList() as List<ExpenseModel>)
            .where((expense) => expense.category == category)
            .toList();

    double total = 0.0;

    total = expenses.fold(
      0,
      (previousValue, element) => previousValue + element.amount,
    );

    return total;
  }

  static double getTotalExpense() {
    var expenses =
        (expenseBox.values.toList() as List<ExpenseModel>)
            .where((expense) => expense.amount < 0)
            .toList();

    double total = 0.0;

    total = expenses.fold(
      0,
      (previousValue, element) => previousValue + element.amount,
    );

    return total;
  }

  static double getTotalIncome() {
    var expenses =
        (expenseBox.values.toList() as List<ExpenseModel>)
            .where((expense) => expense.amount > 0)
            .toList();

    double total = 0.0;

    total = expenses.fold(
      0,
      (previousValue, element) => previousValue + element.amount,
    );

    return total;
  }

  static double getTotal() {
    var expenses = (expenseBox.values.toList() as List<ExpenseModel>);

    double total = 0.0;

    total = expenses.fold(
      0,
      (previousValue, element) => previousValue + element.amount,
    );

    return total;
  }

  static List<BarChartGroupData> getStaticByWeek() {
    var expenses = (expenseBox.values.toList() as List<ExpenseModel>);
    List<BarChartGroupData> data = [];
    DateTime startDay = DateTime.now().subtract(
      Duration(days: DateTime.now().weekday - 1),
    );

    for (int i = 0; i < 7; i++) {
      var filter = expenses.where(
        (expense) =>
            DateFormat('yyyy-MM-dd')
                .format(expense.date)
                .compareTo(DateFormat('yyyy-MM-dd').format(startDay)) ==
            0,
      );

      double y1 = filter
          .where((value) => value.amount < 0)
          .toList()
          .fold(0, (a, b) => a + b.amount);

      double y2 = filter
          .where((value) => value.amount > 0)
          .toList()
          .fold(0, (a, b) => a + b.amount);

      print('$y1 : $y2');

      data.add(_makeGroupData(i, y1, y2));
      startDay = startDay.add(Duration(days: 1));
    }

    return data;
  }

  static BarChartGroupData _makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 0,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.redAccent,
          width: 7,
          borderRadius: BorderRadius.circular(0),
        ),
        BarChartRodData(
          toY: y2,
          color: Colors.green,
          width: 7,
          borderRadius: BorderRadius.circular(0),
        ),
      ],
    );
  }

  static List<Map<String, dynamic>> getAmountByCategory(bool isExpense) {
    var expenses = (expenseBox.values.toList() as List<ExpenseModel>);
    List<Map<String, dynamic>> data = [];

    var categories =
        expenses.map((expense) => expense.category).toList().toSet();

    for (var category in categories) {
      double total = expenses
          .where((expense) => expense.category == category)
          .toList()
          .fold(0, (a, b) => a + b.amount);

      data.add({
        'category': category,
        'total': total,
        'color':
            Constant.expenseCategories.singleWhere(
              (cate) => cate['name'] == category,
              orElse: () => {'color': Colors.blue},
            )['color'],
      });
    }

    var tmp =
        data.where((d) => isExpense ? d['total'] < 0 : d['total'] > 0).toList();

    if (tmp.length > 5) {
      tmp.sort((a, b) => b['total'].compareTo(a['total']));

      print('Length : ${tmp.length}');
      data = tmp.getRange(0, 4).toList();

      var other = tmp.getRange(4, tmp.length);

      data.add({
        'category': 'Other',
        'total': other.fold(0.0, (a, b) => a + b['total']),
        'color': Colors.grey,
      });
    }

    print(
      isExpense
          ? data.where((d) => d['total'] < 0).toList().length
          : data.where((d) => d['total'] > 0).toList().length,
    );

    return data
        .where((d) => isExpense ? d['total'] < 0 : d['total'] > 0)
        .toList();
  }

  static void getNotification() {
    alerts.value = [
      ...categories.value.where((category) {
        return (category.budget != null && category.spent != null) &&
            (category.budget! + category.spent! <= 0);
      }),
    ];
  }

  static Duration getDuration(String frequency, DateTime startDate) {
    Duration duration = Duration(days: 1);

    switch (frequency.trim()) {
      case 'Weekly':
        duration = Duration(days: 7);
        break;
      case 'Monthly':
        duration = Duration(
          days: getDaysInMonth(startDate.year, startDate.month),
        );
        break;
      case 'Yearly':
        duration = Duration(days: getDaysInYear(startDate.year));
        break;
    }
    return duration;
  }

  static int getDaysInMonth(int year, int month) {
    return DateTime(year, month, 0).day;
  }

  static int getDaysInYear(int year) {
    return DateTime(year, 2, 29).month == 2 ? 366 : 365;
  }

  static Future<void> updateRecurePause(
    RecureModel recure,
    String value,
  ) async {
    final key = recureBox.keys.singleWhere(
      (key) => recureBox.get(key).uuid == recure.uuid,
    );

    if (key == null) return;

    final updatedRecure = recureBox.get(key);

    if (value == 'Pause') {
      updatedRecure.isPaused = false;
      await recureBox.put(key, updatedRecure);
    } else {
      updatedRecure.isPaused = true;
      await recureBox.put(key, updatedRecure);
    }

    recures.value = recureBox.values.toList() as List<RecureModel>;
  }

  static int getAmountOfScheduledNotification(RecureModel recure) {
    double amount = 0;
    String frequency = recure.frequency;
    DateTime startDate = recure.startDate, endDate = recure.endDate;

    final remainDay = endDate.difference(startDate);

    amount = remainDay.inDays / getDuration(frequency, startDate).inDays;

    return amount.floor();
  }
}
