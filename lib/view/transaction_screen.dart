import 'dart:developer';

import 'package:expanse_tracker/data/box.dart';
import 'package:expanse_tracker/main.dart';
import 'package:expanse_tracker/widget/transaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return _buildItems();
  }

  final _dataSort = ['Date', 'Name', 'Category', 'Amount'];
  final _dataGroup = ['Day', 'Month', 'Year', 'Category'];

  bool isShowCheckBox = false;

  Widget _buildItems() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Text(
                'Transactions',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              _buildGroup(),
              const SizedBox(width: 10),
              _buildSort(),
            ],
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder(
            valueListenable: expenses,
            builder: (context, value, child) {
              return Expanded(
                child: ListView.builder(
                  itemCount: expenses.value.length,
                  itemBuilder:
                      (context, index) => TransactionItem(
                        expense: expenses.value[index],
                        index: index,
                        isEdited: true,
                      ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSort() {
    return PopupMenuButton(
      tooltip: 'Sort',
      icon: SvgPicture.asset(
        'assets/svg/Sort Icon.svg',
        colorFilter: ColorFilter.mode(Color(0xFFA3A3A3), BlendMode.srcIn),
      ),
      itemBuilder:
          (context) => List.generate(_dataSort.length, (index) {
            return PopupMenuItem(
              child: Text(_dataSort[index], style: TextStyle(fontSize: 12)),
            );
          }),
      color: Colors.white,
    );
  }

  Widget _buildGroup() {
    return PopupMenuButton(
      tooltip: 'Group',
      icon: SvgPicture.asset(
        'assets/svg/Group Icon.svg',
        colorFilter: ColorFilter.mode(Color(0xFFA3A3A3), BlendMode.srcIn),
        width: 20,
      ),
      itemBuilder:
          (context) => List.generate(_dataGroup.length, (index) {
            return PopupMenuItem(
              child: Text(_dataGroup[index], style: TextStyle(fontSize: 12)),
            );
          }),
      color: Colors.white,
    );
  }
}
