import 'dart:developer';
import 'dart:math';

import 'package:expanse_tracker/data/box.dart';
import 'package:expanse_tracker/data/constant.dart';
import 'package:expanse_tracker/model/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper {
  Helper._();

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

  static Map<String, double> getStaticByWeek() {
    var expenses = (expenseBox.values.toList() as List<ExpenseModel>);
    Map<String, double> data = {};
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
      double total = filter.fold(
        0,
        (previousValue, element) => previousValue + element.amount,
      );
      data[DateFormat('EEE').format(startDay)] = total;
      startDay = startDay.add(Duration(days: 1));
    }

    return data;
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

    return data
        .where((d) => isExpense ? d['total'] < 0 : d['total'] > 0)
        .toList();
  }
}
