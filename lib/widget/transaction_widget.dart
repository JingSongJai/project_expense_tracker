import 'dart:math';
import 'package:expanse_tracker/data/box.dart';
import 'package:expanse_tracker/main.dart';
import 'package:expanse_tracker/model/category_model.dart';
import 'package:expanse_tracker/model/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../data/constant.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    super.key,
    required this.expense,
    required this.index,
    required this.isEdited,
  });
  final ExpenseModel expense;
  final int index;
  final bool isEdited;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  final _data = ['Edit', 'Delete'];
  late CategoryModel category;

  @override
  void initState() {
    super.initState();
    category = categories.value.singleWhere(
      (cate) => cate.name.compareTo(widget.expense.category) == 0,
      orElse: () => categories.value[0],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border(),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(category.color ?? 0xFF000000),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(category.icon),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.expense.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.expense.category,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                    color: Color(0xFFA3A3A3),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'amount'.trParams({
                  'number':
                      !widget.expense.amount.isNaN
                          ? widget.expense.amount.toInt().toString()
                          : widget.expense.amount.toStringAsFixed(2),
                }),
                style: TextStyle(
                  color:
                      widget.expense.amount.isNegative
                          ? Colors.redAccent
                          : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('yyyy-MM-dd').format(widget.expense.date),
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 13,
                  color: Color(0xFFA3A3A3),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          if (widget.isEdited)
            PopupMenuButton(
              iconSize: 20,
              itemBuilder: (context) {
                return _data
                    .map(
                      (d) => PopupMenuItem(
                        value: d.tr,
                        child: Text(d.tr, style: TextStyle(fontSize: 12)),
                      ),
                    )
                    .toList();
              },
              color: Colors.white,
              onSelected: (value) async {
                if (value == 'Delete'.tr) {
                  final key = expenseBox.keys.firstWhere(
                    (key) => expenseBox.get(key).uuid == widget.expense.uuid,
                  );
                  if (key != null) {
                    await expenseBox.delete(key);
                    expenses.value =
                        expenseBox.values.toList() as List<ExpenseModel>;
                  }
                }
              },
            ),
        ],
      ),
    );
  }
}
